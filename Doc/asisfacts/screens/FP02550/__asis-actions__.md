# AS-IS 액션 대조표 — FP02550

> 원천: `Doc/asisfacts/screens/FP02550/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 710행 · 메서드 55 · 종류 DATA_OP 217 · FLAG 96 · RETURN 60 · GRID_SET 49 · UI_PROP 45 · GRID_INIT 35 · STATE 35 · MESSAGE 23 · CALL_EXT 21 · POPUP 18 · GRID_LOCK 16 · ENDPOINT 15 · UI_MISC 14 · GRID_STYLE 13 · COMBO_DATA 13 · CALL_BASE 9 · LIST_REBIND 9 · VALIDATE 8 · THROW 5 · GRID_BIND 4 · EXCEL 2 · FOCUS 1 · STATE_RESET 1 · GRID_CLEAR 1 · ⚠ 의미 확인 필요 30


## clsFP02550_Search_Cond.Clear

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-211ecfb5 | (진입점 미연결) | FP02550_Operation_Bod.cs:1972 |  | FLAG | this.COMPANY_ID | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-138ccfa8 | (진입점 미연결) | FP02550_Operation_Bod.cs:1973 |  | FLAG | this.DIVISION_ID | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-e9963ed2 | (진입점 미연결) | FP02550_Operation_Bod.cs:1974 |  | FLAG | this.SITE_ID | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-5a8b1c04 | (진입점 미연결) | FP02550_Operation_Bod.cs:1975 |  | FLAG | this.PLANT_ID | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-025f6f6e | (진입점 미연결) | FP02550_Operation_Bod.cs:1976 |  | FLAG | this.FACTORY_ID | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-9080f309 | (진입점 미연결) | FP02550_Operation_Bod.cs:1977 |  | FLAG | this.OPERATION_ID | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-79f6ff5b | (진입점 미연결) | FP02550_Operation_Bod.cs:1978 |  | FLAG | this.MODEL_TYPE | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-c13f7dd5 | (진입점 미연결) | FP02550_Operation_Bod.cs:1979 |  | FLAG | this.LINE_ATTR | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-5c563c91 | (진입점 미연결) | FP02550_Operation_Bod.cs:1980 |  | FLAG | this.EXCEL_VIEW | string.Empty | 화면 필드/플래그 변경 |  |  |  |

## FP02550_ExcelImportPopup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dc1d65f3 | .ctor | FP02550_ExcelImportPopup.cs:137 |  | FLAG | Filter | new FilterDataSet() | 화면 필드/플래그 변경 |  |  |  |
| AC-2a80b3f2 | .ctor | FP02550_ExcelImportPopup.cs:138 |  | FLAG | AutoCHK | false | 화면 필드/플래그 변경 |  |  |  |

## FP02550_ExcelImportPopup.btnClose_Click

진입점: this.btnClose.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1a2610e0 | this.btnClose.Click | FP02550_ExcelImportPopup.cs:1026 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP02550_ExcelImportPopup.btnDownload_Click

진입점: this.btnDownload.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5e5ef186 | this.btnDownload.Click | FP02550_ExcelImportPopup.cs:1010 |  | FOCUS | spdMain.Focus | () | 포커스 이동 |  |  |  |
| AC-5b4196d9 | this.btnDownload.Click | FP02550_ExcelImportPopup.cs:1011 |  | EXCEL | ExportExcel | () | 엑셀 내보내기/올리기 |  |  |  |

## FP02550_ExcelImportPopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9109732a | this.Load | FP02550_ExcelImportPopup.cs:181 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 2, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-ff21d544 | this.Load | FP02550_ExcelImportPopup.cs:182 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-1f913c6c | this.Load | FP02550_ExcelImportPopup.cs:183 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP02550_ExcelImportPopup.DefaultLineCheck

진입점: this.btnUpload.Click [if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ for (i < iRCnt + 1) ▸ if (DoDefaultLineCheck)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-23ce9ddf | this.btnUpload.Click [if (string.IsNullOrWhiteSpace(FileName… | FP02550_ExcelImportPopup.cs:978 |  | CALL_EXT | ExcelService.CommonDefaultLineCheck | (row, KeyColumnList, ColumnType, ColumnLength, Filter, AcceptOnlyPositve) | ⚠ 의미 확인 필요 |  |  |  |
| AC-194efd88 | this.btnUpload.Click [if (string.IsNullOrWhiteSpace(FileName… | FP02550_ExcelImportPopup.cs:978 |  | RETURN | return ExcelService.CommonDefaultLineCheck(row, KeyColumnList, ColumnType, Colum… |  | 처리 중단/반환 |  |  |  |

## FP02550_ExcelImportPopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5d91d5d2 | this.Load | FP02550_ExcelImportPopup.cs:176 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP02550_ExcelImportPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b3af5c24 | Dispose | FP02550_ExcelImportPopup.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP02550_ExcelImportPopup.FindButton

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-66685cbf | FindButton | FP02550_ExcelImportPopup.cs:228 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-c727d0cf | FindButton | FP02550_ExcelImportPopup.cs:229 |  | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-061e60dd | FindButton | FP02550_ExcelImportPopup.cs:231 |  | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## FP02550_ExcelImportPopup.FindData

진입점: this.Load / this.btnFind.Click / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f0aa0793 | this.Load 외 2 | FP02550_ExcelImportPopup.cs:264 | if (DoSearchData == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e26000be | this.Load 외 2 | FP02550_ExcelImportPopup.cs:265 |  | FLAG | ctx | FoxUserInfoContext.GetUserInfoContext() | 화면 필드/플래그 변경 |  |  |  |
| AC-c57ef8ab | this.Load 외 2 | FP02550_ExcelImportPopup.cs:265 |  | CALL_EXT | FoxUserInfoContext.GetUserInfoContext | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-2d140763 | this.Load 외 2 | FP02550_ExcelImportPopup.cs:269 | if (DoSearchData != null) | FLAG | this.hasError | false | 화면 필드/플래그 변경 |  |  |  |
| AC-6f303834 | this.Load 외 2 | FP02550_ExcelImportPopup.cs:270 | if (DoSearchData != null) | FLAG | this.IsExcelChanged | false | 화면 필드/플래그 변경 |  |  |  |
| AC-dd48cd18 | this.Load 외 2 | FP02550_ExcelImportPopup.cs:272 | if (DoSearchData != null) | STATE | this.spdMain.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-a5b31647 | this.Load 외 2 | FP02550_ExcelImportPopup.cs:273 | if (DoSearchData != null) | STATE | this.btnClose.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-473a1f32 | this.Load 외 2 | FP02550_ExcelImportPopup.cs:274 | if (DoSearchData != null) | STATE | this.btnFind.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-668e186f | this.Load 외 2 | FP02550_ExcelImportPopup.cs:275 | if (DoSearchData != null) | STATE | this.btnDownload.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-d7272ca2 | this.Load 외 2 | FP02550_ExcelImportPopup.cs:276 | if (DoSearchData != null) | STATE | this.btnUpload.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-e4caf436 | this.Load 외 2 | FP02550_ExcelImportPopup.cs:277 | if (DoSearchData != null) | STATE | this.btnSave.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-704383e4 | this.Load 외 2 | FP02550_ExcelImportPopup.cs:284 | if (DoSearchData != null) ▸ try ▸ if (UserInfoContext.Current == null) | CALL_EXT | FoxUserInfoContext.SetCallContext | (ctx) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d8c9a481 | this.Load 외 2 | FP02550_ExcelImportPopup.cs:287 | if (DoSearchData != null) ▸ try | CALL_BASE | DoSearchData | (Filter.Data) | ⚠ 의미 확인 필요 |  |  |  |
| AC-575b141a | this.Load 외 2 | FP02550_ExcelImportPopup.cs:288 | if (DoSearchData != null) ▸ try | CALL_BASE | this.Invoke | (new Action(delegate () { //this.Enabled = true; if (init) { if (set.Good() && !set.Tables… | ⚠ 의미 확인 필요 |  |  |  |
| AC-07305f95 | this.Load 외 2 | FP02550_ExcelImportPopup.cs:294 | if (DoSearchData != null) ▸ try ▸ lambda ▸ if (init) | DATA_OP | set.Tables[0].Columns.Contains | ("MESSAGE") | 데이터 객체 조작/조회 |  |  |  |
| AC-6e58b950 | this.Load 외 2 | FP02550_ExcelImportPopup.cs:295 | if (DoSearchData != null) ▸ try ▸ lambda ▸ if (init) ▸ if (set.Good() && !set.Tables[0].Columns.Contains("MESSAGE")) | DATA_OP | set.Tables[0].Columns.Add | ("MESSAGE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-f67b849e | this.Load 외 2 | FP02550_ExcelImportPopup.cs:296 | if (DoSearchData != null) ▸ try ▸ lambda ▸ if (init) | FLAG | DictColumn | siMain.SetSheetHeaderFromDataSource(siMain, set, ColumnWidth, ColumnTitle, KeyColumns, Aut… | 화면 필드/플래그 변경 |  |  |  |
| AC-e8fcf13f | this.Load 외 2 | FP02550_ExcelImportPopup.cs:296 | if (DoSearchData != null) ▸ try ▸ lambda ▸ if (init) | GRID_INIT | siMain.SetSheetHeaderFromDataSource | (siMain, set, ColumnWidth, ColumnTitle, KeyColumns, AutoCHK, ColumnBgColor,2) | 그리드 재구성/초기화 |  |  |  |
| AC-654f9690 | this.Load 외 2 | FP02550_ExcelImportPopup.cs:302 | if (DoSearchData != null) ▸ try ▸ lambda ▸ if (init) ▸ if (AutoCHK) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex("CHK")].CellType | chk | 그리드 속성/값 설정 |  |  |  |
| AC-4975e680 | this.Load 외 2 | FP02550_ExcelImportPopup.cs:303 | if (DoSearchData != null) ▸ try ▸ lambda ▸ if (init) ▸ if (AutoCHK) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex("CHK")].Value | false | 그리드 속성/값 설정 |  |  |  |
| AC-99fa522f | this.Load 외 2 | FP02550_ExcelImportPopup.cs:304 | if (DoSearchData != null) ▸ try ▸ lambda ▸ if (init) ▸ if (AutoCHK) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex("CHK")].Border | bevelbrdr | 그리드 속성/값 설정 |  |  |  |
| AC-5ebf4ba2 | this.Load 외 2 | FP02550_ExcelImportPopup.cs:308 | if (DoSearchData != null) ▸ try ▸ lambda ▸ if (init) ▸ if (Filter["EXCEL_VIEW"].ToString() == "MAIN") | GRID_INIT | siMain.ColumnHeaderSpan | (0, 9, 1, 3, 20, "Lot Size", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-660dd225 | this.Load 외 2 | FP02550_ExcelImportPopup.cs:309 | if (DoSearchData != null) ▸ try ▸ lambda ▸ if (init) ▸ if (Filter["EXCEL_VIEW"].ToString() == "MAIN") | GRID_INIT | siMain.ColumnHeaderSpan | (0, 12, 1, 2, 20, "Transfer Lot Size", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-73dfff57 | this.Load 외 2 | FP02550_ExcelImportPopup.cs:310 | if (DoSearchData != null) ▸ try ▸ lambda ▸ if (init) ▸ if (Filter["EXCEL_VIEW"].ToString() == "MAIN") | GRID_INIT | siMain.ColumnHeaderSpan | (0, 14, 1, 2, 20, "Precede Producing (Safety Stock)", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f8911a16 | this.Load 외 2 | FP02550_ExcelImportPopup.cs:311 | if (DoSearchData != null) ▸ try ▸ lambda ▸ if (init) ▸ if (Filter["EXCEL_VIEW"].ToString() == "MAIN") | GRID_INIT | siMain.ColumnHeaderSpan | (0, 16, 1, 2, 20, "Moving Time", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-121ff7ba | this.Load 외 2 | FP02550_ExcelImportPopup.cs:312 | if (DoSearchData != null) ▸ try ▸ lambda ▸ if (init) ▸ if (Filter["EXCEL_VIEW"].ToString() == "MAIN") | GRID_INIT | siMain.ColumnHeaderSpan | (0, 18, 1, 2, 20, "TAT", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7fb447ae | this.Load 외 2 | FP02550_ExcelImportPopup.cs:313 | if (DoSearchData != null) ▸ try ▸ lambda ▸ if (init) ▸ if (Filter["EXCEL_VIEW"].ToString() == "MAIN") | GRID_INIT | siMain.ColumnHeaderSpan | (0, 20, 1, 2, 20, "Operation L/T", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0ed5798b | this.Load 외 2 | FP02550_ExcelImportPopup.cs:314 | if (DoSearchData != null) ▸ try ▸ lambda ▸ if (init) ▸ if (Filter["EXCEL_VIEW"].ToString() == "MAIN") | GRID_INIT | siMain.ColumnHeaderSpan | (0, 22, 1, 2, 20, "Tolerance", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-acc6f0fe | this.Load 외 2 | FP02550_ExcelImportPopup.cs:317 | if (DoSearchData != null) ▸ try ▸ lambda ▸ if (init) ▸ else of (Filter["EXCEL_VIEW"].ToString() == "MAIN") | GRID_INIT | siMain.ColumnHeaderSpan | (0, 11, 1, 3, 20, "Lot Size", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b0f40373 | this.Load 외 2 | FP02550_ExcelImportPopup.cs:318 | if (DoSearchData != null) ▸ try ▸ lambda ▸ if (init) ▸ else of (Filter["EXCEL_VIEW"].ToString() == "MAIN") | GRID_INIT | siMain.ColumnHeaderSpan | (0, 14, 1, 2, 20, "Transfer Lot Size", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6d79bb0c | this.Load 외 2 | FP02550_ExcelImportPopup.cs:319 | if (DoSearchData != null) ▸ try ▸ lambda ▸ if (init) ▸ else of (Filter["EXCEL_VIEW"].ToString() == "MAIN") | GRID_INIT | siMain.ColumnHeaderSpan | (0, 16, 1, 2, 20, "Precede Producing (Safety Stock)", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-fffce402 | this.Load 외 2 | FP02550_ExcelImportPopup.cs:320 | if (DoSearchData != null) ▸ try ▸ lambda ▸ if (init) ▸ else of (Filter["EXCEL_VIEW"].ToString() == "MAIN") | GRID_INIT | siMain.ColumnHeaderSpan | (0, 18, 1, 2, 20, "Moving Time", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-44101ef5 | this.Load 외 2 | FP02550_ExcelImportPopup.cs:321 | if (DoSearchData != null) ▸ try ▸ lambda ▸ if (init) ▸ else of (Filter["EXCEL_VIEW"].ToString() == "MAIN") | GRID_INIT | siMain.ColumnHeaderSpan | (0, 20, 1, 2, 20, "TAT", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-406b9541 | this.Load 외 2 | FP02550_ExcelImportPopup.cs:322 | if (DoSearchData != null) ▸ try ▸ lambda ▸ if (init) ▸ else of (Filter["EXCEL_VIEW"].ToString() == "MAIN") | GRID_INIT | siMain.ColumnHeaderSpan | (0, 22, 1, 2, 20, "Operation L/T", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a0785bc5 | this.Load 외 2 | FP02550_ExcelImportPopup.cs:323 | if (DoSearchData != null) ▸ try ▸ lambda ▸ if (init) ▸ else of (Filter["EXCEL_VIEW"].ToString() == "MAIN") | GRID_INIT | siMain.ColumnHeaderSpan | (0, 24, 1, 2, 20, "Tolerance", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-72fd0aa7 | this.Load 외 2 | FP02550_ExcelImportPopup.cs:327 | if (DoSearchData != null) ▸ try ▸ lambda | GRID_BIND | siMain.Query | (set, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-9da134cd | this.Load 외 2 | FP02550_ExcelImportPopup.cs:334 | if (DoSearchData != null) ▸ try ▸ lambda ▸ foreach (KeyValuePair<string, string> col in DictColumn) ▸ if (bg_color.Good() && bg_color!= Colo… | GRID_STYLE | siMain.SetBGColor | (0, siMain.GetColumnIndex(col.Key) , set.Tables[0].Rows.Count - 1, siMain.GetColumnIndex(c… | 그리드 표시 설정 |  |  |  |
| AC-5a8653a0 | this.Load 외 2 | FP02550_ExcelImportPopup.cs:339 | if (DoSearchData != null) ▸ try ▸ lambda ▸ foreach (KeyValuePair<string, string> col in DictColumn) ▸ if (fore_color.Good() && fore_color !=… | GRID_STYLE | siMain.SetFGColor | (0, siMain.GetColumnIndex(col.Key) , set.Tables[0].Rows.Count - 1, siMain.GetColumnIndex(c… | 그리드 표시 설정 |  |  |  |
| AC-e078fe90 | this.Load 외 2 | FP02550_ExcelImportPopup.cs:342 | if (DoSearchData != null) ▸ try ▸ lambda | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-832d588b | this.Load 외 2 | FP02550_ExcelImportPopup.cs:351 | if (DoSearchData != null) ▸ finally | CALL_BASE | this.Invoke | (new Action(delegate () { //this.Enabled = false; this.spdMain.Enabled = true; this.btnClo… | ⚠ 의미 확인 필요 |  |  |  |
| AC-01d5fbce | this.Load 외 2 | FP02550_ExcelImportPopup.cs:354 | if (DoSearchData != null) ▸ finally ▸ lambda | STATE | this.spdMain.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-f4736122 | this.Load 외 2 | FP02550_ExcelImportPopup.cs:355 | if (DoSearchData != null) ▸ finally ▸ lambda | STATE | this.btnClose.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-c1bc0e5a | this.Load 외 2 | FP02550_ExcelImportPopup.cs:356 | if (DoSearchData != null) ▸ finally ▸ lambda | STATE | this.btnFind.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-d06b16eb | this.Load 외 2 | FP02550_ExcelImportPopup.cs:357 | if (DoSearchData != null) ▸ finally ▸ lambda | STATE | this.btnDownload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-a32445ae | this.Load 외 2 | FP02550_ExcelImportPopup.cs:358 | if (DoSearchData != null) ▸ finally ▸ lambda | STATE | this.btnUpload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-4a24a05c | this.Load 외 2 | FP02550_ExcelImportPopup.cs:359 | if (DoSearchData != null) ▸ finally ▸ lambda | STATE | this.btnSave.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## FP02550_ExcelImportPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9d437693 | this.Load | FP02550_ExcelImportPopup.cs:146 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-cb933bfb | this.Load | FP02550_ExcelImportPopup.cs:148 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP02550_ExcelImportPopup.GetExcelFileName

진입점: this.btnUpload.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1a2b2f93 | this.btnUpload.Click | FP02550_ExcelImportPopup.cs:746 | try | POPUP | new OpenFileDialog | () | 팝업/폼 생성 |  |  |  |
| AC-742012cf | this.btnUpload.Click | FP02550_ExcelImportPopup.cs:747 | try | UI_PROP | openFile.Filter | "Excel files (*.xls;*.xlsx)\|*.xls;*.xlsx\|xls files (*.xls)\|*.xls\|xlsx files (*.xlsx)\|… | 속성 Filter 설정 |  |  |  |
| AC-ac8fb14d | this.btnUpload.Click | FP02550_ExcelImportPopup.cs:748 | try | UI_PROP | openFile.FilterIndex | 1 | 속성 FilterIndex 설정 |  |  |  |
| AC-9e22e64f | this.btnUpload.Click | FP02550_ExcelImportPopup.cs:749 | try | UI_PROP | openFile.RestoreDirectory | true | 속성 RestoreDirectory 설정 |  |  |  |
| AC-fe9edec4 | this.btnUpload.Click | FP02550_ExcelImportPopup.cs:750 | try | UI_PROP | openFile.InitialDirectory | @"C:\My Documents\" | 속성 InitialDirectory 설정 |  |  |  |
| AC-3e9a203b | this.btnUpload.Click | FP02550_ExcelImportPopup.cs:751 | try | UI_PROP | openFile.FileName | FileName | 속성 FileName 설정 |  |  |  |
| AC-3a6c99d7 | this.btnUpload.Click | FP02550_ExcelImportPopup.cs:752 | try | POPUP | openFile.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-aaf1166e | this.btnUpload.Click | FP02550_ExcelImportPopup.cs:754 | try | FLAG | this.FileName | openFile.FileName | 화면 필드/플래그 변경 |  |  |  |
| AC-02caf724 | this.btnUpload.Click | FP02550_ExcelImportPopup.cs:755 | try | RETURN | return this.FileName; |  | 처리 중단/반환 |  |  |  |
| AC-41cd6161 | this.btnUpload.Click | FP02550_ExcelImportPopup.cs:759 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message, ex.Source, MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-f8d9ff60 | this.btnUpload.Click | FP02550_ExcelImportPopup.cs:760 | catch ((Exception ex)) | RETURN | return string.Empty; |  | 처리 중단/반환 |  |  |  |

## FP02550_ExcelImportPopup.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-65fea13c | this.Load | FP02550_ExcelImportPopup.cs:193 |  | GRID_INIT | siMain.InitSheet | (siMain.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-e0e1198a | this.Load | FP02550_ExcelImportPopup.cs:196 |  | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 2) | 그리드 재구성/초기화 |  |  |  |
| AC-72d4b348 | this.Load | FP02550_ExcelImportPopup.cs:198 |  | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-32594305 | this.Load | FP02550_ExcelImportPopup.cs:199 |  | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP02550_ExcelImportPopup.InitSpread_Merge

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-86a4faf6 | (진입점 미연결) | FP02550_ExcelImportPopup.cs:219 |  | GRID_INIT | siMain.Freeze | (0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP02550_ExcelImportPopup.OpenAndLoadExcelData

진입점: this.btnUpload.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e94cbb4d | this.btnUpload.Click | FP02550_ExcelImportPopup.cs:770 |  | CALL_EXT | System.IO.File.Exists | (FileName) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b99801cf | this.btnUpload.Click | FP02550_ExcelImportPopup.cs:772 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) | FLAG | hasError | false | 화면 필드/플래그 변경 |  |  |  |
| AC-6a113871 | this.btnUpload.Click | FP02550_ExcelImportPopup.cs:773 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) | FLAG | IsExcelChanged | true | 화면 필드/플래그 변경 |  |  |  |
| AC-803c6b24 | this.btnUpload.Click | FP02550_ExcelImportPopup.cs:774 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) | STATE_RESET | KeyColumnList.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-1d6e6967 | this.btnUpload.Click | FP02550_ExcelImportPopup.cs:779 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ if (KeyColumns != null) ▸ foreach (string keycolumn i… | DATA_OP | KeyColumnList.Add | (keycolumn) | 데이터 객체 조작/조회 |  |  |  |
| AC-e819240c | this.btnUpload.Click | FP02550_ExcelImportPopup.cs:784 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ if (DictColumn == null \|\| DictColumn.Count < 1) | MESSAGE | MessageBox.Show | ("There's no data to display", "Excel Import", MessageBoxButtons.OK, MessageBoxIcon.Inform… | 메시지 표시 |  |  |  |
| AC-3fe1cc93 | this.btnUpload.Click | FP02550_ExcelImportPopup.cs:785 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ if (DictColumn == null \|\| DictColumn.Count < 1) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-eb550feb | this.btnUpload.Click | FP02550_ExcelImportPopup.cs:796 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-6812fc7d | this.btnUpload.Click | FP02550_ExcelImportPopup.cs:800 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-2d6250f5 | this.btnUpload.Click | FP02550_ExcelImportPopup.cs:803 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try | STATE | xlApp.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-d1a88c31 | this.btnUpload.Click | FP02550_ExcelImportPopup.cs:804 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try | UI_PROP | xlApp.DisplayAlerts | false | 속성 DisplayAlerts 설정 |  |  |  |
| AC-d7f77284 | this.btnUpload.Click | FP02550_ExcelImportPopup.cs:806 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try | CALL_EXT | xlApp.Workbooks.Open | (FileName, Missing.Value, Missing.Value, Missing.Value, Missing.Value, Missing.Value , Mis… | ⚠ 의미 확인 필요 |  |  |  |
| AC-1924d6ad | this.btnUpload.Click | FP02550_ExcelImportPopup.cs:825 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try | CALL_EXT | xlRange.get_Value | (Type.Missing) | ⚠ 의미 확인 필요 |  |  |  |
| AC-6ad7f9a3 | this.btnUpload.Click | FP02550_ExcelImportPopup.cs:832 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (iRCnt < 2 \|\| iCCnt < DictColumn.Count) | MESSAGE | MessageBox.Show | ("There's no data to display", "Excel Import", MessageBoxButtons.OK, MessageBoxIcon.Inform… | 메시지 표시 |  |  |  |
| AC-ee55d81d | this.btnUpload.Click | FP02550_ExcelImportPopup.cs:833 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (iRCnt < 2 \|\| iCCnt < DictColumn.Count) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-6987af04 | this.btnUpload.Click | FP02550_ExcelImportPopup.cs:856 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (iFR == 0 \|\| iFC == 0) | MESSAGE | MessageBox.Show | ("Please check your excel file where should use same column and order as orignal file", "E… | 메시지 표시 |  |  |  |
| AC-dcb0d55e | this.btnUpload.Click | FP02550_ExcelImportPopup.cs:857 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (iFR == 0 \|\| iFC == 0) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-52f20419 | this.btnUpload.Click | FP02550_ExcelImportPopup.cs:867 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (main != null) | DATA_OP | main.Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-f71dbe2f | this.btnUpload.Click | FP02550_ExcelImportPopup.cs:876 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try | DATA_OP | excelData.Columns.Contains | ("MESSAGE") | 데이터 객체 조작/조회 |  |  |  |
| AC-6d92d2e3 | this.btnUpload.Click | FP02550_ExcelImportPopup.cs:877 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (!excelData.Columns.Contains("MESSAGE")) | DATA_OP | excelData.Columns.Add | (new DataColumn("MESSAGE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-ff74ecf1 | this.btnUpload.Click | FP02550_ExcelImportPopup.cs:888 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ for (i < iRCnt + 1) | DATA_OP | excelData.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-89654ccc | this.btnUpload.Click | FP02550_ExcelImportPopup.cs:895 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ for (i < iRCnt + 1) ▸ for (j < iFC + DictColumn… | DATA_OP | row[j - iFC] | each_cell_value | 행/컬럼 값 대입 |  |  |  |
| AC-fe656a02 | this.btnUpload.Click | FP02550_ExcelImportPopup.cs:906 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ for (i < iRCnt + 1) ▸ if (this.DoLineCheck != n… | CALL_BASE | DoLineCheck | (row) | ⚠ 의미 확인 필요 |  |  |  |
| AC-71385d0c | this.btnUpload.Click | FP02550_ExcelImportPopup.cs:910 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ for (i < iRCnt + 1) | DATA_OP | excelData.Rows.Add | (row) | 데이터 객체 조작/조회 |  |  |  |
| AC-880760bc | this.btnUpload.Click | FP02550_ExcelImportPopup.cs:915 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try | GRID_BIND | siMain.Query | (excelDataSet, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-b7475f9e | this.btnUpload.Click | FP02550_ExcelImportPopup.cs:929 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (excelDataSet != null && excelDataSet.Tables… | CALL_EXT | siMain.SetRowColor | (k, System.Drawing.Color.PaleVioletRed) | ⚠ 의미 확인 필요 |  |  |  |
| AC-5e5a6412 | this.btnUpload.Click | FP02550_ExcelImportPopup.cs:930 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (excelDataSet != null && excelDataSet.Tables… | FLAG | hasError | true | 화면 필드/플래그 변경 |  |  |  |
| AC-82d730d7 | this.btnUpload.Click | FP02550_ExcelImportPopup.cs:948 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (iSaveCnt == 0) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-01885fd2 | this.btnUpload.Click | FP02550_ExcelImportPopup.cs:954 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-f5430ce9 | this.btnUpload.Click | FP02550_ExcelImportPopup.cs:958 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message, ex.Source, MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-48d4a7c6 | this.btnUpload.Click | FP02550_ExcelImportPopup.cs:963 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ finally | CALL_EXT | xlApp.Quit | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-47882bb1 | this.btnUpload.Click | FP02550_ExcelImportPopup.cs:964 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-10c97e6f | this.btnUpload.Click | FP02550_ExcelImportPopup.cs:969 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## FP02550_ExcelImportPopup.SaveToDB

진입점: this.btnSave.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a2d7ad8e | this.btnSave.Click | FP02550_ExcelImportPopup.cs:460 | if (IsExcelChanged == false) | MESSAGE | MessageBox.Show | ("There is no changed to save") | 메시지 표시 |  |  |  |
| AC-f7eeb8ca | this.btnSave.Click | FP02550_ExcelImportPopup.cs:461 | if (IsExcelChanged == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7fbbcd06 | this.btnSave.Click | FP02550_ExcelImportPopup.cs:465 | if (hasError == true) | MESSAGE | MessageBox.Show | ("You have errors to fix") | 메시지 표시 |  |  |  |
| AC-8b8c39c5 | this.btnSave.Click | FP02550_ExcelImportPopup.cs:466 | if (hasError == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2b7690ce | this.btnSave.Click | FP02550_ExcelImportPopup.cs:470 |  | FLAG | ctx | FoxUserInfoContext.GetUserInfoContext() | 화면 필드/플래그 변경 |  |  |  |
| AC-758e1d33 | this.btnSave.Click | FP02550_ExcelImportPopup.cs:470 |  | CALL_EXT | FoxUserInfoContext.GetUserInfoContext | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-95b49071 | this.btnSave.Click | FP02550_ExcelImportPopup.cs:475 | if (DoSaveData != null) | STATE | this.spdMain.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-a203d9dc | this.btnSave.Click | FP02550_ExcelImportPopup.cs:476 | if (DoSaveData != null) | STATE | this.btnClose.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-992eb5c7 | this.btnSave.Click | FP02550_ExcelImportPopup.cs:477 | if (DoSaveData != null) | STATE | this.btnFind.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-3c80a619 | this.btnSave.Click | FP02550_ExcelImportPopup.cs:478 | if (DoSaveData != null) | STATE | this.btnDownload.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-75d97848 | this.btnSave.Click | FP02550_ExcelImportPopup.cs:479 | if (DoSaveData != null) | STATE | this.btnUpload.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-f7b64dde | this.btnSave.Click | FP02550_ExcelImportPopup.cs:480 | if (DoSaveData != null) | STATE | this.btnSave.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-22b4f86e | this.btnSave.Click | FP02550_ExcelImportPopup.cs:488 | if (DoSaveData != null) ▸ try ▸ if (main.Good()) | DATA_OP | main.Tables[0].Columns.Contains | ("USER_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-bf1e2084 | this.btnSave.Click | FP02550_ExcelImportPopup.cs:491 | if (DoSaveData != null) ▸ try ▸ if (main.Good()) ▸ if (!main.Tables[0].Columns.Contains("USER_ID")) | DATA_OP | main.Tables[0].Columns.Add | (itemColumn) | 데이터 객체 조작/조회 |  |  |  |
| AC-9a9c0028 | this.btnSave.Click | FP02550_ExcelImportPopup.cs:493 | if (DoSaveData != null) ▸ try ▸ if (main.Good()) | DATA_OP | main.Tables[0].Columns.Contains | ("JOB_ORDER") | 데이터 객체 조작/조회 |  |  |  |
| AC-8f3948b5 | this.btnSave.Click | FP02550_ExcelImportPopup.cs:496 | if (DoSaveData != null) ▸ try ▸ if (main.Good()) ▸ if (!main.Tables[0].Columns.Contains("JOB_ORDER")) | DATA_OP | main.Tables[0].Columns.Add | (itemColumn) | 데이터 객체 조작/조회 |  |  |  |
| AC-e913216f | this.btnSave.Click | FP02550_ExcelImportPopup.cs:501 | if (DoSaveData != null) ▸ try ▸ if (main.Good()) ▸ for (i < main.Tables[0].Rows.Count) | GRID_SET | main.Tables[0].Rows[i]["USER_ID"] | UserInfoContext.Current.UserId | 그리드 속성/값 설정 |  |  |  |
| AC-a1c3692a | this.btnSave.Click | FP02550_ExcelImportPopup.cs:502 | if (DoSaveData != null) ▸ try ▸ if (main.Good()) ▸ for (i < main.Tables[0].Rows.Count) | GRID_SET | main.Tables[0].Rows[i]["JOB_ORDER"] | i | 그리드 속성/값 설정 |  |  |  |
| AC-9da91474 | this.btnSave.Click | FP02550_ExcelImportPopup.cs:509 | if (DoSaveData != null) ▸ try ▸ if (expect_count < 1) | MESSAGE | MessageBox.Show | ("There is no data to save") | 메시지 표시 |  |  |  |
| AC-21e95159 | this.btnSave.Click | FP02550_ExcelImportPopup.cs:510 | if (DoSaveData != null) ▸ try ▸ if (expect_count < 1) | STATE | this.spdMain.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-e0096a80 | this.btnSave.Click | FP02550_ExcelImportPopup.cs:511 | if (DoSaveData != null) ▸ try ▸ if (expect_count < 1) | STATE | this.btnClose.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-5f975315 | this.btnSave.Click | FP02550_ExcelImportPopup.cs:512 | if (DoSaveData != null) ▸ try ▸ if (expect_count < 1) | STATE | this.btnFind.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-2cb84e97 | this.btnSave.Click | FP02550_ExcelImportPopup.cs:513 | if (DoSaveData != null) ▸ try ▸ if (expect_count < 1) | STATE | this.btnDownload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-15886c57 | this.btnSave.Click | FP02550_ExcelImportPopup.cs:514 | if (DoSaveData != null) ▸ try ▸ if (expect_count < 1) | STATE | this.btnUpload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-4579d6f1 | this.btnSave.Click | FP02550_ExcelImportPopup.cs:515 | if (DoSaveData != null) ▸ try ▸ if (expect_count < 1) | STATE | this.btnSave.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-d74cc496 | this.btnSave.Click | FP02550_ExcelImportPopup.cs:516 | if (DoSaveData != null) ▸ try ▸ if (expect_count < 1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-79831db3 | this.btnSave.Click | FP02550_ExcelImportPopup.cs:522 | if (DoSaveData != null) ▸ try ▸ if (DoValidationData != null) | CALL_BASE | DoValidationData | (main) | ⚠ 의미 확인 필요 |  |  |  |
| AC-2ddc77b5 | this.btnSave.Click | FP02550_ExcelImportPopup.cs:555 | if (DoSaveData != null) ▸ try ▸ if (valid) | CALL_BASE | DoSaveData | (main) | ⚠ 의미 확인 필요 |  |  |  |
| AC-737f9220 | this.btnSave.Click | FP02550_ExcelImportPopup.cs:567 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ try | DATA_OP | result.Tables[0].Columns.Contains | ("RESULT") | 데이터 객체 조작/조회 |  |  |  |
| AC-b375745c | this.btnSave.Click | FP02550_ExcelImportPopup.cs:569 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ try | DATA_OP | result.Tables[0].Columns.Contains | ("COUNT") | 데이터 객체 조작/조회 |  |  |  |
| AC-dbaf16c4 | this.btnSave.Click | FP02550_ExcelImportPopup.cs:571 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ try | DATA_OP | result.Tables[0].Columns.Contains | ("EXCEPTION") | 데이터 객체 조작/조회 |  |  |  |
| AC-5eaae1de | this.btnSave.Click | FP02550_ExcelImportPopup.cs:575 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ try ▸ if (!string.IsNullOrWhiteSpace(exception)) | MESSAGE | MessageBox.Show | ("Validation error :" + exception) | 메시지 표시 |  |  |  |
| AC-94bc7dea | this.btnSave.Click | FP02550_ExcelImportPopup.cs:590 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ try ▸ if (result_string.Equals("SUCCESS")) | FLAG | SaveSuccess | true | 화면 필드/플래그 변경 |  |  |  |
| AC-72b65398 | this.btnSave.Click | FP02550_ExcelImportPopup.cs:592 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ try ▸ if (result_string.Equals("SUCCESS")) | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { expect_count }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-41163143 | this.btnSave.Click | FP02550_ExcelImportPopup.cs:594 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ try ▸ if (result_string.Equals("SUCCESS")) | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-f6d7fb36 | this.btnSave.Click | FP02550_ExcelImportPopup.cs:599 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ try ▸ else of (result_string.Equals("SUCCESS")) | MESSAGE | MessageBox.Show | ("Save error :" + result_string) | 메시지 표시 |  |  |  |
| AC-20ed1945 | this.btnSave.Click | FP02550_ExcelImportPopup.cs:600 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ try ▸ else of (result_string.Equals("SUCCESS")) | FLAG | this.hasError | true | 화면 필드/플래그 변경 |  |  |  |
| AC-2a529489 | this.btnSave.Click | FP02550_ExcelImportPopup.cs:605 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ catch ((Exception e)) | MESSAGE | MessageBox.Show | ("Unknown validation error :" + e.Message) | 메시지 표시 |  |  |  |
| AC-d857f3da | this.btnSave.Click | FP02550_ExcelImportPopup.cs:640 | if (DoSaveData != null) ▸ try ▸ else of (result.Good()) ▸ foreach (DataRow valrow in valSrc.Rows) ▸ if (valrow["_VALID"] as string == "N") ▸… | DATA_OP | xlsrow["MESSAGE"] | valrow["_MSG"] | 행/컬럼 값 대입 |  |  |  |
| AC-7d74ba06 | this.btnSave.Click | FP02550_ExcelImportPopup.cs:642 | if (DoSaveData != null) ▸ try ▸ else of (result.Good()) ▸ foreach (DataRow valrow in valSrc.Rows) ▸ if (valrow["_VALID"] as string == "N") ▸… | CALL_EXT | siMain.SetRowColor | (index, System.Drawing.Color.PaleVioletRed) | ⚠ 의미 확인 필요 |  |  |  |
| AC-7936602b | this.btnSave.Click | FP02550_ExcelImportPopup.cs:643 | if (DoSaveData != null) ▸ try ▸ else of (result.Good()) ▸ foreach (DataRow valrow in valSrc.Rows) ▸ if (valrow["_VALID"] as string == "N") ▸… | FLAG | this.hasError | true | 화면 필드/플래그 변경 |  |  |  |
| AC-189d2d4f | this.btnSave.Click | FP02550_ExcelImportPopup.cs:653 | if (DoSaveData != null) ▸ catch ((Exception e)) | FLAG | this.hasError | true | 화면 필드/플래그 변경 |  |  |  |
| AC-747cf205 | this.btnSave.Click | FP02550_ExcelImportPopup.cs:654 | if (DoSaveData != null) ▸ catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-cbc4a763 | this.btnSave.Click | FP02550_ExcelImportPopup.cs:658 | if (DoSaveData != null) ▸ finally | STATE | this.spdMain.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-90d071e4 | this.btnSave.Click | FP02550_ExcelImportPopup.cs:659 | if (DoSaveData != null) ▸ finally | STATE | this.btnClose.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-4d213c0c | this.btnSave.Click | FP02550_ExcelImportPopup.cs:660 | if (DoSaveData != null) ▸ finally | STATE | this.btnFind.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-9bb1bd38 | this.btnSave.Click | FP02550_ExcelImportPopup.cs:661 | if (DoSaveData != null) ▸ finally | STATE | this.btnDownload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-9ef2ba03 | this.btnSave.Click | FP02550_ExcelImportPopup.cs:662 | if (DoSaveData != null) ▸ finally | STATE | this.btnUpload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-5a6ab152 | this.btnSave.Click | FP02550_ExcelImportPopup.cs:663 | if (DoSaveData != null) ▸ finally | STATE | this.btnSave.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## FP02550_ExcelImportPopup.SetSpreadInit

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d297234f | (진입점 미연결) | FP02550_ExcelImportPopup.cs:211 |  | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-06ae02de | (진입점 미연결) | FP02550_ExcelImportPopup.cs:212 |  | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |

## FP02550_Operation_Bod.btnExcelUpload_Click

진입점: this.btnExcelUpload.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3966c600 | this.btnExcelUpload.Click | FP02550_Operation_Bod.cs:660 | if (siMain.GetMaxRowIndex() < 0) | MESSAGE | MessageBox.Show | ("You need to Find(F5) before import excel") | 메시지 표시 |  |  |  |
| AC-e8cebef1 | this.btnExcelUpload.Click | FP02550_Operation_Bod.cs:661 | if (siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e39c1069 | this.btnExcelUpload.Click | FP02550_Operation_Bod.cs:667 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-45027d08 | this.btnExcelUpload.Click | FP02550_Operation_Bod.cs:677 |  | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { p_division_id = CString.GetCheckedListValue(dtDivision, c… | ⚠ 의미 확인 필요 |  |  |  |
| AC-c176e1d1 | this.btnExcelUpload.Click | FP02550_Operation_Bod.cs:687 |  | DATA_OP | Filter["p_company_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-a3fb4491 | this.btnExcelUpload.Click | FP02550_Operation_Bod.cs:688 |  | DATA_OP | Filter["p_division_id"] | p_division_id.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-72eeb13a | this.btnExcelUpload.Click | FP02550_Operation_Bod.cs:689 |  | DATA_OP | Filter["p_site_id"] | p_site_id.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-9176aed0 | this.btnExcelUpload.Click | FP02550_Operation_Bod.cs:690 |  | DATA_OP | Filter["p_plant_id"] | p_plant_id.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-2baca941 | this.btnExcelUpload.Click | FP02550_Operation_Bod.cs:691 |  | DATA_OP | Filter["p_factory_id"] | p_factory_id.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-db492200 | this.btnExcelUpload.Click | FP02550_Operation_Bod.cs:692 |  | DATA_OP | Filter["p_operation_id"] | p_operation_id.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-2846a651 | this.btnExcelUpload.Click | FP02550_Operation_Bod.cs:694 |  | DATA_OP | Filter["EXCEL_VIEW"] | "MAIN" | 행/컬럼 값 대입 |  |  |  |
| AC-b16f5f1e | this.btnExcelUpload.Click | FP02550_Operation_Bod.cs:696 |  | POPUP | new FP02550_ExcelImportPopup | () | 팝업/폼 생성 |  |  |  |
| AC-cc1a8ac0 | this.btnExcelUpload.Click | FP02550_Operation_Bod.cs:697 |  | UI_PROP | p.Filter | Filter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-e307a1fd | this.btnExcelUpload.Click | FP02550_Operation_Bod.cs:697 |  | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-62e23f18 | this.btnExcelUpload.Click | FP02550_Operation_Bod.cs:701 | if (fps.Name == spdMain.Name) | GRID_SET | p.KeyColumns["COMPANY_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-aa967a82 | this.btnExcelUpload.Click | FP02550_Operation_Bod.cs:702 | if (fps.Name == spdMain.Name) | GRID_SET | p.KeyColumns["DIVISION_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-dcecfe7e | this.btnExcelUpload.Click | FP02550_Operation_Bod.cs:703 | if (fps.Name == spdMain.Name) | GRID_SET | p.KeyColumns["SITE_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-a5c48fda | this.btnExcelUpload.Click | FP02550_Operation_Bod.cs:704 | if (fps.Name == spdMain.Name) | GRID_SET | p.KeyColumns["PLANT_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-6d50e110 | this.btnExcelUpload.Click | FP02550_Operation_Bod.cs:705 | if (fps.Name == spdMain.Name) | GRID_SET | p.KeyColumns["FACTORY_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-d0107662 | this.btnExcelUpload.Click | FP02550_Operation_Bod.cs:706 | if (fps.Name == spdMain.Name) | GRID_SET | p.KeyColumns["OPERATION_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-7d10af02 | this.btnExcelUpload.Click | FP02550_Operation_Bod.cs:707 | if (fps.Name == spdMain.Name) | GRID_SET | p.KeyColumns["MODEL_TYPE"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-c356f062 | this.btnExcelUpload.Click | FP02550_Operation_Bod.cs:708 | if (fps.Name == spdMain.Name) | GRID_SET | p.KeyColumns["LINE_ATTR_1"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-ddb105d2 | this.btnExcelUpload.Click | FP02550_Operation_Bod.cs:710 | if (fps.Name == spdMain.Name) | DATA_OP | p.ColumnTitle["COMPANY_ID"] | "Company_Id" | 행/컬럼 값 대입 |  |  |  |
| AC-dba0af01 | this.btnExcelUpload.Click | FP02550_Operation_Bod.cs:711 | if (fps.Name == spdMain.Name) | DATA_OP | p.ColumnTitle["DIVISION_ID"] | "Division_Id" | 행/컬럼 값 대입 |  |  |  |
| AC-b8522038 | this.btnExcelUpload.Click | FP02550_Operation_Bod.cs:712 | if (fps.Name == spdMain.Name) | DATA_OP | p.ColumnTitle["SITE_ID"] | "Site_Id" | 행/컬럼 값 대입 |  |  |  |
| AC-7906a6a8 | this.btnExcelUpload.Click | FP02550_Operation_Bod.cs:713 | if (fps.Name == spdMain.Name) | DATA_OP | p.ColumnTitle["PLANT_ID"] | "Plant_Id" | 행/컬럼 값 대입 |  |  |  |
| AC-830d9bdb | this.btnExcelUpload.Click | FP02550_Operation_Bod.cs:714 | if (fps.Name == spdMain.Name) | DATA_OP | p.ColumnTitle["FACTORY_ID"] | "Factory_Id" | 행/컬럼 값 대입 |  |  |  |
| AC-6178de79 | this.btnExcelUpload.Click | FP02550_Operation_Bod.cs:715 | if (fps.Name == spdMain.Name) | DATA_OP | p.ColumnTitle["MODEL_TYPE"] | "Model_Type" | 행/컬럼 값 대입 |  |  |  |
| AC-1829d6ad | this.btnExcelUpload.Click | FP02550_Operation_Bod.cs:716 | if (fps.Name == spdMain.Name) | DATA_OP | p.ColumnTitle["OPERATION_ID"] | "Operation_Id" | 행/컬럼 값 대입 |  |  |  |
| AC-10b60658 | this.btnExcelUpload.Click | FP02550_Operation_Bod.cs:717 | if (fps.Name == spdMain.Name) | DATA_OP | p.ColumnTitle["LINE_ATTR_1"] | "Line_Attr_1" | 행/컬럼 값 대입 |  |  |  |
| AC-f7eebb4b | this.btnExcelUpload.Click | FP02550_Operation_Bod.cs:718 | if (fps.Name == spdMain.Name) | DATA_OP | p.ColumnTitle["OPERATION_LOT_SIZE"] | "Max" | 행/컬럼 값 대입 |  |  |  |
| AC-319a8c78 | this.btnExcelUpload.Click | FP02550_Operation_Bod.cs:719 | if (fps.Name == spdMain.Name) | DATA_OP | p.ColumnTitle["MIN_LOT_SIZE"] | "Min" | 행/컬럼 값 대입 |  |  |  |
| AC-0db55df7 | this.btnExcelUpload.Click | FP02550_Operation_Bod.cs:720 | if (fps.Name == spdMain.Name) | DATA_OP | p.ColumnTitle["LOT_SIZE_UOM"] | "UOM" | 행/컬럼 값 대입 |  |  |  |
| AC-efe24a38 | this.btnExcelUpload.Click | FP02550_Operation_Bod.cs:721 | if (fps.Name == spdMain.Name) | DATA_OP | p.ColumnTitle["TRANSFER_LOT_SIZE"] | "Value" | 행/컬럼 값 대입 |  |  |  |
| AC-5f502bfa | this.btnExcelUpload.Click | FP02550_Operation_Bod.cs:722 | if (fps.Name == spdMain.Name) | DATA_OP | p.ColumnTitle["TRANSFER_LOT_SIZE_UOM"] | "UOM" | 행/컬럼 값 대입 |  |  |  |
| AC-95731313 | this.btnExcelUpload.Click | FP02550_Operation_Bod.cs:723 | if (fps.Name == spdMain.Name) | DATA_OP | p.ColumnTitle["PRECEDE_PRODUCING_TERM"] | "Value" | 행/컬럼 값 대입 |  |  |  |
| AC-cf498df1 | this.btnExcelUpload.Click | FP02550_Operation_Bod.cs:724 | if (fps.Name == spdMain.Name) | DATA_OP | p.ColumnTitle["PRECEDE_PRODUCING_TERM_UOM"] | "UOM" | 행/컬럼 값 대입 |  |  |  |
| AC-d98bba5f | this.btnExcelUpload.Click | FP02550_Operation_Bod.cs:725 | if (fps.Name == spdMain.Name) | DATA_OP | p.ColumnTitle["BUFFER_TIME"] | "Value" | 행/컬럼 값 대입 |  |  |  |
| AC-93885ccc | this.btnExcelUpload.Click | FP02550_Operation_Bod.cs:726 | if (fps.Name == spdMain.Name) | DATA_OP | p.ColumnTitle["BUFFER_TIME_UOM"] | "UOM" | 행/컬럼 값 대입 |  |  |  |
| AC-4a9b5b3a | this.btnExcelUpload.Click | FP02550_Operation_Bod.cs:727 | if (fps.Name == spdMain.Name) | DATA_OP | p.ColumnTitle["TAT"] | "Value" | 행/컬럼 값 대입 |  |  |  |
| AC-d60c75c6 | this.btnExcelUpload.Click | FP02550_Operation_Bod.cs:728 | if (fps.Name == spdMain.Name) | DATA_OP | p.ColumnTitle["TAT_UOM"] | "UOM" | 행/컬럼 값 대입 |  |  |  |
| AC-4ccc8b85 | this.btnExcelUpload.Click | FP02550_Operation_Bod.cs:729 | if (fps.Name == spdMain.Name) | DATA_OP | p.ColumnTitle["OPERATION_LEAD_TIME"] | "Value" | 행/컬럼 값 대입 |  |  |  |
| AC-30c4d4a8 | this.btnExcelUpload.Click | FP02550_Operation_Bod.cs:730 | if (fps.Name == spdMain.Name) | DATA_OP | p.ColumnTitle["OPERATION_LEAD_TIME_UOM"] | "UOM" | 행/컬럼 값 대입 |  |  |  |
| AC-b38fe365 | this.btnExcelUpload.Click | FP02550_Operation_Bod.cs:731 | if (fps.Name == spdMain.Name) | DATA_OP | p.ColumnTitle["TOLERANCE"] | "Value" | 행/컬럼 값 대입 |  |  |  |
| AC-c54a4848 | this.btnExcelUpload.Click | FP02550_Operation_Bod.cs:732 | if (fps.Name == spdMain.Name) | DATA_OP | p.ColumnTitle["TOLERANCE_UOM"] | "UOM" | 행/컬럼 값 대입 |  |  |  |
| AC-2e0582ed | this.btnExcelUpload.Click | FP02550_Operation_Bod.cs:733 | if (fps.Name == spdMain.Name) | DATA_OP | p.ColumnTitle["MESSAGE"] | "Message" | 행/컬럼 값 대입 |  |  |  |
| AC-373c1f61 | this.btnExcelUpload.Click | FP02550_Operation_Bod.cs:734 | if (fps.Name == spdMain.Name) | DATA_OP | p.ColumnTitle["INITIAL_PRODUCING_LEAD_TIME"] | "Value" | 행/컬럼 값 대입 |  |  |  |
| AC-68e32684 | this.btnExcelUpload.Click | FP02550_Operation_Bod.cs:735 | if (fps.Name == spdMain.Name) | DATA_OP | p.ColumnTitle["INITIAL_PRODUCING_LEAD_TIME_UOM"] | "UOM" | 행/컬럼 값 대입 |  |  |  |
| AC-61e8ca78 | this.btnExcelUpload.Click | FP02550_Operation_Bod.cs:736 | if (fps.Name == spdMain.Name) | DATA_OP | p.ColumnTitle["ACTIVE_FLAG"] | "Active_Flag" | 행/컬럼 값 대입 |  |  |  |
| AC-d8168c21 | this.btnExcelUpload.Click | FP02550_Operation_Bod.cs:737 | if (fps.Name == spdMain.Name) | DATA_OP | p.ColumnTitle["DESCRIPTION"] | "Description" | 행/컬럼 값 대입 |  |  |  |
| AC-f30ece04 | this.btnExcelUpload.Click | FP02550_Operation_Bod.cs:740 | if (fps.Name == spdMain.Name) | DATA_OP | p.ColumnWidth["INITIAL_PRODUCING_LEAD_TIME"] | 0 | 행/컬럼 값 대입 |  |  |  |
| AC-b5467a01 | this.btnExcelUpload.Click | FP02550_Operation_Bod.cs:741 | if (fps.Name == spdMain.Name) | DATA_OP | p.ColumnWidth["INITIAL_PRODUCING_LEAD_TIME_UOM"] | 0 | 행/컬럼 값 대입 |  |  |  |
| AC-2359465b | this.btnExcelUpload.Click | FP02550_Operation_Bod.cs:742 | if (fps.Name == spdMain.Name) | DATA_OP | p.ColumnWidth["ACTIVE_FLAG"] | 0 | 행/컬럼 값 대입 |  |  |  |
| AC-e1829d4b | this.btnExcelUpload.Click | FP02550_Operation_Bod.cs:743 | if (fps.Name == spdMain.Name) | DATA_OP | p.ColumnWidth["DESCRIPTION"] | 0 | 행/컬럼 값 대입 |  |  |  |
| AC-64b45158 | this.btnExcelUpload.Click | FP02550_Operation_Bod.cs:744 | if (fps.Name == spdMain.Name) | DATA_OP | p.ColumnWidth["EDIT_YN"] | 0 | 행/컬럼 값 대입 |  |  |  |
| AC-5e8535c2 | this.btnExcelUpload.Click | FP02550_Operation_Bod.cs:746 | if (fps.Name == spdMain.Name) | DATA_OP | p.ColumnBgColor["OPERATION_LOT_SIZE"] | Color.FromArgb(255, 255, 170) | 행/컬럼 값 대입 |  |  |  |
| AC-2d7a034d | this.btnExcelUpload.Click | FP02550_Operation_Bod.cs:747 | if (fps.Name == spdMain.Name) | DATA_OP | p.ColumnBgColor["MIN_LOT_SIZE"] | Color.FromArgb(255, 255, 170) | 행/컬럼 값 대입 |  |  |  |
| AC-35844a1e | this.btnExcelUpload.Click | FP02550_Operation_Bod.cs:748 | if (fps.Name == spdMain.Name) | DATA_OP | p.ColumnBgColor["LOT_SIZE_UOM"] | Color.FromArgb(255, 255, 170) | 행/컬럼 값 대입 |  |  |  |
| AC-95bd338c | this.btnExcelUpload.Click | FP02550_Operation_Bod.cs:749 | if (fps.Name == spdMain.Name) | DATA_OP | p.ColumnBgColor["TRANSFER_LOT_SIZE"] | Color.FromArgb(255, 255, 170) | 행/컬럼 값 대입 |  |  |  |
| AC-ca4803ea | this.btnExcelUpload.Click | FP02550_Operation_Bod.cs:750 | if (fps.Name == spdMain.Name) | DATA_OP | p.ColumnBgColor["TRANSFER_LOT_SIZE_UOM"] | Color.FromArgb(255, 255, 170) | 행/컬럼 값 대입 |  |  |  |
| AC-7d0352c5 | this.btnExcelUpload.Click | FP02550_Operation_Bod.cs:751 | if (fps.Name == spdMain.Name) | DATA_OP | p.ColumnBgColor["PRECEDE_PRODUCING_TERM"] | Color.FromArgb(255, 255, 170) | 행/컬럼 값 대입 |  |  |  |
| AC-9eaf39a1 | this.btnExcelUpload.Click | FP02550_Operation_Bod.cs:753 | if (fps.Name == spdMain.Name) | DATA_OP | p.ColumnBgColor["BUFFER_TIME"] | Color.FromArgb(255, 255, 170) | 행/컬럼 값 대입 |  |  |  |
| AC-199b3324 | this.btnExcelUpload.Click | FP02550_Operation_Bod.cs:755 | if (fps.Name == spdMain.Name) | DATA_OP | p.ColumnBgColor["TAT"] | Color.FromArgb(255, 255, 170) | 행/컬럼 값 대입 |  |  |  |
| AC-53d74e8d | this.btnExcelUpload.Click | FP02550_Operation_Bod.cs:757 | if (fps.Name == spdMain.Name) | DATA_OP | p.ColumnBgColor["OPERATION_LEAD_TIME"] | Color.FromArgb(255, 255, 170) | 행/컬럼 값 대입 |  |  |  |
| AC-5b740be4 | this.btnExcelUpload.Click | FP02550_Operation_Bod.cs:758 | if (fps.Name == spdMain.Name) | DATA_OP | p.ColumnBgColor["OPERATION_LEAD_TIME_UOM"] | Color.FromArgb(255, 255, 170) | 행/컬럼 값 대입 |  |  |  |
| AC-89d5098f | this.btnExcelUpload.Click | FP02550_Operation_Bod.cs:759 | if (fps.Name == spdMain.Name) | DATA_OP | p.ColumnBgColor["TOLERANCE"] | Color.FromArgb(255, 255, 170) | 행/컬럼 값 대입 |  |  |  |
| AC-f2b0285b | this.btnExcelUpload.Click | FP02550_Operation_Bod.cs:760 | if (fps.Name == spdMain.Name) | DATA_OP | p.ColumnBgColor["TOLERANCE_UOM"] | Color.FromArgb(255, 255, 170) | 행/컬럼 값 대입 |  |  |  |
| AC-4c402df2 | this.btnExcelUpload.Click | FP02550_Operation_Bod.cs:764 | if (fps.Name == spdMain.Name) | UI_PROP | p.DoSearchData | ExcelPopup_Search_Data | 속성 DoSearchData 설정 |  |  |  |
| AC-732cea93 | this.btnExcelUpload.Click | FP02550_Operation_Bod.cs:765 | if (fps.Name == spdMain.Name) | UI_PROP | p.DoLineCheck | ExcelImport_Main_RowCheckDelegate | 속성 DoLineCheck 설정 |  |  |  |
| AC-c3edf6b0 | this.btnExcelUpload.Click | FP02550_Operation_Bod.cs:766 | if (fps.Name == spdMain.Name) | UI_PROP | p.DoSaveData | ExcelImport_Main_SaveDataDelegate | 속성 DoSaveData 설정 |  |  |  |
| AC-67d6a865 | this.btnExcelUpload.Click | FP02550_Operation_Bod.cs:767 | if (fps.Name == spdMain.Name) | UI_PROP | p.DoValidationData | ExcelImport_Main_ValidateDataDelegate | 속성 DoValidationData 설정 |  |  |  |
| AC-577f0d80 | this.btnExcelUpload.Click | FP02550_Operation_Bod.cs:770 | if (fps.Name == spdMain.Name) | UI_PROP | p.Owner | this | 속성 Owner 설정 |  |  |  |
| AC-e038eb60 | this.btnExcelUpload.Click | FP02550_Operation_Bod.cs:771 | if (fps.Name == spdMain.Name) | UI_PROP | p.StartPosition | System.Windows.Forms.FormStartPosition.CenterScreen | 속성 StartPosition 설정 |  |  |  |
| AC-70d9aa19 | this.btnExcelUpload.Click | FP02550_Operation_Bod.cs:772 | if (fps.Name == spdMain.Name) | POPUP | p.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP02550_Operation_Bod.btnSearchAll_Click

진입점: this.btnSearchAll.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5f4046b6 | this.btnSearchAll.Click | FP02550_Operation_Bod.cs:1934 |  | CALL_EXT | _search.Clear | () | ⚠ 의미 확인 필요 |  |  |  |

## FP02550_Operation_Bod.btnSql_Click

진입점: this.btnSql.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-574a44ea | this.btnSql.Click | FP02550_Operation_Bod.cs:1029 |  | POPUP | new FPC0099_SqlPopup | () | 팝업/폼 생성 |  |  |  |
| AC-c18e1350 | this.btnSql.Click | FP02550_Operation_Bod.cs:1030 |  | UI_PROP | popSql.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-fceebcc2 | this.btnSql.Click | FP02550_Operation_Bod.cs:1032 |  | DATA_OP | popSql.Services.Add | ("SELECT_MAIN") | 데이터 객체 조작/조회 |  |  |  |
| AC-0dabe924 | this.btnSql.Click | FP02550_Operation_Bod.cs:1033 |  | DATA_OP | popSql.Services.Add | ("SELECT_SUB") | 데이터 객체 조작/조회 |  |  |  |
| AC-ee359fe5 | this.btnSql.Click | FP02550_Operation_Bod.cs:1034 |  | DATA_OP | popSql.Services.Add | ("REFRESH_SETUP_GROUP") | 데이터 객체 조작/조회 |  |  |  |
| AC-78249fc9 | this.btnSql.Click | FP02550_Operation_Bod.cs:1035 |  | DATA_OP | popSql.Services.Add | ("SAVE_MAIN") | 데이터 객체 조작/조회 |  |  |  |
| AC-ac6da5f2 | this.btnSql.Click | FP02550_Operation_Bod.cs:1036 |  | DATA_OP | popSql.Services.Add | ("SAVE_SUB") | 데이터 객체 조작/조회 |  |  |  |
| AC-c08460de | this.btnSql.Click | FP02550_Operation_Bod.cs:1037 |  | POPUP | popSql.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP02550_Operation_Bod.btnSubImport_Click

진입점: this.btnSubImport.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4bec3f3f | this.btnSubImport.Click | FP02550_Operation_Bod.cs:787 | if (siMain.GetMaxRowIndex() < 0) | MESSAGE | MessageBox.Show | ("You need to Find(F5) before import excel") | 메시지 표시 |  |  |  |
| AC-b322614d | this.btnSubImport.Click | FP02550_Operation_Bod.cs:788 | if (siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e1c645cf | this.btnSubImport.Click | FP02550_Operation_Bod.cs:794 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-757702a1 | this.btnSubImport.Click | FP02550_Operation_Bod.cs:804 |  | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { p_division_id = CString.GetCheckedListValue(dtDivision, c… | ⚠ 의미 확인 필요 |  |  |  |
| AC-1d95b6f8 | this.btnSubImport.Click | FP02550_Operation_Bod.cs:814 |  | DATA_OP | Filter["p_company_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-e8be9e43 | this.btnSubImport.Click | FP02550_Operation_Bod.cs:815 |  | DATA_OP | Filter["p_division_id"] | p_division_id.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-e0da3c2f | this.btnSubImport.Click | FP02550_Operation_Bod.cs:816 |  | DATA_OP | Filter["p_site_id"] | p_site_id.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-a188ca91 | this.btnSubImport.Click | FP02550_Operation_Bod.cs:817 |  | DATA_OP | Filter["p_plant_id"] | p_plant_id.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-7dd63cc2 | this.btnSubImport.Click | FP02550_Operation_Bod.cs:818 |  | DATA_OP | Filter["p_factory_id"] | p_factory_id.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-60be3769 | this.btnSubImport.Click | FP02550_Operation_Bod.cs:819 |  | DATA_OP | Filter["p_operation_id"] | p_operation_id.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-39517102 | this.btnSubImport.Click | FP02550_Operation_Bod.cs:821 |  | POPUP | new FP02550_ExcelImportPopup | () | 팝업/폼 생성 |  |  |  |
| AC-050a1213 | this.btnSubImport.Click | FP02550_Operation_Bod.cs:823 |  | DATA_OP | Filter["EXCEL_VIEW"] | "SUB" | 행/컬럼 값 대입 |  |  |  |
| AC-aa050f0a | this.btnSubImport.Click | FP02550_Operation_Bod.cs:824 |  | UI_PROP | p.Filter | Filter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-e07e2bfd | this.btnSubImport.Click | FP02550_Operation_Bod.cs:824 |  | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-6dbc2166 | this.btnSubImport.Click | FP02550_Operation_Bod.cs:828 | if (fps.Name == spdMain.Name) | GRID_SET | p.KeyColumns["COMPANY_ID" ] | true | 그리드 속성/값 설정 |  |  |  |
| AC-f0868ff2 | this.btnSubImport.Click | FP02550_Operation_Bod.cs:829 | if (fps.Name == spdMain.Name) | GRID_SET | p.KeyColumns["DIVISION_ID" ] | true | 그리드 속성/값 설정 |  |  |  |
| AC-fa8a0ff1 | this.btnSubImport.Click | FP02550_Operation_Bod.cs:830 | if (fps.Name == spdMain.Name) | GRID_SET | p.KeyColumns["SITE_ID" ] | true | 그리드 속성/값 설정 |  |  |  |
| AC-854b6585 | this.btnSubImport.Click | FP02550_Operation_Bod.cs:831 | if (fps.Name == spdMain.Name) | GRID_SET | p.KeyColumns["PLANT_ID" ] | true | 그리드 속성/값 설정 |  |  |  |
| AC-ef68badb | this.btnSubImport.Click | FP02550_Operation_Bod.cs:832 | if (fps.Name == spdMain.Name) | GRID_SET | p.KeyColumns["FACTORY_ID" ] | true | 그리드 속성/값 설정 |  |  |  |
| AC-3adae168 | this.btnSubImport.Click | FP02550_Operation_Bod.cs:833 | if (fps.Name == spdMain.Name) | GRID_SET | p.KeyColumns["OPERATION_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-87bbca71 | this.btnSubImport.Click | FP02550_Operation_Bod.cs:834 | if (fps.Name == spdMain.Name) | GRID_SET | p.KeyColumns["MODEL_TYPE" ] | true | 그리드 속성/값 설정 |  |  |  |
| AC-0136d53b | this.btnSubImport.Click | FP02550_Operation_Bod.cs:835 | if (fps.Name == spdMain.Name) | GRID_SET | p.KeyColumns["LINE_ATTR_1" ] | true | 그리드 속성/값 설정 |  |  |  |
| AC-38c876f4 | this.btnSubImport.Click | FP02550_Operation_Bod.cs:836 | if (fps.Name == spdMain.Name) | GRID_SET | p.KeyColumns["ITEM_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-7fec0447 | this.btnSubImport.Click | FP02550_Operation_Bod.cs:838 | if (fps.Name == spdMain.Name) | DATA_OP | p.ColumnTitle["COMPANY_ID"] | "Company_Id" | 행/컬럼 값 대입 |  |  |  |
| AC-439ea52e | this.btnSubImport.Click | FP02550_Operation_Bod.cs:839 | if (fps.Name == spdMain.Name) | DATA_OP | p.ColumnTitle["DIVISION_ID"] | "Division_Id" | 행/컬럼 값 대입 |  |  |  |
| AC-c6e686c3 | this.btnSubImport.Click | FP02550_Operation_Bod.cs:840 | if (fps.Name == spdMain.Name) | DATA_OP | p.ColumnTitle["SITE_ID"] | "Site_Id" | 행/컬럼 값 대입 |  |  |  |
| AC-deb78ab5 | this.btnSubImport.Click | FP02550_Operation_Bod.cs:841 | if (fps.Name == spdMain.Name) | DATA_OP | p.ColumnTitle["PLANT_ID"] | "Plant_Id" | 행/컬럼 값 대입 |  |  |  |
| AC-918249bd | this.btnSubImport.Click | FP02550_Operation_Bod.cs:842 | if (fps.Name == spdMain.Name) | DATA_OP | p.ColumnTitle["FACTORY_ID"] | "Factory_Id" | 행/컬럼 값 대입 |  |  |  |
| AC-09117510 | this.btnSubImport.Click | FP02550_Operation_Bod.cs:843 | if (fps.Name == spdMain.Name) | DATA_OP | p.ColumnTitle["MODEL_TYPE"] | "Model_Type" | 행/컬럼 값 대입 |  |  |  |
| AC-f544d2bc | this.btnSubImport.Click | FP02550_Operation_Bod.cs:844 | if (fps.Name == spdMain.Name) | DATA_OP | p.ColumnTitle["OPERATION_ID"] | "Operation_Id" | 행/컬럼 값 대입 |  |  |  |
| AC-c2bd7c03 | this.btnSubImport.Click | FP02550_Operation_Bod.cs:845 | if (fps.Name == spdMain.Name) | DATA_OP | p.ColumnTitle["LINE_ATTR_1"] | "Line_Attr_1" | 행/컬럼 값 대입 |  |  |  |
| AC-1596c2c8 | this.btnSubImport.Click | FP02550_Operation_Bod.cs:846 | if (fps.Name == spdMain.Name) | DATA_OP | p.ColumnTitle["ITEM_ID"] | "Material" | 행/컬럼 값 대입 |  |  |  |
| AC-4f87a193 | this.btnSubImport.Click | FP02550_Operation_Bod.cs:847 | if (fps.Name == spdMain.Name) | DATA_OP | p.ColumnTitle["NICK_NAME"] | "Nick Name" | 행/컬럼 값 대입 |  |  |  |
| AC-3fad1d28 | this.btnSubImport.Click | FP02550_Operation_Bod.cs:848 | if (fps.Name == spdMain.Name) | DATA_OP | p.ColumnTitle["OPERATION_LOT_SIZE"] | "Max" | 행/컬럼 값 대입 |  |  |  |
| AC-04425686 | this.btnSubImport.Click | FP02550_Operation_Bod.cs:849 | if (fps.Name == spdMain.Name) | DATA_OP | p.ColumnTitle["MIN_LOT_SIZE"] | "Min" | 행/컬럼 값 대입 |  |  |  |
| AC-6b5ce032 | this.btnSubImport.Click | FP02550_Operation_Bod.cs:850 | if (fps.Name == spdMain.Name) | DATA_OP | p.ColumnTitle["LOT_SIZE_UOM"] | "UOM" | 행/컬럼 값 대입 |  |  |  |
| AC-304cc609 | this.btnSubImport.Click | FP02550_Operation_Bod.cs:851 | if (fps.Name == spdMain.Name) | DATA_OP | p.ColumnTitle["TRANSFER_LOT_SIZE"] | "Value" | 행/컬럼 값 대입 |  |  |  |
| AC-8020eba7 | this.btnSubImport.Click | FP02550_Operation_Bod.cs:852 | if (fps.Name == spdMain.Name) | DATA_OP | p.ColumnTitle["TRANSFER_LOT_SIZE_UOM"] | "UOM" | 행/컬럼 값 대입 |  |  |  |
| AC-470d2beb | this.btnSubImport.Click | FP02550_Operation_Bod.cs:853 | if (fps.Name == spdMain.Name) | DATA_OP | p.ColumnTitle["PRECEDE_PRODUCING_TERM"] | "Value" | 행/컬럼 값 대입 |  |  |  |
| AC-d8682a49 | this.btnSubImport.Click | FP02550_Operation_Bod.cs:854 | if (fps.Name == spdMain.Name) | DATA_OP | p.ColumnTitle["PRECEDE_PRODUCING_TERM_UOM"] | "UOM" | 행/컬럼 값 대입 |  |  |  |
| AC-ab5713aa | this.btnSubImport.Click | FP02550_Operation_Bod.cs:855 | if (fps.Name == spdMain.Name) | DATA_OP | p.ColumnTitle["BUFFER_TIME"] | "Value" | 행/컬럼 값 대입 |  |  |  |
| AC-1a4ba197 | this.btnSubImport.Click | FP02550_Operation_Bod.cs:856 | if (fps.Name == spdMain.Name) | DATA_OP | p.ColumnTitle["BUFFER_TIME_UOM"] | "UOM" | 행/컬럼 값 대입 |  |  |  |
| AC-1a006bcf | this.btnSubImport.Click | FP02550_Operation_Bod.cs:857 | if (fps.Name == spdMain.Name) | DATA_OP | p.ColumnTitle["TAT"] | "Value" | 행/컬럼 값 대입 |  |  |  |
| AC-baafa1c4 | this.btnSubImport.Click | FP02550_Operation_Bod.cs:858 | if (fps.Name == spdMain.Name) | DATA_OP | p.ColumnTitle["TAT_UOM"] | "UOM" | 행/컬럼 값 대입 |  |  |  |
| AC-cc1a2159 | this.btnSubImport.Click | FP02550_Operation_Bod.cs:859 | if (fps.Name == spdMain.Name) | DATA_OP | p.ColumnTitle["OPERATION_LEAD_TIME"] | "Value" | 행/컬럼 값 대입 |  |  |  |
| AC-8409f660 | this.btnSubImport.Click | FP02550_Operation_Bod.cs:860 | if (fps.Name == spdMain.Name) | DATA_OP | p.ColumnTitle["OPERATION_LEAD_TIME_UOM"] | "UOM" | 행/컬럼 값 대입 |  |  |  |
| AC-a5765bde | this.btnSubImport.Click | FP02550_Operation_Bod.cs:861 | if (fps.Name == spdMain.Name) | DATA_OP | p.ColumnTitle["TOLERANCE"] | "Value" | 행/컬럼 값 대입 |  |  |  |
| AC-0a24f149 | this.btnSubImport.Click | FP02550_Operation_Bod.cs:862 | if (fps.Name == spdMain.Name) | DATA_OP | p.ColumnTitle["TOLERANCE_UOM"] | "UOM" | 행/컬럼 값 대입 |  |  |  |
| AC-03960f11 | this.btnSubImport.Click | FP02550_Operation_Bod.cs:863 | if (fps.Name == spdMain.Name) | DATA_OP | p.ColumnTitle["MESSAGE"] | "Message" | 행/컬럼 값 대입 |  |  |  |
| AC-5b50f662 | this.btnSubImport.Click | FP02550_Operation_Bod.cs:864 | if (fps.Name == spdMain.Name) | DATA_OP | p.ColumnTitle["INITIAL_PRODUCING_LEAD_TIME"] | "Value" | 행/컬럼 값 대입 |  |  |  |
| AC-45f2e050 | this.btnSubImport.Click | FP02550_Operation_Bod.cs:865 | if (fps.Name == spdMain.Name) | DATA_OP | p.ColumnTitle["INITIAL_PRODUCING_LEAD_TIME_UOM"] | "UOM" | 행/컬럼 값 대입 |  |  |  |
| AC-8c442f49 | this.btnSubImport.Click | FP02550_Operation_Bod.cs:866 | if (fps.Name == spdMain.Name) | DATA_OP | p.ColumnTitle["ACTIVE_FLAG"] | "Active_Flag" | 행/컬럼 값 대입 |  |  |  |
| AC-cea4915d | this.btnSubImport.Click | FP02550_Operation_Bod.cs:867 | if (fps.Name == spdMain.Name) | DATA_OP | p.ColumnTitle["DESCRIPTION"] | "Description" | 행/컬럼 값 대입 |  |  |  |
| AC-ca3e24b5 | this.btnSubImport.Click | FP02550_Operation_Bod.cs:870 | if (fps.Name == spdMain.Name) | DATA_OP | p.ColumnWidth["TAT_FLAG"] | 0 | 행/컬럼 값 대입 |  |  |  |
| AC-3a9838d9 | this.btnSubImport.Click | FP02550_Operation_Bod.cs:871 | if (fps.Name == spdMain.Name) | DATA_OP | p.ColumnWidth["INITIAL_PRODUCING_LEAD_TIME"] | 0 | 행/컬럼 값 대입 |  |  |  |
| AC-672089be | this.btnSubImport.Click | FP02550_Operation_Bod.cs:872 | if (fps.Name == spdMain.Name) | DATA_OP | p.ColumnWidth["INITIAL_PRODUCING_LEAD_TIME_UOM"] | 0 | 행/컬럼 값 대입 |  |  |  |
| AC-cbaa2c6f | this.btnSubImport.Click | FP02550_Operation_Bod.cs:873 | if (fps.Name == spdMain.Name) | DATA_OP | p.ColumnWidth["ACTIVE_FLAG"] | 0 | 행/컬럼 값 대입 |  |  |  |
| AC-5cbaf91e | this.btnSubImport.Click | FP02550_Operation_Bod.cs:874 | if (fps.Name == spdMain.Name) | DATA_OP | p.ColumnWidth["DESCRIPTION"] | 0 | 행/컬럼 값 대입 |  |  |  |
| AC-fec2b649 | this.btnSubImport.Click | FP02550_Operation_Bod.cs:875 | if (fps.Name == spdMain.Name) | DATA_OP | p.ColumnWidth["EDIT_YN"] | 0 | 행/컬럼 값 대입 |  |  |  |
| AC-24fbbc85 | this.btnSubImport.Click | FP02550_Operation_Bod.cs:877 | if (fps.Name == spdMain.Name) | DATA_OP | p.ColumnBgColor["OPERATION_LOT_SIZE"] | Color.FromArgb(255, 255, 170) | 행/컬럼 값 대입 |  |  |  |
| AC-7e53011c | this.btnSubImport.Click | FP02550_Operation_Bod.cs:878 | if (fps.Name == spdMain.Name) | DATA_OP | p.ColumnBgColor["MIN_LOT_SIZE"] | Color.FromArgb(255, 255, 170) | 행/컬럼 값 대입 |  |  |  |
| AC-862fc7a6 | this.btnSubImport.Click | FP02550_Operation_Bod.cs:879 | if (fps.Name == spdMain.Name) | DATA_OP | p.ColumnBgColor["LOT_SIZE_UOM"] | Color.FromArgb(255, 255, 170) | 행/컬럼 값 대입 |  |  |  |
| AC-65368593 | this.btnSubImport.Click | FP02550_Operation_Bod.cs:880 | if (fps.Name == spdMain.Name) | DATA_OP | p.ColumnBgColor["TRANSFER_LOT_SIZE"] | Color.FromArgb(255, 255, 170) | 행/컬럼 값 대입 |  |  |  |
| AC-e6a23a18 | this.btnSubImport.Click | FP02550_Operation_Bod.cs:881 | if (fps.Name == spdMain.Name) | DATA_OP | p.ColumnBgColor["TRANSFER_LOT_SIZE_UOM"] | Color.FromArgb(255, 255, 170) | 행/컬럼 값 대입 |  |  |  |
| AC-4a42704c | this.btnSubImport.Click | FP02550_Operation_Bod.cs:882 | if (fps.Name == spdMain.Name) | DATA_OP | p.ColumnBgColor["PRECEDE_PRODUCING_TERM"] | Color.FromArgb(255, 255, 170) | 행/컬럼 값 대입 |  |  |  |
| AC-cc25555b | this.btnSubImport.Click | FP02550_Operation_Bod.cs:884 | if (fps.Name == spdMain.Name) | DATA_OP | p.ColumnBgColor["BUFFER_TIME"] | Color.FromArgb(255, 255, 170) | 행/컬럼 값 대입 |  |  |  |
| AC-f2db63ba | this.btnSubImport.Click | FP02550_Operation_Bod.cs:886 | if (fps.Name == spdMain.Name) | DATA_OP | p.ColumnBgColor["TAT"] | Color.FromArgb(255, 255, 170) | 행/컬럼 값 대입 |  |  |  |
| AC-95e313a3 | this.btnSubImport.Click | FP02550_Operation_Bod.cs:888 | if (fps.Name == spdMain.Name) | DATA_OP | p.ColumnBgColor["OPERATION_LEAD_TIME"] | Color.FromArgb(255, 255, 170) | 행/컬럼 값 대입 |  |  |  |
| AC-a1d2af70 | this.btnSubImport.Click | FP02550_Operation_Bod.cs:889 | if (fps.Name == spdMain.Name) | DATA_OP | p.ColumnBgColor["OPERATION_LEAD_TIME_UOM"] | Color.FromArgb(255, 255, 170) | 행/컬럼 값 대입 |  |  |  |
| AC-f891aa16 | this.btnSubImport.Click | FP02550_Operation_Bod.cs:890 | if (fps.Name == spdMain.Name) | DATA_OP | p.ColumnBgColor["TOLERANCE"] | Color.FromArgb(255, 255, 170) | 행/컬럼 값 대입 |  |  |  |
| AC-80e7bd80 | this.btnSubImport.Click | FP02550_Operation_Bod.cs:891 | if (fps.Name == spdMain.Name) | DATA_OP | p.ColumnBgColor["TOLERANCE_UOM"] | Color.FromArgb(255, 255, 170) | 행/컬럼 값 대입 |  |  |  |
| AC-a1356dfc | this.btnSubImport.Click | FP02550_Operation_Bod.cs:895 | if (fps.Name == spdMain.Name) | UI_PROP | p.DoSearchData | ExcelPopup_Search_Sub_Data | 속성 DoSearchData 설정 |  |  |  |
| AC-835219cb | this.btnSubImport.Click | FP02550_Operation_Bod.cs:896 | if (fps.Name == spdMain.Name) | UI_PROP | p.DoLineCheck | ExcelImport_Sub_RowCheckDelegate | 속성 DoLineCheck 설정 |  |  |  |
| AC-0244bbcd | this.btnSubImport.Click | FP02550_Operation_Bod.cs:897 | if (fps.Name == spdMain.Name) | UI_PROP | p.DoSaveData | ExcelImport_Sub_SaveDataDelegate | 속성 DoSaveData 설정 |  |  |  |
| AC-bbafd8e6 | this.btnSubImport.Click | FP02550_Operation_Bod.cs:898 | if (fps.Name == spdMain.Name) | UI_PROP | p.DoValidationData | ExcelImport_Sub_ValidateDataDelegate | 속성 DoValidationData 설정 |  |  |  |
| AC-b1b2353a | this.btnSubImport.Click | FP02550_Operation_Bod.cs:901 | if (fps.Name == spdMain.Name) | UI_PROP | p.Owner | this | 속성 Owner 설정 |  |  |  |
| AC-8b88eb99 | this.btnSubImport.Click | FP02550_Operation_Bod.cs:902 | if (fps.Name == spdMain.Name) | UI_PROP | p.StartPosition | System.Windows.Forms.FormStartPosition.CenterScreen | 속성 StartPosition 설정 |  |  |  |
| AC-92894434 | this.btnSubImport.Click | FP02550_Operation_Bod.cs:903 | if (fps.Name == spdMain.Name) | POPUP | p.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP02550_Operation_Bod.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cfc3bdf6 | this.Load | FP02550_Operation_Bod.cs:365 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 2, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-10a465ff | this.Load | FP02550_Operation_Bod.cs:366 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-fb953739 | this.Load | FP02550_Operation_Bod.cs:370 |  | GRID_INIT | this.AddSheet | (spdSub, SpdSheet.shtSub, SpdSheet.shtSub, 2, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-e754e0a2 | this.Load | FP02550_Operation_Bod.cs:371 |  | FLAG | siSub | GetSheetInfo(spdSub.Name, SpdSheet.shtSub) | 화면 필드/플래그 변경 |  |  |  |
| AC-2dedf6cf | this.Load | FP02550_Operation_Bod.cs:373 |  | GRID_INIT | siSub.ChangeSheet | (SpdSheet.shtSub) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-915d1f24 | this.Load | FP02550_Operation_Bod.cs:376 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP02550_Operation_Bod.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3ad68b08 | this.Load | FP02550_Operation_Bod.cs:195 |  | UI_PROP | siSub.ImagePopUp | imageList1.Images[0] | 속성 ImagePopUp 설정 |  |  |  |
| AC-3f46be51 | this.Load | FP02550_Operation_Bod.cs:197 |  | FLAG | cellTypeImage | new TextCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-9c35ced6 | this.Load | FP02550_Operation_Bod.cs:198 |  | UI_PROP | cellTypeImage.BackgroundImage | new FarPoint.Win.Picture(siSub.ImagePopUp) | 속성 BackgroundImage 설정 |  |  |  |
| AC-e7b8af1e | this.Load | FP02550_Operation_Bod.cs:199 |  | UI_PROP | cellTypeImage.BackgroundImage.AlignHorz | FarPoint.Win.HorizontalAlignment.Right | 속성 AlignHorz 설정 |  |  |  |
| AC-682e52d7 | this.Load | FP02550_Operation_Bod.cs:204 | if (adminAuth) | STATE | btnSql.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-0484441a | this.Load | FP02550_Operation_Bod.cs:205 | if (adminAuth) | STATE | btnSql.Visible | true | 컨트롤 상태 Visible |  |  |  |
| AC-5640753f | this.Load | FP02550_Operation_Bod.cs:206 | if (adminAuth) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-f067322b | this.Load | FP02550_Operation_Bod.cs:210 | else of (adminAuth) | STATE | btnSql.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-178c92ca | this.Load | FP02550_Operation_Bod.cs:211 | else of (adminAuth) | STATE | btnSql.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-e8456991 | this.Load | FP02550_Operation_Bod.cs:212 | else of (adminAuth) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |

## FP02550_Operation_Bod.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3a9ce148 | DeleteButton | FP02550_Operation_Bod.cs:623 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-45d35ee7 | DeleteButton | FP02550_Operation_Bod.cs:629 | if (fps.Name == "spdMain") ▸ if (spdMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.ActiveRow == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2156892d | DeleteButton | FP02550_Operation_Bod.cs:633 | if (fps.Name == "spdMain") ▸ if (spdMain != null && siMain.IsLock(siMain.SheetName) == false) | DATA_OP | siMain.Delete | () | 데이터 객체 조작/조회 |  |  |  |
| AC-ea718a5c | DeleteButton | FP02550_Operation_Bod.cs:640 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ if (spdSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.Acti… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-12cb74e7 | DeleteButton | FP02550_Operation_Bod.cs:644 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ if (spdSub != null && siSub.IsLock(siSub.SheetName) == false) | DATA_OP | siSub.Delete | () | 데이터 객체 조작/조회 |  |  |  |

## FP02550_Operation_Bod.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a685b976 | Dispose | FP02550_Operation_Bod.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP02550_Operation_Bod.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2d8e8923 | EditButton | FP02550_Operation_Bod.cs:459 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a19e8ecd | EditButton | FP02550_Operation_Bod.cs:465 | if (this.fps != null) ▸ switch (fps.Name) case "spdMain": | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-7158d299 | EditButton | FP02550_Operation_Bod.cs:467 | if (this.fps != null) ▸ switch (fps.Name) case "spdMain": | CALL_EXT | siMain.SwitchLockEx | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-0faab5dc | EditButton | FP02550_Operation_Bod.cs:471 | if (this.fps != null) ▸ switch (fps.Name) case "spdMain": | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.DIVISION_ID), siMain.GetColumnIndex(DefColumns.LINE_ATTR… | 그리드 편집 잠금/해제 |  |  |  |
| AC-cfa68255 | EditButton | FP02550_Operation_Bod.cs:472 | if (this.fps != null) ▸ switch (fps.Name) case "spdMain": | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.PRECEDE_PRODUCING_TERM_UOM), siMain.GetColumnIndex(DefCo… | 그리드 편집 잠금/해제 |  |  |  |
| AC-7e95b9e7 | EditButton | FP02550_Operation_Bod.cs:473 | if (this.fps != null) ▸ switch (fps.Name) case "spdMain": | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.BUFFER_TIME_UOM), siMain.GetColumnIndex(DefColumns.BUFFE… | 그리드 편집 잠금/해제 |  |  |  |
| AC-28f75d35 | EditButton | FP02550_Operation_Bod.cs:474 | if (this.fps != null) ▸ switch (fps.Name) case "spdMain": | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.TAT_UOM), siMain.GetColumnIndex(DefColumns.TAT_UOM), tru… | 그리드 편집 잠금/해제 |  |  |  |
| AC-e0909adb | EditButton | FP02550_Operation_Bod.cs:482 | if (this.fps != null) ▸ switch (fps.Name) case "spdMain": ▸ if (siMain.GetMaxRowIndex() >= 0) ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | siMain.GetBindingRow | (i) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-244339c2 | EditButton | FP02550_Operation_Bod.cs:487 | if (this.fps != null) ▸ switch (fps.Name) case "spdMain": ▸ if (siMain.GetMaxRowIndex() >= 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (sEd… | GRID_SET | siMain.ActiveSheet.Rows[i, i].Locked | true | 그리드 속성/값 설정 |  |  |  |
| AC-19ea619b | EditButton | FP02550_Operation_Bod.cs:492 | if (this.fps != null) ▸ switch (fps.Name) case "spdMain": ▸ if (siMain.GetMaxRowIndex() >= 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (sEd… | GRID_SET | siMain.ActiveSheet.Rows[i].BackColor | ControlColor.AlternatingRow | 그리드 속성/값 설정 |  |  |  |
| AC-f133510e | EditButton | FP02550_Operation_Bod.cs:496 | if (this.fps != null) ▸ switch (fps.Name) case "spdMain": ▸ if (siMain.GetMaxRowIndex() >= 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (sEd… | GRID_SET | siMain.ActiveSheet.Rows[i].BackColor | ControlColor.LockColor | 그리드 속성/값 설정 |  |  |  |
| AC-251a59dd | EditButton | FP02550_Operation_Bod.cs:505 | if (this.fps != null) ▸ switch (fps.Name) case "spdMain": ▸ if (siMain.GetMaxRowIndex() >= 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of… | GRID_STYLE | siMain.SetBGColor | (i, siMain.GetColumnIndex(DefColumns.OPERATION_LOT_SIZE), i, siMain.GetColumnIndex(DefColu… | 그리드 표시 설정 |  |  |  |
| AC-a7caa904 | EditButton | FP02550_Operation_Bod.cs:506 | if (this.fps != null) ▸ switch (fps.Name) case "spdMain": ▸ if (siMain.GetMaxRowIndex() >= 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of… | GRID_STYLE | siMain.SetBGColor | (i, siMain.GetColumnIndex(DefColumns.BUFFER_TIME), i, siMain.GetColumnIndex(DefColumns.BUF… | 그리드 표시 설정 |  |  |  |
| AC-eab06a37 | EditButton | FP02550_Operation_Bod.cs:507 | if (this.fps != null) ▸ switch (fps.Name) case "spdMain": ▸ if (siMain.GetMaxRowIndex() >= 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of… | GRID_STYLE | siMain.SetBGColor | (i, siMain.GetColumnIndex(DefColumns.TAT), i, siMain.GetColumnIndex(DefColumns.TAT), Syste… | 그리드 표시 설정 |  |  |  |
| AC-d6e74fe2 | EditButton | FP02550_Operation_Bod.cs:508 | if (this.fps != null) ▸ switch (fps.Name) case "spdMain": ▸ if (siMain.GetMaxRowIndex() >= 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of… | GRID_STYLE | siMain.SetBGColor | (i, siMain.GetColumnIndex(DefColumns.OPERATION_LEAD_TIME), i, siMain.GetColumnIndex(DefCol… | 그리드 표시 설정 |  |  |  |
| AC-9c56eb9a | EditButton | FP02550_Operation_Bod.cs:512 | if (this.fps != null) ▸ switch (fps.Name) case "spdMain": ▸ if (siMain.GetMaxRowIndex() >= 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of… | GRID_STYLE | siMain.SetBGColor | (i, siMain.GetColumnIndex(DefColumns.OPERATION_LOT_SIZE), i, siMain.GetColumnIndex(DefColu… | 그리드 표시 설정 |  |  |  |
| AC-dc2965a9 | EditButton | FP02550_Operation_Bod.cs:513 | if (this.fps != null) ▸ switch (fps.Name) case "spdMain": ▸ if (siMain.GetMaxRowIndex() >= 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of… | GRID_STYLE | siMain.SetBGColor | (i, siMain.GetColumnIndex(DefColumns.BUFFER_TIME), i, siMain.GetColumnIndex(DefColumns.BUF… | 그리드 표시 설정 |  |  |  |
| AC-4123bf5f | EditButton | FP02550_Operation_Bod.cs:514 | if (this.fps != null) ▸ switch (fps.Name) case "spdMain": ▸ if (siMain.GetMaxRowIndex() >= 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of… | GRID_STYLE | siMain.SetBGColor | (i, siMain.GetColumnIndex(DefColumns.TAT), i, siMain.GetColumnIndex(DefColumns.TAT), Syste… | 그리드 표시 설정 |  |  |  |
| AC-8b656777 | EditButton | FP02550_Operation_Bod.cs:515 | if (this.fps != null) ▸ switch (fps.Name) case "spdMain": ▸ if (siMain.GetMaxRowIndex() >= 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of… | GRID_STYLE | siMain.SetBGColor | (i, siMain.GetColumnIndex(DefColumns.OPERATION_LEAD_TIME), i, siMain.GetColumnIndex(DefCol… | 그리드 표시 설정 |  |  |  |
| AC-1f3b284c | EditButton | FP02550_Operation_Bod.cs:522 | if (this.fps != null) ▸ switch (fps.Name) case "spdMain": ▸ if (siMain.GetMaxRowIndex() >= 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of… | GRID_STYLE | siMain.SetBGColor | (i, 0, i, siMain.GetMaxColumnIndex(), System.Drawing.Color.FromArgb(245, 245, 245)) | 그리드 표시 설정 |  |  |  |
| AC-85970352 | EditButton | FP02550_Operation_Bod.cs:527 | if (this.fps != null) ▸ switch (fps.Name) case "spdMain": ▸ if (siMain.GetMaxRowIndex() >= 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of… | GRID_STYLE | siMain.SetBGColor | (i, 0, i, siMain.GetMaxColumnIndex(), System.Drawing.Color.FromArgb(255, 255, 255)) | 그리드 표시 설정 |  |  |  |
| AC-8f802b6e | EditButton | FP02550_Operation_Bod.cs:538 | if (this.fps != null) ▸ switch (fps.Name) case "spdSub": | FLAG | siSub | GetSheetInfo(spdSub.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-0b60c5fc | EditButton | FP02550_Operation_Bod.cs:540 | if (this.fps != null) ▸ switch (fps.Name) case "spdSub": | GRID_LOCK | siSub.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-57b27d7b | EditButton | FP02550_Operation_Bod.cs:542 | if (this.fps != null) ▸ switch (fps.Name) case "spdSub": | GRID_LOCK | siSub.LockColumn | (siSub.GetColumnIndex(DefColumns.SUB_DIVISION_ID), siSub.GetColumnIndex(DefColumns.SUB_NIC… | 그리드 편집 잠금/해제 |  |  |  |
| AC-1e0fa6c6 | EditButton | FP02550_Operation_Bod.cs:543 | if (this.fps != null) ▸ switch (fps.Name) case "spdSub": | GRID_LOCK | siSub.LockColumn | (siSub.GetColumnIndex(DefColumns.SUB_PRECEDE_PRODUCING_TERM_UOM), siSub.GetColumnIndex(Def… | 그리드 편집 잠금/해제 |  |  |  |
| AC-c3bff238 | EditButton | FP02550_Operation_Bod.cs:544 | if (this.fps != null) ▸ switch (fps.Name) case "spdSub": | GRID_LOCK | siSub.LockColumn | (siSub.GetColumnIndex(DefColumns.SUB_BUFFER_TIME_UOM), siSub.GetColumnIndex(DefColumns.SUB… | 그리드 편집 잠금/해제 |  |  |  |
| AC-784d40f7 | EditButton | FP02550_Operation_Bod.cs:545 | if (this.fps != null) ▸ switch (fps.Name) case "spdSub": | GRID_LOCK | siSub.LockColumn | (siSub.GetColumnIndex(DefColumns.SUB_TAT_UOM), siSub.GetColumnIndex(DefColumns.SUB_TAT_UOM… | 그리드 편집 잠금/해제 |  |  |  |
| AC-ab1de7ec | EditButton | FP02550_Operation_Bod.cs:553 | if (this.fps != null) ▸ switch (fps.Name) case "spdSub": ▸ if (siMain.GetMaxRowIndex() >= 0) ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | siSub.GetBindingRow | (i) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-d7a707e3 | EditButton | FP02550_Operation_Bod.cs:558 | if (this.fps != null) ▸ switch (fps.Name) case "spdSub": ▸ if (siMain.GetMaxRowIndex() >= 0) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ if (sEdit… | GRID_SET | siSub.ActiveSheet.Rows[i, i].Locked | true | 그리드 속성/값 설정 |  |  |  |
| AC-d015e2ce | EditButton | FP02550_Operation_Bod.cs:559 | if (this.fps != null) ▸ switch (fps.Name) case "spdSub": ▸ if (siMain.GetMaxRowIndex() >= 0) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ if (sEdit… | GRID_SET | siSub.ActiveSheet.Rows[i].BackColor | ControlColor.DefaultBackColor | 그리드 속성/값 설정 |  |  |  |

## FP02550_Operation_Bod.Excel_Export

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-17771c89 | ExcelButton | FP02550_Operation_Bod.cs:1088 |  | EXCEL | ExportExcel | () | 엑셀 내보내기/올리기 |  |  |  |

## FP02550_Operation_Bod.ExcelImport_Main_RowCheckDelegate

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d70672f0 | (진입점 미연결) | FP02550_Operation_Bod.cs:971 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## FP02550_Operation_Bod.ExcelImport_Main_SaveDataDelegate

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-914c60bf | (진입점 미연결) | FP02550_Operation_Bod.cs:943 |  | ENDPOINT | DataService.FP_PseudoBatch | ("FP02550_OperationBod","merge_FP02550", data, 0, "Master") ⇒ biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=merge_FP02550] \| FP\Master\FP02… | 엔드포인트 호출 |  |  |  |
| AC-9256722f | (진입점 미연결) | FP02550_Operation_Bod.cs:951 |  | DATA_OP | rds.Tables.Add | (rdt) | 데이터 객체 조작/조회 |  |  |  |
| AC-a3efa1de | (진입점 미연결) | FP02550_Operation_Bod.cs:953 |  | RETURN | return rds; |  | 처리 중단/반환 |  |  |  |

## FP02550_Operation_Bod.ExcelImport_Main_ValidateDataDelegate

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b644f79b | (진입점 미연결) | FP02550_Operation_Bod.cs:960 |  | DATA_OP | column_params.Add | ("USER_ID", UserInfoContext.Current.UserId) | 데이터 객체 조작/조회 |  |  |  |
| AC-a960a62e | (진입점 미연결) | FP02550_Operation_Bod.cs:962 |  | ENDPOINT | DataService.FP_ExecuteNonQuery | ("FP02550_OperationBod", "delete_Excel_buffer", column_params, "MASTER") ⇒ biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=delete_Excel_buffer] \| FP\M… | 엔드포인트 호출 |  |  |  |
| AC-d030f9a4 | (진입점 미연결) | FP02550_Operation_Bod.cs:965 |  | ENDPOINT | DataService.FP_PseudoBatch | ("FP02550_OperationBod", "insert_Excel_buffer", data, 0, "MASTER") ⇒ biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=insert_Excel_buffer] \| FP\MASTE… | 엔드포인트 호출 |  |  |  |
| AC-0b5b671b | (진입점 미연결) | FP02550_Operation_Bod.cs:966 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP02550_OperationBod", "find_Excel_buffer_validation",column_params, "MASTER") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Excel_buffer_validation] \… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-40fe922e | (진입점 미연결) | FP02550_Operation_Bod.cs:966 |  | RETURN | return DataService.FP_ExecuteQuery("FP02550_OperationBod", "find_Excel_buffer_va… |  | 처리 중단/반환 |  |  |  |

## FP02550_Operation_Bod.ExcelImport_Sub_RowCheckDelegate

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7cd6f4a9 | (진입점 미연결) | FP02550_Operation_Bod.cs:1015 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## FP02550_Operation_Bod.ExcelImport_Sub_SaveDataDelegate

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c789fb72 | (진입점 미연결) | FP02550_Operation_Bod.cs:990 |  | ENDPOINT | DataService.FP_PseudoBatch | ("FP02550_OperationBod", "merge_FP02550_Sub", data, 0, "Master") ⇒ biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=merge_FP02550_Sub] \| FP\Master\… | 엔드포인트 호출 |  |  |  |
| AC-6924bbf6 | (진입점 미연결) | FP02550_Operation_Bod.cs:995 |  | DATA_OP | rds.Tables.Add | (rdt) | 데이터 객체 조작/조회 |  |  |  |
| AC-58de91ac | (진입점 미연결) | FP02550_Operation_Bod.cs:997 |  | RETURN | return rds; |  | 처리 중단/반환 |  |  |  |

## FP02550_Operation_Bod.ExcelImport_Sub_ValidateDataDelegate

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-004cad2a | (진입점 미연결) | FP02550_Operation_Bod.cs:1004 |  | DATA_OP | column_params.Add | ("USER_ID", UserInfoContext.Current.UserId) | 데이터 객체 조작/조회 |  |  |  |
| AC-9a6eb9bc | (진입점 미연결) | FP02550_Operation_Bod.cs:1006 |  | ENDPOINT | DataService.FP_ExecuteNonQuery | ("FP02550_OperationBod", "delete_Excel_buffer_sub", column_params, "MASTER") ⇒ biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=delete_Excel_buffer_sub] \| … | 엔드포인트 호출 |  |  |  |
| AC-bd9433c7 | (진입점 미연결) | FP02550_Operation_Bod.cs:1009 |  | ENDPOINT | DataService.FP_PseudoBatch | ("FP02550_OperationBod", "insert_Excel_buffer_sub", data, 0, "MASTER") ⇒ biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=insert_Excel_buffer_sub] \| FP\M… | 엔드포인트 호출 |  |  |  |
| AC-79a41c7d | (진입점 미연결) | FP02550_Operation_Bod.cs:1010 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP02550_OperationBod", "find_Excel_buffer_validation_sub", column_params, "MASTER") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Excel_buffer_validation_su… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-b9dbaad0 | (진입점 미연결) | FP02550_Operation_Bod.cs:1010 |  | RETURN | return DataService.FP_ExecuteQuery("FP02550_OperationBod", "find_Excel_buffer_va… |  | 처리 중단/반환 |  |  |  |

## FP02550_Operation_Bod.ExcelPopup_Search_Data

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f925fe5d | (진입점 미연결) | FP02550_Operation_Bod.cs:926 |  | RETURN | return dsData; |  | 처리 중단/반환 |  |  |  |

## FP02550_Operation_Bod.ExcelPopup_Search_Sub_Data

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c6e2104d | (진입점 미연결) | FP02550_Operation_Bod.cs:977 |  | FLAG | _search | GetSearchCondition(iClickRow) | 화면 필드/플래그 변경 |  |  |  |
| AC-b4311fb8 | (진입점 미연결) | FP02550_Operation_Bod.cs:981 |  | RETURN | return dsData; |  | 처리 중단/반환 |  |  |  |

## FP02550_Operation_Bod.Find_Data_Main

진입점: this.btnExcelUpload.Click [if (fps.Name == spdMain.Name) ▸ if (p.SaveSuccess == true) ▸ try ▸ lambda] / popSql.OnSql [if (programID == "SELECT_MAIN")] / FindButton [try ▸ lambda] / SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ try ▸ lambda] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f2ea09db | this.btnExcelUpload.Click [if (fps.Name == spdMain.Name) ▸ i… 외 4 | FP02550_Operation_Bod.cs:1190 |  | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { //콤보별 셋팅값 구하기 pCompanyID = string.Empty; pDivisionID = CS… | ⚠ 의미 확인 필요 |  |  |  |
| AC-540f9546 | this.btnExcelUpload.Click [if (fps.Name == spdMain.Name) ▸ i… 외 4 | FP02550_Operation_Bod.cs:1195 | lambda | FLAG | pDivisionID | CString.GetCheckedListValue(dtDivision, clbDivision.ControlValues,true) | 화면 필드/플래그 변경 |  |  |  |
| AC-89dcfb86 | this.btnExcelUpload.Click [if (fps.Name == spdMain.Name) ▸ i… 외 4 | FP02550_Operation_Bod.cs:1196 | lambda | FLAG | pSiteID | CString.GetCheckedListValue(dtSite, clbSite.ControlValues, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-08d6dfdc | this.btnExcelUpload.Click [if (fps.Name == spdMain.Name) ▸ i… 외 4 | FP02550_Operation_Bod.cs:1197 | lambda | FLAG | pPlantID | CString.GetCheckedListValue(dtPlant, clbPlant.ControlValues, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-f3b3f860 | this.btnExcelUpload.Click [if (fps.Name == spdMain.Name) ▸ i… 외 4 | FP02550_Operation_Bod.cs:1198 | lambda | FLAG | pFactoryID | CString.GetCheckedListValue(dtFactory, clbFactory.ControlValues, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-68e0aa7e | this.btnExcelUpload.Click [if (fps.Name == spdMain.Name) ▸ i… 외 4 | FP02550_Operation_Bod.cs:1199 | lambda | FLAG | pOperationID | CString.GetCheckedListValue(dtOperation, clbOperation.ControlValues, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-05bca465 | this.btnExcelUpload.Click [if (fps.Name == spdMain.Name) ▸ i… 외 4 | FP02550_Operation_Bod.cs:1208 | try | ENDPOINT | new FoxDataRequest | ("FP_Master.PR_UI_FP02550_OPERATION_BOD") ⇒ FP_Master.PR_UI_FP02550_OPERATION_BOD | 엔드포인트 요청 생성 |  |  |  |
| AC-3fa4e071 | this.btnExcelUpload.Click [if (fps.Name == spdMain.Name) ▸ i… 외 4 | FP02550_Operation_Bod.cs:1209 | try | DATA_OP | request.Parameters["p_sys_type"] | pSysType | 행/컬럼 값 대입 |  |  |  |
| AC-ba817f15 | this.btnExcelUpload.Click [if (fps.Name == spdMain.Name) ▸ i… 외 4 | FP02550_Operation_Bod.cs:1210 | try | DATA_OP | request.Parameters["p_sys_flag"] | "MAIN" | 행/컬럼 값 대입 |  |  |  |
| AC-2c6d9967 | this.btnExcelUpload.Click [if (fps.Name == spdMain.Name) ▸ i… 외 4 | FP02550_Operation_Bod.cs:1211 | try | DATA_OP | request.Parameters["p_sys_gubun"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-6bfaf767 | this.btnExcelUpload.Click [if (fps.Name == spdMain.Name) ▸ i… 외 4 | FP02550_Operation_Bod.cs:1212 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-6db4c7d7 | this.btnExcelUpload.Click [if (fps.Name == spdMain.Name) ▸ i… 외 4 | FP02550_Operation_Bod.cs:1214 | try | DATA_OP | request.Parameters["p_company_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-361eb863 | this.btnExcelUpload.Click [if (fps.Name == spdMain.Name) ▸ i… 외 4 | FP02550_Operation_Bod.cs:1215 | try | DATA_OP | request.Parameters["p_division_id"] | pDivisionID.Equals("ALL") ? DBNull.Value : pDivisionID | 행/컬럼 값 대입 |  |  |  |
| AC-65ae24da | this.btnExcelUpload.Click [if (fps.Name == spdMain.Name) ▸ i… 외 4 | FP02550_Operation_Bod.cs:1216 | try | DATA_OP | request.Parameters["p_site_id"] | pSiteID.Equals("ALL") ? DBNull.Value : pSiteID | 행/컬럼 값 대입 |  |  |  |
| AC-55f494d5 | this.btnExcelUpload.Click [if (fps.Name == spdMain.Name) ▸ i… 외 4 | FP02550_Operation_Bod.cs:1217 | try | DATA_OP | request.Parameters["p_plant_id"] | pPlantID.Equals("ALL") ? DBNull.Value : pPlantID | 행/컬럼 값 대입 |  |  |  |
| AC-a7e13113 | this.btnExcelUpload.Click [if (fps.Name == spdMain.Name) ▸ i… 외 4 | FP02550_Operation_Bod.cs:1218 | try | DATA_OP | request.Parameters["p_factory_id"] | pFactoryID.Equals("ALL") ? DBNull.Value : pFactoryID | 행/컬럼 값 대입 |  |  |  |
| AC-5429f3a7 | this.btnExcelUpload.Click [if (fps.Name == spdMain.Name) ▸ i… 외 4 | FP02550_Operation_Bod.cs:1219 | try | DATA_OP | request.Parameters["p_operation_id"] | pOperationID.Equals("ALL") ? DBNull.Value : pOperationID | 행/컬럼 값 대입 |  |  |  |
| AC-f5a9127f | this.btnExcelUpload.Click [if (fps.Name == spdMain.Name) ▸ i… 외 4 | FP02550_Operation_Bod.cs:1220 | try | DATA_OP | request.Parameters["p_item_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-8d2cda8a | this.btnExcelUpload.Click [if (fps.Name == spdMain.Name) ▸ i… 외 4 | FP02550_Operation_Bod.cs:1221 | try | DATA_OP | request.Parameters["p_nick_name"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-9056c4ef | this.btnExcelUpload.Click [if (fps.Name == spdMain.Name) ▸ i… 외 4 | FP02550_Operation_Bod.cs:1222 | try | DATA_OP | request.Parameters["p_model_type"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-eb6e6f61 | this.btnExcelUpload.Click [if (fps.Name == spdMain.Name) ▸ i… 외 4 | FP02550_Operation_Bod.cs:1223 | try | DATA_OP | request.Parameters["p_line_attr"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-35704adc | this.btnExcelUpload.Click [if (fps.Name == spdMain.Name) ▸ i… 외 4 | FP02550_Operation_Bod.cs:1225 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-005e8ae1 | this.btnExcelUpload.Click [if (fps.Name == spdMain.Name) ▸ i… 외 4 | FP02550_Operation_Bod.cs:1227 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-9b10a1d8 | this.btnExcelUpload.Click [if (fps.Name == spdMain.Name) ▸ i… 외 4 | FP02550_Operation_Bod.cs:1232 | catch ((Exception e)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-51262f79 | this.btnExcelUpload.Click [if (fps.Name == spdMain.Name) ▸ i… 외 4 | FP02550_Operation_Bod.cs:1236 | finally | FLAG | iClickRow | 0 | 화면 필드/플래그 변경 |  |  |  |

## FP02550_Operation_Bod.Find_Data_Sub

진입점: this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >= 0)] / this.btnExcelUpload.Click [if (fps.Name == spdMain.Name) ▸ if (p.SaveSuccess == true) ▸ finally ▸ if (siMain.ActiveSheet.RowCount > 0)] / this.btnSearchAll.Click / this.btnSubImport.Click [if (fps.Name == spdMain.Name) ▸ if (p.SaveSuccess == true)] / FindButton [finally ▸ if (siMain.ActiveSheet.RowCount > 0)] / SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ if (siSub != null && siMain.IsLock(siSub.SheetName) == false) ▸ try ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (ds.Tables[0].Rows[0][0].ToStr…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2fb304b6 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 5 | FP02550_Operation_Bod.cs:1246 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-f401fd7b | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 5 | FP02550_Operation_Bod.cs:1251 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-ff6226e3 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 5 | FP02550_Operation_Bod.cs:1251 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-fb425178 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 5 | FP02550_Operation_Bod.cs:1257 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-06cc4835 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 5 | FP02550_Operation_Bod.cs:1268 | try | GRID_BIND | siSub.Query | (ds, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-c1ad60eb | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 5 | FP02550_Operation_Bod.cs:1269 | try | GRID_LOCK | siSub.LockColumn | (0, siSub.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-a2393038 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 5 | FP02550_Operation_Bod.cs:1272 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-1c074668 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 5 | FP02550_Operation_Bod.cs:1275 | try | GRID_INIT | siSub.VisibleAlternatingRow | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-3dd3546f | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 5 | FP02550_Operation_Bod.cs:1286 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## FP02550_Operation_Bod.Find_Data_Sub_Execute

진입점: this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >= 0) ▸ try] / this.btnExcelUpload.Click [if (fps.Name == spdMain.Name) ▸ if (p.SaveSuccess == true) ▸ finally ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ try] / this.btnSearchAll.Click [try] / this.btnSubImport.Click [if (fps.Name == spdMain.Name) ▸ if (p.SaveSuccess == true) ▸ try] / FindButton [finally ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ try] / SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ if (siSub != null && siMain.IsLock(siSub.SheetName) == false) ▸ try ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0b2c8598 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 6 | FP02550_Operation_Bod.cs:1312 | try ▸ if (queryFlag.Equals("SUB")) | FLAG | pDivisionID | search.DIVISION_ID | 화면 필드/플래그 변경 |  |  |  |
| AC-46c27e7e | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 6 | FP02550_Operation_Bod.cs:1313 | try ▸ if (queryFlag.Equals("SUB")) | FLAG | pSiteID | search.SITE_ID | 화면 필드/플래그 변경 |  |  |  |
| AC-75ca1989 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 6 | FP02550_Operation_Bod.cs:1314 | try ▸ if (queryFlag.Equals("SUB")) | FLAG | pPlantID | search.PLANT_ID | 화면 필드/플래그 변경 |  |  |  |
| AC-fccfe505 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 6 | FP02550_Operation_Bod.cs:1315 | try ▸ if (queryFlag.Equals("SUB")) | FLAG | pFactoryID | search.FACTORY_ID | 화면 필드/플래그 변경 |  |  |  |
| AC-2089c750 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 6 | FP02550_Operation_Bod.cs:1316 | try ▸ if (queryFlag.Equals("SUB")) | FLAG | pOperationID | search.OPERATION_ID | 화면 필드/플래그 변경 |  |  |  |
| AC-f455103b | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 6 | FP02550_Operation_Bod.cs:1335 | try | ENDPOINT | new FoxDataRequest | ("FP_Master.PR_UI_FP02550_OPERATION_BOD") ⇒ FP_Master.PR_UI_FP02550_OPERATION_BOD | 엔드포인트 요청 생성 |  |  |  |
| AC-5e506dab | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 6 | FP02550_Operation_Bod.cs:1336 | try | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-d1ea7cd5 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 6 | FP02550_Operation_Bod.cs:1337 | try | DATA_OP | request.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-97a17e3a | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 6 | FP02550_Operation_Bod.cs:1338 | try | DATA_OP | request.Parameters["p_sys_flag"] | queryFlag | 행/컬럼 값 대입 |  |  |  |
| AC-fb3b9b80 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 6 | FP02550_Operation_Bod.cs:1339 | try | DATA_OP | request.Parameters["p_sys_gubun"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-48cb7bdf | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 6 | FP02550_Operation_Bod.cs:1340 | try | DATA_OP | request.Parameters["p_user_id"] | sUserId | 행/컬럼 값 대입 |  |  |  |
| AC-c15fd864 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 6 | FP02550_Operation_Bod.cs:1342 | try | DATA_OP | request.Parameters["p_company_id"] | pCompanyID.Equals("ALL") ? DBNull.Value : pCompanyID | 행/컬럼 값 대입 |  |  |  |
| AC-c7258ed6 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 6 | FP02550_Operation_Bod.cs:1343 | try | DATA_OP | request.Parameters["p_division_id"] | pDivisionID.Equals("ALL") ? DBNull.Value : pDivisionID | 행/컬럼 값 대입 |  |  |  |
| AC-0865d154 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 6 | FP02550_Operation_Bod.cs:1344 | try | DATA_OP | request.Parameters["p_site_id"] | pSiteID.Equals("ALL") ? DBNull.Value : pSiteID | 행/컬럼 값 대입 |  |  |  |
| AC-292f87c6 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 6 | FP02550_Operation_Bod.cs:1345 | try | DATA_OP | request.Parameters["p_plant_id"] | pPlantID.Equals("ALL") ? DBNull.Value : pPlantID | 행/컬럼 값 대입 |  |  |  |
| AC-9dca3090 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 6 | FP02550_Operation_Bod.cs:1346 | try | DATA_OP | request.Parameters["p_factory_id"] | pFactoryID.Equals("ALL") ? DBNull.Value : pFactoryID | 행/컬럼 값 대입 |  |  |  |
| AC-97ce76e5 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 6 | FP02550_Operation_Bod.cs:1347 | try | DATA_OP | request.Parameters["p_operation_id"] | pOperationID.Equals("ALL") ? DBNull.Value : pOperationID | 행/컬럼 값 대입 |  |  |  |
| AC-c8908321 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 6 | FP02550_Operation_Bod.cs:1348 | try | DATA_OP | request.Parameters["p_item_id"] | pItemId.Equals("ALL") ? DBNull.Value : pItemId | 행/컬럼 값 대입 |  |  |  |
| AC-8128affb | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 6 | FP02550_Operation_Bod.cs:1349 | try | DATA_OP | request.Parameters["p_nick_name"] | pNickName.Equals("ALL") ? DBNull.Value : pNickName | 행/컬럼 값 대입 |  |  |  |
| AC-928e05e0 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 6 | FP02550_Operation_Bod.cs:1350 | try | DATA_OP | request.Parameters["p_model_type"] | pModelType.Equals("ALL") ? DBNull.Value : pModelType | 행/컬럼 값 대입 |  |  |  |
| AC-fc92c165 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 6 | FP02550_Operation_Bod.cs:1351 | try | DATA_OP | request.Parameters["p_line_attr"] | pLineAttr.Equals("ALL") ? DBNull.Value : pLineAttr | 행/컬럼 값 대입 |  |  |  |
| AC-c4d6ceb9 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 6 | FP02550_Operation_Bod.cs:1353 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-f78e0335 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 6 | FP02550_Operation_Bod.cs:1355 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-8b87dbec | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 6 | FP02550_Operation_Bod.cs:1362 | catch ((Exception)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FP02550_Operation_Bod.Find_Main

진입점: this.btnExcelUpload.Click [if (fps.Name == spdMain.Name) ▸ if (p.SaveSuccess == true)] / FindButton / SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-07511935 | this.btnExcelUpload.Click [if (fps.Name == spdMain.Name) ▸ i… 외 2 | FP02550_Operation_Bod.cs:1097 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-8bcfa82a | this.btnExcelUpload.Click [if (fps.Name == spdMain.Name) ▸ i… 외 2 | FP02550_Operation_Bod.cs:1101 | try | CALL_EXT | spdMain.GetViewportTopRow | (0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d145637b | this.btnExcelUpload.Click [if (fps.Name == spdMain.Name) ▸ i… 외 2 | FP02550_Operation_Bod.cs:1104 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-5781ad3e | this.btnExcelUpload.Click [if (fps.Name == spdMain.Name) ▸ i… 외 2 | FP02550_Operation_Bod.cs:1104 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a0cdfaed | this.btnExcelUpload.Click [if (fps.Name == spdMain.Name) ▸ i… 외 2 | FP02550_Operation_Bod.cs:1108 | try ▸ if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-526c0025 | this.btnExcelUpload.Click [if (fps.Name == spdMain.Name) ▸ i… 외 2 | FP02550_Operation_Bod.cs:1109 | try ▸ if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-bb3ea150 | this.btnExcelUpload.Click [if (fps.Name == spdMain.Name) ▸ i… 외 2 | FP02550_Operation_Bod.cs:1112 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-95421bf2 | this.btnExcelUpload.Click [if (fps.Name == spdMain.Name) ▸ i… 외 2 | FP02550_Operation_Bod.cs:1118 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-4450db21 | this.btnExcelUpload.Click [if (fps.Name == spdMain.Name) ▸ i… 외 2 | FP02550_Operation_Bod.cs:1123 | try | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtMain) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-08026008 | this.btnExcelUpload.Click [if (fps.Name == spdMain.Name) ▸ i… 외 2 | FP02550_Operation_Bod.cs:1129 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-44bbf46b | this.btnExcelUpload.Click [if (fps.Name == spdMain.Name) ▸ i… 외 2 | FP02550_Operation_Bod.cs:1130 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => Find_Data_Main("SELECT") ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-b93df0ba | this.btnExcelUpload.Click [if (fps.Name == spdMain.Name) ▸ i… 외 2 | FP02550_Operation_Bod.cs:1142 | try ▸ if (ds.Tables[0].Rows.Count > 0) | GRID_BIND | siMain.Query | (ds,true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-ed29830c | this.btnExcelUpload.Click [if (fps.Name == spdMain.Name) ▸ i… 외 2 | FP02550_Operation_Bod.cs:1144 | try ▸ if (ds.Tables[0].Rows.Count > 0) | CALL_EXT | siMain.InitFormat | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-a2a3cb30 | this.btnExcelUpload.Click [if (fps.Name == spdMain.Name) ▸ i… 외 2 | FP02550_Operation_Bod.cs:1145 | try ▸ if (ds.Tables[0].Rows.Count > 0) | CALL_EXT | siMain.SetFormat | ("#,##0.#####", 8, 14, false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-5d9d91e4 | this.btnExcelUpload.Click [if (fps.Name == spdMain.Name) ▸ i… 외 2 | FP02550_Operation_Bod.cs:1148 | try ▸ if (ds.Tables[0].Rows.Count > 0) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-155a7fd0 | this.btnExcelUpload.Click [if (fps.Name == spdMain.Name) ▸ i… 외 2 | FP02550_Operation_Bod.cs:1151 | try ▸ if (ds.Tables[0].Rows.Count > 0) | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-25bebf13 | this.btnExcelUpload.Click [if (fps.Name == spdMain.Name) ▸ i… 외 2 | FP02550_Operation_Bod.cs:1154 | try ▸ if (ds.Tables[0].Rows.Count > 0) | GRID_INIT | siMain.VisibleAlternatingRow | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-c338021f | this.btnExcelUpload.Click [if (fps.Name == spdMain.Name) ▸ i… 외 2 | FP02550_Operation_Bod.cs:1162 | try ▸ if (ds.Tables[0].Rows.Count > 0) | GRID_STYLE | spdMain.SetViewportTopRow | (0, iTopRow) | 그리드 표시 설정 |  |  |  |
| AC-8c53c6fa | this.btnExcelUpload.Click [if (fps.Name == spdMain.Name) ▸ i… 외 2 | FP02550_Operation_Bod.cs:1169 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-4375a770 | this.btnExcelUpload.Click [if (fps.Name == spdMain.Name) ▸ i… 외 2 | FP02550_Operation_Bod.cs:1170 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-f31fe04c | this.btnExcelUpload.Click [if (fps.Name == spdMain.Name) ▸ i… 외 2 | FP02550_Operation_Bod.cs:1171 | finally | GRID_SET | this.spdMain.ActiveSheet.Columns.Get(0).Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-ab125873 | this.btnExcelUpload.Click [if (fps.Name == spdMain.Name) ▸ i… 외 2 | FP02550_Operation_Bod.cs:1171 | finally | CALL_EXT | this.spdMain.ActiveSheet.Columns.Get | (0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-60c846d7 | this.btnExcelUpload.Click [if (fps.Name == spdMain.Name) ▸ i… 외 2 | FP02550_Operation_Bod.cs:1173 | finally | GRID_CLEAR | SpreadInfo.ClearDataSource | (siSub.SpreadObject) | 그리드 데이터/선택 비움 |  |  |  |

## FP02550_Operation_Bod.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5b0f6024 | this.Load | FP02550_Operation_Bod.cs:162 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP02550_Operation_Bod.GetSearchCondition

진입점: this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >= 0)] / this.btnExcelUpload.Click [if (fps.Name == spdMain.Name) ▸ if (p.SaveSuccess == true) ▸ finally ▸ if (siMain.ActiveSheet.RowCount > 0)] / this.btnSubImport.Click [if (fps.Name == spdMain.Name) ▸ if (p.SaveSuccess == true)] / FindButton [finally ▸ if (siMain.ActiveSheet.RowCount > 0)] / SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ if (siSub != null && siMain.IsLock(siSub.SheetName) == false) ▸ try ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS")] / (진입…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-939278b2 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 5 | FP02550_Operation_Bod.cs:1941 |  | DATA_OP | siMain.GetBindingRow | (row) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-455d89ca | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 5 | FP02550_Operation_Bod.cs:1943 |  | CALL_EXT | _search.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-e44b7648 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 5 | FP02550_Operation_Bod.cs:1945 |  | UI_PROP | _search.COMPANY_ID | dRow["COMPANY_ID"] as string | 속성 COMPANY_ID 설정 |  |  |  |
| AC-11e5f4b6 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 5 | FP02550_Operation_Bod.cs:1946 |  | UI_PROP | _search.DIVISION_ID | dRow["DIVISION_ID"] as string | 속성 DIVISION_ID 설정 |  |  |  |
| AC-5225805f | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 5 | FP02550_Operation_Bod.cs:1947 |  | UI_PROP | _search.SITE_ID | dRow["SITE_ID"] as string | 속성 SITE_ID 설정 |  |  |  |
| AC-16c8ba99 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 5 | FP02550_Operation_Bod.cs:1948 |  | UI_PROP | _search.PLANT_ID | dRow["PLANT_ID"] as string | 속성 PLANT_ID 설정 |  |  |  |
| AC-fe257806 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 5 | FP02550_Operation_Bod.cs:1949 |  | UI_PROP | _search.FACTORY_ID | dRow["FACTORY_ID"] as string | 속성 FACTORY_ID 설정 |  |  |  |
| AC-b946f2b7 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 5 | FP02550_Operation_Bod.cs:1950 |  | UI_PROP | _search.OPERATION_ID | dRow["OPERATION_ID"] as string | 속성 OPERATION_ID 설정 |  |  |  |
| AC-94aded1e | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 5 | FP02550_Operation_Bod.cs:1951 |  | UI_PROP | _search.MODEL_TYPE | dRow["MODEL_TYPE"] as string | 속성 MODEL_TYPE 설정 |  |  |  |
| AC-2e50e2da | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 5 | FP02550_Operation_Bod.cs:1952 |  | UI_PROP | _search.LINE_ATTR | dRow["LINE_ATTR_1"] as string | 속성 LINE_ATTR 설정 |  |  |  |
| AC-1341a187 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 5 | FP02550_Operation_Bod.cs:1953 |  | UI_PROP | _search.EXCEL_VIEW | string.Empty | 속성 EXCEL_VIEW 설정 |  |  |  |
| AC-f7ad0db2 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 5 | FP02550_Operation_Bod.cs:1955 |  | RETURN | return _search; |  | 처리 중단/반환 |  |  |  |

## FP02550_Operation_Bod.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2e1db123 | this.Load | FP02550_Operation_Bod.cs:222 | try | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-bde6a1ef | this.Load | FP02550_Operation_Bod.cs:228 | try | FLAG | _sNonAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-385e0540 | this.Load | FP02550_Operation_Bod.cs:229 | try | FLAG | _sSaveAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-c89ba43e | this.Load | FP02550_Operation_Bod.cs:234 | try | FLAG | dtDivision | Data_FP.Common_FP(Data_FP.Type.DIVISION, false, UserInfoContext.Current.UserId, _sNonAuth,… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 화면 필드/플래그 변경 |  |  |  |
| AC-6270c078 | this.Load | FP02550_Operation_Bod.cs:234 | try | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.DIVISION, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth) ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-0606504a | this.Load | FP02550_Operation_Bod.cs:235 | try | LIST_REBIND | clsCtrl.setListBox | (dtDivision, clbDivision, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-771c8270 | this.Load | FP02550_Operation_Bod.cs:237 | try | FLAG | dtUom | Data_FP.Common_FP(Data_FP.Type.LOOKUP_CODE, false, UserInfoContext.Current.UserId, _sNonAu… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=LOOKUP_CODE] | 화면 필드/플래그 변경 |  |  |  |
| AC-95c0334b | this.Load | FP02550_Operation_Bod.cs:237 | try | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.LOOKUP_CODE, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth , … ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=LOOKUP_CODE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-d0a7aa12 | this.Load | FP02550_Operation_Bod.cs:242 | try | FLAG | dtBufferTimeUom | Data_FP.Common_FP(Data_FP.Type.LOOKUP_CODE, false, UserInfoContext.Current.UserId, _sNonAu… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=LOOKUP_CODE] | 화면 필드/플래그 변경 |  |  |  |
| AC-51413bad | this.Load | FP02550_Operation_Bod.cs:242 | try | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.LOOKUP_CODE, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth , … ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=LOOKUP_CODE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-8d4dff88 | this.Load | FP02550_Operation_Bod.cs:247 | try | FLAG | dtLeadTimeUom | Data_FP.Common_FP(Data_FP.Type.LOOKUP_CODE, false, UserInfoContext.Current.UserId, _sNonAu… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=LOOKUP_CODE] | 화면 필드/플래그 변경 |  |  |  |
| AC-5759183a | this.Load | FP02550_Operation_Bod.cs:247 | try | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.LOOKUP_CODE, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth , … ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=LOOKUP_CODE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-8712c076 | this.Load | FP02550_Operation_Bod.cs:251 | try | FLAG | dtLotSizeUom | Data_FP.Common_FP(Data_FP.Type.LOOKUP_CODE, false, UserInfoContext.Current.UserId, _sNonAu… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=LOOKUP_CODE] | 화면 필드/플래그 변경 |  |  |  |
| AC-0d942bf0 | this.Load | FP02550_Operation_Bod.cs:251 | try | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.LOOKUP_CODE, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth , … ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=LOOKUP_CODE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ce3c8a5f | this.Load | FP02550_Operation_Bod.cs:256 | try | FLAG | dtOperationLeadTimeUom | new DataTable("Table") | 화면 필드/플래그 변경 |  |  |  |
| AC-d77ab2b5 | this.Load | FP02550_Operation_Bod.cs:257 | try | DATA_OP | dtOperationLeadTimeUom.Columns.Add | ("CODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-2df8735f | this.Load | FP02550_Operation_Bod.cs:258 | try | DATA_OP | dtOperationLeadTimeUom.Columns.Add | ("NAME") | 데이터 객체 조작/조회 |  |  |  |
| AC-2543fde8 | this.Load | FP02550_Operation_Bod.cs:260 | try | DATA_OP | dtOperationLeadTimeUom.Rows.Add | ("HOUR", "HOUR") | 데이터 객체 조작/조회 |  |  |  |
| AC-405e0745 | this.Load | FP02550_Operation_Bod.cs:261 | try | DATA_OP | dtOperationLeadTimeUom.Rows.Add | ("MINUTE", "MINUTE") | 데이터 객체 조작/조회 |  |  |  |
| AC-fe00af3d | this.Load | FP02550_Operation_Bod.cs:262 | try | DATA_OP | dtOperationLeadTimeUom.Rows.Add | ("DAY", "DAY") | 데이터 객체 조작/조회 |  |  |  |
| AC-2289b2f5 | this.Load | FP02550_Operation_Bod.cs:264 | try | FLAG | dtToleranceUom | new DataTable("Table") | 화면 필드/플래그 변경 |  |  |  |
| AC-649c86d7 | this.Load | FP02550_Operation_Bod.cs:265 | try | DATA_OP | dtToleranceUom.Columns.Add | ("CODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-be13aaea | this.Load | FP02550_Operation_Bod.cs:266 | try | DATA_OP | dtToleranceUom.Columns.Add | ("NAME") | 데이터 객체 조작/조회 |  |  |  |
| AC-02d979ff | this.Load | FP02550_Operation_Bod.cs:268 | try | DATA_OP | dtToleranceUom.Rows.Add | ("HOUR", "HOUR") | 데이터 객체 조작/조회 |  |  |  |
| AC-d2dcb778 | this.Load | FP02550_Operation_Bod.cs:269 | try | DATA_OP | dtToleranceUom.Rows.Add | ("MINUTE", "MINUTE") | 데이터 객체 조작/조회 |  |  |  |
| AC-d52425c5 | this.Load | FP02550_Operation_Bod.cs:280 | catch ((Exception ex)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FP02550_Operation_Bod.InitEvent

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bcc8d4f6 | this.Load | FP02550_Operation_Bod.cs:178 |  | UI_PROP | clbDivision.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-070ac3e8 | this.Load | FP02550_Operation_Bod.cs:179 |  | UI_PROP | clbPlant.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-cacfabeb | this.Load | FP02550_Operation_Bod.cs:180 |  | UI_PROP | clbFactory.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-66ae08be | this.Load | FP02550_Operation_Bod.cs:181 |  | UI_PROP | clbSite.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-593db470 | this.Load | FP02550_Operation_Bod.cs:182 |  | UI_PROP | clbOperation.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |

## FP02550_Operation_Bod.InitSpread

진입점: this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >= 0) ▸ try] / this.btnExcelUpload.Click [if (fps.Name == spdMain.Name) ▸ if (p.SaveSuccess == true) ▸ finally ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ try] / this.btnSearchAll.Click [try] / this.btnSubImport.Click [if (fps.Name == spdMain.Name) ▸ if (p.SaveSuccess == true) ▸ try] / this.Load / FindButton [finally ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ try] / SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ if (siSub != null && siMain.IsLock(siSub.SheetName) == false) ▸ try ▸ if (siSub.SheetName == SpdSheet.s…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-42fb73bf | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 6 | FP02550_Operation_Bod.cs:387 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.InitSheet | (spreadInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-204df574 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 6 | FP02550_Operation_Bod.cs:389 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.SetSheetHeaderColumn_FP | (spreadInfo, 2) | 그리드 재구성/초기화 |  |  |  |
| AC-fb2548b9 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 6 | FP02550_Operation_Bod.cs:395 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.InitSheet | (spreadInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-78a2036a | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 6 | FP02550_Operation_Bod.cs:397 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.SetSheetHeaderColumn_FP | (spreadInfo, 2) | 그리드 재구성/초기화 |  |  |  |
| AC-237b3f73 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 6 | FP02550_Operation_Bod.cs:436 |  | CALL_EXT | spreadInfo.SetColumnCombo | ("LOT_SIZE_UOM", dtLotSizeUom) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c70330d3 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 6 | FP02550_Operation_Bod.cs:437 |  | CALL_EXT | spreadInfo.SetColumnCombo | ("TRANSFER_LOT_SIZE_UOM", dtLotSizeUom) | ⚠ 의미 확인 필요 |  |  |  |
| AC-2b41ff10 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 6 | FP02550_Operation_Bod.cs:441 |  | CALL_EXT | spreadInfo.SetColumnCombo | ("OPERATION_LEAD_TIME_UOM", dtOperationLeadTimeUom) | ⚠ 의미 확인 필요 |  |  |  |
| AC-512052e0 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 6 | FP02550_Operation_Bod.cs:442 |  | CALL_EXT | spreadInfo.SetColumnCombo | ("TOLERANCE_UOM", dtToleranceUom) | ⚠ 의미 확인 필요 |  |  |  |

## FP02550_Operation_Bod.Insert_Row_Sub

진입점: InsertButton [try ▸ else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d4a5704a | InsertButton [try ▸ else of (fps.Name == "spdMain") ▸ if (fp… | FP02550_Operation_Bod.cs:1046 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) | DATA_OP | siSub.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-751dea63 | InsertButton [try ▸ else of (fps.Name == "spdMain") ▸ if (fp… | FP02550_Operation_Bod.cs:1053 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) | GRID_SET | siSub.ActiveSheet.Cells[iRow, siSub.GetColumnIndex(DefColumns.SUB_ITEM_ID)].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-f0bc355f | InsertButton [try ▸ else of (fps.Name == "spdMain") ▸ if (fp… | FP02550_Operation_Bod.cs:1056 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) | GRID_LOCK | siSub.LockRange | (insCell, siSub.GetColumnIndex(DefColumns.SUB_PLANT_ID), siSub.GetColumnIndex(DefColumns.S… | 그리드 편집 잠금/해제 |  |  |  |
| AC-ea0d1778 | InsertButton [try ▸ else of (fps.Name == "spdMain") ▸ if (fp… | FP02550_Operation_Bod.cs:1057 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) | GRID_LOCK | siSub.LockRange | (insCell, siSub.GetColumnIndex(DefColumns.SUB_PRECEDE_PRODUCING_TERM_UOM), siSub.GetColumn… | 그리드 편집 잠금/해제 |  |  |  |
| AC-15a017d4 | InsertButton [try ▸ else of (fps.Name == "spdMain") ▸ if (fp… | FP02550_Operation_Bod.cs:1058 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) | GRID_LOCK | siSub.LockRange | (insCell, siSub.GetColumnIndex(DefColumns.SUB_BUFFER_TIME_UOM), siSub.GetColumnIndex(DefCo… | 그리드 편집 잠금/해제 |  |  |  |
| AC-9cb4f2be | InsertButton [try ▸ else of (fps.Name == "spdMain") ▸ if (fp… | FP02550_Operation_Bod.cs:1059 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) | GRID_LOCK | siSub.LockRange | (insCell, siSub.GetColumnIndex(DefColumns.SUB_TAT_UOM), siSub.GetColumnIndex(DefColumns.TA… | 그리드 편집 잠금/해제 |  |  |  |
| AC-b418edeb | InsertButton [try ▸ else of (fps.Name == "spdMain") ▸ if (fp… | FP02550_Operation_Bod.cs:1061 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) | GRID_SET | siSub.SetText | (iRow, siSub.GetColumnIndex(DefColumns.SUB_COMPANY_ID), _search.COMPANY_ID.ToString()) | 그리드 값 설정 |  |  |  |
| AC-4ec81274 | InsertButton [try ▸ else of (fps.Name == "spdMain") ▸ if (fp… | FP02550_Operation_Bod.cs:1062 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) | GRID_SET | siSub.SetText | (iRow, siSub.GetColumnIndex(DefColumns.SUB_DIVISION_ID), _search.DIVISION_ID.ToString()) | 그리드 값 설정 |  |  |  |
| AC-15c8f43b | InsertButton [try ▸ else of (fps.Name == "spdMain") ▸ if (fp… | FP02550_Operation_Bod.cs:1063 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) | GRID_SET | siSub.SetText | (iRow, siSub.GetColumnIndex(DefColumns.SUB_SITE_ID), _search.SITE_ID.ToString()) | 그리드 값 설정 |  |  |  |
| AC-3070c6a8 | InsertButton [try ▸ else of (fps.Name == "spdMain") ▸ if (fp… | FP02550_Operation_Bod.cs:1064 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) | GRID_SET | siSub.SetText | (iRow, siSub.GetColumnIndex(DefColumns.SUB_PLANT_ID), _search.PLANT_ID.ToString()) | 그리드 값 설정 |  |  |  |
| AC-2bdab71d | InsertButton [try ▸ else of (fps.Name == "spdMain") ▸ if (fp… | FP02550_Operation_Bod.cs:1065 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) | GRID_SET | siSub.SetText | (iRow, siSub.GetColumnIndex(DefColumns.SUB_FACTORY_ID), _search.FACTORY_ID.ToString()) | 그리드 값 설정 |  |  |  |
| AC-19ec87c7 | InsertButton [try ▸ else of (fps.Name == "spdMain") ▸ if (fp… | FP02550_Operation_Bod.cs:1066 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) | GRID_SET | siSub.SetText | (iRow, siSub.GetColumnIndex(DefColumns.SUB_OPERATION_ID), _search.OPERATION_ID.ToString()) | 그리드 값 설정 |  |  |  |
| AC-85cd376d | InsertButton [try ▸ else of (fps.Name == "spdMain") ▸ if (fp… | FP02550_Operation_Bod.cs:1067 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) | GRID_SET | siSub.SetText | (iRow, siSub.GetColumnIndex(DefColumns.SUB_MODEL_TYPE), _search.MODEL_TYPE.ToString()) | 그리드 값 설정 |  |  |  |
| AC-75049e37 | InsertButton [try ▸ else of (fps.Name == "spdMain") ▸ if (fp… | FP02550_Operation_Bod.cs:1068 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) | GRID_SET | siSub.SetText | (iRow, siSub.GetColumnIndex(DefColumns.SUB_LINE_ATTR_1), _search.LINE_ATTR.ToString()) | 그리드 값 설정 |  |  |  |
| AC-082796fe | InsertButton [try ▸ else of (fps.Name == "spdMain") ▸ if (fp… | FP02550_Operation_Bod.cs:1071 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) | DATA_OP | siMain.GetBindingRow | (iClickRow) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-2ab80c8d | InsertButton [try ▸ else of (fps.Name == "spdMain") ▸ if (fp… | FP02550_Operation_Bod.cs:1074 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) | GRID_SET | siSub.SetText | (iRow, siSub.GetColumnIndex(DefColumns.SUB_LOT_SIZE_UOM), (dRow["LOT_SIZE_UOM"].ToString()… | 그리드 값 설정 |  |  |  |
| AC-6a542051 | InsertButton [try ▸ else of (fps.Name == "spdMain") ▸ if (fp… | FP02550_Operation_Bod.cs:1075 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) | GRID_SET | siSub.SetText | (iRow, siSub.GetColumnIndex(DefColumns.SUB_PRECEDE_PRODUCING_TERM_UOM), dRow["PRECEDE_PROD… | 그리드 값 설정 |  |  |  |
| AC-5c7e1a19 | InsertButton [try ▸ else of (fps.Name == "spdMain") ▸ if (fp… | FP02550_Operation_Bod.cs:1076 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) | GRID_SET | siSub.SetText | (iRow, siSub.GetColumnIndex(DefColumns.SUB_BUFFER_TIME_UOM), dRow["BUFFER_TIME_UOM"].ToStr… | 그리드 값 설정 |  |  |  |
| AC-78ececec | InsertButton [try ▸ else of (fps.Name == "spdMain") ▸ if (fp… | FP02550_Operation_Bod.cs:1077 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) | GRID_SET | siSub.SetText | (iRow, siSub.GetColumnIndex(DefColumns.SUB_TAT_UOM), dRow["TAT_UOM"].ToString()) | 그리드 값 설정 |  |  |  |
| AC-a748d692 | InsertButton [try ▸ else of (fps.Name == "spdMain") ▸ if (fp… | FP02550_Operation_Bod.cs:1078 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) | GRID_SET | siSub.SetText | (iRow, siSub.GetColumnIndex(DefColumns.SUB_TRANSFER_LOT_SIZE_UOM), (dRow["TRANSFER_LOT_SIZ… | 그리드 값 설정 |  |  |  |
| AC-7771cca2 | InsertButton [try ▸ else of (fps.Name == "spdMain") ▸ if (fp… | FP02550_Operation_Bod.cs:1079 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) | GRID_SET | siSub.SetText | (iRow, siSub.GetColumnIndex(DefColumns.SUB_OPERATION_LEAD_TIME_UOM), dRow["OPERATION_LEAD_… | 그리드 값 설정 |  |  |  |
| AC-f9b5133d | InsertButton [try ▸ else of (fps.Name == "spdMain") ▸ if (fp… | FP02550_Operation_Bod.cs:1080 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) | GRID_SET | siSub.SetText | (iRow, siSub.GetColumnIndex(DefColumns.SUB_TOLERANCE_UOM), dRow["TOLERANCE_UOM"].ToString(… | 그리드 값 설정 |  |  |  |

## FP02550_Operation_Bod.InsertButton

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-94e47aaf | InsertButton | FP02550_Operation_Bod.cs:595 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9c8200a1 | InsertButton | FP02550_Operation_Bod.cs:605 | try ▸ if (fps.Name == "spdMain") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ad2ca8cf | InsertButton | FP02550_Operation_Bod.cs:609 | try ▸ else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ if (siSub.IsLock(siSub.SheetName)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-547e0ba9 | InsertButton | FP02550_Operation_Bod.cs:617 | catch ((Exception ex)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FP02550_Operation_Bod.lfn_SearchDetailGrid

진입점: this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >= 0)] / this.btnExcelUpload.Click [if (fps.Name == spdMain.Name) ▸ if (p.SaveSuccess == true) ▸ finally ▸ if (siMain.ActiveSheet.RowCount > 0)] / this.btnSubImport.Click [if (fps.Name == spdMain.Name) ▸ if (p.SaveSuccess == true)] / FindButton [finally ▸ if (siMain.ActiveSheet.RowCount > 0)] / SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ if (siSub != null && siMain.IsLock(siSub.SheetName) == false) ▸ try ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-19205b3c | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… 외 4 | FP02550_Operation_Bod.cs:1927 |  | FLAG | _search | GetSearchCondition(row) | 화면 필드/플래그 변경 |  |  |  |

## FP02550_Operation_Bod.RunSqlSource

진입점: popSql.OnSql

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e1ae40de | popSql.OnSql | FP02550_Operation_Bod.cs:1881 | if (programID == "SELECT_MAIN") | RETURN | return Find_Data_Main("SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-de5e8102 | popSql.OnSql | FP02550_Operation_Bod.cs:1902 | else of (programID == "SELECT_MAIN") ▸ else of (programID == "SELECT_SUB") ▸ if (programID == "REFRESH_SETUP_GROUP") | DATA_OP | dt.Columns.Add | ("QUERY_VALUE") | 데이터 객체 조작/조회 |  |  |  |
| AC-48c8bf6c | popSql.OnSql | FP02550_Operation_Bod.cs:1903 | else of (programID == "SELECT_MAIN") ▸ else of (programID == "SELECT_SUB") ▸ if (programID == "REFRESH_SETUP_GROUP") | DATA_OP | dt.Rows.Add | ("EXEC PR_SCM_UF_ITEM_SETUP_RENEW ") | 데이터 객체 조작/조회 |  |  |  |
| AC-d36b4ffa | popSql.OnSql | FP02550_Operation_Bod.cs:1905 | else of (programID == "SELECT_MAIN") ▸ else of (programID == "SELECT_SUB") ▸ if (programID == "REFRESH_SETUP_GROUP") | DATA_OP | ds.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-c9f1e29e | popSql.OnSql | FP02550_Operation_Bod.cs:1907 | else of (programID == "SELECT_MAIN") ▸ else of (programID == "SELECT_SUB") ▸ if (programID == "REFRESH_SETUP_GROUP") | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-e93a3001 | popSql.OnSql | FP02550_Operation_Bod.cs:1912 | else of (programID == "SELECT_MAIN") ▸ else of (programID == "SELECT_SUB") ▸ else of (programID == "REFRESH_SETUP_GROUP") ▸ if (programID ==… | VALIDATE | DataUtil.checkRequiredOfSpread | (siMain) | 프레임워크 검증 |  |  |  |
| AC-6d7ed12f | popSql.OnSql | FP02550_Operation_Bod.cs:1912 | else of (programID == "SELECT_MAIN") ▸ else of (programID == "SELECT_SUB") ▸ else of (programID == "REFRESH_SETUP_GROUP") ▸ if (programID ==… | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-13aa9389 | popSql.OnSql | FP02550_Operation_Bod.cs:1918 | else of (programID == "SELECT_MAIN") ▸ else of (programID == "SELECT_SUB") ▸ else of (programID == "REFRESH_SETUP_GROUP") ▸ else of (program… | VALIDATE | DataUtil.checkRequiredOfSpread | (siSub) | 프레임워크 검증 |  |  |  |
| AC-cf519345 | popSql.OnSql | FP02550_Operation_Bod.cs:1918 | else of (programID == "SELECT_MAIN") ▸ else of (programID == "SELECT_SUB") ▸ else of (programID == "REFRESH_SETUP_GROUP") ▸ else of (program… | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-957e7a73 | popSql.OnSql | FP02550_Operation_Bod.cs:1922 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP02550_Operation_Bod.Save_Data_Execute

진입점: SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ try ▸ if (siMain.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-91bf32ba | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP02550_Operation_Bod.cs:1670 | try ▸ if (iCount > 0) | ENDPOINT | new FoxDataRequest | ("FP_Master.PR_UI_FP02550_SAVE") ⇒ FP_Master.PR_UI_FP02550_SAVE | 엔드포인트 요청 생성 |  |  |  |
| AC-9b0b4c49 | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP02550_Operation_Bod.cs:1671 | try ▸ if (iCount > 0) | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-8243286f | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP02550_Operation_Bod.cs:1673 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-10b2add9 | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP02550_Operation_Bod.cs:1674 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_flag"] | p_sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-f009ce11 | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP02550_Operation_Bod.cs:1675 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_gubun"] | p_sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-8b595177 | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP02550_Operation_Bod.cs:1676 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-d93c6925 | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP02550_Operation_Bod.cs:1678 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_company_id"] | p_company_id | 행/컬럼 값 대입 |  |  |  |
| AC-f337761e | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP02550_Operation_Bod.cs:1679 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-6af1c0e4 | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP02550_Operation_Bod.cs:1680 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_site_id"] | p_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-4db01b46 | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP02550_Operation_Bod.cs:1681 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_plant_id"] | p_plant_id | 행/컬럼 값 대입 |  |  |  |
| AC-5af94cb5 | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP02550_Operation_Bod.cs:1682 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_factory_id"] | p_factory_id | 행/컬럼 값 대입 |  |  |  |
| AC-bc8d2411 | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP02550_Operation_Bod.cs:1683 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_operation_id"] | p_operation_id | 행/컬럼 값 대입 |  |  |  |
| AC-8b948e5a | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP02550_Operation_Bod.cs:1684 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-443a395d | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP02550_Operation_Bod.cs:1685 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_operation_lot_size"] | p_operation_lot_size | 행/컬럼 값 대입 |  |  |  |
| AC-76bbf1b9 | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP02550_Operation_Bod.cs:1686 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_min_lot_size"] | p_min_lot_size | 행/컬럼 값 대입 |  |  |  |
| AC-55af95ad | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP02550_Operation_Bod.cs:1687 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_lot_size_uom"] | p_lot_size_uom | 행/컬럼 값 대입 |  |  |  |
| AC-c7143b5c | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP02550_Operation_Bod.cs:1688 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_precede_producing_term"] | p_precede_producing_term | 행/컬럼 값 대입 |  |  |  |
| AC-bc540ff7 | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP02550_Operation_Bod.cs:1689 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_precede_producing_term_uom"] | p_precede_producing_term_uom | 행/컬럼 값 대입 |  |  |  |
| AC-b434b45a | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP02550_Operation_Bod.cs:1690 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_buffer_time"] | p_buffer_time | 행/컬럼 값 대입 |  |  |  |
| AC-4e9fa886 | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP02550_Operation_Bod.cs:1691 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_buffer_time_uom"] | p_buffer_time_uom | 행/컬럼 값 대입 |  |  |  |
| AC-20c94469 | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP02550_Operation_Bod.cs:1692 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_initial_producing_lead_time"] | p_initial_producing_lead_time | 행/컬럼 값 대입 |  |  |  |
| AC-b332cc4f | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP02550_Operation_Bod.cs:1693 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_initial_producing_lead_time_uom"] | p_initial_producing_lead_time_uom | 행/컬럼 값 대입 |  |  |  |
| AC-fa685ae8 | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP02550_Operation_Bod.cs:1694 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_tat"] | p_tat | 행/컬럼 값 대입 |  |  |  |
| AC-30c5b384 | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP02550_Operation_Bod.cs:1695 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_tat_uom"] | p_tat_uom | 행/컬럼 값 대입 |  |  |  |
| AC-bc612605 | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP02550_Operation_Bod.cs:1696 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_tat_flag"] | p_tat_flag | 행/컬럼 값 대입 |  |  |  |
| AC-7fed3974 | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP02550_Operation_Bod.cs:1697 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_transfer_lot_size"] | p_transfer_lot_size | 행/컬럼 값 대입 |  |  |  |
| AC-e2e604ba | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP02550_Operation_Bod.cs:1698 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_transfer_lot_size_uom"] | p_transfer_lot_size_uom | 행/컬럼 값 대입 |  |  |  |
| AC-f253e265 | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP02550_Operation_Bod.cs:1699 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_tolerance"] | p_tolerance | 행/컬럼 값 대입 |  |  |  |
| AC-5d3c1493 | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP02550_Operation_Bod.cs:1700 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_tolerance_uom"] | p_tolerance_uom | 행/컬럼 값 대입 |  |  |  |
| AC-da529c63 | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP02550_Operation_Bod.cs:1701 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_operation_lead_time"] | p_operation_lead_time | 행/컬럼 값 대입 |  |  |  |
| AC-df092594 | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP02550_Operation_Bod.cs:1702 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_operation_lead_time_uom"] | p_operation_lead_time_uom | 행/컬럼 값 대입 |  |  |  |
| AC-2db4d57c | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP02550_Operation_Bod.cs:1703 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_model_type"] | p_model_type | 행/컬럼 값 대입 |  |  |  |
| AC-2aeb2db4 | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP02550_Operation_Bod.cs:1704 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_line_attr_1"] | p_line_attr_1 | 행/컬럼 값 대입 |  |  |  |
| AC-8b3333bc | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP02550_Operation_Bod.cs:1705 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_description"] | p_description | 행/컬럼 값 대입 |  |  |  |
| AC-55c8dec5 | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP02550_Operation_Bod.cs:1706 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-532d32a6 | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP02550_Operation_Bod.cs:1709 | try ▸ if (iCount > 0) | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-c5b6ecf1 | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP02550_Operation_Bod.cs:1710 | try ▸ if (iCount > 0) | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-85507b89 | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP02550_Operation_Bod.cs:1719 | try ▸ else of (iCount > 0) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-d94f6a0f | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP02550_Operation_Bod.cs:1725 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP02550_Operation_Bod.Save_Main

진입점: SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0ec5783e | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP02550_Operation_Bod.cs:1369 |  | VALIDATE | DataUtil.checkRequiredOfSpread | (siMain) | 프레임워크 검증 |  |  |  |
| AC-74c0c24c | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP02550_Operation_Bod.cs:1369 | if (!DataUtil.checkRequiredOfSpread(siMain)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-02ad9937 | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP02550_Operation_Bod.cs:1371 | if (siMain == null \|\| siMain.IsLock(siMain.SheetName) == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d183b074 | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP02550_Operation_Bod.cs:1373 | if (siMain.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-91a9d274 | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP02550_Operation_Bod.cs:1378 | if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9dfd3f96 | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP02550_Operation_Bod.cs:1379 | if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2f4ff0ad | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP02550_Operation_Bod.cs:1382 |  | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-aee3f8ff | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP02550_Operation_Bod.cs:1389 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) | VALIDATE | DataUtil.checkRequiredOfSpread | (siMain) | 프레임워크 검증 |  |  |  |
| AC-9c1d39ab | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP02550_Operation_Bod.cs:1391 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (!DataUtil.checkRequiredOfSpread(siMain)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-c50dad43 | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP02550_Operation_Bod.cs:1392 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (!DataUtil.checkRequiredOfSpread(siMain)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f6138147 | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP02550_Operation_Bod.cs:1397 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-e4e331ba | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP02550_Operation_Bod.cs:1402 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { ds.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-760006db | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP02550_Operation_Bod.cs:1411 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-42ba87fb | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP02550_Operation_Bod.cs:1415 | try | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-c468de75 | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP02550_Operation_Bod.cs:1419 | catch ((Exception ex)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-a221e74e | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP02550_Operation_Bod.cs:1420 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8b439e43 | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP02550_Operation_Bod.cs:1425 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-c40773c8 | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP02550_Operation_Bod.cs:1426 | finally | FLAG | iClickRow | 0 | 화면 필드/플래그 변경 |  |  |  |

## FP02550_Operation_Bod.Save_Sub

진입점: SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ if (siSub != null && siMain.IsLock(siSub.SheetName) == false)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0fd0f58b | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FP02550_Operation_Bod.cs:1432 |  | VALIDATE | DataUtil.checkRequiredOfSpread | (siSub) | 프레임워크 검증 |  |  |  |
| AC-e1952e2e | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FP02550_Operation_Bod.cs:1432 | if (!DataUtil.checkRequiredOfSpread(siSub)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e508e9cc | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FP02550_Operation_Bod.cs:1434 | if (siSub == null \|\| siSub.IsLock(siSub.SheetName) == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c76b2192 | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FP02550_Operation_Bod.cs:1436 | if (siSub.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8ee393c0 | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FP02550_Operation_Bod.cs:1441 | if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-4d6edf47 | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FP02550_Operation_Bod.cs:1442 | if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-de5f6647 | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FP02550_Operation_Bod.cs:1445 |  | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-9c5ca07b | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FP02550_Operation_Bod.cs:1452 | try ▸ if (siSub.SheetName == SpdSheet.shtSub) | VALIDATE | DataUtil.checkRequiredOfSpread | (siSub) | 프레임워크 검증 |  |  |  |
| AC-c88202fc | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FP02550_Operation_Bod.cs:1454 | try ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (!DataUtil.checkRequiredOfSpread(siSub)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-dbb605fb | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FP02550_Operation_Bod.cs:1455 | try ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (!DataUtil.checkRequiredOfSpread(siSub)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1fef609d | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FP02550_Operation_Bod.cs:1460 | try ▸ if (siSub.SheetName == SpdSheet.shtSub) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-b7e2a016 | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FP02550_Operation_Bod.cs:1465 | try ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { ds.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-78ac22d6 | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FP02550_Operation_Bod.cs:1481 | try ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ else of (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ac43daaa | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FP02550_Operation_Bod.cs:1485 | try | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-048536d0 | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FP02550_Operation_Bod.cs:1489 | catch ((Exception ex)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-42bc77af | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FP02550_Operation_Bod.cs:1490 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-19a368b8 | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FP02550_Operation_Bod.cs:1495 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-dcc1cee1 | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FP02550_Operation_Bod.cs:1496 | finally | FLAG | iClickRow | 0 | 화면 필드/플래그 변경 |  |  |  |

## FP02550_Operation_Bod.SaveButton

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-de61eefb | SaveButton | FP02550_Operation_Bod.cs:575 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP02550_Operation_Bod.SetChangedControl

진입점: this.Load [try] / clbDivision.SelectedIndexChanged / clbSite.SelectedIndexChanged / clbPlant.SelectedIndexChanged / clbFactory.SelectedIndexChanged / clbOperation.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7b6ababb | this.Load [try] 외 5 | FP02550_Operation_Bod.cs:290 | if (argType == "") | FLAG | sDataID | CString.GetCheckedListValue(dtDivision, clbDivision.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-c80ef94f | this.Load [try] 외 5 | FP02550_Operation_Bod.cs:291 | if (argType == "") | FLAG | pDivisionID | sDataID | 화면 필드/플래그 변경 |  |  |  |
| AC-cb205a52 | this.Load [try] 외 5 | FP02550_Operation_Bod.cs:292 | if (argType == "") | FLAG | dtSite | Data_FP.Common_FP(Data_FP.Type.SITE, false, UserInfoContext.Current.UserId, _sNonAuth, _sS… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 화면 필드/플래그 변경 |  |  |  |
| AC-5b52555b | this.Load [try] 외 5 | FP02550_Operation_Bod.cs:292 | if (argType == "") | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.SITE, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth, null, nu… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-cddd96bf | this.Load [try] 외 5 | FP02550_Operation_Bod.cs:293 | if (argType == "") | LIST_REBIND | clsCtrl.setListBox | (dtSite, clbSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-86514e77 | this.Load [try] 외 5 | FP02550_Operation_Bod.cs:296 | if (argType == "") | FLAG | sDataID | CString.GetCheckedListValue(dtSite, clbSite.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-643a79b6 | this.Load [try] 외 5 | FP02550_Operation_Bod.cs:297 | if (argType == "") | FLAG | pSiteID | sDataID | 화면 필드/플래그 변경 |  |  |  |
| AC-bfd58057 | this.Load [try] 외 5 | FP02550_Operation_Bod.cs:298 | if (argType == "") | FLAG | dtPlant | Data_FP.Common_FP(Data_FP.Type.PLANT, false, UserInfoContext.Current.UserId, _sNonAuth, _s… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 화면 필드/플래그 변경 |  |  |  |
| AC-c8f0443b | this.Load [try] 외 5 | FP02550_Operation_Bod.cs:298 | if (argType == "") | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.PLANT, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth, null, n… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-15e0f81e | this.Load [try] 외 5 | FP02550_Operation_Bod.cs:299 | if (argType == "") | LIST_REBIND | clsCtrl.setListBox | (dtPlant, clbPlant, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-f5fc69f2 | this.Load [try] 외 5 | FP02550_Operation_Bod.cs:302 | if (argType == "") | FLAG | sDataID | CString.GetCheckedListValue(dtPlant, clbPlant.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-529f6f2c | this.Load [try] 외 5 | FP02550_Operation_Bod.cs:303 | if (argType == "") | FLAG | pPlantID | sDataID | 화면 필드/플래그 변경 |  |  |  |
| AC-0c0694cb | this.Load [try] 외 5 | FP02550_Operation_Bod.cs:304 | if (argType == "") | FLAG | dtFactory | Data_FP.Common_FP(Data_FP.Type.FACTORY, false, UserInfoContext.Current.UserId, _sNonAuth, … ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY] | 화면 필드/플래그 변경 |  |  |  |
| AC-5804cc2e | this.Load [try] 외 5 | FP02550_Operation_Bod.cs:304 | if (argType == "") | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.FACTORY, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth, null,… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-f34030c3 | this.Load [try] 외 5 | FP02550_Operation_Bod.cs:305 | if (argType == "") | LIST_REBIND | clsCtrl.setListBox | (dtFactory, clbFactory, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-6a393450 | this.Load [try] 외 5 | FP02550_Operation_Bod.cs:308 | if (argType == "") | FLAG | sDataID | CString.GetCheckedListValue(dtFactory, clbFactory.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-47f81a92 | this.Load [try] 외 5 | FP02550_Operation_Bod.cs:309 | if (argType == "") | FLAG | pFactoryID | sDataID | 화면 필드/플래그 변경 |  |  |  |
| AC-f5623c33 | this.Load [try] 외 5 | FP02550_Operation_Bod.cs:310 | if (argType == "") | FLAG | dtOperation | Data_FP.Common_FP(Data_FP.Type.OPERATION, false, UserInfoContext.Current.UserId, _sNonAuth… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=OPERATION] | 화면 필드/플래그 변경 |  |  |  |
| AC-8902be32 | this.Load [try] 외 5 | FP02550_Operation_Bod.cs:310 | if (argType == "") | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.OPERATION, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth , nu… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=OPERATION] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-4d2e7fdf | this.Load [try] 외 5 | FP02550_Operation_Bod.cs:313 | if (argType == "") | LIST_REBIND | clsCtrl.setListBox | (dtOperation, clbOperation, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-477f36be | this.Load [try] 외 5 | FP02550_Operation_Bod.cs:319 | else of (argType == "") ▸ if (argType == "DIVISION") | FLAG | sDataID | CString.GetCheckedListValue(dtDivision, clbDivision.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-9fa9f690 | this.Load [try] 외 5 | FP02550_Operation_Bod.cs:320 | else of (argType == "") ▸ if (argType == "DIVISION") | FLAG | pDivisionID | sDataID | 화면 필드/플래그 변경 |  |  |  |
| AC-fd6b56ef | this.Load [try] 외 5 | FP02550_Operation_Bod.cs:321 | else of (argType == "") ▸ if (argType == "DIVISION") | FLAG | dtSite | Data_FP.Common_FP(Data_FP.Type.SITE, false, UserInfoContext.Current.UserId, _sNonAuth, _sS… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 화면 필드/플래그 변경 |  |  |  |
| AC-d65e506b | this.Load [try] 외 5 | FP02550_Operation_Bod.cs:321 | else of (argType == "") ▸ if (argType == "DIVISION") | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.SITE, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth, null, nu… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-e34d22f4 | this.Load [try] 외 5 | FP02550_Operation_Bod.cs:322 | else of (argType == "") ▸ if (argType == "DIVISION") | LIST_REBIND | clsCtrl.setListBox | (dtSite, clbSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-7b98b47e | this.Load [try] 외 5 | FP02550_Operation_Bod.cs:329 | else of (argType == "") ▸ else of (argType == "DIVISION") ▸ if (argType == "SITE") | FLAG | sDataID | CString.GetCheckedListValue(dtSite, clbSite.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-b2b92a05 | this.Load [try] 외 5 | FP02550_Operation_Bod.cs:330 | else of (argType == "") ▸ else of (argType == "DIVISION") ▸ if (argType == "SITE") | FLAG | pSiteID | sDataID | 화면 필드/플래그 변경 |  |  |  |
| AC-06a92b01 | this.Load [try] 외 5 | FP02550_Operation_Bod.cs:331 | else of (argType == "") ▸ else of (argType == "DIVISION") ▸ if (argType == "SITE") | FLAG | dtPlant | Data_FP.Common_FP(Data_FP.Type.PLANT, false, UserInfoContext.Current.UserId, _sNonAuth, _s… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 화면 필드/플래그 변경 |  |  |  |
| AC-6e5a18b4 | this.Load [try] 외 5 | FP02550_Operation_Bod.cs:331 | else of (argType == "") ▸ else of (argType == "DIVISION") ▸ if (argType == "SITE") | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.PLANT, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth, null, n… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-3372f792 | this.Load [try] 외 5 | FP02550_Operation_Bod.cs:332 | else of (argType == "") ▸ else of (argType == "DIVISION") ▸ if (argType == "SITE") | LIST_REBIND | clsCtrl.setListBox | (dtPlant, clbPlant, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-3a07b43f | this.Load [try] 외 5 | FP02550_Operation_Bod.cs:339 | else of (argType == "") ▸ else of (argType == "DIVISION") ▸ else of (argType == "SITE") ▸ if (argType == "PLANT") | FLAG | sDataID | CString.GetCheckedListValue(dtPlant, clbPlant.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-a32f35f3 | this.Load [try] 외 5 | FP02550_Operation_Bod.cs:340 | else of (argType == "") ▸ else of (argType == "DIVISION") ▸ else of (argType == "SITE") ▸ if (argType == "PLANT") | FLAG | pPlantID | sDataID | 화면 필드/플래그 변경 |  |  |  |
| AC-afc9452c | this.Load [try] 외 5 | FP02550_Operation_Bod.cs:341 | else of (argType == "") ▸ else of (argType == "DIVISION") ▸ else of (argType == "SITE") ▸ if (argType == "PLANT") | FLAG | dtFactory | Data_FP.Common_FP(Data_FP.Type.FACTORY, false, UserInfoContext.Current.UserId, _sNonAuth, … ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY] | 화면 필드/플래그 변경 |  |  |  |
| AC-c9fb92ac | this.Load [try] 외 5 | FP02550_Operation_Bod.cs:341 | else of (argType == "") ▸ else of (argType == "DIVISION") ▸ else of (argType == "SITE") ▸ if (argType == "PLANT") | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.FACTORY, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth, null,… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-8d2cf0a5 | this.Load [try] 외 5 | FP02550_Operation_Bod.cs:342 | else of (argType == "") ▸ else of (argType == "DIVISION") ▸ else of (argType == "SITE") ▸ if (argType == "PLANT") | LIST_REBIND | clsCtrl.setListBox | (dtFactory, clbFactory, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-862a7550 | this.Load [try] 외 5 | FP02550_Operation_Bod.cs:348 | else of (argType == "") ▸ else of (argType == "DIVISION") ▸ else of (argType == "SITE") ▸ else of (argType == "PLANT") ▸ if (argType == "FAC… | FLAG | sDataID | CString.GetCheckedListValue(dtFactory, clbFactory.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-1f301b08 | this.Load [try] 외 5 | FP02550_Operation_Bod.cs:349 | else of (argType == "") ▸ else of (argType == "DIVISION") ▸ else of (argType == "SITE") ▸ else of (argType == "PLANT") ▸ if (argType == "FAC… | FLAG | pFactoryID | sDataID | 화면 필드/플래그 변경 |  |  |  |
| AC-f2091781 | this.Load [try] 외 5 | FP02550_Operation_Bod.cs:350 | else of (argType == "") ▸ else of (argType == "DIVISION") ▸ else of (argType == "SITE") ▸ else of (argType == "PLANT") ▸ if (argType == "FAC… | FLAG | dtOperation | Data_FP.Common_FP(Data_FP.Type.OPERATION, false, UserInfoContext.Current.UserId, _sNonAuth… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=OPERATION] | 화면 필드/플래그 변경 |  |  |  |
| AC-4bd1e5f3 | this.Load [try] 외 5 | FP02550_Operation_Bod.cs:350 | else of (argType == "") ▸ else of (argType == "DIVISION") ▸ else of (argType == "SITE") ▸ else of (argType == "PLANT") ▸ if (argType == "FAC… | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.OPERATION, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth , nu… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=OPERATION] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-cb8a7ce3 | this.Load [try] 외 5 | FP02550_Operation_Bod.cs:353 | else of (argType == "") ▸ else of (argType == "DIVISION") ▸ else of (argType == "SITE") ▸ else of (argType == "PLANT") ▸ if (argType == "FAC… | LIST_REBIND | clsCtrl.setListBox | (dtOperation, clbOperation, true) | 목록 컨트롤 재구성 |  |  |  |

## FP02550_Operation_Bod.SpdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5849d71d | this.spdMain.CellDoubleClick | FP02550_Operation_Bod.cs:1842 | if (siMain.Sheet().Rows.Count <= 0) | FLAG | iClickRow | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-43d3b117 | this.spdMain.CellDoubleClick | FP02550_Operation_Bod.cs:1843 | if (siMain.Sheet().Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e3179a30 | this.spdMain.CellDoubleClick | FP02550_Operation_Bod.cs:1850 | if (!e.ColumnHeader && e.Row >= 0) ▸ if (string.IsNullOrWhiteSpace(siMain.GetValue(e.Row, e.Column).ToString())) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4a2bf02d | this.spdMain.CellDoubleClick | FP02550_Operation_Bod.cs:1855 | if (!e.ColumnHeader && e.Row >= 0) | FLAG | iClickRow | e.Row | 화면 필드/플래그 변경 |  |  |  |

## FP02550_Operation_Bod.spdSub_CellClick

진입점: this.spdSub.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5847954a | this.spdSub.CellClick | FP02550_Operation_Bod.cs:1785 | try ▸ if (siSub.Sheet().Rows.Count <= 0 \|\| e.Column <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d1ce1b79 | this.spdSub.CellClick | FP02550_Operation_Bod.cs:1787 | try ▸ if ((siSub.ActiveSheet.Rows.Count <= 0) \|\| siSub.IsLock(siSub.SheetName)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-709243c7 | this.spdSub.CellClick | FP02550_Operation_Bod.cs:1806 | try ▸ if (siSub.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siSub.GetColumnIndex(DefColumns.SUB_ITEM_ID) && act… | DATA_OP | searchParam.Add | ("DIVISION_ID", _search.DIVISION_ID.ToString() ) | 데이터 객체 조작/조회 |  |  |  |
| AC-878ed17b | this.spdSub.CellClick | FP02550_Operation_Bod.cs:1807 | try ▸ if (siSub.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siSub.GetColumnIndex(DefColumns.SUB_ITEM_ID) && act… | DATA_OP | searchParam.Add | ("SITE_ID", _search.SITE_ID.ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-64399f86 | this.spdSub.CellClick | FP02550_Operation_Bod.cs:1809 | try ▸ if (siSub.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siSub.GetColumnIndex(DefColumns.SUB_ITEM_ID) && act… | POPUP | new FPC0031_ItemBPopup | (bFilterEnable, bMultiSelect, searchParam) | 팝업/폼 생성 |  |  |  |
| AC-ab466bff | this.spdSub.CellClick | FP02550_Operation_Bod.cs:1810 | try ▸ if (siSub.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siSub.GetColumnIndex(DefColumns.SUB_ITEM_ID) && act… | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-a982b88d | this.spdSub.CellClick | FP02550_Operation_Bod.cs:1811 | try ▸ if (siSub.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siSub.GetColumnIndex(DefColumns.SUB_ITEM_ID) && act… | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-3b378e98 | this.spdSub.CellClick | FP02550_Operation_Bod.cs:1821 | try ▸ if (siSub.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siSub.GetColumnIndex(DefColumns.SUB_ITEM_ID) && act… | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.SUB_COMPANY_ID), sCompany) | 그리드 값 설정 |  |  |  |
| AC-b5be5778 | this.spdSub.CellClick | FP02550_Operation_Bod.cs:1822 | try ▸ if (siSub.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siSub.GetColumnIndex(DefColumns.SUB_ITEM_ID) && act… | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.SUB_DIVISION_ID), sDivision) | 그리드 값 설정 |  |  |  |
| AC-c379eb60 | this.spdSub.CellClick | FP02550_Operation_Bod.cs:1823 | try ▸ if (siSub.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siSub.GetColumnIndex(DefColumns.SUB_ITEM_ID) && act… | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.SUB_SITE_ID), sSite) | 그리드 값 설정 |  |  |  |
| AC-c0a4703a | this.spdSub.CellClick | FP02550_Operation_Bod.cs:1824 | try ▸ if (siSub.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siSub.GetColumnIndex(DefColumns.SUB_ITEM_ID) && act… | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.SUB_ITEM_ID), sItemID) | 그리드 값 설정 |  |  |  |
| AC-e79fa772 | this.spdSub.CellClick | FP02550_Operation_Bod.cs:1825 | try ▸ if (siSub.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siSub.GetColumnIndex(DefColumns.SUB_ITEM_ID) && act… | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.SUB_NICK_NAME), sNickName) | 그리드 값 설정 |  |  |  |
| AC-8917a2b8 | this.spdSub.CellClick | FP02550_Operation_Bod.cs:1835 | catch ((Exception ex)) | THROW | throw; |  | 예외 발생 |  |  |  |

