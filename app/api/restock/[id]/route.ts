import { db as prisma } from '@/lib/db';
import { NextResponse } from 'next/server';
import { restockSingleSchema } from '@/schema';

export const PATCH = async (
  request: Request,
  { params }: { params: { id: string } }
) => {
  try {
    const body = await request.json();

    const parsed = restockSingleSchema.safeParse(body);
    if (!parsed.success) {
      return NextResponse.json(
        { error: parsed.error.errors.map(e => e.message).join(', ') },
        { status: 400 }
      );
    }

    const data = parsed.data;

    const result = await prisma.productStock.update({
      where: { id: String(params.id) },
      data: { stock: { increment: data.stockProduct } },
    });

    return NextResponse.json(result, { status: 200 });
  } catch (error: any) {
    if (error.code === 'P2025') {
      return NextResponse.json({ error: 'Produk tidak ditemukan' }, { status: 404 });
    }
    console.error('PATCH /api/restock/[id] error:', error);
    return NextResponse.json({ error: 'Internal Server Error' }, { status: 500 });
  }
};
