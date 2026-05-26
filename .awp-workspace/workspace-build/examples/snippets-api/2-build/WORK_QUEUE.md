<!-- Generated from 2-build/WORK_QUEUE.yaml — do not edit directly. Run `make render` to update. -->

# Work Queue

| Task ID | Feature ID | Title | Component | Priority | Phase | Milestone | Target Window | Mode | Lock ID | Owner | Status | Build Dependencies | Design Dependencies | Validation | Notes |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| SETUP-001 | none | Configure workspace and connect project components | api | P1 | sync | M-001 | 2026-Q2 | sequential | none | Dev Team | done | none | none | make docs-check | workspace setup complete |
| TASK-001 | FEAT-001 | Implement snippet create and retrieve endpoints | api | P1 | sync | M-001 | 2026-Q2 | sequential | none | Dev Team | done | SETUP-001 | none | make docs-check; curl smoke tests | POST /snippets + GET /snippets/:id passing; SQLite storage confirmed |
| TASK-002 | FEAT-002 | Implement snippet deletion endpoint | api | P2 | design | M-002 | 2026-Q2 | sequential | none | Dev Team | todo | TASK-001 | none | make docs-check; curl smoke tests | blocked on deletion semantics — soft vs hard delete |
