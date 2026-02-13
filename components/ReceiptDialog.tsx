'use client';

import React, { useRef } from 'react';
import { useReactToPrint } from 'react-to-print';
import { Printer, CheckCircle2, ChevronRight, X } from 'lucide-react';
import { format } from 'date-fns';
import { id as localeId } from 'date-fns/locale';
import {
    Dialog,
    DialogContent,
    DialogHeader,
    DialogTitle,
    DialogFooter,
} from "@/components/ui/dialog";
import { Button } from '@/components/ui/button';
import { Card, CardContent, CardFooter, CardHeader } from '@/components/ui/card';

import { ReceiptContent } from './ReceiptContent';

interface ReceiptDialogProps {
    open: boolean;
    onClose: () => void;
    transactionData: any;
}

export function ReceiptDialog({ open, onClose, transactionData }: ReceiptDialogProps) {
    const componentRef = useRef<HTMLDivElement>(null);

    const handlePrint = useReactToPrint({
        content: () => componentRef.current,
        documentTitle: `Receipt-${transactionData?.id || 'new'}`,
    });

    if (!transactionData) return null;

    // Transform data for ReceiptContent
    const formattedData = {
        id: transactionData.id,
        createdAt: transactionData.createdAt || new Date(),
        items: transactionData.items.map((item: any) => ({
            name: item.name,
            brand: item.brand,
            quantity: item.quantity,
            price: item.price
        })),
        total: transactionData.total,
        paymentAmount: transactionData.paymentAmount,
        changeAmount: transactionData.changeAmount,
        status: transactionData.status
    };

    return (
        <Dialog open={open} onOpenChange={onClose}>
            <DialogContent className="max-w-[400px] border-[#DFE1E6] dark:border-[#2C333A] bg-[#F4F5F7] dark:bg-[#1D2125] p-0 overflow-hidden">
                <DialogHeader className="p-4 bg-white dark:bg-[#22272B] border-b border-[#DFE1E6] dark:border-[#2C333A] flex-row items-center justify-between space-y-0">
                    <div className="flex items-center gap-2">
                        <div className="w-8 h-8 rounded-full bg-[#E3FCEF] dark:bg-[#1C3329] flex items-center justify-center">
                            <CheckCircle2 className="w-4 h-4 text-[#006644] dark:text-[#22A06B]" />
                        </div>
                        <DialogTitle className="text-base font-bold text-[#172B4D] dark:text-white">
                            Transaksi Berhasil
                        </DialogTitle>
                    </div>
                    <button onClick={onClose} className="p-1.5 hover:bg-[#EBECF0] dark:hover:bg-[#2C333A] rounded-full transition-colors">
                        <X className="w-4 h-4 text-[#626F86]" />
                    </button>
                </DialogHeader>

                <div className="p-4 max-h-[70vh] overflow-y-auto flex flex-col items-center">
                    <ReceiptContent ref={componentRef} transaction={formattedData} />
                </div>

                <DialogFooter className="p-4 bg-white dark:bg-[#22272B] border-t border-[#DFE1E6] dark:border-[#2C333A] flex-row gap-2">
                    <Button
                        variant="outline"
                        onClick={onClose}
                        className="flex-1 h-10 text-xs font-bold border-[#DFE1E6] dark:border-[#2C333A] text-[#44546F] dark:text-[#9FADBC]"
                    >
                        Tutup
                    </Button>
                    <Button
                        onClick={handlePrint}
                        className="flex-1 h-10 text-xs bg-[#0052CC] hover:bg-[#0747A6] text-white font-bold gap-2"
                    >
                        <Printer className="w-3.5 h-3.5" />
                        Cetak Struk
                    </Button>
                </DialogFooter>
            </DialogContent>
        </Dialog>
    );
}
