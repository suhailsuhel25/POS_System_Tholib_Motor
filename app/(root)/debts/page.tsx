'use client';

import useSWR from 'swr';
import React, { useState } from 'react';
import axios from '@/lib/axios';
import { Building2, Receipt } from 'lucide-react';
import BengkelList from '@/components/debts/BengkelList';
import BengkelDetail from '@/components/debts/BengkelDetail';
import AddBengkelModal from '@/components/debts/AddBengkelModal';

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

const fetcher = (url: string) => axios.get(url).then((r) => r.data);

export default function DebtsPage() {
  const [selectedBengkel, setSelectedBengkel] = useState<Bengkel | null>(null);
  const [showAddModal, setShowAddModal] = useState(false);
  const [search, setSearch] = useState('');

  const { data, isLoading, mutate } = useSWR('/api/bengkel', fetcher);
  const bengkels: Bengkel[] = data?.bengkels || [];

  const handleSelectBengkel = (bengkel: Bengkel) => {
    setSelectedBengkel(bengkel);
  };

  const handleBengkelDeleted = () => {
    setSelectedBengkel(null);
    mutate();
  };

  const handleMutate = () => {
    mutate();
    // Refresh selected bengkel data too
    if (selectedBengkel) {
      const updated = bengkels.find((b) => b.id === selectedBengkel.id);
      if (updated) setSelectedBengkel(updated);
    }
  };

  return (
    <div className="h-full flex flex-col">
      {/* Header */}
      <div className="h-14 flex items-center justify-between px-6 border-b border-[#DFE1E6] dark:border-[#2C333A] bg-white dark:bg-[#22272B] shrink-0">
        <div className="flex items-center gap-2">
          <Receipt className="w-5 h-5 text-[#0052CC] dark:text-[#579DFF]" />
          <h1 className="text-base font-bold text-[#172B4D] dark:text-white">Hutang Bengkel</h1>
        </div>
        {/* Summary badge */}
        {!isLoading && bengkels.length > 0 && (
          <div className="flex items-center gap-3 text-sm">
            <div className="flex items-center gap-1.5 px-3 py-1.5 bg-[#FFEBE6] dark:bg-[#3D1A1A] rounded-lg">
              <span className="font-bold text-[#DE350B]">
                Rp{bengkels.reduce((s, b) => s + b.totalUnpaid, 0).toLocaleString('id-ID')}
              </span>
              <span className="text-[#974F0C] text-xs">total piutang</span>
            </div>
          </div>
        )}
      </div>

      {/* Main 2-panel layout */}
      <div className="flex-1 flex overflow-hidden">
        {/* LEFT PANEL — Bengkel List */}
        <div className="w-[280px] lg:w-[320px] shrink-0 flex flex-col overflow-hidden">
          <BengkelList
            bengkels={bengkels}
            selectedId={selectedBengkel?.id || null}
            onSelect={handleSelectBengkel}
            onAdd={() => setShowAddModal(true)}
            loading={isLoading}
            search={search}
            onSearchChange={setSearch}
          />
        </div>

        {/* RIGHT PANEL — Detail or Empty State */}
        <div className="flex-1 overflow-hidden">
          {selectedBengkel ? (
            <BengkelDetail
              key={selectedBengkel.id}
              bengkel={selectedBengkel}
              onMutate={handleMutate}
              onDeleted={handleBengkelDeleted}
            />
          ) : (
            <div className="h-full flex flex-col items-center justify-center text-[#626F86] dark:text-[#8C9BAB] bg-[#F4F5F7] dark:bg-[#1D2125]">
              <Building2 className="w-16 h-16 mb-4 opacity-20" />
              <p className="text-lg font-semibold text-[#172B4D] dark:text-white opacity-40">
                Pilih Bengkel
              </p>
              <p className="text-sm opacity-60 mt-1">
                Klik nama bengkel di sebelah kiri untuk melihat detail hutang
              </p>
            </div>
          )}
        </div>
      </div>

      {/* Add Bengkel Modal */}
      <AddBengkelModal
        open={showAddModal}
        onClose={() => setShowAddModal(false)}
        onSuccess={() => mutate()}
      />
    </div>
  );
}
