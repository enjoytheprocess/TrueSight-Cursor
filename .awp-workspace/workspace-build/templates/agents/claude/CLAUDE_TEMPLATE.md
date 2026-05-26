# Claude Code

@AGENTS.md

## Register editing model

Edit `.yaml` source files only — never the `.md` table views.
The `.claude/settings.json` Stop hook runs `make render` automatically after every turn.
Do not call `make render` manually unless you need the `.md` views current within the same turn.

## Session start

1. Check `2-build/WORK_QUEUE.yaml` for any `needs_rework` tasks and `1-design/TASK_READINESS.md` for any `needs_detail` rows. Handle those before pulling new work.
2. Find the active task: look for `status: in_progress` in `2-build/WORK_QUEUE.yaml`.
3. If no task is `in_progress`, ask the user what to work on, or propose the highest-priority `todo` row whose `Readiness = ready_for_build`.
4. Read the active task row in `WORK_QUEUE.yaml`, the matching row in `TASK_READINESS.yaml`, and any linked spec or design doc before writing any code or editing any register.
5. Use `TodoWrite` to lay out the steps if the task has more than two distinct implementation steps.

## Task status discipline

Update `2-build/WORK_QUEUE.yaml` status at these transitions — no other statuses require your action:
- Start of session on a task: `todo` → `in_progress`
- Implementation complete and `make docs-check` passes: `in_progress` → `awaiting_human_review`

Do not set `accepted` or `done` — those require explicit human sign-off.
If a design gap surfaces during build, record it in `TASK_READINESS.yaml` `blocking_unknowns`, set queue status to `needs_rework`, and stop build work on that task.

## When to run `make docs-check`

Run it explicitly at these points (the Stop hook does not run it automatically):
- Before setting a task to `awaiting_human_review`
- After any design-phase change to `TASK_READINESS.yaml` or `DESIGN_STATES.yaml`
- After applying a template schema migration

## When to enter plan mode

Enter plan mode before:
- Changes that touch more than one register file
- Any schema migration from `make migrate-plan`
- Implementing a task whose IRG has any dimension at 1 (known unknowns — plan before committing to an approach)

Not needed for single-field register updates or status-only changes.

## Session end

Before ending a session:
- Confirm `WORK_QUEUE.yaml` status reflects actual current state.
- If design gaps were discovered during this session, confirm `blocking_unknowns` in `TASK_READINESS.yaml` is current.
- If any register `.yaml` was edited this session, confirm the Stop hook has fired at least once (the `.md` views should be up to date).
- If `make docs-check` has not been run this session and registers were changed, run it now.
