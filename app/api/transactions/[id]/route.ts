import { NextRequest, NextResponse } from 'next/server';
import { db as prisma } from '@/lib/db';
import { updateTransactionSchema } from '@/schema';

function serializeTransaction(t: any) {
  return {
    ...t,
    totalAmount: t.totalAmount ? Number(t.totalAmount) : 0,
    paymentAmount: t.paymentAmount ? Number(t.paymentAmount) : 0,
    changeAmount: t.changeAmount ? Number(t.changeAmount) : 0,
    discountAmount: t.discountAmount ? Number(t.discountAmount) : 0,
    products: t.products?.map((p: any) => ({
      ...p,
      product: {
        ...p.product,
        sellprice: Number(p.product?.sellprice || 0),
        productstock: p.product?.productstock ? {
          ...p.product.productstock,
          buyPrice: Number(p.product.productstock.buyPrice || 0),
          sellPrice: Number(p.product.productstock.sellPrice || 0),
        } : undefined,
      },
    })) || [],
  };
}

export async function GET(
  req: NextRequest,
  { params }: { params: { id: string } }
) {
  const { id } = params;

  try {
    const transaction = await prisma.transaction.findUnique({
      where: { id, deletedAt: null },
      include: {
        products: {
          include: {
            product: {
              include: { productstock: true },
            },
          },
          orderBy: {
            product: { productstock: { name: 'asc' } },
          },
        },
      },
    });

    if (!transaction) {
      return NextResponse.json({ error: 'Transaction not found' }, { status: 404 });
    }

    return NextResponse.json(serializeTransaction(transaction), { status: 200 });
  } catch (error) {
    console.error('GET /api/transactions/[id] error:', error);
    return NextResponse.json({ error: 'Internal Server Error' }, { status: 500 });
  }
}

export const PATCH = async (
  request: Request,
  { params }: { params: { id: string } }
) => {
  try {
    const { id } = params;
    const body = await request.json();

    const parsed = updateTransactionSchema.safeParse(body);
    if (!parsed.success) {
      return NextResponse.json(
        { error: parsed.error.errors.map(e => e.message).join(', ') },
        { status: 400 }
      );
    }

    const { status } = parsed.data;

    if (status === 'RETUR') {
      const result = await prisma.$transaction(async (tx) => {
        const transaction = await tx.transaction.findUnique({
          where: { id, deletedAt: null },
          include: {
            products: { include: { product: true } }
          }
        });

        if (!transaction) throw new Error('Transaksi tidak ditemukan');
        if (transaction.status === 'RETUR') throw new Error('Transaksi sudah dikembalikan');

        for (const item of transaction.products) {
          await tx.productStock.update({
            where: { id: item.productId },
            data: { stock: { increment: item.quantity } }
          });
        }

        return await tx.transaction.update({
          where: { id },
          data: { status: 'RETUR' }
        });
      });

      return NextResponse.json(serializeTransaction(result), { status: 200 });
    }

    const updateData: any = {};
    if (body.totalAmount !== undefined) updateData.totalAmount = body.totalAmount;
    if (body.isComplete !== undefined) updateData.isComplete = body.isComplete;

    const updatedTransaction = await prisma.transaction.update({
      where: { id },
      data: updateData,
    });

    return NextResponse.json(serializeTransaction(updatedTransaction), { status: 200 });
  } catch (error: any) {
    console.error('PATCH /api/transactions/[id] error:', error);
    return NextResponse.json({ error: error.message }, { status: 500 });
  }
};

export const DELETE = async (
  request: Request,
  { params }: { params: { id: string } }
) => {
  try {
    const { id } = params;

    const result = await prisma.$transaction(async (tx) => {
      const transaction = await tx.transaction.findUnique({
        where: { id, deletedAt: null },
        include: { products: true },
      });

      if (!transaction) {
        throw new Error('Transaction not found');
      }

      for (const item of transaction.products) {
        await tx.productStock.update({
          where: { id: item.productId },
          data: { stock: { increment: item.quantity } },
        });
      }

      return await tx.transaction.update({
        where: { id },
        data: { deletedAt: new Date() },
      });
    });

    return NextResponse.json(serializeTransaction(result), { status: 200 });
  } catch (error: any) {
    if (error.code === 'P2025') {
      return NextResponse.json({ error: 'Transaction not found' }, { status: 404 });
    }

    console.error('DELETE /api/transactions/[id] error:', error);
    return NextResponse.json({ error: 'Internal Server Error' }, { status: 500 });
  }
};
