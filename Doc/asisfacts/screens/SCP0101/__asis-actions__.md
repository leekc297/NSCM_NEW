# AS-IS 액션 대조표 — SCP0101

> 원천: `Doc/asisfacts/screens/SCP0101/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 219행 · 메서드 24 · 종류 GRID_SET 42 · FLAG 40 · GRID_INIT 30 · UI_PROP 18 · DATA_OP 17 · CALL_EXT 16 · UI_MISC 12 · POPUP 11 · RETURN 11 · ENDPOINT 7 · GRID_LOCK 4 · MESSAGE 3 · VALUE_SET 2 · VALIDATE 2 · LIST_REBIND 2 · GRID_BIND 1 · COMBO_DATA 1 · ⚠ 의미 확인 필요 16


## SCP0101_InventoryTrend.BtnColumn_Click

진입점: this.btnColumn.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8e3841f4 | this.btnColumn.Click | SCP0101_InventoryTrend.cs:961 |  | POPUP | new SCM0002_TitleSetForm_Popup | ("SCP0101", sSheetName, true) | 팝업/폼 생성 |  |  |  |
| AC-dae9e054 | this.btnColumn.Click | SCP0101_InventoryTrend.cs:962 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-3535f2d8 | this.btnColumn.Click | SCP0101_InventoryTrend.cs:963 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## SCP0101_InventoryTrend.BtnItem_Id_Click

진입점: this.btnItem_Id.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ee5f3e3c | this.btnItem_Id.Click | SCP0101_InventoryTrend.cs:977 |  | POPUP | new SCM0002_ItembyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-900957e8 | this.btnItem_Id.Click | SCP0101_InventoryTrend.cs:979 |  | POPUP | popItem.Form_Load | (true, division, sScmSite, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-9cdb9bf7 | this.btnItem_Id.Click | SCP0101_InventoryTrend.cs:980 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-cead6615 | this.btnItem_Id.Click | SCP0101_InventoryTrend.cs:981 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-681977b1 | this.btnItem_Id.Click | SCP0101_InventoryTrend.cs:987 | if (popItem.ItemID != "") | VALUE_SET | txtItem_Id.Text | sItemId | 컨트롤 값 설정 |  |  |  |

## SCP0101_InventoryTrend.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-03e7d00c | this.Load | SCP0101_InventoryTrend.cs:170 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 2, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-8796c4bc | this.Load | SCP0101_InventoryTrend.cs:171 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-cfeb389a | this.Load | SCP0101_InventoryTrend.cs:173 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0101_InventoryTrend.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ec57ecba | Dispose | SCP0101_InventoryTrend.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0101_InventoryTrend.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-448ab10d | EditButton | SCP0101_InventoryTrend.cs:224 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a8d6a325 | EditButton | SCP0101_InventoryTrend.cs:226 | if (siMain.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f80133ce | EditButton | SCP0101_InventoryTrend.cs:227 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-88f44fc2 | EditButton | SCP0101_InventoryTrend.cs:228 |  | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-ba7744b6 | EditButton | SCP0101_InventoryTrend.cs:231 |  | CALL_EXT | fps.ActiveSheet.GetColumnFromTag | (null, CAppSetting.StringAction) | ⚠ 의미 확인 필요 |  |  |  |
| AC-25f4c0a1 | EditButton | SCP0101_InventoryTrend.cs:232 |  | CALL_EXT | fps.ActiveSheet.Columns.Get | (xCol1) | ⚠ 의미 확인 필요 |  |  |  |
| AC-2f6aa5d5 | EditButton | SCP0101_InventoryTrend.cs:234 | if (fps.ActiveSheet.Columns.Get(xCol1).Visible == true) | FLAG | cellclipboardPast | false | 화면 필드/플래그 변경 |  |  |  |
| AC-8b6eace7 | EditButton | SCP0101_InventoryTrend.cs:237 |  | GRID_LOCK | siMain.LockRange | (0, 0, siMain.ActiveSheet.RowCount - 1, siMain.ActiveSheet.ColumnCount - 1, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-cc719011 | EditButton | SCP0101_InventoryTrend.cs:239 |  | CALL_EXT | fps.ActiveSheet.Columns.Get | (xCol1) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3e646218 | EditButton | SCP0101_InventoryTrend.cs:241 | if (fps.ActiveSheet.Columns.Get(xCol1).Visible == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-75daff91 | EditButton | SCP0101_InventoryTrend.cs:244 |  | GRID_LOCK | siMain.LockRange | (0, siMain.GetColumnIndex(DefColumns.MEMO), spdMain.ActiveSheet.RowCount - 1, siMain.GetCo… | 그리드 편집 잠금/해제 |  |  |  |

## SCP0101_InventoryTrend.ExcelButton

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c5638f63 | ExcelButton | SCP0101_InventoryTrend.cs:256 | try | MESSAGE | MessageHelper.GMessageBox | ("MSG00100") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-11ac589f | ExcelButton | SCP0101_InventoryTrend.cs:263 | try ▸ else of (result == DialogResult.Yes) ▸ else of (result == DialogResult.No) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0101_InventoryTrend.ExportExcelData

진입점: ExcelButton [try ▸ if (result == DialogResult.Yes)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c24a227b | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0101_InventoryTrend.cs:680 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-87edc206 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0101_InventoryTrend.cs:684 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-e7cec616 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0101_InventoryTrend.cs:691 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-70166d4e | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0101_InventoryTrend.cs:698 | try | CALL_EXT | spSpread.Sheets.CopyTo | (myarray, 0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c6634c7a | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0101_InventoryTrend.cs:700 | try ▸ if (myarray.Length == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-95f5d1aa | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0101_InventoryTrend.cs:703 | try | CALL_EXT | sp.Sheets.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-b995d6d4 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0101_InventoryTrend.cs:739 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) | DATA_OP | sv.Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-806791c5 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0101_InventoryTrend.cs:744 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) | UI_PROP | newSheet.ReferenceStyle | FarPoint.Win.Spread.Model.ReferenceStyle.A1 | 속성 ReferenceStyle 설정 |  |  |  |
| AC-ed9a82f4 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0101_InventoryTrend.cs:776 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) | CALL_EXT | f.IsRowFilteredOut | (i) | ⚠ 의미 확인 필요 |  |  |  |
| AC-17aa5ce7 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0101_InventoryTrend.cs:778 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ if (newSheet.Rows[i].Visible == false \|\| (f != null && f.IsRowFilteredOut… | DATA_OP | newSheet.Rows.Remove | (i, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-028c7f54 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0101_InventoryTrend.cs:787 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ if (newSheet.Columns[i].Visible == false) | DATA_OP | newSheet.Columns.Remove | (i, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-93c88f84 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0101_InventoryTrend.cs:799 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ if (newSheet.Columns[i].Ce… | GRID_SET | newSheet.Cells[idx.Index, i].CellType | new FarPoint.Win.Spread.CellType.TextCellType() | 그리드 속성/값 설정 |  |  |  |
| AC-90d79fb8 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0101_InventoryTrend.cs:800 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ if (newSheet.Columns[i].Ce… | GRID_SET | newSheet.Cells[idx.Index, i].Text | sText | 그리드 속성/값 설정 |  |  |  |
| AC-110feb20 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0101_InventoryTrend.cs:809 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ if (newSheet.Columns[i].Ce… | GRID_SET | newSheet.Cells[idx.Index, i].CellType | new FarPoint.Win.Spread.CellType.TextCellType() | 그리드 속성/값 설정 |  |  |  |
| AC-462bf773 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0101_InventoryTrend.cs:810 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ if (newSheet.Columns[i].Ce… | GRID_SET | newSheet.Cells[idx.Index, i].Text | sText | 그리드 속성/값 설정 |  |  |  |
| AC-aae3bd1b | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0101_InventoryTrend.cs:816 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ if (newSheet.Columns[i].Ce… | GRID_SET | newSheet.Columns[i].Formula | "" | 그리드 속성/값 설정 |  |  |  |
| AC-e15da32f | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0101_InventoryTrend.cs:829 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (iCol >= 0) ▸ if (newSheet.Columns[iCol].Tag == null) ▸ if (newSheet.Columns[iCol].Dat… | UI_PROP | newSheet.FrozenColumnCount | iCol | 속성 FrozenColumnCount 설정 |  |  |  |
| AC-70c443f1 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0101_InventoryTrend.cs:838 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (iCol >= 0) ▸ else of (newSheet.Columns[iCol].Tag == null) ▸ if (newSheet.Columns[iCol… | UI_PROP | newSheet.FrozenColumnCount | iCol + 1 | 속성 FrozenColumnCount 설정 |  |  |  |
| AC-82ac9ebc | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0101_InventoryTrend.cs:845 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) | DATA_OP | sp.Sheets.Add | (newSheet) | 데이터 객체 조작/조회 |  |  |  |
| AC-764d98a3 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0101_InventoryTrend.cs:850 | try | UI_PROP | siNew.Border | new FarPoint.Win.LineBorder(Color.Black, 1, true, true, true, true) | 속성 Border 설정 |  |  |  |
| AC-bf3d8edd | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0101_InventoryTrend.cs:852 | try | UI_PROP | newSheet.DefaultStyle | siNew | 속성 DefaultStyle 설정 |  |  |  |
| AC-3cc4aace | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0101_InventoryTrend.cs:856 | try | UI_PROP | siNewColHeader.Border | new FarPoint.Win.LineBorder(Color.Black, 1, true, true, true, true) | 속성 Border 설정 |  |  |  |
| AC-8ea243e2 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0101_InventoryTrend.cs:858 | try | GRID_SET | newSheet.ColumnHeader.DefaultStyle | siNewColHeader | 그리드 속성/값 설정 |  |  |  |
| AC-487c3a26 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0101_InventoryTrend.cs:866 | try ▸ if (!bFrozenCheck) | UI_PROP | newSheet.FrozenColumnCount | 0 | 속성 FrozenColumnCount 설정 |  |  |  |
| AC-12e1a0f4 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0101_InventoryTrend.cs:868 | try | UI_PROP | sp.TabStripPolicy | TabStripPolicy.Always | 속성 TabStripPolicy 설정 |  |  |  |
| AC-84582fca | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0101_InventoryTrend.cs:873 | try ▸ for (iSheetIndex < sp.Sheets.Count) | GRID_SET | sp.Sheets[iSheetIndex].Protect | false | 그리드 속성/값 설정 |  |  |  |
| AC-4c83a29a | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0101_InventoryTrend.cs:887 | try ▸ if (isOpen) | CALL_EXT | sp.SaveExcel | (sFileName, gesfDefaultExeclSaveFlg \| FarPoint.Excel.ExcelSaveFlags.UseOOXMLFormat) | ⚠ 의미 확인 필요 |  |  |  |
| AC-16065014 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0101_InventoryTrend.cs:889 | try ▸ if (isOpen) | CALL_EXT | System.Diagnostics.Process.Start | (sFileName) | ⚠ 의미 확인 필요 |  |  |  |
| AC-28adb49c | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0101_InventoryTrend.cs:893 | try ▸ else of (isOpen) | POPUP | new SaveFileDialog | () | 팝업/폼 생성 |  |  |  |
| AC-da7bdc11 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0101_InventoryTrend.cs:894 | try ▸ else of (isOpen) | UI_PROP | saveFileDialog.Filter | "Excel files (*.xls or .xlsx)\|*.xls;*.xlsx" | 속성 Filter 설정 |  |  |  |
| AC-74276192 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0101_InventoryTrend.cs:895 | try ▸ else of (isOpen) | UI_PROP | saveFileDialog.Title | "Save an Excel File" | 속성 Title 설정 |  |  |  |
| AC-82b37d39 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0101_InventoryTrend.cs:896 | try ▸ else of (isOpen) | UI_PROP | saveFileDialog.FileName | sExcelFileName | 속성 FileName 설정 |  |  |  |
| AC-603a0cd8 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0101_InventoryTrend.cs:897 | try ▸ else of (isOpen) | POPUP | saveFileDialog.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-3f734607 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0101_InventoryTrend.cs:904 | try ▸ else of (isOpen) ▸ if (saveFileDialog.FileName != "") | CALL_EXT | sFileName.LastIndexOf | (".") | ⚠ 의미 확인 필요 |  |  |  |
| AC-0b107c53 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0101_InventoryTrend.cs:906 | try ▸ else of (isOpen) ▸ if (saveFileDialog.FileName != "") ▸ if (sFileName.Substring(sFileName.LastIndexOf(".") + 1).ToString().ToUpper() =… | CALL_EXT | sp.SaveExcel | (sFileName, gesfDefaultExeclSaveFlg) | ⚠ 의미 확인 필요 |  |  |  |
| AC-06a1d4b9 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0101_InventoryTrend.cs:909 | try ▸ else of (isOpen) ▸ if (saveFileDialog.FileName != "") ▸ else of (sFileName.Substring(sFileName.LastIndexOf(".") + 1).ToString().ToUppe… | CALL_EXT | sp.SaveExcel | (sFileName, gesfDefaultExeclSaveFlg \| FarPoint.Excel.ExcelSaveFlags.UseOOXMLFormat) | ⚠ 의미 확인 필요 |  |  |  |
| AC-7f5ad212 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0101_InventoryTrend.cs:913 | try | CALL_EXT | GC.GetGeneration | ((object)sp) | ⚠ 의미 확인 필요 |  |  |  |
| AC-41d68879 | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0101_InventoryTrend.cs:919 | catch ((Exception e)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00003", new object[] { e.Message }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-7ce77bcd | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0101_InventoryTrend.cs:924 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-c4bbae1b | ExcelButton [try ▸ if (result == DialogResult.Yes)] | SCP0101_InventoryTrend.cs:927 | finally ▸ if (ver >= 0) | CALL_EXT | GC.Collect | (ver) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0101_InventoryTrend.Find_Data

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dfd1ca11 | FindButton | SCP0101_InventoryTrend.cs:275 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-c0d367da | FindButton | SCP0101_InventoryTrend.cs:278 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-d926e38a | FindButton | SCP0101_InventoryTrend.cs:278 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b9722626 | FindButton | SCP0101_InventoryTrend.cs:282 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-7a3a0d8e | FindButton | SCP0101_InventoryTrend.cs:296 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-7358d4bd | FindButton | SCP0101_InventoryTrend.cs:297 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCP.Analysis.WSL/FoxDataServi… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-cc8be529 | FindButton | SCP0101_InventoryTrend.cs:301 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0101_GET_INVENTORY_TREND") ⇒ SCP.SCP0101_GET_INVENTORY_TREND | 엔드포인트 요청 생성 |  |  |  |
| AC-03645b31 | FindButton | SCP0101_InventoryTrend.cs:302 | try ▸ lambda | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-91aa18a7 | FindButton | SCP0101_InventoryTrend.cs:303 | try ▸ lambda | DATA_OP | request.Parameters["p_yyyymm"] | p_yyyymm | 행/컬럼 값 대입 |  |  |  |
| AC-a1850aff | FindButton | SCP0101_InventoryTrend.cs:304 | try ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-dd0be496 | FindButton | SCP0101_InventoryTrend.cs:305 | try ▸ lambda | DATA_OP | request.Parameters["p_plant_id"] | p_plant_id | 행/컬럼 값 대입 |  |  |  |
| AC-efb031dc | FindButton | SCP0101_InventoryTrend.cs:306 | try ▸ lambda | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-13eff018 | FindButton | SCP0101_InventoryTrend.cs:307 | try ▸ lambda | DATA_OP | request.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-7c1ec09e | FindButton | SCP0101_InventoryTrend.cs:309 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-b7926f7f | FindButton | SCP0101_InventoryTrend.cs:311 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-d82fbbbf | FindButton | SCP0101_InventoryTrend.cs:318 | try | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-33b363a7 | FindButton | SCP0101_InventoryTrend.cs:320 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-c8bc7720 | FindButton | SCP0101_InventoryTrend.cs:325 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-732f7850 | FindButton | SCP0101_InventoryTrend.cs:330 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-2e20b55e | FindButton | SCP0101_InventoryTrend.cs:337 | catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-64de2e56 | FindButton | SCP0101_InventoryTrend.cs:338 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8d67c5d1 | FindButton | SCP0101_InventoryTrend.cs:342 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0101_InventoryTrend.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-85e289cf | this.Load | SCP0101_InventoryTrend.cs:131 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCP0101_InventoryTrend.GetMonthRange

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-24c61d81 | this.Load | SCP0101_InventoryTrend.cs:634 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0084_GET_MONTH_RANGE") ⇒ SCP.SCP0084_GET_MONTH_RANGE | 엔드포인트 요청 생성 |  |  |  |
| AC-78a18467 | this.Load | SCP0101_InventoryTrend.cs:635 |  | DATA_OP | request.Parameters["p_month"] | 12 | 행/컬럼 값 대입 |  |  |  |
| AC-2f4886fe | this.Load | SCP0101_InventoryTrend.cs:637 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-b0b7951d | this.Load | SCP0101_InventoryTrend.cs:637 |  | RETURN | return client.ExecuteDataSet(request).DataSet.Tables[0]; |  | 처리 중단/반환 |  |  |  |

## SCP0101_InventoryTrend.GetToday

진입점: this.Load / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK)] / monthPicker.ValueChanged / FindButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c052407b | this.Load 외 3 | SCP0101_InventoryTrend.cs:411 |  | RETURN | return today; |  | 처리 중단/반환 |  |  |  |

## SCP0101_InventoryTrend.GetYYMM

진입점: this.Load / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK)] / monthPicker.ValueChanged / FindButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f1cb10e1 | this.Load 외 3 | SCP0101_InventoryTrend.cs:405 |  | RETURN | return YYMM; |  | 처리 중단/반환 |  |  |  |

## SCP0101_InventoryTrend.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f50a1cc0 | this.Load | SCP0101_InventoryTrend.cs:148 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-7e4e2e07 | this.Load | SCP0101_InventoryTrend.cs:150 |  | FLAG | dtMonthRange | GetMonthRange() | 화면 필드/플래그 변경 |  |  |  |
| AC-a065acc7 | this.Load | SCP0101_InventoryTrend.cs:154 | if (CommonUtils.CheckDataEmpty(dtMyDivision)) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |
| AC-240cfa00 | this.Load | SCP0101_InventoryTrend.cs:156 |  | LIST_REBIND | clsCtrl.setListBox | (dtMyDivision, cboDivision, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0101_InventoryTrend.InitSpread

진입점: this.Load / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK)] / FindButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8f0b268b | this.Load 외 2 | SCP0101_InventoryTrend.cs:182 |  | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a4dfb4d5 | this.Load 외 2 | SCP0101_InventoryTrend.cs:183 |  | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCP0101_InventoryTrend.SCM_SYS_LOG_BATCH

진입점: ExcelButton [try ▸ if (result == DialogResult.Yes) ▸ catch ((Exception e))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b26d015c | ExcelButton [try ▸ if (result == DialogResult.Yes) ▸ catch (… | SCP0101_InventoryTrend.cs:659 | try | ENDPOINT | new FoxDataRequest | ("SCP.PR_SCM_SYS_LOG_BATCH") ⇒ SCP.PR_SCM_SYS_LOG_BATCH | 엔드포인트 요청 생성 |  |  |  |
| AC-5b72b573 | ExcelButton [try ▸ if (result == DialogResult.Yes) ▸ catch (… | SCP0101_InventoryTrend.cs:660 | try | DATA_OP | request.Parameters["p_program_name"] | p_program_name | 행/컬럼 값 대입 |  |  |  |
| AC-264f60bb | ExcelButton [try ▸ if (result == DialogResult.Yes) ▸ catch (… | SCP0101_InventoryTrend.cs:661 | try | DATA_OP | request.Parameters["p_log_type"] | p_log_type | 행/컬럼 값 대입 |  |  |  |
| AC-21521b89 | ExcelButton [try ▸ if (result == DialogResult.Yes) ▸ catch (… | SCP0101_InventoryTrend.cs:662 | try | DATA_OP | request.Parameters["p_log_count"] | p_log_count | 행/컬럼 값 대입 |  |  |  |
| AC-38495bbe | ExcelButton [try ▸ if (result == DialogResult.Yes) ▸ catch (… | SCP0101_InventoryTrend.cs:663 | try | DATA_OP | request.Parameters["p_log_message"] | p_log_message | 행/컬럼 값 대입 |  |  |  |
| AC-eba93a9f | ExcelButton [try ▸ if (result == DialogResult.Yes) ▸ catch (… | SCP0101_InventoryTrend.cs:664 | try | DATA_OP | request.Parameters["p_description"] | p_description | 행/컬럼 값 대입 |  |  |  |
| AC-46735753 | ExcelButton [try ▸ if (result == DialogResult.Yes) ▸ catch (… | SCP0101_InventoryTrend.cs:665 | try | DATA_OP | request.Parameters["p_event_date"] | DateTime.Now | 행/컬럼 값 대입 |  |  |  |
| AC-ace7cc61 | ExcelButton [try ▸ if (result == DialogResult.Yes) ▸ catch (… | SCP0101_InventoryTrend.cs:667 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## SCP0101_InventoryTrend.SetBackColor

진입점: FindButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-33447b7f | FindButton [try] | SCP0101_InventoryTrend.cs:463 | for (i < siMain.GetMaxRowIndex()) | FLAG | cellValue | siMain.GetValue(i, iColFocus).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-f1eea011 | FindButton [try] | SCP0101_InventoryTrend.cs:475 |  | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-5f9d3017 | FindButton [try] | SCP0101_InventoryTrend.cs:479 |  | UI_PROP | range1.BackColor | BackColor | 속성 BackColor 설정 |  |  |  |
| AC-d6a76315 | FindButton [try] | SCP0101_InventoryTrend.cs:481 |  | UI_MISC | this.siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## SCP0101_InventoryTrend.SetCellColor

진입점: FindButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7e04d4d6 | FindButton [try] | SCP0101_InventoryTrend.cs:501 |  | FLAG | iColChk | siMain.GetColumnIndex("CHK_QTY") | 화면 필드/플래그 변경 |  |  |  |
| AC-4ba02250 | FindButton [try] | SCP0101_InventoryTrend.cs:502 |  | FLAG | iColQty | siMain.GetColumnIndex("QTY_MONTH_FOCUS") | 화면 필드/플래그 변경 |  |  |  |
| AC-328cd78f | FindButton [try] | SCP0101_InventoryTrend.cs:503 |  | FLAG | iColAvailable | siMain.GetColumnIndex("INV_STATUS_AVAILABLE") | 화면 필드/플래그 변경 |  |  |  |
| AC-e903ceff | FindButton [try] | SCP0101_InventoryTrend.cs:504 |  | FLAG | iColHolding | siMain.GetColumnIndex("INV_STATUS_HOLDING") | 화면 필드/플래그 변경 |  |  |  |
| AC-df7d02ed | FindButton [try] | SCP0101_InventoryTrend.cs:505 |  | FLAG | iColQT | siMain.GetColumnIndex("INV_STATUS_QT") | 화면 필드/플래그 변경 |  |  |  |
| AC-4ff6eba6 | FindButton [try] | SCP0101_InventoryTrend.cs:506 |  | FLAG | iColBlocked | siMain.GetColumnIndex("INV_STATUS_BLOCKED") | 화면 필드/플래그 변경 |  |  |  |
| AC-2782afa6 | FindButton [try] | SCP0101_InventoryTrend.cs:507 |  | FLAG | cellQty | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-ccd73351 | FindButton [try] | SCP0101_InventoryTrend.cs:508 |  | FLAG | colName | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-9f25058e | FindButton [try] | SCP0101_InventoryTrend.cs:510 |  | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-d503f04c | FindButton [try] | SCP0101_InventoryTrend.cs:513 | for (i < siMain.GetMaxRowIndex()) | FLAG | cellQty | siMain.GetValue(i, iColChk).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-ea40f2eb | FindButton [try] | SCP0101_InventoryTrend.cs:517 | for (i < siMain.GetMaxRowIndex()) ▸ switch (cellQty) case "40": | GRID_SET | siMain.ActiveSheet.Cells[i, iColAvailable].BackColor | Color.LightGreen | 그리드 속성/값 설정 |  |  |  |
| AC-247cfab9 | FindButton [try] | SCP0101_InventoryTrend.cs:518 | for (i < siMain.GetMaxRowIndex()) ▸ switch (cellQty) case "40": | GRID_SET | siMain.ActiveSheet.Cells[i, iColHolding].BackColor | Color.LightGreen | 그리드 속성/값 설정 |  |  |  |
| AC-6c0c3193 | FindButton [try] | SCP0101_InventoryTrend.cs:519 | for (i < siMain.GetMaxRowIndex()) ▸ switch (cellQty) case "40": | GRID_SET | siMain.ActiveSheet.Cells[i, iColQT].BackColor | Color.LightGreen | 그리드 속성/값 설정 |  |  |  |
| AC-cd4b4eee | FindButton [try] | SCP0101_InventoryTrend.cs:520 | for (i < siMain.GetMaxRowIndex()) ▸ switch (cellQty) case "40": | GRID_SET | siMain.ActiveSheet.Cells[i, iColBlocked].BackColor | Color.LightGreen | 그리드 속성/값 설정 |  |  |  |
| AC-5ba05969 | FindButton [try] | SCP0101_InventoryTrend.cs:522 | for (i < siMain.GetMaxRowIndex()) ▸ switch (cellQty) case "40": | GRID_SET | siMain.ActiveSheet.Cells[i, iColAvailable].ForeColor | Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-f4192452 | FindButton [try] | SCP0101_InventoryTrend.cs:523 | for (i < siMain.GetMaxRowIndex()) ▸ switch (cellQty) case "40": | GRID_SET | siMain.ActiveSheet.Cells[i, iColHolding].ForeColor | Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-71c3dbd0 | FindButton [try] | SCP0101_InventoryTrend.cs:524 | for (i < siMain.GetMaxRowIndex()) ▸ switch (cellQty) case "40": | GRID_SET | siMain.ActiveSheet.Cells[i, iColQT].ForeColor | Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-d319067b | FindButton [try] | SCP0101_InventoryTrend.cs:525 | for (i < siMain.GetMaxRowIndex()) ▸ switch (cellQty) case "40": | GRID_SET | siMain.ActiveSheet.Cells[i, iColBlocked].ForeColor | Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-107d9375 | FindButton [try] | SCP0101_InventoryTrend.cs:529 | for (i < siMain.GetMaxRowIndex()) ▸ switch (cellQty) case "30": | GRID_SET | siMain.ActiveSheet.Cells[i, iColAvailable].ForeColor | Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-1c91aa01 | FindButton [try] | SCP0101_InventoryTrend.cs:530 | for (i < siMain.GetMaxRowIndex()) ▸ switch (cellQty) case "30": | GRID_SET | siMain.ActiveSheet.Cells[i, iColHolding].ForeColor | Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-e28d22e6 | FindButton [try] | SCP0101_InventoryTrend.cs:531 | for (i < siMain.GetMaxRowIndex()) ▸ switch (cellQty) case "30": | GRID_SET | siMain.ActiveSheet.Cells[i, iColQT].ForeColor | Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-b8b5ee27 | FindButton [try] | SCP0101_InventoryTrend.cs:535 | for (i < siMain.GetMaxRowIndex()) ▸ switch (cellQty) case "20": | GRID_SET | siMain.ActiveSheet.Cells[i, iColAvailable].ForeColor | Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-633b8021 | FindButton [try] | SCP0101_InventoryTrend.cs:536 | for (i < siMain.GetMaxRowIndex()) ▸ switch (cellQty) case "20": | GRID_SET | siMain.ActiveSheet.Cells[i, iColHolding].ForeColor | Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-6ec01f8d | FindButton [try] | SCP0101_InventoryTrend.cs:537 | for (i < siMain.GetMaxRowIndex()) ▸ switch (cellQty) case "20": | GRID_SET | siMain.ActiveSheet.Cells[i, iColBlocked].ForeColor | Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-b6765117 | FindButton [try] | SCP0101_InventoryTrend.cs:541 | for (i < siMain.GetMaxRowIndex()) ▸ switch (cellQty) case "10": | GRID_SET | siMain.ActiveSheet.Cells[i, iColAvailable].ForeColor | Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-a42a0ab7 | FindButton [try] | SCP0101_InventoryTrend.cs:545 |  | UI_MISC | this.siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## SCP0101_InventoryTrend.SetCellColorOLD

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f002d55e | (진입점 미연결) | SCP0101_InventoryTrend.cs:550 |  | FLAG | iColQty | siMain.GetColumnIndex("QTY_MONTH_FOCUS") | 화면 필드/플래그 변경 |  |  |  |
| AC-de1a1c79 | (진입점 미연결) | SCP0101_InventoryTrend.cs:551 |  | FLAG | iColAvailable | siMain.GetColumnIndex("INV_STATUS_AVAILABLE") | 화면 필드/플래그 변경 |  |  |  |
| AC-45424c6e | (진입점 미연결) | SCP0101_InventoryTrend.cs:552 |  | FLAG | iColHolding | siMain.GetColumnIndex("INV_STATUS_QT") | 화면 필드/플래그 변경 |  |  |  |
| AC-715c6dc3 | (진입점 미연결) | SCP0101_InventoryTrend.cs:553 |  | FLAG | iColMax | siMain.ActiveSheet.ColumnCount - 1 | 화면 필드/플래그 변경 |  |  |  |
| AC-de73d55c | (진입점 미연결) | SCP0101_InventoryTrend.cs:555 |  | FLAG | cellQty | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-3cb9b951 | (진입점 미연결) | SCP0101_InventoryTrend.cs:556 |  | FLAG | cellAvailable | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-41a36515 | (진입점 미연결) | SCP0101_InventoryTrend.cs:557 |  | FLAG | cellHolding | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-2aeadeff | (진입점 미연결) | SCP0101_InventoryTrend.cs:558 |  | FLAG | cellValue | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-117d4aa4 | (진입점 미연결) | SCP0101_InventoryTrend.cs:559 |  | FLAG | colName | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-556312ca | (진입점 미연결) | SCP0101_InventoryTrend.cs:561 |  | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-fc0ba6c9 | (진입점 미연결) | SCP0101_InventoryTrend.cs:564 | for (i < siMain.GetMaxRowIndex()) | FLAG | chkQTY | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-16897dfb | (진입점 미연결) | SCP0101_InventoryTrend.cs:567 | for (i < siMain.GetMaxRowIndex()) ▸ for (iCol <= iColHolding) | FLAG | colName | siMain.GetColumnTag(iCol) | 화면 필드/플래그 변경 |  |  |  |
| AC-e4f5e852 | (진입점 미연결) | SCP0101_InventoryTrend.cs:571 | for (i < siMain.GetMaxRowIndex()) ▸ for (iCol <= iColHolding) ▸ switch (colName) case "INV_STATUS_AVAILABLE": | FLAG | cellQty | siMain.GetValue(i, iColQty).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-937d6c24 | (진입점 미연결) | SCP0101_InventoryTrend.cs:572 | for (i < siMain.GetMaxRowIndex()) ▸ for (iCol <= iColHolding) ▸ switch (colName) case "INV_STATUS_AVAILABLE": | FLAG | cellAvailable | siMain.GetValue(i, iCol).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-3ec5d0b0 | (진입점 미연결) | SCP0101_InventoryTrend.cs:575 | for (i < siMain.GetMaxRowIndex()) ▸ for (iCol <= iColHolding) ▸ switch (colName) case "INV_STATUS_AVAILABLE": ▸ if (cellQty.Equals(cellAvail… | GRID_SET | siMain.ActiveSheet.Cells[i, iCol].ForeColor | Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-bbaad254 | (진입점 미연결) | SCP0101_InventoryTrend.cs:576 | for (i < siMain.GetMaxRowIndex()) ▸ for (iCol <= iColHolding) ▸ switch (colName) case "INV_STATUS_AVAILABLE": ▸ if (cellQty.Equals(cellAvail… | FLAG | cellHolding | siMain.GetValue(i, iColHolding).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-61b39b14 | (진입점 미연결) | SCP0101_InventoryTrend.cs:578 | for (i < siMain.GetMaxRowIndex()) ▸ for (iCol <= iColHolding) ▸ switch (colName) case "INV_STATUS_AVAILABLE": ▸ if (cellQty.Equals(cellAvail… | FLAG | chkQTY | CommonUtils.GetValueDouble(cellQty) - CommonUtils.GetValueDouble(cellAvailable) + CommonUt… | 화면 필드/플래그 변경 |  |  |  |
| AC-89be87d6 | (진입점 미연결) | SCP0101_InventoryTrend.cs:578 | for (i < siMain.GetMaxRowIndex()) ▸ for (iCol <= iColHolding) ▸ switch (colName) case "INV_STATUS_AVAILABLE": ▸ if (cellQty.Equals(cellAvail… | CALL_EXT | CommonUtils.GetValueDouble | (cellQty) | ⚠ 의미 확인 필요 |  |  |  |
| AC-209773e5 | (진입점 미연결) | SCP0101_InventoryTrend.cs:578 | for (i < siMain.GetMaxRowIndex()) ▸ for (iCol <= iColHolding) ▸ switch (colName) case "INV_STATUS_AVAILABLE": ▸ if (cellQty.Equals(cellAvail… | CALL_EXT | CommonUtils.GetValueDouble | (cellAvailable) | ⚠ 의미 확인 필요 |  |  |  |
| AC-2f660a7e | (진입점 미연결) | SCP0101_InventoryTrend.cs:578 | for (i < siMain.GetMaxRowIndex()) ▸ for (iCol <= iColHolding) ▸ switch (colName) case "INV_STATUS_AVAILABLE": ▸ if (cellQty.Equals(cellAvail… | CALL_EXT | CommonUtils.GetValueDouble | (cellHolding) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9de48670 | (진입점 미연결) | SCP0101_InventoryTrend.cs:581 | for (i < siMain.GetMaxRowIndex()) ▸ for (iCol <= iColHolding) ▸ switch (colName) case "INV_STATUS_AVAILABLE": ▸ if (cellQty.Equals(cellAvail… | GRID_SET | siMain.ActiveSheet.Cells[i, iCol].BackColor | Color.LightGreen | 그리드 속성/값 설정 |  |  |  |
| AC-97318505 | (진입점 미연결) | SCP0101_InventoryTrend.cs:586 | for (i < siMain.GetMaxRowIndex()) ▸ for (iCol <= iColHolding) ▸ switch (colName) case "INV_STATUS_HOLDING": | FLAG | cellValue | siMain.GetValue(i, iCol).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-fa124dcb | (진입점 미연결) | SCP0101_InventoryTrend.cs:602 | for (i < siMain.GetMaxRowIndex()) ▸ for (iCol <= iColHolding) ▸ switch (colName) case "INV_STATUS_HOLDING": ▸ else of (CommonUtils.CheckData… | GRID_SET | siMain.ActiveSheet.Cells[i, iCol].ForeColor | Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-df00f948 | (진입점 미연결) | SCP0101_InventoryTrend.cs:606 | for (i < siMain.GetMaxRowIndex()) ▸ for (iCol <= iColHolding) ▸ switch (colName) case "INV_STATUS_QT": | FLAG | cellValue | siMain.GetValue(i, iCol).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-97759fb7 | (진입점 미연결) | SCP0101_InventoryTrend.cs:622 | for (i < siMain.GetMaxRowIndex()) ▸ for (iCol <= iColHolding) ▸ switch (colName) case "INV_STATUS_QT": ▸ else of (CommonUtils.CheckDataEmpty… | GRID_SET | siMain.ActiveSheet.Cells[i, iCol].ForeColor | Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-d3cefe7e | (진입점 미연결) | SCP0101_InventoryTrend.cs:628 |  | UI_MISC | this.siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## SCP0101_InventoryTrend.SetChangedControl

진입점: this.Load / cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8d9f0121 | this.Load 외 1 | SCP0101_InventoryTrend.cs:164 |  | FLAG | dtPlantByGroup | Data_SCP.Common(Data_SCP.Type.PlantByGroup, false, division) | 화면 필드/플래그 변경 |  |  |  |
| AC-c42b0b17 | this.Load 외 1 | SCP0101_InventoryTrend.cs:164 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.PlantByGroup, false, division) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-8e39d55f | this.Load 외 1 | SCP0101_InventoryTrend.cs:165 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlantByGroup, clbPlant, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0101_InventoryTrend.SetColumnFooterData

진입점: ExcelButton [try ▸ if (result == DialogResult.Yes) ▸ try ▸ if (this.DisplayFooter)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4fa719c3 | ExcelButton [try ▸ if (result == DialogResult.Yes) ▸ try ▸ i… | SCP0101_InventoryTrend.cs:937 |  | DATA_OP | sv.Rows.Add | (newIdx, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-f7c2f684 | ExcelButton [try ▸ if (result == DialogResult.Yes) ▸ try ▸ i… | SCP0101_InventoryTrend.cs:941 | for (col <= sv.ColumnFooter.Columns.Count - 1) | GRID_SET | sv.Cells[newIdx, col].Border | columnHeaerStyle.Border | 그리드 속성/값 설정 |  |  |  |
| AC-1330b270 | ExcelButton [try ▸ if (result == DialogResult.Yes) ▸ try ▸ i… | SCP0101_InventoryTrend.cs:942 | for (col <= sv.ColumnFooter.Columns.Count - 1) | GRID_SET | sv.Cells[newIdx, col].BackColor | columnHeaerStyle.BackColor | 그리드 속성/값 설정 |  |  |  |
| AC-6fa2e544 | ExcelButton [try ▸ if (result == DialogResult.Yes) ▸ try ▸ i… | SCP0101_InventoryTrend.cs:943 | for (col <= sv.ColumnFooter.Columns.Count - 1) | GRID_SET | sv.Cells[newIdx, col].HorizontalAlignment | columnHeaerStyle.HorizontalAlignment | 그리드 속성/값 설정 |  |  |  |
| AC-04228968 | ExcelButton [try ▸ if (result == DialogResult.Yes) ▸ try ▸ i… | SCP0101_InventoryTrend.cs:944 | for (col <= sv.ColumnFooter.Columns.Count - 1) | GRID_SET | sv.Cells[newIdx, col].VerticalAlignment | columnHeaerStyle.VerticalAlignment | 그리드 속성/값 설정 |  |  |  |
| AC-830b685a | ExcelButton [try ▸ if (result == DialogResult.Yes) ▸ try ▸ i… | SCP0101_InventoryTrend.cs:946 | for (col <= sv.ColumnFooter.Columns.Count - 1) | GRID_SET | sv.Cells[newIdx, col].Text | sv.ColumnFooter.Cells[0, col].Text | 그리드 속성/값 설정 |  |  |  |

## SCP0101_InventoryTrend.SetLayout

진입점: this.Load / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK)] / chkDetail.CheckedChanged / FindButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5a72cc08 | this.Load 외 3 | SCP0101_InventoryTrend.cs:425 | try | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex("ITEM_NAME"), isDetail) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-d4cb82c8 | this.Load 외 3 | SCP0101_InventoryTrend.cs:426 | try | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex("PROCESS_DETAIL"), isDetail) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-6b043b1a | this.Load 외 3 | SCP0101_InventoryTrend.cs:427 | try | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex("GPLM_CELL_MODEL"), isDetail) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-0b82e3da | this.Load 외 3 | SCP0101_InventoryTrend.cs:428 | try | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex("MDM_NICK_NAME"), isDetail) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-d455daed | this.Load 외 3 | SCP0101_InventoryTrend.cs:429 | try | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex("SCP_EXTRA_SPEC"), isDetail) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-563af2f4 | this.Load 외 3 | SCP0101_InventoryTrend.cs:430 | try | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex("GPLM_CELL_CONVERSION_FACTOR"), isDetail) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-5b1be33b | this.Load 외 3 | SCP0101_InventoryTrend.cs:431 | try | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex("LEVEL_1_NAME"), isDetail) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-07f50321 | this.Load 외 3 | SCP0101_InventoryTrend.cs:432 | try | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex("LEVEL_2_NAME"), isDetail) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-e42e9879 | this.Load 외 3 | SCP0101_InventoryTrend.cs:433 | try | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex("LEVEL_3_NAME"), isDetail) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-c556d4a6 | this.Load 외 3 | SCP0101_InventoryTrend.cs:434 | try | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex("LEVEL_4_NAME"), isDetail) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-91c3985f | this.Load 외 3 | SCP0101_InventoryTrend.cs:435 | try | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex("VALUATION_CLASS"), isDetail) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-43bdd9e8 | this.Load 외 3 | SCP0101_InventoryTrend.cs:436 | try | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex("UNIT_PRICE_KRW"), isDetail) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-9a63b439 | this.Load 외 3 | SCP0101_InventoryTrend.cs:438 | try | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex("INV_STATUS_QT"), isDetail) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-cdbe58ae | this.Load 외 3 | SCP0101_InventoryTrend.cs:439 | try | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex("INV_STATUS_HOLD"), isDetail) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-a7a1d51f | this.Load 외 3 | SCP0101_InventoryTrend.cs:440 | try | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex("INV_STATUS_BLOCKED"), isDetail) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-eac95381 | this.Load 외 3 | SCP0101_InventoryTrend.cs:442 | try | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex("CURRENCY"), isDetail) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-7f3ca96a | this.Load 외 3 | SCP0101_InventoryTrend.cs:443 | try | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex("AMOUNT"), isDetail) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-1c3632d2 | this.Load 외 3 | SCP0101_InventoryTrend.cs:444 | try | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex("UNIT_PRICE"), isDetail) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-3c1dd582 | this.Load 외 3 | SCP0101_InventoryTrend.cs:445 | try | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex("EX_TO_BAMT"), isDetail) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-1a617062 | this.Load 외 3 | SCP0101_InventoryTrend.cs:446 | try | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex("CELL_TYPE_GR"), isDetail) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-b98b25e9 | this.Load 외 3 | SCP0101_InventoryTrend.cs:447 | try | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex("CELL_GROUP"), isDetail) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-47658e60 | this.Load 외 3 | SCP0101_InventoryTrend.cs:448 | try | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex("PACK_GROUP"), isDetail) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCP0101_InventoryTrend.SetMonthRange

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7032c430 | this.Load | SCP0101_InventoryTrend.cs:645 | if (dtMonthRange != null \|\| dtMonthRange.Rows.Count > 0) | VALUE_SET | monthPicker.InitValue | dtMonthRange.Rows[0]["MAX_YYYYMM"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-0934f1f5 | this.Load | SCP0101_InventoryTrend.cs:646 | if (dtMonthRange != null \|\| dtMonthRange.Rows.Count > 0) | UI_PROP | monthPicker.MonthMin | dtMonthRange.Rows[0]["MIN_YYYYMM"].ToString() | 속성 MonthMin 설정 |  |  |  |
| AC-adf4f463 | this.Load | SCP0101_InventoryTrend.cs:647 | if (dtMonthRange != null \|\| dtMonthRange.Rows.Count > 0) | UI_PROP | monthPicker.MonthMax | dtMonthRange.Rows[0]["MAX_YYYYMM"].ToString() | 속성 MonthMax 설정 |  |  |  |

## SCP0101_InventoryTrend.SetSpreadHeader

진입점: this.Load / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK)] / monthPicker.ValueChanged / FindButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1ed48223 | this.Load 외 3 | SCP0101_InventoryTrend.cs:350 |  | FLAG | month1 | GetYYMM(today, -5) | 화면 필드/플래그 변경 |  |  |  |
| AC-f14897a6 | this.Load 외 3 | SCP0101_InventoryTrend.cs:351 |  | FLAG | month2 | GetYYMM(today, -4) | 화면 필드/플래그 변경 |  |  |  |
| AC-5910846d | this.Load 외 3 | SCP0101_InventoryTrend.cs:352 |  | FLAG | month3 | GetYYMM(today, -3) | 화면 필드/플래그 변경 |  |  |  |
| AC-1a2f1488 | this.Load 외 3 | SCP0101_InventoryTrend.cs:353 |  | FLAG | month4 | GetYYMM(today, -2) | 화면 필드/플래그 변경 |  |  |  |
| AC-b95f9a65 | this.Load 외 3 | SCP0101_InventoryTrend.cs:354 |  | FLAG | month5 | GetYYMM(today, -1) | 화면 필드/플래그 변경 |  |  |  |
| AC-e60393a9 | this.Load 외 3 | SCP0101_InventoryTrend.cs:355 |  | FLAG | monthFocus | GetYYMM(today, 0) | 화면 필드/플래그 변경 |  |  |  |
| AC-dcf25be4 | this.Load 외 3 | SCP0101_InventoryTrend.cs:360 | for (iCol <= siMain.GetMaxColumnIndex()) | FLAG | colName | siMain.GetColumnTag(iCol) | 화면 필드/플래그 변경 |  |  |  |
| AC-5866faa0 | this.Load 외 3 | SCP0101_InventoryTrend.cs:365 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ switch (colName) case "QTY_MONTH1": | GRID_SET | this.siMain.ActiveSheet.ColumnHeader.Cells[1, iCol].Text | month1 | 그리드 속성/값 설정 |  |  |  |
| AC-57c65151 | this.Load 외 3 | SCP0101_InventoryTrend.cs:368 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ switch (colName) case "QTY_MONTH2": | GRID_SET | this.siMain.ActiveSheet.ColumnHeader.Cells[1, iCol].Text | month2 | 그리드 속성/값 설정 |  |  |  |
| AC-f962eb86 | this.Load 외 3 | SCP0101_InventoryTrend.cs:371 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ switch (colName) case "QTY_MONTH3": | GRID_SET | this.siMain.ActiveSheet.ColumnHeader.Cells[1, iCol].Text | month3 | 그리드 속성/값 설정 |  |  |  |
| AC-ece4d04e | this.Load 외 3 | SCP0101_InventoryTrend.cs:374 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ switch (colName) case "QTY_MONTH4": | GRID_SET | this.siMain.ActiveSheet.ColumnHeader.Cells[1, iCol].Text | month4 | 그리드 속성/값 설정 |  |  |  |
| AC-62874273 | this.Load 외 3 | SCP0101_InventoryTrend.cs:377 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ switch (colName) case "QTY_MONTH5": | GRID_SET | this.siMain.ActiveSheet.ColumnHeader.Cells[1, iCol].Text | month5 | 그리드 속성/값 설정 |  |  |  |
| AC-ca4e7a2c | this.Load 외 3 | SCP0101_InventoryTrend.cs:380 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ switch (colName) case "QTY_MONTH_FOCUS": | GRID_SET | this.siMain.ActiveSheet.ColumnHeader.Cells[1, iCol].Text | monthFocus | 그리드 속성/값 설정 |  |  |  |
| AC-963b75b0 | this.Load 외 3 | SCP0101_InventoryTrend.cs:381 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ switch (colName) case "QTY_MONTH_FOCUS": | GRID_SET | this.siMain.ActiveSheet.ColumnHeader.Cells[1, iCol].ForeColor | colorFocus | 그리드 속성/값 설정 |  |  |  |
| AC-9b3adaf9 | this.Load 외 3 | SCP0101_InventoryTrend.cs:382 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ switch (colName) case "QTY_MONTH_FOCUS": | GRID_SET | this.siMain.ActiveSheet.ColumnHeader.Cells[1, iCol].Font | fontFocus | 그리드 속성/값 설정 |  |  |  |
| AC-e95c94b2 | this.Load 외 3 | SCP0101_InventoryTrend.cs:385 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ switch (colName) case "LONG_TERM_STOCK_AMOUNT": | GRID_SET | this.siMain.ActiveSheet.ColumnHeader.Cells[0, iCol].Text | "Amount KRW" | 그리드 속성/값 설정 |  |  |  |
| AC-0e581601 | this.Load 외 3 | SCP0101_InventoryTrend.cs:386 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ switch (colName) case "LONG_TERM_STOCK_AMOUNT": | GRID_SET | this.siMain.ActiveSheet.ColumnHeader.Cells[1, iCol].Text | monthFocus | 그리드 속성/값 설정 |  |  |  |
| AC-64323959 | this.Load 외 3 | SCP0101_InventoryTrend.cs:394 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ switch (colName) case "INV_STATUS_AVAILABLE": case "INV_STATUS_HOLDING": case "INV_STATUS_QT": ca… | GRID_SET | this.siMain.ActiveSheet.ColumnHeader.Cells[0, iCol].Text | string.Format("{0} {1}", monthFocus, "Inventory Status") | 그리드 속성/값 설정 |  |  |  |

## SCP0101_InventoryTrend.SetSpreadInit

진입점: this.Load / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK)] / FindButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-984c052a | this.Load 외 2 | SCP0101_InventoryTrend.cs:190 |  | GRID_INIT | spdInfo.SetSheetHeaderColumn | (spdInfo, 2) | 그리드 재구성/초기화 |  |  |  |
| AC-12f3c7c5 | this.Load 외 2 | SCP0101_InventoryTrend.cs:191 |  | GRID_INIT | spdInfo.ColumnHeaderHeight | (0, 35) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ae4704d6 | this.Load 외 2 | SCP0101_InventoryTrend.cs:192 |  | GRID_INIT | spdInfo.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

