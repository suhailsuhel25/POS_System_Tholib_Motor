'use client';

import React, { useEffect, useState } from 'react';
import axios from 'axios';
import { Search, Filter, Plus, MoreHorizontal, AlertTriangle, ChevronDown, X, Trash2, Package } from 'lucide-react';
import { Button } from '@/components/ui/button';
import { Progress } from '@/components/ui/progress';
import { SuccessAlert } from '@/components/SuccessAlert';
import { ErrorAlert } from '@/components/ErrorAlert';
import {
  AlertDialog,
  AlertDialogAction,
  AlertDialogCancel,
  AlertDialogContent,
  AlertDialogDescription,
  AlertDialogFooter,
  AlertDialogHeader,
  AlertDialogTitle,
} from "@/components/ui/alert-dialog";
import { ProductFormModal } from '@/components/ProductFormModal';
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuLabel,
  DropdownMenuSeparator,
  DropdownMenuTrigger,
} from '@/components/ui/dropdown-menu';

interface Product {
  id: string;
  name: string;
  brand: string;
  category: string;
  masterCategory: string;
  skuManual: string;
  stock: number;
  buyPrice: number;
  sellPrice: number;
}

// Brand categories
const brands = ['HONDA', 'YAMAHA', 'KAWASAKI', 'SUZUKI'] as const;
type Brand = typeof brands[number];

