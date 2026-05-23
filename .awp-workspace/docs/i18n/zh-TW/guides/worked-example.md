# 實作範例

使用真實假設專案的完整生命週期具體演練。

**專案：** Snippets API — 用於儲存和取得程式碼片段的小型 REST API。
**模式：** 單一元件（`api`）
**負責人：** 開發團隊

此範例使用兩個任務：
- `SETUP-001`：初始化工作空間並連接程式碼儲存庫（設定）
- `TASK-001`：實作片段建立和取得端點（第一個功能）

---

## 1. `make init` 之後

```bash
make init MODE=single PROJECT_NAME="Snippets API" COMPONENT_NAME=api
```

登記表已使用起始列初始化。在任何建置工作開始前，替換所有這些列。

---

## 2. 設計（Design）：設定專案登記表

**開始設計（Design）階段——先讀取 DESIGN_INPUTS。**
在全新的工作空間中，`4-sync/DESIGN_INPUTS.md` 是空的——沒有前一個週期的開放項目。
設計（Design）可以直接進行專案定義。

一起更新所有五個登記表：

**`1-design/PROJECT_BRIEF.md`**（關鍵欄位）：
```
Project name: Snippets API
Problem: Developers need a simple, shareable store for code snippets.
Scope: REST API — create a snippet (POST /snippets), retrieve by ID (GET /snippets/:id).
Out of scope: user accounts, search, expiry in the first slice.
Primary owner: Dev Team
```

**`1-design/DESIGN_STATES.md`**：
| Feature ID | Linked Idea | Linked Task(s) | Component(s) | Design State | Owner | Blocking Questions | Last Updated | Notes |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| FEAT-001 | direct_to_design | TASK-001 | api | spec_draft | Dev Team | confirm storage backend (DB vs file) | 2026-04-05 | snippet create and retrieve |

**`1-design/ROADMAP.md`**：
| Milestone ID | Target Window | Objective | Feature ID(s) | Depends On | Status | Owner | Notes |
| --- | --- | --- | --- | --- | --- | --- | --- |
| M-001 | 2026-Q2 | Working snippet API with create and retrieve | FEAT-001 | none | active | Dev Team | |

**`1-design/TASK_READINESS.md`**：
| Task ID | Feature ID | Title | Component | Spec Link | IRG | Blocking Unknowns | Readiness | Specialist Advisor | Advisor Gate | Notes |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| SETUP-001 | none | Bootstrap workspace and connect code repository | api | 1-design/PROJECT_BRIEF.md | S:2 A:2 I:2 R:2 V:2 | none | ready_for_build | none | not_required | setup task; no feature dependency |
| TASK-001 | FEAT-001 | Implement snippet create and retrieve endpoints | api | 1-design/PROJECT_BRIEF.md | S:2 A:1 I:1 R:1 V:1 | acceptance criteria need concrete request/response shapes; storage interface not decided | needs_detail | none | not_required | blocked on storage backend decision |

**`2-build/WORK_QUEUE.md`**：
| Task ID | Feature ID | Title | Component | Priority | Phase | Milestone | Target Window | Mode | Lock ID | Owner | Status | Build Dependencies | Design Dependencies | Validation | Notes |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| SETUP-001 | none | Bootstrap workspace and connect code repository | api | P1 | build | M-001 | 2026-Q2 | sequential | none | Dev Team | todo | none | none | make docs-check | run first; unblocks real path references in traceability |
| TASK-001 | FEAT-001 | Implement snippet create and retrieve endpoints | api | P1 | design | M-001 | 2026-Q2 | sequential | none | Dev Team | todo | SETUP-001 | none | make docs-check; curl smoke tests | waiting on design detail |

**`3-verify/TRACEABILITY_MATRIX.md`**：
| Feature ID | Spec Link | Task ID(s) | Code Link(s) | Test Link(s) | Last Synced | Drift Status | Owner | Notes |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| FEAT-001 | 1-design/PROJECT_BRIEF.md | TASK-001 | components/api/src | components/api/tests | 2026-04-05 | review_needed | Dev Team | paths confirmed after SETUP-001 completes |

---

## 3. 建置（Build）SETUP-001

SETUP-001 立即具有 `ready_for_build`——它是一個沒有設計未知事項的設定任務。

1. 初始化或複製你的程式碼儲存庫至 `components/api/`。
2. 確認 `components/api/src` 和 `components/api/tests` 存在（或調整路徑以符合你的實際佈局）。
3. 使用已確認的路徑更新 `TRACEABILITY_MATRIX.yaml`；設定 `drift_status: aligned`。
4. 執行 `make render`，然後執行 `make docs-check`。
5. 將 SETUP-001 移至 `awaiting_human_review`，並在 Notes 中記錄驗證證據。

