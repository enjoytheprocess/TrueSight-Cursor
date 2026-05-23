# Upgrade Notes

Use this file as the rolling summary for template releases.
Add the newest release notes at the top before packaging a release bundle.

## 2026-05-22
- Added `docs/guides/distributed-teams.md`: guide covering split/merge model for teams working across separate branches, design-merge and sync-merge ceremonies, deferred finding convention, and large-team external-tool integration pattern.
- Added `docs/optional/contracts.md`: interface contracts module for shared API shapes, data models, and auth boundaries between parallel workstreams; lifecycle from draft → agreed.
- Added `workflow-status` make target and `scripts/workspace-status.sh` for a consolidated workspace health summary.
- Fixed cross-reference links across optional docs for cohesion (no schema changes).

No register schema changes in this release.

## 2026-05-10
- Added `WORKSPACE_LANGUAGE` to `make init`. Prompts for an agent response language (default: `English`); injects a language directive at the top of the generated `AGENTS.md` so all agent outputs use the specified language. Overridable via env var: `WORKSPACE_LANGUAGE=Japanese make init`.
- Added Traditional Chinese (Taiwan) translations of all 27 docs under `docs/i18n/zh-TW/`, mirroring the `docs/core/`, `docs/optional/`, `docs/guides/`, and `docs/philosophy.md` structure. Technical identifiers (file paths, YAML field names, make commands, status values) are kept in English.
- Added `docs/i18n/**` to `replace_reference_paths` in the adaptation contract so sideloading consumers receive translated docs on upgrade.

No register schema changes in this release.

## Schema change convention

When a release changes the columns of a canonical register, include a `schema_change` YAML block in the release entry:

```yaml
schema_change:
  file: "path/to/register.yaml"   # required — use the .yaml source file, not the .md view
  schema_version: 2               # required — the version this migration produces; set this in the register after migrating
  is_new: true                    # optional — present and true only for newly introduced files
  fields: [field1, field2]        # for new files: list all fields in order
  removed: [field1, field2]       # optional — fields dropped from an existing file
  added:                          # optional — fields added to an existing file
    - field: new_field_name
      after: preceding_field      # position hint; omit if appended at end
  renamed:                        # optional — field renames (no data loss)
    - from: old_name
      to: new_name
  migration: >
    Free-text guidance for the sideload agent: what to do with existing rows,
    which template to reference, and any ordering constraints.
    After migration, set schema_version: <N> in the register file.
```

`schema_version` on each block is the version the register should be at after the migration completes. `make docs-check` (via `check-register-schema-versions.sh`) validates that live registers match the expected versions in `meta/schemas/register-schema-versions.yaml`.

The sideload agent should look for `schema_change` blocks in the entries between the consumer's current adopted version and the target version, then apply the described migrations to the live register files before running `make docs-check`.

## 2026-05-09
- Renamed `milestone` → `capability` throughout `ROADMAP.yaml` and `WORK_QUEUE.yaml`. Capability IDs use the `CAP-` prefix. Reflects coherence-grouping purpose over delivery-deadline connotation. All checks, render scripts, docs, and prose references updated.
- Added qualitative IRG mode alongside full numeric rubric. Default mode uses a two-question mental check (readiness + notes); full S/A/I/R/V scoring is an opt-in upgrade. `check-ready-queue-admission.sh` detects qualitative mode (all irg sub-fields absent) and skips numeric validation while still enforcing `blocking_unknowns` and other gates. See `docs/optional/full-irg-scoring.md` for the upgrade trigger guidance.
- Restructured docs into `docs/core/`, `docs/optional/`, and `docs/guides/` layers. Added `docs/philosophy.md` as the conceptual entrypoint. Added module-level docs and a Graphviz tech tree (`docs/diagrams/tech-tree.dot`).
- Added `check-sync-skip.sh` to `make docs-check`: detects promoted G&D entries that were not archived through a Sync pass.
- Register design rationale documented in `docs/core/workflow-reference.md`; added capability/feature/non-feature task distinction to `docs/core/glossary.md`.

```yaml
schema_change:
  file: "1-design/ROADMAP.yaml"
  schema_version: 2
  renamed:
    - from: milestones
      to: capabilities
  migration: >
    Rename the top-level `milestones` key to `capabilities`. Update any
    milestone IDs from M-xxx to CAP-xxx format. After migration, set
    schema_version: 2.
```

```yaml
schema_change:
  file: "1-design/archive/ROADMAP.yaml"
  schema_version: 2
  renamed:
    - from: milestones
      to: capabilities
  migration: >
    Same rename as ROADMAP.yaml — change `milestones` → `capabilities` and
    update IDs to CAP- prefix. Set schema_version: 2.
```

```yaml
schema_change:
  file: "2-build/WORK_QUEUE.yaml"
  schema_version: 5
  renamed:
    - from: milestone
      to: capability
  migration: >
    Rename the `milestone` field to `capability` on each task row.
    Update referenced milestone IDs to the CAP- prefix format. Apply the
    same migration to 2-build/archive/WORK_QUEUE.yaml. Set schema_version: 5
    in both files.
```

