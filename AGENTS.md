# AGENTS

Runtime instructions for AI agents in the TrueSight monorepo.

## Cursor

Cursor loads **`.cursor/rules/awp.mdc`** (`alwaysApply: true`) so every agent session is directed to read AWP registers under `.awp-workspace/`. Register YAML edits use **`.cursor/rules/awp-registers.mdc`**.

## Layout

- **Design documentation:** `docs/` — product vision, feature specs, ADRs (`@docs/` in Cursor).
- **Planning workspace (AWP):** `.awp-workspace/` — execution registers (queue, readiness, traceability). Edit `.yaml`; hooks run `make awp-render`.
- **Backend component:** `backend/` — ASP.NET Core API. Read `backend/AGENTS.md` before code changes.
- **Cursor:** `.cursor/rules/awp*.mdc`, `.cursor/hooks.json`, snippets under `.cursor/snippets/` (`awp-*`, `git-commit`, `git-pr`).

## Default read order

1. Active task: `.awp-workspace/2-build/WORK_QUEUE.yaml` (+ `TASK_READINESS.yaml`).
2. Task `spec_link` under `docs/` (e.g. `docs/product/project-brief.md`, `docs/design/features/`).
3. `backend/AGENTS.md` when implementing.

## Commands

From repo root:

```bash
make awp-render
make awp-docs-check
make awp-workflow-status
make awp-install-hooks   # pre-commit: render + docs-check
```

Equivalent from `.awp-workspace/`: `make init`, `make render`, `make docs-check`, `make workflow-status`.

## Token and model tier

Use the **lowest model tier that fits the task**. Reserve high-reasoning models for ambiguity, cross-cutting design, and hard defects. Prefer **separate Cursor chats per AWP phase** (Design / Build / Verify / Sync) so phase rules and context stay narrow.

### Default tiers

| Tier | Use for |
|------|---------|
| **Low** | Git commit message and staging; PR title/body from branch diff; AWP Sync (archive moves, G&D triage); mechanical Verify (FM → G&D, status → `awaiting_human_review`); register YAML from snippets; lint/format; narrow “where is X?” search |
| **Medium** | Routine Build in one vertical slice; mechanical Verify with light code skim; CI log triage; tests mirroring existing patterns |
| **High** | New feature specs and ADRs; IRG/admission and blocking-unknowns judgment; cross-cutting architecture; security/auth; merge conflicts; deep Verify (spec vs implementation); non-obvious bugs |

### Never use an LLM for

- `make awp-render`, `make awp-docs-check`, `make awp-workflow-status` — run in terminal; hooks and pre-commit handle register renders
- Re-reading full `docs/product/` or archive registers when the active task row + `spec_link` suffice

### Context discipline

1. **Session start:** active `WORK_QUEUE` row + matching `TASK_READINESS` row + task `spec_link` (+ component `AGENTS.md` when coding).
2. **@ mentions:** prefer `@docs/design/features/FEAT-….md` and linked ADRs over whole `docs/` trees.
3. **History:** read `.awp-workspace/**/archive/` only when the task explicitly requires it.
4. **Exploration:** prefer grep or readonly explore over loading large subtrees into a high-tier chat.

### AWP phase → tier

| Phase | Typical tier |
|-------|----------------|
| Sync | Low |
| Verify (checklist, YAML, archives) | Low |
| Verify (spec vs code, drift) | High |
| Design (edits, links, readiness fields) | Low |
| Design (new spec, ADR, admission) | High |
| Build (routine slice) | Medium |
| Build (new boundaries, integrations) | High |

### Build loop (multi-task queues)

When several tasks are in `phase: build`, agents run **[docs/design/build-agent-loop.md](docs/design/build-agent-loop.md)**: one task → commit (if requested) → next buildable task → after the queue stalls, re-scan when upstream tasks become **`accepted`**.

### Git and GitHub

- **Commits / PRs:** low tier; `git status`, `git diff`, and `git log -5` only — no codebase exploration unless the user asks.
- For commit/PR-only work, use snippets `.cursor/snippets/git-commit.md` and `.cursor/snippets/git-pr.md`, or paste your own one-line change summary to avoid style archaeology.
- **Merge conflicts / security review:** high tier.

### Subagents and automation

| Tool | Tier |
|------|------|
| `shell` (tests, make, git) | Low / no extended reasoning |
| `explore` (find files, readonly) | Low |
| `generalPurpose` / background agent | Medium–High; scope to one `WORK_QUEUE` task |

### Human gates (save tokens and mistakes)

After Build/Verify, produce **evidence** (files touched, commands run) and move to `awaiting_human_review`. Do not re-audit the whole spec after the human acceptance gate unless asked.
