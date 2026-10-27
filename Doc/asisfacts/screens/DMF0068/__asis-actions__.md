# AS-IS 액션 대조표 — DMF0068

> 원천: `Doc/asisfacts/screens/DMF0068/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 306행 · 메서드 33 · 종류 DATA_OP 69 · RETURN 37 · GRID_INIT 32 · MESSAGE 27 · GRID_SET 26 · UI_PROP 19 · UI_MISC 16 · FLAG 13 · ENDPOINT 13 · CALL_EXT 12 · GRID_LOCK 8 · GRID_COMBO 8 · POPUP 7 · STATE 7 · VALUE_SET 3 · COMBO_DATA 2 · GRID_BIND 2 · LIST_REBIND 2 · THROW 1 · GRID_STYLE 1 · VALUE_CLEAR 1 · ⚠ 의미 확인 필요 12


## DMF0068_DemandManager40.btnSPVer_Click

진입점: this.btnSPVer.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-439eecec | this.btnSPVer.Click | DMF0068_DemandManager40.cs:1319 |  | COMBO_DATA | Data.MultiTimeZone | (UserInfoContext.Current["TimeZone"]) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-b3ac6740 | this.btnSPVer.Click | DMF0068_DemandManager40.cs:1323 |  | POPUP | new DMF0068_VersionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-5f1d7789 | this.btnSPVer.Click | DMF0068_DemandManager40.cs:1324 |  | POPUP | popVersion.Form_Load | (true, "SP", sDivision, sStartDate, sEndDate) | 팝업 초기화(인자 전달) |  |  |  |
| AC-06c7669a | this.btnSPVer.Click | DMF0068_DemandManager40.cs:1325 |  | UI_PROP | popVersion.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-cba32b6b | this.btnSPVer.Click | DMF0068_DemandManager40.cs:1326 |  | POPUP | popVersion.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-f6d628ac | this.btnSPVer.Click | DMF0068_DemandManager40.cs:1330 | if (popVersion.sVersions != "") | VALUE_SET | txtVersion.Text | popVersion.sVersions | 컨트롤 값 설정 |  |  |  |

## DMF0068_DemandManager40.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b96e245d | this.Load | DMF0068_DemandManager40.cs:220 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 2, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-ac6e82c7 | this.Load | DMF0068_DemandManager40.cs:221 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-d9937f3a | this.Load | DMF0068_DemandManager40.cs:222 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DMF0068_DemandManager40.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b870c6f9 | this.Load | DMF0068_DemandManager40.cs:213 |  | FLAG | cellTypeImage | new TextCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-f01cb73c | this.Load | DMF0068_DemandManager40.cs:214 |  | UI_PROP | cellTypeImage.BackgroundImage | new FarPoint.Win.Picture(siMain.ImagePopUp) | 속성 BackgroundImage 설정 |  |  |  |
| AC-92ed20f9 | this.Load | DMF0068_DemandManager40.cs:215 |  | UI_PROP | cellTypeImage.BackgroundImage.AlignHorz | FarPoint.Win.HorizontalAlignment.Right | 속성 AlignHorz 설정 |  |  |  |

## DMF0068_DemandManager40.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6f9e84db | DeleteButton | DMF0068_DemandManager40.cs:427 | if (spdMain.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1eea22e5 | DeleteButton | DMF0068_DemandManager40.cs:429 | if (siMain.GetValue(siMain.ActiveRowIndex, siMain.GetColumnIndex("KEYVALUE")).ToString() == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1a5009d5 | DeleteButton | DMF0068_DemandManager40.cs:430 |  | DATA_OP | siMain.Delete | () | 데이터 객체 조작/조회 |  |  |  |

## DMF0068_DemandManager40.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-006452fd | Dispose | DMF0068_DemandManager40.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## DMF0068_DemandManager40.dtMeasureB

진입점: InsertButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (txtVersion.Text.Substring(0, 3) == "R_S")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e3fc67ca | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… | DMF0068_DemandManager40.cs:112 |  | DATA_OP | dt.Columns.Add | ("CODE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-4f9b982e | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… | DMF0068_DemandManager40.cs:113 |  | DATA_OP | dt.Columns.Add | ("NAME", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-46b90102 | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… | DMF0068_DemandManager40.cs:119 |  | DATA_OP | dt.Rows.Add | (new object[] { "MEA_1", "QTY(Cell)" }) | 데이터 객체 조작/조회 |  |  |  |
| AC-53189a7b | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… | DMF0068_DemandManager40.cs:120 |  | DATA_OP | dt.Rows.Add | (new object[] { "SalesAmt_KRW", "Sales Amt.(KRW)" }) | 데이터 객체 조작/조회 |  |  |  |
| AC-94a4d7ab | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… | DMF0068_DemandManager40.cs:122 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0068_DemandManager40.dtMeasureS

진입점: InsertButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-65635241 | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… | DMF0068_DemandManager40.cs:94 |  | DATA_OP | dt.Columns.Add | ("CODE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-37ed9783 | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… | DMF0068_DemandManager40.cs:95 |  | DATA_OP | dt.Columns.Add | ("NAME", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-69511671 | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… | DMF0068_DemandManager40.cs:101 |  | DATA_OP | dt.Rows.Add | (new object[] { "MEA_1", "QTY(Cell)" }) | 데이터 객체 조작/조회 |  |  |  |
| AC-ee33ebb7 | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… | DMF0068_DemandManager40.cs:102 |  | DATA_OP | dt.Rows.Add | (new object[] { "SalesAmt_KRW", "Sales Amt.(KRW)" }) | 데이터 객체 조작/조회 |  |  |  |
| AC-d15feb3a | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… | DMF0068_DemandManager40.cs:106 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0068_DemandManager40.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7d92b458 | EditButton | DMF0068_DemandManager40.cs:446 |  | DATA_OP | dtDivision.Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-8c7ac64a | EditButton | DMF0068_DemandManager40.cs:446 | lambda | DATA_OP | c["CODE"].ToString().Contains | ("40") | 데이터 객체 조작/조회 |  |  |  |
| AC-ac7eacf6 | EditButton | DMF0068_DemandManager40.cs:449 | if (!anyDivision) | MESSAGE | MessageHelper.GMessageBox | ("MSG00415") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-266ce317 | EditButton | DMF0068_DemandManager40.cs:450 | if (!anyDivision) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-449cf3a4 | EditButton | DMF0068_DemandManager40.cs:452 |  | DATA_OP | viewAuth.Contains | (UserInfoContext.Current["NowGroupID"]) | 데이터 객체 조작/조회 |  |  |  |
| AC-5cccbe2c | EditButton | DMF0068_DemandManager40.cs:454 | if (!viewAuth.Contains(UserInfoContext.Current["NowGroupID"])) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-89fe39a1 | EditButton | DMF0068_DemandManager40.cs:455 | if (!viewAuth.Contains(UserInfoContext.Current["NowGroupID"])) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-665d6266 | EditButton | DMF0068_DemandManager40.cs:457 | if (spdMain.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-33f215d6 | EditButton | DMF0068_DemandManager40.cs:461 | if (this.fps != null) | STATE | txtVersion.Enabled | btnSPVer.Enabled = drpPeriodMonth.Enabled = !siMain.IsLock() | 컨트롤 상태 Enabled |  |  |  |
| AC-2ee282e0 | EditButton | DMF0068_DemandManager40.cs:461 | if (this.fps != null) | STATE | btnSPVer.Enabled | drpPeriodMonth.Enabled = !siMain.IsLock() | 컨트롤 상태 Enabled |  |  |  |
| AC-19dcf512 | EditButton | DMF0068_DemandManager40.cs:461 | if (this.fps != null) | STATE | drpPeriodMonth.Enabled | !siMain.IsLock() | 컨트롤 상태 Enabled |  |  |  |
| AC-05fc4e31 | EditButton | DMF0068_DemandManager40.cs:463 | if (this.fps != null) | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-ddd3f932 | EditButton | DMF0068_DemandManager40.cs:465 | if (this.fps != null) | GRID_LOCK | siMain.LockColumn | (2, 2, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-61e9e488 | EditButton | DMF0068_DemandManager40.cs:466 | if (this.fps != null) | GRID_LOCK | siMain.LockColumn | (5, 5, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-54317bf3 | EditButton | DMF0068_DemandManager40.cs:467 | if (this.fps != null) | GRID_LOCK | siMain.LockColumn | (8, siMain.ActiveSheet.ColumnCount - 1, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-ae41cb41 | EditButton | DMF0068_DemandManager40.cs:484 | if (this.fps != null) ▸ for (i < spdMain.ActiveSheet.RowCount) ▸ if ((i + 1) % 2 == 0) | GRID_LOCK | siMain.LockRange | (i, siMain.GetColumnIndex(DefColumns.OrderStart) , i, siMain.GetColumnIndex(DefColumns.Ord… | 그리드 편집 잠금/해제 |  |  |  |
| AC-ccff2476 | EditButton | DMF0068_DemandManager40.cs:487 | if (this.fps != null) ▸ for (i < spdMain.ActiveSheet.RowCount) ▸ if ((i + 1) % 2 == 0) | GRID_SET | siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(DefColumns.OrderStart)].Formula | siMain.ActiveSheet.Cells[i - 1, siMain.GetColumnIndex(DefColumns.OrderStart)].ToString() | 그리드 속성/값 설정 |  |  |  |
| AC-773bfd3f | EditButton | DMF0068_DemandManager40.cs:490 | if (this.fps != null) ▸ for (i < spdMain.ActiveSheet.RowCount) ▸ if ((i + 1) % 2 == 0) | GRID_SET | siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(DefColumns.OrderEnd)].Formula | siMain.ActiveSheet.Cells[i - 1, siMain.GetColumnIndex(DefColumns.OrderEnd)].ToString() | 그리드 속성/값 설정 |  |  |  |

## DMF0068_DemandManager40.ExcelButton

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-29ce37e9 | ExcelButton | DMF0068_DemandManager40.cs:526 |  | UI_PROP | exportOption.Merge | ExcelMergeOption.None | 속성 Merge 설정 |  |  |  |
| AC-7215299e | ExcelButton | DMF0068_DemandManager40.cs:527 |  | UI_PROP | exportOption.Border | ExcelBorderOption.All | 속성 Border 설정 |  |  |  |
| AC-f3cd0ff5 | ExcelButton | DMF0068_DemandManager40.cs:528 |  | UI_PROP | exportOption.AheadZeroOption | ZeroOption.HideZero | 속성 AheadZeroOption 설정 |  |  |  |
| AC-f0a5fd19 | ExcelButton | DMF0068_DemandManager40.cs:529 |  | UI_PROP | exportOption.AmendZeroOption | ZeroOption.ShowZero | 속성 AmendZeroOption 설정 |  |  |  |
| AC-f2074174 | ExcelButton | DMF0068_DemandManager40.cs:530 |  | UI_PROP | exportOption.AmendNullToZero | false | 속성 AmendNullToZero 설정 |  |  |  |
| AC-cf847331 | ExcelButton | DMF0068_DemandManager40.cs:531 |  | UI_PROP | exportOption.AheadNullToZero | false | 속성 AheadNullToZero 설정 |  |  |  |
| AC-c046413a | ExcelButton | DMF0068_DemandManager40.cs:533 |  | UI_PROP | exportOption.UserName | UserInfo.UserId | 속성 UserName 설정 |  |  |  |
| AC-cf0ef877 | ExcelButton | DMF0068_DemandManager40.cs:534 |  | UI_PROP | exportOption.FileName | sFileName | 속성 FileName 설정 |  |  |  |
| AC-6e1ff6ce | ExcelButton | DMF0068_DemandManager40.cs:536 |  | UI_PROP | exportOption.AmendDecimalFormat | "#,##0;[Red]-#,##0" | 속성 AmendDecimalFormat 설정 |  |  |  |
| AC-2e482747 | ExcelButton | DMF0068_DemandManager40.cs:545 | try | CALL_EXT | SimplexelService.ExportFpSpread | (fps, exportOption) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e14b66dc | ExcelButton | DMF0068_DemandManager40.cs:550 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-f810bd1c | ExcelButton | DMF0068_DemandManager40.cs:554 | finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## DMF0068_DemandManager40.FindData

진입점: FindButton / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ if (bolReload)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-57177b8f | FindButton 외 1 | DMF0068_DemandManager40.cs:573 |  | DATA_OP | dtDivision.Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-fb4bac65 | FindButton 외 1 | DMF0068_DemandManager40.cs:573 | lambda | DATA_OP | c["CODE"].ToString().Contains | ("40") | 데이터 객체 조작/조회 |  |  |  |
| AC-8cbf9d2a | FindButton 외 1 | DMF0068_DemandManager40.cs:576 | if (!anyDivision) | MESSAGE | MessageHelper.GMessageBox | ("MSG00415") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-58066d79 | FindButton 외 1 | DMF0068_DemandManager40.cs:577 | if (!anyDivision) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-25fcec83 | FindButton 외 1 | DMF0068_DemandManager40.cs:579 |  | DATA_OP | viewAuth.Contains | (UserInfoContext.Current["NowGroupID"]) | 데이터 객체 조작/조회 |  |  |  |
| AC-6fc05846 | FindButton 외 1 | DMF0068_DemandManager40.cs:581 | if (!viewAuth.Contains(UserInfoContext.Current["NowGroupID"])) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-945c4afe | FindButton 외 1 | DMF0068_DemandManager40.cs:582 | if (!viewAuth.Contains(UserInfoContext.Current["NowGroupID"])) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8611af10 | FindButton 외 1 | DMF0068_DemandManager40.cs:587 | if (txtVersion.Text == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00283") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-7d47c4e1 | FindButton 외 1 | DMF0068_DemandManager40.cs:588 | if (txtVersion.Text == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-11812e24 | FindButton 외 1 | DMF0068_DemandManager40.cs:592 | if (drpPeriodMonth.MonthText1 == "" \|\| drpPeriodMonth.MonthText2 == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { "Period" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-5e75c72b | FindButton 외 1 | DMF0068_DemandManager40.cs:593 | if (drpPeriodMonth.MonthText1 == "" \|\| drpPeriodMonth.MonthText2 == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d0fe422d | FindButton 외 1 | DMF0068_DemandManager40.cs:603 | catch () | MESSAGE | MessageHelper.GMessageBox | ("MSG00049", new object[] { "" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-be7502a1 | FindButton 외 1 | DMF0068_DemandManager40.cs:604 | catch () | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-119c9243 | FindButton 외 1 | DMF0068_DemandManager40.cs:609 | if (Convert.ToDateTime(drpPeriodMonth.MonthText1 + "-01") > Convert.ToDateTime(drpPeriodMonth.MonthText2 + "-01")) | MESSAGE | MessageHelper.GMessageBox | ("MSG00108") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e9efe848 | FindButton 외 1 | DMF0068_DemandManager40.cs:610 | if (Convert.ToDateTime(drpPeriodMonth.MonthText1 + "-01") > Convert.ToDateTime(drpPeriodMonth.MonthText2 + "-01")) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-281af7b1 | FindButton 외 1 | DMF0068_DemandManager40.cs:613 |  | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-8db9cde5 | FindButton 외 1 | DMF0068_DemandManager40.cs:618 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-de40ac82 | FindButton 외 1 | DMF0068_DemandManager40.cs:619 |  | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-d995087f | FindButton 외 1 | DMF0068_DemandManager40.cs:625 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-485902da | FindButton 외 1 | DMF0068_DemandManager40.cs:628 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding)) { va… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-45022c8e | FindButton 외 1 | DMF0068_DemandManager40.cs:632 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("DM.DMF0068_GET_ORDERLIST") ⇒ DM.DMF0068_GET_ORDERLIST | 엔드포인트 요청 생성 |  |  |  |
| AC-8a9f0499 | FindButton 외 1 | DMF0068_DemandManager40.cs:633 | try ▸ lambda | UI_PROP | request.CommandTimeout | 10 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-145f3923 | FindButton 외 1 | DMF0068_DemandManager40.cs:634 | try ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | "40" | 행/컬럼 값 대입 |  |  |  |
| AC-c58daead | FindButton 외 1 | DMF0068_DemandManager40.cs:635 | try ▸ lambda | DATA_OP | request.Parameters["p_version_no"] | txtVersion.Text | 행/컬럼 값 대입 |  |  |  |
| AC-4de46c0d | FindButton 외 1 | DMF0068_DemandManager40.cs:636 | try ▸ lambda | DATA_OP | request.Parameters["p_fromdt"] | drpPeriodMonth.MonthText1.Replace("-", "") | 행/컬럼 값 대입 |  |  |  |
| AC-06d7afa8 | FindButton 외 1 | DMF0068_DemandManager40.cs:637 | try ▸ lambda | DATA_OP | request.Parameters["p_todt"] | drpPeriodMonth.MonthText2.Replace("-", "") | 행/컬럼 값 대입 |  |  |  |
| AC-19c0d204 | FindButton 외 1 | DMF0068_DemandManager40.cs:639 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-2844799a | FindButton 외 1 | DMF0068_DemandManager40.cs:647 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-246e44a4 | FindButton 외 1 | DMF0068_DemandManager40.cs:655 | try ▸ if (strCnt != "0") | MESSAGE | MessageHelper.GMessageBox | ("MSG00307") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-97cfb4f2 | FindButton 외 1 | DMF0068_DemandManager40.cs:661 | try | GRID_BIND | siMain.Query | (dsMain) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-75e2cb05 | FindButton 외 1 | DMF0068_DemandManager40.cs:662 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-16355c01 | FindButton 외 1 | DMF0068_DemandManager40.cs:664 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d5256109 | FindButton 외 1 | DMF0068_DemandManager40.cs:722 | try ▸ for (i < siMain.ActiveSheet.RowCount) ▸ for (j < intMonCnt + 1 + 12) ▸ if (IsTmpMon) | GRID_SET | siMain.SetValue | (i, j, "0") | 그리드 값 설정 |  |  |  |
| AC-6e1841e4 | FindButton 외 1 | DMF0068_DemandManager40.cs:731 | try ▸ for (i < siMain.ActiveSheet.RowCount) ▸ for (j < intMonCnt + 1 + 12) ▸ else of (IsTmpMon) ▸ if (Convert.ToInt32(siMain.Sheet().ColumnH… | GRID_SET | siMain.SetValue | (i, j, "0") | 그리드 값 설정 |  |  |  |
| AC-dd15561d | FindButton 외 1 | DMF0068_DemandManager40.cs:736 | try ▸ for (i < siMain.ActiveSheet.RowCount) ▸ for (j < intMonCnt + 1 + 12) ▸ else of (IsTmpMon) ▸ else of (Convert.ToInt32(siMain.Sheet().Co… | GRID_SET | siMain.SetValue | (i, j, "0") | 그리드 값 설정 |  |  |  |
| AC-dfc14cc6 | FindButton 외 1 | DMF0068_DemandManager40.cs:812 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c7d707d3 | FindButton 외 1 | DMF0068_DemandManager40.cs:816 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-ead63ecf | FindButton 외 1 | DMF0068_DemandManager40.cs:818 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-422098be | FindButton 외 1 | DMF0068_DemandManager40.cs:819 | finally | STATE | txtVersion.Enabled | btnSPVer.Enabled = drpPeriodMonth.Enabled = true | 컨트롤 상태 Enabled |  |  |  |
| AC-50e4fb4c | FindButton 외 1 | DMF0068_DemandManager40.cs:819 | finally | STATE | btnSPVer.Enabled | drpPeriodMonth.Enabled = true | 컨트롤 상태 Enabled |  |  |  |
| AC-8fd70466 | FindButton 외 1 | DMF0068_DemandManager40.cs:819 | finally | STATE | drpPeriodMonth.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## DMF0068_DemandManager40.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1e4fa8a4 | this.Load | DMF0068_DemandManager40.cs:185 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-265ca6a4 | this.Load | DMF0068_DemandManager40.cs:187 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## DMF0068_DemandManager40.GetCellIndexBySpanRowCells

진입점: InsertButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c6f1f763 | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… | DMF0068_DemandManager40.cs:1311 |  | CALL_EXT | Math.DivRem | (iActiveRow, multiful, out div) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3bc17cb7 | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… | DMF0068_DemandManager40.cs:1312 |  | RETURN | return Convert.ToInt32(iActiveRow - div); |  | 처리 중단/반환 |  |  |  |

## DMF0068_DemandManager40.GetCellNumbersByRow

진입점: InsertButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-05cc7340 | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… | DMF0068_DemandManager40.cs:164 | for (i < (iRow + multiful)) ▸ if (iNo == iNo2) | DATA_OP | iResult[icount] | Convert.ToInt32(i) | 행/컬럼 값 대입 |  |  |  |
| AC-d96d1d6e | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… | DMF0068_DemandManager40.cs:169 |  | RETURN | return iResult; |  | 처리 중단/반환 |  |  |  |

## DMF0068_DemandManager40.GetLookupProject

진입점: InsertButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (strSelectedVer != txtVersion.Text)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-681a6909 | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… | DMF0068_DemandManager40.cs:128 |  | ENDPOINT | new FoxDataRequest | ("DM.DMF0068_GET_LOOKUPPROJECT") ⇒ DM.DMF0068_GET_LOOKUPPROJECT | 엔드포인트 요청 생성 |  |  |  |
| AC-88a60d9f | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… | DMF0068_DemandManager40.cs:132 |  | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-d54184ed | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… | DMF0068_DemandManager40.cs:134 |  | DATA_OP | request.Parameters["p_division_id"] | "40" | 행/컬럼 값 대입 |  |  |  |
| AC-7623acf2 | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… | DMF0068_DemandManager40.cs:135 |  | DATA_OP | request.Parameters["p_version_no"] | txtVersion.Text | 행/컬럼 값 대입 |  |  |  |
| AC-389189df | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… | DMF0068_DemandManager40.cs:136 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-58c2afdb | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… | DMF0068_DemandManager40.cs:139 |  | FLAG | strSelectedVer | txtVersion.Text | 화면 필드/플래그 변경 |  |  |  |
| AC-7efd10a9 | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… | DMF0068_DemandManager40.cs:140 |  | RETURN | return result.Tables[0]; |  | 처리 중단/반환 |  |  |  |

## DMF0068_DemandManager40.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4c8d7013 | this.Load | DMF0068_DemandManager40.cs:198 |  | UI_PROP | drpPeriodMonth.MonthText1 | DateTime.Now.AddYears(-1).ToString("yyyy") + "01" | 속성 MonthText1 설정 |  |  |  |
| AC-fb02f13a | this.Load | DMF0068_DemandManager40.cs:199 |  | UI_PROP | drpPeriodMonth.MonthText2 | DateTime.Now.AddYears(1).ToString("yyyy") + "12" | 속성 MonthText2 설정 |  |  |  |
| AC-08c505ad | this.Load | DMF0068_DemandManager40.cs:203 |  | DATA_OP | dtDivision.Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-ea0e58e9 | this.Load | DMF0068_DemandManager40.cs:203 | lambda | DATA_OP | c["CODE"].ToString().Contains | ("40") | 데이터 객체 조작/조회 |  |  |  |
| AC-ee5cdd7a | this.Load | DMF0068_DemandManager40.cs:206 | if (!anyDivision) | MESSAGE | MessageHelper.GMessageBox | ("MSG00415") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d99de011 | this.Load | DMF0068_DemandManager40.cs:207 | if (!anyDivision) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## DMF0068_DemandManager40.InitSpread

진입점: this.Load / FindButton / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ if (bolReload)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c946299d | this.Load 외 2 | DMF0068_DemandManager40.cs:248 | if (spdInfo == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-49c0a713 | this.Load 외 2 | DMF0068_DemandManager40.cs:249 |  | GRID_INIT | spdInfo.InitSheet | (spdInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-7a91b482 | this.Load 외 2 | DMF0068_DemandManager40.cs:250 |  | GRID_SET | spdInfo.ActiveSheet.DataSource | null | 그리드 속성/값 설정 |  |  |  |
| AC-f9ad5a57 | this.Load 외 2 | DMF0068_DemandManager40.cs:251 |  | GRID_INIT | spdInfo.SetSheetHeaderColumn | (spdInfo, 2) | 그리드 재구성/초기화 |  |  |  |
| AC-25a8a5ff | this.Load 외 2 | DMF0068_DemandManager40.cs:259 |  | GRID_INIT | spdInfo.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8424fe13 | this.Load 외 2 | DMF0068_DemandManager40.cs:262 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, 2, 1, 2, 20, "수주 기간", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |

## DMF0068_DemandManager40.InsertRow

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9bc457a1 | InsertButton | DMF0068_DemandManager40.cs:1148 | if (spdMain.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c09f5ab5 | InsertButton | DMF0068_DemandManager40.cs:1163 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | siMain.Insert | (2) | 데이터 객체 조작/조회 |  |  |  |
| AC-99637401 | InsertButton | DMF0068_DemandManager40.cs:1165 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_STYLE | siMain.SpreadObject.ActiveSheet.SetActiveCell | (iArray[0], 2) | 그리드 표시 설정 |  |  |  |
| AC-3214e15a | InsertButton | DMF0068_DemandManager40.cs:1167 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_COMBO | siMain.SetCellTypeCombo | (intActiveRowIdx, intMeasureIdx, dtMeasureS()) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-a572e076 | InsertButton | DMF0068_DemandManager40.cs:1168 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_COMBO | siMain.SetCellTypeCombo | (intActiveRowIdx + 1, intMeasureIdx, dtMeasureS()) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-2e97882e | InsertButton | DMF0068_DemandManager40.cs:1171 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Cells[intActiveRowIdx + 1, intOrderStartIdx].Locked | true | 그리드 속성/값 설정 |  |  |  |
| AC-12e3ca9f | InsertButton | DMF0068_DemandManager40.cs:1172 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Cells[intActiveRowIdx + 1, intOrderEndIdx].Locked | true | 그리드 속성/값 설정 |  |  |  |
| AC-bdb48cfc | InsertButton | DMF0068_DemandManager40.cs:1173 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Cells[intActiveRowIdx + 1, intProjectIdx].Locked | true | 그리드 속성/값 설정 |  |  |  |
| AC-c628a998 | InsertButton | DMF0068_DemandManager40.cs:1175 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Cells[intActiveRowIdx + 1, intOrderStartIdx].BackColor | System.Drawing.Color.FromArgb(255, 255, 255) | 그리드 속성/값 설정 |  |  |  |
| AC-e53aba9e | InsertButton | DMF0068_DemandManager40.cs:1176 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Cells[intActiveRowIdx + 1, intOrderEndIdx].BackColor | System.Drawing.Color.FromArgb(255, 255, 255) | 그리드 속성/값 설정 |  |  |  |
| AC-75446888 | InsertButton | DMF0068_DemandManager40.cs:1177 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Cells[intActiveRowIdx + 1, intProjectIdx].BackColor | System.Drawing.Color.FromArgb(255, 255, 255) | 그리드 속성/값 설정 |  |  |  |
| AC-43d82e93 | InsertButton | DMF0068_DemandManager40.cs:1186 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (strSelectedVer != txtVersi… | FLAG | dtLookUpPjt | GetLookupProject() | 화면 필드/플래그 변경 |  |  |  |
| AC-8fbdb5f5 | InsertButton | DMF0068_DemandManager40.cs:1189 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_COMBO | siMain.SetCellTypeCombo | (intActiveRowIdx, intProjectIdx, dtLookUpPjt) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-deedd473 | InsertButton | DMF0068_DemandManager40.cs:1190 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_COMBO | siMain.SetCellTypeCombo | (intActiveRowIdx + 1, intProjectIdx, dtLookUpPjt) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-a1f86d21 | InsertButton | DMF0068_DemandManager40.cs:1193 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Cells[intActiveRowIdx + 1, intOrderStartIdx].Formula | siMain.ActiveSheet.Cells[intActiveRowIdx, intOrderStartIdx].ToString() | 그리드 속성/값 설정 |  |  |  |
| AC-5b6afa77 | InsertButton | DMF0068_DemandManager40.cs:1196 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Cells[intActiveRowIdx + 1, intOrderEndIdx].Formula | siMain.ActiveSheet.Cells[intActiveRowIdx, intOrderEndIdx].ToString() | 그리드 속성/값 설정 |  |  |  |
| AC-d2cb0680 | InsertButton | DMF0068_DemandManager40.cs:1199 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Cells[intActiveRowIdx + 1, intProjectIdx].Formula | siMain.ActiveSheet.Cells[intActiveRowIdx, intProjectIdx].ToString() | 그리드 속성/값 설정 |  |  |  |
| AC-0abc7047 | InsertButton | DMF0068_DemandManager40.cs:1206 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (intActiveRowIdx, 8 , intActiveRowIdx + 1, siMain.ActiveSheet.ColumnCount - 1, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-c306a771 | InsertButton | DMF0068_DemandManager40.cs:1212 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (txtVersion.Text.Substring(… | GRID_COMBO | siMain.SetCellTypeCombo | (intActiveRowIdx, intMeasureIdx, dtMeasureS()) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-ba7edf11 | InsertButton | DMF0068_DemandManager40.cs:1213 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (txtVersion.Text.Substring(… | GRID_COMBO | siMain.SetCellTypeCombo | (intActiveRowIdx + 1, intMeasureIdx, dtMeasureS()) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-89f015ca | InsertButton | DMF0068_DemandManager40.cs:1215 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (txtVersion.Text.Substring(… | GRID_SET | siMain.SetValue | (intActiveRowIdx, intMeasureIdx, "MEA_1") | 그리드 값 설정 |  |  |  |
| AC-5605f4c2 | InsertButton | DMF0068_DemandManager40.cs:1216 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (txtVersion.Text.Substring(… | GRID_SET | siMain.SetValue | (intActiveRowIdx + 1, intMeasureIdx, "SalesAmt_KRW") | 그리드 값 설정 |  |  |  |
| AC-5b9a3fd2 | InsertButton | DMF0068_DemandManager40.cs:1220 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (txtVersion.Text.Subst… | GRID_COMBO | siMain.SetCellTypeCombo | (intActiveRowIdx, intMeasureIdx, dtMeasureB()) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-5bad1fb5 | InsertButton | DMF0068_DemandManager40.cs:1221 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (txtVersion.Text.Subst… | GRID_COMBO | siMain.SetCellTypeCombo | (intActiveRowIdx + 1, intMeasureIdx, dtMeasureB()) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-8989b3c4 | InsertButton | DMF0068_DemandManager40.cs:1223 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (txtVersion.Text.Subst… | GRID_SET | siMain.SetValue | (intActiveRowIdx, intMeasureIdx, "MEA_1") | 그리드 값 설정 |  |  |  |
| AC-d77f4bf8 | InsertButton | DMF0068_DemandManager40.cs:1224 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (txtVersion.Text.Subst… | GRID_SET | siMain.SetValue | (intActiveRowIdx + 1, intMeasureIdx, "SalesAmt_KRW") | 그리드 값 설정 |  |  |  |
| AC-dcdb0088 | InsertButton | DMF0068_DemandManager40.cs:1227 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Cells[intActiveRowIdx, intMeasureIdx].Locked | true | 그리드 속성/값 설정 |  |  |  |
| AC-b783924e | InsertButton | DMF0068_DemandManager40.cs:1228 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Cells[intActiveRowIdx + 1, intMeasureIdx].Locked | true | 그리드 속성/값 설정 |  |  |  |
| AC-aab9cd19 | InsertButton | DMF0068_DemandManager40.cs:1231 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | CALL_EXT | Guid.NewGuid | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-bafa9029 | InsertButton | DMF0068_DemandManager40.cs:1233 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.SetValue | (intActiveRowIdx, intKeyValue2Idx, strGuid) | 그리드 값 설정 |  |  |  |
| AC-54ab2439 | InsertButton | DMF0068_DemandManager40.cs:1234 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.SetValue | (intActiveRowIdx + 1, intKeyValue2Idx, strGuid) | 그리드 값 설정 |  |  |  |

## DMF0068_DemandManager40.MonthAgeFind

진입점: this.Load / FindButton [try] / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ if (bolReload) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f3b21e78 | this.Load 외 2 | DMF0068_DemandManager40.cs:326 |  | RETURN | return MonthCount; |  | 처리 중단/반환 |  |  |  |

## DMF0068_DemandManager40.SaveData

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a75e2316 | SaveButton | DMF0068_DemandManager40.cs:829 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (spdMain.ActiveSheet.RowCou… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8b51a78b | SaveButton | DMF0068_DemandManager40.cs:831 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-86eba54a | SaveButton | DMF0068_DemandManager40.cs:832 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-7c611d3b | SaveButton | DMF0068_DemandManager40.cs:843 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.R… | DATA_OP | dtProd.Columns.Add | ("PROJECT_CODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-c93d48c2 | SaveButton | DMF0068_DemandManager40.cs:844 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.R… | DATA_OP | dtProd.Columns.Add | ("YYYYMM_FROM") | 데이터 객체 조작/조회 |  |  |  |
| AC-2049e700 | SaveButton | DMF0068_DemandManager40.cs:845 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.R… | DATA_OP | dtProd.Columns.Add | ("YYYYMM_TO") | 데이터 객체 조작/조회 |  |  |  |
| AC-7f3ce20e | SaveButton | DMF0068_DemandManager40.cs:846 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.R… | DATA_OP | dtProd.Columns.Add | ("MEASURE") | 데이터 객체 조작/조회 |  |  |  |
| AC-1aef1dbc | SaveButton | DMF0068_DemandManager40.cs:847 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.R… | DATA_OP | dtProd.Columns.Add | ("ORDER_APPROVAL") | 데이터 객체 조작/조회 |  |  |  |
| AC-911e39ec | SaveButton | DMF0068_DemandManager40.cs:848 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.R… | DATA_OP | dtProd.Columns.Add | ("ORDER_NOW") | 데이터 객체 조작/조회 |  |  |  |
| AC-80166b2d | SaveButton | DMF0068_DemandManager40.cs:849 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.R… | DATA_OP | dtProd.Columns.Add | ("ATTRIBUTE1") | 데이터 객체 조작/조회 |  |  |  |
| AC-7fb808bc | SaveButton | DMF0068_DemandManager40.cs:850 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.R… | DATA_OP | dtProd.Columns.Add | ("ATTRIBUTE2") | 데이터 객체 조작/조회 |  |  |  |
| AC-6cbcdae0 | SaveButton | DMF0068_DemandManager40.cs:853 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.R… | DATA_OP | dtProd.Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-bd7002df | SaveButton | DMF0068_DemandManager40.cs:874 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.R… | DATA_OP | dtProd.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-170f3524 | SaveButton | DMF0068_DemandManager40.cs:922 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.R… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { "Period" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b0d7424c | SaveButton | DMF0068_DemandManager40.cs:923 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.R… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6986d039 | SaveButton | DMF0068_DemandManager40.cs:927 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.R… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { "Project" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-13f14d8d | SaveButton | DMF0068_DemandManager40.cs:928 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.R… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9b34d458 | SaveButton | DMF0068_DemandManager40.cs:932 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.R… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { "Measure" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ab1b68bd | SaveButton | DMF0068_DemandManager40.cs:933 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.R… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-baaaf5fe | SaveButton | DMF0068_DemandManager40.cs:937 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.R… | MESSAGE | MessageHelper.GMessageBox | ("MSG00084") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-fabc9ba5 | SaveButton | DMF0068_DemandManager40.cs:938 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.R… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a5510ed9 | SaveButton | DMF0068_DemandManager40.cs:940 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.R… | CALL_EXT | Convert.ToInt64 | (strApproval.Split('.')[0]) | ⚠ 의미 확인 필요 |  |  |  |
| AC-8f0d4866 | SaveButton | DMF0068_DemandManager40.cs:940 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.R… | CALL_EXT | Convert.ToInt64 | (strNow.Split('.')[0]) | ⚠ 의미 확인 필요 |  |  |  |
| AC-2e0a4731 | SaveButton | DMF0068_DemandManager40.cs:942 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.R… | MESSAGE | MessageHelper.GMessageBox | ("MSG00084") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9b51093d | SaveButton | DMF0068_DemandManager40.cs:943 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.R… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-29dc002c | SaveButton | DMF0068_DemandManager40.cs:953 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.R… | MESSAGE | MessageHelper.GMessageBox | ("MSG00108") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-74ccaed1 | SaveButton | DMF0068_DemandManager40.cs:954 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.R… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7d118b71 | SaveButton | DMF0068_DemandManager40.cs:959 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.R… | MESSAGE | MessageHelper.GMessageBox | ("MSG00049", new object[] { "" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8377ac2e | SaveButton | DMF0068_DemandManager40.cs:960 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.R… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e642fb8a | SaveButton | DMF0068_DemandManager40.cs:971 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.R… | DATA_OP | dr["PROJECT_CODE"] | strProject | 행/컬럼 값 대입 |  |  |  |
| AC-b4156669 | SaveButton | DMF0068_DemandManager40.cs:972 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.R… | DATA_OP | dr["MEASURE"] | strMeasure | 행/컬럼 값 대입 |  |  |  |
| AC-db8aaa1e | SaveButton | DMF0068_DemandManager40.cs:973 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.R… | DATA_OP | dr["ATTRIBUTE1"] | siMain.Sheet().Cells[i, 0].Text == "M" ? siMain.GetValue(i, siMain.GetColumnIndex("KEYVALU… | 행/컬럼 값 대입 |  |  |  |
| AC-08548e98 | SaveButton | DMF0068_DemandManager40.cs:973 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.R… | CALL_EXT | Guid.NewGuid | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-d6671b68 | SaveButton | DMF0068_DemandManager40.cs:974 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.R… | DATA_OP | dr["YYYYMM_FROM"] | strFrom | 행/컬럼 값 대입 |  |  |  |
| AC-2319acce | SaveButton | DMF0068_DemandManager40.cs:975 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.R… | DATA_OP | dr["YYYYMM_TO"] | strTo | 행/컬럼 값 대입 |  |  |  |
| AC-b0900193 | SaveButton | DMF0068_DemandManager40.cs:976 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.R… | DATA_OP | dr["ORDER_APPROVAL"] | strApproval | 행/컬럼 값 대입 |  |  |  |
| AC-6230e5d7 | SaveButton | DMF0068_DemandManager40.cs:977 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.R… | DATA_OP | dr["ORDER_NOW"] | strNow | 행/컬럼 값 대입 |  |  |  |
| AC-40a0a372 | SaveButton | DMF0068_DemandManager40.cs:979 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.R… | DATA_OP | dr["ATTRIBUTE2"] | siMain.GetValue(i, siMain.GetColumnIndex("KEYVALUE2")) | 행/컬럼 값 대입 |  |  |  |
| AC-bdc3545c | SaveButton | DMF0068_DemandManager40.cs:981 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.R… | DATA_OP | dtProd.Rows.Add | (dr) | 데이터 객체 조작/조회 |  |  |  |
| AC-5ecd52f2 | SaveButton | DMF0068_DemandManager40.cs:985 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.R… | DATA_OP | dtDel.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-b89b94e1 | SaveButton | DMF0068_DemandManager40.cs:986 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.R… | DATA_OP | dr_del["ATTRIBUTE2"] | siMain.GetValue(i, siMain.GetColumnIndex("KEYVALUE2")) | 행/컬럼 값 대입 |  |  |  |
| AC-cfad131e | SaveButton | DMF0068_DemandManager40.cs:987 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.R… | DATA_OP | dtDel.Rows.Add | (dr_del) | 데이터 객체 조작/조회 |  |  |  |
| AC-5dbf8205 | SaveButton | DMF0068_DemandManager40.cs:990 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.R… | DATA_OP | dtProd.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-4aac1816 | SaveButton | DMF0068_DemandManager40.cs:991 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.R… | DATA_OP | dtDel.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-6870f17f | SaveButton | DMF0068_DemandManager40.cs:1004 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.R… | DATA_OP | dtProd.Select("ATTRIBUTE2=''") .AsEnumerable() .GroupBy(r => new { PROJECT_CODE = r.Field<… | (g => { var row = dtProd.NewRow(); row["PROJECT_CODE"] = g.Key.PROJECT_CODE; row["YYYYMM_F… | 데이터 객체 조작/조회 |  |  |  |
| AC-f4552ed3 | SaveButton | DMF0068_DemandManager40.cs:1004 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.R… | CALL_EXT | dtProd.Select("ATTRIBUTE2=''") .AsEnumerable().GroupBy | (r => new { PROJECT_CODE = r.Field<string>("PROJECT_CODE"), YYYYMM_FROM = r.Field<string>(… | ⚠ 의미 확인 필요 |  |  |  |
| AC-28cd9d85 | SaveButton | DMF0068_DemandManager40.cs:1004 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.R… | DATA_OP | dtProd.Select | ("ATTRIBUTE2=''") | 데이터 객체 조작/조회 |  |  |  |
| AC-88e0eff6 | SaveButton | DMF0068_DemandManager40.cs:1008 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.R… | DATA_OP | r.Field | ("PROJECT_CODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-80c2a1ca | SaveButton | DMF0068_DemandManager40.cs:1009 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.R… | DATA_OP | r.Field | ("YYYYMM_FROM") | 데이터 객체 조작/조회 |  |  |  |
| AC-19d7b0b4 | SaveButton | DMF0068_DemandManager40.cs:1010 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.R… | DATA_OP | r.Field | ("YYYYMM_TO") | 데이터 객체 조작/조회 |  |  |  |
| AC-6b9b00d0 | SaveButton | DMF0068_DemandManager40.cs:1015 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.R… | DATA_OP | dtProd.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-46ae114d | SaveButton | DMF0068_DemandManager40.cs:1016 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.R… | DATA_OP | row["PROJECT_CODE"] | g.Key.PROJECT_CODE | 행/컬럼 값 대입 |  |  |  |
| AC-6054979e | SaveButton | DMF0068_DemandManager40.cs:1017 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.R… | DATA_OP | row["YYYYMM_FROM"] | g.Key.YYYYMM_FROM | 행/컬럼 값 대입 |  |  |  |
| AC-501b36f1 | SaveButton | DMF0068_DemandManager40.cs:1018 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.R… | DATA_OP | row["YYYYMM_TO"] | g.Key.YYYYMM_TO | 행/컬럼 값 대입 |  |  |  |
| AC-2fc75259 | SaveButton | DMF0068_DemandManager40.cs:1019 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.R… | RETURN | return row; |  | 처리 중단/반환 |  |  |  |
| AC-dbeb7b14 | SaveButton | DMF0068_DemandManager40.cs:1023 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.R… | MESSAGE | MessageHelper.GMessageBox | ("MSG00113") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-510f14e4 | SaveButton | DMF0068_DemandManager40.cs:1024 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.R… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2df5b870 | SaveButton | DMF0068_DemandManager40.cs:1040 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.R… | CALL_EXT | sql.AddParameter | ("@DMF0068", dtProd) | ⚠ 의미 확인 필요 |  |  |  |
| AC-061a7292 | SaveButton | DMF0068_DemandManager40.cs:1048 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.R… | CALL_EXT | sql.AddParameter | ("@P_USER_ID", UserInfoContext.Current.UserId) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ad511f37 | SaveButton | DMF0068_DemandManager40.cs:1049 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.R… | CALL_EXT | sql.AddParameter | ("@P_DIVISION_ID", "40") | ⚠ 의미 확인 필요 |  |  |  |
| AC-be624272 | SaveButton | DMF0068_DemandManager40.cs:1050 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.R… | CALL_EXT | sql.AddParameter | ("@P_VERSION_NO", txtVersion.Text) | ⚠ 의미 확인 필요 |  |  |  |
| AC-67c5425a | SaveButton | DMF0068_DemandManager40.cs:1057 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.R… | ENDPOINT | sql.ExcuteProcedure | ("SaveDemandManager") ⇒ biz:AppService.GeneralRunProcedureCustomTable [procedure=SaveDemandManager] \| D… | 엔드포인트 호출 |  |  |  |
| AC-2c6fc226 | SaveButton | DMF0068_DemandManager40.cs:1064 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.R… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { "ADD / MODIFY : " + result.Rows[0]["result_cnt"].ToString() }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a79daa55 | SaveButton | DMF0068_DemandManager40.cs:1065 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.R… | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-4e912222 | SaveButton | DMF0068_DemandManager40.cs:1070 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.R… | MESSAGE | MessageHelper.GMessageBox | ("MSG00105") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-1d444a71 | SaveButton | DMF0068_DemandManager40.cs:1071 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.R… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9d8af9bc | SaveButton | DMF0068_DemandManager40.cs:1076 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.R… | MESSAGE | MessageHelper.GMessageBox | ("MSG00260") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d23725d6 | SaveButton | DMF0068_DemandManager40.cs:1077 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.R… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9e3e33da | SaveButton | DMF0068_DemandManager40.cs:1100 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.R… | CALL_EXT | sql.AddParameter | ("@DMF0068", dtDel) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ad21f250 | SaveButton | DMF0068_DemandManager40.cs:1107 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.R… | ENDPOINT | sql.ExcuteProcedure | ("DelDemandManager") ⇒ biz:AppService.GeneralRunProcedureCustomTable [procedure=DelDemandManager] \| DM… | 엔드포인트 호출 |  |  |  |
| AC-15ee7571 | SaveButton | DMF0068_DemandManager40.cs:1115 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.R… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { "DELETE : " + result.Rows[0]["result_cnt"].ToString() }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-5b0c9962 | SaveButton | DMF0068_DemandManager40.cs:1116 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.R… | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-38c916ea | SaveButton | DMF0068_DemandManager40.cs:1121 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.R… | MESSAGE | MessageHelper.GMessageBox | ("MSG00284", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6db9a8dd | SaveButton | DMF0068_DemandManager40.cs:1135 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-f2eb4218 | SaveButton | DMF0068_DemandManager40.cs:1136 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message, ex.Source, MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-467a1c3a | SaveButton | DMF0068_DemandManager40.cs:1140 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## DMF0068_DemandManager40.SetSpreadHeaderSpan

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6f071693 | (진입점 미연결) | DMF0068_DemandManager40.cs:356 | foreach (DataRow dr in dt.Rows) ▸ if (iCellCnt <= iSmallStartCol) | GRID_INIT | siMain.ColumnHeaderSpan | (0, iCellCnt, 2, 1, 30, sColumnLabel, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c333e76c | (진입점 미연결) | DMF0068_DemandManager40.cs:364 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (dr[DefColumns.ColumnName].ToString().IndexOf("B_") > 0) | GRID_INIT | siMain.VisibleColumns | (iCellCnt, false) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-8ffcd755 | (진입점 미연결) | DMF0068_DemandManager40.cs:376 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | siMain.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-859e5eda | (진입점 미연결) | DMF0068_DemandManager40.cs:377 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | siMain.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-96b0085b | (진입점 미연결) | DMF0068_DemandManager40.cs:382 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | siMain.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-98d80c5d | (진입점 미연결) | DMF0068_DemandManager40.cs:390 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName !=… | GRID_INIT | siMain.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9b4c30e3 | (진입점 미연결) | DMF0068_DemandManager40.cs:402 |  | GRID_INIT | siMain.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3ad604df | (진입점 미연결) | DMF0068_DemandManager40.cs:404 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2b73ef10 | (진입점 미연결) | DMF0068_DemandManager40.cs:405 |  | GRID_INIT | siMain.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0c909954 | (진입점 미연결) | DMF0068_DemandManager40.cs:407 |  | GRID_INIT | siMain.Freeze | (0, siMain.GetColumnIndex(DefColumns.EDIT_FLAG)) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-f030cfdb | (진입점 미연결) | DMF0068_DemandManager40.cs:409 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DMF0068_DemandManager40.SetSpreadMonth

진입점: this.Load / FindButton / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ if (bolReload)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-026a529b | this.Load 외 2 | DMF0068_DemandManager40.cs:271 | for (i <= 154) | GRID_SET | spdInfo.ActiveSheet.Columns[i].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-8e9286bf | this.Load 외 2 | DMF0068_DemandManager40.cs:283 | for (i <= 11 + intMonCnt) | GRID_SET | spdInfo.ActiveSheet.Columns[i].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-7ff52276 | this.Load 외 2 | DMF0068_DemandManager40.cs:285 | for (i <= 11 + intMonCnt) | GRID_SET | siMain.Sheet().ColumnHeader.Cells[1, i].Text | dt.AddMonths(intAddMonth).ToString("yyyy.MM") | 그리드 속성/값 설정 |  |  |  |
| AC-e6f76c11 | this.Load 외 2 | DMF0068_DemandManager40.cs:293 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, 11, 1, intMonCnt + 1, 20, "수주 기간 매출 상세", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |

## DMF0068_VersionPopup.btnButtonList_UsrButtonList_Click_Detected

진입점: this.btnButtonList.UsrButtonList_Click_Detected

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-71d0cab8 | this.btnButtonList.UsrButtonList_Click_Detected | DMF0068_VersionPopup.cs:293 | switch (buttonItem.UserType) case ButtonListType.OK: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-b2af1ba0 | this.btnButtonList.UsrButtonList_Click_Detected | DMF0068_VersionPopup.cs:296 | switch (buttonItem.UserType) case ButtonListType.Close: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## DMF0068_VersionPopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8b0374ad | this.Load | DMF0068_VersionPopup.cs:140 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-e5519600 | this.Load | DMF0068_VersionPopup.cs:141 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-82cd6758 | this.Load | DMF0068_VersionPopup.cs:142 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DMF0068_VersionPopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4f4ebda3 | this.Load | DMF0068_VersionPopup.cs:132 |  | UI_PROP | usrConditionPanel1.Height | 70 | 속성 Height 설정 |  |  |  |
| AC-7178376e | this.Load | DMF0068_VersionPopup.cs:135 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## DMF0068_VersionPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ed639136 | Dispose | DMF0068_VersionPopup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## DMF0068_VersionPopup.FindData

진입점: this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter)] / this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find:] / this.Load / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-202c6eaf | this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.K… 외 3 | DMF0068_VersionPopup.cs:245 |  | ENDPOINT | new FoxDataRequest | ("DM.DMF0068_GET_CONT_VIEW_VERSIONPOPUP") ⇒ DM.DMF0068_GET_CONT_VIEW_VERSIONPOPUP | 엔드포인트 요청 생성 |  |  |  |
| AC-7eaad5f9 | this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.K… 외 3 | DMF0068_VersionPopup.cs:250 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | sStartDate | 행/컬럼 값 대입 |  |  |  |
| AC-b0c0758b | this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.K… 외 3 | DMF0068_VersionPopup.cs:251 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | sEndDate | 행/컬럼 값 대입 |  |  |  |
| AC-567440a7 | this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.K… 외 3 | DMF0068_VersionPopup.cs:253 |  | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-ae485829 | this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.K… 외 3 | DMF0068_VersionPopup.cs:254 |  | DATA_OP | request.Parameters["p_version_type"] | clbType.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-60968334 | this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.K… 외 3 | DMF0068_VersionPopup.cs:255 |  | DATA_OP | request.Parameters["p_description"] | txtDes.Text | 행/컬럼 값 대입 |  |  |  |
| AC-60ee2b8d | this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.K… 외 3 | DMF0068_VersionPopup.cs:258 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-132856ee | this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.K… 외 3 | DMF0068_VersionPopup.cs:262 |  | GRID_BIND | siMain.Query | (result) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-81d65b0a | this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.K… 외 3 | DMF0068_VersionPopup.cs:263 |  | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-9011f7ca | this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.K… 외 3 | DMF0068_VersionPopup.cs:270 |  | FLAG | dtFindData | result.Tables[0] | 화면 필드/플래그 변경 |  |  |  |

## DMF0068_VersionPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-52bda242 | this.Load | DMF0068_VersionPopup.cs:96 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-ec039d51 | this.Load | DMF0068_VersionPopup.cs:97 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-557fc41e | this.Load | DMF0068_VersionPopup.cs:106 |  | FLAG | bMulltiSelect | _bMultiSelect | 화면 필드/플래그 변경 |  |  |  |
| AC-169e556f | this.Load | DMF0068_VersionPopup.cs:107 |  | FLAG | sDivision | _DivisionID | 화면 필드/플래그 변경 |  |  |  |
| AC-ece9f541 | this.Load | DMF0068_VersionPopup.cs:108 |  | VALUE_SET | drpPeriod.InitValue | sStartDate + ":" + sEndDate | 컨트롤 값 설정 |  |  |  |

## DMF0068_VersionPopup.GetLookupData

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-36f983cd | this.Load | DMF0068_VersionPopup.cs:377 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_LOOKUP_VALUES") ⇒ SCM.SCM0001_GET_LOOKUP_VALUES | 엔드포인트 요청 생성 |  |  |  |
| AC-15978ea7 | this.Load | DMF0068_VersionPopup.cs:378 |  | DATA_OP | request.Parameters["p_lookup_type"] | strType | 행/컬럼 값 대입 |  |  |  |
| AC-88384aed | this.Load | DMF0068_VersionPopup.cs:379 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a40c9608 | this.Load | DMF0068_VersionPopup.cs:381 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0068_VersionPopup.GetSpdTitle

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7040a20d | (진입점 미연결) | DMF0068_VersionPopup.cs:319 |  | ENDPOINT | new FoxDataRequest | ("DM_H.DM0000_GET_COMMON_SPREAD_TITLE") ⇒ DM_H.DM0000_GET_COMMON_SPREAD_TITLE | 엔드포인트 요청 생성 |  |  |  |
| AC-de908800 | (진입점 미연결) | DMF0068_VersionPopup.cs:320 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-335ad974 | (진입점 미연결) | DMF0068_VersionPopup.cs:321 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-d8797c65 | (진입점 미연결) | DMF0068_VersionPopup.cs:322 |  | DATA_OP | request.Parameters["p_created_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-129e9bef | (진입점 미연결) | DMF0068_VersionPopup.cs:323 |  | DATA_OP | request.Parameters["p_program_id"] | "SCM0002" | 행/컬럼 값 대입 |  |  |  |
| AC-3822ac37 | (진입점 미연결) | DMF0068_VersionPopup.cs:324 |  | DATA_OP | request.Parameters["p_sheet_name"] | "VersionPopup" | 행/컬럼 값 대입 |  |  |  |
| AC-80bcea51 | (진입점 미연결) | DMF0068_VersionPopup.cs:326 |  | FLAG | dsSpdTitle | client.ExecuteDataSet(request).DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-a22736a8 | (진입점 미연결) | DMF0068_VersionPopup.cs:326 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-91f8491e | (진입점 미연결) | DMF0068_VersionPopup.cs:329 |  | RETURN | return dsSpdTitle.Tables[0]; |  | 처리 중단/반환 |  |  |  |

## DMF0068_VersionPopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-da87cc65 | this.Load | DMF0068_VersionPopup.cs:116 |  | FLAG | dtDivision | Data.Common(Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoCo… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 화면 필드/플래그 변경 |  |  |  |
| AC-c5cef531 | this.Load | DMF0068_VersionPopup.cs:116 |  | COMBO_DATA | Data.Common | (Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoContext.Curre… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-616c7554 | this.Load | DMF0068_VersionPopup.cs:117 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, clbDivision, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-c79df989 | this.Load | DMF0068_VersionPopup.cs:119 |  | VALUE_SET | clbDivision.ControlValues | sDivision | 컨트롤 값 설정 |  |  |  |
| AC-0e43bec8 | this.Load | DMF0068_VersionPopup.cs:128 |  | LIST_REBIND | clsCtrl.setListBox | (dtLook, clbType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## DMF0068_VersionPopup.InitSpread_X

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-20e908a0 | this.Load | DMF0068_VersionPopup.cs:158 |  | GRID_INIT | siMain.InitSheet | (siMain.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-ab6a5ae0 | this.Load | DMF0068_VersionPopup.cs:160 |  | GRID_INIT | siMain.AddActionTextBox | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-3d7fcdb7 | this.Load | DMF0068_VersionPopup.cs:161 |  | GRID_INIT | siMain.AddTextColumn | ("Divison", DefColumns.DIVISION_ID, FPMerge.None, 60, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ddabc121 | this.Load | DMF0068_VersionPopup.cs:162 |  | GRID_INIT | siMain.AddTextColumn | ("Version", DefColumns.VERSION_NO, FPMerge.None, 220, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7820862b | this.Load | DMF0068_VersionPopup.cs:163 |  | GRID_INIT | siMain.AddTextColumn | ("Description", DefColumns.VERSION_DESCRIPTION, FPMerge.None, 300, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-97aa03ed | this.Load | DMF0068_VersionPopup.cs:164 |  | GRID_INIT | siMain.AddTextColumn | ("Type", DefColumns.VERSION_TYPE, FPMerge.None, 100, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-bacb5806 | this.Load | DMF0068_VersionPopup.cs:165 |  | GRID_INIT | siMain.AddTextColumn | ("Seq", DefColumns.VER_CRE_SEQ, FPMerge.None, 60, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-646eeecb | this.Load | DMF0068_VersionPopup.cs:166 |  | GRID_INIT | siMain.AddTextColumn | ("Date", DefColumns.YYYYMMDD, FPMerge.None, 60, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-602dabd0 | this.Load | DMF0068_VersionPopup.cs:167 |  | GRID_INIT | siMain.AddTextColumn | ("Create By", DefColumns.CREATED_BY, FPMerge.None, 100, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-49fd6790 | this.Load | DMF0068_VersionPopup.cs:168 |  | GRID_INIT | siMain.AddTextColumn | ("Create Date", DefColumns.CREATION_DATE, FPMerge.None, 150, true, FPHAlign.Center, FPVAli… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-acf8c2c6 | this.Load | DMF0068_VersionPopup.cs:170 |  | GRID_INIT | siMain.Freeze | (0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-0a266a00 | this.Load | DMF0068_VersionPopup.cs:172 |  | STATE | txtDes.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-4fcec1e0 | this.Load | DMF0068_VersionPopup.cs:173 |  | VALUE_CLEAR | txtDes.Text | "" | 컨트롤 값 비움 |  |  |  |

## DMF0068_VersionPopup.SetItem

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.OK:] / this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-73fb6567 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0068_VersionPopup.cs:341 | if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ if (cr.RowCount > 1) | MESSAGE | MessageHelper.GMessageBox | ("MSG00279") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-7127a741 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0068_VersionPopup.cs:342 | if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ if (cr.RowCount > 1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a3cab136 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0068_VersionPopup.cs:348 | if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr.RowCount) ▸ if (sVer… | FLAG | sVersions | siMain.GetText(iRow, siMain.GetColumnIndex(DefColumns.VERSION_NO)) | 화면 필드/플래그 변경 |  |  |  |
| AC-fd0815c4 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0068_VersionPopup.cs:354 | if (cellRange.LongLength > 0) | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-0f2f73f7 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0068_VersionPopup.cs:358 | else of (cellRange.LongLength > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00279") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-2d4e415f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0068_VersionPopup.cs:359 | else of (cellRange.LongLength > 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## DMF0068_VersionPopup.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a7974160 | this.spdMain.CellDoubleClick | DMF0068_VersionPopup.cs:310 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

