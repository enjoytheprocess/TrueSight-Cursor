# Feedback Matrix

**Trigger**: Add this module when a human reviewer is distinct from the implementer and their observations need a structured record. Without this module, human feedback has no canonical home and may bypass the gap/deviation record entirely.

## Files

| File | Role |
|------|------|
| `3-verify/FEEDBACK_MATRIX.yaml` | Active observations |
| `3-verify/archive/FEEDBACK_MATRIX.yaml` | Resolved observations |

## How it works

Humans do not write to `GAPS_AND_DEVIATIONS.yaml` directly. The flow is:

1. Human reviewer provides observations (verbally, in a review comment, etc.)
2. A listening agent captures each observation as an FM entry
3. The agent evaluates each FM entry and decides what to do:
   - Promote to G&D as a gap or deviation → creates a `GAPS_AND_DEVIATIONS.yaml` entry with `source_ref` pointing back to the FM entry
   - Close as non-issue → record the reasoning in the FM entry
   - Mark as informational → no G&D entry needed

FM observation types: `observation` | `issue` | `pass` | `regression`

This indirection keeps G&D as a curated, signal-only staging register rather than a raw dump of everything anyone said. It also preserves attribution: whether a gap was found by agent analysis or by a human reviewer is recorded in the `source_ref` chain.

FM entries with an external tracker reference (e.g. a Jira or Linear ticket ID) can carry that in an optional `external_ref` field — the traceability chain from ticket → FM → G&D → DESIGN_INPUTS remains intact.

## Connection to the loop

FM is a Verify-stage artifact. After Sync triages G&D entries, the FM entries that produced them can be archived. FM entries that were closed as non-issues or informational can be archived immediately after Verify.
