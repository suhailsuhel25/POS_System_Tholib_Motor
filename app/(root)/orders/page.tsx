'use client';

import React, { useEffect, useState, useCallback, useRef } from 'react';
import axios from '@/lib/axios';
import { Plus, Minus, Trash2, CreditCard, ShoppingBag, Search, X, ChevronDown, Store, Receipt, Barcode } from 'lucide-react';
import { toast } from 'react-toastify';
import { Button } from '@/components/ui/button';
import { BluetoothPrinterService } from '@/lib/services/bluetooth-printer';
import { buildReceiptBase64 } from '@/lib/services/receipt-builder';
import { ErrorAlert } from '@/components/ErrorAlert';
import { SuccessAlert } from '@/components/SuccessAlert';
import { ReceiptDialog } from '@/components/ReceiptDialog';
import { CartPaymentSection } from '@/components/CartPaymentSection';

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
  barcode?: string;
}

interface CartItem {
  id: string;
  name: string;
  brand?: string;
  price: number;
  quantity: number;
}

interface ApiResponse {
  products: Product[];
  totalCount: number;
  categories: string[];
  masterCategories: string[];
  pagination: { limit: number; offset: number; hasMore: boolean };
}

const QUICK_PAYMENTS = [
  { label: '10K', value: 10000 },
  { label: '20K', value: 20000 },
  { label: '50K', value: 50000 },
  { label: '100K', value: 100000 },
];

