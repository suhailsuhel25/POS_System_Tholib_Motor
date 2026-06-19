'use client';

import React from 'react';
import { Settings, Info } from 'lucide-react';

export default function SettingsGeneralPage() {
  return (
    <div className="p-6 max-w-4xl">
      <div className="mb-6">
        <h2 className="text-lg font-bold text-[#172B4D] dark:text-white mb-1">Pengaturan Umum</h2>
        <p className="text-sm text-[#626F86] dark:text-[#8C9BAB]">
          Kelola konfigurasi sistem dari satu tempat.
        </p>
      </div>

      <div className="bg-white dark:bg-[#22272B] border border-[#DFE1E6] dark:border-[#2C333A] rounded-lg shadow-sm overflow-hidden">
        <table className="w-full text-left">
          <thead className="bg-[#F4F5F7] dark:bg-[#1D2125] text-[#44546F] dark:text-[#9FADBC] text-xs uppercase font-bold border-b border-[#DFE1E6] dark:border-[#2C333A]">
            <tr>
              <th className="px-6 py-4">Konfigurasi</th>
              <th className="px-6 py-4">Nilai</th>
              <th className="px-6 py-4">Status</th>
            </tr>
          </thead>
          <tbody className="divide-y divide-[#DFE1E6] dark:divide-[#2C333A]">
            <tr className="hover:bg-[#F4F5F7] dark:hover:bg-[#2C333A] transition-colors">
              <td className="px-6 py-4">
                <div className="font-semibold text-[#172B4D] dark:text-[#B6C2CF] text-sm">Nama Aplikasi</div>
                <div className="text-[10px] text-[#626F86] dark:text-[#8C9BAB]">Nama yang ditampilkan di sidebar</div>
              </td>
              <td className="px-6 py-4 text-sm text-[#172B4D] dark:text-[#B6C2CF]">Tholib Motor</td>
              <td className="px-6 py-4">
                <span className="inline-flex items-center px-2 py-0.5 rounded text-[10px] font-bold uppercase bg-[#E3FCEF] text-[#006644]">Aktif</span>
              </td>
            </tr>
            <tr className="hover:bg-[#F4F5F7] dark:hover:bg-[#2C333A] transition-colors">
              <td className="px-6 py-4">
                <div className="font-semibold text-[#172B4D] dark:text-[#B6C2CF] text-sm">Versi</div>
                <div className="text-[10px] text-[#626F86] dark:text-[#8C9BAB]">Versi aplikasi saat ini</div>
              </td>
              <td className="px-6 py-4 text-sm font-mono text-[#626F86] dark:text-[#8C9BAB]">1.0.0</td>
              <td className="px-6 py-4">
                <span className="inline-flex items-center px-2 py-0.5 rounded text-[10px] font-bold uppercase bg-[#E3FCEF] text-[#006644]">Terbaru</span>
              </td>
            </tr>
            <tr className="hover:bg-[#F4F5F7] dark:hover:bg-[#2C333A] transition-colors">
              <td className="px-6 py-4">
                <div className="font-semibold text-[#172B4D] dark:text-[#B6C2CF] text-sm">Database</div>
                <div className="text-[10px] text-[#626F86] dark:text-[#8C9BAB]">Koneksi database utama</div>
              </td>
              <td className="px-6 py-4 text-sm text-[#172B4D] dark:text-[#B6C2CF]">PostgreSQL (Prisma)</td>
              <td className="px-6 py-4">
                <span className="inline-flex items-center px-2 py-0.5 rounded text-[10px] font-bold uppercase bg-[#E3FCEF] text-[#006644]">Terhubung</span>
              </td>
            </tr>
            <tr className="hover:bg-[#F4F5F7] dark:hover:bg-[#2C333A] transition-colors">
              <td className="px-6 py-4">
                <div className="font-semibold text-[#172B4D] dark:text-[#B6C2CF] text-sm">Printer Bluetooth</div>
                <div className="text-[10px] text-[#626F86] dark:text-[#8C9BAB]">Status koneksi printer</div>
              </td>
              <td className="px-6 py-4 text-sm text-[#626F86] dark:text-[#8C9BAB]">Konfigurasi di tab Hardware</td>
              <td className="px-6 py-4">
                <span className="inline-flex items-center px-2 py-0.5 rounded text-[10px] font-bold uppercase bg-[#EBECF0] dark:bg-[#1D2125] text-[#44546F] dark:text-[#9FADBC]">Tidak Aktif</span>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
  );
}
