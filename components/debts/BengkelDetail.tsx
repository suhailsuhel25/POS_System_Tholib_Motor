'use client';

import React, { useState } from 'react';
import useSWR from 'swr';
import axios from '@/lib/axios';
import { format, differenceInDays } from 'date-fns';
import { id as idLocale } from 'date-fns/locale';
import { toast } from 'react-toastify';
import { Button } from '@/components/ui/button';
import PaymentModal from './PaymentModal';
import AddBengkelModal from './AddBengkelModal';
import {
  Building2, Phone, MapPin, Clock, CreditCard, ChevronRight,
  AlertCircle, CheckCircle2, Package, MoreHorizontal, Edit, Trash2, History
} from 'lucide-react';
import {
  DropdownMenu, DropdownMenuContent, DropdownMenuItem,
  DropdownMenuSeparator, DropdownMenuTrigger,
} from '@/components/ui/dropdown-menu';
import {
  AlertDialog, AlertDialogAction, AlertDialogCancel,
  AlertDialogContent, AlertDialogDescription, AlertDialogFooter,
  AlertDialogHeader, AlertDialogTitle,
} from '@/components/ui/alert-dialog';

const fetcher = (url: string) => axios.get(url).then((r) => r.data);

interface Bengkel {
  id: string; name: string; phone: string | null; address: string | null;
  notes: string | null; paymentCycle: number; nextPaymentAt: string | null;
  totalUnpaid: number; unpaidCount: number;
}

interface Debt {
  id: string; amount: number; isPaid: boolean; createdAt: string;
  notes: string | null; paidAt: string | null;
  transaction: { id: string; totalAmount: number; createdAt: string };
}

interface DebtPayment {
  id: string; totalPaid: number; discount: number; notes: string | null; createdAt: string;
  debtItems: { id: string; debt: { id: string; amount: number; createdAt: string } }[];
}

interface BengkelDetailProps {
  bengkel: Bengkel;
  onMutate: () => void;
  onDeleted: () => void;
}

function getPaymentStatusInfo(nextPaymentAt: string | null, unpaidCount: number) {
  if (unpaidCount === 0) return null;
  if (!nextPaymentAt) return null;
  const days = differenceInDays(new Date(nextPaymentAt), new Date());
  if (days < 0) return { label: `Terlambat ${Math.abs(days)} hari`, color: 'text-[#DE350B] bg-[#FFEBE6]', icon: AlertCircle };
  if (days === 0) return { label: 'Jatuh tempo hari ini!', color: 'text-[#974F0C] bg-[#FFF0B3]', icon: AlertCircle };
  if (days <= 3) return { label: `Jatuh tempo ${days} hari lagi`, color: 'text-[#974F0C] bg-[#FFF0B3]', icon: Clock };
  return { label: `Jatuh tempo ${format(new Date(nextPaymentAt), 'dd MMM yyyy', { locale: idLocale })}`, color: 'text-[#0052CC] bg-[#E9F2FF]', icon: Clock };
}