## 2026-05-08 (3)
- Added `title` field to `DESIGN_STATES.yaml` (active and archive). Title is denormalized from `FEATURE_REGISTRY.yaml` for readability — keep them in sync when a feature is renamed. The rendered card heading now shows `FEAT-xxx · **Feature Title**` instead of just the feature ID. `FEATURE_REGISTRY.yaml` remains the authoritative identity record.

```yaml
schema_change:
  file: "1-design/DESIGN_STATES.yaml"
  schema_version: 4
  added:
    - field: title
      after: feature_id
  migration: >
    For each existing feature entry, add title with the feature's human-readable
    name. Copy the value from the matching entry's title field in
    1-design/FEATURE_REGISTRY.yaml. After migration, set schema_version: 4.
```

```yaml
schema_change:
  file: "1-design/archive/DESIGN_STATES.yaml"
  schema_version: 4
  added:
    - field: title
      after: feature_id
  migration: >
    For each existing archived feature entry, add title from the matching entry
    in 1-design/FEATURE_REGISTRY.yaml. After migration, set schema_version: 4.
```

## 2026-05-08 (3)
- Renamed `specialist_advisor` → `advisor_track` and `advisor_gate` → `advisor_status` in `TASK_READINESS.yaml` and `WORK_QUEUE.yaml` (active and archive). Renamed status values: `required` → `pending`, `approved` → `complete` (authority clarification: `complete` signals AI analysis is done; human sign-off uses the separate `specialist_sign_off` structure). Also added missing `data_migration` and `api_contract` to the valid `advisor_track` values checked in `meta/checks/check-work-queue-columns.sh`. Updated all docs, templates, checks, and the render script.

```yaml
schema_change:
  file: "1-design/TASK_READINESS.yaml"
  schema_version: 3
  renamed:
    - from: specialist_advisor
      to: advisor_track
    - from: advisor_gate
      to: advisor_status
  value_changes:
    advisor_status:
      required: pending
      approved: complete
  migration: >
    Rename specialist_advisor → advisor_track and advisor_gate → advisor_status on each
    task row. Change any advisor_status value of "required" to "pending" and "approved"
    to "complete". Set schema_version: 3.
```

```yaml
schema_change:
  file: "2-build/WORK_QUEUE.yaml"
  schema_version: 4
  renamed:
    - from: specialist_advisor
      to: advisor_track
    - from: advisor_gate
      to: advisor_status
  value_changes:
    advisor_status:
      required: pending
      approved: complete
  migration: >
    Rename specialist_advisor → advisor_track and advisor_gate → advisor_status on each
    task row. Change any advisor_status value of "required" to "pending" and "approved"
    to "complete". Apply same migration to 2-build/archive/WORK_QUEUE.yaml.
    Set schema_version: 4 in both files.
```

## 2026-05-08 (2)
- Added `advisor_gate`, `specialist_advisor`, `quality_requirements`, and `decision_links` fields to `WORK_QUEUE.yaml` (active and archive). Build and Verify agents now read all gate and execution-context fields directly from the queue entry, eliminating the mandatory `TASK_READINESS.yaml` open at Build/Verify session start. `TASK_READINESS.yaml` remains the authoritative Design record for IRG scoring; open it only when IRG context is specifically needed.

```yaml
schema_change:
  file: "2-build/WORK_QUEUE.yaml"
  schema_version: 3
  added:
    - field: advisor_gate
      after: spec_link
    - field: specialist_advisor
      after: advisor_gate
    - field: quality_requirements
      after: specialist_advisor
    - field: decision_links
      after: quality_requirements
  migration: >
    For each existing task entry, add the four fields after spec_link.
    Copy advisor_gate and specialist_advisor from the matching row in
    1-design/TASK_READINESS.yaml. Copy quality_requirements and decision_links
    from the same row (both are lists; use [] if empty). For the seeded
    SETUP-001 entry use: advisor_gate: not_required, specialist_advisor: none,
    quality_requirements: [], decision_links: []. After migration, set
    schema_version: 3.
```

```yaml
schema_change:
  file: "2-build/archive/WORK_QUEUE.yaml"
  schema_version: 3
  added:
    - field: advisor_gate
      after: spec_link
    - field: specialist_advisor
      after: advisor_gate
    - field: quality_requirements
      after: specialist_advisor
    - field: decision_links
      after: quality_requirements
  migration: >
    For each existing archived task entry, add the four fields after spec_link.
    Copy values from the matching row in 1-design/archive/TASK_READINESS.yaml.
    After migration, set schema_version: 3.
```

## 2026-05-08
- Added `spec_link` field to `WORK_QUEUE.yaml` (active and archive). Build agents now follow `spec_link` in the queue entry to find the task's design spec, eliminating the need to open `TASK_READINESS.yaml` purely for spec navigation. `TASK_READINESS.yaml` remains the authoritative design record for IRG scores, QR links, and advisor gate tracking.

```yaml
schema_change:
  file: "2-build/WORK_QUEUE.yaml"
  schema_version: 2
  added:
    - field: spec_link
      after: component
  migration: >
    For each existing task entry, add spec_link with the repo-relative path to
    the task's design spec. Copy the value from the matching entry's spec_link
    field in 1-design/TASK_READINESS.yaml. For the seeded SETUP-001 entry use
    "1-design/PROJECT_BRIEF.md". After migration, set schema_version: 2.
```

