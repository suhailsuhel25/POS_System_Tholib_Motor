export interface ReceiptItem {
  name: string;
  brand?: string;
  qty: number;
  price: number;
}

export interface ReceiptData {
  storeName: string;
  storeSubtitle?: string;
  storeAddress: string;
  storePhone?: string;
  cashierName?: string;
  transactionId: string;
  createdAt?: Date;
  items: ReceiptItem[];
  total: number;
  paymentAmount: number;
  changeAmount: number;
  discountAmount?: number;
  footerMessage: string;
  appUrl?: string;
}

const CODE39_CHARS: Record<string, string> = {
  '0': 'nnnwwnwnn', '1': 'wnnwnnnnw', '2': 'nnwwnnnnw', '3': 'wnwwnnnnn',
  '4': 'nnnwwnnnw', '5': 'wnnwwnnnn', '6': 'nnwwwnnnn', '7': 'nnnwnnwnw',
  '8': 'wnnwnnwnn', '9': 'nnwwnnwnn', 'A': 'wnnnnwnnw', 'B': 'nnwnnwnnw',
  'C': 'wnwnnwnnn', 'D': 'nnnnwwnnw', 'E': 'wnnnwwnnn', 'F': 'nnwnwwnnn',
  'G': 'nnnnnwwnw', 'H': 'wnnnnwwnn', 'I': 'nnwnnwwnn', 'J': 'nnnnwwwnn',
  'K': 'wnnnnnnww', 'L': 'nnwnnnnww', 'M': 'wnwnnnnwn', 'N': 'nnnnwnnww',
  'O': 'wnnnwnnwn', 'P': 'nnwnwnnwn', 'Q': 'nnnnnnwww', 'R': 'wnnnnnwwn',
  'S': 'nnwnnnwwn', 'T': 'nnnnwnwwn', 'U': 'wwnnnnnnn', 'V': 'nwwnnnnnn',
  'W': 'wwwnnnnnn', 'X': 'nwnnwnnnn', 'Y': 'wwnnwnnnn', 'Z': 'nwwnwnnnn',
  '-': 'nwnnnnwnn', '.': 'wwnnnnnwn', ' ': 'nwwnnnwnn', '$': 'nwnwnwnnn',
  '/': 'nwnnwnwnn', '+': 'nwnnnwnwn', '%': 'nnnwnwnwn',
};

function generateCode39Raster(canvas: HTMLCanvasElement, text: string): number {
  const upper = text.toUpperCase();
  const full = '*' + upper + '*';
  const barW = 2;
  const barH = 60;
  const textH = 18;

  let totalBars = 0;
  for (const ch of full) {
    const pattern = CODE39_CHARS[ch];
    if (pattern) totalBars += pattern.length;
  }

  const padding = 16;
  const width = totalBars * barW + padding * 2;
  const height = barH + textH;

  canvas.width = width;
  canvas.height = height;
  const ctx = canvas.getContext('2d')!;
  ctx.fillStyle = '#ffffff';
  ctx.fillRect(0, 0, width, height);
  ctx.fillStyle = '#000000';

  let x = padding;
  for (const ch of full) {
    const pattern = CODE39_CHARS[ch];
    if (!pattern) continue;
    for (let i = 0; i < pattern.length; i++) {
      if (pattern[i] === 'w') {
        ctx.fillRect(x, 0, barW * 2, barH);
        x += barW * 2;
      } else {
        ctx.fillRect(x, 0, barW, barH);
        x += barW;
      }
    }
    x += barW;
  }

  ctx.font = 'bold 14px monospace';
  ctx.textAlign = 'center';
  ctx.textBaseline = 'top';
  ctx.fillText(text, width / 2, barH + 2);

  return width;
}

