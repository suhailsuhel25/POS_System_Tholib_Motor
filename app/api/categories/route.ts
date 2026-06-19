import { NextRequest, NextResponse } from 'next/server';
import { db as prisma } from '@/lib/db';

export async function GET(req: NextRequest) {
  try {
    // 1. Get all unique categories currently in ProductStock's masterCategory
    const stockCategories = await prisma.productStock.findMany({
      select: { masterCategory: true },
      distinct: ['masterCategory'],
    });

    // 2. Fetch existing categories from Category table
    let existingCategories = await prisma.category.findMany({
      orderBy: { name: 'asc' }
    });

    // 3. Auto-sync missing categories from ProductStock to Category table
    const existingNames = new Set(existingCategories.map(c => c.name));
    const missingNames = stockCategories
      .map(sc => sc.masterCategory)
      .filter(name => !existingNames.has(name) && name.trim() !== '');

    if (missingNames.length > 0) {
      await prisma.category.createMany({
        data: missingNames.map(name => ({ name })),
        skipDuplicates: true,
      });
      // Refresh the list after inserting
      existingCategories = await prisma.category.findMany({
        orderBy: { name: 'asc' }
      });
    }

    return NextResponse.json(existingCategories, { status: 200 });
  } catch (error) {
    console.error('Failed to get categories:', error);
    return NextResponse.json({ error: 'Internal Server Error' }, { status: 500 });
  }
}

export async function POST(req: NextRequest) {
  try {
    const { name } = await req.json();

    if (!name || name.trim() === '') {
      return NextResponse.json({ error: 'Nama kategori wajib diisi' }, { status: 400 });
    }

    const category = await prisma.category.create({
      data: { name: name.trim().toUpperCase() }
    });

    return NextResponse.json(category, { status: 201 });
  } catch (error: any) {
    if (error.code === 'P2002') {
      return NextResponse.json({ error: 'Kategori ini sudah ada' }, { status: 400 });
    }
    console.error('Failed to create category:', error);
    return NextResponse.json({ error: 'Internal Server Error' }, { status: 500 });
  }
}
