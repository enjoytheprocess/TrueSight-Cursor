# Ideation Backlog

**Trigger**: Add this module when direction or scope is still uncertain before committing to design. If you already know what you're building, skip it and start in Design.

## Files

| File | Role |
|------|------|
| `0-ideation/IDEATION_BACKLOG.yaml` | Active ideas — open entries only |
| `0-ideation/archive/IDEATION_BACKLOG.yaml` | Resolved entries (promoted / parked / dropped) |

## How it works

Ideas enter with `status: open`. Humans drive the discussion; agents record and organize notes. When an idea reaches a decision, set the outcome fields and move the entry to the archive file:

- `promoted` — idea has enough clarity to begin Design; set `promotion_target` to a feature ID or design area
- `parked` — worth revisiting but not now
- `dropped` — not worth pursuing; record the reason

No entry should linger in the active file at `open` without a current discussion thread. If it has gone stale, park or drop it.

## Connection to the loop

Ideation sits before Design. A promoted idea is the signal to open a feature entry in `1-design/DESIGN_STATES.yaml` and start writing a spec. Ideation does not replace Design — it is where you decide whether Design is warranted at all.
