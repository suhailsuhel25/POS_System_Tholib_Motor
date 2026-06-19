import * as z from 'zod';

// ─── Enums ───
const VALID_BRANDS = ['HONDA', 'YAMAHA', 'KAWASAKI', 'SUZUKI'] as const;
const VALID_TRANSACTION_STATUS = ['SUKSES', 'RETUR', 'HUTANG'] as const;

// ─── Product Schemas ───

export const createProductSchema = z.object({
  name: z
    .string({ required_error: 'Nama produk wajib diisi' })
    .min(2, 'Nama produk minimal 2 karakter'),
  brand: z
    .string({ required_error: 'Brand wajib dipilih' })
    .transform((val) => val.toUpperCase())
    .refine((val) => VALID_BRANDS.includes(val as any), {
      message: `Brand harus salah satu dari: ${VALID_BRANDS.join(', ')}`,
    }),
  category: z.string().optional().default(''),
  masterCategory: z.string().optional().default(''),
  skuManual: z.string().optional(),
  barcode: z.string().nullable().optional(),
  buyPrice: z
    .number({ required_error: 'Harga beli wajib diisi' })
    .min(0, 'Harga beli tidak boleh negatif')
    .default(0),
  sellPrice: z
    .number({ required_error: 'Harga jual wajib diisi' })
    .min(0, 'Harga jual tidak boleh negatif')
    .default(0),
  stock: z
    .number({ required_error: 'Stok wajib diisi' })
    .int('Stok harus bilangan bulat')
    .min(0, 'Stok tidak boleh negatif')
    .default(0),
  imageProduct: z.string().nullable().optional(),
});

export const updateProductSchema = z.object({
  name: z.string().min(2, 'Nama produk minimal 2 karakter').optional(),
  brand: z
    .string()
    .transform((val) => val.toUpperCase())
    .refine((val) => VALID_BRANDS.includes(val as any), {
      message: `Brand harus salah satu dari: ${VALID_BRANDS.join(', ')}`,
    })
    .optional(),
  category: z.string().optional(),
  masterCategory: z.string().optional(),
  barcode: z.string().nullable().optional(),
  buyPrice: z.number().min(0, 'Harga beli tidak boleh negatif').optional(),
  sellPrice: z.number().min(0, 'Harga jual tidak boleh negatif').optional(),
  stock: z
    .number()
    .int('Stok harus bilangan bulat')
    .min(0, 'Stok tidak boleh negatif')
    .optional(),
});

// ─── Transaction Schemas ───

const transactionItemSchema = z.object({
  id: z.string({ required_error: 'ID produk wajib diisi' }).min(1, 'ID produk tidak boleh kosong'),
  quantity: z
    .number({ required_error: 'Jumlah wajib diisi' })
    .int('Jumlah harus bilangan bulat')
    .positive('Jumlah harus lebih dari 0'),
  price: z
    .number({ required_error: 'Harga wajib diisi' })
    .min(0, 'Harga tidak boleh negatif'),
});

export const createTransactionSchema = z.object({
  items: z
    .array(transactionItemSchema, { required_error: 'Daftar produk wajib diisi' })
    .min(1, 'Keranjang tidak boleh kosong'),
  paymentAmount: z.number().min(0, 'Jumlah pembayaran tidak boleh negatif').default(0),
  changeAmount: z.number().min(0, 'Jumlah kembalian tidak boleh negatif').default(0),
  discountAmount: z.number().min(0, 'Diskon tidak boleh negatif').default(0),
});

export const updateTransactionSchema = z.object({
  status: z
    .enum(VALID_TRANSACTION_STATUS, {
      errorMap: () => ({ message: `Status harus salah satu dari: ${VALID_TRANSACTION_STATUS.join(', ')}` }),
    })
    .optional(),
  totalAmount: z.number().min(0).optional(),
  isComplete: z.boolean().optional(),
});

// ─── OnSaleProduct Schemas ───

export const createOnSaleSchema = z.object({
  productId: z.string({ required_error: 'ID produk wajib diisi' }).min(1, 'ID produk tidak boleh kosong'),
  transactionId: z
    .string({ required_error: 'ID transaksi wajib diisi' })
    .min(1, 'ID transaksi tidak boleh kosong'),
  qTy: z
    .number({ required_error: 'Jumlah wajib diisi' })
    .int('Jumlah harus bilangan bulat')
    .positive('Jumlah harus lebih dari 0'),
});

export const updateOnSaleSchema = z.object({
  qTy: z
    .number({ required_error: 'Jumlah wajib diisi' })
    .int('Jumlah harus bilangan bulat')
    .positive('Jumlah harus lebih dari 0'),
});

// ─── Restock Schemas ───

export const restockBulkSchema = z.object({
  stock: z
    .number({ required_error: 'Jumlah stok wajib diisi' })
    .int('Stok harus bilangan bulat')
    .positive('Stok harus lebih dari 0'),
});

export const restockSingleSchema = z.object({
  stockProduct: z
    .number({ required_error: 'Jumlah stok wajib diisi' })
    .int('Stok harus bilangan bulat')
    .positive('Stok harus lebih dari 0'),
});

// ─── ShopData Schemas ───

export const updateShopDataSchema = z.object({
  storeName: z
    .string({ required_error: 'Nama toko wajib diisi' })
    .min(2, 'Nama toko minimal 2 karakter'),
});
