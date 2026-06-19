# PROJECT_CONTEXT.md — POS Tholib Motor

> **Auto-generated project index** — Use this as long-term memory for all future development tasks.
> Last indexed: 2026-06-19

---

## 1. Executive Summary

**POS Tholib Motor** is a Point of Sale system for a motorcycle spare parts shop ("Tholib Motor") specializing in Honda, Yamaha, Kawasaki, and Suzuki brands. Built with **Next.js 14 (App Router)**, **Prisma ORM**, **PostgreSQL (Supabase)**, **TailwindCSS**, and **shadcn/ui (New York style)**.

| Attribute | Value |
|---|---|
| **Project Name** | `storage` (package.json) |
| **Framework** | Next.js 14.2.3 (App Router) |
| **Language** | TypeScript 5.4 |
| **Database** | PostgreSQL via Supabase (PgBouncer pooling) |
| **ORM** | Prisma 5.14 |
| **UI Library** | shadcn/ui (New York), Radix UI primitives |
| **Styling** | TailwindCSS 3.4 + tailwindcss-animate |
| **Charts** | ApexCharts (react-apexcharts) |
| **Forms** | react-hook-form + Zod validation (Indonesian messages) |
| **State Mgmt** | React `useState` / `useEffect` (no global store) |
| **Auth** | ❌ **NOT IMPLEMENTED** (User model exists but no auth flow) |
| **Mobile** | Capacitor 8 (Android) + Barcode Scanner + Bluetooth Printer |
| **Deployment** | Docker + Vercel Analytics/Speed Insights |

---

## 2. Architecture Overview

```
┌─────────────────────────────────────────────────────┐
│                   BROWSER (Client)                   │
│  ┌─────────┬─────────┬──────────┬────────┬────────┐ │
│  │Dashboard│ Kasir   │Stok Brgn │Riwayat │Settings│ │
│  └────┬────┴────┬────┴────┬─────┴───┬────┴───┬────┘ │
│       │         │         │         │        │       │
│       └─────────┴────┬────┴─────────┴────────┘       │
│                      │ axios (HTTP)                   │
├──────────────────────┼───────────────────────────────┤
│              Next.js API Routes (Server)              │
│  ┌──────────────────────────────────────────────────┐ │
│  │  /api/product    /api/transactions   /api/profit │ │
│  │  /api/dashboard  /api/onsale         /api/restock│ │
│  │  /api/favorite   /api/productsale    /api/storage│ │
│  │  /api/shopdata   /api/clear-database             │ │
│  └─────────────────────┬────────────────────────────┘ │
│                        │ Prisma Client                 │
├────────────────────────┼──────────────────────────────┤
│           PostgreSQL (Supabase)                       │
│  ┌────────────┬──────────┬──────────────┬───────────┐ │
│  │ProductStock│ Product  │OnSaleProduct │Transaction│ │
│  │ User       │ ShopData │              │           │ │
│  └────────────┴──────────┴──────────────┴───────────┘ │
└───────────────────────────────────────────────────────┘
```

### Routing Pattern
- **App Router** with route groups: `(root)` for authenticated/main pages
- All main pages under `app/(root)/` with a shared sidebar layout
- API routes under `app/api/`

---

## 3. Folder Structure

