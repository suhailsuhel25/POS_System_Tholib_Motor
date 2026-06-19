import { NextResponse } from 'next/server';
import { db as prisma } from '@/lib/db';
import { updateOnSaleSchema } from '@/schema';

export const PATCH = async (
  request: Request,
  { params }: { params: { id: string } }
) => {
  try {
    const body = await request.json();

    const parsed = updateOnSaleSchema.safeParse(body);
    if (!parsed.success) {
      return NextResponse.json(
        { error: parsed.error.errors.map(e => e.message).join(', ') },
        { status: 400 }
      );
    }

    const data = parsed.data;

    const editedOrderProduct = await prisma.onSaleProduct.update({
      where: { id: String(params.id) },
      data: { quantity: data.qTy },
    });

    return NextResponse.json(editedOrderProduct, { status: 200 });
  } catch (error: any) {
    if (error.code === 'P2025') {
      return NextResponse.json({ error: 'Item tidak ditemukan' }, { status: 404 });
    }
    console.error('PATCH /api/onsale/[id] error:', error);
    return NextResponse.json({ error: 'Internal Server Error' }, { status: 500 });
  }
};

export const DELETE = async (
  request: Request,
  { params }: { params: { id: string } }
) => {
  try {
    const deletedOrderProduct = await prisma.onSaleProduct.delete({
      where: { id: String(params.id) },
    });

    return NextResponse.json(deletedOrderProduct, { status: 200 });
  } catch (error: any) {
    if (error.code === 'P2025') {
      return NextResponse.json({ error: 'Item tidak ditemukan' }, { status: 404 });
    }
    console.error('DELETE /api/onsale/[id] error:', error);
    return NextResponse.json({ error: 'Internal Server Error' }, { status: 500 });
  }
};
