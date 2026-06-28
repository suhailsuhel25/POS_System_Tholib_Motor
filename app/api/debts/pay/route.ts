import { db as prisma } from '@/lib/db';
import { NextResponse } from 'next/server';
import { z } from 'zod';

const paySchema = z.object({
  bengkelId: z.string().min(1, 'ID bengkel wajib diisi'),
  debtIds: z.array(z.string()).min(1, 'Pilih minimal 1 hutang untuk dibayar'),
  discount: z.number().min(0).default(0),
  notes: z.string().optional(),
});

// POST — bayar hutang sekaligus (bisa pilih beberapa, bisa beri diskon)
export const POST = async (request: Request) => {
  try {
    const body = await request.json();
    const parsed = paySchema.safeParse(body);

    if (!parsed.success) {
      return NextResponse.json(
        { error: parsed.error.errors.map((e) => e.message).join(', ') },
        { status: 400 }
      );
    }

    const { bengkelId, debtIds, discount, notes } = parsed.data;

    // Validasi bengkel ada
    const bengkel = await prisma.bengkel.findUnique({ where: { id: bengkelId } });
    if (!bengkel) {
      return NextResponse.json({ error: 'Bengkel tidak ditemukan' }, { status: 404 });
    }

    // Ambil semua hutang yang dipilih dan pastikan belum lunas
    const debts = await prisma.debt.findMany({
      where: {
        id: { in: debtIds },
        bengkelId,
        isPaid: false,
      },
    });

    if (debts.length === 0) {
      return NextResponse.json({ error: 'Tidak ada hutang valid yang bisa dibayar' }, { status: 400 });
    }

    const totalBeforeDiscount = debts.reduce((sum, d) => sum + Number(d.amount), 0);
    const totalPaid = Math.max(0, totalBeforeDiscount - discount);

    const now = new Date();

    // Jalankan dalam transaction DB
    const result = await prisma.$transaction(async (tx) => {
      // 1. Tandai semua hutang sebagai lunas
      await tx.debt.updateMany({
        where: { id: { in: debts.map((d) => d.id) } },
        data: { isPaid: true, paidAt: now },
      });

      // 2. Update status transaksi terkait ke SUKSES
      await tx.transaction.updateMany({
        where: { id: { in: debts.map((d) => d.transactionId) } },
        data: { status: 'SUKSES' },
      });

      // 3. Buat record DebtPayment
      const payment = await tx.debtPayment.create({
        data: {
          bengkelId,
          totalPaid,
          discount,
          notes: notes || null,
          debtItems: {
            create: debts.map((d) => ({ debtId: d.id })),
          },
        },
        include: { debtItems: true },
      });

      // 4. Catat sebagai pemasukan (Expense kategori PIUTANG_MASUK)
      await tx.expense.create({
        data: {
          description: `Pembayaran hutang ${bengkel.name}`,
          amount: totalPaid,
          category: 'PIUTANG_MASUK',
          notes: notes || `Melunasi ${debts.length} transaksi hutang`,
        },
      });

      // 5. Update nextPaymentAt bengkel berdasarkan paymentCycle
      const nextPaymentAt = new Date(now);
      nextPaymentAt.setDate(nextPaymentAt.getDate() + bengkel.paymentCycle);
      await tx.bengkel.update({
        where: { id: bengkelId },
        data: { nextPaymentAt },
      });

      return payment;
    });

    return NextResponse.json({
      payment: {
        ...result,
        totalPaid: Number(result.totalPaid),
        discount: Number(result.discount),
      },
      paidCount: debts.length,
      totalPaid,
      discount,
    }, { status: 201 });
  } catch (error: any) {
    console.error('POST /api/debts/pay error:', error);
    return NextResponse.json({ error: error.message || 'Internal Server Error' }, { status: 500 });
  }
};