```yaml
schema_change:
  file: "2-build/archive/WORK_QUEUE.yaml"
  schema_version: 2
  added:
    - field: spec_link
      after: component
  migration: >
    For each existing archived task entry, add spec_link with the repo-relative
    path to the task's design spec. Copy the value from the matching entry in
    1-design/archive/TASK_READINESS.yaml. After migration, set schema_version: 2.
```

## 2026-05-07
- Refactored `FEEDBACK_MATRIX` (v1→v2): removed `gap` and `deviation` types (design vocabulary replaced by agent-authored G&D entries); added `pass` and `regression` types alongside existing `observation` and `issue`; added optional `diagnosis` free-text field for human root-cause notes; replaced `promoted_to_staging` status with `resolved`. Agents now read FM `diagnosis` fields and create `GAPS_AND_DEVIATIONS` entries with `source: human_feedback` — humans no longer write to G&D directly.

```yaml
schema_change:
  file: "3-verify/FEEDBACK_MATRIX.yaml"
  schema_version: 2
  added:
    - field: diagnosis
      after: summary
  migration: >
    For each existing entry with type gap or deviation: change type to issue
    and move the gap/deviation description into the new diagnosis field.
    Change any status of promoted_to_staging to resolved.
    Then set schema_version: 2.
```

```yaml
schema_change:
  file: "3-verify/archive/FEEDBACK_MATRIX.yaml"
  schema_version: 2
  added:
    - field: diagnosis
      after: summary
  migration: >
    For each existing entry with type gap or deviation: change type to issue
    and move the gap/deviation description into the diagnosis field.
    Change any status of promoted_to_staging to resolved.
    Then set schema_version: 2.
```

- Moved all `*_DONE.yaml` / `*_DONE.md` files from their stage root into an `archive/` subfolder within each stage directory. Old path: `1-design/ROADMAP_DONE.yaml`; new path: `1-design/archive/ROADMAP.yaml`. Applies to every register with an active/done split across all stages (`0-ideation/`, `1-design/`, `2-build/`, `3-verify/`, `4-sync/`). No schema changes — existing done-file content requires no migration. Update any local scripts or tooling that reference `*_DONE.yaml` paths.
- Folded `4-sync/DESIGN_ARCHIVE.yaml` into `4-sync/archive/DESIGN_INPUTS.yaml` for naming consistency with the archive subfolder pattern. The file is created on-demand when resolved DESIGN_INPUTS entries are first moved to it.

## 2026-04-29
- Switched all register renders from flat tables to a per-entry card format. `render-registers.sh` now provides `render_cards()` alongside the existing `render_table()`. Registers with prose fields (notes, summaries, requirements, blocking questions, resolution notes) render as cards: a compact table for structured short fields, bold-labelled lines for medium fields, and blockquotes for long prose. Status and readiness enum values are wrapped in backticks; IRG scores of 0 are bolded. FEATURE_REGISTRY, LOCKS, and TASK_DEPENDENCIES remain as plain tables.
- Updated `templates/init/INIT_QUALITY_REQUIREMENTS_TEMPLATE.md` and `templates/init/INIT_TEMP_MEASURES_TEMPLATE.md` to show card-format examples instead of table rows.
- No YAML schema changes — existing register files require no migration. Run `make render` after sideloading to regenerate all `.md` views in the new format.

## 2026-04-18.1
- Added `components` field to `4-sync/RELEASE_QUEUE.yaml` entries. Each entry now includes a list of component names and version labels included in the release. workspace-deployment's `make populate` reads these to auto-fill `scope[].ref` in `DEPLOYMENT_BRIEF.yaml`, eliminating the manual pinning step when component versions are known at Sync time.

```yaml
schema_change:
  file: "4-sync/RELEASE_QUEUE.yaml"
  schema_version: 2
  added:
    - field: components
      after: milestone_ids
  migration: >
    For each existing entry in RELEASE_QUEUE.yaml, add a `components` list.
    Each item has `name` (component name matching workspace.manifest.yaml) and
    `version` (version label or git tag for that component in this release).
    Example: components: [{name: my-service, version: "v1.0.0"}]
    Then set schema_version: 2.
```

```yaml
schema_change:
  file: "4-sync/RELEASE_QUEUE_DONE.yaml"
  schema_version: 2
  added:
    - field: components
      after: milestone_ids
  migration: >
    For each existing entry in RELEASE_QUEUE_DONE.yaml, add a `components` list
    using the same structure as RELEASE_QUEUE.yaml above (backfill from git history
    or leave as empty list [] if unknown). Then set schema_version: 2.
```

