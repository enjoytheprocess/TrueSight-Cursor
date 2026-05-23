# 術語表

本範本中反覆出現的術語簡短定義。

## 顧問狀態（Advisor Status）
追蹤 AI 顧問分析狀態的欄位：`not_required`（無顧問軌道啟用中）、`pending`（分析尚未完成）或 `complete`（顧問已完成分析並在支援檔案中記錄結果）。由代理設定——不是人工核准。另見**專家簽核（Specialist Sign-off）**，了解人工授權閘門。

## 阻塞未知事項（Blocking Unknowns）
尚未解決的開放問題或缺失細節，使建置准入仍然不安全。

## 鎖定 ID（Lock ID）
佇列欄位，用於在並行作業協調啟用時指向對應的鎖定記錄。

## 模式（Mode）
佇列欄位，說明任務預期以 `sequential`（循序）還是 `parallel`（並行）方式執行。

## 建置依賴（Build Dependencies）
其已實作輸出足以解除下游工作阻塞的上游任務，即使在人工驗收之前也算。

## 設計依賴（Design Dependencies）
其已驗證結果必須在後續設計階段中被參考，才能繼續進行下游工作的上游任務。

## 功能（Feature）

設計、建置和驗證為一個完整整體的使用者可見或系統層級行為單元。永久記錄在 `FEATURE_REGISTRY.yaml` 中；透過 `DESIGN_STATES.yaml`、`TASK_READINESS.yaml` 和 `TRACEABILITY_MATRIX.yaml` 追蹤設計與建置進度。

三種容易混淆的工作類型：

| 類型 | 範例 | 記錄位置 |
|------|------|---------|
| **功能（Feature）** | API 端點、驗證流程、匯出功能、平台整合 | `FEATURE_REGISTRY.yaml` → 功能設計鏈 |
| **品質需求（Quality requirement）** | 可部署於 AWS、處理 1k req/s、符合 GDPR | `QUALITY_REQUIREMENTS.yaml` |
| **非功能任務（Non-feature task）** | CI 設定、資料庫遷移、儲存庫架構、依賴升級 | WORK_QUEUE 中的 `feature_id: none` |

判斷規則：若它具有驗收標準和介面，可交付一個新能力，則為功能。若它是適用於多個任務或功能的持久性非功能標準，則為品質需求。若它是沒有使用者可見輸出、無自己規格的支援性工作，則為非功能任務。

部署能力等運維考量處於邊界地帶。若該工作有實際規格、驗收標準和介面（部署設定、腳本、環境限制），則根據其是一次性可交付物還是持續性標準，模型化為功能或品質需求。若是直接的設定工作，則模型化為 `feature_id: none` 任務。

## 功能登記表（Feature Registry）
`1-design/FEATURE_REGISTRY.yaml` — 所有功能的永久身份記錄。保存 `id`、`title`、`components` 和 `created_on`。列記錄永不刪除。所有其他登記表透過此處的 `id` 值引用功能。與設計分類狀態分開。

## 設計狀態（Design State）
`1-design/DESIGN_STATES.yaml` 中功能的有效設計成熟度：`concept`（概念）、`spec_draft`（規格草稿）、`spec_review`（規格審查）、`ready`（就緒）、`needs_redesign`（需要重新設計）或 `complete`（完成）。只有在此處有有效記錄的功能才在設計或建置中；已完成的功能移至 `1-design/archive/DESIGN_STATES.yaml`。功能身份（id、title、components）在 `FEATURE_REGISTRY.yaml` 中，不在此處。

## 階段（Phase）
佇列欄位，將任務置於當前生命週期階段：`design`（設計）、`build`（建置）、`verify`（驗證）或 `sync`（同步）。

## 偏移狀態（Drift Status）
`3-verify/TRACEABILITY_MATRIX.md` 中針對某功能程式碼與其規格當前對齊狀態的閘門信號：`aligned`（對齊）、`review_needed`（需要審查）或 `drift_detected`（偵測到偏移）。`drift_detected` 阻塞進行中的任務；已接受/完成的任務需要 `aligned`。造成偏移的具體事件另外記錄在 `3-verify/GAPS_AND_DEVIATIONS.yaml` 中。