---

## 4. 驗證（Verify）SETUP-001

**開始 SETUP-001 的驗證（Verify）階段：**
- WORK_QUEUE：狀態 `awaiting_human_review`，驗證 `make docs-check` 已通過
- TASK_READINESS：`advisor_status: not_required` — 無閘門需要檢查
- TRACEABILITY_MATRIX：`drift_status: aligned`
- FEEDBACK_MATRIX：設定任務無人工測試觀察
- GAPS_AND_DEVIATIONS：無缺口或偏差浮現

**驗收閘門檢查：**
1. 驗證品質：`make docs-check` 已通過——證據充足。
2. 回饋完整性：FEEDBACK_MATRIX 空——無需推進。
3. 顧問和風險跟進：無顧問活躍。
4. 運維就緒：設定任務；無推出顧慮。
5. 決策：**接受（accept）**。

將 SETUP-001 移至 `accepted` → `done`。

---

## 5. 同步（Sync）SETUP-001

**開始同步（Sync）階段：**
- DESIGN_INPUTS：空——無先前開放項目。
- GAPS_AND_DEVIATIONS：空——無需分類。
- 對齊：WORK_QUEUE 狀態為 `done`；ROADMAP 和 TRACEABILITY_MATRIX 已是最新。

無需分類。同步（Sync）完成。下一個設計（Design）階段可以開始。

---

## 6. 設計（Design）：推進 TASK-001

**開始設計（Design）階段：**
1. 讀取 `4-sync/DESIGN_INPUTS.md` — 仍然是空的；無開放項目。
2. 在 TASK_READINESS 中檢查 `needs_detail` 列——TASK-001 為 `needs_detail`。

解決阻塞未知事項：
- 決定儲存後端：第一個切片使用 SQLite。
- 定義請求/回應結構：
  - `POST /snippets` 主體：`{ "language": "python", "content": "print('hello')" }`
  - `GET /snippets/:id` 回應：`{ "id": "abc123", "language": "python", "content": "..." }`
- 使用儲存和結構決策更新 PROJECT_BRIEF.md。
- 一旦阻塞問題解決，將 DESIGN_STATES.md 更新為 `ready`。

**`1-design/DESIGN_STATES.md`** 設計完成後：
| Feature ID | Linked Idea | Linked Task(s) | Component(s) | Design State | Owner | Blocking Questions | Last Updated | Notes |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| FEAT-001 | direct_to_design | TASK-001 | api | ready | Dev Team | none | 2026-04-07 | storage: SQLite; shapes confirmed |

**`1-design/TASK_READINESS.md`** IRG 更新後：
| Task ID | Feature ID | Title | Component | Spec Link | IRG | Blocking Unknowns | Readiness | Specialist Advisor | Advisor Gate | Notes |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| SETUP-001 | none | Bootstrap workspace and connect code repository | api | 1-design/PROJECT_BRIEF.md | S:2 A:2 I:2 R:2 V:2 | none | ready_for_build | none | not_required | |
| TASK-001 | FEAT-001 | Implement snippet create and retrieve endpoints | api | 1-design/PROJECT_BRIEF.md | S:2 A:2 I:2 R:1 V:2 | none | ready_for_build | none | not_required | storage: SQLite; POST + GET shapes confirmed |

TASK-001 現在通過 IRG 閘門：總分 9/10，A=2，I=2，無阻塞未知事項。

---

## 7. 建置（Build）TASK-001

將 TASK-001 拉入建置。實作端點，保持佇列和可追溯性的更新。

**`2-build/WORK_QUEUE.md`** 建置中：
| Task ID | Feature ID | Title | Component | Priority | Phase | Milestone | Target Window | Mode | Lock ID | Owner | Status | Build Dependencies | Design Dependencies | Validation | Notes |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| SETUP-001 | none | Bootstrap workspace and connect code repository | api | P1 | sync | M-001 | 2026-Q2 | sequential | none | Dev Team | done | none | none | make docs-check | |
| TASK-001 | FEAT-001 | Implement snippet create and retrieve endpoints | api | P1 | build | M-001 | 2026-Q2 | sequential | none | Dev Team | in_progress | SETUP-001 | none | make docs-check; curl smoke tests | |

當實作和測試通過時，移至 `awaiting_human_review` 並在 Notes 中記錄證據。

---

## 8. 驗證（Verify）TASK-001

