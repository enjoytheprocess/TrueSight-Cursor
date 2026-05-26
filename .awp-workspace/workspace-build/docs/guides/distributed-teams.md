# Distributed Teams

This guide covers how to run the workspace workflow across multiple people working in **separate branches** that merge periodically. It is human-facing — AI agents operate within a single workspace instance and do not need to know about split/merge coordination.

> **Working in the same branch?** If your team shares a single branch and needs to coordinate concurrent writes to registers, see `docs/optional/concurrency-overlay.md` instead. That overlay handles real-time file lock discipline. This guide handles the split/merge lifecycle — the two are complementary, not alternatives.

## Team size tiers

| Size | Design pattern | Build/Verify pattern |
|------|---------------|---------------------|
| Small (2–4) | One person drives, communicates requirements | Split workspaces, merge at Sync |
| Medium (4–8) | Split workspaces, design merge session | Split workspaces, merge at Sync |
| Large (8+) | External coordination tool + template as AI layer | Same |

---

## Split workspace model (small and medium teams)

Each person works on their own branch of the shared workspace. Registers are additive — each person adds rows for their own features or tasks — so git merges are usually clean. Conflicts only arise when two people edit the same row, which the rules below prevent.

### When to split

- **Medium teams:** split at the start of the Design stage; merge before Build starts
- **All teams:** split at the start of the Build stage; merge at Sync

### How to split

Each person creates a branch off the current shared workspace:

```bash
git checkout -b workspace/<your-name>
```

Work on that branch. Do not merge or rebase during the split phase — the merge happens at the ceremony.

### Rules during a split

1. Work only on features or tasks you own. Do not edit rows owned by someone else.
2. Build does not start until after the design merge. Do not begin implementing a feature while designs are still being reconciled.
3. If you discover a dependency on another person's work, note it as a gap in `3-verify/GAPS_AND_DEVIATIONS.yaml` and defer it to the merge session — do not resolve it unilaterally.
4. Keep lock scopes narrow if you need to edit shared files. See `docs/optional/concurrency-overlay.md`.

---

## Design merge ceremony (medium teams)

This is a structured meeting, not just a git merge. Run it before anyone starts Build.

**Steps:**

1. Each person opens a PR from their `workspace/<name>` branch to the shared branch.
2. Review each person's design entries together. Resolve conflicts at the feature level: incompatible assumptions, overlapping scope, missing interfaces.
3. Agree on shared interface contracts (API shapes, data models, shared state). If any exist, instantiate `1-design/CONTRACTS.yaml` from its template and populate it before closing the meeting. See `docs/optional/contracts.md`.
4. Run the IRG gate on each feature. Features that pass are admitted to Build; features that fail return to Design on the next cycle.
5. Merge all branches into the shared branch. One person drives the merge; others are present to resolve conflicts immediately.
6. Assign tasks from admitted features. Each person claims tasks and branches again for Build/Verify.

**One person drives the merge.** Others should be present or on standby. Do not do this async — register conflicts need immediate human judgment.

---

## Build/Verify split

After the design merge, each person branches again for their assigned tasks:

```bash
git checkout -b workspace/<your-name>
```

During the Build/Verify loop:
- Each person runs their own Build↔Verify loop on their assigned tasks only.
- Cross-cutting findings (things that affect another person's task) go into `3-verify/GAPS_AND_DEVIATIONS.yaml` as deferred findings. Do not block your own loop waiting for resolution.
- Do not edit another person's task rows in `WORK_QUEUE.md`.

### Deferred finding convention

When your agent encounters a cross-cutting issue — an interface assumption, a conflict with another person's task, a dependency that wasn't in the design — record it in `3-verify/GAPS_AND_DEVIATIONS.yaml` with these fields:

```yaml
- id: GAP-XXX
  type: gap          # or deviation
  description: "Assumed JWT auth format — conflicts with session cookie approach in TASK-02"
  deferred_to_merge: true
  affects_tasks:
    - TASK-02        # the other person's task ID
  status: open
```

The `deferred_to_merge: true` flag tells the merge ceremony to surface this entry for human triage. Without it, cross-cutting findings look identical to local findings and get missed.

If `1-design/CONTRACTS.yaml` exists, check it before assuming. If the relevant contract is `draft` or missing, that itself is the deferred finding to record.

---

## Sync merge ceremony

This is the recombination point. Run it when all Build/Verify loops are complete or at a natural checkpoint.

**Steps:**

1. Each person opens a PR from their `workspace/<name>` branch to the shared branch.
2. Review all deferred cross-cutting findings together. Triage each one: close now (update design docs) or carry forward to the next Design cycle.
3. Merge all branches. One person drives.
4. One person runs Sync on the merged workspace: reconcile design vs. implementation, archive resolved gaps, update `4-sync/DESIGN_INPUTS.yaml` with anything that needs a Design cycle.

---

## One-person-drives-design (small teams)

When one person owns the Design stage:
- That person runs Design solo, generates tasks, and assigns them.
- Others branch for Build/Verify as above.
- No design merge ceremony is needed — the design is already reconciled before tasks are assigned.
- Sync still benefits from one person driving, but others can contribute deferred findings.

This is the closest to the template's native single-loop model and requires the least coordination overhead.

---

## Large teams: external tool integration

For teams large enough to have dedicated coordination tooling (GitHub Issues, Linear, Jira):
- Use the external tool for task assignment, status tracking, and cross-team dependencies.
- Use the template for IRG gating, design traceability, and AI agent read paths.
- Map external task IDs into `WORK_QUEUE.md` `Notes` (e.g. `external_id: LIN-42`) so agents can cross-reference.
- Sync stage remains in the template; the external tool handles human standup and status.

The template does not need to replicate what the external tool does well. Use it for what it does that the external tool does not: structured design-to-build traceability and AI agent orchestration.
