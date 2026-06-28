'use client';

import React, { useState } from 'react';
import axios from '@/lib/axios';
import { toast } from 'react-toastify';
import { Button } from '@/components/ui/button';
import { X, CreditCard, Tag, FileText, CheckSquare, Square } from 'lucide-react';

interface Debt {
  id: string;
  amount: number;
  createdAt: string;
  notes: string | null;
  transaction: { id: string };
}

interface PaymentModalProps {
  open: boolean;
  bengkelId: string;
  bengkelName: string;
  unpaidDebts: Debt[];
  onClose: () => void;
  onSuccess: () => void;
}

export default function PaymentModal({
  open,
  bengkelId,
  bengkelName,
  unpaidDebts,
  onClose,
  onSuccess,
}: PaymentModalProps) {
  const [selectedIds, setSelectedIds] = useState<Set<string>>(
    new Set(unpaidDebts.map((d) => d.id))
  );
  const [discount, setDiscount] = useState('');
  const [notes, setNotes] = useState('');
  const [loading, setLoading] = useState(false);

  React.useEffect(() => {
    if (open) {
      setSelectedIds(new Set(unpaidDebts.map((d) => d.id)));
      setDiscount('');
      setNotes('');
    }
  }, [open, unpaidDebts]);

  const toggleDebt = (id: string) => {
    setSelectedIds((prev) => {
      const next = new Set(prev);
      if (next.has(id)) next.delete(id);
      else next.add(id);
      return next;
    });
  };

  const toggleAll = () => {
    if (selectedIds.size === unpaidDebts.length) {
      setSelectedIds(new Set());
    } else {
      setSelectedIds(new Set(unpaidDebts.map((d) => d.id)));
    }
  };

  const selectedDebts = unpaidDebts.filter((d) => selectedIds.has(d.id));
  const subtotal = selectedDebts.reduce((sum, d) => sum + d.amount, 0);
  const discountNum = Math.min(Number(discount) || 0, subtotal);
  const total = Math.max(0, subtotal - discountNum);

  const handlePay = async () => {
    if (selectedIds.size === 0) {
      toast.warning('Pilih minimal 1 hutang untuk dibayar');
      return;
    }
    try {
      setLoading(true);
      await axios.post('/api/debts/pay', {
        bengkelId,
        debtIds: Array.from(selectedIds),
        discount: discountNum,
        notes: notes || undefined,
      });
      toast.success(`${selectedIds.size} hutang berhasil dilunasi!`);
      onSuccess();
      onClose();
    } catch (err: any) {
      toast.error(err.response?.data?.error || 'Terjadi kesalahan');
    } finally {
      setLoading(false);
    }
  };

  if (!open) return null;

  const fmt = (n: number) => `Rp${n.toLocaleString('id-ID')}`;

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center p-4">
      <div className="absolute inset-0 bg-black/50 backdrop-blur-sm" onClick={onClose} />
      <div className="relative w-full max-w-md bg-white dark:bg-[#22272B] rounded-xl shadow-2xl border border-[#DFE1E6] dark:border-[#2C333A] z-10 flex flex-col max-h-[85vh]">
        {/* Header */}
        <div className="flex items-center justify-between px-5 py-4 border-b border-[#DFE1E6] dark:border-[#2C333A] shrink-0">
          <div>
            <div className="flex items-center gap-2">
              <CreditCard className="w-5 h-5 text-[#0052CC] dark:text-[#579DFF]" />
              <h2 className="text-base font-bold text-[#172B4D] dark:text-white">Bayar Hutang</h2>
            </div>
            <p className="text-xs text-[#626F86] dark:text-[#8C9BAB] mt-0.5">{bengkelName}</p>
          </div>
          <button onClick={onClose} className="p-1.5 rounded hover:bg-[#EBECF0] dark:hover:bg-[#2C333A] text-[#626F86]">
            <X className="w-4 h-4" />
          </button>
        </div>

        {/* Debt List */}
        <div className="flex-1 overflow-y-auto">
          {/* Select All */}
          <button
            onClick={toggleAll}
            className="w-full flex items-center gap-3 px-5 py-3 border-b border-[#DFE1E6] dark:border-[#2C333A] hover:bg-[#F4F5F7] dark:hover:bg-[#2C333A] transition-colors text-left"
          >
            {selectedIds.size === unpaidDebts.length ? (
              <CheckSquare className="w-4 h-4 text-[#0052CC]" />
            ) : (
              <Square className="w-4 h-4 text-[#626F86]" />
            )}
            <span className="text-sm font-semibold text-[#172B4D] dark:text-white">
              Pilih Semua ({unpaidDebts.length} hutang)
            </span>
          </button>

          {unpaidDebts.map((debt) => {
            const isSelected = selectedIds.has(debt.id);
            const date = new Date(debt.createdAt);
            return (
              <button
                key={debt.id}
                onClick={() => toggleDebt(debt.id)}
                className={`w-full flex items-center gap-3 px-5 py-3 border-b border-[#DFE1E6] dark:border-[#2C333A] transition-colors text-left ${
                  isSelected ? 'bg-[#E9F2FF] dark:bg-[#1C2B41]' : 'hover:bg-[#F4F5F7] dark:hover:bg-[#2C333A]'
                }`}
              >
                {isSelected ? (
                  <CheckSquare className="w-4 h-4 text-[#0052CC] shrink-0" />
                ) : (
                  <Square className="w-4 h-4 text-[#626F86] shrink-0" />
                )}
                <div className="flex-1 min-w-0">
                  <div className="flex items-center justify-between gap-2">
                    <span className="font-mono text-xs font-bold text-[#0052CC] dark:text-[#579DFF]">
                      #{debt.transaction.id.slice(-8).toUpperCase()}
                    </span>
                    <span className="text-sm font-bold text-[#172B4D] dark:text-white">
                      {fmt(debt.amount)}
                    </span>
                  </div>
                  <div className="flex items-center justify-between mt-0.5">
                    <span className="text-xs text-[#626F86] dark:text-[#8C9BAB]">
                      {date.toLocaleDateString('id-ID', { day: 'numeric', month: 'short', year: 'numeric' })}
                    </span>
                    {debt.notes && (
                      <span className="text-xs text-[#626F86] truncate max-w-[120px]">{debt.notes}</span>
                    )}
                  </div>
                </div>
              </button>
            );
          })}
        </div>

        {/* Summary & Actions */}
        <div className="shrink-0 border-t border-[#DFE1E6] dark:border-[#2C333A] p-5 space-y-4 bg-[#F4F5F7] dark:bg-[#1D2125]">
          {/* Diskon */}
          <div>
            <label className="text-xs font-semibold text-[#626F86] dark:text-[#8C9BAB] uppercase mb-1.5 block">
              Diskon (Rp)
            </label>
            <div className="relative">
              <Tag className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-[#626F86]" />
              <input
                type="number"
                min={0}
                max={subtotal}
                value={discount}
                onChange={(e) => setDiscount(e.target.value)}
                placeholder="0"
                className="w-full h-10 pl-9 pr-3 rounded-lg border border-[#DFE1E6] dark:border-[#2C333A] bg-white dark:bg-[#22272B] text-sm text-[#172B4D] dark:text-white placeholder:text-[#626F86] focus:outline-none focus:ring-2 focus:ring-[#0052CC] transition-all"
              />
            </div>
          </div>

          {/* Catatan */}
          <div>
            <label className="text-xs font-semibold text-[#626F86] dark:text-[#8C9BAB] uppercase mb-1.5 block">
              Catatan Pembayaran
            </label>
            <div className="relative">
              <FileText className="absolute left-3 top-2.5 w-4 h-4 text-[#626F86]" />
              <textarea
                rows={1}
                value={notes}
                onChange={(e) => setNotes(e.target.value)}
                placeholder="Opsional..."
                className="w-full pl-9 pr-3 py-2 rounded-lg border border-[#DFE1E6] dark:border-[#2C333A] bg-white dark:bg-[#22272B] text-sm text-[#172B4D] dark:text-white placeholder:text-[#626F86] focus:outline-none focus:ring-2 focus:ring-[#0052CC] resize-none transition-all"
              />
            </div>
          </div>

          {/* Total */}
          <div className="bg-white dark:bg-[#22272B] rounded-lg p-3 space-y-1.5 border border-[#DFE1E6] dark:border-[#2C333A]">
            <div className="flex justify-between text-sm text-[#626F86] dark:text-[#8C9BAB]">
              <span>{selectedIds.size} hutang dipilih</span>
              <span>{fmt(subtotal)}</span>
            </div>
            {discountNum > 0 && (
              <div className="flex justify-between text-sm text-[#36B37E]">
                <span>Diskon</span>
                <span>- {fmt(discountNum)}</span>
              </div>
            )}
            <div className="flex justify-between text-base font-bold text-[#172B4D] dark:text-white border-t border-[#DFE1E6] dark:border-[#2C333A] pt-1.5 mt-1.5">
              <span>Total Bayar</span>
              <span className="text-[#0052CC] dark:text-[#579DFF]">{fmt(total)}</span>
            </div>
          </div>

          {/* Button */}
          <Button
            onClick={handlePay}
            disabled={loading || selectedIds.size === 0}
            className="w-full h-11 bg-[#36B37E] hover:bg-[#00875A] text-white font-bold text-base disabled:opacity-50"
          >
            {loading ? 'Memproses...' : `Bayar ${fmt(total)}`}
          </Button>
        </div>
      </div>
    </div>
  );
}
