# IRG 評分（IRG Scoring）

實作就緒閘門（IRG）始終存在——它是防止建置（Build）在任務未就緒時開始的檢查。變化的是你應用它的正式程度。

## 預設模式：定性檢查

在低流程深度時，IRG 是一個兩問題的心智檢查：

1. **我知道完成看起來是什麼樣子嗎？** — 驗收標準是否足夠清晰，讓我在看到通過的實作時能認出它？
2. **我知道我在針對什麼建置嗎？** — 介面和合約是否足夠清晰，無需虛構假設就可以實作？

如果兩者都是肯定的，在 `TASK_READINESS.yaml` 中設定 `readiness: ready_for_build`，並在 `notes` 中簡要記錄推理。如果任何一個是否定的，保持在 `needs_detail`，並在 `blocking_unknowns` 中記錄阻塞問題。

此模式不需要 S/A/I/R/V 分數。`irg:` 區塊可以留空或完全省略。

## 完整模式：數值評分標準

**觸發條件**：當定性檢查不再足夠精確時升級至完整評分——通常是當多個任務同時進行、需要第二個審查員評估就緒性，或設計分歧使共享評分標準成為必要時。

五個維度，每個 0–2：

| 維度 | 含義 |
|-----|---------|
| `S` | 範圍和結果清晰度 |
| `A` | 驗收標準 |
| `I` | 介面和合約 |
| `R` | 依賴和風險 |
| `V` | 驗證計畫 |

**通過標準**：總分 ≥ 8，且 A = 2 和 I = 2 為必要條件。記錄在 `TASK_READINESS.yaml` 的 `irg:` 區塊中。

A 和 I 是硬性最低限制，因為它們是造成建置工作浪費的兩種失敗：未知的驗收標準意味著你不知道什麼時候完成；不清晰的介面意味著你將針對在整合時會破壞的假設進行實作。其他維度為 1 是已知的未知事項——在下一個迴圈中可以生存和恢復。

當閘門通過時，設定 `readiness: ready_for_build`，並將 `spec_link`、`advisor_track`、`advisor_status`、`quality_requirements` 和 `decision_links` 複製至對應的 `WORK_QUEUE.yaml` 記錄。WORK_QUEUE 然後是建置（Build）和驗證（Verify）期間這些欄位的權威來源——不要為它們重新開啟 TASK_READINESS。

## 檔案

`1-design/TASK_READINESS.yaml` — 兩種模式都使用。差異在於 `irg:` 區塊是否填入數值分數或作為定性備注留下。

`make docs-check` 強制執行的完整通過標準請見 `docs/optional/consistency-gates.md`。
