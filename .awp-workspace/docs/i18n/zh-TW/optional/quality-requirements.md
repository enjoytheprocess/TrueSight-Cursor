# 品質需求（Quality Requirements）

**觸發條件**：當非功能或跨領域標準需要每任務執行時添加此模組——例如：回應時間預算、覆蓋率底線、資料保留規則，或適用於每個觸及特定領域的任務的安全基準。

## 檔案

| 檔案 | 角色 |
|------|------|
| `1-design/QUALITY_REQUIREMENTS.yaml` | 有效的需求 |
| `1-design/archive/QUALITY_REQUIREMENTS.yaml` | 終端記錄（已滿足/已取代/已放棄） |

## 運作方式

三種執行模式：

| 模式 | 含義 |
|------|---------|
| `sustained`（持續） | 永久標準；隱含地適用於所有任務。代理在建置開始時讀取完整的 `sustained` 清單——不需要明確的任務連結。 |
| `per_task`（每任務） | 每次發生相關類型的任務時適用。透過 `TASK_READINESS.yaml` 中的 `quality_requirements` 連結。 |
| `milestone`（里程碑） | 必須在特定事件或部署閘門之前滿足。在里程碑任務的 TASK_READINESS 記錄中連結。 |

每個需求必須有所有者，以及「已滿足」看起來是什麼樣子的清晰標準。`deferred`（延遲）的需求保留在有效檔案中——它們仍需要後續跟進；在 `notes` 中記錄連結的任務或臨時措施 ID。

終端處置（`satisfied` 已滿足、`superseded` 已取代、`dropped` 已放棄）移至封存檔案。

## 與迴圈的連接

在建置開始時：讀取所有 `sustained` 需求——它們隱含地適用於當前任務。對於其 WORK_QUEUE 記錄中有 `quality_requirements` 連結的任務，開啟 `QUALITY_REQUIREMENTS.yaml`，驗證每個連結的 `per_task` 或 `milestone` 需求是否在實作和驗證計畫中都得到處理。
