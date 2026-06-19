'use client';

import React, { useState, useEffect } from 'react';
import { Bluetooth, RefreshCw, Printer } from 'lucide-react';
import { Button } from '@/components/ui/button';
import { BluetoothPrinterService } from '@/lib/services/bluetooth-printer';
import { toast } from 'react-toastify';

export default function HardwareSettingPage() {
  const [bluetoothEnabled, setBluetoothEnabled] = useState(false);
  const [devices, setDevices] = useState<any[]>([]);
  const [isScanning, setIsScanning] = useState(false);
  const [connecting, setConnecting] = useState(false);
  const [connectedDevice, setConnectedDevice] = useState<any>(null);

  useEffect(() => {
    const init = async () => {
      const status = await BluetoothPrinterService.checkStatus();
      setBluetoothEnabled(status);
    };
    init();
  }, []);

  const toggleBluetooth = async () => {
    if (bluetoothEnabled) {
      await BluetoothPrinterService.disable();
      setBluetoothEnabled(false);
      setConnectedDevice(null);
    } else {
      await BluetoothPrinterService.enable();
      setBluetoothEnabled(true);
    }
  };

  const handleScan = async () => {
    if (!bluetoothEnabled) return;
    setIsScanning(true);
    try {
      const list = await BluetoothPrinterService.scanDevices();
      setDevices(list);
    } catch (error) {
      console.error(error);
    } finally {
      setIsScanning(false);
    }
  };

  const handleConnect = async (device: any) => {
    setConnecting(true);
    try {
      await BluetoothPrinterService.connect(device.address);
      setConnectedDevice(device);
      localStorage.setItem('printer_mac', device.address);
      toast.success(`Berhasil terhubung ke ${device.name || device.address}`, { position: 'top-right' });
    } catch (error) {
      toast.error('Gagal terhubung ke printer.', { position: 'top-right' });
    } finally {
      setConnecting(false);
    }
  };

  const handlePrintTest = async () => {
    if (!connectedDevice) return;
    try {
      await BluetoothPrinterService.printTestPage(connectedDevice.address);
    } catch (error) {
      toast.error('Gagal mencetak halaman tes.', { position: 'top-right' });
    }
  };

  // Static hardware device list for the table
  const hardwareDevices = [
    {
      name: 'Printer Struk',
      type: 'Bluetooth',
      status: connectedDevice ? 'connected' : 'disconnected',
      lastConnected: connectedDevice ? 'Sekarang' : '-',
    },
    {
      name: 'Barcode Scanner',
      type: 'USB / Keyboard',
      status: 'connected',
      lastConnected: 'Otomatis',
    },
  ];

  return (
    <div className="p-6 max-w-4xl">
      <div className="mb-6">
        <h2 className="text-lg font-bold text-[#172B4D] dark:text-white mb-1">Perangkat Hardware</h2>
        <p className="text-sm text-[#626F86] dark:text-[#8C9BAB]">
          Kelola koneksi ke printer thermal dan scanner barcode.
        </p>
      </div>

      {/* Bluetooth Toggle Row */}
      <div className="bg-white dark:bg-[#22272B] border border-[#DFE1E6] dark:border-[#2C333A] rounded-lg shadow-sm p-4 mb-5 flex items-center justify-between">
        <div className="flex items-center gap-3">
          <Bluetooth className={`w-5 h-5 ${bluetoothEnabled ? 'text-[#0052CC]' : 'text-[#626F86]'}`} />
          <div>
            <div className="text-sm font-bold text-[#172B4D] dark:text-white">Bluetooth</div>
            <div className="text-[10px] text-[#626F86] dark:text-[#8C9BAB]">
              {bluetoothEnabled ? 'Aktif — siap menerima koneksi' : 'Tidak aktif'}
            </div>
          </div>
        </div>
        <div className="flex items-center gap-3">
          {bluetoothEnabled && (
            <Button
              onClick={handleScan}
              disabled={isScanning}
              variant="outline"
              size="sm"
              className="gap-2 border-[#DFE1E6] dark:border-[#2C333A]"
            >
              <RefreshCw className={`w-4 h-4 ${isScanning ? 'animate-spin' : ''}`} />
              {isScanning ? 'Memindai...' : 'Pindai Perangkat'}
            </Button>
          )}
          <button
            onClick={toggleBluetooth}
            className={`relative inline-flex h-6 w-11 items-center rounded-full transition-colors ${bluetoothEnabled ? 'bg-[#0052CC]' : 'bg-[#DFE1E6] dark:bg-[#A5ADBA]'}`}
          >
            <span className={`inline-block h-4 w-4 transform rounded-full bg-white transition-transform ${bluetoothEnabled ? 'translate-x-6' : 'translate-x-1'}`} />
          </button>
        </div>
      </div>

      {/* Hardware Devices Table */}
      <div className="bg-white dark:bg-[#22272B] border border-[#DFE1E6] dark:border-[#2C333A] rounded-lg shadow-sm overflow-hidden mb-5">
        <table className="w-full text-left">
          <thead className="bg-[#F4F5F7] dark:bg-[#1D2125] text-[#44546F] dark:text-[#9FADBC] text-xs uppercase font-bold border-b border-[#DFE1E6] dark:border-[#2C333A]">
            <tr>
              <th className="px-6 py-4">Nama Perangkat</th>
              <th className="px-6 py-4">Tipe Koneksi</th>
              <th className="px-6 py-4">Status</th>
              <th className="px-6 py-4">Terakhir Terhubung</th>
              <th className="px-6 py-4 text-right">Aksi</th>
            </tr>
          </thead>
          <tbody className="divide-y divide-[#DFE1E6] dark:divide-[#2C333A]">
            {hardwareDevices.map((device, i) => (
              <tr key={i} className="hover:bg-[#F4F5F7] dark:hover:bg-[#2C333A] transition-colors">
                <td className="px-6 py-4">
                  <div className="font-semibold text-[#172B4D] dark:text-[#B6C2CF] text-sm">{device.name}</div>
                </td>
                <td className="px-6 py-4 text-sm text-[#626F86] dark:text-[#8C9BAB]">{device.type}</td>
                <td className="px-6 py-4">
                  {device.status === 'connected' ? (
                    <span className="inline-flex items-center px-2 py-0.5 rounded text-[10px] font-bold uppercase bg-[#E3FCEF] text-[#006644]">Terhubung</span>
                  ) : (
                    <span className="inline-flex items-center px-2 py-0.5 rounded text-[10px] font-bold uppercase bg-[#FFEBE6] text-[#BF2600]">Terputus</span>
                  )}
                </td>
                <td className="px-6 py-4 text-sm text-[#626F86] dark:text-[#8C9BAB]">{device.lastConnected}</td>
                <td className="px-6 py-4 text-right">
                  {device.name === 'Printer Struk' && connectedDevice && (
                    <Button onClick={handlePrintTest} variant="outline" size="sm" className="gap-2 border-[#DFE1E6] dark:border-[#2C333A]">
                      <Printer className="w-4 h-4" />
                      Tes Cetak
                    </Button>
                  )}
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>

      {/* Discovered Devices Table */}
      {devices.length > 0 && (
        <div className="bg-white dark:bg-[#22272B] border border-[#DFE1E6] dark:border-[#2C333A] rounded-lg shadow-sm overflow-hidden">
          <div className="px-6 py-4 border-b border-[#DFE1E6] dark:border-[#2C333A]">
            <h3 className="text-sm font-bold text-[#172B4D] dark:text-white uppercase tracking-tight">Perangkat Ditemukan</h3>
          </div>
          <table className="w-full text-left">
            <thead className="bg-[#F4F5F7] dark:bg-[#1D2125] text-[#44546F] dark:text-[#9FADBC] text-xs uppercase font-bold border-b border-[#DFE1E6] dark:border-[#2C333A]">
              <tr>
                <th className="px-6 py-4">Nama</th>
                <th className="px-6 py-4">Alamat</th>
                <th className="px-6 py-4 text-right">Aksi</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-[#DFE1E6] dark:divide-[#2C333A]">
              {devices.map((device, i) => (
                <tr key={i} className="hover:bg-[#F4F5F7] dark:hover:bg-[#2C333A] transition-colors">
                  <td className="px-6 py-4 font-semibold text-[#172B4D] dark:text-[#B6C2CF] text-sm">
                    {device.name || 'Unknown Device'}
                  </td>
                  <td className="px-6 py-4 text-sm font-mono text-[#626F86] dark:text-[#8C9BAB]">
                    {device.address}
                  </td>
                  <td className="px-6 py-4 text-right">
                    <Button
                      onClick={() => handleConnect(device)}
                      disabled={connecting || connectedDevice?.address === device.address}
                      size="sm"
                      className={connectedDevice?.address === device.address
                        ? 'bg-[#E3FCEF] text-[#006644] hover:bg-[#E3FCEF] border border-[#006644]/20'
                        : 'bg-[#0052CC] hover:bg-[#0747A6] text-white'}
                    >
                      {connectedDevice?.address === device.address ? 'Terhubung' : 'Hubungkan'}
                    </Button>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      )}
    </div>
  );
}
