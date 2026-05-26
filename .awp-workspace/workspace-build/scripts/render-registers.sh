#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

if ! command -v yq &>/dev/null; then
  echo "ERROR: yq is required but not installed. See https://github.com/mikefarah/yq" >&2
  exit 1
fi

GENERATED_COMMENT="<!-- Generated from {SOURCE} — do not edit directly. Run \`make render\` to update. -->"

# render_table SOURCE DEST TITLE HEADER SEPARATOR ROW_EXPR [SUBTITLE]
#
# Renders a plain markdown table from a YAML register.
# Used for narrow registers with no long-text fields.
render_table() {
  local source="$1"
  local dest="$2"
  local title="$3"
  local header="$4"
  local separator="$5"
  local row_expr="$6"
  local subtitle="${7:-}"

  local comment="${GENERATED_COMMENT/\{SOURCE\}/$source}"

  {
    echo "$comment"
    echo ""
    echo "# $title"
    echo ""
    if [[ -n "$subtitle" ]]; then
      echo "_${subtitle}_"
      echo ""
    fi
    echo "$header"
    echo "$separator"
    # yq emits a ghost `|  |` row when iterating an empty array; strip it.
    yq "$row_expr" "$REPO_ROOT/$source" 2>/dev/null | grep -v '^|  |$' || true
  } > "$REPO_ROOT/$dest"
}

# render_cards SOURCE DEST TITLE CARD_EXPR [SUBTITLE]
#
# Renders a card-per-entry layout from a YAML register.
# Each card has a compact table for structured short fields and
# labelled lines / blockquotes for prose fields.
render_cards() {
  local source="$1"
  local dest="$2"
  local title="$3"
  local card_expr="$4"
  local subtitle="${5:-}"

  local comment="${GENERATED_COMMENT/\{SOURCE\}/$source}"

  {
    echo "$comment"
    echo ""
    echo "# $title"
    echo ""
    if [[ -n "$subtitle" ]]; then
      echo "_${subtitle}_"
      echo ""
    fi
    yq "$card_expr" "$REPO_ROOT/$source" 2>/dev/null || true
  } > "$REPO_ROOT/$dest"
}