## 功能 ID（Feature ID）
功能層級工作切片的穩定識別符，用於連接設計、佇列、可追溯性和驗證狀態。

## IRG（實作就緒閘門，Implementation Readiness Gate）
用於決定任務是否可以安全拉入建置的評分模型。分數以緊湊格式 `S:v A:v I:v R:v V:v` 記錄在 `1-design/TASK_READINESS.md` 中。

## IRG 分數（IRG Score）
`TASK_READINESS.md` 中的緊湊格式 `S:v A:v I:v R:v V:v`，每個維度為 0–2。`ready_for_build` 需要總分 ≥ 8，且 A=2 和 I=2。通過標準在 `docs/optional/consistency-gates.md` 中。

## IRG 評分標準（IRG Scoring Rubric）
每個維度的 0/1/2 校準指南：

| 維度 | 0 — 未知 | 1 — 部分 | 2 — 明確 |
| --- | --- | --- | --- |
| **S** 範圍 | 目標或可交付物未定義；「完成」無共同認知 | 目標已理解，但邊緣情況、邊界或限制仍開放 | 結果與範圍邊界完全定義；範圍外已說明 |
| **A** 驗收 | 未撰寫驗收標準 | 標準存在但不完整、模糊或無法獨立測試 | 具體、可測試的標準涵蓋完整範圍；審查者可確認通過/失敗 |
| **I** 介面 | API、資料結構或整合點未知或未決定 | 介面已有草圖；部分細節仍開放（欄位類型、錯誤情況、驗證） | 所有相關介面完全指定；合約已與各方達成共識 |
| **R** 風險 | 尚未考慮依賴和風險 | 主要依賴和風險已識別；緩解措施尚未到位 | 依賴已解決或明確接受；已知風險有緩解措施 |
| **V** 驗證 | 未定義驗證方法 | 大致方法已知（例如「添加測試」）但具體事項未定義 | 具體的測試類型、覆蓋目標或驗證步驟已命名且可行 |

A 和 I 在任務准入建置前必須達到 2。若風險被接受，S、R 和 V 在准入時可以為 1——缺口成為下一個迴圈的輸入。

## 能力（Capability）
將多個功能組合在一起的連貫性分組，共同形成系統的一個可獨立測試、可使用的單元——在 `1-design/ROADMAP.md` 中追蹤。能力回答的問題是：「在這部分系統可以進行端對端測試之前，哪些功能需要完成？」它不是交付期限；它是具有邏輯邊界的功能束。

不服務於功能的基礎設施、工具、運維和設定任務應使用 `capability: none`。功能任務（`feature_id != none`）在啟用後（建置階段或之後）必須引用一個能力；在啟用中的功能任務上使用 `capability: none` 是規劃問題，會被 `make docs-check` 捕獲。

能力 ID 使用前綴 `CAP-`（例如 `CAP-001`）。

## needs_detail（需要細節）
`TASK_READINESS.md` 就緒值，表示任務仍缺乏足夠的設計清晰度、介面細節、風險處理或驗證規劃，無法安全進行建置工作。

## 專案摘要（Project Brief）
`1-design/PROJECT_BRIEF.md`，用於穩定的專案背景和限制，而非逐任務的執行狀態。

## 可建置（Ready for Build）
`TASK_READINESS.md` 就緒值，表示任務已通過 IRG 閘門（≥ 8/10，A=2，I=2），無阻塞未知事項，且可以安全地在 `WORK_QUEUE.md` 中晉升為 Phase=build。

## 顧問軌道（Advisor Track）
命名代理為任務執行哪種 AI 分析的欄位：`security`（安全）、`experiment`（實驗）、`incident`（事故）、`data_migration`（資料遷移）、`api_contract`（API 合約）或 `none`（無）。代理自行應用分析並在 `3-verify/` 的支援檔案中記錄結果。另見**專家簽核（Specialist Sign-off）**，了解人工授權閘門。

## 專家簽核（Specialist Sign-off）
可選的人工授權閘門，疊加在顧問軌道之上。一位具名的人類領域專家在設計（Design）、驗證（Verify）和/或同步（Sync）階段審查並批准（或豁免）工作。狀態值（`pending`、`approved`、`waived`）只能由指定的人類設定——代理不得自我核准這些欄位。完整的簽核結構見 `docs/optional/specialist-tracks.md`。

