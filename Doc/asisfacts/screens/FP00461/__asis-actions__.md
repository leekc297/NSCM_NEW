# AS-IS 액션 대조표 — FP00461

> 원천: `Doc/asisfacts/screens/FP00461/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 495행 · 메서드 83 · 종류 DATA_OP 139 · FLAG 68 · RETURN 35 · STATE 31 · GRID_INIT 27 · CALL_EXT 27 · UI_PROP 22 · MESSAGE 21 · UI_MISC 17 · GRID_SET 17 · POPUP 16 · ENDPOINT 14 · COMBO_DATA 13 · LIST_REBIND 12 · GRID_LOCK 8 · CALL_BASE 7 · VALUE_SET 7 · GRID_BIND 5 · THROW 5 · EXCEL 2 · FOCUS 1 · STATE_RESET 1 · ⚠ 의미 확인 필요 34


## FP00461_ExcelPopup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0cababea | .ctor | FP00461_ExcelPopup.cs:146 |  | FLAG | this.bCtlEnable | true | 화면 필드/플래그 변경 |  |  |  |
| AC-a22fbe1f | .ctor | FP00461_ExcelPopup.cs:149 |  | FLAG | Filter | new FilterDataSet() | 화면 필드/플래그 변경 |  |  |  |
| AC-ab881314 | .ctor | FP00461_ExcelPopup.cs:150 |  | FLAG | AutoCHK | false | 화면 필드/플래그 변경 |  |  |  |

## FP00461_ExcelPopup.btnClose_Click

진입점: this.btnClose.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-353bb8df | this.btnClose.Click | FP00461_ExcelPopup.cs:835 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00461_ExcelPopup.btnDownload_Click

진입점: this.btnDownload.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3a8a4d48 | this.btnDownload.Click | FP00461_ExcelPopup.cs:819 |  | FOCUS | spdMain.Focus | () | 포커스 이동 |  |  |  |
| AC-d94717ef | this.btnDownload.Click | FP00461_ExcelPopup.cs:820 |  | EXCEL | ExportExcel | (0) | 엑셀 내보내기/올리기 |  |  |  |

## FP00461_ExcelPopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-473b6941 | this.Load | FP00461_ExcelPopup.cs:202 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-474ac99d | this.Load | FP00461_ExcelPopup.cs:203 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-5196e0d6 | this.Load | FP00461_ExcelPopup.cs:204 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00461_ExcelPopup.DefaultLineCheck

진입점: this.btnUpload.Click [if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ for (i < iRCnt + 1) ▸ if (DoDefaultLineCheck)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e6577cbb | this.btnUpload.Click [if (string.IsNullOrWhiteSpace(FileName… | FP00461_ExcelPopup.cs:787 |  | CALL_EXT | ExcelService.CommonDefaultLineCheck | (row, KeyColumnList, ColumnType, ColumnLength, Filter, AcceptOnlyPositve) | ⚠ 의미 확인 필요 |  |  |  |
| AC-2ba1685d | this.btnUpload.Click [if (string.IsNullOrWhiteSpace(FileName… | FP00461_ExcelPopup.cs:787 |  | RETURN | return ExcelService.CommonDefaultLineCheck(row, KeyColumnList, ColumnType, Colum… |  | 처리 중단/반환 |  |  |  |

## FP00461_ExcelPopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-79cb2f63 | this.Load | FP00461_ExcelPopup.cs:197 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP00461_ExcelPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ae20ac09 | Dispose | FP00461_ExcelPopup.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00461_ExcelPopup.FindButton

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5b961a56 | FindButton | FP00461_ExcelPopup.cs:244 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-fef2a1a6 | FindButton | FP00461_ExcelPopup.cs:245 |  | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-bbbf302f | FindButton | FP00461_ExcelPopup.cs:247 |  | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## FP00461_ExcelPopup.FindData

진입점: this.Load / this.btnFind.Click / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1a2b8396 | this.Load 외 2 | FP00461_ExcelPopup.cs:294 | if (DoSearchData == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-64a676c9 | this.Load 외 2 | FP00461_ExcelPopup.cs:295 |  | FLAG | ctx | FoxUserInfoContext.GetUserInfoContext() | 화면 필드/플래그 변경 |  |  |  |
| AC-c2bc5f67 | this.Load 외 2 | FP00461_ExcelPopup.cs:295 |  | CALL_EXT | FoxUserInfoContext.GetUserInfoContext | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-329c721c | this.Load 외 2 | FP00461_ExcelPopup.cs:299 | if (DoSearchData != null) | FLAG | this.hasError | false | 화면 필드/플래그 변경 |  |  |  |
| AC-f59f8470 | this.Load 외 2 | FP00461_ExcelPopup.cs:300 | if (DoSearchData != null) | FLAG | this.IsExcelChanged | false | 화면 필드/플래그 변경 |  |  |  |
| AC-d81e8467 | this.Load 외 2 | FP00461_ExcelPopup.cs:302 | if (DoSearchData != null) | STATE | this.spdMain.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-a0d56196 | this.Load 외 2 | FP00461_ExcelPopup.cs:303 | if (DoSearchData != null) | STATE | this.btnClose.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-6ab6f823 | this.Load 외 2 | FP00461_ExcelPopup.cs:304 | if (DoSearchData != null) | STATE | this.btnFind.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-674bca97 | this.Load 외 2 | FP00461_ExcelPopup.cs:305 | if (DoSearchData != null) | STATE | this.btnDownload.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-95c596b1 | this.Load 외 2 | FP00461_ExcelPopup.cs:306 | if (DoSearchData != null) | STATE | this.btnUpload.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-71193099 | this.Load 외 2 | FP00461_ExcelPopup.cs:307 | if (DoSearchData != null) | STATE | this.btnSave.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-a95a0ed1 | this.Load 외 2 | FP00461_ExcelPopup.cs:313 | if (DoSearchData != null) ▸ try ▸ if (UserInfoContext.Current == null) | CALL_EXT | FoxUserInfoContext.SetCallContext | (ctx) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c5e9bb2d | this.Load 외 2 | FP00461_ExcelPopup.cs:316 | if (DoSearchData != null) ▸ try | CALL_BASE | DoSearchData | (Filter.Data, this) | ⚠ 의미 확인 필요 |  |  |  |
| AC-0bcb2031 | this.Load 외 2 | FP00461_ExcelPopup.cs:318 | if (DoSearchData != null) ▸ try ▸ if (set == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9db4ea57 | this.Load 외 2 | FP00461_ExcelPopup.cs:320 | if (DoSearchData != null) ▸ try | CALL_BASE | this.Invoke | (new Action(delegate () { //DictColumn = siMain.SetAmendExcelHeaderColumn_FP(Calendar,set,… | ⚠ 의미 확인 필요 |  |  |  |
| AC-d87c93e9 | this.Load 외 2 | FP00461_ExcelPopup.cs:324 | if (DoSearchData != null) ▸ try ▸ lambda | FLAG | DictColumn | siMain.SetSheetHeaderFromDataSource(siMain, set, ColumnWidth, ColumnTitle, KeyColumns, Aut… | 화면 필드/플래그 변경 |  |  |  |
| AC-79434460 | this.Load 외 2 | FP00461_ExcelPopup.cs:324 | if (DoSearchData != null) ▸ try ▸ lambda | GRID_INIT | siMain.SetSheetHeaderFromDataSource | (siMain, set, ColumnWidth, ColumnTitle, KeyColumns, AutoCHK) | 그리드 재구성/초기화 |  |  |  |
| AC-8724d80f | this.Load 외 2 | FP00461_ExcelPopup.cs:329 | if (DoSearchData != null) ▸ try ▸ lambda ▸ if (AutoCHK) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex("CHK")].CellType | chk | 그리드 속성/값 설정 |  |  |  |
| AC-629aa0de | this.Load 외 2 | FP00461_ExcelPopup.cs:330 | if (DoSearchData != null) ▸ try ▸ lambda ▸ if (AutoCHK) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex("CHK")].Value | false | 그리드 속성/값 설정 |  |  |  |
| AC-95355e0c | this.Load 외 2 | FP00461_ExcelPopup.cs:331 | if (DoSearchData != null) ▸ try ▸ lambda ▸ if (AutoCHK) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex("CHK")].Border | bevelbrdr | 그리드 속성/값 설정 |  |  |  |
| AC-5eb89c25 | this.Load 외 2 | FP00461_ExcelPopup.cs:335 | if (DoSearchData != null) ▸ try ▸ lambda ▸ if (set != null && set.Tables != null && set.Tables.Count > 0) | DATA_OP | set.Tables[0].Columns.Add | ("MESSAGE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-a3fec168 | this.Load 외 2 | FP00461_ExcelPopup.cs:338 | if (DoSearchData != null) ▸ try ▸ lambda | GRID_BIND | siMain.Query | (set, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-996bc9b4 | this.Load 외 2 | FP00461_ExcelPopup.cs:339 | if (DoSearchData != null) ▸ try ▸ lambda | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-86ec816e | this.Load 외 2 | FP00461_ExcelPopup.cs:348 | if (DoSearchData != null) ▸ finally | CALL_BASE | this.Invoke | (new Action(delegate () { //this.Enabled = false; this.spdMain.Enabled = true; this.btnClo… | ⚠ 의미 확인 필요 |  |  |  |
| AC-e3fee537 | this.Load 외 2 | FP00461_ExcelPopup.cs:351 | if (DoSearchData != null) ▸ finally ▸ lambda | STATE | this.spdMain.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-8c573f77 | this.Load 외 2 | FP00461_ExcelPopup.cs:352 | if (DoSearchData != null) ▸ finally ▸ lambda | STATE | this.btnClose.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-48ec1676 | this.Load 외 2 | FP00461_ExcelPopup.cs:353 | if (DoSearchData != null) ▸ finally ▸ lambda | STATE | this.btnFind.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-e868f1a6 | this.Load 외 2 | FP00461_ExcelPopup.cs:354 | if (DoSearchData != null) ▸ finally ▸ lambda | STATE | this.btnDownload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-2ffe0069 | this.Load 외 2 | FP00461_ExcelPopup.cs:355 | if (DoSearchData != null) ▸ finally ▸ lambda | STATE | this.btnUpload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-2ac4016f | this.Load 외 2 | FP00461_ExcelPopup.cs:356 | if (DoSearchData != null) ▸ finally ▸ lambda | STATE | this.btnSave.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## FP00461_ExcelPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d9341892 | this.Load | FP00461_ExcelPopup.cs:158 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-0d6429cb | this.Load | FP00461_ExcelPopup.cs:160 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00461_ExcelPopup.GetExcelFileName

진입점: this.btnUpload.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b73a15e8 | this.btnUpload.Click | FP00461_ExcelPopup.cs:559 | try | POPUP | new OpenFileDialog | () | 팝업/폼 생성 |  |  |  |
| AC-e49cd1ba | this.btnUpload.Click | FP00461_ExcelPopup.cs:560 | try | UI_PROP | openFile.Filter | "Excel files (*.xls;*.xlsx)\|*.xls;*.xlsx\|xls files (*.xls)\|*.xls\|xlsx files (*.xlsx)\|… | 속성 Filter 설정 |  |  |  |
| AC-ce6d1e0b | this.btnUpload.Click | FP00461_ExcelPopup.cs:561 | try | UI_PROP | openFile.FilterIndex | 1 | 속성 FilterIndex 설정 |  |  |  |
| AC-b2021513 | this.btnUpload.Click | FP00461_ExcelPopup.cs:562 | try | UI_PROP | openFile.RestoreDirectory | true | 속성 RestoreDirectory 설정 |  |  |  |
| AC-574cc9d0 | this.btnUpload.Click | FP00461_ExcelPopup.cs:563 | try | UI_PROP | openFile.InitialDirectory | @"C:\My Documents\" | 속성 InitialDirectory 설정 |  |  |  |
| AC-56f6527a | this.btnUpload.Click | FP00461_ExcelPopup.cs:564 | try | UI_PROP | openFile.FileName | FileName | 속성 FileName 설정 |  |  |  |
| AC-842d8909 | this.btnUpload.Click | FP00461_ExcelPopup.cs:565 | try | POPUP | openFile.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-eb13eeda | this.btnUpload.Click | FP00461_ExcelPopup.cs:567 | try | FLAG | this.FileName | openFile.FileName | 화면 필드/플래그 변경 |  |  |  |
| AC-9afc1a83 | this.btnUpload.Click | FP00461_ExcelPopup.cs:568 | try | RETURN | return this.FileName; |  | 처리 중단/반환 |  |  |  |
| AC-d4fd248d | this.btnUpload.Click | FP00461_ExcelPopup.cs:572 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message, ex.Source, MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-bff96883 | this.btnUpload.Click | FP00461_ExcelPopup.cs:573 | catch ((Exception ex)) | RETURN | return string.Empty; |  | 처리 중단/반환 |  |  |  |

## FP00461_ExcelPopup.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c2d92c61 | this.Load | FP00461_ExcelPopup.cs:214 |  | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7f55b493 | this.Load | FP00461_ExcelPopup.cs:215 |  | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP00461_ExcelPopup.InitSpread_Merge

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dae02f80 | (진입점 미연결) | FP00461_ExcelPopup.cs:235 |  | GRID_INIT | siMain.Freeze | (0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP00461_ExcelPopup.OpenAndLoadExcelData

진입점: this.btnUpload.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-14eba3da | this.btnUpload.Click | FP00461_ExcelPopup.cs:583 |  | CALL_EXT | System.IO.File.Exists | (FileName) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f5969d52 | this.btnUpload.Click | FP00461_ExcelPopup.cs:585 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) | FLAG | hasError | false | 화면 필드/플래그 변경 |  |  |  |
| AC-a032bff6 | this.btnUpload.Click | FP00461_ExcelPopup.cs:586 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) | FLAG | IsExcelChanged | true | 화면 필드/플래그 변경 |  |  |  |
| AC-0c0a24aa | this.btnUpload.Click | FP00461_ExcelPopup.cs:587 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) | STATE_RESET | KeyColumnList.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-933b1d87 | this.btnUpload.Click | FP00461_ExcelPopup.cs:592 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ if (KeyColumns != null) ▸ foreach (string keycolumn i… | DATA_OP | KeyColumnList.Add | (keycolumn) | 데이터 객체 조작/조회 |  |  |  |
| AC-ec23f179 | this.btnUpload.Click | FP00461_ExcelPopup.cs:597 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ if (DictColumn == null \|\| DictColumn.Count < 1) | MESSAGE | MessageBox.Show | ("There's no data in Excel File to upload:", "Excel Import", MessageBoxButtons.OK, Message… | 메시지 표시 |  |  |  |
| AC-d1818955 | this.btnUpload.Click | FP00461_ExcelPopup.cs:598 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ if (DictColumn == null \|\| DictColumn.Count < 1) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-c15f5bf5 | this.btnUpload.Click | FP00461_ExcelPopup.cs:609 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-fbfc7472 | this.btnUpload.Click | FP00461_ExcelPopup.cs:613 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-92774721 | this.btnUpload.Click | FP00461_ExcelPopup.cs:616 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try | STATE | xlApp.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-5de37ee5 | this.btnUpload.Click | FP00461_ExcelPopup.cs:617 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try | UI_PROP | xlApp.DisplayAlerts | false | 속성 DisplayAlerts 설정 |  |  |  |
| AC-fd28cf57 | this.btnUpload.Click | FP00461_ExcelPopup.cs:619 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try | CALL_EXT | xlApp.Workbooks.Open | (FileName, Missing.Value, Missing.Value, Missing.Value, Missing.Value, Missing.Value , Mis… | ⚠ 의미 확인 필요 |  |  |  |
| AC-b4050ef5 | this.btnUpload.Click | FP00461_ExcelPopup.cs:638 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try | CALL_EXT | xlRange.get_Value | (Type.Missing) | ⚠ 의미 확인 필요 |  |  |  |
| AC-fca37106 | this.btnUpload.Click | FP00461_ExcelPopup.cs:645 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (iRCnt < 2 \|\| iCCnt < DictColumn.Count) | MESSAGE | MessageBox.Show | ("There's no data in Excel File to upload:", "Excel Import", MessageBoxButtons.OK, Message… | 메시지 표시 |  |  |  |
| AC-2fab37ea | this.btnUpload.Click | FP00461_ExcelPopup.cs:646 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (iRCnt < 2 \|\| iCCnt < DictColumn.Count) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-da6d367a | this.btnUpload.Click | FP00461_ExcelPopup.cs:669 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (iFR == 0 \|\| iFC == 0) | MESSAGE | MessageBox.Show | ("Please check your excel file where should use same column and order as orignal file", "E… | 메시지 표시 |  |  |  |
| AC-e470c03f | this.btnUpload.Click | FP00461_ExcelPopup.cs:670 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (iFR == 0 \|\| iFC == 0) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-b90d39d1 | this.btnUpload.Click | FP00461_ExcelPopup.cs:680 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (main != null) | DATA_OP | main.Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-a660c350 | this.btnUpload.Click | FP00461_ExcelPopup.cs:699 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ for (i < iRCnt + 1) | DATA_OP | excelData.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-6568cb25 | this.btnUpload.Click | FP00461_ExcelPopup.cs:706 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ for (i < iRCnt + 1) ▸ for (j < iFC + DictColumn… | DATA_OP | row[j - iFC] | each_cell_value | 행/컬럼 값 대입 |  |  |  |
| AC-ea242f09 | this.btnUpload.Click | FP00461_ExcelPopup.cs:715 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ for (i < iRCnt + 1) ▸ if (this.DoLineCheck != n… | CALL_BASE | DoLineCheck | (row, this) | ⚠ 의미 확인 필요 |  |  |  |
| AC-4bd2b1bb | this.btnUpload.Click | FP00461_ExcelPopup.cs:719 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ for (i < iRCnt + 1) | DATA_OP | excelData.Rows.Add | (row) | 데이터 객체 조작/조회 |  |  |  |
| AC-7747c734 | this.btnUpload.Click | FP00461_ExcelPopup.cs:724 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try | GRID_BIND | siMain.Query | (excelDataSet, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-e92e59de | this.btnUpload.Click | FP00461_ExcelPopup.cs:738 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (excelDataSet != null && excelDataSet.Tables… | CALL_EXT | siMain.SetRowColor | (k, System.Drawing.Color.PaleVioletRed) | ⚠ 의미 확인 필요 |  |  |  |
| AC-0e6c3bdc | this.btnUpload.Click | FP00461_ExcelPopup.cs:739 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (excelDataSet != null && excelDataSet.Tables… | FLAG | hasError | true | 화면 필드/플래그 변경 |  |  |  |
| AC-00a20d51 | this.btnUpload.Click | FP00461_ExcelPopup.cs:757 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (iSaveCnt == 0) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-9fa0dd7c | this.btnUpload.Click | FP00461_ExcelPopup.cs:763 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-5d872744 | this.btnUpload.Click | FP00461_ExcelPopup.cs:767 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message, ex.Source, MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-8018f79e | this.btnUpload.Click | FP00461_ExcelPopup.cs:772 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ finally | CALL_EXT | xlApp.Quit | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-b1c949cc | this.btnUpload.Click | FP00461_ExcelPopup.cs:773 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-88ee6b33 | this.btnUpload.Click | FP00461_ExcelPopup.cs:778 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## FP00461_ExcelPopup.SaveToDB

진입점: this.btnSave.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a61cffb8 | this.btnSave.Click | FP00461_ExcelPopup.cs:368 | if (IsExcelChanged == false) | MESSAGE | MessageBox.Show | ("There is no changed to save") | 메시지 표시 |  |  |  |
| AC-c07f14ba | this.btnSave.Click | FP00461_ExcelPopup.cs:369 | if (IsExcelChanged == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3d4ca803 | this.btnSave.Click | FP00461_ExcelPopup.cs:373 | if (hasError == true) | MESSAGE | MessageBox.Show | ("You have errors to fix") | 메시지 표시 |  |  |  |
| AC-4d70c589 | this.btnSave.Click | FP00461_ExcelPopup.cs:374 | if (hasError == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9dd37a93 | this.btnSave.Click | FP00461_ExcelPopup.cs:377 |  | FLAG | ctx | FoxUserInfoContext.GetUserInfoContext() | 화면 필드/플래그 변경 |  |  |  |
| AC-d8cf42ea | this.btnSave.Click | FP00461_ExcelPopup.cs:377 |  | CALL_EXT | FoxUserInfoContext.GetUserInfoContext | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-4cc40fc6 | this.btnSave.Click | FP00461_ExcelPopup.cs:381 | if (OnCheckData != null) | CALL_BASE | OnCheckData | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-f3c8e986 | this.btnSave.Click | FP00461_ExcelPopup.cs:383 | if (OnCheckData != null) ▸ if (bCheck == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-86dc08b3 | this.btnSave.Click | FP00461_ExcelPopup.cs:393 | if (DoSaveData != null) | STATE | this.spdMain.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-199b3da8 | this.btnSave.Click | FP00461_ExcelPopup.cs:394 | if (DoSaveData != null) | STATE | this.btnClose.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-7fbadd2e | this.btnSave.Click | FP00461_ExcelPopup.cs:395 | if (DoSaveData != null) | STATE | this.btnFind.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-b2da1d96 | this.btnSave.Click | FP00461_ExcelPopup.cs:396 | if (DoSaveData != null) | STATE | this.btnDownload.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-ae58052d | this.btnSave.Click | FP00461_ExcelPopup.cs:397 | if (DoSaveData != null) | STATE | this.btnUpload.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-f24be7f7 | this.btnSave.Click | FP00461_ExcelPopup.cs:398 | if (DoSaveData != null) | STATE | this.btnSave.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-2ee6ffad | this.btnSave.Click | FP00461_ExcelPopup.cs:406 | if (DoSaveData != null) ▸ try ▸ if (dsMain.Tables.Count == 0) | MESSAGE | MessageBox.Show | ("There is no data to save") | 메시지 표시 |  |  |  |
| AC-4a259b20 | this.btnSave.Click | FP00461_ExcelPopup.cs:407 | if (DoSaveData != null) ▸ try ▸ if (dsMain.Tables.Count == 0) | STATE | this.spdMain.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-3a4ff314 | this.btnSave.Click | FP00461_ExcelPopup.cs:408 | if (DoSaveData != null) ▸ try ▸ if (dsMain.Tables.Count == 0) | STATE | this.btnClose.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-c3ddb90e | this.btnSave.Click | FP00461_ExcelPopup.cs:409 | if (DoSaveData != null) ▸ try ▸ if (dsMain.Tables.Count == 0) | STATE | this.btnFind.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-0cf6a671 | this.btnSave.Click | FP00461_ExcelPopup.cs:410 | if (DoSaveData != null) ▸ try ▸ if (dsMain.Tables.Count == 0) | STATE | this.btnDownload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-28eba9a6 | this.btnSave.Click | FP00461_ExcelPopup.cs:411 | if (DoSaveData != null) ▸ try ▸ if (dsMain.Tables.Count == 0) | STATE | this.btnUpload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-a7bc3362 | this.btnSave.Click | FP00461_ExcelPopup.cs:412 | if (DoSaveData != null) ▸ try ▸ if (dsMain.Tables.Count == 0) | STATE | this.btnSave.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-bf3d8c06 | this.btnSave.Click | FP00461_ExcelPopup.cs:413 | if (DoSaveData != null) ▸ try ▸ if (dsMain.Tables.Count == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2a09c8a1 | this.btnSave.Click | FP00461_ExcelPopup.cs:418 | if (DoSaveData != null) ▸ try ▸ if (dsMain != null && dsMain.Tables != null && dsMain.Tables.Count > 0) | DATA_OP | dsMain.Tables[0].Columns.Contains | ("USER_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-bc4ca920 | this.btnSave.Click | FP00461_ExcelPopup.cs:421 | if (DoSaveData != null) ▸ try ▸ if (dsMain != null && dsMain.Tables != null && dsMain.Tables.Count > 0) ▸ if (!dsMain.Tables[0].Columns.Cont… | DATA_OP | dsMain.Tables[0].Columns.Add | (itemColumn) | 데이터 객체 조작/조회 |  |  |  |
| AC-05470878 | this.btnSave.Click | FP00461_ExcelPopup.cs:423 | if (DoSaveData != null) ▸ try ▸ if (dsMain != null && dsMain.Tables != null && dsMain.Tables.Count > 0) | DATA_OP | dsMain.Tables[0].Columns.Contains | ("JOB_ORDER") | 데이터 객체 조작/조회 |  |  |  |
| AC-ef6e56e6 | this.btnSave.Click | FP00461_ExcelPopup.cs:426 | if (DoSaveData != null) ▸ try ▸ if (dsMain != null && dsMain.Tables != null && dsMain.Tables.Count > 0) ▸ if (!dsMain.Tables[0].Columns.Cont… | DATA_OP | dsMain.Tables[0].Columns.Add | (itemColumn) | 데이터 객체 조작/조회 |  |  |  |
| AC-dbe98870 | this.btnSave.Click | FP00461_ExcelPopup.cs:431 | if (DoSaveData != null) ▸ try ▸ if (dsMain != null && dsMain.Tables != null && dsMain.Tables.Count > 0) ▸ for (i < dsMain.Tables[0].Rows.Cou… | GRID_SET | dsMain.Tables[0].Rows[i]["USER_ID"] | UserInfoContext.Current.UserId | 그리드 속성/값 설정 |  |  |  |
| AC-cce3d468 | this.btnSave.Click | FP00461_ExcelPopup.cs:432 | if (DoSaveData != null) ▸ try ▸ if (dsMain != null && dsMain.Tables != null && dsMain.Tables.Count > 0) ▸ for (i < dsMain.Tables[0].Rows.Cou… | GRID_SET | dsMain.Tables[0].Rows[i]["JOB_ORDER"] | i | 그리드 속성/값 설정 |  |  |  |
| AC-79e8db25 | this.btnSave.Click | FP00461_ExcelPopup.cs:439 | if (DoSaveData != null) ▸ try ▸ if (DoValidationData != null) | CALL_BASE | DoValidationData | (dsMain, this) | ⚠ 의미 확인 필요 |  |  |  |
| AC-dd955414 | this.btnSave.Click | FP00461_ExcelPopup.cs:466 | if (DoSaveData != null) ▸ try ▸ if (bValid) | CALL_BASE | DoSaveData | (dsMain, this) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c383d4fd | this.btnSave.Click | FP00461_ExcelPopup.cs:477 | if (DoSaveData != null) ▸ try ▸ if (bValid) ▸ if (dsResult != null && dsResult.Tables.Count > 0) ▸ try ▸ if (result_string.Equals("SUCCESS")… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { dsMain.Tables[0].Rows.Count }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f9f4d992 | this.btnSave.Click | FP00461_ExcelPopup.cs:479 | if (DoSaveData != null) ▸ try ▸ if (bValid) ▸ if (dsResult != null && dsResult.Tables.Count > 0) ▸ try ▸ if (result_string.Equals("SUCCESS")… | FLAG | SaveSuccess | true | 화면 필드/플래그 변경 |  |  |  |
| AC-1b2903bb | this.btnSave.Click | FP00461_ExcelPopup.cs:480 | if (DoSaveData != null) ▸ try ▸ if (bValid) ▸ if (dsResult != null && dsResult.Tables.Count > 0) ▸ try ▸ if (result_string.Equals("SUCCESS")… | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-b7ca72f9 | this.btnSave.Click | FP00461_ExcelPopup.cs:485 | if (DoSaveData != null) ▸ try ▸ if (bValid) ▸ if (dsResult != null && dsResult.Tables.Count > 0) ▸ try ▸ else of (result_string.Equals("SUCC… | MESSAGE | MessageBox.Show | ("Save error :" + result_string) | 메시지 표시 |  |  |  |
| AC-ce32a654 | this.btnSave.Click | FP00461_ExcelPopup.cs:486 | if (DoSaveData != null) ▸ try ▸ if (bValid) ▸ if (dsResult != null && dsResult.Tables.Count > 0) ▸ try ▸ else of (result_string.Equals("SUCC… | FLAG | this.hasError | true | 화면 필드/플래그 변경 |  |  |  |
| AC-cbda9a9c | this.btnSave.Click | FP00461_ExcelPopup.cs:492 | if (DoSaveData != null) ▸ try ▸ if (bValid) ▸ if (dsResult != null && dsResult.Tables.Count > 0) ▸ catch ((Exception e)) | MESSAGE | MessageBox.Show | ("Unknown validation error :" + e.Message) | 메시지 표시 |  |  |  |
| AC-add2c80b | this.btnSave.Click | FP00461_ExcelPopup.cs:526 | if (DoSaveData != null) ▸ try ▸ else of (bValid) ▸ foreach (DataRow valrow in valSrc.Rows) ▸ if (valrow["_VALID"] as string == "N") ▸ foreac… | DATA_OP | xlsrow["MESSAGE"] | valrow["_MSG"] | 행/컬럼 값 대입 |  |  |  |
| AC-61996ece | this.btnSave.Click | FP00461_ExcelPopup.cs:528 | if (DoSaveData != null) ▸ try ▸ else of (bValid) ▸ foreach (DataRow valrow in valSrc.Rows) ▸ if (valrow["_VALID"] as string == "N") ▸ foreac… | CALL_EXT | siMain.SetRowColor | (index, System.Drawing.Color.PaleVioletRed) | ⚠ 의미 확인 필요 |  |  |  |
| AC-be2a8bcd | this.btnSave.Click | FP00461_ExcelPopup.cs:529 | if (DoSaveData != null) ▸ try ▸ else of (bValid) ▸ foreach (DataRow valrow in valSrc.Rows) ▸ if (valrow["_VALID"] as string == "N") ▸ foreac… | FLAG | this.hasError | true | 화면 필드/플래그 변경 |  |  |  |
| AC-0faf552e | this.btnSave.Click | FP00461_ExcelPopup.cs:539 | if (DoSaveData != null) ▸ catch ((Exception e)) | FLAG | this.hasError | true | 화면 필드/플래그 변경 |  |  |  |
| AC-15186865 | this.btnSave.Click | FP00461_ExcelPopup.cs:540 | if (DoSaveData != null) ▸ catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-7ce08116 | this.btnSave.Click | FP00461_ExcelPopup.cs:544 | if (DoSaveData != null) ▸ finally | STATE | this.spdMain.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-68795e81 | this.btnSave.Click | FP00461_ExcelPopup.cs:545 | if (DoSaveData != null) ▸ finally | STATE | this.btnClose.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-2156ba79 | this.btnSave.Click | FP00461_ExcelPopup.cs:546 | if (DoSaveData != null) ▸ finally | STATE | this.btnFind.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-fbcfdf65 | this.btnSave.Click | FP00461_ExcelPopup.cs:547 | if (DoSaveData != null) ▸ finally | STATE | this.btnDownload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-57120c8c | this.btnSave.Click | FP00461_ExcelPopup.cs:548 | if (DoSaveData != null) ▸ finally | STATE | this.btnUpload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-42a18d40 | this.btnSave.Click | FP00461_ExcelPopup.cs:549 | if (DoSaveData != null) ▸ finally | STATE | this.btnSave.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## FP00461_ExcelPopup.SetSpreadInit

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c11d2b6a | this.Load | FP00461_ExcelPopup.cs:227 |  | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2323ac39 | this.Load | FP00461_ExcelPopup.cs:228 |  | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |

## FP00461_PackWorker_Master.btnExcelImport_Click

진입점: this.btnUpload.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cbbe878d | this.btnUpload.Click | FP00461_PackWorker_Master.cs:1153 |  | POPUP | new FP00461_ExcelPopup | () | 팝업/폼 생성 |  |  |  |
| AC-97b51d6d | this.btnUpload.Click | FP00461_PackWorker_Master.cs:1154 |  | UI_PROP | p.Filter | Filter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-dd31e2df | this.btnUpload.Click | FP00461_PackWorker_Master.cs:1154 |  | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-2b04c7ba | this.btnUpload.Click | FP00461_PackWorker_Master.cs:1155 |  | GRID_SET | p.KeyColumns["Company_id"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-859abca9 | this.btnUpload.Click | FP00461_PackWorker_Master.cs:1156 |  | GRID_SET | p.KeyColumns["PLANT_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-a6c879af | this.btnUpload.Click | FP00461_PackWorker_Master.cs:1157 |  | GRID_SET | p.KeyColumns["DIVISION_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-62cbb7fa | this.btnUpload.Click | FP00461_PackWorker_Master.cs:1158 |  | GRID_SET | p.KeyColumns["site_id"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-4fdeaa86 | this.btnUpload.Click | FP00461_PackWorker_Master.cs:1159 |  | GRID_SET | p.KeyColumns["ITEM_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-e1f0e7b7 | this.btnUpload.Click | FP00461_PackWorker_Master.cs:1160 |  | GRID_SET | p.KeyColumns["FACTORY_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-f3ad1593 | this.btnUpload.Click | FP00461_PackWorker_Master.cs:1161 |  | GRID_SET | p.KeyColumns["OPERATION_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-10493bea | this.btnUpload.Click | FP00461_PackWorker_Master.cs:1162 |  | GRID_SET | p.KeyColumns["LINE_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-2646ac52 | this.btnUpload.Click | FP00461_PackWorker_Master.cs:1164 |  | DATA_OP | p.ColumnTitle["Company_id"] | "Company" | 행/컬럼 값 대입 |  |  |  |
| AC-e414b198 | this.btnUpload.Click | FP00461_PackWorker_Master.cs:1165 |  | DATA_OP | p.ColumnTitle["DIVISION_ID"] | "Division" | 행/컬럼 값 대입 |  |  |  |
| AC-02f08152 | this.btnUpload.Click | FP00461_PackWorker_Master.cs:1166 |  | DATA_OP | p.ColumnTitle["PLANT_ID"] | "Division" | 행/컬럼 값 대입 |  |  |  |
| AC-48c51ab7 | this.btnUpload.Click | FP00461_PackWorker_Master.cs:1167 |  | DATA_OP | p.ColumnTitle["site_id"] | "Site" | 행/컬럼 값 대입 |  |  |  |
| AC-953251e7 | this.btnUpload.Click | FP00461_PackWorker_Master.cs:1168 |  | DATA_OP | p.ColumnTitle["ITEM_ID"] | "Plant" | 행/컬럼 값 대입 |  |  |  |
| AC-3261a448 | this.btnUpload.Click | FP00461_PackWorker_Master.cs:1169 |  | DATA_OP | p.ColumnTitle["FACTORY_ID"] | "Factory" | 행/컬럼 값 대입 |  |  |  |
| AC-ed4d4eae | this.btnUpload.Click | FP00461_PackWorker_Master.cs:1170 |  | DATA_OP | p.ColumnTitle["OPERATION_ID"] | "Operation" | 행/컬럼 값 대입 |  |  |  |
| AC-61f4f6e9 | this.btnUpload.Click | FP00461_PackWorker_Master.cs:1171 |  | DATA_OP | p.ColumnTitle["ITEM_ID"] | "Material" | 행/컬럼 값 대입 |  |  |  |
| AC-a4eb5b85 | this.btnUpload.Click | FP00461_PackWorker_Master.cs:1172 |  | DATA_OP | p.ColumnTitle["LINE_ID"] | "Line" | 행/컬럼 값 대입 |  |  |  |
| AC-a16b6a16 | this.btnUpload.Click | FP00461_PackWorker_Master.cs:1173 |  | DATA_OP | p.ColumnTitle["NICK_NAME"] | "PJT Code" | 행/컬럼 값 대입 |  |  |  |
| AC-934bbc3a | this.btnUpload.Click | FP00461_PackWorker_Master.cs:1174 |  | DATA_OP | p.ColumnTitle["WORKER_QTY"] | "Worker" | 행/컬럼 값 대입 |  |  |  |
| AC-9c244d0b | this.btnUpload.Click | FP00461_PackWorker_Master.cs:1175 |  | DATA_OP | p.ColumnTitle["MESSAGE"] | "Message" | 행/컬럼 값 대입 |  |  |  |
| AC-cc0b6a17 | this.btnUpload.Click | FP00461_PackWorker_Master.cs:1181 |  | POPUP | p.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00461_PackWorker_Master.btnSql_Click

진입점: this.btnSql.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-381cd4d4 | this.btnSql.Click | FP00461_PackWorker_Master.cs:780 |  | POPUP | new FPC0099_SqlPopup | () | 팝업/폼 생성 |  |  |  |
| AC-0a075564 | this.btnSql.Click | FP00461_PackWorker_Master.cs:781 |  | UI_PROP | popSql.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-855f1a07 | this.btnSql.Click | FP00461_PackWorker_Master.cs:783 |  | DATA_OP | popSql.Services.Add | (FindProcedure) | 데이터 객체 조작/조회 |  |  |  |
| AC-5593c2a8 | this.btnSql.Click | FP00461_PackWorker_Master.cs:784 |  | POPUP | popSql.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00461_PackWorker_Master.cblPlant_changed

진입점: clbPlant.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-42917fca | clbPlant.SelectedIndexChanged | FP00461_PackWorker_Master.cs:1372 |  | DATA_OP | Filter["PLANT_ID"] | CString.GetCheckedListValue(dtPlant, clbPlant.ControlValues) | 행/컬럼 값 대입 |  |  |  |

## FP00461_PackWorker_Master.cbo_active_SelectedIndexChanged

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2ae340b5 | (진입점 미연결) | FP00461_PackWorker_Master.cs:1082 | try | DATA_OP | Filter["ACTIVE_FLAG"] | pActive | 행/컬럼 값 대입 |  |  |  |
| AC-b606ec4a | (진입점 미연결) | FP00461_PackWorker_Master.cs:1086 | catch () | DATA_OP | Filter["ACTIVE_FLAG"] | "" | 행/컬럼 값 대입 |  |  |  |

## FP00461_PackWorker_Master.cboLine_changed

진입점: cboLine.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fc2b465f | cboLine.SelectedIndexChanged | FP00461_PackWorker_Master.cs:1391 |  | DATA_OP | Filter["LINE_ID"] | CString.GetCheckedListValue(dtLine, cboLine.ControlValues, true) | 행/컬럼 값 대입 |  |  |  |

## FP00461_PackWorker_Master.cboOperation_changed

진입점: cboOperation.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2dca5d38 | cboOperation.SelectedIndexChanged | FP00461_PackWorker_Master.cs:1385 |  | DATA_OP | Filter["OPERATION_ID"] | CString.GetCheckedListValue(dtOperation, cboOperation.ControlValues, true) | 행/컬럼 값 대입 |  |  |  |

## FP00461_PackWorker_Master.cboSite_changed

진입점: cboSite.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6221a18d | cboSite.SelectedIndexChanged | FP00461_PackWorker_Master.cs:1366 |  | DATA_OP | Filter["SITE_ID"] | CString.GetCheckedListValue(dtSite, cboSite.ControlValues, true) | 행/컬럼 값 대입 |  |  |  |

## FP00461_PackWorker_Master.clbBuilding_changed

진입점: clbFactory.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7d33b0b3 | clbFactory.SelectedIndexChanged | FP00461_PackWorker_Master.cs:1379 |  | DATA_OP | Filter["FACTORY_ID"] | CString.GetCheckedListValue(dtFactoryAmend, clbFactory.ControlValues) | 행/컬럼 값 대입 |  |  |  |

## FP00461_PackWorker_Master.clbDivision_changed

진입점: clbDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9ad401d1 | clbDivision.SelectedIndexChanged | FP00461_PackWorker_Master.cs:1357 |  | DATA_OP | Filter["DIVISION_ID"] | CString.GetCheckedListValue(dtDivision, clbDivision.ControlValues) | 행/컬럼 값 대입 |  |  |  |

## FP00461_PackWorker_Master.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-21cd5d4b | this.Load | FP00461_PackWorker_Master.cs:363 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-40d96379 | this.Load | FP00461_PackWorker_Master.cs:364 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, SpdSheet.shtMain) | 화면 필드/플래그 변경 |  |  |  |
| AC-b73731dc | this.Load | FP00461_PackWorker_Master.cs:367 |  | GRID_INIT | this.AddSheet | (spdTotal, SpdSheet.shtTotal, SpdSheet.shtTotal, 2, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-b220e73d | this.Load | FP00461_PackWorker_Master.cs:368 |  | FLAG | siSub | GetSheetInfo(spdTotal.Name, SpdSheet.shtTotal) | 화면 필드/플래그 변경 |  |  |  |
| AC-eae69141 | this.Load | FP00461_PackWorker_Master.cs:371 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00461_PackWorker_Master.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8b1dd08c | DeleteButton | FP00461_PackWorker_Master.cs:490 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2fa41568 | DeleteButton | FP00461_PackWorker_Master.cs:493 | if (fps.Name == spdMain.Name) | DATA_OP | siMain.Delete | () | 데이터 객체 조작/조회 |  |  |  |
| AC-5e38e6a8 | DeleteButton | FP00461_PackWorker_Master.cs:497 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) | DATA_OP | siSub.Delete | () | 데이터 객체 조작/조회 |  |  |  |

## FP00461_PackWorker_Master.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-65e86d3b | Dispose | FP00461_PackWorker_Master.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00461_PackWorker_Master.DpDate_ValueChanged

진입점: dpDate.ValueChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e151ae74 | dpDate.ValueChanged | FP00461_PackWorker_Master.cs:423 |  | DATA_OP | Filter["BASIS_DATE"] | dpDate.Value.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |

## FP00461_PackWorker_Master.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-34bd9628 | EditButton | FP00461_PackWorker_Master.cs:506 | if (spdMain != null) | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-8288ccb7 | EditButton | FP00461_PackWorker_Master.cs:508 | if (spdMain != null) | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-d5d96eaf | EditButton | FP00461_PackWorker_Master.cs:518 | if (spdMain != null) ▸ if (isEdit) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetColumnIndex("LINE_NAME"), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-68fce488 | EditButton | FP00461_PackWorker_Master.cs:524 | if (spdTotal != null) | FLAG | siSub | GetSheetInfo(spdTotal.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-0f6608b6 | EditButton | FP00461_PackWorker_Master.cs:526 | if (spdTotal != null) | GRID_LOCK | siSub.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-ed6cf7e4 | EditButton | FP00461_PackWorker_Master.cs:536 | if (spdTotal != null) ▸ if (isEdit) | GRID_LOCK | siSub.LockColumn | (0, siSub.GetColumnIndex("PLANT_ID"), true) | 그리드 편집 잠금/해제 |  |  |  |

## FP00461_PackWorker_Master.Excel_Export

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6092da75 | ExcelButton | FP00461_PackWorker_Master.cs:903 |  | EXCEL | ExportExcel | () | 엑셀 내보내기/올리기 |  |  |  |

## FP00461_PackWorker_Master.FilterValidation

진입점: this.btnUpload.Click [if (p.SaveSuccess == true)] / FindButton / SaveButton [if (fps.Name == spdMain.Name) ▸ if (ds.Good())]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-271af566 | this.btnUpload.Click [if (p.SaveSuccess == true)] 외 2 | FP00461_PackWorker_Master.cs:357 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## FP00461_PackWorker_Master.FindAttribute

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-df1ecbc1 | (진입점 미연결) | FP00461_PackWorker_Master.cs:971 | try | CALL_EXT | set.setInitColumns | (0, new List<string> { "lookup_type_code" }) | ⚠ 의미 확인 필요 |  |  |  |
| AC-cb3a5687 | (진입점 미연결) | FP00461_PackWorker_Master.cs:972 | try | CALL_EXT | set.Overwrite | (0, Filter) | ⚠ 의미 확인 필요 |  |  |  |
| AC-80f391b8 | (진입점 미연결) | FP00461_PackWorker_Master.cs:974 | try | COMBO_DATA | Data_FP.CallStandardProcedure | ("FP_Master.PR_UI_FP00180_FINDATTRIBUTE", set, UserInfoContext.Current.UserId, p_sys_type) ⇒ FP_Master.PR_UI_FP00180_FINDATTRIBUTE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-cf63f5ca | (진입점 미연결) | FP00461_PackWorker_Master.cs:974 | try | RETURN | return Data_FP.CallStandardProcedure("FP_Master.PR_UI_FP00180_FINDATTRIBUTE", se… |  | 처리 중단/반환 |  |  |  |
| AC-266d6bd8 | (진입점 미연결) | FP00461_PackWorker_Master.cs:978 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |

## FP00461_PackWorker_Master.FindData

진입점: popSql.OnSql [if (programID == FindProcedure)] / p.DoSearchData / this.btnUpload.Click [if (p.SaveSuccess == true) ▸ try ▸ lambda] / FindButton [try ▸ lambda] / SaveButton [if (fps.Name == spdMain.Name) ▸ if (ds.Good()) ▸ try ▸ lambda]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-53c69261 | popSql.OnSql [if (programID == FindProcedure)] 외 4 | FP00461_PackWorker_Master.cs:1015 | try | FLAG | dtBucket | DataService.FP_ExecuteQuery2("FP00461_PackWorker", "findBucketList", Filter.Dictionary, "M… ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findBucketList] \| FP\Master\FP… | 화면 필드/플래그 변경 |  |  |  |
| AC-dd49a924 | popSql.OnSql [if (programID == FindProcedure)] 외 4 | FP00461_PackWorker_Master.cs:1015 | try | ENDPOINT | DataService.FP_ExecuteQuery2 | ("FP00461_PackWorker", "findBucketList", Filter.Dictionary, "Master") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findBucketList] \| FP\Master\FP… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-172c94b8 | popSql.OnSql [if (programID == FindProcedure)] 외 4 | FP00461_PackWorker_Master.cs:1018 | try ▸ try | DATA_OP | Filter["BUCKET_FROM"] | dtBucket.getColumn(0, "VALUE").ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-99f63752 | popSql.OnSql [if (programID == FindProcedure)] 외 4 | FP00461_PackWorker_Master.cs:1018 | try ▸ try | DATA_OP | dtBucket.getColumn | (0, "VALUE") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-0bd23d6e | popSql.OnSql [if (programID == FindProcedure)] 외 4 | FP00461_PackWorker_Master.cs:1023 | try ▸ try | DATA_OP | Filter["BUCKET_TO"] | dtBucket.getColumn(55, "VALUE").ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-a7d97e9f | popSql.OnSql [if (programID == FindProcedure)] 외 4 | FP00461_PackWorker_Master.cs:1023 | try ▸ try | DATA_OP | dtBucket.getColumn | (55, "VALUE") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-a6b5e041 | popSql.OnSql [if (programID == FindProcedure)] 외 4 | FP00461_PackWorker_Master.cs:1027 | try | FLAG | Calendar | AmendService.ApplyPackWorkerCalendar(dtBucket) | 화면 필드/플래그 변경 |  |  |  |
| AC-5432be02 | popSql.OnSql [if (programID == FindProcedure)] 외 4 | FP00461_PackWorker_Master.cs:1027 | try | CALL_EXT | AmendService.ApplyPackWorkerCalendar | (dtBucket) | ⚠ 의미 확인 필요 |  |  |  |
| AC-56794263 | popSql.OnSql [if (programID == FindProcedure)] 외 4 | FP00461_PackWorker_Master.cs:1032 | try ▸ if (dtBucket.Good()) | DATA_OP | dtBucket.getColumn | (0, "VALUE") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-857dfdab | popSql.OnSql [if (programID == FindProcedure)] 외 4 | FP00461_PackWorker_Master.cs:1033 | try ▸ if (dtBucket.Good()) | DATA_OP | dtBucket.getColumn | (55, "VALUE") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-e4a1e8cd | popSql.OnSql [if (programID == FindProcedure)] 외 4 | FP00461_PackWorker_Master.cs:1036 | try | DATA_OP | Filter["BUCKETLIST"] | SQL | 행/컬럼 값 대입 |  |  |  |
| AC-f4f03832 | popSql.OnSql [if (programID == FindProcedure)] 외 4 | FP00461_PackWorker_Master.cs:1054 | try | DATA_OP | Filter["DAYLIST"] | SQL | 행/컬럼 값 대입 |  |  |  |
| AC-1e5791d8 | popSql.OnSql [if (programID == FindProcedure)] 외 4 | FP00461_PackWorker_Master.cs:1056 | try | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-60195071 | popSql.OnSql [if (programID == FindProcedure)] 외 4 | FP00461_PackWorker_Master.cs:1058 | try | FLAG | dtMaster | DataService.FP_ExecuteProcedure2("PR_UI_FP00461_FIND_FP00461_SUB_OF", set, p_sys_type) | 화면 필드/플래그 변경 |  |  |  |
| AC-a2a3cea3 | popSql.OnSql [if (programID == FindProcedure)] 외 4 | FP00461_PackWorker_Master.cs:1058 | try | ENDPOINT | DataService.FP_ExecuteProcedure2 | ("PR_UI_FP00461_FIND_FP00461_SUB_OF", set, p_sys_type) | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-bf8adca4 | popSql.OnSql [if (programID == FindProcedure)] 외 4 | FP00461_PackWorker_Master.cs:1059 | try | FLAG | dtDetail | DataService.FP_ExecuteProcedure2("PR_UI_FP00461_FIND_FP00461_SUB_DETAIL_OF", set, p_sys_ty… | 화면 필드/플래그 변경 |  |  |  |
| AC-55cb099f | popSql.OnSql [if (programID == FindProcedure)] 외 4 | FP00461_PackWorker_Master.cs:1059 | try | ENDPOINT | DataService.FP_ExecuteProcedure2 | ("PR_UI_FP00461_FIND_FP00461_SUB_DETAIL_OF", set, p_sys_type) | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-e8d55b7f | popSql.OnSql [if (programID == FindProcedure)] 외 4 | FP00461_PackWorker_Master.cs:1060 | try | ENDPOINT | DataService.FP_ExecuteProcedure | (FindProcedure, set, p_sys_type) | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-c2da3d51 | popSql.OnSql [if (programID == FindProcedure)] 외 4 | FP00461_PackWorker_Master.cs:1062 | try | RETURN | return main; |  | 처리 중단/반환 |  |  |  |
| AC-699c14d6 | popSql.OnSql [if (programID == FindProcedure)] 외 4 | FP00461_PackWorker_Master.cs:1066 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |

## FP00461_PackWorker_Master.FindFormAttribute

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-17c7fdc4 | (진입점 미연결) | FP00461_PackWorker_Master.cs:991 | try | CALL_EXT | set.setInitColumns | (0, new List<string> { "lookup_type_code" }) | ⚠ 의미 확인 필요 |  |  |  |
| AC-784629c6 | (진입점 미연결) | FP00461_PackWorker_Master.cs:992 | try | CALL_EXT | set.Overwrite | (0, Filter) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e0d9eb57 | (진입점 미연결) | FP00461_PackWorker_Master.cs:994 | try | COMBO_DATA | Data_FP.CallStandardProcedure | ("FP_Master.PR_UI_FP00180_FINDFORMATTRIBUTE", set, UserInfoContext.Current.UserId, p_sys_t… ⇒ FP_Master.PR_UI_FP00180_FINDFORMATTRIBUTE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-2a8dfdb2 | (진입점 미연결) | FP00461_PackWorker_Master.cs:994 | try | RETURN | return Data_FP.CallStandardProcedure("FP_Master.PR_UI_FP00180_FINDFORMATTRIBUTE"… |  | 처리 중단/반환 |  |  |  |
| AC-03a9a34f | (진입점 미연결) | FP00461_PackWorker_Master.cs:998 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |

## FP00461_PackWorker_Master.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-12654430 | this.Load | FP00461_PackWorker_Master.cs:160 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00461_PackWorker_Master.FP00180_RowCheckDelegate

진입점: p.DoLineCheck

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9fe3faf1 | p.DoLineCheck | FP00461_PackWorker_Master.cs:1148 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## FP00461_PackWorker_Master.FP00180_SaveDataDelegate

진입점: p.DoSaveData

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8efc2859 | p.DoSaveData | FP00461_PackWorker_Master.cs:1115 |  | ENDPOINT | DataService.FP_UpdateBatch | ( "FP00461_PackWorker", "merge_FP00461", data, 0, "MASTER") ⇒ biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=merge_FP00461] \| FP\MASTER\FP00… | 엔드포인트 호출 |  |  |  |
| AC-7520b0f2 | p.DoSaveData | FP00461_PackWorker_Master.cs:1122 | if (ret.DataSet == null) ▸ if (string.IsNullOrWhiteSpace(ret.TableName)) | UI_PROP | ret.TableName | "Table0" | 속성 TableName 설정 |  |  |  |
| AC-7bc524f2 | p.DoSaveData | FP00461_PackWorker_Master.cs:1124 | if (ret.DataSet == null) | DATA_OP | tmp.Tables.Add | (ret) | 데이터 객체 조작/조회 |  |  |  |
| AC-cf8feae4 | p.DoSaveData | FP00461_PackWorker_Master.cs:1126 |  | RETURN | return ret.DataSet; |  | 처리 중단/반환 |  |  |  |

## FP00461_PackWorker_Master.FP00180_SearchDataDelegate

진입점: p.DoSearchData

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2f79dc05 | p.DoSearchData | FP00461_PackWorker_Master.cs:1094 | if (set2.Good()) | DATA_OP | set2.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-2dba55c8 | p.DoSearchData | FP00461_PackWorker_Master.cs:1095 | if (set2.Good()) | DATA_OP | set.Tables[0].Columns.Contains | ("INSERT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-60f37adb | p.DoSearchData | FP00461_PackWorker_Master.cs:1096 | if (set2.Good()) ▸ if (set.Tables[0].Columns.Contains("INSERT_ID")) | DATA_OP | set.Tables[0].Columns.Remove | ("INSERT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-e1c8d041 | p.DoSearchData | FP00461_PackWorker_Master.cs:1097 | if (set2.Good()) | DATA_OP | set.Tables[0].Columns.Contains | ("INSERT_TIME") | 데이터 객체 조작/조회 |  |  |  |
| AC-3e7077ec | p.DoSearchData | FP00461_PackWorker_Master.cs:1098 | if (set2.Good()) ▸ if (set.Tables[0].Columns.Contains("INSERT_TIME")) | DATA_OP | set.Tables[0].Columns.Remove | ("INSERT_TIME") | 데이터 객체 조작/조회 |  |  |  |
| AC-02b643ef | p.DoSearchData | FP00461_PackWorker_Master.cs:1099 | if (set2.Good()) | DATA_OP | set.Tables[0].Columns.Contains | ("UPDATE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-4581a99f | p.DoSearchData | FP00461_PackWorker_Master.cs:1100 | if (set2.Good()) ▸ if (set.Tables[0].Columns.Contains("UPDATE_ID")) | DATA_OP | set.Tables[0].Columns.Remove | ("UPDATE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-420a808d | p.DoSearchData | FP00461_PackWorker_Master.cs:1101 | if (set2.Good()) | DATA_OP | set.Tables[0].Columns.Contains | ("UPDATE_TIME") | 데이터 객체 조작/조회 |  |  |  |
| AC-d0d2c368 | p.DoSearchData | FP00461_PackWorker_Master.cs:1102 | if (set2.Good()) ▸ if (set.Tables[0].Columns.Contains("UPDATE_TIME")) | DATA_OP | set.Tables[0].Columns.Remove | ("UPDATE_TIME") | 데이터 객체 조작/조회 |  |  |  |
| AC-b9a1dba4 | p.DoSearchData | FP00461_PackWorker_Master.cs:1103 | if (set2.Good()) | DATA_OP | set.Tables[0].Columns.Contains | ("EDIT_YN") | 데이터 객체 조작/조회 |  |  |  |
| AC-7aefd9ee | p.DoSearchData | FP00461_PackWorker_Master.cs:1104 | if (set2.Good()) ▸ if (set.Tables[0].Columns.Contains("EDIT_YN")) | DATA_OP | set.Tables[0].Columns.Remove | ("EDIT_YN") | 데이터 객체 조작/조회 |  |  |  |
| AC-a0cac45b | p.DoSearchData | FP00461_PackWorker_Master.cs:1105 | if (set2.Good()) | DATA_OP | set.Tables[0].Columns.Contains | ("LINE_NAME") | 데이터 객체 조작/조회 |  |  |  |
| AC-276af255 | p.DoSearchData | FP00461_PackWorker_Master.cs:1106 | if (set2.Good()) ▸ if (set.Tables[0].Columns.Contains("LINE_NAME")) | DATA_OP | set.Tables[0].Columns.Remove | ("LINE_NAME") | 데이터 객체 조작/조회 |  |  |  |
| AC-6e8c505e | p.DoSearchData | FP00461_PackWorker_Master.cs:1107 | if (set2.Good()) | RETURN | return set; |  | 처리 중단/반환 |  |  |  |
| AC-4477784c | p.DoSearchData | FP00461_PackWorker_Master.cs:1110 |  | RETURN | return set2; |  | 처리 중단/반환 |  |  |  |

## FP00461_PackWorker_Master.FP00180_ValidateDataDelegate

진입점: p.DoValidationData

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d9d0e60c | p.DoValidationData | FP00461_PackWorker_Master.cs:1132 |  | DATA_OP | column_params.Add | ("USER_ID", UserInfoContext.Current.UserId) | 데이터 객체 조작/조회 |  |  |  |
| AC-5a07cfc9 | p.DoValidationData | FP00461_PackWorker_Master.cs:1133 |  | ENDPOINT | DataService.FP_ExecuteNonQuery | ( "FP00461_PackWorker", "delete_Excel_buffer", column_params, "MASTER") ⇒ biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=delete_Excel_buffer] \| FP\M… | 엔드포인트 호출 |  |  |  |
| AC-18d3c624 | p.DoValidationData | FP00461_PackWorker_Master.cs:1137 |  | ENDPOINT | DataService.FP_UpdateBatch | ( "FP00461_PackWorker", "insert_Excel_buffer", data,0, "MASTER") ⇒ biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=insert_Excel_buffer] \| FP\MASTE… | 엔드포인트 호출 |  |  |  |
| AC-2758772e | p.DoValidationData | FP00461_PackWorker_Master.cs:1141 |  | ENDPOINT | DataService.FP_ExecuteQuery | ( "FP00461_PackWorker", "find_Excel_buffer_validation", column_params,"MASTER") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Excel_buffer_validation] \… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-7e6f5101 | p.DoValidationData | FP00461_PackWorker_Master.cs:1141 |  | RETURN | return DataService.FP_ExecuteQuery( "FP00461_PackWorker", "find_Excel_buffer_val… |  | 처리 중단/반환 |  |  |  |

## FP00461_PackWorker_Master.GetDate

진입점: this.Load / dpDate.ValueChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6f6c8b47 | this.Load 외 1 | FP00461_PackWorker_Master.cs:300 |  | FLAG | dtBucket | DataService.FP_ExecuteQuery2("FP00461_PackWorker", "findWeekFirstDay", Filter.Dictionary, … ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findWeekFirstDay] \| FP\Master\… | 화면 필드/플래그 변경 |  |  |  |
| AC-3695046a | this.Load 외 1 | FP00461_PackWorker_Master.cs:300 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ("FP00461_PackWorker", "findWeekFirstDay", Filter.Dictionary, "Master") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findWeekFirstDay] \| FP\Master\… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-675567b6 | this.Load 외 1 | FP00461_PackWorker_Master.cs:306 | if (dtBucket.Good()) ▸ for (i<100) | DATA_OP | Filter[string.Format("D{0}", i)] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-770ea95c | this.Load 외 1 | FP00461_PackWorker_Master.cs:307 | if (dtBucket.Good()) ▸ for (i<100) | DATA_OP | Filter[string.Format("W{0}", i)] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-de5b5ff1 | this.Load 외 1 | FP00461_PackWorker_Master.cs:316 | if (dtBucket.Good()) ▸ foreach (DataRow row in dtBucket.Rows) | DATA_OP | Filter[d_col_name] | d_val | 행/컬럼 값 대입 |  |  |  |
| AC-0120d083 | this.Load 외 1 | FP00461_PackWorker_Master.cs:326 | if (dtBucket.Good()) ▸ foreach (DataRow row in dtBucket.Rows) ▸ if (w_val != week.ToString()) | DATA_OP | Filter[w_col_name] | w_val | 행/컬럼 값 대입 |  |  |  |

## FP00461_PackWorker_Master.GetDivision

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3859cc6f | this.Load | FP00461_PackWorker_Master.cs:240 |  | FLAG | dtDivision | Data_FP.Common_FP(Data_FP.Type.DIVISION, false, CurrentUser, _sNonAuth, _sSaveAuth , null,… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 화면 필드/플래그 변경 |  |  |  |
| AC-8fa79c2b | this.Load | FP00461_PackWorker_Master.cs:240 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.DIVISION, false, CurrentUser, _sNonAuth, _sSaveAuth , null, null, null, null… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-39ff21d5 | this.Load | FP00461_PackWorker_Master.cs:242 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, clbDivision, false) | 목록 컨트롤 재구성 |  |  |  |

## FP00461_PackWorker_Master.GetFactory

진입점: this.Load / clbPlant.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0bf69f3b | this.Load 외 1 | FP00461_PackWorker_Master.cs:264 |  | FLAG | dtFactoryAmend | Data_FP.Common_FP(Data_FP.Type.FACTORY_CODE, false, CurrentUser, _sNonAuth, _sSaveAuth , n… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY_CODE] | 화면 필드/플래그 변경 |  |  |  |
| AC-37e3639d | this.Load 외 1 | FP00461_PackWorker_Master.cs:264 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.FACTORY_CODE, false, CurrentUser, _sNonAuth, _sSaveAuth , null, null,null, n… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY_CODE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-d7744bc3 | this.Load 외 1 | FP00461_PackWorker_Master.cs:269 |  | LIST_REBIND | clsCtrl.setListBox | (dtFactoryAmend, clbFactory, false) | 목록 컨트롤 재구성 |  |  |  |

## FP00461_PackWorker_Master.GetLine

진입점: this.Load / cboOperation.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-010f0688 | this.Load 외 1 | FP00461_PackWorker_Master.cs:287 |  | FLAG | dtLine | Data_FP.Common_FP(Data_FP.Type.LINE, false, UserInfoContext.Current.UserId, _sNonAuth, _sS… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=LINE] | 화면 필드/플래그 변경 |  |  |  |
| AC-198e5da4 | this.Load 외 1 | FP00461_PackWorker_Master.cs:287 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.LINE, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth,null, nul… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=LINE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-df98a03a | this.Load 외 1 | FP00461_PackWorker_Master.cs:291 |  | LIST_REBIND | clsCtrl.setListBox | (dtLine, cboLine, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## FP00461_PackWorker_Master.GetOperation

진입점: this.Load / clbFactory.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b1cd33d8 | this.Load 외 1 | FP00461_PackWorker_Master.cs:275 |  | FLAG | dtOperation | Data_FP.Common_FP(Data_FP.Type.OPERATION, false, CurrentUser, _sNonAuth, _sSaveAuth , null… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=OPERATION] | 화면 필드/플래그 변경 |  |  |  |
| AC-3fc337f1 | this.Load 외 1 | FP00461_PackWorker_Master.cs:275 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.OPERATION, false, CurrentUser, _sNonAuth, _sSaveAuth , null, null, null, nul… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=OPERATION] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-1c7c52c8 | this.Load 외 1 | FP00461_PackWorker_Master.cs:280 |  | LIST_REBIND | clsCtrl.setListBox | (dtOperation, cboOperation, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## FP00461_PackWorker_Master.GetPlant

진입점: this.Load / clbDivision.SelectedIndexChanged / cboSite.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-af85a585 | this.Load 외 2 | FP00461_PackWorker_Master.cs:256 |  | FLAG | dtPlant | Data_FP.Common_FP(Data_FP.Type.PLANT, false, CurrentUser, _sNonAuth, _sSaveAuth , null, nu… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 화면 필드/플래그 변경 |  |  |  |
| AC-4197b07e | this.Load 외 2 | FP00461_PackWorker_Master.cs:256 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.PLANT, false, CurrentUser, _sNonAuth, _sSaveAuth , null, null, null, null, F… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-744bade0 | this.Load 외 2 | FP00461_PackWorker_Master.cs:258 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlant, clbPlant, false) | 목록 컨트롤 재구성 |  |  |  |

## FP00461_PackWorker_Master.GetSite

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-19ff6f1e | this.Load | FP00461_PackWorker_Master.cs:247 |  | FLAG | dtSite | Data_FP.Common_FP(Data_FP.Type.SITE, false, CurrentUser, _sNonAuth, _sSaveAuth , null, nul… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 화면 필드/플래그 변경 |  |  |  |
| AC-a0be2afb | this.Load | FP00461_PackWorker_Master.cs:247 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.SITE, false, CurrentUser, _sNonAuth, _sSaveAuth , null, null, null, null, nu… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-b9726b2d | this.Load | FP00461_PackWorker_Master.cs:249 |  | LIST_REBIND | clsCtrl.setListBox | (dtSite, cboSite, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-53968963 | this.Load | FP00461_PackWorker_Master.cs:251 | if (cboSite.Items.Count > 1) | VALUE_SET | cboSite.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |

## FP00461_PackWorker_Master.InitComponents

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e02c43eb | this.Load | FP00461_PackWorker_Master.cs:196 |  | VALUE_SET | dpDate.Value | DateTime.Now.Date | 컨트롤 값 설정 |  |  |  |
| AC-0f0d38ae | this.Load | FP00461_PackWorker_Master.cs:197 |  | DATA_OP | Filter["BUCKET_FROM"] | dpDate.Value.AddDays(-7).Date.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-ef5efb25 | this.Load | FP00461_PackWorker_Master.cs:198 |  | DATA_OP | Filter["BUCKET_TO"] | dpDate.Value.AddDays(55).Date.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-7f67808d | this.Load | FP00461_PackWorker_Master.cs:199 |  | DATA_OP | Filter["BASIS_DATE"] | DateTime.Now.Date.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-a9bf685a | this.Load | FP00461_PackWorker_Master.cs:205 |  | DATA_OP | Filter["DIVISION_ID"] | CString.GetCheckedListValue(dtDivision, clbDivision.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-42adf392 | this.Load | FP00461_PackWorker_Master.cs:209 |  | DATA_OP | Filter["SITE_ID"] | CString.GetCheckedListValue(dtSite, clbPlant.ControlValues, true) | 행/컬럼 값 대입 |  |  |  |
| AC-c637b812 | this.Load | FP00461_PackWorker_Master.cs:214 |  | DATA_OP | Filter["PLANT_ID"] | CString.GetCheckedListValue(dtPlant, clbPlant.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-6acace54 | this.Load | FP00461_PackWorker_Master.cs:219 |  | DATA_OP | Filter["FACTORY_ID"] | CString.GetCheckedListValue(dtFactoryAmend, clbFactory.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-3cfc3756 | this.Load | FP00461_PackWorker_Master.cs:224 |  | DATA_OP | Filter["OPERATION_ID"] | CString.GetCheckedListValue(dtOperation, cboOperation.ControlValues, true) | 행/컬럼 값 대입 |  |  |  |
| AC-2f573a99 | this.Load | FP00461_PackWorker_Master.cs:228 |  | DATA_OP | Filter["LINE_ID"] | CString.GetCheckedListValue(dtLine, cboLine.ControlValues, true) | 행/컬럼 값 대입 |  |  |  |

## FP00461_PackWorker_Master.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7ae2de1f | this.Load | FP00461_PackWorker_Master.cs:174 | try | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-c618cc74 | this.Load | FP00461_PackWorker_Master.cs:176 | try | FLAG | _sNonAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-abdd8be2 | this.Load | FP00461_PackWorker_Master.cs:177 | try | FLAG | _sSaveAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-870cab30 | this.Load | FP00461_PackWorker_Master.cs:180 | try | LIST_REBIND | clsCtrl.setListBox | (dtYesOrNo, cboLine, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-2898ef6d | this.Load | FP00461_PackWorker_Master.cs:181 | try | VALUE_SET | cboLine.InitValue | "Y" | 컨트롤 값 설정 |  |  |  |
| AC-7a5fad44 | this.Load | FP00461_PackWorker_Master.cs:186 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-6e9d60fe | this.Load | FP00461_PackWorker_Master.cs:189 |  | DATA_OP | Filter["USER_ID"] | CurrentUser = UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-dfb09843 | this.Load | FP00461_PackWorker_Master.cs:189 |  | FLAG | CurrentUser | UserInfoContext.Current.UserId | 화면 필드/플래그 변경 |  |  |  |

## FP00461_PackWorker_Master.InitEvent

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-425a9562 | this.Load | FP00461_PackWorker_Master.cs:401 |  | UI_PROP | clbDivision.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-58eb0c5d | this.Load | FP00461_PackWorker_Master.cs:402 |  | UI_PROP | clbPlant.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-da59eefe | this.Load | FP00461_PackWorker_Master.cs:403 |  | UI_PROP | clbFactory.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |

## FP00461_PackWorker_Master.InitSpread

진입점: this.Load / this.btnUpload.Click [if (p.SaveSuccess == true) ▸ try] / FindButton [try] / SaveButton [if (fps.Name == spdMain.Name) ▸ if (ds.Good()) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cf933d7e | this.Load 외 3 | FP00461_PackWorker_Master.cs:380 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.InitSheet | (spreadInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-9f0f79f9 | this.Load 외 3 | FP00461_PackWorker_Master.cs:382 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.SetSheetHeaderColumn_FP | (spreadInfo, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-fcde50db | this.Load 외 3 | FP00461_PackWorker_Master.cs:388 | if (spreadInfo.SheetName == SpdSheet.shtTotal) | GRID_INIT | spreadInfo.InitSheet | (spreadInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-08e3d874 | this.Load 외 3 | FP00461_PackWorker_Master.cs:390 | if (spreadInfo.SheetName == SpdSheet.shtTotal) | GRID_INIT | spreadInfo.SetSheetHeaderColumn_FP | (spreadInfo,2 ) | 그리드 재구성/초기화 |  |  |  |

## FP00461_PackWorker_Master.InsertButton

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5d58574c | InsertButton | FP00461_PackWorker_Master.cs:446 | if (fps.Name == spdTotal.Name) | POPUP | new FP00461_PackWorkerAddPopup | () | 팝업/폼 생성 |  |  |  |
| AC-22dcc3c3 | InsertButton | FP00461_PackWorker_Master.cs:447 | if (fps.Name == spdTotal.Name) | UI_PROP | addPopup.Filter | Filter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-8ca34eaf | InsertButton | FP00461_PackWorker_Master.cs:447 | if (fps.Name == spdTotal.Name) | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-f5c8bbcc | InsertButton | FP00461_PackWorker_Master.cs:449 | if (fps.Name == spdTotal.Name) | DATA_OP | addPopup.Filter["DIVISION_ID"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-b7e6e12c | InsertButton | FP00461_PackWorker_Master.cs:450 | if (fps.Name == spdTotal.Name) | DATA_OP | addPopup.Filter["SITE_ID"] | sSite | 행/컬럼 값 대입 |  |  |  |
| AC-bcda58f6 | InsertButton | FP00461_PackWorker_Master.cs:451 | if (fps.Name == spdTotal.Name) | DATA_OP | addPopup.Filter["PLANT_ID"] | sPlant | 행/컬럼 값 대입 |  |  |  |
| AC-1b6f3f3f | InsertButton | FP00461_PackWorker_Master.cs:453 | if (fps.Name == spdTotal.Name) | POPUP | addPopup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-7778f487 | InsertButton | FP00461_PackWorker_Master.cs:464 | if (fps.Name == spdTotal.Name) ▸ if (res == DialogResult.OK) ▸ if (!string.IsNullOrWhiteSpace(addPopup._CompanyId) && !string.IsNullOrWhiteS… | DATA_OP | defaultData.Add | ("COMPANY_ID", addPopup._CompanyId) | 데이터 객체 조작/조회 |  |  |  |
| AC-36725a7a | InsertButton | FP00461_PackWorker_Master.cs:465 | if (fps.Name == spdTotal.Name) ▸ if (res == DialogResult.OK) ▸ if (!string.IsNullOrWhiteSpace(addPopup._CompanyId) && !string.IsNullOrWhiteS… | DATA_OP | defaultData.Add | ("DIVISION_ID", addPopup._DivisionId) | 데이터 객체 조작/조회 |  |  |  |
| AC-858ac710 | InsertButton | FP00461_PackWorker_Master.cs:466 | if (fps.Name == spdTotal.Name) ▸ if (res == DialogResult.OK) ▸ if (!string.IsNullOrWhiteSpace(addPopup._CompanyId) && !string.IsNullOrWhiteS… | DATA_OP | defaultData.Add | ("SITE_ID", addPopup._SiteId) | 데이터 객체 조작/조회 |  |  |  |
| AC-9fb9e65a | InsertButton | FP00461_PackWorker_Master.cs:467 | if (fps.Name == spdTotal.Name) ▸ if (res == DialogResult.OK) ▸ if (!string.IsNullOrWhiteSpace(addPopup._CompanyId) && !string.IsNullOrWhiteS… | DATA_OP | defaultData.Add | ("PLANT_ID", addPopup._PlantId) | 데이터 객체 조작/조회 |  |  |  |
| AC-c5554c2b | InsertButton | FP00461_PackWorker_Master.cs:469 | if (fps.Name == spdTotal.Name) ▸ if (res == DialogResult.OK) ▸ if (!string.IsNullOrWhiteSpace(addPopup._CompanyId) && !string.IsNullOrWhiteS… | CALL_EXT | siSub.HasValue | (defaultData) | ⚠ 의미 확인 필요 |  |  |  |
| AC-15af92ab | InsertButton | FP00461_PackWorker_Master.cs:471 | if (fps.Name == spdTotal.Name) ▸ if (res == DialogResult.OK) ▸ if (!string.IsNullOrWhiteSpace(addPopup._CompanyId) && !string.IsNullOrWhiteS… | MESSAGE | MessageBox.Show | ("Duplicated Data Exists") | 메시지 표시 |  |  |  |
| AC-35997bbe | InsertButton | FP00461_PackWorker_Master.cs:475 | if (fps.Name == spdTotal.Name) ▸ if (res == DialogResult.OK) ▸ if (!string.IsNullOrWhiteSpace(addPopup._CompanyId) && !string.IsNullOrWhiteS… | DATA_OP | siSub.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-445f54ff | InsertButton | FP00461_PackWorker_Master.cs:476 | if (fps.Name == spdTotal.Name) ▸ if (res == DialogResult.OK) ▸ if (!string.IsNullOrWhiteSpace(addPopup._CompanyId) && !string.IsNullOrWhiteS… | GRID_SET | siSub.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |
| AC-890813c1 | InsertButton | FP00461_PackWorker_Master.cs:479 | if (fps.Name == spdTotal.Name) ▸ if (res == DialogResult.OK) ▸ if (!string.IsNullOrWhiteSpace(addPopup._CompanyId) && !string.IsNullOrWhiteS… | GRID_SET | siSub.SetValue | (insCell.Row.Index, start+1, insCell.Row.Index, tail, "0") | 그리드 값 설정 |  |  |  |

## FP00461_PackWorker_Master.InsertRow

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cff89790 | (진입점 미연결) | FP00461_PackWorker_Master.cs:914 | if (spdMain != null) | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## FP00461_PackWorker_Master.RunSqlSource

진입점: popSql.OnSql

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-29cc667a | popSql.OnSql | FP00461_PackWorker_Master.cs:957 | if (programID == FindProcedure) | RETURN | return FindData(false); |  | 처리 중단/반환 |  |  |  |
| AC-212961ef | popSql.OnSql | FP00461_PackWorker_Master.cs:959 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00461_PackWorker_Master.Save_Data

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8f14c75b | SaveButton | FP00461_PackWorker_Master.cs:556 | if (fps.Name == spdMain.Name) ▸ if (ds.Good()) | DATA_OP | ds.Tables[0].Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-fd2e36c4 | SaveButton | FP00461_PackWorker_Master.cs:570 | if (fps.Name == spdMain.Name) ▸ if (ds.Good()) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (origin != changed) | CALL_EXT | toSave.copyInsert | (origin_row) | ⚠ 의미 확인 필요 |  |  |  |
| AC-5c5bd380 | SaveButton | FP00461_PackWorker_Master.cs:605 | if (fps.Name == spdMain.Name) ▸ if (ds.Good()) ▸ if (a == 0 && m == 0 && d == 0 && t == 0) | MESSAGE | MessageBox.Show | ("There is no change") | 메시지 표시 |  |  |  |
| AC-c549ea36 | SaveButton | FP00461_PackWorker_Master.cs:606 | if (fps.Name == spdMain.Name) ▸ if (ds.Good()) ▸ if (a == 0 && m == 0 && d == 0 && t == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-91c979d6 | SaveButton | FP00461_PackWorker_Master.cs:608 | if (fps.Name == spdMain.Name) ▸ if (ds.Good()) | DATA_OP | toSave.Columns.Contains | ("USER_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-7c3b6548 | SaveButton | FP00461_PackWorker_Master.cs:609 | if (fps.Name == spdMain.Name) ▸ if (ds.Good()) ▸ if (!toSave.Columns.Contains("USER_ID")) | DATA_OP | toSave.Columns.Add | (new DataColumn("USER_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-ca57f3bf | SaveButton | FP00461_PackWorker_Master.cs:612 | if (fps.Name == spdMain.Name) ▸ if (ds.Good()) ▸ foreach (DataRow ro in toSave.Rows) | DATA_OP | ro["USER_ID"] | user_id = UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-0a916153 | SaveButton | FP00461_PackWorker_Master.cs:612 | if (fps.Name == spdMain.Name) ▸ if (ds.Good()) ▸ foreach (DataRow ro in toSave.Rows) | FLAG | user_id | UserInfoContext.Current.UserId | 화면 필드/플래그 변경 |  |  |  |
| AC-4198850b | SaveButton | FP00461_PackWorker_Master.cs:614 | if (fps.Name == spdMain.Name) ▸ if (ds.Good()) | ENDPOINT | DataService.FP_UpdateBatch2 | ("FP00461_PackWorker", "saveAll_FP00461", toSave,0, "Master") ⇒ biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=saveAll_FP00461] \| FP\Master\FP… | 엔드포인트 호출 |  |  |  |
| AC-79cea0da | SaveButton | FP00461_PackWorker_Master.cs:617 | if (fps.Name == spdMain.Name) ▸ if (ds.Good()) ▸ if (res.Good() && res.Rows[0]["RESULT"].ToString()=="SUCCESS") | MESSAGE | MessageBox.Show | (string.Format("Success : {0} Data Saved", res.Rows[0]["COUNT"])) | 메시지 표시 |  |  |  |
| AC-838130ee | SaveButton | FP00461_PackWorker_Master.cs:621 | if (fps.Name == spdMain.Name) ▸ if (ds.Good()) ▸ else of (res.Good() && res.Rows[0]["RESULT"].ToString()=="SUCCESS") | MESSAGE | MessageBox.Show | (string.Format("Fail : {0}", res.Rows[0]["EXCEPTION"])) | 메시지 표시 |  |  |  |
| AC-3e68c977 | SaveButton | FP00461_PackWorker_Master.cs:637 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) ▸ if (ds.Good()) | UI_PROP | toSave.TableName | "Table" | 속성 TableName 설정 |  |  |  |
| AC-1840af31 | SaveButton | FP00461_PackWorker_Master.cs:638 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) ▸ if (ds.Good()) | DATA_OP | toSave.Columns.Add | (new DataColumn("COMPANY_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-0ac5a753 | SaveButton | FP00461_PackWorker_Master.cs:639 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) ▸ if (ds.Good()) | DATA_OP | toSave.Columns.Add | (new DataColumn("DIVISION_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-0874f8bb | SaveButton | FP00461_PackWorker_Master.cs:640 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) ▸ if (ds.Good()) | DATA_OP | toSave.Columns.Add | (new DataColumn("SITE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-27c230b8 | SaveButton | FP00461_PackWorker_Master.cs:641 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) ▸ if (ds.Good()) | DATA_OP | toSave.Columns.Add | (new DataColumn("PLANT_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-641b726b | SaveButton | FP00461_PackWorker_Master.cs:642 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) ▸ if (ds.Good()) | DATA_OP | toSave.Columns.Add | (new DataColumn("WORK_DATE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-a95429d2 | SaveButton | FP00461_PackWorker_Master.cs:643 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) ▸ if (ds.Good()) | DATA_OP | toSave.Columns.Add | (new DataColumn("WORKER_QTY", typeof(decimal))) | 데이터 객체 조작/조회 |  |  |  |
| AC-44da7ee2 | SaveButton | FP00461_PackWorker_Master.cs:644 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) ▸ if (ds.Good()) | DATA_OP | toSave.Columns.Add | (new DataColumn("USER_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-7f635049 | SaveButton | FP00461_PackWorker_Master.cs:646 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) ▸ if (ds.Good()) | DATA_OP | toSave.Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-95c5806e | SaveButton | FP00461_PackWorker_Master.cs:673 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) ▸ if (ds.Good()) ▸ foreach (FarPoint.Win.Spread.Row xlsRow in siSub.Acti… | DATA_OP | toSave.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-2572268d | SaveButton | FP00461_PackWorker_Master.cs:674 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) ▸ if (ds.Good()) ▸ foreach (FarPoint.Win.Spread.Row xlsRow in siSub.Acti… | DATA_OP | saved["WORKER_QTY"] | val1 | 행/컬럼 값 대입 |  |  |  |
| AC-fdd7da80 | SaveButton | FP00461_PackWorker_Master.cs:675 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) ▸ if (ds.Good()) ▸ foreach (FarPoint.Win.Spread.Row xlsRow in siSub.Acti… | DATA_OP | saved["WORK_DATE"] | Calendar.Days.ElementAt(i-1).Value.Date.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-d13e597e | SaveButton | FP00461_PackWorker_Master.cs:676 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) ▸ if (ds.Good()) ▸ foreach (FarPoint.Win.Spread.Row xlsRow in siSub.Acti… | DATA_OP | saved["COMPANY_ID"] | company | 행/컬럼 값 대입 |  |  |  |
| AC-8f2b7291 | SaveButton | FP00461_PackWorker_Master.cs:677 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) ▸ if (ds.Good()) ▸ foreach (FarPoint.Win.Spread.Row xlsRow in siSub.Acti… | DATA_OP | saved["DIVISION_ID"] | division | 행/컬럼 값 대입 |  |  |  |
| AC-e963a85c | SaveButton | FP00461_PackWorker_Master.cs:678 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) ▸ if (ds.Good()) ▸ foreach (FarPoint.Win.Spread.Row xlsRow in siSub.Acti… | DATA_OP | saved["SITE_ID"] | site | 행/컬럼 값 대입 |  |  |  |
| AC-9cc72f66 | SaveButton | FP00461_PackWorker_Master.cs:679 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) ▸ if (ds.Good()) ▸ foreach (FarPoint.Win.Spread.Row xlsRow in siSub.Acti… | DATA_OP | saved["PLANT_ID"] | plant | 행/컬럼 값 대입 |  |  |  |
| AC-bad45b59 | SaveButton | FP00461_PackWorker_Master.cs:680 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) ▸ if (ds.Good()) ▸ foreach (FarPoint.Win.Spread.Row xlsRow in siSub.Acti… | DATA_OP | saved["USER_ID"] | CurrentUser | 행/컬럼 값 대입 |  |  |  |
| AC-d7a3b78a | SaveButton | FP00461_PackWorker_Master.cs:681 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) ▸ if (ds.Good()) ▸ foreach (FarPoint.Win.Spread.Row xlsRow in siSub.Acti… | DATA_OP | toSave.Rows.Add | (saved) | 데이터 객체 조작/조회 |  |  |  |
| AC-a1871d59 | SaveButton | FP00461_PackWorker_Master.cs:686 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) ▸ if (ds.Good()) ▸ foreach (FarPoint.Win.Spread.Row xlsRow in siSub.Acti… | DATA_OP | toSave.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-d10f9436 | SaveButton | FP00461_PackWorker_Master.cs:687 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) ▸ if (ds.Good()) ▸ foreach (FarPoint.Win.Spread.Row xlsRow in siSub.Acti… | DATA_OP | saved["WORKER_QTY"] | val1 | 행/컬럼 값 대입 |  |  |  |
| AC-878d325b | SaveButton | FP00461_PackWorker_Master.cs:688 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) ▸ if (ds.Good()) ▸ foreach (FarPoint.Win.Spread.Row xlsRow in siSub.Acti… | DATA_OP | saved["WORK_DATE"] | Calendar.Days.ElementAt(i-1).Value.Date.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-210a89b4 | SaveButton | FP00461_PackWorker_Master.cs:689 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) ▸ if (ds.Good()) ▸ foreach (FarPoint.Win.Spread.Row xlsRow in siSub.Acti… | DATA_OP | saved["COMPANY_ID"] | company | 행/컬럼 값 대입 |  |  |  |
| AC-10ec30ab | SaveButton | FP00461_PackWorker_Master.cs:690 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) ▸ if (ds.Good()) ▸ foreach (FarPoint.Win.Spread.Row xlsRow in siSub.Acti… | DATA_OP | saved["DIVISION_ID"] | division | 행/컬럼 값 대입 |  |  |  |
| AC-aebacec8 | SaveButton | FP00461_PackWorker_Master.cs:691 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) ▸ if (ds.Good()) ▸ foreach (FarPoint.Win.Spread.Row xlsRow in siSub.Acti… | DATA_OP | saved["SITE_ID"] | site | 행/컬럼 값 대입 |  |  |  |
| AC-8b1d8731 | SaveButton | FP00461_PackWorker_Master.cs:692 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) ▸ if (ds.Good()) ▸ foreach (FarPoint.Win.Spread.Row xlsRow in siSub.Acti… | DATA_OP | saved["PLANT_ID"] | plant | 행/컬럼 값 대입 |  |  |  |
| AC-e0f5b7e1 | SaveButton | FP00461_PackWorker_Master.cs:693 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) ▸ if (ds.Good()) ▸ foreach (FarPoint.Win.Spread.Row xlsRow in siSub.Acti… | DATA_OP | saved["USER_ID"] | CurrentUser | 행/컬럼 값 대입 |  |  |  |
| AC-d335701f | SaveButton | FP00461_PackWorker_Master.cs:694 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) ▸ if (ds.Good()) ▸ foreach (FarPoint.Win.Spread.Row xlsRow in siSub.Acti… | DATA_OP | toSave.Rows.Add | (saved) | 데이터 객체 조작/조회 |  |  |  |
| AC-2460bb49 | SaveButton | FP00461_PackWorker_Master.cs:722 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) ▸ if (ds.Good()) ▸ foreach (FarPoint.Win.Spread.Row xlsRow in siSub.Acti… | CALL_EXT | toSave.copyInsert | (row) | ⚠ 의미 확인 필요 |  |  |  |
| AC-7b633a6b | SaveButton | FP00461_PackWorker_Master.cs:723 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) ▸ if (ds.Good()) ▸ foreach (FarPoint.Win.Spread.Row xlsRow in siSub.Acti… | DATA_OP | saved["WORKER_QTY"] | val1 | 행/컬럼 값 대입 |  |  |  |
| AC-51e60e23 | SaveButton | FP00461_PackWorker_Master.cs:724 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) ▸ if (ds.Good()) ▸ foreach (FarPoint.Win.Spread.Row xlsRow in siSub.Acti… | DATA_OP | saved["WORK_DATE"] | Calendar.Days.ElementAt(i-1).Value.Date.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-ce19cd2b | SaveButton | FP00461_PackWorker_Master.cs:745 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) ▸ if (ds.Good()) ▸ foreach (FarPoint.Win.Spread.Row xlsRow in siSub.Acti… | CALL_EXT | toDelete.copyInsert | (row) | ⚠ 의미 확인 필요 |  |  |  |
| AC-965d3411 | SaveButton | FP00461_PackWorker_Master.cs:750 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) ▸ if (ds.Good()) ▸ if (a == 0 && m == 0 && d == 0 && t == 0) | MESSAGE | MessageBox.Show | ("There is no change") | 메시지 표시 |  |  |  |
| AC-23a824b1 | SaveButton | FP00461_PackWorker_Master.cs:751 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) ▸ if (ds.Good()) ▸ if (a == 0 && m == 0 && d == 0 && t == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-738c0da5 | SaveButton | FP00461_PackWorker_Master.cs:753 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) ▸ if (ds.Good()) | DATA_OP | toSave.Columns.Contains | ("USER_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-3496b7f2 | SaveButton | FP00461_PackWorker_Master.cs:754 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) ▸ if (ds.Good()) ▸ if (!toSave.Columns.Contains("USER_ID")) | DATA_OP | toSave.Columns.Add | (new DataColumn("USER_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-f98d4153 | SaveButton | FP00461_PackWorker_Master.cs:757 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) ▸ if (ds.Good()) ▸ foreach (DataRow ro in toSave.Rows) | DATA_OP | ro["USER_ID"] | user_id = UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-e1c83887 | SaveButton | FP00461_PackWorker_Master.cs:757 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) ▸ if (ds.Good()) ▸ foreach (DataRow ro in toSave.Rows) | FLAG | user_id | UserInfoContext.Current.UserId | 화면 필드/플래그 변경 |  |  |  |
| AC-f6d02398 | SaveButton | FP00461_PackWorker_Master.cs:759 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) ▸ if (ds.Good()) | ENDPOINT | DataService.FP_UpdateBatch2 | ("FP00461_PackWorker", "saveAll_FP00461_sub", toSave, 0, "Master") ⇒ biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=saveAll_FP00461_sub] \| FP\Maste… | 엔드포인트 호출 |  |  |  |
| AC-9194bc47 | SaveButton | FP00461_PackWorker_Master.cs:762 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) ▸ if (ds.Good()) ▸ if (res.Good() && res.Rows[0]["RESULT"].ToString() ==… | MESSAGE | MessageBox.Show | (string.Format("Success : {0} Data Saved", res.Rows[0]["COUNT"])) | 메시지 표시 |  |  |  |
| AC-27ee2973 | SaveButton | FP00461_PackWorker_Master.cs:766 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) ▸ if (ds.Good()) ▸ else of (res.Good() && res.Rows[0]["RESULT"].ToString… | MESSAGE | MessageBox.Show | (string.Format("Fail : {0}", res.Rows[0]["EXCEPTION"])) | 메시지 표시 |  |  |  |

## FP00461_PackWorker_Master.SaveButton

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-de2b0531 | SaveButton | FP00461_PackWorker_Master.cs:544 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00461_PackWorker_Master.SetDevOption

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7f6e28b6 | this.Load | FP00461_PackWorker_Master.cs:143 |  | CALL_EXT | UserService.HasExtraRole | (CurrentUser) | ⚠ 의미 확인 필요 |  |  |  |
| AC-441fb2b4 | this.Load | FP00461_PackWorker_Master.cs:145 | if (UserService.HasExtraRole(CurrentUser)) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-3c105eb0 | this.Load | FP00461_PackWorker_Master.cs:149 | else of (UserService.HasExtraRole(CurrentUser)) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |

## FP00461_PackWorker_Master.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c40b0100 | this.spdMain.CellClick | FP00461_PackWorker_Master.cs:1199 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) | FLAG | sDivision | siMain.GetValue(e.Row, siMain.GetColumnIndex("DIVISION_ID")).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-0f48232b | this.spdMain.CellClick | FP00461_PackWorker_Master.cs:1200 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) | FLAG | sSite | siMain.GetValue(e.Row, siMain.GetColumnIndex("SITE_ID")).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-54496990 | this.spdMain.CellClick | FP00461_PackWorker_Master.cs:1201 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) | FLAG | sPlant | siMain.GetValue(e.Row, siMain.GetColumnIndex("PLANT_ID")).ToString() | 화면 필드/플래그 변경 |  |  |  |

## FP00461_PackWorker_Master.spdMain_KeyDown

진입점: this.spdMain.KeyDown

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8575d0da | this.spdMain.KeyDown | FP00461_PackWorker_Master.cs:1294 | if (e.KeyCode == Keys.Delete) ▸ if (this.IsEditMode == true) ▸ if (range!=null && range.Length > 0) ▸ for (i< range.Length) ▸ for (c < eachR… | GRID_SET | siMain.ActiveSheet.Cells[r + eachRange.Row, c + eachRange.Column].Text | "" | 그리드 속성/값 설정 |  |  |  |
| AC-6eea4ddf | this.spdMain.KeyDown | FP00461_PackWorker_Master.cs:1304 | if (e.KeyCode == Keys.Delete) ▸ if (this.IsEditMode == true) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (siMain.ActiveShee… | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00461_PackWorker_Master.tbNickName_BeforeOpenSearch

진입점: tbNickName.BeforeOpenSearch

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6da7900d | tbNickName.BeforeOpenSearch | FP00461_PackWorker_Master.cs:1317 |  | CALL_EXT | tbNickName.Filter.Set | (Filter) | ⚠ 의미 확인 필요 |  |  |  |
| AC-6fb92d91 | tbNickName.BeforeOpenSearch | FP00461_PackWorker_Master.cs:1322 |  | DATA_OP | _col_width.Add | ("chk".ToUpper(), 22) | 데이터 객체 조작/조회 |  |  |  |
| AC-2de43e4b | tbNickName.BeforeOpenSearch | FP00461_PackWorker_Master.cs:1323 |  | DATA_OP | _col_width.Add | ("division".ToUpper(), 100) | 데이터 객체 조작/조회 |  |  |  |
| AC-7585b953 | tbNickName.BeforeOpenSearch | FP00461_PackWorker_Master.cs:1324 |  | DATA_OP | _col_width.Add | ("site".ToUpper(), 100) | 데이터 객체 조작/조회 |  |  |  |
| AC-880880a9 | tbNickName.BeforeOpenSearch | FP00461_PackWorker_Master.cs:1325 |  | DATA_OP | _col_width.Add | ("company".ToUpper(), 100) | 데이터 객체 조작/조회 |  |  |  |
| AC-17e71d48 | tbNickName.BeforeOpenSearch | FP00461_PackWorker_Master.cs:1326 |  | DATA_OP | _col_width.Add | ("nick_name".ToUpper(), 400) | 데이터 객체 조작/조회 |  |  |  |
| AC-b5b9459d | tbNickName.BeforeOpenSearch | FP00461_PackWorker_Master.cs:1327 |  | DATA_OP | _col_width.Add | ("_default_column_width_".ToUpper(), 0) | 데이터 객체 조작/조회 |  |  |  |
| AC-8543148f | tbNickName.BeforeOpenSearch | FP00461_PackWorker_Master.cs:1332 |  | UI_PROP | tbNickName.ColumnWidth | _col_width | 속성 ColumnWidth 설정 |  |  |  |
| AC-e1f0a787 | tbNickName.BeforeOpenSearch | FP00461_PackWorker_Master.cs:1333 |  | UI_PROP | tbNickName.ColumnTitle | _col_title | 속성 ColumnTitle 설정 |  |  |  |

## FP00461_PackWorker_Master.tbNickName_OnSearchConditionChanged

진입점: tbNickName.OnSearchConditionChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cbaf802b | tbNickName.OnSearchConditionChanged | FP00461_PackWorker_Master.cs:1340 | if (tbNickName.IsInMode == true) | CALL_EXT | Filter.setColumn | (0, "NICK_NAME_LT", tbNickName.Selected) | ⚠ 의미 확인 필요 |  |  |  |
| AC-5215861d | tbNickName.OnSearchConditionChanged | FP00461_PackWorker_Master.cs:1341 | if (tbNickName.IsInMode == true) | DATA_OP | Filter["NICK_NAME"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-70ee29bb | tbNickName.OnSearchConditionChanged | FP00461_PackWorker_Master.cs:1347 | else of (tbNickName.IsInMode == true) ▸ if (tbNickName.Selected.Count > 0) | DATA_OP | Filter["NICK_NAME"] | tbNickName.Selected[0] | 행/컬럼 값 대입 |  |  |  |
| AC-18249b6e | tbNickName.OnSearchConditionChanged | FP00461_PackWorker_Master.cs:1350 | else of (tbNickName.IsInMode == true) ▸ else of (tbNickName.Selected.Count > 0) | DATA_OP | Filter["NICK_NAME"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-8505b30f | tbNickName.OnSearchConditionChanged | FP00461_PackWorker_Master.cs:1351 | else of (tbNickName.IsInMode == true) | DATA_OP | Filter["NICK_NAME_LT"] | "" | 행/컬럼 값 대입 |  |  |  |

## FP00461_PackWorker_Master.txtMaterial_changed

진입점: txtMaterial.TextChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1c333fae | txtMaterial.TextChanged | FP00461_PackWorker_Master.cs:1396 |  | DATA_OP | Filter["ITEM_ID"] | txtMaterial.Text | 행/컬럼 값 대입 |  |  |  |

## FP00461_PackWorker_Master.UIFindData

진입점: this.btnUpload.Click [if (p.SaveSuccess == true)] / FindButton / SaveButton [if (fps.Name == spdMain.Name) ▸ if (ds.Good())]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-407bdcbb | this.btnUpload.Click [if (p.SaveSuccess == true)] 외 2 | FP00461_PackWorker_Master.cs:803 | if (FilterValidation() == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-bf8f978e | this.btnUpload.Click [if (p.SaveSuccess == true)] 외 2 | FP00461_PackWorker_Master.cs:806 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-c63c48e4 | this.btnUpload.Click [if (p.SaveSuccess == true)] 외 2 | FP00461_PackWorker_Master.cs:812 | try ▸ if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-43a524a6 | this.btnUpload.Click [if (p.SaveSuccess == true)] 외 2 | FP00461_PackWorker_Master.cs:813 | try ▸ if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0356b746 | this.btnUpload.Click [if (p.SaveSuccess == true)] 외 2 | FP00461_PackWorker_Master.cs:816 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-03cc006e | this.btnUpload.Click [if (p.SaveSuccess == true)] 외 2 | FP00461_PackWorker_Master.cs:818 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-fa28a9a5 | this.btnUpload.Click [if (p.SaveSuccess == true)] 외 2 | FP00461_PackWorker_Master.cs:820 | try | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-00a26d91 | this.btnUpload.Click [if (p.SaveSuccess == true)] 외 2 | FP00461_PackWorker_Master.cs:831 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-21afa11f | this.btnUpload.Click [if (p.SaveSuccess == true)] 외 2 | FP00461_PackWorker_Master.cs:833 | try | FLAG | dsMain | await asyncProxy.ExecuteAsync<DataSet>(() => FindData(true) ) | 화면 필드/플래그 변경 |  |  |  |
| AC-7c9ef323 | this.btnUpload.Click [if (p.SaveSuccess == true)] 외 2 | FP00461_PackWorker_Master.cs:833 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => FindData(true) ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-9453e1a0 | this.btnUpload.Click [if (p.SaveSuccess == true)] 외 2 | FP00461_PackWorker_Master.cs:842 | try | CALL_EXT | dsMain.Tables[0].Columns["WORKER_QTY"].ChangeType | (typeof(string)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e51350df | this.btnUpload.Click [if (p.SaveSuccess == true)] 외 2 | FP00461_PackWorker_Master.cs:843 | try | DATA_OP | dsMain.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-b2b7ef67 | this.btnUpload.Click [if (p.SaveSuccess == true)] 외 2 | FP00461_PackWorker_Master.cs:844 | try | GRID_BIND | siMain.Query | (dsMain, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-30a88d71 | this.btnUpload.Click [if (p.SaveSuccess == true)] 외 2 | FP00461_PackWorker_Master.cs:845 | try | CALL_EXT | siMain.InitFormat | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-720cec60 | this.btnUpload.Click [if (p.SaveSuccess == true)] 외 2 | FP00461_PackWorker_Master.cs:846 | try | CALL_EXT | siMain.SetFormat | ("#,##0", siMain.GetColumnIndex("WORKER_QTY")) | ⚠ 의미 확인 필요 |  |  |  |
| AC-5985825c | this.btnUpload.Click [if (p.SaveSuccess == true)] 외 2 | FP00461_PackWorker_Master.cs:847 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-e90606fd | this.btnUpload.Click [if (p.SaveSuccess == true)] 외 2 | FP00461_PackWorker_Master.cs:848 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b27339b3 | this.btnUpload.Click [if (p.SaveSuccess == true)] 외 2 | FP00461_PackWorker_Master.cs:856 | try ▸ else of (Calendar.Days == null \|\| Calendar.Days.Count < 1) | CALL_EXT | siSub.SetAmendHeaderColumn_FP | (Calendar, false, false, true, 2, DateColumnType.COLV, DateColumnType.COLV, DateColumnType… | ⚠ 의미 확인 필요 |  |  |  |
| AC-c458bfb9 | this.btnUpload.Click [if (p.SaveSuccess == true)] 외 2 | FP00461_PackWorker_Master.cs:857 | try ▸ else of (Calendar.Days == null \|\| Calendar.Days.Count < 1) | GRID_INIT | siSub.ColumnHeaderHeight | (0, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-fabe7f98 | this.btnUpload.Click [if (p.SaveSuccess == true)] 외 2 | FP00461_PackWorker_Master.cs:858 | try ▸ else of (Calendar.Days == null \|\| Calendar.Days.Count < 1) | GRID_INIT | siSub.ColumnHeaderHeight | (1, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1d48c8b2 | this.btnUpload.Click [if (p.SaveSuccess == true)] 외 2 | FP00461_PackWorker_Master.cs:860 | try ▸ else of (Calendar.Days == null \|\| Calendar.Days.Count < 1) | GRID_SET | siSub.ActiveSheet.FrozenColumnCount | last_col - added_columns_count + 1 | 그리드 속성/값 설정 |  |  |  |
| AC-10269451 | this.btnUpload.Click [if (p.SaveSuccess == true)] 외 2 | FP00461_PackWorker_Master.cs:864 | try | GRID_BIND | siSub.Query | (dtMaster, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-417bf9ff | this.btnUpload.Click [if (p.SaveSuccess == true)] 외 2 | FP00461_PackWorker_Master.cs:865 | try | CALL_EXT | siSub.SetFormat | ("#,##0", froz) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e8b35f13 | this.btnUpload.Click [if (p.SaveSuccess == true)] 외 2 | FP00461_PackWorker_Master.cs:866 | try | GRID_INIT | siSub.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0eaf6925 | this.btnUpload.Click [if (p.SaveSuccess == true)] 외 2 | FP00461_PackWorker_Master.cs:867 | try | GRID_LOCK | siSub.LockColumn | (0, siSub.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-2fad11b4 | this.btnUpload.Click [if (p.SaveSuccess == true)] 외 2 | FP00461_PackWorker_Master.cs:881 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-717e4096 | this.btnUpload.Click [if (p.SaveSuccess == true)] 외 2 | FP00461_PackWorker_Master.cs:887 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-64f0e14a | this.btnUpload.Click [if (p.SaveSuccess == true)] 외 2 | FP00461_PackWorker_Master.cs:888 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-a84690fe | this.btnUpload.Click [if (p.SaveSuccess == true)] 외 2 | FP00461_PackWorker_Master.cs:889 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## FP00461_PackWorkerAddPopup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a7f29321 | .ctor | FP00461_PackWorkerAddPopup.cs:118 |  | FLAG | this.bCtlEnable | true | 화면 필드/플래그 변경 |  |  |  |
| AC-04617b40 | .ctor | FP00461_PackWorkerAddPopup.cs:119 |  | FLAG | this.bMulltiSelect | true | 화면 필드/플래그 변경 |  |  |  |
| AC-57d6315f | .ctor | FP00461_PackWorkerAddPopup.cs:128 |  | FLAG | this.bCtlEnable | p_controlEnable | 화면 필드/플래그 변경 |  |  |  |
| AC-723e9131 | .ctor | FP00461_PackWorkerAddPopup.cs:129 |  | FLAG | this.bMulltiSelect | p_multiselect | 화면 필드/플래그 변경 |  |  |  |
| AC-900d0c43 | .ctor | FP00461_PackWorkerAddPopup.cs:139 |  | FLAG | this.bCtlEnable | p_controlEnable | 화면 필드/플래그 변경 |  |  |  |
| AC-0f322722 | .ctor | FP00461_PackWorkerAddPopup.cs:140 |  | FLAG | this.bMulltiSelect | p_multiselect | 화면 필드/플래그 변경 |  |  |  |
| AC-cf7cd3d2 | .ctor | FP00461_PackWorkerAddPopup.cs:151 |  | FLAG | this.bCtlEnable | p_multiselect | 화면 필드/플래그 변경 |  |  |  |
| AC-525cdd75 | .ctor | FP00461_PackWorkerAddPopup.cs:152 |  | FLAG | this.bMulltiSelect | p_multiselect | 화면 필드/플래그 변경 |  |  |  |

## FP00461_PackWorkerAddPopup.btnButtonList_UsrButtonList_Click_Detected

진입점: this.btnButtonList.UsrButtonList_Click_Detected

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-750a3562 | this.btnButtonList.UsrButtonList_Click_Detected | FP00461_PackWorkerAddPopup.cs:419 | switch (buttonItem.UserType) case ButtonListType.OK: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-1b91c91f | this.btnButtonList.UsrButtonList_Click_Detected | FP00461_PackWorkerAddPopup.cs:422 | switch (buttonItem.UserType) case ButtonListType.Close: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00461_PackWorkerAddPopup.CboSite_SelectedIndexChanged

진입점: cboSite.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f47733f6 | cboSite.SelectedIndexChanged | FP00461_PackWorkerAddPopup.cs:217 |  | DATA_OP | Filter["SITE_ID"] | CString.GetCheckedListValue(dtSite, cboSite.ControlValues, true) | 행/컬럼 값 대입 |  |  |  |

## FP00461_PackWorkerAddPopup.clbDivision_SelectedIndexChanged

진입점: this.clbDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d7bec45d | this.clbDivision.SelectedIndexChanged | FP00461_PackWorkerAddPopup.cs:394 |  | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-a994b6dc | this.clbDivision.SelectedIndexChanged | FP00461_PackWorkerAddPopup.cs:397 |  | FLAG | dtSite | Data_FP.Common_FP(Data_FP.Type.SITE, false, UserInfoContext.Current.UserId, _sNonAuth, _sS… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 화면 필드/플래그 변경 |  |  |  |
| AC-66f8a473 | this.clbDivision.SelectedIndexChanged | FP00461_PackWorkerAddPopup.cs:397 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.SITE, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth, "", "", … ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-3b863daf | this.clbDivision.SelectedIndexChanged | FP00461_PackWorkerAddPopup.cs:398 |  | LIST_REBIND | clsCtrl.setListBox | (dtSite, cboSite, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-ec04df0d | this.clbDivision.SelectedIndexChanged | FP00461_PackWorkerAddPopup.cs:402 |  | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-2e216486 | this.clbDivision.SelectedIndexChanged | FP00461_PackWorkerAddPopup.cs:405 |  | FLAG | dtPlant | Data_FP.Common_FP(Data_FP.Type.PLANT, false, UserInfoContext.Current.UserId, _sNonAuth, _s… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 화면 필드/플래그 변경 |  |  |  |
| AC-1c1a3608 | this.clbDivision.SelectedIndexChanged | FP00461_PackWorkerAddPopup.cs:405 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.PLANT, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth, "", "",… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-8f0d3b4f | this.clbDivision.SelectedIndexChanged | FP00461_PackWorkerAddPopup.cs:406 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlant, clbPlant, true) | 목록 컨트롤 재구성 |  |  |  |

## FP00461_PackWorkerAddPopup.ClbDivision_SelectedIndexChanged

진입점: clbDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1cedb8f5 | clbDivision.SelectedIndexChanged | FP00461_PackWorkerAddPopup.cs:223 |  | DATA_OP | Filter["DIVISION_ID"] | CString.GetCheckedListValue(dtDivision, clbDivision.ControlValues) | 행/컬럼 값 대입 |  |  |  |

## FP00461_PackWorkerAddPopup.ClbPlant_SelectedIndexChanged

진입점: clbPlant.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-28e5a644 | clbPlant.SelectedIndexChanged | FP00461_PackWorkerAddPopup.cs:212 |  | DATA_OP | Filter["PLANT_ID"] | CString.GetCheckedListValue(dtPlant, clbPlant.ControlValues) | 행/컬럼 값 대입 |  |  |  |

## FP00461_PackWorkerAddPopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5951bfc5 | this.Load | FP00461_PackWorkerAddPopup.cs:259 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-e546e10a | this.Load | FP00461_PackWorkerAddPopup.cs:260 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-3ce4a4c5 | this.Load | FP00461_PackWorkerAddPopup.cs:261 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00461_PackWorkerAddPopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9157d83b | this.Load | FP00461_PackWorkerAddPopup.cs:254 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP00461_PackWorkerAddPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-645cb561 | Dispose | FP00461_PackWorkerAddPopup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00461_PackWorkerAddPopup.FindData

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find:] / this.Load / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-52de0a3f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP00461_PackWorkerAddPopup.cs:340 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-f8f0bf0b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP00461_PackWorkerAddPopup.cs:341 |  | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-4bbb2937 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP00461_PackWorkerAddPopup.cs:344 |  | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-9338e890 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP00461_PackWorkerAddPopup.cs:346 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { DataSet ret = DataService.FP_ExecuteProcedure("PR_UI_FP00461_FINDPLANTOPERATIONLI… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-25a06683 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP00461_PackWorkerAddPopup.cs:348 | lambda | ENDPOINT | DataService.FP_ExecuteProcedure | ("PR_UI_FP00461_FINDPLANTOPERATIONLIST", Filter, "") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-28ee4f58 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP00461_PackWorkerAddPopup.cs:349 | lambda | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |
| AC-239a61db | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP00461_PackWorkerAddPopup.cs:353 |  | GRID_BIND | siMain.Query | (ds, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-fa97d9de | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP00461_PackWorkerAddPopup.cs:358 | if (ds.Good()) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-a8a1ae3c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP00461_PackWorkerAddPopup.cs:361 |  | FLAG | dtFindData | ds.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-b86cb94c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP00461_PackWorkerAddPopup.cs:365 |  | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## FP00461_PackWorkerAddPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f6737555 | this.Load | FP00461_PackWorkerAddPopup.cs:164 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-a7880079 | this.Load | FP00461_PackWorkerAddPopup.cs:166 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00461_PackWorkerAddPopup.GetDivision

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6eb64652 | this.Load | FP00461_PackWorkerAddPopup.cs:230 |  | FLAG | dtDivision | Data_FP.Common_FP(Data_FP.Type.DIVISION, false, CurrentUser, _sNonAuth, _sSaveAuth , null,… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 화면 필드/플래그 변경 |  |  |  |
| AC-e1b148ff | this.Load | FP00461_PackWorkerAddPopup.cs:230 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.DIVISION, false, CurrentUser, _sNonAuth, _sSaveAuth , null, null, null, null… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-72f2f028 | this.Load | FP00461_PackWorkerAddPopup.cs:232 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, clbDivision, false) | 목록 컨트롤 재구성 |  |  |  |

## FP00461_PackWorkerAddPopup.GetPlant

진입점: this.Load / clbDivision.SelectedIndexChanged / cboSite.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5f567d28 | this.Load 외 2 | FP00461_PackWorkerAddPopup.cs:246 |  | FLAG | dtPlant | Data_FP.Common_FP(Data_FP.Type.PLANT, false, CurrentUser, _sNonAuth, _sSaveAuth , null, nu… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 화면 필드/플래그 변경 |  |  |  |
| AC-7a4b9eac | this.Load 외 2 | FP00461_PackWorkerAddPopup.cs:246 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.PLANT, false, CurrentUser, _sNonAuth, _sSaveAuth , null, null, null, null, F… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-eb805da0 | this.Load 외 2 | FP00461_PackWorkerAddPopup.cs:248 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlant, clbPlant, false) | 목록 컨트롤 재구성 |  |  |  |

## FP00461_PackWorkerAddPopup.GetSite

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-07cf7d84 | this.Load | FP00461_PackWorkerAddPopup.cs:237 |  | FLAG | dtSite | Data_FP.Common_FP(Data_FP.Type.SITE, false, CurrentUser, _sNonAuth, _sSaveAuth , null, nul… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 화면 필드/플래그 변경 |  |  |  |
| AC-e69c5cbf | this.Load | FP00461_PackWorkerAddPopup.cs:237 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.SITE, false, CurrentUser, _sNonAuth, _sSaveAuth , null, null, null, null, nu… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-aac34f24 | this.Load | FP00461_PackWorkerAddPopup.cs:239 |  | LIST_REBIND | clsCtrl.setListBox | (dtSite, cboSite, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-ea356176 | this.Load | FP00461_PackWorkerAddPopup.cs:241 | if (cboSite.Items.Count > 1) | VALUE_SET | cboSite.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |

## FP00461_PackWorkerAddPopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-41de62a2 | this.Load | FP00461_PackWorkerAddPopup.cs:181 |  | DATA_OP | Filter["USER_ID"] | CurrentUser = UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-c8e39af6 | this.Load | FP00461_PackWorkerAddPopup.cs:181 |  | FLAG | CurrentUser | UserInfoContext.Current.UserId | 화면 필드/플래그 변경 |  |  |  |
| AC-f3a82547 | this.Load | FP00461_PackWorkerAddPopup.cs:191 |  | VALUE_SET | clbDivision.ControlValues | pDivisionID | 컨트롤 값 설정 |  |  |  |
| AC-910c87af | this.Load | FP00461_PackWorkerAddPopup.cs:192 |  | DATA_OP | Filter["DIVISION_ID"] | CString.GetCheckedListValue(dtDivision, clbDivision.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-985f6184 | this.Load | FP00461_PackWorkerAddPopup.cs:196 |  | VALUE_SET | cboSite.ControlValues | pSiteID | 컨트롤 값 설정 |  |  |  |
| AC-e775d6dd | this.Load | FP00461_PackWorkerAddPopup.cs:197 |  | DATA_OP | Filter["SITE_ID"] | CString.GetCheckedListValue(dtSite, cboSite.ControlValues, true) | 행/컬럼 값 대입 |  |  |  |
| AC-387a2ec0 | this.Load | FP00461_PackWorkerAddPopup.cs:202 |  | VALUE_SET | clbPlant.ControlValues | pPlantID | 컨트롤 값 설정 |  |  |  |
| AC-bd91d1e1 | this.Load | FP00461_PackWorkerAddPopup.cs:203 |  | DATA_OP | Filter["PLANT_ID"] | CString.GetCheckedListValue(dtPlant, clbPlant.ControlValues) | 행/컬럼 값 대입 |  |  |  |

## FP00461_PackWorkerAddPopup.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-34193bfe | this.Load | FP00461_PackWorkerAddPopup.cs:271 |  | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b088bf74 | this.Load | FP00461_PackWorkerAddPopup.cs:272 |  | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP00461_PackWorkerAddPopup.InitSpread_Merge

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ad93d6b7 | (진입점 미연결) | FP00461_PackWorkerAddPopup.cs:293 |  | GRID_INIT | siMain.Freeze | (0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP00461_PackWorkerAddPopup.SetSpreadInit

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8ae9dd17 | this.Load | FP00461_PackWorkerAddPopup.cs:278 |  | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7acc101b | this.Load | FP00461_PackWorkerAddPopup.cs:279 |  | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |
| AC-b5f3ecb4 | this.Load | FP00461_PackWorkerAddPopup.cs:283 |  | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 1) | 그리드 재구성/초기화 |  |  |  |

## FP00461_PackWorkerAddPopup.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-776257a4 | this.spdMain.CellClick | FP00461_PackWorkerAddPopup.cs:433 |  | FLAG | iClick_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |

## FP00461_PackWorkerAddPopup.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d9d65e91 | this.spdMain.CellDoubleClick | FP00461_PackWorkerAddPopup.cs:438 |  | FLAG | iClick_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-6c783753 | this.spdMain.CellDoubleClick | FP00461_PackWorkerAddPopup.cs:440 | if (this.siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7056d0da | this.spdMain.CellDoubleClick | FP00461_PackWorkerAddPopup.cs:442 |  | FLAG | _CompanyId | this.dtFindData.Rows[e.Row][DefColumns.COMPANY_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-fdde76ad | this.spdMain.CellDoubleClick | FP00461_PackWorkerAddPopup.cs:443 |  | FLAG | _DivisionId | this.dtFindData.Rows[e.Row][DefColumns.DIVISION_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-76251212 | this.spdMain.CellDoubleClick | FP00461_PackWorkerAddPopup.cs:444 |  | FLAG | _SiteId | this.dtFindData.Rows[e.Row][DefColumns.SITE_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-eb169871 | this.spdMain.CellDoubleClick | FP00461_PackWorkerAddPopup.cs:445 |  | FLAG | _PlantId | this.dtFindData.Rows[e.Row][DefColumns.PLANT_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-e0adfafb | this.spdMain.CellDoubleClick | FP00461_PackWorkerAddPopup.cs:449 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

