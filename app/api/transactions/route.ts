import { db as prisma } from '@/lib/db';
import { NextResponse } from 'next/server';
import { v4 as uuidv4 } from 'uuid';

// Function to generate a unique transaction ID
const generateUniqueId = async () => {
  let isUnique = false;
  let customId = '';

  // Loop until a unique ID is generated
  while (!isUnique) {
    customId = `TRS-${uuidv4().slice(0, 8)}`;
    const existingOrder = await prisma.transaction.findUnique({
      where: { id: customId },
    });

    // Check if the generated ID already exists in the database
    if (!existingOrder) {
      isUnique = true;
    }
  }

  return customId;
};

// GET request handler to fetch all transactions (with basic pagination/filtering placeholders)
export const GET = async (request: Request) => {
  try {
    const { searchParams } = new URL(request.url);
    const limit = parseInt(searchParams.get('limit') || '20');
    // const page = parseInt(searchParams.get('page') || '1'); // Future implementation

    // Fetch transactions
    const transactions = await prisma.transaction.findMany({
      orderBy: {
        createdAt: 'desc',
      },
      take: limit,
      include: {
        products: {
          include: {
            product: {
              include: {
                productstock: true,
              }
            }
          }
        },
      }
    });

    return NextResponse.json({ transactions }, { status: 200 });
  } catch (error: any) {
    return NextResponse.json({ error: error.message }, { status: 500 });
  }
};

// POST request handler to create a new transaction with products
export const POST = async (request: Request) => {
  try {
    const body = await request.json();
    const { items, paymentAmount, changeAmount } = body; // items: { id: string, quantity: number, price: number }[]

    if (!items || items.length === 0) {
      return NextResponse.json({ error: 'No items in cart' }, { status: 400 });
    }

    // Generate a unique transaction ID
    const customId = await generateUniqueId();

    // Calculate total amount
    const totalAmount = items.reduce((sum: number, item: any) => sum + (item.price * item.quantity), 0);

    // Start a transaction to ensure atomicity
    const result = await prisma.$transaction(async (tx) => {
      // 1. Create the transaction
      const transaction = await tx.transaction.create({
        data: {
          id: customId,
          totalAmount,
          paymentAmount: Number(paymentAmount || 0),
          changeAmount: Number(changeAmount || 0),
          status: 'SUKSES',
          isComplete: true,
        },
      });

      // 2. For each item, create OnSaleProduct and update stock
      for (const item of items) {
        // Get the ProductStock to find the linked Product
        const productStock = await tx.productStock.findUnique({
          where: { id: item.id },
          include: { Product: true },
        });

        if (!productStock) {
          throw new Error(`Product with id ${item.id} not found`);
        }

        if (productStock.stock < item.quantity) {
          throw new Error(`Insufficient stock for ${productStock.name}`);
        }

        // Ensure Product exists (create if needed) and get productId
        let productId: string;
        if (productStock.Product) {
          productId = productStock.Product.productId;
        } else {
          const newProduct = await tx.product.create({
            data: {
              productId: productStock.id,
              sellprice: productStock.sellPrice,
            },
          });
          productId = newProduct.productId;
        }

        // Create OnSaleProduct
        await tx.onSaleProduct.create({
          data: {
            productId,
            quantity: item.quantity,
            transactionId: transaction.id,
          },
        });

        // Update stock
        await tx.productStock.update({
          where: { id: item.id },
          data: {
            stock: {
              decrement: item.quantity,
            },
          },
        });
      }

      return transaction;
    });

    return NextResponse.json(result, { status: 201 });
  } catch (error: any) {
    console.error('Transaction error:', error);
    return NextResponse.json({ error: error.message }, { status: 500 });
  }
};

