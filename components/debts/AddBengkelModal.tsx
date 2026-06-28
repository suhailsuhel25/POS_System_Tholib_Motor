'use client';

import React, { useState } from 'react';
import axios from '@/lib/axios';
import { toast } from 'react-toastify';
import { z } from 'zod';
import { Button } from '@/components/ui/button';
import { X, Building2, Phone, MapPin, FileText, Clock } from 'lucide-react';

interface Bengkel {
  id: string;
  name: string;
  phone: string | null;
  address: string | null;
  notes: string | null;
  paymentCycle: number;
}

interface AddBengkelModalProps {
  open: boolean;
  onClose: () => void;
  onSuccess: () => void;
  initialData?: Bengkel | null; // jika ada = mode edit
}

const schema = z.object({
  name: z.string().min(1, 'Nama wajib diisi'),
  phone: z.string().optional(),
  address: z.string().optional(),
  notes: z.string().optional(),
  paymentCycle: z.number().int().min(1, 'Minimal 1 hari'),
});

export default function AddBengkelModal({
  open,
  onClose,
  onSuccess,
  initialData,
}: AddBengkelModalProps) {
  const [form, setForm] = useState({
    name: initialData?.name || '',
    phone: initialData?.phone || '',
    address: initialData?.address || '',
    notes: initialData?.notes || '',
    paymentCycle: initialData?.paymentCycle || 7,
  });
  const [errors, setErrors] = useState<Record<string, string>>({});
  const [loading, setLoading] = useState(false);

  React.useEffect(() => {
    if (open) {
      setForm({
        name: initialData?.name || '',
        phone: initialData?.phone || '',
        address: initialData?.address || '',
        notes: initialData?.notes || '',
        paymentCycle: initialData?.paymentCycle || 7,
      });
      setErrors({});
    }
  }, [open, initialData]);

  const handleChange = (field: string, value: string | number) => {
    setForm((prev) => ({ ...prev, [field]: value }));
    if (errors[field]) setErrors((prev) => ({ ...prev, [field]: '' }));
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    const parsed = schema.safeParse({ ...form, paymentCycle: Number(form.paymentCycle) });
    if (!parsed.success) {
      const errs: Record<string, string> = {};
      parsed.error.errors.forEach((e) => { if (e.path[0]) errs[e.path[0] as string] = e.message; });
      setErrors(errs);
      return;
    }

    try {
      setLoading(true);
      if (initialData) {
        await axios.patch(`/api/bengkel/${initialData.id}`, parsed.data);
        toast.success('Data bengkel berhasil diperbarui');
      } else {
        await axios.post('/api/bengkel', parsed.data);
        toast.success('Bengkel berhasil ditambahkan');
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

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center p-4">
      <div className="absolute inset-0 bg-black/50 backdrop-blur-sm" onClick={onClose} />
      <div className="relative w-full max-w-md bg-white dark:bg-[#22272B] rounded-xl shadow-2xl border border-[#DFE1E6] dark:border-[#2C333A] z-10">
        {/* Header */}
        <div className="flex items-center justify-between px-5 py-4 border-b border-[#DFE1E6] dark:border-[#2C333A]">
          <div className="flex items-center gap-2">
            <Building2 className="w-5 h-5 text-[#0052CC] dark:text-[#579DFF]" />
            <h2 className="text-base font-bold text-[#172B4D] dark:text-white">
              {initialData ? 'Edit Bengkel' : 'Tambah Bengkel Baru'}
            </h2>
          </div>
          <button
            onClick={onClose}
            className="p-1.5 rounded hover:bg-[#EBECF0] dark:hover:bg-[#2C333A] text-[#626F86]"
          >
            <X className="w-4 h-4" />
          </button>
        </div>

        {/* Form */}
        <form onSubmit={handleSubmit} className="p-5 space-y-4">
          {/* Nama */}
          <div>
            <label className="text-xs font-semibold text-[#626F86] dark:text-[#8C9BAB] uppercase mb-1.5 block">
              Nama Bengkel *
            </label>
            <div className="relative">
              <Building2 className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-[#626F86]" />
              <input
                type="text"
                value={form.name}
                onChange={(e) => handleChange('name', e.target.value)}
                placeholder="Contoh: Bengkel Maju Jaya"
                className={`w-full h-10 pl-9 pr-3 rounded-lg border text-sm bg-white dark:bg-[#1D2125] text-[#172B4D] dark:text-white placeholder:text-[#626F86] focus:outline-none focus:ring-2 focus:ring-[#0052CC] transition-all ${
                  errors.name ? 'border-[#DE350B]' : 'border-[#DFE1E6] dark:border-[#2C333A]'
                }`}
              />
            </div>
            {errors.name && <p className="text-xs text-[#DE350B] mt-1">{errors.name}</p>}
          </div>

          {/* No. Telp */}
          <div>
            <label className="text-xs font-semibold text-[#626F86] dark:text-[#8C9BAB] uppercase mb-1.5 block">
              No. Telepon
            </label>
            <div className="relative">
              <Phone className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-[#626F86]" />
              <input
                type="text"
                value={form.phone}
                onChange={(e) => handleChange('phone', e.target.value)}
                placeholder="0812-xxxx-xxxx"
                className="w-full h-10 pl-9 pr-3 rounded-lg border border-[#DFE1E6] dark:border-[#2C333A] text-sm bg-white dark:bg-[#1D2125] text-[#172B4D] dark:text-white placeholder:text-[#626F86] focus:outline-none focus:ring-2 focus:ring-[#0052CC] transition-all"
              />
            </div>
          </div>

          {/* Alamat */}
          <div>
            <label className="text-xs font-semibold text-[#626F86] dark:text-[#8C9BAB] uppercase mb-1.5 block">
              Alamat
            </label>
            <div className="relative">
              <MapPin className="absolute left-3 top-3 w-4 h-4 text-[#626F86]" />
              <textarea
                value={form.address}
                onChange={(e) => handleChange('address', e.target.value)}
                placeholder="Alamat bengkel..."
                rows={2}
                className="w-full pl-9 pr-3 py-2 rounded-lg border border-[#DFE1E6] dark:border-[#2C333A] text-sm bg-white dark:bg-[#1D2125] text-[#172B4D] dark:text-white placeholder:text-[#626F86] focus:outline-none focus:ring-2 focus:ring-[#0052CC] transition-all resize-none"
              />
            </div>
          </div>

          {/* Jadwal Bayar */}
          <div>
            <label className="text-xs font-semibold text-[#626F86] dark:text-[#8C9BAB] uppercase mb-1.5 block">
              Siklus Pembayaran
            </label>
            <div className="flex items-center gap-3">
              <Clock className="w-4 h-4 text-[#626F86] shrink-0" />
              <div className="flex gap-2 flex-wrap">
                {[7, 14, 30].map((days) => (
                  <button
                    key={days}
                    type="button"
                    onClick={() => handleChange('paymentCycle', days)}
                    className={`px-3 py-1.5 rounded-md text-sm font-semibold border transition-all ${
                      form.paymentCycle === days
                        ? 'bg-[#0052CC] text-white border-[#0052CC]'
                        : 'border-[#DFE1E6] dark:border-[#2C333A] text-[#44546F] dark:text-[#9FADBC] hover:bg-[#EBECF0] dark:hover:bg-[#2C333A]'
                    }`}
                  >
                    {days === 7 ? '1 Minggu' : days === 14 ? '2 Minggu' : '1 Bulan'}
                  </button>
                ))}
                <div className="flex items-center gap-1.5">
                  <input
                    type="number"
                    min={1}
                    value={form.paymentCycle}
                    onChange={(e) => handleChange('paymentCycle', Number(e.target.value))}
                    className="w-16 h-8 px-2 text-center text-sm rounded-md border border-[#DFE1E6] dark:border-[#2C333A] bg-white dark:bg-[#1D2125] text-[#172B4D] dark:text-white focus:outline-none focus:ring-2 focus:ring-[#0052CC]"
                  />
                  <span className="text-sm text-[#626F86]">hari</span>
                </div>
              </div>
            </div>
            {errors.paymentCycle && <p className="text-xs text-[#DE350B] mt-1">{errors.paymentCycle}</p>}
          </div>

          {/* Catatan */}
          <div>
            <label className="text-xs font-semibold text-[#626F86] dark:text-[#8C9BAB] uppercase mb-1.5 block">
              Catatan
            </label>
            <div className="relative">
              <FileText className="absolute left-3 top-3 w-4 h-4 text-[#626F86]" />
              <textarea
                value={form.notes}
                onChange={(e) => handleChange('notes', e.target.value)}
                placeholder="Catatan tambahan..."
                rows={2}
                className="w-full pl-9 pr-3 py-2 rounded-lg border border-[#DFE1E6] dark:border-[#2C333A] text-sm bg-white dark:bg-[#1D2125] text-[#172B4D] dark:text-white placeholder:text-[#626F86] focus:outline-none focus:ring-2 focus:ring-[#0052CC] transition-all resize-none"
              />
            </div>
          </div>

          {/* Actions */}
          <div className="flex gap-3 pt-1">
            <Button
              type="button"
              variant="outline"
              onClick={onClose}
              className="flex-1 border-[#DFE1E6] dark:border-[#2C333A]"
              disabled={loading}
            >
              Batal
            </Button>
            <Button
              type="submit"
              className="flex-1 bg-[#0052CC] hover:bg-[#0747A6] text-white"
              disabled={loading}
            >
              {loading ? 'Menyimpan...' : initialData ? 'Simpan Perubahan' : 'Tambah Bengkel'}
            </Button>
          </div>
        </form>
      </div>
    </div>
  );
}
