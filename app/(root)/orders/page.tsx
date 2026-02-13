'use client';

import React, { useEffect, useState, useCallback } from 'react';
import axios from 'axios';
import { Plus, Minus, Trash2, CreditCard, ShoppingBag, Search, X, ChevronDown, Store } from 'lucide-react';
import { Button } from '@/components/ui/button';
import { ErrorAlert } from '@/components/ErrorAlert';
import { SuccessAlert } from '@/components/SuccessAlert';
import { ReceiptDialog } from '@/components/ReceiptDialog';

// Brand categories
const brands = ['HONDA', 'YAMAHA', 'KAWASAKI', 'SUZUKI'] as const;
type Brand = typeof brands[number];

interface Product {
  id: string;
  name: string;
  brand: string;
  category: string;
  masterCategory: string;
  skuManual: string;
  buyPrice: number;
  sellPrice: number;
  stock: number;
}

interface CartItem {
  id: string;
  name: string;
  price: number;
  quantity: number;
}

interface ApiResponse {
  products: Product[];
  totalCount: number;
  categories: string[];
  masterCategories: string[];
  pagination: {
    limit: number;
    offset: number;
    hasMore: boolean;
  };
}

export default function KasirPage() {
  const [activeBrand, setActiveBrand] = useState<Brand>('HONDA');
  const [products, setProducts] = useState<Product[]>([]);
  const [masterCategories, setMasterCategories] = useState<string[]>([]);
  const [selectedMasterCategory, setSelectedMasterCategory] = useState<string>('');
  const [cart, setCart] = useState<CartItem[]>([]);
  const [loading, setLoading] = useState(true);
  const [searchQuery, setSearchQuery] = useState('');
  const [totalCount, setTotalCount] = useState(0);
  const [hasMore, setHasMore] = useState(false);
  const [offset, setOffset] = useState(0);
  const [loadingMore, setLoadingMore] = useState(false);
  const [paymentAmount, setPaymentAmount] = useState<number>(0);
  const [rawPaymentInput, setRawPaymentInput] = useState<string>('');

  // Error alert state
  const [errorAlert, setErrorAlert] = useState({ open: false, message: '' });

  // Success alert state
  const [successAlert, setSuccessAlert] = useState({ open: false, message: '', title: '' });

  // Receipt dialog state
  const [receiptDialogOpen, setReceiptDialogOpen] = useState(false);
  const [receiptData, setReceiptData] = useState<any>(null);

  const LIMIT = 50;

  // Fetch products with filters
  const fetchProducts = useCallback(async (reset = true) => {
    if (reset) {
      setLoading(true);
      setOffset(0);
    } else {
      setLoadingMore(true);
    }

    try {
      const params = new URLSearchParams({
        brand: activeBrand,
        limit: LIMIT.toString(),
        offset: reset ? '0' : offset.toString(),
      });

      if (searchQuery) {
        params.set('search', searchQuery);
      }

      if (selectedMasterCategory) {
        params.set('masterCategory', selectedMasterCategory);
      }

      // Skip count query on "load more" for better performance
      if (!reset) {
        params.set('skipCount', 'true');
      }

      const response = await axios.get<ApiResponse>(`/api/product?${params}`);
      const data = response.data;

      if (reset) {
        setProducts(data.products);
        setMasterCategories(data.masterCategories);
      } else {
        setProducts((prev) => [...prev, ...data.products]);
      }

      setTotalCount(data.totalCount);
      setHasMore(data.pagination.hasMore);
      setOffset((prev) => (reset ? LIMIT : prev + LIMIT));
    } catch (error) {
      console.error('Error fetching products:', error);
    } finally {
      setLoading(false);
      setLoadingMore(false);
    }
  }, [activeBrand, searchQuery, selectedMasterCategory, offset]);

  // Fetch when brand changes
  useEffect(() => {
    setSelectedMasterCategory('');
    setSearchQuery('');
    fetchProducts(true);
  }, [activeBrand]);

  // Debounced search
  useEffect(() => {
    const timer = setTimeout(() => {
      fetchProducts(true);
    }, 300);

    return () => clearTimeout(timer);
  }, [searchQuery, selectedMasterCategory]);

  // Add to cart
  const addToCart = (product: Product) => {
    setCart((prev) => {
      const existing = prev.find((item) => item.id === product.id);
      if (existing) {
        return prev.map((item) =>
          item.id === product.id ? { ...item, quantity: item.quantity + 1 } : item
        );
      }
      return [...prev, { id: product.id, name: product.name, price: product.sellPrice, quantity: 1 }];
    });
  };

  // Update quantity
  const updateQuantity = (id: string, delta: number) => {
    setCart((prev) =>
      prev
        .map((item) =>
          item.id === id ? { ...item, quantity: Math.max(0, item.quantity + delta) } : item
        )
        .filter((item) => item.quantity > 0)
    );
  };

  // Remove from cart
  const removeFromCart = (id: string) => {
    setCart((prev) => prev.filter((item) => item.id !== id));
  };

  // Clear cart
  const clearCart = () => {
    setCart([]);
    setPaymentAmount(0);
    setRawPaymentInput('');
  };

  // Process payment
  const [processingPayment, setProcessingPayment] = useState(false);

  const processPayment = async () => {
    if (cart.length === 0) return;

    setProcessingPayment(true);
    try {
      const items = cart.map(item => ({
        id: item.id,
        quantity: item.quantity,
        price: item.price,
      }));

      const changeAmount = paymentAmount >= total ? paymentAmount - total : 0;

      const response = await axios.post('/api/transactions', {
        items,
        paymentAmount,
        changeAmount
      });

      if (response.status === 201) {
        // Prepare receipt data
        setReceiptData({
          id: response.data.id,
          items: cart,
          total,
          paymentAmount,
          changeAmount
        });
        setReceiptDialogOpen(true);
      }
    } catch (error: any) {
      console.error('Payment error:', error);
      const errorMsg = error.response?.data?.error || 'Gagal memproses pembayaran';

      // Parse error message for insufficient stock
      if (errorMsg.includes('Insufficient stock for ')) {
        const productName = errorMsg.replace('Insufficient stock for ', '');
        setErrorAlert({
          open: true,
          message: `Stok barang "${productName}" tidak mencukupi. Silakan kurangi jumlah atau pilih produk lain.`
        });
      } else {
        setErrorAlert({
          open: true,
          message: errorMsg
        });
      }
    } finally {
      setProcessingPayment(false);
    }
  };

  // Calculate totals
  const subtotal = cart.reduce((sum, item) => sum + item.price * item.quantity, 0);
  const totalItems = cart.reduce((sum, item) => sum + item.quantity, 0);
  const total = subtotal;

  return (
    <div className="h-full flex flex-col">
      {/* Page Header */}
      <div className="h-14 flex items-center px-6 border-b border-[#DFE1E6] dark:border-[#2C333A] bg-white dark:bg-[#22272B]">
        <div className="flex items-center gap-2">
          <Store className="w-5 h-5 text-[#0052CC] dark:text-[#579DFF]" />
          <h1 className="text-base font-bold text-[#172B4D] dark:text-white">Kasir</h1>
        </div>
      </div>

      {/* Main Content */}
      <div className="flex-1 flex overflow-hidden">
        {/* LEFT SIDE - Products */}
        <div className="flex-1 flex flex-col border-r border-[#DFE1E6] dark:border-[#2C333A]">
          {/* Brand Tabs */}
          <div className="p-5 border-b border-[#DFE1E6] dark:border-[#2C333A] bg-white dark:bg-[#22272B]">
            <div className="flex gap-3 mb-4">
              {brands.map((brand) => (
                <button
                  key={brand}
                  onClick={() => setActiveBrand(brand)}
                  className={`
                    flex-1 px-5 py-3 rounded-md text-base font-semibold transition-all
                    ${activeBrand === brand
                      ? 'bg-[#0052CC] text-white'
                      : 'bg-[#F4F5F7] dark:bg-[#2C333A] text-[#44546F] dark:text-[#9FADBC] hover:bg-[#EBECF0] dark:hover:bg-[#3D4449]'
                    }
                  `}
                >
                  {brand}
                </button>
              ))}
            </div>

            {/* Search & Category Filter */}
            <div className="flex gap-3">
              {/* Search Input */}
              <div className="flex-1 relative">
                <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-5 h-5 text-[#626F86]" />
                <input
                  type="text"
                  placeholder="Cari nama produk..."
                  value={searchQuery}
                  onChange={(e) => setSearchQuery(e.target.value)}
                  className="w-full h-11 pl-11 pr-10 rounded-md border border-[#DFE1E6] dark:border-[#2C333A] bg-white dark:bg-[#1D2125] text-base placeholder:text-[#626F86] focus:outline-none focus:ring-2 focus:ring-[#0052CC] focus:border-transparent"
                />
                {searchQuery && (
                  <button
                    onClick={() => setSearchQuery('')}
                    className="absolute right-3 top-1/2 -translate-y-1/2 p-1 hover:bg-[#EBECF0] dark:hover:bg-[#2C333A] rounded"
                  >
                    <X className="w-4 h-4 text-[#626F86]" />
                  </button>
                )}
              </div>

              {/* Category Dropdown */}
              <div className="relative w-64">
                <select
                  value={selectedMasterCategory}
                  onChange={(e) => setSelectedMasterCategory(e.target.value)}
                  className="w-full h-11 pl-4 pr-10 rounded-md border border-[#DFE1E6] dark:border-[#2C333A] bg-white dark:bg-[#1D2125] text-base appearance-none focus:outline-none focus:ring-2 focus:ring-[#0052CC] focus:border-transparent cursor-pointer"
                >
                  <option value="">Semua Kategori</option>
                  {masterCategories.map((cat: string) => (
                    <option key={cat} value={cat}>
                      {cat}
                    </option>
                  ))}
                </select>
                <ChevronDown className="absolute right-3 top-1/2 -translate-y-1/2 w-5 h-5 text-[#626F86] pointer-events-none" />
              </div>
            </div>

            {/* Results count */}
            <div className="mt-3 text-sm text-[#626F86] dark:text-[#8C9BAB]">
              Menampilkan {products.length} dari {totalCount} produk
            </div>
          </div>

          {/* Product Grid */}
          <div className="flex-1 overflow-y-auto p-5 bg-[#F4F5F7] dark:bg-[#1D2125]">
            {loading ? (
              <div className="flex items-center justify-center h-full text-[#626F86]">
                Memuat produk...
              </div>
            ) : products.length === 0 ? (
              <div className="flex flex-col items-center justify-center h-full text-[#626F86]">
                <ShoppingBag className="w-14 h-14 mb-3 opacity-40" />
                <p className="text-lg">Tidak ada produk ditemukan</p>
                <p className="text-sm">Coba ubah filter atau kata kunci pencarian</p>
              </div>
            ) : (
              <>
                <div className="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-4">
                  {products.map((product) => (
                    <button
                      key={product.id}
                      onClick={() => addToCart(product)}
                      className="bg-white dark:bg-[#22272B] border border-[#DFE1E6] dark:border-[#2C333A] p-4 rounded-md text-left hover:border-[#0052CC] dark:hover:border-[#579DFF] hover:shadow-md transition-all group"
                    >
                      {/* Product Name */}
                      <div className="text-sm font-medium text-[#172B4D] dark:text-[#B6C2CF] line-clamp-2 mb-2 group-hover:text-[#0052CC] dark:group-hover:text-[#579DFF] min-h-[40px]">
                        {product.name}
                      </div>
                      {/* Price */}
                      <div className="text-lg font-bold text-[#0052CC] dark:text-[#579DFF]">
                        Rp{product.sellPrice.toLocaleString('id-ID')}
                      </div>
                      {/* Stock */}
                      <div className="text-xs text-[#626F86] dark:text-[#8C9BAB] mt-1">
                        Stok: <span className={product.stock <= 5 ? 'text-[#DE350B] font-semibold' : ''}>{product.stock}</span>
                      </div>
                    </button>
                  ))}
                </div>

                {/* Load More Button */}
                {hasMore && (
                  <div className="mt-6 text-center">
                    <Button
                      variant="outline"
                      onClick={() => fetchProducts(false)}
                      disabled={loadingMore}
                      className="px-8"
                    >
                      {loadingMore ? 'Memuat...' : `Muat Lebih Banyak (${products.length}/${totalCount})`}
                    </Button>
                  </div>
                )}
              </>
            )}
          </div>
        </div>

        {/* RIGHT SIDE - Cart & Transaction */}
        <div className="w-[420px] flex flex-col bg-white dark:bg-[#22272B]">
          {/* Cart Header */}
          <div className="p-5 border-b border-[#DFE1E6] dark:border-[#2C333A]">
            <h2 className="text-lg font-semibold text-[#172B4D] dark:text-[#B6C2CF]">
              Keranjang
            </h2>
            <p className="text-base text-[#626F86] dark:text-[#8C9BAB]">
              {totalItems} item
            </p>
          </div>

          {/* Cart Items */}
          <div className="flex-1 overflow-y-auto p-5 space-y-3">
            {cart.length === 0 ? (
              <div className="flex flex-col items-center justify-center h-full text-[#626F86] dark:text-[#8C9BAB]">
                <ShoppingBag className="w-12 h-12 mb-2 opacity-40" />
                <p className="text-base">Keranjang kosong</p>
                <p className="text-sm">Klik produk untuk menambahkan</p>
              </div>
            ) : (
              cart.map((item) => (
                <div
                  key={item.id}
                  className="bg-[#F4F5F7] dark:bg-[#2C333A] p-4 rounded-md"
                >
                  <div className="flex items-start justify-between mb-2">
                    <div className="flex-1 pr-2">
                      <div className="text-base font-medium text-[#172B4D] dark:text-[#B6C2CF] line-clamp-2">
                        {item.name}
                      </div>
                      <div className="text-sm text-[#626F86] dark:text-[#8C9BAB] mt-1">
                        Rp{item.price.toLocaleString('id-ID')} × {item.quantity}
                      </div>
                    </div>
                    <button
                      onClick={() => removeFromCart(item.id)}
                      className="p-2 text-[#DE350B] hover:bg-[#FFEBE6] dark:hover:bg-[#4A1A1A] rounded transition-colors"
                    >
                      <Trash2 className="w-5 h-5" />
                    </button>
                  </div>
                  <div className="flex items-center justify-between">
                    <div className="flex items-center gap-2">
                      <button
                        onClick={() => updateQuantity(item.id, -1)}
                        className="w-10 h-10 flex items-center justify-center bg-white dark:bg-[#1D2125] border border-[#DFE1E6] dark:border-[#3D4449] rounded text-[#44546F] dark:text-[#9FADBC] hover:bg-[#EBECF0] dark:hover:bg-[#3D4449]"
                      >
                        <Minus className="w-5 h-5" />
                      </button>
                      <span className="w-10 text-center text-lg font-semibold text-[#172B4D] dark:text-[#B6C2CF]">
                        {item.quantity}
                      </span>
                      <button
                        onClick={() => updateQuantity(item.id, 1)}
                        className="w-10 h-10 flex items-center justify-center bg-white dark:bg-[#1D2125] border border-[#DFE1E6] dark:border-[#3D4449] rounded text-[#44546F] dark:text-[#9FADBC] hover:bg-[#EBECF0] dark:hover:bg-[#3D4449]"
                      >
                        <Plus className="w-5 h-5" />
                      </button>
                    </div>
                    <div className="text-lg font-bold text-[#172B4D] dark:text-[#B6C2CF]">
                      Rp{(item.price * item.quantity).toLocaleString('id-ID')}
                    </div>
                  </div>
                </div>
              ))
            )}
          </div>

          {/* Payment Summary */}
          <div className="border-t border-[#DFE1E6] dark:border-[#2C333A] p-5 space-y-4">
            {/* Totals */}
            <div className="space-y-3">
              <div className="flex justify-between text-base text-[#626F86] dark:text-[#8C9BAB]">
                <span>Total Items</span>
                <span>{totalItems} item</span>
              </div>
              <div className="flex justify-between text-2xl font-black text-[#172B4D] dark:text-[#B6C2CF] pt-3 border-t border-[#DFE1E6] dark:border-[#2C333A]">
                <span>Total</span>
                <span className="text-[#0052CC] dark:text-[#579DFF]">Rp{total.toLocaleString('id-ID')}</span>
              </div>
            </div>

            {/* Payment Input Section */}
            {cart.length > 0 && (
              <div className="space-y-2 pt-2">
                <div className="flex items-center justify-between px-1">
                  <span className="text-[10px] font-bold text-[#626F86] dark:text-[#8C9BAB] uppercase tracking-wider">Input Pembayaran (Ribuan)</span>
                  {rawPaymentInput && (
                    <span className="text-[10px] font-medium text-[#0052CC] bg-[#DEEBFF] px-1.5 py-0.5 rounded">
                      Total: Rp{paymentAmount.toLocaleString('id-ID')}
                    </span>
                  )}
                </div>

                <div className="relative group">
                  <div className="absolute left-3 top-1/2 -translate-y-1/2 flex items-center gap-1 pointer-events-none">
                    <span className="text-sm font-bold text-[#44546F] dark:text-[#9FADBC]">Rp</span>
                  </div>
                  <input
                    type="number"
                    placeholder="Contoh: 50 untuk 50.000"
                    value={rawPaymentInput}
                    onChange={(e) => {
                      const val = e.target.value;
                      setRawPaymentInput(val);
                      setPaymentAmount(val ? Number(val) * 1000 : 0);
                    }}
                    className="w-full h-11 pl-9 pr-12 text-base font-bold bg-[#FAFBFC] dark:bg-[#1D2125] border border-[#DFE1E6] dark:border-[#2C333A] rounded-lg focus:ring-2 focus:ring-[#0052CC]/20 focus:border-[#0052CC] outline-none transition-all placeholder:text-[#A5ADBA] placeholder:font-normal placeholder:text-sm"
                  />
                  <div className="absolute right-3 top-1/2 -translate-y-1/2 pointer-events-none">
                    <span className="text-sm font-bold text-[#626F86] dark:text-[#8C9BAB] opacity-50">.000</span>
                  </div>
                </div>

                {paymentAmount > 0 && (
                  <div className={`mt-2 p-3 rounded-lg flex justify-between items-center animate-in fade-in slide-in-from-top-1 duration-200 ${paymentAmount >= total ? 'bg-[#E3FCEF] dark:bg-[#1A3326] text-[#006644] dark:text-[#36B37E] border border-[#ABF2D1]' : 'bg-[#FFEBE6] dark:bg-[#331A1A] text-[#BF2600] border border-[#FFBDAD]'}`}>
                    <span className="text-[10px] font-black uppercase tracking-tight">
                      {paymentAmount >= total ? 'Kembalian' : 'Kurang'}
                    </span>
                    <span className="text-base font-black">
                      Rp{Math.abs(paymentAmount - total).toLocaleString('id-ID')}
                    </span>
                  </div>
                )}
              </div>
            )}

            {/* Action Buttons */}
            <div className="flex gap-3 pt-2">
              <Button
                variant="outline"
                className="flex-1 h-12 font-bold"
                onClick={clearCart}
                disabled={cart.length === 0}
              >
                Reset
              </Button>
              <Button
                className="flex-1 h-12 gap-2 text-base font-bold shadow-lg"
                disabled={cart.length === 0 || processingPayment || paymentAmount < total}
                onClick={processPayment}
              >
                <CreditCard className="w-5 h-5" />
                {processingPayment ? 'Memproses...' : 'Selesaikan'}
              </Button>
            </div>
          </div>
        </div>
      </div>

      {/* Error Alert */}
      <ErrorAlert
        open={errorAlert.open}
        onClose={() => setErrorAlert({ open: false, message: '' })}
        title="Transaksi Gagal"
        message={errorAlert.message}
      />

      {/* Receipt Dialog */}
      <ReceiptDialog
        open={receiptDialogOpen}
        onClose={() => {
          setReceiptDialogOpen(false);
          clearCart();
          fetchProducts(true);
        }}
        transactionData={receiptData}
      />

      {/* Success Alert */}
      <SuccessAlert
        open={successAlert.open}
        onClose={() => setSuccessAlert({ ...successAlert, open: false })}
        title={successAlert.title}
        message={successAlert.message}
      />
    </div>
  );
}
