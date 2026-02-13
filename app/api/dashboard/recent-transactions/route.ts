import { NextResponse } from 'next/server';
import { db as prisma } from '@/lib/db';

export async function GET() {
    try {
        const transactions = await prisma.transaction.findMany({
            where: {
                isComplete: true,
            },
            orderBy: {
                createdAt: 'desc',
            },
            take: 5,
            include: {
                products: {
                    include: {
                        product: {
                            include: {
                                productstock: true,
                            },
                        },
                    },
                },
            },
        });

        return NextResponse.json({ transactions }, { status: 200 });
    } catch (error) {
        console.error('Error fetching recent transactions:', error);
        return NextResponse.json(
            { error: 'Failed to fetch recent transactions' },
            { status: 500 }
        );
    }
}
