import { db as prisma } from '@/lib/db';
import { NextResponse } from 'next/server';
import { z } from 'zod';

const createExpenseSchema = z.object({
  description: z.string().min(1, 'Deskripsi wajib diisi'),
  amount: z.number().positive('Jumlah harus lebih dari 0'),
  category: z.enum(['RESTOK', 'OPERASIONAL', 'GAJI', 'LAINNYA']).default('LAINNYA'),
  notes: z.string().optional(),
});

export const GET = async (request: Request) => {
  try {
    const { searchParams } = new URL(request.url);
    const category = searchParams.get('category');
    const startDate = searchParams.get('start');
    const endDate = searchParams.get('end');

    const where: any = {};

    if (category && category !== 'ALL') {
      where.category = category;
    } else {
      where.category = { not: 'PIUTANG_MASUK' };
    }

    if (startDate && endDate) {
      where.createdAt = {
        gte: new Date(startDate),
        lte: new Date(new Date(endDate).setUTCHours(23, 59, 59, 999)),
      };
    }

    const expenses = await prisma.expense.findMany({
      where,
      orderBy: { createdAt: 'desc' },
    });

    const serialized = expenses.map((e) => ({
      ...e,
      amount: Number(e.amount),
    }));

    // Calculate total
    const total = serialized.reduce((sum, e) => sum + e.amount, 0);

    return NextResponse.json({ expenses: serialized, total }, { status: 200 });
  } catch (error: any) {
    console.error('GET /api/expenses error:', error);
    return NextResponse.json({ error: 'Internal Server Error' }, { status: 500 });
  }
};

export const POST = async (request: Request) => {
  try {
    const body = await request.json();
    const parsed = createExpenseSchema.safeParse(body);

    if (!parsed.success) {
      return NextResponse.json(
        { error: parsed.error.errors.map(e => e.message).join(', ') },
        { status: 400 }
      );
    }

    const { description, amount, category, notes } = parsed.data;

    const expense = await prisma.expense.create({
      data: {
        description,
        amount,
        category,
        notes,
      },
    });

    return NextResponse.json({
      ...expense,
      amount: Number(expense.amount),
    }, { status: 201 });
  } catch (error: any) {
    console.error('POST /api/expenses error:', error);
    return NextResponse.json({ error: 'Internal Server Error' }, { status: 500 });
  }
};
