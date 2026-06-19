import { db as prisma } from '@/lib/db';
import { NextResponse } from 'next/server';
import { updateProductSchema } from '@/schema';

export const PATCH = async (
  request: Request,
  { params }: { params: { id: string } }
) => {
  try {
    const body = await request.json();

    const parsed = updateProductSchema.safeParse(body);
    if (!parsed.success) {
      return NextResponse.json(
        { error: parsed.error.errors.map(e => e.message).join(', ') },
        { status: 400 }
      );
    }

    const existingProduct = await prisma.product.findUnique({
      where: { productId: String(params.id) },
    });

    const updateData: any = {
      name: parsed.data.name,
      stock: parsed.data.stock,
      brand: parsed.data.brand as any,
      buyPrice: parsed.data.buyPrice,
      sellPrice: parsed.data.sellPrice,
      masterCategory: parsed.data.masterCategory,
      category: parsed.data.category,
      barcode: parsed.data.barcode !== undefined ? (parsed.data.barcode ? parsed.data.barcode.toUpperCase() : null) : undefined,
    };

    if (parsed.data.sellPrice !== undefined) {
      if (existingProduct) {
        updateData.Product = {
          update: {
            where: { productId: String(params.id) },
            data: { sellprice: parsed.data.sellPrice },
          },
        };
      } else {
        updateData.Product = {
          create: {
            sellprice: parsed.data.sellPrice,
          },
        };
      }
    }

    const editProduct = await prisma.productStock.update({
      where: { id: String(params.id) },
      data: updateData,
      include: { Product: true },
    });

    return NextResponse.json({
      ...editProduct,
      buyPrice: Number(editProduct.buyPrice),
      sellPrice: Number(editProduct.sellPrice),
      Product: editProduct.Product ? {
        ...editProduct.Product,
        sellprice: Number(editProduct.Product.sellprice),
      } : null,
    }, { status: 200 });
  } catch (error: any) {
    if (error.code === 'P2025') {
      return NextResponse.json({ error: 'Produk tidak ditemukan' }, { status: 404 });
    }
    console.error('PATCH /api/product/[id] error:', error);
    return NextResponse.json({ error: 'Internal Server Error' }, { status: 500 });
  }
};

export const DELETE = async (
  request: Request,
  { params }: { params: { id: string } }
) => {
  try {
    const product = await prisma.productStock.delete({
      where: { id: String(params.id) },
    });

    return NextResponse.json({ message: 'Produk berhasil dihapus' }, { status: 200 });
  } catch (error: any) {
    if (error.code === 'P2025') {
      return NextResponse.json({ error: 'Produk tidak ditemukan' }, { status: 404 });
    }
    console.error('DELETE /api/product/[id] error:', error);
    return NextResponse.json({ error: 'Internal Server Error' }, { status: 500 });
  }
};
