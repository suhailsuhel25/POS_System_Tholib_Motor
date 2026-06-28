const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

async function main() {
  console.log('=== TESTING B2B DEBT FLOW ===');

  try {
    // 1. Create a Test Bengkel
    console.log('\n[Step 1] Creating a test Bengkel...');
    const testBengkelName = `Bengkel Test - ${Date.now()}`;
    const bengkel = await prisma.bengkel.create({
      data: {
        name: testBengkelName,
        phone: '081234567890',
        address: 'Jl. Testing No. 123',
        notes: 'Created by automated test flow script',
        paymentCycle: 7, // 7 days cycle
      },
    });
    console.log(`✅ Bengkel created: "${bengkel.name}" (ID: ${bengkel.id})`);

    // 2. Fetch a Product to use in Transaction
    console.log('\n[Step 2] Fetching a product for transaction...');
    const product = await prisma.productStock.findFirst();
    if (!product) {
      console.log('❌ No products found in database to simulate transaction. Please add a product first.');
      return;
    }
    console.log(`✅ Using product: "${product.name}" (Price: Rp${product.sellPrice}, Available Stock: ${product.stock})`);

    // 3. Create a Transaction of status HUTANG
    console.log('\n[Step 3] Creating a Transaction...');
    const transactionId = `TRS-TEST-${Math.floor(Math.random() * 100000)}`;
    const totalAmount = Number(product.sellPrice) * 1; // 1 item
    const transaction = await prisma.transaction.create({
      data: {
        id: transactionId,
        totalAmount: totalAmount,
        paymentAmount: 0, // No payment yet
        changeAmount: 0,
        discountAmount: 0,
        status: 'HUTANG',
        isComplete: true,
      },
    });
    console.log(`✅ Transaction created: "${transaction.id}" (Total Amount: Rp${transaction.totalAmount})`);

    // 4. Create the associated Debt linking the Transaction to the Bengkel
    console.log('\n[Step 4] Creating Debt record linking Transaction to Bengkel...');
    const debt = await prisma.debt.create({
      data: {
        bengkelId: bengkel.id,
        amount: totalAmount,
        transactionId: transaction.id,
        notes: 'Hutang dari transaksi test-flow.js',
      },
    });
    console.log(`✅ Debt record created (ID: ${debt.id}) with amount Rp${debt.amount}`);

    // 5. Query the Bengkel's total unpaid debt to verify it updated
    console.log('\n[Step 5] Checking workshop unpaid debt summary...');
    const bengkels = await prisma.bengkel.findUnique({
      where: { id: bengkel.id },
      include: { debts: true },
    });
    const unpaidDebts = bengkels.debts.filter(d => !d.isPaid);
    const totalUnpaid = unpaidDebts.reduce((sum, d) => sum + Number(d.amount), 0);
    console.log(`📊 Summary for "${bengkels.name}":`);
    console.log(`   - Unpaid transaction count: ${unpaidDebts.length}`);
    console.log(`   - Total unpaid amount: Rp${totalUnpaid}`);

    // 6. Perform a payment (melunasi hutang)
    console.log('\n[Step 6] Simulating collective payment for this debt...');
    const discount = 5000; // Rp 5.000 discount
    const totalPaid = Math.max(0, Number(debt.amount) - discount);

    const paymentResult = await prisma.$transaction(async (tx) => {
      // Create DebtPayment record
      const payment = await tx.debtPayment.create({
        data: {
          bengkelId: bengkel.id,
          totalPaid: totalPaid,
          discount: discount,
          notes: 'Pelunasan otomatis dari script test-flow.js',
        },
      });

      // Link debt to payment
      await tx.debtPaymentItem.create({
        data: {
          paymentId: payment.id,
          debtId: debt.id,
        },
      });

      // Mark debt as paid
      await tx.debt.update({
        where: { id: debt.id },
        data: {
          isPaid: true,
          paidAt: new Date(),
        },
      });

      // Record as Expense (income / pemasukan)
      const expense = await tx.expense.create({
        data: {
          description: `Pembayaran Piutang Bengkel: ${bengkel.name}`,
          amount: -totalPaid, // Negative amount denotes income in pos-next cash system
          category: 'PIUTANG_MASUK',
          notes: `Pembayaran untuk ID Hutang: ${debt.id}`,
        },
      });

      return { payment, expense };
    });

    console.log(`✅ Payment successfully recorded!`);
    console.log(`   - DebtPayment ID: ${paymentResult.payment.id} (Paid: Rp${paymentResult.payment.totalPaid}, Discount: Rp${paymentResult.payment.discount})`);
    console.log(`   - Cashflow recorded in Expense: ID ${paymentResult.expense.id} (Amount: Rp${paymentResult.expense.amount})`);

    // 7. Verify the final status is Lunas
    const updatedDebt = await prisma.debt.findUnique({ where: { id: debt.id } });
    console.log(`\n[Step 7] Checking final debt status: ${updatedDebt.isPaid ? '🟢 LUNAS' : '🔴 BELUM LUNAS'}`);

    console.log('\n✨ TEST FLOW COMPLETED SUCCESSFULLY WITH ZERO ERRORS! ✨');
  } catch (error) {
    console.error('❌ Error executing test flow:', error);
  } finally {
    await prisma.$disconnect();
  }
}

main();
