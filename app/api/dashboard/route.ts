import { NextRequest, NextResponse } from 'next/server';
import { db as prisma } from '@/lib/db';

// Handler function for GET request
export async function GET(req: NextRequest) {
  try {
    // Count total number of products
    const totalStock = await prisma.productStock.count();

    // Aggregate total amount
    const totalAmount = await prisma.transaction.aggregate({
      where: {
        status: 'SUKSES',
      },
      _sum: {
        totalAmount: true,
      },
    });

    // Aggregate total quantity
    const totalQuantity = await prisma.onSaleProduct.aggregate({
      where: {
        transaction: {
          status: 'SUKSES',
        },
      },
      _sum: {
        quantity: true,
      },
    });

    // Count products with low stock (lt 5)
    const lowStockCount = await prisma.productStock.count({
      where: {
        stock: {
          lt: 5,
        },
      },
    });

    // Return aggregated data in the response
    return NextResponse.json(
      {
        totalStock,
        totalAmount: Number(totalAmount._sum.totalAmount || 0),
        totalQuantity: totalQuantity._sum.quantity || 0,
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
