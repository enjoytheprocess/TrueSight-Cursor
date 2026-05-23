# 工作流程摘要

面向人類的簡短工作流程指南。

使用此文件取得單頁版本。
AI 執行時合約請使用 `AGENTS.md`。
需要完整工作流程參考時請使用 `docs/core/workflow-reference.md`。
僅在並行設計/建置/驗證工作或多使用者/多代理協調需要額外結構時，才使用 `docs/optional/concurrency-overlay.md`。

## 核心迴圈
可選的構思（Ideation）階段，然後是：

`設計（Design）-> 建置（Build）-> 驗證（Verify）-> 同步（Sync）`

```mermaid
flowchart LR
    I(["構思 Ideation（可選）"]):::opt --> D[設計 Design]
    D -->|任務准入| B[建置 Build]
    B --> V[驗證 Verify]
    V -->|需要返工| B
    V --> S[同步 Sync]
    S -->|開放項目| D
    classDef opt stroke-dasharray:5 5
```

**階段簡稱：**
- **驗證（Verify）**：「目前的任務是否令人滿意地解決了？」——任務範圍、實作品質
- **同步（Sync）**：「建置的內容是否符合設計所說的？」——設計範圍、對齊

## 規範性狀態檔案
- `1-design/PROJECT_BRIEF.md`：專案背景和限制
- `1-design/DESIGN_STATES.md`：功能設計成熟度
- `1-design/TASK_READINESS.md`：每任務的 IRG 分數、阻塞未知事項和建置准入
- `1-design/ROADMAP.md`：能力（功能分組）和目標窗口
- `2-build/WORK_QUEUE.md`：執行追蹤——負責人、狀態和階段
- `3-verify/TRACEABILITY_MATRIX.md`：規格/程式碼/測試連結
- `3-verify/FEEDBACK_MATRIX.md`：人工測試觀察
- `3-verify/GAPS_AND_DEVIATIONS.md`：暫存於同步（Sync）的設計缺口和偏差
- `4-sync/DESIGN_INPUTS.md`：下一個設計（Design）週期的開放缺口和偏差（設計開始時優先讀取）
- `4-sync/archive/DESIGN_INPUTS.yaml`：已解決的缺口和偏差（按需建立，當 DESIGN_INPUTS 變大時）

## 階段指南
| 階段 | 主要問題 | 優先更新這些檔案 | 退出條件 |
| --- | --- | --- | --- |
| 構思 Ideation（可選） | 問題或方向是否仍不確定？ | 使用中時更新 `0-ideation/IDEATION_BACKLOG.yaml` | 想法被推進、暫停或放棄 |
| 設計 Design | 我們在建置什麼，是否安全可實作？ | 先讀 `4-sync/DESIGN_INPUTS.md`（處理開放項目），然後 `DESIGN_STATES.md`、`TASK_READINESS.md`、`ROADMAP.md`、`WORK_QUEUE.md` | 開放的 DESIGN_INPUTS 項目已處理；任務達到 `ready_for_build` |
| 建置 Build | 我們能否安全實作准入的任務？ | 程式碼/測試、`WORK_QUEUE.md`、`TRACEABILITY_MATRIX.md`、缺口浮現時更新 `GAPS_AND_DEVIATIONS.md` | 實作完成；所有缺口/偏差已記錄 |
| 驗證 Verify | 目前的任務是否令人滿意地解決了？ | `FEEDBACK_MATRIX.md`（人工測試）、`GAPS_AND_DEVIATIONS.md`（推進項目）；任務移至 `awaiting_human_review` | 人工透過 `acceptance-gate.md` 接受；任務為 `accepted` |
| 同步 Sync | 建置的內容是否符合設計所說的？ | 將 `GAPS_AND_DEVIATIONS.md` 分類至 `DESIGN_INPUTS.md`（需要設計）或立即關閉（更新設計文件）；對齊 `WORK_QUEUE.md`、`ROADMAP.md`、`TRACEABILITY_MATRIX.md` | 所有 GAPS_AND_DEVIATIONS 已分類；DESIGN_INPUTS 已為下次設計更新 |

## 何時停止並快速失敗

如果建置（Build）過程中缺口累積到繼續下去很危險的程度——驗收標準或介面假設被證明無效，或解決一個缺口會引發連鎖反應——**立即停止並快速失敗**，而非繼續在破損的基礎上建置。

在破損設計上的每一步建置都會產生複合的偏差，需要更多文件修正，且有與其他已記錄規格衝突的風險。帶有清晰缺口記錄的阻塞建置，好過帶有連鎖偏差的完成建置。

**步驟：**
1. 停止建置；在 `WORK_QUEUE.md` 中將任務設為 `blocked`。
2. 在 `GAPS_AND_DEVIATIONS.md` 中記錄所有發現的缺口。
3. 在 `DESIGN_STATES.md` 中為該功能設定 `design_state: needs_redesign`。
4. 執行縮短版的驗證（Verify）+同步（Sync）：將所有開放的缺口和偏差推進至 `DESIGN_INPUTS.md`，無需完成完整的驗證迴圈。
5. 在下一個設計（Design）階段開始時，先處理開放的 `DESIGN_INPUTS` 項目，再准入新任務。

## 建置准入
任務在移至建置之前必須通過就緒閘門。閘門檢查設計清晰度、驗收標準、介面和可追溯性。完整標準請見 `docs/core/workflow-reference.md`，`make docs-check` 強制執行的內容請見 `docs/optional/consistency-gates.md`。

## 可選檔案依關切分類
| 關切 | 檔案 |
| --- | --- |
| 設計承諾前的不確定想法 | `0-ideation/IDEATION_BACKLOG.yaml` |
| 持久性非功能或跨領域需求 | `1-design/QUALITY_REQUIREMENTS.md` |
| 值得保留的架構或合約決策 | `1-design/decisions/` |
| 明確的任務依賴追蹤 | `2-build/TASK_DEPENDENCIES.md` |
| 並行作業協調 | `2-build/LOCKS.md` |
| 專家顧問介入 | `3-verify/SECURITY_REVIEWS.md`、`3-verify/EXPERIMENT_REVIEWS.md`、`3-verify/INCIDENT_RESPONSES.md`、`3-verify/DATA_MIGRATION_REVIEWS.md`、`3-verify/API_CONTRACT_REVIEWS.md` |
| 所有權轉移歷史 | `4-sync/HANDOFFS.md` |
| 有移除目標的臨時例外 | `2-build/TEMP_MEASURES.yaml` |
| 正式驗收稽核軌跡 | `3-verify/SIGN_OFF.md` |
| 高度並行協作的可選協調層 | `docs/optional/concurrency-overlay.md` |

## 預設指令
- `make init`
- `make init-smoke`
- `make docs-check`
- `make docs-boundary`

完整指令清單請使用 `docs/core/operations.md`。
