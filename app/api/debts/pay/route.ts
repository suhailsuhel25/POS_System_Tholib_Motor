import { db as prisma } from '@/lib/db';
import { NextResponse } from 'next/server';
import { z } from 'zod';

const paySchema = z.object({
  bengkelId: z.string().min(1, 'ID bengkel wajib diisi'),
  debtIds: z.array(z.string()).min(1, 'Pilih minimal 1 hutang untuk dibayar'),
  discountPercent: z.number().min(0).max(100).default(0),
  customAmount: z.number().min(0).optional(), // Untuk bayar sebagian (nullable = lunas)
  notes: z.string().optional(),
});

/**
 * Hitung total yang sudah dibayarkan untuk satu hutang
 * dengan menjumlahkan semua DebtPayment yang terhubung via DebtPaymentItem
 */
async function getTotalPaidForDebt(
  tx: any,
  debtId: string
): Promise<number> {
  const items = await tx.debtPaymentItem.findMany({
    where: { debtId },
    include: {
      payment: {
        select: {
          totalPaid: true,
          discount: true,
          debtItems: { select: { debtId: true } },
        },
      },
    },
  });

  let totalPaid = 0;
  for (const item of items) {
    const debtCount = item.payment.debtItems.length;
    // Jika payment hanya mencakup 1 hutang, atribusikan seluruh totalPaid + discount ke hutang ini
    // Jika mencakup banyak hutang, bagi rata (proporsional bisa ditambah nanti)
    const paymentTotal = Number(item.payment.totalPaid) + Number(item.payment.discount);
    totalPaid += paymentTotal / debtCount;
  }
  return totalPaid;
}

// POST — bayar hutang sekaligus (bisa pilih beberapa, bisa beri diskon %, bisa bayar sebagian)
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

    const { bengkelId, debtIds, discountPercent, customAmount, notes } = parsed.data;

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
    const discountAmount = Math.round(totalBeforeDiscount * discountPercent / 100);
    const totalAfterDiscount = Math.max(0, totalBeforeDiscount - discountAmount);

    // Tentukan mode: lunas langsung atau bayar sebagian
    const isPartialRequest = customAmount !== undefined && customAmount < totalAfterDiscount;
    const totalPaid = isPartialRequest ? customAmount : totalAfterDiscount;

    const now = new Date();

    // Jalankan dalam transaction DB
    const result = await prisma.$transaction(async (tx) => {
      // 1. Buat record DebtPayment terlebih dahulu
      const payment = await tx.debtPayment.create({
        data: {
          bengkelId,
          totalPaid,
          discount: discountAmount,
          notes: notes || (isPartialRequest ? `Pembayaran sebagian (cicilan)` : null),
          debtItems: {
            create: debts.map((d) => ({ debtId: d.id })),
          },
        },
        include: { debtItems: true },
      });

      // 2. Cek apakah masing-masing hutang sudah lunas secara akumulatif
      //    (termasuk cicilan-cicilan sebelumnya + pembayaran sekarang)
      const debtsToMarkPaid: string[] = [];
      const txToMarkSukses: string[] = [];

      if (!isPartialRequest) {
        // Mode LUNAS: langsung tandai semua hutang sebagai lunas
        debtsToMarkPaid.push(...debts.map((d) => d.id));
        txToMarkSukses.push(...debts.map((d) => d.transactionId));
      } else {
        // Mode SEBAGIAN: cek akumulasi per hutang
        for (const debt of debts) {
          const cumulativePaid = await getTotalPaidForDebt(tx, debt.id);
          const debtAmount = Number(debt.amount);

          if (cumulativePaid >= debtAmount) {
            // Akumulasi cicilan sudah >= hutang → tandai LUNAS otomatis
            debtsToMarkPaid.push(debt.id);
            txToMarkSukses.push(debt.transactionId);
          }
        }
      }

      // 3. Tandai hutang yang sudah lunas (baik dari mode lunas maupun akumulasi cicilan)
      if (debtsToMarkPaid.length > 0) {
        await tx.debt.updateMany({
          where: { id: { in: debtsToMarkPaid } },
          data: { isPaid: true, paidAt: now },
        });

        await tx.transaction.updateMany({
          where: { id: { in: txToMarkSukses } },
          data: { status: 'SUKSES' },
        });
      }

      // 4. Catat sebagai pemasukan (Expense kategori PIUTANG_MASUK)
      if (totalPaid > 0) {
        const isFullyPaid = debtsToMarkPaid.length === debts.length;
        await tx.expense.create({
          data: {
            description: `Pembayaran hutang ${bengkel.name}${!isFullyPaid ? ' (cicilan)' : ''}`,
            amount: totalPaid,
            category: 'PIUTANG_MASUK',
            notes: notes || `${isFullyPaid ? 'Melunasi' : 'Cicilan'} ${debts.length} transaksi hutang`,
          },
        });
      }

      // 5. Update nextPaymentAt bengkel berdasarkan paymentCycle
      const nextPaymentAt = new Date(now);
      nextPaymentAt.setDate(nextPaymentAt.getDate() + bengkel.paymentCycle);
      await tx.bengkel.update({
        where: { id: bengkelId },
        data: { nextPaymentAt },
      });

      return { payment, debtsMarkedPaid: debtsToMarkPaid.length };
    });

    return NextResponse.json({
      payment: {
        ...result.payment,
        totalPaid: Number(result.payment.totalPaid),
        discount: Number(result.payment.discount),
      },
      paidCount: debts.length,
      totalPaid,
      discountAmount,
      discountPercent,
      isPartial: isPartialRequest,
      debtsAutoMarkedPaid: result.debtsMarkedPaid,
    }, { status: 201 });
  } catch (error: any) {
    console.error('POST /api/debts/pay error:', error);
    return NextResponse.json({ error: error.message || 'Internal Server Error' }, { status: 500 });
  }
};
