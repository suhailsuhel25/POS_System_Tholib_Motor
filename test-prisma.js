const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

async function main() {
  console.log('=== DATABASE DIAGNOSTICS ===');
  try {
    const productStockCount = await prisma.productStock.count();
    const productCount = await prisma.product.count();
    const transactionCount = await prisma.transaction.count();
    const categoryCount = await prisma.category.count();
    const debtCount = await prisma.debt.count();
    const bengkelCount = await prisma.bengkel.count();

    console.log(`ProductStock : ${productStockCount} rows`);
    console.log(`Product      : ${productCount} rows`);
    console.log(`Transaction  : ${transactionCount} rows`);
    console.log(`Category     : ${categoryCount} rows`);
    console.log(`Debt         : ${debtCount} rows`);
    console.log(`Bengkel      : ${bengkelCount} rows`);
  } catch (error) {
    console.error('Error querying database:', error);
  } finally {
    await prisma.$disconnect();
  }
}

main();
