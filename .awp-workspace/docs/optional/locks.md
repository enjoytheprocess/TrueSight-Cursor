# Locks

**Trigger**: Add this module when multiple agents or contributors are building in parallel on the same set of files. Without locks, concurrent writes to shared registers (WORK_QUEUE, DESIGN_STATES, spec files) produce conflicts that are expensive to resolve.

## Files

| File | Role |
|------|------|
| `2-build/LOCKS.yaml` | Active and released lock records |
| `2-build/LOCKS.md` | Generated view (do not edit directly; `make render`) |

## How it works

The discipline is simple: **claim before editing, release immediately after merge or handoff.**

Each lock entry carries:
- `status` — `active` | `released`
- The file or set of files being locked
- The task ID and owner holding the lock
- Timestamps for claim and release

When a task goes `in_progress` in WORK_QUEUE, record the matching lock ID in the WORK_QUEUE entry. Release the lock when the task moves to `awaiting_human_review` or is handed off.

Do not hold locks across sessions or during blocked/rework periods — release them and re-claim when work resumes.

## Connection to the loop

Locks are a Build-stage coordination tool. They do not replace Sync triage — they only prevent the write conflicts that make triage harder. For higher-concurrency projects that need more coordination than locks alone (e.g. parallel Design and Build sessions, or multi-agent execution), see `docs/optional/concurrency-overlay.md`.
