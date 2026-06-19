export const dynamic = 'force-dynamic';
import { NextRequest, NextResponse } from 'next/server';
import { db as prisma } from '@/lib/db';

// Handler function for GET request
export async function GET(req: NextRequest) {
  try {
    // Run aggregation queries sequentially to prevent connection pool exhaustion
    const totalStock = await prisma.productStock.count();
    const totalAmountResult = await prisma.transaction.aggregate({
      where: { status: 'SUKSES' },
      _sum: { totalAmount: true },
    });
    const totalQuantityResult = await prisma.onSaleProduct.aggregate({
      where: { transaction: { status: 'SUKSES' } },
      _sum: { quantity: true },
    });
    const lowStockCount = await prisma.productStock.count({
      where: { stock: { lt: 5 } },
    });

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
