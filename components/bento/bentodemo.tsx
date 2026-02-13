'use client';

import React, { useEffect, useState, useMemo } from 'react';
import axios from 'axios';
import Link from 'next/link';
import dynamic from 'next/dynamic';
import { formatDistanceToNow, format } from 'date-fns';
import { id } from 'date-fns/locale';
import { AlertTriangle, TrendingUp, ShoppingCart, Package, Banknote, Clock, ChevronRight, Plus, LayoutDashboard, Calendar, ArrowUpRight, ArrowDownRight } from 'lucide-react';
import { Button } from '@/components/ui/button';

// Dynamically import Chart to avoid SSR issues
const Chart = dynamic(() => import('react-apexcharts'), { ssr: false });

interface DashboardData {
  totalStock: number;
  totalAmount: number;
  totalQuantity: number;
  lowStockCount: number;
}

interface Transaction {
  id: string;
  createdAt: string;
  totalAmount: number;
  status: string;
  isComplete: boolean;
  products: any[];
}

interface LowStockItem {
  id: string;
  name: string;
  stock: number;
  cat: string;
}

export function JiraDashboard() {
  const [kpis, setKpis] = useState<DashboardData | null>(null);
  const [transactions, setTransactions] = useState<Transaction[]>([]);
  const [lowStock, setLowStock] = useState<LowStockItem[]>([]);
  const [profitData, setProfitData] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const endDate = new Date();
    const startDate = new Date();
    startDate.setDate(endDate.getDate() - 7);

    Promise.all([
      axios.get('/api/dashboard'),
      axios.get('/api/dashboard/recent-transactions'),
      axios.get('/api/dashboard/low-stock'),
      axios.get(`/api/profit?start=${startDate.toISOString()}&end=${endDate.toISOString()}`)
    ])
      .then(([kpiRes, txRes, stockRes, profitRes]) => {
        setKpis(kpiRes.data);
        setTransactions(txRes.data.transactions || []);
        setLowStock(stockRes.data.products || []);
        setProfitData(profitRes.data.groupedData || []);
      })
      .catch(console.error)
      .finally(() => setLoading(false));
  }, []);

  // Chart options
  const chartOptions: ApexCharts.ApexOptions = {
    chart: { type: 'area', toolbar: { show: false }, sparkline: { enabled: false }, fontFamily: 'inherit' },
    colors: ['#0052CC'],
    fill: { type: 'gradient', gradient: { shadeIntensity: 1, opacityFrom: 0.3, opacityTo: 0.05, stops: [0, 90, 100] } },
    dataLabels: { enabled: false },
    stroke: { curve: 'smooth', width: 2 },
    xaxis: {
      categories: profitData.map(d => format(new Date(d.date), 'dd MMM')),
      axisBorder: { show: false },
      axisTicks: { show: false },
      labels: { style: { colors: '#626F86', fontSize: '10px' } }
    },
    yaxis: { labels: { show: false } },
    grid: { show: false },
    tooltip: { theme: 'light', y: { formatter: (v) => `Rp${v.toLocaleString('id-ID')}` } }
  };

  const chartSeries = [{ name: 'Penjualan', data: profitData.map(d => d.grossIncome) }];

  if (loading) {
    return (
      <div className="flex items-center justify-center h-full">
        <span className="text-sm text-[#626F86] animate-pulse">Memuat dashboard...</span>
      </div>
    );
  }

  return (
    <div className="h-full overflow-y-auto bg-[#F4F5F7] dark:bg-[#1D2125]">
      {/* Page Title */}
      <div className="h-14 flex items-center justify-between px-6 border-b border-[#DFE1E6] dark:border-[#2C333A] bg-white dark:bg-[#22272B] sticky top-0 z-10 shadow-sm">
        <div className="flex items-center gap-2">
          <LayoutDashboard className="w-5 h-5 text-[#0052CC] dark:text-[#579DFF]" />
          <h1 className="text-base font-bold text-[#172B4D] dark:text-white">Dashboard</h1>
        </div>
        <div className="flex items-center gap-3">
          <div className="flex items-center gap-1.5 px-3 py-1.5 bg-[#F4F5F7] dark:bg-[#1D2125] rounded text-[11px] font-bold text-[#626F86] dark:text-[#8C9BAB]">
            <Calendar className="w-3.5 h-3.5" />
            7 Hari Terakhir
          </div>
          <Link href="/orders">
            <Button size="sm" className="bg-[#0052CC] hover:bg-[#0747A6] text-white gap-2 font-bold px-4 shadow-sm">
              <Plus className="w-4 h-4" />
              Kasir Baru
            </Button>
          </Link>
        </div>
      </div>

      <div className="p-6 space-y-6">
        {/* KPI Grid */}
        <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
          <div className="bg-white dark:bg-[#22272B] p-6 rounded-lg border border-[#DFE1E6] dark:border-[#2C333A] shadow-sm hover:shadow-md transition-shadow group">
            <div className="flex justify-between items-start mb-4">
              <div className="p-2 bg-[#DEEBFF] dark:bg-[#0747A6]/20 rounded-lg group-hover:scale-110 transition-transform">
                <Banknote className="w-5 h-5 text-[#0052CC] dark:text-[#579DFF]" />
              </div>
            </div>
            <p className="text-xs font-bold text-[#626F86] dark:text-[#8C9BAB] uppercase tracking-wider mb-1">Total Omset</p>
            <h3 className="text-2xl font-black text-[#172B4D] dark:text-white">Rp {kpis?.totalAmount?.toLocaleString('id-ID') ?? 0}</h3>
          </div>

          <div className="bg-white dark:bg-[#22272B] p-6 rounded-lg border border-[#DFE1E6] dark:border-[#2C333A] shadow-sm hover:shadow-md transition-shadow group">
            <div className="flex justify-between items-start mb-4">
              <div className="p-2 bg-[#E3FCEF] dark:bg-[#1C3329]/20 rounded-lg group-hover:scale-110 transition-transform">
                <ShoppingCart className="w-5 h-5 text-[#36B37E]" />
              </div>
            </div>
            <p className="text-xs font-bold text-[#626F86] dark:text-[#8C9BAB] uppercase tracking-wider mb-1">Barang Terjual</p>
            <h3 className="text-2xl font-black text-[#172B4D] dark:text-white">{kpis?.totalQuantity ?? 0} <span className="text-sm font-normal text-[#626F86]">Pcs</span></h3>
          </div>

          <div className="bg-white dark:bg-[#22272B] p-6 rounded-lg border border-[#DFE1E6] dark:border-[#2C333A] shadow-sm hover:shadow-md transition-shadow group">
            <div className="flex justify-between items-start mb-4">
              <div className="p-2 bg-[#FFF0B3] dark:bg-[#3D2E00]/20 rounded-lg group-hover:scale-110 transition-transform">
                <Package className="w-5 h-5 text-[#974F0C] dark:text-[#FFE380]" />
              </div>
              {(kpis?.lowStockCount ?? 0) > 0 && (
                <span className="flex items-center text-[10px] font-bold text-[#BF2600] bg-[#FFEBE6] dark:bg-[#4A1D19] px-2 py-0.5 rounded-full uppercase">
                  <AlertTriangle className="w-3 h-3 mr-0.5" /> {kpis?.lowStockCount} Warning
                </span>
              )}
            </div>
            <p className="text-xs font-bold text-[#626F86] dark:text-[#8C9BAB] uppercase tracking-wider mb-1">Total Item Stok</p>
            <h3 className="text-2xl font-black text-[#172B4D] dark:text-white">{kpis?.totalStock ?? 0} <span className="text-sm font-normal text-[#626F86]">Barang</span></h3>
          </div>
        </div>

        {/* Charts & Content Grid */}
        <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
          {/* Revenue Chart */}
          <div className="lg:col-span-2 bg-white dark:bg-[#22272B] border border-[#DFE1E6] dark:border-[#2C333A] rounded-lg shadow-sm flex flex-col">
            <div className="px-6 py-4 border-b border-[#DFE1E6] dark:border-[#2C333A] flex items-center justify-between">
              <h3 className="text-sm font-bold text-[#172B4D] dark:text-white uppercase tracking-tight">Tren Pendapatan</h3>
              <div className="flex items-center gap-2">
                <div className="w-2 h-2 rounded-full bg-[#0052CC]" />
                <span className="text-[10px] font-bold text-[#626F86] dark:text-[#8C9BAB]">Gross Revenue</span>
              </div>
            </div>
            <div className="p-6 flex-1 min-h-[250px]">
              {typeof window !== 'undefined' && <Chart options={chartOptions} series={chartSeries} type="area" height="100%" />}
            </div>
          </div>

          {/* Low Stock Warnings */}
          <div className="bg-white dark:bg-[#22272B] border border-[#DFE1E6] dark:border-[#2C333A] rounded-lg shadow-sm flex flex-col">
            <div className="px-6 py-4 border-b border-[#DFE1E6] dark:border-[#2C333A] flex items-center gap-2">
              <AlertTriangle className="w-4 h-4 text-[#DE350B]" />
              <h3 className="text-sm font-bold text-[#172B4D] dark:text-white uppercase tracking-tight">Stok Menipis</h3>
            </div>
            <div className="flex-1 divide-y divide-[#DFE1E6] dark:divide-[#2C333A] overflow-y-auto max-h-[300px]">
              {lowStock.length === 0 ? (
                <div className="p-10 text-center flex flex-col items-center gap-2">
                  <div className="w-10 h-10 bg-[#E3FCEF] rounded-full flex items-center justify-center">
                    <TrendingUp className="w-5 h-5 text-[#006644]" />
                  </div>
                  <p className="text-xs text-[#626F86] font-medium">Semua stok aman</p>
                </div>
              ) : (
                lowStock.slice(0, 8).map((item) => (
                  <div key={item.id} className="px-6 py-3 flex items-center justify-between hover:bg-[#F4F5F7] dark:hover:bg-[#2C333A] transition-colors">
                    <div className="min-w-0">
                      <div className="text-sm font-bold text-[#172B4D] dark:text-[#B6C2CF] truncate mb-0.5">{item.name}</div>
                      <div className="text-[10px] text-[#626F86] dark:text-[#8C9BAB] uppercase font-bold">{item.cat}</div>
                    </div>
                    <div className={`px-2 py-1 rounded text-xs font-black ${item.stock === 0 ? 'bg-[#FFEBE6] text-[#BF2600]' : 'bg-[#FFF0B3] text-[#974F0C]'}`}>
                      {item.stock}
                    </div>
                  </div>
                ))
              )}
            </div>
            <Link href="/product" className="p-4 text-center border-t border-[#DFE1E6] dark:border-[#2C333A] text-[#0052CC] dark:text-[#579DFF] text-xs font-bold hover:bg-[#F4F5F7] dark:hover:bg-[#2C333A] flex items-center justify-center gap-1 group">
              Kelola Inventaris <ChevronRight className="w-3 h-3 group-hover:translate-x-1 transition-transform" />
            </Link>
          </div>
        </div>

        {/* Recent Transactions Table */}
        <div className="bg-white dark:bg-[#22272B] border border-[#DFE1E6] dark:border-[#2C333A] rounded-lg shadow-sm">
          <div className="px-6 py-4 border-b border-[#DFE1E6] dark:border-[#2C333A] flex items-center justify-between">
            <h3 className="text-sm font-bold text-[#172B4D] dark:text-white uppercase tracking-tight">Riwayat Aktivitas</h3>
            <Link href="/records">
              <Button variant="ghost" size="sm" className="text-[#0052CC] font-bold text-xs hover:bg-[#DEEBFF]">
                Lihat Semua
              </Button>
            </Link>
          </div>
          <div className="overflow-x-auto">
            <table className="w-full text-sm">
              <thead>
                <tr className="bg-[#FAFBFC] dark:bg-[#1D2125] border-b border-[#DFE1E6] dark:border-[#2C333A]">
                  <th className="text-left px-6 py-3 text-[10px] font-black text-[#626F86] dark:text-[#8C9BAB] uppercase tracking-wider">ID Transaksi</th>
                  <th className="text-left px-6 py-3 text-[10px] font-black text-[#626F86] dark:text-[#8C9BAB] uppercase tracking-wider">Waktu</th>
                  <th className="text-right px-6 py-3 text-[10px] font-black text-[#626F86] dark:text-[#8C9BAB] uppercase tracking-wider">Total Nominal</th>
                  <th className="text-center px-6 py-3 text-[10px] font-black text-[#626F86] dark:text-[#8C9BAB] uppercase tracking-wider">Status</th>
                  <th className="text-center px-6 py-3 text-[10px] font-black text-[#626F86] dark:text-[#8C9BAB] uppercase tracking-wider">Aksi</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-[#DFE1E6] dark:divide-[#2C333A]">
                {transactions.slice(0, 5).map((tx) => (
                  <tr key={tx.id} className="hover:bg-[#FAFBFC] dark:hover:bg-[#1D2125] transition-colors group">
                    <td className="px-6 py-4 font-mono text-xs font-bold text-[#0052CC] flex items-center gap-2">
                      <div className="w-1.5 h-1.5 rounded-full bg-[#0052CC]/40" />
                      #{tx.id.slice(-8).toUpperCase()}
                    </td>
                    <td className="px-6 py-4 text-[#44546F] dark:text-[#B6C2CF]">
                      <div className="flex items-center gap-2">
                        <Clock className="w-3.5 h-3.5 text-[#626F86]" />
                        <span className="text-xs font-medium">{formatDistanceToNow(new Date(tx.createdAt), { addSuffix: true, locale: id })}</span>
                      </div>
                    </td>
                    <td className="px-6 py-4 text-right font-black text-[#172B4D] dark:text-white">
                      Rp{tx.totalAmount.toLocaleString('id-ID')}
                    </td>
                    <td className="px-6 py-4 text-center">
                      {tx.status === 'RETUR' ? (
                        <span className="inline-block px-2 py-0.5 text-[9px] font-black rounded uppercase bg-[#FFEBE6] text-[#BF2600]">Retur</span>
                      ) : (
                        <span className="inline-block px-2 py-0.5 text-[9px] font-black rounded uppercase bg-[#E3FCEF] text-[#006644]">Sukses</span>
                      )}
                    </td>
                    <td className="px-6 py-4 text-center">
                      <Link href={`/records/${tx.id}`}>
                        <Button variant="ghost" size="sm" className="h-7 w-7 p-0 rounded-full hover:bg-[#DEEBFF]">
                          <ChevronRight className="w-4 h-4 text-[#626F86]" />
                        </Button>
                      </Link>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div >
  );
}
