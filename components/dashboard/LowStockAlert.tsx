'use client';
import React, { useEffect, useState } from 'react';
import Link from 'next/link';
import { AlertTriangle } from 'lucide-react';
import axios from 'axios';

interface LowStockProduct {
    id: string;
    name: string;
    category: string;
    stock: number;
}

export default function LowStockAlert() {
    const [products, setProducts] = useState<LowStockProduct[]>([]);
    const [loading, setLoading] = useState(true);

    useEffect(() => {
        axios.get('/api/dashboard/low-stock')
            .then(res => setProducts(res.data.products || []))
            .catch(err => console.error(err))
            .finally(() => setLoading(false));
    }, []);

    return (
        <div className="border border-border rounded bg-background flex flex-col h-full">
            <div className="p-4 border-b border-border flex items-center justify-between">
                <h3 className="font-semibold text-foreground text-sm">Low Stock Warnings</h3>
                {products.length > 0 && (
                    <span className="bg-amber-100 text-amber-800 dark:bg-amber-900/30 dark:text-amber-500 text-xs px-2 py-0.5 rounded font-medium">
                        {products.length} Items
                    </span>
                )}
            </div>

            <div className="flex-1 overflow-auto">
                <table className="w-full text-sm text-left">
                    <thead className="bg-[#FAFBFC] dark:bg-[#2C333A] text-muted-foreground text-xs uppercase font-semibold">
                        <tr>
                            <th className="px-4 py-3">Product</th>
                            <th className="px-4 py-3 text-right">Stock</th>
                        </tr>
                    </thead>
                    <tbody className="divide-y divide-border">
                        {loading ? (
                            <tr><td colSpan={2} className="p-4 text-center text-muted-foreground">Checking stock...</td></tr>
                        ) : products.length === 0 ? (
                            <tr><td colSpan={2} className="p-8 text-center text-muted-foreground">All stock levels healthy.</td></tr>
                        ) : (
                            products.map(product => (
                                <tr key={product.id} className="hover:bg-neutral-50 dark:hover:bg-[#2C333A]">
                                    <td className="px-4 py-3">
                                        <Link href="/product" className="text-primary hover:underline font-medium block">
                                            {product.name}
                                        </Link>
                                        <span className="text-xs text-muted-foreground">{product.category}</span>
                                    </td>
                                    <td className="px-4 py-3 text-right font-mono text-destructive font-bold">
                                        {product.stock}
                                    </td>
                                </tr>
                            ))
                        )}
                    </tbody>
                </table>
            </div>
        </div>
    );
}
