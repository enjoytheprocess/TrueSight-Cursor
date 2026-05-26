# AWP: Admit a build task

1. Ensure feature spec exists: `docs/design/features/FEAT-xxx.md` (from `docs/templates/FEATURE_SPEC_TEMPLATE.md`)
2. Update `.awp-workspace/workspace-build/1-design/FEATURE_REGISTRY.yaml` + `DESIGN_STATES.yaml` (`design_state: ready`)
3. Add row to `.awp-workspace/workspace-build/1-design/TASK_READINESS.yaml`:
   - `readiness: ready_for_build`
   - `spec_link: docs/design/features/FEAT-xxx.md`
   - IRG scores ≥ 8/10, A=2, I=2, `blocking_unknowns: none`
4. Add row to `.awp-workspace/workspace-build/2-build/WORK_QUEUE.yaml`:
   - `phase: build`, `status: todo`, same `spec_link`, `component: backend`
   - `validation: make awp-docs-check`
5. Add `.awp-workspace/workspace-build/3-verify/TRACEABILITY_MATRIX.yaml` row with `spec_link` + `code_links` + `test_links`
6. Run `make awp-render`