## 2026-04-17.3
- Introduced `1-design/FEATURE_REGISTRY.yaml` — permanent feature identity register. Holds `id`, `title`, `components`, and `created_on`. Rows are never removed. Separates feature identity from design triage state so other registers can reference features without loading design-work context.
- Refactored `DESIGN_STATES.yaml` (v2→v3) into a pure triage list. Feature identity (id, title, components) moved to `FEATURE_REGISTRY.yaml`. The `id` field is renamed to `feature_id` (a reference to FEATURE_REGISTRY, not a self-identity). The `components` field is removed (lives in FEATURE_REGISTRY). Added `complete` as a terminal design state. Added `DESIGN_STATES_DONE.yaml` for completed features.
- Sync step updated: when all tasks for a feature are in `WORK_QUEUE_DONE` and no open `DESIGN_INPUTS` reference the feature, set `design_state: complete` and move the row to `DESIGN_STATES_DONE.yaml`.
- Fixed bug in `check-ready-queue-admission.sh`: `needs_redesign` was missing from the valid design_state enum; added it.
- Updated `check-ready-queue-admission.sh` to read `.feature_id` instead of `.id` from DESIGN_STATES.
- Updated `render-registers.sh`: added FEATURE_REGISTRY render; replaced DESIGN_STATES render with the new `feature_id`-keyed columns; added DESIGN_STATES_DONE render.
- Updated `check-canonicality.sh`, `init-workspace.sh`, `register-schema-versions.yaml`, AGENTS templates, `docs/core/glossary.md`, and `docs/core/workflow-reference.md`.

```yaml
schema_change:
  file: "1-design/FEATURE_REGISTRY.yaml"
  schema_version: 1
  is_new: true
  fields: [id, title, components, created_on]
  migration: >
    Create 1-design/FEATURE_REGISTRY.yaml from
    templates/init/INIT_FEATURE_REGISTRY_TEMPLATE.yaml.
    For each feature in the old DESIGN_STATES.yaml, add a row here using:
      id: (the feature's old .id value)
      title: (the feature's title or a short description — derive from notes if needed)
      components: (the feature's old .components list)
      created_on: (the feature's last_updated date, or today if unknown)
```

```yaml
schema_change:
  file: "1-design/DESIGN_STATES.yaml"
  schema_version: 3
  removed: [components]
  renamed:
    - from: id
      to: feature_id
  added:
    - field: complete
      after: "# new terminal design_state value — not a field, see design_state enum"
  migration: >
    For each existing feature row:
      1. Rename .id to .feature_id
      2. Remove the .components field (it now lives in FEATURE_REGISTRY.yaml)
      3. Ensure design_state is one of: concept|spec_draft|spec_review|ready|needs_redesign
         Any feature that is fully shipped may be set to complete and moved to DESIGN_STATES_DONE.yaml
    Then set schema_version: 3.
```

```yaml
schema_change:
  file: "1-design/DESIGN_STATES_DONE.yaml"
  schema_version: 3
  is_new: true
  fields: [feature_id, design_state, linked_idea, linked_tasks, owner, blocking_questions, last_updated, decision_links, notes]
  migration: >
    Create 1-design/DESIGN_STATES_DONE.yaml from
    templates/init/INIT_DESIGN_STATES_DONE_TEMPLATE.yaml.
    Move any features with design_state: complete from DESIGN_STATES.yaml here.
```

## 2026-04-17.2
- Converted `TEMP_MEASURES` from a hand-edited markdown table to a YAML register with active/done split (`2-build/TEMP_MEASURES.yaml` / `TEMP_MEASURES_DONE.yaml`). Terminal status `closed` moves to done file; `open` and `removal_in_progress` stay active. `linked_tasks` is now a YAML list instead of a comma-separated string.
- Converted `IDEATION_BACKLOG` from a hand-edited markdown document to a YAML register with active/done split (`0-ideation/IDEATION_BACKLOG.yaml` / `IDEATION_BACKLOG_DONE.yaml`). Terminal statuses `promoted`, `parked`, `dropped` move to done file; `open` stays active. Rich `discussion` content is stored as a multi-line YAML string. Scaffold updated: `0-ideation/templates/IDEA_ENTRY_TEMPLATE.yaml` replaces the old `.md` scaffold.
- Updated `render-registers.sh` with render entries for both new YAML pairs.
- Updated `check-canonicality.sh`, `init-workspace.sh`, and `meta/schemas/register-schema-versions.yaml` for all four new files.
- Updated all docs and templates (`docs/core/workflow-reference.md`, `docs/core/workflow-summary.md`, `docs/core/operations.md`, `docs/guides/repo-modes.md`, AGENTS templates, `INIT_PROJECT_BRIEF_TEMPLATE.md`, `INIT_QUALITY_REQUIREMENTS_TEMPLATE.md`) to reference the new `.yaml` paths.

```yaml
schema_change:
  file: "0-ideation/IDEATION_BACKLOG.yaml"
  schema_version: 1
  is_new: true
  fields: [id, title, status, date, components, summary, discussion, outcome]
  migration: >
    Create 0-ideation/IDEATION_BACKLOG.yaml from
    templates/init/INIT_IDEATION_BACKLOG_TEMPLATE.yaml.
    Convert each open idea section from IDEATION_BACKLOG.md into a YAML entry.
    Move promoted/parked/dropped entries to IDEATION_BACKLOG_DONE.yaml.
    The discussion field accepts a multi-line YAML string (use | syntax).
    outcome is a nested object: {decision, reason, promotion_target}.
```

