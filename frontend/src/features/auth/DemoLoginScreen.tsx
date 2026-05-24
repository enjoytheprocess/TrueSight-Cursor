import { enterDemoUser } from '../../api/userId';

type DemoLoginScreenProps = {
  onEnterDemo: () => void;
};

export function DemoLoginScreen({ onEnterDemo }: DemoLoginScreenProps) {
  const handleEnterDemo = () => {
    enterDemoUser();
    onEnterDemo();
  };

  return (
    <main className="login-shell">
      <section className="login-card" aria-labelledby="login-title">
        <p className="eyebrow">TrueSight</p>
        <h1 id="login-title">FridgeWise</h1>

        <button className="primary-action enter-demo" type="button" onClick={handleEnterDemo}>
          Enter Demo
        </button>

        <p className="login-helper">Welcome to the Demo</p>

        <form className="login-form" aria-label="Sign in (disabled)">
          <label>
            Email
            <input type="email" name="email" placeholder="you@example.com" disabled aria-disabled="true" />
          </label>
          <label>
            Password
            <input type="password" name="password" placeholder="••••••••" disabled aria-disabled="true" />
          </label>
          <button type="submit" className="secondary-action" disabled aria-disabled="true">
            Sign in
          </button>
          <div className="login-links">
            <button type="button" disabled aria-disabled="true">
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
