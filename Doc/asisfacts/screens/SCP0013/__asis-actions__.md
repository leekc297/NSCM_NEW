# AS-IS 액션 대조표 — SCP0013

> 원천: `Doc/asisfacts/screens/SCP0013/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 702행 · 메서드 81 · 종류 DATA_OP 272 · RETURN 57 · GRID_INIT 43 · UI_PROP 41 · FLAG 37 · GRID_SET 35 · MESSAGE 32 · ENDPOINT 32 · CALL_EXT 22 · UI_MISC 21 · POPUP 20 · VALUE_SET 20 · GRID_STYLE 16 · LIST_REBIND 16 · STATE 13 · GRID_LOCK 7 · VALIDATE 5 · GRID_CLEAR 5 · COMBO_DATA 4 · GRID_BIND 2 · STATE_RESET 1 · THROW 1 · ⚠ 의미 확인 필요 22


## SCP0013_ProductionPlanLine.btnFix_Click

진입점: this.btnFix.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fdfd2867 | this.btnFix.Click | SCP0013_ProductionPlanLine.cs:1000 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9bb97f9b | this.btnFix.Click | SCP0013_ProductionPlanLine.cs:1001 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5b9d5a2a | this.btnFix.Click | SCP0013_ProductionPlanLine.cs:1007 | if (siMain.IsLock(siMain.SheetName)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00010") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ea399553 | this.btnFix.Click | SCP0013_ProductionPlanLine.cs:1011 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (!Get_IsSaveYn()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0013_ProductionPlanLine.btnItemId_Click

진입점: this.btnItemId.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6beeda29 | this.btnItemId.Click | SCP0013_ProductionPlanLine.cs:819 |  | CALL_EXT | UIUtils.GetAllDivisionCheckedElectrode | (cboDivision) | ⚠ 의미 확인 필요 |  |  |  |
| AC-40c4ba63 | this.btnItemId.Click | SCP0013_ProductionPlanLine.cs:828 |  | POPUP | new SCM0002_MaterialByDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-c968fbb4 | this.btnItemId.Click | SCP0013_ProductionPlanLine.cs:830 |  | POPUP | pop.Form_Load | (true, division, pOperationGroup, sItemId, this.Name.Substring(0, 7)) | 팝업 초기화(인자 전달) |  |  |  |
| AC-1453846a | this.btnItemId.Click | SCP0013_ProductionPlanLine.cs:831 |  | UI_PROP | pop.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-ae90c879 | this.btnItemId.Click | SCP0013_ProductionPlanLine.cs:832 |  | POPUP | pop.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-50083be4 | this.btnItemId.Click | SCP0013_ProductionPlanLine.cs:838 | if (pop.selectedItemId != "") | VALUE_SET | txtItemId.Text | itemId | 컨트롤 값 설정 |  |  |  |

## SCP0013_ProductionPlanLine.BtnLoad_Click

진입점: btnLoad.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-da6e44cf | btnLoad.Click | SCP0013_ProductionPlanLine.cs:912 |  | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-04b46db9 | btnLoad.Click | SCP0013_ProductionPlanLine.cs:912 | if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-12a5ba3a | btnLoad.Click | SCP0013_ProductionPlanLine.cs:913 |  | VALIDATE | DateUtil.Check_PeriodDate | (dCalendar) | 프레임워크 검증 |  |  |  |
| AC-17d19612 | btnLoad.Click | SCP0013_ProductionPlanLine.cs:913 | if (!DateUtil.Check_PeriodDate(dCalendar)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-45969604 | btnLoad.Click | SCP0013_ProductionPlanLine.cs:915 | if (cboPlanDate.ControlValues == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-effae71c | btnLoad.Click | SCP0013_ProductionPlanLine.cs:944 |  | POPUP | new SCP0013_ProductionPlanLineLoadPopup | () | 팝업/폼 생성 |  |  |  |
| AC-a4e71519 | btnLoad.Click | SCP0013_ProductionPlanLine.cs:945 |  | UI_PROP | popup._pFromYYYYMMDD | p_from_yyyymmdd.ToString() | 속성 _pFromYYYYMMDD 설정 |  |  |  |
| AC-41a49b36 | btnLoad.Click | SCP0013_ProductionPlanLine.cs:946 |  | UI_PROP | popup._pToYYYYMMDD | p_to_yyyymmdd.ToString() | 속성 _pToYYYYMMDD 설정 |  |  |  |
| AC-b42aadcc | btnLoad.Click | SCP0013_ProductionPlanLine.cs:947 |  | UI_PROP | popup._pDivisionID | p_division_id.ToString() | 속성 _pDivisionID 설정 |  |  |  |
| AC-0c6fb94c | btnLoad.Click | SCP0013_ProductionPlanLine.cs:948 |  | UI_PROP | popup._pOperationGroup | p_operation_group.ToString() | 속성 _pOperationGroup 설정 |  |  |  |
| AC-1573940c | btnLoad.Click | SCP0013_ProductionPlanLine.cs:949 |  | UI_PROP | popup._pPlanStartYYYYMMDD | p_plan_start_yyyymmdd.ToString() | 속성 _pPlanStartYYYYMMDD 설정 |  |  |  |
| AC-49b6a6d9 | btnLoad.Click | SCP0013_ProductionPlanLine.cs:950 |  | UI_PROP | popup._pPlanType | p_plan_type.ToString() | 속성 _pPlanType 설정 |  |  |  |
| AC-4c345931 | btnLoad.Click | SCP0013_ProductionPlanLine.cs:951 |  | UI_PROP | popup._pSeq | p_seq.ToString() | 속성 _pSeq 설정 |  |  |  |
| AC-a96d3bbe | btnLoad.Click | SCP0013_ProductionPlanLine.cs:952 |  | UI_PROP | popup._pScmSiteId | p_scm_site_id.ToString() | 속성 _pScmSiteId 설정 |  |  |  |
| AC-63ecaeb8 | btnLoad.Click | SCP0013_ProductionPlanLine.cs:953 |  | UI_PROP | popup._pLineId | p_line_id.ToString() | 속성 _pLineId 설정 |  |  |  |
| AC-cb3178a6 | btnLoad.Click | SCP0013_ProductionPlanLine.cs:955 |  | UI_PROP | popup.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-f2e6e315 | btnLoad.Click | SCP0013_ProductionPlanLine.cs:957 |  | POPUP | popup.Show | () | 팝업/폼 열기 |  |  |  |

## SCP0013_ProductionPlanLine.BtnMeasure_Click

진입점: this.btnMeasure.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9b79b7fe | this.btnMeasure.Click | SCP0013_ProductionPlanLine.cs:1062 | if (fps != null) ▸ else of (fps.Name == "spdMain") | MESSAGE | MessageHelper.GMessageBox | ("MSG00007", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-7a349d70 | this.btnMeasure.Click | SCP0013_ProductionPlanLine.cs:1063 | if (fps != null) ▸ else of (fps.Name == "spdMain") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-fb62de74 | this.btnMeasure.Click | SCP0013_ProductionPlanLine.cs:1068 | else of (fps != null) | MESSAGE | MessageHelper.GMessageBox | ("MSG00007", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0481c2fa | this.btnMeasure.Click | SCP0013_ProductionPlanLine.cs:1069 | else of (fps != null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e50f8217 | this.btnMeasure.Click | SCP0013_ProductionPlanLine.cs:1072 |  | POPUP | new SCM0002_TitleSetForm_Popup | ("SCP0013", shtName, false) | 팝업/폼 생성 |  |  |  |
| AC-a8b7f450 | this.btnMeasure.Click | SCP0013_ProductionPlanLine.cs:1073 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-a305bb55 | this.btnMeasure.Click | SCP0013_ProductionPlanLine.cs:1074 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-680f3de3 | this.btnMeasure.Click | SCP0013_ProductionPlanLine.cs:1078 | if (frm.DialogResult == DialogResult.OK) | UI_PROP | this.CanModelChange | false | 속성 CanModelChange 설정 |  |  |  |
| AC-fd667009 | this.btnMeasure.Click | SCP0013_ProductionPlanLine.cs:1083 | if (frm.DialogResult == DialogResult.OK) | UI_PROP | this.CanModelChange | true | 속성 CanModelChange 설정 |  |  |  |

## SCP0013_ProductionPlanLine.BtnNew_Click

진입점: btnNew.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-43c36d5c | btnNew.Click | SCP0013_ProductionPlanLine.cs:849 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-473544fb | btnNew.Click | SCP0013_ProductionPlanLine.cs:850 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c6486d7e | btnNew.Click | SCP0013_ProductionPlanLine.cs:854 | if (cboPlanDate.ControlValues == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a175db4c | btnNew.Click | SCP0013_ProductionPlanLine.cs:856 | if (!Get_IsSaveYn()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-445866e1 | btnNew.Click | SCP0013_ProductionPlanLine.cs:865 |  | POPUP | new SCM0002_ProductionPlanInsertPopup | () | 팝업/폼 생성 |  |  |  |
| AC-672929ce | btnNew.Click | SCP0013_ProductionPlanLine.cs:866 |  | UI_PROP | popup.division | division | 속성 division 설정 |  |  |  |
| AC-22543706 | btnNew.Click | SCP0013_ProductionPlanLine.cs:867 |  | UI_PROP | popup.operationGroup | sOperationGroup | 속성 operationGroup 설정 |  |  |  |
| AC-642d1142 | btnNew.Click | SCP0013_ProductionPlanLine.cs:868 |  | UI_PROP | popup.planDate | dPlanDate | 속성 planDate 설정 |  |  |  |
| AC-826d61a1 | btnNew.Click | SCP0013_ProductionPlanLine.cs:869 |  | UI_PROP | popup.planType | sPlanType | 속성 planType 설정 |  |  |  |
| AC-81f5546d | btnNew.Click | SCP0013_ProductionPlanLine.cs:870 |  | UI_PROP | popup.seq | sSeq | 속성 seq 설정 |  |  |  |
| AC-27c51713 | btnNew.Click | SCP0013_ProductionPlanLine.cs:871 |  | UI_PROP | popup.user_id | UserInfo.UserId | 속성 user_id 설정 |  |  |  |
| AC-98f05b1b | btnNew.Click | SCP0013_ProductionPlanLine.cs:873 |  | UI_PROP | popup.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-554f909a | btnNew.Click | SCP0013_ProductionPlanLine.cs:874 |  | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-4344c48b | btnNew.Click | SCP0013_ProductionPlanLine.cs:884 | if (popup.DialogResult == DialogResult.OK) ▸ else of (division.Substring(0, 2).Equals("EE")) | VALUE_SET | txtItemId.Text | popup.Item_id | 컨트롤 값 설정 |  |  |  |
| AC-0e9e15ae | btnNew.Click | SCP0013_ProductionPlanLine.cs:886 | if (popup.DialogResult == DialogResult.OK) | MESSAGE | MessageHelper.GMessageBox | ("MSG00265") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SCP0013_ProductionPlanLine.btnUnfix_Click

진입점: this.btnUnfix.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d07a30e3 | this.btnUnfix.Click | SCP0013_ProductionPlanLine.cs:1025 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-11a5075a | this.btnUnfix.Click | SCP0013_ProductionPlanLine.cs:1026 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ef776a8b | this.btnUnfix.Click | SCP0013_ProductionPlanLine.cs:1032 | if (siMain.IsLock(siMain.SheetName)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00010") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-1a6c90e8 | this.btnUnfix.Click | SCP0013_ProductionPlanLine.cs:1036 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (!Get_IsSaveYn()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0013_ProductionPlanLine.BtnW26_Click

진입점: btnW26.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7937e332 | btnW26.Click | SCP0013_ProductionPlanLine.cs:963 |  | VALUE_SET | dCalendar.InitValue | GetDayRange(PeriodType.W26) | 컨트롤 값 설정 |  |  |  |

## SCP0013_ProductionPlanLine.BtnW52_Click

진입점: btnW52.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9dca19aa | btnW52.Click | SCP0013_ProductionPlanLine.cs:968 |  | VALUE_SET | dCalendar.InitValue | GetDayRange(PeriodType.W52) | 컨트롤 값 설정 |  |  |  |

## SCP0013_ProductionPlanLine.BtnWLast_Click

진입점: btnWLast.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ca2b5f64 | btnWLast.Click | SCP0013_ProductionPlanLine.cs:980 | if (success) | VALUE_SET | dCalendar.InitValue | GetDayRange(WkNum.ToString()) | 컨트롤 값 설정 |  |  |  |

## SCP0013_ProductionPlanLine.CalculateDailyQty

진입점: dsdmLine.Changed [try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (!cellclipboardPast) ▸ if (strColName.IndexOf("W_") == 0) ▸ if (cboBucketType.ControlValues.Equals(BucketType.Daily) \|\| chkAll.Checked)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-410ee484 | dsdmLine.Changed [try ▸ switch (e.Type) case FarPoint.Win.Sp… | SCP0013_ProductionPlanLine.cs:1610 | if (nWeek < 0) | GRID_SET | siMain.SetValue | (nRow, nCol, nDaySum) | 그리드 값 설정 |  |  |  |
| AC-4422d6fb | dsdmLine.Changed [try ▸ switch (e.Type) case FarPoint.Win.Sp… | SCP0013_ProductionPlanLine.cs:1613 | if (nWeek < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ba3e157c | dsdmLine.Changed [try ▸ switch (e.Type) case FarPoint.Win.Sp… | SCP0013_ProductionPlanLine.cs:1644 | for (j < (nCol + 1 + nDayCnt)) ▸ if (j != (nCol + nDayCnt)) | GRID_SET | siMain.SetValue | (nRow, j, nDivDay) | 그리드 값 설정 |  |  |  |
| AC-cbb11f52 | dsdmLine.Changed [try ▸ switch (e.Type) case FarPoint.Win.Sp… | SCP0013_ProductionPlanLine.cs:1649 | for (j < (nCol + 1 + nDayCnt)) ▸ else of (j != (nCol + nDayCnt)) | GRID_SET | siMain.SetValue | (nRow, j, (nDivDay + nDivDayMod).ToString()) | 그리드 값 설정 |  |  |  |
| AC-631e8938 | dsdmLine.Changed [try ▸ switch (e.Type) case FarPoint.Win.Sp… | SCP0013_ProductionPlanLine.cs:1651 | for (j < (nCol + 1 + nDayCnt)) | GRID_STYLE | siMain.SetFGColor | (nRow, j, nRow, j, ControlColor.MarkedForeColor) | 그리드 표시 설정 |  |  |  |
| AC-1f12da9b | dsdmLine.Changed [try ▸ switch (e.Type) case FarPoint.Win.Sp… | SCP0013_ProductionPlanLine.cs:1663 | if (!cellclipboardPast) ▸ if (ds == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0013_ProductionPlanLine.CalculateDailyQty2

진입점: this.spdMain.ClipboardPasted [try ▸ for (iRow < e.CellRange.Row + e.CellRange.RowCount) ▸ if (measure.Equals("PROD_PLAN_AMEND")) ▸ for (iCol < e.CellRange.Column + e.CellRange.ColumnCount) ▸ if (strColName.IndexOf("W_") == 0 && siMain.ActiveSheet.Cells[iRow, iCol].ForeColor.Name == "Red" && (cboBucketType.ControlV…)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d0c8d018 | this.spdMain.ClipboardPasted [try ▸ for (iRow < e.CellRange.… | SCP0013_ProductionPlanLine.cs:1686 | if (ds == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c6a52232 | this.spdMain.ClipboardPasted [try ▸ for (iRow < e.CellRange.… | SCP0013_ProductionPlanLine.cs:1737 | for (j < (sumCol + 1 + nDayCnt)) ▸ if (j != (sumCol + nDayCnt)) | DATA_OP | dr[j] | nDivDay | 행/컬럼 값 대입 |  |  |  |
| AC-3f8146d4 | this.spdMain.ClipboardPasted [try ▸ for (iRow < e.CellRange.… | SCP0013_ProductionPlanLine.cs:1741 | for (j < (sumCol + 1 + nDayCnt)) ▸ else of (j != (sumCol + nDayCnt)) | DATA_OP | dr[j] | nDivDay + nDivDayMod | 행/컬럼 값 대입 |  |  |  |
| AC-340cc1e6 | this.spdMain.ClipboardPasted [try ▸ for (iRow < e.CellRange.… | SCP0013_ProductionPlanLine.cs:1743 | for (j < (sumCol + 1 + nDayCnt)) | GRID_STYLE | siMain.SetFGColor | (nRow, k, nRow, k, ControlColor.MarkedForeColor) | 그리드 표시 설정 |  |  |  |
| AC-2b50df81 | this.spdMain.ClipboardPasted [try ▸ for (iRow < e.CellRange.… | SCP0013_ProductionPlanLine.cs:1746 |  | DATA_OP | dt.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |

## SCP0013_ProductionPlanLine.CalculateSum

진입점: dsdmLine.Changed [try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (!cellclipboardPast)] / this.spdMain.ClipboardPasted [try ▸ for (iRow < e.CellRange.Row + e.CellRange.RowCount) ▸ if (measure.Equals("PROD_PLAN_AMEND"))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9ef9251c | dsdmLine.Changed [try ▸ switch (e.Type) case FarPoint.Win.Sp… 외 1 | SCP0013_ProductionPlanLine.cs:1294 | if (cboBucketType.ControlValues.Equals(BucketType.Daily) \|\| chkAll.Checked) ▸ for (nCol < dt.Columns.Count) ▸ if (dt.Columns[nCol].ColumnN… | DATA_OP | listMonth.Add | (nCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-bcf8fe51 | dsdmLine.Changed [try ▸ switch (e.Type) case FarPoint.Win.Sp… 외 1 | SCP0013_ProductionPlanLine.cs:1298 | if (cboBucketType.ControlValues.Equals(BucketType.Daily) \|\| chkAll.Checked) ▸ for (nCol < dt.Columns.Count) ▸ if (dt.Columns[nCol].ColumnN… | DATA_OP | listWeek.Add | (nCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-5b03ece3 | dsdmLine.Changed [try ▸ switch (e.Type) case FarPoint.Win.Sp… 외 1 | SCP0013_ProductionPlanLine.cs:1343 | if (cboBucketType.ControlValues.Equals(BucketType.Daily) \|\| chkAll.Checked) ▸ for (nCol < dt.Columns.Count) ▸ if (nCol == dt.Columns.Count… | DATA_OP | dr[nIdxWeek] | weekSum / nCntDayOfWeek | 행/컬럼 값 대입 |  |  |  |
| AC-01698611 | dsdmLine.Changed [try ▸ switch (e.Type) case FarPoint.Win.Sp… 외 1 | SCP0013_ProductionPlanLine.cs:1347 | if (cboBucketType.ControlValues.Equals(BucketType.Daily) \|\| chkAll.Checked) ▸ for (nCol < dt.Columns.Count) ▸ if (nCol == dt.Columns.Count… | DATA_OP | dr[nIdxWeek] | weekSum | 행/컬럼 값 대입 |  |  |  |
| AC-33e05d2d | dsdmLine.Changed [try ▸ switch (e.Type) case FarPoint.Win.Sp… 외 1 | SCP0013_ProductionPlanLine.cs:1361 | if (cboBucketType.ControlValues.Equals(BucketType.Daily) \|\| chkAll.Checked) ▸ for (nCol < dt.Columns.Count) ▸ if (nCol == dt.Columns.Count… | DATA_OP | dr[nIdxMonth] | monthSum / nCntDayOfMonth | 행/컬럼 값 대입 |  |  |  |
| AC-a2b0c1c4 | dsdmLine.Changed [try ▸ switch (e.Type) case FarPoint.Win.Sp… 외 1 | SCP0013_ProductionPlanLine.cs:1365 | if (cboBucketType.ControlValues.Equals(BucketType.Daily) \|\| chkAll.Checked) ▸ for (nCol < dt.Columns.Count) ▸ if (nCol == dt.Columns.Count… | DATA_OP | dr[nIdxMonth] | monthSum | 행/컬럼 값 대입 |  |  |  |
| AC-7a7a204b | dsdmLine.Changed [try ▸ switch (e.Type) case FarPoint.Win.Sp… 외 1 | SCP0013_ProductionPlanLine.cs:1378 | else of (cboBucketType.ControlValues.Equals(BucketType.Daily) \|\| chkAll.Checked) | DATA_OP | dtSpdTitle.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-c8fef419 | dsdmLine.Changed [try ▸ switch (e.Type) case FarPoint.Win.Sp… 외 1 | SCP0013_ProductionPlanLine.cs:1379 | else of (cboBucketType.ControlValues.Equals(BucketType.Daily) \|\| chkAll.Checked) | DATA_OP | dtTitle.Columns.Remove | ("SORT_ORDER_NO") | 데이터 객체 조작/조회 |  |  |  |
| AC-519d2853 | dsdmLine.Changed [try ▸ switch (e.Type) case FarPoint.Win.Sp… 외 1 | SCP0013_ProductionPlanLine.cs:1380 | else of (cboBucketType.ControlValues.Equals(BucketType.Daily) \|\| chkAll.Checked) | DATA_OP | dtTitle.Merge | (dsSpdTitle.Tables[0]) | 데이터 객체 조작/조회 |  |  |  |
| AC-4fec0bab | dsdmLine.Changed [try ▸ switch (e.Type) case FarPoint.Win.Sp… 외 1 | SCP0013_ProductionPlanLine.cs:1390 | else of (cboBucketType.ControlValues.Equals(BucketType.Daily) \|\| chkAll.Checked) ▸ for (nCol < dtTitle.Rows.Count) ▸ if (dtTitle.Rows[nCol… | DATA_OP | listMonth.Add | (nCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-23634abb | dsdmLine.Changed [try ▸ switch (e.Type) case FarPoint.Win.Sp… 외 1 | SCP0013_ProductionPlanLine.cs:1391 | else of (cboBucketType.ControlValues.Equals(BucketType.Daily) \|\| chkAll.Checked) ▸ for (nCol < dtTitle.Rows.Count) ▸ if (dtTitle.Rows[nCol… | DATA_OP | listMonth2.Add | (dtTitle.Rows[nCol]["COLUMN_NAME"].ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-e2698abf | dsdmLine.Changed [try ▸ switch (e.Type) case FarPoint.Win.Sp… 외 1 | SCP0013_ProductionPlanLine.cs:1395 | else of (cboBucketType.ControlValues.Equals(BucketType.Daily) \|\| chkAll.Checked) ▸ for (nCol < dtTitle.Rows.Count) ▸ if (dtTitle.Rows[nCol… | DATA_OP | listWeek.Add | (nCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-6e7e0958 | dsdmLine.Changed [try ▸ switch (e.Type) case FarPoint.Win.Sp… 외 1 | SCP0013_ProductionPlanLine.cs:1396 | else of (cboBucketType.ControlValues.Equals(BucketType.Daily) \|\| chkAll.Checked) ▸ for (nCol < dtTitle.Rows.Count) ▸ if (dtTitle.Rows[nCol… | DATA_OP | listWeek2.Add | (dtTitle.Rows[nCol]["COLUMN_NAME"].ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-e50c69de | dsdmLine.Changed [try ▸ switch (e.Type) case FarPoint.Win.Sp… 외 1 | SCP0013_ProductionPlanLine.cs:1421 | else of (cboBucketType.ControlValues.Equals(BucketType.Daily) \|\| chkAll.Checked) ▸ for (nCol < dtTitle.Rows.Count) ▸ if (nCol == dtTitle.R… | DATA_OP | dr[month] | monthSum | 행/컬럼 값 대입 |  |  |  |
| AC-d175aa49 | dsdmLine.Changed [try ▸ switch (e.Type) case FarPoint.Win.Sp… 외 1 | SCP0013_ProductionPlanLine.cs:1429 |  | DATA_OP | dt.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-787739cb | dsdmLine.Changed [try ▸ switch (e.Type) case FarPoint.Win.Sp… 외 1 | SCP0013_ProductionPlanLine.cs:1451 | for (nCol < dt.Columns.Count) ▸ if (dt.Columns[nCol].ColumnName.IndexOf("M_") == 0) | DATA_OP | listMonth.Add | (nCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-903e1d58 | dsdmLine.Changed [try ▸ switch (e.Type) case FarPoint.Win.Sp… 외 1 | SCP0013_ProductionPlanLine.cs:1455 | for (nCol < dt.Columns.Count) ▸ if (dt.Columns[nCol].ColumnName.IndexOf("W_") == 0) | DATA_OP | listWeek.Add | (nCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-7033a3f4 | dsdmLine.Changed [try ▸ switch (e.Type) case FarPoint.Win.Sp… 외 1 | SCP0013_ProductionPlanLine.cs:1518 | for (nRow < dt.Rows.Count) ▸ for (nCol < dt.Columns.Count) ▸ if (nCol == dt.Columns.Count - 1 \|\| dt.Columns[nCol].ColumnName.IndexOf("W_")… | DATA_OP | dr[nIdxWeek] | weekSum / nCntDayOfWeek | 행/컬럼 값 대입 |  |  |  |
| AC-7d622e41 | dsdmLine.Changed [try ▸ switch (e.Type) case FarPoint.Win.Sp… 외 1 | SCP0013_ProductionPlanLine.cs:1522 | for (nRow < dt.Rows.Count) ▸ for (nCol < dt.Columns.Count) ▸ if (nCol == dt.Columns.Count - 1 \|\| dt.Columns[nCol].ColumnName.IndexOf("W_")… | DATA_OP | dr[nIdxWeek] | weekSum | 행/컬럼 값 대입 |  |  |  |
| AC-974d1e4a | dsdmLine.Changed [try ▸ switch (e.Type) case FarPoint.Win.Sp… 외 1 | SCP0013_ProductionPlanLine.cs:1540 | for (nRow < dt.Rows.Count) ▸ for (nCol < dt.Columns.Count) ▸ if (nCol == dt.Columns.Count - 1 \|\| dt.Columns[nCol].ColumnName.IndexOf("M_")… | DATA_OP | dr[nIdxMonth] | monthSum / nCntDayOfMonth | 행/컬럼 값 대입 |  |  |  |
| AC-2ece0e8c | dsdmLine.Changed [try ▸ switch (e.Type) case FarPoint.Win.Sp… 외 1 | SCP0013_ProductionPlanLine.cs:1544 | for (nRow < dt.Rows.Count) ▸ for (nCol < dt.Columns.Count) ▸ if (nCol == dt.Columns.Count - 1 \|\| dt.Columns[nCol].ColumnName.IndexOf("M_")… | DATA_OP | dr[nIdxMonth] | monthSum | 행/컬럼 값 대입 |  |  |  |
| AC-7a78c1bb | dsdmLine.Changed [try ▸ switch (e.Type) case FarPoint.Win.Sp… 외 1 | SCP0013_ProductionPlanLine.cs:1553 |  | DATA_OP | dt.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |

## SCP0013_ProductionPlanLine.cboBucketType_SelectedIndexChanged

진입점: this.cboBucketType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d355e5ad | this.cboBucketType.SelectedIndexChanged | SCP0013_ProductionPlanLine.cs:811 | else of (chkAll.Checked) | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |

## SCP0013_ProductionPlanLine.CboCellTypeGr_SelectedIndexChanged

진입점: cboCellTypeGr.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3429e196 | cboCellTypeGr.SelectedIndexChanged | SCP0013_ProductionPlanLine.cs:3972 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-cf89afd6 | cboCellTypeGr.SelectedIndexChanged | SCP0013_ProductionPlanLine.cs:3973 |  | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-d78e31a6 | cboCellTypeGr.SelectedIndexChanged | SCP0013_ProductionPlanLine.cs:3980 | try ▸ if (CommonUtils.CheckDataEmpty(p_cell_type_gr) == false) | FLAG | dtLine | GetLineList() | 화면 필드/플래그 변경 |  |  |  |
| AC-d723ade3 | cboCellTypeGr.SelectedIndexChanged | SCP0013_ProductionPlanLine.cs:3981 | try ▸ if (CommonUtils.CheckDataEmpty(p_cell_type_gr) == false) | LIST_REBIND | clsCtrl.setListBox | (dtLine, clbLine, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-9bd6c3ef | cboCellTypeGr.SelectedIndexChanged | SCP0013_ProductionPlanLine.cs:3991 |  | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0013_ProductionPlanLine.CboDivision_SelectedIndexChanged

진입점: cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2bb997be | cboDivision.SelectedIndexChanged | SCP0013_ProductionPlanLine.cs:3864 |  | VALUE_SET | btnWLast.Text | "W" + dailyPlanPeriod | 컨트롤 값 설정 |  |  |  |

## SCP0013_ProductionPlanLine.CboPlanDate_SelectedIndexChanged

진입점: cboPlanDate.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fdfa1614 | cboPlanDate.SelectedIndexChanged | SCP0013_ProductionPlanLine.cs:3937 | if ((dtPlanType.Rows.Count > 0) && (cboPlanType.Items.Count > 0)) | VALUE_SET | cboPlanType.SelectedIndex | dtPlanType.Rows.Count - 1 | 컨트롤 값 설정 |  |  |  |
| AC-5596a5d3 | cboPlanDate.SelectedIndexChanged | SCP0013_ProductionPlanLine.cs:3942 |  | VALUE_SET | dCalendar.InitValue | GetDayRange(PeriodType.W52) | 컨트롤 값 설정 |  |  |  |
| AC-c2f1fef9 | cboPlanDate.SelectedIndexChanged | SCP0013_ProductionPlanLine.cs:3947 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |

## SCP0013_ProductionPlanLine.CboPlanSeq_SelectedIndexChanged

진입점: cboPlanSeq.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1d2e5ef1 | cboPlanSeq.SelectedIndexChanged | SCP0013_ProductionPlanLine.cs:3967 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |

## SCP0013_ProductionPlanLine.CboPlanType_SelectedIndexChanged

진입점: cboPlanType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-540f01c9 | cboPlanType.SelectedIndexChanged | SCP0013_ProductionPlanLine.cs:3956 |  | VALUE_SET | cboPlanSeq.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-701aa307 | cboPlanType.SelectedIndexChanged | SCP0013_ProductionPlanLine.cs:3959 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |

## SCP0013_ProductionPlanLine.Check_LineAssign

진입점: this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName)) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Equals("S")) ▸ try] / this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName)) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Equals("S")) ▸ try] / btnNew.Click […

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-17faf603 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SCP0013_ProductionPlanLine.cs:4132 | if (chkLineAssign.Checked && txtItemId.Text == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00290") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3ae40f2b | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SCP0013_ProductionPlanLine.cs:4135 |  | RETURN | return chkModel; |  | 처리 중단/반환 |  |  |  |

## SCP0013_ProductionPlanLine.ChkAll_CheckedChanged

진입점: this.chkAll.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-13df8666 | this.chkAll.CheckedChanged | SCP0013_ProductionPlanLine.cs:1207 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |

## SCP0013_ProductionPlanLine.ClearUsrCheckedList

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-98146dda | (진입점 미연결) | SCP0013_ProductionPlanLine.cs:256 | if (dt != null) | STATE_RESET | dt.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-49711f73 | (진입점 미연결) | SCP0013_ProductionPlanLine.cs:257 | if (dt != null) | LIST_REBIND | clsCtrl.setListBox | (dt, control, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0013_ProductionPlanLine.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-156d500b | this.Load | SCP0013_ProductionPlanLine.cs:313 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 3, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-d39d2462 | this.Load | SCP0013_ProductionPlanLine.cs:313 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, 0) | 화면 필드/플래그 변경 |  |  |  |
| AC-f1f41de8 | this.Load | SCP0013_ProductionPlanLine.cs:315 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0013_ProductionPlanLine.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-aaa35696 | this.Load | SCP0013_ProductionPlanLine.cs:244 |  | UI_PROP | usrConditionPanel1.Height | 105 | 속성 Height 설정 |  |  |  |
| AC-8b7ee12d | this.Load | SCP0013_ProductionPlanLine.cs:245 |  | VALUE_SET | cboBucketType.ControlValues | BucketType.Weekly | 컨트롤 값 설정 |  |  |  |
| AC-a5d81d9a | this.Load | SCP0013_ProductionPlanLine.cs:246 |  | VALUE_SET | chkSum.Checked | false | 컨트롤 값 설정 |  |  |  |
| AC-90be64ae | this.Load | SCP0013_ProductionPlanLine.cs:247 |  | VALUE_SET | chkLineAssign.Checked | false | 컨트롤 값 설정 |  |  |  |

## SCP0013_ProductionPlanLine.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b1f0cb24 | Dispose | SCP0013_ProductionPlanLine.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0013_ProductionPlanLine.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6efc9f62 | EditButton | SCP0013_ProductionPlanLine.cs:650 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4d186045 | EditButton | SCP0013_ProductionPlanLine.cs:654 | if (fps.Name == "spdMain") ▸ if (siMain.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-cc720bf3 | EditButton | SCP0013_ProductionPlanLine.cs:655 | if (fps.Name == "spdMain") | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-0cc3d5c6 | EditButton | SCP0013_ProductionPlanLine.cs:656 | if (fps.Name == "spdMain") | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-82b445bd | EditButton | SCP0013_ProductionPlanLine.cs:660 | if (fps.Name == "spdMain") | CALL_EXT | fps.ActiveSheet.GetColumnFromTag | (null, CAppSetting.StringAction) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f32eea1c | EditButton | SCP0013_ProductionPlanLine.cs:661 | if (fps.Name == "spdMain") | CALL_EXT | fps.ActiveSheet.Columns.Get | (xCol1) | ⚠ 의미 확인 필요 |  |  |  |
| AC-bc46cc71 | EditButton | SCP0013_ProductionPlanLine.cs:663 | if (fps.Name == "spdMain") ▸ if (fps.ActiveSheet.Columns.Get(xCol1).Visible == true) | FLAG | cellclipboardPast | false | 화면 필드/플래그 변경 |  |  |  |
| AC-32feb5f9 | EditButton | SCP0013_ProductionPlanLine.cs:667 | if (fps.Name == "spdMain") | GRID_LOCK | siMain.LockRange | (0, 0, siMain.ActiveSheet.RowCount - 1, siMain.ActiveSheet.ColumnCount - 1, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-8369405d | EditButton | SCP0013_ProductionPlanLine.cs:672 | if (fps.Name == "spdMain") | CALL_EXT | fps.ActiveSheet.Columns.Get | (xCol1) | ⚠ 의미 확인 필요 |  |  |  |
| AC-61d47bef | EditButton | SCP0013_ProductionPlanLine.cs:678 | if (fps.Name == "spdMain") ▸ if (fps.ActiveSheet.Columns.Get(xCol1).Visible == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2b5712f0 | EditButton | SCP0013_ProductionPlanLine.cs:689 | if (fps.Name == "spdMain") ▸ for (i < spdMain.ActiveSheet.RowCount) ▸ if (spdMain.ActiveSheet.GetText(i, siMain.GetColumnIndex(DefColumns.ME… | DATA_OP | dtIsEditInfo.Select | ("CP_KEY = '" + strCP_KEY + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-95d8d853 | EditButton | SCP0013_ProductionPlanLine.cs:721 | if (fps.Name == "spdMain") ▸ for (i < spdMain.ActiveSheet.RowCount) ▸ if (spdMain.ActiveSheet.GetText(i, siMain.GetColumnIndex(DefColumns.ME… | DATA_OP | dtPlanType.Select | ("CODE='FN'") | 데이터 객체 조작/조회 |  |  |  |
| AC-2ef8fbb5 | EditButton | SCP0013_ProductionPlanLine.cs:775 | if (fps.Name == "spdMain") ▸ for (i < spdMain.ActiveSheet.RowCount) ▸ if (spdMain.ActiveSheet.GetText(i, siMain.GetColumnIndex(DefColumns.ME… | GRID_LOCK | siMain.LockRange | (nEditableRow, nStartEditIdx, nEditableRow, siMain.ActiveSheet.ColumnCount - 1, false) | 그리드 편집 잠금/해제 |  |  |  |

## SCP0013_ProductionPlanLine.FindData_Main

진입점: this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName)) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Equals("S"))] / this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName)) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Equals("S"))] / btnNew.Click [if (popup.Di…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6ef1b5b0 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SCP0013_ProductionPlanLine.cs:1970 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-de74cf5c | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SCP0013_ProductionPlanLine.cs:1978 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-2573bbef | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SCP0013_ProductionPlanLine.cs:1978 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-82f7aaf8 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SCP0013_ProductionPlanLine.cs:1980 | try | VALIDATE | SCPPlan.Check_PeriodDate_New | (dCalendar, "1", "7") | 프레임워크 검증 |  |  |  |
| AC-9aa967fd | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SCP0013_ProductionPlanLine.cs:1980 | try ▸ if (!SCPPlan.Check_PeriodDate_New(dCalendar, "1", "7")) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1b8f3299 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SCP0013_ProductionPlanLine.cs:1981 | try ▸ if (!Check_LineAssign()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c28c0617 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SCP0013_ProductionPlanLine.cs:1984 | try | UI_PROP | SCPPlan.p_div | CString.GetCheckedListValue(dtMyDivision, cboDivision.ControlValues) | 속성 p_div 설정 |  |  |  |
| AC-e289301d | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SCP0013_ProductionPlanLine.cs:1985 | try | UI_PROP | SCPPlan.p_bucket | CString.GetCheckedListValue(dtBucketType, cboBucketType.ControlValues) | 속성 p_bucket 설정 |  |  |  |
| AC-3d34e773 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SCP0013_ProductionPlanLine.cs:1986 | try | UI_PROP | SCPPlan.p_plan_date | CString.GetCheckedListValue(dtPlanDate, cboPlanDate.ControlValues) | 속성 p_plan_date 설정 |  |  |  |
| AC-9d0856bd | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SCP0013_ProductionPlanLine.cs:1987 | try | UI_PROP | SCPPlan.p_to_yyyymmdd | dCalendar.Text2.Replace("-", "") | 속성 p_to_yyyymmdd 설정 |  |  |  |
| AC-091a4c0c | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SCP0013_ProductionPlanLine.cs:1989 | try | CALL_EXT | SCPPlan.CheckPlanPeriodRange | (ref returnMessage, ref plan_end_date) | ⚠ 의미 확인 필요 |  |  |  |
| AC-de5890ce | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SCP0013_ProductionPlanLine.cs:1991 | try ▸ if (SCPPlan.CheckPlanPeriodRange(ref returnMessage, ref plan_end_date) == false) | MESSAGE | MessageHelper.GMessageBox | (returnMessage) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ff7652f6 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SCP0013_ProductionPlanLine.cs:1992 | try ▸ if (SCPPlan.CheckPlanPeriodRange(ref returnMessage, ref plan_end_date) == false) | UI_PROP | dCalendar.Text2 | plan_end_date | 속성 Text2 설정 |  |  |  |
| AC-60f8a374 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SCP0013_ProductionPlanLine.cs:1993 | try ▸ if (SCPPlan.CheckPlanPeriodRange(ref returnMessage, ref plan_end_date) == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-77d82824 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SCP0013_ProductionPlanLine.cs:1998 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-c24bf0b4 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SCP0013_ProductionPlanLine.cs:2045 | try | UI_PROP | proxyPivot.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-c05dcfa2 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SCP0013_ProductionPlanLine.cs:2047 | try | ENDPOINT | proxyPivot.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, GSCM_SCP_ANALYS… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-88b8996f | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SCP0013_ProductionPlanLine.cs:2051 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0013_GET_PRODUCTION_PLAN_LINEBY") ⇒ SCP.SCP0013_GET_PRODUCTION_PLAN_LINEBY | 엔드포인트 요청 생성 |  |  |  |
| AC-fd44e059 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SCP0013_ProductionPlanLine.cs:2052 | try ▸ lambda | UI_PROP | req.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-6923768b | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SCP0013_ProductionPlanLine.cs:2053 | try ▸ lambda | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-71020ca1 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SCP0013_ProductionPlanLine.cs:2054 | try ▸ lambda | DATA_OP | req.Parameters["p_operation_group"] | p_operation_group | 행/컬럼 값 대입 |  |  |  |
| AC-4d6d2277 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SCP0013_ProductionPlanLine.cs:2055 | try ▸ lambda | DATA_OP | req.Parameters["p_scm_site_id"] | p_scm_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-2345243b | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SCP0013_ProductionPlanLine.cs:2056 | try ▸ lambda | DATA_OP | req.Parameters["p_line_id"] | p_line_id | 행/컬럼 값 대입 |  |  |  |
| AC-1189eca3 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SCP0013_ProductionPlanLine.cs:2057 | try ▸ lambda | DATA_OP | req.Parameters["p_model_id"] | p_model_id | 행/컬럼 값 대입 |  |  |  |
| AC-99644cce | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SCP0013_ProductionPlanLine.cs:2058 | try ▸ lambda | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-6e7f2d0c | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SCP0013_ProductionPlanLine.cs:2059 | try ▸ lambda | DATA_OP | req.Parameters["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-33827f07 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SCP0013_ProductionPlanLine.cs:2060 | try ▸ lambda | DATA_OP | req.Parameters["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-176ae373 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SCP0013_ProductionPlanLine.cs:2061 | try ▸ lambda | DATA_OP | req.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-6e47d758 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SCP0013_ProductionPlanLine.cs:2062 | try ▸ lambda | DATA_OP | req.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-cab88adb | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SCP0013_ProductionPlanLine.cs:2063 | try ▸ lambda | DATA_OP | req.Parameters["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-8f9f2b79 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SCP0013_ProductionPlanLine.cs:2064 | try ▸ lambda | DATA_OP | req.Parameters["p_program_id"] | p_program_id | 행/컬럼 값 대입 |  |  |  |
| AC-a01e1cd3 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SCP0013_ProductionPlanLine.cs:2065 | try ▸ lambda | DATA_OP | req.Parameters["p_sheet_name"] | p_sheet_name | 행/컬럼 값 대입 |  |  |  |
| AC-4a369519 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SCP0013_ProductionPlanLine.cs:2066 | try ▸ lambda | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-b8a95976 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SCP0013_ProductionPlanLine.cs:2067 | try ▸ lambda | DATA_OP | req.Parameters["p_electrode_type"] | p_electrode_type | 행/컬럼 값 대입 |  |  |  |
| AC-3c6f231c | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SCP0013_ProductionPlanLine.cs:2068 | try ▸ lambda | DATA_OP | req.Parameters["p_nick_name"] | p_nick_name | 행/컬럼 값 대입 |  |  |  |
| AC-bcb64e08 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SCP0013_ProductionPlanLine.cs:2069 | try ▸ lambda | DATA_OP | req.Parameters["p_cell_type_gr"] | p_cell_type_gr | 행/컬럼 값 대입 |  |  |  |
| AC-862a3276 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SCP0013_ProductionPlanLine.cs:2070 | try ▸ lambda | DATA_OP | req.Parameters["p_line_assign"] | p_line_assign | 행/컬럼 값 대입 |  |  |  |
| AC-5f10a2d9 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SCP0013_ProductionPlanLine.cs:2071 | try ▸ lambda | DATA_OP | req.Parameters["p_bucket"] | p_bucket | 행/컬럼 값 대입 |  |  |  |
| AC-06cf486c | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SCP0013_ProductionPlanLine.cs:2072 | try ▸ lambda | DATA_OP | req.Parameters["p_chk_all"] | p_chk_all | 행/컬럼 값 대입 |  |  |  |
| AC-acbcc642 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SCP0013_ProductionPlanLine.cs:2073 | try ▸ lambda | DATA_OP | req.Parameters["p_extra_spec"] | p_extra_spec | 행/컬럼 값 대입 |  |  |  |
| AC-7d718b2f | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SCP0013_ProductionPlanLine.cs:2074 | try ▸ lambda | DATA_OP | req.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-11bb1007 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SCP0013_ProductionPlanLine.cs:2075 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-2218c12a | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SCP0013_ProductionPlanLine.cs:2076 | try ▸ lambda | RETURN | return res.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-a33e53ef | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SCP0013_ProductionPlanLine.cs:2088 | try | GRID_BIND | siMain.Query | (dsBinding) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-fbc8f802 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SCP0013_ProductionPlanLine.cs:2090 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-6d0aec3e | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SCP0013_ProductionPlanLine.cs:2091 | try | UI_MISC | SetSearchCount | (dsBinding) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-eb27d4ec | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SCP0013_ProductionPlanLine.cs:2094 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-184c5fc9 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SCP0013_ProductionPlanLine.cs:2114 | try ▸ if (dsBinding.Tables.Count > 0) | FLAG | dtFix | dsBinding.Tables[1] | 화면 필드/플래그 변경 |  |  |  |
| AC-32a21aea | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SCP0013_ProductionPlanLine.cs:2125 | try ▸ if (this.nSelRowOfMain >= 0 && isReload) | GRID_STYLE | siMain.ActiveSheet.SetActiveCell | (this.nSelRowOfMain, this.nSelColOfMain) | 그리드 표시 설정 |  |  |  |
| AC-b4a243be | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SCP0013_ProductionPlanLine.cs:2126 | try ▸ if (this.nSelRowOfMain >= 0 && isReload) | CALL_EXT | spdMain.ShowCell | (0, 0, this.nSelRowOfMain, this.nSelColOfMain, FarPoint.Win.Spread.VerticalPosition.Center… | ⚠ 의미 확인 필요 |  |  |  |
| AC-5faab98b | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SCP0013_ProductionPlanLine.cs:2130 | try | FLAG | cellclipboardPast | false | 화면 필드/플래그 변경 |  |  |  |
| AC-ee4a573f | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SCP0013_ProductionPlanLine.cs:2135 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-103c5de6 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SCP0013_ProductionPlanLine.cs:2141 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0013_ProductionPlanLine.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3c911c9d | this.Load | SCP0013_ProductionPlanLine.cs:221 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-a7feff0b | this.Load | SCP0013_ProductionPlanLine.cs:232 |  | FLAG | dtSpdTitle | GetSpdTitle2("SCP0013", UserInfo.UserId, SpdSheet.shtMain) | 화면 필드/플래그 변경 |  |  |  |

## SCP0013_ProductionPlanLine.Get_IsEditInfo

진입점: btnNew.Click [if (popup.DialogResult == DialogResult.OK) ▸ if (MessageHelper.GMessageBox("MSG00265") == DialogResult.Yes)] / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7506899d | btnNew.Click [if (popup.DialogResult == DialogResult.OK) ▸ i… 외 1 | SCP0013_ProductionPlanLine.cs:3338 | if (division == null \|\| division == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a950a66f | btnNew.Click [if (popup.DialogResult == DialogResult.OK) ▸ i… 외 1 | SCP0013_ProductionPlanLine.cs:3360 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0013_GET_PLAN_EDIT_INFO") ⇒ SCP.SCP0013_GET_PLAN_EDIT_INFO | 엔드포인트 요청 생성 |  |  |  |
| AC-42fa6e4e | btnNew.Click [if (popup.DialogResult == DialogResult.OK) ▸ i… 외 1 | SCP0013_ProductionPlanLine.cs:3362 |  | UI_PROP | request.CommandTimeout | 10 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-b69b11a0 | btnNew.Click [if (popup.DialogResult == DialogResult.OK) ▸ i… 외 1 | SCP0013_ProductionPlanLine.cs:3364 |  | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-145328e6 | btnNew.Click [if (popup.DialogResult == DialogResult.OK) ▸ i… 외 1 | SCP0013_ProductionPlanLine.cs:3365 |  | DATA_OP | request.Parameters["p_operation_group"] | p_operation_group | 행/컬럼 값 대입 |  |  |  |
| AC-9c928048 | btnNew.Click [if (popup.DialogResult == DialogResult.OK) ▸ i… 외 1 | SCP0013_ProductionPlanLine.cs:3366 |  | DATA_OP | request.Parameters["p_scm_site_id"] | p_scm_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-7892461f | btnNew.Click [if (popup.DialogResult == DialogResult.OK) ▸ i… 외 1 | SCP0013_ProductionPlanLine.cs:3367 |  | DATA_OP | request.Parameters["p_line_id"] | p_line_id | 행/컬럼 값 대입 |  |  |  |
| AC-61bb1b4b | btnNew.Click [if (popup.DialogResult == DialogResult.OK) ▸ i… 외 1 | SCP0013_ProductionPlanLine.cs:3368 |  | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-87e3289f | btnNew.Click [if (popup.DialogResult == DialogResult.OK) ▸ i… 외 1 | SCP0013_ProductionPlanLine.cs:3369 |  | DATA_OP | request.Parameters["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-96c1aa62 | btnNew.Click [if (popup.DialogResult == DialogResult.OK) ▸ i… 외 1 | SCP0013_ProductionPlanLine.cs:3370 |  | DATA_OP | request.Parameters["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-1e40d927 | btnNew.Click [if (popup.DialogResult == DialogResult.OK) ▸ i… 외 1 | SCP0013_ProductionPlanLine.cs:3371 |  | DATA_OP | request.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-507bc01e | btnNew.Click [if (popup.DialogResult == DialogResult.OK) ▸ i… 외 1 | SCP0013_ProductionPlanLine.cs:3372 |  | DATA_OP | request.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-2dee5c72 | btnNew.Click [if (popup.DialogResult == DialogResult.OK) ▸ i… 외 1 | SCP0013_ProductionPlanLine.cs:3373 |  | DATA_OP | request.Parameters["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-02828bc2 | btnNew.Click [if (popup.DialogResult == DialogResult.OK) ▸ i… 외 1 | SCP0013_ProductionPlanLine.cs:3374 |  | DATA_OP | request.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-5528311a | btnNew.Click [if (popup.DialogResult == DialogResult.OK) ▸ i… 외 1 | SCP0013_ProductionPlanLine.cs:3376 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-2ebdbc34 | btnNew.Click [if (popup.DialogResult == DialogResult.OK) ▸ i… 외 1 | SCP0013_ProductionPlanLine.cs:3412 | if (dsBinding.Tables.Count > 0) | FLAG | dtIsEditInfo | dsBinding.Tables[0] | 화면 필드/플래그 변경 |  |  |  |

## SCP0013_ProductionPlanLine.Get_IsSaveYn

진입점: this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName))] / this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))] / btnNew.Click / SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a51c4061 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 3 | SCP0013_ProductionPlanLine.cs:3430 | if (division == null \|\| division == "") | RETURN | return saveYn; |  | 처리 중단/반환 |  |  |  |
| AC-ab0c6a32 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 3 | SCP0013_ProductionPlanLine.cs:3442 | try | ENDPOINT | new FoxDataRequest | ("SCP.SCP0013_GET_PLAN_TYPE_SAVE_YN") ⇒ SCP.SCP0013_GET_PLAN_TYPE_SAVE_YN | 엔드포인트 요청 생성 |  |  |  |
| AC-fe621b83 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 3 | SCP0013_ProductionPlanLine.cs:3443 | try | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-f8b8ffbe | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 3 | SCP0013_ProductionPlanLine.cs:3444 | try | DATA_OP | request.Parameters["p_start_yyyymmdd"] | p_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-d194fe8f | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 3 | SCP0013_ProductionPlanLine.cs:3445 | try | DATA_OP | request.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-63bcc6d4 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 3 | SCP0013_ProductionPlanLine.cs:3447 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-91c1afbf | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 3 | SCP0013_ProductionPlanLine.cs:3457 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-2ef47a7d | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 3 | SCP0013_ProductionPlanLine.cs:3462 | if (!saveYn) | MESSAGE | MessageHelper.GMessageBox | ("MSG00182") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-5a222af4 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 3 | SCP0013_ProductionPlanLine.cs:3464 |  | RETURN | return saveYn; |  | 처리 중단/반환 |  |  |  |

## SCP0013_ProductionPlanLine.GetBucketType

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-40bcea49 | this.Load | SCP0013_ProductionPlanLine.cs:1760 |  | ENDPOINT | new FoxDataRequest | ("DM.DM0003_GET_BUCKET_TYPE_CODE") ⇒ DM.DM0003_GET_BUCKET_TYPE_CODE | 엔드포인트 요청 생성 |  |  |  |
| AC-395b199f | this.Load | SCP0013_ProductionPlanLine.cs:1761 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-4dde7596 | this.Load | SCP0013_ProductionPlanLine.cs:1764 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SCP0013_ProductionPlanLine.GetDayRange

진입점: this.Load / cboPlanDate.SelectedIndexChanged / btnW26.Click / btnW52.Click / btnWLast.Click [if (success)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b537d4f6 | this.Load 외 4 | SCP0013_ProductionPlanLine.cs:4116 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCM0001_GET_SCP_DAY_PERIOD") ⇒ SCP.SCM0001_GET_SCP_DAY_PERIOD | 엔드포인트 요청 생성 |  |  |  |
| AC-69174725 | this.Load 외 4 | SCP0013_ProductionPlanLine.cs:4117 |  | DATA_OP | request.Parameters["p_from_date"] | p_plan_start_date == null ? "" : p_plan_start_date | 행/컬럼 값 대입 |  |  |  |
| AC-576d1ab9 | this.Load 외 4 | SCP0013_ProductionPlanLine.cs:4118 |  | DATA_OP | request.Parameters["p_offset_day"] | Convert.ToInt32(periodType) * 7 - 1 | 행/컬럼 값 대입 |  |  |  |
| AC-0de97b04 | this.Load 외 4 | SCP0013_ProductionPlanLine.cs:4119 |  | DATA_OP | request.Parameters["p_timezone"] | UserInfoContext.Current[UserInfoProperites.TimeZone] | 행/컬럼 값 대입 |  |  |  |
| AC-5473b1d7 | this.Load 외 4 | SCP0013_ProductionPlanLine.cs:4120 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-1c93692d | this.Load 외 4 | SCP0013_ProductionPlanLine.cs:4122 |  | RETURN | return sDayRange; |  | 처리 중단/반환 |  |  |  |

## SCP0013_ProductionPlanLine.GetExtraSpecAll

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c914757f | (진입점 미연결) | SCP0013_ProductionPlanLine.cs:469 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0013_GET_EXTRA_SPEC") ⇒ SCP.SCP0013_GET_EXTRA_SPEC | 엔드포인트 요청 생성 |  |  |  |
| AC-09c93ddc | (진입점 미연결) | SCP0013_ProductionPlanLine.cs:471 |  | DATA_OP | request.Parameters["p_division_id"] | "40" | 행/컬럼 값 대입 |  |  |  |
| AC-851058e0 | (진입점 미연결) | SCP0013_ProductionPlanLine.cs:472 |  | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-65640adb | (진입점 미연결) | SCP0013_ProductionPlanLine.cs:475 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-688e9dcc | (진입점 미연결) | SCP0013_ProductionPlanLine.cs:479 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SCP0013_ProductionPlanLine.GetLastPlanVersion

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4f89953d | (진입점 미연결) | SCP0013_ProductionPlanLine.cs:1922 | try | ENDPOINT | new FoxDataRequest | ("SCP.SCP0011_GET_LAST_PLAN_VERSION") ⇒ SCP.SCP0011_GET_LAST_PLAN_VERSION | 엔드포인트 요청 생성 |  |  |  |
| AC-e4447375 | (진입점 미연결) | SCP0013_ProductionPlanLine.cs:1924 | try | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-47b59f90 | (진입점 미연결) | SCP0013_ProductionPlanLine.cs:1925 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-9059fbd8 | (진입점 미연결) | SCP0013_ProductionPlanLine.cs:1941 | try ▸ if (dsBinding.Tables.Count > 0 && dsBinding.Tables[0].Rows.Count > 0) | VALUE_SET | cboPlanDate.SelectedValue | PLAN_START_YYYYMMDD | 컨트롤 값 설정 |  |  |  |
| AC-dcbd1736 | (진입점 미연결) | SCP0013_ProductionPlanLine.cs:1942 | try ▸ if (dsBinding.Tables.Count > 0 && dsBinding.Tables[0].Rows.Count > 0) | VALUE_SET | cboPlanType.SelectedValue | PLAN_TYPE | 컨트롤 값 설정 |  |  |  |
| AC-c2032fbb | (진입점 미연결) | SCP0013_ProductionPlanLine.cs:1943 | try ▸ if (dsBinding.Tables.Count > 0 && dsBinding.Tables[0].Rows.Count > 0) | VALUE_SET | cboPlanSeq.SelectedValue | PLAN_SEQ | 컨트롤 값 설정 |  |  |  |

## SCP0013_ProductionPlanLine.GetLastRange

진입점: this.Load / cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-704dff3a | this.Load 외 1 | SCP0013_ProductionPlanLine.cs:4101 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCM0001_GET_SCP_DAILY_PLAN_PERIOD") ⇒ SCP.SCM0001_GET_SCP_DAILY_PLAN_PERIOD | 엔드포인트 요청 생성 |  |  |  |
| AC-6abc84b5 | this.Load 외 1 | SCP0013_ProductionPlanLine.cs:4102 |  | DATA_OP | request.Parameters["p_division_id"] | divisionId | 행/컬럼 값 대입 |  |  |  |
| AC-f3a0d849 | this.Load 외 1 | SCP0013_ProductionPlanLine.cs:4103 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-108a37c5 | this.Load 외 1 | SCP0013_ProductionPlanLine.cs:4105 |  | RETURN | return dailyPlanPeriod; |  | 처리 중단/반환 |  |  |  |

## SCP0013_ProductionPlanLine.GetLineList

진입점: cboCellTypeGr.SelectedIndexChanged [try ▸ if (CommonUtils.CheckDataEmpty(p_cell_type_gr) == false)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-14efd5c7 | cboCellTypeGr.SelectedIndexChanged [try ▸ if (CommonUtils.Ch… | SCP0013_ProductionPlanLine.cs:4152 | try | ENDPOINT | new FoxDataRequest | ("SCP.SCP0013_GET_LINE_LIST") ⇒ SCP.SCP0013_GET_LINE_LIST | 엔드포인트 요청 생성 |  |  |  |
| AC-5450409d | cboCellTypeGr.SelectedIndexChanged [try ▸ if (CommonUtils.Ch… | SCP0013_ProductionPlanLine.cs:4153 | try | UI_PROP | request.CommandTimeout | 1 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-572cc90e | cboCellTypeGr.SelectedIndexChanged [try ▸ if (CommonUtils.Ch… | SCP0013_ProductionPlanLine.cs:4154 | try | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-e55e9037 | cboCellTypeGr.SelectedIndexChanged [try ▸ if (CommonUtils.Ch… | SCP0013_ProductionPlanLine.cs:4155 | try | DATA_OP | request.Parameters["p_operation_group"] | p_operation_group | 행/컬럼 값 대입 |  |  |  |
| AC-6d67371c | cboCellTypeGr.SelectedIndexChanged [try ▸ if (CommonUtils.Ch… | SCP0013_ProductionPlanLine.cs:4156 | try | DATA_OP | request.Parameters["p_plant_site"] | p_plant_site | 행/컬럼 값 대입 |  |  |  |
| AC-5e3f40a7 | cboCellTypeGr.SelectedIndexChanged [try ▸ if (CommonUtils.Ch… | SCP0013_ProductionPlanLine.cs:4157 | try | DATA_OP | request.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-10338fa8 | cboCellTypeGr.SelectedIndexChanged [try ▸ if (CommonUtils.Ch… | SCP0013_ProductionPlanLine.cs:4158 | try | DATA_OP | request.Parameters["p_cell_type_gr"] | p_cell_type_gr | 행/컬럼 값 대입 |  |  |  |
| AC-bf97ff7c | cboCellTypeGr.SelectedIndexChanged [try ▸ if (CommonUtils.Ch… | SCP0013_ProductionPlanLine.cs:4159 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-7573a526 | cboCellTypeGr.SelectedIndexChanged [try ▸ if (CommonUtils.Ch… | SCP0013_ProductionPlanLine.cs:4166 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SCP0013_ProductionPlanLine.GetSpdTitle

진입점: this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName)) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Equals("S")) ▸ try] / this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName)) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Equals("S")) ▸ try] / this.Load / th…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ced2d98c | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 13 | SCP0013_ProductionPlanLine.cs:4061 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN") ⇒ SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | 엔드포인트 요청 생성 |  |  |  |
| AC-62c72b39 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 13 | SCP0013_ProductionPlanLine.cs:4066 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | dCalendar.Text1.Replace("-", "") | 행/컬럼 값 대입 |  |  |  |
| AC-55f09ae6 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 13 | SCP0013_ProductionPlanLine.cs:4067 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | dCalendar.Text2.Replace("-", "") | 행/컬럼 값 대입 |  |  |  |
| AC-fc18b0bb | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 13 | SCP0013_ProductionPlanLine.cs:4069 |  | FLAG | dsSpdTitle | client.ExecuteDataSet(request).DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-f82d64a2 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 13 | SCP0013_ProductionPlanLine.cs:4069 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## SCP0013_ProductionPlanLine.GetSpdTitle2

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2c55f3bf | this.Load | SCP0013_ProductionPlanLine.cs:3759 | try | ENDPOINT | new FoxDataRequest | ("SCM.SCM_SYS_GET_SPREAD_TITLE") ⇒ SCM.SCM_SYS_GET_SPREAD_TITLE | 엔드포인트 요청 생성 |  |  |  |
| AC-f0e26f74 | this.Load | SCP0013_ProductionPlanLine.cs:3760 | try | DATA_OP | request.Parameters["p_program_id"] | programID | 행/컬럼 값 대입 |  |  |  |
| AC-a672b667 | this.Load | SCP0013_ProductionPlanLine.cs:3761 | try | DATA_OP | request.Parameters["p_user_id"] | userID | 행/컬럼 값 대입 |  |  |  |
| AC-02114496 | this.Load | SCP0013_ProductionPlanLine.cs:3762 | try | DATA_OP | request.Parameters["p_sheet_name"] | sheetName | 행/컬럼 값 대입 |  |  |  |
| AC-edc33849 | this.Load | SCP0013_ProductionPlanLine.cs:3764 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-37e67cb5 | this.Load | SCP0013_ProductionPlanLine.cs:3774 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SCP0013_ProductionPlanLine.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-18a7a5cf | this.Load | SCP0013_ProductionPlanLine.cs:265 |  | DATA_OP | this.ConditionNotUseList.Add | (cboPlanDate) | 데이터 객체 조작/조회 |  |  |  |
| AC-d74c3d7a | this.Load | SCP0013_ProductionPlanLine.cs:266 |  | DATA_OP | this.ConditionNotUseList.Add | (cboPlanType) | 데이터 객체 조작/조회 |  |  |  |
| AC-c79c962f | this.Load | SCP0013_ProductionPlanLine.cs:267 |  | DATA_OP | this.ConditionNotUseList.Add | (cboPlanSeq) | 데이터 객체 조작/조회 |  |  |  |
| AC-7dad892d | this.Load | SCP0013_ProductionPlanLine.cs:271 | if (dtMyDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |
| AC-43f6b190 | this.Load | SCP0013_ProductionPlanLine.cs:272 | if (dtMyDivision.Rows.Count == 0) | STATE | btnLoad.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-caa6fd70 | this.Load | SCP0013_ProductionPlanLine.cs:275 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-a771278c | this.Load | SCP0013_ProductionPlanLine.cs:279 |  | LIST_REBIND | clsCtrl.setListBox | (dtMyDivision, cboDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-a2566a1f | this.Load | SCP0013_ProductionPlanLine.cs:285 |  | LIST_REBIND | clsCtrl.setListBox | (dtElectrodeType, cboElectrode, false) | 목록 컨트롤 재구성 |  |  |  |
| AC-fdd5d875 | this.Load | SCP0013_ProductionPlanLine.cs:286 |  | LIST_REBIND | clsCtrl.setListBox | (dtCellTypeGr, cboCellTypeGr, false) | 목록 컨트롤 재구성 |  |  |  |
| AC-0d0deac7 | this.Load | SCP0013_ProductionPlanLine.cs:290 |  | FLAG | dtBucketType | GetBucketType() | 화면 필드/플래그 변경 |  |  |  |
| AC-5f4d9d7d | this.Load | SCP0013_ProductionPlanLine.cs:291 |  | LIST_REBIND | clsCtrl.setListBox | (dtBucketType, cboBucketType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-dde28961 | this.Load | SCP0013_ProductionPlanLine.cs:294 |  | VALUE_SET | dCalendar.InitValue | GetDayRange(PeriodType.W52) | 컨트롤 값 설정 |  |  |  |
| AC-e2a76916 | this.Load | SCP0013_ProductionPlanLine.cs:305 | if (dailyPlanPeriod == PeriodType.W52) | UI_PROP | layoutControlItem18.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-bca0c0be | this.Load | SCP0013_ProductionPlanLine.cs:308 |  | VALUE_SET | btnWLast.Text | "W" + dailyPlanPeriod | 컨트롤 값 설정 |  |  |  |

## SCP0013_ProductionPlanLine.InitSpread

진입점: this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName)) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Equals("S")) ▸ try] / this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName)) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Equals("S")) ▸ try] / this.Load / th…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-beaa1f07 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 13 | SCP0013_ProductionPlanLine.cs:329 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.InitSheet | (SpdSheet.shtMain) | 그리드 재구성/초기화 |  |  |  |
| AC-82b8c876 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 13 | SCP0013_ProductionPlanLine.cs:330 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_SET | spdInfo.ActiveSheet.DataSource | null | 그리드 속성/값 설정 |  |  |  |
| AC-881b3626 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 13 | SCP0013_ProductionPlanLine.cs:331 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.SetSheetHeaderColumn | (spdInfo, 3) | 그리드 재구성/초기화 |  |  |  |
| AC-429c1c8c | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 13 | SCP0013_ProductionPlanLine.cs:336 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b5b75091 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 13 | SCP0013_ProductionPlanLine.cs:337 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-6919375c | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 13 | SCP0013_ProductionPlanLine.cs:341 | if (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (division.Substring(0, 2).Equals("EE") == false) | GRID_SET | spdInfo.ActiveSheet.Columns[siMain.GetColumnIndex("ORIGIN_DIVISION_ID")].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-feda0179 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 13 | SCP0013_ProductionPlanLine.cs:342 | if (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (division.Substring(0, 2).Equals("EE") == false) | GRID_SET | spdInfo.ActiveSheet.Columns[siMain.GetColumnIndex("ELECTRODE_TYPE")].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-fb6c250c | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 13 | SCP0013_ProductionPlanLine.cs:343 | if (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (division.Substring(0, 2).Equals("EE") == false) | GRID_SET | spdInfo.ActiveSheet.Columns[siMain.GetColumnIndex("UNIT")].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-a2253d4a | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 13 | SCP0013_ProductionPlanLine.cs:346 | if (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (division.Substring(0, 2).Equals("EE") == false) ▸ if (division == "40") | GRID_SET | spdInfo.ActiveSheet.Columns[siMain.GetColumnIndex("CELL_TYPE_GROUP_CODE")].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-c01f23a2 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 13 | SCP0013_ProductionPlanLine.cs:348 | if (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (division.Substring(0, 2).Equals("EE") == false) ▸ else of (division == "40") | GRID_SET | spdInfo.ActiveSheet.Columns[siMain.GetColumnIndex("CELL_TYPE_GROUP_CODE")].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-9784950c | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 13 | SCP0013_ProductionPlanLine.cs:350 | if (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (division.Substring(0, 2).Equals("EE") == false) | GRID_SET | spdInfo.ActiveSheet.Columns[siMain.GetColumnIndex("CELL_ID")].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-3d412152 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 13 | SCP0013_ProductionPlanLine.cs:354 | if (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (division.Substring(0, 2).Equals("EE") == false) | GRID_SET | spdInfo.ActiveSheet.Columns[siMain.GetColumnIndex("ORIGIN_DIVISION_ID")].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-d695a6c6 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 13 | SCP0013_ProductionPlanLine.cs:355 | if (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (division.Substring(0, 2).Equals("EE") == false) | GRID_SET | spdInfo.ActiveSheet.Columns[siMain.GetColumnIndex("ELECTRODE_TYPE")].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-4ad4a032 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 13 | SCP0013_ProductionPlanLine.cs:356 | if (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (division.Substring(0, 2).Equals("EE") == false) | GRID_SET | spdInfo.ActiveSheet.Columns[siMain.GetColumnIndex("CELL_TYPE_GROUP_CODE")].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-ce42bace | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 13 | SCP0013_ProductionPlanLine.cs:360 | if (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (division.Substring(0, 2).Equals("EE") == false) ▸ if (operationGroup.Equals("E")) | GRID_SET | spdInfo.ActiveSheet.Columns[siMain.GetColumnIndex("UNIT")].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-e869031e | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 13 | SCP0013_ProductionPlanLine.cs:361 | if (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (division.Substring(0, 2).Equals("EE") == false) ▸ if (operationGroup.Equals("E")) | GRID_SET | spdInfo.ActiveSheet.Columns[siMain.GetColumnIndex("CELL_ID")].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-45c51b84 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 13 | SCP0013_ProductionPlanLine.cs:365 | if (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (division.Substring(0, 2).Equals("EE") == false) ▸ else of (operationGroup.Equals("E")) | GRID_SET | spdInfo.ActiveSheet.Columns[siMain.GetColumnIndex("UNIT")].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-ee094128 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 13 | SCP0013_ProductionPlanLine.cs:366 | if (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (division.Substring(0, 2).Equals("EE") == false) ▸ else of (operationGroup.Equals("E")) | GRID_SET | spdInfo.ActiveSheet.Columns[siMain.GetColumnIndex("CELL_ID")].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-107aef20 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 13 | SCP0013_ProductionPlanLine.cs:370 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_SET | spdInfo.ActiveSheet.Columns[spdInfo.GetColumnIndex("EXTRA_SPEC")].Visible | (division == "40") | 그리드 속성/값 설정 |  |  |  |

## SCP0013_ProductionPlanLine.InitSpreadDateColumn

진입점: this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName)) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Equals("S")) ▸ try ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName)) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].To…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0bfc9c91 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 13 | SCP0013_ProductionPlanLine.cs:410 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sColumnName.IndexOf("B_") > 0) | GRID_INIT | spdInfo.AddTextColumn | (sColumnLabelname, sColumnName, FPMerge.None, 0, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a7a35842 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 13 | SCP0013_ProductionPlanLine.cs:414 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sColumnName.IndexOf("B_") > 0) | GRID_INIT | spdInfo.AddNumColumn | (sColumnLabelname, sColumnName, FPMerge.None, 70, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-baec5e39 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 13 | SCP0013_ProductionPlanLine.cs:415 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sColumnName.IndexOf("B_") > 0) | GRID_INIT | spdInfo.SetReNumerCellType | (spdInfo, spdInfo.GetColumnIndex(sColumnName), 0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-605400d2 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 13 | SCP0013_ProductionPlanLine.cs:419 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sColumnName.IndexOf("B_") > 0) ▸ if (sDayCode == DefColumnsLabel.Saturday \|\| … | GRID_SET | spdInfo.Sheet().ColumnHeader.Cells[2, spdInfo.GetMaxColumnIndex()].ForeColor | sDayCode == DefColumnsLabel.Saturday ? Color.Blue : Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-4b4838c7 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 13 | SCP0013_ProductionPlanLine.cs:426 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6116fca9 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 13 | SCP0013_ProductionPlanLine.cs:427 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-fc094a51 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 13 | SCP0013_ProductionPlanLine.cs:432 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c91729e0 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 13 | SCP0013_ProductionPlanLine.cs:433 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 30, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f80c0b81 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 13 | SCP0013_ProductionPlanLine.cs:441 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName != sSmallLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ba550554 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 13 | SCP0013_ProductionPlanLine.cs:442 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName != sSmallLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f24ec711 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 13 | SCP0013_ProductionPlanLine.cs:452 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-30c99705 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 13 | SCP0013_ProductionPlanLine.cs:453 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-59a1ba01 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 13 | SCP0013_ProductionPlanLine.cs:454 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-380ebc12 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 13 | SCP0013_ProductionPlanLine.cs:455 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0013_ProductionPlanLine.RefreshExtraSpec

진입점: this.Load [if (division == "40")] / cboOperationGroup.SelectedIndexChanged / cboDivision.SelectedIndexChanged [if (division == "40")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0ff94045 | this.Load [if (division == "40")] 외 2 | SCP0013_ProductionPlanLine.cs:488 | if (dtExtraSpecAll != null) | FLAG | dtExtraSpec | DBUtils.Filter(dtExtraSpecAll, "OPERATION_GROUP = '" + operationGroup + "'", true) | 화면 필드/플래그 변경 |  |  |  |
| AC-9f71d263 | this.Load [if (division == "40")] 외 2 | SCP0013_ProductionPlanLine.cs:488 | if (dtExtraSpecAll != null) | DATA_OP | DBUtils.Filter | (dtExtraSpecAll, "OPERATION_GROUP = '" + operationGroup + "'", true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-6087bbb2 | this.Load [if (division == "40")] 외 2 | SCP0013_ProductionPlanLine.cs:490 | if (dtExtraSpecAll != null) | LIST_REBIND | clsCtrl.setListBox | (dtExtraSpec, clbExtraSpec, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0013_ProductionPlanLine.RefreshLine

진입점: cboOperationGroup.SelectedIndexChanged / clbPlantSite.SelectedIndexChanged / cboCellTypeGr.SelectedIndexChanged [try ▸ else of (CommonUtils.CheckDataEmpty(p_cell_type_gr) == false)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f43521ac | cboOperationGroup.SelectedIndexChanged 외 2 | SCP0013_ProductionPlanLine.cs:1880 | if (division.Substring(0, 2).Equals("EE")) | CALL_EXT | DBUtils.GetAndFilterString | (new List<string>() { "DIVISION_ID", "OPERATION_GROUP" ,"SITE_ID"}, new List<string>() { d… | ⚠ 의미 확인 필요 |  |  |  |
| AC-59d8158c | cboOperationGroup.SelectedIndexChanged 외 2 | SCP0013_ProductionPlanLine.cs:1881 | if (division.Substring(0, 2).Equals("EE")) | FLAG | dtLine | DBUtils.Filter(dtLineEEAll, filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-0c20a604 | cboOperationGroup.SelectedIndexChanged 외 2 | SCP0013_ProductionPlanLine.cs:1881 | if (division.Substring(0, 2).Equals("EE")) | DATA_OP | DBUtils.Filter | (dtLineEEAll, filter) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-90d550d0 | cboOperationGroup.SelectedIndexChanged 외 2 | SCP0013_ProductionPlanLine.cs:1885 | else of (division.Substring(0, 2).Equals("EE")) | CALL_EXT | DBUtils.GetAndFilterString | (new List<string>() { "DIVISION_ID", "SITE_ID" }, new List<string>() { division, plantSite… | ⚠ 의미 확인 필요 |  |  |  |
| AC-55174ffd | cboOperationGroup.SelectedIndexChanged 외 2 | SCP0013_ProductionPlanLine.cs:1886 | else of (division.Substring(0, 2).Equals("EE")) | FLAG | dtLine | DBUtils.Filter(dtLineAll, filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-792b437a | cboOperationGroup.SelectedIndexChanged 외 2 | SCP0013_ProductionPlanLine.cs:1886 | else of (division.Substring(0, 2).Equals("EE")) | DATA_OP | DBUtils.Filter | (dtLineAll, filter) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-e0e98b8d | cboOperationGroup.SelectedIndexChanged 외 2 | SCP0013_ProductionPlanLine.cs:1889 |  | LIST_REBIND | clsCtrl.setListBox | (dtLine, clbLine, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0013_ProductionPlanLine.RefreshPlanDate

진입점: this.Load / cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-686454a7 | this.Load 외 1 | SCP0013_ProductionPlanLine.cs:1840 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | FLAG | dtPlanDate | DBUtils.Filter(dtPlanDateAll, "DIVISION_ID = '" + division + "'", true) | 화면 필드/플래그 변경 |  |  |  |
| AC-3a2d386b | this.Load 외 1 | SCP0013_ProductionPlanLine.cs:1840 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | DATA_OP | DBUtils.Filter | (dtPlanDateAll, "DIVISION_ID = '" + division + "'", true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-59dada29 | this.Load 외 1 | SCP0013_ProductionPlanLine.cs:1842 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | LIST_REBIND | clsCtrl.setListBox | (dtPlanDate, cboPlanDate, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-6d74b427 | this.Load 외 1 | SCP0013_ProductionPlanLine.cs:1846 | else of (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | FLAG | dtPlanDate | dtPlanDateAll.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-555c5900 | this.Load 외 1 | SCP0013_ProductionPlanLine.cs:1846 | else of (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | DATA_OP | dtPlanDateAll.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-2825e9fc | this.Load 외 1 | SCP0013_ProductionPlanLine.cs:1848 | else of (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | LIST_REBIND | clsCtrl.setListBox | (dtPlanDate, cboPlanDate, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0013_ProductionPlanLine.RefreshPlanSeq

진입점: this.Load / cboDivision.SelectedIndexChanged / cboPlanType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-34d71122 | this.Load 외 2 | SCP0013_ProductionPlanLine.cs:1867 |  | FLAG | dtPlanSeq | DBUtils.Filter(dtPlanSeqAll,"DIVISION_ID = '" + division + "' AND PLANDATE = '" + planDate… | 화면 필드/플래그 변경 |  |  |  |
| AC-21caaa8f | this.Load 외 2 | SCP0013_ProductionPlanLine.cs:1867 |  | DATA_OP | DBUtils.Filter | (dtPlanSeqAll,"DIVISION_ID = '" + division + "' AND PLANDATE = '" + planDate + "' AND PLAN… | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-40a64396 | this.Load 외 2 | SCP0013_ProductionPlanLine.cs:1869 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanSeq, cboPlanSeq, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0013_ProductionPlanLine.RefreshPlantSite

진입점: this.Load / cboOperationGroup.SelectedIndexChanged / cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cb8defa3 | this.Load 외 2 | SCP0013_ProductionPlanLine.cs:1823 | if (division.Substring(0, 2).Equals("EE")) | FLAG | dtPlantSiteByDivision | DBUtils.Filter(dtPlantSiteEEAll, "DIVISION_ID = '" + division + "' AND OPERATION_GROUP = '… | 화면 필드/플래그 변경 |  |  |  |
| AC-091b21bc | this.Load 외 2 | SCP0013_ProductionPlanLine.cs:1823 | if (division.Substring(0, 2).Equals("EE")) | DATA_OP | DBUtils.Filter | (dtPlantSiteEEAll, "DIVISION_ID = '" + division + "' AND OPERATION_GROUP = '" + operationG… | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-0e69063c | this.Load 외 2 | SCP0013_ProductionPlanLine.cs:1828 | else of (division.Substring(0, 2).Equals("EE")) | FLAG | dtPlantSiteByDivision | DBUtils.Filter(dtPlantSiteAll, "DIVISION_ID = '" + division + "' AND OPERATION_GROUP = '" … | 화면 필드/플래그 변경 |  |  |  |
| AC-47380e28 | this.Load 외 2 | SCP0013_ProductionPlanLine.cs:1828 | else of (division.Substring(0, 2).Equals("EE")) | DATA_OP | DBUtils.Filter | (dtPlantSiteAll, "DIVISION_ID = '" + division + "' AND OPERATION_GROUP = '" + operationGro… | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-cfccbd96 | this.Load 외 2 | SCP0013_ProductionPlanLine.cs:1831 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlantSiteByDivision, clbPlantSite, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0013_ProductionPlanLine.RefreshPlanType

진입점: this.Load / cboDivision.SelectedIndexChanged / cboPlanDate.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-02035ae3 | this.Load 외 2 | SCP0013_ProductionPlanLine.cs:1857 |  | FLAG | dtPlanType | DBUtils.Filter(dtPlanTypeAll, "DIVISION_ID = '" + division + "' AND PLANDATE = '" + planDa… | 화면 필드/플래그 변경 |  |  |  |
| AC-ba599c1e | this.Load 외 2 | SCP0013_ProductionPlanLine.cs:1857 |  | DATA_OP | DBUtils.Filter | (dtPlanTypeAll, "DIVISION_ID = '" + division + "' AND PLANDATE = '" + planDate + "'", true… | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-36e5aabe | this.Load 외 2 | SCP0013_ProductionPlanLine.cs:1859 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanType, cboPlanType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0013_ProductionPlanLine.SaveData_FixInfo

진입점: this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName))] / this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-914ffc95 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0013_ProductionPlanLine.cs:2833 | if (fps.Name == "spdMain") | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-4f55cd2a | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0013_ProductionPlanLine.cs:2843 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (siMain.ActiveSheet.Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-cab51154 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0013_ProductionPlanLine.cs:2848 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("A", typeof(char)) | 데이터 객체 조작/조회 |  |  |  |
| AC-ec95e714 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0013_ProductionPlanLine.cs:2849 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_active_flag") | 데이터 객체 조작/조회 |  |  |  |
| AC-21a6c4f9 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0013_ProductionPlanLine.cs:2850 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_division_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-73ecae68 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0013_ProductionPlanLine.cs:2851 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_plan_start_yyyymmdd") | 데이터 객체 조작/조회 |  |  |  |
| AC-96fd7e26 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0013_ProductionPlanLine.cs:2852 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_plan_type") | 데이터 객체 조작/조회 |  |  |  |
| AC-98b48d84 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0013_ProductionPlanLine.cs:2853 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_seq") | 데이터 객체 조작/조회 |  |  |  |
| AC-21fc3e16 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0013_ProductionPlanLine.cs:2854 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_operation_group") | 데이터 객체 조작/조회 |  |  |  |
| AC-479c6ec0 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0013_ProductionPlanLine.cs:2855 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_scm_site_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-ceb9943d | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0013_ProductionPlanLine.cs:2856 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_item_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-58fcc265 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0013_ProductionPlanLine.cs:2857 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_line_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-5570e517 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0013_ProductionPlanLine.cs:2858 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_operation_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-57fc1b43 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0013_ProductionPlanLine.cs:2859 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_measure") | 데이터 객체 조작/조회 |  |  |  |
| AC-c4738d42 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0013_ProductionPlanLine.cs:2860 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_yyyymmdd") | 데이터 객체 조작/조회 |  |  |  |
| AC-29056f5d | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0013_ProductionPlanLine.cs:2861 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_qty") | 데이터 객체 조작/조회 |  |  |  |
| AC-42ad22de | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0013_ProductionPlanLine.cs:2862 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_fix_reason") | 데이터 객체 조작/조회 |  |  |  |
| AC-83d09d70 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0013_ProductionPlanLine.cs:2863 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_user_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-cf5fe762 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0013_ProductionPlanLine.cs:2864 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_fix") | 데이터 객체 조작/조회 |  |  |  |
| AC-a90493f4 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0013_ProductionPlanLine.cs:2865 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_loc_flag") | 데이터 객체 조작/조회 |  |  |  |
| AC-b6f3129c | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0013_ProductionPlanLine.cs:2866 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_program_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-77548840 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0013_ProductionPlanLine.cs:2867 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("debug_mode") | 데이터 객체 조작/조회 |  |  |  |
| AC-fed68b8a | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0013_ProductionPlanLine.cs:2868 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_origin_division_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-5beca1d8 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0013_ProductionPlanLine.cs:2869 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_electrode_type") | 데이터 객체 조작/조회 |  |  |  |
| AC-d4453914 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0013_ProductionPlanLine.cs:2870 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_bucket_type") | 데이터 객체 조작/조회 |  |  |  |
| AC-f6c1df1e | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0013_ProductionPlanLine.cs:2871 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_from_yyyymmdd") | 데이터 객체 조작/조회 |  |  |  |
| AC-9a9c9b65 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0013_ProductionPlanLine.cs:2872 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_to_yyyymmdd") | 데이터 객체 조작/조회 |  |  |  |
| AC-9c54e556 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0013_ProductionPlanLine.cs:2873 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dsInput.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-a2309fe0 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0013_ProductionPlanLine.cs:2908 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (selCells.Length < 1) | MESSAGE | MessageHelper.GMessageBox | ("MSG00134", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0d61467c | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0013_ProductionPlanLine.cs:2909 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (selCells.Length < 1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6ec54795 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0013_ProductionPlanLine.cs:2915 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (fixType == "F") | POPUP | new SCM0002_RejectReasonPopup | ("Fix Reason") | 팝업/폼 생성 |  |  |  |
| AC-291e622a | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0013_ProductionPlanLine.cs:2916 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (fixType == "F") | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-8941545e | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0013_ProductionPlanLine.cs:2917 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (fixType == "F") | UI_PROP | popup.Width | 600 | 속성 Width 설정 |  |  |  |
| AC-bf3e4308 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0013_ProductionPlanLine.cs:2918 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (fixType == "F") | UI_PROP | popup.Height | 230 | 속성 Height 설정 |  |  |  |
| AC-516660e3 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0013_ProductionPlanLine.cs:2920 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (fixType == "F") | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-7f76be1f | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0013_ProductionPlanLine.cs:2929 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (fixType == "F") ▸ else of (popup.ShowDial… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9657f574 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0013_ProductionPlanLine.cs:2936 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ else of (fixType == "F") | MESSAGE | MessageHelper.GMessageBox | ("MSG00016") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-45ac4b80 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0013_ProductionPlanLine.cs:2936 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ else of (fixType == "F") ▸ if (MessageHelper.… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-36a92592 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0013_ProductionPlanLine.cs:2982 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | GRID_STYLE | siMain.SetBGColor | (i, j, i, j, ControlColor.InvalidColor) | 그리드 표시 설정 |  |  |  |
| AC-7de0ba16 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0013_ProductionPlanLine.cs:2983 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | MESSAGE | MessageHelper.GMessageBox | ("MSG00026", new object[] { null }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-168ed219 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0013_ProductionPlanLine.cs:2984 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-54e98822 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0013_ProductionPlanLine.cs:2992 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | CALL_EXT | siMain.GetBGColor | (i, j) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b9bf9427 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0013_ProductionPlanLine.cs:3024 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | DATA_OP | dsInput.Tables[0].NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-8079a06b | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0013_ProductionPlanLine.cs:3025 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | DATA_OP | dr["p_active_flag"] | strAction | 행/컬럼 값 대입 |  |  |  |
| AC-a2498848 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0013_ProductionPlanLine.cs:3026 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | DATA_OP | dr["p_division_id"] | str_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-6d0d5fb4 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0013_ProductionPlanLine.cs:3027 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | DATA_OP | dr["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-70362198 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0013_ProductionPlanLine.cs:3028 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | DATA_OP | dr["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-b34644e9 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0013_ProductionPlanLine.cs:3029 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | DATA_OP | dr["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-4b3d86d2 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0013_ProductionPlanLine.cs:3030 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | DATA_OP | dr["p_operation_group"] | str_operation_group | 행/컬럼 값 대입 |  |  |  |
| AC-45608c2f | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0013_ProductionPlanLine.cs:3031 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | DATA_OP | dr["p_scm_site_id"] | str_scm_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-031bc0b1 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0013_ProductionPlanLine.cs:3032 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | DATA_OP | dr["p_line_id"] | str_line_id | 행/컬럼 값 대입 |  |  |  |
| AC-d381b78e | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0013_ProductionPlanLine.cs:3033 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | DATA_OP | dr["p_item_id"] | str_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-e0dd68f3 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0013_ProductionPlanLine.cs:3034 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | DATA_OP | dr["p_operation_id"] | str_operation_id | 행/컬럼 값 대입 |  |  |  |
| AC-2019e0da | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0013_ProductionPlanLine.cs:3035 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | DATA_OP | dr["p_yyyymmdd"] | strYYYYMMDD | 행/컬럼 값 대입 |  |  |  |
| AC-344db769 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0013_ProductionPlanLine.cs:3036 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | DATA_OP | dr["p_qty"] | siMain.GetValue(i, j).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-fccb78b8 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0013_ProductionPlanLine.cs:3037 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | DATA_OP | dr["p_fix_reason"] | strReason | 행/컬럼 값 대입 |  |  |  |
| AC-78bd097f | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0013_ProductionPlanLine.cs:3038 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | DATA_OP | dr["p_origin_division_id"] | str_origin_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-38af694c | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0013_ProductionPlanLine.cs:3039 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | DATA_OP | dr["p_electrode_type"] | str_electrode_type | 행/컬럼 값 대입 |  |  |  |
| AC-2c058204 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0013_ProductionPlanLine.cs:3040 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | DATA_OP | dr["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-6c17c7bf | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0013_ProductionPlanLine.cs:3041 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | DATA_OP | dr["p_bucket_type"] | p_bucket | 행/컬럼 값 대입 |  |  |  |
| AC-9f16db60 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0013_ProductionPlanLine.cs:3042 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | DATA_OP | dsInput.Tables[0].Rows.Add | (dr) | 데이터 객체 조작/조회 |  |  |  |
| AC-7b7741ea | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0013_ProductionPlanLine.cs:3058 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | CALL_EXT | siMain.GetBGColor | (i, j + nDayCntOfWeek) | ⚠ 의미 확인 필요 |  |  |  |
| AC-341afecd | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0013_ProductionPlanLine.cs:3067 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | GRID_STYLE | siMain.SetBGColor | (i, j + nDayCntOfWeek, i, j + nDayCntOfWeek, ControlColor.InvalidColor) | 그리드 표시 설정 |  |  |  |
| AC-9baaa582 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0013_ProductionPlanLine.cs:3068 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | MESSAGE | MessageHelper.GMessageBox | ("MSG00026", new object[] { null }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d81b5161 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0013_ProductionPlanLine.cs:3069 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-eac6776d | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0013_ProductionPlanLine.cs:3083 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | CALL_EXT | siMain.GetBGColor | (i, j) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e28a5446 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0013_ProductionPlanLine.cs:3092 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | GRID_STYLE | siMain.SetBGColor | (i, j, i, j, ControlColor.InvalidColor) | 그리드 표시 설정 |  |  |  |
| AC-1e9bafbd | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0013_ProductionPlanLine.cs:3093 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | MESSAGE | MessageHelper.GMessageBox | ("MSG00026", new object[] { null }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-37952cfd | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0013_ProductionPlanLine.cs:3094 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3abc1ded | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0013_ProductionPlanLine.cs:3117 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | DATA_OP | dsInput.Tables[0].NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-7018c104 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0013_ProductionPlanLine.cs:3118 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | DATA_OP | dr["p_active_flag"] | strAction | 행/컬럼 값 대입 |  |  |  |
| AC-54e10ba0 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0013_ProductionPlanLine.cs:3119 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | DATA_OP | dr["p_division_id"] | str_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-1dbcdd82 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0013_ProductionPlanLine.cs:3120 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | DATA_OP | dr["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-257a0849 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0013_ProductionPlanLine.cs:3121 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | DATA_OP | dr["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-3613e08f | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0013_ProductionPlanLine.cs:3122 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | DATA_OP | dr["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-7e0d0b0f | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0013_ProductionPlanLine.cs:3123 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | DATA_OP | dr["p_operation_group"] | str_operation_group | 행/컬럼 값 대입 |  |  |  |
| AC-214e4f5a | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0013_ProductionPlanLine.cs:3124 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | DATA_OP | dr["p_scm_site_id"] | str_scm_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-3e95ca82 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0013_ProductionPlanLine.cs:3125 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | DATA_OP | dr["p_line_id"] | str_line_id | 행/컬럼 값 대입 |  |  |  |
| AC-100090d9 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0013_ProductionPlanLine.cs:3126 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | DATA_OP | dr["p_item_id"] | str_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-f64ecb68 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0013_ProductionPlanLine.cs:3127 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | DATA_OP | dr["p_operation_id"] | str_operation_id | 행/컬럼 값 대입 |  |  |  |
| AC-702c54c1 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0013_ProductionPlanLine.cs:3128 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | DATA_OP | dr["p_yyyymmdd"] | strYYYYMMDD | 행/컬럼 값 대입 |  |  |  |
| AC-60cddd8e | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0013_ProductionPlanLine.cs:3129 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | DATA_OP | dr["p_qty"] | sQty | 행/컬럼 값 대입 |  |  |  |
| AC-f05f1914 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0013_ProductionPlanLine.cs:3130 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | DATA_OP | dr["p_fix_reason"] | strReason | 행/컬럼 값 대입 |  |  |  |
| AC-6496e59f | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0013_ProductionPlanLine.cs:3131 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | DATA_OP | dr["p_origin_division_id"] | str_origin_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-2e765025 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0013_ProductionPlanLine.cs:3132 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | DATA_OP | dr["p_electrode_type"] | str_electrode_type | 행/컬럼 값 대입 |  |  |  |
| AC-6ff72127 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0013_ProductionPlanLine.cs:3133 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | DATA_OP | dr["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-6693734f | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0013_ProductionPlanLine.cs:3134 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | DATA_OP | dr["p_bucket_type"] | p_bucket | 행/컬럼 값 대입 |  |  |  |
| AC-fc036c97 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0013_ProductionPlanLine.cs:3135 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | DATA_OP | dsInput.Tables[0].Rows.Add | (dr) | 데이터 객체 조작/조회 |  |  |  |
| AC-bc205f68 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0013_ProductionPlanLine.cs:3155 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) | DATA_OP | dsInput.Tables[0].AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-0f54a37b | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0013_ProductionPlanLine.cs:3169 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | CALL_EXT | sql.AddParameter | ("@SCP0013", dsInput.Tables[0]) | ⚠ 의미 확인 필요 |  |  |  |
| AC-7671e91b | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0013_ProductionPlanLine.cs:3170 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | ENDPOINT | sql.ExcuteProcedure | ("SaveProductionPlanFix") ⇒ biz:AppService.GeneralRunProcedureCustomTable [procedure=SaveProductionPlanFix] … | 엔드포인트 호출 |  |  |  |
| AC-10b2eb01 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0013_ProductionPlanLine.cs:3173 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-abc03979 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0013_ProductionPlanLine.cs:3178 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (result != null &&… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { result.Rows[0]["result_cnt"].ToString() }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-46627189 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0013_ProductionPlanLine.cs:3187 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ else of (result != nu… | MESSAGE | MessageHelper.GMessageBox | ("MSG00003", new object[] { ReErrorMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-af1580e5 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0013_ProductionPlanLine.cs:3196 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-629ce605 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0013_ProductionPlanLine.cs:3197 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d8b3bc74 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0013_ProductionPlanLine.cs:3203 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ finally ▸ if (!prgCloseF) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-963d340f | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0013_ProductionPlanLine.cs:3216 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ else of (iCount > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00252", new object[] { null }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SCP0013_ProductionPlanLine.SaveData_Line_DT

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-da3e23cd | SaveButton | SCP0013_ProductionPlanLine.cs:2458 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-903db452 | SaveButton | SCP0013_ProductionPlanLine.cs:2475 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (siMain.ActiveSheet.Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-77a19763 | SaveButton | SCP0013_ProductionPlanLine.cs:2477 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (!Get_IsSaveYn()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d424e862 | SaveButton | SCP0013_ProductionPlanLine.cs:2483 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("A", typeof(char)) | 데이터 객체 조작/조회 |  |  |  |
| AC-5922969c | SaveButton | SCP0013_ProductionPlanLine.cs:2484 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_active_flag") | 데이터 객체 조작/조회 |  |  |  |
| AC-36f5b40e | SaveButton | SCP0013_ProductionPlanLine.cs:2485 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_division_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-bc898d44 | SaveButton | SCP0013_ProductionPlanLine.cs:2486 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_plan_start_yyyymmdd") | 데이터 객체 조작/조회 |  |  |  |
| AC-4ed220c8 | SaveButton | SCP0013_ProductionPlanLine.cs:2487 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_plan_type") | 데이터 객체 조작/조회 |  |  |  |
| AC-0cf501c3 | SaveButton | SCP0013_ProductionPlanLine.cs:2488 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_seq") | 데이터 객체 조작/조회 |  |  |  |
| AC-b989fd5e | SaveButton | SCP0013_ProductionPlanLine.cs:2489 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_operation_group") | 데이터 객체 조작/조회 |  |  |  |
| AC-c6ccc43a | SaveButton | SCP0013_ProductionPlanLine.cs:2490 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_scm_site_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-d46d50b8 | SaveButton | SCP0013_ProductionPlanLine.cs:2491 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_item_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-e1b8ae85 | SaveButton | SCP0013_ProductionPlanLine.cs:2492 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_line_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-1d94052b | SaveButton | SCP0013_ProductionPlanLine.cs:2493 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_operation_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-81b596e0 | SaveButton | SCP0013_ProductionPlanLine.cs:2494 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_measure") | 데이터 객체 조작/조회 |  |  |  |
| AC-8a6d674d | SaveButton | SCP0013_ProductionPlanLine.cs:2495 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_yyyymmdd") | 데이터 객체 조작/조회 |  |  |  |
| AC-a9a35aa1 | SaveButton | SCP0013_ProductionPlanLine.cs:2496 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_qty") | 데이터 객체 조작/조회 |  |  |  |
| AC-04e5d142 | SaveButton | SCP0013_ProductionPlanLine.cs:2497 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_fix_reason") | 데이터 객체 조작/조회 |  |  |  |
| AC-8b7d435f | SaveButton | SCP0013_ProductionPlanLine.cs:2498 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_user_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-76f88c52 | SaveButton | SCP0013_ProductionPlanLine.cs:2499 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_fix") | 데이터 객체 조작/조회 |  |  |  |
| AC-7581bb8c | SaveButton | SCP0013_ProductionPlanLine.cs:2500 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_loc_flag") | 데이터 객체 조작/조회 |  |  |  |
| AC-b52a3b2e | SaveButton | SCP0013_ProductionPlanLine.cs:2501 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_program_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-b8c05e0e | SaveButton | SCP0013_ProductionPlanLine.cs:2502 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("debug_mode") | 데이터 객체 조작/조회 |  |  |  |
| AC-e20e883a | SaveButton | SCP0013_ProductionPlanLine.cs:2503 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_origin_division_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-8729c92a | SaveButton | SCP0013_ProductionPlanLine.cs:2504 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_electrode_type") | 데이터 객체 조작/조회 |  |  |  |
| AC-023fcc44 | SaveButton | SCP0013_ProductionPlanLine.cs:2505 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_bucket_type") | 데이터 객체 조작/조회 |  |  |  |
| AC-b840d530 | SaveButton | SCP0013_ProductionPlanLine.cs:2506 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_from_yyyymmdd") | 데이터 객체 조작/조회 |  |  |  |
| AC-e28fb0f1 | SaveButton | SCP0013_ProductionPlanLine.cs:2507 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_to_yyyymmdd") | 데이터 객체 조작/조회 |  |  |  |
| AC-2801560e | SaveButton | SCP0013_ProductionPlanLine.cs:2509 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dsInput.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-a22428e0 | SaveButton | SCP0013_ProductionPlanLine.cs:2547 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | GRID_STYLE | siMain.SetBGColor | (i, j, i, j, ControlColor.InvalidColor) | 그리드 표시 설정 |  |  |  |
| AC-8caed2c5 | SaveButton | SCP0013_ProductionPlanLine.cs:2548 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | MESSAGE | MessageHelper.GMessageBox | ("MSG00084", new object[] { null }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f845fb37 | SaveButton | SCP0013_ProductionPlanLine.cs:2549 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b8c6d79c | SaveButton | SCP0013_ProductionPlanLine.cs:2553 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | GRID_STYLE | siMain.SetBGColor | (i, j, i, j, ControlColor.InvalidColor) | 그리드 표시 설정 |  |  |  |
| AC-5921c82b | SaveButton | SCP0013_ProductionPlanLine.cs:2555 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | MESSAGE | MessageHelper.GMessageBox | ("MSG00317", new object[] { message }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-2d5de24b | SaveButton | SCP0013_ProductionPlanLine.cs:2556 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-58545d63 | SaveButton | SCP0013_ProductionPlanLine.cs:2563 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dsInput.Tables[0].NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-ea4eea52 | SaveButton | SCP0013_ProductionPlanLine.cs:2565 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["A"] | action | 행/컬럼 값 대입 |  |  |  |
| AC-b030222c | SaveButton | SCP0013_ProductionPlanLine.cs:2566 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_active_flag"] | action | 행/컬럼 값 대입 |  |  |  |
| AC-e7d3d85a | SaveButton | SCP0013_ProductionPlanLine.cs:2567 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-b94a1711 | SaveButton | SCP0013_ProductionPlanLine.cs:2568 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-9a5987ee | SaveButton | SCP0013_ProductionPlanLine.cs:2569 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-0cf0b8e5 | SaveButton | SCP0013_ProductionPlanLine.cs:2570 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-a076a18a | SaveButton | SCP0013_ProductionPlanLine.cs:2571 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_operation_group"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.OPERATION_GROUP)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-0d09d0b8 | SaveButton | SCP0013_ProductionPlanLine.cs:2572 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_scm_site_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-6331d724 | SaveButton | SCP0013_ProductionPlanLine.cs:2573 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_item_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ITEM_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-a6e9b2cb | SaveButton | SCP0013_ProductionPlanLine.cs:2574 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_line_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.LINE_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-258a2756 | SaveButton | SCP0013_ProductionPlanLine.cs:2575 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_operation_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.OPERATION_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-9e8f5d48 | SaveButton | SCP0013_ProductionPlanLine.cs:2576 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_measure"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.MEASURE)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-d682e3b3 | SaveButton | SCP0013_ProductionPlanLine.cs:2577 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_origin_division_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ORIGIN_DIVISION_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-a85943e4 | SaveButton | SCP0013_ProductionPlanLine.cs:2578 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_electrode_type"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ELECTRODE_TYPE)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-f2e4d9d1 | SaveButton | SCP0013_ProductionPlanLine.cs:2579 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_yyyymmdd"] | strDayName | 행/컬럼 값 대입 |  |  |  |
| AC-34c5c485 | SaveButton | SCP0013_ProductionPlanLine.cs:2580 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_qty"] | strDayQty | 행/컬럼 값 대입 |  |  |  |
| AC-b7526178 | SaveButton | SCP0013_ProductionPlanLine.cs:2581 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_fix"] | isFix | 행/컬럼 값 대입 |  |  |  |
| AC-d93bd3f6 | SaveButton | SCP0013_ProductionPlanLine.cs:2582 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_loc_flag"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-f5d80bb8 | SaveButton | SCP0013_ProductionPlanLine.cs:2583 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-6edf8ab1 | SaveButton | SCP0013_ProductionPlanLine.cs:2584 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_bucket_type"] | BucketType.Daily | 행/컬럼 값 대입 |  |  |  |
| AC-c0ada77c | SaveButton | SCP0013_ProductionPlanLine.cs:2585 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-574b3ad7 | SaveButton | SCP0013_ProductionPlanLine.cs:2586 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-37f1c164 | SaveButton | SCP0013_ProductionPlanLine.cs:2587 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_program_id"] | "SCP0013" | 행/컬럼 값 대입 |  |  |  |
| AC-b0699162 | SaveButton | SCP0013_ProductionPlanLine.cs:2588 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-0790cbae | SaveButton | SCP0013_ProductionPlanLine.cs:2591 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dsInput.Tables[0].Rows.Add | (dr) | 데이터 객체 조작/조회 |  |  |  |
| AC-784f13c8 | SaveButton | SCP0013_ProductionPlanLine.cs:2622 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | GRID_STYLE | siMain.SetBGColor | (i, j, i, j, ControlColor.InvalidColor) | 그리드 표시 설정 |  |  |  |
| AC-e57e6eb5 | SaveButton | SCP0013_ProductionPlanLine.cs:2623 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | MESSAGE | MessageHelper.GMessageBox | ("MSG00084", new object[] { null }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b745fb5c | SaveButton | SCP0013_ProductionPlanLine.cs:2624 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b876c86a | SaveButton | SCP0013_ProductionPlanLine.cs:2628 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | GRID_STYLE | siMain.SetBGColor | (i, j, i, j, ControlColor.InvalidColor) | 그리드 표시 설정 |  |  |  |
| AC-ce23049c | SaveButton | SCP0013_ProductionPlanLine.cs:2630 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | MESSAGE | MessageHelper.GMessageBox | ("MSG00317", new object[] { message }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ca5cd6b8 | SaveButton | SCP0013_ProductionPlanLine.cs:2631 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-fecb3a8b | SaveButton | SCP0013_ProductionPlanLine.cs:2635 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dsInput.Tables[0].NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-3e758745 | SaveButton | SCP0013_ProductionPlanLine.cs:2637 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["A"] | action | 행/컬럼 값 대입 |  |  |  |
| AC-269277e1 | SaveButton | SCP0013_ProductionPlanLine.cs:2638 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_active_flag"] | action | 행/컬럼 값 대입 |  |  |  |
| AC-59ec0077 | SaveButton | SCP0013_ProductionPlanLine.cs:2639 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-81c3a47e | SaveButton | SCP0013_ProductionPlanLine.cs:2640 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-187b8870 | SaveButton | SCP0013_ProductionPlanLine.cs:2641 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-eb1fd289 | SaveButton | SCP0013_ProductionPlanLine.cs:2642 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-fcb7196a | SaveButton | SCP0013_ProductionPlanLine.cs:2643 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_operation_group"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.OPERATION_GROUP)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-f2245af0 | SaveButton | SCP0013_ProductionPlanLine.cs:2644 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_scm_site_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-356b65d1 | SaveButton | SCP0013_ProductionPlanLine.cs:2645 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_item_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ITEM_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-7436780f | SaveButton | SCP0013_ProductionPlanLine.cs:2646 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_line_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.LINE_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-6982cc19 | SaveButton | SCP0013_ProductionPlanLine.cs:2647 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_operation_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.OPERATION_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-e5cfd113 | SaveButton | SCP0013_ProductionPlanLine.cs:2648 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_measure"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.MEASURE)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-6146f296 | SaveButton | SCP0013_ProductionPlanLine.cs:2649 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_origin_division_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ORIGIN_DIVISION_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-a13af6c1 | SaveButton | SCP0013_ProductionPlanLine.cs:2650 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_electrode_type"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ELECTRODE_TYPE)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-ff8fa0cf | SaveButton | SCP0013_ProductionPlanLine.cs:2651 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_yyyymmdd"] | strWeekName | 행/컬럼 값 대입 |  |  |  |
| AC-a64376da | SaveButton | SCP0013_ProductionPlanLine.cs:2652 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_qty"] | strWeekQty | 행/컬럼 값 대입 |  |  |  |
| AC-8e3c954f | SaveButton | SCP0013_ProductionPlanLine.cs:2653 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_fix"] | isFix | 행/컬럼 값 대입 |  |  |  |
| AC-5674b310 | SaveButton | SCP0013_ProductionPlanLine.cs:2654 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_loc_flag"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-63e07ba2 | SaveButton | SCP0013_ProductionPlanLine.cs:2655 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-b5cd3b20 | SaveButton | SCP0013_ProductionPlanLine.cs:2656 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_bucket_type"] | BucketType.Weekly | 행/컬럼 값 대입 |  |  |  |
| AC-9ad7ae30 | SaveButton | SCP0013_ProductionPlanLine.cs:2657 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-305a4a13 | SaveButton | SCP0013_ProductionPlanLine.cs:2658 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-f4b9b8e3 | SaveButton | SCP0013_ProductionPlanLine.cs:2659 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_program_id"] | "SCP0013" | 행/컬럼 값 대입 |  |  |  |
| AC-20d5fb2e | SaveButton | SCP0013_ProductionPlanLine.cs:2660 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-f2199225 | SaveButton | SCP0013_ProductionPlanLine.cs:2663 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dsInput.Tables[0].Rows.Add | (dr) | 데이터 객체 조작/조회 |  |  |  |
| AC-24e0d5ad | SaveButton | SCP0013_ProductionPlanLine.cs:2675 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | GRID_SET | dsInput.Tables[0].Rows[0]["p_loc_flag"] | "F" | 그리드 속성/값 설정 |  |  |  |
| AC-58d77d16 | SaveButton | SCP0013_ProductionPlanLine.cs:2676 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | GRID_SET | dsInput.Tables[0].Rows[nRowCnt - 1]["p_loc_flag"] | "L" | 그리드 속성/값 설정 |  |  |  |
| AC-f027bea0 | SaveButton | SCP0013_ProductionPlanLine.cs:2678 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dsInput.Tables[0].AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-85dfa762 | SaveButton | SCP0013_ProductionPlanLine.cs:2687 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-fac1b133 | SaveButton | SCP0013_ProductionPlanLine.cs:2698 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | CALL_EXT | sql.AddParameter | ("@SCP0013", dsInput.Tables[0]) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e91f6edf | SaveButton | SCP0013_ProductionPlanLine.cs:2699 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | ENDPOINT | sql.ExcuteProcedure | ("SaveProductionPlanLine") ⇒ biz:AppService.GeneralRunProcedureCustomTable [procedure=SaveProductionPlanLine]… | 엔드포인트 호출 |  |  |  |
| AC-e6c83595 | SaveButton | SCP0013_ProductionPlanLine.cs:2702 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-4d60a5cd | SaveButton | SCP0013_ProductionPlanLine.cs:2707 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (result != n… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { iCount }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ed0445a0 | SaveButton | SCP0013_ProductionPlanLine.cs:2716 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ else of (result… | MESSAGE | MessageHelper.GMessageBox | ("MSG00003", new object[] { ReErrorMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a3b3e0f6 | SaveButton | SCP0013_ProductionPlanLine.cs:2725 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ catch ((Exception ex)… | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-86827196 | SaveButton | SCP0013_ProductionPlanLine.cs:2727 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ catch ((Exception ex)… | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f3b901fc | SaveButton | SCP0013_ProductionPlanLine.cs:2733 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ finally ▸ if (!prgClo… | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-64f1412a | SaveButton | SCP0013_ProductionPlanLine.cs:2816 | catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-72847ae7 | SaveButton | SCP0013_ProductionPlanLine.cs:2818 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a5df651d | SaveButton | SCP0013_ProductionPlanLine.cs:2822 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-02f6c09c | SaveButton | SCP0013_ProductionPlanLine.cs:2824 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## SCP0013_ProductionPlanLine.SCM_SYS_LOG_BATCH

진입점: this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName)) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try] / this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName)) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try] / SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a4fcbd0a | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 2 | SCP0013_ProductionPlanLine.cs:3693 | try | ENDPOINT | new FoxDataRequest | ("SCP.PR_SCM_SYS_LOG_BATCH") ⇒ SCP.PR_SCM_SYS_LOG_BATCH | 엔드포인트 요청 생성 |  |  |  |
| AC-b214807f | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 2 | SCP0013_ProductionPlanLine.cs:3694 | try | DATA_OP | request.Parameters["p_program_name"] | p_program_name | 행/컬럼 값 대입 |  |  |  |
| AC-a8b48565 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 2 | SCP0013_ProductionPlanLine.cs:3695 | try | DATA_OP | request.Parameters["p_log_type"] | p_log_type | 행/컬럼 값 대입 |  |  |  |
| AC-6f615266 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 2 | SCP0013_ProductionPlanLine.cs:3696 | try | DATA_OP | request.Parameters["p_log_count"] | p_log_count | 행/컬럼 값 대입 |  |  |  |
| AC-6397c2a9 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 2 | SCP0013_ProductionPlanLine.cs:3697 | try | DATA_OP | request.Parameters["p_log_message"] | p_log_message | 행/컬럼 값 대입 |  |  |  |
| AC-ccb47196 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 2 | SCP0013_ProductionPlanLine.cs:3698 | try | DATA_OP | request.Parameters["p_description"] | p_description | 행/컬럼 값 대입 |  |  |  |
| AC-34c84fa4 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 2 | SCP0013_ProductionPlanLine.cs:3699 | try | DATA_OP | request.Parameters["p_event_date"] | DateTime.Now | 행/컬럼 값 대입 |  |  |  |
| AC-5e65b77a | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 2 | SCP0013_ProductionPlanLine.cs:3701 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## SCP0013_ProductionPlanLine.Set_FixButtonEnabled

진입점: cboPlanDate.SelectedIndexChanged / cboPlanType.SelectedIndexChanged / cboPlanSeq.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3c8411c4 | cboPlanDate.SelectedIndexChanged 외 2 | SCP0013_ProductionPlanLine.cs:4012 | if (!string.IsNullOrEmpty(strPlanDate) && !string.IsNullOrEmpty(strPlanType) && !string.IsNullOrEmpty(strPlanSeq) && nPlanDa…) | STATE | btnFix.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-51663132 | cboPlanDate.SelectedIndexChanged 외 2 | SCP0013_ProductionPlanLine.cs:4013 | if (!string.IsNullOrEmpty(strPlanDate) && !string.IsNullOrEmpty(strPlanType) && !string.IsNullOrEmpty(strPlanSeq) && nPlanDa…) | STATE | btnUnfix.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-d3637714 | cboPlanDate.SelectedIndexChanged 외 2 | SCP0013_ProductionPlanLine.cs:4014 | if (!string.IsNullOrEmpty(strPlanDate) && !string.IsNullOrEmpty(strPlanType) && !string.IsNullOrEmpty(strPlanSeq) && nPlanDa…) | STATE | btnNew.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-96dc73f9 | cboPlanDate.SelectedIndexChanged 외 2 | SCP0013_ProductionPlanLine.cs:4018 | else of (!string.IsNullOrEmpty(strPlanDate) && !string.IsNullOrEmpty(strPlanType) && !string.IsNullOrEmpty(strPlanSeq) && nPlanDa…) | STATE | btnFix.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-8b4ae5eb | cboPlanDate.SelectedIndexChanged 외 2 | SCP0013_ProductionPlanLine.cs:4019 | else of (!string.IsNullOrEmpty(strPlanDate) && !string.IsNullOrEmpty(strPlanType) && !string.IsNullOrEmpty(strPlanSeq) && nPlanDa…) | STATE | btnUnfix.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-4e98d2e6 | cboPlanDate.SelectedIndexChanged 외 2 | SCP0013_ProductionPlanLine.cs:4020 | else of (!string.IsNullOrEmpty(strPlanDate) && !string.IsNullOrEmpty(strPlanType) && !string.IsNullOrEmpty(strPlanSeq) && nPlanDa…) | STATE | btnNew.Enabled | false | 컨트롤 상태 Enabled |  |  |  |

## SCP0013_ProductionPlanLine.Set_FixCellColor

진입점: this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName)) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Equals("S")) ▸ try ▸ if (dsBinding.Tables.Count > 0)] / this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName)) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Eq…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e55f1786 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 5 | SCP0013_ProductionPlanLine.cs:3597 | foreach (DataRow row in dtFix.Rows) | DATA_OP | row["FIX_KEY"] | sVal | 행/컬럼 값 대입 |  |  |  |
| AC-b09c556e | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 5 | SCP0013_ProductionPlanLine.cs:3611 | for (k < siMain.ActiveSheet.RowCount) ▸ if (dtFix.Rows.Count > 0 && spd_MEASURE == "PROD_PLAN_AMEND") | DATA_OP | dtFix.Select | ("FIX_KEY='" + spd_FIX_KEY + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-3657459b | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 5 | SCP0013_ProductionPlanLine.cs:3629 | for (k < siMain.ActiveSheet.RowCount) ▸ if (dtFix.Rows.Count > 0 && spd_MEASURE == "PROD_PLAN_AMEND") ▸ foreach (DataRow dr in dataRows) ▸ i… | GRID_STYLE | siMain.SetBGColor2 | (k, nCol, k, nCol, Color.FromArgb(188, 229, 92)) | 그리드 표시 설정 |  |  |  |
| AC-b6791ad7 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 5 | SCP0013_ProductionPlanLine.cs:3633 | for (k < siMain.ActiveSheet.RowCount) ▸ if (dtFix.Rows.Count > 0 && spd_MEASURE == "PROD_PLAN_AMEND") ▸ foreach (DataRow dr in dataRows) ▸ i… | GRID_STYLE | siMain.SetBGColor2 | (k, nColWeek, k, nColWeek, Color.FromArgb(188, 229, 92)) | 그리드 표시 설정 |  |  |  |
| AC-f286c732 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 5 | SCP0013_ProductionPlanLine.cs:3650 | for (k < siMain.ActiveSheet.RowCount) ▸ if (dtFix.Rows.Count > 0 && spd_MEASURE == "PROD_PLAN_AMEND") ▸ foreach (DataRow dr in dataRows) ▸ e… | GRID_STYLE | siMain.SetBGColor2 | (k, nColWeek, k, nColWeek, Color.FromArgb(188, 229, 92)) | 그리드 표시 설정 |  |  |  |
| AC-31812bd2 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 5 | SCP0013_ProductionPlanLine.cs:3672 | for (k < siMain.ActiveSheet.RowCount) ▸ if ((spd_MEASURE == "LINE_TOTAL_LOAD_AMEND" \|\| spd_MEASURE == "LINE_TOTAL_LOAD_ENGINE") && (p_buck… | GRID_STYLE | siMain.SetFGColor2 | (k, nCol, k, nCol, ControlColor.MarkedForeColor) | 그리드 표시 설정 |  |  |  |
| AC-6f105f2a | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 5 | SCP0013_ProductionPlanLine.cs:3677 | for (k < siMain.ActiveSheet.RowCount) | UI_MISC | spdMain.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## SCP0013_ProductionPlanLine.Set_FPOperationColor

진입점: this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName)) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Equals("S")) ▸ try ▸ if (dsBinding.Tables.Count > 0)] / this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName)) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Eq…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9481643e | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 5 | SCP0013_ProductionPlanLine.cs:3470 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-738b339a | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 5 | SCP0013_ProductionPlanLine.cs:3474 | if (fps.Name == "spdMain") ▸ if (siMain.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8f1c13d4 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 5 | SCP0013_ProductionPlanLine.cs:3475 | if (fps.Name == "spdMain") | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-e9a0398f | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 5 | SCP0013_ProductionPlanLine.cs:3486 | if (fps.Name == "spdMain") ▸ for (i < spdMain.ActiveSheet.RowCount) ▸ if (spdMain.ActiveSheet.GetText(i, siMain.GetColumnIndex(DefColumns.ME… | DATA_OP | dtIsEditInfo.Select | ("CP_KEY = '" + strCP_KEY + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-afc4f654 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 5 | SCP0013_ProductionPlanLine.cs:3520 | if (fps.Name == "spdMain") ▸ for (i < spdMain.ActiveSheet.RowCount) ▸ if (spdMain.ActiveSheet.GetText(i, siMain.GetColumnIndex(DefColumns.ME… | DATA_OP | dtPlanType.Select | ("CODE='FN'") | 데이터 객체 조작/조회 |  |  |  |
| AC-d465d4cd | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 5 | SCP0013_ProductionPlanLine.cs:3574 | if (fps.Name == "spdMain") ▸ for (i < spdMain.ActiveSheet.RowCount) ▸ if (spdMain.ActiveSheet.GetText(i, siMain.GetColumnIndex(DefColumns.ME… | GRID_STYLE | siMain.SetBGColor2 | (nEditableRow, nStartEditIdx, nEditableRow, siMain.ActiveSheet.ColumnCount - 1, Color.From… | 그리드 표시 설정 |  |  |  |
| AC-113414b5 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 5 | SCP0013_ProductionPlanLine.cs:3581 | if (fps.Name == "spdMain") | UI_MISC | spdMain.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## SCP0013_ProductionPlanLine.Set_ProductResult

진입점: this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName)) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Equals("S")) ▸ try ▸ if (dsBinding.Tables.Count > 0)] / this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName)) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Eq…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0c5d65ed | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 5 | SCP0013_ProductionPlanLine.cs:1143 | try ▸ if (int.Parse(p_from_yyyymmdd.ToString()) < int.Parse(p_plan_start_yyyymmdd.ToString()) && (p_bucket.Equals(BucketType.Daily…) ▸ if (r… | GRID_STYLE | siMain.SetBGColor2 | (0, siMain.nIdxData + 1, spdMain.ActiveSheet.RowCount - 1, resultIdx, Color.FromArgb(234, … | 그리드 표시 설정 |  |  |  |
| AC-98538d06 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 5 | SCP0013_ProductionPlanLine.cs:1149 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message) | 메시지 표시 |  |  |  |

## SCP0013_ProductionPlanLine.Set_Ratio

진입점: this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName)) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Equals("S")) ▸ try] / this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName)) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Equals("S")) ▸ try] / btnNew.Click […

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-82e44d46 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SCP0013_ProductionPlanLine.cs:2164 | if (dsBinding.Tables[2].Rows.Count > 0) ▸ foreach (DataRow row in dsBinding.Tables[2].Rows) ▸ foreach (DataColumn col in dsBinding.Tables[2]… | DATA_OP | columnName.Contains | ("W_") | 데이터 객체 조작/조회 |  |  |  |
| AC-fd616540 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SCP0013_ProductionPlanLine.cs:2186 | if (dsBinding.Tables[2].Rows.Count > 0) ▸ foreach (DataRow row in dsBinding.Tables[2].Rows) ▸ foreach (DataColumn col in dsBinding.Tables[2]… | DATA_OP | row2[columnName2] | "0" | 행/컬럼 값 대입 |  |  |  |
| AC-63ccc6fa | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SCP0013_ProductionPlanLine.cs:2190 | if (dsBinding.Tables[2].Rows.Count > 0) ▸ foreach (DataRow row in dsBinding.Tables[2].Rows) ▸ foreach (DataColumn col in dsBinding.Tables[2]… | DATA_OP | row2[columnName2] | row[columnName] | 행/컬럼 값 대입 |  |  |  |
| AC-7e54b5e4 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SCP0013_ProductionPlanLine.cs:2219 | if (dsBinding.Tables[3].Rows.Count > 0) ▸ foreach (DataRow row in dsBinding.Tables[3].Rows) ▸ foreach (DataColumn col in dsBinding.Tables[3]… | DATA_OP | columnName.Contains | ("M_") | 데이터 객체 조작/조회 |  |  |  |
| AC-1b3fd753 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SCP0013_ProductionPlanLine.cs:2241 | if (dsBinding.Tables[3].Rows.Count > 0) ▸ foreach (DataRow row in dsBinding.Tables[3].Rows) ▸ foreach (DataColumn col in dsBinding.Tables[3]… | DATA_OP | row2[columnName2] | "0" | 행/컬럼 값 대입 |  |  |  |
| AC-ce11011c | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SCP0013_ProductionPlanLine.cs:2245 | if (dsBinding.Tables[3].Rows.Count > 0) ▸ foreach (DataRow row in dsBinding.Tables[3].Rows) ▸ foreach (DataColumn col in dsBinding.Tables[3]… | DATA_OP | row2[columnName2] | row[columnName] | 행/컬럼 값 대입 |  |  |  |
| AC-772c3177 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SCP0013_ProductionPlanLine.cs:2258 |  | DATA_OP | dsBinding.Tables[0].AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |

## SCP0013_ProductionPlanLine.SetChangedControl

진입점: this.Load / cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-602c2c09 | this.Load 외 1 | SCP0013_ProductionPlanLine.cs:1775 | if (division.Substring(0, 2).Equals("EE")) | FLAG | dtOperationGroup | Data_SCP.Common(Data_SCP.Type.OperationGroupEE, false) | 화면 필드/플래그 변경 |  |  |  |
| AC-493a787d | this.Load 외 1 | SCP0013_ProductionPlanLine.cs:1775 | if (division.Substring(0, 2).Equals("EE")) | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.OperationGroupEE, false) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-67c1a0e6 | this.Load 외 1 | SCP0013_ProductionPlanLine.cs:1777 | else of (division.Substring(0, 2).Equals("EE")) | FLAG | dtOperationGroup | Data_SCP.Common(Data_SCP.Type.OperationGroup, false) | 화면 필드/플래그 변경 |  |  |  |
| AC-31962db7 | this.Load 외 1 | SCP0013_ProductionPlanLine.cs:1777 | else of (division.Substring(0, 2).Equals("EE")) | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.OperationGroup, false) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-3b9c6231 | this.Load 외 1 | SCP0013_ProductionPlanLine.cs:1778 |  | LIST_REBIND | clsCtrl.setListBox | (dtOperationGroup, cboOperationGroup, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-edd46856 | this.Load 외 1 | SCP0013_ProductionPlanLine.cs:1787 | if (division == "40") | STATE | this.lcCellTypeGr.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-3dce60b3 | this.Load 외 1 | SCP0013_ProductionPlanLine.cs:1790 | if (division == "40") | STATE | this.lcExtraSpec.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-924c2b50 | this.Load 외 1 | SCP0013_ProductionPlanLine.cs:1795 | else of (division == "40") | STATE | this.lcCellTypeGr.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-2a4db962 | this.Load 외 1 | SCP0013_ProductionPlanLine.cs:1796 | else of (division == "40") | CALL_EXT | cboCellTypeGr.SetAllCheckItem | (false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-84f55dbe | this.Load 외 1 | SCP0013_ProductionPlanLine.cs:1799 | else of (division == "40") | STATE | this.lcExtraSpec.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-ec1c2376 | this.Load 외 1 | SCP0013_ProductionPlanLine.cs:1800 | else of (division == "40") | CALL_EXT | clbExtraSpec.SetAllCheckItem | (false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b99b7553 | this.Load 외 1 | SCP0013_ProductionPlanLine.cs:1809 | if ((dtPlanType.Rows.Count > 0) && (cboPlanType.Items.Count > 0)) | VALUE_SET | cboPlanType.SelectedIndex | dtPlanType.Rows.Count - 1 | 컨트롤 값 설정 |  |  |  |

## SCP0013_ProductionPlanLine.SetChangedControlPart

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-077b8b0e | (진입점 미연결) | SCP0013_ProductionPlanLine.cs:1897 |  | FLAG | dtPlantSiteByDivision | Data_SCP.Common(Data_SCP.Type.PlantSiteProdPlan, false, division, pOperationGroup) | 화면 필드/플래그 변경 |  |  |  |
| AC-f50fdc58 | (진입점 미연결) | SCP0013_ProductionPlanLine.cs:1897 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.PlantSiteProdPlan, false, division, pOperationGroup) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c57db6c7 | (진입점 미연결) | SCP0013_ProductionPlanLine.cs:1898 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlantSiteByDivision, clbPlantSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-40b1276a | (진입점 미연결) | SCP0013_ProductionPlanLine.cs:1901 |  | FLAG | dtLine | Data_SCP.Common(Data_SCP.Type.LineProdPlanLine, false, division, pOperationGroup, pPlantSi… | 화면 필드/플래그 변경 |  |  |  |
| AC-8acadca7 | (진입점 미연결) | SCP0013_ProductionPlanLine.cs:1901 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.LineProdPlanLine, false, division, pOperationGroup, pPlantSite) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-7479814a | (진입점 미연결) | SCP0013_ProductionPlanLine.cs:1902 |  | LIST_REBIND | clsCtrl.setListBox | (dtLine, clbLine, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0013_ProductionPlanLine.SetColumnModelVisible

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e0dcfc42 | (진입점 미연결) | SCP0013_ProductionPlanLine.cs:3905 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-a0d51e26 | (진입점 미연결) | SCP0013_ProductionPlanLine.cs:3906 |  | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-620ff3c0 | (진입점 미연결) | SCP0013_ProductionPlanLine.cs:3916 | try ▸ switch (pOperationGroup) case "A": | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-2d207b83 | (진입점 미연결) | SCP0013_ProductionPlanLine.cs:3919 | try ▸ switch (pOperationGroup) case "P": | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-f68906ac | (진입점 미연결) | SCP0013_ProductionPlanLine.cs:3927 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0013_ProductionPlanLine.SetElectrodeEnable

진입점: this.Load / cboOperationGroup.SelectedIndexChanged / cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1536c2c7 | this.Load 외 2 | SCP0013_ProductionPlanLine.cs:3893 | if (pOperationGroup == "A" \|\| pOperationGroup == "P") | VALUE_SET | cboElectrode.ControlValues | "ALL" | 컨트롤 값 설정 |  |  |  |
| AC-131c97b7 | this.Load 외 2 | SCP0013_ProductionPlanLine.cs:3894 | if (pOperationGroup == "A" \|\| pOperationGroup == "P") | STATE | cboElectrode.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-638d135f | this.Load 외 2 | SCP0013_ProductionPlanLine.cs:3898 | else of (pOperationGroup == "A" \|\| pOperationGroup == "P") | STATE | cboElectrode.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## SCP0013_ProductionPlanLine.SetFormationYield

진입점: this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName)) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Equals("S")) ▸ try] / this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName)) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Equals("S")) ▸ try] / btnNew.Click […

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8f978fba | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SCP0013_ProductionPlanLine.cs:3742 | for (nRow < dt.Rows.Count) ▸ if (strMeasure.Equals("LINE_TOTAL_LOAD_ENGINE") \|\| strMeasure.Equals("LINE_TOTAL_LOAD_AMEND")) | CALL_EXT | siMain.SetDecimal | (nRow, nIdxStart, nRow, nIdxEnd, 2, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-7cf37c34 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SCP0013_ProductionPlanLine.cs:3746 |  | DATA_OP | dt.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |

## SCP0013_ProductionPlanLine.SetLockSumColumn

진입점: this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName)) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Equals("S")) ▸ try ▸ if (dsBinding.Tables.Count > 0)] / this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName)) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Eq…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3f8a38d8 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 5 | SCP0013_ProductionPlanLine.cs:1168 | for (iCol < spreadInfo.ActiveSheet.ColumnCount) ▸ if (cboBucketType.ControlValues == BucketType.Daily) ▸ if (spreadInfo.GetColumnTag(iCol).I… | GRID_LOCK | spreadInfo.LockRange | (0, iCol, spreadInfo.ActiveSheet.RowCount - 1, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-7b8a9e90 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 5 | SCP0013_ProductionPlanLine.cs:1180 | for (iCol < spreadInfo.ActiveSheet.ColumnCount) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (spreadInfo.GetColumnTag(iC… | GRID_LOCK | spreadInfo.LockRange | (0, iCol, spreadInfo.ActiveSheet.RowCount - 1, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |

## SCP0013_ProductionPlanLine.SetSpreadColumn

진입점: this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName)) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Equals("S")) ▸ try ▸ if (siMain.GetMaxRowIndex() > 0)] / this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName)) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().E…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-935ab514 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 14 | SCP0013_ProductionPlanLine.cs:1220 | for (iCol < siObj.ActiveSheet.ColumnCount) ▸ if (cboBucketType.ControlValues == BucketType.Daily) ▸ if (siObj.GetColumnTag(iCol).IndexOf("D_… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-8d5afb08 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 14 | SCP0013_ProductionPlanLine.cs:1225 | for (iCol < siObj.ActiveSheet.ColumnCount) ▸ if (cboBucketType.ControlValues == BucketType.Daily) ▸ if (siObj.GetColumnTag(iCol).IndexOf("M_… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | chkSum.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-9d53b708 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 14 | SCP0013_ProductionPlanLine.cs:1232 | for (iCol < siObj.ActiveSheet.ColumnCount) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == … | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-554bf8d9 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 14 | SCP0013_ProductionPlanLine.cs:1236 | for (iCol < siObj.ActiveSheet.ColumnCount) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == … | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-a2fb5910 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 14 | SCP0013_ProductionPlanLine.cs:1241 | for (iCol < siObj.ActiveSheet.ColumnCount) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == … | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | chkSum.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-30aa066a | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 14 | SCP0013_ProductionPlanLine.cs:1248 | for (iCol < siObj.ActiveSheet.ColumnCount) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ else of (cboBucketType.ControlValue… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-74bf441e | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 14 | SCP0013_ProductionPlanLine.cs:1252 | for (iCol < siObj.ActiveSheet.ColumnCount) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ else of (cboBucketType.ControlValue… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |

## SCP0013_ProductionPlanLine.SpdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-92a016df | this.spdMain.CellClick | SCP0013_ProductionPlanLine.cs:614 | if (spdMain.ActiveSheet.ActiveRowIndex > 0) | FLAG | this.nSelRowOfMain | spdMain.ActiveSheet.ActiveRowIndex | 화면 필드/플래그 변경 |  |  |  |
| AC-5d50e9f1 | this.spdMain.CellClick | SCP0013_ProductionPlanLine.cs:615 | if (spdMain.ActiveSheet.ActiveRowIndex > 0) | FLAG | this.nSelColOfMain | spdMain.ActiveSheet.ActiveColumnIndex | 화면 필드/플래그 변경 |  |  |  |

## SCP0013_ProductionPlanLine.SpdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dceddc58 | this.spdMain.CellDoubleClick | SCP0013_ProductionPlanLine.cs:4041 | if (!chkAll.Checked) ▸ if ((siMain.GetColumnTag(e.Column).IndexOf("M_") == 0 && BucketType.Monthly == sBucketType) \|\| (siMain.GetColumnTag… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d3b5edb6 | this.spdMain.CellDoubleClick | SCP0013_ProductionPlanLine.cs:4044 |  | CALL_EXT | siMain.SetDblClickColumnShowHide | (sender, e) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3a527c4b | this.spdMain.CellDoubleClick | SCP0013_ProductionPlanLine.cs:4048 | if (!e.ColumnHeader && e.Row >= 0) | FLAG | nSelRowOfMain | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-0197b1a6 | this.spdMain.CellDoubleClick | SCP0013_ProductionPlanLine.cs:4049 | if (!e.ColumnHeader && e.Row >= 0) | FLAG | nSelColOfMain | e.Column | 화면 필드/플래그 변경 |  |  |  |

## SCP0013_ProductionPlanLine.SpdMain_Changed

진입점: dsdmLine.Changed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-93638adf | dsdmLine.Changed | SCP0013_ProductionPlanLine.cs:3785 | if (!this.CanModelChange \|\| e.Row == -1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9fbcabbe | dsdmLine.Changed | SCP0013_ProductionPlanLine.cs:3786 | if (cellclipboardPast) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-92b70678 | dsdmLine.Changed | SCP0013_ProductionPlanLine.cs:3793 | if (ds == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4f2cd837 | dsdmLine.Changed | SCP0013_ProductionPlanLine.cs:3803 | if (strColName == "Action") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5200300c | dsdmLine.Changed | SCP0013_ProductionPlanLine.cs:3809 | try ▸ if (ds == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1cb53506 | dsdmLine.Changed | SCP0013_ProductionPlanLine.cs:3841 | catch ((Exception et)) | THROW | throw et; |  | 예외 발생 |  |  |  |
| AC-c384b648 | dsdmLine.Changed | SCP0013_ProductionPlanLine.cs:3845 | finally | DATA_OP | dt.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |

## SCP0013_ProductionPlanLine.SpdMain_ClipboardPasted

진입점: this.spdMain.ClipboardPasted

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a45c6e6e | this.spdMain.ClipboardPasted | SCP0013_ProductionPlanLine.cs:544 | if (siMain.Sheet().Rows.Count <= 0 \|\| siMain.IsLock(siMain.SheetName) == true) | FLAG | cellclipboardPast | false | 화면 필드/플래그 변경 |  |  |  |
| AC-038cae7a | this.spdMain.ClipboardPasted | SCP0013_ProductionPlanLine.cs:545 | if (siMain.Sheet().Rows.Count <= 0 \|\| siMain.IsLock(siMain.SheetName) == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-216a351a | this.spdMain.ClipboardPasted | SCP0013_ProductionPlanLine.cs:581 | try ▸ for (iRow < e.CellRange.Row + e.CellRange.RowCount) ▸ if (measure.Equals("PROD_PLAN_AMEND")) ▸ if (ds == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0e8cec2b | this.spdMain.ClipboardPasted | SCP0013_ProductionPlanLine.cs:593 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-04e7443e | this.spdMain.ClipboardPasted | SCP0013_ProductionPlanLine.cs:594 | catch ((Exception ex)) | FLAG | cellclipboardPast | false | 화면 필드/플래그 변경 |  |  |  |
| AC-134fe5a5 | this.spdMain.ClipboardPasted | SCP0013_ProductionPlanLine.cs:598 | finally | FLAG | cellclipboardPast | false | 화면 필드/플래그 변경 |  |  |  |
| AC-55ab00a0 | this.spdMain.ClipboardPasted | SCP0013_ProductionPlanLine.cs:600 |  | FLAG | cellclipboardPast | false | 화면 필드/플래그 변경 |  |  |  |

## SCP0013_ProductionPlanLine.SpdMain_ClipboardPasting

진입점: this.spdMain.ClipboardPasting

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-49a2a8d7 | this.spdMain.ClipboardPasting | SCP0013_ProductionPlanLine.cs:607 |  | FLAG | cellclipboardPast | true | 화면 필드/플래그 변경 |  |  |  |

## SCP0013_ProductionPlanLine.SpdMain_TopChange

진입점: this.spdMain.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-006f81ae | this.spdMain.TopChange | SCP0013_ProductionPlanLine.cs:622 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0013_ProductionPlanLineLoadPopup.btnButtonList_UsrButtonList_Click_Detected

진입점: this.btnButtonList.UsrButtonList_Click_Detected

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d98c8a45 | this.btnButtonList.UsrButtonList_Click_Detected | SCP0013_ProductionPlanLineLoadPopup.cs:188 | switch (buttonItem.UserType) case ButtonListType.Close: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## SCP0013_ProductionPlanLineLoadPopup.CalculateSum

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-28b97cbc | (진입점 미연결) | SCP0013_ProductionPlanLineLoadPopup.cs:437 | for (nCol < dt.Columns.Count) ▸ if (dt.Columns[nCol].ColumnName.IndexOf("M_") == 0) | DATA_OP | listMonth.Add | (nCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-96d8f4d5 | (진입점 미연결) | SCP0013_ProductionPlanLineLoadPopup.cs:441 | for (nCol < dt.Columns.Count) ▸ if (dt.Columns[nCol].ColumnName.IndexOf("W_") == 0) | DATA_OP | listWeek.Add | (nCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-1128c0e5 | (진입점 미연결) | SCP0013_ProductionPlanLineLoadPopup.cs:494 | for (nRow < dt.Rows.Count) ▸ for (nCol < dt.Columns.Count) ▸ if (nCol == dt.Columns.Count - 1 \|\| dt.Columns[nCol].ColumnName.IndexOf("W_")… | DATA_OP | dr[nIdxWeek] | weekSum / nCntDayOfWeek | 행/컬럼 값 대입 |  |  |  |
| AC-9ca8889b | (진입점 미연결) | SCP0013_ProductionPlanLineLoadPopup.cs:504 | for (nRow < dt.Rows.Count) ▸ for (nCol < dt.Columns.Count) ▸ if (nCol == dt.Columns.Count - 1 \|\| dt.Columns[nCol].ColumnName.IndexOf("M_")… | DATA_OP | dr[nIdxMonth] | monthSum / nCntDayOfMonth | 행/컬럼 값 대입 |  |  |  |
| AC-c20774f0 | (진입점 미연결) | SCP0013_ProductionPlanLineLoadPopup.cs:512 |  | DATA_OP | dt.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |

## SCP0013_ProductionPlanLineLoadPopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c0fb78d7 | this.Load | SCP0013_ProductionPlanLineLoadPopup.cs:142 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 3, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-9c09117c | this.Load | SCP0013_ProductionPlanLineLoadPopup.cs:143 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-5d346ca5 | this.Load | SCP0013_ProductionPlanLineLoadPopup.cs:144 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0013_ProductionPlanLineLoadPopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-204ddae9 | this.Load | SCP0013_ProductionPlanLineLoadPopup.cs:137 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## SCP0013_ProductionPlanLineLoadPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d7fb986b | Dispose | SCP0013_ProductionPlanLineLoadPopup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0013_ProductionPlanLineLoadPopup.FindDataMain

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find:] / this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-70ddf944 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0013_ProductionPlanLineLoadPopup.cs:236 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCM.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-9e0d20cd | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0013_ProductionPlanLineLoadPopup.cs:240 | lambda | ENDPOINT | new FoxDataRequest | ("SCM.SCP0013_PRODUCTION_PLAN_LINE_LOAD_POPUP") ⇒ SCM.SCP0013_PRODUCTION_PLAN_LINE_LOAD_POPUP | 엔드포인트 요청 생성 |  |  |  |
| AC-9db925b7 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0013_ProductionPlanLineLoadPopup.cs:241 | lambda | DATA_OP | request.Parameters["p_division_id"] | _pDivisionID | 행/컬럼 값 대입 |  |  |  |
| AC-cfb5483c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0013_ProductionPlanLineLoadPopup.cs:242 | lambda | DATA_OP | request.Parameters["p_operation_group"] | _pOperationGroup | 행/컬럼 값 대입 |  |  |  |
| AC-5e1f8548 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0013_ProductionPlanLineLoadPopup.cs:243 | lambda | DATA_OP | request.Parameters["p_scm_site_id"] | _pScmSiteId | 행/컬럼 값 대입 |  |  |  |
| AC-f83ba322 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0013_ProductionPlanLineLoadPopup.cs:244 | lambda | DATA_OP | request.Parameters["p_line_id"] | _pLineId | 행/컬럼 값 대입 |  |  |  |
| AC-0f7fc024 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0013_ProductionPlanLineLoadPopup.cs:245 | lambda | DATA_OP | request.Parameters["p_from_yyyymmdd"] | _pFromYYYYMMDD | 행/컬럼 값 대입 |  |  |  |
| AC-d74587a0 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0013_ProductionPlanLineLoadPopup.cs:246 | lambda | DATA_OP | request.Parameters["p_to_yyyymmdd"] | _pToYYYYMMDD | 행/컬럼 값 대입 |  |  |  |
| AC-a94c2a8d | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0013_ProductionPlanLineLoadPopup.cs:247 | lambda | DATA_OP | request.Parameters["p_plan_start_yyyymmdd"] | _pPlanStartYYYYMMDD | 행/컬럼 값 대입 |  |  |  |
| AC-3ac81348 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0013_ProductionPlanLineLoadPopup.cs:248 | lambda | DATA_OP | request.Parameters["p_plan_type"] | _pPlanType | 행/컬럼 값 대입 |  |  |  |
| AC-f87fa46d | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0013_ProductionPlanLineLoadPopup.cs:249 | lambda | DATA_OP | request.Parameters["p_seq"] | _pSeq | 행/컬럼 값 대입 |  |  |  |
| AC-94d02bd1 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0013_ProductionPlanLineLoadPopup.cs:250 | lambda | DATA_OP | request.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-a312b5ba | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0013_ProductionPlanLineLoadPopup.cs:251 | lambda | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-a0848d43 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0013_ProductionPlanLineLoadPopup.cs:253 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-88b77870 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0013_ProductionPlanLineLoadPopup.cs:255 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-01ab7f5c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0013_ProductionPlanLineLoadPopup.cs:264 |  | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-777cfc3a | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0013_ProductionPlanLineLoadPopup.cs:265 |  | GRID_LOCK | siMain.LockColumn | (1, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |

## SCP0013_ProductionPlanLineLoadPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c0182160 | this.Load | SCP0013_ProductionPlanLineLoadPopup.cs:104 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-dfece8e5 | this.Load | SCP0013_ProductionPlanLineLoadPopup.cs:105 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCP0013_ProductionPlanLineLoadPopup.GetSpdTitle

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find: ▸ if (spreadInfo.SheetName == SpdSheet.shtMain)] / this.Load [if (spreadInfo.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3a440640 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0013_ProductionPlanLineLoadPopup.cs:568 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN") ⇒ SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | 엔드포인트 요청 생성 |  |  |  |
| AC-6bda8b12 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0013_ProductionPlanLineLoadPopup.cs:571 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | _pFromYYYYMMDD.Replace("-", "") | 행/컬럼 값 대입 |  |  |  |
| AC-650cbade | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0013_ProductionPlanLineLoadPopup.cs:572 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | _pToYYYYMMDD.Replace("-", "") | 행/컬럼 값 대입 |  |  |  |
| AC-c84c94bd | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0013_ProductionPlanLineLoadPopup.cs:574 |  | FLAG | dsSpdTitle | client.ExecuteDataSet(request).DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-270a40a4 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0013_ProductionPlanLineLoadPopup.cs:574 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## SCP0013_ProductionPlanLineLoadPopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c4f98940 | this.Load | SCP0013_ProductionPlanLineLoadPopup.cs:130 |  | UI_PROP | this.baseInfoLbl.TextVisible | true | 속성 TextVisible 설정 |  |  |  |
| AC-1937c1a9 | this.Load | SCP0013_ProductionPlanLineLoadPopup.cs:131 |  | VALUE_SET | this.baseInfoLbl.Text | lblTxt | 컨트롤 값 설정 |  |  |  |

## SCP0013_ProductionPlanLineLoadPopup.InitSpread

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find:] / this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-56afedb3 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0013_ProductionPlanLineLoadPopup.cs:153 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.InitSheet | (spreadInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-6142a3d7 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0013_ProductionPlanLineLoadPopup.cs:154 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_SET | spreadInfo.ActiveSheet.DataSource | null | 그리드 속성/값 설정 |  |  |  |
| AC-00653e96 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0013_ProductionPlanLineLoadPopup.cs:157 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddComboColumn | ("Plant Site", DefColumns.SCM_SITE_ID, FPMerge.Restricted, 150, true, dtPlantSiteAll, FPHA… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b140eca3 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0013_ProductionPlanLineLoadPopup.cs:158 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Building", DefColumns.FACTORY_NAME, FPMerge.Restricted, 160, true, FPHAlign.Left, FPVAli… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-60994922 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0013_ProductionPlanLineLoadPopup.cs:159 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddComboColumn | ("Operation", DefColumns.OPERATION_ID, FPMerge.Restricted, 150, true, dtOperation, FPHAlig… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e706584a | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0013_ProductionPlanLineLoadPopup.cs:160 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Line", DefColumns.LINE_NAME, FPMerge.Restricted, 80, true, FPHAlign.Left, FPVAlign.Cente… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-fb865b87 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0013_ProductionPlanLineLoadPopup.cs:162 | if (spreadInfo.SheetName == SpdSheet.shtMain) | CALL_EXT | spreadInfo.ColumnHeaderSpanRow | (0, spreadInfo.GetColumnIndex(DefColumns.SCM_SITE_ID)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-592363af | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0013_ProductionPlanLineLoadPopup.cs:163 | if (spreadInfo.SheetName == SpdSheet.shtMain) | CALL_EXT | spreadInfo.ColumnHeaderSpanRow | (1, spreadInfo.GetColumnIndex(DefColumns.FACTORY_NAME)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-7e7a25d7 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0013_ProductionPlanLineLoadPopup.cs:164 | if (spreadInfo.SheetName == SpdSheet.shtMain) | CALL_EXT | spreadInfo.ColumnHeaderSpanRow | (2, spreadInfo.GetColumnIndex(DefColumns.OPERATION_ID)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f85c3de5 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0013_ProductionPlanLineLoadPopup.cs:165 | if (spreadInfo.SheetName == SpdSheet.shtMain) | CALL_EXT | spreadInfo.ColumnHeaderSpanRow | (3, spreadInfo.GetColumnIndex(DefColumns.LINE_NAME)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d13575e6 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0013_ProductionPlanLineLoadPopup.cs:174 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-77e01fd7 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0013_ProductionPlanLineLoadPopup.cs:175 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.VisibleTab | (false) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCP0013_ProductionPlanLineLoadPopup.InitSpreadDateColumn

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find: ▸ if (spreadInfo.SheetName == SpdSheet.shtMain)] / this.Load [if (spreadInfo.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9a523b8a | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0013_ProductionPlanLineLoadPopup.cs:321 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sColumnName.IndexOf("B_") > 0) | GRID_INIT | spdInfo.AddTextColumn | (sColumnLabelname, sColumnName, FPMerge.None, 0, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9a177e1a | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0013_ProductionPlanLineLoadPopup.cs:325 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sColumnName.IndexOf("B_") > 0) | GRID_INIT | spdInfo.AddNumColumn | (sColumnLabelname, sColumnName, FPMerge.None, 70, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-51b8b645 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0013_ProductionPlanLineLoadPopup.cs:326 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sColumnName.IndexOf("B_") > 0) | GRID_INIT | spdInfo.SetReNumerCellType | (spdInfo, spdInfo.GetColumnIndex(sColumnName), 0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-e7d2c3e5 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0013_ProductionPlanLineLoadPopup.cs:330 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sColumnName.IndexOf("B_") > 0) ▸ if (sDayCode == DefColumnsLabel.Saturday \|\| … | GRID_SET | spdInfo.Sheet().ColumnHeader.Cells[2, spdInfo.GetMaxColumnIndex()].ForeColor | sDayCode == DefColumnsLabel.Saturday ? Color.Blue : Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-7949beed | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0013_ProductionPlanLineLoadPopup.cs:337 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-cd2370ca | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0013_ProductionPlanLineLoadPopup.cs:338 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2b999d19 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0013_ProductionPlanLineLoadPopup.cs:343 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9c9e4d07 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0013_ProductionPlanLineLoadPopup.cs:344 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 30, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-68d541b5 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0013_ProductionPlanLineLoadPopup.cs:352 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName != sSmallLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-02508c94 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0013_ProductionPlanLineLoadPopup.cs:353 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName != sSmallLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-77ef5572 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0013_ProductionPlanLineLoadPopup.cs:363 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6cff24f9 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0013_ProductionPlanLineLoadPopup.cs:364 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1c03316e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0013_ProductionPlanLineLoadPopup.cs:365 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2a30a30f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0013_ProductionPlanLineLoadPopup.cs:366 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0013_ProductionPlanLineLoadPopup.Set_CellColor

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find: ▸ if (siMain.GetMaxRowIndex() > 0)] / this.Load [if (siMain.GetMaxRowIndex() > 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-323629c2 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0013_ProductionPlanLineLoadPopup.cs:528 | for (i < siMain.ActiveSheet.RowCount) ▸ if (spd_operation_id=="-") | UI_PROP | range1.BackColor | Color.FromArgb(234, 234, 234) | 속성 BackColor 설정 |  |  |  |
| AC-57e60da6 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0013_ProductionPlanLineLoadPopup.cs:534 | for (i < siMain.ActiveSheet.RowCount) ▸ else of (spd_operation_id=="-") ▸ if (spd_line_id=="-") | UI_PROP | range1.BackColor | Color.FromArgb(234, 234, 234) | 속성 BackColor 설정 |  |  |  |
| AC-093d4017 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0013_ProductionPlanLineLoadPopup.cs:537 | for (i < siMain.ActiveSheet.RowCount) | UI_MISC | spdMain.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## SCP0013_ProductionPlanLineLoadPopup.SetFormationYield

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find:] / this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-486d36ae | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0013_ProductionPlanLineLoadPopup.cs:552 | for (nRow < dt.Rows.Count) | CALL_EXT | siMain.SetDecimal | (nRow, nIdxStart, nRow, nIdxEnd, 2, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ab29c6d6 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0013_ProductionPlanLineLoadPopup.cs:555 |  | DATA_OP | dt.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |

## SCP0013_ProductionPlanLineLoadPopup.SetSpreadColumn

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find: ▸ if (spreadInfo.SheetName == SpdSheet.shtMain)] / this.Load [if (spreadInfo.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-09f6ab74 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0013_ProductionPlanLineLoadPopup.cs:394 | for (iCol < siObj.ActiveSheet.ColumnCount) ▸ if (siObj.GetColumnTag(iCol).IndexOf("D_") == 0) | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-91eb259e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0013_ProductionPlanLineLoadPopup.cs:398 | for (iCol < siObj.ActiveSheet.ColumnCount) ▸ else of (siObj.GetColumnTag(iCol).IndexOf("D_") == 0) ▸ if (siObj.GetColumnTag(iCol).IndexOf("W… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-b559857d | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0013_ProductionPlanLineLoadPopup.cs:404 | for (iCol < siObj.ActiveSheet.ColumnCount) ▸ if (siObj.GetColumnTag(iCol).IndexOf("M_") == 0) | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |

