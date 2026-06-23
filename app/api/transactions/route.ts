import { db as prisma } from '@/lib/db';
import { NextResponse } from 'next/server';
import { v4 as uuidv4 } from 'uuid';
import { createTransactionSchema } from '@/schema';

const MAX_ID_RETRIES = 10;

const generateUniqueId = async (): Promise<string> => {
  for (let i = 0; i < MAX_ID_RETRIES; i++) {
    const customId = `TRS-${uuidv4().slice(0, 8)}`;
    const existing = await prisma.transaction.findUnique({ where: { id: customId } });
    if (!existing) return customId;
  }
  return `TRS-${uuidv4().slice(0, 8)}`;
};

const BATCH_SIZE = 100;

export const GET = async (request: Request) => {
  try {
    const { searchParams } = new URL(request.url);
    const limit = Math.min(parseInt(searchParams.get('limit') || '20'), 100);

    const transactions = await prisma.transaction.findMany({
      orderBy: { createdAt: 'desc' },
      take: limit,
      where: { deletedAt: null },
      include: {
        products: {
          include: {
            product: {
              include: { productstock: true }
            }
          }
        },
      }
    });

    const serialized = transactions.map((t) => ({
      ...t,
      totalAmount: t.totalAmount ? Number(t.totalAmount) : 0,
      paymentAmount: t.paymentAmount ? Number(t.paymentAmount) : 0,
      changeAmount: t.changeAmount ? Number(t.changeAmount) : 0,
      discountAmount: t.discountAmount ? Number(t.discountAmount) : 0,
      products: t.products.map((p) => ({
        ...p,
        product: {
          ...p.product,
          sellprice: Number(p.product.sellprice),
          productstock: {
            ...p.product.productstock,
            buyPrice: Number(p.product.productstock.buyPrice),
            sellPrice: Number(p.product.productstock.sellPrice),
          },
        },
      })),
    }));

    return NextResponse.json({ transactions: serialized }, { status: 200 });
  } catch (error: any) {
    console.error('GET /api/transactions error:', error);
    return NextResponse.json({ error: 'Internal Server Error' }, { status: 500 });
  }
};

export const POST = async (request: Request) => {
  try {
    const body = await request.json();

    const parsed = createTransactionSchema.safeParse(body);
    if (!parsed.success) {
      return NextResponse.json(
        { error: parsed.error.errors.map(e => e.message).join(', ') },
        { status: 400 }
      );
    }

    const { items, paymentAmount, changeAmount, discountAmount } = parsed.data;

    const customId = await generateUniqueId();

    const result = await prisma.$transaction(async (tx) => {
      const transaction = await tx.transaction.create({
        data: {
          id: customId,
          totalAmount: 0,
          paymentAmount: Number(paymentAmount || 0),
          changeAmount: Number(changeAmount || 0),
          discountAmount: Number(discountAmount || 0),
          status: 'SUKSES',
          isComplete: true,
        },
      });

      let totalAmount = 0;

      for (let i = 0; i < items.length; i += BATCH_SIZE) {
        const batch = items.slice(i, i + BATCH_SIZE);

        const productIds = batch.map((item: any) => item.id);
        const productStocks = await tx.productStock.findMany({
          where: { id: { in: productIds } },
        });

        const stockMap = new Map(productStocks.map((ps) => [ps.id, ps]));

        const insufficientStockItems: string[] = [];

        const queries = [];

        for (const item of batch) {
          const productStock = stockMap.get(item.id);

          if (!productStock) {
            throw new Error(`Produk dengan id ${item.id} tidak ditemukan`);
          }

          if (productStock.stock < item.quantity) {
            insufficientStockItems.push(productStock.name);
            continue;
          }

          const serverPrice = Number(productStock.sellPrice);
          totalAmount += serverPrice * item.quantity;

          queries.push(
            tx.productStock.updateMany({
              where: {
                id: item.id,
                stock: { gte: item.quantity },
              },
              data: {
                stock: { decrement: item.quantity },
              },
            })
          );

          queries.push(
            tx.product.upsert({
              where: { productId: item.id },
              update: {},
              create: {
                productId: item.id,
                sellprice: productStock.sellPrice,
              },
            })
          );

          queries.push(
            tx.onSaleProduct.create({
              data: {
                productId: item.id,
                quantity: item.quantity,
                transactionId: transaction.id,
              },
            })
          );
        }

        if (insufficientStockItems.length > 0) {
          throw new Error(`Stok tidak mencukupi untuk: ${insufficientStockItems.join(', ')}`);
        }

        await Promise.all(queries);
      }

      const finalDiscount = Number(discountAmount || 0);
      const finalTotal = Math.max(0, totalAmount - finalDiscount);

      return tx.transaction.update({
        where: { id: transaction.id },
        data: { totalAmount: finalTotal },
      });
    }, { timeout: 30000, maxWait: 15000 });

    const serialized = {
      ...result,
      totalAmount: result.totalAmount ? Number(result.totalAmount) : 0,
      paymentAmount: result.paymentAmount ? Number(result.paymentAmount) : 0,
      changeAmount: result.changeAmount ? Number(result.changeAmount) : 0,
      discountAmount: result.discountAmount ? Number(result.discountAmount) : 0,
    };

    return NextResponse.json(serialized, { status: 201 });
  } catch (error: any) {
    console.error('POST /api/transactions error:', error);
    return NextResponse.json({ error: error.message }, { status: 500 });
  }
};