```
pos-next/
├── app/
│   ├── (root)/                    # Main app route group
│   │   ├── layout.tsx             # Sidebar + theme toggle (client component)
│   │   ├── home/page.tsx          # Dashboard page → JiraDashboard component
│   │   ├── orders/page.tsx        # Cashier/POS page (kasir)
│   │   ├── product/page.tsx       # Product/inventory management
│   │   ├── records/
│   │   │   ├── page.tsx           # Reports + transaction history
│   │   │   └── [id]/page.tsx      # Transaction detail view
│   │   └── settings/
│   │       ├── page.tsx           # Settings (store profile)
│   │       ├── category/page.tsx  # Category management (CRUD)
│   │       └── hardware/page.tsx  # Hardware settings (printer, scanner)
│   ├── api/                       # API route handlers
│   │   ├── product/               # CRUD products
│   │   │   ├── route.ts           # GET (list+filter), POST (create)
│   │   │   └── [id]/route.ts      # PATCH (update), DELETE
│   │   ├── transactions/          # Transaction management
│   │   │   ├── route.ts           # GET (list), POST (create with stock deduction)
│   │   │   └── [id]/route.ts      # GET (detail), PATCH (return/update), DELETE
│   │   ├── dashboard/             # Dashboard aggregations
│   │   │   ├── route.ts           # GET (KPI: totalStock, totalAmount, etc.)
│   │   │   ├── best-sellers/      # GET top 5 products by quantity sold
│   │   │   ├── low-stock/         # GET products with stock < 5
│   │   │   └── recent-transactions/ # GET last 5 transactions
│   │   ├── categories/            # Category CRUD
│   │   │   ├── route.ts           # GET (list), POST (create)
│   │   │   └── [id]/route.ts      # PATCH (update), DELETE
│   │   ├── onsale/                # OnSaleProduct (line items) management
│   │   │   ├── route.ts           # POST (create/update line item)
│   │   │   └── [id]/route.ts      # PATCH (qty), DELETE
│   │   ├── profit/route.ts        # GET profit data by date range
│   │   ├── productsale/route.ts   # GET product sales volume by date range
│   │   ├── restock/               # Stock replenishment
│   │   │   ├── route.ts           # POST (bulk restock ALL products)
│   │   │   └── [id]/route.ts      # PATCH (restock single product)
│   │   ├── favorite/route.ts      # GET top 5 best-selling products
│   │   ├── storage/route.ts       # GET all product stocks with sell prices
│   │   ├── shopdata/              # Shop configuration
│   │   │   ├── route.ts           # GET shop name (auto-creates default)
│   │   │   └── [id]/route.ts      # PATCH update store name
│   │   └── clear-database/        # Database clear (EMPTY - not implemented)
│   ├── layout.tsx                 # Root layout (Inter font, ThemeProvider, ToastContainer)
│   ├── page.tsx                   # Root redirect
│   ├── error.tsx                  # Global error boundary
│   └── globals.css                # Global styles + Tailwind directives
├── components/
│   ├── ui/                        # shadcn/ui components (30 files)
│   │   ├── alert-dialog.tsx       ├── badge.tsx
│   │   ├── bento-grid.tsx         ├── breadcrumb.tsx
│   │   ├── button.tsx             ├── card.tsx
│   │   ├── card-hover-effect.tsx   ├── collapsible.tsx
│   │   ├── command.tsx            ├── dialog.tsx
│   │   ├── dropdown-menu.tsx      ├── form.tsx
│   │   ├── images-slider.tsx      ├── input.tsx
│   │   ├── label.tsx              ├── pagination.tsx
│   │   ├── popover.tsx            ├── progress.tsx
│   │   ├── resizable.tsx          ├── scroll-area.tsx
│   │   ├── select.tsx             ├── separator.tsx
│   │   ├── sheet.tsx              ├── table.tsx
│   │   ├── tabs.tsx               ├── toast.tsx
│   │   ├── toaster.tsx            ├── tooltip.tsx
│   │   ├── type-writer.tsx        └── use-toast.ts
│   ├── bento/bentodemo.tsx        # Main Dashboard (JiraDashboard) component
│   ├── ErrorAlert.tsx             # Error dialog (Radix AlertDialog)
│   ├── SuccessAlert.tsx           # Success dialog (Radix AlertDialog)
│   ├── ProductFormModal.tsx       # Create/Edit product modal
│   ├── ReceiptContent.tsx         # Receipt/Struk template (printable)
│   ├── ReceiptDialog.tsx          # Receipt dialog with print support
│   └── theme-provider.tsx         # next-themes ThemeProvider wrapper
├── lib/
│   ├── db.ts                      # Prisma client singleton (dev/prod aware)
│   ├── utils.ts                   # cn() utility + pagination generator
│   └── services/
│       ├── barcode-scanner.ts     # Capacitor barcode scanner integration
│       ├── bluetooth-printer.ts   # Bluetooth thermal printer service
│       └── receipt-builder.ts     # Receipt HTML builder for printing
├── prisma/
│   ├── schema.prisma              # Database schema (7 models, 3 enums)
│   ├── seed.ts                    # Seeder using faker data
│   ├── fake-data.ts               # Generated fake data (prisma-generator-fake-data)
│   ├── schema.prisma.backup       # Backup of previous schema
│   ├── dbml/                      # Auto-generated DBML diagrams
│   └── migrations/                # 16 migration files
├── schema/
│   └── index.ts                   # Zod validation schemas (Indonesian messages)
├── types/                         # (empty - types removed)
├── data-sparepart/                # Sparepart data files
├── android/                       # Capacitor Android project
├── capacitor.config.ts            # Capacitor configuration
├── public/                        # Static assets
├── .env                           # Environment variables (DB URLs)
├── Dockerfile                     # Docker production build
├── tailwind.config.ts             # Tailwind configuration
├── tsconfig.json                  # TypeScript configuration
├── components.json                # shadcn/ui config (new-york style)
├── next.config.mjs                # Next.js config (image domains, env vars)
└── package.json                   # Dependencies & scripts
```

