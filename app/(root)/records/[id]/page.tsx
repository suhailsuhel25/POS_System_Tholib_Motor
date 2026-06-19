'use client';
import { Printer, ChevronRight, RotateCcw, CheckCircle2, XCircle, Clock, ArrowLeft, Receipt, ShoppingBag, Eye } from 'lucide-react';
import { format } from 'date-fns';
import { id } from 'date-fns/locale';

import { Button } from '@/components/ui/button';
import {
  Card,
  CardContent,
  CardHeader,
} from '@/components/ui/card';
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
} from '@/components/ui/dialog';
import axios from '@/lib/axios';
import { useEffect, useRef, useState } from 'react';
import { useReactToPrint } from 'react-to-print';
import { useRouter } from 'next/navigation';
import { toast } from 'react-toastify';

import { ReceiptContent } from '@/components/ReceiptContent';
import { BluetoothPrinterService } from '@/lib/services/bluetooth-printer';
import { buildReceiptBase64 } from '@/lib/services/receipt-builder';

const statusConfig: Record<string, { label: string; color: string; bg: string; icon: any }> = {
  COMPLETED: { label: 'Selesai', color: 'text-[#00875A]', bg: 'bg-[#E3FCEF]', icon: CheckCircle2 },
  CANCELLED: { label: 'Dibatalkan', color: 'text-[#DE350B]', bg: 'bg-[#FFEBE6]', icon: XCircle },
  RETUR: { label: 'Retur', color: 'text-[#FF5630]', bg: 'bg-[#FFEBE6]', icon: RotateCcw },
  PENDING: { label: 'Dalam Proses', color: 'text-[#FF8B00]', bg: 'bg-[#FFFAE6]', icon: Clock },
};