## 同步（Sync）
在驗證和人工驗收後，儲存庫狀態進行對齊的生命週期階段。

## 目標窗口（Target Window）
任務或能力的計畫交付窗口，例如 `2026-Q2` 或 `2026-04`。

## 可追溯性矩陣（Traceability Matrix）
`3-verify/TRACEABILITY_MATRIX.md`，將功能連接至規格、程式碼和測試引用，並記錄偏移狀態。

## 驗證（Validation）
佇列欄位，命名建置前預期的檢查，或記錄驗證階段產生的證據。

## 品質需求（Quality Requirements）
持久性非功能或跨領域標準的歸屬地：效能、安全、合規、運維態勢（例如可部署在特定平台上），以及適用於多個功能或任務的類似關切，而非一次性可交付物。定義於 `1-design/QUALITY_REQUIREMENTS.yaml`（可選登記表；當專案有值得明確追蹤的持久標準時啟用）。

`TASK_READINESS.yaml` 和 `WORK_QUEUE.yaml` 條目上的 `quality_requirements` 欄位列出適用於特定任務的 QR ID，其 `enforcement` 為 `per_task` 或 `milestone`。`sustained`（持續性）品質需求隱含地適用於所有任務，無需逐任務列出——代理在建置開始時從 `QUALITY_REQUIREMENTS.yaml` 讀取完整的 `sustained` 清單。

## 決策連結（Decision Links）
`TASK_READINESS.yaml` 和 `DESIGN_STATES.yaml` 中的結構化清單欄位（`decision_links`），保存 `1-design/decisions/` 中決策文件的相對路徑（ADR、部署決策、API 合約決策），這些文件影響了任務或功能的設計。無記錄決策時使用 `[]`。

## 執行強制（Enforcement）
品質需求欄位，分類需求在工作流程中的適用方式：
- `sustained` — 永久標準；適用於每個任務；永不全局滿足；代理在建置開始時讀取完整清單
- `per_task` — 每次發生相關類型任務時適用；在相符任務的 `TASK_READINESS.quality_requirements` 中連結
- `milestone` — 必須在特定事件或部署閘門之前滿足；在里程碑任務的 `TASK_READINESS.quality_requirements` 中連結

## 任務就緒登記表（Task Readiness Register）
`1-design/TASK_READINESS.md`，規範性設計准入記錄。保存 IRG 分數、阻塞未知事項、就緒決策和專家顧問追蹤。

## 規格連結（Spec Link）
`WORK_QUEUE.yaml` 欄位，保存任務設計規格的相對路徑（例如 `1-design/PROJECT_BRIEF.md` 或決策文件）。建置代理遵循此連結找到規格，無需載入 `TASK_READINESS.yaml`。

## 工作佇列（Work Queue）
`2-build/WORK_QUEUE.yaml`，任務階段、負責人、狀態、驗證和規格引用的規範性執行表。進行中的任務在此；已完成的任務移至 `2-build/archive/WORK_QUEUE.yaml`。設計就緒性（IRG 分數、品質需求連結、顧問閘門）在 `TASK_READINESS.yaml` 中。

## awaiting_human_review（等待人工審查）
佇列狀態，表示實作和驗證證據已準備好供人工簽核。

## accepted（已接受）
佇列狀態，表示人工已明確簽核結果。

## done（完成）
佇列狀態，表示工作已被接受，且同步/結案工件已完成。

## needs_rework（需要返工）
佇列狀態，表示發現了設計層級的問題——要麼是人工在驗證（Verify）時拒絕任務（根本原因是設計，而非實作），要麼是同步（Sync）發現設計不完整。始終與 `TASK_READINESS.Readiness = needs_detail` 一起設定。若在驗證時設定，同步（Sync）在下一個設計（Design）階段前仍必須執行。在下一個設計（Design）階段開始時，先處理 `needs_rework` 任務，再拉入新工作。

## direct-use（直接使用）
採用路徑，團隊從此範本直接作為工作空間並就地自訂。

## sideload/adapt（側載/適配）
採用路徑，現有工作空間在不替換專案自有狀態的情況下，逐步吸收此範本的發布版本。
