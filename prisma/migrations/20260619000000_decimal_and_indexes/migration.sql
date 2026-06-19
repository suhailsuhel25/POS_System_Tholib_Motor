-- AlterTable: Float to Decimal for monetary fields
ALTER TABLE "ProductStock" ALTER COLUMN "buyPrice" SET DATA TYPE DECIMAL(15,2) USING "buyPrice"::DECIMAL(15,2);
ALTER TABLE "ProductStock" ALTER COLUMN "sellPrice" SET DATA TYPE DECIMAL(15,2) USING "sellPrice"::DECIMAL(15,2);
ALTER TABLE "Product" ALTER COLUMN "sellprice" SET DATA TYPE DECIMAL(15,2) USING "sellprice"::DECIMAL(15,2);
ALTER TABLE "Transaction" ALTER COLUMN "paymentAmount" SET DATA TYPE DECIMAL(15,2) USING COALESCE("paymentAmount", 0)::DECIMAL(15,2);
ALTER TABLE "Transaction" ALTER COLUMN "changeAmount" SET DATA TYPE DECIMAL(15,2) USING COALESCE("changeAmount", 0)::DECIMAL(15,2);
ALTER TABLE "Transaction" ALTER COLUMN "discountAmount" SET DATA TYPE DECIMAL(15,2) USING COALESCE("discountAmount", 0)::DECIMAL(15,2);

-- AlterTable: Add deletedAt to Transaction
ALTER TABLE "Transaction" ADD COLUMN "deletedAt" TIMESTAMP(3);

-- AlterTable: Add unique constraint on User.username
ALTER TABLE "User" ADD CONSTRAINT "User_username_key" UNIQUE ("username");

-- AlterTable: Add unique constraint on OnSaleProduct
ALTER TABLE "OnSaleProduct" ADD CONSTRAINT "OnSaleProduct_productId_transactionId_key" UNIQUE ("productId", "transactionId");

-- CreateIndex: Add missing indexes
CREATE INDEX "Transaction_createdAt_idx" ON "Transaction"("createdAt");
CREATE INDEX "Transaction_status_idx" ON "Transaction"("status");
CREATE INDEX "OnSaleProduct_transactionId_idx" ON "OnSaleProduct"("transactionId");