---

## 4. Database Schema

### 4.1 Entity-Relationship Diagram (ERD)

```
┌─────────────┐     1:1      ┌──────────┐     1:N      ┌───────────────┐
│ ProductStock │◄─────────────│ Product  │◄─────────────│ OnSaleProduct │
│ (inventory)  │  productId   │ (sale    │  productId   │ (line items)  │
│              │              │  catalog)│              │               │
│ id (PK)      │              │ id       │              │ id (PK)       │
│ name         │              │ productId│              │ productId     │
│ brand (enum) │              │ sellprice│              │ quantity      │
│ category     │              │          │              │ saledate      │
│ masterCat    │              └──────────┘              │ transactionId │
│ skuManual    │                                        └───────┬───────┘
│ stock        │                                                │
│ buyPrice     │                                           N:1  │
│ sellPrice    │                                                │
│ imageProduct │                                        ┌───────┴───────┐
│ createdAt    │                                        │  Transaction  │
│ updatedAt    │                                        │               │
└──────────────┘                                        │ id (PK)       │
                                                        │ totalAmount   │
┌──────────────┐                                        │ paymentAmount │
│    User      │        ┌──────────┐                    │ changeAmount  │
│              │        │ ShopData │                    │ status (enum) │
│ id (PK)      │        │          │                    │ isComplete    │
│ name         │        │ id (PK)  │                    │ createdAt     │
│ username     │        │ name     │                    └───────────────┘
│ email        │        └──────────┘
│ password     │
│ role (enum)  │
└──────────────┘
```

### 4.2 Models Detail

| Model | Purpose | Key Fields | Relations |
|---|---|---|---|
| **ProductStock** | Inventory master — stores physical stock | `id`, `name`, `brand` (enum), `category`, `masterCategory`, `skuManual` (unique), `barcode` (optional), `stock`, `buyPrice`, `sellPrice` | 1:1 → Product |
| **Product** | Sale catalog — links stock to sales | `id`, `productId` (unique, FK→ProductStock), `sellprice` | 1:1 → ProductStock, 1:N → OnSaleProduct |
| **OnSaleProduct** | Transaction line item | `id`, `productId` (FK→Product), `quantity`, `saledate`, `transactionId` (FK→Transaction) | N:1 → Product, N:1 → Transaction |
| **Transaction** | Sales transaction record | `id`, `totalAmount` (Decimal), `paymentAmount`, `changeAmount`, `discountAmount` (optional), `status` (SUKSES/RETUR), `isComplete`, `createdAt` | 1:N → OnSaleProduct |
| **User** | User accounts (NOT USED) | `id`, `name`, `username`, `email`, `password`, `role` (OWNER/WORKER/UNKNOW) | None |
| **ShopData** | Store configuration | `id`, `name` | None |
| **Category** | Product category master | `id`, `name` (unique), `createdAt` | None |

### 4.3 Enums

| Enum | Values |
|---|---|
| **Brand** | `HONDA`, `YAMAHA`, `KAWASAKI`, `SUZUKI` |
| **TransactionStatus** | `SUKSES`, `RETUR` |
| **UserRole** | `OWNER`, `WORKER`, `UNKNOW` |

### 4.4 Database Indexes

| Table | Index |
|---|---|
| ProductStock | `brand` |
| ProductStock | `brand, category` |
| ProductStock | `brand, masterCategory` |
| ProductStock | `name` |
| OnSaleProduct | `productId, transactionId` |

---

## 5. API Endpoints

### 5.1 Product APIs

