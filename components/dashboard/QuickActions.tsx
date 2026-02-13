'use client';
import React from 'react';
import Link from 'next/link';
import { ShoppingCart, Plus, List, PackageSearch } from 'lucide-react';
import { Button } from '@/components/ui/button';

export default function QuickActions() {
    return (
        <div className="flex items-center gap-3 mb-6 bg-background border border-border p-2 rounded">
            <span className="text-xs font-bold text-muted-foreground uppercase px-2">Quick Actions</span>
            <div className="h-4 w-px bg-border mx-1"></div>

            <Link href="/pos">
                <Button size="sm" className="gap-2 font-medium">
                    <ShoppingCart className="w-4 h-4" />
                    New Sale
                </Button>
            </Link>

            <Link href="/product">
                <Button variant="secondary" size="sm" className="gap-2">
                    <Plus className="w-4 h-4" />
                    Add Product
                </Button>
            </Link>

            <Link href="/records">
                <Button variant="secondary" size="sm" className="gap-2">
                    <List className="w-4 h-4" />
                    View Records
                </Button>
            </Link>

            <Link href="/product">
                <Button variant="ghost" size="sm" className="gap-2 text-muted-foreground hover:text-foreground">
                    <PackageSearch className="w-4 h-4" />
                    Check Stock
                </Button>
            </Link>
        </div>
    );
}
