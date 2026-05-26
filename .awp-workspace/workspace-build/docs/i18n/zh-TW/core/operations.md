# 操作指令

此範本的操作指令。

## 前置需求

- **`yq`（mikefarah/yq v4）** — `make render`、`make docs-check` 和大多數 `meta/checks/` 腳本所需。
- **`graphviz`** — `make diagram` 將 `.dot` 原始檔渲染為 SVG 所需。

透過以下指令安裝兩者：
  ```bash
  make install-tools
  ```
  `yq` 預設安裝至 `~/.local/bin/`（可用 `YQ_INSTALL_DIR=<path>` 覆蓋）。Graphviz 透過系統套件管理器安裝（`apt`、`dnf` 或 `brew`）。

## 核心指令
- `make init`：使用工作空間設定任務初始化登記表，設定儲存庫模式和元件名稱，並可選擇性地清除進階登記表；同時呼叫 `make render`。
- `make render`：從 YAML 登記表檔案重新生成 `.md` 表格視圖。編輯任何 `.yaml` 登記表後執行。
- `make diagram`：渲染 `docs/diagrams/tiered-adoption.dot` → `docs/diagrams/tiered-adoption.svg`。編輯 `.dot` 原始檔後執行。
- `make init-smoke`：在一次性暫存複本中驗證引導指令。
- `make docs-check`：執行文件品質檢查。
- `make docs-boundary`：強制執行文件和階段檔案的編輯邊界。
- `make migrate-plan`：比較即時登記表的 schema 版本與預期版本，並列印哪些 schema_change 遷移尚未套用。從側載包升級時，將包的 upgrade-notes.md 作為參數傳入：`make migrate-plan ARGS=.workspace-template-inbox/<version>/upgrade-notes.md`。
- `make adapt-diff BUNDLE=<path>`：將消費者檔案與側載包進行比較。列出將被更新的 replace_reference_paths，並顯示 adapt_in_place_paths 的統一差異。將輸出作為本地代理適配階段的結構化輸入。
- `make roadmap-check`：驗證路線圖 schema 和佇列排程覆蓋。
- `make dependency-check`：驗證佇列到依賴的一致性。
- `make locks-check`：驗證並行作業的有效鎖定紀律。
- `make specialist-check`：驗證帶有專家顧問任務的顧問記錄支援。
- `make template-package`：在預設 `/tmp/workspace-template-releases` 下建立側載發布包。
- `make manifest-lint`：驗證 `workspace.manifest.yaml`。
- `make sync`：將元件儲存庫同步至 manifest 引用。
- `make status`：按元件顯示引用/dirty 偏移。
- `make verify`：執行每元件的驗證指令。
- `make ci-verify`：一次性執行 sync + verify + status。

## 文件檢查
- `meta/checks/check-canonicality.sh`
- `meta/checks/check-work-queue-columns.sh`
- `meta/checks/check-ready-queue-admission.sh`
- `meta/checks/check-roadmap-columns.sh`
- `meta/checks/check-task-dependencies.sh`
- `meta/checks/check-locks.sh`
- `meta/checks/check-doc-code-drift.sh`
- `meta/checks/check-specialist-gates.sh`
- `meta/checks/check-component-doc-contract.sh`
- `meta/checks/check-register-schema-versions.sh`

## 核心與進階檔案

具有終端狀態的登記表使用分割 YAML 模式：有效記錄在 `REGISTER.yaml`；已完成/終端記錄移至 `archive/REGISTER.yaml`。兩者都透過 `make render` 渲染至各自的 `.md` 視圖。切勿直接編輯 `.md` 檔案。

代理預設讀取 `REGISTER.yaml`（有效）。僅在需要歷史記錄時才開啟 `archive/REGISTER.yaml`。將已完成的記錄移出有效 YAML 是保持代理上下文精簡的方式。

核心階段檔案（有效 `.yaml` + 完成 `.yaml`；`.md` 檔案為生成的）：
- `1-design/PROJECT_BRIEF.md`（Markdown 敘述——直接編輯）
- `1-design/DESIGN_STATES.yaml` → `1-design/DESIGN_STATES.md`
- `1-design/TASK_READINESS.yaml` → `1-design/TASK_READINESS.md`
- `1-design/ROADMAP.yaml` + `1-design/archive/ROADMAP.yaml` → `.md` 視圖
- `2-build/WORK_QUEUE.yaml` + `2-build/archive/WORK_QUEUE.yaml` → `.md` 視圖
- `3-verify/TRACEABILITY_MATRIX.yaml` → `3-verify/TRACEABILITY_MATRIX.md`
- `3-verify/FEEDBACK_MATRIX.yaml` + `3-verify/archive/FEEDBACK_MATRIX.yaml` → `.md` 視圖
- `3-verify/GAPS_AND_DEVIATIONS.yaml` + `3-verify/archive/GAPS_AND_DEVIATIONS.yaml` → `.md` 視圖

