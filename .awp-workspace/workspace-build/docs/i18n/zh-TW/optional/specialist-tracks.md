# 專家分析軌道（Specialist Analysis Tracks）

當任務觸及具有明確定義的關切模式的領域——安全、實驗、事故回應、資料遷移或 API 合約——代理在正常工作流程中就地應用專家層級的思考，而不是等待人類專家。

`advisor_track` 欄位標記需要哪種類型的分析。`advisor_status` 欄位追蹤該分析是否完成。

## 分析類型

- `security`（安全）：威脅暴露、驗證/授權變更、敏感資料處理、輸入驗證、合規風險。
- `experiment`（實驗）：帶有指標、推出限制和決策標準的假設驅動變更。
- `incident`（事故）：需要遏制、根本原因分析和糾正措施的生產/服務失敗。
- `data_migration`（資料遷移）：需要記錄回滾路徑、向後相容性窗口和遷移前/後驗證的 schema 或資料變更。
- `api_contract`（API 合約）：需要向後相容性分析、版本決策和消費者影響評估的共享或對外介面變更。

每個任務一種分析類型是預設值。若任務真正需要兩種類型，為次要關切建立一個子任務。

## 何時應用專家分析

當任何條件為真時應用 `advisor_track`：
1. 變更觸及驗證、授權、密鑰、加密或敏感資料 → `security`
2. 任務引入必須用明確指標驗證的行為不確定性 → `experiment`
3. 即時問題影響可靠性、可用性或資料正確性 → `incident`
4. 任務修改資料庫 schema、遷移儲存的資料，或以需要回滾路徑的方式變更資料格式 → `data_migration`
5. 任務更改 `stable`（穩定）或 `beta`（測試版）介面（端點、事件、SDK 類型、協議），或引入任何新的對外介面 → `api_contract`

元件 README 中每個介面上標注的穩定性層級是條件 5 的觸發信號：`stable` → 必要，`beta` → 建議，`internal` → 不必要。

對於其他專家關切（資料庫設計、基礎設施、效能）：
- 若不需要正式閘門，在任務備注、設計文件或 `1-design/QUALITY_REQUIREMENTS.md` 中記錄指引。
- 若關切變得實質性，建立一個子任務。

## 分析生命週期

1. **設計（Design）** — 識別關切類型；在 `1-design/TASK_READINESS.yaml` 中設定 `advisor_track` 和 `advisor_status`。
2. **建置（Build）** — 在 `3-verify/` 中開啟對應的分析記錄；在實作時逐步解決相關問題。
3. **驗證（Verify）** — 確認結果已記錄，殘留風險已確認。
4. **閘門解決** — 分析完成且結果已記錄後，在 `TASK_READINESS.yaml` 中設定 `advisor_status: complete`。

分析與主要任務同步進行。只有當專家工作本身成為具有自己範圍、所有者或時程的獨立可交付物時，才建立子任務。

## 閘門語義

在 `1-design/TASK_READINESS.yaml` 中：

```yaml
advisor_track: security    # security | experiment | incident | data_migration | api_contract | none
advisor_status: pending    # not_required | pending | complete
```

- `not_required`：此任務不需要顧問分析。
- `pending`：分析是必要的且尚未完成；設定時阻塞建置准入。
- `complete`：分析完成；結果已記錄在分析記錄中。

`complete` 由**代理**設定——它意味著分析已完成，而非人工已簽核。人工授權閘門是獨立的 `specialist_sign_off` 結構（見下方**人工專家簽核**）。

若分析浮現出代理無法解決的問題（架構歧義、需要人工判斷的合規問題），在 `3-verify/GAPS_AND_DEVIATIONS.yaml` 中建立 `gap` 記錄，並注明需要設計（Design）或人工輸入。

## 分析記錄

| 類型 | 記錄檔案 | 範本 |
|---|---|---|
| 安全 | `3-verify/SECURITY_REVIEWS.md` | `3-verify/templates/SECURITY_ANALYSIS_TEMPLATE.md` |
| 實驗 | `3-verify/EXPERIMENT_REVIEWS.md` | `3-verify/templates/EXPERIMENT_PLAN_TEMPLATE.md` |
| 事故 | `3-verify/INCIDENT_RESPONSES.md` | `3-verify/templates/INCIDENT_RESPONSE_TEMPLATE.md` |
| 資料遷移 | `3-verify/DATA_MIGRATION_REVIEWS.md` | `3-verify/templates/DATA_MIGRATION_REVIEW_TEMPLATE.md` |
| API 合約 | `3-verify/API_CONTRACT_REVIEWS.md` | `3-verify/templates/API_CONTRACT_REVIEW_TEMPLATE.md` |

每個任務使用範本作為章節格式添加一個記錄。`make docs-check` 在 `advisor_track ≠ none` 時驗證支援檔案存在。

## 選擇分析類型

- `security` — 當風險、驗證、密鑰、授權或敏感資料是主要關切時。
- `experiment` — 當假設驗證、推出指標和護欄是主要關切時。
- `incident` — 當即時服務遏制、恢復和糾正措施是主要關切時。
- `data_migration` — 當 schema 變更、資料回填或格式遷移需要已測試的回滾路徑時。
- `api_contract` — 當共享或對外介面正在變更，且在任務關閉前必須評估消費者影響時。

