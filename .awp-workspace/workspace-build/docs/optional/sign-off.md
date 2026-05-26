# Sign-Off

**Trigger**: Add this module when a formal per-task acceptance audit trail is required — for example: regulated environments, multi-party projects where explicit human approval must be on record, or any project where "who accepted this and when" needs to be answerable after the fact.

## File

`3-verify/SIGN_OFF.md` — one entry per accepted task, in append-only log format.

## How it works

A sign-off entry is added at Verify after:
1. The Acceptance Gate checklist is complete
2. The human reviewer has made the accept (or conditional accept) decision
3. Any open gaps or deviations are staged in `GAPS_AND_DEVIATIONS.yaml` for Sync

Each entry records:
- **Accepted by** — name or role of the human who made the decision
- **Date**
- **Decision** — `accept` or `conditional_accept`
- **Conditions / notes** — any follow-up obligations or residual risks acknowledged
- **Open items staged for Sync** — G&D entry IDs or "none"

Sign-off records are never edited after the fact. A conditional accept with unresolved conditions remains on record until the conditions are closed by a subsequent sign-off or Sync entry.

## Connection to the loop

If `SIGN_OFF.md` is in use, recording an entry is a required step before setting a task to `accepted` in WORK_QUEUE. Sync does not depend on the sign-off log directly, but reviewers checking the audit trail will read it alongside the DESIGN_INPUTS and archive records.
