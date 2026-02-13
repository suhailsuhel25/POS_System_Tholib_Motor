'use client';
import React, { useEffect, useState } from 'react';
import axios from 'axios';

interface BestSellerProduct {
    id: string;
    name: string;
    category: string;
    totalSold: number;
    revenue: number;
}

export default function BestSellers() {
    const [products, setProducts] = useState<BestSellerProduct[]>([]);
    const [loading, setLoading] = useState(true);

    useEffect(() => {
        axios.get('/api/dashboard/best-sellers')
            .then(res => setProducts(res.data.products || []))
            .catch(err => console.error(err))
            .finally(() => setLoading(false));
    }, []);

    return (
        <div className="border border-border rounded bg-background flex flex-col h-full">
            <div className="p-4 border-b border-border">
                <h3 className="font-semibold text-foreground text-sm">Top Performers</h3>
            </div>

            <div className="flex-1 overflow-auto">
                <table className="w-full text-sm text-left">
                    <thead className="bg-[#FAFBFC] dark:bg-[#2C333A] text-muted-foreground text-xs uppercase font-semibold">
                        <tr>
                            <th className="px-4 py-3 w-10">#</th>
                            <th className="px-4 py-3">Product</th>
                            <th className="px-4 py-3 text-right">Vol</th>
                        </tr>
                    </thead>
                    <tbody className="divide-y divide-border">
                        {loading ? (
                            <tr><td colSpan={3} className="p-4 text-center text-muted-foreground">Loading...</td></tr>
                        ) : products.length === 0 ? (
                            <tr><td colSpan={3} className="p-8 text-center text-muted-foreground">No data available.</td></tr>
                        ) : (
                            products.map((product, i) => (
                                <tr key={product.id} className="hover:bg-neutral-50 dark:hover:bg-[#2C333A]">
                                    <td className="px-4 py-3 text-muted-foreground font-mono text-xs text-center">
                                        {i + 1}
                                    </td>
                                    <td className="px-4 py-3">
                                        <div className="font-medium text-foreground truncate max-w-[140px]" title={product.name}>
                                            {product.name}
                                        </div>
                                    </td>
                                    <td className="px-4 py-3 text-right font-medium">
                                        {product.totalSold}
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
