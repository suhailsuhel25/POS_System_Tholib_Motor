export const dynamic = 'force-dynamic';
import { NextRequest, NextResponse } from 'next/server';
import { db as prisma } from '@/lib/db';

export async function GET(req: NextRequest) {
  try {
    const { searchParams } = new URL(req.url);
    const start = searchParams.get('start');
    const end = searchParams.get('end');

    if (!start || !end) {
      return NextResponse.json(
        { error: 'Missing start or end date' },
        { status: 400 }
      );
    }

    const startDate = new Date(start);
    const endDate = new Date(end);
    endDate.setUTCHours(23, 59, 59, 999);

    // Fetch transactions and expenses sequentially to prevent connection pool exhaustion
    const transactions = await prisma.transaction.findMany({
      where: {
        createdAt: { gte: startDate, lte: endDate },
        status: 'SUKSES',
      },
      select: {
        createdAt: true,
        discountAmount: true,
        paymentAmount: true,
        totalAmount: true,
        products: {
          select: {
            quantity: true,
            product: {
              select: {
                sellprice: true,
                productstock: {
                  select: { buyPrice: true },
                },
              },
            },
          },
        },
      },
    });

    const expenses = await prisma.expense.findMany({
      where: {
        createdAt: { gte: startDate, lte: endDate },
      },
      select: {
        createdAt: true,
        amount: true,
        category: true,
      },
    });

    // Initialize groupedData
    const groupedData: {
      date: string;
      revenue: number;
      profit: number;
      expenses: number;
      expenseBreakdown: { restok: number; operational: number; other: number };
    }[] = [];

    let currentDate = new Date(startDate);
    while (currentDate <= endDate) {
      groupedData.push({
        date: currentDate.toISOString().split('T')[0],
        revenue: 0,
        profit: 0,
        expenses: 0,
        expenseBreakdown: { restok: 0, operational: 0, other: 0 },
      });
      currentDate.setDate(currentDate.getDate() + 1);
    }

    // Process transactions
    transactions.forEach((transaction) => {
      const date = transaction.createdAt.toISOString().split('T')[0];
      const existingData = groupedData.find((d) => d.date === date);
      if (!existingData) return;

      let totalSell = 0;
      let totalCost = 0;

      transaction.products.forEach((onSaleProduct: any) => {
        const productStock = onSaleProduct.product;
        const product = onSaleProduct.product?.productstock;

        if (productStock && product) {
          const qty = onSaleProduct.quantity;
          const sellPrice = Number(productStock.sellprice || 0);
          const buyPrice = Number(product.buyPrice || 0);

          totalSell += sellPrice * qty;
          totalCost += buyPrice * qty;
        }
      });

      const discount = Number(transaction.discountAmount || 0);
      const revenue = Math.max(0, totalSell - discount);
      const profit = Math.max(0, totalSell - totalCost - discount);

      existingData.revenue += revenue;
      existingData.profit += profit;
    });

    // Process expenses
    expenses.forEach((expense) => {
      const date = expense.createdAt.toISOString().split('T')[0];
      const existingData = groupedData.find((d) => d.date === date);
      if (!existingData) return;

      const amount = Number(expense.amount);
      existingData.expenses += amount;

      if (expense.category === 'RESTOK') {
        existingData.expenseBreakdown.restok += amount;
      } else if (expense.category === 'OPERASIONAL' || expense.category === 'GAJI') {
        existingData.expenseBreakdown.operational += amount;
      } else {
        existingData.expenseBreakdown.other += amount;
      }

      // Subtract expenses from profit
      existingData.profit -= amount;
    });

    return NextResponse.json({ groupedData }, { status: 200 });
  } catch (error: any) {
    console.error('Error occurred:', error.message, error.stack);
    return NextResponse.json(
      { error: error.message || 'Internal Server Error' },
      { status: 500 }
    );
  }
}
