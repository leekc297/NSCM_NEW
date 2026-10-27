# AS-IS 액션 대조표 — SCP0112

> 원천: `Doc/asisfacts/screens/SCP0112/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 119행 · 메서드 19 · 종류 DATA_OP 23 · GRID_INIT 16 · UI_MISC 11 · FLAG 10 · ENDPOINT 8 · VALUE_SET 7 · UI_PROP 7 · LIST_REBIND 5 · GRID_LOCK 5 · RETURN 4 · POPUP 4 · MESSAGE 4 · STATE 3 · GRID_CLEAR 2 · VALIDATE 2 · CALL_EXT 2 · GRID_SET 2 · COMBO_DATA 1 · GRID_BIND 1 · GRID_STYLE 1 · VALUE_CLEAR 1 · ⚠ 의미 확인 필요 2


## SCP0112_CellTraySimulation.CboPlanDate_SelectedIndexChanged

진입점: cboPlanDate.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d830ac58 | cboPlanDate.SelectedIndexChanged | SCP0112_CellTraySimulation.cs:663 | if (dtPlanTypeAll == null) | FLAG | dtPlanTypeAll | Data_SCP.CommonAll(Data_SCP.Type.PlanType1, false, "", "") | 화면 필드/플래그 변경 |  |  |  |
| AC-943e6901 | cboPlanDate.SelectedIndexChanged | SCP0112_CellTraySimulation.cs:663 | if (dtPlanTypeAll == null) | COMBO_DATA | Data_SCP.CommonAll | (Data_SCP.Type.PlanType1, false, "", "") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-eed28aa2 | cboPlanDate.SelectedIndexChanged | SCP0112_CellTraySimulation.cs:665 |  | FLAG | dtPlanType | dtPlanTypeAll.Select("DIVISION_ID = '" + division + "' AND PLANDATE = '" + pPlanDate + "'"… | 화면 필드/플래그 변경 |  |  |  |
| AC-4e79dcc5 | cboPlanDate.SelectedIndexChanged | SCP0112_CellTraySimulation.cs:665 |  | DATA_OP | dtPlanTypeAll.Select("DIVISION_ID = '" + division + "' AND PLANDATE = '" + pPlanDate + "'"… | () | 데이터 객체 조작/조회 |  |  |  |
| AC-f563763d | cboPlanDate.SelectedIndexChanged | SCP0112_CellTraySimulation.cs:665 |  | DATA_OP | dtPlanTypeAll.Select | ("DIVISION_ID = '" + division + "' AND PLANDATE = '" + pPlanDate + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-bbba3ceb | cboPlanDate.SelectedIndexChanged | SCP0112_CellTraySimulation.cs:667 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanType, cboPlanType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-a2c8caa5 | cboPlanDate.SelectedIndexChanged | SCP0112_CellTraySimulation.cs:669 |  | VALUE_SET | cboPlanType.SelectedIndex | dtPlanType.Rows.Count - 1 | 컨트롤 값 설정 |  |  |  |
| AC-132b14ae | cboPlanDate.SelectedIndexChanged | SCP0112_CellTraySimulation.cs:671 |  | VALUE_SET | dCalendar.InitValue | GetDayRange() | 컨트롤 값 설정 |  |  |  |
| AC-f4cd3c1d | cboPlanDate.SelectedIndexChanged | SCP0112_CellTraySimulation.cs:672 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |

## SCP0112_CellTraySimulation.CboPlanType_SelectedIndexChanged

진입점: cboPlanType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4e3c0cf5 | cboPlanType.SelectedIndexChanged | SCP0112_CellTraySimulation.cs:677 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |

## SCP0112_CellTraySimulation.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1e66f0a4 | this.Load | SCP0112_CellTraySimulation.cs:162 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 2, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-789ca3e4 | this.Load | SCP0112_CellTraySimulation.cs:163 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, 0) | 화면 필드/플래그 변경 |  |  |  |
| AC-8050a467 | this.Load | SCP0112_CellTraySimulation.cs:165 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0112_CellTraySimulation.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9337d560 | this.Load | SCP0112_CellTraySimulation.cs:127 |  | UI_PROP | usrConditionPanel1.Height | 75 | 속성 Height 설정 |  |  |  |

## SCP0112_CellTraySimulation.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-025c021c | Dispose | SCP0112_CellTraySimulation.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0112_CellTraySimulation.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-725f4280 | EditButton | SCP0112_CellTraySimulation.cs:305 | if (spdMain != null) | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-3f15ee0d | EditButton | SCP0112_CellTraySimulation.cs:306 | if (spdMain != null) | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-61c587ee | EditButton | SCP0112_CellTraySimulation.cs:308 | if (spdMain != null) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefMain.FROM_SITE_DESCRIPTION), siMain.GetColumnIndex(DefMain.MEASU… | 그리드 편집 잠금/해제 |  |  |  |
| AC-093bd27a | EditButton | SCP0112_CellTraySimulation.cs:309 | if (spdMain != null) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefMain.BOH_QTY) + 1, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-07a871c9 | EditButton | SCP0112_CellTraySimulation.cs:318 | if (spdMain != null) ▸ for (iRow < siMain.ActiveSheet.Rows.Count) ▸ if (measure_name2 != "Empty" \|\| (measure_value != "Packer" && measure_… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefMain.BOH_QTY), iRow, siMain.GetColumnIndex(DefMain.BOH_QTY… | 그리드 편집 잠금/해제 |  |  |  |

## SCP0112_CellTraySimulation.FindData_Main

진입점: FindButton / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0) ▸ try ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-813c48a1 | FindButton 외 1 | SCP0112_CellTraySimulation.cs:365 |  | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-a317692b | FindButton 외 1 | SCP0112_CellTraySimulation.cs:365 | if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-fa0a1793 | FindButton 외 1 | SCP0112_CellTraySimulation.cs:387 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-2ecd20ae | FindButton 외 1 | SCP0112_CellTraySimulation.cs:390 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-11e0a191 | FindButton 외 1 | SCP0112_CellTraySimulation.cs:393 | try | UI_PROP | proxyPivot.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-562b8ade | FindButton 외 1 | SCP0112_CellTraySimulation.cs:395 | try | ENDPOINT | proxyPivot.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, GSCM_SCP_ANALYS… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-feab7ac0 | FindButton 외 1 | SCP0112_CellTraySimulation.cs:399 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0112_GET_CELL_TRAY_SIMULATION") ⇒ SCP.SCP0112_GET_CELL_TRAY_SIMULATION | 엔드포인트 요청 생성 |  |  |  |
| AC-23236d80 | FindButton 외 1 | SCP0112_CellTraySimulation.cs:400 | try ▸ lambda | UI_PROP | req.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-5562b284 | FindButton 외 1 | SCP0112_CellTraySimulation.cs:401 | try ▸ lambda | DATA_OP | req.Parameters["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-b34846da | FindButton 외 1 | SCP0112_CellTraySimulation.cs:402 | try ▸ lambda | DATA_OP | req.Parameters["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-0717214a | FindButton 외 1 | SCP0112_CellTraySimulation.cs:403 | try ▸ lambda | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-56c49356 | FindButton 외 1 | SCP0112_CellTraySimulation.cs:404 | try ▸ lambda | DATA_OP | req.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-a900e884 | FindButton 외 1 | SCP0112_CellTraySimulation.cs:405 | try ▸ lambda | DATA_OP | req.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-d751471e | FindButton 외 1 | SCP0112_CellTraySimulation.cs:406 | try ▸ lambda | DATA_OP | req.Parameters["p_to_site"] | p_to_site | 행/컬럼 값 대입 |  |  |  |
| AC-5525c208 | FindButton 외 1 | SCP0112_CellTraySimulation.cs:408 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-c975f694 | FindButton 외 1 | SCP0112_CellTraySimulation.cs:409 | try ▸ lambda | RETURN | return res.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-ed7320dc | FindButton 외 1 | SCP0112_CellTraySimulation.cs:418 | try ▸ if (dsBinding.Tables.Count > 0) | FLAG | this.dtAll | dsBinding.Tables[0].Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-f57e60d1 | FindButton 외 1 | SCP0112_CellTraySimulation.cs:418 | try ▸ if (dsBinding.Tables.Count > 0) | DATA_OP | dsBinding.Tables[0].Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-2dd36314 | FindButton 외 1 | SCP0112_CellTraySimulation.cs:421 | try | GRID_BIND | siMain.Query | (dsBinding) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-29e753c9 | FindButton 외 1 | SCP0112_CellTraySimulation.cs:422 | try | UI_MISC | SetSearchCount | (dsBinding) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-8174d0a4 | FindButton 외 1 | SCP0112_CellTraySimulation.cs:433 | try ▸ if (dsBinding.Tables.Count > 0 && dsBinding.Tables[0].Rows.Count > 0) | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-4ac0aa1e | FindButton 외 1 | SCP0112_CellTraySimulation.cs:445 | try ▸ if (dsBinding.Tables.Count > 0 && dsBinding.Tables[0].Rows.Count > 0) ▸ for (iRow < siMain.ActiveSheet.Rows.Count) ▸ if (!isBoh.ToUppe… | VALUE_SET | cells.Text | measure_Value | 컨트롤 값 설정 |  |  |  |
| AC-dedff543 | FindButton 외 1 | SCP0112_CellTraySimulation.cs:446 | try ▸ if (dsBinding.Tables.Count > 0 && dsBinding.Tables[0].Rows.Count > 0) ▸ for (iRow < siMain.ActiveSheet.Rows.Count) ▸ if (!isBoh.ToUppe… | UI_PROP | cells.ColumnSpan | 3 | 속성 ColumnSpan 설정 |  |  |  |
| AC-cbeb5db6 | FindButton 외 1 | SCP0112_CellTraySimulation.cs:447 | try ▸ if (dsBinding.Tables.Count > 0 && dsBinding.Tables[0].Rows.Count > 0) ▸ for (iRow < siMain.ActiveSheet.Rows.Count) ▸ if (!isBoh.ToUppe… | UI_PROP | cells.ForeColor | Color.Black | 속성 ForeColor 설정 |  |  |  |
| AC-f548ba6e | FindButton 외 1 | SCP0112_CellTraySimulation.cs:449 | try ▸ if (dsBinding.Tables.Count > 0 && dsBinding.Tables[0].Rows.Count > 0) ▸ for (iRow < siMain.ActiveSheet.Rows.Count) ▸ if (!isBoh.ToUppe… | UI_PROP | cells.HorizontalAlignment | CellHorizontalAlignment.Center | 속성 HorizontalAlignment 설정 |  |  |  |
| AC-bc8d285c | FindButton 외 1 | SCP0112_CellTraySimulation.cs:459 | try ▸ if (dsBinding.Tables.Count > 0 && dsBinding.Tables[0].Rows.Count > 0) ▸ for (iRow < siMain.ActiveSheet.Rows.Count) ▸ if (measure_Value… | UI_PROP | range1.BackColor | Color.FromArgb(Convert.ToInt32(215), Convert.ToInt32(227), Convert.ToInt32(187)) | 속성 BackColor 설정 |  |  |  |
| AC-b568c235 | FindButton 외 1 | SCP0112_CellTraySimulation.cs:462 | try ▸ if (dsBinding.Tables.Count > 0 && dsBinding.Tables[0].Rows.Count > 0) ▸ for (iRow < siMain.ActiveSheet.Rows.Count) ▸ if (measure_Value… | GRID_STYLE | siMain.SetFontBold | (iRow, siMain.GetColumnIndex(DefMain.BOH_QTY), iRow, siMain.ActiveSheet.ColumnCount - 1, t… | 그리드 표시 설정 |  |  |  |
| AC-0fbf1439 | FindButton 외 1 | SCP0112_CellTraySimulation.cs:469 | try ▸ if (dsBinding.Tables.Count > 0 && dsBinding.Tables[0].Rows.Count > 0) ▸ for (iRow < siMain.ActiveSheet.Rows.Count) ▸ if (measure_Value… | VALUE_CLEAR | cells.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-9db04c55 | FindButton 외 1 | SCP0112_CellTraySimulation.cs:478 | try ▸ if (dsBinding.Tables.Count > 0 && dsBinding.Tables[0].Rows.Count > 0) | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-b848f272 | FindButton 외 1 | SCP0112_CellTraySimulation.cs:480 | try ▸ if (dsBinding.Tables.Count > 0 && dsBinding.Tables[0].Rows.Count > 0) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-7b0ec3aa | FindButton 외 1 | SCP0112_CellTraySimulation.cs:484 | try ▸ if (dsBinding.Tables.Count > 0 && dsBinding.Tables[0].Rows.Count > 0) | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0c0c59bc | FindButton 외 1 | SCP0112_CellTraySimulation.cs:489 | catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-3afa8c87 | FindButton 외 1 | SCP0112_CellTraySimulation.cs:490 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0f0ee7db | FindButton 외 1 | SCP0112_CellTraySimulation.cs:494 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-bf9030e0 | FindButton 외 1 | SCP0112_CellTraySimulation.cs:495 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## SCP0112_CellTraySimulation.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-10dd24dd | this.Load | SCP0112_CellTraySimulation.cs:114 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCP0112_CellTraySimulation.GetDayRange

진입점: this.Load / cboPlanDate.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-deaadd89 | this.Load 외 1 | SCP0112_CellTraySimulation.cs:698 |  | CALL_EXT | DateUtil.GetDayRange | (cboDivision.ControlValues, BucketType.Weekly, cboPlanDate.ControlValues) | ⚠ 의미 확인 필요 |  |  |  |
| AC-8c1790a4 | this.Load 외 1 | SCP0112_CellTraySimulation.cs:712 |  | RETURN | return sDayRange; |  | 처리 중단/반환 |  |  |  |

## SCP0112_CellTraySimulation.GetSpdTitle

진입점: this.Load / FindButton / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0) ▸ try ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dc1dfe6f | this.Load 외 2 | SCP0112_CellTraySimulation.cs:686 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN") ⇒ SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | 엔드포인트 요청 생성 |  |  |  |
| AC-0d7407e0 | this.Load 외 2 | SCP0112_CellTraySimulation.cs:687 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | dCalendar.Text1.Replace("-", "") | 행/컬럼 값 대입 |  |  |  |
| AC-d03cc6a9 | this.Load 외 2 | SCP0112_CellTraySimulation.cs:688 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | dCalendar.Text2.Replace("-", "") | 행/컬럼 값 대입 |  |  |  |
| AC-0fc5e49b | this.Load 외 2 | SCP0112_CellTraySimulation.cs:690 |  | FLAG | dsSpdTitle | client.ExecuteDataSet(request).DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-eaa4883c | this.Load 외 2 | SCP0112_CellTraySimulation.cs:690 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## SCP0112_CellTraySimulation.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e8afdbec | this.Load | SCP0112_CellTraySimulation.cs:133 | if (dtDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |
| AC-6c0ba148 | this.Load | SCP0112_CellTraySimulation.cs:136 |  | DATA_OP | this.ConditionNotUseList.Add | (cboPlanDate) | 데이터 객체 조작/조회 |  |  |  |
| AC-78395875 | this.Load | SCP0112_CellTraySimulation.cs:137 |  | DATA_OP | this.ConditionNotUseList.Add | (cboPlanType) | 데이터 객체 조작/조회 |  |  |  |
| AC-4e426a87 | this.Load | SCP0112_CellTraySimulation.cs:139 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-140c66d9 | this.Load | SCP0112_CellTraySimulation.cs:141 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, cboDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-04e2c51c | this.Load | SCP0112_CellTraySimulation.cs:144 |  | VALUE_SET | cboDivision.SelectedValue | "82" | 컨트롤 값 설정 |  |  |  |
| AC-201b3fba | this.Load | SCP0112_CellTraySimulation.cs:145 |  | STATE | cboDivision.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-d280e0b6 | this.Load | SCP0112_CellTraySimulation.cs:148 |  | CALL_EXT | DBUtils.GetAndFilterString | (new List<string>() { DefMain.DIVISION_ID, DefMain.OPERATION_GROUP }, new List<string>() {… | ⚠ 의미 확인 필요 |  |  |  |
| AC-54e402a8 | this.Load | SCP0112_CellTraySimulation.cs:149 |  | FLAG | dtToSite | DBUtils.Filter(dtToSiteAll, filter, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-a9827a92 | this.Load | SCP0112_CellTraySimulation.cs:149 |  | DATA_OP | DBUtils.Filter | (dtToSiteAll, filter, true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-29bd1f43 | this.Load | SCP0112_CellTraySimulation.cs:150 |  | LIST_REBIND | clsCtrl.setListBox | (dtToSite, cboToSite, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-174e36cc | this.Load | SCP0112_CellTraySimulation.cs:151 |  | VALUE_SET | cboToSite.SelectedValue | "KR32625300_82-P" | 컨트롤 값 설정 |  |  |  |
| AC-fbab86ca | this.Load | SCP0112_CellTraySimulation.cs:152 |  | STATE | cboToSite.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-b27327da | this.Load | SCP0112_CellTraySimulation.cs:156 |  | VALUE_SET | dCalendar.InitValue | GetDayRange() | 컨트롤 값 설정 |  |  |  |
| AC-b09db86e | this.Load | SCP0112_CellTraySimulation.cs:157 |  | STATE | dCalendar.Enabled | false | 컨트롤 상태 Enabled |  |  |  |

## SCP0112_CellTraySimulation.InitSpread

진입점: this.Load / FindButton / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0) ▸ try ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-32c05ea1 | this.Load 외 2 | SCP0112_CellTraySimulation.cs:173 |  | GRID_INIT | siMain.InitSheet | (siMain.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-0f4a65ba | this.Load 외 2 | SCP0112_CellTraySimulation.cs:178 |  | GRID_INIT | siMain.SetSheetHeaderColumn | (siMain, 2) | 그리드 재구성/초기화 |  |  |  |
| AC-a7c7b45f | this.Load 외 2 | SCP0112_CellTraySimulation.cs:181 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, 3, 2, 3, 20, "Measure", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-03df94a5 | this.Load 외 2 | SCP0112_CellTraySimulation.cs:187 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6c50ced0 | this.Load 외 2 | SCP0112_CellTraySimulation.cs:188 |  | GRID_INIT | siMain.VisibleTab | (false) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCP0112_CellTraySimulation.InitSpreadDateColumn

진입점: this.Load / FindButton / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0) ▸ try ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-42c60c4a | this.Load 외 2 | SCP0112_CellTraySimulation.cs:230 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sColumnName.IndexOf("D_") > 0) | GRID_INIT | spdInfo.AddNumColumn | (sColumnLabelname, sColumnName, FPMerge.None, 70, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7e3eaaaf | this.Load 외 2 | SCP0112_CellTraySimulation.cs:231 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sColumnName.IndexOf("D_") > 0) | GRID_INIT | spdInfo.SetReNumerCellType | (spdInfo, spdInfo.GetColumnIndex(sColumnName), -9999999999, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-8e438980 | this.Load 외 2 | SCP0112_CellTraySimulation.cs:237 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1e482b20 | this.Load 외 2 | SCP0112_CellTraySimulation.cs:243 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c9baa8d2 | this.Load 외 2 | SCP0112_CellTraySimulation.cs:252 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName != sSmallLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-dcc2a5f0 | this.Load 외 2 | SCP0112_CellTraySimulation.cs:263 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-14c62d83 | this.Load 외 2 | SCP0112_CellTraySimulation.cs:265 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0112_CellTraySimulation.RefreshPlanDate

진입점: this.Load [if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c4be08b5 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… | SCP0112_CellTraySimulation.cs:334 |  | FLAG | dtPlanDate | DBUtils.Filter(dtPlanDateAll, "DIVISION_ID = '" + division + "'", true) | 화면 필드/플래그 변경 |  |  |  |
| AC-056a64a2 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… | SCP0112_CellTraySimulation.cs:334 |  | DATA_OP | DBUtils.Filter | (dtPlanDateAll, "DIVISION_ID = '" + division + "'", true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-6033dc66 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… | SCP0112_CellTraySimulation.cs:335 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanDate, cboPlanDate, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0112_CellTraySimulation.RefreshPlanType

진입점: this.Load [if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-aedaf1b0 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… | SCP0112_CellTraySimulation.cs:343 |  | FLAG | dtPlanType | DBUtils.Filter(dtPlanTypeAll, "DIVISION_ID = '" + division + "' AND PLANDATE = '" + pPlanD… | 화면 필드/플래그 변경 |  |  |  |
| AC-9956ce69 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… | SCP0112_CellTraySimulation.cs:343 |  | DATA_OP | DBUtils.Filter | (dtPlanTypeAll, "DIVISION_ID = '" + division + "' AND PLANDATE = '" + pPlanDate + "'", tru… | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-d3bd3354 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… | SCP0112_CellTraySimulation.cs:344 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanType, cboPlanType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0112_CellTraySimulation.SaveData

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1c8ad423 | SaveButton | SCP0112_CellTraySimulation.cs:526 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-06460607 | SaveButton | SCP0112_CellTraySimulation.cs:572 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | DBUtils.Filter | (dtAll, sb.ToString(), true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-dbfca030 | SaveButton | SCP0112_CellTraySimulation.cs:597 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0) | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-e93d32ff | SaveButton | SCP0112_CellTraySimulation.cs:601 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0) ▸ try | ENDPOINT | new FoxDataRequest | ("SCP.SCP0112_SAVE_CELL_TRAY_SIMULATION") ⇒ SCP.SCP0112_SAVE_CELL_TRAY_SIMULATION | 엔드포인트 요청 생성 |  |  |  |
| AC-807583af | SaveButton | SCP0112_CellTraySimulation.cs:605 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0) ▸ try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, GSCM_SCP_ANALYS… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-d693cb14 | SaveButton | SCP0112_CellTraySimulation.cs:609 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0) ▸ try ▸ lambda | DATA_OP | request.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-4202f59c | SaveButton | SCP0112_CellTraySimulation.cs:610 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0) ▸ try ▸ lambda | DATA_OP | request.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-61e14ddf | SaveButton | SCP0112_CellTraySimulation.cs:611 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0) ▸ try ▸ lambda | DATA_OP | request.Parameters["p_to_site"] | p_to_site | 행/컬럼 값 대입 |  |  |  |
| AC-b9fd057a | SaveButton | SCP0112_CellTraySimulation.cs:612 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0) ▸ try ▸ lambda | DATA_OP | request.Parameters["p_measure_type"] | p_measure_type | 행/컬럼 값 대입 |  |  |  |
| AC-58dc91a5 | SaveButton | SCP0112_CellTraySimulation.cs:613 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0) ▸ try ▸ lambda | DATA_OP | request.Parameters["p_modiQty"] | p_modiQty | 행/컬럼 값 대입 |  |  |  |
| AC-a2ce7377 | SaveButton | SCP0112_CellTraySimulation.cs:614 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0) ▸ try ▸ lambda | DATA_OP | request.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-186ec6b5 | SaveButton | SCP0112_CellTraySimulation.cs:616 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0) ▸ try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-0a666615 | SaveButton | SCP0112_CellTraySimulation.cs:616 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0) ▸ try ▸ lambda | RETURN | return client.ExecuteDataSet(request); |  | 처리 중단/반환 |  |  |  |
| AC-7039f23c | SaveButton | SCP0112_CellTraySimulation.cs:620 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0) ▸ try | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-8b8aa5dd | SaveButton | SCP0112_CellTraySimulation.cs:627 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0) ▸ try ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { t.DataSet.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-879bb152 | SaveButton | SCP0112_CellTraySimulation.cs:635 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0) ▸ try ▸ if (t.Success) ▸ else of (t.DataSet.Tables[0].Rows… | MESSAGE | MessageHelper.GMessageBox | (errorMsg) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-442e4e98 | SaveButton | SCP0112_CellTraySimulation.cs:641 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0) ▸ catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-e77b0ab3 | SaveButton | SCP0112_CellTraySimulation.cs:642 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0) ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9de27539 | SaveButton | SCP0112_CellTraySimulation.cs:646 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0) ▸ finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0112_CellTraySimulation.SetChangedControl

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8c254690 | this.Load | SCP0112_CellTraySimulation.cs:357 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ if (dtPlanType.Rows.Count > 0) | VALUE_SET | cboPlanType.SelectedIndex | dtPlanType.Rows.Count - 1 | 컨트롤 값 설정 |  |  |  |

## SCP0112_CellTraySimulation.SetSpreadColumn

진입점: this.Load / FindButton [try ▸ if (dsBinding.Tables.Count > 0 && dsBinding.Tables[0].Rows.Count > 0)] / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0) ▸ try ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try ▸ if (dsBinding.Tables.Count > 0 && dsBinding.Tables[0].Rows.Count > 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b427e9fc | this.Load 외 2 | SCP0112_CellTraySimulation.cs:512 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ if (siObj.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siObj.GetColumnTag(iCol).IndexOf("M_") == 0) | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-8bce25f3 | this.Load 외 2 | SCP0112_CellTraySimulation.cs:516 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (siObj.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siObj.GetColumnTag(iCol).IndexOf("M_") =… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |

## SCP0112_CellTraySimulation.SpdMain_TopChange

진입점: this.spdMain.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-16c6edcd | this.spdMain.TopChange | SCP0112_CellTraySimulation.cs:280 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