export async function buildReceiptBase64(data: ReceiptData): Promise<string> {
  const ESC = '\x1b';
  const GS = '\x1d';
  const encoder = new TextEncoder();
  const parts: number[] = [];

  function pushStr(s: string) {
    for (const b of Array.from(encoder.encode(s))) parts.push(b);
  }
  function pushByte(b: number) { parts.push(b); }

  const init = ESC + '@';
  const center = ESC + 'a' + '\x01';
  const left = ESC + 'a' + '\x00';
  const right = ESC + 'a' + '\x02';
  const boldOn = ESC + 'E' + '\x01';
  const boldOff = ESC + 'E' + '\x00';
  const sizeNormal = GS + '!' + '\x00';
  const sizeLarge = GS + '!' + '\x11'; // Double size

  pushStr(init);
  
  // Header (matches preview)
  pushStr(center);
  pushStr(sizeLarge + boldOn + data.storeName.toUpperCase() + boldOff + sizeNormal + "\n");
  if (data.storeSubtitle) {
    pushStr(data.storeSubtitle + "\n");
  }
  pushStr(data.storeAddress + "\n");
  if (data.storePhone) {
    pushStr(`Telp: ${data.storePhone}\n`);
  }
  
  pushStr("--------------------------------\n");
  
  // Meta Information (Transaction ID & Time)
  pushStr(left);
  const dateStr = data.createdAt 
    ? data.createdAt.toLocaleString('id-ID', { year: '2-digit', month: '2-digit', day: '2-digit', hour: '2-digit', minute: '2-digit' }).replace(/\./g, ':')
    : new Date().toLocaleString('id-ID', { year: '2-digit', month: '2-digit', day: '2-digit', hour: '2-digit', minute: '2-digit' }).replace(/\./g, ':');
  
  const shortId = `#${data.transactionId.slice(-8).toUpperCase()}`;
  const idLabel = "No. Transaksi";
  const dateLabel = "Waktu";
  
  // Line 1: No. Transaksi (left), Waktu (right)
  const metaSpaces1 = 32 - idLabel.length - dateLabel.length;
  pushStr(idLabel + ' '.repeat(Math.max(0, metaSpaces1)) + dateLabel + '\n');
  
  // Line 2: ID (left), Date (right)
  const metaSpaces2 = 32 - shortId.length - dateStr.length;
  pushStr(boldOn + shortId + boldOff + ' '.repeat(Math.max(0, metaSpaces2)) + boldOn + dateStr + boldOff + '\n');
  
  pushStr("--------------------------------\n");
  
  // Items
  data.items.forEach(item => {
    // Top line: Name (left), Total Price (right)
    const nameLine = item.name.length > 18 ? item.name.substring(0, 18) : item.name;
    const priceStr = `Rp${(item.price * item.qty).toLocaleString('id-ID')}`;
    
    const spaces = 32 - nameLine.length - priceStr.length;
    pushStr(boldOn + nameLine + boldOff + ' '.repeat(Math.max(0, spaces)) + boldOn + priceStr + boldOff + '\n');
    
    // Bottom line: Brand qty x unit_price
    let detailLine = "";
    if (item.brand) detailLine += `[${item.brand}] `;
    detailLine += `${item.qty} x Rp${item.price.toLocaleString('id-ID')}`;
    pushStr(detailLine + '\n\n');
  });
  
  pushStr("--------------------------------\n");
  
  // Total & Payment
  pushStr(boldOn);
  if (data.discountAmount && data.discountAmount > 0) {
    const subtotalLabel = "Subtotal";
    const subtotalValStr = `Rp${(data.total + data.discountAmount).toLocaleString('id-ID')}`;
    const subtotalSpaces = 32 - subtotalLabel.length - subtotalValStr.length;
    pushStr(subtotalLabel + ' '.repeat(Math.max(0, subtotalSpaces)) + subtotalValStr + '\n');

    const discLabel = "Diskon";
    const discValStr = `-Rp${data.discountAmount.toLocaleString('id-ID')}`;
    const discSpaces = 32 - discLabel.length - discValStr.length;
    pushStr(discLabel + ' '.repeat(Math.max(0, discSpaces)) + discValStr + '\n');
  }

  const totalLabel = "Total";
  const totalValStr = `Rp${data.total.toLocaleString('id-ID')}`;
  const totalSpaces = 32 - totalLabel.length - totalValStr.length;
  pushStr(totalLabel + ' '.repeat(Math.max(0, totalSpaces)) + totalValStr + '\n');
  pushStr(boldOff);
  
  const payLabel = "Bayar";
  const payValStr = `Rp${data.paymentAmount.toLocaleString('id-ID')}`;
  const paySpaces = 32 - payLabel.length - payValStr.length;
  pushStr(payLabel + ' '.repeat(Math.max(0, paySpaces)) + payValStr + '\n');
  
  const changeLabel = "Kembali";
  const changeValStr = `Rp${data.changeAmount.toLocaleString('id-ID')}`;
  const changeSpaces = 32 - changeLabel.length - changeValStr.length;
  pushStr(changeLabel + ' '.repeat(Math.max(0, changeSpaces)) + changeValStr + '\n');
  
  pushStr("--------------------------------\n");
  
  // Footer
  pushStr(center);
  pushStr(boldOn + "Terima Kasih!\n" + boldOff);
  pushStr(data.footerMessage + "\n\n");
  
  // Print Native Barcode (CODE128)
  pushStr("-- NO. TRANSAKSI --\n");
  pushStr(GS + 'h' + String.fromCharCode(60)); // Height
  pushStr(GS + 'w' + String.fromCharCode(2));  // Width
  pushStr(GS + 'H' + String.fromCharCode(2));  // HRI chars below
  
  // Format transaction ID for Code128: GS k \x49 <length> <data>
  // Code128 requires a START code. {B = \x7B\x42
  const trxId = data.transactionId.substring(0, 15);
  const barcodeData = '\x7B\x42' + trxId; // Start Code B + ID
  pushStr(GS + 'k' + '\x49' + String.fromCharCode(barcodeData.length) + barcodeData + '\n');
  
  pushByte(0x0A); pushByte(0x0A); pushByte(0x0A); pushByte(0x0A); pushByte(0x0A); // feed

  const uint8 = new Uint8Array(parts);
  let binary = '';
  for (let i = 0; i < uint8.length; i++) {
    binary += String.fromCharCode(uint8[i]);
  }
  return btoa(binary);
}
