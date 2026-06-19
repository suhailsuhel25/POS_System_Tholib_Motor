import { Brand } from '@prisma/client';
import { db as prisma } from '@/lib/db';
import { NextResponse } from 'next/server';
import { v4 as uuidv4 } from 'uuid';
import { createProductSchema } from '@/schema';

const cache = {
  categories: new Map<string, { data: string[]; timestamp: number }>(),
  masterCategories: new Map<string, { data: string[]; timestamp: number }>(),
  CACHE_TTL: 5 * 60 * 1000,
};

function getCachedCategories(brand: string): string[] | null {
  const cached = cache.categories.get(brand);
  if (cached && Date.now() - cached.timestamp < cache.CACHE_TTL) return cached.data;
  return null;
}

function getCachedMasterCategories(brand: string): string[] | null {
  const cached = cache.masterCategories.get(brand);
  if (cached && Date.now() - cached.timestamp < cache.CACHE_TTL) return cached.data;
  return null;
}

function setCachedCategories(brand: string, data: string[]): void {
  cache.categories.set(brand, { data, timestamp: Date.now() });
}

function setCachedMasterCategories(brand: string, data: string[]): void {
  cache.masterCategories.set(brand, { data, timestamp: Date.now() });
}

const generateUniqueId = () => `PRD-${uuidv4().slice(0, 8)}`;

export const GET = async (request: Request) => {
  try {
    const { searchParams } = new URL(request.url);

    const brand = searchParams.get('brand')?.toUpperCase() as Brand | undefined;
    const search = searchParams.get('search') || '';
    const category = searchParams.get('category') || '';
    const masterCategory = searchParams.get('masterCategory') || '';
    const limit = Math.min(parseInt(searchParams.get('limit') || '50'), 100);
    const offset = parseInt(searchParams.get('offset') || '0');
    const skipCount = searchParams.get('skipCount') === 'true';

    const where: any = {};

    if (brand && ['HONDA', 'YAMAHA', 'KAWASAKI', 'SUZUKI'].includes(brand)) {
      where.brand = brand;
    }

    if (search) {
      where.OR = [
        { name: { contains: search, mode: 'insensitive' } },
        { skuManual: { contains: search, mode: 'insensitive' } },
        { barcode: { contains: search, mode: 'insensitive' } },
      ];
    }

    if (category) {
      where.category = category;
    }

    if (masterCategory) {
      where.masterCategory = masterCategory;
    }

    let categories = brand ? getCachedCategories(brand) : null;
    let masterCategories = brand ? getCachedMasterCategories(brand) : null;

    // Run queries sequentially to prevent connection pool exhaustion
    const rawProducts = await prisma.productStock.findMany({
      where,
      orderBy: { name: 'asc' },
      take: limit,
      skip: offset,
      select: {
        id: true,
        name: true,
        brand: true,
        category: true,
        masterCategory: true,
        skuManual: true,
        barcode: true,
        buyPrice: true,
        sellPrice: true,
        stock: true,
        imageProduct: true,
      },
    });

    let totalCount = skipCount ? -1 : 0;
    if (!skipCount) {
      totalCount = await prisma.productStock.count({ where });
    }

    if (brand && categories === null) {
      const catResult = await prisma.productStock.findMany({
        where: { brand },
        select: { category: true },
        distinct: ['category'],
        orderBy: { category: 'asc' },
      });
      categories = catResult.map((c: any) => c.category);
      setCachedCategories(brand, categories!);
    }

    if (brand && masterCategories === null) {
      const mcResult = await prisma.productStock.findMany({
        where: { brand },
        select: { masterCategory: true },
        distinct: ['masterCategory'],
        orderBy: { masterCategory: 'asc' },
      });
      masterCategories = mcResult.map((c: any) => c.masterCategory);
      setCachedMasterCategories(brand, masterCategories!);
    }

    const products = rawProducts.map((p: any) => ({
      ...p,
      buyPrice: Number(p.buyPrice),
      sellPrice: Number(p.sellPrice),
    }));

    return NextResponse.json({
      products,
      totalCount: totalCount === -1 ? products.length + offset : totalCount,
      categories: categories || [],
      masterCategories: masterCategories || [],
      pagination: {
        limit,
        offset,
        hasMore: products.length === limit,
      },
    }, { status: 200 });
  } catch (error: any) {
    console.error('GET /api/product error:', error);
    return NextResponse.json({ error: 'Internal Server Error' }, { status: 500 });
  }
};

export const POST = async (request: Request) => {
  try {
    const body = await request.json();

    const parsed = createProductSchema.safeParse(body);
    if (!parsed.success) {
      return NextResponse.json(
        { error: parsed.error.errors.map(e => e.message).join(', ') },
        { status: 400 }
      );
    }

    const data = parsed.data;
    const customId = await generateUniqueId();

    cache.categories.delete(data.brand);
    cache.masterCategories.delete(data.brand);

    const newProduct = await prisma.productStock.create({
      data: {
        id: customId,
        name: data.name,
        brand: data.brand as Brand,
        category: data.category || '',
        masterCategory: data.masterCategory || '',
        skuManual: data.skuManual || `${data.brand.slice(0, 3)}-${customId}`,
        barcode: data.barcode || null,
        buyPrice: data.buyPrice || 0,
        sellPrice: data.sellPrice || 0,
        stock: data.stock || 0,
        imageProduct: data.imageProduct || null,
        Product: {
          create: {
            sellprice: data.sellPrice || 0,
          },
        },
      },
    });

    return NextResponse.json({
      ...newProduct,
      buyPrice: Number(newProduct.buyPrice),
      sellPrice: Number(newProduct.sellPrice),
    }, { status: 201 });
  } catch (error: any) {
    console.error('POST /api/product error:', error);
    return NextResponse.json({ error: 'Internal Server Error' }, { status: 500 });
  }
};