export default function ProductList() {
  const [activeBrand, setActiveBrand] = useState<Brand>('HONDA');
  const [products, setProducts] = useState<Product[]>([]);
  const [masterCategories, setMasterCategories] = useState<string[]>([]);
  const [selectedMasterCategory, setSelectedMasterCategory] = useState<string>('');
  const [loading, setLoading] = useState(true);
  const [searchQuery, setSearchQuery] = useState('');
  const [totalCount, setTotalCount] = useState(0);
  const [offset, setOffset] = useState(0);
  const [hasMore, setHasMore] = useState(false);
  const [loadingMore, setLoadingMore] = useState(false);

  // Alert states
  const [successAlert, setSuccessAlert] = useState({ open: false, title: '', message: '' });
  const [errorAlert, setErrorAlert] = useState({ open: false, message: '' });

  // Delete state
  const [deleteId, setDeleteId] = useState<string | null>(null);
  const [deleting, setDeleting] = useState(false);

  // Modal state
  const [modalOpen, setModalOpen] = useState(false);
  const [selectedProduct, setSelectedProduct] = useState<Product | null>(null);

  const LIMIT = 50;

  const handleEdit = (product: Product) => {
    setSelectedProduct(product);
    setModalOpen(true);
  };

  const handleCreate = () => {
    setSelectedProduct(null);
    setModalOpen(true);
  };

  const onModalSuccess = () => {
    setSuccessAlert({
      open: true,
      title: 'Berhasil',
      message: selectedProduct ? 'Produk berhasil diperbarui.' : 'Produk baru berhasil ditambahkan.'
    });
    fetchProducts(true);
  };

  // Fetch products
  const fetchProducts = React.useCallback(async (reset = true) => {
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

      if (searchQuery) params.set('search', searchQuery);
      if (selectedMasterCategory) params.set('masterCategory', selectedMasterCategory);

      if (!reset) params.set('skipCount', 'true');

      const response = await axios.get(`/api/product?${params}`);
      const data = response.data;

      if (reset) {
        setProducts(data.products || []);
        setMasterCategories(data.masterCategories || []);
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

  // Initial fetch & Search debounce
  useEffect(() => {
    const timer = setTimeout(() => {
      fetchProducts(true);
    }, 500);
    return () => clearTimeout(timer);
  }, [searchQuery, selectedMasterCategory]);

  // Fetch when brand changes
  useEffect(() => {
    setSelectedMasterCategory('');
    setSearchQuery('');
    fetchProducts(true);
  }, [activeBrand]);

  // Delete handler
  const confirmDelete = (id: string, name: string) => {
    setDeleteId(id);
  };

  const handleDelete = async () => {
    if (!deleteId) return;

    try {
      setDeleting(true);
      await axios.delete(`/api/product/${deleteId}`);

      // Update UI
      setProducts(prev => prev.filter(p => p.id !== deleteId));
      setDeleteId(null);
      setSuccessAlert({
        open: true,
        title: 'Produk Dihapus',
        message: 'Produk berhasil dihapus dari inventaris.'
      });
      fetchProducts(true); // Refresh data
    } catch (error: any) {
      console.error('Delete error:', error);
      setDeleteId(null);
      setErrorAlert({
        open: true,
        message: error.response?.data?.error || 'Gagal menghapus produk.'
      });
    } finally {
      setDeleting(false);
    }
  };

  // Stock Level Indicator Component
  const StockIndicator = React.memo(({ stock }: { stock: number }) => {
    const maxStock = 50;
    const percentage = Math.min((stock / maxStock) * 100, 100);

    let colorClass = "bg-[#0052CC] dark:bg-[#0C66E4]";
    let textColor = "text-[#626F86] dark:text-[#8C9BAB]";

    if (stock <= 5) {
      colorClass = "bg-[#DE350B] dark:bg-[#FF5630]";
      textColor = "text-[#DE350B] dark:text-[#FF5630]";
    } else if (stock <= 20) {
      colorClass = "bg-[#FF991F] dark:bg-[#F5CD47]";
      textColor = "text-[#B65C02] dark:text-[#F5CD47]";
    }

    return (
      <div className="w-full max-w-[120px] flex items-center gap-3">
        <div className="h-2 flex-1 bg-[#EBECF0] dark:bg-[#2C333A] rounded-full overflow-hidden">
          <div
            className={`h-full rounded-full transition-all duration-500 ease-out ${colorClass}`}
            style={{ width: `${percentage}%` }}
          />
        </div>
        <span className={`text-sm font-semibold w-8 text-right ${textColor}`}>
          {stock}
        </span>
      </div>
    );
  });
  StockIndicator.displayName = 'StockIndicator';

  return (
    <div className="h-full flex flex-col">
      {/* Header */}
      <div className="h-14 flex items-center justify-between px-6 border-b border-[#DFE1E6] dark:border-[#2C333A] bg-white dark:bg-[#22272B]">
        <div className="flex items-center gap-2">
          <Package className="w-5 h-5 text-[#0052CC] dark:text-[#579DFF]" />
          <h1 className="text-base font-bold text-[#172B4D] dark:text-white">Stok Barang</h1>
        </div>
        <div className="flex items-center gap-2">
          <Button onClick={handleCreate} className="gap-2 font-medium bg-[#0052CC] hover:bg-[#0747A6] text-white">
            <Plus className="w-5 h-5" />
            Tambah Produk
          </Button>
        </div>
      </div>

      <div className="flex-1 flex flex-col p-6 space-y-5 overflow-y-auto">

        {/* Filters and Brands Container */}
        <div className="flex flex-col xl:flex-row gap-4 p-4 bg-white dark:bg-[#22272B] border border-[#DFE1E6] dark:border-[#2C333A] rounded-lg items-start xl:items-center justify-between">

          {/* Brand Tabs (Left Side - Stretched) */}
          <div className="flex gap-2 w-full xl:w-auto flex-1 overflow-x-auto pb-2 xl:pb-0">
            {brands.map((brand) => (
              <button
                key={brand}
                onClick={() => setActiveBrand(brand)}
                className={`
                  flex-1 px-4 py-3 rounded-md text-sm font-bold transition-all whitespace-nowrap
                  ${activeBrand === brand
                    ? 'bg-[#0052CC] text-white shadow-md'
                    : 'bg-[#F4F5F7] dark:bg-[#2C333A] text-[#44546F] dark:text-[#9FADBC] hover:bg-[#EBECF0] dark:hover:bg-[#3D4449]'
                  }
                `}
              >
                {brand}
              </button>
            ))}
          </div>

          {/* Search & Category (Right Side - Fixed) */}
          <div className="flex flex-col md:flex-row gap-3 w-full xl:w-auto items-center shrink-0">
            {/* Search */}
            <div className="relative w-full md:w-80">
              <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-5 h-5 text-[#626F86] dark:text-[#8C9BAB]" />
              <input
                type="text"
                placeholder="Cari nama produk..."
                value={searchQuery}
                onChange={(e) => setSearchQuery(e.target.value)}
                className="w-full h-11 pl-10 pr-10 rounded-md border border-[#DFE1E6] dark:border-[#2C333A] bg-white dark:bg-[#1D2125] text-base placeholder:text-[#626F86] dark:placeholder:text-[#8C9BAB] focus:outline-none focus:ring-2 focus:ring-[#0052CC] transition-all"
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

            {/* Category Filter */}
            <div className="relative w-full md:w-64">
              <select
                value={selectedMasterCategory}
                onChange={(e) => setSelectedMasterCategory(e.target.value)}
                className="w-full h-11 pl-4 pr-10 rounded-md border border-[#DFE1E6] dark:border-[#2C333A] bg-white dark:bg-[#1D2125] text-base appearance-none focus:outline-none focus:ring-2 focus:ring-[#0052CC] cursor-pointer"
              >
                <option value="">Semua Kategori</option>
                {masterCategories.map((cat) => (
                  <option key={cat} value={cat}>
                    {cat}
                  </option>
                ))}
              </select>
              <ChevronDown className="absolute right-3 top-1/2 -translate-y-1/2 w-5 h-5 text-[#626F86] pointer-events-none" />
            </div>
          </div>
        </div>

        {/* Table Container */}
        <div className="flex-1 border border-[#DFE1E6] dark:border-[#2C333A] bg-white dark:bg-[#22272B] rounded-lg overflow-hidden flex flex-col shadow-sm">
          <div
            className="flex-1 overflow-y-auto"
            onScroll={(e) => {
              const { scrollTop, scrollHeight, clientHeight } = e.currentTarget;
              if (scrollHeight - scrollTop <= clientHeight + 50 && hasMore && !loadingMore && !loading) {
                fetchProducts(false);
              }
            }}
          >
            <table className="w-full text-base text-left">
              <thead className="bg-[#F4F5F7] dark:bg-[#1D2125] text-[#44546F] dark:text-[#9FADBC] text-xs uppercase font-bold border-b border-[#DFE1E6] dark:border-[#2C333A] sticky top-0 z-10">
                <tr>
                  <th className="px-6 py-4 w-[35%]">Nama Produk</th>
                  <th className="px-6 py-4 w-[15%]">Kategori</th>
                  <th className="px-6 py-4 w-[20%]">Stok</th>
                  <th className="px-6 py-4 text-right w-[15%]">Harga Beli</th>
                  <th className="px-6 py-4 text-right w-[15%]">Harga Jual</th>
                  <th className="px-6 py-4 w-12"></th>
                </tr>
              </thead>
              <tbody className="divide-y divide-[#DFE1E6] dark:divide-[#2C333A]">
                {loading ? (
                  Array.from({ length: 5 }).map((_, i) => (
                    <tr key={i}>
                      <td colSpan={6} className="p-6 text-center">
                        <div className="h-4 bg-[#EBECF0] dark:bg-[#2C333A] rounded animate-pulse w-3/4 mx-auto mb-2" />
                      </td>
                    </tr>
                  ))
                ) : products.length === 0 ? (
                  <tr>
                    <td colSpan={6} className="p-12 text-center text-[#626F86] dark:text-[#8C9BAB]">
                      <div className="flex flex-col items-center justify-center">
                        <Search className="w-12 h-12 mb-4 opacity-20" />
                        <p className="text-lg font-medium">Tidak ada produk ditemukan</p>
                        <p className="text-sm">Coba ubah kata kunci pencarian atau filter kategori.</p>
                      </div>
                    </td>
                  </tr>
                ) : (
                  <>
                    {products.map((product) => (
                      <tr
                        key={product.id}
                        className="hover:bg-[#F4F5F7] dark:hover:bg-[#2C333A] transition-colors group"
                      >
                        <td className="px-6 py-4">
                          <div className="font-semibold text-[#172B4D] dark:text-[#B6C2CF] text-base">{product.name}</div>
                        </td>
                        <td className="px-6 py-4">
                          <span className="inline-flex items-center px-2.5 py-1 rounded text-sm font-medium bg-[#E9F2FF] text-[#0052CC] dark:bg-[#1C2B41] dark:text-[#579DFF]">
                            {product.masterCategory}
                          </span>
                        </td>
                        <td className="px-6 py-4">
                          <StockIndicator stock={product.stock} />
                        </td>
                        <td className="px-6 py-4 text-right text-[#626F86] dark:text-[#8C9BAB] font-mono">
                          Rp{product.buyPrice.toLocaleString('id-ID')}
                        </td>
                        <td className="px-6 py-4 text-right font-bold text-[#172B4D] dark:text-[#B6C2CF] font-mono">
                          Rp{product.sellPrice.toLocaleString('id-ID')}
                        </td>
                        <td className="px-6 py-4 text-right">
                          <DropdownMenu>
                            <DropdownMenuTrigger asChild>
                              <Button variant="ghost" size="icon" className="h-8 w-8 text-[#626F86] dark:text-[#8C9BAB] hover:text-[#172B4D] dark:hover:text-white hover:bg-[#EBECF0] dark:hover:bg-[#3D4449]">
                                <MoreHorizontal className="w-4 h-4" />
                              </Button>
                            </DropdownMenuTrigger>
                            <DropdownMenuContent align="end" className="w-48 bg-white dark:bg-[#22272B] border-[#DFE1E6] dark:border-[#2C333A]">
                              <DropdownMenuLabel className="text-[#626F86] dark:text-[#8C9BAB]">Aksi Produk</DropdownMenuLabel>
                              <DropdownMenuItem
                                onClick={() => handleEdit(product)}
                                className="cursor-pointer focus:bg-[#EBECF0] dark:focus:bg-[#3D4449]"
                              >
                                Ubah Detail
                              </DropdownMenuItem>

                              <DropdownMenuSeparator className="bg-[#DFE1E6] dark:bg-[#3D4449]" />
                              <DropdownMenuItem
                                onClick={() => confirmDelete(product.id, product.name)}
                                className="text-[#DE350B] focus:text-[#DE350B] focus:bg-[#FFEBE6] dark:focus:bg-[#4A1A1A] cursor-pointer"
                              >
                                Hapus Produk
                              </DropdownMenuItem>
                            </DropdownMenuContent>
                          </DropdownMenu>
                        </td>
                      </tr>
                    ))}
                    {loadingMore && (
                      <tr>
                        <td colSpan={6} className="p-4 text-center">
                          <div className="flex items-center justify-center gap-2 text-[#626F86] dark:text-[#8C9BAB]">
                            <div className="w-4 h-4 border-2 border-current border-t-transparent rounded-full animate-spin" />
                            <span>Memuat lebih banyak...</span>
                          </div>
                        </td>
                      </tr>
                    )}
                  </>
                )}
              </tbody>
            </table>
          </div>
        </div>

        {/* Product Form Modal */}
        <ProductFormModal
          open={modalOpen}
          onClose={() => setModalOpen(false)}
          initialData={selectedProduct}
          onSuccess={onModalSuccess}
          masterCategories={masterCategories}
        />

        {/* Delete Confirmation Dialog */}
        <AlertDialog open={!!deleteId} onOpenChange={(open) => !open && setDeleteId(null)}>
          <AlertDialogContent className="bg-white dark:bg-[#22272B] border-[#DFE1E6] dark:border-[#2C333A]">
            <AlertDialogHeader>
              <AlertDialogTitle>Hapus Produk?</AlertDialogTitle>
              <AlertDialogDescription>
                Tindakan ini tidak dapat dibatalkan. Produk akan dihapus permanen dari database.
              </AlertDialogDescription>
            </AlertDialogHeader>
            <AlertDialogFooter>
              <AlertDialogCancel onClick={() => setDeleteId(null)}>Batal</AlertDialogCancel>
              <AlertDialogAction
                onClick={handleDelete}
                className="bg-[#DE350B] hover:bg-[#BF2600] text-white"
              >
                {deleting ? 'Menghapus...' : 'Hapus'}
              </AlertDialogAction>
            </AlertDialogFooter>
          </AlertDialogContent>
        </AlertDialog>

        {/* Success Alert */}
        <SuccessAlert
          open={successAlert.open}
          onClose={() => setSuccessAlert({ ...successAlert, open: false })}
          title={successAlert.title}
          message={successAlert.message}
        />

        {/* Error Alert */}
        <ErrorAlert
          open={errorAlert.open}
          onClose={() => setErrorAlert({ open: false, message: '' })}
          title="Gagal"
          message={errorAlert.message}
        />
      </div>
    </div>
  );
}
