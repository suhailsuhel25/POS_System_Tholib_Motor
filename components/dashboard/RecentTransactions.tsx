'use client';
import React, { useEffect, useState } from 'react';
import axios from 'axios';
import { formatDistanceToNow } from 'date-fns';

interface Transaction {
    id: string;
    createdAt: string;
    totalAmount: number;
    totalQuantity: number;
    status: string;
}

export default function RecentTransactions() {
    const [transactions, setTransactions] = useState<Transaction[]>([]);
    const [loading, setLoading] = useState(true);

    useEffect(() => {
        axios.get('/api/dashboard/recent-transactions')
            .then(res => setTransactions(res.data.transactions || []))
            .catch(err => console.error(err))
            .finally(() => setLoading(false));
    }, []);

    return (
        <div className="border border-border rounded bg-background flex flex-col h-full">
            <div className="p-4 border-b border-border">
                <h3 className="font-semibold text-foreground text-sm">Recent Activity</h3>
            </div>

            <div className="flex-1 overflow-auto">
                <table className="w-full text-sm text-left">
                    <thead className="bg-[#FAFBFC] dark:bg-[#2C333A] text-muted-foreground text-xs uppercase font-semibold">
                        <tr>
                            <th className="px-4 py-3">ID</th>
                            <th className="px-4 py-3">Time</th>
                            <th className="px-4 py-3 text-right">Amount</th>
                            <th className="px-4 py-3 text-center">Status</th>
                        </tr>
                    </thead>
                    <tbody className="divide-y divide-border">
                        {loading ? (
                            <tr><td colSpan={4} className="p-4 text-center text-muted-foreground">Loading...</td></tr>
                        ) : transactions.length === 0 ? (
                            <tr><td colSpan={4} className="p-8 text-center text-muted-foreground">No recent transactions.</td></tr>
                        ) : (
                            transactions.map(tx => (
                                <tr key={tx.id} className="hover:bg-neutral-50 dark:hover:bg-[#2C333A]">
                                    <td className="px-4 py-3 font-mono text-xs text-muted-foreground">
                                        #{tx.id.slice(-6)}
                                    </td>
                                    <td className="px-4 py-3 text-foreground">
                                        {formatDistanceToNow(new Date(tx.createdAt), { addSuffix: true })}
                                    </td>
                                    <td className="px-4 py-3 text-right font-medium">
                                        ${tx.totalAmount.toFixed(2)}
                                    </td>
                                    <td className="px-4 py-3 text-center">
                                        <span className="inline-block px-2 py-0.5 rounded text-[10px] font-bold uppercase tracking-wider bg-emerald-100 text-emerald-800 dark:bg-emerald-900/40 dark:text-emerald-400">
                                            {tx.status}
                                        </span>
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
