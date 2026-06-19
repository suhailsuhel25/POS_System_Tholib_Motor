'use client';

import React from 'react';
import Link from 'next/link';
import { usePathname } from 'next/navigation';
import { Settings, Printer, Store, Users, Building2 } from 'lucide-react';

const settingsNav = [
  { name: 'Umum', href: '/settings', icon: Settings, exact: true },
  { name: 'Hardware', href: '/settings/hardware', icon: Printer },
  { name: 'Kategori Barang', href: '/settings/category', icon: Store },
  { name: 'Info Toko', href: '/settings/store', icon: Building2, disabled: true },
  { name: 'Pengguna', href: '/settings/users', icon: Users, disabled: true },
];

export default function SettingsLayout({ children }: { children: React.ReactNode }) {
  const pathname = usePathname();

  return (
    <div className="h-full flex flex-col">
      {/* Header — matches Product page */}
      <div className="h-14 flex items-center px-6 border-b border-[#DFE1E6] dark:border-[#2C333A] bg-white dark:bg-[#22272B] shrink-0">
        <div className="flex items-center gap-2">
          <Settings className="w-5 h-5 text-[#0052CC] dark:text-[#579DFF]" />
          <h1 className="text-base font-bold text-[#172B4D] dark:text-white">Pengaturan</h1>
        </div>
      </div>

      {/* Body — left nav + content */}
      <div className="flex-1 flex overflow-hidden">
        {/* Left Navigation */}
        <nav className="w-[240px] shrink-0 border-r border-[#DFE1E6] dark:border-[#2C333A] bg-[#FAFBFC] dark:bg-[#161A1D] py-4 px-3 space-y-1 overflow-y-auto">
          {settingsNav.map((item) => {
            const Icon = item.icon;
            const isActive = item.exact
              ? pathname === item.href
              : pathname.startsWith(item.href);

            if (item.disabled) {
              return (
                <div
                  key={item.name}
                  className="flex items-center gap-3 px-4 py-2.5 rounded-md text-sm font-medium text-[#8C9BAB] dark:text-[#626F86] cursor-not-allowed opacity-60"
                >
                  <Icon className="w-5 h-5 shrink-0" />
                  <span>{item.name}</span>
                  <span className="ml-auto px-1.5 py-0.5 bg-[#EBECF0] dark:bg-[#2C333A] text-[#626F86] dark:text-[#8C9BAB] text-[9px] font-bold rounded uppercase tracking-wider">
                    Segera
                  </span>
                </div>
              );
            }

            return (
              <Link
                key={item.name}
                href={item.href}
                className={`flex items-center gap-3 px-4 py-2.5 rounded-md text-sm font-medium transition-all ${
                  isActive
                    ? 'bg-[#0052CC] text-white dark:bg-[#0C66E4]'
                    : 'text-[#44546F] dark:text-[#9FADBC] hover:bg-[#EBECF0] dark:hover:bg-[#2C333A] hover:text-[#172B4D] dark:hover:text-white'
                }`}
              >
                <Icon className="w-5 h-5 shrink-0" />
                <span>{item.name}</span>
              </Link>
            );
          })}
        </nav>

        {/* Content Area */}
        <div className="flex-1 overflow-y-auto bg-[#F4F5F7] dark:bg-[#1D2125]">
          {children}
        </div>
      </div>
    </div>
  );
}
