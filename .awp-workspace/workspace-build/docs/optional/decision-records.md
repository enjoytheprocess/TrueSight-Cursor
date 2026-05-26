# Decision Records

**Trigger**: Add this module when an architecture, contract, ownership, or rollout decision needs a durable record. Use it for decisions with significant consequences — ones that will be hard to reverse or that future contributors need to understand to avoid re-litigating.

## Files

| File | Role |
|------|------|
| `1-design/decisions/` | One Markdown file per decision; no prescribed naming — use a short slug (e.g. `auth-token-storage.md`) |

## How it works

Each decision record answers four questions:
1. **What was decided?** — the specific technical or architectural choice
2. **Why?** — the constraints, tradeoffs, and context that drove the decision
3. **What alternatives were rejected?** — and why
4. **What are the consequences?** — including known risks or follow-up obligations

Decision records are written by humans; agents may draft them for review but must not finalize records unilaterally. Once written, a record is append-only — if a decision is reversed, add a new record referencing the old one rather than editing it.

## Connection to the loop

Reference relevant decision records in the `decision_links` field of `TASK_READINESS.yaml` and in the matching `WORK_QUEUE.yaml` entry at admission. Agents read these links at Build start to understand binding constraints before implementing. A decision record is not a design spec — it documents the why, not the what.
