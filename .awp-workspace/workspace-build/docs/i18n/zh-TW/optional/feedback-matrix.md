# 回饋矩陣（Feedback Matrix）

**觸發條件**：當人類審查員與實作者不同，且他們的觀察需要結構化記錄時添加此模組。若沒有此模組，人類回饋就沒有規範性的歸屬地，可能完全繞過缺口/偏差記錄。

## 檔案

| 檔案 | 角色 |
|------|------|
| `3-verify/FEEDBACK_MATRIX.yaml` | 有效的觀察記錄 |
| `3-verify/archive/FEEDBACK_MATRIX.yaml` | 已解決的觀察記錄 |

## 運作方式

人類不直接寫入 `GAPS_AND_DEVIATIONS.yaml`。流程是：

1. 人類審查員提供觀察（口頭、在審查評論中等）
2. 監聽代理將每個觀察擷取為 FM 記錄
3. 代理評估每個 FM 記錄並決定要做什麼：
   - 作為缺口或偏差推進至 G&D → 建立 `GAPS_AND_DEVIATIONS.yaml` 記錄，`source_ref` 指回 FM 記錄
   - 作為非問題關閉 → 在 FM 記錄中記錄推理
   - 標記為資訊性 → 不需要 G&D 記錄

FM 觀察類型：`observation`（觀察）| `issue`（問題）| `pass`（通過）| `regression`（退化）

這種間接性使 G&D 成為一個經過整理的、僅含信號的暫存登記表，而非任何人說的一切的原始傾倒。它也保留了歸因：缺口是由代理分析發現的，還是由人類審查員浮現的，都記錄在 `source_ref` 鏈中。

有外部追蹤器引用的 FM 記錄（例如 Jira 或 Linear 票據 ID）可以在可選的 `external_ref` 欄位中攜帶——從票據 → FM → G&D → DESIGN_INPUTS 的可追溯性鏈仍然完整。

## 與迴圈的連接

FM 是驗證（Verify）階段的工件。同步（Sync）分類 G&D 記錄後，產生它們的 FM 記錄可以被封存。作為非問題或資訊性關閉的 FM 記錄，可以在驗證（Verify）之後立即封存。
