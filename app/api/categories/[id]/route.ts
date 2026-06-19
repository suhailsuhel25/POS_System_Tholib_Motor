import { NextRequest, NextResponse } from 'next/server';
import { db as prisma } from '@/lib/db';

export async function PUT(req: NextRequest, { params }: { params: { id: string } }) {
  try {
    const { id } = params;
    const { name } = await req.json();

    if (!name || name.trim() === '') {
      return NextResponse.json({ error: 'Nama kategori wajib diisi' }, { status: 400 });
    }

    const oldCategory = await prisma.category.findUnique({
      where: { id }
    });

    if (!oldCategory) {
      return NextResponse.json({ error: 'Kategori tidak ditemukan' }, { status: 404 });
    }

    const newName = name.trim().toUpperCase();

    // Start a transaction to update both Category and all associated ProductStock
    await prisma.$transaction(async (tx) => {
      // 1. Update the category name
      await tx.category.update({
        where: { id },
        data: { name: newName }
      });

      // 2. Update all ProductStocks that have the old category name
      await tx.productStock.updateMany({
        where: { masterCategory: oldCategory.name },
        data: { masterCategory: newName }
      });
    });

    return NextResponse.json({ success: true, message: 'Kategori berhasil diubah' }, { status: 200 });
  } catch (error: any) {
    if (error.code === 'P2002') {
      return NextResponse.json({ error: 'Nama kategori ini sudah ada' }, { status: 400 });
    }
    console.error('Failed to update category:', error);
    return NextResponse.json({ error: 'Internal Server Error' }, { status: 500 });
  }
}

export async function DELETE(req: NextRequest, { params }: { params: { id: string } }) {
  try {
    const { id } = params;
    
    // Deleting the category from the master list. 
    // We intentionally DO NOT update ProductStock here to prevent data loss. 
    // The old string remains in ProductStock, but disappears from the predefined category list.
    await prisma.category.delete({
      where: { id }
    });

    return NextResponse.json({ success: true, message: 'Kategori dihapus' }, { status: 200 });
  } catch (error) {
    console.error('Failed to delete category:', error);
    return NextResponse.json({ error: 'Internal Server Error' }, { status: 500 });
  }
}
