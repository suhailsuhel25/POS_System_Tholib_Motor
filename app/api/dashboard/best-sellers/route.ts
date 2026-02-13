import { NextResponse } from 'next/server';
import { db as prisma } from '@/lib/db';

export async function GET() {
    try {
        // Group by productId and sum quantities
        const bestSellers = await prisma.onSaleProduct.groupBy({
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

        // Fetch product details for each best seller
        const productsWithDetails = await Promise.all(
            bestSellers.map(async (item) => {
                const product = await prisma.product.findUnique({
                    where: { productId: item.productId },
                    include: { productstock: true },
                });
                return {
                    ...product,
                    totalSold: item._sum.quantity || 0,
                };
            })
        );

        return NextResponse.json({ products: productsWithDetails }, { status: 200 });
    } catch (error) {
        console.error('Error fetching best sellers:', error);
        return NextResponse.json(
            { error: 'Failed to fetch best sellers' },
            { status: 500 }
        );
    }
}
