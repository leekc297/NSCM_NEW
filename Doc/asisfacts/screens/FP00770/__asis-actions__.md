# AS-IS 액션 대조표 — FP00770

> 원천: `Doc/asisfacts/screens/FP00770/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 515행 · 메서드 65 · 종류 DATA_OP 114 · FLAG 55 · RETURN 52 · UI_PROP 42 · CALL_EXT 35 · GRID_SET 34 · STATE 32 · MESSAGE 25 · UI_MISC 22 · GRID_INIT 21 · COMBO_DATA 13 · GRID_STYLE 12 · CALL_BASE 11 · LIST_REBIND 11 · POPUP 10 · THROW 8 · ENDPOINT 7 · GRID_LOCK 5 · VALUE_SET 3 · FOCUS 1 · EXCEL 1 · GRID_BIND 1 · ⚠ 의미 확인 필요 46


## FP00770_ExcelPopup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-91895a23 | .ctor | FP00770_ExcelPopup.cs:147 |  | FLAG | this.bCtlEnable | true | 화면 필드/플래그 변경 |  |  |  |
| AC-9eddb860 | .ctor | FP00770_ExcelPopup.cs:150 |  | FLAG | Filter | new FilterDataSet() | 화면 필드/플래그 변경 |  |  |  |
| AC-c588cf42 | .ctor | FP00770_ExcelPopup.cs:151 |  | FLAG | AutoCHK | false | 화면 필드/플래그 변경 |  |  |  |
| AC-71e1eb56 | .ctor | FP00770_ExcelPopup.cs:152 |  | FLAG | HeaderLineCount | 2 | 화면 필드/플래그 변경 |  |  |  |
| AC-989fab7b | .ctor | FP00770_ExcelPopup.cs:153 |  | FLAG | IgnoreColumnsNotInTitle | true | 화면 필드/플래그 변경 |  |  |  |
| AC-8627e228 | .ctor | FP00770_ExcelPopup.cs:154 |  | FLAG | AutoCHK | false | 화면 필드/플래그 변경 |  |  |  |

## FP00770_ExcelPopup.btnClose_Click

진입점: this.btnClose.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d236acf9 | this.btnClose.Click | FP00770_ExcelPopup.cs:713 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00770_ExcelPopup.btnDownload_Click

진입점: this.btnDownload.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fb646ab3 | this.btnDownload.Click | FP00770_ExcelPopup.cs:697 |  | FOCUS | spdMain.Focus | () | 포커스 이동 |  |  |  |
| AC-d4e6506c | this.btnDownload.Click | FP00770_ExcelPopup.cs:698 |  | EXCEL | ExportExcel | (0, true) | 엑셀 내보내기/올리기 |  |  |  |

## FP00770_ExcelPopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3b353eb4 | this.Load | FP00770_ExcelPopup.cs:192 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 2, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-65951a5b | this.Load | FP00770_ExcelPopup.cs:193 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-2cbef8d6 | this.Load | FP00770_ExcelPopup.cs:194 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00770_ExcelPopup.DefaultLineCheck

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a6a411ec | (진입점 미연결) | FP00770_ExcelPopup.cs:665 |  | CALL_EXT | ExcelService.CommonDefaultLineCheck | (row, KeyColumnList, ColumnType, ColumnLength, Filter, AcceptOnlyPositve) | ⚠ 의미 확인 필요 |  |  |  |
| AC-dc3541fe | (진입점 미연결) | FP00770_ExcelPopup.cs:665 |  | RETURN | return ExcelService.CommonDefaultLineCheck(row, KeyColumnList, ColumnType, Colum… |  | 처리 중단/반환 |  |  |  |

## FP00770_ExcelPopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d1be5b23 | this.Load | FP00770_ExcelPopup.cs:187 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP00770_ExcelPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a0603115 | Dispose | FP00770_ExcelPopup.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00770_ExcelPopup.ExcelLineCheck

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bb511fa4 | (진입점 미연결) | FP00770_ExcelPopup.cs:588 | if (this.DoLineCheck != null) | CALL_BASE | DoLineCheck | (row, this) | ⚠ 의미 확인 필요 |  |  |  |

## FP00770_ExcelPopup.FindButton

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a6d2af17 | FindButton | FP00770_ExcelPopup.cs:235 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-3956dcd2 | FindButton | FP00770_ExcelPopup.cs:236 |  | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-34cbd82d | FindButton | FP00770_ExcelPopup.cs:238 |  | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## FP00770_ExcelPopup.FindData

진입점: this.Load / this.btnFind.Click / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4c417756 | this.Load 외 2 | FP00770_ExcelPopup.cs:265 | if (DoSearchData == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b047ab64 | this.Load 외 2 | FP00770_ExcelPopup.cs:266 |  | FLAG | ctx | FoxUserInfoContext.GetUserInfoContext() | 화면 필드/플래그 변경 |  |  |  |
| AC-6a3ae035 | this.Load 외 2 | FP00770_ExcelPopup.cs:266 |  | CALL_EXT | FoxUserInfoContext.GetUserInfoContext | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-885a4130 | this.Load 외 2 | FP00770_ExcelPopup.cs:270 | if (DoSearchData != null) | FLAG | this.hasError | false | 화면 필드/플래그 변경 |  |  |  |
| AC-53197019 | this.Load 외 2 | FP00770_ExcelPopup.cs:271 | if (DoSearchData != null) | FLAG | this.IsExcelChanged | false | 화면 필드/플래그 변경 |  |  |  |
| AC-8992dd47 | this.Load 외 2 | FP00770_ExcelPopup.cs:273 | if (DoSearchData != null) | STATE | this.spdMain.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-2fcf6b84 | this.Load 외 2 | FP00770_ExcelPopup.cs:274 | if (DoSearchData != null) | STATE | this.btnClose.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-855c1cbd | this.Load 외 2 | FP00770_ExcelPopup.cs:275 | if (DoSearchData != null) | STATE | this.btnFind.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-5120cb41 | this.Load 외 2 | FP00770_ExcelPopup.cs:276 | if (DoSearchData != null) | STATE | this.btnDownload.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-6e44b3d8 | this.Load 외 2 | FP00770_ExcelPopup.cs:277 | if (DoSearchData != null) | STATE | this.btnUpload.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-ce7c67fc | this.Load 외 2 | FP00770_ExcelPopup.cs:278 | if (DoSearchData != null) | STATE | this.btnSave.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-ad2af67e | this.Load 외 2 | FP00770_ExcelPopup.cs:285 | if (DoSearchData != null) ▸ try ▸ if (UserInfoContext.Current == null) | CALL_EXT | FoxUserInfoContext.SetCallContext | (ctx) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e523d79c | this.Load 외 2 | FP00770_ExcelPopup.cs:288 | if (DoSearchData != null) ▸ try | CALL_BASE | DoSearchData | (Filter.Data, this) | ⚠ 의미 확인 필요 |  |  |  |
| AC-2e7320ba | this.Load 외 2 | FP00770_ExcelPopup.cs:291 | if (DoSearchData != null) ▸ try ▸ if (set == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c590127d | this.Load 외 2 | FP00770_ExcelPopup.cs:292 | if (DoSearchData != null) ▸ try | CALL_BASE | this.Invoke | (new Action(delegate () { DictColumn = siMain.SetSheetHeaderColumn_FP2(siMain, 2);//.SetSh… | ⚠ 의미 확인 필요 |  |  |  |
| AC-29f92eeb | this.Load 외 2 | FP00770_ExcelPopup.cs:294 | if (DoSearchData != null) ▸ try ▸ lambda | FLAG | DictColumn | siMain.SetSheetHeaderColumn_FP2(siMain, 2) | 화면 필드/플래그 변경 |  |  |  |
| AC-e16b6b92 | this.Load 외 2 | FP00770_ExcelPopup.cs:294 | if (DoSearchData != null) ▸ try ▸ lambda | GRID_INIT | siMain.SetSheetHeaderColumn_FP2 | (siMain, 2) | 그리드 재구성/초기화 |  |  |  |
| AC-f7d2ba6d | this.Load 외 2 | FP00770_ExcelPopup.cs:300 | if (DoSearchData != null) ▸ try ▸ lambda ▸ if (AutoCHK) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex("CHK")].CellType | chk | 그리드 속성/값 설정 |  |  |  |
| AC-1c4c03a9 | this.Load 외 2 | FP00770_ExcelPopup.cs:301 | if (DoSearchData != null) ▸ try ▸ lambda ▸ if (AutoCHK) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex("CHK")].Value | false | 그리드 속성/값 설정 |  |  |  |
| AC-3f548a91 | this.Load 외 2 | FP00770_ExcelPopup.cs:302 | if (DoSearchData != null) ▸ try ▸ lambda ▸ if (AutoCHK) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex("CHK")].Border | bevelbrdr | 그리드 속성/값 설정 |  |  |  |
| AC-676d0d4a | this.Load 외 2 | FP00770_ExcelPopup.cs:307 | if (DoSearchData != null) ▸ try ▸ lambda ▸ if (set != null && set.Tables != null && set.Tables.Count > 0) | DATA_OP | set.Tables[0].Columns.Contains | ("MESSAGE") | 데이터 객체 조작/조회 |  |  |  |
| AC-6203b56e | this.Load 외 2 | FP00770_ExcelPopup.cs:308 | if (DoSearchData != null) ▸ try ▸ lambda ▸ if (set != null && set.Tables != null && set.Tables.Count > 0) ▸ if (!set.Tables[0].Columns.Conta… | DATA_OP | set.Tables[0].Columns.Add | ("MESSAGE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-29f92b03 | this.Load 외 2 | FP00770_ExcelPopup.cs:312 | if (DoSearchData != null) ▸ try ▸ lambda | GRID_BIND | siMain.Query | (set, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-1f2c9936 | this.Load 외 2 | FP00770_ExcelPopup.cs:316 | if (DoSearchData != null) ▸ try ▸ lambda ▸ if (colIndex > 0) | CALL_EXT | siMain.SetColumnFormat | (colIndex, 1, "#,##0.#########", "", true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-1b91ea6c | this.Load 외 2 | FP00770_ExcelPopup.cs:320 | if (DoSearchData != null) ▸ try ▸ lambda ▸ if (colIndex > 0) | CALL_EXT | siMain.SetColumnFormat | (colIndex, 1, "#,##0.#########", "", true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-2052889e | this.Load 외 2 | FP00770_ExcelPopup.cs:324 | if (DoSearchData != null) ▸ try ▸ lambda ▸ if (colIndex > 0) | CALL_EXT | siMain.SetColumnFormat | (colIndex, 1, "#,##0.#########", "", true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f637ecd6 | this.Load 외 2 | FP00770_ExcelPopup.cs:328 | if (DoSearchData != null) ▸ try ▸ lambda ▸ if (colIndex > 0) | CALL_EXT | siMain.SetColumnFormat | (colIndex, 1, "#,##0.#########", "", true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3d762a4a | this.Load 외 2 | FP00770_ExcelPopup.cs:338 | if (DoSearchData != null) ▸ finally | CALL_BASE | this.Invoke | (new Action(delegate () { //this.Enabled = false; this.spdMain.Enabled = true; this.btnClo… | ⚠ 의미 확인 필요 |  |  |  |
| AC-71107487 | this.Load 외 2 | FP00770_ExcelPopup.cs:341 | if (DoSearchData != null) ▸ finally ▸ lambda | STATE | this.spdMain.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-883947c7 | this.Load 외 2 | FP00770_ExcelPopup.cs:342 | if (DoSearchData != null) ▸ finally ▸ lambda | STATE | this.btnClose.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-e0b12bd3 | this.Load 외 2 | FP00770_ExcelPopup.cs:343 | if (DoSearchData != null) ▸ finally ▸ lambda | STATE | this.btnFind.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-1fedfe99 | this.Load 외 2 | FP00770_ExcelPopup.cs:344 | if (DoSearchData != null) ▸ finally ▸ lambda | STATE | this.btnDownload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-6738810b | this.Load 외 2 | FP00770_ExcelPopup.cs:345 | if (DoSearchData != null) ▸ finally ▸ lambda | STATE | this.btnUpload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-c9c40a4d | this.Load 외 2 | FP00770_ExcelPopup.cs:346 | if (DoSearchData != null) ▸ finally ▸ lambda | STATE | this.btnSave.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## FP00770_ExcelPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-32c2c9f5 | this.Load | FP00770_ExcelPopup.cs:162 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-a75b8087 | this.Load | FP00770_ExcelPopup.cs:164 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00770_ExcelPopup.GetExcelFileName

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bf58bb04 | (진입점 미연결) | FP00770_ExcelPopup.cs:562 | try | POPUP | new OpenFileDialog | () | 팝업/폼 생성 |  |  |  |
| AC-dfcef73c | (진입점 미연결) | FP00770_ExcelPopup.cs:563 | try | UI_PROP | openFile.Filter | "Excel files (*.xls;*.xlsx)\|*.xls;*.xlsx\|xls files (*.xls)\|*.xls\|xlsx files (*.xlsx)\|… | 속성 Filter 설정 |  |  |  |
| AC-d48dd7ea | (진입점 미연결) | FP00770_ExcelPopup.cs:564 | try | UI_PROP | openFile.FilterIndex | 1 | 속성 FilterIndex 설정 |  |  |  |
| AC-3cbd3632 | (진입점 미연결) | FP00770_ExcelPopup.cs:565 | try | UI_PROP | openFile.RestoreDirectory | true | 속성 RestoreDirectory 설정 |  |  |  |
| AC-09f7b08a | (진입점 미연결) | FP00770_ExcelPopup.cs:566 | try | UI_PROP | openFile.InitialDirectory | @"C:\My Documents\" | 속성 InitialDirectory 설정 |  |  |  |
| AC-be2b430a | (진입점 미연결) | FP00770_ExcelPopup.cs:567 | try | UI_PROP | openFile.FileName | FileName | 속성 FileName 설정 |  |  |  |
| AC-fb6fdd74 | (진입점 미연결) | FP00770_ExcelPopup.cs:568 | try | POPUP | openFile.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-5d66f000 | (진입점 미연결) | FP00770_ExcelPopup.cs:570 | try | FLAG | this.FileName | openFile.FileName | 화면 필드/플래그 변경 |  |  |  |
| AC-60d4bb67 | (진입점 미연결) | FP00770_ExcelPopup.cs:571 | try | RETURN | return this.FileName; |  | 처리 중단/반환 |  |  |  |
| AC-e3aaa012 | (진입점 미연결) | FP00770_ExcelPopup.cs:575 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message, ex.Source, MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-50deaf82 | (진입점 미연결) | FP00770_ExcelPopup.cs:576 | catch ((Exception ex)) | RETURN | return string.Empty; |  | 처리 중단/반환 |  |  |  |

## FP00770_ExcelPopup.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a843b1f8 | this.Load | FP00770_ExcelPopup.cs:204 |  | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-cef6389d | this.Load | FP00770_ExcelPopup.cs:205 |  | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP00770_ExcelPopup.InitSpread_Merge

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b2e6c23a | (진입점 미연결) | FP00770_ExcelPopup.cs:225 |  | GRID_INIT | siMain.Freeze | (0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP00770_ExcelPopup.OpenAndLoadExcelData

진입점: this.btnUpload.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c7af489a | this.btnUpload.Click | FP00770_ExcelPopup.cs:599 |  | FLAG | FileName | ExcelService.GetExcelFileName(FileName) | 화면 필드/플래그 변경 |  |  |  |
| AC-c7c69521 | this.btnUpload.Click | FP00770_ExcelPopup.cs:599 |  | CALL_EXT | ExcelService.GetExcelFileName | (FileName) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d7ea9fe2 | this.btnUpload.Click | FP00770_ExcelPopup.cs:600 |  | FLAG | hasError | false | 화면 필드/플래그 변경 |  |  |  |
| AC-81d301fe | this.btnUpload.Click | FP00770_ExcelPopup.cs:601 |  | FLAG | IsExcelChanged | true | 화면 필드/플래그 변경 |  |  |  |
| AC-2717a116 | this.btnUpload.Click | FP00770_ExcelPopup.cs:602 |  | CALL_EXT | System.IO.File.Exists | (FileName) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e8db01c6 | this.btnUpload.Click | FP00770_ExcelPopup.cs:604 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-914131f3 | this.btnUpload.Click | FP00770_ExcelPopup.cs:609 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try | FLAG | hasError | ExcelService.LoadExcelFile( FileName, KeyColumns, KeyColumnList, DictColumn, HeaderLineCou… | 화면 필드/플래그 변경 |  |  |  |
| AC-ef7e2156 | this.btnUpload.Click | FP00770_ExcelPopup.cs:609 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try | CALL_EXT | ExcelService.LoadExcelFile | ( FileName, KeyColumns, KeyColumnList, DictColumn, HeaderLineCount, spdMain, siMain, null,… | ⚠ 의미 확인 필요 |  |  |  |
| AC-dc30a38c | this.btnUpload.Click | FP00770_ExcelPopup.cs:616 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-4f6baf2e | this.btnUpload.Click | FP00770_ExcelPopup.cs:619 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (hasError == false) | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-957f2b45 | this.btnUpload.Click | FP00770_ExcelPopup.cs:620 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (hasError == false) | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-aaf7682a | this.btnUpload.Click | FP00770_ExcelPopup.cs:624 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (hasError == false) ▸ if (DoImportData != nu… | CALL_BASE | DoImportData | (dsImport, this) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c7c95abf | this.btnUpload.Click | FP00770_ExcelPopup.cs:625 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (hasError == false) ▸ if (DoImportData != nu… | CALL_EXT | DataService.ReadResult | (importResult) | ⚠ 의미 확인 필요 |  |  |  |
| AC-6ee4a357 | this.btnUpload.Click | FP00770_ExcelPopup.cs:637 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (hasError == false) ▸ if (DoImportData != nu… | CALL_EXT | siMain.SetRowColor | (i, System.Drawing.Color.PaleVioletRed) | ⚠ 의미 확인 필요 |  |  |  |
| AC-02ab6b07 | this.btnUpload.Click | FP00770_ExcelPopup.cs:641 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (hasError == false) ▸ if (DoImportData != nu… | FLAG | hasError | true | 화면 필드/플래그 변경 |  |  |  |
| AC-a5daf823 | this.btnUpload.Click | FP00770_ExcelPopup.cs:644 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (hasError == false) | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-94b4293d | this.btnUpload.Click | FP00770_ExcelPopup.cs:649 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ catch () | THROW | throw; |  | 예외 발생 |  |  |  |
| AC-5191a0d7 | this.btnUpload.Click | FP00770_ExcelPopup.cs:653 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-f133357c | this.btnUpload.Click | FP00770_ExcelPopup.cs:654 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-5e098500 | this.btnUpload.Click | FP00770_ExcelPopup.cs:657 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## FP00770_ExcelPopup.SaveToDB

진입점: this.btnSave.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0631177b | this.btnSave.Click | FP00770_ExcelPopup.cs:360 | if (IsExcelChanged == false) | MESSAGE | MessageBox.Show | ("There is no changed to save") | 메시지 표시 |  |  |  |
| AC-67d329d2 | this.btnSave.Click | FP00770_ExcelPopup.cs:361 | if (IsExcelChanged == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-359e9384 | this.btnSave.Click | FP00770_ExcelPopup.cs:365 | if (hasError == true) | MESSAGE | MessageBox.Show | ("You have errors to fix") | 메시지 표시 |  |  |  |
| AC-725f5a96 | this.btnSave.Click | FP00770_ExcelPopup.cs:366 | if (hasError == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8b1fef1e | this.btnSave.Click | FP00770_ExcelPopup.cs:370 |  | FLAG | ctx | FoxUserInfoContext.GetUserInfoContext() | 화면 필드/플래그 변경 |  |  |  |
| AC-c1de47ec | this.btnSave.Click | FP00770_ExcelPopup.cs:370 |  | CALL_EXT | FoxUserInfoContext.GetUserInfoContext | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-c480450e | this.btnSave.Click | FP00770_ExcelPopup.cs:375 | if (DoSaveData != null) | STATE | this.spdMain.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-8423c4c7 | this.btnSave.Click | FP00770_ExcelPopup.cs:376 | if (DoSaveData != null) | STATE | this.btnClose.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-d31bc555 | this.btnSave.Click | FP00770_ExcelPopup.cs:377 | if (DoSaveData != null) | STATE | this.btnFind.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-4f4a6392 | this.btnSave.Click | FP00770_ExcelPopup.cs:378 | if (DoSaveData != null) | STATE | this.btnDownload.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-b225f625 | this.btnSave.Click | FP00770_ExcelPopup.cs:379 | if (DoSaveData != null) | STATE | this.btnUpload.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-ce40cff0 | this.btnSave.Click | FP00770_ExcelPopup.cs:380 | if (DoSaveData != null) | STATE | this.btnSave.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-6d9eb059 | this.btnSave.Click | FP00770_ExcelPopup.cs:388 | if (DoSaveData != null) ▸ try ▸ if (main != null && main.Tables != null && main.Tables.Count > 0) | DATA_OP | main.Tables[0].Columns.Contains | ("USER_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-fc2ac50a | this.btnSave.Click | FP00770_ExcelPopup.cs:391 | if (DoSaveData != null) ▸ try ▸ if (main != null && main.Tables != null && main.Tables.Count > 0) ▸ if (!main.Tables[0].Columns.Contains("US… | DATA_OP | main.Tables[0].Columns.Add | (itemColumn) | 데이터 객체 조작/조회 |  |  |  |
| AC-779b2329 | this.btnSave.Click | FP00770_ExcelPopup.cs:397 | if (DoSaveData != null) ▸ try ▸ if (main != null && main.Tables != null && main.Tables.Count > 0) ▸ for (i < main.Tables[0].Rows.Count) | GRID_SET | main.Tables[0].Rows[i]["USER_ID"] | UserInfoContext.Current.UserId | 그리드 속성/값 설정 |  |  |  |
| AC-a1c86ed9 | this.btnSave.Click | FP00770_ExcelPopup.cs:405 | if (DoSaveData != null) ▸ try ▸ if (expect_count < 1) | MESSAGE | MessageBox.Show | ("There is no data to save") | 메시지 표시 |  |  |  |
| AC-2ba848f5 | this.btnSave.Click | FP00770_ExcelPopup.cs:406 | if (DoSaveData != null) ▸ try ▸ if (expect_count < 1) | STATE | this.spdMain.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-23ed48ec | this.btnSave.Click | FP00770_ExcelPopup.cs:407 | if (DoSaveData != null) ▸ try ▸ if (expect_count < 1) | STATE | this.btnClose.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-3628452a | this.btnSave.Click | FP00770_ExcelPopup.cs:408 | if (DoSaveData != null) ▸ try ▸ if (expect_count < 1) | STATE | this.btnFind.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-562333c5 | this.btnSave.Click | FP00770_ExcelPopup.cs:409 | if (DoSaveData != null) ▸ try ▸ if (expect_count < 1) | STATE | this.btnDownload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-0b7ff44d | this.btnSave.Click | FP00770_ExcelPopup.cs:410 | if (DoSaveData != null) ▸ try ▸ if (expect_count < 1) | STATE | this.btnUpload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-a9003223 | this.btnSave.Click | FP00770_ExcelPopup.cs:411 | if (DoSaveData != null) ▸ try ▸ if (expect_count < 1) | STATE | this.btnSave.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-1d64e1c0 | this.btnSave.Click | FP00770_ExcelPopup.cs:412 | if (DoSaveData != null) ▸ try ▸ if (expect_count < 1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6b32eefb | this.btnSave.Click | FP00770_ExcelPopup.cs:415 | if (DoSaveData != null) ▸ try | FLAG | validation | null | 화면 필드/플래그 변경 |  |  |  |
| AC-f7ca3588 | this.btnSave.Click | FP00770_ExcelPopup.cs:418 | if (DoSaveData != null) ▸ try ▸ if (DoValidationData != null) | FLAG | validation | DoValidationData(main, this) | 화면 필드/플래그 변경 |  |  |  |
| AC-8ae421c1 | this.btnSave.Click | FP00770_ExcelPopup.cs:418 | if (DoSaveData != null) ▸ try ▸ if (DoValidationData != null) | CALL_BASE | DoValidationData | (main, this) | ⚠ 의미 확인 필요 |  |  |  |
| AC-5e108957 | this.btnSave.Click | FP00770_ExcelPopup.cs:452 | if (DoSaveData != null) ▸ try ▸ if (valid) | CALL_BASE | DoSaveData | (main, this) | ⚠ 의미 확인 필요 |  |  |  |
| AC-53457db2 | this.btnSave.Click | FP00770_ExcelPopup.cs:464 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ try | DATA_OP | result.Tables[0].Columns.Contains | ("RESULT") | 데이터 객체 조작/조회 |  |  |  |
| AC-8b308a4c | this.btnSave.Click | FP00770_ExcelPopup.cs:466 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ try | DATA_OP | result.Tables[0].Columns.Contains | ("COUNT") | 데이터 객체 조작/조회 |  |  |  |
| AC-8fe8d200 | this.btnSave.Click | FP00770_ExcelPopup.cs:468 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ try | DATA_OP | result.Tables[0].Columns.Contains | ("EXCEPTION") | 데이터 객체 조작/조회 |  |  |  |
| AC-d6755535 | this.btnSave.Click | FP00770_ExcelPopup.cs:472 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ try ▸ if (!string.IsNullOrWhiteSpace(exception)) | MESSAGE | MessageBox.Show | ("Validation error :" + exception) | 메시지 표시 |  |  |  |
| AC-1751a030 | this.btnSave.Click | FP00770_ExcelPopup.cs:487 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ try ▸ if (result_string != "SUCCESS") | MESSAGE | MessageBox.Show | (string.Format("Save Error")) | 메시지 표시 |  |  |  |
| AC-92ff2068 | this.btnSave.Click | FP00770_ExcelPopup.cs:488 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ try ▸ if (result_string != "SUCCESS") | FLAG | this.hasError | true | 화면 필드/플래그 변경 |  |  |  |
| AC-8a929657 | this.btnSave.Click | FP00770_ExcelPopup.cs:492 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ try ▸ else of (result_string != "SUCCESS") | MESSAGE | MessageBox.Show | (string.Format("Data Saved")) | 메시지 표시 |  |  |  |
| AC-22eb96d3 | this.btnSave.Click | FP00770_ExcelPopup.cs:493 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ try ▸ else of (result_string != "SUCCESS") | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-0830a927 | this.btnSave.Click | FP00770_ExcelPopup.cs:498 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ catch ((Exception e)) | MESSAGE | MessageBox.Show | ("Unknown validation error :" + e.Message) | 메시지 표시 |  |  |  |
| AC-45c1d2cf | this.btnSave.Click | FP00770_ExcelPopup.cs:520 | if (DoSaveData != null) ▸ try ▸ else of (result.Good()) ▸ if (validation != null) ▸ if (xlsSrc.Rows.Count >= valSrc.Rows.Count) ▸ for (i < v… | DATA_OP | xlsrow["MESSAGE"] | valrow["_MSG"] | 행/컬럼 값 대입 |  |  |  |
| AC-5ed9594b | this.btnSave.Click | FP00770_ExcelPopup.cs:521 | if (DoSaveData != null) ▸ try ▸ else of (result.Good()) ▸ if (validation != null) ▸ if (xlsSrc.Rows.Count >= valSrc.Rows.Count) ▸ for (i < v… | CALL_EXT | siMain.SetRowColor | (i, System.Drawing.Color.PaleVioletRed) | ⚠ 의미 확인 필요 |  |  |  |
| AC-16236c79 | this.btnSave.Click | FP00770_ExcelPopup.cs:522 | if (DoSaveData != null) ▸ try ▸ else of (result.Good()) ▸ if (validation != null) ▸ if (xlsSrc.Rows.Count >= valSrc.Rows.Count) ▸ for (i < v… | FLAG | this.hasError | true | 화면 필드/플래그 변경 |  |  |  |
| AC-b5af191f | this.btnSave.Click | FP00770_ExcelPopup.cs:528 | if (DoSaveData != null) ▸ try ▸ else of (result.Good()) ▸ if (validation != null) | MESSAGE | MessageBox.Show | (string.Format("There are invalid data.")) | 메시지 표시 |  |  |  |
| AC-c7bfd3e6 | this.btnSave.Click | FP00770_ExcelPopup.cs:532 | if (DoSaveData != null) ▸ try ▸ else of (result.Good()) ▸ else of (validation != null) | MESSAGE | MessageBox.Show | (string.Format("Save Fail")) | 메시지 표시 |  |  |  |
| AC-e9019d0b | this.btnSave.Click | FP00770_ExcelPopup.cs:538 | if (DoSaveData != null) ▸ catch ((Exception e)) | MESSAGE | MessageBox.Show | (string.Format("Save Fail:" + e.Message)) | 메시지 표시 |  |  |  |
| AC-03ad6716 | this.btnSave.Click | FP00770_ExcelPopup.cs:539 | if (DoSaveData != null) ▸ catch ((Exception e)) | FLAG | this.hasError | true | 화면 필드/플래그 변경 |  |  |  |
| AC-75a48a9a | this.btnSave.Click | FP00770_ExcelPopup.cs:544 | if (DoSaveData != null) ▸ finally | STATE | this.spdMain.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-17ccf53e | this.btnSave.Click | FP00770_ExcelPopup.cs:545 | if (DoSaveData != null) ▸ finally | STATE | this.btnClose.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-aa390361 | this.btnSave.Click | FP00770_ExcelPopup.cs:546 | if (DoSaveData != null) ▸ finally | STATE | this.btnFind.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-9f8a802e | this.btnSave.Click | FP00770_ExcelPopup.cs:547 | if (DoSaveData != null) ▸ finally | STATE | this.btnDownload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-9ddce874 | this.btnSave.Click | FP00770_ExcelPopup.cs:548 | if (DoSaveData != null) ▸ finally | STATE | this.btnUpload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-2feb700f | this.btnSave.Click | FP00770_ExcelPopup.cs:549 | if (DoSaveData != null) ▸ finally | STATE | this.btnSave.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## FP00770_ExcelPopup.SetSpreadInit

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b41cc0b8 | this.Load | FP00770_ExcelPopup.cs:217 |  | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-faef15b2 | this.Load | FP00770_ExcelPopup.cs:218 |  | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |

## FP00770_Prod_Result_WO_ERP..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-eaacda31 | .ctor | FP00770_Prod_Result_WO_ERP.cs:171 |  | UI_PROP | this.DeleteOperation | DeleteOperationKind.ToZero | 속성 DeleteOperation 설정 |  |  |  |
| AC-1631960c | .ctor | FP00770_Prod_Result_WO_ERP.cs:172 |  | FLAG | CurrentUser | UserInfoContext.Current.UserId | 화면 필드/플래그 변경 |  |  |  |

## FP00770_Prod_Result_WO_ERP.btnExcelImport_Click

진입점: this.btnExcelImport.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dba58979 | this.btnExcelImport.Click | FP00770_Prod_Result_WO_ERP.cs:1484 | if (!FindDone) | MESSAGE | MessageBox.Show | ("You need to Find(F5) before import excel") | 메시지 표시 |  |  |  |
| AC-a6d3b67b | this.btnExcelImport.Click | FP00770_Prod_Result_WO_ERP.cs:1485 | if (!FindDone) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b21ab855 | this.btnExcelImport.Click | FP00770_Prod_Result_WO_ERP.cs:1488 |  | POPUP | new FP00770_ExcelPopup |  | 팝업/폼 생성 |  |  |  |
| AC-9a7891f0 | this.btnExcelImport.Click | FP00770_Prod_Result_WO_ERP.cs:1490 |  | FLAG | Filter | Filter.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-f8a25b13 | this.btnExcelImport.Click | FP00770_Prod_Result_WO_ERP.cs:1490 |  | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-c2f16fd2 | this.btnExcelImport.Click | FP00770_Prod_Result_WO_ERP.cs:1494 |  | GRID_SET | rowPopup.KeyColumns["Company_id"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-6f83facf | this.btnExcelImport.Click | FP00770_Prod_Result_WO_ERP.cs:1495 |  | GRID_SET | rowPopup.KeyColumns["DIVISION_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-ea4589a5 | this.btnExcelImport.Click | FP00770_Prod_Result_WO_ERP.cs:1496 |  | GRID_SET | rowPopup.KeyColumns["SITE_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-7961a446 | this.btnExcelImport.Click | FP00770_Prod_Result_WO_ERP.cs:1497 |  | GRID_SET | rowPopup.KeyColumns["PLANT_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-140ec399 | this.btnExcelImport.Click | FP00770_Prod_Result_WO_ERP.cs:1498 |  | GRID_SET | rowPopup.KeyColumns["FACTORY_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-a144d29d | this.btnExcelImport.Click | FP00770_Prod_Result_WO_ERP.cs:1499 |  | GRID_SET | rowPopup.KeyColumns["CUTOFF_DATE"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-d43478a9 | this.btnExcelImport.Click | FP00770_Prod_Result_WO_ERP.cs:1500 |  | GRID_SET | rowPopup.KeyColumns["OPERATION_ID"] | false | 그리드 속성/값 설정 |  |  |  |
| AC-4aaceea2 | this.btnExcelImport.Click | FP00770_Prod_Result_WO_ERP.cs:1501 |  | GRID_SET | rowPopup.KeyColumns["LINE_ID"] | false | 그리드 속성/값 설정 |  |  |  |
| AC-cc247dc4 | this.btnExcelImport.Click | FP00770_Prod_Result_WO_ERP.cs:1502 |  | GRID_SET | rowPopup.KeyColumns["LINE_NAME"] | false | 그리드 속성/값 설정 |  |  |  |
| AC-4eb75057 | this.btnExcelImport.Click | FP00770_Prod_Result_WO_ERP.cs:1504 |  | GRID_SET | rowPopup.KeyColumns["ITEM_ID"] | false | 그리드 속성/값 설정 |  |  |  |
| AC-2f37e207 | this.btnExcelImport.Click | FP00770_Prod_Result_WO_ERP.cs:1505 |  | GRID_SET | rowPopup.KeyColumns["NICK_NAME"] | false | 그리드 속성/값 설정 |  |  |  |
| AC-810600c2 | this.btnExcelImport.Click | FP00770_Prod_Result_WO_ERP.cs:1508 |  | GRID_SET | rowPopup.KeyColumns["WORK_ORDER_ID"] | false | 그리드 속성/값 설정 |  |  |  |
| AC-4007301f | this.btnExcelImport.Click | FP00770_Prod_Result_WO_ERP.cs:1509 |  | GRID_SET | rowPopup.KeyColumns["ORDER_TYPE"] | false | 그리드 속성/값 설정 |  |  |  |
| AC-10132073 | this.btnExcelImport.Click | FP00770_Prod_Result_WO_ERP.cs:1511 |  | GRID_SET | rowPopup.KeyColumns["PLAN_DATE"] | false | 그리드 속성/값 설정 |  |  |  |
| AC-3e756e69 | this.btnExcelImport.Click | FP00770_Prod_Result_WO_ERP.cs:1512 |  | GRID_SET | rowPopup.KeyColumns["PLAN_START_TIME"] | false | 그리드 속성/값 설정 |  |  |  |
| AC-49216e35 | this.btnExcelImport.Click | FP00770_Prod_Result_WO_ERP.cs:1513 |  | GRID_SET | rowPopup.KeyColumns["PLAN_END_TIME"] | false | 그리드 속성/값 설정 |  |  |  |
| AC-3833413d | this.btnExcelImport.Click | FP00770_Prod_Result_WO_ERP.cs:1515 |  | GRID_SET | rowPopup.KeyColumns["ACTUAL_START_TIME"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-a9f1439d | this.btnExcelImport.Click | FP00770_Prod_Result_WO_ERP.cs:1516 |  | GRID_SET | rowPopup.KeyColumns["ACTUAL_END_TIME"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-c51abb2a | this.btnExcelImport.Click | FP00770_Prod_Result_WO_ERP.cs:1518 |  | GRID_SET | rowPopup.KeyColumns["PLAN_QTY"] | false | 그리드 속성/값 설정 |  |  |  |
| AC-9475068a | this.btnExcelImport.Click | FP00770_Prod_Result_WO_ERP.cs:1519 |  | GRID_SET | rowPopup.KeyColumns["ACTUAL_QTY"] | false | 그리드 속성/값 설정 |  |  |  |
| AC-bd0582bf | this.btnExcelImport.Click | FP00770_Prod_Result_WO_ERP.cs:1520 |  | GRID_SET | rowPopup.KeyColumns["REMAIN_QTY"] | false | 그리드 속성/값 설정 |  |  |  |
| AC-2a14eb5c | this.btnExcelImport.Click | FP00770_Prod_Result_WO_ERP.cs:1522 |  | GRID_SET | rowPopup.KeyColumns["WO_STATUS"] | false | 그리드 속성/값 설정 |  |  |  |
| AC-cf79b268 | this.btnExcelImport.Click | FP00770_Prod_Result_WO_ERP.cs:1523 |  | GRID_SET | rowPopup.KeyColumns["MESSAGE"] | false | 그리드 속성/값 설정 |  |  |  |
| AC-ceb1b284 | this.btnExcelImport.Click | FP00770_Prod_Result_WO_ERP.cs:1528 |  | DATA_OP | rowPopup.ColumnTitle["COMPANY_ID"] | "company" | 행/컬럼 값 대입 |  |  |  |
| AC-e4c850de | this.btnExcelImport.Click | FP00770_Prod_Result_WO_ERP.cs:1529 |  | DATA_OP | rowPopup.ColumnTitle["DIVISION_ID"] | "Division" | 행/컬럼 값 대입 |  |  |  |
| AC-8676edc4 | this.btnExcelImport.Click | FP00770_Prod_Result_WO_ERP.cs:1530 |  | DATA_OP | rowPopup.ColumnTitle["SITE_ID"] | "Site" | 행/컬럼 값 대입 |  |  |  |
| AC-472089f0 | this.btnExcelImport.Click | FP00770_Prod_Result_WO_ERP.cs:1531 |  | DATA_OP | rowPopup.ColumnTitle["PLANT_ID"] | "Plant" | 행/컬럼 값 대입 |  |  |  |
| AC-75f48bc8 | this.btnExcelImport.Click | FP00770_Prod_Result_WO_ERP.cs:1532 |  | DATA_OP | rowPopup.ColumnTitle["FACTORY_ID"] | "Factory" | 행/컬럼 값 대입 |  |  |  |
| AC-b29e6d90 | this.btnExcelImport.Click | FP00770_Prod_Result_WO_ERP.cs:1533 |  | DATA_OP | rowPopup.ColumnTitle["CUTOFF_DATE"] | "CutOff Date" | 행/컬럼 값 대입 |  |  |  |
| AC-72d7fdfe | this.btnExcelImport.Click | FP00770_Prod_Result_WO_ERP.cs:1534 |  | DATA_OP | rowPopup.ColumnTitle["OPERATION_ID"] | "Operation" | 행/컬럼 값 대입 |  |  |  |
| AC-6cf16597 | this.btnExcelImport.Click | FP00770_Prod_Result_WO_ERP.cs:1535 |  | DATA_OP | rowPopup.ColumnTitle["LINE_ID"] | "Line" | 행/컬럼 값 대입 |  |  |  |
| AC-dafe2c63 | this.btnExcelImport.Click | FP00770_Prod_Result_WO_ERP.cs:1536 |  | DATA_OP | rowPopup.ColumnTitle["LINE_NAME"] | "Line Name" | 행/컬럼 값 대입 |  |  |  |
| AC-3c9ed78c | this.btnExcelImport.Click | FP00770_Prod_Result_WO_ERP.cs:1537 |  | DATA_OP | rowPopup.ColumnTitle["ITEM_ID"] | "Material" | 행/컬럼 값 대입 |  |  |  |
| AC-06110227 | this.btnExcelImport.Click | FP00770_Prod_Result_WO_ERP.cs:1538 |  | DATA_OP | rowPopup.ColumnTitle["NICK_NAME"] | "Nick Name" | 행/컬럼 값 대입 |  |  |  |
| AC-8d5ba859 | this.btnExcelImport.Click | FP00770_Prod_Result_WO_ERP.cs:1539 |  | DATA_OP | rowPopup.ColumnTitle["WORK_ORDER_ID"] | "WO" | 행/컬럼 값 대입 |  |  |  |
| AC-f46f1f55 | this.btnExcelImport.Click | FP00770_Prod_Result_WO_ERP.cs:1540 |  | DATA_OP | rowPopup.ColumnTitle["ORDER_TYPE"] | "WO Type" | 행/컬럼 값 대입 |  |  |  |
| AC-2921e4c4 | this.btnExcelImport.Click | FP00770_Prod_Result_WO_ERP.cs:1541 |  | DATA_OP | rowPopup.ColumnTitle["PLAN_DATE"] | "Plan Date" | 행/컬럼 값 대입 |  |  |  |
| AC-9456cff5 | this.btnExcelImport.Click | FP00770_Prod_Result_WO_ERP.cs:1542 |  | DATA_OP | rowPopup.ColumnTitle["PLAN_START_TIME"] | "Start Time" | 행/컬럼 값 대입 |  |  |  |
| AC-2cec9af5 | this.btnExcelImport.Click | FP00770_Prod_Result_WO_ERP.cs:1543 |  | DATA_OP | rowPopup.ColumnTitle["PLAN_END_TIME"] | "End Time" | 행/컬럼 값 대입 |  |  |  |
| AC-152a102b | this.btnExcelImport.Click | FP00770_Prod_Result_WO_ERP.cs:1544 |  | DATA_OP | rowPopup.ColumnTitle["ACTUAL_START_TIME"] | "Start Time" | 행/컬럼 값 대입 |  |  |  |
| AC-ab329ab0 | this.btnExcelImport.Click | FP00770_Prod_Result_WO_ERP.cs:1545 |  | DATA_OP | rowPopup.ColumnTitle["ACTUAL_END_TIME"] | "End Time" | 행/컬럼 값 대입 |  |  |  |
| AC-d6232ffc | this.btnExcelImport.Click | FP00770_Prod_Result_WO_ERP.cs:1546 |  | DATA_OP | rowPopup.ColumnTitle["PLAN_QTY"] | "Original" | 행/컬럼 값 대입 |  |  |  |
| AC-e900d09d | this.btnExcelImport.Click | FP00770_Prod_Result_WO_ERP.cs:1547 |  | DATA_OP | rowPopup.ColumnTitle["ACTUAL_QTY"] | "Result" | 행/컬럼 값 대입 |  |  |  |
| AC-91413067 | this.btnExcelImport.Click | FP00770_Prod_Result_WO_ERP.cs:1548 |  | DATA_OP | rowPopup.ColumnTitle["REMAIN_QTY"] | "Remain" | 행/컬럼 값 대입 |  |  |  |
| AC-3f3f18b4 | this.btnExcelImport.Click | FP00770_Prod_Result_WO_ERP.cs:1549 |  | DATA_OP | rowPopup.ColumnTitle["WO_STATUS"] | "Status" | 행/컬럼 값 대입 |  |  |  |
| AC-f72c4a10 | this.btnExcelImport.Click | FP00770_Prod_Result_WO_ERP.cs:1550 |  | DATA_OP | rowPopup.ColumnTitle["MESSAGE"] | "message" | 행/컬럼 값 대입 |  |  |  |
| AC-a9f313df | this.btnExcelImport.Click | FP00770_Prod_Result_WO_ERP.cs:1553 |  | DATA_OP | rowPopup.ColumnWidth["COMPANY_ID"] | 90 | 행/컬럼 값 대입 |  |  |  |
| AC-66ffca42 | this.btnExcelImport.Click | FP00770_Prod_Result_WO_ERP.cs:1554 |  | DATA_OP | rowPopup.ColumnWidth["DIVISION_ID"] | 90 | 행/컬럼 값 대입 |  |  |  |
| AC-983d49ff | this.btnExcelImport.Click | FP00770_Prod_Result_WO_ERP.cs:1555 |  | DATA_OP | rowPopup.ColumnWidth["SITE_ID"] | 90 | 행/컬럼 값 대입 |  |  |  |
| AC-8c2426ca | this.btnExcelImport.Click | FP00770_Prod_Result_WO_ERP.cs:1556 |  | DATA_OP | rowPopup.ColumnWidth["PLANT_ID"] | 90 | 행/컬럼 값 대입 |  |  |  |
| AC-eb25115d | this.btnExcelImport.Click | FP00770_Prod_Result_WO_ERP.cs:1557 |  | DATA_OP | rowPopup.ColumnWidth["FACTORY_ID"] | 90 | 행/컬럼 값 대입 |  |  |  |
| AC-48a0ea4f | this.btnExcelImport.Click | FP00770_Prod_Result_WO_ERP.cs:1558 |  | DATA_OP | rowPopup.ColumnWidth["CUTOFF_DATE"] | 100 | 행/컬럼 값 대입 |  |  |  |
| AC-475151e3 | this.btnExcelImport.Click | FP00770_Prod_Result_WO_ERP.cs:1559 |  | DATA_OP | rowPopup.ColumnWidth["OPERATION_ID"] | 90 | 행/컬럼 값 대입 |  |  |  |
| AC-32fde86a | this.btnExcelImport.Click | FP00770_Prod_Result_WO_ERP.cs:1560 |  | DATA_OP | rowPopup.ColumnWidth["LINE_ID"] | 90 | 행/컬럼 값 대입 |  |  |  |
| AC-f0820b9b | this.btnExcelImport.Click | FP00770_Prod_Result_WO_ERP.cs:1561 |  | DATA_OP | rowPopup.ColumnWidth["LINE_NAME"] | 90 | 행/컬럼 값 대입 |  |  |  |
| AC-23ba516f | this.btnExcelImport.Click | FP00770_Prod_Result_WO_ERP.cs:1562 |  | DATA_OP | rowPopup.ColumnWidth["ITEM_ID"] | 90 | 행/컬럼 값 대입 |  |  |  |
| AC-ea265c07 | this.btnExcelImport.Click | FP00770_Prod_Result_WO_ERP.cs:1563 |  | DATA_OP | rowPopup.ColumnWidth["NICK_NAME"] | 90 | 행/컬럼 값 대입 |  |  |  |
| AC-1cce582c | this.btnExcelImport.Click | FP00770_Prod_Result_WO_ERP.cs:1564 |  | DATA_OP | rowPopup.ColumnWidth["WORK_ORDER_ID"] | 90 | 행/컬럼 값 대입 |  |  |  |
| AC-5bfefcac | this.btnExcelImport.Click | FP00770_Prod_Result_WO_ERP.cs:1565 |  | DATA_OP | rowPopup.ColumnWidth["ORDER_TYPE"] | 90 | 행/컬럼 값 대입 |  |  |  |
| AC-bff2805a | this.btnExcelImport.Click | FP00770_Prod_Result_WO_ERP.cs:1566 |  | DATA_OP | rowPopup.ColumnWidth["PLAN_DATE"] | 90 | 행/컬럼 값 대입 |  |  |  |
| AC-194e2ecd | this.btnExcelImport.Click | FP00770_Prod_Result_WO_ERP.cs:1567 |  | DATA_OP | rowPopup.ColumnWidth["PLAN_START_TIME"] | 90 | 행/컬럼 값 대입 |  |  |  |
| AC-d7656408 | this.btnExcelImport.Click | FP00770_Prod_Result_WO_ERP.cs:1568 |  | DATA_OP | rowPopup.ColumnWidth["PLAN_END_TIME"] | 90 | 행/컬럼 값 대입 |  |  |  |
| AC-20ad6578 | this.btnExcelImport.Click | FP00770_Prod_Result_WO_ERP.cs:1569 |  | DATA_OP | rowPopup.ColumnWidth["ACTUAL_START_TIME"] | 90 | 행/컬럼 값 대입 |  |  |  |
| AC-6ac33bf3 | this.btnExcelImport.Click | FP00770_Prod_Result_WO_ERP.cs:1570 |  | DATA_OP | rowPopup.ColumnWidth["ACTUAL_END_TIME"] | 90 | 행/컬럼 값 대입 |  |  |  |
| AC-8facf1ec | this.btnExcelImport.Click | FP00770_Prod_Result_WO_ERP.cs:1571 |  | DATA_OP | rowPopup.ColumnWidth["PLAN_QTY"] | 90 | 행/컬럼 값 대입 |  |  |  |
| AC-2517f798 | this.btnExcelImport.Click | FP00770_Prod_Result_WO_ERP.cs:1572 |  | DATA_OP | rowPopup.ColumnWidth["ACTUAL_QTY"] | 90 | 행/컬럼 값 대입 |  |  |  |
| AC-01196da0 | this.btnExcelImport.Click | FP00770_Prod_Result_WO_ERP.cs:1573 |  | DATA_OP | rowPopup.ColumnWidth["REMAIN_QTY"] | 90 | 행/컬럼 값 대입 |  |  |  |
| AC-0fcab977 | this.btnExcelImport.Click | FP00770_Prod_Result_WO_ERP.cs:1574 |  | DATA_OP | rowPopup.ColumnWidth["WO_STATUS"] | 90 | 행/컬럼 값 대입 |  |  |  |
| AC-43a0023b | this.btnExcelImport.Click | FP00770_Prod_Result_WO_ERP.cs:1575 |  | DATA_OP | rowPopup.ColumnWidth["MESSAGE"] | 90 | 행/컬럼 값 대입 |  |  |  |
| AC-5c058a21 | this.btnExcelImport.Click | FP00770_Prod_Result_WO_ERP.cs:1578 |  | UI_PROP | rowPopup.DoSearchData | call_Excel_Row_Search | 속성 DoSearchData 설정 |  |  |  |
| AC-896d3879 | this.btnExcelImport.Click | FP00770_Prod_Result_WO_ERP.cs:1580 |  | UI_PROP | rowPopup.DoSaveData | call_Excel_Row_Save | 속성 DoSaveData 설정 |  |  |  |
| AC-f31030b5 | this.btnExcelImport.Click | FP00770_Prod_Result_WO_ERP.cs:1581 |  | UI_PROP | rowPopup.DoValidationData | call_Excel_Row_Validation | 속성 DoValidationData 설정 |  |  |  |
| AC-c105d43a | this.btnExcelImport.Click | FP00770_Prod_Result_WO_ERP.cs:1582 |  | UI_PROP | rowPopup.DoImportData | call_Excel_Row_After_Import | 속성 DoImportData 설정 |  |  |  |
| AC-fd885880 | this.btnExcelImport.Click | FP00770_Prod_Result_WO_ERP.cs:1583 |  | POPUP | rowPopup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00770_Prod_Result_WO_ERP.btnSql_Click

진입점: this.btnSql.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-96e1064c | this.btnSql.Click | FP00770_Prod_Result_WO_ERP.cs:1198 | if (true) | POPUP | new FPC0099_SqlPopup | () | 팝업/폼 생성 |  |  |  |
| AC-ad2f71d3 | this.btnSql.Click | FP00770_Prod_Result_WO_ERP.cs:1199 | if (true) | UI_PROP | popSql.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-1e0961b4 | this.btnSql.Click | FP00770_Prod_Result_WO_ERP.cs:1201 | if (true) | DATA_OP | popSql.Services.Add | ("PR_UI_FP00770_FIND_FP00770") | 데이터 객체 조작/조회 |  |  |  |
| AC-c2a681fd | this.btnSql.Click | FP00770_Prod_Result_WO_ERP.cs:1202 | if (true) | POPUP | popSql.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00770_Prod_Result_WO_ERP.call_Excel_Row_After_Import

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e2a717cb | (진입점 미연결) | FP00770_Prod_Result_WO_ERP.cs:1913 |  | DATA_OP | data.Tables[0].Columns.SafeAdd | ("_VALID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-3bed2dac | (진입점 미연결) | FP00770_Prod_Result_WO_ERP.cs:1914 |  | DATA_OP | data.Tables[0].Columns.SafeAdd | ("_MSG", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-083d9eb7 | (진입점 미연결) | FP00770_Prod_Result_WO_ERP.cs:1924 | if (AnyError) | CALL_EXT | DataService.CreateResultDataSet | (false, 0, "Validation Error") | ⚠ 의미 확인 필요 |  |  |  |
| AC-fb0e36fd | (진입점 미연결) | FP00770_Prod_Result_WO_ERP.cs:1924 | if (AnyError) | RETURN | return DataService.CreateResultDataSet(false, 0, "Validation Error"); |  | 처리 중단/반환 |  |  |  |
| AC-b4e6a535 | (진입점 미연결) | FP00770_Prod_Result_WO_ERP.cs:1926 |  | CALL_EXT | DataService.CreateResultDataSet | (true, 1, "") | ⚠ 의미 확인 필요 |  |  |  |
| AC-19ef5855 | (진입점 미연결) | FP00770_Prod_Result_WO_ERP.cs:1926 |  | RETURN | return DataService.CreateResultDataSet(true, 1, ""); |  | 처리 중단/반환 |  |  |  |

## FP00770_Prod_Result_WO_ERP.call_Excel_Row_Save

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-65377c2e | (진입점 미연결) | FP00770_Prod_Result_WO_ERP.cs:1888 | if (popup != null) ▸ try ▸ if (SaveExcelRows(data, popup.Filter, out ref_val) == true) | UI_PROP | popup.validation | ref_val | 속성 validation 설정 |  |  |  |
| AC-a8ff3047 | (진입점 미연결) | FP00770_Prod_Result_WO_ERP.cs:1889 | if (popup != null) ▸ try ▸ if (SaveExcelRows(data, popup.Filter, out ref_val) == true) | UI_PROP | popup.SaveSuccess | true | 속성 SaveSuccess 설정 |  |  |  |
| AC-fde868f8 | (진입점 미연결) | FP00770_Prod_Result_WO_ERP.cs:1890 | if (popup != null) ▸ try ▸ if (SaveExcelRows(data, popup.Filter, out ref_val) == true) | CALL_EXT | DataService.CreateResultDataSet | (true, 1, "") | ⚠ 의미 확인 필요 |  |  |  |
| AC-90017607 | (진입점 미연결) | FP00770_Prod_Result_WO_ERP.cs:1890 | if (popup != null) ▸ try ▸ if (SaveExcelRows(data, popup.Filter, out ref_val) == true) | RETURN | return DataService.CreateResultDataSet(true, 1, ""); |  | 처리 중단/반환 |  |  |  |
| AC-cfefc840 | (진입점 미연결) | FP00770_Prod_Result_WO_ERP.cs:1892 | if (popup != null) ▸ try | UI_PROP | popup.validation | ref_val | 속성 validation 설정 |  |  |  |
| AC-ccec4500 | (진입점 미연결) | FP00770_Prod_Result_WO_ERP.cs:1897 | if (popup != null) ▸ catch ((Exception e)) | CALL_EXT | DataService.CreateResultDataSet | (false, 0, e.Message) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c75a0e80 | (진입점 미연결) | FP00770_Prod_Result_WO_ERP.cs:1897 | if (popup != null) ▸ catch ((Exception e)) | RETURN | return DataService.CreateResultDataSet(false, 0, e.Message); |  | 처리 중단/반환 |  |  |  |
| AC-ba605500 | (진입점 미연결) | FP00770_Prod_Result_WO_ERP.cs:1900 |  | CALL_EXT | DataService.CreateResultDataSet | (false, 0, "") | ⚠ 의미 확인 필요 |  |  |  |
| AC-2094e191 | (진입점 미연결) | FP00770_Prod_Result_WO_ERP.cs:1900 |  | RETURN | return DataService.CreateResultDataSet(false, 0, ""); |  | 처리 중단/반환 |  |  |  |

## FP00770_Prod_Result_WO_ERP.call_Excel_Row_Search

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2bf1eea7 | (진입점 미연결) | FP00770_Prod_Result_WO_ERP.cs:1866 | if (popup != null) | ENDPOINT | DataService.FP_ExecuteProcedure | ("PR_UI_FP00770_FIND_FP00770", popup.Filter) | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-a5cb7c16 | (진입점 미연결) | FP00770_Prod_Result_WO_ERP.cs:1867 | if (popup != null) | RETURN | return m; |  | 처리 중단/반환 |  |  |  |
| AC-e3a6d5bf | (진입점 미연결) | FP00770_Prod_Result_WO_ERP.cs:1870 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00770_Prod_Result_WO_ERP.call_Excel_Row_Validation

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dc676103 | (진입점 미연결) | FP00770_Prod_Result_WO_ERP.cs:1930 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00770_Prod_Result_WO_ERP.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-07ee57a9 | this.Load | FP00770_Prod_Result_WO_ERP.cs:404 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtPlanAmendMA, SpdSheet.shtPlanAmendMA, 2, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-542fa170 | this.Load | FP00770_Prod_Result_WO_ERP.cs:405 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, SpdSheet.shtPlanAmendMA) | 화면 필드/플래그 변경 |  |  |  |
| AC-f1fd3bda | this.Load | FP00770_Prod_Result_WO_ERP.cs:406 |  | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtPlanAmendMA) | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00770_Prod_Result_WO_ERP.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-926261ae | DeleteButton | FP00770_Prod_Result_WO_ERP.cs:1039 | if (spdMain != null) | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## FP00770_Prod_Result_WO_ERP.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-976d6f02 | Dispose | FP00770_Prod_Result_WO_ERP.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00770_Prod_Result_WO_ERP.DrawHeader

진입점: this.Load / this.btnExcelImport.Click [if (rowPopup.SaveSuccess == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try ▸ if (dsMain == null)] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try ▸ if (dsMain == null)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1751a2ea | this.Load 외 2 | FP00770_Prod_Result_WO_ERP.cs:661 |  | FLAG | DayColumnCount | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-20887dea | this.Load 외 2 | FP00770_Prod_Result_WO_ERP.cs:665 | if (with_day_part == false) | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 2) | 그리드 재구성/초기화 |  |  |  |
| AC-1d605601 | this.Load 외 2 | FP00770_Prod_Result_WO_ERP.cs:666 | if (with_day_part == false) | GRID_INIT | siMain.ColumnHeaderHeight | (0, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-fa9523c2 | this.Load 외 2 | FP00770_Prod_Result_WO_ERP.cs:667 | if (with_day_part == false) | GRID_INIT | siMain.ColumnHeaderHeight | (1, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-fc4cb3d2 | this.Load 외 2 | FP00770_Prod_Result_WO_ERP.cs:668 | if (with_day_part == false) | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-33626c7f | this.Load 외 2 | FP00770_Prod_Result_WO_ERP.cs:669 | if (with_day_part == false) | FLAG | DayColumnCount | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-77a5a01c | this.Load 외 2 | FP00770_Prod_Result_WO_ERP.cs:673 | else of (with_day_part == false) | FLAG | calendar | new AmendCalendar() | 화면 필드/플래그 변경 |  |  |  |
| AC-60e79437 | this.Load 외 2 | FP00770_Prod_Result_WO_ERP.cs:674 | else of (with_day_part == false) | UI_PROP | calendar.MonthInfo | monthInfo | 속성 MonthInfo 설정 |  |  |  |
| AC-5f22e9ea | this.Load 외 2 | FP00770_Prod_Result_WO_ERP.cs:675 | else of (with_day_part == false) | UI_PROP | calendar.WeekInfo | weekInfo | 속성 WeekInfo 설정 |  |  |  |
| AC-9dbb3e1e | this.Load 외 2 | FP00770_Prod_Result_WO_ERP.cs:676 | else of (with_day_part == false) | UI_PROP | calendar.DateMap | dateMap | 속성 DateMap 설정 |  |  |  |
| AC-a96ab96c | this.Load 외 2 | FP00770_Prod_Result_WO_ERP.cs:688 | else of (with_day_part == false) | FLAG | DayColumnCount | calendar.GetColumnCount(use_month, use_week, use_day) | 화면 필드/플래그 변경 |  |  |  |
| AC-3d351391 | this.Load 외 2 | FP00770_Prod_Result_WO_ERP.cs:689 | else of (with_day_part == false) | CALL_EXT | calendar.GetStartDate | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-fb510a84 | this.Load 외 2 | FP00770_Prod_Result_WO_ERP.cs:695 | else of (with_day_part == false) ▸ if (sdate != measure.StartDate) | VALUE_SET | measure.StartDate | sdate | 컨트롤 값 설정 |  |  |  |
| AC-124775c2 | this.Load 외 2 | FP00770_Prod_Result_WO_ERP.cs:722 | else of (with_day_part == false) ▸ if (refreshColumn) | CALL_EXT | MeasureService.LoadAmendColumn | (measure, calendar, SpdSheet.PROGID + "_" + SpdSheet.shtPlanAmendMA, appendix) | ⚠ 의미 확인 필요 |  |  |  |
| AC-7d6acace | this.Load 외 2 | FP00770_Prod_Result_WO_ERP.cs:728 | else of (with_day_part == false) ▸ if (refreshColumn) | CALL_EXT | siMain.SetAmendHeaderColumn_FP | (measure.AmendColumns, calendar, use_month, use_week, use_day, 2, "") | ⚠ 의미 확인 필요 |  |  |  |
| AC-77b62db1 | this.Load 외 2 | FP00770_Prod_Result_WO_ERP.cs:730 | else of (with_day_part == false) ▸ if (refreshColumn) | GRID_INIT | siMain.ColumnHeaderHeight | (0, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1e18637b | this.Load 외 2 | FP00770_Prod_Result_WO_ERP.cs:731 | else of (with_day_part == false) ▸ if (refreshColumn) | GRID_INIT | siMain.ColumnHeaderHeight | (1, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1b55aa35 | this.Load 외 2 | FP00770_Prod_Result_WO_ERP.cs:732 | else of (with_day_part == false) ▸ if (refreshColumn) | FLAG | last_col | siMain.GetMaxColumnIndex() | 화면 필드/플래그 변경 |  |  |  |
| AC-161fd762 | this.Load 외 2 | FP00770_Prod_Result_WO_ERP.cs:734 | else of (with_day_part == false) ▸ if (refreshColumn) | GRID_SET | siMain.ActiveSheet.FrozenColumnCount | last_col - DayColumnCount + 1 | 그리드 속성/값 설정 |  |  |  |
| AC-95d4571d | this.Load 외 2 | FP00770_Prod_Result_WO_ERP.cs:736 | else of (with_day_part == false) ▸ if (refreshColumn) | UI_PROP | siMain.MergeVerticalAlignment | CellVerticalAlignment.Top | 속성 MergeVerticalAlignment 설정 |  |  |  |
| AC-ff981098 | this.Load 외 2 | FP00770_Prod_Result_WO_ERP.cs:737 | else of (with_day_part == false) ▸ if (refreshColumn) | CALL_EXT | siMain.SetRightMerge | (siMain.ActiveSheet.FrozenColumnCount) | ⚠ 의미 확인 필요 |  |  |  |

## FP00770_Prod_Result_WO_ERP.DrawSheet

진입점: this.btnExcelImport.Click [if (rowPopup.SaveSuccess == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try ▸ else of (dsMain == null)] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try ▸ else of (dsMain == null)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4acf9b07 | this.btnExcelImport.Click [if (rowPopup.SaveSuccess == true)… 외 1 | FP00770_Prod_Result_WO_ERP.cs:746 | if (!siMain.SpreadObject.IsLayoutSuspended) | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-2e45d961 | this.btnExcelImport.Click [if (rowPopup.SaveSuccess == true)… 외 1 | FP00770_Prod_Result_WO_ERP.cs:749 | if (!in_Dataset.Good()) | CALL_EXT | siMain.EditQuery | (in_Dataset) | ⚠ 의미 확인 필요 |  |  |  |
| AC-7621cf13 | this.btnExcelImport.Click [if (rowPopup.SaveSuccess == true)… 외 1 | FP00770_Prod_Result_WO_ERP.cs:750 | if (!in_Dataset.Good()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d61248ce | this.btnExcelImport.Click [if (rowPopup.SaveSuccess == true)… 외 1 | FP00770_Prod_Result_WO_ERP.cs:757 |  | CALL_EXT | siMain.EditQuery | (in_Dataset) | ⚠ 의미 확인 필요 |  |  |  |
| AC-dce67209 | this.btnExcelImport.Click [if (rowPopup.SaveSuccess == true)… 외 1 | FP00770_Prod_Result_WO_ERP.cs:759 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-524b8c17 | this.btnExcelImport.Click [if (rowPopup.SaveSuccess == true)… 외 1 | FP00770_Prod_Result_WO_ERP.cs:766 | if (dsMainFiltered.Good()) ▸ if (SP_DataSource == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-dbdaaa7a | this.btnExcelImport.Click [if (rowPopup.SaveSuccess == true)… 외 1 | FP00770_Prod_Result_WO_ERP.cs:776 | if (dsMainFiltered.Good()) ▸ for (i < SP_DataSource.Tables[0].Rows.Count) ▸ if (select_measure == null \|\| select_measure == "19000101") | GRID_SET | SP_DataSource.Tables[0].Rows[i][idx_PLAN_DATE] | select_measure | 그리드 속성/값 설정 |  |  |  |
| AC-0fe5bfa6 | this.btnExcelImport.Click [if (rowPopup.SaveSuccess == true)… 외 1 | FP00770_Prod_Result_WO_ERP.cs:790 | if (dsMainFiltered.Good()) | UI_PROP | num.DecimalPlaces | Place | 속성 DecimalPlaces 설정 |  |  |  |
| AC-c60680e9 | this.btnExcelImport.Click [if (rowPopup.SaveSuccess == true)… 외 1 | FP00770_Prod_Result_WO_ERP.cs:794 | if (dsMainFiltered.Good()) ▸ if (idx_PLAN_QTY != -1) | GRID_SET | siMain.ActiveSheet.Columns[idx_PLAN_QTY].CellType | num | 그리드 속성/값 설정 |  |  |  |
| AC-658adfc3 | this.btnExcelImport.Click [if (rowPopup.SaveSuccess == true)… 외 1 | FP00770_Prod_Result_WO_ERP.cs:799 | if (dsMainFiltered.Good()) ▸ if (idx_ACTUAL_QTY != -1) | GRID_SET | siMain.ActiveSheet.Columns[idx_ACTUAL_QTY].CellType | num | 그리드 속성/값 설정 |  |  |  |
| AC-5587b51c | this.btnExcelImport.Click [if (rowPopup.SaveSuccess == true)… 외 1 | FP00770_Prod_Result_WO_ERP.cs:804 | if (dsMainFiltered.Good()) ▸ if (idx_REMAIN_QTY != -1) | GRID_SET | siMain.ActiveSheet.Columns[idx_REMAIN_QTY].CellType | num | 그리드 속성/값 설정 |  |  |  |

## FP00770_Prod_Result_WO_ERP.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6814930c | EditButton | FP00770_Prod_Result_WO_ERP.cs:1047 | if (spdMain != null) | MESSAGE | MessageBox.Show | ("You already in edit mode.\r\n(In Plan Amend screen,You always in edit mode while you hav… | 메시지 표시 |  |  |  |
| AC-862e4200 | EditButton | FP00770_Prod_Result_WO_ERP.cs:1049 |  | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtPlanAmendMA, false) | 그리드 편집 잠금/해제 |  |  |  |

## FP00770_Prod_Result_WO_ERP.ExcelButton

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-98ecd281 | ExcelButton | FP00770_Prod_Result_WO_ERP.cs:1240 |  | POPUP | new FPC0109_ExcelSelect_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-4df873da | ExcelButton | FP00770_Prod_Result_WO_ERP.cs:1241 |  | VALUE_SET | select_popup.Text | "SELECT Excel Export Option" | 컨트롤 값 설정 |  |  |  |
| AC-95a6e4bd | ExcelButton | FP00770_Prod_Result_WO_ERP.cs:1243 |  | POPUP | select_popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-4da77ee2 | ExcelButton | FP00770_Prod_Result_WO_ERP.cs:1247 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.Merge | select_popup.MergeSelection | 속성 Merge 설정 |  |  |  |
| AC-9436bdf3 | ExcelButton | FP00770_Prod_Result_WO_ERP.cs:1248 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.Border | select_popup.LineSelection | 속성 Border 설정 |  |  |  |
| AC-fbb88de6 | ExcelButton | FP00770_Prod_Result_WO_ERP.cs:1249 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.AmendZeroOption | select_popup.ZeroSelection | 속성 AmendZeroOption 설정 |  |  |  |
| AC-a285a07d | ExcelButton | FP00770_Prod_Result_WO_ERP.cs:1252 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.AheadZeroOption | ZeroOption.HideZero | 속성 AheadZeroOption 설정 |  |  |  |
| AC-295b3946 | ExcelButton | FP00770_Prod_Result_WO_ERP.cs:1253 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.AmendNullToZero | true | 속성 AmendNullToZero 설정 |  |  |  |
| AC-f7cbccc7 | ExcelButton | FP00770_Prod_Result_WO_ERP.cs:1254 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.AheadNullToZero | false | 속성 AheadNullToZero 설정 |  |  |  |
| AC-d79ed070 | ExcelButton | FP00770_Prod_Result_WO_ERP.cs:1256 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.UserName | UserInfo.UserId | 속성 UserName 설정 |  |  |  |
| AC-538a92f9 | ExcelButton | FP00770_Prod_Result_WO_ERP.cs:1257 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.FileName | sFileName | 속성 FileName 설정 |  |  |  |
| AC-54e2edc1 | ExcelButton | FP00770_Prod_Result_WO_ERP.cs:1260 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.AmendDecimalFormat | "#,##0.##########;[red]-#,##0.##########" | 속성 AmendDecimalFormat 설정 |  |  |  |
| AC-5f4d0334 | ExcelButton | FP00770_Prod_Result_WO_ERP.cs:1272 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ try | CALL_EXT | SimplexelService.ExportFpSpread | (fps, exportOption) | ⚠ 의미 확인 필요 |  |  |  |
| AC-338b3322 | ExcelButton | FP00770_Prod_Result_WO_ERP.cs:1276 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-77fd0c99 | ExcelButton | FP00770_Prod_Result_WO_ERP.cs:1280 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00770_Prod_Result_WO_ERP.FindMainData

진입점: popSql.OnSql [if (programID == "PR_UI_FP00770_FIND_FP00770")] / this.btnExcelImport.Click [if (rowPopup.SaveSuccess == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3bfce672 | popSql.OnSql [if (programID == "PR_UI_FP00770_FIND_FP00770")… 외 2 | FP00770_Prod_Result_WO_ERP.cs:1460 | try | ENDPOINT | DataService.FP_ExecuteProcedure | ("PR_UI_FP00770_FIND_FP00770", Filter, p_sys_type) | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-3391f8d9 | popSql.OnSql [if (programID == "PR_UI_FP00770_FIND_FP00770")… 외 2 | FP00770_Prod_Result_WO_ERP.cs:1469 | try | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |
| AC-2008911b | popSql.OnSql [if (programID == "PR_UI_FP00770_FIND_FP00770")… 외 2 | FP00770_Prod_Result_WO_ERP.cs:1475 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |

## FP00770_Prod_Result_WO_ERP.FindSubTotalColorStart

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dd1af58b | (진입점 미연결) | FP00770_Prod_Result_WO_ERP.cs:829 |  | RETURN | return 0; |  | 처리 중단/반환 |  |  |  |
| AC-e917cb4d | (진입점 미연결) | FP00770_Prod_Result_WO_ERP.cs:833 | if (op > -1) | RETURN | return op + 1; |  | 처리 중단/반환 |  |  |  |
| AC-1ef8a0a0 | (진입점 미연결) | FP00770_Prod_Result_WO_ERP.cs:840 |  | RETURN | return start + 1; |  | 처리 중단/반환 |  |  |  |

## FP00770_Prod_Result_WO_ERP.FindTotalColorStart

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-650560e3 | (진입점 미연결) | FP00770_Prod_Result_WO_ERP.cs:817 | if (op > -1) | RETURN | return op + 1; |  | 처리 중단/반환 |  |  |  |
| AC-e78f9c8f | (진입점 미연결) | FP00770_Prod_Result_WO_ERP.cs:824 |  | RETURN | return start + 1; |  | 처리 중단/반환 |  |  |  |

## FP00770_Prod_Result_WO_ERP.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ab7cb3c7 | this.Load | FP00770_Prod_Result_WO_ERP.cs:213 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00770_Prod_Result_WO_ERP.GetDivision

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-54dd864d | this.Load [try] | FP00770_Prod_Result_WO_ERP.cs:1321 |  | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-aca917b0 | this.Load [try] | FP00770_Prod_Result_WO_ERP.cs:1322 |  | FLAG | dtDivision | DataService.GetInnerTable("DIVISION_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-640885c1 | this.Load [try] | FP00770_Prod_Result_WO_ERP.cs:1322 |  | COMBO_DATA | DataService.GetInnerTable | ("DIVISION_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-c7f7441c | this.Load [try] | FP00770_Prod_Result_WO_ERP.cs:1323 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, mcbo_division, false) | 목록 컨트롤 재구성 |  |  |  |

## FP00770_Prod_Result_WO_ERP.GetFactory

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e15b98ac | (진입점 미연결) | FP00770_Prod_Result_WO_ERP.cs:1346 |  | FLAG | dtFactoryAmend | Data_FP.Common_FP(Data_FP.Type.FACTORY_CODE, false, CurrentUser, _sNonAuth, _sSaveAuth , F… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY_CODE] | 화면 필드/플래그 변경 |  |  |  |
| AC-3fd1bc24 | (진입점 미연결) | FP00770_Prod_Result_WO_ERP.cs:1346 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.FACTORY_CODE, false, CurrentUser, _sNonAuth, _sSaveAuth , Filter["INSTANCE_I… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY_CODE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-a1ac7003 | (진입점 미연결) | FP00770_Prod_Result_WO_ERP.cs:1351 |  | LIST_REBIND | clsCtrl.setListBox | (dtFactoryAmend, mcbo_factory, false) | 목록 컨트롤 재구성 |  |  |  |

## FP00770_Prod_Result_WO_ERP.GetFilter

진입점: this.btnExcelImport.Click [if (rowPopup.SaveSuccess == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3bb4e078 | this.btnExcelImport.Click [if (rowPopup.SaveSuccess == true)… 외 1 | FP00770_Prod_Result_WO_ERP.cs:1314 |  | RETURN | return Filter[key]; |  | 처리 중단/반환 |  |  |  |

## FP00770_Prod_Result_WO_ERP.GetLine

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c1e312b0 | (진입점 미연결) | FP00770_Prod_Result_WO_ERP.cs:1369 | try | FLAG | dtLine | Data_FP.Common_FP(Data_FP.Type.LINE, false, UserInfoContext.Current.UserId, _sNonAuth, _sS… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=LINE] | 화면 필드/플래그 변경 |  |  |  |
| AC-5c93dd27 | (진입점 미연결) | FP00770_Prod_Result_WO_ERP.cs:1369 | try | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.LINE, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth, "", "", … ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=LINE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-9b7533e0 | (진입점 미연결) | FP00770_Prod_Result_WO_ERP.cs:1372 | try | LIST_REBIND | clsCtrl.setListBox | (dtLine, mcbo_line, false) | 목록 컨트롤 재구성 |  |  |  |
| AC-5776fd6b | (진입점 미연결) | FP00770_Prod_Result_WO_ERP.cs:1378 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |

## FP00770_Prod_Result_WO_ERP.GetOperation

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d357f889 | (진입점 미연결) | FP00770_Prod_Result_WO_ERP.cs:1357 |  | FLAG | dtOperation | Data_FP.Common_FP(Data_FP.Type.OPERATION, false, UserInfoContext.Current.UserId, _sNonAuth… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=OPERATION] | 화면 필드/플래그 변경 |  |  |  |
| AC-644d0a2e | (진입점 미연결) | FP00770_Prod_Result_WO_ERP.cs:1357 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.OPERATION, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth, "",… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=OPERATION] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-740f6033 | (진입점 미연결) | FP00770_Prod_Result_WO_ERP.cs:1360 |  | LIST_REBIND | clsCtrl.setListBox | (dtOperation, mcbo_operation, false) | 목록 컨트롤 재구성 |  |  |  |

## FP00770_Prod_Result_WO_ERP.GetPlant

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-eeeae189 | (진입점 미연결) | FP00770_Prod_Result_WO_ERP.cs:1337 |  | FLAG | dtPlant | Data_FP.Common_FP(Data_FP.Type.PLANT, false, CurrentUser, _sNonAuth, _sSaveAuth , Filter["… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 화면 필드/플래그 변경 |  |  |  |
| AC-42a5cba8 | (진입점 미연결) | FP00770_Prod_Result_WO_ERP.cs:1337 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.PLANT, false, CurrentUser, _sNonAuth, _sSaveAuth , Filter["INSTANCE_ID"], nu… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-af19d2d0 | (진입점 미연결) | FP00770_Prod_Result_WO_ERP.cs:1339 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlant, mcbo_plant, false) | 목록 컨트롤 재구성 |  |  |  |

## FP00770_Prod_Result_WO_ERP.GetSite

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9eb65983 | (진입점 미연결) | FP00770_Prod_Result_WO_ERP.cs:1330 |  | FLAG | dtSite | Data_FP.Common_FP(Data_FP.Type.SITE, false, CurrentUser, _sNonAuth, _sSaveAuth , Filter["I… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 화면 필드/플래그 변경 |  |  |  |
| AC-9ad15514 | (진입점 미연결) | FP00770_Prod_Result_WO_ERP.cs:1330 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.SITE, false, CurrentUser, _sNonAuth, _sSaveAuth , Filter["INSTANCE_ID"], nul… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-2a88a201 | (진입점 미연결) | FP00770_Prod_Result_WO_ERP.cs:1332 |  | LIST_REBIND | clsCtrl.setListBox | (dtSite, mcbo_site, false) | 목록 컨트롤 재구성 |  |  |  |

## FP00770_Prod_Result_WO_ERP.GoDrawCellColor

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-aef45301 | (진입점 미연결) | FP00770_Prod_Result_WO_ERP.cs:1055 | if (string.IsNullOrWhiteSpace(color_appendix)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-761ac5e2 | (진입점 미연결) | FP00770_Prod_Result_WO_ERP.cs:1090 | if (current_src != null && calendar != null) ▸ if (day_measure != null && day_measure.On) ▸ if (calendar.Days != null) ▸ foreach (var day_it… | CALL_EXT | FPExtensions.ColorFromName | (strColor) | ⚠ 의미 확인 필요 |  |  |  |
| AC-94feed3f | (진입점 미연결) | FP00770_Prod_Result_WO_ERP.cs:1091 | if (current_src != null && calendar != null) ▸ if (day_measure != null && day_measure.On) ▸ if (calendar.Days != null) ▸ foreach (var day_it… | GRID_STYLE | siMain.SetFGColor3 | (rowindex, index, rowindex, index, color) | 그리드 표시 설정 |  |  |  |
| AC-1b0b7ed3 | (진입점 미연결) | FP00770_Prod_Result_WO_ERP.cs:1095 | if (current_src != null && calendar != null) ▸ if (day_measure != null && day_measure.On) ▸ if (calendar.Days != null) ▸ foreach (var day_it… | CALL_EXT | FPExtensions.ColorFromName | (bgColor) | ⚠ 의미 확인 필요 |  |  |  |
| AC-1ba56753 | (진입점 미연결) | FP00770_Prod_Result_WO_ERP.cs:1096 | if (current_src != null && calendar != null) ▸ if (day_measure != null && day_measure.On) ▸ if (calendar.Days != null) ▸ foreach (var day_it… | GRID_STYLE | siMain.SetBGColor3 | (rowindex, index, rowindex, index, bg) | 그리드 표시 설정 |  |  |  |
| AC-4778ac67 | (진입점 미연결) | FP00770_Prod_Result_WO_ERP.cs:1125 | if (current_src != null && calendar != null) ▸ if (week_measure != null && week_measure.On) ▸ if (calendar.Weeks != null) ▸ foreach (var day… | CALL_EXT | Color.FromName | (strColor) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f7eed144 | (진입점 미연결) | FP00770_Prod_Result_WO_ERP.cs:1126 | if (current_src != null && calendar != null) ▸ if (week_measure != null && week_measure.On) ▸ if (calendar.Weeks != null) ▸ foreach (var day… | GRID_STYLE | siMain.SetFGColor3 | (rowindex, index, rowindex, index, color) | 그리드 표시 설정 |  |  |  |
| AC-bcdca340 | (진입점 미연결) | FP00770_Prod_Result_WO_ERP.cs:1155 | if (current_src != null && calendar != null) ▸ if (month_measure != null && month_measure.On) ▸ if (calendar.Months != null) ▸ foreach (var … | CALL_EXT | Color.FromName | (strColor) | ⚠ 의미 확인 필요 |  |  |  |
| AC-7c0a4e18 | (진입점 미연결) | FP00770_Prod_Result_WO_ERP.cs:1156 | if (current_src != null && calendar != null) ▸ if (month_measure != null && month_measure.On) ▸ if (calendar.Months != null) ▸ foreach (var … | GRID_STYLE | siMain.SetFGColor3 | (rowindex, index, rowindex, index, color) | 그리드 표시 설정 |  |  |  |

## FP00770_Prod_Result_WO_ERP.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-125c49f4 | this.Load | FP00770_Prod_Result_WO_ERP.cs:238 | try | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-eac95edd | this.Load | FP00770_Prod_Result_WO_ERP.cs:244 | try | FLAG | _sNonAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-92c360c6 | this.Load | FP00770_Prod_Result_WO_ERP.cs:245 | try | FLAG | _sSaveAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-e6d6cccd | this.Load | FP00770_Prod_Result_WO_ERP.cs:256 | try | VALUE_SET | sCalendar_planday.DateTime | DateTime.Now | 컨트롤 값 설정 |  |  |  |
| AC-c1ec3c1b | this.Load | FP00770_Prod_Result_WO_ERP.cs:257 | try | DATA_OP | Filter["START_DATE"] | sCalendar_planday.DateTime.ToString("yyyyMMdd", enUS) | 행/컬럼 값 대입 |  |  |  |
| AC-7602dd9c | this.Load | FP00770_Prod_Result_WO_ERP.cs:261 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |

## FP00770_Prod_Result_WO_ERP.InitEvent

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-409aa196 | this.Load | FP00770_Prod_Result_WO_ERP.cs:367 |  | UI_PROP | mcbo_line.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-bfc1a2a0 | this.Load | FP00770_Prod_Result_WO_ERP.cs:368 |  | UI_PROP | mcbo_division.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-9e83d57a | this.Load | FP00770_Prod_Result_WO_ERP.cs:370 |  | UI_PROP | mcbo_operation.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-503d3196 | this.Load | FP00770_Prod_Result_WO_ERP.cs:371 |  | UI_PROP | mcbo_factory.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-56052e3c | this.Load | FP00770_Prod_Result_WO_ERP.cs:372 |  | UI_PROP | mcbo_plant.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-cae8d229 | this.Load | FP00770_Prod_Result_WO_ERP.cs:374 |  | UI_PROP | mcbo_site.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |

## FP00770_Prod_Result_WO_ERP.InitSpread

진입점: this.Load / this.btnExcelImport.Click [if (rowPopup.SaveSuccess == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try ▸ if (dsMain == null) ▸ else of (with_day_part == false) ▸ if (refreshColumn)] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try ▸ if (dsMain == null) ▸ else of (with_day_part == false) ▸ if (refreshColumn)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f3bf565f | this.Load 외 2 | FP00770_Prod_Result_WO_ERP.cs:419 | try | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-387ad4e3 | this.Load 외 2 | FP00770_Prod_Result_WO_ERP.cs:420 | try | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtPlanAmendMA) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-74b376e0 | this.Load 외 2 | FP00770_Prod_Result_WO_ERP.cs:422 | try | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtPlanAmendMA, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-e79651bd | this.Load 외 2 | FP00770_Prod_Result_WO_ERP.cs:426 | catch ((Exception ex)) | THROW | throw ex; |  | 예외 발생 |  |  |  |

## FP00770_Prod_Result_WO_ERP.IsEmpty

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a53957a9 | (진입점 미연결) | FP00770_Prod_Result_WO_ERP.cs:1603 | if (value == null) | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-1d11125e | (진입점 미연결) | FP00770_Prod_Result_WO_ERP.cs:1605 | if (value is string && string.IsNullOrWhiteSpace((string)value)) | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-88b19600 | (진입점 미연결) | FP00770_Prod_Result_WO_ERP.cs:1607 | if (value is DBNull) | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-ff558fa8 | (진입점 미연결) | FP00770_Prod_Result_WO_ERP.cs:1608 |  | RETURN | return false; |  | 처리 중단/반환 |  |  |  |

## FP00770_Prod_Result_WO_ERP.IsNumber

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-02a95fd7 | (진입점 미연결) | FP00770_Prod_Result_WO_ERP.cs:1613 | if (value == null) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-c0b81146 | (진입점 미연결) | FP00770_Prod_Result_WO_ERP.cs:1615 | if (value is decimal) | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-873f0c41 | (진입점 미연결) | FP00770_Prod_Result_WO_ERP.cs:1617 | if (value is double) | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-fc2a5691 | (진입점 미연결) | FP00770_Prod_Result_WO_ERP.cs:1619 | if (value is Int16) | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-fb58be34 | (진입점 미연결) | FP00770_Prod_Result_WO_ERP.cs:1621 | if (value is Int32) | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-523bcb81 | (진입점 미연결) | FP00770_Prod_Result_WO_ERP.cs:1623 | if (value is Int64) | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-ec259fbd | (진입점 미연결) | FP00770_Prod_Result_WO_ERP.cs:1625 | if (value is float) | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-a8e5c608 | (진입점 미연결) | FP00770_Prod_Result_WO_ERP.cs:1629 | if (value is string) ▸ if (string.IsNullOrWhiteSpace((string)value)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-fa5cbfa8 | (진입점 미연결) | FP00770_Prod_Result_WO_ERP.cs:1632 | if (value is string) | RETURN | return result; |  | 처리 중단/반환 |  |  |  |
| AC-6730908f | (진입점 미연결) | FP00770_Prod_Result_WO_ERP.cs:1634 |  | RETURN | return false; |  | 처리 중단/반환 |  |  |  |

## FP00770_Prod_Result_WO_ERP.lfn_settingValid

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a7d2e7e4 | (진입점 미연결) | FP00770_Prod_Result_WO_ERP.cs:1656 | foreach (KeyValuePair<string, AmendDate> each_day in calendar.Days) ▸ if (aDate != null) | DATA_OP | row.Table.Columns.Contains | (sQtyCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-de6eb6bb | (진입점 미연결) | FP00770_Prod_Result_WO_ERP.cs:1663 | foreach (KeyValuePair<string, AmendDate> each_day in calendar.Days) ▸ if (aDate != null) ▸ if (IsEmpty(row[sQtyCol]) && IsEmpty(row[sSeqCol]… | DATA_OP | row[sMCol] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-02eca1e2 | (진입점 미연결) | FP00770_Prod_Result_WO_ERP.cs:1664 | foreach (KeyValuePair<string, AmendDate> each_day in calendar.Days) ▸ if (aDate != null) ▸ if (IsEmpty(row[sQtyCol]) && IsEmpty(row[sSeqCol]… | DATA_OP | row[sCellCol] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-e0b186f2 | (진입점 미연결) | FP00770_Prod_Result_WO_ERP.cs:1665 | foreach (KeyValuePair<string, AmendDate> each_day in calendar.Days) ▸ if (aDate != null) ▸ if (IsEmpty(row[sQtyCol]) && IsEmpty(row[sSeqCol]… | DATA_OP | row[sJRCol] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-eeb97b8b | (진입점 미연결) | FP00770_Prod_Result_WO_ERP.cs:1666 | foreach (KeyValuePair<string, AmendDate> each_day in calendar.Days) ▸ if (aDate != null) ▸ if (IsEmpty(row[sQtyCol]) && IsEmpty(row[sSeqCol]… | DATA_OP | row[sQtyCol] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-1a7112bf | (진입점 미연결) | FP00770_Prod_Result_WO_ERP.cs:1667 | foreach (KeyValuePair<string, AmendDate> each_day in calendar.Days) ▸ if (aDate != null) ▸ if (IsEmpty(row[sQtyCol]) && IsEmpty(row[sSeqCol]… | DATA_OP | row[sSeqCol] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-add49a1c | (진입점 미연결) | FP00770_Prod_Result_WO_ERP.cs:1731 | foreach (KeyValuePair<string, AmendDate> each_day in calendar.Days) ▸ if (aDate != null) ▸ else of (IsEmpty(row[sQtyCol]) && IsEmpty(row[sSe… | DATA_OP | row[sSeqCol] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-efb7f5ff | (진입점 미연결) | FP00770_Prod_Result_WO_ERP.cs:1743 | if (!string.IsNullOrWhiteSpace(total_message)) | DATA_OP | row["_MSG"] | total_message.Substring(1) | 행/컬럼 값 대입 |  |  |  |
| AC-0da10ffc | (진입점 미연결) | FP00770_Prod_Result_WO_ERP.cs:1744 | if (!string.IsNullOrWhiteSpace(total_message)) | DATA_OP | row["MESSAGE"] | total_message.Substring(1) | 행/컬럼 값 대입 |  |  |  |
| AC-fbf917df | (진입점 미연결) | FP00770_Prod_Result_WO_ERP.cs:1747 | if (!valid) | DATA_OP | row["_VALID"] | "N" | 행/컬럼 값 대입 |  |  |  |
| AC-04a97526 | (진입점 미연결) | FP00770_Prod_Result_WO_ERP.cs:1749 | else of (!valid) | DATA_OP | row["_VALID"] | "Y" | 행/컬럼 값 대입 |  |  |  |
| AC-c352ccc8 | (진입점 미연결) | FP00770_Prod_Result_WO_ERP.cs:1750 |  | RETURN | return valid; |  | 처리 중단/반환 |  |  |  |

## FP00770_Prod_Result_WO_ERP.lfn_settingValidRow

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3b9601dc | (진입점 미연결) | FP00770_Prod_Result_WO_ERP.cs:1905 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## FP00770_Prod_Result_WO_ERP.MakeMemoBold

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e60e9325 | (진입점 미연결) | FP00770_Prod_Result_WO_ERP.cs:636 | if (calendar != null && dsMainFiltered.Good()) ▸ foreach (var date_item in calendar.Days) ▸ if (date != null) ▸ if (row_count > 0 && colinde… | UI_PROP | acell.Font | new System.Drawing.Font(acell.Font, FontStyle.Bold) | 속성 Font 설정 |  |  |  |
| AC-e3804ad5 | (진입점 미연결) | FP00770_Prod_Result_WO_ERP.cs:640 | if (calendar != null && dsMainFiltered.Good()) ▸ foreach (var date_item in calendar.Days) ▸ if (date != null) ▸ if (row_count > 0 && colinde… | UI_PROP | acell.Font | new System.Drawing.Font(siMain.SpreadObject.Font, FontStyle.Bold) | 속성 Font 설정 |  |  |  |

## FP00770_Prod_Result_WO_ERP.planday_changed

진입점: sCalendar_planday.ValueChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8de678aa | sCalendar_planday.ValueChanged | FP00770_Prod_Result_WO_ERP.cs:1988 |  | DATA_OP | Filter["PLAN_DATE"] | sCalendar_planday.Value.ToString("yyyyMMdd", enUS) | 행/컬럼 값 대입 |  |  |  |

## FP00770_Prod_Result_WO_ERP.RefreshHeadAndBody

진입점: this.btnExcelImport.Click [if (rowPopup.SaveSuccess == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7ca54e9b | this.btnExcelImport.Click [if (rowPopup.SaveSuccess == true)… 외 1 | FP00770_Prod_Result_WO_ERP.cs:445 | try | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-495e114f | this.btnExcelImport.Click [if (rowPopup.SaveSuccess == true)… 외 1 | FP00770_Prod_Result_WO_ERP.cs:461 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-58667a6e | this.btnExcelImport.Click [if (rowPopup.SaveSuccess == true)… 외 1 | FP00770_Prod_Result_WO_ERP.cs:465 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## FP00770_Prod_Result_WO_ERP.RefreshSpreadSheet

진입점: this.btnExcelImport.Click [if (rowPopup.SaveSuccess == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a5fab0db | this.btnExcelImport.Click [if (rowPopup.SaveSuccess == true)… 외 1 | FP00770_Prod_Result_WO_ERP.cs:1229 |  | FLAG | dsMainFiltered | dsMain.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-7b16f906 | this.btnExcelImport.Click [if (rowPopup.SaveSuccess == true)… 외 1 | FP00770_Prod_Result_WO_ERP.cs:1229 |  | DATA_OP | dsMain.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-69e3497b | this.btnExcelImport.Click [if (rowPopup.SaveSuccess == true)… 외 1 | FP00770_Prod_Result_WO_ERP.cs:1235 | if (maxColumn > 0) | GRID_LOCK | siMain.LockColumn | (0, maxColumn, true) | 그리드 편집 잠금/해제 |  |  |  |

## FP00770_Prod_Result_WO_ERP.RunSqlSource

진입점: popSql.OnSql

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f71a7427 | popSql.OnSql | FP00770_Prod_Result_WO_ERP.cs:1418 | if (programID == "PR_UI_FP00770_FIND_FP00770") | RETURN | return FindMainData(false); |  | 처리 중단/반환 |  |  |  |
| AC-258dec99 | popSql.OnSql | FP00770_Prod_Result_WO_ERP.cs:1420 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00770_Prod_Result_WO_ERP.SaveButton

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ac773cf7 | SaveButton | FP00770_Prod_Result_WO_ERP.cs:1174 | if (Filter["DONOTEDIT"] == "Y") | MESSAGE | MessageBox.Show | ("Release Plan Cannot be edited") | 메시지 표시 |  |  |  |
| AC-86f34d44 | SaveButton | FP00770_Prod_Result_WO_ERP.cs:1175 | if (Filter["DONOTEDIT"] == "Y") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6a38de6b | SaveButton | FP00770_Prod_Result_WO_ERP.cs:1178 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1642aa58 | SaveButton | FP00770_Prod_Result_WO_ERP.cs:1179 |  | CALL_BASE | SaveTopRow | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-800a89c9 | SaveButton | FP00770_Prod_Result_WO_ERP.cs:1181 |  | CALL_BASE | RestoreRowRow | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-9acfc955 | SaveButton | FP00770_Prod_Result_WO_ERP.cs:1183 |  | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtPlanAmendMA, false) | 그리드 편집 잠금/해제 |  |  |  |

## FP00770_Prod_Result_WO_ERP.SaveExcelRows

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-41ac8b8c | (진입점 미연결) | FP00770_Prod_Result_WO_ERP.cs:1772 |  | DATA_OP | popupFilter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-6ccdb0e8 | (진입점 미연결) | FP00770_Prod_Result_WO_ERP.cs:1773 |  | MESSAGE | MessageBox.Show | (""+ UserInfoContext.Current.UserId) | 메시지 표시 |  |  |  |
| AC-a1c4d0a5 | (진입점 미연결) | FP00770_Prod_Result_WO_ERP.cs:1775 |  | ENDPOINT | DataService.FP_ExecuteNonQuery | ("FP00770_Production_Result_WO_ERP", "delete_Excel_buffer", popupFilter.Dictionary, "Plann… ⇒ biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=delete_Excel_buffer] \| FP\P… | 엔드포인트 호출 |  |  |  |
| AC-efd50584 | (진입점 미연결) | FP00770_Prod_Result_WO_ERP.cs:1777 |  | MESSAGE | MessageBox.Show | ("" + res) | 메시지 표시 |  |  |  |
| AC-d351c04b | (진입점 미연결) | FP00770_Prod_Result_WO_ERP.cs:1779 |  | DATA_OP | data.Tables[0].Columns.SafeAdd | ("DEMAND_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-c8de2dce | (진입점 미연결) | FP00770_Prod_Result_WO_ERP.cs:1780 |  | DATA_OP | data.Tables[0].Columns.SafeAdd | ("PRODUCTION_TYPE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-7b782b0c | (진입점 미연결) | FP00770_Prod_Result_WO_ERP.cs:1781 |  | DATA_OP | data.Tables[0].Columns.SafeAdd | ("JOB_ORDER", typeof(Decimal)) | 데이터 객체 조작/조회 |  |  |  |
| AC-07fc2baf | (진입점 미연결) | FP00770_Prod_Result_WO_ERP.cs:1783 |  | MESSAGE | MessageBox.Show | ("saveAll_FP00770 Before") | 메시지 표시 |  |  |  |
| AC-b713e640 | (진입점 미연결) | FP00770_Prod_Result_WO_ERP.cs:1786 |  | ENDPOINT | DataService.FP_UpdateBatch | ("FP00770_Production_Result_WO_ERP", "saveAll_FP00770", data, 0, "Planning") ⇒ biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=saveAll_FP00770] \| FP\Planning\… | 엔드포인트 호출 |  |  |  |
| AC-5361debb | (진입점 미연결) | FP00770_Prod_Result_WO_ERP.cs:1787 |  | MESSAGE | MessageBox.Show | ("saveAll_FP00770 After") | 메시지 표시 |  |  |  |
| AC-56eb56c5 | (진입점 미연결) | FP00770_Prod_Result_WO_ERP.cs:1790 |  | MESSAGE | MessageBox.Show | ("Row : " + dtRes.Rows.Count) | 메시지 표시 |  |  |  |
| AC-f772de15 | (진입점 미연결) | FP00770_Prod_Result_WO_ERP.cs:1796 |  | MESSAGE | MessageBox.Show | ("Final : " + asd) | 메시지 표시 |  |  |  |
| AC-da121e6e | (진입점 미연결) | FP00770_Prod_Result_WO_ERP.cs:1799 |  | CALL_EXT | DataService.ReadResult | (dtRes) | ⚠ 의미 확인 필요 |  |  |  |
| AC-93a34079 | (진입점 미연결) | FP00770_Prod_Result_WO_ERP.cs:1801 |  | MESSAGE | MessageBox.Show | ("Success : " + dr.Success) | 메시지 표시 |  |  |  |
| AC-0be8c534 | (진입점 미연결) | FP00770_Prod_Result_WO_ERP.cs:1805 | if (!dr.Success) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-55e8a407 | (진입점 미연결) | FP00770_Prod_Result_WO_ERP.cs:1809 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00770_Production_Result_WO_ERP", "find_Excel_buffer_validation", popupFilter.Dictionar… ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Excel_buffer_validation] \… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-2a1d9b94 | (진입점 미연결) | FP00770_Prod_Result_WO_ERP.cs:1811 |  | COMBO_DATA | data.Good | () | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-fc71d5dd | (진입점 미연결) | FP00770_Prod_Result_WO_ERP.cs:1813 | if (data.Good()) | DATA_OP | popupFilter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-04041932 | (진입점 미연결) | FP00770_Prod_Result_WO_ERP.cs:1815 | if (data.Good()) | DATA_OP | paramFilter["USER_ID"] | popupFilter["USER_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-e50b630d | (진입점 미연결) | FP00770_Prod_Result_WO_ERP.cs:1816 | if (data.Good()) | DATA_OP | paramFilter["COMPANY_ID"] | data.Tables[0].Rows[0]["COMPANY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-ba7e1ef1 | (진입점 미연결) | FP00770_Prod_Result_WO_ERP.cs:1817 | if (data.Good()) | DATA_OP | paramFilter["DIVISION_ID"] | data.Tables[0].Rows[0]["DIVISION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-985edf18 | (진입점 미연결) | FP00770_Prod_Result_WO_ERP.cs:1818 | if (data.Good()) | DATA_OP | paramFilter["SITE_ID"] | data.Tables[0].Rows[0]["SITE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-2156a317 | (진입점 미연결) | FP00770_Prod_Result_WO_ERP.cs:1819 | if (data.Good()) | DATA_OP | paramFilter["PLANT_ID"] | data.Tables[0].Rows[0]["PLANT_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-758f206c | (진입점 미연결) | FP00770_Prod_Result_WO_ERP.cs:1820 | if (data.Good()) | DATA_OP | paramFilter["FACTORY_ID"] | data.Tables[0].Rows[0]["FACTORY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-2b8ff328 | (진입점 미연결) | FP00770_Prod_Result_WO_ERP.cs:1821 | if (data.Good()) | DATA_OP | paramFilter["CUTOFF_DATE"] | data.Tables[0].Rows[0]["CUTOFF_DATE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-b1a3a41b | (진입점 미연결) | FP00770_Prod_Result_WO_ERP.cs:1823 | if (data.Good()) | DATA_OP | paramFilter["WORK_ORDER_ID"] | data.Tables[0].Rows[0]["WORK_ORDER_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-29845a9a | (진입점 미연결) | FP00770_Prod_Result_WO_ERP.cs:1824 | if (data.Good()) | DATA_OP | paramFilter["ORDER_TYPE"] | data.Tables[0].Rows[0]["ORDER_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-673bf7bd | (진입점 미연결) | FP00770_Prod_Result_WO_ERP.cs:1825 | if (data.Good()) | DATA_OP | paramFilter["ITEM_ID"] | data.Tables[0].Rows[0]["ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-3d8c969e | (진입점 미연결) | FP00770_Prod_Result_WO_ERP.cs:1826 | if (data.Good()) | DATA_OP | paramFilter["TOP_ITEM_ID"] | data.Tables[0].Rows[0]["TOP_ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-553b466c | (진입점 미연결) | FP00770_Prod_Result_WO_ERP.cs:1827 | if (data.Good()) | DATA_OP | paramFilter["OPERATION_ID"] | data.Tables[0].Rows[0]["OPERATION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-557b7d90 | (진입점 미연결) | FP00770_Prod_Result_WO_ERP.cs:1828 | if (data.Good()) | DATA_OP | paramFilter["LINE_ID"] | data.Tables[0].Rows[0]["LINE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-b786a12a | (진입점 미연결) | FP00770_Prod_Result_WO_ERP.cs:1829 | if (data.Good()) | DATA_OP | paramFilter["WORK_CENTER_ID"] | data.Tables[0].Rows[0]["WORK_CENTER_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-5ea44a15 | (진입점 미연결) | FP00770_Prod_Result_WO_ERP.cs:1830 | if (data.Good()) | DATA_OP | paramFilter["EQUIPMENT_ID"] | data.Tables[0].Rows[0]["EQUIPMENT_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-4b702ec2 | (진입점 미연결) | FP00770_Prod_Result_WO_ERP.cs:1831 | if (data.Good()) | DATA_OP | paramFilter["PLAN_DATE"] | data.Tables[0].Rows[0]["PLAN_DATE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-06850a16 | (진입점 미연결) | FP00770_Prod_Result_WO_ERP.cs:1832 | if (data.Good()) | DATA_OP | paramFilter["PLAN_START_TIME"] | data.Tables[0].Rows[0]["PLAN_START_TIME"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-9e25aa3d | (진입점 미연결) | FP00770_Prod_Result_WO_ERP.cs:1833 | if (data.Good()) | DATA_OP | paramFilter["PLAN_END_TIME"] | data.Tables[0].Rows[0]["PLAN_END_TIME"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-d662237a | (진입점 미연결) | FP00770_Prod_Result_WO_ERP.cs:1834 | if (data.Good()) | DATA_OP | paramFilter["PLAN_QTY"] | data.Tables[0].Rows[0]["PLAN_QTY"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-3cc0dedc | (진입점 미연결) | FP00770_Prod_Result_WO_ERP.cs:1835 | if (data.Good()) | DATA_OP | paramFilter["ACTUAL_START_TIME"] | data.Tables[0].Rows[0]["ACTUAL_START_TIME"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-0ba991f5 | (진입점 미연결) | FP00770_Prod_Result_WO_ERP.cs:1836 | if (data.Good()) | DATA_OP | paramFilter["ACTUAL_END_TIME"] | data.Tables[0].Rows[0]["ACTUAL_END_TIME"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-da344da6 | (진입점 미연결) | FP00770_Prod_Result_WO_ERP.cs:1837 | if (data.Good()) | DATA_OP | paramFilter["ACTUAL_QTY"] | data.Tables[0].Rows[0]["ACTUAL_QTY"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-723ead70 | (진입점 미연결) | FP00770_Prod_Result_WO_ERP.cs:1838 | if (data.Good()) | DATA_OP | paramFilter["ACTUAL_GOOD_QTY"] | data.Tables[0].Rows[0]["ACTUAL_GOOD_QTY"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-c8a7096b | (진입점 미연결) | FP00770_Prod_Result_WO_ERP.cs:1839 | if (data.Good()) | DATA_OP | paramFilter["ACTUAL_SCRAP_QTY"] | data.Tables[0].Rows[0]["ACTUAL_SCRAP_QTY"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-d39c9bef | (진입점 미연결) | FP00770_Prod_Result_WO_ERP.cs:1840 | if (data.Good()) | DATA_OP | paramFilter["RUNNING_FLAG"] | data.Tables[0].Rows[0]["RUNNING_FLAG"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-a10fb5af | (진입점 미연결) | FP00770_Prod_Result_WO_ERP.cs:1841 | if (data.Good()) | DATA_OP | paramFilter["WO_STATUS"] | data.Tables[0].Rows[0]["WO_STATUS"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-88a4d2f4 | (진입점 미연결) | FP00770_Prod_Result_WO_ERP.cs:1843 | if (data.Good()) | DATA_OP | paramFilter["BOM_VERSION_ID"] | data.Tables[0].Rows[0]["BOM_VERSION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-a924d69d | (진입점 미연결) | FP00770_Prod_Result_WO_ERP.cs:1845 | if (data.Good()) | ENDPOINT | DataService.FP_ExecuteNonQuery | ("FP00770_Production_Result_WO_ERP", "merge_FP00770", paramFilter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=merge_FP00770] \| FP\Plannin… | 엔드포인트 호출 |  |  |  |
| AC-afecbcd6 | (진입점 미연결) | FP00770_Prod_Result_WO_ERP.cs:1849 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## FP00770_Prod_Result_WO_ERP.SetCalenderColor

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-76330397 | (진입점 미연결) | FP00770_Prod_Result_WO_ERP.cs:540 | if (calendar != null) ▸ if (day_measure != null && day_measure.On) ▸ foreach (var date_item in calendar.Days) ▸ if (date != null) | CALL_EXT | date.isSatureDay | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-d22934ab | (진입점 미연결) | FP00770_Prod_Result_WO_ERP.cs:544 | if (calendar != null) ▸ if (day_measure != null && day_measure.On) ▸ foreach (var date_item in calendar.Days) ▸ if (date != null) ▸ if (date… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[1, index].ForeColor | System.Drawing.Color.Blue | 그리드 속성/값 설정 |  |  |  |
| AC-9b6c5878 | (진입점 미연결) | FP00770_Prod_Result_WO_ERP.cs:546 | if (calendar != null) ▸ if (day_measure != null && day_measure.On) ▸ foreach (var date_item in calendar.Days) ▸ if (date != null) ▸ else of … | CALL_EXT | date.IsSunDay | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-3aa4b72b | (진입점 미연결) | FP00770_Prod_Result_WO_ERP.cs:550 | if (calendar != null) ▸ if (day_measure != null && day_measure.On) ▸ foreach (var date_item in calendar.Days) ▸ if (date != null) ▸ else of … | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[1, index].ForeColor | System.Drawing.Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-93477e7e | (진입점 미연결) | FP00770_Prod_Result_WO_ERP.cs:574 | if (calendar != null) ▸ if (week_measure != null && week_measure.On) ▸ foreach (var week_item in calendar.Weeks) ▸ if (week != null) ▸ if (i… | GRID_STYLE | siMain.SetBGColor3 | (0, index, dsMainFiltered.Tables[0].Rows.Count - 1, index, System.Drawing.Color.FromArgb(2… | 그리드 표시 설정 |  |  |  |
| AC-c3e884a3 | (진입점 미연결) | FP00770_Prod_Result_WO_ERP.cs:589 | if (calendar != null) ▸ if (month_measure != null && month_measure.On) ▸ foreach (var month_item in calendar.Months) ▸ if (month != null) ▸ … | GRID_STYLE | siMain.SetBGColor3 | (0, index, dsMainFiltered.Tables[0].Rows.Count - 1, index, System.Drawing.Color.LightPink) | 그리드 표시 설정 |  |  |  |

## FP00770_Prod_Result_WO_ERP.SetChangeControl

진입점: this.Load [try] / mcbo_division.SelectedIndexChanged / mcbo_site.SelectedIndexChanged / mcbo_plant.SelectedIndexChanged / mcbo_factory.SelectedIndexChanged / mcbo_operation.SelectedIndexChanged / mcbo_line.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-96480512 | this.Load [try] 외 6 | FP00770_Prod_Result_WO_ERP.cs:310 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (!dtDivision.Good()) | FLAG | dtDivision | DataService.GetInnerTable("DIVISION_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-354afddc | this.Load [try] 외 6 | FP00770_Prod_Result_WO_ERP.cs:310 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (!dtDivision.Good()) | COMBO_DATA | DataService.GetInnerTable | ("DIVISION_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-343a8d97 | this.Load [try] 외 6 | FP00770_Prod_Result_WO_ERP.cs:319 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) | FLAG | dtSite | DataService.GetInnerTable("SITE_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-26dd9796 | this.Load [try] 외 6 | FP00770_Prod_Result_WO_ERP.cs:319 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) | COMBO_DATA | DataService.GetInnerTable | ("SITE_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-bf6688f7 | this.Load [try] 외 6 | FP00770_Prod_Result_WO_ERP.cs:320 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) | LIST_REBIND | clsCtrl.setListBox | (dtSite, mcbo_site, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-3c102507 | this.Load [try] 외 6 | FP00770_Prod_Result_WO_ERP.cs:326 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) | DATA_OP | Filter["SITE_ID"] | CString.GetCheckedListValue(dtSite, mcbo_site.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-cbe3df0e | this.Load [try] 외 6 | FP00770_Prod_Result_WO_ERP.cs:327 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) | FLAG | dtPlant | DataService.GetInnerTable("PLANT_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-b1209661 | this.Load [try] 외 6 | FP00770_Prod_Result_WO_ERP.cs:327 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) | COMBO_DATA | DataService.GetInnerTable | ("PLANT_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-2e8d45c2 | this.Load [try] 외 6 | FP00770_Prod_Result_WO_ERP.cs:328 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) | LIST_REBIND | clsCtrl.setListBox | (dtPlant, mcbo_plant, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-9b07297f | this.Load [try] 외 6 | FP00770_Prod_Result_WO_ERP.cs:334 | switch (triggerControl) case DefColumns.PLANT_ID: ▸ if (dtSite.Good()) | DATA_OP | Filter["PLANT_ID"] | CString.GetCheckedListValue(dtPlant, mcbo_plant.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-3e68def2 | this.Load [try] 외 6 | FP00770_Prod_Result_WO_ERP.cs:335 | switch (triggerControl) case DefColumns.PLANT_ID: ▸ if (dtSite.Good()) | FLAG | dtFactoryAmend | DataService.GetInnerTable("FACTORY_ID", Filter) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] \| FP\CO… | 화면 필드/플래그 변경 |  |  |  |
| AC-ea7cebe3 | this.Load [try] 외 6 | FP00770_Prod_Result_WO_ERP.cs:335 | switch (triggerControl) case DefColumns.PLANT_ID: ▸ if (dtSite.Good()) | COMBO_DATA | DataService.GetInnerTable | ("FACTORY_ID", Filter) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] \| FP\CO… | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-1a41f144 | this.Load [try] 외 6 | FP00770_Prod_Result_WO_ERP.cs:336 | switch (triggerControl) case DefColumns.PLANT_ID: ▸ if (dtSite.Good()) | LIST_REBIND | clsCtrl.setListBox | (dtFactoryAmend, mcbo_factory, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-fb538948 | this.Load [try] 외 6 | FP00770_Prod_Result_WO_ERP.cs:342 | switch (triggerControl) case DefColumns.FACTORY_ID: ▸ if (dtFactoryAmend.Good()) | DATA_OP | Filter["FACTORY_ID"] | CString.GetCheckedListValue(dtFactoryAmend, mcbo_factory.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-2e6dc545 | this.Load [try] 외 6 | FP00770_Prod_Result_WO_ERP.cs:343 | switch (triggerControl) case DefColumns.FACTORY_ID: ▸ if (dtFactoryAmend.Good()) | FLAG | dtOperation | DataService.GetInnerTable("OPERATION_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-1819506f | this.Load [try] 외 6 | FP00770_Prod_Result_WO_ERP.cs:343 | switch (triggerControl) case DefColumns.FACTORY_ID: ▸ if (dtFactoryAmend.Good()) | COMBO_DATA | DataService.GetInnerTable | ("OPERATION_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-c33a4a83 | this.Load [try] 외 6 | FP00770_Prod_Result_WO_ERP.cs:344 | switch (triggerControl) case DefColumns.FACTORY_ID: ▸ if (dtFactoryAmend.Good()) | LIST_REBIND | clsCtrl.setListBox | (dtOperation, mcbo_operation, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-18931a43 | this.Load [try] 외 6 | FP00770_Prod_Result_WO_ERP.cs:350 | switch (triggerControl) case DefColumns.OPERATION_ID: ▸ if (dtOperation.Good()) | DATA_OP | Filter["OPERATION_ID"] | CString.GetCheckedListValue(dtOperation, mcbo_operation.ControlValues, true) | 행/컬럼 값 대입 |  |  |  |
| AC-c04a4b0c | this.Load [try] 외 6 | FP00770_Prod_Result_WO_ERP.cs:352 | switch (triggerControl) case DefColumns.OPERATION_ID: ▸ if (dtOperation.Good()) | FLAG | dtLine | DataService.GetInnerTable("LINE_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-e8e6ffe5 | this.Load [try] 외 6 | FP00770_Prod_Result_WO_ERP.cs:352 | switch (triggerControl) case DefColumns.OPERATION_ID: ▸ if (dtOperation.Good()) | COMBO_DATA | DataService.GetInnerTable | ("LINE_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-11e67cb5 | this.Load [try] 외 6 | FP00770_Prod_Result_WO_ERP.cs:353 | switch (triggerControl) case DefColumns.OPERATION_ID: ▸ if (dtOperation.Good()) | LIST_REBIND | clsCtrl.setListBox | (dtLine, mcbo_line, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-51a96439 | this.Load [try] 외 6 | FP00770_Prod_Result_WO_ERP.cs:359 | switch (triggerControl) case DefColumns.LINE_ID: ▸ if (dtLine.Good()) | DATA_OP | Filter["LINE_ID"] | CString.GetCheckedListValue(dtLine, mcbo_line.ControlValues, true) | 행/컬럼 값 대입 |  |  |  |

## FP00770_Prod_Result_WO_ERP.SetDevOption

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d258b6b8 | this.Load | FP00770_Prod_Result_WO_ERP.cs:183 |  | CALL_EXT | UserService.HasExtraRole | (CurrentUser) | ⚠ 의미 확인 필요 |  |  |  |
| AC-8ea36f7c | this.Load | FP00770_Prod_Result_WO_ERP.cs:185 | if (UserService.HasExtraRole(CurrentUser)) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-a64b0cef | this.Load | FP00770_Prod_Result_WO_ERP.cs:189 | else of (UserService.HasExtraRole(CurrentUser)) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-01fd0b63 | this.Load | FP00770_Prod_Result_WO_ERP.cs:192 |  | CALL_EXT | UserService.HasSuperRole | (CurrentUser) | ⚠ 의미 확인 필요 |  |  |  |
| AC-cb419323 | this.Load | FP00770_Prod_Result_WO_ERP.cs:194 | if (UserService.HasSuperRole(CurrentUser)) | UI_PROP | lblData.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-9ddb380d | this.Load | FP00770_Prod_Result_WO_ERP.cs:198 | else of (UserService.HasSuperRole(CurrentUser)) | UI_PROP | lblData.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |

## FP00770_Prod_Result_WO_ERP.SetDirty

진입점: this.btnExcelImport.Click [if (rowPopup.SaveSuccess == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ finally] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ finally] / SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9c10de56 | this.btnExcelImport.Click [if (rowPopup.SaveSuccess == true)… 외 2 | FP00770_Prod_Result_WO_ERP.cs:2082 |  | FLAG | IsDirty | dirty | 화면 필드/플래그 변경 |  |  |  |

## FP00770_Prod_Result_WO_ERP.SetFilter

진입점: this.Load [try ▸ switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good())] / mcbo_division.SelectedIndexChanged [switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good())] / mcbo_site.SelectedIndexChanged [switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good())] / mcbo_plant.SelectedIndexChanged [switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good())] / mcbo_factory.SelectedIndexChanged [switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good())] / mcbo_operation.SelectedIndexChanged [switc…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5d354046 | this.Load [try ▸ switch (triggerControl) case DefColumns.DIV… 외 9 | FP00770_Prod_Result_WO_ERP.cs:1309 |  | DATA_OP | Filter[key] | value | 행/컬럼 값 대입 |  |  |  |

## FP00770_Prod_Result_WO_ERP.SetSpreadInit

진입점: this.Load [try] / this.btnExcelImport.Click [if (rowPopup.SaveSuccess == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try ▸ if (dsMain == null) ▸ else of (with_day_part == false) ▸ if (refreshColumn) ▸ try] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try ▸ if (dsMain == null) ▸ else of (with_day_part == false) ▸ if (refreshColumn) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-081a1061 | this.Load [try] 외 2 | FP00770_Prod_Result_WO_ERP.cs:434 | if (sheetName.Equals(SpdSheet.shtPlanAmendMA)) | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c1c3470f | this.Load [try] 외 2 | FP00770_Prod_Result_WO_ERP.cs:435 | if (sheetName.Equals(SpdSheet.shtPlanAmendMA)) | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |

## FP00770_Prod_Result_WO_ERP.SetTotalColor

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-524d590a | (진입점 미연결) | FP00770_Prod_Result_WO_ERP.cs:499 | foreach (DataRow row in dsMainFiltered.Tables[0].Rows) ▸ switch (row["DATA_TYPE"].ToString()) case "TOTAL": | GRID_STYLE | siMain.SetBGColor3 | (line, start, line, last_col, total_color) | 그리드 표시 설정 |  |  |  |
| AC-331d350e | (진입점 미연결) | FP00770_Prod_Result_WO_ERP.cs:502 | foreach (DataRow row in dsMainFiltered.Tables[0].Rows) ▸ switch (row["DATA_TYPE"].ToString()) case "TOTAL_2": | GRID_STYLE | siMain.SetBGColor3 | (line, substart, line, last_col, sub_total_color) | 그리드 표시 설정 |  |  |  |
| AC-3b701c28 | (진입점 미연결) | FP00770_Prod_Result_WO_ERP.cs:509 | foreach (DataRow row in dsMainFiltered.Tables[0].Rows) ▸ switch (row["DATA_TYPE"].ToString()) default: ▸ if (!string.IsNullOrWhiteSpace(work… | GRID_STYLE | siMain.SetBGColor3 | (line, idx_item_id, line, idx_item_id, Color.Orange) | 그리드 표시 설정 |  |  |  |
| AC-518699c3 | (진입점 미연결) | FP00770_Prod_Result_WO_ERP.cs:511 | foreach (DataRow row in dsMainFiltered.Tables[0].Rows) ▸ switch (row["DATA_TYPE"].ToString()) default: ▸ if (!string.IsNullOrWhiteSpace(work… | GRID_STYLE | siMain.SetBGColor3 | (line, idx_nick_name, line, idx_nick_name, Color.Orange) | 그리드 표시 설정 |  |  |  |
| AC-a5236c35 | (진입점 미연결) | FP00770_Prod_Result_WO_ERP.cs:513 | foreach (DataRow row in dsMainFiltered.Tables[0].Rows) ▸ switch (row["DATA_TYPE"].ToString()) default: ▸ if (!string.IsNullOrWhiteSpace(work… | GRID_STYLE | siMain.SetBGColor3 | (line, idx_app_model, line, idx_app_model, Color.Orange) | 그리드 표시 설정 |  |  |  |
| AC-18c5802d | (진입점 미연결) | FP00770_Prod_Result_WO_ERP.cs:515 | foreach (DataRow row in dsMainFiltered.Tables[0].Rows) ▸ switch (row["DATA_TYPE"].ToString()) default: ▸ if (!string.IsNullOrWhiteSpace(work… | GRID_STYLE | siMain.SetBGColor3 | (line, idx_work_model, line, idx_work_model, Color.Orange) | 그리드 표시 설정 |  |  |  |

## FP00770_Prod_Result_WO_ERP.UIFindData

진입점: this.btnExcelImport.Click [if (rowPopup.SaveSuccess == true)] / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6079b66a | this.btnExcelImport.Click [if (rowPopup.SaveSuccess == true)… 외 1 | FP00770_Prod_Result_WO_ERP.cs:866 | try ▸ if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ebad32f0 | this.btnExcelImport.Click [if (rowPopup.SaveSuccess == true)… 외 1 | FP00770_Prod_Result_WO_ERP.cs:867 | try ▸ if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ff804b4a | this.btnExcelImport.Click [if (rowPopup.SaveSuccess == true)… 외 1 | FP00770_Prod_Result_WO_ERP.cs:870 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-1e87c63d | this.btnExcelImport.Click [if (rowPopup.SaveSuccess == true)… 외 1 | FP00770_Prod_Result_WO_ERP.cs:880 | try | DATA_OP | Filter["START_DATE"] | sCalendar_planday.DateTime.ToString("yyyyMMdd", enUS) | 행/컬럼 값 대입 |  |  |  |
| AC-a33e225b | this.btnExcelImport.Click [if (rowPopup.SaveSuccess == true)… 외 1 | FP00770_Prod_Result_WO_ERP.cs:885 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | CALL_BASE | SaveTopRow | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-ab84f373 | this.btnExcelImport.Click [if (rowPopup.SaveSuccess == true)… 외 1 | FP00770_Prod_Result_WO_ERP.cs:903 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (sDivision == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00097") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-101c76e9 | this.btnExcelImport.Click [if (rowPopup.SaveSuccess == true)… 외 1 | FP00770_Prod_Result_WO_ERP.cs:904 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (sDivision == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-14a6d264 | this.btnExcelImport.Click [if (rowPopup.SaveSuccess == true)… 외 1 | FP00770_Prod_Result_WO_ERP.cs:906 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-6d31468d | this.btnExcelImport.Click [if (rowPopup.SaveSuccess == true)… 외 1 | FP00770_Prod_Result_WO_ERP.cs:911 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | FLAG | dsMain | null | 화면 필드/플래그 변경 |  |  |  |
| AC-cec68a11 | this.btnExcelImport.Click [if (rowPopup.SaveSuccess == true)… 외 1 | FP00770_Prod_Result_WO_ERP.cs:912 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | FLAG | monthInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-b4318f85 | this.btnExcelImport.Click [if (rowPopup.SaveSuccess == true)… 외 1 | FP00770_Prod_Result_WO_ERP.cs:914 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | DATA_OP | Filter["DONOTEDIT"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-080ca115 | this.btnExcelImport.Click [if (rowPopup.SaveSuccess == true)… 외 1 | FP00770_Prod_Result_WO_ERP.cs:926 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-ae2cfcc3 | this.btnExcelImport.Click [if (rowPopup.SaveSuccess == true)… 외 1 | FP00770_Prod_Result_WO_ERP.cs:928 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | FLAG | dsMain | await asyncProxy.ExecuteAsync<DataSet>(() => FindMainData(true) ) | 화면 필드/플래그 변경 |  |  |  |
| AC-43ab89ef | this.btnExcelImport.Click [if (rowPopup.SaveSuccess == true)… 외 1 | FP00770_Prod_Result_WO_ERP.cs:928 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | ENDPOINT | asyncProxy.ExecuteAsync | (() => FindMainData(true) ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-18077d07 | this.btnExcelImport.Click [if (rowPopup.SaveSuccess == true)… 외 1 | FP00770_Prod_Result_WO_ERP.cs:953 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (Filter["PLAN_ID"].EndsWith("00")) | STATE | btnExcelImport.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-4666759f | this.btnExcelImport.Click [if (rowPopup.SaveSuccess == true)… 외 1 | FP00770_Prod_Result_WO_ERP.cs:958 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ else of (Filter["PLAN_ID"].EndsWith("00")) | STATE | btnExcelImport.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-33636666 | this.btnExcelImport.Click [if (rowPopup.SaveSuccess == true)… 외 1 | FP00770_Prod_Result_WO_ERP.cs:959 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ else of (Filter["PLAN_ID"].EndsWith("00")) | DATA_OP | Filter["DONOTEDIT"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-e63af9d4 | this.btnExcelImport.Click [if (rowPopup.SaveSuccess == true)… 외 1 | FP00770_Prod_Result_WO_ERP.cs:993 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMainFiltered.Good()) | UI_MISC | SetSearchCount | (dsMainFiltered) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-154fcfdc | this.btnExcelImport.Click [if (rowPopup.SaveSuccess == true)… 외 1 | FP00770_Prod_Result_WO_ERP.cs:997 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | FLAG | FindDone | true | 화면 필드/플래그 변경 |  |  |  |
| AC-1036d350 | this.btnExcelImport.Click [if (rowPopup.SaveSuccess == true)… 외 1 | FP00770_Prod_Result_WO_ERP.cs:1001 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8c9d41fc | this.btnExcelImport.Click [if (rowPopup.SaveSuccess == true)… 외 1 | FP00770_Prod_Result_WO_ERP.cs:1006 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-855f6dae | this.btnExcelImport.Click [if (rowPopup.SaveSuccess == true)… 외 1 | FP00770_Prod_Result_WO_ERP.cs:1007 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-77313585 | this.btnExcelImport.Click [if (rowPopup.SaveSuccess == true)… 외 1 | FP00770_Prod_Result_WO_ERP.cs:1014 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | CALL_BASE | RestoreRowRow | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-9aa6ea45 | this.btnExcelImport.Click [if (rowPopup.SaveSuccess == true)… 외 1 | FP00770_Prod_Result_WO_ERP.cs:1017 | try | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtPlanAmendMA, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-c7f7c96c | this.btnExcelImport.Click [if (rowPopup.SaveSuccess == true)… 외 1 | FP00770_Prod_Result_WO_ERP.cs:1021 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-3dbc2a72 | this.btnExcelImport.Click [if (rowPopup.SaveSuccess == true)… 외 1 | FP00770_Prod_Result_WO_ERP.cs:1025 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |

