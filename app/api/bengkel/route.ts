import { db as prisma } from '@/lib/db';
import { NextResponse } from 'next/server';
import { z } from 'zod';

const createBengkelSchema = z.object({
  name: z.string().min(1, 'Nama bengkel wajib diisi'),
  phone: z.string().optional(),
  address: z.string().optional(),
  notes: z.string().optional(),
  paymentCycle: z.number().int().min(1).default(7),
});

// GET — daftar semua bengkel + total hutang & jumlah transaksi
export const GET = async () => {
  try {
    const bengkels = await prisma.bengkel.findMany({
      include: {
        debts: {
          select: {
            id: true,
            amount: true,
            isPaid: true,
          },
        },
      },
      orderBy: { name: 'asc' },
    });

    const serialized = bengkels.map((b) => {
      const unpaidDebts = b.debts.filter((d) => !d.isPaid);
      const totalUnpaid = unpaidDebts.reduce((sum, d) => sum + Number(d.amount), 0);
      return {
        id: b.id,
        name: b.name,
        phone: b.phone,
        address: b.address,
        notes: b.notes,
        paymentCycle: b.paymentCycle,
        nextPaymentAt: b.nextPaymentAt,
        createdAt: b.createdAt,
        updatedAt: b.updatedAt,
        totalUnpaid,
        unpaidCount: unpaidDebts.length,
        totalDebtCount: b.debts.length,
      };
    });

    return NextResponse.json({ bengkels: serialized }, { status: 200 });
  } catch (error: any) {
    console.error('GET /api/bengkel error:', error);
    return NextResponse.json({ error: 'Internal Server Error' }, { status: 500 });
  }
};

// POST — tambah bengkel baru
export const POST = async (request: Request) => {
  try {
    const body = await request.json();
    const parsed = createBengkelSchema.safeParse(body);

    if (!parsed.success) {
      return NextResponse.json(
        { error: parsed.error.errors.map((e) => e.message).join(', ') },
        { status: 400 }
      );
    }

    const { name, phone, address, notes, paymentCycle } = parsed.data;

    const bengkel = await prisma.bengkel.create({
      data: { name, phone, address, notes, paymentCycle },
    });

    return NextResponse.json(bengkel, { status: 201 });
  } catch (error: any) {
    if (error.code === 'P2002') {
      return NextResponse.json({ error: 'Nama bengkel sudah terdaftar' }, { status: 400 });
    }
    console.error('POST /api/bengkel error:', error);
    return NextResponse.json({ error: 'Internal Server Error' }, { status: 500 });
  }
};
