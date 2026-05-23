<!-- Generated from 1-design/TASK_READINESS.yaml — do not edit directly. Run `make render` to update. -->

# Task Readiness Register

| Task ID | Feature ID | Title | Component | Spec Link | IRG | Blocking Unknowns | Readiness | Specialist Advisor | Advisor Gate | Notes |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| SETUP-001 | none | Configure workspace and connect project components | api | 1-design/PROJECT_BRIEF.md | S:2 A:2 I:2 R:2 V:2 | none | ready_for_build | none | not_required | completed; workspace connected to components/api |
| TASK-001 | FEAT-001 | Implement snippet create and retrieve endpoints | api | 1-design/PROJECT_BRIEF.md | S:2 A:2 I:2 R:1 V:2 | none | ready_for_build | none | not_required | storage: SQLite; POST + GET shapes confirmed; R:1 accepted — no external deps |
| TASK-002 | FEAT-002 | Implement snippet deletion endpoint | api | 1-design/PROJECT_BRIEF.md | S:2 A:1 I:1 R:1 V:1 | soft-delete vs hard-delete not decided; cascade behaviour for shared snippets unclear | needs_detail | none | not_required | blocked on deletion semantics — A and I cannot reach 2 until decision is made |
