import { db as prisma } from '@/lib/db';
import { NextResponse } from 'next/server';
import { createOnSaleSchema } from '@/schema';

export const POST = async (request: Request) => {
  try {
    const body = await request.json();

    const parsed = createOnSaleSchema.safeParse(body);
    if (!parsed.success) {
      return NextResponse.json(
        { error: parsed.error.errors.map(e => e.message).join(', ') },
        { status: 400 }
      );
    }

    const data = parsed.data;

    const onSaleProduct = await prisma.onSaleProduct.upsert({
      where: {
        productId_transactionId: {
          productId: data.productId,
          transactionId: data.transactionId,
        },
      },
      update: {
        quantity: { increment: data.qTy },
      },
      create: {
        transactionId: data.transactionId,
        productId: data.productId,
        quantity: data.qTy,
      },
    });

    return NextResponse.json(onSaleProduct, { status: 201 });
  } catch (error: any) {
    console.error('POST /api/onsale error:', error);
    return NextResponse.json({ error: 'Internal Server Error' }, { status: 500 });
  }
};
