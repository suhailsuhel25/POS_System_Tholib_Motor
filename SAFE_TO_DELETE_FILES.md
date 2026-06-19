# SAFE TO DELETE FILES

## Unused UI Components (22 files)
High confidence - never imported anywhere in the codebase.

| File | Reason | Confidence |
|------|--------|------------|
| `components/ui/select.tsx` | Never imported | 100% |
| `components/ui/table.tsx` | Never imported | 100% |
| `components/ui/toast.tsx` | Only used internally by unused toaster | 100% |
| `components/ui/toaster.tsx` | Never rendered in layout or pages | 100% |
| `components/ui/use-toast.ts` | Only used by unused toaster | 100% |
| `components/ui/tooltip.tsx` | Never imported | 100% |
| `components/ui/separator.tsx` | Never imported | 100% |
| `components/ui/type-writer.tsx` | Never imported | 100% |
| `components/ui/sheet.tsx` | Never imported | 100% |
| `components/ui/popover.tsx` | Never imported | 100% |
| `components/ui/scroll-area.tsx` | Never imported | 100% |
| `components/ui/form.tsx` | Never imported | 100% |
| `components/ui/label.tsx` | Only used by unused form.tsx | 100% |
| `components/ui/resizable.tsx` | Never imported | 100% |
| `components/ui/pagination.tsx` | Never imported | 100% |
| `components/ui/images-slider.tsx` | Never imported | 100% |
| `components/ui/badge.tsx` | Never imported | 100% |
| `components/ui/collapsible.tsx` | Never imported | 100% |
| `components/ui/bento-grid.tsx` | Never imported | 100% |
| `components/ui/command.tsx` | Never imported | 100% |
| `components/ui/card-hover-effect.tsx` | Never imported | 100% |
| `components/ui/breadcrumb.tsx` | Never imported | 100% |

## Unused Services (1 file)
| File | Reason | Confidence |
|------|--------|------------|
| `lib/services/barcode-scanner.ts` | Never imported by any page or component | 100% |

## Unused Assets (3 files)
| File | Reason | Confidence |
|------|--------|------------|
| `public/next.svg` | Default Next.js logo, never referenced | 100% |
| `public/vercel.svg` | Default Vercel logo, never referenced | 100% |
| `public/icons/icon.svg` | Never referenced in source code | 100% |

## Debug/Test Scripts (6 files)
| File | Reason | Confidence |
|------|--------|------------|
| `test-dashboard.js` | Debug script, dev-only | 100% |
| `test-dashboard-seq.js` | Debug script, dev-only | 100% |
| `test-direct.js` | Debug script, dev-only | 100% |
| `test-prisma.js` | Debug script, dev-only | 100% |
| `fix_barcodes.ts` | One-time utility script | 100% |
| `fix_barcode.patch` | Stale patch referencing non-existent file | 100% |

## Unused API Routes (10 route files)
| File | Reason | Confidence |
|------|--------|------------|
| `app/api/favorite/route.ts` | Never consumed by frontend | 95% |
| `app/api/dashboard/best-sellers/route.ts` | Never consumed by frontend | 95% |
| `app/api/restock/route.ts` | No UI page calling this | 90% |
| `app/api/restock/[id]/route.ts` | No UI page calling this | 90% |
| `app/api/storage/route.ts` | Replaced by /api/product | 95% |
| `app/api/shopdata/route.ts` | No settings UI consuming this | 90% |
| `app/api/shopdata/[id]/route.ts` | No settings UI consuming this | 90% |
| `app/api/onsale/route.ts` | Transaction items handled in /api/transactions | 95% |
| `app/api/onsale/[id]/route.ts` | Transaction items handled in /api/transactions | 95% |
| `app/api/productsale/route.ts` | Never called from frontend | 95% |