| Method | Endpoint | Description | Query/Body Params |
|---|---|---|---|
| `GET` | `/api/product` | List products with filtering, pagination, in-memory caching | `brand`, `search`, `category`, `masterCategory`, `limit` (50), `offset`, `skipCount` |
| `POST` | `/api/product` | Create new product + linked Product record | `name`, `brand`, `category`, `masterCategory`, `skuManual`, `buyPrice`, `sellPrice`, `stock` |
| `PATCH` | `/api/product/[id]` | Update product details + sync sellprice | Same as POST fields |
| `DELETE` | `/api/product/[id]` | Delete product (cascade to Product) | — |

### 5.2 Transaction APIs

| Method | Endpoint | Description | Query/Body Params |
|---|---|---|---|
| `GET` | `/api/transactions` | List transactions (desc by date) | `limit` (20) |
| `POST` | `/api/transactions` | Create transaction + deduct stock (atomic) | `items[]` (id, quantity, price), `paymentAmount`, `changeAmount` |
| `GET` | `/api/transactions/[id]` | Get single transaction with products | — |
| `PATCH` | `/api/transactions/[id]` | Update or RETURN transaction (restore stock) | `status` ("RETUR"), `totalAmount`, `isComplete` |
| `DELETE` | `/api/transactions/[id]` | Delete transaction | — |

### 5.3 Dashboard APIs

| Method | Endpoint | Description |
|---|---|---|
| `GET` | `/api/dashboard` | KPI aggregations: totalStock, totalAmount, totalQuantity, lowStockCount |
| `GET` | `/api/dashboard/best-sellers` | Top 5 products by total quantity sold |
| `GET` | `/api/dashboard/low-stock` | Products with stock < 5 (limit 5) |
| `GET` | `/api/dashboard/recent-transactions` | Last 5 completed transactions |

### 5.4 Analytics/Report APIs

| Method | Endpoint | Description | Query Params |
|---|---|---|---|
| `GET` | `/api/profit` | Daily profit/revenue grouped by date | `start`, `end` (ISO dates) |
| `GET` | `/api/productsale` | Daily product sale quantities | `start`, `end` |
| `GET` | `/api/favorite` | Top 5 most sold products (all time) | — |

### 5.5 Other APIs

| Method | Endpoint | Description |
|---|---|---|
| `POST` | `/api/onsale` | Create/update line item (upsert by productId+transactionId) |
| `PATCH` | `/api/onsale/[id]` | Update line item quantity |
| `DELETE` | `/api/onsale/[id]` | Delete line item |
| `POST` | `/api/restock` | Bulk add stock to ALL products |
| `PATCH` | `/api/restock/[id]` | Add stock to single product |
| `GET` | `/api/storage` | Get all products with sell prices |
| `GET` | `/api/shopdata` | Get shop name (auto-create if missing) |
| `PATCH` | `/api/shopdata/[id]` | Update store name |

---

## 6. Business Logic Analysis

### 6.1 Cashier Flow (Orders Page)

```
1. Select brand tab (HONDA/YAMAHA/KAWASAKI/SUZUKI)
2. Browse/search products → filtered via /api/product
3. Click product → add to in-memory cart (client state)
4. Adjust quantities with +/- buttons
5. Enter payment amount (in thousands, e.g., 50 = Rp50.000)
6. System calculates change = paymentAmount - total
7. Click "Selesaikan" → POST /api/transactions
   → Atomic Prisma transaction:
     a) Create Transaction record
     b) For each cart item:
        - Find ProductStock
        - Verify sufficient stock (throws if insufficient)
        - Ensure Product exists (create if missing)
        - Create OnSaleProduct line item
        - Decrement ProductStock.stock
8. Show receipt dialog → print via react-to-print
9. Cart resets, products refresh
```

### 6.2 Return (Retur) Flow

```
1. Navigate to Records → Transaction Detail
2. Click Return action on transaction
3. PATCH /api/transactions/[id] with status: "RETUR"
   → Atomic Prisma transaction:
     a) Verify transaction exists and isn't already returned
     b) For each line item: INCREMENT stock back to ProductStock
     c) Update transaction status to "RETUR"
```

### 6.3 Product Management

