import type { CapacitorConfig } from '@capacitor/cli';

const config: CapacitorConfig = {
  appId: 'com.posnext.app',
  appName: 'POS Kasir',
  webDir: 'public',
  server: {
    url: 'http://192.168.5.23:3000',
    cleartext: true
  }
};

export default config;
