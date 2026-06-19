import { db as prisma } from '@/lib/db';
import { NextResponse } from 'next/server';

export const PATCH = async (
  request: Request,
  { params }: { params: { id: string } }
) => {
  try {
    const body = await request.json();
    const { isPaid } = body;

    if (typeof isPaid !== 'boolean') {
      return NextResponse.json({ error: 'isPaid harus boolean' }, { status: 400 });
    }

    const existingDebt = await prisma.debt.findUnique({
      where: { id: params.id },
    });

    if (!existingDebt) {
      return NextResponse.json({ error: 'Hutang tidak ditemukan' }, { status: 404 });
    }

    const updateData: any = { isPaid };
    if (isPaid) {
      updateData.paidAt = new Date();
    } else {
      updateData.paidAt = null;
    }

    const debt = await prisma.debt.update({
      where: { id: params.id },
      data: updateData,
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

    // Sync transaction status with debt status
    if (isPaid) {
      await prisma.transaction.update({
        where: { id: existingDebt.transactionId },
        data: { status: 'SUKSES' },
      });
    } else {
      await prisma.transaction.update({
        where: { id: existingDebt.transactionId },
        data: { status: 'HUTANG' },
      });
    }

    return NextResponse.json({
      ...debt,
      amount: Number(debt.amount),
      transaction: {
        ...debt.transaction,
        totalAmount: debt.transaction.totalAmount ? Number(debt.transaction.totalAmount) : 0,
      },
    }, { status: 200 });
  } catch (error: any) {
    console.error('PATCH /api/debts/[id] error:', error);
    return NextResponse.json({ error: 'Internal Server Error' }, { status: 500 });
  }
};

export const DELETE = async (
  request: Request,
  { params }: { params: { id: string } }
) => {
  try {
    const existingDebt = await prisma.debt.findUnique({
      where: { id: params.id },
    });

    if (!existingDebt) {
      return NextResponse.json({ error: 'Hutang tidak ditemukan' }, { status: 404 });
    }

    // Reset transaction status to SUKSES
    await prisma.transaction.update({
      where: { id: existingDebt.transactionId },
      data: { status: 'SUKSES' },
    });

    await prisma.debt.delete({
      where: { id: params.id },
    });

    return NextResponse.json({ message: 'Hutang berhasil dihapus' }, { status: 200 });
  } catch (error: any) {
    console.error('DELETE /api/debts/[id] error:', error);
    return NextResponse.json({ error: 'Internal Server Error' }, { status: 500 });
  }
};
