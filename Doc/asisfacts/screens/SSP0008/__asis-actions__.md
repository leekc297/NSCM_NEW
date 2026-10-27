# AS-IS 액션 대조표 — SSP0008

> 원천: `Doc/asisfacts/screens/SSP0008/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 399행 · 메서드 40 · 종류 DATA_OP 129 · RETURN 34 · FLAG 27 · MESSAGE 24 · GRID_INIT 21 · ENDPOINT 20 · GRID_SET 18 · UI_PROP 17 · COMBO_DATA 16 · LIST_REBIND 15 · UI_MISC 14 · VALUE_SET 12 · POPUP 11 · CALL_EXT 10 · GRID_STYLE 9 · STATE 6 · GRID_LOCK 5 · GRID_CLEAR 4 · VALIDATE 3 · STATE_RESET 1 · GRID_BIND 1 · VALUE_CLEAR 1 · THROW 1 · ⚠ 의미 확인 필요 10


## SSP0008_ProductionPlanLine.btnFix_Click

진입점: this.btnFix.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c2edd670 | this.btnFix.Click | SSP0008_ProductionPlanLine.cs:661 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-4626c32b | this.btnFix.Click | SSP0008_ProductionPlanLine.cs:662 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3eb54f31 | this.btnFix.Click | SSP0008_ProductionPlanLine.cs:668 | if (siMain.IsLock(siMain.SheetName)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00010") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SSP0008_ProductionPlanLine.btnItemId_Click

진입점: this.btnItemId.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0ac2aa91 | this.btnItemId.Click | SSP0008_ProductionPlanLine.cs:639 |  | POPUP | new SCM0002_ItembyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-c29ff99d | this.btnItemId.Click | SSP0008_ProductionPlanLine.cs:641 |  | POPUP | popItem.Form_Load | (true, sdivision, sScmSite, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-3f60b305 | this.btnItemId.Click | SSP0008_ProductionPlanLine.cs:642 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-f91c382e | this.btnItemId.Click | SSP0008_ProductionPlanLine.cs:643 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-deaa7b08 | this.btnItemId.Click | SSP0008_ProductionPlanLine.cs:649 | if (popItem.ItemID != "") | VALUE_SET | txtItemId.Text | sItemId | 컨트롤 값 설정 |  |  |  |

## SSP0008_ProductionPlanLine.BtnMeasure_Click

진입점: this.btnMeasure.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a09172b4 | this.btnMeasure.Click | SSP0008_ProductionPlanLine.cs:721 | if (fps != null) ▸ else of (fps.Name == "spdMain") | MESSAGE | MessageHelper.GMessageBox | ("MSG00007", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-795113e1 | this.btnMeasure.Click | SSP0008_ProductionPlanLine.cs:722 | if (fps != null) ▸ else of (fps.Name == "spdMain") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-27e57564 | this.btnMeasure.Click | SSP0008_ProductionPlanLine.cs:727 | else of (fps != null) | MESSAGE | MessageHelper.GMessageBox | ("MSG00007", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-22fcfe77 | this.btnMeasure.Click | SSP0008_ProductionPlanLine.cs:728 | else of (fps != null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8125287f | this.btnMeasure.Click | SSP0008_ProductionPlanLine.cs:731 |  | POPUP | new SCM0002_TitleSetForm_Popup | ("SSP0008", shtName, false) | 팝업/폼 생성 |  |  |  |
| AC-e26ff0a6 | this.btnMeasure.Click | SSP0008_ProductionPlanLine.cs:732 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-a4683b2b | this.btnMeasure.Click | SSP0008_ProductionPlanLine.cs:733 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-2ca4926f | this.btnMeasure.Click | SSP0008_ProductionPlanLine.cs:737 | if (frm.DialogResult == DialogResult.OK) | UI_PROP | this.CanModelChange | false | 속성 CanModelChange 설정 |  |  |  |
| AC-0a7f367f | this.btnMeasure.Click | SSP0008_ProductionPlanLine.cs:742 | if (frm.DialogResult == DialogResult.OK) | UI_PROP | this.CanModelChange | true | 속성 CanModelChange 설정 |  |  |  |

## SSP0008_ProductionPlanLine.btnUnfix_Click

진입점: this.btnUnfix.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dd811afa | this.btnUnfix.Click | SSP0008_ProductionPlanLine.cs:685 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-38aaeb5a | this.btnUnfix.Click | SSP0008_ProductionPlanLine.cs:686 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e2a602de | this.btnUnfix.Click | SSP0008_ProductionPlanLine.cs:692 | if (siMain.IsLock(siMain.SheetName)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00010") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SSP0008_ProductionPlanLine.CalculateDailyQty

진입점: dsdmLine.Changed [try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strColName.IndexOf("W_") == 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3e875d65 | dsdmLine.Changed [try ▸ switch (e.Type) case FarPoint.Win.Sp… | SSP0008_ProductionPlanLine.cs:1126 | if (nWeek < 0) | GRID_SET | siMain.SetValue | (nRow, nCol, nDaySum) | 그리드 값 설정 |  |  |  |
| AC-c19326db | dsdmLine.Changed [try ▸ switch (e.Type) case FarPoint.Win.Sp… | SSP0008_ProductionPlanLine.cs:1129 | if (nWeek < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7afcfcbc | dsdmLine.Changed [try ▸ switch (e.Type) case FarPoint.Win.Sp… | SSP0008_ProductionPlanLine.cs:1154 | for (j < (nCol + 1 + nDayCnt)) ▸ if (j != (nCol + nDayCnt)) | GRID_SET | siMain.SetValue | (nRow, j, nDivDay) | 그리드 값 설정 |  |  |  |
| AC-7ef8f51e | dsdmLine.Changed [try ▸ switch (e.Type) case FarPoint.Win.Sp… | SSP0008_ProductionPlanLine.cs:1158 | for (j < (nCol + 1 + nDayCnt)) ▸ else of (j != (nCol + nDayCnt)) | GRID_SET | siMain.SetValue | (nRow, j, (nDivDay + nDivDayMod).ToString()) | 그리드 값 설정 |  |  |  |
| AC-53fdd991 | dsdmLine.Changed [try ▸ switch (e.Type) case FarPoint.Win.Sp… | SSP0008_ProductionPlanLine.cs:1160 | for (j < (nCol + 1 + nDayCnt)) | GRID_STYLE | siMain.SetFGColor | (nRow, j, nRow, j, ControlColor.MarkedForeColor) | 그리드 표시 설정 |  |  |  |
| AC-241d761f | dsdmLine.Changed [try ▸ switch (e.Type) case FarPoint.Win.Sp… | SSP0008_ProductionPlanLine.cs:1170 | if (ds == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SSP0008_ProductionPlanLine.CalculateSum

진입점: this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName)) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try] / this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName)) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try] / dsdmLine.Changed [try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a08fb9f7 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SSP0008_ProductionPlanLine.cs:869 | for (nCol < dt.Columns.Count) ▸ if (dt.Columns[nCol].ColumnName.IndexOf("M_") == 0) | DATA_OP | listMonth.Add | (nCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-011fe8ef | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SSP0008_ProductionPlanLine.cs:873 | for (nCol < dt.Columns.Count) ▸ if (dt.Columns[nCol].ColumnName.IndexOf("W_") == 0) | DATA_OP | listWeek.Add | (nCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-a5dd2d37 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SSP0008_ProductionPlanLine.cs:918 | for (nCol < dt.Columns.Count) ▸ if (nCol == dt.Columns.Count - 1 \|\| dt.Columns[nCol].ColumnName.IndexOf("W_") == 0) ▸ if (strMeasure == "F… | DATA_OP | dr[nIdxWeek] | weekSum / nCntDayOfWeek | 행/컬럼 값 대입 |  |  |  |
| AC-3290a396 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SSP0008_ProductionPlanLine.cs:922 | for (nCol < dt.Columns.Count) ▸ if (nCol == dt.Columns.Count - 1 \|\| dt.Columns[nCol].ColumnName.IndexOf("W_") == 0) ▸ else of (strMeasure … | DATA_OP | dr[nIdxWeek] | weekSum | 행/컬럼 값 대입 |  |  |  |
| AC-bb912693 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SSP0008_ProductionPlanLine.cs:936 | for (nCol < dt.Columns.Count) ▸ if (nCol == dt.Columns.Count - 1 \|\| dt.Columns[nCol].ColumnName.IndexOf("M_") == 0) ▸ if (strMeasure == "F… | DATA_OP | dr[nIdxMonth] | monthSum / nCntDayOfMonth | 행/컬럼 값 대입 |  |  |  |
| AC-5c4b96a2 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SSP0008_ProductionPlanLine.cs:940 | for (nCol < dt.Columns.Count) ▸ if (nCol == dt.Columns.Count - 1 \|\| dt.Columns[nCol].ColumnName.IndexOf("M_") == 0) ▸ else of (strMeasure … | DATA_OP | dr[nIdxMonth] | monthSum | 행/컬럼 값 대입 |  |  |  |
| AC-965f973f | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SSP0008_ProductionPlanLine.cs:949 |  | DATA_OP | dt.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-122981db | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SSP0008_ProductionPlanLine.cs:971 | for (nCol < dt.Columns.Count) ▸ if (dt.Columns[nCol].ColumnName.IndexOf("M_") == 0) | DATA_OP | listMonth.Add | (nCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-bbfeb77e | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SSP0008_ProductionPlanLine.cs:975 | for (nCol < dt.Columns.Count) ▸ if (dt.Columns[nCol].ColumnName.IndexOf("W_") == 0) | DATA_OP | listWeek.Add | (nCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-b97d401d | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SSP0008_ProductionPlanLine.cs:1036 | for (nRow < dt.Rows.Count) ▸ for (nCol < dt.Columns.Count) ▸ if (nCol == dt.Columns.Count - 1 \|\| dt.Columns[nCol].ColumnName.IndexOf("W_")… | DATA_OP | dr[nIdxWeek] | weekSum / nCntDayOfWeek | 행/컬럼 값 대입 |  |  |  |
| AC-679029b9 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SSP0008_ProductionPlanLine.cs:1040 | for (nRow < dt.Rows.Count) ▸ for (nCol < dt.Columns.Count) ▸ if (nCol == dt.Columns.Count - 1 \|\| dt.Columns[nCol].ColumnName.IndexOf("W_")… | DATA_OP | dr[nIdxWeek] | weekSum | 행/컬럼 값 대입 |  |  |  |
| AC-2fb10a2f | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SSP0008_ProductionPlanLine.cs:1058 | for (nRow < dt.Rows.Count) ▸ for (nCol < dt.Columns.Count) ▸ if (nCol == dt.Columns.Count - 1 \|\| dt.Columns[nCol].ColumnName.IndexOf("M_")… | DATA_OP | dr[nIdxMonth] | monthSum / nCntDayOfMonth | 행/컬럼 값 대입 |  |  |  |
| AC-d9f5de88 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SSP0008_ProductionPlanLine.cs:1062 | for (nRow < dt.Rows.Count) ▸ for (nCol < dt.Columns.Count) ▸ if (nCol == dt.Columns.Count - 1 \|\| dt.Columns[nCol].ColumnName.IndexOf("M_")… | DATA_OP | dr[nIdxMonth] | monthSum | 행/컬럼 값 대입 |  |  |  |
| AC-2d44682a | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 4 | SSP0008_ProductionPlanLine.cs:1071 |  | DATA_OP | dt.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |

## SSP0008_ProductionPlanLine.CboOperationGroup_SelectedIndexChanged

진입점: cboOperationGroup.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-87a7b8e0 | cboOperationGroup.SelectedIndexChanged | SSP0008_ProductionPlanLine.cs:2427 | if (pDivisionID != "EE") | FLAG | dtPlantSiteByDivision | Data.Common(Data.Type.PlantByDivisionOperation, false, pDivisionID, pOperationGroup) ⇒ biz:CommonData.CommonDataList [code=PlantByDivisionOperation] | 화면 필드/플래그 변경 |  |  |  |
| AC-de060386 | cboOperationGroup.SelectedIndexChanged | SSP0008_ProductionPlanLine.cs:2427 | if (pDivisionID != "EE") | COMBO_DATA | Data.Common | (Data.Type.PlantByDivisionOperation, false, pDivisionID, pOperationGroup) ⇒ biz:CommonData.CommonDataList [code=PlantByDivisionOperation] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-913db36e | cboOperationGroup.SelectedIndexChanged | SSP0008_ProductionPlanLine.cs:2429 | else of (pDivisionID != "EE") | FLAG | dtPlantSiteByDivision | Data_SCP.Common(Data_SCP.Type.PlantSiteProdPlanSSP, false, pDivisionID, pOperationGroup) | 화면 필드/플래그 변경 |  |  |  |
| AC-8b4013bf | cboOperationGroup.SelectedIndexChanged | SSP0008_ProductionPlanLine.cs:2429 | else of (pDivisionID != "EE") | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.PlantSiteProdPlanSSP, false, pDivisionID, pOperationGroup) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-06aeac03 | cboOperationGroup.SelectedIndexChanged | SSP0008_ProductionPlanLine.cs:2431 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlantSiteByDivision, clbPlantSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-95573512 | cboOperationGroup.SelectedIndexChanged | SSP0008_ProductionPlanLine.cs:2436 | if (pDivisionID != "EE") | FLAG | dtLine | Data.Common(Data.Type.LineByOperation, false, pDivisionID, "", "", "", pPlantSite) ⇒ biz:CommonData.CommonDataList [code=LineByOperation] | 화면 필드/플래그 변경 |  |  |  |
| AC-d25e788a | cboOperationGroup.SelectedIndexChanged | SSP0008_ProductionPlanLine.cs:2436 | if (pDivisionID != "EE") | COMBO_DATA | Data.Common | (Data.Type.LineByOperation, false, pDivisionID, "", "", "", pPlantSite) ⇒ biz:CommonData.CommonDataList [code=LineByOperation] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-1c974e8a | cboOperationGroup.SelectedIndexChanged | SSP0008_ProductionPlanLine.cs:2438 | else of (pDivisionID != "EE") | FLAG | dtLine | Data_SCP.Common(Data_SCP.Type.LineProdPlanLineSSP, false, pDivisionID, pOperationGroup, pP… | 화면 필드/플래그 변경 |  |  |  |
| AC-f1e21eb9 | cboOperationGroup.SelectedIndexChanged | SSP0008_ProductionPlanLine.cs:2438 | else of (pDivisionID != "EE") | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.LineProdPlanLineSSP, false, pDivisionID, pOperationGroup, pPlantSite) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-357db7f6 | cboOperationGroup.SelectedIndexChanged | SSP0008_ProductionPlanLine.cs:2439 |  | LIST_REBIND | clsCtrl.setListBox | (dtLine, clbLine, true) | 목록 컨트롤 재구성 |  |  |  |

## SSP0008_ProductionPlanLine.CboPlanDate_SelectedIndexChanged

진입점: cboPlanDate.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-76832794 | cboPlanDate.SelectedIndexChanged | SSP0008_ProductionPlanLine.cs:2448 |  | FLAG | dtPlanType | Data.Common(Data.Type.PlanTypeShip, false, pDivisionID, pPlanDate) ⇒ biz:CommonData.CommonDataList [code=PlanTypeShip] | 화면 필드/플래그 변경 |  |  |  |
| AC-9fd62c2a | cboPlanDate.SelectedIndexChanged | SSP0008_ProductionPlanLine.cs:2448 |  | COMBO_DATA | Data.Common | (Data.Type.PlanTypeShip, false, pDivisionID, pPlanDate) ⇒ biz:CommonData.CommonDataList [code=PlanTypeShip] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-e26c2e86 | cboPlanDate.SelectedIndexChanged | SSP0008_ProductionPlanLine.cs:2449 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanType, cboPlanType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-50beefa1 | cboPlanDate.SelectedIndexChanged | SSP0008_ProductionPlanLine.cs:2450 |  | VALUE_SET | cboPlanType.SelectedIndex | dtPlanType.Rows.Count - 1 | 컨트롤 값 설정 |  |  |  |
| AC-852a5fbf | cboPlanDate.SelectedIndexChanged | SSP0008_ProductionPlanLine.cs:2453 |  | VALUE_SET | drpPeriod.InitValue | GetDayRange() | 컨트롤 값 설정 |  |  |  |
| AC-eb243380 | cboPlanDate.SelectedIndexChanged | SSP0008_ProductionPlanLine.cs:2458 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |

## SSP0008_ProductionPlanLine.CboPlanSeq_SelectedIndexChanged

진입점: cboPlanSeq.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-deab1b46 | cboPlanSeq.SelectedIndexChanged | SSP0008_ProductionPlanLine.cs:2480 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |

## SSP0008_ProductionPlanLine.CboPlanType_SelectedIndexChanged

진입점: cboPlanType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6cd67c1d | cboPlanType.SelectedIndexChanged | SSP0008_ProductionPlanLine.cs:2468 |  | FLAG | dtPlanSeq | Data.Common(Data.Type.PlanSeqShip, false, pDivisionID, pPlanDate, pPlanType) ⇒ biz:CommonData.CommonDataList [code=PlanSeqShip] | 화면 필드/플래그 변경 |  |  |  |
| AC-cdd9a01f | cboPlanType.SelectedIndexChanged | SSP0008_ProductionPlanLine.cs:2468 |  | COMBO_DATA | Data.Common | (Data.Type.PlanSeqShip, false, pDivisionID, pPlanDate, pPlanType) ⇒ biz:CommonData.CommonDataList [code=PlanSeqShip] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ea466bd5 | cboPlanType.SelectedIndexChanged | SSP0008_ProductionPlanLine.cs:2469 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanSeq, cboPlanSeq, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-e6bb79b3 | cboPlanType.SelectedIndexChanged | SSP0008_ProductionPlanLine.cs:2470 |  | VALUE_SET | cboPlanSeq.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-01bace6b | cboPlanType.SelectedIndexChanged | SSP0008_ProductionPlanLine.cs:2473 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |

## SSP0008_ProductionPlanLine.ClbPlantSite_SelectedIndexChanged

진입점: clbPlantSite.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4d10c858 | clbPlantSite.SelectedIndexChanged | SSP0008_ProductionPlanLine.cs:2417 |  | FLAG | dtLine | Data_SCP.Common(Data_SCP.Type.LineProdPlanLineSSP, false, pDivisionID, pOperationGroup, pP… | 화면 필드/플래그 변경 |  |  |  |
| AC-1efb0f6d | clbPlantSite.SelectedIndexChanged | SSP0008_ProductionPlanLine.cs:2417 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.LineProdPlanLineSSP, false, pDivisionID, pOperationGroup, pPlantSiteID) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-b8415f09 | clbPlantSite.SelectedIndexChanged | SSP0008_ProductionPlanLine.cs:2418 |  | LIST_REBIND | clsCtrl.setListBox | (dtLine, clbLine, true) | 목록 컨트롤 재구성 |  |  |  |

## SSP0008_ProductionPlanLine.ClearUsrCheckedList

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-59f66fb5 | (진입점 미연결) | SSP0008_ProductionPlanLine.cs:196 | if (dt != null) | STATE_RESET | dt.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-7e4c8978 | (진입점 미연결) | SSP0008_ProductionPlanLine.cs:197 | if (dt != null) | LIST_REBIND | clsCtrl.setListBox | (dt, control, true) | 목록 컨트롤 재구성 |  |  |  |

## SSP0008_ProductionPlanLine.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bc5018f1 | this.Load | SSP0008_ProductionPlanLine.cs:240 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 3, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-4b850621 | this.Load | SSP0008_ProductionPlanLine.cs:241 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, 0) | 화면 필드/플래그 변경 |  |  |  |
| AC-2a9331a0 | this.Load | SSP0008_ProductionPlanLine.cs:244 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SSP0008_ProductionPlanLine.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c0f1737c | this.Load | SSP0008_ProductionPlanLine.cs:185 |  | UI_PROP | usrConditionPanel1.Height | 105 | 속성 Height 설정 |  |  |  |
| AC-1db9fec9 | this.Load | SSP0008_ProductionPlanLine.cs:186 |  | VALUE_SET | cboBucketType.ControlValues | BucketType.Weekly | 컨트롤 값 설정 |  |  |  |
| AC-58dcb050 | this.Load | SSP0008_ProductionPlanLine.cs:187 |  | VALUE_SET | chkSum.Checked | false | 컨트롤 값 설정 |  |  |  |

## SSP0008_ProductionPlanLine.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3e319528 | Dispose | SSP0008_ProductionPlanLine.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SSP0008_ProductionPlanLine.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3cbf7df6 | EditButton | SSP0008_ProductionPlanLine.cs:484 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3478f3c7 | EditButton | SSP0008_ProductionPlanLine.cs:487 | if (fps.Name == "spdMain") | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-de6281d2 | EditButton | SSP0008_ProductionPlanLine.cs:488 | if (fps.Name == "spdMain") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8ff74d43 | EditButton | SSP0008_ProductionPlanLine.cs:493 | if (fps.Name == "spdMain") ▸ if (siMain.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0674b60b | EditButton | SSP0008_ProductionPlanLine.cs:494 | if (fps.Name == "spdMain") | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-26ce20f4 | EditButton | SSP0008_ProductionPlanLine.cs:495 | if (fps.Name == "spdMain") | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-38d6d48e | EditButton | SSP0008_ProductionPlanLine.cs:499 | if (fps.Name == "spdMain") | CALL_EXT | fps.ActiveSheet.GetColumnFromTag | (null, CAppSetting.StringAction) | ⚠ 의미 확인 필요 |  |  |  |
| AC-02c6fd53 | EditButton | SSP0008_ProductionPlanLine.cs:500 | if (fps.Name == "spdMain") | CALL_EXT | fps.ActiveSheet.Columns.Get | (xCol1) | ⚠ 의미 확인 필요 |  |  |  |
| AC-33d201d8 | EditButton | SSP0008_ProductionPlanLine.cs:505 | if (fps.Name == "spdMain") | GRID_LOCK | siMain.LockRange | (0, 0, siMain.ActiveSheet.RowCount - 1, siMain.ActiveSheet.ColumnCount - 1, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-83797973 | EditButton | SSP0008_ProductionPlanLine.cs:510 | if (fps.Name == "spdMain") | CALL_EXT | fps.ActiveSheet.Columns.Get | (xCol1) | ⚠ 의미 확인 필요 |  |  |  |
| AC-eb5ef234 | EditButton | SSP0008_ProductionPlanLine.cs:515 | if (fps.Name == "spdMain") ▸ if (fps.ActiveSheet.Columns.Get(xCol1).Visible == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-05e5fba7 | EditButton | SSP0008_ProductionPlanLine.cs:526 | if (fps.Name == "spdMain") ▸ for (i < spdMain.ActiveSheet.RowCount) ▸ if (spdMain.ActiveSheet.GetText(i, siMain.GetColumnIndex(DefColumns.ME… | DATA_OP | dtIsEditInfo.Select | ("CP_KEY = '" + strCP_KEY + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-28ca82ab | EditButton | SSP0008_ProductionPlanLine.cs:558 | if (fps.Name == "spdMain") ▸ for (i < spdMain.ActiveSheet.RowCount) ▸ if (spdMain.ActiveSheet.GetText(i, siMain.GetColumnIndex(DefColumns.ME… | DATA_OP | dtPlanType.Select | ("CODE='FN'") | 데이터 객체 조작/조회 |  |  |  |
| AC-8736c377 | EditButton | SSP0008_ProductionPlanLine.cs:596 | if (fps.Name == "spdMain") ▸ for (i < spdMain.ActiveSheet.RowCount) ▸ if (spdMain.ActiveSheet.GetText(i, siMain.GetColumnIndex(DefColumns.ME… | GRID_LOCK | siMain.LockRange | (nEditableRow, nStartEditIdx, nEditableRow, siMain.ActiveSheet.ColumnCount - 1, false) | 그리드 편집 잠금/해제 |  |  |  |

## SSP0008_ProductionPlanLine.FindData_Main

진입점: this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName)) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.Tables[0].Rows[0][0].ToString() == "S")] / this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName)) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.Tables[0].Rows[0][0].ToString() == "S")] / FindButton / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1edf62b0 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 3 | SSP0008_ProductionPlanLine.cs:1324 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-8903aefc | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 3 | SSP0008_ProductionPlanLine.cs:1332 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-19d38c5a | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 3 | SSP0008_ProductionPlanLine.cs:1332 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-585e0b8e | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 3 | SSP0008_ProductionPlanLine.cs:1333 | try | VALIDATE | DateUtil.Check_PeriodDate | (drpPeriod) | 프레임워크 검증 |  |  |  |
| AC-2a4851a9 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 3 | SSP0008_ProductionPlanLine.cs:1333 | try ▸ if (!DateUtil.Check_PeriodDate(drpPeriod)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-74188db4 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 3 | SSP0008_ProductionPlanLine.cs:1337 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-9ec76f8d | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 3 | SSP0008_ProductionPlanLine.cs:1370 | try | UI_PROP | proxyPivot.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-d93bbe5d | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 3 | SSP0008_ProductionPlanLine.cs:1372 | try | ENDPOINT | proxyPivot.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, GSCM_SSP_PLAN_S… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-cf0f3b54 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 3 | SSP0008_ProductionPlanLine.cs:1375 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SSP.SSP0008_GET_PRODUCTION_PLAN_LINEBY") ⇒ SSP.SSP0008_GET_PRODUCTION_PLAN_LINEBY | 엔드포인트 요청 생성 |  |  |  |
| AC-f2c0c831 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 3 | SSP0008_ProductionPlanLine.cs:1376 | try ▸ lambda | UI_PROP | req.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-f384085f | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 3 | SSP0008_ProductionPlanLine.cs:1377 | try ▸ lambda | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-01e72d6e | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 3 | SSP0008_ProductionPlanLine.cs:1378 | try ▸ lambda | DATA_OP | req.Parameters["p_operation_group"] | p_operation_group | 행/컬럼 값 대입 |  |  |  |
| AC-14ce9f03 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 3 | SSP0008_ProductionPlanLine.cs:1379 | try ▸ lambda | DATA_OP | req.Parameters["p_scm_site_id"] | p_scm_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-c710ece1 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 3 | SSP0008_ProductionPlanLine.cs:1380 | try ▸ lambda | DATA_OP | req.Parameters["p_line_id"] | p_line_id | 행/컬럼 값 대입 |  |  |  |
| AC-6044cdf6 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 3 | SSP0008_ProductionPlanLine.cs:1381 | try ▸ lambda | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-839a74de | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 3 | SSP0008_ProductionPlanLine.cs:1382 | try ▸ lambda | DATA_OP | req.Parameters["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-bff8d037 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 3 | SSP0008_ProductionPlanLine.cs:1383 | try ▸ lambda | DATA_OP | req.Parameters["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-2c55dfe4 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 3 | SSP0008_ProductionPlanLine.cs:1384 | try ▸ lambda | DATA_OP | req.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-b9b71ab3 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 3 | SSP0008_ProductionPlanLine.cs:1385 | try ▸ lambda | DATA_OP | req.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-17b52faf | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 3 | SSP0008_ProductionPlanLine.cs:1386 | try ▸ lambda | DATA_OP | req.Parameters["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-4dd14aec | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 3 | SSP0008_ProductionPlanLine.cs:1387 | try ▸ lambda | DATA_OP | req.Parameters["p_electrode_type"] | p_electrode_type | 행/컬럼 값 대입 |  |  |  |
| AC-a0d496ef | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 3 | SSP0008_ProductionPlanLine.cs:1388 | try ▸ lambda | DATA_OP | req.Parameters["p_program_id"] | p_program_id | 행/컬럼 값 대입 |  |  |  |
| AC-49dfb903 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 3 | SSP0008_ProductionPlanLine.cs:1389 | try ▸ lambda | DATA_OP | req.Parameters["p_sheet_name"] | p_sheet_name | 행/컬럼 값 대입 |  |  |  |
| AC-9a49b52d | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 3 | SSP0008_ProductionPlanLine.cs:1390 | try ▸ lambda | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-cad9f5ed | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 3 | SSP0008_ProductionPlanLine.cs:1391 | try ▸ lambda | DATA_OP | req.Parameters["p_nick_name"] | p_nick_name | 행/컬럼 값 대입 |  |  |  |
| AC-ec6cca0f | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 3 | SSP0008_ProductionPlanLine.cs:1392 | try ▸ lambda | DATA_OP | req.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-963f6397 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 3 | SSP0008_ProductionPlanLine.cs:1393 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-f225edff | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 3 | SSP0008_ProductionPlanLine.cs:1394 | try ▸ lambda | RETURN | return res.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-4555fd38 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 3 | SSP0008_ProductionPlanLine.cs:1401 | try | GRID_BIND | siMain.Query | (dsBinding) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-fea925c4 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 3 | SSP0008_ProductionPlanLine.cs:1403 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-bfa88169 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 3 | SSP0008_ProductionPlanLine.cs:1404 | try | UI_MISC | SetSearchCount | (dsBinding) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-43cddda0 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 3 | SSP0008_ProductionPlanLine.cs:1405 | try | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-989b3075 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 3 | SSP0008_ProductionPlanLine.cs:1407 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-312e808d | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 3 | SSP0008_ProductionPlanLine.cs:1440 | try ▸ if (this.nSelRowOfMain >= 0 && isReload) | GRID_STYLE | siMain.ActiveSheet.SetActiveCell | (this.nSelRowOfMain, this.nSelColOfMain) | 그리드 표시 설정 |  |  |  |
| AC-202a779a | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 3 | SSP0008_ProductionPlanLine.cs:1441 | try ▸ if (this.nSelRowOfMain >= 0 && isReload) | CALL_EXT | spdMain.ShowCell | (0, 0, this.nSelRowOfMain, this.nSelColOfMain, FarPoint.Win.Spread.VerticalPosition.Center… | ⚠ 의미 확인 필요 |  |  |  |
| AC-05c2ae60 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 3 | SSP0008_ProductionPlanLine.cs:1448 | catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-2c5eb66a | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 3 | SSP0008_ProductionPlanLine.cs:1450 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-2cae96de | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 3 | SSP0008_ProductionPlanLine.cs:1456 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SSP0008_ProductionPlanLine.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f4e737e0 | this.Load | SSP0008_ProductionPlanLine.cs:167 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SSP0008_ProductionPlanLine.Get_IsEditInfo

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b071826d | FindButton | SSP0008_ProductionPlanLine.cs:2132 | if (sDivision == null \|\| sDivision == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-66c9a9e2 | FindButton | SSP0008_ProductionPlanLine.cs:2161 |  | UI_PROP | proxyPivot.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-ab121fde | FindButton | SSP0008_ProductionPlanLine.cs:2162 |  | ENDPOINT | proxyPivot.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, GSCM_SSP_PLAN_S… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-572ea6ba | FindButton | SSP0008_ProductionPlanLine.cs:2165 | lambda | ENDPOINT | new FoxDataRequest | ("SSP.SSP0008_GET_PLAN_EDIT_INFO") ⇒ SSP.SSP0008_GET_PLAN_EDIT_INFO | 엔드포인트 요청 생성 |  |  |  |
| AC-637f9eb8 | FindButton | SSP0008_ProductionPlanLine.cs:2166 | lambda | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-ba3621b7 | FindButton | SSP0008_ProductionPlanLine.cs:2167 | lambda | DATA_OP | req.Parameters["p_operation_group"] | p_operation_group | 행/컬럼 값 대입 |  |  |  |
| AC-66eff4f4 | FindButton | SSP0008_ProductionPlanLine.cs:2168 | lambda | DATA_OP | req.Parameters["p_scm_site_id"] | p_scm_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-5ecef87d | FindButton | SSP0008_ProductionPlanLine.cs:2169 | lambda | DATA_OP | req.Parameters["p_line_id"] | p_line_id | 행/컬럼 값 대입 |  |  |  |
| AC-00b3ce18 | FindButton | SSP0008_ProductionPlanLine.cs:2170 | lambda | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-8bf9f3ff | FindButton | SSP0008_ProductionPlanLine.cs:2171 | lambda | DATA_OP | req.Parameters["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-054369db | FindButton | SSP0008_ProductionPlanLine.cs:2172 | lambda | DATA_OP | req.Parameters["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-dee31345 | FindButton | SSP0008_ProductionPlanLine.cs:2173 | lambda | DATA_OP | req.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-c258b829 | FindButton | SSP0008_ProductionPlanLine.cs:2174 | lambda | DATA_OP | req.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-af086613 | FindButton | SSP0008_ProductionPlanLine.cs:2175 | lambda | DATA_OP | req.Parameters["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-a89e765f | FindButton | SSP0008_ProductionPlanLine.cs:2176 | lambda | DATA_OP | req.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-d5e7ef17 | FindButton | SSP0008_ProductionPlanLine.cs:2177 | lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a4c3e088 | FindButton | SSP0008_ProductionPlanLine.cs:2178 | lambda | RETURN | return res.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-9e6beda0 | FindButton | SSP0008_ProductionPlanLine.cs:2184 | if (dsBinding.Tables.Count > 0) | FLAG | dtIsEditInfo | dsBinding.Tables[0] | 화면 필드/플래그 변경 |  |  |  |

## SSP0008_ProductionPlanLine.GetBucketType

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c23d5e1f | this.Load | SSP0008_ProductionPlanLine.cs:1182 |  | ENDPOINT | new FoxDataRequest | ("DM.DM0003_GET_BUCKET_TYPE_CODE") ⇒ DM.DM0003_GET_BUCKET_TYPE_CODE | 엔드포인트 요청 생성 |  |  |  |
| AC-07c401fc | this.Load | SSP0008_ProductionPlanLine.cs:1183 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-7a31fd09 | this.Load | SSP0008_ProductionPlanLine.cs:1186 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SSP0008_ProductionPlanLine.GetDayRange

진입점: this.Load / cboPlanDate.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ae6caf46 | this.Load 외 1 | SSP0008_ProductionPlanLine.cs:2552 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCM0001_GET_SCP_DAY_PERIOD") ⇒ SCP.SCM0001_GET_SCP_DAY_PERIOD | 엔드포인트 요청 생성 |  |  |  |
| AC-eed28143 | this.Load 외 1 | SSP0008_ProductionPlanLine.cs:2553 |  | DATA_OP | request.Parameters["p_from_date"] | p_from_date | 행/컬럼 값 대입 |  |  |  |
| AC-275cc039 | this.Load 외 1 | SSP0008_ProductionPlanLine.cs:2554 |  | DATA_OP | request.Parameters["p_offset_day"] | "55" | 행/컬럼 값 대입 |  |  |  |
| AC-857ffd6e | this.Load 외 1 | SSP0008_ProductionPlanLine.cs:2555 |  | DATA_OP | request.Parameters["p_timezone"] | UserInfoContext.Current[UserInfoProperites.TimeZone] | 행/컬럼 값 대입 |  |  |  |
| AC-94df384d | this.Load 외 1 | SSP0008_ProductionPlanLine.cs:2556 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-e11aad81 | this.Load 외 1 | SSP0008_ProductionPlanLine.cs:2559 |  | RETURN | return sDayRange; |  | 처리 중단/반환 |  |  |  |

## SSP0008_ProductionPlanLine.GetLastPlanVersion

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e609742e | (진입점 미연결) | SSP0008_ProductionPlanLine.cs:1281 | try | ENDPOINT | new FoxDataRequest | ("SSP.SSP_GET_LAST_PLAN_VERSION") ⇒ SSP.SSP_GET_LAST_PLAN_VERSION | 엔드포인트 요청 생성 |  |  |  |
| AC-a833a1e8 | (진입점 미연결) | SSP0008_ProductionPlanLine.cs:1283 | try | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-8831519f | (진입점 미연결) | SSP0008_ProductionPlanLine.cs:1284 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-17aa47c1 | (진입점 미연결) | SSP0008_ProductionPlanLine.cs:1298 | try ▸ if (dsBinding.Tables.Count > 0 && dsBinding.Tables[0].Rows.Count > 0) | VALUE_SET | cboPlanDate.SelectedValue | PLAN_START_YYYYMMDD | 컨트롤 값 설정 |  |  |  |
| AC-b38e4ff6 | (진입점 미연결) | SSP0008_ProductionPlanLine.cs:1299 | try ▸ if (dsBinding.Tables.Count > 0 && dsBinding.Tables[0].Rows.Count > 0) | VALUE_SET | cboPlanType.SelectedValue | PLAN_TYPE | 컨트롤 값 설정 |  |  |  |
| AC-c4a2299f | (진입점 미연결) | SSP0008_ProductionPlanLine.cs:1300 | try ▸ if (dsBinding.Tables.Count > 0 && dsBinding.Tables[0].Rows.Count > 0) | VALUE_SET | cboPlanSeq.SelectedValue | PLAN_SEQ | 컨트롤 값 설정 |  |  |  |

## SSP0008_ProductionPlanLine.GetSpdTitle

진입점: this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName)) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try] / this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName)) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try] / this.Load / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (fps.Name == …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-851fd270 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 5 | SSP0008_ProductionPlanLine.cs:2530 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN") ⇒ SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | 엔드포인트 요청 생성 |  |  |  |
| AC-53f6f1d1 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 5 | SSP0008_ProductionPlanLine.cs:2535 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | drpPeriod.Text1.Replace("-", "") | 행/컬럼 값 대입 |  |  |  |
| AC-96cea57f | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 5 | SSP0008_ProductionPlanLine.cs:2536 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | drpPeriod.Text2.Replace("-", "") | 행/컬럼 값 대입 |  |  |  |
| AC-6ad37c76 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 5 | SSP0008_ProductionPlanLine.cs:2538 |  | FLAG | dsSpdTitle | client.ExecuteDataSet(request).DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-6be55f82 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 5 | SSP0008_ProductionPlanLine.cs:2538 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## SSP0008_ProductionPlanLine.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fd6eeeae | this.Load | SSP0008_ProductionPlanLine.cs:204 |  | DATA_OP | this.ConditionNotUseList.Add | (cboPlanDate) | 데이터 객체 조작/조회 |  |  |  |
| AC-d1cd2183 | this.Load | SSP0008_ProductionPlanLine.cs:205 |  | DATA_OP | this.ConditionNotUseList.Add | (cboPlanType) | 데이터 객체 조작/조회 |  |  |  |
| AC-5ff01b09 | this.Load | SSP0008_ProductionPlanLine.cs:206 |  | DATA_OP | this.ConditionNotUseList.Add | (cboPlanSeq) | 데이터 객체 조작/조회 |  |  |  |
| AC-6df3f648 | this.Load | SSP0008_ProductionPlanLine.cs:209 |  | DATA_OP | ReadOnlySheetList.Add | (SpdSheet.shtMain) | 데이터 객체 조작/조회 |  |  |  |
| AC-97c53bc1 | this.Load | SSP0008_ProductionPlanLine.cs:212 | if (dtMyDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |
| AC-ee90c289 | this.Load | SSP0008_ProductionPlanLine.cs:214 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-0c2044ba | this.Load | SSP0008_ProductionPlanLine.cs:218 |  | LIST_REBIND | clsCtrl.setListBox | (dtMyDivision, cboDivision, false,"CODE","NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-a3eba424 | this.Load | SSP0008_ProductionPlanLine.cs:224 |  | LIST_REBIND | clsCtrl.setListBox | (dtElectrode, clbElectrode, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-22c13e36 | this.Load | SSP0008_ProductionPlanLine.cs:228 |  | FLAG | dtBucketType | GetBucketType() | 화면 필드/플래그 변경 |  |  |  |
| AC-d3be2200 | this.Load | SSP0008_ProductionPlanLine.cs:229 |  | LIST_REBIND | clsCtrl.setListBox | (dtBucketType, cboBucketType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-ac78e56d | this.Load | SSP0008_ProductionPlanLine.cs:231 |  | VALUE_SET | drpPeriod.InitValue | GetDayRange() | 컨트롤 값 설정 |  |  |  |

## SSP0008_ProductionPlanLine.InitSpread

진입점: this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName)) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try] / this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName)) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try] / this.Load / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (fps.Name == …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-110c1195 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 5 | SSP0008_ProductionPlanLine.cs:258 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.InitSheet | (SpdSheet.shtMain) | 그리드 재구성/초기화 |  |  |  |
| AC-b06da6e1 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 5 | SSP0008_ProductionPlanLine.cs:306 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_SET | spdInfo.ActiveSheet.DataSource | null | 그리드 속성/값 설정 |  |  |  |
| AC-cd310183 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 5 | SSP0008_ProductionPlanLine.cs:307 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.SetSheetHeaderColumn | (spdInfo, 3) | 그리드 재구성/초기화 |  |  |  |
| AC-524dd16a | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 5 | SSP0008_ProductionPlanLine.cs:311 | if (spdInfo.SheetName == SpdSheet.shtMain) | UI_PROP | spdInfo.nIdxData | nIdxDataMain | 속성 nIdxData 설정 |  |  |  |
| AC-175963cf | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 5 | SSP0008_ProductionPlanLine.cs:316 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7f22c032 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 5 | SSP0008_ProductionPlanLine.cs:318 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-96fe28bf | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 5 | SSP0008_ProductionPlanLine.cs:323 | if (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (pDivisionID != "EE") | GRID_SET | spdInfo.ActiveSheet.Columns[siMain.GetColumnIndex("ORIGIN_DIVISION_ID")].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-96695231 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 5 | SSP0008_ProductionPlanLine.cs:324 | if (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (pDivisionID != "EE") | GRID_SET | spdInfo.ActiveSheet.Columns[siMain.GetColumnIndex("ELECTRODE_TYPE")].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-d0db9ca1 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 5 | SSP0008_ProductionPlanLine.cs:328 | if (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (pDivisionID != "EE") | GRID_SET | spdInfo.ActiveSheet.Columns[siMain.GetColumnIndex("ORIGIN_DIVISION_ID")].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-3c913414 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 5 | SSP0008_ProductionPlanLine.cs:329 | if (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (pDivisionID != "EE") | GRID_SET | spdInfo.ActiveSheet.Columns[siMain.GetColumnIndex("ELECTRODE_TYPE")].Visible | true | 그리드 속성/값 설정 |  |  |  |

## SSP0008_ProductionPlanLine.InitSpreadDateColumn

진입점: this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName)) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName)) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / this…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-200dec9c | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 5 | SSP0008_ProductionPlanLine.cs:368 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sColumnName.IndexOf("B_") > 0) | GRID_INIT | spdInfo.AddTextColumn | (sColumnLabelname, sColumnName, FPMerge.None, 0, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2e919343 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 5 | SSP0008_ProductionPlanLine.cs:372 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sColumnName.IndexOf("B_") > 0) | GRID_INIT | spdInfo.AddNumColumn | (sColumnLabelname, sColumnName, FPMerge.None, 70, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0756f26f | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 5 | SSP0008_ProductionPlanLine.cs:373 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sColumnName.IndexOf("B_") > 0) | GRID_INIT | spdInfo.SetReNumerCellType | (spdInfo, spdInfo.GetColumnIndex(sColumnName),0,0) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-6c9d5980 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 5 | SSP0008_ProductionPlanLine.cs:377 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sColumnName.IndexOf("B_") > 0) ▸ if (sDayCode == DefColumnsLabel.Saturday \|\| … | GRID_SET | spdInfo.Sheet().ColumnHeader.Cells[2, spdInfo.GetMaxColumnIndex()].ForeColor | sDayCode == DefColumnsLabel.Saturday ? Color.Blue : Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-ee8ef527 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 5 | SSP0008_ProductionPlanLine.cs:384 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a4ab98fb | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 5 | SSP0008_ProductionPlanLine.cs:385 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-fad601cc | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 5 | SSP0008_ProductionPlanLine.cs:390 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ff593c75 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 5 | SSP0008_ProductionPlanLine.cs:391 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 30, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-99acb9a0 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 5 | SSP0008_ProductionPlanLine.cs:399 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName != sSmallLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ad059dc3 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 5 | SSP0008_ProductionPlanLine.cs:400 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName != sSmallLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0bf08caf | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 5 | SSP0008_ProductionPlanLine.cs:410 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f3e4a5d7 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 5 | SSP0008_ProductionPlanLine.cs:411 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c50306dd | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 5 | SSP0008_ProductionPlanLine.cs:412 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c223b54b | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 5 | SSP0008_ProductionPlanLine.cs:413 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |

## SSP0008_ProductionPlanLine.SaveButton

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b8b6cc56 | SaveButton | SSP0008_ProductionPlanLine.cs:614 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d7ebd88f | SaveButton | SSP0008_ProductionPlanLine.cs:615 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SSP0008_ProductionPlanLine.SaveData_FixInfo

진입점: this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName))] / this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-295dc4e5 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SSP0008_ProductionPlanLine.cs:1858 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (siMain.ActiveSheet.Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-20a97e7c | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SSP0008_ProductionPlanLine.cs:1890 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (selCells.Length < 1) | MESSAGE | MessageHelper.GMessageBox | ("MSG00134", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-143f0ade | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SSP0008_ProductionPlanLine.cs:1891 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (selCells.Length < 1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5b786ed1 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SSP0008_ProductionPlanLine.cs:1932 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | GRID_STYLE | siMain.SetBGColor | (i, j, i, j, ControlColor.InvalidColor) | 그리드 표시 설정 |  |  |  |
| AC-ac01d43e | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SSP0008_ProductionPlanLine.cs:1933 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | MESSAGE | MessageHelper.GMessageBox | ("MSG00026", new object[] { null}) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-84d16684 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SSP0008_ProductionPlanLine.cs:1934 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7ba96d51 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SSP0008_ProductionPlanLine.cs:1940 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | CALL_EXT | siMain.GetBGColor | (i, j) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ebb5e306 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SSP0008_ProductionPlanLine.cs:1974 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ foreach (CellRange range in selCells) ▸ if (n… | CALL_EXT | siMain.GetBGColor | (i, j+ nDayCntOfWeek) | ⚠ 의미 확인 필요 |  |  |  |
| AC-2974a8d2 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SSP0008_ProductionPlanLine.cs:2021 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (fixType == "F") | POPUP | new SCM0002_RejectReasonPopup | ("Fix Reason") | 팝업/폼 생성 |  |  |  |
| AC-10bb7308 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SSP0008_ProductionPlanLine.cs:2022 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (fixType == "F") | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-8747bd09 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SSP0008_ProductionPlanLine.cs:2023 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (fixType == "F") | UI_PROP | popup.Width | 600 | 속성 Width 설정 |  |  |  |
| AC-7bee1d9d | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SSP0008_ProductionPlanLine.cs:2024 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (fixType == "F") | UI_PROP | popup.Height | 230 | 속성 Height 설정 |  |  |  |
| AC-9b3f11d3 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SSP0008_ProductionPlanLine.cs:2026 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (fixType == "F") | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-0e8c5bf3 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SSP0008_ProductionPlanLine.cs:2035 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (fixType == "F") ▸… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f4cc23a6 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SSP0008_ProductionPlanLine.cs:2041 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ else of (fixType == "… | MESSAGE | MessageHelper.GMessageBox | ("MSG00016") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-01e48830 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SSP0008_ProductionPlanLine.cs:2041 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ else of (fixType == "… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4a6c7a92 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SSP0008_ProductionPlanLine.cs:2051 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | ENDPOINT | new FoxDataRequest | ("SCP.SCP0024_SAVE_PRODUCTION_PLAN_FIX") ⇒ SCP.SCP0024_SAVE_PRODUCTION_PLAN_FIX | 엔드포인트 요청 생성 |  |  |  |
| AC-458b5bb8 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SSP0008_ProductionPlanLine.cs:2055 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-eda42dd4 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SSP0008_ProductionPlanLine.cs:2056 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-37d7b830 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SSP0008_ProductionPlanLine.cs:2057 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_operation_group"] | p_operation_group | 행/컬럼 값 대입 |  |  |  |
| AC-11e7ec7d | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SSP0008_ProductionPlanLine.cs:2058 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_scm_site_id"] | p_scm_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-ceafc65c | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SSP0008_ProductionPlanLine.cs:2059 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_line_id"] | p_line_id | 행/컬럼 값 대입 |  |  |  |
| AC-6237515e | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SSP0008_ProductionPlanLine.cs:2060 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-54efcd42 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SSP0008_ProductionPlanLine.cs:2061 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_operation_id"] | p_operation_id | 행/컬럼 값 대입 |  |  |  |
| AC-cc3eace6 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SSP0008_ProductionPlanLine.cs:2062 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_yyyymmdd"] | p_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-8464a8b4 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SSP0008_ProductionPlanLine.cs:2063 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_qty"] | p_qty | 행/컬럼 값 대입 |  |  |  |
| AC-cd7f2d20 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SSP0008_ProductionPlanLine.cs:2064 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_fix_reason"] | strReason | 행/컬럼 값 대입 |  |  |  |
| AC-6831bb7b | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SSP0008_ProductionPlanLine.cs:2065 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_user_id"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-0157a1de | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SSP0008_ProductionPlanLine.cs:2066 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-ff41e8db | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SSP0008_ProductionPlanLine.cs:2069 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-6a9cd742 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SSP0008_ProductionPlanLine.cs:2074 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { response.DataSet.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d6134f48 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SSP0008_ProductionPlanLine.cs:2090 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ else of (response.Dat… | MESSAGE | MessageHelper.GMessageBox | ("MSG00284", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6bb4c956 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SSP0008_ProductionPlanLine.cs:2099 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-2457d2bf | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 1 | SSP0008_ProductionPlanLine.cs:2114 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ else of (iCount > 0) ▸ if (strAction == "D") | MESSAGE | MessageHelper.GMessageBox | ("MSG00046", new object[] { null}) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SSP0008_ProductionPlanLine.SaveData_Line

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3bdf13c2 | (진입점 미연결) | SSP0008_ProductionPlanLine.cs:1469 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (siMain.ActiveSheet.Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-92e6893e | (진입점 미연결) | SSP0008_ProductionPlanLine.cs:1530 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j <… | GRID_STYLE | siMain.SetBGColor | (i, j, i, j, ControlColor.InvalidColor) | 그리드 표시 설정 |  |  |  |
| AC-81b3bc04 | (진입점 미연결) | SSP0008_ProductionPlanLine.cs:1531 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j <… | MESSAGE | MessageHelper.GMessageBox | ("MSG00084", new object[] { null }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-923c0751 | (진입점 미연결) | SSP0008_ProductionPlanLine.cs:1532 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j <… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-03958fe9 | (진입점 미연결) | SSP0008_ProductionPlanLine.cs:1580 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | ENDPOINT | new FoxDataRequest | ("SSP.SSP0007_SAVE_PRODUCTION_PLAN_LINE") ⇒ SSP.SSP0007_SAVE_PRODUCTION_PLAN_LINE | 엔드포인트 요청 생성 |  |  |  |
| AC-0b5e4991 | (진입점 미연결) | SSP0008_ProductionPlanLine.cs:1584 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_active_flag"] | strACTIVE_FLAG | 행/컬럼 값 대입 |  |  |  |
| AC-3bd469ce | (진입점 미연결) | SSP0008_ProductionPlanLine.cs:1585 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_division_id"] | strDIVISION_ID | 행/컬럼 값 대입 |  |  |  |
| AC-82b495b0 | (진입점 미연결) | SSP0008_ProductionPlanLine.cs:1586 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_plan_start_yyyymmdd"] | strPLAN_START_YYYYMMDD | 행/컬럼 값 대입 |  |  |  |
| AC-d408559b | (진입점 미연결) | SSP0008_ProductionPlanLine.cs:1587 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_plan_type"] | strPLAN_TYPE | 행/컬럼 값 대입 |  |  |  |
| AC-180c2a9c | (진입점 미연결) | SSP0008_ProductionPlanLine.cs:1588 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_seq"] | strSEQ | 행/컬럼 값 대입 |  |  |  |
| AC-98d433b0 | (진입점 미연결) | SSP0008_ProductionPlanLine.cs:1589 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_operation_group"] | strOPERATION_GROUP | 행/컬럼 값 대입 |  |  |  |
| AC-c1fc4c11 | (진입점 미연결) | SSP0008_ProductionPlanLine.cs:1590 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_scm_site_id"] | strSCM_SITE_ID | 행/컬럼 값 대입 |  |  |  |
| AC-64e8e5fe | (진입점 미연결) | SSP0008_ProductionPlanLine.cs:1591 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_item_id"] | strITEM_ID | 행/컬럼 값 대입 |  |  |  |
| AC-c8520597 | (진입점 미연결) | SSP0008_ProductionPlanLine.cs:1592 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_line_id"] | strLINE_ID | 행/컬럼 값 대입 |  |  |  |
| AC-e373b4cb | (진입점 미연결) | SSP0008_ProductionPlanLine.cs:1593 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_operation_id"] | strOPERATION_ID | 행/컬럼 값 대입 |  |  |  |
| AC-26235a3e | (진입점 미연결) | SSP0008_ProductionPlanLine.cs:1594 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_measure"] | strMEASURE | 행/컬럼 값 대입 |  |  |  |
| AC-404f3485 | (진입점 미연결) | SSP0008_ProductionPlanLine.cs:1595 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_yyyymmdd"] | strYYYYMMDD | 행/컬럼 값 대입 |  |  |  |
| AC-6c8c639e | (진입점 미연결) | SSP0008_ProductionPlanLine.cs:1596 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_qty"] | strQTY | 행/컬럼 값 대입 |  |  |  |
| AC-61d18da0 | (진입점 미연결) | SSP0008_ProductionPlanLine.cs:1597 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_user_id"] | strUSER_ID | 행/컬럼 값 대입 |  |  |  |
| AC-2f035e6c | (진입점 미연결) | SSP0008_ProductionPlanLine.cs:1598 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_fix"] | strFIX | 행/컬럼 값 대입 |  |  |  |
| AC-62dc71f8 | (진입점 미연결) | SSP0008_ProductionPlanLine.cs:1600 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_program_id"] | "SSP0007" | 행/컬럼 값 대입 |  |  |  |
| AC-882b5fa5 | (진입점 미연결) | SSP0008_ProductionPlanLine.cs:1601 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-77f68f5e | (진입점 미연결) | SSP0008_ProductionPlanLine.cs:1603 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-5db97f6a | (진입점 미연결) | SSP0008_ProductionPlanLine.cs:1608 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { response.DataSet.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-033cd7da | (진입점 미연결) | SSP0008_ProductionPlanLine.cs:1626 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ else of (response.Dat… | MESSAGE | MessageHelper.GMessageBox | ("MSG00284", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-cbcef144 | (진입점 미연결) | SSP0008_ProductionPlanLine.cs:1636 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SSP0008_ProductionPlanLine.SaveData_Line_DT

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-90e46b34 | (진입점 미연결) | SSP0008_ProductionPlanLine.cs:1655 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-5e2eeb78 | (진입점 미연결) | SSP0008_ProductionPlanLine.cs:1663 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (siMain.ActiveSheet.Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d269e25c | (진입점 미연결) | SSP0008_ProductionPlanLine.cs:1670 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("A", typeof(char)) | 데이터 객체 조작/조회 |  |  |  |
| AC-378f53db | (진입점 미연결) | SSP0008_ProductionPlanLine.cs:1671 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_active_flag") | 데이터 객체 조작/조회 |  |  |  |
| AC-a7d1d631 | (진입점 미연결) | SSP0008_ProductionPlanLine.cs:1672 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_division_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-e017fb28 | (진입점 미연결) | SSP0008_ProductionPlanLine.cs:1673 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_plan_start_yyyymmdd") | 데이터 객체 조작/조회 |  |  |  |
| AC-eef0167c | (진입점 미연결) | SSP0008_ProductionPlanLine.cs:1674 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_plan_type") | 데이터 객체 조작/조회 |  |  |  |
| AC-05bf7960 | (진입점 미연결) | SSP0008_ProductionPlanLine.cs:1675 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_seq") | 데이터 객체 조작/조회 |  |  |  |
| AC-51890354 | (진입점 미연결) | SSP0008_ProductionPlanLine.cs:1676 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_operation_group") | 데이터 객체 조작/조회 |  |  |  |
| AC-4f95f426 | (진입점 미연결) | SSP0008_ProductionPlanLine.cs:1677 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_scm_site_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-867b5f45 | (진입점 미연결) | SSP0008_ProductionPlanLine.cs:1678 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_item_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-510a374a | (진입점 미연결) | SSP0008_ProductionPlanLine.cs:1679 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_line_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-0da215c3 | (진입점 미연결) | SSP0008_ProductionPlanLine.cs:1680 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_operation_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-9b6692e8 | (진입점 미연결) | SSP0008_ProductionPlanLine.cs:1681 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_measure") | 데이터 객체 조작/조회 |  |  |  |
| AC-4a55349b | (진입점 미연결) | SSP0008_ProductionPlanLine.cs:1682 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_yyyymmdd") | 데이터 객체 조작/조회 |  |  |  |
| AC-0244e9c1 | (진입점 미연결) | SSP0008_ProductionPlanLine.cs:1683 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_qty") | 데이터 객체 조작/조회 |  |  |  |
| AC-ed9b9d52 | (진입점 미연결) | SSP0008_ProductionPlanLine.cs:1684 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_user_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-5630b9a8 | (진입점 미연결) | SSP0008_ProductionPlanLine.cs:1685 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_fix") | 데이터 객체 조작/조회 |  |  |  |
| AC-ab63a081 | (진입점 미연결) | SSP0008_ProductionPlanLine.cs:1686 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_loc_flag") | 데이터 객체 조작/조회 |  |  |  |
| AC-8ef503d9 | (진입점 미연결) | SSP0008_ProductionPlanLine.cs:1687 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_program_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-0f96e7aa | (진입점 미연결) | SSP0008_ProductionPlanLine.cs:1688 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("debug_mode") | 데이터 객체 조작/조회 |  |  |  |
| AC-0777d3b9 | (진입점 미연결) | SSP0008_ProductionPlanLine.cs:1689 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dsInput.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-dae2ba37 | (진입점 미연결) | SSP0008_ProductionPlanLine.cs:1724 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | GRID_STYLE | siMain.SetBGColor | (i, j, i, j, ControlColor.InvalidColor) | 그리드 표시 설정 |  |  |  |
| AC-796d8186 | (진입점 미연결) | SSP0008_ProductionPlanLine.cs:1725 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | MESSAGE | MessageHelper.GMessageBox | ("MSG00084", new object[] { null }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d816df77 | (진입점 미연결) | SSP0008_ProductionPlanLine.cs:1726 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a1a6395b | (진입점 미연결) | SSP0008_ProductionPlanLine.cs:1733 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dsInput.Tables[0].NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-ac095917 | (진입점 미연결) | SSP0008_ProductionPlanLine.cs:1735 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["A"] | action | 행/컬럼 값 대입 |  |  |  |
| AC-edbaa046 | (진입점 미연결) | SSP0008_ProductionPlanLine.cs:1736 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_active_flag"] | action | 행/컬럼 값 대입 |  |  |  |
| AC-8605473c | (진입점 미연결) | SSP0008_ProductionPlanLine.cs:1737 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_division_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.DIVISION_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-7a01cbc0 | (진입점 미연결) | SSP0008_ProductionPlanLine.cs:1738 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_plan_start_yyyymmdd"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.PLAN_START_YYYYMMDD)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-b5251ddb | (진입점 미연결) | SSP0008_ProductionPlanLine.cs:1739 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_plan_type"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.PLAN_TYPE)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-caf3ebb0 | (진입점 미연결) | SSP0008_ProductionPlanLine.cs:1740 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_seq"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.PLAN_SEQ)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-bdbdb06b | (진입점 미연결) | SSP0008_ProductionPlanLine.cs:1741 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_operation_group"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.OPERATION_GROUP)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-617280d4 | (진입점 미연결) | SSP0008_ProductionPlanLine.cs:1742 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_scm_site_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-1b73c7ac | (진입점 미연결) | SSP0008_ProductionPlanLine.cs:1743 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_item_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ITEM_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-d93e7208 | (진입점 미연결) | SSP0008_ProductionPlanLine.cs:1744 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_line_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.LINE_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-d1b5c6fa | (진입점 미연결) | SSP0008_ProductionPlanLine.cs:1745 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_operation_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.OPERATION_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-d1e92c8e | (진입점 미연결) | SSP0008_ProductionPlanLine.cs:1746 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_measure"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.MEASURE)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-2822d90a | (진입점 미연결) | SSP0008_ProductionPlanLine.cs:1748 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_yyyymmdd"] | strDayName | 행/컬럼 값 대입 |  |  |  |
| AC-8a2e3df2 | (진입점 미연결) | SSP0008_ProductionPlanLine.cs:1749 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_qty"] | strDayQty | 행/컬럼 값 대입 |  |  |  |
| AC-cdc69f9b | (진입점 미연결) | SSP0008_ProductionPlanLine.cs:1750 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_fix"] | isFix | 행/컬럼 값 대입 |  |  |  |
| AC-57cf8d86 | (진입점 미연결) | SSP0008_ProductionPlanLine.cs:1751 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_loc_flag"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-f9b322ff | (진입점 미연결) | SSP0008_ProductionPlanLine.cs:1752 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-a7380694 | (진입점 미연결) | SSP0008_ProductionPlanLine.cs:1753 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_program_id"] | "SSP0008" | 행/컬럼 값 대입 |  |  |  |
| AC-9741ea78 | (진입점 미연결) | SSP0008_ProductionPlanLine.cs:1754 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-14f9b472 | (진입점 미연결) | SSP0008_ProductionPlanLine.cs:1757 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dsInput.Tables[0].Rows.Add | (dr) | 데이터 객체 조작/조회 |  |  |  |
| AC-273006c0 | (진입점 미연결) | SSP0008_ProductionPlanLine.cs:1767 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | GRID_SET | dsInput.Tables[0].Rows[0]["p_loc_flag"] | "F" | 그리드 속성/값 설정 |  |  |  |
| AC-9a350dbb | (진입점 미연결) | SSP0008_ProductionPlanLine.cs:1768 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | GRID_SET | dsInput.Tables[0].Rows[nRowCnt - 1]["p_loc_flag"] | "L" | 그리드 속성/값 설정 |  |  |  |
| AC-c4185b12 | (진입점 미연결) | SSP0008_ProductionPlanLine.cs:1770 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dsInput.Tables[0].AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-6adfccc0 | (진입점 미연결) | SSP0008_ProductionPlanLine.cs:1774 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-fafa90d0 | (진입점 미연결) | SSP0008_ProductionPlanLine.cs:1785 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ foreach (DataRo… | CALL_EXT | row.SetAdded | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-b0c39e52 | (진입점 미연결) | SSP0008_ProductionPlanLine.cs:1786 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ foreach (DataRo… | CALL_EXT | row.SetModified | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-f6ea97b0 | (진입점 미연결) | SSP0008_ProductionPlanLine.cs:1787 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ foreach (DataRo… | DATA_OP | row.Delete | () | 데이터 객체 조작/조회 |  |  |  |
| AC-1c48fbd0 | (진입점 미연결) | SSP0008_ProductionPlanLine.cs:1791 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | UI_PROP | request.InsertQueryId | "SSP.SSP0008_SAVE_PRODUCTION_PLAN_LINE_ROW" | 속성 InsertQueryId 설정 |  |  |  |
| AC-96032827 | (진입점 미연결) | SSP0008_ProductionPlanLine.cs:1792 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | UI_PROP | request.DeleteQueryId | "SSP.SSP0008_SAVE_PRODUCTION_PLAN_LINE_ROW" | 속성 DeleteQueryId 설정 |  |  |  |
| AC-6b4de1b9 | (진입점 미연결) | SSP0008_ProductionPlanLine.cs:1793 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | UI_PROP | request.UpdateQueryId | "SSP.SSP0008_SAVE_PRODUCTION_PLAN_LINE_ROW" | 속성 UpdateQueryId 설정 |  |  |  |
| AC-bbcc6728 | (진입점 미연결) | SSP0008_ProductionPlanLine.cs:1794 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | UI_PROP | request.DataSet | dsInput.GetChanges() | 속성 DataSet 설정 |  |  |  |
| AC-0dfcb5d2 | (진입점 미연결) | SSP0008_ProductionPlanLine.cs:1794 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | CALL_EXT | dsInput.GetChanges | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-feb235cd | (진입점 미연결) | SSP0008_ProductionPlanLine.cs:1797 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-8a655696 | (진입점 미연결) | SSP0008_ProductionPlanLine.cs:1798 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, GSCM_SSP_PLAN_S… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-1b279e73 | (진입점 미연결) | SSP0008_ProductionPlanLine.cs:1802 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ lambda | ENDPOINT | client.SaveDataTable | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-25a72619 | (진입점 미연결) | SSP0008_ProductionPlanLine.cs:1802 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ lambda | RETURN | return client.SaveDataTable(request); |  | 처리 중단/반환 |  |  |  |
| AC-efbdaa4e | (진입점 미연결) | SSP0008_ProductionPlanLine.cs:1805 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-016ec818 | (진입점 미연결) | SSP0008_ProductionPlanLine.cs:1810 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (t.Success) | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { iCount }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0770dfb4 | (진입점 미연결) | SSP0008_ProductionPlanLine.cs:1822 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ catch ((Exception ex)… | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-82217c70 | (진입점 미연결) | SSP0008_ProductionPlanLine.cs:1824 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ catch ((Exception ex)… | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c123e21d | (진입점 미연결) | SSP0008_ProductionPlanLine.cs:1828 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-9227eca8 | (진입점 미연결) | SSP0008_ProductionPlanLine.cs:1838 | catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-76928eed | (진입점 미연결) | SSP0008_ProductionPlanLine.cs:1840 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-5769dfec | (진입점 미연결) | SSP0008_ProductionPlanLine.cs:1844 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-c2876923 | (진입점 미연결) | SSP0008_ProductionPlanLine.cs:1846 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## SSP0008_ProductionPlanLine.Set_FixButtonEnabled

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c45ff514 | (진입점 미연결) | SSP0008_ProductionPlanLine.cs:2497 | if (!string.IsNullOrEmpty(strPlanDate) && !string.IsNullOrEmpty(strPlanType) && !string.IsNullOrEmpty(strPlanSeq) && nPlanDa…) | STATE | btnFix.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-cb03c1e6 | (진입점 미연결) | SSP0008_ProductionPlanLine.cs:2498 | if (!string.IsNullOrEmpty(strPlanDate) && !string.IsNullOrEmpty(strPlanType) && !string.IsNullOrEmpty(strPlanSeq) && nPlanDa…) | STATE | btnUnfix.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-857956d4 | (진입점 미연결) | SSP0008_ProductionPlanLine.cs:2501 | else of (!string.IsNullOrEmpty(strPlanDate) && !string.IsNullOrEmpty(strPlanType) && !string.IsNullOrEmpty(strPlanSeq) && nPlanDa…) | STATE | btnFix.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-ba91f314 | (진입점 미연결) | SSP0008_ProductionPlanLine.cs:2502 | else of (!string.IsNullOrEmpty(strPlanDate) && !string.IsNullOrEmpty(strPlanType) && !string.IsNullOrEmpty(strPlanSeq) && nPlanDa…) | STATE | btnUnfix.Enabled | false | 컨트롤 상태 Enabled |  |  |  |

## SSP0008_ProductionPlanLine.Set_FixCellColor

진입점: EditButton [if (fps.Name == "spdMain") ▸ if (fps.ActiveSheet.Columns.Get(xCol1).Visible == false)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-676a9534 | EditButton [if (fps.Name == "spdMain") ▸ if (fps.ActiveSheet… | SSP0008_ProductionPlanLine.cs:2295 | for (k < siMain.ActiveSheet.RowCount) ▸ if (dtFix.Rows.Count > 0) | DATA_OP | dtFix.Select | ("FIX_KEY='" + spd_FIX_KEY + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-504362d1 | EditButton [if (fps.Name == "spdMain") ▸ if (fps.ActiveSheet… | SSP0008_ProductionPlanLine.cs:2304 | for (k < siMain.ActiveSheet.RowCount) ▸ if (dtFix.Rows.Count > 0) ▸ foreach (DataRow dr in dataRows) | GRID_STYLE | siMain.SetBGColor2 | (k, nCol, k, nCol, Color.FromArgb(188,229,92)) | 그리드 표시 설정 |  |  |  |
| AC-78a2cbd0 | EditButton [if (fps.Name == "spdMain") ▸ if (fps.ActiveSheet… | SSP0008_ProductionPlanLine.cs:2307 | for (k < siMain.ActiveSheet.RowCount) ▸ if (dtFix.Rows.Count > 0) ▸ foreach (DataRow dr in dataRows) ▸ if (before_nColWeek != nColWeek) | GRID_STYLE | siMain.SetBGColor2 | (k, nColWeek, k, nColWeek, Color.FromArgb(188, 229, 92)) | 그리드 표시 설정 |  |  |  |
| AC-fabb189d | EditButton [if (fps.Name == "spdMain") ▸ if (fps.ActiveSheet… | SSP0008_ProductionPlanLine.cs:2326 | for (k < siMain.ActiveSheet.RowCount) ▸ if (spd_MEASURE == "LINE_TOTAL_LOAD") ▸ for (nCol < siMain.ActiveSheet.ColumnCount) ▸ if (siMain.Get… | GRID_STYLE | siMain.SetFGColor2 | (k, nCol, k, nCol, ControlColor.MarkedForeColor) | 그리드 표시 설정 |  |  |  |
| AC-7c0ef97c | EditButton [if (fps.Name == "spdMain") ▸ if (fps.ActiveSheet… | SSP0008_ProductionPlanLine.cs:2331 | for (k < siMain.ActiveSheet.RowCount) | UI_MISC | spdMain.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## SSP0008_ProductionPlanLine.Set_FPOperationColor

진입점: EditButton [if (fps.Name == "spdMain") ▸ if (fps.ActiveSheet.Columns.Get(xCol1).Visible == false)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-42c0fcc1 | EditButton [if (fps.Name == "spdMain") ▸ if (fps.ActiveSheet… | SSP0008_ProductionPlanLine.cs:2193 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e18b98b5 | EditButton [if (fps.Name == "spdMain") ▸ if (fps.ActiveSheet… | SSP0008_ProductionPlanLine.cs:2197 | if (fps.Name == "spdMain") ▸ if (siMain.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-39ebc120 | EditButton [if (fps.Name == "spdMain") ▸ if (fps.ActiveSheet… | SSP0008_ProductionPlanLine.cs:2198 | if (fps.Name == "spdMain") | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-e3c1ba87 | EditButton [if (fps.Name == "spdMain") ▸ if (fps.ActiveSheet… | SSP0008_ProductionPlanLine.cs:2209 | if (fps.Name == "spdMain") ▸ for (i < spdMain.ActiveSheet.RowCount) ▸ if (spdMain.ActiveSheet.GetText(i, siMain.GetColumnIndex(DefColumns.ME… | DATA_OP | dtIsEditInfo.Select | ("CP_KEY = '" + strCP_KEY + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-ff507f6a | EditButton [if (fps.Name == "spdMain") ▸ if (fps.ActiveSheet… | SSP0008_ProductionPlanLine.cs:2241 | if (fps.Name == "spdMain") ▸ for (i < spdMain.ActiveSheet.RowCount) ▸ if (spdMain.ActiveSheet.GetText(i, siMain.GetColumnIndex(DefColumns.ME… | DATA_OP | dtPlanType.Select | ("CODE='FN'") | 데이터 객체 조작/조회 |  |  |  |
| AC-82dcb178 | EditButton [if (fps.Name == "spdMain") ▸ if (fps.ActiveSheet… | SSP0008_ProductionPlanLine.cs:2275 | if (fps.Name == "spdMain") ▸ for (i < spdMain.ActiveSheet.RowCount) ▸ if (spdMain.ActiveSheet.GetText(i, siMain.GetColumnIndex(DefColumns.ME… | GRID_STYLE | siMain.SetBGColor2 | (nEditableRow, nStartEditIdx, nEditableRow, siMain.ActiveSheet.ColumnCount - 1, Color.From… | 그리드 표시 설정 |  |  |  |
| AC-328df335 | EditButton [if (fps.Name == "spdMain") ▸ if (fps.ActiveSheet… | SSP0008_ProductionPlanLine.cs:2281 | if (fps.Name == "spdMain") | UI_MISC | spdMain.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## SSP0008_ProductionPlanLine.SetChangedControl

진입점: this.Load / cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ac78acd5 | this.Load 외 1 | SSP0008_ProductionPlanLine.cs:1197 | if (pDivisionID == "EE") | FLAG | dtOperationGroup | Data_SCP.Common(Data_SCP.Type.OperationGroupEE, false) | 화면 필드/플래그 변경 |  |  |  |
| AC-d4e6d2dd | this.Load 외 1 | SSP0008_ProductionPlanLine.cs:1197 | if (pDivisionID == "EE") | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.OperationGroupEE, false) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-2aaee79e | this.Load 외 1 | SSP0008_ProductionPlanLine.cs:1201 | else of (pDivisionID == "EE") | FLAG | dtOperationGroup | Data_SCP.Common(Data_SCP.Type.OperationGroup, false) | 화면 필드/플래그 변경 |  |  |  |
| AC-1d78b0ac | this.Load 외 1 | SSP0008_ProductionPlanLine.cs:1201 | else of (pDivisionID == "EE") | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.OperationGroup, false) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-6b4e4660 | this.Load 외 1 | SSP0008_ProductionPlanLine.cs:1204 |  | LIST_REBIND | clsCtrl.setListBox | (dtOperationGroup, cboOperationGroup, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-973f38e8 | this.Load 외 1 | SSP0008_ProductionPlanLine.cs:1210 | if (pDivisionID == "EE") | FLAG | dtPlantSiteByDivision | Data_SCP.Common(Data_SCP.Type.PlantSiteProdPlanSSP, false, pDivisionID, pOperationGroup) | 화면 필드/플래그 변경 |  |  |  |
| AC-fa60a133 | this.Load 외 1 | SSP0008_ProductionPlanLine.cs:1210 | if (pDivisionID == "EE") | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.PlantSiteProdPlanSSP, false, pDivisionID, pOperationGroup) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-81f6b390 | this.Load 외 1 | SSP0008_ProductionPlanLine.cs:1214 | else of (pDivisionID == "EE") | FLAG | dtPlantSiteByDivision | Data.Common(Data.Type.PlantByDivisionOperation, false, pDivisionID, pOperationGroup) ⇒ biz:CommonData.CommonDataList [code=PlantByDivisionOperation] | 화면 필드/플래그 변경 |  |  |  |
| AC-ec1d0db4 | this.Load 외 1 | SSP0008_ProductionPlanLine.cs:1214 | else of (pDivisionID == "EE") | COMBO_DATA | Data.Common | (Data.Type.PlantByDivisionOperation, false, pDivisionID, pOperationGroup) ⇒ biz:CommonData.CommonDataList [code=PlantByDivisionOperation] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-9601288c | this.Load 외 1 | SSP0008_ProductionPlanLine.cs:1219 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlantSiteByDivision, clbPlantSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-e11409b9 | this.Load 외 1 | SSP0008_ProductionPlanLine.cs:1223 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | FLAG | dtPlanDate | Data.Common(Data.Type.PlanDateShip, false, pDivisionID) ⇒ biz:CommonData.CommonDataList [code=PlanDateShip] | 화면 필드/플래그 변경 |  |  |  |
| AC-528101bf | this.Load 외 1 | SSP0008_ProductionPlanLine.cs:1223 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | COMBO_DATA | Data.Common | (Data.Type.PlanDateShip, false, pDivisionID) ⇒ biz:CommonData.CommonDataList [code=PlanDateShip] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-89625ef9 | this.Load 외 1 | SSP0008_ProductionPlanLine.cs:1224 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | LIST_REBIND | clsCtrl.setListBox | (dtPlanDate, cboPlanDate, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-d9319184 | this.Load 외 1 | SSP0008_ProductionPlanLine.cs:1227 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | FLAG | dtPlanType | Data.Common(Data.Type.PlanTypeShip, false, pDivisionID, pPlanDate) ⇒ biz:CommonData.CommonDataList [code=PlanTypeShip] | 화면 필드/플래그 변경 |  |  |  |
| AC-187f00d0 | this.Load 외 1 | SSP0008_ProductionPlanLine.cs:1227 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | COMBO_DATA | Data.Common | (Data.Type.PlanTypeShip, false, pDivisionID, pPlanDate) ⇒ biz:CommonData.CommonDataList [code=PlanTypeShip] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-29711d65 | this.Load 외 1 | SSP0008_ProductionPlanLine.cs:1228 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | LIST_REBIND | clsCtrl.setListBox | (dtPlanType, cboPlanType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-4a89027a | this.Load 외 1 | SSP0008_ProductionPlanLine.cs:1229 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ if (dtPlanType.Rows.Count > 0) | VALUE_SET | cboPlanType.SelectedIndex | dtPlanType.Rows.Count - 1 | 컨트롤 값 설정 |  |  |  |
| AC-43dfe338 | this.Load 외 1 | SSP0008_ProductionPlanLine.cs:1232 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ if (dtPlanType.Rows.Count > 0) | VALUE_SET | cboPlanType.SelectedIndex | dtPlanType.Rows.Count - 1 | 컨트롤 값 설정 |  |  |  |
| AC-0dd6423c | this.Load 외 1 | SSP0008_ProductionPlanLine.cs:1235 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | FLAG | dtPlanSeq | Data.Common(Data.Type.PlanSeqShip, false, pDivisionID, pPlanDate, pPlanType) ⇒ biz:CommonData.CommonDataList [code=PlanSeqShip] | 화면 필드/플래그 변경 |  |  |  |
| AC-db34e9eb | this.Load 외 1 | SSP0008_ProductionPlanLine.cs:1235 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | COMBO_DATA | Data.Common | (Data.Type.PlanSeqShip, false, pDivisionID, pPlanDate, pPlanType) ⇒ biz:CommonData.CommonDataList [code=PlanSeqShip] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-e3d4f06b | this.Load 외 1 | SSP0008_ProductionPlanLine.cs:1236 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | LIST_REBIND | clsCtrl.setListBox | (dtPlanSeq, cboPlanSeq, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-eb098eef | this.Load 외 1 | SSP0008_ProductionPlanLine.cs:1242 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ if (pDivisionID != "EE") | FLAG | dtLine | Data.Common(Data.Type.LineByOperation, false, pDivisionID, "", "", "", pPlantSite) ⇒ biz:CommonData.CommonDataList [code=LineByOperation] | 화면 필드/플래그 변경 |  |  |  |
| AC-8cd07959 | this.Load 외 1 | SSP0008_ProductionPlanLine.cs:1242 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ if (pDivisionID != "EE") | COMBO_DATA | Data.Common | (Data.Type.LineByOperation, false, pDivisionID, "", "", "", pPlantSite) ⇒ biz:CommonData.CommonDataList [code=LineByOperation] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-06ef7560 | this.Load 외 1 | SSP0008_ProductionPlanLine.cs:1244 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ else of (pDivisionID != "EE") | FLAG | dtLine | Data_SCP.Common(Data_SCP.Type.LineProdPlanLineSSP, false, pDivisionID, pOperationGroup, pP… | 화면 필드/플래그 변경 |  |  |  |
| AC-d77f0aed | this.Load 외 1 | SSP0008_ProductionPlanLine.cs:1244 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ else of (pDivisionID != "EE") | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.LineProdPlanLineSSP, false, pDivisionID, pOperationGroup, pPlantSite) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-2b53c627 | this.Load 외 1 | SSP0008_ProductionPlanLine.cs:1246 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | LIST_REBIND | clsCtrl.setListBox | (dtLine, clbLine, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-02e6e018 | this.Load 외 1 | SSP0008_ProductionPlanLine.cs:1249 | if (siMain != null) | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |
| AC-e26872ad | this.Load 외 1 | SSP0008_ProductionPlanLine.cs:1253 | if (pDivisionID != "EE") | VALUE_CLEAR | clbElectrode.ControlValues | "" | 컨트롤 값 비움 |  |  |  |
| AC-c9462aea | this.Load 외 1 | SSP0008_ProductionPlanLine.cs:1254 | if (pDivisionID != "EE") | STATE | clbElectrode.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-03f8e544 | this.Load 외 1 | SSP0008_ProductionPlanLine.cs:1258 | else of (pDivisionID != "EE") | STATE | clbElectrode.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## SSP0008_ProductionPlanLine.SetLockSumColumn

진입점: EditButton [if (fps.Name == "spdMain") ▸ if (fps.ActiveSheet.Columns.Get(xCol1).Visible == false)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7b31318b | EditButton [if (fps.Name == "spdMain") ▸ if (fps.ActiveSheet… | SSP0008_ProductionPlanLine.cs:762 | for (iCol < spreadInfo.ActiveSheet.ColumnCount) ▸ if (spreadInfo.GetColumnTag(iCol).IndexOf("M_") == 0) ▸ if (spreadInfo.ActiveSheet.RowCoun… | GRID_LOCK | spreadInfo.LockRange | (0, iCol, spreadInfo.ActiveSheet.RowCount - 1, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |

## SSP0008_ProductionPlanLine.SetSpreadColumn

진입점: this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName)) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try ▸ if (siMain.GetMaxRowIndex() > 0)] / this.btnFix.Click [else of (siMain.IsLock(siMain.SheetName)) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try ▸ if (siMain.GetMaxRowIndex() > 0)] / this.Load [if (spdInfo.S…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2c80d980 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 7 | SSP0008_ProductionPlanLine.cs:796 | for (iCol < siObj.ActiveSheet.ColumnCount) ▸ if (cboBucketType.ControlValues == BucketType.Daily) ▸ if (siObj.GetColumnTag(iCol).IndexOf("D_… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-5e2303f5 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 7 | SSP0008_ProductionPlanLine.cs:801 | for (iCol < siObj.ActiveSheet.ColumnCount) ▸ if (cboBucketType.ControlValues == BucketType.Daily) ▸ if (siObj.GetColumnTag(iCol).IndexOf("M_… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | chkSum.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-860665b5 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 7 | SSP0008_ProductionPlanLine.cs:808 | for (iCol < siObj.ActiveSheet.ColumnCount) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == … | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-c48c80da | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 7 | SSP0008_ProductionPlanLine.cs:812 | for (iCol < siObj.ActiveSheet.ColumnCount) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == … | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-d3c21e8f | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 7 | SSP0008_ProductionPlanLine.cs:817 | for (iCol < siObj.ActiveSheet.ColumnCount) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == … | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | chkSum.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-14844e3a | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 7 | SSP0008_ProductionPlanLine.cs:824 | for (iCol < siObj.ActiveSheet.ColumnCount) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ else of (cboBucketType.ControlValue… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-545f3183 | this.btnUnfix.Click [else of (siMain.IsLock(siMain.SheetName… 외 7 | SSP0008_ProductionPlanLine.cs:828 | for (iCol < siObj.ActiveSheet.ColumnCount) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ else of (cboBucketType.ControlValue… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |

## SSP0008_ProductionPlanLine.SpdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-596cb881 | this.spdMain.CellClick | SSP0008_ProductionPlanLine.cs:448 | if (spdMain.ActiveSheet.ActiveRowIndex > 0) | FLAG | this.nSelRowOfMain | spdMain.ActiveSheet.ActiveRowIndex | 화면 필드/플래그 변경 |  |  |  |
| AC-a46c8daa | this.spdMain.CellClick | SSP0008_ProductionPlanLine.cs:449 | if (spdMain.ActiveSheet.ActiveRowIndex > 0) | FLAG | this.nSelColOfMain | spdMain.ActiveSheet.ActiveColumnIndex | 화면 필드/플래그 변경 |  |  |  |

## SSP0008_ProductionPlanLine.SpdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4a7c48ab | this.spdMain.CellDoubleClick | SSP0008_ProductionPlanLine.cs:2512 |  | CALL_EXT | siMain.SetDblClickColumnShowHide | (sender, e) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f62d0f8b | this.spdMain.CellDoubleClick | SSP0008_ProductionPlanLine.cs:2515 | if (!e.ColumnHeader && e.Row>=0) | FLAG | nSelRowOfMain | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-b2c1da0e | this.spdMain.CellDoubleClick | SSP0008_ProductionPlanLine.cs:2516 | if (!e.ColumnHeader && e.Row>=0) | FLAG | nSelColOfMain | e.Column | 화면 필드/플래그 변경 |  |  |  |

## SSP0008_ProductionPlanLine.SpdMain_Changed

진입점: dsdmLine.Changed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-26d54d84 | dsdmLine.Changed | SSP0008_ProductionPlanLine.cs:2345 | if (!this.CanModelChange \|\| e.Row == -1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4125aaa1 | dsdmLine.Changed | SSP0008_ProductionPlanLine.cs:2354 | if (ds == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c00d6ca7 | dsdmLine.Changed | SSP0008_ProductionPlanLine.cs:2363 | if (strColName == "Action") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9dcf018d | dsdmLine.Changed | SSP0008_ProductionPlanLine.cs:2369 | try ▸ if (ds == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d174536f | dsdmLine.Changed | SSP0008_ProductionPlanLine.cs:2389 | catch ((Exception et)) | THROW | throw et; |  | 예외 발생 |  |  |  |
| AC-b72a077b | dsdmLine.Changed | SSP0008_ProductionPlanLine.cs:2393 | finally | DATA_OP | dt.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |

## SSP0008_ProductionPlanLine.SpdMain_TopChange

진입점: this.spdMain.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b8429f9e | this.spdMain.TopChange | SSP0008_ProductionPlanLine.cs:456 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