# ---------------------------------------------------------------------------
# WORK_QUEUE  /  WORK_QUEUE_DONE
# ---------------------------------------------------------------------------
WQ_CARD='.tasks[] |
  "\n---\n\n### " + .id + " · **" + .title + "**\n\n" +
  "| Feature | Component | Priority | Phase | Status | Mode | Capability |\n" +
  "| --- | --- | --- | --- | --- | --- | --- |\n" +
  "| " + (.feature_id // "") + " | " + (.component // "") + " | " + (.priority // "") +
  " | " + (.phase // "") + " | `" + (.status // "") + "` | " + (.mode // "") +
  " | " + (.capability // "") + " |\n\n" +
  "**Spec:** `" + (.spec_link // "—") + "`  \n" +
  "**Advisor track:** " + (.advisor_track // "none") + " · **Advisor status:** " + (.advisor_status // "") +
  " · **QRs:** " + (.quality_requirements // [] | (join(", ") | select(. != "")) // "—") +
  " · **Decisions:** " + (.decision_links // [] | (join(", ") | select(. != "")) // "—") + "  \n" +
  "**Owner:** " + (.owner // "") + " · **Lock:** " + (.lock_id // "") +
  " · **Target:** " + (.target_window // "") + "  \n" +
  "**Build deps:** " + (.build_dependencies // "") +
  " · **Design deps:** " + (.design_dependencies // "") + "  \n" +
  "**Validation:** `" + (.validation // "") + "`" +
  ((.notes | ("\n\n> " + .)) // "")'

if [[ -f "$REPO_ROOT/2-build/WORK_QUEUE.yaml" ]]; then
  render_cards \
    "2-build/WORK_QUEUE.yaml" "2-build/WORK_QUEUE.md" "Work Queue" \
    "$WQ_CARD" \
    "Active tasks. Move completed tasks to \`archive/WORK_QUEUE.yaml\`."
  echo "  2-build/WORK_QUEUE.md"
fi

if [[ -f "$REPO_ROOT/2-build/archive/WORK_QUEUE.yaml" ]]; then
  mkdir -p "$REPO_ROOT/2-build/archive"
  render_cards \
    "2-build/archive/WORK_QUEUE.yaml" "2-build/archive/WORK_QUEUE.md" "Work Queue — Done" \
    "$WQ_CARD" \
    "Completed tasks. Active tasks are in \`WORK_QUEUE.yaml\`."
  echo "  2-build/archive/WORK_QUEUE.md"
fi

# ---------------------------------------------------------------------------
# TASK_READINESS  /  TASK_READINESS_DONE
# ---------------------------------------------------------------------------
TR_CARD='.tasks[] |
  "\n---\n\n### " + .id + " · **" + .title + "**\n\n" +
  "| Feature | Component | Readiness | Advisor Track | Advisor Status |\n" +
  "| --- | --- | --- | --- | --- |\n" +
  "| " + (.feature_id // "") + " | " + (.component // "") +
  " | `" + (.readiness // "") + "` | " + (.advisor_track // "") +
  " | " + (.advisor_status // "") + " |\n\n" +
  "| S | A | I | R | V |\n" +
  "| --- | --- | --- | --- | --- |\n" +
  "| " + (.irg.S | tostring) +
  " | " + (.irg.A | tostring) +
  " | " + (.irg.I | tostring) +
  " | " + (.irg.R | tostring) +
  " | " + (.irg.V | tostring) + " |\n\n" +
  "**Blocking unknowns:** " + (.blocking_unknowns // "none") + "\n\n" +
  "**Spec:** `" + (.spec_link // "—") + "`  \n" +
  "**QRs:** " + (.quality_requirements // [] | join(", ") | . // "—") + "  \n" +
  "**Decisions:** " + (.decision_links // [] | join(", ") | . // "—") +
  ((.notes | ("\n\n> " + .)) // "")'

if [[ -f "$REPO_ROOT/1-design/TASK_READINESS.yaml" ]]; then
  render_cards \
    "1-design/TASK_READINESS.yaml" \
    "1-design/TASK_READINESS.md" \
    "Task Readiness Register" \
    "$TR_CARD" \
    "Active tasks. Move completed tasks (WORK_QUEUE status: done) to \`archive/TASK_READINESS.yaml\` during Sync."
  echo "  1-design/TASK_READINESS.md"
fi

if [[ -f "$REPO_ROOT/1-design/archive/TASK_READINESS.yaml" ]]; then
  mkdir -p "$REPO_ROOT/1-design/archive"
  render_cards \
    "1-design/archive/TASK_READINESS.yaml" \
    "1-design/archive/TASK_READINESS.md" \
    "Task Readiness Register — Done" \
    "$TR_CARD" \
    "Completed tasks. Active tasks are in \`TASK_READINESS.yaml\`."
  echo "  1-design/archive/TASK_READINESS.md"
fi

# ---------------------------------------------------------------------------
# FEATURE_REGISTRY  (permanent — no done split) — stays as table
# ---------------------------------------------------------------------------
if [[ -f "$REPO_ROOT/1-design/FEATURE_REGISTRY.yaml" ]]; then
  render_table \
    "1-design/FEATURE_REGISTRY.yaml" \
    "1-design/FEATURE_REGISTRY.md" \
    "Feature Registry" \
    "| Feature ID | Title | Components | Created On |" \
    "| --- | --- | --- | --- |" \
    '.features[] | [.id // "", .title // "", (.components // [] | join(", ")), .created_on // ""] | "| " + join(" | ") + " |"'
  echo "  1-design/FEATURE_REGISTRY.md"
fi

# ---------------------------------------------------------------------------
# DESIGN_STATES  /  DESIGN_STATES_DONE
# ---------------------------------------------------------------------------
DS_CARD='.features[] |
  "\n---\n\n### " + .feature_id + " · **" + (.title // .feature_id) + "**\n\n" +
  "| Design State | Owner | Last Updated |\n" +
  "| --- | --- | --- |\n" +
  "| `" + (.design_state // "") + "` | " + (.owner // "") + " | " + (.last_updated // "") + " |\n\n" +
  "**Linked idea:** " + (.linked_idea // "none") +
  " · **Tasks:** " + (.linked_tasks // [] | join(", ") | . // "—") + "  \n" +
  "**Spec:** `" + (.primary_design_link // "—") + "`  \n" +
  "**Decisions:** " + (.decision_links // [] | join(", ") | . // "—") + "  \n" +
  "**Blocking questions:** " + (.blocking_questions // "none") +
  ((.notes | ("\n\n> " + .)) // "")'

if [[ -f "$REPO_ROOT/1-design/DESIGN_STATES.yaml" ]]; then
  render_cards \
    "1-design/DESIGN_STATES.yaml" \
    "1-design/DESIGN_STATES.md" \
    "Design States Register" \
    "$DS_CARD" \
    "Active design triage. Move complete features to \`archive/DESIGN_STATES.yaml\` during Sync."
  echo "  1-design/DESIGN_STATES.md"
fi

if [[ -f "$REPO_ROOT/1-design/archive/DESIGN_STATES.yaml" ]]; then
  mkdir -p "$REPO_ROOT/1-design/archive"
  render_cards \
    "1-design/archive/DESIGN_STATES.yaml" \
    "1-design/archive/DESIGN_STATES.md" \
    "Design States — Done" \
    "$DS_CARD" \
    "Completed features. Active design triage is in \`DESIGN_STATES.yaml\`."
  echo "  1-design/archive/DESIGN_STATES.md"
fi

# ---------------------------------------------------------------------------
# CONTRACTS  (optional, no done split)
# ---------------------------------------------------------------------------
CT_CARD='.contracts[] |
  "\n---\n\n### " + .id + " · `" + .status + "`\n\n" +
  "| Agreed Date | Producers | Consumers |\n" +
  "| --- | --- | --- |\n" +
  "| " + (.agreed_date // "—") + " | " + (.producers // [] | join(", ")) +
  " | " + (.consumers // [] | join(", ")) + " |\n\n" +
  "**Description:** " + (.description // "") +
  ((.details | to_entries | map("  \n**" + .key + ":** " + (.value | tostring)) | join("")) // "") +
  ((.notes | ("\n\n> " + .)) // "")'

if [[ -f "$REPO_ROOT/1-design/CONTRACTS.yaml" ]]; then
  render_cards \
    "1-design/CONTRACTS.yaml" "1-design/CONTRACTS.md" "Interface Contracts" \
    "$CT_CARD" \
    "Shared interface boundaries agreed at design merge. See \`docs/optional/contracts.md\`."
  echo "  1-design/CONTRACTS.md"
fi

# ---------------------------------------------------------------------------
# ROADMAP  /  ROADMAP_DONE
# ---------------------------------------------------------------------------
RM_CARD='.capabilities[] |
  "\n---\n\n### " + .id + " · **" + .objective + "**\n\n" +
  "| Target Window | Status | Owner | Depends On |\n" +
  "| --- | --- | --- | --- |\n" +
  "| " + (.target_window // "") + " | `" + (.status // "") + "` | " +
  (.owner // "") + " | " + (.depends_on // "") + " |\n\n" +
  "**Feature IDs:** " + (.feature_ids // [] | (join(", ") | select(. != "")) // "—") +
  ((.notes | ("\n\n> " + .)) // "")'

if [[ -f "$REPO_ROOT/1-design/ROADMAP.yaml" ]]; then
  render_cards \
    "1-design/ROADMAP.yaml" "1-design/ROADMAP.md" "Roadmap" \
    "$RM_CARD" \
    "Active capabilities. Move completed/parked capabilities to \`archive/ROADMAP.yaml\`."
  echo "  1-design/ROADMAP.md"
fi

if [[ -f "$REPO_ROOT/1-design/archive/ROADMAP.yaml" ]]; then
  mkdir -p "$REPO_ROOT/1-design/archive"
  render_cards \
    "1-design/archive/ROADMAP.yaml" "1-design/archive/ROADMAP.md" "Roadmap — Done" \
    "$RM_CARD" \
    "Completed and parked capabilities. Active capabilities are in \`ROADMAP.yaml\`."
  echo "  1-design/archive/ROADMAP.md"
fi

# ---------------------------------------------------------------------------
# TRACEABILITY_MATRIX  (no done split)
# ---------------------------------------------------------------------------
TRX_CARD='.features[] |
  "\n---\n\n### " + .id + "\n\n" +
  "| Spec | Last Synced | Drift Status | Owner |\n" +
  "| --- | --- | --- | --- |\n" +
  "| " + (.spec_link // "") + " | " + (.last_synced // "") +
  " | `" + (.drift_status // "") + "` | " + (.owner // "") + " |\n\n" +
  "**Task IDs:** " + (.task_ids // [] | (join(", ") | select(. != "")) // "—") + "  \n" +
  "**Code links:** " + (.code_links // [] | (join(", ") | select(. != "")) // "—") + "  \n" +
  "**Test links:** " + (.test_links // [] | (join(", ") | select(. != "")) // "—") +
  ((.notes | ("\n\n> " + .)) // "")'

if [[ -f "$REPO_ROOT/3-verify/TRACEABILITY_MATRIX.yaml" ]]; then
  render_cards \
    "3-verify/TRACEABILITY_MATRIX.yaml" \
    "3-verify/TRACEABILITY_MATRIX.md" \
    "Feature Traceability Matrix" \
    "$TRX_CARD"
  echo "  3-verify/TRACEABILITY_MATRIX.md"
fi

# ---------------------------------------------------------------------------
# IDEATION_BACKLOG  /  IDEATION_BACKLOG_DONE  (optional)
# ---------------------------------------------------------------------------
IB_CARD='.ideas[] |
  "\n---\n\n### " + .id + " · **" + .title + "**\n\n" +
  "| Status | Date | Components |\n" +
  "| --- | --- | --- |\n" +
  "| `" + (.status // "") + "` | " + (.date // "") +
  " | " + (.components // [] | join(", ")) + " |\n\n" +
  "**Summary:** " + (.summary // "") +
  ((.outcome.decision | ("\n\n**Decision:** `" + . + "`  \n**Promotion target:** " + ((.outcome.promotion_target // "—")))) // "")'

if [[ -f "$REPO_ROOT/0-ideation/IDEATION_BACKLOG.yaml" ]]; then
  render_cards \
    "0-ideation/IDEATION_BACKLOG.yaml" "0-ideation/IDEATION_BACKLOG.md" "Ideation Backlog" \
    "$IB_CARD" \
    "Open ideas. Move promoted, parked, or dropped entries to \`archive/IDEATION_BACKLOG.yaml\`."
  echo "  0-ideation/IDEATION_BACKLOG.md"
fi

if [[ -f "$REPO_ROOT/0-ideation/archive/IDEATION_BACKLOG.yaml" ]]; then
  mkdir -p "$REPO_ROOT/0-ideation/archive"
  render_cards \
    "0-ideation/archive/IDEATION_BACKLOG.yaml" "0-ideation/archive/IDEATION_BACKLOG.md" "Ideation Backlog — Done" \
    "$IB_CARD" \
    "Resolved ideas. Open ideas are in \`IDEATION_BACKLOG.yaml\`."
  echo "  0-ideation/archive/IDEATION_BACKLOG.md"
fi

# ---------------------------------------------------------------------------
# QUALITY_REQUIREMENTS  /  QUALITY_REQUIREMENTS_DONE  (optional)
# ---------------------------------------------------------------------------
QR_CARD='.requirements[] |
  "\n---\n\n### " + .id + "\n\n" +
  "| Category | Enforcement | Scope | Applies To | Disposition |\n" +
  "| --- | --- | --- | --- | --- |\n" +
  "| " + (.category // "") + " | " + (.enforcement // "") + " | " + (.scope // "") +
  " | " + (.applies_to // "") + " | `" + (.disposition // "") + "` |\n\n" +
  "**Requirement:** " + (.requirement // "") + "  \n" +
  "**Validation:** " + (.validation // "") +
  ((.notes | ("\n\n> " + .)) // "")'

if [[ -f "$REPO_ROOT/1-design/QUALITY_REQUIREMENTS.yaml" ]]; then
  render_cards \
    "1-design/QUALITY_REQUIREMENTS.yaml" "1-design/QUALITY_REQUIREMENTS.md" "Quality Requirements Register" \
    "$QR_CARD" \
    "Active requirements. Move satisfied, superseded, or dropped entries to \`archive/QUALITY_REQUIREMENTS.yaml\`."
  echo "  1-design/QUALITY_REQUIREMENTS.md"
fi

if [[ -f "$REPO_ROOT/1-design/archive/QUALITY_REQUIREMENTS.yaml" ]]; then
  mkdir -p "$REPO_ROOT/1-design/archive"
  render_cards \
    "1-design/archive/QUALITY_REQUIREMENTS.yaml" "1-design/archive/QUALITY_REQUIREMENTS.md" "Quality Requirements — Done" \
    "$QR_CARD" \
    "Resolved requirements. Active requirements are in \`QUALITY_REQUIREMENTS.yaml\`."
  echo "  1-design/archive/QUALITY_REQUIREMENTS.md"
fi

# ---------------------------------------------------------------------------
# TEMP_MEASURES  /  TEMP_MEASURES_DONE  (optional)
# ---------------------------------------------------------------------------
TM_CARD='.measures[] |
  "\n---\n\n### " + .id + " · **" + .summary + "**\n\n" +
  "| Scope | Status | Introduced On | Owner | Removal Target |\n" +
  "| --- | --- | --- | --- | --- |\n" +
  "| " + (.scope // "") + " | `" + (.status // "") + "` | " + (.introduced_on // "") +
  " | " + (.owner // "") + " | " + (.removal_target // "") + " |\n\n" +
  "**Exit trigger:** " + (.exit_trigger // "") + "  \n" +
  "**Linked tasks:** " + (.linked_tasks // [] | (join(", ") | select(. != "")) // "—")'

if [[ -f "$REPO_ROOT/2-build/TEMP_MEASURES.yaml" ]]; then
  render_cards \
    "2-build/TEMP_MEASURES.yaml" "2-build/TEMP_MEASURES.md" "Temporary Measures" \
    "$TM_CARD" \
    "Active measures. Move closed entries to \`archive/TEMP_MEASURES.yaml\` during Sync."
  echo "  2-build/TEMP_MEASURES.md"
fi

if [[ -f "$REPO_ROOT/2-build/archive/TEMP_MEASURES.yaml" ]]; then
  mkdir -p "$REPO_ROOT/2-build/archive"
  render_cards \
    "2-build/archive/TEMP_MEASURES.yaml" "2-build/archive/TEMP_MEASURES.md" "Temporary Measures — Done" \
    "$TM_CARD" \
    "Closed measures. Active measures are in \`TEMP_MEASURES.yaml\`."
  echo "  2-build/archive/TEMP_MEASURES.md"
fi

# ---------------------------------------------------------------------------
# TASK_DEPENDENCIES (optional, no done split) — stays as table
# ---------------------------------------------------------------------------
if [[ -f "$REPO_ROOT/2-build/TASK_DEPENDENCIES.yaml" ]]; then
  render_table \
    "2-build/TASK_DEPENDENCIES.yaml" \
    "2-build/TASK_DEPENDENCIES.md" \
    "Task Dependencies" \
    "| Task ID | Build Depends On | Design Depends On | Unblocks | Notes |" \
    "| --- | --- | --- | --- | --- |" \
    '.tasks[] | [.id // "", .build_depends_on // "", .design_depends_on // "", .unblocks // "", .notes // ""] | "| " + join(" | ") + " |"'
  echo "  2-build/TASK_DEPENDENCIES.md"
fi

# ---------------------------------------------------------------------------
# LOCKS  /  LOCKS_DONE  (optional) — stays as table
# ---------------------------------------------------------------------------
LK_HEADER="| Lock ID | Scope | Task ID | Owner | Claimed At (UTC) | Expected Release | Status | Reason |"
LK_SEP="| --- | --- | --- | --- | --- | --- | --- | --- |"
LK_COLS='.locks // [] | .[] | [.id // "", .scope // "", .task_id // "", .owner // "", .claimed_at // "", .expected_release // "", .status // "", .reason // ""] | "| " + join(" | ") + " |"'

if [[ -f "$REPO_ROOT/2-build/LOCKS.yaml" ]]; then
  render_table \
    "2-build/LOCKS.yaml" "2-build/LOCKS.md" "Locks (Parallel Mode)" \
    "$LK_HEADER" "$LK_SEP" "$LK_COLS" \
    "Active locks. Move released locks to \`archive/LOCKS.yaml\`."
  echo "  2-build/LOCKS.md"
fi

if [[ -f "$REPO_ROOT/2-build/archive/LOCKS.yaml" ]]; then
  mkdir -p "$REPO_ROOT/2-build/archive"
  render_table \
    "2-build/archive/LOCKS.yaml" "2-build/archive/LOCKS.md" "Locks — Done" \
    "$LK_HEADER" "$LK_SEP" "$LK_COLS" \
    "Released locks. Active locks are in \`LOCKS.yaml\`."
  echo "  2-build/archive/LOCKS.md"
fi

# ---------------------------------------------------------------------------
# FEEDBACK_MATRIX  /  FEEDBACK_MATRIX_DONE
# ---------------------------------------------------------------------------
FM_CARD='.entries[] |
  "\n---\n\n### " + .id + " · `" + .type + "` · `" + .status + "`\n\n" +
  "| Task | Feature | Severity | Tested By | Date |\n" +
  "| --- | --- | --- | --- | --- |\n" +
  "| " + (.task_id // "") + " | " + (.feature_id // "") + " | " + (.severity // "") +
  " | " + (.tested_by // "") + " | " + (.date // "") + " |\n\n" +
  "**Summary:** " + (.summary // "") +
  ((.diagnosis | ("\n\n**Diagnosis:** " + .)) // "") +
  ((.resolution | ("\n\n**Resolution:** " + .)) // "")'

if [[ -f "$REPO_ROOT/3-verify/FEEDBACK_MATRIX.yaml" ]]; then
  render_cards \
    "3-verify/FEEDBACK_MATRIX.yaml" "3-verify/FEEDBACK_MATRIX.md" "Human Feedback Matrix" \
    "$FM_CARD" \
    "Open entries. Move resolved entries to \`archive/FEEDBACK_MATRIX.yaml\`."
  echo "  3-verify/FEEDBACK_MATRIX.md"
fi

if [[ -f "$REPO_ROOT/3-verify/archive/FEEDBACK_MATRIX.yaml" ]]; then
  mkdir -p "$REPO_ROOT/3-verify/archive"
  render_cards \
    "3-verify/archive/FEEDBACK_MATRIX.yaml" "3-verify/archive/FEEDBACK_MATRIX.md" "Human Feedback Matrix — Done" \
    "$FM_CARD" \
    "Resolved entries. Open entries are in \`FEEDBACK_MATRIX.yaml\`."
  echo "  3-verify/archive/FEEDBACK_MATRIX.md"
fi

# ---------------------------------------------------------------------------
# GAPS_AND_DEVIATIONS  /  GAPS_AND_DEVIATIONS_DONE
# ---------------------------------------------------------------------------
GD_CARD='.entries[] |
  "\n---\n\n### " + .id + " · `" + .type + "` · `" + .status + "`\n\n" +
  "| Feature | Source | Source Ref | Discovered In |\n" +
  "| --- | --- | --- | --- |\n" +
  "| " + (.feature_id // "") + " | " + (.source // "") + " | " +
  (.source_ref // "") + " | " + (.discovered_in_task // "") + " |\n\n" +
  "**Summary:** " + (.summary // "") +
  "\n\n**Resolution:** " + (.resolution_note // "—")'

if [[ -f "$REPO_ROOT/3-verify/GAPS_AND_DEVIATIONS.yaml" ]]; then
  render_cards \
    "3-verify/GAPS_AND_DEVIATIONS.yaml" "3-verify/GAPS_AND_DEVIATIONS.md" "Gaps and Deviations Staging" \
    "$GD_CARD" \
    "Open entries. Move promoted/resolved entries to \`archive/GAPS_AND_DEVIATIONS.yaml\`."
  echo "  3-verify/GAPS_AND_DEVIATIONS.md"
fi

if [[ -f "$REPO_ROOT/3-verify/archive/GAPS_AND_DEVIATIONS.yaml" ]]; then
  mkdir -p "$REPO_ROOT/3-verify/archive"
  render_cards \
    "3-verify/archive/GAPS_AND_DEVIATIONS.yaml" "3-verify/archive/GAPS_AND_DEVIATIONS.md" "Gaps and Deviations — Done" \
    "$GD_CARD" \
    "Promoted and resolved entries. Open entries are in \`GAPS_AND_DEVIATIONS.yaml\`."
  echo "  3-verify/archive/GAPS_AND_DEVIATIONS.md"
fi

# ---------------------------------------------------------------------------
# DESIGN_INPUTS (4-sync)
# ---------------------------------------------------------------------------
DI_CARD='.items[] |
  "\n---\n\n### " + .id + " · `" + .type + "` · `" + .status + "`\n\n" +
  "| Feature | Cycle | Source Ref |\n" +
  "| --- | --- | --- |\n" +
  "| " + (.feature_id // "") + " | " + (.cycle // "") + " | " + (.source_ref // "") + " |\n\n" +
  "**Summary:** " + (.summary // "") +
  ((.resolution_type | (
    "\n\n**Resolution:** `" + . + "`  \n" +
    "**Pointer:** " + ((.resolution_pointer // "—")) +
    ((.resolution_note | ("  \n**Note:** " + .)) // "")
  )) // "")'

if [[ -f "$REPO_ROOT/4-sync/DESIGN_INPUTS.yaml" ]]; then
  render_cards \
    "4-sync/DESIGN_INPUTS.yaml" \
    "4-sync/DESIGN_INPUTS.md" \
    "Design Inputs" \
    "$DI_CARD" \
    "Open items. Move resolved items to \`archive/DESIGN_INPUTS.yaml\`."
  echo "  4-sync/DESIGN_INPUTS.md"
fi

# ---------------------------------------------------------------------------
# RELEASE_QUEUE  /  RELEASE_QUEUE_DONE  (optional)
# ---------------------------------------------------------------------------
RQ_CARD='.entries[] |
  "\n---\n\n### " + .id + " · **" + .release_version + "**\n\n" +
  "| Type | State | Created | Target |\n" +
  "| --- | --- | --- | --- |\n" +
  "| " + (.release_type // "") + " | `" + (.release_state // "") + "` | " +
  (.created_date // "") + " | " + (.target_date // "") + " |\n\n" +
  "**Tasks:** " + (.task_ids // [] | (join(", ") | select(. != "")) // "—") + "  \n" +
  "**Capabilities:** " + (.capability_ids // [] | (join(", ") | select(. != "")) // "—") + "  \n" +
  "**Components:** " + (.components // [] | map(.name + " " + .version) | (join(", ") | select(. != "")) // "—") +
  ((.notes | ("\n\n> " + .)) // "")'

if [[ -f "$REPO_ROOT/4-sync/RELEASE_QUEUE.yaml" ]]; then
  render_cards \
    "4-sync/RELEASE_QUEUE.yaml" "4-sync/RELEASE_QUEUE.md" "Release Queue" \
    "$RQ_CARD" \
    "Active candidates. Move released/abandoned entries to \`archive/RELEASE_QUEUE.yaml\`."
  echo "  4-sync/RELEASE_QUEUE.md"
fi

if [[ -f "$REPO_ROOT/4-sync/archive/RELEASE_QUEUE.yaml" ]]; then
  mkdir -p "$REPO_ROOT/4-sync/archive"
  render_cards \
    "4-sync/archive/RELEASE_QUEUE.yaml" "4-sync/archive/RELEASE_QUEUE.md" "Release Queue — Done" \
    "$RQ_CARD" \
    "Released and abandoned entries. Active candidates are in \`RELEASE_QUEUE.yaml\`."
  echo "  4-sync/archive/RELEASE_QUEUE.md"
fi

# ---------------------------------------------------------------------------
# DESIGN_INPUTS archive (4-sync) — created on demand when DESIGN_INPUTS grows large
# ---------------------------------------------------------------------------
DA_CARD='.items[] |
  "\n---\n\n### " + .id + " · `" + .type + "`\n\n" +
  "| Feature | Source Input | Cycle Opened | Cycle Closed | Resolution |\n" +
  "| --- | --- | --- | --- | --- |\n" +
  "| " + (.feature_id // "") + " | " + (.source_input_id // "") + " | " +
  (.cycle_opened // "") + " | " + (.cycle_closed // "") +
  " | `" + (.resolution_type // "") + "` |\n\n" +
  "**Summary:** " + (.summary // "") + "  \n" +
  "**Pointer:** " + (.resolution_pointer // "—") +
  ((.resolution_note | ("\n\n> " + .)) // "")'

if [[ -f "$REPO_ROOT/4-sync/archive/DESIGN_INPUTS.yaml" ]]; then
  render_cards \
    "4-sync/archive/DESIGN_INPUTS.yaml" \
    "4-sync/archive/DESIGN_INPUTS.md" \
    "Design Archive" \
    "$DA_CARD"
  echo "  4-sync/archive/DESIGN_INPUTS.md"
fi

echo "Registers rendered."
