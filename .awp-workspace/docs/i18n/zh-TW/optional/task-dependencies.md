# 任務依賴（Task Dependencies）

**觸發條件**：當任務間的上下游關係需要超出佇列排序單獨能表達的明確追蹤時添加此模組——通常是當一個任務的輸出是另一個任務的必要輸入，或一個任務的設計層級學習必須在另一個任務開始之前反饋至設計（Design）。

## 檔案

| 檔案 | 角色 |
|------|------|
| `2-build/TASK_DEPENDENCIES.yaml` | 依賴圖；每個 WORK_QUEUE 任務有對應的記錄 |
| `2-build/TASK_DEPENDENCIES.md` | 生成的視圖（不直接編輯；使用 `make render`） |

## 運作方式

兩種依賴類型，語義不同：

| 類型 | 含義 | 解除阻塞條件 |
|------|---------|-------------------|
| `build_depends_on`（建置依賴） | 下游只需要上游實作輸出存在 | 上游任務達到 `done` |
| `design_depends_on`（設計依賴） | 下游必須等待已驗證的上游學習和設計刷新 | 上游任務完成驗證（Verify）+ 同步（Sync），且設計（Design）在重新准入下游任務之前更新規格 |

`unblocks` 是反向的——它列出一旦此任務的依賴解決，可以執行的任務。

`WORK_QUEUE.yaml` 中的每個任務都必須在此檔案中有對應的記錄。在准入時添加的新任務，在知道依賴之前，得到一個設 `build_depends_on: none` 和 `design_depends_on: none` 的列。

## 與迴圈的連接

在建置開始時：檢查當前任務的 `design_depends_on`。若任何列出的任務尚未完成同步（Sync）且規格尚未刷新，則任務尚未安全建置——在 TASK_READINESS 中建立 G&D 缺口記錄並將任務返回 `needs_detail`。
