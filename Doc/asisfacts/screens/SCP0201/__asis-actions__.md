# AS-IS 액션 대조표 — SCP0201

> 원천: `Doc/asisfacts/screens/SCP0201/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 604행 · 메서드 50 · 종류 DATA_OP 184 · UI_PROP 63 · GRID_SET 43 · FLAG 35 · MESSAGE 31 · RETURN 29 · CALL_EXT 28 · GRID_INIT 27 · UI_MISC 23 · POPUP 22 · COMBO_DATA 20 · GRID_STYLE 20 · LIST_REBIND 19 · ENDPOINT 18 · GRID_LOCK 12 · VALUE_SET 10 · VALUE_CLEAR 6 · VALIDATE 4 · STATE 2 · GRID_BIND 2 · GRID_CLEAR 1 · GRID_COMBO 1 · STATE_RESET 1 · LIST_CLEAR 1 · LIST_BIND 1 · THROW 1 · ⚠ 의미 확인 필요 28


## SCP0201_CAPA.BtnColumn_Click

진입점: this.btnColumn.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e2ecf5bd | this.btnColumn.Click | SCP0201_CAPA.cs:2550 |  | POPUP | new SCM0002_TitleSetForm_Popup | ("SCP0049", SpdSheet.shtMain, true) | 팝업/폼 생성 |  |  |  |
| AC-25057c3c | this.btnColumn.Click | SCP0201_CAPA.cs:2551 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-2d096d91 | this.btnColumn.Click | SCP0201_CAPA.cs:2552 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## SCP0201_CAPA.btnExcelFormDownload_Click

진입점: this.formDown.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f1da2814 | this.formDown.Click | SCP0201_CAPA.cs:2664 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-2d0fc8df | this.formDown.Click | SCP0201_CAPA.cs:2665 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0201_CAPA.btnExcelUpload_Click

진입점: this.btnExcelUpload.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-05392069 | this.btnExcelUpload.Click | SCP0201_CAPA.cs:2639 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-86e37078 | this.btnExcelUpload.Click | SCP0201_CAPA.cs:2640 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-544daed0 | this.btnExcelUpload.Click | SCP0201_CAPA.cs:2643 |  | POPUP | new ExcelUploadForm | ("SCP0049", this.spdMain.ActiveSheet.SheetName) | 팝업/폼 생성 |  |  |  |
| AC-23212c12 | this.btnExcelUpload.Click | SCP0201_CAPA.cs:2644 |  | UI_PROP | frm.SaveExceptError | true | 속성 SaveExceptError 설정 |  |  |  |
| AC-688c62d8 | this.btnExcelUpload.Click | SCP0201_CAPA.cs:2645 |  | UI_PROP | frm.Width | 850 | 속성 Width 설정 |  |  |  |
| AC-b42a64c7 | this.btnExcelUpload.Click | SCP0201_CAPA.cs:2646 |  | UI_PROP | frm.Height | 500 | 속성 Height 설정 |  |  |  |
| AC-f20f41ed | this.btnExcelUpload.Click | SCP0201_CAPA.cs:2647 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-c6511311 | this.btnExcelUpload.Click | SCP0201_CAPA.cs:2648 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-489d798a | this.btnExcelUpload.Click | SCP0201_CAPA.cs:2651 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00265") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SCP0201_CAPA.BtnNewModel_Click

진입점: this.buttonNewModel.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-567731d8 | this.buttonNewModel.Click | SCP0201_CAPA.cs:2485 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-af9de11f | this.buttonNewModel.Click | SCP0201_CAPA.cs:2486 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-cb93fa43 | this.buttonNewModel.Click | SCP0201_CAPA.cs:2500 |  | POPUP | new SCP0049_CAPANewModelPopup | () | 팝업/폼 생성 |  |  |  |
| AC-9310f1f0 | this.buttonNewModel.Click | SCP0201_CAPA.cs:2502 |  | CALL_EXT | popup.LoadData | (UserInfo.UserId,sDivisionId,sPlantId,sGroup,sFactoryId, sLineId, sOperationId,sModelId,sI… | ⚠ 의미 확인 필요 |  |  |  |
| AC-138eb219 | this.buttonNewModel.Click | SCP0201_CAPA.cs:2504 |  | UI_PROP | popup.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-e4e03f39 | this.buttonNewModel.Click | SCP0201_CAPA.cs:2505 |  | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## SCP0201_CAPA.BtnNewVersion_Click

진입점: this.buttonNewVersion.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-29a78e5c | this.buttonNewVersion.Click | SCP0201_CAPA.cs:2515 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-7f000554 | this.buttonNewVersion.Click | SCP0201_CAPA.cs:2516 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1712905c | this.buttonNewVersion.Click | SCP0201_CAPA.cs:2520 |  | POPUP | new SCP0049_CAPANewVersionConfirmPopup | () | 팝업/폼 생성 |  |  |  |
| AC-a0803d36 | this.buttonNewVersion.Click | SCP0201_CAPA.cs:2521 |  | CALL_EXT | popup.LoadData | (UserInfo.UserId, sToday) | ⚠ 의미 확인 필요 |  |  |  |
| AC-19d726e6 | this.buttonNewVersion.Click | SCP0201_CAPA.cs:2522 |  | UI_PROP | popup.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-d35286de | this.buttonNewVersion.Click | SCP0201_CAPA.cs:2523 |  | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## SCP0201_CAPA.BtnVersionInfo_Click

진입점: this.buttonVersionInfo.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4ac4e909 | this.buttonVersionInfo.Click | SCP0201_CAPA.cs:2533 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a30191d4 | this.buttonVersionInfo.Click | SCP0201_CAPA.cs:2534 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2d1719f2 | this.buttonVersionInfo.Click | SCP0201_CAPA.cs:2538 |  | POPUP | new SCP0049_CAPANewVersionInfoPopup | () | 팝업/폼 생성 |  |  |  |
| AC-10583b79 | this.buttonVersionInfo.Click | SCP0201_CAPA.cs:2539 |  | CALL_EXT | popup.LoadData | (UserInfo.UserId) | ⚠ 의미 확인 필요 |  |  |  |
| AC-db741bce | this.buttonVersionInfo.Click | SCP0201_CAPA.cs:2540 |  | UI_PROP | popup.Width | 930 | 속성 Width 설정 |  |  |  |
| AC-1c86149a | this.buttonVersionInfo.Click | SCP0201_CAPA.cs:2541 |  | UI_PROP | popup.Height | 500 | 속성 Height 설정 |  |  |  |
| AC-cbd278a8 | this.buttonVersionInfo.Click | SCP0201_CAPA.cs:2542 |  | UI_PROP | popup.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-c4afcd88 | this.buttonVersionInfo.Click | SCP0201_CAPA.cs:2544 |  | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## SCP0201_CAPA.CAPA_Export_Excel

진입점: this.formDown.Click [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a890c63b | this.formDown.Click [try] | SCP0201_CAPA.cs:2025 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-73f9f0f1 | this.formDown.Click [try] | SCP0201_CAPA.cs:2032 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-3d96f51f | this.formDown.Click [try] | SCP0201_CAPA.cs:2039 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-7edf1c0a | this.formDown.Click [try] | SCP0201_CAPA.cs:2046 | try | CALL_EXT | spSpread.Sheets.CopyTo | (myarray, 0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-40f454e2 | this.formDown.Click [try] | SCP0201_CAPA.cs:2048 | try ▸ if (myarray.Length == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8320fd31 | this.formDown.Click [try] | SCP0201_CAPA.cs:2051 | try | CALL_EXT | sp.Sheets.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-1b865fb9 | this.formDown.Click [try] | SCP0201_CAPA.cs:2086 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) | DATA_OP | sv.Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-6b81ba2a | this.formDown.Click [try] | SCP0201_CAPA.cs:2091 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) | UI_PROP | newSheet.ReferenceStyle | FarPoint.Win.Spread.Model.ReferenceStyle.A1 | 속성 ReferenceStyle 설정 |  |  |  |
| AC-042cd321 | this.formDown.Click [try] | SCP0201_CAPA.cs:2096 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) | CALL_EXT | f.IsRowFilteredOut | (i) | ⚠ 의미 확인 필요 |  |  |  |
| AC-6d3e8c15 | this.formDown.Click [try] | SCP0201_CAPA.cs:2098 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ if (newSheet.Rows[i].Visible == false \|\| (f != null && f.IsRowFilteredOut… | DATA_OP | newSheet.Rows.Remove | (i, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-74296106 | this.formDown.Click [try] | SCP0201_CAPA.cs:2107 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ if (newSheet.Columns[i].Visible == false) | DATA_OP | newSheet.Columns.Remove | (i, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-a3d368da | this.formDown.Click [try] | SCP0201_CAPA.cs:2119 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ if (newSheet.Columns[i].Ce… | GRID_SET | newSheet.Cells[idx.Index, i].CellType | new FarPoint.Win.Spread.CellType.TextCellType() | 그리드 속성/값 설정 |  |  |  |
| AC-4708e73c | this.formDown.Click [try] | SCP0201_CAPA.cs:2120 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ if (newSheet.Columns[i].Ce… | GRID_SET | newSheet.Cells[idx.Index, i].Text | sText | 그리드 속성/값 설정 |  |  |  |
| AC-ca5d1db4 | this.formDown.Click [try] | SCP0201_CAPA.cs:2129 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ if (newSheet.Columns[i].Ce… | GRID_SET | newSheet.Cells[idx.Index, i].CellType | new FarPoint.Win.Spread.CellType.TextCellType() | 그리드 속성/값 설정 |  |  |  |
| AC-f6c8ee24 | this.formDown.Click [try] | SCP0201_CAPA.cs:2130 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ if (newSheet.Columns[i].Ce… | GRID_SET | newSheet.Cells[idx.Index, i].Text | sText | 그리드 속성/값 설정 |  |  |  |
| AC-3e7f8a1f | this.formDown.Click [try] | SCP0201_CAPA.cs:2136 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ if (newSheet.Columns[i].Ce… | GRID_SET | newSheet.Columns[i].Formula | "" | 그리드 속성/값 설정 |  |  |  |
| AC-d567e9c3 | this.formDown.Click [try] | SCP0201_CAPA.cs:2150 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ if (newSheet.Columns[i].Ta… | UI_PROP | cb.ItemData | arrCode | 속성 ItemData 설정 |  |  |  |
| AC-1f37aafc | this.formDown.Click [try] | SCP0201_CAPA.cs:2151 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ if (newSheet.Columns[i].Ta… | UI_PROP | cb.Items | arrCode | 속성 Items 설정 |  |  |  |
| AC-f861ffab | this.formDown.Click [try] | SCP0201_CAPA.cs:2153 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ if (newSheet.Columns[i].Ta… | UI_PROP | cb.EditorValue | FarPoint.Win.Spread.CellType.EditorValue.ItemData | 속성 EditorValue 설정 |  |  |  |
| AC-46e66611 | this.formDown.Click [try] | SCP0201_CAPA.cs:2155 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ if (newSheet.Columns[i].Ta… | STATE | cb.Editable | true | 컨트롤 상태 Editable |  |  |  |
| AC-4b5cb6e1 | this.formDown.Click [try] | SCP0201_CAPA.cs:2156 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ if (newSheet.Columns[i].Ta… | GRID_SET | newSheet.Cells[idx.Index, i].CellType | cb | 그리드 속성/값 설정 |  |  |  |
| AC-750742cd | this.formDown.Click [try] | SCP0201_CAPA.cs:2157 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ if (newSheet.Columns[i].Ta… | GRID_SET | newSheet.Cells[idx.Index, i].Value | (sText == "True" ? "Y" : "N") | 그리드 속성/값 설정 |  |  |  |
| AC-b80ad53c | this.formDown.Click [try] | SCP0201_CAPA.cs:2177 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ else of (newSheet.Columns[… | FLAG | dtLaneQtyOfLineAssign | Data_SCP.Common(Data_SCP.Type.LaneQtyOfLineAssign, false) | 화면 필드/플래그 변경 |  |  |  |
| AC-2fea5c1f | this.formDown.Click [try] | SCP0201_CAPA.cs:2177 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ else of (newSheet.Columns[… | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.LaneQtyOfLineAssign, false) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-882c8f0a | this.formDown.Click [try] | SCP0201_CAPA.cs:2179 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ else of (newSheet.Columns[… | DATA_OP | dtLaneQtyOfLineAssign.Select | ("DIVISION_ID = '" + sDivisionId + "' AND COMPANY_ID = '" + sCompanyId + "' AND SITE_ID = … | 데이터 객체 조작/조회 |  |  |  |
| AC-a8c2b7e8 | this.formDown.Click [try] | SCP0201_CAPA.cs:2194 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ else of (newSheet.Columns[… | DATA_OP | dtLanQty.CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-268ea63f | this.formDown.Click [try] | SCP0201_CAPA.cs:2199 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ else of (newSheet.Columns[… | DATA_OP | arrCode.Add | (dr["CODE"].ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-4ef2c06e | this.formDown.Click [try] | SCP0201_CAPA.cs:2200 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ else of (newSheet.Columns[… | DATA_OP | arrName.Add | (dr["NAME"].ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-4a10986c | this.formDown.Click [try] | SCP0201_CAPA.cs:2203 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ else of (newSheet.Columns[… | UI_PROP | cb.ItemData | (String[])arrCode.ToArray(typeof(string)) | 속성 ItemData 설정 |  |  |  |
| AC-fe022542 | this.formDown.Click [try] | SCP0201_CAPA.cs:2204 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ else of (newSheet.Columns[… | UI_PROP | cb.Items | (String[])arrName.ToArray(typeof(string)) | 속성 Items 설정 |  |  |  |
| AC-c91e1faf | this.formDown.Click [try] | SCP0201_CAPA.cs:2206 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ else of (newSheet.Columns[… | UI_PROP | cb.EditorValue | FarPoint.Win.Spread.CellType.EditorValue.ItemData | 속성 EditorValue 설정 |  |  |  |
| AC-25d61aa4 | this.formDown.Click [try] | SCP0201_CAPA.cs:2208 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ else of (newSheet.Columns[… | STATE | cb.Editable | true | 컨트롤 상태 Editable |  |  |  |
| AC-0ba02fa2 | this.formDown.Click [try] | SCP0201_CAPA.cs:2209 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ else of (newSheet.Columns[… | GRID_SET | newSheet.Cells[idx.Index, i].CellType | cb | 그리드 속성/값 설정 |  |  |  |
| AC-a2cb943a | this.formDown.Click [try] | SCP0201_CAPA.cs:2210 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ else of (newSheet.Columns[… | GRID_SET | newSheet.Cells[idx.Index, i].Value | sText | 그리드 속성/값 설정 |  |  |  |
| AC-73aab266 | this.formDown.Click [try] | SCP0201_CAPA.cs:2224 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (iCol >= 0) ▸ if (newSheet.Columns[iCol].Tag == null) ▸ if (newSheet.Columns[iCol].Dat… | UI_PROP | newSheet.FrozenColumnCount | iCol | 속성 FrozenColumnCount 설정 |  |  |  |
| AC-2553b1c2 | this.formDown.Click [try] | SCP0201_CAPA.cs:2233 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (iCol >= 0) ▸ else of (newSheet.Columns[iCol].Tag == null) ▸ if (newSheet.Columns[iCol… | UI_PROP | newSheet.FrozenColumnCount | iCol + 1 | 속성 FrozenColumnCount 설정 |  |  |  |
| AC-e84665d0 | this.formDown.Click [try] | SCP0201_CAPA.cs:2240 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) | DATA_OP | sp.Sheets.Add | (newSheet) | 데이터 객체 조작/조회 |  |  |  |
| AC-2d2f1a20 | this.formDown.Click [try] | SCP0201_CAPA.cs:2245 | try | UI_PROP | siNew.Border | new FarPoint.Win.LineBorder(Color.Black, 1, true, true, true, true) | 속성 Border 설정 |  |  |  |
| AC-ee29ae25 | this.formDown.Click [try] | SCP0201_CAPA.cs:2247 | try | UI_PROP | newSheet.DefaultStyle | siNew | 속성 DefaultStyle 설정 |  |  |  |
| AC-09edeaa1 | this.formDown.Click [try] | SCP0201_CAPA.cs:2251 | try | UI_PROP | siNewColHeader.Border | new FarPoint.Win.LineBorder(Color.Black, 1, true, true, true, true) | 속성 Border 설정 |  |  |  |
| AC-18046a23 | this.formDown.Click [try] | SCP0201_CAPA.cs:2253 | try | GRID_SET | newSheet.ColumnHeader.DefaultStyle | siNewColHeader | 그리드 속성/값 설정 |  |  |  |
| AC-ed2cb12e | this.formDown.Click [try] | SCP0201_CAPA.cs:2256 | try ▸ if (!bFrozenCheck) | UI_PROP | newSheet.FrozenColumnCount | 0 | 속성 FrozenColumnCount 설정 |  |  |  |
| AC-a90f1212 | this.formDown.Click [try] | SCP0201_CAPA.cs:2258 | try | UI_PROP | sp.TabStripPolicy | TabStripPolicy.Always | 속성 TabStripPolicy 설정 |  |  |  |
| AC-0f0ec27c | this.formDown.Click [try] | SCP0201_CAPA.cs:2263 | try ▸ for (iSheetIndex < sp.Sheets.Count) | GRID_SET | sp.Sheets[iSheetIndex].Protect | false | 그리드 속성/값 설정 |  |  |  |
| AC-598e7ca0 | this.formDown.Click [try] | SCP0201_CAPA.cs:2274 | try ▸ if (isOpen) | CALL_EXT | sp.SaveExcel | (sFileName, FarPoint.Excel.ExcelSaveFlags.NoFormulas \| FarPoint.Excel.ExcelSaveFlags.Save… | ⚠ 의미 확인 필요 |  |  |  |
| AC-af9299f4 | this.formDown.Click [try] | SCP0201_CAPA.cs:2276 | try ▸ if (isOpen) | CALL_EXT | System.Diagnostics.Process.Start | (sFileName) | ⚠ 의미 확인 필요 |  |  |  |
| AC-cf974e11 | this.formDown.Click [try] | SCP0201_CAPA.cs:2280 | try ▸ else of (isOpen) | POPUP | new SaveFileDialog | () | 팝업/폼 생성 |  |  |  |
| AC-3a970c44 | this.formDown.Click [try] | SCP0201_CAPA.cs:2281 | try ▸ else of (isOpen) | UI_PROP | saveFileDialog.Filter | "Excel files (*.xls or .xlsx)\|*.xls;*.xlsx" | 속성 Filter 설정 |  |  |  |
| AC-d1a983d3 | this.formDown.Click [try] | SCP0201_CAPA.cs:2282 | try ▸ else of (isOpen) | UI_PROP | saveFileDialog.Title | "Save an Excel File" | 속성 Title 설정 |  |  |  |
| AC-e4424d96 | this.formDown.Click [try] | SCP0201_CAPA.cs:2283 | try ▸ else of (isOpen) | UI_PROP | saveFileDialog.FileName | sExcelFileName | 속성 FileName 설정 |  |  |  |
| AC-a0055195 | this.formDown.Click [try] | SCP0201_CAPA.cs:2284 | try ▸ else of (isOpen) | POPUP | saveFileDialog.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-74a9bc26 | this.formDown.Click [try] | SCP0201_CAPA.cs:2291 | try ▸ else of (isOpen) ▸ if (saveFileDialog.FileName != "") | CALL_EXT | sFileName.LastIndexOf | (".") | ⚠ 의미 확인 필요 |  |  |  |
| AC-a84469a5 | this.formDown.Click [try] | SCP0201_CAPA.cs:2292 | try ▸ else of (isOpen) ▸ if (saveFileDialog.FileName != "") ▸ if (sFileName.Substring(sFileName.LastIndexOf(".") + 1).ToString().ToUpper() =… | CALL_EXT | sp.SaveExcel | (sFileName, FarPoint.Excel.ExcelSaveFlags.NoFormulas \| FarPoint.Excel.ExcelSaveFlags.Save… | ⚠ 의미 확인 필요 |  |  |  |
| AC-45447614 | this.formDown.Click [try] | SCP0201_CAPA.cs:2294 | try ▸ else of (isOpen) ▸ if (saveFileDialog.FileName != "") ▸ else of (sFileName.Substring(sFileName.LastIndexOf(".") + 1).ToString().ToUppe… | CALL_EXT | sp.SaveExcel | (sFileName, FarPoint.Excel.ExcelSaveFlags.NoFormulas \| FarPoint.Excel.ExcelSaveFlags.Save… | ⚠ 의미 확인 필요 |  |  |  |
| AC-38cd64bf | this.formDown.Click [try] | SCP0201_CAPA.cs:2298 | try | CALL_EXT | GC.GetGeneration | ((object)sp) | ⚠ 의미 확인 필요 |  |  |  |
| AC-66d36756 | this.formDown.Click [try] | SCP0201_CAPA.cs:2304 | catch ((Exception e)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00003", new object[] { e.Message }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b4299383 | this.formDown.Click [try] | SCP0201_CAPA.cs:2308 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-75f947dc | this.formDown.Click [try] | SCP0201_CAPA.cs:2311 | finally ▸ if (ver >= 0) | CALL_EXT | GC.Collect | (ver) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0201_CAPA.CboGroup_SelectedIndexChanged

진입점: cboGroup.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e46989f9 | cboGroup.SelectedIndexChanged | SCP0201_CAPA.cs:2333 |  | FLAG | dtPlantByGroup | Data_SCP.Common(Data_SCP.Type.PlantByGroup, false, pDivisionID, pGroupID) | 화면 필드/플래그 변경 |  |  |  |
| AC-19de125d | cboGroup.SelectedIndexChanged | SCP0201_CAPA.cs:2333 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.PlantByGroup, false, pDivisionID, pGroupID) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-a3321c6d | cboGroup.SelectedIndexChanged | SCP0201_CAPA.cs:2334 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlantByGroup, clbPlant, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-71e58b35 | cboGroup.SelectedIndexChanged | SCP0201_CAPA.cs:2337 |  | FLAG | dtBuildingByShopGroupId | Data_SCP.Common(Data_SCP.Type.BuildingByShopGroupId, false, pDivisionID, pPlantID, pGroupI… | 화면 필드/플래그 변경 |  |  |  |
| AC-b73abc01 | cboGroup.SelectedIndexChanged | SCP0201_CAPA.cs:2337 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.BuildingByShopGroupId, false, pDivisionID, pPlantID, pGroupID) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-1a0cfed9 | cboGroup.SelectedIndexChanged | SCP0201_CAPA.cs:2338 |  | LIST_REBIND | clsCtrl.setListBox | (dtBuildingByShopGroupId, clbBuilding, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-493d3fbf | cboGroup.SelectedIndexChanged | SCP0201_CAPA.cs:2341 |  | FLAG | dtLineByOperationPlantId | Data_SCP.Common(Data_SCP.Type.LineByOperationPlantId, false, pDivisionID, pPlantID, pFacto… | 화면 필드/플래그 변경 |  |  |  |
| AC-a3095b76 | cboGroup.SelectedIndexChanged | SCP0201_CAPA.cs:2341 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.LineByOperationPlantId, false, pDivisionID, pPlantID, pFactoryID,pGroupID) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-bf7155d1 | cboGroup.SelectedIndexChanged | SCP0201_CAPA.cs:2342 |  | LIST_REBIND | clsCtrl.setListBox | (dtLineByOperationPlantId, clbLine, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-68b93dd6 | cboGroup.SelectedIndexChanged | SCP0201_CAPA.cs:2345 |  | FLAG | dtOperationByLine | Data.Common(Data.Type.OperationByLine, false, pDivisionID, pPlantID, pFactoryID, pLineId,p… ⇒ biz:CommonData.CommonDataList [code=OperationByLine] | 화면 필드/플래그 변경 |  |  |  |
| AC-07c8d98a | cboGroup.SelectedIndexChanged | SCP0201_CAPA.cs:2345 |  | COMBO_DATA | Data.Common | (Data.Type.OperationByLine, false, pDivisionID, pPlantID, pFactoryID, pLineId,pGroupID) ⇒ biz:CommonData.CommonDataList [code=OperationByLine] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-fe9c0697 | cboGroup.SelectedIndexChanged | SCP0201_CAPA.cs:2346 |  | LIST_REBIND | clsCtrl.setListBox | (dtOperationByLine, clbOperation, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0201_CAPA.CboVersionId_Click

진입점: cboVersionId.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d4cfb583 | cboVersionId.Click | SCP0201_CAPA.cs:2407 |  | FLAG | dtVersionId | Data_SCP.Common(Data_SCP.Type.MDMVersionId, false, pDivisionId, pGroupId) | 화면 필드/플래그 변경 |  |  |  |
| AC-94798aea | cboVersionId.Click | SCP0201_CAPA.cs:2407 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.MDMVersionId, false, pDivisionId, pGroupId) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-3448a7a7 | cboVersionId.Click | SCP0201_CAPA.cs:2409 |  | DATA_OP | dtVersionId.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-1c39f1c5 | cboVersionId.Click | SCP0201_CAPA.cs:2410 |  | DATA_OP | drCurrentRow["CODE"] | "Current" | 행/컬럼 값 대입 |  |  |  |
| AC-7b2f49c5 | cboVersionId.Click | SCP0201_CAPA.cs:2411 |  | DATA_OP | drCurrentRow["NAME"] | "Current" | 행/컬럼 값 대입 |  |  |  |
| AC-66999136 | cboVersionId.Click | SCP0201_CAPA.cs:2412 |  | CALL_EXT | dtVersionId.Rows.InsertAt | (drCurrentRow, 0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f1b754ee | cboVersionId.Click | SCP0201_CAPA.cs:2413 |  | DATA_OP | dtVersionId.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-ddfa66a8 | cboVersionId.Click | SCP0201_CAPA.cs:2414 |  | LIST_REBIND | clsCtrl.setListBox | (dtVersionId, cboVersionId, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0201_CAPA.CboVersionId_SelectedIndexChanged

진입점: cboVersionId.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d08f56a0 | cboVersionId.SelectedIndexChanged | SCP0201_CAPA.cs:2386 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |
| AC-d56dedf4 | cboVersionId.SelectedIndexChanged | SCP0201_CAPA.cs:2387 |  | VALUE_CLEAR | this.txtTotal.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-d5591f39 | cboVersionId.SelectedIndexChanged | SCP0201_CAPA.cs:2388 |  | VALUE_CLEAR | this.txtAuto.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-d1f1b92e | cboVersionId.SelectedIndexChanged | SCP0201_CAPA.cs:2389 |  | VALUE_CLEAR | this.txtSmall.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-3ee801b9 | cboVersionId.SelectedIndexChanged | SCP0201_CAPA.cs:2390 |  | VALUE_CLEAR | this.txtElec.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-2e760eb2 | cboVersionId.SelectedIndexChanged | SCP0201_CAPA.cs:2391 |  | VALUE_CLEAR | this.txtPIC.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-82542026 | cboVersionId.SelectedIndexChanged | SCP0201_CAPA.cs:2394 | if (cboVersionId.SelectedIndex == 0) | FLAG | bRealFlag | true | 화면 필드/플래그 변경 |  |  |  |
| AC-efd5151d | cboVersionId.SelectedIndexChanged | SCP0201_CAPA.cs:2398 | else of (cboVersionId.SelectedIndex == 0) | FLAG | bRealFlag | false | 화면 필드/플래그 변경 |  |  |  |

## SCP0201_CAPA.ClbBucket_SelectedIndexChanged

진입점: clbBucket.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-669912cb | clbBucket.SelectedIndexChanged | SCP0201_CAPA.cs:2431 |  | CALL_EXT | clbBucket.SetValues | ("Month") | ⚠ 의미 확인 필요 |  |  |  |

## SCP0201_CAPA.ClbBuilding_SelectedIndexChanged

진입점: clbBuilding.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-65c790f2 | clbBuilding.SelectedIndexChanged | SCP0201_CAPA.cs:2375 |  | FLAG | dtLineByOperationPlantId | Data_SCP.Common(Data_SCP.Type.LineByOperationPlantId, false, pDivisionID, pPlantID, pFacto… | 화면 필드/플래그 변경 |  |  |  |
| AC-13489702 | clbBuilding.SelectedIndexChanged | SCP0201_CAPA.cs:2375 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.LineByOperationPlantId, false, pDivisionID, pPlantID, pFactoryID, pGroupID) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-6ac5dac6 | clbBuilding.SelectedIndexChanged | SCP0201_CAPA.cs:2376 |  | LIST_REBIND | clsCtrl.setListBox | (dtLineByOperationPlantId, clbLine, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-97717a37 | clbBuilding.SelectedIndexChanged | SCP0201_CAPA.cs:2380 |  | FLAG | dtOperationByLine | Data.Common(Data.Type.OperationByLine, false,pDivisionID,pPlantID,pFactoryID, pLineId, pGr… ⇒ biz:CommonData.CommonDataList [code=OperationByLine] | 화면 필드/플래그 변경 |  |  |  |
| AC-ef46e569 | clbBuilding.SelectedIndexChanged | SCP0201_CAPA.cs:2380 |  | COMBO_DATA | Data.Common | (Data.Type.OperationByLine, false,pDivisionID,pPlantID,pFactoryID, pLineId, pGroupID) ⇒ biz:CommonData.CommonDataList [code=OperationByLine] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-92e058c8 | clbBuilding.SelectedIndexChanged | SCP0201_CAPA.cs:2381 |  | LIST_REBIND | clsCtrl.setListBox | (dtOperationByLine, clbOperation, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0201_CAPA.ClbLine_SelectedIndexChanged

진입점: clbLine.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f5cce005 | clbLine.SelectedIndexChanged | SCP0201_CAPA.cs:2425 |  | FLAG | dtOperationByLine | Data.Common(Data.Type.OperationByLine, false, pDivisionID, pPlantID, pFactoryID, pLineID, … ⇒ biz:CommonData.CommonDataList [code=OperationByLine] | 화면 필드/플래그 변경 |  |  |  |
| AC-794ed1d1 | clbLine.SelectedIndexChanged | SCP0201_CAPA.cs:2425 |  | COMBO_DATA | Data.Common | (Data.Type.OperationByLine, false, pDivisionID, pPlantID, pFactoryID, pLineID, pGroupID) ⇒ biz:CommonData.CommonDataList [code=OperationByLine] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-bdc65b4b | clbLine.SelectedIndexChanged | SCP0201_CAPA.cs:2426 |  | LIST_REBIND | clsCtrl.setListBox | (dtOperationByLine, clbOperation, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0201_CAPA.ClbPlant_SelectedIndexChanged

진입점: clbPlant.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5f27b221 | clbPlant.SelectedIndexChanged | SCP0201_CAPA.cs:2355 |  | FLAG | dtBuildingByShopGroupId | Data_SCP.Common(Data_SCP.Type.BuildingByShopGroupId, false, pDivisionID, pPlantID, pGroupI… | 화면 필드/플래그 변경 |  |  |  |
| AC-2eef2191 | clbPlant.SelectedIndexChanged | SCP0201_CAPA.cs:2355 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.BuildingByShopGroupId, false, pDivisionID, pPlantID, pGroupID) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-0986a38f | clbPlant.SelectedIndexChanged | SCP0201_CAPA.cs:2356 |  | LIST_REBIND | clsCtrl.setListBox | (dtBuildingByShopGroupId, clbBuilding, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-f57dda62 | clbPlant.SelectedIndexChanged | SCP0201_CAPA.cs:2359 |  | FLAG | dtLineByOperationPlantId | Data_SCP.Common(Data_SCP.Type.LineByOperationPlantId, false, pDivisionID, pPlantID, pFacto… | 화면 필드/플래그 변경 |  |  |  |
| AC-ca438260 | clbPlant.SelectedIndexChanged | SCP0201_CAPA.cs:2359 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.LineByOperationPlantId, false, pDivisionID, pPlantID, pFactoryID, pGroupID) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-691a5540 | clbPlant.SelectedIndexChanged | SCP0201_CAPA.cs:2360 |  | LIST_REBIND | clsCtrl.setListBox | (dtLineByOperationPlantId, clbLine, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-67610f61 | clbPlant.SelectedIndexChanged | SCP0201_CAPA.cs:2364 |  | FLAG | dtOperationByLine | Data.Common(Data.Type.OperationByLine, false, pDivisionID, pPlantID, pFactoryID, pLineId, … ⇒ biz:CommonData.CommonDataList [code=OperationByLine] | 화면 필드/플래그 변경 |  |  |  |
| AC-87b41c0b | clbPlant.SelectedIndexChanged | SCP0201_CAPA.cs:2364 |  | COMBO_DATA | Data.Common | (Data.Type.OperationByLine, false, pDivisionID, pPlantID, pFactoryID, pLineId, pGroupID) ⇒ biz:CommonData.CommonDataList [code=OperationByLine] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c00bc135 | clbPlant.SelectedIndexChanged | SCP0201_CAPA.cs:2365 |  | LIST_REBIND | clsCtrl.setListBox | (dtOperationByLine, clbOperation, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0201_CAPA.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-03623096 | this.Load | SCP0201_CAPA.cs:429 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 2, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-32909bb7 | this.Load | SCP0201_CAPA.cs:430 |  | GRID_INIT | this.AddSheet | (spdExcel, SpdSheet.shtCAPAExcel, SpdSheet.shtCAPAExcel, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-68d0be00 | this.Load | SCP0201_CAPA.cs:432 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-30939902 | this.Load | SCP0201_CAPA.cs:433 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-bad1d46f | this.Load | SCP0201_CAPA.cs:436 |  | FLAG | siExcelTemp | GetSheetInfo(spdExcel.Name, SpdSheet.shtCAPAExcel) | 화면 필드/플래그 변경 |  |  |  |
| AC-f9512432 | this.Load | SCP0201_CAPA.cs:437 |  | GRID_INIT | siExcelTemp.ChangeSheet | (SpdSheet.shtCAPAExcel) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-77170b51 | this.Load | SCP0201_CAPA.cs:441 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0201_CAPA.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a10c47bc | this.Load | SCP0201_CAPA.cs:265 |  | FLAG | dtLaneQtyOfLineAssign | Data_SCP.Common(Data_SCP.Type.LaneQtyOfLineAssign, false) | 화면 필드/플래그 변경 |  |  |  |
| AC-9d9da2c5 | this.Load | SCP0201_CAPA.cs:265 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.LaneQtyOfLineAssign, false) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |

## SCP0201_CAPA.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-20a83c2c | Dispose | SCP0201_CAPA.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0201_CAPA.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8613d37f | EditButton | SCP0201_CAPA.cs:541 | if (spdMain != null && spdMain.ActiveSheet.RowCount > 0) ▸ if (fps.Name == "spdMain") ▸ if (bRealFlag == false) | MESSAGE | MessageHelper.GMessageBox | ("MSG00312", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-dea60ca2 | EditButton | SCP0201_CAPA.cs:542 | if (spdMain != null && spdMain.ActiveSheet.RowCount > 0) ▸ if (fps.Name == "spdMain") ▸ if (bRealFlag == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-81aa1b4a | EditButton | SCP0201_CAPA.cs:545 | if (spdMain != null && spdMain.ActiveSheet.RowCount > 0) ▸ if (fps.Name == "spdMain") | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-5d7584c6 | EditButton | SCP0201_CAPA.cs:546 | if (spdMain != null && spdMain.ActiveSheet.RowCount > 0) ▸ if (fps.Name == "spdMain") | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-972a8f67 | EditButton | SCP0201_CAPA.cs:557 | if (spdMain != null && spdMain.ActiveSheet.RowCount > 0) ▸ if (fps.Name == "spdMain") ▸ if (bEdit_Mode == false) | FLAG | bEdit_Mode | true | 화면 필드/플래그 변경 |  |  |  |
| AC-c107650f | EditButton | SCP0201_CAPA.cs:585 | if (spdMain != null && spdMain.ActiveSheet.RowCount > 0) ▸ if (fps.Name == "spdMain") ▸ if (bEdit_Mode == false) ▸ for (row < siMain.Sheet(0… | GRID_LOCK | siMain.LockRange | (row, siMain.GetColumnIndex(DefColumns.SITE_NAME), row, siMain.ActiveSheet.ColumnCount - 1… | 그리드 편집 잠금/해제 |  |  |  |
| AC-c7a3e089 | EditButton | SCP0201_CAPA.cs:593 | if (spdMain != null && spdMain.ActiveSheet.RowCount > 0) ▸ if (fps.Name == "spdMain") ▸ if (bEdit_Mode == false) ▸ for (row < siMain.Sheet(0… | GRID_LOCK | siMain.LockRange | (row, startIdx, row, siMain.ActiveSheet.ColumnCount - 1, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-ecf443b8 | EditButton | SCP0201_CAPA.cs:599 | if (spdMain != null && spdMain.ActiveSheet.RowCount > 0) ▸ if (fps.Name == "spdMain") ▸ if (bEdit_Mode == false) ▸ for (row < siMain.Sheet(0… | GRID_LOCK | siMain.LockRange | (row, siMain.GetColumnIndex(DefColumns.REQUEST_CHK), row, siMain.GetColumnIndex(DefColumns… | 그리드 편집 잠금/해제 |  |  |  |
| AC-69281dc3 | EditButton | SCP0201_CAPA.cs:609 | if (spdMain != null && spdMain.ActiveSheet.RowCount > 0) ▸ if (fps.Name == "spdMain") ▸ if (bEdit_Mode == false) ▸ for (row < siMain.Sheet(0… | GRID_LOCK | siMain.LockRange | (row, siMain.GetColumnIndex(DefColumns.CONFIRM_FLAG), row, siMain.GetColumnIndex(DefColumn… | 그리드 편집 잠금/해제 |  |  |  |
| AC-420f9da0 | EditButton | SCP0201_CAPA.cs:617 | if (spdMain != null && spdMain.ActiveSheet.RowCount > 0) ▸ if (fps.Name == "spdMain") ▸ if (bEdit_Mode == false) ▸ for (row < siMain.Sheet(0… | FLAG | dtLaneQtyOfLineAssign | Data_SCP.Common(Data_SCP.Type.LaneQtyOfLineAssign, false) | 화면 필드/플래그 변경 |  |  |  |
| AC-e6898610 | EditButton | SCP0201_CAPA.cs:617 | if (spdMain != null && spdMain.ActiveSheet.RowCount > 0) ▸ if (fps.Name == "spdMain") ▸ if (bEdit_Mode == false) ▸ for (row < siMain.Sheet(0… | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.LaneQtyOfLineAssign, false) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-4639bcb7 | EditButton | SCP0201_CAPA.cs:619 | if (spdMain != null && spdMain.ActiveSheet.RowCount > 0) ▸ if (fps.Name == "spdMain") ▸ if (bEdit_Mode == false) ▸ for (row < siMain.Sheet(0… | DATA_OP | dtLaneQtyOfLineAssign.Select | ("DIVISION_ID = '" + sDivisionId + "' AND COMPANY_ID = '" + sCompanyId + "' AND SITE_ID = … | 데이터 객체 조작/조회 |  |  |  |
| AC-d518ffed | EditButton | SCP0201_CAPA.cs:629 | if (spdMain != null && spdMain.ActiveSheet.RowCount > 0) ▸ if (fps.Name == "spdMain") ▸ if (bEdit_Mode == false) ▸ for (row < siMain.Sheet(0… | DATA_OP | dtLanQty.CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-647d6ff6 | EditButton | SCP0201_CAPA.cs:630 | if (spdMain != null && spdMain.ActiveSheet.RowCount > 0) ▸ if (fps.Name == "spdMain") ▸ if (bEdit_Mode == false) ▸ for (row < siMain.Sheet(0… | GRID_COMBO | siMain.SetCellTypeCombo | (row, siMain.GetColumnIndex(DefColumns.LANE_QTY), dtComboLaneQty) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-d04ab84e | EditButton | SCP0201_CAPA.cs:631 | if (spdMain != null && spdMain.ActiveSheet.RowCount > 0) ▸ if (fps.Name == "spdMain") ▸ if (bEdit_Mode == false) ▸ for (row < siMain.Sheet(0… | GRID_LOCK | siMain.LockRange | (row, siMain.GetColumnIndex(DefColumns.LANE_QTY), row, siMain.GetColumnIndex(DefColumns.LA… | 그리드 편집 잠금/해제 |  |  |  |
| AC-fa5cd354 | EditButton | SCP0201_CAPA.cs:635 | if (spdMain != null && spdMain.ActiveSheet.RowCount > 0) ▸ if (fps.Name == "spdMain") ▸ if (bEdit_Mode == false) ▸ for (row < siMain.Sheet(0… | CALL_EXT | siMain.SetDecimal | (row, startIdx, row, siMain.ActiveSheet.ColumnCount - 2, 4, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-40cf02a7 | EditButton | SCP0201_CAPA.cs:638 | if (spdMain != null && spdMain.ActiveSheet.RowCount > 0) ▸ if (fps.Name == "spdMain") ▸ if (bEdit_Mode == false) ▸ for (row < siMain.Sheet(0… | GRID_LOCK | siMain.LockRange | (row, startIdx, row, siMain.ActiveSheet.ColumnCount - 2, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-a89cb5d1 | EditButton | SCP0201_CAPA.cs:648 | if (spdMain != null && spdMain.ActiveSheet.RowCount > 0) ▸ if (fps.Name == "spdMain") ▸ if (bEdit_Mode == false) ▸ for (row < siMain.Sheet(0… | GRID_LOCK | siMain.LockRange | (row, col, row, col, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-22352411 | EditButton | SCP0201_CAPA.cs:655 | if (spdMain != null && spdMain.ActiveSheet.RowCount > 0) ▸ if (fps.Name == "spdMain") ▸ if (bEdit_Mode == false) ▸ for (row < siMain.Sheet(0… | GRID_LOCK | siMain.LockRange | (row, col, row, col, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-4bc818a8 | EditButton | SCP0201_CAPA.cs:660 | if (spdMain != null && spdMain.ActiveSheet.RowCount > 0) ▸ if (fps.Name == "spdMain") ▸ if (bEdit_Mode == false) ▸ for (row < siMain.Sheet(0… | GRID_LOCK | siMain.LockRange | (row, col, row, col, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-f54e7548 | EditButton | SCP0201_CAPA.cs:671 | if (spdMain != null && spdMain.ActiveSheet.RowCount > 0) ▸ if (fps.Name == "spdMain") ▸ else of (bEdit_Mode == false) | FLAG | bEdit_Mode | false | 화면 필드/플래그 변경 |  |  |  |
| AC-7847554c | EditButton | SCP0201_CAPA.cs:672 | if (spdMain != null && spdMain.ActiveSheet.RowCount > 0) ▸ if (fps.Name == "spdMain") ▸ else of (bEdit_Mode == false) | GRID_LOCK | siMain.LockRange | (0, siMain.GetColumnIndex(DefColumns.SITE_NAME), siMain.Sheet(0).Rows.Count-1, siMain.Acti… | 그리드 편집 잠금/해제 |  |  |  |
| AC-706541ce | EditButton | SCP0201_CAPA.cs:680 | if (spdMain != null && spdMain.ActiveSheet.RowCount > 0) ▸ if (fps.Name == "spdMain") ▸ else of (bEdit_Mode == false) ▸ for (row < siMain.Sh… | CALL_EXT | siMain.SetDecimal | (row, startIdx, row, siMain.ActiveSheet.ColumnCount - 2 , 2, true) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0201_CAPA.FindData_Excel_DownLoad

진입점: this.formDown.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-99dde950 | this.formDown.Click | SCP0201_CAPA.cs:2674 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-3ca8dbf2 | this.formDown.Click | SCP0201_CAPA.cs:2681 | try ▸ if (bRealFlag == false) | MESSAGE | MessageHelper.GMessageBox | ("MSG00312", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-79dab616 | this.formDown.Click | SCP0201_CAPA.cs:2682 | try ▸ if (bRealFlag == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1d9b5792 | this.formDown.Click | SCP0201_CAPA.cs:2685 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-045e5a83 | this.formDown.Click | SCP0201_CAPA.cs:2685 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-047a440a | this.formDown.Click | SCP0201_CAPA.cs:2698 | try ▸ if (dtCurrentFrom < dtPeriodTo) | MESSAGE | MessageHelper.GMessageBox | ("MSG00331", new object[] { "3" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-eeecd7ad | this.formDown.Click | SCP0201_CAPA.cs:2699 | try ▸ if (dtCurrentFrom < dtPeriodTo) | UI_PROP | drpPeriodMonth.MonthText2 | dtCurrentFrom.AddMonths(41).ToString("yyyy-MM") | 속성 MonthText2 설정 |  |  |  |
| AC-453de643 | this.formDown.Click | SCP0201_CAPA.cs:2700 | try ▸ if (dtCurrentFrom < dtPeriodTo) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a3788186 | this.formDown.Click | SCP0201_CAPA.cs:2707 | try ▸ if (pBucket.IndexOf("D") == 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00329", new object[] { "Day" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-eb42b998 | this.formDown.Click | SCP0201_CAPA.cs:2708 | try ▸ if (pBucket.IndexOf("D") == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-35979120 | this.formDown.Click | SCP0201_CAPA.cs:2713 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-d0dfb46d | this.formDown.Click | SCP0201_CAPA.cs:2716 | try | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtMain) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-73957048 | this.formDown.Click | SCP0201_CAPA.cs:2741 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-4013cdd4 | this.formDown.Click | SCP0201_CAPA.cs:2745 | try | ENDPOINT | new FoxDataRequest | ("SCP.SCP0049_GET_CAPA") ⇒ SCP.SCP0049_GET_CAPA | 엔드포인트 요청 생성 |  |  |  |
| AC-05b5f604 | this.formDown.Click | SCP0201_CAPA.cs:2746 | try | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-36332677 | this.formDown.Click | SCP0201_CAPA.cs:2747 | try | DATA_OP | request.Parameters["p_today_yyyymmdd"] | sToday | 행/컬럼 값 대입 |  |  |  |
| AC-61bf58a6 | this.formDown.Click | SCP0201_CAPA.cs:2748 | try | DATA_OP | request.Parameters["p_from_yyyymm"] | sPeriodMonth1 | 행/컬럼 값 대입 |  |  |  |
| AC-4827eb67 | this.formDown.Click | SCP0201_CAPA.cs:2749 | try | DATA_OP | request.Parameters["p_to_yyyymm"] | sPeriodMonth2 | 행/컬럼 값 대입 |  |  |  |
| AC-c1c9302e | this.formDown.Click | SCP0201_CAPA.cs:2750 | try | DATA_OP | request.Parameters["p_division_id"] | pDivisionId | 행/컬럼 값 대입 |  |  |  |
| AC-4091ade3 | this.formDown.Click | SCP0201_CAPA.cs:2751 | try | DATA_OP | request.Parameters["p_group"] | pGroup | 행/컬럼 값 대입 |  |  |  |
| AC-f53f1451 | this.formDown.Click | SCP0201_CAPA.cs:2752 | try | DATA_OP | request.Parameters["p_plant_id"] | pPlantId.Equals("ALL") ? DBNull.Value : pPlantId | 행/컬럼 값 대입 |  |  |  |
| AC-4d1d1caa | this.formDown.Click | SCP0201_CAPA.cs:2753 | try | DATA_OP | request.Parameters["p_factory_id"] | pFactoryId.Equals("ALL") ? DBNull.Value : pFactoryId | 행/컬럼 값 대입 |  |  |  |
| AC-ca2472a9 | this.formDown.Click | SCP0201_CAPA.cs:2754 | try | DATA_OP | request.Parameters["p_version_id"] | pVersionId | 행/컬럼 값 대입 |  |  |  |
| AC-76ef9b2c | this.formDown.Click | SCP0201_CAPA.cs:2755 | try | DATA_OP | request.Parameters["p_line_id"] | pLineId.Equals("ALL") ? DBNull.Value : pLineId | 행/컬럼 값 대입 |  |  |  |
| AC-cf31af60 | this.formDown.Click | SCP0201_CAPA.cs:2756 | try | DATA_OP | request.Parameters["p_operation_id"] | pOperationId.Equals("ALL") ? DBNull.Value : pOperationId | 행/컬럼 값 대입 |  |  |  |
| AC-e5fc6e17 | this.formDown.Click | SCP0201_CAPA.cs:2757 | try | DATA_OP | request.Parameters["p_model_id"] | pModelId | 행/컬럼 값 대입 |  |  |  |
| AC-6164f7ad | this.formDown.Click | SCP0201_CAPA.cs:2758 | try | DATA_OP | request.Parameters["p_item_id"] | pItemId | 행/컬럼 값 대입 |  |  |  |
| AC-e4b6ee7d | this.formDown.Click | SCP0201_CAPA.cs:2759 | try | DATA_OP | request.Parameters["p_nick_name"] | pNickName | 행/컬럼 값 대입 |  |  |  |
| AC-44c65224 | this.formDown.Click | SCP0201_CAPA.cs:2760 | try | DATA_OP | request.Parameters["p_bucket"] | pBucket | 행/컬럼 값 대입 |  |  |  |
| AC-46462ef1 | this.formDown.Click | SCP0201_CAPA.cs:2761 | try | DATA_OP | request.Parameters["p_check_loss"] | pCheckLoss | 행/컬럼 값 대입 |  |  |  |
| AC-cb4928fb | this.formDown.Click | SCP0201_CAPA.cs:2762 | try | DATA_OP | request.Parameters["p_check_line"] | pCheckLine | 행/컬럼 값 대입 |  |  |  |
| AC-11aca264 | this.formDown.Click | SCP0201_CAPA.cs:2763 | try | DATA_OP | request.Parameters["p_check_tact"] | pCheckTact | 행/컬럼 값 대입 |  |  |  |
| AC-f69dff14 | this.formDown.Click | SCP0201_CAPA.cs:2764 | try | DATA_OP | request.Parameters["p_check_yield"] | pCheckYield | 행/컬럼 값 대입 |  |  |  |
| AC-511529bb | this.formDown.Click | SCP0201_CAPA.cs:2765 | try | DATA_OP | request.Parameters["p_check_empty"] | pCheckEmpty | 행/컬럼 값 대입 |  |  |  |
| AC-992677be | this.formDown.Click | SCP0201_CAPA.cs:2766 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-edd12ffc | this.formDown.Click | SCP0201_CAPA.cs:2767 | try | DATA_OP | request.Parameters["p_user_auth"] | UserInfoContext.Current["NowGroupID"] | 행/컬럼 값 대입 |  |  |  |
| AC-a4c03cb3 | this.formDown.Click | SCP0201_CAPA.cs:2768 | try | DATA_OP | request.Parameters["p_search_type"] | SearchType.EXCEL | 행/컬럼 값 대입 |  |  |  |
| AC-2f8c6489 | this.formDown.Click | SCP0201_CAPA.cs:2769 | try | DATA_OP | request.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-6f62c418 | this.formDown.Click | SCP0201_CAPA.cs:2771 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-e8617e7b | this.formDown.Click | SCP0201_CAPA.cs:2785 | try | UI_PROP | dv.Sort | sOrderBy | 속성 Sort 설정 |  |  |  |
| AC-626da257 | this.formDown.Click | SCP0201_CAPA.cs:2786 | try | DATA_OP | dsSort.Tables.Add | (dv.ToTable()) | 데이터 객체 조작/조회 |  |  |  |
| AC-8171ee4a | this.formDown.Click | SCP0201_CAPA.cs:2786 | try | DATA_OP | dv.ToTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-55345b26 | this.formDown.Click | SCP0201_CAPA.cs:2788 | try | GRID_BIND | siExcelTemp.Query | (dsSort) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-d12428e4 | this.formDown.Click | SCP0201_CAPA.cs:2796 | catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-e00d6371 | this.formDown.Click | SCP0201_CAPA.cs:2797 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-04de69d9 | this.formDown.Click | SCP0201_CAPA.cs:2801 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0201_CAPA.FindData_Main

진입점: txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter)] / txtMaterialId.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter)] / txtNickName.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter)] / this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MSG00265") == DialogResult.Yes)] / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8d1923ba | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 4 | SCP0201_CAPA.cs:809 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-2ad0871c | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 4 | SCP0201_CAPA.cs:812 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-181ea343 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 4 | SCP0201_CAPA.cs:812 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0d8fc62e | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 4 | SCP0201_CAPA.cs:827 | try ▸ if (nDate1 > nDate2) | MESSAGE | MessageHelper.GMessageBox | ("MSG00108", new object[] { null }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f23684b4 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 4 | SCP0201_CAPA.cs:828 | try ▸ if (nDate1 > nDate2) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-fe9d112d | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 4 | SCP0201_CAPA.cs:833 | try ▸ if (pBucket.IndexOf("D") == 0 && dtPeriodFrom.AddYears(1) < dtPeriodTo) | MESSAGE | MessageHelper.GMessageBox | ("MSG00354", new object[] { "Day" ,"1"}) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-04917cf6 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 4 | SCP0201_CAPA.cs:834 | try ▸ if (pBucket.IndexOf("D") == 0 && dtPeriodFrom.AddYears(1) < dtPeriodTo) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-938d69a0 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 4 | SCP0201_CAPA.cs:839 | try ▸ if (dtPeriodFrom.AddYears(6) < dtPeriodTo) | MESSAGE | MessageHelper.GMessageBox | ("MSG00326" , new object[] { "6" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f23e37c0 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 4 | SCP0201_CAPA.cs:841 | try ▸ if (dtPeriodFrom.AddYears(6) < dtPeriodTo) | UI_PROP | drpPeriodMonth.MonthText2 | dtPeriodFrom.AddYears(6).ToString("yyyy-MM") | 속성 MonthText2 설정 |  |  |  |
| AC-a03758ca | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 4 | SCP0201_CAPA.cs:842 | try ▸ if (dtPeriodFrom.AddYears(6) < dtPeriodTo) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8fb9be2a | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 4 | SCP0201_CAPA.cs:847 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-bb500a36 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 4 | SCP0201_CAPA.cs:850 | try | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtMain) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-595f9c94 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 4 | SCP0201_CAPA.cs:872 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-b3da1550 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 4 | SCP0201_CAPA.cs:873 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCP.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-7a6774dd | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 4 | SCP0201_CAPA.cs:877 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0201_GET_CAPA") ⇒ SCP.SCP0201_GET_CAPA | 엔드포인트 요청 생성 |  |  |  |
| AC-969a71db | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 4 | SCP0201_CAPA.cs:878 | try ▸ lambda | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-762f83d7 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 4 | SCP0201_CAPA.cs:879 | try ▸ lambda | DATA_OP | request.Parameters["p_today_yyyymmdd"] | sToday | 행/컬럼 값 대입 |  |  |  |
| AC-0d998ade | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 4 | SCP0201_CAPA.cs:880 | try ▸ lambda | DATA_OP | request.Parameters["p_from_yyyymm"] | sPeriodMonth1 | 행/컬럼 값 대입 |  |  |  |
| AC-2bdfdcef | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 4 | SCP0201_CAPA.cs:881 | try ▸ lambda | DATA_OP | request.Parameters["p_to_yyyymm"] | sPeriodMonth2 | 행/컬럼 값 대입 |  |  |  |
| AC-983f004e | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 4 | SCP0201_CAPA.cs:882 | try ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | pDivisionId | 행/컬럼 값 대입 |  |  |  |
| AC-e34a73b6 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 4 | SCP0201_CAPA.cs:883 | try ▸ lambda | DATA_OP | request.Parameters["p_group"] | pGroup | 행/컬럼 값 대입 |  |  |  |
| AC-2310b579 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 4 | SCP0201_CAPA.cs:884 | try ▸ lambda | DATA_OP | request.Parameters["p_plant_id"] | pPlantId.Equals("ALL") ? DBNull.Value : pPlantId | 행/컬럼 값 대입 |  |  |  |
| AC-063dbdcf | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 4 | SCP0201_CAPA.cs:885 | try ▸ lambda | DATA_OP | request.Parameters["p_factory_id"] | pFactoryId.Equals("ALL") ? DBNull.Value : pFactoryId | 행/컬럼 값 대입 |  |  |  |
| AC-74e7af04 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 4 | SCP0201_CAPA.cs:886 | try ▸ lambda | DATA_OP | request.Parameters["p_version_id"] | pVersionId | 행/컬럼 값 대입 |  |  |  |
| AC-328afff2 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 4 | SCP0201_CAPA.cs:887 | try ▸ lambda | DATA_OP | request.Parameters["p_line_id"] | pLineId.Equals("ALL") ? DBNull.Value : pLineId | 행/컬럼 값 대입 |  |  |  |
| AC-0bd9c9f3 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 4 | SCP0201_CAPA.cs:888 | try ▸ lambda | DATA_OP | request.Parameters["p_operation_id"] | pOperationId.Equals("ALL") ? DBNull.Value : pOperationId | 행/컬럼 값 대입 |  |  |  |
| AC-cc9003c6 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 4 | SCP0201_CAPA.cs:889 | try ▸ lambda | DATA_OP | request.Parameters["p_model_id"] | pModelId | 행/컬럼 값 대입 |  |  |  |
| AC-7ff0a417 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 4 | SCP0201_CAPA.cs:890 | try ▸ lambda | DATA_OP | request.Parameters["p_item_id"] | pItemId | 행/컬럼 값 대입 |  |  |  |
| AC-e2182cbe | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 4 | SCP0201_CAPA.cs:891 | try ▸ lambda | DATA_OP | request.Parameters["p_nick_name"] | pNickName | 행/컬럼 값 대입 |  |  |  |
| AC-06d89af3 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 4 | SCP0201_CAPA.cs:892 | try ▸ lambda | DATA_OP | request.Parameters["p_bucket"] | pBucket | 행/컬럼 값 대입 |  |  |  |
| AC-e997f014 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 4 | SCP0201_CAPA.cs:893 | try ▸ lambda | DATA_OP | request.Parameters["p_check_loss"] | pCheckLoss | 행/컬럼 값 대입 |  |  |  |
| AC-7a58c1e7 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 4 | SCP0201_CAPA.cs:894 | try ▸ lambda | DATA_OP | request.Parameters["p_check_line"] | pCheckLine | 행/컬럼 값 대입 |  |  |  |
| AC-94bec0f4 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 4 | SCP0201_CAPA.cs:895 | try ▸ lambda | DATA_OP | request.Parameters["p_check_tact"] | pCheckTact | 행/컬럼 값 대입 |  |  |  |
| AC-d8742467 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 4 | SCP0201_CAPA.cs:896 | try ▸ lambda | DATA_OP | request.Parameters["p_check_yield"] | pCheckYield | 행/컬럼 값 대입 |  |  |  |
| AC-a3b015e7 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 4 | SCP0201_CAPA.cs:897 | try ▸ lambda | DATA_OP | request.Parameters["p_check_empty"] | pCheckEmpty | 행/컬럼 값 대입 |  |  |  |
| AC-d1dcb565 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 4 | SCP0201_CAPA.cs:898 | try ▸ lambda | DATA_OP | request.Parameters["p_user_id"] | UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-bf3eacd8 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 4 | SCP0201_CAPA.cs:899 | try ▸ lambda | DATA_OP | request.Parameters["p_user_auth"] | UserInfoContext.Current["NowGroupID"] | 행/컬럼 값 대입 |  |  |  |
| AC-3dc3868c | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 4 | SCP0201_CAPA.cs:900 | try ▸ lambda | DATA_OP | request.Parameters["p_search_type"] | SearchType.CAPA | 행/컬럼 값 대입 |  |  |  |
| AC-f6fb62f6 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 4 | SCP0201_CAPA.cs:901 | try ▸ lambda | DATA_OP | request.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-7363bd6b | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 4 | SCP0201_CAPA.cs:903 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-5583813e | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 4 | SCP0201_CAPA.cs:905 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-f88d140c | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 4 | SCP0201_CAPA.cs:919 | try | UI_PROP | dv.Sort | sOrderBy | 속성 Sort 설정 |  |  |  |
| AC-59bd204f | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 4 | SCP0201_CAPA.cs:921 | try | DATA_OP | dsSort.Tables.Add | (dv.ToTable()) | 데이터 객체 조작/조회 |  |  |  |
| AC-dfb1fb39 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 4 | SCP0201_CAPA.cs:921 | try | DATA_OP | dv.ToTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-61b09a71 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 4 | SCP0201_CAPA.cs:924 | try | GRID_BIND | siMain.Query | (dsSort) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-299333ee | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 4 | SCP0201_CAPA.cs:926 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-2a1f2dd3 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 4 | SCP0201_CAPA.cs:929 | try | VALUE_SET | txtTotal.Text | ds.Tables[1].Rows[0][0].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-226d0acf | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 4 | SCP0201_CAPA.cs:930 | try | VALUE_SET | txtAuto.Text | ds.Tables[1].Rows[0][1].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-749d7dff | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 4 | SCP0201_CAPA.cs:931 | try | VALUE_SET | txtSmall.Text | ds.Tables[1].Rows[0][2].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-52bb7d6e | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 4 | SCP0201_CAPA.cs:932 | try | VALUE_SET | txtElec.Text | ds.Tables[1].Rows[0][3].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-cc9508b7 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 4 | SCP0201_CAPA.cs:933 | try | VALUE_SET | txtPIC.Text | ds.Tables[2].Rows[0][0].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-cbff8961 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 4 | SCP0201_CAPA.cs:935 | try | UI_PROP | txtTotal.TextAlign | HorizontalAlignment.Right | 속성 TextAlign 설정 |  |  |  |
| AC-233516e8 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 4 | SCP0201_CAPA.cs:936 | try | UI_PROP | txtAuto.TextAlign | HorizontalAlignment.Right | 속성 TextAlign 설정 |  |  |  |
| AC-072ccb5f | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 4 | SCP0201_CAPA.cs:937 | try | UI_PROP | txtSmall.TextAlign | HorizontalAlignment.Right | 속성 TextAlign 설정 |  |  |  |
| AC-992584e9 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 4 | SCP0201_CAPA.cs:938 | try | UI_PROP | txtElec.TextAlign | HorizontalAlignment.Right | 속성 TextAlign 설정 |  |  |  |
| AC-4dc5177a | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 4 | SCP0201_CAPA.cs:939 | try | UI_PROP | txtPIC.TextAlign | HorizontalAlignment.Right | 속성 TextAlign 설정 |  |  |  |
| AC-5d102947 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 4 | SCP0201_CAPA.cs:942 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-15e5f0e0 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 4 | SCP0201_CAPA.cs:947 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e34da982 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 4 | SCP0201_CAPA.cs:967 | catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-3e87324a | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 4 | SCP0201_CAPA.cs:968 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-5ec3a9e5 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 4 | SCP0201_CAPA.cs:972 | finally | FLAG | this.bEdit_Mode | false | 화면 필드/플래그 변경 |  |  |  |
| AC-e5cfe56a | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 4 | SCP0201_CAPA.cs:973 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0201_CAPA.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f6b373f2 | this.Load | SCP0201_CAPA.cs:252 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCP0201_CAPA.GetDayRange

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d489483a | this.Load | SCP0201_CAPA.cs:1516 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0049_GET_DAY_RANGE") ⇒ SCP.SCP0049_GET_DAY_RANGE | 엔드포인트 요청 생성 |  |  |  |
| AC-8d9b991c | this.Load | SCP0201_CAPA.cs:1517 |  | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-6de91dc7 | this.Load | SCP0201_CAPA.cs:1518 |  | DATA_OP | request.Parameters["p_month"] | 13 | 행/컬럼 값 대입 |  |  |  |
| AC-3fb75544 | this.Load | SCP0201_CAPA.cs:1520 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-07ec08a3 | this.Load | SCP0201_CAPA.cs:1520 |  | RETURN | return client.ExecuteDataSet(request).DataSet.Tables[0]; |  | 처리 중단/반환 |  |  |  |

## SCP0201_CAPA.GetSpdTitle

진입점: this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter) ▸ try ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / txtMaterialId.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter) ▸ try ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / txtNickName.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter) ▸ try ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / this.formDown.Click [try ▸ if (spdInfo.SheetName == SpdS…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-821b36e5 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 7 | SCP0201_CAPA.cs:1419 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0049_GET_SHEET_CALENDAR") ⇒ SCP.SCP0049_GET_SHEET_CALENDAR | 엔드포인트 요청 생성 |  |  |  |
| AC-2b74ae37 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 7 | SCP0201_CAPA.cs:1425 |  | DATA_OP | request.Parameters["p_today_yyyymmdd"] | sToday | 행/컬럼 값 대입 |  |  |  |
| AC-28067707 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 7 | SCP0201_CAPA.cs:1426 |  | DATA_OP | request.Parameters["p_from_yyyymm"] | currentMonth | 행/컬럼 값 대입 |  |  |  |
| AC-e60f423d | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 7 | SCP0201_CAPA.cs:1427 |  | DATA_OP | request.Parameters["p_to_yyyymm"] | sPeriodMonth[1] | 행/컬럼 값 대입 |  |  |  |
| AC-1408390f | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 7 | SCP0201_CAPA.cs:1428 |  | DATA_OP | request.Parameters["p_bucket"] | pBucket | 행/컬럼 값 대입 |  |  |  |
| AC-50ee383f | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 7 | SCP0201_CAPA.cs:1430 |  | FLAG | dsSpdTitle | client.ExecuteDataSet(request).DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-29aad08f | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 7 | SCP0201_CAPA.cs:1430 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## SCP0201_CAPA.GetUserTitle

진입점: this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter) ▸ try ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / txtMaterialId.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter) ▸ try ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / txtNickName.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter) ▸ try ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / this.formDown.Click [try ▸ if (spdInfo.SheetName == SpdS…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4520a546 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 7 | SCP0201_CAPA.cs:1438 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0049_GET_SHEET_USER_TITLE") ⇒ SCP.SCP0049_GET_SHEET_USER_TITLE | 엔드포인트 요청 생성 |  |  |  |
| AC-0a498bc3 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 7 | SCP0201_CAPA.cs:1440 |  | DATA_OP | request.Parameters["p_program_id"] | "SCP0049" | 행/컬럼 값 대입 |  |  |  |
| AC-f81c0f29 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 7 | SCP0201_CAPA.cs:1441 |  | DATA_OP | request.Parameters["p_sheet_name"] | SpdSheet.shtMain | 행/컬럼 값 대입 |  |  |  |
| AC-0914b21b | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 7 | SCP0201_CAPA.cs:1442 |  | DATA_OP | request.Parameters["p_user_id"] | UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-05b2aa1e | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 7 | SCP0201_CAPA.cs:1444 |  | FLAG | dsUserTitle | client.ExecuteDataSet(request).DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-31e3ce6a | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 7 | SCP0201_CAPA.cs:1444 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## SCP0201_CAPA.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-655563c4 | this.Load | SCP0201_CAPA.cs:270 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-d8242976 | this.Load | SCP0201_CAPA.cs:273 | if (dtMyDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |
| AC-20886fd4 | this.Load | SCP0201_CAPA.cs:277 |  | DATA_OP | dtMyDivision.Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-8b127a8f | this.Load | SCP0201_CAPA.cs:278 |  | DATA_OP | tmpDivision.Columns.Add | ("SORT_ORDER") | 데이터 객체 조작/조회 |  |  |  |
| AC-54e5a22c | this.Load | SCP0201_CAPA.cs:279 |  | CALL_EXT | tmpDivision.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-9b89eedb | this.Load | SCP0201_CAPA.cs:283 | foreach (DataRow dr in dtMyDivision.Rows) | DATA_OP | tmpDivision.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-70254e83 | this.Load | SCP0201_CAPA.cs:284 | foreach (DataRow dr in dtMyDivision.Rows) | DATA_OP | dataRow["CODE"] | dr["CODE"] | 행/컬럼 값 대입 |  |  |  |
| AC-8d671367 | this.Load | SCP0201_CAPA.cs:285 | foreach (DataRow dr in dtMyDivision.Rows) | DATA_OP | dataRow["NAME"] | dr["NAME"] | 행/컬럼 값 대입 |  |  |  |
| AC-c530ab47 | this.Load | SCP0201_CAPA.cs:286 | foreach (DataRow dr in dtMyDivision.Rows) | DATA_OP | dataRow["SORT_ORDER"] | dr["CODE"].ToString() == "81" ? 1 : dr["CODE"].ToString() == "40" ? 2 : 3 | 행/컬럼 값 대입 |  |  |  |
| AC-1f00c637 | this.Load | SCP0201_CAPA.cs:288 | foreach (DataRow dr in dtMyDivision.Rows) | CALL_EXT | tmpDivision.Rows.InsertAt | (dataRow, 0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-50f32c89 | this.Load | SCP0201_CAPA.cs:291 |  | UI_PROP | tmpDivision.DefaultView.Sort | "SORT_ORDER Asc" | 속성 Sort 설정 |  |  |  |
| AC-50cfd3e4 | this.Load | SCP0201_CAPA.cs:292 |  | DATA_OP | tmpDivision.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-e4b1c2e3 | this.Load | SCP0201_CAPA.cs:294 |  | DATA_OP | tmpDivision.DefaultView.ToTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-ccdbf7e8 | this.Load | SCP0201_CAPA.cs:296 |  | STATE_RESET | dtMyDivision.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-35d4ca74 | this.Load | SCP0201_CAPA.cs:297 |  | FLAG | dtMyDivision | dtDivisionOrder.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-c9598ef8 | this.Load | SCP0201_CAPA.cs:297 |  | DATA_OP | dtDivisionOrder.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-11345745 | this.Load | SCP0201_CAPA.cs:299 |  | LIST_REBIND | clsCtrl.setListBox | (dtMyDivision, cboDivision, false,"CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-b6ba97e8 | this.Load | SCP0201_CAPA.cs:302 |  | VALUE_SET | checkLoss.Checked | false | 컨트롤 값 설정 |  |  |  |
| AC-572f2a71 | this.Load | SCP0201_CAPA.cs:303 |  | VALUE_SET | checkLineAssign.Checked | true | 컨트롤 값 설정 |  |  |  |
| AC-bc3444ab | this.Load | SCP0201_CAPA.cs:304 |  | VALUE_SET | checkTactTime.Checked | true | 컨트롤 값 설정 |  |  |  |
| AC-f02fd389 | this.Load | SCP0201_CAPA.cs:305 |  | VALUE_SET | checkYield.Checked | true | 컨트롤 값 설정 |  |  |  |
| AC-6a2151ba | this.Load | SCP0201_CAPA.cs:306 |  | VALUE_SET | checkRESULT.Checked | true | 컨트롤 값 설정 |  |  |  |
| AC-784164d8 | this.Load | SCP0201_CAPA.cs:310 |  | DATA_OP | dtTemp.Columns.Add | ("CODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-8c9f5068 | this.Load | SCP0201_CAPA.cs:311 |  | DATA_OP | dtTemp.Columns.Add | ("NAME") | 데이터 객체 조작/조회 |  |  |  |
| AC-0abf15b1 | this.Load | SCP0201_CAPA.cs:312 |  | DATA_OP | dtTemp.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-cf7062fd | this.Load | SCP0201_CAPA.cs:314 |  | DATA_OP | drCurrentRow["CODE"] | "Current" | 행/컬럼 값 대입 |  |  |  |
| AC-7f001f38 | this.Load | SCP0201_CAPA.cs:315 |  | DATA_OP | drCurrentRow["NAME"] | "Current" | 행/컬럼 값 대입 |  |  |  |
| AC-7b973ed5 | this.Load | SCP0201_CAPA.cs:316 |  | DATA_OP | dtTemp.Rows.Add | (drCurrentRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-5a25b753 | this.Load | SCP0201_CAPA.cs:317 |  | LIST_REBIND | clsCtrl.setListBox | (dtTemp, cboVersionId, false, "CODE","NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-2ecd12d7 | this.Load | SCP0201_CAPA.cs:323 | if (dt != null && dt.Rows.Count > 0) | UI_PROP | drpPeriodMonth.MonthText1 | currentMonth | 속성 MonthText1 설정 |  |  |  |
| AC-7ac9275a | this.Load | SCP0201_CAPA.cs:324 | if (dt != null && dt.Rows.Count > 0) | UI_PROP | drpPeriodMonth.MonthText2 | dt.Rows[0]["TO_VALUE"].ToString().Substring(0, 6) | 속성 MonthText2 설정 |  |  |  |
| AC-91e87eaf | this.Load | SCP0201_CAPA.cs:326 | if (dt != null && dt.Rows.Count > 0) | UI_PROP | drpPeriodMonth.MonthMin1 | dt.Rows[0]["FROM_VALUE"].ToString().Substring(0, 6) | 속성 MonthMin1 설정 |  |  |  |
| AC-5fa9f276 | this.Load | SCP0201_CAPA.cs:327 | if (dt != null && dt.Rows.Count > 0) | UI_PROP | drpPeriodMonth.MonthMax1 | currentMonth | 속성 MonthMax1 설정 |  |  |  |
| AC-00667816 | this.Load | SCP0201_CAPA.cs:333 | if (dt != null && dt.Rows.Count > 0) | UI_PROP | drpPeriodMonth.MonthMin2 | dt.Rows[0]["FROM_VALUE"].ToString().Substring(0, 6) | 속성 MonthMin2 설정 |  |  |  |
| AC-7e18d3c9 | this.Load | SCP0201_CAPA.cs:335 | if (dt != null && dt.Rows.Count > 0) | UI_PROP | drpPeriodMonth.MonthMax2 | dateMaxMonth.Substring(0, 6) | 속성 MonthMax2 설정 |  |  |  |
| AC-238e0aa4 | this.Load | SCP0201_CAPA.cs:340 |  | DATA_OP | dtBucketTemp.Columns.Add | ("CODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-d1c0e0fa | this.Load | SCP0201_CAPA.cs:341 |  | DATA_OP | dtBucketTemp.Columns.Add | ("NAME") | 데이터 객체 조작/조회 |  |  |  |
| AC-e70b3ed9 | this.Load | SCP0201_CAPA.cs:343 |  | DATA_OP | dtBucketTemp.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-7bc5240f | this.Load | SCP0201_CAPA.cs:344 |  | DATA_OP | drBucketMonthRow["CODE"] | "M" | 행/컬럼 값 대입 |  |  |  |
| AC-fc19065c | this.Load | SCP0201_CAPA.cs:345 |  | DATA_OP | drBucketMonthRow["NAME"] | "Month" | 행/컬럼 값 대입 |  |  |  |
| AC-7c263f53 | this.Load | SCP0201_CAPA.cs:346 |  | DATA_OP | dtBucketTemp.Rows.Add | (drBucketMonthRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-66aaa0c6 | this.Load | SCP0201_CAPA.cs:348 |  | DATA_OP | dtBucketTemp.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-c8cda587 | this.Load | SCP0201_CAPA.cs:349 |  | DATA_OP | drBucketDayRow["CODE"] | "D" | 행/컬럼 값 대입 |  |  |  |
| AC-4dda334c | this.Load | SCP0201_CAPA.cs:350 |  | DATA_OP | drBucketDayRow["NAME"] | "Day" | 행/컬럼 값 대입 |  |  |  |
| AC-960aa850 | this.Load | SCP0201_CAPA.cs:351 |  | DATA_OP | dtBucketTemp.Rows.Add | (drBucketDayRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-3f3ec745 | this.Load | SCP0201_CAPA.cs:353 |  | LIST_REBIND | clsCtrl.setListBox | (dtBucketTemp, clbBucket, false) | 목록 컨트롤 재구성 |  |  |  |
| AC-e26c6771 | this.Load | SCP0201_CAPA.cs:354 |  | CALL_EXT | clbBucket.SetValues | ("Month") | ⚠ 의미 확인 필요 |  |  |  |
| AC-66a931d6 | this.Load | SCP0201_CAPA.cs:359 | if (UserInfoContext.Current["NowGroupID"] == "SCM PI Admin") | UI_PROP | layoutControlItem1.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-7b89aee3 | this.Load | SCP0201_CAPA.cs:363 | else of (UserInfoContext.Current["NowGroupID"] == "SCM PI Admin") | UI_PROP | layoutControlItem1.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-4d972cd9 | this.Load | SCP0201_CAPA.cs:371 |  | DATA_OP | Filter["USER_ID"] | "chkim.68" | 행/컬럼 값 대입 |  |  |  |
| AC-ffcf36bc | this.Load | SCP0201_CAPA.cs:372 |  | DATA_OP | Filter["DIVISION_ID"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-750b5fdb | this.Load | SCP0201_CAPA.cs:373 |  | DATA_OP | Filter["SITE_ID"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-4853b7df | this.Load | SCP0201_CAPA.cs:374 |  | DATA_OP | Filter["OPERATION_ID"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-b64fd30f | this.Load | SCP0201_CAPA.cs:375 |  | DATA_OP | Filter["PLANT_ID"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-c22c1613 | this.Load | SCP0201_CAPA.cs:376 |  | DATA_OP | Filter["FACTORY_ID"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-17556544 | this.Load | SCP0201_CAPA.cs:383 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("CAPA_PIC", "get_line_by_operation", Filter.Dictionary, "Capa") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=get_line_by_operation] \| FP\Ca… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-5c0eb4a5 | this.Load | SCP0201_CAPA.cs:384 |  | UI_PROP | tvTri.CheckBoxes | true | 속성 CheckBoxes 설정 |  |  |  |
| AC-66212d93 | this.Load | SCP0201_CAPA.cs:385 |  | LIST_CLEAR | tvTri.DataSource | null | 목록/그리드 데이터 원천 해제 |  |  |  |
| AC-11f579b7 | this.Load | SCP0201_CAPA.cs:386 |  | LIST_BIND | tvTri.DataSource | dtDup | 목록/그리드 데이터 원천 연결 |  |  |  |
| AC-9ba2cf5d | this.Load | SCP0201_CAPA.cs:387 |  | UI_PROP | tvTri.Relation | new List<string>() { "company_id", "division_id","site_id","factory_id","line_name" } | 속성 Relation 설정 |  |  |  |
| AC-996c34c1 | this.Load | SCP0201_CAPA.cs:389 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("CAPA_PIC", "get_instance_authority", Filter.Dictionary, "Capa") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=get_instance_authority] \| FP\C… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-9c9b0389 | this.Load | SCP0201_CAPA.cs:390 |  | UI_PROP | triLeft.CheckBoxes | false | 속성 CheckBoxes 설정 |  |  |  |
| AC-428b0a90 | this.Load | SCP0201_CAPA.cs:391 |  | UI_PROP | triLeft.UIDataName | "ROLE_DESCR" | 속성 UIDataName 설정 |  |  |  |
| AC-a5911af3 | this.Load | SCP0201_CAPA.cs:392 |  | UI_PROP | triLeft.UIDataID | "ROLE_ID" | 속성 UIDataID 설정 |  |  |  |
| AC-a09b64eb | this.Load | SCP0201_CAPA.cs:393 |  | UI_PROP | triLeft.UIDataOrder | "ROLE_DETAIL_ORDER" | 속성 UIDataOrder 설정 |  |  |  |
| AC-83c2c6a8 | this.Load | SCP0201_CAPA.cs:394 |  | UI_PROP | triLeft.UILevel | "LVL" | 속성 UILevel 설정 |  |  |  |
| AC-0e456847 | this.Load | SCP0201_CAPA.cs:395 |  | UI_PROP | triLeft.UIDataImg | "IMG" | 속성 UIDataImg 설정 |  |  |  |
| AC-cfe6c0c8 | this.Load | SCP0201_CAPA.cs:396 |  | UI_PROP | triLeft.UIDataParentID | "UPPER_ROLE_ID" | 속성 UIDataParentID 설정 |  |  |  |
| AC-b3db8b97 | this.Load | SCP0201_CAPA.cs:398 |  | UI_PROP | triLeft.UIDataSource | dtDup | 속성 UIDataSource 설정 |  |  |  |

## SCP0201_CAPA.InitSpread

진입점: this.Load / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK)] / txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter) ▸ try] / txtMaterialId.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter) ▸ try] / txtNickName.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter) ▸ try] / this.formDown.Click [try] / this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MSG00265") == DialogResult.Yes) ▸ try] / FindButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-80a3a4fe | this.Load 외 7 | SCP0201_CAPA.cs:452 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-bc8f26f3 | this.Load 외 7 | SCP0201_CAPA.cs:453 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-9585237a | this.Load 외 7 | SCP0201_CAPA.cs:462 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (spdInfo.SheetName == SpdSheet.shtCAPAExcel) | GRID_INIT | spdInfo.InitSheet | (spdInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-e2e6f470 | this.Load 외 7 | SCP0201_CAPA.cs:466 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (spdInfo.SheetName == SpdSheet.shtCAPAExcel) | GRID_INIT | spdInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCP0201_CAPA.InitSpreadDateColumn

진입점: this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter) ▸ try ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / txtMaterialId.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter) ▸ try ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / txtNickName.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter) ▸ try ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / this.formDown.Click [try ▸ if (spdInfo.SheetName == SpdS…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a0ed47c7 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 7 | SCP0201_CAPA.cs:1461 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (spdInfo.SheetName == SpdSheet.shtMain) | CALL_EXT | spdInfo.AddNumColumnEx | (sColumnLabelname, sColumnName, FPMerge.None, 70, true, true, 2) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f43afaf6 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 7 | SCP0201_CAPA.cs:1467 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (dr[DefColumns.DayCode].ToString() == De… | GRID_SET | siMain.Sheet().ColumnHeader.Cells[0, startIdx + iCellCnt].ForeColor | dr[DefColumns.DayCode].ToString() == DefColumnsLabel.Saturday ? Color.Blue : Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-f4504ac7 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 7 | SCP0201_CAPA.cs:1473 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (spdInfo.SheetName == SpdSheet.shtC… | CALL_EXT | spdInfo.AddNumColumnEx | (columnText, sColumnName, FPMerge.None, 70, true, true, 2) | ⚠ 의미 확인 필요 |  |  |  |
| AC-170c6936 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 7 | SCP0201_CAPA.cs:1479 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (spdInfo.SheetName == SpdSheet.shtC… | GRID_SET | spdInfo.Sheet().ColumnHeader.Cells[0, startIdx + iCellCnt].ForeColor | dr[DefColumns.DayCode].ToString() == DefColumnsLabel.Saturday ? Color.Blue : Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-4b24cf3c | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 7 | SCP0201_CAPA.cs:1483 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (spdInfo.SheetName == SpdSheet.shtC… | GRID_SET | spdInfo.Sheet().ColumnHeader.Cells[0, startIdx + iCellCnt].BackColor | Color.LightGreen | 그리드 속성/값 설정 |  |  |  |
| AC-10d5b813 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 7 | SCP0201_CAPA.cs:1490 | if (spdInfo.SheetName == SpdSheet.shtMain) | CALL_EXT | siMain.ColumnHeaderSpanRow | (siMain.GetColumnIndex(DefColumns.CONFIRM_FLAG) + 1, siMain.ActiveSheet.ColumnCount - 1) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0201_CAPA.InitSpreadRequestColumn

진입점: this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter) ▸ try ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / txtMaterialId.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter) ▸ try ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / txtNickName.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter) ▸ try ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / this.formDown.Click [try ▸ if (spdInfo.SheetName == SpdS…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-175eb383 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 7 | SCP0201_CAPA.cs:1503 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.AddCheckColumn | ("Mail REQ", DefColumns.REQUEST_CHK, FPMerge.None, 60, true, FPHAlign.Center, FPVAlign.Cen… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c4cea67a | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 7 | SCP0201_CAPA.cs:1505 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[1, siMain.GetColumnIndex(DefColumns.REQUEST_CHK)].Ce… | chk | 그리드 속성/값 설정 |  |  |  |
| AC-ef7d7e89 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 7 | SCP0201_CAPA.cs:1506 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[1, siMain.GetColumnIndex(DefColumns.REQUEST_CHK)].Va… | false | 그리드 속성/값 설정 |  |  |  |
| AC-c9c48632 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 7 | SCP0201_CAPA.cs:1507 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[1, siMain.GetColumnIndex(DefColumns.REQUEST_CHK)].Bo… | bevelbrdr | 그리드 속성/값 설정 |  |  |  |
| AC-770cedd5 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 7 | SCP0201_CAPA.cs:1508 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex(DefColumns.REQUEST_CHK)].Te… | "Mail REQ" | 그리드 속성/값 설정 |  |  |  |

## SCP0201_CAPA.Re_Design

진입점: txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter) ▸ try] / txtMaterialId.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter) ▸ try] / txtNickName.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter) ▸ try] / this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MSG00265") == DialogResult.Yes) ▸ try] / FindButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-000484bc | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 4 | SCP0201_CAPA.cs:1533 | try ▸ if (siMain.ActiveSheet.RowCount > 0) | FLAG | arrayLA001 | new ArrayList() | 화면 필드/플래그 변경 |  |  |  |
| AC-029ef830 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 4 | SCP0201_CAPA.cs:1553 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SCP0201_CAPA.Re_Design_Excel

진입점: this.formDown.Click [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-956ec5d0 | this.formDown.Click [try] | SCP0201_CAPA.cs:1982 | if (siExcelTemp.ActiveSheet.RowCount > 0) ▸ for (row < siExcelTemp.ActiveSheet.RowCount) ▸ if (sCategoryId == "Not-Available" \|\| sCategory… | GRID_STYLE | siExcelTemp.SetBGColor | (row, col, row, col, Color.Yellow) | 그리드 표시 설정 |  |  |  |
| AC-d1c60be0 | this.formDown.Click [try] | SCP0201_CAPA.cs:1989 | if (siExcelTemp.ActiveSheet.RowCount > 0) ▸ for (row < siExcelTemp.ActiveSheet.RowCount) ▸ if (sCategoryId == "Not-Available" \|\| sCategory… | GRID_STYLE | siExcelTemp.SetBGColor | (row, col, row, col, Color.Yellow) | 그리드 표시 설정 |  |  |  |
| AC-8c018c6f | this.formDown.Click [try] | SCP0201_CAPA.cs:1996 | if (siExcelTemp.ActiveSheet.RowCount > 0) ▸ for (row < siExcelTemp.ActiveSheet.RowCount) ▸ else of (sCategoryId == "Not-Available" \|\| sCat… | GRID_STYLE | siExcelTemp.SetBGColor | (row, startColIdx, row, lastRowIdx, Color.Yellow) | 그리드 표시 설정 |  |  |  |
| AC-b7b1099f | this.formDown.Click [try] | SCP0201_CAPA.cs:2000 | if (siExcelTemp.ActiveSheet.RowCount > 0) ▸ for (row < siExcelTemp.ActiveSheet.RowCount) ▸ else of (sCategoryId == "Not-Available" \|\| sCat… | FLAG | dtLaneQtyOfLineAssign | Data_SCP.Common(Data_SCP.Type.LaneQtyOfLineAssign, false) | 화면 필드/플래그 변경 |  |  |  |
| AC-983f7c4e | this.formDown.Click [try] | SCP0201_CAPA.cs:2000 | if (siExcelTemp.ActiveSheet.RowCount > 0) ▸ for (row < siExcelTemp.ActiveSheet.RowCount) ▸ else of (sCategoryId == "Not-Available" \|\| sCat… | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.LaneQtyOfLineAssign, false) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-78df427f | this.formDown.Click [try] | SCP0201_CAPA.cs:2002 | if (siExcelTemp.ActiveSheet.RowCount > 0) ▸ for (row < siExcelTemp.ActiveSheet.RowCount) ▸ else of (sCategoryId == "Not-Available" \|\| sCat… | DATA_OP | dtLaneQtyOfLineAssign.Select | ("DIVISION_ID = '" + sDivisionId + "' AND COMPANY_ID = '" + sCompanyId + "' AND SITE_ID = … | 데이터 객체 조작/조회 |  |  |  |
| AC-6eed6468 | this.formDown.Click [try] | SCP0201_CAPA.cs:2012 | if (siExcelTemp.ActiveSheet.RowCount > 0) ▸ for (row < siExcelTemp.ActiveSheet.RowCount) ▸ else of (sCategoryId == "Not-Available" \|\| sCat… | GRID_STYLE | siExcelTemp.SetBGColor | (row, siExcelTemp.GetColumnIndex(DefColumns.LANE_QTY), row, siExcelTemp.GetColumnIndex(Def… | 그리드 표시 설정 |  |  |  |
| AC-71afbe75 | this.formDown.Click [try] | SCP0201_CAPA.cs:2017 | if (siExcelTemp.ActiveSheet.RowCount > 0) ▸ for (row < siExcelTemp.ActiveSheet.RowCount) ▸ else of (sCategoryId == "Not-Available" \|\| sCat… | GRID_STYLE | siExcelTemp.SetBGColor | (row, startColIdx, row, siExcelTemp.ActiveSheet.ColumnCount - 1, Color.Yellow) | 그리드 표시 설정 |  |  |  |

## SCP0201_CAPA.RequestData

진입점: this.btnRequest.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d3285f2d | this.btnRequest.Click | SCP0201_CAPA.cs:1322 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-72ae2df5 | this.btnRequest.Click | SCP0201_CAPA.cs:1326 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-30be73f2 | this.btnRequest.Click | SCP0201_CAPA.cs:1367 | try ▸ if (iCount > 0) | ENDPOINT | new FoxDataRequest | ("SCP.SCP0049_SAVE_MAIL_SEND_REQUEST") ⇒ SCP.SCP0049_SAVE_MAIL_SEND_REQUEST | 엔드포인트 요청 생성 |  |  |  |
| AC-fbcff347 | this.btnRequest.Click | SCP0201_CAPA.cs:1371 | try ▸ if (iCount > 0) | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-43313a9a | this.btnRequest.Click | SCP0201_CAPA.cs:1372 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-c62b1df5 | this.btnRequest.Click | SCP0201_CAPA.cs:1373 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_company_id"] | p_company_id | 행/컬럼 값 대입 |  |  |  |
| AC-d62e91d6 | this.btnRequest.Click | SCP0201_CAPA.cs:1374 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_site_id"] | p_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-88b8d6b1 | this.btnRequest.Click | SCP0201_CAPA.cs:1375 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_plant_id"] | p_plant_id | 행/컬럼 값 대입 |  |  |  |
| AC-37929b4b | this.btnRequest.Click | SCP0201_CAPA.cs:1376 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_factory_id"] | p_factory_id | 행/컬럼 값 대입 |  |  |  |
| AC-40483a3a | this.btnRequest.Click | SCP0201_CAPA.cs:1377 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_line_id"] | p_line_id | 행/컬럼 값 대입 |  |  |  |
| AC-4ffbc117 | this.btnRequest.Click | SCP0201_CAPA.cs:1378 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_operation_id"] | p_operation_id | 행/컬럼 값 대입 |  |  |  |
| AC-e3faf656 | this.btnRequest.Click | SCP0201_CAPA.cs:1379 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_electrode_type"] | p_electrode_type | 행/컬럼 값 대입 |  |  |  |
| AC-78daf8ea | this.btnRequest.Click | SCP0201_CAPA.cs:1380 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-84db33e5 | this.btnRequest.Click | SCP0201_CAPA.cs:1381 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_lane_qty"] | p_lane_qty | 행/컬럼 값 대입 |  |  |  |
| AC-6ec30126 | this.btnRequest.Click | SCP0201_CAPA.cs:1382 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_loss_code"] | p_loss_code | 행/컬럼 값 대입 |  |  |  |
| AC-9737eafb | this.btnRequest.Click | SCP0201_CAPA.cs:1383 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_update_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-4d1b67da | this.btnRequest.Click | SCP0201_CAPA.cs:1385 | try ▸ if (iCount > 0) | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-2d1e4925 | this.btnRequest.Click | SCP0201_CAPA.cs:1390 | try ▸ if (iCount > 0) ▸ if (ds.Tables[0].Rows[0]["result_code"].ToString() == "S") | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-987f38dd | this.btnRequest.Click | SCP0201_CAPA.cs:1391 | try ▸ if (iCount > 0) ▸ if (ds.Tables[0].Rows[0]["result_code"].ToString() == "S") | MESSAGE | MessageHelper.GMessageBox | ("MSG00339", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-7d55f6f5 | this.btnRequest.Click | SCP0201_CAPA.cs:1395 | try ▸ if (iCount > 0) ▸ else of (ds.Tables[0].Rows[0]["result_code"].ToString() == "S") | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-268bfc7e | this.btnRequest.Click | SCP0201_CAPA.cs:1396 | try ▸ if (iCount > 0) ▸ else of (ds.Tables[0].Rows[0]["result_code"].ToString() == "S") | MESSAGE | MessageHelper.GMessageBox | ("MSG00284", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a729d2d3 | this.btnRequest.Click | SCP0201_CAPA.cs:1401 | try ▸ else of (iCount > 0) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-a329e0aa | this.btnRequest.Click | SCP0201_CAPA.cs:1402 | try ▸ else of (iCount > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00021", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-209933c5 | this.btnRequest.Click | SCP0201_CAPA.cs:1407 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00284", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-396dd629 | this.btnRequest.Click | SCP0201_CAPA.cs:1411 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0201_CAPA.SaveButton

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-aa493bdb | SaveButton | SCP0201_CAPA.cs:799 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0201_CAPA.SaveData_Main

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-19f8089d | SaveButton | SCP0201_CAPA.cs:979 | if (siMain.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-09b02a8f | SaveButton | SCP0201_CAPA.cs:981 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-86862998 | SaveButton | SCP0201_CAPA.cs:985 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-128d0619 | SaveButton | SCP0201_CAPA.cs:987 | try | VALIDATE | DataUtil.checkRequiredOfSpread | (siMain) | 프레임워크 검증 |  |  |  |
| AC-6e16791c | SaveButton | SCP0201_CAPA.cs:987 | try ▸ if (!DataUtil.checkRequiredOfSpread(siMain)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e935870a | SaveButton | SCP0201_CAPA.cs:1012 | try | DATA_OP | dtInput.Columns.Add | ("p_division_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-bddc5771 | SaveButton | SCP0201_CAPA.cs:1013 | try | DATA_OP | dtInput.Columns.Add | ("p_company_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-0e84118a | SaveButton | SCP0201_CAPA.cs:1014 | try | DATA_OP | dtInput.Columns.Add | ("p_site_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-7ac10f9b | SaveButton | SCP0201_CAPA.cs:1015 | try | DATA_OP | dtInput.Columns.Add | ("p_plant_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-cdcf659e | SaveButton | SCP0201_CAPA.cs:1016 | try | DATA_OP | dtInput.Columns.Add | ("p_factory_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-3dc8c870 | SaveButton | SCP0201_CAPA.cs:1017 | try | DATA_OP | dtInput.Columns.Add | ("p_line_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-8a65bcf6 | SaveButton | SCP0201_CAPA.cs:1018 | try | DATA_OP | dtInput.Columns.Add | ("p_operation_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-83d61219 | SaveButton | SCP0201_CAPA.cs:1019 | try | DATA_OP | dtInput.Columns.Add | ("p_electrode_type") | 데이터 객체 조작/조회 |  |  |  |
| AC-ca18bb53 | SaveButton | SCP0201_CAPA.cs:1020 | try | DATA_OP | dtInput.Columns.Add | ("p_item_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-dc1e0681 | SaveButton | SCP0201_CAPA.cs:1021 | try | DATA_OP | dtInput.Columns.Add | ("p_loss_code") | 데이터 객체 조작/조회 |  |  |  |
| AC-073e418c | SaveButton | SCP0201_CAPA.cs:1022 | try | DATA_OP | dtInput.Columns.Add | ("p_data_table") | 데이터 객체 조작/조회 |  |  |  |
| AC-4ac4ced8 | SaveButton | SCP0201_CAPA.cs:1023 | try | DATA_OP | dtInput.Columns.Add | ("p_data_type") | 데이터 객체 조작/조회 |  |  |  |
| AC-6550aae2 | SaveButton | SCP0201_CAPA.cs:1024 | try | DATA_OP | dtInput.Columns.Add | ("p_day_name") | 데이터 객체 조작/조회 |  |  |  |
| AC-d225900d | SaveButton | SCP0201_CAPA.cs:1025 | try | DATA_OP | dtInput.Columns.Add | ("p_day_qty") | 데이터 객체 조작/조회 |  |  |  |
| AC-7bcee580 | SaveButton | SCP0201_CAPA.cs:1026 | try | DATA_OP | dtInput.Columns.Add | ("p_lane_qty") | 데이터 객체 조작/조회 |  |  |  |
| AC-fd098a12 | SaveButton | SCP0201_CAPA.cs:1027 | try | DATA_OP | dtInput.Columns.Add | ("p_confirm_flag") | 데이터 객체 조작/조회 |  |  |  |
| AC-50ca4e21 | SaveButton | SCP0201_CAPA.cs:1028 | try | DATA_OP | dtInput.Columns.Add | ("p_update_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-a653c3ff | SaveButton | SCP0201_CAPA.cs:1029 | try | DATA_OP | dsInput.Tables.Add | (dtInput) | 데이터 객체 조작/조회 |  |  |  |
| AC-a13ee267 | SaveButton | SCP0201_CAPA.cs:1056 | try ▸ for (row <= siMain.ActiveSheet.RowCount - 1) ▸ for (col < siMain.ActiveSheet.ColumnCount) ▸ if ("E2000" == sOperationId && "LANE_QTY" … | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-423d0e09 | SaveButton | SCP0201_CAPA.cs:1057 | try ▸ for (row <= siMain.ActiveSheet.RowCount - 1) ▸ for (col < siMain.ActiveSheet.ColumnCount) ▸ if ("E2000" == sOperationId && "LANE_QTY" … | MESSAGE | MessageHelper.GMessageBox | ("MSG00337", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d58337af | SaveButton | SCP0201_CAPA.cs:1058 | try ▸ for (row <= siMain.ActiveSheet.RowCount - 1) ▸ for (col < siMain.ActiveSheet.ColumnCount) ▸ if ("E2000" == sOperationId && "LANE_QTY" … | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-fea3cf63 | SaveButton | SCP0201_CAPA.cs:1083 | try ▸ for (row <= siMain.ActiveSheet.RowCount - 1) ▸ for (col < siMain.ActiveSheet.ColumnCount) ▸ if ("SCM_ITEM_LINE_ASSIGN_M" == siMain.Get… | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-fff3fed8 | SaveButton | SCP0201_CAPA.cs:1084 | try ▸ for (row <= siMain.ActiveSheet.RowCount - 1) ▸ for (col < siMain.ActiveSheet.ColumnCount) ▸ if ("SCM_ITEM_LINE_ASSIGN_M" == siMain.Get… | MESSAGE | MessageHelper.GMessageBox | ("MSG00203", new object[] { 1, 9 }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-21ea60d2 | SaveButton | SCP0201_CAPA.cs:1086 | try ▸ for (row <= siMain.ActiveSheet.RowCount - 1) ▸ for (col < siMain.ActiveSheet.ColumnCount) ▸ if ("SCM_ITEM_LINE_ASSIGN_M" == siMain.Get… | GRID_STYLE | siMain.ActiveSheet.SetActiveCell | (row, col) | 그리드 표시 설정 |  |  |  |
| AC-3d787964 | SaveButton | SCP0201_CAPA.cs:1087 | try ▸ for (row <= siMain.ActiveSheet.RowCount - 1) ▸ for (col < siMain.ActiveSheet.ColumnCount) ▸ if ("SCM_ITEM_LINE_ASSIGN_M" == siMain.Get… | GRID_STYLE | siMain.SpreadObject.SetViewportTopRow | (0, row) | 그리드 표시 설정 |  |  |  |
| AC-ce7504d8 | SaveButton | SCP0201_CAPA.cs:1088 | try ▸ for (row <= siMain.ActiveSheet.RowCount - 1) ▸ for (col < siMain.ActiveSheet.ColumnCount) ▸ if ("SCM_ITEM_LINE_ASSIGN_M" == siMain.Get… | GRID_STYLE | siMain.SpreadObject.SetViewportLeftColumn | (0, col) | 그리드 표시 설정 |  |  |  |
| AC-a1cd1e10 | SaveButton | SCP0201_CAPA.cs:1089 | try ▸ for (row <= siMain.ActiveSheet.RowCount - 1) ▸ for (col < siMain.ActiveSheet.ColumnCount) ▸ if ("SCM_ITEM_LINE_ASSIGN_M" == siMain.Get… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f3566f71 | SaveButton | SCP0201_CAPA.cs:1094 | try ▸ for (row <= siMain.ActiveSheet.RowCount - 1) ▸ for (col < siMain.ActiveSheet.ColumnCount) ▸ if ("SCM_ITEM_LINE_ASSIGN_M" == siMain.Get… | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-7d9d1780 | SaveButton | SCP0201_CAPA.cs:1095 | try ▸ for (row <= siMain.ActiveSheet.RowCount - 1) ▸ for (col < siMain.ActiveSheet.ColumnCount) ▸ if ("SCM_ITEM_LINE_ASSIGN_M" == siMain.Get… | MESSAGE | MessageHelper.GMessageBox | ("MSG00107", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b07b7139 | SaveButton | SCP0201_CAPA.cs:1097 | try ▸ for (row <= siMain.ActiveSheet.RowCount - 1) ▸ for (col < siMain.ActiveSheet.ColumnCount) ▸ if ("SCM_ITEM_LINE_ASSIGN_M" == siMain.Get… | GRID_STYLE | siMain.ActiveSheet.SetActiveCell | (row, col) | 그리드 표시 설정 |  |  |  |
| AC-cf5e36da | SaveButton | SCP0201_CAPA.cs:1098 | try ▸ for (row <= siMain.ActiveSheet.RowCount - 1) ▸ for (col < siMain.ActiveSheet.ColumnCount) ▸ if ("SCM_ITEM_LINE_ASSIGN_M" == siMain.Get… | GRID_STYLE | siMain.SpreadObject.SetViewportTopRow | (0, row) | 그리드 표시 설정 |  |  |  |
| AC-0873a0e0 | SaveButton | SCP0201_CAPA.cs:1099 | try ▸ for (row <= siMain.ActiveSheet.RowCount - 1) ▸ for (col < siMain.ActiveSheet.ColumnCount) ▸ if ("SCM_ITEM_LINE_ASSIGN_M" == siMain.Get… | GRID_STYLE | siMain.SpreadObject.SetViewportLeftColumn | (0, col) | 그리드 표시 설정 |  |  |  |
| AC-1f83d5c4 | SaveButton | SCP0201_CAPA.cs:1100 | try ▸ for (row <= siMain.ActiveSheet.RowCount - 1) ▸ for (col < siMain.ActiveSheet.ColumnCount) ▸ if ("SCM_ITEM_LINE_ASSIGN_M" == siMain.Get… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-20e45ded | SaveButton | SCP0201_CAPA.cs:1111 | try ▸ for (row <= siMain.ActiveSheet.RowCount - 1) ▸ for (col < siMain.ActiveSheet.ColumnCount) ▸ if ("SCM_ITEM_LINE_ASSIGN_M" == siMain.Get… | DATA_OP | dtLaneQtyOfLineAssign.Select | ("DIVISION_ID = '" + sDivisionId + "' AND COMPANY_ID = '" + sCompanyId + "' AND SITE_ID = … | 데이터 객체 조작/조회 |  |  |  |
| AC-9d07b74c | SaveButton | SCP0201_CAPA.cs:1122 | try ▸ for (row <= siMain.ActiveSheet.RowCount - 1) ▸ for (col < siMain.ActiveSheet.ColumnCount) ▸ if ("SCM_ITEM_LINE_ASSIGN_M" == siMain.Get… | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-9c90b5f1 | SaveButton | SCP0201_CAPA.cs:1123 | try ▸ for (row <= siMain.ActiveSheet.RowCount - 1) ▸ for (col < siMain.ActiveSheet.ColumnCount) ▸ if ("SCM_ITEM_LINE_ASSIGN_M" == siMain.Get… | MESSAGE | MessageHelper.GMessageBox | ("MSG00337", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-1e1ad909 | SaveButton | SCP0201_CAPA.cs:1124 | try ▸ for (row <= siMain.ActiveSheet.RowCount - 1) ▸ for (col < siMain.ActiveSheet.ColumnCount) ▸ if ("SCM_ITEM_LINE_ASSIGN_M" == siMain.Get… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a6337675 | SaveButton | SCP0201_CAPA.cs:1134 | try ▸ for (row <= siMain.ActiveSheet.RowCount - 1) ▸ for (col < siMain.ActiveSheet.ColumnCount) ▸ if ("LA003".Equals(sLossCode)) ▸ if (0 > C… | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-ba1dcf8a | SaveButton | SCP0201_CAPA.cs:1135 | try ▸ for (row <= siMain.ActiveSheet.RowCount - 1) ▸ for (col < siMain.ActiveSheet.ColumnCount) ▸ if ("LA003".Equals(sLossCode)) ▸ if (0 > C… | MESSAGE | MessageHelper.GMessageBox | ("MSG00085", new object[] { "Yield : 0" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-aa49a41f | SaveButton | SCP0201_CAPA.cs:1137 | try ▸ for (row <= siMain.ActiveSheet.RowCount - 1) ▸ for (col < siMain.ActiveSheet.ColumnCount) ▸ if ("LA003".Equals(sLossCode)) ▸ if (0 > C… | GRID_STYLE | siMain.ActiveSheet.SetActiveCell | (row, col) | 그리드 표시 설정 |  |  |  |
| AC-2121fed5 | SaveButton | SCP0201_CAPA.cs:1138 | try ▸ for (row <= siMain.ActiveSheet.RowCount - 1) ▸ for (col < siMain.ActiveSheet.ColumnCount) ▸ if ("LA003".Equals(sLossCode)) ▸ if (0 > C… | GRID_STYLE | siMain.SpreadObject.SetViewportTopRow | (0, row) | 그리드 표시 설정 |  |  |  |
| AC-c49519f8 | SaveButton | SCP0201_CAPA.cs:1139 | try ▸ for (row <= siMain.ActiveSheet.RowCount - 1) ▸ for (col < siMain.ActiveSheet.ColumnCount) ▸ if ("LA003".Equals(sLossCode)) ▸ if (0 > C… | GRID_STYLE | siMain.SpreadObject.SetViewportLeftColumn | (0, col) | 그리드 표시 설정 |  |  |  |
| AC-f890df34 | SaveButton | SCP0201_CAPA.cs:1140 | try ▸ for (row <= siMain.ActiveSheet.RowCount - 1) ▸ for (col < siMain.ActiveSheet.ColumnCount) ▸ if ("LA003".Equals(sLossCode)) ▸ if (0 > C… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-35a2aacf | SaveButton | SCP0201_CAPA.cs:1144 | try ▸ for (row <= siMain.ActiveSheet.RowCount - 1) ▸ for (col < siMain.ActiveSheet.ColumnCount) ▸ if ("LA003".Equals(sLossCode)) ▸ if (100 <… | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-c56667f1 | SaveButton | SCP0201_CAPA.cs:1145 | try ▸ for (row <= siMain.ActiveSheet.RowCount - 1) ▸ for (col < siMain.ActiveSheet.ColumnCount) ▸ if ("LA003".Equals(sLossCode)) ▸ if (100 <… | MESSAGE | MessageHelper.GMessageBox | ("MSG00072", new object[] { "Yield : 100" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f7980cc1 | SaveButton | SCP0201_CAPA.cs:1147 | try ▸ for (row <= siMain.ActiveSheet.RowCount - 1) ▸ for (col < siMain.ActiveSheet.ColumnCount) ▸ if ("LA003".Equals(sLossCode)) ▸ if (100 <… | GRID_STYLE | siMain.ActiveSheet.SetActiveCell | (row, col) | 그리드 표시 설정 |  |  |  |
| AC-e85c979d | SaveButton | SCP0201_CAPA.cs:1148 | try ▸ for (row <= siMain.ActiveSheet.RowCount - 1) ▸ for (col < siMain.ActiveSheet.ColumnCount) ▸ if ("LA003".Equals(sLossCode)) ▸ if (100 <… | GRID_STYLE | siMain.SpreadObject.SetViewportTopRow | (0, row) | 그리드 표시 설정 |  |  |  |
| AC-44ac9eee | SaveButton | SCP0201_CAPA.cs:1149 | try ▸ for (row <= siMain.ActiveSheet.RowCount - 1) ▸ for (col < siMain.ActiveSheet.ColumnCount) ▸ if ("LA003".Equals(sLossCode)) ▸ if (100 <… | GRID_STYLE | siMain.SpreadObject.SetViewportLeftColumn | (0, col) | 그리드 표시 설정 |  |  |  |
| AC-07afcc34 | SaveButton | SCP0201_CAPA.cs:1150 | try ▸ for (row <= siMain.ActiveSheet.RowCount - 1) ▸ for (col < siMain.ActiveSheet.ColumnCount) ▸ if ("LA003".Equals(sLossCode)) ▸ if (100 <… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b6312cc7 | SaveButton | SCP0201_CAPA.cs:1155 | try ▸ for (row <= siMain.ActiveSheet.RowCount - 1) ▸ for (col < siMain.ActiveSheet.ColumnCount) | DATA_OP | arrayChangeRowCol.Add | (changeRowCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-af8e31ce | SaveButton | SCP0201_CAPA.cs:1198 | try ▸ for (row <= siMain.ActiveSheet.RowCount - 1) ▸ for (col < siMain.ActiveSheet.ColumnCount) | DATA_OP | dsInput.Tables[0].NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-63ed1404 | SaveButton | SCP0201_CAPA.cs:1199 | try ▸ for (row <= siMain.ActiveSheet.RowCount - 1) ▸ for (col < siMain.ActiveSheet.ColumnCount) | DATA_OP | dRow["p_division_id"] | siMain.GetValue(row, siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | 행/컬럼 값 대입 |  |  |  |
| AC-2281e221 | SaveButton | SCP0201_CAPA.cs:1200 | try ▸ for (row <= siMain.ActiveSheet.RowCount - 1) ▸ for (col < siMain.ActiveSheet.ColumnCount) | DATA_OP | dRow["p_company_id"] | siMain.GetValue(row, siMain.GetColumnIndex(DefColumns.COMPANY_ID)) | 행/컬럼 값 대입 |  |  |  |
| AC-b826dafa | SaveButton | SCP0201_CAPA.cs:1201 | try ▸ for (row <= siMain.ActiveSheet.RowCount - 1) ▸ for (col < siMain.ActiveSheet.ColumnCount) | DATA_OP | dRow["p_site_id"] | siMain.GetValue(row, siMain.GetColumnIndex(DefColumns.SITE_ID)) | 행/컬럼 값 대입 |  |  |  |
| AC-62ab1c72 | SaveButton | SCP0201_CAPA.cs:1202 | try ▸ for (row <= siMain.ActiveSheet.RowCount - 1) ▸ for (col < siMain.ActiveSheet.ColumnCount) | DATA_OP | dRow["p_plant_id"] | siMain.GetValue(row, siMain.GetColumnIndex(DefColumns.PLANT_ID)) | 행/컬럼 값 대입 |  |  |  |
| AC-12c8b135 | SaveButton | SCP0201_CAPA.cs:1203 | try ▸ for (row <= siMain.ActiveSheet.RowCount - 1) ▸ for (col < siMain.ActiveSheet.ColumnCount) | DATA_OP | dRow["p_factory_id"] | siMain.GetValue(row, siMain.GetColumnIndex(DefColumns.FACTORY_ID)) | 행/컬럼 값 대입 |  |  |  |
| AC-8ae8b1c4 | SaveButton | SCP0201_CAPA.cs:1204 | try ▸ for (row <= siMain.ActiveSheet.RowCount - 1) ▸ for (col < siMain.ActiveSheet.ColumnCount) | DATA_OP | dRow["p_line_id"] | siMain.GetValue(row, siMain.GetColumnIndex(DefColumns.LINE_ID)) | 행/컬럼 값 대입 |  |  |  |
| AC-0254e8e0 | SaveButton | SCP0201_CAPA.cs:1205 | try ▸ for (row <= siMain.ActiveSheet.RowCount - 1) ▸ for (col < siMain.ActiveSheet.ColumnCount) | DATA_OP | dRow["p_operation_id"] | siMain.GetValue(row, siMain.GetColumnIndex(DefColumns.OPERATION_ID)) | 행/컬럼 값 대입 |  |  |  |
| AC-6a783ed6 | SaveButton | SCP0201_CAPA.cs:1206 | try ▸ for (row <= siMain.ActiveSheet.RowCount - 1) ▸ for (col < siMain.ActiveSheet.ColumnCount) | DATA_OP | dRow["p_electrode_type"] | siMain.GetValue(row, siMain.GetColumnIndex(DefColumns.ELECTRODE_TYPE)) | 행/컬럼 값 대입 |  |  |  |
| AC-d5d142bf | SaveButton | SCP0201_CAPA.cs:1207 | try ▸ for (row <= siMain.ActiveSheet.RowCount - 1) ▸ for (col < siMain.ActiveSheet.ColumnCount) | DATA_OP | dRow["p_item_id"] | siMain.GetValue(row, siMain.GetColumnIndex(DefColumns.ITEM_ID)) | 행/컬럼 값 대입 |  |  |  |
| AC-2010a38d | SaveButton | SCP0201_CAPA.cs:1208 | try ▸ for (row <= siMain.ActiveSheet.RowCount - 1) ▸ for (col < siMain.ActiveSheet.ColumnCount) | DATA_OP | dRow["p_loss_code"] | siMain.GetValue(row, siMain.GetColumnIndex(DefColumns.LOSS_CODE)) | 행/컬럼 값 대입 |  |  |  |
| AC-bdce170b | SaveButton | SCP0201_CAPA.cs:1209 | try ▸ for (row <= siMain.ActiveSheet.RowCount - 1) ▸ for (col < siMain.ActiveSheet.ColumnCount) | DATA_OP | dRow["p_data_table"] | sDataTable | 행/컬럼 값 대입 |  |  |  |
| AC-f7c4c5de | SaveButton | SCP0201_CAPA.cs:1210 | try ▸ for (row <= siMain.ActiveSheet.RowCount - 1) ▸ for (col < siMain.ActiveSheet.ColumnCount) | DATA_OP | dRow["p_data_type"] | sDataType | 행/컬럼 값 대입 |  |  |  |
| AC-1cdca4f8 | SaveButton | SCP0201_CAPA.cs:1211 | try ▸ for (row <= siMain.ActiveSheet.RowCount - 1) ▸ for (col < siMain.ActiveSheet.ColumnCount) | DATA_OP | dRow["p_day_name"] | strDayName | 행/컬럼 값 대입 |  |  |  |
| AC-dd3b0696 | SaveButton | SCP0201_CAPA.cs:1212 | try ▸ for (row <= siMain.ActiveSheet.RowCount - 1) ▸ for (col < siMain.ActiveSheet.ColumnCount) | DATA_OP | dRow["p_day_qty"] | strDayQty | 행/컬럼 값 대입 |  |  |  |
| AC-d67bd25b | SaveButton | SCP0201_CAPA.cs:1213 | try ▸ for (row <= siMain.ActiveSheet.RowCount - 1) ▸ for (col < siMain.ActiveSheet.ColumnCount) | DATA_OP | dRow["p_lane_qty"] | siMain.GetValue(row, siMain.GetColumnIndex(DefColumns.LANE_QTY)) | 행/컬럼 값 대입 |  |  |  |
| AC-7ca65097 | SaveButton | SCP0201_CAPA.cs:1214 | try ▸ for (row <= siMain.ActiveSheet.RowCount - 1) ▸ for (col < siMain.ActiveSheet.ColumnCount) | DATA_OP | dRow["p_confirm_flag"] | sConfrimflag | 행/컬럼 값 대입 |  |  |  |
| AC-65c0166c | SaveButton | SCP0201_CAPA.cs:1215 | try ▸ for (row <= siMain.ActiveSheet.RowCount - 1) ▸ for (col < siMain.ActiveSheet.ColumnCount) | DATA_OP | dRow["p_update_id"] | UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-b56170cb | SaveButton | SCP0201_CAPA.cs:1217 | try ▸ for (row <= siMain.ActiveSheet.RowCount - 1) ▸ for (col < siMain.ActiveSheet.ColumnCount) | DATA_OP | dsInput.Tables[0].Rows.Add | (dRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-38dcda0f | SaveButton | SCP0201_CAPA.cs:1226 | try ▸ if (iCount > 0) | DATA_OP | dsInput.Tables[0].AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-fa407b26 | SaveButton | SCP0201_CAPA.cs:1240 | try ▸ if (iCount > 0) ▸ try | CALL_EXT | sql.AddParameter | (SqlDbType.Structured, "@SCP0049", dsInput.Tables[0]) | ⚠ 의미 확인 필요 |  |  |  |
| AC-20a7d51c | SaveButton | SCP0201_CAPA.cs:1241 | try ▸ if (iCount > 0) ▸ try | ENDPOINT | sql.ExcuteProcedure | ("dbo.SCP0049_SAVE_CAPA") ⇒ biz:AppService.GeneralRunProcedureCustomTable [procedure=dbo.SCP0049_SAVE_CAPA] … | 엔드포인트 호출 |  |  |  |
| AC-efc2b7b3 | SaveButton | SCP0201_CAPA.cs:1244 | try ▸ if (iCount > 0) ▸ try | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-c8004b16 | SaveButton | SCP0201_CAPA.cs:1249 | try ▸ if (iCount > 0) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Equals("S")) | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { result.Rows[0]["result_cnt"].ToString() }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ab4882d6 | SaveButton | SCP0201_CAPA.cs:1259 | try ▸ if (iCount > 0) ▸ try ▸ else of (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Equals("S")) ▸ if… | MESSAGE | MessageHelper.GMessageBox | ("MSG00003", new object[] { ReErrorMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3e5dcb24 | SaveButton | SCP0201_CAPA.cs:1268 | try ▸ if (iCount > 0) ▸ catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-f4c2895e | SaveButton | SCP0201_CAPA.cs:1269 | try ▸ if (iCount > 0) ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-721f1162 | SaveButton | SCP0201_CAPA.cs:1275 | try ▸ if (iCount > 0) ▸ finally ▸ if (!prgCloseF) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-5cd50bdf | SaveButton | SCP0201_CAPA.cs:1282 | try ▸ else of (iCount > 0) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-606a2fcc | SaveButton | SCP0201_CAPA.cs:1283 | try ▸ else of (iCount > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00133", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8836c973 | SaveButton | SCP0201_CAPA.cs:1291 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0201_CAPA.SCM_SYS_LOG_BATCH

진입점: SaveButton [try ▸ if (iCount > 0) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4bd4b0f0 | SaveButton [try ▸ if (iCount > 0) ▸ try] | SCP0201_CAPA.cs:1303 | try | ENDPOINT | new FoxDataRequest | ("SCP.PR_SCM_SYS_LOG_BATCH") ⇒ SCP.PR_SCM_SYS_LOG_BATCH | 엔드포인트 요청 생성 |  |  |  |
| AC-2edd2843 | SaveButton [try ▸ if (iCount > 0) ▸ try] | SCP0201_CAPA.cs:1304 | try | DATA_OP | request.Parameters["p_program_name"] | p_program_name | 행/컬럼 값 대입 |  |  |  |
| AC-be458768 | SaveButton [try ▸ if (iCount > 0) ▸ try] | SCP0201_CAPA.cs:1305 | try | DATA_OP | request.Parameters["p_log_type"] | p_log_type | 행/컬럼 값 대입 |  |  |  |
| AC-887ace82 | SaveButton [try ▸ if (iCount > 0) ▸ try] | SCP0201_CAPA.cs:1306 | try | DATA_OP | request.Parameters["p_log_count"] | p_log_count | 행/컬럼 값 대입 |  |  |  |
| AC-70fb53ef | SaveButton [try ▸ if (iCount > 0) ▸ try] | SCP0201_CAPA.cs:1307 | try | DATA_OP | request.Parameters["p_log_message"] | p_log_message | 행/컬럼 값 대입 |  |  |  |
| AC-ad6cd9f4 | SaveButton [try ▸ if (iCount > 0) ▸ try] | SCP0201_CAPA.cs:1308 | try | DATA_OP | request.Parameters["p_description"] | p_description | 행/컬럼 값 대입 |  |  |  |
| AC-dacc3bda | SaveButton [try ▸ if (iCount > 0) ▸ try] | SCP0201_CAPA.cs:1309 | try | DATA_OP | request.Parameters["p_event_date"] | DateTime.Now | 행/컬럼 값 대입 |  |  |  |
| AC-9a68ecf6 | SaveButton [try ▸ if (iCount > 0) ▸ try] | SCP0201_CAPA.cs:1311 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## SCP0201_CAPA.Set_Calculator

진입점: dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (DefColumns.REQUEST_CHK == sColName) ▸ if (DefColumns.CONFIRM_FLAG != sColName && DefColumns.LANE_QTY != sColName && DefColumnsDataTable.SCM_WORK_CALENDAR_M != sDa…) ▸ if (sAction == CAppSetting.StringM && e.Column > 0)] / txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter) ▸ try] / txtMaterialId.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter) ▸ try] / txtNickName.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter) ▸ try] / this.btnExcelUpload.Click […

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-20efbb12 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 5 | SCP0201_CAPA.cs:1626 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (col <= lastColIdx) ▸ for (row <= lastRowIdx) | DATA_OP | sColumnTag.Contains | ("BEST_") | 데이터 객체 조작/조회 |  |  |  |
| AC-582d9dd0 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 5 | SCP0201_CAPA.cs:1626 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (col <= lastColIdx) ▸ for (row <= lastRowIdx) | DATA_OP | sColumnTag.Contains | ("WORST_") | 데이터 객체 조작/조회 |  |  |  |
| AC-3982dbf6 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 5 | SCP0201_CAPA.cs:1667 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (col <= lastColIdx) ▸ for (row <= lastRowIdx) | DATA_OP | arrayNonOperation.Contains | (sLossCode) | 데이터 객체 조작/조회 |  |  |  |
| AC-f8b2f353 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 5 | SCP0201_CAPA.cs:1671 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (col <= lastColIdx) ▸ for (row <= lastRowIdx) ▸ else of (arrayNonOperation.Contains(sLossCode)) | DATA_OP | arrayNoLoad.Contains | (sLossCode) | 데이터 객체 조작/조회 |  |  |  |
| AC-087cfa88 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 5 | SCP0201_CAPA.cs:1675 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (col <= lastColIdx) ▸ for (row <= lastRowIdx) ▸ else of (arrayNonOperation.Contains(sLossCode)) ▸… | DATA_OP | arrayNoRunNotPM.Contains | (sLossCode) | 데이터 객체 조작/조회 |  |  |  |
| AC-7bf9dd8a | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 5 | SCP0201_CAPA.cs:1699 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (col <= lastColIdx) ▸ for (row <= lastRowIdx) ▸ if (DefColumnsLossCode.XB020 == sLossCode) | GRID_SET | siMain.SetValue | (row, col, dXB020) | 그리드 값 설정 |  |  |  |
| AC-5ad1bda7 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 5 | SCP0201_CAPA.cs:1706 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (col <= lastColIdx) ▸ for (row <= lastRowIdx) ▸ else of (DefColumnsLossCode.XB020 == sLossCode) ▸… | GRID_SET | siMain.SetValue | (row, col, xx) | 그리드 값 설정 |  |  |  |
| AC-c90504ed | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 5 | SCP0201_CAPA.cs:1711 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (col <= lastColIdx) ▸ for (row <= lastRowIdx) ▸ else of (DefColumnsLossCode.XB020 == sLossCode) ▸… | GRID_SET | siMain.SetValue | (row, col, dLoadTime) | 그리드 값 설정 |  |  |  |
| AC-f004f996 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 5 | SCP0201_CAPA.cs:1719 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (col <= lastColIdx) ▸ for (row <= lastRowIdx) ▸ else of (DefColumnsLossCode.XB020 == sLossCode) ▸… | GRID_SET | siMain.SetValue | (row, col, xx) | 그리드 값 설정 |  |  |  |
| AC-6d7ed03b | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 5 | SCP0201_CAPA.cs:1724 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (col <= lastColIdx) ▸ for (row <= lastRowIdx) ▸ else of (DefColumnsLossCode.XB020 == sLossCode) ▸… | GRID_SET | siMain.SetValue | (row, col, dXE500) | 그리드 값 설정 |  |  |  |
| AC-3e03f1d5 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 5 | SCP0201_CAPA.cs:1731 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (col <= lastColIdx) ▸ for (row <= lastRowIdx) ▸ else of (DefColumnsLossCode.XB020 == sLossCode) ▸… | GRID_SET | siMain.SetValue | (row, col, dXE501) | 그리드 값 설정 |  |  |  |
| AC-266fb592 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 5 | SCP0201_CAPA.cs:1739 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (col <= lastColIdx) ▸ for (row <= lastRowIdx) ▸ else of (DefColumnsLossCode.XB020 == sLossCode) ▸… | GRID_SET | siMain.SetValue | (row, col, dM08) | 그리드 값 설정 |  |  |  |
| AC-bea9cdb9 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 5 | SCP0201_CAPA.cs:1745 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (col <= lastColIdx) ▸ for (row <= lastRowIdx) ▸ else of (DefColumnsLossCode.XB020 == sLossCode) ▸… | GRID_SET | siMain.SetValue | (row, col, xx) | 그리드 값 설정 |  |  |  |

## SCP0201_CAPA.Set_CalculatorBestWorst

진입점: txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter) ▸ try] / txtMaterialId.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter) ▸ try] / txtNickName.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter) ▸ try] / this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MSG00265") == DialogResult.Yes) ▸ try] / FindButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d916381b | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 4 | SCP0201_CAPA.cs:1759 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (row <= lastRowIdx) | DATA_OP | arrayCalLoss.Contains | (sLossCode) | 데이터 객체 조작/조회 |  |  |  |
| AC-e158c542 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 4 | SCP0201_CAPA.cs:1763 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (row <= lastRowIdx) | DATA_OP | dtTempValue.Columns.Add | ("Value", typeof(double)) | 데이터 객체 조작/조회 |  |  |  |
| AC-b8853f17 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 4 | SCP0201_CAPA.cs:1765 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (row <= lastRowIdx) | DATA_OP | dtTempResultValue.Columns.Add | ("Value", typeof(double)) | 데이터 객체 조작/조회 |  |  |  |
| AC-6ccd7916 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 4 | SCP0201_CAPA.cs:1783 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (row <= lastRowIdx) ▸ for (col <= lastColIdx) ▸ if (sColumnTag == DefColumns.BEF_BEST \|\| sColum… | DATA_OP | dtTempValue.AsEnumerable().Select | (a => a.Field<double>("value")) | 데이터 객체 조작/조회 |  |  |  |
| AC-a61e668b | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 4 | SCP0201_CAPA.cs:1783 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (row <= lastRowIdx) ▸ for (col <= lastColIdx) ▸ if (sColumnTag == DefColumns.BEF_BEST \|\| sColum… | DATA_OP | a.Field | ("value") | 데이터 객체 조작/조회 |  |  |  |
| AC-57a3a070 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 4 | SCP0201_CAPA.cs:1787 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (row <= lastRowIdx) ▸ for (col <= lastColIdx) ▸ if (sColumnTag == DefColumns.BEF_BEST \|\| sColum… | DATA_OP | dtTempValue.AsEnumerable().Select | (a => a.Field<double>("value")) | 데이터 객체 조작/조회 |  |  |  |
| AC-5369f22a | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 4 | SCP0201_CAPA.cs:1787 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (row <= lastRowIdx) ▸ for (col <= lastColIdx) ▸ if (sColumnTag == DefColumns.BEF_BEST \|\| sColum… | DATA_OP | a.Field | ("value") | 데이터 객체 조작/조회 |  |  |  |
| AC-6539c96f | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 4 | SCP0201_CAPA.cs:1795 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (row <= lastRowIdx) ▸ for (col <= lastColIdx) ▸ if (sColumnTag == DefColumns.BEF_BEST \|\| sColum… | DATA_OP | dtTempResultValue.AsEnumerable().Select | (a => a.Field<double>("value")) | 데이터 객체 조작/조회 |  |  |  |
| AC-b66ba42c | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 4 | SCP0201_CAPA.cs:1795 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (row <= lastRowIdx) ▸ for (col <= lastColIdx) ▸ if (sColumnTag == DefColumns.BEF_BEST \|\| sColum… | DATA_OP | a.Field | ("value") | 데이터 객체 조작/조회 |  |  |  |
| AC-25af6162 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 4 | SCP0201_CAPA.cs:1799 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (row <= lastRowIdx) ▸ for (col <= lastColIdx) ▸ if (sColumnTag == DefColumns.BEF_BEST \|\| sColum… | DATA_OP | dtTempResultValue.AsEnumerable().Select | (a => a.Field<double>("value")) | 데이터 객체 조작/조회 |  |  |  |
| AC-5d55b046 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 4 | SCP0201_CAPA.cs:1799 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (row <= lastRowIdx) ▸ for (col <= lastColIdx) ▸ if (sColumnTag == DefColumns.BEF_BEST \|\| sColum… | DATA_OP | a.Field | ("value") | 데이터 객체 조작/조회 |  |  |  |
| AC-a761ab0b | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 4 | SCP0201_CAPA.cs:1803 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (row <= lastRowIdx) ▸ for (col <= lastColIdx) ▸ if (sColumnTag == DefColumns.BEF_BEST \|\| sColum… | GRID_SET | siMain.SetValue | (row, col, value) | 그리드 값 설정 |  |  |  |
| AC-805e2cf1 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 4 | SCP0201_CAPA.cs:1807 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (row <= lastRowIdx) ▸ for (col <= lastColIdx) ▸ else of (sColumnTag == DefColumns.BEF_BEST \|\| s… | CALL_EXT | siMain.GetColumnText | (0, col) | ⚠ 의미 확인 필요 |  |  |  |
| AC-0fef8751 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 4 | SCP0201_CAPA.cs:1814 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (row <= lastRowIdx) ▸ for (col <= lastColIdx) ▸ else of (sColumnTag == DefColumns.BEF_BEST \|\| s… | DATA_OP | sColumnTag.Contains | ("RESULT") | 데이터 객체 조작/조회 |  |  |  |
| AC-74540e25 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 4 | SCP0201_CAPA.cs:1816 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (row <= lastRowIdx) ▸ for (col <= lastColIdx) ▸ else of (sColumnTag == DefColumns.BEF_BEST \|\| s… | DATA_OP | dtTempResultValue.Rows.Add | (tempValue) | 데이터 객체 조작/조회 |  |  |  |
| AC-931b1ba4 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 4 | SCP0201_CAPA.cs:1820 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (row <= lastRowIdx) ▸ for (col <= lastColIdx) ▸ else of (sColumnTag == DefColumns.BEF_BEST \|\| s… | DATA_OP | dtTempValue.Rows.Add | (tempValue) | 데이터 객체 조작/조회 |  |  |  |

## SCP0201_CAPA.Set_ChangeValue

진입점: dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (DefColumns.REQUEST_CHK == sColName) ▸ if (DefColumns.CONFIRM_FLAG != sColName && DefColumns.LANE_QTY != sColName && DefColumnsDataTable.SCM_WORK_CALENDAR_M != sDa…) ▸ if (sAction == CAppSetting.StringM && e.Column > 0) ▸ if (DefColumnsDataTable.SCM_WORK_CALENDAR_M == sDataTable \|\| DefColumnsDataTable.SCM_LOSS_M == sDataTable)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8212976e | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | SCP0201_CAPA.cs:1588 | if (DefColumnsDataTable.SCM_WORK_CALENDAR_M == sDataTable && sColName.StartsWith("D_")) | GRID_SET | siMain.SetValue | (row, newColIdx, oldValue) | 그리드 값 설정 |  |  |  |

## SCP0201_CAPA.Set_RefreshAfterSave

진입점: SaveButton [try ▸ if (iCount > 0) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Equals("S"))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d06c044e | SaveButton [try ▸ if (iCount > 0) ▸ try ▸ if (result != null… | SCP0201_CAPA.cs:1562 | foreach (int[] k in arrayChangeRowCol) | CALL_EXT | CUIControl.SetActionFlag | (spdMain, k[0], "N") | ⚠ 의미 확인 필요 |  |  |  |
| AC-b693536d | SaveButton [try ▸ if (iCount > 0) ▸ try ▸ if (result != null… | SCP0201_CAPA.cs:1567 | foreach (int[] k in arrayChangeRowCol) | UI_PROP | range1.ForeColor | Color.Black | 속성 ForeColor 설정 |  |  |  |

## SCP0201_CAPA.SetBackColor

진입점: txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter) ▸ try ▸ try ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ for (row < siMain.ActiveSheet.RowCount)] / txtMaterialId.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter) ▸ try ▸ try ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ for (row < siMain.ActiveSheet.RowCount)] / txtNickName.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter) ▸ try ▸ try ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ for (row < siMain.ActiveSheet.RowCount)] / this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MSG00265") == DialogResult.Yes) ▸ try ▸ …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9bcc8142 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 5 | SCP0201_CAPA.cs:721 | try ▸ if (DefColumnsDataTable.CAL == sDataTable \|\| DefColumnsLossCode.M08 == sLossCode) ▸ if (DefColumnsLossCode.XA001 != sLossCode) | GRID_STYLE | siMain.SetBGColor | (row, siMain.GetColumnIndex(DefColumns.CATEGORY_ID), row, siMain.GetColumnIndex(DefColumns… | 그리드 표시 설정 |  |  |  |
| AC-95ff3d04 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 5 | SCP0201_CAPA.cs:723 | try ▸ if (DefColumnsDataTable.CAL == sDataTable \|\| DefColumnsLossCode.M08 == sLossCode) ▸ if (DefColumnsLossCode.XA001 != sLossCode) | GRID_STYLE | siMain.SetBGColor | (row, siMain.GetColumnIndex("M_" + currentMonth) , row, lastIdx, Color.LightBlue) | 그리드 표시 설정 |  |  |  |
| AC-4a5b28ad | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 5 | SCP0201_CAPA.cs:734 | try ▸ if (!bEdit_Mode && bRealFlag && (strLineIdOpeartionId != strLineId + strOperationId)) | FLAG | strLineIdOpeartionId | strLineId + strOperationId | 화면 필드/플래그 변경 |  |  |  |
| AC-d12ff246 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 5 | SCP0201_CAPA.cs:735 | try ▸ if (!bEdit_Mode && bRealFlag && (strLineIdOpeartionId != strLineId + strOperationId)) | FLAG | arrayLA001 | new ArrayList() | 화면 필드/플래그 변경 |  |  |  |
| AC-865fe595 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 5 | SCP0201_CAPA.cs:750 | try ▸ for (col < siMain.ActiveSheet.ColumnCount) ▸ if ((DefColumnsCategoryId.NO_RUN == sCategoryId && DefColumnsLossCode.EL011 != sLossCode)… | UI_PROP | range1.BackColor | Color.Gray | 속성 BackColor 설정 |  |  |  |
| AC-79107e5b | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 5 | SCP0201_CAPA.cs:751 | try ▸ for (col < siMain.ActiveSheet.ColumnCount) ▸ if ((DefColumnsCategoryId.NO_RUN == sCategoryId && DefColumnsLossCode.EL011 != sLossCode)… | VALUE_CLEAR | range1.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-d48ce5c2 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 5 | SCP0201_CAPA.cs:763 | try ▸ for (col < siMain.ActiveSheet.ColumnCount) ▸ if (!bEdit_Mode && bRealFlag && DefColumnsLossCode.LA001 == sLossCode) ▸ if (strDayName.S… | DATA_OP | arrayLA001.Add | (strCode) | 데이터 객체 조작/조회 |  |  |  |
| AC-980ff8df | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 5 | SCP0201_CAPA.cs:777 | try ▸ for (col < siMain.ActiveSheet.ColumnCount) ▸ if (!bEdit_Mode && bRealFlag && (checkEmpty.Checked && (DefColumnsLossCode.LA002 == sLoss… | DATA_OP | arrayLA001.Contains | (strCode) | 데이터 객체 조작/조회 |  |  |  |
| AC-d419dd6b | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 5 | SCP0201_CAPA.cs:781 | try ▸ for (col < siMain.ActiveSheet.ColumnCount) ▸ if (!bEdit_Mode && bRealFlag && (checkEmpty.Checked && (DefColumnsLossCode.LA002 == sLoss… | UI_PROP | range1.BackColor | Color.FromArgb(216, 228, 188) | 속성 BackColor 설정 |  |  |  |
| AC-9ab57311 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 5 | SCP0201_CAPA.cs:789 | catch ((Exception ex)) | THROW | throw ex; |  | 예외 발생 |  |  |  |

## SCP0201_CAPA.SetBackColorBef

진입점: txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter) ▸ try ▸ try ▸ if (siMain.ActiveSheet.RowCount > 0)] / txtMaterialId.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter) ▸ try ▸ try ▸ if (siMain.ActiveSheet.RowCount > 0)] / txtNickName.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter) ▸ try ▸ try ▸ if (siMain.ActiveSheet.RowCount > 0)] / this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MSG00265") == DialogResult.Yes) ▸ try ▸ try ▸ if (siMain.ActiveSheet.RowCount > 0)] / FindButton [try ▸ try ▸ if (siMain.ActiveSheet.RowCount > 0)] / EditButton [if (…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-151654b3 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 5 | SCP0201_CAPA.cs:692 |  | GRID_STYLE | siMain.SetBGColor | (0, siMain.GetColumnIndex(DefColumns.UOM) + 1, siMain.Sheet(0).Rows.Count - 1, iLastIdx, C… | 그리드 표시 설정 |  |  |  |

## SCP0201_CAPA.SetChangedControl

진입점: this.Load / cboDivision.SelectedIndexChanged [if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e9d19234 | this.Load 외 1 | SCP0201_CAPA.cs:405 |  | FLAG | dtShopGroup | Data_SCP.Common(Data_SCP.Type.ShopGroupId, false, pDivisionID) | 화면 필드/플래그 변경 |  |  |  |
| AC-9d2fc189 | this.Load 외 1 | SCP0201_CAPA.cs:405 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.ShopGroupId, false, pDivisionID) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-e2126883 | this.Load 외 1 | SCP0201_CAPA.cs:406 |  | LIST_REBIND | clsCtrl.setListBox | (dtShopGroup, cboGroup, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-50a1cc27 | this.Load 외 1 | SCP0201_CAPA.cs:409 |  | FLAG | dtPlantByGroup | Data_SCP.Common(Data_SCP.Type.PlantByGroup, false, pDivisionID , pGroupId) | 화면 필드/플래그 변경 |  |  |  |
| AC-e3c525b0 | this.Load 외 1 | SCP0201_CAPA.cs:409 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.PlantByGroup, false, pDivisionID , pGroupId) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-af01d173 | this.Load 외 1 | SCP0201_CAPA.cs:410 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlantByGroup, clbPlant, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-5569a32f | this.Load 외 1 | SCP0201_CAPA.cs:413 |  | FLAG | dtBuildingByShopGroupId | Data_SCP.Common(Data_SCP.Type.BuildingByShopGroupId, false, pDivisionID, pPlantId,pGroupId… | 화면 필드/플래그 변경 |  |  |  |
| AC-ebd5ec05 | this.Load 외 1 | SCP0201_CAPA.cs:413 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.BuildingByShopGroupId, false, pDivisionID, pPlantId,pGroupId) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-d8abd1a8 | this.Load 외 1 | SCP0201_CAPA.cs:414 |  | LIST_REBIND | clsCtrl.setListBox | (dtBuildingByShopGroupId, clbBuilding, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-ac9998ca | this.Load 외 1 | SCP0201_CAPA.cs:418 |  | FLAG | dtLineByOperationPlantId | Data_SCP.Common(Data_SCP.Type.LineByOperationPlantId, false, pDivisionID, pPlantId, pBuild… | 화면 필드/플래그 변경 |  |  |  |
| AC-a37a18ca | this.Load 외 1 | SCP0201_CAPA.cs:418 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.LineByOperationPlantId, false, pDivisionID, pPlantId, pBuilding,pGroupId) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-645a6635 | this.Load 외 1 | SCP0201_CAPA.cs:419 |  | LIST_REBIND | clsCtrl.setListBox | (dtLineByOperationPlantId, clbLine, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-1c4ee6f2 | this.Load 외 1 | SCP0201_CAPA.cs:423 |  | FLAG | dtOperationByLine | Data.Common(Data.Type.OperationByLine, false, pDivisionID, pPlantId, pBuilding, pLineId, p… ⇒ biz:CommonData.CommonDataList [code=OperationByLine] | 화면 필드/플래그 변경 |  |  |  |
| AC-fe97878d | this.Load 외 1 | SCP0201_CAPA.cs:423 |  | COMBO_DATA | Data.Common | (Data.Type.OperationByLine, false, pDivisionID, pPlantId, pBuilding, pLineId, pGroupId) ⇒ biz:CommonData.CommonDataList [code=OperationByLine] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-4093c029 | this.Load 외 1 | SCP0201_CAPA.cs:424 |  | LIST_REBIND | clsCtrl.setListBox | (dtOperationByLine, clbOperation, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0201_CAPA.SetLineAssignVisible

진입점: txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter) ▸ try ▸ try ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ if (checkEmpty.Checked && !checkLineAssign.Checked)] / txtMaterialId.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter) ▸ try ▸ try ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ if (checkEmpty.Checked && !checkLineAssign.Checked)] / txtNickName.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter) ▸ try ▸ try ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ if (checkEmpty.Checked && !checkLineAssign.Checked)] / this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MSG0…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1d497b80 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 4 | SCP0201_CAPA.cs:702 | for (row < siMain.Sheet(0).Rows.Count) ▸ if ("LA001" == sLossCode) | CALL_EXT | siMain.ActiveSheet.RemoveRows | (row, 1) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0201_CAPA.SetSpreadColumn

진입점: this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter) ▸ try ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / txtMaterialId.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter) ▸ try ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / txtNickName.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter) ▸ try ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / this.formDown.Click [try ▸ if (spdInfo.SheetName == SpdS…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e409f76e | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 7 | SCP0201_CAPA.cs:1941 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (siMain.GetColumnTag(iCol).IndexOf("M_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("Y_") == … | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-10601756 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 7 | SCP0201_CAPA.cs:1944 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (siMain.GetColumnTag(iCol).IndexOf("M_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("Y_"… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |

## SCP0201_CAPA.SetSpreadColumnRESULT

진입점: this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] / checkRESULT.CheckedChanged / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter) ▸ try ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / txtMaterialId.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter) ▸ try ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / txtNickName.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter) ▸ try ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / this.formDown.Click [try ▸ …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-eb6637fb | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 8 | SCP0201_CAPA.cs:1892 | for (i<= 5) | GRID_SET | siMain.ActiveSheet.Columns[iBefM6Col - i].Visible | bVisible | 그리드 속성/값 설정 |  |  |  |
| AC-fe0c9c93 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 8 | SCP0201_CAPA.cs:1893 | for (i<= 5) | GRID_SET | siMain.ActiveSheet.Columns[iBefM6ResultCol - i].Visible | bVisibleResult | 그리드 속성/값 설정 |  |  |  |
| AC-23430334 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 8 | SCP0201_CAPA.cs:1896 |  | GRID_SET | siMain.ActiveSheet.Columns[iBest].Visible | !checkRESULT.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-5efa20c3 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 8 | SCP0201_CAPA.cs:1897 |  | GRID_SET | siMain.ActiveSheet.Columns[iWorst].Visible | !checkRESULT.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-a9d58cb5 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 8 | SCP0201_CAPA.cs:1898 |  | GRID_SET | siMain.ActiveSheet.Columns[iBestResult].Visible | checkRESULT.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-641411f9 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 8 | SCP0201_CAPA.cs:1899 |  | GRID_SET | siMain.ActiveSheet.Columns[iWorstResult].Visible | checkRESULT.Checked | 그리드 속성/값 설정 |  |  |  |

## SCP0201_CAPA.SetSpreadColumnTitle

진입점: this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter) ▸ try ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / txtMaterialId.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter) ▸ try ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / txtNickName.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter) ▸ try ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / this.formDown.Click [try ▸ if (spdInfo.SheetName == SpdS…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-05a6f569 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 7 | SCP0201_CAPA.cs:1912 |  | GRID_INIT | siMain.SetColumnHeader | (0, siMain.GetColumnIndex(DefColumns.BEF_M6), bef6Mon) | 그리드 재구성/초기화 |  |  |  |
| AC-ec08e9cb | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 7 | SCP0201_CAPA.cs:1913 |  | GRID_INIT | siMain.SetColumnHeader | (0, siMain.GetColumnIndex(DefColumns.BEF_M5), bef5Mon) | 그리드 재구성/초기화 |  |  |  |
| AC-207d7459 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 7 | SCP0201_CAPA.cs:1914 |  | GRID_INIT | siMain.SetColumnHeader | (0, siMain.GetColumnIndex(DefColumns.BEF_M4), bef4Mon) | 그리드 재구성/초기화 |  |  |  |
| AC-07e8f1b2 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 7 | SCP0201_CAPA.cs:1915 |  | GRID_INIT | siMain.SetColumnHeader | (0, siMain.GetColumnIndex(DefColumns.BEF_M3), bef3Mon) | 그리드 재구성/초기화 |  |  |  |
| AC-f6a80b36 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 7 | SCP0201_CAPA.cs:1916 |  | GRID_INIT | siMain.SetColumnHeader | (0, siMain.GetColumnIndex(DefColumns.BEF_M2), bef2Mon) | 그리드 재구성/초기화 |  |  |  |
| AC-993801b2 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 7 | SCP0201_CAPA.cs:1917 |  | GRID_INIT | siMain.SetColumnHeader | (0, siMain.GetColumnIndex(DefColumns.BEF_M1), bef1Mon) | 그리드 재구성/초기화 |  |  |  |
| AC-8b13b619 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 7 | SCP0201_CAPA.cs:1919 |  | GRID_INIT | siMain.SetColumnHeader | (0, siMain.GetColumnIndex(DefColumns.BEF_M6_RESULT), bef6Mon) | 그리드 재구성/초기화 |  |  |  |
| AC-bd9572d6 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 7 | SCP0201_CAPA.cs:1920 |  | GRID_INIT | siMain.SetColumnHeader | (0, siMain.GetColumnIndex(DefColumns.BEF_M5_RESULT), bef5Mon) | 그리드 재구성/초기화 |  |  |  |
| AC-5199fe2b | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 7 | SCP0201_CAPA.cs:1921 |  | GRID_INIT | siMain.SetColumnHeader | (0, siMain.GetColumnIndex(DefColumns.BEF_M4_RESULT), bef4Mon) | 그리드 재구성/초기화 |  |  |  |
| AC-59a0e5e7 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 7 | SCP0201_CAPA.cs:1922 |  | GRID_INIT | siMain.SetColumnHeader | (0, siMain.GetColumnIndex(DefColumns.BEF_M3_RESULT), bef3Mon) | 그리드 재구성/초기화 |  |  |  |
| AC-dd0108bc | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 7 | SCP0201_CAPA.cs:1923 |  | GRID_INIT | siMain.SetColumnHeader | (0, siMain.GetColumnIndex(DefColumns.BEF_M2_RESULT), bef2Mon) | 그리드 재구성/초기화 |  |  |  |
| AC-07fe6202 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 7 | SCP0201_CAPA.cs:1924 |  | GRID_INIT | siMain.SetColumnHeader | (0, siMain.GetColumnIndex(DefColumns.BEF_M1_RESULT), bef1Mon) | 그리드 재구성/초기화 |  |  |  |

## SCP0201_CAPA.SetSpreadInit

진입점: this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter) ▸ try ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / txtMaterialId.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter) ▸ try ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / txtNickName.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter) ▸ try ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / this.formDown.Click [try ▸ if (spdInfo.SheetName == SpdS…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-85371a6c | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 7 | SCP0201_CAPA.cs:475 | if (siObj.SheetName == SpdSheet.shtMain) | GRID_INIT | siObj.SetSheetHeaderColumn | (siObj, 2, dsUserTitle.Tables[0]) | 그리드 재구성/초기화 |  |  |  |
| AC-899c1b28 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 7 | SCP0201_CAPA.cs:479 | else of (siObj.SheetName == SpdSheet.shtMain) ▸ if (siObj.SheetName == SpdSheet.shtCAPAExcel) | GRID_INIT | siObj.SetSheetHeaderColumn | (siObj, 1) | 그리드 재구성/초기화 |  |  |  |

## SCP0201_CAPA.SetSpreadRow

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-777bd729 | (진입점 미연결) | SCP0201_CAPA.cs:1841 | for (row < siMain.ActiveSheet.RowCount) ▸ if ("LOSS" == eventParam) ▸ if (sDataTable == "SCM_WORK_CALENDAR_M" \|\| sDataTable =="SCM_LOSS_M"… | GRID_SET | siMain.ActiveSheet.Rows[row].Visible | checkLoss.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-8cbd589d | (진입점 미연결) | SCP0201_CAPA.cs:1848 | for (row < siMain.ActiveSheet.RowCount) ▸ else of ("LOSS" == eventParam) ▸ if ("LINE_ASSIGN" == eventParam) ▸ if (DefColumnsLossCode.LA001 =… | GRID_SET | siMain.ActiveSheet.Rows[row].Visible | checkLineAssign.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-b63a9907 | (진입점 미연결) | SCP0201_CAPA.cs:1854 | for (row < siMain.ActiveSheet.RowCount) ▸ else of ("LOSS" == eventParam) ▸ else of ("LINE_ASSIGN" == eventParam) ▸ if ("TACT_TIME" == eventP… | GRID_SET | siMain.ActiveSheet.Rows[row].Visible | checkTactTime.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-44628d26 | (진입점 미연결) | SCP0201_CAPA.cs:1861 | for (row < siMain.ActiveSheet.RowCount) ▸ else of ("LOSS" == eventParam) ▸ else of ("LINE_ASSIGN" == eventParam) ▸ else of ("TACT_TIME" == e… | GRID_SET | siMain.ActiveSheet.Rows[row].Visible | checkYield.Checked | 그리드 속성/값 설정 |  |  |  |

## SCP0201_CAPA.shtMain_Changed

진입점: dsdm.Changed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a200390d | dsdm.Changed | SCP0201_CAPA.cs:2596 | if (!this.CanModelChange) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3fe5940b | dsdm.Changed | SCP0201_CAPA.cs:2607 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (DefColumns.REQUEST_CHK == sColName) | CALL_EXT | siMain.IsLockCell | (e.Row, e.Column) | ⚠ 의미 확인 필요 |  |  |  |
| AC-6a482ac6 | dsdm.Changed | SCP0201_CAPA.cs:2609 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (DefColumns.REQUEST_CHK == sColName) ▸ if (siMain.… | GRID_SET | siMain.SetValue | (e.Row, e.Column, "False") | 그리드 값 설정 |  |  |  |

## SCP0201_CAPA.SpdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e75a11db | this.spdMain.CellClick | SCP0201_CAPA.cs:2445 | if (e.Column == siMain.GetColumnIndex(DefColumns.CONFIRM_FLAG)) | GRID_SET | siMain.ActiveSheet.Cells[e.Row, e.Column].ForeColor | Color.Red | 그리드 속성/값 설정 |  |  |  |

## SCP0201_CAPA.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b2d3e97e | this.spdMain.CellDoubleClick | SCP0201_CAPA.cs:2459 | if (e.ColumnHeader) ▸ if (siMain.GetColumnTag(e.Column).IndexOf("M_") == 0) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (siMain.GetColum… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | !siMain.ActiveSheet.Columns[iCol].Visible | 그리드 속성/값 설정 |  |  |  |
| AC-6606df28 | this.spdMain.CellDoubleClick | SCP0201_CAPA.cs:2473 | else of (e.ColumnHeader) ▸ if (siMain.IsLock(siMain.SheetName) \|\| siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) !… | RETURN | return; |  | 처리 중단/반환 |  |  |  |

