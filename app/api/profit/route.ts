export const dynamic = 'force-dynamic';
import { NextRequest, NextResponse } from 'next/server';
import { db as prisma } from '@/lib/db';

// Handler function for GET requests
export async function GET(req: NextRequest) {
  try {
    // Get start and end dates from query parameters
    const { searchParams } = new URL(req.url);
    const start = searchParams.get('start');
    const end = searchParams.get('end');

    // Return an error response if start or end date is missing
    if (!start || !end) {
      return NextResponse.json(
        { error: 'Missing start or end date' },
        { status: 400 }
      );
    }

    // Convert start and end dates to Date objects
    const startDate = new Date(start);
    const endDate = new Date(end);
    endDate.setUTCHours(23, 59, 59, 999); // Set end date to the end of the day

    // Query transactions with selected fields for performance
    const transactions = await prisma.transaction.findMany({
      where: {
        createdAt: {
          gte: new Date(startDate),
          lte: new Date(endDate),
        },
        status: 'SUKSES',
      },
      select: {
        createdAt: true,
        products: {
          select: {
            quantity: true,
            product: {
              select: {
                sellprice: true,
                productstock: {
                  select: {
                    buyPrice: true,
                  },
                },
              },
            },
          },
        },
      },
    });

    // Initialize groupedData with default 0 values for each day in the range
    const groupedData: {
      date: string;
      netIncome: number;
      grossIncome: number;
    }[] = [];

    // Populate default data for each day in the date range
    let currentDate = startDate;
    while (currentDate <= endDate) {
      groupedData.push({
        date: currentDate.toISOString().split('T')[0],
        netIncome: 0,
        grossIncome: 0,
      });
      currentDate.setDate(currentDate.getDate() + 1);
    }

    // Process each transaction and group by createdAt date
    transactions.forEach((transaction) => {
      const date = transaction.createdAt.toISOString().split('T')[0];
      let costPriceTotal = 0;
      let sellPriceTotal = 0;

      // Process each onSaleProduct in the transaction
      transaction.products.forEach((onSaleProduct: any) => {
        const productStock = onSaleProduct.product;
        const product = onSaleProduct.product?.productstock;

        if (productStock && product) {
          const quantity = onSaleProduct.quantity;
          const currentSellPrice = Number(productStock.sellprice || 0) * quantity;
          const currentBuyPrice = Number(product.buyPrice || 0) * quantity;

          // Logic: If buyPrice exists (> 0), use real calculation.
          // Otherwise, fallback to 3000 per item as requested.
          const itemProfit = (Number(product.buyPrice || 0) > 0)
            ? (currentSellPrice - currentBuyPrice)
            : (3000 * quantity);

          costPriceTotal += itemProfit;
          sellPriceTotal += currentSellPrice;
        }
      });

      const netIncome = costPriceTotal;
      const grossIncome = sellPriceTotal;

      // Update groupedData with calculated values
      const existingData = groupedData.find((data) => data.date === date);
      if (existingData) {
        existingData.netIncome += netIncome;
        existingData.grossIncome += grossIncome;
      }
    });

    // Return the grouped data as a JSON response with a 200 status code
    return NextResponse.json({ groupedData }, { status: 200 });
  } catch (error) {
    // Log and return an error message as a JSON response with a 500 status code if there's an error
    console.error('Error occurred:', error);
    return NextResponse.json(
      { error: 'Internal Server Error' },
      { status: 500 }
    );
  }
}