```yaml
schema_change:
  file: "0-ideation/IDEATION_BACKLOG_DONE.yaml"
  schema_version: 1
  is_new: true
  fields: [id, title, status, date, components, summary, discussion, outcome]
  migration: >
    Create 0-ideation/IDEATION_BACKLOG_DONE.yaml from
    templates/init/INIT_IDEATION_BACKLOG_DONE_TEMPLATE.yaml.
    Move promoted/parked/dropped entries from the old IDEATION_BACKLOG.md here.
```

```yaml
schema_change:
  file: "2-build/TEMP_MEASURES.yaml"
  schema_version: 1
  is_new: true
  fields: [id, summary, scope, introduced_on, owner, exit_trigger, removal_target, linked_tasks, status]
  migration: >
    Create 2-build/TEMP_MEASURES.yaml from
    templates/init/INIT_TEMP_MEASURES_TEMPLATE.yaml.
    Convert each row from the old TEMP_MEASURES.md into a YAML entry.
    linked_tasks becomes a YAML list (split the comma-separated string).
    Move entries with status closed to TEMP_MEASURES_DONE.yaml.
```

```yaml
schema_change:
  file: "2-build/TEMP_MEASURES_DONE.yaml"
  schema_version: 1
  is_new: true
  fields: [id, summary, scope, introduced_on, owner, exit_trigger, removal_target, linked_tasks, status]
  migration: >
    Create 2-build/TEMP_MEASURES_DONE.yaml from
    templates/init/INIT_TEMP_MEASURES_DONE_TEMPLATE.yaml.
    Move closed entries from the old TEMP_MEASURES.md here.
```

## 2026-04-17.1
- Added `1-design/TASK_READINESS_DONE.yaml` — active/done split for Task Readiness. When a task is moved to `WORK_QUEUE_DONE` during Sync, its matching `TASK_READINESS` row moves to `TASK_READINESS_DONE` in the same step. Preserves design admission history (IRG scores, `quality_requirements`, `decision_links`) without accumulating in the active read path.
- Updated Sync step 3 in both AGENTS templates and `docs/core/workflow-reference.md` to include the TASK_READINESS move alongside the WORK_QUEUE move.
- Updated `render-registers.sh`, `check-canonicality.sh`, `scripts/init-workspace.sh`, and `meta/schemas/register-schema-versions.yaml` for the new file.

```yaml
schema_change:
  file: "1-design/TASK_READINESS_DONE.yaml"
  schema_version: 2
  is_new: true
  fields: [id, feature_id, title, component, spec_link, irg, blocking_unknowns, readiness, specialist_advisor, advisor_gate, quality_requirements, decision_links, notes]
  migration: >
    Create 1-design/TASK_READINESS_DONE.yaml from
    templates/init/INIT_TASK_READINESS_DONE_TEMPLATE.yaml.
    Move any rows from TASK_READINESS.yaml whose corresponding WORK_QUEUE task
    is already in WORK_QUEUE_DONE.yaml into this file.
```

## 2026-04-17

- Added `quality_requirements` and `decision_links` fields to `TASK_READINESS.yaml`. `quality_requirements` is a list of QR IDs from `QUALITY_REQUIREMENTS.yaml` with `enforcement: per_task` or `enforcement: milestone` that apply to the specific task; sustained QRs apply implicitly and need not be listed. `decision_links` is a list of repo-relative paths to decision documents in `1-design/decisions/` that shaped the task design.
- Added `decision_links` field to `DESIGN_STATES.yaml` features — repo-relative paths to decision docs that informed the feature design.
- Converted `QUALITY_REQUIREMENTS` from a hand-edited markdown table to a YAML register with active/done split (`QUALITY_REQUIREMENTS.yaml` / `QUALITY_REQUIREMENTS_DONE.yaml`). Added `enforcement` field with values `sustained | per_task | milestone` to distinguish permanent standards (never globally satisfied) from task-specific and milestone-gated requirements. Terminal dispositions (`satisfied`, `superseded`, `dropped`) move to `QUALITY_REQUIREMENTS_DONE.yaml`; non-terminal (`active`, `deferred`) stay in the active file. `make render` now generates both `.md` views.
- Updated `check-task-readiness-columns.sh` to validate the new `quality_requirements` and `decision_links` fields.
- Updated `scripts/init-workspace.sh`: `USE_QUALITY_REQUIREMENTS=1` now deploys the YAML pair instead of the markdown file.
- Updated `docs/core/workflow-reference.md` Build rules: agents read all `sustained` QRs at build start; only open `QUALITY_REQUIREMENTS.yaml` for per-task/milestone verification when `quality_requirements` is populated in TASK_READINESS.
- Updated AGENTS templates build session step 4 with structured open conditions for `QUALITY_REQUIREMENTS.yaml` and `1-design/decisions/`.

```yaml
schema_change:
  file: "1-design/TASK_READINESS.yaml"
  schema_version: 2
  added:
    - field: quality_requirements
      after: advisor_gate
    - field: decision_links
      after: quality_requirements
  migration: >
    For each existing task row, add quality_requirements: [] and decision_links: [].
    Then set schema_version: 2 in the file header.
    Populate quality_requirements with QR IDs (per_task or milestone enforcement only)
    that apply to each task, and decision_links with any decision doc paths already
    referenced in the task notes.
```

