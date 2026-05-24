<!-- Generated from 2-build/TEMP_MEASURES.yaml — do not edit directly. Run `make render` to update. -->

# Temporary Measures

_Active measures. Move closed entries to `archive/TEMP_MEASURES.yaml` during Sync._


---

### TMP-001 · **V1 shows a login screen with all real auth controls disabled. Users enter via Enter Demo (demo-user). Per-user isolation uses X-TrueSight-User header only. Not suitable for production multi-user security until removed.
**

| Scope | Status | Introduced On | Owner | Removal Target |
| --- | --- | --- | --- | --- |
|  | `open` |  | unassigned | Future real-auth task (post BUILD-AUTH-001) — not yet in WORK_QUEUE |

**Exit trigger:** Dedicated real-auth build task completes: sign-up/login replaces demo entry and header identity (ASP.NET Identity + cookies or JWT — mechanism chosen at auth task admission).
  
**Linked tasks:** BUILD-AUTH-001, BUILD-INV-001, BUILD-REC-001, BUILD-SES-001

---

### TMP-002 · **Inventory uses free-text Name + NormalizedName only. IngredientCatalog entity in domain model is not implemented; recipe matching relies on normalized string equality + exact units.
**

| Scope | Status | Introduced On | Owner | Removal Target |
| --- | --- | --- | --- | --- |
|  | `open` |  | unassigned | BUILD-CAT-001 — design queued 2026-05-24 |

**Exit trigger:** IngredientCatalog promoted to V1+ scope: catalog table seeded, inventory links to catalog rows, specs and domain model updated.
  
**Linked tasks:** BUILD-CAT-001, BUILD-INV-001, BUILD-REC-001
