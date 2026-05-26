# Temporary Measures

**Trigger**: Add this module when a temporary exception or tactical workaround needs a tracked removal target — for example: a skipped validation rule, a hardcoded value, a feature flag with a known expiry, or a dependency pinned to a known-bad version pending an upstream fix.

## Files

| File | Role |
|------|------|
| `2-build/TEMP_MEASURES.yaml` | Active measures (open / removal_in_progress) |
| `2-build/archive/TEMP_MEASURES.yaml` | Closed measures |

## How it works

Every temporary measure requires three things:
1. **Owner** — a named person or role responsible for removal
2. **Exit trigger** — the condition that makes removal appropriate (a date, an upstream release, a task completion)
3. **Removal target** — a date or a linked task ID

Measures with `status: removal_in_progress` stay in the active file until removal is confirmed. Once removed, set `status: closed` in the same Sync cycle and move the entry to the archive file.

`linked_tasks` records which tasks created, depend on, or will remove the measure — this is the primary way to surface a temp measure during Build when the relevant task is in progress.

## Connection to the loop

At Build start: check for temp measures linked to the current task. If a measure's exit trigger has been met, record its removal as part of the implementation and set it to `removal_in_progress`. Sync confirms closure after Verify accepts the task.
