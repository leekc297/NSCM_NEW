# AS-IS 액션 대조표 — SCP0096

> 원천: `Doc/asisfacts/screens/SCP0096/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 139행 · 메서드 21 · 종류 DATA_OP 35 · GRID_INIT 20 · RETURN 13 · ENDPOINT 9 · GRID_SET 8 · UI_MISC 8 · CALL_EXT 7 · MESSAGE 6 · FLAG 6 · UI_PROP 6 · GRID_LOCK 5 · LIST_REBIND 4 · POPUP 3 · VALIDATE 3 · STATE 2 · VALUE_SET 2 · GRID_BIND 1 · COMBO_DATA 1 · ⚠ 의미 확인 필요 7


## SCP0096_Shipment_Working_Day_OSP.BtnInput_Click

진입점: btnInput.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ab592920 | btnInput.Click | SCP0096_Shipment_Working_Day_OSP.cs:686 |  | CALL_EXT | siMain.ActiveSheet.Columns.Get | (0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-33978044 | btnInput.Click | SCP0096_Shipment_Working_Day_OSP.cs:689 | if (siMain.ActiveSheet.Columns.Get(0).Visible == false) | MESSAGE | MessageHelper.GMessageBox | ("MSG00135", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-7936e161 | btnInput.Click | SCP0096_Shipment_Working_Day_OSP.cs:690 | if (siMain.ActiveSheet.Columns.Get(0).Visible == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ce477761 | btnInput.Click | SCP0096_Shipment_Working_Day_OSP.cs:693 | if (!this.CanModelChange) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-02e1befa | btnInput.Click | SCP0096_Shipment_Working_Day_OSP.cs:705 | if (pDayWeekCode == "SelectDay") ▸ if (selCells.Length < 1) | MESSAGE | MessageHelper.GMessageBox | ("MSG00134", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-2a8d5188 | btnInput.Click | SCP0096_Shipment_Working_Day_OSP.cs:706 | if (pDayWeekCode == "SelectDay") ▸ if (selCells.Length < 1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-db5ba668 | btnInput.Click | SCP0096_Shipment_Working_Day_OSP.cs:712 | if (string.IsNullOrEmpty(pDayWeekCode)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-aa878da9 | btnInput.Click | SCP0096_Shipment_Working_Day_OSP.cs:715 | if (!this.CanModelChange) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a538041b | btnInput.Click | SCP0096_Shipment_Working_Day_OSP.cs:737 | if (pDayWeekCode == "SelectDay") ▸ foreach (CellRange range in selCells) | CALL_EXT | spdMain.ActiveSheet.GetModelColumnFromViewColumn | (row) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e978cb8f | btnInput.Click | SCP0096_Shipment_Working_Day_OSP.cs:738 | if (pDayWeekCode == "SelectDay") ▸ foreach (CellRange range in selCells) | CALL_EXT | spdMain.ActiveSheet.GetModelColumnFromViewColumn | (col) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c6bad386 | btnInput.Click | SCP0096_Shipment_Working_Day_OSP.cs:747 | if (pDayWeekCode == "SelectDay") ▸ foreach (CellRange range in selCells) ▸ if (row >= 0 && col < 0) ▸ for (i < row + rowCnt) ▸ for (j < siMa… | GRID_SET | siMain.ActiveSheet.SetText | (i, j, sInputValue) | 그리드 값 설정 |  |  |  |
| AC-d54aa06c | btnInput.Click | SCP0096_Shipment_Working_Day_OSP.cs:761 | if (pDayWeekCode == "SelectDay") ▸ foreach (CellRange range in selCells) ▸ else of (row >= 0 && col < 0) ▸ if (row < 0 && col >= 0) ▸ for (i… | GRID_SET | siMain.ActiveSheet.SetText | (i, j, sInputValue) | 그리드 값 설정 |  |  |  |
| AC-329ea8b2 | btnInput.Click | SCP0096_Shipment_Working_Day_OSP.cs:774 | if (pDayWeekCode == "SelectDay") ▸ foreach (CellRange range in selCells) ▸ else of (row >= 0 && col < 0) ▸ else of (row < 0 && col >= 0) ▸ i… | GRID_SET | siMain.ActiveSheet.SetText | (i, j, sInputValue) | 그리드 값 설정 |  |  |  |
| AC-ea923053 | btnInput.Click | SCP0096_Shipment_Working_Day_OSP.cs:792 | else of (pDayWeekCode == "SelectDay") ▸ for (i < siMain.ActiveSheet.Rows.Count) ▸ for (j < siMain.ActiveSheet.Columns.Count) ▸ if (siMain.Ac… | GRID_SET | siMain.ActiveSheet.SetText | (i, j, sInputValue) | 그리드 값 설정 |  |  |  |
| AC-7b9340ed | btnInput.Click | SCP0096_Shipment_Working_Day_OSP.cs:800 | else of (pDayWeekCode == "SelectDay") ▸ for (i < siMain.ActiveSheet.Rows.Count) ▸ for (j < siMain.ActiveSheet.Columns.Count) ▸ if (siMain.Ac… | GRID_SET | siMain.ActiveSheet.SetText | (i, j, sInputValue) | 그리드 값 설정 |  |  |  |

## SCP0096_Shipment_Working_Day_OSP.CboDayWeek_SelectedIndexChanged

진입점: cboDayWeek.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a8253d55 | cboDayWeek.SelectedIndexChanged | SCP0096_Shipment_Working_Day_OSP.cs:675 | if (string.IsNullOrEmpty(pDayWeek)) | STATE | cboInputValue.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-9705a1f9 | cboDayWeek.SelectedIndexChanged | SCP0096_Shipment_Working_Day_OSP.cs:679 | else of (string.IsNullOrEmpty(pDayWeek)) | STATE | cboInputValue.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## SCP0096_Shipment_Working_Day_OSP.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-77d0b560 | this.Load | SCP0096_Shipment_Working_Day_OSP.cs:142 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 3, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-c7db14c3 | this.Load | SCP0096_Shipment_Working_Day_OSP.cs:143 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, 0) | 화면 필드/플래그 변경 |  |  |  |
| AC-15068b3a | this.Load | SCP0096_Shipment_Working_Day_OSP.cs:144 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0096_Shipment_Working_Day_OSP.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6d6b211e | this.Load | SCP0096_Shipment_Working_Day_OSP.cs:120 |  | UI_PROP | usrConditionPanel1.Height | 105 | 속성 Height 설정 |  |  |  |
| AC-137a2614 | this.Load | SCP0096_Shipment_Working_Day_OSP.cs:121 |  | VALUE_SET | chkSum.Checked | false | 컨트롤 값 설정 |  |  |  |

## SCP0096_Shipment_Working_Day_OSP.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6f48c69b | Dispose | SCP0096_Shipment_Working_Day_OSP.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0096_Shipment_Working_Day_OSP.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-65463aa5 | EditButton | SCP0096_Shipment_Working_Day_OSP.cs:288 | if (fps != null) ▸ if (fps.Name == "spdMain") | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-b73d4459 | EditButton | SCP0096_Shipment_Working_Day_OSP.cs:289 | if (fps != null) ▸ if (fps.Name == "spdMain") | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-90fb49a5 | EditButton | SCP0096_Shipment_Working_Day_OSP.cs:291 | if (fps != null) ▸ if (fps.Name == "spdMain") | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.DIVISION_ID), siMain.GetColumnIndex(DefColumns.PLANT_SIT… | 그리드 편집 잠금/해제 |  |  |  |
| AC-ebdb793b | EditButton | SCP0096_Shipment_Working_Day_OSP.cs:292 | if (fps != null) ▸ if (fps.Name == "spdMain") | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.LAST_INPUT_DATE), siMain.GetColumnIndex(DefColumns.MEASU… | 그리드 편집 잠금/해제 |  |  |  |

## SCP0096_Shipment_Working_Day_OSP.FindData_Main

진입점: FindButton / SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (t.Success)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cd3cbe03 | FindButton 외 1 | SCP0096_Shipment_Working_Day_OSP.cs:431 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-2e4f77f9 | FindButton 외 1 | SCP0096_Shipment_Working_Day_OSP.cs:435 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-db148f8d | FindButton 외 1 | SCP0096_Shipment_Working_Day_OSP.cs:435 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-719971bc | FindButton 외 1 | SCP0096_Shipment_Working_Day_OSP.cs:436 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-b5cc8e43 | FindButton 외 1 | SCP0096_Shipment_Working_Day_OSP.cs:451 | try | UI_PROP | proxyPivot.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-929f195a | FindButton 외 1 | SCP0096_Shipment_Working_Day_OSP.cs:453 | try | ENDPOINT | proxyPivot.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, GSCM_SCP_MASTER… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-0e444471 | FindButton 외 1 | SCP0096_Shipment_Working_Day_OSP.cs:457 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0096_GET_SHIPMENT_WORKING_DAY_OSP") ⇒ SCP.SCP0096_GET_SHIPMENT_WORKING_DAY_OSP | 엔드포인트 요청 생성 |  |  |  |
| AC-7d912a87 | FindButton 외 1 | SCP0096_Shipment_Working_Day_OSP.cs:459 | try ▸ lambda | UI_PROP | req.CommandTimeout | 60 * 10 | 속성 CommandTimeout 설정 |  |  |  |
| AC-678a6e26 | FindButton 외 1 | SCP0096_Shipment_Working_Day_OSP.cs:460 | try ▸ lambda | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-3f22a832 | FindButton 외 1 | SCP0096_Shipment_Working_Day_OSP.cs:461 | try ▸ lambda | DATA_OP | req.Parameters["p_plant_site_id"] | p_plant_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-106c7194 | FindButton 외 1 | SCP0096_Shipment_Working_Day_OSP.cs:462 | try ▸ lambda | DATA_OP | req.Parameters["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-52e33457 | FindButton 외 1 | SCP0096_Shipment_Working_Day_OSP.cs:463 | try ▸ lambda | DATA_OP | req.Parameters["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-4e002b9e | FindButton 외 1 | SCP0096_Shipment_Working_Day_OSP.cs:464 | try ▸ lambda | DATA_OP | req.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-edf41b68 | FindButton 외 1 | SCP0096_Shipment_Working_Day_OSP.cs:465 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-2f5e0311 | FindButton 외 1 | SCP0096_Shipment_Working_Day_OSP.cs:466 | try ▸ lambda | RETURN | return res.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-aeb763de | FindButton 외 1 | SCP0096_Shipment_Working_Day_OSP.cs:473 | try | GRID_BIND | siMain.Query | (dsBinding) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-191e1c28 | FindButton 외 1 | SCP0096_Shipment_Working_Day_OSP.cs:475 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-25c8c6fa | FindButton 외 1 | SCP0096_Shipment_Working_Day_OSP.cs:477 | try | UI_MISC | SetSearchCount | (dsBinding) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-2b642070 | FindButton 외 1 | SCP0096_Shipment_Working_Day_OSP.cs:480 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d8227fbf | FindButton 외 1 | SCP0096_Shipment_Working_Day_OSP.cs:490 | try | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-6c7fb080 | FindButton 외 1 | SCP0096_Shipment_Working_Day_OSP.cs:497 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a231165d | FindButton 외 1 | SCP0096_Shipment_Working_Day_OSP.cs:501 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0096_Shipment_Working_Day_OSP.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d6f0e22f | this.Load | SCP0096_Shipment_Working_Day_OSP.cs:109 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCP0096_Shipment_Working_Day_OSP.GetBucketType

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a690bb58 | this.Load | SCP0096_Shipment_Working_Day_OSP.cs:394 |  | ENDPOINT | new FoxDataRequest | ("DM.DM0003_GET_BUCKET_TYPE_CODE") ⇒ DM.DM0003_GET_BUCKET_TYPE_CODE | 엔드포인트 요청 생성 |  |  |  |
| AC-bdcbe650 | this.Load | SCP0096_Shipment_Working_Day_OSP.cs:395 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-f7f58a94 | this.Load | SCP0096_Shipment_Working_Day_OSP.cs:398 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SCP0096_Shipment_Working_Day_OSP.GetDayOfWeek

진입점: btnInput.Click [else of (pDayWeekCode == "SelectDay") ▸ for (i < siMain.ActiveSheet.Rows.Count) ▸ for (j < siMain.ActiveSheet.Columns.Count) ▸ if (siMain.ActiveSheet.Columns[j].Tag.ToString().IndexOf("D_") == 0) ▸ else of (pDayWeekCode == "EveryDay")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-89466f51 | btnInput.Click [else of (pDayWeekCode == "SelectDay") ▸ for … | SCP0096_Shipment_Working_Day_OSP.cs:815 |  | DATA_OP | dt.Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-73698b37 | btnInput.Click [else of (pDayWeekCode == "SelectDay") ▸ for … | SCP0096_Shipment_Working_Day_OSP.cs:815 | lambda | DATA_OP | row.Field | ("COLUMN_NAME") | 데이터 객체 조작/조회 |  |  |  |
| AC-c0db51ac | btnInput.Click [else of (pDayWeekCode == "SelectDay") ▸ for … | SCP0096_Shipment_Working_Day_OSP.cs:817 |  | RETURN | return returnDay; |  | 처리 중단/반환 |  |  |  |

## SCP0096_Shipment_Working_Day_OSP.GetDayRange

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a8e480ad | this.Load | SCP0096_Shipment_Working_Day_OSP.cs:843 |  | CALL_EXT | DateUtil.GetDayRange | (cboDivision.ControlValues, "DAILY") | ⚠ 의미 확인 필요 |  |  |  |
| AC-7591461b | this.Load | SCP0096_Shipment_Working_Day_OSP.cs:845 |  | RETURN | return sDayRange; |  | 처리 중단/반환 |  |  |  |

## SCP0096_Shipment_Working_Day_OSP.GetSpdTitle

진입점: this.Load / FindButton [try] / SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (t.Success) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cc98efe2 | this.Load 외 2 | SCP0096_Shipment_Working_Day_OSP.cs:831 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN") ⇒ SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | 엔드포인트 요청 생성 |  |  |  |
| AC-f17d3bf8 | this.Load 외 2 | SCP0096_Shipment_Working_Day_OSP.cs:833 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | dCalendar.Text1.Replace("-", "") | 행/컬럼 값 대입 |  |  |  |
| AC-2bed971d | this.Load 외 2 | SCP0096_Shipment_Working_Day_OSP.cs:834 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | dCalendar.Text2.Replace("-", "") | 행/컬럼 값 대입 |  |  |  |
| AC-4573b40d | this.Load 외 2 | SCP0096_Shipment_Working_Day_OSP.cs:836 |  | FLAG | dsSpdTitle | client.ExecuteDataSet(request).DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-1f0839eb | this.Load 외 2 | SCP0096_Shipment_Working_Day_OSP.cs:836 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## SCP0096_Shipment_Working_Day_OSP.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ccb17fe3 | this.Load | SCP0096_Shipment_Working_Day_OSP.cs:127 | if (dtMyDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |
| AC-7bc17c68 | this.Load | SCP0096_Shipment_Working_Day_OSP.cs:129 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-112be785 | this.Load | SCP0096_Shipment_Working_Day_OSP.cs:130 |  | LIST_REBIND | clsCtrl.setListBox | (dtMyDivision, cboDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-aa0dc541 | this.Load | SCP0096_Shipment_Working_Day_OSP.cs:131 |  | LIST_REBIND | clsCtrl.setListBox | (dtValidYN, cboInputValue, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-13a1cca3 | this.Load | SCP0096_Shipment_Working_Day_OSP.cs:132 |  | LIST_REBIND | clsCtrl.setListBox | (dtDayWeek, cboDayWeek, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-9dc2ff4c | this.Load | SCP0096_Shipment_Working_Day_OSP.cs:136 |  | FLAG | dtBucketType | GetBucketType() | 화면 필드/플래그 변경 |  |  |  |
| AC-f2a0244d | this.Load | SCP0096_Shipment_Working_Day_OSP.cs:137 |  | VALUE_SET | dCalendar.InitValue | GetDayRange() | 컨트롤 값 설정 |  |  |  |

## SCP0096_Shipment_Working_Day_OSP.InitSpread

진입점: this.Load / FindButton [try] / SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (t.Success) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4bbb2e25 | this.Load 외 2 | SCP0096_Shipment_Working_Day_OSP.cs:155 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.InitSheet | (SpdSheet.shtMain) | 그리드 재구성/초기화 |  |  |  |
| AC-109c23c2 | this.Load 외 2 | SCP0096_Shipment_Working_Day_OSP.cs:156 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.SetSheetHeaderColumn | (siMain, 3) | 그리드 재구성/초기화 |  |  |  |
| AC-125eeba3 | this.Load 외 2 | SCP0096_Shipment_Working_Day_OSP.cs:163 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.SetReNumerCellType | (spdInfo, spdInfo.GetColumnIndex(DefColumns.WORKING_TIME_DEFAULT), 0, 0, 7) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-6ea7dbbe | this.Load 외 2 | SCP0096_Shipment_Working_Day_OSP.cs:165 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0096_Shipment_Working_Day_OSP.InitSpreadDateColumn

진입점: this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] / FindButton [try ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (t.Success) ▸ try ▸ if (spdInfo.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a88217c5 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 2 | SCP0096_Shipment_Working_Day_OSP.cs:196 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sColumnName.IndexOf("B_") > 0) | GRID_INIT | spdInfo.AddTextColumn | (sColumnLabelname, sColumnName, FPMerge.None, 0, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7e84a36b | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 2 | SCP0096_Shipment_Working_Day_OSP.cs:203 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sColumnName.IndexOf("B_") > 0) | GRID_INIT | spdInfo.AddComboColumn | (sColumnLabelname, sColumnName, FPMerge.None, 50, true, dtValidYN, FPHAlign.Center, FPVAli… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-836fd0f9 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 2 | SCP0096_Shipment_Working_Day_OSP.cs:208 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sColumnName.IndexOf("B_") > 0) ▸ if (sDayCode == DefColumnsLabel.Saturday \|\| … | GRID_SET | spdInfo.Sheet().ColumnHeader.Cells[2, spdInfo.GetMaxColumnIndex()].ForeColor | sDayCode == DefColumnsLabel.Saturday ? Color.Blue : Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-1c57d0ce | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 2 | SCP0096_Shipment_Working_Day_OSP.cs:215 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7f9fd878 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 2 | SCP0096_Shipment_Working_Day_OSP.cs:216 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-34c9ab14 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 2 | SCP0096_Shipment_Working_Day_OSP.cs:221 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-644cc8b3 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 2 | SCP0096_Shipment_Working_Day_OSP.cs:222 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 30, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-da8a5d35 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 2 | SCP0096_Shipment_Working_Day_OSP.cs:230 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName != sSmallLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6fd28a6b | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 2 | SCP0096_Shipment_Working_Day_OSP.cs:231 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName != sSmallLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-964fd743 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 2 | SCP0096_Shipment_Working_Day_OSP.cs:241 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b05fe87d | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 2 | SCP0096_Shipment_Working_Day_OSP.cs:242 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3a3cc630 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 2 | SCP0096_Shipment_Working_Day_OSP.cs:243 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b25d961a | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 2 | SCP0096_Shipment_Working_Day_OSP.cs:244 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0096_Shipment_Working_Day_OSP.SaveData_Main

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-550fa4e9 | SaveButton | SCP0096_Shipment_Working_Day_OSP.cs:507 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-e5e49c62 | SaveButton | SCP0096_Shipment_Working_Day_OSP.cs:516 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (siMain.ActiveSheet.Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-017a8492 | SaveButton | SCP0096_Shipment_Working_Day_OSP.cs:520 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | VALIDATE | DataUtil.checkRequiredOfSpread | (siMain) | 프레임워크 검증 |  |  |  |
| AC-ca108833 | SaveButton | SCP0096_Shipment_Working_Day_OSP.cs:520 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (!DataUtil.checkRequiredOfSpread(siM… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-62492e6c | SaveButton | SCP0096_Shipment_Working_Day_OSP.cs:526 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("A", typeof(char)) | 데이터 객체 조작/조회 |  |  |  |
| AC-5288a7d7 | SaveButton | SCP0096_Shipment_Working_Day_OSP.cs:528 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_division_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-9daff78b | SaveButton | SCP0096_Shipment_Working_Day_OSP.cs:529 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_plant_site_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-6abcd99e | SaveButton | SCP0096_Shipment_Working_Day_OSP.cs:530 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_yyyymmdd") | 데이터 객체 조작/조회 |  |  |  |
| AC-de99f063 | SaveButton | SCP0096_Shipment_Working_Day_OSP.cs:531 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_measure") | 데이터 객체 조작/조회 |  |  |  |
| AC-29e2958a | SaveButton | SCP0096_Shipment_Working_Day_OSP.cs:532 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_shipment_yn") | 데이터 객체 조작/조회 |  |  |  |
| AC-0e86fa07 | SaveButton | SCP0096_Shipment_Working_Day_OSP.cs:533 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_is_save_defalut") | 데이터 객체 조작/조회 |  |  |  |
| AC-2b44e5eb | SaveButton | SCP0096_Shipment_Working_Day_OSP.cs:534 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_user_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-fc655506 | SaveButton | SCP0096_Shipment_Working_Day_OSP.cs:535 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_working_time_default") | 데이터 객체 조작/조회 |  |  |  |
| AC-ba7e7f4b | SaveButton | SCP0096_Shipment_Working_Day_OSP.cs:536 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dsInput.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-31a56795 | SaveButton | SCP0096_Shipment_Working_Day_OSP.cs:552 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dsInput.Tables[0].NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-24d94470 | SaveButton | SCP0096_Shipment_Working_Day_OSP.cs:558 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["A"] | action | 행/컬럼 값 대입 |  |  |  |
| AC-6ca4ce6f | SaveButton | SCP0096_Shipment_Working_Day_OSP.cs:560 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_division_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.DIVISION_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-0ef88c93 | SaveButton | SCP0096_Shipment_Working_Day_OSP.cs:561 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_plant_site_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.PLANT_SITE_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-d6f42257 | SaveButton | SCP0096_Shipment_Working_Day_OSP.cs:562 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_measure"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.MEASURE)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-0e458e9d | SaveButton | SCP0096_Shipment_Working_Day_OSP.cs:563 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-9879f052 | SaveButton | SCP0096_Shipment_Working_Day_OSP.cs:570 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_yyyymmdd"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-8c7ad70d | SaveButton | SCP0096_Shipment_Working_Day_OSP.cs:571 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_shipment_yn"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-7456afff | SaveButton | SCP0096_Shipment_Working_Day_OSP.cs:572 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_is_save_defalut"] | "Y" | 행/컬럼 값 대입 |  |  |  |
| AC-d1e6ddc6 | SaveButton | SCP0096_Shipment_Working_Day_OSP.cs:573 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_working_time_default"] | workingTimeDefault | 행/컬럼 값 대입 |  |  |  |
| AC-d4ff44ef | SaveButton | SCP0096_Shipment_Working_Day_OSP.cs:578 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_yyyymmdd"] | strDayName | 행/컬럼 값 대입 |  |  |  |
| AC-0df51d83 | SaveButton | SCP0096_Shipment_Working_Day_OSP.cs:579 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_shipment_yn"] | strDayYN | 행/컬럼 값 대입 |  |  |  |
| AC-b581c763 | SaveButton | SCP0096_Shipment_Working_Day_OSP.cs:580 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_is_save_defalut"] | "N" | 행/컬럼 값 대입 |  |  |  |
| AC-efaa4c94 | SaveButton | SCP0096_Shipment_Working_Day_OSP.cs:581 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_working_time_default"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-30711005 | SaveButton | SCP0096_Shipment_Working_Day_OSP.cs:584 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dsInput.Tables[0].Rows.Add | (dr) | 데이터 객체 조작/조회 |  |  |  |
| AC-37fa1d7a | SaveButton | SCP0096_Shipment_Working_Day_OSP.cs:590 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dsInput.Tables[0].AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-5a5e6522 | SaveButton | SCP0096_Shipment_Working_Day_OSP.cs:603 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ foreach (DataRo… | CALL_EXT | row.SetModified | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-afbcee2c | SaveButton | SCP0096_Shipment_Working_Day_OSP.cs:608 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | UI_PROP | request.UpdateQueryId | "SCP.SCP0096_SAVE_SHIPMENT_WORKING_DAY_OSP" | 속성 UpdateQueryId 설정 |  |  |  |
| AC-7171f89e | SaveButton | SCP0096_Shipment_Working_Day_OSP.cs:609 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | UI_PROP | request.DataSet | dsInput.GetChanges() | 속성 DataSet 설정 |  |  |  |
| AC-22ebf26a | SaveButton | SCP0096_Shipment_Working_Day_OSP.cs:609 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | CALL_EXT | dsInput.GetChanges | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-01fa4a33 | SaveButton | SCP0096_Shipment_Working_Day_OSP.cs:612 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-614f66ec | SaveButton | SCP0096_Shipment_Working_Day_OSP.cs:613 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, GSCM_SCP_MASTER… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-c846ea05 | SaveButton | SCP0096_Shipment_Working_Day_OSP.cs:618 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ lambda | ENDPOINT | client.SaveDataTable | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a736abf6 | SaveButton | SCP0096_Shipment_Working_Day_OSP.cs:618 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ lambda | RETURN | return client.SaveDataTable(request); |  | 처리 중단/반환 |  |  |  |
| AC-18a3ad5e | SaveButton | SCP0096_Shipment_Working_Day_OSP.cs:621 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-254dabe1 | SaveButton | SCP0096_Shipment_Working_Day_OSP.cs:625 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (t.Success) | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { iCount }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-7f41f8ae | SaveButton | SCP0096_Shipment_Working_Day_OSP.cs:635 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ catch ((Exception ex)… | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3d1ba0c4 | SaveButton | SCP0096_Shipment_Working_Day_OSP.cs:647 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-5a635723 | SaveButton | SCP0096_Shipment_Working_Day_OSP.cs:651 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-c00c38d0 | SaveButton | SCP0096_Shipment_Working_Day_OSP.cs:652 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## SCP0096_Shipment_Working_Day_OSP.SetChangedControl

진입점: this.Load / cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-83e5f9c6 | this.Load 외 1 | SCP0096_Shipment_Working_Day_OSP.cs:422 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | FLAG | dtPlantSiteByDivision | Data_SCP.Common(Data_SCP.Type.PlantByDivisionOperOsp3, false, division, "", "") | 화면 필드/플래그 변경 |  |  |  |
| AC-91a4048e | this.Load 외 1 | SCP0096_Shipment_Working_Day_OSP.cs:422 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.PlantByDivisionOperOsp3, false, division, "", "") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-f2da44db | this.Load 외 1 | SCP0096_Shipment_Working_Day_OSP.cs:423 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | LIST_REBIND | clsCtrl.setListBox | (dtPlantSiteByDivision, clbPlantSite, false) | 목록 컨트롤 재구성 |  |  |  |

## SCP0096_Shipment_Working_Day_OSP.SetLockSumColumn

진입점: EditButton [if (fps != null) ▸ if (fps.Name == "spdMain")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8cb032b7 | EditButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | SCP0096_Shipment_Working_Day_OSP.cs:408 | for (iCol <= spreadInfo.GetMaxColumnIndex()) ▸ if (spreadInfo.GetColumnTag(iCol).IndexOf("W_") == 0 \|\| spreadInfo.GetColumnTag(iCol).Index… | GRID_LOCK | spreadInfo.LockColumn | (iCol, true) | 그리드 편집 잠금/해제 |  |  |  |

## SCP0096_Shipment_Working_Day_OSP.SetSpreadColumn

진입점: this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] / this.chkSum.CheckedChanged [if (fps != null) ▸ if (fps.Name == "spdMain")] / FindButton [try ▸ if (siMain.GetMaxRowIndex() > 0)] / SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (t.Success) ▸ try ▸ if (siMain.GetMaxRowIndex() > 0)] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a2f7749d | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 4 | SCP0096_Shipment_Working_Day_OSP.cs:350 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ if (siObj.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siObj.GetColumnTag(iCol).IndexOf("W_") == 0) | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-da3c45fc | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 4 | SCP0096_Shipment_Working_Day_OSP.cs:355 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ if (siObj.GetColumnTag(iCol).IndexOf("M_") == 0 \|\| siObj.GetColumnTag(iCol).IndexOf("W_") == 0) | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | chkSum.Checked | 그리드 속성/값 설정 |  |  |  |

## SCP0096_Shipment_Working_Day_OSP.SpdMain_CellDoubleClick

진입점: spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-12c2a484 | spdMain.CellDoubleClick | SCP0096_Shipment_Working_Day_OSP.cs:822 |  | CALL_EXT | siMain.SetDblClickColumnShowHide | (sender, e) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0096_Shipment_Working_Day_OSP.SpdMain_TopChange

진입점: spdMain.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3b39a6b5 | spdMain.TopChange | SCP0096_Shipment_Working_Day_OSP.cs:261 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