```yaml
schema_change:
  file: "1-design/DESIGN_STATES.yaml"
  schema_version: 2
  added:
    - field: decision_links
      after: linked_idea
  migration: >
    For each existing feature row, add decision_links: [].
    Then set schema_version: 2 in the file header.
    Populate decision_links with any decision doc paths already referenced
    in the feature notes or design documents.
```

```yaml
schema_change:
  file: "1-design/QUALITY_REQUIREMENTS.yaml"
  schema_version: 1
  is_new: true
  fields: [id, recorded_on, origin, added_by, scope, category, enforcement, requirement, applies_to, validation, disposition, notes]
  migration: >
    Create 1-design/QUALITY_REQUIREMENTS.yaml from templates/init/INIT_QUALITY_REQUIREMENTS_TEMPLATE.yaml.
    If a hand-edited QUALITY_REQUIREMENTS.md exists, convert each table row to a YAML entry.
    Set enforcement for each row: sustained (permanent standards like logging, no-hardcoded-secrets),
    per_task (applies each time a specific task type occurs), or milestone (one-time gate before an event).
    Move any rows with disposition satisfied/superseded/dropped to QUALITY_REQUIREMENTS_DONE.yaml.
    Delete or regenerate QUALITY_REQUIREMENTS.md via make render.
```

```yaml
schema_change:
  file: "1-design/QUALITY_REQUIREMENTS_DONE.yaml"
  schema_version: 1
  is_new: true
  fields: [id, recorded_on, origin, added_by, scope, category, enforcement, requirement, applies_to, validation, disposition, notes]
  migration: >
    Create 1-design/QUALITY_REQUIREMENTS_DONE.yaml from
    templates/init/INIT_QUALITY_REQUIREMENTS_DONE_TEMPLATE.yaml.
    Move any terminal-disposition rows (satisfied/superseded/dropped) from
    the old QUALITY_REQUIREMENTS.md into this file as YAML entries.
```

## 2026-04-16
- Split registers with terminal statuses into active/done YAML pairs. Each affected register now has two source files: `REGISTER.yaml` (active entries) and `REGISTER_DONE.yaml` (completed/terminal entries). When an entry reaches its terminal status it is moved — not just updated — from the active file to the done file, keeping the active YAML lean for agent reads. Registers split: `WORK_QUEUE` (terminal: `done`), `ROADMAP` (terminal: `completed`, `parked`), `FEEDBACK_MATRIX` (terminal: `resolved_in_loop`, `promoted_to_staging`), `GAPS_AND_DEVIATIONS` (terminal: `promoted_to_sync`, `resolved_in_loop`), `RELEASE_QUEUE` opt (terminal: `released`, `abandoned`), `LOCKS` opt (terminal: `released`). `DESIGN_INPUTS` is unchanged — it already uses `DESIGN_ARCHIVE.yaml` for this purpose.
- `make render` now renders each YAML file straight to its own `.md` with no filter logic. Running `make render` after moving entries to `_DONE.yaml` regenerates both views.
- `make init` now deploys all `_DONE.yaml` files alongside their active counterparts.
- Stage instructions in AGENTS templates and `docs/core/workflow-reference.md` updated: reads now reference `.yaml` source files directly (not `.md` views), and each stage includes explicit move-to-done steps.
- `meta/schemas/register-schema-versions.yaml`, `check-canonicality.sh`, column checks, and smoke test updated for the new files.

## 2026-04-15.1
- Added optional `4-sync/RELEASE_QUEUE.yaml` register for deployment release candidates. Enabled via `USE_RELEASE_QUEUE=1` at `make init`. Each entry records a `release_version`, `release_type` (`feature | bugfix | performance | architecture | mixed`), `release_state` (`candidate | released | abandoned`), the `task_ids` from WORK_QUEUE included in the release, and optional `milestone_ids`. Setting `release_state: candidate` is the explicit signal for workspace-deployment's `make populate` to scope a DEPLOYMENT_BRIEF. Releases are not constrained to milestone boundaries — bugfixes, performance work, and architecture changes are first-class release types.
- Wired `RELEASE_QUEUE.yaml` into `make render` (generates `4-sync/RELEASE_QUEUE.md` table view), `make docs-check` (new `release-queue-check` target validates entry columns and enum values), and `meta/schemas/register-schema-versions.yaml`.
- Updated Sync rules in `docs/core/workflow-reference.md` and both AGENTS templates with a step 5 prompting agents to assess release readiness and create `candidate` entries at the end of Sync.

