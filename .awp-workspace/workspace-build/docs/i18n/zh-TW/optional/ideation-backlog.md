# 構思待辦（Ideation Backlog）

**觸發條件**：當在承諾設計之前方向或範圍仍不確定時添加此模組。如果你已經知道你在建置什麼，跳過它並直接從設計（Design）開始。

## 檔案

| 檔案 | 角色 |
|------|------|
| `0-ideation/IDEATION_BACKLOG.yaml` | 有效的想法——僅開放記錄 |
| `0-ideation/archive/IDEATION_BACKLOG.yaml` | 已解決的記錄（推進/暫停/放棄） |

## 運作方式

想法以 `status: open` 進入。人類驅動討論；代理記錄和整理備注。當一個想法達到決策時，設定結果欄位並將記錄移至封存檔案：

- `promoted`（推進）— 想法有足夠的清晰度可以開始設計（Design）；將 `promotion_target` 設為功能 ID 或設計領域
- `parked`（暫停）— 值得重新審視但現在不是時候
- `dropped`（放棄）— 不值得追求；記錄原因

有效檔案中的記錄不應在沒有當前討論線索的情況下以 `open` 狀態停滯。如果已過期，暫停或放棄它。

## 與迴圈的連接

構思（Ideation）在設計（Design）之前。被推進的想法是在 `1-design/DESIGN_STATES.yaml` 中開啟功能記錄並開始撰寫規格的信號。構思（Ideation）不取代設計（Design）——它是你決定是否值得進行設計（Design）的地方。
