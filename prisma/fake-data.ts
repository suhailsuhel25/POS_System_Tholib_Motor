import { TransactionStatus, UserRole, Brand } from '@prisma/client';
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
    buyPrice: 0,
    category: faker.lorem.words(5),
    createdAt: new Date(),
    masterCategory: faker.lorem.words(5),
    sellPrice: 0,
    skuManual: faker.lorem.words(5),
    updatedAt: faker.date.anytime(),
  };
}
export function fakeProduct() {
  return {
    sellprice: faker.number.float(),
  };
}
export function fakeProductComplete() {
  return {
    id: faker.string.uuid(),
    productId: faker.string.uuid(),
    sellprice: faker.number.float(),
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
  };
}
export function fakeTransactionComplete() {
  return {
    id: faker.string.uuid(),
    totalAmount: undefined,
    paymentAmount: 0,
    changeAmount: 0,
    status: TransactionStatus.SUKSES,
    isComplete: false,
    createdAt: new Date(),
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
