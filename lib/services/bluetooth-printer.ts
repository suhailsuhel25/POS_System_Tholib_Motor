import { Capacitor } from '@capacitor/core';
import { BluetoothSerial, BluetoothDevice } from '@e-is/capacitor-bluetooth-serial';
import { toast } from 'react-toastify';

export class BluetoothPrinterService {
  static isNative() {
    return Capacitor.isNativePlatform();
  }

  static async checkStatus(): Promise<boolean> {
    if (!this.isNative()) return false;
    try {
      const state = await BluetoothSerial.isEnabled();
      return state.enabled;
    } catch (error) {
      console.error('Error checking bluetooth status:', error);
      return false;
    }
  }

  static async enable(): Promise<void> {
    if (!this.isNative()) {
      toast.warning('Fitur Bluetooth hanya tersedia di aplikasi Android (APK).', { position: 'top-right' });
      return;
    }
    await BluetoothSerial.enable();
  }

  static async disable(): Promise<void> {
    if (!this.isNative()) return;
    await BluetoothSerial.disable();
  }

  static async scanDevices(): Promise<BluetoothDevice[]> {
    if (!this.isNative()) {
      toast.warning('Fitur pemindaian Bluetooth hanya tersedia di aplikasi Android (APK).', { position: 'top-right' });
      return [];
    }
    const result = await BluetoothSerial.scan();
    return result.devices || [];
  }

  static async connect(address: string): Promise<void> {
    if (!this.isNative()) return;
    await BluetoothSerial.connect({ address });
  }

  static async disconnect(address: string): Promise<void> {
    if (!this.isNative()) return;
    await BluetoothSerial.disconnect({ address });
  }

  static async printData(address: string, data: string): Promise<void> {
    if (!this.isNative()) {
      console.log('Simulasi Print (Web Mode):', data);
      return;
    }
    await BluetoothSerial.write({ address, value: data });
  }

  static async printTestPage(address: string): Promise<void> {
    const ESC = '\x1b';
    const GS = '\x1d';
    
    let r = '';
    r += ESC + '@'; // init
    r += ESC + 'a' + '\x01'; // center
    r += GS + '!' + '\x11' + "TEST PRINTER" + GS + '!' + '\x00' + "\n";
    r += "--------------------------------\n";
    r += ESC + 'a' + '\x00'; // left
    r += "Koneksi: Bluetooth Classic SPP\n";
    r += "Status: Sukses Terhubung!\n";
    r += "Karakter: 32 Karakter per baris\n";
    r += "Aplikasi: POS Kasir Next\n";
    r += "--------------------------------\n";
    r += ESC + 'a' + '\x01'; // center
    r += "\n\n\n\n\n";

    await this.printData(address, r);
  }
}
