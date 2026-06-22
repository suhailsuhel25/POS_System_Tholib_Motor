'use client';

import React, { useState, useEffect, useMemo } from 'react';
import dynamic from 'next/dynamic';
import { Calendar, Download, ShoppingBag, Eye, TrendingUp, Banknote, Package, ChevronRight, Search, FileText, History } from 'lucide-react';
import { Button } from '@/components/ui/button';
import { Tabs, TabsContent, TabsList, TabsTrigger } from '@/components/ui/tabs';
import { Input } from '@/components/ui/input';
import axios from '@/lib/axios';
import { format } from 'date-fns';
import { id } from 'date-fns/locale';
import { useTheme } from 'next-themes';
import Link from 'next/link';
import { Capacitor } from '@capacitor/core';
import { Filesystem, Directory } from '@capacitor/filesystem';
import { Share } from '@capacitor/share';

// Dynamically import ApexCharts to avoid SSR issues
const Chart = dynamic(() => import('react-apexcharts'), { ssr: false });

export default function RecordsPage() {
  const [activeTab, setActiveTab] = useState('laporan');
  const [loading, setLoading] = useState(true);
  const [transactions, setTransactions] = useState<any[]>([]);
  const [profitData, setProfitData] = useState<any[]>([]);
  const [searchQuery, setSearchQuery] = useState('');

  const [startDate, setStartDate] = useState(() => {
    const d = new Date();
    d.setDate(d.getDate() - 7);
    return d.toISOString().split('T')[0];
  });
  const [endDate, setEndDate] = useState(() => new Date().toISOString().split('T')[0]);

  // Fetch data
  const fetchData = async () => {
    try {
      setLoading(true);

      const start = new Date(startDate + 'T00:00:00');
      const end = new Date(endDate + 'T23:59:59');

      const [transRes, profitRes] = await Promise.all([
        axios.get(`/api/transactions?limit=200`),
        axios.get(`/api/profit?start=${start.toISOString()}&end=${end.toISOString()}`)
      ]);

      setTransactions(transRes.data.transactions || []);
      setProfitData(profitRes.data.groupedData || []);
    } catch (error) {
      console.error('Error fetching records:', error);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchData();
  }, [startDate, endDate]);

  // Statistics calculation
  const stats = useMemo(() => {
    const successTransactions = transactions.filter(t => t.status !== 'RETUR');
    const totalTransactions = successTransactions.length;
    const totalRevenue = successTransactions.reduce((sum, t) => sum + Number(t.totalAmount || 0), 0);
    const totalProfit = profitData.reduce((sum, d) => sum + Number(d.profit || 0), 0);
    const avgTransaction = totalTransactions > 0 ? totalRevenue / totalTransactions : 0;

    return {
      totalRevenue,
      totalProfit,
      totalTransactions,
      avgTransaction
    };
  }, [transactions, profitData]);

  // Filtered transactions for the history tab
  const filteredTransactions = useMemo(() => {
    if (!searchQuery) return transactions;
    return transactions.filter(t =>
      t.id.toLowerCase().includes(searchQuery.toLowerCase()) ||
      t.products?.some((p: any) => p.product?.productstock?.name?.toLowerCase().includes(searchQuery.toLowerCase()))
    );
  }, [transactions, searchQuery]);

  const { theme } = useTheme();

  // Chart: Revenue Trend
  const salesOptions: ApexCharts.ApexOptions = {
    chart: { type: 'area', toolbar: { show: false }, fontFamily: 'inherit', animations: { enabled: false } },
    colors: ['#0052CC', '#36B37E'],
    fill: { type: 'gradient', gradient: { shadeIntensity: 1, opacityFrom: 0.4, opacityTo: 0.1, stops: [0, 90, 100] } },
    dataLabels: { enabled: false },
    stroke: { curve: 'smooth', width: 2 },
    xaxis: {
      categories: profitData.map(d => format(new Date(d.date), 'dd MMM', { locale: id })),
      axisBorder: { show: false },
      labels: { style: { colors: '#626F86', fontSize: '10px' } }
    },
    yaxis: { labels: { style: { colors: '#626F86', fontSize: '10px' }, formatter: (v) => `Rp${(Number(v) / 1000).toLocaleString()}k` } },
    grid: { borderColor: '#DFE1E6', strokeDashArray: 4 },
    tooltip: { theme: theme === 'dark' ? 'dark' : 'light' }
  };

  const salesSeries = [
    { name: 'Omset', data: profitData.map(d => Number(d.revenue || 0)) },
    { name: 'Profit', data: profitData.map(d => Number(d.profit || 0)) }
  ];

  // Chart: Category Distribution (Mock but derived from counts if we had them)
  const categoryOptions: ApexCharts.ApexOptions = {
    chart: { type: 'donut', fontFamily: 'inherit', animations: { enabled: false } },
    colors: ['#0052CC', '#36B37E', '#FF991F', '#EB5757', '#6554C0'],
    labels: ['HONDA', 'YAMAHA', 'KAWASAKI', 'SUZUKI', 'LAINNYA'],
    plotOptions: { pie: { donut: { size: '70%', labels: { show: true, total: { show: true, label: 'Total', formatter: () => stats.totalTransactions.toString() } } } } },
    dataLabels: { enabled: false },
    legend: { position: 'bottom', fontSize: '12px' },
    stroke: { show: false }
  };

  // Calculate real brand distribution from transactions
  const brandStats = useMemo(() => {
    const brandsCount: Record<string, number> = { 'HONDA': 0, 'YAMAHA': 0, 'KAWASAKI': 0, 'SUZUKI': 0, 'LAINNYA': 0 };
    const successTransactions = transactions.filter(t => t.status !== 'RETUR');

    successTransactions.forEach(t => t.products?.forEach((p: any) => {
      const brand = p.product?.productstock?.brand;
      if (brand && brandsCount[brand] !== undefined) brandsCount[brand] += p.quantity;
      else if (brand) brandsCount['LAINNYA'] += p.quantity;
    }));
    return { labels: Object.keys(brandsCount), series: Object.values(brandsCount) };
  }, [transactions]);

  // Export to CSV
  const handleExport = async () => {
    if (transactions.length === 0) return;

    // CSV Header sesuai standar POS
    const headers = [
      'No',
      'ID Transaksi',
      'Tanggal',
      'Waktu',
      'Status',
      'Nama Produk',
      'Brand',
      'Kategori',
      'Qty',
      'Harga Satuan',
      'Subtotal Item',
      'Subtotal Transaksi',
      'Diskon',
      'Total Bayar',
      'Dibayar',
      'Kembalian',
      'Metode Bayar',
      'Keterangan'
    ];

    const rows: any[][] = [];
    let rowNumber = 0;

    // Sort by date descending
    const sortedTransactions = [...transactions].sort((a, b) =>
      new Date(b.createdAt).getTime() - new Date(a.createdAt).getTime()
    );

    sortedTransactions.forEach((t) => {
      const date = format(new Date(t.createdAt), 'yyyy-MM-dd');
      const time = format(new Date(t.createdAt), 'HH:mm:ss');
      const status = t.status === 'SUKSES' ? 'Lunas' : t.status === 'HUTANG' ? 'Hutang' : 'Retur';
      const totalAmount = Number(t.totalAmount || 0);
      const discount = Number(t.discountAmount || 0);
      const paymentAmount = Number(t.paymentAmount || 0);
      const changeAmount = Number(t.changeAmount || 0);
      const metodeBayar = t.status === 'HUTANG' ? 'Hutang' : 'Tunai';
      const keterangan = t.status === 'HUTANG' ? (t.debt?.customerName || '-') : '-';

      if (t.products && t.products.length > 0) {
        t.products.forEach((p: any) => {
          rowNumber++;
          const productName = p.product?.productstock?.name || '-';
          const brand = p.product?.productstock?.brand || '-';
          const category = p.product?.productstock?.category || p.product?.productstock?.masterCategory || '-';
          const qty = p.quantity || 0;
          const hargaSatuan = Number(p.product?.sellprice || 0);
          const subtotalItem = qty * hargaSatuan;

          rows.push([
            rowNumber,
            t.id,
            date,
            time,
            status,
            `"${productName}"`,
            brand,
            `"${category}"`,
            qty,
            hargaSatuan,
            subtotalItem,
            totalAmount,
            discount,
            totalAmount,
            paymentAmount,
            changeAmount,
            metodeBayar,
            `"${keterangan}"`
          ]);
        });
      } else {
        rowNumber++;
        rows.push([
          rowNumber,
          t.id,
          date,
          time,
          status,
          '-',
          '-',
          '-',
          0,
          0,
          0,
          totalAmount,
          discount,
          totalAmount,
          paymentAmount,
          changeAmount,
          metodeBayar,
          `"${keterangan}"`
        ]);
      }
    });

    // Add summary at the end
    const totalRevenue = sortedTransactions
      .filter(t => t.status !== 'RETUR')
      .reduce((sum, t) => sum + Number(t.totalAmount || 0), 0);
    const totalDiscount = sortedTransactions.reduce((sum, t) => sum + Number(t.discountAmount || 0), 0);
    const totalPaid = sortedTransactions.reduce((sum, t) => sum + Number(t.paymentAmount || 0), 0);
    const totalHutang = sortedTransactions
      .filter(t => t.status === 'HUTANG')
      .reduce((sum, t) => sum + (Number(t.totalAmount || 0) - Number(t.paymentAmount || 0)), 0);

    rows.push([]);
    rows.push(['', '', '', '', '', '', '', '', '', '', 'TOTAL OMSET', totalRevenue, '', '', '', '', '', '']);
    rows.push(['', '', '', '', '', '', '', '', '', '', 'TOTAL DISKON', totalDiscount, '', '', '', '', '', '']);
    rows.push(['', '', '', '', '', '', '', '', '', '', 'TOTAL DIBAYAR', totalPaid, '', '', '', '', '', '']);
    rows.push(['', '', '', '', '', '', '', '', '', '', 'TOTAL HUTANG', totalHutang, '', '', '', '', '', '']);
    rows.push(['', '', '', '', '', '', '', '', '', '', 'TOTAL TRANSAKSI', sortedTransactions.length, '', '', '', '', '', '']);

    const csvContent = [headers, ...rows].map(e => e.join(';')).join('\n');
    const fileName = `Laporan_Penjualan_${startDate}_${endDate}.csv`;

    if (Capacitor.isNativePlatform()) {
      try {
        const base64Data = btoa(unescape(encodeURIComponent('\ufeff' + csvContent)));
        const result = await Filesystem.writeFile({
          path: fileName,
          data: base64Data,
          directory: Directory.Cache
        });
        await Share.share({
          title: 'Laporan Penjualan CSV',
          url: result.uri,
          dialogTitle: 'Bagikan atau Simpan Laporan'
        });
      } catch (e) {
        console.error('Failed to export CSV', e);
      }
    } else {
      const blob = new Blob(['\ufeff' + csvContent], { type: 'text/csv;charset=utf-8;' });
      const link = document.createElement('a');
      link.href = URL.createObjectURL(blob);
      link.download = fileName;
      link.click();
    }
  };

  return (
    <div className="h-full flex flex-col bg-[#F4F5F7] dark:bg-[#1D2125]">
      {/* Header */}
      <div className="h-16 flex items-center justify-between px-6 bg-white dark:bg-[#22272B] border-b border-[#DFE1E6] dark:border-[#2C333A] sticky top-0 z-20">
        <div className="flex items-center gap-6">
          <div className="flex items-center gap-3">
            <div className="p-2 bg-[#0052CC]/10 dark:bg-[#0052CC]/20 rounded-lg">
              <TrendingUp className="w-5 h-5 text-[#0052CC] dark:text-[#579DFF]" />
            </div>
            <h1 className="text-lg font-bold text-[#172B4D] dark:text-white whitespace-nowrap">Riwayat & Laporan</h1>
          </div>

          <Tabs value={activeTab} onValueChange={setActiveTab} className="hidden md:block">
            <TabsList className="bg-[#EBECF0] dark:bg-[#1D2125] p-1 h-10 border border-[#DFE1E6] dark:border-[#2C333A]">
              <TabsTrigger value="laporan" className="gap-2 px-4 data-[state=active]:bg-white dark:data-[state=active]:bg-[#2C333A]">
                <FileText className="w-4 h-4" />
                <span>Ringkasan Laporan</span>
              </TabsTrigger>
              <TabsTrigger value="riwayat" className="gap-2 px-4 data-[state=active]:bg-white dark:data-[state=active]:bg-[#2C333A]">
                <History className="w-4 h-4" />
                <span>Riwayat Transaksi</span>
              </TabsTrigger>
            </TabsList>
          </Tabs>
        </div>

        <div className="flex items-center gap-3">
          <div className="flex items-center gap-2 bg-white dark:bg-[#1D2125] border border-[#DFE1E6] dark:border-[#2C333A] rounded-md px-3 h-10">
            <Calendar className="w-4 h-4 text-[#626F86] shrink-0" />
            <input
              type="date"
              value={startDate}
              max={endDate}
              onChange={(e) => setStartDate(e.target.value)}
              className="bg-transparent border-none outline-none text-sm text-[#172B4D] dark:text-[#B6C2CF] w-[130px] cursor-pointer"
            />
            <span className="text-[#626F86] text-sm">-</span>
            <input
              type="date"
              value={endDate}
              min={startDate}
              onChange={(e) => setEndDate(e.target.value)}
              className="bg-transparent border-none outline-none text-sm text-[#172B4D] dark:text-[#B6C2CF] w-[130px] cursor-pointer"
            />
          </div>
          <Button variant="outline" onClick={handleExport} disabled={loading || transactions.length === 0} className="gap-2 border-[#DFE1E6] dark:border-[#2C333A] h-10">
            <Download className="w-4 h-4 text-[#626F86]" />
            <span className="hidden sm:inline">Ekspor CSV</span>
          </Button>
        </div>
      </div>

      {/* Tabs Mobile Header (Visible only on small screens) */}
      <div className="md:hidden px-6 pt-4 bg-white dark:bg-[#22272B] border-b border-[#DFE1E6] dark:border-[#2C333A]">
        <Tabs value={activeTab} onValueChange={setActiveTab} className="w-full">
          <TabsList className="grid grid-cols-2 w-full mb-2">
            <TabsTrigger value="laporan">Laporan</TabsTrigger>
            <TabsTrigger value="riwayat">Riwayat</TabsTrigger>
          </TabsList>
        </Tabs>
      </div>

      <div className="flex-1 overflow-y-auto p-6">
        <Tabs value={activeTab} className="space-y-6">
          <TabsContent value="laporan" className="space-y-6 m-0 border-none p-0 outline-none">
            {/* Quick Stats Grid */}
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
              <div className="bg-white dark:bg-[#22272B] p-5 rounded-lg border border-[#DFE1E6] dark:border-[#2C333A] shadow-sm">
                <div className="flex justify-between items-start mb-2">
                  <span className="text-xs font-semibold text-[#626F86] dark:text-[#8C9BAB] uppercase tracking-wider">Total Omset</span>
                  <Banknote className="w-4 h-4 text-[#0052CC]" />
                </div>
                <div className="text-2xl font-bold text-[#172B4D] dark:text-white">
                  Rp {stats.totalRevenue.toLocaleString('id-ID')}
                </div>
              </div>
              <div className="bg-white dark:bg-[#22272B] p-5 rounded-lg border border-[#DFE1E6] dark:border-[#2C333A] shadow-sm">
                <div className="flex justify-between items-start mb-2">
                  <span className="text-xs font-semibold text-[#626F86] dark:text-[#8C9BAB] uppercase tracking-wider">Total Profit</span>
                  <TrendingUp className="w-4 h-4 text-[#36B37E]" />
                </div>
                <div className="text-2xl font-bold text-[#36B37E]">
                  Rp {stats.totalProfit.toLocaleString('id-ID')}
                </div>
              </div>
              <div className="bg-white dark:bg-[#22272B] p-5 rounded-lg border border-[#DFE1E6] dark:border-[#2C333A] shadow-sm">
                <div className="flex justify-between items-start mb-2">
                  <span className="text-xs font-semibold text-[#626F86] dark:text-[#8C9BAB] uppercase tracking-wider">Transaksi</span>
                  <ShoppingBag className="w-4 h-4 text-[#6554C0]" />
                </div>
                <div className="text-2xl font-bold text-[#172B4D] dark:text-white">
                  {stats.totalTransactions}
                </div>
              </div>
              <div className="bg-white dark:bg-[#22272B] p-5 rounded-lg border border-[#DFE1E6] dark:border-[#2C333A] shadow-sm">
                <div className="flex justify-between items-start mb-2">
                  <span className="text-xs font-semibold text-[#626F86] dark:text-[#8C9BAB] uppercase tracking-wider">Rata-rata Struk</span>
                  <Package className="w-4 h-4 text-[#FF991F]" />
                </div>
                <div className="text-2xl font-bold text-[#172B4D] dark:text-white">
                  Rp {Math.round(stats.avgTransaction).toLocaleString('id-ID')}
                </div>
              </div>
            </div>

            {/* Charts Grid */}
            <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
              <div className="lg:col-span-2 bg-white dark:bg-[#22272B] border border-[#DFE1E6] dark:border-[#2C333A] rounded-lg p-5 flex flex-col shadow-sm">
                <div className="flex items-center justify-between mb-6">
                  <h3 className="font-bold text-[#172B4D] dark:text-white text-base">Tren Penjualan</h3>
                  <div className="flex items-center gap-4">
                    <div className="flex items-center gap-1.5">
                      <div className="w-3 h-3 rounded-full bg-[#0052CC]" />
                      <span className="text-xs text-[#626F86] dark:text-[#8C9BAB]">Omset</span>
                    </div>
                    <div className="flex items-center gap-1.5">
                      <div className="w-3 h-3 rounded-full bg-[#36B37E]" />
                      <span className="text-xs text-[#626F86] dark:text-[#8C9BAB]">Profit</span>
                    </div>
                  </div>
                </div>
                <div className="flex-1 min-h-[320px]">
                  {loading ? (
                    <div className="w-full h-full flex items-center justify-center text-xs text-[#626F86]">Memuat grafik...</div>
                  ) : (
                    <Chart key={`sales-${profitData.length}`} options={salesOptions} series={salesSeries} type="area" height="100%" />
                  )}
                </div>
              </div>
              <div className="bg-white dark:bg-[#22272B] border border-[#DFE1E6] dark:border-[#2C333A] rounded-lg p-5 flex flex-col shadow-sm">
                <h3 className="font-bold text-[#172B4D] dark:text-white text-base mb-6">Distribusi Brand</h3>
                <div className="flex-1 min-h-[300px] flex items-center justify-center">
                  {loading ? <div className="text-xs text-[#626F86]">Memuat data...</div> : (
                    <Chart key={`brand-${brandStats.series.length}`} options={categoryOptions} series={brandStats.series} type="donut" width="100%" />
                  )}
                </div>
              </div>
            </div>
          </TabsContent>

          <TabsContent value="riwayat" className="m-0 border-none p-0 outline-none">
            <div className="bg-white dark:bg-[#22272B] border border-[#DFE1E6] dark:border-[#2C333A] rounded-lg flex flex-col shadow-sm overflow-hidden min-h-[500px]">
              <div className="p-4 border-b border-[#DFE1E6] dark:border-[#2C333A] flex flex-col md:flex-row gap-4 justify-between items-center">
                <div className="relative w-full md:w-96">
                  <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-[#626F86]" />
                  <Input
                    placeholder="Cari ID Transaksi atau Nama Produk..."
                    className="pl-10 h-10 bg-[#FAFBFC] dark:bg-[#1D2125] border-[#DFE1E6] dark:border-[#2C333A]"
                    value={searchQuery}
                    onChange={(e) => setSearchQuery(e.target.value)}
                  />
                </div>
                <div className="flex items-center gap-2 text-xs text-[#626F86] dark:text-[#8C9BAB]">
                  <span>Menampilkan <b>{filteredTransactions.length}</b> transaksi</span>
                </div>
              </div>

              <div className="overflow-x-auto flex-1">
                <table className="w-full text-sm text-left border-collapse">
                  <thead className="bg-[#FAFBFC] dark:bg-[#1D2125] text-[#626F86] dark:text-[#8C9BAB] text-xs uppercase font-bold border-b border-[#DFE1E6] dark:border-[#2C333A] sticky top-0">
                    <tr>
                      <th className="px-6 py-4">ID Transaksi</th>
                      <th className="px-6 py-4">Waktu</th>
                      <th className="px-6 py-4">Status</th>
                      <th className="px-6 py-4">Detail Items</th>
                      <th className="px-6 py-4 text-right">Total</th>
                      <th className="px-6 py-4 text-center">Aksi</th>
                    </tr>
                  </thead>
                  <tbody className="divide-y divide-[#DFE1E6] dark:divide-[#2C333A]">
                    {loading ? (
                      [...Array(8)].map((_, i) => (
                        <tr key={i}><td colSpan={5} className="px-6 py-8"><div className="h-4 bg-[#EBECF0] dark:bg-[#2C333A] rounded animate-pulse w-full max-w-lg mx-auto" /></td></tr>
                      ))
                    ) : filteredTransactions.length === 0 ? (
                      <tr><td colSpan={5} className="px-6 py-20 text-center text-[#626F86]">Tidak ada transaksi ditemukan</td></tr>
                    ) : (
                      filteredTransactions.map((t) => (
                        <tr key={t.id} className="hover:bg-[#F4F5F7] dark:hover:bg-[#2C333A] transition-colors group">
                          <td className="px-6 py-4">
                            <span className="font-mono font-bold text-[#0052CC]">{t.id}</span>
                          </td>
                          <td className="px-6 py-4 text-[#44546F] dark:text-[#9FADBC]">
                            <div className="text-sm font-medium">{format(new Date(t.createdAt), 'dd MMM yyyy', { locale: id })}</div>
                            <div className="text-[10px] opacity-70">{format(new Date(t.createdAt), 'HH:mm:ss')}</div>
                          </td>
                          <td className="px-6 py-4">
                            <span className={`inline-flex items-center px-2 py-0.5 rounded text-[10px] font-bold uppercase ${t.status === 'RETUR' ? 'bg-[#FFEBE6] text-[#BF2600]' : 'bg-[#E3FCEF] text-[#006644]'}`}>
                              {t.status || 'SUKSES'}
                            </span>
                          </td>
                          <td className="px-6 py-4">
                            <div className="flex flex-wrap gap-1 max-w-xs">
                              {t.products?.slice(0, 2).map((p: any, idx: number) => (
                                <span key={idx} className="inline-flex items-center px-2 py-0.5 rounded text-[10px] font-medium bg-[#EBECF0] dark:bg-[#1D2125] text-[#44546F] dark:text-[#B6C2CF]">
                                  {p.product?.productstock?.name} (x{p.quantity})
                                </span>
                              ))}
                              {t.products?.length > 2 && (
                                <span className="text-[10px] text-[#626F86] font-medium">+{t.products.length - 2} lainnya</span>
                              )}
                            </div>
                          </td>
                          <td className="px-6 py-4 text-right font-bold text-[#172B4D] dark:text-white">
                            Rp {Number(t.totalAmount || 0).toLocaleString('id-ID')}
                          </td>
                          <td className="px-6 py-4 text-center">
                            <Link href={`/records/${t.id}`}>
                              <Button variant="ghost" size="sm" className="h-8 gap-2 hover:bg-[#0052CC] hover:text-white transition-all rounded-full px-3">
                                <Eye className="w-4 h-4" />
                                <span className="text-xs">Detail</span>
                              </Button>
                            </Link>
                          </td>
                        </tr>
                      ))
                    )}
                  </tbody>
                </table>
              </div>
            </div>
          </TabsContent>
        </Tabs>
      </div>
    </div>
  );
}
