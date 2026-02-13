'use client';

import React, { useState, useEffect } from 'react';
import NextTopLoader from 'nextjs-toploader';
import Link from 'next/link';
import { usePathname } from 'next/navigation';
import { useTheme } from 'next-themes';
import {
  LayoutDashboard,
  CreditCard,
  Package,
  BarChart3,
  Sun,
  Moon,

  ChevronsLeft,
  ChevronsRight,
} from 'lucide-react';

interface RootLayoutProps {
  children: React.ReactNode;
}

const navItems = [
  { name: 'Dashboard', href: '/home', icon: LayoutDashboard },
  { name: 'Kasir', href: '/orders', icon: CreditCard },
  { name: 'Stok Barang', href: '/product', icon: Package },
  { name: 'Riwayat', href: '/records', icon: BarChart3 },
];

export default function RootLayout({ children }: RootLayoutProps) {
  const pathname = usePathname();
  const { setTheme, theme } = useTheme();
  const [collapsed, setCollapsed] = useState(false);
  const [mounted, setMounted] = useState(false);

  useEffect(() => {
    setMounted(true);
  }, []);

  const toggleTheme = () => {
    setTheme(theme === 'dark' ? 'light' : 'dark');
  };

  return (
    <div className="flex h-screen w-full bg-[#F4F5F7] dark:bg-[#1D2125] overflow-hidden">
      <NextTopLoader showSpinner={false} color="#0052CC" />

      {/* SIDEBAR */}
      <aside
        className={`
          relative h-full flex flex-col
          border-r border-[#DFE1E6] dark:border-[#2C333A]
          bg-[#FAFBFC] dark:bg-[#161A1D]
          transition-all duration-200 ease-in-out
          ${collapsed ? 'w-[68px]' : 'w-[260px]'}
        `}
      >
        {/* TOP - Toggle */}
        <div className="h-14 flex items-center justify-between px-4 border-b border-[#DFE1E6] dark:border-[#2C333A]">
          {!collapsed && (
            <Link href="/home" className="text-base font-bold text-[#172B4D] dark:text-white truncate hover:text-[#0052CC] dark:hover:text-[#579DFF] transition-colors">
              Tholib Motor
            </Link>
          )}
          <button
            onClick={() => setCollapsed(!collapsed)}
            className={`
              p-2 rounded hover:bg-[#EBECF0] dark:hover:bg-[#2C333A] 
              text-[#626F86] dark:text-[#8C9BAB] hover:text-[#172B4D] dark:hover:text-white
              transition-colors
              ${collapsed ? 'mx-auto' : 'ml-auto'}
            `}
            title={collapsed ? 'Perluas sidebar' : 'Perkecil sidebar'}
          >
            {collapsed ? (
              <ChevronsRight className="w-5 h-5" />
            ) : (
              <ChevronsLeft className="w-5 h-5" />
            )}
          </button>
        </div>

        {/* MIDDLE - Navigation */}
        <nav className="flex-1 py-4 px-3 space-y-1.5 overflow-y-auto">
          {navItems.map((item) => {
            const isActive = pathname === item.href || (item.href === '/home' && pathname === '/');
            const Icon = item.icon;
            return (
              <Link
                key={item.name}
                href={item.href}
                className={`
                  flex items-center gap-3 px-4 py-3 rounded-md text-base font-medium transition-all
                  ${collapsed ? 'justify-center' : ''}
                  ${isActive
                    ? 'bg-[#0052CC] text-white dark:bg-[#0C66E4]'
                    : 'text-[#44546F] dark:text-[#9FADBC] hover:bg-[#EBECF0] dark:hover:bg-[#2C333A] hover:text-[#172B4D] dark:hover:text-white'
                  }
                `}
                title={collapsed ? item.name : undefined}
              >
                <Icon className="w-6 h-6 shrink-0" />
                {!collapsed && <span>{item.name}</span>}
              </Link>
            );
          })}
        </nav>

        {/* BOTTOM - Theme & Settings */}
        <div className="border-t border-[#DFE1E6] dark:border-[#2C333A] py-4 px-3 space-y-1.5">
          {/* Theme Toggle */}
          <button
            onClick={toggleTheme}
            className={`
              w-full flex items-center gap-3 px-4 py-3 rounded-md text-base font-medium transition-all
              text-[#44546F] dark:text-[#9FADBC] hover:bg-[#EBECF0] dark:hover:bg-[#2C333A] hover:text-[#172B4D] dark:hover:text-white
              ${collapsed ? 'justify-center' : ''}
            `}
            title={collapsed ? (mounted && theme === 'dark' ? 'Mode Terang' : 'Mode Gelap') : undefined}
          >
            {mounted ? (
              theme === 'dark' ? (
                <Sun className="w-6 h-6 shrink-0" />
              ) : (
                <Moon className="w-6 h-6 shrink-0" />
              )
            ) : (
              <div className="w-6 h-6 shrink-0" />
            )}
            {!collapsed && mounted && <span>{theme === 'dark' ? 'Mode Terang' : 'Mode Gelap'}</span>}
          </button>


        </div>
      </aside>

      {/* CONTENT AREA */}
      <main className="flex-1 overflow-y-auto">
        {children}
      </main>
    </div>
  );
}
