import { FormEvent, useState } from 'react';
import { login, register } from '../../api/auth';
import { enterDemoUser } from '../../api/userId';

type DemoLoginScreenProps = {
  onAuthenticated: () => void;
};

export function DemoLoginScreen({ onAuthenticated }: DemoLoginScreenProps) {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [error, setError] = useState<string | null>(null);
  const [busy, setBusy] = useState(false);
  const showDemoEntry = import.meta.env.DEV;

  const handleEnterDemo = () => {
    enterDemoUser();
    onAuthenticated();
  };

  const handleSignIn = async (event: FormEvent) => {
    event.preventDefault();
    setBusy(true);
    setError(null);
    try {
      await login(email, password);
      onAuthenticated();
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Sign in failed');
    } finally {
      setBusy(false);
    }
  };

  const handleSignUp = async () => {
    setBusy(true);
    setError(null);
    try {
      await register(email, password);
      onAuthenticated();
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Sign up failed');
    } finally {
      setBusy(false);
    }
  };

  return (
    <main className="login-shell">
      <section className="login-card" aria-labelledby="login-title">
        <p className="eyebrow">TrueSight</p>
        <h1 id="login-title">FridgeWise</h1>

        {showDemoEntry ? (
          <button className="primary-action enter-demo" type="button" onClick={handleEnterDemo}>
            Enter Demo
          </button>
        ) : null}

        <p className="login-helper">{showDemoEntry ? 'Welcome to the Demo' : 'Sign in to continue'}</p>

        <form className="login-form" aria-label="Sign in" onSubmit={handleSignIn}>
          <label>
            Email
            <input
              type="email"
              name="email"
              placeholder="you@example.com"
              value={email}
              onChange={(event) => setEmail(event.target.value)}
              autoComplete="email"
              required
            />
          </label>
          <label>
            Password
            <input
              type="password"
              name="password"
              placeholder="••••••••"
              value={password}
              onChange={(event) => setPassword(event.target.value)}
              autoComplete="current-password"
              minLength={8}
              required
            />
          </label>
          {error ? <p className="login-error">{error}</p> : null}
          <button type="submit" className="secondary-action" disabled={busy}>
            Sign in
          </button>
          <div className="login-links">
            <button type="button" disabled={busy} onClick={handleSignUp}>
              Sign up
            </button>
            <button type="button" disabled aria-disabled="true">
              Forgot password
            </button>
          </div>
          <div className="oauth-row">
            <button type="button" className="oauth-button" disabled aria-disabled="true">
              Google
            </button>
            <button type="button" className="oauth-button" disabled aria-disabled="true">
              Facebook
            </button>
          </div>
        </form>
      </section>
    </main>
  );
}
