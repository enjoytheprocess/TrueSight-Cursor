# Task Dependencies

**Trigger**: Add this module when upstream/downstream relationships between tasks need explicit tracking beyond what queue ordering alone can express — typically when one task's output is a required input for another, or when a design-level learning from one task must feed back into Design before another can begin.

## Files

| File | Role |
|------|------|
| `2-build/TASK_DEPENDENCIES.yaml` | Dependency map; every WORK_QUEUE task has a corresponding entry |
| `2-build/TASK_DEPENDENCIES.md` | Generated view (do not edit directly; `make render`) |

## How it works

Two dependency types with distinct semantics:

| Type | Meaning | Unblock condition |
|------|---------|-------------------|
| `build_depends_on` | Downstream only needs the upstream implementation output to exist | Upstream task reaches `done` |
| `design_depends_on` | Downstream must wait for verified upstream learning and a Design refresh | Upstream task completes Verify + Sync, and Design updates the spec before re-admitting the downstream task |

`unblocks` is the inverse — it lists tasks that become executable once this task's dependency is resolved.

Every task in `WORK_QUEUE.yaml` must have a corresponding entry in this file. New tasks added at admission get a row with `build_depends_on: none` and `design_depends_on: none` until dependencies are known.

## Connection to the loop

At Build start: check `design_depends_on` for the current task. If any listed task has not yet completed Sync and the spec has not been refreshed, the task is not safe to build — raise a G&D gap entry and return the task to `needs_detail` in TASK_READINESS.
