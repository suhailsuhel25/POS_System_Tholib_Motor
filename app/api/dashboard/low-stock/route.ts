export const dynamic = 'force-dynamic';
import { NextResponse } from 'next/server';
import { db as prisma } from '@/lib/db';

export async function GET() {
    try {
        const lowStockProducts = await prisma.productStock.findMany({
            where: {
                stock: {
                    lt: 5,
                },
            },
            include: {
                Product: true,
            },
            orderBy: {
                stock: 'asc',
            },
            take: 5,
        });

        return NextResponse.json({ products: lowStockProducts }, { status: 200 });
    } catch (error) {
        console.error('Error fetching low stock products:', error);
        return NextResponse.json(
            { error: 'Failed to fetch low stock products' },
            { status: 500 }
        );
    }
}
