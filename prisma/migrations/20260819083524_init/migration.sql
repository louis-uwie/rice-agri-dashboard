-- CreateEnum
CREATE TYPE "UserRole" AS ENUM ('COOPERATIVE_HEAD', 'COOPERATIVE_ASSISTANT');

-- CreateEnum
CREATE TYPE "SeasonStatus" AS ENUM ('PLANNED', 'ACTIVE', 'HARVESTED');

-- CreateEnum
CREATE TYPE "TransactionType" AS ENUM ('PURCHASE', 'USAGE');

-- CreateEnum
CREATE TYPE "ExpenseType" AS ENUM ('DIESEL', 'MAINTENANCE', 'LABOR', 'OTHER');

-- CreateTable
CREATE TABLE "User" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "passwordHash" TEXT NOT NULL,
    "role" "UserRole" NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "User_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Farmer" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "contactNum" TEXT,
    "hectaresManaged" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Farmer_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "LandDivision" (
    "id" TEXT NOT NULL,
    "hectares" DOUBLE PRECISION NOT NULL,
    "location" TEXT,
    "farmerId" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "LandDivision_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "FarmVariety" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "pricePerKg" DOUBLE PRECISION NOT NULL,

    CONSTRAINT "FarmVariety_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Season" (
    "id" TEXT NOT NULL,
    "landDivisionId" TEXT NOT NULL,
    "farmVarietyId" TEXT NOT NULL,
    "cycleLabel" TEXT NOT NULL,
    "dateStarted" TIMESTAMP(3) NOT NULL,
    "dateHarvested" TIMESTAMP(3),
    "status" "SeasonStatus" NOT NULL DEFAULT 'PLANNED',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Season_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Category" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,

    CONSTRAINT "Category_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Product" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "categoryId" TEXT NOT NULL,
    "unit" TEXT NOT NULL,
    "lowStockThreshold" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Product_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "InventoryTransaction" (
    "id" TEXT NOT NULL,
    "seasonId" TEXT NOT NULL,
    "productId" TEXT NOT NULL,
    "type" "TransactionType" NOT NULL,
    "quantity" DOUBLE PRECISION NOT NULL,
    "transactionDate" TIMESTAMP(3) NOT NULL,
    "loggedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "loggedById" TEXT NOT NULL,

    CONSTRAINT "InventoryTransaction_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Expense" (
    "id" TEXT NOT NULL,
    "seasonId" TEXT NOT NULL,
    "type" "ExpenseType" NOT NULL,
    "description" TEXT,
    "amount" DOUBLE PRECISION NOT NULL,
    "expenseDate" TIMESTAMP(3) NOT NULL,
    "loggedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "loggedById" TEXT NOT NULL,

    CONSTRAINT "Expense_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "User_email_key" ON "User"("email");

-- CreateIndex
CREATE INDEX "LandDivision_farmerId_idx" ON "LandDivision"("farmerId");

-- CreateIndex
CREATE INDEX "Season_landDivisionId_idx" ON "Season"("landDivisionId");

-- CreateIndex
CREATE INDEX "Season_cycleLabel_idx" ON "Season"("cycleLabel");

-- CreateIndex
CREATE UNIQUE INDEX "Category_name_key" ON "Category"("name");

-- CreateIndex
CREATE INDEX "Product_categoryId_idx" ON "Product"("categoryId");

-- CreateIndex
CREATE INDEX "InventoryTransaction_seasonId_idx" ON "InventoryTransaction"("seasonId");

-- CreateIndex
CREATE INDEX "InventoryTransaction_productId_idx" ON "InventoryTransaction"("productId");

-- CreateIndex
CREATE INDEX "Expense_seasonId_idx" ON "Expense"("seasonId");

-- AddForeignKey
ALTER TABLE "LandDivision" ADD CONSTRAINT "LandDivision_farmerId_fkey" FOREIGN KEY ("farmerId") REFERENCES "Farmer"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Season" ADD CONSTRAINT "Season_landDivisionId_fkey" FOREIGN KEY ("landDivisionId") REFERENCES "LandDivision"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Season" ADD CONSTRAINT "Season_farmVarietyId_fkey" FOREIGN KEY ("farmVarietyId") REFERENCES "FarmVariety"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Product" ADD CONSTRAINT "Product_categoryId_fkey" FOREIGN KEY ("categoryId") REFERENCES "Category"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "InventoryTransaction" ADD CONSTRAINT "InventoryTransaction_seasonId_fkey" FOREIGN KEY ("seasonId") REFERENCES "Season"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "InventoryTransaction" ADD CONSTRAINT "InventoryTransaction_productId_fkey" FOREIGN KEY ("productId") REFERENCES "Product"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "InventoryTransaction" ADD CONSTRAINT "InventoryTransaction_loggedById_fkey" FOREIGN KEY ("loggedById") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Expense" ADD CONSTRAINT "Expense_seasonId_fkey" FOREIGN KEY ("seasonId") REFERENCES "Season"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Expense" ADD CONSTRAINT "Expense_loggedById_fkey" FOREIGN KEY ("loggedById") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