```
- List: Paginated table with brand tabs, search, category filter
- Create: Modal form → POST /api/product (also creates Product record)
- Edit: Same modal → PATCH /api/product/[id] (syncs sellprice to Product)
- Delete: Confirmation dialog → DELETE /api/product/[id] (cascades)
- Restock (single): PATCH /api/restock/[id] (adds to existing stock)
- Restock (bulk): POST /api/restock (adds fixed amount to ALL products)
```

### 6.4 Reports & Analytics

```
- Dashboard: KPI cards, revenue chart (7-day), low stock warnings, recent transactions
- Records page: Summary tab (stats + charts) + History tab (transaction table)
- Profit API: Calculates gross income and net income per day
  - Net income = sellPrice - buyPrice per item
  - Fallback: If buyPrice is 0, uses flat Rp3.000/item as profit
- CSV Export: Client-side generation from transaction data
```

---

## 7. Data Flow

### 7.1 Sale Transaction Flow

```
UI (Cart State)
  ↓ POST /api/transactions { items[], paymentAmount, changeAmount }
API Route
  ↓ prisma.$transaction()
Database
  ↓ 1. INSERT Transaction
  ↓ 2. For each item:
  ↓    a. SELECT ProductStock (verify stock)
  ↓    b. UPSERT Product (if missing)
  ↓    c. INSERT OnSaleProduct
  ↓    d. UPDATE ProductStock (decrement stock)
  ↓ COMMIT
API Response → Transaction record
  ↓
UI → Show Receipt Dialog → Print
```

### 7.2 Dashboard Data Flow

```
Dashboard Component (useEffect)
  ↓ Parallel requests:
  ├─ GET /api/dashboard          → KPI stats
  ├─ GET /api/dashboard/recent-transactions → Recent list
  ├─ GET /api/dashboard/low-stock → Low stock warnings
  └─ GET /api/profit?start&end   → Revenue chart data
```

---

## 8. Coding Conventions

| Convention | Detail |
|---|---|
| **Components** | Function components, `'use client'` directive where needed |
| **API Routes** | Arrow function exports (`export const GET/POST/PATCH/DELETE`) or named function exports |
| **Naming** | camelCase for variables, PascalCase for components/types, UPPER_SNAKE for constants |
| **Error Handling** | try/catch blocks, NextResponse.json with status codes, console.error logging |
| **State** | Local component state with `useState`, no global state management |
| **Data Fetching** | Client-side via `axios` in `useEffect` |
| **Validation** | Zod schemas in `schema/index.ts` (Indonesian messages), NOT applied in most API routes |
| **Styling** | Tailwind utility classes inline, Jira/Atlassian-inspired color palette |
| **Theme** | Dark/Light mode via next-themes, colors hardcoded per mode |
| **Typography** | Inter (Google Font) |
| **Locale** | Indonesian (`id-ID` for currency, `date-fns/locale/id`) |

### Color Palette (Atlassian/Jira-inspired)

| Token | Light | Dark |
|---|---|---|
| Primary | `#0052CC` | `#579DFF` / `#0C66E4` |
| BG Primary | `#F4F5F7` | `#1D2125` |
| BG Surface | `#FFFFFF` | `#22272B` |
| Border | `#DFE1E6` | `#2C333A` |
| Text Primary | `#172B4D` | `#B6C2CF` / `#FFFFFF` |
| Text Secondary | `#626F86` | `#8C9BAB` |
| Success | `#36B37E` / `#006644` | `#22A06B` |
| Error | `#DE350B` / `#BF2600` | `#FF5630` |
| Warning | `#FF991F` / `#974F0C` | `#F5CD47` / `#FFE380` |

---

## 9. Reusable Components

| Component | Location | Purpose |
|---|---|---|
| `ErrorAlert` | `components/ErrorAlert.tsx` | Radix AlertDialog for error messages |
| `SuccessAlert` | `components/SuccessAlert.tsx` | Radix AlertDialog for success messages |
| `ProductFormModal` | `components/ProductFormModal.tsx` | Create/Edit product dialog form |
| `ReceiptContent` | `components/ReceiptContent.tsx` | Printable receipt layout (forwardRef) |
| `ReceiptDialog` | `components/ReceiptDialog.tsx` | Receipt dialog with print button |
| `ThemeProvider` | `components/theme-provider.tsx` | next-themes wrapper |
| `JiraDashboard` | `components/bento/bentodemo.tsx` | Full dashboard with KPIs, charts, tables |
| **30 shadcn/ui** | `components/ui/*` | Standard UI primitives (Button, Card, Dialog, etc.) |

