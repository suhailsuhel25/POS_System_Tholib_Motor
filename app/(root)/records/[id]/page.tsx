'use client';
import { Printer, ChevronRight, RotateCcw } from 'lucide-react';
import { format } from 'date-fns';
import { id } from 'date-fns/locale';

import { Button } from '@/components/ui/button';
import {
  Card,
  CardContent,
  CardFooter,
  CardHeader,
} from '@/components/ui/card';
import axios from 'axios';
import { useEffect, useRef, useState } from 'react';
import { useReactToPrint } from 'react-to-print';
import { useRouter } from 'next/navigation';

import { ReceiptContent } from '@/components/ReceiptContent';

export default function DetailPage({ params }: { params: { id: string } }) {
  // State variables
  const [transaction, setTransaction] = useState<any>(null);
  const [loading, setLoading] = useState(true);
  const [printing, setPrinting] = useState(false);
  const [updating, setUpdating] = useState(false);

  // Reference for printing
  const route = useRouter();
  const componentRef = useRef<HTMLDivElement>(null);

  // Handle printing
  const handlePrint = useReactToPrint({
    content: () => componentRef.current,
    documentTitle: `Receipt-${params.id}`,
    onBeforeGetContent: () => {
      setPrinting(true);
    },
    onAfterPrint: () => {
      setPrinting(false);
    },
  });

  // Fetch transaction data for the given ID on component mount
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
      const response = await axios.patch(`/api/transactions/${params.id}`, {
        status: 'RETUR'
      });

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
        <p className="text-muted-foreground animate-pulse">Memuat detail transaksi...</p>
      </div>
    );
  }

  if (!transaction) return null;

  // Transform data for ReceiptContent
  const formattedData = {
    id: transaction.id,
    createdAt: transaction.createdAt,
    items: (transaction.products || []).map((item: any) => ({
      name: item.product?.productstock?.name || 'Produk Tidak Diketahui',
      brand: item.product?.productstock?.brand,
      quantity: item.quantity,
      price: Number(item.product?.sellprice || 0)
    })),
    total: Number(transaction.totalAmount || 0),
    paymentAmount: Number(transaction.paymentAmount || 0),
    changeAmount: Number(transaction.changeAmount || 0),
    status: transaction.status
  };

  // Render the component
  return (
    <div className="w-full h-full p-6 flex flex-col items-center overflow-y-auto bg-[#F4F5F7] dark:bg-[#1D2125]">
      <div className="mb-6 w-full max-w-[500px] flex justify-between items-center print:hidden">
        <Button variant="ghost" className="gap-2" onClick={() => route.back()}>
          <ChevronRight className="w-4 h-4 rotate-180" />
          Kembali
        </Button>
        <div className="flex items-center gap-2">
          {transaction.status !== 'RETUR' && (
            <Button
              size="sm"
              variant="outline"
              className="border-[#DE350B] text-[#DE350B] hover:bg-[#FFEBE6] gap-2 shadow-sm"
              onClick={handleReturn}
              disabled={updating}
            >
              <RotateCcw className="w-4 h-4" />
              Retur
            </Button>
          )}
          <Button
            size="sm"
            className="bg-[#0052CC] hover:bg-[#0747A6] text-white gap-2 px-4 shadow-sm"
            onClick={handlePrint}
            disabled={printing}
          >
            <Printer className="w-4 h-4" />
            Cetak
          </Button>
        </div>
      </div>

      <div className="flex flex-col items-center">
        <ReceiptContent ref={componentRef} transaction={formattedData} />
      </div>
    </div>
  );
}