## 非正式的專家關切

許多關切不需要正式軌道：

- 跨領域品質期望 → `1-design/QUALITY_REQUIREMENTS.md`
- 架構或合約決策 → `1-design/decisions/`
- 來自其他專家的領域指引 → 任務備注或子任務

## 範例：帶有安全分析的後端驗證

任務添加刷新令牌輪換。代理設定 `advisor_track: security`、`advisor_status: pending`。

在建置（Build）期間，代理開啟 `3-verify/SECURITY_REVIEWS.md`，添加一個新記錄，並逐步解決：
- 令牌輪換觸及哪些攻擊面？
- 存在哪些重放、無效化或儲存風險？
- 此實作中應用了哪些緩解措施？
- 哪些殘留風險是可接受的？

分析完成且結果已記錄後，代理設定 `advisor_status: complete`。

若有一個開放問題無法解決（例如合規需求不清楚），代理在 `GAPS_AND_DEVIATIONS.yaml` 中記錄它，並在解決之前不設定 `approved`。

## 範例：推出實驗

任務變更快取策略。代理設定 `advisor_track: experiment`、`advisor_status: pending`。

代理開啟 `3-verify/EXPERIMENT_REVIEWS.md`，在實作之前或期間定義假設、成功指標、護欄和決策策略。計畫已記錄且推出設計合理後，設定 `advisor_status: complete`。

## 範例：API 合約變更

任務重命名 `stable` 端點上的回應欄位。代理設定 `advisor_track: api_contract`、`advisor_status: pending`。

代理開啟 `3-verify/API_CONTRACT_REVIEWS.md`，添加一個新記錄，並逐步解決：
- 這是一個破壞性變更嗎？（是——欄位重命名不向後相容）
- 已知的消費者是誰？（從元件 README 下游消費者列表中）
- 版本策略是什麼？（添加新欄位，以移除窗口棄用舊欄位）
- 實作是否包括棄用路徑，還是立即破壞？

分析完成且版本決策已記錄後，代理設定 `advisor_status: complete`。若棄用窗口需要後續移除任務，代理在關閉之前建立它。

---

## 人工專家簽核（可選）

代理顧問（`advisor_track` / `advisor_status`）是代理驅動的——代理在完成分析後自我批准。對於要求正式人類領域專家批准的團隊，可以在頂部疊加一個獨立的**專家簽核**。

這是可選加入的。透過在需要的特定任務列或 G&D 記錄中添加以下欄位來啟用它——不要全局添加至不需要簽核的登記表。

### 何時使用

- 你的組織要求具名的人類批准安全、合規或架構決策，在工作進行或出貨之前。
- 代理顧問輸出是人類專家審查的輸入，而非本身的最終閘門。

### 三個閘門，三個階段

簽核可以在任意組合的階段要求。每個閘門阻塞它所守護的轉換。

**設計（Design）閘門** — 提議的設計是否符合標準？
阻塞 `readiness: ready_for_build`。添加至 `1-design/TASK_READINESS.yaml` 中的任務列：

```yaml
specialist_sign_off:
  domain: security          # security | architecture | compliance
  required_at: [design]     # 清單：design | verify | sync — 事先宣告所有階段
  design_status: pending    # pending | approved | waived
  design_approved_by: ""
  design_date: ""
  design_notes: ""
```

`design_status: approved` 僅在指定的人類審查並批准後設定。代理不得自我核准此欄位。

**驗證（Verify）閘門** — 實作是否符合標準？
阻塞任務驗收。當 `required_at` 中包含 `verify` 時，在將任務標記為 `accepted` 之前，在 `3-verify/SIGN_OFF.md` 中添加一個專家記錄：

```markdown
- **Specialist sign-off**:
  - Domain: security | architecture | compliance
  - Approved by: [name / role]
  - Date: [YYYY-MM-DD]
  - Notes: [conditions or "none"]
```

**同步（Sync）閘門** — 特定的偏差或缺口是否違反標準？
阻塞同步（Sync）時 G&D 記錄的封存。當偏差有領域敏感影響時，添加至 `3-verify/GAPS_AND_DEVIATIONS.yaml` 中的相關記錄：

```yaml
specialist_review:
  domain: security    # security | architecture | compliance
  status: pending     # pending | approved | waived
  approved_by: ""
  date: ""
  notes: ""
```

`specialist_review.status: pending` 的 G&D 記錄在專家批准或豁免之前不得封存。

### 與代理顧問共存

兩個閘門是獨立的，可以在同一任務上都要求。典型順序：
1. 代理完成其分析（`advisor_status: complete`）——結果記錄在 `3-verify/` 記錄中。
2. 人類專家閱讀代理的結果，進行自己的審查，並批准相關的階段閘門。

代理分析記錄作為人類審查的輸入，而非其替代。

### 啟用

不需要初始化步驟。將欄位添加至需要簽核的特定列或記錄，並在任務 `notes` 欄位中記錄指定的審查員，這樣要求在建置開始前就可見。
