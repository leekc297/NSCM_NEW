# AS-IS 액션 대조표 — FP06970

> 원천: `Doc/asisfacts/screens/FP06970/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 441행 · 메서드 33 · 종류 DATA_OP 128 · GRID_INIT 67 · RETURN 41 · FLAG 34 · UI_PROP 25 · CALL_EXT 24 · ENDPOINT 23 · UI_MISC 19 · MESSAGE 18 · STATE 11 · GRID_LOCK 10 · STATE_RESET 7 · VALUE_SET 7 · VALUE_CLEAR 4 · POPUP 4 · GRID_BIND 4 · GRID_SET 4 · GRID_STYLE 4 · LIST_REBIND 2 · VALIDATE 2 · THROW 1 · CALL_BASE 1 · LIST_CLEAR 1 · ⚠ 의미 확인 필요 25


## FP06970_Code_Lookup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7523855d | .ctor | FP06970_Code_Lookup.cs:144 |  | FLAG | _CurrentUser | UserInfoContext.Current.UserId | 화면 필드/플래그 변경 |  |  |  |

## FP06970_Code_Lookup.ActiveSheet_CellChanged

진입점: this.spdMain.ActiveSheet.CellChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4a584e61 | this.spdMain.ActiveSheet.CellChanged | FP06970_Code_Lookup.cs:1698 | if (siMain.IsLock(siMain.SheetName) == true) ▸ if (siMain.Sheet().Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1c715e54 | this.spdMain.ActiveSheet.CellChanged | FP06970_Code_Lookup.cs:1706 | if (siMain.IsLock(siMain.SheetName) == true) ▸ if (cbGenTmplate.Checked== true) | VALUE_CLEAR | txtGuide.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-1d6c3141 | this.spdMain.ActiveSheet.CellChanged | FP06970_Code_Lookup.cs:1709 | if (siMain.IsLock(siMain.SheetName) == true) | FLAG | mainLookupType | siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.LOOKUP_TYPE_CODE)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-28881285 | this.spdMain.ActiveSheet.CellChanged | FP06970_Code_Lookup.cs:1710 | if (siMain.IsLock(siMain.SheetName) == true) | DATA_OP | Filter["ACTIVE_FLAG"] | siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.ACTIVE)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-7381683d | this.spdMain.ActiveSheet.CellChanged | FP06970_Code_Lookup.cs:1712 | if (siMain.IsLock(siMain.SheetName) == true) | STATE_RESET | dtColumInfo.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |

## FP06970_Code_Lookup.btnSql_Click

진입점: this.btnSql.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f7c97217 | this.btnSql.Click | FP06970_Code_Lookup.cs:1914 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-de48392a | this.btnSql.Click | FP06970_Code_Lookup.cs:1917 |  | POPUP | new FPC0099_SqlPopup | () | 팝업/폼 생성 |  |  |  |
| AC-3aadf5ff | this.btnSql.Click | FP06970_Code_Lookup.cs:1918 |  | UI_PROP | popSql.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-fa7aa826 | this.btnSql.Click | FP06970_Code_Lookup.cs:1920 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP06970_GET_LOOKUP_FP") | 데이터 객체 조작/조회 |  |  |  |
| AC-83483603 | this.btnSql.Click | FP06970_Code_Lookup.cs:1922 |  | POPUP | popSql.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP06970_Code_Lookup.CheckValidation

진입점: SaveButton [if (fps.Name == "spdMain") ▸ if (siMain.SpreadObject.DataSource != null)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1678cd1c | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain.SpreadOb… | FP06970_Code_Lookup.cs:1884 | try ▸ for (i < dt.Rows.Count) ▸ for (j < dt.Rows.Count) ▸ if (sLookupType == schkLookupType && sSegment1 == schkSegment1 && sSegment2 == sch… | MESSAGE | MessageHelper.GMessageBox | ("MSG00060", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8dd536e3 | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain.SpreadOb… | FP06970_Code_Lookup.cs:1885 | try ▸ for (i < dt.Rows.Count) ▸ for (j < dt.Rows.Count) ▸ if (sLookupType == schkLookupType && sSegment1 == schkSegment1 && sSegment2 == sch… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-8e249106 | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain.SpreadOb… | FP06970_Code_Lookup.cs:1892 | catch ((Exception ex)) | RETURN | return bCheck; |  | 처리 중단/반환 |  |  |  |
| AC-16a4866f | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain.SpreadOb… | FP06970_Code_Lookup.cs:1894 |  | RETURN | return bCheck; |  | 처리 중단/반환 |  |  |  |

## FP06970_Code_Lookup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3f019295 | this.Load | FP06970_Code_Lookup.cs:296 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-7e60fe24 | this.Load | FP06970_Code_Lookup.cs:297 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-e423ebbc | this.Load | FP06970_Code_Lookup.cs:299 |  | GRID_INIT | this.AddSheet | (spdSub, SpdSheet.shtSub, SpdSheet.shtSub, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-8b9430ff | this.Load | FP06970_Code_Lookup.cs:300 |  | FLAG | siSub | GetSheetInfo(spdSub.Name, spdSub.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-df2f07d8 | this.Load | FP06970_Code_Lookup.cs:302 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP06970_Code_Lookup.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-22fbe4ef | DeleteButton | FP06970_Code_Lookup.cs:556 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0062988d | DeleteButton | FP06970_Code_Lookup.cs:559 | if (fps.Name == "spdMain") | DATA_OP | siMain.Delete | () | 데이터 객체 조작/조회 |  |  |  |
| AC-2c8671f2 | DeleteButton | FP06970_Code_Lookup.cs:561 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") | DATA_OP | siSub.Delete | () | 데이터 객체 조작/조회 |  |  |  |

## FP06970_Code_Lookup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-98120f53 | Dispose | FP06970_Code_Lookup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP06970_Code_Lookup.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-21d2a5e7 | EditButton | FP06970_Code_Lookup.cs:570 | if (fps != null) ▸ if (fps.Name == "spdMain") | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-b079713d | EditButton | FP06970_Code_Lookup.cs:571 | if (fps != null) ▸ if (fps.Name == "spdMain") | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-e62edb2d | EditButton | FP06970_Code_Lookup.cs:573 | if (fps != null) ▸ if (fps.Name == "spdMain") | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-5ee73555 | EditButton | FP06970_Code_Lookup.cs:578 | if (fps != null) ▸ if (fps.Name == "spdSub") | FLAG | siSub | GetSheetInfo(spdSub.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-042889cf | EditButton | FP06970_Code_Lookup.cs:579 | if (fps != null) ▸ if (fps.Name == "spdSub") | GRID_LOCK | siSub.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-401a1bda | EditButton | FP06970_Code_Lookup.cs:583 | if (fps != null) ▸ if (fps.Name == "spdSub") | GRID_LOCK | siSub.LockColumn | (siSub.GetColumnIndex(DefColumns.MODIFY_DATE), siSub.GetColumnIndex(DefColumns.modify_user… | 그리드 편집 잠금/해제 |  |  |  |
| AC-5c67103e | EditButton | FP06970_Code_Lookup.cs:584 | if (fps != null) ▸ if (fps.Name == "spdSub") | GRID_LOCK | siSub.LockColumn | (siSub.GetColumnIndex(DefColumns.LOOKUP_TYPE_CODE), siSub.GetColumnIndex(DefColumns.LOOKUP… | 그리드 편집 잠금/해제 |  |  |  |

## FP06970_Code_Lookup.EssentialCheck

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-806b2456 | (진입점 미연결) | FP06970_Code_Lookup.cs:1813 | try ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ for (iCol <= siMain.GetMaxColumnIndex()) | CALL_EXT | siMain.GetColumnText | (0, iCol) | ⚠ 의미 확인 필요 |  |  |  |
| AC-99eee1cf | (진입점 미연결) | FP06970_Code_Lookup.cs:1821 | try ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (string.IsNullOrWhiteSpace(str)) | CALL_EXT | siMain.GetColumnText | (0, iCol) | ⚠ 의미 확인 필요 |  |  |  |
| AC-70885b8c | (진입점 미연결) | FP06970_Code_Lookup.cs:1825 | try ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (string.IsNullOrWhiteSpace(str)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6a59019c | (진입점 미연결) | FP06970_Code_Lookup.cs:1826 | try ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (string.IsNullOrWhiteSpace(str)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-c855ec5b | (진입점 미연결) | FP06970_Code_Lookup.cs:1833 | catch ((Exception ex)) | RETURN | return bFlag; |  | 처리 중단/반환 |  |  |  |
| AC-168d008f | (진입점 미연결) | FP06970_Code_Lookup.cs:1835 |  | RETURN | return bFlag; |  | 처리 중단/반환 |  |  |  |

## FP06970_Code_Lookup.ExcelButton

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c2502cc0 | ExcelButton | FP06970_Code_Lookup.cs:597 |  | POPUP | new FPC0109_ExcelSelect_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-4e0ea935 | ExcelButton | FP06970_Code_Lookup.cs:598 |  | VALUE_SET | select_popup.Text | "SELECT Excel Export Option" | 컨트롤 값 설정 |  |  |  |
| AC-c2b2e939 | ExcelButton | FP06970_Code_Lookup.cs:600 |  | POPUP | select_popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-f36b8924 | ExcelButton | FP06970_Code_Lookup.cs:604 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.Merge | select_popup.MergeSelection | 속성 Merge 설정 |  |  |  |
| AC-ff6f84bc | ExcelButton | FP06970_Code_Lookup.cs:605 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.Border | select_popup.LineSelection | 속성 Border 설정 |  |  |  |
| AC-b535cea2 | ExcelButton | FP06970_Code_Lookup.cs:606 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.AmendZeroOption | select_popup.ZeroSelection | 속성 AmendZeroOption 설정 |  |  |  |
| AC-f567084b | ExcelButton | FP06970_Code_Lookup.cs:609 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.AheadZeroOption | ZeroOption.HideZero | 속성 AheadZeroOption 설정 |  |  |  |
| AC-43a1b0a3 | ExcelButton | FP06970_Code_Lookup.cs:610 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.AmendNullToZero | true | 속성 AmendNullToZero 설정 |  |  |  |
| AC-a5e328cf | ExcelButton | FP06970_Code_Lookup.cs:611 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.AheadNullToZero | false | 속성 AheadNullToZero 설정 |  |  |  |
| AC-9be29fc1 | ExcelButton | FP06970_Code_Lookup.cs:613 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.UserName | UserInfo.UserId | 속성 UserName 설정 |  |  |  |
| AC-16f1f249 | ExcelButton | FP06970_Code_Lookup.cs:614 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.FileName | sFileName | 속성 FileName 설정 |  |  |  |
| AC-e16ef2da | ExcelButton | FP06970_Code_Lookup.cs:621 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ try | CALL_EXT | SimplexelService.ExportFpSpread | (fps, exportOption) | ⚠ 의미 확인 필요 |  |  |  |
| AC-8fc8b3f9 | ExcelButton | FP06970_Code_Lookup.cs:625 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-eef21812 | ExcelButton | FP06970_Code_Lookup.cs:629 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP06970_Code_Lookup.Find_Data_Amend

진입점: popSql.OnSql [if (fps.Name == "spdMain")] / FindButton [try ▸ lambda] / SaveButton [if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ if (dsDelete.Good()) ▸ try ▸ lambda]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b5f46240 | popSql.OnSql [if (fps.Name == "spdMain")] 외 2 | FP06970_Code_Lookup.cs:1512 | try | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { Filter["P_SEGMENT1"] = ""; Filter["P_SEGMENT2"] = ""; Fil… | ⚠ 의미 확인 필요 |  |  |  |
| AC-d435f1ab | popSql.OnSql [if (fps.Name == "spdMain")] 외 2 | FP06970_Code_Lookup.cs:1514 | try ▸ lambda | DATA_OP | Filter["P_SEGMENT1"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-6ea5552e | popSql.OnSql [if (fps.Name == "spdMain")] 외 2 | FP06970_Code_Lookup.cs:1515 | try ▸ lambda | DATA_OP | Filter["P_SEGMENT2"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-325f8652 | popSql.OnSql [if (fps.Name == "spdMain")] 외 2 | FP06970_Code_Lookup.cs:1516 | try ▸ lambda | DATA_OP | Filter["P_SEGMENT3"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-9ffbda9d | popSql.OnSql [if (fps.Name == "spdMain")] 외 2 | FP06970_Code_Lookup.cs:1517 | try ▸ lambda | DATA_OP | Filter["P_SEGMENT4"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-9aa3416e | popSql.OnSql [if (fps.Name == "spdMain")] 외 2 | FP06970_Code_Lookup.cs:1518 | try ▸ lambda | DATA_OP | Filter["P_SEGMENT5"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-48d4e6de | popSql.OnSql [if (fps.Name == "spdMain")] 외 2 | FP06970_Code_Lookup.cs:1519 | try ▸ lambda | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-2f89adfe | popSql.OnSql [if (fps.Name == "spdMain")] 외 2 | FP06970_Code_Lookup.cs:1520 | try ▸ lambda | DATA_OP | Filter["P_LOOKUP_TYPE_CODE"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-f661e21a | popSql.OnSql [if (fps.Name == "spdMain")] 외 2 | FP06970_Code_Lookup.cs:1522 | try ▸ lambda | DATA_OP | Filter[segment_ID] | usrTextBox_Seg.Text.ToUpper() | 행/컬럼 값 대입 |  |  |  |
| AC-cad36217 | popSql.OnSql [if (fps.Name == "spdMain")] 외 2 | FP06970_Code_Lookup.cs:1524 | try ▸ lambda | DATA_OP | Filter["P_LOOKUP_TYPE_CODE"] | txtLookupType.Text.ToUpper() | 행/컬럼 값 대입 |  |  |  |
| AC-f01b2c24 | popSql.OnSql [if (fps.Name == "spdMain")] 외 2 | FP06970_Code_Lookup.cs:1528 | try ▸ lambda ▸ if (cboValid.Text.ToUpper() != "ALL") | DATA_OP | Filter["V_ACTIVE_FLAG"] | cboValid.Text.ToUpper() | 행/컬럼 값 대입 |  |  |  |
| AC-eba38025 | popSql.OnSql [if (fps.Name == "spdMain")] 외 2 | FP06970_Code_Lookup.cs:1532 | try ▸ lambda ▸ else of (cboValid.Text.ToUpper() != "ALL") | DATA_OP | Filter["V_ACTIVE_FLAG"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-44ce08ee | popSql.OnSql [if (fps.Name == "spdMain")] 외 2 | FP06970_Code_Lookup.cs:1546 | try ▸ switch (conn) case "DevFp": | ENDPOINT | GService.FP_ExecuteQuery | (@"code_lookup", "find_code_lookup", Filter.Dictionary,"admin") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_code_lookup] \| FP\admin\c… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-1f05498a | popSql.OnSql [if (fps.Name == "spdMain")] 외 2 | FP06970_Code_Lookup.cs:1547 | try ▸ switch (conn) case "DevFp": | CALL_EXT | GService.ReadResult | (dsRet) | ⚠ 의미 확인 필요 |  |  |  |
| AC-327a87c5 | popSql.OnSql [if (fps.Name == "spdMain")] 외 2 | FP06970_Code_Lookup.cs:1550 | try ▸ switch (conn) case "DevScp": | ENDPOINT | GService.CommonExecuteQuery | (@"scp\admin\code_lookup", "find_code_lookup", Filter.Dictionary) ⇒ biz:AppService.GeneralExecuteQuery [batchId=find_code_lookup] \| scp\admin\code_… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-f33ce50a | popSql.OnSql [if (fps.Name == "spdMain")] 외 2 | FP06970_Code_Lookup.cs:1553 | try ▸ switch (conn) case "QaFp": | ENDPOINT | GService.QAExecuteQuery | (@"qa\nerp\code_lookup_fp", "find_code_lookup", Filter.Dictionary) ⇒ biz:QACommonDataBLL.GeneralExecuteQuery [batchId=find_code_lookup] \| qa\nerp\co… | 엔드포인트 호출 |  |  |  |
| AC-ea7b570d | popSql.OnSql [if (fps.Name == "spdMain")] 외 2 | FP06970_Code_Lookup.cs:1556 | try ▸ switch (conn) case "QaScp": | ENDPOINT | GService.QAExecuteQuery | (@"qa\nerp\code_lookup", "find_code_lookup", Filter.Dictionary) ⇒ biz:QACommonDataBLL.GeneralExecuteQuery [batchId=find_code_lookup] \| qa\nerp\co… | 엔드포인트 호출 |  |  |  |
| AC-babe2e11 | popSql.OnSql [if (fps.Name == "spdMain")] 외 2 | FP06970_Code_Lookup.cs:1564 | try ▸ if (ret.Success) | CALL_EXT | Filter.clearData | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-294369e0 | popSql.OnSql [if (fps.Name == "spdMain")] 외 2 | FP06970_Code_Lookup.cs:1565 | try ▸ if (ret.Success) | RETURN | return ret.Result; |  | 처리 중단/반환 |  |  |  |
| AC-f67f51b3 | popSql.OnSql [if (fps.Name == "spdMain")] 외 2 | FP06970_Code_Lookup.cs:1569 | try ▸ else of (ret.Success) | CALL_EXT | Filter.clearData | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-c2c87499 | popSql.OnSql [if (fps.Name == "spdMain")] 외 2 | FP06970_Code_Lookup.cs:1570 | try ▸ else of (ret.Success) | RETURN | return ret.Result; |  | 처리 중단/반환 |  |  |  |
| AC-00719937 | popSql.OnSql [if (fps.Name == "spdMain")] 외 2 | FP06970_Code_Lookup.cs:1578 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP06970_Code_Lookup.Find_Data_Save

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-728eb569 | (진입점 미연결) | FP06970_Code_Lookup.cs:1592 | try | ENDPOINT | Data_FP.CallGeneralProcedure | ("PR_UI_FP06970_GET_LOOKUP_FP", SaveFilter, _CurrentUser, pSysType, mFlag) | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-68e77ecb | (진입점 미연결) | FP06970_Code_Lookup.cs:1594 | try | RETURN | return dsResult; |  | 처리 중단/반환 |  |  |  |
| AC-8357bb3c | (진입점 미연결) | FP06970_Code_Lookup.cs:1598 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP06970_Code_Lookup.Find_Data_Save_Sub

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-43d1844d | (진입점 미연결) | FP06970_Code_Lookup.cs:1613 | try | ENDPOINT | Data_FP.CallGeneralProcedure | ("PR_UI_FP06970_GET_LOOKUP_FP", SaveFilter, _CurrentUser, pSysType, mFlag) | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-0c1e4dfc | (진입점 미연결) | FP06970_Code_Lookup.cs:1615 | try | RETURN | return dsResult; |  | 처리 중단/반환 |  |  |  |
| AC-7e78d3a5 | (진입점 미연결) | FP06970_Code_Lookup.cs:1619 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP06970_Code_Lookup.Find_Data_sub

진입점: this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == true) ▸ if (_UpAct_Cell != _PressAct_Cell) ▸ try] / this.spdMain.CellClick [try] / this.spdMain.ActiveSheet.CellChanged [if (siMain.IsLock(siMain.SheetName) == true) ▸ try] / popSql.OnSql [else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub")] / FindButton [if (siMain.ActiveSheet.RowCount > 0) ▸ try] / SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ if (iCount > 0) ▸ if (dsToSave.Good() && dsDelete.Good()) ▸ else of (bGoLookupType) ▸ try] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8a4a66f2 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 6 | FP06970_Code_Lookup.cs:1628 | try | DATA_OP | Filter["P_LOOKUP_TYPE_CODE"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-b7fdf975 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 6 | FP06970_Code_Lookup.cs:1629 | try | DATA_OP | Filter["P_LOOKUP_TYPE_CODE"] | mainLookupType.ToUpper() | 행/컬럼 값 대입 |  |  |  |
| AC-76291bbe | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 6 | FP06970_Code_Lookup.cs:1631 | try | DATA_OP | Filter["P_SEGMENT1"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-8f7f08b5 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 6 | FP06970_Code_Lookup.cs:1632 | try | DATA_OP | Filter["P_SEGMENT2"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-faa6f37b | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 6 | FP06970_Code_Lookup.cs:1633 | try | DATA_OP | Filter["P_SEGMENT3"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-2c77708a | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 6 | FP06970_Code_Lookup.cs:1634 | try | DATA_OP | Filter["P_SEGMENT4"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-ab618879 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 6 | FP06970_Code_Lookup.cs:1635 | try | DATA_OP | Filter["P_SEGMENT5"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-664be9b7 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 6 | FP06970_Code_Lookup.cs:1636 | try | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-a64367c0 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 6 | FP06970_Code_Lookup.cs:1638 | try | DATA_OP | Filter[segment_ID] | usrTextBox_Seg.Text.ToUpper() | 행/컬럼 값 대입 |  |  |  |
| AC-2aa00404 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 6 | FP06970_Code_Lookup.cs:1644 | try ▸ if (cboValid.Text.ToUpper() != "ALL") | DATA_OP | Filter["V_ACTIVE_FLAG"] | cboValid.Text.ToUpper() | 행/컬럼 값 대입 |  |  |  |
| AC-e5ff5847 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 6 | FP06970_Code_Lookup.cs:1648 | try ▸ else of (cboValid.Text.ToUpper() != "ALL") | DATA_OP | Filter["V_ACTIVE_FLAG"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-f801e4e9 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 6 | FP06970_Code_Lookup.cs:1659 | try ▸ switch (conn) case "DevFp": | ENDPOINT | GService.FP_ExecuteQuery | (@"code_lookup", "find_code_lookup_sub", Filter.Dictionary,"admin") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_code_lookup_sub] \| FP\adm… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-0fe0e107 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 6 | FP06970_Code_Lookup.cs:1660 | try ▸ switch (conn) case "DevFp": | CALL_EXT | GService.ReadResult | (dsRet) | ⚠ 의미 확인 필요 |  |  |  |
| AC-2c9639f7 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 6 | FP06970_Code_Lookup.cs:1663 | try ▸ switch (conn) case "DevScp": | ENDPOINT | GService.CommonExecuteQuery | (@"scp\admin\code_lookup", "find_code_lookup_sub", Filter.Dictionary) ⇒ biz:AppService.GeneralExecuteQuery [batchId=find_code_lookup_sub] \| scp\admin\c… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-193f707d | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 6 | FP06970_Code_Lookup.cs:1666 | try ▸ switch (conn) case "QaFp": | ENDPOINT | GService.QAExecuteQuery | (@"qa\nerp\code_lookup_fp", "find_code_lookup_sub", Filter.Dictionary) ⇒ biz:QACommonDataBLL.GeneralExecuteQuery [batchId=find_code_lookup_sub] \| qa\ner… | 엔드포인트 호출 |  |  |  |
| AC-000dc129 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 6 | FP06970_Code_Lookup.cs:1669 | try ▸ switch (conn) case "QaScp": | ENDPOINT | GService.QAExecuteQuery | (@"qa\nerp\code_lookup", "find_code_lookup_sub", Filter.Dictionary) ⇒ biz:QACommonDataBLL.GeneralExecuteQuery [batchId=find_code_lookup_sub] \| qa\ner… | 엔드포인트 호출 |  |  |  |
| AC-cfb9b46d | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 6 | FP06970_Code_Lookup.cs:1676 | try ▸ if (ret.Success) | CALL_EXT | Filter.clearData | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-358ad97c | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 6 | FP06970_Code_Lookup.cs:1677 | try ▸ if (ret.Success) | RETURN | return ret.Result; |  | 처리 중단/반환 |  |  |  |
| AC-4db8a183 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 6 | FP06970_Code_Lookup.cs:1681 | try ▸ else of (ret.Success) | CALL_EXT | Filter.clearData | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-17fdbc93 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 6 | FP06970_Code_Lookup.cs:1682 | try ▸ else of (ret.Success) | RETURN | return ret.Result; |  | 처리 중단/반환 |  |  |  |
| AC-67de0dce | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 6 | FP06970_Code_Lookup.cs:1687 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP06970_Code_Lookup.FindData_Sub

진입점: this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == true) ▸ if (_UpAct_Cell != _PressAct_Cell)] / this.spdMain.CellClick / this.spdMain.ActiveSheet.CellChanged [if (siMain.IsLock(siMain.SheetName) == true)] / FindButton [if (siMain.ActiveSheet.RowCount > 0)] / SaveButton [if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ if (dsDelete.Good()) ▸ if (siMain.ActiveSheet.RowCount > 0)] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4c5ec468 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP06970_Code_Lookup.cs:682 | try | VALUE_CLEAR | usrTextBox_Att.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-7a8defcc | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP06970_Code_Lookup.cs:686 | try ▸ if (string.IsNullOrWhiteSpace(mainLookupType)) | FLAG | mainLookupType | siMain.GetValue(0, siMain.GetColumnIndex(DefColumns.LOOKUP_TYPE_CODE)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-b46d10a7 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP06970_Code_Lookup.cs:688 | try | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-94ce0db0 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP06970_Code_Lookup.cs:702 | try | FLAG | dsMain_sub | Find_Data_sub("SELECT") | 화면 필드/플래그 변경 |  |  |  |
| AC-a0aa577d | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP06970_Code_Lookup.cs:706 | try | FLAG | siSub | GetSheetInfo(spdSub.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-1ef9da4a | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP06970_Code_Lookup.cs:715 | try ▸ if (dr != null) ▸ for (iCol < siSub.ActiveSheet.Columns.Count) | DATA_OP | dtColumInfo.Columns.Contains | (sColName) | 데이터 객체 조작/조회 |  |  |  |
| AC-6ad4310e | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP06970_Code_Lookup.cs:723 | try ▸ if (dr != null) ▸ for (iCol < siSub.ActiveSheet.Columns.Count) ▸ if (sValue == "-" \|\| sValue == "*" \|\| string.IsNullOrWhiteSpace(s… | STATE | col.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-4efbec4c | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP06970_Code_Lookup.cs:729 | try ▸ if (dr != null) ▸ for (iCol < siSub.ActiveSheet.Columns.Count) ▸ else of (sValue == "-" \|\| sValue == "*" \|\| string.IsNullOrWhiteSp… | UI_PROP | col.Label | sValue | 속성 Label 설정 |  |  |  |
| AC-1b5f261f | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP06970_Code_Lookup.cs:734 | try | GRID_BIND | siSub.Query | (dsMain_sub,true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-366067e9 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP06970_Code_Lookup.cs:735 | try | GRID_LOCK | siSub.LockColumn | (0, siSub.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-9d651e39 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP06970_Code_Lookup.cs:739 | try | CALL_EXT | col_head.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-aa9b8ec6 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP06970_Code_Lookup.cs:740 | try | CALL_EXT | col_head_idx.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-b10140cc | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP06970_Code_Lookup.cs:744 | try | LIST_CLEAR | SubComboBox_param.Items.Clear | () | 목록 항목 비움 |  |  |  |
| AC-499a0bf5 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP06970_Code_Lookup.cs:754 | try ▸ for (i < siSub.ActiveSheet.ColumnCount) ▸ if (siSub.ActiveSheet.Columns[i].Visible) ▸ if (siSub.ActiveSheet.Columns[i].Label != "Last … | DATA_OP | col_head.Add | (siSub.ActiveSheet.Columns[i].Label) | 데이터 객체 조작/조회 |  |  |  |
| AC-73459a55 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP06970_Code_Lookup.cs:755 | try ▸ for (i < siSub.ActiveSheet.ColumnCount) ▸ if (siSub.ActiveSheet.Columns[i].Visible) ▸ if (siSub.ActiveSheet.Columns[i].Label != "Last … | DATA_OP | col_head_idx.Add | (SP_DataSource.Tables[0].Columns[siSub.ActiveSheet.Columns[i].Tag.ToString()].Ordinal) | 데이터 객체 조작/조회 |  |  |  |
| AC-19d3a897 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP06970_Code_Lookup.cs:768 | try ▸ for (i < col_head.Count) | DATA_OP | SubComboBox_param.Items.Add | (col_head[i]) | 데이터 객체 조작/조회 |  |  |  |
| AC-108891df | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP06970_Code_Lookup.cs:770 | try | VALUE_SET | SubComboBox_param.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-a30e15a4 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP06970_Code_Lookup.cs:785 | try | UI_PROP | objCellType.MaxLength | 32767 | 속성 MaxLength 설정 |  |  |  |
| AC-044bfd76 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP06970_Code_Lookup.cs:787 | try | UI_MISC | siSub.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-0d78b5a1 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP06970_Code_Lookup.cs:790 | try ▸ if (nRowCnt >= 0) | GRID_SET | siSub.ActiveSheet.Cells[0, nStartCol, nRowCnt, nEndCol].CellType | objCellType | 그리드 속성/값 설정 |  |  |  |
| AC-3130e911 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP06970_Code_Lookup.cs:792 | try | UI_MISC | siSub.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-a4b0f292 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP06970_Code_Lookup.cs:797 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8a944f32 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP06970_Code_Lookup.cs:802 | finally | UI_MISC | siSub.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-e2791676 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP06970_Code_Lookup.cs:803 | finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP06970_Code_Lookup.FindData_Sub_Conditon

진입점: this.usrTextBox_Att.KeyUp [if (e.KeyCode == Keys.Enter)] / this.simpleButton1.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6cb7830e | this.usrTextBox_Att.KeyUp [if (e.KeyCode == Keys.Enter)] 외 1 | FP06970_Code_Lookup.cs:814 | try ▸ if (string.IsNullOrWhiteSpace(mainLookupType)) | FLAG | mainLookupType | siMain.GetValue(0, siMain.GetColumnIndex(DefColumns.LOOKUP_TYPE_CODE)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-e73af3ac | this.usrTextBox_Att.KeyUp [if (e.KeyCode == Keys.Enter)] 외 1 | FP06970_Code_Lookup.cs:816 | try | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-30671b21 | this.usrTextBox_Att.KeyUp [if (e.KeyCode == Keys.Enter)] 외 1 | FP06970_Code_Lookup.cs:830 | try | FLAG | dsMain | dsMain_sub | 화면 필드/플래그 변경 |  |  |  |
| AC-2863080c | this.usrTextBox_Att.KeyUp [if (e.KeyCode == Keys.Enter)] 외 1 | FP06970_Code_Lookup.cs:832 | try | FLAG | siSub | GetSheetInfo(spdSub.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-9122b40b | this.usrTextBox_Att.KeyUp [if (e.KeyCode == Keys.Enter)] 외 1 | FP06970_Code_Lookup.cs:841 | try ▸ if (dr != null) ▸ for (iCol < siSub.ActiveSheet.Columns.Count) | DATA_OP | dtColumInfo.Columns.Contains | (sColName) | 데이터 객체 조작/조회 |  |  |  |
| AC-3a499801 | this.usrTextBox_Att.KeyUp [if (e.KeyCode == Keys.Enter)] 외 1 | FP06970_Code_Lookup.cs:849 | try ▸ if (dr != null) ▸ for (iCol < siSub.ActiveSheet.Columns.Count) ▸ if (sValue == "-" \|\| sValue == "*" \|\| string.IsNullOrWhiteSpace(s… | STATE | col.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-0d14a9c0 | this.usrTextBox_Att.KeyUp [if (e.KeyCode == Keys.Enter)] 외 1 | FP06970_Code_Lookup.cs:855 | try ▸ if (dr != null) ▸ for (iCol < siSub.ActiveSheet.Columns.Count) ▸ else of (sValue == "-" \|\| sValue == "*" \|\| string.IsNullOrWhiteSp… | UI_PROP | col.Label | sValue | 속성 Label 설정 |  |  |  |
| AC-ac23a038 | this.usrTextBox_Att.KeyUp [if (e.KeyCode == Keys.Enter)] 외 1 | FP06970_Code_Lookup.cs:870 | try ▸ if (usrTextBox_Att.Text.Length > 0) | DATA_OP | dsMain.Tables[0].Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-280a0132 | this.usrTextBox_Att.KeyUp [if (e.KeyCode == Keys.Enter)] 외 1 | FP06970_Code_Lookup.cs:871 | try ▸ if (usrTextBox_Att.Text.Length > 0) ▸ lambda | DATA_OP | s[columIdx].ToString().Contains | (con_param) | 데이터 객체 조작/조회 |  |  |  |
| AC-aa943b90 | this.usrTextBox_Att.KeyUp [if (e.KeyCode == Keys.Enter)] 외 1 | FP06970_Code_Lookup.cs:873 | try ▸ if (usrTextBox_Att.Text.Length > 0) ▸ if (dsMain.Tables[0].Select().Where(s => s[columIdx].ToString().Contains(con_param)).Count() > 0… | DATA_OP | dsMain.Tables[0].Select().Where(s => s[columIdx].ToString().Contains(con_param)).CopyToDat… | () | 데이터 객체 조작/조회 |  |  |  |
| AC-44eb37e0 | this.usrTextBox_Att.KeyUp [if (e.KeyCode == Keys.Enter)] 외 1 | FP06970_Code_Lookup.cs:873 | try ▸ if (usrTextBox_Att.Text.Length > 0) ▸ if (dsMain.Tables[0].Select().Where(s => s[columIdx].ToString().Contains(con_param)).Count() > 0… | DATA_OP | dsMain.Tables[0].Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-ab91320f | this.usrTextBox_Att.KeyUp [if (e.KeyCode == Keys.Enter)] 외 1 | FP06970_Code_Lookup.cs:874 | try ▸ if (usrTextBox_Att.Text.Length > 0) ▸ if (dsMain.Tables[0].Select().Where(s => s[columIdx].ToString().Contains(con_param)).Count() > 0… | DATA_OP | s[columIdx].ToString().Contains | (con_param) | 데이터 객체 조작/조회 |  |  |  |
| AC-7f6b059d | this.usrTextBox_Att.KeyUp [if (e.KeyCode == Keys.Enter)] 외 1 | FP06970_Code_Lookup.cs:876 | try ▸ if (usrTextBox_Att.Text.Length > 0) ▸ if (dsMain.Tables[0].Select().Where(s => s[columIdx].ToString().Contains(con_param)).Count() > 0… | STATE_RESET | dsMain.Tables.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-8ee05562 | this.usrTextBox_Att.KeyUp [if (e.KeyCode == Keys.Enter)] 외 1 | FP06970_Code_Lookup.cs:878 | try ▸ if (usrTextBox_Att.Text.Length > 0) ▸ if (dsMain.Tables[0].Select().Where(s => s[columIdx].ToString().Contains(con_param)).Count() > 0… | DATA_OP | dsMain.Tables.Add | (dtSeg) | 데이터 객체 조작/조회 |  |  |  |
| AC-d47fd583 | this.usrTextBox_Att.KeyUp [if (e.KeyCode == Keys.Enter)] 외 1 | FP06970_Code_Lookup.cs:882 | try ▸ if (usrTextBox_Att.Text.Length > 0) ▸ else of (dsMain.Tables[0].Select().Where(s => s[columIdx].ToString().Contains(con_param)).Count(… | DATA_OP | dsMain.Tables[0].Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-f3b7c570 | this.usrTextBox_Att.KeyUp [if (e.KeyCode == Keys.Enter)] 외 1 | FP06970_Code_Lookup.cs:883 | try ▸ if (usrTextBox_Att.Text.Length > 0) ▸ else of (dsMain.Tables[0].Select().Where(s => s[columIdx].ToString().Contains(con_param)).Count(… | STATE_RESET | dsMain.Tables.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-51b72b1f | this.usrTextBox_Att.KeyUp [if (e.KeyCode == Keys.Enter)] 외 1 | FP06970_Code_Lookup.cs:884 | try ▸ if (usrTextBox_Att.Text.Length > 0) ▸ else of (dsMain.Tables[0].Select().Where(s => s[columIdx].ToString().Contains(con_param)).Count(… | DATA_OP | dsMain.Tables.Add | (dtTMP) | 데이터 객체 조작/조회 |  |  |  |
| AC-88d877ad | this.usrTextBox_Att.KeyUp [if (e.KeyCode == Keys.Enter)] 외 1 | FP06970_Code_Lookup.cs:888 | try | GRID_BIND | siSub.Query | (dsMain_sub,true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-5e035dfc | this.usrTextBox_Att.KeyUp [if (e.KeyCode == Keys.Enter)] 외 1 | FP06970_Code_Lookup.cs:889 | try | GRID_LOCK | siSub.LockColumn | (0, siSub.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-906d5272 | this.usrTextBox_Att.KeyUp [if (e.KeyCode == Keys.Enter)] 외 1 | FP06970_Code_Lookup.cs:894 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f7b37c56 | this.usrTextBox_Att.KeyUp [if (e.KeyCode == Keys.Enter)] 외 1 | FP06970_Code_Lookup.cs:899 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-6fa51c01 | this.usrTextBox_Att.KeyUp [if (e.KeyCode == Keys.Enter)] 외 1 | FP06970_Code_Lookup.cs:900 | finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP06970_Code_Lookup.FindData_Sub_Save

진입점: SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ if (iCount > 0) ▸ if (dsToSave.Good() && dsDelete.Good()) ▸ else of (bGoLookupType)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d69e5c49 | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FP06970_Code_Lookup.cs:913 | try ▸ if (string.IsNullOrWhiteSpace(mainLookupType)) | FLAG | mainLookupType | siMain.GetValue(0, siMain.GetColumnIndex(DefColumns.LOOKUP_TYPE_CODE)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-3dd878bc | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FP06970_Code_Lookup.cs:915 | try | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-46b3eeab | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FP06970_Code_Lookup.cs:929 | try | FLAG | dsMain_sub | Find_Data_sub("SELECT") | 화면 필드/플래그 변경 |  |  |  |
| AC-1b1dbee5 | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FP06970_Code_Lookup.cs:933 | try | FLAG | siSub | GetSheetInfo(spdSub.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-46e5d382 | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FP06970_Code_Lookup.cs:942 | try ▸ if (dr != null) ▸ for (iCol < siSub.ActiveSheet.Columns.Count) | DATA_OP | dtColumInfo.Columns.Contains | (sColName) | 데이터 객체 조작/조회 |  |  |  |
| AC-45b683fc | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FP06970_Code_Lookup.cs:950 | try ▸ if (dr != null) ▸ for (iCol < siSub.ActiveSheet.Columns.Count) ▸ if (sValue == "-" \|\| sValue == "*" \|\| string.IsNullOrWhiteSpace(s… | STATE | col.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-15f36192 | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FP06970_Code_Lookup.cs:956 | try ▸ if (dr != null) ▸ for (iCol < siSub.ActiveSheet.Columns.Count) ▸ else of (sValue == "-" \|\| sValue == "*" \|\| string.IsNullOrWhiteSp… | UI_PROP | col.Label | sValue | 속성 Label 설정 |  |  |  |
| AC-cb42bbb0 | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FP06970_Code_Lookup.cs:961 | try | GRID_BIND | siSub.Query | (dsMain_sub,true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-ba0614df | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FP06970_Code_Lookup.cs:962 | try | GRID_LOCK | siSub.LockColumn | (0, siSub.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-8f982c7f | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FP06970_Code_Lookup.cs:968 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c6859c3d | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FP06970_Code_Lookup.cs:973 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-5ae5843a | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FP06970_Code_Lookup.cs:974 | finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP06970_Code_Lookup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a3527649 | this.Load | FP06970_Code_Lookup.cs:176 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-45e9a33e | this.Load | FP06970_Code_Lookup.cs:181 |  | VALUE_SET | txtGuide.Text | @" SELECT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID FROM FP_INSTANCE_INFO_V WHERE COMPANY… | 컨트롤 값 설정 |  |  |  |

## FP06970_Code_Lookup.GetFilter

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4398a58f | (진입점 미연결) | FP06970_Code_Lookup.cs:1904 |  | RETURN | return Filter[key]; |  | 처리 중단/반환 |  |  |  |

## FP06970_Code_Lookup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4ab42035 | this.Load | FP06970_Code_Lookup.cs:230 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-70a229ef | this.Load | FP06970_Code_Lookup.cs:236 |  | DATA_OP | usrComboBox_Seg.Items.Add | ("SEGMENT1") | 데이터 객체 조작/조회 |  |  |  |
| AC-1620806f | this.Load | FP06970_Code_Lookup.cs:237 |  | DATA_OP | usrComboBox_Seg.Items.Add | ("SEGMENT2") | 데이터 객체 조작/조회 |  |  |  |
| AC-ef188f42 | this.Load | FP06970_Code_Lookup.cs:238 |  | DATA_OP | usrComboBox_Seg.Items.Add | ("SEGMENT3") | 데이터 객체 조작/조회 |  |  |  |
| AC-2d618f28 | this.Load | FP06970_Code_Lookup.cs:239 |  | DATA_OP | usrComboBox_Seg.Items.Add | ("SEGMENT4") | 데이터 객체 조작/조회 |  |  |  |
| AC-91ebec85 | this.Load | FP06970_Code_Lookup.cs:240 |  | DATA_OP | usrComboBox_Seg.Items.Add | ("SEGMENT5") | 데이터 객체 조작/조회 |  |  |  |
| AC-20f63584 | this.Load | FP06970_Code_Lookup.cs:242 |  | VALUE_SET | usrComboBox_Seg.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-b48b3996 | this.Load | FP06970_Code_Lookup.cs:245 |  | UI_PROP | dtCombo.TableName | "tt" | 속성 TableName 설정 |  |  |  |
| AC-05bda448 | this.Load | FP06970_Code_Lookup.cs:246 |  | DATA_OP | dtCombo.Columns.Add | ("CODE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-ea3581e5 | this.Load | FP06970_Code_Lookup.cs:247 |  | DATA_OP | dtCombo.Columns.Add | ("NAME", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-517e24b9 | this.Load | FP06970_Code_Lookup.cs:249 |  | DATA_OP | dtCombo.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-a94c4f4e | this.Load | FP06970_Code_Lookup.cs:250 |  | DATA_OP | r["CODE"] | ConnectionOption.DevFp.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-a34cdeae | this.Load | FP06970_Code_Lookup.cs:251 |  | DATA_OP | r["NAME"] | "개발서버 FP DB" | 행/컬럼 값 대입 |  |  |  |
| AC-de7cce1e | this.Load | FP06970_Code_Lookup.cs:252 |  | DATA_OP | dtCombo.Rows.Add | (r) | 데이터 객체 조작/조회 |  |  |  |
| AC-67e9dbb8 | this.Load | FP06970_Code_Lookup.cs:255 |  | DATA_OP | dtCombo.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-3aa1949a | this.Load | FP06970_Code_Lookup.cs:256 |  | DATA_OP | r["CODE"] | ConnectionOption.QaFp.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-fb6bb43f | this.Load | FP06970_Code_Lookup.cs:257 |  | DATA_OP | r["NAME"] | "QA서버 FP DB" | 행/컬럼 값 대입 |  |  |  |
| AC-a0c2b1b0 | this.Load | FP06970_Code_Lookup.cs:258 |  | DATA_OP | dtCombo.Rows.Add | (r) | 데이터 객체 조작/조회 |  |  |  |
| AC-1c59b7d4 | this.Load | FP06970_Code_Lookup.cs:261 |  | DATA_OP | dtCombo.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-c72c0387 | this.Load | FP06970_Code_Lookup.cs:262 |  | DATA_OP | r["CODE"] | ConnectionOption.DevScp.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-4935d70c | this.Load | FP06970_Code_Lookup.cs:263 |  | DATA_OP | r["NAME"] | "개발서버 Scp DB" | 행/컬럼 값 대입 |  |  |  |
| AC-35602fd8 | this.Load | FP06970_Code_Lookup.cs:264 |  | DATA_OP | dtCombo.Rows.Add | (r) | 데이터 객체 조작/조회 |  |  |  |
| AC-337295b4 | this.Load | FP06970_Code_Lookup.cs:267 |  | DATA_OP | dtCombo.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-29c246ed | this.Load | FP06970_Code_Lookup.cs:268 |  | DATA_OP | r["CODE"] | ConnectionOption.QaScp.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-a538d6f2 | this.Load | FP06970_Code_Lookup.cs:269 |  | DATA_OP | r["NAME"] | "QA서버 Scp DB" | 행/컬럼 값 대입 |  |  |  |
| AC-013f0c0e | this.Load | FP06970_Code_Lookup.cs:270 |  | DATA_OP | dtCombo.Rows.Add | (r) | 데이터 객체 조작/조회 |  |  |  |
| AC-45bf2129 | this.Load | FP06970_Code_Lookup.cs:272 |  | DATA_OP | dtCombo.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-6e6b3e6d | this.Load | FP06970_Code_Lookup.cs:274 |  | LIST_REBIND | clsCtrl.setListBox | (dtCombo, cboServerDB, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-864f44c0 | this.Load | FP06970_Code_Lookup.cs:275 |  | VALUE_SET | cboServerDB.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-d94a31a4 | this.Load | FP06970_Code_Lookup.cs:277 |  | LIST_REBIND | cboValid.DataBind | (Data.Type.YesOrNo, true) ⇒ biz:CommonData.YesOrNo | 목록 컨트롤 재구성 |  |  |  |
| AC-2c48f8a8 | this.Load | FP06970_Code_Lookup.cs:278 |  | VALUE_SET | cboValid.SelectedValue | "Y" | 컨트롤 값 설정 |  |  |  |
| AC-63851856 | this.Load | FP06970_Code_Lookup.cs:280 |  | FLAG | dtColumInfo | new DataTable() | 화면 필드/플래그 변경 |  |  |  |
| AC-687e82a4 | this.Load | FP06970_Code_Lookup.cs:284 | foreach (string str in sColumnList) | DATA_OP | dtColumInfo.Columns.Add | (str) | 데이터 객체 조작/조회 |  |  |  |
| AC-87cb9a2b | this.Load | FP06970_Code_Lookup.cs:287 |  | FLAG | dtColumInfo_Sub | new DataTable() | 화면 필드/플래그 변경 |  |  |  |
| AC-0ded8df0 | this.Load | FP06970_Code_Lookup.cs:290 | foreach (string str in sColumnList_Sub) | DATA_OP | dtColumInfo_Sub.Columns.Add | (str) | 데이터 객체 조작/조회 |  |  |  |

## FP06970_Code_Lookup.InitSpread

진입점: this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == true) ▸ if (_UpAct_Cell != _PressAct_Cell) ▸ try] / this.usrTextBox_Att.KeyUp [if (e.KeyCode == Keys.Enter) ▸ try] / this.simpleButton1.Click [try] / this.Load / this.spdMain.CellClick [try] / this.spdMain.ActiveSheet.CellChanged [if (siMain.IsLock(siMain.SheetName) == true) ▸ try] / FindButton / SaveButton [if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ if (dsDelete.Good())] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ae05242e | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP06970_Code_Lookup.cs:312 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.InitSheet | (spreadInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-36d114f4 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP06970_Code_Lookup.cs:314 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddActionTextBox | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-2f5ddbba | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP06970_Code_Lookup.cs:316 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Code Type - Procedure*", DefColumns.LOOKUP_TYPE_CODE, FPMerge.None, 160, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-191d2fb3 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP06970_Code_Lookup.cs:317 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Code Value Descriptionn*", DefColumns.LOOKUP_DESCRIPTION, FPMerge.None, 220, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f63bab98 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP06970_Code_Lookup.cs:318 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddComboColumn | ("Active*", DefColumns.ACTIVE, FPMerge.None, 50, true, dtYesOrNo, FPHAlign.Center, FPVAlig… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-641a7d78 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP06970_Code_Lookup.cs:319 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Segment1*", DefColumns.SEGMENT1, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a6822326 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP06970_Code_Lookup.cs:320 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Segment2*", DefColumns.SEGMENT2, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-639522f2 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP06970_Code_Lookup.cs:321 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Segment3*", DefColumns.SEGMENT3, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-29ab18ea | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP06970_Code_Lookup.cs:322 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Segment4*", DefColumns.SEGMENT4, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a48d418b | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP06970_Code_Lookup.cs:323 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Segment5*", DefColumns.SEGMENT5, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2ff64876 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP06970_Code_Lookup.cs:324 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute1", DefColumns.ATTRIBUTE1, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a9427a64 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP06970_Code_Lookup.cs:325 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute2", DefColumns.ATTRIBUTE2, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-edffdc60 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP06970_Code_Lookup.cs:326 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute3", DefColumns.ATTRIBUTE3, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-05a05ad9 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP06970_Code_Lookup.cs:327 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute4", DefColumns.ATTRIBUTE4, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e71e5c40 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP06970_Code_Lookup.cs:328 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute5", DefColumns.ATTRIBUTE5, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-baed42a5 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP06970_Code_Lookup.cs:329 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute6", DefColumns.ATTRIBUTE6, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f196fe67 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP06970_Code_Lookup.cs:330 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute7", DefColumns.ATTRIBUTE7, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-43a18ae4 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP06970_Code_Lookup.cs:331 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute8", DefColumns.ATTRIBUTE8, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b85bab04 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP06970_Code_Lookup.cs:332 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute9", DefColumns.ATTRIBUTE9, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-bb6fab57 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP06970_Code_Lookup.cs:333 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute10", DefColumns.ATTRIBUTE10, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ab34902e | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP06970_Code_Lookup.cs:334 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute11", DefColumns.ATTRIBUTE11, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d26a9fb1 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP06970_Code_Lookup.cs:335 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute12", DefColumns.ATTRIBUTE12, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6c8f40d7 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP06970_Code_Lookup.cs:336 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute13", DefColumns.ATTRIBUTE13, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c1429208 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP06970_Code_Lookup.cs:337 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute14", DefColumns.ATTRIBUTE14, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-fd15db6a | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP06970_Code_Lookup.cs:338 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute15", DefColumns.ATTRIBUTE15, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ee590ece | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP06970_Code_Lookup.cs:341 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddDateTimeColumn | ("Last Update", DefColumns.MODIFY_DATE, FPMerge.None, 160, true, FPHAlign.Center, FPVAlign… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9174ac18 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP06970_Code_Lookup.cs:342 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Update ID", DefColumns.modify_user_id, FPMerge.None, 100, true, FPHAlign.Center, FPVAlig… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7b4f0d1b | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP06970_Code_Lookup.cs:344 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.Freeze | (0, siMain.GetColumnIndex(DefColumns.LOOKUP_DESCRIPTION)) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-8eeea8b0 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP06970_Code_Lookup.cs:346 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-83bd42da | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP06970_Code_Lookup.cs:351 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.InitSheet | (spreadInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-53bd7db9 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP06970_Code_Lookup.cs:353 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddActionTextBox | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-30f562c6 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP06970_Code_Lookup.cs:354 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("lookup type code*", DefColumns.LOOKUP_TYPE_CODE, FPMerge.None, 160, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-560f1810 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP06970_Code_Lookup.cs:355 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Segment1", DefColumns.SEGMENT1, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ffb76f88 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP06970_Code_Lookup.cs:356 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Segment2", DefColumns.SEGMENT2, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-80c51378 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP06970_Code_Lookup.cs:357 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Segment3", DefColumns.SEGMENT3, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a729662e | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP06970_Code_Lookup.cs:358 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Segment4", DefColumns.SEGMENT4, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7508d938 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP06970_Code_Lookup.cs:359 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Segment5", DefColumns.SEGMENT5, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e6bccfbc | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP06970_Code_Lookup.cs:360 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddComboColumn | ("Active", DefColumns.ACTIVE, FPMerge.None, 50, true, dtYesOrNo, FPHAlign.Center, FPVAlign… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ec8b8601 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP06970_Code_Lookup.cs:361 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute1", DefColumns.ATTRIBUTE1, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c9bbbcbf | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP06970_Code_Lookup.cs:362 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute2", DefColumns.ATTRIBUTE2, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f9efa097 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP06970_Code_Lookup.cs:363 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute3", DefColumns.ATTRIBUTE3, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-929c9595 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP06970_Code_Lookup.cs:364 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute4", DefColumns.ATTRIBUTE4, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-eb633141 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP06970_Code_Lookup.cs:365 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute5", DefColumns.ATTRIBUTE5, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c3390d9b | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP06970_Code_Lookup.cs:366 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute6", DefColumns.ATTRIBUTE6, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-66136a46 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP06970_Code_Lookup.cs:367 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute7", DefColumns.ATTRIBUTE7, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d3eb4140 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP06970_Code_Lookup.cs:368 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute8", DefColumns.ATTRIBUTE8, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c76c9b8a | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP06970_Code_Lookup.cs:369 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute9", DefColumns.ATTRIBUTE9, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-460829fd | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP06970_Code_Lookup.cs:370 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute10", DefColumns.ATTRIBUTE10, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-254e4381 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP06970_Code_Lookup.cs:371 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute11", DefColumns.ATTRIBUTE11, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a16f24f4 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP06970_Code_Lookup.cs:372 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute12", DefColumns.ATTRIBUTE12, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a6bee3c9 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP06970_Code_Lookup.cs:373 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute13", DefColumns.ATTRIBUTE13, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c3a12f12 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP06970_Code_Lookup.cs:374 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute14", DefColumns.ATTRIBUTE14, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-39600417 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP06970_Code_Lookup.cs:375 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute15", DefColumns.ATTRIBUTE15, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4bf85450 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP06970_Code_Lookup.cs:376 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Sort Order", DefColumns.SORT_ORDER, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c5595d54 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP06970_Code_Lookup.cs:377 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Value Description", DefColumns.VALUE_DESCRIPTION, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-10255b88 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP06970_Code_Lookup.cs:382 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddDateTimeColumn | ("Last Update Date", DefColumns.MODIFY_DATE, FPMerge.None, 160, true, FPHAlign.Center, FPV… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9b08a349 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP06970_Code_Lookup.cs:383 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Last Updated By", DefColumns.modify_user_id, FPMerge.None, 100, true, FPHAlign.Center, F… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7d07f40b | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP06970_Code_Lookup.cs:386 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Segment1", DefColumns.SEGMENT1_KEY, FPMerge.None, 120, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7bcb1082 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP06970_Code_Lookup.cs:387 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Segment2", DefColumns.SEGMENT2_KEY, FPMerge.None, 120, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-982da7e3 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP06970_Code_Lookup.cs:388 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Segment3", DefColumns.SEGMENT3_KEY, FPMerge.None, 120, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-34f3bcb8 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP06970_Code_Lookup.cs:389 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Segment4", DefColumns.SEGMENT4_KEY, FPMerge.None, 120, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-82142af4 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP06970_Code_Lookup.cs:390 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Segment5", DefColumns.SEGMENT5_KEY, FPMerge.None, 120, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-50b9dd5f | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP06970_Code_Lookup.cs:392 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.Freeze | (0, siMain.GetColumnIndex(DefColumns.LOOKUP_DESCRIPTION)) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-4833e1a3 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 8 | FP06970_Code_Lookup.cs:394 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP06970_Code_Lookup.InsertRow

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5c521db0 | InsertButton | FP06970_Code_Lookup.cs:1474 | if (fps.Name == "spdMain") | MESSAGE | MessageBox.Show | ("Cannot add Procedure directly. Add value with procedure name, you can get it. Use [Looku… | 메시지 표시 |  |  |  |
| AC-4b1c530d | InsertButton | FP06970_Code_Lookup.cs:1475 | if (fps.Name == "spdMain") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0d666a7e | InsertButton | FP06970_Code_Lookup.cs:1487 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") | DATA_OP | siSub.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-021d782d | InsertButton | FP06970_Code_Lookup.cs:1489 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") | DATA_OP | defaultData.Add | (DefColumns.LOOKUP_TYPE_CODE, mainLookupType) | 데이터 객체 조작/조회 |  |  |  |
| AC-da1d5426 | InsertButton | FP06970_Code_Lookup.cs:1490 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") | DATA_OP | defaultData.Add | (DefColumns.SEGMENT1, "-") | 데이터 객체 조작/조회 |  |  |  |
| AC-c7172a54 | InsertButton | FP06970_Code_Lookup.cs:1491 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") | DATA_OP | defaultData.Add | (DefColumns.SEGMENT2, "-") | 데이터 객체 조작/조회 |  |  |  |
| AC-53a098d8 | InsertButton | FP06970_Code_Lookup.cs:1492 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") | DATA_OP | defaultData.Add | (DefColumns.SEGMENT3, "-") | 데이터 객체 조작/조회 |  |  |  |
| AC-a6d05326 | InsertButton | FP06970_Code_Lookup.cs:1493 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") | DATA_OP | defaultData.Add | (DefColumns.SEGMENT4, "-") | 데이터 객체 조작/조회 |  |  |  |
| AC-7a3df55e | InsertButton | FP06970_Code_Lookup.cs:1494 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") | DATA_OP | defaultData.Add | (DefColumns.SEGMENT5, "-") | 데이터 객체 조작/조회 |  |  |  |
| AC-3b9246ea | InsertButton | FP06970_Code_Lookup.cs:1495 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") | DATA_OP | defaultData.Add | (DefColumns.ACTIVE, "Y") | 데이터 객체 조작/조회 |  |  |  |
| AC-f429ce04 | InsertButton | FP06970_Code_Lookup.cs:1497 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") | GRID_SET | siSub.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |

## FP06970_Code_Lookup.RefreshSpreadSheet

진입점: FindButton [try] / SaveButton [if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ if (dsDelete.Good()) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5a3eb138 | FindButton [try] 외 1 | FP06970_Code_Lookup.cs:537 | if (mode == "MAIN") | FLAG | _dsMain | dsMain | 화면 필드/플래그 변경 |  |  |  |
| AC-502ef3dc | FindButton [try] 외 1 | FP06970_Code_Lookup.cs:538 | if (mode == "MAIN") | CALL_EXT | siMain.EditQuery | (dsMain) | ⚠ 의미 확인 필요 |  |  |  |
| AC-21b1d534 | FindButton [try] 외 1 | FP06970_Code_Lookup.cs:539 | if (mode == "MAIN") | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-4c55c4fb | FindButton [try] 외 1 | FP06970_Code_Lookup.cs:543 | else of (mode == "MAIN") ▸ if (mode == "SUB") | CALL_EXT | siSub.EditQuery | (dsMain_sub) | ⚠ 의미 확인 필요 |  |  |  |
| AC-235044bd | FindButton [try] 외 1 | FP06970_Code_Lookup.cs:544 | else of (mode == "MAIN") ▸ if (mode == "SUB") | GRID_LOCK | siSub.LockColumn | (0, siSub.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |

## FP06970_Code_Lookup.RunSqlSource

진입점: popSql.OnSql

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fa04dd17 | popSql.OnSql | FP06970_Code_Lookup.cs:1929 | if (fps.Name == "spdMain") | RETURN | return Find_Data_Amend("SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-f89d0e42 | popSql.OnSql | FP06970_Code_Lookup.cs:1934 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") | RETURN | return Find_Data_sub("SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-9533c7f5 | popSql.OnSql | FP06970_Code_Lookup.cs:1937 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP06970_Code_Lookup.SaveData

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7afd2e57 | SaveButton | FP06970_Code_Lookup.cs:987 | try | FLAG | last_pos | siMain.ActiveRowIndex | 화면 필드/플래그 변경 |  |  |  |
| AC-c89f3454 | SaveButton | FP06970_Code_Lookup.cs:988 | try | FLAG | last_pos2 | siSub.ActiveRowIndex | 화면 필드/플래그 변경 |  |  |  |
| AC-fcd9072a | SaveButton | FP06970_Code_Lookup.cs:997 | if (fps.Name == "spdMain") | VALIDATE | DataUtil.checkRequiredOfSpread | (siMain) | 프레임워크 검증 |  |  |  |
| AC-f8a72d94 | SaveButton | FP06970_Code_Lookup.cs:997 | if (fps.Name == "spdMain") ▸ if (!DataUtil.checkRequiredOfSpread(siMain)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-65ff17f4 | SaveButton | FP06970_Code_Lookup.cs:1002 | if (fps.Name == "spdMain") ▸ if (siMain.SpreadObject.DataSource != null) ▸ if (!CheckValidation(siMain)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-493b2694 | SaveButton | FP06970_Code_Lookup.cs:1008 | if (fps.Name == "spdMain") ▸ if (dsSave == null) | MESSAGE | MessageBox.Show | ("You need Find First for saving") | 메시지 표시 |  |  |  |
| AC-ef10e091 | SaveButton | FP06970_Code_Lookup.cs:1009 | if (fps.Name == "spdMain") ▸ if (dsSave == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a43fd33f | SaveButton | FP06970_Code_Lookup.cs:1011 | if (fps.Name == "spdMain") | DATA_OP | dsSave.Tables[0].Columns.SafeAdd | ("_OPCODE_", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-a6057f7a | SaveButton | FP06970_Code_Lookup.cs:1012 | if (fps.Name == "spdMain") | DATA_OP | dsSave.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-7fd82a85 | SaveButton | FP06970_Code_Lookup.cs:1026 | if (fps.Name == "spdMain") ▸ foreach (DataRow r in dsSave.Tables[0].Rows) | DATA_OP | r["_OPCODE_"] | "I" | 행/컬럼 값 대입 |  |  |  |
| AC-0970a836 | SaveButton | FP06970_Code_Lookup.cs:1035 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | siMain.GetBindingRow | (i) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-592be1e5 | SaveButton | FP06970_Code_Lookup.cs:1041 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ switch (actionState) case CAppSetting.FlagI: case CAppSetting.FlagA: ▸ if … | DATA_OP | bindingRow["_OPCODE_"] | "I" | 행/컬럼 값 대입 |  |  |  |
| AC-d5fb7aa2 | SaveButton | FP06970_Code_Lookup.cs:1045 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ switch (actionState) case CAppSetting.FlagM: ▸ if (bindingRow != null && b… | DATA_OP | bindingRow["_OPCODE_"] | "M" | 행/컬럼 값 대입 |  |  |  |
| AC-3e8ca7b1 | SaveButton | FP06970_Code_Lookup.cs:1049 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ switch (actionState) case CAppSetting.FlagD: ▸ if (bindingRow != null && b… | DATA_OP | bindingRow["_OPCODE_"] | "D" | 행/컬럼 값 대입 |  |  |  |
| AC-c6f5dac2 | SaveButton | FP06970_Code_Lookup.cs:1053 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ switch (actionState) default: ▸ if (bindingRow != null && bindingRow.RowSt… | DATA_OP | bindingRow["_OPCODE_"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-66eaa248 | SaveButton | FP06970_Code_Lookup.cs:1064 | if (fps.Name == "spdMain") ▸ if (iCount > 0) | DATA_OP | dsSave.Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-cd08ae56 | SaveButton | FP06970_Code_Lookup.cs:1065 | if (fps.Name == "spdMain") ▸ if (iCount > 0) | DATA_OP | dsSave.Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-c36e6d47 | SaveButton | FP06970_Code_Lookup.cs:1073 | if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ foreach (DataRow r in dsSave.Tables[0].Rows) ▸ switch (oc) case "D": | DATA_OP | dsDelete.Tables[0].ImportRow | (r) | 데이터 객체 조작/조회 |  |  |  |
| AC-54c5f990 | SaveButton | FP06970_Code_Lookup.cs:1079 | if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ foreach (DataRow r in dsSave.Tables[0].Rows) ▸ switch (oc) case "I": case "M": | DATA_OP | dsToSave.Tables[0].ImportRow | (r) | 데이터 객체 조작/조회 |  |  |  |
| AC-4f0f3bfb | SaveButton | FP06970_Code_Lookup.cs:1089 | if (fps.Name == "spdMain") ▸ if (iCount > 0) | UI_PROP | ret2.Success | true | 속성 Success 설정 |  |  |  |
| AC-d1cd2190 | SaveButton | FP06970_Code_Lookup.cs:1096 | if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ if (dsDelete.Good()) ▸ switch (conn) case "DevFp": | ENDPOINT | GService.FP_PseudoBatch | (@"code_lookup", "delete_code_lookup", dsDelete, 0,"admin") ⇒ biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=delete_code_lookup] \| FP\admin\… | 엔드포인트 호출 |  |  |  |
| AC-724f21a1 | SaveButton | FP06970_Code_Lookup.cs:1097 | if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ if (dsDelete.Good()) ▸ switch (conn) case "DevFp": | CALL_EXT | GService.ReadResult | (dtRet) | ⚠ 의미 확인 필요 |  |  |  |
| AC-2614e509 | SaveButton | FP06970_Code_Lookup.cs:1100 | if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ if (dsDelete.Good()) ▸ switch (conn) case "DevScp": | ENDPOINT | GService.CommonPseudoBatch | (@"scp\admin\code_lookup", "delete_code_lookup", dsDelete, 0) ⇒ biz:AppService.GeneralPseudoBatch [batchId=delete_code_lookup] \| scp\admin\code… | 엔드포인트 호출 |  |  |  |
| AC-2b9f798e | SaveButton | FP06970_Code_Lookup.cs:1103 | if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ if (dsDelete.Good()) ▸ switch (conn) case "QaFp": | ENDPOINT | GService.QAPseudoBatch | (@"qa\nerp\code_lookup_fp", "delete_code_lookup", dsDelete, 0) ⇒ biz:QACommonDataBLL.GeneralPseudoBatch [batchId=delete_code_lookup] \| qa\nerp\c… | 엔드포인트 호출 |  |  |  |
| AC-a6e42404 | SaveButton | FP06970_Code_Lookup.cs:1106 | if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ if (dsDelete.Good()) ▸ switch (conn) case "QaScp": | ENDPOINT | GService.QAPseudoBatch | (@"qa\nerp\code_lookup", "delete_code_lookup", dsDelete, 0) ⇒ biz:QACommonDataBLL.GeneralPseudoBatch [batchId=delete_code_lookup] \| qa\nerp\c… | 엔드포인트 호출 |  |  |  |
| AC-e6b7dea7 | SaveButton | FP06970_Code_Lookup.cs:1114 | if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ if (dsDelete.Good()) | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { ret2.Count.ToString() }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f56e5f63 | SaveButton | FP06970_Code_Lookup.cs:1116 | if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ if (dsDelete.Good()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-185e36cb | SaveButton | FP06970_Code_Lookup.cs:1123 | if (fps.Name == "spdMain") ▸ else of (iCount > 0) | MESSAGE | MessageBox.Show | ("No data to save") | 메시지 표시 |  |  |  |
| AC-6396fd31 | SaveButton | FP06970_Code_Lookup.cs:1124 | if (fps.Name == "spdMain") ▸ else of (iCount > 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f5f3c4c6 | SaveButton | FP06970_Code_Lookup.cs:1144 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") | VALIDATE | DataUtil.checkRequiredOfSpread | (siSub) | 프레임워크 검증 |  |  |  |
| AC-23305ae5 | SaveButton | FP06970_Code_Lookup.cs:1144 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ if (!DataUtil.checkRequiredOfSpread(siSub)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5cc2eff5 | SaveButton | FP06970_Code_Lookup.cs:1146 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ if (!CheckValidation(siSub)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8d96501d | SaveButton | FP06970_Code_Lookup.cs:1148 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") | FLAG | SaveFilter | Filter.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-0b41db4f | SaveButton | FP06970_Code_Lookup.cs:1148 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-1ee782cb | SaveButton | FP06970_Code_Lookup.cs:1152 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") | DATA_OP | (siSub.SpreadObject.DataSource as DataSet).Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-1ff15527 | SaveButton | FP06970_Code_Lookup.cs:1153 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") | DATA_OP | saveDS.Tables[0].Columns.Add | (CAppSetting.StringAction, typeof(char)) | 데이터 객체 조작/조회 |  |  |  |
| AC-b6af4827 | SaveButton | FP06970_Code_Lookup.cs:1191 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ if (dsSave == null) | MESSAGE | MessageBox.Show | ("You need Find First for saving") | 메시지 표시 |  |  |  |
| AC-14acc581 | SaveButton | FP06970_Code_Lookup.cs:1192 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ if (dsSave == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4d972ab6 | SaveButton | FP06970_Code_Lookup.cs:1194 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") | DATA_OP | dsSave.Tables[0].Columns.SafeAdd | ("_OPCODE_", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-e73c665a | SaveButton | FP06970_Code_Lookup.cs:1195 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") | DATA_OP | dsSave.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-7f909fa6 | SaveButton | FP06970_Code_Lookup.cs:1209 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ foreach (DataRow r in dsSave.Tables[0].Rows) | DATA_OP | r["_OPCODE_"] | "I" | 행/컬럼 값 대입 |  |  |  |
| AC-bcd05add | SaveButton | FP06970_Code_Lookup.cs:1218 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | siSub.GetBindingRow | (i) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-5a1fd076 | SaveButton | FP06970_Code_Lookup.cs:1224 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) ▸ switch (actionState) case CAppSetting.Flag… | DATA_OP | bindingRow["_OPCODE_"] | "I" | 행/컬럼 값 대입 |  |  |  |
| AC-a39ac9e2 | SaveButton | FP06970_Code_Lookup.cs:1228 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) ▸ switch (actionState) case CAppSetting.Flag… | DATA_OP | bindingRow["_OPCODE_"] | "M" | 행/컬럼 값 대입 |  |  |  |
| AC-1427486f | SaveButton | FP06970_Code_Lookup.cs:1232 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) ▸ switch (actionState) case CAppSetting.Flag… | DATA_OP | bindingRow["_OPCODE_"] | "D" | 행/컬럼 값 대입 |  |  |  |
| AC-a3c87b45 | SaveButton | FP06970_Code_Lookup.cs:1236 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) ▸ switch (actionState) default: ▸ if (bindin… | DATA_OP | bindingRow["_OPCODE_"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-f9ce2ee0 | SaveButton | FP06970_Code_Lookup.cs:1319 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ if (iCount > 0) | DATA_OP | dsSave.Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-b7193953 | SaveButton | FP06970_Code_Lookup.cs:1320 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ if (iCount > 0) | DATA_OP | dsSave.Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-3ea5477f | SaveButton | FP06970_Code_Lookup.cs:1328 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ if (iCount > 0) ▸ foreach (DataRow r in dsSave.Tables[0].Rows) ▸ switch (oc) c… | DATA_OP | dsDelete.Tables[0].ImportRow | (r) | 데이터 객체 조작/조회 |  |  |  |
| AC-d5d997ba | SaveButton | FP06970_Code_Lookup.cs:1334 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ if (iCount > 0) ▸ foreach (DataRow r in dsSave.Tables[0].Rows) ▸ switch (oc) c… | DATA_OP | dsToSave.Tables[0].ImportRow | (r) | 데이터 객체 조작/조회 |  |  |  |
| AC-aaf35ca1 | SaveButton | FP06970_Code_Lookup.cs:1343 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ if (iCount > 0) | UI_PROP | ret1.Success | true | 속성 Success 설정 |  |  |  |
| AC-fc309290 | SaveButton | FP06970_Code_Lookup.cs:1344 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ if (iCount > 0) | UI_PROP | ret2.Success | true | 속성 Success 설정 |  |  |  |
| AC-f6163135 | SaveButton | FP06970_Code_Lookup.cs:1350 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ if (iCount > 0) ▸ if (dsToSave.Good()) ▸ foreach (DataRow r in dsToSave.Tables… | DATA_OP | r["sort_order"] | "0" | 행/컬럼 값 대입 |  |  |  |
| AC-785fc5e2 | SaveButton | FP06970_Code_Lookup.cs:1360 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ if (iCount > 0) ▸ if (dsToSave.Good()) ▸ switch (conn) case "DevFp": | ENDPOINT | GService.FP_PseudoBatch | (@"code_lookup", "save_code_lookup_value", dsToSave, 0,"admin") ⇒ biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=save_code_lookup_value] \| FP\ad… | 엔드포인트 호출 |  |  |  |
| AC-d1c6e975 | SaveButton | FP06970_Code_Lookup.cs:1361 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ if (iCount > 0) ▸ if (dsToSave.Good()) ▸ switch (conn) case "DevFp": | CALL_EXT | GService.ReadResult | (dtRet) | ⚠ 의미 확인 필요 |  |  |  |
| AC-4d307ff4 | SaveButton | FP06970_Code_Lookup.cs:1364 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ if (iCount > 0) ▸ if (dsToSave.Good()) ▸ switch (conn) case "DevScp": | ENDPOINT | GService.CommonPseudoBatch | (@"scp\admin\code_lookup", "save_code_lookup_value", dsToSave, 0) ⇒ biz:AppService.GeneralPseudoBatch [batchId=save_code_lookup_value] \| scp\admin\… | 엔드포인트 호출 |  |  |  |
| AC-e3ca9571 | SaveButton | FP06970_Code_Lookup.cs:1367 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ if (iCount > 0) ▸ if (dsToSave.Good()) ▸ switch (conn) case "QaFp": | ENDPOINT | GService.QAPseudoBatch | (@"qa\nerp\code_lookup_fp", "save_code_lookup_value", dsToSave, 0) ⇒ biz:QACommonDataBLL.GeneralPseudoBatch [batchId=save_code_lookup_value] \| qa\ne… | 엔드포인트 호출 |  |  |  |
| AC-af1a3b95 | SaveButton | FP06970_Code_Lookup.cs:1370 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ if (iCount > 0) ▸ if (dsToSave.Good()) ▸ switch (conn) case "QaScp": | ENDPOINT | GService.QAPseudoBatch | (@"qa\nerp\code_lookup", "save_code_lookup_value", dsToSave, 0) ⇒ biz:QACommonDataBLL.GeneralPseudoBatch [batchId=save_code_lookup_value] \| qa\ne… | 엔드포인트 호출 |  |  |  |
| AC-a40a5ba4 | SaveButton | FP06970_Code_Lookup.cs:1382 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ if (iCount > 0) ▸ if (dsDelete.Good()) ▸ switch (conn) case "DevFp": | ENDPOINT | GService.FP_PseudoBatch | (@"code_lookup", "delete_code_lookup_value", dsDelete, 0,"admin") ⇒ biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=delete_code_lookup_value] \| FP\… | 엔드포인트 호출 |  |  |  |
| AC-85c693b5 | SaveButton | FP06970_Code_Lookup.cs:1383 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ if (iCount > 0) ▸ if (dsDelete.Good()) ▸ switch (conn) case "DevFp": | CALL_EXT | GService.ReadResult | (dtRet) | ⚠ 의미 확인 필요 |  |  |  |
| AC-6f8aafbb | SaveButton | FP06970_Code_Lookup.cs:1386 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ if (iCount > 0) ▸ if (dsDelete.Good()) ▸ switch (conn) case "DevScp": | ENDPOINT | GService.QAPseudoBatch | (@"scp\admin\code_lookup", "delete_code_lookup_value", dsDelete, 0) ⇒ biz:QACommonDataBLL.GeneralPseudoBatch [batchId=delete_code_lookup_value] \| scp… | 엔드포인트 호출 |  |  |  |
| AC-f1c6f0c9 | SaveButton | FP06970_Code_Lookup.cs:1389 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ if (iCount > 0) ▸ if (dsDelete.Good()) ▸ switch (conn) case "QaFp": | ENDPOINT | GService.QAPseudoBatch | (@"qa\nerp\code_lookup_fp", "delete_code_lookup_value", dsDelete, 0) ⇒ biz:QACommonDataBLL.GeneralPseudoBatch [batchId=delete_code_lookup_value] \| qa\… | 엔드포인트 호출 |  |  |  |
| AC-c216a943 | SaveButton | FP06970_Code_Lookup.cs:1392 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ if (iCount > 0) ▸ if (dsDelete.Good()) ▸ switch (conn) case "QaScp": | ENDPOINT | GService.QAPseudoBatch | (@"qa\nerp\code_lookup", "delete_code_lookup_value", dsDelete, 0) ⇒ biz:QACommonDataBLL.GeneralPseudoBatch [batchId=delete_code_lookup_value] \| qa\… | 엔드포인트 호출 |  |  |  |
| AC-af08e3ae | SaveButton | FP06970_Code_Lookup.cs:1400 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ if (iCount > 0) ▸ if (dsToSave.Good() && dsDelete.Good()) | UI_PROP | ret1.Success | false | 속성 Success 설정 |  |  |  |
| AC-2981ce51 | SaveButton | FP06970_Code_Lookup.cs:1401 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ if (iCount > 0) ▸ if (dsToSave.Good() && dsDelete.Good()) | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { ret1.Count.ToString() }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8446f56d | SaveButton | FP06970_Code_Lookup.cs:1409 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ if (iCount > 0) ▸ if (dsToSave.Good() && dsDelete.Good()) ▸ try | CALL_EXT | siMain.SetSelection | (last_pos, 0, 1, 1) | ⚠ 의미 확인 필요 |  |  |  |
| AC-7ab90c90 | SaveButton | FP06970_Code_Lookup.cs:1410 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ if (iCount > 0) ▸ if (dsToSave.Good() && dsDelete.Good()) ▸ try | CALL_EXT | siSub.SetSelection | (last_pos2, 0, 1, 1) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a4bc0882 | SaveButton | FP06970_Code_Lookup.cs:1413 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ if (iCount > 0) ▸ if (dsToSave.Good() && dsDelete.Good()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2e10fb9d | SaveButton | FP06970_Code_Lookup.cs:1417 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ if (iCount > 0) ▸ if (ret1.Success && ret2.Success) | UI_PROP | ret1.Count | += ret2.Count | 속성 Count 설정 |  |  |  |
| AC-87b7043a | SaveButton | FP06970_Code_Lookup.cs:1419 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ if (iCount > 0) ▸ if (ret1.Success && ret2.Success) ▸ if (ret1.Result == null) | UI_PROP | ret1.Result | ret2.Result | 속성 Result 설정 |  |  |  |
| AC-1386fa60 | SaveButton | FP06970_Code_Lookup.cs:1420 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ if (iCount > 0) ▸ if (ret1.Success && ret2.Success) | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { ret1.Count.ToString() }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-275108f3 | SaveButton | FP06970_Code_Lookup.cs:1428 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ if (iCount > 0) ▸ if (ret1.Success && ret2.Success) ▸ try | GRID_STYLE | siMain.SpreadObject.ActiveSheet.SetActiveCell | (last_pos, 1,true) | 그리드 표시 설정 |  |  |  |
| AC-2c096c6f | SaveButton | FP06970_Code_Lookup.cs:1429 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ if (iCount > 0) ▸ if (ret1.Success && ret2.Success) ▸ try | GRID_STYLE | siMain.SpreadObject.SetViewportTopRow | (0, last_pos) | 그리드 표시 설정 |  |  |  |
| AC-a5320e5c | SaveButton | FP06970_Code_Lookup.cs:1430 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ if (iCount > 0) ▸ if (ret1.Success && ret2.Success) ▸ try | CALL_EXT | siSub.SetSelection | (last_pos2, 0, 1, 1) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9683b099 | SaveButton | FP06970_Code_Lookup.cs:1433 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ if (iCount > 0) ▸ if (ret1.Success && ret2.Success) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-463f8154 | SaveButton | FP06970_Code_Lookup.cs:1435 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ if (iCount > 0) | UI_PROP | ret1.Success | false | 속성 Success 설정 |  |  |  |
| AC-d8071f07 | SaveButton | FP06970_Code_Lookup.cs:1438 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ if (iCount > 0) ▸ if (ret1.Success) | UI_PROP | ret1.Message | "" | 속성 Message 설정 |  |  |  |
| AC-b7748755 | SaveButton | FP06970_Code_Lookup.cs:1442 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ if (iCount > 0) ▸ if (!ret2.Success) | UI_PROP | ret1.Message | += ret2.Message | 속성 Message 설정 |  |  |  |
| AC-182c5dd1 | SaveButton | FP06970_Code_Lookup.cs:1448 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ else of (iCount > 0) | MESSAGE | MessageBox.Show | ("No data to save") | 메시지 표시 |  |  |  |
| AC-9629526f | SaveButton | FP06970_Code_Lookup.cs:1449 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ else of (iCount > 0) | RETURN | return ; |  | 처리 중단/반환 |  |  |  |
| AC-6a7ebdec | SaveButton | FP06970_Code_Lookup.cs:1464 | try | CALL_EXT | siMain.SetSelection | (last_pos,0,1,1) | ⚠ 의미 확인 필요 |  |  |  |
| AC-28d3c3fc | SaveButton | FP06970_Code_Lookup.cs:1465 | try | CALL_EXT | siSub.SetSelection | (last_pos2, 0, 1, 1) | ⚠ 의미 확인 필요 |  |  |  |

## FP06970_Code_Lookup.SetColumInfo

진입점: this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == true) ▸ if (_UpAct_Cell != _PressAct_Cell)] / this.spdMain.CellClick / this.spdMain.ActiveSheet.CellChanged [if (siMain.IsLock(siMain.SheetName) == true)] / FindButton [if (siMain.ActiveSheet.RowCount > 0)] / SaveButton [if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ if (dsDelete.Good()) ▸ if (siMain.ActiveSheet.RowCount > 0)] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7f03061b | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP06970_Code_Lookup.cs:1772 |  | DATA_OP | dtColumInfo.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-27d38785 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP06970_Code_Lookup.cs:1773 |  | DATA_OP | dr[DefColumns.SEGMENT1] | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.SEGMENT1)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-106fe83c | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP06970_Code_Lookup.cs:1774 |  | DATA_OP | dr[DefColumns.SEGMENT2] | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.SEGMENT2)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-bda32059 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP06970_Code_Lookup.cs:1775 |  | DATA_OP | dr[DefColumns.SEGMENT3] | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.SEGMENT3)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-2d57355b | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP06970_Code_Lookup.cs:1776 |  | DATA_OP | dr[DefColumns.SEGMENT4] | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.SEGMENT4)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-2da0c9fe | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP06970_Code_Lookup.cs:1777 |  | DATA_OP | dr[DefColumns.SEGMENT5] | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.SEGMENT5)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-6f9ee54a | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP06970_Code_Lookup.cs:1778 |  | DATA_OP | dr[DefColumns.ATTRIBUTE1] | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ATTRIBUTE1)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-bcd724de | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP06970_Code_Lookup.cs:1779 |  | DATA_OP | dr[DefColumns.ATTRIBUTE2] | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ATTRIBUTE2)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-af192106 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP06970_Code_Lookup.cs:1780 |  | DATA_OP | dr[DefColumns.ATTRIBUTE3] | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ATTRIBUTE3)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-96c625b2 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP06970_Code_Lookup.cs:1781 |  | DATA_OP | dr[DefColumns.ATTRIBUTE4] | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ATTRIBUTE4)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-cc134e65 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP06970_Code_Lookup.cs:1782 |  | DATA_OP | dr[DefColumns.ATTRIBUTE5] | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ATTRIBUTE5)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-9d149045 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP06970_Code_Lookup.cs:1783 |  | DATA_OP | dr[DefColumns.ATTRIBUTE6] | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ATTRIBUTE6)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-eee79dde | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP06970_Code_Lookup.cs:1784 |  | DATA_OP | dr[DefColumns.ATTRIBUTE7] | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ATTRIBUTE7)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-c260c1fa | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP06970_Code_Lookup.cs:1785 |  | DATA_OP | dr[DefColumns.ATTRIBUTE8] | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ATTRIBUTE8)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-86989f15 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP06970_Code_Lookup.cs:1786 |  | DATA_OP | dr[DefColumns.ATTRIBUTE9] | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ATTRIBUTE9)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-7c02db99 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP06970_Code_Lookup.cs:1787 |  | DATA_OP | dr[DefColumns.ATTRIBUTE10] | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ATTRIBUTE10)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-56508961 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP06970_Code_Lookup.cs:1788 |  | DATA_OP | dr[DefColumns.ATTRIBUTE11] | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ATTRIBUTE11)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-5d047dff | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP06970_Code_Lookup.cs:1789 |  | DATA_OP | dr[DefColumns.ATTRIBUTE12] | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ATTRIBUTE12)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-6ad6429a | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP06970_Code_Lookup.cs:1790 |  | DATA_OP | dr[DefColumns.ATTRIBUTE13] | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ATTRIBUTE13)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-bc09a4e6 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP06970_Code_Lookup.cs:1791 |  | DATA_OP | dr[DefColumns.ATTRIBUTE14] | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ATTRIBUTE14)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-1f9eb7ed | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP06970_Code_Lookup.cs:1792 |  | DATA_OP | dr[DefColumns.ATTRIBUTE15] | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ATTRIBUTE15)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-d7dd3e6f | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 5 | FP06970_Code_Lookup.cs:1794 |  | DATA_OP | dtColumInfo.Rows.Add | (dr) | 데이터 객체 조작/조회 |  |  |  |

## FP06970_Code_Lookup.SetDevOption

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3dc26ac6 | this.Load | FP06970_Code_Lookup.cs:210 |  | CALL_EXT | UserService.HasExtraRole | (_CurrentUser) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e9c7758d | this.Load | FP06970_Code_Lookup.cs:212 | if (UserService.HasExtraRole(_CurrentUser)) | STATE | btnSql.Visible | true | 컨트롤 상태 Visible |  |  |  |
| AC-da1cdc6b | this.Load | FP06970_Code_Lookup.cs:216 | else of (UserService.HasExtraRole(_CurrentUser)) | STATE | btnSql.Visible | false | 컨트롤 상태 Visible |  |  |  |

## FP06970_Code_Lookup.simpleButton1_Click

진입점: this.simpleButton1.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-38f8984f | this.simpleButton1.Click | FP06970_Code_Lookup.cs:1984 | if (!siMain.IsLock(siMain.SheetName) \|\| !siSub.IsLock(siSub.SheetName)) | MESSAGE | MessageBox.Show | ("Can't search in Edit-Mode") | 메시지 표시 |  |  |  |
| AC-e0c4e737 | this.simpleButton1.Click | FP06970_Code_Lookup.cs:1985 | if (!siMain.IsLock(siMain.SheetName) \|\| !siSub.IsLock(siSub.SheetName)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP06970_Code_Lookup.SpdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3e808fce | this.spdMain.CellClick | FP06970_Code_Lookup.cs:1724 | if (siMain.IsLock(siMain.SheetName) == true) ▸ if (siMain.Sheet().Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5ae690dd | this.spdMain.CellClick | FP06970_Code_Lookup.cs:1726 | if (siMain.IsLock(siMain.SheetName) == true) | FLAG | _UpAct_Cell | this.spdMain.ActiveSheet.ActiveCell.Row.Index2.ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-b62091a3 | this.spdMain.CellClick | FP06970_Code_Lookup.cs:1728 | if (siMain.IsLock(siMain.SheetName) == true) | FLAG | mainLookupType | siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.LOOKUP_TYPE_CODE)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-5b7e6f06 | this.spdMain.CellClick | FP06970_Code_Lookup.cs:1729 | if (siMain.IsLock(siMain.SheetName) == true) | DATA_OP | Filter["ACTIVE_FLAG"] | siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.ACTIVE)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-b3937270 | this.spdMain.CellClick | FP06970_Code_Lookup.cs:1735 |  | STATE_RESET | dtColumInfo.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-39ae064e | this.spdMain.CellClick | FP06970_Code_Lookup.cs:1747 | if (cbGenTmplate.Checked == true) ▸ if (r != null) | VALUE_SET | txtGuide.Text | sql | 컨트롤 값 설정 |  |  |  |
| AC-7f1a912c | this.spdMain.CellClick | FP06970_Code_Lookup.cs:1748 | if (cbGenTmplate.Checked == true) ▸ if (r != null) | CALL_EXT | Clipboard.SetData | (DataFormats.Text, sql) | ⚠ 의미 확인 필요 |  |  |  |

## FP06970_Code_Lookup.SpdMain_CellDoubleClick

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-631ab507 | (진입점 미연결) | FP06970_Code_Lookup.cs:1757 | if (siMain.IsLock(siMain.SheetName) == true) ▸ if (siMain.Sheet().Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0256845a | (진입점 미연결) | FP06970_Code_Lookup.cs:1759 | if (siMain.IsLock(siMain.SheetName) == true) | FLAG | mainLookupType | siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.LOOKUP_TYPE_CODE)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-dc308b35 | (진입점 미연결) | FP06970_Code_Lookup.cs:1760 | if (siMain.IsLock(siMain.SheetName) == true) | DATA_OP | Filter["ACTIVE_FLAG"] | siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.ACTIVE)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-b2135c7f | (진입점 미연결) | FP06970_Code_Lookup.cs:1762 | if (siMain.IsLock(siMain.SheetName) == true) | STATE_RESET | dtColumInfo.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |

## FP06970_Code_Lookup.spdMain_KeyUp

진입점: this.spdMain.KeyUp

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-81e18e81 | this.spdMain.KeyUp | FP06970_Code_Lookup.cs:1950 | if (siMain.IsLock(siMain.SheetName) == true) ▸ if (_UpAct_Cell != _PressAct_Cell) ▸ if (siMain.Sheet().Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7633cb50 | this.spdMain.KeyUp | FP06970_Code_Lookup.cs:1953 | if (siMain.IsLock(siMain.SheetName) == true) ▸ if (_UpAct_Cell != _PressAct_Cell) ▸ if (e.KeyData != Keys.Left && e.KeyData != Keys.Right) | FLAG | _PressAct_Cell | _UpAct_Cell | 화면 필드/플래그 변경 |  |  |  |
| AC-de280ca5 | this.spdMain.KeyUp | FP06970_Code_Lookup.cs:1954 | if (siMain.IsLock(siMain.SheetName) == true) ▸ if (_UpAct_Cell != _PressAct_Cell) ▸ if (e.KeyData != Keys.Left && e.KeyData != Keys.Right) | FLAG | _UpAct_Cell | this.spdMain.ActiveSheet.ActiveCell.Row.Index2.ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-635cbe3c | this.spdMain.KeyUp | FP06970_Code_Lookup.cs:1958 | if (siMain.IsLock(siMain.SheetName) == true) ▸ if (_UpAct_Cell != _PressAct_Cell) | FLAG | mainLookupType | siMain.GetValue(this.spdMain.ActiveSheet.ActiveCell.Row.Index2, siMain.GetColumnIndex(DefC… | 화면 필드/플래그 변경 |  |  |  |
| AC-ba21ffcc | this.spdMain.KeyUp | FP06970_Code_Lookup.cs:1959 | if (siMain.IsLock(siMain.SheetName) == true) ▸ if (_UpAct_Cell != _PressAct_Cell) | DATA_OP | Filter["ACTIVE_FLAG"] | siMain.GetValue(this.spdMain.ActiveSheet.ActiveCell.Row.Index2, siMain.GetColumnIndex(DefC… | 행/컬럼 값 대입 |  |  |  |
| AC-94cb950f | this.spdMain.KeyUp | FP06970_Code_Lookup.cs:1961 | if (siMain.IsLock(siMain.SheetName) == true) ▸ if (_UpAct_Cell != _PressAct_Cell) | STATE_RESET | dtColumInfo.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-8a4112aa | this.spdMain.KeyUp | FP06970_Code_Lookup.cs:1969 | if (siMain.IsLock(siMain.SheetName) == true) | UI_PROP | this.ActiveControl | spdMain | 속성 ActiveControl 설정 |  |  |  |
| AC-f53f65ed | this.spdMain.KeyUp | FP06970_Code_Lookup.cs:1974 | else of (siMain.IsLock(siMain.SheetName) == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP06970_Code_Lookup.UIFindData

진입점: FindButton / SaveButton [if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ if (dsDelete.Good())]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6e737465 | FindButton 외 1 | FP06970_Code_Lookup.cs:423 | try ▸ if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-dd68b6b6 | FindButton 외 1 | FP06970_Code_Lookup.cs:424 | try ▸ if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8186d0f8 | FindButton 외 1 | FP06970_Code_Lookup.cs:427 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-fbddc2e9 | FindButton 외 1 | FP06970_Code_Lookup.cs:429 | try | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-3f6633f7 | FindButton 외 1 | FP06970_Code_Lookup.cs:433 | try | FLAG | dsMain | null | 화면 필드/플래그 변경 |  |  |  |
| AC-03ce7902 | FindButton 외 1 | FP06970_Code_Lookup.cs:436 | try | STATE | usrTextBox_Att.ReadOnly | true | 컨트롤 상태 ReadOnly |  |  |  |
| AC-40708298 | FindButton 외 1 | FP06970_Code_Lookup.cs:437 | try | VALUE_CLEAR | usrTextBox_Att.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-b8b6c488 | FindButton 외 1 | FP06970_Code_Lookup.cs:438 | try | STATE | simpleButton1.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-e5dbbf43 | FindButton 외 1 | FP06970_Code_Lookup.cs:448 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-7d2c34db | FindButton 외 1 | FP06970_Code_Lookup.cs:450 | try | FLAG | dsMain | await asyncProxy.ExecuteAsync<DataSet>(() => Find_Data_Amend("SELECT") ) | 화면 필드/플래그 변경 |  |  |  |
| AC-ef363621 | FindButton 외 1 | FP06970_Code_Lookup.cs:450 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => Find_Data_Amend("SELECT") ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-30417628 | FindButton 외 1 | FP06970_Code_Lookup.cs:465 | try ▸ if (dsMain != null) ▸ if (dsMain.Tables[0].Rows.Count > 0) | STATE | usrTextBox_Att.ReadOnly | false | 컨트롤 상태 ReadOnly |  |  |  |
| AC-f0bcfcb1 | FindButton 외 1 | FP06970_Code_Lookup.cs:466 | try ▸ if (dsMain != null) ▸ if (dsMain.Tables[0].Rows.Count > 0) | STATE | simpleButton1.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-1e48cea7 | FindButton 외 1 | FP06970_Code_Lookup.cs:470 | try ▸ if (dsMain != null) ▸ else of (dsMain.Tables[0].Rows.Count > 0) | GRID_BIND | siMain.Query | (dsMain, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-b559be50 | FindButton 외 1 | FP06970_Code_Lookup.cs:471 | try ▸ if (dsMain != null) ▸ else of (dsMain.Tables[0].Rows.Count > 0) | FLAG | _dsMain | dsMain | 화면 필드/플래그 변경 |  |  |  |
| AC-a9df8c66 | FindButton 외 1 | FP06970_Code_Lookup.cs:472 | try ▸ if (dsMain != null) ▸ else of (dsMain.Tables[0].Rows.Count > 0) | UI_MISC | SetSearchCount | (dsMain) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-de34dde1 | FindButton 외 1 | FP06970_Code_Lookup.cs:473 | try ▸ if (dsMain != null) ▸ else of (dsMain.Tables[0].Rows.Count > 0) | GRID_SET | siMain.ActiveSheet.RowCount | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-b9f4750b | FindButton 외 1 | FP06970_Code_Lookup.cs:475 | try ▸ if (dsMain != null) ▸ else of (dsMain.Tables[0].Rows.Count > 0) | STATE | usrTextBox_Att.ReadOnly | true | 컨트롤 상태 ReadOnly |  |  |  |
| AC-45bebcc8 | FindButton 외 1 | FP06970_Code_Lookup.cs:476 | try ▸ if (dsMain != null) ▸ else of (dsMain.Tables[0].Rows.Count > 0) | VALUE_CLEAR | usrTextBox_Att.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-e7b55665 | FindButton 외 1 | FP06970_Code_Lookup.cs:477 | try ▸ if (dsMain != null) ▸ else of (dsMain.Tables[0].Rows.Count > 0) | STATE | simpleButton1.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-6983924e | FindButton 외 1 | FP06970_Code_Lookup.cs:482 | try ▸ else of (dsMain != null) | GRID_SET | siMain.ActiveSheet.RowCount | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-5d6ac6ed | FindButton 외 1 | FP06970_Code_Lookup.cs:483 | try ▸ else of (dsMain != null) | MESSAGE | MessageBox.Show | ("Query Statement is Occure Error!", "Error", MessageBoxButtons.OK, MessageBoxIcon.Informa… | 메시지 표시 |  |  |  |
| AC-4df76760 | FindButton 외 1 | FP06970_Code_Lookup.cs:503 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-5c5f3005 | FindButton 외 1 | FP06970_Code_Lookup.cs:508 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-dcad2ff2 | FindButton 외 1 | FP06970_Code_Lookup.cs:509 | finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-ffaeeca5 | FindButton 외 1 | FP06970_Code_Lookup.cs:510 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-51ea26f8 | FindButton 외 1 | FP06970_Code_Lookup.cs:515 | if (siMain.ActiveSheet.RowCount > 0) | FLAG | mainLookupType | siMain.GetValue(0, siMain.GetColumnIndex(DefColumns.LOOKUP_TYPE_CODE)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-fcb45c9b | FindButton 외 1 | FP06970_Code_Lookup.cs:517 | if (siMain.ActiveSheet.RowCount > 0) | STATE_RESET | dtColumInfo.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-30eed20d | FindButton 외 1 | FP06970_Code_Lookup.cs:520 | if (siMain.ActiveSheet.RowCount > 0) | DATA_OP | Filter["ACTIVE_FLAG"] | siMain.GetValue(0, siMain.GetColumnIndex(DefColumns.ACTIVE)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-4380488d | FindButton 외 1 | FP06970_Code_Lookup.cs:526 | try | GRID_STYLE | siMain.SpreadObject.ActiveSheet.SetActiveCell | (last_pos, 1, true) | 그리드 표시 설정 |  |  |  |
| AC-ea429938 | FindButton 외 1 | FP06970_Code_Lookup.cs:527 | try | GRID_STYLE | siMain.SpreadObject.SetViewportTopRow | (0, last_pos) | 그리드 표시 설정 |  |  |  |
| AC-3dfa0c08 | FindButton 외 1 | FP06970_Code_Lookup.cs:528 | try | CALL_EXT | siSub.SetSelection | (last_pos2, 0, 1, 1) | ⚠ 의미 확인 필요 |  |  |  |

## FP06970_Code_Lookup.usrTextBox_Att_KeyUp

진입점: this.usrTextBox_Att.KeyUp

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-497157b5 | this.usrTextBox_Att.KeyUp | FP06970_Code_Lookup.cs:2001 | if (!siMain.IsLock(siMain.SheetName) \|\| !siSub.IsLock(siSub.SheetName)) | MESSAGE | MessageBox.Show | ("Can't search in Edit-Mode") | 메시지 표시 |  |  |  |
| AC-2666df3a | this.usrTextBox_Att.KeyUp | FP06970_Code_Lookup.cs:2002 | if (!siMain.IsLock(siMain.SheetName) \|\| !siSub.IsLock(siSub.SheetName)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

