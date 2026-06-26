'use client';

import React from 'react';
import { format, differenceInDays } from 'date-fns';
import { id } from 'date-fns/locale';
import { Building2, Phone, Clock, AlertCircle, Plus, Search, X } from 'lucide-react';
import { Button } from '@/components/ui/button';

interface Bengkel {
  id: string;
  name: string;
  phone: string | null;
  address: string | null;
  notes: string | null;
  paymentCycle: number;
  nextPaymentAt: string | null;
  totalUnpaid: number;
  unpaidCount: number;
  totalDebtCount: number;
}

interface BengkelListProps {
  bengkels: Bengkel[];
  selectedId: string | null;
  onSelect: (bengkel: Bengkel) => void;
  onAdd: () => void;
  loading: boolean;
  search: string;
  onSearchChange: (v: string) => void;
}

function getPaymentStatus(nextPaymentAt: string | null, unpaidCount: number) {
  if (unpaidCount === 0) return 'lunas';
  if (!nextPaymentAt) return 'aktif';
  const days = differenceInDays(new Date(nextPaymentAt), new Date());
  if (days < 0) return 'lewat';
  if (days <= 3) return 'segera';
  return 'aktif';
}

const statusConfig = {
  lunas: { dot: 'bg-[#36B37E]', badge: 'bg-[#E3FCEF] text-[#006644]', label: 'Lunas' },
  aktif: { dot: 'bg-[#0052CC]', badge: 'bg-[#E9F2FF] text-[#0052CC]', label: 'Ada Hutang' },
  segera: { dot: 'bg-[#FF8B00]', badge: 'bg-[#FFF0B3] text-[#974F0C]', label: 'Jatuh Tempo' },
  lewat: { dot: 'bg-[#DE350B]', badge: 'bg-[#FFEBE6] text-[#DE350B]', label: 'Terlambat' },
};

function getInitials(name: string) {
  return name
    .split(' ')
    .slice(0, 2)
    .map((w) => w[0])
    .join('')
    .toUpperCase();
}

