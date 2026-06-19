export interface ReceiptItem {
  name: string;
  qty: number;
  price: number;
}

export interface ReceiptData {
  storeName: string;
  storeAddress: string;
  storePhone: string;
  cashierName: string;
  transactionId: string;
  items: ReceiptItem[];
  total: number;
  paymentAmount: number;
  changeAmount: number;
  discountAmount?: number;
  footerMessage: string;
  appUrl?: string; // For QR code
}

export function buildReceipt(data: ReceiptData): string {
  const ESC = '\x1b';
  const GS = '\x1d';
  
  // Commands
  const init = ESC + '@';
  const center = ESC + 'a' + '\x01';
  const left = ESC + 'a' + '\x00';
  const right = ESC + 'a' + '\x02';
  const boldOn = ESC + 'E' + '\x01';
  const boldOff = ESC + 'E' + '\x00';
  const sizeNormal = GS + '!' + '\x00';
  const sizeLarge = GS + '!' + '\x11'; // Double size
  
  let r = '';
  r += init;
  
  // Header
  r += center;
  r += sizeLarge + boldOn + data.storeName.toUpperCase() + boldOff + sizeNormal + "\n";
  r += data.storeAddress + "\n";
  if (data.storePhone) {
    r += `Telp: ${data.storePhone}\n`;
  }
  r += "--------------------------------\n";
  
  // Meta Info
  r += left;
  r += `Kasir: ${data.cashierName}\n`;
  r += `Waktu: ${new Date().toLocaleString('id-ID')}\n`;
  r += `No Trx: ${data.transactionId}\n`;
  r += "--------------------------------\n";
  
  // Items
  data.items.forEach(item => {
    const nameLine = `${item.name} x${item.qty}`;
    const priceStr = `Rp ${(item.price * item.qty).toLocaleString('id-ID')}`;
    
    const totalSpaces = 32 - nameLine.length - priceStr.length;
    if (totalSpaces > 0) {
      r += nameLine + ' '.repeat(totalSpaces) + priceStr + '\n';
    } else {
      r += nameLine + '\n';
      r += ' '.repeat(32 - priceStr.length) + priceStr + '\n';
    }
  });
  
  r += "--------------------------------\n";
  
  // Total & Payment
  r += boldOn;
  
  // Discount
  if (data.discountAmount && data.discountAmount > 0) {
    const subtotalLabel = "SUBTOTAL";
    const subtotalValStr = `Rp ${(data.total + data.discountAmount).toLocaleString('id-ID')}`;
    const subtotalSpaces = 32 - subtotalLabel.length - subtotalValStr.length;
    r += subtotalLabel + ' '.repeat(Math.max(0, subtotalSpaces)) + subtotalValStr + '\n';

    const discLabel = "DISKON";
    const discValStr = `-Rp ${data.discountAmount.toLocaleString('id-ID')}`;
    const discSpaces = 32 - discLabel.length - discValStr.length;
    r += discLabel + ' '.repeat(Math.max(0, discSpaces)) + discValStr + '\n';
  }

  // Total
  const totalLabel = "TOTAL";
  const totalValStr = `Rp ${data.total.toLocaleString('id-ID')}`;
  const totalSpaces = 32 - totalLabel.length - totalValStr.length;
  r += totalLabel + ' '.repeat(Math.max(0, totalSpaces)) + totalValStr + '\n';
  
  // Payment
  const payLabel = "TUNAI";
  const payValStr = `Rp ${data.paymentAmount.toLocaleString('id-ID')}`;
  const paySpaces = 32 - payLabel.length - payValStr.length;
  r += payLabel + ' '.repeat(Math.max(0, paySpaces)) + payValStr + '\n';
  
  // Change
  if (data.changeAmount > 0) {
    const changeLabel = "KEMBALI";
    const changeValStr = `Rp ${data.changeAmount.toLocaleString('id-ID')}`;
    const changeSpaces = 32 - changeLabel.length - changeValStr.length;
    r += changeLabel + ' '.repeat(Math.max(0, changeSpaces)) + changeValStr + '\n';
  }
  
  r += boldOff;
  r += "--------------------------------\n";
  
  // Footer
  r += center;
  r += `\n${data.footerMessage}\n`;
  
  // 1D Barcode (Code39)
  r += "\n-- NO. TRANSAKSI --\n";
  r += GS + 'h' + String.fromCharCode(60); // height: 60 dots
  r += GS + 'w' + String.fromCharCode(2);  // width: 2
  r += GS + 'H' + String.fromCharCode(2);  // print text below
  
  // Format transaction ID for Code39 (remove non-alphanumeric and uppercase it to be safe, or just use it directly if it fits)
  // Code39 only supports 0-9, A-Z, and some special chars. If UUID, it contains hyphens and lowercase.
  const shortTrxId = data.transactionId.split('-')[0].toUpperCase();
  r += GS + 'k' + '\x04' + shortTrxId + '\x00'; // CODE39
  r += "\n";
  
  // 2D QR Code pointing to local app server IP (if appUrl is provided)
  if (data.appUrl) {
    const qrUrl = `${data.appUrl}/receipt/${data.transactionId}`;
    r += "\n-- SCAN BUKTI TRANSAKSI --\n";
    
    // Select Model: Model 2 (Hex: 1d 28 6b 04 00 31 41 32 00)
    r += GS + '\x28\x6b\x04\x00\x31\x41\x32\x00';
    // Set Module Size: size 3 (Hex: 1d 28 6b 03 00 31 43 03)
    r += GS + '\x28\x6b\x03\x00\x31\x43\x03';
    // Set Error Correction: level L (Hex: 1d 28 6b 03 00 31 45 30)
    r += GS + '\x28\x6b\x03\x00\x31\x45\x30';
    // Store Data: (Hex: 1d 28 6b pL pH 31 50 30 [data])
    const len = qrUrl.length + 3;
    const pL = String.fromCharCode(len % 256);
    const pH = String.fromCharCode(Math.floor(len / 256));
    r += GS + '\x28\x6b' + pL + pH + '\x31\x50\x30' + qrUrl;
    // Print Symbol: (Hex: 1d 28 6b 03 00 31 51 30)
    r += GS + '\x28\x6b\x03\x00\x31\x51\x30';
  }
  
  r += "\n\n\n\n\n"; // feeds
  
  return r;
}
