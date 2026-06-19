'use client';

import React, { useState, useEffect } from 'react';
import { Plus, Edit2, Trash2, Search, Loader2, X } from 'lucide-react';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { toast } from 'react-toastify';
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
  DialogDescription,
  DialogFooter,
} from '@/components/ui/dialog';
import {
  AlertDialog,
  AlertDialogAction,
  AlertDialogCancel,
  AlertDialogContent,
  AlertDialogDescription,
  AlertDialogFooter,
  AlertDialogHeader,
  AlertDialogTitle,
} from '@/components/ui/alert-dialog';
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuLabel,
  DropdownMenuSeparator,
  DropdownMenuTrigger,
} from '@/components/ui/dropdown-menu';
import { MoreHorizontal } from 'lucide-react';

type Category = {
  id: string;
  name: string;
};

export default function CategorySettingPage() {
  const [categories, setCategories] = useState<Category[]>([]);
  const [isLoading, setIsLoading] = useState(true);
  const [search, setSearch] = useState('');

  // Modal states
  const [isAddOpen, setIsAddOpen] = useState(false);
  const [isEditOpen, setIsEditOpen] = useState(false);
  const [deleteCategory, setDeleteCategory] = useState<Category | null>(null);

  // Form states
  const [selectedCategory, setSelectedCategory] = useState<Category | null>(null);
  const [categoryName, setCategoryName] = useState('');
  const [isSubmitting, setIsSubmitting] = useState(false);

  useEffect(() => {
    fetchCategories();
  }, []);

  const fetchCategories = async () => {
    setIsLoading(true);
    try {
      const res = await fetch('/api/categories');
      if (!res.ok) throw new Error('Failed to fetch');
      const data = await res.json();
      setCategories(data);
    } catch (error) {
      toast.error('Gagal mengambil data kategori');
    } finally {
      setIsLoading(false);
    }
  };

  const handleAdd = async () => {
    if (!categoryName.trim()) {
      toast.error('Nama kategori tidak boleh kosong');
      return;
    }
    setIsSubmitting(true);
    try {
      const res = await fetch('/api/categories', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ name: categoryName })
      });
      const data = await res.json();
      if (!res.ok) throw new Error(data.error || 'Failed to add');

      toast.success('Kategori berhasil ditambahkan');
      setIsAddOpen(false);
      setCategoryName('');
      fetchCategories();
    } catch (error: any) {
      toast.error(error.message);
    } finally {
      setIsSubmitting(false);
    }
  };

  const handleEdit = async () => {
    if (!categoryName.trim() || !selectedCategory) {
      toast.error('Nama kategori tidak boleh kosong');
      return;
    }
    setIsSubmitting(true);
    try {
      const res = await fetch(`/api/categories/${selectedCategory.id}`, {
        method: 'PUT',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ name: categoryName })
      });
      const data = await res.json();
      if (!res.ok) throw new Error(data.error || 'Failed to update');

      toast.success('Kategori berhasil diubah');
      setIsEditOpen(false);
      setSelectedCategory(null);
      setCategoryName('');
      fetchCategories();
    } catch (error: any) {
      toast.error(error.message);
    } finally {
      setIsSubmitting(false);
    }
  };

  const handleDelete = async () => {
    if (!deleteCategory) return;
    setIsSubmitting(true);
    try {
      const res = await fetch(`/api/categories/${deleteCategory.id}`, {
        method: 'DELETE'
      });
      const data = await res.json();
      if (!res.ok) throw new Error(data.error || 'Failed to delete');

      toast.success('Kategori berhasil dihapus');
      setDeleteCategory(null);
      fetchCategories();
    } catch (error: any) {
      toast.error(error.message);
    } finally {
      setIsSubmitting(false);
    }
  };

  const openEdit = (category: Category) => {
    setSelectedCategory(category);
    setCategoryName(category.name);
    setIsEditOpen(true);
  };

  const filteredCategories = categories.filter(c => c.name.toLowerCase().includes(search.toLowerCase()));

  return (
    <div className="p-6 max-w-4xl">
      <div className="mb-6">
        <h2 className="text-lg font-bold text-[#172B4D] dark:text-white mb-1">Kategori Barang</h2>
        <p className="text-sm text-[#626F86] dark:text-[#8C9BAB]">
          Kelola daftar kategori master untuk produk Anda.
        </p>
      </div>

      {/* Table with integrated toolbar — matches Product page structure */}
      <div className="bg-white dark:bg-[#22272B] border border-[#DFE1E6] dark:border-[#2C333A] rounded-lg shadow-sm overflow-hidden flex flex-col">
        {/* Toolbar */}
        <div className="p-4 border-b border-[#DFE1E6] dark:border-[#2C333A] flex flex-col sm:flex-row gap-4 justify-between items-center bg-[#FAFBFC] dark:bg-[#1D2125]">
          <div className="relative w-full sm:max-w-xs">
            <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-5 h-5 text-[#626F86] dark:text-[#8C9BAB]" />
            <input
              type="text"
              placeholder="Cari kategori..."
              value={search}
              onChange={(e) => setSearch(e.target.value)}
              className="w-full h-11 pl-10 pr-10 rounded-md border border-[#DFE1E6] dark:border-[#2C333A] bg-white dark:bg-[#1D2125] text-base placeholder:text-[#626F86] dark:placeholder:text-[#8C9BAB] focus:outline-none focus:ring-2 focus:ring-[#0052CC] transition-all"
            />
            {search && (
              <button onClick={() => setSearch('')} className="absolute right-3 top-1/2 -translate-y-1/2 p-1 hover:bg-[#EBECF0] dark:hover:bg-[#2C333A] rounded">
                <X className="w-4 h-4 text-[#626F86]" />
              </button>
            )}
          </div>
          <Button
            onClick={() => { setCategoryName(''); setIsAddOpen(true); }}
            className="w-full sm:w-auto bg-[#0052CC] hover:bg-[#0747A6] text-white gap-2 font-medium"
          >
            <Plus className="w-5 h-5" />
            Tambah Kategori
          </Button>
        </div>

        {/* Table */}
        <table className="w-full text-left">
          <thead className="bg-[#F4F5F7] dark:bg-[#1D2125] text-[#44546F] dark:text-[#9FADBC] text-xs uppercase font-bold border-b border-[#DFE1E6] dark:border-[#2C333A]">
            <tr>
              <th className="px-6 py-4 w-[50%]">Nama Kategori</th>
              <th className="px-6 py-4">Status</th>
              <th className="px-6 py-4 w-12"></th>
            </tr>
          </thead>
          <tbody className="divide-y divide-[#DFE1E6] dark:divide-[#2C333A]">
            {isLoading ? (
              Array.from({ length: 4 }).map((_, i) => (
                <tr key={i}>
                  <td colSpan={3} className="p-6 text-center">
                    <div className="h-4 bg-[#EBECF0] dark:bg-[#2C333A] rounded animate-pulse w-3/4 mx-auto" />
                  </td>
                </tr>
              ))
            ) : filteredCategories.length === 0 ? (
              <tr>
                <td colSpan={3} className="p-12 text-center text-[#626F86] dark:text-[#8C9BAB]">
                  <div className="flex flex-col items-center justify-center">
                    <Search className="w-12 h-12 mb-4 opacity-20" />
                    <p className="text-lg font-medium">Tidak ada kategori ditemukan</p>
                    <p className="text-sm">Klik tombol &quot;Tambah Kategori&quot; untuk membuat baru.</p>
                  </div>
                </td>
              </tr>
            ) : (
              filteredCategories.map((category) => (
                <tr key={category.id} className="hover:bg-[#F4F5F7] dark:hover:bg-[#2C333A] transition-colors group">
                  <td className="px-6 py-4">
                    <div className="font-semibold text-[#172B4D] dark:text-[#B6C2CF] text-base">{category.name}</div>
                  </td>
                  <td className="px-6 py-4">
                    <span className="inline-flex items-center px-2 py-0.5 rounded text-[10px] font-bold uppercase bg-[#E3FCEF] text-[#006644]">Aktif</span>
                  </td>
                  <td className="px-6 py-4 text-right">
                    <DropdownMenu>
                      <DropdownMenuTrigger asChild>
                        <Button variant="ghost" size="icon" className="h-8 w-8 text-[#626F86] dark:text-[#8C9BAB] hover:text-[#172B4D] dark:hover:text-white hover:bg-[#EBECF0] dark:hover:bg-[#3D4449]">
                          <MoreHorizontal className="w-4 h-4" />
                        </Button>
                      </DropdownMenuTrigger>
                      <DropdownMenuContent align="end" className="w-48 bg-white dark:bg-[#22272B] border-[#DFE1E6] dark:border-[#2C333A]">
                        <DropdownMenuLabel className="text-[#626F86] dark:text-[#8C9BAB]">Aksi Kategori</DropdownMenuLabel>
                        <DropdownMenuItem
                          onClick={() => openEdit(category)}
                          className="cursor-pointer focus:bg-[#EBECF0] dark:focus:bg-[#3D4449]"
                        >
                          Ubah Nama
                        </DropdownMenuItem>
                        <DropdownMenuSeparator className="bg-[#DFE1E6] dark:bg-[#3D4449]" />
                        <DropdownMenuItem
                          onClick={() => setDeleteCategory(category)}
                          className="text-[#DE350B] focus:text-[#DE350B] focus:bg-[#FFEBE6] dark:focus:bg-[#4A1A1A] cursor-pointer"
                        >
                          Hapus Kategori
                        </DropdownMenuItem>
                      </DropdownMenuContent>
                    </DropdownMenu>
                  </td>
                </tr>
              ))
            )}
          </tbody>
        </table>
      </div>

      {/* Add Dialog */}
      <Dialog open={isAddOpen} onOpenChange={setIsAddOpen}>
        <DialogContent className="sm:max-w-[420px] bg-white dark:bg-[#22272B] border-[#DFE1E6] dark:border-[#2C333A]">
          <DialogHeader>
            <DialogTitle className="text-[#172B4D] dark:text-white">Tambah Kategori Baru</DialogTitle>
            <DialogDescription className="text-[#626F86] dark:text-[#8C9BAB]">
              Buat kategori master baru untuk produk.
            </DialogDescription>
          </DialogHeader>
          <div className="py-4">
            <label className="text-xs font-bold text-[#44546F] dark:text-[#9FADBC] uppercase tracking-wider block mb-2">Nama Kategori</label>
            <Input
              placeholder="Contoh: SPAREPART"
              value={categoryName}
              onChange={(e) => setCategoryName(e.target.value.toUpperCase())}
              onKeyDown={(e) => e.key === 'Enter' && handleAdd()}
              autoFocus
              className="h-10 bg-[#FAFBFC] dark:bg-[#1D2125] border-[#DFE1E6] dark:border-[#2C333A]"
            />
          </div>
          <DialogFooter className="gap-2">
            <Button variant="outline" onClick={() => setIsAddOpen(false)} disabled={isSubmitting} className="border-[#DFE1E6] dark:border-[#2C333A]">Batal</Button>
            <Button onClick={handleAdd} disabled={isSubmitting} className="bg-[#0052CC] hover:bg-[#0747A6] text-white">
              {isSubmitting ? <><Loader2 className="w-4 h-4 animate-spin mr-2" />Menyimpan...</> : 'Simpan'}
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>

      {/* Edit Dialog */}
      <Dialog open={isEditOpen} onOpenChange={setIsEditOpen}>
        <DialogContent className="sm:max-w-[420px] bg-white dark:bg-[#22272B] border-[#DFE1E6] dark:border-[#2C333A]">
          <DialogHeader>
            <DialogTitle className="text-[#172B4D] dark:text-white">Edit Kategori</DialogTitle>
            <DialogDescription className="text-[#626F86] dark:text-[#8C9BAB]">
              Ubah nama kategori. Semua produk dengan kategori ini akan otomatis terupdate.
            </DialogDescription>
          </DialogHeader>
          <div className="py-4">
            <label className="text-xs font-bold text-[#44546F] dark:text-[#9FADBC] uppercase tracking-wider block mb-2">Nama Kategori Baru</label>
            <Input
              value={categoryName}
              onChange={(e) => setCategoryName(e.target.value.toUpperCase())}
              onKeyDown={(e) => e.key === 'Enter' && handleEdit()}
              autoFocus
              className="h-10 bg-[#FAFBFC] dark:bg-[#1D2125] border-[#DFE1E6] dark:border-[#2C333A]"
            />
          </div>
          <DialogFooter className="gap-2">
            <Button variant="outline" onClick={() => setIsEditOpen(false)} disabled={isSubmitting} className="border-[#DFE1E6] dark:border-[#2C333A]">Batal</Button>
            <Button onClick={handleEdit} disabled={isSubmitting} className="bg-[#0052CC] hover:bg-[#0747A6] text-white">
              {isSubmitting ? <><Loader2 className="w-4 h-4 animate-spin mr-2" />Menyimpan...</> : 'Simpan Perubahan'}
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>

      {/* Delete Confirmation */}
      <AlertDialog open={!!deleteCategory} onOpenChange={(open) => !open && setDeleteCategory(null)}>
        <AlertDialogContent className="bg-white dark:bg-[#22272B] border-[#DFE1E6] dark:border-[#2C333A]">
          <AlertDialogHeader>
            <AlertDialogTitle>Hapus Kategori?</AlertDialogTitle>
            <AlertDialogDescription>
              Apakah Anda yakin ingin menghapus kategori <strong>{deleteCategory?.name}</strong>? Barang yang sudah menggunakan kategori ini tidak akan dihapus, namun kategori ini tidak akan muncul lagi di pilihan.
            </AlertDialogDescription>
          </AlertDialogHeader>
          <AlertDialogFooter>
            <AlertDialogCancel onClick={() => setDeleteCategory(null)}>Batal</AlertDialogCancel>
            <AlertDialogAction onClick={handleDelete} className="bg-[#DE350B] hover:bg-[#BF2600] text-white">
              {isSubmitting ? 'Menghapus...' : 'Hapus'}
            </AlertDialogAction>
          </AlertDialogFooter>
        </AlertDialogContent>
      </AlertDialog>
    </div>
  );
}
