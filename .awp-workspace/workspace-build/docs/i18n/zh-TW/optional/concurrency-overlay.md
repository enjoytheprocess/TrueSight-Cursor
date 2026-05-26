# 並發協調層（Concurrency Overlay）

適用於需要並行設計/建置/驗證活動，或多個人類和代理同時工作的工作空間的選用協調層。

不要預設採用此功能。
只有在預設的單一所有者、低協調路徑不再足夠時才使用它。

## 何時選擇加入
- 設計（Design）在已准入的建置（Build）或驗證（Verify）工作仍活躍時繼續進行
- 超過一個人類或代理同時編輯
- 所有權在任務生命週期中頻繁變換
- 共享合約或跨領域檔案使意外重疊的可能性很高

## 設計目標
保持核心工作流程不變。
鉤入現有的選用登記表，而非擴展預設的佇列 schema。

主要工件：
- `2-build/LOCKS.md`
- `4-sync/HANDOFFS.md`

## 啟用規則
1. 在 `2-build/WORK_QUEUE.md` 的每個佇列列中保持一個活躍的所有者。
2. 在實際可行時，將並行工作拆分為獨立的任務列。
3. 使用 `Mode = parallel` 標記並行任務。
4. 在編輯共享檔案或目錄之前，在 `2-build/LOCKS.md` 中聲明窄範圍的鎖定。
5. 在 `4-sync/HANDOFFS.md` 中記錄所有者或生命週期轉移。
6. 如果設計在執行期間移動，在 `3-verify/GAPS_AND_DEVIATIONS.yaml` 中記錄缺口或偏差，並在記錄中列出受影響的任務 ID。
7. 如果文件、程式碼或測試停止與預期行為匹配，在 `3-verify/TRACEABILITY_MATRIX.yaml` 中設定 `drift_status: drift_detected`，在 `3-verify/GAPS_AND_DEVIATIONS.yaml` 中建立對應記錄，並根據需要阻塞或將受影響的任務返回設計。

## 輕量備注慣例
為避免添加更多強制欄位，僅在此協調層啟用時，在 `2-build/WORK_QUEUE.md` 的 `Notes` 中使用簡短的結構化標記。

建議的標記：
- `baseline:<id>`：任務所針對的設計基準
- `review_owner:<human:name>`：預期的人類審查員
- `next_owner:<human:name|agent:name>`：下一個交接目標
- `scope:<path-or-contract>`：活躍鎖定或編輯表面，有助於可讀性時使用

範例：
`baseline:DESIGN-2026-04-02-A; review_owner:human:alex; next_owner:agent:verify-bot`

## 重新基準化規則
當設計在任務准入建置後發生變更時：

1. 讓不受影響的任務繼續進行。
2. 對受影響的任務，明確選擇一條路徑：
- 繼續在舊基準上，在 `WORK_QUEUE.md` 中添加備注
- 暫停並將任務移至 `blocked`
- 將任務移回 `design`
3. 不要讓受影響的工作在過時的假設集上靜默繼續。

## 退出規則
當並發爆發結束時停止使用協調層：
- 釋放活躍的鎖定
- 關閉已完成的交接
- 確保所有開放的 GAPS_AND_DEVIATIONS 記錄已透過同步（Sync）分類
- 當不再有用時，從佇列備注中移除過時的協調標記

然後在沒有任何額外協調負擔的情況下返回正常工作流程。
