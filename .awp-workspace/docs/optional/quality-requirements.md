# Quality Requirements

**Trigger**: Add this module when nonfunctional or cross-cutting standards need per-task enforcement — for example: response-time budgets, coverage floors, data retention rules, or security baselines that apply to every task touching a specific area.

## Files

| File | Role |
|------|------|
| `1-design/QUALITY_REQUIREMENTS.yaml` | Active requirements |
| `1-design/archive/QUALITY_REQUIREMENTS.yaml` | Terminal entries (satisfied / superseded / dropped) |

## How it works

Three enforcement modes:

| Mode | Meaning |
|------|---------|
| `sustained` | Permanent standard; applies to all tasks implicitly. Agents read the full `sustained` list at Build start — no explicit task link needed. |
| `per_task` | Applies each time a task of the relevant type occurs. Linked via `quality_requirements` in `TASK_READINESS.yaml`. |
| `milestone` | Must be satisfied before a specific event or deployment gate. Linked in the milestone task's TASK_READINESS entry. |

Each requirement must have an owner and a clear criterion for what "satisfied" looks like. `deferred` requirements stay in the active file — they still need follow-up; record the linked task or temp measure ID in `notes`.

Terminal dispositions (`satisfied`, `superseded`, `dropped`) move to the archive file.

## Connection to the loop

At Build start: read all `sustained` requirements — they apply implicitly to the current task. For tasks with `quality_requirements` links in their WORK_QUEUE entry, open `QUALITY_REQUIREMENTS.yaml` and verify each linked `per_task` or `milestone` requirement is addressed in both the implementation and the validation plan.
