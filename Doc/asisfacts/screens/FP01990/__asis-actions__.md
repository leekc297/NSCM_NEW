# AS-IS 액션 대조표 — FP01990

> 원천: `Doc/asisfacts/screens/FP01990/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 388행 · 메서드 33 · 종류 DATA_OP 135 · GRID_INIT 68 · FLAG 36 · RETURN 31 · UI_MISC 19 · UI_PROP 15 · MESSAGE 12 · GRID_LOCK 11 · STATE 11 · CALL_EXT 10 · STATE_RESET 7 · VALUE_SET 5 · ENDPOINT 5 · GRID_SET 5 · POPUP 4 · GRID_BIND 4 · VALUE_CLEAR 3 · LIST_CLEAR 2 · VALIDATE 2 · THROW 1 · CALL_BASE 1 · LIST_REBIND 1 · ⚠ 의미 확인 필요 11


## FP01990_Lookup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dea736c0 | .ctor | FP01990_Lookup.cs:143 |  | FLAG | _CurrentUser | UserInfoContext.Current.UserId | 화면 필드/플래그 변경 |  |  |  |

## FP01990_Lookup.ActiveSheet_CellChanged

진입점: this.spdMain.ActiveSheet.CellChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-88524d85 | this.spdMain.ActiveSheet.CellChanged | FP01990_Lookup.cs:1260 | if (siMain.IsLock(siMain.SheetName) == true) ▸ if (siMain.Sheet().Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e074fbe0 | this.spdMain.ActiveSheet.CellChanged | FP01990_Lookup.cs:1262 | if (siMain.IsLock(siMain.SheetName) == true) | FLAG | mainLookupType | siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.LOOKUP_TYPE_CODE)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-3f13fffd | this.spdMain.ActiveSheet.CellChanged | FP01990_Lookup.cs:1263 | if (siMain.IsLock(siMain.SheetName) == true) | DATA_OP | Filter["ACTIVE_FLAG"] | siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.ACTIVE)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-5a44cd9e | this.spdMain.ActiveSheet.CellChanged | FP01990_Lookup.cs:1265 | if (siMain.IsLock(siMain.SheetName) == true) | STATE_RESET | dtColumInfo.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |

## FP01990_Lookup.btnSql_Click

진입점: this.btnSql.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-371a5535 | this.btnSql.Click | FP01990_Lookup.cs:1453 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-2b390538 | this.btnSql.Click | FP01990_Lookup.cs:1456 |  | POPUP | new FPC0099_SqlPopup | () | 팝업/폼 생성 |  |  |  |
| AC-6073a048 | this.btnSql.Click | FP01990_Lookup.cs:1457 |  | UI_PROP | popSql.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-68f4a1b5 | this.btnSql.Click | FP01990_Lookup.cs:1459 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP01990_GET_LOOKUP_FP") | 데이터 객체 조작/조회 |  |  |  |
| AC-f4b31c46 | this.btnSql.Click | FP01990_Lookup.cs:1461 |  | POPUP | popSql.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP01990_Lookup.CheckValidation

진입점: SaveButton [if (fps.Name == "spdMain") ▸ if (siMain.SpreadObject.DataSource != null)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-29dd31af | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain.SpreadOb… | FP01990_Lookup.cs:1423 | try ▸ for (i < dt.Rows.Count) ▸ for (j < dt.Rows.Count) ▸ if (sLookupType == schkLookupType && sSegment1 == schkSegment1 && sSegment2 == sch… | MESSAGE | MessageHelper.GMessageBox | ("MSG00060", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-51dd7c6e | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain.SpreadOb… | FP01990_Lookup.cs:1424 | try ▸ for (i < dt.Rows.Count) ▸ for (j < dt.Rows.Count) ▸ if (sLookupType == schkLookupType && sSegment1 == schkSegment1 && sSegment2 == sch… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-64cc65ec | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain.SpreadOb… | FP01990_Lookup.cs:1431 | catch ((Exception ex)) | RETURN | return bCheck; |  | 처리 중단/반환 |  |  |  |
| AC-454d34c7 | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain.SpreadOb… | FP01990_Lookup.cs:1433 |  | RETURN | return bCheck; |  | 처리 중단/반환 |  |  |  |

## FP01990_Lookup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dd239463 | this.Load | FP01990_Lookup.cs:239 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-342180f0 | this.Load | FP01990_Lookup.cs:240 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-1fc697c2 | this.Load | FP01990_Lookup.cs:242 |  | GRID_INIT | this.AddSheet | (spdSub, SpdSheet.shtSub, SpdSheet.shtSub, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-4bab7e45 | this.Load | FP01990_Lookup.cs:243 |  | FLAG | siSub | GetSheetInfo(spdSub.Name, spdSub.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-e0dd8959 | this.Load | FP01990_Lookup.cs:245 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP01990_Lookup.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c7a6267e | DeleteButton | FP01990_Lookup.cs:488 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e7ccef99 | DeleteButton | FP01990_Lookup.cs:491 | if (fps.Name == "spdMain") | DATA_OP | siMain.Delete | () | 데이터 객체 조작/조회 |  |  |  |
| AC-edef7461 | DeleteButton | FP01990_Lookup.cs:493 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") | DATA_OP | siSub.Delete | () | 데이터 객체 조작/조회 |  |  |  |

## FP01990_Lookup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-72199309 | Dispose | FP01990_Lookup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP01990_Lookup.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0ecd4fde | EditButton | FP01990_Lookup.cs:502 | if (fps != null) ▸ if (fps.Name == "spdMain") | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-168390c4 | EditButton | FP01990_Lookup.cs:503 | if (fps != null) ▸ if (fps.Name == "spdMain") | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-f1d322dc | EditButton | FP01990_Lookup.cs:505 | if (fps != null) ▸ if (fps.Name == "spdMain") | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.MODIFY_DATE), siMain.GetColumnIndex(DefColumns.modify_us… | 그리드 편집 잠금/해제 |  |  |  |
| AC-ee231a5b | EditButton | FP01990_Lookup.cs:511 | if (fps != null) ▸ if (fps.Name == "spdSub") | FLAG | siSub | GetSheetInfo(spdSub.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-0acc4f0e | EditButton | FP01990_Lookup.cs:512 | if (fps != null) ▸ if (fps.Name == "spdSub") | GRID_LOCK | siSub.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-a281a99f | EditButton | FP01990_Lookup.cs:516 | if (fps != null) ▸ if (fps.Name == "spdSub") | GRID_LOCK | siSub.LockColumn | (siSub.GetColumnIndex(DefColumns.MODIFY_DATE), siSub.GetColumnIndex(DefColumns.modify_user… | 그리드 편집 잠금/해제 |  |  |  |
| AC-5224554d | EditButton | FP01990_Lookup.cs:517 | if (fps != null) ▸ if (fps.Name == "spdSub") | GRID_LOCK | siSub.LockColumn | (siSub.GetColumnIndex(DefColumns.LOOKUP_TYPE_CODE), siSub.GetColumnIndex(DefColumns.LOOKUP… | 그리드 편집 잠금/해제 |  |  |  |

## FP01990_Lookup.EssentialCheck

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e2a93d7c | (진입점 미연결) | FP01990_Lookup.cs:1352 | try ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ for (iCol <= siMain.GetMaxColumnIndex()) | CALL_EXT | siMain.GetColumnText | (0, iCol) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c7a21bfc | (진입점 미연결) | FP01990_Lookup.cs:1360 | try ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (string.IsNullOrWhiteSpace(str)) | CALL_EXT | siMain.GetColumnText | (0, iCol) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d9a32f09 | (진입점 미연결) | FP01990_Lookup.cs:1364 | try ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (string.IsNullOrWhiteSpace(str)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a8f1eef5 | (진입점 미연결) | FP01990_Lookup.cs:1365 | try ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (string.IsNullOrWhiteSpace(str)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-b1de5941 | (진입점 미연결) | FP01990_Lookup.cs:1372 | catch ((Exception ex)) | RETURN | return bFlag; |  | 처리 중단/반환 |  |  |  |
| AC-8d2c9a8c | (진입점 미연결) | FP01990_Lookup.cs:1374 |  | RETURN | return bFlag; |  | 처리 중단/반환 |  |  |  |

## FP01990_Lookup.ExcelButton

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2c27e02a | ExcelButton | FP01990_Lookup.cs:530 |  | POPUP | new FPC0109_ExcelSelect_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-98a81dff | ExcelButton | FP01990_Lookup.cs:531 |  | VALUE_SET | select_popup.Text | "SELECT Excel Export Option" | 컨트롤 값 설정 |  |  |  |
| AC-129d3da0 | ExcelButton | FP01990_Lookup.cs:533 |  | POPUP | select_popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-4feeaa17 | ExcelButton | FP01990_Lookup.cs:537 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.Merge | select_popup.MergeSelection | 속성 Merge 설정 |  |  |  |
| AC-c18324ee | ExcelButton | FP01990_Lookup.cs:538 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.Border | select_popup.LineSelection | 속성 Border 설정 |  |  |  |
| AC-58dcd1f8 | ExcelButton | FP01990_Lookup.cs:539 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.AmendZeroOption | select_popup.ZeroSelection | 속성 AmendZeroOption 설정 |  |  |  |
| AC-b035a42b | ExcelButton | FP01990_Lookup.cs:542 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.AheadZeroOption | ZeroOption.HideZero | 속성 AheadZeroOption 설정 |  |  |  |
| AC-e8a0da43 | ExcelButton | FP01990_Lookup.cs:543 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.AmendNullToZero | true | 속성 AmendNullToZero 설정 |  |  |  |
| AC-9a0a956d | ExcelButton | FP01990_Lookup.cs:544 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.AheadNullToZero | false | 속성 AheadNullToZero 설정 |  |  |  |
| AC-dbf6722a | ExcelButton | FP01990_Lookup.cs:546 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.UserName | UserInfo.UserId | 속성 UserName 설정 |  |  |  |
| AC-fcf5b0d1 | ExcelButton | FP01990_Lookup.cs:547 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.FileName | sFileName | 속성 FileName 설정 |  |  |  |
| AC-b60c3491 | ExcelButton | FP01990_Lookup.cs:554 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ try | CALL_EXT | SimplexelService.ExportFpSpread | (fps, exportOption) | ⚠ 의미 확인 필요 |  |  |  |
| AC-12d1b4dc | ExcelButton | FP01990_Lookup.cs:558 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-8dd30fac | ExcelButton | FP01990_Lookup.cs:562 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP01990_Lookup.Find_Data_Amend

진입점: popSql.OnSql [if (fps.Name == "spdMain")] / FindButton [try ▸ lambda] / SaveButton [if (fps.Name == "spdMain") ▸ try ▸ lambda]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d4a32a7c | popSql.OnSql [if (fps.Name == "spdMain")] 외 2 | FP01990_Lookup.cs:1160 | try | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { segment_ID = "SEGMENT" + (usrComboBox_Seg.SelectedIndex +… | ⚠ 의미 확인 필요 |  |  |  |
| AC-1add4579 | popSql.OnSql [if (fps.Name == "spdMain")] 외 2 | FP01990_Lookup.cs:1163 | try ▸ lambda | DATA_OP | Filter[segment_ID] | usrTextBox_Seg.Text.ToUpper() | 행/컬럼 값 대입 |  |  |  |
| AC-b5334425 | popSql.OnSql [if (fps.Name == "spdMain")] 외 2 | FP01990_Lookup.cs:1165 | try ▸ lambda | DATA_OP | Filter["LOOKUP_TYPE_CODE"] | txtLookupType.Text.ToUpper() | 행/컬럼 값 대입 |  |  |  |
| AC-8ccbc7f5 | popSql.OnSql [if (fps.Name == "spdMain")] 외 2 | FP01990_Lookup.cs:1169 | try ▸ lambda ▸ if (cboValid.Text.ToUpper() != "ALL") | DATA_OP | Filter["ACTIVE_FLAG"] | cboValid.Text.ToUpper() | 행/컬럼 값 대입 |  |  |  |
| AC-c096f427 | popSql.OnSql [if (fps.Name == "spdMain")] 외 2 | FP01990_Lookup.cs:1173 | try ▸ lambda ▸ else of (cboValid.Text.ToUpper() != "ALL") | DATA_OP | Filter["ACTIVE_FLAG"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-5bc9a9a2 | popSql.OnSql [if (fps.Name == "spdMain")] 외 2 | FP01990_Lookup.cs:1184 | try | ENDPOINT | Data_FP.CallGeneralProcedure | ("PR_UI_FP01990_GET_LOOKUP_FP", Filter, _CurrentUser, pSysType, "SELECT_MAIN") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-6f25ddff | popSql.OnSql [if (fps.Name == "spdMain")] 외 2 | FP01990_Lookup.cs:1185 | try | CALL_EXT | Filter.clearData | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-4c1e6b6f | popSql.OnSql [if (fps.Name == "spdMain")] 외 2 | FP01990_Lookup.cs:1187 | try | RETURN | return dsResult; |  | 처리 중단/반환 |  |  |  |
| AC-a03458b7 | popSql.OnSql [if (fps.Name == "spdMain")] 외 2 | FP01990_Lookup.cs:1191 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP01990_Lookup.Find_Data_Save

진입점: SaveButton [if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex())]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-62fb6cea | SaveButton [if (fps.Name == "spdMain") ▸ for (i <= siMain.Ge… | FP01990_Lookup.cs:1205 | try | ENDPOINT | Data_FP.CallGeneralProcedure | ("PR_UI_FP01990_GET_LOOKUP_FP", SaveFilter, _CurrentUser, pSysType, mFlag) | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-f0abdb19 | SaveButton [if (fps.Name == "spdMain") ▸ for (i <= siMain.Ge… | FP01990_Lookup.cs:1207 | try | RETURN | return dsResult; |  | 처리 중단/반환 |  |  |  |
| AC-c4edfb53 | SaveButton [if (fps.Name == "spdMain") ▸ for (i <= siMain.Ge… | FP01990_Lookup.cs:1211 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP01990_Lookup.Find_Data_Save_Sub

진입점: SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex())]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5a5f87a5 | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FP01990_Lookup.cs:1226 | try | ENDPOINT | Data_FP.CallGeneralProcedure | ("PR_UI_FP01990_GET_LOOKUP_FP", SaveFilter, _CurrentUser, pSysType, mFlag) | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-7852c2e3 | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FP01990_Lookup.cs:1228 | try | RETURN | return dsResult; |  | 처리 중단/반환 |  |  |  |
| AC-76f37312 | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FP01990_Lookup.cs:1232 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP01990_Lookup.Find_Data_sub

진입점: this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == true) ▸ if (_UpAct_Cell != _PressAct_Cell) ▸ try] / this.spdMain.CellClick [if (siMain.IsLock(siMain.SheetName) == true) ▸ try] / this.spdMain.ActiveSheet.CellChanged [if (siMain.IsLock(siMain.SheetName) == true) ▸ try] / popSql.OnSql [else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub")] / FindButton [if (siMain.ActiveSheet.RowCount > 0) ▸ try] / SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ try] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-987359fd | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 6 | FP01990_Lookup.cs:1240 | try | DATA_OP | Filter["LOOKUP_TYPE_CODE"] | mainLookupType.ToUpper() | 행/컬럼 값 대입 |  |  |  |
| AC-304ddb07 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 6 | FP01990_Lookup.cs:1243 | try | ENDPOINT | Data_FP.CallGeneralProcedure | ("PR_UI_FP01990_GET_LOOKUP_FP", Filter, _CurrentUser, pSysType, "SELECT_MAIN_DETAIL") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-11f8f012 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 6 | FP01990_Lookup.cs:1245 | try | RETURN | return dsResult; |  | 처리 중단/반환 |  |  |  |
| AC-f7133d0c | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 6 | FP01990_Lookup.cs:1249 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP01990_Lookup.FindData_Sub

진입점: this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == true) ▸ if (_UpAct_Cell != _PressAct_Cell)] / this.spdMain.CellClick [if (siMain.IsLock(siMain.SheetName) == true)] / this.spdMain.ActiveSheet.CellChanged [if (siMain.IsLock(siMain.SheetName) == true)] / FindButton [if (siMain.ActiveSheet.RowCount > 0)] / SaveButton [if (fps.Name == "spdMain") ▸ if (siMain.ActiveSheet.RowCount > 0)] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d6383cd0 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP01990_Lookup.cs:615 | try | VALUE_CLEAR | usrTextBox_Att.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-e33141b1 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP01990_Lookup.cs:619 | try ▸ if (string.IsNullOrWhiteSpace(mainLookupType)) | FLAG | mainLookupType | siMain.GetValue(0, siMain.GetColumnIndex(DefColumns.LOOKUP_TYPE_CODE)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-152b0014 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP01990_Lookup.cs:621 | try | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-5e9241b7 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP01990_Lookup.cs:625 | try | FLAG | dsMain | null | 화면 필드/플래그 변경 |  |  |  |
| AC-32c37afd | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP01990_Lookup.cs:635 | try | FLAG | dsMain | Find_Data_sub("SELECT") | 화면 필드/플래그 변경 |  |  |  |
| AC-ba14568c | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP01990_Lookup.cs:637 | try | FLAG | dsMain_sub | dsMain.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-85866b1b | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP01990_Lookup.cs:637 | try | DATA_OP | dsMain.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-bbaa0b26 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP01990_Lookup.cs:639 | try | FLAG | siSub | GetSheetInfo(spdSub.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-28a1656e | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP01990_Lookup.cs:648 | try ▸ if (dr != null) ▸ for (iCol < siSub.ActiveSheet.Columns.Count) | DATA_OP | dtColumInfo.Columns.Contains | (sColName) | 데이터 객체 조작/조회 |  |  |  |
| AC-49f0255c | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP01990_Lookup.cs:656 | try ▸ if (dr != null) ▸ for (iCol < siSub.ActiveSheet.Columns.Count) ▸ if (sValue == "-" \|\| sValue == "*" \|\| string.IsNullOrWhiteSpace(s… | STATE | col.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-182508c3 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP01990_Lookup.cs:662 | try ▸ if (dr != null) ▸ for (iCol < siSub.ActiveSheet.Columns.Count) ▸ else of (sValue == "-" \|\| sValue == "*" \|\| string.IsNullOrWhiteSp… | UI_PROP | col.Label | sValue | 속성 Label 설정 |  |  |  |
| AC-d557590e | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP01990_Lookup.cs:667 | try | GRID_BIND | siSub.Query | (dsMain) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-ad45e8d7 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP01990_Lookup.cs:668 | try | GRID_LOCK | siSub.LockColumn | (0, siSub.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-a9ad44ad | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP01990_Lookup.cs:672 | try | CALL_EXT | col_head.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-8bf10844 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP01990_Lookup.cs:673 | try | CALL_EXT | col_head_idx.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-c15f7477 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP01990_Lookup.cs:677 | try | LIST_CLEAR | SubComboBox_param.Items.Clear | () | 목록 항목 비움 |  |  |  |
| AC-695d8725 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP01990_Lookup.cs:685 | try ▸ for (i < siSub.ActiveSheet.ColumnCount) ▸ if (siSub.ActiveSheet.Columns[i].Visible) ▸ if (siSub.ActiveSheet.Columns[i].Label != "Last … | DATA_OP | col_head.Add | (siSub.ActiveSheet.Columns[i].Label) | 데이터 객체 조작/조회 |  |  |  |
| AC-6afc5681 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP01990_Lookup.cs:686 | try ▸ for (i < siSub.ActiveSheet.ColumnCount) ▸ if (siSub.ActiveSheet.Columns[i].Visible) ▸ if (siSub.ActiveSheet.Columns[i].Label != "Last … | DATA_OP | col_head_idx.Add | (SP_DataSource.Tables[0].Columns[siSub.ActiveSheet.Columns[i].Tag.ToString()].Ordinal) | 데이터 객체 조작/조회 |  |  |  |
| AC-df00b9f6 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP01990_Lookup.cs:694 | try ▸ for (i < col_head.Count) | DATA_OP | SubComboBox_param.Items.Add | (col_head[i]) | 데이터 객체 조작/조회 |  |  |  |
| AC-8f4b9095 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP01990_Lookup.cs:696 | try | VALUE_SET | SubComboBox_param.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-bf127274 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP01990_Lookup.cs:711 | try | UI_PROP | objCellType.MaxLength | 32767 | 속성 MaxLength 설정 |  |  |  |
| AC-5bbdf727 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP01990_Lookup.cs:713 | try | UI_MISC | siSub.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-7879e7f6 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP01990_Lookup.cs:716 | try ▸ if (nRowCnt >= 0) | GRID_SET | siSub.ActiveSheet.Cells[0, nStartCol, nRowCnt, nEndCol].CellType | objCellType | 그리드 속성/값 설정 |  |  |  |
| AC-095ae51c | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP01990_Lookup.cs:718 | try | UI_MISC | siSub.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-c272af76 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP01990_Lookup.cs:723 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-75aa6506 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP01990_Lookup.cs:728 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-e482339c | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP01990_Lookup.cs:729 | finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP01990_Lookup.FindData_Sub_Conditon

진입점: this.usrTextBox_Att.KeyUp [if (e.KeyCode == Keys.Enter)] / this.simpleButton1.Click / SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ finally]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ff32b801 | this.usrTextBox_Att.KeyUp [if (e.KeyCode == Keys.Enter)] 외 2 | FP01990_Lookup.cs:739 | try ▸ if (string.IsNullOrWhiteSpace(mainLookupType)) | FLAG | mainLookupType | siMain.GetValue(0, siMain.GetColumnIndex(DefColumns.LOOKUP_TYPE_CODE)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-83ff9861 | this.usrTextBox_Att.KeyUp [if (e.KeyCode == Keys.Enter)] 외 2 | FP01990_Lookup.cs:741 | try | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-5559ddb2 | this.usrTextBox_Att.KeyUp [if (e.KeyCode == Keys.Enter)] 외 2 | FP01990_Lookup.cs:745 | try | FLAG | dsMain | null | 화면 필드/플래그 변경 |  |  |  |
| AC-09e8429a | this.usrTextBox_Att.KeyUp [if (e.KeyCode == Keys.Enter)] 외 2 | FP01990_Lookup.cs:755 | try | FLAG | dsMain | dsMain_sub.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-65a8d46d | this.usrTextBox_Att.KeyUp [if (e.KeyCode == Keys.Enter)] 외 2 | FP01990_Lookup.cs:755 | try | DATA_OP | dsMain_sub.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-f58b2a4b | this.usrTextBox_Att.KeyUp [if (e.KeyCode == Keys.Enter)] 외 2 | FP01990_Lookup.cs:757 | try | FLAG | siSub | GetSheetInfo(spdSub.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-53b61994 | this.usrTextBox_Att.KeyUp [if (e.KeyCode == Keys.Enter)] 외 2 | FP01990_Lookup.cs:766 | try ▸ if (dr != null) ▸ for (iCol < siSub.ActiveSheet.Columns.Count) | DATA_OP | dtColumInfo.Columns.Contains | (sColName) | 데이터 객체 조작/조회 |  |  |  |
| AC-430cc16d | this.usrTextBox_Att.KeyUp [if (e.KeyCode == Keys.Enter)] 외 2 | FP01990_Lookup.cs:774 | try ▸ if (dr != null) ▸ for (iCol < siSub.ActiveSheet.Columns.Count) ▸ if (sValue == "-" \|\| sValue == "*" \|\| string.IsNullOrWhiteSpace(s… | STATE | col.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-5164ed86 | this.usrTextBox_Att.KeyUp [if (e.KeyCode == Keys.Enter)] 외 2 | FP01990_Lookup.cs:780 | try ▸ if (dr != null) ▸ for (iCol < siSub.ActiveSheet.Columns.Count) ▸ else of (sValue == "-" \|\| sValue == "*" \|\| string.IsNullOrWhiteSp… | UI_PROP | col.Label | sValue | 속성 Label 설정 |  |  |  |
| AC-f2c26644 | this.usrTextBox_Att.KeyUp [if (e.KeyCode == Keys.Enter)] 외 2 | FP01990_Lookup.cs:795 | try ▸ if (usrTextBox_Att.Text.Length > 0) | DATA_OP | dsMain.Tables[0].Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-5e2036e4 | this.usrTextBox_Att.KeyUp [if (e.KeyCode == Keys.Enter)] 외 2 | FP01990_Lookup.cs:796 | try ▸ if (usrTextBox_Att.Text.Length > 0) ▸ lambda | DATA_OP | s[columIdx].ToString().Contains | (con_param) | 데이터 객체 조작/조회 |  |  |  |
| AC-ea4f7d04 | this.usrTextBox_Att.KeyUp [if (e.KeyCode == Keys.Enter)] 외 2 | FP01990_Lookup.cs:798 | try ▸ if (usrTextBox_Att.Text.Length > 0) ▸ if (dsMain.Tables[0].Select().Where(s => s[columIdx].ToString().Contains(con_param)).Count() > 0… | DATA_OP | dsMain.Tables[0].Select().Where(s => s[columIdx].ToString().Contains(con_param)).CopyToDat… | () | 데이터 객체 조작/조회 |  |  |  |
| AC-9a2e9a30 | this.usrTextBox_Att.KeyUp [if (e.KeyCode == Keys.Enter)] 외 2 | FP01990_Lookup.cs:798 | try ▸ if (usrTextBox_Att.Text.Length > 0) ▸ if (dsMain.Tables[0].Select().Where(s => s[columIdx].ToString().Contains(con_param)).Count() > 0… | DATA_OP | dsMain.Tables[0].Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-e1cfa233 | this.usrTextBox_Att.KeyUp [if (e.KeyCode == Keys.Enter)] 외 2 | FP01990_Lookup.cs:799 | try ▸ if (usrTextBox_Att.Text.Length > 0) ▸ if (dsMain.Tables[0].Select().Where(s => s[columIdx].ToString().Contains(con_param)).Count() > 0… | DATA_OP | s[columIdx].ToString().Contains | (con_param) | 데이터 객체 조작/조회 |  |  |  |
| AC-4e6a73e6 | this.usrTextBox_Att.KeyUp [if (e.KeyCode == Keys.Enter)] 외 2 | FP01990_Lookup.cs:801 | try ▸ if (usrTextBox_Att.Text.Length > 0) ▸ if (dsMain.Tables[0].Select().Where(s => s[columIdx].ToString().Contains(con_param)).Count() > 0… | STATE_RESET | dsMain.Tables.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-ef8f8696 | this.usrTextBox_Att.KeyUp [if (e.KeyCode == Keys.Enter)] 외 2 | FP01990_Lookup.cs:803 | try ▸ if (usrTextBox_Att.Text.Length > 0) ▸ if (dsMain.Tables[0].Select().Where(s => s[columIdx].ToString().Contains(con_param)).Count() > 0… | DATA_OP | dsMain.Tables.Add | (dtSeg) | 데이터 객체 조작/조회 |  |  |  |
| AC-5fc07fe2 | this.usrTextBox_Att.KeyUp [if (e.KeyCode == Keys.Enter)] 외 2 | FP01990_Lookup.cs:807 | try ▸ if (usrTextBox_Att.Text.Length > 0) ▸ else of (dsMain.Tables[0].Select().Where(s => s[columIdx].ToString().Contains(con_param)).Count(… | DATA_OP | dsMain.Tables[0].Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-34c6298d | this.usrTextBox_Att.KeyUp [if (e.KeyCode == Keys.Enter)] 외 2 | FP01990_Lookup.cs:808 | try ▸ if (usrTextBox_Att.Text.Length > 0) ▸ else of (dsMain.Tables[0].Select().Where(s => s[columIdx].ToString().Contains(con_param)).Count(… | STATE_RESET | dsMain.Tables.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-10b86c85 | this.usrTextBox_Att.KeyUp [if (e.KeyCode == Keys.Enter)] 외 2 | FP01990_Lookup.cs:809 | try ▸ if (usrTextBox_Att.Text.Length > 0) ▸ else of (dsMain.Tables[0].Select().Where(s => s[columIdx].ToString().Contains(con_param)).Count(… | DATA_OP | dsMain.Tables.Add | (dtTMP) | 데이터 객체 조작/조회 |  |  |  |
| AC-8889cb45 | this.usrTextBox_Att.KeyUp [if (e.KeyCode == Keys.Enter)] 외 2 | FP01990_Lookup.cs:813 | try | GRID_BIND | siSub.Query | (dsMain) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-7e2ead30 | this.usrTextBox_Att.KeyUp [if (e.KeyCode == Keys.Enter)] 외 2 | FP01990_Lookup.cs:814 | try | GRID_LOCK | siSub.LockColumn | (0, siSub.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-e9918197 | this.usrTextBox_Att.KeyUp [if (e.KeyCode == Keys.Enter)] 외 2 | FP01990_Lookup.cs:819 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9db2db67 | this.usrTextBox_Att.KeyUp [if (e.KeyCode == Keys.Enter)] 외 2 | FP01990_Lookup.cs:824 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-8934d2e1 | this.usrTextBox_Att.KeyUp [if (e.KeyCode == Keys.Enter)] 외 2 | FP01990_Lookup.cs:825 | finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP01990_Lookup.FindData_Sub_Save

진입점: SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-53741f87 | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FP01990_Lookup.cs:838 | try ▸ if (string.IsNullOrWhiteSpace(mainLookupType)) | FLAG | mainLookupType | siMain.GetValue(0, siMain.GetColumnIndex(DefColumns.LOOKUP_TYPE_CODE)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-de4423ef | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FP01990_Lookup.cs:840 | try | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-8de5dbbb | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FP01990_Lookup.cs:844 | try | FLAG | dsMain | null | 화면 필드/플래그 변경 |  |  |  |
| AC-b96c9521 | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FP01990_Lookup.cs:854 | try | FLAG | dsMain | Find_Data_sub("SELECT") | 화면 필드/플래그 변경 |  |  |  |
| AC-d54a5031 | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FP01990_Lookup.cs:856 | try | FLAG | dsMain_sub | dsMain.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-7a4a8a5d | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FP01990_Lookup.cs:856 | try | DATA_OP | dsMain.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-39301f16 | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FP01990_Lookup.cs:858 | try | FLAG | siSub | GetSheetInfo(spdSub.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-8070d94c | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FP01990_Lookup.cs:867 | try ▸ if (dr != null) ▸ for (iCol < siSub.ActiveSheet.Columns.Count) | DATA_OP | dtColumInfo.Columns.Contains | (sColName) | 데이터 객체 조작/조회 |  |  |  |
| AC-27f39704 | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FP01990_Lookup.cs:875 | try ▸ if (dr != null) ▸ for (iCol < siSub.ActiveSheet.Columns.Count) ▸ if (sValue == "-" \|\| sValue == "*" \|\| string.IsNullOrWhiteSpace(s… | STATE | col.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-5982d9d3 | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FP01990_Lookup.cs:881 | try ▸ if (dr != null) ▸ for (iCol < siSub.ActiveSheet.Columns.Count) ▸ else of (sValue == "-" \|\| sValue == "*" \|\| string.IsNullOrWhiteSp… | UI_PROP | col.Label | sValue | 속성 Label 설정 |  |  |  |
| AC-516ed60b | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FP01990_Lookup.cs:886 | try | GRID_BIND | siSub.Query | (dsMain) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-8151adda | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FP01990_Lookup.cs:887 | try | GRID_LOCK | siSub.LockColumn | (0, siSub.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-458ee623 | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FP01990_Lookup.cs:893 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6279cc56 | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FP01990_Lookup.cs:898 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-c51f0d00 | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FP01990_Lookup.cs:899 | finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP01990_Lookup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-854fff88 | this.Load | FP01990_Lookup.cs:168 |  | FLAG | dtSystem | GSCM.Windows.Forms.Service.LookupService.GetAsTableFp("FP01990_LOOKUP", "SYSTEM_TYPE") | 화면 필드/플래그 변경 |  |  |  |
| AC-4d35dc9f | this.Load | FP01990_Lookup.cs:168 |  | CALL_EXT | GSCM.Windows.Forms.Service.LookupService.GetAsTableFp | ("FP01990_LOOKUP", "SYSTEM_TYPE") | ⚠ 의미 확인 필요 |  |  |  |
| AC-e98ddc12 | this.Load | FP01990_Lookup.cs:176 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP01990_Lookup.GetFilter

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8b282835 | (진입점 미연결) | FP01990_Lookup.cs:1443 |  | RETURN | return Filter[key]; |  | 처리 중단/반환 |  |  |  |

## FP01990_Lookup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-57550839 | this.Load | FP01990_Lookup.cs:206 |  | LIST_CLEAR | cboLookupGroup.Items.Clear | () | 목록 항목 비움 |  |  |  |
| AC-3a8d94f8 | this.Load | FP01990_Lookup.cs:207 |  | DATA_OP | cboLookupGroup.Items.Add | ("FP") | 데이터 객체 조작/조회 |  |  |  |
| AC-2e447d92 | this.Load | FP01990_Lookup.cs:208 |  | VALUE_SET | cboLookupGroup.Text | "FP" | 컨트롤 값 설정 |  |  |  |
| AC-5a30825b | this.Load | FP01990_Lookup.cs:210 |  | DATA_OP | usrComboBox_Seg.Items.Add | ("SEGMENT1") | 데이터 객체 조작/조회 |  |  |  |
| AC-f1889c14 | this.Load | FP01990_Lookup.cs:211 |  | DATA_OP | usrComboBox_Seg.Items.Add | ("SEGMENT2") | 데이터 객체 조작/조회 |  |  |  |
| AC-de7ecf46 | this.Load | FP01990_Lookup.cs:212 |  | DATA_OP | usrComboBox_Seg.Items.Add | ("SEGMENT3") | 데이터 객체 조작/조회 |  |  |  |
| AC-d895674e | this.Load | FP01990_Lookup.cs:213 |  | DATA_OP | usrComboBox_Seg.Items.Add | ("SEGMENT4") | 데이터 객체 조작/조회 |  |  |  |
| AC-7a007765 | this.Load | FP01990_Lookup.cs:214 |  | DATA_OP | usrComboBox_Seg.Items.Add | ("SEGMENT5") | 데이터 객체 조작/조회 |  |  |  |
| AC-85e7efb7 | this.Load | FP01990_Lookup.cs:216 |  | VALUE_SET | usrComboBox_Seg.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-3e2fd90e | this.Load | FP01990_Lookup.cs:219 |  | LIST_REBIND | cboValid.DataBind | (Data.Type.YesOrNo, true) ⇒ biz:CommonData.YesOrNo | 목록 컨트롤 재구성 |  |  |  |
| AC-9973af4b | this.Load | FP01990_Lookup.cs:221 |  | VALUE_SET | cboValid.SelectedValue | "Y" | 컨트롤 값 설정 |  |  |  |
| AC-81bba91a | this.Load | FP01990_Lookup.cs:223 |  | FLAG | dtColumInfo | new DataTable() | 화면 필드/플래그 변경 |  |  |  |
| AC-61bf50cc | this.Load | FP01990_Lookup.cs:227 | foreach (string str in sColumnList) | DATA_OP | dtColumInfo.Columns.Add | (str) | 데이터 객체 조작/조회 |  |  |  |
| AC-69a9d8c0 | this.Load | FP01990_Lookup.cs:230 |  | FLAG | dtColumInfo_Sub | new DataTable() | 화면 필드/플래그 변경 |  |  |  |
| AC-0f9304f6 | this.Load | FP01990_Lookup.cs:233 | foreach (string str in sColumnList_Sub) | DATA_OP | dtColumInfo_Sub.Columns.Add | (str) | 데이터 객체 조작/조회 |  |  |  |

## FP01990_Lookup.InitSpread

진입점: this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == true) ▸ if (_UpAct_Cell != _PressAct_Cell) ▸ try] / this.usrTextBox_Att.KeyUp [if (e.KeyCode == Keys.Enter) ▸ try] / this.simpleButton1.Click [try] / this.Load / this.spdMain.CellClick [if (siMain.IsLock(siMain.SheetName) == true) ▸ try] / this.spdMain.ActiveSheet.CellChanged [if (siMain.IsLock(siMain.SheetName) == true) ▸ try] / FindButton / SaveButton [if (fps.Name == "spdMain")] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c979fae2 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP01990_Lookup.cs:255 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.InitSheet | (spreadInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-ec80197c | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP01990_Lookup.cs:257 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddActionTextBox | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-83f63a33 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP01990_Lookup.cs:259 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Lookup Type Name*", DefColumns.LOOKUP_TYPE_CODE, FPMerge.None, 160, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-afb02bef | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP01990_Lookup.cs:260 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Lookup Description*", DefColumns.LOOKUP_DESCRIPTION, FPMerge.None, 220, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6ea53111 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP01990_Lookup.cs:261 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddComboColumn | ("System Type Code*", DefColumns.SYSTEM_TYPE_CODE, FPMerge.None, 80, true, dtSystem, FPHAl… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0a600f9e | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP01990_Lookup.cs:262 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddComboColumn | ("Active*", DefColumns.ACTIVE, FPMerge.None, 50, true, dtYesOrNo, FPHAlign.Center, FPVAlig… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-de311670 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP01990_Lookup.cs:263 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Segment1*", DefColumns.SEGMENT1, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-bb16a3bb | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP01990_Lookup.cs:264 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Segment2*", DefColumns.SEGMENT2, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-297fa3b6 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP01990_Lookup.cs:265 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Segment3*", DefColumns.SEGMENT3, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-bf744bdb | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP01990_Lookup.cs:266 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Segment4*", DefColumns.SEGMENT4, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b57aee59 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP01990_Lookup.cs:267 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Segment5*", DefColumns.SEGMENT5, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c9542477 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP01990_Lookup.cs:268 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute1", DefColumns.ATTRIBUTE1, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4d4689d0 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP01990_Lookup.cs:269 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute2", DefColumns.ATTRIBUTE2, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-49994d67 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP01990_Lookup.cs:270 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute3", DefColumns.ATTRIBUTE3, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-710585a3 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP01990_Lookup.cs:271 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute4", DefColumns.ATTRIBUTE4, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-66bd7da1 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP01990_Lookup.cs:272 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute5", DefColumns.ATTRIBUTE5, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9cf49b4b | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP01990_Lookup.cs:273 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute6", DefColumns.ATTRIBUTE6, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5e257f78 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP01990_Lookup.cs:274 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute7", DefColumns.ATTRIBUTE7, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0be03ae6 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP01990_Lookup.cs:275 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute8", DefColumns.ATTRIBUTE8, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d893ff0e | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP01990_Lookup.cs:276 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute9", DefColumns.ATTRIBUTE9, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e53dec8e | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP01990_Lookup.cs:277 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute10", DefColumns.ATTRIBUTE10, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9e60ec0b | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP01990_Lookup.cs:278 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute11", DefColumns.ATTRIBUTE11, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8d698617 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP01990_Lookup.cs:279 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute12", DefColumns.ATTRIBUTE12, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5ac4cd7c | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP01990_Lookup.cs:280 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute13", DefColumns.ATTRIBUTE13, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-aa7e785b | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP01990_Lookup.cs:281 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute14", DefColumns.ATTRIBUTE14, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-90b52abe | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP01990_Lookup.cs:282 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute15", DefColumns.ATTRIBUTE15, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-67809e96 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP01990_Lookup.cs:285 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddDateTimeColumn | ("Last Update", DefColumns.MODIFY_DATE, FPMerge.None, 160, true, FPHAlign.Center, FPVAlign… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-961e5a7d | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP01990_Lookup.cs:286 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Update ID", DefColumns.modify_user_id, FPMerge.None, 100, true, FPHAlign.Center, FPVAlig… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-88b38ad5 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP01990_Lookup.cs:288 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.Freeze | (0, siMain.GetColumnIndex(DefColumns.LOOKUP_DESCRIPTION)) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-91dee114 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP01990_Lookup.cs:290 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-6603bf3d | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP01990_Lookup.cs:295 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.InitSheet | (spreadInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-2bb6b17c | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP01990_Lookup.cs:297 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddActionTextBox | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-69bf10e7 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP01990_Lookup.cs:298 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("lookup type code*", DefColumns.LOOKUP_TYPE_CODE, FPMerge.None, 160, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-27b6cb78 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP01990_Lookup.cs:299 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Segment1", DefColumns.SEGMENT1, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-112003d7 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP01990_Lookup.cs:300 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Segment2", DefColumns.SEGMENT2, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4e2c56c7 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP01990_Lookup.cs:301 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Segment3", DefColumns.SEGMENT3, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-930b9234 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP01990_Lookup.cs:302 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Segment4", DefColumns.SEGMENT4, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5d0e1d9a | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP01990_Lookup.cs:303 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Segment5", DefColumns.SEGMENT5, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-73d05703 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP01990_Lookup.cs:304 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddComboColumn | ("Active", DefColumns.ACTIVE, FPMerge.None, 50, true, dtYesOrNo, FPHAlign.Center, FPVAlign… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-745795a1 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP01990_Lookup.cs:305 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute1", DefColumns.ATTRIBUTE1, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-495a9d0f | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP01990_Lookup.cs:306 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute2", DefColumns.ATTRIBUTE2, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f51d88ca | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP01990_Lookup.cs:307 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute3", DefColumns.ATTRIBUTE3, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b8a96e1f | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP01990_Lookup.cs:308 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute4", DefColumns.ATTRIBUTE4, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-977b1c91 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP01990_Lookup.cs:309 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute5", DefColumns.ATTRIBUTE5, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f877d2ce | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP01990_Lookup.cs:310 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute6", DefColumns.ATTRIBUTE6, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4d8bed61 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP01990_Lookup.cs:311 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute7", DefColumns.ATTRIBUTE7, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-686c64c6 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP01990_Lookup.cs:312 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute8", DefColumns.ATTRIBUTE8, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1c130291 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP01990_Lookup.cs:313 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute9", DefColumns.ATTRIBUTE9, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-54f2f9f3 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP01990_Lookup.cs:314 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute10", DefColumns.ATTRIBUTE10, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2e77adef | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP01990_Lookup.cs:315 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute11", DefColumns.ATTRIBUTE11, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d75ee0f8 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP01990_Lookup.cs:316 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute12", DefColumns.ATTRIBUTE12, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f3afe233 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP01990_Lookup.cs:317 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute13", DefColumns.ATTRIBUTE13, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ff42329d | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP01990_Lookup.cs:318 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute14", DefColumns.ATTRIBUTE14, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4c727c32 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP01990_Lookup.cs:319 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute15", DefColumns.ATTRIBUTE15, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4b89ddb4 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP01990_Lookup.cs:320 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Sort Order", DefColumns.SORT_ORDER, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a94d4007 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP01990_Lookup.cs:321 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Value Description", DefColumns.VALUE_DESCRIPTION, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f1aef1bd | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP01990_Lookup.cs:326 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddDateTimeColumn | ("Last Update Date", DefColumns.MODIFY_DATE, FPMerge.None, 160, true, FPHAlign.Center, FPV… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a04d2248 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP01990_Lookup.cs:327 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Last Updated By", DefColumns.modify_user_id, FPMerge.None, 100, true, FPHAlign.Center, F… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9605d4c7 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP01990_Lookup.cs:330 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Segment1", DefColumns.SEGMENT1_KEY, FPMerge.None, 120, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f12a2722 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP01990_Lookup.cs:331 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Segment2", DefColumns.SEGMENT2_KEY, FPMerge.None, 120, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9a199420 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP01990_Lookup.cs:332 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Segment3", DefColumns.SEGMENT3_KEY, FPMerge.None, 120, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-28abf184 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP01990_Lookup.cs:333 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Segment4", DefColumns.SEGMENT4_KEY, FPMerge.None, 120, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-102a9eef | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP01990_Lookup.cs:334 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Segment5", DefColumns.SEGMENT5_KEY, FPMerge.None, 120, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4951bf14 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP01990_Lookup.cs:336 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.Freeze | (0, siMain.GetColumnIndex(DefColumns.LOOKUP_DESCRIPTION)) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-fda554aa | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP01990_Lookup.cs:338 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP01990_Lookup.InsertRow

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-11082f25 | InsertButton | FP01990_Lookup.cs:1125 | if (fps.Name == "spdMain") | DATA_OP | siMain.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-040181ae | InsertButton | FP01990_Lookup.cs:1128 | if (fps.Name == "spdMain") | DATA_OP | defaultData.Add | (DefColumns.ACTIVE, "Y") | 데이터 객체 조작/조회 |  |  |  |
| AC-c3e34c0f | InsertButton | FP01990_Lookup.cs:1130 | if (fps.Name == "spdMain") | GRID_SET | siMain.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |
| AC-df238aad | InsertButton | FP01990_Lookup.cs:1136 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") | DATA_OP | siSub.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-22d1dc3d | InsertButton | FP01990_Lookup.cs:1138 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") | DATA_OP | defaultData.Add | (DefColumns.LOOKUP_TYPE_CODE, mainLookupType) | 데이터 객체 조작/조회 |  |  |  |
| AC-d752c9d3 | InsertButton | FP01990_Lookup.cs:1139 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") | DATA_OP | defaultData.Add | (DefColumns.SEGMENT1, "-") | 데이터 객체 조작/조회 |  |  |  |
| AC-719d4678 | InsertButton | FP01990_Lookup.cs:1140 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") | DATA_OP | defaultData.Add | (DefColumns.SEGMENT2, "-") | 데이터 객체 조작/조회 |  |  |  |
| AC-c0de0ee7 | InsertButton | FP01990_Lookup.cs:1141 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") | DATA_OP | defaultData.Add | (DefColumns.SEGMENT3, "-") | 데이터 객체 조작/조회 |  |  |  |
| AC-ecedad2d | InsertButton | FP01990_Lookup.cs:1142 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") | DATA_OP | defaultData.Add | (DefColumns.SEGMENT4, "-") | 데이터 객체 조작/조회 |  |  |  |
| AC-e7c1c972 | InsertButton | FP01990_Lookup.cs:1143 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") | DATA_OP | defaultData.Add | (DefColumns.SEGMENT5, "-") | 데이터 객체 조작/조회 |  |  |  |
| AC-ed10e962 | InsertButton | FP01990_Lookup.cs:1144 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") | DATA_OP | defaultData.Add | (DefColumns.ACTIVE, "Y") | 데이터 객체 조작/조회 |  |  |  |
| AC-f1e6e1b4 | InsertButton | FP01990_Lookup.cs:1146 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") | GRID_SET | siSub.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |
| AC-37fb5c76 | InsertButton | FP01990_Lookup.cs:1149 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") | GRID_LOCK | siSub.LockRange | (insCell, siSub.GetColumnIndex(DefColumns.LOOKUP_TYPE_CODE), siSub.GetColumnIndex(DefColum… | 그리드 편집 잠금/해제 |  |  |  |

## FP01990_Lookup.RefreshSpreadSheet

진입점: FindButton [try] / SaveButton [if (fps.Name == "spdMain") ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-52c2f01a | FindButton [try] 외 1 | FP01990_Lookup.cs:470 | if (mode == "MAIN") | CALL_EXT | siMain.EditQuery | (dsMain) | ⚠ 의미 확인 필요 |  |  |  |
| AC-df7881ae | FindButton [try] 외 1 | FP01990_Lookup.cs:471 | if (mode == "MAIN") | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-43417e42 | FindButton [try] 외 1 | FP01990_Lookup.cs:475 | else of (mode == "MAIN") ▸ if (mode == "SUB") | CALL_EXT | siSub.EditQuery | (dsMain) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d03e256a | FindButton [try] 외 1 | FP01990_Lookup.cs:476 | else of (mode == "MAIN") ▸ if (mode == "SUB") | GRID_LOCK | siSub.LockColumn | (0, siSub.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |

## FP01990_Lookup.RunSqlSource

진입점: popSql.OnSql

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0147fc09 | popSql.OnSql | FP01990_Lookup.cs:1468 | if (fps.Name == "spdMain") | RETURN | return Find_Data_Amend("SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-7ab0e99c | popSql.OnSql | FP01990_Lookup.cs:1473 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") | RETURN | return Find_Data_sub("SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-3fcef44f | popSql.OnSql | FP01990_Lookup.cs:1476 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP01990_Lookup.SaveData

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9f550e57 | SaveButton | FP01990_Lookup.cs:912 | if (fps.Name == "spdMain") | VALIDATE | DataUtil.checkRequiredOfSpread | (siMain) | 프레임워크 검증 |  |  |  |
| AC-dcf042e8 | SaveButton | FP01990_Lookup.cs:912 | if (fps.Name == "spdMain") ▸ if (!DataUtil.checkRequiredOfSpread(siMain)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a606fb33 | SaveButton | FP01990_Lookup.cs:917 | if (fps.Name == "spdMain") ▸ if (siMain.SpreadObject.DataSource != null) ▸ if (!CheckValidation(siMain)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9d8ba19b | SaveButton | FP01990_Lookup.cs:920 | if (fps.Name == "spdMain") | FLAG | SaveFilter | Filter.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-bfeff464 | SaveButton | FP01990_Lookup.cs:920 | if (fps.Name == "spdMain") | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-1cf972c9 | SaveButton | FP01990_Lookup.cs:925 | if (fps.Name == "spdMain") ▸ if (siMain.SpreadObject.DataSource != null) | DATA_OP | (siMain.SpreadObject.DataSource as DataSet).Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-ca37e91b | SaveButton | FP01990_Lookup.cs:926 | if (fps.Name == "spdMain") ▸ if (siMain.SpreadObject.DataSource != null) | DATA_OP | saveDS.Tables[0].Columns.Add | (CAppSetting.StringAction, typeof(char)) | 데이터 객체 조작/조회 |  |  |  |
| AC-af124238 | SaveButton | FP01990_Lookup.cs:948 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | SaveFilter["LOOKUP_TYPE_CODE"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.LOOKUP_TYPE_CODE)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-69318824 | SaveButton | FP01990_Lookup.cs:949 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | SaveFilter["LOOKUP_DESCRIPTION"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.LOOKUP_DESCRIPTION)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-7eb22e45 | SaveButton | FP01990_Lookup.cs:950 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | SaveFilter["SYSTEM_TYPE_CODE"] | "FP" | 행/컬럼 값 대입 |  |  |  |
| AC-4c9bae23 | SaveButton | FP01990_Lookup.cs:955 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ACTIVE)).ToString(… | DATA_OP | SaveFilter["ACTIVE_FLAG"] | "Y" | 행/컬럼 값 대입 |  |  |  |
| AC-1f8aa3dc | SaveButton | FP01990_Lookup.cs:959 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ACTIVE)).ToSt… | DATA_OP | SaveFilter["ACTIVE_FLAG"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ACTIVE)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-a5f6c6cd | SaveButton | FP01990_Lookup.cs:961 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | SaveFilter["SEGMENT1"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.SEGMENT1)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-d54b6012 | SaveButton | FP01990_Lookup.cs:962 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | SaveFilter["SEGMENT2"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.SEGMENT2)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-8fb4e9dc | SaveButton | FP01990_Lookup.cs:963 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | SaveFilter["SEGMENT3"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.SEGMENT3)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-86d0c12b | SaveButton | FP01990_Lookup.cs:964 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | SaveFilter["SEGMENT4"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.SEGMENT4)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-2b540796 | SaveButton | FP01990_Lookup.cs:965 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | SaveFilter["SEGMENT5"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.SEGMENT5)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-1e603ea7 | SaveButton | FP01990_Lookup.cs:966 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | SaveFilter["ATTRIBUTE1"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ATTRIBUTE1)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-b146b497 | SaveButton | FP01990_Lookup.cs:967 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | SaveFilter["ATTRIBUTE2"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ATTRIBUTE2)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-b4a8976d | SaveButton | FP01990_Lookup.cs:968 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | SaveFilter["ATTRIBUTE3"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ATTRIBUTE3)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-5e72d94d | SaveButton | FP01990_Lookup.cs:969 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | SaveFilter["ATTRIBUTE4"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ATTRIBUTE4)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-beee7fdb | SaveButton | FP01990_Lookup.cs:970 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | SaveFilter["ATTRIBUTE5"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ATTRIBUTE5)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-911fcb44 | SaveButton | FP01990_Lookup.cs:971 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | SaveFilter["ATTRIBUTE6"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ATTRIBUTE6)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-8d32110f | SaveButton | FP01990_Lookup.cs:972 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | SaveFilter["ATTRIBUTE7"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ATTRIBUTE7)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-7930d5ae | SaveButton | FP01990_Lookup.cs:973 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | SaveFilter["ATTRIBUTE8"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ATTRIBUTE8)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-bc5226fb | SaveButton | FP01990_Lookup.cs:974 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | SaveFilter["ATTRIBUTE9"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ATTRIBUTE9)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-46b6a0ba | SaveButton | FP01990_Lookup.cs:975 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | SaveFilter["ATTRIBUTE10"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ATTRIBUTE10)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-c2ce91cc | SaveButton | FP01990_Lookup.cs:976 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | SaveFilter["ATTRIBUTE11"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ATTRIBUTE11)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-75477df6 | SaveButton | FP01990_Lookup.cs:977 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | SaveFilter["ATTRIBUTE12"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ATTRIBUTE12)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-5ddd2467 | SaveButton | FP01990_Lookup.cs:978 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | SaveFilter["ATTRIBUTE13"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ATTRIBUTE13)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-98517067 | SaveButton | FP01990_Lookup.cs:979 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | SaveFilter["ATTRIBUTE14"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ATTRIBUTE14)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-88ed4787 | SaveButton | FP01990_Lookup.cs:980 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | SaveFilter["ATTRIBUTE15"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ATTRIBUTE15)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-47457776 | SaveButton | FP01990_Lookup.cs:1012 | if (fps.Name == "spdMain") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { done.ToString() }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-eb3aabd0 | SaveButton | FP01990_Lookup.cs:1020 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") | VALIDATE | DataUtil.checkRequiredOfSpread | (siSub) | 프레임워크 검증 |  |  |  |
| AC-ec5121ac | SaveButton | FP01990_Lookup.cs:1020 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ if (!DataUtil.checkRequiredOfSpread(siSub)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6f06be92 | SaveButton | FP01990_Lookup.cs:1022 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ if (!CheckValidation(siSub)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-473a596f | SaveButton | FP01990_Lookup.cs:1024 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") | FLAG | SaveFilter | Filter.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-77591b18 | SaveButton | FP01990_Lookup.cs:1024 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-bf331566 | SaveButton | FP01990_Lookup.cs:1028 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") | DATA_OP | (siSub.SpreadObject.DataSource as DataSet).Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-30955723 | SaveButton | FP01990_Lookup.cs:1029 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") | DATA_OP | saveDS.Tables[0].Columns.Add | (CAppSetting.StringAction, typeof(char)) | 데이터 객체 조작/조회 |  |  |  |
| AC-3a6d5078 | SaveButton | FP01990_Lookup.cs:1041 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | SaveFilter["LOOKUP_TYPE_CODE"] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.LOOKUP_TYPE_CODE)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-08525427 | SaveButton | FP01990_Lookup.cs:1044 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) ▸ if (siSub.GetValue(i, siSub.GetColumnIndex… | DATA_OP | SaveFilter["LOOKUP_DESCRIPTION"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-2dab225b | SaveButton | FP01990_Lookup.cs:1048 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) ▸ else of (siSub.GetValue(i, siSub.GetColumn… | DATA_OP | SaveFilter["LOOKUP_DESCRIPTION"] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.LOOKUP_DESCRIPTION)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-d7df05a2 | SaveButton | FP01990_Lookup.cs:1051 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | SaveFilter["SYSTEM_TYPE_CODE"] | "FP" | 행/컬럼 값 대입 |  |  |  |
| AC-408bd0aa | SaveButton | FP01990_Lookup.cs:1056 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) ▸ if (siSub.GetValue(i, siSub.GetColumnIndex… | DATA_OP | SaveFilter["ACTIVE_FLAG"] | "Y" | 행/컬럼 값 대입 |  |  |  |
| AC-0372302a | SaveButton | FP01990_Lookup.cs:1060 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) ▸ else of (siSub.GetValue(i, siSub.GetColumn… | DATA_OP | SaveFilter["ACTIVE_FLAG"] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.ACTIVE)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-ea0900c8 | SaveButton | FP01990_Lookup.cs:1062 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | SaveFilter["SEGMENT1"] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.SEGMENT1)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-fbaa3ffb | SaveButton | FP01990_Lookup.cs:1063 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | SaveFilter["SEGMENT2"] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.SEGMENT2)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-b082cb9e | SaveButton | FP01990_Lookup.cs:1064 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | SaveFilter["SEGMENT3"] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.SEGMENT3)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-0ab2214c | SaveButton | FP01990_Lookup.cs:1065 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | SaveFilter["SEGMENT4"] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.SEGMENT4)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-90b9ffec | SaveButton | FP01990_Lookup.cs:1066 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | SaveFilter["SEGMENT5"] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.SEGMENT5)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-40c28425 | SaveButton | FP01990_Lookup.cs:1068 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | SaveFilter["SEGMENT1_KEY"] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.SEGMENT1_KEY)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-70ec9cd3 | SaveButton | FP01990_Lookup.cs:1069 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | SaveFilter["SEGMENT2_KEY"] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.SEGMENT2_KEY)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-be1d867c | SaveButton | FP01990_Lookup.cs:1070 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | SaveFilter["SEGMENT3_KEY"] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.SEGMENT3_KEY)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-2fa636ff | SaveButton | FP01990_Lookup.cs:1071 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | SaveFilter["SEGMENT4_KEY"] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.SEGMENT4_KEY)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-40c9bd73 | SaveButton | FP01990_Lookup.cs:1072 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | SaveFilter["SEGMENT5_KEY"] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.SEGMENT5_KEY)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-7214faba | SaveButton | FP01990_Lookup.cs:1075 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | SaveFilter["ATTRIBUTE1"] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.ATTRIBUTE1)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-d5f2a515 | SaveButton | FP01990_Lookup.cs:1076 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | SaveFilter["ATTRIBUTE2"] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.ATTRIBUTE2)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-19a3f5d5 | SaveButton | FP01990_Lookup.cs:1077 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | SaveFilter["ATTRIBUTE3"] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.ATTRIBUTE3)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-495fdc80 | SaveButton | FP01990_Lookup.cs:1078 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | SaveFilter["ATTRIBUTE4"] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.ATTRIBUTE4)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-5068e621 | SaveButton | FP01990_Lookup.cs:1079 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | SaveFilter["ATTRIBUTE5"] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.ATTRIBUTE5)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-a1512695 | SaveButton | FP01990_Lookup.cs:1080 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | SaveFilter["ATTRIBUTE6"] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.ATTRIBUTE6)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-411d5276 | SaveButton | FP01990_Lookup.cs:1081 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | SaveFilter["ATTRIBUTE7"] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.ATTRIBUTE7)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-bbc4a148 | SaveButton | FP01990_Lookup.cs:1082 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | SaveFilter["ATTRIBUTE8"] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.ATTRIBUTE8)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-a1f75999 | SaveButton | FP01990_Lookup.cs:1083 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | SaveFilter["ATTRIBUTE9"] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.ATTRIBUTE9)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-a5fd332f | SaveButton | FP01990_Lookup.cs:1084 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | SaveFilter["ATTRIBUTE10"] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.ATTRIBUTE10)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-8009f1cc | SaveButton | FP01990_Lookup.cs:1085 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | SaveFilter["ATTRIBUTE11"] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.ATTRIBUTE11)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-17042ce3 | SaveButton | FP01990_Lookup.cs:1086 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | SaveFilter["ATTRIBUTE12"] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.ATTRIBUTE12)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-38b864a9 | SaveButton | FP01990_Lookup.cs:1087 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | SaveFilter["ATTRIBUTE13"] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.ATTRIBUTE13)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-1fbed34b | SaveButton | FP01990_Lookup.cs:1088 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | SaveFilter["ATTRIBUTE14"] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.ATTRIBUTE14)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-382d93ec | SaveButton | FP01990_Lookup.cs:1089 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | SaveFilter["ATTRIBUTE15"] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.ATTRIBUTE15)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-e5b77b82 | SaveButton | FP01990_Lookup.cs:1097 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) ▸ if (result) | DATA_OP | SaveFilter["SORT_ORDER"] | m_num.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-6ec641a3 | SaveButton | FP01990_Lookup.cs:1101 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) ▸ else of (result) | DATA_OP | SaveFilter["SORT_ORDER"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-3180565f | SaveButton | FP01990_Lookup.cs:1104 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | SaveFilter["VALUE_DESCRIPTION"] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.VALUE_DESCRIPTION)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-31371e2e | SaveButton | FP01990_Lookup.cs:1114 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { done.ToString() }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## FP01990_Lookup.SetColumInfo

진입점: this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == true) ▸ if (_UpAct_Cell != _PressAct_Cell)] / this.spdMain.CellClick [if (siMain.IsLock(siMain.SheetName) == true)] / this.spdMain.ActiveSheet.CellChanged [if (siMain.IsLock(siMain.SheetName) == true)] / FindButton [if (siMain.ActiveSheet.RowCount > 0)] / SaveButton [if (fps.Name == "spdMain") ▸ if (siMain.ActiveSheet.RowCount > 0)] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9fed810f | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP01990_Lookup.cs:1311 |  | DATA_OP | dtColumInfo.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-a3bb0f40 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP01990_Lookup.cs:1312 |  | DATA_OP | dr[DefColumns.SEGMENT1] | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.SEGMENT1)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-09ce8c93 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP01990_Lookup.cs:1313 |  | DATA_OP | dr[DefColumns.SEGMENT2] | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.SEGMENT2)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-9b672301 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP01990_Lookup.cs:1314 |  | DATA_OP | dr[DefColumns.SEGMENT3] | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.SEGMENT3)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-c7a632e6 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP01990_Lookup.cs:1315 |  | DATA_OP | dr[DefColumns.SEGMENT4] | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.SEGMENT4)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-a7adf57f | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP01990_Lookup.cs:1316 |  | DATA_OP | dr[DefColumns.SEGMENT5] | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.SEGMENT5)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-cdceb4ea | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP01990_Lookup.cs:1317 |  | DATA_OP | dr[DefColumns.ATTRIBUTE1] | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ATTRIBUTE1)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-5d868597 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP01990_Lookup.cs:1318 |  | DATA_OP | dr[DefColumns.ATTRIBUTE2] | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ATTRIBUTE2)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-41985c8a | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP01990_Lookup.cs:1319 |  | DATA_OP | dr[DefColumns.ATTRIBUTE3] | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ATTRIBUTE3)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-23e472cb | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP01990_Lookup.cs:1320 |  | DATA_OP | dr[DefColumns.ATTRIBUTE4] | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ATTRIBUTE4)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-52d2d631 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP01990_Lookup.cs:1321 |  | DATA_OP | dr[DefColumns.ATTRIBUTE5] | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ATTRIBUTE5)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-a931b181 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP01990_Lookup.cs:1322 |  | DATA_OP | dr[DefColumns.ATTRIBUTE6] | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ATTRIBUTE6)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-326c9359 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP01990_Lookup.cs:1323 |  | DATA_OP | dr[DefColumns.ATTRIBUTE7] | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ATTRIBUTE7)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-7143a778 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP01990_Lookup.cs:1324 |  | DATA_OP | dr[DefColumns.ATTRIBUTE8] | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ATTRIBUTE8)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-a269b908 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP01990_Lookup.cs:1325 |  | DATA_OP | dr[DefColumns.ATTRIBUTE9] | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ATTRIBUTE9)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-1cac059e | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP01990_Lookup.cs:1326 |  | DATA_OP | dr[DefColumns.ATTRIBUTE10] | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ATTRIBUTE10)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-8fbf3984 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP01990_Lookup.cs:1327 |  | DATA_OP | dr[DefColumns.ATTRIBUTE11] | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ATTRIBUTE11)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-bda52c30 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP01990_Lookup.cs:1328 |  | DATA_OP | dr[DefColumns.ATTRIBUTE12] | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ATTRIBUTE12)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-799c5c0d | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP01990_Lookup.cs:1329 |  | DATA_OP | dr[DefColumns.ATTRIBUTE13] | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ATTRIBUTE13)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-21fe82da | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP01990_Lookup.cs:1330 |  | DATA_OP | dr[DefColumns.ATTRIBUTE14] | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ATTRIBUTE14)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-05e30cca | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP01990_Lookup.cs:1331 |  | DATA_OP | dr[DefColumns.ATTRIBUTE15] | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ATTRIBUTE15)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-951149f9 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP01990_Lookup.cs:1333 |  | DATA_OP | dtColumInfo.Rows.Add | (dr) | 데이터 객체 조작/조회 |  |  |  |

## FP01990_Lookup.SetDevOption

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-06e182f6 | this.Load | FP01990_Lookup.cs:189 |  | CALL_EXT | UserService.HasExtraRole | (_CurrentUser) | ⚠ 의미 확인 필요 |  |  |  |
| AC-1b3af292 | this.Load | FP01990_Lookup.cs:191 | if (UserService.HasExtraRole(_CurrentUser)) | STATE | btnSql.Visible | true | 컨트롤 상태 Visible |  |  |  |
| AC-59583051 | this.Load | FP01990_Lookup.cs:195 | else of (UserService.HasExtraRole(_CurrentUser)) | STATE | btnSql.Visible | false | 컨트롤 상태 Visible |  |  |  |

## FP01990_Lookup.simpleButton1_Click

진입점: this.simpleButton1.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7e348226 | this.simpleButton1.Click | FP01990_Lookup.cs:1523 | if (!siMain.IsLock(siMain.SheetName) \|\| !siSub.IsLock(siSub.SheetName)) | MESSAGE | MessageBox.Show | ("Can't search in Edit-Mode") | 메시지 표시 |  |  |  |
| AC-7c4b249d | this.simpleButton1.Click | FP01990_Lookup.cs:1524 | if (!siMain.IsLock(siMain.SheetName) \|\| !siSub.IsLock(siSub.SheetName)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP01990_Lookup.SpdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2de3e5ed | this.spdMain.CellClick | FP01990_Lookup.cs:1277 | if (siMain.IsLock(siMain.SheetName) == true) ▸ if (siMain.Sheet().Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-55483d83 | this.spdMain.CellClick | FP01990_Lookup.cs:1279 | if (siMain.IsLock(siMain.SheetName) == true) | FLAG | _UpAct_Cell | this.spdMain.ActiveSheet.ActiveCell.Row.Index2.ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-72db3977 | this.spdMain.CellClick | FP01990_Lookup.cs:1281 | if (siMain.IsLock(siMain.SheetName) == true) | FLAG | mainLookupType | siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.LOOKUP_TYPE_CODE)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-b4809679 | this.spdMain.CellClick | FP01990_Lookup.cs:1282 | if (siMain.IsLock(siMain.SheetName) == true) | DATA_OP | Filter["ACTIVE_FLAG"] | siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.ACTIVE)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-20cfbc1e | this.spdMain.CellClick | FP01990_Lookup.cs:1284 | if (siMain.IsLock(siMain.SheetName) == true) | STATE_RESET | dtColumInfo.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |

## FP01990_Lookup.SpdMain_CellDoubleClick

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6bd3b028 | (진입점 미연결) | FP01990_Lookup.cs:1296 | if (siMain.IsLock(siMain.SheetName) == true) ▸ if (siMain.Sheet().Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-23be1849 | (진입점 미연결) | FP01990_Lookup.cs:1298 | if (siMain.IsLock(siMain.SheetName) == true) | FLAG | mainLookupType | siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.LOOKUP_TYPE_CODE)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-cf0fed45 | (진입점 미연결) | FP01990_Lookup.cs:1299 | if (siMain.IsLock(siMain.SheetName) == true) | DATA_OP | Filter["ACTIVE_FLAG"] | siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.ACTIVE)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-8ece3378 | (진입점 미연결) | FP01990_Lookup.cs:1301 | if (siMain.IsLock(siMain.SheetName) == true) | STATE_RESET | dtColumInfo.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |

## FP01990_Lookup.spdMain_KeyUp

진입점: this.spdMain.KeyUp

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-aa97e322 | this.spdMain.KeyUp | FP01990_Lookup.cs:1489 | if (siMain.IsLock(siMain.SheetName) == true) ▸ if (_UpAct_Cell != _PressAct_Cell) ▸ if (siMain.Sheet().Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1f009076 | this.spdMain.KeyUp | FP01990_Lookup.cs:1492 | if (siMain.IsLock(siMain.SheetName) == true) ▸ if (_UpAct_Cell != _PressAct_Cell) ▸ if (e.KeyData != Keys.Left && e.KeyData != Keys.Right) | FLAG | _PressAct_Cell | _UpAct_Cell | 화면 필드/플래그 변경 |  |  |  |
| AC-9b19cc7a | this.spdMain.KeyUp | FP01990_Lookup.cs:1493 | if (siMain.IsLock(siMain.SheetName) == true) ▸ if (_UpAct_Cell != _PressAct_Cell) ▸ if (e.KeyData != Keys.Left && e.KeyData != Keys.Right) | FLAG | _UpAct_Cell | this.spdMain.ActiveSheet.ActiveCell.Row.Index2.ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-cd3c7024 | this.spdMain.KeyUp | FP01990_Lookup.cs:1497 | if (siMain.IsLock(siMain.SheetName) == true) ▸ if (_UpAct_Cell != _PressAct_Cell) | FLAG | mainLookupType | siMain.GetValue(this.spdMain.ActiveSheet.ActiveCell.Row.Index2, siMain.GetColumnIndex(DefC… | 화면 필드/플래그 변경 |  |  |  |
| AC-357ad378 | this.spdMain.KeyUp | FP01990_Lookup.cs:1498 | if (siMain.IsLock(siMain.SheetName) == true) ▸ if (_UpAct_Cell != _PressAct_Cell) | DATA_OP | Filter["ACTIVE_FLAG"] | siMain.GetValue(this.spdMain.ActiveSheet.ActiveCell.Row.Index2, siMain.GetColumnIndex(DefC… | 행/컬럼 값 대입 |  |  |  |
| AC-8af5c5a4 | this.spdMain.KeyUp | FP01990_Lookup.cs:1500 | if (siMain.IsLock(siMain.SheetName) == true) ▸ if (_UpAct_Cell != _PressAct_Cell) | STATE_RESET | dtColumInfo.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-ada09d9f | this.spdMain.KeyUp | FP01990_Lookup.cs:1508 | if (siMain.IsLock(siMain.SheetName) == true) | UI_PROP | this.ActiveControl | spdMain | 속성 ActiveControl 설정 |  |  |  |
| AC-16815d82 | this.spdMain.KeyUp | FP01990_Lookup.cs:1513 | else of (siMain.IsLock(siMain.SheetName) == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP01990_Lookup.UIFindData

진입점: FindButton / SaveButton [if (fps.Name == "spdMain")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ae95445a | FindButton 외 1 | FP01990_Lookup.cs:365 | try ▸ if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a0fc4f0f | FindButton 외 1 | FP01990_Lookup.cs:366 | try ▸ if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-67d2d790 | FindButton 외 1 | FP01990_Lookup.cs:369 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-9145da1a | FindButton 외 1 | FP01990_Lookup.cs:371 | try | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-d59ce53a | FindButton 외 1 | FP01990_Lookup.cs:375 | try | FLAG | dsMain | null | 화면 필드/플래그 변경 |  |  |  |
| AC-efa18343 | FindButton 외 1 | FP01990_Lookup.cs:378 | try | STATE | usrTextBox_Att.ReadOnly | true | 컨트롤 상태 ReadOnly |  |  |  |
| AC-b87c8f02 | FindButton 외 1 | FP01990_Lookup.cs:379 | try | VALUE_CLEAR | usrTextBox_Att.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-1f1ddc08 | FindButton 외 1 | FP01990_Lookup.cs:380 | try | STATE | simpleButton1.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-7ed73b1d | FindButton 외 1 | FP01990_Lookup.cs:390 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-f517edc9 | FindButton 외 1 | FP01990_Lookup.cs:392 | try | FLAG | dsMain | await asyncProxy.ExecuteAsync<DataSet>(() => Find_Data_Amend("SELECT") ) | 화면 필드/플래그 변경 |  |  |  |
| AC-76a015b5 | FindButton 외 1 | FP01990_Lookup.cs:392 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => Find_Data_Amend("SELECT") ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-8a962a9d | FindButton 외 1 | FP01990_Lookup.cs:407 | try ▸ if (dsMain != null) ▸ if (dsMain.Tables[0].Rows.Count > 0) | STATE | usrTextBox_Att.ReadOnly | false | 컨트롤 상태 ReadOnly |  |  |  |
| AC-ce623c1f | FindButton 외 1 | FP01990_Lookup.cs:408 | try ▸ if (dsMain != null) ▸ if (dsMain.Tables[0].Rows.Count > 0) | STATE | simpleButton1.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-636dfade | FindButton 외 1 | FP01990_Lookup.cs:412 | try ▸ if (dsMain != null) ▸ else of (dsMain.Tables[0].Rows.Count > 0) | GRID_BIND | siMain.Query | (dsMain, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-d4fb3771 | FindButton 외 1 | FP01990_Lookup.cs:413 | try ▸ if (dsMain != null) ▸ else of (dsMain.Tables[0].Rows.Count > 0) | UI_MISC | SetSearchCount | (dsMain) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-b5ad9ca3 | FindButton 외 1 | FP01990_Lookup.cs:414 | try ▸ if (dsMain != null) ▸ else of (dsMain.Tables[0].Rows.Count > 0) | GRID_SET | siMain.ActiveSheet.RowCount | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-a087e4d6 | FindButton 외 1 | FP01990_Lookup.cs:416 | try ▸ if (dsMain != null) ▸ else of (dsMain.Tables[0].Rows.Count > 0) | STATE | usrTextBox_Att.ReadOnly | true | 컨트롤 상태 ReadOnly |  |  |  |
| AC-36bceb79 | FindButton 외 1 | FP01990_Lookup.cs:417 | try ▸ if (dsMain != null) ▸ else of (dsMain.Tables[0].Rows.Count > 0) | VALUE_CLEAR | usrTextBox_Att.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-f12dd89e | FindButton 외 1 | FP01990_Lookup.cs:418 | try ▸ if (dsMain != null) ▸ else of (dsMain.Tables[0].Rows.Count > 0) | STATE | simpleButton1.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-c8fa4ef7 | FindButton 외 1 | FP01990_Lookup.cs:423 | try ▸ else of (dsMain != null) | GRID_SET | siMain.ActiveSheet.RowCount | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-b9abd711 | FindButton 외 1 | FP01990_Lookup.cs:424 | try ▸ else of (dsMain != null) | MESSAGE | MessageBox.Show | ("Query Statement is Occure Error!", "Error", MessageBoxButtons.OK, MessageBoxIcon.Informa… | 메시지 표시 |  |  |  |
| AC-09bed72f | FindButton 외 1 | FP01990_Lookup.cs:444 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-975d1496 | FindButton 외 1 | FP01990_Lookup.cs:449 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-794f17d4 | FindButton 외 1 | FP01990_Lookup.cs:450 | finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-f63fb185 | FindButton 외 1 | FP01990_Lookup.cs:451 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-e3abba11 | FindButton 외 1 | FP01990_Lookup.cs:456 | if (siMain.ActiveSheet.RowCount > 0) | FLAG | mainLookupType | siMain.GetValue(0, siMain.GetColumnIndex(DefColumns.LOOKUP_TYPE_CODE)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-31fab1bc | FindButton 외 1 | FP01990_Lookup.cs:458 | if (siMain.ActiveSheet.RowCount > 0) | STATE_RESET | dtColumInfo.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-e3d27cd8 | FindButton 외 1 | FP01990_Lookup.cs:461 | if (siMain.ActiveSheet.RowCount > 0) | DATA_OP | Filter["ACTIVE_FLAG"] | siMain.GetValue(0, siMain.GetColumnIndex(DefColumns.ACTIVE)).ToString() | 행/컬럼 값 대입 |  |  |  |

## FP01990_Lookup.usrTextBox_Att_KeyUp

진입점: this.usrTextBox_Att.KeyUp

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-77f357bb | this.usrTextBox_Att.KeyUp | FP01990_Lookup.cs:1540 | if (!siMain.IsLock(siMain.SheetName) \|\| !siSub.IsLock(siSub.SheetName)) | MESSAGE | MessageBox.Show | ("Can't search in Edit-Mode") | 메시지 표시 |  |  |  |
| AC-f283e1c1 | this.usrTextBox_Att.KeyUp | FP01990_Lookup.cs:1541 | if (!siMain.IsLock(siMain.SheetName) \|\| !siSub.IsLock(siSub.SheetName)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

