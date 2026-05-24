# Git: commit (low tier)

Use the **lowest / fastest** model. Commit-only — do not read application code or AWP registers unless the user asks.

1. `git status` and `git diff` (staged + unstaged) only; optional `git log -5 --oneline` for message style.
2. Draft a concise commit message (why, not a file list). Use HEREDOC for `git commit -m`.
3. Stage only relevant paths; never commit secrets (`.env`, credentials).
4. Do not push unless the user explicitly asks.
5. If pre-commit fails, fix and create a **new** commit (do not amend unless user rules allow).

Do not run `make awp-*` unless register YAML is in the diff and the user asked.