選用進階階段檔案（opted in 時由 `make init` 部署）：
- `0-ideation/IDEATION_BACKLOG.yaml`
- `1-design/QUALITY_REQUIREMENTS.md`
- `2-build/TASK_DEPENDENCIES.yaml` → `2-build/TASK_DEPENDENCIES.md`
- `2-build/LOCKS.yaml` + `2-build/archive/LOCKS.yaml` → `.md` 視圖
- `2-build/TEMP_MEASURES.yaml`
- `3-verify/SIGN_OFF.md`
- `3-verify/SECURITY_REVIEWS.md`、`3-verify/EXPERIMENT_REVIEWS.md`、`3-verify/INCIDENT_RESPONSES.md`
- `4-sync/RELEASE_QUEUE.yaml` + `4-sync/archive/RELEASE_QUEUE.yaml` → `.md` 視圖
- `4-sync/HANDOFFS.md`

在以下情況使用進階檔案：
- 多個代理或負責人同時活躍
- 依賴鏈造成真正的執行歧義
- 設計變更或臨時例外需要明確記帳
- 需要正式驗收稽核軌跡（`SIGN_OFF.md`）
- 需要專家顧問分析

## 建議閱讀路徑
人類入職路徑：
- `README.md`
- `docs/core/workflow-summary.md`
- 當前階段檔案及任何連結的規格或元件文件

AI 執行路徑：
- `AGENTS.md`
- `2-build/WORK_QUEUE.yaml` 中的有效列（編輯用）或 `2-build/WORK_QUEUE.md`（閱讀用）
- `1-design/DESIGN_STATES.yaml`、`1-design/ROADMAP.yaml` 和 `3-verify/TRACEABILITY_MATRIX.yaml` 中的連結列
- 僅在任務實際使用時才開啟可選檔案

深度參考路徑：
- 當工作流程語義模糊時使用 `docs/core/workflow-reference.md`
- 術語需要澄清時使用 `docs/core/glossary.md`
- 專家顧問活躍時才開啟專家顧問檔案：
  - `3-verify/SECURITY_REVIEWS.md`
  - `3-verify/EXPERIMENT_REVIEWS.md`
  - `3-verify/INCIDENT_RESPONSES.md`
- 想看完整生命週期串聯時使用 `docs/guides/worked-example.md`

## 專家準備
當任務設定了 `advisor_track`（security、experiment 或 incident）時，讀取 `docs/optional/specialist-tracks.md`，並使用 `3-verify/templates/` 中對應的範本來組織分析。分析記錄完成後設定 `advisor_status: complete`。如果問題無法解決，在 `GAPS_AND_DEVIATIONS` 中建立記錄，並考慮透過同步（Sync）階段上報。

## 一致性與偏移控制
使用 `docs/optional/consistency-gates.md`。
若偵測到偏移，在 `3-verify/TRACEABILITY_MATRIX.yaml` 中設定 `drift_status: drift_detected`，在 `3-verify/GAPS_AND_DEVIATIONS.yaml` 中建立對應記錄，並阻塞或重新基準化受影響的任務。
若時程變更，在同一變更集中更新 `1-design/ROADMAP.md`。

`make docs-check` 對階段結構是安全的：
- 可選進階檢查在其特定階段檔案不存在時會乾淨地跳過

## 僅限文件邊界
若變更包含非文件/非階段區域（如檢查腳本、scripts 目錄、Makefile 或 manifest），`make docs-boundary` 會失敗，除非明確允許。

## Manifest 模式注意事項
- 使用固定引用以獲得確定性的多儲存庫工作。
- 僅在本地探索時使用 `HEAD`。
- 保持 `verify_command` 準確，以確保 `make verify` 可靠。

## 範本側載
- 新儲存庫生成、採用和升級流程請使用 `docs/guides/template-sideloading.md`。
- 發布元資料在 `template-release.yaml` 中。
- 使用 `make template-package` 為消費者儲存庫建立側載包。

## 代理專用設定

範本在 `templates/agents/claude/` 中提供 Claude Code 整合檔案。若您使用 Claude Code，在 `make init` 後一次性複製這些檔案：

- `templates/agents/claude/CLAUDE_TEMPLATE.md` → `CLAUDE.md`（專案根目錄）
- `templates/agents/claude/settings_TEMPLATE.json` → `.claude/settings.json`

`settings_TEMPLATE.json` 包含一個 `Stop` 鉤子，每次 Claude 轉換後自動執行 `make render`，使生成的 `.md` 表格視圖與 `.yaml` 登記表保持同步，無需手動干預。

這些檔案是代理專用的，不是核心工作流程的一部分。其他代理可以忽略此目錄。

## Pre-commit 鉤子（可選加入）

範本在 `templates/hooks/pre-commit` 中提供一個範例 pre-commit 鉤子，在每次提交前執行 `make docs-check`。安裝方式：

```bash
make install-hooks
```

這是刻意設計為可選加入的。有現有 pre-commit 工具的團隊可以手動將鉤子內容複製到自己的設定中。`make install-hooks` 不會覆蓋現有的 `.git/hooks/pre-commit`。

## 引導工作流程
在全新的直接使用工作空間中使用 `make init` 以：
- 以專案特定值渲染 `PROJECT_BRIEF.md`、`README.md` 和 `AGENTS.md`
- 使用準備完成的工作空間設定任務初始化 `WORK_QUEUE.yaml` 和 `TASK_READINESS.yaml`
- 讓 `DESIGN_STATES.yaml` 和 `TRACEABILITY_MATRIX.yaml` 空白，供第一個真實功能使用
- 可選擇性地清除工作空間尚未計畫使用的進階登記表

常見範例：

```bash
make init MODE=single PROJECT_NAME="Acme Workspace" COMPONENT_NAME=app
```
