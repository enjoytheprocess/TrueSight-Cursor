# Ideation

Use this folder as a shared discussion space before committing to design work.

This `README.md` is the human stage guide.
`IDEATION_BACKLOG.md` is the canonical stage artifact.

## When to use ideation

- The problem framing or feature direction is still uncertain
- Multiple options are being explored before a design commitment
- An idea is worth capturing but not yet ready for design

Direct-to-design is fine when the feature is already clear enough to skip this stage.

## How it works

1. A human describes an idea in conversation.
2. The agent adds a new section to `IDEATION_BACKLOG.md` using `templates/IDEA_ENTRY_TEMPLATE.md` as the scaffold and updates the index table.
3. As discussion continues, the agent appends notes under **Discussion**.
4. When a decision is reached, the agent records the outcome and updates the status in both the section and the index.

## Promotion path

When an idea reaches `promoted`:
- Add or update a row in `1-design/DESIGN_STATES.md` for the feature.
- Record the promotion target (feature ID or design area) in the idea entry.

## Artifacts

- `IDEATION_BACKLOG.md` — index table + per-idea sections
- `templates/IDEA_ENTRY_TEMPLATE.md` — scaffold for a new idea section
