# AS-IS 액션 대조표 — SCP0085

> 원천: `Doc/asisfacts/screens/SCP0085/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 214행 · 메서드 28 · 종류 GRID_INIT 47 · GRID_SET 33 · UI_PROP 24 · DATA_OP 19 · FLAG 17 · CALL_EXT 16 · VALUE_SET 10 · POPUP 9 · RETURN 8 · ENDPOINT 7 · UI_MISC 6 · MESSAGE 5 · LIST_REBIND 4 · STATE 4 · VALIDATE 2 · GRID_BIND 1 · GRID_LOCK 1 · GRID_CLEAR 1 · ⚠ 의미 확인 필요 16


## SCP0085_EndingInventory.BtnItem_Id_Click

진입점: this.btnItem_Id.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2b9348a9 | this.btnItem_Id.Click | SCP0085_EndingInventory.cs:545 |  | POPUP | new SCM0002_MaterialByDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-249e43b8 | this.btnItem_Id.Click | SCP0085_EndingInventory.cs:547 |  | POPUP | pop.Form_Load | (true, sdivision, "ALL", sItemId, this.Name.Substring(0, 7)) | 팝업 초기화(인자 전달) |  |  |  |
| AC-76412151 | this.btnItem_Id.Click | SCP0085_EndingInventory.cs:548 |  | UI_PROP | pop.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-755fa160 | this.btnItem_Id.Click | SCP0085_EndingInventory.cs:549 |  | POPUP | pop.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-8cb85c93 | this.btnItem_Id.Click | SCP0085_EndingInventory.cs:555 | if (pop.selectedItemId != "") | VALUE_SET | txtItem_Id.Text | itemId | 컨트롤 값 설정 |  |  |  |

## SCP0085_EndingInventory.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-407d4e14 | this.Load | SCP0085_EndingInventory.cs:312 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-32ed5a26 | this.Load | SCP0085_EndingInventory.cs:313 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-5703d5d3 | this.Load | SCP0085_EndingInventory.cs:314 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0085_EndingInventory.DatePicker_ValueChanged

진입점: datePicker.ValueChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dac64fc6 | datePicker.ValueChanged | SCP0085_EndingInventory.cs:628 |  | VALUE_SET | monthPicker.Text | month | 컨트롤 값 설정 |  |  |  |
| AC-b1e1d54a | datePicker.ValueChanged | SCP0085_EndingInventory.cs:631 |  | FLAG | dtProfitAll | GetSearchInfo(p_yyyymmdd).Tables[0] | 화면 필드/플래그 변경 |  |  |  |

## SCP0085_EndingInventory.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-db695daa | Dispose | SCP0085_EndingInventory.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0085_EndingInventory.ExcelButton

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2eb15a52 | ExcelButton | SCP0085_EndingInventory.cs:810 | try | MESSAGE | MessageHelper.GMessageBox | ("MSG00100") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SCP0085_EndingInventory.ExportExcelData

진입점: ExcelButton [try ▸ if (result == DialogResult.Yes)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7534bc00 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0085_EndingInventory.cs:858 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-187b5905 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0085_EndingInventory.cs:862 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-ed22a42e | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0085_EndingInventory.cs:869 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-22f36557 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0085_EndingInventory.cs:876 | try | CALL_EXT | spSpread.Sheets.CopyTo | (myarray, 0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-1465d6cd | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0085_EndingInventory.cs:878 | try ▸ if (myarray.Length == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a86600bd | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0085_EndingInventory.cs:881 | try | CALL_EXT | sp.Sheets.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-e695b530 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0085_EndingInventory.cs:917 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) | DATA_OP | sv.Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-e1c148b6 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0085_EndingInventory.cs:922 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) | UI_PROP | newSheet.ReferenceStyle | FarPoint.Win.Spread.Model.ReferenceStyle.A1 | 속성 ReferenceStyle 설정 |  |  |  |
| AC-53fdc855 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0085_EndingInventory.cs:928 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) | CALL_EXT | ScpUtils.GetColumnName | (newSheet, i) | ⚠ 의미 확인 필요 |  |  |  |
| AC-687d01a3 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0085_EndingInventory.cs:938 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ switch (columnName) case "CELL_CONVER_FACTOR": case "CELL_CONVER_QUANTITY":… | GRID_SET | newSheet.Columns[i].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-e929937c | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0085_EndingInventory.cs:950 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ switch (columnName) case "CELL_CONVER_FACTOR_XLS": case "CELL_CONVER_QUANTI… | GRID_SET | newSheet.Columns[i].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-dcb902bb | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0085_EndingInventory.cs:964 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) | CALL_EXT | f.IsRowFilteredOut | (i) | ⚠ 의미 확인 필요 |  |  |  |
| AC-806e17d5 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0085_EndingInventory.cs:966 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ if (newSheet.Rows[i].Visible == false \|\| (f != null && f.IsRowFilteredOut… | DATA_OP | newSheet.Rows.Remove | (i, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-d7f17753 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0085_EndingInventory.cs:973 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ if (USE_CELL_CF_BOM.Equals("Y")) | GRID_SET | newSheet.Cells[i, iCol_CELL_CONVER_FACTOR_XLS].BackColor | System.Drawing.Color.Yellow | 그리드 속성/값 설정 |  |  |  |
| AC-aa1a4307 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0085_EndingInventory.cs:974 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ if (USE_CELL_CF_BOM.Equals("Y")) | GRID_SET | newSheet.Cells[i, iCol_CELL_CONVER_QUANTITY_XLS].BackColor | System.Drawing.Color.Yellow | 그리드 속성/값 설정 |  |  |  |
| AC-6d9398c1 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0085_EndingInventory.cs:975 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ if (USE_CELL_CF_BOM.Equals("Y")) | GRID_SET | newSheet.Cells[i, iCol_USE_CELL_CF_BOM].BackColor | System.Drawing.Color.Yellow | 그리드 속성/값 설정 |  |  |  |
| AC-a373e3ce | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0085_EndingInventory.cs:984 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ if (newSheet.Columns[i].Visible == false) | DATA_OP | newSheet.Columns.Remove | (i, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-a97c974b | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0085_EndingInventory.cs:996 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ if (newSheet.Columns[i].Ce… | GRID_SET | newSheet.Cells[idx.Index, i].CellType | new FarPoint.Win.Spread.CellType.TextCellType() | 그리드 속성/값 설정 |  |  |  |
| AC-b8b606e8 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0085_EndingInventory.cs:997 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ if (newSheet.Columns[i].Ce… | GRID_SET | newSheet.Cells[idx.Index, i].Text | sText | 그리드 속성/값 설정 |  |  |  |
| AC-a9bbb6cd | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0085_EndingInventory.cs:1006 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ if (newSheet.Columns[i].Ce… | GRID_SET | newSheet.Cells[idx.Index, i].CellType | new FarPoint.Win.Spread.CellType.TextCellType() | 그리드 속성/값 설정 |  |  |  |
| AC-a2054dc5 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0085_EndingInventory.cs:1007 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ if (newSheet.Columns[i].Ce… | GRID_SET | newSheet.Cells[idx.Index, i].Text | sText | 그리드 속성/값 설정 |  |  |  |
| AC-42aa161a | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0085_EndingInventory.cs:1013 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ if (newSheet.Columns[i].Ce… | GRID_SET | newSheet.Columns[i].Formula | "" | 그리드 속성/값 설정 |  |  |  |
| AC-9bb86064 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0085_EndingInventory.cs:1026 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (iCol >= 0) ▸ if (newSheet.Columns[iCol].Tag == null) ▸ if (newSheet.Columns[iCol].Dat… | UI_PROP | newSheet.FrozenColumnCount | iCol | 속성 FrozenColumnCount 설정 |  |  |  |
| AC-a9b3b8a2 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0085_EndingInventory.cs:1035 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (iCol >= 0) ▸ else of (newSheet.Columns[iCol].Tag == null) ▸ if (newSheet.Columns[iCol… | UI_PROP | newSheet.FrozenColumnCount | iCol + 1 | 속성 FrozenColumnCount 설정 |  |  |  |
| AC-0b4f82a1 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0085_EndingInventory.cs:1042 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) | DATA_OP | sp.Sheets.Add | (newSheet) | 데이터 객체 조작/조회 |  |  |  |
| AC-927f526c | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0085_EndingInventory.cs:1046 | try | UI_PROP | siNew.Border | new FarPoint.Win.LineBorder(System.Drawing.Color.Black, 1, true, true, true, true) | 속성 Border 설정 |  |  |  |
| AC-8379c82d | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0085_EndingInventory.cs:1048 | try | UI_PROP | siNew.Border | new FarPoint.Win.LineBorder(Color.Black, 1, true, true, true, true) | 속성 Border 설정 |  |  |  |
| AC-27aa883c | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0085_EndingInventory.cs:1050 | try | UI_PROP | newSheet.DefaultStyle | siNew | 속성 DefaultStyle 설정 |  |  |  |
| AC-71a7d488 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0085_EndingInventory.cs:1052 | try | UI_PROP | siNewColHeader.Border | new FarPoint.Win.LineBorder(System.Drawing.Color.Black, 1, true, true, true, true) | 속성 Border 설정 |  |  |  |
| AC-084058b9 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0085_EndingInventory.cs:1054 | try | GRID_SET | newSheet.ColumnHeader.DefaultStyle | siNewColHeader | 그리드 속성/값 설정 |  |  |  |
| AC-83338760 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0085_EndingInventory.cs:1062 | try ▸ if (!bFrozenCheck) | UI_PROP | newSheet.FrozenColumnCount | 0 | 속성 FrozenColumnCount 설정 |  |  |  |
| AC-207e3530 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0085_EndingInventory.cs:1064 | try | UI_PROP | sp.TabStripPolicy | TabStripPolicy.Always | 속성 TabStripPolicy 설정 |  |  |  |
| AC-df544670 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0085_EndingInventory.cs:1069 | try ▸ for (iSheetIndex < sp.Sheets.Count) | GRID_SET | sp.Sheets[iSheetIndex].Protect | false | 그리드 속성/값 설정 |  |  |  |
| AC-887c3d18 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0085_EndingInventory.cs:1083 | try ▸ if (isOpen) | CALL_EXT | sp.SaveExcel | (sFileName, gesfDefaultExeclSaveFlg \| FarPoint.Excel.ExcelSaveFlags.UseOOXMLFormat) | ⚠ 의미 확인 필요 |  |  |  |
| AC-6015c44d | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0085_EndingInventory.cs:1085 | try ▸ if (isOpen) | CALL_EXT | System.Diagnostics.Process.Start | (sFileName) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ed3db843 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0085_EndingInventory.cs:1089 | try ▸ else of (isOpen) | POPUP | new SaveFileDialog | () | 팝업/폼 생성 |  |  |  |
| AC-8ba3724e | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0085_EndingInventory.cs:1090 | try ▸ else of (isOpen) | UI_PROP | saveFileDialog.Filter | "Excel files (*.xls or .xlsx)\|*.xls;*.xlsx" | 속성 Filter 설정 |  |  |  |
| AC-43a59dc3 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0085_EndingInventory.cs:1091 | try ▸ else of (isOpen) | UI_PROP | saveFileDialog.Title | "Save an Excel File" | 속성 Title 설정 |  |  |  |
| AC-bfca05de | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0085_EndingInventory.cs:1092 | try ▸ else of (isOpen) | UI_PROP | saveFileDialog.FileName | sExcelFileName | 속성 FileName 설정 |  |  |  |
| AC-5b43a4f6 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0085_EndingInventory.cs:1093 | try ▸ else of (isOpen) | POPUP | saveFileDialog.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-410f7ae0 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0085_EndingInventory.cs:1100 | try ▸ else of (isOpen) ▸ if (saveFileDialog.FileName != "") | CALL_EXT | sFileName.LastIndexOf | (".") | ⚠ 의미 확인 필요 |  |  |  |
| AC-0e69368d | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0085_EndingInventory.cs:1102 | try ▸ else of (isOpen) ▸ if (saveFileDialog.FileName != "") ▸ if (sFileName.Substring(sFileName.LastIndexOf(".") + 1).ToString().ToUpper() =… | CALL_EXT | sp.SaveExcel | (sFileName, gesfDefaultExeclSaveFlg) | ⚠ 의미 확인 필요 |  |  |  |
| AC-76593e8c | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0085_EndingInventory.cs:1105 | try ▸ else of (isOpen) ▸ if (saveFileDialog.FileName != "") ▸ else of (sFileName.Substring(sFileName.LastIndexOf(".") + 1).ToString().ToUppe… | CALL_EXT | sp.SaveExcel | (sFileName, gesfDefaultExeclSaveFlg \| FarPoint.Excel.ExcelSaveFlags.UseOOXMLFormat) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3a1fe7ca | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0085_EndingInventory.cs:1109 | try | CALL_EXT | GC.GetGeneration | ((object)sp) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a03a3d10 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0085_EndingInventory.cs:1115 | catch ((Exception e)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00003", new object[] { e.Message }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e3e005b7 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0085_EndingInventory.cs:1120 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-e0cd7bff | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0085_EndingInventory.cs:1123 | finally ▸ if (ver >= 0) | CALL_EXT | GC.Collect | (ver) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0085_EndingInventory.Find_Data

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fc0706bc | FindButton | SCP0085_EndingInventory.cs:401 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-f8556394 | FindButton | SCP0085_EndingInventory.cs:405 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-849b9a34 | FindButton | SCP0085_EndingInventory.cs:405 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a144e2a6 | FindButton | SCP0085_EndingInventory.cs:407 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-b1ce9aa9 | FindButton | SCP0085_EndingInventory.cs:435 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-ad586e71 | FindButton | SCP0085_EndingInventory.cs:437 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCP.Analysis.WSL/FoxDataServi… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-931f555e | FindButton | SCP0085_EndingInventory.cs:441 | try ▸ lambda | ENDPOINT | new FoxDataRequest | (call_sp) ⇒ SCP.SCP0085_GET_ENDING_INVENTORY \| SCP.SCP0085_GET_ENDING_INVENTORY_DAILY | 엔드포인트 요청 생성 |  |  |  |
| AC-610a6768 | FindButton | SCP0085_EndingInventory.cs:442 | try ▸ lambda | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-911d17a3 | FindButton | SCP0085_EndingInventory.cs:443 | try ▸ lambda | DATA_OP | request.Parameters[call_sp_param] | call_sp_param_value | 행/컬럼 값 대입 |  |  |  |
| AC-2ada64c0 | FindButton | SCP0085_EndingInventory.cs:444 | try ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-b35cbaef | FindButton | SCP0085_EndingInventory.cs:445 | try ▸ lambda | DATA_OP | request.Parameters["p_plant_id"] | p_plant_id | 행/컬럼 값 대입 |  |  |  |
| AC-6825e45f | FindButton | SCP0085_EndingInventory.cs:446 | try ▸ lambda | DATA_OP | request.Parameters["p_item_type"] | p_item_type | 행/컬럼 값 대입 |  |  |  |
| AC-bd928c08 | FindButton | SCP0085_EndingInventory.cs:447 | try ▸ lambda | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-d556687b | FindButton | SCP0085_EndingInventory.cs:448 | try ▸ lambda | DATA_OP | request.Parameters["p_profit_center"] | p_profit_center | 행/컬럼 값 대입 |  |  |  |
| AC-737d0094 | FindButton | SCP0085_EndingInventory.cs:450 | try ▸ lambda | DATA_OP | request.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-b50e9e1a | FindButton | SCP0085_EndingInventory.cs:452 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-e4bc13dc | FindButton | SCP0085_EndingInventory.cs:454 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-668b99da | FindButton | SCP0085_EndingInventory.cs:461 | try | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-18da91a7 | FindButton | SCP0085_EndingInventory.cs:462 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-bd9d725e | FindButton | SCP0085_EndingInventory.cs:468 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-76de1285 | FindButton | SCP0085_EndingInventory.cs:473 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-905ab3f2 | FindButton | SCP0085_EndingInventory.cs:480 | catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-b4b15119 | FindButton | SCP0085_EndingInventory.cs:481 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b0b098cd | FindButton | SCP0085_EndingInventory.cs:485 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0085_EndingInventory.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8be3c197 | this.Load | SCP0085_EndingInventory.cs:180 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCP0085_EndingInventory.GetMonthRange

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-13fa4bec | this.Load | SCP0085_EndingInventory.cs:498 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0084_GET_MONTH_RANGE") ⇒ SCP.SCP0084_GET_MONTH_RANGE | 엔드포인트 요청 생성 |  |  |  |
| AC-11b001d3 | this.Load | SCP0085_EndingInventory.cs:499 |  | DATA_OP | request.Parameters["p_month"] | 12 | 행/컬럼 값 대입 |  |  |  |
| AC-29aec44a | this.Load | SCP0085_EndingInventory.cs:501 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-3b83c1fd | this.Load | SCP0085_EndingInventory.cs:501 |  | RETURN | return client.ExecuteDataSet(request).DataSet.Tables[0]; |  | 처리 중단/반환 |  |  |  |

## SCP0085_EndingInventory.GetSearchInfo

진입점: this.Load / RdoMonth.CheckedChanged [if (RdoDate.Checked)] / RdoDate.CheckedChanged [if (RdoDate.Checked)] / datePicker.ValueChanged / monthPicker.ValueChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-907599d5 | this.Load 외 4 | SCP0085_EndingInventory.cs:238 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0085_GET_SEARCH_INFO") ⇒ SCP.SCP0085_GET_SEARCH_INFO | 엔드포인트 요청 생성 |  |  |  |
| AC-54acd6cd | this.Load 외 4 | SCP0085_EndingInventory.cs:239 |  | DATA_OP | request.Parameters["p_yyyymmdd"] | yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-0c3d4eca | this.Load 외 4 | SCP0085_EndingInventory.cs:240 |  | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-4a068c37 | this.Load 외 4 | SCP0085_EndingInventory.cs:243 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a82edb69 | this.Load 외 4 | SCP0085_EndingInventory.cs:247 |  | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |

## SCP0085_EndingInventory.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b0ecef78 | this.Load | SCP0085_EndingInventory.cs:201 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-dc0b2bf9 | this.Load | SCP0085_EndingInventory.cs:203 |  | FLAG | dtMonthRange | GetMonthRange() | 화면 필드/플래그 변경 |  |  |  |
| AC-69808014 | this.Load | SCP0085_EndingInventory.cs:206 |  | FLAG | dtProfitAll | GetSearchInfo(p_yyyymm).Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-72fdaeaa | this.Load | SCP0085_EndingInventory.cs:209 | if (CommonUtils.CheckDataEmpty(dtMyDivision)) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |
| AC-8c6f5f56 | this.Load | SCP0085_EndingInventory.cs:211 |  | LIST_REBIND | clsCtrl.setListBox | (dtMyDivision, cboDivision, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-e538df8f | this.Load | SCP0085_EndingInventory.cs:218 |  | FLAG | isHeaderViewDetail | false | 화면 필드/플래그 변경 |  |  |  |
| AC-94328f25 | this.Load | SCP0085_EndingInventory.cs:220 |  | VALUE_SET | datePicker.Value | DateTime.Now | 컨트롤 값 설정 |  |  |  |
| AC-deed8853 | this.Load | SCP0085_EndingInventory.cs:221 |  | VALUE_SET | chkDetail.Checked | false | 컨트롤 값 설정 |  |  |  |
| AC-44b5115a | this.Load | SCP0085_EndingInventory.cs:223 |  | FLAG | dtItemType | ScpUtils.GetLookupValues("ITEM_TYPE") | 화면 필드/플래그 변경 |  |  |  |
| AC-818700c6 | this.Load | SCP0085_EndingInventory.cs:223 |  | CALL_EXT | ScpUtils.GetLookupValues | ("ITEM_TYPE") | ⚠ 의미 확인 필요 |  |  |  |
| AC-d2d4d7c6 | this.Load | SCP0085_EndingInventory.cs:225 |  | LIST_REBIND | clsCtrl.setListBox | (dtItemType, clbItemType, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0085_EndingInventory.InitSpread

진입점: this.Load / FindButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f2b77704 | this.Load 외 1 | SCP0085_EndingInventory.cs:322 |  | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b8d46ca5 | this.Load 외 1 | SCP0085_EndingInventory.cs:323 |  | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCP0085_EndingInventory.MonthPicker_ValueChanged

진입점: monthPicker.ValueChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-aa8ba3bf | monthPicker.ValueChanged | SCP0085_EndingInventory.cs:612 |  | VALUE_SET | datePicker.Text | date | 컨트롤 값 설정 |  |  |  |
| AC-c2939052 | monthPicker.ValueChanged | SCP0085_EndingInventory.cs:615 |  | FLAG | dtProfitAll | GetSearchInfo(p_yyyymm).Tables[0] | 화면 필드/플래그 변경 |  |  |  |

## SCP0085_EndingInventory.rdButton_Changed

진입점: RdoMonth.CheckedChanged / RdoDate.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f065fc36 | RdoMonth.CheckedChanged 외 1 | SCP0085_EndingInventory.cs:639 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |

## SCP0085_EndingInventory.RefreshProfitByDivisionPlant

진입점: this.Load [if (RdoDate.Checked)] / cboDivision.SelectedIndexChanged / clbPlant.SelectedIndexChanged / RdoMonth.CheckedChanged [if (RdoDate.Checked)] / RdoDate.CheckedChanged [if (RdoDate.Checked)] / datePicker.ValueChanged / monthPicker.ValueChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-420e4038 | this.Load [if (RdoDate.Checked)] 외 6 | SCP0085_EndingInventory.cs:277 |  | FLAG | dtProfit | DBUtils.Filter(dtProfitAll, filterExpression + " AND " + filterExpression2,true) | 화면 필드/플래그 변경 |  |  |  |
| AC-7887fc42 | this.Load [if (RdoDate.Checked)] 외 6 | SCP0085_EndingInventory.cs:277 |  | DATA_OP | DBUtils.Filter | (dtProfitAll, filterExpression + " AND " + filterExpression2,true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-c9952742 | this.Load [if (RdoDate.Checked)] 외 6 | SCP0085_EndingInventory.cs:281 |  | DATA_OP | dtProfit.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-b80558d0 | this.Load [if (RdoDate.Checked)] 외 6 | SCP0085_EndingInventory.cs:291 | try ▸ foreach (DataColumn c in dtProfit.Columns) ▸ if (c.ColumnName == "CODE" \|\| c.ColumnName == "NAME") | DATA_OP | cols.Add | (c.ColumnName) | 데이터 객체 조작/조회 |  |  |  |
| AC-f86ffb30 | this.Load [if (RdoDate.Checked)] 외 6 | SCP0085_EndingInventory.cs:295 | try | CALL_EXT | DBUtils.GetDistinctTable | (res, cols.ToArray()) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ae026916 | this.Load [if (RdoDate.Checked)] 외 6 | SCP0085_EndingInventory.cs:303 |  | FLAG | dtProfit | res | 화면 필드/플래그 변경 |  |  |  |
| AC-a1a2296d | this.Load [if (RdoDate.Checked)] 외 6 | SCP0085_EndingInventory.cs:305 |  | LIST_REBIND | clsCtrl.setListBox | (dtProfit, cboProfit, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0085_EndingInventory.SetChangedControl

진입점: this.Load / cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-51862b0b | this.Load 외 1 | SCP0085_EndingInventory.cs:256 |  | FLAG | dtPlantByGroup | DBUtils.Filter(dtPlantByGroupAll, filterExpression, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-afa81b04 | this.Load 외 1 | SCP0085_EndingInventory.cs:256 |  | DATA_OP | DBUtils.Filter | (dtPlantByGroupAll, filterExpression, true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-0ce31a51 | this.Load 외 1 | SCP0085_EndingInventory.cs:258 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlantByGroup, clbPlant, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0085_EndingInventory.SetColumnFooterData

진입점: ExcelButton [try ▸ if (result == DialogResult.Yes) ▸ try ▸ if (this.DisplayFooter)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5ae692cd | ExcelButton [try ▸ if (result == DialogResult.Yes) ▸ try ▸ i… | SCP0085_EndingInventory.cs:1133 |  | DATA_OP | sv.Rows.Add | (newIdx, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-7360f680 | ExcelButton [try ▸ if (result == DialogResult.Yes) ▸ try ▸ i… | SCP0085_EndingInventory.cs:1137 | for (col <= sv.ColumnFooter.Columns.Count - 1) | GRID_SET | sv.Cells[newIdx, col].Border | columnHeaerStyle.Border | 그리드 속성/값 설정 |  |  |  |
| AC-c7584e78 | ExcelButton [try ▸ if (result == DialogResult.Yes) ▸ try ▸ i… | SCP0085_EndingInventory.cs:1138 | for (col <= sv.ColumnFooter.Columns.Count - 1) | GRID_SET | sv.Cells[newIdx, col].BackColor | columnHeaerStyle.BackColor | 그리드 속성/값 설정 |  |  |  |
| AC-05507ce5 | ExcelButton [try ▸ if (result == DialogResult.Yes) ▸ try ▸ i… | SCP0085_EndingInventory.cs:1139 | for (col <= sv.ColumnFooter.Columns.Count - 1) | GRID_SET | sv.Cells[newIdx, col].HorizontalAlignment | columnHeaerStyle.HorizontalAlignment | 그리드 속성/값 설정 |  |  |  |
| AC-5e1d96a6 | ExcelButton [try ▸ if (result == DialogResult.Yes) ▸ try ▸ i… | SCP0085_EndingInventory.cs:1140 | for (col <= sv.ColumnFooter.Columns.Count - 1) | GRID_SET | sv.Cells[newIdx, col].VerticalAlignment | columnHeaerStyle.VerticalAlignment | 그리드 속성/값 설정 |  |  |  |
| AC-0d55cecf | ExcelButton [try ▸ if (result == DialogResult.Yes) ▸ try ▸ i… | SCP0085_EndingInventory.cs:1142 | for (col <= sv.ColumnFooter.Columns.Count - 1) | GRID_SET | sv.Cells[newIdx, col].Text | sv.ColumnFooter.Cells[0, col].Text | 그리드 속성/값 설정 |  |  |  |

## SCP0085_EndingInventory.SetHeaderDaily

진입점: this.Load / RdoMonth.CheckedChanged / RdoDate.CheckedChanged / FindButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6b167bb4 | this.Load 외 3 | SCP0085_EndingInventory.cs:704 | if (siMain != null) ▸ if (RdoMonth.Checked) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.YYYYMMDD)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-03892cb2 | this.Load 외 3 | SCP0085_EndingInventory.cs:705 | if (siMain != null) ▸ if (RdoMonth.Checked) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.VALUATION_TYPE)].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-0285ba44 | this.Load 외 3 | SCP0085_EndingInventory.cs:709 | if (siMain != null) ▸ else of (RdoMonth.Checked) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.YYYYMMDD)].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-df263683 | this.Load 외 3 | SCP0085_EndingInventory.cs:710 | if (siMain != null) ▸ else of (RdoMonth.Checked) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.VALUATION_TYPE)].Visible | false | 그리드 속성/값 설정 |  |  |  |

## SCP0085_EndingInventory.SetHeaderDivision

진입점: cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0ca94af8 | cboDivision.SelectedIndexChanged | SCP0085_EndingInventory.cs:722 | try | DATA_OP | div.Contains | ("40") | 데이터 객체 조작/조회 |  |  |  |
| AC-b8e4dad3 | cboDivision.SelectedIndexChanged | SCP0085_EndingInventory.cs:724 | try ▸ if (div.Contains("40")) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.CELL_TYPE_GR)].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-6e5afd76 | cboDivision.SelectedIndexChanged | SCP0085_EndingInventory.cs:728 | try ▸ else of (div.Contains("40")) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.CELL_TYPE_GR)].Visible | false | 그리드 속성/값 설정 |  |  |  |

## SCP0085_EndingInventory.SetHeaderViewDetail

진입점: this.Load / spdMain.CellDoubleClick [try] / FindButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-efa6c421 | this.Load 외 2 | SCP0085_EndingInventory.cs:591 | try ▸ if (isHeaderViewDetail) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.UNRESTRICTED_QTY)].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-7eb2a87e | this.Load 외 2 | SCP0085_EndingInventory.cs:592 | try ▸ if (isHeaderViewDetail) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.BLOCKED_STOCK)].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-ddfa0130 | this.Load 외 2 | SCP0085_EndingInventory.cs:593 | try ▸ if (isHeaderViewDetail) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.IN_TRANSIT)].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-1c45bcc4 | this.Load 외 2 | SCP0085_EndingInventory.cs:597 | try ▸ else of (isHeaderViewDetail) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.UNRESTRICTED_QTY)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-f01a1c93 | this.Load 외 2 | SCP0085_EndingInventory.cs:598 | try ▸ else of (isHeaderViewDetail) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.BLOCKED_STOCK)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-1d2c87d8 | this.Load 외 2 | SCP0085_EndingInventory.cs:599 | try ▸ else of (isHeaderViewDetail) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.IN_TRANSIT)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-f1e56923 | this.Load 외 2 | SCP0085_EndingInventory.cs:604 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SCP0085_EndingInventory.SetLayout

진입점: this.Load / chkDetail.CheckedChanged / FindButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d5eacaec | this.Load 외 2 | SCP0085_EndingInventory.cs:746 | try ▸ if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.M1_QUANTITY), isDetailShow ) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-3585f918 | this.Load 외 2 | SCP0085_EndingInventory.cs:747 | try ▸ if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.M2_QUANTITY), isDetailShow ) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-8a5de559 | this.Load 외 2 | SCP0085_EndingInventory.cs:748 | try ▸ if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.M3_QUANTITY), isDetailShow ) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-6bc4d574 | this.Load 외 2 | SCP0085_EndingInventory.cs:749 | try ▸ if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.M4_QUANTITY), isDetailShow ) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-bc0f70f3 | this.Load 외 2 | SCP0085_EndingInventory.cs:750 | try ▸ if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.M5_QUANTITY), isDetailShow ) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-b11adaab | this.Load 외 2 | SCP0085_EndingInventory.cs:751 | try ▸ if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.M6_QUANTITY), isDetailShow ) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-03f2129f | this.Load 외 2 | SCP0085_EndingInventory.cs:752 | try ▸ if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.M7_QUANTITY), isDetailShow ) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-fbf81c94 | this.Load 외 2 | SCP0085_EndingInventory.cs:753 | try ▸ if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.M8_QUANTITY), isDetailShow ) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-9768edb4 | this.Load 외 2 | SCP0085_EndingInventory.cs:754 | try ▸ if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.M9_QUANTITY), isDetailShow ) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-0b5916d9 | this.Load 외 2 | SCP0085_EndingInventory.cs:755 | try ▸ if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.M10_QUANTITY), isDetailShow ) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-f9f24a45 | this.Load 외 2 | SCP0085_EndingInventory.cs:756 | try ▸ if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.M11_QUANTITY), isDetailShow ) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-42500a5b | this.Load 외 2 | SCP0085_EndingInventory.cs:757 | try ▸ if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.M12_QUANTITY), isDetailShow ) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-06a3fdb0 | this.Load 외 2 | SCP0085_EndingInventory.cs:758 | try ▸ if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.M13_QUANTITY), isDetailShow ) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-7936f47b | this.Load 외 2 | SCP0085_EndingInventory.cs:759 | try ▸ if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.M1_AMOUNT), isDetailShow ) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-b574816c | this.Load 외 2 | SCP0085_EndingInventory.cs:760 | try ▸ if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.M2_AMOUNT), isDetailShow ) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-cb1871cf | this.Load 외 2 | SCP0085_EndingInventory.cs:761 | try ▸ if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.M3_AMOUNT), isDetailShow ) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-f5e11697 | this.Load 외 2 | SCP0085_EndingInventory.cs:762 | try ▸ if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.M4_AMOUNT), isDetailShow ) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-284b9d68 | this.Load 외 2 | SCP0085_EndingInventory.cs:763 | try ▸ if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.M5_AMOUNT), isDetailShow ) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-41634753 | this.Load 외 2 | SCP0085_EndingInventory.cs:764 | try ▸ if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.M6_AMOUNT), isDetailShow ) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-a72f2fdd | this.Load 외 2 | SCP0085_EndingInventory.cs:765 | try ▸ if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.M7_AMOUNT), isDetailShow ) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-56cdd685 | this.Load 외 2 | SCP0085_EndingInventory.cs:766 | try ▸ if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.M8_AMOUNT), isDetailShow ) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-bfa64646 | this.Load 외 2 | SCP0085_EndingInventory.cs:767 | try ▸ if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.M9_AMOUNT), isDetailShow ) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-0e98c125 | this.Load 외 2 | SCP0085_EndingInventory.cs:768 | try ▸ if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.M10_AMOUNT), isDetailShow ) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-2715b388 | this.Load 외 2 | SCP0085_EndingInventory.cs:769 | try ▸ if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.M11_AMOUNT), isDetailShow ) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-396e8cb6 | this.Load 외 2 | SCP0085_EndingInventory.cs:770 | try ▸ if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.M12_AMOUNT), isDetailShow ) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-77cc8ce1 | this.Load 외 2 | SCP0085_EndingInventory.cs:771 | try ▸ if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.M13_AMOUNT), isDetailShow ) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-5d53d754 | this.Load 외 2 | SCP0085_EndingInventory.cs:772 | try ▸ if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.M1_AMOUNT_KRW), isDetailShow ) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-2e825d78 | this.Load 외 2 | SCP0085_EndingInventory.cs:773 | try ▸ if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.M2_AMOUNT_KRW), isDetailShow ) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-f896f68d | this.Load 외 2 | SCP0085_EndingInventory.cs:774 | try ▸ if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.M3_AMOUNT_KRW), isDetailShow ) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-4b0db343 | this.Load 외 2 | SCP0085_EndingInventory.cs:775 | try ▸ if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.M4_AMOUNT_KRW), isDetailShow ) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-d004027b | this.Load 외 2 | SCP0085_EndingInventory.cs:776 | try ▸ if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.M5_AMOUNT_KRW), isDetailShow ) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-0a76ef7b | this.Load 외 2 | SCP0085_EndingInventory.cs:777 | try ▸ if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.M6_AMOUNT_KRW), isDetailShow ) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-256ec74a | this.Load 외 2 | SCP0085_EndingInventory.cs:778 | try ▸ if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.M7_AMOUNT_KRW), isDetailShow ) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-7d5842d5 | this.Load 외 2 | SCP0085_EndingInventory.cs:779 | try ▸ if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.M8_AMOUNT_KRW), isDetailShow ) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-1705ccdb | this.Load 외 2 | SCP0085_EndingInventory.cs:780 | try ▸ if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.M9_AMOUNT_KRW), isDetailShow ) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-55a25bbc | this.Load 외 2 | SCP0085_EndingInventory.cs:781 | try ▸ if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.M10_AMOUNT_KRW), isDetailShow ) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-8b28d0e6 | this.Load 외 2 | SCP0085_EndingInventory.cs:782 | try ▸ if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.M11_AMOUNT_KRW), isDetailShow ) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-72d72dd1 | this.Load 외 2 | SCP0085_EndingInventory.cs:783 | try ▸ if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.M12_AMOUNT_KRW), isDetailShow ) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-b7b14282 | this.Load 외 2 | SCP0085_EndingInventory.cs:784 | try ▸ if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.M13_AMOUNT_KRW), isDetailShow ) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCP0085_EndingInventory.SetMonthRange

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cde4eede | this.Load | SCP0085_EndingInventory.cs:509 | if (dtMonthRange != null \|\| dtMonthRange.Rows.Count > 0) | VALUE_SET | monthPicker.InitValue | dtMonthRange.Rows[0]["MAX_YYYYMM"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-ef46beb3 | this.Load | SCP0085_EndingInventory.cs:510 | if (dtMonthRange != null \|\| dtMonthRange.Rows.Count > 0) | UI_PROP | monthPicker.MonthMin | "2021-12" | 속성 MonthMin 설정 |  |  |  |
| AC-9d43320f | this.Load | SCP0085_EndingInventory.cs:511 | if (dtMonthRange != null \|\| dtMonthRange.Rows.Count > 0) | UI_PROP | monthPicker.MonthMax | dtMonthRange.Rows[0]["MAX_YYYYMM"].ToString() | 속성 MonthMax 설정 |  |  |  |

## SCP0085_EndingInventory.SetRadioControl

진입점: this.Load / RdoMonth.CheckedChanged / RdoDate.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d7f9c99c | this.Load 외 2 | SCP0085_EndingInventory.cs:650 | if (RdoDate.Checked) | FLAG | searchGubun | "DAILY" | 화면 필드/플래그 변경 |  |  |  |
| AC-9b27ab30 | this.Load 외 2 | SCP0085_EndingInventory.cs:651 | if (RdoDate.Checked) | VALUE_SET | RdoMonth.Checked | false | 컨트롤 값 설정 |  |  |  |
| AC-b5be136d | this.Load 외 2 | SCP0085_EndingInventory.cs:653 | if (RdoDate.Checked) | STATE | monthPicker.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-f0cbf3d8 | this.Load 외 2 | SCP0085_EndingInventory.cs:654 | if (RdoDate.Checked) | STATE | datePicker.Visible | true | 컨트롤 상태 Visible |  |  |  |
| AC-3b3a158c | this.Load 외 2 | SCP0085_EndingInventory.cs:655 | if (RdoDate.Checked) | UI_PROP | layMonth.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-07dbf4dc | this.Load 외 2 | SCP0085_EndingInventory.cs:656 | if (RdoDate.Checked) | UI_PROP | layDate.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-378dcfdc | this.Load 외 2 | SCP0085_EndingInventory.cs:658 | if (RdoDate.Checked) | UI_PROP | emptySpaceItem3.TextVisible | true | 속성 TextVisible 설정 |  |  |  |
| AC-117652f4 | this.Load 외 2 | SCP0085_EndingInventory.cs:662 | if (RdoDate.Checked) | VALUE_SET | emptySpaceItem3.Text | MessageHelper.GetMessageInfo("MSG00378", UserInfoContext.Current[UserInfoProperites.Langua… | 컨트롤 값 설정 |  |  |  |
| AC-844f01d8 | this.Load 외 2 | SCP0085_EndingInventory.cs:662 | if (RdoDate.Checked) | CALL_EXT | MessageHelper.GetMessageInfo | ("MSG00378", UserInfoContext.Current[UserInfoProperites.Language]) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d4b8e841 | this.Load 외 2 | SCP0085_EndingInventory.cs:665 | if (RdoDate.Checked) | FLAG | dtProfitAll | GetSearchInfo(p_yyyymmdd).Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-eae7f959 | this.Load 외 2 | SCP0085_EndingInventory.cs:671 | else of (RdoDate.Checked) ▸ if (RdoMonth.Checked) | FLAG | searchGubun | "MONTH" | 화면 필드/플래그 변경 |  |  |  |
| AC-bdc6b9d7 | this.Load 외 2 | SCP0085_EndingInventory.cs:672 | else of (RdoDate.Checked) ▸ if (RdoMonth.Checked) | VALUE_SET | RdoDate.Checked | false | 컨트롤 값 설정 |  |  |  |
| AC-d02aadab | this.Load 외 2 | SCP0085_EndingInventory.cs:677 | else of (RdoDate.Checked) ▸ if (RdoMonth.Checked) | UI_PROP | emptySpaceItem3.TextVisible | true | 속성 TextVisible 설정 |  |  |  |
| AC-9297d2eb | this.Load 외 2 | SCP0085_EndingInventory.cs:678 | else of (RdoDate.Checked) ▸ if (RdoMonth.Checked) | VALUE_SET | emptySpaceItem3.Text | MessageHelper.GetMessageInfo("MSG00379", UserInfoContext.Current[UserInfoProperites.Langua… | 컨트롤 값 설정 |  |  |  |
| AC-b5ed1053 | this.Load 외 2 | SCP0085_EndingInventory.cs:678 | else of (RdoDate.Checked) ▸ if (RdoMonth.Checked) | CALL_EXT | MessageHelper.GetMessageInfo | ("MSG00379", UserInfoContext.Current[UserInfoProperites.Language]) | ⚠ 의미 확인 필요 |  |  |  |
| AC-37e2019e | this.Load 외 2 | SCP0085_EndingInventory.cs:681 | else of (RdoDate.Checked) ▸ if (RdoMonth.Checked) | STATE | monthPicker.Visible | true | 컨트롤 상태 Visible |  |  |  |
| AC-a69f2d08 | this.Load 외 2 | SCP0085_EndingInventory.cs:682 | else of (RdoDate.Checked) ▸ if (RdoMonth.Checked) | STATE | datePicker.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-4d68b153 | this.Load 외 2 | SCP0085_EndingInventory.cs:683 | else of (RdoDate.Checked) ▸ if (RdoMonth.Checked) | UI_PROP | layMonth.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-67563ce9 | this.Load 외 2 | SCP0085_EndingInventory.cs:684 | else of (RdoDate.Checked) ▸ if (RdoMonth.Checked) | UI_PROP | layDate.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-1e704f2c | this.Load 외 2 | SCP0085_EndingInventory.cs:687 | else of (RdoDate.Checked) ▸ if (RdoMonth.Checked) | FLAG | dtProfitAll | GetSearchInfo(p_yyyymm).Tables[0] | 화면 필드/플래그 변경 |  |  |  |

## SCP0085_EndingInventory.SetSheetVisible

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-89d1234a | (진입점 미연결) | SCP0085_EndingInventory.cs:838 | try ▸ for (i >= 0) | CALL_EXT | ScpUtils.GetColumnName | (siMain, i) | ⚠ 의미 확인 필요 |  |  |  |
| AC-2be57fde | (진입점 미연결) | SCP0085_EndingInventory.cs:843 | try ▸ for (i >= 0) ▸ switch (columnName) case "CELL_CONVER_FACTOR": case "CELL_CONVER_QUANTITY": | GRID_SET | siMain.ActiveSheet.Columns[i].Visible | isVisible_Sheet | 그리드 속성/값 설정 |  |  |  |
| AC-1a1297a7 | (진입점 미연결) | SCP0085_EndingInventory.cs:847 | try ▸ for (i >= 0) ▸ switch (columnName) case "CELL_CONVER_FACTOR_XLS": case "CELL_CONVER_QUANTITY_XLS": | GRID_SET | siMain.ActiveSheet.Columns[i].Visible | isVisible_Excel | 그리드 속성/값 설정 |  |  |  |

## SCP0085_EndingInventory.SetSpreadColumn

진입점: this.Load / FindButton [finally ▸ if (dsRowCount > 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c5304513 | this.Load 외 1 | SCP0085_EndingInventory.cs:355 | for (iRow < siMain.ActiveSheet.RowCount) ▸ if (USE_CELL_CF_BOM.Equals("Y")) | GRID_SET | siMain.ActiveSheet.Cells[iRow, iCol_CELL_CONVER_FACTOR].BackColor | System.Drawing.Color.Yellow | 그리드 속성/값 설정 |  |  |  |
| AC-5e1b959e | this.Load 외 1 | SCP0085_EndingInventory.cs:356 | for (iRow < siMain.ActiveSheet.RowCount) ▸ if (USE_CELL_CF_BOM.Equals("Y")) | GRID_SET | siMain.ActiveSheet.Cells[iRow, iCol_CELL_CONVER_QUANTITY].BackColor | System.Drawing.Color.Yellow | 그리드 속성/값 설정 |  |  |  |

## SCP0085_EndingInventory.SetSpreadInit

진입점: this.Load / FindButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fa09eae0 | this.Load 외 1 | SCP0085_EndingInventory.cs:330 |  | GRID_INIT | spdInfo.SetSheetHeaderColumn | (spdInfo, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-c005704a | this.Load 외 1 | SCP0085_EndingInventory.cs:331 |  | GRID_INIT | spdInfo.ColumnHeaderHeight | (0, 50) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-972de889 | this.Load 외 1 | SCP0085_EndingInventory.cs:332 |  | GRID_INIT | spdInfo.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0085_EndingInventory.SetToggleHeaderViewDetail

진입점: spdMain.CellDoubleClick [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-32eb87ae | spdMain.CellDoubleClick [try] | SCP0085_EndingInventory.cs:521 | if (isHeaderViewDetail) | FLAG | isHeaderViewDetail | false | 화면 필드/플래그 변경 |  |  |  |
| AC-59744e0f | spdMain.CellDoubleClick [try] | SCP0085_EndingInventory.cs:523 | else of (isHeaderViewDetail) | FLAG | isHeaderViewDetail | true | 화면 필드/플래그 변경 |  |  |  |

## SCP0085_EndingInventory.SpdMain_CellDoubleClick

진입점: spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b3171e0a | spdMain.CellDoubleClick | SCP0085_EndingInventory.cs:570 | try ▸ if (!e.ColumnHeader) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-150bc77a | spdMain.CellDoubleClick | SCP0085_EndingInventory.cs:574 | try ▸ if (e.Column != siMain.GetColumnIndex(DefColumns.QUANTITY)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-58fa5a6e | spdMain.CellDoubleClick | SCP0085_EndingInventory.cs:581 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

