import { PrismaClient } from "@prisma/client";

declare global {
  var prisma: PrismaClient | undefined;
}

// Configure Prisma with connection settings
const prismaClientSingleton = () => {
  return new PrismaClient({
    log: process.env.NODE_ENV === 'development' ? ['error', 'warn'] : ['error'],
    datasources: {
      db: {
        // Use DIRECT_URL for more stable connection in development
        url: process.env.NODE_ENV === 'development'
          ? process.env.DIRECT_URL || process.env.DATABASE_URL
          : process.env.DATABASE_URL,
      },
    },
  });
};

export const db = globalThis.prisma ?? prismaClientSingleton();

if (process.env.NODE_ENV !== "production") globalThis.prisma = db;