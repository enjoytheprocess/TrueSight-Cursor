# 範本側載（Template Sideloading）

當另一個工作空間儲存庫想要從此範本開始、稍後採用它，或側載更新的範本發布並要求其本地代理就地調整儲存庫時，請使用本指南。

## 兩種採用路徑
此範本刻意以兩種不同方式使用：

- `直接使用（Direct use）`：從範本建立新工作空間並就地自訂。
- `側載/適配（Sideload/adapt）`：現有工作空間保持其本地狀態，並逐步從側載的範本發布中採用結構。

相同的工作流程模型支援兩種情況，但預期不同：
- 直接使用的工作空間應快速將佔位符替換為真實的本地路徑
- 側載的工作空間可以在本地代理逐步調整儲存庫時保持明確的外部引用
- 適配應保留專案自有的檔案和當前工作狀態，除非人類要求替換

## 模型

此範本使用側載模型，而非硬同步模型。

- 新儲存庫從此儲存庫建立的發布包生成其起始檔案。
- 現有儲存庫將更新的範本發布側載至本地收件箱目錄。
- 本地代理比較儲存庫的當前檔案與側載包，並就地更新儲存庫。
- 即時專案狀態被調整，而非盲目覆蓋。

目標是在保留專案特定背景的同時，讓儲存庫受益於更新的工作流程結構、檢查和文件格式。

## 適配期間的可追溯性
在側載或聯合採用期間，不要為了滿足可追溯性矩陣而虛構假的本地程式碼/測試路徑。

優先使用明確的引用，例如：
- `../<component>/src`，當消費者工作空間在相鄰本地簽出中保持元件時
- `repo:<component>@<ref>:<path>`
- `repo:<component>:<path>`，當引用已在其他地方（例如 `workspace.manifest.yaml`）固定時
- `https://host/org/<component>/blob/<ref>/<path>`，當固定 URL 比本地簽出引用更有用時

直接使用的工作空間應在這些路徑存在後，將佔位符引用替換為真實的相對儲存庫本地路徑。

## 規範性腳架檔案

- `template-release.yaml`：發布元資料和預設適配合約
- `upgrade-notes.md`：人類和代理的滾動發布說明
- `templates/sideload/WORKSPACE_TEMPLATE_STATE_TEMPLATE.yaml`：消費者儲存庫狀態檔案範本
- `templates/sideload/WORKSPACE_TEMPLATE_LOCAL_OVERRIDES_TEMPLATE.md`：可選的消費者本地覆蓋範本
- `meta/templates/template-release-paths.txt`：發布包中包含的路徑

## 發布包內容

使用以下指令建立發布包：

```bash
make template-package
```

預設輸出：

```text
/tmp/workspace-template-releases/workspace-template-<release-version>/
/tmp/workspace-template-releases/workspace-template-<release-version>.tar.gz
```

此包是消費者儲存庫可以作為本地代理參考輸入保存的側載載荷。

## 消費者儲存庫檔案

消費者儲存庫通常應保存：

- `.workspace-template-state.yaml`：當前採用版本和側載狀態
- `.workspace-template-inbox/<release-version>/`：已解壓的側載包
- `.workspace-template-local-overrides.md`：刻意本地偏差的可選備注

從此儲存庫中的範本建立狀態和覆蓋檔案：

- `templates/sideload/WORKSPACE_TEMPLATE_STATE_TEMPLATE.yaml`
- `templates/sideload/WORKSPACE_TEMPLATE_LOCAL_OVERRIDES_TEMPLATE.md`

## 檔案處理模型

`template-release.yaml` 中的預設合約將檔案分為三種行為：

- `replace_reference_paths`：通常是靜態框架文件/範本/檢查，可以主要作為引用刷新
- `adapt_in_place_paths`：其內容應在消費者儲存庫中謹慎遷移的即時工作流程檔案
- `preserve_local_paths`：應保持本地的專案自有檔案，除非人類明確決定否則

此合約是本地代理的指引。它不是盲目覆蓋規則。

## 新儲存庫流程

