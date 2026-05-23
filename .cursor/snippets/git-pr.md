# Git: pull request (low tier)

Use the **lowest / fastest** model. PR packaging only — no feature implementation or spec review.

1. `git status`, `git diff`, tracking branch check, `git log` and `git diff <base>...HEAD` for PR scope only.
2. Push with `-u` only if needed and the user asked (or creating PR requires it).
3. `gh pr create` with Summary + Test plan (HEREDOC body).
4. Return the PR URL.

Do not explore the codebase beyond what the diff shows. Escalate model tier only if the user asks for architectural review in the same session.