## 2026-04-15
- Added `api_contract` specialist track for interface change safety: analysis template, `INIT_API_CONTRACT_REVIEWS_TEMPLATE.md` init scaffold, `check-specialist-gates.sh` enforcement, and interface stability tier annotation in both component README templates (stable tier requires `api_contract` review on change). Includes a worked example (breaking field rename on a stable endpoint) in `docs/optional/specialist-tracks.md`.
- Added `data_migration` specialist advisor track: analysis template, `INIT_DATA_MIGRATION_REVIEWS_TEMPLATE.md` init scaffold, and `check-specialist-gates.sh` enforcement.
- Added optional `QUALITY_REQUIREMENTS.md` init template pre-seeded with rows for observability, reliability, SLO, security, testability, and data safety (opt-in via `USE_QUALITY_REQUIREMENTS=1`).
- Added `docs/optional/deployment-patterns.md` covering strategy selection, pre-deployment checklist, blast radius control, and rollback criteria.
- Added operational contract section to both component README templates (SLO target, key health metric, rollback, escalation).
- Sharpened acceptance-gate section 4 with concrete operational readiness sub-criteria linking to the new deployment docs and data migration track.
- Surfaced `yq` prerequisite in generated README and AGENTS entrypoints: both `WORKSPACE_README_TEMPLATE.md` and `WORKSPACE_AGENTS_TEMPLATE.md` (and federated variants) now include a Setup section pointing to `make install-tools` before Common commands. Previously only documented in `docs/core/operations.md`, causing silent failures on a fresh `make init` + `make docs-check`.
- Added Mermaid flowcharts to `docs/core/workflow-summary.md`, `docs/core/workflow-reference.md`, and `docs/optional/consistency-gates.md` illustrating the core loop, task status path, and IRG gate.

## 2026-04-08
- Wired all Verify/Sync artifacts into `make init`: `3-verify/FEEDBACK_MATRIX.yaml`, `3-verify/GAPS_AND_DEVIATIONS.yaml`, `3-verify/acceptance-gate.md`, `3-verify/SIGN_OFF.md`, `4-sync/DESIGN_INPUTS.yaml`, `4-sync/DESIGN_ARCHIVE.yaml`.
- Renamed `3-verify/HUMAN_REVIEW_CHECKLIST.md` → `3-verify/acceptance-gate.md` to match its actual role.
- Added `INIT_ACCEPTANCE_GATE_TEMPLATE.md` and `INIT_SIGN_OFF_TEMPLATE.md` to `templates/init/`.
- Added `needs_redesign` state to `1-design/DESIGN_STATES.yaml` and its init template.
- Clarified `drift_status` in `TRACEABILITY_MATRIX` as a gate signal distinct from the GAPS_AND_DEVIATIONS incident log.
- Removed superseded files `4-sync/DESIGN_LOG.md` and `4-sync/DRIFT_LOG.md`; their roles are fully covered by `3-verify/GAPS_AND_DEVIATIONS.yaml`, `4-sync/DESIGN_INPUTS.yaml`, and `4-sync/DESIGN_ARCHIVE.yaml`. References in `docs/core/operations.md` and `docs/optional/concurrency-overlay.md` updated accordingly. Workspaces with existing entries in these files should migrate content to the appropriate replacement registers before discarding the files.
- Restructured optional file deployment: optional files are no longer checked into the repo root. Each has an `INIT_*_TEMPLATE` in `templates/` and is deployed only when opted in during `make init`. Consumers who previously relied on these files existing after cloning should run `make init` with the relevant flags set. Affected files: `0-ideation/IDEATION_BACKLOG.md`, `2-build/TASK_DEPENDENCIES.yaml/.md`, `2-build/LOCKS.yaml/.md`, `2-build/TEMP_MEASURES.md`, `3-verify/SECURITY_REVIEWS.md`, `3-verify/EXPERIMENT_REVIEWS.md`, `3-verify/INCIDENT_RESPONSES.md`, `3-verify/SIGN_OFF.md`, `4-sync/HANDOFFS.md`. `SIGN_OFF.md` is now optional (new `USE_SIGN_OFF` flag); `PRUNE_OPTIONAL` variable removed.
- Moved `4-sync/TEMP_MEASURES.md` → `2-build/TEMP_MEASURES.md`. Temp measures are introduced during Build and agents need access to them while building; Sync closure is the only Sync-stage operation. Also split the `USE_SYNC_LOGS` init flag: HANDOFFS remains under `USE_SYNC_LOGS`; TEMP_MEASURES gets its own `USE_TEMP_MEASURES` flag. Consumers with existing `4-sync/TEMP_MEASURES.md` should move the file to `2-build/` and update any links.
- Redesigned specialist advisor track from human-routing model to agent-led analysis model. The agent now applies specialist-level thinking itself, records findings using the backing templates in `3-verify/templates/`, and sets `advisor_gate: approved` when complete. If a concern cannot be resolved, the agent creates a GAPS_AND_DEVIATIONS entry. Updated: `docs/optional/specialist-tracks.md` (full rewrite), `3-verify/templates/SECURITY_ANALYSIS_TEMPLATE.md` (renamed from `SECURITY_REVIEW_REQUEST_TEMPLATE.md`, rewritten as agent analysis record), `3-verify/templates/EXPERIMENT_PLAN_TEMPLATE.md`, `3-verify/templates/INCIDENT_RESPONSE_TEMPLATE.md`, `3-verify/SECURITY_REVIEWS.md`, `3-verify/EXPERIMENT_REVIEWS.md`, `3-verify/INCIDENT_RESPONSES.md` (section-based log format), `docs/core/glossary.md` (Advisor Gate + Specialist Advisor definitions), `docs/core/operations.md` (Specialist preparation section), `meta/checks/check-specialist-gates.sh` (simplified: verifies file existence and gate resolved before accepted/done), `1-design/TASK_READINESS.yaml` and template (advisor_gate comment clarified).

