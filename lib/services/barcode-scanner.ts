import { useEffect, useRef } from 'react';
import { Capacitor } from '@capacitor/core';
import { toast } from 'react-toastify';

export class BarcodeScannerService {
  static async scanCamera(): Promise<string | null> {
    if (!Capacitor.isNativePlatform()) {
      toast.warning('Fitur pemindaian Kamera hanya tersedia di aplikasi Android (APK).', { position: 'top-right' });
      return null;
    }
    
    try {
      const { CapacitorBarcodeScanner, CapacitorBarcodeScannerTypeHint } = await import('@capacitor/barcode-scanner');
      const result = await CapacitorBarcodeScanner.scanBarcode({
        hint: CapacitorBarcodeScannerTypeHint.ALL
      });
      if (result && result.ScanResult) {
        return result.ScanResult;
      }
      return null;
    } catch (err: any) {
      console.error('Camera scan failed', err);
      throw err;
    }
  }
}

/**
 * Hook to listen for fast keyboard input (HID barcode scanner gun)
 * Scanners typically type keystrokes very fast (<50ms between keys)
 * 
 * @param onScan Callback triggered when a barcode is fully scanned (Enter key is pressed)
 */
export function useHardwareScanner(onScan: (barcode: string) => void) {
  // Use ref to avoid stale closures if onScan changes
  const onScanRef = useRef(onScan);
  useEffect(() => {
    onScanRef.current = onScan;
  }, [onScan]);

  useEffect(() => {
    let barcodeBuffer = '';
    let lastKeyTime = Date.now();

    const handleGlobalKeyDown = (e: KeyboardEvent) => {
      // Ignore if typing in a specific manual input field to avoid double entry
      const target = e.target as HTMLElement;
      const isInput = target.tagName === 'INPUT' || target.tagName === 'TEXTAREA';
      
      const now = Date.now();
      const diff = now - lastKeyTime;
      lastKeyTime = now;

      // Scanners type keys extremely fast (usually < 50ms).
      // If typing is slow, reset the buffer since it's likely a human.
      if (diff > 50) {
        barcodeBuffer = '';
      }

      if (e.key.length === 1) {
        barcodeBuffer += e.key;
      }

      if (e.key === 'Enter') {
        if (barcodeBuffer.length >= 3) {
          // Scanner finished reading barcode
          onScanRef.current(barcodeBuffer);
          barcodeBuffer = '';
          e.preventDefault();
        }
      }
    };

    window.addEventListener('keydown', handleGlobalKeyDown);
    return () => {
      window.removeEventListener('keydown', handleGlobalKeyDown);
    };
  }, []);
}
