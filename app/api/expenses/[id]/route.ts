import { db as prisma } from '@/lib/db';
import { NextResponse } from 'next/server';

export const PATCH = async (
  request: Request,
  { params }: { params: { id: string } }
) => {
  try {
    const body = await request.json();
    const { description, amount, category, notes } = body;

    const existing = await prisma.expense.findUnique({
      where: { id: params.id },
    });

    if (!existing) {
      return NextResponse.json({ error: 'Pengeluaran tidak ditemukan' }, { status: 404 });
    }

    const updateData: any = {};
    if (description !== undefined) updateData.description = description;
    if (amount !== undefined) updateData.amount = amount;
    if (category !== undefined) updateData.category = category;
    if (notes !== undefined) updateData.notes = notes;

    const expense = await prisma.expense.update({
      where: { id: params.id },
      data: updateData,
    });

    return NextResponse.json({
      ...expense,
      amount: Number(expense.amount),
    }, { status: 200 });
  } catch (error: any) {
    console.error('PATCH /api/expenses/[id] error:', error);
    return NextResponse.json({ error: 'Internal Server Error' }, { status: 500 });
  }
};

export const DELETE = async (
  request: Request,
  { params }: { params: { id: string } }
) => {
  try {
    const existing = await prisma.expense.findUnique({
      where: { id: params.id },
    });

    if (!existing) {
      return NextResponse.json({ error: 'Pengeluaran tidak ditemukan' }, { status: 404 });
    }

    await prisma.expense.delete({
      where: { id: params.id },
    });

    return NextResponse.json({ message: 'Pengeluaran berhasil dihapus' }, { status: 200 });
  } catch (error: any) {
    console.error('DELETE /api/expenses/[id] error:', error);
    return NextResponse.json({ error: 'Internal Server Error' }, { status: 500 });
  }
};
