export const dynamic = 'force-dynamic';
import { NextRequest, NextResponse } from 'next/server';
import { db as prisma } from '@/lib/db';

// Handler function for GET requests
export async function GET(req: NextRequest) {
  try {
    // Fetch shopData from the database
    let data = await prisma.shopData.findFirst();

    // If no data exists, create a default one
    if (!data) {
      data = await prisma.shopData.create({
        data: {
          name: 'My Store',
        },
      });
    }

    // Return the data as a JSON response with a 200 status code
    return NextResponse.json({ data }, { status: 200 });
  } catch (error) {
    // Log the error for debugging purposes
    console.error('Error fetching shop data:', error);

    // Return a detailed error message as a JSON response with a 500 status code
    return NextResponse.json(
      { error: 'Failed to fetch shop data. Please try again later.' },
      { status: 500 }
    );
  }
}
