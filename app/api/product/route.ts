import { Brand } from '@prisma/client';
import { db as prisma } from '@/lib/db';
import { NextResponse } from 'next/server';
import { v4 as uuidv4 } from 'uuid';

// Simple in-memory cache for categories (refreshes every 5 minutes)
const cache = {
  categories: new Map<string, { data: string[]; timestamp: number }>(),
  masterCategories: new Map<string, { data: string[]; timestamp: number }>(),
  CACHE_TTL: 5 * 60 * 1000, // 5 minutes
};

function getCachedCategories(brand: string): string[] | null {
  const cached = cache.categories.get(brand);
  if (cached && Date.now() - cached.timestamp < cache.CACHE_TTL) {
    return cached.data;
  }
  return null;
}

function getCachedMasterCategories(brand: string): string[] | null {
  const cached = cache.masterCategories.get(brand);
  if (cached && Date.now() - cached.timestamp < cache.CACHE_TTL) {
    return cached.data;
  }
  return null;
}

function setCachedCategories(brand: string, data: string[]): void {
  cache.categories.set(brand, { data, timestamp: Date.now() });
}

function setCachedMasterCategories(brand: string, data: string[]): void {
  cache.masterCategories.set(brand, { data, timestamp: Date.now() });
}

// Function to generate a unique ID for a new product
const generateUniqueId = async () => {
  const customId = `PRD-${uuidv4().slice(0, 8)}`;
  return customId;
};

// GET request handler to fetch products with filters
export const GET = async (request: Request) => {
  try {
    const { searchParams } = new URL(request.url);

    // Query parameters
    const brand = searchParams.get('brand')?.toUpperCase() as Brand | undefined;
    const search = searchParams.get('search') || '';
    const category = searchParams.get('category') || '';
    const masterCategory = searchParams.get('masterCategory') || '';
    const limit = parseInt(searchParams.get('limit') || '50');
    const offset = parseInt(searchParams.get('offset') || '0');
    const skipCount = searchParams.get('skipCount') === 'true';

    // Build where clause
    const where: any = {};

    // Filter by brand (required for performance)
    if (brand && ['HONDA', 'YAMAHA', 'KAWASAKI', 'SUZUKI'].includes(brand)) {
      where.brand = brand;
    }

    // Filter by search (name or SKU)
    if (search) {
      where.OR = [
        { name: { contains: search, mode: 'insensitive' } },
        { skuManual: { contains: search, mode: 'insensitive' } },
      ];
    }

    // Filter by category
    if (category) {
      where.category = category;
    }

    // Filter by master category (exact match for performance)
    if (masterCategory) {
      where.masterCategory = masterCategory;
    }

    // Check cache first for categories
    let categories = brand ? getCachedCategories(brand) : null;
    let masterCategories = brand ? getCachedMasterCategories(brand) : null;

    // Build parallel queries
    const queries: Promise<any>[] = [];

    // Query 1: Fetch products (always needed)
    queries.push(
      prisma.productStock.findMany({
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
          buyPrice: true,
          sellPrice: true,
          stock: true,
          imageProduct: true,
        },
      })
    );

    // Query 2: Count (skip if not needed for "load more" pagination)
    if (!skipCount) {
      queries.push(prisma.productStock.count({ where }));
    }

    // Query 3: Categories (only if not cached and brand is selected)
    if (brand && categories === null) {
      queries.push(
        prisma.productStock.findMany({
          where: { brand },
          select: { category: true },
          distinct: ['category'],
          orderBy: { category: 'asc' },
        })
      );
    }

    // Query 4: Master categories (only if not cached and brand is selected)
    if (brand && masterCategories === null) {
      queries.push(
        prisma.productStock.findMany({
          where: { brand },
          select: { masterCategory: true },
          distinct: ['masterCategory'],
          orderBy: { masterCategory: 'asc' },
        })
      );
    }

    // Execute all queries in parallel
    const results = await Promise.all(queries);

    // Parse results
    let resultIndex = 0;
    const products = results[resultIndex++];
    const totalCount = skipCount ? -1 : results[resultIndex++];

    // Process categories if fetched
    if (brand && categories === null) {
      const catResult = results[resultIndex++];
      categories = catResult.map((c: any) => c.category);
      setCachedCategories(brand, categories!);
    }

    // Process master categories if fetched
    if (brand && masterCategories === null) {
      const mcResult = results[resultIndex++];
      masterCategories = mcResult.map((c: any) => c.masterCategory);
      setCachedMasterCategories(brand, masterCategories!);
    }

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
    return NextResponse.json({ error: error.message }, { status: 500 });
  }
};

// POST request handler to create a new product
export const POST = async (request: Request) => {
  try {
    const customId = await generateUniqueId();
    const body = await request.json();

    // Validate brand
    const validBrands = ['HONDA', 'YAMAHA', 'KAWASAKI', 'SUZUKI'];
    const brand = body.brand?.toUpperCase();
    if (!validBrands.includes(brand)) {
      return NextResponse.json({ error: 'Invalid brand' }, { status: 400 });
    }

    // Clear cache for this brand
    cache.categories.delete(brand);
    cache.masterCategories.delete(brand);

    // Create new product
    const newProduct = await prisma.productStock.create({
      data: {
        id: customId,
        name: body.name,
        brand: brand as Brand,
        category: body.category || '',
        masterCategory: body.masterCategory || '',
        skuManual: body.skuManual || `${brand.slice(0, 3)}-${customId}`,
        buyPrice: body.buyPrice || 0,
        sellPrice: body.sellPrice || 0,
        stock: body.stock || 0,
        imageProduct: body.imageProduct || null,
        Product: {
          create: {
            sellprice: body.sellPrice || 0,
          },
        },
      },
    });

    return NextResponse.json(newProduct, { status: 201 });
  } catch (error: any) {
    console.error('POST /api/product error:', error);
    return NextResponse.json({ error: error.message }, { status: 500 });
  }
};
