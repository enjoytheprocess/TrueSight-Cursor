# AWP: Log gap or deviation

Add entry to `.awp-workspace/workspace-build/3-verify/GAPS_AND_DEVIATIONS.yaml`:

```yaml
  - id: GD-XXX
    feature_id: FEAT-xxx
    task_id: TASK-xxx
    type: gap | deviation
    source: build | verify | human_feedback
    summary: "..."
    status: open
    severity: low | medium | high
```

If from feedback matrix, set `source_ref` to the FM entry id.

Run `make awp-render`. Triage in Sync → `4-sync/DESIGN_INPUTS.yaml` or update `docs/design/features/` spec.
