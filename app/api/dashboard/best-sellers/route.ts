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

        // Fetch product details for each best seller using a single query to prevent pool exhaustion
        const productIds = bestSellers.map((b) => b.productId);
        const products = await prisma.product.findMany({
            where: { productId: { in: productIds } },
            include: { productstock: true },
        });

        const productsWithDetails = bestSellers.map((item) => {
            const product = products.find((p) => p.productId === item.productId);
            return {
                ...product,
                totalSold: item._sum.quantity || 0,
            };
        });

        return NextResponse.json({ products: productsWithDetails }, { status: 200 });
    } catch (error) {
        console.error('Error fetching best sellers:', error);
        return NextResponse.json(
            { error: 'Failed to fetch best sellers' },
            { status: 500 }
        );
    }
}
