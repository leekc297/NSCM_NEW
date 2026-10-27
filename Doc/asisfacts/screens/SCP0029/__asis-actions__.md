# AS-IS 액션 대조표 — SCP0029

> 원천: `Doc/asisfacts/screens/SCP0029/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 409행 · 메서드 40 · 종류 DATA_OP 136 · RETURN 32 · FLAG 30 · MESSAGE 22 · GRID_INIT 21 · GRID_SET 20 · ENDPOINT 20 · UI_PROP 17 · COMBO_DATA 17 · LIST_REBIND 15 · CALL_EXT 13 · UI_MISC 13 · POPUP 11 · VALUE_SET 11 · GRID_STYLE 10 · STATE 6 · GRID_LOCK 5 · GRID_CLEAR 3 · VALIDATE 3 · STATE_RESET 1 · GRID_BIND 1 · VALUE_CLEAR 1 · THROW 1 · ⚠ 의미 확인 필요 13


## SCP0029_ProductionPlanLine_SMALL.btnFix_Click

진입점: this.btnFix.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cf875efe | this.btnFix.Click | SCP0029_ProductionPlanLine_SMALL.cs:665 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b3e4bb78 | this.btnFix.Click | SCP0029_ProductionPlanLine_SMALL.cs:666 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4fb18630 | this.btnFix.Click | SCP0029_ProductionPlanLine_SMALL.cs:672 | if (siMain.IsLock(siMain.SheetName)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00010") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SCP0029_ProductionPlanLine_SMALL.btnItemId_Click

진입점: this.btnItemId.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2a9e0ee3 | this.btnItemId.Click | SCP0029_ProductionPlanLine_SMALL.cs:636 |  | CALL_EXT | UIUtils.GetAllDivisionCheckedElectrode | (cboDivision) | ⚠ 의미 확인 필요 |  |  |  |
| AC-7592817c | this.btnItemId.Click | SCP0029_ProductionPlanLine_SMALL.cs:643 |  | POPUP | new SCM0002_ItembyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-61372199 | this.btnItemId.Click | SCP0029_ProductionPlanLine_SMALL.cs:645 |  | POPUP | popItem.Form_Load | (true, division, sScmSite, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-990a9f22 | this.btnItemId.Click | SCP0029_ProductionPlanLine_SMALL.cs:646 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-97d884b7 | this.btnItemId.Click | SCP0029_ProductionPlanLine_SMALL.cs:647 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-4ef24ff4 | this.btnItemId.Click | SCP0029_ProductionPlanLine_SMALL.cs:653 | if (popItem.ItemID != "") | VALUE_SET | txtItemId.Text | sItemId | 컨트롤 값 설정 |  |  |  |

## SCP0029_ProductionPlanLine_SMALL.BtnMeasure_Click

진입점: this.btnMeasure.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fe1106f6 | this.btnMeasure.Click | SCP0029_ProductionPlanLine_SMALL.cs:725 | if (fps != null) ▸ else of (fps.Name == "spdMain") | MESSAGE | MessageHelper.GMessageBox | ("MSG00007", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-dca75b8c | this.btnMeasure.Click | SCP0029_ProductionPlanLine_SMALL.cs:726 | if (fps != null) ▸ else of (fps.Name == "spdMain") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4dc853c7 | this.btnMeasure.Click | SCP0029_ProductionPlanLine_SMALL.cs:731 | else of (fps != null) | MESSAGE | MessageHelper.GMessageBox | ("MSG00007", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e8540d55 | this.btnMeasure.Click | SCP0029_ProductionPlanLine_SMALL.cs:732 | else of (fps != null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-acafe82d | this.btnMeasure.Click | SCP0029_ProductionPlanLine_SMALL.cs:735 |  | POPUP | new SCM0002_TitleSetForm_Popup | ("SCP0013", shtName, false) | 팝업/폼 생성 |  |  |  |
| AC-6d666b8a | this.btnMeasure.Click | SCP0029_ProductionPlanLine_SMALL.cs:736 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-4d6110d6 | this.btnMeasure.Click | SCP0029_ProductionPlanLine_SMALL.cs:737 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-23a613a3 | this.btnMeasure.Click | SCP0029_ProductionPlanLine_SMALL.cs:741 | if (frm.DialogResult == DialogResult.OK) | UI_PROP | this.CanModelChange | false | 속성 CanModelChange 설정 |  |  |  |
| AC-d77e187b | this.btnMeasure.Click | SCP0029_ProductionPlanLine_SMALL.cs:746 | if (frm.DialogResult == DialogResult.OK) | UI_PROP | this.CanModelChange | true | 속성 CanModelChange 설정 |  |  |  |

## SCP0029_ProductionPlanLine_SMALL.btnUnfix_Click

진입점: this.btnUnfix.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-38ac2fd7 | this.btnUnfix.Click | SCP0029_ProductionPlanLine_SMALL.cs:689 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8c0c4596 | this.btnUnfix.Click | SCP0029_ProductionPlanLine_SMALL.cs:690 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f13b6036 | this.btnUnfix.Click | SCP0029_ProductionPlanLine_SMALL.cs:696 | if (siMain.IsLock(siMain.SheetName)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00010") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SCP0029_ProductionPlanLine_SMALL.CalculateDailyQty

진입점: dsdmLine.Changed [try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strColName.IndexOf("W_") == 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d3cbc2fc | dsdmLine.Changed [try ▸ switch (e.Type) case FarPoint.Win.Sp… | SCP0029_ProductionPlanLine_SMALL.cs:1171 | if (nWeek < 0) | GRID_SET | siMain.SetValue | (nRow, nCol, nDaySum) | 그리드 값 설정 |  |  |  |
| AC-1b68305b | dsdmLine.Changed [try ▸ switch (e.Type) case FarPoint.Win.Sp… | SCP0029_ProductionPlanLine_SMALL.cs:1174 | if (nWeek < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-25a54b56 | dsdmLine.Changed [try ▸ switch (e.Type) case FarPoint.Win.Sp… | SCP0029_ProductionPlanLine_SMALL.cs:1207 | if (int.Parse(siMain.GetColumnTag(nCol).ToString().Substring(2)) <= int.Parse(bs_Week)) ▸ for (j < (nCol + 1 + nDayCnt)) ▸ if (j != (nCol + … | GRID_SET | siMain.SetValue | (nRow, j, nDivDay) | 그리드 값 설정 |  |  |  |
| AC-addae4f5 | dsdmLine.Changed [try ▸ switch (e.Type) case FarPoint.Win.Sp… | SCP0029_ProductionPlanLine_SMALL.cs:1212 | if (int.Parse(siMain.GetColumnTag(nCol).ToString().Substring(2)) <= int.Parse(bs_Week)) ▸ for (j < (nCol + 1 + nDayCnt)) ▸ else of (j != (nC… | GRID_SET | siMain.SetValue | (nRow, j, (nDivDay + nDivDayMod).ToString()) | 그리드 값 설정 |  |  |  |
| AC-989fee2d | dsdmLine.Changed [try ▸ switch (e.Type) case FarPoint.Win.Sp… | SCP0029_ProductionPlanLine_SMALL.cs:1214 | if (int.Parse(siMain.GetColumnTag(nCol).ToString().Substring(2)) <= int.Parse(bs_Week)) ▸ for (j < (nCol + 1 + nDayCnt)) | GRID_STYLE | siMain.SetFGColor | (nRow, j, nRow, j, ControlColor.MarkedForeColor) | 그리드 표시 설정 |  |  |  |
| AC-8f44bbe0 | dsdmLine.Changed [try ▸ switch (e.Type) case FarPoint.Win.Sp… | SCP0029_ProductionPlanLine_SMALL.cs:1220 | else of (int.Parse(siMain.GetColumnTag(nCol).ToString().Substring(2)) <= int.Parse(bs_Week)) ▸ if (bCheck) | GRID_SET | siMain.SetValue | (nRow, nCol + 1, nWeek) | 그리드 값 설정 |  |  |  |
| AC-d72744e9 | dsdmLine.Changed [try ▸ switch (e.Type) case FarPoint.Win.Sp… | SCP0029_ProductionPlanLine_SMALL.cs:1221 | else of (int.Parse(siMain.GetColumnTag(nCol).ToString().Substring(2)) <= int.Parse(bs_Week)) ▸ if (bCheck) | GRID_STYLE | siMain.SetFGColor | (nRow, nCol + 1, nRow, nCol + 1, ControlColor.MarkedForeColor) | 그리드 표시 설정 |  |  |  |
| AC-365908ef | dsdmLine.Changed [try ▸ switch (e.Type) case FarPoint.Win.Sp… | SCP0029_ProductionPlanLine_SMALL.cs:1232 | if (ds == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0029_ProductionPlanLine_SMALL.CalculateSum

진입점: this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName)) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try] / this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName)) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try] / dsdmLine.Changed [try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3a6e9d34 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 5 | SCP0029_ProductionPlanLine_SMALL.cs:911 | for (nCol < dt.Columns.Count) ▸ if (dt.Columns[nCol].ColumnName.IndexOf("M_") == 0) | DATA_OP | listMonth.Add | (nCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-c9c83a72 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 5 | SCP0029_ProductionPlanLine_SMALL.cs:915 | for (nCol < dt.Columns.Count) ▸ if (dt.Columns[nCol].ColumnName.IndexOf("W_") == 0) | DATA_OP | listWeek.Add | (nCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-a210fd84 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 5 | SCP0029_ProductionPlanLine_SMALL.cs:960 | for (nCol < dt.Columns.Count) ▸ if (nCol == dt.Columns.Count - 1 \|\| dt.Columns[nCol].ColumnName.IndexOf("W_") == 0) ▸ if (strMeasure == "F… | DATA_OP | dr[nIdxWeek] | weekSum / nCntDayOfWeek | 행/컬럼 값 대입 |  |  |  |
| AC-fc4c51ef | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 5 | SCP0029_ProductionPlanLine_SMALL.cs:964 | for (nCol < dt.Columns.Count) ▸ if (nCol == dt.Columns.Count - 1 \|\| dt.Columns[nCol].ColumnName.IndexOf("W_") == 0) ▸ else of (strMeasure … | DATA_OP | dr[nIdxWeek] | weekSum | 행/컬럼 값 대입 |  |  |  |
| AC-1eaf44fe | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 5 | SCP0029_ProductionPlanLine_SMALL.cs:978 | for (nCol < dt.Columns.Count) ▸ if (nCol == dt.Columns.Count - 1 \|\| dt.Columns[nCol].ColumnName.IndexOf("M_") == 0) ▸ if (strMeasure == "F… | DATA_OP | dr[nIdxMonth] | monthSum / nCntDayOfMonth | 행/컬럼 값 대입 |  |  |  |
| AC-b463b677 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 5 | SCP0029_ProductionPlanLine_SMALL.cs:982 | for (nCol < dt.Columns.Count) ▸ if (nCol == dt.Columns.Count - 1 \|\| dt.Columns[nCol].ColumnName.IndexOf("M_") == 0) ▸ else of (strMeasure … | DATA_OP | dr[nIdxMonth] | monthSum | 행/컬럼 값 대입 |  |  |  |
| AC-7c119a6a | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 5 | SCP0029_ProductionPlanLine_SMALL.cs:991 |  | DATA_OP | dt.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-1310770e | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 5 | SCP0029_ProductionPlanLine_SMALL.cs:1013 | for (nCol < dt.Columns.Count) ▸ if (dt.Columns[nCol].ColumnName.IndexOf("M_") == 0) | DATA_OP | listMonth.Add | (nCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-700d3140 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 5 | SCP0029_ProductionPlanLine_SMALL.cs:1017 | for (nCol < dt.Columns.Count) ▸ if (dt.Columns[nCol].ColumnName.IndexOf("W_") == 0) | DATA_OP | listWeek.Add | (nCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-01350819 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 5 | SCP0029_ProductionPlanLine_SMALL.cs:1078 | for (nRow < dt.Rows.Count) ▸ for (nCol < dt.Columns.Count) ▸ if (nCol == dt.Columns.Count - 1 \|\| dt.Columns[nCol].ColumnName.IndexOf("W_")… | DATA_OP | dr[nIdxWeek] | weekSum / nCntDayOfWeek | 행/컬럼 값 대입 |  |  |  |
| AC-388e5c20 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 5 | SCP0029_ProductionPlanLine_SMALL.cs:1082 | for (nRow < dt.Rows.Count) ▸ for (nCol < dt.Columns.Count) ▸ if (nCol == dt.Columns.Count - 1 \|\| dt.Columns[nCol].ColumnName.IndexOf("W_")… | DATA_OP | dr[nIdxWeek] | weekSum | 행/컬럼 값 대입 |  |  |  |
| AC-b1a4ea8e | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 5 | SCP0029_ProductionPlanLine_SMALL.cs:1100 | for (nRow < dt.Rows.Count) ▸ for (nCol < dt.Columns.Count) ▸ if (nCol == dt.Columns.Count - 1 \|\| dt.Columns[nCol].ColumnName.IndexOf("M_")… | DATA_OP | dr[nIdxMonth] | monthSum / nCntDayOfMonth | 행/컬럼 값 대입 |  |  |  |
| AC-370210cc | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 5 | SCP0029_ProductionPlanLine_SMALL.cs:1104 | for (nRow < dt.Rows.Count) ▸ for (nCol < dt.Columns.Count) ▸ if (nCol == dt.Columns.Count - 1 \|\| dt.Columns[nCol].ColumnName.IndexOf("M_")… | DATA_OP | dr[nIdxMonth] | monthSum | 행/컬럼 값 대입 |  |  |  |
| AC-7c7a17c7 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 5 | SCP0029_ProductionPlanLine_SMALL.cs:1113 |  | DATA_OP | dt.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |

## SCP0029_ProductionPlanLine_SMALL.CboOperationGroup_SelectedIndexChanged

진입점: cboOperationGroup.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6816bbc2 | cboOperationGroup.SelectedIndexChanged | SCP0029_ProductionPlanLine_SMALL.cs:2514 | if (division.Substring(0, 2).Equals("EE")) | FLAG | dtPlantSiteByDivision | Data_SCP.Common(Data_SCP.Type.PlantSiteProdPlan, false, division, pOperationGroup) | 화면 필드/플래그 변경 |  |  |  |
| AC-befb5be0 | cboOperationGroup.SelectedIndexChanged | SCP0029_ProductionPlanLine_SMALL.cs:2514 | if (division.Substring(0, 2).Equals("EE")) | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.PlantSiteProdPlan, false, division, pOperationGroup) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-dde917a7 | cboOperationGroup.SelectedIndexChanged | SCP0029_ProductionPlanLine_SMALL.cs:2516 | else of (division.Substring(0, 2).Equals("EE")) | FLAG | dtPlantSiteByDivision | Data.Common(Data.Type.PlantByDivisionOperation, false, division, pOperationGroup) ⇒ biz:CommonData.CommonDataList [code=PlantByDivisionOperation] | 화면 필드/플래그 변경 |  |  |  |
| AC-347bada4 | cboOperationGroup.SelectedIndexChanged | SCP0029_ProductionPlanLine_SMALL.cs:2516 | else of (division.Substring(0, 2).Equals("EE")) | COMBO_DATA | Data.Common | (Data.Type.PlantByDivisionOperation, false, division, pOperationGroup) ⇒ biz:CommonData.CommonDataList [code=PlantByDivisionOperation] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-17c9b725 | cboOperationGroup.SelectedIndexChanged | SCP0029_ProductionPlanLine_SMALL.cs:2519 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlantSiteByDivision, clbPlantSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-476b7b33 | cboOperationGroup.SelectedIndexChanged | SCP0029_ProductionPlanLine_SMALL.cs:2526 | if (division.Substring(0, 2).Equals("EE")) | FLAG | dtLine | Data_SCP.Common(Data_SCP.Type.LineProdPlanLine, false, division, pOperationGroup, pPlantSi… | 화면 필드/플래그 변경 |  |  |  |
| AC-a45c250c | cboOperationGroup.SelectedIndexChanged | SCP0029_ProductionPlanLine_SMALL.cs:2526 | if (division.Substring(0, 2).Equals("EE")) | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.LineProdPlanLine, false, division, pOperationGroup, pPlantSite, "", "") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-65de0da9 | cboOperationGroup.SelectedIndexChanged | SCP0029_ProductionPlanLine_SMALL.cs:2528 | else of (division.Substring(0, 2).Equals("EE")) | FLAG | dtLine | Data.Common(Data.Type.LineByOperation, false, division, "", "", "", pPlantSite) ⇒ biz:CommonData.CommonDataList [code=LineByOperation] | 화면 필드/플래그 변경 |  |  |  |
| AC-aa7a6b15 | cboOperationGroup.SelectedIndexChanged | SCP0029_ProductionPlanLine_SMALL.cs:2528 | else of (division.Substring(0, 2).Equals("EE")) | COMBO_DATA | Data.Common | (Data.Type.LineByOperation, false, division, "", "", "", pPlantSite) ⇒ biz:CommonData.CommonDataList [code=LineByOperation] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-f231c57b | cboOperationGroup.SelectedIndexChanged | SCP0029_ProductionPlanLine_SMALL.cs:2531 |  | LIST_REBIND | clsCtrl.setListBox | (dtLine, clbLine, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0029_ProductionPlanLine_SMALL.CboPlanDate_SelectedIndexChanged

진입점: cboPlanDate.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-35bb449c | cboPlanDate.SelectedIndexChanged | SCP0029_ProductionPlanLine_SMALL.cs:2540 |  | FLAG | dtPlanType | Data.Common(Data.Type.PlanType, false, division, pPlanDate) ⇒ biz:CommonData.CommonDataList [code=PlanType] | 화면 필드/플래그 변경 |  |  |  |
| AC-4f0d6bb5 | cboPlanDate.SelectedIndexChanged | SCP0029_ProductionPlanLine_SMALL.cs:2540 |  | COMBO_DATA | Data.Common | (Data.Type.PlanType, false, division, pPlanDate) ⇒ biz:CommonData.CommonDataList [code=PlanType] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-25b206b6 | cboPlanDate.SelectedIndexChanged | SCP0029_ProductionPlanLine_SMALL.cs:2541 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanType, cboPlanType, false, "CODE","NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-82518334 | cboPlanDate.SelectedIndexChanged | SCP0029_ProductionPlanLine_SMALL.cs:2542 |  | VALUE_SET | cboPlanType.SelectedIndex | dtPlanType.Rows.Count - 1 | 컨트롤 값 설정 |  |  |  |
| AC-e0fbbc14 | cboPlanDate.SelectedIndexChanged | SCP0029_ProductionPlanLine_SMALL.cs:2544 |  | VALUE_SET | drpPeriod.InitValue | GetDayRange() | 컨트롤 값 설정 |  |  |  |
| AC-0d150b27 | cboPlanDate.SelectedIndexChanged | SCP0029_ProductionPlanLine_SMALL.cs:2549 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |

## SCP0029_ProductionPlanLine_SMALL.CboPlanSeq_SelectedIndexChanged

진입점: cboPlanSeq.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-90fc3d4c | cboPlanSeq.SelectedIndexChanged | SCP0029_ProductionPlanLine_SMALL.cs:2573 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |

## SCP0029_ProductionPlanLine_SMALL.CboPlanType_SelectedIndexChanged

진입점: cboPlanType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c5cf3e07 | cboPlanType.SelectedIndexChanged | SCP0029_ProductionPlanLine_SMALL.cs:2560 |  | FLAG | dtPlanSeq | Data.Common(Data.Type.PlanSeq, false, division, pPlanDate, pPlanType) ⇒ biz:CommonData.CommonDataList [code=PlanSeq] | 화면 필드/플래그 변경 |  |  |  |
| AC-036f3815 | cboPlanType.SelectedIndexChanged | SCP0029_ProductionPlanLine_SMALL.cs:2560 |  | COMBO_DATA | Data.Common | (Data.Type.PlanSeq, false, division, pPlanDate, pPlanType) ⇒ biz:CommonData.CommonDataList [code=PlanSeq] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ae79ef89 | cboPlanType.SelectedIndexChanged | SCP0029_ProductionPlanLine_SMALL.cs:2561 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanSeq, cboPlanSeq, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-a836d139 | cboPlanType.SelectedIndexChanged | SCP0029_ProductionPlanLine_SMALL.cs:2562 |  | VALUE_SET | cboPlanSeq.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-ec28e9dc | cboPlanType.SelectedIndexChanged | SCP0029_ProductionPlanLine_SMALL.cs:2565 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |

## SCP0029_ProductionPlanLine_SMALL.ClbPlantSite_SelectedIndexChanged

진입점: clbPlantSite.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ea98e5a7 | clbPlantSite.SelectedIndexChanged | SCP0029_ProductionPlanLine_SMALL.cs:2498 | if (division.Substring(0, 2).Equals("EE")) | FLAG | dtLine | Data_SCP.Common(Data_SCP.Type.LineProdPlanLine, false, division, pOperationGroup, pPlantSi… | 화면 필드/플래그 변경 |  |  |  |
| AC-d406c417 | clbPlantSite.SelectedIndexChanged | SCP0029_ProductionPlanLine_SMALL.cs:2498 | if (division.Substring(0, 2).Equals("EE")) | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.LineProdPlanLine, false, division, pOperationGroup, pPlantSiteID, "", "") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ad05dba5 | clbPlantSite.SelectedIndexChanged | SCP0029_ProductionPlanLine_SMALL.cs:2500 | else of (division.Substring(0, 2).Equals("EE")) | FLAG | dtLine | Data.Common(Data.Type.LineByOperation, false, division, "", pFactoryID, pOperationID, pPla… ⇒ biz:CommonData.CommonDataList [code=LineByOperation] | 화면 필드/플래그 변경 |  |  |  |
| AC-bab768ed | clbPlantSite.SelectedIndexChanged | SCP0029_ProductionPlanLine_SMALL.cs:2500 | else of (division.Substring(0, 2).Equals("EE")) | COMBO_DATA | Data.Common | (Data.Type.LineByOperation, false, division, "", pFactoryID, pOperationID, pPlantSiteID) ⇒ biz:CommonData.CommonDataList [code=LineByOperation] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-b74c30c2 | clbPlantSite.SelectedIndexChanged | SCP0029_ProductionPlanLine_SMALL.cs:2504 |  | LIST_REBIND | clsCtrl.setListBox | (dtLine, clbLine, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0029_ProductionPlanLine_SMALL.ClearUsrCheckedList

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cc7b15c7 | (진입점 미연결) | SCP0029_ProductionPlanLine_SMALL.cs:206 | if (dt != null) | STATE_RESET | dt.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-1238f4ac | (진입점 미연결) | SCP0029_ProductionPlanLine_SMALL.cs:207 | if (dt != null) | LIST_REBIND | clsCtrl.setListBox | (dt, control, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0029_ProductionPlanLine_SMALL.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b331b34a | this.Load | SCP0029_ProductionPlanLine_SMALL.cs:246 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 3, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-57998e2e | this.Load | SCP0029_ProductionPlanLine_SMALL.cs:246 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, 0) | 화면 필드/플래그 변경 |  |  |  |
| AC-412e97a3 | this.Load | SCP0029_ProductionPlanLine_SMALL.cs:249 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0029_ProductionPlanLine_SMALL.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ce41e509 | this.Load | SCP0029_ProductionPlanLine_SMALL.cs:195 |  | UI_PROP | usrConditionPanel1.Height | 105 | 속성 Height 설정 |  |  |  |
| AC-624da5d9 | this.Load | SCP0029_ProductionPlanLine_SMALL.cs:196 |  | VALUE_SET | cboBucketType.ControlValues | BucketType.Weekly | 컨트롤 값 설정 |  |  |  |
| AC-221ec5dd | this.Load | SCP0029_ProductionPlanLine_SMALL.cs:197 |  | VALUE_SET | chkSum.Checked | false | 컨트롤 값 설정 |  |  |  |

## SCP0029_ProductionPlanLine_SMALL.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e9d59677 | Dispose | SCP0029_ProductionPlanLine_SMALL.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0029_ProductionPlanLine_SMALL.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9ca24380 | EditButton | SCP0029_ProductionPlanLine_SMALL.cs:491 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d5dfa458 | EditButton | SCP0029_ProductionPlanLine_SMALL.cs:495 | if (fps.Name == "spdMain") ▸ if (siMain.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-991a7429 | EditButton | SCP0029_ProductionPlanLine_SMALL.cs:496 | if (fps.Name == "spdMain") | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-2eb53554 | EditButton | SCP0029_ProductionPlanLine_SMALL.cs:497 | if (fps.Name == "spdMain") | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-8f7e5e8d | EditButton | SCP0029_ProductionPlanLine_SMALL.cs:501 | if (fps.Name == "spdMain") | CALL_EXT | fps.ActiveSheet.GetColumnFromTag | (null, CAppSetting.StringAction) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f1678797 | EditButton | SCP0029_ProductionPlanLine_SMALL.cs:502 | if (fps.Name == "spdMain") | CALL_EXT | fps.ActiveSheet.Columns.Get | (xCol1) | ⚠ 의미 확인 필요 |  |  |  |
| AC-2686735c | EditButton | SCP0029_ProductionPlanLine_SMALL.cs:507 | if (fps.Name == "spdMain") | GRID_LOCK | siMain.LockRange | (0, 0, siMain.ActiveSheet.RowCount - 1, siMain.ActiveSheet.ColumnCount - 1, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-54a631c6 | EditButton | SCP0029_ProductionPlanLine_SMALL.cs:512 | if (fps.Name == "spdMain") | CALL_EXT | fps.ActiveSheet.Columns.Get | (xCol1) | ⚠ 의미 확인 필요 |  |  |  |
| AC-7da6a36f | EditButton | SCP0029_ProductionPlanLine_SMALL.cs:517 | if (fps.Name == "spdMain") ▸ if (fps.ActiveSheet.Columns.Get(xCol1).Visible == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e76a8359 | EditButton | SCP0029_ProductionPlanLine_SMALL.cs:528 | if (fps.Name == "spdMain") ▸ for (i < spdMain.ActiveSheet.RowCount) ▸ if (spdMain.ActiveSheet.GetText(i, siMain.GetColumnIndex(DefColumns.ME… | DATA_OP | dtIsEditInfo.Select | ("CP_KEY = '" + strCP_KEY + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-c5d78d05 | EditButton | SCP0029_ProductionPlanLine_SMALL.cs:560 | if (fps.Name == "spdMain") ▸ for (i < spdMain.ActiveSheet.RowCount) ▸ if (spdMain.ActiveSheet.GetText(i, siMain.GetColumnIndex(DefColumns.ME… | DATA_OP | dtPlanType.Select | ("CODE='FN'") | 데이터 객체 조작/조회 |  |  |  |
| AC-4c266427 | EditButton | SCP0029_ProductionPlanLine_SMALL.cs:605 | if (fps.Name == "spdMain") ▸ for (i < spdMain.ActiveSheet.RowCount) ▸ if (spdMain.ActiveSheet.GetText(i, siMain.GetColumnIndex(DefColumns.ME… | GRID_LOCK | siMain.LockRange | (nEditableRow, nStartEditIdx, nEditableRow, siMain.ActiveSheet.ColumnCount - 1, false) | 그리드 편집 잠금/해제 |  |  |  |

## SCP0029_ProductionPlanLine_SMALL.FindData_Main

진입점: this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName)) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.Tables[0].Rows[0][0].ToString() == "S")] / this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName)) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.Tables[0].Rows[0][0].ToString() == "S")] / FindButton / SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.s…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8e316c49 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SCP0029_ProductionPlanLine_SMALL.cs:1383 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-414651d7 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SCP0029_ProductionPlanLine_SMALL.cs:1391 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-14d8085c | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SCP0029_ProductionPlanLine_SMALL.cs:1391 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c28d0b32 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SCP0029_ProductionPlanLine_SMALL.cs:1392 | try | VALIDATE | DateUtil.Check_PeriodDate | (drpPeriod) | 프레임워크 검증 |  |  |  |
| AC-5605dd46 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SCP0029_ProductionPlanLine_SMALL.cs:1392 | try ▸ if (!DateUtil.Check_PeriodDate(drpPeriod)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ce707fdc | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SCP0029_ProductionPlanLine_SMALL.cs:1396 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-40ab121e | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SCP0029_ProductionPlanLine_SMALL.cs:1426 | try | UI_PROP | proxyPivot.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-95f87c95 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SCP0029_ProductionPlanLine_SMALL.cs:1428 | try | ENDPOINT | proxyPivot.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, GSCM_SCP_ANALYS… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-d8af8576 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SCP0029_ProductionPlanLine_SMALL.cs:1431 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0013_GET_PRODUCTION_PLAN_LINEBY") ⇒ SCP.SCP0013_GET_PRODUCTION_PLAN_LINEBY | 엔드포인트 요청 생성 |  |  |  |
| AC-79223edd | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SCP0029_ProductionPlanLine_SMALL.cs:1432 | try ▸ lambda | UI_PROP | req.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-077bc786 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SCP0029_ProductionPlanLine_SMALL.cs:1433 | try ▸ lambda | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-2b9fd9ea | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SCP0029_ProductionPlanLine_SMALL.cs:1434 | try ▸ lambda | DATA_OP | req.Parameters["p_operation_group"] | p_operation_group | 행/컬럼 값 대입 |  |  |  |
| AC-13ccabb1 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SCP0029_ProductionPlanLine_SMALL.cs:1435 | try ▸ lambda | DATA_OP | req.Parameters["p_scm_site_id"] | p_scm_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-bd869b93 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SCP0029_ProductionPlanLine_SMALL.cs:1436 | try ▸ lambda | DATA_OP | req.Parameters["p_line_id"] | p_line_id | 행/컬럼 값 대입 |  |  |  |
| AC-bc725d28 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SCP0029_ProductionPlanLine_SMALL.cs:1437 | try ▸ lambda | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-06d49393 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SCP0029_ProductionPlanLine_SMALL.cs:1438 | try ▸ lambda | DATA_OP | req.Parameters["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-c1d59e74 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SCP0029_ProductionPlanLine_SMALL.cs:1439 | try ▸ lambda | DATA_OP | req.Parameters["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-ca1ec706 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SCP0029_ProductionPlanLine_SMALL.cs:1440 | try ▸ lambda | DATA_OP | req.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-58f9e4bc | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SCP0029_ProductionPlanLine_SMALL.cs:1441 | try ▸ lambda | DATA_OP | req.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-cb2e061a | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SCP0029_ProductionPlanLine_SMALL.cs:1442 | try ▸ lambda | DATA_OP | req.Parameters["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-6b8780da | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SCP0029_ProductionPlanLine_SMALL.cs:1443 | try ▸ lambda | DATA_OP | req.Parameters["p_program_id"] | p_program_id | 행/컬럼 값 대입 |  |  |  |
| AC-d315825f | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SCP0029_ProductionPlanLine_SMALL.cs:1444 | try ▸ lambda | DATA_OP | req.Parameters["p_sheet_name"] | p_sheet_name | 행/컬럼 값 대입 |  |  |  |
| AC-692e66a6 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SCP0029_ProductionPlanLine_SMALL.cs:1445 | try ▸ lambda | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-961f51c4 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SCP0029_ProductionPlanLine_SMALL.cs:1446 | try ▸ lambda | DATA_OP | req.Parameters["p_electrode_type"] | p_electrode_type | 행/컬럼 값 대입 |  |  |  |
| AC-1b9843e6 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SCP0029_ProductionPlanLine_SMALL.cs:1447 | try ▸ lambda | DATA_OP | req.Parameters["p_nick_name"] | p_nick_name | 행/컬럼 값 대입 |  |  |  |
| AC-5e291f50 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SCP0029_ProductionPlanLine_SMALL.cs:1448 | try ▸ lambda | DATA_OP | req.Parameters["p_cell_type_gr"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-6e12e644 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SCP0029_ProductionPlanLine_SMALL.cs:1449 | try ▸ lambda | DATA_OP | req.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-7560cc17 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SCP0029_ProductionPlanLine_SMALL.cs:1450 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-2476dcb8 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SCP0029_ProductionPlanLine_SMALL.cs:1451 | try ▸ lambda | RETURN | return res.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-d1f5cb50 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SCP0029_ProductionPlanLine_SMALL.cs:1458 | try | GRID_BIND | siMain.Query | (dsBinding) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-1313edc2 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SCP0029_ProductionPlanLine_SMALL.cs:1460 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-b12ddae1 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SCP0029_ProductionPlanLine_SMALL.cs:1461 | try | UI_MISC | SetSearchCount | (dsBinding) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-e4d1d47a | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SCP0029_ProductionPlanLine_SMALL.cs:1462 | try | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-cfaafdb4 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SCP0029_ProductionPlanLine_SMALL.cs:1464 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-521836b5 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SCP0029_ProductionPlanLine_SMALL.cs:1478 | try ▸ if (dsBinding.Tables.Count > 0) | FLAG | dtFix | dsBinding.Tables[1] | 화면 필드/플래그 변경 |  |  |  |
| AC-7c941c4b | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SCP0029_ProductionPlanLine_SMALL.cs:1490 | try ▸ if (this.nSelRowOfMain >= 0 && isReload) | GRID_STYLE | siMain.ActiveSheet.SetActiveCell | (this.nSelRowOfMain, this.nSelColOfMain) | 그리드 표시 설정 |  |  |  |
| AC-b05a1b55 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SCP0029_ProductionPlanLine_SMALL.cs:1491 | try ▸ if (this.nSelRowOfMain >= 0 && isReload) | CALL_EXT | spdMain.ShowCell | (0, 0, this.nSelRowOfMain, this.nSelColOfMain, FarPoint.Win.Spread.VerticalPosition.Center… | ⚠ 의미 확인 필요 |  |  |  |
| AC-20df4a79 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SCP0029_ProductionPlanLine_SMALL.cs:1499 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-569cdf11 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SCP0029_ProductionPlanLine_SMALL.cs:1505 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0029_ProductionPlanLine_SMALL.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-208231dd | this.Load | SCP0029_ProductionPlanLine_SMALL.cs:172 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCP0029_ProductionPlanLine_SMALL.Get_IsEditInfo

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-007bfd41 | FindButton | SCP0029_ProductionPlanLine_SMALL.cs:2196 | if (division == null \|\| division == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5eb1453f | FindButton | SCP0029_ProductionPlanLine_SMALL.cs:2225 |  | UI_PROP | proxyPivot.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-a91d8217 | FindButton | SCP0029_ProductionPlanLine_SMALL.cs:2226 |  | ENDPOINT | proxyPivot.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, GSCM_SCP_ANALYS… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-f50554cd | FindButton | SCP0029_ProductionPlanLine_SMALL.cs:2229 | lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0013_GET_PLAN_EDIT_INFO") ⇒ SCP.SCP0013_GET_PLAN_EDIT_INFO | 엔드포인트 요청 생성 |  |  |  |
| AC-702eb793 | FindButton | SCP0029_ProductionPlanLine_SMALL.cs:2230 | lambda | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-4db630af | FindButton | SCP0029_ProductionPlanLine_SMALL.cs:2231 | lambda | DATA_OP | req.Parameters["p_operation_group"] | p_operation_group | 행/컬럼 값 대입 |  |  |  |
| AC-f381aacb | FindButton | SCP0029_ProductionPlanLine_SMALL.cs:2232 | lambda | DATA_OP | req.Parameters["p_scm_site_id"] | p_scm_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-7d2eb55c | FindButton | SCP0029_ProductionPlanLine_SMALL.cs:2233 | lambda | DATA_OP | req.Parameters["p_line_id"] | p_line_id | 행/컬럼 값 대입 |  |  |  |
| AC-5b12a850 | FindButton | SCP0029_ProductionPlanLine_SMALL.cs:2234 | lambda | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-de9066e9 | FindButton | SCP0029_ProductionPlanLine_SMALL.cs:2235 | lambda | DATA_OP | req.Parameters["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-b6b27eba | FindButton | SCP0029_ProductionPlanLine_SMALL.cs:2236 | lambda | DATA_OP | req.Parameters["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-69155c95 | FindButton | SCP0029_ProductionPlanLine_SMALL.cs:2237 | lambda | DATA_OP | req.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-a0920469 | FindButton | SCP0029_ProductionPlanLine_SMALL.cs:2238 | lambda | DATA_OP | req.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-1b37b5fb | FindButton | SCP0029_ProductionPlanLine_SMALL.cs:2239 | lambda | DATA_OP | req.Parameters["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-98510d26 | FindButton | SCP0029_ProductionPlanLine_SMALL.cs:2240 | lambda | DATA_OP | req.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-23f3936f | FindButton | SCP0029_ProductionPlanLine_SMALL.cs:2241 | lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-755e648a | FindButton | SCP0029_ProductionPlanLine_SMALL.cs:2242 | lambda | RETURN | return res.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-53ed00ef | FindButton | SCP0029_ProductionPlanLine_SMALL.cs:2248 | if (dsBinding.Tables.Count > 0) | FLAG | dtIsEditInfo | dsBinding.Tables[0] | 화면 필드/플래그 변경 |  |  |  |

## SCP0029_ProductionPlanLine_SMALL.GetBucketSet

진입점: this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName)) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try] / this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName)) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try] / this.Load / cboPlanDate.SelectedIndexChanged [if (siMain.ActiveSheet.RowCount>0)] / cboPlanTyp…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f3fffe93 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 9 | SCP0029_ProductionPlanLine_SMALL.cs:2647 | if (strPlanDate!="") | ENDPOINT | new FoxDataRequest | ("SCP.SCP0009_GET_SHEET_BUCKET_FIX") ⇒ SCP.SCP0009_GET_SHEET_BUCKET_FIX | 엔드포인트 요청 생성 |  |  |  |
| AC-4e79487b | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 9 | SCP0029_ProductionPlanLine_SMALL.cs:2649 | if (strPlanDate!="") | DATA_OP | request.Parameters["p_division_id"] | division | 행/컬럼 값 대입 |  |  |  |
| AC-a600dab8 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 9 | SCP0029_ProductionPlanLine_SMALL.cs:2650 | if (strPlanDate!="") | DATA_OP | request.Parameters["p_plan_start_yyyymmdd"] | strPlanDate.Replace("-", "") | 행/컬럼 값 대입 |  |  |  |
| AC-43f97986 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 9 | SCP0029_ProductionPlanLine_SMALL.cs:2652 | if (strPlanDate!="") | FLAG | dtBucketSet | client.ExecuteDataSet(request).DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-57b91ee6 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 9 | SCP0029_ProductionPlanLine_SMALL.cs:2652 | if (strPlanDate!="") | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## SCP0029_ProductionPlanLine_SMALL.GetBucketType

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cb1889f5 | this.Load | SCP0029_ProductionPlanLine_SMALL.cs:1245 |  | ENDPOINT | new FoxDataRequest | ("DM.DM0003_GET_BUCKET_TYPE_CODE") ⇒ DM.DM0003_GET_BUCKET_TYPE_CODE | 엔드포인트 요청 생성 |  |  |  |
| AC-89c9c520 | this.Load | SCP0029_ProductionPlanLine_SMALL.cs:1246 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-3ba147f0 | this.Load | SCP0029_ProductionPlanLine_SMALL.cs:1249 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SCP0029_ProductionPlanLine_SMALL.GetDayRange

진입점: this.Load / cboPlanDate.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6cfe0515 | this.Load 외 1 | SCP0029_ProductionPlanLine_SMALL.cs:2662 |  | CALL_EXT | DateUtil.GetDayRange | (cboDivision.ControlValues, cboBucketType.ControlValues, cboPlanDate.ControlValues) | ⚠ 의미 확인 필요 |  |  |  |
| AC-7161992e | this.Load 외 1 | SCP0029_ProductionPlanLine_SMALL.cs:2664 |  | RETURN | return sDayRange; |  | 처리 중단/반환 |  |  |  |

## SCP0029_ProductionPlanLine_SMALL.GetLastPlanVersion

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7930ed0e | (진입점 미연결) | SCP0029_ProductionPlanLine_SMALL.cs:1334 | try | ENDPOINT | new FoxDataRequest | ("SCP.SCP0011_GET_LAST_PLAN_VERSION") ⇒ SCP.SCP0011_GET_LAST_PLAN_VERSION | 엔드포인트 요청 생성 |  |  |  |
| AC-7b653e05 | (진입점 미연결) | SCP0029_ProductionPlanLine_SMALL.cs:1336 | try | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-1cc35850 | (진입점 미연결) | SCP0029_ProductionPlanLine_SMALL.cs:1337 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-86b76842 | (진입점 미연결) | SCP0029_ProductionPlanLine_SMALL.cs:1353 | try ▸ if (dsBinding.Tables.Count > 0 && dsBinding.Tables[0].Rows.Count > 0) | VALUE_SET | cboPlanDate.SelectedValue | PLAN_START_YYYYMMDD | 컨트롤 값 설정 |  |  |  |
| AC-3dfcbea3 | (진입점 미연결) | SCP0029_ProductionPlanLine_SMALL.cs:1354 | try ▸ if (dsBinding.Tables.Count > 0 && dsBinding.Tables[0].Rows.Count > 0) | VALUE_SET | cboPlanType.SelectedValue | PLAN_TYPE | 컨트롤 값 설정 |  |  |  |
| AC-d9570dfd | (진입점 미연결) | SCP0029_ProductionPlanLine_SMALL.cs:1355 | try ▸ if (dsBinding.Tables.Count > 0 && dsBinding.Tables[0].Rows.Count > 0) | VALUE_SET | cboPlanSeq.SelectedValue | PLAN_SEQ | 컨트롤 값 설정 |  |  |  |

## SCP0029_ProductionPlanLine_SMALL.GetSpdTitle

진입점: this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName)) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try] / this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName)) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try] / this.Load / cboPlanDate.SelectedIndexChanged [if (siMain.ActiveSheet.RowCount>0)] / cboPlanTyp…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-71723ba6 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 9 | SCP0029_ProductionPlanLine_SMALL.cs:2623 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN") ⇒ SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | 엔드포인트 요청 생성 |  |  |  |
| AC-e17e7e04 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 9 | SCP0029_ProductionPlanLine_SMALL.cs:2628 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | drpPeriod.Text1.Replace("-", "") | 행/컬럼 값 대입 |  |  |  |
| AC-3b8783c7 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 9 | SCP0029_ProductionPlanLine_SMALL.cs:2629 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | drpPeriod.Text2.Replace("-", "") | 행/컬럼 값 대입 |  |  |  |
| AC-7c55971f | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 9 | SCP0029_ProductionPlanLine_SMALL.cs:2631 |  | FLAG | dsSpdTitle | client.ExecuteDataSet(request).DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-65c694e7 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 9 | SCP0029_ProductionPlanLine_SMALL.cs:2631 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## SCP0029_ProductionPlanLine_SMALL.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-deac51bc | this.Load | SCP0029_ProductionPlanLine_SMALL.cs:214 |  | DATA_OP | this.ConditionNotUseList.Add | (cboPlanDate) | 데이터 객체 조작/조회 |  |  |  |
| AC-83436ddf | this.Load | SCP0029_ProductionPlanLine_SMALL.cs:215 |  | DATA_OP | this.ConditionNotUseList.Add | (cboPlanType) | 데이터 객체 조작/조회 |  |  |  |
| AC-5d180920 | this.Load | SCP0029_ProductionPlanLine_SMALL.cs:216 |  | DATA_OP | this.ConditionNotUseList.Add | (cboPlanSeq) | 데이터 객체 조작/조회 |  |  |  |
| AC-c1f3ecd0 | this.Load | SCP0029_ProductionPlanLine_SMALL.cs:220 | if (dtMyDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |
| AC-f27b2031 | this.Load | SCP0029_ProductionPlanLine_SMALL.cs:222 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-e2b97781 | this.Load | SCP0029_ProductionPlanLine_SMALL.cs:226 |  | LIST_REBIND | clsCtrl.setListBox | (dtMyDivision, cboDivision, false,"CODE","NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-acb8a4c3 | this.Load | SCP0029_ProductionPlanLine_SMALL.cs:232 |  | LIST_REBIND | clsCtrl.setListBox | (dtElectrodeType, cboElectrode, false) | 목록 컨트롤 재구성 |  |  |  |
| AC-bffeeff0 | this.Load | SCP0029_ProductionPlanLine_SMALL.cs:236 |  | FLAG | dtBucketType | GetBucketType() | 화면 필드/플래그 변경 |  |  |  |
| AC-01b4342c | this.Load | SCP0029_ProductionPlanLine_SMALL.cs:237 |  | LIST_REBIND | clsCtrl.setListBox | (dtBucketType, cboBucketType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-0365f232 | this.Load | SCP0029_ProductionPlanLine_SMALL.cs:239 |  | VALUE_SET | drpPeriod.InitValue | GetDayRange() | 컨트롤 값 설정 |  |  |  |

## SCP0029_ProductionPlanLine_SMALL.InitSpread

진입점: this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName)) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try] / this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName)) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try] / this.Load / cboPlanDate.SelectedIndexChanged [if (siMain.ActiveSheet.RowCount>0)] / cboPlanTyp…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-19866876 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 9 | SCP0029_ProductionPlanLine_SMALL.cs:263 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.InitSheet | (SpdSheet.shtMain) | 그리드 재구성/초기화 |  |  |  |
| AC-a716180c | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 9 | SCP0029_ProductionPlanLine_SMALL.cs:311 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_SET | spdInfo.ActiveSheet.DataSource | null | 그리드 속성/값 설정 |  |  |  |
| AC-b9daadee | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 9 | SCP0029_ProductionPlanLine_SMALL.cs:312 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.SetSheetHeaderColumn | (spdInfo, 3) | 그리드 재구성/초기화 |  |  |  |
| AC-569772cd | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 9 | SCP0029_ProductionPlanLine_SMALL.cs:317 | if (spdInfo.SheetName == SpdSheet.shtMain) | UI_PROP | spdInfo.nIdxData | nIdxDataMain | 속성 nIdxData 설정 |  |  |  |
| AC-e8c6c1c9 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 9 | SCP0029_ProductionPlanLine_SMALL.cs:323 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-966ef735 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 9 | SCP0029_ProductionPlanLine_SMALL.cs:325 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-ff33baf2 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 9 | SCP0029_ProductionPlanLine_SMALL.cs:329 | if (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (!division.Substring(0, 2).Equals("EE")) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex("ORIGIN_DIVISION_ID")].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-b7f46440 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 9 | SCP0029_ProductionPlanLine_SMALL.cs:330 | if (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (!division.Substring(0, 2).Equals("EE")) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex("ELECTRODE_TYPE")].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-5f58163c | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 9 | SCP0029_ProductionPlanLine_SMALL.cs:334 | if (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (!division.Substring(0, 2).Equals("EE")) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex("ORIGIN_DIVISION_ID")].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-6c86c48d | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 9 | SCP0029_ProductionPlanLine_SMALL.cs:335 | if (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (!division.Substring(0, 2).Equals("EE")) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex("ELECTRODE_TYPE")].Visible | true | 그리드 속성/값 설정 |  |  |  |

## SCP0029_ProductionPlanLine_SMALL.InitSpreadDateColumn

진입점: this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName)) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName)) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / this…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dbde6f2b | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 9 | SCP0029_ProductionPlanLine_SMALL.cs:375 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sColumnName.IndexOf("B_") > 0) | GRID_INIT | spdInfo.AddTextColumn | (sColumnLabelname, sColumnName, FPMerge.None, 0, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7f2fbec3 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 9 | SCP0029_ProductionPlanLine_SMALL.cs:379 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sColumnName.IndexOf("B_") > 0) | GRID_INIT | spdInfo.AddNumColumn | (sColumnLabelname, sColumnName, FPMerge.None, 70, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-65c5888f | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 9 | SCP0029_ProductionPlanLine_SMALL.cs:380 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sColumnName.IndexOf("B_") > 0) | GRID_INIT | spdInfo.SetReNumerCellType | (spdInfo, spdInfo.GetColumnIndex(sColumnName),0,0) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-4fde560a | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 9 | SCP0029_ProductionPlanLine_SMALL.cs:384 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sColumnName.IndexOf("B_") > 0) ▸ if (sDayCode == DefColumnsLabel.Saturday \|\| … | GRID_SET | spdInfo.Sheet().ColumnHeader.Cells[2, spdInfo.GetMaxColumnIndex()].ForeColor | sDayCode == DefColumnsLabel.Saturday ? Color.Blue : Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-0eafa953 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 9 | SCP0029_ProductionPlanLine_SMALL.cs:391 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-55835cec | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 9 | SCP0029_ProductionPlanLine_SMALL.cs:392 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6fd402d0 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 9 | SCP0029_ProductionPlanLine_SMALL.cs:397 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-22ce769f | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 9 | SCP0029_ProductionPlanLine_SMALL.cs:398 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 30, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9a66202e | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 9 | SCP0029_ProductionPlanLine_SMALL.cs:406 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName != sSmallLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e524ce22 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 9 | SCP0029_ProductionPlanLine_SMALL.cs:407 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName != sSmallLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-71559ec1 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 9 | SCP0029_ProductionPlanLine_SMALL.cs:417 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-53e5b4af | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 9 | SCP0029_ProductionPlanLine_SMALL.cs:418 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-aa6ab09f | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 9 | SCP0029_ProductionPlanLine_SMALL.cs:419 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6fdb2788 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 9 | SCP0029_ProductionPlanLine_SMALL.cs:420 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0029_ProductionPlanLine_SMALL.SaveData_FixInfo

진입점: this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName))] / this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a2e7c921 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0029_ProductionPlanLine_SMALL.cs:1914 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (siMain.ActiveSheet.Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-fe7343ef | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0029_ProductionPlanLine_SMALL.cs:1948 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (selCells.Length < 1) | MESSAGE | MessageHelper.GMessageBox | ("MSG00134", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-738eacbd | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0029_ProductionPlanLine_SMALL.cs:1949 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (selCells.Length < 1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4f73f104 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0029_ProductionPlanLine_SMALL.cs:1993 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | GRID_STYLE | siMain.SetBGColor | (i, j, i, j, ControlColor.InvalidColor) | 그리드 표시 설정 |  |  |  |
| AC-5a207864 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0029_ProductionPlanLine_SMALL.cs:1994 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | MESSAGE | MessageHelper.GMessageBox | ("MSG00026", new object[] { null}) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b3ad2511 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0029_ProductionPlanLine_SMALL.cs:1995 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a27e5011 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0029_ProductionPlanLine_SMALL.cs:2001 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | CALL_EXT | siMain.GetBGColor | (i, j) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b6fc770d | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0029_ProductionPlanLine_SMALL.cs:2037 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | CALL_EXT | siMain.GetBGColor | (i, j+ nDayCntOfWeek) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3a030085 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0029_ProductionPlanLine_SMALL.cs:2087 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (fixType == "F") | POPUP | new SCM0002_RejectReasonPopup | ("Fix Reason") | 팝업/폼 생성 |  |  |  |
| AC-77c03234 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0029_ProductionPlanLine_SMALL.cs:2088 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (fixType == "F") | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-b5d3e7f3 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0029_ProductionPlanLine_SMALL.cs:2089 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (fixType == "F") | UI_PROP | popup.Width | 600 | 속성 Width 설정 |  |  |  |
| AC-e85bdced | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0029_ProductionPlanLine_SMALL.cs:2090 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (fixType == "F") | UI_PROP | popup.Height | 230 | 속성 Height 설정 |  |  |  |
| AC-7aa94701 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0029_ProductionPlanLine_SMALL.cs:2092 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (fixType == "F") | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-40d54832 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0029_ProductionPlanLine_SMALL.cs:2101 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (fixType == "F") ▸… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-77d90651 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0029_ProductionPlanLine_SMALL.cs:2107 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ else of (fixType == "… | MESSAGE | MessageHelper.GMessageBox | ("MSG00016") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-025630f0 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0029_ProductionPlanLine_SMALL.cs:2107 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ else of (fixType == "… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b77c2788 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0029_ProductionPlanLine_SMALL.cs:2117 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | ENDPOINT | new FoxDataRequest | ("SCP.SCP0024_SAVE_PRODUCTION_PLAN_FIX") ⇒ SCP.SCP0024_SAVE_PRODUCTION_PLAN_FIX | 엔드포인트 요청 생성 |  |  |  |
| AC-9a6dda16 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0029_ProductionPlanLine_SMALL.cs:2121 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-27d32510 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0029_ProductionPlanLine_SMALL.cs:2122 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-9fb8245f | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0029_ProductionPlanLine_SMALL.cs:2123 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_operation_group"] | p_operation_group | 행/컬럼 값 대입 |  |  |  |
| AC-604a0d6d | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0029_ProductionPlanLine_SMALL.cs:2124 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_scm_site_id"] | p_scm_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-6f2f3fe0 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0029_ProductionPlanLine_SMALL.cs:2125 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_line_id"] | p_line_id | 행/컬럼 값 대입 |  |  |  |
| AC-813ace5e | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0029_ProductionPlanLine_SMALL.cs:2126 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-371185e4 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0029_ProductionPlanLine_SMALL.cs:2127 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_operation_id"] | p_operation_id | 행/컬럼 값 대입 |  |  |  |
| AC-aac9ff81 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0029_ProductionPlanLine_SMALL.cs:2128 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_yyyymmdd"] | p_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-c9a431af | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0029_ProductionPlanLine_SMALL.cs:2129 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_qty"] | p_qty | 행/컬럼 값 대입 |  |  |  |
| AC-d090ebd7 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0029_ProductionPlanLine_SMALL.cs:2130 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_fix_reason"] | strReason | 행/컬럼 값 대입 |  |  |  |
| AC-04357273 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0029_ProductionPlanLine_SMALL.cs:2131 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_user_id"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-3274be58 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0029_ProductionPlanLine_SMALL.cs:2132 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_origin_division_id"] | p_origin_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-9b8e56cd | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0029_ProductionPlanLine_SMALL.cs:2133 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_electrode_type"] | p_electrode_type | 행/컬럼 값 대입 |  |  |  |
| AC-e62467ac | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0029_ProductionPlanLine_SMALL.cs:2134 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-7aa8eb2d | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0029_ProductionPlanLine_SMALL.cs:2137 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-87bc884b | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0029_ProductionPlanLine_SMALL.cs:2142 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { response.DataSet.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-87de29a3 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0029_ProductionPlanLine_SMALL.cs:2155 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ else of (response.Dat… | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f72353f2 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0029_ProductionPlanLine_SMALL.cs:2163 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-25ba0588 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SCP0029_ProductionPlanLine_SMALL.cs:2178 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ else of (iCount > 0) ▸ if (strAction == "D") | MESSAGE | MessageHelper.GMessageBox | ("MSG00046", new object[] { null}) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SCP0029_ProductionPlanLine_SMALL.SaveData_Line

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-52766a5c | (진입점 미연결) | SCP0029_ProductionPlanLine_SMALL.cs:1518 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (siMain.ActiveSheet.Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3e2309b4 | (진입점 미연결) | SCP0029_ProductionPlanLine_SMALL.cs:1581 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j <… | GRID_STYLE | siMain.SetBGColor | (i, j, i, j, ControlColor.InvalidColor) | 그리드 표시 설정 |  |  |  |
| AC-5c387866 | (진입점 미연결) | SCP0029_ProductionPlanLine_SMALL.cs:1582 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j <… | MESSAGE | MessageHelper.GMessageBox | ("MSG00084", new object[] { null }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d2753015 | (진입점 미연결) | SCP0029_ProductionPlanLine_SMALL.cs:1583 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j <… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-35937492 | (진입점 미연결) | SCP0029_ProductionPlanLine_SMALL.cs:1633 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | ENDPOINT | new FoxDataRequest | ("SCP.SCP0011_SAVE_PRODUCTION_PLAN_LINE") ⇒ SCP.SCP0011_SAVE_PRODUCTION_PLAN_LINE | 엔드포인트 요청 생성 |  |  |  |
| AC-d72680fe | (진입점 미연결) | SCP0029_ProductionPlanLine_SMALL.cs:1637 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_active_flag"] | strACTIVE_FLAG | 행/컬럼 값 대입 |  |  |  |
| AC-2ca3f285 | (진입점 미연결) | SCP0029_ProductionPlanLine_SMALL.cs:1638 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_division_id"] | strDIVISION_ID | 행/컬럼 값 대입 |  |  |  |
| AC-d832ea5d | (진입점 미연결) | SCP0029_ProductionPlanLine_SMALL.cs:1639 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_plan_start_yyyymmdd"] | strPLAN_START_YYYYMMDD | 행/컬럼 값 대입 |  |  |  |
| AC-fdb4e16e | (진입점 미연결) | SCP0029_ProductionPlanLine_SMALL.cs:1640 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_plan_type"] | strPLAN_TYPE | 행/컬럼 값 대입 |  |  |  |
| AC-3c3fcf29 | (진입점 미연결) | SCP0029_ProductionPlanLine_SMALL.cs:1641 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_seq"] | strSEQ | 행/컬럼 값 대입 |  |  |  |
| AC-d3ff71b2 | (진입점 미연결) | SCP0029_ProductionPlanLine_SMALL.cs:1642 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_operation_group"] | strOPERATION_GROUP | 행/컬럼 값 대입 |  |  |  |
| AC-fbf72da9 | (진입점 미연결) | SCP0029_ProductionPlanLine_SMALL.cs:1643 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_scm_site_id"] | strSCM_SITE_ID | 행/컬럼 값 대입 |  |  |  |
| AC-964b1521 | (진입점 미연결) | SCP0029_ProductionPlanLine_SMALL.cs:1644 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_item_id"] | strITEM_ID | 행/컬럼 값 대입 |  |  |  |
| AC-8907fbd7 | (진입점 미연결) | SCP0029_ProductionPlanLine_SMALL.cs:1645 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_line_id"] | strLINE_ID | 행/컬럼 값 대입 |  |  |  |
| AC-26e74b25 | (진입점 미연결) | SCP0029_ProductionPlanLine_SMALL.cs:1646 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_operation_id"] | strOPERATION_ID | 행/컬럼 값 대입 |  |  |  |
| AC-30a3c732 | (진입점 미연결) | SCP0029_ProductionPlanLine_SMALL.cs:1647 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_measure"] | strMEASURE | 행/컬럼 값 대입 |  |  |  |
| AC-66d615b4 | (진입점 미연결) | SCP0029_ProductionPlanLine_SMALL.cs:1648 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_yyyymmdd"] | strYYYYMMDD | 행/컬럼 값 대입 |  |  |  |
| AC-061bd13b | (진입점 미연결) | SCP0029_ProductionPlanLine_SMALL.cs:1649 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_qty"] | strQTY | 행/컬럼 값 대입 |  |  |  |
| AC-2261c780 | (진입점 미연결) | SCP0029_ProductionPlanLine_SMALL.cs:1650 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_user_id"] | strUSER_ID | 행/컬럼 값 대입 |  |  |  |
| AC-d59fd624 | (진입점 미연결) | SCP0029_ProductionPlanLine_SMALL.cs:1651 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_fix"] | strFIX | 행/컬럼 값 대입 |  |  |  |
| AC-793096de | (진입점 미연결) | SCP0029_ProductionPlanLine_SMALL.cs:1652 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_electrode_type"] | strELECTRODE_TYPE | 행/컬럼 값 대입 |  |  |  |
| AC-f4b6d757 | (진입점 미연결) | SCP0029_ProductionPlanLine_SMALL.cs:1653 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_origin_division_id"] | strORIGIN_DIVISION_ID | 행/컬럼 값 대입 |  |  |  |
| AC-3c8d8f1b | (진입점 미연결) | SCP0029_ProductionPlanLine_SMALL.cs:1655 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_program_id"] | "SCP0013" | 행/컬럼 값 대입 |  |  |  |
| AC-385111ec | (진입점 미연결) | SCP0029_ProductionPlanLine_SMALL.cs:1656 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-37920d17 | (진입점 미연결) | SCP0029_ProductionPlanLine_SMALL.cs:1658 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-90d7886c | (진입점 미연결) | SCP0029_ProductionPlanLine_SMALL.cs:1663 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { response.DataSet.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0aa7fde9 | (진입점 미연결) | SCP0029_ProductionPlanLine_SMALL.cs:1678 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ else of (response.Dat… | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-19e5a3eb | (진입점 미연결) | SCP0029_ProductionPlanLine_SMALL.cs:1688 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SCP0029_ProductionPlanLine_SMALL.SaveData_Line_DT

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-780e6c89 | SaveButton | SCP0029_ProductionPlanLine_SMALL.cs:1707 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-9191b366 | SaveButton | SCP0029_ProductionPlanLine_SMALL.cs:1715 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (siMain.ActiveSheet.Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-56a1355a | SaveButton | SCP0029_ProductionPlanLine_SMALL.cs:1722 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("A", typeof(char)) | 데이터 객체 조작/조회 |  |  |  |
| AC-967bd11e | SaveButton | SCP0029_ProductionPlanLine_SMALL.cs:1723 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_active_flag") | 데이터 객체 조작/조회 |  |  |  |
| AC-ad4311c9 | SaveButton | SCP0029_ProductionPlanLine_SMALL.cs:1724 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_division_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-08d9763f | SaveButton | SCP0029_ProductionPlanLine_SMALL.cs:1725 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_plan_start_yyyymmdd") | 데이터 객체 조작/조회 |  |  |  |
| AC-1f32efc5 | SaveButton | SCP0029_ProductionPlanLine_SMALL.cs:1726 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_plan_type") | 데이터 객체 조작/조회 |  |  |  |
| AC-1b159e7f | SaveButton | SCP0029_ProductionPlanLine_SMALL.cs:1727 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_seq") | 데이터 객체 조작/조회 |  |  |  |
| AC-849bdbda | SaveButton | SCP0029_ProductionPlanLine_SMALL.cs:1728 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_operation_group") | 데이터 객체 조작/조회 |  |  |  |
| AC-6593e746 | SaveButton | SCP0029_ProductionPlanLine_SMALL.cs:1729 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_scm_site_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-d10d4cde | SaveButton | SCP0029_ProductionPlanLine_SMALL.cs:1730 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_item_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-a493b56a | SaveButton | SCP0029_ProductionPlanLine_SMALL.cs:1731 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_line_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-a68113db | SaveButton | SCP0029_ProductionPlanLine_SMALL.cs:1732 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_operation_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-c850523e | SaveButton | SCP0029_ProductionPlanLine_SMALL.cs:1733 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_measure") | 데이터 객체 조작/조회 |  |  |  |
| AC-c2371800 | SaveButton | SCP0029_ProductionPlanLine_SMALL.cs:1734 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_yyyymmdd") | 데이터 객체 조작/조회 |  |  |  |
| AC-4f2b246c | SaveButton | SCP0029_ProductionPlanLine_SMALL.cs:1735 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_qty") | 데이터 객체 조작/조회 |  |  |  |
| AC-1e1e64e8 | SaveButton | SCP0029_ProductionPlanLine_SMALL.cs:1736 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_user_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-dbec5e67 | SaveButton | SCP0029_ProductionPlanLine_SMALL.cs:1737 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_fix") | 데이터 객체 조작/조회 |  |  |  |
| AC-d647bc93 | SaveButton | SCP0029_ProductionPlanLine_SMALL.cs:1738 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_loc_flag") | 데이터 객체 조작/조회 |  |  |  |
| AC-15d39d54 | SaveButton | SCP0029_ProductionPlanLine_SMALL.cs:1739 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_program_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-7c06be57 | SaveButton | SCP0029_ProductionPlanLine_SMALL.cs:1740 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("debug_mode") | 데이터 객체 조작/조회 |  |  |  |
| AC-3a2f78cf | SaveButton | SCP0029_ProductionPlanLine_SMALL.cs:1741 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_origin_division_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-9e895ff7 | SaveButton | SCP0029_ProductionPlanLine_SMALL.cs:1742 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_electrode_type") | 데이터 객체 조작/조회 |  |  |  |
| AC-24b39306 | SaveButton | SCP0029_ProductionPlanLine_SMALL.cs:1744 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dsInput.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-359e70dd | SaveButton | SCP0029_ProductionPlanLine_SMALL.cs:1779 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | GRID_STYLE | siMain.SetBGColor | (i, j, i, j, ControlColor.InvalidColor) | 그리드 표시 설정 |  |  |  |
| AC-b36a3006 | SaveButton | SCP0029_ProductionPlanLine_SMALL.cs:1780 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | MESSAGE | MessageHelper.GMessageBox | ("MSG00084", new object[] { null }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3ace181a | SaveButton | SCP0029_ProductionPlanLine_SMALL.cs:1781 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b4228d4c | SaveButton | SCP0029_ProductionPlanLine_SMALL.cs:1788 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dsInput.Tables[0].NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-97692510 | SaveButton | SCP0029_ProductionPlanLine_SMALL.cs:1790 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["A"] | action | 행/컬럼 값 대입 |  |  |  |
| AC-3fb91209 | SaveButton | SCP0029_ProductionPlanLine_SMALL.cs:1791 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_active_flag"] | action | 행/컬럼 값 대입 |  |  |  |
| AC-7f199da9 | SaveButton | SCP0029_ProductionPlanLine_SMALL.cs:1792 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_division_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.DIVISION_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-0286b937 | SaveButton | SCP0029_ProductionPlanLine_SMALL.cs:1793 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_plan_start_yyyymmdd"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.PLAN_START_YYYYMMDD)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-6a1c3a09 | SaveButton | SCP0029_ProductionPlanLine_SMALL.cs:1794 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_plan_type"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.PLAN_TYPE)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-3e96c970 | SaveButton | SCP0029_ProductionPlanLine_SMALL.cs:1795 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_seq"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.PLAN_SEQ)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-ee3ae26c | SaveButton | SCP0029_ProductionPlanLine_SMALL.cs:1796 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_operation_group"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.OPERATION_GROUP)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-fa61b2cd | SaveButton | SCP0029_ProductionPlanLine_SMALL.cs:1797 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_scm_site_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-b5be8ef8 | SaveButton | SCP0029_ProductionPlanLine_SMALL.cs:1798 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_item_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ITEM_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-066f47ec | SaveButton | SCP0029_ProductionPlanLine_SMALL.cs:1799 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_line_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.LINE_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-037d86ec | SaveButton | SCP0029_ProductionPlanLine_SMALL.cs:1800 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_operation_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.OPERATION_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-5892d9e8 | SaveButton | SCP0029_ProductionPlanLine_SMALL.cs:1801 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_measure"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.MEASURE)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-94a76859 | SaveButton | SCP0029_ProductionPlanLine_SMALL.cs:1802 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_origin_division_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ORIGIN_DIVISION_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-9ab95cf0 | SaveButton | SCP0029_ProductionPlanLine_SMALL.cs:1803 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_electrode_type"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ELECTRODE_TYPE)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-5be45f02 | SaveButton | SCP0029_ProductionPlanLine_SMALL.cs:1804 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_yyyymmdd"] | strDayName | 행/컬럼 값 대입 |  |  |  |
| AC-f7b7715e | SaveButton | SCP0029_ProductionPlanLine_SMALL.cs:1805 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_qty"] | strDayQty | 행/컬럼 값 대입 |  |  |  |
| AC-d6abf90d | SaveButton | SCP0029_ProductionPlanLine_SMALL.cs:1806 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_fix"] | isFix | 행/컬럼 값 대입 |  |  |  |
| AC-c57f2e57 | SaveButton | SCP0029_ProductionPlanLine_SMALL.cs:1807 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_loc_flag"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-ec6980db | SaveButton | SCP0029_ProductionPlanLine_SMALL.cs:1808 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-e34baec8 | SaveButton | SCP0029_ProductionPlanLine_SMALL.cs:1809 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_program_id"] | "SCP0013" | 행/컬럼 값 대입 |  |  |  |
| AC-548171f8 | SaveButton | SCP0029_ProductionPlanLine_SMALL.cs:1810 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-d907b0f0 | SaveButton | SCP0029_ProductionPlanLine_SMALL.cs:1813 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dsInput.Tables[0].Rows.Add | (dr) | 데이터 객체 조작/조회 |  |  |  |
| AC-3fde01e6 | SaveButton | SCP0029_ProductionPlanLine_SMALL.cs:1823 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | GRID_SET | dsInput.Tables[0].Rows[0]["p_loc_flag"] | "F" | 그리드 속성/값 설정 |  |  |  |
| AC-694ea78d | SaveButton | SCP0029_ProductionPlanLine_SMALL.cs:1824 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | GRID_SET | dsInput.Tables[0].Rows[nRowCnt - 1]["p_loc_flag"] | "L" | 그리드 속성/값 설정 |  |  |  |
| AC-af07e856 | SaveButton | SCP0029_ProductionPlanLine_SMALL.cs:1826 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dsInput.Tables[0].AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-69575528 | SaveButton | SCP0029_ProductionPlanLine_SMALL.cs:1830 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-2173345e | SaveButton | SCP0029_ProductionPlanLine_SMALL.cs:1841 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ foreach (DataRo… | CALL_EXT | row.SetAdded | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-090195c1 | SaveButton | SCP0029_ProductionPlanLine_SMALL.cs:1842 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ foreach (DataRo… | CALL_EXT | row.SetModified | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-4b471424 | SaveButton | SCP0029_ProductionPlanLine_SMALL.cs:1843 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ foreach (DataRo… | DATA_OP | row.Delete | () | 데이터 객체 조작/조회 |  |  |  |
| AC-0bbefe28 | SaveButton | SCP0029_ProductionPlanLine_SMALL.cs:1847 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | UI_PROP | request.InsertQueryId | "SCP.SCP0013_SAVE_PRODUCTION_PLAN_LINE_ROW" | 속성 InsertQueryId 설정 |  |  |  |
| AC-cd528f55 | SaveButton | SCP0029_ProductionPlanLine_SMALL.cs:1848 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | UI_PROP | request.DeleteQueryId | "SCP.SCP0013_SAVE_PRODUCTION_PLAN_LINE_ROW" | 속성 DeleteQueryId 설정 |  |  |  |
| AC-a9072f84 | SaveButton | SCP0029_ProductionPlanLine_SMALL.cs:1849 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | UI_PROP | request.UpdateQueryId | "SCP.SCP0013_SAVE_PRODUCTION_PLAN_LINE_ROW" | 속성 UpdateQueryId 설정 |  |  |  |
| AC-498ccbf8 | SaveButton | SCP0029_ProductionPlanLine_SMALL.cs:1850 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | UI_PROP | request.DataSet | dsInput.GetChanges() | 속성 DataSet 설정 |  |  |  |
| AC-c4fbdac9 | SaveButton | SCP0029_ProductionPlanLine_SMALL.cs:1850 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | CALL_EXT | dsInput.GetChanges | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-ec3bb6da | SaveButton | SCP0029_ProductionPlanLine_SMALL.cs:1853 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-90653554 | SaveButton | SCP0029_ProductionPlanLine_SMALL.cs:1854 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, GSCM_SCP_ANALYS… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-5139ae9a | SaveButton | SCP0029_ProductionPlanLine_SMALL.cs:1858 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ lambda | ENDPOINT | client.SaveDataTable | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-c6b90b9d | SaveButton | SCP0029_ProductionPlanLine_SMALL.cs:1858 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ lambda | RETURN | return client.SaveDataTable(request); |  | 처리 중단/반환 |  |  |  |
| AC-de916147 | SaveButton | SCP0029_ProductionPlanLine_SMALL.cs:1861 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-668c3901 | SaveButton | SCP0029_ProductionPlanLine_SMALL.cs:1866 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (t.Success) | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { iCount }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ec33c16b | SaveButton | SCP0029_ProductionPlanLine_SMALL.cs:1878 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ catch ((Exception ex)… | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-d181dfc4 | SaveButton | SCP0029_ProductionPlanLine_SMALL.cs:1880 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ catch ((Exception ex)… | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6944b553 | SaveButton | SCP0029_ProductionPlanLine_SMALL.cs:1884 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-9daf7736 | SaveButton | SCP0029_ProductionPlanLine_SMALL.cs:1894 | catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-ce0c16a7 | SaveButton | SCP0029_ProductionPlanLine_SMALL.cs:1896 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d6cc9ff7 | SaveButton | SCP0029_ProductionPlanLine_SMALL.cs:1900 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-09597606 | SaveButton | SCP0029_ProductionPlanLine_SMALL.cs:1902 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## SCP0029_ProductionPlanLine_SMALL.Set_FixButtonEnabled

진입점: cboPlanDate.SelectedIndexChanged / cboPlanType.SelectedIndexChanged / cboPlanSeq.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ae705b49 | cboPlanDate.SelectedIndexChanged 외 2 | SCP0029_ProductionPlanLine_SMALL.cs:2589 | if (!string.IsNullOrEmpty(strPlanDate) && !string.IsNullOrEmpty(strPlanType) && !string.IsNullOrEmpty(strPlanSeq) && nPlanDa…) | STATE | btnFix.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-c000bf26 | cboPlanDate.SelectedIndexChanged 외 2 | SCP0029_ProductionPlanLine_SMALL.cs:2590 | if (!string.IsNullOrEmpty(strPlanDate) && !string.IsNullOrEmpty(strPlanType) && !string.IsNullOrEmpty(strPlanSeq) && nPlanDa…) | STATE | btnUnfix.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-65e85892 | cboPlanDate.SelectedIndexChanged 외 2 | SCP0029_ProductionPlanLine_SMALL.cs:2593 | else of (!string.IsNullOrEmpty(strPlanDate) && !string.IsNullOrEmpty(strPlanType) && !string.IsNullOrEmpty(strPlanSeq) && nPlanDa…) | STATE | btnFix.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-dd0716c4 | cboPlanDate.SelectedIndexChanged 외 2 | SCP0029_ProductionPlanLine_SMALL.cs:2594 | else of (!string.IsNullOrEmpty(strPlanDate) && !string.IsNullOrEmpty(strPlanType) && !string.IsNullOrEmpty(strPlanSeq) && nPlanDa…) | STATE | btnUnfix.Enabled | false | 컨트롤 상태 Enabled |  |  |  |

## SCP0029_ProductionPlanLine_SMALL.Set_FixCellColor

진입점: this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName)) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try ▸ if (dsBinding.Tables.Count > 0)] / this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName)) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try ▸ if (dsBinding.Tables.Count > 0)] / FindButton [try ▸ if (dsBi…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-384eb484 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 5 | SCP0029_ProductionPlanLine_SMALL.cs:2374 | for (k < siMain.ActiveSheet.RowCount) ▸ if (dtFix.Rows.Count > 0 && spd_MEASURE== "PROD_PLAN_AMEND") | DATA_OP | dtFix.Select | ("FIX_KEY='" + spd_FIX_KEY + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-4268d0fe | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 5 | SCP0029_ProductionPlanLine_SMALL.cs:2384 | for (k < siMain.ActiveSheet.RowCount) ▸ if (dtFix.Rows.Count > 0 && spd_MEASURE== "PROD_PLAN_AMEND") ▸ foreach (DataRow dr in dataRows) | GRID_STYLE | siMain.SetBGColor2 | (k, nCol, k, nCol, Color.FromArgb(188,229,92)) | 그리드 표시 설정 |  |  |  |
| AC-b026cf20 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 5 | SCP0029_ProductionPlanLine_SMALL.cs:2387 | for (k < siMain.ActiveSheet.RowCount) ▸ if (dtFix.Rows.Count > 0 && spd_MEASURE== "PROD_PLAN_AMEND") ▸ foreach (DataRow dr in dataRows) ▸ if… | GRID_STYLE | siMain.SetBGColor2 | (k, nColWeek, k, nColWeek, Color.FromArgb(188, 229, 92)) | 그리드 표시 설정 |  |  |  |
| AC-0e1cf021 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 5 | SCP0029_ProductionPlanLine_SMALL.cs:2406 | for (k < siMain.ActiveSheet.RowCount) ▸ if (spd_MEASURE == "LINE_TOTAL_LOAD_AMEND" \|\| spd_MEASURE == "LINE_TOTAL_LOAD_ENGINE") ▸ for (nCol… | GRID_STYLE | siMain.SetFGColor2 | (k, nCol, k, nCol, ControlColor.MarkedForeColor) | 그리드 표시 설정 |  |  |  |
| AC-180e03c7 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 5 | SCP0029_ProductionPlanLine_SMALL.cs:2411 | for (k < siMain.ActiveSheet.RowCount) | UI_MISC | spdMain.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## SCP0029_ProductionPlanLine_SMALL.Set_FPOperationColor

진입점: this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName)) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try ▸ if (dsBinding.Tables.Count > 0)] / this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName)) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try ▸ if (dsBinding.Tables.Count > 0)] / FindButton [try ▸ if (dsBi…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8013a49b | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 5 | SCP0029_ProductionPlanLine_SMALL.cs:2257 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-19f03808 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 5 | SCP0029_ProductionPlanLine_SMALL.cs:2261 | if (fps.Name == "spdMain") ▸ if (siMain.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1ae4299b | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 5 | SCP0029_ProductionPlanLine_SMALL.cs:2262 | if (fps.Name == "spdMain") | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-191161c9 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 5 | SCP0029_ProductionPlanLine_SMALL.cs:2273 | if (fps.Name == "spdMain") ▸ for (i < spdMain.ActiveSheet.RowCount) ▸ if (spdMain.ActiveSheet.GetText(i, siMain.GetColumnIndex(DefColumns.ME… | DATA_OP | dtIsEditInfo.Select | ("CP_KEY = '" + strCP_KEY + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-75838b3c | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 5 | SCP0029_ProductionPlanLine_SMALL.cs:2305 | if (fps.Name == "spdMain") ▸ for (i < spdMain.ActiveSheet.RowCount) ▸ if (spdMain.ActiveSheet.GetText(i, siMain.GetColumnIndex(DefColumns.ME… | DATA_OP | dtPlanType.Select | ("CODE='FN'") | 데이터 객체 조작/조회 |  |  |  |
| AC-cad74931 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 5 | SCP0029_ProductionPlanLine_SMALL.cs:2351 | if (fps.Name == "spdMain") ▸ for (i < spdMain.ActiveSheet.RowCount) ▸ if (spdMain.ActiveSheet.GetText(i, siMain.GetColumnIndex(DefColumns.ME… | GRID_STYLE | siMain.SetBGColor2 | (nEditableRow, nStartEditIdx, nEditableRow, siMain.ActiveSheet.ColumnCount - 1, Color.From… | 그리드 표시 설정 |  |  |  |
| AC-72a04c4c | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 5 | SCP0029_ProductionPlanLine_SMALL.cs:2357 | if (fps.Name == "spdMain") | UI_MISC | spdMain.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## SCP0029_ProductionPlanLine_SMALL.SetChangedControl

진입점: this.Load / cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4905978c | this.Load 외 1 | SCP0029_ProductionPlanLine_SMALL.cs:1260 | if (division.Substring(0, 2).Equals("EE")) | FLAG | dtOperationGroup | Data_SCP.Common(Data_SCP.Type.OperationGroupEE, false) | 화면 필드/플래그 변경 |  |  |  |
| AC-880e457a | this.Load 외 1 | SCP0029_ProductionPlanLine_SMALL.cs:1260 | if (division.Substring(0, 2).Equals("EE")) | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.OperationGroupEE, false) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-f1a6f571 | this.Load 외 1 | SCP0029_ProductionPlanLine_SMALL.cs:1262 | else of (division.Substring(0, 2).Equals("EE")) | FLAG | dtOperationGroup | Data_SCP.Common(Data_SCP.Type.OperationGroup, false) | 화면 필드/플래그 변경 |  |  |  |
| AC-8447826c | this.Load 외 1 | SCP0029_ProductionPlanLine_SMALL.cs:1262 | else of (division.Substring(0, 2).Equals("EE")) | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.OperationGroup, false) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-d7b7b3ed | this.Load 외 1 | SCP0029_ProductionPlanLine_SMALL.cs:1263 |  | LIST_REBIND | clsCtrl.setListBox | (dtOperationGroup, cboOperationGroup, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-ea77eded | this.Load 외 1 | SCP0029_ProductionPlanLine_SMALL.cs:1269 | if (division.Substring(0, 2).Equals("EE")) | FLAG | dtPlantSiteByDivision | Data_SCP.Common(Data_SCP.Type.PlantSiteProdPlan, false, division, pOperationGroup) | 화면 필드/플래그 변경 |  |  |  |
| AC-9457dc41 | this.Load 외 1 | SCP0029_ProductionPlanLine_SMALL.cs:1269 | if (division.Substring(0, 2).Equals("EE")) | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.PlantSiteProdPlan, false, division, pOperationGroup) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-1583ccd3 | this.Load 외 1 | SCP0029_ProductionPlanLine_SMALL.cs:1271 | else of (division.Substring(0, 2).Equals("EE")) | FLAG | dtPlantSiteByDivision | Data.Common(Data.Type.PlantByDivisionOperation, false, division, pOperationGroup) ⇒ biz:CommonData.CommonDataList [code=PlantByDivisionOperation] | 화면 필드/플래그 변경 |  |  |  |
| AC-b15fd164 | this.Load 외 1 | SCP0029_ProductionPlanLine_SMALL.cs:1271 | else of (division.Substring(0, 2).Equals("EE")) | COMBO_DATA | Data.Common | (Data.Type.PlantByDivisionOperation, false, division, pOperationGroup) ⇒ biz:CommonData.CommonDataList [code=PlantByDivisionOperation] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-d084c861 | this.Load 외 1 | SCP0029_ProductionPlanLine_SMALL.cs:1275 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlantSiteByDivision, clbPlantSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-4038fb33 | this.Load 외 1 | SCP0029_ProductionPlanLine_SMALL.cs:1281 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | FLAG | dtPlanDate | Data.Common(Data.Type.PlanDate, false, division) ⇒ biz:CommonData.CommonDataList [code=PlanDate] | 화면 필드/플래그 변경 |  |  |  |
| AC-a7536f7a | this.Load 외 1 | SCP0029_ProductionPlanLine_SMALL.cs:1281 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | COMBO_DATA | Data.Common | (Data.Type.PlanDate, false, division) ⇒ biz:CommonData.CommonDataList [code=PlanDate] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-eb75e152 | this.Load 외 1 | SCP0029_ProductionPlanLine_SMALL.cs:1282 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | LIST_REBIND | clsCtrl.setListBox | (dtPlanDate, cboPlanDate, false, "CODE","NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-a95d5a32 | this.Load 외 1 | SCP0029_ProductionPlanLine_SMALL.cs:1286 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | FLAG | dtPlanType | Data.Common(Data.Type.PlanType, false, division, pPlanDate) ⇒ biz:CommonData.CommonDataList [code=PlanType] | 화면 필드/플래그 변경 |  |  |  |
| AC-e38c2ce4 | this.Load 외 1 | SCP0029_ProductionPlanLine_SMALL.cs:1286 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | COMBO_DATA | Data.Common | (Data.Type.PlanType, false, division, pPlanDate) ⇒ biz:CommonData.CommonDataList [code=PlanType] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-be676ed9 | this.Load 외 1 | SCP0029_ProductionPlanLine_SMALL.cs:1287 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | LIST_REBIND | clsCtrl.setListBox | (dtPlanType, cboPlanType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-a3a7bc6d | this.Load 외 1 | SCP0029_ProductionPlanLine_SMALL.cs:1288 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ if (dtPlanType.Rows.Count > 0) | VALUE_SET | cboPlanType.SelectedIndex | dtPlanType.Rows.Count - 1 | 컨트롤 값 설정 |  |  |  |
| AC-5d9c891d | this.Load 외 1 | SCP0029_ProductionPlanLine_SMALL.cs:1291 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | FLAG | dtPlanSeq | Data.Common(Data.Type.PlanSeq, false, division, pPlanDate, pPlanType) ⇒ biz:CommonData.CommonDataList [code=PlanSeq] | 화면 필드/플래그 변경 |  |  |  |
| AC-f514239d | this.Load 외 1 | SCP0029_ProductionPlanLine_SMALL.cs:1291 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | COMBO_DATA | Data.Common | (Data.Type.PlanSeq, false, division, pPlanDate, pPlanType) ⇒ biz:CommonData.CommonDataList [code=PlanSeq] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-7bdde5ab | this.Load 외 1 | SCP0029_ProductionPlanLine_SMALL.cs:1292 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | LIST_REBIND | clsCtrl.setListBox | (dtPlanSeq, cboPlanSeq, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-89f39588 | this.Load 외 1 | SCP0029_ProductionPlanLine_SMALL.cs:1298 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ if (division.Substring(0, 2).Equals("EE")) | FLAG | dtLine | Data_SCP.Common(Data_SCP.Type.LineProdPlanLine, false, division, pOperationGroup, pPlantSi… | 화면 필드/플래그 변경 |  |  |  |
| AC-3ec2b7e3 | this.Load 외 1 | SCP0029_ProductionPlanLine_SMALL.cs:1298 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ if (division.Substring(0, 2).Equals("EE")) | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.LineProdPlanLine, false, division, pOperationGroup, pPlantSite) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-662462f6 | this.Load 외 1 | SCP0029_ProductionPlanLine_SMALL.cs:1300 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ else of (division.Substring(0, 2).Equals("EE")) | FLAG | dtLine | Data.Common(Data.Type.LineByOperation, false, division, "", "", "", pPlantSite) ⇒ biz:CommonData.CommonDataList [code=LineByOperation] | 화면 필드/플래그 변경 |  |  |  |
| AC-67ec9931 | this.Load 외 1 | SCP0029_ProductionPlanLine_SMALL.cs:1300 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ else of (division.Substring(0, 2).Equals("EE")) | COMBO_DATA | Data.Common | (Data.Type.LineByOperation, false, division, "", "", "", pPlantSite) ⇒ biz:CommonData.CommonDataList [code=LineByOperation] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-17ac3b1b | this.Load 외 1 | SCP0029_ProductionPlanLine_SMALL.cs:1304 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | LIST_REBIND | clsCtrl.setListBox | (dtLine, clbLine, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-d6c9d788 | this.Load 외 1 | SCP0029_ProductionPlanLine_SMALL.cs:1309 | if (!division.Substring(0, 2).Equals("EE")) | VALUE_CLEAR | cboElectrode.ControlValues | "" | 컨트롤 값 비움 |  |  |  |
| AC-b355991a | this.Load 외 1 | SCP0029_ProductionPlanLine_SMALL.cs:1310 | if (!division.Substring(0, 2).Equals("EE")) | STATE | cboElectrode.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-9f9eefd4 | this.Load 외 1 | SCP0029_ProductionPlanLine_SMALL.cs:1314 | else of (!division.Substring(0, 2).Equals("EE")) | STATE | cboElectrode.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## SCP0029_ProductionPlanLine_SMALL.SetLockSumColumn

진입점: this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName)) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try ▸ if (dsBinding.Tables.Count > 0)] / this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName)) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try ▸ if (dsBinding.Tables.Count > 0)] / FindButton [try ▸ if (dsBi…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fc453395 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 5 | SCP0029_ProductionPlanLine_SMALL.cs:766 | for (iCol < spreadInfo.ActiveSheet.ColumnCount) ▸ if (spreadInfo.GetColumnTag(iCol).IndexOf("M_") == 0) ▸ if (spreadInfo.ActiveSheet.RowCoun… | GRID_LOCK | spreadInfo.LockRange | (0, iCol, spreadInfo.ActiveSheet.RowCount - 1, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |

## SCP0029_ProductionPlanLine_SMALL.SetSpreadColumn

진입점: this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName)) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try ▸ if (siMain.GetMaxRowIndex() > 0)] / this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName)) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try ▸ if (siMain.GetMaxRowIndex() > 0)] / this.Load [if (spdInfo.S…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-40bf483f | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 11 | SCP0029_ProductionPlanLine_SMALL.cs:814 | for (iCol < siObj.ActiveSheet.ColumnCount) ▸ if (cboBucketType.ControlValues == BucketType.Daily) ▸ if (siObj.GetColumnTag(iCol).IndexOf("D_… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-1e3082c5 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 11 | SCP0029_ProductionPlanLine_SMALL.cs:816 | for (iCol < siObj.ActiveSheet.ColumnCount) ▸ if (cboBucketType.ControlValues == BucketType.Daily) ▸ if (siObj.GetColumnTag(iCol).IndexOf("D_… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-1c71287d | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 11 | SCP0029_ProductionPlanLine_SMALL.cs:831 | for (iCol < siObj.ActiveSheet.ColumnCount) ▸ if (cboBucketType.ControlValues == BucketType.Daily) ▸ if (siObj.GetColumnTag(iCol).IndexOf("M_… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | viewYN | 그리드 속성/값 설정 |  |  |  |
| AC-e4f94194 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 11 | SCP0029_ProductionPlanLine_SMALL.cs:850 | for (iCol < siObj.ActiveSheet.ColumnCount) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == … | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-f8d5f6e8 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 11 | SCP0029_ProductionPlanLine_SMALL.cs:854 | for (iCol < siObj.ActiveSheet.ColumnCount) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == … | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-1eff833d | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 11 | SCP0029_ProductionPlanLine_SMALL.cs:859 | for (iCol < siObj.ActiveSheet.ColumnCount) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == … | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | chkSum.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-5ceb9009 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 11 | SCP0029_ProductionPlanLine_SMALL.cs:866 | for (iCol < siObj.ActiveSheet.ColumnCount) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ else of (cboBucketType.ControlValue… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-6a14a75f | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 11 | SCP0029_ProductionPlanLine_SMALL.cs:870 | for (iCol < siObj.ActiveSheet.ColumnCount) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ else of (cboBucketType.ControlValue… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |

## SCP0029_ProductionPlanLine_SMALL.SpdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-83e9b51f | this.spdMain.CellClick | SCP0029_ProductionPlanLine_SMALL.cs:455 | if (spdMain.ActiveSheet.ActiveRowIndex > 0) | FLAG | this.nSelRowOfMain | spdMain.ActiveSheet.ActiveRowIndex | 화면 필드/플래그 변경 |  |  |  |
| AC-e176140e | this.spdMain.CellClick | SCP0029_ProductionPlanLine_SMALL.cs:456 | if (spdMain.ActiveSheet.ActiveRowIndex > 0) | FLAG | this.nSelColOfMain | spdMain.ActiveSheet.ActiveColumnIndex | 화면 필드/플래그 변경 |  |  |  |

## SCP0029_ProductionPlanLine_SMALL.SpdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ed8610b9 | this.spdMain.CellDoubleClick | SCP0029_ProductionPlanLine_SMALL.cs:2607 | if (dtBucketSet!=null) | CALL_EXT | siMain.SetDblClickColumnShowHide_small | (sender, e, dtBucketSet) | ⚠ 의미 확인 필요 |  |  |  |
| AC-60e33e15 | this.spdMain.CellDoubleClick | SCP0029_ProductionPlanLine_SMALL.cs:2609 | else of (dtBucketSet!=null) | CALL_EXT | siMain.SetDblClickColumnShowHide | (sender, e) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a54a3f22 | this.spdMain.CellDoubleClick | SCP0029_ProductionPlanLine_SMALL.cs:2612 | if (!e.ColumnHeader && e.Row>=0) | FLAG | nSelRowOfMain | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-29b23b2b | this.spdMain.CellDoubleClick | SCP0029_ProductionPlanLine_SMALL.cs:2613 | if (!e.ColumnHeader && e.Row>=0) | FLAG | nSelColOfMain | e.Column | 화면 필드/플래그 변경 |  |  |  |

## SCP0029_ProductionPlanLine_SMALL.SpdMain_Changed

진입점: dsdmLine.Changed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-134af251 | dsdmLine.Changed | SCP0029_ProductionPlanLine_SMALL.cs:2425 | if (!this.CanModelChange \|\| e.Row == -1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-104b3780 | dsdmLine.Changed | SCP0029_ProductionPlanLine_SMALL.cs:2434 | if (ds == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5fd43e93 | dsdmLine.Changed | SCP0029_ProductionPlanLine_SMALL.cs:2443 | if (strColName == "Action") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c3311e2e | dsdmLine.Changed | SCP0029_ProductionPlanLine_SMALL.cs:2449 | try ▸ if (ds == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-fd5e8074 | dsdmLine.Changed | SCP0029_ProductionPlanLine_SMALL.cs:2469 | catch ((Exception et)) | THROW | throw et; |  | 예외 발생 |  |  |  |
| AC-e8ddfd2b | dsdmLine.Changed | SCP0029_ProductionPlanLine_SMALL.cs:2473 | finally | DATA_OP | dt.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |

## SCP0029_ProductionPlanLine_SMALL.SpdMain_TopChange

진입점: this.spdMain.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-45e708bf | this.spdMain.TopChange | SCP0029_ProductionPlanLine_SMALL.cs:463 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

