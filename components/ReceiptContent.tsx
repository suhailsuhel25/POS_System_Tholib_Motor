'use client';

import React, { forwardRef } from 'react';
import { format } from 'date-fns';
import { id as localeId } from 'date-fns/locale';
import { Card, CardContent, CardFooter, CardHeader } from '@/components/ui/card';

interface ReceiptContentProps {
    transaction: {
        id: string;
        createdAt?: string | Date;
        items: {
            name: string;
            brand?: string;
            quantity: number;
            price: number;
        }[];
        total: number;
        paymentAmount: number;
        changeAmount: number;
        status?: string;
    };
}

export const ReceiptContent = forwardRef<HTMLDivElement, ReceiptContentProps>(({ transaction }, ref) => {
    const createdAt = transaction.createdAt ? new Date(transaction.createdAt) : new Date();

    return (
        <Card
            className="w-full max-w-[320px] mx-auto bg-white dark:bg-[#22272B] border-[#DFE1E6] dark:border-[#2C333A] shadow-none print:shadow-none print:border-none print:max-w-none"
            ref={ref}
        >
            <style jsx global>{`
        @media print {
          .receipt-print-container {
            width: 80mm !important;
            padding: 4mm !important;
            margin: 0 !important;
          }
          @page {
            size: 80mm auto;
            margin: 0;
          }
        }
      `}</style>

            <div className="receipt-print-container">
                <CardHeader className="text-center pb-4 border-b border-dashed border-[#DFE1E6] dark:border-[#2C333A] px-4">
                    <div className="space-y-1">
                        <h2 className="text-lg font-black text-[#172B4D] dark:text-white uppercase tracking-tighter">
                            Tholib Motor
                        </h2>
                        <p className="text-[9px] text-[#626F86] dark:text-[#8C9BAB] leading-tight">
                            Spesialis Suku Cadang Motor<br />
                            Honda, Yamaha, Suzuki, Kawasaki<br />
                            Jl. Kebon Jeruk No. 12, Jakarta Barat
                        </p>
                    </div>
                </CardHeader>

                <CardContent className="p-4 space-y-4">
                    <div className="flex justify-between items-start text-[10px] border-b border-[#DFE1E6] dark:border-[#2C333A] pb-3">
                        <div className="space-y-0.5">
                            <p className="text-[#626F86] dark:text-[#8C9BAB]">No. Transaksi</p>
                            <p className="font-mono font-bold text-[#172B4D] dark:text-white uppercase">#{transaction.id.slice(-8)}</p>
                        </div>
                        <div className="text-right space-y-0.5">
                            <p className="text-[#626F86] dark:text-[#8C9BAB]">Waktu</p>
                            <p className="font-bold text-[#172B4D] dark:text-white">
                                {format(createdAt, 'dd/MM/yy HH:mm', { locale: localeId })}
                            </p>
                        </div>
                    </div>

                    <div className="space-y-3">
                        {transaction.items.map((item, index) => (
                            <div key={index} className="flex justify-between items-start gap-2">
                                <div className="space-y-0.5 flex-1 min-w-0">
                                    <p className="font-bold text-[#172B4D] dark:text-white text-[11px] leading-tight break-words">
                                        {item.name}
                                    </p>
                                    <div className="flex items-center gap-1.5 text-[9px] text-[#626F86] dark:text-[#8C9BAB]">
                                        {item.brand && (
                                            <span className="bg-[#EBECF0] dark:bg-[#1D2125] px-1 rounded leading-none font-medium">
                                                {item.brand}
                                            </span>
                                        )}
                                        <span>{item.quantity} x Rp{item.price.toLocaleString('id-ID')}</span>
                                    </div>
                                </div>
                                <p className="font-bold text-[#172B4D] dark:text-white text-[11px] whitespace-nowrap">
                                    Rp{(item.quantity * item.price).toLocaleString('id-ID')}
                                </p>
                            </div>
                        ))}
                    </div>

                    <div className="pt-3 border-t border-dashed border-[#DFE1E6] dark:border-[#2C333A] space-y-1.5">
                        <div className="flex justify-between items-center text-xs">
                            <span className="text-[#626F86] dark:text-[#8C9BAB] font-medium">Total</span>
                            <span className="font-black text-[#172B4D] dark:text-white">Rp{transaction.total.toLocaleString('id-ID')}</span>
                        </div>
                        <div className="flex justify-between items-center text-[11px]">
                            <span className="text-[#626F86] dark:text-[#8C9BAB]">Bayar</span>
                            <span className="text-[#172B4D] dark:text-white font-medium">Rp{transaction.paymentAmount.toLocaleString('id-ID')}</span>
                        </div>
                        <div className="flex justify-between items-center text-[11px]">
                            <span className="text-[#626F86] dark:text-[#8C9BAB]">Kembali</span>
                            <span className="text-[#172B4D] dark:text-white font-medium">Rp{transaction.changeAmount.toLocaleString('id-ID')}</span>
                        </div>
                        {transaction.status === 'RETUR' && (
                            <div className="flex justify-between items-center pt-1">
                                <span className="text-[#BF2600] font-black text-[10px] uppercase">STATUS: RETUR</span>
                            </div>
                        )}
                    </div>
                </CardContent>

                <CardFooter className="flex flex-col items-center gap-2 pb-6 pt-0 px-4">
                    <div className="text-center space-y-0.5 border-t border-dashed border-[#DFE1E6] dark:border-[#2C333A] pt-3 w-full">
                        <p className="text-[10px] font-bold text-[#172B4D] dark:text-white">Terima Kasih!</p>
                        <p className="text-[8px] text-[#626F86] dark:text-[#8C9BAB] leading-tight">
                            Barang yang sudah dibeli tidak dapat ditukar atau dikembalikan.
                        </p>
                    </div>
                </CardFooter>
            </div>
        </Card>
    );
});

ReceiptContent.displayName = 'ReceiptContent';
