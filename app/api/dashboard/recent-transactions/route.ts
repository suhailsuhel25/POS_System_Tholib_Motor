export const dynamic = 'force-dynamic';
import { NextResponse } from 'next/server';
import { db as prisma } from '@/lib/db';

export async function GET() {
    try {
        const transactions = await prisma.transaction.findMany({
            where: {
                isComplete: true,
                deletedAt: null,
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

        const serialized = transactions.map((t) => ({
            ...t,
            totalAmount: t.totalAmount ? Number(t.totalAmount) : 0,
            paymentAmount: t.paymentAmount ? Number(t.paymentAmount) : 0,
            changeAmount: t.changeAmount ? Number(t.changeAmount) : 0,
            discountAmount: t.discountAmount ? Number(t.discountAmount) : 0,
            products: t.products.map((p) => ({
                ...p,
                product: {
                    ...p.product,
                    sellprice: Number(p.product.sellprice),
                    productstock: {
                        ...p.product.productstock,
                        buyPrice: Number(p.product.productstock.buyPrice),
                        sellPrice: Number(p.product.productstock.sellPrice),
                    },
                },
            })),
        }));

        return NextResponse.json({ transactions: serialized }, { status: 200 });
    } catch (error) {
        console.error('Error fetching recent transactions:', error);
        return NextResponse.json(
            { error: 'Failed to fetch recent transactions' },
            { status: 500 }
        );
    }
}