---

## 10. Known Issues & Technical Debt

### 🔴 Critical

| Issue | Location | Description |
|---|---|---|
| **No Authentication** | Entire app | `User` model exists with roles (OWNER/WORKER) but zero auth implementation. No login page, no session, no route protection. |
| **Exposed Database Credentials** | `.env` | Supabase credentials committed to `.env` (should be in `.env.local`, not tracked by git) |
| **No API Validation** | All API routes | Zod schemas exist in `schema/index.ts` but are **NOT used** in any API route handler — all input is trusted without sanitization |
| **No CSRF/Rate Limiting** | All API routes | No middleware for CSRF protection or rate limiting |

### 🟡 Important

| Issue | Location | Description |
|---|---|---|
| **Dual Product Model Redundancy** | Schema | `ProductStock` and `Product` are split 1:1 unnecessarily — `sellprice` is duplicated in both models |
| **Bulk Restock is Dangerous** | `api/restock/route.ts` | POST endpoint adds fixed stock amount to ALL products — no confirmation or granularity |
| **No Transaction Pagination** | `api/transactions/route.ts` | Fetches up to 200 transactions in one query (Records page), no cursor/page-based pagination |
| **In-Memory Cache in API Routes** | `api/product/route.ts` | Category cache uses module-level Map — resets on serverless cold starts, not shared across instances |
| **Profit Fallback Logic** | `api/profit/route.ts` | When buyPrice=0, uses hardcoded Rp3.000/item as profit — arbitrary and undocumented |
| **Capacitor Integration** | `android/` | Android project exists but barcode scanner and bluetooth printer not yet fully integrated in UI |

### 🟢 Minor

| Issue | Location | Description |
|---|---|---|
| **Inconsistent ID Generation** | `api/product` vs `api/transactions` | Products use UUID without uniqueness check; Transactions loop until unique — inconsistent approach |
| **CRLF Line Endings** | Most files | Mixed CRLF (`\r\n`) and LF (`\n`) line endings |
| **Docker Non-Optimized** | `Dockerfile` | Single-stage build, no multi-stage optimization, copies `.env` into image |
| **package.json name** | `package.json` | Package named `"storage"` instead of a meaningful name |
| **`next.config.mjs`** | Config | References `WEATHER_API` environment variable — unrelated to POS |

---

## 11. Dependencies

### Production Dependencies

| Package | Version | Purpose |
|---|---|---|
| `next` | 14.2.3 | React framework (App Router) |
| `react` / `react-dom` | ^18 | UI library |
| `@prisma/client` | ^5.14.0 | Database ORM client |
| `axios` | ^1.6.8 | HTTP client for API calls |
| `zod` | ^3.23.8 | Schema validation (Indonesian messages) |
| `react-hook-form` + `@hookform/resolvers` | ^7.51.5 | Form management |
| `@radix-ui/*` (12 packages) | Various | Headless UI primitives (shadcn/ui foundation) |
| `lucide-react` | ^0.378.0 | Icon library |
| `@tabler/icons-react` | ^3.3.0 | Additional icon library |
| `apexcharts` + `react-apexcharts` | ^5.3.0 | Chart library |
| `date-fns` | ^3.6.0 | Date formatting/manipulation |
| `decimal.js` | ^10.4.3 | Precise decimal math (used for totalAmount) |
| `framer-motion` | ^11.1.8 | Animation library |
| `next-themes` | ^0.3.0 | Dark/Light mode switching |
| `nextjs-toploader` | ^1.6.12 | Top loading bar on navigation |
| `tailwind-merge` + `clsx` + `class-variance-authority` | Various | Tailwind class utilities |
| `tailwindcss-animate` | ^1.0.7 | Animation utilities for Tailwind |
| `react-to-print` | ^2.15.1 | Receipt printing |
| `react-toastify` | ^10.0.5 | Toast notifications |
| `react-resizable-panels` | ^2.0.19 | Resizable panel layouts |
| `cmdk` | ^1.0.0 | Command menu (shadcn/ui command) |
| `uuid` | ^9.0.1 | UUID generation for IDs |
| `use-debounce` | ^10.0.0 | Debounce hook |
| `mini-svg-data-uri` | ^1.4.4 | SVG optimization |
| `@vercel/analytics` + `@vercel/speed-insights` | Various | Vercel monitoring |
| **`@capacitor/core`** | ^8.4.0 | Capacitor mobile framework |
| **`@capacitor/android`** | ^8.4.0 | Android platform support |
| **`@capacitor/cli`** | ^8.4.0 | Capacitor CLI |
| **`@capacitor/barcode-scanner`** | ^3.0.2 | Barcode scanning (Capacitor plugin) |
| **`@e-is/capacitor-bluetooth-serial`** | ^6.0.3 | Bluetooth serial communication (thermal printer) |

