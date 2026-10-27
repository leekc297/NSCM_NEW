# AS-IS 액션 대조표 — SCP0058

> 원천: `Doc/asisfacts/screens/SCP0058/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 983행 · 메서드 69 · 종류 DATA_OP 501 · RETURN 59 · UI_PROP 47 · FLAG 45 · GRID_SET 41 · CALL_EXT 35 · MESSAGE 33 · ENDPOINT 31 · GRID_INIT 30 · UI_MISC 28 · POPUP 26 · COMBO_DATA 20 · LIST_REBIND 16 · GRID_LOCK 15 · STATE 14 · VALUE_SET 13 · GRID_CLEAR 10 · GRID_STYLE 6 · GRID_BIND 4 · VALIDATE 3 · STATE_RESET 3 · LIST_CLEAR 2 · VALUE_CLEAR 1 · ⚠ 의미 확인 필요 35


## SCP0058_Shipment_Plan_FG_JV.BlockCellsChecking

진입점: this.spdMain.CellClick [if ((e.Column == siMain.GetColumnIndex(DefMain.TRANSPORT_MODE) \|\| e.Column == siMain.GetColumnIndex(DefMain.FROM_SITE_NAME))…)] / EditButton [if (fps != null) ▸ if (this.IsEditMode) ▸ if (EditBlockChecking(2) != 1)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-afcbe1c5 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… 외 1 | SCP0058_Shipment_Plan_FG_JV.cs:2409 | for (iRow < siMain.ActiveSheet.Rows.Count) ▸ if (siMain.GetValue(iRow, measure_idx).ToString().Equals("SHIP_PLAN_AMEND") && !siMain.GetValue… | GRID_LOCK | siMain.LockRange | (iRow, 1, iRow, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-2468460e | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… 외 1 | SCP0058_Shipment_Plan_FG_JV.cs:2430 | for (iRow < siMain.ActiveSheet.Rows.Count) ▸ if (siMain.GetValue(iRow, measure_idx).ToString().Equals("SHIP_PLAN_AMEND") && !siMain.GetValue… | CALL_EXT | frozenDate.CompareTo | (dtBodTo) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9a7ffa4a | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… 외 1 | SCP0058_Shipment_Plan_FG_JV.cs:2434 | for (iRow < siMain.ActiveSheet.Rows.Count) ▸ if (siMain.GetValue(iRow, measure_idx).ToString().Equals("SHIP_PLAN_AMEND") && !siMain.GetValue… | CALL_EXT | dtBodFrom.CompareTo | (frozenDate) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a9791107 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… 외 1 | SCP0058_Shipment_Plan_FG_JV.cs:2442 | for (iRow < siMain.ActiveSheet.Rows.Count) ▸ if (siMain.GetValue(iRow, measure_idx).ToString().Equals("SHIP_PLAN_AMEND") && !siMain.GetValue… | CALL_EXT | frozenDate.CompareTo | (dtBodFrom) | ⚠ 의미 확인 필요 |  |  |  |
| AC-25e68dae | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… 외 1 | SCP0058_Shipment_Plan_FG_JV.cs:2442 | for (iRow < siMain.ActiveSheet.Rows.Count) ▸ if (siMain.GetValue(iRow, measure_idx).ToString().Equals("SHIP_PLAN_AMEND") && !siMain.GetValue… | CALL_EXT | dtBodTo.CompareTo | (frozenDate) | ⚠ 의미 확인 필요 |  |  |  |
| AC-5eeb08bc | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… 외 1 | SCP0058_Shipment_Plan_FG_JV.cs:2465 | for (iRow < siMain.ActiveSheet.Rows.Count) ▸ if (siMain.GetValue(iRow, measure_idx).ToString().Equals("SHIP_PLAN_AMEND") && !siMain.GetValue… | DATA_OP | lstBlockWeek_Month.Add | (iCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-22d5e9d0 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… 외 1 | SCP0058_Shipment_Plan_FG_JV.cs:2495 | for (iRow < siMain.ActiveSheet.Rows.Count) ▸ if (siMain.GetValue(iRow, measure_idx).ToString().Equals("SHIP_PLAN_AMEND") && !siMain.GetValue… | GRID_LOCK | siMain.LockRange | (iRow, 1, iRow, nBlockColumnEnd, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-3230ed9d | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… 외 1 | SCP0058_Shipment_Plan_FG_JV.cs:2496 | for (iRow < siMain.ActiveSheet.Rows.Count) ▸ if (siMain.GetValue(iRow, measure_idx).ToString().Equals("SHIP_PLAN_AMEND") && !siMain.GetValue… | GRID_LOCK | siMain.LockRange | (iRow, nBlockColumnEnd + 1, iRow, siMain.GetMaxColumnIndex(), false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-3fd554a9 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… 외 1 | SCP0058_Shipment_Plan_FG_JV.cs:2500 | for (iRow < siMain.ActiveSheet.Rows.Count) ▸ if (siMain.GetValue(iRow, measure_idx).ToString().Equals("SHIP_PLAN_AMEND") && !siMain.GetValue… | GRID_LOCK | siMain.LockRange | (iRow, 1, iRow, nBlockColumnEnd, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-80a5a453 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… 외 1 | SCP0058_Shipment_Plan_FG_JV.cs:2501 | for (iRow < siMain.ActiveSheet.Rows.Count) ▸ if (siMain.GetValue(iRow, measure_idx).ToString().Equals("SHIP_PLAN_AMEND") && !siMain.GetValue… | GRID_LOCK | siMain.LockRange | (iRow, nBlockColumnEnd + 1, iRow, iBlockLastIdx, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-ef824740 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… 외 1 | SCP0058_Shipment_Plan_FG_JV.cs:2502 | for (iRow < siMain.ActiveSheet.Rows.Count) ▸ if (siMain.GetValue(iRow, measure_idx).ToString().Equals("SHIP_PLAN_AMEND") && !siMain.GetValue… | GRID_LOCK | siMain.LockRange | (iRow, iBlockLastIdx + 1, iRow, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-cec2b791 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… 외 1 | SCP0058_Shipment_Plan_FG_JV.cs:2510 | for (iRow < siMain.ActiveSheet.Rows.Count) ▸ if (siMain.GetValue(iRow, measure_idx).ToString().Equals("SHIP_PLAN_AMEND") && !siMain.GetValue… | GRID_LOCK | siMain.LockRange2 | (iRow, col, iRow, col, true) | 그리드 편집 잠금 전환 |  |  |  |
| AC-26de53e2 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… 외 1 | SCP0058_Shipment_Plan_FG_JV.cs:2512 | for (iRow < siMain.ActiveSheet.Rows.Count) ▸ if (siMain.GetValue(iRow, measure_idx).ToString().Equals("SHIP_PLAN_AMEND") && !siMain.GetValue… | UI_MISC | spdMain.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-0a41371e | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… 외 1 | SCP0058_Shipment_Plan_FG_JV.cs:2516 | for (iRow < siMain.ActiveSheet.Rows.Count) ▸ else of (siMain.GetValue(iRow, measure_idx).ToString().Equals("SHIP_PLAN_AMEND") && !siMain.Get… | GRID_LOCK | siMain.LockRange | (iRow, 1, iRow, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |

## SCP0058_Shipment_Plan_FG_JV.BtnColumn_Click

진입점: this.btnColumn.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5d908a62 | this.btnColumn.Click | SCP0058_Shipment_Plan_FG_JV.cs:1008 |  | POPUP | new SCM0002_TitleSetForm_Popup | ("SCP0058", SpdSheet.shtMain, true) | 팝업/폼 생성 |  |  |  |
| AC-b2393c6e | this.btnColumn.Click | SCP0058_Shipment_Plan_FG_JV.cs:1009 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-b003fb87 | this.btnColumn.Click | SCP0058_Shipment_Plan_FG_JV.cs:1010 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## SCP0058_Shipment_Plan_FG_JV.BtnFix_Click

진입점: this.btnFix.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9e908388 | this.btnFix.Click | SCP0058_Shipment_Plan_FG_JV.cs:1057 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-82a42c7d | this.btnFix.Click | SCP0058_Shipment_Plan_FG_JV.cs:1058 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ac0a00fd | this.btnFix.Click | SCP0058_Shipment_Plan_FG_JV.cs:1064 | if (fps != null) ▸ if (dsBinding.Tables.Count == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4b9dad20 | this.btnFix.Click | SCP0058_Shipment_Plan_FG_JV.cs:1068 | if (fps != null) ▸ if (siMain.IsLock(siMain.SheetName)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00010") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9b38372d | this.btnFix.Click | SCP0058_Shipment_Plan_FG_JV.cs:1072 | if (fps != null) ▸ else of (siMain.IsLock(siMain.SheetName)) ▸ if (!Get_IsSaveYn()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0058_Shipment_Plan_FG_JV.BtnItem_Id_Click

진입점: this.btnItem_Id.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6960e8fd | this.btnItem_Id.Click | SCP0058_Shipment_Plan_FG_JV.cs:3936 |  | CALL_EXT | UIUtils.GetAllDivisionCheckedElectrode | (cboDivision) | ⚠ 의미 확인 필요 |  |  |  |
| AC-5eed574f | this.btnItem_Id.Click | SCP0058_Shipment_Plan_FG_JV.cs:3938 |  | POPUP | new SCM0002_ItembyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-6418e477 | this.btnItem_Id.Click | SCP0058_Shipment_Plan_FG_JV.cs:3940 |  | POPUP | popItem.Form_Load | (true, division, sScmSite, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-4dcf1393 | this.btnItem_Id.Click | SCP0058_Shipment_Plan_FG_JV.cs:3941 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-5ee26e26 | this.btnItem_Id.Click | SCP0058_Shipment_Plan_FG_JV.cs:3942 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-941da3b5 | this.btnItem_Id.Click | SCP0058_Shipment_Plan_FG_JV.cs:3948 | if (popItem.ItemID != "") | VALUE_SET | txtItem_Id.Text | sItemId | 컨트롤 값 설정 |  |  |  |

## SCP0058_Shipment_Plan_FG_JV.btnMeasure_Click

진입점: this.btnMeasure.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-432be79f | this.btnMeasure.Click | SCP0058_Shipment_Plan_FG_JV.cs:3977 |  | POPUP | new SCM0002_TitleSetForm_Popup | ("SCP0058", measure, false) | 팝업/폼 생성 |  |  |  |
| AC-f1bbae88 | this.btnMeasure.Click | SCP0058_Shipment_Plan_FG_JV.cs:3978 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-b09f94e9 | this.btnMeasure.Click | SCP0058_Shipment_Plan_FG_JV.cs:3979 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-3a96514c | this.btnMeasure.Click | SCP0058_Shipment_Plan_FG_JV.cs:3983 | if (frm.DialogResult == DialogResult.OK) | UI_PROP | this.CanModelChange | false | 속성 CanModelChange 설정 |  |  |  |
| AC-c9b26dd2 | this.btnMeasure.Click | SCP0058_Shipment_Plan_FG_JV.cs:3986 | if (frm.DialogResult == DialogResult.OK) | UI_PROP | this.CanModelChange | true | 속성 CanModelChange 설정 |  |  |  |

## SCP0058_Shipment_Plan_FG_JV.BtnNew_Click

진입점: this.btnNew.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-06d0457e | this.btnNew.Click | SCP0058_Shipment_Plan_FG_JV.cs:1134 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ca52c899 | this.btnNew.Click | SCP0058_Shipment_Plan_FG_JV.cs:1135 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-afeb7091 | this.btnNew.Click | SCP0058_Shipment_Plan_FG_JV.cs:1139 | if (cboPlanDate.ControlValues == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e4fd02f3 | this.btnNew.Click | SCP0058_Shipment_Plan_FG_JV.cs:1141 | if (!Get_IsSaveYn()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-39499c6a | this.btnNew.Click | SCP0058_Shipment_Plan_FG_JV.cs:1151 | if (this._division.Substring(0, 2).Equals("EE") && this._operationGroup == "A") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-32f7fc58 | this.btnNew.Click | SCP0058_Shipment_Plan_FG_JV.cs:1153 |  | POPUP | new SCM0002_ShipmentPlanInsertPopup | () | 팝업/폼 생성 |  |  |  |
| AC-43ca0558 | this.btnNew.Click | SCP0058_Shipment_Plan_FG_JV.cs:1154 |  | UI_PROP | popup.divisionId | this._division | 속성 divisionId 설정 |  |  |  |
| AC-ab28fd6c | this.btnNew.Click | SCP0058_Shipment_Plan_FG_JV.cs:1155 |  | UI_PROP | popup.p_operationGroup | this._operationGroup | 속성 p_operationGroup 설정 |  |  |  |
| AC-d8e580c7 | this.btnNew.Click | SCP0058_Shipment_Plan_FG_JV.cs:1156 |  | UI_PROP | popup.p_planDate | dPlanDate | 속성 p_planDate 설정 |  |  |  |
| AC-f509b1f3 | this.btnNew.Click | SCP0058_Shipment_Plan_FG_JV.cs:1157 |  | UI_PROP | popup.p_plan_start_yyyymmdd | sPlanStartYyyymmdd | 속성 p_plan_start_yyyymmdd 설정 |  |  |  |
| AC-d7d078d0 | this.btnNew.Click | SCP0058_Shipment_Plan_FG_JV.cs:1158 |  | UI_PROP | popup.p_planType | sPlanType | 속성 p_planType 설정 |  |  |  |
| AC-e741507c | this.btnNew.Click | SCP0058_Shipment_Plan_FG_JV.cs:1159 |  | UI_PROP | popup.p_seq | sSeq | 속성 p_seq 설정 |  |  |  |
| AC-ab3c18e4 | this.btnNew.Click | SCP0058_Shipment_Plan_FG_JV.cs:1160 |  | UI_PROP | popup.p_user_id | UserInfo.UserId | 속성 p_user_id 설정 |  |  |  |
| AC-6c53576b | this.btnNew.Click | SCP0058_Shipment_Plan_FG_JV.cs:1161 |  | UI_PROP | popup.p_prgram_id | sPrg | 속성 p_prgram_id 설정 |  |  |  |
| AC-1e4a73d0 | this.btnNew.Click | SCP0058_Shipment_Plan_FG_JV.cs:1163 |  | UI_PROP | popup.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-2e6c1453 | this.btnNew.Click | SCP0058_Shipment_Plan_FG_JV.cs:1164 |  | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-8722356d | this.btnNew.Click | SCP0058_Shipment_Plan_FG_JV.cs:1175 | if (popup.DialogResult == DialogResult.OK) ▸ else of (this._division.Substring(0, 2).Equals("EE")) | VALUE_SET | txtItem_Id.Text | popup.s_ItemId | 컨트롤 값 설정 |  |  |  |
| AC-1c728436 | this.btnNew.Click | SCP0058_Shipment_Plan_FG_JV.cs:1178 | if (popup.DialogResult == DialogResult.OK) ▸ else of (this._division.Substring(0, 2).Equals("EE")) | MESSAGE | MessageHelper.GMessageBox | ("MSG00265") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SCP0058_Shipment_Plan_FG_JV.btnNewControl

진입점: this.Load [if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))] / cboDivision.SelectedIndexChanged [if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))] / cboBizType.SelectedIndexChanged / cboPlanDate.SelectedIndexChanged [else of (sPlanType.Equals("FN") \|\| sPlanType.Equals("TE")) ▸ if (!string.IsNullOrEmpty(CString.GetCheckedListValue(dtPlanSeq, cboPlanSeq.ControlValues, true))) ▸ if (curPlanSeq == maxSeq)] / cboPlanType.SelectedIndexChanged [else of (sPlanType.Equals("FN") \|\| sPlanType.Equals("TE")) ▸ if (!string.IsNullOrEmpty…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3fb8d8d0 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 5 | SCP0058_Shipment_Plan_FG_JV.cs:4010 | if ((this._division.Substring(0, 2).Equals("EE") && this._operationGroup == "A") \|\| this._planType == "FN") | STATE | btnNew.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-1e77626c | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 5 | SCP0058_Shipment_Plan_FG_JV.cs:4014 | else of ((this._division.Substring(0, 2).Equals("EE") && this._operationGroup == "A") \|\| this._planType == "FN") | STATE | btnNew.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## SCP0058_Shipment_Plan_FG_JV.BtnProject_Click

진입점: this.btnProject.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ba99a0b0 | this.btnProject.Click | SCP0058_Shipment_Plan_FG_JV.cs:3958 |  | CALL_EXT | UIUtils.GetAllDivisionCheckedElectrode | (cboDivision) | ⚠ 의미 확인 필요 |  |  |  |
| AC-5cc3fa53 | this.btnProject.Click | SCP0058_Shipment_Plan_FG_JV.cs:3960 |  | POPUP | new SCM0002_ProjectbyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-afd3bdff | this.btnProject.Click | SCP0058_Shipment_Plan_FG_JV.cs:3962 |  | POPUP | popProject.Form_Load | (true, division, sProject) | 팝업 초기화(인자 전달) |  |  |  |
| AC-27c2e2af | this.btnProject.Click | SCP0058_Shipment_Plan_FG_JV.cs:3963 |  | UI_PROP | popProject.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-c321786b | this.btnProject.Click | SCP0058_Shipment_Plan_FG_JV.cs:3964 |  | POPUP | popProject.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-7db8ab24 | this.btnProject.Click | SCP0058_Shipment_Plan_FG_JV.cs:3970 | if (popProject.ProjectCode != "") | VALUE_SET | txtProject.Text | sProjectCode | 컨트롤 값 설정 |  |  |  |

## SCP0058_Shipment_Plan_FG_JV.BtnUnfix_Click

진입점: this.btnUnfix.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6af5065b | this.btnUnfix.Click | SCP0058_Shipment_Plan_FG_JV.cs:1093 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c8119da0 | this.btnUnfix.Click | SCP0058_Shipment_Plan_FG_JV.cs:1094 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b5161028 | this.btnUnfix.Click | SCP0058_Shipment_Plan_FG_JV.cs:1100 | if (fps != null) ▸ if (dsBinding.Tables.Count == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d61df01c | this.btnUnfix.Click | SCP0058_Shipment_Plan_FG_JV.cs:1104 | if (fps != null) ▸ if (siMain.IsLock(siMain.SheetName)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00010") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-031b8f3d | this.btnUnfix.Click | SCP0058_Shipment_Plan_FG_JV.cs:1108 | if (fps != null) ▸ else of (siMain.IsLock(siMain.SheetName)) ▸ if (!Get_IsSaveYn()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-566d3b98 | this.btnUnfix.Click | SCP0058_Shipment_Plan_FG_JV.cs:1117 | if (fps != null) ▸ else of (siMain.IsLock(siMain.SheetName)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00016") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SCP0058_Shipment_Plan_FG_JV.BtnW26_Click

진입점: this.btnW26.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a5f08b64 | this.btnW26.Click | SCP0058_Shipment_Plan_FG_JV.cs:1020 |  | VALUE_SET | drpPeriod.InitValue | GetDayRange(PeriodType.W26) | 컨트롤 값 설정 |  |  |  |

## SCP0058_Shipment_Plan_FG_JV.BtnW52_Click

진입점: this.btnW52.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b2be84d5 | this.btnW52.Click | SCP0058_Shipment_Plan_FG_JV.cs:1025 |  | VALUE_SET | drpPeriod.InitValue | GetDayRange(PeriodType.W52) | 컨트롤 값 설정 |  |  |  |

## SCP0058_Shipment_Plan_FG_JV.BtnWLast_Click

진입점: this.btnWLast.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2831c219 | this.btnWLast.Click | SCP0058_Shipment_Plan_FG_JV.cs:1035 |  | VALUE_SET | drpPeriod.InitValue | GetDayRange(sPeriod) | 컨트롤 값 설정 |  |  |  |

## SCP0058_Shipment_Plan_FG_JV.CboBizType_SelectedIndexChanged

진입점: cboBizType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b6ef44e6 | cboBizType.SelectedIndexChanged | SCP0058_Shipment_Plan_FG_JV.cs:4486 | if (dic_JV_Plant.Count == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0058_Shipment_Plan_FG_JV.cboBucketType_SelectedIndexChanged

진입점: this.cboBucketType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-09a6c2ec | this.cboBucketType.SelectedIndexChanged | SCP0058_Shipment_Plan_FG_JV.cs:3870 | else of (chkAll.Checked) | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |

## SCP0058_Shipment_Plan_FG_JV.CboDivision_SelectedIndexChanged

진입점: cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c91a9fac | cboDivision.SelectedIndexChanged | SCP0058_Shipment_Plan_FG_JV.cs:1240 | if (dic_JV_Plant.Count == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0058_Shipment_Plan_FG_JV.CboPlanDate_SelectedIndexChanged

진입점: cboPlanDate.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c85bad5b | cboPlanDate.SelectedIndexChanged | SCP0058_Shipment_Plan_FG_JV.cs:1254 |  | VALUE_SET | drpPeriod.InitValue | GetDayRange(PeriodType.W52) | 컨트롤 값 설정 |  |  |  |
| AC-32eb2d28 | cboPlanDate.SelectedIndexChanged | SCP0058_Shipment_Plan_FG_JV.cs:1256 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |
| AC-561dfed0 | cboPlanDate.SelectedIndexChanged | SCP0058_Shipment_Plan_FG_JV.cs:1258 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdPeggingInfo) | 그리드 데이터/선택 비움 |  |  |  |
| AC-ccc94048 | cboPlanDate.SelectedIndexChanged | SCP0058_Shipment_Plan_FG_JV.cs:1259 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdPlanProblem) | 그리드 데이터/선택 비움 |  |  |  |

## SCP0058_Shipment_Plan_FG_JV.CboPlanSeq_SelectedIndexChanged

진입점: cboPlanSeq.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f12fc563 | cboPlanSeq.SelectedIndexChanged | SCP0058_Shipment_Plan_FG_JV.cs:1042 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |
| AC-7c9b3ecf | cboPlanSeq.SelectedIndexChanged | SCP0058_Shipment_Plan_FG_JV.cs:1044 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdPeggingInfo) | 그리드 데이터/선택 비움 |  |  |  |
| AC-cbb1152b | cboPlanSeq.SelectedIndexChanged | SCP0058_Shipment_Plan_FG_JV.cs:1045 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdPlanProblem) | 그리드 데이터/선택 비움 |  |  |  |

## SCP0058_Shipment_Plan_FG_JV.CboPlanType_SelectedIndexChanged

진입점: cboPlanType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0c09bffc | cboPlanType.SelectedIndexChanged | SCP0058_Shipment_Plan_FG_JV.cs:1266 |  | VALUE_SET | cboPlanSeq.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-249eaa27 | cboPlanType.SelectedIndexChanged | SCP0058_Shipment_Plan_FG_JV.cs:1272 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |
| AC-b12fb9ba | cboPlanType.SelectedIndexChanged | SCP0058_Shipment_Plan_FG_JV.cs:1274 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdPeggingInfo) | 그리드 데이터/선택 비움 |  |  |  |
| AC-57de5bfd | cboPlanType.SelectedIndexChanged | SCP0058_Shipment_Plan_FG_JV.cs:1275 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdPlanProblem) | 그리드 데이터/선택 비움 |  |  |  |

## SCP0058_Shipment_Plan_FG_JV.clbTeam_SelectedIndexChanged

진입점: this.clbTeam.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b712614f | this.clbTeam.SelectedIndexChanged | SCP0058_Shipment_Plan_FG_JV.cs:4523 | if ((this._division == "81") \|\| (this._division == "82")) | FLAG | dtCustomer | Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.… | 화면 필드/플래그 변경 |  |  |  |
| AC-f7b10b83 | this.clbTeam.SelectedIndexChanged | SCP0058_Shipment_Plan_FG_JV.cs:4523 | if ((this._division == "81") \|\| (this._division == "82")) | COMBO_DATA | Data.UserEndCustomerByDivisionDept | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, this._division, sT… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-0a6fb180 | this.clbTeam.SelectedIndexChanged | SCP0058_Shipment_Plan_FG_JV.cs:4524 | if ((this._division == "81") \|\| (this._division == "82")) | LIST_REBIND | clsCtrl.setListBox | (dtCustomer, clbCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-b3fa8df8 | this.clbTeam.SelectedIndexChanged | SCP0058_Shipment_Plan_FG_JV.cs:4526 | if ((this._division == "81") \|\| (this._division == "82")) | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-0eb50cb7 | this.clbTeam.SelectedIndexChanged | SCP0058_Shipment_Plan_FG_JV.cs:4526 | if ((this._division == "81") \|\| (this._division == "82")) | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, this._division, sE… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-e5bbbd74 | this.clbTeam.SelectedIndexChanged | SCP0058_Shipment_Plan_FG_JV.cs:4530 | else of ((this._division == "81") \|\| (this._division == "82")) | FLAG | dtCustomer | Data.Common(Data.Type.EndCustomerByDivision40, false, this._division, clbTeam.ControlValue… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 화면 필드/플래그 변경 |  |  |  |
| AC-a03ec718 | this.clbTeam.SelectedIndexChanged | SCP0058_Shipment_Plan_FG_JV.cs:4530 | else of ((this._division == "81") \|\| (this._division == "82")) | COMBO_DATA | Data.Common | (Data.Type.EndCustomerByDivision40, false, this._division, clbTeam.ControlValues, UserInfo… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-05bb94fd | this.clbTeam.SelectedIndexChanged | SCP0058_Shipment_Plan_FG_JV.cs:4531 | else of ((this._division == "81") \|\| (this._division == "82")) | LIST_REBIND | clsCtrl.setListBox | (dtCustomer, clbCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-01c64b1a | this.clbTeam.SelectedIndexChanged | SCP0058_Shipment_Plan_FG_JV.cs:4533 | else of ((this._division == "81") \|\| (this._division == "82")) | FLAG | dtSalesSite | Data.Common(Data.Type.SiteByEndCustomer40, false, this._division, clbTeam.ControlValues, c… ⇒ biz:CommonData.CommonDataList [code=SiteByEndCustomer40] | 화면 필드/플래그 변경 |  |  |  |
| AC-e99addad | this.clbTeam.SelectedIndexChanged | SCP0058_Shipment_Plan_FG_JV.cs:4533 | else of ((this._division == "81") \|\| (this._division == "82")) | COMBO_DATA | Data.Common | (Data.Type.SiteByEndCustomer40, false, this._division, clbTeam.ControlValues, clbCustomer.… ⇒ biz:CommonData.CommonDataList [code=SiteByEndCustomer40] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-7a3c0828 | this.clbTeam.SelectedIndexChanged | SCP0058_Shipment_Plan_FG_JV.cs:4536 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbToSite, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0058_Shipment_Plan_FG_JV.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5c27aed0 | this.Load | SCP0058_Shipment_Plan_FG_JV.cs:671 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 3, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-adcab49c | this.Load | SCP0058_Shipment_Plan_FG_JV.cs:672 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-4690bad7 | this.Load | SCP0058_Shipment_Plan_FG_JV.cs:673 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b91e3a84 | this.Load | SCP0058_Shipment_Plan_FG_JV.cs:675 |  | GRID_INIT | this.AddSheet | (spdPeggingInfo, SpdSheet.shtPeggingInfo, SpdSheet.shtPeggingInfo, 1, 1, 50) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-2a14c392 | this.Load | SCP0058_Shipment_Plan_FG_JV.cs:676 |  | FLAG | siPeggingInfo | GetSheetInfo(spdPeggingInfo.Name, spdPeggingInfo.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-6fa9b34a | this.Load | SCP0058_Shipment_Plan_FG_JV.cs:678 |  | GRID_INIT | this.AddSheet | (spdPlanProblem, SpdSheet.shtPlanProblem, SpdSheet.shtPlanProblem, 1, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-3229f558 | this.Load | SCP0058_Shipment_Plan_FG_JV.cs:679 |  | FLAG | siPlanProblem | GetSheetInfo(spdPlanProblem.Name, 0) | 화면 필드/플래그 변경 |  |  |  |

## SCP0058_Shipment_Plan_FG_JV.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5df96ab1 | this.Load | SCP0058_Shipment_Plan_FG_JV.cs:278 |  | UI_PROP | usrConditionPanel1.Height | 100 | 속성 Height 설정 |  |  |  |
| AC-98e5bc74 | this.Load | SCP0058_Shipment_Plan_FG_JV.cs:280 |  | VALUE_SET | cboBucketType.SelectedValue | BucketType.Weekly | 컨트롤 값 설정 |  |  |  |

## SCP0058_Shipment_Plan_FG_JV.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-80717ea6 | Dispose | SCP0058_Shipment_Plan_FG_JV.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0058_Shipment_Plan_FG_JV.EditBlockChecking

진입점: this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock(siMain.SheetName)) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ if (iCount > 0) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Equals("S")) ▸ try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ if (p_bucket.ToString() == BucketType.Daily \|\| chkAll.Checked)] / this.btnUnfix.Click [if (fps != null) ▸ else of (siMain.IsLock(siMain.SheetName)) ▸ if (MessageHelper.GMessageBox("MSG00016") == DialogResult.Yes) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ if (iCount > 0) ▸ try ▸ …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-898a21e6 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 5 | SCP0058_Shipment_Plan_FG_JV.cs:2025 | if (number == 1) ▸ for (cols <= siMain.ActiveSheet.Columns.Count - 1) | DATA_OP | dateColumn.Contains | ("W_") | 데이터 객체 조작/조회 |  |  |  |
| AC-2eba8b95 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 5 | SCP0058_Shipment_Plan_FG_JV.cs:2029 | if (number == 1) ▸ for (cols <= siMain.ActiveSheet.Columns.Count - 1) ▸ else of (dateColumn.Contains("W_")) | DATA_OP | dateColumn.Contains | ("D_") | 데이터 객체 조작/조회 |  |  |  |
| AC-c11153d0 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 5 | SCP0058_Shipment_Plan_FG_JV.cs:2054 | if (number == 1) | RETURN | return retIndex == 0 ? siMain.GetMaxColumnIndex() : retIndex; |  | 처리 중단/반환 |  |  |  |
| AC-e464908a | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 5 | SCP0058_Shipment_Plan_FG_JV.cs:2063 |  | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |

## SCP0058_Shipment_Plan_FG_JV.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5f4c47e6 | EditButton | SCP0058_Shipment_Plan_FG_JV.cs:1309 | if (fps != null) ▸ if (dsBinding.Tables.Count == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-693dd079 | EditButton | SCP0058_Shipment_Plan_FG_JV.cs:1311 | if (fps != null) | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-b92c6870 | EditButton | SCP0058_Shipment_Plan_FG_JV.cs:1312 | if (fps != null) | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-efa89ef9 | EditButton | SCP0058_Shipment_Plan_FG_JV.cs:1314 | if (fps != null) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefMain.DIVISION_ID), siMain.nIdxData, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-45d37f52 | EditButton | SCP0058_Shipment_Plan_FG_JV.cs:1320 | if (fps != null) ▸ if (this.IsEditMode) ▸ if (EditBlockChecking(2) != 1) | FLAG | _isInsert | true | 화면 필드/플래그 변경 |  |  |  |
| AC-768d5f7e | EditButton | SCP0058_Shipment_Plan_FG_JV.cs:1326 | if (fps != null) ▸ if (this.IsEditMode) ▸ else of (EditBlockChecking(2) != 1) | FLAG | _isInsert | false | 화면 필드/플래그 변경 |  |  |  |
| AC-0349fbd5 | EditButton | SCP0058_Shipment_Plan_FG_JV.cs:1327 | if (fps != null) ▸ if (this.IsEditMode) ▸ else of (EditBlockChecking(2) != 1) | GRID_LOCK | siMain.LockRange | (0, siMain.nIdxData, siMain.GetMaxRowIndex(), siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-dcf47b59 | EditButton | SCP0058_Shipment_Plan_FG_JV.cs:1333 | if (fps != null) ▸ else of (this.IsEditMode) | FLAG | _isInsert | false | 화면 필드/플래그 변경 |  |  |  |
| AC-6c79a9bb | EditButton | SCP0058_Shipment_Plan_FG_JV.cs:1334 | if (fps != null) ▸ else of (this.IsEditMode) | GRID_LOCK | siMain.LockRange | (0, siMain.nIdxData, siMain.GetMaxRowIndex(), siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |

## SCP0058_Shipment_Plan_FG_JV.ElectrodeDashReplace

진입점: this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >= 0) ▸ if (siMain.GetValue(e.Row, siMain.GetColumnIndex(DefMain.MEASURE)).ToString().Equals("MKT_FCST"))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dbb2a56e | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0058_Shipment_Plan_FG_JV.cs:3734 |  | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |

## SCP0058_Shipment_Plan_FG_JV.FindButton

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ca0d030f | FindButton | SCP0058_Shipment_Plan_FG_JV.cs:1286 | if (checkPlantSite == 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00352") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e1c64ffc | FindButton | SCP0058_Shipment_Plan_FG_JV.cs:1287 | if (checkPlantSite == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-62eb3705 | FindButton | SCP0058_Shipment_Plan_FG_JV.cs:1299 | if (strValue == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00352") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-70379312 | FindButton | SCP0058_Shipment_Plan_FG_JV.cs:1300 | if (strValue == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0058_Shipment_Plan_FG_JV.FindData_Division

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-adc55e92 | this.Load | SCP0058_Shipment_Plan_FG_JV.cs:4541 |  | STATE | clbFromSite.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-1faca68e | this.Load | SCP0058_Shipment_Plan_FG_JV.cs:4544 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SystemMgmt.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-f913ec13 | this.Load | SCP0058_Shipment_Plan_FG_JV.cs:4548 | lambda | ENDPOINT | new FoxDataRequest | ("SystemManager.UP_FX_GetUserGroupAuthExtentionList") ⇒ SystemManager.UP_FX_GetUserGroupAuthExtentionList | 엔드포인트 요청 생성 |  |  |  |
| AC-c4cdacc9 | this.Load | SCP0058_Shipment_Plan_FG_JV.cs:4550 | lambda | DATA_OP | request.Parameters["GroupID"] | "JV Planner" | 행/컬럼 값 대입 |  |  |  |
| AC-8b07356a | this.Load | SCP0058_Shipment_Plan_FG_JV.cs:4551 | lambda | DATA_OP | request.Parameters["UserID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-68ceeae7 | this.Load | SCP0058_Shipment_Plan_FG_JV.cs:4552 | lambda | DATA_OP | request.Parameters["AuthType"] | "J" | 행/컬럼 값 대입 |  |  |  |
| AC-3438db16 | this.Load | SCP0058_Shipment_Plan_FG_JV.cs:4553 | lambda | DATA_OP | request.Parameters["DivisionID"] | string.Empty | 행/컬럼 값 대입 |  |  |  |
| AC-19d7af08 | this.Load | SCP0058_Shipment_Plan_FG_JV.cs:4554 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-07290dd4 | this.Load | SCP0058_Shipment_Plan_FG_JV.cs:4556 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-215e1306 | this.Load | SCP0058_Shipment_Plan_FG_JV.cs:4565 | for (i < ds.Tables[0].Rows.Count) | DATA_OP | dic_JV_Plant.Add | (Code, JV_PLANT_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-6963203f | this.Load | SCP0058_Shipment_Plan_FG_JV.cs:4567 |  | STATE | clbFromSite.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## SCP0058_Shipment_Plan_FG_JV.FindData_Main

진입점: this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock(siMain.SheetName)) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ if (iCount > 0) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Equals("S"))] / this.btnUnfix.Click [if (fps != null) ▸ else of (siMain.IsLock(siMain.SheetName)) ▸ if (MessageHelper.GMessageBox("MSG00016") == DialogResult.Yes) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ if (iCount > 0) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Equals("S"))] / this.btnNew…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5de1062e | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0058_Shipment_Plan_FG_JV.cs:1358 |  | VALIDATE | DataUtil.checkRequired | (this.usrConditionPanel1) | 프레임워크 검증 |  |  |  |
| AC-b7bc2f3c | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0058_Shipment_Plan_FG_JV.cs:1358 | if (!DataUtil.checkRequired(this.usrConditionPanel1)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-33b49e43 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0058_Shipment_Plan_FG_JV.cs:1360 |  | VALIDATE | DateUtil.Check_PeriodDate_New | (drpPeriod, "1", "7") | 프레임워크 검증 |  |  |  |
| AC-17addc26 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0058_Shipment_Plan_FG_JV.cs:1360 | if (!DateUtil.Check_PeriodDate_New(drpPeriod, "1", "7")) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-817ea066 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0058_Shipment_Plan_FG_JV.cs:1395 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-35e1a4d2 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0058_Shipment_Plan_FG_JV.cs:1398 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-6d016357 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0058_Shipment_Plan_FG_JV.cs:1404 | try ▸ if (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) | CALL_EXT | DateUtil.MonthDiff | (p_to_yyyymmdd.ToString(), p_from_yyyymmdd.ToString()) | ⚠ 의미 확인 필요 |  |  |  |
| AC-39bd0c83 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0058_Shipment_Plan_FG_JV.cs:1417 | try ▸ if (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) | CALL_EXT | Parallel.For | (0, (nCnt), (i) => { if (i != nCnt - 1) { //중장기 개발 ( 4=> 7) string strStartDate = DateUtil… | ⚠ 의미 확인 필요 |  |  |  |
| AC-3fb51a1a | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0058_Shipment_Plan_FG_JV.cs:1435 | try ▸ if (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ if (i != nCnt - 1) | CALL_EXT | FoxUserInfoContext.CreateScope | (new FoxUserInfoContext(p_user_id.ToString())) | ⚠ 의미 확인 필요 |  |  |  |
| AC-80ae2043 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0058_Shipment_Plan_FG_JV.cs:1438 | try ▸ if (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ if (i != nCnt - 1) | ENDPOINT | new FoxDataRequest | ("SCP.SCP0009_GET_SHIPMENT_PLAN_FG") ⇒ SCP.SCP0009_GET_SHIPMENT_PLAN_FG | 엔드포인트 요청 생성 |  |  |  |
| AC-f7b21e41 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0058_Shipment_Plan_FG_JV.cs:1440 | try ▸ if (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ if (i != nCnt - 1) | UI_PROP | req.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-b7830406 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0058_Shipment_Plan_FG_JV.cs:1442 | try ▸ if (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ if (i != nCnt - 1) | DATA_OP | req.Parameters["p_from_yyyymmdd"] | strStartDate | 행/컬럼 값 대입 |  |  |  |
| AC-ad20873d | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0058_Shipment_Plan_FG_JV.cs:1443 | try ▸ if (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ if (i != nCnt - 1) | DATA_OP | req.Parameters["p_to_yyyymmdd"] | strEndDate | 행/컬럼 값 대입 |  |  |  |
| AC-c55a299b | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0058_Shipment_Plan_FG_JV.cs:1444 | try ▸ if (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ if (i != nCnt - 1) | DATA_OP | req.Parameters["p_division_id"] | this._division | 행/컬럼 값 대입 |  |  |  |
| AC-6ea61450 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0058_Shipment_Plan_FG_JV.cs:1445 | try ▸ if (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ if (i != nCnt - 1) | DATA_OP | req.Parameters["p_biz_type"] | p_biz_type | 행/컬럼 값 대입 |  |  |  |
| AC-44563bf3 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0058_Shipment_Plan_FG_JV.cs:1446 | try ▸ if (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ if (i != nCnt - 1) | DATA_OP | req.Parameters["p_project_code"] | p_project_code | 행/컬럼 값 대입 |  |  |  |
| AC-ccfd8955 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0058_Shipment_Plan_FG_JV.cs:1447 | try ▸ if (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ if (i != nCnt - 1) | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-ff9470e1 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0058_Shipment_Plan_FG_JV.cs:1448 | try ▸ if (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ if (i != nCnt - 1) | DATA_OP | req.Parameters["p_electype"] | p_electype | 행/컬럼 값 대입 |  |  |  |
| AC-8cd3dcf9 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0058_Shipment_Plan_FG_JV.cs:1449 | try ▸ if (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ if (i != nCnt - 1) | DATA_OP | req.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-59ea28fe | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0058_Shipment_Plan_FG_JV.cs:1450 | try ▸ if (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ if (i != nCnt - 1) | DATA_OP | req.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-6bd47132 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0058_Shipment_Plan_FG_JV.cs:1451 | try ▸ if (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ if (i != nCnt - 1) | DATA_OP | req.Parameters["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-f43cd185 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0058_Shipment_Plan_FG_JV.cs:1452 | try ▸ if (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ if (i != nCnt - 1) | DATA_OP | req.Parameters["p_fromsite"] | p_fromsite | 행/컬럼 값 대입 |  |  |  |
| AC-53e0e483 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0058_Shipment_Plan_FG_JV.cs:1453 | try ▸ if (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ if (i != nCnt - 1) | DATA_OP | req.Parameters["p_team_id"] | p_team | 행/컬럼 값 대입 |  |  |  |
| AC-06e98f46 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0058_Shipment_Plan_FG_JV.cs:1454 | try ▸ if (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ if (i != nCnt - 1) | DATA_OP | req.Parameters["p_tosite"] | p_tosite | 행/컬럼 값 대입 |  |  |  |
| AC-707ee555 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0058_Shipment_Plan_FG_JV.cs:1455 | try ▸ if (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ if (i != nCnt - 1) | DATA_OP | req.Parameters["p_program_id"] | "SCP0009" | 행/컬럼 값 대입 |  |  |  |
| AC-231cc831 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0058_Shipment_Plan_FG_JV.cs:1456 | try ▸ if (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ if (i != nCnt - 1) | DATA_OP | req.Parameters["p_sheet_name"] | p_sheet_name | 행/컬럼 값 대입 |  |  |  |
| AC-7808649c | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0058_Shipment_Plan_FG_JV.cs:1457 | try ▸ if (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ if (i != nCnt - 1) | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-981c6004 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0058_Shipment_Plan_FG_JV.cs:1458 | try ▸ if (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ if (i != nCnt - 1) | DATA_OP | req.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-dbc755e6 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0058_Shipment_Plan_FG_JV.cs:1459 | try ▸ if (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ if (i != nCnt - 1) | DATA_OP | req.Parameters["p_bucket"] | p_bucket | 행/컬럼 값 대입 |  |  |  |
| AC-65e52a2e | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0058_Shipment_Plan_FG_JV.cs:1460 | try ▸ if (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ if (i != nCnt - 1) | DATA_OP | req.Parameters["p_to_period"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-e3cb0aa5 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0058_Shipment_Plan_FG_JV.cs:1461 | try ▸ if (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ if (i != nCnt - 1) | DATA_OP | req.Parameters["p_chk_all"] | p_chk_all | 행/컬럼 값 대입 |  |  |  |
| AC-20fc19bf | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0058_Shipment_Plan_FG_JV.cs:1469 | try ▸ if (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ if (i != nCnt - 1) ▸ if (i == 0) | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-bc3fc8f6 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0058_Shipment_Plan_FG_JV.cs:1473 | try ▸ if (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ if (i != nCnt - 1) ▸ else of (i == 0) ▸ if (i == 1) | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-4f42604c | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0058_Shipment_Plan_FG_JV.cs:1477 | try ▸ if (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ if (i != nCnt - 1) ▸ else of (i == 0) ▸ else of (i … | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a6abe6a8 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0058_Shipment_Plan_FG_JV.cs:1483 | try ▸ if (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ else of (i != nCnt - 1) | CALL_EXT | FoxUserInfoContext.CreateScope | (new FoxUserInfoContext(p_user_id.ToString())) | ⚠ 의미 확인 필요 |  |  |  |
| AC-2b381ca1 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0058_Shipment_Plan_FG_JV.cs:1486 | try ▸ if (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ else of (i != nCnt - 1) | ENDPOINT | new FoxDataRequest | ("SCP.SCP0009_GET_SHIPMENT_PLAN_FG_TITLE_PARAL") ⇒ SCP.SCP0009_GET_SHIPMENT_PLAN_FG_TITLE_PARAL | 엔드포인트 요청 생성 |  |  |  |
| AC-b0ffe441 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0058_Shipment_Plan_FG_JV.cs:1488 | try ▸ if (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ else of (i != nCnt - 1) | UI_PROP | req.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-b5bdbac5 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0058_Shipment_Plan_FG_JV.cs:1489 | try ▸ if (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ else of (i != nCnt - 1) | DATA_OP | req.Parameters["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-aeb06745 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0058_Shipment_Plan_FG_JV.cs:1490 | try ▸ if (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ else of (i != nCnt - 1) | DATA_OP | req.Parameters["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-94af4d50 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0058_Shipment_Plan_FG_JV.cs:1491 | try ▸ if (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ else of (i != nCnt - 1) | DATA_OP | req.Parameters["p_division_id"] | this._division | 행/컬럼 값 대입 |  |  |  |
| AC-406d3bcb | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0058_Shipment_Plan_FG_JV.cs:1492 | try ▸ if (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ else of (i != nCnt - 1) | DATA_OP | req.Parameters["p_biz_type"] | p_biz_type | 행/컬럼 값 대입 |  |  |  |
| AC-2c5e4bab | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0058_Shipment_Plan_FG_JV.cs:1493 | try ▸ if (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ else of (i != nCnt - 1) | DATA_OP | req.Parameters["p_project_code"] | p_project_code | 행/컬럼 값 대입 |  |  |  |
| AC-760036b2 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0058_Shipment_Plan_FG_JV.cs:1494 | try ▸ if (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ else of (i != nCnt - 1) | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-8c89a157 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0058_Shipment_Plan_FG_JV.cs:1495 | try ▸ if (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ else of (i != nCnt - 1) | DATA_OP | req.Parameters["p_electype"] | p_electype | 행/컬럼 값 대입 |  |  |  |
| AC-019dae06 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0058_Shipment_Plan_FG_JV.cs:1496 | try ▸ if (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ else of (i != nCnt - 1) | DATA_OP | req.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-700413fd | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0058_Shipment_Plan_FG_JV.cs:1497 | try ▸ if (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ else of (i != nCnt - 1) | DATA_OP | req.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-8e683b45 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0058_Shipment_Plan_FG_JV.cs:1498 | try ▸ if (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ else of (i != nCnt - 1) | DATA_OP | req.Parameters["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-36b7ffef | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0058_Shipment_Plan_FG_JV.cs:1499 | try ▸ if (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ else of (i != nCnt - 1) | DATA_OP | req.Parameters["p_fromsite"] | p_fromsite | 행/컬럼 값 대입 |  |  |  |
| AC-fc7f02c8 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0058_Shipment_Plan_FG_JV.cs:1500 | try ▸ if (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ else of (i != nCnt - 1) | DATA_OP | req.Parameters["p_team_id"] | p_team | 행/컬럼 값 대입 |  |  |  |
| AC-e9734c97 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0058_Shipment_Plan_FG_JV.cs:1501 | try ▸ if (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ else of (i != nCnt - 1) | DATA_OP | req.Parameters["p_tosite"] | p_tosite | 행/컬럼 값 대입 |  |  |  |
| AC-6cf5bfb7 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0058_Shipment_Plan_FG_JV.cs:1502 | try ▸ if (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ else of (i != nCnt - 1) | DATA_OP | req.Parameters["p_program_id"] | "SCP0009" | 행/컬럼 값 대입 |  |  |  |
| AC-eb72d888 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0058_Shipment_Plan_FG_JV.cs:1503 | try ▸ if (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ else of (i != nCnt - 1) | DATA_OP | req.Parameters["p_sheet_name"] | p_sheet_name | 행/컬럼 값 대입 |  |  |  |
| AC-964bef62 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0058_Shipment_Plan_FG_JV.cs:1504 | try ▸ if (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ else of (i != nCnt - 1) | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-c5b7d023 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0058_Shipment_Plan_FG_JV.cs:1505 | try ▸ if (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ else of (i != nCnt - 1) | DATA_OP | req.Parameters["p_bucket"] | p_bucket | 행/컬럼 값 대입 |  |  |  |
| AC-e97f44f0 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0058_Shipment_Plan_FG_JV.cs:1506 | try ▸ if (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ else of (i != nCnt - 1) | DATA_OP | req.Parameters["p_chk_all"] | p_chk_all | 행/컬럼 값 대입 |  |  |  |
| AC-1f95dfd3 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0058_Shipment_Plan_FG_JV.cs:1507 | try ▸ if (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ else of (i != nCnt - 1) | DATA_OP | req.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-8d118a88 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0058_Shipment_Plan_FG_JV.cs:1511 | try ▸ if (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ else of (i != nCnt - 1) | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-d08be9a5 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0058_Shipment_Plan_FG_JV.cs:1517 | try ▸ if (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) | FLAG | dsBinding | dsTitle.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-ee5ba503 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0058_Shipment_Plan_FG_JV.cs:1517 | try ▸ if (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) | DATA_OP | dsTitle.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-b494d461 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0058_Shipment_Plan_FG_JV.cs:1518 | try ▸ if (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) | UI_MISC | dsTitle.Dispose | () | 창 닫기/해제 |  |  |  |
| AC-0cac242a | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0058_Shipment_Plan_FG_JV.cs:1520 | try ▸ if (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) ▸ if (dsBinding1 != null) | CALL_EXT | DataUtil.SetDataTableQtyData_New | (dsBinding.Tables[0], dsBinding1.Tables[0]) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f5f5f38a | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0058_Shipment_Plan_FG_JV.cs:1521 | try ▸ if (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) ▸ if (dsBinding2 != null) | CALL_EXT | DataUtil.SetDataTableQtyData_New | (dsBinding.Tables[0], dsBinding2.Tables[0]) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d9d68d61 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0058_Shipment_Plan_FG_JV.cs:1522 | try ▸ if (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) ▸ if (dsBinding3 != null) | CALL_EXT | DataUtil.SetDataTableQtyData_New | (dsBinding.Tables[0], dsBinding3.Tables[0]) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3144a79d | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0058_Shipment_Plan_FG_JV.cs:1526 | try ▸ else of (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) | CALL_EXT | FoxUserInfoContext.CreateScope | (new FoxUserInfoContext(p_user_id.ToString())) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9ccdf5c8 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0058_Shipment_Plan_FG_JV.cs:1529 | try ▸ else of (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) | ENDPOINT | new FoxDataRequest | ("SCP.SCP0009_GET_SHIPMENT_PLAN_FG") ⇒ SCP.SCP0009_GET_SHIPMENT_PLAN_FG | 엔드포인트 요청 생성 |  |  |  |
| AC-92466fc6 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0058_Shipment_Plan_FG_JV.cs:1531 | try ▸ else of (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) | UI_PROP | req.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-ceb3d76f | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0058_Shipment_Plan_FG_JV.cs:1533 | try ▸ else of (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) | DATA_OP | req.Parameters["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-271821a1 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0058_Shipment_Plan_FG_JV.cs:1534 | try ▸ else of (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) | DATA_OP | req.Parameters["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-d4dbad53 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0058_Shipment_Plan_FG_JV.cs:1535 | try ▸ else of (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) | DATA_OP | req.Parameters["p_division_id"] | this._division | 행/컬럼 값 대입 |  |  |  |
| AC-72efd05a | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0058_Shipment_Plan_FG_JV.cs:1536 | try ▸ else of (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) | DATA_OP | req.Parameters["p_biz_type"] | p_biz_type | 행/컬럼 값 대입 |  |  |  |
| AC-ac446d80 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0058_Shipment_Plan_FG_JV.cs:1537 | try ▸ else of (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) | DATA_OP | req.Parameters["p_project_code"] | p_project_code | 행/컬럼 값 대입 |  |  |  |
| AC-3737875a | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0058_Shipment_Plan_FG_JV.cs:1538 | try ▸ else of (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-c8657178 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0058_Shipment_Plan_FG_JV.cs:1539 | try ▸ else of (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) | DATA_OP | req.Parameters["p_electype"] | p_electype | 행/컬럼 값 대입 |  |  |  |
| AC-e72a7599 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0058_Shipment_Plan_FG_JV.cs:1540 | try ▸ else of (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) | DATA_OP | req.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-245d8e71 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0058_Shipment_Plan_FG_JV.cs:1541 | try ▸ else of (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) | DATA_OP | req.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-3a18725b | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0058_Shipment_Plan_FG_JV.cs:1542 | try ▸ else of (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) | DATA_OP | req.Parameters["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-15f2b468 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0058_Shipment_Plan_FG_JV.cs:1543 | try ▸ else of (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) | DATA_OP | req.Parameters["p_fromsite"] | p_fromsite | 행/컬럼 값 대입 |  |  |  |
| AC-2c39965c | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0058_Shipment_Plan_FG_JV.cs:1544 | try ▸ else of (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) | DATA_OP | req.Parameters["p_team_id"] | p_team | 행/컬럼 값 대입 |  |  |  |
| AC-8d06b266 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0058_Shipment_Plan_FG_JV.cs:1545 | try ▸ else of (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) | DATA_OP | req.Parameters["p_tosite"] | p_tosite | 행/컬럼 값 대입 |  |  |  |
| AC-8a0670d9 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0058_Shipment_Plan_FG_JV.cs:1546 | try ▸ else of (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) | DATA_OP | req.Parameters["p_program_id"] | "SCP0009" | 행/컬럼 값 대입 |  |  |  |
| AC-a1bb7310 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0058_Shipment_Plan_FG_JV.cs:1547 | try ▸ else of (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) | DATA_OP | req.Parameters["p_sheet_name"] | p_sheet_name | 행/컬럼 값 대입 |  |  |  |
| AC-aab7e93f | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0058_Shipment_Plan_FG_JV.cs:1548 | try ▸ else of (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-b2efc1ec | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0058_Shipment_Plan_FG_JV.cs:1549 | try ▸ else of (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) | DATA_OP | req.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-884b587f | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0058_Shipment_Plan_FG_JV.cs:1550 | try ▸ else of (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) | DATA_OP | req.Parameters["p_bucket"] | p_bucket | 행/컬럼 값 대입 |  |  |  |
| AC-d6e13f5b | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0058_Shipment_Plan_FG_JV.cs:1551 | try ▸ else of (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) | DATA_OP | req.Parameters["p_to_period"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-c7486e10 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0058_Shipment_Plan_FG_JV.cs:1552 | try ▸ else of (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) | DATA_OP | req.Parameters["p_chk_all"] | p_chk_all | 행/컬럼 값 대입 |  |  |  |
| AC-18dbd437 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0058_Shipment_Plan_FG_JV.cs:1554 | try ▸ else of (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) | FLAG | dsBinding | client.ExecuteDataSet(req).DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-7e7c8e0a | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0058_Shipment_Plan_FG_JV.cs:1554 | try ▸ else of (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-648badcb | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0058_Shipment_Plan_FG_JV.cs:1567 | try ▸ if (dsBinding.Tables[0].Rows.Count > 0) | GRID_BIND | siMain.Query | (dsBinding) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-d473820e | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0058_Shipment_Plan_FG_JV.cs:1569 | try ▸ if (dsBinding.Tables[0].Rows.Count > 0) | FLAG | this._IsEditable | GetIsEditable(dsBinding.Tables[1], p_plan_start_yyyymmdd, p_plan_type, p_seq) | 화면 필드/플래그 변경 |  |  |  |
| AC-63591264 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0058_Shipment_Plan_FG_JV.cs:1574 | try ▸ if (dsBinding.Tables[0].Rows.Count > 0) | FLAG | this._plan_Start_Date | Convert.ToDateTime(dsBinding.Tables[1].Rows[0]["plan_start_date"]) | 화면 필드/플래그 변경 |  |  |  |
| AC-2732d1e8 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0058_Shipment_Plan_FG_JV.cs:1582 | try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ if (p_bucket.ToString() == BucketType.Daily \|\| chkAll.Checked) | FLAG | this._block_idx | EditBlockChecking(1, siMain.nIdxData) | 화면 필드/플래그 변경 |  |  |  |
| AC-da702e41 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0058_Shipment_Plan_FG_JV.cs:1587 | try ▸ if (dsBinding.Tables[0].Rows.Count > 0) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-146dcc9b | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0058_Shipment_Plan_FG_JV.cs:1592 | try ▸ if (dsBinding.Tables[0].Rows.Count > 0) | UI_MISC | SetSearchCount | (dsBinding) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-c0d2e608 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0058_Shipment_Plan_FG_JV.cs:1607 | try ▸ if (dsBinding.Tables[0].Rows.Count > 0) | CALL_EXT | siMain.AddRows | (siMain.GetMaxRowIndex() + 1, 1) | ⚠ 의미 확인 필요 |  |  |  |
| AC-6b93e318 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0058_Shipment_Plan_FG_JV.cs:1608 | try ▸ if (dsBinding.Tables[0].Rows.Count > 0) | CALL_EXT | siMain.VisibleRow | (siMain.GetMaxRowIndex(), false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-7f291510 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0058_Shipment_Plan_FG_JV.cs:1609 | try ▸ if (dsBinding.Tables[0].Rows.Count > 0) | GRID_SET | siMain.ActiveSheet.Rows[siMain.ActiveSheet.Rows.Count - 1].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-90b2976a | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0058_Shipment_Plan_FG_JV.cs:1611 | try ▸ if (dsBinding.Tables[0].Rows.Count > 0) | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7907df43 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0058_Shipment_Plan_FG_JV.cs:1615 | try ▸ else of (dsBinding.Tables[0].Rows.Count > 0) | GRID_BIND | siMain.Query | (dsBinding) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-4cfca3a8 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0058_Shipment_Plan_FG_JV.cs:1618 | try | UI_MISC | SetSearchCount | (dsBinding) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-98736e84 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0058_Shipment_Plan_FG_JV.cs:1622 | catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-a1abeed3 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0058_Shipment_Plan_FG_JV.cs:1625 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-2a3a7bee | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0058_Shipment_Plan_FG_JV.cs:1629 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-d3439905 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0058_Shipment_Plan_FG_JV.cs:1630 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## SCP0058_Shipment_Plan_FG_JV.FindData_PeggingInfo

진입점: this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >= 0) ▸ if (siMain.GetValue(e.Row, siMain.GetColumnIndex(DefMain.MEASURE)).ToString().Equals("MKT_FCST"))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-defcd983 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0058_Shipment_Plan_FG_JV.cs:3600 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-eb0c9f28 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0058_Shipment_Plan_FG_JV.cs:3603 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-fde026de | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0058_Shipment_Plan_FG_JV.cs:3606 | try | UI_PROP | proxyPivot.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-56016293 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0058_Shipment_Plan_FG_JV.cs:3608 | try | ENDPOINT | proxyPivot.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, GSCM_SCP_ANALYS… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-effdd3ad | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0058_Shipment_Plan_FG_JV.cs:3611 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0009_GET_SHIPMENT_PLAN_FG_PEGGING") ⇒ SCP.SCP0009_GET_SHIPMENT_PLAN_FG_PEGGING | 엔드포인트 요청 생성 |  |  |  |
| AC-622c2e27 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0058_Shipment_Plan_FG_JV.cs:3612 | try ▸ lambda | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-da51b956 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0058_Shipment_Plan_FG_JV.cs:3613 | try ▸ lambda | DATA_OP | req.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-5c58b8c2 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0058_Shipment_Plan_FG_JV.cs:3614 | try ▸ lambda | DATA_OP | req.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-bc75b986 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0058_Shipment_Plan_FG_JV.cs:3615 | try ▸ lambda | DATA_OP | req.Parameters["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-2138638f | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0058_Shipment_Plan_FG_JV.cs:3616 | try ▸ lambda | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-e9382f4c | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0058_Shipment_Plan_FG_JV.cs:3617 | try ▸ lambda | DATA_OP | req.Parameters["p_origin_from_division_id"] | p_origin_from_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-a8c30eaf | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0058_Shipment_Plan_FG_JV.cs:3618 | try ▸ lambda | DATA_OP | req.Parameters["p_origin_to_division_id"] | p_origin_to_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-de821a3e | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0058_Shipment_Plan_FG_JV.cs:3619 | try ▸ lambda | DATA_OP | req.Parameters["p_electrode_type"] | p_electrode_type | 행/컬럼 값 대입 |  |  |  |
| AC-e974c3f6 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0058_Shipment_Plan_FG_JV.cs:3620 | try ▸ lambda | DATA_OP | req.Parameters["p_biz_type"] | p_biz_type | 행/컬럼 값 대입 |  |  |  |
| AC-7145fbaf | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0058_Shipment_Plan_FG_JV.cs:3621 | try ▸ lambda | DATA_OP | req.Parameters["p_to_site"] | p_to_site | 행/컬럼 값 대입 |  |  |  |
| AC-67f3172e | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0058_Shipment_Plan_FG_JV.cs:3622 | try ▸ lambda | DATA_OP | req.Parameters["p_duedate"] | p_duedate | 행/컬럼 값 대입 |  |  |  |
| AC-804ee2aa | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0058_Shipment_Plan_FG_JV.cs:3623 | try ▸ lambda | DATA_OP | req.Parameters["p_project_code"] | p_project_code | 행/컬럼 값 대입 |  |  |  |
| AC-b7fff88c | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0058_Shipment_Plan_FG_JV.cs:3625 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-5d475f1c | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0058_Shipment_Plan_FG_JV.cs:3626 | try ▸ lambda | RETURN | return res.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-5a2f346f | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0058_Shipment_Plan_FG_JV.cs:3630 | try | GRID_BIND | siPeggingInfo.Query | (dsBinding) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-5120f224 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0058_Shipment_Plan_FG_JV.cs:3631 | try | GRID_LOCK | siPeggingInfo.LockColumn | (0, siPeggingInfo.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-af4bf1a6 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0058_Shipment_Plan_FG_JV.cs:3632 | try | GRID_INIT | siPeggingInfo.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-970b0248 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0058_Shipment_Plan_FG_JV.cs:3636 | catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-01024d5b | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0058_Shipment_Plan_FG_JV.cs:3639 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c7044498 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0058_Shipment_Plan_FG_JV.cs:3643 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0058_Shipment_Plan_FG_JV.FindData_PlanProblem

진입점: this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >= 0) ▸ if (siMain.GetValue(e.Row, siMain.GetColumnIndex(DefMain.MEASURE)).ToString().Equals("MKT_FCST"))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d4b93d99 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0058_Shipment_Plan_FG_JV.cs:3670 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-227fe9fe | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0058_Shipment_Plan_FG_JV.cs:3673 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-4f7da6ca | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0058_Shipment_Plan_FG_JV.cs:3676 | try | UI_PROP | proxyPivot.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-3739b4c7 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0058_Shipment_Plan_FG_JV.cs:3678 | try | ENDPOINT | proxyPivot.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, GSCM_SCP_ANALYS… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-7c86ad4a | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0058_Shipment_Plan_FG_JV.cs:3682 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0009_GET_SHIPMENT_PLAN_FG_PROBLEM") ⇒ SCP.SCP0009_GET_SHIPMENT_PLAN_FG_PROBLEM | 엔드포인트 요청 생성 |  |  |  |
| AC-77824c2c | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0058_Shipment_Plan_FG_JV.cs:3683 | try ▸ lambda | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-048c4e15 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0058_Shipment_Plan_FG_JV.cs:3684 | try ▸ lambda | DATA_OP | req.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-b1118f68 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0058_Shipment_Plan_FG_JV.cs:3685 | try ▸ lambda | DATA_OP | req.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-79a1a6ca | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0058_Shipment_Plan_FG_JV.cs:3686 | try ▸ lambda | DATA_OP | req.Parameters["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-445ebfc0 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0058_Shipment_Plan_FG_JV.cs:3687 | try ▸ lambda | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-254bcd95 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0058_Shipment_Plan_FG_JV.cs:3688 | try ▸ lambda | DATA_OP | req.Parameters["p_project_code"] | p_project_code | 행/컬럼 값 대입 |  |  |  |
| AC-99177954 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0058_Shipment_Plan_FG_JV.cs:3693 | try ▸ lambda | DATA_OP | req.Parameters["p_to_site"] | p_to_site | 행/컬럼 값 대입 |  |  |  |
| AC-c9d32e0a | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0058_Shipment_Plan_FG_JV.cs:3694 | try ▸ lambda | DATA_OP | req.Parameters["p_duedate"] | p_duedate | 행/컬럼 값 대입 |  |  |  |
| AC-bc78a638 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0058_Shipment_Plan_FG_JV.cs:3696 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-f460dc03 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0058_Shipment_Plan_FG_JV.cs:3697 | try ▸ lambda | RETURN | return res.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-7c99af7d | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0058_Shipment_Plan_FG_JV.cs:3701 | try | GRID_BIND | siPlanProblem.Query | (dsBinding) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-2ae463f5 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0058_Shipment_Plan_FG_JV.cs:3702 | try | GRID_LOCK | siPlanProblem.LockColumn | (0, siPlanProblem.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-c956725d | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0058_Shipment_Plan_FG_JV.cs:3703 | try | GRID_INIT | siPlanProblem.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b396df90 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0058_Shipment_Plan_FG_JV.cs:3707 | catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-ab2a7114 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0058_Shipment_Plan_FG_JV.cs:3710 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0ee5d245 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0058_Shipment_Plan_FG_JV.cs:3714 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0058_Shipment_Plan_FG_JV.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-531726fc | this.Load | SCP0058_Shipment_Plan_FG_JV.cs:266 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCP0058_Shipment_Plan_FG_JV.Get_IsSaveYn

진입점: this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock(siMain.SheetName))] / this.btnUnfix.Click [if (fps != null) ▸ else of (siMain.IsLock(siMain.SheetName))] / this.btnNew.Click / SaveButton [if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-02341d02 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 3 | SCP0058_Shipment_Plan_FG_JV.cs:3441 | if (this._division == null \|\| this._division.ToString() == "") | RETURN | return saveYn; |  | 처리 중단/반환 |  |  |  |
| AC-8b802c8d | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 3 | SCP0058_Shipment_Plan_FG_JV.cs:3452 | try | ENDPOINT | new FoxDataRequest | ("SCP.SCP0013_GET_PLAN_TYPE_SAVE_YN") ⇒ SCP.SCP0013_GET_PLAN_TYPE_SAVE_YN | 엔드포인트 요청 생성 |  |  |  |
| AC-8fc0bfad | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 3 | SCP0058_Shipment_Plan_FG_JV.cs:3453 | try | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-7f574734 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 3 | SCP0058_Shipment_Plan_FG_JV.cs:3454 | try | DATA_OP | request.Parameters["p_start_yyyymmdd"] | p_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-d3c92a88 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 3 | SCP0058_Shipment_Plan_FG_JV.cs:3455 | try | DATA_OP | request.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-a57c238d | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 3 | SCP0058_Shipment_Plan_FG_JV.cs:3457 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-2e444366 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 3 | SCP0058_Shipment_Plan_FG_JV.cs:3467 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-48b687fd | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 3 | SCP0058_Shipment_Plan_FG_JV.cs:3472 | if (!saveYn) | MESSAGE | MessageHelper.GMessageBox | ("MSG00182") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-5b45bec4 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 3 | SCP0058_Shipment_Plan_FG_JV.cs:3474 |  | RETURN | return saveYn; |  | 처리 중단/반환 |  |  |  |

## SCP0058_Shipment_Plan_FG_JV.GetBucketType

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5d1dc5f8 | this.Load | SCP0058_Shipment_Plan_FG_JV.cs:361 |  | ENDPOINT | new FoxDataRequest | ("DM.DM0003_GET_BUCKET_TYPE_CODE") ⇒ DM.DM0003_GET_BUCKET_TYPE_CODE | 엔드포인트 요청 생성 |  |  |  |
| AC-0e617193 | this.Load | SCP0058_Shipment_Plan_FG_JV.cs:362 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-5f51a88a | this.Load | SCP0058_Shipment_Plan_FG_JV.cs:364 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SCP0058_Shipment_Plan_FG_JV.GetDayRange

진입점: this.Load / this.btnW26.Click / this.btnW52.Click / this.btnWLast.Click / cboPlanDate.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-954fb917 | this.Load 외 4 | SCP0058_Shipment_Plan_FG_JV.cs:3850 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCM0001_GET_SCP_DAY_PERIOD") ⇒ SCP.SCM0001_GET_SCP_DAY_PERIOD | 엔드포인트 요청 생성 |  |  |  |
| AC-8fc2f995 | this.Load 외 4 | SCP0058_Shipment_Plan_FG_JV.cs:3851 |  | DATA_OP | request.Parameters["p_from_date"] | p_plan_start_date == null ? "" : p_plan_start_date | 행/컬럼 값 대입 |  |  |  |
| AC-bc32f3cc | this.Load 외 4 | SCP0058_Shipment_Plan_FG_JV.cs:3852 |  | DATA_OP | request.Parameters["p_offset_day"] | Convert.ToInt32(periodType) * 7 - 1 | 행/컬럼 값 대입 |  |  |  |
| AC-5dd1b988 | this.Load 외 4 | SCP0058_Shipment_Plan_FG_JV.cs:3853 |  | DATA_OP | request.Parameters["p_timezone"] | UserInfoContext.Current[UserInfoProperites.TimeZone] | 행/컬럼 값 대입 |  |  |  |
| AC-dc1b5d63 | this.Load 외 4 | SCP0058_Shipment_Plan_FG_JV.cs:3854 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-b07fc1a4 | this.Load 외 4 | SCP0058_Shipment_Plan_FG_JV.cs:3856 |  | RETURN | return sDayRange; |  | 처리 중단/반환 |  |  |  |

## SCP0058_Shipment_Plan_FG_JV.GetIsEditable

진입점: this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock(siMain.SheetName)) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ if (iCount > 0) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Equals("S")) ▸ try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] / this.btnUnfix.Click [if (fps != null) ▸ else of (siMain.IsLock(siMain.SheetName)) ▸ if (MessageHelper.GMessageBox("MSG00016") == DialogResult.Yes) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ if (iCount > 0) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["resu…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-317a3e74 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0058_Shipment_Plan_FG_JV.cs:3305 | if (isEditTable.Equals("N") \|\| curPlanType.Equals("FN") \|\| curPlanType.Equals("TE")) | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |
| AC-665087f0 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0058_Shipment_Plan_FG_JV.cs:3328 | if (curPlanType.Equals("PR")) | DATA_OP | dtEditable.Select | ("plan_type_seq = '1'") | 데이터 객체 조작/조회 |  |  |  |
| AC-d50d1a01 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0058_Shipment_Plan_FG_JV.cs:3362 | if (curPlanType.Equals("PR")) | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |
| AC-191c7dba | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0058_Shipment_Plan_FG_JV.cs:3369 | else of (curPlanType.Equals("PR")) ▸ if (curPlanType.Equals("MA")) | DATA_OP | dtEditable.Select | ("plan_type_seq = '2'") | 데이터 객체 조작/조회 |  |  |  |
| AC-86ad0bf5 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0058_Shipment_Plan_FG_JV.cs:3385 | else of (curPlanType.Equals("PR")) ▸ if (curPlanType.Equals("MA")) ▸ else of (founded.Length > 0) | DATA_OP | dtEditable.Select | ("plan_start_yyyymmdd = '" + curPlanStartYYYYMMDD.ToString() + "' and plan_type= '" + curP… | 데이터 객체 조작/조회 |  |  |  |
| AC-905214cb | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0058_Shipment_Plan_FG_JV.cs:3399 | else of (curPlanType.Equals("PR")) ▸ if (curPlanType.Equals("MA")) | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |
| AC-0bc77f9e | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0058_Shipment_Plan_FG_JV.cs:3406 | else of (curPlanType.Equals("PR")) ▸ else of (curPlanType.Equals("MA")) ▸ if (curPlanType.Equals("SE")) | DATA_OP | dtEditable.Select | ("plan_type_seq = '3'") | 데이터 객체 조작/조회 |  |  |  |
| AC-c127fabf | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0058_Shipment_Plan_FG_JV.cs:3425 | else of (curPlanType.Equals("PR")) ▸ else of (curPlanType.Equals("MA")) ▸ if (curPlanType.Equals("SE")) | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |
| AC-fa10b5a7 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0058_Shipment_Plan_FG_JV.cs:3428 |  | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |

## SCP0058_Shipment_Plan_FG_JV.GetLastRange

진입점: this.Load / cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-07b36f67 | this.Load 외 1 | SCP0058_Shipment_Plan_FG_JV.cs:3836 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCM0001_GET_SCP_DAILY_PLAN_PERIOD") ⇒ SCP.SCM0001_GET_SCP_DAILY_PLAN_PERIOD | 엔드포인트 요청 생성 |  |  |  |
| AC-2c076e05 | this.Load 외 1 | SCP0058_Shipment_Plan_FG_JV.cs:3837 |  | DATA_OP | request.Parameters["p_division_id"] | divisionId | 행/컬럼 값 대입 |  |  |  |
| AC-3b206c61 | this.Load 외 1 | SCP0058_Shipment_Plan_FG_JV.cs:3838 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-4cd8f18c | this.Load 외 1 | SCP0058_Shipment_Plan_FG_JV.cs:3840 |  | RETURN | return dailyPlanPeriod; |  | 처리 중단/반환 |  |  |  |

## SCP0058_Shipment_Plan_FG_JV.GetNewInsertRowIndex

진입점: this.spdMain.CellClick [if ((e.Column == siMain.GetColumnIndex(DefMain.TRANSPORT_MODE) \|\| e.Column == siMain.GetColumnIndex(DefMain.FROM_SITE_NAME))…) ▸ if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (chosedFromSite.ToString() == popupReturnSite)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ff5ea5ad | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0058_Shipment_Plan_FG_JV.cs:2600 |  | RETURN | return retIndex; |  | 처리 중단/반환 |  |  |  |

## SCP0058_Shipment_Plan_FG_JV.GetSpdTitle

진입점: this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] / this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >= 0) ▸ if (siMain.GetValue(e.Row, siMain.GetColumnIndex(DefMain.MEASURE)).ToString().Equals("MKT_FCST")) ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / this.cboBucketType.SelectedIndexChanged [else of (chkAll.Checked) ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock(siMain.SheetName)) ▸ if (fps.Name == "spdMa…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a83b9773 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0058_Shipment_Plan_FG_JV.cs:3804 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN") ⇒ SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | 엔드포인트 요청 생성 |  |  |  |
| AC-02c9244c | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0058_Shipment_Plan_FG_JV.cs:3805 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-1b86ca7b | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0058_Shipment_Plan_FG_JV.cs:3806 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-3faa8f6c | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0058_Shipment_Plan_FG_JV.cs:3808 |  | FLAG | dsSpdTitle | client.ExecuteDataSet(request).DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-4645214d | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0058_Shipment_Plan_FG_JV.cs:3808 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## SCP0058_Shipment_Plan_FG_JV.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6afff6d9 | this.Load | SCP0058_Shipment_Plan_FG_JV.cs:287 | if (dtDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |
| AC-87c68886 | this.Load | SCP0058_Shipment_Plan_FG_JV.cs:289 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-4f8df15f | this.Load | SCP0058_Shipment_Plan_FG_JV.cs:292 |  | DATA_OP | this.ConditionNotUseList.Add | (cboPlanDate) | 데이터 객체 조작/조회 |  |  |  |
| AC-2bd39288 | this.Load | SCP0058_Shipment_Plan_FG_JV.cs:293 |  | DATA_OP | this.ConditionNotUseList.Add | (cboPlanType) | 데이터 객체 조작/조회 |  |  |  |
| AC-4c913a23 | this.Load | SCP0058_Shipment_Plan_FG_JV.cs:294 |  | DATA_OP | this.ConditionNotUseList.Add | (cboPlanSeq) | 데이터 객체 조작/조회 |  |  |  |
| AC-f1e8f2b4 | this.Load | SCP0058_Shipment_Plan_FG_JV.cs:297 |  | DATA_OP | dtDivision.Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-19646e3a | this.Load | SCP0058_Shipment_Plan_FG_JV.cs:298 |  | DATA_OP | tmpDivision.Columns.Add | ("SORT_ORDER") | 데이터 객체 조작/조회 |  |  |  |
| AC-4bcbefa5 | this.Load | SCP0058_Shipment_Plan_FG_JV.cs:299 |  | CALL_EXT | tmpDivision.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-3c860a0e | this.Load | SCP0058_Shipment_Plan_FG_JV.cs:303 | foreach (DataRow dr in dtDivision.Rows) | DATA_OP | tmpDivision.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-098c3b51 | this.Load | SCP0058_Shipment_Plan_FG_JV.cs:304 | foreach (DataRow dr in dtDivision.Rows) | DATA_OP | dataRow["CODE"] | dr["CODE"] | 행/컬럼 값 대입 |  |  |  |
| AC-e1b7609e | this.Load | SCP0058_Shipment_Plan_FG_JV.cs:305 | foreach (DataRow dr in dtDivision.Rows) | DATA_OP | dataRow["NAME"] | dr["NAME"] | 행/컬럼 값 대입 |  |  |  |
| AC-7b90a3c6 | this.Load | SCP0058_Shipment_Plan_FG_JV.cs:306 | foreach (DataRow dr in dtDivision.Rows) | DATA_OP | dataRow["SORT_ORDER"] | dr["CODE"].ToString() == "81" ? 1 : dr["CODE"].ToString() == "40" ? 2 : 3 | 행/컬럼 값 대입 |  |  |  |
| AC-3671411f | this.Load | SCP0058_Shipment_Plan_FG_JV.cs:308 | foreach (DataRow dr in dtDivision.Rows) | CALL_EXT | tmpDivision.Rows.InsertAt | (dataRow, 0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-abc7d5fa | this.Load | SCP0058_Shipment_Plan_FG_JV.cs:311 |  | UI_PROP | tmpDivision.DefaultView.Sort | "SORT_ORDER Asc" | 속성 Sort 설정 |  |  |  |
| AC-14b7f876 | this.Load | SCP0058_Shipment_Plan_FG_JV.cs:312 |  | DATA_OP | tmpDivision.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-d996cf10 | this.Load | SCP0058_Shipment_Plan_FG_JV.cs:314 |  | DATA_OP | tmpDivision.DefaultView.ToTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-2ac6b2fd | this.Load | SCP0058_Shipment_Plan_FG_JV.cs:316 |  | STATE_RESET | dtDivision.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-28842b86 | this.Load | SCP0058_Shipment_Plan_FG_JV.cs:317 |  | FLAG | dtDivision | dtDivisionOrder.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-d2e0c269 | this.Load | SCP0058_Shipment_Plan_FG_JV.cs:317 |  | DATA_OP | dtDivisionOrder.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-c88c8eae | this.Load | SCP0058_Shipment_Plan_FG_JV.cs:320 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, cboDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-ee309349 | this.Load | SCP0058_Shipment_Plan_FG_JV.cs:322 |  | FLAG | dtOperGrp | Data.Common(Data.Type.LookupCommon, false, "OPERATION_GROUP") ⇒ biz:CommonData.CommonDataList [code=LookupCommon] | 화면 필드/플래그 변경 |  |  |  |
| AC-3f39e474 | this.Load | SCP0058_Shipment_Plan_FG_JV.cs:322 |  | COMBO_DATA | Data.Common | (Data.Type.LookupCommon, false, "OPERATION_GROUP") ⇒ biz:CommonData.CommonDataList [code=LookupCommon] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-2ef43f17 | this.Load | SCP0058_Shipment_Plan_FG_JV.cs:323 |  | LIST_REBIND | clsCtrl.setListBox | (dtOperGrp, cboBizType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-35206906 | this.Load | SCP0058_Shipment_Plan_FG_JV.cs:325 |  | FLAG | dtElecType | Data.Common(Data.Type.LookupCommon, false, "ELECTRODE_TYPE") ⇒ biz:CommonData.CommonDataList [code=LookupCommon] | 화면 필드/플래그 변경 |  |  |  |
| AC-a581ac1d | this.Load | SCP0058_Shipment_Plan_FG_JV.cs:325 |  | COMBO_DATA | Data.Common | (Data.Type.LookupCommon, false, "ELECTRODE_TYPE") ⇒ biz:CommonData.CommonDataList [code=LookupCommon] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ea3b3652 | this.Load | SCP0058_Shipment_Plan_FG_JV.cs:326 |  | LIST_REBIND | clsCtrl.setListBox | (dtElecType, clbElecType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-0e4d249a | this.Load | SCP0058_Shipment_Plan_FG_JV.cs:333 |  | VALUE_SET | drpPeriod.InitValue | GetDayRange(PeriodType.W52) | 컨트롤 값 설정 |  |  |  |
| AC-aabc0179 | this.Load | SCP0058_Shipment_Plan_FG_JV.cs:335 |  | FLAG | dtBucketType | GetBucketType() | 화면 필드/플래그 변경 |  |  |  |
| AC-e7bfae57 | this.Load | SCP0058_Shipment_Plan_FG_JV.cs:336 |  | LIST_REBIND | clsCtrl.setListBox | (dtBucketType, cboBucketType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-65d96e19 | this.Load | SCP0058_Shipment_Plan_FG_JV.cs:341 |  | FLAG | dtTeam | Data.UserTeamByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.Use… | 화면 필드/플래그 변경 |  |  |  |
| AC-d1578be2 | this.Load | SCP0058_Shipment_Plan_FG_JV.cs:341 |  | COMBO_DATA | Data.UserTeamByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, this._division) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-2a288ac0 | this.Load | SCP0058_Shipment_Plan_FG_JV.cs:342 |  | LIST_REBIND | clsCtrl.setListBox | (dtTeam, clbTeam, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-1426e16d | this.Load | SCP0058_Shipment_Plan_FG_JV.cs:350 | if (dailyPlanPeriod == PeriodType.W52) | UI_PROP | layoutBtnWLast.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-6fc4ad3a | this.Load | SCP0058_Shipment_Plan_FG_JV.cs:353 |  | VALUE_SET | btnWLast.Text | "W" + dailyPlanPeriod | 컨트롤 값 설정 |  |  |  |

## SCP0058_Shipment_Plan_FG_JV.InitSpread_2

진입점: this.Load / this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >= 0) ▸ if (siMain.GetValue(e.Row, siMain.GetColumnIndex(DefMain.MEASURE)).ToString().Equals("MKT_FCST"))] / this.cboBucketType.SelectedIndexChanged [else of (chkAll.Checked)] / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK)] / this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock(siMain.SheetName)) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ if (iCount > 0) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Equals("S"))] / this.btnUnfix.Click [if…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dc8d601a | this.Load 외 9 | SCP0058_Shipment_Plan_FG_JV.cs:693 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.InitSheet | (SpdSheet.shtMain) | 그리드 재구성/초기화 |  |  |  |
| AC-e91efc80 | this.Load 외 9 | SCP0058_Shipment_Plan_FG_JV.cs:698 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.SetSheetHeaderColumn | (spdInfo, 3) | 그리드 재구성/초기화 |  |  |  |
| AC-3a1c26ff | this.Load 외 9 | SCP0058_Shipment_Plan_FG_JV.cs:702 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Columns[siMain.GetColumnIndex(DefMain.FROM_SITE_NAME)].Fon… | new Font(spdMain.Font.Name, spdMain.Font.Size, FontStyle.Bold) | 그리드 속성/값 설정 |  |  |  |
| AC-d3cd9890 | this.Load 외 9 | SCP0058_Shipment_Plan_FG_JV.cs:703 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Columns[siMain.GetColumnIndex(DefMain.TRANSPORT_MODE)].Fon… | new Font(spdMain.Font.Name, spdMain.Font.Size, FontStyle.Bold) | 그리드 속성/값 설정 |  |  |  |
| AC-67c355e9 | this.Load 외 9 | SCP0058_Shipment_Plan_FG_JV.cs:718 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5d74b6f9 | this.Load 외 9 | SCP0058_Shipment_Plan_FG_JV.cs:722 | if (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (!this._division.Substring(0, 2).Equals("EE")) | GRID_SET | spdInfo.ActiveSheet.Columns[siMain.GetColumnIndex("ORIGIN_TO_DIVISION_ID")].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-1a9adff5 | this.Load 외 9 | SCP0058_Shipment_Plan_FG_JV.cs:723 | if (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (!this._division.Substring(0, 2).Equals("EE")) | GRID_SET | spdInfo.ActiveSheet.Columns[siMain.GetColumnIndex("ELECTRODE_TYPE")].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-06ff8ad7 | this.Load 외 9 | SCP0058_Shipment_Plan_FG_JV.cs:724 | if (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (!this._division.Substring(0, 2).Equals("EE")) | GRID_SET | spdInfo.ActiveSheet.Columns[siMain.GetColumnIndex("ORIGIN_FROM_DIVISION_ID")].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-06af6ec1 | this.Load 외 9 | SCP0058_Shipment_Plan_FG_JV.cs:728 | if (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (!this._division.Substring(0, 2).Equals("EE")) | GRID_SET | spdInfo.ActiveSheet.Columns[siMain.GetColumnIndex("ORIGIN_TO_DIVISION_ID")].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-2f2def2a | this.Load 외 9 | SCP0058_Shipment_Plan_FG_JV.cs:729 | if (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (!this._division.Substring(0, 2).Equals("EE")) | GRID_SET | spdInfo.ActiveSheet.Columns[siMain.GetColumnIndex("ELECTRODE_TYPE")].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-f849b1b1 | this.Load 외 9 | SCP0058_Shipment_Plan_FG_JV.cs:730 | if (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (!this._division.Substring(0, 2).Equals("EE")) | GRID_SET | spdInfo.ActiveSheet.Columns[siMain.GetColumnIndex("ORIGIN_FROM_DIVISION_ID")].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-86251ae2 | this.Load 외 9 | SCP0058_Shipment_Plan_FG_JV.cs:733 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_SET | spdInfo.ActiveSheet.Columns[spdInfo.GetColumnIndex("EXTRA_SPEC")].Visible | (this._division == "40") | 그리드 속성/값 설정 |  |  |  |
| AC-f08a0683 | this.Load 외 9 | SCP0058_Shipment_Plan_FG_JV.cs:737 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (spdInfo.SheetName == SpdSheet.shtPeggingInfo) | GRID_INIT | spdInfo.InitSheet | (SpdSheet.shtPeggingInfo) | 그리드 재구성/초기화 |  |  |  |
| AC-504f5167 | this.Load 외 9 | SCP0058_Shipment_Plan_FG_JV.cs:738 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (spdInfo.SheetName == SpdSheet.shtPeggingInfo) | GRID_INIT | siPeggingInfo.SetSheetHeaderColumn | (spdInfo, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-ecaeba69 | this.Load 외 9 | SCP0058_Shipment_Plan_FG_JV.cs:739 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (spdInfo.SheetName == SpdSheet.shtPeggingInfo) | GRID_INIT | spdInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-71024543 | this.Load 외 9 | SCP0058_Shipment_Plan_FG_JV.cs:743 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (spdInfo.SheetName == SpdSheet.shtPeggingInfo) ▸ if (!this._division.Substring(0, 2).Eq… | GRID_SET | spdInfo.ActiveSheet.Columns[siPeggingInfo.GetColumnIndex("ELECTRODE_TYPE")].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-8b81a414 | this.Load 외 9 | SCP0058_Shipment_Plan_FG_JV.cs:744 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (spdInfo.SheetName == SpdSheet.shtPeggingInfo) ▸ if (!this._division.Substring(0, 2).Eq… | GRID_SET | spdInfo.ActiveSheet.Columns[siPeggingInfo.GetColumnIndex("ORIGIN_FROM_DIVISION_ID")].Visib… | false | 그리드 속성/값 설정 |  |  |  |
| AC-af28dfcd | this.Load 외 9 | SCP0058_Shipment_Plan_FG_JV.cs:745 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (spdInfo.SheetName == SpdSheet.shtPeggingInfo) ▸ if (!this._division.Substring(0, 2).Eq… | GRID_SET | spdInfo.ActiveSheet.Columns[siPeggingInfo.GetColumnIndex("ORIGIN_TO_DIVISION_ID")].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-1697f751 | this.Load 외 9 | SCP0058_Shipment_Plan_FG_JV.cs:749 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (spdInfo.SheetName == SpdSheet.shtPeggingInfo) ▸ else of (!this._division.Substring(0, … | GRID_SET | spdInfo.ActiveSheet.Columns[siPeggingInfo.GetColumnIndex("ELECTRODE_TYPE")].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-7a889d23 | this.Load 외 9 | SCP0058_Shipment_Plan_FG_JV.cs:750 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (spdInfo.SheetName == SpdSheet.shtPeggingInfo) ▸ else of (!this._division.Substring(0, … | GRID_SET | spdInfo.ActiveSheet.Columns[siPeggingInfo.GetColumnIndex("ORIGIN_FROM_DIVISION_ID")].Visib… | true | 그리드 속성/값 설정 |  |  |  |
| AC-f1e57434 | this.Load 외 9 | SCP0058_Shipment_Plan_FG_JV.cs:751 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (spdInfo.SheetName == SpdSheet.shtPeggingInfo) ▸ else of (!this._division.Substring(0, … | GRID_SET | spdInfo.ActiveSheet.Columns[siPeggingInfo.GetColumnIndex("ORIGIN_TO_DIVISION_ID")].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-ea68001b | this.Load 외 9 | SCP0058_Shipment_Plan_FG_JV.cs:757 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPeggingInfo) ▸ if (spdInfo.SheetName == SpdSheet… | GRID_INIT | spdInfo.InitSheet | (SpdSheet.shtPlanProblem) | 그리드 재구성/초기화 |  |  |  |
| AC-14fee0e7 | this.Load 외 9 | SCP0058_Shipment_Plan_FG_JV.cs:758 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPeggingInfo) ▸ if (spdInfo.SheetName == SpdSheet… | GRID_INIT | siPlanProblem.SetSheetHeaderColumn | (spdInfo, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-aad675b8 | this.Load 외 9 | SCP0058_Shipment_Plan_FG_JV.cs:759 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPeggingInfo) ▸ if (spdInfo.SheetName == SpdSheet… | GRID_INIT | spdInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCP0058_Shipment_Plan_FG_JV.InitSpreadDateColumn

진입점: this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] / this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >= 0) ▸ if (siMain.GetValue(e.Row, siMain.GetColumnIndex(DefMain.MEASURE)).ToString().Equals("MKT_FCST")) ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / this.cboBucketType.SelectedIndexChanged [else of (chkAll.Checked) ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock(siMain.SheetName)) ▸ if (fps.Name == "spdMa…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-df9f7e2b | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0058_Shipment_Plan_FG_JV.cs:917 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sColumnName.IndexOf("B_") > 0) | GRID_INIT | spdInfo.AddTextColumn | (sColumnLabelname, sColumnName, FPMerge.None, 0, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7ad4c8e1 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0058_Shipment_Plan_FG_JV.cs:921 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sColumnName.IndexOf("B_") > 0) | GRID_INIT | spdInfo.AddNumColumn | (sColumnLabelname, sColumnName, FPMerge.None, 70, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-17a7a638 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0058_Shipment_Plan_FG_JV.cs:922 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sColumnName.IndexOf("B_") > 0) | GRID_INIT | spdInfo.SetReNumerCellType | (spdInfo, spdInfo.GetColumnIndex(sColumnName)) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-e0c66f6f | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0058_Shipment_Plan_FG_JV.cs:926 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sColumnName.IndexOf("B_") > 0) ▸ if (sDayCode == DefMainLabel.Saturday \|\| sDa… | GRID_SET | spdInfo.Sheet().ColumnHeader.Cells[2, spdInfo.GetMaxColumnIndex()].ForeColor | sDayCode == DefMainLabel.Saturday ? Color.Blue : Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-7c298f3b | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0058_Shipment_Plan_FG_JV.cs:933 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1cf5a613 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0058_Shipment_Plan_FG_JV.cs:934 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8822bd58 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0058_Shipment_Plan_FG_JV.cs:939 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-27e72fa2 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0058_Shipment_Plan_FG_JV.cs:940 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 30, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2a91db19 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0058_Shipment_Plan_FG_JV.cs:948 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName != sSmallLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0c15ac99 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0058_Shipment_Plan_FG_JV.cs:949 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName != sSmallLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f997b5f6 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0058_Shipment_Plan_FG_JV.cs:959 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-def9ff42 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0058_Shipment_Plan_FG_JV.cs:960 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-14ec00c7 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0058_Shipment_Plan_FG_JV.cs:961 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a6522992 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0058_Shipment_Plan_FG_JV.cs:962 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0058_Shipment_Plan_FG_JV.InsertRow

진입점: this.spdMain.CellClick [if ((e.Column == siMain.GetColumnIndex(DefMain.TRANSPORT_MODE) \|\| e.Column == siMain.GetColumnIndex(DefMain.FROM_SITE_NAME))…)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7f0adc01 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0058_Shipment_Plan_FG_JV.cs:2088 |  | DATA_OP | dsBinding.Tables[0].Select() .Where(c => c[DefMain.KEY_IDX].ToString() == key_idx.ToString… | () | 데이터 객체 조작/조회 |  |  |  |
| AC-4c919344 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0058_Shipment_Plan_FG_JV.cs:2088 |  | DATA_OP | dsBinding.Tables[0].Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-2a09e6d7 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0058_Shipment_Plan_FG_JV.cs:2096 |  | POPUP | new SCM0002_GetBODPopup | (dtCaller, 0, this._plan_Start_Date) | 팝업/폼 생성 |  |  |  |
| AC-a4bfef4c | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0058_Shipment_Plan_FG_JV.cs:2097 |  | UI_PROP | popup.Width | 1050 | 속성 Width 설정 |  |  |  |
| AC-eab6f456 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0058_Shipment_Plan_FG_JV.cs:2098 |  | UI_PROP | popup.Height | 350 | 속성 Height 설정 |  |  |  |
| AC-b3987bc8 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0058_Shipment_Plan_FG_JV.cs:2099 |  | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-c946f754 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0058_Shipment_Plan_FG_JV.cs:2107 |  | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-689ae3d6 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0058_Shipment_Plan_FG_JV.cs:2110 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (popup.retList.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-caa0b8a8 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0058_Shipment_Plan_FG_JV.cs:2137 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (chosedFromSite.ToString() == popupReturnSite) | DATA_OP | dtCaller.Select().Where(c => c[DefMain.MEASURE].ToString().Contains("SHIP_") && c[DefMain.… | () | 데이터 객체 조작/조회 |  |  |  |
| AC-81895d41 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0058_Shipment_Plan_FG_JV.cs:2137 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (chosedFromSite.ToString() == popupReturnSite) | DATA_OP | dtCaller.Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-ef81e6bf | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0058_Shipment_Plan_FG_JV.cs:2137 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (chosedFromSite.ToString() == popupReturnSite) ▸ lambda | DATA_OP | c[DefMain.MEASURE].ToString().Contains | ("SHIP_") | 데이터 객체 조작/조회 |  |  |  |
| AC-d613f7a3 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0058_Shipment_Plan_FG_JV.cs:2147 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (chosedFromSite.ToString() == popupReturnSite) ▸ foreac… | CALL_EXT | siMain.InsertNewRow | (insertStartIdx) | ⚠ 의미 확인 필요 |  |  |  |
| AC-7ee51177 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0058_Shipment_Plan_FG_JV.cs:2149 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (chosedFromSite.ToString() == popupReturnSite) ▸ foreac… | DATA_OP | defaultData.Add | (DefMain.DIVISION_ID, dr["division_id"]) | 데이터 객체 조작/조회 |  |  |  |
| AC-20ca5ec6 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0058_Shipment_Plan_FG_JV.cs:2150 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (chosedFromSite.ToString() == popupReturnSite) ▸ foreac… | DATA_OP | defaultData.Add | (DefMain.BIZ_TYPE_NAME, dr["BIZ_TYPE_NAME"]) | 데이터 객체 조작/조회 |  |  |  |
| AC-af5aaec9 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0058_Shipment_Plan_FG_JV.cs:2151 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (chosedFromSite.ToString() == popupReturnSite) ▸ foreac… | DATA_OP | defaultData.Add | (DefMain.ITEM_ID, dr["ITEM_ID"]) | 데이터 객체 조작/조회 |  |  |  |
| AC-5f865502 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0058_Shipment_Plan_FG_JV.cs:2152 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (chosedFromSite.ToString() == popupReturnSite) ▸ foreac… | DATA_OP | defaultData.Add | (DefMain.NICK_NAME, dr["NICK_NAME"]) | 데이터 객체 조작/조회 |  |  |  |
| AC-637f472b | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0058_Shipment_Plan_FG_JV.cs:2155 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (chosedFromSite.ToString() == popupReturnSite) ▸ foreac… | DATA_OP | defaultData.Add | (DefMain.ELECTRODE_TYPE, dr["ELECTRODE_TYPE"]) | 데이터 객체 조작/조회 |  |  |  |
| AC-0f199acc | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0058_Shipment_Plan_FG_JV.cs:2158 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (chosedFromSite.ToString() == popupReturnSite) ▸ foreac… | DATA_OP | defaultData.Add | (DefMain.ORIGIN_TO_DIVISION_ID, dr["ORIGIN_TO_DIVISION_ID"]) | 데이터 객체 조작/조회 |  |  |  |
| AC-7bf7b185 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0058_Shipment_Plan_FG_JV.cs:2160 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (chosedFromSite.ToString() == popupReturnSite) ▸ foreac… | DATA_OP | defaultData.Add | (DefMain.TO_SITE_NAME, bod.first_site_name) | 데이터 객체 조작/조회 |  |  |  |
| AC-b14c192a | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0058_Shipment_Plan_FG_JV.cs:2162 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (chosedFromSite.ToString() == popupReturnSite) ▸ foreac… | DATA_OP | defaultData.Add | (DefMain.BOH, dr["BOH"]) | 데이터 객체 조작/조회 |  |  |  |
| AC-e6f9e88e | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0058_Shipment_Plan_FG_JV.cs:2163 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (chosedFromSite.ToString() == popupReturnSite) ▸ foreac… | DATA_OP | defaultData.Add | (DefMain.INCOTERMS, bod.incoterms) | 데이터 객체 조작/조회 |  |  |  |
| AC-ebbab39f | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0058_Shipment_Plan_FG_JV.cs:2164 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (chosedFromSite.ToString() == popupReturnSite) ▸ foreac… | DATA_OP | defaultData.Add | (DefMain.PROJECT_CODE, dr["PROJECT_CODE"]) | 데이터 객체 조작/조회 |  |  |  |
| AC-71206f00 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0058_Shipment_Plan_FG_JV.cs:2167 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (chosedFromSite.ToString() == popupReturnSite) ▸ foreac… | DATA_OP | defaultData.Add | (DefMain.ORIGIN_FROM_DIVISION_ID, dr["ORIGIN_FROM_DIVISION_ID"]) | 데이터 객체 조작/조회 |  |  |  |
| AC-305e8059 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0058_Shipment_Plan_FG_JV.cs:2169 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (chosedFromSite.ToString() == popupReturnSite) ▸ foreac… | DATA_OP | defaultData.Add | (DefMain.FROM_SITE_NAME, bod.second_site_name) | 데이터 객체 조작/조회 |  |  |  |
| AC-9db3f37c | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0058_Shipment_Plan_FG_JV.cs:2170 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (chosedFromSite.ToString() == popupReturnSite) ▸ foreac… | DATA_OP | defaultData.Add | (DefMain.TRANSPORT_MODE, bod.transport_mode) | 데이터 객체 조작/조회 |  |  |  |
| AC-222c3184 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0058_Shipment_Plan_FG_JV.cs:2172 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (chosedFromSite.ToString() == popupReturnSite) ▸ foreac… | DATA_OP | defaultData.Add | (DefMain.LT_DAY, bod.lt_total) | 데이터 객체 조작/조회 |  |  |  |
| AC-52114105 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0058_Shipment_Plan_FG_JV.cs:2173 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (chosedFromSite.ToString() == popupReturnSite) ▸ foreac… | DATA_OP | defaultData.Add | (DefMain.MEASURE_LABEL, dr["MEASURE_LABEL"]) | 데이터 객체 조작/조회 |  |  |  |
| AC-b363e81c | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0058_Shipment_Plan_FG_JV.cs:2174 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (chosedFromSite.ToString() == popupReturnSite) ▸ foreac… | DATA_OP | defaultData.Add | (DefMain.MEASURE, dr["measure"]) | 데이터 객체 조작/조회 |  |  |  |
| AC-98aabbeb | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0058_Shipment_Plan_FG_JV.cs:2175 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (chosedFromSite.ToString() == popupReturnSite) ▸ foreac… | DATA_OP | defaultData.Add | (DefMain.BOD_ID, bod.bod_id) | 데이터 객체 조작/조회 |  |  |  |
| AC-d4a9e9b3 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0058_Shipment_Plan_FG_JV.cs:2176 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (chosedFromSite.ToString() == popupReturnSite) ▸ foreac… | DATA_OP | defaultData.Add | (DefMain.KEY_IDX, dr["key_idx"]) | 데이터 객체 조작/조회 |  |  |  |
| AC-f43faf22 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0058_Shipment_Plan_FG_JV.cs:2178 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (chosedFromSite.ToString() == popupReturnSite) ▸ foreac… | DATA_OP | defaultData.Add | (DefMain.BIZ_TYPE, dr["biz_type"]) | 데이터 객체 조작/조회 |  |  |  |
| AC-fcaa3e4b | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0058_Shipment_Plan_FG_JV.cs:2179 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (chosedFromSite.ToString() == popupReturnSite) ▸ foreac… | DATA_OP | defaultData.Add | (DefMain.TO_SITE, bod.first_site) | 데이터 객체 조작/조회 |  |  |  |
| AC-7ae735af | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0058_Shipment_Plan_FG_JV.cs:2180 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (chosedFromSite.ToString() == popupReturnSite) ▸ foreac… | DATA_OP | defaultData.Add | (DefMain.FROM_SITE, bod.second_site) | 데이터 객체 조작/조회 |  |  |  |
| AC-18496474 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0058_Shipment_Plan_FG_JV.cs:2181 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (chosedFromSite.ToString() == popupReturnSite) ▸ foreac… | DATA_OP | defaultData.Add | (DefMain.SHIP_FROZEN, bod.ship_frozen) | 데이터 객체 조작/조회 |  |  |  |
| AC-a0a62988 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0058_Shipment_Plan_FG_JV.cs:2182 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (chosedFromSite.ToString() == popupReturnSite) ▸ foreac… | DATA_OP | defaultData.Add | (DefMain.MEASURE_ORDER_NO, dr["MEASURE_ORDER_NO"]) | 데이터 객체 조작/조회 |  |  |  |
| AC-efb8c782 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0058_Shipment_Plan_FG_JV.cs:2184 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (chosedFromSite.ToString() == popupReturnSite) ▸ foreac… | DATA_OP | defaultData.Add | (DefMain.PLAN_START_YYYYMMDD, dr["plan_start_yyyymmdd"]) | 데이터 객체 조작/조회 |  |  |  |
| AC-4b45b41b | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0058_Shipment_Plan_FG_JV.cs:2185 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (chosedFromSite.ToString() == popupReturnSite) ▸ foreac… | DATA_OP | defaultData.Add | (DefMain.PLAN_TYPE, dr["plan_type"]) | 데이터 객체 조작/조회 |  |  |  |
| AC-20668a1f | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0058_Shipment_Plan_FG_JV.cs:2186 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (chosedFromSite.ToString() == popupReturnSite) ▸ foreac… | DATA_OP | defaultData.Add | (DefMain.SEQ, dr["seq"]) | 데이터 객체 조작/조회 |  |  |  |
| AC-817c8fdf | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0058_Shipment_Plan_FG_JV.cs:2187 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (chosedFromSite.ToString() == popupReturnSite) ▸ foreac… | DATA_OP | defaultData.Add | (DefMain.TO_YYYYMMDD, dr["to_yyyymmdd"]) | 데이터 객체 조작/조회 |  |  |  |
| AC-d5dc095e | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0058_Shipment_Plan_FG_JV.cs:2188 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (chosedFromSite.ToString() == popupReturnSite) ▸ foreac… | DATA_OP | defaultData.Add | (DefMain.BOD_FROM_YYYYMMDD, bod.bod_from_yyyymmdd) | 데이터 객체 조작/조회 |  |  |  |
| AC-2ba166c8 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0058_Shipment_Plan_FG_JV.cs:2189 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (chosedFromSite.ToString() == popupReturnSite) ▸ foreac… | DATA_OP | defaultData.Add | (DefMain.BOD_TO_YYYYMMDD, bod.bod_to_yyyymmdd) | 데이터 객체 조작/조회 |  |  |  |
| AC-4664cf9a | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0058_Shipment_Plan_FG_JV.cs:2191 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (chosedFromSite.ToString() == popupReturnSite) ▸ foreac… | GRID_SET | siMain.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |
| AC-7cfc8ede | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0058_Shipment_Plan_FG_JV.cs:2211 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (chosedFromSite.ToString() == popupReturnSite) | DATA_OP | dtCaller.Select().Where(c => (c[DefMain.MEASURE].ToString().Contains("SHIP_") \|\| c[DefMa… | () | 데이터 객체 조작/조회 |  |  |  |
| AC-fcaffbc2 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0058_Shipment_Plan_FG_JV.cs:2211 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (chosedFromSite.ToString() == popupReturnSite) | DATA_OP | dtCaller.Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-3fe8be27 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0058_Shipment_Plan_FG_JV.cs:2211 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (chosedFromSite.ToString() == popupReturnSite) ▸ l… | DATA_OP | c[DefMain.MEASURE].ToString().Contains | ("SHIP_") | 데이터 객체 조작/조회 |  |  |  |
| AC-d504d4da | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0058_Shipment_Plan_FG_JV.cs:2234 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (chosedFromSite.ToString() == popupReturnSite) ▸ f… | CALL_EXT | siMain.InsertNewRow | (insertStartIdx) | ⚠ 의미 확인 필요 |  |  |  |
| AC-36d7ce54 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0058_Shipment_Plan_FG_JV.cs:2236 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (chosedFromSite.ToString() == popupReturnSite) ▸ f… | DATA_OP | defaultData.Add | (DefMain.DIVISION_ID, row["division_id"]) | 데이터 객체 조작/조회 |  |  |  |
| AC-2cf6e4a6 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0058_Shipment_Plan_FG_JV.cs:2237 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (chosedFromSite.ToString() == popupReturnSite) ▸ f… | DATA_OP | defaultData.Add | (DefMain.BIZ_TYPE_NAME, row["BIZ_TYPE_NAME"]) | 데이터 객체 조작/조회 |  |  |  |
| AC-f826e09c | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0058_Shipment_Plan_FG_JV.cs:2238 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (chosedFromSite.ToString() == popupReturnSite) ▸ f… | DATA_OP | defaultData.Add | (DefMain.ITEM_ID, row["ITEM_ID"]) | 데이터 객체 조작/조회 |  |  |  |
| AC-277a8a16 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0058_Shipment_Plan_FG_JV.cs:2239 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (chosedFromSite.ToString() == popupReturnSite) ▸ f… | DATA_OP | defaultData.Add | (DefMain.NICK_NAME, row["NICK_NAME"]) | 데이터 객체 조작/조회 |  |  |  |
| AC-be16d7d0 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0058_Shipment_Plan_FG_JV.cs:2242 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (chosedFromSite.ToString() == popupReturnSite) ▸ f… | DATA_OP | defaultData.Add | (DefMain.ELECTRODE_TYPE, row["ELECTRODE_TYPE"]) | 데이터 객체 조작/조회 |  |  |  |
| AC-f17c9154 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0058_Shipment_Plan_FG_JV.cs:2245 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (chosedFromSite.ToString() == popupReturnSite) ▸ f… | DATA_OP | defaultData.Add | (DefMain.ORIGIN_TO_DIVISION_ID, row["ORIGIN_TO_DIVISION_ID"]) | 데이터 객체 조작/조회 |  |  |  |
| AC-553915c4 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0058_Shipment_Plan_FG_JV.cs:2247 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (chosedFromSite.ToString() == popupReturnSite) ▸ f… | DATA_OP | defaultData.Add | (DefMain.TO_SITE_NAME, bod.first_site_name) | 데이터 객체 조작/조회 |  |  |  |
| AC-eccaef68 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0058_Shipment_Plan_FG_JV.cs:2249 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (chosedFromSite.ToString() == popupReturnSite) ▸ f… | DATA_OP | defaultData.Add | (DefMain.BOH, row["BOH"]) | 데이터 객체 조작/조회 |  |  |  |
| AC-bc725389 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0058_Shipment_Plan_FG_JV.cs:2250 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (chosedFromSite.ToString() == popupReturnSite) ▸ f… | DATA_OP | defaultData.Add | (DefMain.INCOTERMS, bod.incoterms) | 데이터 객체 조작/조회 |  |  |  |
| AC-cb53c5fe | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0058_Shipment_Plan_FG_JV.cs:2258 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (chosedFromSite.ToString() == popupReturnSite) ▸ f… | DATA_OP | defaultData.Add | (DefMain.PROJECT_CODE, row["PROJECT_CODE"]) | 데이터 객체 조작/조회 |  |  |  |
| AC-7f7defef | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0058_Shipment_Plan_FG_JV.cs:2275 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (chosedFromSite.ToString() == popupReturnSite) ▸ f… | DATA_OP | defaultData.Add | (DefMain.ORIGIN_FROM_DIVISION_ID, row["ORIGIN_FROM_DIVISION_ID"]) | 데이터 객체 조작/조회 |  |  |  |
| AC-e7062237 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0058_Shipment_Plan_FG_JV.cs:2277 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (chosedFromSite.ToString() == popupReturnSite) ▸ f… | DATA_OP | cur_Measure.Contains | ("SHIP") | 데이터 객체 조작/조회 |  |  |  |
| AC-86e2bcbd | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0058_Shipment_Plan_FG_JV.cs:2279 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (chosedFromSite.ToString() == popupReturnSite) ▸ f… | DATA_OP | defaultData.Add | (DefMain.FROM_SITE_NAME, "-") | 데이터 객체 조작/조회 |  |  |  |
| AC-0dccb703 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0058_Shipment_Plan_FG_JV.cs:2283 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (chosedFromSite.ToString() == popupReturnSite) ▸ f… | DATA_OP | defaultData.Add | (DefMain.FROM_SITE_NAME, bod.second_site_name) | 데이터 객체 조작/조회 |  |  |  |
| AC-eb65df1f | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0058_Shipment_Plan_FG_JV.cs:2286 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (chosedFromSite.ToString() == popupReturnSite) ▸ f… | DATA_OP | cur_Measure.Contains | ("SHIP") | 데이터 객체 조작/조회 |  |  |  |
| AC-dad43b4e | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0058_Shipment_Plan_FG_JV.cs:2288 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (chosedFromSite.ToString() == popupReturnSite) ▸ f… | DATA_OP | defaultData.Add | (DefMain.TRANSPORT_MODE, bod.transport_mode) | 데이터 객체 조작/조회 |  |  |  |
| AC-6e6aca57 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0058_Shipment_Plan_FG_JV.cs:2292 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (chosedFromSite.ToString() == popupReturnSite) ▸ f… | DATA_OP | defaultData.Add | (DefMain.TRANSPORT_MODE, "-") | 데이터 객체 조작/조회 |  |  |  |
| AC-ef9b1783 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0058_Shipment_Plan_FG_JV.cs:2295 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (chosedFromSite.ToString() == popupReturnSite) ▸ f… | DATA_OP | cur_Measure.Contains | ("SHIP") | 데이터 객체 조작/조회 |  |  |  |
| AC-24e24f5d | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0058_Shipment_Plan_FG_JV.cs:2297 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (chosedFromSite.ToString() == popupReturnSite) ▸ f… | DATA_OP | defaultData.Add | (DefMain.LT_DAY, bod.lt_total) | 데이터 객체 조작/조회 |  |  |  |
| AC-04e87f3f | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0058_Shipment_Plan_FG_JV.cs:2301 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (chosedFromSite.ToString() == popupReturnSite) ▸ f… | DATA_OP | defaultData.Add | (DefMain.LT_DAY, 0) | 데이터 객체 조작/조회 |  |  |  |
| AC-6ff080fe | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0058_Shipment_Plan_FG_JV.cs:2304 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (chosedFromSite.ToString() == popupReturnSite) ▸ f… | DATA_OP | defaultData.Add | (DefMain.MEASURE_LABEL, row["MEASURE_LABEL"]) | 데이터 객체 조작/조회 |  |  |  |
| AC-faaa9930 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0058_Shipment_Plan_FG_JV.cs:2305 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (chosedFromSite.ToString() == popupReturnSite) ▸ f… | DATA_OP | defaultData.Add | (DefMain.MEASURE, cur_Measure) | 데이터 객체 조작/조회 |  |  |  |
| AC-5f0937fc | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0058_Shipment_Plan_FG_JV.cs:2308 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (chosedFromSite.ToString() == popupReturnSite) ▸ f… | DATA_OP | cur_Measure.Contains | ("SHIP") | 데이터 객체 조작/조회 |  |  |  |
| AC-7784e265 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0058_Shipment_Plan_FG_JV.cs:2310 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (chosedFromSite.ToString() == popupReturnSite) ▸ f… | DATA_OP | defaultData.Add | (DefMain.BOD_ID, bod.bod_id) | 데이터 객체 조작/조회 |  |  |  |
| AC-aa0815c9 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0058_Shipment_Plan_FG_JV.cs:2314 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (chosedFromSite.ToString() == popupReturnSite) ▸ f… | DATA_OP | defaultData.Add | (DefMain.BOD_ID, "-") | 데이터 객체 조작/조회 |  |  |  |
| AC-6004ceec | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0058_Shipment_Plan_FG_JV.cs:2317 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (chosedFromSite.ToString() == popupReturnSite) ▸ f… | DATA_OP | defaultData.Add | (DefMain.KEY_IDX, row["key_idx"]) | 데이터 객체 조작/조회 |  |  |  |
| AC-af0b564c | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0058_Shipment_Plan_FG_JV.cs:2318 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (chosedFromSite.ToString() == popupReturnSite) ▸ f… | DATA_OP | defaultData.Add | (DefMain.BIZ_TYPE, row["biz_type"]) | 데이터 객체 조작/조회 |  |  |  |
| AC-ce258ff2 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0058_Shipment_Plan_FG_JV.cs:2319 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (chosedFromSite.ToString() == popupReturnSite) ▸ f… | DATA_OP | defaultData.Add | (DefMain.TO_SITE, bod.first_site) | 데이터 객체 조작/조회 |  |  |  |
| AC-df421930 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0058_Shipment_Plan_FG_JV.cs:2321 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (chosedFromSite.ToString() == popupReturnSite) ▸ f… | DATA_OP | cur_Measure.Contains | ("SHIP") | 데이터 객체 조작/조회 |  |  |  |
| AC-d683cabc | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0058_Shipment_Plan_FG_JV.cs:2323 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (chosedFromSite.ToString() == popupReturnSite) ▸ f… | DATA_OP | defaultData.Add | (DefMain.FROM_SITE, "-") | 데이터 객체 조작/조회 |  |  |  |
| AC-a96c90fb | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0058_Shipment_Plan_FG_JV.cs:2327 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (chosedFromSite.ToString() == popupReturnSite) ▸ f… | DATA_OP | defaultData.Add | (DefMain.FROM_SITE, bod.second_site) | 데이터 객체 조작/조회 |  |  |  |
| AC-1fbacd95 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0058_Shipment_Plan_FG_JV.cs:2330 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (chosedFromSite.ToString() == popupReturnSite) ▸ f… | DATA_OP | defaultData.Add | (DefMain.SHIP_FROZEN, bod.ship_frozen) | 데이터 객체 조작/조회 |  |  |  |
| AC-3c5863b9 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0058_Shipment_Plan_FG_JV.cs:2331 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (chosedFromSite.ToString() == popupReturnSite) ▸ f… | DATA_OP | defaultData.Add | (DefMain.MEASURE_ORDER_NO, row["MEASURE_ORDER_NO"]) | 데이터 객체 조작/조회 |  |  |  |
| AC-3f8d7386 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0058_Shipment_Plan_FG_JV.cs:2333 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (chosedFromSite.ToString() == popupReturnSite) ▸ f… | DATA_OP | defaultData.Add | (DefMain.PLAN_START_YYYYMMDD, row["plan_start_yyyymmdd"]) | 데이터 객체 조작/조회 |  |  |  |
| AC-40caec83 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0058_Shipment_Plan_FG_JV.cs:2334 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (chosedFromSite.ToString() == popupReturnSite) ▸ f… | DATA_OP | defaultData.Add | (DefMain.PLAN_TYPE, row["plan_type"]) | 데이터 객체 조작/조회 |  |  |  |
| AC-4b3643b1 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0058_Shipment_Plan_FG_JV.cs:2335 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (chosedFromSite.ToString() == popupReturnSite) ▸ f… | DATA_OP | defaultData.Add | (DefMain.SEQ, row["seq"]) | 데이터 객체 조작/조회 |  |  |  |
| AC-82de896c | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0058_Shipment_Plan_FG_JV.cs:2336 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (chosedFromSite.ToString() == popupReturnSite) ▸ f… | DATA_OP | defaultData.Add | (DefMain.TO_YYYYMMDD, row["to_yyyymmdd"]) | 데이터 객체 조작/조회 |  |  |  |
| AC-f67fdcb7 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0058_Shipment_Plan_FG_JV.cs:2337 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (chosedFromSite.ToString() == popupReturnSite) ▸ f… | DATA_OP | defaultData.Add | (DefMain.BOD_FROM_YYYYMMDD, bod.bod_from_yyyymmdd) | 데이터 객체 조작/조회 |  |  |  |
| AC-e87457d8 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0058_Shipment_Plan_FG_JV.cs:2338 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (chosedFromSite.ToString() == popupReturnSite) ▸ f… | DATA_OP | defaultData.Add | (DefMain.BOD_TO_YYYYMMDD, bod.bod_to_yyyymmdd) | 데이터 객체 조작/조회 |  |  |  |
| AC-7e0a6acb | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0058_Shipment_Plan_FG_JV.cs:2339 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (chosedFromSite.ToString() == popupReturnSite) ▸ f… | GRID_SET | siMain.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |
| AC-115b394d | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0058_Shipment_Plan_FG_JV.cs:2351 | if (popup.ShowDialog() == DialogResult.OK) | UI_MISC | spdMain.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## SCP0058_Shipment_Plan_FG_JV.RefreshFromSite

진입점: this.Load [if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))] / cboDivision.SelectedIndexChanged [if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))] / cboBizType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1d49192f | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 2 | SCP0058_Shipment_Plan_FG_JV.cs:435 |  | FLAG | dtFromSite | Data_SCP.Common(Data_SCP.Type.AllPlantSiteDescription, false, "", "") | 화면 필드/플래그 변경 |  |  |  |
| AC-f3533ec0 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 2 | SCP0058_Shipment_Plan_FG_JV.cs:435 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.AllPlantSiteDescription, false, "", "") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-e0f3b237 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 2 | SCP0058_Shipment_Plan_FG_JV.cs:436 |  | FLAG | dtFromSiteCpy | null | 화면 필드/플래그 변경 |  |  |  |
| AC-93aaf9ee | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 2 | SCP0058_Shipment_Plan_FG_JV.cs:444 | try ▸ if (this._division.Substring(0, 2).Equals("EE")) ▸ if (this._division.Equals("EE_UC")) | FLAG | dtFromSiteCpyTmp | dtFromSite.Select().Where(c => c[DefMain.OPERATION_GROUP].ToString() == this._operationGro… | 화면 필드/플래그 변경 |  |  |  |
| AC-ff34e08e | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 2 | SCP0058_Shipment_Plan_FG_JV.cs:444 | try ▸ if (this._division.Substring(0, 2).Equals("EE")) ▸ if (this._division.Equals("EE_UC")) | DATA_OP | dtFromSite.Select().Where(c => c[DefMain.OPERATION_GROUP].ToString() == this._operationGro… | () | 데이터 객체 조작/조회 |  |  |  |
| AC-442d8a62 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 2 | SCP0058_Shipment_Plan_FG_JV.cs:444 | try ▸ if (this._division.Substring(0, 2).Equals("EE")) ▸ if (this._division.Equals("EE_UC")) | DATA_OP | dtFromSite.Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-a6abb881 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 2 | SCP0058_Shipment_Plan_FG_JV.cs:450 | try ▸ if (this._division.Substring(0, 2).Equals("EE")) ▸ else of (this._division.Equals("EE_UC")) ▸ if (this._division.Equals("EE")) | FLAG | dtFromSiteCpyTmp | dtFromSite.Select().Where(c => c[DefMain.OPERATION_GROUP].ToString() == this._operationGro… | 화면 필드/플래그 변경 |  |  |  |
| AC-a5382619 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 2 | SCP0058_Shipment_Plan_FG_JV.cs:450 | try ▸ if (this._division.Substring(0, 2).Equals("EE")) ▸ else of (this._division.Equals("EE_UC")) ▸ if (this._division.Equals("EE")) | DATA_OP | dtFromSite.Select().Where(c => c[DefMain.OPERATION_GROUP].ToString() == this._operationGro… | () | 데이터 객체 조작/조회 |  |  |  |
| AC-47873dad | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 2 | SCP0058_Shipment_Plan_FG_JV.cs:450 | try ▸ if (this._division.Substring(0, 2).Equals("EE")) ▸ else of (this._division.Equals("EE_UC")) ▸ if (this._division.Equals("EE")) | DATA_OP | dtFromSite.Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-a67faeb9 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 2 | SCP0058_Shipment_Plan_FG_JV.cs:450 | try ▸ if (this._division.Substring(0, 2).Equals("EE")) ▸ else of (this._division.Equals("EE_UC")) ▸ if (this._division.Equals("EE")) ▸ lambd… | DATA_OP | this._allDivisionsExceptUCEE.Contains | (c[DefMain.DIVISION_ID].ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-dd46611f | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 2 | SCP0058_Shipment_Plan_FG_JV.cs:454 | try ▸ if (this._division.Substring(0, 2).Equals("EE")) | STATE_RESET | dtFromSite.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-87770093 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 2 | SCP0058_Shipment_Plan_FG_JV.cs:457 | try ▸ if (this._division.Substring(0, 2).Equals("EE")) | CALL_EXT | dic_JV_Plant.TryGetValue | (this._division, out get_JV_Value) | ⚠ 의미 확인 필요 |  |  |  |
| AC-822e5916 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 2 | SCP0058_Shipment_Plan_FG_JV.cs:461 | try ▸ if (this._division.Substring(0, 2).Equals("EE")) ▸ if (get_JV_Value == null \|\| get_JV_Value == "") | DATA_OP | plantList.Add | ("9999!!!!") | 데이터 객체 조작/조회 |  |  |  |
| AC-df5db014 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 2 | SCP0058_Shipment_Plan_FG_JV.cs:462 | try ▸ if (this._division.Substring(0, 2).Equals("EE")) ▸ if (get_JV_Value == null \|\| get_JV_Value == "") | UI_PROP | clbFromSite.ALL_VIEW | false | 속성 ALL_VIEW 설정 |  |  |  |
| AC-f2e1ff93 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 2 | SCP0058_Shipment_Plan_FG_JV.cs:473 | try ▸ if (this._division.Substring(0, 2).Equals("EE")) ▸ else of (get_JV_Value == null \|\| get_JV_Value == "") ▸ for (i < splt_get_JV_Value… | DATA_OP | dtFromSiteCpyTmp.Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-10e55c36 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 2 | SCP0058_Shipment_Plan_FG_JV.cs:473 | try ▸ if (this._division.Substring(0, 2).Equals("EE")) ▸ else of (get_JV_Value == null \|\| get_JV_Value == "") ▸ for (i < splt_get_JV_Value… | DATA_OP | c["CODE"].ToString().Contains | (JV_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-9f5a7dcb | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 2 | SCP0058_Shipment_Plan_FG_JV.cs:475 | try ▸ if (this._division.Substring(0, 2).Equals("EE")) ▸ else of (get_JV_Value == null \|\| get_JV_Value == "") ▸ for (i < splt_get_JV_Value… | DATA_OP | dtFromSiteCpyTmp.Select().Where(c => c["CODE"].ToString().Contains(JV_ID)).CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-729c7046 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 2 | SCP0058_Shipment_Plan_FG_JV.cs:475 | try ▸ if (this._division.Substring(0, 2).Equals("EE")) ▸ else of (get_JV_Value == null \|\| get_JV_Value == "") ▸ for (i < splt_get_JV_Value… | DATA_OP | dtFromSiteCpyTmp.Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-6048f79d | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 2 | SCP0058_Shipment_Plan_FG_JV.cs:475 | try ▸ if (this._division.Substring(0, 2).Equals("EE")) ▸ else of (get_JV_Value == null \|\| get_JV_Value == "") ▸ for (i < splt_get_JV_Value… | DATA_OP | c["CODE"].ToString().Contains | (JV_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-8575a118 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 2 | SCP0058_Shipment_Plan_FG_JV.cs:477 | try ▸ if (this._division.Substring(0, 2).Equals("EE")) ▸ else of (get_JV_Value == null \|\| get_JV_Value == "") ▸ for (i < splt_get_JV_Value… | DATA_OP | dtFromSite.Merge | (dtTmp) | 데이터 객체 조작/조회 |  |  |  |
| AC-3bef1e8a | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 2 | SCP0058_Shipment_Plan_FG_JV.cs:482 | try ▸ if (this._division.Substring(0, 2).Equals("EE")) ▸ else of (get_JV_Value == null \|\| get_JV_Value == "") ▸ if (dtTmp.Rows.Count > 0) | UI_PROP | clbFromSite.ALL_VIEW | true | 속성 ALL_VIEW 설정 |  |  |  |
| AC-9f757682 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 2 | SCP0058_Shipment_Plan_FG_JV.cs:483 | try ▸ if (this._division.Substring(0, 2).Equals("EE")) ▸ else of (get_JV_Value == null \|\| get_JV_Value == "") ▸ else of (dtTmp.Rows.Count … | UI_PROP | clbFromSite.ALL_VIEW | false | 속성 ALL_VIEW 설정 |  |  |  |
| AC-38a37cf3 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 2 | SCP0058_Shipment_Plan_FG_JV.cs:488 | try ▸ else of (this._division.Substring(0, 2).Equals("EE")) | FLAG | dtFromSiteCpyTmp | dtFromSite.Select().Where(c => c[DefMain.OPERATION_GROUP].ToString() == this._operationGro… | 화면 필드/플래그 변경 |  |  |  |
| AC-e4feabee | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 2 | SCP0058_Shipment_Plan_FG_JV.cs:488 | try ▸ else of (this._division.Substring(0, 2).Equals("EE")) | DATA_OP | dtFromSite.Select().Where(c => c[DefMain.OPERATION_GROUP].ToString() == this._operationGro… | () | 데이터 객체 조작/조회 |  |  |  |
| AC-26a2b78c | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 2 | SCP0058_Shipment_Plan_FG_JV.cs:488 | try ▸ else of (this._division.Substring(0, 2).Equals("EE")) | DATA_OP | dtFromSite.Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-9f28a72f | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 2 | SCP0058_Shipment_Plan_FG_JV.cs:490 | try ▸ else of (this._division.Substring(0, 2).Equals("EE")) | STATE_RESET | dtFromSite.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-0b9af6af | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 2 | SCP0058_Shipment_Plan_FG_JV.cs:494 | try ▸ else of (this._division.Substring(0, 2).Equals("EE")) | CALL_EXT | dic_JV_Plant.TryGetValue | (this._division, out get_JV_Value) | ⚠ 의미 확인 필요 |  |  |  |
| AC-02fd4e63 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 2 | SCP0058_Shipment_Plan_FG_JV.cs:498 | try ▸ else of (this._division.Substring(0, 2).Equals("EE")) ▸ if (get_JV_Value == null \|\| get_JV_Value == "") | DATA_OP | plantList.Add | ("9999!!!!") | 데이터 객체 조작/조회 |  |  |  |
| AC-7354b719 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 2 | SCP0058_Shipment_Plan_FG_JV.cs:499 | try ▸ else of (this._division.Substring(0, 2).Equals("EE")) ▸ if (get_JV_Value == null \|\| get_JV_Value == "") | UI_PROP | clbFromSite.ALL_VIEW | false | 속성 ALL_VIEW 설정 |  |  |  |
| AC-ae0d2a3b | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 2 | SCP0058_Shipment_Plan_FG_JV.cs:510 | try ▸ else of (this._division.Substring(0, 2).Equals("EE")) ▸ else of (get_JV_Value == null \|\| get_JV_Value == "") ▸ for (i < splt_get_JV_… | DATA_OP | dtFromSiteCpyTmp.Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-4de7c2fb | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 2 | SCP0058_Shipment_Plan_FG_JV.cs:510 | try ▸ else of (this._division.Substring(0, 2).Equals("EE")) ▸ else of (get_JV_Value == null \|\| get_JV_Value == "") ▸ for (i < splt_get_JV_… | DATA_OP | c["CODE"].ToString().Contains | (JV_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-7facba27 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 2 | SCP0058_Shipment_Plan_FG_JV.cs:512 | try ▸ else of (this._division.Substring(0, 2).Equals("EE")) ▸ else of (get_JV_Value == null \|\| get_JV_Value == "") ▸ for (i < splt_get_JV_… | DATA_OP | dtFromSiteCpyTmp.Select().Where(c => c["CODE"].ToString().Contains(JV_ID)).CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-837726d2 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 2 | SCP0058_Shipment_Plan_FG_JV.cs:512 | try ▸ else of (this._division.Substring(0, 2).Equals("EE")) ▸ else of (get_JV_Value == null \|\| get_JV_Value == "") ▸ for (i < splt_get_JV_… | DATA_OP | dtFromSiteCpyTmp.Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-cc6b65d8 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 2 | SCP0058_Shipment_Plan_FG_JV.cs:512 | try ▸ else of (this._division.Substring(0, 2).Equals("EE")) ▸ else of (get_JV_Value == null \|\| get_JV_Value == "") ▸ for (i < splt_get_JV_… | DATA_OP | c["CODE"].ToString().Contains | (JV_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-a7652293 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 2 | SCP0058_Shipment_Plan_FG_JV.cs:514 | try ▸ else of (this._division.Substring(0, 2).Equals("EE")) ▸ else of (get_JV_Value == null \|\| get_JV_Value == "") ▸ for (i < splt_get_JV_… | DATA_OP | dtFromSite.Merge | (dtTmp) | 데이터 객체 조작/조회 |  |  |  |
| AC-3ede556d | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 2 | SCP0058_Shipment_Plan_FG_JV.cs:519 | try ▸ else of (this._division.Substring(0, 2).Equals("EE")) ▸ else of (get_JV_Value == null \|\| get_JV_Value == "") ▸ if (dtTmp.Rows.Count … | UI_PROP | clbFromSite.ALL_VIEW | true | 속성 ALL_VIEW 설정 |  |  |  |
| AC-d5e3a83c | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 2 | SCP0058_Shipment_Plan_FG_JV.cs:520 | try ▸ else of (this._division.Substring(0, 2).Equals("EE")) ▸ else of (get_JV_Value == null \|\| get_JV_Value == "") ▸ else of (dtTmp.Rows.C… | UI_PROP | clbFromSite.ALL_VIEW | false | 속성 ALL_VIEW 설정 |  |  |  |
| AC-fdd34c4c | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 2 | SCP0058_Shipment_Plan_FG_JV.cs:524 | try | FLAG | dtFromSiteCpy | dtFromSite.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-c649ac6f | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 2 | SCP0058_Shipment_Plan_FG_JV.cs:524 | try | DATA_OP | dtFromSite.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-56cb1fc4 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 2 | SCP0058_Shipment_Plan_FG_JV.cs:526 | try | LIST_REBIND | clsCtrl.setListBox | (dtFromSiteCpy, clbFromSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-42429af9 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 2 | SCP0058_Shipment_Plan_FG_JV.cs:530 | catch () | LIST_CLEAR | clbFromSite.Items.Clear | () | 목록 항목 비움 |  |  |  |

## SCP0058_Shipment_Plan_FG_JV.RefreshOperationGroup

진입점: this.Load [if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))] / cboDivision.SelectedIndexChanged [if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8d48f892 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 1 | SCP0058_Shipment_Plan_FG_JV.cs:421 | if (!this._division.Substring(0, 2).Equals("EE")) | FLAG | dtOperGrp | Data_SCP.Common(Data_SCP.Type.OperationGroup, false) | 화면 필드/플래그 변경 |  |  |  |
| AC-60a405e2 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 1 | SCP0058_Shipment_Plan_FG_JV.cs:421 | if (!this._division.Substring(0, 2).Equals("EE")) | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.OperationGroup, false) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-b02665ed | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 1 | SCP0058_Shipment_Plan_FG_JV.cs:425 | else of (!this._division.Substring(0, 2).Equals("EE")) | FLAG | dtOperGrp | Data_SCP.Common(Data_SCP.Type.OperationGroupEE, false) | 화면 필드/플래그 변경 |  |  |  |
| AC-3aedbdc5 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 1 | SCP0058_Shipment_Plan_FG_JV.cs:425 | else of (!this._division.Substring(0, 2).Equals("EE")) | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.OperationGroupEE, false) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-e65d0e94 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 1 | SCP0058_Shipment_Plan_FG_JV.cs:428 |  | LIST_REBIND | clsCtrl.setListBox | (dtOperGrp, cboBizType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0058_Shipment_Plan_FG_JV.RefreshPlanDate

진입점: this.Load [if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))] / cboDivision.SelectedIndexChanged [if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-df09ffe1 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 1 | SCP0058_Shipment_Plan_FG_JV.cs:555 |  | FLAG | dtPlanDate | Data.Common(Data.Type.PlanDate, false, this._division) ⇒ biz:CommonData.CommonDataList [code=PlanDate] | 화면 필드/플래그 변경 |  |  |  |
| AC-1186782c | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 1 | SCP0058_Shipment_Plan_FG_JV.cs:555 |  | COMBO_DATA | Data.Common | (Data.Type.PlanDate, false, this._division) ⇒ biz:CommonData.CommonDataList [code=PlanDate] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-01ab634c | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 1 | SCP0058_Shipment_Plan_FG_JV.cs:556 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanDate, cboPlanDate, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0058_Shipment_Plan_FG_JV.RefreshPlanSeq

진입점: this.Load [if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))] / cboDivision.SelectedIndexChanged [if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))] / cboPlanType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bc0fac99 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 2 | SCP0058_Shipment_Plan_FG_JV.cs:568 |  | FLAG | dtPlanSeq | Data.Common(Data.Type.PlanSeq, false, this._division, this._planDate, this._planType) ⇒ biz:CommonData.CommonDataList [code=PlanSeq] | 화면 필드/플래그 변경 |  |  |  |
| AC-b2697f7a | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 2 | SCP0058_Shipment_Plan_FG_JV.cs:568 |  | COMBO_DATA | Data.Common | (Data.Type.PlanSeq, false, this._division, this._planDate, this._planType) ⇒ biz:CommonData.CommonDataList [code=PlanSeq] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-6c230efe | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 2 | SCP0058_Shipment_Plan_FG_JV.cs:569 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanSeq, cboPlanSeq, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0058_Shipment_Plan_FG_JV.RefreshPlanType

진입점: this.Load [if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))] / cboDivision.SelectedIndexChanged [if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))] / cboPlanDate.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f9d76314 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 2 | SCP0058_Shipment_Plan_FG_JV.cs:560 |  | FLAG | dtPlanType | Data.Common(Data.Type.PlanType, false, this._division, this._planDate) ⇒ biz:CommonData.CommonDataList [code=PlanType] | 화면 필드/플래그 변경 |  |  |  |
| AC-f28d55ff | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 2 | SCP0058_Shipment_Plan_FG_JV.cs:560 |  | COMBO_DATA | Data.Common | (Data.Type.PlanType, false, this._division, this._planDate) ⇒ biz:CommonData.CommonDataList [code=PlanType] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-dbf15f85 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 2 | SCP0058_Shipment_Plan_FG_JV.cs:561 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanType, cboPlanType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-3f466056 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 2 | SCP0058_Shipment_Plan_FG_JV.cs:564 | if (dtPlanType.Rows.Count > 0) | VALUE_SET | cboPlanType.SelectedIndex | dtPlanType.Rows.Count - 1 | 컨트롤 값 설정 |  |  |  |

## SCP0058_Shipment_Plan_FG_JV.RefreshTeam

진입점: this.Load / cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-156c4200 | this.Load 외 1 | SCP0058_Shipment_Plan_FG_JV.cs:412 | if (!this._division.Substring(0, 2).Equals("EE")) | FLAG | dtTeam | Data.UserTeamByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.Use… | 화면 필드/플래그 변경 |  |  |  |
| AC-f9136d39 | this.Load 외 1 | SCP0058_Shipment_Plan_FG_JV.cs:412 | if (!this._division.Substring(0, 2).Equals("EE")) | COMBO_DATA | Data.UserTeamByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, this._division) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ec0d4cda | this.Load 외 1 | SCP0058_Shipment_Plan_FG_JV.cs:414 | else of (!this._division.Substring(0, 2).Equals("EE")) | FLAG | dtTeam | Data.UserTeamByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.Use… | 화면 필드/플래그 변경 |  |  |  |
| AC-5417ae70 | this.Load 외 1 | SCP0058_Shipment_Plan_FG_JV.cs:414 | else of (!this._division.Substring(0, 2).Equals("EE")) | COMBO_DATA | Data.UserTeamByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, this._allDivisions… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-2a43f300 | this.Load 외 1 | SCP0058_Shipment_Plan_FG_JV.cs:415 |  | LIST_REBIND | clsCtrl.setListBox | (dtTeam, clbTeam, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0058_Shipment_Plan_FG_JV.RefreshToSite

진입점: this.Load [if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))] / cboDivision.SelectedIndexChanged [if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))] / cboBizType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-813de2c5 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 2 | SCP0058_Shipment_Plan_FG_JV.cs:539 | try ▸ if (this._division.Substring(0, 2).Equals("EE")) | FLAG | dtToSite | Data_SCP.Common(Data_SCP.Type.ToSiteShipmentPlanFG, false, this._division, this._operation… | 화면 필드/플래그 변경 |  |  |  |
| AC-b92bff09 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 2 | SCP0058_Shipment_Plan_FG_JV.cs:539 | try ▸ if (this._division.Substring(0, 2).Equals("EE")) | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.ToSiteShipmentPlanFG, false, this._division, this._operationGroup) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-b2d4c26d | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 2 | SCP0058_Shipment_Plan_FG_JV.cs:543 | try ▸ else of (this._division.Substring(0, 2).Equals("EE")) | FLAG | dtToSite | Data.Common(Data.Type.SaleSiteByDivision, false, this._division) ⇒ biz:CommonData.CommonDataList [code=SaleSiteByDivision] | 화면 필드/플래그 변경 |  |  |  |
| AC-6dcf2d09 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 2 | SCP0058_Shipment_Plan_FG_JV.cs:543 | try ▸ else of (this._division.Substring(0, 2).Equals("EE")) | COMBO_DATA | Data.Common | (Data.Type.SaleSiteByDivision, false, this._division) ⇒ biz:CommonData.CommonDataList [code=SaleSiteByDivision] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-244c6d14 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 2 | SCP0058_Shipment_Plan_FG_JV.cs:546 | try | LIST_REBIND | clsCtrl.setListBox | (dtToSite, clbToSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-ca5226c7 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 2 | SCP0058_Shipment_Plan_FG_JV.cs:550 | catch () | LIST_CLEAR | clbToSite.Items.Clear | () | 목록 항목 비움 |  |  |  |

## SCP0058_Shipment_Plan_FG_JV.RetIntValue

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-70ed960e | (진입점 미연결) | SCP0058_Shipment_Plan_FG_JV.cs:2075 |  | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |

## SCP0058_Shipment_Plan_FG_JV.SaveData_FixInfo

진입점: this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock(siMain.SheetName))] / this.btnUnfix.Click [if (fps != null) ▸ else of (siMain.IsLock(siMain.SheetName)) ▸ if (MessageHelper.GMessageBox("MSG00016") == DialogResult.Yes)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2ae84a18 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0058_Shipment_Plan_FG_JV.cs:4024 | if (fps.Name == "spdMain") | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-3677a70f | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0058_Shipment_Plan_FG_JV.cs:4030 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ if (siMain.ActiveSheet.Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ec42b706 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0058_Shipment_Plan_FG_JV.cs:4056 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ if (fixType == "F") | POPUP | new SCM0002_RejectReasonPopup | ("Fix Reason") | 팝업/폼 생성 |  |  |  |
| AC-13178438 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0058_Shipment_Plan_FG_JV.cs:4057 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ if (fixType == "F") | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-5bb62963 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0058_Shipment_Plan_FG_JV.cs:4058 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ if (fixType == "F") | UI_PROP | popup.Width | 600 | 속성 Width 설정 |  |  |  |
| AC-974ffbca | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0058_Shipment_Plan_FG_JV.cs:4059 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ if (fixType == "F") | UI_PROP | popup.Height | 230 | 속성 Height 설정 |  |  |  |
| AC-dd853a12 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0058_Shipment_Plan_FG_JV.cs:4061 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ if (fixType == "F") | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-00ad5806 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0058_Shipment_Plan_FG_JV.cs:4071 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ if (fixType == "F") ▸ else of (popup.ShowDialog() == DialogResult.OK) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e6cd50d8 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0058_Shipment_Plan_FG_JV.cs:4084 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ if (selCells.Length < 1) | MESSAGE | MessageHelper.GMessageBox | ("MSG00134", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e54d3d2b | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0058_Shipment_Plan_FG_JV.cs:4085 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ if (selCells.Length < 1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-83baf0d2 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0058_Shipment_Plan_FG_JV.cs:4091 | if (fps.Name == "spdMain") ▸ if (siMain != null) | DATA_OP | dt.Columns.Add | ("A") | 데이터 객체 조작/조회 |  |  |  |
| AC-23ad6e22 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0058_Shipment_Plan_FG_JV.cs:4092 | if (fps.Name == "spdMain") ▸ if (siMain != null) | DATA_OP | dt.Columns.Add | ("p_active_flag") | 데이터 객체 조작/조회 |  |  |  |
| AC-a042d126 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0058_Shipment_Plan_FG_JV.cs:4093 | if (fps.Name == "spdMain") ▸ if (siMain != null) | DATA_OP | dt.Columns.Add | ("p_division_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-abc654e6 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0058_Shipment_Plan_FG_JV.cs:4094 | if (fps.Name == "spdMain") ▸ if (siMain != null) | DATA_OP | dt.Columns.Add | ("p_plan_start_yyyymmdd") | 데이터 객체 조작/조회 |  |  |  |
| AC-36c8ad41 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0058_Shipment_Plan_FG_JV.cs:4095 | if (fps.Name == "spdMain") ▸ if (siMain != null) | DATA_OP | dt.Columns.Add | ("p_plan_type") | 데이터 객체 조작/조회 |  |  |  |
| AC-1e3ae52e | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0058_Shipment_Plan_FG_JV.cs:4096 | if (fps.Name == "spdMain") ▸ if (siMain != null) | DATA_OP | dt.Columns.Add | ("p_seq") | 데이터 객체 조작/조회 |  |  |  |
| AC-a786ed1d | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0058_Shipment_Plan_FG_JV.cs:4097 | if (fps.Name == "spdMain") ▸ if (siMain != null) | DATA_OP | dt.Columns.Add | ("p_biz_type") | 데이터 객체 조작/조회 |  |  |  |
| AC-c088f296 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0058_Shipment_Plan_FG_JV.cs:4098 | if (fps.Name == "spdMain") ▸ if (siMain != null) | DATA_OP | dt.Columns.Add | ("p_project_code") | 데이터 객체 조작/조회 |  |  |  |
| AC-f141955d | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0058_Shipment_Plan_FG_JV.cs:4099 | if (fps.Name == "spdMain") ▸ if (siMain != null) | DATA_OP | dt.Columns.Add | ("p_item_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-539cc4ae | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0058_Shipment_Plan_FG_JV.cs:4100 | if (fps.Name == "spdMain") ▸ if (siMain != null) | DATA_OP | dt.Columns.Add | ("p_to_site") | 데이터 객체 조작/조회 |  |  |  |
| AC-a6d864bc | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0058_Shipment_Plan_FG_JV.cs:4101 | if (fps.Name == "spdMain") ▸ if (siMain != null) | DATA_OP | dt.Columns.Add | ("p_incoterms") | 데이터 객체 조작/조회 |  |  |  |
| AC-19be5b2b | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0058_Shipment_Plan_FG_JV.cs:4102 | if (fps.Name == "spdMain") ▸ if (siMain != null) | DATA_OP | dt.Columns.Add | ("p_from_site") | 데이터 객체 조작/조회 |  |  |  |
| AC-98a62fbe | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0058_Shipment_Plan_FG_JV.cs:4103 | if (fps.Name == "spdMain") ▸ if (siMain != null) | DATA_OP | dt.Columns.Add | ("p_bod_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-c772217e | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0058_Shipment_Plan_FG_JV.cs:4104 | if (fps.Name == "spdMain") ▸ if (siMain != null) | DATA_OP | dt.Columns.Add | ("p_measure") | 데이터 객체 조작/조회 |  |  |  |
| AC-007ae8cb | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0058_Shipment_Plan_FG_JV.cs:4105 | if (fps.Name == "spdMain") ▸ if (siMain != null) | DATA_OP | dt.Columns.Add | ("p_yyyymmdd") | 데이터 객체 조작/조회 |  |  |  |
| AC-355a433e | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0058_Shipment_Plan_FG_JV.cs:4106 | if (fps.Name == "spdMain") ▸ if (siMain != null) | DATA_OP | dt.Columns.Add | ("p_qty") | 데이터 객체 조작/조회 |  |  |  |
| AC-6ece3fb9 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0058_Shipment_Plan_FG_JV.cs:4107 | if (fps.Name == "spdMain") ▸ if (siMain != null) | DATA_OP | dt.Columns.Add | ("p_origin_from_division_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-a57b6a85 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0058_Shipment_Plan_FG_JV.cs:4108 | if (fps.Name == "spdMain") ▸ if (siMain != null) | DATA_OP | dt.Columns.Add | ("p_origin_to_division_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-41b9efcc | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0058_Shipment_Plan_FG_JV.cs:4109 | if (fps.Name == "spdMain") ▸ if (siMain != null) | DATA_OP | dt.Columns.Add | ("p_electrode_type") | 데이터 객체 조작/조회 |  |  |  |
| AC-61beb17b | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0058_Shipment_Plan_FG_JV.cs:4110 | if (fps.Name == "spdMain") ▸ if (siMain != null) | DATA_OP | dt.Columns.Add | ("p_fix_reason") | 데이터 객체 조작/조회 |  |  |  |
| AC-fc6bfb50 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0058_Shipment_Plan_FG_JV.cs:4111 | if (fps.Name == "spdMain") ▸ if (siMain != null) | DATA_OP | dt.Columns.Add | ("p_bucket_type") | 데이터 객체 조작/조회 |  |  |  |
| AC-34c28949 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0058_Shipment_Plan_FG_JV.cs:4112 | if (fps.Name == "spdMain") ▸ if (siMain != null) | DATA_OP | dt.Columns.Add | ("p_created_by") | 데이터 객체 조작/조회 |  |  |  |
| AC-16c26e0b | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0058_Shipment_Plan_FG_JV.cs:4113 | if (fps.Name == "spdMain") ▸ if (siMain != null) | DATA_OP | dt.Columns.Add | ("p_last_updated_by") | 데이터 객체 조작/조회 |  |  |  |
| AC-d0ead7f4 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0058_Shipment_Plan_FG_JV.cs:4114 | if (fps.Name == "spdMain") ▸ if (siMain != null) | DATA_OP | dt.Columns.Add | ("p_time_zone") | 데이터 객체 조작/조회 |  |  |  |
| AC-518cfd71 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0058_Shipment_Plan_FG_JV.cs:4115 | if (fps.Name == "spdMain") ▸ if (siMain != null) | DATA_OP | dt.Columns.Add | ("debug_mode") | 데이터 객체 조작/조회 |  |  |  |
| AC-20fe2b2f | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0058_Shipment_Plan_FG_JV.cs:4116 | if (fps.Name == "spdMain") ▸ if (siMain != null) | DATA_OP | dsInput.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-87082082 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0058_Shipment_Plan_FG_JV.cs:4142 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | CALL_EXT | siMain.ActiveSheet.GetRowVisible | (i) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f08ca03d | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0058_Shipment_Plan_FG_JV.cs:4159 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | GRID_STYLE | siMain.SetBGColor | (i, j, i, j, ControlColor.InvalidColor) | 그리드 표시 설정 |  |  |  |
| AC-6437639c | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0058_Shipment_Plan_FG_JV.cs:4160 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | MESSAGE | MessageHelper.GMessageBox | ("MSG00026", new object[] { null }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-833cf0f5 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0058_Shipment_Plan_FG_JV.cs:4161 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-663225a0 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0058_Shipment_Plan_FG_JV.cs:4167 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | CALL_EXT | siMain.GetBGColor | (i, j) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a57a995d | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0058_Shipment_Plan_FG_JV.cs:4198 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dsInput.Tables[0].NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-af68955b | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0058_Shipment_Plan_FG_JV.cs:4199 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_active_flag"] | strAction | 행/컬럼 값 대입 |  |  |  |
| AC-d6ca3514 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0058_Shipment_Plan_FG_JV.cs:4200 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_division_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.DIVISION_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-64059dbe | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0058_Shipment_Plan_FG_JV.cs:4201 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_plan_start_yyyymmdd"] | sPlanStartYyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-8b64b9bc | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0058_Shipment_Plan_FG_JV.cs:4202 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_plan_type"] | sPlanType | 행/컬럼 값 대입 |  |  |  |
| AC-29a30f95 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0058_Shipment_Plan_FG_JV.cs:4203 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_seq"] | sSeq | 행/컬럼 값 대입 |  |  |  |
| AC-d90bee82 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0058_Shipment_Plan_FG_JV.cs:4204 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_biz_type"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.BIZ_TYPE)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-deeb20b1 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0058_Shipment_Plan_FG_JV.cs:4205 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_item_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.ITEM_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-d99c29b5 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0058_Shipment_Plan_FG_JV.cs:4206 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_to_site"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.TO_SITE)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-a8d3211d | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0058_Shipment_Plan_FG_JV.cs:4207 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_from_site"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.FROM_SITE)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-8c9f4e1e | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0058_Shipment_Plan_FG_JV.cs:4208 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_project_code"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.PROJECT_CODE)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-43578699 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0058_Shipment_Plan_FG_JV.cs:4209 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_incoterms"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.INCOTERMS)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-5906e5b1 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0058_Shipment_Plan_FG_JV.cs:4210 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_bod_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.BOD_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-62bf59b3 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0058_Shipment_Plan_FG_JV.cs:4211 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_yyyymmdd"] | strYYYYMMDD | 행/컬럼 값 대입 |  |  |  |
| AC-4a377f35 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0058_Shipment_Plan_FG_JV.cs:4212 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_qty"] | sQty | 행/컬럼 값 대입 |  |  |  |
| AC-84c17645 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0058_Shipment_Plan_FG_JV.cs:4213 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_origin_from_division_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.ORIGIN_FROM_DIVISION_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-2497b0d7 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0058_Shipment_Plan_FG_JV.cs:4214 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_origin_to_division_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.ORIGIN_TO_DIVISION_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-e9067713 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0058_Shipment_Plan_FG_JV.cs:4215 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_electrode_type"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.ELECTRODE_TYPE)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-257f2576 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0058_Shipment_Plan_FG_JV.cs:4216 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_fix_reason"] | strReason | 행/컬럼 값 대입 |  |  |  |
| AC-ab269c8a | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0058_Shipment_Plan_FG_JV.cs:4217 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_bucket_type"] | cboBucketType.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-3acd3f4e | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0058_Shipment_Plan_FG_JV.cs:4218 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_created_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-785f5e0c | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0058_Shipment_Plan_FG_JV.cs:4219 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_last_updated_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-aca52095 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0058_Shipment_Plan_FG_JV.cs:4220 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_time_zone"] | UserInfoContext.Current[UserInfoProperites.TimeZone] | 행/컬럼 값 대입 |  |  |  |
| AC-7e572177 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0058_Shipment_Plan_FG_JV.cs:4221 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-2186ff54 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0058_Shipment_Plan_FG_JV.cs:4222 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dsInput.Tables[0].Rows.Add | (dr) | 데이터 객체 조작/조회 |  |  |  |
| AC-d3327d54 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0058_Shipment_Plan_FG_JV.cs:4236 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | CALL_EXT | siMain.GetBGColor | (i, j + nDayCntOfWeek) | ⚠ 의미 확인 필요 |  |  |  |
| AC-408bbb4b | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0058_Shipment_Plan_FG_JV.cs:4244 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | GRID_STYLE | siMain.SetBGColor | (i, j + nDayCntOfWeek, i, j + nDayCntOfWeek, ControlColor.InvalidColor) | 그리드 표시 설정 |  |  |  |
| AC-3adc15fc | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0058_Shipment_Plan_FG_JV.cs:4245 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | MESSAGE | MessageHelper.GMessageBox | ("MSG00026", new object[] { null }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-2ef08385 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0058_Shipment_Plan_FG_JV.cs:4246 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-339e00f3 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0058_Shipment_Plan_FG_JV.cs:4276 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dsInput.Tables[0].NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-ad1ab9d5 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0058_Shipment_Plan_FG_JV.cs:4277 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_active_flag"] | strAction | 행/컬럼 값 대입 |  |  |  |
| AC-d06dedeb | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0058_Shipment_Plan_FG_JV.cs:4278 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_division_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.DIVISION_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-5deb9356 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0058_Shipment_Plan_FG_JV.cs:4279 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_plan_start_yyyymmdd"] | sPlanStartYyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-22e56874 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0058_Shipment_Plan_FG_JV.cs:4280 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_plan_type"] | sPlanType | 행/컬럼 값 대입 |  |  |  |
| AC-cbac1a74 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0058_Shipment_Plan_FG_JV.cs:4281 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_seq"] | sSeq | 행/컬럼 값 대입 |  |  |  |
| AC-dfd20da8 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0058_Shipment_Plan_FG_JV.cs:4282 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_biz_type"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.BIZ_TYPE)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-78ff3be6 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0058_Shipment_Plan_FG_JV.cs:4283 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_item_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.ITEM_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-f68d57af | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0058_Shipment_Plan_FG_JV.cs:4284 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_to_site"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.TO_SITE)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-0f41e2b3 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0058_Shipment_Plan_FG_JV.cs:4285 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_from_site"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.FROM_SITE)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-03b6a248 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0058_Shipment_Plan_FG_JV.cs:4286 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_project_code"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.PROJECT_CODE)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-12bcaac8 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0058_Shipment_Plan_FG_JV.cs:4287 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_incoterms"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.INCOTERMS)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-da7432c3 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0058_Shipment_Plan_FG_JV.cs:4288 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_bod_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.BOD_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-c04e156d | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0058_Shipment_Plan_FG_JV.cs:4289 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_yyyymmdd"] | strYYYYMMDD | 행/컬럼 값 대입 |  |  |  |
| AC-edce1122 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0058_Shipment_Plan_FG_JV.cs:4290 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_qty"] | sQty | 행/컬럼 값 대입 |  |  |  |
| AC-37c469ff | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0058_Shipment_Plan_FG_JV.cs:4291 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_origin_from_division_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.ORIGIN_FROM_DIVISION_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-7a52a909 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0058_Shipment_Plan_FG_JV.cs:4292 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_origin_to_division_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.ORIGIN_TO_DIVISION_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-00010562 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0058_Shipment_Plan_FG_JV.cs:4293 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_electrode_type"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.ELECTRODE_TYPE)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-2444fd57 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0058_Shipment_Plan_FG_JV.cs:4294 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_fix_reason"] | strReason | 행/컬럼 값 대입 |  |  |  |
| AC-53365324 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0058_Shipment_Plan_FG_JV.cs:4295 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_bucket_type"] | cboBucketType.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-c489b8b0 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0058_Shipment_Plan_FG_JV.cs:4296 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_created_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-b4999bbf | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0058_Shipment_Plan_FG_JV.cs:4297 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_last_updated_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-fcfe6702 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0058_Shipment_Plan_FG_JV.cs:4298 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_time_zone"] | UserInfoContext.Current[UserInfoProperites.TimeZone] | 행/컬럼 값 대입 |  |  |  |
| AC-34efbe52 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0058_Shipment_Plan_FG_JV.cs:4299 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-c911168e | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0058_Shipment_Plan_FG_JV.cs:4300 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dsInput.Tables[0].Rows.Add | (dr) | 데이터 객체 조작/조회 |  |  |  |
| AC-4689e648 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0058_Shipment_Plan_FG_JV.cs:4354 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ if (fixType.Equals("U") && iCount == 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00046", new object[] { null }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-dc48acc4 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0058_Shipment_Plan_FG_JV.cs:4355 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ if (fixType.Equals("U") && iCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c9081ed6 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0058_Shipment_Plan_FG_JV.cs:4361 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ if (iCount > 0) | DATA_OP | dsInput.Tables[0].AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-d0da00ee | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0058_Shipment_Plan_FG_JV.cs:4366 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ if (iCount > 0) | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-bb1bb03b | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0058_Shipment_Plan_FG_JV.cs:4375 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ if (iCount > 0) ▸ try | CALL_EXT | sql.AddParameter | (SqlDbType.Structured, "@SCP0009", dsInput.Tables[0]) | ⚠ 의미 확인 필요 |  |  |  |
| AC-08bfc2d1 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0058_Shipment_Plan_FG_JV.cs:4376 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ if (iCount > 0) ▸ try | ENDPOINT | sql.ExcuteProcedure | ("dbo.SCP0009_SAVE_ANL_SHIPMENT_PLAN_FG_FIX_DATASET") ⇒ biz:AppService.GeneralRunProcedureCustomTable [procedure=dbo.SCP0009_SAVE_ANL_SH… | 엔드포인트 호출 |  |  |  |
| AC-29c3e168 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0058_Shipment_Plan_FG_JV.cs:4379 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ if (iCount > 0) ▸ try | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-ae656193 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0058_Shipment_Plan_FG_JV.cs:4384 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ if (iCount > 0) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["re… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { result.Rows[0]["result_cnt"].ToString() }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-53f13443 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0058_Shipment_Plan_FG_JV.cs:4393 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ if (iCount > 0) ▸ try ▸ else of (result != null && result.Rows.Count > 0 && result.Rows[0… | MESSAGE | MessageHelper.GMessageBox | ("MSG00003", new object[] { ReErrorMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b4dde0fe | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0058_Shipment_Plan_FG_JV.cs:4402 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ if (iCount > 0) ▸ catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-068bf375 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0058_Shipment_Plan_FG_JV.cs:4403 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ if (iCount > 0) ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-59c255b7 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0058_Shipment_Plan_FG_JV.cs:4409 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ if (iCount > 0) ▸ finally ▸ if (!prgCloseF) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-0ea2eee2 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0058_Shipment_Plan_FG_JV.cs:4417 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ else of (iCount > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00252", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b4480dcb | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0058_Shipment_Plan_FG_JV.cs:4418 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ else of (iCount > 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0058_Shipment_Plan_FG_JV.SaveData_Main

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0e6766f4 | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2654 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (siMain.ActiveSheet.Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8d8d50dd | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2656 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (!Get_IsSaveYn()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-79ef4a8e | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2663 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-239d4286 | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2666 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-5d70305a | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2688 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (iRow < siMain.ActiveSheet.Rows.… | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-19b5965d | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2690 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (iRow < siMain.ActiveSheet.Rows.… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-81055e5c | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2692 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (iRow < siMain.ActiveSheet.Rows.… | CALL_EXT | Math.Truncate | (nDayQty) | ⚠ 의미 확인 필요 |  |  |  |
| AC-7da29acb | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2694 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (iRow < siMain.ActiveSheet.Rows.… | CALL_EXT | Math.Truncate | (Convert.ToDouble(val)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ee6b4e2c | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2696 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (iRow < siMain.ActiveSheet.Rows.… | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-748e9e49 | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2698 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (iRow < siMain.ActiveSheet.Rows.… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4fb01ad4 | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2708 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (iRow < siMain.ActiveSheet.Rows.… | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-b44c1227 | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2710 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (iRow < siMain.ActiveSheet.Rows.… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-445e1229 | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2727 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (iRow < siMain.ActiveSheet.Rows.… | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-1bf4e82d | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2729 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (iRow < siMain.ActiveSheet.Rows.… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2fe7820c | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2731 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (iRow < siMain.ActiveSheet.Rows.… | CALL_EXT | Math.Truncate | (nDayQty) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f4788b7a | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2733 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (iRow < siMain.ActiveSheet.Rows.… | CALL_EXT | Math.Truncate | (Convert.ToDouble(val)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-db238723 | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2735 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (iRow < siMain.ActiveSheet.Rows.… | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-cb1e6274 | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2737 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (iRow < siMain.ActiveSheet.Rows.… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4b3d5df5 | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2747 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | FLAG | saveDS | new DataSet() | 화면 필드/플래그 변경 |  |  |  |
| AC-0bcf762f | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2749 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dt.Columns.Add | ("A", typeof(char)) | 데이터 객체 조작/조회 |  |  |  |
| AC-300319b2 | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2750 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dt.Columns.Add | ("p_active_flag") | 데이터 객체 조작/조회 |  |  |  |
| AC-363feb55 | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2751 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dt.Columns.Add | ("p_division_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-f6d943b7 | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2752 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dt.Columns.Add | ("p_plan_start_yyyymmdd") | 데이터 객체 조작/조회 |  |  |  |
| AC-08fb4a37 | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2753 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dt.Columns.Add | ("p_plan_type") | 데이터 객체 조작/조회 |  |  |  |
| AC-32c53735 | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2754 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dt.Columns.Add | ("p_seq") | 데이터 객체 조작/조회 |  |  |  |
| AC-37ef6fe5 | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2755 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dt.Columns.Add | ("p_biz_type") | 데이터 객체 조작/조회 |  |  |  |
| AC-08cd1ed0 | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2756 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dt.Columns.Add | ("p_project_code") | 데이터 객체 조작/조회 |  |  |  |
| AC-61413142 | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2757 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dt.Columns.Add | ("p_item_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-e54d8800 | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2758 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dt.Columns.Add | ("p_to_site") | 데이터 객체 조작/조회 |  |  |  |
| AC-f716889e | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2759 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dt.Columns.Add | ("p_incoterms") | 데이터 객체 조작/조회 |  |  |  |
| AC-5e7ca314 | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2760 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dt.Columns.Add | ("p_from_site") | 데이터 객체 조작/조회 |  |  |  |
| AC-76f96612 | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2761 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dt.Columns.Add | ("p_bod_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-9d420414 | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2762 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dt.Columns.Add | ("p_measure") | 데이터 객체 조작/조회 |  |  |  |
| AC-f1541e0c | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2763 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dt.Columns.Add | ("p_yyyymmdd") | 데이터 객체 조작/조회 |  |  |  |
| AC-42f02791 | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2764 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dt.Columns.Add | ("p_qty") | 데이터 객체 조작/조회 |  |  |  |
| AC-e6e02748 | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2765 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dt.Columns.Add | ("p_origin_from_division_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-d2eb5538 | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2766 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dt.Columns.Add | ("p_origin_to_division_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-75060a04 | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2767 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dt.Columns.Add | ("p_electrode_type") | 데이터 객체 조작/조회 |  |  |  |
| AC-ebc1a841 | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2768 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dt.Columns.Add | ("p_created_by") | 데이터 객체 조작/조회 |  |  |  |
| AC-c92cb564 | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2769 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dt.Columns.Add | ("p_last_updated_by") | 데이터 객체 조작/조회 |  |  |  |
| AC-8d196c28 | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2770 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dt.Columns.Add | ("p_time_zone") | 데이터 객체 조작/조회 |  |  |  |
| AC-1fb91182 | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2771 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dt.Columns.Add | ("p_first_row") | 데이터 객체 조작/조회 |  |  |  |
| AC-4f1c04ec | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2772 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dt.Columns.Add | ("p_last_row") | 데이터 객체 조작/조회 |  |  |  |
| AC-fc80c53b | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2773 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | saveDS.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-2f4719ac | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2778 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dtInput.Columns.Add | ("A") | 데이터 객체 조작/조회 |  |  |  |
| AC-d6d4b035 | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2779 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dtInput.Columns.Add | ("p_active_flag") | 데이터 객체 조작/조회 |  |  |  |
| AC-79ee36cf | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2780 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dtInput.Columns.Add | ("p_division_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-bdae21d3 | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2781 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dtInput.Columns.Add | ("p_plan_start_yyyymmdd") | 데이터 객체 조작/조회 |  |  |  |
| AC-9b68ada9 | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2782 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dtInput.Columns.Add | ("p_plan_type") | 데이터 객체 조작/조회 |  |  |  |
| AC-0f238f5c | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2783 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dtInput.Columns.Add | ("p_seq") | 데이터 객체 조작/조회 |  |  |  |
| AC-ca11563f | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2784 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dtInput.Columns.Add | ("p_biz_type") | 데이터 객체 조작/조회 |  |  |  |
| AC-e6afe00e | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2785 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dtInput.Columns.Add | ("p_project_code") | 데이터 객체 조작/조회 |  |  |  |
| AC-6a398b6d | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2786 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dtInput.Columns.Add | ("p_item_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-b76a2337 | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2787 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dtInput.Columns.Add | ("p_to_site") | 데이터 객체 조작/조회 |  |  |  |
| AC-63e36a95 | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2788 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dtInput.Columns.Add | ("p_incoterms") | 데이터 객체 조작/조회 |  |  |  |
| AC-0b9f9a69 | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2789 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dtInput.Columns.Add | ("p_from_site") | 데이터 객체 조작/조회 |  |  |  |
| AC-f3fc331e | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2790 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dtInput.Columns.Add | ("p_bod_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-a208aa39 | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2791 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dtInput.Columns.Add | ("p_measure") | 데이터 객체 조작/조회 |  |  |  |
| AC-0bd4c075 | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2792 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dtInput.Columns.Add | ("p_yyyymmdd") | 데이터 객체 조작/조회 |  |  |  |
| AC-4990493d | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2793 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dtInput.Columns.Add | ("p_qty") | 데이터 객체 조작/조회 |  |  |  |
| AC-d2742525 | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2794 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dtInput.Columns.Add | ("p_origin_from_division_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-55afdafa | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2795 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dtInput.Columns.Add | ("p_origin_to_division_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-7f630759 | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2796 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dtInput.Columns.Add | ("p_electrode_type") | 데이터 객체 조작/조회 |  |  |  |
| AC-8804d44a | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2797 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dtInput.Columns.Add | ("p_fix_reason") | 데이터 객체 조작/조회 |  |  |  |
| AC-10f969be | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2798 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dtInput.Columns.Add | ("p_bucket_type") | 데이터 객체 조작/조회 |  |  |  |
| AC-d4866a9b | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2799 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dtInput.Columns.Add | ("p_created_by") | 데이터 객체 조작/조회 |  |  |  |
| AC-84c40d8c | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2800 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dtInput.Columns.Add | ("p_last_updated_by") | 데이터 객체 조작/조회 |  |  |  |
| AC-0b92a33a | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2801 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dtInput.Columns.Add | ("p_time_zone") | 데이터 객체 조작/조회 |  |  |  |
| AC-b15a59e9 | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2802 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dtInput.Columns.Add | ("debug_mode") | 데이터 객체 조작/조회 |  |  |  |
| AC-e052a806 | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2803 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dsInput.Tables.Add | (dtInput) | 데이터 객체 조작/조회 |  |  |  |
| AC-af85da3b | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2837 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | saveDS.Tables[0].NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-64f070c1 | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2838 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["A"] | action | 행/컬럼 값 대입 |  |  |  |
| AC-414742e8 | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2839 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_active_flag"] | action | 행/컬럼 값 대입 |  |  |  |
| AC-3f6603ba | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2840 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_division_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.DIVISION_ID)) | 행/컬럼 값 대입 |  |  |  |
| AC-24c05394 | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2841 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-ae2884db | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2842 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-66b60301 | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2843 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-f66b1178 | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2844 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_biz_type"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.BIZ_TYPE)) | 행/컬럼 값 대입 |  |  |  |
| AC-2a54fac4 | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2845 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_project_code"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.PROJECT_CODE)) | 행/컬럼 값 대입 |  |  |  |
| AC-c573525a | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2846 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_item_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.ITEM_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-17acb79e | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2847 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_to_site"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.TO_SITE)) | 행/컬럼 값 대입 |  |  |  |
| AC-9777266a | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2848 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_incoterms"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.INCOTERMS)) | 행/컬럼 값 대입 |  |  |  |
| AC-400ba847 | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2849 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_from_site"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.FROM_SITE)) | 행/컬럼 값 대입 |  |  |  |
| AC-f5d0d946 | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2850 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_bod_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.BOD_ID)) | 행/컬럼 값 대입 |  |  |  |
| AC-711d082f | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2851 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_measure"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.MEASURE)) | 행/컬럼 값 대입 |  |  |  |
| AC-58e644c1 | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2854 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_yyyymmdd"] | yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-26e5de04 | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2855 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_qty"] | 0 | 행/컬럼 값 대입 |  |  |  |
| AC-28fa13b2 | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2862 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_origin_from_division_id"] | org_from_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-51beed2b | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2869 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_origin_to_division_id"] | org_to_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-9fb0f85e | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2876 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_electrode_type"] | elec_type | 행/컬럼 값 대입 |  |  |  |
| AC-855a4ed3 | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2878 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_created_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-64b4ab45 | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2879 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_last_updated_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-1d5b81cd | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2880 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_time_zone"] | UserInfoContext.Current[UserInfoProperites.TimeZone] | 행/컬럼 값 대입 |  |  |  |
| AC-2238c0cb | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2882 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | saveDS.Tables[0].Rows.Add | (dr) | 데이터 객체 조작/조회 |  |  |  |
| AC-c0dc1259 | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2887 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dsInput.Tables[0].NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-9d580e79 | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2888 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dRow["A"] | action | 행/컬럼 값 대입 |  |  |  |
| AC-0342aeee | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2889 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dRow["p_active_flag"] | action | 행/컬럼 값 대입 |  |  |  |
| AC-31ddf493 | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2890 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dRow["p_division_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.DIVISION_ID)) | 행/컬럼 값 대입 |  |  |  |
| AC-11bacc1b | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2891 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dRow["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-a55cf128 | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2892 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dRow["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-1a033bf0 | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2893 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dRow["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-de2aec84 | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2894 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dRow["p_biz_type"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.BIZ_TYPE)) | 행/컬럼 값 대입 |  |  |  |
| AC-fdfbd1ae | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2895 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dRow["p_project_code"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.PROJECT_CODE)) | 행/컬럼 값 대입 |  |  |  |
| AC-14c840ff | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2896 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dRow["p_item_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.ITEM_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-943cdcf5 | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2897 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dRow["p_to_site"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.TO_SITE)) | 행/컬럼 값 대입 |  |  |  |
| AC-873d6353 | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2898 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dRow["p_incoterms"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.INCOTERMS)) | 행/컬럼 값 대입 |  |  |  |
| AC-f906790a | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2899 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dRow["p_from_site"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.FROM_SITE)) | 행/컬럼 값 대입 |  |  |  |
| AC-f5aa93cf | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2900 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dRow["p_bod_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.BOD_ID)) | 행/컬럼 값 대입 |  |  |  |
| AC-47854f8b | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2901 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dRow["p_measure"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.MEASURE)) | 행/컬럼 값 대입 |  |  |  |
| AC-8d099ffb | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2902 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dRow["p_yyyymmdd"] | yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-f998bf6f | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2903 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dRow["p_qty"] | 0 | 행/컬럼 값 대입 |  |  |  |
| AC-2528230c | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2904 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dRow["p_origin_from_division_id"] | org_from_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-66ac5eff | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2905 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dRow["p_origin_to_division_id"] | org_to_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-446c36ff | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2906 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dRow["p_electrode_type"] | elec_type | 행/컬럼 값 대입 |  |  |  |
| AC-34e08e75 | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2907 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dRow["p_created_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-963041ad | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2908 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dRow["p_last_updated_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-89e7729d | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2909 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dRow["p_time_zone"] | UserInfoContext.Current[UserInfoProperites.TimeZone] | 행/컬럼 값 대입 |  |  |  |
| AC-45787e33 | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2910 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dRow["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-e8ee2f81 | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2911 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dsInput.Tables[0].Rows.Add | (dRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-372be30a | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2925 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | saveDS.Tables[0].NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-8ce4b49f | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2926 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["A"] | action | 행/컬럼 값 대입 |  |  |  |
| AC-4a062e19 | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2927 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_active_flag"] | action | 행/컬럼 값 대입 |  |  |  |
| AC-d0f5c657 | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2928 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_division_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.DIVISION_ID)) | 행/컬럼 값 대입 |  |  |  |
| AC-c156e51b | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2929 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-e87fb640 | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2930 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-bf771a47 | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2931 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-1cc7e9ae | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2932 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_biz_type"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.BIZ_TYPE)) | 행/컬럼 값 대입 |  |  |  |
| AC-fd9ece63 | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2933 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_project_code"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.PROJECT_CODE)) | 행/컬럼 값 대입 |  |  |  |
| AC-95756610 | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2934 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_item_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.ITEM_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-c234fdb7 | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2935 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_to_site"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.TO_SITE)) | 행/컬럼 값 대입 |  |  |  |
| AC-ac3537c1 | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2936 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_incoterms"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.INCOTERMS)) | 행/컬럼 값 대입 |  |  |  |
| AC-bba01a63 | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2937 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_from_site"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.FROM_SITE)) | 행/컬럼 값 대입 |  |  |  |
| AC-7d0b0983 | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2938 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_bod_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.BOD_ID)) | 행/컬럼 값 대입 |  |  |  |
| AC-a5fcdb99 | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2939 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_measure"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.MEASURE)) | 행/컬럼 값 대입 |  |  |  |
| AC-9e773f6d | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2942 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_yyyymmdd"] | yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-693d5e79 | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2943 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_qty"] | val | 행/컬럼 값 대입 |  |  |  |
| AC-3ddcce0f | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2950 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_origin_from_division_id"] | org_from_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-3c91fda0 | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2957 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_origin_to_division_id"] | org_to_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-ab7c5981 | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2964 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_electrode_type"] | elec_type | 행/컬럼 값 대입 |  |  |  |
| AC-8acc9888 | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2966 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_created_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-ca207990 | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2967 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_last_updated_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-90fc5867 | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2968 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_time_zone"] | UserInfoContext.Current[UserInfoProperites.TimeZone] | 행/컬럼 값 대입 |  |  |  |
| AC-c92d7fc5 | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2970 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | saveDS.Tables[0].Rows.Add | (dr) | 데이터 객체 조작/조회 |  |  |  |
| AC-e9028f25 | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2975 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dsInput.Tables[0].NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-3c21c7cd | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2976 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dRow["A"] | action | 행/컬럼 값 대입 |  |  |  |
| AC-dfa5038b | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2977 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dRow["p_active_flag"] | action | 행/컬럼 값 대입 |  |  |  |
| AC-85d754fa | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2978 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dRow["p_division_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.DIVISION_ID)) | 행/컬럼 값 대입 |  |  |  |
| AC-e1de1fff | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2979 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dRow["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-a78fc706 | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2980 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dRow["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-28452643 | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2981 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dRow["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-df2ab107 | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2982 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dRow["p_biz_type"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.BIZ_TYPE)) | 행/컬럼 값 대입 |  |  |  |
| AC-38b4d1b4 | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2983 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dRow["p_project_code"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.PROJECT_CODE)) | 행/컬럼 값 대입 |  |  |  |
| AC-9954dc15 | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2984 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dRow["p_item_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.ITEM_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-385fded7 | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2985 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dRow["p_to_site"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.TO_SITE)) | 행/컬럼 값 대입 |  |  |  |
| AC-0ba420c5 | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2986 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dRow["p_incoterms"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.INCOTERMS)) | 행/컬럼 값 대입 |  |  |  |
| AC-a51099a8 | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2987 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dRow["p_from_site"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.FROM_SITE)) | 행/컬럼 값 대입 |  |  |  |
| AC-7e5732fa | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2988 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dRow["p_bod_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.BOD_ID)) | 행/컬럼 값 대입 |  |  |  |
| AC-54004cb9 | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2989 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dRow["p_measure"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.MEASURE)) | 행/컬럼 값 대입 |  |  |  |
| AC-82a06947 | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2990 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dRow["p_yyyymmdd"] | yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-4f4bcb9b | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2991 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dRow["p_qty"] | val | 행/컬럼 값 대입 |  |  |  |
| AC-200e5939 | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2992 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dRow["p_origin_from_division_id"] | org_from_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-4def6193 | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2993 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dRow["p_origin_to_division_id"] | org_to_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-84252af8 | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2994 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dRow["p_electrode_type"] | elec_type | 행/컬럼 값 대입 |  |  |  |
| AC-aba69b25 | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2995 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dRow["p_created_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-b4a2ea60 | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2996 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dRow["p_last_updated_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-67a120c4 | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2997 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dRow["p_time_zone"] | UserInfoContext.Current[UserInfoProperites.TimeZone] | 행/컬럼 값 대입 |  |  |  |
| AC-8b50090b | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2998 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dRow["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-2e0eace2 | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:2999 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dsInput.Tables[0].Rows.Add | (dRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-6f49d357 | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:3017 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | saveDS.Tables[0].NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-90380b28 | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:3018 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["A"] | action | 행/컬럼 값 대입 |  |  |  |
| AC-ccc17966 | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:3019 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_active_flag"] | action | 행/컬럼 값 대입 |  |  |  |
| AC-7ff2f06e | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:3020 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_division_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.DIVISION_ID)) | 행/컬럼 값 대입 |  |  |  |
| AC-daceb90c | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:3021 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-2102b39a | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:3022 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-7f1e6874 | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:3023 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-a321e379 | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:3024 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_biz_type"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.BIZ_TYPE)) | 행/컬럼 값 대입 |  |  |  |
| AC-3bc30efb | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:3025 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_project_code"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.PROJECT_CODE)) | 행/컬럼 값 대입 |  |  |  |
| AC-e25c6ff9 | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:3026 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_item_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.ITEM_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-b7d216cb | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:3028 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_to_site"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.TO_SITE)) | 행/컬럼 값 대입 |  |  |  |
| AC-dac6b20d | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:3029 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_incoterms"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.INCOTERMS)) | 행/컬럼 값 대입 |  |  |  |
| AC-31a944ad | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:3030 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_from_site"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.FROM_SITE)) | 행/컬럼 값 대입 |  |  |  |
| AC-221d59ac | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:3031 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_bod_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.BOD_ID)) | 행/컬럼 값 대입 |  |  |  |
| AC-54c87741 | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:3032 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_measure"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.MEASURE)) | 행/컬럼 값 대입 |  |  |  |
| AC-814fde4d | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:3035 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_yyyymmdd"] | yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-5b17d992 | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:3036 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_qty"] | strQty | 행/컬럼 값 대입 |  |  |  |
| AC-ec142d64 | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:3044 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_origin_from_division_id"] | org_from_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-c3ace2a2 | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:3051 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_origin_to_division_id"] | org_to_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-042c5075 | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:3058 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_electrode_type"] | elec_type | 행/컬럼 값 대입 |  |  |  |
| AC-88849dd2 | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:3060 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_created_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-e4db0177 | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:3061 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_last_updated_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-5de10379 | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:3062 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_time_zone"] | UserInfoContext.Current[UserInfoProperites.TimeZone] | 행/컬럼 값 대입 |  |  |  |
| AC-8ceac94e | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:3064 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | saveDS.Tables[0].Rows.Add | (dr) | 데이터 객체 조작/조회 |  |  |  |
| AC-2c1834d0 | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:3069 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dsInput.Tables[0].NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-a5d8f2d3 | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:3070 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dRow["A"] | action | 행/컬럼 값 대입 |  |  |  |
| AC-5c55f7a2 | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:3071 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dRow["p_active_flag"] | action | 행/컬럼 값 대입 |  |  |  |
| AC-9fa3e686 | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:3072 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dRow["p_division_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.DIVISION_ID)) | 행/컬럼 값 대입 |  |  |  |
| AC-4c17190a | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:3073 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dRow["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-a6c37b9a | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:3074 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dRow["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-88f5ac41 | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:3075 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dRow["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-b359c20e | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:3076 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dRow["p_biz_type"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.BIZ_TYPE)) | 행/컬럼 값 대입 |  |  |  |
| AC-8a2aebf8 | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:3077 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dRow["p_project_code"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.PROJECT_CODE)) | 행/컬럼 값 대입 |  |  |  |
| AC-f74a77c0 | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:3078 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dRow["p_item_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.ITEM_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-4fae03ef | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:3079 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dRow["p_to_site"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.TO_SITE)) | 행/컬럼 값 대입 |  |  |  |
| AC-a361ede7 | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:3080 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dRow["p_incoterms"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.INCOTERMS)) | 행/컬럼 값 대입 |  |  |  |
| AC-bd5d2adf | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:3081 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dRow["p_from_site"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.FROM_SITE)) | 행/컬럼 값 대입 |  |  |  |
| AC-996f4cb9 | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:3082 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dRow["p_bod_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.BOD_ID)) | 행/컬럼 값 대입 |  |  |  |
| AC-02803896 | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:3083 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dRow["p_measure"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.MEASURE)) | 행/컬럼 값 대입 |  |  |  |
| AC-e02abc5b | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:3084 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dRow["p_yyyymmdd"] | yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-e348fe4f | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:3085 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dRow["p_qty"] | strQty | 행/컬럼 값 대입 |  |  |  |
| AC-e32afc61 | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:3086 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dRow["p_origin_from_division_id"] | org_from_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-0d612701 | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:3087 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dRow["p_origin_to_division_id"] | org_to_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-29c67172 | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:3088 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dRow["p_electrode_type"] | elec_type | 행/컬럼 값 대입 |  |  |  |
| AC-bf443182 | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:3089 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dRow["p_created_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-cc422235 | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:3090 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dRow["p_last_updated_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-87d785f3 | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:3091 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dRow["p_time_zone"] | UserInfoContext.Current[UserInfoProperites.TimeZone] | 행/컬럼 값 대입 |  |  |  |
| AC-770c64ed | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:3092 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dRow["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-b6715128 | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:3093 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dsInput.Tables[0].Rows.Add | (dRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-222913d5 | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:3099 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | GRID_SET | saveDS.Tables[0].Rows[0]["p_first_row"] | "Y" | 그리드 속성/값 설정 |  |  |  |
| AC-557efce4 | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:3100 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | GRID_SET | saveDS.Tables[0].Rows[iCount - 1]["p_last_row"] | "Y" | 그리드 속성/값 설정 |  |  |  |
| AC-b9925e74 | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:3102 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | saveDS.Tables[0].AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-04362eb9 | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:3108 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (iCount > 0) | DATA_OP | dsInput.Tables[0].AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-9e4ada07 | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:3122 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (iCount > 0) ▸ try | CALL_EXT | sql.AddParameter | (SqlDbType.Structured, "@SCP0009", dsInput.Tables[0]) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3a0a8c57 | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:3123 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (iCount > 0) ▸ try | ENDPOINT | sql.ExcuteProcedure | ("dbo.SCP0009_SAVE_ANL_SHIPMENT_PLAN_FG_DATASET") ⇒ biz:AppService.GeneralRunProcedureCustomTable [procedure=dbo.SCP0009_SAVE_ANL_SH… | 엔드포인트 호출 |  |  |  |
| AC-df63eae2 | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:3126 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (iCount > 0) ▸ try | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-2e2aed40 | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:3131 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (iCount > 0) ▸ try ▸ if (result !… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { result.Rows[0]["result_cnt"].ToString() }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a384b084 | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:3140 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (iCount > 0) ▸ try ▸ else of (res… | MESSAGE | MessageHelper.GMessageBox | ("MSG00003", new object[] { ReErrorMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-32e275f3 | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:3149 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (iCount > 0) ▸ catch ((Exception … | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-7fede252 | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:3150 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (iCount > 0) ▸ catch ((Exception … | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f47ef916 | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:3156 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (iCount > 0) ▸ finally ▸ if (!prg… | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-e6b68e05 | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:3206 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-2aa6305c | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:3208 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-900a609c | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:3212 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-3e51f0df | SaveButton | SCP0058_Shipment_Plan_FG_JV.cs:3213 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## SCP0058_Shipment_Plan_FG_JV.SCM_SYS_LOG_BATCH

진입점: this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock(siMain.SheetName)) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ if (iCount > 0) ▸ try] / this.btnUnfix.Click [if (fps != null) ▸ else of (siMain.IsLock(siMain.SheetName)) ▸ if (MessageHelper.GMessageBox("MSG00016") == DialogResult.Yes) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ if (iCount > 0) ▸ try] / SaveButton [if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (iCount > 0) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9305f17e | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 2 | SCP0058_Shipment_Plan_FG_JV.cs:4498 | try | ENDPOINT | new FoxDataRequest | ("SCP.PR_SCM_SYS_LOG_BATCH") ⇒ SCP.PR_SCM_SYS_LOG_BATCH | 엔드포인트 요청 생성 |  |  |  |
| AC-41a5046d | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 2 | SCP0058_Shipment_Plan_FG_JV.cs:4499 | try | DATA_OP | request.Parameters["p_program_name"] | p_program_name | 행/컬럼 값 대입 |  |  |  |
| AC-dfc2682e | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 2 | SCP0058_Shipment_Plan_FG_JV.cs:4500 | try | DATA_OP | request.Parameters["p_log_type"] | p_log_type | 행/컬럼 값 대입 |  |  |  |
| AC-cd5c6bed | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 2 | SCP0058_Shipment_Plan_FG_JV.cs:4501 | try | DATA_OP | request.Parameters["p_log_count"] | p_log_count | 행/컬럼 값 대입 |  |  |  |
| AC-6fa9ffa3 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 2 | SCP0058_Shipment_Plan_FG_JV.cs:4502 | try | DATA_OP | request.Parameters["p_log_message"] | p_log_message | 행/컬럼 값 대입 |  |  |  |
| AC-b3320196 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 2 | SCP0058_Shipment_Plan_FG_JV.cs:4503 | try | DATA_OP | request.Parameters["p_description"] | p_description | 행/컬럼 값 대입 |  |  |  |
| AC-8b8553f1 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 2 | SCP0058_Shipment_Plan_FG_JV.cs:4504 | try | DATA_OP | request.Parameters["p_event_date"] | DateTime.Now | 행/컬럼 값 대입 |  |  |  |
| AC-474ef874 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 2 | SCP0058_Shipment_Plan_FG_JV.cs:4506 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## SCP0058_Shipment_Plan_FG_JV.Set_FixButtonEnabled

진입점: this.Load / cboPlanDate.SelectedIndexChanged / cboPlanType.SelectedIndexChanged / cboPlanSeq.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d717e389 | this.Load 외 3 | SCP0058_Shipment_Plan_FG_JV.cs:3770 | if (sPlanType.Equals("FN") \|\| sPlanType.Equals("TE")) | STATE | btnFix.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-1a7c7d66 | this.Load 외 3 | SCP0058_Shipment_Plan_FG_JV.cs:3771 | if (sPlanType.Equals("FN") \|\| sPlanType.Equals("TE")) | STATE | btnUnfix.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-f9288fce | this.Load 외 3 | SCP0058_Shipment_Plan_FG_JV.cs:3772 | if (sPlanType.Equals("FN") \|\| sPlanType.Equals("TE")) | STATE | btnNew.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-709677a6 | this.Load 외 3 | SCP0058_Shipment_Plan_FG_JV.cs:3779 | else of (sPlanType.Equals("FN") \|\| sPlanType.Equals("TE")) ▸ if (!string.IsNullOrEmpty(CString.GetCheckedListValue(dtPlanSeq, cboPlanSeq.C… | DATA_OP | dtPlanSeq.AsEnumerable().Select | (a => a.Field<int>("CODE")) | 데이터 객체 조작/조회 |  |  |  |
| AC-b5efef42 | this.Load 외 3 | SCP0058_Shipment_Plan_FG_JV.cs:3779 | else of (sPlanType.Equals("FN") \|\| sPlanType.Equals("TE")) ▸ if (!string.IsNullOrEmpty(CString.GetCheckedListValue(dtPlanSeq, cboPlanSeq.C… | DATA_OP | a.Field | ("CODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-6ce230d6 | this.Load 외 3 | SCP0058_Shipment_Plan_FG_JV.cs:3783 | else of (sPlanType.Equals("FN") \|\| sPlanType.Equals("TE")) ▸ if (!string.IsNullOrEmpty(CString.GetCheckedListValue(dtPlanSeq, cboPlanSeq.C… | STATE | btnFix.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-283f829b | this.Load 외 3 | SCP0058_Shipment_Plan_FG_JV.cs:3784 | else of (sPlanType.Equals("FN") \|\| sPlanType.Equals("TE")) ▸ if (!string.IsNullOrEmpty(CString.GetCheckedListValue(dtPlanSeq, cboPlanSeq.C… | STATE | btnUnfix.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-0d69a5e7 | this.Load 외 3 | SCP0058_Shipment_Plan_FG_JV.cs:3789 | else of (sPlanType.Equals("FN") \|\| sPlanType.Equals("TE")) ▸ if (!string.IsNullOrEmpty(CString.GetCheckedListValue(dtPlanSeq, cboPlanSeq.C… | STATE | btnFix.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-6099fb22 | this.Load 외 3 | SCP0058_Shipment_Plan_FG_JV.cs:3790 | else of (sPlanType.Equals("FN") \|\| sPlanType.Equals("TE")) ▸ if (!string.IsNullOrEmpty(CString.GetCheckedListValue(dtPlanSeq, cboPlanSeq.C… | STATE | btnUnfix.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-9b03832e | this.Load 외 3 | SCP0058_Shipment_Plan_FG_JV.cs:3791 | else of (sPlanType.Equals("FN") \|\| sPlanType.Equals("TE")) ▸ if (!string.IsNullOrEmpty(CString.GetCheckedListValue(dtPlanSeq, cboPlanSeq.C… | STATE | btnNew.Enabled | false | 컨트롤 상태 Enabled |  |  |  |

## SCP0058_Shipment_Plan_FG_JV.Set_FixCellColor

진입점: this.spdMain.CellClick [if ((e.Column == siMain.GetColumnIndex(DefMain.TRANSPORT_MODE) \|\| e.Column == siMain.GetColumnIndex(DefMain.FROM_SITE_NAME))…)] / this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock(siMain.SheetName)) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ if (iCount > 0) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Equals("S")) ▸ try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ if (dsBinding.Tables[2].Rows.Count > 0)] / this.btnUnfix.Click [if (fps != null) ▸ else of (siMain.IsLock(siMain.SheetName)) ▸ if (Messa…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-258f33ac | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… 외 6 | SCP0058_Shipment_Plan_FG_JV.cs:1640 |  | FLAG | dtFix | dsBinding.Tables[2] | 화면 필드/플래그 변경 |  |  |  |
| AC-44ed4823 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… 외 6 | SCP0058_Shipment_Plan_FG_JV.cs:1655 | for (nRow < siMain.ActiveSheet.Rows.Count) ▸ if (measure.Equals("SHIP_PLAN_AMEND")) | DATA_OP | dtFix.Select | ("key_idx='" + sKey_Idx + "' AND FROM_SITE='" + sFrom_site + "' AND incoterms='" + sIncote… | 데이터 객체 조작/조회 |  |  |  |
| AC-236ff28a | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… 외 6 | SCP0058_Shipment_Plan_FG_JV.cs:1662 | for (nRow < siMain.ActiveSheet.Rows.Count) ▸ if (measure.Equals("SHIP_PLAN_AMEND")) ▸ if (res.Count() > 0) ▸ foreach (DataRow dr in res) | GRID_STYLE | siMain.SetBGColor2 | (nRow, siMain.GetColumnIndex(sDay), nRow, siMain.GetColumnIndex(sDay), Color.FromArgb(188,… | 그리드 표시 설정 |  |  |  |
| AC-fe38b26a | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… 외 6 | SCP0058_Shipment_Plan_FG_JV.cs:1672 | for (nRow < siMain.ActiveSheet.Rows.Count) ▸ if (measure.Equals("SHIP_PLAN_AMEND")) ▸ if (res.Count() > 0) ▸ foreach (DataRow dr in res) ▸ f… | GRID_STYLE | siMain.SetBGColor2 | (nRow, iCol, nRow, iCol, Color.FromArgb(188, 229, 92)) | 그리드 표시 설정 |  |  |  |

## SCP0058_Shipment_Plan_FG_JV.Set_FPOperationColor

진입점: this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock(siMain.SheetName)) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ if (iCount > 0) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Equals("S")) ▸ try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ if (p_bucket.ToString() == BucketType.Daily \|\| chkAll.Checked)] / this.btnUnfix.Click [if (fps != null) ▸ else of (siMain.IsLock(siMain.SheetName)) ▸ if (MessageHelper.GMessageBox("MSG00016") == DialogResult.Yes) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ if (iCount > 0) ▸ try ▸ …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-14ece3be | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 5 | SCP0058_Shipment_Plan_FG_JV.cs:1786 | for (nRow < siMain.ActiveSheet.Rows.Count) ▸ if (siMain.ActiveSheet.GetText(nRow, siMain.GetColumnIndex(DefMain.MEASURE)).ToString() == "SHI… | GRID_STYLE | siMain.SetBGColor | (nRow, befCol, nRow, nCol - 1, Color.FromArgb(234, 234, 234)) | 그리드 표시 설정 |  |  |  |
| AC-73a9d25b | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 5 | SCP0058_Shipment_Plan_FG_JV.cs:1792 | for (nRow < siMain.ActiveSheet.Rows.Count) ▸ if (siMain.ActiveSheet.GetText(nRow, siMain.GetColumnIndex(DefMain.MEASURE)).ToString() == "SHI… | GRID_STYLE | siMain.SetBGColor | (nRow, befCol, nRow, nCol, Color.FromArgb(234, 234, 234)) | 그리드 표시 설정 |  |  |  |

## SCP0058_Shipment_Plan_FG_JV.Set_InsertColumnsFont

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-07f3ba1f | (진입점 미연결) | SCP0058_Shipment_Plan_FG_JV.cs:2529 | if (bBold) | UI_PROP | range1.Font | new System.Drawing.Font(spdMain.Font.Name, spdMain.Font.Size, FontStyle.Bold) | 속성 Font 설정 |  |  |  |
| AC-99f70cb5 | (진입점 미연결) | SCP0058_Shipment_Plan_FG_JV.cs:2533 | else of (bBold) | UI_PROP | range1.Font | new System.Drawing.Font(spdMain.Font.Name, spdMain.Font.Size, FontStyle.Regular) | 속성 Font 설정 |  |  |  |

## SCP0058_Shipment_Plan_FG_JV.Set_SumValues

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-44f6aba1 | (진입점 미연결) | SCP0058_Shipment_Plan_FG_JV.cs:1915 | for (iRow < dsBinding.Tables[0].Rows.Count) ▸ for (iCol < dsBinding.Tables[0].Columns.Count) ▸ if (colName.IndexOf("M_") == 0) ▸ if (bef_mon… | GRID_SET | dsBinding.Tables[0].Rows[iRow][bef_month_idx] | sum_month | 그리드 속성/값 설정 |  |  |  |
| AC-a03baf1e | (진입점 미연결) | SCP0058_Shipment_Plan_FG_JV.cs:1925 | for (iRow < dsBinding.Tables[0].Rows.Count) ▸ for (iCol < dsBinding.Tables[0].Columns.Count) ▸ if (colName.IndexOf("M_") == 0) ▸ if (bef_mon… | GRID_SET | dsBinding.Tables[0].Rows[iRow][bef_month_idx] | qty | 그리드 속성/값 설정 |  |  |  |
| AC-2b299ac8 | (진입점 미연결) | SCP0058_Shipment_Plan_FG_JV.cs:1937 | for (iRow < dsBinding.Tables[0].Rows.Count) ▸ for (iCol < dsBinding.Tables[0].Columns.Count) ▸ else of (colName.IndexOf("M_") == 0) ▸ if (co… | GRID_SET | dsBinding.Tables[0].Rows[iRow][bef_week_idx] | sum_week | 그리드 속성/값 설정 |  |  |  |
| AC-309c92ad | (진입점 미연결) | SCP0058_Shipment_Plan_FG_JV.cs:1947 | for (iRow < dsBinding.Tables[0].Rows.Count) ▸ for (iCol < dsBinding.Tables[0].Columns.Count) ▸ else of (colName.IndexOf("M_") == 0) ▸ if (co… | GRID_SET | dsBinding.Tables[0].Rows[iRow][bef_week_idx] | qty | 그리드 속성/값 설정 |  |  |  |
| AC-6fb6e1ee | (진입점 미연결) | SCP0058_Shipment_Plan_FG_JV.cs:1968 | for (iRow < dsBinding.Tables[0].Rows.Count) ▸ for (iCol < dsBinding.Tables[0].Columns.Count) ▸ else of (colName.IndexOf("M_") == 0) ▸ else o… | GRID_SET | dsBinding.Tables[0].Rows[iRow][bef_week_idx] | sum_week | 그리드 속성/값 설정 |  |  |  |
| AC-0b2afc97 | (진입점 미연결) | SCP0058_Shipment_Plan_FG_JV.cs:1969 | for (iRow < dsBinding.Tables[0].Rows.Count) ▸ for (iCol < dsBinding.Tables[0].Columns.Count) ▸ else of (colName.IndexOf("M_") == 0) ▸ else o… | GRID_SET | dsBinding.Tables[0].Rows[iRow][bef_month_idx] | sum_month | 그리드 속성/값 설정 |  |  |  |
| AC-563df97d | (진입점 미연결) | SCP0058_Shipment_Plan_FG_JV.cs:1976 | for (iRow < dsBinding.Tables[0].Rows.Count) ▸ for (iCol < dsBinding.Tables[0].Columns.Count) ▸ else of (colName.IndexOf("M_") == 0) ▸ else o… | GRID_SET | dsBinding.Tables[0].Rows[iRow][bef_week_idx] | qty | 그리드 속성/값 설정 |  |  |  |
| AC-ffa37812 | (진입점 미연결) | SCP0058_Shipment_Plan_FG_JV.cs:1977 | for (iRow < dsBinding.Tables[0].Rows.Count) ▸ for (iCol < dsBinding.Tables[0].Columns.Count) ▸ else of (colName.IndexOf("M_") == 0) ▸ else o… | GRID_SET | dsBinding.Tables[0].Rows[iRow][bef_month_idx] | qty | 그리드 속성/값 설정 |  |  |  |
| AC-a139434b | (진입점 미연결) | SCP0058_Shipment_Plan_FG_JV.cs:1985 | for (iRow < dsBinding.Tables[0].Rows.Count) ▸ for (iCol < dsBinding.Tables[0].Columns.Count) ▸ else of (colName.IndexOf("M_") == 0) ▸ else o… | GRID_SET | dsBinding.Tables[0].Rows[iRow][bef_week_idx] | sum_week | 그리드 속성/값 설정 |  |  |  |
| AC-18834ce8 | (진입점 미연결) | SCP0058_Shipment_Plan_FG_JV.cs:1986 | for (iRow < dsBinding.Tables[0].Rows.Count) ▸ for (iCol < dsBinding.Tables[0].Columns.Count) ▸ else of (colName.IndexOf("M_") == 0) ▸ else o… | GRID_SET | dsBinding.Tables[0].Rows[iRow][bef_month_idx] | sum_month | 그리드 속성/값 설정 |  |  |  |
| AC-b5397b05 | (진입점 미연결) | SCP0058_Shipment_Plan_FG_JV.cs:1993 | for (iRow < dsBinding.Tables[0].Rows.Count) ▸ for (iCol < dsBinding.Tables[0].Columns.Count) ▸ else of (colName.IndexOf("M_") == 0) ▸ else o… | GRID_SET | dsBinding.Tables[0].Rows[iRow][bef_week_idx] | qty | 그리드 속성/값 설정 |  |  |  |
| AC-13ebd4e9 | (진입점 미연결) | SCP0058_Shipment_Plan_FG_JV.cs:1994 | for (iRow < dsBinding.Tables[0].Rows.Count) ▸ for (iCol < dsBinding.Tables[0].Columns.Count) ▸ else of (colName.IndexOf("M_") == 0) ▸ else o… | GRID_SET | dsBinding.Tables[0].Rows[iRow][bef_month_idx] | qty | 그리드 속성/값 설정 |  |  |  |

## SCP0058_Shipment_Plan_FG_JV.SetChangedControl

진입점: this.Load / cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-246a6bd7 | this.Load 외 1 | SCP0058_Shipment_Plan_FG_JV.cs:576 | if (dic_JV_Plant.Count == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-24f3e826 | this.Load 외 1 | SCP0058_Shipment_Plan_FG_JV.cs:578 |  | FLAG | dtFromSiteCpyTmp | new DataTable() | 화면 필드/플래그 변경 |  |  |  |
| AC-0cb48e90 | this.Load 외 1 | SCP0058_Shipment_Plan_FG_JV.cs:579 |  | FLAG | dtFromSiteCpy | null | 화면 필드/플래그 변경 |  |  |  |
| AC-08872b13 | this.Load 외 1 | SCP0058_Shipment_Plan_FG_JV.cs:583 |  | FLAG | dtFromSite | Data_SCP.Common(Data_SCP.Type.AllPlantSiteDescription, false, "", "") | 화면 필드/플래그 변경 |  |  |  |
| AC-a2da9dff | this.Load 외 1 | SCP0058_Shipment_Plan_FG_JV.cs:583 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.AllPlantSiteDescription, false, "", "") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-762e9f92 | this.Load 외 1 | SCP0058_Shipment_Plan_FG_JV.cs:600 | if (!this._division.Substring(0, 2).Equals("EE")) | VALUE_CLEAR | clbElecType.ControlValues | "" | 컨트롤 값 비움 |  |  |  |
| AC-f11c24e3 | this.Load 외 1 | SCP0058_Shipment_Plan_FG_JV.cs:601 | if (!this._division.Substring(0, 2).Equals("EE")) | STATE | clbElecType.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-09ada112 | this.Load 외 1 | SCP0058_Shipment_Plan_FG_JV.cs:605 | else of (!this._division.Substring(0, 2).Equals("EE")) | STATE | clbElecType.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-d7f5b450 | this.Load 외 1 | SCP0058_Shipment_Plan_FG_JV.cs:612 |  | VALUE_SET | btnWLast.Text | "W" + dailyPlanPeriod | 컨트롤 값 설정 |  |  |  |

## SCP0058_Shipment_Plan_FG_JV.SetDataTableQtyData

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c40cd3f7 | (진입점 미연결) | SCP0058_Shipment_Plan_FG_JV.cs:775 | for (i < source.Rows.Count) ▸ for (j < source.Columns.Count) ▸ if (columnName.IndexOf("D_") == 0) | GRID_SET | target.Rows[i][columnName] | source.Rows[i][columnName] | 그리드 속성/값 설정 |  |  |  |
| AC-99950101 | (진입점 미연결) | SCP0058_Shipment_Plan_FG_JV.cs:781 |  | DATA_OP | target.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |

## SCP0058_Shipment_Plan_FG_JV.SetFromSite

진입점: cboBizType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-65e5f159 | cboBizType.SelectedIndexChanged | SCP0058_Shipment_Plan_FG_JV.cs:3480 | if (dic_JV_Plant.Count == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0058_Shipment_Plan_FG_JV.SetOperationGroupByDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ee41b9ee | (진입점 미연결) | SCP0058_Shipment_Plan_FG_JV.cs:3996 | if (!this._division.Substring(0, 2).Equals("EE")) | FLAG | dtOperGrp | Data_SCP.Common(Data_SCP.Type.OperationGroup, false) | 화면 필드/플래그 변경 |  |  |  |
| AC-59a8363f | (진입점 미연결) | SCP0058_Shipment_Plan_FG_JV.cs:3996 | if (!this._division.Substring(0, 2).Equals("EE")) | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.OperationGroup, false) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-203a6eb8 | (진입점 미연결) | SCP0058_Shipment_Plan_FG_JV.cs:4000 | else of (!this._division.Substring(0, 2).Equals("EE")) | FLAG | dtOperGrp | Data_SCP.Common(Data_SCP.Type.OperationGroupEE, false) | 화면 필드/플래그 변경 |  |  |  |
| AC-d8fcf9f4 | (진입점 미연결) | SCP0058_Shipment_Plan_FG_JV.cs:4000 | else of (!this._division.Substring(0, 2).Equals("EE")) | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.OperationGroupEE, false) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-1a0f58bf | (진입점 미연결) | SCP0058_Shipment_Plan_FG_JV.cs:4003 |  | LIST_REBIND | clsCtrl.setListBox | (dtOperGrp, cboBizType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0058_Shipment_Plan_FG_JV.SetSpreadColumn

진입점: this.chkSum.CheckedChanged [if (siMain != null)] / this.Load / this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >= 0) ▸ if (siMain.GetValue(e.Row, siMain.GetColumnIndex(DefMain.MEASURE)).ToString().Equals("MKT_FCST")) ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / this.cboBucketType.SelectedIndexChanged [if (chkAll.Checked) ▸ if (siMain != null)] / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock(siMain.SheetName)) ▸ if (fps.Name == "spdMain") ▸ if (siMain != n…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4b36026f | this.chkSum.CheckedChanged [if (siMain != null)] 외 10 | SCP0058_Shipment_Plan_FG_JV.cs:3891 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Daily) ▸ if (siObj.GetColumnTag(iCol).IndexOf("D_") … | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-6d16952f | this.chkSum.CheckedChanged [if (siMain != null)] 외 10 | SCP0058_Shipment_Plan_FG_JV.cs:3896 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Daily) ▸ if (siObj.GetColumnTag(iCol).IndexOf("M_") … | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | chkSum.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-ca5e8fc8 | this.chkSum.CheckedChanged [if (siMain != null)] 외 10 | SCP0058_Shipment_Plan_FG_JV.cs:3903 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Buc… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-67d2cdae | this.chkSum.CheckedChanged [if (siMain != null)] 외 10 | SCP0058_Shipment_Plan_FG_JV.cs:3907 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Buc… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-3ae0729c | this.chkSum.CheckedChanged [if (siMain != null)] 외 10 | SCP0058_Shipment_Plan_FG_JV.cs:3912 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Buc… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | chkSum.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-a000a00a | this.chkSum.CheckedChanged [if (siMain != null)] 외 10 | SCP0058_Shipment_Plan_FG_JV.cs:3919 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ else of (cboBucketType.ControlValues =… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-2bbbe1bd | this.chkSum.CheckedChanged [if (siMain != null)] 외 10 | SCP0058_Shipment_Plan_FG_JV.cs:3923 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ else of (cboBucketType.ControlValues =… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |

## SCP0058_Shipment_Plan_FG_JV.SpdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4af67f51 | this.spdMain.CellClick | SCP0058_Shipment_Plan_FG_JV.cs:1212 | if (siMain.IsLock(siMain.SheetName)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0058_Shipment_Plan_FG_JV.SpdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6dcbd362 | this.spdMain.CellDoubleClick | SCP0058_Shipment_Plan_FG_JV.cs:3553 | if (!chkAll.Checked) ▸ if ((siMain.GetColumnTag(e.Column).IndexOf("M_") == 0 && BucketType.Monthly == sBucketType) \|\| (siMain.GetColumnTag… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-77b87fd1 | this.spdMain.CellDoubleClick | SCP0058_Shipment_Plan_FG_JV.cs:3556 |  | CALL_EXT | siMain.SetDblClickColumnShowHide | (sender, e) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ae663c8b | this.spdMain.CellDoubleClick | SCP0058_Shipment_Plan_FG_JV.cs:3561 | if (e.Column < siMain.nIdxData \|\| siMain.GetColumnTag(e.Column).IndexOf("M_") == 0 \|\| siMain.GetColumnTag(e.Column).IndexOf(…) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5982215d | this.spdMain.CellDoubleClick | SCP0058_Shipment_Plan_FG_JV.cs:3566 | if (siMain.GetColumnTag(e.Column).IndexOf("D_") != 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0058_Shipment_Plan_FG_JV.SpdMain_KeyUp

진입점: this.spdMain.KeyUp

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-11e60172 | this.spdMain.KeyUp | SCP0058_Shipment_Plan_FG_JV.cs:1189 | if (siMain.GetColumnIndex(DefMain.MEASURE) >= siMain.ActiveColumnIndex) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-57b07579 | this.spdMain.KeyUp | SCP0058_Shipment_Plan_FG_JV.cs:1193 | if (e.Control == true && e.KeyCode == Keys.V \|\| e.Control == false && e.KeyCode == Keys.V) | CALL_EXT | spdMain.ActiveSheet.ClipboardPaste | (ClipboardPasteOptions.AsStringSkipHidden) | ⚠ 의미 확인 필요 |  |  |  |
| AC-7c36786d | this.spdMain.KeyUp | SCP0058_Shipment_Plan_FG_JV.cs:1198 | if (e.Control == true && e.KeyCode == Keys.C \|\| e.Control == false && e.KeyCode == Keys.C) | CALL_EXT | Clipboard.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-8ca21aed | this.spdMain.KeyUp | SCP0058_Shipment_Plan_FG_JV.cs:1199 | if (e.Control == true && e.KeyCode == Keys.C \|\| e.Control == false && e.KeyCode == Keys.C) | CALL_EXT | spdMain.Sheets[0].ClipboardCopy | (ClipboardCopyOptions.AsStringSkipHidden) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0058_Shipment_Plan_FG_JV.SpdMain_TopChange

진입점: this.spdMain.CellClick [if ((e.Column == siMain.GetColumnIndex(DefMain.TRANSPORT_MODE) \|\| e.Column == siMain.GetColumnIndex(DefMain.FROM_SITE_NAME))…)] / this.spdMain.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-929425ed | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… 외 1 | SCP0058_Shipment_Plan_FG_JV.cs:1206 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0058_Shipment_Plan_FG_JV.TotalCellsMerge

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f02e3978 | (진입점 미연결) | SCP0058_Shipment_Plan_FG_JV.cs:1806 |  | DATA_OP | list.Add | (siMain.GetColumnIndex(DefMain.FROM_SITE_NAME)) | 데이터 객체 조작/조회 |  |  |  |
| AC-fcbc6410 | (진입점 미연결) | SCP0058_Shipment_Plan_FG_JV.cs:1807 |  | DATA_OP | list.Add | (siMain.GetColumnIndex(DefMain.TRANSPORT_MODE)) | 데이터 객체 조작/조회 |  |  |  |
| AC-3ded101c | (진입점 미연결) | SCP0058_Shipment_Plan_FG_JV.cs:1808 |  | DATA_OP | list.Add | (siMain.GetColumnIndex(DefMain.LT_DAY)) | 데이터 객체 조작/조회 |  |  |  |
| AC-13c5ac80 | (진입점 미연결) | SCP0058_Shipment_Plan_FG_JV.cs:1833 | for (iRow <= siMain.GetMaxRowIndex()) ▸ if (cur_key_idx != bef_key_idx) ▸ foreach (int idx in list) | UI_PROP | range.HorizontalAlignment | CellHorizontalAlignment.Center | 속성 HorizontalAlignment 설정 |  |  |  |
| AC-c1e5dbff | (진입점 미연결) | SCP0058_Shipment_Plan_FG_JV.cs:1834 | for (iRow <= siMain.GetMaxRowIndex()) ▸ if (cur_key_idx != bef_key_idx) ▸ foreach (int idx in list) | UI_PROP | range.ForeColor | Color.Black | 속성 ForeColor 설정 |  |  |  |
| AC-cb820143 | (진입점 미연결) | SCP0058_Shipment_Plan_FG_JV.cs:1835 | for (iRow <= siMain.GetMaxRowIndex()) ▸ if (cur_key_idx != bef_key_idx) ▸ foreach (int idx in list) | UI_PROP | range.RowSpan | rowSpan_Count | 속성 RowSpan 설정 |  |  |  |
| AC-265e6bfe | (진입점 미연결) | SCP0058_Shipment_Plan_FG_JV.cs:1839 | for (iRow <= siMain.GetMaxRowIndex()) ▸ if (cur_key_idx != bef_key_idx) | UI_PROP | boh.HorizontalAlignment | CellHorizontalAlignment.Center | 속성 HorizontalAlignment 설정 |  |  |  |
| AC-e8a36d5b | (진입점 미연결) | SCP0058_Shipment_Plan_FG_JV.cs:1840 | for (iRow <= siMain.GetMaxRowIndex()) ▸ if (cur_key_idx != bef_key_idx) | UI_PROP | boh.RowSpan | bohSpan_Count | 속성 RowSpan 설정 |  |  |  |
| AC-b7888cdd | (진입점 미연결) | SCP0058_Shipment_Plan_FG_JV.cs:1870 | for (iRow <= siMain.GetMaxRowIndex()) ▸ if (iRow == siMain.GetMaxRowIndex()) ▸ if (isSum) ▸ foreach (int idx in list) | UI_PROP | range.HorizontalAlignment | CellHorizontalAlignment.Center | 속성 HorizontalAlignment 설정 |  |  |  |
| AC-b13dc7d9 | (진입점 미연결) | SCP0058_Shipment_Plan_FG_JV.cs:1871 | for (iRow <= siMain.GetMaxRowIndex()) ▸ if (iRow == siMain.GetMaxRowIndex()) ▸ if (isSum) ▸ foreach (int idx in list) | UI_PROP | range.ForeColor | Color.Black | 속성 ForeColor 설정 |  |  |  |
| AC-4db9cb8e | (진입점 미연결) | SCP0058_Shipment_Plan_FG_JV.cs:1872 | for (iRow <= siMain.GetMaxRowIndex()) ▸ if (iRow == siMain.GetMaxRowIndex()) ▸ if (isSum) ▸ foreach (int idx in list) | UI_PROP | range.RowSpan | rowSpan_Count | 속성 RowSpan 설정 |  |  |  |
| AC-85afb296 | (진입점 미연결) | SCP0058_Shipment_Plan_FG_JV.cs:1876 | for (iRow <= siMain.GetMaxRowIndex()) ▸ if (iRow == siMain.GetMaxRowIndex()) ▸ if (isSum) | UI_PROP | boh.HorizontalAlignment | CellHorizontalAlignment.Center | 속성 HorizontalAlignment 설정 |  |  |  |
| AC-1569afa7 | (진입점 미연결) | SCP0058_Shipment_Plan_FG_JV.cs:1877 | for (iRow <= siMain.GetMaxRowIndex()) ▸ if (iRow == siMain.GetMaxRowIndex()) ▸ if (isSum) | UI_PROP | boh.RowSpan | bohSpan_Count | 속성 RowSpan 설정 |  |  |  |

## SCP0058_Shipment_Plan_FG_JV.ValidateUserInput

진입점: SaveButton [if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (iRow < siMain.ActiveSheet.Rows.Count) ▸ if (action == CAppSetting.FlagI && measure_name.Equals("SHIP_PLAN_AMEND")) ▸ for (iCol < siMain.GetMaxColumnIndex()) ▸ if (!string.IsNullOrEmpty(val)) ▸ if (nDayQty < 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ffd8bb68 | SaveButton [if (fps.Name == spdMain.Name) ▸ if (siMain != nu… | SCP0058_Shipment_Plan_FG_JV.cs:3230 | if (action_name.Equals("NO_DATA")) ▸ if (siMain.ActiveSheet.RowCount <= 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00059") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-44011aca | SaveButton [if (fps.Name == spdMain.Name) ▸ if (siMain != nu… | SCP0058_Shipment_Plan_FG_JV.cs:3237 | else of (action_name.Equals("NO_DATA")) ▸ if (action_name.Equals("NO_CHECKED")) | MESSAGE | MessageHelper.GMessageBox | ("MSG00017") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c1867df6 | SaveButton [if (fps.Name == spdMain.Name) ▸ if (siMain != nu… | SCP0058_Shipment_Plan_FG_JV.cs:3251 | else of (action_name.Equals("NO_DATA")) ▸ else of (action_name.Equals("NO_CHECKED")) ▸ if (action_name.Equals("CHK_PERIOD")) ▸ if (DateTime.… | MESSAGE | MessageHelper.GMessageBox | ("MSG00171") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-5ef7f047 | SaveButton [if (fps.Name == spdMain.Name) ▸ if (siMain != nu… | SCP0058_Shipment_Plan_FG_JV.cs:3253 | else of (action_name.Equals("NO_DATA")) ▸ else of (action_name.Equals("NO_CHECKED")) ▸ if (action_name.Equals("CHK_PERIOD")) ▸ if (DateTime.… | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |
| AC-001766ac | SaveButton [if (fps.Name == spdMain.Name) ▸ if (siMain != nu… | SCP0058_Shipment_Plan_FG_JV.cs:3259 | else of (action_name.Equals("NO_DATA")) ▸ else of (action_name.Equals("NO_CHECKED")) ▸ if (action_name.Equals("CHK_PERIOD")) ▸ if (diff.Days… | MESSAGE | MessageHelper.GMessageBox | ("MSG00172", new object[] { 364 }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ce38595b | SaveButton [if (fps.Name == spdMain.Name) ▸ if (siMain != nu… | SCP0058_Shipment_Plan_FG_JV.cs:3267 | else of (action_name.Equals("NO_DATA")) ▸ else of (action_name.Equals("NO_CHECKED")) ▸ else of (action_name.Equals("CHK_PERIOD")) ▸ if (acti… | MESSAGE | MessageHelper.GMessageBox | ("MSG00084") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-351a1230 | SaveButton [if (fps.Name == spdMain.Name) ▸ if (siMain != nu… | SCP0058_Shipment_Plan_FG_JV.cs:3274 | else of (action_name.Equals("NO_DATA")) ▸ else of (action_name.Equals("NO_CHECKED")) ▸ else of (action_name.Equals("CHK_PERIOD")) ▸ else of … | MESSAGE | MessageHelper.GMessageBox | ("MSG00233") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9cd6c82e | SaveButton [if (fps.Name == spdMain.Name) ▸ if (siMain != nu… | SCP0058_Shipment_Plan_FG_JV.cs:3280 | else of (action_name.Equals("NO_DATA")) ▸ else of (action_name.Equals("NO_CHECKED")) ▸ else of (action_name.Equals("CHK_PERIOD")) ▸ else of … | MESSAGE | MessageHelper.GMessageBox | ("MSG00317", new object[] { "100,000,000" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-4edc22d6 | SaveButton [if (fps.Name == spdMain.Name) ▸ if (siMain != nu… | SCP0058_Shipment_Plan_FG_JV.cs:3283 |  | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |

