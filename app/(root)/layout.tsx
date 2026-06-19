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
  Settings,
  ChevronsLeft,
  ChevronsRight,
  ChevronDown,
  ChevronRight,
  Receipt,
  DollarSign,
} from 'lucide-react';

interface RootLayoutProps {
  children: React.ReactNode;
}

const navItems: { name: string; href: string; icon: any; subItems?: { name: string; href: string }[] }[] = [
  { name: 'Dashboard', href: '/home', icon: LayoutDashboard },
  { name: 'Kasir', href: '/orders', icon: CreditCard },
  { name: 'Stok Barang', href: '/product', icon: Package },
  { name: 'Riwayat', href: '/records', icon: BarChart3 },
  { name: 'Hutang', href: '/debts', icon: Receipt },
  { name: 'Pengeluaran', href: '/expenses', icon: DollarSign },
  { 
    name: 'Pengaturan', 
    href: '/settings', 
    icon: Settings
  },
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
        <nav className={`flex-1 py-4 space-y-1.5 overflow-y-auto ${collapsed ? 'px-2' : 'px-3'}`}>
          {navItems.map((item) => {
            const isExactActive = pathname === item.href || (item.href === '/home' && pathname === '/');
            const isPathActive = pathname.startsWith(item.href);
            const hasSub = item.subItems && item.subItems.length > 0;
            const Icon = item.icon;
            
            return (
              <div key={item.name} className="flex flex-col">
                <Link
                  href={item.href}
                  className={`
                    flex items-center gap-3 rounded-md text-base font-medium transition-all
                    ${collapsed ? 'justify-center px-0 py-3' : 'justify-between px-4 py-3'}
                    ${isExactActive
                      ? 'bg-[#0052CC] text-white dark:bg-[#0C66E4]'
                      : isPathActive
                        ? 'bg-[#DEEBFF] text-[#0052CC] dark:bg-[#0747A6]/30 dark:text-[#579DFF]'
                        : 'text-[#44546F] dark:text-[#9FADBC] hover:bg-[#EBECF0] dark:hover:bg-[#2C333A] hover:text-[#172B4D] dark:hover:text-white'
                    }
                  `}
                  title={collapsed ? item.name : undefined}
                >
                  <div className="flex items-center gap-3">
                    <Icon className="w-6 h-6 shrink-0" />
                    {!collapsed && <span>{item.name}</span>}
                  </div>
                  {hasSub && !collapsed && (
                    <ChevronRight className={`w-4 h-4 transition-transform ${isPathActive ? 'rotate-90' : ''}`} />
                  )}
                </Link>

                {/* Sub Items */}
                {hasSub && !collapsed && isPathActive && (
                  <div className="flex flex-col mt-1.5 ml-11 space-y-1">
                    {item.subItems!.map((sub) => {
                      const isSubActive = pathname === sub.href;
                      return (
                        <Link
                          key={sub.name}
                          href={sub.href}
                          className={`
                            px-3 py-2.5 rounded-md text-sm font-medium transition-all
                            ${isSubActive 
                              ? 'bg-[#0052CC] text-white dark:bg-[#0C66E4]' 
                              : 'text-[#626F86] dark:text-[#8C9BAB] hover:bg-[#EBECF0] dark:hover:bg-[#2C333A] hover:text-[#172B4D] dark:hover:text-white'}
                          `}
                        >
                          {sub.name}
                        </Link>
                      );
                    })}
                  </div>
                )}
              </div>
            );
          })}
        </nav>

        {/* BOTTOM - Theme & Settings */}
        <div className={`border-t border-[#DFE1E6] dark:border-[#2C333A] py-4 space-y-1.5 ${collapsed ? 'px-2' : 'px-3'}`}>
          {/* Theme Toggle */}
          <button
            onClick={toggleTheme}
            className={`
              w-full flex items-center gap-3 rounded-md text-base font-medium transition-all
              ${collapsed ? 'justify-center px-0 py-3' : 'justify-start px-4 py-3'}
              text-[#44546F] dark:text-[#9FADBC] hover:bg-[#EBECF0] dark:hover:bg-[#2C333A] hover:text-[#172B4D] dark:hover:text-white
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
