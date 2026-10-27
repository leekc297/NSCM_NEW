# AS-IS 액션 대조표 — SSP0010

> 원천: `Doc/asisfacts/screens/SSP0010/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 505행 · 메서드 53 · 종류 DATA_OP 231 · RETURN 34 · GRID_SET 34 · UI_PROP 32 · GRID_INIT 20 · MESSAGE 19 · FLAG 18 · CALL_EXT 17 · ENDPOINT 15 · POPUP 13 · UI_MISC 13 · VALUE_SET 10 · LIST_REBIND 10 · COMBO_DATA 9 · STATE 8 · GRID_LOCK 7 · GRID_STYLE 4 · GRID_CLEAR 3 · VALIDATE 3 · GRID_BIND 2 · STATE_RESET 2 · VALUE_CLEAR 1 · ⚠ 의미 확인 필요 17


## Calc_Measure..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-55edc921 | .ctor | SSP0010_Shipment_Plan_SEMI.cs:2896 |  | FLAG | this._header_last_idx | header_last_idx | 화면 필드/플래그 변경 |  |  |  |
| AC-2f6daecc | .ctor | SSP0010_Shipment_Plan_SEMI.cs:2901 | foreach (var item in list) | DATA_OP | _inputMeasure.Add | (item, new List<int>()) | 데이터 객체 조작/조회 |  |  |  |

## Calc_Measure.RetDoubleValue

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fc0f5c56 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:3121 |  | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |

## Calc_Measure.RetIntValue

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5cf10bac | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:3103 |  | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |

## Calc_Measure.RetLongValue

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0a7bcc25 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:3110 | if (obj.ToString() != "" && obj != null && obj != DBNull.Value) | CALL_EXT | Convert.ToInt64 | (obj) | ⚠ 의미 확인 필요 |  |  |  |
| AC-67efe5e2 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:3112 |  | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |

## Calc_Measure.SetCalcMeasure

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d29a391a | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:2967 | for (col < dtBinding.Columns.Count) ▸ for (iRow < end_row) ▸ if (measure_name.Equals("INVENTORY")) ▸ if (dtBinding.Columns[col].ColumnName.I… | GRID_SET | dtBinding.Rows[iRow][bef_Month_Idx] | sum | 그리드 속성/값 설정 |  |  |  |
| AC-13c42d0b | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:2974 | for (col < dtBinding.Columns.Count) ▸ for (iRow < end_row) ▸ if (measure_name.Equals("INVENTORY")) ▸ if (dtBinding.Columns[col].ColumnName.I… | GRID_SET | dtBinding.Rows[iRow][col] | sum | 그리드 속성/값 설정 |  |  |  |
| AC-94254dff | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:2994 | for (col < dtBinding.Columns.Count) ▸ for (iRow < end_row) ▸ if (measure_name.Equals("INVENTORY")) ▸ else of (dtBinding.Columns[col].ColumnN… | GRID_SET | dtBinding.Rows[iRow][bef_Week_idx] | sum | 그리드 속성/값 설정 |  |  |  |
| AC-90c78b8a | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:3001 | for (col < dtBinding.Columns.Count) ▸ for (iRow < end_row) ▸ if (measure_name.Equals("INVENTORY")) ▸ else of (dtBinding.Columns[col].ColumnN… | GRID_SET | dtBinding.Rows[iRow][col] | sum | 그리드 속성/값 설정 |  |  |  |
| AC-f42b51c9 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:3027 | for (col < dtBinding.Columns.Count) ▸ for (iRow < end_row) ▸ if (measure_name.Equals("INVENTORY")) ▸ else of (dtBinding.Columns[col].ColumnN… | GRID_SET | dtBinding.Rows[iRow][col] | sum | 그리드 속성/값 설정 |  |  |  |
| AC-48739f76 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:3043 | for (col < dtBinding.Columns.Count) ▸ for (iRow < end_row) ▸ if (measure_name.Equals("INVENTORY")) ▸ else of (dtBinding.Columns[col].ColumnN… | GRID_SET | dtBinding.Rows[iRow][bef_Week_idx] | last_sum | 그리드 속성/값 설정 |  |  |  |
| AC-348f5916 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:3050 | for (col < dtBinding.Columns.Count) ▸ for (iRow < end_row) ▸ if (measure_name.Equals("INVENTORY")) ▸ else of (dtBinding.Columns[col].ColumnN… | GRID_SET | dtBinding.Rows[iRow][col] | last_sum | 그리드 속성/값 설정 |  |  |  |
| AC-c3e31301 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:3065 | for (col < dtBinding.Columns.Count) ▸ for (iRow < end_row) ▸ else of (measure_name.Equals("INVENTORY")) ▸ if (to_site_name.Length > 2) | DATA_OP | _inputMeasure[measure_name].Add | (iRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-1ba30945 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:3085 | for (col < dtBinding.Columns.Count) ▸ for (iRow < end_row) ▸ else of (measure_name.Equals("INVENTORY")) ▸ else of (to_site_name.Length > 2) | GRID_SET | dtBinding.Rows[iRow][col] | sum | 그리드 속성/값 설정 |  |  |  |
| AC-6104c7e1 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:3086 | for (col < dtBinding.Columns.Count) ▸ for (iRow < end_row) ▸ else of (measure_name.Equals("INVENTORY")) ▸ else of (to_site_name.Length > 2) | CALL_EXT | _inputMeasure[measure_name].Clear | () | ⚠ 의미 확인 필요 |  |  |  |

## SSP0010_Shipment_Plan_SEMI.BlockCellsChecking

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d36bbfb4 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1981 | for (iRow < siMain.ActiveSheet.RowCount) | GRID_LOCK | siMain.LockRange | (iRow, 1, iRow, this._LastHeader_Idx, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-3c233653 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1995 | for (iRow < siMain.ActiveSheet.RowCount) ▸ if (siMain.GetValue(iRow, measure_idx).Equals("SHIP_PLAN_AMEND") && siMain.GetValue(iRow, site_id… | GRID_LOCK | siMain.LockRange | (iRow, this._LastHeader_Idx, iRow, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-ea304775 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:2008 | for (iRow < siMain.ActiveSheet.RowCount) ▸ if (siMain.GetValue(iRow, measure_idx).Equals("SHIP_PLAN_AMEND") && siMain.GetValue(iRow, site_id… | GRID_LOCK | siMain.LockRange | (iRow, iCol, iRow, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-8d718ac8 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:2017 | for (iRow < siMain.ActiveSheet.RowCount) ▸ if (siMain.GetValue(iRow, measure_idx).Equals("SHIP_PLAN_AMEND") && siMain.GetValue(iRow, site_id… | GRID_LOCK | siMain.LockRange | (iRow, iCol, iRow, iCol, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-d858b4b0 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:2022 | for (iRow < siMain.ActiveSheet.RowCount) ▸ if (siMain.GetValue(iRow, measure_idx).Equals("SHIP_PLAN_AMEND") && siMain.GetValue(iRow, site_id… | GRID_LOCK | siMain.LockRange | (iRow, iCol, iRow, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-2a5d8c48 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:2029 | for (iRow < siMain.ActiveSheet.RowCount) ▸ else of (siMain.GetValue(iRow, measure_idx).Equals("SHIP_PLAN_AMEND") && siMain.GetValue(iRow, si… | GRID_LOCK | siMain.LockRange | (iRow, 1, iRow, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |

## SSP0010_Shipment_Plan_SEMI.BtnFix_Click

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d3a1fd9a | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:2846 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-dbdf5b3e | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:2847 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a32a3b39 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:2853 | if (siMain.IsLock(siMain.SheetName)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00010") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SSP0010_Shipment_Plan_SEMI.BtnItem_Id_Click

진입점: this.btnItem_Id.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9c5eadb9 | this.btnItem_Id.Click | SSP0010_Shipment_Plan_SEMI.cs:2825 |  | POPUP | new SCM0002_ItembyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-42d71804 | this.btnItem_Id.Click | SSP0010_Shipment_Plan_SEMI.cs:2827 |  | POPUP | popItem.Form_Load | (true, sdivision, sScmSite, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-24e16448 | this.btnItem_Id.Click | SSP0010_Shipment_Plan_SEMI.cs:2828 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-9f359f66 | this.btnItem_Id.Click | SSP0010_Shipment_Plan_SEMI.cs:2829 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-1db0f22d | this.btnItem_Id.Click | SSP0010_Shipment_Plan_SEMI.cs:2835 | if (popItem.ItemID != "") | VALUE_SET | txtItemId.Text | sItemId | 컨트롤 값 설정 |  |  |  |

## SSP0010_Shipment_Plan_SEMI.btnMeasure_Click

진입점: this.btnMeasure.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a2b82125 | this.btnMeasure.Click | SSP0010_Shipment_Plan_SEMI.cs:2752 |  | POPUP | new SCM0002_TitleSetForm_Popup | ("SSP0010", measureType, false) | 팝업/폼 생성 |  |  |  |
| AC-66c12ffd | this.btnMeasure.Click | SSP0010_Shipment_Plan_SEMI.cs:2753 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-01991bbb | this.btnMeasure.Click | SSP0010_Shipment_Plan_SEMI.cs:2754 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-c5be35e8 | this.btnMeasure.Click | SSP0010_Shipment_Plan_SEMI.cs:2758 | if (frm.DialogResult == DialogResult.OK) | UI_PROP | this.CanModelChange | false | 속성 CanModelChange 설정 |  |  |  |
| AC-ecd1d9da | this.btnMeasure.Click | SSP0010_Shipment_Plan_SEMI.cs:2761 | if (frm.DialogResult == DialogResult.OK) | UI_PROP | this.CanModelChange | true | 속성 CanModelChange 설정 |  |  |  |

## SSP0010_Shipment_Plan_SEMI.BtnUnfix_Click

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5a49802a | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:2868 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8f97bd3c | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:2869 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9aa8462f | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:2875 | if (siMain.IsLock(siMain.SheetName)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00010") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-22d9886e | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:2879 | else of (siMain.IsLock(siMain.SheetName)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00016") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SSP0010_Shipment_Plan_SEMI.cboOperGrp_SelectedIndexChanged

진입점: this.cboOperGroup.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4c16573b | this.cboOperGroup.SelectedIndexChanged | SSP0010_Shipment_Plan_SEMI.cs:2693 |  | FLAG | this._curSheetName | cboOperGroup.Text.ToUpper() | 화면 필드/플래그 변경 |  |  |  |

## SSP0010_Shipment_Plan_SEMI.CboPlanDate_SelectedIndexChanged

진입점: cboPlanDate.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-081a6fa9 | cboPlanDate.SelectedIndexChanged | SSP0010_Shipment_Plan_SEMI.cs:2800 |  | FLAG | dtPlanTypeShip | Data.Common(Data.Type.PlanTypeShip, false, pDivisionID, pPlanDate) ⇒ biz:CommonData.CommonDataList [code=PlanTypeShip] | 화면 필드/플래그 변경 |  |  |  |
| AC-0a3c513d | cboPlanDate.SelectedIndexChanged | SSP0010_Shipment_Plan_SEMI.cs:2800 |  | COMBO_DATA | Data.Common | (Data.Type.PlanTypeShip, false, pDivisionID, pPlanDate) ⇒ biz:CommonData.CommonDataList [code=PlanTypeShip] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-55d816b8 | cboPlanDate.SelectedIndexChanged | SSP0010_Shipment_Plan_SEMI.cs:2801 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanTypeShip, cboPlanType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-00f94f60 | cboPlanDate.SelectedIndexChanged | SSP0010_Shipment_Plan_SEMI.cs:2803 |  | VALUE_SET | cboPlanType.SelectedIndex | dtPlanTypeShip.Rows.Count - 1 | 컨트롤 값 설정 |  |  |  |
| AC-eeb5ff2b | cboPlanDate.SelectedIndexChanged | SSP0010_Shipment_Plan_SEMI.cs:2805 |  | VALUE_SET | drpPeriod.InitValue | GetDayRange() | 컨트롤 값 설정 |  |  |  |
| AC-1af8ab97 | cboPlanDate.SelectedIndexChanged | SSP0010_Shipment_Plan_SEMI.cs:2806 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |

## SSP0010_Shipment_Plan_SEMI.CboPlanSeq_SelectedIndexChanged

진입점: cboPlanSeq.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3c0c289b | cboPlanSeq.SelectedIndexChanged | SSP0010_Shipment_Plan_SEMI.cs:495 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |

## SSP0010_Shipment_Plan_SEMI.CboPlanType_SelectedIndexChanged

진입점: cboPlanType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fc8de8ee | cboPlanType.SelectedIndexChanged | SSP0010_Shipment_Plan_SEMI.cs:2784 |  | FLAG | dtPlanSeqShip | Data.Common(Data.Type.PlanSeqShip, false, pDivisionID, pPlanDate, pPlanType) ⇒ biz:CommonData.CommonDataList [code=PlanSeqShip] | 화면 필드/플래그 변경 |  |  |  |
| AC-41e72994 | cboPlanType.SelectedIndexChanged | SSP0010_Shipment_Plan_SEMI.cs:2784 |  | COMBO_DATA | Data.Common | (Data.Type.PlanSeqShip, false, pDivisionID, pPlanDate, pPlanType) ⇒ biz:CommonData.CommonDataList [code=PlanSeqShip] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-d1f05674 | cboPlanType.SelectedIndexChanged | SSP0010_Shipment_Plan_SEMI.cs:2785 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanSeqShip, cboPlanSeq, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-826452a5 | cboPlanType.SelectedIndexChanged | SSP0010_Shipment_Plan_SEMI.cs:2787 |  | VALUE_SET | cboPlanSeq.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-8571f1bb | cboPlanType.SelectedIndexChanged | SSP0010_Shipment_Plan_SEMI.cs:2790 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |

## SSP0010_Shipment_Plan_SEMI.CreateBindingDataSet

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c3bfd2eb | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1351 | if (dtQty.Rows.Count == 0) | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-50fd0472 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1359 |  | DATA_OP | dtBinding.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-3ad3fa59 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1360 |  | DATA_OP | ds.Tables.Add | (dtBinding) | 데이터 객체 조작/조회 |  |  |  |
| AC-645a6a3e | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1361 |  | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |

## SSP0010_Shipment_Plan_SEMI.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dd573930 | this.Load | SSP0010_Shipment_Plan_SEMI.cs:288 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 3, 1, 20) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-2259bce4 | this.Load | SSP0010_Shipment_Plan_SEMI.cs:289 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-164b33c5 | this.Load | SSP0010_Shipment_Plan_SEMI.cs:290 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SSP0010_Shipment_Plan_SEMI.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9f60582d | this.Load | SSP0010_Shipment_Plan_SEMI.cs:216 |  | UI_PROP | pnlCondition.Height | 75 | 속성 Height 설정 |  |  |  |
| AC-f12bdb0a | this.Load | SSP0010_Shipment_Plan_SEMI.cs:220 |  | DATA_OP | dicSubSumItems.Add | ("SHIP_PLAN", new List<int>()) | 데이터 객체 조작/조회 |  |  |  |
| AC-42c7fe08 | this.Load | SSP0010_Shipment_Plan_SEMI.cs:221 |  | DATA_OP | dicSubSumItems.Add | ("SHIP_REQ", new List<int>()) | 데이터 객체 조작/조회 |  |  |  |
| AC-17d5d9b4 | this.Load | SSP0010_Shipment_Plan_SEMI.cs:222 |  | DATA_OP | dicSubSumItems.Add | ("SHIP_PLAN_AMEND", new List<int>()) | 데이터 객체 조작/조회 |  |  |  |
| AC-c8e14865 | this.Load | SSP0010_Shipment_Plan_SEMI.cs:232 |  | DATA_OP | dicInputMeasure.Add | ("T", new SortedList<int, string> { { 1, "SHIP_REQ" }, { 2, "SHIP_PLAN" }, { 3, "SHIP_PLAN… | 데이터 객체 조작/조회 |  |  |  |
| AC-c4225cd3 | this.Load | SSP0010_Shipment_Plan_SEMI.cs:242 |  | DATA_OP | dicElecInputMeasure.Add | (1, new Dictionary<string, string> { { "SHIP_REQ_QTY", "Ship Req(Cell Qty)" } }) | 데이터 객체 조작/조회 |  |  |  |
| AC-8a3da631 | this.Load | SSP0010_Shipment_Plan_SEMI.cs:243 |  | DATA_OP | dicElecInputMeasure.Add | (2, new Dictionary<string, string> { { "SHIP_PLAN_QTY", "Ship Plan(Cell Qty)" } }) | 데이터 객체 조작/조회 |  |  |  |
| AC-e70bfe26 | this.Load | SSP0010_Shipment_Plan_SEMI.cs:244 |  | DATA_OP | dicElecInputMeasure.Add | (3, new Dictionary<string, string> { { "SHIP_PLAN_AMEND_QTY", "Ship Plan Amend(Cell Qty)" … | 데이터 객체 조작/조회 |  |  |  |
| AC-2c874a42 | this.Load | SSP0010_Shipment_Plan_SEMI.cs:246 |  | DATA_OP | dicInputMeasure.Add | ("S", new SortedList<int, string> { { 1, "CHAR_COMPLETED_QTY" }, { 2, "INVENTORY" }, { 3, … | 데이터 객체 조작/조회 |  |  |  |
| AC-f53dfdbc | this.Load | SSP0010_Shipment_Plan_SEMI.cs:248 |  | VALUE_SET | cboBucketType.ControlValues | BucketType.Daily | 컨트롤 값 설정 |  |  |  |
| AC-f283cdf9 | this.Load | SSP0010_Shipment_Plan_SEMI.cs:250 |  | FLAG | this._LastHeader_Idx | siMain.GetColumnIndex(DefMain.TO_YYYYMMDD) + 1 | 화면 필드/플래그 변경 |  |  |  |

## SSP0010_Shipment_Plan_SEMI.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-eb6a80fd | Dispose | SSP0010_Shipment_Plan_SEMI.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SSP0010_Shipment_Plan_SEMI.EditBlockChecking

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ed290480 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1287 | if (number == 1) ▸ for (cols <= siMain.GetMaxColumnIndex()) | DATA_OP | dateColumn.Contains | ("W_") | 데이터 객체 조작/조회 |  |  |  |
| AC-f144d8a4 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1291 | if (number == 1) ▸ for (cols <= siMain.GetMaxColumnIndex()) ▸ else of (dateColumn.Contains("W_")) | DATA_OP | dateColumn.Contains | ("D_") | 데이터 객체 조작/조회 |  |  |  |
| AC-6e66ece1 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1315 | if (number == 1) | RETURN | return retIndex == 0 ? siMain.GetMaxColumnIndex() : retIndex; |  | 처리 중단/반환 |  |  |  |
| AC-068c7ec2 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1324 |  | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |

## SSP0010_Shipment_Plan_SEMI.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-56c6b1e8 | EditButton | SSP0010_Shipment_Plan_SEMI.cs:705 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-5b989d54 | EditButton | SSP0010_Shipment_Plan_SEMI.cs:706 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SSP0010_Shipment_Plan_SEMI.FindData_Main

진입점: FindButton / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3c27d473 | FindButton 외 1 | SSP0010_Shipment_Plan_SEMI.cs:721 |  | VALIDATE | DataUtil.checkRequired | (this.pnlCondition) | 프레임워크 검증 |  |  |  |
| AC-fc6de6f0 | FindButton 외 1 | SSP0010_Shipment_Plan_SEMI.cs:721 | if (!DataUtil.checkRequired(this.pnlCondition)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5cc9089f | FindButton 외 1 | SSP0010_Shipment_Plan_SEMI.cs:722 |  | VALIDATE | DateUtil.Check_PeriodDate | (drpPeriod) | 프레임워크 검증 |  |  |  |
| AC-2636eb73 | FindButton 외 1 | SSP0010_Shipment_Plan_SEMI.cs:722 | if (!DateUtil.Check_PeriodDate(drpPeriod)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c09b679f | FindButton 외 1 | SSP0010_Shipment_Plan_SEMI.cs:751 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-0e93c585 | FindButton 외 1 | SSP0010_Shipment_Plan_SEMI.cs:754 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-53d9e7ae | FindButton 외 1 | SSP0010_Shipment_Plan_SEMI.cs:758 | try | UI_PROP | proxyPivot.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-10d74cbf | FindButton 외 1 | SSP0010_Shipment_Plan_SEMI.cs:760 | try | FLAG | dsBinding | await proxyPivot.ExecuteAsync<DataSet>(() => { using (var client = new FoxDataClient(CAppS… | 화면 필드/플래그 변경 |  |  |  |
| AC-188e5499 | FindButton 외 1 | SSP0010_Shipment_Plan_SEMI.cs:760 | try | ENDPOINT | proxyPivot.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, GSCM_SSP_PLAN_S… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-c6347fc3 | FindButton 외 1 | SSP0010_Shipment_Plan_SEMI.cs:763 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SSP.SSP0010_GET_SHIPMENT_PLAN_SEMI_SSP") ⇒ SSP.SSP0010_GET_SHIPMENT_PLAN_SEMI_SSP | 엔드포인트 요청 생성 |  |  |  |
| AC-05c7efcf | FindButton 외 1 | SSP0010_Shipment_Plan_SEMI.cs:764 | try ▸ lambda | UI_PROP | req.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-7d54aa7b | FindButton 외 1 | SSP0010_Shipment_Plan_SEMI.cs:765 | try ▸ lambda | DATA_OP | req.Parameters["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-c66cec76 | FindButton 외 1 | SSP0010_Shipment_Plan_SEMI.cs:766 | try ▸ lambda | DATA_OP | req.Parameters["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-fe89a6dc | FindButton 외 1 | SSP0010_Shipment_Plan_SEMI.cs:767 | try ▸ lambda | DATA_OP | req.Parameters["p_division_id"] | pDivisionID | 행/컬럼 값 대입 |  |  |  |
| AC-0992e825 | FindButton 외 1 | SSP0010_Shipment_Plan_SEMI.cs:768 | try ▸ lambda | DATA_OP | req.Parameters["p_operation_group"] | pOperationGroup | 행/컬럼 값 대입 |  |  |  |
| AC-c4f5ca50 | FindButton 외 1 | SSP0010_Shipment_Plan_SEMI.cs:769 | try ▸ lambda | DATA_OP | req.Parameters["p_item_id"] | p_Item_id | 행/컬럼 값 대입 |  |  |  |
| AC-29f55964 | FindButton 외 1 | SSP0010_Shipment_Plan_SEMI.cs:770 | try ▸ lambda | DATA_OP | req.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-0b41e95d | FindButton 외 1 | SSP0010_Shipment_Plan_SEMI.cs:771 | try ▸ lambda | DATA_OP | req.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-35237c97 | FindButton 외 1 | SSP0010_Shipment_Plan_SEMI.cs:772 | try ▸ lambda | DATA_OP | req.Parameters["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-3f39df0f | FindButton 외 1 | SSP0010_Shipment_Plan_SEMI.cs:773 | try ▸ lambda | DATA_OP | req.Parameters["p_electrode_type"] | p_electrode_type | 행/컬럼 값 대입 |  |  |  |
| AC-832838f5 | FindButton 외 1 | SSP0010_Shipment_Plan_SEMI.cs:775 | try ▸ lambda | DATA_OP | req.Parameters["p_program_id"] | "SSP0010" | 행/컬럼 값 대입 |  |  |  |
| AC-17be60d8 | FindButton 외 1 | SSP0010_Shipment_Plan_SEMI.cs:777 | try ▸ lambda | DATA_OP | req.Parameters["p_sheet_name"] | p_sheet_name | 행/컬럼 값 대입 |  |  |  |
| AC-58d7c73b | FindButton 외 1 | SSP0010_Shipment_Plan_SEMI.cs:779 | try ▸ lambda | DATA_OP | req.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-6a193b01 | FindButton 외 1 | SSP0010_Shipment_Plan_SEMI.cs:780 | try ▸ lambda | DATA_OP | req.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-58a31d38 | FindButton 외 1 | SSP0010_Shipment_Plan_SEMI.cs:781 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-df03b479 | FindButton 외 1 | SSP0010_Shipment_Plan_SEMI.cs:782 | try ▸ lambda | RETURN | return res.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-eddb96c8 | FindButton 외 1 | SSP0010_Shipment_Plan_SEMI.cs:791 | try | GRID_BIND | siMain.Query | (dsBinding) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-abeef492 | FindButton 외 1 | SSP0010_Shipment_Plan_SEMI.cs:812 | try ▸ if (dsBinding.Tables[0].Rows.Count > 0) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-9c1c161b | FindButton 외 1 | SSP0010_Shipment_Plan_SEMI.cs:822 | try ▸ if (dsBinding.Tables[0].Rows.Count > 0) | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-477d3af1 | FindButton 외 1 | SSP0010_Shipment_Plan_SEMI.cs:826 | try ▸ else of (dsBinding.Tables[0].Rows.Count > 0) | GRID_BIND | siMain.Query | (dsBinding) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-7fe3b43f | FindButton 외 1 | SSP0010_Shipment_Plan_SEMI.cs:829 | try | UI_MISC | SetSearchCount | (dsBinding) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-d6c92439 | FindButton 외 1 | SSP0010_Shipment_Plan_SEMI.cs:833 | catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-b09b7ce4 | FindButton 외 1 | SSP0010_Shipment_Plan_SEMI.cs:835 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-209b86cf | FindButton 외 1 | SSP0010_Shipment_Plan_SEMI.cs:839 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-2ce40379 | FindButton 외 1 | SSP0010_Shipment_Plan_SEMI.cs:840 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## SSP0010_Shipment_Plan_SEMI.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1df375f6 | this.Load | SSP0010_Shipment_Plan_SEMI.cs:205 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SSP0010_Shipment_Plan_SEMI.GetBucketType

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5d1ebe07 | this.Load | SSP0010_Shipment_Plan_SEMI.cs:1262 |  | ENDPOINT | new FoxDataRequest | ("DM.DM0003_GET_BUCKET_TYPE_CODE") ⇒ DM.DM0003_GET_BUCKET_TYPE_CODE | 엔드포인트 요청 생성 |  |  |  |
| AC-cc26caeb | this.Load | SSP0010_Shipment_Plan_SEMI.cs:1263 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-28ff6bb2 | this.Load | SSP0010_Shipment_Plan_SEMI.cs:1265 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SSP0010_Shipment_Plan_SEMI.GetDayRange

진입점: this.Load / cboPlanDate.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5daa6210 | this.Load 외 1 | SSP0010_Shipment_Plan_SEMI.cs:2681 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCM0001_GET_SCP_DAY_PERIOD") ⇒ SCP.SCM0001_GET_SCP_DAY_PERIOD | 엔드포인트 요청 생성 |  |  |  |
| AC-a173c47a | this.Load 외 1 | SSP0010_Shipment_Plan_SEMI.cs:2682 |  | DATA_OP | request.Parameters["p_from_date"] | p_from_date | 행/컬럼 값 대입 |  |  |  |
| AC-09950b51 | this.Load 외 1 | SSP0010_Shipment_Plan_SEMI.cs:2683 |  | DATA_OP | request.Parameters["p_offset_day"] | "55" | 행/컬럼 값 대입 |  |  |  |
| AC-c598b215 | this.Load 외 1 | SSP0010_Shipment_Plan_SEMI.cs:2684 |  | DATA_OP | request.Parameters["p_timezone"] | UserInfoContext.Current[UserInfoProperites.TimeZone] | 행/컬럼 값 대입 |  |  |  |
| AC-1bd638a2 | this.Load 외 1 | SSP0010_Shipment_Plan_SEMI.cs:2685 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-bb837ea9 | this.Load 외 1 | SSP0010_Shipment_Plan_SEMI.cs:2688 |  | RETURN | return sDayRange; |  | 처리 중단/반환 |  |  |  |

## SSP0010_Shipment_Plan_SEMI.GetIsEditable

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d1930e7b | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1056 | foreach (DataRow item in dtPlanTypeShip.Rows) | DATA_OP | lst.Add | (item["code"].ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-121bc5da | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1063 |  | DATA_OP | lst.Contains | ("SE") | 데이터 객체 조작/조회 |  |  |  |
| AC-5d5ccf08 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1070 |  | DATA_OP | lst.Contains | ("MA") | 데이터 객체 조작/조회 |  |  |  |
| AC-a28c728c | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1070 |  | DATA_OP | lst.Contains | ("PR") | 데이터 객체 조작/조회 |  |  |  |
| AC-12fbff7a | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1077 |  | DATA_OP | lst.Contains | ("FN") | 데이터 객체 조작/조회 |  |  |  |
| AC-9b150764 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1082 |  | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |

## SSP0010_Shipment_Plan_SEMI.GetLastPlanVersion

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bf6b2126 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:656 | try | ENDPOINT | new FoxDataRequest | ("SSP.SSP_GET_LAST_PLAN_VERSION") ⇒ SSP.SSP_GET_LAST_PLAN_VERSION | 엔드포인트 요청 생성 |  |  |  |
| AC-f52827b7 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:658 | try | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-46242d17 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:659 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-8e0572a8 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:660 | try | FLAG | dsBinding | response.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-c3a6aeb1 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:671 | try ▸ if (dsBinding.Tables.Count > 0 && dsBinding.Tables[0].Rows.Count > 0) | VALUE_SET | cboPlanDate.SelectedValue | PLAN_START_YYYYMMDD | 컨트롤 값 설정 |  |  |  |
| AC-c0736b37 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:672 | try ▸ if (dsBinding.Tables.Count > 0 && dsBinding.Tables[0].Rows.Count > 0) | VALUE_SET | cboPlanType.SelectedValue | PLAN_TYPE | 컨트롤 값 설정 |  |  |  |
| AC-5c08245c | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:673 | try ▸ if (dsBinding.Tables.Count > 0 && dsBinding.Tables[0].Rows.Count > 0) | VALUE_SET | cboPlanSeq.SelectedValue | PLAN_SEQ | 컨트롤 값 설정 |  |  |  |

## SSP0010_Shipment_Plan_SEMI.GetNewInsertRowIndex

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8c7ad8d8 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:2379 |  | RETURN | return retIndex; |  | 처리 중단/반환 |  |  |  |

## SSP0010_Shipment_Plan_SEMI.GetSpdTitle

진입점: this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK)] / this.Load / FindButton / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-14db799a | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | SSP0010_Shipment_Plan_SEMI.cs:2662 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN") ⇒ SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | 엔드포인트 요청 생성 |  |  |  |
| AC-a5d31d16 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | SSP0010_Shipment_Plan_SEMI.cs:2663 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-9c35c82b | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | SSP0010_Shipment_Plan_SEMI.cs:2664 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-3dc2a80e | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | SSP0010_Shipment_Plan_SEMI.cs:2666 |  | FLAG | dsSpdTitle | client.ExecuteDataSet(request).DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-b4e6df3b | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | SSP0010_Shipment_Plan_SEMI.cs:2666 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## SSP0010_Shipment_Plan_SEMI.HandleBindingDataSet

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d695a2a0 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1420 |  | DATA_OP | list.Add | ("SHIP_REQ") | 데이터 객체 조작/조회 |  |  |  |
| AC-3dac27a3 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1421 |  | DATA_OP | list.Add | ("SHIP_PLAN") | 데이터 객체 조작/조회 |  |  |  |
| AC-f5c805bd | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1422 |  | DATA_OP | list.Add | ("SHIP_PLAN_AMEND") | 데이터 객체 조작/조회 |  |  |  |
| AC-a5bb1689 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1423 |  | DATA_OP | list.Add | ("INVENTORY") | 데이터 객체 조작/조회 |  |  |  |
| AC-537c6aef | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1430 | for (iRow < dtQty.Rows.Count) | DATA_OP | dtBinding.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-d32c94e8 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1463 | for (iRow < dtQty.Rows.Count) ▸ for (iCol < dtQty.Columns.Count) ▸ if (iCol <= header_idx) ▸ if (iCol == from_site_idx) | DATA_OP | newDr[iCol] | dtQty.Rows[iRow][iCol].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-5cecb4fe | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1467 | for (iRow < dtQty.Rows.Count) ▸ for (iCol < dtQty.Columns.Count) ▸ if (iCol <= header_idx) ▸ else of (iCol == from_site_idx) ▸ if (iCol == m… | DATA_OP | newDr[iCol] | dtQty.Rows[iRow][iCol].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-b40f4757 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1473 | for (iRow < dtQty.Rows.Count) ▸ for (iCol < dtQty.Columns.Count) ▸ if (iCol <= header_idx) ▸ else of (iCol == from_site_idx) ▸ else of (iCol… | DATA_OP | newDr[iCol] | dtQty.Rows[iRow][iCol].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-d5b974a6 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1487 | for (iRow < dtQty.Rows.Count) ▸ for (iCol < dtQty.Columns.Count) ▸ else of (iCol <= header_idx) ▸ if (colName.IndexOf("M_") == 0) ▸ if (Mont… | DATA_OP | newDr[WeekIdx] | WeekSum | 행/컬럼 값 대입 |  |  |  |
| AC-90b278db | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1488 | for (iRow < dtQty.Rows.Count) ▸ for (iCol < dtQty.Columns.Count) ▸ else of (iCol <= header_idx) ▸ if (colName.IndexOf("M_") == 0) ▸ if (Mont… | DATA_OP | newDr[MonthIdx] | MonthSum + WeekSum | 행/컬럼 값 대입 |  |  |  |
| AC-cc991242 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1501 | for (iRow < dtQty.Rows.Count) ▸ for (iCol < dtQty.Columns.Count) ▸ else of (iCol <= header_idx) ▸ else of (colName.IndexOf("M_") == 0) ▸ if … | DATA_OP | newDr[WeekIdx] | WeekSum | 행/컬럼 값 대입 |  |  |  |
| AC-bd202ac6 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1502 | for (iRow < dtQty.Rows.Count) ▸ for (iCol < dtQty.Columns.Count) ▸ else of (iCol <= header_idx) ▸ else of (colName.IndexOf("M_") == 0) ▸ if … | DATA_OP | newDr[MonthIdx] | MonthSum + WeekSum | 행/컬럼 값 대입 |  |  |  |
| AC-c61d0aed | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1520 | for (iRow < dtQty.Rows.Count) ▸ for (iCol < dtQty.Columns.Count) ▸ else of (iCol <= header_idx) ▸ else of (colName.IndexOf("M_") == 0) ▸ els… | DATA_OP | newDr[iCol] | check_value | 행/컬럼 값 대입 |  |  |  |
| AC-b570edd8 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1531 | for (iRow < dtQty.Rows.Count) ▸ for (iCol < dtQty.Columns.Count) ▸ if (iCol == dtQty.Columns.Count - 1) ▸ if (MonthSum > 0) | DATA_OP | newDr[MonthIdx] | MonthSum + WeekSum | 행/컬럼 값 대입 |  |  |  |
| AC-549cb77e | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1535 | for (iRow < dtQty.Rows.Count) ▸ for (iCol < dtQty.Columns.Count) ▸ if (iCol == dtQty.Columns.Count - 1) ▸ if (WeekSum > 0) | DATA_OP | newDr[WeekIdx] | WeekSum | 행/컬럼 값 대입 |  |  |  |
| AC-4cd120ad | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1538 | for (iRow < dtQty.Rows.Count) ▸ for (iCol < dtQty.Columns.Count) ▸ if (iCol == dtQty.Columns.Count - 1) ▸ if (WeekSum > 0) | DATA_OP | newDr[MonthIdx] | MonthSum | 행/컬럼 값 대입 |  |  |  |
| AC-326ac23b | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1543 | for (iRow < dtQty.Rows.Count) | DATA_OP | dtBinding.Rows.Add | (newDr) | 데이터 객체 조작/조회 |  |  |  |
| AC-963766de | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1549 | for (iRow < dtQty.Rows.Count) ▸ if (bef_key_idx != cur_key_idx) ▸ if (bef_key_idx != string.Empty) | CALL_EXT | calc.SetCalcMeasure | (ref dtBinding, key_idx_index, iRow) | ⚠ 의미 확인 필요 |  |  |  |
| AC-8b7310a8 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1556 | for (iRow < dtQty.Rows.Count) ▸ if (iRow == dtQty.Rows.Count - 1) | CALL_EXT | calc.SetCalcMeasure | (ref dtBinding, key_idx_index, iRow) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e156fb6e | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1576 |  | DATA_OP | dtBinding.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |

## SSP0010_Shipment_Plan_SEMI.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3d2439d3 | this.Load | SSP0010_Shipment_Plan_SEMI.cs:256 | if (dtDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |
| AC-7f0c9339 | this.Load | SSP0010_Shipment_Plan_SEMI.cs:259 |  | DATA_OP | this.ConditionNotUseList.Add | (cboPlanDate) | 데이터 객체 조작/조회 |  |  |  |
| AC-a46aa1f9 | this.Load | SSP0010_Shipment_Plan_SEMI.cs:260 |  | DATA_OP | this.ConditionNotUseList.Add | (cboPlanType) | 데이터 객체 조작/조회 |  |  |  |
| AC-281e0699 | this.Load | SSP0010_Shipment_Plan_SEMI.cs:261 |  | DATA_OP | this.ConditionNotUseList.Add | (cboPlanSeq) | 데이터 객체 조작/조회 |  |  |  |
| AC-ef4e8ddc | this.Load | SSP0010_Shipment_Plan_SEMI.cs:264 |  | DATA_OP | ReadOnlySheetList.Add | (SpdSheet.shtMain) | 데이터 객체 조작/조회 |  |  |  |
| AC-a9ca9f0c | this.Load | SSP0010_Shipment_Plan_SEMI.cs:266 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-a48c3f3c | this.Load | SSP0010_Shipment_Plan_SEMI.cs:268 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, cboDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-85167980 | this.Load | SSP0010_Shipment_Plan_SEMI.cs:273 |  | LIST_REBIND | clsCtrl.setListBox | (dtElectrode, clbElectrode, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-8f67ec52 | this.Load | SSP0010_Shipment_Plan_SEMI.cs:277 |  | VALUE_SET | drpPeriod.InitValue | GetDayRange() | 컨트롤 값 설정 |  |  |  |
| AC-11456758 | this.Load | SSP0010_Shipment_Plan_SEMI.cs:282 |  | FLAG | dtBucketType | GetBucketType() | 화면 필드/플래그 변경 |  |  |  |
| AC-22b55f76 | this.Load | SSP0010_Shipment_Plan_SEMI.cs:283 |  | LIST_REBIND | clsCtrl.setListBox | (dtBucketType, cboBucketType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SSP0010_Shipment_Plan_SEMI.InitDictionary

진입점: FindButton / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ae145d2b | FindButton 외 1 | SSP0010_Shipment_Plan_SEMI.cs:1332 | foreach (var pair in dicTotalSumItems) | CALL_EXT | dicTotalSumItems[pair.Key].Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-f95c76e0 | FindButton 외 1 | SSP0010_Shipment_Plan_SEMI.cs:1337 | foreach (var pair in dicSubSum_Range) | STATE_RESET | dicSubSum_Range.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-0b251087 | FindButton 외 1 | SSP0010_Shipment_Plan_SEMI.cs:1342 | foreach (var pair in dicSubSumItems) | CALL_EXT | dicSubSumItems[pair.Key].Clear | () | ⚠ 의미 확인 필요 |  |  |  |

## SSP0010_Shipment_Plan_SEMI.InitSpread_2

진입점: this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK)] / this.Load / FindButton / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1e85056f | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | SSP0010_Shipment_Plan_SEMI.cs:300 |  | GRID_INIT | spdInfo.InitSheet | (SpdSheet.shtMain) | 그리드 재구성/초기화 |  |  |  |
| AC-3abe6108 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | SSP0010_Shipment_Plan_SEMI.cs:304 |  | GRID_INIT | siMain.SetSheetHeaderColumn | (spdInfo, 3) | 그리드 재구성/초기화 |  |  |  |
| AC-f32065ae | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | SSP0010_Shipment_Plan_SEMI.cs:310 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b16826c6 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | SSP0010_Shipment_Plan_SEMI.cs:314 | if (pDivisionID != "EE") | GRID_SET | spdInfo.ActiveSheet.Columns[siMain.GetColumnIndex("ELECTRODE_TYPE")].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-bda53c79 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | SSP0010_Shipment_Plan_SEMI.cs:315 | if (pDivisionID != "EE") | GRID_SET | spdInfo.ActiveSheet.Columns[siMain.GetColumnIndex("ORIGIN_FROM_DIVISION_ID")].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-aa873260 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | SSP0010_Shipment_Plan_SEMI.cs:316 | if (pDivisionID != "EE") | GRID_SET | spdInfo.ActiveSheet.Columns[siMain.GetColumnIndex("ORIGIN_TO_DIVISION_ID")].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-4338895d | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | SSP0010_Shipment_Plan_SEMI.cs:320 | else of (pDivisionID != "EE") | GRID_SET | spdInfo.ActiveSheet.Columns[siMain.GetColumnIndex("ELECTRODE_TYPE")].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-6fd935a9 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | SSP0010_Shipment_Plan_SEMI.cs:321 | else of (pDivisionID != "EE") | GRID_SET | spdInfo.ActiveSheet.Columns[siMain.GetColumnIndex("ORIGIN_FROM_DIVISION_ID")].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-4cf365dd | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | SSP0010_Shipment_Plan_SEMI.cs:322 | else of (pDivisionID != "EE") | GRID_SET | spdInfo.ActiveSheet.Columns[siMain.GetColumnIndex("ORIGIN_TO_DIVISION_ID")].Visible | true | 그리드 속성/값 설정 |  |  |  |

## SSP0010_Shipment_Plan_SEMI.InitSpreadDateColumn

진입점: this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK)] / this.Load / FindButton / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-37dae700 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | SSP0010_Shipment_Plan_SEMI.cs:419 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sColumnName.IndexOf("B_") > 0) | GRID_INIT | spdInfo.AddTextColumn | (sColumnLabelname, sColumnName, FPMerge.None, 0, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-afcfe986 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | SSP0010_Shipment_Plan_SEMI.cs:423 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sColumnName.IndexOf("B_") > 0) | GRID_INIT | spdInfo.AddNumColumn | (sColumnLabelname, sColumnName, FPMerge.None, 70, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-af1fdaaa | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | SSP0010_Shipment_Plan_SEMI.cs:427 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sColumnName.IndexOf("B_") > 0) ▸ if (sDayCode == DefMainLabel.Saturday \|\| sDa… | GRID_SET | spdInfo.Sheet().ColumnHeader.Cells[2, spdInfo.GetMaxColumnIndex()].ForeColor | sDayCode == DefMainLabel.Saturday ? Color.Blue : Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-1fdbb27f | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | SSP0010_Shipment_Plan_SEMI.cs:434 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-37f66f71 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | SSP0010_Shipment_Plan_SEMI.cs:435 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-98ee75e0 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | SSP0010_Shipment_Plan_SEMI.cs:440 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0e99fb7f | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | SSP0010_Shipment_Plan_SEMI.cs:441 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 30, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-98d7e362 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | SSP0010_Shipment_Plan_SEMI.cs:449 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName != sSmallLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4e4dae83 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | SSP0010_Shipment_Plan_SEMI.cs:450 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName != sSmallLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a2af8682 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | SSP0010_Shipment_Plan_SEMI.cs:460 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-eaee779d | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | SSP0010_Shipment_Plan_SEMI.cs:461 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-dabdc53b | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | SSP0010_Shipment_Plan_SEMI.cs:462 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-af8de34d | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | SSP0010_Shipment_Plan_SEMI.cs:463 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |

## SSP0010_Shipment_Plan_SEMI.InsertRow

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-901a6410 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:2121 | if (siMain.Sheet().Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8353feca | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:2136 |  | DATA_OP | dsBinding.Tables[0].Select() .Where(c => c[DefMain.KEY_IDX].ToString() == key_idx.ToString… | () | 데이터 객체 조작/조회 |  |  |  |
| AC-5a72a214 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:2136 |  | DATA_OP | dsBinding.Tables[0].Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-00dc1b41 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:2144 |  | POPUP | new SCM0002_GetBODPopup | (dtCaller, 1, this._plan_Start_Date) | 팝업/폼 생성 |  |  |  |
| AC-f8ab5b1a | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:2145 |  | UI_PROP | popup.Width | 1050 | 속성 Width 설정 |  |  |  |
| AC-20f501dc | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:2146 |  | UI_PROP | popup.Height | 350 | 속성 Height 설정 |  |  |  |
| AC-962cc687 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:2147 |  | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-8b8d1b48 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:2151 |  | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-aac40c42 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:2155 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (popup.retList.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6c46c63a | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:2164 | if (popup.ShowDialog() == DialogResult.OK) | DATA_OP | dtCaller.DefaultView.ToTable | (true, distinct) | 데이터 객체 조작/조회 |  |  |  |
| AC-ac38778d | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:2183 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (toSite.ToString() == popupToSite) | DATA_OP | dt2.Select().Where(c => c[DefMain.MEASURE].ToString().Contains("SHIP")).CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-9b817e69 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:2183 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (toSite.ToString() == popupToSite) | DATA_OP | dt2.Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-4c1586c8 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:2183 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (toSite.ToString() == popupToSite) ▸ lambda | DATA_OP | c[DefMain.MEASURE].ToString().Contains | ("SHIP") | 데이터 객체 조작/조회 |  |  |  |
| AC-94391efe | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:2187 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (toSite.ToString() == popupToSite) ▸ foreach (DataRow d… | CALL_EXT | siMain.InsertNewRow | (insertStartIdx) | ⚠ 의미 확인 필요 |  |  |  |
| AC-5d376fee | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:2189 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (toSite.ToString() == popupToSite) ▸ foreach (DataRow d… | DATA_OP | defaultData.Add | (DefMain.KEY_IDX, dr[DefMain.KEY_IDX]) | 데이터 객체 조작/조회 |  |  |  |
| AC-2ac8d8c1 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:2190 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (toSite.ToString() == popupToSite) ▸ foreach (DataRow d… | DATA_OP | defaultData.Add | (DefMain.DIVISION_ID, dr[DefMain.DIVISION_ID]) | 데이터 객체 조작/조회 |  |  |  |
| AC-7cc20cfe | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:2191 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (toSite.ToString() == popupToSite) ▸ foreach (DataRow d… | DATA_OP | defaultData.Add | (DefMain.OPERATION_GROUP_DESC, dr[DefMain.OPERATION_GROUP_DESC]) | 데이터 객체 조작/조회 |  |  |  |
| AC-afd04d81 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:2192 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (toSite.ToString() == popupToSite) ▸ foreach (DataRow d… | DATA_OP | defaultData.Add | (DefMain.ITEM_ID, dr[DefMain.ITEM_ID]) | 데이터 객체 조작/조회 |  |  |  |
| AC-697de5d0 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:2193 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (toSite.ToString() == popupToSite) ▸ foreach (DataRow d… | DATA_OP | defaultData.Add | (DefMain.NICK_NAME, dr[DefMain.NICK_NAME]) | 데이터 객체 조작/조회 |  |  |  |
| AC-5aaa03e5 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:2195 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (toSite.ToString() == popupToSite) ▸ foreach (DataRow d… | DATA_OP | defaultData.Add | (DefMain.FROM_SITE_DESCRIPTION, bod.first_site_name) | 데이터 객체 조작/조회 |  |  |  |
| AC-feafa6e3 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:2196 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (toSite.ToString() == popupToSite) ▸ foreach (DataRow d… | DATA_OP | defaultData.Add | (DefMain.BOH, dr[DefMain.BOH]) | 데이터 객체 조작/조회 |  |  |  |
| AC-e2206cda | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:2197 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (toSite.ToString() == popupToSite) ▸ foreach (DataRow d… | DATA_OP | defaultData.Add | (DefMain.TO_SITE_DESCRIPTION, bod.second_site_name) | 데이터 객체 조작/조회 |  |  |  |
| AC-78f58f21 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:2198 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (toSite.ToString() == popupToSite) ▸ foreach (DataRow d… | DATA_OP | defaultData.Add | (DefMain.TRANSPORT_MODE, bod.transport_mode) | 데이터 객체 조작/조회 |  |  |  |
| AC-7f8a9a50 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:2199 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (toSite.ToString() == popupToSite) ▸ foreach (DataRow d… | DATA_OP | defaultData.Add | (DefMain.LT_DAY, bod.lt_total) | 데이터 객체 조작/조회 |  |  |  |
| AC-78af9114 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:2201 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (toSite.ToString() == popupToSite) ▸ foreach (DataRow d… | DATA_OP | defaultData.Add | (DefMain.MEASURE_LABEL, dr[DefMain.MEASURE_LABEL]) | 데이터 객체 조작/조회 |  |  |  |
| AC-daa113f2 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:2202 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (toSite.ToString() == popupToSite) ▸ foreach (DataRow d… | DATA_OP | defaultData.Add | (DefMain.MEASURE, dr[DefMain.MEASURE]) | 데이터 객체 조작/조회 |  |  |  |
| AC-23be1a1b | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:2203 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (toSite.ToString() == popupToSite) ▸ foreach (DataRow d… | DATA_OP | defaultData.Add | (DefMain.DIVISION_NAME, dr[DefMain.DIVISION_NAME]) | 데이터 객체 조작/조회 |  |  |  |
| AC-59c9509a | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:2204 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (toSite.ToString() == popupToSite) ▸ foreach (DataRow d… | DATA_OP | defaultData.Add | (DefMain.OPERATION_GROUP, dr[DefMain.OPERATION_GROUP]) | 데이터 객체 조작/조회 |  |  |  |
| AC-6193c923 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:2206 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (toSite.ToString() == popupToSite) ▸ foreach (DataRow d… | DATA_OP | defaultData.Add | (DefMain.FROM_SITE, bod.first_site) | 데이터 객체 조작/조회 |  |  |  |
| AC-b97bd44e | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:2207 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (toSite.ToString() == popupToSite) ▸ foreach (DataRow d… | DATA_OP | defaultData.Add | (DefMain.TO_SITE, bod.second_site) | 데이터 객체 조작/조회 |  |  |  |
| AC-61dcfe26 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:2208 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (toSite.ToString() == popupToSite) ▸ foreach (DataRow d… | DATA_OP | defaultData.Add | (DefMain.BOD_ID, bod.bod_id) | 데이터 객체 조작/조회 |  |  |  |
| AC-92132766 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:2210 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (toSite.ToString() == popupToSite) ▸ foreach (DataRow d… | DATA_OP | defaultData.Add | (DefMain.MEASURE_ORDER_NO, dr[DefMain.MEASURE_ORDER_NO]) | 데이터 객체 조작/조회 |  |  |  |
| AC-a53ebb6b | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:2211 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (toSite.ToString() == popupToSite) ▸ foreach (DataRow d… | DATA_OP | defaultData.Add | (DefMain.SHIP_FROZEN, bod.ship_frozen) | 데이터 객체 조작/조회 |  |  |  |
| AC-7bebec4d | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:2212 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (toSite.ToString() == popupToSite) ▸ foreach (DataRow d… | DATA_OP | defaultData.Add | (DefMain.FROM_YYYYMMDD, dr[DefMain.FROM_YYYYMMDD]) | 데이터 객체 조작/조회 |  |  |  |
| AC-78afbaee | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:2213 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (toSite.ToString() == popupToSite) ▸ foreach (DataRow d… | DATA_OP | defaultData.Add | (DefMain.TO_YYYYMMDD, dr[DefMain.TO_YYYYMMDD]) | 데이터 객체 조작/조회 |  |  |  |
| AC-e3708e7f | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:2214 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (toSite.ToString() == popupToSite) ▸ foreach (DataRow d… | GRID_SET | siMain.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |
| AC-302fe0be | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:2225 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (toSite.ToString() == popupToSite) | DATA_OP | dt2.Select().Where(c => c[DefMain.MEASURE].ToString().Contains("SHIP")).CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-bc0129ce | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:2225 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (toSite.ToString() == popupToSite) | DATA_OP | dt2.Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-157dfb45 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:2225 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (toSite.ToString() == popupToSite) ▸ lambda | DATA_OP | c[DefMain.MEASURE].ToString().Contains | ("SHIP") | 데이터 객체 조작/조회 |  |  |  |
| AC-3c6342d1 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:2233 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (toSite.ToString() == popupToSite) ▸ foreach (Data… | CALL_EXT | siMain.InsertNewRow | (insertStartIdx) | ⚠ 의미 확인 필요 |  |  |  |
| AC-0d869bf0 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:2235 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (toSite.ToString() == popupToSite) ▸ foreach (Data… | DATA_OP | defaultData.Add | (DefMain.KEY_IDX, dr[DefMain.KEY_IDX]) | 데이터 객체 조작/조회 |  |  |  |
| AC-5bb2eedb | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:2236 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (toSite.ToString() == popupToSite) ▸ foreach (Data… | DATA_OP | defaultData.Add | (DefMain.DIVISION_ID, dr[DefMain.DIVISION_ID]) | 데이터 객체 조작/조회 |  |  |  |
| AC-5e11dbd8 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:2237 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (toSite.ToString() == popupToSite) ▸ foreach (Data… | DATA_OP | defaultData.Add | (DefMain.OPERATION_GROUP_DESC, dr[DefMain.OPERATION_GROUP_DESC]) | 데이터 객체 조작/조회 |  |  |  |
| AC-5a2a4137 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:2238 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (toSite.ToString() == popupToSite) ▸ foreach (Data… | DATA_OP | defaultData.Add | (DefMain.ITEM_ID, dr[DefMain.ITEM_ID]) | 데이터 객체 조작/조회 |  |  |  |
| AC-e9738194 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:2239 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (toSite.ToString() == popupToSite) ▸ foreach (Data… | DATA_OP | defaultData.Add | (DefMain.NICK_NAME, dr[DefMain.NICK_NAME]) | 데이터 객체 조작/조회 |  |  |  |
| AC-872d3b88 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:2241 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (toSite.ToString() == popupToSite) ▸ foreach (Data… | DATA_OP | defaultData.Add | (DefMain.FROM_SITE_DESCRIPTION, bod.first_site_name) | 데이터 객체 조작/조회 |  |  |  |
| AC-d4878612 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:2242 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (toSite.ToString() == popupToSite) ▸ foreach (Data… | DATA_OP | defaultData.Add | (DefMain.BOH, dr[DefMain.BOH]) | 데이터 객체 조작/조회 |  |  |  |
| AC-9c54130c | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:2245 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (toSite.ToString() == popupToSite) ▸ foreach (Data… | DATA_OP | dr[DefMain.MEASURE].ToString().Contains | ("SHIP") | 데이터 객체 조작/조회 |  |  |  |
| AC-e0f87453 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:2247 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (toSite.ToString() == popupToSite) ▸ foreach (Data… | DATA_OP | defaultData.Add | (DefMain.TO_SITE_DESCRIPTION, bod.second_site_name) | 데이터 객체 조작/조회 |  |  |  |
| AC-450d7011 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:2248 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (toSite.ToString() == popupToSite) ▸ foreach (Data… | DATA_OP | defaultData.Add | (DefMain.TRANSPORT_MODE, bod.transport_mode) | 데이터 객체 조작/조회 |  |  |  |
| AC-23336c76 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:2249 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (toSite.ToString() == popupToSite) ▸ foreach (Data… | DATA_OP | defaultData.Add | (DefMain.LT_DAY, bod.lt_total) | 데이터 객체 조작/조회 |  |  |  |
| AC-6ad98baf | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:2253 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (toSite.ToString() == popupToSite) ▸ foreach (Data… | DATA_OP | defaultData.Add | (DefMain.TO_SITE_DESCRIPTION, "-") | 데이터 객체 조작/조회 |  |  |  |
| AC-9b85a088 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:2254 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (toSite.ToString() == popupToSite) ▸ foreach (Data… | DATA_OP | defaultData.Add | (DefMain.TRANSPORT_MODE, "-") | 데이터 객체 조작/조회 |  |  |  |
| AC-71a7db49 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:2255 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (toSite.ToString() == popupToSite) ▸ foreach (Data… | DATA_OP | defaultData.Add | (DefMain.LT_DAY, "0") | 데이터 객체 조작/조회 |  |  |  |
| AC-6bf80926 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:2258 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (toSite.ToString() == popupToSite) ▸ foreach (Data… | DATA_OP | defaultData.Add | (DefMain.MEASURE_LABEL, dr[DefMain.MEASURE_LABEL]) | 데이터 객체 조작/조회 |  |  |  |
| AC-b8f52d3b | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:2259 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (toSite.ToString() == popupToSite) ▸ foreach (Data… | DATA_OP | defaultData.Add | (DefMain.MEASURE, dr[DefMain.MEASURE]) | 데이터 객체 조작/조회 |  |  |  |
| AC-b53c3697 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:2260 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (toSite.ToString() == popupToSite) ▸ foreach (Data… | DATA_OP | defaultData.Add | (DefMain.DIVISION_NAME, dr[DefMain.DIVISION_NAME]) | 데이터 객체 조작/조회 |  |  |  |
| AC-e495feeb | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:2261 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (toSite.ToString() == popupToSite) ▸ foreach (Data… | DATA_OP | defaultData.Add | (DefMain.OPERATION_GROUP, dr[DefMain.OPERATION_GROUP]) | 데이터 객체 조작/조회 |  |  |  |
| AC-815db585 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:2262 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (toSite.ToString() == popupToSite) ▸ foreach (Data… | DATA_OP | defaultData.Add | (DefMain.FROM_SITE, bod.first_site) | 데이터 객체 조작/조회 |  |  |  |
| AC-d893aa63 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:2264 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (toSite.ToString() == popupToSite) ▸ foreach (Data… | DATA_OP | dr[DefMain.MEASURE].ToString().Contains | ("SHIP") | 데이터 객체 조작/조회 |  |  |  |
| AC-ee76e536 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:2266 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (toSite.ToString() == popupToSite) ▸ foreach (Data… | DATA_OP | defaultData.Add | (DefMain.TO_SITE, bod.second_site) | 데이터 객체 조작/조회 |  |  |  |
| AC-7d9a14d9 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:2267 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (toSite.ToString() == popupToSite) ▸ foreach (Data… | DATA_OP | defaultData.Add | (DefMain.BOD_ID, bod.bod_id) | 데이터 객체 조작/조회 |  |  |  |
| AC-13bdc04c | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:2271 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (toSite.ToString() == popupToSite) ▸ foreach (Data… | DATA_OP | defaultData.Add | (DefMain.TO_SITE, "-") | 데이터 객체 조작/조회 |  |  |  |
| AC-e7a9ee11 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:2272 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (toSite.ToString() == popupToSite) ▸ foreach (Data… | DATA_OP | defaultData.Add | (DefMain.BOD_ID, "-") | 데이터 객체 조작/조회 |  |  |  |
| AC-090f78b6 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:2275 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (toSite.ToString() == popupToSite) ▸ foreach (Data… | DATA_OP | defaultData.Add | (DefMain.MEASURE_ORDER_NO, dr[DefMain.MEASURE_ORDER_NO]) | 데이터 객체 조작/조회 |  |  |  |
| AC-81fb978c | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:2276 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (toSite.ToString() == popupToSite) ▸ foreach (Data… | DATA_OP | defaultData.Add | (DefMain.SHIP_FROZEN, bod.ship_frozen) | 데이터 객체 조작/조회 |  |  |  |
| AC-63fca3af | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:2277 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (toSite.ToString() == popupToSite) ▸ foreach (Data… | DATA_OP | defaultData.Add | (DefMain.FROM_YYYYMMDD, dr[DefMain.FROM_YYYYMMDD]) | 데이터 객체 조작/조회 |  |  |  |
| AC-cdae7713 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:2278 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (toSite.ToString() == popupToSite) ▸ foreach (Data… | DATA_OP | defaultData.Add | (DefMain.TO_YYYYMMDD, dr[DefMain.TO_YYYYMMDD]) | 데이터 객체 조작/조회 |  |  |  |
| AC-e3cb0ef4 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:2279 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (toSite.ToString() == popupToSite) ▸ foreach (Data… | GRID_SET | siMain.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |

## SSP0010_Shipment_Plan_SEMI.RetLongValue

진입점: FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ for (iRow < dsBinding.Tables[0].Rows.Count) ▸ for (iCol < dsBinding.Tables[0].Columns.Count) ▸ else of (colName.IndexOf("M_") == 0) ▸ else of (colName.IndexOf("W_") == 0) ▸ if (colName.IndexOf("D_") == 0)] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2fa88654 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ … 외 1 | SSP0010_Shipment_Plan_SEMI.cs:1091 | if (obj.ToString() != "" && obj != null && obj != DBNull.Value) | CALL_EXT | Convert.ToInt64 | (obj) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a4679663 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ … 외 1 | SSP0010_Shipment_Plan_SEMI.cs:1093 |  | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |

## SSP0010_Shipment_Plan_SEMI.SaveData_FixInfo

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9ac0f0bb | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:2390 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (siMain.ActiveSheet.Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4b8e9a24 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:2411 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (fixType == "F") | POPUP | new SCM0002_RejectReasonPopup | ("Fix Reason") | 팝업/폼 생성 |  |  |  |
| AC-7adc4f05 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:2412 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (fixType == "F") | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-46b4b009 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:2413 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (fixType == "F") | UI_PROP | popup.Width | 600 | 속성 Width 설정 |  |  |  |
| AC-8b346da7 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:2414 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (fixType == "F") | UI_PROP | popup.Height | 230 | 속성 Height 설정 |  |  |  |
| AC-d143362c | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:2416 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (fixType == "F") | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-6e6d54d4 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:2425 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (fixType == "F") ▸ else of (popup.ShowDial… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-189eb205 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:2438 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (selCells.Length < 1) | MESSAGE | MessageHelper.GMessageBox | ("MSG00134", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-1a523b66 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:2439 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (selCells.Length < 1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-103f49eb | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:2501 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (fixType.Equals("U") && iCount == 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00046", new object[] { null }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a659b6e9 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:2502 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (fixType.Equals("U") && iCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d05639b5 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:2513 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | ENDPOINT | new FoxDataRequest | ("SCP.SCP0010_SAVE_ANL_SHIPMENT_PLAN_SEMI_FIX") ⇒ SCP.SCP0010_SAVE_ANL_SHIPMENT_PLAN_SEMI_FIX | 엔드포인트 요청 생성 |  |  |  |
| AC-f2f08e31 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:2515 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-3c8bbba1 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:2516 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-cee6da45 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:2517 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_biz_type"] | p_biz_type | 행/컬럼 값 대입 |  |  |  |
| AC-73fd5d8d | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:2518 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-6e0e10a0 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:2519 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_to_site"] | p_to_site | 행/컬럼 값 대입 |  |  |  |
| AC-65dc7d2d | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:2520 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-cd35e85d | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:2523 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_bod_id"] | p_bod_id | 행/컬럼 값 대입 |  |  |  |
| AC-8e4b1346 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:2524 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_yyyymmdd"] | p_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-7c39c939 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:2525 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_qty"] | p_qty | 행/컬럼 값 대입 |  |  |  |
| AC-b562d8ec | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:2526 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_fix_reason"] | strReason | 행/컬럼 값 대입 |  |  |  |
| AC-63a25e43 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:2527 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_user_id"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-6210d13c | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:2528 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-f15aed42 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:2530 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-1c204461 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:2535 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { response.DataSet.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a68abf78 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:2551 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ else of (response.Dat… | MESSAGE | MessageHelper.GMessageBox | ("MSG00284", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-334db082 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:2558 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SSP0010_Shipment_Plan_SEMI.SaveData_Main

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5f407f31 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1691 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (siMain.ActiveSheet.Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e32f573c | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1693 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-6f6f875c | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1696 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-787b211f | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1717 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (iRow < siMain.ActiveSheet.Rows.… | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-44f6a64c | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1719 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (iRow < siMain.ActiveSheet.Rows.… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-40e9cb99 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1727 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (iRow < siMain.ActiveSheet.Rows.… | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-9264477a | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1729 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (iRow < siMain.ActiveSheet.Rows.… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-edb8f331 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1744 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (iRow < siMain.ActiveSheet.Rows.… | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-a1d4ae1d | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1746 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (iRow < siMain.ActiveSheet.Rows.… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1aa1ae57 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1753 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | FLAG | saveDS | new DataSet() | 화면 필드/플래그 변경 |  |  |  |
| AC-f3321448 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1755 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dt.Columns.Add | ("A", typeof(char)) | 데이터 객체 조작/조회 |  |  |  |
| AC-f6cab54c | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1756 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dt.Columns.Add | ("p_active_flag") | 데이터 객체 조작/조회 |  |  |  |
| AC-ca1aa7d2 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1757 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dt.Columns.Add | ("p_division_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-d650cdfa | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1758 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dt.Columns.Add | ("p_plan_start_yyyymmdd") | 데이터 객체 조작/조회 |  |  |  |
| AC-031637f4 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1759 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dt.Columns.Add | ("p_plan_type") | 데이터 객체 조작/조회 |  |  |  |
| AC-d27af730 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1760 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dt.Columns.Add | ("p_seq") | 데이터 객체 조작/조회 |  |  |  |
| AC-a177a3ff | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1761 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dt.Columns.Add | ("p_operation_group") | 데이터 객체 조작/조회 |  |  |  |
| AC-9fd9bef5 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1762 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dt.Columns.Add | ("p_item_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-73d91d58 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1763 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dt.Columns.Add | ("p_from_site") | 데이터 객체 조작/조회 |  |  |  |
| AC-a0d201b2 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1764 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dt.Columns.Add | ("p_bod_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-bf8d31be | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1765 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dt.Columns.Add | ("p_measure") | 데이터 객체 조작/조회 |  |  |  |
| AC-9aeba1bd | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1766 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dt.Columns.Add | ("p_yyyymmdd") | 데이터 객체 조작/조회 |  |  |  |
| AC-d0c4005e | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1767 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dt.Columns.Add | ("p_to_site") | 데이터 객체 조작/조회 |  |  |  |
| AC-4284ab5b | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1768 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dt.Columns.Add | ("p_qty") | 데이터 객체 조작/조회 |  |  |  |
| AC-56be137a | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1769 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dt.Columns.Add | ("p_created_by") | 데이터 객체 조작/조회 |  |  |  |
| AC-60d5afa2 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1770 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dt.Columns.Add | ("p_last_updated_by") | 데이터 객체 조작/조회 |  |  |  |
| AC-7ba9335b | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1771 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dt.Columns.Add | ("p_time_zone") | 데이터 객체 조작/조회 |  |  |  |
| AC-f4dac377 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1772 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dt.Columns.Add | ("p_first_row") | 데이터 객체 조작/조회 |  |  |  |
| AC-00062d74 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1773 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dt.Columns.Add | ("p_last_row") | 데이터 객체 조작/조회 |  |  |  |
| AC-8359ddbd | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1774 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | saveDS.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-4b2e73c8 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1809 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | saveDS.Tables[0].NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-7a346ca3 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1810 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["A"] | action | 행/컬럼 값 대입 |  |  |  |
| AC-a22ebcf7 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1811 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_active_flag"] | action | 행/컬럼 값 대입 |  |  |  |
| AC-5ab0c8c3 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1812 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_division_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.DIVISION_ID)) | 행/컬럼 값 대입 |  |  |  |
| AC-c12f09db | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1813 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-c9ceea46 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1814 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-b031cb90 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1815 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-47a4f5aa | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1816 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_operation_group"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.OPERATION_GROUP)) | 행/컬럼 값 대입 |  |  |  |
| AC-4c57c90e | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1817 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_item_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.ITEM_ID)) | 행/컬럼 값 대입 |  |  |  |
| AC-74e00f96 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1818 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_from_site"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.FROM_SITE)) | 행/컬럼 값 대입 |  |  |  |
| AC-a454a0d4 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1819 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_bod_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.BOD_ID)) | 행/컬럼 값 대입 |  |  |  |
| AC-f3513ade | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1820 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_measure"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.MEASURE)) | 행/컬럼 값 대입 |  |  |  |
| AC-5279dc0d | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1823 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_yyyymmdd"] | yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-1e0cac2b | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1824 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_to_site"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.TO_SITE)) | 행/컬럼 값 대입 |  |  |  |
| AC-783250ac | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1825 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_qty"] | 0 | 행/컬럼 값 대입 |  |  |  |
| AC-d4b552bc | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1826 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_created_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-9db3bc71 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1827 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_last_updated_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-5fbadcb1 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1828 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_time_zone"] | UserInfoContext.Current[UserInfoProperites.TimeZone] | 행/컬럼 값 대입 |  |  |  |
| AC-05256a83 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1830 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | saveDS.Tables[0].Rows.Add | (dr) | 데이터 객체 조작/조회 |  |  |  |
| AC-d578ff68 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1843 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | saveDS.Tables[0].NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-4ce2a98e | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1844 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["A"] | action | 행/컬럼 값 대입 |  |  |  |
| AC-e9cb739a | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1845 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_active_flag"] | action | 행/컬럼 값 대입 |  |  |  |
| AC-675bc189 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1846 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_division_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.DIVISION_ID)) | 행/컬럼 값 대입 |  |  |  |
| AC-b7a192cc | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1847 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-646a0cef | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1848 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-df377099 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1849 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-b2cb9305 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1850 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_operation_group"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.OPERATION_GROUP)) | 행/컬럼 값 대입 |  |  |  |
| AC-8e210db0 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1851 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_item_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.ITEM_ID)) | 행/컬럼 값 대입 |  |  |  |
| AC-0c52ff71 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1852 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_from_site"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.FROM_SITE)) | 행/컬럼 값 대입 |  |  |  |
| AC-66c79c71 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1853 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_bod_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.BOD_ID)) | 행/컬럼 값 대입 |  |  |  |
| AC-a6cb31ee | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1854 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_measure"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.MEASURE)) | 행/컬럼 값 대입 |  |  |  |
| AC-5f3a5329 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1857 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_yyyymmdd"] | yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-bef96def | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1858 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_to_site"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.TO_SITE)) | 행/컬럼 값 대입 |  |  |  |
| AC-9727c53c | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1859 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_qty"] | val | 행/컬럼 값 대입 |  |  |  |
| AC-052a4a3d | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1860 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_created_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-e3f570f7 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1861 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_last_updated_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-6f21f3ba | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1862 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_time_zone"] | UserInfoContext.Current[UserInfoProperites.TimeZone] | 행/컬럼 값 대입 |  |  |  |
| AC-b0efbce5 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1864 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | saveDS.Tables[0].Rows.Add | (dr) | 데이터 객체 조작/조회 |  |  |  |
| AC-43f90e32 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1882 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | saveDS.Tables[0].NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-b4fd114f | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1883 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["A"] | action | 행/컬럼 값 대입 |  |  |  |
| AC-282e80f3 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1884 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_active_flag"] | action | 행/컬럼 값 대입 |  |  |  |
| AC-de62a3c5 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1885 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_division_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.DIVISION_ID)) | 행/컬럼 값 대입 |  |  |  |
| AC-cb117d9c | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1886 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-37e97c47 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1887 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-ccf3bad4 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1888 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-26e5bfb4 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1889 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_operation_group"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.OPERATION_GROUP)) | 행/컬럼 값 대입 |  |  |  |
| AC-7f814ce6 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1890 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_item_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.ITEM_ID)) | 행/컬럼 값 대입 |  |  |  |
| AC-e04ba4b8 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1891 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_from_site"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.FROM_SITE)) | 행/컬럼 값 대입 |  |  |  |
| AC-3e8c609f | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1892 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_bod_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.BOD_ID)) | 행/컬럼 값 대입 |  |  |  |
| AC-e5dd9f4b | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1893 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_measure"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.MEASURE)) | 행/컬럼 값 대입 |  |  |  |
| AC-444bf54e | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1896 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_yyyymmdd"] | yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-cb693308 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1897 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_to_site"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.TO_SITE)) | 행/컬럼 값 대입 |  |  |  |
| AC-e3d51ec7 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1898 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_qty"] | strQty | 행/컬럼 값 대입 |  |  |  |
| AC-0653cc8f | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1899 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_created_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-e2db7e20 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1900 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_last_updated_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-13cd72c4 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1901 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_time_zone"] | UserInfoContext.Current[UserInfoProperites.TimeZone] | 행/컬럼 값 대입 |  |  |  |
| AC-4a18ed1b | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1903 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | saveDS.Tables[0].Rows.Add | (dr) | 데이터 객체 조작/조회 |  |  |  |
| AC-a5b68beb | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1909 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | GRID_SET | saveDS.Tables[0].Rows[0]["p_first_row"] | "Y" | 그리드 속성/값 설정 |  |  |  |
| AC-12552ae8 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1910 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | GRID_SET | saveDS.Tables[0].Rows[iCount - 1]["p_last_row"] | "Y" | 그리드 속성/값 설정 |  |  |  |
| AC-5dbc5d74 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1912 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | saveDS.Tables[0].AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-c81c5c83 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1922 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (iCount > 0) ▸ foreach (DataRow r… | CALL_EXT | row.SetAdded | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-741bc4fd | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1923 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (iCount > 0) ▸ foreach (DataRow r… | CALL_EXT | row.SetModified | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-e89b494a | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1924 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (iCount > 0) ▸ foreach (DataRow r… | DATA_OP | row.Delete | () | 데이터 객체 조작/조회 |  |  |  |
| AC-bee8e085 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1928 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (iCount > 0) | UI_PROP | req.InsertQueryId | "SCP.SCP0010_SAVE_ANL_SHIPMENT_PLAN_SEMI" | 속성 InsertQueryId 설정 |  |  |  |
| AC-e37d2816 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1929 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (iCount > 0) | UI_PROP | req.DeleteQueryId | "SCP.SCP0010_SAVE_ANL_SHIPMENT_PLAN_SEMI" | 속성 DeleteQueryId 설정 |  |  |  |
| AC-4751c70c | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1930 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (iCount > 0) | UI_PROP | req.UpdateQueryId | "SCP.SCP0010_SAVE_ANL_SHIPMENT_PLAN_SEMI" | 속성 UpdateQueryId 설정 |  |  |  |
| AC-592360cc | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1931 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (iCount > 0) | UI_PROP | req.DataSet | saveDS.GetChanges() | 속성 DataSet 설정 |  |  |  |
| AC-b7f905ed | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1931 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (iCount > 0) | CALL_EXT | saveDS.GetChanges | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-57838bad | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1934 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (iCount > 0) | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-58266906 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1936 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (iCount > 0) | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCP.Analysis.WSL/FoxDataServi… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-d2760cfc | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1939 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (iCount > 0) ▸ lambda | ENDPOINT | client.SaveDataTable | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a6ee525c | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1939 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (iCount > 0) ▸ lambda | RETURN | return client.SaveDataTable(req); |  | 처리 중단/반환 |  |  |  |
| AC-6a4b002b | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1945 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (iCount > 0) ▸ if (tran.Success) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-bd0e4373 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1946 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (iCount > 0) ▸ if (tran.Success) | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { iCount }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f02f5124 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1957 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-41a9b4d4 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1959 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b2087927 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1963 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-b1c89f3f | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1964 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## SSP0010_Shipment_Plan_SEMI.Set_FixButtonEnabled

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bce08424 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:2042 | if (sPlanType.Equals("FN")) | STATE | btnFix.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-ed258560 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:2043 | if (sPlanType.Equals("FN")) | STATE | btnUnfix.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-060e41ec | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:2050 | else of (sPlanType.Equals("FN")) ▸ if (!string.IsNullOrEmpty(CString.GetCheckedListValue(dtPlanSeqShip, cboPlanSeq.ControlValues, true))) | DATA_OP | dtPlanSeqShip.AsEnumerable().Select | (a => a.Field<int>("CODE")) | 데이터 객체 조작/조회 |  |  |  |
| AC-f4b424ec | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:2050 | else of (sPlanType.Equals("FN")) ▸ if (!string.IsNullOrEmpty(CString.GetCheckedListValue(dtPlanSeqShip, cboPlanSeq.ControlValues, true))) ▸ … | DATA_OP | a.Field | ("CODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-dfe218bf | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:2054 | else of (sPlanType.Equals("FN")) ▸ if (!string.IsNullOrEmpty(CString.GetCheckedListValue(dtPlanSeqShip, cboPlanSeq.ControlValues, true))) ▸ … | STATE | btnFix.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-ab2b810f | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:2055 | else of (sPlanType.Equals("FN")) ▸ if (!string.IsNullOrEmpty(CString.GetCheckedListValue(dtPlanSeqShip, cboPlanSeq.ControlValues, true))) ▸ … | STATE | btnUnfix.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-9b6eb18a | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:2059 | else of (sPlanType.Equals("FN")) ▸ if (!string.IsNullOrEmpty(CString.GetCheckedListValue(dtPlanSeqShip, cboPlanSeq.ControlValues, true))) ▸ … | STATE | btnFix.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-404ca38e | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:2060 | else of (sPlanType.Equals("FN")) ▸ if (!string.IsNullOrEmpty(CString.GetCheckedListValue(dtPlanSeqShip, cboPlanSeq.ControlValues, true))) ▸ … | STATE | btnUnfix.Enabled | false | 컨트롤 상태 Enabled |  |  |  |

## SSP0010_Shipment_Plan_SEMI.Set_FixCellColor

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-11ed1d4c | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:869 |  | FLAG | dtFix | dsBinding.Tables[2] | 화면 필드/플래그 변경 |  |  |  |
| AC-c8ef81ea | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:883 | for (nRow < siMain.ActiveSheet.Rows.Count) ▸ if (measure.Equals("SHIP_PLAN_AMEND")) | DATA_OP | dtFix.Select | ("key_idx='" + sKey_Idx + "' AND TO_SITE='" + sTo_Site + "' AND bod_id='" + sBod_Id + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-5f435436 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:893 | for (nRow < siMain.ActiveSheet.Rows.Count) ▸ if (measure.Equals("SHIP_PLAN_AMEND")) ▸ if (res.Count() > 0) ▸ foreach (var dr in res) | DATA_OP | list.Add | (dr["yyyymmdd"].ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-89e57761 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:917 | for (nRow < siMain.ActiveSheet.Rows.Count) ▸ if (measure.Equals("SHIP_PLAN_AMEND")) ▸ if (res.Count() > 0) ▸ for (nCol < siMain.ActiveSheet.… | GRID_STYLE | siMain.SetBGColor2 | (nRow, bef_week, nRow, bef_week, Color.FromArgb(188, 229, 92)) | 그리드 표시 설정 |  |  |  |
| AC-80f5d2e0 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:925 | for (nRow < siMain.ActiveSheet.Rows.Count) ▸ if (measure.Equals("SHIP_PLAN_AMEND")) ▸ if (res.Count() > 0) ▸ for (nCol < siMain.ActiveSheet.… | DATA_OP | list.Contains | (colName) | 데이터 객체 조작/조회 |  |  |  |
| AC-252bb55a | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:927 | for (nRow < siMain.ActiveSheet.Rows.Count) ▸ if (measure.Equals("SHIP_PLAN_AMEND")) ▸ if (res.Count() > 0) ▸ for (nCol < siMain.ActiveSheet.… | GRID_STYLE | siMain.SetBGColor2 | (nRow, nCol, nRow, nCol, Color.FromArgb(188, 229, 92)) | 그리드 표시 설정 |  |  |  |
| AC-76cd3162 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:937 | for (nRow < siMain.ActiveSheet.Rows.Count) ▸ if (measure.Equals("SHIP_PLAN_AMEND")) ▸ if (res.Count() > 0) ▸ for (nCol < siMain.ActiveSheet.… | GRID_STYLE | siMain.SetBGColor2 | (nRow, bef_week, nRow, bef_week, Color.FromArgb(188, 229, 92)) | 그리드 표시 설정 |  |  |  |

## SSP0010_Shipment_Plan_SEMI.Set_FPOperationColor

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7b20054e | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:860 | for (nRow < siMain.ActiveSheet.Rows.Count) ▸ if (siMain.ActiveSheet.GetText(nRow, siMain.GetColumnIndex(DefMain.MEASURE)).ToString() == "SHI… | GRID_STYLE | siMain.SetBGColor | (nRow, nCol, nRow, nCol, Color.FromArgb(234, 234, 234)) | 그리드 표시 설정 |  |  |  |

## SSP0010_Shipment_Plan_SEMI.Set_InsertColumnsFont

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-72484075 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:2300 | if (bBold) | UI_PROP | range1.Font | new System.Drawing.Font(spdMain.Font.Name, spdMain.Font.Size, FontStyle.Bold) | 속성 Font 설정 |  |  |  |
| AC-cddad5e9 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:2304 | else of (bBold) | UI_PROP | range1.Font | new System.Drawing.Font(spdMain.Font.Name, spdMain.Font.Size, FontStyle.Regular) | 속성 Font 설정 |  |  |  |

## SSP0010_Shipment_Plan_SEMI.Set_SumValues

진입점: FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c6fbd0a0 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] 외 1 | SSP0010_Shipment_Plan_SEMI.cs:979 | for (iRow < dsBinding.Tables[0].Rows.Count) ▸ for (iCol < dsBinding.Tables[0].Columns.Count) ▸ if (colName.IndexOf("M_") == 0) ▸ if (bef_mon… | GRID_SET | dsBinding.Tables[0].Rows[iRow][bef_month_idx] | sum_month | 그리드 속성/값 설정 |  |  |  |
| AC-d0d60254 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] 외 1 | SSP0010_Shipment_Plan_SEMI.cs:988 | for (iRow < dsBinding.Tables[0].Rows.Count) ▸ for (iCol < dsBinding.Tables[0].Columns.Count) ▸ if (colName.IndexOf("M_") == 0) ▸ if (bef_mon… | GRID_SET | dsBinding.Tables[0].Rows[iRow][bef_month_idx] | qty | 그리드 속성/값 설정 |  |  |  |
| AC-c46eb615 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] 외 1 | SSP0010_Shipment_Plan_SEMI.cs:1000 | for (iRow < dsBinding.Tables[0].Rows.Count) ▸ for (iCol < dsBinding.Tables[0].Columns.Count) ▸ else of (colName.IndexOf("M_") == 0) ▸ if (co… | GRID_SET | dsBinding.Tables[0].Rows[iRow][bef_week_idx] | sum_week | 그리드 속성/값 설정 |  |  |  |
| AC-d0b81d9c | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] 외 1 | SSP0010_Shipment_Plan_SEMI.cs:1009 | for (iRow < dsBinding.Tables[0].Rows.Count) ▸ for (iCol < dsBinding.Tables[0].Columns.Count) ▸ else of (colName.IndexOf("M_") == 0) ▸ if (co… | GRID_SET | dsBinding.Tables[0].Rows[iRow][bef_week_idx] | qty | 그리드 속성/값 설정 |  |  |  |
| AC-6d543c60 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] 외 1 | SSP0010_Shipment_Plan_SEMI.cs:1030 | for (iRow < dsBinding.Tables[0].Rows.Count) ▸ for (iCol < dsBinding.Tables[0].Columns.Count) ▸ else of (colName.IndexOf("M_") == 0) ▸ else o… | GRID_SET | dsBinding.Tables[0].Rows[iRow][bef_week_idx] | sum_week | 그리드 속성/값 설정 |  |  |  |
| AC-d1d1c44f | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] 외 1 | SSP0010_Shipment_Plan_SEMI.cs:1031 | for (iRow < dsBinding.Tables[0].Rows.Count) ▸ for (iCol < dsBinding.Tables[0].Columns.Count) ▸ else of (colName.IndexOf("M_") == 0) ▸ else o… | GRID_SET | dsBinding.Tables[0].Rows[iRow][bef_month_idx] | sum_month | 그리드 속성/값 설정 |  |  |  |
| AC-6e07b9ea | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] 외 1 | SSP0010_Shipment_Plan_SEMI.cs:1038 | for (iRow < dsBinding.Tables[0].Rows.Count) ▸ for (iCol < dsBinding.Tables[0].Columns.Count) ▸ else of (colName.IndexOf("M_") == 0) ▸ else o… | GRID_SET | dsBinding.Tables[0].Rows[iRow][bef_week_idx] | qty | 그리드 속성/값 설정 |  |  |  |
| AC-fda8978c | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] 외 1 | SSP0010_Shipment_Plan_SEMI.cs:1039 | for (iRow < dsBinding.Tables[0].Rows.Count) ▸ for (iCol < dsBinding.Tables[0].Columns.Count) ▸ else of (colName.IndexOf("M_") == 0) ▸ else o… | GRID_SET | dsBinding.Tables[0].Rows[iRow][bef_month_idx] | qty | 그리드 속성/값 설정 |  |  |  |

## SSP0010_Shipment_Plan_SEMI.SetChangedControl

진입점: this.Load / cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a21830b8 | this.Load 외 1 | SSP0010_Shipment_Plan_SEMI.cs:603 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ if (!pDivisionID.Equals("EE")) | FLAG | dtOperGrp | Data.Common(Data.Type.LookupCommon, false, "OPERATION_GROUP_SEMI") ⇒ biz:CommonData.CommonDataList [code=LookupCommon] | 화면 필드/플래그 변경 |  |  |  |
| AC-923ec0f4 | this.Load 외 1 | SSP0010_Shipment_Plan_SEMI.cs:603 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ if (!pDivisionID.Equals("EE")) | COMBO_DATA | Data.Common | (Data.Type.LookupCommon, false, "OPERATION_GROUP_SEMI") ⇒ biz:CommonData.CommonDataList [code=LookupCommon] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-75f8a103 | this.Load 외 1 | SSP0010_Shipment_Plan_SEMI.cs:604 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ if (!pDivisionID.Equals("EE")) | LIST_REBIND | clsCtrl.setListBox | (dtOperGrp, cboOperGroup, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-13df2e44 | this.Load 외 1 | SSP0010_Shipment_Plan_SEMI.cs:608 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ else of (!pDivisionID.Equals("EE")) | FLAG | dtOperGrp | Data.Common(Data.Type.LookupCommon, false, "OPERATION_GROUP_SEMI_EE") ⇒ biz:CommonData.CommonDataList [code=LookupCommon] | 화면 필드/플래그 변경 |  |  |  |
| AC-c39c3cd3 | this.Load 외 1 | SSP0010_Shipment_Plan_SEMI.cs:608 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ else of (!pDivisionID.Equals("EE")) | COMBO_DATA | Data.Common | (Data.Type.LookupCommon, false, "OPERATION_GROUP_SEMI_EE") ⇒ biz:CommonData.CommonDataList [code=LookupCommon] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-8080b624 | this.Load 외 1 | SSP0010_Shipment_Plan_SEMI.cs:609 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ else of (!pDivisionID.Equals("EE")) | LIST_REBIND | clsCtrl.setListBox | (dtOperGrp, cboOperGroup, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-1bb13b69 | this.Load 외 1 | SSP0010_Shipment_Plan_SEMI.cs:613 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | FLAG | dtPlanDateShip | Data.Common(Data.Type.PlanDateShip, false, pDivisionID) ⇒ biz:CommonData.CommonDataList [code=PlanDateShip] | 화면 필드/플래그 변경 |  |  |  |
| AC-942687d5 | this.Load 외 1 | SSP0010_Shipment_Plan_SEMI.cs:613 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | COMBO_DATA | Data.Common | (Data.Type.PlanDateShip, false, pDivisionID) ⇒ biz:CommonData.CommonDataList [code=PlanDateShip] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-1ce1bf04 | this.Load 외 1 | SSP0010_Shipment_Plan_SEMI.cs:614 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | LIST_REBIND | clsCtrl.setListBox | (dtPlanDateShip, cboPlanDate, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-26c64765 | this.Load 외 1 | SSP0010_Shipment_Plan_SEMI.cs:617 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | FLAG | dtPlanTypeShip | Data.Common(Data.Type.PlanTypeShip, false, pDivisionID, pPlanDate) ⇒ biz:CommonData.CommonDataList [code=PlanTypeShip] | 화면 필드/플래그 변경 |  |  |  |
| AC-c4a7b4d5 | this.Load 외 1 | SSP0010_Shipment_Plan_SEMI.cs:617 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | COMBO_DATA | Data.Common | (Data.Type.PlanTypeShip, false, pDivisionID, pPlanDate) ⇒ biz:CommonData.CommonDataList [code=PlanTypeShip] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-6010b227 | this.Load 외 1 | SSP0010_Shipment_Plan_SEMI.cs:618 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | LIST_REBIND | clsCtrl.setListBox | (dtPlanTypeShip, cboPlanType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-e05020f0 | this.Load 외 1 | SSP0010_Shipment_Plan_SEMI.cs:621 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ if (dtPlanTypeShip.Rows.Count > 0) | VALUE_SET | cboPlanType.SelectedIndex | dtPlanTypeShip.Rows.Count - 1 | 컨트롤 값 설정 |  |  |  |
| AC-1eb54ba6 | this.Load 외 1 | SSP0010_Shipment_Plan_SEMI.cs:624 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | FLAG | dtPlanSeqShip | Data.Common(Data.Type.PlanSeqShip, false, pDivisionID, pPlanDate, pPlanType) ⇒ biz:CommonData.CommonDataList [code=PlanSeqShip] | 화면 필드/플래그 변경 |  |  |  |
| AC-ee049a14 | this.Load 외 1 | SSP0010_Shipment_Plan_SEMI.cs:624 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | COMBO_DATA | Data.Common | (Data.Type.PlanSeqShip, false, pDivisionID, pPlanDate, pPlanType) ⇒ biz:CommonData.CommonDataList [code=PlanSeqShip] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-719253f6 | this.Load 외 1 | SSP0010_Shipment_Plan_SEMI.cs:625 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | LIST_REBIND | clsCtrl.setListBox | (dtPlanSeqShip, cboPlanSeq, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-de7cfdd1 | this.Load 외 1 | SSP0010_Shipment_Plan_SEMI.cs:629 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ if (pDivisionID != "EE") | VALUE_CLEAR | clbElectrode.ControlValues | "" | 컨트롤 값 비움 |  |  |  |
| AC-d1769934 | this.Load 외 1 | SSP0010_Shipment_Plan_SEMI.cs:630 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ if (pDivisionID != "EE") | STATE | clbElectrode.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-84634682 | this.Load 외 1 | SSP0010_Shipment_Plan_SEMI.cs:634 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ else of (pDivisionID != "EE") | STATE | clbElectrode.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## SSP0010_Shipment_Plan_SEMI.SetChangedPeriod

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5f21cab6 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:2639 | if (string.IsNullOrEmpty(strcboPlanDate)) | COMBO_DATA | Data.CallBizCommonData | ("PERIOD_" + value) ⇒ biz:CommonData.CommonDataList [code=PERIOD_{p:value}] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-63c53a89 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:2643 | else of (string.IsNullOrEmpty(strcboPlanDate)) | COMBO_DATA | Data.CallBizCommonData | ("PERIOD2_" + value, strcboPlanDate) ⇒ biz:CommonData.CommonDataList [code=PERIOD2_{p:value}] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-92d1c0f7 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:2646 | if (dt == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-12806a38 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:2650 | if (dt.Rows.Count > 0) | UI_PROP | drpPeriod.Text1 | dt.Rows[0]["FROM_VALUE"].ToString() | 속성 Text1 설정 |  |  |  |
| AC-93c7f71b | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:2651 | if (dt.Rows.Count > 0) | UI_PROP | drpPeriod.Text2 | dt.Rows[0]["TO_VALUE"].ToString() | 속성 Text2 설정 |  |  |  |

## SSP0010_Shipment_Plan_SEMI.SetSpreadColumn

진입점: this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK)] / this.Load / this.chkSum.CheckedChanged [if (siMain != null)] / this.cboBucketType.SelectedIndexChanged [if (siMain != null)] / FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-626f4566 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | SSP0010_Shipment_Plan_SEMI.cs:557 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Daily) ▸ if (siObj.GetColumnTag(iCol).IndexOf("D_") … | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-51a6ad81 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | SSP0010_Shipment_Plan_SEMI.cs:562 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Daily) ▸ if (siObj.GetColumnTag(iCol).IndexOf("M_") … | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | chkSum.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-4c59a10d | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | SSP0010_Shipment_Plan_SEMI.cs:569 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Buc… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-bbd9a739 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | SSP0010_Shipment_Plan_SEMI.cs:573 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Buc… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-f1a4533d | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | SSP0010_Shipment_Plan_SEMI.cs:578 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Buc… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | chkSum.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-9ecaea68 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | SSP0010_Shipment_Plan_SEMI.cs:585 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ else of (cboBucketType.ControlValues =… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-6a75160f | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | SSP0010_Shipment_Plan_SEMI.cs:589 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ else of (cboBucketType.ControlValues =… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |

## SSP0010_Shipment_Plan_SEMI.SetTableInfo

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-134d437a | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1377 | for (i <= target_idx) ▸ if (i <= target_idx) | DATA_OP | dt.Columns.Add | (dtQty.Columns[i].ColumnName) | 데이터 객체 조작/조회 |  |  |  |
| AC-d845d097 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1384 | for (i < dtHeader.Rows.Count) | DATA_OP | dt.Columns.Add | (dtHeader.Rows[i][0].ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-782e8b74 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1387 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SSP0010_Shipment_Plan_SEMI.SpdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fa878423 | this.spdMain.CellDoubleClick | SSP0010_Shipment_Plan_SEMI.cs:2611 |  | CALL_EXT | siMain.SetDblClickColumnShowHide | (sender, e) | ⚠ 의미 확인 필요 |  |  |  |

## SSP0010_Shipment_Plan_SEMI.SpdMain_KeyUp

진입점: this.spdMain.KeyUp

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f529a6d1 | this.spdMain.KeyUp | SSP0010_Shipment_Plan_SEMI.cs:502 | if (siMain.GetColumnIndex(DefMain.MEASURE) >= siMain.ActiveColumnIndex) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-60d3159b | this.spdMain.KeyUp | SSP0010_Shipment_Plan_SEMI.cs:506 | if (e.Control == true && e.KeyCode == Keys.V \|\| e.Control == false && e.KeyCode == Keys.V) | CALL_EXT | spdMain.ActiveSheet.ClipboardPaste | (ClipboardPasteOptions.AsStringSkipHidden) | ⚠ 의미 확인 필요 |  |  |  |
| AC-99cd3a9c | this.spdMain.KeyUp | SSP0010_Shipment_Plan_SEMI.cs:511 | if (e.Control == true && e.KeyCode == Keys.C \|\| e.Control == false && e.KeyCode == Keys.C) | CALL_EXT | Clipboard.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-4daf7984 | this.spdMain.KeyUp | SSP0010_Shipment_Plan_SEMI.cs:512 | if (e.Control == true && e.KeyCode == Keys.C \|\| e.Control == false && e.KeyCode == Keys.C) | CALL_EXT | spdMain.Sheets[0].ClipboardCopy | (ClipboardCopyOptions.AsStringSkipHidden) | ⚠ 의미 확인 필요 |  |  |  |

## SSP0010_Shipment_Plan_SEMI.spdMain_TopChange

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-00a6c6d4 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:2576 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SSP0010_Shipment_Plan_SEMI.SpdMain_TopChange

진입점: this.spdMain.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-087910e9 | this.spdMain.TopChange | SSP0010_Shipment_Plan_SEMI.cs:2731 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SSP0010_Shipment_Plan_SEMI.SubSumMerge

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-828e87af | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1595 |  | DATA_OP | dtBinding.Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-ea4018a5 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1610 | for (iRow <= r2) | DATA_OP | dicSubSumItems.ContainsKey | (target) | 데이터 객체 조작/조회 |  |  |  |
| AC-d34ac66b | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1612 | for (iRow <= r2) ▸ if (dicSubSumItems.ContainsKey(target)) | DATA_OP | (dicSubSumItems[target]).Add | (iRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-f50bee89 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1622 | foreach (var pair in dicSubSumItems) | DATA_OP | tmp.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-733a86e2 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1628 | foreach (var pair in dicSubSumItems) ▸ for (iCol <= subsum_begin) | DATA_OP | dr[iCol] | dtBinding.Rows[r2][iCol] | 행/컬럼 값 대입 |  |  |  |
| AC-11117b8c | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1634 | foreach (var pair in dicSubSumItems) ▸ for (iCol <= targetColumn) | DATA_OP | dr[iCol] | "Total" | 행/컬럼 값 대입 |  |  |  |
| AC-203a91db | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1637 | foreach (var pair in dicSubSumItems) ▸ for (iCol <= targetColumn) ▸ if (iCol == targetColumn) | DATA_OP | dr[iCol] | colName | 행/컬럼 값 대입 |  |  |  |
| AC-188a0b92 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1648 | foreach (var pair in dicSubSumItems) ▸ for (sCol < dtBinding.Columns.Count) | DATA_OP | dr[sCol] | sum | 행/컬럼 값 대입 |  |  |  |
| AC-efd1c92a | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1651 | foreach (var pair in dicSubSumItems) | DATA_OP | tmp.Rows.Add | (dr) | 데이터 객체 조작/조회 |  |  |  |
| AC-29166572 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1653 |  | DATA_OP | tmp.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-68fa701b | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1654 |  | DATA_OP | dtBinding.Merge | (tmp) | 데이터 객체 조작/조회 |  |  |  |
| AC-0d2f0aed | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1660 | foreach (var pair in dicSubSumItems) ▸ if (dicSubSumItems[pair.Key] != null) | CALL_EXT | (dicSubSumItems[pair.Key]).Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-cc3df36e | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1664 |  | STATE_RESET | dicSubSum_Range.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-26195f8b | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1668 | if (!next_key.Equals("")) | DATA_OP | dicSubSum_Range.Add | (next_key, dtBinding.Rows.Count + 1) | 데이터 객체 조작/조회 |  |  |  |

## SSP0010_Shipment_Plan_SEMI.TotalCellsMerge

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5655c1e0 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1179 |  | DATA_OP | list.Add | (siMain.GetColumnIndex(DefMain.TO_SITE_DESCRIPTION)) | 데이터 객체 조작/조회 |  |  |  |
| AC-0ecb1961 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1180 |  | DATA_OP | list.Add | (siMain.GetColumnIndex(DefMain.TRANSPORT_MODE)) | 데이터 객체 조작/조회 |  |  |  |
| AC-6c17c989 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1181 |  | DATA_OP | list.Add | (siMain.GetColumnIndex(DefMain.LT_DAY)) | 데이터 객체 조작/조회 |  |  |  |
| AC-4acd06b9 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1206 | for (iRow <= siMain.GetMaxRowIndex()) ▸ if (cur_key_idx != bef_key_idx) ▸ foreach (int idx in list) | UI_PROP | range.HorizontalAlignment | CellHorizontalAlignment.Center | 속성 HorizontalAlignment 설정 |  |  |  |
| AC-7a4423dc | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1207 | for (iRow <= siMain.GetMaxRowIndex()) ▸ if (cur_key_idx != bef_key_idx) ▸ foreach (int idx in list) | UI_PROP | range.ForeColor | Color.Black | 속성 ForeColor 설정 |  |  |  |
| AC-8e4d8156 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1208 | for (iRow <= siMain.GetMaxRowIndex()) ▸ if (cur_key_idx != bef_key_idx) ▸ foreach (int idx in list) | UI_PROP | range.RowSpan | rowSpan_Count | 속성 RowSpan 설정 |  |  |  |
| AC-7be2b30f | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1212 | for (iRow <= siMain.GetMaxRowIndex()) ▸ if (cur_key_idx != bef_key_idx) | UI_PROP | boh.HorizontalAlignment | CellHorizontalAlignment.Center | 속성 HorizontalAlignment 설정 |  |  |  |
| AC-cfa73864 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1213 | for (iRow <= siMain.GetMaxRowIndex()) ▸ if (cur_key_idx != bef_key_idx) | UI_PROP | boh.RowSpan | bohSpan_Count | 속성 RowSpan 설정 |  |  |  |
| AC-62f58382 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1243 | for (iRow <= siMain.GetMaxRowIndex()) ▸ if (iRow == siMain.GetMaxRowIndex()) ▸ if (isSum) ▸ foreach (int idx in list) | UI_PROP | range.HorizontalAlignment | CellHorizontalAlignment.Center | 속성 HorizontalAlignment 설정 |  |  |  |
| AC-42588620 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1244 | for (iRow <= siMain.GetMaxRowIndex()) ▸ if (iRow == siMain.GetMaxRowIndex()) ▸ if (isSum) ▸ foreach (int idx in list) | UI_PROP | range.ForeColor | Color.Black | 속성 ForeColor 설정 |  |  |  |
| AC-abd737e1 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1245 | for (iRow <= siMain.GetMaxRowIndex()) ▸ if (iRow == siMain.GetMaxRowIndex()) ▸ if (isSum) ▸ foreach (int idx in list) | UI_PROP | range.RowSpan | rowSpan_Count | 속성 RowSpan 설정 |  |  |  |
| AC-467eacd7 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1249 | for (iRow <= siMain.GetMaxRowIndex()) ▸ if (iRow == siMain.GetMaxRowIndex()) ▸ if (isSum) | UI_PROP | boh.HorizontalAlignment | CellHorizontalAlignment.Center | 속성 HorizontalAlignment 설정 |  |  |  |
| AC-c3597618 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:1250 | for (iRow <= siMain.GetMaxRowIndex()) ▸ if (iRow == siMain.GetMaxRowIndex()) ▸ if (isSum) | UI_PROP | boh.RowSpan | bohSpan_Count | 속성 RowSpan 설정 |  |  |  |

## SSP0010_Shipment_Plan_SEMI.ValidateUserInput

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ccd81bad | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:2075 | if (action_name.Equals("NO_DATA")) ▸ if (siMain.ActiveSheet.RowCount <= 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00059") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-cbf06e0d | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:2082 | else of (action_name.Equals("NO_DATA")) ▸ if (action_name.Equals("NO_CHECKED")) | MESSAGE | MessageHelper.GMessageBox | ("MSG00017") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-38dd1f3f | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:2096 | else of (action_name.Equals("NO_DATA")) ▸ else of (action_name.Equals("NO_CHECKED")) ▸ if (action_name.Equals("CHK_PERIOD")) ▸ if (DateTime.… | MESSAGE | MessageHelper.GMessageBox | ("MSG00171") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-10dca559 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:2098 | else of (action_name.Equals("NO_DATA")) ▸ else of (action_name.Equals("NO_CHECKED")) ▸ if (action_name.Equals("CHK_PERIOD")) ▸ if (DateTime.… | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |
| AC-6d52c529 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:2104 | else of (action_name.Equals("NO_DATA")) ▸ else of (action_name.Equals("NO_CHECKED")) ▸ if (action_name.Equals("CHK_PERIOD")) ▸ if (diff.Days… | MESSAGE | MessageHelper.GMessageBox | ("MSG00172", new object[] { 364 }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9cea59f5 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:2111 | else of (action_name.Equals("NO_DATA")) ▸ else of (action_name.Equals("NO_CHECKED")) ▸ else of (action_name.Equals("CHK_PERIOD")) ▸ if (acti… | MESSAGE | MessageHelper.GMessageBox | ("MSG00084") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b700aa21 | (진입점 미연결) | SSP0010_Shipment_Plan_SEMI.cs:2115 |  | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |

