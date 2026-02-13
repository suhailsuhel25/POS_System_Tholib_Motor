'use client';

import React, { useEffect, useState } from 'react';
import axios from 'axios';
import { Button } from '@/components/ui/button';
import {
    Dialog,
    DialogContent,
    DialogDescription,
    DialogFooter,
    DialogHeader,
    DialogTitle,
} from "@/components/ui/dialog";
import { Loader2 } from 'lucide-react';

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

interface ProductFormModalProps {
    open: boolean;
    onClose: () => void;
    initialData?: Product | null;
    onSuccess: () => void;
    masterCategories: string[];
}

const BRANDS = ['HONDA', 'YAMAHA', 'KAWASAKI', 'SUZUKI'];

export function ProductFormModal({ open, onClose, initialData, onSuccess, masterCategories }: ProductFormModalProps) {
    const [loading, setLoading] = useState(false);
    const [error, setError] = useState('');

    const [formData, setFormData] = useState({
        name: '',
        brand: 'HONDA',
        masterCategory: '',
        stock: 0,
        buyPrice: 0,
        sellPrice: 0,
    });

    // Reset form when modal opens or initialData changes
    useEffect(() => {
        if (open) {
            if (initialData) {
                setFormData({
                    name: initialData.name,
                    brand: initialData.brand,
                    masterCategory: initialData.masterCategory,
                    stock: initialData.stock,
                    buyPrice: initialData.buyPrice,
                    sellPrice: initialData.sellPrice,
                });
            } else {
                // Default for new product
                setFormData({
                    name: '',
                    brand: 'HONDA',
                    masterCategory: masterCategories[0] || '',
                    stock: 0,
                    buyPrice: 0,
                    sellPrice: 0,
                });
            }
            setError('');
        }
    }, [open, initialData, masterCategories]);

    const handleChange = (e: React.ChangeEvent<HTMLInputElement | HTMLSelectElement>) => {
        const { name, value } = e.target;
        setFormData(prev => ({
            ...prev,
            [name]: name === 'stock' || name === 'buyPrice' || name === 'sellPrice'
                ? Number(value)
                : value
        }));
    };

    const handleSubmit = async (e: React.FormEvent) => {
        e.preventDefault();
        setLoading(true);
        setError('');

        if (!formData.masterCategory) {
            setError('Pilih kategori produk.');
            setLoading(false);
            return;
        }

        try {
            if (initialData) {
                // Edit Mode
                await axios.patch(`/api/product/${initialData.id}`, { ...formData, category: '' });
            } else {
                // Create Mode - backend might need category field so we send it as empty string
                await axios.post('/api/product', { ...formData, category: '' });
            }
            onSuccess();
            onClose();
        } catch (err: any) {
            console.error('Submit error:', err);
            setError(err.response?.data?.error || 'Gagal menyimpan produk.');
        } finally {
            setLoading(false);
        }
    };

    return (
        <Dialog open={open} onOpenChange={onClose}>
            <DialogContent className="sm:max-w-[600px] bg-white dark:bg-[#22272B] border-[#DFE1E6] dark:border-[#2C333A] max-h-[90vh] overflow-y-auto">
                <DialogHeader>
                    <DialogTitle className="text-[#172B4D] dark:text-white">
                        {initialData ? 'Ubah Detail Produk' : 'Tambah Produk Baru'}
                    </DialogTitle>
                    <DialogDescription>
                        Isi detail produk di bawah ini. Pastikan data sudah benar sebelum menyimpan.
                    </DialogDescription>
                </DialogHeader>

                <form onSubmit={handleSubmit} className="space-y-4 py-4">
                    {error && (
                        <div className="p-3 bg-[#FFEBE6] text-[#DE350B] rounded-md text-sm font-medium">
                            {error}
                        </div>
                    )}

                    <div className="grid grid-cols-2 gap-4">
                        <div className="space-y-2 col-span-2">
                            <label className="text-sm font-medium text-[#172B4D] dark:text-[#B6C2CF]">Nama Produk</label>
                            <input
                                required
                                name="name"
                                value={formData.name}
                                onChange={handleChange}
                                placeholder="Contoh: Oli Yamalube 1L"
                                className="w-full h-10 px-3 rounded-md border border-[#DFE1E6] dark:border-[#2C333A] bg-white dark:bg-[#1D2125] focus:ring-2 focus:ring-[#0052CC]"
                            />
                        </div>

                        <div className="space-y-2">
                            <label className="text-sm font-medium text-[#172B4D] dark:text-[#B6C2CF]">Brand</label>
                            <select
                                name="brand"
                                value={formData.brand}
                                onChange={handleChange}
                                className="w-full h-10 px-3 rounded-md border border-[#DFE1E6] dark:border-[#2C333A] bg-white dark:bg-[#1D2125] focus:ring-2 focus:ring-[#0052CC]"
                            >
                                {BRANDS.map(brand => (
                                    <option key={brand} value={brand}>{brand}</option>
                                ))}
                            </select>
                        </div>

                        <div className="space-y-2">
                            <label className="text-sm font-medium text-[#172B4D] dark:text-[#B6C2CF]">Kategori</label>
                            <select
                                name="masterCategory"
                                value={formData.masterCategory}
                                onChange={handleChange}
                                className="w-full h-10 px-3 rounded-md border border-[#DFE1E6] dark:border-[#2C333A] bg-white dark:bg-[#1D2125] focus:ring-2 focus:ring-[#0052CC]"
                            >
                                <option value="" disabled>Pilih Kategori</option>
                                {masterCategories.map(cat => (
                                    <option key={cat} value={cat}>{cat}</option>
                                ))}
                            </select>
                        </div>

                        <div className="space-y-2">
                            <label className="text-sm font-medium text-[#172B4D] dark:text-[#B6C2CF]">Stok Awal</label>
                            <input
                                required
                                type="number"
                                min="0"
                                name="stock"
                                value={formData.stock}
                                onChange={handleChange}
                                className="w-full h-10 px-3 rounded-md border border-[#DFE1E6] dark:border-[#2C333A] bg-white dark:bg-[#1D2125] focus:ring-2 focus:ring-[#0052CC]"
                            />
                        </div>

                        <div className="space-y-2">
                            <label className="text-sm font-medium text-[#172B4D] dark:text-[#B6C2CF]">Harga Beli (Rp)</label>
                            <input
                                required
                                type="number"
                                min="0"
                                name="buyPrice"
                                value={formData.buyPrice}
                                onChange={handleChange}
                                className="w-full h-10 px-3 rounded-md border border-[#DFE1E6] dark:border-[#2C333A] bg-white dark:bg-[#1D2125] focus:ring-2 focus:ring-[#0052CC]"
                            />
                        </div>

                        <div className="space-y-2 col-span-2">
                            <label className="text-sm font-medium text-[#172B4D] dark:text-[#B6C2CF]">Harga Jual (Rp)</label>
                            <input
                                required
                                type="number"
                                min="0"
                                name="sellPrice"
                                value={formData.sellPrice}
                                onChange={handleChange}
                                className="w-full h-10 px-3 rounded-md border border-[#DFE1E6] dark:border-[#2C333A] bg-white dark:bg-[#1D2125] focus:ring-2 focus:ring-[#0052CC]"
                            />
                        </div>
                    </div>

                    <DialogFooter className="pt-4">
                        <Button type="button" variant="outline" onClick={onClose} disabled={loading}>
                            Batal
                        </Button>
                        <Button type="submit" disabled={loading} className="bg-[#0052CC] hover:bg-[#0747A6] text-white">
                            {loading && <Loader2 className="mr-2 h-4 w-4 animate-spin" />}
                            {initialData ? 'Simpan Perubahan' : 'Tambah Produk'}
                        </Button>
                    </DialogFooter>
                </form>
            </DialogContent>
        </Dialog>
    );
}
