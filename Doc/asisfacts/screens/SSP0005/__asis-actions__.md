# AS-IS 액션 대조표 — SSP0005

> 원천: `Doc/asisfacts/screens/SSP0005/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 149행 · 메서드 19 · 종류 DATA_OP 37 · RETURN 18 · GRID_INIT 13 · GRID_SET 11 · UI_PROP 9 · ENDPOINT 9 · UI_MISC 8 · MESSAGE 7 · CALL_EXT 6 · LIST_REBIND 5 · FLAG 5 · POPUP 4 · GRID_LOCK 3 · VALIDATE 3 · STATE 2 · VALUE_CLEAR 2 · STATE_RESET 2 · FOCUS 1 · GRID_BIND 1 · VALUE_SET 1 · COMBO_DATA 1 · THROW 1 · ⚠ 의미 확인 필요 6


## SSP0005_ShipmentWorkingDay.BtnInput_Click

진입점: btnInput.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-04683230 | btnInput.Click | SSP0005_ShipmentWorkingDay.cs:673 |  | CALL_EXT | siMain.ActiveSheet.Columns.Get | (0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-88c59c78 | btnInput.Click | SSP0005_ShipmentWorkingDay.cs:676 | if (siMain.ActiveSheet.Columns.Get(0).Visible == false) | MESSAGE | MessageHelper.GMessageBox | ("MSG00135", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-87f40917 | btnInput.Click | SSP0005_ShipmentWorkingDay.cs:677 | if (siMain.ActiveSheet.Columns.Get(0).Visible == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-90fa583e | btnInput.Click | SSP0005_ShipmentWorkingDay.cs:681 | if (!this.CanModelChange) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-89f27c0d | btnInput.Click | SSP0005_ShipmentWorkingDay.cs:688 | if (cboInputValue.SelectedValue == null) | MESSAGE | MessageHelper.GMessageBox | ("MSG00093", new object[] { arg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-5a84c1ed | btnInput.Click | SSP0005_ShipmentWorkingDay.cs:689 | if (cboInputValue.SelectedValue == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-bd3c943f | btnInput.Click | SSP0005_ShipmentWorkingDay.cs:699 | if (pDayWeekCode == "SelectDay") ▸ if (selCells.Length < 1) | MESSAGE | MessageHelper.GMessageBox | ("MSG00134", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-740d6f0a | btnInput.Click | SSP0005_ShipmentWorkingDay.cs:700 | if (pDayWeekCode == "SelectDay") ▸ if (selCells.Length < 1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d8d52ff9 | btnInput.Click | SSP0005_ShipmentWorkingDay.cs:705 | if (string.IsNullOrEmpty(pDayWeekCode)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-29c5143e | btnInput.Click | SSP0005_ShipmentWorkingDay.cs:714 | catch ((FormatException fe)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00050", new object[] { strValue }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-7a12e14b | btnInput.Click | SSP0005_ShipmentWorkingDay.cs:715 | catch ((FormatException fe)) | FOCUS | cboInputValue.Focus | () | 포커스 이동 |  |  |  |
| AC-abf0be6e | btnInput.Click | SSP0005_ShipmentWorkingDay.cs:716 | catch ((FormatException fe)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-66e9ac47 | btnInput.Click | SSP0005_ShipmentWorkingDay.cs:720 | if (!this.CanModelChange) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-34e0efc9 | btnInput.Click | SSP0005_ShipmentWorkingDay.cs:730 | if (ds == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3300fd73 | btnInput.Click | SSP0005_ShipmentWorkingDay.cs:742 | if (pDayWeekCode == "SelectDay") ▸ foreach (CellRange range in selCells) | CALL_EXT | spdMain.ActiveSheet.GetModelColumnFromViewColumn | (row) | ⚠ 의미 확인 필요 |  |  |  |
| AC-5042acab | btnInput.Click | SSP0005_ShipmentWorkingDay.cs:743 | if (pDayWeekCode == "SelectDay") ▸ foreach (CellRange range in selCells) | CALL_EXT | spdMain.ActiveSheet.GetModelColumnFromViewColumn | (col) | ⚠ 의미 확인 필요 |  |  |  |
| AC-1880da6a | btnInput.Click | SSP0005_ShipmentWorkingDay.cs:752 | if (pDayWeekCode == "SelectDay") ▸ foreach (CellRange range in selCells) ▸ if (row >= 0 && col < 0) ▸ for (i < row + rowCnt) ▸ for (j < siMa… | GRID_SET | siMain.ActiveSheet.SetText | (i, j, strValue) | 그리드 값 설정 |  |  |  |
| AC-4fccb142 | btnInput.Click | SSP0005_ShipmentWorkingDay.cs:766 | if (pDayWeekCode == "SelectDay") ▸ foreach (CellRange range in selCells) ▸ else of (row >= 0 && col < 0) ▸ if (row < 0 && col >= 0) ▸ for (i… | GRID_SET | siMain.ActiveSheet.SetText | (i, j, strValue) | 그리드 값 설정 |  |  |  |
| AC-29bbe176 | btnInput.Click | SSP0005_ShipmentWorkingDay.cs:780 | if (pDayWeekCode == "SelectDay") ▸ foreach (CellRange range in selCells) ▸ else of (row >= 0 && col < 0) ▸ else of (row < 0 && col >= 0) ▸ i… | GRID_SET | siMain.ActiveSheet.SetText | (i, j, strValue) | 그리드 값 설정 |  |  |  |
| AC-c37228fb | btnInput.Click | SSP0005_ShipmentWorkingDay.cs:802 | else of (pDayWeekCode == "SelectDay") ▸ for (i < siMain.ActiveSheet.Rows.Count) ▸ for (j < siMain.ActiveSheet.Columns.Count) ▸ if (siMain.Ac… | GRID_SET | siMain.ActiveSheet.SetText | (i, j, strValue) | 그리드 값 설정 |  |  |  |
| AC-33962331 | btnInput.Click | SSP0005_ShipmentWorkingDay.cs:810 | else of (pDayWeekCode == "SelectDay") ▸ for (i < siMain.ActiveSheet.Rows.Count) ▸ for (j < siMain.ActiveSheet.Columns.Count) ▸ if (siMain.Ac… | GRID_SET | siMain.ActiveSheet.SetText | (i, j, strValue) | 그리드 값 설정 |  |  |  |
| AC-2ef08170 | btnInput.Click | SSP0005_ShipmentWorkingDay.cs:820 |  | DATA_OP | dt.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |

## SSP0005_ShipmentWorkingDay.CboDayWeek_SelectedIndexChanged

진입점: cboDayWeek.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-15d80e30 | cboDayWeek.SelectedIndexChanged | SSP0005_ShipmentWorkingDay.cs:663 | if (string.IsNullOrEmpty(pDayWeek)) | STATE | cboInputValue.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-813ec2dd | cboDayWeek.SelectedIndexChanged | SSP0005_ShipmentWorkingDay.cs:666 | else of (string.IsNullOrEmpty(pDayWeek)) | STATE | cboInputValue.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-6203325d | cboDayWeek.SelectedIndexChanged | SSP0005_ShipmentWorkingDay.cs:669 |  | VALUE_CLEAR | cboInputValue.SelectedValue | "" | 컨트롤 값 비움 |  |  |  |

## SSP0005_ShipmentWorkingDay.ClearUsrCheckedList

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8bc4486d | (진입점 미연결) | SSP0005_ShipmentWorkingDay.cs:152 | if (dt != null) | STATE_RESET | dt.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-97435335 | (진입점 미연결) | SSP0005_ShipmentWorkingDay.cs:153 | if (dt != null) | LIST_REBIND | clsCtrl.setListBox | (dt, control, true) | 목록 컨트롤 재구성 |  |  |  |

## SSP0005_ShipmentWorkingDay.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c0873744 | this.Load | SSP0005_ShipmentWorkingDay.cs:179 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 3, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-670ae7ea | this.Load | SSP0005_ShipmentWorkingDay.cs:180 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, 0) | 화면 필드/플래그 변경 |  |  |  |
| AC-218b7407 | this.Load | SSP0005_ShipmentWorkingDay.cs:182 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SSP0005_ShipmentWorkingDay.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b3ffde64 | Dispose | SSP0005_ShipmentWorkingDay.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SSP0005_ShipmentWorkingDay.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2935b162 | EditButton | SSP0005_ShipmentWorkingDay.cs:352 | if (fps != null) ▸ if (fps.Name == "spdMain") | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-d56d940b | EditButton | SSP0005_ShipmentWorkingDay.cs:353 | if (fps != null) ▸ if (fps.Name == "spdMain") | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-825c7f5d | EditButton | SSP0005_ShipmentWorkingDay.cs:355 | if (fps != null) ▸ if (fps.Name == "spdMain") | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.COMPANY), siMain.GetColumnIndex(DefColumns.DIVISION), tr… | 그리드 편집 잠금/해제 |  |  |  |

## SSP0005_ShipmentWorkingDay.FindData_Main

진입점: FindButton / SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (t.Success)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c182f2d2 | FindButton 외 1 | SSP0005_ShipmentWorkingDay.cs:372 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-fa5b519a | FindButton 외 1 | SSP0005_ShipmentWorkingDay.cs:377 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-2fa8c10e | FindButton 외 1 | SSP0005_ShipmentWorkingDay.cs:377 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b8b5ace6 | FindButton 외 1 | SSP0005_ShipmentWorkingDay.cs:381 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-72c8f000 | FindButton 외 1 | SSP0005_ShipmentWorkingDay.cs:398 | try | UI_PROP | proxyPivot.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-786759e7 | FindButton 외 1 | SSP0005_ShipmentWorkingDay.cs:399 | try | ENDPOINT | proxyPivot.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, "GSCM.SSP.Plan.… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a21de942 | FindButton 외 1 | SSP0005_ShipmentWorkingDay.cs:403 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SSP.SSP0005_GET_SHIPMENT_WORKING_DAY") ⇒ SSP.SSP0005_GET_SHIPMENT_WORKING_DAY | 엔드포인트 요청 생성 |  |  |  |
| AC-4a7dfb8b | FindButton 외 1 | SSP0005_ShipmentWorkingDay.cs:404 | try ▸ lambda | UI_PROP | req.CommandTimeout | 60 * 10 | 속성 CommandTimeout 설정 |  |  |  |
| AC-0b9fec23 | FindButton 외 1 | SSP0005_ShipmentWorkingDay.cs:405 | try ▸ lambda | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-674f31f4 | FindButton 외 1 | SSP0005_ShipmentWorkingDay.cs:406 | try ▸ lambda | DATA_OP | req.Parameters["p_company_id"] | p_company_id | 행/컬럼 값 대입 |  |  |  |
| AC-2784ec7c | FindButton 외 1 | SSP0005_ShipmentWorkingDay.cs:407 | try ▸ lambda | DATA_OP | req.Parameters["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-aa6e40d2 | FindButton 외 1 | SSP0005_ShipmentWorkingDay.cs:408 | try ▸ lambda | DATA_OP | req.Parameters["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-c7eb1760 | FindButton 외 1 | SSP0005_ShipmentWorkingDay.cs:409 | try ▸ lambda | DATA_OP | req.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-a6187a38 | FindButton 외 1 | SSP0005_ShipmentWorkingDay.cs:410 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-4860d5e2 | FindButton 외 1 | SSP0005_ShipmentWorkingDay.cs:411 | try ▸ lambda | RETURN | return res.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-f5c4df7a | FindButton 외 1 | SSP0005_ShipmentWorkingDay.cs:418 | try | GRID_BIND | siMain.Query | (dsBinding) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-7ad2bc4a | FindButton 외 1 | SSP0005_ShipmentWorkingDay.cs:420 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-1e5049a9 | FindButton 외 1 | SSP0005_ShipmentWorkingDay.cs:422 | try | UI_MISC | SetSearchCount | (dsBinding) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-b787971c | FindButton 외 1 | SSP0005_ShipmentWorkingDay.cs:424 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2c5a8d63 | FindButton 외 1 | SSP0005_ShipmentWorkingDay.cs:432 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SSP0005_ShipmentWorkingDay.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-490e3382 | this.Load | SSP0005_ShipmentWorkingDay.cs:129 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SSP0005_ShipmentWorkingDay.GetDayOfWeek

진입점: btnInput.Click [else of (pDayWeekCode == "SelectDay") ▸ for (i < siMain.ActiveSheet.Rows.Count) ▸ for (j < siMain.ActiveSheet.Columns.Count) ▸ if (siMain.ActiveSheet.Columns[j].Tag.ToString().IndexOf("D_") == 0) ▸ else of (pDayWeekCode == "EveryDay")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9ef5cf2d | btnInput.Click [else of (pDayWeekCode == "SelectDay") ▸ for … | SSP0005_ShipmentWorkingDay.cs:827 |  | DATA_OP | dt.Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-58b7f89a | btnInput.Click [else of (pDayWeekCode == "SelectDay") ▸ for … | SSP0005_ShipmentWorkingDay.cs:827 | lambda | DATA_OP | row.Field | ("COLUMN_NAME") | 데이터 객체 조작/조회 |  |  |  |
| AC-89b4fa71 | btnInput.Click [else of (pDayWeekCode == "SelectDay") ▸ for … | SSP0005_ShipmentWorkingDay.cs:829 |  | RETURN | return returnDay; |  | 처리 중단/반환 |  |  |  |

## SSP0005_ShipmentWorkingDay.GetDayRange

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-015f6dd0 | this.Load | SSP0005_ShipmentWorkingDay.cs:941 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCM0001_GET_SCP_PERIOD") ⇒ SCP.SCM0001_GET_SCP_PERIOD | 엔드포인트 요청 생성 |  |  |  |
| AC-852e2b0f | this.Load | SSP0005_ShipmentWorkingDay.cs:942 |  | DATA_OP | request.Parameters["p_from_date"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-11099d08 | this.Load | SSP0005_ShipmentWorkingDay.cs:943 |  | DATA_OP | request.Parameters["p_offset_month"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-f0e3a6e0 | this.Load | SSP0005_ShipmentWorkingDay.cs:944 |  | DATA_OP | request.Parameters["p_timezone"] | UserInfoContext.Current[UserInfoProperites.TimeZone] | 행/컬럼 값 대입 |  |  |  |
| AC-5131ac36 | this.Load | SSP0005_ShipmentWorkingDay.cs:945 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-bf2358c0 | this.Load | SSP0005_ShipmentWorkingDay.cs:948 |  | RETURN | return sDayRange; |  | 처리 중단/반환 |  |  |  |

## SSP0005_ShipmentWorkingDay.GetSpdTitle

진입점: this.Load / FindButton [try] / SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (t.Success) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d3766c42 | this.Load 외 2 | SSP0005_ShipmentWorkingDay.cs:925 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN") ⇒ SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | 엔드포인트 요청 생성 |  |  |  |
| AC-6f5a53d6 | this.Load 외 2 | SSP0005_ShipmentWorkingDay.cs:930 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | drpPeriod.Text1.Replace("-", "") | 행/컬럼 값 대입 |  |  |  |
| AC-2eb00552 | this.Load 외 2 | SSP0005_ShipmentWorkingDay.cs:931 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | drpPeriod.Text2.Replace("-", "") | 행/컬럼 값 대입 |  |  |  |
| AC-0767ba2d | this.Load 외 2 | SSP0005_ShipmentWorkingDay.cs:933 |  | FLAG | dsSpdTitle | client.ExecuteDataSet(request).DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-c7094c72 | this.Load 외 2 | SSP0005_ShipmentWorkingDay.cs:933 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## SSP0005_ShipmentWorkingDay.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a74a7853 | this.Load | SSP0005_ShipmentWorkingDay.cs:159 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-55080188 | this.Load | SSP0005_ShipmentWorkingDay.cs:162 | if (dtMyDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |
| AC-38390f6c | this.Load | SSP0005_ShipmentWorkingDay.cs:164 |  | LIST_REBIND | clsCtrl.setListBox | (dtMyDivision, clbDivision, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-3ec2f87a | this.Load | SSP0005_ShipmentWorkingDay.cs:166 |  | LIST_REBIND | clsCtrl.setListBox | (dtCompany, cboCompany, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-152ab3a6 | this.Load | SSP0005_ShipmentWorkingDay.cs:168 |  | LIST_REBIND | cboInputValue.DataBind | (Data.Type.YesOrNo, false) ⇒ biz:CommonData.YesOrNo | 목록 컨트롤 재구성 |  |  |  |
| AC-1e10b548 | this.Load | SSP0005_ShipmentWorkingDay.cs:170 |  | VALUE_SET | drpPeriod.InitValue | GetDayRange() | 컨트롤 값 설정 |  |  |  |
| AC-ff9b7d24 | this.Load | SSP0005_ShipmentWorkingDay.cs:172 |  | LIST_REBIND | clsCtrl.setListBox | (dtDayWeek, cboDayWeek, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-884d171c | this.Load | SSP0005_ShipmentWorkingDay.cs:174 |  | VALUE_CLEAR | cboInputValue.SelectedValue | "" | 컨트롤 값 비움 |  |  |  |

## SSP0005_ShipmentWorkingDay.InitSpread

진입점: this.Load / FindButton [try] / SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (t.Success) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ef923522 | this.Load 외 2 | SSP0005_ShipmentWorkingDay.cs:194 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.InitSheet | (SpdSheet.shtMain) | 그리드 재구성/초기화 |  |  |  |
| AC-d2f138cb | this.Load 외 2 | SSP0005_ShipmentWorkingDay.cs:196 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.SetSheetHeaderColumn | (spdInfo, 3) | 그리드 재구성/초기화 |  |  |  |
| AC-57d0301c | this.Load 외 2 | SSP0005_ShipmentWorkingDay.cs:201 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SSP0005_ShipmentWorkingDay.InitSpreadDateColumn

진입점: this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] / FindButton [try ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (t.Success) ▸ try ▸ if (spdInfo.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-25feaf7a | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 2 | SSP0005_ShipmentWorkingDay.cs:263 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sColumnName.IndexOf("B_") > 0) | GRID_INIT | spdInfo.AddComboColumn | (sColumnLabelname, sColumnName, FPMerge.None, 70, true, dtYesOrNo, FPHAlign.Center, FPVAli… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ecd66364 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 2 | SSP0005_ShipmentWorkingDay.cs:267 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sColumnName.IndexOf("B_") > 0) ▸ if (sDayCode == DefColumnsLabel.Saturday \|\| … | GRID_SET | spdInfo.Sheet().ColumnHeader.Cells[2, spdInfo.GetMaxColumnIndex()].ForeColor | sDayCode == DefColumnsLabel.Saturday ? Color.Blue : Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-258fecd2 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 2 | SSP0005_ShipmentWorkingDay.cs:274 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-83dc82ff | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 2 | SSP0005_ShipmentWorkingDay.cs:280 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c5e3e02c | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 2 | SSP0005_ShipmentWorkingDay.cs:290 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName != sSmallLabelName && i… | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-09b83e18 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 2 | SSP0005_ShipmentWorkingDay.cs:301 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5eab795b | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 2 | SSP0005_ShipmentWorkingDay.cs:303 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |

## SSP0005_ShipmentWorkingDay.SaveData_Main

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4405409f | SaveButton | SSP0005_ShipmentWorkingDay.cs:438 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-a3983496 | SaveButton | SSP0005_ShipmentWorkingDay.cs:446 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (siMain.ActiveSheet.Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-433d7a47 | SaveButton | SSP0005_ShipmentWorkingDay.cs:449 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (saveDS != null) | STATE_RESET | saveDS.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-ca766e23 | SaveButton | SSP0005_ShipmentWorkingDay.cs:451 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-75000a13 | SaveButton | SSP0005_ShipmentWorkingDay.cs:456 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | VALIDATE | DataUtil.checkRequiredOfSpread | (siMain) | 프레임워크 검증 |  |  |  |
| AC-3bd9c8f5 | SaveButton | SSP0005_ShipmentWorkingDay.cs:456 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (!DataUtil.checkRequiredOfSpread(siM… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-82c37553 | SaveButton | SSP0005_ShipmentWorkingDay.cs:460 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | FLAG | saveDS | new DataSet() | 화면 필드/플래그 변경 |  |  |  |
| AC-b7fec9a6 | SaveButton | SSP0005_ShipmentWorkingDay.cs:462 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("A", typeof(char)) | 데이터 객체 조작/조회 |  |  |  |
| AC-a7003786 | SaveButton | SSP0005_ShipmentWorkingDay.cs:463 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | (DefColumns.P_ACTIVE_FLAG) | 데이터 객체 조작/조회 |  |  |  |
| AC-6dfdc1c3 | SaveButton | SSP0005_ShipmentWorkingDay.cs:464 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | (DefColumns.P_DIVISION_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-d901fb44 | SaveButton | SSP0005_ShipmentWorkingDay.cs:465 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | (DefColumns.P_COMPANY_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-fb7b58c3 | SaveButton | SSP0005_ShipmentWorkingDay.cs:466 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | (DefColumns.P_YYYYMMDD) | 데이터 객체 조작/조회 |  |  |  |
| AC-253d7e27 | SaveButton | SSP0005_ShipmentWorkingDay.cs:467 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | (DefColumns.P_WORKDAY_YN) | 데이터 객체 조작/조회 |  |  |  |
| AC-b5c4cd05 | SaveButton | SSP0005_ShipmentWorkingDay.cs:468 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | (DefColumns.P_LAST_UPDATED_BY) | 데이터 객체 조작/조회 |  |  |  |
| AC-092938d2 | SaveButton | SSP0005_ShipmentWorkingDay.cs:469 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | (DefColumns.P_TIME_ZONE) | 데이터 객체 조작/조회 |  |  |  |
| AC-c5776cb7 | SaveButton | SSP0005_ShipmentWorkingDay.cs:470 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | (DefColumns.DEBUG_MODE) | 데이터 객체 조작/조회 |  |  |  |
| AC-3c6e0c5f | SaveButton | SSP0005_ShipmentWorkingDay.cs:471 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | (DefColumns.P_FIRST_ROW) | 데이터 객체 조작/조회 |  |  |  |
| AC-f60bb1e0 | SaveButton | SSP0005_ShipmentWorkingDay.cs:472 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | (DefColumns.P_LAST_ROW) | 데이터 객체 조작/조회 |  |  |  |
| AC-ceb50260 | SaveButton | SSP0005_ShipmentWorkingDay.cs:474 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | saveDS.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-c4497eac | SaveButton | SSP0005_ShipmentWorkingDay.cs:500 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i < siMain.ActiveSheet.RowCount) ▸… | DATA_OP | saveDS.Tables[0].NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-7713fe11 | SaveButton | SSP0005_ShipmentWorkingDay.cs:502 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i < siMain.ActiveSheet.RowCount) ▸… | DATA_OP | dr["A"] | action | 행/컬럼 값 대입 |  |  |  |
| AC-c58b8365 | SaveButton | SSP0005_ShipmentWorkingDay.cs:503 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i < siMain.ActiveSheet.RowCount) ▸… | DATA_OP | dr[DefColumns.P_DIVISION_ID] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.DIVISION)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-fa9336d8 | SaveButton | SSP0005_ShipmentWorkingDay.cs:504 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i < siMain.ActiveSheet.RowCount) ▸… | DATA_OP | dr[DefColumns.P_COMPANY_ID] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.COMPANY)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-a55ead58 | SaveButton | SSP0005_ShipmentWorkingDay.cs:505 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i < siMain.ActiveSheet.RowCount) ▸… | DATA_OP | dr[DefColumns.P_YYYYMMDD] | strYYYYMMDD | 행/컬럼 값 대입 |  |  |  |
| AC-fc4b4f77 | SaveButton | SSP0005_ShipmentWorkingDay.cs:506 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i < siMain.ActiveSheet.RowCount) ▸… | DATA_OP | dr[DefColumns.P_WORKDAY_YN] | strWORKYN | 행/컬럼 값 대입 |  |  |  |
| AC-633bfea4 | SaveButton | SSP0005_ShipmentWorkingDay.cs:507 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i < siMain.ActiveSheet.RowCount) ▸… | DATA_OP | dr[DefColumns.P_LAST_UPDATED_BY] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-77750c14 | SaveButton | SSP0005_ShipmentWorkingDay.cs:508 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i < siMain.ActiveSheet.RowCount) ▸… | DATA_OP | dr[DefColumns.P_TIME_ZONE] | UserInfoContext.Current[UserInfoProperites.TimeZone] | 행/컬럼 값 대입 |  |  |  |
| AC-e86dbbba | SaveButton | SSP0005_ShipmentWorkingDay.cs:510 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i < siMain.ActiveSheet.RowCount) ▸… | DATA_OP | saveDS.Tables[0].Rows.Add | (dr) | 데이터 객체 조작/조회 |  |  |  |
| AC-ee1d0705 | SaveButton | SSP0005_ShipmentWorkingDay.cs:514 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | GRID_SET | saveDS.Tables[0].Rows[0][DefColumns.P_FIRST_ROW] | "Y" | 그리드 속성/값 설정 |  |  |  |
| AC-e0faca56 | SaveButton | SSP0005_ShipmentWorkingDay.cs:515 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | GRID_SET | saveDS.Tables[0].Rows[iCount-1][DefColumns.P_LAST_ROW] | "Y" | 그리드 속성/값 설정 |  |  |  |
| AC-441925ec | SaveButton | SSP0005_ShipmentWorkingDay.cs:517 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | saveDS.Tables[0].AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-a8de86a0 | SaveButton | SSP0005_ShipmentWorkingDay.cs:529 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ foreach (DataRo… | CALL_EXT | row.SetAdded | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-2ff4b920 | SaveButton | SSP0005_ShipmentWorkingDay.cs:530 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ foreach (DataRo… | CALL_EXT | row.SetModified | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-fbbd690d | SaveButton | SSP0005_ShipmentWorkingDay.cs:531 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ foreach (DataRo… | DATA_OP | row.Delete | () | 데이터 객체 조작/조회 |  |  |  |
| AC-5c31fcde | SaveButton | SSP0005_ShipmentWorkingDay.cs:535 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | UI_PROP | request.InsertQueryId | "SSP.SSP0005_SAVE_SHIPMENT_WORKING_DAY_ROW" | 속성 InsertQueryId 설정 |  |  |  |
| AC-98e98150 | SaveButton | SSP0005_ShipmentWorkingDay.cs:536 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | UI_PROP | request.DeleteQueryId | "SSP.SSP0005_SAVE_SHIPMENT_WORKING_DAY_ROW" | 속성 DeleteQueryId 설정 |  |  |  |
| AC-e85adc41 | SaveButton | SSP0005_ShipmentWorkingDay.cs:537 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | UI_PROP | request.UpdateQueryId | "SSP.SSP0005_SAVE_SHIPMENT_WORKING_DAY_ROW" | 속성 UpdateQueryId 설정 |  |  |  |
| AC-ae6a26c1 | SaveButton | SSP0005_ShipmentWorkingDay.cs:538 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | UI_PROP | request.DataSet | saveDS.GetChanges() | 속성 DataSet 설정 |  |  |  |
| AC-483083d3 | SaveButton | SSP0005_ShipmentWorkingDay.cs:538 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | CALL_EXT | saveDS.GetChanges | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-4c5f69bd | SaveButton | SSP0005_ShipmentWorkingDay.cs:541 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-1adc439e | SaveButton | SSP0005_ShipmentWorkingDay.cs:542 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SSP.Plan.WSL/FoxDataService.s… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-54eafeb6 | SaveButton | SSP0005_ShipmentWorkingDay.cs:547 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ lambda | ENDPOINT | client.SaveDataTable | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-979920f3 | SaveButton | SSP0005_ShipmentWorkingDay.cs:547 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ lambda | RETURN | return client.SaveDataTable(request); |  | 처리 중단/반환 |  |  |  |
| AC-d00bddfe | SaveButton | SSP0005_ShipmentWorkingDay.cs:553 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (t.Success) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-66380b32 | SaveButton | SSP0005_ShipmentWorkingDay.cs:555 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (t.Success) | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { iCount }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-de6ca567 | SaveButton | SSP0005_ShipmentWorkingDay.cs:561 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ catch ((Exception ex)… | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-79cb1617 | SaveButton | SSP0005_ShipmentWorkingDay.cs:563 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ catch ((Exception ex)… | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-37566e2e | SaveButton | SSP0005_ShipmentWorkingDay.cs:635 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-865e6ea7 | SaveButton | SSP0005_ShipmentWorkingDay.cs:639 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-5c2b940b | SaveButton | SSP0005_ShipmentWorkingDay.cs:641 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## SSP0005_ShipmentWorkingDay.SetChangedPeriod

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b1865ccc | (진입점 미연결) | SSP0005_ShipmentWorkingDay.cs:910 |  | COMBO_DATA | Data.CallBizCommonData | ("PERIOD_" + value) ⇒ biz:CommonData.CommonDataList [code=PERIOD_{p:value}] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-17bb5645 | (진입점 미연결) | SSP0005_ShipmentWorkingDay.cs:913 | if (dt == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d3f58205 | (진입점 미연결) | SSP0005_ShipmentWorkingDay.cs:916 | if (dt.Rows.Count > 0) | UI_PROP | drpPeriod.Text1 | dt.Rows[0]["FROM_VALUE"].ToString() | 속성 Text1 설정 |  |  |  |
| AC-4ef49d17 | (진입점 미연결) | SSP0005_ShipmentWorkingDay.cs:917 | if (dt.Rows.Count > 0) | UI_PROP | drpPeriod.Text2 | dt.Rows[0]["TO_VALUE"].ToString() | 속성 Text2 설정 |  |  |  |

## SSP0005_ShipmentWorkingDay.SpdMain_CellDoubleClick

진입점: spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-463c77ba | spdMain.CellDoubleClick | SSP0005_ShipmentWorkingDay.cs:840 | if (e.ColumnHeader) ▸ if (siMain.GetColumnTag(e.Column).IndexOf("M_") == 0) ▸ for (iCol < siMain.GetMaxColumnIndex()) ▸ if (siMain.GetColumn… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | !siMain.ActiveSheet.Columns[iCol].Visible | 그리드 속성/값 설정 |  |  |  |
| AC-d92b0398 | spdMain.CellDoubleClick | SSP0005_ShipmentWorkingDay.cs:843 | if (e.ColumnHeader) ▸ if (siMain.GetColumnTag(e.Column).IndexOf("M_") == 0) ▸ for (iCol < siMain.GetMaxColumnIndex()) ▸ else of (siMain.GetC… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | !siMain.ActiveSheet.Columns[iCol].Visible | 그리드 속성/값 설정 |  |  |  |
| AC-1050105c | spdMain.CellDoubleClick | SSP0005_ShipmentWorkingDay.cs:854 | if (e.ColumnHeader) ▸ else of (siMain.GetColumnTag(e.Column).IndexOf("M_") == 0) ▸ if (siMain.GetColumnTag(e.Column).IndexOf("W_") == 0) ▸ f… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | !siMain.ActiveSheet.Columns[iCol].Visible | 그리드 속성/값 설정 |  |  |  |

## SSP0005_ShipmentWorkingDay.SpdMain_Changed

진입점: dsdm.Changed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9ad0f3b6 | dsdm.Changed | SSP0005_ShipmentWorkingDay.cs:873 | if (!this.CanModelChange) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ce06096a | dsdm.Changed | SSP0005_ShipmentWorkingDay.cs:885 | try ▸ if (ds == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c112e7e6 | dsdm.Changed | SSP0005_ShipmentWorkingDay.cs:898 | catch ((Exception et)) | THROW | throw et; |  | 예외 발생 |  |  |  |
| AC-cc437408 | dsdm.Changed | SSP0005_ShipmentWorkingDay.cs:901 | finally | DATA_OP | dt.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |

## SSP0005_ShipmentWorkingDay.SpdMain_TopChange

진입점: spdMain.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cac783eb | spdMain.TopChange | SSP0005_ShipmentWorkingDay.cs:322 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

