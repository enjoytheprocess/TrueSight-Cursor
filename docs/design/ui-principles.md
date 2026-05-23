# UI principles (inventory and recipes)

Cross-cutting UX guidance for the **mobile-first web** client. Feature-specific acceptance criteria remain in each `FEAT-*.md`.

## Platform

- Same core flows on **phone and desktop** (responsive layout, touch-friendly targets on small screens).
- Camera capture for V2 uses standard web APIs ([ADR-20260523-01](../decisions/ADR-20260523-01-delivery-model-pwa-web.md)).

## Inventory list and detail

Each inventory row or card should surface, at a glance:

| Element | Requirement |
|---------|-------------|
| **Image** | Clean product/ingredient imagery where available (catalog or user photo); consistent aspect ratio; placeholder when missing |
| **Quantity** | Numeric amount + unit (e.g. `2 cups`, `500 g`) |
| **Expiry** | Expiry date prominent; visual emphasis when within a “soon” window (exact thresholds TBD with [IDEA-006](../product/ideation.md#idea-006-expiry-proximity-warnings)) |

Avoid clutter: name, quantity, and expiry are primary; secondary metadata collapsed or on detail view.

## Recipe suggestions and detail

| Element | Requirement |
|---------|-------------|
| **Image** | Recipe hero image from provider when available |
| **Match** | Clear signal: uses what you have vs missing ingredients (count or chips) |
| **Time** | Estimated cook time visible for “tired” use case |
| **Macros** | Show nutrition/macros when the recipe provider supplies them (optional row; hide if unavailable) |

Primary action: **Use this recipe** → triggers acceptance/deduction flow ([FEAT-SES-001](features/FEAT-SES-001-recipe-acceptance-deduction.md)).

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
