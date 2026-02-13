'use client';
import React, { useEffect, useState } from 'react';
import { getTotal } from '@/data/stock';

function DashboardCard() {
  const [totalStock, setTotalStock] = useState<number | null>(null);
  const [totalAmount, setTotalAmount] = useState<number | null>(null);
  const [totalQuantity, setTotalQuantity] = useState<number | null>(null);

  useEffect(() => {
    const fetchData = async () => {
      const { totalStock, totalAmount, totalQuantity } = await getTotal();
      setTotalStock(totalStock || 0);
      setTotalAmount(totalAmount || 0);
      setTotalQuantity(totalQuantity || 0);
    };

    fetchData();
  }, []);

  const kpis = [
    { label: 'Total Products', value: totalStock ?? '-', sub: 'In Stock' },
    { label: 'Total Revenue', value: totalAmount ? `$${totalAmount.toLocaleString()}` : '-', sub: 'Gross Income' },
    { label: 'Items Sold', value: totalQuantity ?? '-', sub: 'Total Volume' },
  ];

  return (
    <div className="grid grid-cols-1 md:grid-cols-3 gap-4 mb-6">
      {kpis.map((kpi, i) => (
        <div
          key={i}
          className="bg-background border border-border rounded p-4 flex flex-col justify-between h-24 hover:bg-neutral-50 dark:hover:bg-[#2C333A] transition-colors"
        >
          <span className="text-xs font-bold text-muted-foreground uppercase tracking-wide">
            {kpi.label}
          </span>
          <div>
            <span className="text-2xl font-semibold text-foreground block">
              {kpi.value}
            </span>
            <span className="text-xs text-muted-foreground">
              {kpi.sub}
            </span>
          </div>
        </div>
      ))}
    </div>
  );
}

export default DashboardCard;