export default function KasirPage() {
  const [activeBrand, setActiveBrand] = useState<Brand>('HONDA');
  const [products, setProducts] = useState<Product[]>([]);
  const [masterCategories, setMasterCategories] = useState<string[]>([]);
  const [selectedMasterCategory, setSelectedMasterCategory] = useState('');
  const [cart, setCart] = useState<CartItem[]>([]);
  const [loading, setLoading] = useState(true);
  const [searchQuery, setSearchQuery] = useState('');
  const [totalCount, setTotalCount] = useState(0);
  const [hasMore, setHasMore] = useState(false);
  const [offset, setOffset] = useState(0);
  const [loadingMore, setLoadingMore] = useState(false);
  const [paymentAmount, setPaymentAmount] = useState<number>(0);
  const [rawPaymentInput, setRawPaymentInput] = useState('');

  const [rawDiscountInput, setRawDiscountInput] = useState('');
  const [isHutang, setIsHutang] = useState(false);
  const [hutangCustomerName, setHutangCustomerName] = useState('');
  const [hutangNotes, setHutangNotes] = useState('');
  const [showHutangModal, setShowHutangModal] = useState(false);
  const [errorAlert, setErrorAlert] = useState({ open: false, message: '' });
  const [successAlert, setSuccessAlert] = useState({ open: false, message: '', title: '' });
  const [receiptDialogOpen, setReceiptDialogOpen] = useState(false);
  const [receiptData, setReceiptData] = useState<any>(null);
  const [processingPayment, setProcessingPayment] = useState(false);
  const [showCart, setShowCart] = useState(false);
  const searchRef = useRef<HTMLInputElement>(null);
  const barcodeRef = useRef<HTMLInputElement>(null);

  const LIMIT = 50;

  const handleSearchKeyDown = async (e: React.KeyboardEvent<HTMLInputElement>) => {
    if (e.key === 'Enter' && searchQuery.trim() !== '') {
      e.preventDefault();
      const barcode = searchQuery.trim();
      setSearchQuery('');
      try {
        const res = await axios.get<ApiResponse>(`/api/product?search=${encodeURIComponent(barcode)}&limit=50&offset=0&skipCount=true`);
        const found = res.data.products.find(
          (p: Product) => p.skuManual === barcode || (p as any).barcode === barcode
        );
        if (found) {
          addToCart(found);
        }
      } catch { /* silently fail */ }
    }
  };

  const fetchProducts = useCallback(async (reset = true) => {
    if (reset) { setLoading(true); setOffset(0); } else { setLoadingMore(true); }
    try {
      const params = new URLSearchParams({ brand: activeBrand, limit: LIMIT.toString(), offset: reset ? '0' : offset.toString() });
      if (searchQuery) params.set('search', searchQuery);
      if (selectedMasterCategory) params.set('masterCategory', selectedMasterCategory);
      if (!reset) params.set('skipCount', 'true');
      const response = await axios.get<ApiResponse>(`/api/product?${params}`);
      const data = response.data;
      if (reset) { setProducts(data.products); setMasterCategories(data.masterCategories); }
      else { setProducts((prev) => [...prev, ...data.products]); }
      setTotalCount(data.totalCount);
      setHasMore(data.pagination.hasMore);
      setOffset((prev) => (reset ? LIMIT : prev + LIMIT));
    } catch (error) { console.error('Error fetching products:', error); }
    finally { setLoading(false); setLoadingMore(false); }
  }, [activeBrand, searchQuery, selectedMasterCategory, offset]);

  useEffect(() => { setSelectedMasterCategory(''); setSearchQuery(''); fetchProducts(true); }, [activeBrand]);
  useEffect(() => { const t = setTimeout(() => fetchProducts(true), 300); return () => clearTimeout(t); }, [searchQuery, selectedMasterCategory]);

  const addToCart = (product: Product) => {
    setCart((prev) => {
      const existing = prev.find((item) => item.id === product.id);
      if (existing) return prev.map((item) => item.id === product.id ? { ...item, quantity: item.quantity + 1 } : item);
      return [...prev, { id: product.id, name: product.name, price: product.sellPrice, quantity: 1 }];
    });
  };

  const updateQuantity = (id: string, delta: number) => {
    setCart((prev) => prev.map((item) => item.id === id ? { ...item, quantity: Math.max(0, item.quantity + delta) } : item).filter((item) => item.quantity > 0));
  };

  const removeFromCart = (id: string) => setCart((prev) => prev.filter((item) => item.id !== id));
  const clearCart = () => { setCart([]); setPaymentAmount(0); setRawPaymentInput(''); setRawDiscountInput(''); };

  const subtotal = cart.reduce((sum, item) => sum + item.price * item.quantity, 0);
  const discountPercent = Number(rawDiscountInput) || 0;
  const discountAmount = Math.max(0, Math.floor((subtotal * discountPercent) / 100));
  const total = Math.max(0, subtotal - discountAmount);
  const totalItems = cart.reduce((sum, item) => sum + item.quantity, 0);
  const cartBadge = cart.reduce((sum, item) => sum + item.quantity, 0);

  const processPayment = async () => {
    if (cart.length === 0) return;
    if (isHutang && !hutangCustomerName.trim()) { setErrorAlert({ open: true, message: 'Nama pelanggan wajib diisi untuk hutang' }); return; }
    setProcessingPayment(true);
    try {
      const items = cart.map(item => ({ id: item.id, quantity: item.quantity, price: item.price }));
      const changeAmount = paymentAmount >= total ? paymentAmount - total : 0;
      const response = await axios.post('/api/transactions', { items, paymentAmount, changeAmount, discountAmount });
      if (response.status === 201) {
        if (isHutang) {
          try { await axios.post('/api/debts', { customerName: hutangCustomerName, amount: total, transactionId: response.data.id, notes: hutangNotes }); } catch (e) { console.error('Failed to create debt:', e); }
        }
        setReceiptData({ id: response.data.id, items: cart, total, paymentAmount, changeAmount, discountAmount, subtotal });
        setReceiptDialogOpen(true);
        try {
          if (!BluetoothPrinterService.isNative()) {
            toast.warning('Pembayaran sukses! Fitur cetak struk via bluetooth hanya tersedia di Android.');
          } else {
            const mac = localStorage.getItem('printer_mac');
            if (mac) {
              const isEnabled = await BluetoothPrinterService.checkStatus();
              if (isEnabled) {
                const dataToPrint = await buildReceiptBase64({
                  storeName: 'Tholib Motor',
                  storeSubtitle: 'Bengkel Sepeda Motor',
                  storeAddress: 'Jl. Tebu No.20, RT.13/RW.7, Cakung Bar., Kec. Cakung, Kota Jakarta Timur 13910',
                  storePhone: '0821-1247-8537',
                  cashierName: 'Administrator',
                  transactionId: response.data.id,
                  createdAt: new Date(response.data.createdAt || new Date()),
                  items: cart.map(i => ({ name: i.name, brand: i.brand, qty: i.quantity, price: i.price })),
                  total,
                  paymentAmount,
                  changeAmount: paymentAmount - total,
                  discountAmount,
                  footerMessage: 'Barang yang sudah dibeli tidak dapat ditukar atau dikembalikan.',
                  appUrl: 'https://tholib-motor.vercel.app/'
                });
                await BluetoothPrinterService.printRawData(mac, dataToPrint);
                toast.success('Struk berhasil dicetak!');
              } else {
                toast.error('Gagal mencetak: Bluetooth tidak aktif');
              }
            } else {
              toast.error('Gagal mencetak: Printer belum diatur di menu Pengaturan Hardware');
            }
          }
        } catch (e: any) {
          console.error('Failed to print receipt', e);
          toast.error(`Gagal mencetak struk: ${e.message || 'Koneksi ke printer gagal'}`);
        }
      }
    } catch (error: any) {
      const errorMsg = error.response?.data?.error || 'Gagal memproses pembayaran';
      if (errorMsg.includes('Stok tidak mencukupi untuk: ')) {
        const names = errorMsg.replace('Stok tidak mencukupi untuk: ', '');
        setErrorAlert({ open: true, message: `Stok "${names}" tidak mencukupi.` });
      } else { setErrorAlert({ open: true, message: errorMsg }); }
    } finally { setProcessingPayment(false); }
  };

  // Auto-focus barcode input
  useEffect(() => { const t = setTimeout(() => barcodeRef.current?.focus(), 500); return () => clearTimeout(t); }, [showCart]);

  return (
    <div className="h-full flex flex-col">
      {/* MOBILE TOP BAR */}
      <div className="shrink-0 bg-white dark:bg-[#22272B] border-b border-[#DFE1E6] dark:border-[#2C333A] px-4 py-3">
        <div className="flex flex-col md:flex-row gap-3 items-stretch md:items-center">
          <div className="flex items-center gap-2 flex-1 min-w-0">
            <div className="flex gap-2 overflow-x-auto scrollbar-none flex-1">
              {brands.map((brand) => (
                <button key={brand} onClick={() => setActiveBrand(brand)}
                  className={`flex-none px-4 py-2 rounded-lg text-xs md:text-sm font-bold transition-all active:scale-95 ${
                    activeBrand === brand ? 'bg-[#0052CC] text-white shadow-sm' : 'bg-[#F4F5F7] dark:bg-[#2C333A] text-[#44546F] dark:text-[#9FADBC]'
                  }`}
                >{brand}</button>
              ))}
            </div>
            {/* Cart button - mobile only */}
            <button onClick={() => setShowCart(!showCart)}
              className={`lg:hidden relative p-2.5 rounded-lg active:scale-95 transition-all ${showCart ? 'bg-[#0052CC] text-white' : 'bg-[#F4F5F7] dark:bg-[#2C333A]'}`}
            >
              <ShoppingBag className="w-5 h-5" />
              {cartBadge > 0 && <span className="absolute -top-1 -right-1 w-5 h-5 bg-[#DE350B] text-white text-[9px] font-bold rounded-full flex items-center justify-center">{cartBadge}</span>}
            </button>
          </div>

          <div className="flex gap-2 flex-1 md:flex-[1.5] min-w-0">
            <div className="relative flex-1">
              <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-[#626F86]" />
              <input ref={searchRef} type="text" placeholder="Barcode / Nama..."
                value={searchQuery} onChange={(e) => setSearchQuery(e.target.value)} onKeyDown={handleSearchKeyDown}
                className="w-full h-10 pl-10 pr-6 text-sm rounded-lg border border-[#DFE1E6] dark:border-[#2C333A] bg-[#FAFBFC] dark:bg-[#1D2125] focus:ring-2 focus:ring-[#0052CC]/30 focus:border-[#0052CC] outline-none"
              />
              {searchQuery && <button onClick={() => setSearchQuery('')} className="absolute right-3 top-1/2 -translate-y-1/2 p-0.5"><X className="w-3.5 h-3.5 text-[#626F86]" /></button>}
            </div>
            <div className="relative w-36 md:w-44 shrink-0">
              <select value={selectedMasterCategory} onChange={(e) => setSelectedMasterCategory(e.target.value)}
                className="w-full h-10 pl-3 pr-8 text-xs md:text-sm rounded-lg border border-[#DFE1E6] dark:border-[#2C333A] bg-[#FAFBFC] dark:bg-[#1D2125] appearance-none cursor-pointer outline-none focus:ring-2 focus:ring-[#0052CC]/30"
              >
                <option value="">Semua</option>
                {masterCategories.map((cat) => <option key={cat} value={cat}>{cat}</option>)}
              </select>
              <ChevronDown className="absolute right-2 top-1/2 -translate-y-1/2 w-4 h-4 text-[#626F86] pointer-events-none" />
            </div>
          </div>
        </div>
      </div>

      {/* MAIN CONTENT - Side by side in landscape mobile, stacked in portrait */}
      <div className="flex-1 flex overflow-hidden min-h-0">
        {/* PRODUCTS GRID */}
        <div className={`flex-1 overflow-y-auto p-3 md:p-4 bg-[#F4F5F7] dark:bg-[#1D2125] min-w-0 ${
          showCart ? 'hidden landscape:block lg:block' : 'block'
        }`}>
          {loading ? (
            <div className="flex items-center justify-center h-full text-[#626F86] text-xs">Memuat...</div>
          ) : products.length === 0 ? (
            <div className="flex flex-col items-center justify-center h-full text-[#626F86]">
              <ShoppingBag className="w-8 h-8 mb-1 opacity-40" />
              <p className="text-xs">Kosong</p>
            </div>
          ) : (
            <>
              <div className="text-[10px] text-[#626F86] dark:text-[#8C9BAB] mb-2">{products.length}/{totalCount}</div>
              <div className={`grid gap-2 ${
                showCart 
                  ? 'grid-cols-2 md:grid-cols-2 lg:grid-cols-3' 
                  : 'grid-cols-2 md:grid-cols-3 lg:grid-cols-3 xl:grid-cols-4'
              }`}>
                {products.map((product) => (
                  <button key={product.id} onClick={() => addToCart(product)}
                    className="bg-white dark:bg-[#22272B] border border-[#DFE1E6] dark:border-[#2C333A] p-3 rounded-xl text-left active:scale-[0.97] active:bg-[#DEEBFF] dark:active:bg-[#0747A6]/20 transition-all min-h-[80px]"
                  >
                    <div className="text-xs font-medium text-[#172B4D] dark:text-[#B6C2CF] line-clamp-2 leading-snug">{product.name}</div>
                    <div className="text-sm font-bold text-[#0052CC] dark:text-[#579DFF] mt-1.5">Rp{product.sellPrice.toLocaleString('id-ID')}</div>
                    <div className={`text-[10px] mt-1 ${product.stock <= 5 ? 'text-[#DE350B] font-semibold' : 'text-[#626F86]'}`}>
                      Stok: {product.stock}
                    </div>
                  </button>
                ))}
              </div>
              {hasMore && (
                <div className="mt-3 text-center">
                  <Button variant="outline" onClick={() => fetchProducts(false)} disabled={loadingMore} className="text-xs h-8 px-4">
                    {loadingMore ? '...' : `Muat Lebih (${products.length}/${totalCount})`}
                  </Button>
                </div>
              )}
            </>
          )}
        </div>

        {/* CART PANEL - Desktop + Landscape: side panel, Portrait mobile: overlay */}
        <div className={`bg-white dark:bg-[#22272B] border-l border-[#DFE1E6] dark:border-[#2C333A] min-w-0 ${
          showCart
            ? 'flex w-full md:w-[360px] landscape:w-[40%] landscape:max-w-[340px] flex-col'
            : 'hidden lg:flex w-[360px] xl:w-[400px] flex-col'
        }`}>
          <CartPanel
            cart={cart} totalItems={totalItems} total={total} subtotal={subtotal}
            updateQuantity={updateQuantity} removeFromCart={removeFromCart} clearCart={clearCart}
            rawDiscountInput={rawDiscountInput} setRawDiscountInput={setRawDiscountInput}
            discountAmount={discountAmount}
            rawPaymentInput={rawPaymentInput} setRawPaymentInput={setRawPaymentInput}
            paymentAmount={paymentAmount} setPaymentAmount={setPaymentAmount}
            processingPayment={processingPayment} isHutang={isHutang}
            processPayment={processPayment} setShowHutangModal={setShowHutangModal}
            onClose={() => setShowCart(false)}
            isMobile={true}
            barcodeRef={barcodeRef}
            addToCart={addToCart}
          />
        </div>
      </div>

      {/* MOBILE QUICK CART FAB */}
      {cart.length > 0 && !showCart && (
        <button onClick={() => setShowCart(true)}
          className="fixed bottom-16 right-3 z-20 w-12 h-12 bg-[#0052CC] text-white rounded-full shadow-lg flex items-center justify-center lg:hidden active:scale-95"
        >
          <ShoppingBag className="w-5 h-5" />
          <span className="absolute -top-1 -right-1 w-4 h-4 bg-[#DE350B] text-white text-[9px] font-bold rounded-full flex items-center justify-center">{cartBadge}</span>
        </button>
      )}

      {/* HUTANG MODAL */}
      {showHutangModal && (
        <div className="fixed inset-0 z-50 flex items-end md:items-center justify-center bg-black/50" onClick={() => setShowHutangModal(false)}>
          <div className="bg-white dark:bg-[#22272B] w-full md:max-w-md rounded-t-2xl md:rounded-2xl p-5 safe-area-bottom" onClick={(e) => e.stopPropagation()}>
            <h3 className="text-base font-bold text-[#172B4D] dark:text-white mb-4 flex items-center gap-2">
              <Receipt className="w-5 h-5 text-[#FF8B00]" /> Form Hutang
            </h3>
            <div className="space-y-3">
              <input type="text" placeholder="Nama pelanggan *" value={hutangCustomerName}
                onChange={(e) => setHutangCustomerName(e.target.value)}
                className="w-full h-12 px-4 text-sm border border-[#DFE1E6] dark:border-[#2C333A] rounded-lg outline-none focus:ring-2 focus:ring-[#FF8B00]/30"
              />
              <input type="text" placeholder="Catatan (opsional)" value={hutangNotes}
                onChange={(e) => setHutangNotes(e.target.value)}
                className="w-full h-12 px-4 text-sm border border-[#DFE1E6] dark:border-[#2C333A] rounded-lg outline-none focus:ring-2 focus:ring-[#FF8B00]/30"
              />
              <div className="p-3 bg-[#FFFAE6] rounded-lg text-center">
                <span className="text-sm text-[#626F86]">Total: </span>
                <span className="text-lg font-bold text-[#DE350B]">Rp{total.toLocaleString('id-ID')}</span>
              </div>
              <div className="flex gap-2">
                <button onClick={() => { setShowHutangModal(false); setIsHutang(false); setHutangCustomerName(''); setHutangNotes(''); }}
                  className="flex-1 h-12 rounded-lg border border-[#DFE1E6] dark:border-[#2C333A] font-bold text-sm"
                >Batal</button>
                <button onClick={() => { setIsHutang(true); setShowHutangModal(false); }}
                  disabled={!hutangCustomerName.trim()}
                  className="flex-1 h-12 rounded-lg bg-[#FF8B00] text-white font-bold text-sm disabled:opacity-50"
                >Simpan & Proses</button>
              </div>
            </div>
          </div>
        </div>
      )}

      <ErrorAlert open={errorAlert.open} onClose={() => setErrorAlert({ open: false, message: '' })} title="Transaksi Gagal" message={errorAlert.message} />
      <ReceiptDialog open={receiptDialogOpen} onClose={() => { setReceiptDialogOpen(false); clearCart(); fetchProducts(true); }} transactionData={receiptData} />
      <SuccessAlert open={successAlert.open} onClose={() => setSuccessAlert({ ...successAlert, open: false })} title={successAlert.title} message={successAlert.message} />
    </div>
  );
}

// ─── Cart Panel Component ───
function CartPanel({
  cart, totalItems, total, subtotal, updateQuantity, removeFromCart, clearCart,
  rawDiscountInput, setRawDiscountInput, discountAmount,
  rawPaymentInput, setRawPaymentInput, paymentAmount, setPaymentAmount,
  processingPayment, isHutang, processPayment, setShowHutangModal,
  isMobile, onClose, barcodeRef, addToCart,
}: {
  cart: CartItem[]; totalItems: number; total: number; subtotal: number;
  updateQuantity: (id: string, delta: number) => void; removeFromCart: (id: string) => void; clearCart: () => void;
  rawDiscountInput: string; setRawDiscountInput: (v: string) => void; discountAmount: number;
  rawPaymentInput: string; setRawPaymentInput: (v: string) => void; paymentAmount: number; setPaymentAmount: (v: number) => void;
  processingPayment: boolean; isHutang: boolean; processPayment: () => void; setShowHutangModal: (v: boolean) => void;
  isMobile?: boolean; onClose?: () => void; barcodeRef?: React.RefObject<HTMLInputElement>; addToCart?: (product: any) => void;
}) {
  return (
    <div className="flex flex-col h-full">
      {/* Header */}
      <div className="flex items-center justify-between px-3 py-2 landscape:py-1.5 border-b border-[#DFE1E6] dark:border-[#2C333A] shrink-0">
        <div className="flex items-center gap-2">
          {onClose && (
            <button onClick={onClose} className="lg:hidden p-1 -ml-1 rounded-lg hover:bg-[#EBECF0] dark:hover:bg-[#2C333A]"><X className="w-4 h-4 text-[#626F86]" /></button>
          )}
          <h2 className="text-xs md:text-sm font-bold text-[#172B4D] dark:text-white">Keranjang ({totalItems})</h2>
        </div>
        {cart.length > 0 && <button onClick={clearCart} className="text-[9px] font-bold text-[#DE350B] px-1.5 py-0.5 rounded hover:bg-[#FFEBE6]">Reset</button>}
      </div>

      {/* Barcode Scanner Input (mobile only) */}
      {isMobile && (
        <div className="px-3 py-1.5 border-b border-[#DFE1E6] dark:border-[#2C333A] shrink-0">
          <div className="relative">
            <Barcode className="absolute left-2.5 top-1/2 -translate-y-1/2 w-3.5 h-3.5 text-[#626F86]" />
            <input ref={barcodeRef} type="text" placeholder="Scan barcode..."
              className="w-full h-8 pl-8 pr-2 text-xs rounded-lg border border-[#DFE1E6] dark:border-[#2C333A] bg-[#FAFBFC] dark:bg-[#1D2125] outline-none focus:ring-2 focus:ring-[#0052CC]/30"
              onKeyDown={async (e) => {
                if (e.key === 'Enter') {
                  const barcode = (e.target as HTMLInputElement).value.trim();
                  if (!barcode) return;
                  (e.target as HTMLInputElement).value = '';
                  try {
                    const res = await axios.get(`/api/product?search=${encodeURIComponent(barcode)}&limit=50&offset=0&skipCount=true`);
                    const found = res.data.products.find((p: any) => p.skuManual === barcode || p.barcode === barcode);
                    if (found && addToCart) {
                      addToCart(found);
                    }
                  } catch { /* silently fail */ }
                }
              }}
            />
          </div>
        </div>
      )}

      {/* Cart Items */}
      <div className="flex-1 overflow-y-auto p-2 landscape:p-1.5 space-y-1.5 landscape:space-y-1">
        {cart.length === 0 ? (
          <div className="flex flex-col items-center justify-center h-full text-[#626F86] dark:text-[#8C9BAB]">
            <ShoppingBag className="w-8 h-8 mb-1 opacity-30" />
            <p className="text-[10px]">Kosong</p>
          </div>
        ) : (
          cart.map((item) => (
            <div key={item.id} className="bg-[#F4F5F7] dark:bg-[#2C333A] rounded-lg p-2 landscape:p-1.5">
              <div className="flex items-start justify-between gap-1.5">
                <div className="flex-1 min-w-0">
                  <div className="text-[10px] landscape:text-[9px] md:text-xs font-medium text-[#172B4D] dark:text-[#B6C2CF] line-clamp-2 leading-tight">{item.name}</div>
                  <div className="text-[9px] text-[#626F86] dark:text-[#8C9BAB] mt-0.5">Rp{item.price.toLocaleString('id-ID')}</div>
                </div>
                <button onClick={() => removeFromCart(item.id)} className="p-1 text-[#DE350B] hover:bg-[#FFEBE6] dark:hover:bg-[#4A1A1A] rounded shrink-0">
                  <Trash2 className="w-3 h-3" />
                </button>
              </div>
              <div className="flex items-center justify-between mt-1 landscape:mt-0.5">
                <div className="flex items-center gap-0.5 landscape:gap-px">
                  <button onClick={() => updateQuantity(item.id, -1)}
                    className="w-7 h-7 landscape:w-6 landscape:h-6 flex items-center justify-center bg-white dark:bg-[#1D2125] border border-[#DFE1E6] dark:border-[#3D4449] rounded text-[#44546F] dark:text-[#9FADBC] active:bg-[#EBECF0] dark:active:bg-[#3D4449] text-xs font-bold"
                  ><Minus className="w-3 h-3" /></button>
                  <span className="w-6 text-center text-xs font-bold text-[#172B4D] dark:text-[#B6C2CF]">{item.quantity}</span>
                  <button onClick={() => updateQuantity(item.id, 1)}
                    className="w-7 h-7 landscape:w-6 landscape:h-6 flex items-center justify-center bg-white dark:bg-[#1D2125] border border-[#DFE1E6] dark:border-[#3D4449] rounded text-[#44546F] dark:text-[#9FADBC] active:bg-[#EBECF0] dark:active:bg-[#3D4449] text-xs font-bold"
                  ><Plus className="w-3 h-3" /></button>
                  {[2, 5, 10].map(q => (
                    <button key={q} onClick={() => { const diff = q - item.quantity; if (diff !== 0) updateQuantity(item.id, diff); }}
                      className={`w-6 h-6 landscape:w-5 landscape:h-5 flex items-center justify-center rounded text-[8px] font-bold border ${
                        item.quantity === q ? 'bg-[#0052CC] text-white border-[#0052CC]' : 'bg-white dark:bg-[#1D2125] border-[#DFE1E6] dark:border-[#3D4449] text-[#626F86]'
                      } active:scale-95`}
                    >{q}</button>
                  ))}
                </div>
                <div className="text-[10px] md:text-xs font-bold text-[#172B4D] dark:text-[#B6C2CF]">
                  Rp{(item.price * item.quantity).toLocaleString('id-ID')}
                </div>
              </div>
            </div>
          ))
        )}
      </div>

      {/* Payment Summary */}
      <div className="border-t border-[#DFE1E6] dark:border-[#2C333A] p-2.5 landscape:p-2 md:p-3 space-y-2 landscape:space-y-1.5 shrink-0 safe-area-bottom">
        {/* Total */}
        <div className="flex justify-between items-center">
          <span className="text-[10px] font-bold text-[#626F86] dark:text-[#8C9BAB]">TOTAL</span>
          <span className="text-base landscape:text-sm md:text-lg font-black text-[#0052CC] dark:text-[#579DFF]">Rp{total.toLocaleString('id-ID')}</span>
        </div>

        {cart.length > 0 && (
          <>
            {/* Discount and Payment Section - side-by-side in landscape for vertical space optimization */}
            <div className="flex flex-col landscape:flex-row gap-1.5">
              {/* Discount */}
              <div className="flex-1">
                <input type="number" placeholder="Diskon (%)" value={rawDiscountInput}
                  onChange={(e) => setRawDiscountInput(e.target.value)}
                  className="w-full h-8 landscape:h-7 px-2 text-[10px] font-bold border border-[#DFE1E6] dark:border-[#2C333A] rounded outline-none focus:ring-2 focus:ring-[#0052CC]/30 bg-[#FAFBFC] dark:bg-[#1D2125]"
                />
              </div>

              {/* Manual Payment */}
              <div className="relative flex-1">
                <span className="absolute left-2 top-1/2 -translate-y-1/2 text-[9px] font-bold text-[#626F86] pointer-events-none">Rp</span>
                <input type="number" placeholder="Bayar" value={rawPaymentInput}
                  onChange={(e) => { setRawPaymentInput(e.target.value); setPaymentAmount(e.target.value ? Number(e.target.value) * 1000 : 0); }}
                  className="w-full h-8 landscape:h-7 pl-6 pr-2 text-[11px] font-bold border border-[#DFE1E6] dark:border-[#2C333A] rounded outline-none focus:ring-2 focus:ring-[#0052CC]/30 bg-[#FAFBFC] dark:bg-[#1D2125]"
                />
              </div>
            </div>

            {/* Quick Payment Buttons */}
            <div className="grid grid-cols-5 gap-1">
              {QUICK_PAYMENTS.map((qp) => (
                <button key={qp.value} onClick={() => { setPaymentAmount(qp.value); setRawPaymentInput((qp.value / 1000).toString()); }}
                  className={`h-8 landscape:h-7 rounded text-[9px] md:text-[10px] font-bold border transition-all active:scale-95 ${
                    paymentAmount === qp.value
                      ? 'bg-[#0052CC] text-white border-[#0052CC]'
                      : 'bg-white dark:bg-[#1D2125] border-[#DFE1E6] dark:border-[#2C333A] text-[#44546F] dark:text-[#9FADBC]'
                  }`}
                >{qp.label}</button>
              ))}
              <button onClick={() => { setPaymentAmount(total); setRawPaymentInput((total / 1000).toString()); }}
                className={`h-8 landscape:h-7 rounded text-[9px] md:text-[10px] font-bold border transition-all active:scale-95 ${
                  paymentAmount === total
                    ? 'bg-[#36B37E] text-white border-[#36B37E]'
                    : 'bg-white dark:bg-[#1D2125] border-[#DFE1E6] dark:border-[#2C333A] text-[#36B37E]'
                }`}
              >Pas</button>
            </div>

            {/* Change */}
            {paymentAmount > 0 && (
              <div className={`px-2 py-1.5 rounded flex justify-between items-center ${
                paymentAmount >= total ? 'bg-[#E3FCEF] dark:bg-[#1A3326] text-[#006644] dark:text-[#36B37E]' : 'bg-[#FFEBE6] dark:bg-[#331A1A] text-[#BF2600]'
              }`}>
                <span className="text-[8px] font-bold uppercase">{paymentAmount >= total ? 'Kembali' : 'Kurang'}</span>
                <span className="text-xs font-black">Rp{Math.abs(paymentAmount - total).toLocaleString('id-ID')}</span>
              </div>
            )}

            {/* Action Buttons */}
            <div className="flex gap-1.5">
              <button onClick={() => { setShowHutangModal(true); }}
                disabled={processingPayment}
                className="h-10 landscape:h-9 px-2.5 rounded-lg border border-[#FF8B00] text-[#FF8B00] font-bold text-[10px] active:bg-[#FFFAE6] disabled:opacity-50 shrink-0"
              >Hutang</button>
              <button onClick={processPayment}
                disabled={processingPayment || (!isHutang && paymentAmount < total)}
                className="flex-1 h-10 landscape:h-9 flex items-center justify-center gap-1 bg-[#0052CC] hover:bg-[#0747A6] text-white font-bold text-xs rounded-lg shadow-lg disabled:opacity-50 active:scale-[0.98]"
              >
                <CreditCard className="w-3.5 h-3.5" />
                {processingPayment ? '...' : 'Bayar'}
              </button>
            </div>
          </>
        )}
      </div>
    </div>
  );
}