1. 從此範本儲存庫建立或下載發布包。
2. 從該包為新工作空間儲存庫生成起始檔案。
3. 將 `templates/sideload/WORKSPACE_TEMPLATE_STATE_TEMPLATE.yaml` 複製至 `.workspace-template-state.yaml`。
4. 在該狀態檔案中設定採用的範本版本。
5. 自訂專案自有的檔案，例如 `README.md`、元件和專案摘要內容。
6. 執行 `make docs-check`。

## 採用現有儲存庫

1. 將側載的發布包放在 `.workspace-template-inbox/<release-version>/`。
2. 若儲存庫尚未有 `.workspace-template-state.yaml`，建立它。
3. 要求本地代理比較當前儲存庫與側載包。
4. 代理應該：
   - 添加缺少的規範性檔案
   - 在適當的地方更新靜態框架文件/檢查
   - 就地調整即時工作流程文件
   - 將佔位符可追溯性引用轉換為真實的本地路徑或明確的外部引用
   - 保留專案特定內容，除非人類要求替換
5. 在 `.workspace-template-state.yaml` 中記錄新採用的版本。
6. 執行 `make docs-check`。

## 升級現有儲存庫

1. 將較新的發布側載至 `.workspace-template-inbox/<new-version>/`。
2. 在 `.workspace-template-state.yaml` 中保持當前採用的版本。
3. 針對包的 upgrade-notes.md 執行 `make migrate-plan`，以識別哪些登記表遷移適用：
   ```bash
   make migrate-plan ARGS=.workspace-template-inbox/<new-version>/upgrade-notes.md
   ```
   這會列印每個登記表的當前版本與預期 schema 版本，並按順序顯示需要套用的相關 `schema_change` 區塊。
4. 在更改任何其他內容之前，將每個列出的遷移套用至即時登記表 `.yaml` 檔案。每次遷移後，在登記表中將 `schema_version` 設為區塊的目標版本。
5. 執行 `make docs-check` 確認遷移完成。
6. 執行 `make adapt-diff` 生成所有就地調整檔案的結構化差異：
   ```bash
   make adapt-diff BUNDLE=.workspace-template-inbox/<new-version>
   ```
   這會列出哪些引用檔案將被替換，並顯示每個已更改的就地調整檔案的統一差異。將輸出作為本地代理適配階段的起始點。
7. 要求本地代理使用差異輸出套用調整：
   - 使用差異作為指引更新就地調整檔案，保留本地專案狀態
   - 從包替換引用檔案
   - 若 `.workspace-template-local-overrides.md` 使用中，在其中記錄任何刻意偏差
8. 重新執行 `make docs-check`。
9. 將 `.workspace-template-state.yaml` 更新至新採用的版本。

## 建議的本地代理提示

在消費者儲存庫中使用此形式的提示：

```text
將此儲存庫升級至 workspace-template 發布 <new-version>。
發布包在 .workspace-template-inbox/<new-version>/。

1. 執行：make migrate-plan ARGS=.workspace-template-inbox/<new-version>/upgrade-notes.md
   在觸碰任何其他內容之前套用每個列出的遷移。
   每次遷移後，在登記表檔案中將 schema_version 設為區塊的目標版本。
   執行 make docs-check 確認遷移完成。

2. 執行：make adapt-diff BUNDLE=.workspace-template-inbox/<new-version>
   使用輸出作為你的工作差異。對每個顯示的檔案：
   - replace_reference_paths：從包原樣複製
   - adapt_in_place_paths：套用安全的差異塊；跳過會覆蓋
     本地專案狀態或刻意自訂的塊

3. 若使用中，在 .workspace-template-local-overrides.md 中記錄刻意偏差。

4. 執行 make docs-check 並將 .workspace-template-state.yaml 更新至 <new-version>。
```

## 建議的預期

- 優先使用明確的版本標籤作為發布。
- 將側載包視為本地代理的參考輸入。
- 保留當前工作狀態，除非人類明確要求重置。
- 將消費者特定的偏差寫下來，以便未來的升級保持可理解。
