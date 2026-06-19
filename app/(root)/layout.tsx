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
  Receipt,
  DollarSign,
  Menu,
  X,
} from 'lucide-react';

interface RootLayoutProps {
  children: React.ReactNode;
}

const navItems: { name: string; href: string; icon: any }[] = [
  { name: 'Dashboard', href: '/home', icon: LayoutDashboard },
  { name: 'Kasir', href: '/orders', icon: CreditCard },
  { name: 'Stok', href: '/product', icon: Package },
  { name: 'Riwayat', href: '/records', icon: BarChart3 },
  { name: 'Hutang', href: '/debts', icon: Receipt },
  { name: 'Pengeluaran', href: '/expenses', icon: DollarSign },
  { name: 'Pengaturan', href: '/settings', icon: Settings },
];

export default function RootLayout({ children }: RootLayoutProps) {
  const pathname = usePathname();
  const { setTheme, theme } = useTheme();
  const [collapsed, setCollapsed] = useState(false);
  const [mounted, setMounted] = useState(false);
  const [mobileMenuOpen, setMobileMenuOpen] = useState(false);

  useEffect(() => {
    setMounted(true);
  }, []);

  useEffect(() => {
    setMobileMenuOpen(false);
  }, [pathname]);

  const toggleTheme = () => {
    setTheme(theme === 'dark' ? 'light' : 'dark');
  };

  const isActive = (href: string) => pathname === href || (href === '/home' && pathname === '/');

  const bottomNavItems = navItems.filter(item =>
    ['/home', '/orders', '/product', '/records', '/settings'].includes(item.href)
  );

  return (
    <div className="flex h-screen w-full bg-[#F4F5F7] dark:bg-[#1D2125] overflow-hidden">
      <NextTopLoader showSpinner={false} color="#0052CC" />

      {/* MOBILE OVERLAY */}
      {mobileMenuOpen && (
        <div
          className="fixed inset-0 bg-black/50 z-40 lg:hidden"
          onClick={() => setMobileMenuOpen(false)}
        />
      )}

      {/* SIDEBAR - Hidden on mobile, visible on lg+ */}
      <aside
        className={`
          fixed inset-y-0 left-0 z-50 flex flex-col
          border-r border-[#DFE1E6] dark:border-[#2C333A]
          bg-[#FAFBFC] dark:bg-[#161A1D]
          transition-all duration-200 ease-in-out
          lg:relative lg:z-auto
          ${mobileMenuOpen ? 'translate-x-0' : '-translate-x-full lg:translate-x-0'}
          ${collapsed ? 'w-[68px]' : 'w-[260px]'}
        `}
      >
        {/* TOP - Logo & Close */}
        <div className="h-14 flex items-center justify-between px-4 border-b border-[#DFE1E6] dark:border-[#2C333A]">
          {!collapsed && (
            <Link href="/home" className="text-base font-bold text-[#172B4D] dark:text-white truncate hover:text-[#0052CC] dark:hover:text-[#579DFF] transition-colors">
              Tholib Motor
            </Link>
          )}
          <button
            onClick={() => {
              if (mobileMenuOpen) setMobileMenuOpen(false);
              else setCollapsed(!collapsed);
            }}
            className={`
              p-2 rounded hover:bg-[#EBECF0] dark:hover:bg-[#2C333A]
              text-[#626F86] dark:text-[#8C9BAB] hover:text-[#172B4D] dark:hover:text-white
              transition-colors lg:block
              ${mobileMenuOpen ? '' : collapsed ? 'mx-auto hidden' : 'ml-auto hidden'}
            `}
          >
            {mobileMenuOpen ? <X className="w-5 h-5" /> : collapsed ? <ChevronsRight className="w-5 h-5" /> : <ChevronsLeft className="w-5 h-5" />}
          </button>
          {/* Mobile close button */}
          <button
            onClick={() => setMobileMenuOpen(false)}
            className="p-2 rounded hover:bg-[#EBECF0] dark:hover:bg-[#2C333A] text-[#626F86] dark:text-[#8C9BAB] lg:hidden"
          >
            <X className="w-5 h-5" />
          </button>
        </div>

        {/* NAVIGATION */}
        <nav className={`flex-1 py-4 space-y-1.5 overflow-y-auto ${collapsed ? 'px-2' : 'px-3'}`}>
          {navItems.map((item) => {
            const active = isActive(item.href);
            const Icon = item.icon;

            return (
              <Link
                key={item.name}
                href={item.href}
                className={`
                  flex items-center gap-3 rounded-md text-base font-medium transition-all
                  ${collapsed ? 'justify-center px-0 py-3' : 'px-4 py-3'}
                  ${active
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

        {/* BOTTOM - Theme Toggle */}
        <div className={`border-t border-[#DFE1E6] dark:border-[#2C333A] py-4 space-y-1.5 ${collapsed ? 'px-2' : 'px-3'}`}>
          <button
            onClick={toggleTheme}
            className={`
              w-full flex items-center gap-3 rounded-md text-base font-medium transition-all
              ${collapsed ? 'justify-center px-0 py-3' : 'justify-start px-4 py-3'}
              text-[#44546F] dark:text-[#9FADBC] hover:bg-[#EBECF0] dark:hover:bg-[#2C333A] hover:text-[#172B4D] dark:hover:text-white
            `}
          >
            {mounted ? (
              theme === 'dark' ? <Sun className="w-6 h-6 shrink-0" /> : <Moon className="w-6 h-6 shrink-0" />
            ) : (
              <div className="w-6 h-6 shrink-0" />
            )}
            {!collapsed && mounted && <span>{theme === 'dark' ? 'Mode Terang' : 'Mode Gelap'}</span>}
          </button>
        </div>
      </aside>

      {/* MAIN CONTENT */}
      <div className="flex-1 flex flex-col min-w-0 overflow-hidden">
        {/* MOBILE TOP BAR */}
        <div className="h-12 flex items-center justify-between px-4 border-b border-[#DFE1E6] dark:border-[#2C333A] bg-white dark:bg-[#22272B] lg:hidden shrink-0">
          <button
            onClick={() => setMobileMenuOpen(true)}
            className="p-2 -ml-2 rounded hover:bg-[#EBECF0] dark:hover:bg-[#2C333A] text-[#626F86] dark:text-[#8C9BAB]"
          >
            <Menu className="w-5 h-5" />
          </button>
          <Link href="/home" className="text-sm font-bold text-[#172B4D] dark:text-white">Tholib Motor</Link>
          <button
            onClick={toggleTheme}
            className="p-2 -mr-2 rounded hover:bg-[#EBECF0] dark:hover:bg-[#2C333A] text-[#626F86] dark:text-[#8C9BAB]"
          >
            {mounted ? (
              theme === 'dark' ? <Sun className="w-5 h-5" /> : <Moon className="w-5 h-5" />
            ) : <div className="w-5 h-5" />}
          </button>
        </div>

        <main className="flex-1 overflow-y-auto pb-16 lg:pb-0 landscape:pb-0">
          {children}
        </main>
      </div>

      {/* MOBILE BOTTOM NAV - Hidden in landscape */}
      <nav className="fixed bottom-0 left-0 right-0 z-40 bg-white dark:bg-[#22272B] border-t border-[#DFE1E6] dark:border-[#2C333A] lg:hidden safe-area-bottom portrait:block landscape:hidden">
        <div className="flex items-center justify-around h-14 px-1">
          {bottomNavItems.map((item) => {
            const active = isActive(item.href);
            const Icon = item.icon;
            return (
              <Link
                key={item.name}
                href={item.href}
                className={`flex flex-col items-center justify-center gap-0.5 min-w-[48px] py-1 rounded-lg transition-colors ${
                  active
                    ? 'text-[#0052CC] dark:text-[#579DFF]'
                    : 'text-[#626F86] dark:text-[#8C9BAB]'
                }`}
              >
                <Icon className="w-5 h-5" />
                <span className="text-[9px] font-semibold">{item.name}</span>
              </Link>
            );
          })}
        </div>
      </nav>
    </div>
  );
}