```yaml
schema_change:
  file: "3-verify/FEEDBACK_MATRIX.yaml"
  schema_version: 1
  is_new: true
  fields: [id, task_id, feature_id, type, summary, detail, tested_by, date, severity, status, resolution]
  migration: >
    Create 3-verify/FEEDBACK_MATRIX.yaml from templates/init/INIT_FEEDBACK_MATRIX_TEMPLATE.yaml.
    This file collects structured human test observations during the Verify stage.
    After creation, set schema_version: 1.
```

```yaml
schema_change:
  file: "3-verify/GAPS_AND_DEVIATIONS.yaml"
  schema_version: 1
  is_new: true
  fields: [id, feature_id, type, summary, detail, source, source_ref, discovered_in_task, status, resolution_note]
  migration: >
    Create 3-verify/GAPS_AND_DEVIATIONS.yaml from templates/init/INIT_GAPS_AND_DEVIATIONS_TEMPLATE.yaml.
    This file stages all gaps and deviations discovered during the Build/Verify loop, to be passed to Sync.
    After creation, set schema_version: 1.
```

```yaml
schema_change:
  file: "4-sync/DESIGN_INPUTS.yaml"
  schema_version: 1
  is_new: true
  fields: [id, feature_id, type, summary, detail, source_ref, cycle, status, resolution_type, resolution_pointer, resolution_note]
  migration: >
    Create 4-sync/DESIGN_INPUTS.yaml from templates/init/INIT_DESIGN_INPUTS_TEMPLATE.yaml.
    This is the live register of open gaps and deviations for the next Design cycle, written by Sync.
    After creation, set schema_version: 1.
```

```yaml
schema_change:
  file: "4-sync/DESIGN_ARCHIVE.yaml"
  schema_version: 1
  is_new: true
  fields: [id, source_input_id, feature_id, type, summary, cycle_opened, cycle_closed, resolution_type, resolution_pointer, resolution_note]
  migration: >
    Create 4-sync/DESIGN_ARCHIVE.yaml from templates/init/INIT_DESIGN_ARCHIVE_TEMPLATE.yaml.
    Entries move here from DESIGN_INPUTS once Design has made a decision (incorporated or dismissed).
    After creation, set schema_version: 1.
```

## 2026-04-01
- Applied a file naming convention: `README.md` for human entrypoints, `AGENTS.md` for AI entrypoints, uppercase names for canonical registers, lowercase kebab-case for narrative docs, and `*_TEMPLATE.*` for scaffolds.
- Renamed stage `INDEX.md` guides to `README.md` and moved narrative docs under `docs/` to lowercase kebab-case names.
- Clarified `Direct use` vs `Sideload/adapt` across the top-level docs.
- Added `make init` plus `scripts/init-workspace.sh` for first-run workspace bootstrap.
- Added `make init-smoke` and a smoke-check script for the bootstrap flow.
- Added `docs/guides/worked-example.md` as an end-to-end lifecycle walkthrough.
- Strengthened traceability guidance and validation for local paths versus federated references.
- Aligned federated example data across `workspace.manifest.yaml` and `components/COMPONENT_REPOS.md`.
- Reworked the shipped stage registers into starter/tutorial rows instead of template-maintenance history.
- Documented that template maintenance should not be tracked in the shipped starter queue and aligned `make init` with the new placeholders.
- Split IRG scoring and design admission tracking out of `2-build/WORK_QUEUE.yaml` into a new `1-design/TASK_READINESS.yaml` register.

```yaml
schema_change:
  file: "2-build/WORK_QUEUE.yaml"
  schema_version: 1
  removed: [Spec Link, IRG, Blocking Unknowns, Readiness, Specialist Advisor, Advisor Gate]
  migration: >
    For each existing WORK_QUEUE row, remove those six columns.
    Create a matching row in 1-design/TASK_READINESS.yaml carrying the IRG data.
    See templates/init/INIT_TASK_READINESS_TEMPLATE.yaml for the required fields.
    After migration, set schema_version: 1 in 2-build/WORK_QUEUE.yaml.
```

```yaml
schema_change:
  file: "1-design/TASK_READINESS.yaml"
  schema_version: 1
  is_new: true
  fields: [task_id, feature_id, title, component, spec_link, irg, blocking_unknowns, readiness, specialist_advisor, advisor_gate, notes]
  migration: >
    Create this file from templates/init/INIT_TASK_READINESS_TEMPLATE.yaml if it does not exist,
    then populate one entry per WORK_QUEUE task using the IRG data removed from WORK_QUEUE.
    After migration, set schema_version: 1 in 1-design/TASK_READINESS.yaml.
```

## 2026-03-16
- Added the first sideloading scaffold for versioned template releases.
- Introduced `template-release.yaml` as the release metadata and adaptation contract file.
- Added consumer state and local override templates in `templates/`.
- Added a release packaging script and `make template-package`.
- Added `docs/guides/template-sideloading.md` to document new-repo generation, adoption, and upgrade flows.
