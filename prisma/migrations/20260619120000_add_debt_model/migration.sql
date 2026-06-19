-- CreateTable
CREATE TABLE "Debt" (
    "id" TEXT NOT NULL,
    "customerName" TEXT NOT NULL,
    "amount" DECIMAL(15,2) NOT NULL,
    "transactionId" TEXT NOT NULL,
    "notes" TEXT,
    "isPaid" BOOLEAN NOT NULL DEFAULT false,
    "paidAt" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Debt_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "Debt_transactionId_key" ON "Debt"("transactionId");

-- CreateIndex
CREATE INDEX "Debt_customerName_idx" ON "Debt"("customerName");

-- CreateIndex
CREATE INDEX "Debt_isPaid_idx" ON "Debt"("isPaid");

-- CreateIndex
CREATE INDEX "Debt_createdAt_idx" ON "Debt"("createdAt");

-- AddForeignKey
ALTER TABLE "Debt" ADD CONSTRAINT "Debt_transactionId_fkey" FOREIGN KEY ("transactionId") REFERENCES "Transaction"("id") ON DELETE CASCADE ON UPDATE CASCADE;
