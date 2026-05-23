# Template Canonicality

This folder indexes canonical template artifacts for this repository.

Stage-specific per-entry templates live inside the stage folders that use them:
- `0-ideation/templates/IDEA_ENTRY_TEMPLATE.md`
- `1-design/templates/PROJECT_BRIEF_TEMPLATE.md`
- `2-build/templates/TASK_ENTRY_TEMPLATE.md`
- `3-verify/templates/SECURITY_ANALYSIS_TEMPLATE.md`
- `3-verify/templates/EXPERIMENT_PLAN_TEMPLATE.md`
- `3-verify/templates/INCIDENT_RESPONSE_TEMPLATE.md`

Repo-level templates live under `templates/` organized by purpose:
- `templates/init/` — rendered by `make init` (INIT_* files + workspace README/AGENTS variants)
- `templates/sideload/` — used during sideload/upgrade (state file and local overrides templates)
- `templates/component/` — blank post-init scaffolds for adding new components
- `templates/agents/` — agent-specific templates (e.g. Claude)
- `templates/hooks/` — hook templates (e.g. pre-commit)

Release packaging index:
- `meta/templates/template-release-paths.txt`

Rule:
- Update the template in its canonical location first.
- Keep this index in sync with any template additions/removals.
