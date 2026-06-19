import { TransactionStatus, UserRole, Brand, ExpenseCategory } from '@prisma/client';
import { faker } from '@faker-js/faker';
import Decimal from 'decimal.js';



export function fakeUser() {
  return {
    name: faker.person.fullName(),
    username: faker.internet.userName(),
    email: undefined,
    emailVerified: undefined,
    image: undefined,
    password: undefined,
  };
}
export function fakeUserComplete() {
  return {
    id: faker.string.uuid(),
    name: faker.person.fullName(),
    username: faker.internet.userName(),
    email: undefined,
    emailVerified: undefined,
    image: undefined,
    password: undefined,
    role: UserRole.UNKNOW,
  };
}
export function fakeProductStock() {
  return {
    name: faker.person.fullName(),
    imageProduct: undefined,
    brand: faker.helpers.arrayElement([Brand.HONDA, Brand.YAMAHA, Brand.KAWASAKI, Brand.SUZUKI] as const),
    category: faker.lorem.words(5),
    masterCategory: faker.lorem.words(5),
    skuManual: faker.lorem.words(5),
    barcode: undefined,
    updatedAt: faker.date.anytime(),
  };
}
export function fakeProductStockComplete() {
  return {
    id: faker.string.uuid(),
    name: faker.person.fullName(),
    imageProduct: undefined,
    stock: 0,
    brand: faker.helpers.arrayElement([Brand.HONDA, Brand.YAMAHA, Brand.KAWASAKI, Brand.SUZUKI] as const),
    buyPrice: new Decimal(0),
    category: faker.lorem.words(5),
    createdAt: new Date(),
    masterCategory: faker.lorem.words(5),
    sellPrice: new Decimal(0),
    skuManual: faker.lorem.words(5),
    barcode: undefined,
    updatedAt: faker.date.anytime(),
  };
}
export function fakeProduct() {
  return {
    sellprice: new Decimal(faker.number.float()),
  };
}
export function fakeProductComplete() {
  return {
    id: faker.string.uuid(),
    productId: faker.string.uuid(),
    sellprice: new Decimal(faker.number.float()),
  };
}
export function fakeOnSaleProduct() {
  return {
    quantity: faker.number.int(),
  };
}
export function fakeOnSaleProductComplete() {
  return {
    id: faker.string.uuid(),
    productId: faker.string.uuid(),
    quantity: faker.number.int(),
    saledate: new Date(),
    transactionId: faker.string.uuid(),
  };
}
export function fakeTransaction() {
  return {
    totalAmount: undefined,
    deletedAt: undefined,
  };
}
export function fakeTransactionComplete() {
  return {
    totalAmount: undefined,
    createdAt: new Date(),
    id: faker.string.uuid(),
    isComplete: false,
    changeAmount: new Decimal(0),
    paymentAmount: new Decimal(0),
    discountAmount: new Decimal(0),
    status: TransactionStatus.SUKSES,
    deletedAt: undefined,
  };
}
export function fakeShopData() {
  return {
    name: undefined,
  };
}
export function fakeShopDataComplete() {
  return {
    id: faker.string.uuid(),
    name: undefined,
  };
}
export function fakeDebt() {
  return {
    customerName: faker.lorem.words(5),
    amount: new Decimal(faker.number.float()),
    notes: undefined,
    paidAt: undefined,
    updatedAt: faker.date.anytime(),
  };
}
export function fakeDebtComplete() {
  return {
    id: faker.string.uuid(),
    customerName: faker.lorem.words(5),
    amount: new Decimal(faker.number.float()),
    transactionId: faker.string.uuid(),
    notes: undefined,
    isPaid: false,
    paidAt: undefined,
    createdAt: new Date(),
    updatedAt: faker.date.anytime(),
  };
}
export function fakeCategory() {
  return {
    name: faker.person.fullName(),
  };
}
export function fakeCategoryComplete() {
  return {
    id: faker.string.uuid(),
    name: faker.person.fullName(),
    createdAt: new Date(),
  };
}
export function fakeExpense() {
  return {
    description: faker.lorem.words(5),
    amount: new Decimal(faker.number.float()),
    notes: undefined,
    updatedAt: faker.date.anytime(),
  };
}
export function fakeExpenseComplete() {
  return {
    id: faker.string.uuid(),
    description: faker.lorem.words(5),
    amount: new Decimal(faker.number.float()),
    category: ExpenseCategory.LAINNYA,
    notes: undefined,
    createdAt: new Date(),
    updatedAt: faker.date.anytime(),
  };
}
