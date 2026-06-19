import { db as prisma } from '@/lib/db';
import { NextResponse } from 'next/server';
import { z } from 'zod';

const restockSchema = z.object({
  stock: z.number().int().positive('Jumlah stok harus lebih dari 0'),
  unitCost: z.number().min(0, 'Harga satuan tidak boleh negatif').optional().default(0),
});

export const POST = async (request: Request) => {
  try {
    const body = await request.json();
    const parsed = restockSchema.safeParse(body);

    if (!parsed.success) {
      return NextResponse.json(
        { error: parsed.error.errors.map(e => e.message).join(', ') },
        { status: 400 }
      );
    }

    const { stock, unitCost } = parsed.data;
    const totalCost = stock * unitCost;

    const result = await prisma.productStock.updateMany({
      data: {
        stock: { increment: stock },
      },
    });

    // Create expense record if there's a cost
    if (totalCost > 0) {
      await prisma.expense.create({
        data: {
          description: `Restok ${stock} item`,
          amount: totalCost,
          category: 'RESTOK',
          notes: `Penambahan stok ${stock} item`,
        },
      });
    }

    return NextResponse.json(
      { 
        message: `Berhasil menambah stok ${stock} untuk ${result.count} produk`,
        totalCost,
      },
      { status: 200 }
    );
  } catch (error: any) {
    console.error('POST /api/restock error:', error);
    return NextResponse.json({ error: 'Internal Server Error' }, { status: 500 });
  }
};
