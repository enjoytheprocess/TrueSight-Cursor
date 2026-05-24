<!-- Generated from 2-build/archive/TEMP_MEASURES.yaml — do not edit directly. Run `make render` to update. -->

# Temporary Measures — Done

_Closed measures. Active measures are in `TEMP_MEASURES.yaml`._


---

### TMP-001 · **V1 showed a login screen with all real auth controls disabled. Users enter via Enter Demo (demo-user). Per-user isolation used X-TrueSight-User header only until removed.
**

| Scope | Status | Introduced On | Owner | Removal Target |
| --- | --- | --- | --- | --- |
|  | `closed` |  | unassigned | Closed 2026-05-24 — BUILD-AUTH-002 |

**Exit trigger:** Dedicated real-auth build task completes: sign-up/login replaces demo entry and header identity (ASP.NET Identity + cookies or JWT — mechanism chosen at auth task admission).
  
**Linked tasks:** BUILD-AUTH-001, BUILD-AUTH-002, BUILD-INV-001, BUILD-REC-001, BUILD-SES-001
