export const dynamic = 'force-dynamic';
import { NextRequest, NextResponse } from 'next/server';
import { db as prisma } from '@/lib/db';

// Handler function for GET request
export async function GET(req: NextRequest) {
  try {
    // Run all aggregation queries in parallel
    const [totalStock, totalAmountResult, totalQuantityResult, lowStockCount] = await Promise.all([
      prisma.productStock.count(),
      prisma.transaction.aggregate({
        where: { status: 'SUKSES' },
        _sum: { totalAmount: true },
      }),
      prisma.onSaleProduct.aggregate({
        where: { transaction: { status: 'SUKSES' } },
        _sum: { quantity: true },
      }),
      prisma.productStock.count({
        where: { stock: { lt: 5 } },
      })
    ]);

    // Return aggregated data in the response
    return NextResponse.json(
      {
        totalStock,
        totalAmount: Number(totalAmountResult._sum.totalAmount || 0),
        totalQuantity: totalQuantityResult._sum.quantity || 0,
        lowStockCount,
      },
      { status: 200 }
    );
  } catch (error) {
    // Handle errors
    console.error(error);
    return NextResponse.json(
      { error: 'Internal Server Error' },
      { status: 500 }
    );
  }
}
