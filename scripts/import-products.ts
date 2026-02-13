import { PrismaClient, Brand } from '@prisma/client';
import fs from 'fs';
import path from 'path';

const prisma = new PrismaClient();

interface ProductData {
    name: string;
    brand: string;
    category: string;
    sku_manual: string;
    buy_price: number;
    sell_price: number;
    stock: number;
    master_category: string;
}

async function importProducts(filePath: string) {
    console.log(`📂 Reading file: ${filePath}`);

    const rawData = fs.readFileSync(filePath, 'utf-8');
    const products: ProductData[] = JSON.parse(rawData);

    console.log(`📦 Found ${products.length} products to import`);

    let imported = 0;
    let skipped = 0;
    let errors = 0;

    // Process in batches for performance
    const BATCH_SIZE = 100;

    for (let i = 0; i < products.length; i += BATCH_SIZE) {
        const batch = products.slice(i, i + BATCH_SIZE);

        const createPromises = batch.map(async (product) => {
            try {
                // Validate brand
                const brand = product.brand?.toUpperCase() as Brand;
                if (!['HONDA', 'YAMAHA', 'KAWASAKI', 'SUZUKI'].includes(brand)) {
                    console.warn(`⚠️ Invalid brand: ${product.brand} for ${product.sku_manual}`);
                    skipped++;
                    return;
                }

                // Check if already exists
                const existing = await prisma.productStock.findUnique({
                    where: { skuManual: product.sku_manual },
                });

                if (existing) {
                    skipped++;
                    return;
                }

                // Create product
                await prisma.productStock.create({
                    data: {
                        name: product.name,
                        brand: brand,
                        category: product.category || '',
                        masterCategory: product.master_category || '',
                        skuManual: product.sku_manual,
                        buyPrice: product.buy_price || 0,
                        sellPrice: product.sell_price || 0,
                        stock: product.stock || 0,
                        Product: {
                            create: {
                                sellprice: product.sell_price || 0,
                            },
                        },
                    },
                });

                imported++;
            } catch (error: any) {
                console.error(`❌ Error importing ${product.sku_manual}: ${error.message}`);
                errors++;
            }
        });

        await Promise.all(createPromises);

        // Progress log
        const progress = Math.min(i + BATCH_SIZE, products.length);
        console.log(`📊 Progress: ${progress}/${products.length} (${Math.round(progress / products.length * 100)}%)`);
    }

    console.log('\n✅ Import completed!');
    console.log(`   📥 Imported: ${imported}`);
    console.log(`   ⏭️ Skipped: ${skipped}`);
    console.log(`   ❌ Errors: ${errors}`);
}

async function main() {
    const args = process.argv.slice(2);

    if (args.length === 0) {
        // Default: import honda_final.json
        const defaultFile = path.join(process.cwd(), 'honda_final.json');
        if (fs.existsSync(defaultFile)) {
            await importProducts(defaultFile);
        } else {
            console.log('Usage: npx ts-node scripts/import-products.ts <json-file>');
            console.log('Example: npx ts-node scripts/import-products.ts honda_final.json');
        }
    } else {
        // Import specified file
        for (const file of args) {
            const filePath = path.isAbsolute(file) ? file : path.join(process.cwd(), file);
            if (fs.existsSync(filePath)) {
                await importProducts(filePath);
            } else {
                console.error(`❌ File not found: ${filePath}`);
            }
        }
    }

    await prisma.$disconnect();
}

main().catch((error) => {
    console.error('Fatal error:', error);
    prisma.$disconnect();
    process.exit(1);
});
