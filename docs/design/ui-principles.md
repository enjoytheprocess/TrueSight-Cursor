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

## V2 confirmation (fridge photo)

After vision proposes items, show **confidence** and let the user toggle each line before save — never auto-add low-confidence items without review.

Example pattern:

```
AI found:
  [✓] Eggs      (high)
  [✓] Milk      (medium)
  [ ] Lettuce   (low)

[Confirm selection]
```

See [FEAT-REC-002](features/FEAT-REC-002-fridge-photo-recognition.md).

## Accessibility and trust

- Destructive actions (delete item, discard detections) require confirmation.
- Errors from external APIs: user-visible message, no silent empty states without explanation.

## Related

- [Use cases](../product/use-cases.md)
- [User stories](../product/user-stories.md)
