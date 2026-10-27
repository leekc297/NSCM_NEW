# AS-IS 액션 대조표 — SCP0010

> 원천: `Doc/asisfacts/screens/SCP0010/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 1056행 · 메서드 75 · 종류 DATA_OP 601 · GRID_INIT 68 · RETURN 59 · UI_PROP 48 · GRID_SET 37 · CALL_EXT 34 · MESSAGE 31 · FLAG 26 · GRID_LOCK 26 · UI_MISC 24 · ENDPOINT 23 · POPUP 17 · VALUE_SET 15 · STATE 11 · GRID_STYLE 9 · LIST_REBIND 9 · COMBO_DATA 5 · GRID_CLEAR 4 · VALIDATE 3 · GRID_BIND 2 · STATE_RESET 2 · THROW 1 · VALUE_CLEAR 1 · ⚠ 의미 확인 필요 34


## Calc_Measure..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6116df55 | .ctor | SCP0010_Shipment_Plan_SEMI.cs:5030 |  | FLAG | this._header_last_idx | header_last_idx | 화면 필드/플래그 변경 |  |  |  |
| AC-b7d030d1 | .ctor | SCP0010_Shipment_Plan_SEMI.cs:5035 | foreach (var item in list) | DATA_OP | _inputMeasure.Add | (item, new List<int>()) | 데이터 객체 조작/조회 |  |  |  |

## Calc_Measure.RetDoubleValue

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-184fcc1a | (진입점 미연결) | SCP0010_Shipment_Plan_SEMI.cs:5252 |  | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |

## Calc_Measure.RetIntValue

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-da7ecefb | (진입점 미연결) | SCP0010_Shipment_Plan_SEMI.cs:5234 |  | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |

## Calc_Measure.RetLongValue

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1ba3d2a8 | (진입점 미연결) | SCP0010_Shipment_Plan_SEMI.cs:5241 | if (obj.ToString() != "" && obj != null && obj != DBNull.Value) | CALL_EXT | Convert.ToInt64 | (obj) | ⚠ 의미 확인 필요 |  |  |  |
| AC-205fe60e | (진입점 미연결) | SCP0010_Shipment_Plan_SEMI.cs:5243 |  | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |

## Calc_Measure.SetCalcMeasure

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5562a74d | (진입점 미연결) | SCP0010_Shipment_Plan_SEMI.cs:5101 | for (col < dtBinding.Columns.Count) ▸ for (iRow < end_row) ▸ if (measure_name.Equals("INVENTORY")) ▸ if (dtBinding.Columns[col].ColumnName.I… | GRID_SET | dtBinding.Rows[iRow][bef_Month_Idx] | sum | 그리드 속성/값 설정 |  |  |  |
| AC-e3f38867 | (진입점 미연결) | SCP0010_Shipment_Plan_SEMI.cs:5108 | for (col < dtBinding.Columns.Count) ▸ for (iRow < end_row) ▸ if (measure_name.Equals("INVENTORY")) ▸ if (dtBinding.Columns[col].ColumnName.I… | GRID_SET | dtBinding.Rows[iRow][col] | sum | 그리드 속성/값 설정 |  |  |  |
| AC-dc8e1061 | (진입점 미연결) | SCP0010_Shipment_Plan_SEMI.cs:5128 | for (col < dtBinding.Columns.Count) ▸ for (iRow < end_row) ▸ if (measure_name.Equals("INVENTORY")) ▸ else of (dtBinding.Columns[col].ColumnN… | GRID_SET | dtBinding.Rows[iRow][bef_Week_idx] | sum | 그리드 속성/값 설정 |  |  |  |
| AC-0ce7e7f6 | (진입점 미연결) | SCP0010_Shipment_Plan_SEMI.cs:5135 | for (col < dtBinding.Columns.Count) ▸ for (iRow < end_row) ▸ if (measure_name.Equals("INVENTORY")) ▸ else of (dtBinding.Columns[col].ColumnN… | GRID_SET | dtBinding.Rows[iRow][col] | sum | 그리드 속성/값 설정 |  |  |  |
| AC-bd09161d | (진입점 미연결) | SCP0010_Shipment_Plan_SEMI.cs:5161 | for (col < dtBinding.Columns.Count) ▸ for (iRow < end_row) ▸ if (measure_name.Equals("INVENTORY")) ▸ else of (dtBinding.Columns[col].ColumnN… | GRID_SET | dtBinding.Rows[iRow][col] | sum | 그리드 속성/값 설정 |  |  |  |
| AC-d8d6fb10 | (진입점 미연결) | SCP0010_Shipment_Plan_SEMI.cs:5177 | for (col < dtBinding.Columns.Count) ▸ for (iRow < end_row) ▸ if (measure_name.Equals("INVENTORY")) ▸ else of (dtBinding.Columns[col].ColumnN… | GRID_SET | dtBinding.Rows[iRow][bef_Week_idx] | last_sum | 그리드 속성/값 설정 |  |  |  |
| AC-af65055d | (진입점 미연결) | SCP0010_Shipment_Plan_SEMI.cs:5184 | for (col < dtBinding.Columns.Count) ▸ for (iRow < end_row) ▸ if (measure_name.Equals("INVENTORY")) ▸ else of (dtBinding.Columns[col].ColumnN… | GRID_SET | dtBinding.Rows[iRow][col] | last_sum | 그리드 속성/값 설정 |  |  |  |
| AC-ec995432 | (진입점 미연결) | SCP0010_Shipment_Plan_SEMI.cs:5197 | for (col < dtBinding.Columns.Count) ▸ for (iRow < end_row) ▸ else of (measure_name.Equals("INVENTORY")) ▸ if (to_site_name.Length > 2) | DATA_OP | _inputMeasure[measure_name].Add | (iRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-b12931b2 | (진입점 미연결) | SCP0010_Shipment_Plan_SEMI.cs:5217 | for (col < dtBinding.Columns.Count) ▸ for (iRow < end_row) ▸ else of (measure_name.Equals("INVENTORY")) ▸ else of (to_site_name.Length > 2) | GRID_SET | dtBinding.Rows[iRow][col] | sum | 그리드 속성/값 설정 |  |  |  |
| AC-b8361d3c | (진입점 미연결) | SCP0010_Shipment_Plan_SEMI.cs:5218 | for (col < dtBinding.Columns.Count) ▸ for (iRow < end_row) ▸ else of (measure_name.Equals("INVENTORY")) ▸ else of (to_site_name.Length > 2) | CALL_EXT | _inputMeasure[measure_name].Clear | () | ⚠ 의미 확인 필요 |  |  |  |

## SCP0010_Shipment_Plan_SEMI.BlockCellsChecking

진입점: this.spdMain.CellClick [if ((e.Column == siMain.GetColumnIndex(DefMain.TRANSPORT_MODE) \|\| e.Column == siMain.GetColumnIndex(DefMain.TO_SITE_DESCRIPT…) ▸ if (cboDivision.ControlValues.Equals("81") \|\| cboDivision.ControlValues.Equals("81_UC"))] / EditButton [if (fps != null) ▸ if (this.IsEditMode && cboBucketType.ControlValues != BucketType.Monthly) ▸ if (EditBlockChecking(2) != 1) ▸ if (cboDivision.ControlValues.Equals("81") \|\| cboDivision.ControlValues.Equals("81_UC"))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-597309ba | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… 외 1 | SCP0010_Shipment_Plan_SEMI.cs:3118 | for (iRow < siMain.ActiveSheet.RowCount) ▸ if (siMain.GetValue(iRow, measure_idx).Equals("SHIP_PLAN_AMEND") && siMain.GetValue(iRow, site_id… | GRID_LOCK | siMain.LockRange | (iRow, 1, iRow, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-e1af55ef | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… 외 1 | SCP0010_Shipment_Plan_SEMI.cs:3128 | for (iRow < siMain.ActiveSheet.RowCount) ▸ if (siMain.GetValue(iRow, measure_idx).Equals("SHIP_PLAN_AMEND") && siMain.GetValue(iRow, site_id… | GRID_LOCK | siMain.LockRange | (iRow, 1, iRow, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-eb1b5e24 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… 외 1 | SCP0010_Shipment_Plan_SEMI.cs:3150 | for (iRow < siMain.ActiveSheet.RowCount) ▸ if (siMain.GetValue(iRow, measure_idx).Equals("SHIP_PLAN_AMEND") && siMain.GetValue(iRow, site_id… | CALL_EXT | frozenDate.CompareTo | (dtBodTo) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c795f777 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… 외 1 | SCP0010_Shipment_Plan_SEMI.cs:3152 | for (iRow < siMain.ActiveSheet.RowCount) ▸ if (siMain.GetValue(iRow, measure_idx).Equals("SHIP_PLAN_AMEND") && siMain.GetValue(iRow, site_id… | GRID_LOCK | siMain.LockRange | (iRow, 1, iRow, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-bc2a4c9a | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… 외 1 | SCP0010_Shipment_Plan_SEMI.cs:3156 | for (iRow < siMain.ActiveSheet.RowCount) ▸ if (siMain.GetValue(iRow, measure_idx).Equals("SHIP_PLAN_AMEND") && siMain.GetValue(iRow, site_id… | CALL_EXT | dtBodFrom.CompareTo | (frozenDate) | ⚠ 의미 확인 필요 |  |  |  |
| AC-771ba8ee | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… 외 1 | SCP0010_Shipment_Plan_SEMI.cs:3164 | for (iRow < siMain.ActiveSheet.RowCount) ▸ if (siMain.GetValue(iRow, measure_idx).Equals("SHIP_PLAN_AMEND") && siMain.GetValue(iRow, site_id… | CALL_EXT | frozenDate.CompareTo | (dtBodFrom) | ⚠ 의미 확인 필요 |  |  |  |
| AC-cdc74712 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… 외 1 | SCP0010_Shipment_Plan_SEMI.cs:3164 | for (iRow < siMain.ActiveSheet.RowCount) ▸ if (siMain.GetValue(iRow, measure_idx).Equals("SHIP_PLAN_AMEND") && siMain.GetValue(iRow, site_id… | CALL_EXT | dtBodTo.CompareTo | (frozenDate) | ⚠ 의미 확인 필요 |  |  |  |
| AC-eb786f68 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… 외 1 | SCP0010_Shipment_Plan_SEMI.cs:3199 | for (iRow < siMain.ActiveSheet.RowCount) ▸ if (siMain.GetValue(iRow, measure_idx).Equals("SHIP_PLAN_AMEND") && siMain.GetValue(iRow, site_id… | GRID_LOCK | siMain.LockRange | (iRow, nStartEditIdx, iRow, siMain.ActiveSheet.ColumnCount - 1, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-0cdbc6a5 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… 외 1 | SCP0010_Shipment_Plan_SEMI.cs:3212 | for (iRow < siMain.ActiveSheet.RowCount) ▸ if (siMain.GetValue(iRow, measure_idx).Equals("SHIP_PLAN_AMEND") && siMain.GetValue(iRow, site_id… | GRID_LOCK | siMain.LockRange | (0, iCol, siMain.ActiveSheet.RowCount - 1, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-2eb12386 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… 외 1 | SCP0010_Shipment_Plan_SEMI.cs:3230 | for (iRow < siMain.ActiveSheet.RowCount) ▸ if (siMain.GetValue(iRow, measure_idx).Equals("SHIP_PLAN_AMEND") && siMain.GetValue(iRow, site_id… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(siMain.ActiveSheet.Columns[j].Tag.ToString()), iRow, siMain.A… | 그리드 편집 잠금/해제 |  |  |  |
| AC-79292d11 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… 외 1 | SCP0010_Shipment_Plan_SEMI.cs:3231 | for (iRow < siMain.ActiveSheet.RowCount) ▸ if (siMain.GetValue(iRow, measure_idx).Equals("SHIP_PLAN_AMEND") && siMain.GetValue(iRow, site_id… | GRID_STYLE | siMain.SetBGColor | (iRow, siMain.GetColumnIndex(siMain.ActiveSheet.Columns[j].Tag.ToString()), iRow, siMain.G… | 그리드 표시 설정 |  |  |  |
| AC-b637bbd2 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… 외 1 | SCP0010_Shipment_Plan_SEMI.cs:3240 | for (iRow < siMain.ActiveSheet.RowCount) ▸ if (siMain.GetValue(iRow, measure_idx).Equals("SHIP_PLAN_AMEND") && siMain.GetValue(iRow, site_id… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(siMain.ActiveSheet.Columns[j].Tag.ToString()), iRow, siMain.A… | 그리드 편집 잠금/해제 |  |  |  |
| AC-61533417 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… 외 1 | SCP0010_Shipment_Plan_SEMI.cs:3251 | for (iRow < siMain.ActiveSheet.RowCount) ▸ if (siMain.GetValue(iRow, measure_idx).Equals("SHIP_PLAN_AMEND") && siMain.GetValue(iRow, site_id… | GRID_LOCK | siMain.LockRange | (0, j, siMain.ActiveSheet.RowCount - 1, j, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-7f38e941 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… 외 1 | SCP0010_Shipment_Plan_SEMI.cs:3258 | for (iRow < siMain.ActiveSheet.RowCount) ▸ if (siMain.GetValue(iRow, measure_idx).Equals("SHIP_PLAN_AMEND") && siMain.GetValue(iRow, site_id… | UI_MISC | spdMain.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-0ab9f76e | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… 외 1 | SCP0010_Shipment_Plan_SEMI.cs:3264 | for (iRow < siMain.ActiveSheet.RowCount) ▸ else of (siMain.GetValue(iRow, measure_idx).Equals("SHIP_PLAN_AMEND") && siMain.GetValue(iRow, si… | GRID_LOCK | siMain.LockRange | (iRow, 1, iRow, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |

## SCP0010_Shipment_Plan_SEMI.BlockCellsChecking_2

진입점: this.spdMain.CellClick [if ((e.Column == siMain.GetColumnIndex(DefMain.TRANSPORT_MODE) \|\| e.Column == siMain.GetColumnIndex(DefMain.TO_SITE_DESCRIPT…) ▸ else of (cboDivision.ControlValues.Equals("81") \|\| cboDivision.ControlValues.Equals("81_UC"))] / EditButton [if (fps != null) ▸ if (this.IsEditMode && cboBucketType.ControlValues != BucketType.Monthly) ▸ if (EditBlockChecking(2) != 1) ▸ if (!(cboDivision.ControlValues.Equals("81") \|\| cboDivision.ControlValues.Equals("81_UC")))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-eead5107 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… 외 1 | SCP0010_Shipment_Plan_SEMI.cs:3350 | for (iRow < siMain.ActiveSheet.RowCount) ▸ if (siMain.GetValue(iRow, measure_idx).Equals("SHIP_PLAN_AMEND") && siMain.GetValue(iRow, site_id… | GRID_LOCK | siMain.LockRange | (iRow, 1, iRow, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-1f1a4ed8 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… 외 1 | SCP0010_Shipment_Plan_SEMI.cs:3372 | for (iRow < siMain.ActiveSheet.RowCount) ▸ if (siMain.GetValue(iRow, measure_idx).Equals("SHIP_PLAN_AMEND") && siMain.GetValue(iRow, site_id… | CALL_EXT | frozenDate.CompareTo | (dtBodTo) | ⚠ 의미 확인 필요 |  |  |  |
| AC-5cd72ef5 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… 외 1 | SCP0010_Shipment_Plan_SEMI.cs:3374 | for (iRow < siMain.ActiveSheet.RowCount) ▸ if (siMain.GetValue(iRow, measure_idx).Equals("SHIP_PLAN_AMEND") && siMain.GetValue(iRow, site_id… | GRID_LOCK | siMain.LockRange | (iRow, 1, iRow, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-24bf839c | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… 외 1 | SCP0010_Shipment_Plan_SEMI.cs:3378 | for (iRow < siMain.ActiveSheet.RowCount) ▸ if (siMain.GetValue(iRow, measure_idx).Equals("SHIP_PLAN_AMEND") && siMain.GetValue(iRow, site_id… | CALL_EXT | dtBodFrom.CompareTo | (frozenDate) | ⚠ 의미 확인 필요 |  |  |  |
| AC-1fb42ef9 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… 외 1 | SCP0010_Shipment_Plan_SEMI.cs:3386 | for (iRow < siMain.ActiveSheet.RowCount) ▸ if (siMain.GetValue(iRow, measure_idx).Equals("SHIP_PLAN_AMEND") && siMain.GetValue(iRow, site_id… | CALL_EXT | frozenDate.CompareTo | (dtBodFrom) | ⚠ 의미 확인 필요 |  |  |  |
| AC-82a34bf4 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… 외 1 | SCP0010_Shipment_Plan_SEMI.cs:3386 | for (iRow < siMain.ActiveSheet.RowCount) ▸ if (siMain.GetValue(iRow, measure_idx).Equals("SHIP_PLAN_AMEND") && siMain.GetValue(iRow, site_id… | CALL_EXT | dtBodTo.CompareTo | (frozenDate) | ⚠ 의미 확인 필요 |  |  |  |
| AC-2a942ccf | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… 외 1 | SCP0010_Shipment_Plan_SEMI.cs:3411 | for (iRow < siMain.ActiveSheet.RowCount) ▸ if (siMain.GetValue(iRow, measure_idx).Equals("SHIP_PLAN_AMEND") && siMain.GetValue(iRow, site_id… | DATA_OP | lstBlockWeek_Month.Add | (iCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-2ec2cc34 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… 외 1 | SCP0010_Shipment_Plan_SEMI.cs:3431 | for (iRow < siMain.ActiveSheet.RowCount) ▸ if (siMain.GetValue(iRow, measure_idx).Equals("SHIP_PLAN_AMEND") && siMain.GetValue(iRow, site_id… | GRID_LOCK | siMain.LockRange | (iRow, 1, iRow, nBlockColumnEnd, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-aabe5a70 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… 외 1 | SCP0010_Shipment_Plan_SEMI.cs:3432 | for (iRow < siMain.ActiveSheet.RowCount) ▸ if (siMain.GetValue(iRow, measure_idx).Equals("SHIP_PLAN_AMEND") && siMain.GetValue(iRow, site_id… | GRID_LOCK | siMain.LockRange | (iRow, nBlockColumnEnd + 1, iRow, siMain.GetMaxColumnIndex(), false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-9b565ed9 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… 외 1 | SCP0010_Shipment_Plan_SEMI.cs:3436 | for (iRow < siMain.ActiveSheet.RowCount) ▸ if (siMain.GetValue(iRow, measure_idx).Equals("SHIP_PLAN_AMEND") && siMain.GetValue(iRow, site_id… | GRID_LOCK | siMain.LockRange | (iRow, 1, iRow, nBlockColumnEnd, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-dabb4a94 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… 외 1 | SCP0010_Shipment_Plan_SEMI.cs:3437 | for (iRow < siMain.ActiveSheet.RowCount) ▸ if (siMain.GetValue(iRow, measure_idx).Equals("SHIP_PLAN_AMEND") && siMain.GetValue(iRow, site_id… | GRID_LOCK | siMain.LockRange | (iRow, nBlockColumnEnd + 1, iRow, iBlockLastIdx, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-c9938c0d | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… 외 1 | SCP0010_Shipment_Plan_SEMI.cs:3438 | for (iRow < siMain.ActiveSheet.RowCount) ▸ if (siMain.GetValue(iRow, measure_idx).Equals("SHIP_PLAN_AMEND") && siMain.GetValue(iRow, site_id… | GRID_LOCK | siMain.LockRange | (iRow, iBlockLastIdx + 1, iRow, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-2f59de7a | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… 외 1 | SCP0010_Shipment_Plan_SEMI.cs:3447 | for (iRow < siMain.ActiveSheet.RowCount) ▸ if (siMain.GetValue(iRow, measure_idx).Equals("SHIP_PLAN_AMEND") && siMain.GetValue(iRow, site_id… | GRID_LOCK | siMain.LockRange2 | (iRow, col, iRow, col, true) | 그리드 편집 잠금 전환 |  |  |  |
| AC-5c0b6821 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… 외 1 | SCP0010_Shipment_Plan_SEMI.cs:3460 | for (iRow < siMain.ActiveSheet.RowCount) ▸ if (siMain.GetValue(iRow, measure_idx).Equals("SHIP_PLAN_AMEND") && siMain.GetValue(iRow, site_id… | GRID_LOCK | siMain.LockRange | (0, iCol, siMain.ActiveSheet.RowCount - 1, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-2514caa9 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… 외 1 | SCP0010_Shipment_Plan_SEMI.cs:3476 | for (iRow < siMain.ActiveSheet.RowCount) ▸ if (siMain.GetValue(iRow, measure_idx).Equals("SHIP_PLAN_AMEND") && siMain.GetValue(iRow, site_id… | GRID_LOCK | siMain.LockRange | (0, iCol, siMain.ActiveSheet.RowCount - 1, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-9864b64f | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… 외 1 | SCP0010_Shipment_Plan_SEMI.cs:3492 | for (iRow < siMain.ActiveSheet.RowCount) ▸ if (siMain.GetValue(iRow, measure_idx).Equals("SHIP_PLAN_AMEND") && siMain.GetValue(iRow, site_id… | GRID_LOCK | siMain.LockRange | (iRow, iCol, iRow, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-e31c700c | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… 외 1 | SCP0010_Shipment_Plan_SEMI.cs:3500 | for (iRow < siMain.ActiveSheet.RowCount) ▸ if (siMain.GetValue(iRow, measure_idx).Equals("SHIP_PLAN_AMEND") && siMain.GetValue(iRow, site_id… | UI_MISC | spdMain.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-9e4b90f1 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… 외 1 | SCP0010_Shipment_Plan_SEMI.cs:3504 | for (iRow < siMain.ActiveSheet.RowCount) ▸ else of (siMain.GetValue(iRow, measure_idx).Equals("SHIP_PLAN_AMEND") && siMain.GetValue(iRow, si… | GRID_LOCK | siMain.LockRange | (iRow, 1, iRow, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |

## SCP0010_Shipment_Plan_SEMI.BtnFix_Click

진입점: this.btnFix.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fd0045be | this.btnFix.Click | SCP0010_Shipment_Plan_SEMI.cs:4854 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-99e82109 | this.btnFix.Click | SCP0010_Shipment_Plan_SEMI.cs:4855 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-44093a8f | this.btnFix.Click | SCP0010_Shipment_Plan_SEMI.cs:4861 | if (siMain.IsLock(siMain.SheetName)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00010") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f70ab468 | this.btnFix.Click | SCP0010_Shipment_Plan_SEMI.cs:4865 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (!Get_IsSaveYn()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0010_Shipment_Plan_SEMI.BtnItem_Id_Click

진입점: this.btnItem_Id.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9e019810 | this.btnItem_Id.Click | SCP0010_Shipment_Plan_SEMI.cs:4831 |  | CALL_EXT | UIUtils.GetAllDivisionCheckedElectrode | (cboDivision) | ⚠ 의미 확인 필요 |  |  |  |
| AC-2468bd9a | this.btnItem_Id.Click | SCP0010_Shipment_Plan_SEMI.cs:4833 |  | POPUP | new SCM0002_ItembyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-dc9a777d | this.btnItem_Id.Click | SCP0010_Shipment_Plan_SEMI.cs:4835 |  | POPUP | popItem.Form_Load | (true, division, sScmSite, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-5961050c | this.btnItem_Id.Click | SCP0010_Shipment_Plan_SEMI.cs:4836 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-cd095a73 | this.btnItem_Id.Click | SCP0010_Shipment_Plan_SEMI.cs:4837 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-11121648 | this.btnItem_Id.Click | SCP0010_Shipment_Plan_SEMI.cs:4843 | if (popItem.ItemID != "") | VALUE_SET | txtItemId.Text | sItemId | 컨트롤 값 설정 |  |  |  |

## SCP0010_Shipment_Plan_SEMI.btnMeasure_Click

진입점: this.btnMeasure.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-437485ac | this.btnMeasure.Click | SCP0010_Shipment_Plan_SEMI.cs:4739 |  | POPUP | new SCM0002_TitleSetForm_Popup | ("SCP0010", measureType, false) | 팝업/폼 생성 |  |  |  |
| AC-3e77cf05 | this.btnMeasure.Click | SCP0010_Shipment_Plan_SEMI.cs:4740 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-ea4a8708 | this.btnMeasure.Click | SCP0010_Shipment_Plan_SEMI.cs:4741 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-420eaed7 | this.btnMeasure.Click | SCP0010_Shipment_Plan_SEMI.cs:4745 | if (frm.DialogResult == DialogResult.OK) | UI_PROP | this.CanModelChange | false | 속성 CanModelChange 설정 |  |  |  |
| AC-5b6ef517 | this.btnMeasure.Click | SCP0010_Shipment_Plan_SEMI.cs:4748 | if (frm.DialogResult == DialogResult.OK) | UI_PROP | this.CanModelChange | true | 속성 CanModelChange 설정 |  |  |  |

## SCP0010_Shipment_Plan_SEMI.BtnNew_Click

진입점: this.btnNew.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7f02e528 | this.btnNew.Click | SCP0010_Shipment_Plan_SEMI.cs:4903 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6bdad13f | this.btnNew.Click | SCP0010_Shipment_Plan_SEMI.cs:4904 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b4308a22 | this.btnNew.Click | SCP0010_Shipment_Plan_SEMI.cs:4908 | if (cboPlanDate.ControlValues == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-513e97a2 | this.btnNew.Click | SCP0010_Shipment_Plan_SEMI.cs:4909 | if (!Get_IsSaveYn()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-73df5406 | this.btnNew.Click | SCP0010_Shipment_Plan_SEMI.cs:4919 |  | POPUP | new SCM0002_ShipmentPlanInsertPopup | () | 팝업/폼 생성 |  |  |  |
| AC-de8cfa8d | this.btnNew.Click | SCP0010_Shipment_Plan_SEMI.cs:4920 |  | UI_PROP | popup.divisionId | division | 속성 divisionId 설정 |  |  |  |
| AC-15c7cb4e | this.btnNew.Click | SCP0010_Shipment_Plan_SEMI.cs:4921 |  | UI_PROP | popup.p_operationGroup | sOperationGroup | 속성 p_operationGroup 설정 |  |  |  |
| AC-f40036b7 | this.btnNew.Click | SCP0010_Shipment_Plan_SEMI.cs:4922 |  | UI_PROP | popup.p_planDate | dPlanDate | 속성 p_planDate 설정 |  |  |  |
| AC-908d64a5 | this.btnNew.Click | SCP0010_Shipment_Plan_SEMI.cs:4923 |  | UI_PROP | popup.p_plan_start_yyyymmdd | sPlanStartYyyymmdd | 속성 p_plan_start_yyyymmdd 설정 |  |  |  |
| AC-9b42c515 | this.btnNew.Click | SCP0010_Shipment_Plan_SEMI.cs:4924 |  | UI_PROP | popup.p_planType | sPlanType | 속성 p_planType 설정 |  |  |  |
| AC-093eb70e | this.btnNew.Click | SCP0010_Shipment_Plan_SEMI.cs:4925 |  | UI_PROP | popup.p_seq | sSeq | 속성 p_seq 설정 |  |  |  |
| AC-48810087 | this.btnNew.Click | SCP0010_Shipment_Plan_SEMI.cs:4926 |  | UI_PROP | popup.p_user_id | UserInfo.UserId | 속성 p_user_id 설정 |  |  |  |
| AC-5cfc50bc | this.btnNew.Click | SCP0010_Shipment_Plan_SEMI.cs:4927 |  | UI_PROP | popup.p_prgram_id | sPrg | 속성 p_prgram_id 설정 |  |  |  |
| AC-9ebaa5b7 | this.btnNew.Click | SCP0010_Shipment_Plan_SEMI.cs:4929 |  | UI_PROP | popup.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-5fa43c1c | this.btnNew.Click | SCP0010_Shipment_Plan_SEMI.cs:4930 |  | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-1653c9ca | this.btnNew.Click | SCP0010_Shipment_Plan_SEMI.cs:4940 | if (popup.DialogResult == DialogResult.OK) ▸ else of (division.Substring(0, 2).Equals("EE")) | VALUE_SET | txtItemId.Text | popup.s_ItemId | 컨트롤 값 설정 |  |  |  |
| AC-270e262f | this.btnNew.Click | SCP0010_Shipment_Plan_SEMI.cs:4943 | if (popup.DialogResult == DialogResult.OK) ▸ else of (division.Substring(0, 2).Equals("EE")) | MESSAGE | MessageHelper.GMessageBox | ("MSG00265") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SCP0010_Shipment_Plan_SEMI.BtnUnfix_Click

진입점: this.btnUnfix.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-41527dc9 | this.btnUnfix.Click | SCP0010_Shipment_Plan_SEMI.cs:4877 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-dcde285b | this.btnUnfix.Click | SCP0010_Shipment_Plan_SEMI.cs:4878 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a0056351 | this.btnUnfix.Click | SCP0010_Shipment_Plan_SEMI.cs:4884 | if (siMain.IsLock(siMain.SheetName)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00010") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-768497a3 | this.btnUnfix.Click | SCP0010_Shipment_Plan_SEMI.cs:4888 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (!Get_IsSaveYn()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e31d99a0 | this.btnUnfix.Click | SCP0010_Shipment_Plan_SEMI.cs:4889 | else of (siMain.IsLock(siMain.SheetName)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00016") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SCP0010_Shipment_Plan_SEMI.BtnW26_Click

진입점: this.btnW26.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0fc208cc | this.btnW26.Click | SCP0010_Shipment_Plan_SEMI.cs:4955 |  | VALUE_SET | dCalendar.InitValue | GetDayRange(PeriodType.W26) | 컨트롤 값 설정 |  |  |  |

## SCP0010_Shipment_Plan_SEMI.BtnW52_Click

진입점: this.btnW52.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0eeec179 | this.btnW52.Click | SCP0010_Shipment_Plan_SEMI.cs:4960 |  | VALUE_SET | dCalendar.InitValue | GetDayRange(PeriodType.W52) | 컨트롤 값 설정 |  |  |  |

## SCP0010_Shipment_Plan_SEMI.BtnWLast_Click

진입점: this.btnWLast.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dc52b410 | this.btnWLast.Click | SCP0010_Shipment_Plan_SEMI.cs:4972 | if (success) | VALUE_SET | dCalendar.InitValue | GetDayRange(WkNum.ToString()) | 컨트롤 값 설정 |  |  |  |

## SCP0010_Shipment_Plan_SEMI.CalculateSum

진입점: dsdm.Changed [try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (strColName.IndexOf("W_") == 0) ▸ if (strColName.IndexOf("D_") == 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9173b50e | dsdm.Changed [try ▸ switch (e.Type) case FarPoint.Win.Spread… | SCP0010_Shipment_Plan_SEMI.cs:4387 | for (nCol < dt.Columns.Count) ▸ if (dt.Columns[nCol].ColumnName.IndexOf("M_") == 0) | DATA_OP | listMonth.Add | (nCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-2d53b5b6 | dsdm.Changed [try ▸ switch (e.Type) case FarPoint.Win.Spread… | SCP0010_Shipment_Plan_SEMI.cs:4391 | for (nCol < dt.Columns.Count) ▸ if (dt.Columns[nCol].ColumnName.IndexOf("W_") == 0) | DATA_OP | listWeek.Add | (nCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-6095d8e9 | dsdm.Changed [try ▸ switch (e.Type) case FarPoint.Win.Spread… | SCP0010_Shipment_Plan_SEMI.cs:4430 | for (nCol < dt.Columns.Count) ▸ if (nCol == dt.Columns.Count - 1 \|\| dt.Columns[nCol].ColumnName.IndexOf("W_") == 0) | DATA_OP | dr[nIdxWeek] | weekSum | 행/컬럼 값 대입 |  |  |  |
| AC-3feafcc2 | dsdm.Changed [try ▸ switch (e.Type) case FarPoint.Win.Spread… | SCP0010_Shipment_Plan_SEMI.cs:4439 | for (nCol < dt.Columns.Count) ▸ if (nCol == dt.Columns.Count - 1 \|\| dt.Columns[nCol].ColumnName.IndexOf("M_") == 0) | DATA_OP | dr[nIdxMonth] | monthSum | 행/컬럼 값 대입 |  |  |  |
| AC-fb541b5b | dsdm.Changed [try ▸ switch (e.Type) case FarPoint.Win.Spread… | SCP0010_Shipment_Plan_SEMI.cs:4446 |  | DATA_OP | dt.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |

## SCP0010_Shipment_Plan_SEMI.CboBucketType_SelectedIndexChanged

진입점: this.cboBucketType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-84948bf5 | this.cboBucketType.SelectedIndexChanged | SCP0010_Shipment_Plan_SEMI.cs:4769 | else of (chkAll.Checked) | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |

## SCP0010_Shipment_Plan_SEMI.CboDivision_SelectedIndexChanged

진입점: cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-585601d3 | cboDivision.SelectedIndexChanged | SCP0010_Shipment_Plan_SEMI.cs:4819 |  | VALUE_SET | btnWLast.Text | "W" + dailyPlanPeriod | 컨트롤 값 설정 |  |  |  |

## SCP0010_Shipment_Plan_SEMI.cboOperGrp_SelectedIndexChanged

진입점: this.cboOperGroup.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d6927797 | this.cboOperGroup.SelectedIndexChanged | SCP0010_Shipment_Plan_SEMI.cs:4680 |  | FLAG | this._curSheetName | cboOperGroup.Text.ToUpper() | 화면 필드/플래그 변경 |  |  |  |

## SCP0010_Shipment_Plan_SEMI.CboPlanDate_SelectedIndexChanged

진입점: cboPlanDate.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d78628c7 | cboPlanDate.SelectedIndexChanged | SCP0010_Shipment_Plan_SEMI.cs:4807 |  | VALUE_SET | dCalendar.InitValue | GetDayRange(PeriodType.W52) | 컨트롤 값 설정 |  |  |  |
| AC-71bdba67 | cboPlanDate.SelectedIndexChanged | SCP0010_Shipment_Plan_SEMI.cs:4808 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |

## SCP0010_Shipment_Plan_SEMI.CboPlanSeq_SelectedIndexChanged

진입점: cboPlanSeq.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-daeb9a8d | cboPlanSeq.SelectedIndexChanged | SCP0010_Shipment_Plan_SEMI.cs:597 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |

## SCP0010_Shipment_Plan_SEMI.CboPlanType_SelectedIndexChanged

진입점: cboPlanType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-76e0826f | cboPlanType.SelectedIndexChanged | SCP0010_Shipment_Plan_SEMI.cs:4788 |  | VALUE_SET | cboPlanSeq.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-a6003d43 | cboPlanType.SelectedIndexChanged | SCP0010_Shipment_Plan_SEMI.cs:4791 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |

## SCP0010_Shipment_Plan_SEMI.CreateBindingDataSet

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a6aae859 | (진입점 미연결) | SCP0010_Shipment_Plan_SEMI.cs:1790 | if (dtQty.Rows.Count == 0) | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-aa705783 | (진입점 미연결) | SCP0010_Shipment_Plan_SEMI.cs:1798 |  | DATA_OP | dtBinding.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-376c27e2 | (진입점 미연결) | SCP0010_Shipment_Plan_SEMI.cs:1799 |  | DATA_OP | ds.Tables.Add | (dtBinding) | 데이터 객체 조작/조회 |  |  |  |
| AC-1cc15b34 | (진입점 미연결) | SCP0010_Shipment_Plan_SEMI.cs:1800 |  | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |

## SCP0010_Shipment_Plan_SEMI.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f43ae6cb | this.Load | SCP0010_Shipment_Plan_SEMI.cs:366 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 3, 1, 20) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-f18e4701 | this.Load | SCP0010_Shipment_Plan_SEMI.cs:367 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-e2e85cab | this.Load | SCP0010_Shipment_Plan_SEMI.cs:368 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0010_Shipment_Plan_SEMI.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d9ae62f0 | this.Load | SCP0010_Shipment_Plan_SEMI.cs:245 |  | UI_PROP | pnlCondition.Height | 100 | 속성 Height 설정 |  |  |  |
| AC-f377dbdf | this.Load | SCP0010_Shipment_Plan_SEMI.cs:249 |  | DATA_OP | dicSubSumItems.Add | ("SHIP_PLAN", new List<int>()) | 데이터 객체 조작/조회 |  |  |  |
| AC-191f3b13 | this.Load | SCP0010_Shipment_Plan_SEMI.cs:250 |  | DATA_OP | dicSubSumItems.Add | ("SHIP_REQ", new List<int>()) | 데이터 객체 조작/조회 |  |  |  |
| AC-c49691ba | this.Load | SCP0010_Shipment_Plan_SEMI.cs:251 |  | DATA_OP | dicSubSumItems.Add | ("SHIP_PLAN_AMEND", new List<int>()) | 데이터 객체 조작/조회 |  |  |  |
| AC-2cca190f | this.Load | SCP0010_Shipment_Plan_SEMI.cs:261 |  | DATA_OP | dicInputMeasure.Add | ("T", new SortedList<int, string> { { 1, "SHIP_REQ" }, { 2, "SHIP_PLAN" }, { 3, "SHIP_PLAN… | 데이터 객체 조작/조회 |  |  |  |
| AC-73aef950 | this.Load | SCP0010_Shipment_Plan_SEMI.cs:271 |  | DATA_OP | dicElecInputMeasure.Add | (1, new Dictionary<string, string> { { "SHIP_REQ_QTY", "Ship Req(Cell Qty)" } }) | 데이터 객체 조작/조회 |  |  |  |
| AC-eb100790 | this.Load | SCP0010_Shipment_Plan_SEMI.cs:272 |  | DATA_OP | dicElecInputMeasure.Add | (2, new Dictionary<string, string> { { "SHIP_PLAN_QTY", "Ship Plan(Cell Qty)" } }) | 데이터 객체 조작/조회 |  |  |  |
| AC-e1f3be74 | this.Load | SCP0010_Shipment_Plan_SEMI.cs:273 |  | DATA_OP | dicElecInputMeasure.Add | (3, new Dictionary<string, string> { { "SHIP_PLAN_AMEND_QTY", "Ship Plan Amend(Cell Qty)" … | 데이터 객체 조작/조회 |  |  |  |
| AC-68e921d3 | this.Load | SCP0010_Shipment_Plan_SEMI.cs:275 |  | DATA_OP | dicInputMeasure.Add | ("S", new SortedList<int, string> { { 1, "CHAR_COMPLETED_QTY" }, { 2, "INVENTORY" }, { 3, … | 데이터 객체 조작/조회 |  |  |  |
| AC-6377232e | this.Load | SCP0010_Shipment_Plan_SEMI.cs:277 |  | VALUE_SET | cboBucketType.ControlValues | BucketType.Daily | 컨트롤 값 설정 |  |  |  |

## SCP0010_Shipment_Plan_SEMI.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1c12c2c8 | Dispose | SCP0010_Shipment_Plan_SEMI.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0010_Shipment_Plan_SEMI.EditBlockChecking

진입점: this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName)) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Equals("S")) ▸ try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] / this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName)) ▸ if (MessageHelper.GMessageBox("MSG00016") == DialogResult.Yes) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (result != nul…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6ba8431c | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 5 | SCP0010_Shipment_Plan_SEMI.cs:1731 | if (number == 1) ▸ for (cols <= siMain.ActiveSheet.Columns.Count) | DATA_OP | dateColumn.Contains | ("W_") | 데이터 객체 조작/조회 |  |  |  |
| AC-ab8d7fcc | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 5 | SCP0010_Shipment_Plan_SEMI.cs:1735 | if (number == 1) ▸ for (cols <= siMain.ActiveSheet.Columns.Count) ▸ else of (dateColumn.Contains("W_")) | DATA_OP | dateColumn.Contains | ("D_") | 데이터 객체 조작/조회 |  |  |  |
| AC-e3a15bf4 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 5 | SCP0010_Shipment_Plan_SEMI.cs:1759 | if (number == 1) | RETURN | return retIndex == 0 ? siMain.GetMaxColumnIndex() : retIndex; |  | 처리 중단/반환 |  |  |  |
| AC-b4e841c8 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 5 | SCP0010_Shipment_Plan_SEMI.cs:1768 |  | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |

## SCP0010_Shipment_Plan_SEMI.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f92b63be | EditButton | SCP0010_Shipment_Plan_SEMI.cs:889 | if (fps != null) ▸ if (dsBinding.Tables.Count == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ce9e265b | EditButton | SCP0010_Shipment_Plan_SEMI.cs:891 | if (fps != null) | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-46809019 | EditButton | SCP0010_Shipment_Plan_SEMI.cs:892 | if (fps != null) | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-6c0ed945 | EditButton | SCP0010_Shipment_Plan_SEMI.cs:896 | if (fps != null) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefMain.DIVISION_ID), siMain.nIdxData, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-0000a132 | EditButton | SCP0010_Shipment_Plan_SEMI.cs:902 | if (fps != null) ▸ if (this.IsEditMode && cboBucketType.ControlValues != BucketType.Monthly) ▸ if (EditBlockChecking(2) != 1) | FLAG | _isInsert | true | 화면 필드/플래그 변경 |  |  |  |
| AC-ef409470 | EditButton | SCP0010_Shipment_Plan_SEMI.cs:917 | if (fps != null) ▸ if (this.IsEditMode && cboBucketType.ControlValues != BucketType.Monthly) ▸ else of (EditBlockChecking(2) != 1) | FLAG | _isInsert | false | 화면 필드/플래그 변경 |  |  |  |
| AC-03bb8afb | EditButton | SCP0010_Shipment_Plan_SEMI.cs:918 | if (fps != null) ▸ if (this.IsEditMode && cboBucketType.ControlValues != BucketType.Monthly) ▸ else of (EditBlockChecking(2) != 1) | GRID_LOCK | siMain.LockRange | (0, siMain.nIdxData, siMain.GetMaxRowIndex(), siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-8f3cbdef | EditButton | SCP0010_Shipment_Plan_SEMI.cs:924 | if (fps != null) ▸ else of (this.IsEditMode && cboBucketType.ControlValues != BucketType.Monthly) | FLAG | _isInsert | false | 화면 필드/플래그 변경 |  |  |  |
| AC-af888dcb | EditButton | SCP0010_Shipment_Plan_SEMI.cs:926 | if (fps != null) ▸ else of (this.IsEditMode && cboBucketType.ControlValues != BucketType.Monthly) | GRID_LOCK | siMain.LockRange | (0, siMain.nIdxData, siMain.GetMaxRowIndex(), siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-cebcb2f0 | EditButton | SCP0010_Shipment_Plan_SEMI.cs:935 | if (fps != null) | UI_MISC | spdMain.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## SCP0010_Shipment_Plan_SEMI.ExcelButton

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-65edd288 | ExcelButton | SCP0010_Shipment_Plan_SEMI.cs:950 |  | UI_PROP | exportOption.Merge | ExcelMergeOption.None | 속성 Merge 설정 |  |  |  |
| AC-013c0fc8 | ExcelButton | SCP0010_Shipment_Plan_SEMI.cs:951 |  | UI_PROP | exportOption.Border | ExcelBorderOption.All | 속성 Border 설정 |  |  |  |
| AC-a2483665 | ExcelButton | SCP0010_Shipment_Plan_SEMI.cs:952 |  | UI_PROP | exportOption.AheadZeroOption | ZeroOption.HideZero | 속성 AheadZeroOption 설정 |  |  |  |
| AC-ed270ab9 | ExcelButton | SCP0010_Shipment_Plan_SEMI.cs:953 |  | UI_PROP | exportOption.AmendNullToZero | true | 속성 AmendNullToZero 설정 |  |  |  |
| AC-aa679428 | ExcelButton | SCP0010_Shipment_Plan_SEMI.cs:954 |  | UI_PROP | exportOption.AheadNullToZero | false | 속성 AheadNullToZero 설정 |  |  |  |
| AC-201bff51 | ExcelButton | SCP0010_Shipment_Plan_SEMI.cs:955 |  | UI_PROP | exportOption.AmendZeroOption | ZeroOption.ShowZero | 속성 AmendZeroOption 설정 |  |  |  |
| AC-961f9a03 | ExcelButton | SCP0010_Shipment_Plan_SEMI.cs:957 |  | UI_PROP | exportOption.UserName | UserInfo.UserId | 속성 UserName 설정 |  |  |  |
| AC-b4b0cacb | ExcelButton | SCP0010_Shipment_Plan_SEMI.cs:958 |  | UI_PROP | exportOption.FileName | sFileName | 속성 FileName 설정 |  |  |  |
| AC-9b3faadb | ExcelButton | SCP0010_Shipment_Plan_SEMI.cs:960 |  | UI_PROP | exportOption.AmendDecimalFormat | "#,##0;[Red]-#,##0" | 속성 AmendDecimalFormat 설정 |  |  |  |
| AC-98ad00a4 | ExcelButton | SCP0010_Shipment_Plan_SEMI.cs:965 | try | CALL_EXT | SimplexelService.ExportFpSpread | (fps, exportOption) | ⚠ 의미 확인 필요 |  |  |  |
| AC-20ec9801 | ExcelButton | SCP0010_Shipment_Plan_SEMI.cs:970 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-3ed792d4 | ExcelButton | SCP0010_Shipment_Plan_SEMI.cs:974 | finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCP0010_Shipment_Plan_SEMI.FindData_Main

진입점: this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName)) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Equals("S"))] / this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName)) ▸ if (MessageHelper.GMessageBox("MSG00016") == DialogResult.Yes) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["re…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1b94ea0c | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 4 | SCP0010_Shipment_Plan_SEMI.cs:986 |  | VALIDATE | DataUtil.checkRequired | (this.pnlCondition) | 프레임워크 검증 |  |  |  |
| AC-015c363e | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 4 | SCP0010_Shipment_Plan_SEMI.cs:986 | if (!DataUtil.checkRequired(this.pnlCondition)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ca0c997f | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 4 | SCP0010_Shipment_Plan_SEMI.cs:988 |  | VALIDATE | DateUtil.Check_PeriodDate_New | (dCalendar, "1", "7") | 프레임워크 검증 |  |  |  |
| AC-7efea4c3 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 4 | SCP0010_Shipment_Plan_SEMI.cs:988 | if (!DateUtil.Check_PeriodDate_New(dCalendar, "1", "7")) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d43c36b0 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 4 | SCP0010_Shipment_Plan_SEMI.cs:1014 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-789baa9c | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 4 | SCP0010_Shipment_Plan_SEMI.cs:1017 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-6b369646 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 4 | SCP0010_Shipment_Plan_SEMI.cs:1021 | try | UI_PROP | proxyPivot.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-76dc6972 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 4 | SCP0010_Shipment_Plan_SEMI.cs:1023 | try | FLAG | dsBinding | await proxyPivot.ExecuteAsync<DataSet>(() => { using (var client = new FoxDataClient(CAppS… | 화면 필드/플래그 변경 |  |  |  |
| AC-3e459c61 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 4 | SCP0010_Shipment_Plan_SEMI.cs:1023 | try | ENDPOINT | proxyPivot.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, GSCM_SCP_ANALYS… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-2a8d294d | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 4 | SCP0010_Shipment_Plan_SEMI.cs:1026 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0010_GET_SHIPMENT_PLAN_SEMI") ⇒ SCP.SCP0010_GET_SHIPMENT_PLAN_SEMI | 엔드포인트 요청 생성 |  |  |  |
| AC-890753e6 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 4 | SCP0010_Shipment_Plan_SEMI.cs:1027 | try ▸ lambda | UI_PROP | req.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-977b5135 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 4 | SCP0010_Shipment_Plan_SEMI.cs:1029 | try ▸ lambda | DATA_OP | req.Parameters["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-8cf92810 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 4 | SCP0010_Shipment_Plan_SEMI.cs:1030 | try ▸ lambda | DATA_OP | req.Parameters["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-7c773826 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 4 | SCP0010_Shipment_Plan_SEMI.cs:1031 | try ▸ lambda | DATA_OP | req.Parameters["p_division_id"] | division | 행/컬럼 값 대입 |  |  |  |
| AC-b234c847 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 4 | SCP0010_Shipment_Plan_SEMI.cs:1032 | try ▸ lambda | DATA_OP | req.Parameters["p_operation_group"] | pOperationGroup | 행/컬럼 값 대입 |  |  |  |
| AC-101d08da | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 4 | SCP0010_Shipment_Plan_SEMI.cs:1033 | try ▸ lambda | DATA_OP | req.Parameters["p_item_id"] | p_Item_id | 행/컬럼 값 대입 |  |  |  |
| AC-02510492 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 4 | SCP0010_Shipment_Plan_SEMI.cs:1034 | try ▸ lambda | DATA_OP | req.Parameters["p_electype"] | p_electype | 행/컬럼 값 대입 |  |  |  |
| AC-164f7dd2 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 4 | SCP0010_Shipment_Plan_SEMI.cs:1035 | try ▸ lambda | DATA_OP | req.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-3f749f71 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 4 | SCP0010_Shipment_Plan_SEMI.cs:1036 | try ▸ lambda | DATA_OP | req.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-866cb4a6 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 4 | SCP0010_Shipment_Plan_SEMI.cs:1037 | try ▸ lambda | DATA_OP | req.Parameters["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-494e2f5f | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 4 | SCP0010_Shipment_Plan_SEMI.cs:1038 | try ▸ lambda | DATA_OP | req.Parameters["p_fromsite"] | p_fromsite | 행/컬럼 값 대입 |  |  |  |
| AC-f4715ff5 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 4 | SCP0010_Shipment_Plan_SEMI.cs:1039 | try ▸ lambda | DATA_OP | req.Parameters["p_tosite"] | p_tosite | 행/컬럼 값 대입 |  |  |  |
| AC-a1d4f41a | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 4 | SCP0010_Shipment_Plan_SEMI.cs:1040 | try ▸ lambda | DATA_OP | req.Parameters["p_program_id"] | "SCP0010" | 행/컬럼 값 대입 |  |  |  |
| AC-ed57223f | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 4 | SCP0010_Shipment_Plan_SEMI.cs:1042 | try ▸ lambda | DATA_OP | req.Parameters["p_sheet_name"] | p_sheet_name | 행/컬럼 값 대입 |  |  |  |
| AC-0ab47a49 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 4 | SCP0010_Shipment_Plan_SEMI.cs:1044 | try ▸ lambda | DATA_OP | req.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-45203ce8 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 4 | SCP0010_Shipment_Plan_SEMI.cs:1045 | try ▸ lambda | DATA_OP | req.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-4de3e622 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 4 | SCP0010_Shipment_Plan_SEMI.cs:1047 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-1a15ea0b | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 4 | SCP0010_Shipment_Plan_SEMI.cs:1048 | try ▸ lambda | RETURN | return res.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-93aae0ca | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 4 | SCP0010_Shipment_Plan_SEMI.cs:1064 | try | UI_PROP | dv.Sort | sOrderBy | 속성 Sort 설정 |  |  |  |
| AC-372e3bb3 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 4 | SCP0010_Shipment_Plan_SEMI.cs:1066 | try | DATA_OP | dsSort.Tables.Add | (dv.ToTable()) | 데이터 객체 조작/조회 |  |  |  |
| AC-82a7e163 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 4 | SCP0010_Shipment_Plan_SEMI.cs:1066 | try | DATA_OP | dv.ToTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-f948ce69 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 4 | SCP0010_Shipment_Plan_SEMI.cs:1069 | try | GRID_BIND | siMain.Query | (dsSort) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-698e99e1 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 4 | SCP0010_Shipment_Plan_SEMI.cs:1076 | try ▸ if (dsBinding.Tables[0].Rows.Count > 0) | FLAG | this._IsEditable | GetIsEditable(dsBinding.Tables[1], p_plan_start_yyyymmdd, p_plan_type, p_seq) | 화면 필드/플래그 변경 |  |  |  |
| AC-b412dba4 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 4 | SCP0010_Shipment_Plan_SEMI.cs:1077 | try ▸ if (dsBinding.Tables[0].Rows.Count > 0) | FLAG | this._plan_Start_Date | Convert.ToDateTime(dsBinding.Tables[1].Rows[0]["plan_start_date"]) | 화면 필드/플래그 변경 |  |  |  |
| AC-d8fc82f7 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 4 | SCP0010_Shipment_Plan_SEMI.cs:1078 | try ▸ if (dsBinding.Tables[0].Rows.Count > 0) | FLAG | this._block_idx | EditBlockChecking(1, siMain.nIdxData) | 화면 필드/플래그 변경 |  |  |  |
| AC-0f056fbe | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 4 | SCP0010_Shipment_Plan_SEMI.cs:1097 | try ▸ if (dsBinding.Tables[0].Rows.Count > 0) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-eeb17f23 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 4 | SCP0010_Shipment_Plan_SEMI.cs:1101 | try ▸ if (dsBinding.Tables[0].Rows.Count > 0) | CALL_EXT | siMain.AddRows | (siMain.GetMaxRowIndex() + 1, 1) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b69c9908 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 4 | SCP0010_Shipment_Plan_SEMI.cs:1102 | try ▸ if (dsBinding.Tables[0].Rows.Count > 0) | CALL_EXT | siMain.VisibleRow | (siMain.GetMaxRowIndex(), false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a52e1628 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 4 | SCP0010_Shipment_Plan_SEMI.cs:1103 | try ▸ if (dsBinding.Tables[0].Rows.Count > 0) | GRID_SET | siMain.ActiveSheet.Rows[siMain.ActiveSheet.Rows.Count - 1].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-dbac7c61 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 4 | SCP0010_Shipment_Plan_SEMI.cs:1105 | try ▸ if (dsBinding.Tables[0].Rows.Count > 0) | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8f7fdc7e | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 4 | SCP0010_Shipment_Plan_SEMI.cs:1109 | try ▸ else of (dsBinding.Tables[0].Rows.Count > 0) | GRID_BIND | siMain.Query | (dsBinding) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-60a30b1f | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 4 | SCP0010_Shipment_Plan_SEMI.cs:1112 | try | UI_MISC | SetSearchCount | (dsBinding) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-39555bb9 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 4 | SCP0010_Shipment_Plan_SEMI.cs:1116 | catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-3d5bf30e | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 4 | SCP0010_Shipment_Plan_SEMI.cs:1118 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-2a5978d8 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 4 | SCP0010_Shipment_Plan_SEMI.cs:1122 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-b29ab966 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 4 | SCP0010_Shipment_Plan_SEMI.cs:1123 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## SCP0010_Shipment_Plan_SEMI.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c4088636 | this.Load | SCP0010_Shipment_Plan_SEMI.cs:234 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCP0010_Shipment_Plan_SEMI.Get_IsSaveYn

진입점: this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))] / this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName))] / this.btnNew.Click / SaveButton [if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a6fde5df | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 3 | SCP0010_Shipment_Plan_SEMI.cs:1493 | if (division == null \|\| division.ToString() == "") | RETURN | return saveYn; |  | 처리 중단/반환 |  |  |  |
| AC-ad64b976 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 3 | SCP0010_Shipment_Plan_SEMI.cs:1504 | try | ENDPOINT | new FoxDataRequest | ("SCP.SCP0013_GET_PLAN_TYPE_SAVE_YN") ⇒ SCP.SCP0013_GET_PLAN_TYPE_SAVE_YN | 엔드포인트 요청 생성 |  |  |  |
| AC-56fb8d89 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 3 | SCP0010_Shipment_Plan_SEMI.cs:1505 | try | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-2a5f031d | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 3 | SCP0010_Shipment_Plan_SEMI.cs:1506 | try | DATA_OP | request.Parameters["p_start_yyyymmdd"] | p_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-5759d621 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 3 | SCP0010_Shipment_Plan_SEMI.cs:1507 | try | DATA_OP | request.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-410ce71f | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 3 | SCP0010_Shipment_Plan_SEMI.cs:1509 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-7e1fa3f4 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 3 | SCP0010_Shipment_Plan_SEMI.cs:1519 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-7b98e795 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 3 | SCP0010_Shipment_Plan_SEMI.cs:1524 | if (!saveYn) | MESSAGE | MessageHelper.GMessageBox | ("MSG00182") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c67a4a28 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 3 | SCP0010_Shipment_Plan_SEMI.cs:1526 |  | RETURN | return saveYn; |  | 처리 중단/반환 |  |  |  |

## SCP0010_Shipment_Plan_SEMI.GetBucketType

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a5c425f2 | this.Load | SCP0010_Shipment_Plan_SEMI.cs:1706 |  | ENDPOINT | new FoxDataRequest | ("DM.DM0003_GET_BUCKET_TYPE_CODE") ⇒ DM.DM0003_GET_BUCKET_TYPE_CODE | 엔드포인트 요청 생성 |  |  |  |
| AC-4e2f6dc7 | this.Load | SCP0010_Shipment_Plan_SEMI.cs:1707 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-4498f303 | this.Load | SCP0010_Shipment_Plan_SEMI.cs:1709 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SCP0010_Shipment_Plan_SEMI.GetDayRange

진입점: this.Load / cboPlanDate.SelectedIndexChanged / this.btnW26.Click / this.btnW52.Click / this.btnWLast.Click [if (success)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-349ab0d0 | this.Load 외 4 | SCP0010_Shipment_Plan_SEMI.cs:4669 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCM0001_GET_SCP_DAY_PERIOD") ⇒ SCP.SCM0001_GET_SCP_DAY_PERIOD | 엔드포인트 요청 생성 |  |  |  |
| AC-dfcd1d9b | this.Load 외 4 | SCP0010_Shipment_Plan_SEMI.cs:4670 |  | DATA_OP | request.Parameters["p_from_date"] | p_plan_start_date == null ? "" : p_plan_start_date | 행/컬럼 값 대입 |  |  |  |
| AC-39856945 | this.Load 외 4 | SCP0010_Shipment_Plan_SEMI.cs:4671 |  | DATA_OP | request.Parameters["p_offset_day"] | Convert.ToInt32(periodType) * 7 - 1 | 행/컬럼 값 대입 |  |  |  |
| AC-30ae68d1 | this.Load 외 4 | SCP0010_Shipment_Plan_SEMI.cs:4672 |  | DATA_OP | request.Parameters["p_timezone"] | UserInfoContext.Current[UserInfoProperites.TimeZone] | 행/컬럼 값 대입 |  |  |  |
| AC-27b1ad80 | this.Load 외 4 | SCP0010_Shipment_Plan_SEMI.cs:4673 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-09627489 | this.Load 외 4 | SCP0010_Shipment_Plan_SEMI.cs:4675 |  | RETURN | return sDayRange; |  | 처리 중단/반환 |  |  |  |

## SCP0010_Shipment_Plan_SEMI.GetDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6d8726f7 | (진입점 미연결) | SCP0010_Shipment_Plan_SEMI.cs:4583 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_DIVISION") ⇒ SCM.SCM0001_GET_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-cd7c9975 | (진입점 미연결) | SCP0010_Shipment_Plan_SEMI.cs:4584 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-9aa98add | (진입점 미연결) | SCP0010_Shipment_Plan_SEMI.cs:4586 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SCP0010_Shipment_Plan_SEMI.GetIsEditable

진입점: this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName)) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Equals("S")) ▸ try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] / this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName)) ▸ if (MessageHelper.GMessageBox("MSG00016") == DialogResult.Yes) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (result != nul…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f747bdd3 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 4 | SCP0010_Shipment_Plan_SEMI.cs:1347 | if (isEditTable.Equals("N") \|\| curPlanType.Equals("FN") \|\| curPlanType.Equals("TE")) | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |
| AC-e4755621 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 4 | SCP0010_Shipment_Plan_SEMI.cs:1367 | if (curPlanType.Equals("PR")) | DATA_OP | dtEditable.Select | ("plan_type_seq = '1'") | 데이터 객체 조작/조회 |  |  |  |
| AC-1fb595cb | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 4 | SCP0010_Shipment_Plan_SEMI.cs:1401 | if (curPlanType.Equals("PR")) | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |
| AC-aafa7da4 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 4 | SCP0010_Shipment_Plan_SEMI.cs:1409 | else of (curPlanType.Equals("PR")) ▸ if (curPlanType.Equals("MA")) | DATA_OP | dtEditable.Select | ("plan_type_seq = '2'") | 데이터 객체 조작/조회 |  |  |  |
| AC-72788e8a | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 4 | SCP0010_Shipment_Plan_SEMI.cs:1425 | else of (curPlanType.Equals("PR")) ▸ if (curPlanType.Equals("MA")) ▸ else of (founded.Length > 0) | DATA_OP | dtEditable.Select | ("plan_start_yyyymmdd = '" + curPlanStartYYYYMMDD.ToString() + "' and plan_type= '" + curP… | 데이터 객체 조작/조회 |  |  |  |
| AC-32a11e99 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 4 | SCP0010_Shipment_Plan_SEMI.cs:1439 | else of (curPlanType.Equals("PR")) ▸ if (curPlanType.Equals("MA")) | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |
| AC-6bba7efc | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 4 | SCP0010_Shipment_Plan_SEMI.cs:1446 | else of (curPlanType.Equals("PR")) ▸ else of (curPlanType.Equals("MA")) ▸ if (curPlanType.Equals("SE")) | DATA_OP | dtEditable.Select | ("plan_type_seq = '3'") | 데이터 객체 조작/조회 |  |  |  |
| AC-0ecb5b65 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 4 | SCP0010_Shipment_Plan_SEMI.cs:1476 | else of (curPlanType.Equals("PR")) ▸ else of (curPlanType.Equals("MA")) ▸ if (curPlanType.Equals("SE")) | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |
| AC-b88a9c0d | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 4 | SCP0010_Shipment_Plan_SEMI.cs:1479 |  | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |

## SCP0010_Shipment_Plan_SEMI.GetLastPlanVersion

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ede018c3 | (진입점 미연결) | SCP0010_Shipment_Plan_SEMI.cs:832 | try | UI_PROP | proxyPivot.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-784471a8 | (진입점 미연결) | SCP0010_Shipment_Plan_SEMI.cs:833 | try | ENDPOINT | proxyPivot.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, GSCM_SCP_ANALYS… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-f70beaac | (진입점 미연결) | SCP0010_Shipment_Plan_SEMI.cs:836 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0011_GET_LAST_PLAN_VERSION") ⇒ SCP.SCP0011_GET_LAST_PLAN_VERSION | 엔드포인트 요청 생성 |  |  |  |
| AC-510eddc8 | (진입점 미연결) | SCP0010_Shipment_Plan_SEMI.cs:837 | try ▸ lambda | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-23958d48 | (진입점 미연결) | SCP0010_Shipment_Plan_SEMI.cs:838 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-23ed06ed | (진입점 미연결) | SCP0010_Shipment_Plan_SEMI.cs:839 | try ▸ lambda | RETURN | return res.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-b82d04af | (진입점 미연결) | SCP0010_Shipment_Plan_SEMI.cs:851 | try ▸ if (dsBinding.Tables.Count > 0 && dsBinding.Tables[0].Rows.Count > 0) | VALUE_SET | cboPlanDate.SelectedValue | PLAN_START_YYYYMMDD | 컨트롤 값 설정 |  |  |  |
| AC-12ad736e | (진입점 미연결) | SCP0010_Shipment_Plan_SEMI.cs:852 | try ▸ if (dsBinding.Tables.Count > 0 && dsBinding.Tables[0].Rows.Count > 0) | VALUE_SET | cboPlanType.SelectedValue | PLAN_TYPE | 컨트롤 값 설정 |  |  |  |
| AC-d5d684b6 | (진입점 미연결) | SCP0010_Shipment_Plan_SEMI.cs:853 | try ▸ if (dsBinding.Tables.Count > 0 && dsBinding.Tables[0].Rows.Count > 0) | VALUE_SET | cboPlanSeq.SelectedValue | PLAN_SEQ | 컨트롤 값 설정 |  |  |  |

## SCP0010_Shipment_Plan_SEMI.GetLastRange

진입점: this.Load / cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ebd352cf | this.Load 외 1 | SCP0010_Shipment_Plan_SEMI.cs:4655 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCM0001_GET_SCP_DAILY_PLAN_PERIOD") ⇒ SCP.SCM0001_GET_SCP_DAILY_PLAN_PERIOD | 엔드포인트 요청 생성 |  |  |  |
| AC-1d5f3f88 | this.Load 외 1 | SCP0010_Shipment_Plan_SEMI.cs:4656 |  | DATA_OP | request.Parameters["p_division_id"] | divisionId | 행/컬럼 값 대입 |  |  |  |
| AC-ac196137 | this.Load 외 1 | SCP0010_Shipment_Plan_SEMI.cs:4657 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-bdd83be3 | this.Load 외 1 | SCP0010_Shipment_Plan_SEMI.cs:4659 |  | RETURN | return dailyPlanPeriod; |  | 처리 중단/반환 |  |  |  |

## SCP0010_Shipment_Plan_SEMI.GetNewInsertRowIndex

진입점: this.spdMain.CellClick [if ((e.Column == siMain.GetColumnIndex(DefMain.TRANSPORT_MODE) \|\| e.Column == siMain.GetColumnIndex(DefMain.TO_SITE_DESCRIPT…) ▸ if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (toSite.ToString() == popupToSite)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b12be727 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0010_Shipment_Plan_SEMI.cs:3927 |  | RETURN | return retIndex; |  | 처리 중단/반환 |  |  |  |

## SCP0010_Shipment_Plan_SEMI.GetSpdTitle

진입점: this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK)] / this.Load / this.cboBucketType.SelectedIndexChanged [else of (chkAll.Checked)] / this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName)) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Equals("S"))] / this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName)) ▸ if (MessageHelper.GMessageBox("MSG00016") == DialogResult.Yes) ▸ if (fps.Name == "spdMain") ▸ if (siM…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7cc107c3 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 8 | SCP0010_Shipment_Plan_SEMI.cs:4619 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN") ⇒ SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | 엔드포인트 요청 생성 |  |  |  |
| AC-07aada56 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 8 | SCP0010_Shipment_Plan_SEMI.cs:4620 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-c71e2a6d | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 8 | SCP0010_Shipment_Plan_SEMI.cs:4621 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-343c6b11 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 8 | SCP0010_Shipment_Plan_SEMI.cs:4623 |  | FLAG | dsSpdTitle | client.ExecuteDataSet(request).DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-36661142 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 8 | SCP0010_Shipment_Plan_SEMI.cs:4623 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## SCP0010_Shipment_Plan_SEMI.HandleBindingDataSet

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ceea5252 | (진입점 미연결) | SCP0010_Shipment_Plan_SEMI.cs:1859 |  | DATA_OP | list.Add | ("SHIP_REQ") | 데이터 객체 조작/조회 |  |  |  |
| AC-7ac661a5 | (진입점 미연결) | SCP0010_Shipment_Plan_SEMI.cs:1860 |  | DATA_OP | list.Add | ("SHIP_PLAN") | 데이터 객체 조작/조회 |  |  |  |
| AC-a07a24f6 | (진입점 미연결) | SCP0010_Shipment_Plan_SEMI.cs:1861 |  | DATA_OP | list.Add | ("SHIP_PLAN_AMEND") | 데이터 객체 조작/조회 |  |  |  |
| AC-8bce0961 | (진입점 미연결) | SCP0010_Shipment_Plan_SEMI.cs:1862 |  | DATA_OP | list.Add | ("INVENTORY") | 데이터 객체 조작/조회 |  |  |  |
| AC-a54e7666 | (진입점 미연결) | SCP0010_Shipment_Plan_SEMI.cs:1869 | for (iRow < dtQty.Rows.Count) | DATA_OP | dtBinding.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-af5b1ce4 | (진입점 미연결) | SCP0010_Shipment_Plan_SEMI.cs:1902 | for (iRow < dtQty.Rows.Count) ▸ for (iCol < dtQty.Columns.Count) ▸ if (iCol <= header_idx) ▸ if (iCol == from_site_idx) | DATA_OP | newDr[iCol] | dtQty.Rows[iRow][iCol].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-55db0bfb | (진입점 미연결) | SCP0010_Shipment_Plan_SEMI.cs:1906 | for (iRow < dtQty.Rows.Count) ▸ for (iCol < dtQty.Columns.Count) ▸ if (iCol <= header_idx) ▸ else of (iCol == from_site_idx) ▸ if (iCol == m… | DATA_OP | newDr[iCol] | dtQty.Rows[iRow][iCol].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-f132038c | (진입점 미연결) | SCP0010_Shipment_Plan_SEMI.cs:1912 | for (iRow < dtQty.Rows.Count) ▸ for (iCol < dtQty.Columns.Count) ▸ if (iCol <= header_idx) ▸ else of (iCol == from_site_idx) ▸ else of (iCol… | DATA_OP | newDr[iCol] | dtQty.Rows[iRow][iCol].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-2a88b1f1 | (진입점 미연결) | SCP0010_Shipment_Plan_SEMI.cs:1926 | for (iRow < dtQty.Rows.Count) ▸ for (iCol < dtQty.Columns.Count) ▸ else of (iCol <= header_idx) ▸ if (colName.IndexOf("M_") == 0) ▸ if (Mont… | DATA_OP | newDr[WeekIdx] | WeekSum | 행/컬럼 값 대입 |  |  |  |
| AC-be91c78c | (진입점 미연결) | SCP0010_Shipment_Plan_SEMI.cs:1927 | for (iRow < dtQty.Rows.Count) ▸ for (iCol < dtQty.Columns.Count) ▸ else of (iCol <= header_idx) ▸ if (colName.IndexOf("M_") == 0) ▸ if (Mont… | DATA_OP | newDr[MonthIdx] | MonthSum + WeekSum | 행/컬럼 값 대입 |  |  |  |
| AC-fb672446 | (진입점 미연결) | SCP0010_Shipment_Plan_SEMI.cs:1940 | for (iRow < dtQty.Rows.Count) ▸ for (iCol < dtQty.Columns.Count) ▸ else of (iCol <= header_idx) ▸ else of (colName.IndexOf("M_") == 0) ▸ if … | DATA_OP | newDr[WeekIdx] | WeekSum | 행/컬럼 값 대입 |  |  |  |
| AC-94a956d8 | (진입점 미연결) | SCP0010_Shipment_Plan_SEMI.cs:1941 | for (iRow < dtQty.Rows.Count) ▸ for (iCol < dtQty.Columns.Count) ▸ else of (iCol <= header_idx) ▸ else of (colName.IndexOf("M_") == 0) ▸ if … | DATA_OP | newDr[MonthIdx] | MonthSum + WeekSum | 행/컬럼 값 대입 |  |  |  |
| AC-8b629092 | (진입점 미연결) | SCP0010_Shipment_Plan_SEMI.cs:1959 | for (iRow < dtQty.Rows.Count) ▸ for (iCol < dtQty.Columns.Count) ▸ else of (iCol <= header_idx) ▸ else of (colName.IndexOf("M_") == 0) ▸ els… | DATA_OP | newDr[iCol] | check_value | 행/컬럼 값 대입 |  |  |  |
| AC-1f7eddc9 | (진입점 미연결) | SCP0010_Shipment_Plan_SEMI.cs:1970 | for (iRow < dtQty.Rows.Count) ▸ for (iCol < dtQty.Columns.Count) ▸ if (iCol == dtQty.Columns.Count - 1) ▸ if (MonthSum > 0) | DATA_OP | newDr[MonthIdx] | MonthSum + WeekSum | 행/컬럼 값 대입 |  |  |  |
| AC-699c8514 | (진입점 미연결) | SCP0010_Shipment_Plan_SEMI.cs:1974 | for (iRow < dtQty.Rows.Count) ▸ for (iCol < dtQty.Columns.Count) ▸ if (iCol == dtQty.Columns.Count - 1) ▸ if (WeekSum > 0) | DATA_OP | newDr[WeekIdx] | WeekSum | 행/컬럼 값 대입 |  |  |  |
| AC-7b3efa1d | (진입점 미연결) | SCP0010_Shipment_Plan_SEMI.cs:1977 | for (iRow < dtQty.Rows.Count) ▸ for (iCol < dtQty.Columns.Count) ▸ if (iCol == dtQty.Columns.Count - 1) ▸ if (WeekSum > 0) | DATA_OP | newDr[MonthIdx] | MonthSum | 행/컬럼 값 대입 |  |  |  |
| AC-fa7ae74e | (진입점 미연결) | SCP0010_Shipment_Plan_SEMI.cs:1982 | for (iRow < dtQty.Rows.Count) | DATA_OP | dtBinding.Rows.Add | (newDr) | 데이터 객체 조작/조회 |  |  |  |
| AC-7f635abc | (진입점 미연결) | SCP0010_Shipment_Plan_SEMI.cs:1988 | for (iRow < dtQty.Rows.Count) ▸ if (bef_key_idx != cur_key_idx) ▸ if (bef_key_idx != string.Empty) | CALL_EXT | calc.SetCalcMeasure | (ref dtBinding, key_idx_index, iRow) | ⚠ 의미 확인 필요 |  |  |  |
| AC-373e7ffc | (진입점 미연결) | SCP0010_Shipment_Plan_SEMI.cs:1995 | for (iRow < dtQty.Rows.Count) ▸ if (iRow == dtQty.Rows.Count - 1) | CALL_EXT | calc.SetCalcMeasure | (ref dtBinding, key_idx_index, iRow) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3b0b4577 | (진입점 미연결) | SCP0010_Shipment_Plan_SEMI.cs:2015 |  | DATA_OP | dtBinding.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |

## SCP0010_Shipment_Plan_SEMI.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2b2783c8 | this.Load | SCP0010_Shipment_Plan_SEMI.cs:323 | if (dtDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |
| AC-772fcf2c | this.Load | SCP0010_Shipment_Plan_SEMI.cs:326 |  | DATA_OP | this.ConditionNotUseList.Add | (cboPlanDate) | 데이터 객체 조작/조회 |  |  |  |
| AC-c92e3053 | this.Load | SCP0010_Shipment_Plan_SEMI.cs:327 |  | DATA_OP | this.ConditionNotUseList.Add | (cboPlanType) | 데이터 객체 조작/조회 |  |  |  |
| AC-11f44f5d | this.Load | SCP0010_Shipment_Plan_SEMI.cs:328 |  | DATA_OP | this.ConditionNotUseList.Add | (cboPlanSeq) | 데이터 객체 조작/조회 |  |  |  |
| AC-8ae002b4 | this.Load | SCP0010_Shipment_Plan_SEMI.cs:330 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-88ad5cc8 | this.Load | SCP0010_Shipment_Plan_SEMI.cs:332 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, cboDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-6c020e11 | this.Load | SCP0010_Shipment_Plan_SEMI.cs:337 |  | FLAG | dtElecType | Data.Common(Data.Type.LookupCommon, false, "ELECTRODE_TYPE") ⇒ biz:CommonData.CommonDataList [code=LookupCommon] | 화면 필드/플래그 변경 |  |  |  |
| AC-e68a1596 | this.Load | SCP0010_Shipment_Plan_SEMI.cs:337 |  | COMBO_DATA | Data.Common | (Data.Type.LookupCommon, false, "ELECTRODE_TYPE") ⇒ biz:CommonData.CommonDataList [code=LookupCommon] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-234a3448 | this.Load | SCP0010_Shipment_Plan_SEMI.cs:338 |  | LIST_REBIND | clsCtrl.setListBox | (dtElecType, clbElecType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-d3945e5b | this.Load | SCP0010_Shipment_Plan_SEMI.cs:345 |  | VALUE_SET | dCalendar.InitValue | GetDayRange(PeriodType.W52) | 컨트롤 값 설정 |  |  |  |
| AC-af86b165 | this.Load | SCP0010_Shipment_Plan_SEMI.cs:347 |  | FLAG | dtBucketType | GetBucketType() | 화면 필드/플래그 변경 |  |  |  |
| AC-0d18b3b9 | this.Load | SCP0010_Shipment_Plan_SEMI.cs:348 |  | LIST_REBIND | clsCtrl.setListBox | (dtBucketType, cboBucketType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-e1aeb959 | this.Load | SCP0010_Shipment_Plan_SEMI.cs:358 | if (dailyPlanPeriod == PeriodType.W52) | UI_PROP | layoutControlItem12.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-4e058348 | this.Load | SCP0010_Shipment_Plan_SEMI.cs:361 |  | VALUE_SET | btnWLast.Text | "W" + dailyPlanPeriod | 컨트롤 값 설정 |  |  |  |

## SCP0010_Shipment_Plan_SEMI.InitDictionary

진입점: this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName)) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Equals("S"))] / this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName)) ▸ if (MessageHelper.GMessageBox("MSG00016") == DialogResult.Yes) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["re…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-804040f2 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 4 | SCP0010_Shipment_Plan_SEMI.cs:1776 | foreach (var pair in dicSubSum_Range) | STATE_RESET | dicSubSum_Range.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-0aa5d678 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 4 | SCP0010_Shipment_Plan_SEMI.cs:1781 | foreach (var pair in dicSubSumItems) | CALL_EXT | dicSubSumItems[pair.Key].Clear | () | ⚠ 의미 확인 필요 |  |  |  |

## SCP0010_Shipment_Plan_SEMI.InitSpread

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f07430ba | (진입점 미연결) | SCP0010_Shipment_Plan_SEMI.cs:407 |  | GRID_INIT | spdInfo.InitSheet | (SpdSheet.shtMain) | 그리드 재구성/초기화 |  |  |  |
| AC-038841dd | (진입점 미연결) | SCP0010_Shipment_Plan_SEMI.cs:409 |  | GRID_INIT | spdInfo.AddActionTextBox | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-d5998172 | (진입점 미연결) | SCP0010_Shipment_Plan_SEMI.cs:410 |  | GRID_INIT | spdInfo.AddTextColumn | (DefMainLabel.KEY_IDX, DefMain.KEY_IDX, FPMerge.Restricted, 60, false, FPHAlign.Left, FPVA… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e50f0b63 | (진입점 미연결) | SCP0010_Shipment_Plan_SEMI.cs:411 |  | GRID_INIT | spdInfo.AddTextColumn | (DefMainLabel.DIVISION_ID, DefMain.DIVISION_ID, FPMerge.Restricted, 40, true, FPHAlign.Cen… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-fcefe575 | (진입점 미연결) | SCP0010_Shipment_Plan_SEMI.cs:412 |  | GRID_INIT | spdInfo.AddTextColumn | (DefMainLabel.OPERATION_GROUP_DESC, DefMain.OPERATION_GROUP_DESC, FPMerge.Restricted, 65, … | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0880ab6f | (진입점 미연결) | SCP0010_Shipment_Plan_SEMI.cs:413 |  | GRID_INIT | spdInfo.AddTextColumn | (DefMainLabel.ITEM_ID, DefMain.ITEM_ID, FPMerge.Restricted, 103, true, FPHAlign.Left, FPVA… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-316c530d | (진입점 미연결) | SCP0010_Shipment_Plan_SEMI.cs:414 |  | GRID_INIT | spdInfo.AddTextColumn | (DefMainLabel.NICK_NAME, DefMain.NICK_NAME, FPMerge.Restricted, 65, true, FPHAlign.Left, F… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3198d600 | (진입점 미연결) | SCP0010_Shipment_Plan_SEMI.cs:416 |  | GRID_INIT | spdInfo.AddTextColumn | (DefMainLabel.FROM_SITE_DESCRIPTION, DefMain.FROM_SITE_DESCRIPTION, FPMerge.Restricted, 75… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-137e21ae | (진입점 미연결) | SCP0010_Shipment_Plan_SEMI.cs:417 |  | GRID_INIT | spdInfo.AddNumColumn | (DefMainLabel.BOH, DefMain.BOH, FPMerge.Restricted, 75, true, FPHAlign.Right, FPVAlign.Cen… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-98199440 | (진입점 미연결) | SCP0010_Shipment_Plan_SEMI.cs:418 |  | GRID_INIT | spdInfo.AddTextColumn | (DefMainLabel.T0_SITE_DESCRIPTION, DefMain.TO_SITE_DESCRIPTION, FPMerge.Restricted, 65, tr… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-727a1b40 | (진입점 미연결) | SCP0010_Shipment_Plan_SEMI.cs:419 |  | GRID_INIT | spdInfo.AddTextColumn | (DefMainLabel.TRANSPORT_MODE, DefMain.TRANSPORT_MODE, FPMerge.Restricted, 40, true, FPHAli… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ae5fa170 | (진입점 미연결) | SCP0010_Shipment_Plan_SEMI.cs:420 |  | GRID_INIT | spdInfo.AddTextColumn | (DefMainLabel.LT_DAY, DefMain.LT_DAY, FPMerge.Restricted, 40, true, FPHAlign.Right, FPVAli… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6f0e3ff1 | (진입점 미연결) | SCP0010_Shipment_Plan_SEMI.cs:422 |  | GRID_INIT | spdInfo.AddTextColumn | (DefMainLabel.MEASURE_LABEL, DefMain.MEASURE_LABEL, FPMerge.Restricted, 110, true, FPHAlig… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ba9463c0 | (진입점 미연결) | SCP0010_Shipment_Plan_SEMI.cs:423 |  | GRID_INIT | spdInfo.AddTextColumn | (DefMainLabel.MEASURE, DefMain.MEASURE, FPMerge.Restricted, 80, false, FPHAlign.Left, FPVA… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-db79e2d9 | (진입점 미연결) | SCP0010_Shipment_Plan_SEMI.cs:424 |  | GRID_INIT | spdInfo.AddTextColumn | (DefMainLabel.DIVISION_NAME, DefMain.DIVISION_NAME, FPMerge.Restricted, 60, false, FPHAlig… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-dba8866b | (진입점 미연결) | SCP0010_Shipment_Plan_SEMI.cs:425 |  | GRID_INIT | spdInfo.AddTextColumn | (DefMainLabel.OPERATION_GROUP, DefMain.OPERATION_GROUP, FPMerge.Restricted, 90, false, FPH… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f847ed63 | (진입점 미연결) | SCP0010_Shipment_Plan_SEMI.cs:426 |  | GRID_INIT | spdInfo.AddTextColumn | (DefMainLabel.FROM_SITE, DefMain.FROM_SITE, FPMerge.Restricted, 110, false, FPHAlign.Left,… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-60a8b87a | (진입점 미연결) | SCP0010_Shipment_Plan_SEMI.cs:428 |  | GRID_INIT | spdInfo.AddTextColumn | (DefMainLabel.TO_SITE, DefMain.TO_SITE, FPMerge.Restricted, 110, false, FPHAlign.Left, FPV… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-74f4dd78 | (진입점 미연결) | SCP0010_Shipment_Plan_SEMI.cs:429 |  | GRID_INIT | spdInfo.AddTextColumn | (DefMainLabel.BOD_ID, DefMain.BOD_ID, FPMerge.Restricted, 110, false, FPHAlign.Right, FPVA… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-566c4079 | (진입점 미연결) | SCP0010_Shipment_Plan_SEMI.cs:430 |  | GRID_INIT | spdInfo.AddTextColumn | (DefMainLabel.MEASURE_ORDER_NO, DefMain.MEASURE_ORDER_NO, FPMerge.Restricted, 140, false, … | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-89a456a6 | (진입점 미연결) | SCP0010_Shipment_Plan_SEMI.cs:431 |  | GRID_INIT | spdInfo.AddDateColumn | (DefMainLabel.SHIP_FROZEN, DefMain.SHIP_FROZEN, FPMerge.Restricted, 90, false, FPHAlign.Le… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5ada1252 | (진입점 미연결) | SCP0010_Shipment_Plan_SEMI.cs:432 |  | GRID_INIT | spdInfo.AddTextColumn | (DefMainLabel.FROM_YYYYMMDD, DefMain.FROM_YYYYMMDD, FPMerge.Restricted, 140, false, FPHAli… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a69d6d23 | (진입점 미연결) | SCP0010_Shipment_Plan_SEMI.cs:434 |  | GRID_INIT | spdInfo.AddTextColumn | (DefMainLabel.TO_YYYYMMDD, DefMain.TO_YYYYMMDD, FPMerge.Restricted, 140, false, FPHAlign.C… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ca80ebcb | (진입점 미연결) | SCP0010_Shipment_Plan_SEMI.cs:437 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, 0, 3, 1, 20, " ", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c98679f3 | (진입점 미연결) | SCP0010_Shipment_Plan_SEMI.cs:438 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefMain.KEY_IDX), 3, 1, 20, DefMainLabel.KEY_IDX, FPHAlign.Cente… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1396da41 | (진입점 미연결) | SCP0010_Shipment_Plan_SEMI.cs:439 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefMain.DIVISION_ID), 3, 1, 20, DefMainLabel.DIVISION_ID, FPHAli… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c1aca9c4 | (진입점 미연결) | SCP0010_Shipment_Plan_SEMI.cs:440 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefMain.DIVISION_NAME), 3, 1, 20, DefMainLabel.DIVISION_NAME, FP… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-39ccfa60 | (진입점 미연결) | SCP0010_Shipment_Plan_SEMI.cs:441 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefMain.OPERATION_GROUP), 3, 1, 20, DefMainLabel.OPERATION_GROUP… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f16102c9 | (진입점 미연결) | SCP0010_Shipment_Plan_SEMI.cs:442 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefMain.OPERATION_GROUP_DESC), 3, 1, 20, DefMainLabel.OPERATION_… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-951c2c56 | (진입점 미연결) | SCP0010_Shipment_Plan_SEMI.cs:443 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefMain.ITEM_ID), 3, 1, 20, DefMainLabel.ITEM_ID, FPHAlign.Cente… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-43922263 | (진입점 미연결) | SCP0010_Shipment_Plan_SEMI.cs:444 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefMain.NICK_NAME), 3, 1, 20, DefMainLabel.NICK_NAME, FPHAlign.C… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f7255683 | (진입점 미연결) | SCP0010_Shipment_Plan_SEMI.cs:445 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefMain.FROM_SITE), 3, 1, 20, DefMainLabel.FROM_SITE, FPHAlign.C… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ee4bf034 | (진입점 미연결) | SCP0010_Shipment_Plan_SEMI.cs:446 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefMain.FROM_SITE_DESCRIPTION), 3, 1, 20, DefMainLabel.FROM_SITE… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e8623a45 | (진입점 미연결) | SCP0010_Shipment_Plan_SEMI.cs:447 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefMain.BOH), 3, 1, 20, DefMainLabel.BOH, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8350f09d | (진입점 미연결) | SCP0010_Shipment_Plan_SEMI.cs:448 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefMain.TO_SITE), 3, 1, 20, DefMainLabel.TO_SITE, FPHAlign.Cente… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-00719c03 | (진입점 미연결) | SCP0010_Shipment_Plan_SEMI.cs:449 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefMain.TO_SITE_DESCRIPTION), 3, 1, 20, DefMainLabel.T0_SITE_DES… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-36bf80ef | (진입점 미연결) | SCP0010_Shipment_Plan_SEMI.cs:450 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefMain.TRANSPORT_MODE), 3, 1, 20, DefMainLabel.TRANSPORT_MODE, … | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b6c9b770 | (진입점 미연결) | SCP0010_Shipment_Plan_SEMI.cs:451 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefMain.LT_DAY), 3, 1, 20, DefMainLabel.LT_DAY, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d02afb3d | (진입점 미연결) | SCP0010_Shipment_Plan_SEMI.cs:452 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefMain.MEASURE_LABEL), 3, 1, 20, DefMainLabel.MEASURE_LABEL, FP… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-913c82b9 | (진입점 미연결) | SCP0010_Shipment_Plan_SEMI.cs:453 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefMain.MEASURE), 3, 1, 20, DefMainLabel.MEASURE, FPHAlign.Cente… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ea8ca5dd | (진입점 미연결) | SCP0010_Shipment_Plan_SEMI.cs:454 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefMain.MEASURE_ORDER_NO), 3, 1, 20, DefMainLabel.MEASURE_ORDER_… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-04422b70 | (진입점 미연결) | SCP0010_Shipment_Plan_SEMI.cs:455 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefMain.SHIP_FROZEN), 3, 1, 20, DefMainLabel.SHIP_FROZEN, FPHAli… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3aa4e7d2 | (진입점 미연결) | SCP0010_Shipment_Plan_SEMI.cs:456 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefMain.FROM_YYYYMMDD), 3, 1, 20, DefMainLabel.FROM_YYYYMMDD, FP… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7c56aaca | (진입점 미연결) | SCP0010_Shipment_Plan_SEMI.cs:457 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefMain.TO_YYYYMMDD), 3, 1, 20, DefMainLabel.TO_YYYYMMDD, FPHAli… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c888e827 | (진입점 미연결) | SCP0010_Shipment_Plan_SEMI.cs:465 |  | GRID_INIT | siMain.Freeze | (0, siMain.GetColumnIndex(DefMain.MEASURE_LABEL) + 1) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-2010c42b | (진입점 미연결) | SCP0010_Shipment_Plan_SEMI.cs:466 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0010_Shipment_Plan_SEMI.InitSpread_2

진입점: this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK)] / this.Load / this.cboBucketType.SelectedIndexChanged [else of (chkAll.Checked)] / this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName)) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Equals("S"))] / this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName)) ▸ if (MessageHelper.GMessageBox("MSG00016") == DialogResult.Yes) ▸ if (fps.Name == "spdMain") ▸ if (siM…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4ac24fc0 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | SCP0010_Shipment_Plan_SEMI.cs:377 |  | GRID_INIT | spdInfo.InitSheet | (SpdSheet.shtMain) | 그리드 재구성/초기화 |  |  |  |
| AC-187cbe1d | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | SCP0010_Shipment_Plan_SEMI.cs:381 |  | GRID_INIT | siMain.SetSheetHeaderColumn | (spdInfo, 3) | 그리드 재구성/초기화 |  |  |  |
| AC-46564062 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | SCP0010_Shipment_Plan_SEMI.cs:385 |  | GRID_SET | siMain.ActiveSheet.ColumnHeader.Columns[siMain.GetColumnIndex(DefMain.TO_SITE_DESCRIPTION)… | new Font(spdMain.Font.Name, spdMain.Font.Size, FontStyle.Bold) | 그리드 속성/값 설정 |  |  |  |
| AC-ba87f827 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | SCP0010_Shipment_Plan_SEMI.cs:386 |  | GRID_SET | siMain.ActiveSheet.ColumnHeader.Columns[siMain.GetColumnIndex(DefMain.TRANSPORT_MODE)].Fon… | new Font(spdMain.Font.Name, spdMain.Font.Size, FontStyle.Bold) | 그리드 속성/값 설정 |  |  |  |
| AC-5fd51806 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | SCP0010_Shipment_Plan_SEMI.cs:389 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ba107d92 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | SCP0010_Shipment_Plan_SEMI.cs:393 | if (!division.Substring(0, 2).Equals("EE")) | GRID_SET | spdInfo.ActiveSheet.Columns[siMain.GetColumnIndex("ELECTRODE_TYPE")].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-34592f79 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | SCP0010_Shipment_Plan_SEMI.cs:394 | if (!division.Substring(0, 2).Equals("EE")) | GRID_SET | spdInfo.ActiveSheet.Columns[siMain.GetColumnIndex("ORIGIN_FROM_DIVISION_ID")].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-ed89ab37 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | SCP0010_Shipment_Plan_SEMI.cs:395 | if (!division.Substring(0, 2).Equals("EE")) | GRID_SET | spdInfo.ActiveSheet.Columns[siMain.GetColumnIndex("ORIGIN_TO_DIVISION_ID")].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-88cae164 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | SCP0010_Shipment_Plan_SEMI.cs:399 | else of (!division.Substring(0, 2).Equals("EE")) | GRID_SET | spdInfo.ActiveSheet.Columns[siMain.GetColumnIndex("ELECTRODE_TYPE")].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-1795db3f | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | SCP0010_Shipment_Plan_SEMI.cs:400 | else of (!division.Substring(0, 2).Equals("EE")) | GRID_SET | spdInfo.ActiveSheet.Columns[siMain.GetColumnIndex("ORIGIN_FROM_DIVISION_ID")].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-2a628345 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | SCP0010_Shipment_Plan_SEMI.cs:401 | else of (!division.Substring(0, 2).Equals("EE")) | GRID_SET | spdInfo.ActiveSheet.Columns[siMain.GetColumnIndex("ORIGIN_TO_DIVISION_ID")].Visible | true | 그리드 속성/값 설정 |  |  |  |

## SCP0010_Shipment_Plan_SEMI.InitSpreadDateColumn

진입점: this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK)] / this.Load / this.cboBucketType.SelectedIndexChanged [else of (chkAll.Checked)] / this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName)) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Equals("S"))] / this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName)) ▸ if (MessageHelper.GMessageBox("MSG00016") == DialogResult.Yes) ▸ if (fps.Name == "spdMain") ▸ if (siM…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a92db078 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 8 | SCP0010_Shipment_Plan_SEMI.cs:502 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sColumnName.IndexOf("B_") > 0) | GRID_INIT | spdInfo.AddTextColumn | (sColumnLabelname, sColumnName, FPMerge.None, 0, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-666f519d | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 8 | SCP0010_Shipment_Plan_SEMI.cs:503 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sColumnName.IndexOf("B_") > 0) | GRID_INIT | spdInfo.SetReNumerCellType | (spdInfo, spdInfo.GetColumnIndex(sColumnName), -9999999999, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-5371eece | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 8 | SCP0010_Shipment_Plan_SEMI.cs:507 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sColumnName.IndexOf("B_") > 0) | GRID_INIT | spdInfo.AddNumColumn | (sColumnLabelname, sColumnName, FPMerge.None, 70, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-16463f8a | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 8 | SCP0010_Shipment_Plan_SEMI.cs:508 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sColumnName.IndexOf("B_") > 0) | GRID_INIT | spdInfo.SetReNumerCellType | (spdInfo, spdInfo.GetColumnIndex(sColumnName), -9999999999, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-6dbb51e9 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 8 | SCP0010_Shipment_Plan_SEMI.cs:512 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sColumnName.IndexOf("B_") > 0) ▸ if (sDayCode == DefMainLabel.Saturday \|\| sDa… | GRID_SET | spdInfo.Sheet().ColumnHeader.Cells[2, spdInfo.GetMaxColumnIndex()].ForeColor | sDayCode == DefMainLabel.Saturday ? Color.Blue : Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-b8aa17bc | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 8 | SCP0010_Shipment_Plan_SEMI.cs:519 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ab15f8a0 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 8 | SCP0010_Shipment_Plan_SEMI.cs:520 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9e06dac0 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 8 | SCP0010_Shipment_Plan_SEMI.cs:525 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-29c95186 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 8 | SCP0010_Shipment_Plan_SEMI.cs:526 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 30, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c085575a | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 8 | SCP0010_Shipment_Plan_SEMI.cs:534 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName != sSmallLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f1789639 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 8 | SCP0010_Shipment_Plan_SEMI.cs:535 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName != sSmallLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b82d9e6d | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 8 | SCP0010_Shipment_Plan_SEMI.cs:545 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3a245542 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 8 | SCP0010_Shipment_Plan_SEMI.cs:546 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-739da304 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 8 | SCP0010_Shipment_Plan_SEMI.cs:547 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2c9c30b0 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 8 | SCP0010_Shipment_Plan_SEMI.cs:548 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0010_Shipment_Plan_SEMI.InsertRow

진입점: this.spdMain.CellClick [if ((e.Column == siMain.GetColumnIndex(DefMain.TRANSPORT_MODE) \|\| e.Column == siMain.GetColumnIndex(DefMain.TO_SITE_DESCRIPT…)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bf3a33c1 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0010_Shipment_Plan_SEMI.cs:3612 | if (siMain.Sheet().Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-28eedc76 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0010_Shipment_Plan_SEMI.cs:3636 |  | DATA_OP | dsBinding.Tables[0].Select() .Where(c => c[DefMain.DIVISION_ID].ToString() == division.ToS… | () | 데이터 객체 조작/조회 |  |  |  |
| AC-c468f75d | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0010_Shipment_Plan_SEMI.cs:3636 |  | DATA_OP | dsBinding.Tables[0].Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-9b41a092 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0010_Shipment_Plan_SEMI.cs:3644 |  | DATA_OP | dsBinding.Tables[0].Select() .Where(c => c[DefMain.DIVISION_ID].ToString() == division.ToS… | () | 데이터 객체 조작/조회 |  |  |  |
| AC-c12c296b | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0010_Shipment_Plan_SEMI.cs:3644 |  | DATA_OP | dsBinding.Tables[0].Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-eec4fe0f | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0010_Shipment_Plan_SEMI.cs:3654 |  | POPUP | new SCM0002_GetBODPopup | (dtCaller, 1, this._plan_Start_Date) | 팝업/폼 생성 |  |  |  |
| AC-83a98377 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0010_Shipment_Plan_SEMI.cs:3655 |  | UI_PROP | popup.Width | 1050 | 속성 Width 설정 |  |  |  |
| AC-fee23b19 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0010_Shipment_Plan_SEMI.cs:3656 |  | UI_PROP | popup.Height | 350 | 속성 Height 설정 |  |  |  |
| AC-091898f3 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0010_Shipment_Plan_SEMI.cs:3657 |  | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-e7d0394f | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0010_Shipment_Plan_SEMI.cs:3661 |  | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-f2a9918f | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0010_Shipment_Plan_SEMI.cs:3665 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (popup.retList.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e82d3f77 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0010_Shipment_Plan_SEMI.cs:3678 | if (popup.ShowDialog() == DialogResult.OK) | DATA_OP | dtCaller2.DefaultView.ToTable | (true, distinct) | 데이터 객체 조작/조회 |  |  |  |
| AC-e76eab74 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0010_Shipment_Plan_SEMI.cs:3697 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (toSite.ToString() == popupToSite) | DATA_OP | dt2.Select().Where(c => c[DefMain.MEASURE].ToString().Contains("SHIP")).CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-1b80ae5d | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0010_Shipment_Plan_SEMI.cs:3697 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (toSite.ToString() == popupToSite) | DATA_OP | dt2.Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-fd112282 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0010_Shipment_Plan_SEMI.cs:3697 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (toSite.ToString() == popupToSite) ▸ lambda | DATA_OP | c[DefMain.MEASURE].ToString().Contains | ("SHIP") | 데이터 객체 조작/조회 |  |  |  |
| AC-e790c5f4 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0010_Shipment_Plan_SEMI.cs:3701 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (toSite.ToString() == popupToSite) ▸ foreach (DataRow d… | CALL_EXT | siMain.InsertNewRow | (insertStartIdx) | ⚠ 의미 확인 필요 |  |  |  |
| AC-649a1a3d | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0010_Shipment_Plan_SEMI.cs:3703 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (toSite.ToString() == popupToSite) ▸ foreach (DataRow d… | DATA_OP | defaultData.Add | (DefMain.KEY_IDX, dr[DefMain.KEY_IDX]) | 데이터 객체 조작/조회 |  |  |  |
| AC-cb53f88f | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0010_Shipment_Plan_SEMI.cs:3704 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (toSite.ToString() == popupToSite) ▸ foreach (DataRow d… | DATA_OP | defaultData.Add | (DefMain.DIVISION_ID, dr[DefMain.DIVISION_ID]) | 데이터 객체 조작/조회 |  |  |  |
| AC-be7c8a68 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0010_Shipment_Plan_SEMI.cs:3705 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (toSite.ToString() == popupToSite) ▸ foreach (DataRow d… | DATA_OP | defaultData.Add | (DefMain.OPERATION_GROUP_DESC, dr[DefMain.OPERATION_GROUP_DESC]) | 데이터 객체 조작/조회 |  |  |  |
| AC-74c6a132 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0010_Shipment_Plan_SEMI.cs:3706 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (toSite.ToString() == popupToSite) ▸ foreach (DataRow d… | DATA_OP | defaultData.Add | (DefMain.ITEM_ID, dr[DefMain.ITEM_ID]) | 데이터 객체 조작/조회 |  |  |  |
| AC-e354c152 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0010_Shipment_Plan_SEMI.cs:3707 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (toSite.ToString() == popupToSite) ▸ foreach (DataRow d… | DATA_OP | defaultData.Add | (DefMain.NICK_NAME, dr[DefMain.NICK_NAME]) | 데이터 객체 조작/조회 |  |  |  |
| AC-718bd983 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0010_Shipment_Plan_SEMI.cs:3710 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (toSite.ToString() == popupToSite) ▸ foreach (DataRow d… | DATA_OP | defaultData.Add | (DefMain.ELECTRODE_TYPE, dtCaller.Rows[0]["ELECTRODE_TYPE"]) | 데이터 객체 조작/조회 |  |  |  |
| AC-f1b94ba1 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0010_Shipment_Plan_SEMI.cs:3713 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (toSite.ToString() == popupToSite) ▸ foreach (DataRow d… | DATA_OP | defaultData.Add | (DefMain.ORIGIN_FROM_DIVISION_ID, dtCaller.Rows[0]["ORIGIN_FROM_DIVISION_ID"]) | 데이터 객체 조작/조회 |  |  |  |
| AC-7eec3189 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0010_Shipment_Plan_SEMI.cs:3715 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (toSite.ToString() == popupToSite) ▸ foreach (DataRow d… | DATA_OP | defaultData.Add | (DefMain.FROM_SITE_DESCRIPTION, bod.first_site_name) | 데이터 객체 조작/조회 |  |  |  |
| AC-36df02ed | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0010_Shipment_Plan_SEMI.cs:3716 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (toSite.ToString() == popupToSite) ▸ foreach (DataRow d… | DATA_OP | defaultData.Add | (DefMain.BOH, dr[DefMain.BOH]) | 데이터 객체 조작/조회 |  |  |  |
| AC-e19a1163 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0010_Shipment_Plan_SEMI.cs:3719 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (toSite.ToString() == popupToSite) ▸ foreach (DataRow d… | DATA_OP | defaultData.Add | (DefMain.ORIGIN_TO_DIVISION_ID, dtCaller.Rows[0]["ORIGIN_TO_DIVISION_ID"]) | 데이터 객체 조작/조회 |  |  |  |
| AC-af23bcd6 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0010_Shipment_Plan_SEMI.cs:3721 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (toSite.ToString() == popupToSite) ▸ foreach (DataRow d… | DATA_OP | defaultData.Add | (DefMain.TO_SITE_DESCRIPTION, bod.second_site_name) | 데이터 객체 조작/조회 |  |  |  |
| AC-5ee0bbac | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0010_Shipment_Plan_SEMI.cs:3722 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (toSite.ToString() == popupToSite) ▸ foreach (DataRow d… | DATA_OP | defaultData.Add | (DefMain.TRANSPORT_MODE, bod.transport_mode) | 데이터 객체 조작/조회 |  |  |  |
| AC-3dc9993f | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0010_Shipment_Plan_SEMI.cs:3723 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (toSite.ToString() == popupToSite) ▸ foreach (DataRow d… | DATA_OP | defaultData.Add | (DefMain.LT_DAY, bod.lt_total) | 데이터 객체 조작/조회 |  |  |  |
| AC-f1b55c91 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0010_Shipment_Plan_SEMI.cs:3725 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (toSite.ToString() == popupToSite) ▸ foreach (DataRow d… | DATA_OP | defaultData.Add | (DefMain.MEASURE_LABEL, dr[DefMain.MEASURE_LABEL]) | 데이터 객체 조작/조회 |  |  |  |
| AC-3e7a7bad | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0010_Shipment_Plan_SEMI.cs:3726 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (toSite.ToString() == popupToSite) ▸ foreach (DataRow d… | DATA_OP | defaultData.Add | (DefMain.MEASURE, dr[DefMain.MEASURE]) | 데이터 객체 조작/조회 |  |  |  |
| AC-1a5a7c34 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0010_Shipment_Plan_SEMI.cs:3727 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (toSite.ToString() == popupToSite) ▸ foreach (DataRow d… | DATA_OP | defaultData.Add | (DefMain.DIVISION_NAME, dr[DefMain.DIVISION_NAME]) | 데이터 객체 조작/조회 |  |  |  |
| AC-43d142a3 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0010_Shipment_Plan_SEMI.cs:3728 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (toSite.ToString() == popupToSite) ▸ foreach (DataRow d… | DATA_OP | defaultData.Add | (DefMain.OPERATION_GROUP, dr[DefMain.OPERATION_GROUP]) | 데이터 객체 조작/조회 |  |  |  |
| AC-ef870442 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0010_Shipment_Plan_SEMI.cs:3730 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (toSite.ToString() == popupToSite) ▸ foreach (DataRow d… | DATA_OP | defaultData.Add | (DefMain.FROM_SITE, bod.first_site) | 데이터 객체 조작/조회 |  |  |  |
| AC-63c5130b | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0010_Shipment_Plan_SEMI.cs:3731 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (toSite.ToString() == popupToSite) ▸ foreach (DataRow d… | DATA_OP | defaultData.Add | (DefMain.TO_SITE, bod.second_site) | 데이터 객체 조작/조회 |  |  |  |
| AC-0c0a7e09 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0010_Shipment_Plan_SEMI.cs:3732 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (toSite.ToString() == popupToSite) ▸ foreach (DataRow d… | DATA_OP | defaultData.Add | (DefMain.BOD_ID, bod.bod_id) | 데이터 객체 조작/조회 |  |  |  |
| AC-c58f8925 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0010_Shipment_Plan_SEMI.cs:3734 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (toSite.ToString() == popupToSite) ▸ foreach (DataRow d… | DATA_OP | defaultData.Add | (DefMain.MEASURE_ORDER_NO, dr[DefMain.MEASURE_ORDER_NO]) | 데이터 객체 조작/조회 |  |  |  |
| AC-3185ae3a | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0010_Shipment_Plan_SEMI.cs:3735 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (toSite.ToString() == popupToSite) ▸ foreach (DataRow d… | DATA_OP | defaultData.Add | (DefMain.SHIP_FROZEN, bod.ship_frozen) | 데이터 객체 조작/조회 |  |  |  |
| AC-866c5aa3 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0010_Shipment_Plan_SEMI.cs:3736 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (toSite.ToString() == popupToSite) ▸ foreach (DataRow d… | DATA_OP | defaultData.Add | (DefMain.FROM_YYYYMMDD, dr[DefMain.FROM_YYYYMMDD]) | 데이터 객체 조작/조회 |  |  |  |
| AC-28f2307b | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0010_Shipment_Plan_SEMI.cs:3737 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (toSite.ToString() == popupToSite) ▸ foreach (DataRow d… | DATA_OP | defaultData.Add | (DefMain.TO_YYYYMMDD, dr[DefMain.TO_YYYYMMDD]) | 데이터 객체 조작/조회 |  |  |  |
| AC-29226345 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0010_Shipment_Plan_SEMI.cs:3738 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (toSite.ToString() == popupToSite) ▸ foreach (DataRow d… | DATA_OP | defaultData.Add | (DefMain.BOD_FROM_YYYYMMDD, bod.bod_from_yyyymmdd) | 데이터 객체 조작/조회 |  |  |  |
| AC-cca6422c | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0010_Shipment_Plan_SEMI.cs:3739 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (toSite.ToString() == popupToSite) ▸ foreach (DataRow d… | DATA_OP | defaultData.Add | (DefMain.BOD_TO_YYYYMMDD, bod.bod_to_yyyymmdd) | 데이터 객체 조작/조회 |  |  |  |
| AC-15ccd7bc | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0010_Shipment_Plan_SEMI.cs:3740 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (toSite.ToString() == popupToSite) ▸ foreach (DataRow d… | GRID_SET | siMain.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |
| AC-597e0e8e | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0010_Shipment_Plan_SEMI.cs:3751 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (toSite.ToString() == popupToSite) | DATA_OP | dt2.Select().Where(c => c[DefMain.MEASURE].ToString().Contains("SHIP")).CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-580e7422 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0010_Shipment_Plan_SEMI.cs:3751 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (toSite.ToString() == popupToSite) | DATA_OP | dt2.Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-eae85f6c | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0010_Shipment_Plan_SEMI.cs:3751 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (toSite.ToString() == popupToSite) ▸ lambda | DATA_OP | c[DefMain.MEASURE].ToString().Contains | ("SHIP") | 데이터 객체 조작/조회 |  |  |  |
| AC-fb2ce3c3 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0010_Shipment_Plan_SEMI.cs:3759 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (toSite.ToString() == popupToSite) ▸ foreach (Data… | CALL_EXT | siMain.InsertNewRow | (insertStartIdx) | ⚠ 의미 확인 필요 |  |  |  |
| AC-8edb8f67 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0010_Shipment_Plan_SEMI.cs:3761 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (toSite.ToString() == popupToSite) ▸ foreach (Data… | DATA_OP | defaultData.Add | (DefMain.KEY_IDX, dr[DefMain.KEY_IDX]) | 데이터 객체 조작/조회 |  |  |  |
| AC-22a603ea | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0010_Shipment_Plan_SEMI.cs:3762 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (toSite.ToString() == popupToSite) ▸ foreach (Data… | DATA_OP | defaultData.Add | (DefMain.DIVISION_ID, dr[DefMain.DIVISION_ID]) | 데이터 객체 조작/조회 |  |  |  |
| AC-d6ab3880 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0010_Shipment_Plan_SEMI.cs:3763 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (toSite.ToString() == popupToSite) ▸ foreach (Data… | DATA_OP | defaultData.Add | (DefMain.OPERATION_GROUP_DESC, dr[DefMain.OPERATION_GROUP_DESC]) | 데이터 객체 조작/조회 |  |  |  |
| AC-d514ffc2 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0010_Shipment_Plan_SEMI.cs:3764 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (toSite.ToString() == popupToSite) ▸ foreach (Data… | DATA_OP | defaultData.Add | (DefMain.ITEM_ID, dr[DefMain.ITEM_ID]) | 데이터 객체 조작/조회 |  |  |  |
| AC-7d65a36a | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0010_Shipment_Plan_SEMI.cs:3765 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (toSite.ToString() == popupToSite) ▸ foreach (Data… | DATA_OP | defaultData.Add | (DefMain.NICK_NAME, dr[DefMain.NICK_NAME]) | 데이터 객체 조작/조회 |  |  |  |
| AC-dc98c49d | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0010_Shipment_Plan_SEMI.cs:3768 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (toSite.ToString() == popupToSite) ▸ foreach (Data… | DATA_OP | defaultData.Add | (DefMain.ELECTRODE_TYPE, dtCaller.Rows[0]["ELECTRODE_TYPE"]) | 데이터 객체 조작/조회 |  |  |  |
| AC-51af5c3c | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0010_Shipment_Plan_SEMI.cs:3771 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (toSite.ToString() == popupToSite) ▸ foreach (Data… | DATA_OP | defaultData.Add | (DefMain.ORIGIN_FROM_DIVISION_ID, dtCaller.Rows[0]["ORIGIN_FROM_DIVISION_ID"]) | 데이터 객체 조작/조회 |  |  |  |
| AC-137e8ada | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0010_Shipment_Plan_SEMI.cs:3773 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (toSite.ToString() == popupToSite) ▸ foreach (Data… | DATA_OP | defaultData.Add | (DefMain.FROM_SITE_DESCRIPTION, bod.first_site_name) | 데이터 객체 조작/조회 |  |  |  |
| AC-7de48992 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0010_Shipment_Plan_SEMI.cs:3774 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (toSite.ToString() == popupToSite) ▸ foreach (Data… | DATA_OP | defaultData.Add | (DefMain.BOH, dr[DefMain.BOH]) | 데이터 객체 조작/조회 |  |  |  |
| AC-4e0f70c3 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0010_Shipment_Plan_SEMI.cs:3777 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (toSite.ToString() == popupToSite) ▸ foreach (Data… | DATA_OP | defaultData.Add | (DefMain.ORIGIN_TO_DIVISION_ID, dtCaller.Rows[0]["ORIGIN_TO_DIVISION_ID"]) | 데이터 객체 조작/조회 |  |  |  |
| AC-d9f43253 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0010_Shipment_Plan_SEMI.cs:3780 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (toSite.ToString() == popupToSite) ▸ foreach (Data… | DATA_OP | dr[DefMain.MEASURE].ToString().Contains | ("SHIP") | 데이터 객체 조작/조회 |  |  |  |
| AC-f74ba432 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0010_Shipment_Plan_SEMI.cs:3782 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (toSite.ToString() == popupToSite) ▸ foreach (Data… | DATA_OP | defaultData.Add | (DefMain.TO_SITE_DESCRIPTION, bod.second_site_name) | 데이터 객체 조작/조회 |  |  |  |
| AC-973c71fa | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0010_Shipment_Plan_SEMI.cs:3783 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (toSite.ToString() == popupToSite) ▸ foreach (Data… | DATA_OP | defaultData.Add | (DefMain.TRANSPORT_MODE, bod.transport_mode) | 데이터 객체 조작/조회 |  |  |  |
| AC-149b5b9c | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0010_Shipment_Plan_SEMI.cs:3784 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (toSite.ToString() == popupToSite) ▸ foreach (Data… | DATA_OP | defaultData.Add | (DefMain.LT_DAY, bod.lt_total) | 데이터 객체 조작/조회 |  |  |  |
| AC-a18370a8 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0010_Shipment_Plan_SEMI.cs:3788 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (toSite.ToString() == popupToSite) ▸ foreach (Data… | DATA_OP | defaultData.Add | (DefMain.TO_SITE_DESCRIPTION, "-") | 데이터 객체 조작/조회 |  |  |  |
| AC-392dadbc | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0010_Shipment_Plan_SEMI.cs:3789 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (toSite.ToString() == popupToSite) ▸ foreach (Data… | DATA_OP | defaultData.Add | (DefMain.TRANSPORT_MODE, "-") | 데이터 객체 조작/조회 |  |  |  |
| AC-84e2b82d | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0010_Shipment_Plan_SEMI.cs:3790 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (toSite.ToString() == popupToSite) ▸ foreach (Data… | DATA_OP | defaultData.Add | (DefMain.LT_DAY, "0") | 데이터 객체 조작/조회 |  |  |  |
| AC-2f12fc7a | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0010_Shipment_Plan_SEMI.cs:3793 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (toSite.ToString() == popupToSite) ▸ foreach (Data… | DATA_OP | defaultData.Add | (DefMain.MEASURE_LABEL, dr[DefMain.MEASURE_LABEL]) | 데이터 객체 조작/조회 |  |  |  |
| AC-2e24721a | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0010_Shipment_Plan_SEMI.cs:3794 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (toSite.ToString() == popupToSite) ▸ foreach (Data… | DATA_OP | defaultData.Add | (DefMain.MEASURE, dr[DefMain.MEASURE]) | 데이터 객체 조작/조회 |  |  |  |
| AC-20e2b7b3 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0010_Shipment_Plan_SEMI.cs:3795 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (toSite.ToString() == popupToSite) ▸ foreach (Data… | DATA_OP | defaultData.Add | (DefMain.DIVISION_NAME, dr[DefMain.DIVISION_NAME]) | 데이터 객체 조작/조회 |  |  |  |
| AC-26b7a668 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0010_Shipment_Plan_SEMI.cs:3796 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (toSite.ToString() == popupToSite) ▸ foreach (Data… | DATA_OP | defaultData.Add | (DefMain.OPERATION_GROUP, dr[DefMain.OPERATION_GROUP]) | 데이터 객체 조작/조회 |  |  |  |
| AC-873f6543 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0010_Shipment_Plan_SEMI.cs:3797 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (toSite.ToString() == popupToSite) ▸ foreach (Data… | DATA_OP | defaultData.Add | (DefMain.FROM_SITE, bod.first_site) | 데이터 객체 조작/조회 |  |  |  |
| AC-9560d670 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0010_Shipment_Plan_SEMI.cs:3799 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (toSite.ToString() == popupToSite) ▸ foreach (Data… | DATA_OP | dr[DefMain.MEASURE].ToString().Contains | ("SHIP") | 데이터 객체 조작/조회 |  |  |  |
| AC-2eea3721 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0010_Shipment_Plan_SEMI.cs:3801 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (toSite.ToString() == popupToSite) ▸ foreach (Data… | DATA_OP | defaultData.Add | (DefMain.TO_SITE, bod.second_site) | 데이터 객체 조작/조회 |  |  |  |
| AC-77b5af62 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0010_Shipment_Plan_SEMI.cs:3802 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (toSite.ToString() == popupToSite) ▸ foreach (Data… | DATA_OP | defaultData.Add | (DefMain.BOD_ID, bod.bod_id) | 데이터 객체 조작/조회 |  |  |  |
| AC-1e25b98b | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0010_Shipment_Plan_SEMI.cs:3806 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (toSite.ToString() == popupToSite) ▸ foreach (Data… | DATA_OP | defaultData.Add | (DefMain.TO_SITE, "-") | 데이터 객체 조작/조회 |  |  |  |
| AC-e4953a99 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0010_Shipment_Plan_SEMI.cs:3807 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (toSite.ToString() == popupToSite) ▸ foreach (Data… | DATA_OP | defaultData.Add | (DefMain.BOD_ID, "-") | 데이터 객체 조작/조회 |  |  |  |
| AC-0ded74f1 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0010_Shipment_Plan_SEMI.cs:3810 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (toSite.ToString() == popupToSite) ▸ foreach (Data… | DATA_OP | defaultData.Add | (DefMain.MEASURE_ORDER_NO, dr[DefMain.MEASURE_ORDER_NO]) | 데이터 객체 조작/조회 |  |  |  |
| AC-2a0ad940 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0010_Shipment_Plan_SEMI.cs:3811 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (toSite.ToString() == popupToSite) ▸ foreach (Data… | DATA_OP | defaultData.Add | (DefMain.SHIP_FROZEN, bod.ship_frozen) | 데이터 객체 조작/조회 |  |  |  |
| AC-c55b5c8c | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0010_Shipment_Plan_SEMI.cs:3812 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (toSite.ToString() == popupToSite) ▸ foreach (Data… | DATA_OP | defaultData.Add | (DefMain.FROM_YYYYMMDD, dr[DefMain.FROM_YYYYMMDD]) | 데이터 객체 조작/조회 |  |  |  |
| AC-f7a0d04c | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0010_Shipment_Plan_SEMI.cs:3813 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (toSite.ToString() == popupToSite) ▸ foreach (Data… | DATA_OP | defaultData.Add | (DefMain.TO_YYYYMMDD, dr[DefMain.TO_YYYYMMDD]) | 데이터 객체 조작/조회 |  |  |  |
| AC-13711d33 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0010_Shipment_Plan_SEMI.cs:3814 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (toSite.ToString() == popupToSite) ▸ foreach (Data… | DATA_OP | defaultData.Add | (DefMain.BOD_FROM_YYYYMMDD, bod.bod_from_yyyymmdd) | 데이터 객체 조작/조회 |  |  |  |
| AC-04bf3c12 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0010_Shipment_Plan_SEMI.cs:3815 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (toSite.ToString() == popupToSite) ▸ foreach (Data… | DATA_OP | defaultData.Add | (DefMain.BOD_TO_YYYYMMDD, bod.bod_to_yyyymmdd) | 데이터 객체 조작/조회 |  |  |  |
| AC-7b09a3bc | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0010_Shipment_Plan_SEMI.cs:3816 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (toSite.ToString() == popupToSite) ▸ foreach (Data… | GRID_SET | siMain.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |

## SCP0010_Shipment_Plan_SEMI.RefreshFromSite

진입점: this.Load [if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))] / cboDivision.SelectedIndexChanged [if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))] / cboOperGroup.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-806fa54f | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 2 | SCP0010_Shipment_Plan_SEMI.cs:717 | try ▸ if (this._division.Equals("EE_UC")) | CALL_EXT | DBUtils.GetAndFilterString | (new List<string>() { DefMain.DIVISION_ID, DefMain.OPERATION_GROUP }, new List<string>() {… | ⚠ 의미 확인 필요 |  |  |  |
| AC-5066d2fd | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 2 | SCP0010_Shipment_Plan_SEMI.cs:723 | try ▸ else of (this._division.Equals("EE_UC")) ▸ if (this._division.Equals("EE")) | CALL_EXT | DBUtils.GetAndFilterString | (new List<string>() { DefMain.DIVISION_ID, DefMain.OPERATION_GROUP }, new List<string>() {… | ⚠ 의미 확인 필요 |  |  |  |
| AC-cfc9e933 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 2 | SCP0010_Shipment_Plan_SEMI.cs:727 | try ▸ else of (this._division.Equals("EE_UC")) ▸ else of (this._division.Equals("EE")) | CALL_EXT | DBUtils.GetAndFilterString | (new List<string>() { DefMain.DIVISION_ID, DefMain.OPERATION_GROUP }, new List<string>() {… | ⚠ 의미 확인 필요 |  |  |  |
| AC-ef86409b | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 2 | SCP0010_Shipment_Plan_SEMI.cs:731 | try | FLAG | dtFromSite | DBUtils.Filter(dtFromSiteAll, filter, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-438d5f04 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 2 | SCP0010_Shipment_Plan_SEMI.cs:731 | try | DATA_OP | DBUtils.Filter | (dtFromSiteAll, filter, true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-cd201b11 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 2 | SCP0010_Shipment_Plan_SEMI.cs:733 | try | LIST_REBIND | clsCtrl.setListBox | (dtFromSite, clbFromSite, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0010_Shipment_Plan_SEMI.RefreshOperationGroup

진입점: this.Load [if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))] / cboDivision.SelectedIndexChanged [if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3ef756b4 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 1 | SCP0010_Shipment_Plan_SEMI.cs:700 | if (!this._division.Substring(0, 2).Equals("EE")) | FLAG | dtOperationGroup | Data.Common(Data.Type.LookupCommon, false, "OPERATION_GROUP_SEMI") ⇒ biz:CommonData.CommonDataList [code=LookupCommon] | 화면 필드/플래그 변경 |  |  |  |
| AC-52a147e7 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 1 | SCP0010_Shipment_Plan_SEMI.cs:700 | if (!this._division.Substring(0, 2).Equals("EE")) | COMBO_DATA | Data.Common | (Data.Type.LookupCommon, false, "OPERATION_GROUP_SEMI") ⇒ biz:CommonData.CommonDataList [code=LookupCommon] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-1f21ff27 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 1 | SCP0010_Shipment_Plan_SEMI.cs:704 | else of (!this._division.Substring(0, 2).Equals("EE")) | FLAG | dtOperationGroup | Data.Common(Data.Type.LookupCommon, false, "OPERATION_GROUP_SEMI_EE") ⇒ biz:CommonData.CommonDataList [code=LookupCommon] | 화면 필드/플래그 변경 |  |  |  |
| AC-55c459f6 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 1 | SCP0010_Shipment_Plan_SEMI.cs:704 | else of (!this._division.Substring(0, 2).Equals("EE")) | COMBO_DATA | Data.Common | (Data.Type.LookupCommon, false, "OPERATION_GROUP_SEMI_EE") ⇒ biz:CommonData.CommonDataList [code=LookupCommon] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-1709ef0a | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 1 | SCP0010_Shipment_Plan_SEMI.cs:707 |  | LIST_REBIND | clsCtrl.setListBox | (dtOperationGroup, cboOperGroup, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0010_Shipment_Plan_SEMI.RefreshPlanDate

진입점: this.Load [if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))] / cboDivision.SelectedIndexChanged [if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f28e040e | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 1 | SCP0010_Shipment_Plan_SEMI.cs:775 |  | FLAG | dtPlanDate | DBUtils.Filter(dtPlanDateAll, "DIVISION_ID = '"+ this._division + "'", true) | 화면 필드/플래그 변경 |  |  |  |
| AC-0dc75477 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 1 | SCP0010_Shipment_Plan_SEMI.cs:775 |  | DATA_OP | DBUtils.Filter | (dtPlanDateAll, "DIVISION_ID = '"+ this._division + "'", true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-c94e0d02 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 1 | SCP0010_Shipment_Plan_SEMI.cs:776 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanDate, cboPlanDate, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0010_Shipment_Plan_SEMI.RefreshPlanSeq

진입점: this.Load [if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))] / cboDivision.SelectedIndexChanged [if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))] / cboPlanType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-083b9c91 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 2 | SCP0010_Shipment_Plan_SEMI.cs:789 |  | FLAG | dtPlanSeq | DBUtils.Filter(dtPlanSeqAll, "DIVISION_ID = '" + this._division + "' AND PLANDATE = '" + t… | 화면 필드/플래그 변경 |  |  |  |
| AC-cca65885 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 2 | SCP0010_Shipment_Plan_SEMI.cs:789 |  | DATA_OP | DBUtils.Filter | (dtPlanSeqAll, "DIVISION_ID = '" + this._division + "' AND PLANDATE = '" + this._planDate … | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-9924991d | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 2 | SCP0010_Shipment_Plan_SEMI.cs:791 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanSeq, cboPlanSeq, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0010_Shipment_Plan_SEMI.RefreshPlanType

진입점: this.Load [if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))] / cboDivision.SelectedIndexChanged [if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))] / cboPlanDate.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-afae6708 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 2 | SCP0010_Shipment_Plan_SEMI.cs:780 |  | FLAG | dtPlanType | DBUtils.Filter(dtPlanTypeAll, "DIVISION_ID = '" + this._division + "' AND PLANDATE = '" + … | 화면 필드/플래그 변경 |  |  |  |
| AC-fa1eeea7 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 2 | SCP0010_Shipment_Plan_SEMI.cs:780 |  | DATA_OP | DBUtils.Filter | (dtPlanTypeAll, "DIVISION_ID = '" + this._division + "' AND PLANDATE = '" + this._planDate… | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-926a2122 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 2 | SCP0010_Shipment_Plan_SEMI.cs:781 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanType, cboPlanType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-778d5891 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 2 | SCP0010_Shipment_Plan_SEMI.cs:784 | if (dtPlanType.Rows.Count > 0) | VALUE_SET | cboPlanType.SelectedIndex | dtPlanType.Rows.Count - 1 | 컨트롤 값 설정 |  |  |  |

## SCP0010_Shipment_Plan_SEMI.RefreshToSite

진입점: this.Load [if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))] / cboDivision.SelectedIndexChanged [if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))] / cboOperGroup.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b4e77d04 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 2 | SCP0010_Shipment_Plan_SEMI.cs:748 | try ▸ if (this._division.Equals("EE_UC")) | CALL_EXT | DBUtils.GetAndFilterString | (new List<string>() { DefMain.DIVISION_ID, DefMain.OPERATION_GROUP }, new List<string>() {… | ⚠ 의미 확인 필요 |  |  |  |
| AC-a3a5cd53 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 2 | SCP0010_Shipment_Plan_SEMI.cs:749 | try ▸ if (this._division.Equals("EE_UC")) | FLAG | dtToSite | DBUtils.Filter(dtToSiteAll, filter, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-6b3447d8 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 2 | SCP0010_Shipment_Plan_SEMI.cs:749 | try ▸ if (this._division.Equals("EE_UC")) | DATA_OP | DBUtils.Filter | (dtToSiteAll, filter, true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-ac1f1ce6 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 2 | SCP0010_Shipment_Plan_SEMI.cs:753 | try ▸ else of (this._division.Equals("EE_UC")) | CALL_EXT | DBUtils.GetAndFilterString | (new List<string>() { DefMain.DIVISION_ID, DefMain.OPERATION_GROUP }, new List<string>() {… | ⚠ 의미 확인 필요 |  |  |  |
| AC-591e34c5 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 2 | SCP0010_Shipment_Plan_SEMI.cs:757 | try ▸ else of (this._division.Equals("EE_UC")) ▸ if (this._division.Substring(0, 2).Equals("EE")) | FLAG | dtToSite | DBUtils.Filter(dtToSiteEEAll, filter, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-07ad0b68 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 2 | SCP0010_Shipment_Plan_SEMI.cs:757 | try ▸ else of (this._division.Equals("EE_UC")) ▸ if (this._division.Substring(0, 2).Equals("EE")) | DATA_OP | DBUtils.Filter | (dtToSiteEEAll, filter, true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-4dafb0fb | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 2 | SCP0010_Shipment_Plan_SEMI.cs:761 | try ▸ else of (this._division.Equals("EE_UC")) ▸ else of (this._division.Substring(0, 2).Equals("EE")) | FLAG | dtToSite | DBUtils.Filter(dtToSiteAll, filter, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-666b3efc | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 2 | SCP0010_Shipment_Plan_SEMI.cs:761 | try ▸ else of (this._division.Equals("EE_UC")) ▸ else of (this._division.Substring(0, 2).Equals("EE")) | DATA_OP | DBUtils.Filter | (dtToSiteAll, filter, true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-8c82f101 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 2 | SCP0010_Shipment_Plan_SEMI.cs:765 | try | LIST_REBIND | clsCtrl.setListBox | (dtToSite, clbToSite, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0010_Shipment_Plan_SEMI.RetValue

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-81167b5e | (진입점 미연결) | SCP0010_Shipment_Plan_SEMI.cs:1537 |  | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |

## SCP0010_Shipment_Plan_SEMI.SaveData_FixInfo

진입점: this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))] / this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName)) ▸ if (MessageHelper.GMessageBox("MSG00016") == DialogResult.Yes)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-08231e1a | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0010_Shipment_Plan_SEMI.cs:3936 | if (fps.Name == "spdMain") | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-46903120 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0010_Shipment_Plan_SEMI.cs:3941 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (siMain.ActiveSheet.Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-50b02b1d | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0010_Shipment_Plan_SEMI.cs:3965 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (fixType == "F") | POPUP | new SCM0002_RejectReasonPopup | ("Fix Reason") | 팝업/폼 생성 |  |  |  |
| AC-28803896 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0010_Shipment_Plan_SEMI.cs:3966 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (fixType == "F") | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-7d992d7a | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0010_Shipment_Plan_SEMI.cs:3967 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (fixType == "F") | UI_PROP | popup.Width | 600 | 속성 Width 설정 |  |  |  |
| AC-b08f4c2b | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0010_Shipment_Plan_SEMI.cs:3968 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (fixType == "F") | UI_PROP | popup.Height | 230 | 속성 Height 설정 |  |  |  |
| AC-7271d30b | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0010_Shipment_Plan_SEMI.cs:3970 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (fixType == "F") | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-e8f20576 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0010_Shipment_Plan_SEMI.cs:3979 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (fixType == "F") ▸ else of (popup.ShowDial… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7e022772 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0010_Shipment_Plan_SEMI.cs:3992 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (selCells.Length < 1) | MESSAGE | MessageHelper.GMessageBox | ("MSG00134", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b906a758 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0010_Shipment_Plan_SEMI.cs:3993 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (selCells.Length < 1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c508bc6f | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0010_Shipment_Plan_SEMI.cs:3999 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("A") | 데이터 객체 조작/조회 |  |  |  |
| AC-a34a8def | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0010_Shipment_Plan_SEMI.cs:4000 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_active_flag") | 데이터 객체 조작/조회 |  |  |  |
| AC-ad327a33 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0010_Shipment_Plan_SEMI.cs:4001 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_division_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-b9ec1ff5 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0010_Shipment_Plan_SEMI.cs:4002 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_plan_start_yyyymmdd") | 데이터 객체 조작/조회 |  |  |  |
| AC-5d824560 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0010_Shipment_Plan_SEMI.cs:4003 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_plan_type") | 데이터 객체 조작/조회 |  |  |  |
| AC-8704ee3c | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0010_Shipment_Plan_SEMI.cs:4004 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_seq") | 데이터 객체 조작/조회 |  |  |  |
| AC-88d75259 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0010_Shipment_Plan_SEMI.cs:4005 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_biz_type") | 데이터 객체 조작/조회 |  |  |  |
| AC-5bd31da2 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0010_Shipment_Plan_SEMI.cs:4006 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_operation_group") | 데이터 객체 조작/조회 |  |  |  |
| AC-96b3e991 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0010_Shipment_Plan_SEMI.cs:4007 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_item_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-45c129f7 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0010_Shipment_Plan_SEMI.cs:4008 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_from_site") | 데이터 객체 조작/조회 |  |  |  |
| AC-5b190c90 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0010_Shipment_Plan_SEMI.cs:4009 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_bod_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-e44e500a | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0010_Shipment_Plan_SEMI.cs:4010 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_measure") | 데이터 객체 조작/조회 |  |  |  |
| AC-d7ed6aaa | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0010_Shipment_Plan_SEMI.cs:4011 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_yyyymmdd") | 데이터 객체 조작/조회 |  |  |  |
| AC-4b095709 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0010_Shipment_Plan_SEMI.cs:4012 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_to_site") | 데이터 객체 조작/조회 |  |  |  |
| AC-6f7b8d78 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0010_Shipment_Plan_SEMI.cs:4013 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_qty") | 데이터 객체 조작/조회 |  |  |  |
| AC-d5e57d12 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0010_Shipment_Plan_SEMI.cs:4014 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_origin_from_division_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-b0695d2f | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0010_Shipment_Plan_SEMI.cs:4015 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_origin_to_division_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-bd23fb25 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0010_Shipment_Plan_SEMI.cs:4016 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_electrode_type") | 데이터 객체 조작/조회 |  |  |  |
| AC-81c661e9 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0010_Shipment_Plan_SEMI.cs:4017 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_fix_reason") | 데이터 객체 조작/조회 |  |  |  |
| AC-49388e35 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0010_Shipment_Plan_SEMI.cs:4018 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_created_by") | 데이터 객체 조작/조회 |  |  |  |
| AC-960f7e04 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0010_Shipment_Plan_SEMI.cs:4019 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_last_updated_by") | 데이터 객체 조작/조회 |  |  |  |
| AC-5eb419cf | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0010_Shipment_Plan_SEMI.cs:4020 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_time_zone") | 데이터 객체 조작/조회 |  |  |  |
| AC-77e732bd | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0010_Shipment_Plan_SEMI.cs:4021 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_bucket_type") | 데이터 객체 조작/조회 |  |  |  |
| AC-6aef127f | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0010_Shipment_Plan_SEMI.cs:4022 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_trans_mode") | 데이터 객체 조작/조회 |  |  |  |
| AC-405a11ac | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0010_Shipment_Plan_SEMI.cs:4023 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("debug_mode") | 데이터 객체 조작/조회 |  |  |  |
| AC-b57ab2b7 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0010_Shipment_Plan_SEMI.cs:4024 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dsInput.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-93946a4d | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0010_Shipment_Plan_SEMI.cs:4055 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | GRID_STYLE | siMain.SetBGColor | (i, j, i, j, ControlColor.InvalidColor) | 그리드 표시 설정 |  |  |  |
| AC-2a9f2589 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0010_Shipment_Plan_SEMI.cs:4056 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | MESSAGE | MessageHelper.GMessageBox | ("MSG00026", new object[] { null }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-83815b70 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0010_Shipment_Plan_SEMI.cs:4057 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-bad917d5 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0010_Shipment_Plan_SEMI.cs:4063 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | CALL_EXT | siMain.GetBGColor | (i, j) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e4a490fc | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0010_Shipment_Plan_SEMI.cs:4092 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | DATA_OP | dsInput.Tables[0].NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-2f6c4f0f | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0010_Shipment_Plan_SEMI.cs:4093 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | DATA_OP | dr["p_active_flag"] | strAction | 행/컬럼 값 대입 |  |  |  |
| AC-8f73f9df | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0010_Shipment_Plan_SEMI.cs:4094 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | DATA_OP | dr["p_division_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.DIVISION_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-d33f76c2 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0010_Shipment_Plan_SEMI.cs:4095 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | DATA_OP | dr["p_biz_type"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.OPERATION_GROUP)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-a5d66477 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0010_Shipment_Plan_SEMI.cs:4096 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | DATA_OP | dr["p_item_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.ITEM_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-7e302c60 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0010_Shipment_Plan_SEMI.cs:4097 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | DATA_OP | dr["p_to_site"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.TO_SITE)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-d4e8e3a6 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0010_Shipment_Plan_SEMI.cs:4098 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | DATA_OP | dr["p_from_site"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.FROM_SITE)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-84f23cf5 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0010_Shipment_Plan_SEMI.cs:4099 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | DATA_OP | dr["p_bod_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.BOD_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-311c34ee | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0010_Shipment_Plan_SEMI.cs:4100 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | DATA_OP | dr["p_yyyymmdd"] | strYYYYMMDD | 행/컬럼 값 대입 |  |  |  |
| AC-6a6be8f3 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0010_Shipment_Plan_SEMI.cs:4101 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | DATA_OP | dr["p_qty"] | sQty | 행/컬럼 값 대입 |  |  |  |
| AC-1f5ddbff | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0010_Shipment_Plan_SEMI.cs:4102 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | DATA_OP | dr["p_origin_from_division_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.ORIGIN_FROM_DIVISION_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-7b3263f2 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0010_Shipment_Plan_SEMI.cs:4103 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | DATA_OP | dr["p_origin_to_division_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.ORIGIN_TO_DIVISION_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-19c0d8f6 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0010_Shipment_Plan_SEMI.cs:4104 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | DATA_OP | dr["p_electrode_type"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.ELECTRODE_TYPE)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-9bfe7de6 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0010_Shipment_Plan_SEMI.cs:4105 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | DATA_OP | dr["p_fix_reason"] | strReason | 행/컬럼 값 대입 |  |  |  |
| AC-f3de1d19 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0010_Shipment_Plan_SEMI.cs:4106 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | DATA_OP | dr["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-62b8bdc0 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0010_Shipment_Plan_SEMI.cs:4107 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | DATA_OP | dr["p_last_updated_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-516bc26b | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0010_Shipment_Plan_SEMI.cs:4108 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | DATA_OP | dr["p_time_zone"] | UserInfoContext.Current[UserInfoProperites.TimeZone] | 행/컬럼 값 대입 |  |  |  |
| AC-ddb78170 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0010_Shipment_Plan_SEMI.cs:4109 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | DATA_OP | dr["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-47c3243a | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0010_Shipment_Plan_SEMI.cs:4110 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | DATA_OP | dsInput.Tables[0].Rows.Add | (dr) | 데이터 객체 조작/조회 |  |  |  |
| AC-e8de6adb | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0010_Shipment_Plan_SEMI.cs:4124 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | CALL_EXT | siMain.GetBGColor | (i, j + nDayCntOfWeek) | ⚠ 의미 확인 필요 |  |  |  |
| AC-7566972a | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0010_Shipment_Plan_SEMI.cs:4133 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | GRID_STYLE | siMain.SetBGColor | (i, j + nDayCntOfWeek, i, j + nDayCntOfWeek, ControlColor.InvalidColor) | 그리드 표시 설정 |  |  |  |
| AC-08df9fae | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0010_Shipment_Plan_SEMI.cs:4134 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | MESSAGE | MessageHelper.GMessageBox | ("MSG00026", new object[] { null }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d10f2d9a | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0010_Shipment_Plan_SEMI.cs:4135 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-bbf0d346 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0010_Shipment_Plan_SEMI.cs:4162 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | DATA_OP | dsInput.Tables[0].NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-b51d97f7 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0010_Shipment_Plan_SEMI.cs:4163 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | DATA_OP | dr["p_active_flag"] | strAction | 행/컬럼 값 대입 |  |  |  |
| AC-de643964 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0010_Shipment_Plan_SEMI.cs:4164 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | DATA_OP | dr["p_division_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.DIVISION_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-faf13e70 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0010_Shipment_Plan_SEMI.cs:4165 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | DATA_OP | dr["p_biz_type"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.OPERATION_GROUP)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-078285ee | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0010_Shipment_Plan_SEMI.cs:4166 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | DATA_OP | dr["p_item_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.ITEM_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-35c45bf7 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0010_Shipment_Plan_SEMI.cs:4167 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | DATA_OP | dr["p_to_site"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.TO_SITE)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-d83cc081 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0010_Shipment_Plan_SEMI.cs:4168 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | DATA_OP | dr["p_from_site"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.FROM_SITE)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-512ad844 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0010_Shipment_Plan_SEMI.cs:4169 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | DATA_OP | dr["p_bod_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.BOD_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-3fb3e271 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0010_Shipment_Plan_SEMI.cs:4170 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | DATA_OP | dr["p_yyyymmdd"] | strYYYYMMDD | 행/컬럼 값 대입 |  |  |  |
| AC-011bd894 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0010_Shipment_Plan_SEMI.cs:4171 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | DATA_OP | dr["p_qty"] | sQty | 행/컬럼 값 대입 |  |  |  |
| AC-63abe520 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0010_Shipment_Plan_SEMI.cs:4172 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | DATA_OP | dr["p_origin_from_division_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.ORIGIN_FROM_DIVISION_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-60811adf | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0010_Shipment_Plan_SEMI.cs:4173 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | DATA_OP | dr["p_origin_to_division_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.ORIGIN_TO_DIVISION_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-56998dfa | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0010_Shipment_Plan_SEMI.cs:4174 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | DATA_OP | dr["p_electrode_type"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.ELECTRODE_TYPE)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-ba7ee231 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0010_Shipment_Plan_SEMI.cs:4175 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | DATA_OP | dr["p_fix_reason"] | strReason | 행/컬럼 값 대입 |  |  |  |
| AC-f07d94ac | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0010_Shipment_Plan_SEMI.cs:4176 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | DATA_OP | dr["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-db31f8db | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0010_Shipment_Plan_SEMI.cs:4177 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | DATA_OP | dr["p_last_updated_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-abd26177 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0010_Shipment_Plan_SEMI.cs:4178 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | DATA_OP | dr["p_time_zone"] | UserInfoContext.Current[UserInfoProperites.TimeZone] | 행/컬럼 값 대입 |  |  |  |
| AC-dae99b5b | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0010_Shipment_Plan_SEMI.cs:4179 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | DATA_OP | dr["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-f0b85f95 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0010_Shipment_Plan_SEMI.cs:4180 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | DATA_OP | dsInput.Tables[0].Rows.Add | (dr) | 데이터 객체 조작/조회 |  |  |  |
| AC-27a838d6 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0010_Shipment_Plan_SEMI.cs:4232 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (fixType.Equals("U") && iCount == 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00046", new object[] { null }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ca2899a6 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0010_Shipment_Plan_SEMI.cs:4233 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (fixType.Equals("U") && iCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-fe9def9f | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0010_Shipment_Plan_SEMI.cs:4238 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) | DATA_OP | dsInput.Tables[0].AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-f54753bf | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0010_Shipment_Plan_SEMI.cs:4243 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-50f11b8d | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0010_Shipment_Plan_SEMI.cs:4253 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | CALL_EXT | sql.AddParameter | ("@SCP0010", dsInput.Tables[0]) | ⚠ 의미 확인 필요 |  |  |  |
| AC-7b42fe83 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0010_Shipment_Plan_SEMI.cs:4254 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | ENDPOINT | sql.ExcuteProcedure | ("SaveShipmentPlanSemiFix") ⇒ biz:AppService.GeneralRunProcedureCustomTable [procedure=SaveShipmentPlanSemiFix… | 엔드포인트 호출 |  |  |  |
| AC-54daf37d | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0010_Shipment_Plan_SEMI.cs:4257 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-f1a02ebe | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0010_Shipment_Plan_SEMI.cs:4262 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (result != null &&… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { result.Rows[0]["result_cnt"].ToString() }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-dcb5ca45 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0010_Shipment_Plan_SEMI.cs:4271 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ else of (result != nu… | MESSAGE | MessageHelper.GMessageBox | ("MSG00003", new object[] { ReErrorMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-43e50961 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0010_Shipment_Plan_SEMI.cs:4280 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-f7b36f6f | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0010_Shipment_Plan_SEMI.cs:4281 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-94f3e89e | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0010_Shipment_Plan_SEMI.cs:4287 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ finally ▸ if (!prgCloseF) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-0abe90ff | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0010_Shipment_Plan_SEMI.cs:4294 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ else of (iCount > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00252", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c52f1428 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 1 | SCP0010_Shipment_Plan_SEMI.cs:4295 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ else of (iCount > 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0010_Shipment_Plan_SEMI.SaveData_Main

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d75714cd | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2130 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (siMain.ActiveSheet.Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c6336e67 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2132 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (!Get_IsSaveYn()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-04b4b898 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2134 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-abacdad1 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2137 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-ed87cdc9 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2161 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (iRow < siMain.ActiveSheet.Rows.… | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-2927ef24 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2163 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (iRow < siMain.ActiveSheet.Rows.… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9bf15e23 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2167 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (iRow < siMain.ActiveSheet.Rows.… | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-fd0039f8 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2169 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (iRow < siMain.ActiveSheet.Rows.… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b1301505 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2177 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (iRow < siMain.ActiveSheet.Rows.… | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-4d0c57f7 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2179 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (iRow < siMain.ActiveSheet.Rows.… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8e4f7636 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2194 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (iRow < siMain.ActiveSheet.Rows.… | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-26d19142 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2196 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (iRow < siMain.ActiveSheet.Rows.… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a135e0ba | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2200 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (iRow < siMain.ActiveSheet.Rows.… | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-b8501546 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2202 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (iRow < siMain.ActiveSheet.Rows.… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-25187409 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2209 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | FLAG | saveDS | new DataSet() | 화면 필드/플래그 변경 |  |  |  |
| AC-c76bc559 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2211 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dt.Columns.Add | ("A", typeof(char)) | 데이터 객체 조작/조회 |  |  |  |
| AC-b6e2458e | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2212 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dt.Columns.Add | ("p_active_flag") | 데이터 객체 조작/조회 |  |  |  |
| AC-3805b07a | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2213 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dt.Columns.Add | ("p_division_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-77bb88bc | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2214 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dt.Columns.Add | ("p_plan_start_yyyymmdd") | 데이터 객체 조작/조회 |  |  |  |
| AC-d535ea61 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2215 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dt.Columns.Add | ("p_plan_type") | 데이터 객체 조작/조회 |  |  |  |
| AC-891e2c73 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2216 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dt.Columns.Add | ("p_seq") | 데이터 객체 조작/조회 |  |  |  |
| AC-a61d0069 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2217 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dt.Columns.Add | ("p_operation_group") | 데이터 객체 조작/조회 |  |  |  |
| AC-c41a3c0f | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2218 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dt.Columns.Add | ("p_item_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-1a3f2aee | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2219 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dt.Columns.Add | ("p_from_site") | 데이터 객체 조작/조회 |  |  |  |
| AC-127cc217 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2220 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dt.Columns.Add | ("p_bod_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-5c204e5b | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2221 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dt.Columns.Add | ("p_measure") | 데이터 객체 조작/조회 |  |  |  |
| AC-26a74fcd | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2222 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dt.Columns.Add | ("p_yyyymmdd") | 데이터 객체 조작/조회 |  |  |  |
| AC-1a24da1e | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2223 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dt.Columns.Add | ("p_to_site") | 데이터 객체 조작/조회 |  |  |  |
| AC-ce4ac3c9 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2224 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dt.Columns.Add | ("p_qty") | 데이터 객체 조작/조회 |  |  |  |
| AC-a5ba96b1 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2225 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dt.Columns.Add | ("p_origin_from_division_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-8061c87f | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2226 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dt.Columns.Add | ("p_origin_to_division_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-0a080feb | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2227 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dt.Columns.Add | ("p_electrode_type") | 데이터 객체 조작/조회 |  |  |  |
| AC-8835d5e8 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2228 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dt.Columns.Add | ("p_created_by") | 데이터 객체 조작/조회 |  |  |  |
| AC-a0299085 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2229 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dt.Columns.Add | ("p_last_updated_by") | 데이터 객체 조작/조회 |  |  |  |
| AC-b484d42a | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2230 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dt.Columns.Add | ("p_time_zone") | 데이터 객체 조작/조회 |  |  |  |
| AC-f1b0d18e | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2231 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dt.Columns.Add | ("p_first_row") | 데이터 객체 조작/조회 |  |  |  |
| AC-7bfa9131 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2232 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dt.Columns.Add | ("p_last_row") | 데이터 객체 조작/조회 |  |  |  |
| AC-b1c25e26 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2233 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | saveDS.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-d150b0bc | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2238 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dtInput.Columns.Add | ("A") | 데이터 객체 조작/조회 |  |  |  |
| AC-46add438 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2239 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dtInput.Columns.Add | ("p_active_flag") | 데이터 객체 조작/조회 |  |  |  |
| AC-a6f0afb6 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2240 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dtInput.Columns.Add | ("p_division_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-dc8fae88 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2241 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dtInput.Columns.Add | ("p_plan_start_yyyymmdd") | 데이터 객체 조작/조회 |  |  |  |
| AC-01a965ec | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2242 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dtInput.Columns.Add | ("p_plan_type") | 데이터 객체 조작/조회 |  |  |  |
| AC-281972f8 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2243 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dtInput.Columns.Add | ("p_seq") | 데이터 객체 조작/조회 |  |  |  |
| AC-2b0401c9 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2244 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dtInput.Columns.Add | ("p_biz_type") | 데이터 객체 조작/조회 |  |  |  |
| AC-0129211c | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2245 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dtInput.Columns.Add | ("p_operation_group") | 데이터 객체 조작/조회 |  |  |  |
| AC-7c59f535 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2246 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dtInput.Columns.Add | ("p_item_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-4b8b8f95 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2247 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dtInput.Columns.Add | ("p_from_site") | 데이터 객체 조작/조회 |  |  |  |
| AC-0feb8c50 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2248 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dtInput.Columns.Add | ("p_bod_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-9caad76d | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2249 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dtInput.Columns.Add | ("p_measure") | 데이터 객체 조작/조회 |  |  |  |
| AC-77f32e17 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2250 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dtInput.Columns.Add | ("p_yyyymmdd") | 데이터 객체 조작/조회 |  |  |  |
| AC-ac3785cc | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2251 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dtInput.Columns.Add | ("p_to_site") | 데이터 객체 조작/조회 |  |  |  |
| AC-9c16047c | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2252 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dtInput.Columns.Add | ("p_qty") | 데이터 객체 조작/조회 |  |  |  |
| AC-1c5a29b2 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2253 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dtInput.Columns.Add | ("p_origin_from_division_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-ef90d491 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2254 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dtInput.Columns.Add | ("p_origin_to_division_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-0425a033 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2255 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dtInput.Columns.Add | ("p_electrode_type") | 데이터 객체 조작/조회 |  |  |  |
| AC-7af1ffe7 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2256 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dtInput.Columns.Add | ("p_fix_reason") | 데이터 객체 조작/조회 |  |  |  |
| AC-6b969c6b | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2257 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dtInput.Columns.Add | ("p_created_by") | 데이터 객체 조작/조회 |  |  |  |
| AC-234ebb1e | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2258 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dtInput.Columns.Add | ("p_last_updated_by") | 데이터 객체 조작/조회 |  |  |  |
| AC-2d6ededd | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2259 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dtInput.Columns.Add | ("p_time_zone") | 데이터 객체 조작/조회 |  |  |  |
| AC-249c5f70 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2260 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dtInput.Columns.Add | ("p_bucket_type") | 데이터 객체 조작/조회 |  |  |  |
| AC-f8469322 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2261 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dtInput.Columns.Add | ("p_trans_mode") | 데이터 객체 조작/조회 |  |  |  |
| AC-7e597f97 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2262 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dtInput.Columns.Add | ("debug_mode") | 데이터 객체 조작/조회 |  |  |  |
| AC-11e443f6 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2263 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dsInput.Tables.Add | (dtInput) | 데이터 객체 조작/조회 |  |  |  |
| AC-daf83ae5 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2302 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | saveDS.Tables[0].NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-149977ef | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2303 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dr["A"] | action | 행/컬럼 값 대입 |  |  |  |
| AC-3a9b6a08 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2304 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dr["p_active_flag"] | action | 행/컬럼 값 대입 |  |  |  |
| AC-1ffeea6d | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2305 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dr["p_division_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.DIVISION_ID)) | 행/컬럼 값 대입 |  |  |  |
| AC-1c513332 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2306 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dr["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-74a38884 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2307 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dr["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-e6a234c0 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2308 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dr["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-1c5503ba | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2309 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dr["p_operation_group"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.OPERATION_GROUP)) | 행/컬럼 값 대입 |  |  |  |
| AC-d97390fd | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2310 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dr["p_item_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.ITEM_ID)) | 행/컬럼 값 대입 |  |  |  |
| AC-763692af | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2311 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dr["p_from_site"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.FROM_SITE)) | 행/컬럼 값 대입 |  |  |  |
| AC-7875da8a | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2312 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dr["p_bod_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.BOD_ID)) | 행/컬럼 값 대입 |  |  |  |
| AC-1f89b75e | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2313 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dr["p_measure"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.MEASURE)) | 행/컬럼 값 대입 |  |  |  |
| AC-b2b09a08 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2316 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dr["p_yyyymmdd"] | yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-fdee9038 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2317 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dr["p_to_site"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.TO_SITE)) | 행/컬럼 값 대입 |  |  |  |
| AC-ef551018 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2318 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dr["p_qty"] | 0 | 행/컬럼 값 대입 |  |  |  |
| AC-ee426620 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2319 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dr["p_origin_from_division_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.ORIGIN_FROM_DIVISION_ID)) | 행/컬럼 값 대입 |  |  |  |
| AC-d16346a2 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2320 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dr["p_origin_to_division_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.ORIGIN_TO_DIVISION_ID)) | 행/컬럼 값 대입 |  |  |  |
| AC-eeffd2a1 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2327 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dr["p_electrode_type"] | elec_type | 행/컬럼 값 대입 |  |  |  |
| AC-6ac89854 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2329 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dr["p_created_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-2255cb21 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2330 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dr["p_last_updated_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-331361b8 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2331 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dr["p_time_zone"] | UserInfoContext.Current[UserInfoProperites.TimeZone] | 행/컬럼 값 대입 |  |  |  |
| AC-447fd29a | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2333 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | saveDS.Tables[0].Rows.Add | (dr) | 데이터 객체 조작/조회 |  |  |  |
| AC-b2ce431d | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2337 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dsInput.Tables[0].NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-4ad6f330 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2338 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dRow["A"] | action | 행/컬럼 값 대입 |  |  |  |
| AC-cca55d07 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2339 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dRow["p_active_flag"] | action | 행/컬럼 값 대입 |  |  |  |
| AC-7e19b50c | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2340 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dRow["p_division_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.DIVISION_ID)) | 행/컬럼 값 대입 |  |  |  |
| AC-61dc39ab | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2341 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dRow["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-7d301755 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2342 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dRow["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-96d36237 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2343 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dRow["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-4606e869 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2344 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dRow["p_operation_group"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.OPERATION_GROUP)) | 행/컬럼 값 대입 |  |  |  |
| AC-b37a6878 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2345 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dRow["p_biz_type"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.OPERATION_GROUP)) | 행/컬럼 값 대입 |  |  |  |
| AC-96198d69 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2346 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dRow["p_item_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.ITEM_ID)) | 행/컬럼 값 대입 |  |  |  |
| AC-ed5acc3f | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2347 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dRow["p_from_site"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.FROM_SITE)) | 행/컬럼 값 대입 |  |  |  |
| AC-b8c817e7 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2348 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dRow["p_bod_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.BOD_ID)) | 행/컬럼 값 대입 |  |  |  |
| AC-46d7c3f1 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2349 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dRow["p_measure"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.MEASURE)) | 행/컬럼 값 대입 |  |  |  |
| AC-43776a60 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2350 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dRow["p_yyyymmdd"] | yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-f0d61aef | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2351 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dRow["p_to_site"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.TO_SITE)) | 행/컬럼 값 대입 |  |  |  |
| AC-9b4adcbb | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2352 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dRow["p_qty"] | 0 | 행/컬럼 값 대입 |  |  |  |
| AC-37b313eb | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2353 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dRow["p_origin_from_division_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.ORIGIN_FROM_DIVISION_ID)) | 행/컬럼 값 대입 |  |  |  |
| AC-42df273b | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2354 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dRow["p_origin_to_division_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.ORIGIN_TO_DIVISION_ID)) | 행/컬럼 값 대입 |  |  |  |
| AC-9583f3c4 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2355 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dRow["p_electrode_type"] | elec_type | 행/컬럼 값 대입 |  |  |  |
| AC-f306ea1d | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2356 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dRow["p_bucket_type"] | cboBucketType.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-99e22ccc | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2357 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dRow["p_created_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-bca86940 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2358 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dRow["p_last_updated_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-7e09a197 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2359 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dRow["p_time_zone"] | UserInfoContext.Current[UserInfoProperites.TimeZone] | 행/컬럼 값 대입 |  |  |  |
| AC-ffe8ae9f | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2360 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dRow["p_trans_mode"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.TRANSPORT_MODE)) | 행/컬럼 값 대입 |  |  |  |
| AC-24019990 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2361 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dRow["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-40695592 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2362 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dsInput.Tables[0].Rows.Add | (dRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-c64375f4 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2376 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | saveDS.Tables[0].NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-880dd39f | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2377 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dr["A"] | action | 행/컬럼 값 대입 |  |  |  |
| AC-7c79d2c0 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2378 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dr["p_active_flag"] | action | 행/컬럼 값 대입 |  |  |  |
| AC-f3ad133f | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2379 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dr["p_division_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.DIVISION_ID)) | 행/컬럼 값 대입 |  |  |  |
| AC-bea54039 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2380 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dr["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-a8616f58 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2381 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dr["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-bdc6c24b | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2382 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dr["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-14952923 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2383 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dr["p_operation_group"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.OPERATION_GROUP)) | 행/컬럼 값 대입 |  |  |  |
| AC-37e10105 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2384 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dr["p_item_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.ITEM_ID)) | 행/컬럼 값 대입 |  |  |  |
| AC-5a4c4449 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2385 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dr["p_from_site"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.FROM_SITE)) | 행/컬럼 값 대입 |  |  |  |
| AC-1e791580 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2386 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dr["p_bod_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.BOD_ID)) | 행/컬럼 값 대입 |  |  |  |
| AC-79a24ec8 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2387 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dr["p_measure"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.MEASURE)) | 행/컬럼 값 대입 |  |  |  |
| AC-ec29b27d | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2390 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dr["p_yyyymmdd"] | yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-7073a784 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2391 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dr["p_to_site"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.TO_SITE)) | 행/컬럼 값 대입 |  |  |  |
| AC-7e6edc6f | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2392 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dr["p_qty"] | val | 행/컬럼 값 대입 |  |  |  |
| AC-942eb212 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2393 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dr["p_origin_from_division_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.ORIGIN_FROM_DIVISION_ID)) | 행/컬럼 값 대입 |  |  |  |
| AC-d324e205 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2394 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dr["p_origin_to_division_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.ORIGIN_TO_DIVISION_ID)) | 행/컬럼 값 대입 |  |  |  |
| AC-e052fd06 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2401 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dr["p_electrode_type"] | elec_type | 행/컬럼 값 대입 |  |  |  |
| AC-5c76c262 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2403 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dr["p_created_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-1616aaca | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2404 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dr["p_last_updated_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-acfbcca3 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2405 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dr["p_time_zone"] | UserInfoContext.Current[UserInfoProperites.TimeZone] | 행/컬럼 값 대입 |  |  |  |
| AC-d8a76d7d | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2407 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | saveDS.Tables[0].Rows.Add | (dr) | 데이터 객체 조작/조회 |  |  |  |
| AC-9acba8f6 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2412 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dsInput.Tables[0].NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-4bdd9cf2 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2413 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dRow["A"] | action | 행/컬럼 값 대입 |  |  |  |
| AC-e319ea7d | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2414 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dRow["p_active_flag"] | action | 행/컬럼 값 대입 |  |  |  |
| AC-2ba29ada | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2415 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dRow["p_division_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.DIVISION_ID)) | 행/컬럼 값 대입 |  |  |  |
| AC-113f71f6 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2416 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dRow["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-e226db30 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2417 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dRow["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-d296a299 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2418 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dRow["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-7fec63b5 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2419 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dRow["p_biz_type"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.OPERATION_GROUP)) | 행/컬럼 값 대입 |  |  |  |
| AC-418275ee | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2420 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dRow["p_operation_group"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.OPERATION_GROUP)) | 행/컬럼 값 대입 |  |  |  |
| AC-c606fa6f | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2421 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dRow["p_item_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.ITEM_ID)) | 행/컬럼 값 대입 |  |  |  |
| AC-10af93da | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2422 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dRow["p_from_site"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.FROM_SITE)) | 행/컬럼 값 대입 |  |  |  |
| AC-79783c0d | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2423 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dRow["p_bod_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.BOD_ID)) | 행/컬럼 값 대입 |  |  |  |
| AC-0e219f9a | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2424 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dRow["p_measure"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.MEASURE)) | 행/컬럼 값 대입 |  |  |  |
| AC-59180b8f | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2425 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dRow["p_yyyymmdd"] | yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-10cfea72 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2426 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dRow["p_to_site"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.TO_SITE)) | 행/컬럼 값 대입 |  |  |  |
| AC-51b7faf4 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2427 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dRow["p_qty"] | val | 행/컬럼 값 대입 |  |  |  |
| AC-c371f3ee | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2428 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dRow["p_origin_from_division_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.ORIGIN_FROM_DIVISION_ID)) | 행/컬럼 값 대입 |  |  |  |
| AC-d8153e98 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2429 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dRow["p_origin_to_division_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.ORIGIN_TO_DIVISION_ID)) | 행/컬럼 값 대입 |  |  |  |
| AC-fd15d48e | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2430 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dRow["p_electrode_type"] | elec_type | 행/컬럼 값 대입 |  |  |  |
| AC-873273aa | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2431 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dRow["p_bucket_type"] | cboBucketType.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-ff4e5c24 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2432 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dRow["p_created_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-1e2dcc1a | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2433 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dRow["p_last_updated_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-e7fe506e | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2434 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dRow["p_time_zone"] | UserInfoContext.Current[UserInfoProperites.TimeZone] | 행/컬럼 값 대입 |  |  |  |
| AC-2b25732a | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2435 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dRow["p_trans_mode"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.TRANSPORT_MODE)) | 행/컬럼 값 대입 |  |  |  |
| AC-2e1d8527 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2436 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dRow["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-2b7f335f | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2437 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dsInput.Tables[0].Rows.Add | (dRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-43245140 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2456 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | saveDS.Tables[0].NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-c168861d | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2457 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dr["A"] | action | 행/컬럼 값 대입 |  |  |  |
| AC-222b5989 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2458 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dr["p_active_flag"] | action | 행/컬럼 값 대입 |  |  |  |
| AC-bef626ac | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2459 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dr["p_division_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.DIVISION_ID)) | 행/컬럼 값 대입 |  |  |  |
| AC-35334218 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2460 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dr["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-0b1b9529 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2461 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dr["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-f37ae870 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2462 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dr["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-f7bae810 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2463 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dr["p_operation_group"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.OPERATION_GROUP)) | 행/컬럼 값 대입 |  |  |  |
| AC-07743804 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2464 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dr["p_item_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.ITEM_ID)) | 행/컬럼 값 대입 |  |  |  |
| AC-1b587fc1 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2465 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dr["p_from_site"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.FROM_SITE)) | 행/컬럼 값 대입 |  |  |  |
| AC-0e00f089 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2466 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dr["p_bod_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.BOD_ID)) | 행/컬럼 값 대입 |  |  |  |
| AC-57b94f0d | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2467 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dr["p_measure"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.MEASURE)) | 행/컬럼 값 대입 |  |  |  |
| AC-7cb0426f | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2470 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dr["p_yyyymmdd"] | yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-aea1165b | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2471 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dr["p_to_site"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.TO_SITE)) | 행/컬럼 값 대입 |  |  |  |
| AC-6371a4e7 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2472 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dr["p_qty"] | strQty | 행/컬럼 값 대입 |  |  |  |
| AC-236b0a89 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2473 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dr["p_origin_from_division_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.ORIGIN_FROM_DIVISION_ID)) | 행/컬럼 값 대입 |  |  |  |
| AC-f97841e0 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2474 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dr["p_origin_to_division_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.ORIGIN_TO_DIVISION_ID)) | 행/컬럼 값 대입 |  |  |  |
| AC-9ab73810 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2482 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dr["p_electrode_type"] | elec_type | 행/컬럼 값 대입 |  |  |  |
| AC-6cbf94a5 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2484 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dr["p_created_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-f78061d9 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2485 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dr["p_last_updated_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-74f8103d | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2486 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dr["p_time_zone"] | UserInfoContext.Current[UserInfoProperites.TimeZone] | 행/컬럼 값 대입 |  |  |  |
| AC-b130e1fc | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2488 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | saveDS.Tables[0].Rows.Add | (dr) | 데이터 객체 조작/조회 |  |  |  |
| AC-62771e9e | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2493 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dsInput.Tables[0].NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-9dba98ef | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2494 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dRow["A"] | action | 행/컬럼 값 대입 |  |  |  |
| AC-fb5b6dd0 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2495 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dRow["p_active_flag"] | action | 행/컬럼 값 대입 |  |  |  |
| AC-5efc230a | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2496 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dRow["p_division_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.DIVISION_ID)) | 행/컬럼 값 대입 |  |  |  |
| AC-7f835352 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2497 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dRow["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-77dd5bb1 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2498 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dRow["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-208487cb | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2499 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dRow["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-c6bd2302 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2500 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dRow["p_operation_group"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.OPERATION_GROUP)) | 행/컬럼 값 대입 |  |  |  |
| AC-6d465503 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2501 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dRow["p_biz_type"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.OPERATION_GROUP)) | 행/컬럼 값 대입 |  |  |  |
| AC-0e600b80 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2502 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dRow["p_item_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.ITEM_ID)) | 행/컬럼 값 대입 |  |  |  |
| AC-7896a578 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2503 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dRow["p_from_site"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.FROM_SITE)) | 행/컬럼 값 대입 |  |  |  |
| AC-5b52d71b | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2504 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dRow["p_bod_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.BOD_ID)) | 행/컬럼 값 대입 |  |  |  |
| AC-40fb36e1 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2505 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dRow["p_measure"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.MEASURE)) | 행/컬럼 값 대입 |  |  |  |
| AC-ab255fa8 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2506 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dRow["p_yyyymmdd"] | yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-976f7b88 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2507 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dRow["p_to_site"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.TO_SITE)) | 행/컬럼 값 대입 |  |  |  |
| AC-a98de5f9 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2508 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dRow["p_qty"] | strQty | 행/컬럼 값 대입 |  |  |  |
| AC-a02aa25f | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2509 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dRow["p_origin_from_division_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.ORIGIN_FROM_DIVISION_ID)) | 행/컬럼 값 대입 |  |  |  |
| AC-0f169a41 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2510 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dRow["p_origin_to_division_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.ORIGIN_TO_DIVISION_ID)) | 행/컬럼 값 대입 |  |  |  |
| AC-8473c7e0 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2511 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dRow["p_electrode_type"] | elec_type | 행/컬럼 값 대입 |  |  |  |
| AC-65595785 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2512 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dRow["p_created_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-7cd8caba | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2513 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dRow["p_last_updated_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-622bd8b8 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2514 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dRow["p_time_zone"] | UserInfoContext.Current[UserInfoProperites.TimeZone] | 행/컬럼 값 대입 |  |  |  |
| AC-cac03b83 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2515 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dRow["p_bucket_type"] | cboBucketType.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-5e2167b0 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2516 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dRow["p_trans_mode"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.TRANSPORT_MODE)) | 행/컬럼 값 대입 |  |  |  |
| AC-efd24bf4 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2517 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dRow["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-d6e394b5 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2518 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dsInput.Tables[0].Rows.Add | (dRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-8d775670 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2524 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | GRID_SET | saveDS.Tables[0].Rows[0]["p_first_row"] | "Y" | 그리드 속성/값 설정 |  |  |  |
| AC-42b748a3 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2525 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | GRID_SET | saveDS.Tables[0].Rows[iCount - 1]["p_last_row"] | "Y" | 그리드 속성/값 설정 |  |  |  |
| AC-7af666f7 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2527 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | saveDS.Tables[0].AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-cde79b44 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2566 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | GRID_STYLE | siMain.SetBGColor | (i, j, i, j, ControlColor.InvalidColor) | 그리드 표시 설정 |  |  |  |
| AC-e1111774 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2567 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | MESSAGE | MessageHelper.GMessageBox | ("MSG00084", new object[] { null }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6719baa9 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2568 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d6f14f9a | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2572 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | GRID_STYLE | siMain.SetBGColor | (i, j, i, j, ControlColor.InvalidColor) | 그리드 표시 설정 |  |  |  |
| AC-375fa464 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2574 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | MESSAGE | MessageHelper.GMessageBox | ("MSG00317", new object[] { message }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-4e264e36 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2575 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3ff44b50 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2579 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dsInput.Tables[0].NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-1f7e7f8f | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2581 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dr["A"] | action | 행/컬럼 값 대입 |  |  |  |
| AC-d56f9bc6 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2582 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dr["p_active_flag"] | action | 행/컬럼 값 대입 |  |  |  |
| AC-ca04b4be | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2583 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dr["p_division_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.DIVISION_ID)) | 행/컬럼 값 대입 |  |  |  |
| AC-abc8ef6a | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2584 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dr["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-e15aeddb | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2585 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dr["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-1917ab3e | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2586 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dr["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-9529a183 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2587 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dr["p_biz_type"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.OPERATION_GROUP)) | 행/컬럼 값 대입 |  |  |  |
| AC-56cc4a57 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2588 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dr["p_operation_group"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.OPERATION_GROUP)) | 행/컬럼 값 대입 |  |  |  |
| AC-d35f4cbc | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2589 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dr["p_item_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.ITEM_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-d7029201 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2590 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dr["p_from_site"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.FROM_SITE)) | 행/컬럼 값 대입 |  |  |  |
| AC-2e1946bd | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2591 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dr["p_bod_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.BOD_ID)) | 행/컬럼 값 대입 |  |  |  |
| AC-11c8e22a | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2592 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dr["p_measure"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.MEASURE)) | 행/컬럼 값 대입 |  |  |  |
| AC-e7c3ccb6 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2593 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dr["p_yyyymmdd"] | strWeekName | 행/컬럼 값 대입 |  |  |  |
| AC-19156548 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2594 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dr["p_to_site"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.TO_SITE)) | 행/컬럼 값 대입 |  |  |  |
| AC-d43edad5 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2595 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dr["p_qty"] | strWeekQty | 행/컬럼 값 대입 |  |  |  |
| AC-b8ba79dd | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2601 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dr["p_origin_from_division_id"] | org_from_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-e9515e40 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2608 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dr["p_origin_to_division_id"] | org_to_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-c4e3ad6c | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2609 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dr["p_electrode_type"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.ELECTRODE_TYPE)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-2b4f83dd | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2611 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dr["p_bucket_type"] | p_bucket | 행/컬럼 값 대입 |  |  |  |
| AC-76d9b95c | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2612 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dr["p_trans_mode"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.TRANSPORT_MODE)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-b37c987e | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2613 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dr["p_created_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-cb10a545 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2614 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dr["p_last_updated_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-daa8f6d7 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2615 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dr["p_time_zone"] | UserInfoContext.Current[UserInfoProperites.TimeZone] | 행/컬럼 값 대입 |  |  |  |
| AC-5c65aa44 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2616 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dr["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-a8cb4805 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2618 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dsInput.Tables[0].Rows.Add | (dr) | 데이터 객체 조작/조회 |  |  |  |
| AC-a3766a3d | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2626 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboDivision.ControlValues.Equals… | DATA_OP | dsInput.Tables[0].AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-e92bf1df | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2658 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboDivision.ControlValues.E… | DATA_OP | saveDS.Tables[0].NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-636022ef | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2659 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboDivision.ControlValues.E… | DATA_OP | dr["A"] | action | 행/컬럼 값 대입 |  |  |  |
| AC-b8a7d7b5 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2660 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboDivision.ControlValues.E… | DATA_OP | dr["p_active_flag"] | action | 행/컬럼 값 대입 |  |  |  |
| AC-504815e9 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2661 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboDivision.ControlValues.E… | DATA_OP | dr["p_division_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.DIVISION_ID)) | 행/컬럼 값 대입 |  |  |  |
| AC-6dcd08e3 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2662 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboDivision.ControlValues.E… | DATA_OP | dr["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-59125a61 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2663 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboDivision.ControlValues.E… | DATA_OP | dr["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-e3547f07 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2664 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboDivision.ControlValues.E… | DATA_OP | dr["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-acf5d1e6 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2665 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboDivision.ControlValues.E… | DATA_OP | dr["p_operation_group"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.OPERATION_GROUP)) | 행/컬럼 값 대입 |  |  |  |
| AC-a376dec9 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2666 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboDivision.ControlValues.E… | DATA_OP | dr["p_item_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.ITEM_ID)) | 행/컬럼 값 대입 |  |  |  |
| AC-2033002a | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2667 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboDivision.ControlValues.E… | DATA_OP | dr["p_from_site"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.FROM_SITE)) | 행/컬럼 값 대입 |  |  |  |
| AC-eb52ffe8 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2668 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboDivision.ControlValues.E… | DATA_OP | dr["p_bod_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.BOD_ID)) | 행/컬럼 값 대입 |  |  |  |
| AC-a25d9dc7 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2669 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboDivision.ControlValues.E… | DATA_OP | dr["p_measure"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.MEASURE)) | 행/컬럼 값 대입 |  |  |  |
| AC-1ba5183a | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2672 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboDivision.ControlValues.E… | DATA_OP | dr["p_yyyymmdd"] | yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-21b03415 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2673 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboDivision.ControlValues.E… | DATA_OP | dr["p_to_site"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.TO_SITE)) | 행/컬럼 값 대입 |  |  |  |
| AC-1fc15d03 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2674 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboDivision.ControlValues.E… | DATA_OP | dr["p_qty"] | 0 | 행/컬럼 값 대입 |  |  |  |
| AC-68b46a73 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2675 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboDivision.ControlValues.E… | DATA_OP | dr["p_origin_from_division_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.ORIGIN_FROM_DIVISION_ID)) | 행/컬럼 값 대입 |  |  |  |
| AC-952dcb94 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2676 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboDivision.ControlValues.E… | DATA_OP | dr["p_origin_to_division_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.ORIGIN_TO_DIVISION_ID)) | 행/컬럼 값 대입 |  |  |  |
| AC-17653ed4 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2683 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboDivision.ControlValues.E… | DATA_OP | dr["p_electrode_type"] | elec_type | 행/컬럼 값 대입 |  |  |  |
| AC-fc9c4907 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2685 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboDivision.ControlValues.E… | DATA_OP | dr["p_created_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-89520f04 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2686 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboDivision.ControlValues.E… | DATA_OP | dr["p_last_updated_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-48d23b92 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2687 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboDivision.ControlValues.E… | DATA_OP | dr["p_time_zone"] | UserInfoContext.Current[UserInfoProperites.TimeZone] | 행/컬럼 값 대입 |  |  |  |
| AC-9048a13b | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2689 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboDivision.ControlValues.E… | DATA_OP | saveDS.Tables[0].Rows.Add | (dr) | 데이터 객체 조작/조회 |  |  |  |
| AC-16af8be7 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2693 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboDivision.ControlValues.E… | DATA_OP | dsInput.Tables[0].NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-c19878eb | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2694 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboDivision.ControlValues.E… | DATA_OP | dRow["A"] | action | 행/컬럼 값 대입 |  |  |  |
| AC-1256bc74 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2695 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboDivision.ControlValues.E… | DATA_OP | dRow["p_active_flag"] | action | 행/컬럼 값 대입 |  |  |  |
| AC-e5ad93aa | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2696 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboDivision.ControlValues.E… | DATA_OP | dRow["p_division_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.DIVISION_ID)) | 행/컬럼 값 대입 |  |  |  |
| AC-7e1297aa | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2697 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboDivision.ControlValues.E… | DATA_OP | dRow["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-31b38451 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2698 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboDivision.ControlValues.E… | DATA_OP | dRow["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-809bc6d8 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2699 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboDivision.ControlValues.E… | DATA_OP | dRow["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-e32d9a9e | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2700 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboDivision.ControlValues.E… | DATA_OP | dRow["p_operation_group"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.OPERATION_GROUP)) | 행/컬럼 값 대입 |  |  |  |
| AC-89fce7ac | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2701 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboDivision.ControlValues.E… | DATA_OP | dRow["p_biz_type"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.OPERATION_GROUP)) | 행/컬럼 값 대입 |  |  |  |
| AC-cf554ac8 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2702 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboDivision.ControlValues.E… | DATA_OP | dRow["p_item_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.ITEM_ID)) | 행/컬럼 값 대입 |  |  |  |
| AC-52f90c59 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2703 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboDivision.ControlValues.E… | DATA_OP | dRow["p_from_site"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.FROM_SITE)) | 행/컬럼 값 대입 |  |  |  |
| AC-0417f4e4 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2704 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboDivision.ControlValues.E… | DATA_OP | dRow["p_bod_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.BOD_ID)) | 행/컬럼 값 대입 |  |  |  |
| AC-d3dff756 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2705 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboDivision.ControlValues.E… | DATA_OP | dRow["p_measure"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.MEASURE)) | 행/컬럼 값 대입 |  |  |  |
| AC-64d68acb | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2706 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboDivision.ControlValues.E… | DATA_OP | dRow["p_yyyymmdd"] | yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-d89e71ab | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2707 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboDivision.ControlValues.E… | DATA_OP | dRow["p_to_site"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.TO_SITE)) | 행/컬럼 값 대입 |  |  |  |
| AC-9465fd89 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2708 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboDivision.ControlValues.E… | DATA_OP | dRow["p_qty"] | 0 | 행/컬럼 값 대입 |  |  |  |
| AC-1b802285 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2709 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboDivision.ControlValues.E… | DATA_OP | dRow["p_origin_from_division_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.ORIGIN_FROM_DIVISION_ID)) | 행/컬럼 값 대입 |  |  |  |
| AC-4226b4d2 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2710 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboDivision.ControlValues.E… | DATA_OP | dRow["p_origin_to_division_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.ORIGIN_TO_DIVISION_ID)) | 행/컬럼 값 대입 |  |  |  |
| AC-46323381 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2711 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboDivision.ControlValues.E… | DATA_OP | dRow["p_electrode_type"] | elec_type | 행/컬럼 값 대입 |  |  |  |
| AC-f442d129 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2712 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboDivision.ControlValues.E… | DATA_OP | dRow["p_created_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-0c870ef0 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2713 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboDivision.ControlValues.E… | DATA_OP | dRow["p_last_updated_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-65213302 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2714 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboDivision.ControlValues.E… | DATA_OP | dRow["p_time_zone"] | UserInfoContext.Current[UserInfoProperites.TimeZone] | 행/컬럼 값 대입 |  |  |  |
| AC-5b888e01 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2715 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboDivision.ControlValues.E… | DATA_OP | dRow["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-13a6a457 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2716 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboDivision.ControlValues.E… | DATA_OP | dsInput.Tables[0].Rows.Add | (dRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-70f6abe3 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2730 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboDivision.ControlValues.E… | DATA_OP | saveDS.Tables[0].NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-e35c46e5 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2731 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboDivision.ControlValues.E… | DATA_OP | dr["A"] | action | 행/컬럼 값 대입 |  |  |  |
| AC-979b0525 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2732 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboDivision.ControlValues.E… | DATA_OP | dr["p_active_flag"] | action | 행/컬럼 값 대입 |  |  |  |
| AC-6776c585 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2733 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboDivision.ControlValues.E… | DATA_OP | dr["p_division_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.DIVISION_ID)) | 행/컬럼 값 대입 |  |  |  |
| AC-9be63096 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2734 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboDivision.ControlValues.E… | DATA_OP | dr["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-e5d7aaf9 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2735 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboDivision.ControlValues.E… | DATA_OP | dr["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-471106da | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2736 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboDivision.ControlValues.E… | DATA_OP | dr["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-d09e2855 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2737 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboDivision.ControlValues.E… | DATA_OP | dr["p_operation_group"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.OPERATION_GROUP)) | 행/컬럼 값 대입 |  |  |  |
| AC-75a4c91b | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2738 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboDivision.ControlValues.E… | DATA_OP | dr["p_item_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.ITEM_ID)) | 행/컬럼 값 대입 |  |  |  |
| AC-9ddb175a | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2739 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboDivision.ControlValues.E… | DATA_OP | dr["p_from_site"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.FROM_SITE)) | 행/컬럼 값 대입 |  |  |  |
| AC-c012a9d6 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2740 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboDivision.ControlValues.E… | DATA_OP | dr["p_bod_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.BOD_ID)) | 행/컬럼 값 대입 |  |  |  |
| AC-28f032a6 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2741 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboDivision.ControlValues.E… | DATA_OP | dr["p_measure"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.MEASURE)) | 행/컬럼 값 대입 |  |  |  |
| AC-0ab3df09 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2744 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboDivision.ControlValues.E… | DATA_OP | dr["p_yyyymmdd"] | yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-45a61b38 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2745 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboDivision.ControlValues.E… | DATA_OP | dr["p_to_site"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.TO_SITE)) | 행/컬럼 값 대입 |  |  |  |
| AC-291164e9 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2746 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboDivision.ControlValues.E… | DATA_OP | dr["p_qty"] | val | 행/컬럼 값 대입 |  |  |  |
| AC-15c3d330 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2747 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboDivision.ControlValues.E… | DATA_OP | dr["p_origin_from_division_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.ORIGIN_FROM_DIVISION_ID)) | 행/컬럼 값 대입 |  |  |  |
| AC-eb82dbc2 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2748 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboDivision.ControlValues.E… | DATA_OP | dr["p_origin_to_division_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.ORIGIN_TO_DIVISION_ID)) | 행/컬럼 값 대입 |  |  |  |
| AC-4ef10606 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2755 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboDivision.ControlValues.E… | DATA_OP | dr["p_electrode_type"] | elec_type | 행/컬럼 값 대입 |  |  |  |
| AC-86eceb56 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2757 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboDivision.ControlValues.E… | DATA_OP | dr["p_created_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-4f80f694 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2758 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboDivision.ControlValues.E… | DATA_OP | dr["p_last_updated_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-ac834323 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2759 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboDivision.ControlValues.E… | DATA_OP | dr["p_time_zone"] | UserInfoContext.Current[UserInfoProperites.TimeZone] | 행/컬럼 값 대입 |  |  |  |
| AC-684cb27b | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2761 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboDivision.ControlValues.E… | DATA_OP | saveDS.Tables[0].Rows.Add | (dr) | 데이터 객체 조작/조회 |  |  |  |
| AC-78a15e71 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2766 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboDivision.ControlValues.E… | DATA_OP | dsInput.Tables[0].NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-d33d8b1d | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2767 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboDivision.ControlValues.E… | DATA_OP | dRow["A"] | action | 행/컬럼 값 대입 |  |  |  |
| AC-56e79a06 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2768 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboDivision.ControlValues.E… | DATA_OP | dRow["p_active_flag"] | action | 행/컬럼 값 대입 |  |  |  |
| AC-ea8ea3fe | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2769 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboDivision.ControlValues.E… | DATA_OP | dRow["p_division_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.DIVISION_ID)) | 행/컬럼 값 대입 |  |  |  |
| AC-737adc07 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2770 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboDivision.ControlValues.E… | DATA_OP | dRow["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-c3d06d39 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2771 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboDivision.ControlValues.E… | DATA_OP | dRow["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-e1659cc8 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2772 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboDivision.ControlValues.E… | DATA_OP | dRow["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-934dca30 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2773 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboDivision.ControlValues.E… | DATA_OP | dRow["p_operation_group"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.OPERATION_GROUP)) | 행/컬럼 값 대입 |  |  |  |
| AC-ad4857a7 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2774 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboDivision.ControlValues.E… | DATA_OP | dRow["p_biz_type"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.OPERATION_GROUP)) | 행/컬럼 값 대입 |  |  |  |
| AC-04e12e7b | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2775 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboDivision.ControlValues.E… | DATA_OP | dRow["p_item_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.ITEM_ID)) | 행/컬럼 값 대입 |  |  |  |
| AC-290e606c | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2776 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboDivision.ControlValues.E… | DATA_OP | dRow["p_from_site"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.FROM_SITE)) | 행/컬럼 값 대입 |  |  |  |
| AC-749780fb | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2777 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboDivision.ControlValues.E… | DATA_OP | dRow["p_bod_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.BOD_ID)) | 행/컬럼 값 대입 |  |  |  |
| AC-6eb5ec46 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2778 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboDivision.ControlValues.E… | DATA_OP | dRow["p_measure"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.MEASURE)) | 행/컬럼 값 대입 |  |  |  |
| AC-ed4ff6d5 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2779 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboDivision.ControlValues.E… | DATA_OP | dRow["p_yyyymmdd"] | yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-4eba6680 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2780 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboDivision.ControlValues.E… | DATA_OP | dRow["p_to_site"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.TO_SITE)) | 행/컬럼 값 대입 |  |  |  |
| AC-2ed31c4a | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2781 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboDivision.ControlValues.E… | DATA_OP | dRow["p_qty"] | val | 행/컬럼 값 대입 |  |  |  |
| AC-f9315962 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2782 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboDivision.ControlValues.E… | DATA_OP | dRow["p_origin_from_division_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.ORIGIN_FROM_DIVISION_ID)) | 행/컬럼 값 대입 |  |  |  |
| AC-fc369c0d | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2783 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboDivision.ControlValues.E… | DATA_OP | dRow["p_origin_to_division_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.ORIGIN_TO_DIVISION_ID)) | 행/컬럼 값 대입 |  |  |  |
| AC-a71e5513 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2784 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboDivision.ControlValues.E… | DATA_OP | dRow["p_electrode_type"] | elec_type | 행/컬럼 값 대입 |  |  |  |
| AC-1949074e | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2785 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboDivision.ControlValues.E… | DATA_OP | dRow["p_created_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-69a79c62 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2786 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboDivision.ControlValues.E… | DATA_OP | dRow["p_last_updated_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-bd6a523d | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2787 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboDivision.ControlValues.E… | DATA_OP | dRow["p_time_zone"] | UserInfoContext.Current[UserInfoProperites.TimeZone] | 행/컬럼 값 대입 |  |  |  |
| AC-df11116d | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2788 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboDivision.ControlValues.E… | DATA_OP | dRow["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-12bfe256 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2789 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboDivision.ControlValues.E… | DATA_OP | dsInput.Tables[0].Rows.Add | (dRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-470ffac2 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2808 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboDivision.ControlValues.E… | DATA_OP | saveDS.Tables[0].NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-3d3e0a3e | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2809 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboDivision.ControlValues.E… | DATA_OP | dr["A"] | action | 행/컬럼 값 대입 |  |  |  |
| AC-7b166ff0 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2810 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboDivision.ControlValues.E… | DATA_OP | dr["p_active_flag"] | action | 행/컬럼 값 대입 |  |  |  |
| AC-9dd63409 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2811 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboDivision.ControlValues.E… | DATA_OP | dr["p_division_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.DIVISION_ID)) | 행/컬럼 값 대입 |  |  |  |
| AC-c14ced58 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2812 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboDivision.ControlValues.E… | DATA_OP | dr["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-5c11c2f4 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2813 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboDivision.ControlValues.E… | DATA_OP | dr["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-a4a9c85d | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2814 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboDivision.ControlValues.E… | DATA_OP | dr["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-d281d780 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2815 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboDivision.ControlValues.E… | DATA_OP | dr["p_operation_group"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.OPERATION_GROUP)) | 행/컬럼 값 대입 |  |  |  |
| AC-56f68cac | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2816 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboDivision.ControlValues.E… | DATA_OP | dr["p_item_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.ITEM_ID)) | 행/컬럼 값 대입 |  |  |  |
| AC-1f542555 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2817 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboDivision.ControlValues.E… | DATA_OP | dr["p_from_site"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.FROM_SITE)) | 행/컬럼 값 대입 |  |  |  |
| AC-a50023b8 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2818 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboDivision.ControlValues.E… | DATA_OP | dr["p_bod_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.BOD_ID)) | 행/컬럼 값 대입 |  |  |  |
| AC-266c3578 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2819 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboDivision.ControlValues.E… | DATA_OP | dr["p_measure"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.MEASURE)) | 행/컬럼 값 대입 |  |  |  |
| AC-d1c5dfb4 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2822 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboDivision.ControlValues.E… | DATA_OP | dr["p_yyyymmdd"] | yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-667203aa | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2823 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboDivision.ControlValues.E… | DATA_OP | dr["p_to_site"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.TO_SITE)) | 행/컬럼 값 대입 |  |  |  |
| AC-c2da19d1 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2824 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboDivision.ControlValues.E… | DATA_OP | dr["p_qty"] | strQty | 행/컬럼 값 대입 |  |  |  |
| AC-7fe7223f | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2825 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboDivision.ControlValues.E… | DATA_OP | dr["p_origin_from_division_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.ORIGIN_FROM_DIVISION_ID)) | 행/컬럼 값 대입 |  |  |  |
| AC-0975aaed | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2826 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboDivision.ControlValues.E… | DATA_OP | dr["p_origin_to_division_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.ORIGIN_TO_DIVISION_ID)) | 행/컬럼 값 대입 |  |  |  |
| AC-7f8a5a7c | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2834 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboDivision.ControlValues.E… | DATA_OP | dr["p_electrode_type"] | elec_type | 행/컬럼 값 대입 |  |  |  |
| AC-1d2dbf25 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2836 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboDivision.ControlValues.E… | DATA_OP | dr["p_created_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-fe442c22 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2837 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboDivision.ControlValues.E… | DATA_OP | dr["p_last_updated_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-db533874 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2838 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboDivision.ControlValues.E… | DATA_OP | dr["p_time_zone"] | UserInfoContext.Current[UserInfoProperites.TimeZone] | 행/컬럼 값 대입 |  |  |  |
| AC-b268c610 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2840 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboDivision.ControlValues.E… | DATA_OP | saveDS.Tables[0].Rows.Add | (dr) | 데이터 객체 조작/조회 |  |  |  |
| AC-f961b984 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2845 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboDivision.ControlValues.E… | DATA_OP | dsInput.Tables[0].NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-1bc2bca6 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2846 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboDivision.ControlValues.E… | DATA_OP | dRow["A"] | action | 행/컬럼 값 대입 |  |  |  |
| AC-69cce501 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2847 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboDivision.ControlValues.E… | DATA_OP | dRow["p_active_flag"] | action | 행/컬럼 값 대입 |  |  |  |
| AC-619f4b27 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2848 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboDivision.ControlValues.E… | DATA_OP | dRow["p_division_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.DIVISION_ID)) | 행/컬럼 값 대입 |  |  |  |
| AC-03ea0a56 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2849 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboDivision.ControlValues.E… | DATA_OP | dRow["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-a036b5ba | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2850 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboDivision.ControlValues.E… | DATA_OP | dRow["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-19984914 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2851 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboDivision.ControlValues.E… | DATA_OP | dRow["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-a0fe9a00 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2852 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboDivision.ControlValues.E… | DATA_OP | dRow["p_operation_group"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.OPERATION_GROUP)) | 행/컬럼 값 대입 |  |  |  |
| AC-6e10747d | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2853 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboDivision.ControlValues.E… | DATA_OP | dRow["p_biz_type"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.OPERATION_GROUP)) | 행/컬럼 값 대입 |  |  |  |
| AC-673362db | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2854 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboDivision.ControlValues.E… | DATA_OP | dRow["p_item_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.ITEM_ID)) | 행/컬럼 값 대입 |  |  |  |
| AC-71f73bec | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2855 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboDivision.ControlValues.E… | DATA_OP | dRow["p_from_site"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.FROM_SITE)) | 행/컬럼 값 대입 |  |  |  |
| AC-1679191a | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2856 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboDivision.ControlValues.E… | DATA_OP | dRow["p_bod_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.BOD_ID)) | 행/컬럼 값 대입 |  |  |  |
| AC-bede511e | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2857 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboDivision.ControlValues.E… | DATA_OP | dRow["p_measure"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.MEASURE)) | 행/컬럼 값 대입 |  |  |  |
| AC-463c6a00 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2858 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboDivision.ControlValues.E… | DATA_OP | dRow["p_yyyymmdd"] | yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-051d2454 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2859 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboDivision.ControlValues.E… | DATA_OP | dRow["p_to_site"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.TO_SITE)) | 행/컬럼 값 대입 |  |  |  |
| AC-c11350a9 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2860 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboDivision.ControlValues.E… | DATA_OP | dRow["p_qty"] | strQty | 행/컬럼 값 대입 |  |  |  |
| AC-8877e69b | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2861 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboDivision.ControlValues.E… | DATA_OP | dRow["p_origin_from_division_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.ORIGIN_FROM_DIVISION_ID)) | 행/컬럼 값 대입 |  |  |  |
| AC-f730c1dd | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2862 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboDivision.ControlValues.E… | DATA_OP | dRow["p_origin_to_division_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.ORIGIN_TO_DIVISION_ID)) | 행/컬럼 값 대입 |  |  |  |
| AC-b9709fc2 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2863 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboDivision.ControlValues.E… | DATA_OP | dRow["p_electrode_type"] | elec_type | 행/컬럼 값 대입 |  |  |  |
| AC-22a0fb6a | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2864 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboDivision.ControlValues.E… | DATA_OP | dRow["p_created_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-999541f6 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2865 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboDivision.ControlValues.E… | DATA_OP | dRow["p_last_updated_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-17150ab9 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2866 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboDivision.ControlValues.E… | DATA_OP | dRow["p_time_zone"] | UserInfoContext.Current[UserInfoProperites.TimeZone] | 행/컬럼 값 대입 |  |  |  |
| AC-c7740c0f | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2867 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboDivision.ControlValues.E… | DATA_OP | dRow["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-55e9a6c3 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2868 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboDivision.ControlValues.E… | DATA_OP | dsInput.Tables[0].Rows.Add | (dRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-a1f536a1 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2874 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboDivision.ControlValues.E… | GRID_SET | saveDS.Tables[0].Rows[0]["p_first_row"] | "Y" | 그리드 속성/값 설정 |  |  |  |
| AC-ad369a52 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2875 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboDivision.ControlValues.E… | GRID_SET | saveDS.Tables[0].Rows[iCount - 1]["p_last_row"] | "Y" | 그리드 속성/값 설정 |  |  |  |
| AC-41448535 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2877 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboDivision.ControlValues.E… | DATA_OP | saveDS.Tables[0].AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-a465fe5b | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2882 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (iCount > 0) | DATA_OP | dsInput.Tables[0].AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-5569eea8 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2907 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (iCount > 0) ▸ try | CALL_EXT | sql.AddParameter | ("@SCP0010", dsInput.Tables[0]) | ⚠ 의미 확인 필요 |  |  |  |
| AC-6b7a1c56 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2911 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (iCount > 0) ▸ try ▸ if (cboDivis… | ENDPOINT | sql.ExcuteProcedure | ("SaveShipmentPlanSemiWeekly") ⇒ biz:AppService.GeneralRunProcedureCustomTable [procedure=SaveShipmentPlanSemiWee… | 엔드포인트 호출 |  |  |  |
| AC-a8b6f5f2 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2915 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (iCount > 0) ▸ try ▸ else of (cbo… | ENDPOINT | sql.ExcuteProcedure | ("SaveShipmentPlanSemiDataset") ⇒ biz:AppService.GeneralRunProcedureCustomTable [procedure=SaveShipmentPlanSemiDat… | 엔드포인트 호출 |  |  |  |
| AC-5c3f00db | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2918 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (iCount > 0) ▸ try | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-5a1b9fd5 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2923 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (iCount > 0) ▸ try ▸ if (result !… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { result.Rows[0]["result_cnt"].ToString() }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-81877e4b | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2932 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (iCount > 0) ▸ try ▸ else of (res… | MESSAGE | MessageHelper.GMessageBox | ("MSG00003", new object[] { ReErrorMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-7ad5357d | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2941 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (iCount > 0) ▸ catch ((Exception … | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-ec0dbbae | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2942 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (iCount > 0) ▸ catch ((Exception … | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-765f7ee7 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2948 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (iCount > 0) ▸ finally ▸ if (!prg… | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-e3d47065 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2996 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-a1cc34f7 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:2998 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-7ff2e589 | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:3002 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-cf30c7be | SaveButton | SCP0010_Shipment_Plan_SEMI.cs:3003 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## SCP0010_Shipment_Plan_SEMI.SCM_SYS_LOG_BATCH

진입점: this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName)) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try] / this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName)) ▸ if (MessageHelper.GMessageBox("MSG00016") == DialogResult.Yes) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try] / SaveButton [if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (iCount > 0) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-de7642d2 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 2 | SCP0010_Shipment_Plan_SEMI.cs:5002 | try | ENDPOINT | new FoxDataRequest | ("SCP.PR_SCM_SYS_LOG_BATCH") ⇒ SCP.PR_SCM_SYS_LOG_BATCH | 엔드포인트 요청 생성 |  |  |  |
| AC-89bd7214 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 2 | SCP0010_Shipment_Plan_SEMI.cs:5003 | try | DATA_OP | request.Parameters["p_program_name"] | p_program_name | 행/컬럼 값 대입 |  |  |  |
| AC-0f389f34 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 2 | SCP0010_Shipment_Plan_SEMI.cs:5004 | try | DATA_OP | request.Parameters["p_log_type"] | p_log_type | 행/컬럼 값 대입 |  |  |  |
| AC-7d224d75 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 2 | SCP0010_Shipment_Plan_SEMI.cs:5005 | try | DATA_OP | request.Parameters["p_log_count"] | p_log_count | 행/컬럼 값 대입 |  |  |  |
| AC-737b073c | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 2 | SCP0010_Shipment_Plan_SEMI.cs:5006 | try | DATA_OP | request.Parameters["p_log_message"] | p_log_message | 행/컬럼 값 대입 |  |  |  |
| AC-06c152c1 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 2 | SCP0010_Shipment_Plan_SEMI.cs:5007 | try | DATA_OP | request.Parameters["p_description"] | p_description | 행/컬럼 값 대입 |  |  |  |
| AC-f67d0222 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 2 | SCP0010_Shipment_Plan_SEMI.cs:5008 | try | DATA_OP | request.Parameters["p_event_date"] | DateTime.Now | 행/컬럼 값 대입 |  |  |  |
| AC-5f80c346 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 2 | SCP0010_Shipment_Plan_SEMI.cs:5010 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## SCP0010_Shipment_Plan_SEMI.Set_FixButtonEnabled

진입점: this.Load / cboPlanDate.SelectedIndexChanged / cboPlanType.SelectedIndexChanged / cboPlanSeq.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a13ac73a | this.Load 외 3 | SCP0010_Shipment_Plan_SEMI.cs:3518 | if (sPlanType.Equals("FN") \|\| sPlanType.Equals("TE")) | STATE | btnFix.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-69ea5b1a | this.Load 외 3 | SCP0010_Shipment_Plan_SEMI.cs:3519 | if (sPlanType.Equals("FN") \|\| sPlanType.Equals("TE")) | STATE | btnUnfix.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-c0678914 | this.Load 외 3 | SCP0010_Shipment_Plan_SEMI.cs:3520 | if (sPlanType.Equals("FN") \|\| sPlanType.Equals("TE")) | STATE | btnNew.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-0944dfc6 | this.Load 외 3 | SCP0010_Shipment_Plan_SEMI.cs:3527 | else of (sPlanType.Equals("FN") \|\| sPlanType.Equals("TE")) ▸ if (!string.IsNullOrEmpty(CString.GetCheckedListValue(dtPlanSeq, cboPlanSeq.C… | DATA_OP | dtPlanSeq.AsEnumerable().Select | (a => a.Field<int>("CODE")) | 데이터 객체 조작/조회 |  |  |  |
| AC-0f4a15f1 | this.Load 외 3 | SCP0010_Shipment_Plan_SEMI.cs:3527 | else of (sPlanType.Equals("FN") \|\| sPlanType.Equals("TE")) ▸ if (!string.IsNullOrEmpty(CString.GetCheckedListValue(dtPlanSeq, cboPlanSeq.C… | DATA_OP | a.Field | ("CODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-e2751422 | this.Load 외 3 | SCP0010_Shipment_Plan_SEMI.cs:3531 | else of (sPlanType.Equals("FN") \|\| sPlanType.Equals("TE")) ▸ if (!string.IsNullOrEmpty(CString.GetCheckedListValue(dtPlanSeq, cboPlanSeq.C… | STATE | btnFix.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-b5881d84 | this.Load 외 3 | SCP0010_Shipment_Plan_SEMI.cs:3532 | else of (sPlanType.Equals("FN") \|\| sPlanType.Equals("TE")) ▸ if (!string.IsNullOrEmpty(CString.GetCheckedListValue(dtPlanSeq, cboPlanSeq.C… | STATE | btnUnfix.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-1510ec69 | this.Load 외 3 | SCP0010_Shipment_Plan_SEMI.cs:3533 | else of (sPlanType.Equals("FN") \|\| sPlanType.Equals("TE")) ▸ if (!string.IsNullOrEmpty(CString.GetCheckedListValue(dtPlanSeq, cboPlanSeq.C… | STATE | btnNew.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-9d6c678c | this.Load 외 3 | SCP0010_Shipment_Plan_SEMI.cs:3537 | else of (sPlanType.Equals("FN") \|\| sPlanType.Equals("TE")) ▸ if (!string.IsNullOrEmpty(CString.GetCheckedListValue(dtPlanSeq, cboPlanSeq.C… | STATE | btnFix.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-9c0daf19 | this.Load 외 3 | SCP0010_Shipment_Plan_SEMI.cs:3538 | else of (sPlanType.Equals("FN") \|\| sPlanType.Equals("TE")) ▸ if (!string.IsNullOrEmpty(CString.GetCheckedListValue(dtPlanSeq, cboPlanSeq.C… | STATE | btnUnfix.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-59b5c3e7 | this.Load 외 3 | SCP0010_Shipment_Plan_SEMI.cs:3539 | else of (sPlanType.Equals("FN") \|\| sPlanType.Equals("TE")) ▸ if (!string.IsNullOrEmpty(CString.GetCheckedListValue(dtPlanSeq, cboPlanSeq.C… | STATE | btnNew.Enabled | false | 컨트롤 상태 Enabled |  |  |  |

## SCP0010_Shipment_Plan_SEMI.Set_FixCellColor

진입점: this.spdMain.CellClick [if ((e.Column == siMain.GetColumnIndex(DefMain.TRANSPORT_MODE) \|\| e.Column == siMain.GetColumnIndex(DefMain.TO_SITE_DESCRIPT…)] / this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName)) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Equals("S")) ▸ try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ if (dsBinding.Tables[2].Rows.Count > 0)] / this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName)) ▸ if …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3ac19eb9 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… 외 6 | SCP0010_Shipment_Plan_SEMI.cs:1178 |  | FLAG | dtFix | dsBinding.Tables[2] | 화면 필드/플래그 변경 |  |  |  |
| AC-fafb79b6 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… 외 6 | SCP0010_Shipment_Plan_SEMI.cs:1193 | for (nRow < siMain.ActiveSheet.Rows.Count) ▸ if (measure.Equals("SHIP_PLAN_AMEND")) | DATA_OP | dtFix.Select | ("key_idx='" + sKey_Idx + "' AND TO_SITE='" + sTo_Site + "' AND bod_id='" + sBod_Id + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-9de9069d | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… 외 6 | SCP0010_Shipment_Plan_SEMI.cs:1201 | for (nRow < siMain.ActiveSheet.Rows.Count) ▸ if (measure.Equals("SHIP_PLAN_AMEND")) ▸ if (res.Count() > 0) ▸ foreach (DataRow dr in res) | GRID_STYLE | siMain.SetBGColor2 | (nRow, siMain.GetColumnIndex(sDay), nRow, siMain.GetColumnIndex(sDay), Color.FromArgb(188,… | 그리드 표시 설정 |  |  |  |
| AC-dea8c97d | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… 외 6 | SCP0010_Shipment_Plan_SEMI.cs:1210 | for (nRow < siMain.ActiveSheet.Rows.Count) ▸ if (measure.Equals("SHIP_PLAN_AMEND")) ▸ if (res.Count() > 0) ▸ foreach (DataRow dr in res) ▸ f… | GRID_STYLE | siMain.SetBGColor2 | (nRow, iCol, nRow, iCol, Color.FromArgb(188, 229, 92)) | 그리드 표시 설정 |  |  |  |

## SCP0010_Shipment_Plan_SEMI.Set_FPOperationColor

진입점: this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName)) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Equals("S")) ▸ try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] / this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName)) ▸ if (MessageHelper.GMessageBox("MSG00016") == DialogResult.Yes) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (result != nul…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f1af6a65 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 5 | SCP0010_Shipment_Plan_SEMI.cs:1163 | for (nRow < siMain.ActiveSheet.Rows.Count) ▸ if (siMain.ActiveSheet.GetText(nRow, siMain.GetColumnIndex(DefMain.MEASURE)).ToString() == "SHI… | GRID_STYLE | siMain.SetBGColor | (nRow, befCol, nRow, nCol - 1, Color.FromArgb(234, 234, 234)) | 그리드 표시 설정 |  |  |  |
| AC-afc2ee63 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 5 | SCP0010_Shipment_Plan_SEMI.cs:1169 | for (nRow < siMain.ActiveSheet.Rows.Count) ▸ if (siMain.ActiveSheet.GetText(nRow, siMain.GetColumnIndex(DefMain.MEASURE)).ToString() == "SHI… | GRID_STYLE | siMain.SetBGColor | (nRow, befCol, nRow, nCol, Color.FromArgb(234, 234, 234)) | 그리드 표시 설정 |  |  |  |

## SCP0010_Shipment_Plan_SEMI.Set_InsertColumnsFont

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-43cc98e9 | (진입점 미연결) | SCP0010_Shipment_Plan_SEMI.cs:3848 | if (bBold) | UI_PROP | range1.Font | new System.Drawing.Font(spdMain.Font.Name, spdMain.Font.Size, FontStyle.Bold) | 속성 Font 설정 |  |  |  |
| AC-abe42b8b | (진입점 미연결) | SCP0010_Shipment_Plan_SEMI.cs:3852 | else of (bBold) | UI_PROP | range1.Font | new System.Drawing.Font(spdMain.Font.Name, spdMain.Font.Size, FontStyle.Regular) | 속성 Font 설정 |  |  |  |

## SCP0010_Shipment_Plan_SEMI.Set_SumValues

진입점: this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName)) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Equals("S")) ▸ try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] / this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName)) ▸ if (MessageHelper.GMessageBox("MSG00016") == DialogResult.Yes) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (result != nul…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-49a872bb | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 4 | SCP0010_Shipment_Plan_SEMI.cs:1261 | for (iRow < dsBinding.Tables[0].Rows.Count) ▸ for (iCol < dsBinding.Tables[0].Columns.Count) ▸ if (colName.IndexOf("M_") == 0) ▸ if (bef_mon… | GRID_SET | dsBinding.Tables[0].Rows[iRow][bef_month_idx] | dsBinding.Tables[0].Rows[iRow][bef_day_idx] | 그리드 속성/값 설정 |  |  |  |
| AC-3c131dd6 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 4 | SCP0010_Shipment_Plan_SEMI.cs:1282 | for (iRow < dsBinding.Tables[0].Rows.Count) ▸ for (iCol < dsBinding.Tables[0].Columns.Count) ▸ else of (colName.IndexOf("M_") == 0) ▸ if (co… | GRID_SET | dsBinding.Tables[0].Rows[iRow][bef_week_idx] | dsBinding.Tables[0].Rows[iRow][bef_day_idx] | 그리드 속성/값 설정 |  |  |  |
| AC-150fa363 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 4 | SCP0010_Shipment_Plan_SEMI.cs:1313 | for (iRow < dsBinding.Tables[0].Rows.Count) ▸ for (iCol < dsBinding.Tables[0].Columns.Count) ▸ else of (colName.IndexOf("M_") == 0) ▸ else o… | GRID_SET | dsBinding.Tables[0].Rows[iRow][bef_week_idx] | dsBinding.Tables[0].Rows[iRow][bef_day_idx] | 그리드 속성/값 설정 |  |  |  |
| AC-32859af7 | this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))… 외 4 | SCP0010_Shipment_Plan_SEMI.cs:1314 | for (iRow < dsBinding.Tables[0].Rows.Count) ▸ for (iCol < dsBinding.Tables[0].Columns.Count) ▸ else of (colName.IndexOf("M_") == 0) ▸ else o… | GRID_SET | dsBinding.Tables[0].Rows[iRow][bef_month_idx] | dsBinding.Tables[0].Rows[iRow][bef_day_idx] | 그리드 속성/값 설정 |  |  |  |

## SCP0010_Shipment_Plan_SEMI.SetChangedControl

진입점: this.Load / cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0b95d962 | this.Load 외 1 | SCP0010_Shipment_Plan_SEMI.cs:808 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ if (!this._division.Substring(0, 2).Equals("EE")) | VALUE_CLEAR | clbElecType.ControlValues | "" | 컨트롤 값 비움 |  |  |  |
| AC-eb43d9c2 | this.Load 외 1 | SCP0010_Shipment_Plan_SEMI.cs:809 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ if (!this._division.Substring(0, 2).Equals("EE")) | STATE | clbElecType.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-529d2c2a | this.Load 외 1 | SCP0010_Shipment_Plan_SEMI.cs:813 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ else of (!this._division.Substring(0, 2).Equals("EE")) | STATE | clbElecType.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## SCP0010_Shipment_Plan_SEMI.SetChangedPeriod

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2dbb32b1 | (진입점 미연결) | SCP0010_Shipment_Plan_SEMI.cs:4596 | if (string.IsNullOrEmpty(strcboPlanDate)) | COMBO_DATA | Data.CallBizCommonData | ("PERIOD_" + value) ⇒ biz:CommonData.CommonDataList [code=PERIOD_{p:value}] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-179d315b | (진입점 미연결) | SCP0010_Shipment_Plan_SEMI.cs:4600 | else of (string.IsNullOrEmpty(strcboPlanDate)) | COMBO_DATA | Data.CallBizCommonData | ("PERIOD2_" + value, strcboPlanDate) ⇒ biz:CommonData.CommonDataList [code=PERIOD2_{p:value}] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-aca77b07 | (진입점 미연결) | SCP0010_Shipment_Plan_SEMI.cs:4603 | if (dt == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2eb345eb | (진입점 미연결) | SCP0010_Shipment_Plan_SEMI.cs:4607 | if (dt.Rows.Count > 0) | UI_PROP | dCalendar.Text1 | dt.Rows[0]["FROM_VALUE"].ToString() | 속성 Text1 설정 |  |  |  |
| AC-e2e66cb1 | (진입점 미연결) | SCP0010_Shipment_Plan_SEMI.cs:4608 | if (dt.Rows.Count > 0) | UI_PROP | dCalendar.Text2 | dt.Rows[0]["TO_VALUE"].ToString() | 속성 Text2 설정 |  |  |  |

## SCP0010_Shipment_Plan_SEMI.SetSpreadColumn

진입점: this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK)] / this.Load / this.chkSum.CheckedChanged [if (siMain != null)] / this.cboBucketType.SelectedIndexChanged [if (chkAll.Checked) ▸ if (siMain != null)] / this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName)) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Equals("S")) ▸ try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] / this.btnUnfix.Click [else of (siMain.IsLock(siMain…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c6aba1ae | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 9 | SCP0010_Shipment_Plan_SEMI.cs:658 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Daily) ▸ if (siObj.GetColumnTag(iCol).IndexOf("D_") … | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-7f9c9ae9 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 9 | SCP0010_Shipment_Plan_SEMI.cs:663 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Daily) ▸ if (siObj.GetColumnTag(iCol).IndexOf("M_") … | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | chkSum.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-a1ddc1dd | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 9 | SCP0010_Shipment_Plan_SEMI.cs:670 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Buc… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-975162fa | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 9 | SCP0010_Shipment_Plan_SEMI.cs:674 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Buc… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-0c705ad9 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 9 | SCP0010_Shipment_Plan_SEMI.cs:679 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Buc… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | chkSum.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-4bb3eb9e | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 9 | SCP0010_Shipment_Plan_SEMI.cs:686 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ else of (cboBucketType.ControlValues =… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-506b9c2c | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 9 | SCP0010_Shipment_Plan_SEMI.cs:690 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ else of (cboBucketType.ControlValues =… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |

## SCP0010_Shipment_Plan_SEMI.SetTableInfo

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3b6f9fc5 | (진입점 미연결) | SCP0010_Shipment_Plan_SEMI.cs:1816 | for (i <= target_idx) ▸ if (i <= target_idx) | DATA_OP | dt.Columns.Add | (dtQty.Columns[i].ColumnName) | 데이터 객체 조작/조회 |  |  |  |
| AC-e35dda43 | (진입점 미연결) | SCP0010_Shipment_Plan_SEMI.cs:1823 | for (i < dtHeader.Rows.Count) | DATA_OP | dt.Columns.Add | (dtHeader.Rows[i][0].ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-034d0d91 | (진입점 미연결) | SCP0010_Shipment_Plan_SEMI.cs:1826 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SCP0010_Shipment_Plan_SEMI.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9c8b6acf | this.spdMain.CellClick | SCP0010_Shipment_Plan_SEMI.cs:4686 | if (e.ColumnHeader \|\| siMain.IsLock(siMain.SheetName)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0010_Shipment_Plan_SEMI.SpdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6a592c2c | this.spdMain.CellDoubleClick | SCP0010_Shipment_Plan_SEMI.cs:4491 |  | CALL_EXT | siMain.SetDblClickColumnShowHide | (sender, e) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0010_Shipment_Plan_SEMI.spdMain_Changed

진입점: dsdm.Changed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a2b8f626 | dsdm.Changed | SCP0010_Shipment_Plan_SEMI.cs:4497 | if (!this.CanModelChange \|\| e.Row == -1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-707f0f7c | dsdm.Changed | SCP0010_Shipment_Plan_SEMI.cs:4511 | try ▸ if (ds == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-375b562b | dsdm.Changed | SCP0010_Shipment_Plan_SEMI.cs:4518 | try ▸ if (strColName == "Action") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b7902dfa | dsdm.Changed | SCP0010_Shipment_Plan_SEMI.cs:4549 | try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strColName.IndexOf("W_") == 0) ▸ if (strMea… | CALL_EXT | DateUtil.GetWeekName | (dateValue.DayOfWeek.ToString()) | ⚠ 의미 확인 필요 |  |  |  |
| AC-dd57452b | dsdm.Changed | SCP0010_Shipment_Plan_SEMI.cs:4551 | try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strColName.IndexOf("W_") == 0) ▸ if (strMea… | GRID_SET | siMain.SetValue | (nRow, iCol, sValue) | 그리드 값 설정 |  |  |  |
| AC-55bda6fa | dsdm.Changed | SCP0010_Shipment_Plan_SEMI.cs:4554 | try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strColName.IndexOf("W_") == 0) ▸ if (strMea… | GRID_SET | siMain.SetValue | (nRow, iCol, 0) | 그리드 값 설정 |  |  |  |

## SCP0010_Shipment_Plan_SEMI.SpdMain_KeyUp

진입점: this.spdMain.KeyUp

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6eb907c4 | this.spdMain.KeyUp | SCP0010_Shipment_Plan_SEMI.cs:602 | if (siMain.GetColumnIndex(DefMain.MEASURE) >= siMain.ActiveColumnIndex) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-25a231fc | this.spdMain.KeyUp | SCP0010_Shipment_Plan_SEMI.cs:606 | if (e.Control == true && e.KeyCode == Keys.V \|\| e.Control == false && e.KeyCode == Keys.V) | CALL_EXT | spdMain.ActiveSheet.ClipboardPaste | (ClipboardPasteOptions.AsStringSkipHidden) | ⚠ 의미 확인 필요 |  |  |  |
| AC-764eb96b | this.spdMain.KeyUp | SCP0010_Shipment_Plan_SEMI.cs:611 | if (e.Control == true && e.KeyCode == Keys.C \|\| e.Control == false && e.KeyCode == Keys.C) | CALL_EXT | Clipboard.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-1185f467 | this.spdMain.KeyUp | SCP0010_Shipment_Plan_SEMI.cs:612 | if (e.Control == true && e.KeyCode == Keys.C \|\| e.Control == false && e.KeyCode == Keys.C) | CALL_EXT | spdMain.Sheets[0].ClipboardCopy | (ClipboardCopyOptions.AsStringSkipHidden) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0010_Shipment_Plan_SEMI.spdMain_TopChange

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-12883200 | (진입점 미연결) | SCP0010_Shipment_Plan_SEMI.cs:4456 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0010_Shipment_Plan_SEMI.SpdMain_TopChange

진입점: this.spdMain.TopChange / this.spdMain.CellClick [if ((e.Column == siMain.GetColumnIndex(DefMain.TRANSPORT_MODE) \|\| e.Column == siMain.GetColumnIndex(DefMain.TO_SITE_DESCRIPT…)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f3fe5be1 | this.spdMain.TopChange 외 1 | SCP0010_Shipment_Plan_SEMI.cs:4718 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0010_Shipment_Plan_SEMI.SubSumMerge

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-351147dc | (진입점 미연결) | SCP0010_Shipment_Plan_SEMI.cs:2034 |  | DATA_OP | dtBinding.Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-345f89ab | (진입점 미연결) | SCP0010_Shipment_Plan_SEMI.cs:2049 | for (iRow <= r2) | DATA_OP | dicSubSumItems.ContainsKey | (target) | 데이터 객체 조작/조회 |  |  |  |
| AC-355ca655 | (진입점 미연결) | SCP0010_Shipment_Plan_SEMI.cs:2051 | for (iRow <= r2) ▸ if (dicSubSumItems.ContainsKey(target)) | DATA_OP | (dicSubSumItems[target]).Add | (iRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-621a5080 | (진입점 미연결) | SCP0010_Shipment_Plan_SEMI.cs:2061 | foreach (var pair in dicSubSumItems) | DATA_OP | tmp.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-fb33f58a | (진입점 미연결) | SCP0010_Shipment_Plan_SEMI.cs:2067 | foreach (var pair in dicSubSumItems) ▸ for (iCol <= subsum_begin) | DATA_OP | dr[iCol] | dtBinding.Rows[r2][iCol] | 행/컬럼 값 대입 |  |  |  |
| AC-389db160 | (진입점 미연결) | SCP0010_Shipment_Plan_SEMI.cs:2073 | foreach (var pair in dicSubSumItems) ▸ for (iCol <= targetColumn) | DATA_OP | dr[iCol] | "Total" | 행/컬럼 값 대입 |  |  |  |
| AC-66893aac | (진입점 미연결) | SCP0010_Shipment_Plan_SEMI.cs:2076 | foreach (var pair in dicSubSumItems) ▸ for (iCol <= targetColumn) ▸ if (iCol == targetColumn) | DATA_OP | dr[iCol] | colName | 행/컬럼 값 대입 |  |  |  |
| AC-5a2ca136 | (진입점 미연결) | SCP0010_Shipment_Plan_SEMI.cs:2087 | foreach (var pair in dicSubSumItems) ▸ for (sCol < dtBinding.Columns.Count) | DATA_OP | dr[sCol] | sum | 행/컬럼 값 대입 |  |  |  |
| AC-7a95ca2e | (진입점 미연결) | SCP0010_Shipment_Plan_SEMI.cs:2090 | foreach (var pair in dicSubSumItems) | DATA_OP | tmp.Rows.Add | (dr) | 데이터 객체 조작/조회 |  |  |  |
| AC-d428af81 | (진입점 미연결) | SCP0010_Shipment_Plan_SEMI.cs:2092 |  | DATA_OP | tmp.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-e412921d | (진입점 미연결) | SCP0010_Shipment_Plan_SEMI.cs:2093 |  | DATA_OP | dtBinding.Merge | (tmp) | 데이터 객체 조작/조회 |  |  |  |
| AC-668f0433 | (진입점 미연결) | SCP0010_Shipment_Plan_SEMI.cs:2099 | foreach (var pair in dicSubSumItems) ▸ if (dicSubSumItems[pair.Key] != null) | CALL_EXT | (dicSubSumItems[pair.Key]).Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-d05f56ac | (진입점 미연결) | SCP0010_Shipment_Plan_SEMI.cs:2103 |  | STATE_RESET | dicSubSum_Range.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-7fd8ad9c | (진입점 미연결) | SCP0010_Shipment_Plan_SEMI.cs:2107 | if (!next_key.Equals("")) | DATA_OP | dicSubSum_Range.Add | (next_key, dtBinding.Rows.Count + 1) | 데이터 객체 조작/조회 |  |  |  |

## SCP0010_Shipment_Plan_SEMI.TotalCellsMerge

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0fd843ff | (진입점 미연결) | SCP0010_Shipment_Plan_SEMI.cs:1623 |  | DATA_OP | list.Add | (siMain.GetColumnIndex(DefMain.TO_SITE_DESCRIPTION)) | 데이터 객체 조작/조회 |  |  |  |
| AC-4c0021a3 | (진입점 미연결) | SCP0010_Shipment_Plan_SEMI.cs:1624 |  | DATA_OP | list.Add | (siMain.GetColumnIndex(DefMain.TRANSPORT_MODE)) | 데이터 객체 조작/조회 |  |  |  |
| AC-65ae034e | (진입점 미연결) | SCP0010_Shipment_Plan_SEMI.cs:1625 |  | DATA_OP | list.Add | (siMain.GetColumnIndex(DefMain.LT_DAY)) | 데이터 객체 조작/조회 |  |  |  |
| AC-1106928d | (진입점 미연결) | SCP0010_Shipment_Plan_SEMI.cs:1650 | for (iRow <= siMain.GetMaxRowIndex()) ▸ if (cur_key_idx != bef_key_idx) ▸ foreach (int idx in list) | UI_PROP | range.HorizontalAlignment | CellHorizontalAlignment.Center | 속성 HorizontalAlignment 설정 |  |  |  |
| AC-97670dc8 | (진입점 미연결) | SCP0010_Shipment_Plan_SEMI.cs:1651 | for (iRow <= siMain.GetMaxRowIndex()) ▸ if (cur_key_idx != bef_key_idx) ▸ foreach (int idx in list) | UI_PROP | range.ForeColor | Color.Black | 속성 ForeColor 설정 |  |  |  |
| AC-7ec3097f | (진입점 미연결) | SCP0010_Shipment_Plan_SEMI.cs:1652 | for (iRow <= siMain.GetMaxRowIndex()) ▸ if (cur_key_idx != bef_key_idx) ▸ foreach (int idx in list) | UI_PROP | range.RowSpan | rowSpan_Count | 속성 RowSpan 설정 |  |  |  |
| AC-784ba113 | (진입점 미연결) | SCP0010_Shipment_Plan_SEMI.cs:1656 | for (iRow <= siMain.GetMaxRowIndex()) ▸ if (cur_key_idx != bef_key_idx) | UI_PROP | boh.HorizontalAlignment | CellHorizontalAlignment.Center | 속성 HorizontalAlignment 설정 |  |  |  |
| AC-80290fd7 | (진입점 미연결) | SCP0010_Shipment_Plan_SEMI.cs:1657 | for (iRow <= siMain.GetMaxRowIndex()) ▸ if (cur_key_idx != bef_key_idx) | UI_PROP | boh.RowSpan | bohSpan_Count | 속성 RowSpan 설정 |  |  |  |
| AC-885a6d68 | (진입점 미연결) | SCP0010_Shipment_Plan_SEMI.cs:1687 | for (iRow <= siMain.GetMaxRowIndex()) ▸ if (iRow == siMain.GetMaxRowIndex()) ▸ if (isSum) ▸ foreach (int idx in list) | UI_PROP | range.HorizontalAlignment | CellHorizontalAlignment.Center | 속성 HorizontalAlignment 설정 |  |  |  |
| AC-b0670a68 | (진입점 미연결) | SCP0010_Shipment_Plan_SEMI.cs:1688 | for (iRow <= siMain.GetMaxRowIndex()) ▸ if (iRow == siMain.GetMaxRowIndex()) ▸ if (isSum) ▸ foreach (int idx in list) | UI_PROP | range.ForeColor | Color.Black | 속성 ForeColor 설정 |  |  |  |
| AC-a3288dc9 | (진입점 미연결) | SCP0010_Shipment_Plan_SEMI.cs:1689 | for (iRow <= siMain.GetMaxRowIndex()) ▸ if (iRow == siMain.GetMaxRowIndex()) ▸ if (isSum) ▸ foreach (int idx in list) | UI_PROP | range.RowSpan | rowSpan_Count | 속성 RowSpan 설정 |  |  |  |
| AC-65e4e78e | (진입점 미연결) | SCP0010_Shipment_Plan_SEMI.cs:1693 | for (iRow <= siMain.GetMaxRowIndex()) ▸ if (iRow == siMain.GetMaxRowIndex()) ▸ if (isSum) | UI_PROP | boh.HorizontalAlignment | CellHorizontalAlignment.Center | 속성 HorizontalAlignment 설정 |  |  |  |
| AC-beff8e8b | (진입점 미연결) | SCP0010_Shipment_Plan_SEMI.cs:1694 | for (iRow <= siMain.GetMaxRowIndex()) ▸ if (iRow == siMain.GetMaxRowIndex()) ▸ if (isSum) | UI_PROP | boh.RowSpan | bohSpan_Count | 속성 RowSpan 설정 |  |  |  |

## SCP0010_Shipment_Plan_SEMI.ValidateUserInput

진입점: SaveButton [if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (iRow < siMain.ActiveSheet.Rows.Count) ▸ if (action == CAppSetting.FlagI && measure_name.Equals("SHIP_PLAN_AMEND")) ▸ for (c < siMain.GetMaxColumnIndex()) ▸ if (!string.IsNullOrEmpty(val)) ▸ if (nDayQty < 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3644c0be | SaveButton [if (fps.Name == spdMain.Name) ▸ if (siMain != nu… | SCP0010_Shipment_Plan_SEMI.cs:3554 | if (action_name.Equals("NO_DATA")) ▸ if (siMain.ActiveSheet.RowCount <= 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00059") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-33bd8ba5 | SaveButton [if (fps.Name == spdMain.Name) ▸ if (siMain != nu… | SCP0010_Shipment_Plan_SEMI.cs:3561 | else of (action_name.Equals("NO_DATA")) ▸ if (action_name.Equals("NO_CHECKED")) | MESSAGE | MessageHelper.GMessageBox | ("MSG00017") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-2d080f5b | SaveButton [if (fps.Name == spdMain.Name) ▸ if (siMain != nu… | SCP0010_Shipment_Plan_SEMI.cs:3575 | else of (action_name.Equals("NO_DATA")) ▸ else of (action_name.Equals("NO_CHECKED")) ▸ if (action_name.Equals("CHK_PERIOD")) ▸ if (DateTime.… | MESSAGE | MessageHelper.GMessageBox | ("MSG00171") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-bf7f09b4 | SaveButton [if (fps.Name == spdMain.Name) ▸ if (siMain != nu… | SCP0010_Shipment_Plan_SEMI.cs:3577 | else of (action_name.Equals("NO_DATA")) ▸ else of (action_name.Equals("NO_CHECKED")) ▸ if (action_name.Equals("CHK_PERIOD")) ▸ if (DateTime.… | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |
| AC-0a61b9d5 | SaveButton [if (fps.Name == spdMain.Name) ▸ if (siMain != nu… | SCP0010_Shipment_Plan_SEMI.cs:3583 | else of (action_name.Equals("NO_DATA")) ▸ else of (action_name.Equals("NO_CHECKED")) ▸ if (action_name.Equals("CHK_PERIOD")) ▸ if (diff.Days… | MESSAGE | MessageHelper.GMessageBox | ("MSG00172", new object[] { 364 }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-99c83d9f | SaveButton [if (fps.Name == spdMain.Name) ▸ if (siMain != nu… | SCP0010_Shipment_Plan_SEMI.cs:3590 | else of (action_name.Equals("NO_DATA")) ▸ else of (action_name.Equals("NO_CHECKED")) ▸ else of (action_name.Equals("CHK_PERIOD")) ▸ if (acti… | MESSAGE | MessageHelper.GMessageBox | ("MSG00084") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-421fd768 | SaveButton [if (fps.Name == spdMain.Name) ▸ if (siMain != nu… | SCP0010_Shipment_Plan_SEMI.cs:3597 | else of (action_name.Equals("NO_DATA")) ▸ else of (action_name.Equals("NO_CHECKED")) ▸ else of (action_name.Equals("CHK_PERIOD")) ▸ else of … | MESSAGE | MessageHelper.GMessageBox | ("MSG00233") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e9ef682d | SaveButton [if (fps.Name == spdMain.Name) ▸ if (siMain != nu… | SCP0010_Shipment_Plan_SEMI.cs:3603 | else of (action_name.Equals("NO_DATA")) ▸ else of (action_name.Equals("NO_CHECKED")) ▸ else of (action_name.Equals("CHK_PERIOD")) ▸ else of … | MESSAGE | MessageHelper.GMessageBox | ("MSG00317", new object[] { "100,000,000" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-5eb56e75 | SaveButton [if (fps.Name == spdMain.Name) ▸ if (siMain != nu… | SCP0010_Shipment_Plan_SEMI.cs:3606 |  | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |

