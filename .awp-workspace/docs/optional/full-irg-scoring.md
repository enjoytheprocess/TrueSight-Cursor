# IRG Scoring

The Implementation Readiness Gate is always present — it is the check that prevents Build from starting on a task that isn't ready. What varies is how formally you apply it.

## Default mode: qualitative check

At low process depth, the IRG is a two-question mental check:

1. **Do I know what done looks like?** — Are acceptance criteria clear enough that I'll recognize a passing implementation when I see it?
2. **Do I know what I'm building against?** — Are the interfaces and contracts clear enough to implement without inventing assumptions?

If both answers are yes, set `readiness: ready_for_build` in `TASK_READINESS.yaml` and record the reasoning briefly in `notes`. If either answer is no, stay at `needs_detail` and record the blocking question in `blocking_unknowns`.

No S/A/I/R/V scores are needed in this mode. The `irg:` block can be left empty or omitted entirely.

## Full mode: numeric rubric

**Trigger**: upgrade to full scoring when the qualitative check is no longer precise enough — typically when multiple tasks are in flight simultaneously, when a second reviewer needs to evaluate readiness, or when design disagreements make a shared scoring rubric necessary.

Five dimensions, each 0–2:

| Dim | Meaning |
|-----|---------|
| `S` | Scope and outcome clarity |
| `A` | Acceptance criteria |
| `I` | Interfaces and contracts |
| `R` | Dependencies and risks |
| `V` | Verification plan |

**Pass criteria**: total ≥ 8, with A = 2 and I = 2 required. Recorded in the `irg:` block of `TASK_READINESS.yaml`.

A and I are hard minimums because they are the two failures that cause wasted build work: unknown acceptance criteria mean you can't tell when you're done; unclear interfaces mean you will implement against assumptions that break at integration. Other dimensions at 1 are known unknowns — survivable and recoverable in the next loop.

When the gate passes, set `readiness: ready_for_build` and copy `spec_link`, `advisor_track`, `advisor_status`, `quality_requirements`, and `decision_links` into the corresponding `WORK_QUEUE.yaml` entry. WORK_QUEUE is then the authoritative source for these fields during Build and Verify — do not re-open TASK_READINESS for them.

## File

`1-design/TASK_READINESS.yaml` — used in both modes. The difference is whether the `irg:` block is filled with numeric scores or left as a qualitative note.

See `docs/optional/consistency-gates.md` for the full pass criteria enforced by `make docs-check`.
