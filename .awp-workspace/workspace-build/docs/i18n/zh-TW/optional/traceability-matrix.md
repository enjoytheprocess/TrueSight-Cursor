# 可追溯性矩陣（Traceability Matrix）

**觸發條件**：當規格/程式碼/測試連結需要維護，且未記錄的變更需要可偵測時添加此模組。當涉及人類審查員、程式碼庫被多個貢獻者觸及，或需要合規稽核軌跡時特別有用。

## 檔案

| 檔案 | 角色 |
|------|------|
| `3-verify/TRACEABILITY_MATRIX.yaml` | 功能層級的連結和偏移狀態 |

## 運作方式

每個功能列宣告其合法的實作範圍：
- `spec_ref` — 功能所針對建置的規格或設計文件
- `code_refs` — 此功能「在範圍內」的程式碼路徑
- `test_refs` — 驗證功能的測試
- `drift_status` — `aligned`（對齊）或 `drift_detected`（偵測到偏移）

**偏移偵測**：當 `drift_status` 設為 `drift_detected` 時，必須在 `3-verify/GAPS_AND_DEVIATIONS.yaml` 中建立對應的記錄。只有在該 G&D 記錄為 `resolved_in_loop` 或 `promoted_to_sync` 後，才重置為 `aligned`。

TM 是**建置可寫的（Build-writable）** — 代理可以在建置（Build）和驗證（Verify）期間更新 `drift_status`。`DESIGN_STATES.yaml` 由設計（Design）擁有，在建置（Build）期間不得寫入（快速失敗路徑除外）。TM 是這個分離存在的關鍵原因：它給予建置（Build）一個可以在不觸碰設計（Design）記錄的情況下寫入的功能層級對齊信號。

在宣告的 `code_refs` **內部**的程式碼庫變更由 `drift_detected` 捕獲。在所有宣告範圍**之外**的變更由未連結變更工作流程規則捕獲（任何此類變更在階段結束前需要 G&D 偏差記錄）。

## 與迴圈的連接

同步（Sync）在分類後對齊 TM：一旦功能的所有任務都 `done` 且所有 G&D 記錄都已解決，功能列可以與其 DESIGN_STATES 記錄一起封存。