export default function BengkelDetail({ bengkel, onMutate, onDeleted }: BengkelDetailProps) {
  const [activeTab, setActiveTab] = useState<'unpaid' | 'paid' | 'history'>('unpaid');
  const [showPayModal, setShowPayModal] = useState(false);
  const [showEditModal, setShowEditModal] = useState(false);
  const [showDeleteDialog, setShowDeleteDialog] = useState(false);
  const [deleting, setDeleting] = useState(false);

  const { data, mutate } = useSWR(`/api/bengkel/${bengkel.id}/debts`, fetcher);
  const debts: Debt[] = data?.debts || [];
  const payments: DebtPayment[] = data?.payments || [];
  const summary = data?.summary || { totalUnpaid: 0, unpaidCount: 0 };

  const unpaidDebts = debts.filter((d) => !d.isPaid);
  const paidDebts = debts.filter((d) => d.isPaid);

  const handleDelete = async () => {
    try {
      setDeleting(true);
      await axios.delete(`/api/bengkel/${bengkel.id}`);
      toast.success('Bengkel berhasil dihapus');
      onDeleted();
    } catch (err: any) {
      toast.error(err.response?.data?.error || 'Gagal menghapus bengkel');
    } finally {
      setDeleting(false);
      setShowDeleteDialog(false);
    }
  };

  const statusInfo = getPaymentStatusInfo(bengkel.nextPaymentAt, summary.unpaidCount);
  const fmt = (n: number) => `Rp${n.toLocaleString('id-ID')}`;

  return (
    <div className="h-full flex flex-col bg-[#F4F5F7] dark:bg-[#1D2125]">
      {/* Bengkel Header Card */}
      <div className="bg-white dark:bg-[#22272B] border-b border-[#DFE1E6] dark:border-[#2C333A] px-5 py-4">
        <div className="flex items-start justify-between gap-3">
          {/* Info */}
          <div className="flex items-start gap-3 min-w-0">
            <div className="w-12 h-12 rounded-full bg-gradient-to-br from-[#0052CC] to-[#2684FF] flex items-center justify-center text-white text-lg font-bold shrink-0">
              {bengkel.name.split(' ').slice(0, 2).map((w) => w[0]).join('').toUpperCase()}
            </div>
            <div className="min-w-0">
              <h2 className="text-base font-bold text-[#172B4D] dark:text-white truncate">{bengkel.name}</h2>
              {bengkel.phone && (
                <div className="flex items-center gap-1 mt-0.5">
                  <Phone className="w-3 h-3 text-[#626F86]" />
                  <span className="text-xs text-[#626F86] dark:text-[#8C9BAB]">{bengkel.phone}</span>
                </div>
              )}
              {bengkel.address && (
                <div className="flex items-center gap-1 mt-0.5">
                  <MapPin className="w-3 h-3 text-[#626F86]" />
                  <span className="text-xs text-[#626F86] dark:text-[#8C9BAB] truncate">{bengkel.address}</span>
                </div>
              )}
              <div className="flex items-center gap-1 mt-0.5">
                <Clock className="w-3 h-3 text-[#626F86]" />
                <span className="text-xs text-[#626F86] dark:text-[#8C9BAB]">
                  Siklus bayar: setiap {bengkel.paymentCycle} hari
                </span>
              </div>
            </div>
          </div>

          {/* Actions */}
          <DropdownMenu>
            <DropdownMenuTrigger asChild>
              <Button variant="ghost" size="icon" className="h-8 w-8 shrink-0">
                <MoreHorizontal className="w-4 h-4" />
              </Button>
            </DropdownMenuTrigger>
            <DropdownMenuContent align="end" className="w-44 bg-white dark:bg-[#22272B] border-[#DFE1E6] dark:border-[#2C333A]">
              <DropdownMenuItem onClick={() => setShowEditModal(true)} className="cursor-pointer gap-2">
                <Edit className="w-4 h-4" /> Edit Bengkel
              </DropdownMenuItem>
              <DropdownMenuSeparator />
              <DropdownMenuItem
                onClick={() => setShowDeleteDialog(true)}
                className="text-[#DE350B] focus:text-[#DE350B] focus:bg-[#FFEBE6] cursor-pointer gap-2"
              >
                <Trash2 className="w-4 h-4" /> Hapus Bengkel
              </DropdownMenuItem>
            </DropdownMenuContent>
          </DropdownMenu>
        </div>

        {/* Total Hutang & Pay Button */}
        {summary.unpaidCount > 0 && (
          <div className="mt-4 flex items-center justify-between gap-3 p-3 bg-[#FFEBE6] dark:bg-[#3D1A1A] rounded-lg">
            <div>
              <p className="text-xs text-[#974F0C] dark:text-[#FF8F73] font-semibold">Total Belum Lunas</p>
              <p className="text-xl font-black text-[#DE350B] dark:text-[#FF5630]">{fmt(summary.totalUnpaid)}</p>
              <p className="text-xs text-[#974F0C] dark:text-[#FF8F73]">{summary.unpaidCount} transaksi</p>
            </div>
            <Button
              onClick={() => setShowPayModal(true)}
              className="shrink-0 bg-[#36B37E] hover:bg-[#00875A] text-white font-bold gap-2"
            >
              <CreditCard className="w-4 h-4" />
              Bayar
            </Button>
          </div>
        )}

        {summary.unpaidCount === 0 && (
          <div className="mt-4 flex items-center gap-2 p-3 bg-[#E3FCEF] dark:bg-[#1A3A2A] rounded-lg">
            <CheckCircle2 className="w-4 h-4 text-[#36B37E]" />
            <p className="text-sm font-semibold text-[#006644] dark:text-[#36B37E]">Semua hutang sudah lunas</p>
          </div>
        )}

        {statusInfo && (
          <div className={`mt-2 flex items-center gap-2 px-3 py-2 rounded-lg text-xs font-semibold ${statusInfo.color}`}>
            <statusInfo.icon className="w-3.5 h-3.5" />
            {statusInfo.label}
          </div>
        )}
      </div>

      {/* Tabs */}
      <div className="flex border-b border-[#DFE1E6] dark:border-[#2C333A] bg-white dark:bg-[#22272B] shrink-0">
        {([
          { key: 'unpaid', label: 'Belum Lunas', count: unpaidDebts.length },
          { key: 'paid', label: 'Sudah Lunas', count: paidDebts.length },
          { key: 'history', label: 'Riwayat Bayar', count: payments.length },
        ] as const).map((tab) => (
          <button
            key={tab.key}
            onClick={() => setActiveTab(tab.key)}
            className={`flex-1 py-3 text-sm font-semibold flex items-center justify-center gap-1.5 border-b-2 transition-colors ${
              activeTab === tab.key
                ? 'border-[#0052CC] text-[#0052CC] dark:text-[#579DFF] dark:border-[#579DFF]'
                : 'border-transparent text-[#44546F] dark:text-[#9FADBC] hover:text-[#172B4D] dark:hover:text-white'
            }`}
          >
            {tab.label}
            {tab.count > 0 && (
              <span className={`text-xs rounded-full px-1.5 py-0.5 font-bold ${
                activeTab === tab.key
                  ? 'bg-[#0052CC] text-white'
                  : 'bg-[#EBECF0] dark:bg-[#2C333A] text-[#44546F] dark:text-[#9FADBC]'
              }`}>
                {tab.count}
              </span>
            )}
          </button>
        ))}
      </div>

      {/* Content */}
      <div className="flex-1 overflow-y-auto">
        {/* Unpaid Tab */}
        {activeTab === 'unpaid' && (
          <div className="p-4 space-y-2">
            {unpaidDebts.length === 0 ? (
              <div className="flex flex-col items-center justify-center py-12 text-[#626F86] dark:text-[#8C9BAB]">
                <CheckCircle2 className="w-10 h-10 mb-3 text-[#36B37E]" />
                <p className="font-semibold">Tidak ada hutang</p>
                <p className="text-sm">Semua tagihan sudah lunas</p>
              </div>
            ) : (
              unpaidDebts.map((debt) => (
                <div key={debt.id} className="bg-white dark:bg-[#22272B] rounded-lg border border-[#DFE1E6] dark:border-[#2C333A] p-3">
                  <div className="flex items-center justify-between">
                    <span className="font-mono text-xs font-bold text-[#0052CC] dark:text-[#579DFF]">
                      #{debt.transaction.id.slice(-8).toUpperCase()}
                    </span>
                    <span className="text-base font-black text-[#172B4D] dark:text-white">
                      {fmt(debt.amount)}
                    </span>
                  </div>
                  <div className="flex items-center justify-between mt-1">
                    <span className="text-xs text-[#626F86] dark:text-[#8C9BAB]">
                      {format(new Date(debt.createdAt), 'EEEE, dd MMM yyyy • HH:mm', { locale: idLocale })}
                    </span>
                    <span className="text-[10px] bg-[#FFF0B3] text-[#974F0C] font-bold px-1.5 py-0.5 rounded">
                      BELUM LUNAS
                    </span>
                  </div>
                  {debt.notes && (
                    <p className="text-xs text-[#626F86] mt-1 flex items-center gap-1">
                      <Package className="w-3 h-3" />
                      {debt.notes}
                    </p>
                  )}
                </div>
              ))
            )}
          </div>
        )}

        {/* Paid Tab */}
        {activeTab === 'paid' && (
          <div className="p-4 space-y-2">
            {paidDebts.length === 0 ? (
              <div className="flex flex-col items-center justify-center py-12 text-[#626F86] dark:text-[#8C9BAB]">
                <History className="w-10 h-10 mb-3 opacity-30" />
                <p className="font-semibold">Belum ada hutang yang lunas</p>
              </div>
            ) : (
              paidDebts.map((debt) => (
                <div key={debt.id} className="bg-white dark:bg-[#22272B] rounded-lg border border-[#DFE1E6] dark:border-[#2C333A] p-3 opacity-75">
                  <div className="flex items-center justify-between">
                    <span className="font-mono text-xs font-bold text-[#626F86]">
                      #{debt.transaction.id.slice(-8).toUpperCase()}
                    </span>
                    <span className="text-base font-black text-[#172B4D] dark:text-white line-through opacity-60">
                      {fmt(debt.amount)}
                    </span>
                  </div>
                  <div className="flex items-center justify-between mt-1">
                    <span className="text-xs text-[#626F86] dark:text-[#8C9BAB]">
                      {format(new Date(debt.createdAt), 'dd MMM yyyy', { locale: idLocale })}
                    </span>
                    <span className="text-[10px] bg-[#E3FCEF] text-[#006644] font-bold px-1.5 py-0.5 rounded">
                      LUNAS {debt.paidAt ? format(new Date(debt.paidAt), 'dd MMM', { locale: idLocale }) : ''}
                    </span>
                  </div>
                </div>
              ))
            )}
          </div>
        )}

        {/* Payment History Tab */}
        {activeTab === 'history' && (
          <div className="p-4 space-y-3">
            {payments.length === 0 ? (
              <div className="flex flex-col items-center justify-center py-12 text-[#626F86] dark:text-[#8C9BAB]">
                <History className="w-10 h-10 mb-3 opacity-30" />
                <p className="font-semibold">Belum ada riwayat pembayaran</p>
              </div>
            ) : (
              payments.map((payment) => (
                <div key={payment.id} className="bg-white dark:bg-[#22272B] rounded-lg border border-[#DFE1E6] dark:border-[#2C333A] p-4">
                  <div className="flex items-center justify-between mb-2">
                    <span className="text-sm font-bold text-[#172B4D] dark:text-white">
                      {format(new Date(payment.createdAt), 'EEEE, dd MMM yyyy', { locale: idLocale })}
                    </span>
                    <span className="text-base font-black text-[#36B37E]">{fmt(payment.totalPaid)}</span>
                  </div>
                  <div className="text-xs text-[#626F86] dark:text-[#8C9BAB] space-y-0.5">
                    <p>{payment.debtItems.length} hutang dilunasi</p>
                    {payment.discount > 0 && <p>Diskon: {fmt(payment.discount)}</p>}
                    {payment.notes && <p>Catatan: {payment.notes}</p>}
                  </div>
                </div>
              ))
            )}
          </div>
        )}
      </div>

      {/* Payment Modal */}
      <PaymentModal
        open={showPayModal}
        bengkelId={bengkel.id}
        bengkelName={bengkel.name}
        unpaidDebts={unpaidDebts}
        onClose={() => setShowPayModal(false)}
        onSuccess={() => { mutate(); onMutate(); }}
      />

      {/* Edit Modal */}
      <AddBengkelModal
        open={showEditModal}
        onClose={() => setShowEditModal(false)}
        onSuccess={() => { mutate(); onMutate(); }}
        initialData={bengkel}
      />

      {/* Delete Confirmation */}
      <AlertDialog open={showDeleteDialog} onOpenChange={setShowDeleteDialog}>
        <AlertDialogContent className="bg-white dark:bg-[#22272B] border-[#DFE1E6] dark:border-[#2C333A]">
          <AlertDialogHeader>
            <AlertDialogTitle>Hapus Bengkel?</AlertDialogTitle>
            <AlertDialogDescription>
              Bengkel <strong>{bengkel.name}</strong> akan dihapus permanen. Tindakan ini tidak dapat dibatalkan.
            </AlertDialogDescription>
          </AlertDialogHeader>
          <AlertDialogFooter>
            <AlertDialogCancel>Batal</AlertDialogCancel>
            <AlertDialogAction onClick={handleDelete} className="bg-[#DE350B] hover:bg-[#BF2600] text-white">
              {deleting ? 'Menghapus...' : 'Hapus'}
            </AlertDialogAction>
          </AlertDialogFooter>
        </AlertDialogContent>
      </AlertDialog>
    </div>
  );
}
