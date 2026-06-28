import { db as prisma } from '@/lib/db';
import { NextResponse } from 'next/server';

// GET — semua hutang milik 1 bengkel (unpaid + paid + riwayat pembayaran)
export const GET = async (
  request: Request,
  { params }: { params: { id: string } }
) => {
  try {
    const { searchParams } = new URL(request.url);
    const status = searchParams.get('status'); // 'unpaid' | 'paid' | null (all)

    const bengkel = await prisma.bengkel.findUnique({
      where: { id: params.id },
    });

    if (!bengkel) {
      return NextResponse.json({ error: 'Bengkel tidak ditemukan' }, { status: 404 });
    }

    const where: any = { bengkelId: params.id };
    if (status === 'unpaid') where.isPaid = false;
    if (status === 'paid') where.isPaid = true;

    const debts = await prisma.debt.findMany({
      where,
      include: {
        transaction: {
          select: { id: true, totalAmount: true, createdAt: true, products: {
            include: {
              product: { include: { productstock: { select: { name: true, brand: true } } } }
            }
          }},
        },
      },
      orderBy: { createdAt: 'desc' },
    });

    const payments = await prisma.debtPayment.findMany({
      where: { bengkelId: params.id },
      include: {
        debtItems: {
          include: { debt: { select: { id: true, amount: true, createdAt: true } } },
        },
      },
      orderBy: { createdAt: 'desc' },
    });

    const serializedDebts = debts.map((d) => ({
      ...d,
      amount: Number(d.amount),
      transaction: {
        ...d.transaction,
        totalAmount: d.transaction.totalAmount ? Number(d.transaction.totalAmount) : 0,
      },
    }));

    const serializedPayments = payments.map((p) => ({
      ...p,
      totalPaid: Number(p.totalPaid),
      discount: Number(p.discount),
      debtItems: p.debtItems.map((item) => ({
        ...item,
        debt: { ...item.debt, amount: Number(item.debt.amount) },
      })),
    }));

    // summary stats
    const unpaidDebts = debts.filter((d) => !d.isPaid);
    const totalUnpaid = unpaidDebts.reduce((sum, d) => sum + Number(d.amount), 0);

    return NextResponse.json({
      bengkel,
      debts: serializedDebts,
      payments: serializedPayments,
      summary: {
        totalUnpaid,
        unpaidCount: unpaidDebts.length,
        totalDebtCount: debts.length,
      },
    }, { status: 200 });
  } catch (error: any) {
    console.error('GET /api/bengkel/[id]/debts error:', error);
    return NextResponse.json({ error: 'Internal Server Error' }, { status: 500 });
  }
};
