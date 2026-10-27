# AS-IS 액션 대조표 — SCP0059

> 원천: `Doc/asisfacts/screens/SCP0059/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 877행 · 메서드 70 · 종류 DATA_OP 436 · GRID_INIT 68 · RETURN 60 · UI_PROP 41 · GRID_SET 35 · MESSAGE 31 · FLAG 30 · CALL_EXT 25 · ENDPOINT 25 · UI_MISC 22 · POPUP 17 · VALUE_SET 16 · GRID_LOCK 14 · COMBO_DATA 14 · LIST_REBIND 13 · STATE 13 · GRID_STYLE 6 · GRID_CLEAR 3 · VALIDATE 3 · GRID_BIND 2 · STATE_RESET 2 · VALUE_CLEAR 1 · ⚠ 의미 확인 필요 25


## Calc_Measure..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-36791267 | .ctor | SCP0059_Shipment_Plan_SEMI_JV.cs:4269 |  | FLAG | this._header_last_idx | header_last_idx | 화면 필드/플래그 변경 |  |  |  |
| AC-21735ecb | .ctor | SCP0059_Shipment_Plan_SEMI_JV.cs:4274 | foreach (var item in list) | DATA_OP | _inputMeasure.Add | (item, new List<int>()) | 데이터 객체 조작/조회 |  |  |  |

## Calc_Measure.RetDoubleValue

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3fa9b21b | (진입점 미연결) | SCP0059_Shipment_Plan_SEMI_JV.cs:4491 |  | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |

## Calc_Measure.RetIntValue

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e7fdc590 | (진입점 미연결) | SCP0059_Shipment_Plan_SEMI_JV.cs:4473 |  | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |

## Calc_Measure.RetLongValue

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b3e2624c | (진입점 미연결) | SCP0059_Shipment_Plan_SEMI_JV.cs:4480 | if (obj.ToString() != "" && obj != null && obj != DBNull.Value) | CALL_EXT | Convert.ToInt64 | (obj) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c1760cfa | (진입점 미연결) | SCP0059_Shipment_Plan_SEMI_JV.cs:4482 |  | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |

## Calc_Measure.SetCalcMeasure

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-18ec03ba | (진입점 미연결) | SCP0059_Shipment_Plan_SEMI_JV.cs:4340 | for (col < dtBinding.Columns.Count) ▸ for (iRow < end_row) ▸ if (measure_name.Equals("INVENTORY")) ▸ if (dtBinding.Columns[col].ColumnName.I… | GRID_SET | dtBinding.Rows[iRow][bef_Month_Idx] | sum | 그리드 속성/값 설정 |  |  |  |
| AC-1bd30e4c | (진입점 미연결) | SCP0059_Shipment_Plan_SEMI_JV.cs:4347 | for (col < dtBinding.Columns.Count) ▸ for (iRow < end_row) ▸ if (measure_name.Equals("INVENTORY")) ▸ if (dtBinding.Columns[col].ColumnName.I… | GRID_SET | dtBinding.Rows[iRow][col] | sum | 그리드 속성/값 설정 |  |  |  |
| AC-3ae6564e | (진입점 미연결) | SCP0059_Shipment_Plan_SEMI_JV.cs:4367 | for (col < dtBinding.Columns.Count) ▸ for (iRow < end_row) ▸ if (measure_name.Equals("INVENTORY")) ▸ else of (dtBinding.Columns[col].ColumnN… | GRID_SET | dtBinding.Rows[iRow][bef_Week_idx] | sum | 그리드 속성/값 설정 |  |  |  |
| AC-bb8bc658 | (진입점 미연결) | SCP0059_Shipment_Plan_SEMI_JV.cs:4374 | for (col < dtBinding.Columns.Count) ▸ for (iRow < end_row) ▸ if (measure_name.Equals("INVENTORY")) ▸ else of (dtBinding.Columns[col].ColumnN… | GRID_SET | dtBinding.Rows[iRow][col] | sum | 그리드 속성/값 설정 |  |  |  |
| AC-d4732f58 | (진입점 미연결) | SCP0059_Shipment_Plan_SEMI_JV.cs:4400 | for (col < dtBinding.Columns.Count) ▸ for (iRow < end_row) ▸ if (measure_name.Equals("INVENTORY")) ▸ else of (dtBinding.Columns[col].ColumnN… | GRID_SET | dtBinding.Rows[iRow][col] | sum | 그리드 속성/값 설정 |  |  |  |
| AC-7e36035e | (진입점 미연결) | SCP0059_Shipment_Plan_SEMI_JV.cs:4416 | for (col < dtBinding.Columns.Count) ▸ for (iRow < end_row) ▸ if (measure_name.Equals("INVENTORY")) ▸ else of (dtBinding.Columns[col].ColumnN… | GRID_SET | dtBinding.Rows[iRow][bef_Week_idx] | last_sum | 그리드 속성/값 설정 |  |  |  |
| AC-de291b15 | (진입점 미연결) | SCP0059_Shipment_Plan_SEMI_JV.cs:4423 | for (col < dtBinding.Columns.Count) ▸ for (iRow < end_row) ▸ if (measure_name.Equals("INVENTORY")) ▸ else of (dtBinding.Columns[col].ColumnN… | GRID_SET | dtBinding.Rows[iRow][col] | last_sum | 그리드 속성/값 설정 |  |  |  |
| AC-32c53d78 | (진입점 미연결) | SCP0059_Shipment_Plan_SEMI_JV.cs:4436 | for (col < dtBinding.Columns.Count) ▸ for (iRow < end_row) ▸ else of (measure_name.Equals("INVENTORY")) ▸ if (to_site_name.Length > 2) | DATA_OP | _inputMeasure[measure_name].Add | (iRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-2c1513c6 | (진입점 미연결) | SCP0059_Shipment_Plan_SEMI_JV.cs:4456 | for (col < dtBinding.Columns.Count) ▸ for (iRow < end_row) ▸ else of (measure_name.Equals("INVENTORY")) ▸ else of (to_site_name.Length > 2) | GRID_SET | dtBinding.Rows[iRow][col] | sum | 그리드 속성/값 설정 |  |  |  |
| AC-742275fb | (진입점 미연결) | SCP0059_Shipment_Plan_SEMI_JV.cs:4457 | for (col < dtBinding.Columns.Count) ▸ for (iRow < end_row) ▸ else of (measure_name.Equals("INVENTORY")) ▸ else of (to_site_name.Length > 2) | CALL_EXT | _inputMeasure[measure_name].Clear | () | ⚠ 의미 확인 필요 |  |  |  |

## SCP0059_Shipment_Plan_SEMI_JV.BlockCellsChecking

진입점: this.spdMain.CellClick [if ((e.Column == siMain.GetColumnIndex(DefMain.TRANSPORT_MODE) \|\| e.Column == siMain.GetColumnIndex(DefMain.TO_SITE_DESCRIPT…)] / EditButton [if (fps != null) ▸ if (this.IsEditMode) ▸ if (EditBlockChecking(2) != 1)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-948263a1 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… 외 1 | SCP0059_Shipment_Plan_SEMI_JV.cs:2650 | for (iRow < siMain.ActiveSheet.RowCount) ▸ if (siMain.GetValue(iRow, measure_idx).Equals("SHIP_PLAN_AMEND") && siMain.GetValue(iRow, site_id… | GRID_LOCK | siMain.LockRange | (iRow, 1, iRow, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-624f0a42 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… 외 1 | SCP0059_Shipment_Plan_SEMI_JV.cs:2672 | for (iRow < siMain.ActiveSheet.RowCount) ▸ if (siMain.GetValue(iRow, measure_idx).Equals("SHIP_PLAN_AMEND") && siMain.GetValue(iRow, site_id… | CALL_EXT | frozenDate.CompareTo | (dtBodTo) | ⚠ 의미 확인 필요 |  |  |  |
| AC-031c62d8 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… 외 1 | SCP0059_Shipment_Plan_SEMI_JV.cs:2674 | for (iRow < siMain.ActiveSheet.RowCount) ▸ if (siMain.GetValue(iRow, measure_idx).Equals("SHIP_PLAN_AMEND") && siMain.GetValue(iRow, site_id… | GRID_LOCK | siMain.LockRange | (iRow, 1, iRow, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-5f7f805c | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… 외 1 | SCP0059_Shipment_Plan_SEMI_JV.cs:2678 | for (iRow < siMain.ActiveSheet.RowCount) ▸ if (siMain.GetValue(iRow, measure_idx).Equals("SHIP_PLAN_AMEND") && siMain.GetValue(iRow, site_id… | CALL_EXT | dtBodFrom.CompareTo | (frozenDate) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d9231ec1 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… 외 1 | SCP0059_Shipment_Plan_SEMI_JV.cs:2686 | for (iRow < siMain.ActiveSheet.RowCount) ▸ if (siMain.GetValue(iRow, measure_idx).Equals("SHIP_PLAN_AMEND") && siMain.GetValue(iRow, site_id… | CALL_EXT | frozenDate.CompareTo | (dtBodFrom) | ⚠ 의미 확인 필요 |  |  |  |
| AC-018418e5 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… 외 1 | SCP0059_Shipment_Plan_SEMI_JV.cs:2686 | for (iRow < siMain.ActiveSheet.RowCount) ▸ if (siMain.GetValue(iRow, measure_idx).Equals("SHIP_PLAN_AMEND") && siMain.GetValue(iRow, site_id… | CALL_EXT | dtBodTo.CompareTo | (frozenDate) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b2a5b308 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… 외 1 | SCP0059_Shipment_Plan_SEMI_JV.cs:2711 | for (iRow < siMain.ActiveSheet.RowCount) ▸ if (siMain.GetValue(iRow, measure_idx).Equals("SHIP_PLAN_AMEND") && siMain.GetValue(iRow, site_id… | DATA_OP | lstBlockWeek_Month.Add | (iCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-d6e48432 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… 외 1 | SCP0059_Shipment_Plan_SEMI_JV.cs:2731 | for (iRow < siMain.ActiveSheet.RowCount) ▸ if (siMain.GetValue(iRow, measure_idx).Equals("SHIP_PLAN_AMEND") && siMain.GetValue(iRow, site_id… | GRID_LOCK | siMain.LockRange | (iRow, 1, iRow, nBlockColumnEnd, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-7c91c645 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… 외 1 | SCP0059_Shipment_Plan_SEMI_JV.cs:2732 | for (iRow < siMain.ActiveSheet.RowCount) ▸ if (siMain.GetValue(iRow, measure_idx).Equals("SHIP_PLAN_AMEND") && siMain.GetValue(iRow, site_id… | GRID_LOCK | siMain.LockRange | (iRow, nBlockColumnEnd + 1, iRow, siMain.GetMaxColumnIndex(), false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-16b150fb | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… 외 1 | SCP0059_Shipment_Plan_SEMI_JV.cs:2736 | for (iRow < siMain.ActiveSheet.RowCount) ▸ if (siMain.GetValue(iRow, measure_idx).Equals("SHIP_PLAN_AMEND") && siMain.GetValue(iRow, site_id… | GRID_LOCK | siMain.LockRange | (iRow, 1, iRow, nBlockColumnEnd, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-91707dc7 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… 외 1 | SCP0059_Shipment_Plan_SEMI_JV.cs:2737 | for (iRow < siMain.ActiveSheet.RowCount) ▸ if (siMain.GetValue(iRow, measure_idx).Equals("SHIP_PLAN_AMEND") && siMain.GetValue(iRow, site_id… | GRID_LOCK | siMain.LockRange | (iRow, nBlockColumnEnd + 1, iRow, iBlockLastIdx, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-5396c6fd | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… 외 1 | SCP0059_Shipment_Plan_SEMI_JV.cs:2738 | for (iRow < siMain.ActiveSheet.RowCount) ▸ if (siMain.GetValue(iRow, measure_idx).Equals("SHIP_PLAN_AMEND") && siMain.GetValue(iRow, site_id… | GRID_LOCK | siMain.LockRange | (iRow, iBlockLastIdx + 1, iRow, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-1008ddf7 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… 외 1 | SCP0059_Shipment_Plan_SEMI_JV.cs:2747 | for (iRow < siMain.ActiveSheet.RowCount) ▸ if (siMain.GetValue(iRow, measure_idx).Equals("SHIP_PLAN_AMEND") && siMain.GetValue(iRow, site_id… | GRID_LOCK | siMain.LockRange2 | (iRow, col, iRow, col, true) | 그리드 편집 잠금 전환 |  |  |  |
| AC-07916f6b | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… 외 1 | SCP0059_Shipment_Plan_SEMI_JV.cs:2749 | for (iRow < siMain.ActiveSheet.RowCount) ▸ if (siMain.GetValue(iRow, measure_idx).Equals("SHIP_PLAN_AMEND") && siMain.GetValue(iRow, site_id… | UI_MISC | spdMain.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-15a75937 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… 외 1 | SCP0059_Shipment_Plan_SEMI_JV.cs:2753 | for (iRow < siMain.ActiveSheet.RowCount) ▸ else of (siMain.GetValue(iRow, measure_idx).Equals("SHIP_PLAN_AMEND") && siMain.GetValue(iRow, si… | GRID_LOCK | siMain.LockRange | (iRow, 1, iRow, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |

## SCP0059_Shipment_Plan_SEMI_JV.BtnFix_Click

진입점: this.btnFix.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-289375d1 | this.btnFix.Click | SCP0059_Shipment_Plan_SEMI_JV.cs:4076 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-2157325c | this.btnFix.Click | SCP0059_Shipment_Plan_SEMI_JV.cs:4077 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-79f326f2 | this.btnFix.Click | SCP0059_Shipment_Plan_SEMI_JV.cs:4083 | if (siMain.IsLock(siMain.SheetName)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00010") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-80719b00 | this.btnFix.Click | SCP0059_Shipment_Plan_SEMI_JV.cs:4087 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (!Get_IsSaveYn()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0059_Shipment_Plan_SEMI_JV.BtnItem_Id_Click

진입점: this.btnItem_Id.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7d0e7121 | this.btnItem_Id.Click | SCP0059_Shipment_Plan_SEMI_JV.cs:4053 |  | CALL_EXT | UIUtils.GetAllDivisionCheckedElectrode | (cboDivision) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b446c8a2 | this.btnItem_Id.Click | SCP0059_Shipment_Plan_SEMI_JV.cs:4055 |  | POPUP | new SCM0002_ItembyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-f7918281 | this.btnItem_Id.Click | SCP0059_Shipment_Plan_SEMI_JV.cs:4057 |  | POPUP | popItem.Form_Load | (true, division, sScmSite, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-975a8d0d | this.btnItem_Id.Click | SCP0059_Shipment_Plan_SEMI_JV.cs:4058 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-8f8c8c03 | this.btnItem_Id.Click | SCP0059_Shipment_Plan_SEMI_JV.cs:4059 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-44d6ae78 | this.btnItem_Id.Click | SCP0059_Shipment_Plan_SEMI_JV.cs:4065 | if (popItem.ItemID != "") | VALUE_SET | txtItemId.Text | sItemId | 컨트롤 값 설정 |  |  |  |

## SCP0059_Shipment_Plan_SEMI_JV.btnMeasure_Click

진입점: this.btnMeasure.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-466cc100 | this.btnMeasure.Click | SCP0059_Shipment_Plan_SEMI_JV.cs:3973 |  | POPUP | new SCM0002_TitleSetForm_Popup | ("SCP0010", measureType, false) | 팝업/폼 생성 |  |  |  |
| AC-43ea512d | this.btnMeasure.Click | SCP0059_Shipment_Plan_SEMI_JV.cs:3974 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-254221f0 | this.btnMeasure.Click | SCP0059_Shipment_Plan_SEMI_JV.cs:3975 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-58f35027 | this.btnMeasure.Click | SCP0059_Shipment_Plan_SEMI_JV.cs:3979 | if (frm.DialogResult == DialogResult.OK) | UI_PROP | this.CanModelChange | false | 속성 CanModelChange 설정 |  |  |  |
| AC-24bb8471 | this.btnMeasure.Click | SCP0059_Shipment_Plan_SEMI_JV.cs:3982 | if (frm.DialogResult == DialogResult.OK) | UI_PROP | this.CanModelChange | true | 속성 CanModelChange 설정 |  |  |  |

## SCP0059_Shipment_Plan_SEMI_JV.BtnNew_Click

진입점: this.btnNew.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fca9382d | this.btnNew.Click | SCP0059_Shipment_Plan_SEMI_JV.cs:4125 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ea78a420 | this.btnNew.Click | SCP0059_Shipment_Plan_SEMI_JV.cs:4126 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-46f15f7d | this.btnNew.Click | SCP0059_Shipment_Plan_SEMI_JV.cs:4130 | if (cboPlanDate.ControlValues == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-fc8c315c | this.btnNew.Click | SCP0059_Shipment_Plan_SEMI_JV.cs:4131 | if (!Get_IsSaveYn()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8dd90396 | this.btnNew.Click | SCP0059_Shipment_Plan_SEMI_JV.cs:4141 |  | POPUP | new SCM0002_ShipmentPlanInsertPopup | () | 팝업/폼 생성 |  |  |  |
| AC-b06cb154 | this.btnNew.Click | SCP0059_Shipment_Plan_SEMI_JV.cs:4142 |  | UI_PROP | popup.divisionId | division | 속성 divisionId 설정 |  |  |  |
| AC-04990839 | this.btnNew.Click | SCP0059_Shipment_Plan_SEMI_JV.cs:4143 |  | UI_PROP | popup.p_operationGroup | sOperationGroup | 속성 p_operationGroup 설정 |  |  |  |
| AC-1c0589ba | this.btnNew.Click | SCP0059_Shipment_Plan_SEMI_JV.cs:4144 |  | UI_PROP | popup.p_planDate | dPlanDate | 속성 p_planDate 설정 |  |  |  |
| AC-3f7b0ee3 | this.btnNew.Click | SCP0059_Shipment_Plan_SEMI_JV.cs:4145 |  | UI_PROP | popup.p_plan_start_yyyymmdd | sPlanStartYyyymmdd | 속성 p_plan_start_yyyymmdd 설정 |  |  |  |
| AC-87be8745 | this.btnNew.Click | SCP0059_Shipment_Plan_SEMI_JV.cs:4146 |  | UI_PROP | popup.p_planType | sPlanType | 속성 p_planType 설정 |  |  |  |
| AC-3d7ebc13 | this.btnNew.Click | SCP0059_Shipment_Plan_SEMI_JV.cs:4147 |  | UI_PROP | popup.p_seq | sSeq | 속성 p_seq 설정 |  |  |  |
| AC-c5381442 | this.btnNew.Click | SCP0059_Shipment_Plan_SEMI_JV.cs:4148 |  | UI_PROP | popup.p_user_id | UserInfo.UserId | 속성 p_user_id 설정 |  |  |  |
| AC-9edd0a0b | this.btnNew.Click | SCP0059_Shipment_Plan_SEMI_JV.cs:4149 |  | UI_PROP | popup.p_prgram_id | sPrg | 속성 p_prgram_id 설정 |  |  |  |
| AC-49896f38 | this.btnNew.Click | SCP0059_Shipment_Plan_SEMI_JV.cs:4151 |  | UI_PROP | popup.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-4d6cdbbd | this.btnNew.Click | SCP0059_Shipment_Plan_SEMI_JV.cs:4152 |  | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-95500fcc | this.btnNew.Click | SCP0059_Shipment_Plan_SEMI_JV.cs:4162 | if (popup.DialogResult == DialogResult.OK) ▸ else of (division.Substring(0, 2).Equals("EE")) | VALUE_SET | txtItemId.Text | popup.s_ItemId | 컨트롤 값 설정 |  |  |  |
| AC-053166c1 | this.btnNew.Click | SCP0059_Shipment_Plan_SEMI_JV.cs:4165 | if (popup.DialogResult == DialogResult.OK) ▸ else of (division.Substring(0, 2).Equals("EE")) | MESSAGE | MessageHelper.GMessageBox | ("MSG00265") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SCP0059_Shipment_Plan_SEMI_JV.BtnUnfix_Click

진입점: this.btnUnfix.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-94b74942 | this.btnUnfix.Click | SCP0059_Shipment_Plan_SEMI_JV.cs:4099 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-bc279d26 | this.btnUnfix.Click | SCP0059_Shipment_Plan_SEMI_JV.cs:4100 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-346b91ce | this.btnUnfix.Click | SCP0059_Shipment_Plan_SEMI_JV.cs:4106 | if (siMain.IsLock(siMain.SheetName)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00010") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0c7fd701 | this.btnUnfix.Click | SCP0059_Shipment_Plan_SEMI_JV.cs:4110 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (!Get_IsSaveYn()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-28aa0fc2 | this.btnUnfix.Click | SCP0059_Shipment_Plan_SEMI_JV.cs:4111 | else of (siMain.IsLock(siMain.SheetName)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00016") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SCP0059_Shipment_Plan_SEMI_JV.BtnW26_Click

진입점: this.btnW26.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-531f1cc2 | this.btnW26.Click | SCP0059_Shipment_Plan_SEMI_JV.cs:4177 |  | VALUE_SET | drpPeriod.InitValue | GetDayRange(PeriodType.W26) | 컨트롤 값 설정 |  |  |  |

## SCP0059_Shipment_Plan_SEMI_JV.BtnW52_Click

진입점: this.btnW52.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9ce2c71a | this.btnW52.Click | SCP0059_Shipment_Plan_SEMI_JV.cs:4182 |  | VALUE_SET | drpPeriod.InitValue | GetDayRange(PeriodType.W52) | 컨트롤 값 설정 |  |  |  |

## SCP0059_Shipment_Plan_SEMI_JV.BtnWLast_Click

진입점: this.btnWLast.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8128aa1e | this.btnWLast.Click | SCP0059_Shipment_Plan_SEMI_JV.cs:4192 |  | VALUE_SET | drpPeriod.InitValue | GetDayRange(sPeriod) | 컨트롤 값 설정 |  |  |  |

## SCP0059_Shipment_Plan_SEMI_JV.CalculateSum

진입점: dsdm.Changed [try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (strColName.IndexOf("W_") == 0) ▸ if (strColName.IndexOf("D_") == 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3faad2c4 | dsdm.Changed [try ▸ switch (e.Type) case FarPoint.Win.Spread… | SCP0059_Shipment_Plan_SEMI_JV.cs:3621 | for (nCol < dt.Columns.Count) ▸ if (dt.Columns[nCol].ColumnName.IndexOf("M_") == 0) | DATA_OP | listMonth.Add | (nCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-a4ac4186 | dsdm.Changed [try ▸ switch (e.Type) case FarPoint.Win.Spread… | SCP0059_Shipment_Plan_SEMI_JV.cs:3625 | for (nCol < dt.Columns.Count) ▸ if (dt.Columns[nCol].ColumnName.IndexOf("W_") == 0) | DATA_OP | listWeek.Add | (nCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-ed7d046f | dsdm.Changed [try ▸ switch (e.Type) case FarPoint.Win.Spread… | SCP0059_Shipment_Plan_SEMI_JV.cs:3664 | for (nCol < dt.Columns.Count) ▸ if (nCol == dt.Columns.Count - 1 \|\| dt.Columns[nCol].ColumnName.IndexOf("W_") == 0) | DATA_OP | dr[nIdxWeek] | weekSum | 행/컬럼 값 대입 |  |  |  |
| AC-c085edca | dsdm.Changed [try ▸ switch (e.Type) case FarPoint.Win.Spread… | SCP0059_Shipment_Plan_SEMI_JV.cs:3673 | for (nCol < dt.Columns.Count) ▸ if (nCol == dt.Columns.Count - 1 \|\| dt.Columns[nCol].ColumnName.IndexOf("M_") == 0) | DATA_OP | dr[nIdxMonth] | monthSum | 행/컬럼 값 대입 |  |  |  |
| AC-92fa54f6 | dsdm.Changed [try ▸ switch (e.Type) case FarPoint.Win.Spread… | SCP0059_Shipment_Plan_SEMI_JV.cs:3680 |  | DATA_OP | dt.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |

## SCP0059_Shipment_Plan_SEMI_JV.CboDivision_SelectedIndexChanged

진입점: cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b4442d20 | cboDivision.SelectedIndexChanged | SCP0059_Shipment_Plan_SEMI_JV.cs:4041 |  | VALUE_SET | btnWLast.Text | "W" + dailyPlanPeriod | 컨트롤 값 설정 |  |  |  |

## SCP0059_Shipment_Plan_SEMI_JV.cboOperGrp_SelectedIndexChanged

진입점: this.cboOperGroup.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ea4e1894 | this.cboOperGroup.SelectedIndexChanged | SCP0059_Shipment_Plan_SEMI_JV.cs:3914 |  | FLAG | this._curSheetName | cboOperGroup.Text.ToUpper() | 화면 필드/플래그 변경 |  |  |  |

## SCP0059_Shipment_Plan_SEMI_JV.CboPlanDate_SelectedIndexChanged

진입점: cboPlanDate.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-606acc2d | cboPlanDate.SelectedIndexChanged | SCP0059_Shipment_Plan_SEMI_JV.cs:4021 |  | FLAG | dtPlanType | Data.Common(Data.Type.PlanType, false, division, pPlanDate) ⇒ biz:CommonData.CommonDataList [code=PlanType] | 화면 필드/플래그 변경 |  |  |  |
| AC-7df5c3ae | cboPlanDate.SelectedIndexChanged | SCP0059_Shipment_Plan_SEMI_JV.cs:4021 |  | COMBO_DATA | Data.Common | (Data.Type.PlanType, false, division, pPlanDate) ⇒ biz:CommonData.CommonDataList [code=PlanType] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ed3eeea4 | cboPlanDate.SelectedIndexChanged | SCP0059_Shipment_Plan_SEMI_JV.cs:4022 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanType, cboPlanType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-b848a13e | cboPlanDate.SelectedIndexChanged | SCP0059_Shipment_Plan_SEMI_JV.cs:4026 |  | VALUE_SET | cboPlanType.SelectedIndex | dtPlanType.Rows.Count - 1 | 컨트롤 값 설정 |  |  |  |
| AC-cddcff9d | cboPlanDate.SelectedIndexChanged | SCP0059_Shipment_Plan_SEMI_JV.cs:4029 |  | VALUE_SET | drpPeriod.InitValue | GetDayRange(PeriodType.W52) | 컨트롤 값 설정 |  |  |  |
| AC-11a01b2b | cboPlanDate.SelectedIndexChanged | SCP0059_Shipment_Plan_SEMI_JV.cs:4030 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |

## SCP0059_Shipment_Plan_SEMI_JV.CboPlanSeq_SelectedIndexChanged

진입점: cboPlanSeq.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-28ed60aa | cboPlanSeq.SelectedIndexChanged | SCP0059_Shipment_Plan_SEMI_JV.cs:544 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |

## SCP0059_Shipment_Plan_SEMI_JV.CboPlanType_SelectedIndexChanged

진입점: cboPlanType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0f5d618a | cboPlanType.SelectedIndexChanged | SCP0059_Shipment_Plan_SEMI_JV.cs:4005 |  | FLAG | dtPlanSeq | Data.Common(Data.Type.PlanSeq, false, division, pPlanDate, pPlanType) ⇒ biz:CommonData.CommonDataList [code=PlanSeq] | 화면 필드/플래그 변경 |  |  |  |
| AC-d43fdbb1 | cboPlanType.SelectedIndexChanged | SCP0059_Shipment_Plan_SEMI_JV.cs:4005 |  | COMBO_DATA | Data.Common | (Data.Type.PlanSeq, false, division, pPlanDate, pPlanType) ⇒ biz:CommonData.CommonDataList [code=PlanSeq] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-a43d422b | cboPlanType.SelectedIndexChanged | SCP0059_Shipment_Plan_SEMI_JV.cs:4006 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanSeq, cboPlanSeq, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-1bf072ee | cboPlanType.SelectedIndexChanged | SCP0059_Shipment_Plan_SEMI_JV.cs:4008 |  | VALUE_SET | cboPlanSeq.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-3ef057e8 | cboPlanType.SelectedIndexChanged | SCP0059_Shipment_Plan_SEMI_JV.cs:4011 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |

## SCP0059_Shipment_Plan_SEMI_JV.CreateBindingDataSet

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d6f48120 | (진입점 미연결) | SCP0059_Shipment_Plan_SEMI_JV.cs:1717 | if (dtQty.Rows.Count == 0) | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-fbcc3500 | (진입점 미연결) | SCP0059_Shipment_Plan_SEMI_JV.cs:1725 |  | DATA_OP | dtBinding.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-9170b8f7 | (진입점 미연결) | SCP0059_Shipment_Plan_SEMI_JV.cs:1726 |  | DATA_OP | ds.Tables.Add | (dtBinding) | 데이터 객체 조작/조회 |  |  |  |
| AC-7d8f49b1 | (진입점 미연결) | SCP0059_Shipment_Plan_SEMI_JV.cs:1727 |  | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |

## SCP0059_Shipment_Plan_SEMI_JV.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7cec459a | this.Load | SCP0059_Shipment_Plan_SEMI_JV.cs:313 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 3, 1, 20) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-ae8bbe94 | this.Load | SCP0059_Shipment_Plan_SEMI_JV.cs:314 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-69bf2381 | this.Load | SCP0059_Shipment_Plan_SEMI_JV.cs:315 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0059_Shipment_Plan_SEMI_JV.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a097e4f6 | this.Load | SCP0059_Shipment_Plan_SEMI_JV.cs:232 |  | UI_PROP | pnlCondition.Height | 100 | 속성 Height 설정 |  |  |  |
| AC-aeca9c0d | this.Load | SCP0059_Shipment_Plan_SEMI_JV.cs:236 |  | DATA_OP | dicSubSumItems.Add | ("SHIP_PLAN", new List<int>()) | 데이터 객체 조작/조회 |  |  |  |
| AC-f16de603 | this.Load | SCP0059_Shipment_Plan_SEMI_JV.cs:237 |  | DATA_OP | dicSubSumItems.Add | ("SHIP_REQ", new List<int>()) | 데이터 객체 조작/조회 |  |  |  |
| AC-d8e5def4 | this.Load | SCP0059_Shipment_Plan_SEMI_JV.cs:238 |  | DATA_OP | dicSubSumItems.Add | ("SHIP_PLAN_AMEND", new List<int>()) | 데이터 객체 조작/조회 |  |  |  |
| AC-e76b20cc | this.Load | SCP0059_Shipment_Plan_SEMI_JV.cs:248 |  | DATA_OP | dicInputMeasure.Add | ("T", new SortedList<int, string> { { 1, "SHIP_REQ" }, { 2, "SHIP_PLAN" }, { 3, "SHIP_PLAN… | 데이터 객체 조작/조회 |  |  |  |
| AC-b16988b8 | this.Load | SCP0059_Shipment_Plan_SEMI_JV.cs:258 |  | DATA_OP | dicElecInputMeasure.Add | (1, new Dictionary<string, string> { { "SHIP_REQ_QTY", "Ship Req(Cell Qty)" } }) | 데이터 객체 조작/조회 |  |  |  |
| AC-5fb17069 | this.Load | SCP0059_Shipment_Plan_SEMI_JV.cs:259 |  | DATA_OP | dicElecInputMeasure.Add | (2, new Dictionary<string, string> { { "SHIP_PLAN_QTY", "Ship Plan(Cell Qty)" } }) | 데이터 객체 조작/조회 |  |  |  |
| AC-b3a2cca5 | this.Load | SCP0059_Shipment_Plan_SEMI_JV.cs:260 |  | DATA_OP | dicElecInputMeasure.Add | (3, new Dictionary<string, string> { { "SHIP_PLAN_AMEND_QTY", "Ship Plan Amend(Cell Qty)" … | 데이터 객체 조작/조회 |  |  |  |
| AC-31fbeec6 | this.Load | SCP0059_Shipment_Plan_SEMI_JV.cs:262 |  | DATA_OP | dicInputMeasure.Add | ("S", new SortedList<int, string> { { 1, "CHAR_COMPLETED_QTY" }, { 2, "INVENTORY" }, { 3, … | 데이터 객체 조작/조회 |  |  |  |
| AC-e528ebc9 | this.Load | SCP0059_Shipment_Plan_SEMI_JV.cs:264 |  | VALUE_SET | cboBucketType.ControlValues | BucketType.Daily | 컨트롤 값 설정 |  |  |  |

## SCP0059_Shipment_Plan_SEMI_JV.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d9ac40e9 | Dispose | SCP0059_Shipment_Plan_SEMI_JV.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0059_Shipment_Plan_SEMI_JV.EditBlockChecking

진입점: this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName)) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Equals("S")) ▸ try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] / this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName)) ▸ if (MessageHelper.GMessageBox("MSG00016") == DialogResult.Yes) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (result != nul…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-90ac2281 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 5 | SCP0059_Shipment_Plan_SEMI_JV.cs:1658 | if (number == 1) ▸ for (cols <= siMain.GetMaxColumnIndex()) | DATA_OP | dateColumn.Contains | ("W_") | 데이터 객체 조작/조회 |  |  |  |
| AC-ab78eb72 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 5 | SCP0059_Shipment_Plan_SEMI_JV.cs:1662 | if (number == 1) ▸ for (cols <= siMain.GetMaxColumnIndex()) ▸ else of (dateColumn.Contains("W_")) | DATA_OP | dateColumn.Contains | ("D_") | 데이터 객체 조작/조회 |  |  |  |
| AC-13688cb5 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 5 | SCP0059_Shipment_Plan_SEMI_JV.cs:1686 | if (number == 1) | RETURN | return retIndex == 0 ? siMain.GetMaxColumnIndex() : retIndex; |  | 처리 중단/반환 |  |  |  |
| AC-8cc0e151 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 5 | SCP0059_Shipment_Plan_SEMI_JV.cs:1695 |  | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |

## SCP0059_Shipment_Plan_SEMI_JV.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-479736b0 | EditButton | SCP0059_Shipment_Plan_SEMI_JV.cs:819 | if (fps != null) ▸ if (dsBinding.Tables.Count == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b46a15e0 | EditButton | SCP0059_Shipment_Plan_SEMI_JV.cs:821 | if (fps != null) | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-691c011c | EditButton | SCP0059_Shipment_Plan_SEMI_JV.cs:822 | if (fps != null) | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-c61ec2ca | EditButton | SCP0059_Shipment_Plan_SEMI_JV.cs:826 | if (fps != null) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefMain.DIVISION_ID), siMain.nIdxData, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-a3ea168a | EditButton | SCP0059_Shipment_Plan_SEMI_JV.cs:832 | if (fps != null) ▸ if (this.IsEditMode) ▸ if (EditBlockChecking(2) != 1) | FLAG | _isInsert | true | 화면 필드/플래그 변경 |  |  |  |
| AC-26729996 | EditButton | SCP0059_Shipment_Plan_SEMI_JV.cs:838 | if (fps != null) ▸ if (this.IsEditMode) ▸ else of (EditBlockChecking(2) != 1) | FLAG | _isInsert | false | 화면 필드/플래그 변경 |  |  |  |
| AC-cbf26eea | EditButton | SCP0059_Shipment_Plan_SEMI_JV.cs:839 | if (fps != null) ▸ if (this.IsEditMode) ▸ else of (EditBlockChecking(2) != 1) | GRID_LOCK | siMain.LockRange | (0, siMain.nIdxData, siMain.GetMaxRowIndex(), siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-11a7d251 | EditButton | SCP0059_Shipment_Plan_SEMI_JV.cs:845 | if (fps != null) ▸ else of (this.IsEditMode) | FLAG | _isInsert | false | 화면 필드/플래그 변경 |  |  |  |
| AC-3156a10f | EditButton | SCP0059_Shipment_Plan_SEMI_JV.cs:847 | if (fps != null) ▸ else of (this.IsEditMode) | GRID_LOCK | siMain.LockRange | (0, siMain.nIdxData, siMain.GetMaxRowIndex(), siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-5bbdc4af | EditButton | SCP0059_Shipment_Plan_SEMI_JV.cs:856 | if (fps != null) | UI_MISC | spdMain.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## SCP0059_Shipment_Plan_SEMI_JV.FindButton

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b7457349 | FindButton | SCP0059_Shipment_Plan_SEMI_JV.cs:790 | if (checkPlantSite == 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00352") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8e0aae6d | FindButton | SCP0059_Shipment_Plan_SEMI_JV.cs:791 | if (checkPlantSite == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0ae418a7 | FindButton | SCP0059_Shipment_Plan_SEMI_JV.cs:803 | if (strValue == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00352") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-1c7ae52d | FindButton | SCP0059_Shipment_Plan_SEMI_JV.cs:804 | if (strValue == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0059_Shipment_Plan_SEMI_JV.FindData_Division

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-aad1d6cd | this.Load | SCP0059_Shipment_Plan_SEMI_JV.cs:4497 |  | STATE | clbFromSite.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-ca6c92bc | this.Load | SCP0059_Shipment_Plan_SEMI_JV.cs:4500 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SystemMgmt.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-826af86a | this.Load | SCP0059_Shipment_Plan_SEMI_JV.cs:4504 | lambda | ENDPOINT | new FoxDataRequest | ("SystemManager.UP_FX_GetUserGroupAuthExtentionList") ⇒ SystemManager.UP_FX_GetUserGroupAuthExtentionList | 엔드포인트 요청 생성 |  |  |  |
| AC-fd0da3de | this.Load | SCP0059_Shipment_Plan_SEMI_JV.cs:4506 | lambda | DATA_OP | request.Parameters["GroupID"] | "JV Planner" | 행/컬럼 값 대입 |  |  |  |
| AC-d16429a4 | this.Load | SCP0059_Shipment_Plan_SEMI_JV.cs:4507 | lambda | DATA_OP | request.Parameters["UserID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-061e93e5 | this.Load | SCP0059_Shipment_Plan_SEMI_JV.cs:4508 | lambda | DATA_OP | request.Parameters["AuthType"] | "J" | 행/컬럼 값 대입 |  |  |  |
| AC-5cab6c32 | this.Load | SCP0059_Shipment_Plan_SEMI_JV.cs:4509 | lambda | DATA_OP | request.Parameters["DivisionID"] | string.Empty | 행/컬럼 값 대입 |  |  |  |
| AC-eceaa60f | this.Load | SCP0059_Shipment_Plan_SEMI_JV.cs:4510 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-9d9b15eb | this.Load | SCP0059_Shipment_Plan_SEMI_JV.cs:4512 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-b6e93447 | this.Load | SCP0059_Shipment_Plan_SEMI_JV.cs:4521 | for (i < ds.Tables[0].Rows.Count) | DATA_OP | dic_JV_Plant.Add | (Code, JV_PLANT_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-dbf42400 | this.Load | SCP0059_Shipment_Plan_SEMI_JV.cs:4523 |  | STATE | clbFromSite.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## SCP0059_Shipment_Plan_SEMI_JV.FindData_Main

진입점: this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName)) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Equals("S"))] / this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName)) ▸ if (MessageHelper.GMessageBox("MSG00016") == DialogResult.Yes) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["re…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-de0209b6 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 4 | SCP0059_Shipment_Plan_SEMI_JV.cs:872 |  | VALIDATE | DataUtil.checkRequired | (this.pnlCondition) | 프레임워크 검증 |  |  |  |
| AC-12f4613a | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 4 | SCP0059_Shipment_Plan_SEMI_JV.cs:872 | if (!DataUtil.checkRequired(this.pnlCondition)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5383b874 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 4 | SCP0059_Shipment_Plan_SEMI_JV.cs:874 |  | VALIDATE | DateUtil.Check_PeriodDate_New | (drpPeriod, "1", "7") | 프레임워크 검증 |  |  |  |
| AC-784ff5c1 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 4 | SCP0059_Shipment_Plan_SEMI_JV.cs:874 | if (!DateUtil.Check_PeriodDate_New(drpPeriod, "1", "7")) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2d34e133 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 4 | SCP0059_Shipment_Plan_SEMI_JV.cs:901 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-712964a8 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 4 | SCP0059_Shipment_Plan_SEMI_JV.cs:904 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-cee3efa7 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 4 | SCP0059_Shipment_Plan_SEMI_JV.cs:908 | try | UI_PROP | proxyPivot.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-f33c7e62 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 4 | SCP0059_Shipment_Plan_SEMI_JV.cs:910 | try | FLAG | dsBinding | await proxyPivot.ExecuteAsync<DataSet>(() => { using (var client = new FoxDataClient(CAppS… | 화면 필드/플래그 변경 |  |  |  |
| AC-fec45756 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 4 | SCP0059_Shipment_Plan_SEMI_JV.cs:910 | try | ENDPOINT | proxyPivot.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, GSCM_SCP_ANALYS… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-580ef8c5 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 4 | SCP0059_Shipment_Plan_SEMI_JV.cs:913 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0010_GET_SHIPMENT_PLAN_SEMI") ⇒ SCP.SCP0010_GET_SHIPMENT_PLAN_SEMI | 엔드포인트 요청 생성 |  |  |  |
| AC-58439f72 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 4 | SCP0059_Shipment_Plan_SEMI_JV.cs:914 | try ▸ lambda | UI_PROP | req.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-7ec04db8 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 4 | SCP0059_Shipment_Plan_SEMI_JV.cs:915 | try ▸ lambda | DATA_OP | req.Parameters["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-32e830fe | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 4 | SCP0059_Shipment_Plan_SEMI_JV.cs:916 | try ▸ lambda | DATA_OP | req.Parameters["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-f6076972 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 4 | SCP0059_Shipment_Plan_SEMI_JV.cs:917 | try ▸ lambda | DATA_OP | req.Parameters["p_division_id"] | division | 행/컬럼 값 대입 |  |  |  |
| AC-316a7167 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 4 | SCP0059_Shipment_Plan_SEMI_JV.cs:918 | try ▸ lambda | DATA_OP | req.Parameters["p_operation_group"] | pOperationGroup | 행/컬럼 값 대입 |  |  |  |
| AC-f3dca1c2 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 4 | SCP0059_Shipment_Plan_SEMI_JV.cs:919 | try ▸ lambda | DATA_OP | req.Parameters["p_item_id"] | p_Item_id | 행/컬럼 값 대입 |  |  |  |
| AC-9511fecc | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 4 | SCP0059_Shipment_Plan_SEMI_JV.cs:920 | try ▸ lambda | DATA_OP | req.Parameters["p_electype"] | p_electype | 행/컬럼 값 대입 |  |  |  |
| AC-9753e9a8 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 4 | SCP0059_Shipment_Plan_SEMI_JV.cs:921 | try ▸ lambda | DATA_OP | req.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-447ecb5d | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 4 | SCP0059_Shipment_Plan_SEMI_JV.cs:922 | try ▸ lambda | DATA_OP | req.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-cd3176ac | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 4 | SCP0059_Shipment_Plan_SEMI_JV.cs:923 | try ▸ lambda | DATA_OP | req.Parameters["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-b4d3e940 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 4 | SCP0059_Shipment_Plan_SEMI_JV.cs:924 | try ▸ lambda | DATA_OP | req.Parameters["p_fromsite"] | p_fromsite | 행/컬럼 값 대입 |  |  |  |
| AC-016636f6 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 4 | SCP0059_Shipment_Plan_SEMI_JV.cs:925 | try ▸ lambda | DATA_OP | req.Parameters["p_tosite"] | p_tosite | 행/컬럼 값 대입 |  |  |  |
| AC-60926774 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 4 | SCP0059_Shipment_Plan_SEMI_JV.cs:926 | try ▸ lambda | DATA_OP | req.Parameters["p_program_id"] | "SCP0010" | 행/컬럼 값 대입 |  |  |  |
| AC-01288403 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 4 | SCP0059_Shipment_Plan_SEMI_JV.cs:928 | try ▸ lambda | DATA_OP | req.Parameters["p_sheet_name"] | p_sheet_name | 행/컬럼 값 대입 |  |  |  |
| AC-c33342c4 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 4 | SCP0059_Shipment_Plan_SEMI_JV.cs:930 | try ▸ lambda | DATA_OP | req.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-606a6ddd | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 4 | SCP0059_Shipment_Plan_SEMI_JV.cs:931 | try ▸ lambda | DATA_OP | req.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-be8e4b9a | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 4 | SCP0059_Shipment_Plan_SEMI_JV.cs:933 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-d9c04a47 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 4 | SCP0059_Shipment_Plan_SEMI_JV.cs:934 | try ▸ lambda | RETURN | return res.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-69c41404 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 4 | SCP0059_Shipment_Plan_SEMI_JV.cs:950 | try | UI_PROP | dv.Sort | sOrderBy | 속성 Sort 설정 |  |  |  |
| AC-a1394b51 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 4 | SCP0059_Shipment_Plan_SEMI_JV.cs:952 | try | DATA_OP | dsSort.Tables.Add | (dv.ToTable()) | 데이터 객체 조작/조회 |  |  |  |
| AC-b792a83d | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 4 | SCP0059_Shipment_Plan_SEMI_JV.cs:952 | try | DATA_OP | dv.ToTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-768ac263 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 4 | SCP0059_Shipment_Plan_SEMI_JV.cs:955 | try | GRID_BIND | siMain.Query | (dsSort) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-8b41b010 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 4 | SCP0059_Shipment_Plan_SEMI_JV.cs:963 | try ▸ if (dsBinding.Tables[0].Rows.Count > 0) | FLAG | this._IsEditable | GetIsEditable(dsBinding.Tables[1], p_plan_start_yyyymmdd, p_plan_type, p_seq) | 화면 필드/플래그 변경 |  |  |  |
| AC-add6a572 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 4 | SCP0059_Shipment_Plan_SEMI_JV.cs:964 | try ▸ if (dsBinding.Tables[0].Rows.Count > 0) | FLAG | this._plan_Start_Date | Convert.ToDateTime(dsBinding.Tables[1].Rows[0]["plan_start_date"]) | 화면 필드/플래그 변경 |  |  |  |
| AC-e2f282c4 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 4 | SCP0059_Shipment_Plan_SEMI_JV.cs:965 | try ▸ if (dsBinding.Tables[0].Rows.Count > 0) | FLAG | this._block_idx | EditBlockChecking(1, siMain.nIdxData) | 화면 필드/플래그 변경 |  |  |  |
| AC-5b070968 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 4 | SCP0059_Shipment_Plan_SEMI_JV.cs:984 | try ▸ if (dsBinding.Tables[0].Rows.Count > 0) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-59b74d1e | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 4 | SCP0059_Shipment_Plan_SEMI_JV.cs:988 | try ▸ if (dsBinding.Tables[0].Rows.Count > 0) | CALL_EXT | siMain.AddRows | (siMain.GetMaxRowIndex() + 1, 1) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c889c7fe | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 4 | SCP0059_Shipment_Plan_SEMI_JV.cs:989 | try ▸ if (dsBinding.Tables[0].Rows.Count > 0) | CALL_EXT | siMain.VisibleRow | (siMain.GetMaxRowIndex(), false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-08cdad19 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 4 | SCP0059_Shipment_Plan_SEMI_JV.cs:990 | try ▸ if (dsBinding.Tables[0].Rows.Count > 0) | GRID_SET | siMain.ActiveSheet.Rows[siMain.ActiveSheet.Rows.Count - 1].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-4033c08f | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 4 | SCP0059_Shipment_Plan_SEMI_JV.cs:992 | try ▸ if (dsBinding.Tables[0].Rows.Count > 0) | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-75d8d74a | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 4 | SCP0059_Shipment_Plan_SEMI_JV.cs:996 | try ▸ else of (dsBinding.Tables[0].Rows.Count > 0) | GRID_BIND | siMain.Query | (dsBinding) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-ea81ab44 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 4 | SCP0059_Shipment_Plan_SEMI_JV.cs:999 | try | UI_MISC | SetSearchCount | (dsBinding) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-f1b4dc7c | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 4 | SCP0059_Shipment_Plan_SEMI_JV.cs:1003 | catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-dce1bd0c | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 4 | SCP0059_Shipment_Plan_SEMI_JV.cs:1005 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-dac25f57 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 4 | SCP0059_Shipment_Plan_SEMI_JV.cs:1009 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-02cec544 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 4 | SCP0059_Shipment_Plan_SEMI_JV.cs:1010 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## SCP0059_Shipment_Plan_SEMI_JV.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-64f9a3bd | this.Load | SCP0059_Shipment_Plan_SEMI_JV.cs:221 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCP0059_Shipment_Plan_SEMI_JV.Get_IsSaveYn

진입점: this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))] / this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName))] / this.btnNew.Click / SaveButton [if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8e2f4a4f | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 3 | SCP0059_Shipment_Plan_SEMI_JV.cs:1420 | if (division == null \|\| division.ToString() == "") | RETURN | return saveYn; |  | 처리 중단/반환 |  |  |  |
| AC-16aad565 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 3 | SCP0059_Shipment_Plan_SEMI_JV.cs:1431 | try | ENDPOINT | new FoxDataRequest | ("SCP.SCP0013_GET_PLAN_TYPE_SAVE_YN") ⇒ SCP.SCP0013_GET_PLAN_TYPE_SAVE_YN | 엔드포인트 요청 생성 |  |  |  |
| AC-08d014c9 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 3 | SCP0059_Shipment_Plan_SEMI_JV.cs:1432 | try | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-5e0f585a | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 3 | SCP0059_Shipment_Plan_SEMI_JV.cs:1433 | try | DATA_OP | request.Parameters["p_start_yyyymmdd"] | p_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-3283165e | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 3 | SCP0059_Shipment_Plan_SEMI_JV.cs:1434 | try | DATA_OP | request.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-8a82e883 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 3 | SCP0059_Shipment_Plan_SEMI_JV.cs:1436 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-3fb43b2c | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 3 | SCP0059_Shipment_Plan_SEMI_JV.cs:1446 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-11ace69b | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 3 | SCP0059_Shipment_Plan_SEMI_JV.cs:1451 | if (!saveYn) | MESSAGE | MessageHelper.GMessageBox | ("MSG00182") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-2a209e43 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 3 | SCP0059_Shipment_Plan_SEMI_JV.cs:1453 |  | RETURN | return saveYn; |  | 처리 중단/반환 |  |  |  |

## SCP0059_Shipment_Plan_SEMI_JV.GetBucketType

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ab052f3d | this.Load | SCP0059_Shipment_Plan_SEMI_JV.cs:1633 |  | ENDPOINT | new FoxDataRequest | ("DM.DM0003_GET_BUCKET_TYPE_CODE") ⇒ DM.DM0003_GET_BUCKET_TYPE_CODE | 엔드포인트 요청 생성 |  |  |  |
| AC-ecc709cb | this.Load | SCP0059_Shipment_Plan_SEMI_JV.cs:1634 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-6cb88fb5 | this.Load | SCP0059_Shipment_Plan_SEMI_JV.cs:1636 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SCP0059_Shipment_Plan_SEMI_JV.GetDayRange

진입점: this.Load / cboPlanDate.SelectedIndexChanged / this.btnW26.Click / this.btnW52.Click / this.btnWLast.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4637edf9 | this.Load 외 4 | SCP0059_Shipment_Plan_SEMI_JV.cs:3903 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCM0001_GET_SCP_DAY_PERIOD") ⇒ SCP.SCM0001_GET_SCP_DAY_PERIOD | 엔드포인트 요청 생성 |  |  |  |
| AC-3563dbfe | this.Load 외 4 | SCP0059_Shipment_Plan_SEMI_JV.cs:3904 |  | DATA_OP | request.Parameters["p_from_date"] | p_plan_start_date == null ? "" : p_plan_start_date | 행/컬럼 값 대입 |  |  |  |
| AC-7ca9b0c0 | this.Load 외 4 | SCP0059_Shipment_Plan_SEMI_JV.cs:3905 |  | DATA_OP | request.Parameters["p_offset_day"] | Convert.ToInt32(periodType) * 7 - 1 | 행/컬럼 값 대입 |  |  |  |
| AC-7da307d3 | this.Load 외 4 | SCP0059_Shipment_Plan_SEMI_JV.cs:3906 |  | DATA_OP | request.Parameters["p_timezone"] | UserInfoContext.Current[UserInfoProperites.TimeZone] | 행/컬럼 값 대입 |  |  |  |
| AC-3bb3a4fe | this.Load 외 4 | SCP0059_Shipment_Plan_SEMI_JV.cs:3907 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-7da4eea5 | this.Load 외 4 | SCP0059_Shipment_Plan_SEMI_JV.cs:3909 |  | RETURN | return sDayRange; |  | 처리 중단/반환 |  |  |  |

## SCP0059_Shipment_Plan_SEMI_JV.GetDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0c599ae6 | (진입점 미연결) | SCP0059_Shipment_Plan_SEMI_JV.cs:3817 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_DIVISION") ⇒ SCM.SCM0001_GET_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-c613a059 | (진입점 미연결) | SCP0059_Shipment_Plan_SEMI_JV.cs:3818 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-c95f5c7c | (진입점 미연결) | SCP0059_Shipment_Plan_SEMI_JV.cs:3820 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SCP0059_Shipment_Plan_SEMI_JV.GetIsEditable

진입점: this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName)) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Equals("S")) ▸ try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] / this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName)) ▸ if (MessageHelper.GMessageBox("MSG00016") == DialogResult.Yes) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (result != nul…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-75cece0e | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 4 | SCP0059_Shipment_Plan_SEMI_JV.cs:1274 | if (isEditTable.Equals("N") \|\| curPlanType.Equals("FN") \|\| curPlanType.Equals("TE")) | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |
| AC-55510803 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 4 | SCP0059_Shipment_Plan_SEMI_JV.cs:1294 | if (curPlanType.Equals("PR")) | DATA_OP | dtEditable.Select | ("plan_type_seq = '1'") | 데이터 객체 조작/조회 |  |  |  |
| AC-5fd61a8c | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 4 | SCP0059_Shipment_Plan_SEMI_JV.cs:1328 | if (curPlanType.Equals("PR")) | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |
| AC-7fa8d52e | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 4 | SCP0059_Shipment_Plan_SEMI_JV.cs:1336 | else of (curPlanType.Equals("PR")) ▸ if (curPlanType.Equals("MA")) | DATA_OP | dtEditable.Select | ("plan_type_seq = '2'") | 데이터 객체 조작/조회 |  |  |  |
| AC-10e560b2 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 4 | SCP0059_Shipment_Plan_SEMI_JV.cs:1352 | else of (curPlanType.Equals("PR")) ▸ if (curPlanType.Equals("MA")) ▸ else of (founded.Length > 0) | DATA_OP | dtEditable.Select | ("plan_start_yyyymmdd = '" + curPlanStartYYYYMMDD.ToString() + "' and plan_type= '" + curP… | 데이터 객체 조작/조회 |  |  |  |
| AC-d8597df2 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 4 | SCP0059_Shipment_Plan_SEMI_JV.cs:1366 | else of (curPlanType.Equals("PR")) ▸ if (curPlanType.Equals("MA")) | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |
| AC-68539a2c | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 4 | SCP0059_Shipment_Plan_SEMI_JV.cs:1373 | else of (curPlanType.Equals("PR")) ▸ else of (curPlanType.Equals("MA")) ▸ if (curPlanType.Equals("SE")) | DATA_OP | dtEditable.Select | ("plan_type_seq = '3'") | 데이터 객체 조작/조회 |  |  |  |
| AC-8093fade | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 4 | SCP0059_Shipment_Plan_SEMI_JV.cs:1403 | else of (curPlanType.Equals("PR")) ▸ else of (curPlanType.Equals("MA")) ▸ if (curPlanType.Equals("SE")) | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |
| AC-bc3181a4 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 4 | SCP0059_Shipment_Plan_SEMI_JV.cs:1406 |  | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |

## SCP0059_Shipment_Plan_SEMI_JV.GetLastPlanVersion

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3c770fab | (진입점 미연결) | SCP0059_Shipment_Plan_SEMI_JV.cs:743 | try | UI_PROP | proxyPivot.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-349fa17a | (진입점 미연결) | SCP0059_Shipment_Plan_SEMI_JV.cs:744 | try | ENDPOINT | proxyPivot.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, GSCM_SCP_ANALYS… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-f4cd26a2 | (진입점 미연결) | SCP0059_Shipment_Plan_SEMI_JV.cs:747 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0011_GET_LAST_PLAN_VERSION") ⇒ SCP.SCP0011_GET_LAST_PLAN_VERSION | 엔드포인트 요청 생성 |  |  |  |
| AC-94ae3a68 | (진입점 미연결) | SCP0059_Shipment_Plan_SEMI_JV.cs:748 | try ▸ lambda | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-93a76939 | (진입점 미연결) | SCP0059_Shipment_Plan_SEMI_JV.cs:749 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-e944efd9 | (진입점 미연결) | SCP0059_Shipment_Plan_SEMI_JV.cs:750 | try ▸ lambda | RETURN | return res.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-d88c7b0b | (진입점 미연결) | SCP0059_Shipment_Plan_SEMI_JV.cs:762 | try ▸ if (dsBinding.Tables.Count > 0 && dsBinding.Tables[0].Rows.Count > 0) | VALUE_SET | cboPlanDate.SelectedValue | PLAN_START_YYYYMMDD | 컨트롤 값 설정 |  |  |  |
| AC-f50e1ab2 | (진입점 미연결) | SCP0059_Shipment_Plan_SEMI_JV.cs:763 | try ▸ if (dsBinding.Tables.Count > 0 && dsBinding.Tables[0].Rows.Count > 0) | VALUE_SET | cboPlanType.SelectedValue | PLAN_TYPE | 컨트롤 값 설정 |  |  |  |
| AC-66efa376 | (진입점 미연결) | SCP0059_Shipment_Plan_SEMI_JV.cs:764 | try ▸ if (dsBinding.Tables.Count > 0 && dsBinding.Tables[0].Rows.Count > 0) | VALUE_SET | cboPlanSeq.SelectedValue | PLAN_SEQ | 컨트롤 값 설정 |  |  |  |

## SCP0059_Shipment_Plan_SEMI_JV.GetLastRange

진입점: this.Load / cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-79901d01 | this.Load 외 1 | SCP0059_Shipment_Plan_SEMI_JV.cs:3889 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCM0001_GET_SCP_DAILY_PLAN_PERIOD") ⇒ SCP.SCM0001_GET_SCP_DAILY_PLAN_PERIOD | 엔드포인트 요청 생성 |  |  |  |
| AC-31e37493 | this.Load 외 1 | SCP0059_Shipment_Plan_SEMI_JV.cs:3890 |  | DATA_OP | request.Parameters["p_division_id"] | divisionId | 행/컬럼 값 대입 |  |  |  |
| AC-4449d110 | this.Load 외 1 | SCP0059_Shipment_Plan_SEMI_JV.cs:3891 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-bbb77f49 | this.Load 외 1 | SCP0059_Shipment_Plan_SEMI_JV.cs:3893 |  | RETURN | return dailyPlanPeriod; |  | 처리 중단/반환 |  |  |  |

## SCP0059_Shipment_Plan_SEMI_JV.GetNewInsertRowIndex

진입점: this.spdMain.CellClick [if ((e.Column == siMain.GetColumnIndex(DefMain.TRANSPORT_MODE) \|\| e.Column == siMain.GetColumnIndex(DefMain.TO_SITE_DESCRIPT…) ▸ if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (toSite.ToString() == popupToSite)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ce80808b | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0059_Shipment_Plan_SEMI_JV.cs:3164 |  | RETURN | return retIndex; |  | 처리 중단/반환 |  |  |  |

## SCP0059_Shipment_Plan_SEMI_JV.GetSpdTitle

진입점: this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK)] / this.Load / this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName)) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Equals("S"))] / this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName)) ▸ if (MessageHelper.GMessageBox("MSG00016") == DialogResult.Yes) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9016b8d7 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | SCP0059_Shipment_Plan_SEMI_JV.cs:3853 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN") ⇒ SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | 엔드포인트 요청 생성 |  |  |  |
| AC-88376ecf | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | SCP0059_Shipment_Plan_SEMI_JV.cs:3854 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-a2f4291b | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | SCP0059_Shipment_Plan_SEMI_JV.cs:3855 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-dcae50be | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | SCP0059_Shipment_Plan_SEMI_JV.cs:3857 |  | FLAG | dsSpdTitle | client.ExecuteDataSet(request).DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-82c2b6bf | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | SCP0059_Shipment_Plan_SEMI_JV.cs:3857 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## SCP0059_Shipment_Plan_SEMI_JV.HandleBindingDataSet

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2a67bea9 | (진입점 미연결) | SCP0059_Shipment_Plan_SEMI_JV.cs:1786 |  | DATA_OP | list.Add | ("SHIP_REQ") | 데이터 객체 조작/조회 |  |  |  |
| AC-cbefcdab | (진입점 미연결) | SCP0059_Shipment_Plan_SEMI_JV.cs:1787 |  | DATA_OP | list.Add | ("SHIP_PLAN") | 데이터 객체 조작/조회 |  |  |  |
| AC-227f680b | (진입점 미연결) | SCP0059_Shipment_Plan_SEMI_JV.cs:1788 |  | DATA_OP | list.Add | ("SHIP_PLAN_AMEND") | 데이터 객체 조작/조회 |  |  |  |
| AC-e96575c7 | (진입점 미연결) | SCP0059_Shipment_Plan_SEMI_JV.cs:1789 |  | DATA_OP | list.Add | ("INVENTORY") | 데이터 객체 조작/조회 |  |  |  |
| AC-6bb22ed9 | (진입점 미연결) | SCP0059_Shipment_Plan_SEMI_JV.cs:1796 | for (iRow < dtQty.Rows.Count) | DATA_OP | dtBinding.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-3de1028d | (진입점 미연결) | SCP0059_Shipment_Plan_SEMI_JV.cs:1829 | for (iRow < dtQty.Rows.Count) ▸ for (iCol < dtQty.Columns.Count) ▸ if (iCol <= header_idx) ▸ if (iCol == from_site_idx) | DATA_OP | newDr[iCol] | dtQty.Rows[iRow][iCol].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-70e9edd5 | (진입점 미연결) | SCP0059_Shipment_Plan_SEMI_JV.cs:1833 | for (iRow < dtQty.Rows.Count) ▸ for (iCol < dtQty.Columns.Count) ▸ if (iCol <= header_idx) ▸ else of (iCol == from_site_idx) ▸ if (iCol == m… | DATA_OP | newDr[iCol] | dtQty.Rows[iRow][iCol].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-e8f2acd5 | (진입점 미연결) | SCP0059_Shipment_Plan_SEMI_JV.cs:1839 | for (iRow < dtQty.Rows.Count) ▸ for (iCol < dtQty.Columns.Count) ▸ if (iCol <= header_idx) ▸ else of (iCol == from_site_idx) ▸ else of (iCol… | DATA_OP | newDr[iCol] | dtQty.Rows[iRow][iCol].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-74eca05e | (진입점 미연결) | SCP0059_Shipment_Plan_SEMI_JV.cs:1853 | for (iRow < dtQty.Rows.Count) ▸ for (iCol < dtQty.Columns.Count) ▸ else of (iCol <= header_idx) ▸ if (colName.IndexOf("M_") == 0) ▸ if (Mont… | DATA_OP | newDr[WeekIdx] | WeekSum | 행/컬럼 값 대입 |  |  |  |
| AC-5bce7303 | (진입점 미연결) | SCP0059_Shipment_Plan_SEMI_JV.cs:1854 | for (iRow < dtQty.Rows.Count) ▸ for (iCol < dtQty.Columns.Count) ▸ else of (iCol <= header_idx) ▸ if (colName.IndexOf("M_") == 0) ▸ if (Mont… | DATA_OP | newDr[MonthIdx] | MonthSum + WeekSum | 행/컬럼 값 대입 |  |  |  |
| AC-beaea0f2 | (진입점 미연결) | SCP0059_Shipment_Plan_SEMI_JV.cs:1867 | for (iRow < dtQty.Rows.Count) ▸ for (iCol < dtQty.Columns.Count) ▸ else of (iCol <= header_idx) ▸ else of (colName.IndexOf("M_") == 0) ▸ if … | DATA_OP | newDr[WeekIdx] | WeekSum | 행/컬럼 값 대입 |  |  |  |
| AC-cd956ee0 | (진입점 미연결) | SCP0059_Shipment_Plan_SEMI_JV.cs:1868 | for (iRow < dtQty.Rows.Count) ▸ for (iCol < dtQty.Columns.Count) ▸ else of (iCol <= header_idx) ▸ else of (colName.IndexOf("M_") == 0) ▸ if … | DATA_OP | newDr[MonthIdx] | MonthSum + WeekSum | 행/컬럼 값 대입 |  |  |  |
| AC-13dff1c2 | (진입점 미연결) | SCP0059_Shipment_Plan_SEMI_JV.cs:1886 | for (iRow < dtQty.Rows.Count) ▸ for (iCol < dtQty.Columns.Count) ▸ else of (iCol <= header_idx) ▸ else of (colName.IndexOf("M_") == 0) ▸ els… | DATA_OP | newDr[iCol] | check_value | 행/컬럼 값 대입 |  |  |  |
| AC-927d1adb | (진입점 미연결) | SCP0059_Shipment_Plan_SEMI_JV.cs:1897 | for (iRow < dtQty.Rows.Count) ▸ for (iCol < dtQty.Columns.Count) ▸ if (iCol == dtQty.Columns.Count - 1) ▸ if (MonthSum > 0) | DATA_OP | newDr[MonthIdx] | MonthSum + WeekSum | 행/컬럼 값 대입 |  |  |  |
| AC-423fd3fd | (진입점 미연결) | SCP0059_Shipment_Plan_SEMI_JV.cs:1901 | for (iRow < dtQty.Rows.Count) ▸ for (iCol < dtQty.Columns.Count) ▸ if (iCol == dtQty.Columns.Count - 1) ▸ if (WeekSum > 0) | DATA_OP | newDr[WeekIdx] | WeekSum | 행/컬럼 값 대입 |  |  |  |
| AC-6e3630a2 | (진입점 미연결) | SCP0059_Shipment_Plan_SEMI_JV.cs:1904 | for (iRow < dtQty.Rows.Count) ▸ for (iCol < dtQty.Columns.Count) ▸ if (iCol == dtQty.Columns.Count - 1) ▸ if (WeekSum > 0) | DATA_OP | newDr[MonthIdx] | MonthSum | 행/컬럼 값 대입 |  |  |  |
| AC-a5c83161 | (진입점 미연결) | SCP0059_Shipment_Plan_SEMI_JV.cs:1909 | for (iRow < dtQty.Rows.Count) | DATA_OP | dtBinding.Rows.Add | (newDr) | 데이터 객체 조작/조회 |  |  |  |
| AC-45814b1e | (진입점 미연결) | SCP0059_Shipment_Plan_SEMI_JV.cs:1915 | for (iRow < dtQty.Rows.Count) ▸ if (bef_key_idx != cur_key_idx) ▸ if (bef_key_idx != string.Empty) | CALL_EXT | calc.SetCalcMeasure | (ref dtBinding, key_idx_index, iRow) | ⚠ 의미 확인 필요 |  |  |  |
| AC-30d7f877 | (진입점 미연결) | SCP0059_Shipment_Plan_SEMI_JV.cs:1922 | for (iRow < dtQty.Rows.Count) ▸ if (iRow == dtQty.Rows.Count - 1) | CALL_EXT | calc.SetCalcMeasure | (ref dtBinding, key_idx_index, iRow) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e6ced43e | (진입점 미연결) | SCP0059_Shipment_Plan_SEMI_JV.cs:1942 |  | DATA_OP | dtBinding.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |

## SCP0059_Shipment_Plan_SEMI_JV.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f4f830c7 | this.Load | SCP0059_Shipment_Plan_SEMI_JV.cs:270 | if (dtDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |
| AC-7c092f93 | this.Load | SCP0059_Shipment_Plan_SEMI_JV.cs:273 |  | DATA_OP | this.ConditionNotUseList.Add | (cboPlanDate) | 데이터 객체 조작/조회 |  |  |  |
| AC-6eafb25c | this.Load | SCP0059_Shipment_Plan_SEMI_JV.cs:274 |  | DATA_OP | this.ConditionNotUseList.Add | (cboPlanType) | 데이터 객체 조작/조회 |  |  |  |
| AC-6c3b7d9c | this.Load | SCP0059_Shipment_Plan_SEMI_JV.cs:275 |  | DATA_OP | this.ConditionNotUseList.Add | (cboPlanSeq) | 데이터 객체 조작/조회 |  |  |  |
| AC-64d4b782 | this.Load | SCP0059_Shipment_Plan_SEMI_JV.cs:277 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-8d918eed | this.Load | SCP0059_Shipment_Plan_SEMI_JV.cs:279 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, cboDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-154313f6 | this.Load | SCP0059_Shipment_Plan_SEMI_JV.cs:284 |  | FLAG | dtElecType | Data.Common(Data.Type.LookupCommon, false, "ELECTRODE_TYPE") ⇒ biz:CommonData.CommonDataList [code=LookupCommon] | 화면 필드/플래그 변경 |  |  |  |
| AC-a87d2466 | this.Load | SCP0059_Shipment_Plan_SEMI_JV.cs:284 |  | COMBO_DATA | Data.Common | (Data.Type.LookupCommon, false, "ELECTRODE_TYPE") ⇒ biz:CommonData.CommonDataList [code=LookupCommon] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-9cf4efb9 | this.Load | SCP0059_Shipment_Plan_SEMI_JV.cs:285 |  | LIST_REBIND | clsCtrl.setListBox | (dtElecType, clbElecType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-c7a5bd03 | this.Load | SCP0059_Shipment_Plan_SEMI_JV.cs:292 |  | VALUE_SET | drpPeriod.InitValue | GetDayRange(PeriodType.W52) | 컨트롤 값 설정 |  |  |  |
| AC-4e28e730 | this.Load | SCP0059_Shipment_Plan_SEMI_JV.cs:294 |  | FLAG | dtBucketType | GetBucketType() | 화면 필드/플래그 변경 |  |  |  |
| AC-c2b9d950 | this.Load | SCP0059_Shipment_Plan_SEMI_JV.cs:295 |  | LIST_REBIND | clsCtrl.setListBox | (dtBucketType, cboBucketType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-02deabf5 | this.Load | SCP0059_Shipment_Plan_SEMI_JV.cs:305 | if (dailyPlanPeriod == PeriodType.W52) | UI_PROP | layoutControlItem12.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-bcbff91a | this.Load | SCP0059_Shipment_Plan_SEMI_JV.cs:308 |  | VALUE_SET | btnWLast.Text | "W" + dailyPlanPeriod | 컨트롤 값 설정 |  |  |  |

## SCP0059_Shipment_Plan_SEMI_JV.InitDictionary

진입점: this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName)) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Equals("S"))] / this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName)) ▸ if (MessageHelper.GMessageBox("MSG00016") == DialogResult.Yes) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["re…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a135e851 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 4 | SCP0059_Shipment_Plan_SEMI_JV.cs:1703 | foreach (var pair in dicSubSum_Range) | STATE_RESET | dicSubSum_Range.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-027233bd | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 4 | SCP0059_Shipment_Plan_SEMI_JV.cs:1708 | foreach (var pair in dicSubSumItems) | CALL_EXT | dicSubSumItems[pair.Key].Clear | () | ⚠ 의미 확인 필요 |  |  |  |

## SCP0059_Shipment_Plan_SEMI_JV.InitSpread

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7fbad145 | (진입점 미연결) | SCP0059_Shipment_Plan_SEMI_JV.cs:354 |  | GRID_INIT | spdInfo.InitSheet | (SpdSheet.shtMain) | 그리드 재구성/초기화 |  |  |  |
| AC-0e64d73b | (진입점 미연결) | SCP0059_Shipment_Plan_SEMI_JV.cs:356 |  | GRID_INIT | spdInfo.AddActionTextBox | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-a5cf7872 | (진입점 미연결) | SCP0059_Shipment_Plan_SEMI_JV.cs:357 |  | GRID_INIT | spdInfo.AddTextColumn | (DefMainLabel.KEY_IDX, DefMain.KEY_IDX, FPMerge.Restricted, 60, false, FPHAlign.Left, FPVA… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3fbb4110 | (진입점 미연결) | SCP0059_Shipment_Plan_SEMI_JV.cs:358 |  | GRID_INIT | spdInfo.AddTextColumn | (DefMainLabel.DIVISION_ID, DefMain.DIVISION_ID, FPMerge.Restricted, 40, true, FPHAlign.Cen… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-70f77feb | (진입점 미연결) | SCP0059_Shipment_Plan_SEMI_JV.cs:359 |  | GRID_INIT | spdInfo.AddTextColumn | (DefMainLabel.OPERATION_GROUP_DESC, DefMain.OPERATION_GROUP_DESC, FPMerge.Restricted, 65, … | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-825470fc | (진입점 미연결) | SCP0059_Shipment_Plan_SEMI_JV.cs:360 |  | GRID_INIT | spdInfo.AddTextColumn | (DefMainLabel.ITEM_ID, DefMain.ITEM_ID, FPMerge.Restricted, 103, true, FPHAlign.Left, FPVA… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1858ea35 | (진입점 미연결) | SCP0059_Shipment_Plan_SEMI_JV.cs:361 |  | GRID_INIT | spdInfo.AddTextColumn | (DefMainLabel.NICK_NAME, DefMain.NICK_NAME, FPMerge.Restricted, 65, true, FPHAlign.Left, F… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c752b15e | (진입점 미연결) | SCP0059_Shipment_Plan_SEMI_JV.cs:363 |  | GRID_INIT | spdInfo.AddTextColumn | (DefMainLabel.FROM_SITE_DESCRIPTION, DefMain.FROM_SITE_DESCRIPTION, FPMerge.Restricted, 75… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8a56de40 | (진입점 미연결) | SCP0059_Shipment_Plan_SEMI_JV.cs:364 |  | GRID_INIT | spdInfo.AddNumColumn | (DefMainLabel.BOH, DefMain.BOH, FPMerge.Restricted, 75, true, FPHAlign.Right, FPVAlign.Cen… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-fedf3f13 | (진입점 미연결) | SCP0059_Shipment_Plan_SEMI_JV.cs:365 |  | GRID_INIT | spdInfo.AddTextColumn | (DefMainLabel.T0_SITE_DESCRIPTION, DefMain.TO_SITE_DESCRIPTION, FPMerge.Restricted, 65, tr… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6c6451de | (진입점 미연결) | SCP0059_Shipment_Plan_SEMI_JV.cs:366 |  | GRID_INIT | spdInfo.AddTextColumn | (DefMainLabel.TRANSPORT_MODE, DefMain.TRANSPORT_MODE, FPMerge.Restricted, 40, true, FPHAli… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-dc39b789 | (진입점 미연결) | SCP0059_Shipment_Plan_SEMI_JV.cs:367 |  | GRID_INIT | spdInfo.AddTextColumn | (DefMainLabel.LT_DAY, DefMain.LT_DAY, FPMerge.Restricted, 40, true, FPHAlign.Right, FPVAli… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0c8aea67 | (진입점 미연결) | SCP0059_Shipment_Plan_SEMI_JV.cs:369 |  | GRID_INIT | spdInfo.AddTextColumn | (DefMainLabel.MEASURE_LABEL, DefMain.MEASURE_LABEL, FPMerge.Restricted, 110, true, FPHAlig… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6612bc60 | (진입점 미연결) | SCP0059_Shipment_Plan_SEMI_JV.cs:370 |  | GRID_INIT | spdInfo.AddTextColumn | (DefMainLabel.MEASURE, DefMain.MEASURE, FPMerge.Restricted, 80, false, FPHAlign.Left, FPVA… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-db376fb0 | (진입점 미연결) | SCP0059_Shipment_Plan_SEMI_JV.cs:371 |  | GRID_INIT | spdInfo.AddTextColumn | (DefMainLabel.DIVISION_NAME, DefMain.DIVISION_NAME, FPMerge.Restricted, 60, false, FPHAlig… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a3a342bd | (진입점 미연결) | SCP0059_Shipment_Plan_SEMI_JV.cs:372 |  | GRID_INIT | spdInfo.AddTextColumn | (DefMainLabel.OPERATION_GROUP, DefMain.OPERATION_GROUP, FPMerge.Restricted, 90, false, FPH… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1276205b | (진입점 미연결) | SCP0059_Shipment_Plan_SEMI_JV.cs:373 |  | GRID_INIT | spdInfo.AddTextColumn | (DefMainLabel.FROM_SITE, DefMain.FROM_SITE, FPMerge.Restricted, 110, false, FPHAlign.Left,… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0312db43 | (진입점 미연결) | SCP0059_Shipment_Plan_SEMI_JV.cs:375 |  | GRID_INIT | spdInfo.AddTextColumn | (DefMainLabel.TO_SITE, DefMain.TO_SITE, FPMerge.Restricted, 110, false, FPHAlign.Left, FPV… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ddcd2f08 | (진입점 미연결) | SCP0059_Shipment_Plan_SEMI_JV.cs:376 |  | GRID_INIT | spdInfo.AddTextColumn | (DefMainLabel.BOD_ID, DefMain.BOD_ID, FPMerge.Restricted, 110, false, FPHAlign.Right, FPVA… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-554baae4 | (진입점 미연결) | SCP0059_Shipment_Plan_SEMI_JV.cs:377 |  | GRID_INIT | spdInfo.AddTextColumn | (DefMainLabel.MEASURE_ORDER_NO, DefMain.MEASURE_ORDER_NO, FPMerge.Restricted, 140, false, … | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7cb52995 | (진입점 미연결) | SCP0059_Shipment_Plan_SEMI_JV.cs:378 |  | GRID_INIT | spdInfo.AddDateColumn | (DefMainLabel.SHIP_FROZEN, DefMain.SHIP_FROZEN, FPMerge.Restricted, 90, false, FPHAlign.Le… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-750c6a35 | (진입점 미연결) | SCP0059_Shipment_Plan_SEMI_JV.cs:379 |  | GRID_INIT | spdInfo.AddTextColumn | (DefMainLabel.FROM_YYYYMMDD, DefMain.FROM_YYYYMMDD, FPMerge.Restricted, 140, false, FPHAli… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-936e2a74 | (진입점 미연결) | SCP0059_Shipment_Plan_SEMI_JV.cs:381 |  | GRID_INIT | spdInfo.AddTextColumn | (DefMainLabel.TO_YYYYMMDD, DefMain.TO_YYYYMMDD, FPMerge.Restricted, 140, false, FPHAlign.C… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3fd38662 | (진입점 미연결) | SCP0059_Shipment_Plan_SEMI_JV.cs:384 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, 0, 3, 1, 20, " ", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d2cb6b20 | (진입점 미연결) | SCP0059_Shipment_Plan_SEMI_JV.cs:385 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefMain.KEY_IDX), 3, 1, 20, DefMainLabel.KEY_IDX, FPHAlign.Cente… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-902126a9 | (진입점 미연결) | SCP0059_Shipment_Plan_SEMI_JV.cs:386 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefMain.DIVISION_ID), 3, 1, 20, DefMainLabel.DIVISION_ID, FPHAli… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e851761e | (진입점 미연결) | SCP0059_Shipment_Plan_SEMI_JV.cs:387 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefMain.DIVISION_NAME), 3, 1, 20, DefMainLabel.DIVISION_NAME, FP… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-77172dcd | (진입점 미연결) | SCP0059_Shipment_Plan_SEMI_JV.cs:388 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefMain.OPERATION_GROUP), 3, 1, 20, DefMainLabel.OPERATION_GROUP… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-35f57a95 | (진입점 미연결) | SCP0059_Shipment_Plan_SEMI_JV.cs:389 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefMain.OPERATION_GROUP_DESC), 3, 1, 20, DefMainLabel.OPERATION_… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6ea2c0a9 | (진입점 미연결) | SCP0059_Shipment_Plan_SEMI_JV.cs:390 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefMain.ITEM_ID), 3, 1, 20, DefMainLabel.ITEM_ID, FPHAlign.Cente… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3fba5b9b | (진입점 미연결) | SCP0059_Shipment_Plan_SEMI_JV.cs:391 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefMain.NICK_NAME), 3, 1, 20, DefMainLabel.NICK_NAME, FPHAlign.C… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4ad54822 | (진입점 미연결) | SCP0059_Shipment_Plan_SEMI_JV.cs:392 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefMain.FROM_SITE), 3, 1, 20, DefMainLabel.FROM_SITE, FPHAlign.C… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-32949777 | (진입점 미연결) | SCP0059_Shipment_Plan_SEMI_JV.cs:393 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefMain.FROM_SITE_DESCRIPTION), 3, 1, 20, DefMainLabel.FROM_SITE… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3c390f7b | (진입점 미연결) | SCP0059_Shipment_Plan_SEMI_JV.cs:394 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefMain.BOH), 3, 1, 20, DefMainLabel.BOH, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-59e08cbe | (진입점 미연결) | SCP0059_Shipment_Plan_SEMI_JV.cs:395 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefMain.TO_SITE), 3, 1, 20, DefMainLabel.TO_SITE, FPHAlign.Cente… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3f0c8089 | (진입점 미연결) | SCP0059_Shipment_Plan_SEMI_JV.cs:396 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefMain.TO_SITE_DESCRIPTION), 3, 1, 20, DefMainLabel.T0_SITE_DES… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ca253126 | (진입점 미연결) | SCP0059_Shipment_Plan_SEMI_JV.cs:397 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefMain.TRANSPORT_MODE), 3, 1, 20, DefMainLabel.TRANSPORT_MODE, … | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-29bc8c9a | (진입점 미연결) | SCP0059_Shipment_Plan_SEMI_JV.cs:398 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefMain.LT_DAY), 3, 1, 20, DefMainLabel.LT_DAY, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a9e99390 | (진입점 미연결) | SCP0059_Shipment_Plan_SEMI_JV.cs:399 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefMain.MEASURE_LABEL), 3, 1, 20, DefMainLabel.MEASURE_LABEL, FP… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-eaac1225 | (진입점 미연결) | SCP0059_Shipment_Plan_SEMI_JV.cs:400 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefMain.MEASURE), 3, 1, 20, DefMainLabel.MEASURE, FPHAlign.Cente… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-79060d43 | (진입점 미연결) | SCP0059_Shipment_Plan_SEMI_JV.cs:401 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefMain.MEASURE_ORDER_NO), 3, 1, 20, DefMainLabel.MEASURE_ORDER_… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-39d9a739 | (진입점 미연결) | SCP0059_Shipment_Plan_SEMI_JV.cs:402 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefMain.SHIP_FROZEN), 3, 1, 20, DefMainLabel.SHIP_FROZEN, FPHAli… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-cf931680 | (진입점 미연결) | SCP0059_Shipment_Plan_SEMI_JV.cs:403 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefMain.FROM_YYYYMMDD), 3, 1, 20, DefMainLabel.FROM_YYYYMMDD, FP… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2725a928 | (진입점 미연결) | SCP0059_Shipment_Plan_SEMI_JV.cs:404 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefMain.TO_YYYYMMDD), 3, 1, 20, DefMainLabel.TO_YYYYMMDD, FPHAli… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5d7cc848 | (진입점 미연결) | SCP0059_Shipment_Plan_SEMI_JV.cs:412 |  | GRID_INIT | siMain.Freeze | (0, siMain.GetColumnIndex(DefMain.MEASURE_LABEL) + 1) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-395bea51 | (진입점 미연결) | SCP0059_Shipment_Plan_SEMI_JV.cs:413 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0059_Shipment_Plan_SEMI_JV.InitSpread_2

진입점: this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK)] / this.Load / this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName)) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Equals("S"))] / this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName)) ▸ if (MessageHelper.GMessageBox("MSG00016") == DialogResult.Yes) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-262e02ff | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 6 | SCP0059_Shipment_Plan_SEMI_JV.cs:324 |  | GRID_INIT | spdInfo.InitSheet | (SpdSheet.shtMain) | 그리드 재구성/초기화 |  |  |  |
| AC-c29e9a60 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 6 | SCP0059_Shipment_Plan_SEMI_JV.cs:328 |  | GRID_INIT | siMain.SetSheetHeaderColumn | (spdInfo, 3) | 그리드 재구성/초기화 |  |  |  |
| AC-b9b48882 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 6 | SCP0059_Shipment_Plan_SEMI_JV.cs:332 |  | GRID_SET | siMain.ActiveSheet.ColumnHeader.Columns[siMain.GetColumnIndex(DefMain.TO_SITE_DESCRIPTION)… | new Font(spdMain.Font.Name, spdMain.Font.Size, FontStyle.Bold) | 그리드 속성/값 설정 |  |  |  |
| AC-823e7cdb | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 6 | SCP0059_Shipment_Plan_SEMI_JV.cs:333 |  | GRID_SET | siMain.ActiveSheet.ColumnHeader.Columns[siMain.GetColumnIndex(DefMain.TRANSPORT_MODE)].Fon… | new Font(spdMain.Font.Name, spdMain.Font.Size, FontStyle.Bold) | 그리드 속성/값 설정 |  |  |  |
| AC-47590085 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 6 | SCP0059_Shipment_Plan_SEMI_JV.cs:336 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f9c3c4ee | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 6 | SCP0059_Shipment_Plan_SEMI_JV.cs:340 | if (!division.Substring(0, 2).Equals("EE")) | GRID_SET | spdInfo.ActiveSheet.Columns[siMain.GetColumnIndex("ELECTRODE_TYPE")].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-d03bfd6b | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 6 | SCP0059_Shipment_Plan_SEMI_JV.cs:341 | if (!division.Substring(0, 2).Equals("EE")) | GRID_SET | spdInfo.ActiveSheet.Columns[siMain.GetColumnIndex("ORIGIN_FROM_DIVISION_ID")].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-d2e46cd3 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 6 | SCP0059_Shipment_Plan_SEMI_JV.cs:342 | if (!division.Substring(0, 2).Equals("EE")) | GRID_SET | spdInfo.ActiveSheet.Columns[siMain.GetColumnIndex("ORIGIN_TO_DIVISION_ID")].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-1a07a6cf | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 6 | SCP0059_Shipment_Plan_SEMI_JV.cs:346 | else of (!division.Substring(0, 2).Equals("EE")) | GRID_SET | spdInfo.ActiveSheet.Columns[siMain.GetColumnIndex("ELECTRODE_TYPE")].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-7c68a3b5 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 6 | SCP0059_Shipment_Plan_SEMI_JV.cs:347 | else of (!division.Substring(0, 2).Equals("EE")) | GRID_SET | spdInfo.ActiveSheet.Columns[siMain.GetColumnIndex("ORIGIN_FROM_DIVISION_ID")].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-09bf8f21 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 6 | SCP0059_Shipment_Plan_SEMI_JV.cs:348 | else of (!division.Substring(0, 2).Equals("EE")) | GRID_SET | spdInfo.ActiveSheet.Columns[siMain.GetColumnIndex("ORIGIN_TO_DIVISION_ID")].Visible | true | 그리드 속성/값 설정 |  |  |  |

## SCP0059_Shipment_Plan_SEMI_JV.InitSpreadDateColumn

진입점: this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK)] / this.Load / this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName)) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Equals("S"))] / this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName)) ▸ if (MessageHelper.GMessageBox("MSG00016") == DialogResult.Yes) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4969a4d8 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | SCP0059_Shipment_Plan_SEMI_JV.cs:449 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sColumnName.IndexOf("B_") > 0) | GRID_INIT | spdInfo.AddTextColumn | (sColumnLabelname, sColumnName, FPMerge.None, 0, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4f0698e0 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | SCP0059_Shipment_Plan_SEMI_JV.cs:450 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sColumnName.IndexOf("B_") > 0) | GRID_INIT | spdInfo.SetReNumerCellType | (spdInfo, spdInfo.GetColumnIndex(sColumnName), -9999999999, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-b06ff69b | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | SCP0059_Shipment_Plan_SEMI_JV.cs:454 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sColumnName.IndexOf("B_") > 0) | GRID_INIT | spdInfo.AddNumColumn | (sColumnLabelname, sColumnName, FPMerge.None, 70, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-189c9edb | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | SCP0059_Shipment_Plan_SEMI_JV.cs:455 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sColumnName.IndexOf("B_") > 0) | GRID_INIT | spdInfo.SetReNumerCellType | (spdInfo, spdInfo.GetColumnIndex(sColumnName), -9999999999, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-5e8428cd | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | SCP0059_Shipment_Plan_SEMI_JV.cs:459 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sColumnName.IndexOf("B_") > 0) ▸ if (sDayCode == DefMainLabel.Saturday \|\| sDa… | GRID_SET | spdInfo.Sheet().ColumnHeader.Cells[2, spdInfo.GetMaxColumnIndex()].ForeColor | sDayCode == DefMainLabel.Saturday ? Color.Blue : Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-abbc59d4 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | SCP0059_Shipment_Plan_SEMI_JV.cs:466 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5f8203dc | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | SCP0059_Shipment_Plan_SEMI_JV.cs:467 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e027201f | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | SCP0059_Shipment_Plan_SEMI_JV.cs:472 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5b1211cb | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | SCP0059_Shipment_Plan_SEMI_JV.cs:473 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 30, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a0da1c4e | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | SCP0059_Shipment_Plan_SEMI_JV.cs:481 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName != sSmallLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-27bed58a | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | SCP0059_Shipment_Plan_SEMI_JV.cs:482 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName != sSmallLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0c902c51 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | SCP0059_Shipment_Plan_SEMI_JV.cs:492 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2bebfe7d | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | SCP0059_Shipment_Plan_SEMI_JV.cs:493 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e2828399 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | SCP0059_Shipment_Plan_SEMI_JV.cs:494 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a3df4147 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | SCP0059_Shipment_Plan_SEMI_JV.cs:495 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0059_Shipment_Plan_SEMI_JV.InsertRow

진입점: this.spdMain.CellClick [if ((e.Column == siMain.GetColumnIndex(DefMain.TRANSPORT_MODE) \|\| e.Column == siMain.GetColumnIndex(DefMain.TO_SITE_DESCRIPT…)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bb8b58dc | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0059_Shipment_Plan_SEMI_JV.cs:2860 | if (siMain.Sheet().Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-da948dd1 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0059_Shipment_Plan_SEMI_JV.cs:2884 |  | DATA_OP | dsBinding.Tables[0].Select() .Where(c => c[DefMain.DIVISION_ID].ToString() == division.ToS… | () | 데이터 객체 조작/조회 |  |  |  |
| AC-addae54b | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0059_Shipment_Plan_SEMI_JV.cs:2884 |  | DATA_OP | dsBinding.Tables[0].Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-57b04616 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0059_Shipment_Plan_SEMI_JV.cs:2892 |  | DATA_OP | dsBinding.Tables[0].Select() .Where(c => c[DefMain.DIVISION_ID].ToString() == division.ToS… | () | 데이터 객체 조작/조회 |  |  |  |
| AC-2d0870d5 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0059_Shipment_Plan_SEMI_JV.cs:2892 |  | DATA_OP | dsBinding.Tables[0].Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-851e4016 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0059_Shipment_Plan_SEMI_JV.cs:2902 |  | POPUP | new SCM0002_GetBODPopup | (dtCaller, 1, this._plan_Start_Date) | 팝업/폼 생성 |  |  |  |
| AC-591a4668 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0059_Shipment_Plan_SEMI_JV.cs:2903 |  | UI_PROP | popup.Width | 1050 | 속성 Width 설정 |  |  |  |
| AC-1c1c3d79 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0059_Shipment_Plan_SEMI_JV.cs:2904 |  | UI_PROP | popup.Height | 350 | 속성 Height 설정 |  |  |  |
| AC-2bec2a10 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0059_Shipment_Plan_SEMI_JV.cs:2905 |  | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-7b851c9e | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0059_Shipment_Plan_SEMI_JV.cs:2909 |  | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-a34039b8 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0059_Shipment_Plan_SEMI_JV.cs:2913 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (popup.retList.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f5d09064 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0059_Shipment_Plan_SEMI_JV.cs:2926 | if (popup.ShowDialog() == DialogResult.OK) | DATA_OP | dtCaller2.DefaultView.ToTable | (true, distinct) | 데이터 객체 조작/조회 |  |  |  |
| AC-15cfa45b | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0059_Shipment_Plan_SEMI_JV.cs:2945 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (toSite.ToString() == popupToSite) | DATA_OP | dt2.Select().Where(c => c[DefMain.MEASURE].ToString().Contains("SHIP")).CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-9dd811c6 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0059_Shipment_Plan_SEMI_JV.cs:2945 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (toSite.ToString() == popupToSite) | DATA_OP | dt2.Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-d136f73f | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0059_Shipment_Plan_SEMI_JV.cs:2945 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (toSite.ToString() == popupToSite) ▸ lambda | DATA_OP | c[DefMain.MEASURE].ToString().Contains | ("SHIP") | 데이터 객체 조작/조회 |  |  |  |
| AC-69cf7b63 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0059_Shipment_Plan_SEMI_JV.cs:2949 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (toSite.ToString() == popupToSite) ▸ foreach (DataRow d… | CALL_EXT | siMain.InsertNewRow | (insertStartIdx) | ⚠ 의미 확인 필요 |  |  |  |
| AC-df58e5cd | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0059_Shipment_Plan_SEMI_JV.cs:2951 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (toSite.ToString() == popupToSite) ▸ foreach (DataRow d… | DATA_OP | defaultData.Add | (DefMain.KEY_IDX, dr[DefMain.KEY_IDX]) | 데이터 객체 조작/조회 |  |  |  |
| AC-28b130ef | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0059_Shipment_Plan_SEMI_JV.cs:2952 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (toSite.ToString() == popupToSite) ▸ foreach (DataRow d… | DATA_OP | defaultData.Add | (DefMain.DIVISION_ID, dr[DefMain.DIVISION_ID]) | 데이터 객체 조작/조회 |  |  |  |
| AC-2124fce1 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0059_Shipment_Plan_SEMI_JV.cs:2953 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (toSite.ToString() == popupToSite) ▸ foreach (DataRow d… | DATA_OP | defaultData.Add | (DefMain.OPERATION_GROUP_DESC, dr[DefMain.OPERATION_GROUP_DESC]) | 데이터 객체 조작/조회 |  |  |  |
| AC-319340cd | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0059_Shipment_Plan_SEMI_JV.cs:2954 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (toSite.ToString() == popupToSite) ▸ foreach (DataRow d… | DATA_OP | defaultData.Add | (DefMain.ITEM_ID, dr[DefMain.ITEM_ID]) | 데이터 객체 조작/조회 |  |  |  |
| AC-8b9561cb | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0059_Shipment_Plan_SEMI_JV.cs:2955 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (toSite.ToString() == popupToSite) ▸ foreach (DataRow d… | DATA_OP | defaultData.Add | (DefMain.NICK_NAME, dr[DefMain.NICK_NAME]) | 데이터 객체 조작/조회 |  |  |  |
| AC-9f2a9a01 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0059_Shipment_Plan_SEMI_JV.cs:2958 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (toSite.ToString() == popupToSite) ▸ foreach (DataRow d… | DATA_OP | defaultData.Add | (DefMain.ELECTRODE_TYPE, dtCaller.Rows[0]["ELECTRODE_TYPE"]) | 데이터 객체 조작/조회 |  |  |  |
| AC-a598f734 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0059_Shipment_Plan_SEMI_JV.cs:2961 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (toSite.ToString() == popupToSite) ▸ foreach (DataRow d… | DATA_OP | defaultData.Add | (DefMain.ORIGIN_FROM_DIVISION_ID, dtCaller.Rows[0]["ORIGIN_FROM_DIVISION_ID"]) | 데이터 객체 조작/조회 |  |  |  |
| AC-ddf8ed72 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0059_Shipment_Plan_SEMI_JV.cs:2963 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (toSite.ToString() == popupToSite) ▸ foreach (DataRow d… | DATA_OP | defaultData.Add | (DefMain.FROM_SITE_DESCRIPTION, bod.first_site_name) | 데이터 객체 조작/조회 |  |  |  |
| AC-fc2a61ae | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0059_Shipment_Plan_SEMI_JV.cs:2964 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (toSite.ToString() == popupToSite) ▸ foreach (DataRow d… | DATA_OP | defaultData.Add | (DefMain.BOH, dr[DefMain.BOH]) | 데이터 객체 조작/조회 |  |  |  |
| AC-33480475 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0059_Shipment_Plan_SEMI_JV.cs:2967 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (toSite.ToString() == popupToSite) ▸ foreach (DataRow d… | DATA_OP | defaultData.Add | (DefMain.ORIGIN_TO_DIVISION_ID, dtCaller.Rows[0]["ORIGIN_TO_DIVISION_ID"]) | 데이터 객체 조작/조회 |  |  |  |
| AC-a04671a9 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0059_Shipment_Plan_SEMI_JV.cs:2969 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (toSite.ToString() == popupToSite) ▸ foreach (DataRow d… | DATA_OP | defaultData.Add | (DefMain.TO_SITE_DESCRIPTION, bod.second_site_name) | 데이터 객체 조작/조회 |  |  |  |
| AC-a6b995dc | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0059_Shipment_Plan_SEMI_JV.cs:2970 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (toSite.ToString() == popupToSite) ▸ foreach (DataRow d… | DATA_OP | defaultData.Add | (DefMain.TRANSPORT_MODE, bod.transport_mode) | 데이터 객체 조작/조회 |  |  |  |
| AC-d95782eb | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0059_Shipment_Plan_SEMI_JV.cs:2971 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (toSite.ToString() == popupToSite) ▸ foreach (DataRow d… | DATA_OP | defaultData.Add | (DefMain.LT_DAY, bod.lt_total) | 데이터 객체 조작/조회 |  |  |  |
| AC-316e8db3 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0059_Shipment_Plan_SEMI_JV.cs:2973 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (toSite.ToString() == popupToSite) ▸ foreach (DataRow d… | DATA_OP | defaultData.Add | (DefMain.MEASURE_LABEL, dr[DefMain.MEASURE_LABEL]) | 데이터 객체 조작/조회 |  |  |  |
| AC-ef96a8c9 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0059_Shipment_Plan_SEMI_JV.cs:2974 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (toSite.ToString() == popupToSite) ▸ foreach (DataRow d… | DATA_OP | defaultData.Add | (DefMain.MEASURE, dr[DefMain.MEASURE]) | 데이터 객체 조작/조회 |  |  |  |
| AC-fa160f6e | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0059_Shipment_Plan_SEMI_JV.cs:2975 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (toSite.ToString() == popupToSite) ▸ foreach (DataRow d… | DATA_OP | defaultData.Add | (DefMain.DIVISION_NAME, dr[DefMain.DIVISION_NAME]) | 데이터 객체 조작/조회 |  |  |  |
| AC-21d2ce11 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0059_Shipment_Plan_SEMI_JV.cs:2976 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (toSite.ToString() == popupToSite) ▸ foreach (DataRow d… | DATA_OP | defaultData.Add | (DefMain.OPERATION_GROUP, dr[DefMain.OPERATION_GROUP]) | 데이터 객체 조작/조회 |  |  |  |
| AC-0486ca9d | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0059_Shipment_Plan_SEMI_JV.cs:2978 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (toSite.ToString() == popupToSite) ▸ foreach (DataRow d… | DATA_OP | defaultData.Add | (DefMain.FROM_SITE, bod.first_site) | 데이터 객체 조작/조회 |  |  |  |
| AC-9904a331 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0059_Shipment_Plan_SEMI_JV.cs:2979 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (toSite.ToString() == popupToSite) ▸ foreach (DataRow d… | DATA_OP | defaultData.Add | (DefMain.TO_SITE, bod.second_site) | 데이터 객체 조작/조회 |  |  |  |
| AC-9ad2dc78 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0059_Shipment_Plan_SEMI_JV.cs:2980 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (toSite.ToString() == popupToSite) ▸ foreach (DataRow d… | DATA_OP | defaultData.Add | (DefMain.BOD_ID, bod.bod_id) | 데이터 객체 조작/조회 |  |  |  |
| AC-a29298cd | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0059_Shipment_Plan_SEMI_JV.cs:2982 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (toSite.ToString() == popupToSite) ▸ foreach (DataRow d… | DATA_OP | defaultData.Add | (DefMain.MEASURE_ORDER_NO, dr[DefMain.MEASURE_ORDER_NO]) | 데이터 객체 조작/조회 |  |  |  |
| AC-95010032 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0059_Shipment_Plan_SEMI_JV.cs:2983 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (toSite.ToString() == popupToSite) ▸ foreach (DataRow d… | DATA_OP | defaultData.Add | (DefMain.SHIP_FROZEN, bod.ship_frozen) | 데이터 객체 조작/조회 |  |  |  |
| AC-0614832d | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0059_Shipment_Plan_SEMI_JV.cs:2984 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (toSite.ToString() == popupToSite) ▸ foreach (DataRow d… | DATA_OP | defaultData.Add | (DefMain.FROM_YYYYMMDD, dr[DefMain.FROM_YYYYMMDD]) | 데이터 객체 조작/조회 |  |  |  |
| AC-9230b44c | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0059_Shipment_Plan_SEMI_JV.cs:2985 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (toSite.ToString() == popupToSite) ▸ foreach (DataRow d… | DATA_OP | defaultData.Add | (DefMain.TO_YYYYMMDD, dr[DefMain.TO_YYYYMMDD]) | 데이터 객체 조작/조회 |  |  |  |
| AC-8e9e3ef4 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0059_Shipment_Plan_SEMI_JV.cs:2986 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (toSite.ToString() == popupToSite) ▸ foreach (DataRow d… | DATA_OP | defaultData.Add | (DefMain.BOD_FROM_YYYYMMDD, bod.bod_from_yyyymmdd) | 데이터 객체 조작/조회 |  |  |  |
| AC-b52aa614 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0059_Shipment_Plan_SEMI_JV.cs:2987 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (toSite.ToString() == popupToSite) ▸ foreach (DataRow d… | DATA_OP | defaultData.Add | (DefMain.BOD_TO_YYYYMMDD, bod.bod_to_yyyymmdd) | 데이터 객체 조작/조회 |  |  |  |
| AC-47c6e212 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0059_Shipment_Plan_SEMI_JV.cs:2988 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (toSite.ToString() == popupToSite) ▸ foreach (DataRow d… | GRID_SET | siMain.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |
| AC-3c7ac5f4 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0059_Shipment_Plan_SEMI_JV.cs:2999 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (toSite.ToString() == popupToSite) | DATA_OP | dt2.Select().Where(c => c[DefMain.MEASURE].ToString().Contains("SHIP")).CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-8da01053 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0059_Shipment_Plan_SEMI_JV.cs:2999 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (toSite.ToString() == popupToSite) | DATA_OP | dt2.Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-1314eb88 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0059_Shipment_Plan_SEMI_JV.cs:2999 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (toSite.ToString() == popupToSite) ▸ lambda | DATA_OP | c[DefMain.MEASURE].ToString().Contains | ("SHIP") | 데이터 객체 조작/조회 |  |  |  |
| AC-d1ca6bab | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0059_Shipment_Plan_SEMI_JV.cs:3007 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (toSite.ToString() == popupToSite) ▸ foreach (Data… | CALL_EXT | siMain.InsertNewRow | (insertStartIdx) | ⚠ 의미 확인 필요 |  |  |  |
| AC-033edbba | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0059_Shipment_Plan_SEMI_JV.cs:3009 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (toSite.ToString() == popupToSite) ▸ foreach (Data… | DATA_OP | defaultData.Add | (DefMain.KEY_IDX, dr[DefMain.KEY_IDX]) | 데이터 객체 조작/조회 |  |  |  |
| AC-9a02ee4a | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0059_Shipment_Plan_SEMI_JV.cs:3010 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (toSite.ToString() == popupToSite) ▸ foreach (Data… | DATA_OP | defaultData.Add | (DefMain.DIVISION_ID, dr[DefMain.DIVISION_ID]) | 데이터 객체 조작/조회 |  |  |  |
| AC-5a806044 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0059_Shipment_Plan_SEMI_JV.cs:3011 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (toSite.ToString() == popupToSite) ▸ foreach (Data… | DATA_OP | defaultData.Add | (DefMain.OPERATION_GROUP_DESC, dr[DefMain.OPERATION_GROUP_DESC]) | 데이터 객체 조작/조회 |  |  |  |
| AC-4462f585 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0059_Shipment_Plan_SEMI_JV.cs:3012 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (toSite.ToString() == popupToSite) ▸ foreach (Data… | DATA_OP | defaultData.Add | (DefMain.ITEM_ID, dr[DefMain.ITEM_ID]) | 데이터 객체 조작/조회 |  |  |  |
| AC-c346b583 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0059_Shipment_Plan_SEMI_JV.cs:3013 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (toSite.ToString() == popupToSite) ▸ foreach (Data… | DATA_OP | defaultData.Add | (DefMain.NICK_NAME, dr[DefMain.NICK_NAME]) | 데이터 객체 조작/조회 |  |  |  |
| AC-e653ee68 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0059_Shipment_Plan_SEMI_JV.cs:3016 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (toSite.ToString() == popupToSite) ▸ foreach (Data… | DATA_OP | defaultData.Add | (DefMain.ELECTRODE_TYPE, dtCaller.Rows[0]["ELECTRODE_TYPE"]) | 데이터 객체 조작/조회 |  |  |  |
| AC-d8b2d2d1 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0059_Shipment_Plan_SEMI_JV.cs:3019 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (toSite.ToString() == popupToSite) ▸ foreach (Data… | DATA_OP | defaultData.Add | (DefMain.ORIGIN_FROM_DIVISION_ID, dtCaller.Rows[0]["ORIGIN_FROM_DIVISION_ID"]) | 데이터 객체 조작/조회 |  |  |  |
| AC-0e1c081c | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0059_Shipment_Plan_SEMI_JV.cs:3021 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (toSite.ToString() == popupToSite) ▸ foreach (Data… | DATA_OP | defaultData.Add | (DefMain.FROM_SITE_DESCRIPTION, bod.first_site_name) | 데이터 객체 조작/조회 |  |  |  |
| AC-8eb18637 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0059_Shipment_Plan_SEMI_JV.cs:3022 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (toSite.ToString() == popupToSite) ▸ foreach (Data… | DATA_OP | defaultData.Add | (DefMain.BOH, dr[DefMain.BOH]) | 데이터 객체 조작/조회 |  |  |  |
| AC-55d1b8fc | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0059_Shipment_Plan_SEMI_JV.cs:3025 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (toSite.ToString() == popupToSite) ▸ foreach (Data… | DATA_OP | defaultData.Add | (DefMain.ORIGIN_TO_DIVISION_ID, dtCaller.Rows[0]["ORIGIN_TO_DIVISION_ID"]) | 데이터 객체 조작/조회 |  |  |  |
| AC-e326e714 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0059_Shipment_Plan_SEMI_JV.cs:3028 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (toSite.ToString() == popupToSite) ▸ foreach (Data… | DATA_OP | dr[DefMain.MEASURE].ToString().Contains | ("SHIP") | 데이터 객체 조작/조회 |  |  |  |
| AC-6a854407 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0059_Shipment_Plan_SEMI_JV.cs:3030 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (toSite.ToString() == popupToSite) ▸ foreach (Data… | DATA_OP | defaultData.Add | (DefMain.TO_SITE_DESCRIPTION, bod.second_site_name) | 데이터 객체 조작/조회 |  |  |  |
| AC-68f3bc76 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0059_Shipment_Plan_SEMI_JV.cs:3031 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (toSite.ToString() == popupToSite) ▸ foreach (Data… | DATA_OP | defaultData.Add | (DefMain.TRANSPORT_MODE, bod.transport_mode) | 데이터 객체 조작/조회 |  |  |  |
| AC-2fedec01 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0059_Shipment_Plan_SEMI_JV.cs:3032 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (toSite.ToString() == popupToSite) ▸ foreach (Data… | DATA_OP | defaultData.Add | (DefMain.LT_DAY, bod.lt_total) | 데이터 객체 조작/조회 |  |  |  |
| AC-852be77d | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0059_Shipment_Plan_SEMI_JV.cs:3036 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (toSite.ToString() == popupToSite) ▸ foreach (Data… | DATA_OP | defaultData.Add | (DefMain.TO_SITE_DESCRIPTION, "-") | 데이터 객체 조작/조회 |  |  |  |
| AC-44eefad0 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0059_Shipment_Plan_SEMI_JV.cs:3037 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (toSite.ToString() == popupToSite) ▸ foreach (Data… | DATA_OP | defaultData.Add | (DefMain.TRANSPORT_MODE, "-") | 데이터 객체 조작/조회 |  |  |  |
| AC-f1cb2ad7 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0059_Shipment_Plan_SEMI_JV.cs:3038 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (toSite.ToString() == popupToSite) ▸ foreach (Data… | DATA_OP | defaultData.Add | (DefMain.LT_DAY, "0") | 데이터 객체 조작/조회 |  |  |  |
| AC-3a5da666 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0059_Shipment_Plan_SEMI_JV.cs:3041 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (toSite.ToString() == popupToSite) ▸ foreach (Data… | DATA_OP | defaultData.Add | (DefMain.MEASURE_LABEL, dr[DefMain.MEASURE_LABEL]) | 데이터 객체 조작/조회 |  |  |  |
| AC-a9daa579 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0059_Shipment_Plan_SEMI_JV.cs:3042 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (toSite.ToString() == popupToSite) ▸ foreach (Data… | DATA_OP | defaultData.Add | (DefMain.MEASURE, dr[DefMain.MEASURE]) | 데이터 객체 조작/조회 |  |  |  |
| AC-4a520f01 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0059_Shipment_Plan_SEMI_JV.cs:3043 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (toSite.ToString() == popupToSite) ▸ foreach (Data… | DATA_OP | defaultData.Add | (DefMain.DIVISION_NAME, dr[DefMain.DIVISION_NAME]) | 데이터 객체 조작/조회 |  |  |  |
| AC-19f4b6d9 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0059_Shipment_Plan_SEMI_JV.cs:3044 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (toSite.ToString() == popupToSite) ▸ foreach (Data… | DATA_OP | defaultData.Add | (DefMain.OPERATION_GROUP, dr[DefMain.OPERATION_GROUP]) | 데이터 객체 조작/조회 |  |  |  |
| AC-b5855b5d | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0059_Shipment_Plan_SEMI_JV.cs:3045 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (toSite.ToString() == popupToSite) ▸ foreach (Data… | DATA_OP | defaultData.Add | (DefMain.FROM_SITE, bod.first_site) | 데이터 객체 조작/조회 |  |  |  |
| AC-03014d1e | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0059_Shipment_Plan_SEMI_JV.cs:3047 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (toSite.ToString() == popupToSite) ▸ foreach (Data… | DATA_OP | dr[DefMain.MEASURE].ToString().Contains | ("SHIP") | 데이터 객체 조작/조회 |  |  |  |
| AC-c96097f7 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0059_Shipment_Plan_SEMI_JV.cs:3049 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (toSite.ToString() == popupToSite) ▸ foreach (Data… | DATA_OP | defaultData.Add | (DefMain.TO_SITE, bod.second_site) | 데이터 객체 조작/조회 |  |  |  |
| AC-2f704c89 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0059_Shipment_Plan_SEMI_JV.cs:3050 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (toSite.ToString() == popupToSite) ▸ foreach (Data… | DATA_OP | defaultData.Add | (DefMain.BOD_ID, bod.bod_id) | 데이터 객체 조작/조회 |  |  |  |
| AC-bed5494e | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0059_Shipment_Plan_SEMI_JV.cs:3054 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (toSite.ToString() == popupToSite) ▸ foreach (Data… | DATA_OP | defaultData.Add | (DefMain.TO_SITE, "-") | 데이터 객체 조작/조회 |  |  |  |
| AC-911216e2 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0059_Shipment_Plan_SEMI_JV.cs:3055 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (toSite.ToString() == popupToSite) ▸ foreach (Data… | DATA_OP | defaultData.Add | (DefMain.BOD_ID, "-") | 데이터 객체 조작/조회 |  |  |  |
| AC-c95aa22c | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0059_Shipment_Plan_SEMI_JV.cs:3058 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (toSite.ToString() == popupToSite) ▸ foreach (Data… | DATA_OP | defaultData.Add | (DefMain.MEASURE_ORDER_NO, dr[DefMain.MEASURE_ORDER_NO]) | 데이터 객체 조작/조회 |  |  |  |
| AC-29254803 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0059_Shipment_Plan_SEMI_JV.cs:3059 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (toSite.ToString() == popupToSite) ▸ foreach (Data… | DATA_OP | defaultData.Add | (DefMain.SHIP_FROZEN, bod.ship_frozen) | 데이터 객체 조작/조회 |  |  |  |
| AC-e90ef54a | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0059_Shipment_Plan_SEMI_JV.cs:3060 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (toSite.ToString() == popupToSite) ▸ foreach (Data… | DATA_OP | defaultData.Add | (DefMain.FROM_YYYYMMDD, dr[DefMain.FROM_YYYYMMDD]) | 데이터 객체 조작/조회 |  |  |  |
| AC-1e8dfaef | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0059_Shipment_Plan_SEMI_JV.cs:3061 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (toSite.ToString() == popupToSite) ▸ foreach (Data… | DATA_OP | defaultData.Add | (DefMain.TO_YYYYMMDD, dr[DefMain.TO_YYYYMMDD]) | 데이터 객체 조작/조회 |  |  |  |
| AC-22cebf67 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0059_Shipment_Plan_SEMI_JV.cs:3062 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (toSite.ToString() == popupToSite) ▸ foreach (Data… | DATA_OP | defaultData.Add | (DefMain.BOD_FROM_YYYYMMDD, bod.bod_from_yyyymmdd) | 데이터 객체 조작/조회 |  |  |  |
| AC-2d5901bd | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0059_Shipment_Plan_SEMI_JV.cs:3063 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (toSite.ToString() == popupToSite) ▸ foreach (Data… | DATA_OP | defaultData.Add | (DefMain.BOD_TO_YYYYMMDD, bod.bod_to_yyyymmdd) | 데이터 객체 조작/조회 |  |  |  |
| AC-f54743ca | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0059_Shipment_Plan_SEMI_JV.cs:3064 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (toSite.ToString() == popupToSite) ▸ foreach (Data… | GRID_SET | siMain.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |

## SCP0059_Shipment_Plan_SEMI_JV.RetValue

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-97b772e2 | (진입점 미연결) | SCP0059_Shipment_Plan_SEMI_JV.cs:1464 |  | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |

## SCP0059_Shipment_Plan_SEMI_JV.SaveData_FixInfo

진입점: this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))] / this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName)) ▸ if (MessageHelper.GMessageBox("MSG00016") == DialogResult.Yes)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a881265f | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0059_Shipment_Plan_SEMI_JV.cs:3173 | if (fps.Name == "spdMain") | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-32af0d87 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0059_Shipment_Plan_SEMI_JV.cs:3178 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (siMain.ActiveSheet.Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-56616426 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0059_Shipment_Plan_SEMI_JV.cs:3202 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (fixType == "F") | POPUP | new SCM0002_RejectReasonPopup | ("Fix Reason") | 팝업/폼 생성 |  |  |  |
| AC-c612638b | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0059_Shipment_Plan_SEMI_JV.cs:3203 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (fixType == "F") | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-ca315f0b | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0059_Shipment_Plan_SEMI_JV.cs:3204 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (fixType == "F") | UI_PROP | popup.Width | 600 | 속성 Width 설정 |  |  |  |
| AC-90f1c6d0 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0059_Shipment_Plan_SEMI_JV.cs:3205 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (fixType == "F") | UI_PROP | popup.Height | 230 | 속성 Height 설정 |  |  |  |
| AC-6d5ffe2e | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0059_Shipment_Plan_SEMI_JV.cs:3207 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (fixType == "F") | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-ec297ba6 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0059_Shipment_Plan_SEMI_JV.cs:3216 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (fixType == "F") ▸ else of (popup.ShowDial… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9c0b89ae | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0059_Shipment_Plan_SEMI_JV.cs:3229 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (selCells.Length < 1) | MESSAGE | MessageHelper.GMessageBox | ("MSG00134", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-2ef7e16c | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0059_Shipment_Plan_SEMI_JV.cs:3230 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (selCells.Length < 1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-31979ae1 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0059_Shipment_Plan_SEMI_JV.cs:3236 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("A") | 데이터 객체 조작/조회 |  |  |  |
| AC-cbf9d7ec | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0059_Shipment_Plan_SEMI_JV.cs:3237 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_active_flag") | 데이터 객체 조작/조회 |  |  |  |
| AC-18ad604f | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0059_Shipment_Plan_SEMI_JV.cs:3238 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_division_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-636d0046 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0059_Shipment_Plan_SEMI_JV.cs:3239 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_plan_start_yyyymmdd") | 데이터 객체 조작/조회 |  |  |  |
| AC-7c91ae63 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0059_Shipment_Plan_SEMI_JV.cs:3240 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_plan_type") | 데이터 객체 조작/조회 |  |  |  |
| AC-150e7577 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0059_Shipment_Plan_SEMI_JV.cs:3241 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_seq") | 데이터 객체 조작/조회 |  |  |  |
| AC-7962778b | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0059_Shipment_Plan_SEMI_JV.cs:3242 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_biz_type") | 데이터 객체 조작/조회 |  |  |  |
| AC-5c848977 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0059_Shipment_Plan_SEMI_JV.cs:3243 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_operation_group") | 데이터 객체 조작/조회 |  |  |  |
| AC-c668a650 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0059_Shipment_Plan_SEMI_JV.cs:3244 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_item_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-0cd00590 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0059_Shipment_Plan_SEMI_JV.cs:3245 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_from_site") | 데이터 객체 조작/조회 |  |  |  |
| AC-23924c0b | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0059_Shipment_Plan_SEMI_JV.cs:3246 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_bod_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-da144207 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0059_Shipment_Plan_SEMI_JV.cs:3247 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_measure") | 데이터 객체 조작/조회 |  |  |  |
| AC-ee3ec7ba | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0059_Shipment_Plan_SEMI_JV.cs:3248 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_yyyymmdd") | 데이터 객체 조작/조회 |  |  |  |
| AC-dec2bba7 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0059_Shipment_Plan_SEMI_JV.cs:3249 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_to_site") | 데이터 객체 조작/조회 |  |  |  |
| AC-4ee95ed5 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0059_Shipment_Plan_SEMI_JV.cs:3250 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_qty") | 데이터 객체 조작/조회 |  |  |  |
| AC-ea1b268b | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0059_Shipment_Plan_SEMI_JV.cs:3251 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_origin_from_division_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-fb60387d | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0059_Shipment_Plan_SEMI_JV.cs:3252 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_origin_to_division_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-3bc43040 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0059_Shipment_Plan_SEMI_JV.cs:3253 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_electrode_type") | 데이터 객체 조작/조회 |  |  |  |
| AC-9a44612d | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0059_Shipment_Plan_SEMI_JV.cs:3254 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_fix_reason") | 데이터 객체 조작/조회 |  |  |  |
| AC-4af0854c | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0059_Shipment_Plan_SEMI_JV.cs:3255 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_created_by") | 데이터 객체 조작/조회 |  |  |  |
| AC-54aac6a7 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0059_Shipment_Plan_SEMI_JV.cs:3256 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_last_updated_by") | 데이터 객체 조작/조회 |  |  |  |
| AC-368b5769 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0059_Shipment_Plan_SEMI_JV.cs:3257 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_time_zone") | 데이터 객체 조작/조회 |  |  |  |
| AC-16607b76 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0059_Shipment_Plan_SEMI_JV.cs:3258 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("debug_mode") | 데이터 객체 조작/조회 |  |  |  |
| AC-760144a4 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0059_Shipment_Plan_SEMI_JV.cs:3259 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dsInput.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-4cf50092 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0059_Shipment_Plan_SEMI_JV.cs:3290 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | GRID_STYLE | siMain.SetBGColor | (i, j, i, j, ControlColor.InvalidColor) | 그리드 표시 설정 |  |  |  |
| AC-f03da73c | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0059_Shipment_Plan_SEMI_JV.cs:3291 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | MESSAGE | MessageHelper.GMessageBox | ("MSG00026", new object[] { null }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-642c1b47 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0059_Shipment_Plan_SEMI_JV.cs:3292 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-19f8f3c5 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0059_Shipment_Plan_SEMI_JV.cs:3298 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | CALL_EXT | siMain.GetBGColor | (i, j) | ⚠ 의미 확인 필요 |  |  |  |
| AC-580671af | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0059_Shipment_Plan_SEMI_JV.cs:3327 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | DATA_OP | dsInput.Tables[0].NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-5f282cbf | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0059_Shipment_Plan_SEMI_JV.cs:3328 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | DATA_OP | dr["p_active_flag"] | strAction | 행/컬럼 값 대입 |  |  |  |
| AC-bc3f8b9d | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0059_Shipment_Plan_SEMI_JV.cs:3329 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | DATA_OP | dr["p_division_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.DIVISION_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-36459736 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0059_Shipment_Plan_SEMI_JV.cs:3330 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | DATA_OP | dr["p_biz_type"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.OPERATION_GROUP)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-3d7a0f46 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0059_Shipment_Plan_SEMI_JV.cs:3331 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | DATA_OP | dr["p_item_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.ITEM_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-06df0b9d | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0059_Shipment_Plan_SEMI_JV.cs:3332 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | DATA_OP | dr["p_to_site"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.TO_SITE)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-e0c14cf5 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0059_Shipment_Plan_SEMI_JV.cs:3333 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | DATA_OP | dr["p_from_site"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.FROM_SITE)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-7d499b4c | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0059_Shipment_Plan_SEMI_JV.cs:3334 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | DATA_OP | dr["p_bod_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.BOD_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-116e2a28 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0059_Shipment_Plan_SEMI_JV.cs:3335 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | DATA_OP | dr["p_yyyymmdd"] | strYYYYMMDD | 행/컬럼 값 대입 |  |  |  |
| AC-92515ba5 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0059_Shipment_Plan_SEMI_JV.cs:3336 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | DATA_OP | dr["p_qty"] | sQty | 행/컬럼 값 대입 |  |  |  |
| AC-00eed2c5 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0059_Shipment_Plan_SEMI_JV.cs:3337 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | DATA_OP | dr["p_origin_from_division_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.ORIGIN_FROM_DIVISION_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-6e7aaea8 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0059_Shipment_Plan_SEMI_JV.cs:3338 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | DATA_OP | dr["p_origin_to_division_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.ORIGIN_TO_DIVISION_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-0f333185 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0059_Shipment_Plan_SEMI_JV.cs:3339 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | DATA_OP | dr["p_electrode_type"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.ELECTRODE_TYPE)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-75e3fb3d | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0059_Shipment_Plan_SEMI_JV.cs:3340 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | DATA_OP | dr["p_fix_reason"] | strReason | 행/컬럼 값 대입 |  |  |  |
| AC-e4235593 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0059_Shipment_Plan_SEMI_JV.cs:3341 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | DATA_OP | dr["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-11e5bd22 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0059_Shipment_Plan_SEMI_JV.cs:3342 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | DATA_OP | dr["p_last_updated_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-ae4a9bf3 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0059_Shipment_Plan_SEMI_JV.cs:3343 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | DATA_OP | dr["p_time_zone"] | UserInfoContext.Current[UserInfoProperites.TimeZone] | 행/컬럼 값 대입 |  |  |  |
| AC-daa43d54 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0059_Shipment_Plan_SEMI_JV.cs:3344 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | DATA_OP | dr["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-4f603d83 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0059_Shipment_Plan_SEMI_JV.cs:3345 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | DATA_OP | dsInput.Tables[0].Rows.Add | (dr) | 데이터 객체 조작/조회 |  |  |  |
| AC-a6229084 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0059_Shipment_Plan_SEMI_JV.cs:3359 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | CALL_EXT | siMain.GetBGColor | (i, j + nDayCntOfWeek) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ed22e753 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0059_Shipment_Plan_SEMI_JV.cs:3368 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | GRID_STYLE | siMain.SetBGColor | (i, j + nDayCntOfWeek, i, j + nDayCntOfWeek, ControlColor.InvalidColor) | 그리드 표시 설정 |  |  |  |
| AC-08547152 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0059_Shipment_Plan_SEMI_JV.cs:3369 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | MESSAGE | MessageHelper.GMessageBox | ("MSG00026", new object[] { null }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-5b81c21c | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0059_Shipment_Plan_SEMI_JV.cs:3370 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0762785f | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0059_Shipment_Plan_SEMI_JV.cs:3397 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | DATA_OP | dsInput.Tables[0].NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-abbd3009 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0059_Shipment_Plan_SEMI_JV.cs:3398 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | DATA_OP | dr["p_active_flag"] | strAction | 행/컬럼 값 대입 |  |  |  |
| AC-f9ec076a | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0059_Shipment_Plan_SEMI_JV.cs:3399 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | DATA_OP | dr["p_division_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.DIVISION_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-81709378 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0059_Shipment_Plan_SEMI_JV.cs:3400 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | DATA_OP | dr["p_biz_type"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.OPERATION_GROUP)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-cc332ee7 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0059_Shipment_Plan_SEMI_JV.cs:3401 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | DATA_OP | dr["p_item_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.ITEM_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-0b988a6d | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0059_Shipment_Plan_SEMI_JV.cs:3402 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | DATA_OP | dr["p_to_site"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.TO_SITE)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-df79ad64 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0059_Shipment_Plan_SEMI_JV.cs:3403 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | DATA_OP | dr["p_from_site"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.FROM_SITE)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-05b9f718 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0059_Shipment_Plan_SEMI_JV.cs:3404 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | DATA_OP | dr["p_bod_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.BOD_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-d4f193e9 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0059_Shipment_Plan_SEMI_JV.cs:3405 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | DATA_OP | dr["p_yyyymmdd"] | strYYYYMMDD | 행/컬럼 값 대입 |  |  |  |
| AC-78a97a6c | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0059_Shipment_Plan_SEMI_JV.cs:3406 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | DATA_OP | dr["p_qty"] | sQty | 행/컬럼 값 대입 |  |  |  |
| AC-4d7b9ab1 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0059_Shipment_Plan_SEMI_JV.cs:3407 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | DATA_OP | dr["p_origin_from_division_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.ORIGIN_FROM_DIVISION_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-aeccd2c3 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0059_Shipment_Plan_SEMI_JV.cs:3408 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | DATA_OP | dr["p_origin_to_division_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.ORIGIN_TO_DIVISION_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-76f19b2a | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0059_Shipment_Plan_SEMI_JV.cs:3409 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | DATA_OP | dr["p_electrode_type"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.ELECTRODE_TYPE)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-ff7d05b7 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0059_Shipment_Plan_SEMI_JV.cs:3410 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | DATA_OP | dr["p_fix_reason"] | strReason | 행/컬럼 값 대입 |  |  |  |
| AC-3e648b4d | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0059_Shipment_Plan_SEMI_JV.cs:3411 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | DATA_OP | dr["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-35afcd43 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0059_Shipment_Plan_SEMI_JV.cs:3412 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | DATA_OP | dr["p_last_updated_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-6ba27796 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0059_Shipment_Plan_SEMI_JV.cs:3413 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | DATA_OP | dr["p_time_zone"] | UserInfoContext.Current[UserInfoProperites.TimeZone] | 행/컬럼 값 대입 |  |  |  |
| AC-21bb19cd | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0059_Shipment_Plan_SEMI_JV.cs:3414 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | DATA_OP | dr["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-a1149b38 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0059_Shipment_Plan_SEMI_JV.cs:3415 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | DATA_OP | dsInput.Tables[0].Rows.Add | (dr) | 데이터 객체 조작/조회 |  |  |  |
| AC-24f5c70e | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0059_Shipment_Plan_SEMI_JV.cs:3467 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (fixType.Equals("U") && iCount == 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00046", new object[] { null }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-4186bec3 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0059_Shipment_Plan_SEMI_JV.cs:3468 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (fixType.Equals("U") && iCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-144be11e | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0059_Shipment_Plan_SEMI_JV.cs:3473 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) | DATA_OP | dsInput.Tables[0].AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-7bb23735 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0059_Shipment_Plan_SEMI_JV.cs:3478 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-806a50ef | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0059_Shipment_Plan_SEMI_JV.cs:3487 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | CALL_EXT | sql.AddParameter | (SqlDbType.Structured, "@SCP0010", dsInput.Tables[0]) | ⚠ 의미 확인 필요 |  |  |  |
| AC-7e115b38 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0059_Shipment_Plan_SEMI_JV.cs:3488 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | ENDPOINT | sql.ExcuteProcedure | ("dbo.SCP0010_SAVE_ANL_SHIPMENT_PLAN_SEMI_FIX_DATASET") ⇒ biz:AppService.GeneralRunProcedureCustomTable [procedure=dbo.SCP0010_SAVE_ANL_SH… | 엔드포인트 호출 |  |  |  |
| AC-831df55c | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0059_Shipment_Plan_SEMI_JV.cs:3491 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-ea9b21f9 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0059_Shipment_Plan_SEMI_JV.cs:3496 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (result != null &&… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { result.Rows[0]["result_cnt"].ToString() }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-29263cba | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0059_Shipment_Plan_SEMI_JV.cs:3505 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ else of (result != nu… | MESSAGE | MessageHelper.GMessageBox | ("MSG00003", new object[] { ReErrorMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-678805db | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0059_Shipment_Plan_SEMI_JV.cs:3514 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-8a8e8b4f | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0059_Shipment_Plan_SEMI_JV.cs:3515 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-5346151a | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0059_Shipment_Plan_SEMI_JV.cs:3521 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ finally ▸ if (!prgCloseF) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-4ddfc2b6 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0059_Shipment_Plan_SEMI_JV.cs:3528 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ else of (iCount > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00252", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-11789817 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0059_Shipment_Plan_SEMI_JV.cs:3529 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ else of (iCount > 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0059_Shipment_Plan_SEMI_JV.SaveData_Main

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d601912e | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2057 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (siMain.ActiveSheet.Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e2d1493a | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2059 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (!Get_IsSaveYn()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c59f42cb | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2061 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-daa463da | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2064 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-ae056b60 | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2088 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (iRow < siMain.ActiveSheet.Rows.… | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-36bef209 | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2090 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (iRow < siMain.ActiveSheet.Rows.… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-15aa7f23 | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2094 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (iRow < siMain.ActiveSheet.Rows.… | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-d54ec193 | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2096 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (iRow < siMain.ActiveSheet.Rows.… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-57ccdd21 | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2104 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (iRow < siMain.ActiveSheet.Rows.… | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-5f66cfba | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2106 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (iRow < siMain.ActiveSheet.Rows.… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5d8b0809 | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2121 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (iRow < siMain.ActiveSheet.Rows.… | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-b9f701ab | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2123 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (iRow < siMain.ActiveSheet.Rows.… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7aa2832b | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2127 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (iRow < siMain.ActiveSheet.Rows.… | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-799895e0 | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2129 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (iRow < siMain.ActiveSheet.Rows.… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4f3ae0bf | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2136 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | FLAG | saveDS | new DataSet() | 화면 필드/플래그 변경 |  |  |  |
| AC-873489f6 | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2138 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dt.Columns.Add | ("A", typeof(char)) | 데이터 객체 조작/조회 |  |  |  |
| AC-e768e084 | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2139 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dt.Columns.Add | ("p_active_flag") | 데이터 객체 조작/조회 |  |  |  |
| AC-7c20f07a | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2140 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dt.Columns.Add | ("p_division_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-ff5000ed | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2141 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dt.Columns.Add | ("p_plan_start_yyyymmdd") | 데이터 객체 조작/조회 |  |  |  |
| AC-c900b016 | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2142 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dt.Columns.Add | ("p_plan_type") | 데이터 객체 조작/조회 |  |  |  |
| AC-28d541f8 | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2143 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dt.Columns.Add | ("p_seq") | 데이터 객체 조작/조회 |  |  |  |
| AC-5308be5d | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2144 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dt.Columns.Add | ("p_operation_group") | 데이터 객체 조작/조회 |  |  |  |
| AC-f30ec973 | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2145 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dt.Columns.Add | ("p_item_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-7a00c444 | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2146 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dt.Columns.Add | ("p_from_site") | 데이터 객체 조작/조회 |  |  |  |
| AC-ec6f87c1 | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2147 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dt.Columns.Add | ("p_bod_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-0bb7d03d | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2148 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dt.Columns.Add | ("p_measure") | 데이터 객체 조작/조회 |  |  |  |
| AC-30c4417a | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2149 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dt.Columns.Add | ("p_yyyymmdd") | 데이터 객체 조작/조회 |  |  |  |
| AC-0d990e58 | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2150 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dt.Columns.Add | ("p_to_site") | 데이터 객체 조작/조회 |  |  |  |
| AC-a5d12ed4 | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2151 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dt.Columns.Add | ("p_qty") | 데이터 객체 조작/조회 |  |  |  |
| AC-ef9516a1 | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2152 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dt.Columns.Add | ("p_origin_from_division_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-38af025a | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2153 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dt.Columns.Add | ("p_origin_to_division_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-e84ac6be | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2154 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dt.Columns.Add | ("p_electrode_type") | 데이터 객체 조작/조회 |  |  |  |
| AC-8ea96d92 | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2155 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dt.Columns.Add | ("p_created_by") | 데이터 객체 조작/조회 |  |  |  |
| AC-8e4f0461 | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2156 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dt.Columns.Add | ("p_last_updated_by") | 데이터 객체 조작/조회 |  |  |  |
| AC-0d325a23 | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2157 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dt.Columns.Add | ("p_time_zone") | 데이터 객체 조작/조회 |  |  |  |
| AC-b1241c2b | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2158 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dt.Columns.Add | ("p_first_row") | 데이터 객체 조작/조회 |  |  |  |
| AC-66102a3f | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2159 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dt.Columns.Add | ("p_last_row") | 데이터 객체 조작/조회 |  |  |  |
| AC-c3b79da7 | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2160 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | saveDS.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-cf8ac646 | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2165 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dtInput.Columns.Add | ("A") | 데이터 객체 조작/조회 |  |  |  |
| AC-8e44347c | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2166 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dtInput.Columns.Add | ("p_active_flag") | 데이터 객체 조작/조회 |  |  |  |
| AC-c796f6a7 | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2167 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dtInput.Columns.Add | ("p_division_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-5ed4e0fb | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2168 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dtInput.Columns.Add | ("p_plan_start_yyyymmdd") | 데이터 객체 조작/조회 |  |  |  |
| AC-add2455d | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2169 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dtInput.Columns.Add | ("p_plan_type") | 데이터 객체 조작/조회 |  |  |  |
| AC-bb3ed819 | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2170 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dtInput.Columns.Add | ("p_seq") | 데이터 객체 조작/조회 |  |  |  |
| AC-bc507828 | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2171 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dtInput.Columns.Add | ("p_biz_type") | 데이터 객체 조작/조회 |  |  |  |
| AC-6cd758d5 | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2172 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dtInput.Columns.Add | ("p_operation_group") | 데이터 객체 조작/조회 |  |  |  |
| AC-9cff409f | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2173 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dtInput.Columns.Add | ("p_item_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-524859f4 | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2174 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dtInput.Columns.Add | ("p_from_site") | 데이터 객체 조작/조회 |  |  |  |
| AC-8d24dd94 | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2175 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dtInput.Columns.Add | ("p_bod_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-0c1ddb33 | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2176 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dtInput.Columns.Add | ("p_measure") | 데이터 객체 조작/조회 |  |  |  |
| AC-a1340e2d | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2177 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dtInput.Columns.Add | ("p_yyyymmdd") | 데이터 객체 조작/조회 |  |  |  |
| AC-7e25348e | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2178 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dtInput.Columns.Add | ("p_to_site") | 데이터 객체 조작/조회 |  |  |  |
| AC-f1e687a4 | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2179 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dtInput.Columns.Add | ("p_qty") | 데이터 객체 조작/조회 |  |  |  |
| AC-d454d300 | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2180 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dtInput.Columns.Add | ("p_origin_from_division_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-7942fa06 | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2181 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dtInput.Columns.Add | ("p_origin_to_division_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-a64eef5f | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2182 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dtInput.Columns.Add | ("p_electrode_type") | 데이터 객체 조작/조회 |  |  |  |
| AC-8bdb7344 | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2183 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dtInput.Columns.Add | ("p_fix_reason") | 데이터 객체 조작/조회 |  |  |  |
| AC-af30c31d | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2184 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dtInput.Columns.Add | ("p_created_by") | 데이터 객체 조작/조회 |  |  |  |
| AC-16f179f3 | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2185 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dtInput.Columns.Add | ("p_last_updated_by") | 데이터 객체 조작/조회 |  |  |  |
| AC-14f644a9 | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2186 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dtInput.Columns.Add | ("p_time_zone") | 데이터 객체 조작/조회 |  |  |  |
| AC-1b3f21b2 | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2187 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dtInput.Columns.Add | ("debug_mode") | 데이터 객체 조작/조회 |  |  |  |
| AC-308754af | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2188 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dsInput.Tables.Add | (dtInput) | 데이터 객체 조작/조회 |  |  |  |
| AC-90a11fdc | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2222 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | saveDS.Tables[0].NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-4df81a46 | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2223 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["A"] | action | 행/컬럼 값 대입 |  |  |  |
| AC-54c6e952 | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2224 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_active_flag"] | action | 행/컬럼 값 대입 |  |  |  |
| AC-b559b836 | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2225 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_division_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.DIVISION_ID)) | 행/컬럼 값 대입 |  |  |  |
| AC-877f8fe7 | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2226 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-3601cc48 | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2227 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-f84adf45 | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2228 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-09149bc7 | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2229 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_operation_group"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.OPERATION_GROUP)) | 행/컬럼 값 대입 |  |  |  |
| AC-736d02a0 | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2230 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_item_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.ITEM_ID)) | 행/컬럼 값 대입 |  |  |  |
| AC-e1a6d1dc | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2231 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_from_site"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.FROM_SITE)) | 행/컬럼 값 대입 |  |  |  |
| AC-12b2c9c5 | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2232 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_bod_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.BOD_ID)) | 행/컬럼 값 대입 |  |  |  |
| AC-523797e9 | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2233 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_measure"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.MEASURE)) | 행/컬럼 값 대입 |  |  |  |
| AC-591ac002 | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2236 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_yyyymmdd"] | yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-2901e18c | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2237 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_to_site"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.TO_SITE)) | 행/컬럼 값 대입 |  |  |  |
| AC-02ae247b | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2238 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_qty"] | 0 | 행/컬럼 값 대입 |  |  |  |
| AC-88cf5950 | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2239 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_origin_from_division_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.ORIGIN_FROM_DIVISION_ID)) | 행/컬럼 값 대입 |  |  |  |
| AC-84c03ee4 | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2240 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_origin_to_division_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.ORIGIN_TO_DIVISION_ID)) | 행/컬럼 값 대입 |  |  |  |
| AC-cef4cebd | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2247 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_electrode_type"] | elec_type | 행/컬럼 값 대입 |  |  |  |
| AC-41faa6ae | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2249 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_created_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-17156182 | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2250 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_last_updated_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-91e3bd12 | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2251 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_time_zone"] | UserInfoContext.Current[UserInfoProperites.TimeZone] | 행/컬럼 값 대입 |  |  |  |
| AC-be02f40a | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2253 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | saveDS.Tables[0].Rows.Add | (dr) | 데이터 객체 조작/조회 |  |  |  |
| AC-76042fdd | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2257 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dsInput.Tables[0].NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-52023361 | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2258 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dRow["A"] | action | 행/컬럼 값 대입 |  |  |  |
| AC-fe3bbd3c | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2259 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dRow["p_active_flag"] | action | 행/컬럼 값 대입 |  |  |  |
| AC-23943ee2 | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2260 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dRow["p_division_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.DIVISION_ID)) | 행/컬럼 값 대입 |  |  |  |
| AC-ff2d88a6 | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2261 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dRow["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-c98e84a0 | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2262 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dRow["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-fa2b96d8 | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2263 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dRow["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-de22b519 | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2264 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dRow["p_operation_group"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.OPERATION_GROUP)) | 행/컬럼 값 대입 |  |  |  |
| AC-a864e956 | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2265 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dRow["p_biz_type"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.OPERATION_GROUP)) | 행/컬럼 값 대입 |  |  |  |
| AC-a9d4acc7 | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2266 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dRow["p_item_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.ITEM_ID)) | 행/컬럼 값 대입 |  |  |  |
| AC-e4147957 | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2267 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dRow["p_from_site"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.FROM_SITE)) | 행/컬럼 값 대입 |  |  |  |
| AC-f37e4280 | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2268 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dRow["p_bod_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.BOD_ID)) | 행/컬럼 값 대입 |  |  |  |
| AC-b57a23c5 | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2269 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dRow["p_measure"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.MEASURE)) | 행/컬럼 값 대입 |  |  |  |
| AC-5d1a780f | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2270 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dRow["p_yyyymmdd"] | yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-6b222176 | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2271 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dRow["p_to_site"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.TO_SITE)) | 행/컬럼 값 대입 |  |  |  |
| AC-885c9931 | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2272 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dRow["p_qty"] | 0 | 행/컬럼 값 대입 |  |  |  |
| AC-b850001a | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2273 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dRow["p_origin_from_division_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.ORIGIN_FROM_DIVISION_ID)) | 행/컬럼 값 대입 |  |  |  |
| AC-bd9a306e | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2274 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dRow["p_origin_to_division_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.ORIGIN_TO_DIVISION_ID)) | 행/컬럼 값 대입 |  |  |  |
| AC-37ff7bd3 | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2275 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dRow["p_electrode_type"] | elec_type | 행/컬럼 값 대입 |  |  |  |
| AC-e0a48a62 | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2276 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dRow["p_created_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-6591ab59 | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2277 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dRow["p_last_updated_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-325a433b | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2278 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dRow["p_time_zone"] | UserInfoContext.Current[UserInfoProperites.TimeZone] | 행/컬럼 값 대입 |  |  |  |
| AC-a314b31d | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2279 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dRow["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-5b8c9fba | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2280 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dsInput.Tables[0].Rows.Add | (dRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-3edeff18 | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2294 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | saveDS.Tables[0].NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-0fea47db | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2295 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["A"] | action | 행/컬럼 값 대입 |  |  |  |
| AC-fd39d00d | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2296 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_active_flag"] | action | 행/컬럼 값 대입 |  |  |  |
| AC-843dd851 | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2297 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_division_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.DIVISION_ID)) | 행/컬럼 값 대입 |  |  |  |
| AC-85364af4 | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2298 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-28f6d79b | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2299 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-775056b3 | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2300 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-388833f4 | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2301 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_operation_group"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.OPERATION_GROUP)) | 행/컬럼 값 대입 |  |  |  |
| AC-ca528694 | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2302 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_item_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.ITEM_ID)) | 행/컬럼 값 대입 |  |  |  |
| AC-dee54d87 | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2303 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_from_site"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.FROM_SITE)) | 행/컬럼 값 대입 |  |  |  |
| AC-c608db0a | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2304 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_bod_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.BOD_ID)) | 행/컬럼 값 대입 |  |  |  |
| AC-5f166c61 | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2305 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_measure"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.MEASURE)) | 행/컬럼 값 대입 |  |  |  |
| AC-019c8e94 | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2308 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_yyyymmdd"] | yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-9f10be83 | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2309 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_to_site"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.TO_SITE)) | 행/컬럼 값 대입 |  |  |  |
| AC-c2033d24 | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2310 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_qty"] | val | 행/컬럼 값 대입 |  |  |  |
| AC-b9eedd0b | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2311 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_origin_from_division_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.ORIGIN_FROM_DIVISION_ID)) | 행/컬럼 값 대입 |  |  |  |
| AC-1bb9f5ad | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2312 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_origin_to_division_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.ORIGIN_TO_DIVISION_ID)) | 행/컬럼 값 대입 |  |  |  |
| AC-a21eb9da | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2319 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_electrode_type"] | elec_type | 행/컬럼 값 대입 |  |  |  |
| AC-f2aec1f9 | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2321 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_created_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-5282f3a2 | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2322 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_last_updated_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-6a11bd38 | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2323 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_time_zone"] | UserInfoContext.Current[UserInfoProperites.TimeZone] | 행/컬럼 값 대입 |  |  |  |
| AC-b0172f87 | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2325 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | saveDS.Tables[0].Rows.Add | (dr) | 데이터 객체 조작/조회 |  |  |  |
| AC-7c99fde3 | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2330 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dsInput.Tables[0].NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-4f88415b | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2331 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dRow["A"] | action | 행/컬럼 값 대입 |  |  |  |
| AC-a5341e3d | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2332 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dRow["p_active_flag"] | action | 행/컬럼 값 대입 |  |  |  |
| AC-495d53f4 | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2333 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dRow["p_division_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.DIVISION_ID)) | 행/컬럼 값 대입 |  |  |  |
| AC-90a25d17 | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2334 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dRow["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-844661f8 | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2335 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dRow["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-a439030a | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2336 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dRow["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-ab6336b7 | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2337 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dRow["p_operation_group"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.OPERATION_GROUP)) | 행/컬럼 값 대입 |  |  |  |
| AC-9fff43b7 | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2338 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dRow["p_biz_type"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.OPERATION_GROUP)) | 행/컬럼 값 대입 |  |  |  |
| AC-d544fb56 | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2339 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dRow["p_item_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.ITEM_ID)) | 행/컬럼 값 대입 |  |  |  |
| AC-b823b12f | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2340 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dRow["p_from_site"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.FROM_SITE)) | 행/컬럼 값 대입 |  |  |  |
| AC-18637be6 | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2341 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dRow["p_bod_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.BOD_ID)) | 행/컬럼 값 대입 |  |  |  |
| AC-7d922f84 | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2342 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dRow["p_measure"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.MEASURE)) | 행/컬럼 값 대입 |  |  |  |
| AC-4ce101f9 | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2343 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dRow["p_yyyymmdd"] | yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-a94bd887 | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2344 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dRow["p_to_site"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.TO_SITE)) | 행/컬럼 값 대입 |  |  |  |
| AC-413d753d | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2345 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dRow["p_qty"] | val | 행/컬럼 값 대입 |  |  |  |
| AC-a4013eed | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2346 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dRow["p_origin_from_division_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.ORIGIN_FROM_DIVISION_ID)) | 행/컬럼 값 대입 |  |  |  |
| AC-f30370b5 | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2347 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dRow["p_origin_to_division_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.ORIGIN_TO_DIVISION_ID)) | 행/컬럼 값 대입 |  |  |  |
| AC-02823529 | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2348 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dRow["p_electrode_type"] | elec_type | 행/컬럼 값 대입 |  |  |  |
| AC-8d4cf8f8 | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2349 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dRow["p_created_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-81667653 | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2350 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dRow["p_last_updated_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-2fedc6bb | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2351 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dRow["p_time_zone"] | UserInfoContext.Current[UserInfoProperites.TimeZone] | 행/컬럼 값 대입 |  |  |  |
| AC-49609cf2 | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2352 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dRow["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-6db9c9b0 | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2353 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dsInput.Tables[0].Rows.Add | (dRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-76cc77f8 | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2372 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | saveDS.Tables[0].NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-56caf278 | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2373 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["A"] | action | 행/컬럼 값 대입 |  |  |  |
| AC-3bebc374 | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2374 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_active_flag"] | action | 행/컬럼 값 대입 |  |  |  |
| AC-6e25be43 | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2375 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_division_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.DIVISION_ID)) | 행/컬럼 값 대입 |  |  |  |
| AC-cfba0c0e | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2376 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-c0f066f4 | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2377 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-282f4ff3 | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2378 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-2fac6404 | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2379 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_operation_group"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.OPERATION_GROUP)) | 행/컬럼 값 대입 |  |  |  |
| AC-47e0a594 | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2380 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_item_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.ITEM_ID)) | 행/컬럼 값 대입 |  |  |  |
| AC-d17d38c3 | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2381 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_from_site"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.FROM_SITE)) | 행/컬럼 값 대입 |  |  |  |
| AC-a73789df | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2382 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_bod_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.BOD_ID)) | 행/컬럼 값 대입 |  |  |  |
| AC-b57fee5b | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2383 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_measure"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.MEASURE)) | 행/컬럼 값 대입 |  |  |  |
| AC-041c0d4b | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2386 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_yyyymmdd"] | yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-8f2b46bc | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2387 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_to_site"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.TO_SITE)) | 행/컬럼 값 대입 |  |  |  |
| AC-46f98d49 | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2388 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_qty"] | strQty | 행/컬럼 값 대입 |  |  |  |
| AC-1e0b6cf8 | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2389 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_origin_from_division_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.ORIGIN_FROM_DIVISION_ID)) | 행/컬럼 값 대입 |  |  |  |
| AC-894c9a7a | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2390 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_origin_to_division_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.ORIGIN_TO_DIVISION_ID)) | 행/컬럼 값 대입 |  |  |  |
| AC-06c1f680 | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2398 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_electrode_type"] | elec_type | 행/컬럼 값 대입 |  |  |  |
| AC-66a82b29 | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2400 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_created_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-fd4d00fb | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2401 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_last_updated_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-bd287edc | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2402 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_time_zone"] | UserInfoContext.Current[UserInfoProperites.TimeZone] | 행/컬럼 값 대입 |  |  |  |
| AC-fedc43fb | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2404 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | saveDS.Tables[0].Rows.Add | (dr) | 데이터 객체 조작/조회 |  |  |  |
| AC-275a0aa3 | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2409 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dsInput.Tables[0].NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-1fefece5 | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2410 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dRow["A"] | action | 행/컬럼 값 대입 |  |  |  |
| AC-f04dfd2e | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2411 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dRow["p_active_flag"] | action | 행/컬럼 값 대입 |  |  |  |
| AC-95626f57 | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2412 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dRow["p_division_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.DIVISION_ID)) | 행/컬럼 값 대입 |  |  |  |
| AC-6e5f6ddf | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2413 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dRow["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-e152a251 | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2414 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dRow["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-12c0fd6f | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2415 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dRow["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-754401cf | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2416 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dRow["p_operation_group"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.OPERATION_GROUP)) | 행/컬럼 값 대입 |  |  |  |
| AC-cfcc60e5 | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2417 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dRow["p_biz_type"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.OPERATION_GROUP)) | 행/컬럼 값 대입 |  |  |  |
| AC-2843c402 | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2418 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dRow["p_item_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.ITEM_ID)) | 행/컬럼 값 대입 |  |  |  |
| AC-faeec474 | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2419 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dRow["p_from_site"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.FROM_SITE)) | 행/컬럼 값 대입 |  |  |  |
| AC-977a6efe | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2420 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dRow["p_bod_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.BOD_ID)) | 행/컬럼 값 대입 |  |  |  |
| AC-545fa566 | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2421 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dRow["p_measure"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.MEASURE)) | 행/컬럼 값 대입 |  |  |  |
| AC-a569f489 | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2422 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dRow["p_yyyymmdd"] | yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-3761a52e | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2423 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dRow["p_to_site"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.TO_SITE)) | 행/컬럼 값 대입 |  |  |  |
| AC-73439ab8 | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2424 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dRow["p_qty"] | strQty | 행/컬럼 값 대입 |  |  |  |
| AC-3ac39bf7 | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2425 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dRow["p_origin_from_division_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.ORIGIN_FROM_DIVISION_ID)) | 행/컬럼 값 대입 |  |  |  |
| AC-d5767228 | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2426 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dRow["p_origin_to_division_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.ORIGIN_TO_DIVISION_ID)) | 행/컬럼 값 대입 |  |  |  |
| AC-e40cafa5 | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2427 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dRow["p_electrode_type"] | elec_type | 행/컬럼 값 대입 |  |  |  |
| AC-c8ac07c8 | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2428 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dRow["p_created_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-ad1059b7 | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2429 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dRow["p_last_updated_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-babb304b | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2430 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dRow["p_time_zone"] | UserInfoContext.Current[UserInfoProperites.TimeZone] | 행/컬럼 값 대입 |  |  |  |
| AC-d3b5cee4 | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2431 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dRow["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-07773644 | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2432 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dsInput.Tables[0].Rows.Add | (dRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-312a3268 | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2438 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | GRID_SET | saveDS.Tables[0].Rows[0]["p_first_row"] | "Y" | 그리드 속성/값 설정 |  |  |  |
| AC-74cf7203 | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2439 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | GRID_SET | saveDS.Tables[0].Rows[iCount - 1]["p_last_row"] | "Y" | 그리드 속성/값 설정 |  |  |  |
| AC-4f8e474e | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2441 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | saveDS.Tables[0].AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-3e593cb0 | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2446 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (iCount > 0) | DATA_OP | dsInput.Tables[0].AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-f4a94338 | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2460 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (iCount > 0) ▸ try | CALL_EXT | sql.AddParameter | (SqlDbType.Structured, "@SCP0010", dsInput.Tables[0]) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e08405e3 | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2461 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (iCount > 0) ▸ try | ENDPOINT | sql.ExcuteProcedure | ("dbo.SCP0010_SAVE_ANL_SHIPMENT_PLAN_SEMI_DATASET") ⇒ biz:AppService.GeneralRunProcedureCustomTable [procedure=dbo.SCP0010_SAVE_ANL_SH… | 엔드포인트 호출 |  |  |  |
| AC-bcf13308 | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2464 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (iCount > 0) ▸ try | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-d73dac25 | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2469 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (iCount > 0) ▸ try ▸ if (result !… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { result.Rows[0]["result_cnt"].ToString() }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-fac6c96c | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2478 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (iCount > 0) ▸ try ▸ else of (res… | MESSAGE | MessageHelper.GMessageBox | ("MSG00003", new object[] { ReErrorMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-2573a7fd | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2487 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (iCount > 0) ▸ catch ((Exception … | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-bb899954 | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2488 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (iCount > 0) ▸ catch ((Exception … | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-466bd2f0 | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2494 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (iCount > 0) ▸ finally ▸ if (!prg… | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-809c0492 | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2542 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-a7dc6436 | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2544 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-5bb762b0 | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2548 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-847978b2 | SaveButton | SCP0059_Shipment_Plan_SEMI_JV.cs:2549 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## SCP0059_Shipment_Plan_SEMI_JV.SCM_SYS_LOG_BATCH

진입점: this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName)) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try] / this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName)) ▸ if (MessageHelper.GMessageBox("MSG00016") == DialogResult.Yes) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try] / SaveButton [if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (iCount > 0) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-003dc95c | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 2 | SCP0059_Shipment_Plan_SEMI_JV.cs:4241 | try | ENDPOINT | new FoxDataRequest | ("SCP.PR_SCM_SYS_LOG_BATCH") ⇒ SCP.PR_SCM_SYS_LOG_BATCH | 엔드포인트 요청 생성 |  |  |  |
| AC-40f45448 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 2 | SCP0059_Shipment_Plan_SEMI_JV.cs:4242 | try | DATA_OP | request.Parameters["p_program_name"] | p_program_name | 행/컬럼 값 대입 |  |  |  |
| AC-19171eb7 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 2 | SCP0059_Shipment_Plan_SEMI_JV.cs:4243 | try | DATA_OP | request.Parameters["p_log_type"] | p_log_type | 행/컬럼 값 대입 |  |  |  |
| AC-b6ee1845 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 2 | SCP0059_Shipment_Plan_SEMI_JV.cs:4244 | try | DATA_OP | request.Parameters["p_log_count"] | p_log_count | 행/컬럼 값 대입 |  |  |  |
| AC-45e0f1f8 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 2 | SCP0059_Shipment_Plan_SEMI_JV.cs:4245 | try | DATA_OP | request.Parameters["p_log_message"] | p_log_message | 행/컬럼 값 대입 |  |  |  |
| AC-21a24758 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 2 | SCP0059_Shipment_Plan_SEMI_JV.cs:4246 | try | DATA_OP | request.Parameters["p_description"] | p_description | 행/컬럼 값 대입 |  |  |  |
| AC-bdf1a734 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 2 | SCP0059_Shipment_Plan_SEMI_JV.cs:4247 | try | DATA_OP | request.Parameters["p_event_date"] | DateTime.Now | 행/컬럼 값 대입 |  |  |  |
| AC-b1d61885 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 2 | SCP0059_Shipment_Plan_SEMI_JV.cs:4249 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## SCP0059_Shipment_Plan_SEMI_JV.Set_FixButtonEnabled

진입점: this.Load / cboPlanDate.SelectedIndexChanged / cboPlanType.SelectedIndexChanged / cboPlanSeq.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-18096ab3 | this.Load 외 3 | SCP0059_Shipment_Plan_SEMI_JV.cs:2766 | if (sPlanType.Equals("FN") \|\| sPlanType.Equals("TE")) | STATE | btnFix.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-da9dd1c0 | this.Load 외 3 | SCP0059_Shipment_Plan_SEMI_JV.cs:2767 | if (sPlanType.Equals("FN") \|\| sPlanType.Equals("TE")) | STATE | btnUnfix.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-eaf09955 | this.Load 외 3 | SCP0059_Shipment_Plan_SEMI_JV.cs:2768 | if (sPlanType.Equals("FN") \|\| sPlanType.Equals("TE")) | STATE | btnNew.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-26c401cb | this.Load 외 3 | SCP0059_Shipment_Plan_SEMI_JV.cs:2775 | else of (sPlanType.Equals("FN") \|\| sPlanType.Equals("TE")) ▸ if (!string.IsNullOrEmpty(CString.GetCheckedListValue(dtPlanSeq, cboPlanSeq.C… | DATA_OP | dtPlanSeq.AsEnumerable().Select | (a => a.Field<int>("CODE")) | 데이터 객체 조작/조회 |  |  |  |
| AC-b4956ce0 | this.Load 외 3 | SCP0059_Shipment_Plan_SEMI_JV.cs:2775 | else of (sPlanType.Equals("FN") \|\| sPlanType.Equals("TE")) ▸ if (!string.IsNullOrEmpty(CString.GetCheckedListValue(dtPlanSeq, cboPlanSeq.C… | DATA_OP | a.Field | ("CODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-546df8b0 | this.Load 외 3 | SCP0059_Shipment_Plan_SEMI_JV.cs:2779 | else of (sPlanType.Equals("FN") \|\| sPlanType.Equals("TE")) ▸ if (!string.IsNullOrEmpty(CString.GetCheckedListValue(dtPlanSeq, cboPlanSeq.C… | STATE | btnFix.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-58c9fc67 | this.Load 외 3 | SCP0059_Shipment_Plan_SEMI_JV.cs:2780 | else of (sPlanType.Equals("FN") \|\| sPlanType.Equals("TE")) ▸ if (!string.IsNullOrEmpty(CString.GetCheckedListValue(dtPlanSeq, cboPlanSeq.C… | STATE | btnUnfix.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-95dfe638 | this.Load 외 3 | SCP0059_Shipment_Plan_SEMI_JV.cs:2781 | else of (sPlanType.Equals("FN") \|\| sPlanType.Equals("TE")) ▸ if (!string.IsNullOrEmpty(CString.GetCheckedListValue(dtPlanSeq, cboPlanSeq.C… | STATE | btnNew.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-8cee8917 | this.Load 외 3 | SCP0059_Shipment_Plan_SEMI_JV.cs:2785 | else of (sPlanType.Equals("FN") \|\| sPlanType.Equals("TE")) ▸ if (!string.IsNullOrEmpty(CString.GetCheckedListValue(dtPlanSeq, cboPlanSeq.C… | STATE | btnFix.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-8920dfe3 | this.Load 외 3 | SCP0059_Shipment_Plan_SEMI_JV.cs:2786 | else of (sPlanType.Equals("FN") \|\| sPlanType.Equals("TE")) ▸ if (!string.IsNullOrEmpty(CString.GetCheckedListValue(dtPlanSeq, cboPlanSeq.C… | STATE | btnUnfix.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-59d0c8f9 | this.Load 외 3 | SCP0059_Shipment_Plan_SEMI_JV.cs:2787 | else of (sPlanType.Equals("FN") \|\| sPlanType.Equals("TE")) ▸ if (!string.IsNullOrEmpty(CString.GetCheckedListValue(dtPlanSeq, cboPlanSeq.C… | STATE | btnNew.Enabled | false | 컨트롤 상태 Enabled |  |  |  |

## SCP0059_Shipment_Plan_SEMI_JV.Set_FixCellColor

진입점: this.spdMain.CellClick [if ((e.Column == siMain.GetColumnIndex(DefMain.TRANSPORT_MODE) \|\| e.Column == siMain.GetColumnIndex(DefMain.TO_SITE_DESCRIPT…)] / this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName)) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Equals("S")) ▸ try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ if (dsBinding.Tables[2].Rows.Count > 0)] / this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName)) ▸ if …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-81c65d87 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… 외 6 | SCP0059_Shipment_Plan_SEMI_JV.cs:1065 |  | FLAG | dtFix | dsBinding.Tables[2] | 화면 필드/플래그 변경 |  |  |  |
| AC-beb739b4 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… 외 6 | SCP0059_Shipment_Plan_SEMI_JV.cs:1079 | for (nRow < siMain.ActiveSheet.Rows.Count) ▸ if (measure.Equals("SHIP_PLAN_AMEND")) | DATA_OP | dtFix.Select | ("key_idx='" + sKey_Idx + "' AND TO_SITE='" + sTo_Site + "' AND bod_id='" + sBod_Id + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-a2cd0693 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… 외 6 | SCP0059_Shipment_Plan_SEMI_JV.cs:1087 | for (nRow < siMain.ActiveSheet.Rows.Count) ▸ if (measure.Equals("SHIP_PLAN_AMEND")) ▸ if (res.Count() > 0) ▸ foreach (DataRow dr in res) | GRID_STYLE | siMain.SetBGColor2 | (nRow, siMain.GetColumnIndex(sDay), nRow, siMain.GetColumnIndex(sDay), Color.FromArgb(188,… | 그리드 표시 설정 |  |  |  |
| AC-73dee35d | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… 외 6 | SCP0059_Shipment_Plan_SEMI_JV.cs:1096 | for (nRow < siMain.ActiveSheet.Rows.Count) ▸ if (measure.Equals("SHIP_PLAN_AMEND")) ▸ if (res.Count() > 0) ▸ foreach (DataRow dr in res) ▸ f… | GRID_STYLE | siMain.SetBGColor2 | (nRow, iCol, nRow, iCol, Color.FromArgb(188, 229, 92)) | 그리드 표시 설정 |  |  |  |

## SCP0059_Shipment_Plan_SEMI_JV.Set_FPOperationColor

진입점: this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName)) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Equals("S")) ▸ try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] / this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName)) ▸ if (MessageHelper.GMessageBox("MSG00016") == DialogResult.Yes) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (result != nul…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-74e54d98 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 5 | SCP0059_Shipment_Plan_SEMI_JV.cs:1050 | for (nRow < siMain.ActiveSheet.Rows.Count) ▸ if (siMain.ActiveSheet.GetText(nRow, siMain.GetColumnIndex(DefMain.MEASURE)).ToString() == "SHI… | GRID_STYLE | siMain.SetBGColor | (nRow, befCol, nRow, nCol - 1, Color.FromArgb(234, 234, 234)) | 그리드 표시 설정 |  |  |  |
| AC-ce7e678c | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 5 | SCP0059_Shipment_Plan_SEMI_JV.cs:1056 | for (nRow < siMain.ActiveSheet.Rows.Count) ▸ if (siMain.ActiveSheet.GetText(nRow, siMain.GetColumnIndex(DefMain.MEASURE)).ToString() == "SHI… | GRID_STYLE | siMain.SetBGColor | (nRow, befCol, nRow, nCol, Color.FromArgb(234, 234, 234)) | 그리드 표시 설정 |  |  |  |

## SCP0059_Shipment_Plan_SEMI_JV.Set_InsertColumnsFont

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6ca1c099 | (진입점 미연결) | SCP0059_Shipment_Plan_SEMI_JV.cs:3085 | if (bBold) | UI_PROP | range1.Font | new System.Drawing.Font(spdMain.Font.Name, spdMain.Font.Size, FontStyle.Bold) | 속성 Font 설정 |  |  |  |
| AC-812423b6 | (진입점 미연결) | SCP0059_Shipment_Plan_SEMI_JV.cs:3089 | else of (bBold) | UI_PROP | range1.Font | new System.Drawing.Font(spdMain.Font.Name, spdMain.Font.Size, FontStyle.Regular) | 속성 Font 설정 |  |  |  |

## SCP0059_Shipment_Plan_SEMI_JV.Set_SumValues

진입점: this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName)) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Equals("S")) ▸ try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] / this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName)) ▸ if (MessageHelper.GMessageBox("MSG00016") == DialogResult.Yes) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (result != nul…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1eb542f3 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 4 | SCP0059_Shipment_Plan_SEMI_JV.cs:1188 | for (iRow < dsBinding.Tables[0].Rows.Count) ▸ for (iCol < dsBinding.Tables[0].Columns.Count) ▸ if (colName.IndexOf("M_") == 0) ▸ if (bef_mon… | GRID_SET | dsBinding.Tables[0].Rows[iRow][bef_month_idx] | dsBinding.Tables[0].Rows[iRow][bef_day_idx] | 그리드 속성/값 설정 |  |  |  |
| AC-d3e435ac | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 4 | SCP0059_Shipment_Plan_SEMI_JV.cs:1209 | for (iRow < dsBinding.Tables[0].Rows.Count) ▸ for (iCol < dsBinding.Tables[0].Columns.Count) ▸ else of (colName.IndexOf("M_") == 0) ▸ if (co… | GRID_SET | dsBinding.Tables[0].Rows[iRow][bef_week_idx] | dsBinding.Tables[0].Rows[iRow][bef_day_idx] | 그리드 속성/값 설정 |  |  |  |
| AC-c0a4ede4 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 4 | SCP0059_Shipment_Plan_SEMI_JV.cs:1240 | for (iRow < dsBinding.Tables[0].Rows.Count) ▸ for (iCol < dsBinding.Tables[0].Columns.Count) ▸ else of (colName.IndexOf("M_") == 0) ▸ else o… | GRID_SET | dsBinding.Tables[0].Rows[iRow][bef_week_idx] | dsBinding.Tables[0].Rows[iRow][bef_day_idx] | 그리드 속성/값 설정 |  |  |  |
| AC-ecb71ebf | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 4 | SCP0059_Shipment_Plan_SEMI_JV.cs:1241 | for (iRow < dsBinding.Tables[0].Rows.Count) ▸ for (iCol < dsBinding.Tables[0].Columns.Count) ▸ else of (colName.IndexOf("M_") == 0) ▸ else o… | GRID_SET | dsBinding.Tables[0].Rows[iRow][bef_month_idx] | dsBinding.Tables[0].Rows[iRow][bef_day_idx] | 그리드 속성/값 설정 |  |  |  |

## SCP0059_Shipment_Plan_SEMI_JV.SetChangedControl

진입점: this.Load / cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1274ab46 | this.Load 외 1 | SCP0059_Shipment_Plan_SEMI_JV.cs:647 |  | FLAG | dtFromSite | Data_SCP.Common(Data_SCP.Type.AllPlantSiteDescription, false, "", "") | 화면 필드/플래그 변경 |  |  |  |
| AC-175d96da | this.Load 외 1 | SCP0059_Shipment_Plan_SEMI_JV.cs:647 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.AllPlantSiteDescription, false, "", "") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-4330ec4a | this.Load 외 1 | SCP0059_Shipment_Plan_SEMI_JV.cs:660 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | FLAG | dtOperGrp | Data.Common(Data.Type.LookupCommon, false, operation_option) ⇒ biz:CommonData.CommonDataList [code=LookupCommon] | 화면 필드/플래그 변경 |  |  |  |
| AC-58ec7771 | this.Load 외 1 | SCP0059_Shipment_Plan_SEMI_JV.cs:660 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | COMBO_DATA | Data.Common | (Data.Type.LookupCommon, false, operation_option) ⇒ biz:CommonData.CommonDataList [code=LookupCommon] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-1cc3dacd | this.Load 외 1 | SCP0059_Shipment_Plan_SEMI_JV.cs:661 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | LIST_REBIND | clsCtrl.setListBox | (dtOperGrp, cboOperGroup, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-746808f4 | this.Load 외 1 | SCP0059_Shipment_Plan_SEMI_JV.cs:664 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ if (!division.Substring(0, 2).Equals("EE")) | FLAG | dtToSite | Data_SCP.Common(Data_SCP.Type.ShipmentPlanSEMIToStie, false, division, sOperationGroup) | 화면 필드/플래그 변경 |  |  |  |
| AC-fb0d996f | this.Load 외 1 | SCP0059_Shipment_Plan_SEMI_JV.cs:664 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ if (!division.Substring(0, 2).Equals("EE")) | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.ShipmentPlanSEMIToStie, false, division, sOperationGroup) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-4038b200 | this.Load 외 1 | SCP0059_Shipment_Plan_SEMI_JV.cs:665 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ else of (!division.Substring(0, 2).Equals("EE")) | FLAG | dtToSite | Data_SCP.Common(Data_SCP.Type.ToSiteShipmentPlanSEMI, false, division, sOperationGroup) | 화면 필드/플래그 변경 |  |  |  |
| AC-b64a1060 | this.Load 외 1 | SCP0059_Shipment_Plan_SEMI_JV.cs:665 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ else of (!division.Substring(0, 2).Equals("EE")) | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.ToSiteShipmentPlanSEMI, false, division, sOperationGroup) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-43678a34 | this.Load 외 1 | SCP0059_Shipment_Plan_SEMI_JV.cs:667 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | DATA_OP | dtFromSite.Select() .Where(c => c[DefMain.OPERATION_GROUP].ToString() == sOperationGroup.T… | () | 데이터 객체 조작/조회 |  |  |  |
| AC-2cd44ab1 | this.Load 외 1 | SCP0059_Shipment_Plan_SEMI_JV.cs:667 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | DATA_OP | dtFromSite.Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-696b3333 | this.Load 외 1 | SCP0059_Shipment_Plan_SEMI_JV.cs:674 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | CALL_EXT | dic_JV_Plant.TryGetValue | (division, out get_JV_Value) | ⚠ 의미 확인 필요 |  |  |  |
| AC-955a9db3 | this.Load 외 1 | SCP0059_Shipment_Plan_SEMI_JV.cs:680 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ for (i < splt_get_JV_Value.Count()) | DATA_OP | plantList.Add | (splt_get_JV_Value[i] + "-" + sOperationGroup) | 데이터 객체 조작/조회 |  |  |  |
| AC-1ac88842 | this.Load 외 1 | SCP0059_Shipment_Plan_SEMI_JV.cs:681 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ for (i < splt_get_JV_Value.Count()) | DATA_OP | plantList.Add | (splt_get_JV_Value[i] + "_" + division + "-" + sOperationGroup) | 데이터 객체 조작/조회 |  |  |  |
| AC-45421693 | this.Load 외 1 | SCP0059_Shipment_Plan_SEMI_JV.cs:684 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | DATA_OP | dtFromSiteCpyTmp.Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-3a4d6f7e | this.Load 외 1 | SCP0059_Shipment_Plan_SEMI_JV.cs:684 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ lambda | DATA_OP | plantList.Contains | (c["CODE"].ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-6bd7543c | this.Load 외 1 | SCP0059_Shipment_Plan_SEMI_JV.cs:685 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | DATA_OP | dtFromSiteCpyTmp.Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-75161ad9 | this.Load 외 1 | SCP0059_Shipment_Plan_SEMI_JV.cs:689 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ for (i < dataTmp.ToList().Count) | DATA_OP | dtFromSiteCpy.ImportRow | (dr) | 데이터 객체 조작/조회 |  |  |  |
| AC-eb392a4e | this.Load 외 1 | SCP0059_Shipment_Plan_SEMI_JV.cs:692 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | FLAG | dtFromSiteJV | null | 화면 필드/플래그 변경 |  |  |  |
| AC-b30661e1 | this.Load 외 1 | SCP0059_Shipment_Plan_SEMI_JV.cs:693 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | FLAG | dtFromSiteJV | dtFromSiteCpy.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-e75a6651 | this.Load 외 1 | SCP0059_Shipment_Plan_SEMI_JV.cs:693 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | DATA_OP | dtFromSiteCpy.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-a9b2a4ba | this.Load 외 1 | SCP0059_Shipment_Plan_SEMI_JV.cs:695 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ if (dataTmp.ToList().Count > 0) | UI_PROP | clbFromSite.ALL_VIEW | true | 속성 ALL_VIEW 설정 |  |  |  |
| AC-6bbf37a3 | this.Load 외 1 | SCP0059_Shipment_Plan_SEMI_JV.cs:696 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ else of (dataTmp.ToList().Count > 0) | UI_PROP | clbFromSite.ALL_VIEW | false | 속성 ALL_VIEW 설정 |  |  |  |
| AC-2df09c6c | this.Load 외 1 | SCP0059_Shipment_Plan_SEMI_JV.cs:699 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | LIST_REBIND | clsCtrl.setListBox | (dtFromSiteCpy, clbFromSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-f09db388 | this.Load 외 1 | SCP0059_Shipment_Plan_SEMI_JV.cs:700 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | LIST_REBIND | clsCtrl.setListBox | (dtToSite, clbToSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-2143bcdb | this.Load 외 1 | SCP0059_Shipment_Plan_SEMI_JV.cs:703 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | FLAG | dtPlanDate | Data.Common(Data.Type.PlanDate, false, division) ⇒ biz:CommonData.CommonDataList [code=PlanDate] | 화면 필드/플래그 변경 |  |  |  |
| AC-578e15bd | this.Load 외 1 | SCP0059_Shipment_Plan_SEMI_JV.cs:703 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | COMBO_DATA | Data.Common | (Data.Type.PlanDate, false, division) ⇒ biz:CommonData.CommonDataList [code=PlanDate] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-a82844fe | this.Load 외 1 | SCP0059_Shipment_Plan_SEMI_JV.cs:704 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | LIST_REBIND | clsCtrl.setListBox | (dtPlanDate, cboPlanDate, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-c4893bbd | this.Load 외 1 | SCP0059_Shipment_Plan_SEMI_JV.cs:707 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | FLAG | dtPlanType | Data.Common(Data.Type.PlanType, false, division, pPlanDate) ⇒ biz:CommonData.CommonDataList [code=PlanType] | 화면 필드/플래그 변경 |  |  |  |
| AC-4c065a77 | this.Load 외 1 | SCP0059_Shipment_Plan_SEMI_JV.cs:707 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | COMBO_DATA | Data.Common | (Data.Type.PlanType, false, division, pPlanDate) ⇒ biz:CommonData.CommonDataList [code=PlanType] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-33e75448 | this.Load 외 1 | SCP0059_Shipment_Plan_SEMI_JV.cs:708 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | LIST_REBIND | clsCtrl.setListBox | (dtPlanType, cboPlanType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-a6796054 | this.Load 외 1 | SCP0059_Shipment_Plan_SEMI_JV.cs:711 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ if (dtPlanType.Rows.Count > 0) | VALUE_SET | cboPlanType.SelectedIndex | dtPlanType.Rows.Count - 1 | 컨트롤 값 설정 |  |  |  |
| AC-4b5379c3 | this.Load 외 1 | SCP0059_Shipment_Plan_SEMI_JV.cs:714 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | FLAG | dtPlanSeq | Data.Common(Data.Type.PlanSeq, false, division, pPlanDate, pPlanType) ⇒ biz:CommonData.CommonDataList [code=PlanSeq] | 화면 필드/플래그 변경 |  |  |  |
| AC-959d2963 | this.Load 외 1 | SCP0059_Shipment_Plan_SEMI_JV.cs:714 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | COMBO_DATA | Data.Common | (Data.Type.PlanSeq, false, division, pPlanDate, pPlanType) ⇒ biz:CommonData.CommonDataList [code=PlanSeq] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-266b4330 | this.Load 외 1 | SCP0059_Shipment_Plan_SEMI_JV.cs:715 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | LIST_REBIND | clsCtrl.setListBox | (dtPlanSeq, cboPlanSeq, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-bfe6d46e | this.Load 외 1 | SCP0059_Shipment_Plan_SEMI_JV.cs:719 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ if (!division.Substring(0, 2).Equals("EE")) | VALUE_CLEAR | clbElecType.ControlValues | "" | 컨트롤 값 비움 |  |  |  |
| AC-d06607e0 | this.Load 외 1 | SCP0059_Shipment_Plan_SEMI_JV.cs:720 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ if (!division.Substring(0, 2).Equals("EE")) | STATE | clbElecType.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-8066502f | this.Load 외 1 | SCP0059_Shipment_Plan_SEMI_JV.cs:724 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ else of (!division.Substring(0, 2).Equals("EE")) | STATE | clbElecType.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## SCP0059_Shipment_Plan_SEMI_JV.SetChangedPeriod

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4f261ac6 | (진입점 미연결) | SCP0059_Shipment_Plan_SEMI_JV.cs:3830 | if (string.IsNullOrEmpty(strcboPlanDate)) | COMBO_DATA | Data.CallBizCommonData | ("PERIOD_" + value) ⇒ biz:CommonData.CommonDataList [code=PERIOD_{p:value}] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-85009ba0 | (진입점 미연결) | SCP0059_Shipment_Plan_SEMI_JV.cs:3834 | else of (string.IsNullOrEmpty(strcboPlanDate)) | COMBO_DATA | Data.CallBizCommonData | ("PERIOD2_" + value, strcboPlanDate) ⇒ biz:CommonData.CommonDataList [code=PERIOD2_{p:value}] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-dfaea164 | (진입점 미연결) | SCP0059_Shipment_Plan_SEMI_JV.cs:3837 | if (dt == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-bcddbca5 | (진입점 미연결) | SCP0059_Shipment_Plan_SEMI_JV.cs:3841 | if (dt.Rows.Count > 0) | UI_PROP | drpPeriod.Text1 | dt.Rows[0]["FROM_VALUE"].ToString() | 속성 Text1 설정 |  |  |  |
| AC-be2b9c5b | (진입점 미연결) | SCP0059_Shipment_Plan_SEMI_JV.cs:3842 | if (dt.Rows.Count > 0) | UI_PROP | drpPeriod.Text2 | dt.Rows[0]["TO_VALUE"].ToString() | 속성 Text2 설정 |  |  |  |

## SCP0059_Shipment_Plan_SEMI_JV.SetFromSite

진입점: cboOperGroup.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a3b72f5f | cboOperGroup.SelectedIndexChanged | SCP0059_Shipment_Plan_SEMI_JV.cs:4222 | if (!division.Substring(0, 2).Equals("EE")) | DATA_OP | dtFromSite.Select() .Where(c => c[DefMain.OPERATION_GROUP].ToString() == sOperationGroup.T… | () | 데이터 객체 조작/조회 |  |  |  |
| AC-749ea679 | cboOperGroup.SelectedIndexChanged | SCP0059_Shipment_Plan_SEMI_JV.cs:4222 | if (!division.Substring(0, 2).Equals("EE")) | DATA_OP | dtFromSite.Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-9c53d099 | cboOperGroup.SelectedIndexChanged | SCP0059_Shipment_Plan_SEMI_JV.cs:4227 | else of (!division.Substring(0, 2).Equals("EE")) | DATA_OP | dtFromSite.Select() .Where(c => c[DefMain.OPERATION_GROUP].ToString() == sOperationGroup.T… | () | 데이터 객체 조작/조회 |  |  |  |
| AC-9393fcb5 | cboOperGroup.SelectedIndexChanged | SCP0059_Shipment_Plan_SEMI_JV.cs:4227 | else of (!division.Substring(0, 2).Equals("EE")) | DATA_OP | dtFromSite.Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-d1d52e67 | cboOperGroup.SelectedIndexChanged | SCP0059_Shipment_Plan_SEMI_JV.cs:4231 |  | LIST_REBIND | clsCtrl.setListBox | (dtFromSiteCpy, clbFromSite, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0059_Shipment_Plan_SEMI_JV.SetSpreadColumn

진입점: this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK)] / this.Load / this.chkSum.CheckedChanged [if (siMain != null)] / this.cboBucketType.SelectedIndexChanged [if (siMain != null)] / this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName)) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Equals("S")) ▸ try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] / this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName)) ▸ if (Mes…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-06fe6dc3 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 9 | SCP0059_Shipment_Plan_SEMI_JV.cs:605 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Daily) ▸ if (siObj.GetColumnTag(iCol).IndexOf("D_") … | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-013e04e7 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 9 | SCP0059_Shipment_Plan_SEMI_JV.cs:610 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Daily) ▸ if (siObj.GetColumnTag(iCol).IndexOf("M_") … | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | chkSum.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-9a8c5531 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 9 | SCP0059_Shipment_Plan_SEMI_JV.cs:617 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Buc… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-464462f9 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 9 | SCP0059_Shipment_Plan_SEMI_JV.cs:621 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Buc… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-7a11f448 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 9 | SCP0059_Shipment_Plan_SEMI_JV.cs:626 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Buc… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | chkSum.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-270e4d56 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 9 | SCP0059_Shipment_Plan_SEMI_JV.cs:633 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ else of (cboBucketType.ControlValues =… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-a03441d6 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 9 | SCP0059_Shipment_Plan_SEMI_JV.cs:637 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ else of (cboBucketType.ControlValues =… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |

## SCP0059_Shipment_Plan_SEMI_JV.SetTableInfo

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-16f2ba6c | (진입점 미연결) | SCP0059_Shipment_Plan_SEMI_JV.cs:1743 | for (i <= target_idx) ▸ if (i <= target_idx) | DATA_OP | dt.Columns.Add | (dtQty.Columns[i].ColumnName) | 데이터 객체 조작/조회 |  |  |  |
| AC-959a4155 | (진입점 미연결) | SCP0059_Shipment_Plan_SEMI_JV.cs:1750 | for (i < dtHeader.Rows.Count) | DATA_OP | dt.Columns.Add | (dtHeader.Rows[i][0].ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-40744458 | (진입점 미연결) | SCP0059_Shipment_Plan_SEMI_JV.cs:1753 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SCP0059_Shipment_Plan_SEMI_JV.SetToSite

진입점: cboOperGroup.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cd42417d | cboOperGroup.SelectedIndexChanged | SCP0059_Shipment_Plan_SEMI_JV.cs:4204 | if (!division.Substring(0, 2).Equals("EE")) | FLAG | dtToSite | Data_SCP.Common(Data_SCP.Type.ShipmentPlanSEMIToStie, false, division, sOperationGroup) | 화면 필드/플래그 변경 |  |  |  |
| AC-bc0844d3 | cboOperGroup.SelectedIndexChanged | SCP0059_Shipment_Plan_SEMI_JV.cs:4204 | if (!division.Substring(0, 2).Equals("EE")) | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.ShipmentPlanSEMIToStie, false, division, sOperationGroup) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-189e928e | cboOperGroup.SelectedIndexChanged | SCP0059_Shipment_Plan_SEMI_JV.cs:4208 | else of (!division.Substring(0, 2).Equals("EE")) | FLAG | dtToSite | Data_SCP.Common(Data_SCP.Type.ToSiteShipmentPlanSEMI, false, division, sOperationGroup) | 화면 필드/플래그 변경 |  |  |  |
| AC-6bf01d66 | cboOperGroup.SelectedIndexChanged | SCP0059_Shipment_Plan_SEMI_JV.cs:4208 | else of (!division.Substring(0, 2).Equals("EE")) | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.ToSiteShipmentPlanSEMI, false, division, sOperationGroup) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-44f1cc99 | cboOperGroup.SelectedIndexChanged | SCP0059_Shipment_Plan_SEMI_JV.cs:4211 |  | LIST_REBIND | clsCtrl.setListBox | (dtToSite, clbToSite, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0059_Shipment_Plan_SEMI_JV.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-eea89464 | this.spdMain.CellClick | SCP0059_Shipment_Plan_SEMI_JV.cs:3920 | if (e.ColumnHeader \|\| siMain.IsLock(siMain.SheetName)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0059_Shipment_Plan_SEMI_JV.SpdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-39f97978 | this.spdMain.CellDoubleClick | SCP0059_Shipment_Plan_SEMI_JV.cs:3725 |  | CALL_EXT | siMain.SetDblClickColumnShowHide | (sender, e) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0059_Shipment_Plan_SEMI_JV.spdMain_Changed

진입점: dsdm.Changed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-03053883 | dsdm.Changed | SCP0059_Shipment_Plan_SEMI_JV.cs:3731 | if (!this.CanModelChange \|\| e.Row == -1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4ad93715 | dsdm.Changed | SCP0059_Shipment_Plan_SEMI_JV.cs:3745 | try ▸ if (ds == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-fc261b15 | dsdm.Changed | SCP0059_Shipment_Plan_SEMI_JV.cs:3752 | try ▸ if (strColName == "Action") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6e8d0ecb | dsdm.Changed | SCP0059_Shipment_Plan_SEMI_JV.cs:3783 | try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strColName.IndexOf("W_") == 0) ▸ if (strMea… | CALL_EXT | DateUtil.GetWeekName | (dateValue.DayOfWeek.ToString()) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9b05e39c | dsdm.Changed | SCP0059_Shipment_Plan_SEMI_JV.cs:3785 | try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strColName.IndexOf("W_") == 0) ▸ if (strMea… | GRID_SET | siMain.SetValue | (nRow, iCol, sValue) | 그리드 값 설정 |  |  |  |
| AC-ddca37d2 | dsdm.Changed | SCP0059_Shipment_Plan_SEMI_JV.cs:3788 | try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strColName.IndexOf("W_") == 0) ▸ if (strMea… | GRID_SET | siMain.SetValue | (nRow, iCol, 0) | 그리드 값 설정 |  |  |  |

## SCP0059_Shipment_Plan_SEMI_JV.SpdMain_KeyUp

진입점: this.spdMain.KeyUp

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-eafde326 | this.spdMain.KeyUp | SCP0059_Shipment_Plan_SEMI_JV.cs:549 | if (siMain.GetColumnIndex(DefMain.MEASURE) >= siMain.ActiveColumnIndex) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2c5105bd | this.spdMain.KeyUp | SCP0059_Shipment_Plan_SEMI_JV.cs:553 | if (e.Control == true && e.KeyCode == Keys.V \|\| e.Control == false && e.KeyCode == Keys.V) | CALL_EXT | spdMain.ActiveSheet.ClipboardPaste | (ClipboardPasteOptions.AsStringSkipHidden) | ⚠ 의미 확인 필요 |  |  |  |
| AC-df198c85 | this.spdMain.KeyUp | SCP0059_Shipment_Plan_SEMI_JV.cs:558 | if (e.Control == true && e.KeyCode == Keys.C \|\| e.Control == false && e.KeyCode == Keys.C) | CALL_EXT | Clipboard.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-1daaba1a | this.spdMain.KeyUp | SCP0059_Shipment_Plan_SEMI_JV.cs:559 | if (e.Control == true && e.KeyCode == Keys.C \|\| e.Control == false && e.KeyCode == Keys.C) | CALL_EXT | spdMain.Sheets[0].ClipboardCopy | (ClipboardCopyOptions.AsStringSkipHidden) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0059_Shipment_Plan_SEMI_JV.spdMain_TopChange

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f1e6edca | (진입점 미연결) | SCP0059_Shipment_Plan_SEMI_JV.cs:3690 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0059_Shipment_Plan_SEMI_JV.SpdMain_TopChange

진입점: this.spdMain.TopChange / this.spdMain.CellClick [if ((e.Column == siMain.GetColumnIndex(DefMain.TRANSPORT_MODE) \|\| e.Column == siMain.GetColumnIndex(DefMain.TO_SITE_DESCRIPT…)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ceff2728 | this.spdMain.TopChange 외 1 | SCP0059_Shipment_Plan_SEMI_JV.cs:3952 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0059_Shipment_Plan_SEMI_JV.SubSumMerge

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d5983389 | (진입점 미연결) | SCP0059_Shipment_Plan_SEMI_JV.cs:1961 |  | DATA_OP | dtBinding.Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-2cf20714 | (진입점 미연결) | SCP0059_Shipment_Plan_SEMI_JV.cs:1976 | for (iRow <= r2) | DATA_OP | dicSubSumItems.ContainsKey | (target) | 데이터 객체 조작/조회 |  |  |  |
| AC-f4b1bac9 | (진입점 미연결) | SCP0059_Shipment_Plan_SEMI_JV.cs:1978 | for (iRow <= r2) ▸ if (dicSubSumItems.ContainsKey(target)) | DATA_OP | (dicSubSumItems[target]).Add | (iRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-15db2d75 | (진입점 미연결) | SCP0059_Shipment_Plan_SEMI_JV.cs:1988 | foreach (var pair in dicSubSumItems) | DATA_OP | tmp.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-1653df40 | (진입점 미연결) | SCP0059_Shipment_Plan_SEMI_JV.cs:1994 | foreach (var pair in dicSubSumItems) ▸ for (iCol <= subsum_begin) | DATA_OP | dr[iCol] | dtBinding.Rows[r2][iCol] | 행/컬럼 값 대입 |  |  |  |
| AC-f35d94fc | (진입점 미연결) | SCP0059_Shipment_Plan_SEMI_JV.cs:2000 | foreach (var pair in dicSubSumItems) ▸ for (iCol <= targetColumn) | DATA_OP | dr[iCol] | "Total" | 행/컬럼 값 대입 |  |  |  |
| AC-9663cb95 | (진입점 미연결) | SCP0059_Shipment_Plan_SEMI_JV.cs:2003 | foreach (var pair in dicSubSumItems) ▸ for (iCol <= targetColumn) ▸ if (iCol == targetColumn) | DATA_OP | dr[iCol] | colName | 행/컬럼 값 대입 |  |  |  |
| AC-d2bf00dd | (진입점 미연결) | SCP0059_Shipment_Plan_SEMI_JV.cs:2014 | foreach (var pair in dicSubSumItems) ▸ for (sCol < dtBinding.Columns.Count) | DATA_OP | dr[sCol] | sum | 행/컬럼 값 대입 |  |  |  |
| AC-1172c2a8 | (진입점 미연결) | SCP0059_Shipment_Plan_SEMI_JV.cs:2017 | foreach (var pair in dicSubSumItems) | DATA_OP | tmp.Rows.Add | (dr) | 데이터 객체 조작/조회 |  |  |  |
| AC-236d353e | (진입점 미연결) | SCP0059_Shipment_Plan_SEMI_JV.cs:2019 |  | DATA_OP | tmp.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-2c7db0e6 | (진입점 미연결) | SCP0059_Shipment_Plan_SEMI_JV.cs:2020 |  | DATA_OP | dtBinding.Merge | (tmp) | 데이터 객체 조작/조회 |  |  |  |
| AC-9d5cee8a | (진입점 미연결) | SCP0059_Shipment_Plan_SEMI_JV.cs:2026 | foreach (var pair in dicSubSumItems) ▸ if (dicSubSumItems[pair.Key] != null) | CALL_EXT | (dicSubSumItems[pair.Key]).Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-6f46249f | (진입점 미연결) | SCP0059_Shipment_Plan_SEMI_JV.cs:2030 |  | STATE_RESET | dicSubSum_Range.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-c46383d3 | (진입점 미연결) | SCP0059_Shipment_Plan_SEMI_JV.cs:2034 | if (!next_key.Equals("")) | DATA_OP | dicSubSum_Range.Add | (next_key, dtBinding.Rows.Count + 1) | 데이터 객체 조작/조회 |  |  |  |

## SCP0059_Shipment_Plan_SEMI_JV.TotalCellsMerge

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-99ccd226 | (진입점 미연결) | SCP0059_Shipment_Plan_SEMI_JV.cs:1550 |  | DATA_OP | list.Add | (siMain.GetColumnIndex(DefMain.TO_SITE_DESCRIPTION)) | 데이터 객체 조작/조회 |  |  |  |
| AC-4cd1a4fa | (진입점 미연결) | SCP0059_Shipment_Plan_SEMI_JV.cs:1551 |  | DATA_OP | list.Add | (siMain.GetColumnIndex(DefMain.TRANSPORT_MODE)) | 데이터 객체 조작/조회 |  |  |  |
| AC-df8bc4ed | (진입점 미연결) | SCP0059_Shipment_Plan_SEMI_JV.cs:1552 |  | DATA_OP | list.Add | (siMain.GetColumnIndex(DefMain.LT_DAY)) | 데이터 객체 조작/조회 |  |  |  |
| AC-83a4ecf3 | (진입점 미연결) | SCP0059_Shipment_Plan_SEMI_JV.cs:1577 | for (iRow <= siMain.GetMaxRowIndex()) ▸ if (cur_key_idx != bef_key_idx) ▸ foreach (int idx in list) | UI_PROP | range.HorizontalAlignment | CellHorizontalAlignment.Center | 속성 HorizontalAlignment 설정 |  |  |  |
| AC-81346528 | (진입점 미연결) | SCP0059_Shipment_Plan_SEMI_JV.cs:1578 | for (iRow <= siMain.GetMaxRowIndex()) ▸ if (cur_key_idx != bef_key_idx) ▸ foreach (int idx in list) | UI_PROP | range.ForeColor | Color.Black | 속성 ForeColor 설정 |  |  |  |
| AC-10150cb7 | (진입점 미연결) | SCP0059_Shipment_Plan_SEMI_JV.cs:1579 | for (iRow <= siMain.GetMaxRowIndex()) ▸ if (cur_key_idx != bef_key_idx) ▸ foreach (int idx in list) | UI_PROP | range.RowSpan | rowSpan_Count | 속성 RowSpan 설정 |  |  |  |
| AC-8aebf5bf | (진입점 미연결) | SCP0059_Shipment_Plan_SEMI_JV.cs:1583 | for (iRow <= siMain.GetMaxRowIndex()) ▸ if (cur_key_idx != bef_key_idx) | UI_PROP | boh.HorizontalAlignment | CellHorizontalAlignment.Center | 속성 HorizontalAlignment 설정 |  |  |  |
| AC-7df9a189 | (진입점 미연결) | SCP0059_Shipment_Plan_SEMI_JV.cs:1584 | for (iRow <= siMain.GetMaxRowIndex()) ▸ if (cur_key_idx != bef_key_idx) | UI_PROP | boh.RowSpan | bohSpan_Count | 속성 RowSpan 설정 |  |  |  |
| AC-0fcfe49e | (진입점 미연결) | SCP0059_Shipment_Plan_SEMI_JV.cs:1614 | for (iRow <= siMain.GetMaxRowIndex()) ▸ if (iRow == siMain.GetMaxRowIndex()) ▸ if (isSum) ▸ foreach (int idx in list) | UI_PROP | range.HorizontalAlignment | CellHorizontalAlignment.Center | 속성 HorizontalAlignment 설정 |  |  |  |
| AC-e146ce18 | (진입점 미연결) | SCP0059_Shipment_Plan_SEMI_JV.cs:1615 | for (iRow <= siMain.GetMaxRowIndex()) ▸ if (iRow == siMain.GetMaxRowIndex()) ▸ if (isSum) ▸ foreach (int idx in list) | UI_PROP | range.ForeColor | Color.Black | 속성 ForeColor 설정 |  |  |  |
| AC-86297086 | (진입점 미연결) | SCP0059_Shipment_Plan_SEMI_JV.cs:1616 | for (iRow <= siMain.GetMaxRowIndex()) ▸ if (iRow == siMain.GetMaxRowIndex()) ▸ if (isSum) ▸ foreach (int idx in list) | UI_PROP | range.RowSpan | rowSpan_Count | 속성 RowSpan 설정 |  |  |  |
| AC-f6d6bcd5 | (진입점 미연결) | SCP0059_Shipment_Plan_SEMI_JV.cs:1620 | for (iRow <= siMain.GetMaxRowIndex()) ▸ if (iRow == siMain.GetMaxRowIndex()) ▸ if (isSum) | UI_PROP | boh.HorizontalAlignment | CellHorizontalAlignment.Center | 속성 HorizontalAlignment 설정 |  |  |  |
| AC-6af4a656 | (진입점 미연결) | SCP0059_Shipment_Plan_SEMI_JV.cs:1621 | for (iRow <= siMain.GetMaxRowIndex()) ▸ if (iRow == siMain.GetMaxRowIndex()) ▸ if (isSum) | UI_PROP | boh.RowSpan | bohSpan_Count | 속성 RowSpan 설정 |  |  |  |

## SCP0059_Shipment_Plan_SEMI_JV.ValidateUserInput

진입점: SaveButton [if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (iRow < siMain.ActiveSheet.Rows.Count) ▸ if (action == CAppSetting.FlagI && measure_name.Equals("SHIP_PLAN_AMEND")) ▸ for (c < siMain.GetMaxColumnIndex()) ▸ if (!string.IsNullOrEmpty(val)) ▸ if (nDayQty < 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-914d2915 | SaveButton [if (fps.Name == spdMain.Name) ▸ if (siMain != nu… | SCP0059_Shipment_Plan_SEMI_JV.cs:2802 | if (action_name.Equals("NO_DATA")) ▸ if (siMain.ActiveSheet.RowCount <= 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00059") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-859321fb | SaveButton [if (fps.Name == spdMain.Name) ▸ if (siMain != nu… | SCP0059_Shipment_Plan_SEMI_JV.cs:2809 | else of (action_name.Equals("NO_DATA")) ▸ if (action_name.Equals("NO_CHECKED")) | MESSAGE | MessageHelper.GMessageBox | ("MSG00017") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-bf50e255 | SaveButton [if (fps.Name == spdMain.Name) ▸ if (siMain != nu… | SCP0059_Shipment_Plan_SEMI_JV.cs:2823 | else of (action_name.Equals("NO_DATA")) ▸ else of (action_name.Equals("NO_CHECKED")) ▸ if (action_name.Equals("CHK_PERIOD")) ▸ if (DateTime.… | MESSAGE | MessageHelper.GMessageBox | ("MSG00171") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-1d644528 | SaveButton [if (fps.Name == spdMain.Name) ▸ if (siMain != nu… | SCP0059_Shipment_Plan_SEMI_JV.cs:2825 | else of (action_name.Equals("NO_DATA")) ▸ else of (action_name.Equals("NO_CHECKED")) ▸ if (action_name.Equals("CHK_PERIOD")) ▸ if (DateTime.… | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |
| AC-b6d1a258 | SaveButton [if (fps.Name == spdMain.Name) ▸ if (siMain != nu… | SCP0059_Shipment_Plan_SEMI_JV.cs:2831 | else of (action_name.Equals("NO_DATA")) ▸ else of (action_name.Equals("NO_CHECKED")) ▸ if (action_name.Equals("CHK_PERIOD")) ▸ if (diff.Days… | MESSAGE | MessageHelper.GMessageBox | ("MSG00172", new object[] { 364 }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-46849599 | SaveButton [if (fps.Name == spdMain.Name) ▸ if (siMain != nu… | SCP0059_Shipment_Plan_SEMI_JV.cs:2838 | else of (action_name.Equals("NO_DATA")) ▸ else of (action_name.Equals("NO_CHECKED")) ▸ else of (action_name.Equals("CHK_PERIOD")) ▸ if (acti… | MESSAGE | MessageHelper.GMessageBox | ("MSG00084") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6713e2fa | SaveButton [if (fps.Name == spdMain.Name) ▸ if (siMain != nu… | SCP0059_Shipment_Plan_SEMI_JV.cs:2845 | else of (action_name.Equals("NO_DATA")) ▸ else of (action_name.Equals("NO_CHECKED")) ▸ else of (action_name.Equals("CHK_PERIOD")) ▸ else of … | MESSAGE | MessageHelper.GMessageBox | ("MSG00233") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b3cc97f0 | SaveButton [if (fps.Name == spdMain.Name) ▸ if (siMain != nu… | SCP0059_Shipment_Plan_SEMI_JV.cs:2851 | else of (action_name.Equals("NO_DATA")) ▸ else of (action_name.Equals("NO_CHECKED")) ▸ else of (action_name.Equals("CHK_PERIOD")) ▸ else of … | MESSAGE | MessageHelper.GMessageBox | ("MSG00317", new object[] { "100,000,000" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-14995cae | SaveButton [if (fps.Name == spdMain.Name) ▸ if (siMain != nu… | SCP0059_Shipment_Plan_SEMI_JV.cs:2854 |  | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |

