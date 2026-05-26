# Release Queue

**Trigger**: Add this module when completed build work feeds a deployment pipeline and release candidates need explicit tracking. This is most useful when the project uses workspace-deployment or a similar tool that reads candidate entries to scope a deployment brief.

## Files

| File | Role |
|------|------|
| `4-sync/RELEASE_QUEUE.yaml` | Active release candidates and released entries |
| `4-sync/archive/RELEASE_QUEUE.yaml` | Abandoned entries |

## How it works

Sync creates a `release_state: candidate` entry when completed work is approved to ship. Each entry includes:
- `release_type` — `feature` | `bugfix` | `performance` | `architecture` | `mixed`
- `task_ids` — the tasks included in this release
- `capability_ids` — relevant capability IDs (empty for non-feature releases)
- `components` — list of `{name, version}` pairs; workspace-deployment reads these to fill `scope[].ref` in the deployment brief
- `target_date`

Release candidates are not constrained to capability or milestone boundaries — a release can include any combination of completed tasks. Use `release_type` to distinguish the nature of the work.

**State transitions**:
- `candidate` → `released` — after deployment is confirmed; update the entry in the same Sync cycle as the deployment
- `candidate` → `abandoned` — candidate withdrawn before deployment; move entry to archive

`make populate` (workspace-deployment) reads `candidate` entries from this file to auto-fill the deployment brief.

## Connection to the loop

The release queue is written at Sync, after G&D triage is complete. A task must reach `done` (Sync complete) before it is eligible for a candidate entry. Sync also updates `ROADMAP.yaml` capabilities to `completed` in the same pass.
