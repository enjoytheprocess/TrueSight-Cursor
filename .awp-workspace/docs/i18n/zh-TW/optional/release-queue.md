# 發布佇列（Release Queue）

**觸發條件**：當已完成的建置工作進入部署管道，且發布候選需要明確追蹤時添加此模組。當專案使用 workspace-deployment 或類似工具，讀取候選記錄以確定部署摘要範圍時，這最為有用。

## 檔案

| 檔案 | 角色 |
|------|------|
| `4-sync/RELEASE_QUEUE.yaml` | 有效的發布候選和已發布記錄 |
| `4-sync/archive/RELEASE_QUEUE.yaml` | 已放棄的記錄 |

## 運作方式

同步（Sync）在已完成的工作被批准出貨時建立 `release_state: candidate` 記錄。每個記錄包含：
- `release_type` — `feature`（功能）| `bugfix`（錯誤修復）| `performance`（效能）| `architecture`（架構）| `mixed`（混合）
- `task_ids` — 此發布中包含的任務
- `capability_ids` — 相關的能力 ID（非功能發布時為空）
- `components` — `{name, version}` 對的清單；workspace-deployment 讀取這些來填充部署摘要中的 `scope[].ref`
- `target_date`（目標日期）

發布候選不受能力或里程碑邊界的限制——發布可以包括任意組合的已完成任務。使用 `release_type` 區分工作的性質。

**狀態轉換**：
- `candidate` → `released` — 部署確認後；在與部署相同的同步（Sync）週期中更新記錄
- `candidate` → `abandoned` — 部署前撤回候選；將記錄移至封存

`make populate`（workspace-deployment）讀取此檔案中的 `candidate` 記錄，以自動填充部署摘要。

## 與迴圈的連接

發布佇列在同步（Sync）時撰寫，在 G&D 分類完成後。任務必須達到 `done`（同步（Sync）完成）才有資格成為候選記錄。同步（Sync）也在同一次中將 `ROADMAP.yaml` 能力更新為 `completed`。
