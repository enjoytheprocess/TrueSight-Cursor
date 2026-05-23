# Handoffs

**Trigger**: Add this module when task ownership transfers between people or agents and the transfer history matters — for example: when a human takes over a task an agent left partially complete, when an agent resumes work a human started, or when responsibility shifts across team members at a lifecycle stage boundary.

## File

`4-sync/HANDOFFS.md` — append-only log; one entry per transfer.

## How it works

Add an entry whenever a task changes owner or transitions lifecycle stage in a way that someone else needs to pick up from. Each entry records:
- **Date**
- **Task ID**
- **From / To** — who or what agent is handing off and who is picking up
- **Stage transition** — e.g. `in_progress → awaiting_human_review`
- **Summary** — what was done, what remains
- **Files changed** — the files touched during the outgoing owner's session
- **Validation performed** — what was checked before handoff
- **Open risks / follow-ups** — anything the incoming owner needs to be aware of

The log is append-only. Do not edit past entries — if a handoff summary was incomplete, add a correction entry referencing the original.

## Connection to the loop

Handoffs are typically written at the Verify or Sync stage when a task moves between owners. The incoming owner reads the handoff entry before resuming Build or making the accept/reject decision. The handoff log is not triaged by Sync — it is a historical record only.
