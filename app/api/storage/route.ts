import { NextResponse } from 'next/server';
import { db as prisma } from '@/lib/db';

export async function GET() {
  try {
    const productStocks = await prisma.productStock.findMany({
      include: {
        Product: {
          select: {
            sellprice: true,
          },
        },
      },
    });

    const serialized = productStocks.map((ps) => ({
      ...ps,
      buyPrice: Number(ps.buyPrice),
      sellPrice: Number(ps.sellPrice),
      Product: ps.Product ? {
        ...ps.Product,
        sellprice: Number(ps.Product.sellprice),
      } : null,
    }));

    return NextResponse.json(serialized, { status: 200 });
  } catch (error) {
    console.error('GET /api/storage error:', error);
    return NextResponse.json(
      { error: 'Internal Server Error' },
      { status: 500 }
    );
  }
}
