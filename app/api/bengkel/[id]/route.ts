import { db as prisma } from '@/lib/db';
import { NextResponse } from 'next/server';
import { z } from 'zod';

const updateBengkelSchema = z.object({
  name: z.string().min(1).optional(),
  phone: z.string().optional().nullable(),
  address: z.string().optional().nullable(),
  notes: z.string().optional().nullable(),
  paymentCycle: z.number().int().min(1).optional(),
  nextPaymentAt: z.string().datetime().optional().nullable(),
});

// PATCH — edit data bengkel
export const PATCH = async (
  request: Request,
  { params }: { params: { id: string } }
) => {
  try {
    const body = await request.json();
    const parsed = updateBengkelSchema.safeParse(body);

    if (!parsed.success) {
      return NextResponse.json(
        { error: parsed.error.errors.map((e) => e.message).join(', ') },
        { status: 400 }
      );
    }

    const existing = await prisma.bengkel.findUnique({ where: { id: params.id } });
    if (!existing) {
      return NextResponse.json({ error: 'Bengkel tidak ditemukan' }, { status: 404 });
    }

    const data: any = { ...parsed.data };
    if (parsed.data.nextPaymentAt !== undefined) {
      data.nextPaymentAt = parsed.data.nextPaymentAt ? new Date(parsed.data.nextPaymentAt) : null;
    }

    const bengkel = await prisma.bengkel.update({
      where: { id: params.id },
      data,
    });

    return NextResponse.json(bengkel, { status: 200 });
  } catch (error: any) {
    if (error.code === 'P2002') {
      return NextResponse.json({ error: 'Nama bengkel sudah digunakan' }, { status: 400 });
    }
    console.error('PATCH /api/bengkel/[id] error:', error);
    return NextResponse.json({ error: 'Internal Server Error' }, { status: 500 });
  }
};

// DELETE — hapus bengkel (diblokir jika masih ada hutang belum lunas)
export const DELETE = async (
  _request: Request,
  { params }: { params: { id: string } }
) => {
  try {
    const existing = await prisma.bengkel.findUnique({
      where: { id: params.id },
      include: {
        debts: { where: { isPaid: false }, select: { id: true } },
      },
    });

    if (!existing) {
      return NextResponse.json({ error: 'Bengkel tidak ditemukan' }, { status: 404 });
    }

    if (existing.debts.length > 0) {
      return NextResponse.json(
        { error: `Bengkel masih memiliki ${existing.debts.length} hutang yang belum lunas. Lunasi semua hutang terlebih dahulu sebelum menghapus.` },
        { status: 400 }
      );
    }

    await prisma.bengkel.delete({ where: { id: params.id } });

    return NextResponse.json({ message: 'Bengkel berhasil dihapus' }, { status: 200 });
  } catch (error: any) {
    console.error('DELETE /api/bengkel/[id] error:', error);
    return NextResponse.json({ error: 'Internal Server Error' }, { status: 500 });
  }
};
