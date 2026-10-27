# AS-IS 액션 대조표 — SCP0009

> 원천: `Doc/asisfacts/screens/SCP0009/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 1014행 · 메서드 69 · 종류 DATA_OP 512 · RETURN 64 · GRID_SET 60 · UI_PROP 51 · CALL_EXT 40 · FLAG 39 · MESSAGE 34 · GRID_INIT 30 · UI_MISC 28 · ENDPOINT 28 · POPUP 26 · GRID_LOCK 17 · LIST_REBIND 16 · VALUE_SET 14 · COMBO_DATA 13 · STATE 12 · GRID_CLEAR 10 · GRID_STYLE 8 · GRID_BIND 4 · VALIDATE 3 · LIST_CLEAR 2 · THROW 1 · STATE_RESET 1 · VALUE_CLEAR 1 · ⚠ 의미 확인 필요 40


## SCP0009_Shipment_Plan_FG.BlockCellsChecking

진입점: this.spdMain.CellClick [if ((e.Column == siMain.GetColumnIndex(DefMain.TRANSPORT_MODE) \|\| e.Column == siMain.GetColumnIndex(DefMain.FROM_SITE_NAME))…)] / EditButton [if (fps != null) ▸ if (this.IsEditMode && cboBucketType.ControlValues != BucketType.Monthly) ▸ if (EditBlockChecking(2) != 1)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9e33273a | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… 외 1 | SCP0009_Shipment_Plan_FG.cs:2353 | for (iRow < siMain.ActiveSheet.Rows.Count) ▸ if (siMain.GetValue(iRow, measure_idx).ToString().Equals("SHIP_PLAN_AMEND")) ▸ if (cboBucketTyp… | GRID_LOCK | siMain.LockRange | (iRow, 1, iRow, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-82b7579d | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… 외 1 | SCP0009_Shipment_Plan_FG.cs:2364 | for (iRow < siMain.ActiveSheet.Rows.Count) ▸ if (siMain.GetValue(iRow, measure_idx).ToString().Equals("SHIP_PLAN_AMEND")) ▸ else of (cboBuck… | GRID_LOCK | siMain.LockRange | (iRow, 1, iRow, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-3bb0c295 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… 외 1 | SCP0009_Shipment_Plan_FG.cs:2389 | for (iRow < siMain.ActiveSheet.Rows.Count) ▸ if (siMain.GetValue(iRow, measure_idx).ToString().Equals("SHIP_PLAN_AMEND")) ▸ else of (cboBuck… | CALL_EXT | frozenDate.CompareTo | (dtBodTo) | ⚠ 의미 확인 필요 |  |  |  |
| AC-0bcf895d | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… 외 1 | SCP0009_Shipment_Plan_FG.cs:2393 | for (iRow < siMain.ActiveSheet.Rows.Count) ▸ if (siMain.GetValue(iRow, measure_idx).ToString().Equals("SHIP_PLAN_AMEND")) ▸ else of (cboBuck… | CALL_EXT | dtBodFrom.CompareTo | (frozenDate) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b2e25d26 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… 외 1 | SCP0009_Shipment_Plan_FG.cs:2401 | for (iRow < siMain.ActiveSheet.Rows.Count) ▸ if (siMain.GetValue(iRow, measure_idx).ToString().Equals("SHIP_PLAN_AMEND")) ▸ else of (cboBuck… | CALL_EXT | frozenDate.CompareTo | (dtBodFrom) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c48b1aa4 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… 외 1 | SCP0009_Shipment_Plan_FG.cs:2401 | for (iRow < siMain.ActiveSheet.Rows.Count) ▸ if (siMain.GetValue(iRow, measure_idx).ToString().Equals("SHIP_PLAN_AMEND")) ▸ else of (cboBuck… | CALL_EXT | dtBodTo.CompareTo | (frozenDate) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f0a87b36 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… 외 1 | SCP0009_Shipment_Plan_FG.cs:2421 | for (iRow < siMain.ActiveSheet.Rows.Count) ▸ if (siMain.GetValue(iRow, measure_idx).ToString().Equals("SHIP_PLAN_AMEND")) ▸ else of (cboBuck… | DATA_OP | lstBlockWeek_Month.Add | (iCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-afc0eac1 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… 외 1 | SCP0009_Shipment_Plan_FG.cs:2441 | for (iRow < siMain.ActiveSheet.Rows.Count) ▸ if (siMain.GetValue(iRow, measure_idx).ToString().Equals("SHIP_PLAN_AMEND")) ▸ else of (cboBuck… | GRID_LOCK | siMain.LockRange | (iRow, 1, iRow, nBlockColumnEnd, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-94352d1b | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… 외 1 | SCP0009_Shipment_Plan_FG.cs:2442 | for (iRow < siMain.ActiveSheet.Rows.Count) ▸ if (siMain.GetValue(iRow, measure_idx).ToString().Equals("SHIP_PLAN_AMEND")) ▸ else of (cboBuck… | GRID_LOCK | siMain.LockRange | (iRow, nBlockColumnEnd + 1, iRow, siMain.GetMaxColumnIndex(), false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-ee909976 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… 외 1 | SCP0009_Shipment_Plan_FG.cs:2446 | for (iRow < siMain.ActiveSheet.Rows.Count) ▸ if (siMain.GetValue(iRow, measure_idx).ToString().Equals("SHIP_PLAN_AMEND")) ▸ else of (cboBuck… | GRID_LOCK | siMain.LockRange | (iRow, 1, iRow, nBlockColumnEnd, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-de30d67e | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… 외 1 | SCP0009_Shipment_Plan_FG.cs:2447 | for (iRow < siMain.ActiveSheet.Rows.Count) ▸ if (siMain.GetValue(iRow, measure_idx).ToString().Equals("SHIP_PLAN_AMEND")) ▸ else of (cboBuck… | GRID_LOCK | siMain.LockRange | (iRow, nBlockColumnEnd + 1, iRow, iBlockLastIdx, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-c09407ab | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… 외 1 | SCP0009_Shipment_Plan_FG.cs:2448 | for (iRow < siMain.ActiveSheet.Rows.Count) ▸ if (siMain.GetValue(iRow, measure_idx).ToString().Equals("SHIP_PLAN_AMEND")) ▸ else of (cboBuck… | GRID_LOCK | siMain.LockRange | (iRow, iBlockLastIdx + 1, iRow, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-82d03d90 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… 외 1 | SCP0009_Shipment_Plan_FG.cs:2493 | for (iRow < siMain.ActiveSheet.Rows.Count) ▸ if (siMain.GetValue(iRow, measure_idx).ToString().Equals("SHIP_PLAN_AMEND")) ▸ else of (cboBuck… | GRID_LOCK | siMain.LockRange | (0, iCol, siMain.ActiveSheet.RowCount - 1, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-74e2feb2 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… 외 1 | SCP0009_Shipment_Plan_FG.cs:2508 | for (iRow < siMain.ActiveSheet.Rows.Count) ▸ if (siMain.GetValue(iRow, measure_idx).ToString().Equals("SHIP_PLAN_AMEND")) ▸ else of (cboBuck… | GRID_LOCK | siMain.LockRange | (0, iCol, siMain.ActiveSheet.RowCount - 1, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-2f70e8ad | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… 외 1 | SCP0009_Shipment_Plan_FG.cs:2563 | for (iRow < siMain.ActiveSheet.Rows.Count) ▸ else of (siMain.GetValue(iRow, measure_idx).ToString().Equals("SHIP_PLAN_AMEND")) | GRID_LOCK | siMain.LockRange | (iRow, 1, iRow, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |

## SCP0009_Shipment_Plan_FG.BtnColumn_Click

진입점: this.btnColumn.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e8ff5972 | this.btnColumn.Click | SCP0009_Shipment_Plan_FG.cs:987 |  | POPUP | new SCM0002_TitleSetForm_Popup | ("SCP0009", SpdSheet.shtMain, true) | 팝업/폼 생성 |  |  |  |
| AC-9f547f8b | this.btnColumn.Click | SCP0009_Shipment_Plan_FG.cs:988 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-696df73e | this.btnColumn.Click | SCP0009_Shipment_Plan_FG.cs:989 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## SCP0009_Shipment_Plan_FG.BtnFix_Click

진입점: this.btnFix.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d326c068 | this.btnFix.Click | SCP0009_Shipment_Plan_FG.cs:1044 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e8fa7417 | this.btnFix.Click | SCP0009_Shipment_Plan_FG.cs:1045 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3b944878 | this.btnFix.Click | SCP0009_Shipment_Plan_FG.cs:1050 | if (fps != null) ▸ if (dsBinding.Tables.Count == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8f14632a | this.btnFix.Click | SCP0009_Shipment_Plan_FG.cs:1053 | if (fps != null) ▸ if (siMain.IsLock(siMain.SheetName)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00010") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-758a7761 | this.btnFix.Click | SCP0009_Shipment_Plan_FG.cs:1056 | if (fps != null) ▸ else of (siMain.IsLock(siMain.SheetName)) ▸ if (!Get_IsSaveYn()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0009_Shipment_Plan_FG.BtnItem_Id_Click

진입점: this.btnItem_Id.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0381e3f3 | this.btnItem_Id.Click | SCP0009_Shipment_Plan_FG.cs:4167 |  | CALL_EXT | UIUtils.GetAllDivisionChecked | (cboDivision) | ⚠ 의미 확인 필요 |  |  |  |
| AC-03dcf4d0 | this.btnItem_Id.Click | SCP0009_Shipment_Plan_FG.cs:4169 |  | POPUP | new SCM0002_ItembyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-7866e96f | this.btnItem_Id.Click | SCP0009_Shipment_Plan_FG.cs:4171 |  | POPUP | popItem.Form_Load | (true, division, sScmSite, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-5d635f1f | this.btnItem_Id.Click | SCP0009_Shipment_Plan_FG.cs:4172 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-7a4993c3 | this.btnItem_Id.Click | SCP0009_Shipment_Plan_FG.cs:4173 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-bc739f45 | this.btnItem_Id.Click | SCP0009_Shipment_Plan_FG.cs:4178 | if (popItem.ItemID != "") | VALUE_SET | txtItem_Id.Text | sItemId | 컨트롤 값 설정 |  |  |  |

## SCP0009_Shipment_Plan_FG.btnMeasure_Click

진입점: this.btnMeasure.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e85dab1e | this.btnMeasure.Click | SCP0009_Shipment_Plan_FG.cs:4204 |  | POPUP | new SCM0002_TitleSetForm_Popup | ("SCP0009", measure, false) | 팝업/폼 생성 |  |  |  |
| AC-121f0396 | this.btnMeasure.Click | SCP0009_Shipment_Plan_FG.cs:4205 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-46119202 | this.btnMeasure.Click | SCP0009_Shipment_Plan_FG.cs:4206 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-c3d47dcb | this.btnMeasure.Click | SCP0009_Shipment_Plan_FG.cs:4209 | if (frm.DialogResult == DialogResult.OK) | UI_PROP | this.CanModelChange | false | 속성 CanModelChange 설정 |  |  |  |
| AC-20134160 | this.btnMeasure.Click | SCP0009_Shipment_Plan_FG.cs:4212 | if (frm.DialogResult == DialogResult.OK) | UI_PROP | this.CanModelChange | true | 속성 CanModelChange 설정 |  |  |  |

## SCP0009_Shipment_Plan_FG.BtnNew_Click

진입점: this.btnNew.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1c25a189 | this.btnNew.Click | SCP0009_Shipment_Plan_FG.cs:1112 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-282e4e29 | this.btnNew.Click | SCP0009_Shipment_Plan_FG.cs:1113 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1e5c5e5b | this.btnNew.Click | SCP0009_Shipment_Plan_FG.cs:1117 | if (cboPlanDate.ControlValues == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8514a02a | this.btnNew.Click | SCP0009_Shipment_Plan_FG.cs:1119 | if (!Get_IsSaveYn()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-56b3cedd | this.btnNew.Click | SCP0009_Shipment_Plan_FG.cs:1131 | if (division.Substring(0, 2).Equals("EE") && sOperationGroup=="A") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4012e199 | this.btnNew.Click | SCP0009_Shipment_Plan_FG.cs:1133 |  | POPUP | new SCM0002_ShipmentPlanInsertPopup | () | 팝업/폼 생성 |  |  |  |
| AC-528f9e8a | this.btnNew.Click | SCP0009_Shipment_Plan_FG.cs:1134 |  | UI_PROP | popup.divisionId | division | 속성 divisionId 설정 |  |  |  |
| AC-9ea084e8 | this.btnNew.Click | SCP0009_Shipment_Plan_FG.cs:1135 |  | UI_PROP | popup.p_operationGroup | sOperationGroup | 속성 p_operationGroup 설정 |  |  |  |
| AC-5d2e6ac5 | this.btnNew.Click | SCP0009_Shipment_Plan_FG.cs:1136 |  | UI_PROP | popup.p_planDate | dPlanDate | 속성 p_planDate 설정 |  |  |  |
| AC-ffb107fa | this.btnNew.Click | SCP0009_Shipment_Plan_FG.cs:1137 |  | UI_PROP | popup.p_plan_start_yyyymmdd | sPlanStartYyyymmdd | 속성 p_plan_start_yyyymmdd 설정 |  |  |  |
| AC-af4f6b0f | this.btnNew.Click | SCP0009_Shipment_Plan_FG.cs:1138 |  | UI_PROP | popup.p_planType | sPlanType | 속성 p_planType 설정 |  |  |  |
| AC-1ec9a0b7 | this.btnNew.Click | SCP0009_Shipment_Plan_FG.cs:1139 |  | UI_PROP | popup.p_seq | sSeq | 속성 p_seq 설정 |  |  |  |
| AC-16d6b94f | this.btnNew.Click | SCP0009_Shipment_Plan_FG.cs:1140 |  | UI_PROP | popup.p_user_id | UserInfo.UserId | 속성 p_user_id 설정 |  |  |  |
| AC-6e6fe1d7 | this.btnNew.Click | SCP0009_Shipment_Plan_FG.cs:1141 |  | UI_PROP | popup.p_prgram_id | sPrg | 속성 p_prgram_id 설정 |  |  |  |
| AC-71ad106e | this.btnNew.Click | SCP0009_Shipment_Plan_FG.cs:1143 |  | UI_PROP | popup.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-00b5ac98 | this.btnNew.Click | SCP0009_Shipment_Plan_FG.cs:1144 |  | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-b643f071 | this.btnNew.Click | SCP0009_Shipment_Plan_FG.cs:1154 | if (popup.DialogResult == DialogResult.OK) ▸ else of (division.Substring(0, 2).Equals("EE")) | VALUE_SET | txtItem_Id.Text | popup.s_ItemId | 컨트롤 값 설정 |  |  |  |
| AC-794ae95b | this.btnNew.Click | SCP0009_Shipment_Plan_FG.cs:1157 | if (popup.DialogResult == DialogResult.OK) ▸ else of (division.Substring(0, 2).Equals("EE")) | MESSAGE | MessageHelper.GMessageBox | ("MSG00265") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SCP0009_Shipment_Plan_FG.btnNewControl

진입점: this.Load [if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))] / cboDivision.SelectedIndexChanged [if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))] / cboBizType.SelectedIndexChanged / cboPlanDate.SelectedIndexChanged [else of (sPlanType.Equals("FN") \|\| sPlanType.Equals("TE")) ▸ if (!string.IsNullOrEmpty(CString.GetCheckedListValue(dtPlanSeq, cboPlanSeq.ControlValues, true))) ▸ if (curPlanSeq == maxSeq)] / cboPlanType.SelectedIndexChanged [else of (sPlanType.Equals("FN") \|\| sPlanType.Equals("TE")) ▸ if (!string.IsNullOrEmpty…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6005190a | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 5 | SCP0009_Shipment_Plan_FG.cs:4233 | if ((this._division.Substring(0, 2).Equals("EE") && this._operationGroup == "A") \|\| this._planType=="FN") | STATE | btnNew.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-5fba39ce | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 5 | SCP0009_Shipment_Plan_FG.cs:4237 | else of ((this._division.Substring(0, 2).Equals("EE") && this._operationGroup == "A") \|\| this._planType=="FN") | STATE | btnNew.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## SCP0009_Shipment_Plan_FG.BtnProject_Click

진입점: this.btnProject.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1f308337 | this.btnProject.Click | SCP0009_Shipment_Plan_FG.cs:4187 |  | CALL_EXT | UIUtils.GetAllDivisionChecked | (cboDivision) | ⚠ 의미 확인 필요 |  |  |  |
| AC-aefed89e | this.btnProject.Click | SCP0009_Shipment_Plan_FG.cs:4189 |  | POPUP | new SCM0002_ProjectbyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-b75eab57 | this.btnProject.Click | SCP0009_Shipment_Plan_FG.cs:4191 |  | POPUP | popProject.Form_Load | (true, division, sProject) | 팝업 초기화(인자 전달) |  |  |  |
| AC-bb2b670f | this.btnProject.Click | SCP0009_Shipment_Plan_FG.cs:4192 |  | UI_PROP | popProject.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-df322929 | this.btnProject.Click | SCP0009_Shipment_Plan_FG.cs:4193 |  | POPUP | popProject.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-16760c05 | this.btnProject.Click | SCP0009_Shipment_Plan_FG.cs:4198 | if (popProject.ProjectCode != "") | VALUE_SET | txtProject.Text | sProjectCode | 컨트롤 값 설정 |  |  |  |

## SCP0009_Shipment_Plan_FG.BtnUnfix_Click

진입점: this.btnUnfix.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a5c14074 | this.btnUnfix.Click | SCP0009_Shipment_Plan_FG.cs:1074 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0e8fb025 | this.btnUnfix.Click | SCP0009_Shipment_Plan_FG.cs:1075 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-cddeacda | this.btnUnfix.Click | SCP0009_Shipment_Plan_FG.cs:1080 | if (fps != null) ▸ if (dsBinding.Tables.Count == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-60dadb1d | this.btnUnfix.Click | SCP0009_Shipment_Plan_FG.cs:1083 | if (fps != null) ▸ if (siMain.IsLock(siMain.SheetName)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00010") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-81337286 | this.btnUnfix.Click | SCP0009_Shipment_Plan_FG.cs:1086 | if (fps != null) ▸ else of (siMain.IsLock(siMain.SheetName)) ▸ if (!Get_IsSaveYn()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4d9db527 | this.btnUnfix.Click | SCP0009_Shipment_Plan_FG.cs:1095 | if (fps != null) ▸ else of (siMain.IsLock(siMain.SheetName)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00016") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SCP0009_Shipment_Plan_FG.BtnW26_Click

진입점: this.btnW26.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-810a976b | this.btnW26.Click | SCP0009_Shipment_Plan_FG.cs:999 |  | VALUE_SET | dCalendar.InitValue | GetDayRange(PeriodType.W26) | 컨트롤 값 설정 |  |  |  |

## SCP0009_Shipment_Plan_FG.BtnW52_Click

진입점: this.btnW52.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-10fe19be | this.btnW52.Click | SCP0009_Shipment_Plan_FG.cs:1004 |  | VALUE_SET | dCalendar.InitValue | GetDayRange(PeriodType.W52) | 컨트롤 값 설정 |  |  |  |

## SCP0009_Shipment_Plan_FG.BtnWLast_Click

진입점: this.btnWLast.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3c614deb | this.btnWLast.Click | SCP0009_Shipment_Plan_FG.cs:1016 | if (success) | VALUE_SET | dCalendar.InitValue | GetDayRange(WkNum.ToString()) | 컨트롤 값 설정 |  |  |  |

## SCP0009_Shipment_Plan_FG.cboBucketType_SelectedIndexChanged

진입점: this.cboBucketType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4b2d87c8 | this.cboBucketType.SelectedIndexChanged | SCP0009_Shipment_Plan_FG.cs:4076 | else of (chkAll.Checked) | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |

## SCP0009_Shipment_Plan_FG.CboPlanDate_SelectedIndexChanged

진입점: cboPlanDate.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-45176981 | cboPlanDate.SelectedIndexChanged | SCP0009_Shipment_Plan_FG.cs:1226 |  | VALUE_SET | cboPlanType.SelectedIndex | dtPlanType.Rows.Count - 1 | 컨트롤 값 설정 |  |  |  |
| AC-be0cd9a1 | cboPlanDate.SelectedIndexChanged | SCP0009_Shipment_Plan_FG.cs:1231 |  | VALUE_SET | dCalendar.InitValue | GetDayRange(PeriodType.W52) | 컨트롤 값 설정 |  |  |  |
| AC-ec6e214f | cboPlanDate.SelectedIndexChanged | SCP0009_Shipment_Plan_FG.cs:1233 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |
| AC-cc54be78 | cboPlanDate.SelectedIndexChanged | SCP0009_Shipment_Plan_FG.cs:1235 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdPeggingInfo) | 그리드 데이터/선택 비움 |  |  |  |
| AC-39038644 | cboPlanDate.SelectedIndexChanged | SCP0009_Shipment_Plan_FG.cs:1236 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdPlanProblem) | 그리드 데이터/선택 비움 |  |  |  |

## SCP0009_Shipment_Plan_FG.CboPlanSeq_SelectedIndexChanged

진입점: cboPlanSeq.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6202ebfb | cboPlanSeq.SelectedIndexChanged | SCP0009_Shipment_Plan_FG.cs:1032 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |
| AC-01832327 | cboPlanSeq.SelectedIndexChanged | SCP0009_Shipment_Plan_FG.cs:1034 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdPeggingInfo) | 그리드 데이터/선택 비움 |  |  |  |
| AC-1ecad37a | cboPlanSeq.SelectedIndexChanged | SCP0009_Shipment_Plan_FG.cs:1035 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdPlanProblem) | 그리드 데이터/선택 비움 |  |  |  |

## SCP0009_Shipment_Plan_FG.CboPlanType_SelectedIndexChanged

진입점: cboPlanType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ae062871 | cboPlanType.SelectedIndexChanged | SCP0009_Shipment_Plan_FG.cs:1246 |  | VALUE_SET | cboPlanSeq.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-df6261a4 | cboPlanType.SelectedIndexChanged | SCP0009_Shipment_Plan_FG.cs:1252 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |
| AC-e020f397 | cboPlanType.SelectedIndexChanged | SCP0009_Shipment_Plan_FG.cs:1254 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdPeggingInfo) | 그리드 데이터/선택 비움 |  |  |  |
| AC-b6ef3cf6 | cboPlanType.SelectedIndexChanged | SCP0009_Shipment_Plan_FG.cs:1255 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdPlanProblem) | 그리드 데이터/선택 비움 |  |  |  |

## SCP0009_Shipment_Plan_FG.CheckMandatorySheetColumns

진입점: EditButton [if (fps != null)] / SaveButton [if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c8e75c83 | EditButton [if (fps != null)] 외 1 | SCP0009_Shipment_Plan_FG.cs:2725 | if (errorCols.Length > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00412", new object[] { errorCols, "" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-7f751783 | EditButton [if (fps != null)] 외 1 | SCP0009_Shipment_Plan_FG.cs:2727 | if (errorCols.Length > 0) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-c034dcc3 | EditButton [if (fps != null)] 외 1 | SCP0009_Shipment_Plan_FG.cs:2731 | else of (errorCols.Length > 0) | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## SCP0009_Shipment_Plan_FG.clbTeam_SelectedIndexChanged

진입점: this.clbTeam.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ecb4be6a | this.clbTeam.SelectedIndexChanged | SCP0009_Shipment_Plan_FG.cs:4733 | if ((division == "81") \|\| (division == "82")) | FLAG | dtCustomer | Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.… | 화면 필드/플래그 변경 |  |  |  |
| AC-dcb7d2f9 | this.clbTeam.SelectedIndexChanged | SCP0009_Shipment_Plan_FG.cs:4733 | if ((division == "81") \|\| (division == "82")) | COMBO_DATA | Data.UserEndCustomerByDivisionDept | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, division, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-46289e0c | this.clbTeam.SelectedIndexChanged | SCP0009_Shipment_Plan_FG.cs:4734 | if ((division == "81") \|\| (division == "82")) | LIST_REBIND | clsCtrl.setListBox | (dtCustomer, clbCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-832c22ed | this.clbTeam.SelectedIndexChanged | SCP0009_Shipment_Plan_FG.cs:4736 | if ((division == "81") \|\| (division == "82")) | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-a9cd256e | this.clbTeam.SelectedIndexChanged | SCP0009_Shipment_Plan_FG.cs:4736 | if ((division == "81") \|\| (division == "82")) | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, division, sEndCust… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-305692c4 | this.clbTeam.SelectedIndexChanged | SCP0009_Shipment_Plan_FG.cs:4740 | else of ((division == "81") \|\| (division == "82")) | FLAG | dtCustomer | Data.Common(Data.Type.EndCustomerByDivision40, false, division, clbTeam.ControlValues, Use… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 화면 필드/플래그 변경 |  |  |  |
| AC-d1b68f35 | this.clbTeam.SelectedIndexChanged | SCP0009_Shipment_Plan_FG.cs:4740 | else of ((division == "81") \|\| (division == "82")) | COMBO_DATA | Data.Common | (Data.Type.EndCustomerByDivision40, false, division, clbTeam.ControlValues, UserInfoContex… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-7bda5cdc | this.clbTeam.SelectedIndexChanged | SCP0009_Shipment_Plan_FG.cs:4741 | else of ((division == "81") \|\| (division == "82")) | LIST_REBIND | clsCtrl.setListBox | (dtCustomer, clbCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-10902ccc | this.clbTeam.SelectedIndexChanged | SCP0009_Shipment_Plan_FG.cs:4743 | else of ((division == "81") \|\| (division == "82")) | FLAG | dtSalesSite | Data.Common(Data.Type.SiteByEndCustomer40, false, division, clbTeam.ControlValues, clbCust… ⇒ biz:CommonData.CommonDataList [code=SiteByEndCustomer40] | 화면 필드/플래그 변경 |  |  |  |
| AC-8be03eff | this.clbTeam.SelectedIndexChanged | SCP0009_Shipment_Plan_FG.cs:4743 | else of ((division == "81") \|\| (division == "82")) | COMBO_DATA | Data.Common | (Data.Type.SiteByEndCustomer40, false, division, clbTeam.ControlValues, clbCustomer.Contro… ⇒ biz:CommonData.CommonDataList [code=SiteByEndCustomer40] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-e1fd7617 | this.clbTeam.SelectedIndexChanged | SCP0009_Shipment_Plan_FG.cs:4746 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite,clbToSite, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0009_Shipment_Plan_FG.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fb4ea05f | this.Load | SCP0009_Shipment_Plan_FG.cs:634 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 3, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-7bd043a4 | this.Load | SCP0009_Shipment_Plan_FG.cs:635 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-27cf84d0 | this.Load | SCP0009_Shipment_Plan_FG.cs:636 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-af53bf53 | this.Load | SCP0009_Shipment_Plan_FG.cs:638 |  | GRID_INIT | this.AddSheet | (spdPeggingInfo, SpdSheet.shtPeggingInfo, SpdSheet.shtPeggingInfo, 1, 1, 50) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-7e4be60f | this.Load | SCP0009_Shipment_Plan_FG.cs:639 |  | FLAG | siPeggingInfo | GetSheetInfo(spdPeggingInfo.Name, spdPeggingInfo.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-3c475691 | this.Load | SCP0009_Shipment_Plan_FG.cs:641 |  | GRID_INIT | this.AddSheet | (spdPlanProblem, SpdSheet.shtPlanProblem, SpdSheet.shtPlanProblem, 1, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-fb802d9f | this.Load | SCP0009_Shipment_Plan_FG.cs:642 |  | FLAG | siPlanProblem | GetSheetInfo(spdPlanProblem.Name, 0) | 화면 필드/플래그 변경 |  |  |  |

## SCP0009_Shipment_Plan_FG.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b8ed6363 | this.Load | SCP0009_Shipment_Plan_FG.cs:309 |  | UI_PROP | usrConditionPanel1.Height | 100 | 속성 Height 설정 |  |  |  |
| AC-45ab63c4 | this.Load | SCP0009_Shipment_Plan_FG.cs:311 |  | VALUE_SET | cboBucketType.SelectedValue | BucketType.Weekly | 컨트롤 값 설정 |  |  |  |

## SCP0009_Shipment_Plan_FG.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ae0eb4c1 | Dispose | SCP0009_Shipment_Plan_FG.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0009_Shipment_Plan_FG.EditBlockChecking

진입점: this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock(siMain.SheetName)) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ if (iCount > 0) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Equals("S")) ▸ try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ if (p_bucket.ToString() == BucketType.Daily \|\| chkAll.Checked)] / this.btnUnfix.Click [if (fps != null) ▸ else of (siMain.IsLock(siMain.SheetName)) ▸ if (MessageHelper.GMessageBox("MSG00016") == DialogResult.Yes) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ if (iCount > 0) ▸ try ▸ …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a5fef279 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 5 | SCP0009_Shipment_Plan_FG.cs:1992 | if (number == 1) ▸ for (cols <= siMain.ActiveSheet.Columns.Count -1) | DATA_OP | dateColumn.Contains | ("W_") | 데이터 객체 조작/조회 |  |  |  |
| AC-4157e611 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 5 | SCP0009_Shipment_Plan_FG.cs:1995 | if (number == 1) ▸ for (cols <= siMain.ActiveSheet.Columns.Count -1) ▸ else of (dateColumn.Contains("W_")) | DATA_OP | dateColumn.Contains | ("D_") | 데이터 객체 조작/조회 |  |  |  |
| AC-69e50c82 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 5 | SCP0009_Shipment_Plan_FG.cs:2017 | if (number == 1) | RETURN | return retIndex == 0 ? siMain.GetMaxColumnIndex() : retIndex; |  | 처리 중단/반환 |  |  |  |
| AC-0a939ce4 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 5 | SCP0009_Shipment_Plan_FG.cs:2024 |  | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |

## SCP0009_Shipment_Plan_FG.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-eea4d630 | EditButton | SCP0009_Shipment_Plan_FG.cs:1270 | if (fps != null) ▸ if (dsBinding.Tables.Count == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-23ab1920 | EditButton | SCP0009_Shipment_Plan_FG.cs:1273 | if (fps != null) ▸ if (siMain == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6ccdf139 | EditButton | SCP0009_Shipment_Plan_FG.cs:1276 | if (fps != null) ▸ if (siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9ab8549f | EditButton | SCP0009_Shipment_Plan_FG.cs:1278 | if (fps != null) | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-942962e7 | EditButton | SCP0009_Shipment_Plan_FG.cs:1282 | if (fps != null) ▸ if (!CheckMandatorySheetColumns()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3a5eaaaa | EditButton | SCP0009_Shipment_Plan_FG.cs:1284 | if (fps != null) | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-95c6797c | EditButton | SCP0009_Shipment_Plan_FG.cs:1286 | if (fps != null) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefMain.DIVISION_ID), siMain.nIdxData, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-343b354e | EditButton | SCP0009_Shipment_Plan_FG.cs:1290 | if (fps != null) ▸ if (this.IsEditMode && cboBucketType.ControlValues != BucketType.Monthly) ▸ if (EditBlockChecking(2) != 1) | FLAG | _isInsert | true | 화면 필드/플래그 변경 |  |  |  |
| AC-bffdf59b | EditButton | SCP0009_Shipment_Plan_FG.cs:1295 | if (fps != null) ▸ if (this.IsEditMode && cboBucketType.ControlValues != BucketType.Monthly) ▸ else of (EditBlockChecking(2) != 1) | FLAG | _isInsert | false | 화면 필드/플래그 변경 |  |  |  |
| AC-6fd959a8 | EditButton | SCP0009_Shipment_Plan_FG.cs:1296 | if (fps != null) ▸ if (this.IsEditMode && cboBucketType.ControlValues != BucketType.Monthly) ▸ else of (EditBlockChecking(2) != 1) | GRID_LOCK | siMain.LockRange | (0, siMain.nIdxData, siMain.GetMaxRowIndex(), siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-b404d13e | EditButton | SCP0009_Shipment_Plan_FG.cs:1301 | if (fps != null) ▸ else of (this.IsEditMode && cboBucketType.ControlValues != BucketType.Monthly) | FLAG | _isInsert | false | 화면 필드/플래그 변경 |  |  |  |
| AC-5484ce08 | EditButton | SCP0009_Shipment_Plan_FG.cs:1302 | if (fps != null) ▸ else of (this.IsEditMode && cboBucketType.ControlValues != BucketType.Monthly) | GRID_LOCK | siMain.LockRange | (0, siMain.nIdxData, siMain.GetMaxRowIndex(), siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |

## SCP0009_Shipment_Plan_FG.ElectrodeDashReplace

진입점: this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >= 0) ▸ if (siMain.GetValue(e.Row, siMain.GetColumnIndex(DefMain.MEASURE)).ToString().Equals("MKT_FCST"))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fc693ce2 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0009_Shipment_Plan_FG.cs:3949 |  | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |

## SCP0009_Shipment_Plan_FG.ExcelButton

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5299e0bb | ExcelButton | SCP0009_Shipment_Plan_FG.cs:1324 |  | UI_PROP | exportOption.Merge | ExcelMergeOption.None | 속성 Merge 설정 |  |  |  |
| AC-4b90eb20 | ExcelButton | SCP0009_Shipment_Plan_FG.cs:1325 |  | UI_PROP | exportOption.Border | ExcelBorderOption.All | 속성 Border 설정 |  |  |  |
| AC-f0a5d325 | ExcelButton | SCP0009_Shipment_Plan_FG.cs:1326 |  | UI_PROP | exportOption.AheadZeroOption | ZeroOption.HideZero | 속성 AheadZeroOption 설정 |  |  |  |
| AC-e3e96fc6 | ExcelButton | SCP0009_Shipment_Plan_FG.cs:1327 |  | UI_PROP | exportOption.AmendNullToZero | true | 속성 AmendNullToZero 설정 |  |  |  |
| AC-e8a586c4 | ExcelButton | SCP0009_Shipment_Plan_FG.cs:1328 |  | UI_PROP | exportOption.AheadNullToZero | false | 속성 AheadNullToZero 설정 |  |  |  |
| AC-8bc55fd6 | ExcelButton | SCP0009_Shipment_Plan_FG.cs:1329 |  | UI_PROP | exportOption.AmendZeroOption | ZeroOption.ShowZero | 속성 AmendZeroOption 설정 |  |  |  |
| AC-e0190da7 | ExcelButton | SCP0009_Shipment_Plan_FG.cs:1331 |  | UI_PROP | exportOption.UserName | UserInfo.UserId | 속성 UserName 설정 |  |  |  |
| AC-acbc3058 | ExcelButton | SCP0009_Shipment_Plan_FG.cs:1332 |  | UI_PROP | exportOption.FileName | sFileName | 속성 FileName 설정 |  |  |  |
| AC-c7f8e1d9 | ExcelButton | SCP0009_Shipment_Plan_FG.cs:1334 |  | UI_PROP | exportOption.AmendDecimalFormat | "#,###;[red]-#,###" | 속성 AmendDecimalFormat 설정 |  |  |  |
| AC-358b4ee6 | ExcelButton | SCP0009_Shipment_Plan_FG.cs:1339 | try | CALL_EXT | SimplexelService.ExportFpSpread | (fps, exportOption) | ⚠ 의미 확인 필요 |  |  |  |
| AC-aa27404f | ExcelButton | SCP0009_Shipment_Plan_FG.cs:1344 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-558a407a | ExcelButton | SCP0009_Shipment_Plan_FG.cs:1348 | finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCP0009_Shipment_Plan_FG.FindData_Main

진입점: this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock(siMain.SheetName)) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ if (iCount > 0) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Equals("S"))] / this.btnUnfix.Click [if (fps != null) ▸ else of (siMain.IsLock(siMain.SheetName)) ▸ if (MessageHelper.GMessageBox("MSG00016") == DialogResult.Yes) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ if (iCount > 0) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Equals("S"))] / this.btnNew…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f58ab101 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0009_Shipment_Plan_FG.cs:1359 |  | VALIDATE | DataUtil.checkRequired | (this.usrConditionPanel1) | 프레임워크 검증 |  |  |  |
| AC-4f6a1fe4 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0009_Shipment_Plan_FG.cs:1359 | if (!DataUtil.checkRequired(this.usrConditionPanel1)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f024f46a | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0009_Shipment_Plan_FG.cs:1361 |  | VALIDATE | DateUtil.Check_PeriodDate_New | (dCalendar, "1", "7") | 프레임워크 검증 |  |  |  |
| AC-a4560d53 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0009_Shipment_Plan_FG.cs:1361 | if (!DateUtil.Check_PeriodDate_New(dCalendar, "1", "7")) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-fc7447cb | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0009_Shipment_Plan_FG.cs:1396 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-55d41231 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0009_Shipment_Plan_FG.cs:1398 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-d7fe46cc | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0009_Shipment_Plan_FG.cs:1404 | try ▸ if (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) | CALL_EXT | DateUtil.MonthDiff | (p_to_yyyymmdd.ToString(), p_from_yyyymmdd.ToString()) | ⚠ 의미 확인 필요 |  |  |  |
| AC-29e47c8c | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0009_Shipment_Plan_FG.cs:1417 | try ▸ if (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) | CALL_EXT | Parallel.For | (0, (nCnt), (i) => { if (i != nCnt - 1) { //중장기 개발 ( 4=> 7) string strStartDate = DateUtil… | ⚠ 의미 확인 필요 |  |  |  |
| AC-53efcc3a | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0009_Shipment_Plan_FG.cs:1435 | try ▸ if (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ if (i != nCnt - 1) | CALL_EXT | FoxUserInfoContext.CreateScope | (new FoxUserInfoContext(p_user_id.ToString())) | ⚠ 의미 확인 필요 |  |  |  |
| AC-2ebfeb88 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0009_Shipment_Plan_FG.cs:1438 | try ▸ if (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ if (i != nCnt - 1) | ENDPOINT | new FoxDataRequest | ("SCP.SCP0009_GET_SHIPMENT_PLAN_FG") ⇒ SCP.SCP0009_GET_SHIPMENT_PLAN_FG | 엔드포인트 요청 생성 |  |  |  |
| AC-042e2855 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0009_Shipment_Plan_FG.cs:1440 | try ▸ if (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ if (i != nCnt - 1) | UI_PROP | req.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-3fdd3836 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0009_Shipment_Plan_FG.cs:1442 | try ▸ if (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ if (i != nCnt - 1) | DATA_OP | req.Parameters["p_from_yyyymmdd"] | strStartDate | 행/컬럼 값 대입 |  |  |  |
| AC-fff876e3 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0009_Shipment_Plan_FG.cs:1443 | try ▸ if (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ if (i != nCnt - 1) | DATA_OP | req.Parameters["p_to_yyyymmdd"] | strEndDate | 행/컬럼 값 대입 |  |  |  |
| AC-89b0d23f | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0009_Shipment_Plan_FG.cs:1444 | try ▸ if (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ if (i != nCnt - 1) | DATA_OP | req.Parameters["p_division_id"] | division | 행/컬럼 값 대입 |  |  |  |
| AC-d0c8bc53 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0009_Shipment_Plan_FG.cs:1445 | try ▸ if (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ if (i != nCnt - 1) | DATA_OP | req.Parameters["p_biz_type"] | p_biz_type | 행/컬럼 값 대입 |  |  |  |
| AC-0fc9e2ef | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0009_Shipment_Plan_FG.cs:1446 | try ▸ if (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ if (i != nCnt - 1) | DATA_OP | req.Parameters["p_project_code"] | p_project_code | 행/컬럼 값 대입 |  |  |  |
| AC-97d5f7af | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0009_Shipment_Plan_FG.cs:1447 | try ▸ if (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ if (i != nCnt - 1) | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-d01cbe2b | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0009_Shipment_Plan_FG.cs:1448 | try ▸ if (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ if (i != nCnt - 1) | DATA_OP | req.Parameters["p_electype"] | p_electype | 행/컬럼 값 대입 |  |  |  |
| AC-9421fd35 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0009_Shipment_Plan_FG.cs:1449 | try ▸ if (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ if (i != nCnt - 1) | DATA_OP | req.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-cce4f184 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0009_Shipment_Plan_FG.cs:1450 | try ▸ if (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ if (i != nCnt - 1) | DATA_OP | req.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-0c422d1f | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0009_Shipment_Plan_FG.cs:1451 | try ▸ if (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ if (i != nCnt - 1) | DATA_OP | req.Parameters["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-11d45b82 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0009_Shipment_Plan_FG.cs:1452 | try ▸ if (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ if (i != nCnt - 1) | DATA_OP | req.Parameters["p_fromsite"] | p_fromsite | 행/컬럼 값 대입 |  |  |  |
| AC-cf3fe6b5 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0009_Shipment_Plan_FG.cs:1453 | try ▸ if (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ if (i != nCnt - 1) | DATA_OP | req.Parameters["p_team_id"] | p_team | 행/컬럼 값 대입 |  |  |  |
| AC-3daacce6 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0009_Shipment_Plan_FG.cs:1454 | try ▸ if (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ if (i != nCnt - 1) | DATA_OP | req.Parameters["p_tosite"] | p_tosite | 행/컬럼 값 대입 |  |  |  |
| AC-0316d63d | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0009_Shipment_Plan_FG.cs:1455 | try ▸ if (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ if (i != nCnt - 1) | DATA_OP | req.Parameters["p_program_id"] | "SCP0009" | 행/컬럼 값 대입 |  |  |  |
| AC-783166f5 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0009_Shipment_Plan_FG.cs:1456 | try ▸ if (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ if (i != nCnt - 1) | DATA_OP | req.Parameters["p_sheet_name"] | p_sheet_name | 행/컬럼 값 대입 |  |  |  |
| AC-27ed5eb2 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0009_Shipment_Plan_FG.cs:1457 | try ▸ if (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ if (i != nCnt - 1) | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-61be6df4 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0009_Shipment_Plan_FG.cs:1458 | try ▸ if (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ if (i != nCnt - 1) | DATA_OP | req.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-724705d3 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0009_Shipment_Plan_FG.cs:1459 | try ▸ if (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ if (i != nCnt - 1) | DATA_OP | req.Parameters["p_bucket"] | p_bucket | 행/컬럼 값 대입 |  |  |  |
| AC-e71cb1e9 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0009_Shipment_Plan_FG.cs:1460 | try ▸ if (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ if (i != nCnt - 1) | DATA_OP | req.Parameters["p_to_period"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-0b55450f | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0009_Shipment_Plan_FG.cs:1461 | try ▸ if (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ if (i != nCnt - 1) | DATA_OP | req.Parameters["p_chk_all"] | p_chk_all | 행/컬럼 값 대입 |  |  |  |
| AC-84605d9b | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0009_Shipment_Plan_FG.cs:1469 | try ▸ if (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ if (i != nCnt - 1) ▸ if (i == 0) | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-216b1d50 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0009_Shipment_Plan_FG.cs:1473 | try ▸ if (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ if (i != nCnt - 1) ▸ else of (i == 0) ▸ if (i == 1) | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-fbe3a159 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0009_Shipment_Plan_FG.cs:1477 | try ▸ if (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ if (i != nCnt - 1) ▸ else of (i == 0) ▸ else of (i … | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-003e0be4 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0009_Shipment_Plan_FG.cs:1483 | try ▸ if (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ else of (i != nCnt - 1) | CALL_EXT | FoxUserInfoContext.CreateScope | (new FoxUserInfoContext(p_user_id.ToString())) | ⚠ 의미 확인 필요 |  |  |  |
| AC-4615dca8 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0009_Shipment_Plan_FG.cs:1486 | try ▸ if (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ else of (i != nCnt - 1) | ENDPOINT | new FoxDataRequest | ("SCP.SCP0009_GET_SHIPMENT_PLAN_FG_TITLE_PARAL") ⇒ SCP.SCP0009_GET_SHIPMENT_PLAN_FG_TITLE_PARAL | 엔드포인트 요청 생성 |  |  |  |
| AC-ccf38799 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0009_Shipment_Plan_FG.cs:1488 | try ▸ if (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ else of (i != nCnt - 1) | UI_PROP | req.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-6824ad12 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0009_Shipment_Plan_FG.cs:1489 | try ▸ if (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ else of (i != nCnt - 1) | DATA_OP | req.Parameters["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-8e3866bc | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0009_Shipment_Plan_FG.cs:1490 | try ▸ if (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ else of (i != nCnt - 1) | DATA_OP | req.Parameters["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-d333191b | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0009_Shipment_Plan_FG.cs:1491 | try ▸ if (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ else of (i != nCnt - 1) | DATA_OP | req.Parameters["p_division_id"] | division | 행/컬럼 값 대입 |  |  |  |
| AC-b8222d42 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0009_Shipment_Plan_FG.cs:1492 | try ▸ if (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ else of (i != nCnt - 1) | DATA_OP | req.Parameters["p_biz_type"] | p_biz_type | 행/컬럼 값 대입 |  |  |  |
| AC-4e926cf2 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0009_Shipment_Plan_FG.cs:1493 | try ▸ if (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ else of (i != nCnt - 1) | DATA_OP | req.Parameters["p_project_code"] | p_project_code | 행/컬럼 값 대입 |  |  |  |
| AC-e3b2aebc | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0009_Shipment_Plan_FG.cs:1494 | try ▸ if (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ else of (i != nCnt - 1) | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-10a3c77f | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0009_Shipment_Plan_FG.cs:1495 | try ▸ if (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ else of (i != nCnt - 1) | DATA_OP | req.Parameters["p_electype"] | p_electype | 행/컬럼 값 대입 |  |  |  |
| AC-a9003c58 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0009_Shipment_Plan_FG.cs:1496 | try ▸ if (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ else of (i != nCnt - 1) | DATA_OP | req.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-2e8c7d74 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0009_Shipment_Plan_FG.cs:1497 | try ▸ if (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ else of (i != nCnt - 1) | DATA_OP | req.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-5d0d141c | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0009_Shipment_Plan_FG.cs:1498 | try ▸ if (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ else of (i != nCnt - 1) | DATA_OP | req.Parameters["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-78bba2d2 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0009_Shipment_Plan_FG.cs:1499 | try ▸ if (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ else of (i != nCnt - 1) | DATA_OP | req.Parameters["p_fromsite"] | p_fromsite | 행/컬럼 값 대입 |  |  |  |
| AC-5b58cff8 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0009_Shipment_Plan_FG.cs:1500 | try ▸ if (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ else of (i != nCnt - 1) | DATA_OP | req.Parameters["p_team_id"] | p_team | 행/컬럼 값 대입 |  |  |  |
| AC-b0183be1 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0009_Shipment_Plan_FG.cs:1501 | try ▸ if (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ else of (i != nCnt - 1) | DATA_OP | req.Parameters["p_tosite"] | p_tosite | 행/컬럼 값 대입 |  |  |  |
| AC-6e4be1a4 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0009_Shipment_Plan_FG.cs:1502 | try ▸ if (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ else of (i != nCnt - 1) | DATA_OP | req.Parameters["p_bucket"] | p_bucket | 행/컬럼 값 대입 |  |  |  |
| AC-ad8a1a8e | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0009_Shipment_Plan_FG.cs:1503 | try ▸ if (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ else of (i != nCnt - 1) | DATA_OP | req.Parameters["p_chk_all"] | p_chk_all | 행/컬럼 값 대입 |  |  |  |
| AC-dcad2edc | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0009_Shipment_Plan_FG.cs:1504 | try ▸ if (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ else of (i != nCnt - 1) | DATA_OP | req.Parameters["p_program_id"] | "SCP0009" | 행/컬럼 값 대입 |  |  |  |
| AC-90e7a2c8 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0009_Shipment_Plan_FG.cs:1505 | try ▸ if (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ else of (i != nCnt - 1) | DATA_OP | req.Parameters["p_sheet_name"] | p_sheet_name | 행/컬럼 값 대입 |  |  |  |
| AC-d349a845 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0009_Shipment_Plan_FG.cs:1506 | try ▸ if (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ else of (i != nCnt - 1) | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-fdcf3ca1 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0009_Shipment_Plan_FG.cs:1507 | try ▸ if (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ else of (i != nCnt - 1) | DATA_OP | req.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-8691baa0 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0009_Shipment_Plan_FG.cs:1511 | try ▸ if (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ else of (i != nCnt - 1) | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-22280c0e | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0009_Shipment_Plan_FG.cs:1517 | try ▸ if (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) | FLAG | dsBinding | dsTitle.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-104118e3 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0009_Shipment_Plan_FG.cs:1517 | try ▸ if (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) | DATA_OP | dsTitle.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-cd59eda4 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0009_Shipment_Plan_FG.cs:1518 | try ▸ if (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) | UI_MISC | dsTitle.Dispose | () | 창 닫기/해제 |  |  |  |
| AC-fe360036 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0009_Shipment_Plan_FG.cs:1520 | try ▸ if (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) ▸ if (dsBinding1 != null) | CALL_EXT | DataUtil.SetDataTableQtyData_New | (dsBinding.Tables[0], dsBinding1.Tables[0]) | ⚠ 의미 확인 필요 |  |  |  |
| AC-78cf96e3 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0009_Shipment_Plan_FG.cs:1521 | try ▸ if (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) ▸ if (dsBinding2 != null) | CALL_EXT | DataUtil.SetDataTableQtyData_New | (dsBinding.Tables[0], dsBinding2.Tables[0]) | ⚠ 의미 확인 필요 |  |  |  |
| AC-05b8d0bb | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0009_Shipment_Plan_FG.cs:1522 | try ▸ if (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) ▸ if (dsBinding3 != null) | CALL_EXT | DataUtil.SetDataTableQtyData_New | (dsBinding.Tables[0], dsBinding3.Tables[0]) | ⚠ 의미 확인 필요 |  |  |  |
| AC-cfe2bcc4 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0009_Shipment_Plan_FG.cs:1526 | try ▸ else of (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) | CALL_EXT | FoxUserInfoContext.CreateScope | (new FoxUserInfoContext(p_user_id.ToString())) | ⚠ 의미 확인 필요 |  |  |  |
| AC-34392664 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0009_Shipment_Plan_FG.cs:1529 | try ▸ else of (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) | ENDPOINT | new FoxDataRequest | ("SCP.SCP0009_GET_SHIPMENT_PLAN_FG") ⇒ SCP.SCP0009_GET_SHIPMENT_PLAN_FG | 엔드포인트 요청 생성 |  |  |  |
| AC-f3683e6e | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0009_Shipment_Plan_FG.cs:1531 | try ▸ else of (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) | UI_PROP | req.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-774e4cc0 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0009_Shipment_Plan_FG.cs:1533 | try ▸ else of (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) | DATA_OP | req.Parameters["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-a92b193d | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0009_Shipment_Plan_FG.cs:1534 | try ▸ else of (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) | DATA_OP | req.Parameters["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-3158bf86 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0009_Shipment_Plan_FG.cs:1535 | try ▸ else of (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) | DATA_OP | req.Parameters["p_division_id"] | division | 행/컬럼 값 대입 |  |  |  |
| AC-48b38a06 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0009_Shipment_Plan_FG.cs:1536 | try ▸ else of (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) | DATA_OP | req.Parameters["p_biz_type"] | p_biz_type | 행/컬럼 값 대입 |  |  |  |
| AC-aeab9724 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0009_Shipment_Plan_FG.cs:1537 | try ▸ else of (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) | DATA_OP | req.Parameters["p_project_code"] | p_project_code | 행/컬럼 값 대입 |  |  |  |
| AC-4c1703b6 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0009_Shipment_Plan_FG.cs:1538 | try ▸ else of (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-87f2a4ce | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0009_Shipment_Plan_FG.cs:1539 | try ▸ else of (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) | DATA_OP | req.Parameters["p_electype"] | p_electype | 행/컬럼 값 대입 |  |  |  |
| AC-4b0654cc | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0009_Shipment_Plan_FG.cs:1540 | try ▸ else of (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) | DATA_OP | req.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-d4e18044 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0009_Shipment_Plan_FG.cs:1541 | try ▸ else of (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) | DATA_OP | req.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-c38288c7 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0009_Shipment_Plan_FG.cs:1542 | try ▸ else of (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) | DATA_OP | req.Parameters["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-38471344 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0009_Shipment_Plan_FG.cs:1543 | try ▸ else of (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) | DATA_OP | req.Parameters["p_fromsite"] | p_fromsite | 행/컬럼 값 대입 |  |  |  |
| AC-db6e84b8 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0009_Shipment_Plan_FG.cs:1544 | try ▸ else of (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) | DATA_OP | req.Parameters["p_team_id"] | p_team | 행/컬럼 값 대입 |  |  |  |
| AC-18b9e67d | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0009_Shipment_Plan_FG.cs:1545 | try ▸ else of (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) | DATA_OP | req.Parameters["p_tosite"] | p_tosite | 행/컬럼 값 대입 |  |  |  |
| AC-e8833cf4 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0009_Shipment_Plan_FG.cs:1546 | try ▸ else of (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) | DATA_OP | req.Parameters["p_program_id"] | "SCP0009" | 행/컬럼 값 대입 |  |  |  |
| AC-201976a8 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0009_Shipment_Plan_FG.cs:1547 | try ▸ else of (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) | DATA_OP | req.Parameters["p_sheet_name"] | p_sheet_name | 행/컬럼 값 대입 |  |  |  |
| AC-043302ce | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0009_Shipment_Plan_FG.cs:1548 | try ▸ else of (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-ba2123d6 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0009_Shipment_Plan_FG.cs:1549 | try ▸ else of (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) | DATA_OP | req.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-f76f07e9 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0009_Shipment_Plan_FG.cs:1550 | try ▸ else of (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) | DATA_OP | req.Parameters["p_bucket"] | p_bucket | 행/컬럼 값 대입 |  |  |  |
| AC-8b1c87c9 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0009_Shipment_Plan_FG.cs:1551 | try ▸ else of (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) | DATA_OP | req.Parameters["p_to_period"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-075d2010 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0009_Shipment_Plan_FG.cs:1552 | try ▸ else of (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) | DATA_OP | req.Parameters["p_chk_all"] | p_chk_all | 행/컬럼 값 대입 |  |  |  |
| AC-6ede2c5f | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0009_Shipment_Plan_FG.cs:1554 | try ▸ else of (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) | FLAG | dsBinding | client.ExecuteDataSet(req).DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-76fff193 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0009_Shipment_Plan_FG.cs:1554 | try ▸ else of (p_bucket.ToString() == BucketType.Daily \|\| "Y".Equals(p_chk_all)) | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-e47c3b45 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0009_Shipment_Plan_FG.cs:1566 | try ▸ if (dsBinding.Tables[0].Rows.Count > 0) | GRID_BIND | siMain.Query | (dsBinding) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-5dbd8c12 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0009_Shipment_Plan_FG.cs:1570 | try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ if (CommonUtils.CheckDataEmpty(dsBinding.Tables[1]) == false) | FLAG | this._IsEditable | GetIsEditable(dsBinding.Tables[1], p_plan_start_yyyymmdd, p_plan_type, p_seq) | 화면 필드/플래그 변경 |  |  |  |
| AC-caf17b85 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0009_Shipment_Plan_FG.cs:1575 | try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ if (CommonUtils.CheckDataEmpty(dsBinding.Tables[1]) == false) | FLAG | this._plan_Start_Date | Convert.ToDateTime(dsBinding.Tables[1].Rows[0]["plan_start_date"]) | 화면 필드/플래그 변경 |  |  |  |
| AC-931a5266 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0009_Shipment_Plan_FG.cs:1583 | try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ if (p_bucket.ToString() == BucketType.Daily \|\| chkAll.Checked) | FLAG | this._block_idx | EditBlockChecking(1, siMain.nIdxData) | 화면 필드/플래그 변경 |  |  |  |
| AC-28e8733f | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0009_Shipment_Plan_FG.cs:1588 | try ▸ if (dsBinding.Tables[0].Rows.Count > 0) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-88a55dcf | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0009_Shipment_Plan_FG.cs:1593 | try ▸ if (dsBinding.Tables[0].Rows.Count > 0) | UI_MISC | SetSearchCount | (dsBinding) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-d5062f33 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0009_Shipment_Plan_FG.cs:1607 | try ▸ if (dsBinding.Tables[0].Rows.Count > 0) | CALL_EXT | siMain.AddRows | (siMain.GetMaxRowIndex() + 1, 1) | ⚠ 의미 확인 필요 |  |  |  |
| AC-8eb8c966 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0009_Shipment_Plan_FG.cs:1608 | try ▸ if (dsBinding.Tables[0].Rows.Count > 0) | CALL_EXT | siMain.VisibleRow | (siMain.GetMaxRowIndex(), false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f2495799 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0009_Shipment_Plan_FG.cs:1609 | try ▸ if (dsBinding.Tables[0].Rows.Count > 0) | GRID_SET | siMain.ActiveSheet.Rows[siMain.ActiveSheet.Rows.Count - 1].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-38e9f4ed | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0009_Shipment_Plan_FG.cs:1611 | try ▸ if (dsBinding.Tables[0].Rows.Count > 0) | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-085b2bd3 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0009_Shipment_Plan_FG.cs:1614 | try ▸ else of (dsBinding.Tables[0].Rows.Count > 0) | GRID_BIND | siMain.Query | (dsBinding) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-1ddc9137 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0009_Shipment_Plan_FG.cs:1617 | try | UI_MISC | SetSearchCount | (dsBinding) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-08a21b2f | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0009_Shipment_Plan_FG.cs:1620 | catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-1af67ccf | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0009_Shipment_Plan_FG.cs:1623 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-75e90850 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0009_Shipment_Plan_FG.cs:1625 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-e071e288 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0009_Shipment_Plan_FG.cs:1626 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## SCP0009_Shipment_Plan_FG.FindData_PeggingInfo

진입점: this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >= 0) ▸ if (siMain.GetValue(e.Row, siMain.GetColumnIndex(DefMain.MEASURE)).ToString().Equals("MKT_FCST"))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3fe5034d | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0009_Shipment_Plan_FG.cs:3823 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-f7d5efd3 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0009_Shipment_Plan_FG.cs:3825 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-fed7051f | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0009_Shipment_Plan_FG.cs:3828 | try | UI_PROP | proxyPivot.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-85a1b984 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0009_Shipment_Plan_FG.cs:3830 | try | ENDPOINT | proxyPivot.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, GSCM_SCP_ANALYS… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-bc629bee | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0009_Shipment_Plan_FG.cs:3832 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0009_GET_SHIPMENT_PLAN_FG_PEGGING") ⇒ SCP.SCP0009_GET_SHIPMENT_PLAN_FG_PEGGING | 엔드포인트 요청 생성 |  |  |  |
| AC-c1315143 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0009_Shipment_Plan_FG.cs:3833 | try ▸ lambda | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-f811c576 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0009_Shipment_Plan_FG.cs:3834 | try ▸ lambda | DATA_OP | req.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-15c55558 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0009_Shipment_Plan_FG.cs:3835 | try ▸ lambda | DATA_OP | req.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-246a0d8b | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0009_Shipment_Plan_FG.cs:3836 | try ▸ lambda | DATA_OP | req.Parameters["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-a8cf8844 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0009_Shipment_Plan_FG.cs:3837 | try ▸ lambda | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-05915ee1 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0009_Shipment_Plan_FG.cs:3838 | try ▸ lambda | DATA_OP | req.Parameters["p_origin_from_division_id"] | p_origin_from_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-5e5705e4 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0009_Shipment_Plan_FG.cs:3839 | try ▸ lambda | DATA_OP | req.Parameters["p_origin_to_division_id"] | p_origin_to_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-d68e74a2 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0009_Shipment_Plan_FG.cs:3840 | try ▸ lambda | DATA_OP | req.Parameters["p_electrode_type"] | p_electrode_type | 행/컬럼 값 대입 |  |  |  |
| AC-c7c6506f | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0009_Shipment_Plan_FG.cs:3841 | try ▸ lambda | DATA_OP | req.Parameters["p_biz_type"] | p_biz_type | 행/컬럼 값 대입 |  |  |  |
| AC-7988d7e5 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0009_Shipment_Plan_FG.cs:3842 | try ▸ lambda | DATA_OP | req.Parameters["p_to_site"] | p_to_site | 행/컬럼 값 대입 |  |  |  |
| AC-d2663d45 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0009_Shipment_Plan_FG.cs:3843 | try ▸ lambda | DATA_OP | req.Parameters["p_duedate"] | p_duedate | 행/컬럼 값 대입 |  |  |  |
| AC-fffa6281 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0009_Shipment_Plan_FG.cs:3844 | try ▸ lambda | DATA_OP | req.Parameters["p_project_code"] | p_project_code | 행/컬럼 값 대입 |  |  |  |
| AC-2e9d3913 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0009_Shipment_Plan_FG.cs:3846 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-7bc1c4ac | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0009_Shipment_Plan_FG.cs:3847 | try ▸ lambda | RETURN | return res.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-cdda9f3f | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0009_Shipment_Plan_FG.cs:3851 | try | GRID_BIND | siPeggingInfo.Query | (dsBinding) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-3a152fe2 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0009_Shipment_Plan_FG.cs:3852 | try | GRID_LOCK | siPeggingInfo.LockColumn | (0, siPeggingInfo.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-4b44e98c | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0009_Shipment_Plan_FG.cs:3853 | try | GRID_INIT | siPeggingInfo.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a612157e | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0009_Shipment_Plan_FG.cs:3856 | catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-73f03bc3 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0009_Shipment_Plan_FG.cs:3859 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-2e1d03e6 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0009_Shipment_Plan_FG.cs:3861 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0009_Shipment_Plan_FG.FindData_PlanProblem

진입점: this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >= 0) ▸ if (siMain.GetValue(e.Row, siMain.GetColumnIndex(DefMain.MEASURE)).ToString().Equals("MKT_FCST"))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0e540f70 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0009_Shipment_Plan_FG.cs:3888 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-2f712b04 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0009_Shipment_Plan_FG.cs:3891 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-f3f68a17 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0009_Shipment_Plan_FG.cs:3894 | try | UI_PROP | proxyPivot.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-f7c75888 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0009_Shipment_Plan_FG.cs:3896 | try | ENDPOINT | proxyPivot.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, GSCM_SCP_ANALYS… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-c56ce76c | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0009_Shipment_Plan_FG.cs:3900 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0009_GET_SHIPMENT_PLAN_FG_PROBLEM") ⇒ SCP.SCP0009_GET_SHIPMENT_PLAN_FG_PROBLEM | 엔드포인트 요청 생성 |  |  |  |
| AC-85132404 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0009_Shipment_Plan_FG.cs:3901 | try ▸ lambda | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-8152626c | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0009_Shipment_Plan_FG.cs:3902 | try ▸ lambda | DATA_OP | req.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-2e88d061 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0009_Shipment_Plan_FG.cs:3903 | try ▸ lambda | DATA_OP | req.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-7fb37a07 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0009_Shipment_Plan_FG.cs:3904 | try ▸ lambda | DATA_OP | req.Parameters["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-895f9723 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0009_Shipment_Plan_FG.cs:3905 | try ▸ lambda | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-52f7ee5c | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0009_Shipment_Plan_FG.cs:3906 | try ▸ lambda | DATA_OP | req.Parameters["p_project_code"] | p_project_code | 행/컬럼 값 대입 |  |  |  |
| AC-a46b9a6c | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0009_Shipment_Plan_FG.cs:3911 | try ▸ lambda | DATA_OP | req.Parameters["p_to_site"] | p_to_site | 행/컬럼 값 대입 |  |  |  |
| AC-1221553a | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0009_Shipment_Plan_FG.cs:3912 | try ▸ lambda | DATA_OP | req.Parameters["p_duedate"] | p_duedate | 행/컬럼 값 대입 |  |  |  |
| AC-a34820a5 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0009_Shipment_Plan_FG.cs:3914 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-00b9566e | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0009_Shipment_Plan_FG.cs:3915 | try ▸ lambda | RETURN | return res.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-598d9c1d | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0009_Shipment_Plan_FG.cs:3919 | try | GRID_BIND | siPlanProblem.Query | (dsBinding) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-00d1d97e | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0009_Shipment_Plan_FG.cs:3920 | try | GRID_LOCK | siPlanProblem.LockColumn | (0, siPlanProblem.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-9167267f | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0009_Shipment_Plan_FG.cs:3921 | try | GRID_INIT | siPlanProblem.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-eeac5657 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0009_Shipment_Plan_FG.cs:3925 | catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-c1635170 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0009_Shipment_Plan_FG.cs:3928 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-903ae2a1 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0009_Shipment_Plan_FG.cs:3932 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0009_Shipment_Plan_FG.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-307602c8 | this.Load | SCP0009_Shipment_Plan_FG.cs:299 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCP0009_Shipment_Plan_FG.Get_IsSaveYn

진입점: this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock(siMain.SheetName))] / this.btnUnfix.Click [if (fps != null) ▸ else of (siMain.IsLock(siMain.SheetName))] / this.btnNew.Click / SaveButton [if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-55629686 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 3 | SCP0009_Shipment_Plan_FG.cs:3671 | if (division == null \|\| division.ToString() == "") | RETURN | return saveYn; |  | 처리 중단/반환 |  |  |  |
| AC-c2776ece | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 3 | SCP0009_Shipment_Plan_FG.cs:3682 | try | ENDPOINT | new FoxDataRequest | ("SCP.SCP0013_GET_PLAN_TYPE_SAVE_YN") ⇒ SCP.SCP0013_GET_PLAN_TYPE_SAVE_YN | 엔드포인트 요청 생성 |  |  |  |
| AC-541d7a01 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 3 | SCP0009_Shipment_Plan_FG.cs:3683 | try | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-c4e15768 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 3 | SCP0009_Shipment_Plan_FG.cs:3684 | try | DATA_OP | request.Parameters["p_start_yyyymmdd"] | p_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-f92f300c | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 3 | SCP0009_Shipment_Plan_FG.cs:3685 | try | DATA_OP | request.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-100cbd34 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 3 | SCP0009_Shipment_Plan_FG.cs:3687 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-0005da00 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 3 | SCP0009_Shipment_Plan_FG.cs:3697 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6e76911e | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 3 | SCP0009_Shipment_Plan_FG.cs:3702 | if (!saveYn) | MESSAGE | MessageHelper.GMessageBox | ("MSG00182") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-85955ce9 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 3 | SCP0009_Shipment_Plan_FG.cs:3704 |  | RETURN | return saveYn; |  | 처리 중단/반환 |  |  |  |

## SCP0009_Shipment_Plan_FG.GetBucketType

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2274dd11 | this.Load | SCP0009_Shipment_Plan_FG.cs:537 |  | ENDPOINT | new FoxDataRequest | ("DM.DM0003_GET_BUCKET_TYPE_CODE") ⇒ DM.DM0003_GET_BUCKET_TYPE_CODE | 엔드포인트 요청 생성 |  |  |  |
| AC-2aae9445 | this.Load | SCP0009_Shipment_Plan_FG.cs:538 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-6da2d388 | this.Load | SCP0009_Shipment_Plan_FG.cs:540 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SCP0009_Shipment_Plan_FG.GetDayRange

진입점: this.Load / this.btnW26.Click / this.btnW52.Click / this.btnWLast.Click [if (success)] / cboPlanDate.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dd66bd05 | this.Load 외 4 | SCP0009_Shipment_Plan_FG.cs:4057 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCM0001_GET_SCP_DAY_PERIOD") ⇒ SCP.SCM0001_GET_SCP_DAY_PERIOD | 엔드포인트 요청 생성 |  |  |  |
| AC-4f622bc9 | this.Load 외 4 | SCP0009_Shipment_Plan_FG.cs:4058 |  | DATA_OP | request.Parameters["p_from_date"] | p_plan_start_date == null ? "" : p_plan_start_date | 행/컬럼 값 대입 |  |  |  |
| AC-a8f9f08c | this.Load 외 4 | SCP0009_Shipment_Plan_FG.cs:4059 |  | DATA_OP | request.Parameters["p_offset_day"] | Convert.ToInt32(periodType) * 7 - 1 | 행/컬럼 값 대입 |  |  |  |
| AC-dfd46ca1 | this.Load 외 4 | SCP0009_Shipment_Plan_FG.cs:4060 |  | DATA_OP | request.Parameters["p_timezone"] | UserInfoContext.Current[UserInfoProperites.TimeZone] | 행/컬럼 값 대입 |  |  |  |
| AC-733f7dd6 | this.Load 외 4 | SCP0009_Shipment_Plan_FG.cs:4061 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-5a70883b | this.Load 외 4 | SCP0009_Shipment_Plan_FG.cs:4063 |  | RETURN | return sDayRange; |  | 처리 중단/반환 |  |  |  |

## SCP0009_Shipment_Plan_FG.GetErrorMandatorySheetColumn

진입점: EditButton [if (fps != null)] / SaveButton [if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-72daf4ab | EditButton [if (fps != null)] 외 1 | SCP0009_Shipment_Plan_FG.cs:2698 |  | RETURN | return errorCols; |  | 처리 중단/반환 |  |  |  |

## SCP0009_Shipment_Plan_FG.GetFilterStr

진입점: this.spdMain.CellClick [if ((e.Column == siMain.GetColumnIndex(DefMain.TRANSPORT_MODE) \|\| e.Column == siMain.GetColumnIndex(DefMain.FROM_SITE_NAME))…) ▸ for (nRow < siMain.ActiveSheet.Rows.Count) ▸ if (measure.Equals("SHIP_PLAN_AMEND"))] / this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock(siMain.SheetName)) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ if (iCount > 0) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Equals("S")) ▸ try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ if (dsBinding.Tables[2].Rows.Count>0) ▸ for (nRow …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-55234d51 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… 외 6 | SCP0009_Shipment_Plan_FG.cs:1645 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0009_Shipment_Plan_FG.GetIsEditable

진입점: this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock(siMain.SheetName)) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ if (iCount > 0) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Equals("S")) ▸ try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ if (CommonUtils.CheckDataEmpty(dsBinding.Tables[1]) == false)] / this.btnUnfix.Click [if (fps != null) ▸ else of (siMain.IsLock(siMain.SheetName)) ▸ if (MessageHelper.GMessageBox("MSG00016") == DialogResult.Yes) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ if (iCount > 0) ▸ try ▸ if …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f3a55e30 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0009_Shipment_Plan_FG.cs:3532 | if (CommonUtils.CheckDataEmpty(dtEditable)) | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |
| AC-0df81338 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0009_Shipment_Plan_FG.cs:3547 | if (isEditTable.Equals("N") \|\| curPlanType.Equals("FN") \|\| curPlanType.Equals("TE")) | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |
| AC-871ddab9 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0009_Shipment_Plan_FG.cs:3570 | if (curPlanType.Equals("PR")) | DATA_OP | dtEditable.Select | ("plan_type_seq = '1'") | 데이터 객체 조작/조회 |  |  |  |
| AC-1fc88b11 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0009_Shipment_Plan_FG.cs:3604 | if (curPlanType.Equals("PR")) | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |
| AC-c91292a7 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0009_Shipment_Plan_FG.cs:3610 | else of (curPlanType.Equals("PR")) ▸ if (curPlanType.Equals("MA")) | DATA_OP | dtEditable.Select | ("plan_type_seq = '2'") | 데이터 객체 조작/조회 |  |  |  |
| AC-1d74dfff | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0009_Shipment_Plan_FG.cs:3622 | else of (curPlanType.Equals("PR")) ▸ if (curPlanType.Equals("MA")) ▸ else of (founded.Length > 0) | DATA_OP | dtEditable.Select | ("plan_start_yyyymmdd = '" + curPlanStartYYYYMMDD.ToString() + "' and plan_type= '" + curP… | 데이터 객체 조작/조회 |  |  |  |
| AC-f47268b4 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0009_Shipment_Plan_FG.cs:3634 | else of (curPlanType.Equals("PR")) ▸ if (curPlanType.Equals("MA")) | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |
| AC-e48288bb | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0009_Shipment_Plan_FG.cs:3640 | else of (curPlanType.Equals("PR")) ▸ else of (curPlanType.Equals("MA")) ▸ if (curPlanType.Equals("SE")) | DATA_OP | dtEditable.Select | ("plan_type_seq = '3'") | 데이터 객체 조작/조회 |  |  |  |
| AC-62116a82 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0009_Shipment_Plan_FG.cs:3655 | else of (curPlanType.Equals("PR")) ▸ else of (curPlanType.Equals("MA")) ▸ if (curPlanType.Equals("SE")) | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |
| AC-5e6b1593 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 4 | SCP0009_Shipment_Plan_FG.cs:3658 |  | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |

## SCP0009_Shipment_Plan_FG.GetLastRange

진입점: this.Load / cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-41688a52 | this.Load 외 1 | SCP0009_Shipment_Plan_FG.cs:4043 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCM0001_GET_SCP_DAILY_PLAN_PERIOD") ⇒ SCP.SCM0001_GET_SCP_DAILY_PLAN_PERIOD | 엔드포인트 요청 생성 |  |  |  |
| AC-f2bf85da | this.Load 외 1 | SCP0009_Shipment_Plan_FG.cs:4044 |  | DATA_OP | request.Parameters["p_division_id"] | divisionId | 행/컬럼 값 대입 |  |  |  |
| AC-fdd6dae4 | this.Load 외 1 | SCP0009_Shipment_Plan_FG.cs:4045 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-93d356b1 | this.Load 외 1 | SCP0009_Shipment_Plan_FG.cs:4047 |  | RETURN | return dailyPlanPeriod; |  | 처리 중단/반환 |  |  |  |

## SCP0009_Shipment_Plan_FG.GetNewInsertRowIndex

진입점: this.spdMain.CellClick [if ((e.Column == siMain.GetColumnIndex(DefMain.TRANSPORT_MODE) \|\| e.Column == siMain.GetColumnIndex(DefMain.FROM_SITE_NAME))…) ▸ if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (chosedFromSite.ToString() == popupReturnSite)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-be51c0b0 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0009_Shipment_Plan_FG.cs:2635 |  | RETURN | return retIndex; |  | 처리 중단/반환 |  |  |  |

## SCP0009_Shipment_Plan_FG.GetSpdTitle

진입점: this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] / this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >= 0) ▸ if (siMain.GetValue(e.Row, siMain.GetColumnIndex(DefMain.MEASURE)).ToString().Equals("MKT_FCST")) ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / this.cboBucketType.SelectedIndexChanged [else of (chkAll.Checked) ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock(siMain.SheetName)) ▸ if (fps.Name == "spdMa…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4d2e3b94 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0009_Shipment_Plan_FG.cs:4011 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN") ⇒ SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | 엔드포인트 요청 생성 |  |  |  |
| AC-67206a4d | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0009_Shipment_Plan_FG.cs:4012 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-7e4a2e3a | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0009_Shipment_Plan_FG.cs:4013 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-3f5c4d27 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0009_Shipment_Plan_FG.cs:4015 |  | FLAG | dsSpdTitle | client.ExecuteDataSet(request).DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-96c2f6ad | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0009_Shipment_Plan_FG.cs:4015 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## SCP0009_Shipment_Plan_FG.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1960c264 | this.Load | SCP0009_Shipment_Plan_FG.cs:464 | if (dtDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |
| AC-8d439622 | this.Load | SCP0009_Shipment_Plan_FG.cs:466 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-a305cbfc | this.Load | SCP0009_Shipment_Plan_FG.cs:469 |  | DATA_OP | this.ConditionNotUseList.Add | (cboPlanDate) | 데이터 객체 조작/조회 |  |  |  |
| AC-c06ba604 | this.Load | SCP0009_Shipment_Plan_FG.cs:470 |  | DATA_OP | this.ConditionNotUseList.Add | (cboPlanType) | 데이터 객체 조작/조회 |  |  |  |
| AC-a3ef3e6c | this.Load | SCP0009_Shipment_Plan_FG.cs:471 |  | DATA_OP | this.ConditionNotUseList.Add | (cboPlanSeq) | 데이터 객체 조작/조회 |  |  |  |
| AC-526e22e5 | this.Load | SCP0009_Shipment_Plan_FG.cs:474 |  | DATA_OP | dtDivision.Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-63d734fe | this.Load | SCP0009_Shipment_Plan_FG.cs:475 |  | DATA_OP | tmpDivision.Columns.Add | ("SORT_ORDER") | 데이터 객체 조작/조회 |  |  |  |
| AC-2efcb099 | this.Load | SCP0009_Shipment_Plan_FG.cs:476 |  | CALL_EXT | tmpDivision.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-a69e6ba7 | this.Load | SCP0009_Shipment_Plan_FG.cs:480 | foreach (DataRow dr in dtDivision.Rows) | DATA_OP | tmpDivision.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-0b952b61 | this.Load | SCP0009_Shipment_Plan_FG.cs:481 | foreach (DataRow dr in dtDivision.Rows) | DATA_OP | dataRow["CODE"] | dr["CODE"] | 행/컬럼 값 대입 |  |  |  |
| AC-859a2711 | this.Load | SCP0009_Shipment_Plan_FG.cs:482 | foreach (DataRow dr in dtDivision.Rows) | DATA_OP | dataRow["NAME"] | dr["NAME"] | 행/컬럼 값 대입 |  |  |  |
| AC-f62ed20c | this.Load | SCP0009_Shipment_Plan_FG.cs:483 | foreach (DataRow dr in dtDivision.Rows) | DATA_OP | dataRow["SORT_ORDER"] | dr["CODE"].ToString() == "81" ? 1 : dr["CODE"].ToString() == "40" ? 2 : 3 | 행/컬럼 값 대입 |  |  |  |
| AC-fce5d874 | this.Load | SCP0009_Shipment_Plan_FG.cs:485 | foreach (DataRow dr in dtDivision.Rows) | CALL_EXT | tmpDivision.Rows.InsertAt | (dataRow, 0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-645dbf08 | this.Load | SCP0009_Shipment_Plan_FG.cs:488 |  | UI_PROP | tmpDivision.DefaultView.Sort | "SORT_ORDER Asc" | 속성 Sort 설정 |  |  |  |
| AC-b7092080 | this.Load | SCP0009_Shipment_Plan_FG.cs:489 |  | DATA_OP | tmpDivision.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-d9c0bad1 | this.Load | SCP0009_Shipment_Plan_FG.cs:491 |  | DATA_OP | tmpDivision.DefaultView.ToTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-89dd9cc6 | this.Load | SCP0009_Shipment_Plan_FG.cs:493 |  | STATE_RESET | dtDivision.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-e2d2a520 | this.Load | SCP0009_Shipment_Plan_FG.cs:494 |  | FLAG | dtDivision | dtDivisionOrder.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-7b08c1bf | this.Load | SCP0009_Shipment_Plan_FG.cs:494 |  | DATA_OP | dtDivisionOrder.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-5f82a0fc | this.Load | SCP0009_Shipment_Plan_FG.cs:497 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, cboDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-a7f7e0bc | this.Load | SCP0009_Shipment_Plan_FG.cs:499 |  | FLAG | dtOperGrp | Data.Common(Data.Type.LookupCommon, false, "OPERATION_GROUP") ⇒ biz:CommonData.CommonDataList [code=LookupCommon] | 화면 필드/플래그 변경 |  |  |  |
| AC-ca0a41bd | this.Load | SCP0009_Shipment_Plan_FG.cs:499 |  | COMBO_DATA | Data.Common | (Data.Type.LookupCommon, false, "OPERATION_GROUP") ⇒ biz:CommonData.CommonDataList [code=LookupCommon] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-40a8144e | this.Load | SCP0009_Shipment_Plan_FG.cs:500 |  | LIST_REBIND | clsCtrl.setListBox | (dtOperGrp, cboBizType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-8e2dbc7c | this.Load | SCP0009_Shipment_Plan_FG.cs:502 |  | FLAG | dtElecType | Data.Common(Data.Type.LookupCommon, false, "ELECTRODE_TYPE") ⇒ biz:CommonData.CommonDataList [code=LookupCommon] | 화면 필드/플래그 변경 |  |  |  |
| AC-d1792d89 | this.Load | SCP0009_Shipment_Plan_FG.cs:502 |  | COMBO_DATA | Data.Common | (Data.Type.LookupCommon, false, "ELECTRODE_TYPE") ⇒ biz:CommonData.CommonDataList [code=LookupCommon] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-3681942b | this.Load | SCP0009_Shipment_Plan_FG.cs:503 |  | LIST_REBIND | clsCtrl.setListBox | (dtElecType, clbElecType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-baff48f8 | this.Load | SCP0009_Shipment_Plan_FG.cs:510 |  | VALUE_SET | dCalendar.InitValue | GetDayRange(PeriodType.W52) | 컨트롤 값 설정 |  |  |  |
| AC-3ade0381 | this.Load | SCP0009_Shipment_Plan_FG.cs:512 |  | FLAG | dtBucketType | GetBucketType() | 화면 필드/플래그 변경 |  |  |  |
| AC-85dbb5dc | this.Load | SCP0009_Shipment_Plan_FG.cs:513 |  | LIST_REBIND | clsCtrl.setListBox | (dtBucketType, cboBucketType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-6de29ebb | this.Load | SCP0009_Shipment_Plan_FG.cs:519 |  | FLAG | dtTeam | Data.UserTeamByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.Use… | 화면 필드/플래그 변경 |  |  |  |
| AC-21898889 | this.Load | SCP0009_Shipment_Plan_FG.cs:519 |  | COMBO_DATA | Data.UserTeamByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, division) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-6678daa7 | this.Load | SCP0009_Shipment_Plan_FG.cs:520 |  | LIST_REBIND | clsCtrl.setListBox | (dtTeam, clbTeam, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-1730be23 | this.Load | SCP0009_Shipment_Plan_FG.cs:528 | if (dailyPlanPeriod == PeriodType.W52) | UI_PROP | layoutBtnWLast.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-261f1e8a | this.Load | SCP0009_Shipment_Plan_FG.cs:531 |  | VALUE_SET | btnWLast.Text | "W" + dailyPlanPeriod | 컨트롤 값 설정 |  |  |  |

## SCP0009_Shipment_Plan_FG.InitSpread_2

진입점: this.Load / this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >= 0) ▸ if (siMain.GetValue(e.Row, siMain.GetColumnIndex(DefMain.MEASURE)).ToString().Equals("MKT_FCST"))] / this.cboBucketType.SelectedIndexChanged [else of (chkAll.Checked)] / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK)] / this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock(siMain.SheetName)) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ if (iCount > 0) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Equals("S"))] / this.btnUnfix.Click [if…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7f788a2a | this.Load 외 9 | SCP0009_Shipment_Plan_FG.cs:657 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.InitSheet | (SpdSheet.shtMain) | 그리드 재구성/초기화 |  |  |  |
| AC-11c708c1 | this.Load 외 9 | SCP0009_Shipment_Plan_FG.cs:662 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.SetSheetHeaderColumn | (spdInfo, 3) | 그리드 재구성/초기화 |  |  |  |
| AC-94427e83 | this.Load 외 9 | SCP0009_Shipment_Plan_FG.cs:666 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Columns[siMain.GetColumnIndex(DefMain.FROM_SITE_NAME)].Fon… | new Font(spdMain.Font.Name, spdMain.Font.Size, FontStyle.Bold) | 그리드 속성/값 설정 |  |  |  |
| AC-a23332d8 | this.Load 외 9 | SCP0009_Shipment_Plan_FG.cs:667 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Columns[siMain.GetColumnIndex(DefMain.TRANSPORT_MODE)].Fon… | new Font(spdMain.Font.Name, spdMain.Font.Size, FontStyle.Bold) | 그리드 속성/값 설정 |  |  |  |
| AC-ef233a33 | this.Load 외 9 | SCP0009_Shipment_Plan_FG.cs:682 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e33b817b | this.Load 외 9 | SCP0009_Shipment_Plan_FG.cs:686 | if (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (!division.Substring(0, 2).Equals("EE")) | GRID_SET | spdInfo.ActiveSheet.Columns[siMain.GetColumnIndex("ORIGIN_TO_DIVISION_ID")].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-9b5348d4 | this.Load 외 9 | SCP0009_Shipment_Plan_FG.cs:687 | if (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (!division.Substring(0, 2).Equals("EE")) | GRID_SET | spdInfo.ActiveSheet.Columns[siMain.GetColumnIndex("ELECTRODE_TYPE")].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-88da4d3b | this.Load 외 9 | SCP0009_Shipment_Plan_FG.cs:688 | if (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (!division.Substring(0, 2).Equals("EE")) | GRID_SET | spdInfo.ActiveSheet.Columns[siMain.GetColumnIndex("ORIGIN_FROM_DIVISION_ID")].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-137d894a | this.Load 외 9 | SCP0009_Shipment_Plan_FG.cs:692 | if (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (!division.Substring(0, 2).Equals("EE")) | GRID_SET | spdInfo.ActiveSheet.Columns[siMain.GetColumnIndex("ORIGIN_TO_DIVISION_ID")].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-84d62682 | this.Load 외 9 | SCP0009_Shipment_Plan_FG.cs:693 | if (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (!division.Substring(0, 2).Equals("EE")) | GRID_SET | spdInfo.ActiveSheet.Columns[siMain.GetColumnIndex("ELECTRODE_TYPE")].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-7ea36ca5 | this.Load 외 9 | SCP0009_Shipment_Plan_FG.cs:694 | if (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (!division.Substring(0, 2).Equals("EE")) | GRID_SET | spdInfo.ActiveSheet.Columns[siMain.GetColumnIndex("ORIGIN_FROM_DIVISION_ID")].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-80afb99f | this.Load 외 9 | SCP0009_Shipment_Plan_FG.cs:697 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_SET | spdInfo.ActiveSheet.Columns[spdInfo.GetColumnIndex("EXTRA_SPEC")].Visible | (division == "40") | 그리드 속성/값 설정 |  |  |  |
| AC-ee275217 | this.Load 외 9 | SCP0009_Shipment_Plan_FG.cs:701 | if (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (!division.Equals("40")) | GRID_SET | spdInfo.ActiveSheet.Columns[siMain.GetColumnIndex("product_group")].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-6b642c7f | this.Load 외 9 | SCP0009_Shipment_Plan_FG.cs:702 | if (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (!division.Equals("40")) | GRID_SET | spdInfo.ActiveSheet.Columns[siMain.GetColumnIndex("cell_model")].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-b5c0e7cf | this.Load 외 9 | SCP0009_Shipment_Plan_FG.cs:703 | if (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (!division.Equals("40")) | GRID_SET | spdInfo.ActiveSheet.Columns[siMain.GetColumnIndex("cell_pack_count")].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-843e7bfa | this.Load 외 9 | SCP0009_Shipment_Plan_FG.cs:704 | if (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (!division.Equals("40")) | GRID_SET | spdInfo.ActiveSheet.Columns[siMain.GetColumnIndex("application")].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-71c7a00d | this.Load 외 9 | SCP0009_Shipment_Plan_FG.cs:705 | if (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (!division.Equals("40")) | GRID_SET | spdInfo.ActiveSheet.Columns[siMain.GetColumnIndex("min_capacity")].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-3cae0997 | this.Load 외 9 | SCP0009_Shipment_Plan_FG.cs:706 | if (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (!division.Equals("40")) | GRID_SET | spdInfo.ActiveSheet.Columns[siMain.GetColumnIndex("soldto_customer")].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-3606031c | this.Load 외 9 | SCP0009_Shipment_Plan_FG.cs:707 | if (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (!division.Equals("40")) | GRID_SET | spdInfo.ActiveSheet.Columns[siMain.GetColumnIndex("model_spec")].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-5de48706 | this.Load 외 9 | SCP0009_Shipment_Plan_FG.cs:708 | if (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (!division.Equals("40")) | GRID_SET | spdInfo.ActiveSheet.Columns[siMain.GetColumnIndex("model_version")].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-680da322 | this.Load 외 9 | SCP0009_Shipment_Plan_FG.cs:709 | if (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (!division.Equals("40")) | GRID_SET | spdInfo.ActiveSheet.Columns[siMain.GetColumnIndex("spec_version")].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-935db6db | this.Load 외 9 | SCP0009_Shipment_Plan_FG.cs:713 | if (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (!division.Equals("40")) | GRID_SET | spdInfo.ActiveSheet.Columns[siMain.GetColumnIndex("product_group")].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-daed290a | this.Load 외 9 | SCP0009_Shipment_Plan_FG.cs:714 | if (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (!division.Equals("40")) | GRID_SET | spdInfo.ActiveSheet.Columns[siMain.GetColumnIndex("cell_model")].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-8427d799 | this.Load 외 9 | SCP0009_Shipment_Plan_FG.cs:715 | if (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (!division.Equals("40")) | GRID_SET | spdInfo.ActiveSheet.Columns[siMain.GetColumnIndex("cell_pack_count")].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-146646db | this.Load 외 9 | SCP0009_Shipment_Plan_FG.cs:716 | if (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (!division.Equals("40")) | GRID_SET | spdInfo.ActiveSheet.Columns[siMain.GetColumnIndex("application")].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-ffe76c02 | this.Load 외 9 | SCP0009_Shipment_Plan_FG.cs:717 | if (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (!division.Equals("40")) | GRID_SET | spdInfo.ActiveSheet.Columns[siMain.GetColumnIndex("min_capacity")].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-4449bc0e | this.Load 외 9 | SCP0009_Shipment_Plan_FG.cs:718 | if (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (!division.Equals("40")) | GRID_SET | spdInfo.ActiveSheet.Columns[siMain.GetColumnIndex("soldto_customer")].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-629eca46 | this.Load 외 9 | SCP0009_Shipment_Plan_FG.cs:719 | if (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (!division.Equals("40")) | GRID_SET | spdInfo.ActiveSheet.Columns[siMain.GetColumnIndex("model_spec")].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-1d8aff4c | this.Load 외 9 | SCP0009_Shipment_Plan_FG.cs:720 | if (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (!division.Equals("40")) | GRID_SET | spdInfo.ActiveSheet.Columns[siMain.GetColumnIndex("model_version")].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-76be9398 | this.Load 외 9 | SCP0009_Shipment_Plan_FG.cs:721 | if (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (!division.Equals("40")) | GRID_SET | spdInfo.ActiveSheet.Columns[siMain.GetColumnIndex("spec_version")].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-26156d45 | this.Load 외 9 | SCP0009_Shipment_Plan_FG.cs:725 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (spdInfo.SheetName == SpdSheet.shtPeggingInfo) | GRID_INIT | spdInfo.InitSheet | (SpdSheet.shtPeggingInfo) | 그리드 재구성/초기화 |  |  |  |
| AC-bdd61266 | this.Load 외 9 | SCP0009_Shipment_Plan_FG.cs:726 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (spdInfo.SheetName == SpdSheet.shtPeggingInfo) | GRID_INIT | siPeggingInfo.SetSheetHeaderColumn | (spdInfo, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-ca41c7e5 | this.Load 외 9 | SCP0009_Shipment_Plan_FG.cs:727 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (spdInfo.SheetName == SpdSheet.shtPeggingInfo) | GRID_INIT | spdInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-7dec1924 | this.Load 외 9 | SCP0009_Shipment_Plan_FG.cs:731 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (spdInfo.SheetName == SpdSheet.shtPeggingInfo) ▸ if (!division.Substring(0, 2).Equals("… | GRID_SET | spdInfo.ActiveSheet.Columns[siPeggingInfo.GetColumnIndex("ELECTRODE_TYPE")].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-4357374c | this.Load 외 9 | SCP0009_Shipment_Plan_FG.cs:732 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (spdInfo.SheetName == SpdSheet.shtPeggingInfo) ▸ if (!division.Substring(0, 2).Equals("… | GRID_SET | spdInfo.ActiveSheet.Columns[siPeggingInfo.GetColumnIndex("ORIGIN_FROM_DIVISION_ID")].Visib… | false | 그리드 속성/값 설정 |  |  |  |
| AC-c4e56275 | this.Load 외 9 | SCP0009_Shipment_Plan_FG.cs:733 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (spdInfo.SheetName == SpdSheet.shtPeggingInfo) ▸ if (!division.Substring(0, 2).Equals("… | GRID_SET | spdInfo.ActiveSheet.Columns[siPeggingInfo.GetColumnIndex("ORIGIN_TO_DIVISION_ID")].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-51074128 | this.Load 외 9 | SCP0009_Shipment_Plan_FG.cs:737 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (spdInfo.SheetName == SpdSheet.shtPeggingInfo) ▸ else of (!division.Substring(0, 2).Equ… | GRID_SET | spdInfo.ActiveSheet.Columns[siPeggingInfo.GetColumnIndex("ELECTRODE_TYPE")].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-c5d5cfc5 | this.Load 외 9 | SCP0009_Shipment_Plan_FG.cs:738 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (spdInfo.SheetName == SpdSheet.shtPeggingInfo) ▸ else of (!division.Substring(0, 2).Equ… | GRID_SET | spdInfo.ActiveSheet.Columns[siPeggingInfo.GetColumnIndex("ORIGIN_FROM_DIVISION_ID")].Visib… | true | 그리드 속성/값 설정 |  |  |  |
| AC-53d86868 | this.Load 외 9 | SCP0009_Shipment_Plan_FG.cs:739 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (spdInfo.SheetName == SpdSheet.shtPeggingInfo) ▸ else of (!division.Substring(0, 2).Equ… | GRID_SET | spdInfo.ActiveSheet.Columns[siPeggingInfo.GetColumnIndex("ORIGIN_TO_DIVISION_ID")].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-31d94d65 | this.Load 외 9 | SCP0009_Shipment_Plan_FG.cs:744 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPeggingInfo) ▸ if (spdInfo.SheetName == SpdSheet… | GRID_INIT | spdInfo.InitSheet | (SpdSheet.shtPlanProblem) | 그리드 재구성/초기화 |  |  |  |
| AC-646e3e03 | this.Load 외 9 | SCP0009_Shipment_Plan_FG.cs:745 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPeggingInfo) ▸ if (spdInfo.SheetName == SpdSheet… | GRID_INIT | siPlanProblem.SetSheetHeaderColumn | (spdInfo, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-697db55d | this.Load 외 9 | SCP0009_Shipment_Plan_FG.cs:746 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPeggingInfo) ▸ if (spdInfo.SheetName == SpdSheet… | GRID_INIT | spdInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCP0009_Shipment_Plan_FG.InitSpreadDateColumn

진입점: this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] / this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >= 0) ▸ if (siMain.GetValue(e.Row, siMain.GetColumnIndex(DefMain.MEASURE)).ToString().Equals("MKT_FCST")) ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / this.cboBucketType.SelectedIndexChanged [else of (chkAll.Checked) ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock(siMain.SheetName)) ▸ if (fps.Name == "spdMa…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7dfbe680 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0009_Shipment_Plan_FG.cs:901 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sColumnName.IndexOf("B_") > 0) | GRID_INIT | spdInfo.AddTextColumn | (sColumnLabelname, sColumnName, FPMerge.None, 0, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-96c26676 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0009_Shipment_Plan_FG.cs:904 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sColumnName.IndexOf("B_") > 0) | GRID_INIT | spdInfo.AddNumColumn | (sColumnLabelname, sColumnName, FPMerge.None, 70, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-55199041 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0009_Shipment_Plan_FG.cs:905 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sColumnName.IndexOf("B_") > 0) | GRID_INIT | spdInfo.SetReNumerCellType | (spdInfo, spdInfo.GetColumnIndex(sColumnName)) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-c0c06ad8 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0009_Shipment_Plan_FG.cs:908 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sColumnName.IndexOf("B_") > 0) ▸ if (sDayCode == DefMainLabel.Saturday \|\| sDa… | GRID_SET | spdInfo.Sheet().ColumnHeader.Cells[2, spdInfo.GetMaxColumnIndex()].ForeColor | sDayCode == DefMainLabel.Saturday ? Color.Blue : Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-183675dc | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0009_Shipment_Plan_FG.cs:914 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b5ef8fdd | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0009_Shipment_Plan_FG.cs:915 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-eca84aa9 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0009_Shipment_Plan_FG.cs:920 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3c25cab9 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0009_Shipment_Plan_FG.cs:921 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 30, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-91312c85 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0009_Shipment_Plan_FG.cs:928 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName != sSmallLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c1d0db39 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0009_Shipment_Plan_FG.cs:929 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName != sSmallLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-724f18d7 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0009_Shipment_Plan_FG.cs:939 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-39d408a7 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0009_Shipment_Plan_FG.cs:940 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0a136806 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0009_Shipment_Plan_FG.cs:941 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-616e7568 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0009_Shipment_Plan_FG.cs:942 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0009_Shipment_Plan_FG.InsertRow

진입점: this.spdMain.CellClick [if ((e.Column == siMain.GetColumnIndex(DefMain.TRANSPORT_MODE) \|\| e.Column == siMain.GetColumnIndex(DefMain.FROM_SITE_NAME))…)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2fd2dc7f | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0009_Shipment_Plan_FG.cs:2046 |  | DATA_OP | dsBinding.Tables[0].Select() .Where(c => c[DefMain.KEY_IDX].ToString() == key_idx.ToString… | () | 데이터 객체 조작/조회 |  |  |  |
| AC-d621f8d6 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0009_Shipment_Plan_FG.cs:2046 |  | DATA_OP | dsBinding.Tables[0].Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-fb718cd3 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0009_Shipment_Plan_FG.cs:2054 |  | POPUP | new SCM0002_GetBODPopup | (dtCaller, 0, this._plan_Start_Date) | 팝업/폼 생성 |  |  |  |
| AC-f5b77863 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0009_Shipment_Plan_FG.cs:2055 |  | UI_PROP | popup.Width | 1050 | 속성 Width 설정 |  |  |  |
| AC-8ea3f5d4 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0009_Shipment_Plan_FG.cs:2056 |  | UI_PROP | popup.Height | 350 | 속성 Height 설정 |  |  |  |
| AC-2bf1b254 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0009_Shipment_Plan_FG.cs:2057 |  | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-f44210a2 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0009_Shipment_Plan_FG.cs:2065 |  | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-a8bc2b91 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0009_Shipment_Plan_FG.cs:2067 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (popup.retList.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9d63708d | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0009_Shipment_Plan_FG.cs:2092 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (chosedFromSite.ToString() == popupReturnSite) | DATA_OP | dtCaller.Select().Where(c => c[DefMain.MEASURE].ToString().Contains("SHIP_") && c[DefMain.… | () | 데이터 객체 조작/조회 |  |  |  |
| AC-862c7db3 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0009_Shipment_Plan_FG.cs:2092 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (chosedFromSite.ToString() == popupReturnSite) | DATA_OP | dtCaller.Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-25756b21 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0009_Shipment_Plan_FG.cs:2092 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (chosedFromSite.ToString() == popupReturnSite) ▸ lambda | DATA_OP | c[DefMain.MEASURE].ToString().Contains | ("SHIP_") | 데이터 객체 조작/조회 |  |  |  |
| AC-e3480c4a | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0009_Shipment_Plan_FG.cs:2101 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (chosedFromSite.ToString() == popupReturnSite) ▸ foreac… | CALL_EXT | siMain.InsertNewRow | (insertStartIdx) | ⚠ 의미 확인 필요 |  |  |  |
| AC-0eb83497 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0009_Shipment_Plan_FG.cs:2103 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (chosedFromSite.ToString() == popupReturnSite) ▸ foreac… | DATA_OP | defaultData.Add | (DefMain.DIVISION_ID, dr["division_id"]) | 데이터 객체 조작/조회 |  |  |  |
| AC-6c4fac5e | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0009_Shipment_Plan_FG.cs:2104 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (chosedFromSite.ToString() == popupReturnSite) ▸ foreac… | DATA_OP | defaultData.Add | (DefMain.BIZ_TYPE_NAME, dr["BIZ_TYPE_NAME"]) | 데이터 객체 조작/조회 |  |  |  |
| AC-aae9f5e0 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0009_Shipment_Plan_FG.cs:2105 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (chosedFromSite.ToString() == popupReturnSite) ▸ foreac… | DATA_OP | defaultData.Add | (DefMain.ITEM_ID, dr["ITEM_ID"]) | 데이터 객체 조작/조회 |  |  |  |
| AC-3771caf0 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0009_Shipment_Plan_FG.cs:2106 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (chosedFromSite.ToString() == popupReturnSite) ▸ foreac… | DATA_OP | defaultData.Add | (DefMain.NICK_NAME, dr["NICK_NAME"]) | 데이터 객체 조작/조회 |  |  |  |
| AC-2755e296 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0009_Shipment_Plan_FG.cs:2109 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (chosedFromSite.ToString() == popupReturnSite) ▸ foreac… | DATA_OP | defaultData.Add | (DefMain.ELECTRODE_TYPE , dr["ELECTRODE_TYPE"]) | 데이터 객체 조작/조회 |  |  |  |
| AC-daf03efc | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0009_Shipment_Plan_FG.cs:2112 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (chosedFromSite.ToString() == popupReturnSite) ▸ foreac… | DATA_OP | defaultData.Add | (DefMain.ORIGIN_TO_DIVISION_ID, dr["ORIGIN_TO_DIVISION_ID"]) | 데이터 객체 조작/조회 |  |  |  |
| AC-8555d6b5 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0009_Shipment_Plan_FG.cs:2114 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (chosedFromSite.ToString() == popupReturnSite) ▸ foreac… | DATA_OP | defaultData.Add | (DefMain.TO_SITE_NAME, bod.first_site_name) | 데이터 객체 조작/조회 |  |  |  |
| AC-8c718bd4 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0009_Shipment_Plan_FG.cs:2116 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (chosedFromSite.ToString() == popupReturnSite) ▸ foreac… | DATA_OP | defaultData.Add | (DefMain.BOH, dr["BOH"]) | 데이터 객체 조작/조회 |  |  |  |
| AC-86ac7fde | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0009_Shipment_Plan_FG.cs:2117 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (chosedFromSite.ToString() == popupReturnSite) ▸ foreac… | DATA_OP | defaultData.Add | (DefMain.INCOTERMS, bod.incoterms) | 데이터 객체 조작/조회 |  |  |  |
| AC-61b944c0 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0009_Shipment_Plan_FG.cs:2118 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (chosedFromSite.ToString() == popupReturnSite) ▸ foreac… | DATA_OP | defaultData.Add | (DefMain.PROJECT_CODE, dr["PROJECT_CODE"]) | 데이터 객체 조작/조회 |  |  |  |
| AC-f3098ded | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0009_Shipment_Plan_FG.cs:2121 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (chosedFromSite.ToString() == popupReturnSite) ▸ foreac… | DATA_OP | defaultData.Add | (DefMain.ORIGIN_FROM_DIVISION_ID , dr["ORIGIN_FROM_DIVISION_ID"]) | 데이터 객체 조작/조회 |  |  |  |
| AC-87756796 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0009_Shipment_Plan_FG.cs:2123 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (chosedFromSite.ToString() == popupReturnSite) ▸ foreac… | DATA_OP | defaultData.Add | (DefMain.FROM_SITE_NAME, bod.second_site_name) | 데이터 객체 조작/조회 |  |  |  |
| AC-ec4f7999 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0009_Shipment_Plan_FG.cs:2124 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (chosedFromSite.ToString() == popupReturnSite) ▸ foreac… | DATA_OP | defaultData.Add | (DefMain.TRANSPORT_MODE, bod.transport_mode) | 데이터 객체 조작/조회 |  |  |  |
| AC-d6e9c8ca | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0009_Shipment_Plan_FG.cs:2126 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (chosedFromSite.ToString() == popupReturnSite) ▸ foreac… | DATA_OP | defaultData.Add | (DefMain.LT_DAY, bod.lt_total) | 데이터 객체 조작/조회 |  |  |  |
| AC-d69e1030 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0009_Shipment_Plan_FG.cs:2127 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (chosedFromSite.ToString() == popupReturnSite) ▸ foreac… | DATA_OP | defaultData.Add | (DefMain.MEASURE_LABEL, dr["MEASURE_LABEL"]) | 데이터 객체 조작/조회 |  |  |  |
| AC-818023b5 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0009_Shipment_Plan_FG.cs:2128 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (chosedFromSite.ToString() == popupReturnSite) ▸ foreac… | DATA_OP | defaultData.Add | (DefMain.MEASURE, dr["measure"]) | 데이터 객체 조작/조회 |  |  |  |
| AC-8ea7c957 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0009_Shipment_Plan_FG.cs:2129 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (chosedFromSite.ToString() == popupReturnSite) ▸ foreac… | DATA_OP | defaultData.Add | (DefMain.BOD_ID, bod.bod_id) | 데이터 객체 조작/조회 |  |  |  |
| AC-0d1c1b54 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0009_Shipment_Plan_FG.cs:2130 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (chosedFromSite.ToString() == popupReturnSite) ▸ foreac… | DATA_OP | defaultData.Add | (DefMain.KEY_IDX, dr["key_idx"]) | 데이터 객체 조작/조회 |  |  |  |
| AC-f626ac2f | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0009_Shipment_Plan_FG.cs:2132 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (chosedFromSite.ToString() == popupReturnSite) ▸ foreac… | DATA_OP | defaultData.Add | (DefMain.BIZ_TYPE, dr["biz_type"]) | 데이터 객체 조작/조회 |  |  |  |
| AC-e568e58a | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0009_Shipment_Plan_FG.cs:2133 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (chosedFromSite.ToString() == popupReturnSite) ▸ foreac… | DATA_OP | defaultData.Add | (DefMain.TO_SITE, bod.first_site) | 데이터 객체 조작/조회 |  |  |  |
| AC-918a70ca | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0009_Shipment_Plan_FG.cs:2134 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (chosedFromSite.ToString() == popupReturnSite) ▸ foreac… | DATA_OP | defaultData.Add | (DefMain.FROM_SITE, bod.second_site) | 데이터 객체 조작/조회 |  |  |  |
| AC-3a03d2f2 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0009_Shipment_Plan_FG.cs:2135 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (chosedFromSite.ToString() == popupReturnSite) ▸ foreac… | DATA_OP | defaultData.Add | (DefMain.SHIP_FROZEN, bod.ship_frozen) | 데이터 객체 조작/조회 |  |  |  |
| AC-042260ce | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0009_Shipment_Plan_FG.cs:2136 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (chosedFromSite.ToString() == popupReturnSite) ▸ foreac… | DATA_OP | defaultData.Add | (DefMain.MEASURE_ORDER_NO, dr["MEASURE_ORDER_NO"]) | 데이터 객체 조작/조회 |  |  |  |
| AC-bb52fb69 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0009_Shipment_Plan_FG.cs:2138 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (chosedFromSite.ToString() == popupReturnSite) ▸ foreac… | DATA_OP | defaultData.Add | (DefMain.PLAN_START_YYYYMMDD, dr["plan_start_yyyymmdd"]) | 데이터 객체 조작/조회 |  |  |  |
| AC-7890b53a | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0009_Shipment_Plan_FG.cs:2139 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (chosedFromSite.ToString() == popupReturnSite) ▸ foreac… | DATA_OP | defaultData.Add | (DefMain.PLAN_TYPE, dr["plan_type"]) | 데이터 객체 조작/조회 |  |  |  |
| AC-a779feb9 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0009_Shipment_Plan_FG.cs:2140 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (chosedFromSite.ToString() == popupReturnSite) ▸ foreac… | DATA_OP | defaultData.Add | (DefMain.SEQ, dr["seq"]) | 데이터 객체 조작/조회 |  |  |  |
| AC-efc68532 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0009_Shipment_Plan_FG.cs:2141 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (chosedFromSite.ToString() == popupReturnSite) ▸ foreac… | DATA_OP | defaultData.Add | (DefMain.TO_YYYYMMDD, dr["to_yyyymmdd"]) | 데이터 객체 조작/조회 |  |  |  |
| AC-2a2c611c | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0009_Shipment_Plan_FG.cs:2142 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (chosedFromSite.ToString() == popupReturnSite) ▸ foreac… | DATA_OP | defaultData.Add | (DefMain.BOD_FROM_YYYYMMDD, bod.bod_from_yyyymmdd) | 데이터 객체 조작/조회 |  |  |  |
| AC-6b06a731 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0009_Shipment_Plan_FG.cs:2143 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (chosedFromSite.ToString() == popupReturnSite) ▸ foreac… | DATA_OP | defaultData.Add | (DefMain.BOD_TO_YYYYMMDD, bod.bod_to_yyyymmdd) | 데이터 객체 조작/조회 |  |  |  |
| AC-47faeb66 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0009_Shipment_Plan_FG.cs:2145 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (chosedFromSite.ToString() == popupReturnSite) ▸ foreac… | GRID_SET | siMain.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |
| AC-1ff6f000 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0009_Shipment_Plan_FG.cs:2164 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (chosedFromSite.ToString() == popupReturnSite) | DATA_OP | dtCaller.Select().Where(c => (c[DefMain.MEASURE].ToString().Contains("SHIP_") \|\| c[DefMa… | () | 데이터 객체 조작/조회 |  |  |  |
| AC-789e4fbd | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0009_Shipment_Plan_FG.cs:2164 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (chosedFromSite.ToString() == popupReturnSite) | DATA_OP | dtCaller.Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-fa2b01b5 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0009_Shipment_Plan_FG.cs:2164 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (chosedFromSite.ToString() == popupReturnSite) ▸ l… | DATA_OP | c[DefMain.MEASURE].ToString().Contains | ("SHIP_") | 데이터 객체 조작/조회 |  |  |  |
| AC-68cb0349 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0009_Shipment_Plan_FG.cs:2185 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (chosedFromSite.ToString() == popupReturnSite) ▸ f… | CALL_EXT | siMain.InsertNewRow | (insertStartIdx) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3d5665b5 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0009_Shipment_Plan_FG.cs:2187 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (chosedFromSite.ToString() == popupReturnSite) ▸ f… | DATA_OP | defaultData.Add | (DefMain.DIVISION_ID, row["division_id"]) | 데이터 객체 조작/조회 |  |  |  |
| AC-9c030702 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0009_Shipment_Plan_FG.cs:2188 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (chosedFromSite.ToString() == popupReturnSite) ▸ f… | DATA_OP | defaultData.Add | (DefMain.BIZ_TYPE_NAME, row["BIZ_TYPE_NAME"]) | 데이터 객체 조작/조회 |  |  |  |
| AC-2cf92732 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0009_Shipment_Plan_FG.cs:2189 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (chosedFromSite.ToString() == popupReturnSite) ▸ f… | DATA_OP | defaultData.Add | (DefMain.ITEM_ID, row["ITEM_ID"]) | 데이터 객체 조작/조회 |  |  |  |
| AC-66ccf2bf | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0009_Shipment_Plan_FG.cs:2190 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (chosedFromSite.ToString() == popupReturnSite) ▸ f… | DATA_OP | defaultData.Add | (DefMain.NICK_NAME, row["NICK_NAME"]) | 데이터 객체 조작/조회 |  |  |  |
| AC-5f1b3b3b | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0009_Shipment_Plan_FG.cs:2193 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (chosedFromSite.ToString() == popupReturnSite) ▸ f… | DATA_OP | defaultData.Add | (DefMain.ELECTRODE_TYPE , row["ELECTRODE_TYPE"]) | 데이터 객체 조작/조회 |  |  |  |
| AC-79743dc8 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0009_Shipment_Plan_FG.cs:2196 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (chosedFromSite.ToString() == popupReturnSite) ▸ f… | DATA_OP | defaultData.Add | (DefMain.ORIGIN_TO_DIVISION_ID, row["ORIGIN_TO_DIVISION_ID"]) | 데이터 객체 조작/조회 |  |  |  |
| AC-84ab920b | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0009_Shipment_Plan_FG.cs:2198 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (chosedFromSite.ToString() == popupReturnSite) ▸ f… | DATA_OP | defaultData.Add | (DefMain.TO_SITE_NAME, bod.first_site_name) | 데이터 객체 조작/조회 |  |  |  |
| AC-25c624bc | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0009_Shipment_Plan_FG.cs:2200 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (chosedFromSite.ToString() == popupReturnSite) ▸ f… | DATA_OP | defaultData.Add | (DefMain.BOH, row["BOH"]) | 데이터 객체 조작/조회 |  |  |  |
| AC-d3c20740 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0009_Shipment_Plan_FG.cs:2201 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (chosedFromSite.ToString() == popupReturnSite) ▸ f… | DATA_OP | defaultData.Add | (DefMain.INCOTERMS, bod.incoterms) | 데이터 객체 조작/조회 |  |  |  |
| AC-6d4aad5d | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0009_Shipment_Plan_FG.cs:2209 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (chosedFromSite.ToString() == popupReturnSite) ▸ f… | DATA_OP | defaultData.Add | (DefMain.PROJECT_CODE, row["PROJECT_CODE"]) | 데이터 객체 조작/조회 |  |  |  |
| AC-e09b03da | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0009_Shipment_Plan_FG.cs:2226 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (chosedFromSite.ToString() == popupReturnSite) ▸ f… | DATA_OP | defaultData.Add | (DefMain.ORIGIN_FROM_DIVISION_ID , row["ORIGIN_FROM_DIVISION_ID"]) | 데이터 객체 조작/조회 |  |  |  |
| AC-5389a7c9 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0009_Shipment_Plan_FG.cs:2228 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (chosedFromSite.ToString() == popupReturnSite) ▸ f… | DATA_OP | cur_Measure.Contains | ("SHIP") | 데이터 객체 조작/조회 |  |  |  |
| AC-c58ed044 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0009_Shipment_Plan_FG.cs:2229 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (chosedFromSite.ToString() == popupReturnSite) ▸ f… | DATA_OP | defaultData.Add | (DefMain.FROM_SITE_NAME, "-") | 데이터 객체 조작/조회 |  |  |  |
| AC-8aa03c2a | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0009_Shipment_Plan_FG.cs:2232 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (chosedFromSite.ToString() == popupReturnSite) ▸ f… | DATA_OP | defaultData.Add | (DefMain.FROM_SITE_NAME, bod.second_site_name) | 데이터 객체 조작/조회 |  |  |  |
| AC-70b5bdf1 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0009_Shipment_Plan_FG.cs:2235 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (chosedFromSite.ToString() == popupReturnSite) ▸ f… | DATA_OP | cur_Measure.Contains | ("SHIP") | 데이터 객체 조작/조회 |  |  |  |
| AC-2c2f1b7c | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0009_Shipment_Plan_FG.cs:2236 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (chosedFromSite.ToString() == popupReturnSite) ▸ f… | DATA_OP | defaultData.Add | (DefMain.TRANSPORT_MODE, bod.transport_mode) | 데이터 객체 조작/조회 |  |  |  |
| AC-626a74aa | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0009_Shipment_Plan_FG.cs:2239 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (chosedFromSite.ToString() == popupReturnSite) ▸ f… | DATA_OP | defaultData.Add | (DefMain.TRANSPORT_MODE, "-") | 데이터 객체 조작/조회 |  |  |  |
| AC-8ddeb59c | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0009_Shipment_Plan_FG.cs:2242 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (chosedFromSite.ToString() == popupReturnSite) ▸ f… | DATA_OP | cur_Measure.Contains | ("SHIP") | 데이터 객체 조작/조회 |  |  |  |
| AC-5f32d1cc | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0009_Shipment_Plan_FG.cs:2243 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (chosedFromSite.ToString() == popupReturnSite) ▸ f… | DATA_OP | defaultData.Add | (DefMain.LT_DAY, bod.lt_total) | 데이터 객체 조작/조회 |  |  |  |
| AC-b5bdf71b | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0009_Shipment_Plan_FG.cs:2246 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (chosedFromSite.ToString() == popupReturnSite) ▸ f… | DATA_OP | defaultData.Add | (DefMain.LT_DAY, 0) | 데이터 객체 조작/조회 |  |  |  |
| AC-b7558b51 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0009_Shipment_Plan_FG.cs:2249 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (chosedFromSite.ToString() == popupReturnSite) ▸ f… | DATA_OP | defaultData.Add | (DefMain.MEASURE_LABEL, row["MEASURE_LABEL"]) | 데이터 객체 조작/조회 |  |  |  |
| AC-388b669d | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0009_Shipment_Plan_FG.cs:2250 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (chosedFromSite.ToString() == popupReturnSite) ▸ f… | DATA_OP | defaultData.Add | (DefMain.MEASURE, cur_Measure) | 데이터 객체 조작/조회 |  |  |  |
| AC-2e0a0e59 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0009_Shipment_Plan_FG.cs:2253 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (chosedFromSite.ToString() == popupReturnSite) ▸ f… | DATA_OP | cur_Measure.Contains | ("SHIP") | 데이터 객체 조작/조회 |  |  |  |
| AC-376d0de4 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0009_Shipment_Plan_FG.cs:2254 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (chosedFromSite.ToString() == popupReturnSite) ▸ f… | DATA_OP | defaultData.Add | (DefMain.BOD_ID, bod.bod_id) | 데이터 객체 조작/조회 |  |  |  |
| AC-caee85c5 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0009_Shipment_Plan_FG.cs:2257 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (chosedFromSite.ToString() == popupReturnSite) ▸ f… | DATA_OP | defaultData.Add | (DefMain.BOD_ID, "-") | 데이터 객체 조작/조회 |  |  |  |
| AC-266fc3a0 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0009_Shipment_Plan_FG.cs:2260 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (chosedFromSite.ToString() == popupReturnSite) ▸ f… | DATA_OP | defaultData.Add | (DefMain.KEY_IDX, row["key_idx"]) | 데이터 객체 조작/조회 |  |  |  |
| AC-9efeb2cc | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0009_Shipment_Plan_FG.cs:2261 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (chosedFromSite.ToString() == popupReturnSite) ▸ f… | DATA_OP | defaultData.Add | (DefMain.BIZ_TYPE, row["biz_type"]) | 데이터 객체 조작/조회 |  |  |  |
| AC-f11113d8 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0009_Shipment_Plan_FG.cs:2262 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (chosedFromSite.ToString() == popupReturnSite) ▸ f… | DATA_OP | defaultData.Add | (DefMain.TO_SITE, bod.first_site) | 데이터 객체 조작/조회 |  |  |  |
| AC-03f7757e | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0009_Shipment_Plan_FG.cs:2264 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (chosedFromSite.ToString() == popupReturnSite) ▸ f… | DATA_OP | cur_Measure.Contains | ("SHIP") | 데이터 객체 조작/조회 |  |  |  |
| AC-8421bf4d | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0009_Shipment_Plan_FG.cs:2265 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (chosedFromSite.ToString() == popupReturnSite) ▸ f… | DATA_OP | defaultData.Add | (DefMain.FROM_SITE, "-") | 데이터 객체 조작/조회 |  |  |  |
| AC-082c20cf | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0009_Shipment_Plan_FG.cs:2268 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (chosedFromSite.ToString() == popupReturnSite) ▸ f… | DATA_OP | defaultData.Add | (DefMain.FROM_SITE, bod.second_site) | 데이터 객체 조작/조회 |  |  |  |
| AC-dd435373 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0009_Shipment_Plan_FG.cs:2271 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (chosedFromSite.ToString() == popupReturnSite) ▸ f… | DATA_OP | defaultData.Add | (DefMain.SHIP_FROZEN, bod.ship_frozen) | 데이터 객체 조작/조회 |  |  |  |
| AC-507f17ff | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0009_Shipment_Plan_FG.cs:2272 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (chosedFromSite.ToString() == popupReturnSite) ▸ f… | DATA_OP | defaultData.Add | (DefMain.MEASURE_ORDER_NO, row["MEASURE_ORDER_NO"]) | 데이터 객체 조작/조회 |  |  |  |
| AC-1ca889b4 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0009_Shipment_Plan_FG.cs:2274 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (chosedFromSite.ToString() == popupReturnSite) ▸ f… | DATA_OP | defaultData.Add | (DefMain.PLAN_START_YYYYMMDD, row["plan_start_yyyymmdd"]) | 데이터 객체 조작/조회 |  |  |  |
| AC-928b3137 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0009_Shipment_Plan_FG.cs:2275 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (chosedFromSite.ToString() == popupReturnSite) ▸ f… | DATA_OP | defaultData.Add | (DefMain.PLAN_TYPE, row["plan_type"]) | 데이터 객체 조작/조회 |  |  |  |
| AC-c235c8c5 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0009_Shipment_Plan_FG.cs:2276 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (chosedFromSite.ToString() == popupReturnSite) ▸ f… | DATA_OP | defaultData.Add | (DefMain.SEQ, row["seq"]) | 데이터 객체 조작/조회 |  |  |  |
| AC-d8e1e052 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0009_Shipment_Plan_FG.cs:2277 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (chosedFromSite.ToString() == popupReturnSite) ▸ f… | DATA_OP | defaultData.Add | (DefMain.TO_YYYYMMDD, row["to_yyyymmdd"]) | 데이터 객체 조작/조회 |  |  |  |
| AC-8e5fb9cf | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0009_Shipment_Plan_FG.cs:2278 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (chosedFromSite.ToString() == popupReturnSite) ▸ f… | DATA_OP | defaultData.Add | (DefMain.BOD_FROM_YYYYMMDD, bod.bod_from_yyyymmdd) | 데이터 객체 조작/조회 |  |  |  |
| AC-d11389b9 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0009_Shipment_Plan_FG.cs:2279 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (chosedFromSite.ToString() == popupReturnSite) ▸ f… | DATA_OP | defaultData.Add | (DefMain.BOD_TO_YYYYMMDD, bod.bod_to_yyyymmdd) | 데이터 객체 조작/조회 |  |  |  |
| AC-e41437c1 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0009_Shipment_Plan_FG.cs:2280 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (chosedFromSite.ToString() == popupReturnSite) ▸ f… | GRID_SET | siMain.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |
| AC-fc4f6799 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SCP0009_Shipment_Plan_FG.cs:2292 | if (popup.ShowDialog() == DialogResult.OK) | UI_MISC | spdMain.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## SCP0009_Shipment_Plan_FG.RefreshFromSite

진입점: this.Load [if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))] / cboDivision.SelectedIndexChanged [if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))] / cboBizType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2e1b571f | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 2 | SCP0009_Shipment_Plan_FG.cs:388 | try ▸ if (this._division.Equals("EE_UC")) | CALL_EXT | DBUtils.GetAndFilterString | (new List<string>(){ DefMain.DIVISION_ID, DefMain.OPERATION_GROUP }, new List<string>(){ "… | ⚠ 의미 확인 필요 |  |  |  |
| AC-4aa8ae65 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 2 | SCP0009_Shipment_Plan_FG.cs:394 | try ▸ else of (this._division.Equals("EE_UC")) ▸ if (this._division.Equals("EE")) | CALL_EXT | DBUtils.GetAndFilterString | (new List<string>() { DefMain.DIVISION_ID, DefMain.OPERATION_GROUP }, new List<string>() {… | ⚠ 의미 확인 필요 |  |  |  |
| AC-a62f177e | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 2 | SCP0009_Shipment_Plan_FG.cs:398 | try ▸ else of (this._division.Equals("EE_UC")) ▸ else of (this._division.Equals("EE")) | CALL_EXT | DBUtils.GetAndFilterString | (new List<string>() { DefMain.DIVISION_ID, DefMain.OPERATION_GROUP }, new List<string>() {… | ⚠ 의미 확인 필요 |  |  |  |
| AC-72167e1d | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 2 | SCP0009_Shipment_Plan_FG.cs:402 | try | FLAG | dtFromSite | DBUtils.Filter(dtFromSiteAll, filter, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-f321607d | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 2 | SCP0009_Shipment_Plan_FG.cs:402 | try | DATA_OP | DBUtils.Filter | (dtFromSiteAll, filter, true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-fe954a19 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 2 | SCP0009_Shipment_Plan_FG.cs:403 | try | LIST_REBIND | clsCtrl.setListBox | (dtFromSite, clbFromSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-35c54500 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 2 | SCP0009_Shipment_Plan_FG.cs:407 | catch () | LIST_CLEAR | clbFromSite.Items.Clear | () | 목록 항목 비움 |  |  |  |

## SCP0009_Shipment_Plan_FG.RefreshOperationGroup

진입점: this.Load [if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))] / cboDivision.SelectedIndexChanged [if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cb0db768 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 1 | SCP0009_Shipment_Plan_FG.cs:368 | if (!this._division.Substring(0, 2).Equals("EE")) | FLAG | dtOperGrp | Data_SCP.Common(Data_SCP.Type.OperationGroup, false) | 화면 필드/플래그 변경 |  |  |  |
| AC-b89004e8 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 1 | SCP0009_Shipment_Plan_FG.cs:368 | if (!this._division.Substring(0, 2).Equals("EE")) | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.OperationGroup, false) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-90ad64f4 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 1 | SCP0009_Shipment_Plan_FG.cs:372 | else of (!this._division.Substring(0, 2).Equals("EE")) | FLAG | dtOperGrp | Data_SCP.Common(Data_SCP.Type.OperationGroupEE, false) | 화면 필드/플래그 변경 |  |  |  |
| AC-d9379019 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 1 | SCP0009_Shipment_Plan_FG.cs:372 | else of (!this._division.Substring(0, 2).Equals("EE")) | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.OperationGroupEE, false) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-0f4372be | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 1 | SCP0009_Shipment_Plan_FG.cs:375 |  | LIST_REBIND | clsCtrl.setListBox | (dtOperGrp, cboBizType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0009_Shipment_Plan_FG.RefreshPlanDate

진입점: this.Load [if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))] / cboDivision.SelectedIndexChanged [if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2cf4000c | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 1 | SCP0009_Shipment_Plan_FG.cs:445 |  | FLAG | dtPlanDate | DBUtils.Filter(dtPlanDateAll, "DIVISION_ID = '" + this._division + "'", true) | 화면 필드/플래그 변경 |  |  |  |
| AC-9218be86 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 1 | SCP0009_Shipment_Plan_FG.cs:445 |  | DATA_OP | DBUtils.Filter | (dtPlanDateAll, "DIVISION_ID = '" + this._division + "'", true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-7d0959b4 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 1 | SCP0009_Shipment_Plan_FG.cs:446 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanDate, cboPlanDate, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0009_Shipment_Plan_FG.RefreshPlanSeq

진입점: this.Load [if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))] / cboDivision.SelectedIndexChanged [if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))] / cboPlanType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-36e647d8 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 2 | SCP0009_Shipment_Plan_FG.cs:458 |  | FLAG | dtPlanSeq | DBUtils.Filter(dtPlanSeqAll, "DIVISION_ID = '" + this._division + "' AND PLANDATE = '" + t… | 화면 필드/플래그 변경 |  |  |  |
| AC-5ffa351c | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 2 | SCP0009_Shipment_Plan_FG.cs:458 |  | DATA_OP | DBUtils.Filter | (dtPlanSeqAll, "DIVISION_ID = '" + this._division + "' AND PLANDATE = '" + this._planDate … | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-e3746a3c | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 2 | SCP0009_Shipment_Plan_FG.cs:459 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanSeq, cboPlanSeq, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0009_Shipment_Plan_FG.RefreshPlanType

진입점: this.Load [if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))] / cboDivision.SelectedIndexChanged [if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))] / cboPlanDate.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fc867fcf | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 2 | SCP0009_Shipment_Plan_FG.cs:450 |  | FLAG | dtPlanType | DBUtils.Filter(dtPlanTypeAll, "DIVISION_ID = '" + this._division + "' AND PLANDATE ='" + t… | 화면 필드/플래그 변경 |  |  |  |
| AC-b0c4129b | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 2 | SCP0009_Shipment_Plan_FG.cs:450 |  | DATA_OP | DBUtils.Filter | (dtPlanTypeAll, "DIVISION_ID = '" + this._division + "' AND PLANDATE ='" + this._planDate … | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-c635778f | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 2 | SCP0009_Shipment_Plan_FG.cs:451 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanType, cboPlanType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-493a4fe4 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 2 | SCP0009_Shipment_Plan_FG.cs:454 | if (dtPlanType.Rows.Count > 0) | VALUE_SET | cboPlanType.SelectedIndex | dtPlanType.Rows.Count - 1 | 컨트롤 값 설정 |  |  |  |

## SCP0009_Shipment_Plan_FG.RefreshTeam

진입점: this.Load / cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-47a84dba | this.Load 외 1 | SCP0009_Shipment_Plan_FG.cs:359 | if (!this._division.Substring(0, 2).Equals("EE")) | FLAG | dtTeam | Data.UserTeamByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.Use… | 화면 필드/플래그 변경 |  |  |  |
| AC-73848c17 | this.Load 외 1 | SCP0009_Shipment_Plan_FG.cs:359 | if (!this._division.Substring(0, 2).Equals("EE")) | COMBO_DATA | Data.UserTeamByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, this._division) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-f75dece4 | this.Load 외 1 | SCP0009_Shipment_Plan_FG.cs:361 | else of (!this._division.Substring(0, 2).Equals("EE")) | FLAG | dtTeam | Data.UserTeamByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.Use… | 화면 필드/플래그 변경 |  |  |  |
| AC-5063427b | this.Load 외 1 | SCP0009_Shipment_Plan_FG.cs:361 | else of (!this._division.Substring(0, 2).Equals("EE")) | COMBO_DATA | Data.UserTeamByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, this._allDivisions… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-75932a11 | this.Load 외 1 | SCP0009_Shipment_Plan_FG.cs:362 |  | LIST_REBIND | clsCtrl.setListBox | (dtTeam, clbTeam, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0009_Shipment_Plan_FG.RefreshToSite

진입점: this.Load [if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))] / cboDivision.SelectedIndexChanged [if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))] / cboBizType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2e07ad85 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 2 | SCP0009_Shipment_Plan_FG.cs:418 | try ▸ if (this._division.Substring(0, 2).Equals("EE")) | CALL_EXT | DBUtils.GetAndFilterString | (new List<string>() { DefMain.DIVISION_ID, DefMain.OPERATION_GROUP }, new List<string>() {… | ⚠ 의미 확인 필요 |  |  |  |
| AC-459e5eae | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 2 | SCP0009_Shipment_Plan_FG.cs:419 | try ▸ if (this._division.Substring(0, 2).Equals("EE")) | FLAG | dtToSite | DBUtils.Filter(dtToSiteEEAll, filter, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-814a5df4 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 2 | SCP0009_Shipment_Plan_FG.cs:419 | try ▸ if (this._division.Substring(0, 2).Equals("EE")) | DATA_OP | DBUtils.Filter | (dtToSiteEEAll, filter, true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-a997ae16 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 2 | SCP0009_Shipment_Plan_FG.cs:425 | try ▸ else of (this._division.Substring(0, 2).Equals("EE")) ▸ if (this._division.Equals("EE_UC")) | CALL_EXT | DBUtils.GetAndFilterString | (new List<string>() { DefMain.DIVISION_ID }, new List<string>() { "81_UC" }, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3344038c | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 2 | SCP0009_Shipment_Plan_FG.cs:426 | try ▸ else of (this._division.Substring(0, 2).Equals("EE")) ▸ if (this._division.Equals("EE_UC")) | FLAG | dtToSite | DBUtils.Filter(dtToSiteEE_UCAll, filter, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-947d7f00 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 2 | SCP0009_Shipment_Plan_FG.cs:426 | try ▸ else of (this._division.Substring(0, 2).Equals("EE")) ▸ if (this._division.Equals("EE_UC")) | DATA_OP | DBUtils.Filter | (dtToSiteEE_UCAll, filter, true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-c7b52f82 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 2 | SCP0009_Shipment_Plan_FG.cs:430 | try ▸ else of (this._division.Substring(0, 2).Equals("EE")) ▸ else of (this._division.Equals("EE_UC")) | CALL_EXT | DBUtils.GetAndFilterString | (new List<string>() { DefMain.DIVISION_ID }, new List<string>() { this._division }, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-4d242204 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 2 | SCP0009_Shipment_Plan_FG.cs:431 | try ▸ else of (this._division.Substring(0, 2).Equals("EE")) ▸ else of (this._division.Equals("EE_UC")) | FLAG | dtToSite | DBUtils.Filter(dtFromSiteAll, filter, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-253bbb13 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 2 | SCP0009_Shipment_Plan_FG.cs:431 | try ▸ else of (this._division.Substring(0, 2).Equals("EE")) ▸ else of (this._division.Equals("EE_UC")) | DATA_OP | DBUtils.Filter | (dtFromSiteAll, filter, true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-14569033 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 2 | SCP0009_Shipment_Plan_FG.cs:436 | try | LIST_REBIND | clsCtrl.setListBox | (dtToSite, clbToSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-d72e38e8 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 2 | SCP0009_Shipment_Plan_FG.cs:440 | catch () | LIST_CLEAR | clbToSite.Items.Clear | () | 목록 항목 비움 |  |  |  |

## SCP0009_Shipment_Plan_FG.RetIntValue

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-028b88b8 | (진입점 미연결) | SCP0009_Shipment_Plan_FG.cs:2034 |  | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |

## SCP0009_Shipment_Plan_FG.SaveData_FixInfo

진입점: this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock(siMain.SheetName))] / this.btnUnfix.Click [if (fps != null) ▸ else of (siMain.IsLock(siMain.SheetName)) ▸ if (MessageHelper.GMessageBox("MSG00016") == DialogResult.Yes)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1fc922c5 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0009_Shipment_Plan_FG.cs:4245 | if (fps.Name == "spdMain") | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-b4ff0de9 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0009_Shipment_Plan_FG.cs:4250 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ if (siMain.ActiveSheet.Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-681a0399 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0009_Shipment_Plan_FG.cs:4275 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ if (fixType == "F") | POPUP | new SCM0002_RejectReasonPopup | ("Fix Reason") | 팝업/폼 생성 |  |  |  |
| AC-8efaeb30 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0009_Shipment_Plan_FG.cs:4276 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ if (fixType == "F") | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-e69256b2 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0009_Shipment_Plan_FG.cs:4277 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ if (fixType == "F") | UI_PROP | popup.Width | 600 | 속성 Width 설정 |  |  |  |
| AC-e5ed733f | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0009_Shipment_Plan_FG.cs:4278 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ if (fixType == "F") | UI_PROP | popup.Height | 230 | 속성 Height 설정 |  |  |  |
| AC-7f9bbea9 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0009_Shipment_Plan_FG.cs:4280 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ if (fixType == "F") | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-ea2c51b1 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0009_Shipment_Plan_FG.cs:4287 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ if (fixType == "F") ▸ else of (popup.ShowDialog() == DialogResult.OK) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d7296d6d | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0009_Shipment_Plan_FG.cs:4298 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ if (selCells.Length < 1) | MESSAGE | MessageHelper.GMessageBox | ("MSG00134", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-038dd406 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0009_Shipment_Plan_FG.cs:4299 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ if (selCells.Length < 1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-fc811e9a | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0009_Shipment_Plan_FG.cs:4305 | if (fps.Name == "spdMain") ▸ if (siMain != null) | DATA_OP | dt.Columns.Add | ("A") | 데이터 객체 조작/조회 |  |  |  |
| AC-013aefa1 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0009_Shipment_Plan_FG.cs:4306 | if (fps.Name == "spdMain") ▸ if (siMain != null) | DATA_OP | dt.Columns.Add | ("p_active_flag") | 데이터 객체 조작/조회 |  |  |  |
| AC-057db7e7 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0009_Shipment_Plan_FG.cs:4307 | if (fps.Name == "spdMain") ▸ if (siMain != null) | DATA_OP | dt.Columns.Add | ("p_division_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-ee5fa3d5 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0009_Shipment_Plan_FG.cs:4308 | if (fps.Name == "spdMain") ▸ if (siMain != null) | DATA_OP | dt.Columns.Add | ("p_plan_start_yyyymmdd") | 데이터 객체 조작/조회 |  |  |  |
| AC-349e1c7a | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0009_Shipment_Plan_FG.cs:4309 | if (fps.Name == "spdMain") ▸ if (siMain != null) | DATA_OP | dt.Columns.Add | ("p_plan_type") | 데이터 객체 조작/조회 |  |  |  |
| AC-3a0d7729 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0009_Shipment_Plan_FG.cs:4310 | if (fps.Name == "spdMain") ▸ if (siMain != null) | DATA_OP | dt.Columns.Add | ("p_seq") | 데이터 객체 조작/조회 |  |  |  |
| AC-1b8ef69f | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0009_Shipment_Plan_FG.cs:4311 | if (fps.Name == "spdMain") ▸ if (siMain != null) | DATA_OP | dt.Columns.Add | ("p_biz_type") | 데이터 객체 조작/조회 |  |  |  |
| AC-9c2eba80 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0009_Shipment_Plan_FG.cs:4312 | if (fps.Name == "spdMain") ▸ if (siMain != null) | DATA_OP | dt.Columns.Add | ("p_project_code") | 데이터 객체 조작/조회 |  |  |  |
| AC-f122d603 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0009_Shipment_Plan_FG.cs:4313 | if (fps.Name == "spdMain") ▸ if (siMain != null) | DATA_OP | dt.Columns.Add | ("p_item_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-9ec11fb7 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0009_Shipment_Plan_FG.cs:4314 | if (fps.Name == "spdMain") ▸ if (siMain != null) | DATA_OP | dt.Columns.Add | ("p_to_site") | 데이터 객체 조작/조회 |  |  |  |
| AC-a2c65d96 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0009_Shipment_Plan_FG.cs:4315 | if (fps.Name == "spdMain") ▸ if (siMain != null) | DATA_OP | dt.Columns.Add | ("p_incoterms") | 데이터 객체 조작/조회 |  |  |  |
| AC-35a76675 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0009_Shipment_Plan_FG.cs:4316 | if (fps.Name == "spdMain") ▸ if (siMain != null) | DATA_OP | dt.Columns.Add | ("p_from_site") | 데이터 객체 조작/조회 |  |  |  |
| AC-e84e8db2 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0009_Shipment_Plan_FG.cs:4317 | if (fps.Name == "spdMain") ▸ if (siMain != null) | DATA_OP | dt.Columns.Add | ("p_bod_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-6eb8969c | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0009_Shipment_Plan_FG.cs:4318 | if (fps.Name == "spdMain") ▸ if (siMain != null) | DATA_OP | dt.Columns.Add | ("p_measure") | 데이터 객체 조작/조회 |  |  |  |
| AC-333686b1 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0009_Shipment_Plan_FG.cs:4319 | if (fps.Name == "spdMain") ▸ if (siMain != null) | DATA_OP | dt.Columns.Add | ("p_yyyymmdd") | 데이터 객체 조작/조회 |  |  |  |
| AC-d21bbcd3 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0009_Shipment_Plan_FG.cs:4320 | if (fps.Name == "spdMain") ▸ if (siMain != null) | DATA_OP | dt.Columns.Add | ("p_qty") | 데이터 객체 조작/조회 |  |  |  |
| AC-6e44ede3 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0009_Shipment_Plan_FG.cs:4321 | if (fps.Name == "spdMain") ▸ if (siMain != null) | DATA_OP | dt.Columns.Add | ("p_origin_from_division_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-4d391e01 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0009_Shipment_Plan_FG.cs:4322 | if (fps.Name == "spdMain") ▸ if (siMain != null) | DATA_OP | dt.Columns.Add | ("p_origin_to_division_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-e99a3238 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0009_Shipment_Plan_FG.cs:4323 | if (fps.Name == "spdMain") ▸ if (siMain != null) | DATA_OP | dt.Columns.Add | ("p_electrode_type") | 데이터 객체 조작/조회 |  |  |  |
| AC-3d9464c6 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0009_Shipment_Plan_FG.cs:4324 | if (fps.Name == "spdMain") ▸ if (siMain != null) | DATA_OP | dt.Columns.Add | ("p_fix_reason") | 데이터 객체 조작/조회 |  |  |  |
| AC-1f740e3f | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0009_Shipment_Plan_FG.cs:4325 | if (fps.Name == "spdMain") ▸ if (siMain != null) | DATA_OP | dt.Columns.Add | ("p_bucket_type") | 데이터 객체 조작/조회 |  |  |  |
| AC-ec5a6b82 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0009_Shipment_Plan_FG.cs:4326 | if (fps.Name == "spdMain") ▸ if (siMain != null) | DATA_OP | dt.Columns.Add | ("p_trans_mode") | 데이터 객체 조작/조회 |  |  |  |
| AC-ae5805dc | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0009_Shipment_Plan_FG.cs:4327 | if (fps.Name == "spdMain") ▸ if (siMain != null) | DATA_OP | dt.Columns.Add | ("p_created_by") | 데이터 객체 조작/조회 |  |  |  |
| AC-821b2dc7 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0009_Shipment_Plan_FG.cs:4328 | if (fps.Name == "spdMain") ▸ if (siMain != null) | DATA_OP | dt.Columns.Add | ("p_last_updated_by") | 데이터 객체 조작/조회 |  |  |  |
| AC-a455b2d0 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0009_Shipment_Plan_FG.cs:4329 | if (fps.Name == "spdMain") ▸ if (siMain != null) | DATA_OP | dt.Columns.Add | ("p_time_zone") | 데이터 객체 조작/조회 |  |  |  |
| AC-a5b5a83b | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0009_Shipment_Plan_FG.cs:4330 | if (fps.Name == "spdMain") ▸ if (siMain != null) | DATA_OP | dt.Columns.Add | ("debug_mode") | 데이터 객체 조작/조회 |  |  |  |
| AC-b43ded76 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0009_Shipment_Plan_FG.cs:4331 | if (fps.Name == "spdMain") ▸ if (siMain != null) | DATA_OP | dsInput.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-5ea7514d | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0009_Shipment_Plan_FG.cs:4354 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | CALL_EXT | siMain.ActiveSheet.GetRowVisible | (i) | ⚠ 의미 확인 필요 |  |  |  |
| AC-2b62ffd1 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0009_Shipment_Plan_FG.cs:4370 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | GRID_STYLE | siMain.SetBGColor | (i, j, i, j, ControlColor.InvalidColor) | 그리드 표시 설정 |  |  |  |
| AC-ba01fd12 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0009_Shipment_Plan_FG.cs:4371 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | MESSAGE | MessageHelper.GMessageBox | ("MSG00026", new object[] { null }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-4cbda29b | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0009_Shipment_Plan_FG.cs:4372 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4adf8c95 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0009_Shipment_Plan_FG.cs:4378 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | CALL_EXT | siMain.GetBGColor | (i, j) | ⚠ 의미 확인 필요 |  |  |  |
| AC-961a5fc6 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0009_Shipment_Plan_FG.cs:4409 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dsInput.Tables[0].NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-96b5528a | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0009_Shipment_Plan_FG.cs:4410 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_active_flag"] | strAction | 행/컬럼 값 대입 |  |  |  |
| AC-53f0a020 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0009_Shipment_Plan_FG.cs:4411 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_division_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.DIVISION_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-d320517f | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0009_Shipment_Plan_FG.cs:4412 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_plan_start_yyyymmdd"] | sPlanStartYyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-910f2e64 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0009_Shipment_Plan_FG.cs:4413 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_plan_type"] | sPlanType | 행/컬럼 값 대입 |  |  |  |
| AC-1d6305f6 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0009_Shipment_Plan_FG.cs:4414 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_seq"] | sSeq | 행/컬럼 값 대입 |  |  |  |
| AC-c8719b42 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0009_Shipment_Plan_FG.cs:4415 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_biz_type"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.BIZ_TYPE)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-390a5b65 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0009_Shipment_Plan_FG.cs:4416 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_item_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.ITEM_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-02a2391f | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0009_Shipment_Plan_FG.cs:4417 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_to_site"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.TO_SITE)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-b63b768e | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0009_Shipment_Plan_FG.cs:4418 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_from_site"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.FROM_SITE)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-6c102053 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0009_Shipment_Plan_FG.cs:4419 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_project_code"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.PROJECT_CODE)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-708f4f02 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0009_Shipment_Plan_FG.cs:4420 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_incoterms"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.INCOTERMS)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-7a326929 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0009_Shipment_Plan_FG.cs:4421 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_bod_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.BOD_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-dbd1c3b9 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0009_Shipment_Plan_FG.cs:4422 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_yyyymmdd"] | strYYYYMMDD | 행/컬럼 값 대입 |  |  |  |
| AC-6c2ce7da | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0009_Shipment_Plan_FG.cs:4423 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_qty"] | sQty | 행/컬럼 값 대입 |  |  |  |
| AC-36d0568c | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0009_Shipment_Plan_FG.cs:4424 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_origin_from_division_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.ORIGIN_FROM_DIVISION_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-39f89ce2 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0009_Shipment_Plan_FG.cs:4425 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_origin_to_division_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.ORIGIN_TO_DIVISION_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-29e5139e | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0009_Shipment_Plan_FG.cs:4426 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_electrode_type"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.ELECTRODE_TYPE)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-84c395e3 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0009_Shipment_Plan_FG.cs:4427 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_fix_reason"] | strReason | 행/컬럼 값 대입 |  |  |  |
| AC-5d353cc5 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0009_Shipment_Plan_FG.cs:4428 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_bucket_type"] | cboBucketType.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-64f88f4b | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0009_Shipment_Plan_FG.cs:4429 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_created_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-2cd71466 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0009_Shipment_Plan_FG.cs:4430 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_last_updated_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-4ccf1839 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0009_Shipment_Plan_FG.cs:4431 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_time_zone"] | UserInfoContext.Current[UserInfoProperites.TimeZone] | 행/컬럼 값 대입 |  |  |  |
| AC-21c35423 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0009_Shipment_Plan_FG.cs:4432 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-9bddff42 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0009_Shipment_Plan_FG.cs:4433 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dsInput.Tables[0].Rows.Add | (dr) | 데이터 객체 조작/조회 |  |  |  |
| AC-82bb9959 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0009_Shipment_Plan_FG.cs:4447 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | CALL_EXT | siMain.GetBGColor | (i, j + nDayCntOfWeek) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f51372ee | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0009_Shipment_Plan_FG.cs:4455 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | GRID_STYLE | siMain.SetBGColor | (i, j + nDayCntOfWeek, i, j + nDayCntOfWeek, ControlColor.InvalidColor) | 그리드 표시 설정 |  |  |  |
| AC-e829499a | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0009_Shipment_Plan_FG.cs:4456 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | MESSAGE | MessageHelper.GMessageBox | ("MSG00026", new object[] { null }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f768fe17 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0009_Shipment_Plan_FG.cs:4457 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f472fc02 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0009_Shipment_Plan_FG.cs:4487 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dsInput.Tables[0].NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-99c28cb0 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0009_Shipment_Plan_FG.cs:4488 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_active_flag"] | strAction | 행/컬럼 값 대입 |  |  |  |
| AC-238ee994 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0009_Shipment_Plan_FG.cs:4489 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_division_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.DIVISION_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-cc830131 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0009_Shipment_Plan_FG.cs:4490 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_plan_start_yyyymmdd"] | sPlanStartYyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-582fe1c7 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0009_Shipment_Plan_FG.cs:4491 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_plan_type"] | sPlanType | 행/컬럼 값 대입 |  |  |  |
| AC-58672710 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0009_Shipment_Plan_FG.cs:4492 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_seq"] | sSeq | 행/컬럼 값 대입 |  |  |  |
| AC-58bca7f4 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0009_Shipment_Plan_FG.cs:4493 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_biz_type"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.BIZ_TYPE)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-72c63f74 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0009_Shipment_Plan_FG.cs:4494 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_item_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.ITEM_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-1e0fa450 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0009_Shipment_Plan_FG.cs:4495 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_to_site"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.TO_SITE)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-35374d70 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0009_Shipment_Plan_FG.cs:4496 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_from_site"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.FROM_SITE)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-813871f1 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0009_Shipment_Plan_FG.cs:4497 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_project_code"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.PROJECT_CODE)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-00c95dac | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0009_Shipment_Plan_FG.cs:4498 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_incoterms"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.INCOTERMS)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-debf47ec | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0009_Shipment_Plan_FG.cs:4499 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_bod_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.BOD_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-a2e77781 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0009_Shipment_Plan_FG.cs:4500 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_yyyymmdd"] | strYYYYMMDD | 행/컬럼 값 대입 |  |  |  |
| AC-e3ec127a | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0009_Shipment_Plan_FG.cs:4501 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_qty"] | sQty | 행/컬럼 값 대입 |  |  |  |
| AC-de14a162 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0009_Shipment_Plan_FG.cs:4502 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_origin_from_division_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.ORIGIN_FROM_DIVISION_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-942695ff | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0009_Shipment_Plan_FG.cs:4503 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_origin_to_division_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.ORIGIN_TO_DIVISION_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-cd6ace7e | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0009_Shipment_Plan_FG.cs:4504 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_electrode_type"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.ELECTRODE_TYPE)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-61f50c35 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0009_Shipment_Plan_FG.cs:4505 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_fix_reason"] | strReason | 행/컬럼 값 대입 |  |  |  |
| AC-b3371917 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0009_Shipment_Plan_FG.cs:4506 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_bucket_type"] | cboBucketType.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-3b27548d | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0009_Shipment_Plan_FG.cs:4507 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_created_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-d4b8b0f3 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0009_Shipment_Plan_FG.cs:4508 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_last_updated_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-cf44376d | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0009_Shipment_Plan_FG.cs:4509 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_time_zone"] | UserInfoContext.Current[UserInfoProperites.TimeZone] | 행/컬럼 값 대입 |  |  |  |
| AC-55b857a7 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0009_Shipment_Plan_FG.cs:4510 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-fdc334b6 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0009_Shipment_Plan_FG.cs:4511 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dsInput.Tables[0].Rows.Add | (dr) | 데이터 객체 조작/조회 |  |  |  |
| AC-4acf369c | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0009_Shipment_Plan_FG.cs:4564 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ if (fixType.Equals("U") && iCount == 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00046", new object[] { null }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-7cfa3b8b | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0009_Shipment_Plan_FG.cs:4565 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ if (fixType.Equals("U") && iCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-155e5119 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0009_Shipment_Plan_FG.cs:4571 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ if (iCount > 0) | DATA_OP | dsInput.Tables[0].AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-1f38df69 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0009_Shipment_Plan_FG.cs:4576 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ if (iCount > 0) | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-fd2a24f8 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0009_Shipment_Plan_FG.cs:4586 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ if (iCount > 0) ▸ try | CALL_EXT | sql.AddParameter | ("@SCP0009", dsInput.Tables[0]) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ad655abb | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0009_Shipment_Plan_FG.cs:4587 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ if (iCount > 0) ▸ try | ENDPOINT | sql.ExcuteProcedure | ("SaveShipmentPlanFGFix") ⇒ biz:AppService.GeneralRunProcedureCustomTable [procedure=SaveShipmentPlanFGFix] … | 엔드포인트 호출 |  |  |  |
| AC-ee1a1fdc | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0009_Shipment_Plan_FG.cs:4590 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ if (iCount > 0) ▸ try | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-61ba96e4 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0009_Shipment_Plan_FG.cs:4595 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ if (iCount > 0) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["re… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { result.Rows[0]["result_cnt"].ToString() }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-4336152c | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0009_Shipment_Plan_FG.cs:4604 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ if (iCount > 0) ▸ try ▸ else of (result != null && result.Rows.Count > 0 && result.Rows[0… | MESSAGE | MessageHelper.GMessageBox | ("MSG00003", new object[] { ReErrorMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9d206445 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0009_Shipment_Plan_FG.cs:4613 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ if (iCount > 0) ▸ catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-fc0b12c7 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0009_Shipment_Plan_FG.cs:4614 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ if (iCount > 0) ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-4e18e4af | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0009_Shipment_Plan_FG.cs:4620 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ if (iCount > 0) ▸ finally ▸ if (!prgCloseF) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-13140673 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0009_Shipment_Plan_FG.cs:4628 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ else of (iCount > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00252", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e351c393 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 1 | SCP0009_Shipment_Plan_FG.cs:4629 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ else of (iCount > 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0009_Shipment_Plan_FG.SaveData_Main

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2c0864ed | SaveButton | SCP0009_Shipment_Plan_FG.cs:2742 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (siMain.ActiveSheet.Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-745ac6e9 | SaveButton | SCP0009_Shipment_Plan_FG.cs:2745 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (!Get_IsSaveYn()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8a8087ed | SaveButton | SCP0009_Shipment_Plan_FG.cs:2763 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (!CheckMandatorySheetColumns()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-029a84fb | SaveButton | SCP0009_Shipment_Plan_FG.cs:2771 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-fc7177e7 | SaveButton | SCP0009_Shipment_Plan_FG.cs:2775 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-a5011b2e | SaveButton | SCP0009_Shipment_Plan_FG.cs:2799 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (iRow < siMain.ActiveSheet.Rows.… | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-5ac44868 | SaveButton | SCP0009_Shipment_Plan_FG.cs:2801 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (iRow < siMain.ActiveSheet.Rows.… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-41a51d45 | SaveButton | SCP0009_Shipment_Plan_FG.cs:2803 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (iRow < siMain.ActiveSheet.Rows.… | CALL_EXT | Math.Truncate | (nDayQty) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a47a3001 | SaveButton | SCP0009_Shipment_Plan_FG.cs:2805 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (iRow < siMain.ActiveSheet.Rows.… | CALL_EXT | Math.Truncate | (Convert.ToDouble(val)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e7d1c867 | SaveButton | SCP0009_Shipment_Plan_FG.cs:2807 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (iRow < siMain.ActiveSheet.Rows.… | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-bce3df1c | SaveButton | SCP0009_Shipment_Plan_FG.cs:2809 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (iRow < siMain.ActiveSheet.Rows.… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-bcc9f12d | SaveButton | SCP0009_Shipment_Plan_FG.cs:2819 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (iRow < siMain.ActiveSheet.Rows.… | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-968b32b1 | SaveButton | SCP0009_Shipment_Plan_FG.cs:2821 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (iRow < siMain.ActiveSheet.Rows.… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4521cfe1 | SaveButton | SCP0009_Shipment_Plan_FG.cs:2836 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (iRow < siMain.ActiveSheet.Rows.… | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-8ba0abfd | SaveButton | SCP0009_Shipment_Plan_FG.cs:2838 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (iRow < siMain.ActiveSheet.Rows.… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-938d9e67 | SaveButton | SCP0009_Shipment_Plan_FG.cs:2840 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (iRow < siMain.ActiveSheet.Rows.… | CALL_EXT | Math.Truncate | (nDayQty) | ⚠ 의미 확인 필요 |  |  |  |
| AC-5dc80cd4 | SaveButton | SCP0009_Shipment_Plan_FG.cs:2842 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (iRow < siMain.ActiveSheet.Rows.… | CALL_EXT | Math.Truncate | (Convert.ToDouble(val)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-0a319307 | SaveButton | SCP0009_Shipment_Plan_FG.cs:2844 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (iRow < siMain.ActiveSheet.Rows.… | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-1bd6a67a | SaveButton | SCP0009_Shipment_Plan_FG.cs:2846 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (iRow < siMain.ActiveSheet.Rows.… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c9e8c879 | SaveButton | SCP0009_Shipment_Plan_FG.cs:2856 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | FLAG | saveDS | new DataSet() | 화면 필드/플래그 변경 |  |  |  |
| AC-87de274a | SaveButton | SCP0009_Shipment_Plan_FG.cs:2858 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dt.Columns.Add | ("A", typeof(char)) | 데이터 객체 조작/조회 |  |  |  |
| AC-32acc80d | SaveButton | SCP0009_Shipment_Plan_FG.cs:2859 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dt.Columns.Add | ("p_active_flag") | 데이터 객체 조작/조회 |  |  |  |
| AC-6b81bacc | SaveButton | SCP0009_Shipment_Plan_FG.cs:2860 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dt.Columns.Add | ("p_division_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-4e4826fa | SaveButton | SCP0009_Shipment_Plan_FG.cs:2861 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dt.Columns.Add | ("p_plan_start_yyyymmdd") | 데이터 객체 조작/조회 |  |  |  |
| AC-61cbabac | SaveButton | SCP0009_Shipment_Plan_FG.cs:2862 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dt.Columns.Add | ("p_plan_type") | 데이터 객체 조작/조회 |  |  |  |
| AC-47c2b3fd | SaveButton | SCP0009_Shipment_Plan_FG.cs:2863 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dt.Columns.Add | ("p_seq") | 데이터 객체 조작/조회 |  |  |  |
| AC-f810ee8b | SaveButton | SCP0009_Shipment_Plan_FG.cs:2864 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dt.Columns.Add | ("p_biz_type") | 데이터 객체 조작/조회 |  |  |  |
| AC-5a6cf9e6 | SaveButton | SCP0009_Shipment_Plan_FG.cs:2865 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dt.Columns.Add | ("p_project_code") | 데이터 객체 조작/조회 |  |  |  |
| AC-7891bb49 | SaveButton | SCP0009_Shipment_Plan_FG.cs:2866 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dt.Columns.Add | ("p_item_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-667e925f | SaveButton | SCP0009_Shipment_Plan_FG.cs:2867 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dt.Columns.Add | ("p_to_site") | 데이터 객체 조작/조회 |  |  |  |
| AC-14841a0f | SaveButton | SCP0009_Shipment_Plan_FG.cs:2868 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dt.Columns.Add | ("p_incoterms") | 데이터 객체 조작/조회 |  |  |  |
| AC-0ecedc4e | SaveButton | SCP0009_Shipment_Plan_FG.cs:2869 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dt.Columns.Add | ("p_from_site") | 데이터 객체 조작/조회 |  |  |  |
| AC-12df1906 | SaveButton | SCP0009_Shipment_Plan_FG.cs:2870 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dt.Columns.Add | ("p_bod_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-8e482ddf | SaveButton | SCP0009_Shipment_Plan_FG.cs:2871 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dt.Columns.Add | ("p_measure") | 데이터 객체 조작/조회 |  |  |  |
| AC-e96fdccf | SaveButton | SCP0009_Shipment_Plan_FG.cs:2872 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dt.Columns.Add | ("p_yyyymmdd") | 데이터 객체 조작/조회 |  |  |  |
| AC-e8bf6ad1 | SaveButton | SCP0009_Shipment_Plan_FG.cs:2873 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dt.Columns.Add | ("p_qty") | 데이터 객체 조작/조회 |  |  |  |
| AC-cbace5ac | SaveButton | SCP0009_Shipment_Plan_FG.cs:2874 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dt.Columns.Add | ("p_origin_from_division_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-63a18d03 | SaveButton | SCP0009_Shipment_Plan_FG.cs:2875 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dt.Columns.Add | ("p_origin_to_division_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-72e6c445 | SaveButton | SCP0009_Shipment_Plan_FG.cs:2876 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dt.Columns.Add | ("p_electrode_type") | 데이터 객체 조작/조회 |  |  |  |
| AC-431d84a6 | SaveButton | SCP0009_Shipment_Plan_FG.cs:2877 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dt.Columns.Add | ("p_created_by") | 데이터 객체 조작/조회 |  |  |  |
| AC-d6dae3ee | SaveButton | SCP0009_Shipment_Plan_FG.cs:2878 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dt.Columns.Add | ("p_last_updated_by") | 데이터 객체 조작/조회 |  |  |  |
| AC-25f43490 | SaveButton | SCP0009_Shipment_Plan_FG.cs:2879 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dt.Columns.Add | ("p_time_zone") | 데이터 객체 조작/조회 |  |  |  |
| AC-cb0a0226 | SaveButton | SCP0009_Shipment_Plan_FG.cs:2880 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dt.Columns.Add | ("p_first_row") | 데이터 객체 조작/조회 |  |  |  |
| AC-3578ed1b | SaveButton | SCP0009_Shipment_Plan_FG.cs:2881 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dt.Columns.Add | ("p_last_row") | 데이터 객체 조작/조회 |  |  |  |
| AC-2cfe923c | SaveButton | SCP0009_Shipment_Plan_FG.cs:2882 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | saveDS.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-3cdee6ab | SaveButton | SCP0009_Shipment_Plan_FG.cs:2887 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dtInput.Columns.Add | ("A") | 데이터 객체 조작/조회 |  |  |  |
| AC-db7af025 | SaveButton | SCP0009_Shipment_Plan_FG.cs:2888 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dtInput.Columns.Add | ("p_active_flag") | 데이터 객체 조작/조회 |  |  |  |
| AC-6fea8544 | SaveButton | SCP0009_Shipment_Plan_FG.cs:2889 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dtInput.Columns.Add | ("p_division_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-a4f349cb | SaveButton | SCP0009_Shipment_Plan_FG.cs:2890 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dtInput.Columns.Add | ("p_plan_start_yyyymmdd") | 데이터 객체 조작/조회 |  |  |  |
| AC-0a6ff187 | SaveButton | SCP0009_Shipment_Plan_FG.cs:2891 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dtInput.Columns.Add | ("p_plan_type") | 데이터 객체 조작/조회 |  |  |  |
| AC-cb820ab3 | SaveButton | SCP0009_Shipment_Plan_FG.cs:2892 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dtInput.Columns.Add | ("p_seq") | 데이터 객체 조작/조회 |  |  |  |
| AC-2d9048a1 | SaveButton | SCP0009_Shipment_Plan_FG.cs:2893 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dtInput.Columns.Add | ("p_biz_type") | 데이터 객체 조작/조회 |  |  |  |
| AC-ae508082 | SaveButton | SCP0009_Shipment_Plan_FG.cs:2894 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dtInput.Columns.Add | ("p_project_code") | 데이터 객체 조작/조회 |  |  |  |
| AC-e2f85f29 | SaveButton | SCP0009_Shipment_Plan_FG.cs:2895 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dtInput.Columns.Add | ("p_item_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-d1eca841 | SaveButton | SCP0009_Shipment_Plan_FG.cs:2896 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dtInput.Columns.Add | ("p_to_site") | 데이터 객체 조작/조회 |  |  |  |
| AC-151a1340 | SaveButton | SCP0009_Shipment_Plan_FG.cs:2897 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dtInput.Columns.Add | ("p_incoterms") | 데이터 객체 조작/조회 |  |  |  |
| AC-bd604206 | SaveButton | SCP0009_Shipment_Plan_FG.cs:2898 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dtInput.Columns.Add | ("p_from_site") | 데이터 객체 조작/조회 |  |  |  |
| AC-b34c3b22 | SaveButton | SCP0009_Shipment_Plan_FG.cs:2899 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dtInput.Columns.Add | ("p_bod_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-49e2c7ed | SaveButton | SCP0009_Shipment_Plan_FG.cs:2900 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dtInput.Columns.Add | ("p_measure") | 데이터 객체 조작/조회 |  |  |  |
| AC-ba8b55ac | SaveButton | SCP0009_Shipment_Plan_FG.cs:2901 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dtInput.Columns.Add | ("p_yyyymmdd") | 데이터 객체 조작/조회 |  |  |  |
| AC-c9bf1dcb | SaveButton | SCP0009_Shipment_Plan_FG.cs:2902 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dtInput.Columns.Add | ("p_qty") | 데이터 객체 조작/조회 |  |  |  |
| AC-bedc686c | SaveButton | SCP0009_Shipment_Plan_FG.cs:2903 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dtInput.Columns.Add | ("p_origin_from_division_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-b589fefa | SaveButton | SCP0009_Shipment_Plan_FG.cs:2904 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dtInput.Columns.Add | ("p_origin_to_division_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-0de4cd1f | SaveButton | SCP0009_Shipment_Plan_FG.cs:2905 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dtInput.Columns.Add | ("p_electrode_type") | 데이터 객체 조작/조회 |  |  |  |
| AC-5f6b8ba4 | SaveButton | SCP0009_Shipment_Plan_FG.cs:2906 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dtInput.Columns.Add | ("p_fix_reason") | 데이터 객체 조작/조회 |  |  |  |
| AC-b432a95a | SaveButton | SCP0009_Shipment_Plan_FG.cs:2907 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dtInput.Columns.Add | ("p_bucket_type") | 데이터 객체 조작/조회 |  |  |  |
| AC-41996ca2 | SaveButton | SCP0009_Shipment_Plan_FG.cs:2908 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dtInput.Columns.Add | ("p_trans_mode") | 데이터 객체 조작/조회 |  |  |  |
| AC-336f695b | SaveButton | SCP0009_Shipment_Plan_FG.cs:2909 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dtInput.Columns.Add | ("p_created_by") | 데이터 객체 조작/조회 |  |  |  |
| AC-a3436935 | SaveButton | SCP0009_Shipment_Plan_FG.cs:2910 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dtInput.Columns.Add | ("p_last_updated_by") | 데이터 객체 조작/조회 |  |  |  |
| AC-ebf81a49 | SaveButton | SCP0009_Shipment_Plan_FG.cs:2911 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dtInput.Columns.Add | ("p_time_zone") | 데이터 객체 조작/조회 |  |  |  |
| AC-8d10a4e3 | SaveButton | SCP0009_Shipment_Plan_FG.cs:2912 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dtInput.Columns.Add | ("debug_mode") | 데이터 객체 조작/조회 |  |  |  |
| AC-e38eea0c | SaveButton | SCP0009_Shipment_Plan_FG.cs:2913 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dsInput.Tables.Add | (dtInput) | 데이터 객체 조작/조회 |  |  |  |
| AC-cec9b851 | SaveButton | SCP0009_Shipment_Plan_FG.cs:2950 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboBucketType.ControlValues == B… | DATA_OP | saveDS.Tables[0].NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-d564e568 | SaveButton | SCP0009_Shipment_Plan_FG.cs:2951 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboBucketType.ControlValues == B… | DATA_OP | dr["A"] | action | 행/컬럼 값 대입 |  |  |  |
| AC-245f8cb1 | SaveButton | SCP0009_Shipment_Plan_FG.cs:2952 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboBucketType.ControlValues == B… | DATA_OP | dr["p_active_flag"] | action | 행/컬럼 값 대입 |  |  |  |
| AC-6fd65426 | SaveButton | SCP0009_Shipment_Plan_FG.cs:2953 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboBucketType.ControlValues == B… | DATA_OP | dr["p_division_id"] | siMain.GetValue(i, idxDIVISION_ID) | 행/컬럼 값 대입 |  |  |  |
| AC-f0d9a2db | SaveButton | SCP0009_Shipment_Plan_FG.cs:2954 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboBucketType.ControlValues == B… | DATA_OP | dr["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-0173ad81 | SaveButton | SCP0009_Shipment_Plan_FG.cs:2955 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboBucketType.ControlValues == B… | DATA_OP | dr["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-d41809dd | SaveButton | SCP0009_Shipment_Plan_FG.cs:2956 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboBucketType.ControlValues == B… | DATA_OP | dr["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-3eb6a27d | SaveButton | SCP0009_Shipment_Plan_FG.cs:2957 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboBucketType.ControlValues == B… | DATA_OP | dr["p_biz_type"] | siMain.GetValue(i, idxBIZ_TYPE) | 행/컬럼 값 대입 |  |  |  |
| AC-4009032e | SaveButton | SCP0009_Shipment_Plan_FG.cs:2958 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboBucketType.ControlValues == B… | DATA_OP | dr["p_project_code"] | siMain.GetValue(i, idxPROJECT_CODE) | 행/컬럼 값 대입 |  |  |  |
| AC-bd5c8d87 | SaveButton | SCP0009_Shipment_Plan_FG.cs:2959 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboBucketType.ControlValues == B… | DATA_OP | dr["p_item_id"] | siMain.GetValue(i, idxITEM_ID).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-cd0e432d | SaveButton | SCP0009_Shipment_Plan_FG.cs:2960 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboBucketType.ControlValues == B… | DATA_OP | dr["p_to_site"] | siMain.GetValue(i, idxTO_SITE) | 행/컬럼 값 대입 |  |  |  |
| AC-4e706cc7 | SaveButton | SCP0009_Shipment_Plan_FG.cs:2961 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboBucketType.ControlValues == B… | DATA_OP | dr["p_incoterms"] | siMain.GetValue(i, idxINCOTERMS) | 행/컬럼 값 대입 |  |  |  |
| AC-f5e8b8f4 | SaveButton | SCP0009_Shipment_Plan_FG.cs:2962 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboBucketType.ControlValues == B… | DATA_OP | dr["p_from_site"] | siMain.GetValue(i, idxFROM_SITE) | 행/컬럼 값 대입 |  |  |  |
| AC-2fd06827 | SaveButton | SCP0009_Shipment_Plan_FG.cs:2963 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboBucketType.ControlValues == B… | DATA_OP | dr["p_bod_id"] | siMain.GetValue(i, idxBOD_ID) | 행/컬럼 값 대입 |  |  |  |
| AC-d8842cef | SaveButton | SCP0009_Shipment_Plan_FG.cs:2964 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboBucketType.ControlValues == B… | DATA_OP | dr["p_measure"] | siMain.GetValue(i, idxMEASURE) | 행/컬럼 값 대입 |  |  |  |
| AC-9672bb96 | SaveButton | SCP0009_Shipment_Plan_FG.cs:2967 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboBucketType.ControlValues == B… | DATA_OP | dr["p_yyyymmdd"] | yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-9a3e3505 | SaveButton | SCP0009_Shipment_Plan_FG.cs:2968 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboBucketType.ControlValues == B… | DATA_OP | dr["p_qty"] | 0 | 행/컬럼 값 대입 |  |  |  |
| AC-b30274ef | SaveButton | SCP0009_Shipment_Plan_FG.cs:2977 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboBucketType.ControlValues == B… | DATA_OP | dr["p_origin_from_division_id"] | org_from_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-e12a637d | SaveButton | SCP0009_Shipment_Plan_FG.cs:2985 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboBucketType.ControlValues == B… | DATA_OP | dr["p_origin_to_division_id"] | org_to_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-c2fba3b9 | SaveButton | SCP0009_Shipment_Plan_FG.cs:2994 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboBucketType.ControlValues == B… | DATA_OP | dr["p_electrode_type"] | elec_type | 행/컬럼 값 대입 |  |  |  |
| AC-04ca8de6 | SaveButton | SCP0009_Shipment_Plan_FG.cs:2996 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboBucketType.ControlValues == B… | DATA_OP | dr["p_created_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-15694660 | SaveButton | SCP0009_Shipment_Plan_FG.cs:2997 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboBucketType.ControlValues == B… | DATA_OP | dr["p_last_updated_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-f57df9ed | SaveButton | SCP0009_Shipment_Plan_FG.cs:2998 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboBucketType.ControlValues == B… | DATA_OP | dr["p_time_zone"] | UserInfoContext.Current[UserInfoProperites.TimeZone] | 행/컬럼 값 대입 |  |  |  |
| AC-770aebab | SaveButton | SCP0009_Shipment_Plan_FG.cs:3000 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboBucketType.ControlValues == B… | DATA_OP | saveDS.Tables[0].Rows.Add | (dr) | 데이터 객체 조작/조회 |  |  |  |
| AC-1ecb5123 | SaveButton | SCP0009_Shipment_Plan_FG.cs:3005 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboBucketType.ControlValues == B… | DATA_OP | dsInput.Tables[0].NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-cd10d407 | SaveButton | SCP0009_Shipment_Plan_FG.cs:3006 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboBucketType.ControlValues == B… | DATA_OP | dRow["A"] | action | 행/컬럼 값 대입 |  |  |  |
| AC-000036bb | SaveButton | SCP0009_Shipment_Plan_FG.cs:3007 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboBucketType.ControlValues == B… | DATA_OP | dRow["p_active_flag"] | action | 행/컬럼 값 대입 |  |  |  |
| AC-5249c82d | SaveButton | SCP0009_Shipment_Plan_FG.cs:3008 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboBucketType.ControlValues == B… | DATA_OP | dRow["p_division_id"] | siMain.GetValue(i, idxDIVISION_ID) | 행/컬럼 값 대입 |  |  |  |
| AC-82f3d4ee | SaveButton | SCP0009_Shipment_Plan_FG.cs:3009 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboBucketType.ControlValues == B… | DATA_OP | dRow["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-b21d0b12 | SaveButton | SCP0009_Shipment_Plan_FG.cs:3010 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboBucketType.ControlValues == B… | DATA_OP | dRow["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-7982275c | SaveButton | SCP0009_Shipment_Plan_FG.cs:3011 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboBucketType.ControlValues == B… | DATA_OP | dRow["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-a766a1d8 | SaveButton | SCP0009_Shipment_Plan_FG.cs:3012 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboBucketType.ControlValues == B… | DATA_OP | dRow["p_biz_type"] | siMain.GetValue(i, idxBIZ_TYPE) | 행/컬럼 값 대입 |  |  |  |
| AC-5b6222d3 | SaveButton | SCP0009_Shipment_Plan_FG.cs:3013 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboBucketType.ControlValues == B… | DATA_OP | dRow["p_project_code"] | siMain.GetValue(i, idxPROJECT_CODE) | 행/컬럼 값 대입 |  |  |  |
| AC-f41d6172 | SaveButton | SCP0009_Shipment_Plan_FG.cs:3014 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboBucketType.ControlValues == B… | DATA_OP | dRow["p_item_id"] | siMain.GetValue(i, idxITEM_ID).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-8cfc0daf | SaveButton | SCP0009_Shipment_Plan_FG.cs:3015 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboBucketType.ControlValues == B… | DATA_OP | dRow["p_to_site"] | siMain.GetValue(i, idxTO_SITE) | 행/컬럼 값 대입 |  |  |  |
| AC-034a2669 | SaveButton | SCP0009_Shipment_Plan_FG.cs:3016 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboBucketType.ControlValues == B… | DATA_OP | dRow["p_incoterms"] | siMain.GetValue(i, idxINCOTERMS) | 행/컬럼 값 대입 |  |  |  |
| AC-12197167 | SaveButton | SCP0009_Shipment_Plan_FG.cs:3017 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboBucketType.ControlValues == B… | DATA_OP | dRow["p_from_site"] | siMain.GetValue(i, idxFROM_SITE) | 행/컬럼 값 대입 |  |  |  |
| AC-7b91260a | SaveButton | SCP0009_Shipment_Plan_FG.cs:3018 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboBucketType.ControlValues == B… | DATA_OP | dRow["p_bod_id"] | siMain.GetValue(i, idxBOD_ID) | 행/컬럼 값 대입 |  |  |  |
| AC-ea55e82a | SaveButton | SCP0009_Shipment_Plan_FG.cs:3019 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboBucketType.ControlValues == B… | DATA_OP | dRow["p_measure"] | siMain.GetValue(i, idxMEASURE) | 행/컬럼 값 대입 |  |  |  |
| AC-916b3ecc | SaveButton | SCP0009_Shipment_Plan_FG.cs:3020 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboBucketType.ControlValues == B… | DATA_OP | dRow["p_yyyymmdd"] | yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-74474efa | SaveButton | SCP0009_Shipment_Plan_FG.cs:3021 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboBucketType.ControlValues == B… | DATA_OP | dRow["p_qty"] | 0 | 행/컬럼 값 대입 |  |  |  |
| AC-c0733dd6 | SaveButton | SCP0009_Shipment_Plan_FG.cs:3022 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboBucketType.ControlValues == B… | DATA_OP | dRow["p_origin_from_division_id"] | org_from_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-4e69ab8d | SaveButton | SCP0009_Shipment_Plan_FG.cs:3023 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboBucketType.ControlValues == B… | DATA_OP | dRow["p_origin_to_division_id"] | org_to_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-c5f96caa | SaveButton | SCP0009_Shipment_Plan_FG.cs:3024 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboBucketType.ControlValues == B… | DATA_OP | dRow["p_electrode_type"] | elec_type | 행/컬럼 값 대입 |  |  |  |
| AC-75ebb9f3 | SaveButton | SCP0009_Shipment_Plan_FG.cs:3025 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboBucketType.ControlValues == B… | DATA_OP | dRow["p_created_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-dde71606 | SaveButton | SCP0009_Shipment_Plan_FG.cs:3026 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboBucketType.ControlValues == B… | DATA_OP | dRow["p_last_updated_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-2124c5af | SaveButton | SCP0009_Shipment_Plan_FG.cs:3027 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboBucketType.ControlValues == B… | DATA_OP | dRow["p_time_zone"] | UserInfoContext.Current[UserInfoProperites.TimeZone] | 행/컬럼 값 대입 |  |  |  |
| AC-6b0c8746 | SaveButton | SCP0009_Shipment_Plan_FG.cs:3028 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboBucketType.ControlValues == B… | DATA_OP | dRow["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-9c152d88 | SaveButton | SCP0009_Shipment_Plan_FG.cs:3029 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboBucketType.ControlValues == B… | DATA_OP | dsInput.Tables[0].Rows.Add | (dRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-a38bb983 | SaveButton | SCP0009_Shipment_Plan_FG.cs:3044 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboBucketType.ControlValues == B… | DATA_OP | saveDS.Tables[0].NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-e0dd7061 | SaveButton | SCP0009_Shipment_Plan_FG.cs:3045 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboBucketType.ControlValues == B… | DATA_OP | dr["A"] | action | 행/컬럼 값 대입 |  |  |  |
| AC-73d7c780 | SaveButton | SCP0009_Shipment_Plan_FG.cs:3046 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboBucketType.ControlValues == B… | DATA_OP | dr["p_active_flag"] | action | 행/컬럼 값 대입 |  |  |  |
| AC-f72af22b | SaveButton | SCP0009_Shipment_Plan_FG.cs:3047 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboBucketType.ControlValues == B… | DATA_OP | dr["p_division_id"] | siMain.GetValue(i, idxDIVISION_ID) | 행/컬럼 값 대입 |  |  |  |
| AC-d68f219b | SaveButton | SCP0009_Shipment_Plan_FG.cs:3048 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboBucketType.ControlValues == B… | DATA_OP | dr["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-1b01e541 | SaveButton | SCP0009_Shipment_Plan_FG.cs:3049 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboBucketType.ControlValues == B… | DATA_OP | dr["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-0eca3c47 | SaveButton | SCP0009_Shipment_Plan_FG.cs:3050 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboBucketType.ControlValues == B… | DATA_OP | dr["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-243886da | SaveButton | SCP0009_Shipment_Plan_FG.cs:3051 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboBucketType.ControlValues == B… | DATA_OP | dr["p_biz_type"] | siMain.GetValue(i, idxBIZ_TYPE) | 행/컬럼 값 대입 |  |  |  |
| AC-63dc83de | SaveButton | SCP0009_Shipment_Plan_FG.cs:3052 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboBucketType.ControlValues == B… | DATA_OP | dr["p_project_code"] | siMain.GetValue(i, idxPROJECT_CODE) | 행/컬럼 값 대입 |  |  |  |
| AC-9b522fdf | SaveButton | SCP0009_Shipment_Plan_FG.cs:3053 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboBucketType.ControlValues == B… | DATA_OP | dr["p_item_id"] | siMain.GetValue(i, idxITEM_ID).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-57884135 | SaveButton | SCP0009_Shipment_Plan_FG.cs:3054 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboBucketType.ControlValues == B… | DATA_OP | dr["p_to_site"] | siMain.GetValue(i, idxTO_SITE) | 행/컬럼 값 대입 |  |  |  |
| AC-cd66c9a3 | SaveButton | SCP0009_Shipment_Plan_FG.cs:3055 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboBucketType.ControlValues == B… | DATA_OP | dr["p_incoterms"] | siMain.GetValue(i, idxINCOTERMS) | 행/컬럼 값 대입 |  |  |  |
| AC-ac1767ff | SaveButton | SCP0009_Shipment_Plan_FG.cs:3056 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboBucketType.ControlValues == B… | DATA_OP | dr["p_from_site"] | siMain.GetValue(i, idxFROM_SITE) | 행/컬럼 값 대입 |  |  |  |
| AC-28bf9350 | SaveButton | SCP0009_Shipment_Plan_FG.cs:3057 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboBucketType.ControlValues == B… | DATA_OP | dr["p_bod_id"] | siMain.GetValue(i, idxBOD_ID) | 행/컬럼 값 대입 |  |  |  |
| AC-2c96029c | SaveButton | SCP0009_Shipment_Plan_FG.cs:3058 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboBucketType.ControlValues == B… | DATA_OP | dr["p_measure"] | siMain.GetValue(i, idxMEASURE) | 행/컬럼 값 대입 |  |  |  |
| AC-fa31be5d | SaveButton | SCP0009_Shipment_Plan_FG.cs:3061 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboBucketType.ControlValues == B… | DATA_OP | dr["p_yyyymmdd"] | yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-15925777 | SaveButton | SCP0009_Shipment_Plan_FG.cs:3062 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboBucketType.ControlValues == B… | DATA_OP | dr["p_qty"] | val | 행/컬럼 값 대입 |  |  |  |
| AC-68b28cd2 | SaveButton | SCP0009_Shipment_Plan_FG.cs:3071 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboBucketType.ControlValues == B… | DATA_OP | dr["p_origin_from_division_id"] | org_from_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-024e1264 | SaveButton | SCP0009_Shipment_Plan_FG.cs:3080 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboBucketType.ControlValues == B… | DATA_OP | dr["p_origin_to_division_id"] | org_to_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-c7f96751 | SaveButton | SCP0009_Shipment_Plan_FG.cs:3089 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboBucketType.ControlValues == B… | DATA_OP | dr["p_electrode_type"] | elec_type | 행/컬럼 값 대입 |  |  |  |
| AC-c82b72d6 | SaveButton | SCP0009_Shipment_Plan_FG.cs:3091 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboBucketType.ControlValues == B… | DATA_OP | dr["p_created_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-eb68b437 | SaveButton | SCP0009_Shipment_Plan_FG.cs:3092 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboBucketType.ControlValues == B… | DATA_OP | dr["p_last_updated_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-4ff5fe4e | SaveButton | SCP0009_Shipment_Plan_FG.cs:3093 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboBucketType.ControlValues == B… | DATA_OP | dr["p_time_zone"] | UserInfoContext.Current[UserInfoProperites.TimeZone] | 행/컬럼 값 대입 |  |  |  |
| AC-d60e75f6 | SaveButton | SCP0009_Shipment_Plan_FG.cs:3095 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboBucketType.ControlValues == B… | DATA_OP | saveDS.Tables[0].Rows.Add | (dr) | 데이터 객체 조작/조회 |  |  |  |
| AC-78d3f4ff | SaveButton | SCP0009_Shipment_Plan_FG.cs:3100 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboBucketType.ControlValues == B… | DATA_OP | dsInput.Tables[0].NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-d087144b | SaveButton | SCP0009_Shipment_Plan_FG.cs:3101 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboBucketType.ControlValues == B… | DATA_OP | dRow["A"] | action | 행/컬럼 값 대입 |  |  |  |
| AC-85ff1cc5 | SaveButton | SCP0009_Shipment_Plan_FG.cs:3102 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboBucketType.ControlValues == B… | DATA_OP | dRow["p_active_flag"] | action | 행/컬럼 값 대입 |  |  |  |
| AC-eba3a010 | SaveButton | SCP0009_Shipment_Plan_FG.cs:3103 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboBucketType.ControlValues == B… | DATA_OP | dRow["p_division_id"] | siMain.GetValue(i, idxDIVISION_ID) | 행/컬럼 값 대입 |  |  |  |
| AC-075f3d3a | SaveButton | SCP0009_Shipment_Plan_FG.cs:3104 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboBucketType.ControlValues == B… | DATA_OP | dRow["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-df1e7e92 | SaveButton | SCP0009_Shipment_Plan_FG.cs:3105 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboBucketType.ControlValues == B… | DATA_OP | dRow["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-eac8e8b8 | SaveButton | SCP0009_Shipment_Plan_FG.cs:3106 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboBucketType.ControlValues == B… | DATA_OP | dRow["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-e40a34ad | SaveButton | SCP0009_Shipment_Plan_FG.cs:3107 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboBucketType.ControlValues == B… | DATA_OP | dRow["p_biz_type"] | siMain.GetValue(i, idxBIZ_TYPE) | 행/컬럼 값 대입 |  |  |  |
| AC-eeb7e20e | SaveButton | SCP0009_Shipment_Plan_FG.cs:3108 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboBucketType.ControlValues == B… | DATA_OP | dRow["p_project_code"] | siMain.GetValue(i, idxPROJECT_CODE) | 행/컬럼 값 대입 |  |  |  |
| AC-0b17e0f1 | SaveButton | SCP0009_Shipment_Plan_FG.cs:3109 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboBucketType.ControlValues == B… | DATA_OP | dRow["p_item_id"] | siMain.GetValue(i, idxITEM_ID).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-36c30029 | SaveButton | SCP0009_Shipment_Plan_FG.cs:3110 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboBucketType.ControlValues == B… | DATA_OP | dRow["p_to_site"] | siMain.GetValue(i, idxTO_SITE) | 행/컬럼 값 대입 |  |  |  |
| AC-de115fcc | SaveButton | SCP0009_Shipment_Plan_FG.cs:3111 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboBucketType.ControlValues == B… | DATA_OP | dRow["p_incoterms"] | siMain.GetValue(i, idxINCOTERMS) | 행/컬럼 값 대입 |  |  |  |
| AC-294a5aad | SaveButton | SCP0009_Shipment_Plan_FG.cs:3112 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboBucketType.ControlValues == B… | DATA_OP | dRow["p_from_site"] | siMain.GetValue(i, idxFROM_SITE) | 행/컬럼 값 대입 |  |  |  |
| AC-74c65914 | SaveButton | SCP0009_Shipment_Plan_FG.cs:3113 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboBucketType.ControlValues == B… | DATA_OP | dRow["p_bod_id"] | siMain.GetValue(i, idxBOD_ID) | 행/컬럼 값 대입 |  |  |  |
| AC-022f6b6e | SaveButton | SCP0009_Shipment_Plan_FG.cs:3114 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboBucketType.ControlValues == B… | DATA_OP | dRow["p_measure"] | siMain.GetValue(i, idxMEASURE) | 행/컬럼 값 대입 |  |  |  |
| AC-fa82e9f6 | SaveButton | SCP0009_Shipment_Plan_FG.cs:3115 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboBucketType.ControlValues == B… | DATA_OP | dRow["p_yyyymmdd"] | yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-87a07e8e | SaveButton | SCP0009_Shipment_Plan_FG.cs:3116 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboBucketType.ControlValues == B… | DATA_OP | dRow["p_qty"] | val | 행/컬럼 값 대입 |  |  |  |
| AC-910899fc | SaveButton | SCP0009_Shipment_Plan_FG.cs:3117 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboBucketType.ControlValues == B… | DATA_OP | dRow["p_origin_from_division_id"] | org_from_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-232b4f5d | SaveButton | SCP0009_Shipment_Plan_FG.cs:3118 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboBucketType.ControlValues == B… | DATA_OP | dRow["p_origin_to_division_id"] | org_to_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-2a9b440e | SaveButton | SCP0009_Shipment_Plan_FG.cs:3119 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboBucketType.ControlValues == B… | DATA_OP | dRow["p_electrode_type"] | elec_type | 행/컬럼 값 대입 |  |  |  |
| AC-8ebf0532 | SaveButton | SCP0009_Shipment_Plan_FG.cs:3120 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboBucketType.ControlValues == B… | DATA_OP | dRow["p_created_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-4d3a65e0 | SaveButton | SCP0009_Shipment_Plan_FG.cs:3121 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboBucketType.ControlValues == B… | DATA_OP | dRow["p_last_updated_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-378d9792 | SaveButton | SCP0009_Shipment_Plan_FG.cs:3122 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboBucketType.ControlValues == B… | DATA_OP | dRow["p_time_zone"] | UserInfoContext.Current[UserInfoProperites.TimeZone] | 행/컬럼 값 대입 |  |  |  |
| AC-3b442389 | SaveButton | SCP0009_Shipment_Plan_FG.cs:3123 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboBucketType.ControlValues == B… | DATA_OP | dRow["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-6dcd8ef6 | SaveButton | SCP0009_Shipment_Plan_FG.cs:3124 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboBucketType.ControlValues == B… | DATA_OP | dsInput.Tables[0].Rows.Add | (dRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-c5fd6941 | SaveButton | SCP0009_Shipment_Plan_FG.cs:3142 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboBucketType.ControlValues == B… | DATA_OP | saveDS.Tables[0].NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-20c03eec | SaveButton | SCP0009_Shipment_Plan_FG.cs:3143 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboBucketType.ControlValues == B… | DATA_OP | dr["A"] | action | 행/컬럼 값 대입 |  |  |  |
| AC-12c4d864 | SaveButton | SCP0009_Shipment_Plan_FG.cs:3144 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboBucketType.ControlValues == B… | DATA_OP | dr["p_active_flag"] | action | 행/컬럼 값 대입 |  |  |  |
| AC-015cc0d4 | SaveButton | SCP0009_Shipment_Plan_FG.cs:3145 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboBucketType.ControlValues == B… | DATA_OP | dr["p_division_id"] | siMain.GetValue(i, idxDIVISION_ID) | 행/컬럼 값 대입 |  |  |  |
| AC-77f503b0 | SaveButton | SCP0009_Shipment_Plan_FG.cs:3146 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboBucketType.ControlValues == B… | DATA_OP | dr["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-c87abbc0 | SaveButton | SCP0009_Shipment_Plan_FG.cs:3147 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboBucketType.ControlValues == B… | DATA_OP | dr["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-38eb3e1c | SaveButton | SCP0009_Shipment_Plan_FG.cs:3148 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboBucketType.ControlValues == B… | DATA_OP | dr["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-d75747bd | SaveButton | SCP0009_Shipment_Plan_FG.cs:3149 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboBucketType.ControlValues == B… | DATA_OP | dr["p_biz_type"] | siMain.GetValue(i, idxBIZ_TYPE) | 행/컬럼 값 대입 |  |  |  |
| AC-fc70e28c | SaveButton | SCP0009_Shipment_Plan_FG.cs:3150 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboBucketType.ControlValues == B… | DATA_OP | dr["p_project_code"] | siMain.GetValue(i, idxPROJECT_CODE) | 행/컬럼 값 대입 |  |  |  |
| AC-a0eae2c7 | SaveButton | SCP0009_Shipment_Plan_FG.cs:3151 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboBucketType.ControlValues == B… | DATA_OP | dr["p_item_id"] | siMain.GetValue(i, idxITEM_ID).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-48cd1883 | SaveButton | SCP0009_Shipment_Plan_FG.cs:3153 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboBucketType.ControlValues == B… | DATA_OP | dr["p_to_site"] | siMain.GetValue(i, idxTO_SITE) | 행/컬럼 값 대입 |  |  |  |
| AC-7f5276fe | SaveButton | SCP0009_Shipment_Plan_FG.cs:3154 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboBucketType.ControlValues == B… | DATA_OP | dr["p_incoterms"] | siMain.GetValue(i, idxINCOTERMS) | 행/컬럼 값 대입 |  |  |  |
| AC-d0ba3182 | SaveButton | SCP0009_Shipment_Plan_FG.cs:3155 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboBucketType.ControlValues == B… | DATA_OP | dr["p_from_site"] | siMain.GetValue(i, idxFROM_SITE) | 행/컬럼 값 대입 |  |  |  |
| AC-a1dcdc5e | SaveButton | SCP0009_Shipment_Plan_FG.cs:3156 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboBucketType.ControlValues == B… | DATA_OP | dr["p_bod_id"] | siMain.GetValue(i, idxBOD_ID) | 행/컬럼 값 대입 |  |  |  |
| AC-65c8cd37 | SaveButton | SCP0009_Shipment_Plan_FG.cs:3157 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboBucketType.ControlValues == B… | DATA_OP | dr["p_measure"] | siMain.GetValue(i, idxMEASURE) | 행/컬럼 값 대입 |  |  |  |
| AC-78efd2b6 | SaveButton | SCP0009_Shipment_Plan_FG.cs:3160 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboBucketType.ControlValues == B… | DATA_OP | dr["p_yyyymmdd"] | yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-2ba6d227 | SaveButton | SCP0009_Shipment_Plan_FG.cs:3161 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboBucketType.ControlValues == B… | DATA_OP | dr["p_qty"] | strQty | 행/컬럼 값 대입 |  |  |  |
| AC-8d4179f9 | SaveButton | SCP0009_Shipment_Plan_FG.cs:3171 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboBucketType.ControlValues == B… | DATA_OP | dr["p_origin_from_division_id"] | org_from_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-03ba232b | SaveButton | SCP0009_Shipment_Plan_FG.cs:3180 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboBucketType.ControlValues == B… | DATA_OP | dr["p_origin_to_division_id"] | org_to_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-6651eda9 | SaveButton | SCP0009_Shipment_Plan_FG.cs:3189 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboBucketType.ControlValues == B… | DATA_OP | dr["p_electrode_type"] | elec_type | 행/컬럼 값 대입 |  |  |  |
| AC-b33602ee | SaveButton | SCP0009_Shipment_Plan_FG.cs:3191 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboBucketType.ControlValues == B… | DATA_OP | dr["p_created_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-8e0ed893 | SaveButton | SCP0009_Shipment_Plan_FG.cs:3192 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboBucketType.ControlValues == B… | DATA_OP | dr["p_last_updated_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-b372967f | SaveButton | SCP0009_Shipment_Plan_FG.cs:3193 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboBucketType.ControlValues == B… | DATA_OP | dr["p_time_zone"] | UserInfoContext.Current[UserInfoProperites.TimeZone] | 행/컬럼 값 대입 |  |  |  |
| AC-e303ee4d | SaveButton | SCP0009_Shipment_Plan_FG.cs:3195 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboBucketType.ControlValues == B… | DATA_OP | saveDS.Tables[0].Rows.Add | (dr) | 데이터 객체 조작/조회 |  |  |  |
| AC-b478e8e0 | SaveButton | SCP0009_Shipment_Plan_FG.cs:3200 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboBucketType.ControlValues == B… | DATA_OP | dsInput.Tables[0].NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-05b9dd48 | SaveButton | SCP0009_Shipment_Plan_FG.cs:3201 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboBucketType.ControlValues == B… | DATA_OP | dRow["A"] | action | 행/컬럼 값 대입 |  |  |  |
| AC-c968b5cb | SaveButton | SCP0009_Shipment_Plan_FG.cs:3202 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboBucketType.ControlValues == B… | DATA_OP | dRow["p_active_flag"] | action | 행/컬럼 값 대입 |  |  |  |
| AC-0cecc8ba | SaveButton | SCP0009_Shipment_Plan_FG.cs:3203 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboBucketType.ControlValues == B… | DATA_OP | dRow["p_division_id"] | siMain.GetValue(i, idxDIVISION_ID) | 행/컬럼 값 대입 |  |  |  |
| AC-06f2751e | SaveButton | SCP0009_Shipment_Plan_FG.cs:3204 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboBucketType.ControlValues == B… | DATA_OP | dRow["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-a12d38d2 | SaveButton | SCP0009_Shipment_Plan_FG.cs:3205 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboBucketType.ControlValues == B… | DATA_OP | dRow["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-3f612677 | SaveButton | SCP0009_Shipment_Plan_FG.cs:3206 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboBucketType.ControlValues == B… | DATA_OP | dRow["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-a702415b | SaveButton | SCP0009_Shipment_Plan_FG.cs:3207 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboBucketType.ControlValues == B… | DATA_OP | dRow["p_biz_type"] | siMain.GetValue(i, idxBIZ_TYPE) | 행/컬럼 값 대입 |  |  |  |
| AC-b208ada3 | SaveButton | SCP0009_Shipment_Plan_FG.cs:3208 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboBucketType.ControlValues == B… | DATA_OP | dRow["p_project_code"] | siMain.GetValue(i, idxPROJECT_CODE) | 행/컬럼 값 대입 |  |  |  |
| AC-dc456bbc | SaveButton | SCP0009_Shipment_Plan_FG.cs:3209 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboBucketType.ControlValues == B… | DATA_OP | dRow["p_item_id"] | siMain.GetValue(i, idxITEM_ID).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-6a85cb82 | SaveButton | SCP0009_Shipment_Plan_FG.cs:3210 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboBucketType.ControlValues == B… | DATA_OP | dRow["p_to_site"] | siMain.GetValue(i, idxTO_SITE) | 행/컬럼 값 대입 |  |  |  |
| AC-420b0d6e | SaveButton | SCP0009_Shipment_Plan_FG.cs:3211 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboBucketType.ControlValues == B… | DATA_OP | dRow["p_incoterms"] | siMain.GetValue(i, idxINCOTERMS) | 행/컬럼 값 대입 |  |  |  |
| AC-ba277813 | SaveButton | SCP0009_Shipment_Plan_FG.cs:3212 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboBucketType.ControlValues == B… | DATA_OP | dRow["p_from_site"] | siMain.GetValue(i, idxFROM_SITE) | 행/컬럼 값 대입 |  |  |  |
| AC-48587953 | SaveButton | SCP0009_Shipment_Plan_FG.cs:3213 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboBucketType.ControlValues == B… | DATA_OP | dRow["p_bod_id"] | siMain.GetValue(i, idxBOD_ID) | 행/컬럼 값 대입 |  |  |  |
| AC-1d5b1ede | SaveButton | SCP0009_Shipment_Plan_FG.cs:3214 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboBucketType.ControlValues == B… | DATA_OP | dRow["p_measure"] | siMain.GetValue(i, idxMEASURE) | 행/컬럼 값 대입 |  |  |  |
| AC-5433eaa4 | SaveButton | SCP0009_Shipment_Plan_FG.cs:3215 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboBucketType.ControlValues == B… | DATA_OP | dRow["p_yyyymmdd"] | yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-1f4adb37 | SaveButton | SCP0009_Shipment_Plan_FG.cs:3216 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboBucketType.ControlValues == B… | DATA_OP | dRow["p_qty"] | strQty | 행/컬럼 값 대입 |  |  |  |
| AC-aeca2466 | SaveButton | SCP0009_Shipment_Plan_FG.cs:3217 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboBucketType.ControlValues == B… | DATA_OP | dRow["p_origin_from_division_id"] | org_from_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-910b3872 | SaveButton | SCP0009_Shipment_Plan_FG.cs:3218 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboBucketType.ControlValues == B… | DATA_OP | dRow["p_origin_to_division_id"] | org_to_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-e96a9723 | SaveButton | SCP0009_Shipment_Plan_FG.cs:3219 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboBucketType.ControlValues == B… | DATA_OP | dRow["p_bucket_type"] | p_bucket | 행/컬럼 값 대입 |  |  |  |
| AC-7fb2b638 | SaveButton | SCP0009_Shipment_Plan_FG.cs:3220 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboBucketType.ControlValues == B… | DATA_OP | dRow["p_electrode_type"] | elec_type | 행/컬럼 값 대입 |  |  |  |
| AC-5ed05821 | SaveButton | SCP0009_Shipment_Plan_FG.cs:3221 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboBucketType.ControlValues == B… | DATA_OP | dRow["p_created_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-c846b39b | SaveButton | SCP0009_Shipment_Plan_FG.cs:3222 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboBucketType.ControlValues == B… | DATA_OP | dRow["p_last_updated_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-cda46c06 | SaveButton | SCP0009_Shipment_Plan_FG.cs:3223 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboBucketType.ControlValues == B… | DATA_OP | dRow["p_time_zone"] | UserInfoContext.Current[UserInfoProperites.TimeZone] | 행/컬럼 값 대입 |  |  |  |
| AC-0bf127a3 | SaveButton | SCP0009_Shipment_Plan_FG.cs:3224 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboBucketType.ControlValues == B… | DATA_OP | dRow["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-0348ed44 | SaveButton | SCP0009_Shipment_Plan_FG.cs:3225 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboBucketType.ControlValues == B… | DATA_OP | dsInput.Tables[0].Rows.Add | (dRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-4db856ca | SaveButton | SCP0009_Shipment_Plan_FG.cs:3230 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboBucketType.ControlValues == B… | GRID_SET | saveDS.Tables[0].Rows[0]["p_first_row"] | "Y" | 그리드 속성/값 설정 |  |  |  |
| AC-f5212254 | SaveButton | SCP0009_Shipment_Plan_FG.cs:3231 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboBucketType.ControlValues == B… | GRID_SET | saveDS.Tables[0].Rows[iCount - 1]["p_last_row"] | "Y" | 그리드 속성/값 설정 |  |  |  |
| AC-f734b5d7 | SaveButton | SCP0009_Shipment_Plan_FG.cs:3233 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (cboBucketType.ControlValues == B… | DATA_OP | saveDS.Tables[0].AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-cd44646c | SaveButton | SCP0009_Shipment_Plan_FG.cs:3280 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboBucketType.ControlValues… | GRID_STYLE | siMain.SetBGColor | (i, j, i, j, ControlColor.InvalidColor) | 그리드 표시 설정 |  |  |  |
| AC-6f40df61 | SaveButton | SCP0009_Shipment_Plan_FG.cs:3281 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboBucketType.ControlValues… | MESSAGE | MessageHelper.GMessageBox | ("MSG00084", new object[]{ null }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-4e05c833 | SaveButton | SCP0009_Shipment_Plan_FG.cs:3282 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboBucketType.ControlValues… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3bb5d8e7 | SaveButton | SCP0009_Shipment_Plan_FG.cs:3286 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboBucketType.ControlValues… | GRID_STYLE | siMain.SetBGColor | (i, j, i, j, ControlColor.InvalidColor) | 그리드 표시 설정 |  |  |  |
| AC-15670f3f | SaveButton | SCP0009_Shipment_Plan_FG.cs:3288 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboBucketType.ControlValues… | MESSAGE | MessageHelper.GMessageBox | ("MSG00317", new object[]{ message }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-4bdf72e9 | SaveButton | SCP0009_Shipment_Plan_FG.cs:3289 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboBucketType.ControlValues… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2872db0a | SaveButton | SCP0009_Shipment_Plan_FG.cs:3293 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboBucketType.ControlValues… | DATA_OP | dsInput.Tables[0].NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-5f93cb83 | SaveButton | SCP0009_Shipment_Plan_FG.cs:3294 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboBucketType.ControlValues… | DATA_OP | dr["A"] | action | 행/컬럼 값 대입 |  |  |  |
| AC-b4305e8e | SaveButton | SCP0009_Shipment_Plan_FG.cs:3295 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboBucketType.ControlValues… | DATA_OP | dr["p_active_flag"] | action | 행/컬럼 값 대입 |  |  |  |
| AC-14d8f5ee | SaveButton | SCP0009_Shipment_Plan_FG.cs:3296 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboBucketType.ControlValues… | DATA_OP | dr["p_division_id"] | siMain.GetValue(i, idxDIVISION_ID) | 행/컬럼 값 대입 |  |  |  |
| AC-bba8b21c | SaveButton | SCP0009_Shipment_Plan_FG.cs:3297 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboBucketType.ControlValues… | DATA_OP | dr["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-85455dbe | SaveButton | SCP0009_Shipment_Plan_FG.cs:3298 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboBucketType.ControlValues… | DATA_OP | dr["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-abe978f0 | SaveButton | SCP0009_Shipment_Plan_FG.cs:3299 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboBucketType.ControlValues… | DATA_OP | dr["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-e4d1ed07 | SaveButton | SCP0009_Shipment_Plan_FG.cs:3300 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboBucketType.ControlValues… | DATA_OP | dr["p_biz_type"] | siMain.GetValue(i, idxBIZ_TYPE) | 행/컬럼 값 대입 |  |  |  |
| AC-f3bc4a96 | SaveButton | SCP0009_Shipment_Plan_FG.cs:3301 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboBucketType.ControlValues… | DATA_OP | dr["p_project_code"] | siMain.GetValue(i, idxPROJECT_CODE) | 행/컬럼 값 대입 |  |  |  |
| AC-9d174c67 | SaveButton | SCP0009_Shipment_Plan_FG.cs:3302 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboBucketType.ControlValues… | DATA_OP | dr["p_item_id"] | siMain.GetValue(i, idxITEM_ID).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-d9d7b32f | SaveButton | SCP0009_Shipment_Plan_FG.cs:3303 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboBucketType.ControlValues… | DATA_OP | dr["p_to_site"] | siMain.GetValue(i, idxTO_SITE) | 행/컬럼 값 대입 |  |  |  |
| AC-4742869d | SaveButton | SCP0009_Shipment_Plan_FG.cs:3304 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboBucketType.ControlValues… | DATA_OP | dr["p_incoterms"] | siMain.GetValue(i, idxINCOTERMS) | 행/컬럼 값 대입 |  |  |  |
| AC-4c50d6d0 | SaveButton | SCP0009_Shipment_Plan_FG.cs:3305 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboBucketType.ControlValues… | DATA_OP | dr["p_from_site"] | siMain.GetValue(i, idxFROM_SITE) | 행/컬럼 값 대입 |  |  |  |
| AC-9f4ac5ce | SaveButton | SCP0009_Shipment_Plan_FG.cs:3306 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboBucketType.ControlValues… | DATA_OP | dr["p_bod_id"] | siMain.GetValue(i, idxBOD_ID) | 행/컬럼 값 대입 |  |  |  |
| AC-53cf4f51 | SaveButton | SCP0009_Shipment_Plan_FG.cs:3307 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboBucketType.ControlValues… | DATA_OP | dr["p_measure"] | siMain.GetValue(i, idxMEASURE) | 행/컬럼 값 대입 |  |  |  |
| AC-b12bc85b | SaveButton | SCP0009_Shipment_Plan_FG.cs:3308 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboBucketType.ControlValues… | DATA_OP | dr["p_yyyymmdd"] | strWeekName == "20230152" ? "20220152" : strWeekName | 행/컬럼 값 대입 |  |  |  |
| AC-8214607f | SaveButton | SCP0009_Shipment_Plan_FG.cs:3309 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboBucketType.ControlValues… | DATA_OP | dr["p_qty"] | strWeekQty | 행/컬럼 값 대입 |  |  |  |
| AC-1055c553 | SaveButton | SCP0009_Shipment_Plan_FG.cs:3317 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboBucketType.ControlValues… | DATA_OP | dr["p_origin_from_division_id"] | org_from_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-63f80446 | SaveButton | SCP0009_Shipment_Plan_FG.cs:3326 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboBucketType.ControlValues… | DATA_OP | dr["p_origin_to_division_id"] | org_to_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-86cef7c5 | SaveButton | SCP0009_Shipment_Plan_FG.cs:3327 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboBucketType.ControlValues… | DATA_OP | dr["p_bucket_type"] | p_bucket | 행/컬럼 값 대입 |  |  |  |
| AC-64aed3ae | SaveButton | SCP0009_Shipment_Plan_FG.cs:3328 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboBucketType.ControlValues… | DATA_OP | dr["p_trans_mode"] | siMain.GetValue(i, idxTRANSPORT_MODE).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-35eefabf | SaveButton | SCP0009_Shipment_Plan_FG.cs:3329 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboBucketType.ControlValues… | DATA_OP | dr["p_created_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-85ec9b73 | SaveButton | SCP0009_Shipment_Plan_FG.cs:3330 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboBucketType.ControlValues… | DATA_OP | dr["p_last_updated_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-2a60c550 | SaveButton | SCP0009_Shipment_Plan_FG.cs:3331 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboBucketType.ControlValues… | DATA_OP | dr["p_time_zone"] | UserInfoContext.Current[UserInfoProperites.TimeZone] | 행/컬럼 값 대입 |  |  |  |
| AC-a1ce4799 | SaveButton | SCP0009_Shipment_Plan_FG.cs:3332 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboBucketType.ControlValues… | DATA_OP | dr["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-de11100a | SaveButton | SCP0009_Shipment_Plan_FG.cs:3333 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboBucketType.ControlValues… | DATA_OP | dsInput.Tables[0].Rows.Add | (dr) | 데이터 객체 조작/조회 |  |  |  |
| AC-dd26d131 | SaveButton | SCP0009_Shipment_Plan_FG.cs:3341 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ else of (cboBucketType.ControlValues… | DATA_OP | dsInput.Tables[0].AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-64a5e2c4 | SaveButton | SCP0009_Shipment_Plan_FG.cs:3347 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (iCount > 0) | DATA_OP | dsInput.Tables[0].AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-d9df069a | SaveButton | SCP0009_Shipment_Plan_FG.cs:3362 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (iCount > 0) ▸ try | CALL_EXT | sql.AddParameter | ("@SCP0009", dsInput.Tables[0]) | ⚠ 의미 확인 필요 |  |  |  |
| AC-db588878 | SaveButton | SCP0009_Shipment_Plan_FG.cs:3364 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (iCount > 0) ▸ try | ENDPOINT | sql.ExcuteProcedure | ("SaveShipmentPlanFGWeekly") ⇒ biz:AppService.GeneralRunProcedureCustomTable [procedure=SaveShipmentPlanFGWeekl… | 엔드포인트 호출 |  |  |  |
| AC-073427df | SaveButton | SCP0009_Shipment_Plan_FG.cs:3367 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (iCount > 0) ▸ try | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-6a54dc46 | SaveButton | SCP0009_Shipment_Plan_FG.cs:3372 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (iCount > 0) ▸ try ▸ if (result !… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { result.Rows[0]["result_cnt"].ToString() }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-4afbe446 | SaveButton | SCP0009_Shipment_Plan_FG.cs:3381 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (iCount > 0) ▸ try ▸ else of (res… | MESSAGE | MessageHelper.GMessageBox | ("MSG00003", new object[] { ReErrorMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a82c4639 | SaveButton | SCP0009_Shipment_Plan_FG.cs:3390 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (iCount > 0) ▸ catch ((Exception … | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-434beb22 | SaveButton | SCP0009_Shipment_Plan_FG.cs:3391 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (iCount > 0) ▸ catch ((Exception … | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-fae922a1 | SaveButton | SCP0009_Shipment_Plan_FG.cs:3397 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (iCount > 0) ▸ finally ▸ if (!prg… | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-d151c7f1 | SaveButton | SCP0009_Shipment_Plan_FG.cs:3453 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-45874295 | SaveButton | SCP0009_Shipment_Plan_FG.cs:3455 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-29045e73 | SaveButton | SCP0009_Shipment_Plan_FG.cs:3459 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-5e34a8b6 | SaveButton | SCP0009_Shipment_Plan_FG.cs:3460 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## SCP0009_Shipment_Plan_FG.SCM_SYS_LOG_BATCH

진입점: this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock(siMain.SheetName)) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ if (iCount > 0) ▸ try] / this.btnUnfix.Click [if (fps != null) ▸ else of (siMain.IsLock(siMain.SheetName)) ▸ if (MessageHelper.GMessageBox("MSG00016") == DialogResult.Yes) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ if (iCount > 0) ▸ try] / SaveButton [if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (iCount > 0) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d7154926 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 2 | SCP0009_Shipment_Plan_FG.cs:4707 | try | ENDPOINT | new FoxDataRequest | ("SCP.PR_SCM_SYS_LOG_BATCH") ⇒ SCP.PR_SCM_SYS_LOG_BATCH | 엔드포인트 요청 생성 |  |  |  |
| AC-7c34a63a | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 2 | SCP0009_Shipment_Plan_FG.cs:4708 | try | DATA_OP | request.Parameters["p_program_name"] | p_program_name | 행/컬럼 값 대입 |  |  |  |
| AC-3ce18f88 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 2 | SCP0009_Shipment_Plan_FG.cs:4709 | try | DATA_OP | request.Parameters["p_log_type"] | p_log_type | 행/컬럼 값 대입 |  |  |  |
| AC-05a71dd7 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 2 | SCP0009_Shipment_Plan_FG.cs:4710 | try | DATA_OP | request.Parameters["p_log_count"] | p_log_count | 행/컬럼 값 대입 |  |  |  |
| AC-661fab48 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 2 | SCP0009_Shipment_Plan_FG.cs:4711 | try | DATA_OP | request.Parameters["p_log_message"] | p_log_message | 행/컬럼 값 대입 |  |  |  |
| AC-af62c72f | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 2 | SCP0009_Shipment_Plan_FG.cs:4712 | try | DATA_OP | request.Parameters["p_description"] | p_description | 행/컬럼 값 대입 |  |  |  |
| AC-0e37e2dc | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 2 | SCP0009_Shipment_Plan_FG.cs:4713 | try | DATA_OP | request.Parameters["p_event_date"] | DateTime.Now | 행/컬럼 값 대입 |  |  |  |
| AC-c4233697 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 2 | SCP0009_Shipment_Plan_FG.cs:4715 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## SCP0009_Shipment_Plan_FG.Set_FixButtonEnabled

진입점: this.Load / cboPlanDate.SelectedIndexChanged / cboPlanType.SelectedIndexChanged / cboPlanSeq.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-90b00954 | this.Load 외 3 | SCP0009_Shipment_Plan_FG.cs:3983 | if (sPlanType.Equals("FN") \|\| sPlanType.Equals("TE")) | STATE | btnFix.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-93930cf9 | this.Load 외 3 | SCP0009_Shipment_Plan_FG.cs:3984 | if (sPlanType.Equals("FN") \|\| sPlanType.Equals("TE")) | STATE | btnUnfix.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-b333394d | this.Load 외 3 | SCP0009_Shipment_Plan_FG.cs:3985 | if (sPlanType.Equals("FN") \|\| sPlanType.Equals("TE")) | STATE | btnNew.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-bcdb633a | this.Load 외 3 | SCP0009_Shipment_Plan_FG.cs:3990 | else of (sPlanType.Equals("FN") \|\| sPlanType.Equals("TE")) ▸ if (!string.IsNullOrEmpty(CString.GetCheckedListValue(dtPlanSeq, cboPlanSeq.C… | DATA_OP | dtPlanSeq.AsEnumerable().Select | (a => a.Field<int>("CODE")) | 데이터 객체 조작/조회 |  |  |  |
| AC-89e457b7 | this.Load 외 3 | SCP0009_Shipment_Plan_FG.cs:3990 | else of (sPlanType.Equals("FN") \|\| sPlanType.Equals("TE")) ▸ if (!string.IsNullOrEmpty(CString.GetCheckedListValue(dtPlanSeq, cboPlanSeq.C… | DATA_OP | a.Field | ("CODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-a14b2c74 | this.Load 외 3 | SCP0009_Shipment_Plan_FG.cs:3993 | else of (sPlanType.Equals("FN") \|\| sPlanType.Equals("TE")) ▸ if (!string.IsNullOrEmpty(CString.GetCheckedListValue(dtPlanSeq, cboPlanSeq.C… | STATE | btnFix.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-599967e9 | this.Load 외 3 | SCP0009_Shipment_Plan_FG.cs:3994 | else of (sPlanType.Equals("FN") \|\| sPlanType.Equals("TE")) ▸ if (!string.IsNullOrEmpty(CString.GetCheckedListValue(dtPlanSeq, cboPlanSeq.C… | STATE | btnUnfix.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-dcf36bbb | this.Load 외 3 | SCP0009_Shipment_Plan_FG.cs:3998 | else of (sPlanType.Equals("FN") \|\| sPlanType.Equals("TE")) ▸ if (!string.IsNullOrEmpty(CString.GetCheckedListValue(dtPlanSeq, cboPlanSeq.C… | STATE | btnFix.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-2195c317 | this.Load 외 3 | SCP0009_Shipment_Plan_FG.cs:3999 | else of (sPlanType.Equals("FN") \|\| sPlanType.Equals("TE")) ▸ if (!string.IsNullOrEmpty(CString.GetCheckedListValue(dtPlanSeq, cboPlanSeq.C… | STATE | btnUnfix.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-a1e2015a | this.Load 외 3 | SCP0009_Shipment_Plan_FG.cs:4000 | else of (sPlanType.Equals("FN") \|\| sPlanType.Equals("TE")) ▸ if (!string.IsNullOrEmpty(CString.GetCheckedListValue(dtPlanSeq, cboPlanSeq.C… | STATE | btnNew.Enabled | false | 컨트롤 상태 Enabled |  |  |  |

## SCP0009_Shipment_Plan_FG.Set_FixCellColor

진입점: this.spdMain.CellClick [if ((e.Column == siMain.GetColumnIndex(DefMain.TRANSPORT_MODE) \|\| e.Column == siMain.GetColumnIndex(DefMain.FROM_SITE_NAME))…)] / this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock(siMain.SheetName)) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ if (iCount > 0) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Equals("S")) ▸ try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ if (dsBinding.Tables[2].Rows.Count>0)] / this.btnUnfix.Click [if (fps != null) ▸ else of (siMain.IsLock(siMain.SheetName)) ▸ if (Message…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-17b5aceb | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… 외 6 | SCP0009_Shipment_Plan_FG.cs:1650 |  | FLAG | dtFix | dsBinding.Tables[2] | 화면 필드/플래그 변경 |  |  |  |
| AC-5f163053 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… 외 6 | SCP0009_Shipment_Plan_FG.cs:1697 | for (nRow < siMain.ActiveSheet.Rows.Count) ▸ if (measure.Equals("SHIP_PLAN_AMEND")) | DATA_OP | dtFix.Select | (filter) | 데이터 객체 조작/조회 |  |  |  |
| AC-f48b3e03 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… 외 6 | SCP0009_Shipment_Plan_FG.cs:1706 | for (nRow < siMain.ActiveSheet.Rows.Count) ▸ if (measure.Equals("SHIP_PLAN_AMEND")) ▸ if (res.Count() > 0) ▸ foreach (DataRow dr in res) | GRID_STYLE | siMain.SetBGColor2 | (nRow, siMain.GetColumnIndex(sDay), nRow, siMain.GetColumnIndex(sDay), Color.FromArgb(188,… | 그리드 표시 설정 |  |  |  |
| AC-b1fb93e9 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… 외 6 | SCP0009_Shipment_Plan_FG.cs:1718 | for (nRow < siMain.ActiveSheet.Rows.Count) ▸ if (measure.Equals("SHIP_PLAN_AMEND")) ▸ if (res.Count() > 0) ▸ foreach (DataRow dr in res) ▸ i… | GRID_STYLE | siMain.SetBGColor2 | (nRow, iCol, nRow, iCol, Color.FromArgb(188, 229, 92)) | 그리드 표시 설정 |  |  |  |

## SCP0009_Shipment_Plan_FG.Set_FPOperationColor

진입점: this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock(siMain.SheetName)) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ if (iCount > 0) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Equals("S")) ▸ try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ if (p_bucket.ToString() == BucketType.Daily \|\| chkAll.Checked)] / this.btnUnfix.Click [if (fps != null) ▸ else of (siMain.IsLock(siMain.SheetName)) ▸ if (MessageHelper.GMessageBox("MSG00016") == DialogResult.Yes) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ if (iCount > 0) ▸ try ▸ …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2b9e38e1 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 5 | SCP0009_Shipment_Plan_FG.cs:1784 | for (nRow < siMain.ActiveSheet.Rows.Count) ▸ if (siMain.ActiveSheet.GetText(nRow, siMain.GetColumnIndex(DefMain.MEASURE)).ToString() == "SHI… | GRID_STYLE | siMain.SetBGColor | (nRow, befCol, nRow, nCol - 1, Color.FromArgb(234, 234, 234)) | 그리드 표시 설정 |  |  |  |
| AC-ddc68807 | this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock… 외 5 | SCP0009_Shipment_Plan_FG.cs:1789 | for (nRow < siMain.ActiveSheet.Rows.Count) ▸ if (siMain.ActiveSheet.GetText(nRow, siMain.GetColumnIndex(DefMain.MEASURE)).ToString() == "SHI… | GRID_STYLE | siMain.SetBGColor | (nRow, befCol, nRow, nCol, Color.FromArgb(234, 234, 234)) | 그리드 표시 설정 |  |  |  |

## SCP0009_Shipment_Plan_FG.Set_InsertColumnsFont

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-76215e62 | (진입점 미연결) | SCP0009_Shipment_Plan_FG.cs:2574 | if (bBold) | UI_PROP | range1.Font | new System.Drawing.Font(spdMain.Font.Name, spdMain.Font.Size, FontStyle.Bold) | 속성 Font 설정 |  |  |  |
| AC-56735470 | (진입점 미연결) | SCP0009_Shipment_Plan_FG.cs:2577 | else of (bBold) | UI_PROP | range1.Font | new System.Drawing.Font(spdMain.Font.Name, spdMain.Font.Size, FontStyle.Regular) | 속성 Font 설정 |  |  |  |

## SCP0009_Shipment_Plan_FG.Set_SumValues

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9a082398 | (진입점 미연결) | SCP0009_Shipment_Plan_FG.cs:1897 | for (iRow < dsBinding.Tables[0].Rows.Count) ▸ for (iCol < dsBinding.Tables[0].Columns.Count) ▸ if (colName.IndexOf("M_") == 0) ▸ if (bef_mon… | GRID_SET | dsBinding.Tables[0].Rows[iRow][bef_month_idx] | sum_month | 그리드 속성/값 설정 |  |  |  |
| AC-1867ae42 | (진입점 미연결) | SCP0009_Shipment_Plan_FG.cs:1906 | for (iRow < dsBinding.Tables[0].Rows.Count) ▸ for (iCol < dsBinding.Tables[0].Columns.Count) ▸ if (colName.IndexOf("M_") == 0) ▸ if (bef_mon… | GRID_SET | dsBinding.Tables[0].Rows[iRow][bef_month_idx] | qty | 그리드 속성/값 설정 |  |  |  |
| AC-ea2d058d | (진입점 미연결) | SCP0009_Shipment_Plan_FG.cs:1915 | for (iRow < dsBinding.Tables[0].Rows.Count) ▸ for (iCol < dsBinding.Tables[0].Columns.Count) ▸ else of (colName.IndexOf("M_") == 0) ▸ if (co… | GRID_SET | dsBinding.Tables[0].Rows[iRow][bef_week_idx] | sum_week | 그리드 속성/값 설정 |  |  |  |
| AC-6ce3b05e | (진입점 미연결) | SCP0009_Shipment_Plan_FG.cs:1924 | for (iRow < dsBinding.Tables[0].Rows.Count) ▸ for (iCol < dsBinding.Tables[0].Columns.Count) ▸ else of (colName.IndexOf("M_") == 0) ▸ if (co… | GRID_SET | dsBinding.Tables[0].Rows[iRow][bef_week_idx] | qty | 그리드 속성/값 설정 |  |  |  |
| AC-8b178c3e | (진입점 미연결) | SCP0009_Shipment_Plan_FG.cs:1942 | for (iRow < dsBinding.Tables[0].Rows.Count) ▸ for (iCol < dsBinding.Tables[0].Columns.Count) ▸ else of (colName.IndexOf("M_") == 0) ▸ else o… | GRID_SET | dsBinding.Tables[0].Rows[iRow][bef_week_idx] | sum_week | 그리드 속성/값 설정 |  |  |  |
| AC-13db8a2f | (진입점 미연결) | SCP0009_Shipment_Plan_FG.cs:1943 | for (iRow < dsBinding.Tables[0].Rows.Count) ▸ for (iCol < dsBinding.Tables[0].Columns.Count) ▸ else of (colName.IndexOf("M_") == 0) ▸ else o… | GRID_SET | dsBinding.Tables[0].Rows[iRow][bef_month_idx] | sum_month | 그리드 속성/값 설정 |  |  |  |
| AC-407fb192 | (진입점 미연결) | SCP0009_Shipment_Plan_FG.cs:1949 | for (iRow < dsBinding.Tables[0].Rows.Count) ▸ for (iCol < dsBinding.Tables[0].Columns.Count) ▸ else of (colName.IndexOf("M_") == 0) ▸ else o… | GRID_SET | dsBinding.Tables[0].Rows[iRow][bef_week_idx] | qty | 그리드 속성/값 설정 |  |  |  |
| AC-ad0997e9 | (진입점 미연결) | SCP0009_Shipment_Plan_FG.cs:1950 | for (iRow < dsBinding.Tables[0].Rows.Count) ▸ for (iCol < dsBinding.Tables[0].Columns.Count) ▸ else of (colName.IndexOf("M_") == 0) ▸ else o… | GRID_SET | dsBinding.Tables[0].Rows[iRow][bef_month_idx] | qty | 그리드 속성/값 설정 |  |  |  |
| AC-78557411 | (진입점 미연결) | SCP0009_Shipment_Plan_FG.cs:1956 | for (iRow < dsBinding.Tables[0].Rows.Count) ▸ for (iCol < dsBinding.Tables[0].Columns.Count) ▸ else of (colName.IndexOf("M_") == 0) ▸ else o… | GRID_SET | dsBinding.Tables[0].Rows[iRow][bef_week_idx] | sum_week | 그리드 속성/값 설정 |  |  |  |
| AC-59d410e0 | (진입점 미연결) | SCP0009_Shipment_Plan_FG.cs:1957 | for (iRow < dsBinding.Tables[0].Rows.Count) ▸ for (iCol < dsBinding.Tables[0].Columns.Count) ▸ else of (colName.IndexOf("M_") == 0) ▸ else o… | GRID_SET | dsBinding.Tables[0].Rows[iRow][bef_month_idx] | sum_month | 그리드 속성/값 설정 |  |  |  |
| AC-71af5215 | (진입점 미연결) | SCP0009_Shipment_Plan_FG.cs:1963 | for (iRow < dsBinding.Tables[0].Rows.Count) ▸ for (iCol < dsBinding.Tables[0].Columns.Count) ▸ else of (colName.IndexOf("M_") == 0) ▸ else o… | GRID_SET | dsBinding.Tables[0].Rows[iRow][bef_week_idx] | qty | 그리드 속성/값 설정 |  |  |  |
| AC-5b1e71d2 | (진입점 미연결) | SCP0009_Shipment_Plan_FG.cs:1964 | for (iRow < dsBinding.Tables[0].Rows.Count) ▸ for (iCol < dsBinding.Tables[0].Columns.Count) ▸ else of (colName.IndexOf("M_") == 0) ▸ else o… | GRID_SET | dsBinding.Tables[0].Rows[iRow][bef_month_idx] | qty | 그리드 속성/값 설정 |  |  |  |

## SCP0009_Shipment_Plan_FG.SetCellType

진입점: this.chkSum.CheckedChanged [if (siMain != null) ▸ for (iRow < siObj.ActiveSheet.RowCount) ▸ switch (measure) case "SHIP_PLAN_ENERGY": case "SHIP_PLAN_AMEND_ENERGY":] / this.Load [for (iRow < siObj.ActiveSheet.RowCount) ▸ switch (measure) case "SHIP_PLAN_ENERGY": case "SHIP_PLAN_AMEND_ENERGY":] / this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >= 0) ▸ if (siMain.GetValue(e.Row, siMain.GetColumnIndex(DefMain.MEASURE)).ToString().Equals("MKT_FCST")) ▸ if (spdInfo.SheetName == SpdSheet.shtMain) ▸ for (iRow < siObj.ActiveSheet.RowCount) ▸ switch (measure) case "SHIP_PLAN_ENERGY": case "S…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7cd3a66d | this.chkSum.CheckedChanged [if (siMain != null) ▸ for (iRow … 외 10 | SCP0009_Shipment_Plan_FG.cs:4154 | for (iCol <= iEndBucketCol) ▸ if (CommonUtils.CheckDataEmpty(cellValue) == false) | UI_PROP | yieldCellType.DecimalPlaces | 3 | 속성 DecimalPlaces 설정 |  |  |  |
| AC-db4a6e37 | this.chkSum.CheckedChanged [if (siMain != null) ▸ for (iRow … 외 10 | SCP0009_Shipment_Plan_FG.cs:4155 | for (iCol <= iEndBucketCol) ▸ if (CommonUtils.CheckDataEmpty(cellValue) == false) | GRID_SET | siMain.ActiveSheet.Cells[iRow, iCol].CellType | yieldCellType | 그리드 속성/값 설정 |  |  |  |

## SCP0009_Shipment_Plan_FG.SetChangedControl

진입점: this.Load / cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-853c3dca | this.Load 외 1 | SCP0009_Shipment_Plan_FG.cs:547 |  | FLAG | dtFromSite | dtFromSiteAll.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-a7c7b272 | this.Load 외 1 | SCP0009_Shipment_Plan_FG.cs:547 |  | DATA_OP | dtFromSiteAll.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-0844a5f4 | this.Load 외 1 | SCP0009_Shipment_Plan_FG.cs:564 | if (!this._division.Substring(0, 2).Equals("EE")) | VALUE_CLEAR | clbElecType.ControlValues | "" | 컨트롤 값 비움 |  |  |  |
| AC-d92e4f7c | this.Load 외 1 | SCP0009_Shipment_Plan_FG.cs:565 | if (!this._division.Substring(0, 2).Equals("EE")) | STATE | clbElecType.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-521a462b | this.Load 외 1 | SCP0009_Shipment_Plan_FG.cs:569 | else of (!this._division.Substring(0, 2).Equals("EE")) | STATE | clbElecType.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-0a975bee | this.Load 외 1 | SCP0009_Shipment_Plan_FG.cs:576 |  | VALUE_SET | btnWLast.Text | "W" + dailyPlanPeriod | 컨트롤 값 설정 |  |  |  |

## SCP0009_Shipment_Plan_FG.SetDataTableQtyData

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-67439d1c | (진입점 미연결) | SCP0009_Shipment_Plan_FG.cs:762 | for (i < source.Rows.Count) ▸ for (j < source.Columns.Count) ▸ if (columnName.IndexOf("D_") == 0) | GRID_SET | target.Rows[i][columnName] | source.Rows[i][columnName] | 그리드 속성/값 설정 |  |  |  |
| AC-1637d1a6 | (진입점 미연결) | SCP0009_Shipment_Plan_FG.cs:768 |  | DATA_OP | target.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |

## SCP0009_Shipment_Plan_FG.SetOperationGroupByDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9a667a75 | (진입점 미연결) | SCP0009_Shipment_Plan_FG.cs:4220 | if (!division.Substring(0, 2).Equals("EE")) | FLAG | dtOperGrp | Data_SCP.Common(Data_SCP.Type.OperationGroup, false) | 화면 필드/플래그 변경 |  |  |  |
| AC-ce5fbfd4 | (진입점 미연결) | SCP0009_Shipment_Plan_FG.cs:4220 | if (!division.Substring(0, 2).Equals("EE")) | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.OperationGroup, false) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-08942ce2 | (진입점 미연결) | SCP0009_Shipment_Plan_FG.cs:4223 | else of (!division.Substring(0, 2).Equals("EE")) | FLAG | dtOperGrp | Data_SCP.Common(Data_SCP.Type.OperationGroupEE, false) | 화면 필드/플래그 변경 |  |  |  |
| AC-b1d59b65 | (진입점 미연결) | SCP0009_Shipment_Plan_FG.cs:4223 | else of (!division.Substring(0, 2).Equals("EE")) | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.OperationGroupEE, false) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-336e6621 | (진입점 미연결) | SCP0009_Shipment_Plan_FG.cs:4226 |  | LIST_REBIND | clsCtrl.setListBox | (dtOperGrp, cboBizType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0009_Shipment_Plan_FG.SetSpreadColumn

진입점: this.chkSum.CheckedChanged [if (siMain != null)] / this.Load / this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >= 0) ▸ if (siMain.GetValue(e.Row, siMain.GetColumnIndex(DefMain.MEASURE)).ToString().Equals("MKT_FCST")) ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / this.cboBucketType.SelectedIndexChanged [if (chkAll.Checked) ▸ if (siMain != null)] / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / this.btnFix.Click [if (fps != null) ▸ else of (siMain.IsLock(siMain.SheetName)) ▸ if (fps.Name == "spdMain") ▸ if (siMain != n…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5b154a4e | this.chkSum.CheckedChanged [if (siMain != null)] 외 10 | SCP0009_Shipment_Plan_FG.cs:4091 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Daily) ▸ if (siObj.GetColumnTag(iCol).IndexOf("D_") … | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-f0f0bad3 | this.chkSum.CheckedChanged [if (siMain != null)] 외 10 | SCP0009_Shipment_Plan_FG.cs:4095 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Daily) ▸ if (siObj.GetColumnTag(iCol).IndexOf("M_") … | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | chkSum.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-34e5bfd6 | this.chkSum.CheckedChanged [if (siMain != null)] 외 10 | SCP0009_Shipment_Plan_FG.cs:4100 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Buc… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-2db60bd6 | this.chkSum.CheckedChanged [if (siMain != null)] 외 10 | SCP0009_Shipment_Plan_FG.cs:4103 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Buc… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-cb7c7ea7 | this.chkSum.CheckedChanged [if (siMain != null)] 외 10 | SCP0009_Shipment_Plan_FG.cs:4107 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Buc… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | chkSum.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-8dac541c | this.chkSum.CheckedChanged [if (siMain != null)] 외 10 | SCP0009_Shipment_Plan_FG.cs:4112 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ else of (cboBucketType.ControlValues =… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-5608491e | this.chkSum.CheckedChanged [if (siMain != null)] 외 10 | SCP0009_Shipment_Plan_FG.cs:4115 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ else of (cboBucketType.ControlValues =… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-64a489dd | this.chkSum.CheckedChanged [if (siMain != null)] 외 10 | SCP0009_Shipment_Plan_FG.cs:4121 | if (siObj.ActiveSheet.RowCount < 1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0009_Shipment_Plan_FG.SpdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c1d0e98c | this.spdMain.CellClick | SCP0009_Shipment_Plan_FG.cs:1186 | if (siMain.IsLock(siMain.SheetName)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0009_Shipment_Plan_FG.SpdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dce7d8d3 | this.spdMain.CellDoubleClick | SCP0009_Shipment_Plan_FG.cs:3780 | if (!chkAll.Checked) ▸ if ((siMain.GetColumnTag(e.Column).IndexOf("M_") == 0 && BucketType.Monthly == sBucketType) \|\| (siMain.GetColumnTag… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-36bc4785 | this.spdMain.CellDoubleClick | SCP0009_Shipment_Plan_FG.cs:3783 |  | CALL_EXT | siMain.SetDblClickColumnShowHide | (sender, e) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3937c888 | this.spdMain.CellDoubleClick | SCP0009_Shipment_Plan_FG.cs:3787 | if (e.Column < siMain.nIdxData \|\| siMain.GetColumnTag(e.Column).IndexOf("M_") == 0 \|\| siMain.GetColumnTag(e.Column).IndexOf(…) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-78877375 | this.spdMain.CellDoubleClick | SCP0009_Shipment_Plan_FG.cs:3792 | if (siMain.GetColumnTag(e.Column).IndexOf("D_")!=0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0009_Shipment_Plan_FG.SpdMain_KeyUp

진입점: this.spdMain.KeyUp

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-891f61d1 | this.spdMain.KeyUp | SCP0009_Shipment_Plan_FG.cs:1167 | if (siMain.GetColumnIndex(DefMain.MEASURE) >= siMain.ActiveColumnIndex) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7bfa4df0 | this.spdMain.KeyUp | SCP0009_Shipment_Plan_FG.cs:1170 | if (e.Control == true && e.KeyCode == Keys.V \|\| e.Control == false && e.KeyCode == Keys.V) | CALL_EXT | spdMain.ActiveSheet.ClipboardPaste | (ClipboardPasteOptions.AsStringSkipHidden) | ⚠ 의미 확인 필요 |  |  |  |
| AC-bf27fb00 | this.spdMain.KeyUp | SCP0009_Shipment_Plan_FG.cs:1174 | if (e.Control == true && e.KeyCode == Keys.C \|\| e.Control == false && e.KeyCode == Keys.C) | CALL_EXT | Clipboard.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-a3ea69c1 | this.spdMain.KeyUp | SCP0009_Shipment_Plan_FG.cs:1175 | if (e.Control == true && e.KeyCode == Keys.C \|\| e.Control == false && e.KeyCode == Keys.C) | CALL_EXT | spdMain.Sheets[0].ClipboardCopy | (ClipboardCopyOptions.AsStringSkipHidden) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0009_Shipment_Plan_FG.SpdMain_TopChange

진입점: this.spdMain.CellClick [if ((e.Column == siMain.GetColumnIndex(DefMain.TRANSPORT_MODE) \|\| e.Column == siMain.GetColumnIndex(DefMain.FROM_SITE_NAME))…)] / this.spdMain.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6e391ad9 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… 외 1 | SCP0009_Shipment_Plan_FG.cs:1181 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0009_Shipment_Plan_FG.TotalCellsMerge

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-23592f6d | (진입점 미연결) | SCP0009_Shipment_Plan_FG.cs:1802 |  | DATA_OP | list.Add | (siMain.GetColumnIndex(DefMain.FROM_SITE_NAME)) | 데이터 객체 조작/조회 |  |  |  |
| AC-3ac9f3af | (진입점 미연결) | SCP0009_Shipment_Plan_FG.cs:1803 |  | DATA_OP | list.Add | (siMain.GetColumnIndex(DefMain.TRANSPORT_MODE)) | 데이터 객체 조작/조회 |  |  |  |
| AC-896d5e26 | (진입점 미연결) | SCP0009_Shipment_Plan_FG.cs:1804 |  | DATA_OP | list.Add | (siMain.GetColumnIndex(DefMain.LT_DAY)) | 데이터 객체 조작/조회 |  |  |  |
| AC-0da0135b | (진입점 미연결) | SCP0009_Shipment_Plan_FG.cs:1826 | for (iRow <= siMain.GetMaxRowIndex()) ▸ if (cur_key_idx != bef_key_idx) ▸ foreach (int idx in list) | UI_PROP | range.HorizontalAlignment | CellHorizontalAlignment.Center | 속성 HorizontalAlignment 설정 |  |  |  |
| AC-4648df7d | (진입점 미연결) | SCP0009_Shipment_Plan_FG.cs:1827 | for (iRow <= siMain.GetMaxRowIndex()) ▸ if (cur_key_idx != bef_key_idx) ▸ foreach (int idx in list) | UI_PROP | range.ForeColor | Color.Black | 속성 ForeColor 설정 |  |  |  |
| AC-f27d7bfc | (진입점 미연결) | SCP0009_Shipment_Plan_FG.cs:1828 | for (iRow <= siMain.GetMaxRowIndex()) ▸ if (cur_key_idx != bef_key_idx) ▸ foreach (int idx in list) | UI_PROP | range.RowSpan | rowSpan_Count | 속성 RowSpan 설정 |  |  |  |
| AC-b2300592 | (진입점 미연결) | SCP0009_Shipment_Plan_FG.cs:1832 | for (iRow <= siMain.GetMaxRowIndex()) ▸ if (cur_key_idx != bef_key_idx) | UI_PROP | boh.HorizontalAlignment | CellHorizontalAlignment.Center | 속성 HorizontalAlignment 설정 |  |  |  |
| AC-13837118 | (진입점 미연결) | SCP0009_Shipment_Plan_FG.cs:1833 | for (iRow <= siMain.GetMaxRowIndex()) ▸ if (cur_key_idx != bef_key_idx) | UI_PROP | boh.RowSpan | bohSpan_Count | 속성 RowSpan 설정 |  |  |  |
| AC-0e33e485 | (진입점 미연결) | SCP0009_Shipment_Plan_FG.cs:1858 | for (iRow <= siMain.GetMaxRowIndex()) ▸ if (iRow == siMain.GetMaxRowIndex()) ▸ if (isSum) ▸ foreach (int idx in list) | UI_PROP | range.HorizontalAlignment | CellHorizontalAlignment.Center | 속성 HorizontalAlignment 설정 |  |  |  |
| AC-9922881d | (진입점 미연결) | SCP0009_Shipment_Plan_FG.cs:1859 | for (iRow <= siMain.GetMaxRowIndex()) ▸ if (iRow == siMain.GetMaxRowIndex()) ▸ if (isSum) ▸ foreach (int idx in list) | UI_PROP | range.ForeColor | Color.Black | 속성 ForeColor 설정 |  |  |  |
| AC-01ecb338 | (진입점 미연결) | SCP0009_Shipment_Plan_FG.cs:1860 | for (iRow <= siMain.GetMaxRowIndex()) ▸ if (iRow == siMain.GetMaxRowIndex()) ▸ if (isSum) ▸ foreach (int idx in list) | UI_PROP | range.RowSpan | rowSpan_Count | 속성 RowSpan 설정 |  |  |  |
| AC-d249f6fb | (진입점 미연결) | SCP0009_Shipment_Plan_FG.cs:1864 | for (iRow <= siMain.GetMaxRowIndex()) ▸ if (iRow == siMain.GetMaxRowIndex()) ▸ if (isSum) | UI_PROP | boh.HorizontalAlignment | CellHorizontalAlignment.Center | 속성 HorizontalAlignment 설정 |  |  |  |
| AC-e895c545 | (진입점 미연결) | SCP0009_Shipment_Plan_FG.cs:1865 | for (iRow <= siMain.GetMaxRowIndex()) ▸ if (iRow == siMain.GetMaxRowIndex()) ▸ if (isSum) | UI_PROP | boh.RowSpan | bohSpan_Count | 속성 RowSpan 설정 |  |  |  |

## SCP0009_Shipment_Plan_FG.ValidateUserInput

진입점: SaveButton [if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (iRow < siMain.ActiveSheet.Rows.Count) ▸ if (action == CAppSetting.FlagI && measure.Equals("SHIP_PLAN_AMEND")) ▸ for (iCol < siMain.GetMaxColumnIndex()) ▸ if (!string.IsNullOrEmpty(val)) ▸ if (nDayQty < 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-eeb3d370 | SaveButton [if (fps.Name == spdMain.Name) ▸ if (siMain != nu… | SCP0009_Shipment_Plan_FG.cs:3474 | if (action_name.Equals("NO_DATA")) ▸ if (siMain.ActiveSheet.RowCount <= 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00059") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-968481b0 | SaveButton [if (fps.Name == spdMain.Name) ▸ if (siMain != nu… | SCP0009_Shipment_Plan_FG.cs:3480 | else of (action_name.Equals("NO_DATA")) ▸ if (action_name.Equals("NO_CHECKED")) | MESSAGE | MessageHelper.GMessageBox | ("MSG00017") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a3b2b475 | SaveButton [if (fps.Name == spdMain.Name) ▸ if (siMain != nu… | SCP0009_Shipment_Plan_FG.cs:3492 | else of (action_name.Equals("NO_DATA")) ▸ else of (action_name.Equals("NO_CHECKED")) ▸ if (action_name.Equals("CHK_PERIOD")) ▸ if (DateTime.… | MESSAGE | MessageHelper.GMessageBox | ("MSG00171") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8725666b | SaveButton [if (fps.Name == spdMain.Name) ▸ if (siMain != nu… | SCP0009_Shipment_Plan_FG.cs:3494 | else of (action_name.Equals("NO_DATA")) ▸ else of (action_name.Equals("NO_CHECKED")) ▸ if (action_name.Equals("CHK_PERIOD")) ▸ if (DateTime.… | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |
| AC-cd399763 | SaveButton [if (fps.Name == spdMain.Name) ▸ if (siMain != nu… | SCP0009_Shipment_Plan_FG.cs:3499 | else of (action_name.Equals("NO_DATA")) ▸ else of (action_name.Equals("NO_CHECKED")) ▸ if (action_name.Equals("CHK_PERIOD")) ▸ if (diff.Days… | MESSAGE | MessageHelper.GMessageBox | ("MSG00172", new object[] { 364 }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-abdb7f6d | SaveButton [if (fps.Name == spdMain.Name) ▸ if (siMain != nu… | SCP0009_Shipment_Plan_FG.cs:3506 | else of (action_name.Equals("NO_DATA")) ▸ else of (action_name.Equals("NO_CHECKED")) ▸ else of (action_name.Equals("CHK_PERIOD")) ▸ if (acti… | MESSAGE | MessageHelper.GMessageBox | ("MSG00084") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-96f0a4b8 | SaveButton [if (fps.Name == spdMain.Name) ▸ if (siMain != nu… | SCP0009_Shipment_Plan_FG.cs:3513 | else of (action_name.Equals("NO_DATA")) ▸ else of (action_name.Equals("NO_CHECKED")) ▸ else of (action_name.Equals("CHK_PERIOD")) ▸ else of … | MESSAGE | MessageHelper.GMessageBox | ("MSG00233") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-17390544 | SaveButton [if (fps.Name == spdMain.Name) ▸ if (siMain != nu… | SCP0009_Shipment_Plan_FG.cs:3519 | else of (action_name.Equals("NO_DATA")) ▸ else of (action_name.Equals("NO_CHECKED")) ▸ else of (action_name.Equals("CHK_PERIOD")) ▸ else of … | MESSAGE | MessageHelper.GMessageBox | ("MSG00317", new object[] { "100,000,000" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f256dccc | SaveButton [if (fps.Name == spdMain.Name) ▸ if (siMain != nu… | SCP0009_Shipment_Plan_FG.cs:3522 |  | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |

