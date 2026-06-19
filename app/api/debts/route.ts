import { db as prisma } from '@/lib/db';
import { NextResponse } from 'next/server';
import { z } from 'zod';

const createDebtSchema = z.object({
  customerName: z.string().min(1, 'Nama pelanggan wajib diisi'),
  amount: z.number().positive('Jumlah hutang harus lebih dari 0'),
  transactionId: z.string().min(1, 'ID transaksi wajib diisi'),
  notes: z.string().optional(),
});

export const GET = async (request: Request) => {
  try {
    const { searchParams } = new URL(request.url);
    const status = searchParams.get('status'); // 'paid', 'unpaid', or null for all

    const where: any = {};
    if (status === 'paid') {
      where.isPaid = true;
    } else if (status === 'unpaid') {
      where.isPaid = false;
    }

    const debts = await prisma.debt.findMany({
      where,
      include: {
        transaction: {
          select: {
            id: true,
            totalAmount: true,
            createdAt: true,
          },
        },
      },
      orderBy: { createdAt: 'desc' },
    });

    const serialized = debts.map((d) => ({
      ...d,
      amount: Number(d.amount),
      transaction: {
        ...d.transaction,
        totalAmount: d.transaction.totalAmount ? Number(d.transaction.totalAmount) : 0,
      },
    }));

    return NextResponse.json({ debts: serialized }, { status: 200 });
  } catch (error: any) {
    console.error('GET /api/debts error:', error);
    return NextResponse.json({ error: 'Internal Server Error' }, { status: 500 });
  }
};

export const POST = async (request: Request) => {
  try {
    const body = await request.json();
    const parsed = createDebtSchema.safeParse(body);

    if (!parsed.success) {
      return NextResponse.json(
        { error: parsed.error.errors.map(e => e.message).join(', ') },
        { status: 400 }
      );
    }

    const { customerName, amount, transactionId, notes } = parsed.data;

    // Check if transaction exists
    const transaction = await prisma.transaction.findUnique({
      where: { id: transactionId },
    });

    if (!transaction) {
      return NextResponse.json({ error: 'Transaksi tidak ditemukan' }, { status: 404 });
    }

    // Check if debt already exists for this transaction
    const existingDebt = await prisma.debt.findUnique({
      where: { transactionId },
    });

    if (existingDebt) {
      return NextResponse.json({ error: 'Transaksi ini sudah memiliki catatan hutang' }, { status: 400 });
    }

    const debt = await prisma.debt.create({
      data: {
        customerName,
        amount: amount,
        transactionId,
        notes: notes || null,
      },
      include: {
        transaction: {
          select: {
            id: true,
            totalAmount: true,
            createdAt: true,
          },
        },
      },
    });

    // Update transaction status to HUTANG
    await prisma.transaction.update({
      where: { id: transactionId },
      data: { status: 'HUTANG' },
    });

    return NextResponse.json({
      ...debt,
      amount: Number(debt.amount),
      transaction: {
        ...debt.transaction,
        totalAmount: debt.transaction.totalAmount ? Number(debt.transaction.totalAmount) : 0,
      },
    }, { status: 201 });
  } catch (error: any) {
    console.error('POST /api/debts error:', error);
    return NextResponse.json({ error: error.message || 'Internal Server Error' }, { status: 500 });
  }
};
