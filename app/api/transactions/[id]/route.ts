import { NextRequest, NextResponse } from 'next/server';
import { db as prisma } from '@/lib/db';

// GET request handler to fetch onSaleProducts by transactionId
export async function GET(
  req: NextRequest,
  { params }: { params: { id: string } }
) {
  const { id } = params;

  try {
    // Fetch transaction with the given id, including detailed product information
    const transaction = await prisma.transaction.findUnique({
      where: { id },
      include: {
        products: {
          include: {
            product: {
              include: {
                productstock: true,
              },
            },
          },
          orderBy: {
            product: {
              productstock: {
                name: 'asc',
              },
            },
          },
        },
      },
    });

    // Return 404 if transaction is not found
    if (!transaction) {
      return NextResponse.json(
        { message: 'Transaction not found' },
        { status: 404 }
      );
    }

    return NextResponse.json(transaction, { status: 200 });
  } catch (error) {
    console.error('API Error fetching transaction:', error);
    return NextResponse.json(
      { error: 'Internal server error' },
      { status: 500 }
    );
  }
}

export const PATCH = async (
  request: Request,
  { params }: { params: { id: string } }
) => {
  try {
    const { id } = params;
    const body = await request.json();
    const { status } = body;

    if (status === 'RETUR') {
      // Logic for return: change status and RESTORE stock
      const result = await prisma.$transaction(async (tx) => {
        // 1. Get the transaction with products
        const transaction = await tx.transaction.findUnique({
          where: { id },
          include: {
            products: {
              include: {
                product: true
              }
            }
          }
        });

        if (!transaction) throw new Error('Transaction not found');
        if (transaction.status === 'RETUR') throw new Error('Transaction is already returned');

        // 2. Restore stock for each product
        for (const item of transaction.products) {
          await tx.productStock.update({
            where: { id: item.productId },
            data: {
              stock: {
                increment: item.quantity
              }
            }
          });
        }

        // 3. Update transaction status
        return await tx.transaction.update({
          where: { id },
          data: { status: 'RETUR' }
        });
      });

      return NextResponse.json(result, { status: 200 });
    }

    // Default patch logic (if needed for other updates)
    const updateData: any = {};
    if (body.totalAmount !== undefined) updateData.totalAmount = body.totalAmount;
    if (body.isComplete !== undefined) updateData.isComplete = body.isComplete;

    const updatedTransaction = await prisma.transaction.update({
      where: { id },
      data: updateData,
    });

    return NextResponse.json(updatedTransaction, { status: 200 });
  } catch (error: any) {
    console.error('Error updating transaction:', error);
    return NextResponse.json({ error: error.message }, { status: 500 });
  }
};

// DELETE request handler to delete a transaction
export const DELETE = async (
  request: Request,
  { params }: { params: { id: string } }
) => {
  try {
    // Delete transaction by id
    const transaction = await prisma.transaction.delete({
      where: {
        id: String(params.id),
      },
    });

    return NextResponse.json(transaction, { status: 200 });
  } catch (error: any) {
    if (error.code === 'P2025') {
      // Prisma error code for data not found
      return NextResponse.json(
        { error: 'Transaction not found' },
        { status: 404 }
      );
    }

    return NextResponse.json({ error: error.message }, { status: 500 });
  }
};
