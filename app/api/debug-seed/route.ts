import { db } from '@/lib/db';
import { NextResponse } from 'next/server';

export async function GET() {
  try {
    console.log('=== STARTING DEBUG SEED ===');

    // 1. Ambil 3 produk stock pertama untuk data transaksi dummy yang valid
    const productStocks = await db.productStock.findMany({ take: 3 });
    if (productStocks.length === 0) {
      return NextResponse.json({ success: false, error: 'Tidak ada produk di ProductStock untuk referensi transaksi' }, { status: 200 });
    }

    // Pastikan productStock tersebut terhubung ke model Product
    const products: any[] = [];
    for (const ps of productStocks) {
      const prod = await db.product.upsert({
        where: { productId: ps.id },
        update: {},
        create: {
          productId: ps.id,
          sellprice: ps.sellPrice,
        },
      });
      products.push({ ...prod, stockName: ps.name });
    }

    // Generate random suffix so every seed run is unique and conflict-free
    const suffix = Math.floor(100 + Math.random() * 900);

    // 2. Buat Bengkel Baru dengan suffix unik
    const bSentosa = await db.bengkel.create({
      data: {
        name: `Bengkel Sentosa Motor #${suffix}`,
        phone: '08122334455',
        address: 'Jl. Menteng No. 12, Jakarta Pusat',
        notes: 'Pelanggan setia suku cadang ban dan oli (Data Contoh)',
        paymentCycle: 7, // mingguan
      }
    });

    const bAutoGarage = await db.bengkel.create({
      data: {
        name: `Auto Garage Jakarta #${suffix}`,
        phone: '08388997766',
        address: 'Jl. Boulevard Raya Blok HG, Jakarta Utara',
        notes: 'Melakukan pelunasan tiap 2 minggu (Data Contoh)',
        paymentCycle: 14,
      }
    });

    const bMitra = await db.bengkel.create({
      data: {
        name: `Mitra Motor Servis #${suffix}`,
        phone: '08566778899',
        address: 'Jl. Pajajaran No. 101, Bandung',
        notes: 'Siklus bulanan tempo lama (Data Contoh)',
        paymentCycle: 30,
      }
    });

    // 3. Masukkan transaksi HUTANG yang belum lunas
    // -- Bengkel Sentosa --
    const tr1Id = `TR-SNT-${suffix}-${Math.floor(1000 + Math.random() * 9000)}`;
    await db.transaction.create({
      data: {
        id: tr1Id,
        totalAmount: 350000,
        paymentAmount: 0,
        changeAmount: 0,
        discountAmount: 0,
        status: 'HUTANG',
        isComplete: true,
        products: {
          create: {
            productId: products[0].productId,
            quantity: 2,
          },
        },
      },
    });
    await db.debt.create({
      data: {
        bengkelId: bSentosa.id,
        amount: 350000,
        transactionId: tr1Id,
        notes: 'Suku Cadang Mesin (Ban & Oli)',
      },
    });

    const tr2Id = `TR-SNT-${suffix}-${Math.floor(1000 + Math.random() * 9000)}`;
    await db.transaction.create({
      data: {
        id: tr2Id,
        totalAmount: 200000,
        paymentAmount: 0,
        changeAmount: 0,
        discountAmount: 0,
        status: 'HUTANG',
        isComplete: true,
        products: {
          create: {
            productId: products[1 % products.length].productId,
            quantity: 1,
          },
        },
      },
    });
    await db.debt.create({
      data: {
        bengkelId: bSentosa.id,
        amount: 200000,
        transactionId: tr2Id,
        notes: 'Peralatan Bengkel (Kunci & Alat)',
      },
    });

    // -- Auto Garage Jakarta --
    const tr3Id = `TR-AGJ-${suffix}-${Math.floor(1000 + Math.random() * 9000)}`;
    await db.transaction.create({
      data: {
        id: tr3Id,
        totalAmount: 1200000,
        paymentAmount: 0,
        changeAmount: 0,
        discountAmount: 0,
        status: 'HUTANG',
        isComplete: true,
        products: {
          create: {
            productId: products[2 % products.length].productId,
            quantity: 4,
          },
        },
      },
    });
    await db.debt.create({
      data: {
        bengkelId: bAutoGarage.id,
        amount: 1200000,
        transactionId: tr3Id,
        notes: 'Peralatan Bengkel Hidrolik & Dongkrak',
      },
    });

    // -- Mitra Motor Servis (Belum Lunas) --
    const tr4Id = `TR-MMS-${suffix}-${Math.floor(1000 + Math.random() * 9000)}`;
    await db.transaction.create({
      data: {
        id: tr4Id,
        totalAmount: 450000,
        paymentAmount: 0,
        changeAmount: 0,
        discountAmount: 0,
        status: 'HUTANG',
        isComplete: true,
        products: {
          create: {
            productId: products[0].productId,
            quantity: 3,
          },
        },
      },
    });
    await db.debt.create({
      data: {
        bengkelId: bMitra.id,
        amount: 450000,
        transactionId: tr4Id,
        notes: 'Perbaikan Kendaraan Yamaha Mio',
      },
    });

    // 4. Masukkan transaksi HUTANG yang SUDAH LUNAS (simulasi riwayat pembayaran)
    const tr5Id = `TR-MMS-${suffix}-${Math.floor(1000 + Math.random() * 9000)}`;
    await db.transaction.create({
      data: {
        id: tr5Id,
        totalAmount: 980000,
        paymentAmount: 980000,
        changeAmount: 0,
        discountAmount: 0,
        status: 'SUKSES',
        isComplete: true,
        products: {
          create: {
            productId: products[1 % products.length].productId,
            quantity: 5,
          },
        },
      },
    });
    const paidDebt = await db.debt.create({
      data: {
        bengkelId: bMitra.id,
        amount: 980000,
        transactionId: tr5Id,
        notes: 'Beli Karburator & Knalpot R9',
        isPaid: true,
        paidAt: new Date(Date.now() - 3 * 24 * 60 * 60 * 1000), // Lunas 3 hari lalu
      },
    });

    // Catat record pembayaran kolektifnya (DebtPayment)
    const payment = await db.debtPayment.create({
      data: {
        bengkelId: bMitra.id,
        totalPaid: 950000,
        discount: 30000, // Diskon Rp30.000
        notes: 'Dilunasi via transfer Bank BCA dengan diskon Rp30rb (Data Contoh)',
        createdAt: new Date(Date.now() - 3 * 24 * 60 * 60 * 1000),
        debtItems: {
          create: {
            debtId: paidDebt.id,
          },
        },
      },
    });

    // Catat cashflow masuk ke Expense
    await db.expense.create({
      data: {
        description: `Pembayaran hutang ${bMitra.name}`,
        amount: 950000,
        category: 'PIUTANG_MASUK',
        notes: 'Melunasi transaksi karburator & knalpot (Data Contoh)',
        createdAt: new Date(Date.now() - 3 * 24 * 60 * 60 * 1000),
      },
    });

    console.log('✅ DEBUG SEED COMPLETED SUCCESSFULLY');
    return NextResponse.json({
      success: true,
      message: `Database berhasil di-seed dengan data contoh B2B baru (Suffix #${suffix})!`,
      bengkelsCreated: 3,
      unpaidDebtsCount: 4,
      paidDebtsCount: 1,
    });
  } catch (error: any) {
    console.error('Error seeding debug data:', error);
    return NextResponse.json({ success: false, error: error.message || 'Internal Server Error', stack: error.stack }, { status: 200 });
  }
}
