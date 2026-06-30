'use client';

import React, { useState } from 'react';
import axios from '@/lib/axios';
import { toast } from 'react-toastify';
import { Button } from '@/components/ui/button';
import {
  X, CreditCard, Tag, FileText, CheckSquare, Square, Percent,
  Banknote, ShoppingBag, ChevronRight, ChevronDown
} from 'lucide-react';

interface ProductItem {
  id: string;
  quantity: number;
  product: {
    productstock: {
      name: string;
      brand: string;
    };
  };
}

interface Debt {
  id: string;
  amount: number;
  paidSoFar?: number;
  createdAt: string;
  notes: string | null;
  transaction: {
    id: string;
    products?: ProductItem[];
  };
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
  const [discountPercent, setDiscountPercent] = useState('');
  const [notes, setNotes] = useState('');
  const [loading, setLoading] = useState(false);
  const [payMode, setPayMode] = useState<'lunas' | 'sebagian'>('lunas');
  const [customAmount, setCustomAmount] = useState('');
  const [expandedItems, setExpandedItems] = useState<Set<string>>(new Set());

  React.useEffect(() => {
    if (open) {
      setSelectedIds(new Set(unpaidDebts.map((d) => d.id)));
      setDiscountPercent('');
      setNotes('');
      setPayMode('lunas');
      setCustomAmount('');
      setExpandedItems(new Set());
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

  const toggleExpanded = (id: string) => {
    setExpandedItems((prev) => {
      const next = new Set(prev);
      if (next.has(id)) next.delete(id);
      else next.add(id);
      return next;
    });
  };

  const selectedDebts = unpaidDebts.filter((d) => selectedIds.has(d.id));
  // Gunakan sisa hutang (amount - paidSoFar) bukan amount penuh
  const subtotal = selectedDebts.reduce((sum, d) => sum + Math.max(0, d.amount - (d.paidSoFar || 0)), 0);
  const discountPct = Math.min(Math.max(Number(discountPercent) || 0, 0), 100);
  const discountAmount = Math.round(subtotal * discountPct / 100);
  const totalAfterDiscount = Math.max(0, subtotal - discountAmount);
  const customAmountNum = Number(customAmount) || 0;
  const total = payMode === 'lunas' ? totalAfterDiscount : Math.min(customAmountNum, totalAfterDiscount);

  const handlePay = async () => {
    if (selectedIds.size === 0) {
      toast.warning('Pilih minimal 1 hutang untuk dibayar');
      return;
    }
    if (payMode === 'sebagian' && customAmountNum <= 0) {
      toast.warning('Masukkan nominal yang ingin dibayar');
      return;
    }
    try {
      setLoading(true);
      await axios.post('/api/debts/pay', {
        bengkelId,
        debtIds: Array.from(selectedIds),
        discountPercent: discountPct,
        ...(payMode === 'sebagian' ? { customAmount: total } : {}),
        notes: notes || undefined,
      });
      if (payMode === 'lunas') {
        toast.success(`${selectedIds.size} hutang berhasil dilunasi!`);
      } else {
        toast.success(`Cicilan ${fmt(total)} berhasil dicatat!`);
      }
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
      <div className="relative w-full max-w-md bg-white dark:bg-[#22272B] rounded-xl shadow-2xl border border-[#DFE1E6] dark:border-[#2C333A] z-10 flex flex-col max-h-[90vh]">
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
            const products = debt.transaction.products || [];
            const isExpanded = expandedItems.has(debt.id);
            return (
              <div key={debt.id} className={`border-b border-[#DFE1E6] dark:border-[#2C333A] transition-colors ${
                isSelected ? 'bg-[#E9F2FF] dark:bg-[#1C2B41]' : 'hover:bg-[#F4F5F7] dark:hover:bg-[#2C333A]'
              }`}>
                <button
                  onClick={() => toggleDebt(debt.id)}
                  className="w-full flex items-center gap-3 px-5 py-3 text-left"
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
                      <div className="text-right">
                        <span className="text-sm font-bold text-[#172B4D] dark:text-white">
                          {fmt(Math.max(0, debt.amount - (debt.paidSoFar || 0)))}
                        </span>
                        {(debt.paidSoFar || 0) > 0 && (
                          <span className="block text-[10px] text-[#626F86] line-through">{fmt(debt.amount)}</span>
                        )}
                      </div>
                    </div>
                    <div className="flex items-center justify-between mt-0.5">
                      <span className="text-xs text-[#626F86] dark:text-[#8C9BAB]">
                        {date.toLocaleDateString('id-ID', { day: 'numeric', month: 'short', year: 'numeric' })}
                      </span>
                      {(debt.paidSoFar || 0) > 0 ? (
                        <span className="text-[10px] text-[#36B37E] font-semibold">sudah cicil {fmt(debt.paidSoFar!)}</span>
                      ) : debt.notes ? (
                        <span className="text-xs text-[#626F86] truncate max-w-[120px]">{debt.notes}</span>
                      ) : null}
                    </div>
                  </div>
                </button>

                {/* Product details in payment modal */}
                {products.length > 0 && (
                  <div className="px-5 pb-2">
                    <button
                      onClick={() => toggleExpanded(debt.id)}
                      className="flex items-center gap-1 text-[10px] font-semibold text-[#0052CC] dark:text-[#579DFF] hover:underline ml-7"
                    >
                      <ShoppingBag className="w-2.5 h-2.5" />
                      {products.length} barang
                      {isExpanded ? <ChevronDown className="w-2.5 h-2.5" /> : <ChevronRight className="w-2.5 h-2.5" />}
                    </button>
                    {isExpanded && (
                      <div className="ml-7 mt-1 space-y-0.5">
                        {products.map((item) => (
                          <div key={item.id} className="flex items-center gap-1.5 text-[10px] text-[#44546F] dark:text-[#9FADBC]">
                            <span className="truncate">{item.product.productstock.name}</span>
                            <span className="text-[#626F86]">×{item.quantity}</span>
                          </div>
                        ))}
                      </div>
                    )}
                  </div>
                )}
              </div>
            );
          })}
        </div>

        {/* Summary & Actions */}
        <div className="shrink-0 border-t border-[#DFE1E6] dark:border-[#2C333A] p-5 space-y-4 bg-[#F4F5F7] dark:bg-[#1D2125]">
          {/* Mode Pembayaran: Lunas atau Sebagian */}
          <div>
            <label className="text-xs font-semibold text-[#626F86] dark:text-[#8C9BAB] uppercase mb-2 block">
              Mode Pembayaran
            </label>
            <div className="grid grid-cols-2 gap-2">
              <button
                onClick={() => setPayMode('lunas')}
                className={`flex items-center justify-center gap-2 py-2.5 rounded-lg border-2 text-sm font-bold transition-all ${
                  payMode === 'lunas'
                    ? 'border-[#36B37E] bg-[#E3FCEF] dark:bg-[#1A3A2A] text-[#006644] dark:text-[#36B37E]'
                    : 'border-[#DFE1E6] dark:border-[#2C333A] bg-white dark:bg-[#22272B] text-[#626F86] hover:border-[#36B37E]'
                }`}
              >
                <CheckSquare className="w-4 h-4" />
                Lunas
              </button>
              <button
                onClick={() => setPayMode('sebagian')}
                className={`flex items-center justify-center gap-2 py-2.5 rounded-lg border-2 text-sm font-bold transition-all ${
                  payMode === 'sebagian'
                    ? 'border-[#FF8B00] bg-[#FFF0B3] dark:bg-[#3D2E00] text-[#974F0C] dark:text-[#FF8B00]'
                    : 'border-[#DFE1E6] dark:border-[#2C333A] bg-white dark:bg-[#22272B] text-[#626F86] hover:border-[#FF8B00]'
                }`}
              >
                <Banknote className="w-4 h-4" />
                Bayar Sebagian
              </button>
            </div>
          </div>

          {/* Bayar Sebagian: Input custom amount */}
          {payMode === 'sebagian' && (
            <div>
              <label className="text-xs font-semibold text-[#626F86] dark:text-[#8C9BAB] uppercase mb-1.5 block">
                Nominal yang Dibayar (Rp)
              </label>
              <div className="relative">
                <Banknote className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-[#626F86]" />
                <input
                  type="number"
                  min={0}
                  max={totalAfterDiscount}
                  value={customAmount}
                  onChange={(e) => setCustomAmount(e.target.value)}
                  placeholder="Masukkan nominal..."
                  className="w-full h-10 pl-9 pr-3 rounded-lg border border-[#DFE1E6] dark:border-[#2C333A] bg-white dark:bg-[#22272B] text-sm text-[#172B4D] dark:text-white placeholder:text-[#626F86] focus:outline-none focus:ring-2 focus:ring-[#FF8B00] transition-all"
                />
              </div>
              <p className="text-[10px] text-[#974F0C] mt-1">
                * Hutang tetap tercatat belum lunas sampai dibayar penuh
              </p>
            </div>
          )}

          {/* Diskon (%) */}
          <div>
            <label className="text-xs font-semibold text-[#626F86] dark:text-[#8C9BAB] uppercase mb-1.5 block">
              Diskon (%)
            </label>
            <div className="relative">
              <Percent className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-[#626F86]" />
              <input
                type="number"
                min={0}
                max={100}
                value={discountPercent}
                onChange={(e) => setDiscountPercent(e.target.value)}
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
            {discountAmount > 0 && (
              <div className="flex justify-between text-sm text-[#36B37E]">
                <span>Diskon ({discountPct}%)</span>
                <span>- {fmt(discountAmount)}</span>
              </div>
            )}
            {payMode === 'lunas' ? (
              <div className="flex justify-between text-base font-bold text-[#172B4D] dark:text-white border-t border-[#DFE1E6] dark:border-[#2C333A] pt-1.5 mt-1.5">
                <span>Total Bayar (Lunas)</span>
                <span className="text-[#36B37E]">{fmt(total)}</span>
              </div>
            ) : (
              <>
                <div className="flex justify-between text-xs text-[#626F86] dark:text-[#8C9BAB]">
                  <span>Total setelah diskon</span>
                  <span>{fmt(totalAfterDiscount)}</span>
                </div>
                <div className="flex justify-between text-base font-bold text-[#172B4D] dark:text-white border-t border-[#DFE1E6] dark:border-[#2C333A] pt-1.5 mt-1.5">
                  <span>Bayar Sebagian</span>
                  <span className="text-[#FF8B00]">{fmt(total)}</span>
                </div>
                {total > 0 && total < totalAfterDiscount && (
                  <div className="flex justify-between text-xs text-[#974F0C]">
                    <span>Sisa hutang</span>
                    <span>{fmt(totalAfterDiscount - total)}</span>
                  </div>
                )}
              </>
            )}
          </div>

          {/* Button */}
          <Button
            onClick={handlePay}
            disabled={loading || selectedIds.size === 0 || (payMode === 'sebagian' && customAmountNum <= 0)}
            className={`w-full h-11 text-white font-bold text-base disabled:opacity-50 ${
              payMode === 'lunas'
                ? 'bg-[#36B37E] hover:bg-[#00875A]'
                : 'bg-[#FF8B00] hover:bg-[#E07600]'
            }`}
          >
            {loading ? 'Memproses...' : (
              payMode === 'lunas'
                ? `Lunasi ${fmt(total)}`
                : `Bayar Cicilan ${fmt(total)}`
            )}
          </Button>
        </div>
      </div>
    </div>
  );
}
