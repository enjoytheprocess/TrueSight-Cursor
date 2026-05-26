# 儲存庫模式

`make init` 為選定的模式安裝固定的根目錄 `README.md` 和 `AGENTS.md` 範本。
這使即時入口點說明保持特定於模式，而不依賴後續的 AI 重寫。

## 單一元件模式（Single-component）
當所有產品邏輯作為一個可部署單元出貨時使用。

建議的目錄結構：
```text
components/
└── app/
    ├── src/
    ├── tests/
    ├── README.md
    └── AGENTS.md
```

指引：
- 在 `2-build/WORK_QUEUE.md` 中保持一個主要佇列。
- 在 `1-design/ROADMAP.md` 中保持能力分組。
- 大多數任務使用 `Mode = sequential`。
- 僅對大型重構或緊急吞吐量使用並行鎖定。
- 在 `3-verify/TRACEABILITY_MATRIX.md` 中，優先使用相對於儲存庫的本地程式碼/測試路徑。
- 根目錄入口點範本：
  - `templates/init/WORKSPACE_README_TEMPLATE.md`
  - `templates/init/WORKSPACE_AGENTS_TEMPLATE.md`

## 多元件模式（Multi-component）
當產品有獨立的可部署物（例如 API + web + worker）時使用。

建議的目錄結構：
```text
components/
├── api/
├── web/
└── worker/
```

指引：
- 以具體的元件名稱標記每個任務。
- 透過 `1-design/ROADMAP.md` 中的共享能力排序跨元件工作。
- 優先使用元件範圍的鎖定（例如 `components/api/**`）。
- 保留跨領域檔案和合約的共享鎖定。
- 為每個元件使用元件文件合約範本：
  - `templates/component/COMPONENT_README_TEMPLATE.md`
  - `templates/component/COMPONENT_AGENTS_TEMPLATE.md`
- 在 `3-verify/TRACEABILITY_MATRIX.md` 中，優先使用每個元件或共享合約路徑的相對本地路徑。
- 根目錄入口點範本：
  - `templates/init/WORKSPACE_README_TEMPLATE.md`
  - `templates/init/WORKSPACE_AGENTS_TEMPLATE.md`

## 多儲存庫模式（聯合，Federated）
當每個元件住在自己的儲存庫中，此儲存庫作為共享的 AI 規劃中心時使用。

建議的目錄結構：
```text
.
├── 0-ideation/
├── 1-design/
├── 2-build/
├── 3-verify/
├── 4-sync/
├── docs/
├── components/
│   └── COMPONENT_REPOS.md
├── scripts/
├── workspace.manifest.yaml
└── Makefile
```

`components/COMPONENT_REPOS.md` 範例：
```text
| Component | Repository URL | Default Branch | Local Path (optional) |
| --- | --- | --- | --- |
| api | git@example.com/org/api.git | main | ../api |
| web | git@example.com/org/web.git | main | ../web |
```

由 manifest 驅動的工作流程（可選但建議）：
- `make manifest-lint`
- `make sync`
- `make status`
- `make verify`

指引：
- 將架構和跨元件決策保存在此範本儲存庫中。
- 在每個元件儲存庫中執行元件特定的實作。
- 在 `2-build/WORK_QUEUE.md` 和 `2-build/TASK_DEPENDENCIES.md`（若依賴追蹤使用中）中追蹤跨儲存庫依賴。
- 將構思/設計治理集中在 `1-design/DESIGN_STATES.md` 和 `1-design/ROADMAP.md`；使用中時在 `0-ideation/IDEATION_BACKLOG.yaml` 中保持構思。
- 在 `3-verify/TRACEABILITY_MATRIX.md` 中，優先使用明確的外部引用，例如 `repo:<component>@<ref>:<path>`，除非元件也在本地簽出。
- 根目錄入口點範本：
  - `templates/WORKSPACE_README_FEDERATED_TEMPLATE.md`
  - `templates/WORKSPACE_AGENTS_FEDERATED_TEMPLATE.md`

聯合工作的已接受可追溯性引用樣式：
- 相對於儲存庫的本地簽出路徑在此儲存庫內，例如 `components/api/src`，當元件已同步至此時
- 相鄰簽出路徑，例如 `../api/src`，當元件簽出在此儲存庫旁時
- 明確的外部引用，例如 `repo:api@<ref>:src`
- 固定至特定引用的 URL，例如 `https://host/org/api/blob/<ref>/src/index.ts`
