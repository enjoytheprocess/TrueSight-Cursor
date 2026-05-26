# 任務佇列（Task Queue）

**觸發條件**：當多個任務同時進行，或階段頻繁中斷且你需要進行中和下一步工作的持久記錄時添加此模組。

## 檔案

| 檔案 | 角色 |
|------|------|
| `2-build/WORK_QUEUE.yaml` | 有效任務——從 todo 到 accepted |
| `2-build/archive/WORK_QUEUE.yaml` | 已完成的任務（done） |

## 運作方式

任務在設計（Design）准入（IRG 閘門通過）時以 `status: todo` 進入佇列。每個記錄保存任務的規格連結、顧問軌道、品質需求和決策連結的准入時快照——這樣設計（Design）可以繼續編輯 `TASK_READINESS.yaml`，而不會在有效的建置迴圈中造成偏移。

**狀態路徑**：
```
todo → in_progress → awaiting_human_review → accepted → done
```

- `in_progress`：代理已聲明任務
- `awaiting_human_review`：實作完成；人類透過 `3-verify/acceptance-gate.md` 做出接受/拒絕決策
- `needs_rework`：拒絕揭示了設計層級問題；任務在同步（Sync）後返回設計（Design）
- `blocked`：快速失敗路徑——缺口使繼續下去很危險；立即執行縮短版的驗證（Verify）+同步（Sync）
- `done`：同步（Sync）更新已完成；將記錄移至封存

在建置開始時，在拉取新工作之前先檢查 `needs_rework` 任務。

## 與迴圈的連接

佇列是主要的建置（Build）輸入。代理從它拉取，而不是從手動任務摘要。同步（Sync）將 `done` 記錄移至 `2-build/archive/WORK_QUEUE.yaml`，其 TASK_READINESS 列移至 `1-design/archive/TASK_READINESS.yaml`。
