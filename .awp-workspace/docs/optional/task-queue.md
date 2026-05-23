# Task Queue

**Trigger**: Add this module when more than one task is in flight, or when sessions are frequently interrupted and you need a persistent record of what is in progress and what is next.

## Files

| File | Role |
|------|------|
| `2-build/WORK_QUEUE.yaml` | Active tasks — todo through accepted |
| `2-build/archive/WORK_QUEUE.yaml` | Completed tasks (done) |

## How it works

Tasks enter the queue at `status: todo` when admitted from Design (IRG gate passed). Each entry holds an admission-time snapshot of the task's spec link, advisor track, quality requirements, and decision links — so Design can keep editing `TASK_READINESS.yaml` without causing drift in an active build loop.

**Status path**:
```
todo → in_progress → awaiting_human_review → accepted → done
```

- `in_progress`: agent has claimed the task
- `awaiting_human_review`: implementation is complete; human makes the accept/reject decision via `3-verify/acceptance-gate.md`
- `needs_rework`: rejection revealed a design-level problem; task returns to Design after Sync
- `blocked`: fail-quickly path — gaps make continuing dangerous; abbreviated Verify+Sync runs immediately
- `done`: Sync updates are complete; move entry to archive

At Build start, check for `needs_rework` tasks before pulling new work.

## Connection to the loop

The queue is the primary Build input. Agents pull from it, not from a manual task summary. Sync moves `done` entries to `2-build/archive/WORK_QUEUE.yaml` and their TASK_READINESS rows to `1-design/archive/TASK_READINESS.yaml`.