export default function BengkelList({
  bengkels,
  selectedId,
  onSelect,
  onAdd,
  loading,
  search,
  onSearchChange,
}: BengkelListProps) {
  const filtered = bengkels.filter((b) =>
    b.name.toLowerCase().includes(search.toLowerCase())
  );

  return (
    <div className="w-full h-full flex flex-col border-r border-[#DFE1E6] dark:border-[#2C333A] bg-white dark:bg-[#22272B]">
      {/* Header */}
      <div className="h-14 flex items-center justify-between px-4 border-b border-[#DFE1E6] dark:border-[#2C333A] shrink-0">
        <div className="flex items-center gap-2">
          <Building2 className="w-4 h-4 text-[#0052CC] dark:text-[#579DFF]" />
          <span className="text-sm font-bold text-[#172B4D] dark:text-white">Bengkel</span>
          <span className="text-xs text-[#626F86] dark:text-[#8C9BAB]">({bengkels.length})</span>
        </div>
        <Button
          size="sm"
          onClick={onAdd}
          className="h-8 px-3 text-xs bg-[#0052CC] hover:bg-[#0747A6] text-white"
        >
          <Plus className="w-3.5 h-3.5 mr-1" />
          Tambah
        </Button>
      </div>

      {/* Search */}
      <div className="px-3 py-2.5 border-b border-[#DFE1E6] dark:border-[#2C333A] shrink-0">
        <div className="relative">
          <Search className="absolute left-2.5 top-1/2 -translate-y-1/2 w-3.5 h-3.5 text-[#626F86]" />
          <input
            type="text"
            placeholder="Cari bengkel..."
            value={search}
            onChange={(e) => onSearchChange(e.target.value)}
            className="w-full h-8 pl-8 pr-8 rounded-md border border-[#DFE1E6] dark:border-[#2C333A] bg-[#F4F5F7] dark:bg-[#1D2125] text-sm text-[#172B4D] dark:text-white placeholder:text-[#626F86] focus:outline-none focus:ring-2 focus:ring-[#0052CC]"
          />
          {search && (
            <button
              onClick={() => onSearchChange('')}
              className="absolute right-2 top-1/2 -translate-y-1/2"
            >
              <X className="w-3.5 h-3.5 text-[#626F86]" />
            </button>
          )}
        </div>
      </div>

      {/* List */}
      <div className="flex-1 overflow-y-auto">
        {loading ? (
          Array.from({ length: 5 }).map((_, i) => (
            <div key={i} className="p-3 border-b border-[#DFE1E6] dark:border-[#2C333A]">
              <div className="flex items-center gap-3">
                <div className="w-10 h-10 rounded-full bg-[#EBECF0] dark:bg-[#2C333A] animate-pulse shrink-0" />
                <div className="flex-1 space-y-2">
                  <div className="h-3 bg-[#EBECF0] dark:bg-[#2C333A] rounded animate-pulse w-3/4" />
                  <div className="h-2.5 bg-[#EBECF0] dark:bg-[#2C333A] rounded animate-pulse w-1/2" />
                </div>
              </div>
            </div>
          ))
        ) : filtered.length === 0 ? (
          <div className="flex flex-col items-center justify-center h-40 text-[#626F86] dark:text-[#8C9BAB]">
            <Building2 className="w-8 h-8 mb-2 opacity-30" />
            <p className="text-sm">{search ? 'Bengkel tidak ditemukan' : 'Belum ada bengkel'}</p>
          </div>
        ) : (
          filtered.map((bengkel) => {
            const status = getPaymentStatus(bengkel.nextPaymentAt, bengkel.unpaidCount);
            const cfg = statusConfig[status];
            const isSelected = selectedId === bengkel.id;

            return (
              <button
                key={bengkel.id}
                onClick={() => onSelect(bengkel)}
                className={`w-full text-left px-3 py-3 border-b border-[#DFE1E6] dark:border-[#2C333A] transition-colors ${
                  isSelected
                    ? 'bg-[#E9F2FF] dark:bg-[#1C2B41]'
                    : 'hover:bg-[#F4F5F7] dark:hover:bg-[#2C333A]'
                }`}
              >
                <div className="flex items-start gap-3">
                  {/* Avatar */}
                  <div className="relative shrink-0">
                    <div className="w-10 h-10 rounded-full bg-gradient-to-br from-[#0052CC] to-[#2684FF] flex items-center justify-center text-white text-sm font-bold">
                      {getInitials(bengkel.name)}
                    </div>
                    <div className={`absolute bottom-0 right-0 w-3 h-3 rounded-full border-2 border-white dark:border-[#22272B] ${cfg.dot}`} />
                  </div>

                  {/* Info */}
                  <div className="flex-1 min-w-0">
                    <div className="flex items-center justify-between gap-1">
                      <span className="text-sm font-semibold text-[#172B4D] dark:text-white truncate">
                        {bengkel.name}
                      </span>
                      {bengkel.unpaidCount > 0 && (
                        <span className="shrink-0 text-[10px] font-bold bg-[#DE350B] text-white rounded-full w-5 h-5 flex items-center justify-center">
                          {bengkel.unpaidCount > 9 ? '9+' : bengkel.unpaidCount}
                        </span>
                      )}
                    </div>

                    <div className="flex items-center justify-between mt-0.5">
                      <span className="text-xs text-[#626F86] dark:text-[#8C9BAB]">
                        {bengkel.unpaidCount > 0
                          ? `Rp${bengkel.totalUnpaid.toLocaleString('id-ID')}`
                          : 'Semua lunas'}
                      </span>
                      <span className={`text-[10px] font-bold px-1.5 py-0.5 rounded ${cfg.badge}`}>
                        {cfg.label}
                      </span>
                    </div>

                    {bengkel.nextPaymentAt && bengkel.unpaidCount > 0 && (
                      <div className="flex items-center gap-1 mt-0.5">
                        <Clock className="w-3 h-3 text-[#626F86] dark:text-[#8C9BAB]" />
                        <span className="text-[10px] text-[#626F86] dark:text-[#8C9BAB]">
                          Jatuh tempo: {format(new Date(bengkel.nextPaymentAt), 'dd MMM', { locale: id })}
                        </span>
                      </div>
                    )}
                  </div>
                </div>
              </button>
            );
          })
        )}
      </div>
    </div>
  );
}
