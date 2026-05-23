# AWP: Verify handoff to human

1. Confirm evidence matches `spec_link` under `docs/`
2. Update `.awp-workspace/2-build/WORK_QUEUE.yaml`: `status: awaiting_human_review`
3. Set `validation` to commands actually run (e.g. `dotnet test`, `make awp-docs-check`)
4. Ensure `TRACEABILITY_MATRIX` `drift_status` is not `drift_detected`
5. Run `make awp-docs-check` && `make awp-render`
6. Human uses `.awp-workspace/3-verify/acceptance-gate.md` for accept/reject
