# AS-IS 액션 대조표 — SCP0084

> 원천: `Doc/asisfacts/screens/SCP0084/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 177행 · 메서드 16 · 종류 DATA_OP 56 · CALL_EXT 21 · UI_PROP 15 · GRID_SET 14 · UI_MISC 12 · RETURN 10 · GRID_INIT 8 · POPUP 8 · ENDPOINT 8 · FLAG 7 · MESSAGE 7 · GRID_LOCK 4 · LIST_REBIND 3 · VALIDATE 2 · GRID_BIND 1 · VALUE_SET 1 · ⚠ 의미 확인 필요 21


## SCP0084_LongTermStock.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bab0fb10 | this.Load | SCP0084_LongTermStock.cs:186 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-e2b7d521 | this.Load | SCP0084_LongTermStock.cs:188 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-df21a3dc | this.Load | SCP0084_LongTermStock.cs:190 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0084_LongTermStock.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bde62dcb | Dispose | SCP0084_LongTermStock.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0084_LongTermStock.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6cc82a52 | EditButton | SCP0084_LongTermStock.cs:229 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9f741b54 | EditButton | SCP0084_LongTermStock.cs:231 | if (siMain.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-512fbd18 | EditButton | SCP0084_LongTermStock.cs:232 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-acc43199 | EditButton | SCP0084_LongTermStock.cs:233 |  | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-9a466c78 | EditButton | SCP0084_LongTermStock.cs:236 |  | CALL_EXT | fps.ActiveSheet.GetColumnFromTag | (null, CAppSetting.StringAction) | ⚠ 의미 확인 필요 |  |  |  |
| AC-18cfe136 | EditButton | SCP0084_LongTermStock.cs:237 |  | CALL_EXT | fps.ActiveSheet.Columns.Get | (xCol1) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d2e2b70b | EditButton | SCP0084_LongTermStock.cs:239 | if (fps.ActiveSheet.Columns.Get(xCol1).Visible == true) | FLAG | cellclipboardPast | false | 화면 필드/플래그 변경 |  |  |  |
| AC-3bcb6119 | EditButton | SCP0084_LongTermStock.cs:242 |  | GRID_LOCK | siMain.LockRange | (0, 0, siMain.ActiveSheet.RowCount - 1, siMain.ActiveSheet.ColumnCount - 1, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-58327185 | EditButton | SCP0084_LongTermStock.cs:244 |  | CALL_EXT | fps.ActiveSheet.Columns.Get | (xCol1) | ⚠ 의미 확인 필요 |  |  |  |
| AC-78f32bad | EditButton | SCP0084_LongTermStock.cs:246 | if (fps.ActiveSheet.Columns.Get(xCol1).Visible == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c1fc83be | EditButton | SCP0084_LongTermStock.cs:249 |  | GRID_LOCK | siMain.LockRange | (0, siMain.GetColumnIndex(DefColumns.MEMO), spdMain.ActiveSheet.RowCount - 1, siMain.GetCo… | 그리드 편집 잠금/해제 |  |  |  |

## SCP0084_LongTermStock.ExcelButton

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a126e51c | ExcelButton | SCP0084_LongTermStock.cs:263 | try | MESSAGE | MessageHelper.GMessageBox | ("MSG00100") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-2f72283e | ExcelButton | SCP0084_LongTermStock.cs:270 | try ▸ else of (result == DialogResult.Yes) ▸ else of (result == DialogResult.No) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0084_LongTermStock.ExportExcelData

진입점: ExcelButton [try ▸ if (result == DialogResult.Yes)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7948238b | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0084_LongTermStock.cs:535 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-96d48845 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0084_LongTermStock.cs:539 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-c478e2ac | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0084_LongTermStock.cs:546 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-9ff26980 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0084_LongTermStock.cs:553 | try | CALL_EXT | spSpread.Sheets.CopyTo | (myarray, 0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-7b7b9cf7 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0084_LongTermStock.cs:555 | try ▸ if (myarray.Length == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-57a533c3 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0084_LongTermStock.cs:558 | try | CALL_EXT | sp.Sheets.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-a37329be | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0084_LongTermStock.cs:594 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) | DATA_OP | sv.Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-fe81b518 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0084_LongTermStock.cs:599 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) | UI_PROP | newSheet.ReferenceStyle | FarPoint.Win.Spread.Model.ReferenceStyle.A1 | 속성 ReferenceStyle 설정 |  |  |  |
| AC-272c5d4c | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0084_LongTermStock.cs:605 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) | CALL_EXT | ScpUtils.GetColumnName | (newSheet, i) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d40de7c1 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0084_LongTermStock.cs:614 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ switch (columnName) case "CELL_CONVER_QUANTITY": case "LONG_TERM_STOCK_QTY"… | GRID_SET | newSheet.Columns[i].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-a63c8d33 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0084_LongTermStock.cs:622 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ switch (columnName) case "CELL_CONVER_QUANTITY_XLS": case "LONG_TERM_STOCK_… | GRID_SET | newSheet.Columns[i].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-87eb6e88 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0084_LongTermStock.cs:631 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) | CALL_EXT | f.IsRowFilteredOut | (i) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b608301f | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0084_LongTermStock.cs:633 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ if (newSheet.Rows[i].Visible == false \|\| (f != null && f.IsRowFilteredOut… | DATA_OP | newSheet.Rows.Remove | (i, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-132f0a1a | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0084_LongTermStock.cs:642 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ if (newSheet.Columns[i].Visible == false) | DATA_OP | newSheet.Columns.Remove | (i, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-291a5361 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0084_LongTermStock.cs:654 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ if (newSheet.Columns[i].Ce… | GRID_SET | newSheet.Cells[idx.Index, i].CellType | new FarPoint.Win.Spread.CellType.TextCellType() | 그리드 속성/값 설정 |  |  |  |
| AC-b792caf0 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0084_LongTermStock.cs:655 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ if (newSheet.Columns[i].Ce… | GRID_SET | newSheet.Cells[idx.Index, i].Text | sText | 그리드 속성/값 설정 |  |  |  |
| AC-884268f6 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0084_LongTermStock.cs:664 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ if (newSheet.Columns[i].Ce… | GRID_SET | newSheet.Cells[idx.Index, i].CellType | new FarPoint.Win.Spread.CellType.TextCellType() | 그리드 속성/값 설정 |  |  |  |
| AC-650666c8 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0084_LongTermStock.cs:665 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ if (newSheet.Columns[i].Ce… | GRID_SET | newSheet.Cells[idx.Index, i].Text | sText | 그리드 속성/값 설정 |  |  |  |
| AC-d6b19ceb | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0084_LongTermStock.cs:671 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ if (newSheet.Columns[i].Ce… | GRID_SET | newSheet.Columns[i].Formula | "" | 그리드 속성/값 설정 |  |  |  |
| AC-1a8c4b2f | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0084_LongTermStock.cs:684 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (iCol >= 0) ▸ if (newSheet.Columns[iCol].Tag == null) ▸ if (newSheet.Columns[iCol].Dat… | UI_PROP | newSheet.FrozenColumnCount | iCol | 속성 FrozenColumnCount 설정 |  |  |  |
| AC-fc086e14 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0084_LongTermStock.cs:693 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (iCol >= 0) ▸ else of (newSheet.Columns[iCol].Tag == null) ▸ if (newSheet.Columns[iCol… | UI_PROP | newSheet.FrozenColumnCount | iCol + 1 | 속성 FrozenColumnCount 설정 |  |  |  |
| AC-e1f5c11f | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0084_LongTermStock.cs:700 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) | DATA_OP | sp.Sheets.Add | (newSheet) | 데이터 객체 조작/조회 |  |  |  |
| AC-433b33de | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0084_LongTermStock.cs:705 | try | UI_PROP | siNew.Border | new FarPoint.Win.LineBorder(Color.Black, 1, true, true, true, true) | 속성 Border 설정 |  |  |  |
| AC-18eff4e0 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0084_LongTermStock.cs:707 | try | UI_PROP | newSheet.DefaultStyle | siNew | 속성 DefaultStyle 설정 |  |  |  |
| AC-c13babf3 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0084_LongTermStock.cs:711 | try | UI_PROP | siNewColHeader.Border | new FarPoint.Win.LineBorder(Color.Black, 1, true, true, true, true) | 속성 Border 설정 |  |  |  |
| AC-b2850f5b | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0084_LongTermStock.cs:713 | try | GRID_SET | newSheet.ColumnHeader.DefaultStyle | siNewColHeader | 그리드 속성/값 설정 |  |  |  |
| AC-b2e5574e | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0084_LongTermStock.cs:721 | try ▸ if (!bFrozenCheck) | UI_PROP | newSheet.FrozenColumnCount | 0 | 속성 FrozenColumnCount 설정 |  |  |  |
| AC-dfe3e98b | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0084_LongTermStock.cs:723 | try | UI_PROP | sp.TabStripPolicy | TabStripPolicy.Always | 속성 TabStripPolicy 설정 |  |  |  |
| AC-792d727e | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0084_LongTermStock.cs:728 | try ▸ for (iSheetIndex < sp.Sheets.Count) | GRID_SET | sp.Sheets[iSheetIndex].Protect | false | 그리드 속성/값 설정 |  |  |  |
| AC-0bfbab10 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0084_LongTermStock.cs:742 | try ▸ if (isOpen) | CALL_EXT | sp.SaveExcel | (sFileName, gesfDefaultExeclSaveFlg \| FarPoint.Excel.ExcelSaveFlags.UseOOXMLFormat) | ⚠ 의미 확인 필요 |  |  |  |
| AC-0121729f | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0084_LongTermStock.cs:744 | try ▸ if (isOpen) | CALL_EXT | System.Diagnostics.Process.Start | (sFileName) | ⚠ 의미 확인 필요 |  |  |  |
| AC-abd50b36 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0084_LongTermStock.cs:748 | try ▸ else of (isOpen) | POPUP | new SaveFileDialog | () | 팝업/폼 생성 |  |  |  |
| AC-98952954 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0084_LongTermStock.cs:749 | try ▸ else of (isOpen) | UI_PROP | saveFileDialog.Filter | "Excel files (*.xls or .xlsx)\|*.xls;*.xlsx" | 속성 Filter 설정 |  |  |  |
| AC-41b115f6 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0084_LongTermStock.cs:750 | try ▸ else of (isOpen) | UI_PROP | saveFileDialog.Title | "Save an Excel File" | 속성 Title 설정 |  |  |  |
| AC-d722fa4e | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0084_LongTermStock.cs:751 | try ▸ else of (isOpen) | UI_PROP | saveFileDialog.FileName | sExcelFileName | 속성 FileName 설정 |  |  |  |
| AC-ce6b4bdf | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0084_LongTermStock.cs:752 | try ▸ else of (isOpen) | POPUP | saveFileDialog.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-44d1c1bf | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0084_LongTermStock.cs:759 | try ▸ else of (isOpen) ▸ if (saveFileDialog.FileName != "") | CALL_EXT | sFileName.LastIndexOf | (".") | ⚠ 의미 확인 필요 |  |  |  |
| AC-a839ad60 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0084_LongTermStock.cs:761 | try ▸ else of (isOpen) ▸ if (saveFileDialog.FileName != "") ▸ if (sFileName.Substring(sFileName.LastIndexOf(".") + 1).ToString().ToUpper() =… | CALL_EXT | sp.SaveExcel | (sFileName, gesfDefaultExeclSaveFlg) | ⚠ 의미 확인 필요 |  |  |  |
| AC-8a1663f8 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0084_LongTermStock.cs:764 | try ▸ else of (isOpen) ▸ if (saveFileDialog.FileName != "") ▸ else of (sFileName.Substring(sFileName.LastIndexOf(".") + 1).ToString().ToUppe… | CALL_EXT | sp.SaveExcel | (sFileName, gesfDefaultExeclSaveFlg \| FarPoint.Excel.ExcelSaveFlags.UseOOXMLFormat) | ⚠ 의미 확인 필요 |  |  |  |
| AC-43fbf4aa | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0084_LongTermStock.cs:768 | try | CALL_EXT | GC.GetGeneration | ((object)sp) | ⚠ 의미 확인 필요 |  |  |  |
| AC-bd34df91 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0084_LongTermStock.cs:774 | catch ((Exception e)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00003", new object[] { e.Message }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-40ec4225 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0084_LongTermStock.cs:779 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-83cecfc8 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0084_LongTermStock.cs:782 | finally ▸ if (ver >= 0) | CALL_EXT | GC.Collect | (ver) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0084_LongTermStock.Find_Data

진입점: FindButton / SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Equals("S"))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-162ce531 | FindButton 외 1 | SCP0084_LongTermStock.cs:282 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-731c4ee2 | FindButton 외 1 | SCP0084_LongTermStock.cs:285 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-971782f8 | FindButton 외 1 | SCP0084_LongTermStock.cs:285 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1e96e89d | FindButton 외 1 | SCP0084_LongTermStock.cs:289 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-63da64c9 | FindButton 외 1 | SCP0084_LongTermStock.cs:303 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-70654005 | FindButton 외 1 | SCP0084_LongTermStock.cs:304 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCP.Analysis.WSL/FoxDataServi… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-1055dfd6 | FindButton 외 1 | SCP0084_LongTermStock.cs:308 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0084_GET_LONG_TERM_STOCK") ⇒ SCP.SCP0084_GET_LONG_TERM_STOCK | 엔드포인트 요청 생성 |  |  |  |
| AC-324b2b81 | FindButton 외 1 | SCP0084_LongTermStock.cs:309 | try ▸ lambda | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-e52dde77 | FindButton 외 1 | SCP0084_LongTermStock.cs:310 | try ▸ lambda | DATA_OP | request.Parameters["p_yyyymm"] | p_yyyymm | 행/컬럼 값 대입 |  |  |  |
| AC-92755029 | FindButton 외 1 | SCP0084_LongTermStock.cs:311 | try ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-055608c3 | FindButton 외 1 | SCP0084_LongTermStock.cs:312 | try ▸ lambda | DATA_OP | request.Parameters["p_plant_id"] | p_plant_id | 행/컬럼 값 대입 |  |  |  |
| AC-602e5f7b | FindButton 외 1 | SCP0084_LongTermStock.cs:313 | try ▸ lambda | DATA_OP | request.Parameters["p_long_term_type_code"] | p_long_term_type_code | 행/컬럼 값 대입 |  |  |  |
| AC-66ac4769 | FindButton 외 1 | SCP0084_LongTermStock.cs:314 | try ▸ lambda | DATA_OP | request.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-3812f552 | FindButton 외 1 | SCP0084_LongTermStock.cs:316 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-03c0f626 | FindButton 외 1 | SCP0084_LongTermStock.cs:318 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-6d493f0f | FindButton 외 1 | SCP0084_LongTermStock.cs:325 | try | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-dd75c008 | FindButton 외 1 | SCP0084_LongTermStock.cs:327 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-d2daaf12 | FindButton 외 1 | SCP0084_LongTermStock.cs:329 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c658c590 | FindButton 외 1 | SCP0084_LongTermStock.cs:334 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-a5386316 | FindButton 외 1 | SCP0084_LongTermStock.cs:341 | catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-98feab1f | FindButton 외 1 | SCP0084_LongTermStock.cs:342 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-04f9cef8 | FindButton 외 1 | SCP0084_LongTermStock.cs:346 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0084_LongTermStock.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-62a02426 | this.Load | SCP0084_LongTermStock.cs:123 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCP0084_LongTermStock.GetMonthRange

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-89299f3a | this.Load | SCP0084_LongTermStock.cs:354 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0084_GET_MONTH_RANGE") ⇒ SCP.SCP0084_GET_MONTH_RANGE | 엔드포인트 요청 생성 |  |  |  |
| AC-6ecae633 | this.Load | SCP0084_LongTermStock.cs:355 |  | DATA_OP | request.Parameters["p_month"] | 12 | 행/컬럼 값 대입 |  |  |  |
| AC-b7eb5fa7 | this.Load | SCP0084_LongTermStock.cs:357 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-bf6ba90b | this.Load | SCP0084_LongTermStock.cs:357 |  | RETURN | return client.ExecuteDataSet(request).DataSet.Tables[0]; |  | 처리 중단/반환 |  |  |  |

## SCP0084_LongTermStock.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-58d10367 | this.Load | SCP0084_LongTermStock.cs:141 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-08f16ca0 | this.Load | SCP0084_LongTermStock.cs:143 |  | FLAG | dtMonthRange | GetMonthRange() | 화면 필드/플래그 변경 |  |  |  |
| AC-cc796a6f | this.Load | SCP0084_LongTermStock.cs:147 | if (CommonUtils.CheckDataEmpty(dtMyDivision)) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |
| AC-ed25402b | this.Load | SCP0084_LongTermStock.cs:149 |  | LIST_REBIND | clsCtrl.setListBox | (dtMyDivision, cboDivision, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-a3c6c697 | this.Load | SCP0084_LongTermStock.cs:151 |  | FLAG | dtLongTermType | new DataTable() | 화면 필드/플래그 변경 |  |  |  |
| AC-c9f27910 | this.Load | SCP0084_LongTermStock.cs:152 |  | DATA_OP | dtLongTermType.Columns.Add | ("CODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-0f02ece5 | this.Load | SCP0084_LongTermStock.cs:153 |  | DATA_OP | dtLongTermType.Columns.Add | ("NAME") | 데이터 객체 조작/조회 |  |  |  |
| AC-7d99d455 | this.Load | SCP0084_LongTermStock.cs:154 |  | DATA_OP | dtLongTermType.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-75a1a3c6 | this.Load | SCP0084_LongTermStock.cs:155 |  | DATA_OP | dataRow["CODE"] | DefLongTermType.CODE_2 | 행/컬럼 값 대입 |  |  |  |
| AC-1160d229 | this.Load | SCP0084_LongTermStock.cs:156 |  | DATA_OP | dataRow["NAME"] | DefLongTermType.CODE_2_NAME | 행/컬럼 값 대입 |  |  |  |
| AC-e0321fd0 | this.Load | SCP0084_LongTermStock.cs:157 |  | DATA_OP | dtLongTermType.Rows.Add | (dataRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-e9b56014 | this.Load | SCP0084_LongTermStock.cs:158 |  | DATA_OP | dtLongTermType.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-40e743ac | this.Load | SCP0084_LongTermStock.cs:159 |  | DATA_OP | dataRow["CODE"] | DefLongTermType.CODE_5 | 행/컬럼 값 대입 |  |  |  |
| AC-a58c9dd4 | this.Load | SCP0084_LongTermStock.cs:160 |  | DATA_OP | dataRow["NAME"] | DefLongTermType.CODE_5_NAME | 행/컬럼 값 대입 |  |  |  |
| AC-3b38cc12 | this.Load | SCP0084_LongTermStock.cs:161 |  | DATA_OP | dtLongTermType.Rows.Add | (dataRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-e22c4619 | this.Load | SCP0084_LongTermStock.cs:162 |  | DATA_OP | dtLongTermType.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-3441b794 | this.Load | SCP0084_LongTermStock.cs:163 |  | DATA_OP | dataRow["CODE"] | DefLongTermType.CODE_6 | 행/컬럼 값 대입 |  |  |  |
| AC-5de334ed | this.Load | SCP0084_LongTermStock.cs:164 |  | DATA_OP | dataRow["NAME"] | DefLongTermType.CODE_6_NAME | 행/컬럼 값 대입 |  |  |  |
| AC-0058c72f | this.Load | SCP0084_LongTermStock.cs:165 |  | DATA_OP | dtLongTermType.Rows.Add | (dataRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-91916c28 | this.Load | SCP0084_LongTermStock.cs:167 |  | LIST_REBIND | clsCtrl.setListBox | (dtLongTermType, cboLongTermType, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0084_LongTermStock.InitSpread

진입점: this.Load / FindButton [try] / SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Equals("S")) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ba9bc8bc | this.Load 외 2 | SCP0084_LongTermStock.cs:199 |  | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-fefaa294 | this.Load 외 2 | SCP0084_LongTermStock.cs:200 |  | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCP0084_LongTermStock.SaveData_Memo

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ccf3e22e | SaveButton | SCP0084_LongTermStock.cs:374 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-30fe9fd4 | SaveButton | SCP0084_LongTermStock.cs:383 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (siMain.ActiveSheet.Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a37035ee | SaveButton | SCP0084_LongTermStock.cs:389 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("YYYYMM") | 데이터 객체 조작/조회 |  |  |  |
| AC-a0c9418f | SaveButton | SCP0084_LongTermStock.cs:390 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("PLANT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-7d69b870 | SaveButton | SCP0084_LongTermStock.cs:391 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-72a6964f | SaveButton | SCP0084_LongTermStock.cs:392 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-ce742afa | SaveButton | SCP0084_LongTermStock.cs:393 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("CHARG") | 데이터 객체 조작/조회 |  |  |  |
| AC-8c93afe5 | SaveButton | SCP0084_LongTermStock.cs:394 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("DEVALUATION_AGE") | 데이터 객체 조작/조회 |  |  |  |
| AC-56bf0898 | SaveButton | SCP0084_LongTermStock.cs:395 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("MEMO") | 데이터 객체 조작/조회 |  |  |  |
| AC-b281a818 | SaveButton | SCP0084_LongTermStock.cs:396 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("USER_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-27234a89 | SaveButton | SCP0084_LongTermStock.cs:397 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("PROGRAM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-1bb134d7 | SaveButton | SCP0084_LongTermStock.cs:398 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("DEBUG_MODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-6e936f2f | SaveButton | SCP0084_LongTermStock.cs:400 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dsInput.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-51496b2b | SaveButton | SCP0084_LongTermStock.cs:409 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dsInput.Tables[0].NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-a85b8a1d | SaveButton | SCP0084_LongTermStock.cs:411 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr["YYYYMM"] | siMain.GetValue2(i, siMain.GetColumnIndex(DefColumns.YYYYMM_VAL)) | 행/컬럼 값 대입 |  |  |  |
| AC-f1c590bb | SaveButton | SCP0084_LongTermStock.cs:411 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) | CALL_EXT | siMain.GetValue2 | (i, siMain.GetColumnIndex(DefColumns.YYYYMM_VAL)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-1ccb73a4 | SaveButton | SCP0084_LongTermStock.cs:412 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr["PLANT_ID"] | siMain.GetValue2(i, siMain.GetColumnIndex(DefColumns.PLANT_ID)) | 행/컬럼 값 대입 |  |  |  |
| AC-27069c71 | SaveButton | SCP0084_LongTermStock.cs:412 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) | CALL_EXT | siMain.GetValue2 | (i, siMain.GetColumnIndex(DefColumns.PLANT_ID)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-888b9845 | SaveButton | SCP0084_LongTermStock.cs:413 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr["DIVISION_ID"] | siMain.GetValue2(i, siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | 행/컬럼 값 대입 |  |  |  |
| AC-4bd872ec | SaveButton | SCP0084_LongTermStock.cs:413 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) | CALL_EXT | siMain.GetValue2 | (i, siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c35bbdad | SaveButton | SCP0084_LongTermStock.cs:414 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr["ITEM_ID"] | siMain.GetValue2(i, siMain.GetColumnIndex(DefColumns.ITEM_ID)) | 행/컬럼 값 대입 |  |  |  |
| AC-3a9fa15b | SaveButton | SCP0084_LongTermStock.cs:414 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) | CALL_EXT | siMain.GetValue2 | (i, siMain.GetColumnIndex(DefColumns.ITEM_ID)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d2e92789 | SaveButton | SCP0084_LongTermStock.cs:415 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr["CHARG"] | siMain.GetValue2(i, siMain.GetColumnIndex(DefColumns.CHARG)) | 행/컬럼 값 대입 |  |  |  |
| AC-142cb847 | SaveButton | SCP0084_LongTermStock.cs:415 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) | CALL_EXT | siMain.GetValue2 | (i, siMain.GetColumnIndex(DefColumns.CHARG)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-7c8353be | SaveButton | SCP0084_LongTermStock.cs:416 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr["DEVALUATION_AGE"] | siMain.GetValue2(i, siMain.GetColumnIndex(DefColumns.DEVALUATION_AGE)) | 행/컬럼 값 대입 |  |  |  |
| AC-2d7f2223 | SaveButton | SCP0084_LongTermStock.cs:416 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) | CALL_EXT | siMain.GetValue2 | (i, siMain.GetColumnIndex(DefColumns.DEVALUATION_AGE)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-6ad43bb4 | SaveButton | SCP0084_LongTermStock.cs:417 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr["MEMO"] | siMain.GetText(i, siMain.GetColumnIndex(DefColumns.MEMO)) | 행/컬럼 값 대입 |  |  |  |
| AC-8070f0c9 | SaveButton | SCP0084_LongTermStock.cs:418 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-b2031780 | SaveButton | SCP0084_LongTermStock.cs:419 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr["PROGRAM_ID"] | "SCP0084" | 행/컬럼 값 대입 |  |  |  |
| AC-3a0bc83a | SaveButton | SCP0084_LongTermStock.cs:420 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr["DEBUG_MODE"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-7641edfa | SaveButton | SCP0084_LongTermStock.cs:422 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dsInput.Tables[0].Rows.Add | (dr) | 데이터 객체 조작/조회 |  |  |  |
| AC-c845f9f1 | SaveButton | SCP0084_LongTermStock.cs:432 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dsInput.Tables[0].AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-feb9fe56 | SaveButton | SCP0084_LongTermStock.cs:440 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-b64db782 | SaveButton | SCP0084_LongTermStock.cs:449 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | CALL_EXT | sql.AddParameter | ("@SCP0084_MEMO", dsInput.Tables[0]) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3d43858d | SaveButton | SCP0084_LongTermStock.cs:450 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | ENDPOINT | sql.ExcuteProcedure | ("SaveLongTermStockMemo") ⇒ biz:AppService.GeneralRunProcedureCustomTable [procedure=SaveLongTermStockMemo] … | 엔드포인트 호출 |  |  |  |
| AC-b5e56581 | SaveButton | SCP0084_LongTermStock.cs:453 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-8c321948 | SaveButton | SCP0084_LongTermStock.cs:458 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (result != n… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { iCount }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-31c54acf | SaveButton | SCP0084_LongTermStock.cs:467 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ else of (result… | MESSAGE | MessageHelper.GMessageBox | ("MSG00003", new object[] { ReErrorMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0fb44451 | SaveButton | SCP0084_LongTermStock.cs:476 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ catch ((Exception ex)… | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-42249e6d | SaveButton | SCP0084_LongTermStock.cs:478 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ catch ((Exception ex)… | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-40f54acc | SaveButton | SCP0084_LongTermStock.cs:484 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ finally ▸ if (!prgClo… | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-db6b5f47 | SaveButton | SCP0084_LongTermStock.cs:497 | catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-1357527f | SaveButton | SCP0084_LongTermStock.cs:498 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8bb9b8e0 | SaveButton | SCP0084_LongTermStock.cs:502 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-99e8616c | SaveButton | SCP0084_LongTermStock.cs:503 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## SCP0084_LongTermStock.SCM_SYS_LOG_BATCH

진입점: SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try] / ExcelButton [try ▸ if (result == DialogResult.Yes) ▸ catch ((Exception e))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ccf80a8f | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… 외 1 | SCP0084_LongTermStock.cs:514 | try | ENDPOINT | new FoxDataRequest | ("SCP.PR_SCM_SYS_LOG_BATCH") ⇒ SCP.PR_SCM_SYS_LOG_BATCH | 엔드포인트 요청 생성 |  |  |  |
| AC-1fb34a2e | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… 외 1 | SCP0084_LongTermStock.cs:515 | try | DATA_OP | request.Parameters["p_program_name"] | p_program_name | 행/컬럼 값 대입 |  |  |  |
| AC-fbf2738b | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… 외 1 | SCP0084_LongTermStock.cs:516 | try | DATA_OP | request.Parameters["p_log_type"] | p_log_type | 행/컬럼 값 대입 |  |  |  |
| AC-4a3c014a | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… 외 1 | SCP0084_LongTermStock.cs:517 | try | DATA_OP | request.Parameters["p_log_count"] | p_log_count | 행/컬럼 값 대입 |  |  |  |
| AC-b2d6e6fd | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… 외 1 | SCP0084_LongTermStock.cs:518 | try | DATA_OP | request.Parameters["p_log_message"] | p_log_message | 행/컬럼 값 대입 |  |  |  |
| AC-2bcf2857 | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… 외 1 | SCP0084_LongTermStock.cs:519 | try | DATA_OP | request.Parameters["p_description"] | p_description | 행/컬럼 값 대입 |  |  |  |
| AC-0f9aa482 | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… 외 1 | SCP0084_LongTermStock.cs:520 | try | DATA_OP | request.Parameters["p_event_date"] | DateTime.Now | 행/컬럼 값 대입 |  |  |  |
| AC-e4ee5f35 | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… 외 1 | SCP0084_LongTermStock.cs:522 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## SCP0084_LongTermStock.SetChangedControl

진입점: this.Load / cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-008918a8 | this.Load 외 1 | SCP0084_LongTermStock.cs:179 |  | FLAG | dtPlantByGroup | DBUtils.Filter(dtPlantByGroupAll, filterExpression, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-71f85336 | this.Load 외 1 | SCP0084_LongTermStock.cs:179 |  | DATA_OP | DBUtils.Filter | (dtPlantByGroupAll, filterExpression, true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-6c3c4cf1 | this.Load 외 1 | SCP0084_LongTermStock.cs:181 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlantByGroup, clbPlant, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0084_LongTermStock.SetColumnFooterData

진입점: ExcelButton [try ▸ if (result == DialogResult.Yes) ▸ try ▸ if (this.DisplayFooter)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fb9f6cb8 | ExcelButton [try ▸ if (result == DialogResult.Yes) ▸ try ▸ i… | SCP0084_LongTermStock.cs:792 |  | DATA_OP | sv.Rows.Add | (newIdx, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-2c5c5a61 | ExcelButton [try ▸ if (result == DialogResult.Yes) ▸ try ▸ i… | SCP0084_LongTermStock.cs:796 | for (col <= sv.ColumnFooter.Columns.Count - 1) | GRID_SET | sv.Cells[newIdx, col].Border | columnHeaerStyle.Border | 그리드 속성/값 설정 |  |  |  |
| AC-799a1587 | ExcelButton [try ▸ if (result == DialogResult.Yes) ▸ try ▸ i… | SCP0084_LongTermStock.cs:797 | for (col <= sv.ColumnFooter.Columns.Count - 1) | GRID_SET | sv.Cells[newIdx, col].BackColor | columnHeaerStyle.BackColor | 그리드 속성/값 설정 |  |  |  |
| AC-147a3dca | ExcelButton [try ▸ if (result == DialogResult.Yes) ▸ try ▸ i… | SCP0084_LongTermStock.cs:798 | for (col <= sv.ColumnFooter.Columns.Count - 1) | GRID_SET | sv.Cells[newIdx, col].HorizontalAlignment | columnHeaerStyle.HorizontalAlignment | 그리드 속성/값 설정 |  |  |  |
| AC-503c97a1 | ExcelButton [try ▸ if (result == DialogResult.Yes) ▸ try ▸ i… | SCP0084_LongTermStock.cs:799 | for (col <= sv.ColumnFooter.Columns.Count - 1) | GRID_SET | sv.Cells[newIdx, col].VerticalAlignment | columnHeaerStyle.VerticalAlignment | 그리드 속성/값 설정 |  |  |  |
| AC-6d592d3e | ExcelButton [try ▸ if (result == DialogResult.Yes) ▸ try ▸ i… | SCP0084_LongTermStock.cs:801 | for (col <= sv.ColumnFooter.Columns.Count - 1) | GRID_SET | sv.Cells[newIdx, col].Text | sv.ColumnFooter.Cells[0, col].Text | 그리드 속성/값 설정 |  |  |  |

## SCP0084_LongTermStock.SetMonthRange

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8d9f26f7 | this.Load | SCP0084_LongTermStock.cs:365 | if (dtMonthRange != null \|\| dtMonthRange.Rows.Count > 0) | VALUE_SET | monthPicker.InitValue | dtMonthRange.Rows[0]["MAX_YYYYMM"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-89d5b20b | this.Load | SCP0084_LongTermStock.cs:366 | if (dtMonthRange != null \|\| dtMonthRange.Rows.Count > 0) | UI_PROP | monthPicker.MonthMin | dtMonthRange.Rows[0]["MIN_YYYYMM"].ToString() | 속성 MonthMin 설정 |  |  |  |
| AC-8389a386 | this.Load | SCP0084_LongTermStock.cs:367 | if (dtMonthRange != null \|\| dtMonthRange.Rows.Count > 0) | UI_PROP | monthPicker.MonthMax | dtMonthRange.Rows[0]["MAX_YYYYMM"].ToString() | 속성 MonthMax 설정 |  |  |  |

## SCP0084_LongTermStock.SetSpreadInit

진입점: this.Load / FindButton [try] / SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Equals("S")) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7e60d5bc | this.Load 외 2 | SCP0084_LongTermStock.cs:205 |  | GRID_INIT | spdInfo.SetSheetHeaderColumn | (spdInfo, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-83fd8972 | this.Load 외 2 | SCP0084_LongTermStock.cs:206 |  | GRID_INIT | spdInfo.ColumnHeaderHeight | (0, 50) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-479236d9 | this.Load 외 2 | SCP0084_LongTermStock.cs:207 |  | GRID_INIT | spdInfo.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

