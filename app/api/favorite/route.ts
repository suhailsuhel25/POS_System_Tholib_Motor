export const dynamic = 'force-dynamic';
import { NextRequest, NextResponse } from 'next/server';
import { db as prisma } from '@/lib/db';

// Handler function for GET requests
export async function GET(req: NextRequest) {
  try {
    // Get the top 5 products with the highest total quantity sold
    const topProducts = await prisma.onSaleProduct.groupBy({
      by: ['productId'],
      _sum: {
        quantity: true,
      },
      orderBy: {
        _sum: {
          quantity: 'desc',
        },
      },
      take: 5,
    });

    // Get detailed information for each top product using a single query to prevent pool exhaustion
    const productIds = topProducts.map((p) => p.productId);
    const products = await prisma.product.findMany({
      where: { productId: { in: productIds } },
      include: { productstock: true },
    });

    const productDetails = topProducts.map((product) => {
      const productDetail = products.find((p) => p.productId === product.productId);
      return {
        ...productDetail,
        _sum: product._sum,
      };
    });

    // Return the top products with their details as a JSON response with a 200 status code
    return NextResponse.json({ topProducts: productDetails }, { status: 200 });
  } catch (error) {
    // Log and return an error message as a JSON response with a 500 status code if there's an error
    console.error('Error occurred:', error);
    return NextResponse.json(
      { error: 'Internal Server Error' },
      { status: 500 }
    );
  }
}
