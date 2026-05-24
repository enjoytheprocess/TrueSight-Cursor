# FEAT-AUTH-001: Demo login screen (temporary)

**Status:** ready  
**Module:** Profile / Identity  
**Related AWP feature_id:** `FEAT-AUTH-001`

## Summary

Add a **login screen** as a temporary V1 UX measure ([TMP-001](../../.awp-workspace/2-build/TEMP_MEASURES.yaml)). The screen shows a conventional sign-in layout with all real auth controls **disabled**. A prominent **Enter Demo** action above the form lets users enter the app as the shared demo user (`demo-user`) without sign-up or credentials. Real authentication remains out of scope until TMP-001 is removed.

## User story

As a visitor, I want a clear entry point that looks like a login screen but lets me try the app immediately via **Enter Demo**, so that I can explore inventory and recipes without creating an account.

## Scope

### In scope

- Dedicated **login route/screen** shown when the client has no stored user id ([ADR-20260524-01](../decisions/ADR-20260524-01-v1-interim-identity-header.md), TMP-001).
- **Enter Demo** button placed **above** the normal login form (primary call-to-action).
- **Enter Demo** behavior: persist `demo-user` via existing client identity helpers (`enterDemoUser()` in `frontend/src/api/userId.ts`), then navigate to the main V1 app shell.
- Normal login UI present for layout/preview but **fully non-interactive** (OQ-046):
  - Email and password inputs **disabled**
  - Sign-in / submit button **disabled**
  - Sign-up and forgot-password links **disabled**
  - OAuth provider buttons (e.g. Google, Facebook) **disabled** — visual placeholders only
- After demo entry, main app loads and API calls continue using `X-TrueSight-User: demo-user` (unchanged backend contract).
- Mobile-first responsive layout consistent with [ui-principles.md](../ui-principles.md).

### Out of scope

- Real sign-up, sign-in, password reset, or OAuth ([OQ-001](../../product/open-questions.md) — deferred).
- Backend auth endpoints or ASP.NET Identity.
- Multi-user demo accounts or admin provisioning.
- “Sign out” / switch-user flows (optional follow-on; not required for this task).

## Behavior

1. **Cold start:** If `hasClientUserId()` is false, render the login screen instead of inventory/recipes.
2. **Enter Demo:** User taps **Enter Demo** → `enterDemoUser()` → redirect/render main app.
3. **Disabled login form:** Visible below **Enter Demo**; all inputs and auth actions use `disabled` (and appropriate `aria-disabled` where needed). Helper copy (OQ-045): **“Welcome to the Demo”** above or immediately beside the disabled form.
4. **Return visits:** If a user id exists in `localStorage`, skip the login screen and show the main app (including prior demo-user sessions).
5. **Demo inventory:** On API startup, `DemoInventorySeeder` pre-seeds `demo-user` with representative stock when that user's inventory is empty (so Enter Demo can exercise recipes immediately).

## UI layout (wireframe)

```
┌─────────────────────────────┐
│         TrueSight           │
│                             │
│   [ Enter Demo ]  ← primary │
│   Welcome to the Demo       │
│                             │
│   Email    [ disabled    ]  │
│   Password [ disabled    ]  │
│   [ Sign in ]  disabled     │
│   Sign up · Forgot password │
│        (disabled links)       │
│   [ Google ] [ Facebook ]   │
│        (disabled OAuth)     │
└─────────────────────────────┘
```

## API / contracts

No new API surface. Client continues to send `X-TrueSight-User` per [ADR-20260524-01](../decisions/ADR-20260524-01-v1-interim-identity-header.md).

## Data model

- Client only: `localStorage` key `truesight-user-id` (existing).
- Migrations needed: **N**

## Acceptance criteria

- [x] Login screen renders on first visit (no stored user id).
- [x] **Enter Demo** is visually above the standard login form and is the only enabled auth-related control.
- [x] All other login inputs, buttons, and links are disabled and non-submittable.
- [x] **Enter Demo** sets `demo-user` and navigates to the main V1 app; inventory/recipe API calls succeed.
- [x] Repeat visit with stored id skips the login screen.
- [x] Layout usable on mobile and desktop viewports.

## Decisions (resolved)

| ID | Decision |
|----|----------|
| [OQ-045](../../product/open-questions.md) | Helper copy: **“Welcome to the Demo”** |
| [OQ-046](../../product/open-questions.md) | Full login mock: email/password, disabled sign-up/forgot links, disabled OAuth buttons; **Enter Demo** only enabled action |

## Traceability (AWP)

- Temporary measure: **TMP-001** (`.awp-workspace/2-build/TEMP_MEASURES.yaml`)
- Build task: **BUILD-AUTH-001** (design phase — not yet admitted to build)
- Decision: [ADR-20260524-01](../decisions/ADR-20260524-01-v1-interim-identity-header.md)

After design approval, update:

- `.awp-workspace/1-design/FEATURE_REGISTRY.yaml`
- `.awp-workspace/1-design/DESIGN_STATES.yaml`
- `.awp-workspace/3-verify/TRACEABILITY_MATRIX.yaml`
- `.awp-workspace/2-build/WORK_QUEUE.yaml`
