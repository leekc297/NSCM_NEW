# AS-IS 액션 대조표 — SCP0057

> 원천: `Doc/asisfacts/screens/SCP0057/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 645행 · 메서드 59 · 종류 DATA_OP 235 · RETURN 57 · FLAG 51 · UI_PROP 36 · MESSAGE 32 · COMBO_DATA 31 · ENDPOINT 26 · GRID_SET 22 · GRID_INIT 21 · CALL_EXT 18 · VALUE_SET 18 · LIST_REBIND 18 · POPUP 16 · GRID_STYLE 16 · UI_MISC 15 · STATE 13 · VALIDATE 5 · GRID_CLEAR 5 · GRID_LOCK 5 · STATE_RESET 1 · GRID_BIND 1 · LIST_CLEAR 1 · VALUE_CLEAR 1 · THROW 1 · ⚠ 의미 확인 필요 18


## SCP0057_ProductionPlanLine_JV.btnFix_Click

진입점: this.btnFix.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ee72e4a3 | this.btnFix.Click | SCP0057_ProductionPlanLine_JV.cs:868 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c4b9b767 | this.btnFix.Click | SCP0057_ProductionPlanLine_JV.cs:869 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c22f07ee | this.btnFix.Click | SCP0057_ProductionPlanLine_JV.cs:875 | if (siMain.IsLock(siMain.SheetName)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00010") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0a80440b | this.btnFix.Click | SCP0057_ProductionPlanLine_JV.cs:879 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (!Get_IsSaveYn()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0057_ProductionPlanLine_JV.btnItemId_Click

진입점: this.btnItemId.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-81055182 | this.btnItemId.Click | SCP0057_ProductionPlanLine_JV.cs:715 |  | CALL_EXT | UIUtils.GetAllDivisionCheckedElectrode | (cboDivision) | ⚠ 의미 확인 필요 |  |  |  |
| AC-986df53a | this.btnItemId.Click | SCP0057_ProductionPlanLine_JV.cs:721 |  | POPUP | new SCM0002_ItembyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-f80ebbba | this.btnItemId.Click | SCP0057_ProductionPlanLine_JV.cs:723 |  | POPUP | popItem.Form_Load | (true, division, sScmSite, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-6a33cfbf | this.btnItemId.Click | SCP0057_ProductionPlanLine_JV.cs:724 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-1fa9390e | this.btnItemId.Click | SCP0057_ProductionPlanLine_JV.cs:725 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-35b689ee | this.btnItemId.Click | SCP0057_ProductionPlanLine_JV.cs:731 | if (popItem.ItemID != "") | VALUE_SET | txtItemId.Text | sItemId | 컨트롤 값 설정 |  |  |  |

## SCP0057_ProductionPlanLine_JV.BtnLoad_Click

진입점: btnLoad.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f84dc9db | btnLoad.Click | SCP0057_ProductionPlanLine_JV.cs:790 |  | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-b01c0ae4 | btnLoad.Click | SCP0057_ProductionPlanLine_JV.cs:790 | if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-de136805 | btnLoad.Click | SCP0057_ProductionPlanLine_JV.cs:791 |  | VALIDATE | DateUtil.Check_PeriodDate | (drpPeriod) | 프레임워크 검증 |  |  |  |
| AC-dd3fc587 | btnLoad.Click | SCP0057_ProductionPlanLine_JV.cs:791 | if (!DateUtil.Check_PeriodDate(drpPeriod)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a8cebaa4 | btnLoad.Click | SCP0057_ProductionPlanLine_JV.cs:793 | if (cboPlanDate.ControlValues == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6027a41f | btnLoad.Click | SCP0057_ProductionPlanLine_JV.cs:796 | if (sScmSite == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2023e749 | btnLoad.Click | SCP0057_ProductionPlanLine_JV.cs:822 |  | POPUP | new SCP0013_ProductionPlanLineLoadPopup | () | 팝업/폼 생성 |  |  |  |
| AC-cf53aa62 | btnLoad.Click | SCP0057_ProductionPlanLine_JV.cs:823 |  | UI_PROP | popup._pFromYYYYMMDD | p_from_yyyymmdd.ToString() | 속성 _pFromYYYYMMDD 설정 |  |  |  |
| AC-d5552c89 | btnLoad.Click | SCP0057_ProductionPlanLine_JV.cs:824 |  | UI_PROP | popup._pToYYYYMMDD | p_to_yyyymmdd.ToString() | 속성 _pToYYYYMMDD 설정 |  |  |  |
| AC-f9bccd64 | btnLoad.Click | SCP0057_ProductionPlanLine_JV.cs:825 |  | UI_PROP | popup._pDivisionID | p_division_id.ToString() | 속성 _pDivisionID 설정 |  |  |  |
| AC-4f6757ce | btnLoad.Click | SCP0057_ProductionPlanLine_JV.cs:826 |  | UI_PROP | popup._pOperationGroup | p_operation_group.ToString() | 속성 _pOperationGroup 설정 |  |  |  |
| AC-e7e6b24d | btnLoad.Click | SCP0057_ProductionPlanLine_JV.cs:827 |  | UI_PROP | popup._pPlanStartYYYYMMDD | p_plan_start_yyyymmdd.ToString() | 속성 _pPlanStartYYYYMMDD 설정 |  |  |  |
| AC-869ec3c2 | btnLoad.Click | SCP0057_ProductionPlanLine_JV.cs:828 |  | UI_PROP | popup._pPlanType | p_plan_type.ToString() | 속성 _pPlanType 설정 |  |  |  |
| AC-7b16e237 | btnLoad.Click | SCP0057_ProductionPlanLine_JV.cs:829 |  | UI_PROP | popup._pSeq | p_seq.ToString() | 속성 _pSeq 설정 |  |  |  |
| AC-f779738d | btnLoad.Click | SCP0057_ProductionPlanLine_JV.cs:830 |  | UI_PROP | popup._pScmSiteId | p_scm_site_id.ToString() | 속성 _pScmSiteId 설정 |  |  |  |
| AC-4231d741 | btnLoad.Click | SCP0057_ProductionPlanLine_JV.cs:831 |  | UI_PROP | popup._pLineId | p_line_id.ToString() | 속성 _pLineId 설정 |  |  |  |
| AC-412f4f96 | btnLoad.Click | SCP0057_ProductionPlanLine_JV.cs:833 |  | UI_PROP | popup.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-2ba3a4b8 | btnLoad.Click | SCP0057_ProductionPlanLine_JV.cs:834 |  | POPUP | popup.Show | () | 팝업/폼 열기 |  |  |  |

## SCP0057_ProductionPlanLine_JV.BtnMeasure_Click

진입점: this.btnMeasure.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-432e9f91 | this.btnMeasure.Click | SCP0057_ProductionPlanLine_JV.cs:919 | if (fps != null) ▸ else of (fps.Name == "spdMain") | MESSAGE | MessageHelper.GMessageBox | ("MSG00007", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-1b59a9b0 | this.btnMeasure.Click | SCP0057_ProductionPlanLine_JV.cs:920 | if (fps != null) ▸ else of (fps.Name == "spdMain") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e8d50f51 | this.btnMeasure.Click | SCP0057_ProductionPlanLine_JV.cs:925 | else of (fps != null) | MESSAGE | MessageHelper.GMessageBox | ("MSG00007", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-688842a4 | this.btnMeasure.Click | SCP0057_ProductionPlanLine_JV.cs:926 | else of (fps != null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-48e7a35f | this.btnMeasure.Click | SCP0057_ProductionPlanLine_JV.cs:929 |  | POPUP | new SCM0002_TitleSetForm_Popup | ("SCP0057", shtName, false) | 팝업/폼 생성 |  |  |  |
| AC-bb33f943 | this.btnMeasure.Click | SCP0057_ProductionPlanLine_JV.cs:930 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-1ad09e03 | this.btnMeasure.Click | SCP0057_ProductionPlanLine_JV.cs:931 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-1401252b | this.btnMeasure.Click | SCP0057_ProductionPlanLine_JV.cs:935 | if (frm.DialogResult == DialogResult.OK) | UI_PROP | this.CanModelChange | false | 속성 CanModelChange 설정 |  |  |  |
| AC-9879d4b1 | this.btnMeasure.Click | SCP0057_ProductionPlanLine_JV.cs:940 | if (frm.DialogResult == DialogResult.OK) | UI_PROP | this.CanModelChange | true | 속성 CanModelChange 설정 |  |  |  |

## SCP0057_ProductionPlanLine_JV.BtnNew_Click

진입점: btnNew.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-189d4ea3 | btnNew.Click | SCP0057_ProductionPlanLine_JV.cs:742 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-1cf98def | btnNew.Click | SCP0057_ProductionPlanLine_JV.cs:743 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-44641e44 | btnNew.Click | SCP0057_ProductionPlanLine_JV.cs:747 | if (cboPlanDate.ControlValues == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-be6e1886 | btnNew.Click | SCP0057_ProductionPlanLine_JV.cs:749 | if (!Get_IsSaveYn()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-fcf892d4 | btnNew.Click | SCP0057_ProductionPlanLine_JV.cs:758 |  | POPUP | new SCM0002_ProductionPlanInsertPopup | () | 팝업/폼 생성 |  |  |  |
| AC-170a0199 | btnNew.Click | SCP0057_ProductionPlanLine_JV.cs:759 |  | UI_PROP | popup.division | division | 속성 division 설정 |  |  |  |
| AC-0ce5d2cb | btnNew.Click | SCP0057_ProductionPlanLine_JV.cs:760 |  | UI_PROP | popup.operationGroup | sOperationGroup | 속성 operationGroup 설정 |  |  |  |
| AC-aa3c1297 | btnNew.Click | SCP0057_ProductionPlanLine_JV.cs:761 |  | UI_PROP | popup.planDate | dPlanDate | 속성 planDate 설정 |  |  |  |
| AC-7e69d581 | btnNew.Click | SCP0057_ProductionPlanLine_JV.cs:762 |  | UI_PROP | popup.planType | sPlanType | 속성 planType 설정 |  |  |  |
| AC-d76c1bb1 | btnNew.Click | SCP0057_ProductionPlanLine_JV.cs:763 |  | UI_PROP | popup.seq | sSeq | 속성 seq 설정 |  |  |  |
| AC-40507ddc | btnNew.Click | SCP0057_ProductionPlanLine_JV.cs:764 |  | UI_PROP | popup.user_id | UserInfo.UserId | 속성 user_id 설정 |  |  |  |
| AC-7b2500f5 | btnNew.Click | SCP0057_ProductionPlanLine_JV.cs:766 |  | UI_PROP | popup.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-ed62705b | btnNew.Click | SCP0057_ProductionPlanLine_JV.cs:767 |  | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-eb3c9a81 | btnNew.Click | SCP0057_ProductionPlanLine_JV.cs:777 | if (popup.DialogResult == DialogResult.OK) ▸ else of (division.Substring(0, 2).Equals("EE")) | VALUE_SET | txtItemId.Text | popup.Item_id | 컨트롤 값 설정 |  |  |  |
| AC-0b1d4420 | btnNew.Click | SCP0057_ProductionPlanLine_JV.cs:779 | if (popup.DialogResult == DialogResult.OK) | MESSAGE | MessageHelper.GMessageBox | ("MSG00265") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SCP0057_ProductionPlanLine_JV.btnUnfix_Click

진입점: this.btnUnfix.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9feed62b | this.btnUnfix.Click | SCP0057_ProductionPlanLine_JV.cs:891 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d9afddc0 | this.btnUnfix.Click | SCP0057_ProductionPlanLine_JV.cs:892 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8b9ad62f | this.btnUnfix.Click | SCP0057_ProductionPlanLine_JV.cs:898 | if (siMain.IsLock(siMain.SheetName)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00010") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-19cc7936 | this.btnUnfix.Click | SCP0057_ProductionPlanLine_JV.cs:902 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (!Get_IsSaveYn()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0057_ProductionPlanLine_JV.BtnW26_Click

진입점: btnW26.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-89bdf9c9 | btnW26.Click | SCP0057_ProductionPlanLine_JV.cs:840 |  | VALUE_SET | drpPeriod.InitValue | GetDayRange(PeriodType.W26) | 컨트롤 값 설정 |  |  |  |

## SCP0057_ProductionPlanLine_JV.BtnW52_Click

진입점: btnW52.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1192e460 | btnW52.Click | SCP0057_ProductionPlanLine_JV.cs:845 |  | VALUE_SET | drpPeriod.InitValue | GetDayRange(PeriodType.W52) | 컨트롤 값 설정 |  |  |  |

## SCP0057_ProductionPlanLine_JV.BtnWLast_Click

진입점: btnWLast.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0d7c5dbd | btnWLast.Click | SCP0057_ProductionPlanLine_JV.cs:856 |  | VALUE_SET | drpPeriod.InitValue | GetDayRange(sPeriod) | 컨트롤 값 설정 |  |  |  |

## SCP0057_ProductionPlanLine_JV.CalculateDailyQty

진입점: dsdmLine.Changed [try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (!cellclipboardPast) ▸ if (strColName.IndexOf("W_") == 0) ▸ if (cboBucketType.ControlValues.Equals(BucketType.Daily) \|\| chkAll.Checked)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-851774fc | dsdmLine.Changed [try ▸ switch (e.Type) case FarPoint.Win.Sp… | SCP0057_ProductionPlanLine_JV.cs:1390 | if (nWeek < 0) | GRID_SET | siMain.SetValue | (nRow, nCol, nDaySum) | 그리드 값 설정 |  |  |  |
| AC-61b04cd0 | dsdmLine.Changed [try ▸ switch (e.Type) case FarPoint.Win.Sp… | SCP0057_ProductionPlanLine_JV.cs:1393 | if (nWeek < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2f387830 | dsdmLine.Changed [try ▸ switch (e.Type) case FarPoint.Win.Sp… | SCP0057_ProductionPlanLine_JV.cs:1406 | for (j < (nCol + 1 + nDayCnt)) ▸ if (j != (nCol + nDayCnt)) | GRID_SET | siMain.SetValue | (nRow, j, nDivDay) | 그리드 값 설정 |  |  |  |
| AC-61cf7ba8 | dsdmLine.Changed [try ▸ switch (e.Type) case FarPoint.Win.Sp… | SCP0057_ProductionPlanLine_JV.cs:1411 | for (j < (nCol + 1 + nDayCnt)) ▸ else of (j != (nCol + nDayCnt)) | GRID_SET | siMain.SetValue | (nRow, j, (nDivDay + nDivDayMod).ToString()) | 그리드 값 설정 |  |  |  |
| AC-e36aca1b | dsdmLine.Changed [try ▸ switch (e.Type) case FarPoint.Win.Sp… | SCP0057_ProductionPlanLine_JV.cs:1413 | for (j < (nCol + 1 + nDayCnt)) | GRID_STYLE | siMain.SetFGColor | (nRow, j, nRow, j, ControlColor.MarkedForeColor) | 그리드 표시 설정 |  |  |  |
| AC-46a7b12f | dsdmLine.Changed [try ▸ switch (e.Type) case FarPoint.Win.Sp… | SCP0057_ProductionPlanLine_JV.cs:1425 | if (!cellclipboardPast) ▸ if (ds == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0057_ProductionPlanLine_JV.CalculateDailyQty2

진입점: this.spdMain.ClipboardPasted [try ▸ for (iRow < e.CellRange.Row + e.CellRange.RowCount) ▸ if (measure.Equals("PROD_PLAN_AMEND")) ▸ for (iCol < e.CellRange.Column + e.CellRange.ColumnCount) ▸ if (strColName.IndexOf("W_") == 0 && siMain.ActiveSheet.Cells[iRow, iCol].ForeColor.Name == "Red" && (cboBucketType.ControlV…)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f64b7e10 | this.spdMain.ClipboardPasted [try ▸ for (iRow < e.CellRange.… | SCP0057_ProductionPlanLine_JV.cs:1448 | if (ds == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2e478151 | this.spdMain.ClipboardPasted [try ▸ for (iRow < e.CellRange.… | SCP0057_ProductionPlanLine_JV.cs:1499 | for (j < (sumCol + 1 + nDayCnt)) ▸ if (j != (sumCol + nDayCnt)) | DATA_OP | dr[j] | nDivDay | 행/컬럼 값 대입 |  |  |  |
| AC-4529cd19 | this.spdMain.ClipboardPasted [try ▸ for (iRow < e.CellRange.… | SCP0057_ProductionPlanLine_JV.cs:1503 | for (j < (sumCol + 1 + nDayCnt)) ▸ else of (j != (sumCol + nDayCnt)) | DATA_OP | dr[j] | nDivDay + nDivDayMod | 행/컬럼 값 대입 |  |  |  |
| AC-fd293551 | this.spdMain.ClipboardPasted [try ▸ for (iRow < e.CellRange.… | SCP0057_ProductionPlanLine_JV.cs:1505 | for (j < (sumCol + 1 + nDayCnt)) | GRID_STYLE | siMain.SetFGColor | (nRow, k, nRow, k, ControlColor.MarkedForeColor) | 그리드 표시 설정 |  |  |  |
| AC-6f09b034 | this.spdMain.ClipboardPasted [try ▸ for (iRow < e.CellRange.… | SCP0057_ProductionPlanLine_JV.cs:1508 |  | DATA_OP | dt.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |

## SCP0057_ProductionPlanLine_JV.CalculateSum

진입점: this.spdMain.ClipboardPasted [try ▸ for (iRow < e.CellRange.Row + e.CellRange.RowCount) ▸ if (measure.Equals("PROD_PLAN_AMEND"))] / dsdmLine.Changed [try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (!cellclipboardPast)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-52900a68 | this.spdMain.ClipboardPasted [try ▸ for (iRow < e.CellRange.… 외 1 | SCP0057_ProductionPlanLine_JV.cs:1074 | if (cboBucketType.ControlValues.Equals(BucketType.Daily) \|\| chkAll.Checked) ▸ for (nCol < dt.Columns.Count) ▸ if (dt.Columns[nCol].ColumnN… | DATA_OP | listMonth.Add | (nCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-d541f2d7 | this.spdMain.ClipboardPasted [try ▸ for (iRow < e.CellRange.… 외 1 | SCP0057_ProductionPlanLine_JV.cs:1078 | if (cboBucketType.ControlValues.Equals(BucketType.Daily) \|\| chkAll.Checked) ▸ for (nCol < dt.Columns.Count) ▸ if (dt.Columns[nCol].ColumnN… | DATA_OP | listWeek.Add | (nCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-58225404 | this.spdMain.ClipboardPasted [try ▸ for (iRow < e.CellRange.… 외 1 | SCP0057_ProductionPlanLine_JV.cs:1123 | if (cboBucketType.ControlValues.Equals(BucketType.Daily) \|\| chkAll.Checked) ▸ for (nCol < dt.Columns.Count) ▸ if (nCol == dt.Columns.Count… | DATA_OP | dr[nIdxWeek] | weekSum / nCntDayOfWeek | 행/컬럼 값 대입 |  |  |  |
| AC-04eb0c1e | this.spdMain.ClipboardPasted [try ▸ for (iRow < e.CellRange.… 외 1 | SCP0057_ProductionPlanLine_JV.cs:1127 | if (cboBucketType.ControlValues.Equals(BucketType.Daily) \|\| chkAll.Checked) ▸ for (nCol < dt.Columns.Count) ▸ if (nCol == dt.Columns.Count… | DATA_OP | dr[nIdxWeek] | weekSum | 행/컬럼 값 대입 |  |  |  |
| AC-68abe7fa | this.spdMain.ClipboardPasted [try ▸ for (iRow < e.CellRange.… 외 1 | SCP0057_ProductionPlanLine_JV.cs:1141 | if (cboBucketType.ControlValues.Equals(BucketType.Daily) \|\| chkAll.Checked) ▸ for (nCol < dt.Columns.Count) ▸ if (nCol == dt.Columns.Count… | DATA_OP | dr[nIdxMonth] | monthSum / nCntDayOfMonth | 행/컬럼 값 대입 |  |  |  |
| AC-3e88dbb5 | this.spdMain.ClipboardPasted [try ▸ for (iRow < e.CellRange.… 외 1 | SCP0057_ProductionPlanLine_JV.cs:1145 | if (cboBucketType.ControlValues.Equals(BucketType.Daily) \|\| chkAll.Checked) ▸ for (nCol < dt.Columns.Count) ▸ if (nCol == dt.Columns.Count… | DATA_OP | dr[nIdxMonth] | monthSum | 행/컬럼 값 대입 |  |  |  |
| AC-19a5cecc | this.spdMain.ClipboardPasted [try ▸ for (iRow < e.CellRange.… 외 1 | SCP0057_ProductionPlanLine_JV.cs:1158 | else of (cboBucketType.ControlValues.Equals(BucketType.Daily) \|\| chkAll.Checked) | DATA_OP | dtSpdTitle.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-f4fe526e | this.spdMain.ClipboardPasted [try ▸ for (iRow < e.CellRange.… 외 1 | SCP0057_ProductionPlanLine_JV.cs:1159 | else of (cboBucketType.ControlValues.Equals(BucketType.Daily) \|\| chkAll.Checked) | DATA_OP | dtTitle.Columns.Remove | ("SORT_ORDER_NO") | 데이터 객체 조작/조회 |  |  |  |
| AC-bd6983c2 | this.spdMain.ClipboardPasted [try ▸ for (iRow < e.CellRange.… 외 1 | SCP0057_ProductionPlanLine_JV.cs:1160 | else of (cboBucketType.ControlValues.Equals(BucketType.Daily) \|\| chkAll.Checked) | DATA_OP | dtTitle.Merge | (dsSpdTitle.Tables[0]) | 데이터 객체 조작/조회 |  |  |  |
| AC-801f66a1 | this.spdMain.ClipboardPasted [try ▸ for (iRow < e.CellRange.… 외 1 | SCP0057_ProductionPlanLine_JV.cs:1170 | else of (cboBucketType.ControlValues.Equals(BucketType.Daily) \|\| chkAll.Checked) ▸ for (nCol < dtTitle.Rows.Count) ▸ if (dtTitle.Rows[nCol… | DATA_OP | listMonth.Add | (nCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-5a0edbe8 | this.spdMain.ClipboardPasted [try ▸ for (iRow < e.CellRange.… 외 1 | SCP0057_ProductionPlanLine_JV.cs:1171 | else of (cboBucketType.ControlValues.Equals(BucketType.Daily) \|\| chkAll.Checked) ▸ for (nCol < dtTitle.Rows.Count) ▸ if (dtTitle.Rows[nCol… | DATA_OP | listMonth2.Add | (dtTitle.Rows[nCol]["COLUMN_NAME"].ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-daf2f50b | this.spdMain.ClipboardPasted [try ▸ for (iRow < e.CellRange.… 외 1 | SCP0057_ProductionPlanLine_JV.cs:1175 | else of (cboBucketType.ControlValues.Equals(BucketType.Daily) \|\| chkAll.Checked) ▸ for (nCol < dtTitle.Rows.Count) ▸ if (dtTitle.Rows[nCol… | DATA_OP | listWeek.Add | (nCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-04cc99bf | this.spdMain.ClipboardPasted [try ▸ for (iRow < e.CellRange.… 외 1 | SCP0057_ProductionPlanLine_JV.cs:1176 | else of (cboBucketType.ControlValues.Equals(BucketType.Daily) \|\| chkAll.Checked) ▸ for (nCol < dtTitle.Rows.Count) ▸ if (dtTitle.Rows[nCol… | DATA_OP | listWeek2.Add | (dtTitle.Rows[nCol]["COLUMN_NAME"].ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-a56b6d94 | this.spdMain.ClipboardPasted [try ▸ for (iRow < e.CellRange.… 외 1 | SCP0057_ProductionPlanLine_JV.cs:1201 | else of (cboBucketType.ControlValues.Equals(BucketType.Daily) \|\| chkAll.Checked) ▸ for (nCol < dtTitle.Rows.Count) ▸ if (nCol == dtTitle.R… | DATA_OP | dr[month] | monthSum | 행/컬럼 값 대입 |  |  |  |
| AC-eea37b52 | this.spdMain.ClipboardPasted [try ▸ for (iRow < e.CellRange.… 외 1 | SCP0057_ProductionPlanLine_JV.cs:1209 |  | DATA_OP | dt.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-2284f05b | this.spdMain.ClipboardPasted [try ▸ for (iRow < e.CellRange.… 외 1 | SCP0057_ProductionPlanLine_JV.cs:1231 | for (nCol < dt.Columns.Count) ▸ if (dt.Columns[nCol].ColumnName.IndexOf("M_") == 0) | DATA_OP | listMonth.Add | (nCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-6edf21f2 | this.spdMain.ClipboardPasted [try ▸ for (iRow < e.CellRange.… 외 1 | SCP0057_ProductionPlanLine_JV.cs:1235 | for (nCol < dt.Columns.Count) ▸ if (dt.Columns[nCol].ColumnName.IndexOf("W_") == 0) | DATA_OP | listWeek.Add | (nCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-41b91d30 | this.spdMain.ClipboardPasted [try ▸ for (iRow < e.CellRange.… 외 1 | SCP0057_ProductionPlanLine_JV.cs:1298 | for (nRow < dt.Rows.Count) ▸ for (nCol < dt.Columns.Count) ▸ if (nCol == dt.Columns.Count - 1 \|\| dt.Columns[nCol].ColumnName.IndexOf("W_")… | DATA_OP | dr[nIdxWeek] | weekSum / nCntDayOfWeek | 행/컬럼 값 대입 |  |  |  |
| AC-28e25b38 | this.spdMain.ClipboardPasted [try ▸ for (iRow < e.CellRange.… 외 1 | SCP0057_ProductionPlanLine_JV.cs:1302 | for (nRow < dt.Rows.Count) ▸ for (nCol < dt.Columns.Count) ▸ if (nCol == dt.Columns.Count - 1 \|\| dt.Columns[nCol].ColumnName.IndexOf("W_")… | DATA_OP | dr[nIdxWeek] | weekSum | 행/컬럼 값 대입 |  |  |  |
| AC-6788ab59 | this.spdMain.ClipboardPasted [try ▸ for (iRow < e.CellRange.… 외 1 | SCP0057_ProductionPlanLine_JV.cs:1320 | for (nRow < dt.Rows.Count) ▸ for (nCol < dt.Columns.Count) ▸ if (nCol == dt.Columns.Count - 1 \|\| dt.Columns[nCol].ColumnName.IndexOf("M_")… | DATA_OP | dr[nIdxMonth] | monthSum / nCntDayOfMonth | 행/컬럼 값 대입 |  |  |  |
| AC-d1238250 | this.spdMain.ClipboardPasted [try ▸ for (iRow < e.CellRange.… 외 1 | SCP0057_ProductionPlanLine_JV.cs:1324 | for (nRow < dt.Rows.Count) ▸ for (nCol < dt.Columns.Count) ▸ if (nCol == dt.Columns.Count - 1 \|\| dt.Columns[nCol].ColumnName.IndexOf("M_")… | DATA_OP | dr[nIdxMonth] | monthSum | 행/컬럼 값 대입 |  |  |  |
| AC-394821e7 | this.spdMain.ClipboardPasted [try ▸ for (iRow < e.CellRange.… 외 1 | SCP0057_ProductionPlanLine_JV.cs:1333 |  | DATA_OP | dt.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |

## SCP0057_ProductionPlanLine_JV.cboBucketType_SelectedIndexChanged

진입점: this.cboBucketType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ce96cb59 | this.cboBucketType.SelectedIndexChanged | SCP0057_ProductionPlanLine_JV.cs:707 | else of (chkAll.Checked) | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |

## SCP0057_ProductionPlanLine_JV.CboDivision_SelectedIndexChanged

진입점: cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-55ae388c | cboDivision.SelectedIndexChanged | SCP0057_ProductionPlanLine_JV.cs:3220 |  | VALUE_SET | btnWLast.Text | "W" + dailyPlanPeriod | 컨트롤 값 설정 |  |  |  |

## SCP0057_ProductionPlanLine_JV.CboOperationGroup_SelectedIndexChanged

진입점: cboOperationGroup.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7a3dbfcf | cboOperationGroup.SelectedIndexChanged | SCP0057_ProductionPlanLine_JV.cs:3255 | if (division.Substring(0, 2).Equals("EE")) | CALL_EXT | dic_JV_Plant.TryGetValue | (division, out get_JV_Value) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b292b548 | cboOperationGroup.SelectedIndexChanged | SCP0057_ProductionPlanLine_JV.cs:3266 | if (division.Substring(0, 2).Equals("EE")) ▸ if (get_JV_Value == "") | FLAG | dtPlantSiteByDivision | Data_SCP.Common(Data_SCP.Type.PlantSiteProdPlan, false, division, pOperationGroup, "JV Pla… | 화면 필드/플래그 변경 |  |  |  |
| AC-5b8f8c95 | cboOperationGroup.SelectedIndexChanged | SCP0057_ProductionPlanLine_JV.cs:3266 | if (division.Substring(0, 2).Equals("EE")) ▸ if (get_JV_Value == "") | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.PlantSiteProdPlan, false, division, pOperationGroup, "JV Planner", "9999!!!… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-b3b6a7c3 | cboOperationGroup.SelectedIndexChanged | SCP0057_ProductionPlanLine_JV.cs:3267 | if (division.Substring(0, 2).Equals("EE")) ▸ else of (get_JV_Value == "") | FLAG | dtPlantSiteByDivision | Data_SCP.Common(Data_SCP.Type.PlantSiteProdPlan, false, division, pOperationGroup, "JV Pla… | 화면 필드/플래그 변경 |  |  |  |
| AC-8d7eee86 | cboOperationGroup.SelectedIndexChanged | SCP0057_ProductionPlanLine_JV.cs:3267 | if (division.Substring(0, 2).Equals("EE")) ▸ else of (get_JV_Value == "") | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.PlantSiteProdPlan, false, division, pOperationGroup, "JV Planner", get_JV_V… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-8327a647 | cboOperationGroup.SelectedIndexChanged | SCP0057_ProductionPlanLine_JV.cs:3272 | else of (division.Substring(0, 2).Equals("EE")) | CALL_EXT | dic_JV_Plant.TryGetValue | (division, out get_JV_Value) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b74af77c | cboOperationGroup.SelectedIndexChanged | SCP0057_ProductionPlanLine_JV.cs:3274 | else of (division.Substring(0, 2).Equals("EE")) ▸ if (get_JV_Value == "") | FLAG | dtPlantSiteByDivision | Data.Common(Data.Type.PlantByDivisionOperation, false, "9999!!!!", pOperationGroup, "JV Pl… ⇒ biz:CommonData.CommonDataList [code=PlantByDivisionOperation] | 화면 필드/플래그 변경 |  |  |  |
| AC-c1d615a9 | cboOperationGroup.SelectedIndexChanged | SCP0057_ProductionPlanLine_JV.cs:3274 | else of (division.Substring(0, 2).Equals("EE")) ▸ if (get_JV_Value == "") | COMBO_DATA | Data.Common | (Data.Type.PlantByDivisionOperation, false, "9999!!!!", pOperationGroup, "JV Planner", get… ⇒ biz:CommonData.CommonDataList [code=PlantByDivisionOperation] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-bc7f8cfb | cboOperationGroup.SelectedIndexChanged | SCP0057_ProductionPlanLine_JV.cs:3275 | else of (division.Substring(0, 2).Equals("EE")) ▸ else of (get_JV_Value == "") | FLAG | dtPlantSiteByDivision | Data.Common(Data.Type.PlantByDivisionOperation, false, division, pOperationGroup, "JV Plan… ⇒ biz:CommonData.CommonDataList [code=PlantByDivisionOperation] | 화면 필드/플래그 변경 |  |  |  |
| AC-1c4ce7f4 | cboOperationGroup.SelectedIndexChanged | SCP0057_ProductionPlanLine_JV.cs:3275 | else of (division.Substring(0, 2).Equals("EE")) ▸ else of (get_JV_Value == "") | COMBO_DATA | Data.Common | (Data.Type.PlantByDivisionOperation, false, division, pOperationGroup, "JV Planner", get_J… ⇒ biz:CommonData.CommonDataList [code=PlantByDivisionOperation] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-cea3ccf6 | cboOperationGroup.SelectedIndexChanged | SCP0057_ProductionPlanLine_JV.cs:3277 | if (dtPlantSiteByDivision.Rows.Count < 1) | UI_PROP | clbPlantSite.ALL_VIEW | false | 속성 ALL_VIEW 설정 |  |  |  |
| AC-66b0e4a7 | cboOperationGroup.SelectedIndexChanged | SCP0057_ProductionPlanLine_JV.cs:3278 | else of (dtPlantSiteByDivision.Rows.Count < 1) | UI_PROP | clbPlantSite.ALL_VIEW | true | 속성 ALL_VIEW 설정 |  |  |  |
| AC-545eb7bc | cboOperationGroup.SelectedIndexChanged | SCP0057_ProductionPlanLine_JV.cs:3280 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlantSiteByDivision, clbPlantSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-8a720536 | cboOperationGroup.SelectedIndexChanged | SCP0057_ProductionPlanLine_JV.cs:3287 | if (division.Substring(0, 2).Equals("EE")) ▸ if (pPlantSite == "") | FLAG | dtLine | Data_SCP.Common(Data_SCP.Type.LineProdPlanLine, false, "9999!!!!", pOperationGroup, pPlant… | 화면 필드/플래그 변경 |  |  |  |
| AC-6cf38e6f | cboOperationGroup.SelectedIndexChanged | SCP0057_ProductionPlanLine_JV.cs:3287 | if (division.Substring(0, 2).Equals("EE")) ▸ if (pPlantSite == "") | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.LineProdPlanLine, false, "9999!!!!", pOperationGroup, pPlantSite, "", "") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-879049de | cboOperationGroup.SelectedIndexChanged | SCP0057_ProductionPlanLine_JV.cs:3288 | if (division.Substring(0, 2).Equals("EE")) ▸ else of (pPlantSite == "") | FLAG | dtLine | Data_SCP.Common(Data_SCP.Type.LineProdPlanLine, false, division, pOperationGroup, pPlantSi… | 화면 필드/플래그 변경 |  |  |  |
| AC-baa1e95e | cboOperationGroup.SelectedIndexChanged | SCP0057_ProductionPlanLine_JV.cs:3288 | if (division.Substring(0, 2).Equals("EE")) ▸ else of (pPlantSite == "") | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.LineProdPlanLine, false, division, pOperationGroup, pPlantSite, "", "") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-cd8f4720 | cboOperationGroup.SelectedIndexChanged | SCP0057_ProductionPlanLine_JV.cs:3292 | else of (division.Substring(0, 2).Equals("EE")) ▸ if (pPlantSite == "") | FLAG | dtLine | Data_SCP.Common(Data_SCP.Type.LineByOperationAddOSP, false, "9999!!!!", "", "", "", pPlant… | 화면 필드/플래그 변경 |  |  |  |
| AC-618131a0 | cboOperationGroup.SelectedIndexChanged | SCP0057_ProductionPlanLine_JV.cs:3292 | else of (division.Substring(0, 2).Equals("EE")) ▸ if (pPlantSite == "") | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.LineByOperationAddOSP, false, "9999!!!!", "", "", "", pPlantSite) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-24deceb3 | cboOperationGroup.SelectedIndexChanged | SCP0057_ProductionPlanLine_JV.cs:3293 | else of (division.Substring(0, 2).Equals("EE")) ▸ else of (pPlantSite == "") | FLAG | dtLine | Data_SCP.Common(Data_SCP.Type.LineByOperationAddOSP, false, division, "", "", "", pPlantSi… | 화면 필드/플래그 변경 |  |  |  |
| AC-bf9c6134 | cboOperationGroup.SelectedIndexChanged | SCP0057_ProductionPlanLine_JV.cs:3293 | else of (division.Substring(0, 2).Equals("EE")) ▸ else of (pPlantSite == "") | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.LineByOperationAddOSP, false, division, "", "", "", pPlantSite) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-99f54c65 | cboOperationGroup.SelectedIndexChanged | SCP0057_ProductionPlanLine_JV.cs:3295 |  | LIST_REBIND | clsCtrl.setListBox | (dtLine, clbLine, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0057_ProductionPlanLine_JV.CboPlanDate_SelectedIndexChanged

진입점: cboPlanDate.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0f87a445 | cboPlanDate.SelectedIndexChanged | SCP0057_ProductionPlanLine_JV.cs:3304 |  | FLAG | dtPlanType | Data.Common(Data.Type.PlanType, false, division, pPlanDate) ⇒ biz:CommonData.CommonDataList [code=PlanType] | 화면 필드/플래그 변경 |  |  |  |
| AC-01dc272b | cboPlanDate.SelectedIndexChanged | SCP0057_ProductionPlanLine_JV.cs:3304 |  | COMBO_DATA | Data.Common | (Data.Type.PlanType, false, division, pPlanDate) ⇒ biz:CommonData.CommonDataList [code=PlanType] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-e38de317 | cboPlanDate.SelectedIndexChanged | SCP0057_ProductionPlanLine_JV.cs:3305 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanType, cboPlanType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-71b97d12 | cboPlanDate.SelectedIndexChanged | SCP0057_ProductionPlanLine_JV.cs:3306 |  | VALUE_SET | cboPlanType.SelectedIndex | dtPlanType.Rows.Count - 1 | 컨트롤 값 설정 |  |  |  |
| AC-50f5b233 | cboPlanDate.SelectedIndexChanged | SCP0057_ProductionPlanLine_JV.cs:3310 |  | VALUE_SET | drpPeriod.InitValue | GetDayRange(PeriodType.W52) | 컨트롤 값 설정 |  |  |  |
| AC-d9d792d5 | cboPlanDate.SelectedIndexChanged | SCP0057_ProductionPlanLine_JV.cs:3315 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |

## SCP0057_ProductionPlanLine_JV.CboPlanSeq_SelectedIndexChanged

진입점: cboPlanSeq.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-68c95d6d | cboPlanSeq.SelectedIndexChanged | SCP0057_ProductionPlanLine_JV.cs:3337 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |

## SCP0057_ProductionPlanLine_JV.CboPlanType_SelectedIndexChanged

진입점: cboPlanType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f915ac7e | cboPlanType.SelectedIndexChanged | SCP0057_ProductionPlanLine_JV.cs:3325 |  | FLAG | dtPlanSeq | Data.Common(Data.Type.PlanSeq, false, division, pPlanDate, pPlanType) ⇒ biz:CommonData.CommonDataList [code=PlanSeq] | 화면 필드/플래그 변경 |  |  |  |
| AC-611536aa | cboPlanType.SelectedIndexChanged | SCP0057_ProductionPlanLine_JV.cs:3325 |  | COMBO_DATA | Data.Common | (Data.Type.PlanSeq, false, division, pPlanDate, pPlanType) ⇒ biz:CommonData.CommonDataList [code=PlanSeq] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-96b4e54f | cboPlanType.SelectedIndexChanged | SCP0057_ProductionPlanLine_JV.cs:3326 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanSeq, cboPlanSeq, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-cec0999f | cboPlanType.SelectedIndexChanged | SCP0057_ProductionPlanLine_JV.cs:3327 |  | VALUE_SET | cboPlanSeq.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-e7fd4f51 | cboPlanType.SelectedIndexChanged | SCP0057_ProductionPlanLine_JV.cs:3330 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |

## SCP0057_ProductionPlanLine_JV.Check_LineAssign

진입점: this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName)) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Equals("S")) ▸ try] / this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName)) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Equals("S")) ▸ try] / btnNew.Click […

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4b2a80d8 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SCP0057_ProductionPlanLine_JV.cs:3450 | if (chkLineAssign.Checked && txtItemId.Text == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00290") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ff672eb8 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SCP0057_ProductionPlanLine_JV.cs:3453 |  | RETURN | return chkModel; |  | 처리 중단/반환 |  |  |  |

## SCP0057_ProductionPlanLine_JV.ChkAll_CheckedChanged

진입점: this.chkAll.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dd0696b4 | this.chkAll.CheckedChanged | SCP0057_ProductionPlanLine_JV.cs:994 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |

## SCP0057_ProductionPlanLine_JV.ClbPlantSite_SelectedIndexChanged

진입점: clbPlantSite.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-092b5cb1 | clbPlantSite.SelectedIndexChanged | SCP0057_ProductionPlanLine_JV.cs:3234 | if (division.Substring(0, 2).Equals("EE")) ▸ if (pPlantSiteID == "") | FLAG | dtLine | Data_SCP.Common(Data_SCP.Type.LineProdPlanLine, false, "9999!!!!", pOperationGroup, pPlant… | 화면 필드/플래그 변경 |  |  |  |
| AC-f6368492 | clbPlantSite.SelectedIndexChanged | SCP0057_ProductionPlanLine_JV.cs:3234 | if (division.Substring(0, 2).Equals("EE")) ▸ if (pPlantSiteID == "") | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.LineProdPlanLine, false, "9999!!!!", pOperationGroup, pPlantSiteID, "", "") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-207c9402 | clbPlantSite.SelectedIndexChanged | SCP0057_ProductionPlanLine_JV.cs:3235 | if (division.Substring(0, 2).Equals("EE")) ▸ else of (pPlantSiteID == "") | FLAG | dtLine | Data_SCP.Common(Data_SCP.Type.LineProdPlanLine, false, division, pOperationGroup, pPlantSi… | 화면 필드/플래그 변경 |  |  |  |
| AC-a4701088 | clbPlantSite.SelectedIndexChanged | SCP0057_ProductionPlanLine_JV.cs:3235 | if (division.Substring(0, 2).Equals("EE")) ▸ else of (pPlantSiteID == "") | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.LineProdPlanLine, false, division, pOperationGroup, pPlantSiteID, "", "") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-3c86b614 | clbPlantSite.SelectedIndexChanged | SCP0057_ProductionPlanLine_JV.cs:3239 | else of (division.Substring(0, 2).Equals("EE")) ▸ if (pPlantSiteID == "") | FLAG | dtLine | Data_SCP.Common(Data_SCP.Type.LineByOperationAddOSP, false, "9999!!!!", "", pFactoryID, pO… | 화면 필드/플래그 변경 |  |  |  |
| AC-6d70a059 | clbPlantSite.SelectedIndexChanged | SCP0057_ProductionPlanLine_JV.cs:3239 | else of (division.Substring(0, 2).Equals("EE")) ▸ if (pPlantSiteID == "") | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.LineByOperationAddOSP, false, "9999!!!!", "", pFactoryID, pOperationID, pPl… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-a62240d1 | clbPlantSite.SelectedIndexChanged | SCP0057_ProductionPlanLine_JV.cs:3240 | else of (division.Substring(0, 2).Equals("EE")) ▸ else of (pPlantSiteID == "") | FLAG | dtLine | Data_SCP.Common(Data_SCP.Type.LineByOperationAddOSP, false, division, "", pFactoryID, pOpe… | 화면 필드/플래그 변경 |  |  |  |
| AC-87082099 | clbPlantSite.SelectedIndexChanged | SCP0057_ProductionPlanLine_JV.cs:3240 | else of (division.Substring(0, 2).Equals("EE")) ▸ else of (pPlantSiteID == "") | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.LineByOperationAddOSP, false, division, "", pFactoryID, pOperationID, pPlan… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-eb54e9c8 | clbPlantSite.SelectedIndexChanged | SCP0057_ProductionPlanLine_JV.cs:3243 |  | LIST_REBIND | clsCtrl.setListBox | (dtLine, clbLine, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0057_ProductionPlanLine_JV.ClearUsrCheckedList

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-96bf7f75 | (진입점 미연결) | SCP0057_ProductionPlanLine_JV.cs:222 | if (dt != null) | STATE_RESET | dt.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-9fdaf0dd | (진입점 미연결) | SCP0057_ProductionPlanLine_JV.cs:223 | if (dt != null) | LIST_REBIND | clsCtrl.setListBox | (dt, control, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0057_ProductionPlanLine_JV.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2cd6ae38 | this.Load | SCP0057_ProductionPlanLine_JV.cs:273 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 3, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-eb450c09 | this.Load | SCP0057_ProductionPlanLine_JV.cs:273 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, 0) | 화면 필드/플래그 변경 |  |  |  |
| AC-485c172f | this.Load | SCP0057_ProductionPlanLine_JV.cs:275 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0057_ProductionPlanLine_JV.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e62193a2 | this.Load | SCP0057_ProductionPlanLine_JV.cs:210 |  | UI_PROP | usrConditionPanel1.Height | 105 | 속성 Height 설정 |  |  |  |
| AC-cf7d25b2 | this.Load | SCP0057_ProductionPlanLine_JV.cs:211 |  | VALUE_SET | cboBucketType.ControlValues | BucketType.Weekly | 컨트롤 값 설정 |  |  |  |
| AC-b0159ae8 | this.Load | SCP0057_ProductionPlanLine_JV.cs:212 |  | VALUE_SET | chkSum.Checked | false | 컨트롤 값 설정 |  |  |  |
| AC-287a4a5e | this.Load | SCP0057_ProductionPlanLine_JV.cs:213 |  | VALUE_SET | chkLineAssign.Checked | false | 컨트롤 값 설정 |  |  |  |

## SCP0057_ProductionPlanLine_JV.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-819cdc51 | Dispose | SCP0057_ProductionPlanLine_JV.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0057_ProductionPlanLine_JV.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3e95c237 | EditButton | SCP0057_ProductionPlanLine_JV.cs:561 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-437ed0f4 | EditButton | SCP0057_ProductionPlanLine_JV.cs:565 | if (fps.Name == "spdMain") ▸ if (siMain.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-90ff340f | EditButton | SCP0057_ProductionPlanLine_JV.cs:566 | if (fps.Name == "spdMain") | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-eea52edc | EditButton | SCP0057_ProductionPlanLine_JV.cs:567 | if (fps.Name == "spdMain") | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-ab197eed | EditButton | SCP0057_ProductionPlanLine_JV.cs:571 | if (fps.Name == "spdMain") | CALL_EXT | fps.ActiveSheet.GetColumnFromTag | (null, CAppSetting.StringAction) | ⚠ 의미 확인 필요 |  |  |  |
| AC-8578cd6c | EditButton | SCP0057_ProductionPlanLine_JV.cs:572 | if (fps.Name == "spdMain") | CALL_EXT | fps.ActiveSheet.Columns.Get | (xCol1) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a38865f6 | EditButton | SCP0057_ProductionPlanLine_JV.cs:574 | if (fps.Name == "spdMain") ▸ if (fps.ActiveSheet.Columns.Get(xCol1).Visible == true) | FLAG | cellclipboardPast | false | 화면 필드/플래그 변경 |  |  |  |
| AC-1f9a184f | EditButton | SCP0057_ProductionPlanLine_JV.cs:577 | if (fps.Name == "spdMain") | GRID_LOCK | siMain.LockRange | (0, 0, siMain.ActiveSheet.RowCount - 1, siMain.ActiveSheet.ColumnCount - 1, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-9b2adda9 | EditButton | SCP0057_ProductionPlanLine_JV.cs:579 | if (fps.Name == "spdMain") | CALL_EXT | fps.ActiveSheet.Columns.Get | (xCol1) | ⚠ 의미 확인 필요 |  |  |  |
| AC-5e41429b | EditButton | SCP0057_ProductionPlanLine_JV.cs:585 | if (fps.Name == "spdMain") ▸ if (fps.ActiveSheet.Columns.Get(xCol1).Visible == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ea4da70d | EditButton | SCP0057_ProductionPlanLine_JV.cs:596 | if (fps.Name == "spdMain") ▸ for (i < spdMain.ActiveSheet.RowCount) ▸ if (spdMain.ActiveSheet.GetText(i, siMain.GetColumnIndex(DefColumns.ME… | DATA_OP | dtIsEditInfo.Select | ("CP_KEY = '" + strCP_KEY + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-d7767062 | EditButton | SCP0057_ProductionPlanLine_JV.cs:624 | if (fps.Name == "spdMain") ▸ for (i < spdMain.ActiveSheet.RowCount) ▸ if (spdMain.ActiveSheet.GetText(i, siMain.GetColumnIndex(DefColumns.ME… | DATA_OP | dtPlanType.Select | ("CODE='FN'") | 데이터 객체 조작/조회 |  |  |  |
| AC-79c9a0f9 | EditButton | SCP0057_ProductionPlanLine_JV.cs:674 | if (fps.Name == "spdMain") ▸ for (i < spdMain.ActiveSheet.RowCount) ▸ if (spdMain.ActiveSheet.GetText(i, siMain.GetColumnIndex(DefColumns.ME… | GRID_LOCK | siMain.LockRange | (nEditableRow, nStartEditIdx, nEditableRow, siMain.ActiveSheet.ColumnCount - 1, false) | 그리드 편집 잠금/해제 |  |  |  |

## SCP0057_ProductionPlanLine_JV.FindButton

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cbc41b2f | FindButton | SCP0057_ProductionPlanLine_JV.cs:526 | if (checkPlantSite == 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00352") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-4e376393 | FindButton | SCP0057_ProductionPlanLine_JV.cs:527 | if (checkPlantSite == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-66ffb646 | FindButton | SCP0057_ProductionPlanLine_JV.cs:539 | if (strValue == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00352") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-1923a99b | FindButton | SCP0057_ProductionPlanLine_JV.cs:540 | if (strValue == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0057_ProductionPlanLine_JV.FindData_Division

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e375205c | this.Load | SCP0057_ProductionPlanLine_JV.cs:3458 |  | STATE | clbPlantSite.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-602d4a0d | this.Load | SCP0057_ProductionPlanLine_JV.cs:3461 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SystemMgmt.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-98b98efe | this.Load | SCP0057_ProductionPlanLine_JV.cs:3465 | lambda | ENDPOINT | new FoxDataRequest | ("SystemManager.UP_FX_GetUserGroupAuthExtentionList") ⇒ SystemManager.UP_FX_GetUserGroupAuthExtentionList | 엔드포인트 요청 생성 |  |  |  |
| AC-10d7cefb | this.Load | SCP0057_ProductionPlanLine_JV.cs:3467 | lambda | DATA_OP | request.Parameters["GroupID"] | "JV Planner" | 행/컬럼 값 대입 |  |  |  |
| AC-e9e9c18b | this.Load | SCP0057_ProductionPlanLine_JV.cs:3468 | lambda | DATA_OP | request.Parameters["UserID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-57b0a204 | this.Load | SCP0057_ProductionPlanLine_JV.cs:3469 | lambda | DATA_OP | request.Parameters["AuthType"] | "J" | 행/컬럼 값 대입 |  |  |  |
| AC-418d9f2a | this.Load | SCP0057_ProductionPlanLine_JV.cs:3470 | lambda | DATA_OP | request.Parameters["DivisionID"] | string.Empty | 행/컬럼 값 대입 |  |  |  |
| AC-ce52b73b | this.Load | SCP0057_ProductionPlanLine_JV.cs:3471 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-8bd334bf | this.Load | SCP0057_ProductionPlanLine_JV.cs:3473 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-2d5c8ed2 | this.Load | SCP0057_ProductionPlanLine_JV.cs:3482 | for (i < ds.Tables[0].Rows.Count) | DATA_OP | dic_JV_Plant.Add | (Code, JV_PLANT_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-b7715b94 | this.Load | SCP0057_ProductionPlanLine_JV.cs:3485 |  | STATE | clbPlantSite.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## SCP0057_ProductionPlanLine_JV.FindData_Main

진입점: this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName)) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Equals("S"))] / this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName)) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Equals("S"))] / btnNew.Click [if (popup.Di…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-223b2885 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SCP0057_ProductionPlanLine_JV.cs:1738 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-9a0ba63b | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SCP0057_ProductionPlanLine_JV.cs:1745 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-f36130d6 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SCP0057_ProductionPlanLine_JV.cs:1745 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a164cad0 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SCP0057_ProductionPlanLine_JV.cs:1747 | try | VALIDATE | DateUtil.Check_PeriodDate_New | (drpPeriod, "1", "7") | 프레임워크 검증 |  |  |  |
| AC-92e38620 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SCP0057_ProductionPlanLine_JV.cs:1747 | try ▸ if (!DateUtil.Check_PeriodDate_New(drpPeriod, "1", "7")) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ade61699 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SCP0057_ProductionPlanLine_JV.cs:1748 | try ▸ if (!Check_LineAssign()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e4fab435 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SCP0057_ProductionPlanLine_JV.cs:1752 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-dc80bb31 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SCP0057_ProductionPlanLine_JV.cs:1794 | try | UI_PROP | proxyPivot.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-c8299ab2 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SCP0057_ProductionPlanLine_JV.cs:1796 | try | ENDPOINT | proxyPivot.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, GSCM_SCP_ANALYS… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-de2e86ab | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SCP0057_ProductionPlanLine_JV.cs:1799 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0013_GET_PRODUCTION_PLAN_LINEBY") ⇒ SCP.SCP0013_GET_PRODUCTION_PLAN_LINEBY | 엔드포인트 요청 생성 |  |  |  |
| AC-cdffcf9e | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SCP0057_ProductionPlanLine_JV.cs:1800 | try ▸ lambda | UI_PROP | req.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-c6aba2ea | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SCP0057_ProductionPlanLine_JV.cs:1801 | try ▸ lambda | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-0b0c556f | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SCP0057_ProductionPlanLine_JV.cs:1802 | try ▸ lambda | DATA_OP | req.Parameters["p_operation_group"] | p_operation_group | 행/컬럼 값 대입 |  |  |  |
| AC-0308de72 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SCP0057_ProductionPlanLine_JV.cs:1803 | try ▸ lambda | DATA_OP | req.Parameters["p_scm_site_id"] | p_scm_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-d40756f1 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SCP0057_ProductionPlanLine_JV.cs:1804 | try ▸ lambda | DATA_OP | req.Parameters["p_line_id"] | p_line_id | 행/컬럼 값 대입 |  |  |  |
| AC-39bc9eb1 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SCP0057_ProductionPlanLine_JV.cs:1805 | try ▸ lambda | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-cb3a90c6 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SCP0057_ProductionPlanLine_JV.cs:1806 | try ▸ lambda | DATA_OP | req.Parameters["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-58f9552b | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SCP0057_ProductionPlanLine_JV.cs:1807 | try ▸ lambda | DATA_OP | req.Parameters["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-adc1dc0c | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SCP0057_ProductionPlanLine_JV.cs:1808 | try ▸ lambda | DATA_OP | req.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-98bd9114 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SCP0057_ProductionPlanLine_JV.cs:1809 | try ▸ lambda | DATA_OP | req.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-c4dba5b8 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SCP0057_ProductionPlanLine_JV.cs:1810 | try ▸ lambda | DATA_OP | req.Parameters["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-799b681e | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SCP0057_ProductionPlanLine_JV.cs:1811 | try ▸ lambda | DATA_OP | req.Parameters["p_program_id"] | p_program_id | 행/컬럼 값 대입 |  |  |  |
| AC-0774dd02 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SCP0057_ProductionPlanLine_JV.cs:1812 | try ▸ lambda | DATA_OP | req.Parameters["p_sheet_name"] | p_sheet_name | 행/컬럼 값 대입 |  |  |  |
| AC-03433683 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SCP0057_ProductionPlanLine_JV.cs:1813 | try ▸ lambda | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-44fcbf5d | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SCP0057_ProductionPlanLine_JV.cs:1814 | try ▸ lambda | DATA_OP | req.Parameters["p_electrode_type"] | p_electrode_type | 행/컬럼 값 대입 |  |  |  |
| AC-d254ab2b | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SCP0057_ProductionPlanLine_JV.cs:1815 | try ▸ lambda | DATA_OP | req.Parameters["p_nick_name"] | p_nick_name | 행/컬럼 값 대입 |  |  |  |
| AC-ddbed13c | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SCP0057_ProductionPlanLine_JV.cs:1816 | try ▸ lambda | DATA_OP | req.Parameters["p_cell_type_gr"] | p_cell_type_gr | 행/컬럼 값 대입 |  |  |  |
| AC-de5c51f2 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SCP0057_ProductionPlanLine_JV.cs:1817 | try ▸ lambda | DATA_OP | req.Parameters["p_line_assign"] | p_line_assign | 행/컬럼 값 대입 |  |  |  |
| AC-4ed78553 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SCP0057_ProductionPlanLine_JV.cs:1818 | try ▸ lambda | DATA_OP | req.Parameters["p_bucket"] | p_bucket | 행/컬럼 값 대입 |  |  |  |
| AC-5aecc859 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SCP0057_ProductionPlanLine_JV.cs:1819 | try ▸ lambda | DATA_OP | req.Parameters["p_chk_all"] | p_chk_all | 행/컬럼 값 대입 |  |  |  |
| AC-6cad0c72 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SCP0057_ProductionPlanLine_JV.cs:1820 | try ▸ lambda | DATA_OP | req.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-e161183c | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SCP0057_ProductionPlanLine_JV.cs:1821 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-b972fcd8 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SCP0057_ProductionPlanLine_JV.cs:1822 | try ▸ lambda | RETURN | return res.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-46781f70 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SCP0057_ProductionPlanLine_JV.cs:1830 | try | GRID_BIND | siMain.Query | (dsBinding) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-d7e34ac0 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SCP0057_ProductionPlanLine_JV.cs:1832 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-9ce03f32 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SCP0057_ProductionPlanLine_JV.cs:1833 | try | UI_MISC | SetSearchCount | (dsBinding) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-7151c306 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SCP0057_ProductionPlanLine_JV.cs:1836 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d27c3561 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SCP0057_ProductionPlanLine_JV.cs:1856 | try ▸ if (dsBinding.Tables.Count > 0) | FLAG | dtFix | dsBinding.Tables[1] | 화면 필드/플래그 변경 |  |  |  |
| AC-ca32f457 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SCP0057_ProductionPlanLine_JV.cs:1867 | try ▸ if (this.nSelRowOfMain >= 0 && isReload) | GRID_STYLE | siMain.ActiveSheet.SetActiveCell | (this.nSelRowOfMain, this.nSelColOfMain) | 그리드 표시 설정 |  |  |  |
| AC-5a5785ae | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SCP0057_ProductionPlanLine_JV.cs:1868 | try ▸ if (this.nSelRowOfMain >= 0 && isReload) | CALL_EXT | spdMain.ShowCell | (0, 0, this.nSelRowOfMain, this.nSelColOfMain, FarPoint.Win.Spread.VerticalPosition.Center… | ⚠ 의미 확인 필요 |  |  |  |
| AC-2783e8f4 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SCP0057_ProductionPlanLine_JV.cs:1872 | try | FLAG | cellclipboardPast | false | 화면 필드/플래그 변경 |  |  |  |
| AC-a062c19d | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SCP0057_ProductionPlanLine_JV.cs:1876 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-15ef150f | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SCP0057_ProductionPlanLine_JV.cs:1882 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0057_ProductionPlanLine_JV.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-67f1ef8e | this.Load | SCP0057_ProductionPlanLine_JV.cs:189 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-3b8ea50c | this.Load | SCP0057_ProductionPlanLine_JV.cs:196 |  | FLAG | dtSpdTitle | GetSpdTitle2("SCP0013", UserInfo.UserId, SpdSheet.shtMain) | 화면 필드/플래그 변경 |  |  |  |

## SCP0057_ProductionPlanLine_JV.Get_IsEditInfo

진입점: btnNew.Click [if (popup.DialogResult == DialogResult.OK) ▸ if (MessageHelper.GMessageBox("MSG00265") == DialogResult.Yes)] / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-99e4b29a | btnNew.Click [if (popup.DialogResult == DialogResult.OK) ▸ i… 외 1 | SCP0057_ProductionPlanLine_JV.cs:2769 | if (division == null \|\| division == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-70d7276a | btnNew.Click [if (popup.DialogResult == DialogResult.OK) ▸ i… 외 1 | SCP0057_ProductionPlanLine_JV.cs:2791 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0013_GET_PLAN_EDIT_INFO") ⇒ SCP.SCP0013_GET_PLAN_EDIT_INFO | 엔드포인트 요청 생성 |  |  |  |
| AC-d5b2a404 | btnNew.Click [if (popup.DialogResult == DialogResult.OK) ▸ i… 외 1 | SCP0057_ProductionPlanLine_JV.cs:2793 |  | UI_PROP | request.CommandTimeout | 10 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-5125fbf7 | btnNew.Click [if (popup.DialogResult == DialogResult.OK) ▸ i… 외 1 | SCP0057_ProductionPlanLine_JV.cs:2795 |  | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-516d5944 | btnNew.Click [if (popup.DialogResult == DialogResult.OK) ▸ i… 외 1 | SCP0057_ProductionPlanLine_JV.cs:2796 |  | DATA_OP | request.Parameters["p_operation_group"] | p_operation_group | 행/컬럼 값 대입 |  |  |  |
| AC-a8e40a7b | btnNew.Click [if (popup.DialogResult == DialogResult.OK) ▸ i… 외 1 | SCP0057_ProductionPlanLine_JV.cs:2797 |  | DATA_OP | request.Parameters["p_scm_site_id"] | p_scm_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-4ba89950 | btnNew.Click [if (popup.DialogResult == DialogResult.OK) ▸ i… 외 1 | SCP0057_ProductionPlanLine_JV.cs:2798 |  | DATA_OP | request.Parameters["p_line_id"] | p_line_id | 행/컬럼 값 대입 |  |  |  |
| AC-3f2d9e96 | btnNew.Click [if (popup.DialogResult == DialogResult.OK) ▸ i… 외 1 | SCP0057_ProductionPlanLine_JV.cs:2799 |  | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-aad0041a | btnNew.Click [if (popup.DialogResult == DialogResult.OK) ▸ i… 외 1 | SCP0057_ProductionPlanLine_JV.cs:2800 |  | DATA_OP | request.Parameters["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-bea7b3be | btnNew.Click [if (popup.DialogResult == DialogResult.OK) ▸ i… 외 1 | SCP0057_ProductionPlanLine_JV.cs:2801 |  | DATA_OP | request.Parameters["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-c33bb1c4 | btnNew.Click [if (popup.DialogResult == DialogResult.OK) ▸ i… 외 1 | SCP0057_ProductionPlanLine_JV.cs:2802 |  | DATA_OP | request.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-cf2bc80b | btnNew.Click [if (popup.DialogResult == DialogResult.OK) ▸ i… 외 1 | SCP0057_ProductionPlanLine_JV.cs:2803 |  | DATA_OP | request.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-607fbe09 | btnNew.Click [if (popup.DialogResult == DialogResult.OK) ▸ i… 외 1 | SCP0057_ProductionPlanLine_JV.cs:2804 |  | DATA_OP | request.Parameters["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-ec3660c1 | btnNew.Click [if (popup.DialogResult == DialogResult.OK) ▸ i… 외 1 | SCP0057_ProductionPlanLine_JV.cs:2805 |  | DATA_OP | request.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-952d5ad4 | btnNew.Click [if (popup.DialogResult == DialogResult.OK) ▸ i… 외 1 | SCP0057_ProductionPlanLine_JV.cs:2807 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-c3ee3fc2 | btnNew.Click [if (popup.DialogResult == DialogResult.OK) ▸ i… 외 1 | SCP0057_ProductionPlanLine_JV.cs:2814 | if (dsBinding.Tables.Count > 0) | FLAG | dtIsEditInfo | dsBinding.Tables[0] | 화면 필드/플래그 변경 |  |  |  |

## SCP0057_ProductionPlanLine_JV.Get_IsSaveYn

진입점: this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName))] / this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))] / btnNew.Click / SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-be2f8b8c | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 3 | SCP0057_ProductionPlanLine_JV.cs:2828 | if (division == null \|\| division == "") | RETURN | return saveYn; |  | 처리 중단/반환 |  |  |  |
| AC-dd9403fb | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 3 | SCP0057_ProductionPlanLine_JV.cs:2839 | try | ENDPOINT | new FoxDataRequest | ("SCP.SCP0013_GET_PLAN_TYPE_SAVE_YN") ⇒ SCP.SCP0013_GET_PLAN_TYPE_SAVE_YN | 엔드포인트 요청 생성 |  |  |  |
| AC-68edf395 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 3 | SCP0057_ProductionPlanLine_JV.cs:2840 | try | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-64889766 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 3 | SCP0057_ProductionPlanLine_JV.cs:2841 | try | DATA_OP | request.Parameters["p_start_yyyymmdd"] | p_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-6d82c646 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 3 | SCP0057_ProductionPlanLine_JV.cs:2842 | try | DATA_OP | request.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-cd2a3925 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 3 | SCP0057_ProductionPlanLine_JV.cs:2844 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-ade16094 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 3 | SCP0057_ProductionPlanLine_JV.cs:2853 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-17cd4334 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 3 | SCP0057_ProductionPlanLine_JV.cs:2858 | if (!saveYn) | MESSAGE | MessageHelper.GMessageBox | ("MSG00182") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d4a78bc5 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 3 | SCP0057_ProductionPlanLine_JV.cs:2860 |  | RETURN | return saveYn; |  | 처리 중단/반환 |  |  |  |

## SCP0057_ProductionPlanLine_JV.GetBucketType

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-efc566d9 | this.Load | SCP0057_ProductionPlanLine_JV.cs:1522 |  | ENDPOINT | new FoxDataRequest | ("DM.DM0003_GET_BUCKET_TYPE_CODE") ⇒ DM.DM0003_GET_BUCKET_TYPE_CODE | 엔드포인트 요청 생성 |  |  |  |
| AC-1a7aadf1 | this.Load | SCP0057_ProductionPlanLine_JV.cs:1523 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-1c9e9d87 | this.Load | SCP0057_ProductionPlanLine_JV.cs:1526 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SCP0057_ProductionPlanLine_JV.GetDayRange

진입점: this.Load / cboPlanDate.SelectedIndexChanged / btnW26.Click / btnW52.Click / btnWLast.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4f9ff3f0 | this.Load 외 4 | SCP0057_ProductionPlanLine_JV.cs:3434 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCM0001_GET_SCP_DAY_PERIOD") ⇒ SCP.SCM0001_GET_SCP_DAY_PERIOD | 엔드포인트 요청 생성 |  |  |  |
| AC-7e2b4520 | this.Load 외 4 | SCP0057_ProductionPlanLine_JV.cs:3435 |  | DATA_OP | request.Parameters["p_from_date"] | p_plan_start_date == null ? "" : p_plan_start_date | 행/컬럼 값 대입 |  |  |  |
| AC-4d215604 | this.Load 외 4 | SCP0057_ProductionPlanLine_JV.cs:3436 |  | DATA_OP | request.Parameters["p_offset_day"] | Convert.ToInt32(periodType) * 7 - 1 | 행/컬럼 값 대입 |  |  |  |
| AC-d1362ad8 | this.Load 외 4 | SCP0057_ProductionPlanLine_JV.cs:3437 |  | DATA_OP | request.Parameters["p_timezone"] | UserInfoContext.Current[UserInfoProperites.TimeZone] | 행/컬럼 값 대입 |  |  |  |
| AC-0480b873 | this.Load 외 4 | SCP0057_ProductionPlanLine_JV.cs:3438 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-cd760fa5 | this.Load 외 4 | SCP0057_ProductionPlanLine_JV.cs:3440 |  | RETURN | return sDayRange; |  | 처리 중단/반환 |  |  |  |

## SCP0057_ProductionPlanLine_JV.GetLastPlanVersion

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7e3537b0 | (진입점 미연결) | SCP0057_ProductionPlanLine_JV.cs:1686 | try | ENDPOINT | new FoxDataRequest | ("SCP.SCP0011_GET_LAST_PLAN_VERSION") ⇒ SCP.SCP0011_GET_LAST_PLAN_VERSION | 엔드포인트 요청 생성 |  |  |  |
| AC-22062949 | (진입점 미연결) | SCP0057_ProductionPlanLine_JV.cs:1688 | try | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-e6b191d1 | (진입점 미연결) | SCP0057_ProductionPlanLine_JV.cs:1689 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-1304f67c | (진입점 미연결) | SCP0057_ProductionPlanLine_JV.cs:1705 | try ▸ if (dsBinding.Tables.Count > 0 && dsBinding.Tables[0].Rows.Count > 0) | VALUE_SET | cboPlanDate.SelectedValue | PLAN_START_YYYYMMDD | 컨트롤 값 설정 |  |  |  |
| AC-b151125a | (진입점 미연결) | SCP0057_ProductionPlanLine_JV.cs:1706 | try ▸ if (dsBinding.Tables.Count > 0 && dsBinding.Tables[0].Rows.Count > 0) | VALUE_SET | cboPlanType.SelectedValue | PLAN_TYPE | 컨트롤 값 설정 |  |  |  |
| AC-f837b4c5 | (진입점 미연결) | SCP0057_ProductionPlanLine_JV.cs:1707 | try ▸ if (dsBinding.Tables.Count > 0 && dsBinding.Tables[0].Rows.Count > 0) | VALUE_SET | cboPlanSeq.SelectedValue | PLAN_SEQ | 컨트롤 값 설정 |  |  |  |

## SCP0057_ProductionPlanLine_JV.GetLastRange

진입점: this.Load / cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e6a90ac9 | this.Load 외 1 | SCP0057_ProductionPlanLine_JV.cs:3419 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCM0001_GET_SCP_DAILY_PLAN_PERIOD") ⇒ SCP.SCM0001_GET_SCP_DAILY_PLAN_PERIOD | 엔드포인트 요청 생성 |  |  |  |
| AC-51454098 | this.Load 외 1 | SCP0057_ProductionPlanLine_JV.cs:3420 |  | DATA_OP | request.Parameters["p_division_id"] | divisionId | 행/컬럼 값 대입 |  |  |  |
| AC-f82b2d9a | this.Load 외 1 | SCP0057_ProductionPlanLine_JV.cs:3421 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-0e613333 | this.Load 외 1 | SCP0057_ProductionPlanLine_JV.cs:3423 |  | RETURN | return dailyPlanPeriod; |  | 처리 중단/반환 |  |  |  |

## SCP0057_ProductionPlanLine_JV.GetSpdTitle

진입점: this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName)) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Equals("S")) ▸ try] / this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName)) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Equals("S")) ▸ try] / this.Load / th…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-60e8ee80 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 11 | SCP0057_ProductionPlanLine_JV.cs:3404 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN") ⇒ SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | 엔드포인트 요청 생성 |  |  |  |
| AC-91ede90f | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 11 | SCP0057_ProductionPlanLine_JV.cs:3406 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | drpPeriod.Text1.Replace("-", "") | 행/컬럼 값 대입 |  |  |  |
| AC-c9c82147 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 11 | SCP0057_ProductionPlanLine_JV.cs:3407 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | drpPeriod.Text2.Replace("-", "") | 행/컬럼 값 대입 |  |  |  |
| AC-7461c181 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 11 | SCP0057_ProductionPlanLine_JV.cs:3409 |  | FLAG | dsSpdTitle | client.ExecuteDataSet(request).DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-d956396d | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 11 | SCP0057_ProductionPlanLine_JV.cs:3409 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## SCP0057_ProductionPlanLine_JV.GetSpdTitle2

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-50868ab6 | this.Load | SCP0057_ProductionPlanLine_JV.cs:3124 | try | ENDPOINT | new FoxDataRequest | ("SCM.SCM_SYS_GET_SPREAD_TITLE") ⇒ SCM.SCM_SYS_GET_SPREAD_TITLE | 엔드포인트 요청 생성 |  |  |  |
| AC-ae585c3b | this.Load | SCP0057_ProductionPlanLine_JV.cs:3125 | try | DATA_OP | request.Parameters["p_program_id"] | programID | 행/컬럼 값 대입 |  |  |  |
| AC-5f9a2757 | this.Load | SCP0057_ProductionPlanLine_JV.cs:3126 | try | DATA_OP | request.Parameters["p_user_id"] | userID | 행/컬럼 값 대입 |  |  |  |
| AC-4fdefe01 | this.Load | SCP0057_ProductionPlanLine_JV.cs:3127 | try | DATA_OP | request.Parameters["p_sheet_name"] | sheetName | 행/컬럼 값 대입 |  |  |  |
| AC-285df70e | this.Load | SCP0057_ProductionPlanLine_JV.cs:3129 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-e8338765 | this.Load | SCP0057_ProductionPlanLine_JV.cs:3139 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SCP0057_ProductionPlanLine_JV.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-726f8df3 | this.Load | SCP0057_ProductionPlanLine_JV.cs:230 |  | DATA_OP | this.ConditionNotUseList.Add | (cboPlanDate) | 데이터 객체 조작/조회 |  |  |  |
| AC-ac8f38c5 | this.Load | SCP0057_ProductionPlanLine_JV.cs:231 |  | DATA_OP | this.ConditionNotUseList.Add | (cboPlanType) | 데이터 객체 조작/조회 |  |  |  |
| AC-9e441f23 | this.Load | SCP0057_ProductionPlanLine_JV.cs:232 |  | DATA_OP | this.ConditionNotUseList.Add | (cboPlanSeq) | 데이터 객체 조작/조회 |  |  |  |
| AC-d8e7ea70 | this.Load | SCP0057_ProductionPlanLine_JV.cs:236 | if (dtMyDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |
| AC-25965651 | this.Load | SCP0057_ProductionPlanLine_JV.cs:237 | if (dtMyDivision.Rows.Count == 0) | STATE | btnLoad.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-c407b7f4 | this.Load | SCP0057_ProductionPlanLine_JV.cs:240 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-2ff5113f | this.Load | SCP0057_ProductionPlanLine_JV.cs:242 |  | LIST_REBIND | clsCtrl.setListBox | (dtMyDivision, cboDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-19eca742 | this.Load | SCP0057_ProductionPlanLine_JV.cs:245 |  | LIST_REBIND | clsCtrl.setListBox | (dtElectrodeType, cboElectrode, false) | 목록 컨트롤 재구성 |  |  |  |
| AC-f716907b | this.Load | SCP0057_ProductionPlanLine_JV.cs:246 |  | LIST_REBIND | clsCtrl.setListBox | (dtCellTypeGr, cboCellTypeGr, false) | 목록 컨트롤 재구성 |  |  |  |
| AC-7050f9ca | this.Load | SCP0057_ProductionPlanLine_JV.cs:250 |  | FLAG | dtBucketType | GetBucketType() | 화면 필드/플래그 변경 |  |  |  |
| AC-c54dcf90 | this.Load | SCP0057_ProductionPlanLine_JV.cs:251 |  | LIST_REBIND | clsCtrl.setListBox | (dtBucketType, cboBucketType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-e0fdf869 | this.Load | SCP0057_ProductionPlanLine_JV.cs:254 |  | VALUE_SET | drpPeriod.InitValue | GetDayRange(PeriodType.W52) | 컨트롤 값 설정 |  |  |  |
| AC-53c69a6f | this.Load | SCP0057_ProductionPlanLine_JV.cs:265 | if (dailyPlanPeriod == PeriodType.W52) | UI_PROP | layoutControlItem18.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-44eb47fb | this.Load | SCP0057_ProductionPlanLine_JV.cs:268 |  | VALUE_SET | btnWLast.Text | "W" + dailyPlanPeriod | 컨트롤 값 설정 |  |  |  |

## SCP0057_ProductionPlanLine_JV.InitSpread

진입점: this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName)) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Equals("S")) ▸ try] / this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName)) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Equals("S")) ▸ try] / this.Load / th…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bb53dd23 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 11 | SCP0057_ProductionPlanLine_JV.cs:288 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.InitSheet | (SpdSheet.shtMain) | 그리드 재구성/초기화 |  |  |  |
| AC-7dbc8695 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 11 | SCP0057_ProductionPlanLine_JV.cs:289 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_SET | spdInfo.ActiveSheet.DataSource | null | 그리드 속성/값 설정 |  |  |  |
| AC-cfc4a9cb | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 11 | SCP0057_ProductionPlanLine_JV.cs:290 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.SetSheetHeaderColumn | (spdInfo, 3) | 그리드 재구성/초기화 |  |  |  |
| AC-8a66e514 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 11 | SCP0057_ProductionPlanLine_JV.cs:295 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-17f63610 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 11 | SCP0057_ProductionPlanLine_JV.cs:296 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-830de421 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 11 | SCP0057_ProductionPlanLine_JV.cs:300 | if (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (!division.Substring(0, 2).Equals("EE")) | GRID_SET | spdInfo.ActiveSheet.Columns[siMain.GetColumnIndex("ORIGIN_DIVISION_ID")].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-9021a6a4 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 11 | SCP0057_ProductionPlanLine_JV.cs:301 | if (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (!division.Substring(0, 2).Equals("EE")) | GRID_SET | spdInfo.ActiveSheet.Columns[siMain.GetColumnIndex("ELECTRODE_TYPE")].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-8fc27ff8 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 11 | SCP0057_ProductionPlanLine_JV.cs:304 | if (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (!division.Substring(0, 2).Equals("EE")) ▸ if (division == "40") | GRID_SET | spdInfo.ActiveSheet.Columns[siMain.GetColumnIndex("CELL_TYPE_GROUP_CODE")].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-07cfae9c | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 11 | SCP0057_ProductionPlanLine_JV.cs:306 | if (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (!division.Substring(0, 2).Equals("EE")) ▸ else of (division == "40") | GRID_SET | spdInfo.ActiveSheet.Columns[siMain.GetColumnIndex("CELL_TYPE_GROUP_CODE")].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-484d9743 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 11 | SCP0057_ProductionPlanLine_JV.cs:311 | if (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (!division.Substring(0, 2).Equals("EE")) | GRID_SET | spdInfo.ActiveSheet.Columns[siMain.GetColumnIndex("ORIGIN_DIVISION_ID")].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-5d48a9a5 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 11 | SCP0057_ProductionPlanLine_JV.cs:312 | if (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (!division.Substring(0, 2).Equals("EE")) | GRID_SET | spdInfo.ActiveSheet.Columns[siMain.GetColumnIndex("ELECTRODE_TYPE")].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-175b3f32 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 11 | SCP0057_ProductionPlanLine_JV.cs:313 | if (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (!division.Substring(0, 2).Equals("EE")) | GRID_SET | spdInfo.ActiveSheet.Columns[siMain.GetColumnIndex("CELL_TYPE_GROUP_CODE")].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-8fcf08f6 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 11 | SCP0057_ProductionPlanLine_JV.cs:316 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_SET | spdInfo.ActiveSheet.Columns[spdInfo.GetColumnIndex("EXTRA_SPEC")].Visible | (division == "40") | 그리드 속성/값 설정 |  |  |  |

## SCP0057_ProductionPlanLine_JV.InitSpreadDateColumn

진입점: this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName)) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Equals("S")) ▸ try ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName)) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].To…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-54a2c79e | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 11 | SCP0057_ProductionPlanLine_JV.cs:355 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sColumnName.IndexOf("B_") > 0) | GRID_INIT | spdInfo.AddTextColumn | (sColumnLabelname, sColumnName, FPMerge.None, 0, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f2c0f7e0 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 11 | SCP0057_ProductionPlanLine_JV.cs:359 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sColumnName.IndexOf("B_") > 0) | GRID_INIT | spdInfo.AddNumColumn | (sColumnLabelname, sColumnName, FPMerge.None, 70, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3942c81e | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 11 | SCP0057_ProductionPlanLine_JV.cs:360 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sColumnName.IndexOf("B_") > 0) | GRID_INIT | spdInfo.SetReNumerCellType | (spdInfo, spdInfo.GetColumnIndex(sColumnName), 0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-2d510c71 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 11 | SCP0057_ProductionPlanLine_JV.cs:364 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sColumnName.IndexOf("B_") > 0) ▸ if (sDayCode == DefColumnsLabel.Saturday \|\| … | GRID_SET | spdInfo.Sheet().ColumnHeader.Cells[2, spdInfo.GetMaxColumnIndex()].ForeColor | sDayCode == DefColumnsLabel.Saturday ? Color.Blue : Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-7948bdff | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 11 | SCP0057_ProductionPlanLine_JV.cs:371 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c2367a8c | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 11 | SCP0057_ProductionPlanLine_JV.cs:372 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5e6434c7 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 11 | SCP0057_ProductionPlanLine_JV.cs:377 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-118c064f | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 11 | SCP0057_ProductionPlanLine_JV.cs:378 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 30, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0b81ca76 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 11 | SCP0057_ProductionPlanLine_JV.cs:386 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName != sSmallLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b60b9f71 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 11 | SCP0057_ProductionPlanLine_JV.cs:387 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName != sSmallLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c2f9a053 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 11 | SCP0057_ProductionPlanLine_JV.cs:397 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-bf1c71d4 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 11 | SCP0057_ProductionPlanLine_JV.cs:398 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-900c629a | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 11 | SCP0057_ProductionPlanLine_JV.cs:399 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-89c7cef2 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 11 | SCP0057_ProductionPlanLine_JV.cs:400 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0057_ProductionPlanLine_JV.SaveData_FixInfo

진입점: this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName))] / this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7b95d1f0 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0057_ProductionPlanLine_JV.cs:2267 | if (fps.Name == "spdMain") | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-609e35fc | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0057_ProductionPlanLine_JV.cs:2277 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (siMain.ActiveSheet.Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e2590913 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0057_ProductionPlanLine_JV.cs:2282 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("A", typeof(char)) | 데이터 객체 조작/조회 |  |  |  |
| AC-becfa810 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0057_ProductionPlanLine_JV.cs:2283 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_active_flag") | 데이터 객체 조작/조회 |  |  |  |
| AC-9d160ef6 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0057_ProductionPlanLine_JV.cs:2284 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_division_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-139b7d73 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0057_ProductionPlanLine_JV.cs:2285 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_plan_start_yyyymmdd") | 데이터 객체 조작/조회 |  |  |  |
| AC-0c829d42 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0057_ProductionPlanLine_JV.cs:2286 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_plan_type") | 데이터 객체 조작/조회 |  |  |  |
| AC-6bc1f0c1 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0057_ProductionPlanLine_JV.cs:2287 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_seq") | 데이터 객체 조작/조회 |  |  |  |
| AC-1fff9404 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0057_ProductionPlanLine_JV.cs:2288 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_operation_group") | 데이터 객체 조작/조회 |  |  |  |
| AC-3be81bd4 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0057_ProductionPlanLine_JV.cs:2289 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_scm_site_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-e33593a7 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0057_ProductionPlanLine_JV.cs:2290 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_item_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-5417f5cc | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0057_ProductionPlanLine_JV.cs:2291 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_line_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-23f44837 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0057_ProductionPlanLine_JV.cs:2292 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_operation_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-420c1099 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0057_ProductionPlanLine_JV.cs:2293 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_measure") | 데이터 객체 조작/조회 |  |  |  |
| AC-f608eae8 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0057_ProductionPlanLine_JV.cs:2294 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_yyyymmdd") | 데이터 객체 조작/조회 |  |  |  |
| AC-d8e4bf48 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0057_ProductionPlanLine_JV.cs:2295 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_qty") | 데이터 객체 조작/조회 |  |  |  |
| AC-ca6468c5 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0057_ProductionPlanLine_JV.cs:2296 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_fix_reason") | 데이터 객체 조작/조회 |  |  |  |
| AC-3c3f3609 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0057_ProductionPlanLine_JV.cs:2297 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_user_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-3a49e696 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0057_ProductionPlanLine_JV.cs:2298 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_fix") | 데이터 객체 조작/조회 |  |  |  |
| AC-1ff7dd5b | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0057_ProductionPlanLine_JV.cs:2299 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_loc_flag") | 데이터 객체 조작/조회 |  |  |  |
| AC-a3a5aba6 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0057_ProductionPlanLine_JV.cs:2300 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_program_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-2a9367a7 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0057_ProductionPlanLine_JV.cs:2301 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("debug_mode") | 데이터 객체 조작/조회 |  |  |  |
| AC-fd8e4da7 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0057_ProductionPlanLine_JV.cs:2302 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_origin_division_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-8a46d209 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0057_ProductionPlanLine_JV.cs:2303 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_electrode_type") | 데이터 객체 조작/조회 |  |  |  |
| AC-7d31bc36 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0057_ProductionPlanLine_JV.cs:2304 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_bucket_type") | 데이터 객체 조작/조회 |  |  |  |
| AC-fe553055 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0057_ProductionPlanLine_JV.cs:2305 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_from_yyyymmdd") | 데이터 객체 조작/조회 |  |  |  |
| AC-7556f05e | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0057_ProductionPlanLine_JV.cs:2306 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_to_yyyymmdd") | 데이터 객체 조작/조회 |  |  |  |
| AC-b78d7d12 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0057_ProductionPlanLine_JV.cs:2307 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dsInput.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-36a3f1fb | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0057_ProductionPlanLine_JV.cs:2341 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (selCells.Length < 1) | MESSAGE | MessageHelper.GMessageBox | ("MSG00134", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-303aea9f | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0057_ProductionPlanLine_JV.cs:2342 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (selCells.Length < 1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4551af77 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0057_ProductionPlanLine_JV.cs:2348 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (fixType == "F") | POPUP | new SCM0002_RejectReasonPopup | ("Fix Reason") | 팝업/폼 생성 |  |  |  |
| AC-aecddb4d | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0057_ProductionPlanLine_JV.cs:2349 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (fixType == "F") | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-70af8218 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0057_ProductionPlanLine_JV.cs:2350 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (fixType == "F") | UI_PROP | popup.Width | 600 | 속성 Width 설정 |  |  |  |
| AC-bebf3639 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0057_ProductionPlanLine_JV.cs:2351 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (fixType == "F") | UI_PROP | popup.Height | 230 | 속성 Height 설정 |  |  |  |
| AC-41102614 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0057_ProductionPlanLine_JV.cs:2353 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (fixType == "F") | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-dcd5d854 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0057_ProductionPlanLine_JV.cs:2362 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (fixType == "F") ▸ else of (popup.ShowDial… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-bbef2d68 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0057_ProductionPlanLine_JV.cs:2369 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ else of (fixType == "F") | MESSAGE | MessageHelper.GMessageBox | ("MSG00016") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-82e7f7b7 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0057_ProductionPlanLine_JV.cs:2369 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ else of (fixType == "F") ▸ if (MessageHelper.… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-53906841 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0057_ProductionPlanLine_JV.cs:2418 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | GRID_STYLE | siMain.SetBGColor | (i, j, i, j, ControlColor.InvalidColor) | 그리드 표시 설정 |  |  |  |
| AC-6c2f877a | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0057_ProductionPlanLine_JV.cs:2419 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | MESSAGE | MessageHelper.GMessageBox | ("MSG00026", new object[] { null }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-10f8da62 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0057_ProductionPlanLine_JV.cs:2420 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c27164cb | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0057_ProductionPlanLine_JV.cs:2426 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | CALL_EXT | siMain.GetBGColor | (i, j) | ⚠ 의미 확인 필요 |  |  |  |
| AC-4ce1f25d | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0057_ProductionPlanLine_JV.cs:2458 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | DATA_OP | dsInput.Tables[0].NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-8a6f8812 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0057_ProductionPlanLine_JV.cs:2459 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | DATA_OP | dr["p_active_flag"] | strAction | 행/컬럼 값 대입 |  |  |  |
| AC-72b3b76d | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0057_ProductionPlanLine_JV.cs:2460 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | DATA_OP | dr["p_division_id"] | str_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-56991626 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0057_ProductionPlanLine_JV.cs:2461 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | DATA_OP | dr["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-047e2301 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0057_ProductionPlanLine_JV.cs:2462 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | DATA_OP | dr["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-4cab6bc6 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0057_ProductionPlanLine_JV.cs:2463 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | DATA_OP | dr["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-2470a31b | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0057_ProductionPlanLine_JV.cs:2464 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | DATA_OP | dr["p_operation_group"] | str_operation_group | 행/컬럼 값 대입 |  |  |  |
| AC-6fcc73c5 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0057_ProductionPlanLine_JV.cs:2465 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | DATA_OP | dr["p_scm_site_id"] | str_scm_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-a750c15c | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0057_ProductionPlanLine_JV.cs:2466 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | DATA_OP | dr["p_line_id"] | str_line_id | 행/컬럼 값 대입 |  |  |  |
| AC-25b3d589 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0057_ProductionPlanLine_JV.cs:2467 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | DATA_OP | dr["p_item_id"] | str_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-cccc1b95 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0057_ProductionPlanLine_JV.cs:2468 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | DATA_OP | dr["p_operation_id"] | str_operation_id | 행/컬럼 값 대입 |  |  |  |
| AC-9c88736d | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0057_ProductionPlanLine_JV.cs:2469 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | DATA_OP | dr["p_yyyymmdd"] | strYYYYMMDD | 행/컬럼 값 대입 |  |  |  |
| AC-44ca69ed | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0057_ProductionPlanLine_JV.cs:2470 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | DATA_OP | dr["p_qty"] | siMain.GetValue(i, j).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-29351ed8 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0057_ProductionPlanLine_JV.cs:2471 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | DATA_OP | dr["p_fix_reason"] | strReason | 행/컬럼 값 대입 |  |  |  |
| AC-464d6778 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0057_ProductionPlanLine_JV.cs:2472 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | DATA_OP | dr["p_origin_division_id"] | str_origin_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-6ff88089 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0057_ProductionPlanLine_JV.cs:2473 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | DATA_OP | dr["p_electrode_type"] | str_electrode_type | 행/컬럼 값 대입 |  |  |  |
| AC-934cb001 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0057_ProductionPlanLine_JV.cs:2474 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | DATA_OP | dr["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-118b4ddb | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0057_ProductionPlanLine_JV.cs:2475 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | DATA_OP | dr["p_bucket_type"] | p_bucket | 행/컬럼 값 대입 |  |  |  |
| AC-a6e2580d | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0057_ProductionPlanLine_JV.cs:2476 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | DATA_OP | dsInput.Tables[0].Rows.Add | (dr) | 데이터 객체 조작/조회 |  |  |  |
| AC-d0a86c5d | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0057_ProductionPlanLine_JV.cs:2492 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | CALL_EXT | siMain.GetBGColor | (i, j + nDayCntOfWeek) | ⚠ 의미 확인 필요 |  |  |  |
| AC-95ad8541 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0057_ProductionPlanLine_JV.cs:2501 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | GRID_STYLE | siMain.SetBGColor | (i, j + nDayCntOfWeek, i, j + nDayCntOfWeek, ControlColor.InvalidColor) | 그리드 표시 설정 |  |  |  |
| AC-ed8e157a | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0057_ProductionPlanLine_JV.cs:2502 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | MESSAGE | MessageHelper.GMessageBox | ("MSG00026", new object[] { null }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0227f11c | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0057_ProductionPlanLine_JV.cs:2503 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-eef3b945 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0057_ProductionPlanLine_JV.cs:2517 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | CALL_EXT | siMain.GetBGColor | (i, j) | ⚠ 의미 확인 필요 |  |  |  |
| AC-2b933271 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0057_ProductionPlanLine_JV.cs:2526 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | GRID_STYLE | siMain.SetBGColor | (i, j, i, j, ControlColor.InvalidColor) | 그리드 표시 설정 |  |  |  |
| AC-f9a632d4 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0057_ProductionPlanLine_JV.cs:2527 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | MESSAGE | MessageHelper.GMessageBox | ("MSG00026", new object[] { null }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-952174e6 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0057_ProductionPlanLine_JV.cs:2528 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4e8a00c5 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0057_ProductionPlanLine_JV.cs:2551 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | DATA_OP | dsInput.Tables[0].NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-5f90dcee | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0057_ProductionPlanLine_JV.cs:2552 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | DATA_OP | dr["p_active_flag"] | strAction | 행/컬럼 값 대입 |  |  |  |
| AC-b941afe1 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0057_ProductionPlanLine_JV.cs:2553 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | DATA_OP | dr["p_division_id"] | str_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-1b415159 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0057_ProductionPlanLine_JV.cs:2554 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | DATA_OP | dr["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-c87bf883 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0057_ProductionPlanLine_JV.cs:2555 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | DATA_OP | dr["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-0a75fcc7 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0057_ProductionPlanLine_JV.cs:2556 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | DATA_OP | dr["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-0b52a375 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0057_ProductionPlanLine_JV.cs:2557 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | DATA_OP | dr["p_operation_group"] | str_operation_group | 행/컬럼 값 대입 |  |  |  |
| AC-456f915c | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0057_ProductionPlanLine_JV.cs:2558 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | DATA_OP | dr["p_scm_site_id"] | str_scm_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-0d689574 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0057_ProductionPlanLine_JV.cs:2559 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | DATA_OP | dr["p_line_id"] | str_line_id | 행/컬럼 값 대입 |  |  |  |
| AC-d8d40902 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0057_ProductionPlanLine_JV.cs:2560 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | DATA_OP | dr["p_item_id"] | str_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-fae14bff | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0057_ProductionPlanLine_JV.cs:2561 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | DATA_OP | dr["p_operation_id"] | str_operation_id | 행/컬럼 값 대입 |  |  |  |
| AC-02f87648 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0057_ProductionPlanLine_JV.cs:2562 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | DATA_OP | dr["p_yyyymmdd"] | strYYYYMMDD | 행/컬럼 값 대입 |  |  |  |
| AC-61dd77c7 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0057_ProductionPlanLine_JV.cs:2563 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | DATA_OP | dr["p_qty"] | sQty | 행/컬럼 값 대입 |  |  |  |
| AC-1b1b92eb | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0057_ProductionPlanLine_JV.cs:2564 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | DATA_OP | dr["p_fix_reason"] | strReason | 행/컬럼 값 대입 |  |  |  |
| AC-6efe4002 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0057_ProductionPlanLine_JV.cs:2565 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | DATA_OP | dr["p_origin_division_id"] | str_origin_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-02783dbe | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0057_ProductionPlanLine_JV.cs:2566 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | DATA_OP | dr["p_electrode_type"] | str_electrode_type | 행/컬럼 값 대입 |  |  |  |
| AC-9224096d | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0057_ProductionPlanLine_JV.cs:2567 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | DATA_OP | dr["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-995e2713 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0057_ProductionPlanLine_JV.cs:2568 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | DATA_OP | dr["p_bucket_type"] | p_bucket | 행/컬럼 값 대입 |  |  |  |
| AC-54b59ae8 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0057_ProductionPlanLine_JV.cs:2569 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | DATA_OP | dsInput.Tables[0].Rows.Add | (dr) | 데이터 객체 조작/조회 |  |  |  |
| AC-80a58ef0 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0057_ProductionPlanLine_JV.cs:2589 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) | DATA_OP | dsInput.Tables[0].AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-afb33f23 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0057_ProductionPlanLine_JV.cs:2603 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | CALL_EXT | sql.AddParameter | (SqlDbType.Structured, "@SCP0013", dsInput.Tables[0]) | ⚠ 의미 확인 필요 |  |  |  |
| AC-dd25dee3 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0057_ProductionPlanLine_JV.cs:2604 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | ENDPOINT | sql.ExcuteProcedure | ("dbo.SCP0024_SAVE_PRODUCTION_PLAN_FIX_DATASET") ⇒ biz:AppService.GeneralRunProcedureCustomTable [procedure=dbo.SCP0024_SAVE_PRODUC… | 엔드포인트 호출 |  |  |  |
| AC-a258355b | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0057_ProductionPlanLine_JV.cs:2607 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-6fbb2e1c | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0057_ProductionPlanLine_JV.cs:2612 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (result != null &&… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { result.Rows[0]["result_cnt"].ToString() }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-4d852f1d | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0057_ProductionPlanLine_JV.cs:2621 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ else of (result != nu… | MESSAGE | MessageHelper.GMessageBox | ("MSG00003", new object[] { ReErrorMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8cc5e91f | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0057_ProductionPlanLine_JV.cs:2630 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-b8507ea8 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0057_ProductionPlanLine_JV.cs:2631 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ec25108a | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0057_ProductionPlanLine_JV.cs:2637 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ finally ▸ if (!prgCloseF) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-bb9cdff0 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0057_ProductionPlanLine_JV.cs:2650 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ else of (iCount > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00252", new object[] { null }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SCP0057_ProductionPlanLine_JV.SaveData_Line_DT

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-29840e16 | SaveButton | SCP0057_ProductionPlanLine_JV.cs:1891 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-4e458d5e | SaveButton | SCP0057_ProductionPlanLine_JV.cs:1909 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (siMain.ActiveSheet.Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1704afb4 | SaveButton | SCP0057_ProductionPlanLine_JV.cs:1911 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (!Get_IsSaveYn()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1a5c9b81 | SaveButton | SCP0057_ProductionPlanLine_JV.cs:1917 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("A", typeof(char)) | 데이터 객체 조작/조회 |  |  |  |
| AC-8b0db200 | SaveButton | SCP0057_ProductionPlanLine_JV.cs:1918 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_active_flag") | 데이터 객체 조작/조회 |  |  |  |
| AC-9697aed3 | SaveButton | SCP0057_ProductionPlanLine_JV.cs:1919 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_division_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-7584a61d | SaveButton | SCP0057_ProductionPlanLine_JV.cs:1920 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_plan_start_yyyymmdd") | 데이터 객체 조작/조회 |  |  |  |
| AC-64b93358 | SaveButton | SCP0057_ProductionPlanLine_JV.cs:1921 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_plan_type") | 데이터 객체 조작/조회 |  |  |  |
| AC-c3adbdff | SaveButton | SCP0057_ProductionPlanLine_JV.cs:1922 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_seq") | 데이터 객체 조작/조회 |  |  |  |
| AC-aca6dcd9 | SaveButton | SCP0057_ProductionPlanLine_JV.cs:1923 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_operation_group") | 데이터 객체 조작/조회 |  |  |  |
| AC-6150c621 | SaveButton | SCP0057_ProductionPlanLine_JV.cs:1924 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_scm_site_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-ee77f2cc | SaveButton | SCP0057_ProductionPlanLine_JV.cs:1925 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_item_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-1546c12b | SaveButton | SCP0057_ProductionPlanLine_JV.cs:1926 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_line_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-96dd769d | SaveButton | SCP0057_ProductionPlanLine_JV.cs:1927 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_operation_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-4e30f4cf | SaveButton | SCP0057_ProductionPlanLine_JV.cs:1928 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_measure") | 데이터 객체 조작/조회 |  |  |  |
| AC-df652aa9 | SaveButton | SCP0057_ProductionPlanLine_JV.cs:1929 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_yyyymmdd") | 데이터 객체 조작/조회 |  |  |  |
| AC-658dff60 | SaveButton | SCP0057_ProductionPlanLine_JV.cs:1930 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_qty") | 데이터 객체 조작/조회 |  |  |  |
| AC-0eea8493 | SaveButton | SCP0057_ProductionPlanLine_JV.cs:1931 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_fix_reason") | 데이터 객체 조작/조회 |  |  |  |
| AC-a6e5fcc0 | SaveButton | SCP0057_ProductionPlanLine_JV.cs:1932 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_user_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-100b81ae | SaveButton | SCP0057_ProductionPlanLine_JV.cs:1933 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_fix") | 데이터 객체 조작/조회 |  |  |  |
| AC-e0584c60 | SaveButton | SCP0057_ProductionPlanLine_JV.cs:1934 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_loc_flag") | 데이터 객체 조작/조회 |  |  |  |
| AC-11d6a57d | SaveButton | SCP0057_ProductionPlanLine_JV.cs:1935 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_program_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-f04123e2 | SaveButton | SCP0057_ProductionPlanLine_JV.cs:1936 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("debug_mode") | 데이터 객체 조작/조회 |  |  |  |
| AC-ad8cf4f7 | SaveButton | SCP0057_ProductionPlanLine_JV.cs:1937 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_origin_division_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-533899f1 | SaveButton | SCP0057_ProductionPlanLine_JV.cs:1938 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_electrode_type") | 데이터 객체 조작/조회 |  |  |  |
| AC-dfacb69f | SaveButton | SCP0057_ProductionPlanLine_JV.cs:1939 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_bucket_type") | 데이터 객체 조작/조회 |  |  |  |
| AC-ddbd926a | SaveButton | SCP0057_ProductionPlanLine_JV.cs:1940 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_from_yyyymmdd") | 데이터 객체 조작/조회 |  |  |  |
| AC-5aedb9dc | SaveButton | SCP0057_ProductionPlanLine_JV.cs:1941 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_to_yyyymmdd") | 데이터 객체 조작/조회 |  |  |  |
| AC-d9795188 | SaveButton | SCP0057_ProductionPlanLine_JV.cs:1943 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dsInput.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-e69c42ba | SaveButton | SCP0057_ProductionPlanLine_JV.cs:1981 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | GRID_STYLE | siMain.SetBGColor | (i, j, i, j, ControlColor.InvalidColor) | 그리드 표시 설정 |  |  |  |
| AC-071abe2a | SaveButton | SCP0057_ProductionPlanLine_JV.cs:1982 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | MESSAGE | MessageHelper.GMessageBox | ("MSG00084", new object[] { null }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f770460b | SaveButton | SCP0057_ProductionPlanLine_JV.cs:1983 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1382acae | SaveButton | SCP0057_ProductionPlanLine_JV.cs:1987 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | GRID_STYLE | siMain.SetBGColor | (i, j, i, j, ControlColor.InvalidColor) | 그리드 표시 설정 |  |  |  |
| AC-d4d14519 | SaveButton | SCP0057_ProductionPlanLine_JV.cs:1989 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | MESSAGE | MessageHelper.GMessageBox | ("MSG00317", new object[] { message }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3b17220f | SaveButton | SCP0057_ProductionPlanLine_JV.cs:1990 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3bfd7b83 | SaveButton | SCP0057_ProductionPlanLine_JV.cs:1997 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dsInput.Tables[0].NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-7224ecbd | SaveButton | SCP0057_ProductionPlanLine_JV.cs:1999 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["A"] | action | 행/컬럼 값 대입 |  |  |  |
| AC-be5e5a02 | SaveButton | SCP0057_ProductionPlanLine_JV.cs:2000 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_active_flag"] | action | 행/컬럼 값 대입 |  |  |  |
| AC-c3f46cbb | SaveButton | SCP0057_ProductionPlanLine_JV.cs:2001 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-b867a911 | SaveButton | SCP0057_ProductionPlanLine_JV.cs:2002 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-9b932ab7 | SaveButton | SCP0057_ProductionPlanLine_JV.cs:2003 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-41dc8f13 | SaveButton | SCP0057_ProductionPlanLine_JV.cs:2004 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-2d6000c5 | SaveButton | SCP0057_ProductionPlanLine_JV.cs:2005 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_operation_group"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.OPERATION_GROUP)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-bc474cbb | SaveButton | SCP0057_ProductionPlanLine_JV.cs:2006 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_scm_site_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-d83b2632 | SaveButton | SCP0057_ProductionPlanLine_JV.cs:2007 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_item_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ITEM_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-540757ff | SaveButton | SCP0057_ProductionPlanLine_JV.cs:2008 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_line_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.LINE_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-cbc78a6b | SaveButton | SCP0057_ProductionPlanLine_JV.cs:2009 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_operation_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.OPERATION_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-f586943b | SaveButton | SCP0057_ProductionPlanLine_JV.cs:2010 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_measure"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.MEASURE)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-6742d179 | SaveButton | SCP0057_ProductionPlanLine_JV.cs:2011 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_origin_division_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ORIGIN_DIVISION_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-909572d8 | SaveButton | SCP0057_ProductionPlanLine_JV.cs:2012 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_electrode_type"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ELECTRODE_TYPE)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-80017c23 | SaveButton | SCP0057_ProductionPlanLine_JV.cs:2013 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_yyyymmdd"] | strDayName | 행/컬럼 값 대입 |  |  |  |
| AC-f2458f14 | SaveButton | SCP0057_ProductionPlanLine_JV.cs:2014 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_qty"] | strDayQty | 행/컬럼 값 대입 |  |  |  |
| AC-05ff7f67 | SaveButton | SCP0057_ProductionPlanLine_JV.cs:2015 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_fix"] | isFix | 행/컬럼 값 대입 |  |  |  |
| AC-6ba6b52b | SaveButton | SCP0057_ProductionPlanLine_JV.cs:2016 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_loc_flag"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-5cb57f1b | SaveButton | SCP0057_ProductionPlanLine_JV.cs:2017 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-e0864e8e | SaveButton | SCP0057_ProductionPlanLine_JV.cs:2018 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_bucket_type"] | BucketType.Daily | 행/컬럼 값 대입 |  |  |  |
| AC-5331c5f5 | SaveButton | SCP0057_ProductionPlanLine_JV.cs:2019 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-e9087062 | SaveButton | SCP0057_ProductionPlanLine_JV.cs:2020 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-ec045a9c | SaveButton | SCP0057_ProductionPlanLine_JV.cs:2021 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_program_id"] | "SCP0013" | 행/컬럼 값 대입 |  |  |  |
| AC-2da8ad38 | SaveButton | SCP0057_ProductionPlanLine_JV.cs:2022 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-e63d5aa7 | SaveButton | SCP0057_ProductionPlanLine_JV.cs:2025 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dsInput.Tables[0].Rows.Add | (dr) | 데이터 객체 조작/조회 |  |  |  |
| AC-f137dfeb | SaveButton | SCP0057_ProductionPlanLine_JV.cs:2056 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | GRID_STYLE | siMain.SetBGColor | (i, j, i, j, ControlColor.InvalidColor) | 그리드 표시 설정 |  |  |  |
| AC-71b63001 | SaveButton | SCP0057_ProductionPlanLine_JV.cs:2057 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | MESSAGE | MessageHelper.GMessageBox | ("MSG00084", new object[] { null }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-11879b90 | SaveButton | SCP0057_ProductionPlanLine_JV.cs:2058 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-fac5d0d5 | SaveButton | SCP0057_ProductionPlanLine_JV.cs:2062 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | GRID_STYLE | siMain.SetBGColor | (i, j, i, j, ControlColor.InvalidColor) | 그리드 표시 설정 |  |  |  |
| AC-f08ac98d | SaveButton | SCP0057_ProductionPlanLine_JV.cs:2064 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | MESSAGE | MessageHelper.GMessageBox | ("MSG00317", new object[] { message }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-960b22a3 | SaveButton | SCP0057_ProductionPlanLine_JV.cs:2065 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9c743da4 | SaveButton | SCP0057_ProductionPlanLine_JV.cs:2069 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dsInput.Tables[0].NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-062260a6 | SaveButton | SCP0057_ProductionPlanLine_JV.cs:2071 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["A"] | action | 행/컬럼 값 대입 |  |  |  |
| AC-8d96144d | SaveButton | SCP0057_ProductionPlanLine_JV.cs:2072 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_active_flag"] | action | 행/컬럼 값 대입 |  |  |  |
| AC-ec28f564 | SaveButton | SCP0057_ProductionPlanLine_JV.cs:2073 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-d9785cf2 | SaveButton | SCP0057_ProductionPlanLine_JV.cs:2074 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-a0d46e56 | SaveButton | SCP0057_ProductionPlanLine_JV.cs:2075 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-74c8ddf0 | SaveButton | SCP0057_ProductionPlanLine_JV.cs:2076 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-6e5f8573 | SaveButton | SCP0057_ProductionPlanLine_JV.cs:2077 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_operation_group"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.OPERATION_GROUP)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-d5facc4a | SaveButton | SCP0057_ProductionPlanLine_JV.cs:2078 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_scm_site_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-5f88cb2f | SaveButton | SCP0057_ProductionPlanLine_JV.cs:2079 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_item_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ITEM_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-2f144be5 | SaveButton | SCP0057_ProductionPlanLine_JV.cs:2080 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_line_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.LINE_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-91a8cedf | SaveButton | SCP0057_ProductionPlanLine_JV.cs:2081 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_operation_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.OPERATION_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-f40f80d1 | SaveButton | SCP0057_ProductionPlanLine_JV.cs:2082 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_measure"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.MEASURE)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-b02ab3b5 | SaveButton | SCP0057_ProductionPlanLine_JV.cs:2083 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_origin_division_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ORIGIN_DIVISION_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-1b63f20f | SaveButton | SCP0057_ProductionPlanLine_JV.cs:2084 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_electrode_type"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ELECTRODE_TYPE)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-3ff09118 | SaveButton | SCP0057_ProductionPlanLine_JV.cs:2085 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_yyyymmdd"] | strWeekName | 행/컬럼 값 대입 |  |  |  |
| AC-1e617f6f | SaveButton | SCP0057_ProductionPlanLine_JV.cs:2086 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_qty"] | strWeekQty | 행/컬럼 값 대입 |  |  |  |
| AC-4005e8f5 | SaveButton | SCP0057_ProductionPlanLine_JV.cs:2087 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_fix"] | isFix | 행/컬럼 값 대입 |  |  |  |
| AC-806e873f | SaveButton | SCP0057_ProductionPlanLine_JV.cs:2088 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_loc_flag"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-f8e9a67e | SaveButton | SCP0057_ProductionPlanLine_JV.cs:2089 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-2b779eeb | SaveButton | SCP0057_ProductionPlanLine_JV.cs:2090 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_bucket_type"] | BucketType.Weekly | 행/컬럼 값 대입 |  |  |  |
| AC-50de2de9 | SaveButton | SCP0057_ProductionPlanLine_JV.cs:2091 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-9438b66d | SaveButton | SCP0057_ProductionPlanLine_JV.cs:2092 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-f22dd2d0 | SaveButton | SCP0057_ProductionPlanLine_JV.cs:2093 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_program_id"] | "SCP0013" | 행/컬럼 값 대입 |  |  |  |
| AC-c4aef040 | SaveButton | SCP0057_ProductionPlanLine_JV.cs:2094 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-1125695d | SaveButton | SCP0057_ProductionPlanLine_JV.cs:2097 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dsInput.Tables[0].Rows.Add | (dr) | 데이터 객체 조작/조회 |  |  |  |
| AC-eba94a42 | SaveButton | SCP0057_ProductionPlanLine_JV.cs:2109 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | GRID_SET | dsInput.Tables[0].Rows[0]["p_loc_flag"] | "F" | 그리드 속성/값 설정 |  |  |  |
| AC-07ea3688 | SaveButton | SCP0057_ProductionPlanLine_JV.cs:2110 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | GRID_SET | dsInput.Tables[0].Rows[nRowCnt - 1]["p_loc_flag"] | "L" | 그리드 속성/값 설정 |  |  |  |
| AC-71a7f662 | SaveButton | SCP0057_ProductionPlanLine_JV.cs:2112 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dsInput.Tables[0].AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-9f9c2000 | SaveButton | SCP0057_ProductionPlanLine_JV.cs:2121 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-fb2ee1f8 | SaveButton | SCP0057_ProductionPlanLine_JV.cs:2132 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | CALL_EXT | sql.AddParameter | (SqlDbType.Structured, "@SCP0013", dsInput.Tables[0]) | ⚠ 의미 확인 필요 |  |  |  |
| AC-dfef79b3 | SaveButton | SCP0057_ProductionPlanLine_JV.cs:2133 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | ENDPOINT | sql.ExcuteProcedure | ("dbo.SCP0013_SAVE_PRODUCTION_PLAN_LINE_ROW_DATASET") ⇒ biz:AppService.GeneralRunProcedureCustomTable [procedure=dbo.SCP0013_SAVE_PRODUC… | 엔드포인트 호출 |  |  |  |
| AC-62450285 | SaveButton | SCP0057_ProductionPlanLine_JV.cs:2136 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-79763e60 | SaveButton | SCP0057_ProductionPlanLine_JV.cs:2141 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (result != n… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { iCount }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a0976319 | SaveButton | SCP0057_ProductionPlanLine_JV.cs:2150 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ else of (result… | MESSAGE | MessageHelper.GMessageBox | ("MSG00003", new object[] { ReErrorMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-2fb57a8b | SaveButton | SCP0057_ProductionPlanLine_JV.cs:2159 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ catch ((Exception ex)… | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-ea662dc2 | SaveButton | SCP0057_ProductionPlanLine_JV.cs:2161 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ catch ((Exception ex)… | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-88b2fc66 | SaveButton | SCP0057_ProductionPlanLine_JV.cs:2167 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ finally ▸ if (!prgClo… | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-a0ebec81 | SaveButton | SCP0057_ProductionPlanLine_JV.cs:2250 | catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-2901a705 | SaveButton | SCP0057_ProductionPlanLine_JV.cs:2252 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e437288d | SaveButton | SCP0057_ProductionPlanLine_JV.cs:2256 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-14baefaf | SaveButton | SCP0057_ProductionPlanLine_JV.cs:2258 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## SCP0057_ProductionPlanLine_JV.SCM_SYS_LOG_BATCH

진입점: this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName)) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try] / this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName)) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try] / SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-91ca6f18 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 2 | SCP0057_ProductionPlanLine_JV.cs:3074 | try | ENDPOINT | new FoxDataRequest | ("SCP.PR_SCM_SYS_LOG_BATCH") ⇒ SCP.PR_SCM_SYS_LOG_BATCH | 엔드포인트 요청 생성 |  |  |  |
| AC-4332396e | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 2 | SCP0057_ProductionPlanLine_JV.cs:3075 | try | DATA_OP | request.Parameters["p_program_name"] | p_program_name | 행/컬럼 값 대입 |  |  |  |
| AC-a81d8785 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 2 | SCP0057_ProductionPlanLine_JV.cs:3076 | try | DATA_OP | request.Parameters["p_log_type"] | p_log_type | 행/컬럼 값 대입 |  |  |  |
| AC-cfc33c49 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 2 | SCP0057_ProductionPlanLine_JV.cs:3077 | try | DATA_OP | request.Parameters["p_log_count"] | p_log_count | 행/컬럼 값 대입 |  |  |  |
| AC-ba671c8d | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 2 | SCP0057_ProductionPlanLine_JV.cs:3078 | try | DATA_OP | request.Parameters["p_log_message"] | p_log_message | 행/컬럼 값 대입 |  |  |  |
| AC-b92b993d | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 2 | SCP0057_ProductionPlanLine_JV.cs:3079 | try | DATA_OP | request.Parameters["p_description"] | p_description | 행/컬럼 값 대입 |  |  |  |
| AC-e5104d56 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 2 | SCP0057_ProductionPlanLine_JV.cs:3080 | try | DATA_OP | request.Parameters["p_event_date"] | DateTime.Now | 행/컬럼 값 대입 |  |  |  |
| AC-636ad493 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 2 | SCP0057_ProductionPlanLine_JV.cs:3082 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## SCP0057_ProductionPlanLine_JV.Set_FixButtonEnabled

진입점: cboPlanDate.SelectedIndexChanged / cboPlanType.SelectedIndexChanged / cboPlanSeq.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bc99d781 | cboPlanDate.SelectedIndexChanged 외 2 | SCP0057_ProductionPlanLine_JV.cs:3355 | if (!string.IsNullOrEmpty(strPlanDate) && !string.IsNullOrEmpty(strPlanType) && !string.IsNullOrEmpty(strPlanSeq) && nPlanDa…) | STATE | btnFix.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-c35f7bd5 | cboPlanDate.SelectedIndexChanged 외 2 | SCP0057_ProductionPlanLine_JV.cs:3356 | if (!string.IsNullOrEmpty(strPlanDate) && !string.IsNullOrEmpty(strPlanType) && !string.IsNullOrEmpty(strPlanSeq) && nPlanDa…) | STATE | btnUnfix.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-b0307578 | cboPlanDate.SelectedIndexChanged 외 2 | SCP0057_ProductionPlanLine_JV.cs:3357 | if (!string.IsNullOrEmpty(strPlanDate) && !string.IsNullOrEmpty(strPlanType) && !string.IsNullOrEmpty(strPlanSeq) && nPlanDa…) | STATE | btnNew.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-073d55ac | cboPlanDate.SelectedIndexChanged 외 2 | SCP0057_ProductionPlanLine_JV.cs:3361 | else of (!string.IsNullOrEmpty(strPlanDate) && !string.IsNullOrEmpty(strPlanType) && !string.IsNullOrEmpty(strPlanSeq) && nPlanDa…) | STATE | btnFix.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-1136083a | cboPlanDate.SelectedIndexChanged 외 2 | SCP0057_ProductionPlanLine_JV.cs:3362 | else of (!string.IsNullOrEmpty(strPlanDate) && !string.IsNullOrEmpty(strPlanType) && !string.IsNullOrEmpty(strPlanSeq) && nPlanDa…) | STATE | btnUnfix.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-31616da5 | cboPlanDate.SelectedIndexChanged 외 2 | SCP0057_ProductionPlanLine_JV.cs:3363 | else of (!string.IsNullOrEmpty(strPlanDate) && !string.IsNullOrEmpty(strPlanType) && !string.IsNullOrEmpty(strPlanSeq) && nPlanDa…) | STATE | btnNew.Enabled | false | 컨트롤 상태 Enabled |  |  |  |

## SCP0057_ProductionPlanLine_JV.Set_FixCellColor

진입점: this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName)) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Equals("S")) ▸ try ▸ if (dsBinding.Tables.Count > 0)] / this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName)) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Eq…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9b135510 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 5 | SCP0057_ProductionPlanLine_JV.cs:2978 | foreach (DataRow row in dtFix.Rows) | DATA_OP | row["FIX_KEY"] | sVal | 행/컬럼 값 대입 |  |  |  |
| AC-29e21216 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 5 | SCP0057_ProductionPlanLine_JV.cs:2992 | for (k < siMain.ActiveSheet.RowCount) ▸ if (dtFix.Rows.Count > 0 && spd_MEASURE == "PROD_PLAN_AMEND") | DATA_OP | dtFix.Select | ("FIX_KEY='" + spd_FIX_KEY + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-1eb45c01 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 5 | SCP0057_ProductionPlanLine_JV.cs:3010 | for (k < siMain.ActiveSheet.RowCount) ▸ if (dtFix.Rows.Count > 0 && spd_MEASURE == "PROD_PLAN_AMEND") ▸ foreach (DataRow dr in dataRows) ▸ i… | GRID_STYLE | siMain.SetBGColor2 | (k, nCol, k, nCol, Color.FromArgb(188, 229, 92)) | 그리드 표시 설정 |  |  |  |
| AC-cd7ea9a4 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 5 | SCP0057_ProductionPlanLine_JV.cs:3014 | for (k < siMain.ActiveSheet.RowCount) ▸ if (dtFix.Rows.Count > 0 && spd_MEASURE == "PROD_PLAN_AMEND") ▸ foreach (DataRow dr in dataRows) ▸ i… | GRID_STYLE | siMain.SetBGColor2 | (k, nColWeek, k, nColWeek, Color.FromArgb(188, 229, 92)) | 그리드 표시 설정 |  |  |  |
| AC-7dfc9a41 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 5 | SCP0057_ProductionPlanLine_JV.cs:3031 | for (k < siMain.ActiveSheet.RowCount) ▸ if (dtFix.Rows.Count > 0 && spd_MEASURE == "PROD_PLAN_AMEND") ▸ foreach (DataRow dr in dataRows) ▸ e… | GRID_STYLE | siMain.SetBGColor2 | (k, nColWeek, k, nColWeek, Color.FromArgb(188, 229, 92)) | 그리드 표시 설정 |  |  |  |
| AC-e56f86bd | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 5 | SCP0057_ProductionPlanLine_JV.cs:3053 | for (k < siMain.ActiveSheet.RowCount) ▸ if ((spd_MEASURE == "LINE_TOTAL_LOAD_AMEND" \|\| spd_MEASURE == "LINE_TOTAL_LOAD_ENGINE") && (p_buck… | GRID_STYLE | siMain.SetFGColor2 | (k, nCol, k, nCol, ControlColor.MarkedForeColor) | 그리드 표시 설정 |  |  |  |
| AC-48efa9b3 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 5 | SCP0057_ProductionPlanLine_JV.cs:3058 | for (k < siMain.ActiveSheet.RowCount) | UI_MISC | spdMain.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## SCP0057_ProductionPlanLine_JV.Set_FPOperationColor

진입점: this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName)) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Equals("S")) ▸ try ▸ if (dsBinding.Tables.Count > 0)] / this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName)) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Eq…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1933b1bf | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 5 | SCP0057_ProductionPlanLine_JV.cs:2866 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2ad149bf | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 5 | SCP0057_ProductionPlanLine_JV.cs:2870 | if (fps.Name == "spdMain") ▸ if (siMain.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-88c01a29 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 5 | SCP0057_ProductionPlanLine_JV.cs:2871 | if (fps.Name == "spdMain") | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-03ae6b40 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 5 | SCP0057_ProductionPlanLine_JV.cs:2882 | if (fps.Name == "spdMain") ▸ for (i < spdMain.ActiveSheet.RowCount) ▸ if (spdMain.ActiveSheet.GetText(i, siMain.GetColumnIndex(DefColumns.ME… | DATA_OP | dtIsEditInfo.Select | ("CP_KEY = '" + strCP_KEY + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-fc8d0822 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 5 | SCP0057_ProductionPlanLine_JV.cs:2911 | if (fps.Name == "spdMain") ▸ for (i < spdMain.ActiveSheet.RowCount) ▸ if (spdMain.ActiveSheet.GetText(i, siMain.GetColumnIndex(DefColumns.ME… | DATA_OP | dtPlanType.Select | ("CODE='FN'") | 데이터 객체 조작/조회 |  |  |  |
| AC-cb3b9f1f | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 5 | SCP0057_ProductionPlanLine_JV.cs:2958 | if (fps.Name == "spdMain") ▸ for (i < spdMain.ActiveSheet.RowCount) ▸ if (spdMain.ActiveSheet.GetText(i, siMain.GetColumnIndex(DefColumns.ME… | GRID_STYLE | siMain.SetBGColor2 | (nEditableRow, nStartEditIdx, nEditableRow, siMain.ActiveSheet.ColumnCount - 1, Color.From… | 그리드 표시 설정 |  |  |  |
| AC-033772a5 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 5 | SCP0057_ProductionPlanLine_JV.cs:2964 | if (fps.Name == "spdMain") | UI_MISC | spdMain.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## SCP0057_ProductionPlanLine_JV.Set_ProductResult

진입점: this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName)) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Equals("S")) ▸ try ▸ if (dsBinding.Tables.Count > 0)] / this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName)) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Eq…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7e6878fb | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 5 | SCP0057_ProductionPlanLine_JV.cs:962 | if (int.Parse(p_from_yyyymmdd.ToString()) < int.Parse(p_plan_start_yyyymmdd.ToString()) && (p_bucket.Equals(BucketType.Daily…) ▸ if (resultI… | GRID_STYLE | siMain.SetBGColor2 | (0, siMain.nIdxData + 1, spdMain.ActiveSheet.RowCount - 1, resultIdx, Color.FromArgb(234, … | 그리드 표시 설정 |  |  |  |

## SCP0057_ProductionPlanLine_JV.SetChangedControl

진입점: this.Load / cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1793786a | this.Load 외 1 | SCP0057_ProductionPlanLine_JV.cs:1533 |  | LIST_CLEAR | clbPlantSite.Items.Clear | () | 목록 항목 비움 |  |  |  |
| AC-7c4e24ff | this.Load 외 1 | SCP0057_ProductionPlanLine_JV.cs:1534 |  | UI_PROP | clbPlantSite.ALL_VIEW | false | 속성 ALL_VIEW 설정 |  |  |  |
| AC-4250dd13 | this.Load 외 1 | SCP0057_ProductionPlanLine_JV.cs:1539 | if (division.Substring(0, 2).Equals("EE")) | FLAG | dtOperationGroup | Data_SCP.Common(Data_SCP.Type.OperationGroupEE, false) | 화면 필드/플래그 변경 |  |  |  |
| AC-a8c6c434 | this.Load 외 1 | SCP0057_ProductionPlanLine_JV.cs:1539 | if (division.Substring(0, 2).Equals("EE")) | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.OperationGroupEE, false) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-abd3916a | this.Load 외 1 | SCP0057_ProductionPlanLine_JV.cs:1541 | else of (division.Substring(0, 2).Equals("EE")) | FLAG | dtOperationGroup | Data_SCP.Common(Data_SCP.Type.OperationGroup, false) | 화면 필드/플래그 변경 |  |  |  |
| AC-6fa9ae7b | this.Load 외 1 | SCP0057_ProductionPlanLine_JV.cs:1541 | else of (division.Substring(0, 2).Equals("EE")) | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.OperationGroup, false) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-4dbc4ce4 | this.Load 외 1 | SCP0057_ProductionPlanLine_JV.cs:1542 |  | LIST_REBIND | clsCtrl.setListBox | (dtOperationGroup, cboOperationGroup, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-910fc24b | this.Load 외 1 | SCP0057_ProductionPlanLine_JV.cs:1548 | if (division == "40") | STATE | this.lcCellTypeGr.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-d0ee6134 | this.Load 외 1 | SCP0057_ProductionPlanLine_JV.cs:1552 | else of (division == "40") | STATE | this.lcCellTypeGr.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-a5066103 | this.Load 외 1 | SCP0057_ProductionPlanLine_JV.cs:1553 | else of (division == "40") | CALL_EXT | cboCellTypeGr.SetAllCheckItem | (false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-79abdd05 | this.Load 외 1 | SCP0057_ProductionPlanLine_JV.cs:1561 | if (division.Substring(0, 2).Equals("EE")) | CALL_EXT | dic_JV_Plant.TryGetValue | (division, out get_JV_Value) | ⚠ 의미 확인 필요 |  |  |  |
| AC-abaaae0c | this.Load 외 1 | SCP0057_ProductionPlanLine_JV.cs:1574 | if (division.Substring(0, 2).Equals("EE")) ▸ if (get_JV_Value != "") | FLAG | dtPlantSiteByDivision | Data_SCP.Common(Data_SCP.Type.PlantSiteProdPlan, false, division, pOperationGroup, "JV Pla… | 화면 필드/플래그 변경 |  |  |  |
| AC-67e64ad7 | this.Load 외 1 | SCP0057_ProductionPlanLine_JV.cs:1574 | if (division.Substring(0, 2).Equals("EE")) ▸ if (get_JV_Value != "") | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.PlantSiteProdPlan, false, division, pOperationGroup, "JV Planner", get_JV_V… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-988a909e | this.Load 외 1 | SCP0057_ProductionPlanLine_JV.cs:1578 | if (division.Substring(0, 2).Equals("EE")) ▸ else of (get_JV_Value != "") | FLAG | dtPlantSiteByDivision | Data_SCP.Common(Data_SCP.Type.PlantSiteProdPlan, false, division, pOperationGroup, "JV Pla… | 화면 필드/플래그 변경 |  |  |  |
| AC-d8ef0e2b | this.Load 외 1 | SCP0057_ProductionPlanLine_JV.cs:1578 | if (division.Substring(0, 2).Equals("EE")) ▸ else of (get_JV_Value != "") | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.PlantSiteProdPlan, false, division, pOperationGroup, "JV Planner", "9999!!!… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-07e5942d | this.Load 외 1 | SCP0057_ProductionPlanLine_JV.cs:1585 | else of (division.Substring(0, 2).Equals("EE")) | CALL_EXT | dic_JV_Plant.TryGetValue | (division, out get_JV_Value) | ⚠ 의미 확인 필요 |  |  |  |
| AC-4c30f75d | this.Load 외 1 | SCP0057_ProductionPlanLine_JV.cs:1589 | else of (division.Substring(0, 2).Equals("EE")) ▸ if (get_JV_Value != "") | FLAG | dtPlantSiteByDivision | Data.Common(Data.Type.PlantByDivisionOperation, false, division, pOperationGroup, "JV Plan… ⇒ biz:CommonData.CommonDataList [code=PlantByDivisionOperation] | 화면 필드/플래그 변경 |  |  |  |
| AC-71420126 | this.Load 외 1 | SCP0057_ProductionPlanLine_JV.cs:1589 | else of (division.Substring(0, 2).Equals("EE")) ▸ if (get_JV_Value != "") | COMBO_DATA | Data.Common | (Data.Type.PlantByDivisionOperation, false, division, pOperationGroup, "JV Planner", get_J… ⇒ biz:CommonData.CommonDataList [code=PlantByDivisionOperation] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-13a4af31 | this.Load 외 1 | SCP0057_ProductionPlanLine_JV.cs:1593 | else of (division.Substring(0, 2).Equals("EE")) ▸ else of (get_JV_Value != "") | FLAG | dtPlantSiteByDivision | Data.Common(Data.Type.PlantByDivisionOperation, false, "9999!!!!", pOperationGroup, "JV Pl… ⇒ biz:CommonData.CommonDataList [code=PlantByDivisionOperation] | 화면 필드/플래그 변경 |  |  |  |
| AC-4a10de46 | this.Load 외 1 | SCP0057_ProductionPlanLine_JV.cs:1593 | else of (division.Substring(0, 2).Equals("EE")) ▸ else of (get_JV_Value != "") | COMBO_DATA | Data.Common | (Data.Type.PlantByDivisionOperation, false, "9999!!!!", pOperationGroup, "JV Planner", get… ⇒ biz:CommonData.CommonDataList [code=PlantByDivisionOperation] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c324bc31 | this.Load 외 1 | SCP0057_ProductionPlanLine_JV.cs:1598 | if (dtPlantSiteByDivision.Rows.Count < 1) | UI_PROP | clbPlantSite.ALL_VIEW | false | 속성 ALL_VIEW 설정 |  |  |  |
| AC-fa87935c | this.Load 외 1 | SCP0057_ProductionPlanLine_JV.cs:1599 | else of (dtPlantSiteByDivision.Rows.Count < 1) | UI_PROP | clbPlantSite.ALL_VIEW | true | 속성 ALL_VIEW 설정 |  |  |  |
| AC-08cb414c | this.Load 외 1 | SCP0057_ProductionPlanLine_JV.cs:1603 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlantSiteByDivision, clbPlantSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-c7344f81 | this.Load 외 1 | SCP0057_ProductionPlanLine_JV.cs:1610 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | FLAG | dtPlanDate | Data.Common(Data.Type.PlanDate, false, division) ⇒ biz:CommonData.CommonDataList [code=PlanDate] | 화면 필드/플래그 변경 |  |  |  |
| AC-e1b30314 | this.Load 외 1 | SCP0057_ProductionPlanLine_JV.cs:1610 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | COMBO_DATA | Data.Common | (Data.Type.PlanDate, false, division) ⇒ biz:CommonData.CommonDataList [code=PlanDate] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-36437843 | this.Load 외 1 | SCP0057_ProductionPlanLine_JV.cs:1611 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | LIST_REBIND | clsCtrl.setListBox | (dtPlanDate, cboPlanDate, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-05652efb | this.Load 외 1 | SCP0057_ProductionPlanLine_JV.cs:1615 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | FLAG | dtPlanType | Data.Common(Data.Type.PlanType, false, division, pPlanDate) ⇒ biz:CommonData.CommonDataList [code=PlanType] | 화면 필드/플래그 변경 |  |  |  |
| AC-e850f662 | this.Load 외 1 | SCP0057_ProductionPlanLine_JV.cs:1615 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | COMBO_DATA | Data.Common | (Data.Type.PlanType, false, division, pPlanDate) ⇒ biz:CommonData.CommonDataList [code=PlanType] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-d3992a1b | this.Load 외 1 | SCP0057_ProductionPlanLine_JV.cs:1616 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | LIST_REBIND | clsCtrl.setListBox | (dtPlanType, cboPlanType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-34f6087c | this.Load 외 1 | SCP0057_ProductionPlanLine_JV.cs:1617 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ if (dtPlanType.Rows.Count > 0) | VALUE_SET | cboPlanType.SelectedIndex | dtPlanType.Rows.Count - 1 | 컨트롤 값 설정 |  |  |  |
| AC-016df7cc | this.Load 외 1 | SCP0057_ProductionPlanLine_JV.cs:1620 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | FLAG | dtPlanSeq | Data.Common(Data.Type.PlanSeq, false, division, pPlanDate, pPlanType) ⇒ biz:CommonData.CommonDataList [code=PlanSeq] | 화면 필드/플래그 변경 |  |  |  |
| AC-aefe0afc | this.Load 외 1 | SCP0057_ProductionPlanLine_JV.cs:1620 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | COMBO_DATA | Data.Common | (Data.Type.PlanSeq, false, division, pPlanDate, pPlanType) ⇒ biz:CommonData.CommonDataList [code=PlanSeq] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-1a7a9959 | this.Load 외 1 | SCP0057_ProductionPlanLine_JV.cs:1621 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | LIST_REBIND | clsCtrl.setListBox | (dtPlanSeq, cboPlanSeq, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-2bad0681 | this.Load 외 1 | SCP0057_ProductionPlanLine_JV.cs:1626 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ if (division.Substring(0, 2).Equals("EE")) ▸ if (pPlant… | FLAG | dtLine | Data_SCP.Common(Data_SCP.Type.LineProdPlanLine, false, "9999!!!!", pOperationGroup, pPlant… | 화면 필드/플래그 변경 |  |  |  |
| AC-0c44d838 | this.Load 외 1 | SCP0057_ProductionPlanLine_JV.cs:1626 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ if (division.Substring(0, 2).Equals("EE")) ▸ if (pPlant… | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.LineProdPlanLine, false, "9999!!!!", pOperationGroup, pPlantSite) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-aefb53f4 | this.Load 외 1 | SCP0057_ProductionPlanLine_JV.cs:1627 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ if (division.Substring(0, 2).Equals("EE")) ▸ else of (p… | FLAG | dtLine | Data_SCP.Common(Data_SCP.Type.LineProdPlanLine, false, division, pOperationGroup, pPlantSi… | 화면 필드/플래그 변경 |  |  |  |
| AC-43e8b179 | this.Load 외 1 | SCP0057_ProductionPlanLine_JV.cs:1627 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ if (division.Substring(0, 2).Equals("EE")) ▸ else of (p… | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.LineProdPlanLine, false, division, pOperationGroup, pPlantSite) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-92856509 | this.Load 외 1 | SCP0057_ProductionPlanLine_JV.cs:1631 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ else of (division.Substring(0, 2).Equals("EE")) ▸ if (p… | FLAG | dtLine | Data_SCP.Common(Data_SCP.Type.LineByOperationAddOSP, false, "9999!!!!", "", "", "", pPlant… | 화면 필드/플래그 변경 |  |  |  |
| AC-d6af9744 | this.Load 외 1 | SCP0057_ProductionPlanLine_JV.cs:1631 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ else of (division.Substring(0, 2).Equals("EE")) ▸ if (p… | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.LineByOperationAddOSP, false, "9999!!!!", "", "", "", pPlantSite) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-d6697d6a | this.Load 외 1 | SCP0057_ProductionPlanLine_JV.cs:1632 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ else of (division.Substring(0, 2).Equals("EE")) ▸ else … | FLAG | dtLine | Data_SCP.Common(Data_SCP.Type.LineByOperationAddOSP, false, division, "", "", "", pPlantSi… | 화면 필드/플래그 변경 |  |  |  |
| AC-cbe6832a | this.Load 외 1 | SCP0057_ProductionPlanLine_JV.cs:1632 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ else of (division.Substring(0, 2).Equals("EE")) ▸ else … | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.LineByOperationAddOSP, false, division, "", "", "", pPlantSite) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-35072500 | this.Load 외 1 | SCP0057_ProductionPlanLine_JV.cs:1634 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | LIST_REBIND | clsCtrl.setListBox | (dtLine, clbLine, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-bd4534e2 | this.Load 외 1 | SCP0057_ProductionPlanLine_JV.cs:1639 | if (!division.Substring(0, 2).Equals("EE")) | VALUE_CLEAR | cboElectrode.ControlValues | "" | 컨트롤 값 비움 |  |  |  |
| AC-7a6b2503 | this.Load 외 1 | SCP0057_ProductionPlanLine_JV.cs:1640 | if (!division.Substring(0, 2).Equals("EE")) | STATE | cboElectrode.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-fa4999fb | this.Load 외 1 | SCP0057_ProductionPlanLine_JV.cs:1644 | else of (!division.Substring(0, 2).Equals("EE")) | STATE | cboElectrode.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## SCP0057_ProductionPlanLine_JV.SetChangedControlPart

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-efc615aa | (진입점 미연결) | SCP0057_ProductionPlanLine_JV.cs:1656 |  | CALL_EXT | dic_JV_Plant.TryGetValue | (division, out get_JV_Value) | ⚠ 의미 확인 필요 |  |  |  |
| AC-27d6da91 | (진입점 미연결) | SCP0057_ProductionPlanLine_JV.cs:1657 | if (get_JV_Value != "") | FLAG | dtPlantSiteByDivision | Data.Common(Data.Type.PlantByDivisionOperation, false, division, pOperationGroup, "JV Plan… ⇒ biz:CommonData.CommonDataList [code=PlantByDivisionOperation] | 화면 필드/플래그 변경 |  |  |  |
| AC-4945de37 | (진입점 미연결) | SCP0057_ProductionPlanLine_JV.cs:1657 | if (get_JV_Value != "") | COMBO_DATA | Data.Common | (Data.Type.PlantByDivisionOperation, false, division, pOperationGroup, "JV Planner", get_J… ⇒ biz:CommonData.CommonDataList [code=PlantByDivisionOperation] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-b97620fd | (진입점 미연결) | SCP0057_ProductionPlanLine_JV.cs:1658 | else of (get_JV_Value != "") | FLAG | dtPlantSiteByDivision | Data.Common(Data.Type.PlantByDivisionOperation, false, "9999!!!!", pOperationGroup, "JV Pl… ⇒ biz:CommonData.CommonDataList [code=PlantByDivisionOperation] | 화면 필드/플래그 변경 |  |  |  |
| AC-6e911c84 | (진입점 미연결) | SCP0057_ProductionPlanLine_JV.cs:1658 | else of (get_JV_Value != "") | COMBO_DATA | Data.Common | (Data.Type.PlantByDivisionOperation, false, "9999!!!!", pOperationGroup, "JV Planner", get… ⇒ biz:CommonData.CommonDataList [code=PlantByDivisionOperation] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-b60f82a5 | (진입점 미연결) | SCP0057_ProductionPlanLine_JV.cs:1659 | if (dtPlantSiteByDivision.Rows.Count < 1) | UI_PROP | clbPlantSite.ALL_VIEW | false | 속성 ALL_VIEW 설정 |  |  |  |
| AC-2741f9a3 | (진입점 미연결) | SCP0057_ProductionPlanLine_JV.cs:1660 | else of (dtPlantSiteByDivision.Rows.Count < 1) | UI_PROP | clbPlantSite.ALL_VIEW | true | 속성 ALL_VIEW 설정 |  |  |  |
| AC-b3081dd4 | (진입점 미연결) | SCP0057_ProductionPlanLine_JV.cs:1661 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlantSiteByDivision, clbPlantSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-0d33546c | (진입점 미연결) | SCP0057_ProductionPlanLine_JV.cs:1664 | if (pPlantSite == "") | FLAG | dtLine | Data_SCP.Common(Data_SCP.Type.LineProdPlanLine, false, "9999!!!!", pOperationGroup, pPlant… | 화면 필드/플래그 변경 |  |  |  |
| AC-2961ee2e | (진입점 미연결) | SCP0057_ProductionPlanLine_JV.cs:1664 | if (pPlantSite == "") | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.LineProdPlanLine, false, "9999!!!!", pOperationGroup, pPlantSite) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-335d1480 | (진입점 미연결) | SCP0057_ProductionPlanLine_JV.cs:1665 | else of (pPlantSite == "") | FLAG | dtLine | Data_SCP.Common(Data_SCP.Type.LineProdPlanLine, false, division, pOperationGroup, pPlantSi… | 화면 필드/플래그 변경 |  |  |  |
| AC-ad1af32a | (진입점 미연결) | SCP0057_ProductionPlanLine_JV.cs:1665 | else of (pPlantSite == "") | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.LineProdPlanLine, false, division, pOperationGroup, pPlantSite) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-70ecf317 | (진입점 미연결) | SCP0057_ProductionPlanLine_JV.cs:1666 |  | LIST_REBIND | clsCtrl.setListBox | (dtLine, clbLine, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0057_ProductionPlanLine_JV.SetFormationYield

진입점: this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName)) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Equals("S")) ▸ try] / this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName)) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Equals("S")) ▸ try] / btnNew.Click […

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0c6765d1 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SCP0057_ProductionPlanLine_JV.cs:3107 | for (nRow < dt.Rows.Count) ▸ if (strMeasure.Equals("LINE_TOTAL_LOAD_ENGINE") \|\| strMeasure.Equals("LINE_TOTAL_LOAD_AMEND")) | CALL_EXT | siMain.SetDecimal | (nRow, nIdxStart, nRow, nIdxEnd, 2, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f1cb0552 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SCP0057_ProductionPlanLine_JV.cs:3111 |  | DATA_OP | dt.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |

## SCP0057_ProductionPlanLine_JV.SetLockSumColumn

진입점: this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName)) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Equals("S")) ▸ try ▸ if (dsBinding.Tables.Count > 0)] / this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName)) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Eq…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-eb66ae51 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 5 | SCP0057_ProductionPlanLine_JV.cs:980 | for (iCol < spreadInfo.ActiveSheet.ColumnCount) ▸ if (spreadInfo.GetColumnTag(iCol).IndexOf("M_") == 0) ▸ if (spreadInfo.ActiveSheet.RowCoun… | GRID_LOCK | spreadInfo.LockRange | (0, iCol, spreadInfo.ActiveSheet.RowCount - 1, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |

## SCP0057_ProductionPlanLine_JV.SetSpreadColumn

진입점: this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName)) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Equals("S")) ▸ try ▸ if (siMain.GetMaxRowIndex() > 0)] / this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName)) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().E…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ac348a9a | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 12 | SCP0057_ProductionPlanLine_JV.cs:1007 | for (iCol < siObj.ActiveSheet.ColumnCount) ▸ if (cboBucketType.ControlValues == BucketType.Daily) ▸ if (siObj.GetColumnTag(iCol).IndexOf("D_… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-513c854d | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 12 | SCP0057_ProductionPlanLine_JV.cs:1012 | for (iCol < siObj.ActiveSheet.ColumnCount) ▸ if (cboBucketType.ControlValues == BucketType.Daily) ▸ if (siObj.GetColumnTag(iCol).IndexOf("M_… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | chkSum.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-d21e0339 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 12 | SCP0057_ProductionPlanLine_JV.cs:1019 | for (iCol < siObj.ActiveSheet.ColumnCount) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == … | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-9938505a | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 12 | SCP0057_ProductionPlanLine_JV.cs:1023 | for (iCol < siObj.ActiveSheet.ColumnCount) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == … | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-a3d9bdc9 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 12 | SCP0057_ProductionPlanLine_JV.cs:1028 | for (iCol < siObj.ActiveSheet.ColumnCount) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == … | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | chkSum.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-7809265f | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 12 | SCP0057_ProductionPlanLine_JV.cs:1035 | for (iCol < siObj.ActiveSheet.ColumnCount) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ else of (cboBucketType.ControlValue… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-02cc2789 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 12 | SCP0057_ProductionPlanLine_JV.cs:1039 | for (iCol < siObj.ActiveSheet.ColumnCount) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ else of (cboBucketType.ControlValue… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |

## SCP0057_ProductionPlanLine_JV.SpdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ef29f910 | this.spdMain.CellClick | SCP0057_ProductionPlanLine_JV.cs:505 | if (spdMain.ActiveSheet.ActiveRowIndex > 0) | FLAG | this.nSelRowOfMain | spdMain.ActiveSheet.ActiveRowIndex | 화면 필드/플래그 변경 |  |  |  |
| AC-ba4efd0e | this.spdMain.CellClick | SCP0057_ProductionPlanLine_JV.cs:506 | if (spdMain.ActiveSheet.ActiveRowIndex > 0) | FLAG | this.nSelColOfMain | spdMain.ActiveSheet.ActiveColumnIndex | 화면 필드/플래그 변경 |  |  |  |

## SCP0057_ProductionPlanLine_JV.SpdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8c805c4e | this.spdMain.CellDoubleClick | SCP0057_ProductionPlanLine_JV.cs:3383 | if (!chkAll.Checked) ▸ if ((siMain.GetColumnTag(e.Column).IndexOf("M_") == 0 && BucketType.Monthly == sBucketType) \|\| (siMain.GetColumnTag… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-45a22ef4 | this.spdMain.CellDoubleClick | SCP0057_ProductionPlanLine_JV.cs:3386 |  | CALL_EXT | siMain.SetDblClickColumnShowHide | (sender, e) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9ca09c9c | this.spdMain.CellDoubleClick | SCP0057_ProductionPlanLine_JV.cs:3390 | if (!e.ColumnHeader && e.Row >= 0) | FLAG | nSelRowOfMain | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-18c927ac | this.spdMain.CellDoubleClick | SCP0057_ProductionPlanLine_JV.cs:3391 | if (!e.ColumnHeader && e.Row >= 0) | FLAG | nSelColOfMain | e.Column | 화면 필드/플래그 변경 |  |  |  |

## SCP0057_ProductionPlanLine_JV.SpdMain_Changed

진입점: dsdmLine.Changed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-61df2921 | dsdmLine.Changed | SCP0057_ProductionPlanLine_JV.cs:3149 | if (!this.CanModelChange \|\| e.Row == -1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-efef1e8a | dsdmLine.Changed | SCP0057_ProductionPlanLine_JV.cs:3150 | if (cellclipboardPast) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0b49eff5 | dsdmLine.Changed | SCP0057_ProductionPlanLine_JV.cs:3157 | if (ds == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-57bdbc95 | dsdmLine.Changed | SCP0057_ProductionPlanLine_JV.cs:3166 | if (strColName == "Action") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b6837ef5 | dsdmLine.Changed | SCP0057_ProductionPlanLine_JV.cs:3171 | try ▸ if (ds == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-52ab253f | dsdmLine.Changed | SCP0057_ProductionPlanLine_JV.cs:3202 | catch ((Exception et)) | THROW | throw et; |  | 예외 발생 |  |  |  |
| AC-53d416b9 | dsdmLine.Changed | SCP0057_ProductionPlanLine_JV.cs:3206 | finally | DATA_OP | dt.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |

## SCP0057_ProductionPlanLine_JV.SpdMain_ClipboardPasted

진입점: this.spdMain.ClipboardPasted

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-882997e1 | this.spdMain.ClipboardPasted | SCP0057_ProductionPlanLine_JV.cs:446 | if (siMain.Sheet().Rows.Count <= 0 \|\| siMain.IsLock(siMain.SheetName) == true) | FLAG | cellclipboardPast | false | 화면 필드/플래그 변경 |  |  |  |
| AC-e8b162a3 | this.spdMain.ClipboardPasted | SCP0057_ProductionPlanLine_JV.cs:447 | if (siMain.Sheet().Rows.Count <= 0 \|\| siMain.IsLock(siMain.SheetName) == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1970868f | this.spdMain.ClipboardPasted | SCP0057_ProductionPlanLine_JV.cs:478 | try ▸ for (iRow < e.CellRange.Row + e.CellRange.RowCount) ▸ if (measure.Equals("PROD_PLAN_AMEND")) ▸ if (ds == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c984afcb | this.spdMain.ClipboardPasted | SCP0057_ProductionPlanLine_JV.cs:486 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3610c9d3 | this.spdMain.ClipboardPasted | SCP0057_ProductionPlanLine_JV.cs:487 | catch ((Exception ex)) | FLAG | cellclipboardPast | false | 화면 필드/플래그 변경 |  |  |  |
| AC-f8b8d4f3 | this.spdMain.ClipboardPasted | SCP0057_ProductionPlanLine_JV.cs:491 | finally | FLAG | cellclipboardPast | false | 화면 필드/플래그 변경 |  |  |  |
| AC-7e20e6a1 | this.spdMain.ClipboardPasted | SCP0057_ProductionPlanLine_JV.cs:493 |  | FLAG | cellclipboardPast | false | 화면 필드/플래그 변경 |  |  |  |

## SCP0057_ProductionPlanLine_JV.SpdMain_ClipboardPasting

진입점: this.spdMain.ClipboardPasting

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-af3f95eb | this.spdMain.ClipboardPasting | SCP0057_ProductionPlanLine_JV.cs:498 |  | FLAG | cellclipboardPast | true | 화면 필드/플래그 변경 |  |  |  |

## SCP0057_ProductionPlanLine_JV.SpdMain_TopChange

진입점: this.spdMain.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9eb16d56 | this.spdMain.TopChange | SCP0057_ProductionPlanLine_JV.cs:513 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

