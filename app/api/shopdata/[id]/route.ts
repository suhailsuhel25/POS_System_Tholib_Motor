import { db as prisma } from '@/lib/db';
import { NextResponse } from 'next/server';
import { updateShopDataSchema } from '@/schema';

export const PATCH = async (
  request: Request,
  { params }: { params: { id: string } }
) => {
  try {
    const body = await request.json();

    const parsed = updateShopDataSchema.safeParse(body);
    if (!parsed.success) {
      return NextResponse.json(
        { error: parsed.error.errors.map(e => e.message).join(', ') },
        { status: 400 }
      );
    }

    const data = parsed.data;

    const updatedStorename = await prisma.shopData.update({
      where: { id: String(params.id) },
      data: { name: data.storeName },
    });
    return NextResponse.json(updatedStorename, { status: 200 });
  } catch (error: any) {
    if (error.code === 'P2025') {
      return NextResponse.json({ error: 'Data toko tidak ditemukan' }, { status: 404 });
    }
    console.error('PATCH /api/shopdata/[id] error:', error);
    return NextResponse.json({ error: 'Internal Server Error' }, { status: 500 });
  }
};
