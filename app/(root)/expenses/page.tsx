'use client';

import React, { useState, useEffect } from 'react';
import axios from '@/lib/axios';
import { format } from 'date-fns';
import { id } from 'date-fns/locale';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
  DialogDescription,
  DialogFooter,
} from '@/components/ui/dialog';
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuLabel,
  DropdownMenuSeparator,
  DropdownMenuTrigger,
} from '@/components/ui/dropdown-menu';
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
import { Search, Plus, Trash2, DollarSign, MoreHorizontal, X, Download } from 'lucide-react';

interface Expense {
  id: string;
  description: string;
  amount: number;
  category: string;
  notes: string | null;
  createdAt: string;
}

const categories = ['RESTOK', 'OPERASIONAL', 'GAJI', 'LAINNYA'] as const;

const categoryLabels: Record<string, string> = {
  RESTOK: 'Restok',
  OPERASIONAL: 'Operasional',
  GAJI: 'Gaji',
  LAINNYA: 'Lainnya',
};

export default function ExpensesPage() {
  const [expenses, setExpenses] = useState<Expense[]>([]);
  const [loading, setLoading] = useState(true);
  const [search, setSearch] = useState('');
  const [filterCategory, setFilterCategory] = useState('ALL');
  const [dialogOpen, setDialogOpen] = useState(false);
  const [form, setForm] = useState({ description: '', amount: '', category: 'LAINNYA', notes: '' });
  const [submitting, setSubmitting] = useState(false);
  const [deleteId, setDeleteId] = useState<string | null>(null);
  const [deleting, setDeleting] = useState(false);

  const fetchExpenses = async () => {
    try {
      setLoading(true);
      const params = new URLSearchParams();
      if (filterCategory !== 'ALL') params.set('category', filterCategory);
      const response = await axios.get(`/api/expenses?${params.toString()}`);
      setExpenses(response.data.expenses);
    } catch (error) {
      console.error('Error fetching expenses:', error);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchExpenses();
  }, [filterCategory]);

  const handleSubmit = async () => {
    if (!form.description.trim() || !form.amount) return;
    try {
      setSubmitting(true);
      await axios.post('/api/expenses', {
        description: form.description.trim(),
        amount: Number(form.amount),
        category: form.category,
        notes: form.notes.trim() || undefined,
      });
      setDialogOpen(false);
      setForm({ description: '', amount: '', category: 'LAINNYA', notes: '' });
      fetchExpenses();
    } catch (error) {
      alert('Gagal menambah pengeluaran');
    } finally {
      setSubmitting(false);
    }
  };

  const handleDelete = async () => {
    if (!deleteId) return;
    try {
      setDeleting(true);
      await axios.delete(`/api/expenses/${deleteId}`);
      setDeleteId(null);
      fetchExpenses();
    } catch (error) {
      alert('Gagal menghapus pengeluaran');
    } finally {
      setDeleting(false);
    }
  };

  const handleExportCSV = () => {
    if (expenses.length === 0) return;

    const headers = ['No', 'Tanggal', 'Waktu', 'Deskripsi', 'Kategori', 'Jumlah (Rp)', 'Catatan'];
    const rows: any[][] = [];
    let rowNumber = 0;

    const categoryTotals: Record<string, number> = {};

    expenses.forEach((e) => {
      rowNumber++;
      const date = format(new Date(e.createdAt), 'yyyy-MM-dd');
      const time = format(new Date(e.createdAt), 'HH:mm:ss');
      const catLabel = categoryLabels[e.category] || e.category;

      rows.push([
        rowNumber,
        date,
        time,
        `"${e.description}"`,
        catLabel,
        e.amount,
        `"${e.notes || '-'}"`
      ]);

      categoryTotals[e.category] = (categoryTotals[e.category] || 0) + e.amount;
    });

    const totalAll = Object.values(categoryTotals).reduce((s, v) => s + v, 0);

    rows.push([]);
    rows.push(['', '', '', '', 'TOTAL', totalAll, '']);
    Object.entries(categoryTotals).forEach(([cat, amt]) => {
      rows.push(['', '', '', '', `Total ${categoryLabels[cat] || cat}`, amt, '']);
    });

    const csvContent = [headers, ...rows].map(e => e.join(',')).join('\n');
    const blob = new Blob(['\ufeff' + csvContent], { type: 'text/csv;charset=utf-8;' });
    const link = document.createElement('a');
    link.href = URL.createObjectURL(blob);
    link.download = `Laporan_Pengeluaran_${format(new Date(), 'yyyy-MM-dd')}.csv`;
    link.click();
  };

  const filteredExpenses = expenses.filter((e) =>
    e.description.toLowerCase().includes(search.toLowerCase())
  );

  return (
    <div className="h-full flex flex-col">
      {/* Header — matches Product page header exactly */}
      <div className="h-14 flex items-center justify-between px-6 border-b border-[#DFE1E6] dark:border-[#2C333A] bg-white dark:bg-[#22272B]">
        <div className="flex items-center gap-2">
          <DollarSign className="w-5 h-5 text-[#0052CC] dark:text-[#579DFF]" />
          <h1 className="text-base font-bold text-[#172B4D] dark:text-white">Pengeluaran</h1>
        </div>
        <div className="flex items-center gap-2">
          <Button variant="outline" onClick={handleExportCSV} disabled={loading || expenses.length === 0} className="gap-2 border-[#DFE1E6] dark:border-[#2C333A] h-9">
            <Download className="w-4 h-4 text-[#626F86]" />
            <span className="text-xs">Ekspor CSV</span>
          </Button>
          <Button onClick={() => setDialogOpen(true)} className="gap-2 font-medium bg-[#0052CC] hover:bg-[#0747A6] text-white h-9">
            <Plus className="w-4 h-4" />
            <span className="text-xs">Tambah</span>
          </Button>
        </div>
      </div>

      <div className="flex-1 flex flex-col p-6 space-y-5 overflow-y-auto">
        {/* Filters — matches Product page filter bar */}
        <div className="flex flex-col xl:flex-row gap-4 p-4 bg-white dark:bg-[#22272B] border border-[#DFE1E6] dark:border-[#2C333A] rounded-lg items-start xl:items-center justify-between">
          {/* Category Tabs */}
          <div className="flex gap-2 w-full xl:w-auto flex-1 overflow-x-auto pb-2 xl:pb-0">
            <button
              onClick={() => setFilterCategory('ALL')}
              className={`flex-1 px-4 py-3 rounded-md text-sm font-bold transition-all whitespace-nowrap ${
                filterCategory === 'ALL'
                  ? 'bg-[#0052CC] text-white shadow-md'
                  : 'bg-[#F4F5F7] dark:bg-[#2C333A] text-[#44546F] dark:text-[#9FADBC] hover:bg-[#EBECF0] dark:hover:bg-[#3D4449]'
              }`}
            >
              Semua
            </button>
            {categories.map((cat) => (
              <button
                key={cat}
                onClick={() => setFilterCategory(cat)}
                className={`flex-1 px-4 py-3 rounded-md text-sm font-bold transition-all whitespace-nowrap ${
                  filterCategory === cat
                    ? 'bg-[#0052CC] text-white shadow-md'
                    : 'bg-[#F4F5F7] dark:bg-[#2C333A] text-[#44546F] dark:text-[#9FADBC] hover:bg-[#EBECF0] dark:hover:bg-[#3D4449]'
                }`}
              >
                {categoryLabels[cat]}
              </button>
            ))}
          </div>

          {/* Search */}
          <div className="relative w-full xl:w-80 shrink-0">
            <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-5 h-5 text-[#626F86] dark:text-[#8C9BAB]" />
            <input
              type="text"
              placeholder="Cari pengeluaran..."
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
        </div>

        {/* Table — matches Product page table exactly */}
        <div className="flex-1 border border-[#DFE1E6] dark:border-[#2C333A] bg-white dark:bg-[#22272B] rounded-lg overflow-hidden flex flex-col shadow-sm">
          <div className="flex-1 overflow-y-auto">
            <table className="w-full text-base text-left">
              <thead className="bg-[#F4F5F7] dark:bg-[#1D2125] text-[#44546F] dark:text-[#9FADBC] text-xs uppercase font-bold border-b border-[#DFE1E6] dark:border-[#2C333A] sticky top-0 z-10">
                <tr>
                  <th className="px-6 py-4 w-[18%]">Tanggal</th>
                  <th className="px-6 py-4 w-[14%]">Kategori</th>
                  <th className="px-6 py-4 w-[30%]">Deskripsi</th>
                  <th className="px-6 py-4 text-right w-[18%]">Jumlah</th>
                  <th className="px-6 py-4 w-[16%]">Catatan</th>
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
                ) : filteredExpenses.length === 0 ? (
                  <tr>
                    <td colSpan={6} className="p-12 text-center text-[#626F86] dark:text-[#8C9BAB]">
                      <div className="flex flex-col items-center justify-center">
                        <DollarSign className="w-12 h-12 mb-4 opacity-20" />
                        <p className="text-lg font-medium">Belum ada pengeluaran</p>
                        <p className="text-sm">Klik tombol &quot;Tambah Pengeluaran&quot; untuk memulai.</p>
                      </div>
                    </td>
                  </tr>
                ) : (
                  filteredExpenses.map((expense) => (
                    <tr key={expense.id} className="hover:bg-[#F4F5F7] dark:hover:bg-[#2C333A] transition-colors group">
                      <td className="px-6 py-4">
                        <div className="text-sm font-medium text-[#172B4D] dark:text-[#B6C2CF]">
                          {format(new Date(expense.createdAt), 'dd MMM yyyy', { locale: id })}
                        </div>
                        <div className="text-[10px] text-[#626F86] dark:text-[#8C9BAB]">
                          {format(new Date(expense.createdAt), 'HH:mm')}
                        </div>
                      </td>
                      <td className="px-6 py-4">
                        <span className="inline-flex items-center px-2.5 py-1 rounded text-sm font-medium bg-[#E9F2FF] text-[#0052CC] dark:bg-[#1C2B41] dark:text-[#579DFF]">
                          {categoryLabels[expense.category] || expense.category}
                        </span>
                      </td>
                      <td className="px-6 py-4">
                        <div className="font-semibold text-[#172B4D] dark:text-[#B6C2CF] text-base">{expense.description}</div>
                      </td>
                      <td className="px-6 py-4 text-right font-bold text-[#172B4D] dark:text-[#B6C2CF] font-mono">
                        Rp{expense.amount.toLocaleString('id-ID')}
                      </td>
                      <td className="px-6 py-4 text-sm text-[#626F86] dark:text-[#8C9BAB] truncate max-w-[200px]">
                        {expense.notes || '-'}
                      </td>
                      <td className="px-6 py-4 text-right">
                        <DropdownMenu>
                          <DropdownMenuTrigger asChild>
                            <Button variant="ghost" size="icon" className="h-8 w-8 text-[#626F86] dark:text-[#8C9BAB] hover:text-[#172B4D] dark:hover:text-white hover:bg-[#EBECF0] dark:hover:bg-[#3D4449]">
                              <MoreHorizontal className="w-4 h-4" />
                            </Button>
                          </DropdownMenuTrigger>
                          <DropdownMenuContent align="end" className="w-48 bg-white dark:bg-[#22272B] border-[#DFE1E6] dark:border-[#2C333A]">
                            <DropdownMenuLabel className="text-[#626F86] dark:text-[#8C9BAB]">Aksi</DropdownMenuLabel>
                            <DropdownMenuSeparator className="bg-[#DFE1E6] dark:bg-[#3D4449]" />
                            <DropdownMenuItem
                              onClick={() => setDeleteId(expense.id)}
                              className="text-[#DE350B] focus:text-[#DE350B] focus:bg-[#FFEBE6] dark:focus:bg-[#4A1A1A] cursor-pointer"
                            >
                              Hapus Pengeluaran
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
        </div>
      </div>

      {/* Add Expense Dialog */}
      <Dialog open={dialogOpen} onOpenChange={setDialogOpen}>
        <DialogContent className="sm:max-w-[460px] bg-white dark:bg-[#22272B] border-[#DFE1E6] dark:border-[#2C333A]">
          <DialogHeader>
            <DialogTitle className="text-[#172B4D] dark:text-white">Tambah Pengeluaran</DialogTitle>
            <DialogDescription className="text-[#626F86] dark:text-[#8C9BAB]">
              Catat pengeluaran operasional baru.
            </DialogDescription>
          </DialogHeader>
          <div className="space-y-4 py-2">
            <div>
              <label className="text-xs font-bold text-[#44546F] dark:text-[#9FADBC] uppercase tracking-wider block mb-2">Deskripsi *</label>
              <Input placeholder="Contoh: Restok oli, Bayar listrik" value={form.description} onChange={(e) => setForm({ ...form, description: e.target.value })} className="h-10 bg-[#FAFBFC] dark:bg-[#1D2125] border-[#DFE1E6] dark:border-[#2C333A]" />
            </div>
            <div>
              <label className="text-xs font-bold text-[#44546F] dark:text-[#9FADBC] uppercase tracking-wider block mb-2">Jumlah (Rp) *</label>
              <Input type="number" placeholder="0" value={form.amount} onChange={(e) => setForm({ ...form, amount: e.target.value })} className="h-10 bg-[#FAFBFC] dark:bg-[#1D2125] border-[#DFE1E6] dark:border-[#2C333A]" />
            </div>
            <div>
              <label className="text-xs font-bold text-[#44546F] dark:text-[#9FADBC] uppercase tracking-wider block mb-2">Kategori</label>
              <div className="relative">
                <select
                  value={form.category}
                  onChange={(e) => setForm({ ...form, category: e.target.value })}
                  className="w-full h-10 pl-4 pr-10 rounded-md border border-[#DFE1E6] dark:border-[#2C333A] bg-[#FAFBFC] dark:bg-[#1D2125] text-sm appearance-none focus:outline-none focus:ring-2 focus:ring-[#0052CC] cursor-pointer"
                >
                  {categories.map((cat) => (
                    <option key={cat} value={cat}>{categoryLabels[cat]}</option>
                  ))}
                </select>
              </div>
            </div>
            <div>
              <label className="text-xs font-bold text-[#44546F] dark:text-[#9FADBC] uppercase tracking-wider block mb-2">Catatan</label>
              <Input placeholder="Opsional" value={form.notes} onChange={(e) => setForm({ ...form, notes: e.target.value })} className="h-10 bg-[#FAFBFC] dark:bg-[#1D2125] border-[#DFE1E6] dark:border-[#2C333A]" />
            </div>
          </div>
          <DialogFooter className="gap-2">
            <Button variant="outline" onClick={() => setDialogOpen(false)} className="border-[#DFE1E6] dark:border-[#2C333A]">Batal</Button>
            <Button className="bg-[#0052CC] hover:bg-[#0747A6] text-white" disabled={!form.description.trim() || !form.amount || submitting} onClick={handleSubmit}>
              {submitting ? 'Menyimpan...' : 'Simpan'}
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>

      {/* Delete Confirmation */}
      <AlertDialog open={!!deleteId} onOpenChange={(open) => !open && setDeleteId(null)}>
        <AlertDialogContent className="bg-white dark:bg-[#22272B] border-[#DFE1E6] dark:border-[#2C333A]">
          <AlertDialogHeader>
            <AlertDialogTitle>Hapus Pengeluaran?</AlertDialogTitle>
            <AlertDialogDescription>
              Tindakan ini tidak dapat dibatalkan. Data pengeluaran akan dihapus permanen.
            </AlertDialogDescription>
          </AlertDialogHeader>
          <AlertDialogFooter>
            <AlertDialogCancel onClick={() => setDeleteId(null)}>Batal</AlertDialogCancel>
            <AlertDialogAction onClick={handleDelete} className="bg-[#DE350B] hover:bg-[#BF2600] text-white">
              {deleting ? 'Menghapus...' : 'Hapus'}
            </AlertDialogAction>
          </AlertDialogFooter>
        </AlertDialogContent>
      </AlertDialog>
    </div>
  );
}
