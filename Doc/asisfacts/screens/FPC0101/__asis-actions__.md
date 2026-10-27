# AS-IS 액션 대조표 — FPC0101

> 원천: `Doc/asisfacts/screens/FPC0101/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 150행 · 메서드 17 · 종류 STATE 31 · FLAG 17 · DATA_OP 17 · RETURN 13 · MESSAGE 12 · CALL_EXT 10 · UI_PROP 9 · GRID_INIT 8 · CALL_BASE 7 · UI_MISC 6 · POPUP 6 · GRID_SET 5 · GRID_BIND 2 · GRID_STYLE 2 · FOCUS 1 · EXCEL 1 · GRID_LOCK 1 · STATE_RESET 1 · THROW 1 · ⚠ 의미 확인 필요 17


## FPC0101_AutoExcelPopup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f34d0640 | .ctor | FPC0101_AutoExcelPopup.cs:134 |  | FLAG | Filter | new FilterDataSet() | 화면 필드/플래그 변경 |  |  |  |
| AC-8340dbb5 | .ctor | FPC0101_AutoExcelPopup.cs:135 |  | FLAG | AutoCHK | false | 화면 필드/플래그 변경 |  |  |  |

## FPC0101_AutoExcelPopup.btnClose_Click

진입점: this.btnClose.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3cb8a1f7 | this.btnClose.Click | FPC0101_AutoExcelPopup.cs:826 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FPC0101_AutoExcelPopup.btnDownload_Click

진입점: this.btnDownload.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ecaca8ee | this.btnDownload.Click | FPC0101_AutoExcelPopup.cs:797 |  | FOCUS | spdMain.Focus | () | 포커스 이동 |  |  |  |
| AC-08fc463d | this.btnDownload.Click | FPC0101_AutoExcelPopup.cs:798 |  | EXCEL | ExportExcel | (0) | 엑셀 내보내기/올리기 |  |  |  |

## FPC0101_AutoExcelPopup.btnSave_Click

진입점: this.btnSave.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a146ba42 | this.btnSave.Click | FPC0101_AutoExcelPopup.cs:820 | if (IsExcelChanged) ▸ if (!error && !this.hasError) | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |

## FPC0101_AutoExcelPopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-12054906 | this.Load | FPC0101_AutoExcelPopup.cs:171 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, ColumnHeaderCount, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-aaf27010 | this.Load | FPC0101_AutoExcelPopup.cs:172 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-9ecff14c | this.Load | FPC0101_AutoExcelPopup.cs:173 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FPC0101_AutoExcelPopup.DefaultLineCheck

진입점: this.btnUpload.Click [if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ for (i < iRCnt + 1) ▸ if (DoDefaultLineCheck)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f46cee74 | this.btnUpload.Click [if (string.IsNullOrWhiteSpace(FileName… | FPC0101_AutoExcelPopup.cs:765 |  | CALL_EXT | ExcelService.CommonDefaultLineCheck | (row, KeyColumnList, ColumnType, ColumnLength, Filter, AcceptOnlyPositve) | ⚠ 의미 확인 필요 |  |  |  |
| AC-51f2fcba | this.btnUpload.Click [if (string.IsNullOrWhiteSpace(FileName… | FPC0101_AutoExcelPopup.cs:765 |  | RETURN | return ExcelService.CommonDefaultLineCheck(row, KeyColumnList, ColumnType, Colum… |  | 처리 중단/반환 |  |  |  |

## FPC0101_AutoExcelPopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-af51ad9d | this.Load | FPC0101_AutoExcelPopup.cs:166 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FPC0101_AutoExcelPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-37590c14 | Dispose | FPC0101_AutoExcelPopup.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FPC0101_AutoExcelPopup.FindButton

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f2e1f886 | FindButton | FPC0101_AutoExcelPopup.cs:205 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-4c9e37fb | FindButton | FPC0101_AutoExcelPopup.cs:206 |  | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-1dfaa58f | FindButton | FPC0101_AutoExcelPopup.cs:208 |  | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## FPC0101_AutoExcelPopup.FindData

진입점: this.Load / this.btnFind.Click / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e4be466c | this.Load 외 2 | FPC0101_AutoExcelPopup.cs:241 | if (DoSearchData == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b15712a8 | this.Load 외 2 | FPC0101_AutoExcelPopup.cs:242 |  | FLAG | ctx | FoxUserInfoContext.GetUserInfoContext() | 화면 필드/플래그 변경 |  |  |  |
| AC-0d54eaa0 | this.Load 외 2 | FPC0101_AutoExcelPopup.cs:242 |  | CALL_EXT | FoxUserInfoContext.GetUserInfoContext | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-e4d36fb9 | this.Load 외 2 | FPC0101_AutoExcelPopup.cs:246 | if (DoSearchData != null) | FLAG | this.hasError | false | 화면 필드/플래그 변경 |  |  |  |
| AC-c494ebb8 | this.Load 외 2 | FPC0101_AutoExcelPopup.cs:247 | if (DoSearchData != null) | FLAG | this.IsExcelChanged | false | 화면 필드/플래그 변경 |  |  |  |
| AC-247a9f5b | this.Load 외 2 | FPC0101_AutoExcelPopup.cs:249 | if (DoSearchData != null) | STATE | this.spdMain.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-ab2b4bcd | this.Load 외 2 | FPC0101_AutoExcelPopup.cs:250 | if (DoSearchData != null) | STATE | this.btnClose.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-0daa2412 | this.Load 외 2 | FPC0101_AutoExcelPopup.cs:251 | if (DoSearchData != null) | STATE | this.btnFind.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-4a92a3ff | this.Load 외 2 | FPC0101_AutoExcelPopup.cs:252 | if (DoSearchData != null) | STATE | this.btnDownload.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-1f3f4c09 | this.Load 외 2 | FPC0101_AutoExcelPopup.cs:253 | if (DoSearchData != null) | STATE | this.btnUpload.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-d377689f | this.Load 외 2 | FPC0101_AutoExcelPopup.cs:254 | if (DoSearchData != null) | STATE | this.btnSave.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-625d0999 | this.Load 외 2 | FPC0101_AutoExcelPopup.cs:261 | if (DoSearchData != null) ▸ try ▸ if (UserInfoContext.Current == null) | CALL_EXT | FoxUserInfoContext.SetCallContext | (ctx) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a45eacef | this.Load 외 2 | FPC0101_AutoExcelPopup.cs:264 | if (DoSearchData != null) ▸ try | CALL_BASE | DoSearchData | (Filter.Data) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d66dac90 | this.Load 외 2 | FPC0101_AutoExcelPopup.cs:265 | if (DoSearchData != null) ▸ try | CALL_BASE | this.Invoke | (new Action(delegate () { //this.Enabled = true; if (init) { if (set.Good() && !set.Tables… | ⚠ 의미 확인 필요 |  |  |  |
| AC-ffd90df6 | this.Load 외 2 | FPC0101_AutoExcelPopup.cs:271 | if (DoSearchData != null) ▸ try ▸ lambda ▸ if (init) | DATA_OP | set.Tables[0].Columns.Contains | ("MESSAGE") | 데이터 객체 조작/조회 |  |  |  |
| AC-a3b3268a | this.Load 외 2 | FPC0101_AutoExcelPopup.cs:272 | if (DoSearchData != null) ▸ try ▸ lambda ▸ if (init) ▸ if (set.Good() && !set.Tables[0].Columns.Contains("MESSAGE")) | DATA_OP | set.Tables[0].Columns.Add | ("MESSAGE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-59085937 | this.Load 외 2 | FPC0101_AutoExcelPopup.cs:273 | if (DoSearchData != null) ▸ try ▸ lambda ▸ if (init) | FLAG | DictColumn | siMain.SetSheetHeaderFromDataSource(siMain, set, ColumnWidth, ColumnTitle, KeyColumns, Aut… | 화면 필드/플래그 변경 |  |  |  |
| AC-91afaa98 | this.Load 외 2 | FPC0101_AutoExcelPopup.cs:273 | if (DoSearchData != null) ▸ try ▸ lambda ▸ if (init) | GRID_INIT | siMain.SetSheetHeaderFromDataSource | (siMain, set, ColumnWidth, ColumnTitle, KeyColumns, AutoCHK, ColumnBgColor,2,true,60) | 그리드 재구성/초기화 |  |  |  |
| AC-0437de51 | this.Load 외 2 | FPC0101_AutoExcelPopup.cs:279 | if (DoSearchData != null) ▸ try ▸ lambda ▸ if (init) ▸ if (AutoCHK) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex("CHK")].CellType | chk | 그리드 속성/값 설정 |  |  |  |
| AC-2a631c77 | this.Load 외 2 | FPC0101_AutoExcelPopup.cs:280 | if (DoSearchData != null) ▸ try ▸ lambda ▸ if (init) ▸ if (AutoCHK) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex("CHK")].Value | false | 그리드 속성/값 설정 |  |  |  |
| AC-59c1971a | this.Load 외 2 | FPC0101_AutoExcelPopup.cs:281 | if (DoSearchData != null) ▸ try ▸ lambda ▸ if (init) ▸ if (AutoCHK) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex("CHK")].Border | bevelbrdr | 그리드 속성/값 설정 |  |  |  |
| AC-82be96ee | this.Load 외 2 | FPC0101_AutoExcelPopup.cs:285 | if (DoSearchData != null) ▸ try ▸ lambda | GRID_BIND | siMain.Query | (set, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-87edac2d | this.Load 외 2 | FPC0101_AutoExcelPopup.cs:292 | if (DoSearchData != null) ▸ try ▸ lambda ▸ foreach (KeyValuePair<string, string> col in DictColumn) ▸ if (bg_color.Good() && bg_color!= Colo… | GRID_STYLE | siMain.SetBGColor | (0, siMain.GetColumnIndex(col.Key) , set.Tables[0].Rows.Count - 1, siMain.GetColumnIndex(c… | 그리드 표시 설정 |  |  |  |
| AC-e0239c71 | this.Load 외 2 | FPC0101_AutoExcelPopup.cs:297 | if (DoSearchData != null) ▸ try ▸ lambda ▸ foreach (KeyValuePair<string, string> col in DictColumn) ▸ if (fore_color.Good() && fore_color !=… | GRID_STYLE | siMain.SetFGColor | (0, siMain.GetColumnIndex(col.Key) , set.Tables[0].Rows.Count - 1, siMain.GetColumnIndex(c… | 그리드 표시 설정 |  |  |  |
| AC-c37d2f43 | this.Load 외 2 | FPC0101_AutoExcelPopup.cs:300 | if (DoSearchData != null) ▸ try ▸ lambda | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-620c1546 | this.Load 외 2 | FPC0101_AutoExcelPopup.cs:309 | if (DoSearchData != null) ▸ finally | CALL_BASE | this.Invoke | (new Action(delegate () { //this.Enabled = false; this.spdMain.Enabled = true; this.btnClo… | ⚠ 의미 확인 필요 |  |  |  |
| AC-de7cd992 | this.Load 외 2 | FPC0101_AutoExcelPopup.cs:312 | if (DoSearchData != null) ▸ finally ▸ lambda | STATE | this.spdMain.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-4ed4d873 | this.Load 외 2 | FPC0101_AutoExcelPopup.cs:313 | if (DoSearchData != null) ▸ finally ▸ lambda | STATE | this.btnClose.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-60fa1dd6 | this.Load 외 2 | FPC0101_AutoExcelPopup.cs:314 | if (DoSearchData != null) ▸ finally ▸ lambda | STATE | this.btnFind.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-bb3b31ec | this.Load 외 2 | FPC0101_AutoExcelPopup.cs:315 | if (DoSearchData != null) ▸ finally ▸ lambda | STATE | this.btnDownload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-41a9fb3a | this.Load 외 2 | FPC0101_AutoExcelPopup.cs:316 | if (DoSearchData != null) ▸ finally ▸ lambda | STATE | this.btnUpload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-68130fea | this.Load 외 2 | FPC0101_AutoExcelPopup.cs:317 | if (DoSearchData != null) ▸ finally ▸ lambda | STATE | this.btnSave.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## FPC0101_AutoExcelPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-33879924 | this.Load | FPC0101_AutoExcelPopup.cs:143 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-b0ced977 | this.Load | FPC0101_AutoExcelPopup.cs:145 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FPC0101_AutoExcelPopup.GetExcelFileName

진입점: this.btnUpload.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-aa6a36ed | this.btnUpload.Click | FPC0101_AutoExcelPopup.cs:533 | try | FLAG | FileName | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-5f2b1764 | this.btnUpload.Click | FPC0101_AutoExcelPopup.cs:534 | try | POPUP | new OpenFileDialog | () | 팝업/폼 생성 |  |  |  |
| AC-1fb133d2 | this.btnUpload.Click | FPC0101_AutoExcelPopup.cs:535 | try | UI_PROP | openFile.Filter | "Excel files (*.xls;*.xlsx)\|*.xls;*.xlsx\|xls files (*.xls)\|*.xls\|xlsx files (*.xlsx)\|… | 속성 Filter 설정 |  |  |  |
| AC-3fee41b1 | this.btnUpload.Click | FPC0101_AutoExcelPopup.cs:536 | try | UI_PROP | openFile.FilterIndex | 1 | 속성 FilterIndex 설정 |  |  |  |
| AC-1edbc69a | this.btnUpload.Click | FPC0101_AutoExcelPopup.cs:537 | try | UI_PROP | openFile.RestoreDirectory | true | 속성 RestoreDirectory 설정 |  |  |  |
| AC-7926f822 | this.btnUpload.Click | FPC0101_AutoExcelPopup.cs:538 | try | UI_PROP | openFile.InitialDirectory | @"C:\My Documents\" | 속성 InitialDirectory 설정 |  |  |  |
| AC-64e05959 | this.btnUpload.Click | FPC0101_AutoExcelPopup.cs:539 | try | UI_PROP | openFile.FileName | FileName | 속성 FileName 설정 |  |  |  |
| AC-e7960810 | this.btnUpload.Click | FPC0101_AutoExcelPopup.cs:540 | try | POPUP | openFile.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-c125f2a9 | this.btnUpload.Click | FPC0101_AutoExcelPopup.cs:542 | try | FLAG | this.FileName | openFile.FileName | 화면 필드/플래그 변경 |  |  |  |
| AC-f3527bb5 | this.btnUpload.Click | FPC0101_AutoExcelPopup.cs:543 | try | RETURN | return this.FileName; |  | 처리 중단/반환 |  |  |  |
| AC-1adc2311 | this.btnUpload.Click | FPC0101_AutoExcelPopup.cs:547 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message, ex.Source, MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-845e178c | this.btnUpload.Click | FPC0101_AutoExcelPopup.cs:548 | catch ((Exception ex)) | RETURN | return string.Empty; |  | 처리 중단/반환 |  |  |  |

## FPC0101_AutoExcelPopup.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-46ff2da4 | this.Load | FPC0101_AutoExcelPopup.cs:183 |  | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a91a701b | this.Load | FPC0101_AutoExcelPopup.cs:184 |  | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FPC0101_AutoExcelPopup.InitSpread_Merge

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a395a9b3 | (진입점 미연결) | FPC0101_AutoExcelPopup.cs:196 |  | GRID_INIT | siMain.Freeze | (0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FPC0101_AutoExcelPopup.OpenAndLoadExcelData

진입점: this.btnUpload.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4a1d0bdb | this.btnUpload.Click | FPC0101_AutoExcelPopup.cs:558 |  | CALL_EXT | System.IO.File.Exists | (FileName) | ⚠ 의미 확인 필요 |  |  |  |
| AC-6d907d4a | this.btnUpload.Click | FPC0101_AutoExcelPopup.cs:560 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) | FLAG | hasError | false | 화면 필드/플래그 변경 |  |  |  |
| AC-3ae160d7 | this.btnUpload.Click | FPC0101_AutoExcelPopup.cs:561 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) | FLAG | IsExcelChanged | true | 화면 필드/플래그 변경 |  |  |  |
| AC-2f188e14 | this.btnUpload.Click | FPC0101_AutoExcelPopup.cs:562 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) | STATE_RESET | KeyColumnList.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-433c8af5 | this.btnUpload.Click | FPC0101_AutoExcelPopup.cs:567 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ if (KeyColumns != null) ▸ foreach (string keycolumn i… | DATA_OP | KeyColumnList.Add | (keycolumn) | 데이터 객체 조작/조회 |  |  |  |
| AC-9fc5b08d | this.btnUpload.Click | FPC0101_AutoExcelPopup.cs:572 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ if (DictColumn == null \|\| DictColumn.Count < 1) | MESSAGE | MessageBox.Show | ("There's no data to display", "Excel Import", MessageBoxButtons.OK, MessageBoxIcon.Inform… | 메시지 표시 |  |  |  |
| AC-aa3eadb0 | this.btnUpload.Click | FPC0101_AutoExcelPopup.cs:573 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ if (DictColumn == null \|\| DictColumn.Count < 1) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-98834410 | this.btnUpload.Click | FPC0101_AutoExcelPopup.cs:584 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-31ba5d82 | this.btnUpload.Click | FPC0101_AutoExcelPopup.cs:588 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-37088eeb | this.btnUpload.Click | FPC0101_AutoExcelPopup.cs:591 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try | STATE | xlApp.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-d6c215f5 | this.btnUpload.Click | FPC0101_AutoExcelPopup.cs:592 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try | UI_PROP | xlApp.DisplayAlerts | false | 속성 DisplayAlerts 설정 |  |  |  |
| AC-d3ee02ae | this.btnUpload.Click | FPC0101_AutoExcelPopup.cs:594 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try | CALL_EXT | xlApp.Workbooks.Open | (FileName, Missing.Value, Missing.Value, Missing.Value, Missing.Value, Missing.Value , Mis… | ⚠ 의미 확인 필요 |  |  |  |
| AC-b4327726 | this.btnUpload.Click | FPC0101_AutoExcelPopup.cs:613 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try | CALL_EXT | xlRange.get_Value | (Type.Missing) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f5e963fa | this.btnUpload.Click | FPC0101_AutoExcelPopup.cs:620 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (iRCnt < 2 \|\| iCCnt < DictColumn.Count) | MESSAGE | MessageBox.Show | ("There's no data to display", "Excel Import", MessageBoxButtons.OK, MessageBoxIcon.Inform… | 메시지 표시 |  |  |  |
| AC-c9b299c6 | this.btnUpload.Click | FPC0101_AutoExcelPopup.cs:621 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (iRCnt < 2 \|\| iCCnt < DictColumn.Count) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-c63b9513 | this.btnUpload.Click | FPC0101_AutoExcelPopup.cs:644 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (iFR == 0 \|\| iFC == 0) | MESSAGE | MessageBox.Show | ("Please check your excel file where should use same column and order as orignal file", "E… | 메시지 표시 |  |  |  |
| AC-2cc44974 | this.btnUpload.Click | FPC0101_AutoExcelPopup.cs:645 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (iFR == 0 \|\| iFC == 0) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-1ff504cd | this.btnUpload.Click | FPC0101_AutoExcelPopup.cs:655 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (main != null) | DATA_OP | main.Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-4c5e8f64 | this.btnUpload.Click | FPC0101_AutoExcelPopup.cs:664 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try | DATA_OP | excelData.Columns.Contains | ("MESSAGE") | 데이터 객체 조작/조회 |  |  |  |
| AC-0b9e8412 | this.btnUpload.Click | FPC0101_AutoExcelPopup.cs:665 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (!excelData.Columns.Contains("MESSAGE")) | DATA_OP | excelData.Columns.Add | (new DataColumn("MESSAGE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-1875ccfb | this.btnUpload.Click | FPC0101_AutoExcelPopup.cs:676 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ for (i < iRCnt + 1) | DATA_OP | excelData.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-e8a5d28e | this.btnUpload.Click | FPC0101_AutoExcelPopup.cs:684 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ for (i < iRCnt + 1) ▸ for (j < iFC + DictColumn… | DATA_OP | row[j - iFC] | each_cell_value | 행/컬럼 값 대입 |  |  |  |
| AC-bf4018dd | this.btnUpload.Click | FPC0101_AutoExcelPopup.cs:693 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ for (i < iRCnt + 1) ▸ if (this.DoLineCheck != n… | CALL_BASE | DoLineCheck | (row) | ⚠ 의미 확인 필요 |  |  |  |
| AC-1290fca4 | this.btnUpload.Click | FPC0101_AutoExcelPopup.cs:697 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ for (i < iRCnt + 1) | DATA_OP | excelData.Rows.Add | (row) | 데이터 객체 조작/조회 |  |  |  |
| AC-42968ef8 | this.btnUpload.Click | FPC0101_AutoExcelPopup.cs:702 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try | GRID_BIND | siMain.Query | (excelDataSet, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-57869eee | this.btnUpload.Click | FPC0101_AutoExcelPopup.cs:716 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (excelDataSet != null && excelDataSet.Tables… | CALL_EXT | siMain.SetRowColor | (k, System.Drawing.Color.PaleVioletRed) | ⚠ 의미 확인 필요 |  |  |  |
| AC-754cd108 | this.btnUpload.Click | FPC0101_AutoExcelPopup.cs:717 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (excelDataSet != null && excelDataSet.Tables… | FLAG | hasError | true | 화면 필드/플래그 변경 |  |  |  |
| AC-2097480a | this.btnUpload.Click | FPC0101_AutoExcelPopup.cs:735 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (iSaveCnt == 0) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-d3bff8a0 | this.btnUpload.Click | FPC0101_AutoExcelPopup.cs:741 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-31fa4d89 | this.btnUpload.Click | FPC0101_AutoExcelPopup.cs:745 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message, ex.Source, MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-a90b836e | this.btnUpload.Click | FPC0101_AutoExcelPopup.cs:750 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ finally | CALL_EXT | xlApp.Quit | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-9aaac1b8 | this.btnUpload.Click | FPC0101_AutoExcelPopup.cs:751 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-ddd20a11 | this.btnUpload.Click | FPC0101_AutoExcelPopup.cs:756 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## FPC0101_AutoExcelPopup.SaveToDB

진입점: this.btnSave.Click [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fdaa9f53 | this.btnSave.Click [try] | FPC0101_AutoExcelPopup.cs:329 | if (IsExcelChanged == false) | MESSAGE | MessageBox.Show | ("Not Modified") | 메시지 표시 |  |  |  |
| AC-09b24f0e | this.btnSave.Click [try] | FPC0101_AutoExcelPopup.cs:330 | if (IsExcelChanged == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-847ecf17 | this.btnSave.Click [try] | FPC0101_AutoExcelPopup.cs:334 | if (hasError == true) | MESSAGE | MessageBox.Show | ("You have errors to fix") | 메시지 표시 |  |  |  |
| AC-61ee6846 | this.btnSave.Click [try] | FPC0101_AutoExcelPopup.cs:335 | if (hasError == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9746fed7 | this.btnSave.Click [try] | FPC0101_AutoExcelPopup.cs:339 |  | FLAG | ctx | FoxUserInfoContext.GetUserInfoContext() | 화면 필드/플래그 변경 |  |  |  |
| AC-d87b7fdb | this.btnSave.Click [try] | FPC0101_AutoExcelPopup.cs:339 |  | CALL_EXT | FoxUserInfoContext.GetUserInfoContext | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-152368ec | this.btnSave.Click [try] | FPC0101_AutoExcelPopup.cs:344 | if (DoSaveData != null) | STATE | this.spdMain.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-a6925282 | this.btnSave.Click [try] | FPC0101_AutoExcelPopup.cs:345 | if (DoSaveData != null) | STATE | this.btnClose.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-329a7f05 | this.btnSave.Click [try] | FPC0101_AutoExcelPopup.cs:346 | if (DoSaveData != null) | STATE | this.btnFind.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-f5ac1670 | this.btnSave.Click [try] | FPC0101_AutoExcelPopup.cs:347 | if (DoSaveData != null) | STATE | this.btnDownload.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-086a7973 | this.btnSave.Click [try] | FPC0101_AutoExcelPopup.cs:348 | if (DoSaveData != null) | STATE | this.btnUpload.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-88ebe38a | this.btnSave.Click [try] | FPC0101_AutoExcelPopup.cs:349 | if (DoSaveData != null) | STATE | this.btnSave.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-465fae9f | this.btnSave.Click [try] | FPC0101_AutoExcelPopup.cs:357 | if (DoSaveData != null) ▸ try ▸ if (main.Good()) | DATA_OP | main.Tables[0].Columns.Contains | ("USER_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-be38c8e7 | this.btnSave.Click [try] | FPC0101_AutoExcelPopup.cs:360 | if (DoSaveData != null) ▸ try ▸ if (main.Good()) ▸ if (!main.Tables[0].Columns.Contains("USER_ID")) | DATA_OP | main.Tables[0].Columns.Add | (itemColumn) | 데이터 객체 조작/조회 |  |  |  |
| AC-2d0cd15f | this.btnSave.Click [try] | FPC0101_AutoExcelPopup.cs:362 | if (DoSaveData != null) ▸ try ▸ if (main.Good()) | DATA_OP | main.Tables[0].Columns.Contains | ("JOB_ORDER") | 데이터 객체 조작/조회 |  |  |  |
| AC-d0e77d22 | this.btnSave.Click [try] | FPC0101_AutoExcelPopup.cs:365 | if (DoSaveData != null) ▸ try ▸ if (main.Good()) ▸ if (!main.Tables[0].Columns.Contains("JOB_ORDER")) | DATA_OP | main.Tables[0].Columns.Add | (itemColumn) | 데이터 객체 조작/조회 |  |  |  |
| AC-769cd805 | this.btnSave.Click [try] | FPC0101_AutoExcelPopup.cs:370 | if (DoSaveData != null) ▸ try ▸ if (main.Good()) ▸ for (i < main.Tables[0].Rows.Count) | GRID_SET | main.Tables[0].Rows[i]["USER_ID"] | UserInfoContext.Current.UserId | 그리드 속성/값 설정 |  |  |  |
| AC-c25f0bd9 | this.btnSave.Click [try] | FPC0101_AutoExcelPopup.cs:371 | if (DoSaveData != null) ▸ try ▸ if (main.Good()) ▸ for (i < main.Tables[0].Rows.Count) | GRID_SET | main.Tables[0].Rows[i]["JOB_ORDER"] | i | 그리드 속성/값 설정 |  |  |  |
| AC-cc10ddc5 | this.btnSave.Click [try] | FPC0101_AutoExcelPopup.cs:378 | if (DoSaveData != null) ▸ try ▸ if (expect_count < 1) | MESSAGE | MessageBox.Show | ("There is no data to save") | 메시지 표시 |  |  |  |
| AC-4a60ce47 | this.btnSave.Click [try] | FPC0101_AutoExcelPopup.cs:379 | if (DoSaveData != null) ▸ try ▸ if (expect_count < 1) | STATE | this.spdMain.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-7acac976 | this.btnSave.Click [try] | FPC0101_AutoExcelPopup.cs:380 | if (DoSaveData != null) ▸ try ▸ if (expect_count < 1) | STATE | this.btnClose.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-65b70fbc | this.btnSave.Click [try] | FPC0101_AutoExcelPopup.cs:381 | if (DoSaveData != null) ▸ try ▸ if (expect_count < 1) | STATE | this.btnFind.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-dbd7d2a9 | this.btnSave.Click [try] | FPC0101_AutoExcelPopup.cs:382 | if (DoSaveData != null) ▸ try ▸ if (expect_count < 1) | STATE | this.btnDownload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-f5d22566 | this.btnSave.Click [try] | FPC0101_AutoExcelPopup.cs:383 | if (DoSaveData != null) ▸ try ▸ if (expect_count < 1) | STATE | this.btnUpload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-044f48c9 | this.btnSave.Click [try] | FPC0101_AutoExcelPopup.cs:384 | if (DoSaveData != null) ▸ try ▸ if (expect_count < 1) | STATE | this.btnSave.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-5b089c27 | this.btnSave.Click [try] | FPC0101_AutoExcelPopup.cs:385 | if (DoSaveData != null) ▸ try ▸ if (expect_count < 1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-671ec3c9 | this.btnSave.Click [try] | FPC0101_AutoExcelPopup.cs:391 | if (DoSaveData != null) ▸ try ▸ if (DoValidationData != null) | CALL_BASE | DoValidationData | (main) | ⚠ 의미 확인 필요 |  |  |  |
| AC-48c7205e | this.btnSave.Click [try] | FPC0101_AutoExcelPopup.cs:426 | if (DoSaveData != null) ▸ try ▸ if (valid) ▸ if (validation.Good()) | CALL_BASE | DoSaveData | (validation) | ⚠ 의미 확인 필요 |  |  |  |
| AC-00419f2b | this.btnSave.Click [try] | FPC0101_AutoExcelPopup.cs:430 | if (DoSaveData != null) ▸ try ▸ if (valid) ▸ else of (validation.Good()) | CALL_BASE | DoSaveData | (main) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a4651d24 | this.btnSave.Click [try] | FPC0101_AutoExcelPopup.cs:443 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ try | DATA_OP | result.Tables[0].Columns.Contains | ("RESULT") | 데이터 객체 조작/조회 |  |  |  |
| AC-ccd623d4 | this.btnSave.Click [try] | FPC0101_AutoExcelPopup.cs:445 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ try | DATA_OP | result.Tables[0].Columns.Contains | ("COUNT") | 데이터 객체 조작/조회 |  |  |  |
| AC-cf572fa1 | this.btnSave.Click [try] | FPC0101_AutoExcelPopup.cs:447 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ try | DATA_OP | result.Tables[0].Columns.Contains | ("EXCEPTION") | 데이터 객체 조작/조회 |  |  |  |
| AC-bc02ebcc | this.btnSave.Click [try] | FPC0101_AutoExcelPopup.cs:451 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ try ▸ if (!string.IsNullOrWhiteSpace(exception)) | MESSAGE | MessageBox.Show | ("Validation error :" + exception) | 메시지 표시 |  |  |  |
| AC-19d2a74f | this.btnSave.Click [try] | FPC0101_AutoExcelPopup.cs:455 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ try ▸ if (result_string != "SUCCESS") | MESSAGE | MessageBox.Show | (string.Format("Save Error")) | 메시지 표시 |  |  |  |
| AC-7c263589 | this.btnSave.Click [try] | FPC0101_AutoExcelPopup.cs:456 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ try ▸ if (result_string != "SUCCESS") | FLAG | this.hasError | true | 화면 필드/플래그 변경 |  |  |  |
| AC-b1983138 | this.btnSave.Click [try] | FPC0101_AutoExcelPopup.cs:459 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ try ▸ else of (result_string != "SUCCESS") | MESSAGE | MessageBox.Show | (string.Format("{0} data Saved", expect_count)) | 메시지 표시 |  |  |  |
| AC-46490e22 | this.btnSave.Click [try] | FPC0101_AutoExcelPopup.cs:460 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ try ▸ else of (result_string != "SUCCESS") | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |
| AC-5ea14144 | this.btnSave.Click [try] | FPC0101_AutoExcelPopup.cs:461 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ try ▸ else of (result_string != "SUCCESS") | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-0aa8a801 | this.btnSave.Click [try] | FPC0101_AutoExcelPopup.cs:466 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ catch ((Exception e)) | MESSAGE | MessageBox.Show | ("Unknown validation error :" + e.Message) | 메시지 표시 |  |  |  |
| AC-3cfd0ce8 | this.btnSave.Click [try] | FPC0101_AutoExcelPopup.cs:499 | if (DoSaveData != null) ▸ try ▸ else of (result.Good()) ▸ foreach (DataRow valrow in valSrc.Rows) ▸ if (valrow["_VALID"] as string == "N") ▸… | DATA_OP | xlsrow["MESSAGE"] | valrow["_MSG"] | 행/컬럼 값 대입 |  |  |  |
| AC-e7a3f218 | this.btnSave.Click [try] | FPC0101_AutoExcelPopup.cs:501 | if (DoSaveData != null) ▸ try ▸ else of (result.Good()) ▸ foreach (DataRow valrow in valSrc.Rows) ▸ if (valrow["_VALID"] as string == "N") ▸… | CALL_EXT | siMain.SetRowColor | (index, System.Drawing.Color.PaleVioletRed) | ⚠ 의미 확인 필요 |  |  |  |
| AC-7bff01b7 | this.btnSave.Click [try] | FPC0101_AutoExcelPopup.cs:502 | if (DoSaveData != null) ▸ try ▸ else of (result.Good()) ▸ foreach (DataRow valrow in valSrc.Rows) ▸ if (valrow["_VALID"] as string == "N") ▸… | FLAG | this.hasError | true | 화면 필드/플래그 변경 |  |  |  |
| AC-5dfd2189 | this.btnSave.Click [try] | FPC0101_AutoExcelPopup.cs:512 | if (DoSaveData != null) ▸ catch ((Exception e)) | FLAG | this.hasError | true | 화면 필드/플래그 변경 |  |  |  |
| AC-c584bd4b | this.btnSave.Click [try] | FPC0101_AutoExcelPopup.cs:513 | if (DoSaveData != null) ▸ catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-f13f1699 | this.btnSave.Click [try] | FPC0101_AutoExcelPopup.cs:517 | if (DoSaveData != null) ▸ finally | STATE | this.spdMain.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-2b76afb8 | this.btnSave.Click [try] | FPC0101_AutoExcelPopup.cs:518 | if (DoSaveData != null) ▸ finally | STATE | this.btnClose.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-8b4f45db | this.btnSave.Click [try] | FPC0101_AutoExcelPopup.cs:519 | if (DoSaveData != null) ▸ finally | STATE | this.btnFind.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-18d55f5c | this.btnSave.Click [try] | FPC0101_AutoExcelPopup.cs:520 | if (DoSaveData != null) ▸ finally | STATE | this.btnDownload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-86a42cf6 | this.btnSave.Click [try] | FPC0101_AutoExcelPopup.cs:521 | if (DoSaveData != null) ▸ finally | STATE | this.btnUpload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-f08b30e7 | this.btnSave.Click [try] | FPC0101_AutoExcelPopup.cs:522 | if (DoSaveData != null) ▸ finally | STATE | this.btnSave.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## FPC0101_AutoExcelPopup.SetSpreadInit

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-63e19be1 | this.Load | FPC0101_AutoExcelPopup.cs:190 |  | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-24c35e29 | this.Load | FPC0101_AutoExcelPopup.cs:191 |  | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |

