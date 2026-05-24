<!-- Generated from 2-build/TEMP_MEASURES.yaml — do not edit directly. Run `make render` to update. -->

# Temporary Measures

_Active measures. Move closed entries to `archive/TEMP_MEASURES.yaml` during Sync._


---

### TMP-002 · **Inventory uses free-text Name + NormalizedName only. IngredientCatalog entity in domain model is not implemented; recipe matching relies on normalized string equality + exact units.
**

| Scope | Status | Introduced On | Owner | Removal Target |
| --- | --- | --- | --- | --- |
|  | `open` |  | unassigned | BUILD-CAT-001 — design queued 2026-05-24 |

**Exit trigger:** IngredientCatalog promoted to V1+ scope: catalog table seeded, inventory links to catalog rows, specs and domain model updated.
  
**Linked tasks:** BUILD-CAT-001, BUILD-INV-001, BUILD-REC-001