**開始 TASK-001 的驗證（Verify）階段：**
- WORK_QUEUE：狀態 `awaiting_human_review`
- TASK_READINESS：`advisor_status: not_required`
- TRACEABILITY_MATRIX：`drift_status: aligned`
- FEEDBACK_MATRIX：來自人工測試的一個觀察（見下文）
- GAPS_AND_DEVIATIONS：一個從 FEEDBACK_MATRIX 推進的記錄（見下文）

**人工測試觀察**記錄在 `3-verify/FEEDBACK_MATRIX.yaml` 中：
```yaml
- id: FB-001
  task_id: TASK-001
  feature_id: FEAT-001
  type: deviation
  summary: "POST /snippets returns 201 but spec only specifies 200"
  detail: "Implementation returns 201 Created; PROJECT_BRIEF.md only specifies 200 OK for success responses"
  tested_by: Dev Team
  date: 2026-04-09
  severity: low
  status: promoted_to_staging
  resolution: "Promoted to GD-001 — needs Sync ratification"
```

**推進至** `3-verify/GAPS_AND_DEVIATIONS.yaml`：
```yaml
- id: GD-001
  feature_id: FEAT-001
  type: deviation
  summary: "POST /snippets returns 201 Created; spec says 200 OK"
  detail: "Build chose 201 as more semantically correct for resource creation; spec was silent on this"
  source: human_feedback
  source_ref: FB-001
  discovered_in_task: TASK-001
  status: promoted_to_sync
  resolution_note: "Promoted to Sync for ratification"
```

**驗收閘門檢查：**
1. 驗證品質：測試和煙霧測試通過；證據已記錄。
2. 回饋完整性：FB-001 為 `promoted_to_staging`；GD-001 已暫存。✓
3. 顧問和風險跟進：無顧問活躍。
4. 運維就緒：第一個切片無部署顧慮。
5. 決策：**接受（accept）**。

將 TASK-001 移至 `accepted`。

---

## 9. 同步（Sync）TASK-001

**開始同步（Sync）階段：**

1. 讀取 DESIGN_INPUTS — 從前一個階段仍然是空的。
2. 分類 GAPS_AND_DEVIATIONS：

**GD-001**（偏差：POST 回傳 201 而非 200）：
- 現在可以關閉嗎？可以——更新 PROJECT_BRIEF.md 以指定資源建立使用 201。不需要完整的設計（Design）週期。
- 行動：更新規格，添加至 `4-sync/archive/DESIGN_INPUTS.yaml`。

**`4-sync/archive/DESIGN_INPUTS.yaml`** 分類後：
```yaml
- id: DA-001
  source_input_id: ""
  feature_id: FEAT-001
  type: deviation
  summary: "POST /snippets returns 201 Created; spec updated to match"
  cycle_opened: "2026-Q2-loop-1"
  cycle_closed: "2026-Q2-loop-1"
  resolution_type: incorporated
  resolution_pointer: "1-design/PROJECT_BRIEF.md#response-codes"
  resolution_note: "Spec updated to specify 201 for resource creation; implementation is correct"
```

3. 對齊登記表：

**`2-build/WORK_QUEUE.md`** 最終狀態：
| Task ID | Feature ID | Title | Component | Priority | Phase | Milestone | Target Window | Mode | Lock ID | Owner | Status | Build Dependencies | Design Dependencies | Validation | Notes |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| SETUP-001 | none | Bootstrap workspace and connect code repository | api | P1 | sync | M-001 | 2026-Q2 | sequential | none | Dev Team | done | none | none | make docs-check | |
| TASK-001 | FEAT-001 | Implement snippet create and retrieve endpoints | api | P1 | sync | M-001 | 2026-Q2 | sequential | none | Dev Team | done | SETUP-001 | none | make docs-check; curl smoke tests | POST /snippets + GET /snippets/:id passing; SQLite storage confirmed |

**`1-design/ROADMAP.md`** 同步後：
| Milestone ID | Target Window | Objective | Feature ID(s) | Depends On | Status | Owner | Notes |
| --- | --- | --- | --- | --- | --- | --- | --- |
| M-001 | 2026-Q2 | Working snippet API with create and retrieve | FEAT-001 | none | completed | Dev Team | delivered 2026-04-10 |

**`3-verify/TRACEABILITY_MATRIX.md`** 同步後：
| Feature ID | Spec Link | Task ID(s) | Code Link(s) | Test Link(s) | Last Synced | Drift Status | Owner | Notes |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| FEAT-001 | 1-design/PROJECT_BRIEF.md | TASK-001 | components/api/src | components/api/tests | 2026-04-10 | aligned | Dev Team | |

執行 `make docs-check` 確認一切正常。
DESIGN_INPUTS 是空的——下一個設計（Design）階段可以乾淨地開始。
