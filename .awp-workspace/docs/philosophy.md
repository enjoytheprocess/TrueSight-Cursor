# Philosophy

This template exists because AI agents have a fundamental asymmetry: they are fast at implementing things but have no inherent resistance to implementing the wrong thing. Without explicit structure, they fill ambiguity with decisions — silently — and leave no record.

## The core problem

An unstructured AI-assisted workflow has three failure modes:

1. **Directional drift** — the agent implements what sounds plausible rather than what was specified, because the specification never made the boundary explicit.
2. **Silent design calls** — when the spec doesn't answer something, the agent decides and moves on, turning a design question into an implementation fact with no record.
3. **Compounding deviation** — once the first silent decision is made, subsequent decisions layer on top of it, making the divergence from the intended design increasingly expensive to unwind.

## The three non-negotiables

Three things are present at every scale of process depth:

**1. An explicit readiness gate (IRG)**
Before anything moves to Build, there is always a check: is the design clear enough to implement correctly? At low process depth this is a qualitative judgment. At higher depth it becomes a numeric rubric on five dimensions (Scope, Acceptance criteria, Interfaces, Reviewability, Verifiability). Total ≥ 8, with A=2 and I=2 required. The gate enforces "design before build" structurally, not just as a norm.

**2. Gap and deviation records**
Nothing discovered during Build or Verify is silently discarded. Gaps (things the design never answered) and deviations (design calls made under pressure to keep moving) are recorded explicitly and triaged at Sync — closed by updating the design now, or carried into the next Design cycle. A covered deviation is still a silent design change that needs ratification; only the resolution speed differs.

**3. The Build ↔ Verify rework cycle**
Verify asks: "Is the current task resolved satisfactorily?" — not just "do tests pass?" It collects everything Build and Verify surface together. If gaps accumulate to the point where continuing is dangerous, the correct move is to stop and fail quickly rather than compound the deviation record.

Below this floor, you have a different tool.

## Additive complexity

The template is designed to work at any scale without requiring an upfront commitment to process overhead. Every project runs the same core loop. Everything beyond the core — task queues, specialist tracks, locks, traceability matrices, concurrency overlays — is a module you enable when the problem makes it necessary.

The trigger for adding a module is always a real gap in the workflow, not a plan made upfront. There is no migration when you add a module: create the file, start using it.

See `docs/optional/tiered-adoption.md` for the module tech tree and adoption progression.
