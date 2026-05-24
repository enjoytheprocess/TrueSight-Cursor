# UI principles (inventory and recipes)

Cross-cutting UX guidance for the **mobile-first web** client. Feature-specific acceptance criteria remain in each `FEAT-*.md`.

## Platform

- Same core flows on **phone and desktop** (responsive layout, touch-friendly targets on small screens).
- Camera capture for V2 uses standard web APIs ([ADR-20260523-01](../decisions/ADR-20260523-01-delivery-model-pwa-web.md)).

## Main shell (V1.1)

Per [FEAT-SHP-001](features/FEAT-SHP-001-shopping-list-and-main-shell.md):

| Area | Pattern |
|------|---------|
| **Tabs** | **In Stock** \| **Shopping List** |
| **Layout** | Single column: add form → item list → recipe **pager** (not a side-by-side grid) |
| **In Stock** | Add includes expiry; rows have **Delete** |
| **Shopping List** | Add without expiry; rows have **Move to In Stock** (+ optional expiry at move); secondary delete |
| **Recipes** | One card at a time; previous/next and position indicator |

Do not add a third tab or third panel for recipes.

## Inventory list and detail

Each inventory row or card should surface, at a glance:

| Element | Requirement |
|---------|-------------|
| **Image** | Clean product/ingredient imagery where available (catalog or user photo); consistent aspect ratio; placeholder when missing |
| **Quantity** | Numeric amount + unit (e.g. `2 cups`, `500 g`) |
| **Expiry** | Expiry date prominent; visual emphasis when within **3 days** of expiry ([OQ-040](../product/open-questions.md), [IDEA-006](../product/ideation.md#idea-006-expiry-proximity-warnings)) |

Avoid clutter: name, quantity, and expiry are primary; secondary metadata collapsed or on detail view.

## Recipe suggestions and detail

| Element | Requirement |
|---------|-------------|
| **Image** | Recipe hero image from provider when available |
| **Servings** | Adjustable control above ingredient table; required amounts scale with selection |
| **Ingredient table** | Columns: Ingredient, Required amount, Amount in stock; short rows in red |
| **Ready / cook** | **Ready** and **Cook and deduct** only when **all** ingredients are sufficient for current servings ([FEAT-REC-001](features/FEAT-REC-001-recipe-suggestions.md)) |
| **Time** | Estimated cook time visible for “tired” use case |
| **Macros** | Show nutrition/macros when the recipe provider supplies them (hide if unavailable) |

Primary action: **Cook and deduct** → acceptance/deduction ([FEAT-SES-001](features/FEAT-SES-001-recipe-acceptance-deduction.md)). Disabled when stock is insufficient; server re-validates on POST.

**Deferred (not V1):** unit conversion between recipe and inventory units; adjusting deduct when the user did not follow the recipe exactly.

## Demo login (V1 interim)

Per [FEAT-AUTH-001](features/FEAT-AUTH-001-demo-login-screen.md) and TMP-001:

- **Enter Demo** is the only enabled auth control; placed above the disabled login form.
- Helper copy: **“Welcome to the Demo”** near the disabled fields.
- Email, password, sign-up/forgot links, and OAuth buttons are visible but **disabled** (layout preview only).

## V2 fridge photo — entry and mockup

Per [FEAT-REC-002](features/FEAT-REC-002-fridge-photo-recognition.md). **First delivery:** UI mockup with preset photo and stub detections; **later:** live camera + server vision.

### Entry (add-item section)

| Element | Rule |
|---------|------|
| **Camera control** | Icon button immediately **beside** the primary **Add** button (same row; Add grows, camera fixed ~44px) |
| **Manual add** | Unchanged — camera is additive, not a replacement |
| **Mockup signal** | Visible **Demo** badge on the camera control; `aria-label` explains sample image / not a real scan |
| **Production** | Remove Demo badge and demo copy when live vision ships |

### Mockup labeling (required until real vision)

Honest labeling like the demo login screen — users must know the scan is simulated while **Save** still writes real inventory.

| Where | Copy / pattern |
|-------|----------------|
| Camera button | **Demo** badge + tooltip “Try fridge photo demo (sample image)” |
| Overlay (all steps) | Persistent info banner: **“Demo — sample photo & suggested items, not real AI yet.”** |
| Camera step | **Use sample photo** (not “Capture”); helper: fixed sample image |
| Scanning | **“Scanning sample photo…”** |
| Review | Heading **“Suggested items (demo)”** |

Full table: [FEAT-REC-002 § Mockup labeling](features/FEAT-REC-002-fridge-photo-recognition.md#mockup-labeling).

### Camera → review flow (mockup)

1. **Preset photo** screen with demo banner (bundled image; **Use sample photo**).
2. **Scanning** feedback (short; “sample photo” wording).
3. **Review** list — same quantity / unit / expiry controls as manual add; demo heading + banner.

### Confirmation (mockup and production)

After vision (or stub) proposes items, show **confidence** and let the user toggle each line before save — never auto-add low-confidence items without review.

Example pattern (mockup — use **“Suggested items (demo)”** as heading, not “AI found”):

```
[Demo banner: sample photo & suggested items, not real AI yet]

Suggested items (demo)
  [✓] Eggs      (high)     qty · unit · expiry
  [✓] Milk      (medium)   …
  [ ] Lettuce   (low)      …

[Save to inventory]  [Cancel]
```

Low-confidence lines default **unchecked**. Primary action: **Save to inventory** (not “Confirm” alone — makes persistence explicit).

**Save rules (mockup):** Disable **Save** when no rows are checked, when any included quantity is &lt; 1, or while requests are in flight. **All-or-nothing** — dismiss overlay only after every included `POST` succeeds; on failure, keep the review screen (no partial dismiss).

## Accessibility and trust

- Destructive actions (delete item, discard detections) require confirmation.
- Errors from external APIs: user-visible message, no silent empty states without explanation.

## Related

- [Use cases](../product/use-cases.md)
- [User stories](../product/user-stories.md)
