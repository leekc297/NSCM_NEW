# AS-IS 액션 대조표 — FP02600

> 원천: `Doc/asisfacts/screens/FP02600/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 576행 · 메서드 73 · 종류 DATA_OP 159 · FLAG 64 · RETURN 58 · UI_PROP 41 · CALL_EXT 35 · GRID_SET 34 · STATE 32 · UI_MISC 22 · GRID_INIT 21 · MESSAGE 19 · ENDPOINT 13 · COMBO_DATA 13 · GRID_STYLE 12 · CALL_BASE 11 · LIST_REBIND 11 · POPUP 10 · THROW 10 · GRID_LOCK 5 · VALUE_SET 3 · FOCUS 1 · EXCEL 1 · GRID_BIND 1 · ⚠ 의미 확인 필요 46


## FP02600_ExcelPopup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-83b7b4ec | .ctor | FP02600_ExcelPopup.cs:150 |  | FLAG | Filter | new FilterDataSet() | 화면 필드/플래그 변경 |  |  |  |
| AC-13a40074 | .ctor | FP02600_ExcelPopup.cs:151 |  | FLAG | AutoCHK | false | 화면 필드/플래그 변경 |  |  |  |
| AC-8f5164da | .ctor | FP02600_ExcelPopup.cs:152 |  | FLAG | HeaderLineCount | 2 | 화면 필드/플래그 변경 |  |  |  |
| AC-d2cd11af | .ctor | FP02600_ExcelPopup.cs:153 |  | FLAG | IgnoreColumnsNotInTitle | true | 화면 필드/플래그 변경 |  |  |  |
| AC-e31a1cb3 | .ctor | FP02600_ExcelPopup.cs:154 |  | FLAG | AutoCHK | false | 화면 필드/플래그 변경 |  |  |  |

## FP02600_ExcelPopup.btnClose_Click

진입점: this.btnClose.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5c97d7f1 | this.btnClose.Click | FP02600_ExcelPopup.cs:713 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP02600_ExcelPopup.btnDownload_Click

진입점: this.btnDownload.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-eabbf3b5 | this.btnDownload.Click | FP02600_ExcelPopup.cs:697 |  | FOCUS | spdMain.Focus | () | 포커스 이동 |  |  |  |
| AC-3b5bc87c | this.btnDownload.Click | FP02600_ExcelPopup.cs:698 |  | EXCEL | ExportExcel | (0, true) | 엑셀 내보내기/올리기 |  |  |  |

## FP02600_ExcelPopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-21ba3220 | this.Load | FP02600_ExcelPopup.cs:192 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 2, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-019e2840 | this.Load | FP02600_ExcelPopup.cs:193 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-d8d3f3de | this.Load | FP02600_ExcelPopup.cs:194 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP02600_ExcelPopup.DefaultLineCheck

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-068ea26e | (진입점 미연결) | FP02600_ExcelPopup.cs:665 |  | CALL_EXT | ExcelService.CommonDefaultLineCheck | (row, KeyColumnList, ColumnType, ColumnLength, Filter, AcceptOnlyPositve) | ⚠ 의미 확인 필요 |  |  |  |
| AC-5f1c08f1 | (진입점 미연결) | FP02600_ExcelPopup.cs:665 |  | RETURN | return ExcelService.CommonDefaultLineCheck(row, KeyColumnList, ColumnType, Colum… |  | 처리 중단/반환 |  |  |  |

## FP02600_ExcelPopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-54fc765a | this.Load | FP02600_ExcelPopup.cs:187 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP02600_ExcelPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-176b39f2 | Dispose | FP02600_ExcelPopup.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP02600_ExcelPopup.ExcelLineCheck

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ff729382 | (진입점 미연결) | FP02600_ExcelPopup.cs:588 | if (this.DoLineCheck != null) | CALL_BASE | DoLineCheck | (row, this) | ⚠ 의미 확인 필요 |  |  |  |

## FP02600_ExcelPopup.FindButton

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9fb5b4ae | FindButton | FP02600_ExcelPopup.cs:235 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-257d4f51 | FindButton | FP02600_ExcelPopup.cs:236 |  | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-ceeb8f30 | FindButton | FP02600_ExcelPopup.cs:238 |  | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## FP02600_ExcelPopup.FindData

진입점: this.Load / this.btnFind.Click / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-38b45018 | this.Load 외 2 | FP02600_ExcelPopup.cs:265 | if (DoSearchData == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b1472cd7 | this.Load 외 2 | FP02600_ExcelPopup.cs:266 |  | FLAG | ctx | FoxUserInfoContext.GetUserInfoContext() | 화면 필드/플래그 변경 |  |  |  |
| AC-1705770a | this.Load 외 2 | FP02600_ExcelPopup.cs:266 |  | CALL_EXT | FoxUserInfoContext.GetUserInfoContext | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-4b645822 | this.Load 외 2 | FP02600_ExcelPopup.cs:270 | if (DoSearchData != null) | FLAG | this.hasError | false | 화면 필드/플래그 변경 |  |  |  |
| AC-47fd0597 | this.Load 외 2 | FP02600_ExcelPopup.cs:271 | if (DoSearchData != null) | FLAG | this.IsExcelChanged | false | 화면 필드/플래그 변경 |  |  |  |
| AC-e7946aec | this.Load 외 2 | FP02600_ExcelPopup.cs:273 | if (DoSearchData != null) | STATE | this.spdMain.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-3471dc36 | this.Load 외 2 | FP02600_ExcelPopup.cs:274 | if (DoSearchData != null) | STATE | this.btnClose.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-1424a5a5 | this.Load 외 2 | FP02600_ExcelPopup.cs:275 | if (DoSearchData != null) | STATE | this.btnFind.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-9d6cdf0d | this.Load 외 2 | FP02600_ExcelPopup.cs:276 | if (DoSearchData != null) | STATE | this.btnDownload.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-bd020855 | this.Load 외 2 | FP02600_ExcelPopup.cs:277 | if (DoSearchData != null) | STATE | this.btnUpload.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-59b8b5c2 | this.Load 외 2 | FP02600_ExcelPopup.cs:278 | if (DoSearchData != null) | STATE | this.btnSave.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-432c62eb | this.Load 외 2 | FP02600_ExcelPopup.cs:285 | if (DoSearchData != null) ▸ try ▸ if (UserInfoContext.Current == null) | CALL_EXT | FoxUserInfoContext.SetCallContext | (ctx) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ac628072 | this.Load 외 2 | FP02600_ExcelPopup.cs:288 | if (DoSearchData != null) ▸ try | CALL_BASE | DoSearchData | (Filter.Data, this) | ⚠ 의미 확인 필요 |  |  |  |
| AC-09397436 | this.Load 외 2 | FP02600_ExcelPopup.cs:291 | if (DoSearchData != null) ▸ try ▸ if (set == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3ac30138 | this.Load 외 2 | FP02600_ExcelPopup.cs:292 | if (DoSearchData != null) ▸ try | CALL_BASE | this.Invoke | (new Action(delegate () { DictColumn = siMain.SetSheetHeaderColumn_FP2(siMain, 2);//.SetSh… | ⚠ 의미 확인 필요 |  |  |  |
| AC-51b0ac79 | this.Load 외 2 | FP02600_ExcelPopup.cs:294 | if (DoSearchData != null) ▸ try ▸ lambda | FLAG | DictColumn | siMain.SetSheetHeaderColumn_FP2(siMain, 2) | 화면 필드/플래그 변경 |  |  |  |
| AC-272285f8 | this.Load 외 2 | FP02600_ExcelPopup.cs:294 | if (DoSearchData != null) ▸ try ▸ lambda | GRID_INIT | siMain.SetSheetHeaderColumn_FP2 | (siMain, 2) | 그리드 재구성/초기화 |  |  |  |
| AC-e8e6c973 | this.Load 외 2 | FP02600_ExcelPopup.cs:300 | if (DoSearchData != null) ▸ try ▸ lambda ▸ if (AutoCHK) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex("CHK")].CellType | chk | 그리드 속성/값 설정 |  |  |  |
| AC-d33e6b2a | this.Load 외 2 | FP02600_ExcelPopup.cs:301 | if (DoSearchData != null) ▸ try ▸ lambda ▸ if (AutoCHK) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex("CHK")].Value | false | 그리드 속성/값 설정 |  |  |  |
| AC-50613203 | this.Load 외 2 | FP02600_ExcelPopup.cs:302 | if (DoSearchData != null) ▸ try ▸ lambda ▸ if (AutoCHK) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex("CHK")].Border | bevelbrdr | 그리드 속성/값 설정 |  |  |  |
| AC-70af1a2b | this.Load 외 2 | FP02600_ExcelPopup.cs:307 | if (DoSearchData != null) ▸ try ▸ lambda ▸ if (set != null && set.Tables != null && set.Tables.Count > 0) | DATA_OP | set.Tables[0].Columns.Contains | ("MESSAGE") | 데이터 객체 조작/조회 |  |  |  |
| AC-edfb1d63 | this.Load 외 2 | FP02600_ExcelPopup.cs:308 | if (DoSearchData != null) ▸ try ▸ lambda ▸ if (set != null && set.Tables != null && set.Tables.Count > 0) ▸ if (!set.Tables[0].Columns.Conta… | DATA_OP | set.Tables[0].Columns.Add | ("MESSAGE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-b245c74b | this.Load 외 2 | FP02600_ExcelPopup.cs:312 | if (DoSearchData != null) ▸ try ▸ lambda | GRID_BIND | siMain.Query | (set, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-61ff1ada | this.Load 외 2 | FP02600_ExcelPopup.cs:316 | if (DoSearchData != null) ▸ try ▸ lambda ▸ if (colIndex > 0) | CALL_EXT | siMain.SetColumnFormat | (colIndex, 1, "#,##0.#########", "", true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-7af6edc4 | this.Load 외 2 | FP02600_ExcelPopup.cs:320 | if (DoSearchData != null) ▸ try ▸ lambda ▸ if (colIndex > 0) | CALL_EXT | siMain.SetColumnFormat | (colIndex, 1, "#,##0.#########", "", true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-afda19f1 | this.Load 외 2 | FP02600_ExcelPopup.cs:324 | if (DoSearchData != null) ▸ try ▸ lambda ▸ if (colIndex > 0) | CALL_EXT | siMain.SetColumnFormat | (colIndex, 1, "#,##0.#########", "", true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3bf1f5c2 | this.Load 외 2 | FP02600_ExcelPopup.cs:328 | if (DoSearchData != null) ▸ try ▸ lambda ▸ if (colIndex > 0) | CALL_EXT | siMain.SetColumnFormat | (colIndex, 1, "#,##0.#########", "", true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-38ecb2d3 | this.Load 외 2 | FP02600_ExcelPopup.cs:338 | if (DoSearchData != null) ▸ finally | CALL_BASE | this.Invoke | (new Action(delegate () { //this.Enabled = false; this.spdMain.Enabled = true; this.btnClo… | ⚠ 의미 확인 필요 |  |  |  |
| AC-89e90a9c | this.Load 외 2 | FP02600_ExcelPopup.cs:341 | if (DoSearchData != null) ▸ finally ▸ lambda | STATE | this.spdMain.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-22aa0511 | this.Load 외 2 | FP02600_ExcelPopup.cs:342 | if (DoSearchData != null) ▸ finally ▸ lambda | STATE | this.btnClose.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-9acb4674 | this.Load 외 2 | FP02600_ExcelPopup.cs:343 | if (DoSearchData != null) ▸ finally ▸ lambda | STATE | this.btnFind.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-1ccc2212 | this.Load 외 2 | FP02600_ExcelPopup.cs:344 | if (DoSearchData != null) ▸ finally ▸ lambda | STATE | this.btnDownload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-7c2c12db | this.Load 외 2 | FP02600_ExcelPopup.cs:345 | if (DoSearchData != null) ▸ finally ▸ lambda | STATE | this.btnUpload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-76803aaa | this.Load 외 2 | FP02600_ExcelPopup.cs:346 | if (DoSearchData != null) ▸ finally ▸ lambda | STATE | this.btnSave.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## FP02600_ExcelPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-05b9aa78 | this.Load | FP02600_ExcelPopup.cs:162 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-6ccf4ae9 | this.Load | FP02600_ExcelPopup.cs:164 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP02600_ExcelPopup.GetExcelFileName

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-31f6573f | (진입점 미연결) | FP02600_ExcelPopup.cs:562 | try | POPUP | new OpenFileDialog | () | 팝업/폼 생성 |  |  |  |
| AC-ac8e5a07 | (진입점 미연결) | FP02600_ExcelPopup.cs:563 | try | UI_PROP | openFile.Filter | "Excel files (*.xls;*.xlsx)\|*.xls;*.xlsx\|xls files (*.xls)\|*.xls\|xlsx files (*.xlsx)\|… | 속성 Filter 설정 |  |  |  |
| AC-ad8f20b2 | (진입점 미연결) | FP02600_ExcelPopup.cs:564 | try | UI_PROP | openFile.FilterIndex | 1 | 속성 FilterIndex 설정 |  |  |  |
| AC-d8f9d357 | (진입점 미연결) | FP02600_ExcelPopup.cs:565 | try | UI_PROP | openFile.RestoreDirectory | true | 속성 RestoreDirectory 설정 |  |  |  |
| AC-013981e6 | (진입점 미연결) | FP02600_ExcelPopup.cs:566 | try | UI_PROP | openFile.InitialDirectory | @"C:\My Documents\" | 속성 InitialDirectory 설정 |  |  |  |
| AC-fcac347b | (진입점 미연결) | FP02600_ExcelPopup.cs:567 | try | UI_PROP | openFile.FileName | FileName | 속성 FileName 설정 |  |  |  |
| AC-96789c70 | (진입점 미연결) | FP02600_ExcelPopup.cs:568 | try | POPUP | openFile.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-f50a4bcf | (진입점 미연결) | FP02600_ExcelPopup.cs:570 | try | FLAG | this.FileName | openFile.FileName | 화면 필드/플래그 변경 |  |  |  |
| AC-3126cd82 | (진입점 미연결) | FP02600_ExcelPopup.cs:571 | try | RETURN | return this.FileName; |  | 처리 중단/반환 |  |  |  |
| AC-00efccec | (진입점 미연결) | FP02600_ExcelPopup.cs:575 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message, ex.Source, MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-197063f7 | (진입점 미연결) | FP02600_ExcelPopup.cs:576 | catch ((Exception ex)) | RETURN | return string.Empty; |  | 처리 중단/반환 |  |  |  |

## FP02600_ExcelPopup.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-252157d6 | this.Load | FP02600_ExcelPopup.cs:204 |  | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-64d42cd7 | this.Load | FP02600_ExcelPopup.cs:205 |  | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP02600_ExcelPopup.InitSpread_Merge

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-889c0cef | (진입점 미연결) | FP02600_ExcelPopup.cs:225 |  | GRID_INIT | siMain.Freeze | (0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP02600_ExcelPopup.OpenAndLoadExcelData

진입점: this.btnUpload.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bbb4ba64 | this.btnUpload.Click | FP02600_ExcelPopup.cs:599 |  | FLAG | FileName | ExcelService.GetExcelFileName(FileName) | 화면 필드/플래그 변경 |  |  |  |
| AC-841bb87d | this.btnUpload.Click | FP02600_ExcelPopup.cs:599 |  | CALL_EXT | ExcelService.GetExcelFileName | (FileName) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c959af58 | this.btnUpload.Click | FP02600_ExcelPopup.cs:600 |  | FLAG | hasError | false | 화면 필드/플래그 변경 |  |  |  |
| AC-0782c268 | this.btnUpload.Click | FP02600_ExcelPopup.cs:601 |  | FLAG | IsExcelChanged | true | 화면 필드/플래그 변경 |  |  |  |
| AC-d01024a7 | this.btnUpload.Click | FP02600_ExcelPopup.cs:602 |  | CALL_EXT | System.IO.File.Exists | (FileName) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3a04d5cc | this.btnUpload.Click | FP02600_ExcelPopup.cs:604 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-3b2f7a37 | this.btnUpload.Click | FP02600_ExcelPopup.cs:609 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try | FLAG | hasError | ExcelService.LoadExcelFile( FileName, KeyColumns, KeyColumnList, DictColumn, HeaderLineCou… | 화면 필드/플래그 변경 |  |  |  |
| AC-bfaf946a | this.btnUpload.Click | FP02600_ExcelPopup.cs:609 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try | CALL_EXT | ExcelService.LoadExcelFile | ( FileName, KeyColumns, KeyColumnList, DictColumn, HeaderLineCount, spdMain, siMain, null,… | ⚠ 의미 확인 필요 |  |  |  |
| AC-e10e6966 | this.btnUpload.Click | FP02600_ExcelPopup.cs:616 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-13f017c4 | this.btnUpload.Click | FP02600_ExcelPopup.cs:619 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (hasError == false) | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-05c1ef30 | this.btnUpload.Click | FP02600_ExcelPopup.cs:620 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (hasError == false) | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-c3b4fb92 | this.btnUpload.Click | FP02600_ExcelPopup.cs:624 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (hasError == false) ▸ if (DoImportData != nu… | CALL_BASE | DoImportData | (dsImport, this) | ⚠ 의미 확인 필요 |  |  |  |
| AC-27747db9 | this.btnUpload.Click | FP02600_ExcelPopup.cs:625 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (hasError == false) ▸ if (DoImportData != nu… | CALL_EXT | DataService.ReadResult | (importResult) | ⚠ 의미 확인 필요 |  |  |  |
| AC-cb8f6bfe | this.btnUpload.Click | FP02600_ExcelPopup.cs:637 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (hasError == false) ▸ if (DoImportData != nu… | CALL_EXT | siMain.SetRowColor | (i, System.Drawing.Color.PaleVioletRed) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d35cd8ce | this.btnUpload.Click | FP02600_ExcelPopup.cs:641 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (hasError == false) ▸ if (DoImportData != nu… | FLAG | hasError | true | 화면 필드/플래그 변경 |  |  |  |
| AC-09e675e7 | this.btnUpload.Click | FP02600_ExcelPopup.cs:644 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (hasError == false) | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-a4185711 | this.btnUpload.Click | FP02600_ExcelPopup.cs:649 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ catch () | THROW | throw; |  | 예외 발생 |  |  |  |
| AC-9aac43e4 | this.btnUpload.Click | FP02600_ExcelPopup.cs:653 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-7b5fe358 | this.btnUpload.Click | FP02600_ExcelPopup.cs:654 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-5e8bf698 | this.btnUpload.Click | FP02600_ExcelPopup.cs:657 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## FP02600_ExcelPopup.SaveToDB

진입점: this.btnSave.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cb2c0c0f | this.btnSave.Click | FP02600_ExcelPopup.cs:360 | if (IsExcelChanged == false) | MESSAGE | MessageBox.Show | ("There is no changed to save") | 메시지 표시 |  |  |  |
| AC-9047bcd6 | this.btnSave.Click | FP02600_ExcelPopup.cs:361 | if (IsExcelChanged == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-454a7fbe | this.btnSave.Click | FP02600_ExcelPopup.cs:365 | if (hasError == true) | MESSAGE | MessageBox.Show | ("You have errors to fix") | 메시지 표시 |  |  |  |
| AC-a17720a9 | this.btnSave.Click | FP02600_ExcelPopup.cs:366 | if (hasError == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6288c708 | this.btnSave.Click | FP02600_ExcelPopup.cs:370 |  | FLAG | ctx | FoxUserInfoContext.GetUserInfoContext() | 화면 필드/플래그 변경 |  |  |  |
| AC-66cbe77f | this.btnSave.Click | FP02600_ExcelPopup.cs:370 |  | CALL_EXT | FoxUserInfoContext.GetUserInfoContext | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-410fe569 | this.btnSave.Click | FP02600_ExcelPopup.cs:375 | if (DoSaveData != null) | STATE | this.spdMain.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-652f1762 | this.btnSave.Click | FP02600_ExcelPopup.cs:376 | if (DoSaveData != null) | STATE | this.btnClose.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-03ca145c | this.btnSave.Click | FP02600_ExcelPopup.cs:377 | if (DoSaveData != null) | STATE | this.btnFind.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-cacfcb8e | this.btnSave.Click | FP02600_ExcelPopup.cs:378 | if (DoSaveData != null) | STATE | this.btnDownload.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-b388a9b0 | this.btnSave.Click | FP02600_ExcelPopup.cs:379 | if (DoSaveData != null) | STATE | this.btnUpload.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-5e6d1dc7 | this.btnSave.Click | FP02600_ExcelPopup.cs:380 | if (DoSaveData != null) | STATE | this.btnSave.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-265a5df9 | this.btnSave.Click | FP02600_ExcelPopup.cs:388 | if (DoSaveData != null) ▸ try ▸ if (main != null && main.Tables != null && main.Tables.Count > 0) | DATA_OP | main.Tables[0].Columns.Contains | ("USER_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-68c8d9c3 | this.btnSave.Click | FP02600_ExcelPopup.cs:391 | if (DoSaveData != null) ▸ try ▸ if (main != null && main.Tables != null && main.Tables.Count > 0) ▸ if (!main.Tables[0].Columns.Contains("US… | DATA_OP | main.Tables[0].Columns.Add | (itemColumn) | 데이터 객체 조작/조회 |  |  |  |
| AC-5a002bfd | this.btnSave.Click | FP02600_ExcelPopup.cs:397 | if (DoSaveData != null) ▸ try ▸ if (main != null && main.Tables != null && main.Tables.Count > 0) ▸ for (i < main.Tables[0].Rows.Count) | GRID_SET | main.Tables[0].Rows[i]["USER_ID"] | UserInfoContext.Current.UserId | 그리드 속성/값 설정 |  |  |  |
| AC-174f319b | this.btnSave.Click | FP02600_ExcelPopup.cs:405 | if (DoSaveData != null) ▸ try ▸ if (expect_count < 1) | MESSAGE | MessageBox.Show | ("There is no data to save") | 메시지 표시 |  |  |  |
| AC-8b8a0c9b | this.btnSave.Click | FP02600_ExcelPopup.cs:406 | if (DoSaveData != null) ▸ try ▸ if (expect_count < 1) | STATE | this.spdMain.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-ccc6b0e5 | this.btnSave.Click | FP02600_ExcelPopup.cs:407 | if (DoSaveData != null) ▸ try ▸ if (expect_count < 1) | STATE | this.btnClose.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-19050c63 | this.btnSave.Click | FP02600_ExcelPopup.cs:408 | if (DoSaveData != null) ▸ try ▸ if (expect_count < 1) | STATE | this.btnFind.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-de595c13 | this.btnSave.Click | FP02600_ExcelPopup.cs:409 | if (DoSaveData != null) ▸ try ▸ if (expect_count < 1) | STATE | this.btnDownload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-ffe3a1ca | this.btnSave.Click | FP02600_ExcelPopup.cs:410 | if (DoSaveData != null) ▸ try ▸ if (expect_count < 1) | STATE | this.btnUpload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-75db98e3 | this.btnSave.Click | FP02600_ExcelPopup.cs:411 | if (DoSaveData != null) ▸ try ▸ if (expect_count < 1) | STATE | this.btnSave.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-638ac80a | this.btnSave.Click | FP02600_ExcelPopup.cs:412 | if (DoSaveData != null) ▸ try ▸ if (expect_count < 1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-27a9871a | this.btnSave.Click | FP02600_ExcelPopup.cs:415 | if (DoSaveData != null) ▸ try | FLAG | validation | null | 화면 필드/플래그 변경 |  |  |  |
| AC-3032f07f | this.btnSave.Click | FP02600_ExcelPopup.cs:418 | if (DoSaveData != null) ▸ try ▸ if (DoValidationData != null) | FLAG | validation | DoValidationData(main, this) | 화면 필드/플래그 변경 |  |  |  |
| AC-9d836fa0 | this.btnSave.Click | FP02600_ExcelPopup.cs:418 | if (DoSaveData != null) ▸ try ▸ if (DoValidationData != null) | CALL_BASE | DoValidationData | (main, this) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c45a6597 | this.btnSave.Click | FP02600_ExcelPopup.cs:452 | if (DoSaveData != null) ▸ try ▸ if (valid) | CALL_BASE | DoSaveData | (main, this) | ⚠ 의미 확인 필요 |  |  |  |
| AC-2df2f39e | this.btnSave.Click | FP02600_ExcelPopup.cs:464 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ try | DATA_OP | result.Tables[0].Columns.Contains | ("RESULT") | 데이터 객체 조작/조회 |  |  |  |
| AC-e883bc1d | this.btnSave.Click | FP02600_ExcelPopup.cs:466 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ try | DATA_OP | result.Tables[0].Columns.Contains | ("COUNT") | 데이터 객체 조작/조회 |  |  |  |
| AC-0dcd8652 | this.btnSave.Click | FP02600_ExcelPopup.cs:468 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ try | DATA_OP | result.Tables[0].Columns.Contains | ("EXCEPTION") | 데이터 객체 조작/조회 |  |  |  |
| AC-db13bdb2 | this.btnSave.Click | FP02600_ExcelPopup.cs:472 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ try ▸ if (!string.IsNullOrWhiteSpace(exception)) | MESSAGE | MessageBox.Show | ("Validation error :" + exception) | 메시지 표시 |  |  |  |
| AC-a66314e0 | this.btnSave.Click | FP02600_ExcelPopup.cs:487 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ try ▸ if (result_string != "SUCCESS") | MESSAGE | MessageBox.Show | (string.Format("Save Error")) | 메시지 표시 |  |  |  |
| AC-50a72c59 | this.btnSave.Click | FP02600_ExcelPopup.cs:488 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ try ▸ if (result_string != "SUCCESS") | FLAG | this.hasError | true | 화면 필드/플래그 변경 |  |  |  |
| AC-cd389a02 | this.btnSave.Click | FP02600_ExcelPopup.cs:492 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ try ▸ else of (result_string != "SUCCESS") | MESSAGE | MessageBox.Show | (string.Format("Data Saved")) | 메시지 표시 |  |  |  |
| AC-80c9835a | this.btnSave.Click | FP02600_ExcelPopup.cs:493 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ try ▸ else of (result_string != "SUCCESS") | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-2c715ff4 | this.btnSave.Click | FP02600_ExcelPopup.cs:498 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ catch ((Exception e)) | MESSAGE | MessageBox.Show | ("Unknown validation error :" + e.Message) | 메시지 표시 |  |  |  |
| AC-4dd9ee9b | this.btnSave.Click | FP02600_ExcelPopup.cs:520 | if (DoSaveData != null) ▸ try ▸ else of (result.Good()) ▸ if (validation != null) ▸ if (xlsSrc.Rows.Count >= valSrc.Rows.Count) ▸ for (i < v… | DATA_OP | xlsrow["MESSAGE"] | valrow["_MSG"] | 행/컬럼 값 대입 |  |  |  |
| AC-855a0592 | this.btnSave.Click | FP02600_ExcelPopup.cs:521 | if (DoSaveData != null) ▸ try ▸ else of (result.Good()) ▸ if (validation != null) ▸ if (xlsSrc.Rows.Count >= valSrc.Rows.Count) ▸ for (i < v… | CALL_EXT | siMain.SetRowColor | (i, System.Drawing.Color.PaleVioletRed) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e86fbb28 | this.btnSave.Click | FP02600_ExcelPopup.cs:522 | if (DoSaveData != null) ▸ try ▸ else of (result.Good()) ▸ if (validation != null) ▸ if (xlsSrc.Rows.Count >= valSrc.Rows.Count) ▸ for (i < v… | FLAG | this.hasError | true | 화면 필드/플래그 변경 |  |  |  |
| AC-d9d4b218 | this.btnSave.Click | FP02600_ExcelPopup.cs:528 | if (DoSaveData != null) ▸ try ▸ else of (result.Good()) ▸ if (validation != null) | MESSAGE | MessageBox.Show | (string.Format("There are invalid data.")) | 메시지 표시 |  |  |  |
| AC-be233ed5 | this.btnSave.Click | FP02600_ExcelPopup.cs:532 | if (DoSaveData != null) ▸ try ▸ else of (result.Good()) ▸ else of (validation != null) | MESSAGE | MessageBox.Show | (string.Format("Save Fail")) | 메시지 표시 |  |  |  |
| AC-03004a9b | this.btnSave.Click | FP02600_ExcelPopup.cs:538 | if (DoSaveData != null) ▸ catch ((Exception e)) | MESSAGE | MessageBox.Show | (string.Format("Save Fail:" + e.Message)) | 메시지 표시 |  |  |  |
| AC-9e93e3c7 | this.btnSave.Click | FP02600_ExcelPopup.cs:539 | if (DoSaveData != null) ▸ catch ((Exception e)) | FLAG | this.hasError | true | 화면 필드/플래그 변경 |  |  |  |
| AC-d08441cd | this.btnSave.Click | FP02600_ExcelPopup.cs:544 | if (DoSaveData != null) ▸ finally | STATE | this.spdMain.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-d7ac2ebc | this.btnSave.Click | FP02600_ExcelPopup.cs:545 | if (DoSaveData != null) ▸ finally | STATE | this.btnClose.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-8ef1d81e | this.btnSave.Click | FP02600_ExcelPopup.cs:546 | if (DoSaveData != null) ▸ finally | STATE | this.btnFind.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-20afa9a7 | this.btnSave.Click | FP02600_ExcelPopup.cs:547 | if (DoSaveData != null) ▸ finally | STATE | this.btnDownload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-5e068497 | this.btnSave.Click | FP02600_ExcelPopup.cs:548 | if (DoSaveData != null) ▸ finally | STATE | this.btnUpload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-cf35c580 | this.btnSave.Click | FP02600_ExcelPopup.cs:549 | if (DoSaveData != null) ▸ finally | STATE | this.btnSave.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## FP02600_ExcelPopup.SetSpreadInit

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d59171f9 | this.Load | FP02600_ExcelPopup.cs:217 |  | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-123bb7a4 | this.Load | FP02600_ExcelPopup.cs:218 |  | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |

## FP02600_Prod_Result_WO_MES..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6afb80de | .ctor | FP02600_Prod_Result_WO_MES.cs:167 |  | UI_PROP | this.DeleteOperation | DeleteOperationKind.ToZero | 속성 DeleteOperation 설정 |  |  |  |
| AC-64a755c5 | .ctor | FP02600_Prod_Result_WO_MES.cs:168 |  | FLAG | CurrentUser | UserInfoContext.Current.UserId | 화면 필드/플래그 변경 |  |  |  |

## FP02600_Prod_Result_WO_MES.ApplyAmendCalendarCondition

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0160f4fa | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:2879 |  | FLAG | calendar | null | 화면 필드/플래그 변경 |  |  |  |
| AC-99c21f66 | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:2880 |  | FLAG | weekInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-468f239a | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:2881 |  | FLAG | dateMap | null | 화면 필드/플래그 변경 |  |  |  |
| AC-aa4fd679 | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:2882 |  | FLAG | monthInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-da8ed546 | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:2883 |  | FLAG | bukInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-2026db8c | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:2884 |  | FLAG | weekInfo | DataService.FP_ExecuteQuery("FP00602_PlanAmendLineAssy", "find_WeekCnt", Filter.Dictionary… ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] \| FP\Common\FP00… | 화면 필드/플래그 변경 |  |  |  |
| AC-b4709767 | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:2884 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00602_PlanAmendLineAssy", "find_WeekCnt", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] \| FP\Common\FP00… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-426addda | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:2885 |  | FLAG | dateMap | DataService.FP_ExecuteQuery("FP00602_PlanAmendLineAssy", "find_DateMap", Filter.Dictionary… ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] \| FP\Common\FP00… | 화면 필드/플래그 변경 |  |  |  |
| AC-16adc37e | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:2885 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00602_PlanAmendLineAssy", "find_DateMap", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] \| FP\Common\FP00… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-1332314f | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:2886 |  | FLAG | monthInfo | DataService.FP_ExecuteQuery("FP00602_PlanAmendLineAssy", "find_MonthCnt", Filter.Dictionar… ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] \| FP\Common\FP0… | 화면 필드/플래그 변경 |  |  |  |
| AC-19c93dd4 | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:2886 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00602_PlanAmendLineAssy", "find_MonthCnt", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] \| FP\Common\FP0… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-87e75177 | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:2887 |  | FLAG | bukInfo | DataService.FP_ExecuteQuery("FP00602_PlanAmendLineAssy", "find_bukInfo", Filter.Dictionary… ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_bukInfo] \| FP\Common\FP00… | 화면 필드/플래그 변경 |  |  |  |
| AC-166f9713 | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:2887 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00602_PlanAmendLineAssy", "find_bukInfo", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_bukInfo] \| FP\Common\FP00… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-cd9e6415 | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:2899 | if (measure.Month.On) | DATA_OP | Filter["MONTH_INFO"] | month_info | 행/컬럼 값 대입 |  |  |  |
| AC-0bb2dca0 | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:2901 | else of (measure.Month.On) | DATA_OP | Filter["MONTH_INFO"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-f2df97e0 | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:2902 |  | DATA_OP | Filter["BUCKET"] | bulk_info | 행/컬럼 값 대입 |  |  |  |
| AC-e5bdd490 | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:2903 |  | DATA_OP | Filter["WEEK_INFO"] | week_info | 행/컬럼 값 대입 |  |  |  |
| AC-1adc8702 | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:2904 |  | DATA_OP | Filter["CATE_INFO"] | cate_info | 행/컬럼 값 대입 |  |  |  |

## FP02600_Prod_Result_WO_MES.ApplySearchCondition

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-be161590 | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:2937 |  | DATA_OP | LocalFilter["MASTER_ID"] | LocalFilter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |

## FP02600_Prod_Result_WO_MES.btnExcelImport_Click

진입점: this.btnExcelImport.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b219a582 | this.btnExcelImport.Click | FP02600_Prod_Result_WO_MES.cs:2943 | if (!FindDone) | MESSAGE | MessageBox.Show | ("You need to Find(F5) before import excel") | 메시지 표시 |  |  |  |
| AC-2251f95d | this.btnExcelImport.Click | FP02600_Prod_Result_WO_MES.cs:2944 | if (!FindDone) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f82f7ead | this.btnExcelImport.Click | FP02600_Prod_Result_WO_MES.cs:2947 |  | POPUP | new FP02600_ExcelPopup |  | 팝업/폼 생성 |  |  |  |
| AC-c26d3296 | this.btnExcelImport.Click | FP02600_Prod_Result_WO_MES.cs:2949 |  | FLAG | Filter | Filter.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-42ca95ab | this.btnExcelImport.Click | FP02600_Prod_Result_WO_MES.cs:2949 |  | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-43a19e0f | this.btnExcelImport.Click | FP02600_Prod_Result_WO_MES.cs:2953 |  | GRID_SET | rowPopup.KeyColumns["Company_id"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-909a37d0 | this.btnExcelImport.Click | FP02600_Prod_Result_WO_MES.cs:2954 |  | GRID_SET | rowPopup.KeyColumns["DIVISION_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-5a544d4d | this.btnExcelImport.Click | FP02600_Prod_Result_WO_MES.cs:2955 |  | GRID_SET | rowPopup.KeyColumns["SITE_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-11d050af | this.btnExcelImport.Click | FP02600_Prod_Result_WO_MES.cs:2956 |  | GRID_SET | rowPopup.KeyColumns["PLANT_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-5ebdcd25 | this.btnExcelImport.Click | FP02600_Prod_Result_WO_MES.cs:2957 |  | GRID_SET | rowPopup.KeyColumns["FACTORY_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-0336f7c6 | this.btnExcelImport.Click | FP02600_Prod_Result_WO_MES.cs:2958 |  | GRID_SET | rowPopup.KeyColumns["CUTOFF_DATE"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-a4b5b10d | this.btnExcelImport.Click | FP02600_Prod_Result_WO_MES.cs:2959 |  | GRID_SET | rowPopup.KeyColumns["WORK_ORDER_SPL_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-8a21f7d6 | this.btnExcelImport.Click | FP02600_Prod_Result_WO_MES.cs:2960 |  | GRID_SET | rowPopup.KeyColumns["WORK_ORDER_ID"] | false | 그리드 속성/값 설정 |  |  |  |
| AC-b4e2d450 | this.btnExcelImport.Click | FP02600_Prod_Result_WO_MES.cs:2961 |  | GRID_SET | rowPopup.KeyColumns["ORDER_TYPE"] | false | 그리드 속성/값 설정 |  |  |  |
| AC-ccc6f81f | this.btnExcelImport.Click | FP02600_Prod_Result_WO_MES.cs:2962 |  | GRID_SET | rowPopup.KeyColumns["ITEM_ID"] | false | 그리드 속성/값 설정 |  |  |  |
| AC-6c6e4df7 | this.btnExcelImport.Click | FP02600_Prod_Result_WO_MES.cs:2963 |  | GRID_SET | rowPopup.KeyColumns["NICK_NAME"] | false | 그리드 속성/값 설정 |  |  |  |
| AC-a41fedf0 | this.btnExcelImport.Click | FP02600_Prod_Result_WO_MES.cs:2964 |  | GRID_SET | rowPopup.KeyColumns["TOP_ITEM_ID"] | false | 그리드 속성/값 설정 |  |  |  |
| AC-824757d3 | this.btnExcelImport.Click | FP02600_Prod_Result_WO_MES.cs:2966 |  | GRID_SET | rowPopup.KeyColumns["OPERATION_ID"] | false | 그리드 속성/값 설정 |  |  |  |
| AC-68494e64 | this.btnExcelImport.Click | FP02600_Prod_Result_WO_MES.cs:2967 |  | GRID_SET | rowPopup.KeyColumns["LINE_ID"] | false | 그리드 속성/값 설정 |  |  |  |
| AC-1cf916fb | this.btnExcelImport.Click | FP02600_Prod_Result_WO_MES.cs:2968 |  | GRID_SET | rowPopup.KeyColumns["EQUIPMENT_ID"] | false | 그리드 속성/값 설정 |  |  |  |
| AC-adebe073 | this.btnExcelImport.Click | FP02600_Prod_Result_WO_MES.cs:2969 |  | GRID_SET | rowPopup.KeyColumns["PLAN_DATE"] | false | 그리드 속성/값 설정 |  |  |  |
| AC-67d039d8 | this.btnExcelImport.Click | FP02600_Prod_Result_WO_MES.cs:2971 |  | GRID_SET | rowPopup.KeyColumns["PLAN_QTY"] | false | 그리드 속성/값 설정 |  |  |  |
| AC-d97116ee | this.btnExcelImport.Click | FP02600_Prod_Result_WO_MES.cs:2972 |  | GRID_SET | rowPopup.KeyColumns["PLAN_START_TIME"] | false | 그리드 속성/값 설정 |  |  |  |
| AC-ddd57b28 | this.btnExcelImport.Click | FP02600_Prod_Result_WO_MES.cs:2973 |  | GRID_SET | rowPopup.KeyColumns["PLAN_END_TIME"] | false | 그리드 속성/값 설정 |  |  |  |
| AC-f590661b | this.btnExcelImport.Click | FP02600_Prod_Result_WO_MES.cs:2975 |  | GRID_SET | rowPopup.KeyColumns["ACTUAL_GOOD_QTY"] | false | 그리드 속성/값 설정 |  |  |  |
| AC-5107effc | this.btnExcelImport.Click | FP02600_Prod_Result_WO_MES.cs:2976 |  | GRID_SET | rowPopup.KeyColumns["ACTUAL_SCRAP_QTY"] | false | 그리드 속성/값 설정 |  |  |  |
| AC-ac8cecc6 | this.btnExcelImport.Click | FP02600_Prod_Result_WO_MES.cs:2977 |  | GRID_SET | rowPopup.KeyColumns["ACTUAL_QTY"] | false | 그리드 속성/값 설정 |  |  |  |
| AC-50325c4c | this.btnExcelImport.Click | FP02600_Prod_Result_WO_MES.cs:2978 |  | GRID_SET | rowPopup.KeyColumns["ACTUAL_START_TIME"] | false | 그리드 속성/값 설정 |  |  |  |
| AC-bfac2ccf | this.btnExcelImport.Click | FP02600_Prod_Result_WO_MES.cs:2979 |  | GRID_SET | rowPopup.KeyColumns["ACTUAL_END_TIME"] | false | 그리드 속성/값 설정 |  |  |  |
| AC-7bbb8eeb | this.btnExcelImport.Click | FP02600_Prod_Result_WO_MES.cs:2981 |  | GRID_SET | rowPopup.KeyColumns["RUNNING_FLAG"] | false | 그리드 속성/값 설정 |  |  |  |
| AC-4ac5fbf7 | this.btnExcelImport.Click | FP02600_Prod_Result_WO_MES.cs:2982 |  | GRID_SET | rowPopup.KeyColumns["WO_STATUS"] | false | 그리드 속성/값 설정 |  |  |  |
| AC-39d6ebd4 | this.btnExcelImport.Click | FP02600_Prod_Result_WO_MES.cs:2983 |  | GRID_SET | rowPopup.KeyColumns["MESSAGE"] | false | 그리드 속성/값 설정 |  |  |  |
| AC-a4d6a27d | this.btnExcelImport.Click | FP02600_Prod_Result_WO_MES.cs:2986 |  | DATA_OP | rowPopup.ColumnTitle["Company_id"] | "Company" | 행/컬럼 값 대입 |  |  |  |
| AC-e170c991 | this.btnExcelImport.Click | FP02600_Prod_Result_WO_MES.cs:2987 |  | DATA_OP | rowPopup.ColumnTitle["DIVISION_ID"] | "Division" | 행/컬럼 값 대입 |  |  |  |
| AC-80b2f99b | this.btnExcelImport.Click | FP02600_Prod_Result_WO_MES.cs:2988 |  | DATA_OP | rowPopup.ColumnTitle["SITE_ID"] | "Site" | 행/컬럼 값 대입 |  |  |  |
| AC-711c663e | this.btnExcelImport.Click | FP02600_Prod_Result_WO_MES.cs:2989 |  | DATA_OP | rowPopup.ColumnTitle["PLANT_ID"] | "Plant" | 행/컬럼 값 대입 |  |  |  |
| AC-ddba795b | this.btnExcelImport.Click | FP02600_Prod_Result_WO_MES.cs:2990 |  | DATA_OP | rowPopup.ColumnTitle["FACTORY_ID"] | "Building" | 행/컬럼 값 대입 |  |  |  |
| AC-fc0b5694 | this.btnExcelImport.Click | FP02600_Prod_Result_WO_MES.cs:2991 |  | DATA_OP | rowPopup.ColumnTitle["CUTOFF_DATE"] | "CutOff Date" | 행/컬럼 값 대입 |  |  |  |
| AC-8ff6d9c1 | this.btnExcelImport.Click | FP02600_Prod_Result_WO_MES.cs:2992 |  | DATA_OP | rowPopup.ColumnTitle["WORK_ORDER_ID"] | "WO" | 행/컬럼 값 대입 |  |  |  |
| AC-c81f1c56 | this.btnExcelImport.Click | FP02600_Prod_Result_WO_MES.cs:2993 |  | DATA_OP | rowPopup.ColumnTitle["WORK_ORDER_SPL_ID"] | "Schedule Order" | 행/컬럼 값 대입 |  |  |  |
| AC-d612b5c4 | this.btnExcelImport.Click | FP02600_Prod_Result_WO_MES.cs:2994 |  | DATA_OP | rowPopup.ColumnTitle["ORDER_TYPE"] | "Order Type" | 행/컬럼 값 대입 |  |  |  |
| AC-37a4290e | this.btnExcelImport.Click | FP02600_Prod_Result_WO_MES.cs:2995 |  | DATA_OP | rowPopup.ColumnTitle["ITEM_ID"] | "Material" | 행/컬럼 값 대입 |  |  |  |
| AC-a9de3ae3 | this.btnExcelImport.Click | FP02600_Prod_Result_WO_MES.cs:2996 |  | DATA_OP | rowPopup.ColumnTitle["NICK_NAME"] | "Nick Name" | 행/컬럼 값 대입 |  |  |  |
| AC-0b8d53fc | this.btnExcelImport.Click | FP02600_Prod_Result_WO_MES.cs:2997 |  | DATA_OP | rowPopup.ColumnTitle["TOP_ITEM_ID"] | "TOP Material ID" | 행/컬럼 값 대입 |  |  |  |
| AC-41d55592 | this.btnExcelImport.Click | FP02600_Prod_Result_WO_MES.cs:2999 |  | DATA_OP | rowPopup.ColumnTitle["OPERATION_ID"] | "Operation" | 행/컬럼 값 대입 |  |  |  |
| AC-d72b6edf | this.btnExcelImport.Click | FP02600_Prod_Result_WO_MES.cs:3000 |  | DATA_OP | rowPopup.ColumnTitle["LINE_ID"] | "Line" | 행/컬럼 값 대입 |  |  |  |
| AC-d43deb9c | this.btnExcelImport.Click | FP02600_Prod_Result_WO_MES.cs:3001 |  | DATA_OP | rowPopup.ColumnTitle["EQUIPMENT_ID"] | "Equipment" | 행/컬럼 값 대입 |  |  |  |
| AC-9c340c2d | this.btnExcelImport.Click | FP02600_Prod_Result_WO_MES.cs:3002 |  | DATA_OP | rowPopup.ColumnTitle["PLAN_DATE"] | "Plan Date" | 행/컬럼 값 대입 |  |  |  |
| AC-1c43de06 | this.btnExcelImport.Click | FP02600_Prod_Result_WO_MES.cs:3004 |  | DATA_OP | rowPopup.ColumnTitle["PLAN_QTY"] | "QTY" | 행/컬럼 값 대입 |  |  |  |
| AC-bbc290ed | this.btnExcelImport.Click | FP02600_Prod_Result_WO_MES.cs:3005 |  | DATA_OP | rowPopup.ColumnTitle["PLAN_START_TIME"] | "Start Time" | 행/컬럼 값 대입 |  |  |  |
| AC-403e79f5 | this.btnExcelImport.Click | FP02600_Prod_Result_WO_MES.cs:3006 |  | DATA_OP | rowPopup.ColumnTitle["PLAN_END_TIME"] | "End Time" | 행/컬럼 값 대입 |  |  |  |
| AC-ebc1962f | this.btnExcelImport.Click | FP02600_Prod_Result_WO_MES.cs:3008 |  | DATA_OP | rowPopup.ColumnTitle["ACTUAL_GOOD_QTY"] | "Good QTY" | 행/컬럼 값 대입 |  |  |  |
| AC-9b76ec71 | this.btnExcelImport.Click | FP02600_Prod_Result_WO_MES.cs:3009 |  | DATA_OP | rowPopup.ColumnTitle["ACTUAL_SCRAP_QTY"] | "Scrap QTY" | 행/컬럼 값 대입 |  |  |  |
| AC-78c69729 | this.btnExcelImport.Click | FP02600_Prod_Result_WO_MES.cs:3010 |  | DATA_OP | rowPopup.ColumnTitle["ACTUAL_QTY"] | "Actual QTY" | 행/컬럼 값 대입 |  |  |  |
| AC-1c5c13bf | this.btnExcelImport.Click | FP02600_Prod_Result_WO_MES.cs:3011 |  | DATA_OP | rowPopup.ColumnTitle["ACTUAL_START_TIME"] | "Start Time" | 행/컬럼 값 대입 |  |  |  |
| AC-10771646 | this.btnExcelImport.Click | FP02600_Prod_Result_WO_MES.cs:3012 |  | DATA_OP | rowPopup.ColumnTitle["ACTUAL_END_TIME"] | "End Time" | 행/컬럼 값 대입 |  |  |  |
| AC-01671a5c | this.btnExcelImport.Click | FP02600_Prod_Result_WO_MES.cs:3014 |  | DATA_OP | rowPopup.ColumnTitle["RUNNING_FLAG"] | "Running Flag" | 행/컬럼 값 대입 |  |  |  |
| AC-ae45bcd6 | this.btnExcelImport.Click | FP02600_Prod_Result_WO_MES.cs:3015 |  | DATA_OP | rowPopup.ColumnTitle["WO_STATUS"] | "WO STATUS" | 행/컬럼 값 대입 |  |  |  |
| AC-fb63f538 | this.btnExcelImport.Click | FP02600_Prod_Result_WO_MES.cs:3016 |  | DATA_OP | rowPopup.ColumnTitle["MESSAGE"] | "Message" | 행/컬럼 값 대입 |  |  |  |
| AC-7357a0cd | this.btnExcelImport.Click | FP02600_Prod_Result_WO_MES.cs:3018 |  | DATA_OP | rowPopup.ColumnWidth["Company_id"] | 90 | 행/컬럼 값 대입 |  |  |  |
| AC-9b813641 | this.btnExcelImport.Click | FP02600_Prod_Result_WO_MES.cs:3019 |  | DATA_OP | rowPopup.ColumnWidth["DIVISION_ID"] | 90 | 행/컬럼 값 대입 |  |  |  |
| AC-f5897bbe | this.btnExcelImport.Click | FP02600_Prod_Result_WO_MES.cs:3020 |  | DATA_OP | rowPopup.ColumnWidth["SITE_ID"] | 90 | 행/컬럼 값 대입 |  |  |  |
| AC-e97df702 | this.btnExcelImport.Click | FP02600_Prod_Result_WO_MES.cs:3021 |  | DATA_OP | rowPopup.ColumnWidth["PLANT_ID"] | 90 | 행/컬럼 값 대입 |  |  |  |
| AC-4d140ce7 | this.btnExcelImport.Click | FP02600_Prod_Result_WO_MES.cs:3022 |  | DATA_OP | rowPopup.ColumnWidth["FACTORY_ID"] | 90 | 행/컬럼 값 대입 |  |  |  |
| AC-10d69c2e | this.btnExcelImport.Click | FP02600_Prod_Result_WO_MES.cs:3023 |  | DATA_OP | rowPopup.ColumnWidth["CUTOFF_DATE"] | 100 | 행/컬럼 값 대입 |  |  |  |
| AC-d6b4cbd5 | this.btnExcelImport.Click | FP02600_Prod_Result_WO_MES.cs:3024 |  | DATA_OP | rowPopup.ColumnWidth["WORK_ORDER_SPL_ID"] | 120 | 행/컬럼 값 대입 |  |  |  |
| AC-152cd56c | this.btnExcelImport.Click | FP02600_Prod_Result_WO_MES.cs:3025 |  | DATA_OP | rowPopup.ColumnWidth["WORK_ORDER_ID"] | 100 | 행/컬럼 값 대입 |  |  |  |
| AC-496e9306 | this.btnExcelImport.Click | FP02600_Prod_Result_WO_MES.cs:3026 |  | DATA_OP | rowPopup.ColumnWidth["ORDER_TYPE"] | 70 | 행/컬럼 값 대입 |  |  |  |
| AC-9630a213 | this.btnExcelImport.Click | FP02600_Prod_Result_WO_MES.cs:3027 |  | DATA_OP | rowPopup.ColumnWidth["ITEM_ID"] | 100 | 행/컬럼 값 대입 |  |  |  |
| AC-108c6933 | this.btnExcelImport.Click | FP02600_Prod_Result_WO_MES.cs:3028 |  | DATA_OP | rowPopup.ColumnWidth["NICK_NAME"] | 100 | 행/컬럼 값 대입 |  |  |  |
| AC-5c359db9 | this.btnExcelImport.Click | FP02600_Prod_Result_WO_MES.cs:3029 |  | DATA_OP | rowPopup.ColumnWidth["TOP_ITEM_ID"] | 100 | 행/컬럼 값 대입 |  |  |  |
| AC-4e33f67c | this.btnExcelImport.Click | FP02600_Prod_Result_WO_MES.cs:3031 |  | DATA_OP | rowPopup.ColumnWidth["OPERATION_ID"] | 100 | 행/컬럼 값 대입 |  |  |  |
| AC-4984c525 | this.btnExcelImport.Click | FP02600_Prod_Result_WO_MES.cs:3032 |  | DATA_OP | rowPopup.ColumnWidth["LINE_ID"] | 100 | 행/컬럼 값 대입 |  |  |  |
| AC-63168175 | this.btnExcelImport.Click | FP02600_Prod_Result_WO_MES.cs:3033 |  | DATA_OP | rowPopup.ColumnWidth["EQUIPMENT_ID"] | 100 | 행/컬럼 값 대입 |  |  |  |
| AC-79404005 | this.btnExcelImport.Click | FP02600_Prod_Result_WO_MES.cs:3034 |  | DATA_OP | rowPopup.ColumnWidth["PLAN_DATE"] | 100 | 행/컬럼 값 대입 |  |  |  |
| AC-d70daac3 | this.btnExcelImport.Click | FP02600_Prod_Result_WO_MES.cs:3036 |  | DATA_OP | rowPopup.ColumnWidth["PLAN_QTY"] | 100 | 행/컬럼 값 대입 |  |  |  |
| AC-eddd12c2 | this.btnExcelImport.Click | FP02600_Prod_Result_WO_MES.cs:3037 |  | DATA_OP | rowPopup.ColumnWidth["PLAN_START_TIME"] | 150 | 행/컬럼 값 대입 |  |  |  |
| AC-de3a9ebe | this.btnExcelImport.Click | FP02600_Prod_Result_WO_MES.cs:3038 |  | DATA_OP | rowPopup.ColumnWidth["PLAN_END_TIME"] | 150 | 행/컬럼 값 대입 |  |  |  |
| AC-dc37f2cc | this.btnExcelImport.Click | FP02600_Prod_Result_WO_MES.cs:3040 |  | DATA_OP | rowPopup.ColumnWidth["ACTUAL_GOOD_QTY"] | 100 | 행/컬럼 값 대입 |  |  |  |
| AC-22ebf4f0 | this.btnExcelImport.Click | FP02600_Prod_Result_WO_MES.cs:3041 |  | DATA_OP | rowPopup.ColumnWidth["ACTUAL_SCRAP_QTY"] | 100 | 행/컬럼 값 대입 |  |  |  |
| AC-5aba3073 | this.btnExcelImport.Click | FP02600_Prod_Result_WO_MES.cs:3042 |  | DATA_OP | rowPopup.ColumnWidth["ACTUAL_QTY"] | 100 | 행/컬럼 값 대입 |  |  |  |
| AC-7f1cda5e | this.btnExcelImport.Click | FP02600_Prod_Result_WO_MES.cs:3043 |  | DATA_OP | rowPopup.ColumnWidth["ACTUAL_START_TIME"] | 150 | 행/컬럼 값 대입 |  |  |  |
| AC-36ba1d16 | this.btnExcelImport.Click | FP02600_Prod_Result_WO_MES.cs:3044 |  | DATA_OP | rowPopup.ColumnWidth["ACTUAL_END_TIME"] | 150 | 행/컬럼 값 대입 |  |  |  |
| AC-195cdbda | this.btnExcelImport.Click | FP02600_Prod_Result_WO_MES.cs:3046 |  | DATA_OP | rowPopup.ColumnWidth["RUNNING_FLAG"] | 100 | 행/컬럼 값 대입 |  |  |  |
| AC-d3f12679 | this.btnExcelImport.Click | FP02600_Prod_Result_WO_MES.cs:3047 |  | DATA_OP | rowPopup.ColumnWidth["WO_STATUS"] | 100 | 행/컬럼 값 대입 |  |  |  |
| AC-e28a9758 | this.btnExcelImport.Click | FP02600_Prod_Result_WO_MES.cs:3048 |  | DATA_OP | rowPopup.ColumnWidth["MESSAGE"] | 250 | 행/컬럼 값 대입 |  |  |  |
| AC-f8f01e7a | this.btnExcelImport.Click | FP02600_Prod_Result_WO_MES.cs:3074 |  | UI_PROP | rowPopup.DoSearchData | call_Excel_Row_Search | 속성 DoSearchData 설정 |  |  |  |
| AC-54e195f4 | this.btnExcelImport.Click | FP02600_Prod_Result_WO_MES.cs:3076 |  | UI_PROP | rowPopup.DoSaveData | call_Excel_Row_Save | 속성 DoSaveData 설정 |  |  |  |
| AC-89b340e7 | this.btnExcelImport.Click | FP02600_Prod_Result_WO_MES.cs:3077 |  | UI_PROP | rowPopup.DoValidationData | call_Excel_Row_Validation | 속성 DoValidationData 설정 |  |  |  |
| AC-34c9c955 | this.btnExcelImport.Click | FP02600_Prod_Result_WO_MES.cs:3078 |  | UI_PROP | rowPopup.DoImportData | call_Excel_Row_After_Import | 속성 DoImportData 설정 |  |  |  |
| AC-78c7d28a | this.btnExcelImport.Click | FP02600_Prod_Result_WO_MES.cs:3079 |  | POPUP | rowPopup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP02600_Prod_Result_WO_MES.btnSql_Click

진입점: this.btnSql.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4cdbfa20 | this.btnSql.Click | FP02600_Prod_Result_WO_MES.cs:1358 | if (true) | POPUP | new FPC0099_SqlPopup | () | 팝업/폼 생성 |  |  |  |
| AC-a5d30d7c | this.btnSql.Click | FP02600_Prod_Result_WO_MES.cs:1359 | if (true) | UI_PROP | popSql.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-02b2fe15 | this.btnSql.Click | FP02600_Prod_Result_WO_MES.cs:1361 | if (true) | DATA_OP | popSql.Services.Add | ("PR_UI_FP02600_FIND_FP02600") | 데이터 객체 조작/조회 |  |  |  |
| AC-0a3dd1a0 | this.btnSql.Click | FP02600_Prod_Result_WO_MES.cs:1362 | if (true) | POPUP | popSql.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP02600_Prod_Result_WO_MES.call_Excel_Row_After_Import

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bd003152 | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:3388 |  | DATA_OP | data.Tables[0].Columns.SafeAdd | ("_VALID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-da7c6ddd | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:3389 |  | DATA_OP | data.Tables[0].Columns.SafeAdd | ("_MSG", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-4dcbe86b | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:3399 | if (AnyError) | CALL_EXT | DataService.CreateResultDataSet | (false, 0, "Validation Error") | ⚠ 의미 확인 필요 |  |  |  |
| AC-26cad430 | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:3399 | if (AnyError) | RETURN | return DataService.CreateResultDataSet(false, 0, "Validation Error"); |  | 처리 중단/반환 |  |  |  |
| AC-de6b0e74 | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:3401 |  | CALL_EXT | DataService.CreateResultDataSet | (true, 1, "") | ⚠ 의미 확인 필요 |  |  |  |
| AC-fe3f3f47 | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:3401 |  | RETURN | return DataService.CreateResultDataSet(true, 1, ""); |  | 처리 중단/반환 |  |  |  |

## FP02600_Prod_Result_WO_MES.call_Excel_Row_Save

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-42ac2775 | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:3363 | if (popup != null) ▸ try ▸ if (SaveExcelRows(data, popup.Filter, out ref_val) == true) | UI_PROP | popup.validation | ref_val | 속성 validation 설정 |  |  |  |
| AC-8ed0aad9 | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:3364 | if (popup != null) ▸ try ▸ if (SaveExcelRows(data, popup.Filter, out ref_val) == true) | UI_PROP | popup.SaveSuccess | true | 속성 SaveSuccess 설정 |  |  |  |
| AC-c2c4b3a1 | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:3365 | if (popup != null) ▸ try ▸ if (SaveExcelRows(data, popup.Filter, out ref_val) == true) | CALL_EXT | DataService.CreateResultDataSet | (true, 1, "") | ⚠ 의미 확인 필요 |  |  |  |
| AC-83cf69b9 | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:3365 | if (popup != null) ▸ try ▸ if (SaveExcelRows(data, popup.Filter, out ref_val) == true) | RETURN | return DataService.CreateResultDataSet(true, 1, ""); |  | 처리 중단/반환 |  |  |  |
| AC-55212e53 | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:3367 | if (popup != null) ▸ try | UI_PROP | popup.validation | ref_val | 속성 validation 설정 |  |  |  |
| AC-7df3d121 | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:3372 | if (popup != null) ▸ catch ((Exception e)) | CALL_EXT | DataService.CreateResultDataSet | (false, 0, e.Message) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9780c4b5 | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:3372 | if (popup != null) ▸ catch ((Exception e)) | RETURN | return DataService.CreateResultDataSet(false, 0, e.Message); |  | 처리 중단/반환 |  |  |  |
| AC-9984c6d8 | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:3375 |  | CALL_EXT | DataService.CreateResultDataSet | (false, 0, "") | ⚠ 의미 확인 필요 |  |  |  |
| AC-d6f6e8cd | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:3375 |  | RETURN | return DataService.CreateResultDataSet(false, 0, ""); |  | 처리 중단/반환 |  |  |  |

## FP02600_Prod_Result_WO_MES.call_Excel_Row_Search

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-691d5d6c | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:3341 | if (popup != null) | ENDPOINT | DataService.FP_ExecuteProcedure | ("PR_UI_FP02600_FIND_FP02600", popup.Filter) | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-c6ec9c6c | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:3342 | if (popup != null) | RETURN | return m; |  | 처리 중단/반환 |  |  |  |
| AC-57e41638 | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:3345 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP02600_Prod_Result_WO_MES.call_Excel_Row_Validation

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ddf38172 | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:3405 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP02600_Prod_Result_WO_MES.CreateFilterDataSet

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f1a856d2 | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:1395 | if (dsResult == null) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-adf19508 | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:1406 | lambda | DATA_OP | result_row["_MM_"] | false | 행/컬럼 값 대입 |  |  |  |
| AC-6b285201 | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:1407 | lambda | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-ab3517d3 | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:2398 |  | DATA_OP | dsResult.Tables[0].Select | (sExpr) | 데이터 객체 조작/조회 |  |  |  |
| AC-fbbefd55 | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:2401 | for (i < rows.Length) | DATA_OP | rows[i]["_MM_"] | true | 행/컬럼 값 대입 |  |  |  |
| AC-3785fac3 | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:2407 | lambda | DATA_OP | x.Field | ("_MM_") | 데이터 객체 조작/조회 |  |  |  |
| AC-78fcc026 | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:2411 | if (m != null && m.Count() > 0) | DATA_OP | m.CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-daa8e4c1 | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:2414 | if (t != null) | DATA_OP | dsMain.Tables.Add | (t) | 데이터 객체 조작/조회 |  |  |  |
| AC-0d8fd2e0 | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:2416 | else of (t != null) | DATA_OP | dsResult.Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-2135b5d3 | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:2416 | else of (t != null) | RETURN | return dsResult.Clone(); |  | 처리 중단/반환 |  |  |  |
| AC-c03a167f | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:2417 |  | RETURN | return dsMain; |  | 처리 중단/반환 |  |  |  |

## FP02600_Prod_Result_WO_MES.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1059e73d | this.Load | FP02600_Prod_Result_WO_MES.cs:481 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtPlanAmendMA, SpdSheet.shtPlanAmendMA, 2, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-fdbf0e28 | this.Load | FP02600_Prod_Result_WO_MES.cs:482 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, SpdSheet.shtPlanAmendMA) | 화면 필드/플래그 변경 |  |  |  |
| AC-bd48c086 | this.Load | FP02600_Prod_Result_WO_MES.cs:483 |  | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtPlanAmendMA) | 그리드 컬럼/헤더 구성 |  |  |  |

## FP02600_Prod_Result_WO_MES.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f8622a60 | DeleteButton | FP02600_Prod_Result_WO_MES.cs:1138 | if (spdMain != null) | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## FP02600_Prod_Result_WO_MES.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9453d2a4 | Dispose | FP02600_Prod_Result_WO_MES.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP02600_Prod_Result_WO_MES.DrawHeader

진입점: this.Load / this.btnExcelImport.Click [if (rowPopup.SaveSuccess == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try ▸ if (dsMain == null)] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try ▸ if (dsMain == null)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0a7996f3 | this.Load 외 2 | FP02600_Prod_Result_WO_MES.cs:738 |  | FLAG | DayColumnCount | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-37805982 | this.Load 외 2 | FP02600_Prod_Result_WO_MES.cs:742 | if (with_day_part == false) | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 2) | 그리드 재구성/초기화 |  |  |  |
| AC-05a25c93 | this.Load 외 2 | FP02600_Prod_Result_WO_MES.cs:743 | if (with_day_part == false) | GRID_INIT | siMain.ColumnHeaderHeight | (0, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5edf6bad | this.Load 외 2 | FP02600_Prod_Result_WO_MES.cs:744 | if (with_day_part == false) | GRID_INIT | siMain.ColumnHeaderHeight | (1, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6e8f354e | this.Load 외 2 | FP02600_Prod_Result_WO_MES.cs:745 | if (with_day_part == false) | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0808a2ca | this.Load 외 2 | FP02600_Prod_Result_WO_MES.cs:746 | if (with_day_part == false) | FLAG | DayColumnCount | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-5a434daa | this.Load 외 2 | FP02600_Prod_Result_WO_MES.cs:750 | else of (with_day_part == false) | FLAG | calendar | new AmendCalendar() | 화면 필드/플래그 변경 |  |  |  |
| AC-e9c90dae | this.Load 외 2 | FP02600_Prod_Result_WO_MES.cs:751 | else of (with_day_part == false) | UI_PROP | calendar.MonthInfo | monthInfo | 속성 MonthInfo 설정 |  |  |  |
| AC-3de1e941 | this.Load 외 2 | FP02600_Prod_Result_WO_MES.cs:752 | else of (with_day_part == false) | UI_PROP | calendar.WeekInfo | weekInfo | 속성 WeekInfo 설정 |  |  |  |
| AC-d0cae463 | this.Load 외 2 | FP02600_Prod_Result_WO_MES.cs:753 | else of (with_day_part == false) | UI_PROP | calendar.DateMap | dateMap | 속성 DateMap 설정 |  |  |  |
| AC-53ef9de3 | this.Load 외 2 | FP02600_Prod_Result_WO_MES.cs:765 | else of (with_day_part == false) | FLAG | DayColumnCount | calendar.GetColumnCount(use_month, use_week, use_day) | 화면 필드/플래그 변경 |  |  |  |
| AC-05d5cc97 | this.Load 외 2 | FP02600_Prod_Result_WO_MES.cs:766 | else of (with_day_part == false) | CALL_EXT | calendar.GetStartDate | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-2b51292c | this.Load 외 2 | FP02600_Prod_Result_WO_MES.cs:772 | else of (with_day_part == false) ▸ if (sdate != measure.StartDate) | VALUE_SET | measure.StartDate | sdate | 컨트롤 값 설정 |  |  |  |
| AC-cb212a30 | this.Load 외 2 | FP02600_Prod_Result_WO_MES.cs:799 | else of (with_day_part == false) ▸ if (refreshColumn) | CALL_EXT | MeasureService.LoadAmendColumn | (measure, calendar, SpdSheet.PROGID + "_" + SpdSheet.shtPlanAmendMA, appendix) | ⚠ 의미 확인 필요 |  |  |  |
| AC-39706978 | this.Load 외 2 | FP02600_Prod_Result_WO_MES.cs:805 | else of (with_day_part == false) ▸ if (refreshColumn) | CALL_EXT | siMain.SetAmendHeaderColumn_FP | (measure.AmendColumns, calendar, use_month, use_week, use_day, 2, "") | ⚠ 의미 확인 필요 |  |  |  |
| AC-f04b02a6 | this.Load 외 2 | FP02600_Prod_Result_WO_MES.cs:807 | else of (with_day_part == false) ▸ if (refreshColumn) | GRID_INIT | siMain.ColumnHeaderHeight | (0, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9c5f7144 | this.Load 외 2 | FP02600_Prod_Result_WO_MES.cs:808 | else of (with_day_part == false) ▸ if (refreshColumn) | GRID_INIT | siMain.ColumnHeaderHeight | (1, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-902192ab | this.Load 외 2 | FP02600_Prod_Result_WO_MES.cs:809 | else of (with_day_part == false) ▸ if (refreshColumn) | FLAG | last_col | siMain.GetMaxColumnIndex() | 화면 필드/플래그 변경 |  |  |  |
| AC-ab411aa7 | this.Load 외 2 | FP02600_Prod_Result_WO_MES.cs:811 | else of (with_day_part == false) ▸ if (refreshColumn) | GRID_SET | siMain.ActiveSheet.FrozenColumnCount | last_col - DayColumnCount + 1 | 그리드 속성/값 설정 |  |  |  |
| AC-3f635c74 | this.Load 외 2 | FP02600_Prod_Result_WO_MES.cs:813 | else of (with_day_part == false) ▸ if (refreshColumn) | UI_PROP | siMain.MergeVerticalAlignment | CellVerticalAlignment.Top | 속성 MergeVerticalAlignment 설정 |  |  |  |
| AC-938d431e | this.Load 외 2 | FP02600_Prod_Result_WO_MES.cs:814 | else of (with_day_part == false) ▸ if (refreshColumn) | CALL_EXT | siMain.SetRightMerge | (siMain.ActiveSheet.FrozenColumnCount) | ⚠ 의미 확인 필요 |  |  |  |

## FP02600_Prod_Result_WO_MES.DrawSheet

진입점: this.btnExcelImport.Click [if (rowPopup.SaveSuccess == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try ▸ else of (dsMain == null)] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try ▸ else of (dsMain == null)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c1b2b240 | this.btnExcelImport.Click [if (rowPopup.SaveSuccess == true)… 외 1 | FP02600_Prod_Result_WO_MES.cs:823 | if (!siMain.SpreadObject.IsLayoutSuspended) | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-6c79dea8 | this.btnExcelImport.Click [if (rowPopup.SaveSuccess == true)… 외 1 | FP02600_Prod_Result_WO_MES.cs:826 | if (!in_Dataset.Good()) | CALL_EXT | siMain.EditQuery | (in_Dataset) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d7c44aee | this.btnExcelImport.Click [if (rowPopup.SaveSuccess == true)… 외 1 | FP02600_Prod_Result_WO_MES.cs:827 | if (!in_Dataset.Good()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c952b7b4 | this.btnExcelImport.Click [if (rowPopup.SaveSuccess == true)… 외 1 | FP02600_Prod_Result_WO_MES.cs:834 |  | CALL_EXT | siMain.EditQuery | (in_Dataset) | ⚠ 의미 확인 필요 |  |  |  |
| AC-75cfa6fe | this.btnExcelImport.Click [if (rowPopup.SaveSuccess == true)… 외 1 | FP02600_Prod_Result_WO_MES.cs:836 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP02600_Prod_Result_WO_MES.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ac5dd6e4 | EditButton | FP02600_Prod_Result_WO_MES.cs:1146 | if (spdMain != null) | MESSAGE | MessageBox.Show | ("You already in edit mode.\r\n(In Plan Amend screen,You always in edit mode while you hav… | 메시지 표시 |  |  |  |
| AC-12f2d051 | EditButton | FP02600_Prod_Result_WO_MES.cs:1148 |  | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtPlanAmendMA, false) | 그리드 편집 잠금/해제 |  |  |  |

## FP02600_Prod_Result_WO_MES.ExcelButton

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7451aa98 | ExcelButton | FP02600_Prod_Result_WO_MES.cs:2483 |  | POPUP | new FPC0109_ExcelSelect_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-1eaeee1d | ExcelButton | FP02600_Prod_Result_WO_MES.cs:2484 |  | VALUE_SET | select_popup.Text | "SELECT Excel Export Option" | 컨트롤 값 설정 |  |  |  |
| AC-59402478 | ExcelButton | FP02600_Prod_Result_WO_MES.cs:2486 |  | POPUP | select_popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-54308999 | ExcelButton | FP02600_Prod_Result_WO_MES.cs:2490 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.Merge | select_popup.MergeSelection | 속성 Merge 설정 |  |  |  |
| AC-4fcde3ed | ExcelButton | FP02600_Prod_Result_WO_MES.cs:2491 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.Border | select_popup.LineSelection | 속성 Border 설정 |  |  |  |
| AC-00b292ee | ExcelButton | FP02600_Prod_Result_WO_MES.cs:2492 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.AmendZeroOption | select_popup.ZeroSelection | 속성 AmendZeroOption 설정 |  |  |  |
| AC-621c21da | ExcelButton | FP02600_Prod_Result_WO_MES.cs:2495 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.AheadZeroOption | ZeroOption.HideZero | 속성 AheadZeroOption 설정 |  |  |  |
| AC-3032978f | ExcelButton | FP02600_Prod_Result_WO_MES.cs:2496 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.AmendNullToZero | true | 속성 AmendNullToZero 설정 |  |  |  |
| AC-2492baec | ExcelButton | FP02600_Prod_Result_WO_MES.cs:2497 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.AheadNullToZero | false | 속성 AheadNullToZero 설정 |  |  |  |
| AC-22efbc79 | ExcelButton | FP02600_Prod_Result_WO_MES.cs:2499 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.UserName | UserInfo.UserId | 속성 UserName 설정 |  |  |  |
| AC-2adb0e03 | ExcelButton | FP02600_Prod_Result_WO_MES.cs:2500 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.FileName | sFileName | 속성 FileName 설정 |  |  |  |
| AC-071fe925 | ExcelButton | FP02600_Prod_Result_WO_MES.cs:2503 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.AmendDecimalFormat | "#,##0.##########;[red]-#,##0.##########" | 속성 AmendDecimalFormat 설정 |  |  |  |
| AC-e99ab496 | ExcelButton | FP02600_Prod_Result_WO_MES.cs:2515 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ try | CALL_EXT | SimplexelService.ExportFpSpread | (fps, exportOption) | ⚠ 의미 확인 필요 |  |  |  |
| AC-544315eb | ExcelButton | FP02600_Prod_Result_WO_MES.cs:2519 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-260ae2e6 | ExcelButton | FP02600_Prod_Result_WO_MES.cs:2523 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP02600_Prod_Result_WO_MES.FindMainData

진입점: popSql.OnSql [if (programID == "PR_UI_FP02600_FIND_FP02600")] / this.btnExcelImport.Click [if (rowPopup.SaveSuccess == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-012a972d | popSql.OnSql [if (programID == "PR_UI_FP02600_FIND_FP02600")… 외 2 | FP02600_Prod_Result_WO_MES.cs:2859 | try | ENDPOINT | DataService.FP_ExecuteProcedure | ("PR_UI_FP02600_FIND_FP02600", Filter, p_sys_type) | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-2d02f6e2 | popSql.OnSql [if (programID == "PR_UI_FP02600_FIND_FP02600")… 외 2 | FP02600_Prod_Result_WO_MES.cs:2867 | try | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |
| AC-e5338e7b | popSql.OnSql [if (programID == "PR_UI_FP02600_FIND_FP02600")… 외 2 | FP02600_Prod_Result_WO_MES.cs:2873 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |

## FP02600_Prod_Result_WO_MES.FindSubTotalColorStart

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e6708c67 | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:867 |  | RETURN | return 0; |  | 처리 중단/반환 |  |  |  |

## FP02600_Prod_Result_WO_MES.FindTotalColorStart

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ff24324d | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:855 | if (op > -1) | RETURN | return op + 1; |  | 처리 중단/반환 |  |  |  |
| AC-2bafcd83 | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:862 |  | RETURN | return start + 1; |  | 처리 중단/반환 |  |  |  |

## FP02600_Prod_Result_WO_MES.FindTotalValue

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b25bb0c4 | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:2809 | try ▸ if (GetFilter("INSTANCE_ID") == "") | THROW | throw new Exception("Instance ID required"); |  | 예외 발생 |  |  |  |
| AC-02aa3c2f | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:2811 | try | ENDPOINT | DataService.FP_ExecuteProcedure | ("PR_UI_FP00599_FIND_TOTALVALUE", Filter, p_sys_type) | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-34654b31 | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:2812 | try | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |
| AC-2f18c761 | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:2818 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |

## FP02600_Prod_Result_WO_MES.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-de0007a6 | this.Load | FP02600_Prod_Result_WO_MES.cs:209 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP02600_Prod_Result_WO_MES.GetDivision

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a74c525d | this.Load [try] | FP02600_Prod_Result_WO_MES.cs:2562 |  | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-3bdf3106 | this.Load [try] | FP02600_Prod_Result_WO_MES.cs:2563 |  | FLAG | dtDivision | DataService.GetInnerTable("DIVISION_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-ae0fc76f | this.Load [try] | FP02600_Prod_Result_WO_MES.cs:2563 |  | COMBO_DATA | DataService.GetInnerTable | ("DIVISION_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-c535c6b9 | this.Load [try] | FP02600_Prod_Result_WO_MES.cs:2564 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, mcbo_division, false) | 목록 컨트롤 재구성 |  |  |  |

## FP02600_Prod_Result_WO_MES.GetFactory

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a20a0731 | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:2636 |  | FLAG | dtFactoryAmend | Data_FP.Common_FP(Data_FP.Type.FACTORY_CODE, false, CurrentUser, _sNonAuth, _sSaveAuth , F… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY_CODE] | 화면 필드/플래그 변경 |  |  |  |
| AC-33a64a87 | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:2636 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.FACTORY_CODE, false, CurrentUser, _sNonAuth, _sSaveAuth , Filter["INSTANCE_I… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY_CODE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-97be7475 | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:2641 |  | LIST_REBIND | clsCtrl.setListBox | (dtFactoryAmend, mcbo_factory, false) | 목록 컨트롤 재구성 |  |  |  |

## FP02600_Prod_Result_WO_MES.GetFilter

진입점: this.btnExcelImport.Click [if (rowPopup.SaveSuccess == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9e67454b | this.btnExcelImport.Click [if (rowPopup.SaveSuccess == true)… 외 2 | FP02600_Prod_Result_WO_MES.cs:2557 |  | RETURN | return Filter[key]; |  | 처리 중단/반환 |  |  |  |

## FP02600_Prod_Result_WO_MES.GetLine

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-47c3fb9a | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:2670 | try | FLAG | dtLine | Data_FP.Common_FP(Data_FP.Type.LINE, false, UserInfoContext.Current.UserId, _sNonAuth, _sS… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=LINE] | 화면 필드/플래그 변경 |  |  |  |
| AC-6dc4c093 | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:2670 | try | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.LINE, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth, "", "", … ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=LINE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-e4f644a5 | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:2673 | try | LIST_REBIND | clsCtrl.setListBox | (dtLine, mcbo_line, false) | 목록 컨트롤 재구성 |  |  |  |
| AC-f262c182 | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:2679 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |

## FP02600_Prod_Result_WO_MES.GetMppWpp

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5b98f553 | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:1293 | if (!ds.Good()) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-595b7889 | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:1303 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-0bb8c1bd | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:1304 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("COMPANY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-30414189 | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:1305 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-4c825462 | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:1306 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("PLANT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-eab8e2f9 | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:1307 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-2a177631 | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:1308 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("PRODUCTION_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-1925ed15 | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:1309 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("MARKET") | 데이터 객체 조작/조회 |  |  |  |
| AC-302378a8 | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:1310 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("FACTORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-3800c493 | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:1311 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("LINE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-16199fb9 | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:1312 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("ELECTRODE_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-7eb708f4 | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:1313 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("LOCATION") | 데이터 객체 조작/조회 |  |  |  |
| AC-92c7f294 | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:1314 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("TOP_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-5238db51 | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:1315 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-b846bcd2 | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:1301 | if (clicked_row != null) ▸ lambda | RETURN | return ( x.Field<string>("DIVISION_ID") == clicked_row["DIVISION_ID"].ToString()… |  | 처리 중단/반환 |  |  |  |
| AC-101a33be | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:1331 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "M_OUT": ▸ if (cell_uom == "CELL") | DATA_OP | ret[order_M_OUT_CELL] | related_row | 행/컬럼 값 대입 |  |  |  |
| AC-c7a75aaa | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:1334 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "M_OUT": ▸ else of (cell_uom == "CELL"… | DATA_OP | ret[order_M_OUT] | related_row | 행/컬럼 값 대입 |  |  |  |
| AC-12d593cb | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:1339 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "W_OUT": ▸ if (cell_uom == "CELL") | DATA_OP | ret[order_W_OUT_CELL] | related_row | 행/컬럼 값 대입 |  |  |  |
| AC-b1599226 | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:1341 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "W_OUT": ▸ else of (cell_uom == "CELL"… | DATA_OP | ret[order_W_OUT] | related_row | 행/컬럼 값 대입 |  |  |  |
| AC-ad4e58ea | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:1346 |  | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |

## FP02600_Prod_Result_WO_MES.GetOperation

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5ac0169a | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:2655 |  | FLAG | dtOperation | Data_FP.Common_FP(Data_FP.Type.OPERATION, false, UserInfoContext.Current.UserId, _sNonAuth… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=OPERATION] | 화면 필드/플래그 변경 |  |  |  |
| AC-36c680b6 | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:2655 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.OPERATION, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth, "",… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=OPERATION] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ca54ef54 | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:2658 |  | LIST_REBIND | clsCtrl.setListBox | (dtOperation, mcbo_operation, false) | 목록 컨트롤 재구성 |  |  |  |

## FP02600_Prod_Result_WO_MES.GetPlant

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-996258c3 | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:2627 |  | FLAG | dtPlant | Data_FP.Common_FP(Data_FP.Type.PLANT, false, CurrentUser, _sNonAuth, _sSaveAuth , Filter["… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 화면 필드/플래그 변경 |  |  |  |
| AC-746499d2 | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:2627 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.PLANT, false, CurrentUser, _sNonAuth, _sSaveAuth , Filter["INSTANCE_ID"], nu… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c60e6bbd | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:2629 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlant, mcbo_plant, false) | 목록 컨트롤 재구성 |  |  |  |

## FP02600_Prod_Result_WO_MES.GetSite

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0e1ac467 | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:2620 |  | FLAG | dtSite | Data_FP.Common_FP(Data_FP.Type.SITE, false, CurrentUser, _sNonAuth, _sSaveAuth , Filter["I… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 화면 필드/플래그 변경 |  |  |  |
| AC-48216930 | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:2620 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.SITE, false, CurrentUser, _sNonAuth, _sSaveAuth , Filter["INSTANCE_ID"], nul… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-21e176d4 | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:2622 |  | LIST_REBIND | clsCtrl.setListBox | (dtSite, mcbo_site, false) | 목록 컨트롤 재구성 |  |  |  |

## FP02600_Prod_Result_WO_MES.gfn_Msg

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-33bd91e0 | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:2693 |  | MESSAGE | MessageBox.Show | (message, title) | 메시지 표시 |  |  |  |

## FP02600_Prod_Result_WO_MES.GoDrawCellColor

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ddda59b8 | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:1154 | if (string.IsNullOrWhiteSpace(color_appendix)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-90392d4f | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:1189 | if (current_src != null && calendar != null) ▸ if (day_measure != null && day_measure.On) ▸ if (calendar.Days != null) ▸ foreach (var day_it… | CALL_EXT | FPExtensions.ColorFromName | (strColor) | ⚠ 의미 확인 필요 |  |  |  |
| AC-4e59bac1 | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:1190 | if (current_src != null && calendar != null) ▸ if (day_measure != null && day_measure.On) ▸ if (calendar.Days != null) ▸ foreach (var day_it… | GRID_STYLE | siMain.SetFGColor3 | (rowindex, index, rowindex, index, color) | 그리드 표시 설정 |  |  |  |
| AC-99cab2a4 | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:1194 | if (current_src != null && calendar != null) ▸ if (day_measure != null && day_measure.On) ▸ if (calendar.Days != null) ▸ foreach (var day_it… | CALL_EXT | FPExtensions.ColorFromName | (bgColor) | ⚠ 의미 확인 필요 |  |  |  |
| AC-7b18ae01 | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:1195 | if (current_src != null && calendar != null) ▸ if (day_measure != null && day_measure.On) ▸ if (calendar.Days != null) ▸ foreach (var day_it… | GRID_STYLE | siMain.SetBGColor3 | (rowindex, index, rowindex, index, bg) | 그리드 표시 설정 |  |  |  |
| AC-d7e36720 | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:1224 | if (current_src != null && calendar != null) ▸ if (week_measure != null && week_measure.On) ▸ if (calendar.Weeks != null) ▸ foreach (var day… | CALL_EXT | Color.FromName | (strColor) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d4eb5964 | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:1225 | if (current_src != null && calendar != null) ▸ if (week_measure != null && week_measure.On) ▸ if (calendar.Weeks != null) ▸ foreach (var day… | GRID_STYLE | siMain.SetFGColor3 | (rowindex, index, rowindex, index, color) | 그리드 표시 설정 |  |  |  |
| AC-fbacfacc | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:1254 | if (current_src != null && calendar != null) ▸ if (month_measure != null && month_measure.On) ▸ if (calendar.Months != null) ▸ foreach (var … | CALL_EXT | Color.FromName | (strColor) | ⚠ 의미 확인 필요 |  |  |  |
| AC-4a3f3f42 | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:1255 | if (current_src != null && calendar != null) ▸ if (month_measure != null && month_measure.On) ▸ if (calendar.Months != null) ▸ foreach (var … | GRID_STYLE | siMain.SetFGColor3 | (rowindex, index, rowindex, index, color) | 그리드 표시 설정 |  |  |  |

## FP02600_Prod_Result_WO_MES.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e8db6ae4 | this.Load | FP02600_Prod_Result_WO_MES.cs:234 | try | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-5cb331ef | this.Load | FP02600_Prod_Result_WO_MES.cs:240 | try | FLAG | _sNonAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-810f3cf1 | this.Load | FP02600_Prod_Result_WO_MES.cs:241 | try | FLAG | _sSaveAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-1ff3334c | this.Load | FP02600_Prod_Result_WO_MES.cs:251 | try | VALUE_SET | sCalendar_planday.DateTime | DateTime.Now | 컨트롤 값 설정 |  |  |  |
| AC-35b4252d | this.Load | FP02600_Prod_Result_WO_MES.cs:252 | try | DATA_OP | Filter["START_DATE"] | sCalendar_planday.DateTime.ToString("yyyyMMdd", enUS) | 행/컬럼 값 대입 |  |  |  |
| AC-aa8f7596 | this.Load | FP02600_Prod_Result_WO_MES.cs:258 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |

## FP02600_Prod_Result_WO_MES.InitEvent

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c3e873cd | this.Load | FP02600_Prod_Result_WO_MES.cs:367 |  | UI_PROP | mcbo_line.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-4edfebf4 | this.Load | FP02600_Prod_Result_WO_MES.cs:368 |  | UI_PROP | mcbo_division.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-2b2fbf2d | this.Load | FP02600_Prod_Result_WO_MES.cs:370 |  | UI_PROP | mcbo_operation.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-3ba1bdaa | this.Load | FP02600_Prod_Result_WO_MES.cs:371 |  | UI_PROP | mcbo_factory.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-babe0001 | this.Load | FP02600_Prod_Result_WO_MES.cs:372 |  | UI_PROP | mcbo_plant.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-f3c19bc8 | this.Load | FP02600_Prod_Result_WO_MES.cs:374 |  | UI_PROP | mcbo_site.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |

## FP02600_Prod_Result_WO_MES.InitSpread

진입점: this.Load / this.btnExcelImport.Click [if (rowPopup.SaveSuccess == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try ▸ if (dsMain == null) ▸ else of (with_day_part == false) ▸ if (refreshColumn)] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try ▸ if (dsMain == null) ▸ else of (with_day_part == false) ▸ if (refreshColumn)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-236ffe5d | this.Load 외 2 | FP02600_Prod_Result_WO_MES.cs:496 | try | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a1a3cc2f | this.Load 외 2 | FP02600_Prod_Result_WO_MES.cs:497 | try | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtPlanAmendMA) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-c1ef6f54 | this.Load 외 2 | FP02600_Prod_Result_WO_MES.cs:499 | try | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtPlanAmendMA, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-1a683d4e | this.Load 외 2 | FP02600_Prod_Result_WO_MES.cs:503 | catch ((Exception ex)) | THROW | throw ex; |  | 예외 발생 |  |  |  |

## FP02600_Prod_Result_WO_MES.IsEmpty

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-185c4ceb | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:3099 | if (value == null) | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-da35089e | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:3101 | if (value is string && string.IsNullOrWhiteSpace((string)value)) | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-2ad5ed0d | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:3103 | if (value is DBNull) | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-a48e5e49 | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:3104 |  | RETURN | return false; |  | 처리 중단/반환 |  |  |  |

## FP02600_Prod_Result_WO_MES.IsNumber

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e1acff0e | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:3109 | if (value == null) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-ec3d4698 | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:3111 | if (value is decimal) | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-711d52ea | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:3113 | if (value is double) | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-bdf3a7ed | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:3115 | if (value is Int16) | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-386c6151 | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:3117 | if (value is Int32) | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-79268e26 | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:3119 | if (value is Int64) | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-fc502cdc | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:3121 | if (value is float) | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-ecc14387 | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:3125 | if (value is string) ▸ if (string.IsNullOrWhiteSpace((string)value)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-29b29bf0 | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:3128 | if (value is string) | RETURN | return result; |  | 처리 중단/반환 |  |  |  |
| AC-31ec254b | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:3130 |  | RETURN | return false; |  | 처리 중단/반환 |  |  |  |

## FP02600_Prod_Result_WO_MES.lfn_settingValid

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1be5b0fb | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:3152 | foreach (KeyValuePair<string, AmendDate> each_day in calendar.Days) ▸ if (aDate != null) | DATA_OP | row.Table.Columns.Contains | (sQtyCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-d89f325d | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:3159 | foreach (KeyValuePair<string, AmendDate> each_day in calendar.Days) ▸ if (aDate != null) ▸ if (IsEmpty(row[sQtyCol]) && IsEmpty(row[sSeqCol]… | DATA_OP | row[sMCol] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-d8700df4 | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:3160 | foreach (KeyValuePair<string, AmendDate> each_day in calendar.Days) ▸ if (aDate != null) ▸ if (IsEmpty(row[sQtyCol]) && IsEmpty(row[sSeqCol]… | DATA_OP | row[sCellCol] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-e372b15a | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:3161 | foreach (KeyValuePair<string, AmendDate> each_day in calendar.Days) ▸ if (aDate != null) ▸ if (IsEmpty(row[sQtyCol]) && IsEmpty(row[sSeqCol]… | DATA_OP | row[sJRCol] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-26bceb9d | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:3162 | foreach (KeyValuePair<string, AmendDate> each_day in calendar.Days) ▸ if (aDate != null) ▸ if (IsEmpty(row[sQtyCol]) && IsEmpty(row[sSeqCol]… | DATA_OP | row[sQtyCol] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-63c9cb40 | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:3163 | foreach (KeyValuePair<string, AmendDate> each_day in calendar.Days) ▸ if (aDate != null) ▸ if (IsEmpty(row[sQtyCol]) && IsEmpty(row[sSeqCol]… | DATA_OP | row[sSeqCol] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-795d0bcf | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:3227 | foreach (KeyValuePair<string, AmendDate> each_day in calendar.Days) ▸ if (aDate != null) ▸ else of (IsEmpty(row[sQtyCol]) && IsEmpty(row[sSe… | DATA_OP | row[sSeqCol] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-e5869c08 | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:3239 | if (!string.IsNullOrWhiteSpace(total_message)) | DATA_OP | row["_MSG"] | total_message.Substring(1) | 행/컬럼 값 대입 |  |  |  |
| AC-d38b73e8 | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:3240 | if (!string.IsNullOrWhiteSpace(total_message)) | DATA_OP | row["MESSAGE"] | total_message.Substring(1) | 행/컬럼 값 대입 |  |  |  |
| AC-82f527d3 | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:3243 | if (!valid) | DATA_OP | row["_VALID"] | "N" | 행/컬럼 값 대입 |  |  |  |
| AC-0063b24c | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:3245 | else of (!valid) | DATA_OP | row["_VALID"] | "Y" | 행/컬럼 값 대입 |  |  |  |
| AC-d4161ab9 | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:3246 |  | RETURN | return valid; |  | 처리 중단/반환 |  |  |  |

## FP02600_Prod_Result_WO_MES.lfn_settingValidRow

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f92b109a | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:3380 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## FP02600_Prod_Result_WO_MES.MakeMemoBold

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ca61af81 | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:713 | if (calendar != null && dsMainFiltered.Good()) ▸ foreach (var date_item in calendar.Days) ▸ if (date != null) ▸ if (row_count > 0 && colinde… | UI_PROP | acell.Font | new System.Drawing.Font(acell.Font, FontStyle.Bold) | 속성 Font 설정 |  |  |  |
| AC-67990ab7 | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:717 | if (calendar != null && dsMainFiltered.Good()) ▸ foreach (var date_item in calendar.Days) ▸ if (date != null) ▸ if (row_count > 0 && colinde… | UI_PROP | acell.Font | new System.Drawing.Font(siMain.SpreadObject.Font, FontStyle.Bold) | 속성 Font 설정 |  |  |  |

## FP02600_Prod_Result_WO_MES.planday_changed

진입점: sCalendar_planday.ValueChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4e3e0ab4 | sCalendar_planday.ValueChanged | FP02600_Prod_Result_WO_MES.cs:3463 |  | DATA_OP | Filter["PLAN_DATE"] | sCalendar_planday.Value.ToString("yyyyMMdd", enUS) | 행/컬럼 값 대입 |  |  |  |

## FP02600_Prod_Result_WO_MES.RefreshHeadAndBody

진입점: this.btnExcelImport.Click [if (rowPopup.SaveSuccess == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-34e26d4c | this.btnExcelImport.Click [if (rowPopup.SaveSuccess == true)… 외 1 | FP02600_Prod_Result_WO_MES.cs:522 | try | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-e844ab04 | this.btnExcelImport.Click [if (rowPopup.SaveSuccess == true)… 외 1 | FP02600_Prod_Result_WO_MES.cs:538 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-0953ebcb | this.btnExcelImport.Click [if (rowPopup.SaveSuccess == true)… 외 1 | FP02600_Prod_Result_WO_MES.cs:542 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## FP02600_Prod_Result_WO_MES.RefreshSpreadSheet

진입점: this.btnExcelImport.Click [if (rowPopup.SaveSuccess == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fbcd6f48 | this.btnExcelImport.Click [if (rowPopup.SaveSuccess == true)… 외 1 | FP02600_Prod_Result_WO_MES.cs:2472 |  | FLAG | dsMainFiltered | dsMain.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-1d952041 | this.btnExcelImport.Click [if (rowPopup.SaveSuccess == true)… 외 1 | FP02600_Prod_Result_WO_MES.cs:2472 |  | DATA_OP | dsMain.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-0eeb72dd | this.btnExcelImport.Click [if (rowPopup.SaveSuccess == true)… 외 1 | FP02600_Prod_Result_WO_MES.cs:2478 | if (maxColumn > 0) | GRID_LOCK | siMain.LockColumn | (0, maxColumn, true) | 그리드 편집 잠금/해제 |  |  |  |

## FP02600_Prod_Result_WO_MES.RunSqlSource

진입점: popSql.OnSql

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3bcdaba4 | popSql.OnSql | FP02600_Prod_Result_WO_MES.cs:2794 | if (programID == "PR_UI_FP02600_FIND_FP02600") | RETURN | return FindMainData(false); |  | 처리 중단/반환 |  |  |  |
| AC-718df6f7 | popSql.OnSql | FP02600_Prod_Result_WO_MES.cs:2796 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP02600_Prod_Result_WO_MES.Save_Data_Line

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-952fccb2 | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:1350 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP02600_Prod_Result_WO_MES.SaveButton

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-37888846 | SaveButton | FP02600_Prod_Result_WO_MES.cs:1273 | if (Filter["DONOTEDIT"] == "Y") | MESSAGE | MessageBox.Show | ("Release Plan Cannot be edited") | 메시지 표시 |  |  |  |
| AC-09e041fa | SaveButton | FP02600_Prod_Result_WO_MES.cs:1274 | if (Filter["DONOTEDIT"] == "Y") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ab7e0f39 | SaveButton | FP02600_Prod_Result_WO_MES.cs:1277 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d55d6dcd | SaveButton | FP02600_Prod_Result_WO_MES.cs:1278 |  | CALL_BASE | SaveTopRow | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-d127c7a8 | SaveButton | FP02600_Prod_Result_WO_MES.cs:1280 |  | CALL_BASE | RestoreRowRow | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-5b359534 | SaveButton | FP02600_Prod_Result_WO_MES.cs:1282 |  | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtPlanAmendMA, false) | 그리드 편집 잠금/해제 |  |  |  |

## FP02600_Prod_Result_WO_MES.SaveExcelRows

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1bf23d27 | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:3268 |  | DATA_OP | popupFilter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-00a3ff69 | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:3269 |  | ENDPOINT | DataService.FP_ExecuteNonQuery | ("FP02600_PRODUCTION_RESULT_WO_MES", "delete_Excel_buffer", popupFilter.Dictionary, "Plann… ⇒ biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=delete_Excel_buffer] \| FP\P… | 엔드포인트 호출 |  |  |  |
| AC-e3e59be4 | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:3270 |  | DATA_OP | data.Tables[0].Columns.SafeAdd | ("DEMAND_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-b1163049 | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:3271 |  | DATA_OP | data.Tables[0].Columns.SafeAdd | ("PRODUCTION_TYPE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-57aa0e60 | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:3272 |  | DATA_OP | data.Tables[0].Columns.SafeAdd | ("JOB_ORDER", typeof(Decimal)) | 데이터 객체 조작/조회 |  |  |  |
| AC-829ba6eb | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:3274 |  | ENDPOINT | DataService.FP_UpdateBatch | ( "FP02600_PRODUCTION_RESULT_WO_MES", "saveAll_FP02600", data, 0, "Planning") ⇒ biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=saveAll_FP02600] \| FP\Planning\… | 엔드포인트 호출 |  |  |  |
| AC-753bb5a5 | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:3278 |  | CALL_EXT | DataService.ReadResult | (dtRes) | ⚠ 의미 확인 필요 |  |  |  |
| AC-85df7016 | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:3282 | if (!dr.Success) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-fcc00b0d | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:3286 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP02600_PRODUCTION_RESULT_WO_MES", "find_Excel_buffer_validation", popupFilter.Dictionar… ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Excel_buffer_validation] \… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-5fc21b53 | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:3288 |  | COMBO_DATA | data.Good | () | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-32479cd3 | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:3290 | if (data.Good()) | DATA_OP | popupFilter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-ccf16109 | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:3292 | if (data.Good()) | DATA_OP | paramFilter["USER_ID"] | popupFilter["USER_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-6d446d02 | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:3293 | if (data.Good()) | DATA_OP | paramFilter["COMPANY_ID"] | data.Tables[0].Rows[0]["COMPANY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-f0a3bda0 | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:3294 | if (data.Good()) | DATA_OP | paramFilter["DIVISION_ID"] | data.Tables[0].Rows[0]["DIVISION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-920a3f7f | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:3295 | if (data.Good()) | DATA_OP | paramFilter["SITE_ID"] | data.Tables[0].Rows[0]["SITE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-0a37feff | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:3296 | if (data.Good()) | DATA_OP | paramFilter["PLANT_ID"] | data.Tables[0].Rows[0]["PLANT_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-244fadb5 | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:3297 | if (data.Good()) | DATA_OP | paramFilter["FACTORY_ID"] | data.Tables[0].Rows[0]["FACTORY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-365c326d | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:3298 | if (data.Good()) | DATA_OP | paramFilter["CUTOFF_DATE"] | data.Tables[0].Rows[0]["CUTOFF_DATE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-abae720c | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:3299 | if (data.Good()) | DATA_OP | paramFilter["WORK_ORDER_SPL_ID"] | data.Tables[0].Rows[0]["WORK_ORDER_SPL_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-034de566 | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:3300 | if (data.Good()) | DATA_OP | paramFilter["WORK_ORDER_ID"] | data.Tables[0].Rows[0]["WORK_ORDER_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-2653166b | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:3301 | if (data.Good()) | DATA_OP | paramFilter["ORDER_TYPE"] | data.Tables[0].Rows[0]["ORDER_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-404edbac | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:3302 | if (data.Good()) | DATA_OP | paramFilter["ITEM_ID"] | data.Tables[0].Rows[0]["ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-8f80a3c4 | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:3303 | if (data.Good()) | DATA_OP | paramFilter["TOP_ITEM_ID"] | data.Tables[0].Rows[0]["TOP_ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-1512f2ad | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:3304 | if (data.Good()) | DATA_OP | paramFilter["OPERATION_ID"] | data.Tables[0].Rows[0]["OPERATION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-5b2bffb1 | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:3305 | if (data.Good()) | DATA_OP | paramFilter["LINE_ID"] | data.Tables[0].Rows[0]["LINE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-d7546df4 | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:3306 | if (data.Good()) | DATA_OP | paramFilter["WORK_CENTER_ID"] | data.Tables[0].Rows[0]["WORK_CENTER_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-8d86d08f | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:3307 | if (data.Good()) | DATA_OP | paramFilter["EQUIPMENT_ID"] | data.Tables[0].Rows[0]["EQUIPMENT_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-ae2ec8c6 | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:3308 | if (data.Good()) | DATA_OP | paramFilter["PLAN_DATE"] | data.Tables[0].Rows[0]["PLAN_DATE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-62359688 | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:3309 | if (data.Good()) | DATA_OP | paramFilter["PLAN_START_TIME"] | data.Tables[0].Rows[0]["PLAN_START_TIME"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-16dcdd04 | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:3310 | if (data.Good()) | DATA_OP | paramFilter["PLAN_END_TIME"] | data.Tables[0].Rows[0]["PLAN_END_TIME"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-1b2af532 | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:3311 | if (data.Good()) | DATA_OP | paramFilter["PLAN_QTY"] | data.Tables[0].Rows[0]["PLAN_QTY"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-27c36676 | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:3312 | if (data.Good()) | DATA_OP | paramFilter["ACTUAL_START_TIME"] | data.Tables[0].Rows[0]["ACTUAL_START_TIME"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-30a32e2e | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:3313 | if (data.Good()) | DATA_OP | paramFilter["ACTUAL_END_TIME"] | data.Tables[0].Rows[0]["ACTUAL_END_TIME"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-6fe1ca82 | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:3314 | if (data.Good()) | DATA_OP | paramFilter["ACTUAL_QTY"] | data.Tables[0].Rows[0]["ACTUAL_QTY"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-19bd97fc | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:3315 | if (data.Good()) | DATA_OP | paramFilter["ACTUAL_GOOD_QTY"] | data.Tables[0].Rows[0]["ACTUAL_GOOD_QTY"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-f49922a6 | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:3316 | if (data.Good()) | DATA_OP | paramFilter["ACTUAL_SCRAP_QTY"] | data.Tables[0].Rows[0]["ACTUAL_SCRAP_QTY"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-c6bb7c13 | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:3317 | if (data.Good()) | DATA_OP | paramFilter["RUNNING_FLAG"] | data.Tables[0].Rows[0]["RUNNING_FLAG"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-9e8891f5 | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:3318 | if (data.Good()) | DATA_OP | paramFilter["WO_STATUS"] | data.Tables[0].Rows[0]["WO_STATUS"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-eec40382 | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:3320 | if (data.Good()) | ENDPOINT | DataService.FP_ExecuteNonQuery | ("FP02600_PRODUCTION_RESULT_WO_MES", "merge_FP02600", paramFilter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=merge_FP02600] \| FP\Plannin… | 엔드포인트 호출 |  |  |  |
| AC-1e5f12d0 | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:3324 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## FP02600_Prod_Result_WO_MES.SetCalenderColor

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5473b159 | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:617 | if (calendar != null) ▸ if (day_measure != null && day_measure.On) ▸ foreach (var date_item in calendar.Days) ▸ if (date != null) | CALL_EXT | date.isSatureDay | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-3167ad45 | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:621 | if (calendar != null) ▸ if (day_measure != null && day_measure.On) ▸ foreach (var date_item in calendar.Days) ▸ if (date != null) ▸ if (date… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[1, index].ForeColor | System.Drawing.Color.Blue | 그리드 속성/값 설정 |  |  |  |
| AC-7aafcbee | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:623 | if (calendar != null) ▸ if (day_measure != null && day_measure.On) ▸ foreach (var date_item in calendar.Days) ▸ if (date != null) ▸ else of … | CALL_EXT | date.IsSunDay | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-0e2fd04a | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:627 | if (calendar != null) ▸ if (day_measure != null && day_measure.On) ▸ foreach (var date_item in calendar.Days) ▸ if (date != null) ▸ else of … | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[1, index].ForeColor | System.Drawing.Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-85d2d7fc | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:651 | if (calendar != null) ▸ if (week_measure != null && week_measure.On) ▸ foreach (var week_item in calendar.Weeks) ▸ if (week != null) ▸ if (i… | GRID_STYLE | siMain.SetBGColor3 | (0, index, dsMainFiltered.Tables[0].Rows.Count - 1, index, System.Drawing.Color.FromArgb(2… | 그리드 표시 설정 |  |  |  |
| AC-af14df22 | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:666 | if (calendar != null) ▸ if (month_measure != null && month_measure.On) ▸ foreach (var month_item in calendar.Months) ▸ if (month != null) ▸ … | GRID_STYLE | siMain.SetBGColor3 | (0, index, dsMainFiltered.Tables[0].Rows.Count - 1, index, System.Drawing.Color.LightPink) | 그리드 표시 설정 |  |  |  |

## FP02600_Prod_Result_WO_MES.SetChangeControl

진입점: this.Load [try] / mcbo_division.SelectedIndexChanged / mcbo_site.SelectedIndexChanged / mcbo_plant.SelectedIndexChanged / mcbo_factory.SelectedIndexChanged / mcbo_operation.SelectedIndexChanged / mcbo_line.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f0e5da61 | this.Load [try] 외 6 | FP02600_Prod_Result_WO_MES.cs:309 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (!dtDivision.Good()) | FLAG | dtDivision | DataService.GetInnerTable("DIVISION_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-1d9e3de6 | this.Load [try] 외 6 | FP02600_Prod_Result_WO_MES.cs:309 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (!dtDivision.Good()) | COMBO_DATA | DataService.GetInnerTable | ("DIVISION_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-e487abc8 | this.Load [try] 외 6 | FP02600_Prod_Result_WO_MES.cs:318 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) | FLAG | dtSite | DataService.GetInnerTable("SITE_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-99c39b06 | this.Load [try] 외 6 | FP02600_Prod_Result_WO_MES.cs:318 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) | COMBO_DATA | DataService.GetInnerTable | ("SITE_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-3a0b3121 | this.Load [try] 외 6 | FP02600_Prod_Result_WO_MES.cs:319 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) | LIST_REBIND | clsCtrl.setListBox | (dtSite, mcbo_site, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-22852cbf | this.Load [try] 외 6 | FP02600_Prod_Result_WO_MES.cs:325 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) | DATA_OP | Filter["SITE_ID"] | CString.GetCheckedListValue(dtSite, mcbo_site.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-c5985cf2 | this.Load [try] 외 6 | FP02600_Prod_Result_WO_MES.cs:326 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) | FLAG | dtPlant | DataService.GetInnerTable("PLANT_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-ea0775e7 | this.Load [try] 외 6 | FP02600_Prod_Result_WO_MES.cs:326 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) | COMBO_DATA | DataService.GetInnerTable | ("PLANT_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-233e61ce | this.Load [try] 외 6 | FP02600_Prod_Result_WO_MES.cs:327 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) | LIST_REBIND | clsCtrl.setListBox | (dtPlant, mcbo_plant, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-44443539 | this.Load [try] 외 6 | FP02600_Prod_Result_WO_MES.cs:333 | switch (triggerControl) case DefColumns.PLANT_ID: ▸ if (dtSite.Good()) | DATA_OP | Filter["PLANT_ID"] | CString.GetCheckedListValue(dtPlant, mcbo_plant.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-88a27e04 | this.Load [try] 외 6 | FP02600_Prod_Result_WO_MES.cs:334 | switch (triggerControl) case DefColumns.PLANT_ID: ▸ if (dtSite.Good()) | FLAG | dtFactoryAmend | DataService.GetInnerTable("FACTORY_ID", Filter) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] \| FP\CO… | 화면 필드/플래그 변경 |  |  |  |
| AC-c336e858 | this.Load [try] 외 6 | FP02600_Prod_Result_WO_MES.cs:334 | switch (triggerControl) case DefColumns.PLANT_ID: ▸ if (dtSite.Good()) | COMBO_DATA | DataService.GetInnerTable | ("FACTORY_ID", Filter) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] \| FP\CO… | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-3d736f2c | this.Load [try] 외 6 | FP02600_Prod_Result_WO_MES.cs:335 | switch (triggerControl) case DefColumns.PLANT_ID: ▸ if (dtSite.Good()) | LIST_REBIND | clsCtrl.setListBox | (dtFactoryAmend, mcbo_factory, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-f44be939 | this.Load [try] 외 6 | FP02600_Prod_Result_WO_MES.cs:341 | switch (triggerControl) case DefColumns.FACTORY_ID: ▸ if (dtFactoryAmend.Good()) | DATA_OP | Filter["FACTORY_ID"] | CString.GetCheckedListValue(dtFactoryAmend, mcbo_factory.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-8285fc14 | this.Load [try] 외 6 | FP02600_Prod_Result_WO_MES.cs:342 | switch (triggerControl) case DefColumns.FACTORY_ID: ▸ if (dtFactoryAmend.Good()) | FLAG | dtOperation | DataService.GetInnerTable("OPERATION_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-6b6878c1 | this.Load [try] 외 6 | FP02600_Prod_Result_WO_MES.cs:342 | switch (triggerControl) case DefColumns.FACTORY_ID: ▸ if (dtFactoryAmend.Good()) | COMBO_DATA | DataService.GetInnerTable | ("OPERATION_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-a30cdc27 | this.Load [try] 외 6 | FP02600_Prod_Result_WO_MES.cs:343 | switch (triggerControl) case DefColumns.FACTORY_ID: ▸ if (dtFactoryAmend.Good()) | LIST_REBIND | clsCtrl.setListBox | (dtOperation, mcbo_operation, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-0068fcbf | this.Load [try] 외 6 | FP02600_Prod_Result_WO_MES.cs:349 | switch (triggerControl) case DefColumns.OPERATION_ID: ▸ if (dtOperation.Good()) | DATA_OP | Filter["OPERATION_ID"] | CString.GetCheckedListValue(dtOperation, mcbo_operation.ControlValues, true) | 행/컬럼 값 대입 |  |  |  |
| AC-cdb1a8db | this.Load [try] 외 6 | FP02600_Prod_Result_WO_MES.cs:351 | switch (triggerControl) case DefColumns.OPERATION_ID: ▸ if (dtOperation.Good()) | FLAG | dtLine | DataService.GetInnerTable("LINE_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-2bdafda1 | this.Load [try] 외 6 | FP02600_Prod_Result_WO_MES.cs:351 | switch (triggerControl) case DefColumns.OPERATION_ID: ▸ if (dtOperation.Good()) | COMBO_DATA | DataService.GetInnerTable | ("LINE_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-a5c8726c | this.Load [try] 외 6 | FP02600_Prod_Result_WO_MES.cs:352 | switch (triggerControl) case DefColumns.OPERATION_ID: ▸ if (dtOperation.Good()) | LIST_REBIND | clsCtrl.setListBox | (dtLine, mcbo_line, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-dcd9b24f | this.Load [try] 외 6 | FP02600_Prod_Result_WO_MES.cs:358 | switch (triggerControl) case DefColumns.LINE_ID: ▸ if (dtLine.Good()) | DATA_OP | Filter["LINE_ID"] | CString.GetCheckedListValue(dtLine, mcbo_line.ControlValues, true) | 행/컬럼 값 대입 |  |  |  |

## FP02600_Prod_Result_WO_MES.SetDevOption

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5ee8bcbc | this.Load | FP02600_Prod_Result_WO_MES.cs:179 |  | CALL_EXT | UserService.HasExtraRole | (CurrentUser) | ⚠ 의미 확인 필요 |  |  |  |
| AC-cb284c56 | this.Load | FP02600_Prod_Result_WO_MES.cs:181 | if (UserService.HasExtraRole(CurrentUser)) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-ebab378b | this.Load | FP02600_Prod_Result_WO_MES.cs:185 | else of (UserService.HasExtraRole(CurrentUser)) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-f4450a16 | this.Load | FP02600_Prod_Result_WO_MES.cs:188 |  | CALL_EXT | UserService.HasSuperRole | (CurrentUser) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c21cbd0d | this.Load | FP02600_Prod_Result_WO_MES.cs:190 | if (UserService.HasSuperRole(CurrentUser)) | UI_PROP | lblData.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-9d11f7f0 | this.Load | FP02600_Prod_Result_WO_MES.cs:194 | else of (UserService.HasSuperRole(CurrentUser)) | UI_PROP | lblData.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |

## FP02600_Prod_Result_WO_MES.SetDirty

진입점: this.btnExcelImport.Click [if (rowPopup.SaveSuccess == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ finally] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ finally] / SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e7e5f0a7 | this.btnExcelImport.Click [if (rowPopup.SaveSuccess == true)… 외 2 | FP02600_Prod_Result_WO_MES.cs:3557 |  | FLAG | IsDirty | dirty | 화면 필드/플래그 변경 |  |  |  |

## FP02600_Prod_Result_WO_MES.SetFilter

진입점: this.Load [try ▸ switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good())] / mcbo_division.SelectedIndexChanged [switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good())] / mcbo_site.SelectedIndexChanged [switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good())] / mcbo_plant.SelectedIndexChanged [switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good())] / mcbo_factory.SelectedIndexChanged [switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good())] / mcbo_operation.SelectedIndexChanged [switc…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b1cd142e | this.Load [try ▸ switch (triggerControl) case DefColumns.DIV… 외 9 | FP02600_Prod_Result_WO_MES.cs:2552 |  | DATA_OP | Filter[key] | value | 행/컬럼 값 대입 |  |  |  |

## FP02600_Prod_Result_WO_MES.SetReleaseProcess

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e82c3395 | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:2428 | if (Filter["PLAN_TYPE"] == "RELEASE") | ENDPOINT | DataService.FP_ExecuteQuery | ("XpCommonAmend", "find_isCurrWeek", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_isCurrWeek] \| FP\Common\X… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-ab978132 | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:2434 | if (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (ds_isCurrWeek.Good()) ▸ foreach (DataRow row in dateMap.Tables[0].Rows) | FLAG | DbCurrentDate | DateTime.ParseExact(curr_date, "yyyyMMdd", enUS) | 화면 필드/플래그 변경 |  |  |  |
| AC-a00e7127 | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:2439 | if (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (ds_isCurrWeek.Good()) ▸ foreach (DataRow row in dateMap.Tables[0].Rows) ▸ if (row_Date < DbCurre… | DATA_OP | row["IS_PLAN"] | "N" | 행/컬럼 값 대입 |  |  |  |
| AC-f46cfb14 | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:2443 | if (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (ds_isCurrWeek.Good()) ▸ foreach (DataRow row in dateMap.Tables[0].Rows) ▸ else of (row_Date < Db… | DATA_OP | row["IS_PLAN"] | "Y" | 행/컬럼 값 대입 |  |  |  |
| AC-5de7f0b2 | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:2449 | if (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (ds_isCurrWeek.Good()) ▸ if (ds_isCurrWeek.Tables[0].Rows[0]["IS_LATEST_PLAN"].ToString() != "Y") | DATA_OP | Filter["DONOTEDIT"] | "Y" | 행/컬럼 값 대입 |  |  |  |
| AC-7cac7153 | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:2452 | if (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (ds_isCurrWeek.Good()) | DATA_OP | Filter["CURR_DATE"] | ds_isCurrWeek.Tables[0].Rows[0]["CURR_DATE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-6211faf1 | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:2453 | if (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (ds_isCurrWeek.Good()) | DATA_OP | Filter["RELEASE_VALUE"] | ds_isCurrWeek.Tables[0].Rows[0]["RELEASE_VALUE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-557f8be7 | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:2458 | else of (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | Filter["CURR_DATE"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-661bac5f | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:2459 | else of (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | Filter["RELEASE_VALUE"] | "" | 행/컬럼 값 대입 |  |  |  |

## FP02600_Prod_Result_WO_MES.SetSpreadInit

진입점: this.Load [try] / this.btnExcelImport.Click [if (rowPopup.SaveSuccess == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try ▸ if (dsMain == null) ▸ else of (with_day_part == false) ▸ if (refreshColumn) ▸ try] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try ▸ if (dsMain == null) ▸ else of (with_day_part == false) ▸ if (refreshColumn) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3f5d9fc3 | this.Load [try] 외 2 | FP02600_Prod_Result_WO_MES.cs:511 | if (sheetName.Equals(SpdSheet.shtPlanAmendMA)) | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0848de19 | this.Load [try] 외 2 | FP02600_Prod_Result_WO_MES.cs:512 | if (sheetName.Equals(SpdSheet.shtPlanAmendMA)) | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |

## FP02600_Prod_Result_WO_MES.SetTotalColor

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bb67b70e | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:576 | foreach (DataRow row in dsMainFiltered.Tables[0].Rows) ▸ switch (row["DATA_TYPE"].ToString()) case "TOTAL": | GRID_STYLE | siMain.SetBGColor3 | (line, start, line, last_col, total_color) | 그리드 표시 설정 |  |  |  |
| AC-b39233e0 | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:579 | foreach (DataRow row in dsMainFiltered.Tables[0].Rows) ▸ switch (row["DATA_TYPE"].ToString()) case "TOTAL_2": | GRID_STYLE | siMain.SetBGColor3 | (line, substart, line, last_col, sub_total_color) | 그리드 표시 설정 |  |  |  |
| AC-1ce03489 | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:586 | foreach (DataRow row in dsMainFiltered.Tables[0].Rows) ▸ switch (row["DATA_TYPE"].ToString()) default: ▸ if (!string.IsNullOrWhiteSpace(work… | GRID_STYLE | siMain.SetBGColor3 | (line, idx_item_id, line, idx_item_id, Color.Orange) | 그리드 표시 설정 |  |  |  |
| AC-3f1bd86b | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:588 | foreach (DataRow row in dsMainFiltered.Tables[0].Rows) ▸ switch (row["DATA_TYPE"].ToString()) default: ▸ if (!string.IsNullOrWhiteSpace(work… | GRID_STYLE | siMain.SetBGColor3 | (line, idx_nick_name, line, idx_nick_name, Color.Orange) | 그리드 표시 설정 |  |  |  |
| AC-0340da94 | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:590 | foreach (DataRow row in dsMainFiltered.Tables[0].Rows) ▸ switch (row["DATA_TYPE"].ToString()) default: ▸ if (!string.IsNullOrWhiteSpace(work… | GRID_STYLE | siMain.SetBGColor3 | (line, idx_app_model, line, idx_app_model, Color.Orange) | 그리드 표시 설정 |  |  |  |
| AC-61c1885b | (진입점 미연결) | FP02600_Prod_Result_WO_MES.cs:592 | foreach (DataRow row in dsMainFiltered.Tables[0].Rows) ▸ switch (row["DATA_TYPE"].ToString()) default: ▸ if (!string.IsNullOrWhiteSpace(work… | GRID_STYLE | siMain.SetBGColor3 | (line, idx_work_model, line, idx_work_model, Color.Orange) | 그리드 표시 설정 |  |  |  |

## FP02600_Prod_Result_WO_MES.UIFindData

진입점: this.btnExcelImport.Click [if (rowPopup.SaveSuccess == true)] / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0bd248cb | this.btnExcelImport.Click [if (rowPopup.SaveSuccess == true)… 외 1 | FP02600_Prod_Result_WO_MES.cs:905 | try ▸ if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-07d2eccd | this.btnExcelImport.Click [if (rowPopup.SaveSuccess == true)… 외 1 | FP02600_Prod_Result_WO_MES.cs:906 | try ▸ if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c6d4dfa4 | this.btnExcelImport.Click [if (rowPopup.SaveSuccess == true)… 외 1 | FP02600_Prod_Result_WO_MES.cs:909 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-0e045cfe | this.btnExcelImport.Click [if (rowPopup.SaveSuccess == true)… 외 1 | FP02600_Prod_Result_WO_MES.cs:919 | try | DATA_OP | Filter["START_DATE"] | sCalendar_planday.DateTime.ToString("yyyyMMdd", enUS) | 행/컬럼 값 대입 |  |  |  |
| AC-d47bc9e3 | this.btnExcelImport.Click [if (rowPopup.SaveSuccess == true)… 외 1 | FP02600_Prod_Result_WO_MES.cs:924 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | CALL_BASE | SaveTopRow | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-32d2f4ed | this.btnExcelImport.Click [if (rowPopup.SaveSuccess == true)… 외 1 | FP02600_Prod_Result_WO_MES.cs:942 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (sDivision == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00097") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-77e9a3ad | this.btnExcelImport.Click [if (rowPopup.SaveSuccess == true)… 외 1 | FP02600_Prod_Result_WO_MES.cs:943 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (sDivision == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-704ec0b7 | this.btnExcelImport.Click [if (rowPopup.SaveSuccess == true)… 외 1 | FP02600_Prod_Result_WO_MES.cs:945 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-e8faac86 | this.btnExcelImport.Click [if (rowPopup.SaveSuccess == true)… 외 1 | FP02600_Prod_Result_WO_MES.cs:950 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | FLAG | dsMain | null | 화면 필드/플래그 변경 |  |  |  |
| AC-045e4fd4 | this.btnExcelImport.Click [if (rowPopup.SaveSuccess == true)… 외 1 | FP02600_Prod_Result_WO_MES.cs:951 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | FLAG | monthInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-62339e25 | this.btnExcelImport.Click [if (rowPopup.SaveSuccess == true)… 외 1 | FP02600_Prod_Result_WO_MES.cs:953 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | DATA_OP | Filter["DONOTEDIT"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-462861da | this.btnExcelImport.Click [if (rowPopup.SaveSuccess == true)… 외 1 | FP02600_Prod_Result_WO_MES.cs:965 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-82566e35 | this.btnExcelImport.Click [if (rowPopup.SaveSuccess == true)… 외 1 | FP02600_Prod_Result_WO_MES.cs:967 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | FLAG | dsMain | await asyncProxy.ExecuteAsync<DataSet>(() => FindMainData(true) ) | 화면 필드/플래그 변경 |  |  |  |
| AC-7b3a7171 | this.btnExcelImport.Click [if (rowPopup.SaveSuccess == true)… 외 1 | FP02600_Prod_Result_WO_MES.cs:967 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | ENDPOINT | asyncProxy.ExecuteAsync | (() => FindMainData(true) ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-c718e40f | this.btnExcelImport.Click [if (rowPopup.SaveSuccess == true)… 외 1 | FP02600_Prod_Result_WO_MES.cs:1050 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (Filter["PLAN_ID"].EndsWith("00")) | STATE | btnExcelImport.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-54c1c001 | this.btnExcelImport.Click [if (rowPopup.SaveSuccess == true)… 외 1 | FP02600_Prod_Result_WO_MES.cs:1055 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ else of (Filter["PLAN_ID"].EndsWith("00")) | STATE | btnExcelImport.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-920dd5db | this.btnExcelImport.Click [if (rowPopup.SaveSuccess == true)… 외 1 | FP02600_Prod_Result_WO_MES.cs:1056 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ else of (Filter["PLAN_ID"].EndsWith("00")) | DATA_OP | Filter["DONOTEDIT"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-b59e0fc6 | this.btnExcelImport.Click [if (rowPopup.SaveSuccess == true)… 외 1 | FP02600_Prod_Result_WO_MES.cs:1092 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMainFiltered.Good()) | UI_MISC | SetSearchCount | (dsMainFiltered) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-25e34fab | this.btnExcelImport.Click [if (rowPopup.SaveSuccess == true)… 외 1 | FP02600_Prod_Result_WO_MES.cs:1096 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | FLAG | FindDone | true | 화면 필드/플래그 변경 |  |  |  |
| AC-7ee46f1d | this.btnExcelImport.Click [if (rowPopup.SaveSuccess == true)… 외 1 | FP02600_Prod_Result_WO_MES.cs:1100 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-47283492 | this.btnExcelImport.Click [if (rowPopup.SaveSuccess == true)… 외 1 | FP02600_Prod_Result_WO_MES.cs:1105 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-1dc9e938 | this.btnExcelImport.Click [if (rowPopup.SaveSuccess == true)… 외 1 | FP02600_Prod_Result_WO_MES.cs:1106 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-b301a71c | this.btnExcelImport.Click [if (rowPopup.SaveSuccess == true)… 외 1 | FP02600_Prod_Result_WO_MES.cs:1113 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | CALL_BASE | RestoreRowRow | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-3c97f109 | this.btnExcelImport.Click [if (rowPopup.SaveSuccess == true)… 외 1 | FP02600_Prod_Result_WO_MES.cs:1116 | try | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtPlanAmendMA, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-ee28b28f | this.btnExcelImport.Click [if (rowPopup.SaveSuccess == true)… 외 1 | FP02600_Prod_Result_WO_MES.cs:1120 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-7c510f23 | this.btnExcelImport.Click [if (rowPopup.SaveSuccess == true)… 외 1 | FP02600_Prod_Result_WO_MES.cs:1124 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |

