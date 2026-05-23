# Concurrency Overlay

Optional coordination overlay for workspaces that need concurrent design/build/verify activity or multiple humans and agents working **within the same branch** at the same time.

Do not adopt this by default.
Use it only when the default single-owner, low-coordination path is no longer enough.

> **Working in separate branches?** If your team splits into personal workspace branches and merges periodically, see `docs/guides/distributed-teams.md` instead. That guide covers the split/merge lifecycle. This overlay handles real-time write coordination within a shared branch — the two are complementary, not alternatives.

## When to opt in
- design continues while admitted build or verify work is still active
- more than one human or agent is editing concurrently
- ownership is changing frequently across a task's lifecycle
- shared contracts or cross-cutting files make accidental overlap likely

## Design goal
Keep the core workflow unchanged.
Hook into existing optional registers instead of expanding the default queue schema.

Primary artifacts:
- `2-build/LOCKS.md`
- `4-sync/HANDOFFS.md`

## Activation rules
1. Keep one active owner per queue row in `2-build/WORK_QUEUE.md`.
2. Split concurrent work into separate task rows when practical.
3. Mark concurrent tasks with `Mode = parallel`.
4. Claim narrow lock scopes in `2-build/LOCKS.md` before editing shared files or directories.
5. Record owner or lifecycle transfers in `4-sync/HANDOFFS.md`.
6. If design moves during execution, record the gap or deviation in `3-verify/GAPS_AND_DEVIATIONS.yaml` and list affected task IDs in the entry.
7. If docs, code, or tests stop matching intended behavior, set `drift_status: drift_detected` in `3-verify/TRACEABILITY_MATRIX.yaml`, create a matching entry in `3-verify/GAPS_AND_DEVIATIONS.yaml`, and block or return affected tasks to design as needed.

## Lightweight note conventions
To avoid adding more mandatory columns, use short structured tokens in `2-build/WORK_QUEUE.md` `Notes` only while this overlay is active.

Suggested tokens:
- `baseline:<id>` for the design baseline a task is building against
- `review_owner:<human:name>` for the expected human reviewer
- `next_owner:<human:name|agent:name>` for the next handoff target
- `scope:<path-or-contract>` for the active lock or edit surface when it helps readability

Example:
`baseline:DESIGN-2026-04-02-A; review_owner:human:alex; next_owner:agent:verify-bot`

## Rebaseline rule
When design changes after a task was admitted to build:

1. Keep unaffected tasks moving.
2. For affected tasks, choose one path explicitly:
- continue on the old baseline with a note in `WORK_QUEUE.md`
- pause and move the task to `blocked`
- move the task back to `design`
3. Do not let affected work proceed silently on an outdated assumption set.

## Exit rules
Stop using the overlay when the burst of concurrency is over:
- release active locks
- close completed handoffs
- ensure all open GAPS_AND_DEVIATIONS entries have been triaged through Sync
- remove stale coordination tokens from queue notes when they are no longer useful

Then return to the normal workflow without any extra coordination overhead.