export default function DetailPage({ params }: { params: { id: string } }) {
  const [transaction, setTransaction] = useState<any>(null);
  const [loading, setLoading] = useState(true);
  const [printing, setPrinting] = useState(false);
  const [updating, setUpdating] = useState(false);
  const [previewOpen, setPreviewOpen] = useState(false);

  const route = useRouter();
  const componentRef = useRef<HTMLDivElement>(null);

  const handlePrintClick = async () => {
    if (!BluetoothPrinterService.isNative()) {
      toast.warning('Fitur cetak struk langsung hanya tersedia di Aplikasi Kasir Android.');
      return;
    }

    const mac = localStorage.getItem('printer_mac');
    if (!mac) {
      toast.error('Printer belum diatur! Silakan atur printer di menu Settings > Hardware.');
      return;
    }

    try {
      setPrinting(true);
      const isEnabled = await BluetoothPrinterService.checkStatus();
      if (!isEnabled) {
        toast.error('Bluetooth tidak aktif! Harap nyalakan Bluetooth di HP Anda.');
        return;
      }

      const dataToPrint = await buildReceiptBase64({
        storeName: 'Tholib Motor',
        storeSubtitle: 'Bengkel Sepeda Motor',
        storeAddress: 'Jl. Tebu No.20, RT.13/RW.7, Cakung Bar., Kec. Cakung, Kota Jakarta Timur 13910',
        storePhone: '0821-1247-8537',
        cashierName: 'Administrator',
        transactionId: transaction.id,
        createdAt: new Date(transaction.createdAt || new Date()),
        items: items.map((item: any) => ({ 
          name: item.product?.productstock?.name || 'Produk Tidak Diketahui', 
          brand: item.product?.productstock?.brand,
          qty: item.quantity, 
          price: Number(item.product?.sellprice || 0) 
        })),
        total: Number(transaction.totalAmount || 0),
        paymentAmount: Number(transaction.paymentAmount || 0),
        changeAmount: Number(transaction.changeAmount || 0),
        discountAmount: Number(transaction.discountAmount || 0),
        footerMessage: 'Barang yang sudah dibeli tidak dapat ditukar atau dikembalikan.',
        appUrl: 'http://192.168.5.23:3000'
      });
      
      await BluetoothPrinterService.printRawData(mac, dataToPrint);
      toast.success('Struk berhasil dicetak!');
    } catch (e: any) {
      console.error(e);
      toast.error(`Gagal mencetak: ${e.message || 'Koneksi ke printer terputus'}`);
    } finally {
      setPrinting(false);
    }
  };

  useEffect(() => {
    const fetchTransaction = async () => {
      try {
        setLoading(true);
        const response = await axios.get(`/api/transactions/${params.id}`);
        if (response.status === 200) {
          setTransaction(response.data);
        }
      } catch (error) {
        console.error('Error fetching details:', error);
        route.push('/records');
      } finally {
        setLoading(false);
      }
    };

    if (params.id) {
      fetchTransaction();
    }
  }, [params.id, route]);

  const handleReturn = async () => {
    if (!confirm('Apakah Anda yakin ingin membatalkan transaksi ini (RETUR)? Stok barang akan dikembalikan.')) return;

    try {
      setUpdating(true);
      const response = await axios.patch(`/api/transactions/${params.id}`, { status: 'RETUR' });
      if (response.status === 200) {
        setTransaction(response.data);
        alert('Transaksi berhasil dibatalkan dan stok telah dikembalikan.');
      }
    } catch (error) {
      console.error('Error returning transaction:', error);
      alert('Gagal memproses retur.');
    } finally {
      setUpdating(false);
    }
  };

  if (loading) {
    return (
      <div className="w-full h-full flex items-center justify-center">
        <div className="flex items-center gap-3 text-[#626F86] dark:text-[#8C9BAB]">
          <div className="w-5 h-5 border-2 border-[#0052CC] border-t-transparent rounded-full animate-spin" />
          <p>Memuat detail transaksi...</p>
        </div>
      </div>
    );
  }

  if (!transaction) return null;

  const createdAt = transaction.createdAt ? new Date(transaction.createdAt) : new Date();
  const status = statusConfig[transaction.status] || statusConfig.COMPLETED;
  const StatusIcon = status.icon;
  const items = transaction.products || [];
  const subtotal = items.reduce((sum: number, item: any) => sum + (Number(item.product?.sellprice || 0) * item.quantity), 0);
  const discount = Number(transaction.discountAmount || 0);

  const formattedData = {
    id: transaction.id,
    createdAt: transaction.createdAt,
    items: items.map((item: any) => ({
      name: item.product?.productstock?.name || 'Produk Tidak Diketahui',
      brand: item.product?.productstock?.brand,
      quantity: item.quantity,
      price: Number(item.product?.sellprice || 0),
    })),
    total: Number(transaction.totalAmount || 0),
    paymentAmount: Number(transaction.paymentAmount || 0),
    changeAmount: Number(transaction.changeAmount || 0),
    status: transaction.status,
    discountAmount: discount,
  };

  return (
    <div className="w-full h-full p-6 overflow-y-auto bg-[#F4F5F7] dark:bg-[#1D2125]">
      <div className="max-w-[640px] mx-auto space-y-5">

        {/* Header */}
        <div className="flex items-center justify-between print:hidden">
          <Button
            variant="ghost"
            className="gap-2 text-[#44546F] dark:text-[#9FADBC] hover:text-[#172B4D] dark:hover:text-white"
            onClick={() => route.back()}
          >
            <ArrowLeft className="w-4 h-4" />
            Kembali
          </Button>
          <div className="flex items-center gap-2">
            {transaction.status !== 'RETUR' && (
              <Button
                size="sm"
                variant="outline"
                className="border-[#DE350B] text-[#DE350B] hover:bg-[#FFEBE6] gap-2"
                onClick={handleReturn}
                disabled={updating}
              >
                <RotateCcw className="w-4 h-4" />
                Retur
              </Button>
            )}
            <Button
              size="sm"
              variant="outline"
              className="gap-2"
              onClick={() => setPreviewOpen(true)}
            >
              <Eye className="w-4 h-4" />
              Pratinjau Struk
            </Button>
            <Button
              size="sm"
              className="bg-[#0052CC] hover:bg-[#0747A6] text-white gap-2"
              onClick={handlePrintClick}
              disabled={printing}
            >
              <Printer className="w-4 h-4" />
              Cetak Struk
            </Button>
          </div>
        </div>

        {/* Status & Info */}
        <Card className="bg-white dark:bg-[#22272B] border-[#DFE1E6] dark:border-[#2C333A]">
          <CardContent className="p-5">
            <div className="flex items-start justify-between mb-4">
              <div className="flex items-center gap-3">
                <div className={`p-2.5 rounded-xl ${status.bg}`}>
                  <StatusIcon className={`w-5 h-5 ${status.color}`} />
                </div>
                <div>
                  <h2 className="text-base font-bold text-[#172B4D] dark:text-white">
                    Detail Transaksi
                  </h2>
                  <p className={`text-xs font-semibold ${status.color}`}>
                    {status.label}
                  </p>
                </div>
              </div>
              <div className="text-right">
                <p className="text-[10px] text-[#626F86] dark:text-[#8C9BAB]">No. Transaksi</p>
                <p className="text-xs font-mono font-bold text-[#172B4D] dark:text-white">
                  #{transaction.id.slice(-8).toUpperCase()}
                </p>
              </div>
            </div>

            <div className="grid grid-cols-2 gap-3 pt-3 border-t border-[#DFE1E6] dark:border-[#2C333A]">
              <div>
                <p className="text-[10px] text-[#626F86] dark:text-[#8C9BAB] mb-0.5">Tanggal & Waktu</p>
                <p className="text-xs font-semibold text-[#172B4D] dark:text-white">
                  {format(createdAt, 'EEEE, dd MMMM yyyy', { locale: id })}
                </p>
                <p className="text-xs text-[#626F86] dark:text-[#8C9BAB]">
                  {format(createdAt, "HH:mm", { locale: id })} WIB
                </p>
              </div>
              <div>
                <p className="text-[10px] text-[#626F86] dark:text-[#8C9BAB] mb-0.5">Total Item</p>
                <p className="text-xs font-semibold text-[#172B4D] dark:text-white">
                  {items.reduce((sum: number, item: any) => sum + item.quantity, 0)} barang
                </p>
              </div>
            </div>
          </CardContent>
        </Card>

        {/* Items */}
        <Card className="bg-white dark:bg-[#22272B] border-[#DFE1E6] dark:border-[#2C333A]">
          <CardHeader className="pb-3">
            <div className="flex items-center gap-2">
              <ShoppingBag className="w-4 h-4 text-[#626F86] dark:text-[#8C9BAB]" />
              <h3 className="text-sm font-bold text-[#172B4D] dark:text-white">Daftar Barang</h3>
              <span className="text-[10px] text-[#626F86] dark:text-[#8C9BAB] bg-[#F4F5F7] dark:bg-[#1D2125] px-1.5 py-0.5 rounded-full font-medium">
                {items.length} produk
              </span>
            </div>
          </CardHeader>
          <CardContent className="pt-0 px-5 pb-5">
            <div className="space-y-3">
              {items.map((item: any, index: number) => {
                const product = item.product?.productstock;
                const price = Number(item.product?.sellprice || 0);
                const subtotal = price * item.quantity;

                return (
                  <div
                    key={index}
                    className="flex items-center justify-between p-3 rounded-lg bg-[#F4F5F7] dark:bg-[#1D2125]"
                  >
                    <div className="flex items-center gap-3 min-w-0 flex-1">
                      <div className="w-8 h-8 rounded-lg bg-[#DEEBFF] dark:bg-[#0747A6]/30 flex items-center justify-center shrink-0">
                        <span className="text-xs font-bold text-[#0052CC] dark:text-[#579DFF]">
                          {item.quantity}x
                        </span>
                      </div>
                      <div className="min-w-0">
                        <p className="text-xs font-bold text-[#172B4D] dark:text-white truncate">
                          {product?.name || 'Produk Tidak Diketahui'}
                        </p>
                        <div className="flex items-center gap-1.5 mt-0.5">
                          {product?.brand && (
                            <span className="text-[9px] font-medium text-[#626F86] dark:text-[#8C9BAB] bg-[#DFE1E6] dark:bg-[#2C333A] px-1.5 py-0.5 rounded">
                              {product.brand}
                            </span>
                          )}
                          <span className="text-[9px] text-[#626F86] dark:text-[#8C9BAB]">
                            @ Rp{price.toLocaleString('id-ID')}
                          </span>
                        </div>
                      </div>
                    </div>
                    <p className="text-xs font-bold text-[#172B4D] dark:text-white whitespace-nowrap ml-3">
                      Rp{subtotal.toLocaleString('id-ID')}
                    </p>
                  </div>
                );
              })}
            </div>
          </CardContent>
        </Card>

        {/* Payment Summary */}
        <Card className="bg-white dark:bg-[#22272B] border-[#DFE1E6] dark:border-[#2C333A]">
          <CardContent className="p-5">
            <div className="flex items-center gap-2 mb-4">
              <Receipt className="w-4 h-4 text-[#626F86] dark:text-[#8C9BAB]" />
              <h3 className="text-sm font-bold text-[#172B4D] dark:text-white">Ringkasan Pembayaran</h3>
            </div>

            <div className="space-y-2.5">
              {discount > 0 && (
                <>
                  <div className="flex justify-between items-center text-xs">
                    <span className="text-[#626F86] dark:text-[#8C9BAB]">Subtotal</span>
                    <span className="text-[#172B4D] dark:text-white font-medium">Rp{(subtotal).toLocaleString('id-ID')}</span>
                  </div>
                  <div className="flex justify-between items-center text-xs">
                    <span className="text-[#DE350B] font-medium">Diskon</span>
                    <span className="text-[#DE350B] font-bold">-Rp{discount.toLocaleString('id-ID')}</span>
                  </div>
                </>
              )}

              <div className="flex justify-between items-center pt-2.5 border-t border-[#DFE1E6] dark:border-[#2C333A]">
                <span className="text-sm font-bold text-[#172B4D] dark:text-white">Total</span>
                <span className="text-lg font-black text-[#0052CC] dark:text-[#579DFF]">
                  Rp{Number(transaction.totalAmount || 0).toLocaleString('id-ID')}
                </span>
              </div>

              <div className="flex justify-between items-center text-xs pt-2 border-t border-dashed border-[#DFE1E6] dark:border-[#2C333A]">
                <span className="text-[#626F86] dark:text-[#8C9BAB]">Dibayar</span>
                <span className="text-[#172B4D] dark:text-white font-semibold">
                  Rp{Number(transaction.paymentAmount || 0).toLocaleString('id-ID')}
                </span>
              </div>

              <div className="flex justify-between items-center text-xs">
                <span className="text-[#626F86] dark:text-[#8C9BAB]">Kembalian</span>
                <span className="text-[#00875A] dark:text-[#57D9A3] font-bold">
                  Rp{Number(transaction.changeAmount || 0).toLocaleString('id-ID')}
                </span>
              </div>
            </div>
          </CardContent>
        </Card>

        {/* Print Area (hidden on screen) */}
        <div className="hidden print:block">
          <ReceiptContent ref={componentRef} transaction={formattedData} />
        </div>
      </div>

      {/* Preview Modal */}
      <Dialog open={previewOpen} onOpenChange={setPreviewOpen}>
        <DialogContent className="sm:max-w-[380px] bg-[#F4F5F7] dark:bg-[#1D2125] border-[#DFE1E6] dark:border-[#2C333A] p-0">
          <DialogHeader className="p-4 pb-0">
            <DialogTitle className="text-sm font-bold text-[#172B4D] dark:text-white flex items-center gap-2">
              <Eye className="w-4 h-4" />
              Pratinjau Struk
            </DialogTitle>
          </DialogHeader>
          <div className="p-4 pt-2">
            <ReceiptContent transaction={formattedData} />
          </div>
        </DialogContent>
      </Dialog>
    </div>
  );
}
