import { useState } from 'react';
import { hasClientUserId } from './api/userId';
import { DemoLoginScreen } from './features/auth/DemoLoginScreen';
import { MainApp } from './features/app/MainApp';

export function App() {
  const [sessionReady, setSessionReady] = useState(() => hasClientUserId());

  if (!sessionReady) {
    return <DemoLoginScreen onEnterDemo={() => setSessionReady(true)} />;
  }

  return <MainApp />;
}