### Dev Dependencies

| Package | Version | Purpose |
|---|---|---|
| `prisma` | ^5.14.0 | Prisma CLI |
| `prisma-dbml-generator` | ^0.12.0 | Generate DBML from Prisma schema |
| `prisma-generator-fake-data` | ^0.14.2 | Generate fake data from schema |
| `@faker-js/faker` | ^8.4.1 | Fake data generation |
| `typescript` | ^5.4.5 | TypeScript compiler |
| `tailwindcss` | ^3.4.1 | CSS framework |
| `postcss` | ^8 | CSS processing |
| `eslint` + plugins | Various | Linting (Prettier integration) |
| `ts-node` | ^10.9.2 | TypeScript execution (scripts) |

---

## 12. Improvement Recommendations

### Priority 1 — Security
1. **Implement Authentication**: Add NextAuth.js or similar, protect all routes, implement role-based access (OWNER vs WORKER)
2. **Move credentials**: Use `.env.local` for secrets, ensure `.env` is in `.gitignore`
3. **Add API validation**: Apply Zod schemas to all API route handlers as middleware
4. **Add CSRF protection**: Implement CSRF tokens for mutating operations

### Priority 2 — Architecture
5. **Merge ProductStock + Product**: Consolidate into a single model to eliminate redundancy
6. **Add proper pagination**: Cursor-based pagination for transactions and products
7. **Add global state**: Consider Zustand or React Context for cart state, user session

### Priority 3 — Features
8. **Complete User management**: Implement user CRUD with role-based permissions
9. **Add Customer management**: Track customer information for transactions
10. **Add Supplier management**: Track suppliers for restocking
11. **Complete Hardware integration**: Wire barcode scanner and bluetooth printer to UI components
12. **Add discount functionality**: Implement discountAmount in transaction flow

### Priority 4 — Quality
13. **Add unit tests**: No tests exist currently
14. **Add error boundaries**: Per-page error handling
15. **Fix Docker build**: Multi-stage build, don't copy `.env` into image
16. **Add logging**: Structured logging instead of console.error
17. **Fix line endings**: Standardize to LF

---

## 13. Quick Reference — Key File Locations

| What | Where |
|---|---|
| Prisma Schema | `prisma/schema.prisma` |
| Database Client | `lib/db.ts` |
| Root Layout | `app/layout.tsx` |
| Sidebar Layout | `app/(root)/layout.tsx` |
| Dashboard | `components/bento/bentodemo.tsx` |
| Cashier Page | `app/(root)/orders/page.tsx` |
| Product List | `app/(root)/product/page.tsx` |
| Records Page | `app/(root)/records/page.tsx` |
| Settings Page | `app/(root)/settings/page.tsx` |
| Category Management | `app/(root)/settings/category/page.tsx` |
| Hardware Settings | `app/(root)/settings/hardware/page.tsx` |
| Categories API | `app/api/categories/route.ts` |
| Zod Schemas | `schema/index.ts` |
| Barcode Scanner | `lib/services/barcode-scanner.ts` |
| Bluetooth Printer | `lib/services/bluetooth-printer.ts` |
| Receipt Builder | `lib/services/receipt-builder.ts` |
| UI Components | `components/ui/` |
| shadcn/ui Config | `components.json` |
| Tailwind Config | `tailwind.config.ts` |
| Global CSS | `app/globals.css` |
| Environment | `.env` |
| Capacitor Config | `capacitor.config.ts` |
| Android Project | `android/` |
| Docker | `Dockerfile` |
| Import Script | `scripts/import-products.ts` |
