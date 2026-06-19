import type { CapacitorConfig } from '@capacitor/cli';

const config: CapacitorConfig = {
  appId: 'com.posnext.app',
  appName: 'POS Kasir',
  webDir: 'public',
  server: {
    url: 'https://tholib-motor.vercel.app/',
    cleartext: true
  }
};

export default config;
