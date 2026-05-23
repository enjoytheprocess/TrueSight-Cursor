# AGENTS

> **Response language:** __WORKSPACE_LANGUAGE__ — use this language for all outputs: stage registers, comments, inline notes, and human-facing responses.

AI runtime contract for this initialized __REPO_MODE__ workspace.

## Mode assumptions
- Repository mode: `__REPO_MODE__`
- Adoption path: `direct-use`
- Primary component: `__COMPONENT_NAME__`

## Stage responsibilities
- **Design**: shape what to build; gate on IRG before admitting to Build
- **Build**: implement admitted tasks only
- **Verify**: "Is the current task resolved satisfactorily?" — task scope, implementation quality
- **Sync**: "Does what was built fit what the design says?" — design scope, alignment

## Default read order
Read from `.md` table views; edit the `.yaml` source files.

Registers with terminal statuses use a split-YAML pattern: `REGISTER.yaml` holds active entries; `archive/REGISTER.yaml` holds completed/terminal entries. When an entry reaches its terminal status, move it from the active YAML to the done YAML. Both files render to their own `.md` view via `make render`. Read the active `.yaml` by default; open the done file only when history is needed.

**Starting a Design session:**
1. Read `4-sync/DESIGN_INPUTS.yaml` — address all `open` items before designing anything new; these are gaps and deviations the previous cycle left unresolved.
2. Check `1-design/TASK_READINESS.yaml` for any `needs_detail` rows — tasks returned for more design work before new build admission.
3. Read `1-design/FEATURE_REGISTRY.yaml` for the feature identity list, then `1-design/DESIGN_STATES.yaml` for active design maturity.
4. Read `1-design/ROADMAP.yaml` for current capabilities and coverage.

**Starting a Build session:**
1. Read the active task in `2-build/WORK_QUEUE.yaml` and its matching row in `1-design/TASK_READINESS.yaml` — confirm status, IRG scores, blocking unknowns, and advisor gate.
2. Read the linked rows in `1-design/DESIGN_STATES.yaml` and `3-verify/TRACEABILITY_MATRIX.yaml`.
3. Read the `AGENTS.md` and linked specs for the component named by the task.
4. Open optional registers only when the task uses them:
   - `1-design/QUALITY_REQUIREMENTS.yaml` — when in use: read all `sustained` entries at build start; open for tasks with `quality_requirements` entries in TASK_READINESS to verify each linked `per_task` or `milestone` QR
   - `1-design/decisions/` — when the task or feature has `decision_links` entries
   - `2-build/TASK_DEPENDENCIES.yaml` — when dependency tracking is in use
   - `2-build/LOCKS.yaml` — when running in parallel mode
   - `2-build/TEMP_MEASURES.yaml` — when the task touches an active temporary exception
   - `4-sync/HANDOFFS.md` — when picking up work handed off from another agent/person
   - specialist advisory files — when `Specialist Advisor ≠ none` (see `docs/optional/specialist-tracks.md`)

**Starting a Verify session:**
1. Read the active row in `2-build/WORK_QUEUE.yaml` — check current status and validation field.
2. Read the matching row in `1-design/TASK_READINESS.yaml` — check advisor gate and any blocking unknowns to verify.
3. Read `3-verify/TRACEABILITY_MATRIX.yaml` — check `drift_status` for the linked feature.
4. Read `3-verify/FEEDBACK_MATRIX.yaml` — review existing observations for this task.
5. Read `3-verify/GAPS_AND_DEVIATIONS.yaml` — review what has already been staged.
6. For each open FEEDBACK_MATRIX entry: if it has a `diagnosis` field or its type is `issue`, create a corresponding `GAPS_AND_DEVIATIONS.yaml` entry with `source: human_feedback` and a `source_ref` pointing to the FM entry id. When the entry is resolved, move it to `3-verify/archive/FEEDBACK_MATRIX.yaml`.
7. When promoting or resolving a GAPS_AND_DEVIATIONS entry, move it to `3-verify/archive/GAPS_AND_DEVIATIONS.yaml`.
When evidence is ready, move the task to `awaiting_human_review`. The human uses `3-verify/acceptance-gate.md` to make the accept/reject decision.

**Starting a Sync session:**
1. Read `4-sync/DESIGN_INPUTS.yaml` — review open items before triaging new entries.
2. Read `3-verify/GAPS_AND_DEVIATIONS.yaml` — triage each entry: add to DESIGN_INPUTS (needs Design cycle) or close now (update design docs, mark addressed). Move each triaged entry to `3-verify/archive/GAPS_AND_DEVIATIONS.yaml`.
3. Reconcile `2-build/WORK_QUEUE.yaml`, `1-design/ROADMAP.yaml`, and `3-verify/TRACEABILITY_MATRIX.yaml`. Move any `done` tasks to `2-build/archive/WORK_QUEUE.yaml` and their matching rows in `1-design/TASK_READINESS.yaml` to `1-design/archive/TASK_READINESS.yaml`; move any `completed` or `parked` capabilities to `1-design/archive/ROADMAP.yaml`. For any feature whose tasks are all now in `archive/WORK_QUEUE` and has no open `DESIGN_INPUTS` entries, set `design_state: complete` and move the row from `1-design/DESIGN_STATES.yaml` to `1-design/archive/DESIGN_STATES.yaml`.
4. If DESIGN_INPUTS is growing large, create `4-sync/archive/DESIGN_INPUTS.yaml` from `templates/init/INIT_DESIGN_ARCHIVE_TEMPLATE.yaml` and move `addressed` entries there to keep the live register readable.
5. If `4-sync/RELEASE_QUEUE.yaml` is in use: assess whether completed work is approved to ship; add a `candidate` entry for each release. Move `released` or `abandoned` entries to `4-sync/archive/RELEASE_QUEUE.yaml`. Releases may be feature, bugfix, performance, architecture, or mixed — not constrained to capability boundaries.

## Rules
- Trust uppercase `.yaml` registers as canonical shared state; `.md` views are generated from them.
- After editing any register `.yaml`, run `make render` to regenerate the `.md` table views.
- Keep traceability links repo-relative.
- Prefer component-scoped edits; treat shared docs and contracts as cross-cutting changes.
- Build only when all are true (condensed; authoritative list in `docs/optional/consistency-gates.md`):
  - `Readiness = ready_for_build`, IRG ≥ 8/10 with A=2 and I=2, `Blocking Unknowns = none`
  - linked design state is `ready` (skip when `feature_id: none`)
  - traceability row is not `drift_detected` (skip when `feature_id: none`)
  - `Advisor Gate = approved` when a gate is required
- Record all gaps and deviations in `3-verify/GAPS_AND_DEVIATIONS.yaml` during Build/Verify — including items resolved in-loop.
- Do not skip Sync. GAPS_AND_DEVIATIONS must be triaged before the next Design session.
- Move work to `accepted` only after the Acceptance Gate checklist is complete. If `3-verify/SIGN_OFF.md` is in use, record an entry before closing.
- Open specialist docs only when `Specialist Advisor != none`.
- Run `make docs-check` before handoff.

## Agent-specific setup
- Run `make install-tools` once after `make init` if `yq` is not already available — it is required by `make docs-check` and `make render`.
- If you are a Claude Code agent: copy `templates/agents/claude/CLAUDE_TEMPLATE.md` → `CLAUDE.md` and `templates/agents/claude/settings_TEMPLATE.json` → `.claude/settings.json` once after `make init` if not already done. The settings file includes a Stop hook that runs `make render` automatically. See `docs/core/operations.md` for details.
