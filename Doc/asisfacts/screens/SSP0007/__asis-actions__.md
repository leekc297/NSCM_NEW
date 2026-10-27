# AS-IS 액션 대조표 — SSP0007

> 원천: `Doc/asisfacts/screens/SSP0007/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 435행 · 메서드 51 · 종류 DATA_OP 123 · RETURN 37 · ENDPOINT 30 · FLAG 28 · GRID_INIT 28 · CALL_EXT 24 · GRID_SET 23 · UI_PROP 17 · UI_MISC 17 · MESSAGE 15 · COMBO_DATA 14 · LIST_REBIND 14 · POPUP 13 · VALUE_SET 13 · GRID_CLEAR 8 · GRID_LOCK 8 · VALIDATE 7 · GRID_STYLE 6 · GRID_BIND 3 · THROW 3 · STATE 2 · STATE_RESET 1 · VALUE_CLEAR 1 · ⚠ 의미 확인 필요 24


## SSP0007_ProductionPlan.btnCal_Click

진입점: this.btnCal.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-42f3a8da | this.btnCal.Click | SSP0007_ProductionPlan.cs:2853 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-dedc221a | this.btnCal.Click | SSP0007_ProductionPlan.cs:2854 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7dc6e843 | this.btnCal.Click | SSP0007_ProductionPlan.cs:2858 |  | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-8584871f | this.btnCal.Click | SSP0007_ProductionPlan.cs:2858 | if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-cd5eea93 | this.btnCal.Click | SSP0007_ProductionPlan.cs:2861 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00206") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-2a2faf83 | this.btnCal.Click | SSP0007_ProductionPlan.cs:2863 | if (MessageHelper.GMessageBox("MSG00206") == DialogResult.No) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SSP0007_ProductionPlan.btnItemId_Click

진입점: this.btnItemId.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1a28c2a1 | this.btnItemId.Click | SSP0007_ProductionPlan.cs:726 |  | POPUP | new SCM0002_ItembyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-4b798f3b | this.btnItemId.Click | SSP0007_ProductionPlan.cs:728 |  | POPUP | popItem.Form_Load | (true, sdivision, sScmSite, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-b0c641a9 | this.btnItemId.Click | SSP0007_ProductionPlan.cs:729 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-30e6c32f | this.btnItemId.Click | SSP0007_ProductionPlan.cs:730 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-e940f1d5 | this.btnItemId.Click | SSP0007_ProductionPlan.cs:736 | if (popItem.ItemID != "") | VALUE_SET | txtItemId.Text | sItemId | 컨트롤 값 설정 |  |  |  |

## SSP0007_ProductionPlan.btnMeasure_Click

진입점: this.btnMeasure.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d630f18b | this.btnMeasure.Click | SSP0007_ProductionPlan.cs:754 | if (fps != null) ▸ else of (fps.Name == "spdMain") ▸ else of (fps.Name == "spdLine") | MESSAGE | MessageHelper.GMessageBox | ("MSG00007", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ebe2679f | this.btnMeasure.Click | SSP0007_ProductionPlan.cs:755 | if (fps != null) ▸ else of (fps.Name == "spdMain") ▸ else of (fps.Name == "spdLine") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-287a12f7 | this.btnMeasure.Click | SSP0007_ProductionPlan.cs:759 | else of (fps != null) | MESSAGE | MessageHelper.GMessageBox | ("MSG00007", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f19ed8b0 | this.btnMeasure.Click | SSP0007_ProductionPlan.cs:760 | else of (fps != null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d88280ed | this.btnMeasure.Click | SSP0007_ProductionPlan.cs:763 |  | POPUP | new SCM0002_TitleSetForm_Popup | ("SSP0007", shtName, false) | 팝업/폼 생성 |  |  |  |
| AC-152d7286 | this.btnMeasure.Click | SSP0007_ProductionPlan.cs:764 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-20d1070b | this.btnMeasure.Click | SSP0007_ProductionPlan.cs:765 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-a2a7fa4a | this.btnMeasure.Click | SSP0007_ProductionPlan.cs:769 | if (frm.DialogResult == DialogResult.OK) | UI_PROP | this.CanModelChange | false | 속성 CanModelChange 설정 |  |  |  |
| AC-5c71a0eb | this.btnMeasure.Click | SSP0007_ProductionPlan.cs:779 | if (frm.DialogResult == DialogResult.OK) | UI_PROP | this.CanModelChange | true | 속성 CanModelChange 설정 |  |  |  |

## SSP0007_ProductionPlan.CalculateSum

진입점: this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ if (showMsg) ▸ try] / dsdmLine.Changed [try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated:] / this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row>=0) ▸ try ▸ for (i < siLine.ActiveSheet.RowCount) ▸ if (mesure == "LINE_TOTAL_LOAD")] / FindButton [try] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0736a012 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 4 | SSP0007_ProductionPlan.cs:2079 | if (strMeasure == "ONHAND_EOH") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9fd46768 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 4 | SSP0007_ProductionPlan.cs:2085 | for (nCol < dt.Columns.Count) ▸ if (dt.Columns[nCol].ColumnName.IndexOf("M_") == 0) | DATA_OP | listMonth.Add | (nCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-9df429fc | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 4 | SSP0007_ProductionPlan.cs:2089 | for (nCol < dt.Columns.Count) ▸ if (dt.Columns[nCol].ColumnName.IndexOf("W_") == 0) | DATA_OP | listWeek.Add | (nCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-9dadb7ba | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 4 | SSP0007_ProductionPlan.cs:2130 | for (nCol < dt.Columns.Count) ▸ if (nCol == dt.Columns.Count-1 \|\| dt.Columns[nCol].ColumnName.IndexOf("W_") == 0) ▸ if (strMeasure == "FOR… | DATA_OP | dr[nIdxWeek] | weekSum / nCntDayOfWeek | 행/컬럼 값 대입 |  |  |  |
| AC-9ba65aee | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 4 | SSP0007_ProductionPlan.cs:2133 | for (nCol < dt.Columns.Count) ▸ if (nCol == dt.Columns.Count-1 \|\| dt.Columns[nCol].ColumnName.IndexOf("W_") == 0) ▸ else of (strMeasure ==… | DATA_OP | dr[nIdxWeek] | weekSum | 행/컬럼 값 대입 |  |  |  |
| AC-22e2eaca | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 4 | SSP0007_ProductionPlan.cs:2147 | for (nCol < dt.Columns.Count) ▸ if (nCol == dt.Columns.Count - 1 \|\| dt.Columns[nCol].ColumnName.IndexOf("M_") == 0) ▸ if (strMeasure == "F… | DATA_OP | dr[nIdxMonth] | monthSum / nCntDayOfMonth | 행/컬럼 값 대입 |  |  |  |
| AC-d99c5d74 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 4 | SSP0007_ProductionPlan.cs:2150 | for (nCol < dt.Columns.Count) ▸ if (nCol == dt.Columns.Count - 1 \|\| dt.Columns[nCol].ColumnName.IndexOf("M_") == 0) ▸ else of (strMeasure … | DATA_OP | dr[nIdxMonth] | monthSum | 행/컬럼 값 대입 |  |  |  |
| AC-13d03d0d | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 4 | SSP0007_ProductionPlan.cs:2159 |  | DATA_OP | dt.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-9c2729e0 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 4 | SSP0007_ProductionPlan.cs:2181 | for (nCol < dt.Columns.Count) ▸ if (dt.Columns[nCol].ColumnName.IndexOf("M_") == 0) | DATA_OP | listMonth.Add | (nCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-dbfb99a5 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 4 | SSP0007_ProductionPlan.cs:2185 | for (nCol < dt.Columns.Count) ▸ if (dt.Columns[nCol].ColumnName.IndexOf("W_") == 0) | DATA_OP | listWeek.Add | (nCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-5a043fa3 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 4 | SSP0007_ProductionPlan.cs:2244 | for (nRow < dt.Rows.Count) ▸ for (nCol < dt.Columns.Count) ▸ if (nCol == dt.Columns.Count - 1 \|\| dt.Columns[nCol].ColumnName.IndexOf("W_")… | DATA_OP | dr[nIdxWeek] | weekSum / nCntDayOfWeek | 행/컬럼 값 대입 |  |  |  |
| AC-54f94fa6 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 4 | SSP0007_ProductionPlan.cs:2247 | for (nRow < dt.Rows.Count) ▸ for (nCol < dt.Columns.Count) ▸ if (nCol == dt.Columns.Count - 1 \|\| dt.Columns[nCol].ColumnName.IndexOf("W_")… | DATA_OP | dr[nIdxWeek] | weekSum | 행/컬럼 값 대입 |  |  |  |
| AC-b995c73a | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 4 | SSP0007_ProductionPlan.cs:2265 | for (nRow < dt.Rows.Count) ▸ for (nCol < dt.Columns.Count) ▸ if (nCol == dt.Columns.Count - 1 \|\| dt.Columns[nCol].ColumnName.IndexOf("M_")… | DATA_OP | dr[nIdxMonth] | monthSum / nCntDayOfMonth | 행/컬럼 값 대입 |  |  |  |
| AC-04b61948 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 4 | SSP0007_ProductionPlan.cs:2269 | for (nRow < dt.Rows.Count) ▸ for (nCol < dt.Columns.Count) ▸ if (nCol == dt.Columns.Count - 1 \|\| dt.Columns[nCol].ColumnName.IndexOf("M_")… | DATA_OP | dr[nIdxMonth] | monthSum | 행/컬럼 값 대입 |  |  |  |
| AC-2be65d79 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 4 | SSP0007_ProductionPlan.cs:2278 |  | DATA_OP | dt.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |

## SSP0007_ProductionPlan.CboOperationGroup_SelectedIndexChanged

진입점: cboOperationGroup.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8bc234ec | cboOperationGroup.SelectedIndexChanged | SSP0007_ProductionPlan.cs:2591 | if (pDivisionID != "EE") | FLAG | dtPlantSiteByDivision | Data.Common(Data.Type.PlantByDivisionOperation, false, pDivisionID, pOperationGroup) ⇒ biz:CommonData.CommonDataList [code=PlantByDivisionOperation] | 화면 필드/플래그 변경 |  |  |  |
| AC-6d7fcd1c | cboOperationGroup.SelectedIndexChanged | SSP0007_ProductionPlan.cs:2591 | if (pDivisionID != "EE") | COMBO_DATA | Data.Common | (Data.Type.PlantByDivisionOperation, false, pDivisionID, pOperationGroup) ⇒ biz:CommonData.CommonDataList [code=PlantByDivisionOperation] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-fabf0f3b | cboOperationGroup.SelectedIndexChanged | SSP0007_ProductionPlan.cs:2593 | else of (pDivisionID != "EE") | FLAG | dtPlantSiteByDivision | Data_SCP.Common(Data_SCP.Type.PlantSiteProdPlanSSP, false, pDivisionID, pOperationGroup) | 화면 필드/플래그 변경 |  |  |  |
| AC-af9ac2f3 | cboOperationGroup.SelectedIndexChanged | SSP0007_ProductionPlan.cs:2593 | else of (pDivisionID != "EE") | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.PlantSiteProdPlanSSP, false, pDivisionID, pOperationGroup) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-7aa95096 | cboOperationGroup.SelectedIndexChanged | SSP0007_ProductionPlan.cs:2595 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlantSiteByDivision, clbPlantSite, true) | 목록 컨트롤 재구성 |  |  |  |

## SSP0007_ProductionPlan.CboPlanDate_SelectedIndexChanged

진입점: cboPlanDate.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c3ab9390 | cboPlanDate.SelectedIndexChanged | SSP0007_ProductionPlan.cs:2623 |  | FLAG | dtPlanType | Data.Common(Data.Type.PlanTypeShip, false, pDivisionID, pPlanDate) ⇒ biz:CommonData.CommonDataList [code=PlanTypeShip] | 화면 필드/플래그 변경 |  |  |  |
| AC-c7fd749d | cboPlanDate.SelectedIndexChanged | SSP0007_ProductionPlan.cs:2623 |  | COMBO_DATA | Data.Common | (Data.Type.PlanTypeShip, false, pDivisionID, pPlanDate) ⇒ biz:CommonData.CommonDataList [code=PlanTypeShip] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-2aa68f0b | cboPlanDate.SelectedIndexChanged | SSP0007_ProductionPlan.cs:2624 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanType, cboPlanType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-0bce3d55 | cboPlanDate.SelectedIndexChanged | SSP0007_ProductionPlan.cs:2625 |  | VALUE_SET | cboPlanType.SelectedIndex | dtPlanType.Rows.Count - 1 | 컨트롤 값 설정 |  |  |  |
| AC-716713b0 | cboPlanDate.SelectedIndexChanged | SSP0007_ProductionPlan.cs:2628 |  | VALUE_SET | drpPeriod.InitValue | GetDayRange() | 컨트롤 값 설정 |  |  |  |
| AC-57d71fe3 | cboPlanDate.SelectedIndexChanged | SSP0007_ProductionPlan.cs:2633 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |
| AC-5f58ce5a | cboPlanDate.SelectedIndexChanged | SSP0007_ProductionPlan.cs:2634 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdLine) | 그리드 데이터/선택 비움 |  |  |  |

## SSP0007_ProductionPlan.CboPlanSeq_SelectedIndexChanged

진입점: cboPlanSeq.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-385f1e4c | cboPlanSeq.SelectedIndexChanged | SSP0007_ProductionPlan.cs:2657 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |
| AC-a8f67ffe | cboPlanSeq.SelectedIndexChanged | SSP0007_ProductionPlan.cs:2658 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdLine) | 그리드 데이터/선택 비움 |  |  |  |

## SSP0007_ProductionPlan.CboPlanType_SelectedIndexChanged

진입점: cboPlanType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d7f72f9d | cboPlanType.SelectedIndexChanged | SSP0007_ProductionPlan.cs:2645 |  | FLAG | dtPlanSeq | Data.Common(Data.Type.PlanSeqShip, false, pDivisionID, pPlanDate, pPlanType) ⇒ biz:CommonData.CommonDataList [code=PlanSeqShip] | 화면 필드/플래그 변경 |  |  |  |
| AC-9becb2a5 | cboPlanType.SelectedIndexChanged | SSP0007_ProductionPlan.cs:2645 |  | COMBO_DATA | Data.Common | (Data.Type.PlanSeqShip, false, pDivisionID, pPlanDate, pPlanType) ⇒ biz:CommonData.CommonDataList [code=PlanSeqShip] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-741a0f7c | cboPlanType.SelectedIndexChanged | SSP0007_ProductionPlan.cs:2646 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanSeq, cboPlanSeq, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-55b52cc0 | cboPlanType.SelectedIndexChanged | SSP0007_ProductionPlan.cs:2647 |  | VALUE_SET | cboPlanSeq.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-c6679324 | cboPlanType.SelectedIndexChanged | SSP0007_ProductionPlan.cs:2649 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |
| AC-1e1708db | cboPlanType.SelectedIndexChanged | SSP0007_ProductionPlan.cs:2650 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdLine) | 그리드 데이터/선택 비움 |  |  |  |

## SSP0007_ProductionPlan.ClbPlantSite_SelectedIndexChanged

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-21ce3540 | (진입점 미연결) | SSP0007_ProductionPlan.cs:2614 |  | FLAG | dtPlantSiteByDivision | Data.Common(Data.Type.PlantByDivisionOperation, false, pDivisionID, pOperationGroup) ⇒ biz:CommonData.CommonDataList [code=PlantByDivisionOperation] | 화면 필드/플래그 변경 |  |  |  |
| AC-fb4bb301 | (진입점 미연결) | SSP0007_ProductionPlan.cs:2614 |  | COMBO_DATA | Data.Common | (Data.Type.PlantByDivisionOperation, false, pDivisionID, pOperationGroup) ⇒ biz:CommonData.CommonDataList [code=PlantByDivisionOperation] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-2684cfd3 | (진입점 미연결) | SSP0007_ProductionPlan.cs:2615 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlantSiteByDivision, clbPlantSite, true) | 목록 컨트롤 재구성 |  |  |  |

## SSP0007_ProductionPlan.ClearEventInvocations

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e5693c59 | (진입점 미연결) | SSP0007_ProductionPlan.cs:2683 | if (fi == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-cf5f7a3b | (진입점 미연결) | SSP0007_ProductionPlan.cs:2684 |  | GRID_SET | fi.SetValue | (obj, null) | 그리드 값 설정 |  |  |  |

## SSP0007_ProductionPlan.ClearUsrCheckedList

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4ca20b03 | (진입점 미연결) | SSP0007_ProductionPlan.cs:191 | if (dt != null) | STATE_RESET | dt.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-e45fe1c3 | (진입점 미연결) | SSP0007_ProductionPlan.cs:192 | if (dt != null) | LIST_REBIND | clsCtrl.setListBox | (dt, control, true) | 목록 컨트롤 재구성 |  |  |  |

## SSP0007_ProductionPlan.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-179c9f7c | this.Load | SSP0007_ProductionPlan.cs:247 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 3, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-3e92d216 | this.Load | SSP0007_ProductionPlan.cs:248 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, 0) | 화면 필드/플래그 변경 |  |  |  |
| AC-987ade35 | this.Load | SSP0007_ProductionPlan.cs:250 |  | GRID_INIT | this.AddSheet | (spdLine, SpdSheet.shtLine, SpdSheet.shtLine, 3, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-24ef1173 | this.Load | SSP0007_ProductionPlan.cs:251 |  | FLAG | siLine | GetSheetInfo(spdLine.Name, 0) | 화면 필드/플래그 변경 |  |  |  |
| AC-7ab55cc8 | this.Load | SSP0007_ProductionPlan.cs:254 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SSP0007_ProductionPlan.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-38e0db1a | this.Load | SSP0007_ProductionPlan.cs:180 |  | UI_PROP | usrConditionPanel1.Height | 105 | 속성 Height 설정 |  |  |  |
| AC-d9958077 | this.Load | SSP0007_ProductionPlan.cs:181 |  | VALUE_SET | cboBucketType.ControlValues | BucketType.Daily | 컨트롤 값 설정 |  |  |  |
| AC-af31e7b8 | this.Load | SSP0007_ProductionPlan.cs:182 |  | VALUE_SET | chkSum.Checked | false | 컨트롤 값 설정 |  |  |  |

## SSP0007_ProductionPlan.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-11f3f216 | Dispose | SSP0007_ProductionPlan.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SSP0007_ProductionPlan.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a4430712 | EditButton | SSP0007_ProductionPlan.cs:614 | if (fps != null) ▸ if (fps.Name == "spdMain" \|\| fps.Name == "spdLine") | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9bc9bdcc | EditButton | SSP0007_ProductionPlan.cs:615 | if (fps != null) ▸ if (fps.Name == "spdMain" \|\| fps.Name == "spdLine") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8a2ab1d7 | EditButton | SSP0007_ProductionPlan.cs:622 | if (fps != null) ▸ if (fps.Name == "spdLine") | FLAG | siLine | GetSheetInfo(spdLine.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-81d74b9e | EditButton | SSP0007_ProductionPlan.cs:623 | if (fps != null) ▸ if (fps.Name == "spdLine") | GRID_LOCK | siLine.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-4746a823 | EditButton | SSP0007_ProductionPlan.cs:627 | if (fps != null) ▸ if (fps.Name == "spdLine") | CALL_EXT | fps.ActiveSheet.GetColumnFromTag | (null, CAppSetting.StringAction) | ⚠ 의미 확인 필요 |  |  |  |
| AC-389411c6 | EditButton | SSP0007_ProductionPlan.cs:628 | if (fps != null) ▸ if (fps.Name == "spdLine") | CALL_EXT | fps.ActiveSheet.Columns.Get | (xCol1) | ⚠ 의미 확인 필요 |  |  |  |
| AC-86c0e09b | EditButton | SSP0007_ProductionPlan.cs:630 | if (fps != null) ▸ if (fps.Name == "spdLine") ▸ if (fps.ActiveSheet.Columns.Get(xCol1).Visible == true) | VALUE_SET | cboBucketType.ControlValues | BucketType.Daily | 컨트롤 값 설정 |  |  |  |
| AC-4b159aad | EditButton | SSP0007_ProductionPlan.cs:633 | if (fps != null) ▸ if (fps.Name == "spdLine") | GRID_LOCK | siLine.LockRange | (0, 0, siLine.ActiveSheet.RowCount - 1, siLine.ActiveSheet.ColumnCount - 1, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-e3888704 | EditButton | SSP0007_ProductionPlan.cs:636 | if (fps != null) ▸ if (fps.Name == "spdLine") | CALL_EXT | fps.ActiveSheet.Columns.Get | (xCol1) | ⚠ 의미 확인 필요 |  |  |  |
| AC-4605ed0c | EditButton | SSP0007_ProductionPlan.cs:639 | if (fps != null) ▸ if (fps.Name == "spdLine") ▸ if (fps.ActiveSheet.Columns.Get(xCol1).Visible == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-92ef19e5 | EditButton | SSP0007_ProductionPlan.cs:677 | if (fps != null) ▸ if (fps.Name == "spdLine") ▸ for (i < spdLine.ActiveSheet.RowCount) ▸ if (spdLine.ActiveSheet.GetText(i, siLine.GetColumn… | DATA_OP | dtPlanType.Select | ("CODE='FN'") | 데이터 객체 조작/조회 |  |  |  |
| AC-56e29f63 | EditButton | SSP0007_ProductionPlan.cs:702 | if (fps != null) ▸ if (fps.Name == "spdLine") ▸ for (i < spdLine.ActiveSheet.RowCount) ▸ if (spdLine.ActiveSheet.GetText(i, siLine.GetColumn… | GRID_LOCK | siLine.LockRange | (nEditableRow, nStartEditIdx, nEditableRow, siLine.ActiveSheet.ColumnCount - 1, false) | 그리드 편집 잠금/해제 |  |  |  |

## SSP0007_ProductionPlan.FindButton

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ecb6529d | FindButton | SSP0007_ProductionPlan.cs:592 |  | FLAG | this.nSelColOfMain | -1 | 화면 필드/플래그 변경 |  |  |  |
| AC-e45700c0 | FindButton | SSP0007_ProductionPlan.cs:593 |  | FLAG | this.nSelRowOfMain | -1 | 화면 필드/플래그 변경 |  |  |  |

## SSP0007_ProductionPlan.FindData_Line

진입점: this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ if (showMsg) ▸ try ▸ if (this.nSelRowOfMain >= 0 && isReload)] / this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row>=0)] / FindButton [try ▸ if (this.nSelRowOfMain >= 0 && isReload)] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-92db056c | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 3 | SSP0007_ProductionPlan.cs:1426 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-f795f597 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 3 | SSP0007_ProductionPlan.cs:1467 | try | UI_PROP | proxyPivot.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-8fc4f120 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 3 | SSP0007_ProductionPlan.cs:1468 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-5aa04f86 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 3 | SSP0007_ProductionPlan.cs:1469 | try | ENDPOINT | proxyPivot.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, GSCM_SSP_PLAN_S… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-f804884d | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 3 | SSP0007_ProductionPlan.cs:1472 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SSP.SSP0007_GET_PRODUCTION_PLAN_LINE") ⇒ SSP.SSP0007_GET_PRODUCTION_PLAN_LINE | 엔드포인트 요청 생성 |  |  |  |
| AC-18b691c1 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 3 | SSP0007_ProductionPlan.cs:1473 | try ▸ lambda | UI_PROP | req.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-d3e88ff3 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 3 | SSP0007_ProductionPlan.cs:1474 | try ▸ lambda | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-9a5b60c0 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 3 | SSP0007_ProductionPlan.cs:1475 | try ▸ lambda | DATA_OP | req.Parameters["p_operation_group"] | p_operation_group | 행/컬럼 값 대입 |  |  |  |
| AC-eb902859 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 3 | SSP0007_ProductionPlan.cs:1476 | try ▸ lambda | DATA_OP | req.Parameters["p_scm_site_id"] | p_scm_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-eb6329cf | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 3 | SSP0007_ProductionPlan.cs:1477 | try ▸ lambda | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-8d4c9ac2 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 3 | SSP0007_ProductionPlan.cs:1478 | try ▸ lambda | DATA_OP | req.Parameters["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-a6e38ad4 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 3 | SSP0007_ProductionPlan.cs:1479 | try ▸ lambda | DATA_OP | req.Parameters["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-2dfb0775 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 3 | SSP0007_ProductionPlan.cs:1480 | try ▸ lambda | DATA_OP | req.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-6e4a859f | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 3 | SSP0007_ProductionPlan.cs:1481 | try ▸ lambda | DATA_OP | req.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-8f83675b | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 3 | SSP0007_ProductionPlan.cs:1482 | try ▸ lambda | DATA_OP | req.Parameters["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-d395ebe1 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 3 | SSP0007_ProductionPlan.cs:1483 | try ▸ lambda | DATA_OP | req.Parameters["p_electrode_type"] | p_electrode_type | 행/컬럼 값 대입 |  |  |  |
| AC-e8c6dd70 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 3 | SSP0007_ProductionPlan.cs:1484 | try ▸ lambda | DATA_OP | req.Parameters["p_program_id"] | p_program_id | 행/컬럼 값 대입 |  |  |  |
| AC-5e93753f | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 3 | SSP0007_ProductionPlan.cs:1485 | try ▸ lambda | DATA_OP | req.Parameters["p_sheet_name"] | p_sheet_name | 행/컬럼 값 대입 |  |  |  |
| AC-f5765a9e | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 3 | SSP0007_ProductionPlan.cs:1486 | try ▸ lambda | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-f70b75f5 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 3 | SSP0007_ProductionPlan.cs:1487 | try ▸ lambda | DATA_OP | req.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-87760034 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 3 | SSP0007_ProductionPlan.cs:1488 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-f1e64c11 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 3 | SSP0007_ProductionPlan.cs:1489 | try ▸ lambda | RETURN | return res.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-1699b167 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 3 | SSP0007_ProductionPlan.cs:1502 | try | GRID_BIND | siLine.Query | (dsBinding) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-968deb8b | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 3 | SSP0007_ProductionPlan.cs:1504 | try | GRID_LOCK | siLine.LockColumn | (0, siLine.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-3ce66177 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 3 | SSP0007_ProductionPlan.cs:1506 | try | UI_MISC | SetSearchCount | (dsBinding) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-8a66d165 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 3 | SSP0007_ProductionPlan.cs:1511 | try | GRID_INIT | siLine.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-52f6380d | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 3 | SSP0007_ProductionPlan.cs:1522 | try ▸ for (i < siLine.ActiveSheet.RowCount) ▸ if (mesure == "LINE_TOTAL_LOAD") | CALL_EXT | siLine.SetDecimal | (i, nIdxStart, i, nIdxEnd, 2, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e9aadac7 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 3 | SSP0007_ProductionPlan.cs:1535 | try ▸ for (i < siLine.ActiveSheet.RowCount) ▸ if (mesure == "LINE_TOTAL_LOAD") ▸ for (nCol < siMain.ActiveSheet.ColumnCount) ▸ if (siLine.Ge… | GRID_STYLE | siLine.SetFGColor2 | (i, nCol, i, nCol, ControlColor.MarkedForeColor) | 그리드 표시 설정 |  |  |  |
| AC-527926fe | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 3 | SSP0007_ProductionPlan.cs:1539 | try ▸ for (i < siLine.ActiveSheet.RowCount) ▸ if (mesure == "LINE_TOTAL_LOAD") | UI_MISC | spdLine.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-9d723aab | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 3 | SSP0007_ProductionPlan.cs:1562 | try ▸ if (this.nSelRowOfLine >= 0 && isReload) | GRID_STYLE | siLine.ActiveSheet.SetActiveCell | (this.nSelRowOfLine, this.nSelColOfLine) | 그리드 표시 설정 |  |  |  |
| AC-b18b4f23 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 3 | SSP0007_ProductionPlan.cs:1563 | try ▸ if (this.nSelRowOfLine >= 0 && isReload) | CALL_EXT | spdLine.ShowCell | (0, 0, this.nSelRowOfLine, this.nSelColOfLine, FarPoint.Win.Spread.VerticalPosition.Center… | ⚠ 의미 확인 필요 |  |  |  |
| AC-e460a3a3 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 3 | SSP0007_ProductionPlan.cs:1566 | try | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-ed89c4f1 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 3 | SSP0007_ProductionPlan.cs:1570 | catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-23b53c16 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 3 | SSP0007_ProductionPlan.cs:1572 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a8120b46 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 3 | SSP0007_ProductionPlan.cs:1577 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SSP0007_ProductionPlan.FindData_Model

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-526a6dd8 | (진입점 미연결) | SSP0007_ProductionPlan.cs:1036 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-54d265dc | (진입점 미연결) | SSP0007_ProductionPlan.cs:1040 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-8ccb79bb | (진입점 미연결) | SSP0007_ProductionPlan.cs:1040 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a147ba2a | (진입점 미연결) | SSP0007_ProductionPlan.cs:1041 | try | VALIDATE | DateUtil.Check_PeriodDate | (drpPeriod) | 프레임워크 검증 |  |  |  |
| AC-6c7b1665 | (진입점 미연결) | SSP0007_ProductionPlan.cs:1041 | try ▸ if (!DateUtil.Check_PeriodDate(drpPeriod)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b1ec42df | (진입점 미연결) | SSP0007_ProductionPlan.cs:1045 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-d3661f17 | (진입점 미연결) | SSP0007_ProductionPlan.cs:1072 | try | UI_PROP | proxyPivot.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-b5f6b2f6 | (진입점 미연결) | SSP0007_ProductionPlan.cs:1074 | try | ENDPOINT | proxyPivot.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, GSCM_SSP_PLAN_S… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-6fe73ea9 | (진입점 미연결) | SSP0007_ProductionPlan.cs:1077 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SSP.SSP0007_GET_PRODUCTION_PLAN_MODEL") ⇒ SSP.SSP0007_GET_PRODUCTION_PLAN_MODEL | 엔드포인트 요청 생성 |  |  |  |
| AC-d0160d84 | (진입점 미연결) | SSP0007_ProductionPlan.cs:1079 | try ▸ lambda | UI_PROP | req.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-b69d44ff | (진입점 미연결) | SSP0007_ProductionPlan.cs:1080 | try ▸ lambda | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-683950d3 | (진입점 미연결) | SSP0007_ProductionPlan.cs:1081 | try ▸ lambda | DATA_OP | req.Parameters["p_operation_group"] | p_operation_group | 행/컬럼 값 대입 |  |  |  |
| AC-33ae64de | (진입점 미연결) | SSP0007_ProductionPlan.cs:1082 | try ▸ lambda | DATA_OP | req.Parameters["p_scm_site_id"] | p_scm_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-fcf03aed | (진입점 미연결) | SSP0007_ProductionPlan.cs:1083 | try ▸ lambda | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-6245fe2e | (진입점 미연결) | SSP0007_ProductionPlan.cs:1084 | try ▸ lambda | DATA_OP | req.Parameters["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-f815ae8e | (진입점 미연결) | SSP0007_ProductionPlan.cs:1085 | try ▸ lambda | DATA_OP | req.Parameters["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-640687ad | (진입점 미연결) | SSP0007_ProductionPlan.cs:1086 | try ▸ lambda | DATA_OP | req.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-7f235bc6 | (진입점 미연결) | SSP0007_ProductionPlan.cs:1087 | try ▸ lambda | DATA_OP | req.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-5f2e6484 | (진입점 미연결) | SSP0007_ProductionPlan.cs:1088 | try ▸ lambda | DATA_OP | req.Parameters["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-3f94a38d | (진입점 미연결) | SSP0007_ProductionPlan.cs:1089 | try ▸ lambda | DATA_OP | req.Parameters["p_program_id"] | p_program_id | 행/컬럼 값 대입 |  |  |  |
| AC-8e8a852e | (진입점 미연결) | SSP0007_ProductionPlan.cs:1090 | try ▸ lambda | DATA_OP | req.Parameters["p_sheet_name"] | p_sheet_name | 행/컬럼 값 대입 |  |  |  |
| AC-2f38d02b | (진입점 미연결) | SSP0007_ProductionPlan.cs:1091 | try ▸ lambda | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-97109835 | (진입점 미연결) | SSP0007_ProductionPlan.cs:1092 | try ▸ lambda | DATA_OP | req.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-53594ee3 | (진입점 미연결) | SSP0007_ProductionPlan.cs:1093 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-249a030a | (진입점 미연결) | SSP0007_ProductionPlan.cs:1094 | try ▸ lambda | RETURN | return res.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-d142e01b | (진입점 미연결) | SSP0007_ProductionPlan.cs:1101 | try | GRID_BIND | siMain.Query | (dsBinding) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-99b5fec7 | (진입점 미연결) | SSP0007_ProductionPlan.cs:1103 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-13d685b4 | (진입점 미연결) | SSP0007_ProductionPlan.cs:1104 | try | UI_MISC | SetSearchCount | (dsBinding) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-97d15b80 | (진입점 미연결) | SSP0007_ProductionPlan.cs:1114 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-074db532 | (진입점 미연결) | SSP0007_ProductionPlan.cs:1127 | try ▸ if (this.nSelRowOfMain >= 0 && isReload) | GRID_STYLE | siMain.ActiveSheet.SetActiveCell | (this.nSelRowOfMain, this.nSelColOfMain) | 그리드 표시 설정 |  |  |  |
| AC-8126b9ac | (진입점 미연결) | SSP0007_ProductionPlan.cs:1128 | try ▸ if (this.nSelRowOfMain >= 0 && isReload) | CALL_EXT | spdMain.ShowCell | (0, 0, this.nSelRowOfMain, this.nSelColOfMain, FarPoint.Win.Spread.VerticalPosition.Center… | ⚠ 의미 확인 필요 |  |  |  |
| AC-693245e6 | (진입점 미연결) | SSP0007_ProductionPlan.cs:1134 | try | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-76f7d5e4 | (진입점 미연결) | SSP0007_ProductionPlan.cs:1139 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e8a4ce55 | (진입점 미연결) | SSP0007_ProductionPlan.cs:1144 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SSP0007_ProductionPlan.FindData_Model_Parallel

진입점: this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ if (showMsg)] / FindButton / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5653e523 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SSP0007_ProductionPlan.cs:1153 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-c708483e | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SSP0007_ProductionPlan.cs:1157 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-5675d487 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SSP0007_ProductionPlan.cs:1157 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b7a3efc6 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SSP0007_ProductionPlan.cs:1158 | try | VALIDATE | DateUtil.Check_PeriodDate | (drpPeriod) | 프레임워크 검증 |  |  |  |
| AC-93341719 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SSP0007_ProductionPlan.cs:1158 | try ▸ if (!DateUtil.Check_PeriodDate(drpPeriod)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-55483b01 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SSP0007_ProductionPlan.cs:1162 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-ce90cbe9 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SSP0007_ProductionPlan.cs:1189 | try | CALL_EXT | DateUtil.MonthDiff | (p_to_yyyymmdd.ToString(), p_from_yyyymmdd.ToString()) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b9a6e1d5 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SSP0007_ProductionPlan.cs:1211 | try | CALL_EXT | Parallel.For | (0, (nCnt), (i) => { //for(int i = 0; i < 6; i++) { if (i != nCnt-1) { string strStartDate… | ⚠ 의미 확인 필요 |  |  |  |
| AC-118f64b2 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SSP0007_ProductionPlan.cs:1245 | try ▸ lambda ▸ if (i != nCnt-1) | ENDPOINT | new FoxDataRequest | ("SSP.SSP0007_GET_PRODUCTION_PLAN_MODEL") ⇒ SSP.SSP0007_GET_PRODUCTION_PLAN_MODEL | 엔드포인트 요청 생성 |  |  |  |
| AC-73c033cf | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SSP0007_ProductionPlan.cs:1247 | try ▸ lambda ▸ if (i != nCnt-1) | UI_PROP | req.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-b5a9a605 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SSP0007_ProductionPlan.cs:1248 | try ▸ lambda ▸ if (i != nCnt-1) | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-8bbc32b5 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SSP0007_ProductionPlan.cs:1249 | try ▸ lambda ▸ if (i != nCnt-1) | DATA_OP | req.Parameters["p_operation_group"] | p_operation_group | 행/컬럼 값 대입 |  |  |  |
| AC-161438c5 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SSP0007_ProductionPlan.cs:1250 | try ▸ lambda ▸ if (i != nCnt-1) | DATA_OP | req.Parameters["p_scm_site_id"] | p_scm_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-3ff23e0d | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SSP0007_ProductionPlan.cs:1251 | try ▸ lambda ▸ if (i != nCnt-1) | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-f5c7518a | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SSP0007_ProductionPlan.cs:1252 | try ▸ lambda ▸ if (i != nCnt-1) | DATA_OP | req.Parameters["p_from_yyyymmdd"] | strStartDate | 행/컬럼 값 대입 |  |  |  |
| AC-328a0f82 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SSP0007_ProductionPlan.cs:1253 | try ▸ lambda ▸ if (i != nCnt-1) | DATA_OP | req.Parameters["p_to_yyyymmdd"] | strEndDate | 행/컬럼 값 대입 |  |  |  |
| AC-ecc9e7f6 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SSP0007_ProductionPlan.cs:1254 | try ▸ lambda ▸ if (i != nCnt-1) | DATA_OP | req.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-388b770e | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SSP0007_ProductionPlan.cs:1255 | try ▸ lambda ▸ if (i != nCnt-1) | DATA_OP | req.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-147a8926 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SSP0007_ProductionPlan.cs:1256 | try ▸ lambda ▸ if (i != nCnt-1) | DATA_OP | req.Parameters["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-c597763e | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SSP0007_ProductionPlan.cs:1257 | try ▸ lambda ▸ if (i != nCnt-1) | DATA_OP | req.Parameters["p_electrode_type"] | p_electrode_type | 행/컬럼 값 대입 |  |  |  |
| AC-2564d778 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SSP0007_ProductionPlan.cs:1258 | try ▸ lambda ▸ if (i != nCnt-1) | DATA_OP | req.Parameters["p_program_id"] | p_program_id | 행/컬럼 값 대입 |  |  |  |
| AC-1bcf81be | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SSP0007_ProductionPlan.cs:1259 | try ▸ lambda ▸ if (i != nCnt-1) | DATA_OP | req.Parameters["p_sheet_name"] | p_sheet_name | 행/컬럼 값 대입 |  |  |  |
| AC-1be7ca20 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SSP0007_ProductionPlan.cs:1260 | try ▸ lambda ▸ if (i != nCnt-1) | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-c61e524c | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SSP0007_ProductionPlan.cs:1261 | try ▸ lambda ▸ if (i != nCnt-1) | DATA_OP | req.Parameters["p_nick_name"] | p_nick_name | 행/컬럼 값 대입 |  |  |  |
| AC-e458b00f | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SSP0007_ProductionPlan.cs:1262 | try ▸ lambda ▸ if (i != nCnt-1) | DATA_OP | req.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-f4135061 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SSP0007_ProductionPlan.cs:1268 | try ▸ lambda ▸ if (i != nCnt-1) ▸ if (i == 0) | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-4d945bcd | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SSP0007_ProductionPlan.cs:1272 | try ▸ lambda ▸ if (i != nCnt-1) ▸ else of (i == 0) ▸ if (i == 1) | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-9f23f7e5 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SSP0007_ProductionPlan.cs:1276 | try ▸ lambda ▸ if (i != nCnt-1) ▸ else of (i == 0) ▸ else of (i == 1) ▸ if (i == 2) | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-59c77e17 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SSP0007_ProductionPlan.cs:1300 | try ▸ lambda ▸ else of (i != nCnt-1) | ENDPOINT | new FoxDataRequest | ("SSP.SSP0007_GET_PRODUCTION_PLAN_MODEL_TITLE_PARAL") ⇒ SSP.SSP0007_GET_PRODUCTION_PLAN_MODEL_TITLE_PARAL | 엔드포인트 요청 생성 |  |  |  |
| AC-1792ae24 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SSP0007_ProductionPlan.cs:1302 | try ▸ lambda ▸ else of (i != nCnt-1) | UI_PROP | req.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-bc3b3b5d | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SSP0007_ProductionPlan.cs:1303 | try ▸ lambda ▸ else of (i != nCnt-1) | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-4449db87 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SSP0007_ProductionPlan.cs:1304 | try ▸ lambda ▸ else of (i != nCnt-1) | DATA_OP | req.Parameters["p_operation_group"] | p_operation_group | 행/컬럼 값 대입 |  |  |  |
| AC-93042b6d | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SSP0007_ProductionPlan.cs:1305 | try ▸ lambda ▸ else of (i != nCnt-1) | DATA_OP | req.Parameters["p_scm_site_id"] | p_scm_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-6e941c87 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SSP0007_ProductionPlan.cs:1306 | try ▸ lambda ▸ else of (i != nCnt-1) | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-c1d7fec1 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SSP0007_ProductionPlan.cs:1307 | try ▸ lambda ▸ else of (i != nCnt-1) | DATA_OP | req.Parameters["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-dc43ea08 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SSP0007_ProductionPlan.cs:1308 | try ▸ lambda ▸ else of (i != nCnt-1) | DATA_OP | req.Parameters["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-d490a14b | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SSP0007_ProductionPlan.cs:1309 | try ▸ lambda ▸ else of (i != nCnt-1) | DATA_OP | req.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-3b01eebf | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SSP0007_ProductionPlan.cs:1310 | try ▸ lambda ▸ else of (i != nCnt-1) | DATA_OP | req.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-28fdf68a | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SSP0007_ProductionPlan.cs:1311 | try ▸ lambda ▸ else of (i != nCnt-1) | DATA_OP | req.Parameters["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-349c6355 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SSP0007_ProductionPlan.cs:1312 | try ▸ lambda ▸ else of (i != nCnt-1) | DATA_OP | req.Parameters["p_electrode_type"] | p_electrode_type | 행/컬럼 값 대입 |  |  |  |
| AC-7e980029 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SSP0007_ProductionPlan.cs:1313 | try ▸ lambda ▸ else of (i != nCnt-1) | DATA_OP | req.Parameters["p_program_id"] | p_program_id | 행/컬럼 값 대입 |  |  |  |
| AC-f2ecba06 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SSP0007_ProductionPlan.cs:1314 | try ▸ lambda ▸ else of (i != nCnt-1) | DATA_OP | req.Parameters["p_sheet_name"] | p_sheet_name | 행/컬럼 값 대입 |  |  |  |
| AC-7dad8dc9 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SSP0007_ProductionPlan.cs:1315 | try ▸ lambda ▸ else of (i != nCnt-1) | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-5a2da5c8 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SSP0007_ProductionPlan.cs:1316 | try ▸ lambda ▸ else of (i != nCnt-1) | DATA_OP | req.Parameters["p_nick_name"] | p_nick_name | 행/컬럼 값 대입 |  |  |  |
| AC-08aef249 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SSP0007_ProductionPlan.cs:1317 | try ▸ lambda ▸ else of (i != nCnt-1) | DATA_OP | req.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-2931faaa | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SSP0007_ProductionPlan.cs:1319 | try ▸ lambda ▸ else of (i != nCnt-1) | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a059628f | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SSP0007_ProductionPlan.cs:1327 | try | DATA_OP | dsTitle.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-87f1ba1d | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SSP0007_ProductionPlan.cs:1328 | try | UI_MISC | dsTitle.Dispose | () | 창 닫기/해제 |  |  |  |
| AC-5bbcc4c1 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SSP0007_ProductionPlan.cs:1355 | try ▸ if (dsBinding1 != null) | CALL_EXT | DataUtil.SetDataTableQtyData | (dsBinding.Tables[0], dsBinding1.Tables[0]) | ⚠ 의미 확인 필요 |  |  |  |
| AC-914796fd | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SSP0007_ProductionPlan.cs:1356 | try ▸ if (dsBinding2 != null) | CALL_EXT | DataUtil.SetDataTableQtyData | (dsBinding.Tables[0], dsBinding2.Tables[0]) | ⚠ 의미 확인 필요 |  |  |  |
| AC-4f01323a | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SSP0007_ProductionPlan.cs:1357 | try ▸ if (dsBinding3 != null) | CALL_EXT | DataUtil.SetDataTableQtyData | (dsBinding.Tables[0], dsBinding3.Tables[0]) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e40f4767 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SSP0007_ProductionPlan.cs:1358 | try ▸ if (dsBinding4 != null) | CALL_EXT | DataUtil.SetDataTableQtyData | (dsBinding.Tables[0], dsBinding4.Tables[0]) | ⚠ 의미 확인 필요 |  |  |  |
| AC-1bc4a60b | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SSP0007_ProductionPlan.cs:1359 | try ▸ if (dsBinding5 != null) | CALL_EXT | DataUtil.SetDataTableQtyData | (dsBinding.Tables[0], dsBinding5.Tables[0]) | ⚠ 의미 확인 필요 |  |  |  |
| AC-97994cff | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SSP0007_ProductionPlan.cs:1360 | try ▸ if (dsBinding6 != null) | CALL_EXT | DataUtil.SetDataTableQtyData | (dsBinding.Tables[0], dsBinding6.Tables[0]) | ⚠ 의미 확인 필요 |  |  |  |
| AC-56981051 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SSP0007_ProductionPlan.cs:1366 | try | GRID_BIND | siMain.Query | (dsBinding) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-321646f5 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SSP0007_ProductionPlan.cs:1368 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-dcdaf079 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SSP0007_ProductionPlan.cs:1369 | try | UI_MISC | SetSearchCount | (dsBinding) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-0d74ae69 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SSP0007_ProductionPlan.cs:1381 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-bf3dc1df | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SSP0007_ProductionPlan.cs:1401 | try ▸ if (this.nSelRowOfMain >= 0 && isReload) | GRID_STYLE | siMain.ActiveSheet.SetActiveCell | (this.nSelRowOfMain, this.nSelColOfMain) | 그리드 표시 설정 |  |  |  |
| AC-886b806f | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SSP0007_ProductionPlan.cs:1402 | try ▸ if (this.nSelRowOfMain >= 0 && isReload) | CALL_EXT | spdMain.ShowCell | (0, 0, this.nSelRowOfMain, this.nSelColOfMain, FarPoint.Win.Spread.VerticalPosition.Center… | ⚠ 의미 확인 필요 |  |  |  |
| AC-052677d6 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SSP0007_ProductionPlan.cs:1408 | try | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-5dbeeb2d | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SSP0007_ProductionPlan.cs:1413 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-44ec19ec | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SSP0007_ProductionPlan.cs:1418 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SSP0007_ProductionPlan.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d0a65612 | this.Load | SSP0007_ProductionPlan.cs:165 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SSP0007_ProductionPlan.Get_IsEditInfo

진입점: this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row>=0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-436bd41c | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row>=… | SSP0007_ProductionPlan.cs:1598 |  | UI_PROP | proxyPivot.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-0464945a | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row>=… | SSP0007_ProductionPlan.cs:1599 |  | ENDPOINT | proxyPivot.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, GSCM_SSP_PLAN_S… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-d3b102b1 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row>=… | SSP0007_ProductionPlan.cs:1602 | lambda | ENDPOINT | new FoxDataRequest | ("SSP.SSP0007_GET_PLAN_EDIT_INFO") ⇒ SSP.SSP0007_GET_PLAN_EDIT_INFO | 엔드포인트 요청 생성 |  |  |  |
| AC-a1d7ce65 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row>=… | SSP0007_ProductionPlan.cs:1604 | lambda | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-0ae9515d | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row>=… | SSP0007_ProductionPlan.cs:1605 | lambda | DATA_OP | req.Parameters["p_scm_site_id"] | p_scm_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-d83fd5c5 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row>=… | SSP0007_ProductionPlan.cs:1606 | lambda | DATA_OP | req.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-e009105b | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row>=… | SSP0007_ProductionPlan.cs:1607 | lambda | DATA_OP | req.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-52d202c4 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row>=… | SSP0007_ProductionPlan.cs:1608 | lambda | DATA_OP | req.Parameters["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-85d81ed9 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row>=… | SSP0007_ProductionPlan.cs:1609 | lambda | DATA_OP | req.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-80955d22 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row>=… | SSP0007_ProductionPlan.cs:1610 | lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-eaa02472 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row>=… | SSP0007_ProductionPlan.cs:1611 | lambda | RETURN | return res.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-a69fe085 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row>=… | SSP0007_ProductionPlan.cs:1616 | if (dsBinding.Tables.Count > 0) | FLAG | dtIsEditInfo | dsBinding.Tables[0] | 화면 필드/플래그 변경 |  |  |  |

## SSP0007_ProductionPlan.GetBucketType

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6c5bf113 | this.Load | SSP0007_ProductionPlan.cs:900 |  | ENDPOINT | new FoxDataRequest | ("DM.DM0003_GET_BUCKET_TYPE_CODE") ⇒ DM.DM0003_GET_BUCKET_TYPE_CODE | 엔드포인트 요청 생성 |  |  |  |
| AC-987f7276 | this.Load | SSP0007_ProductionPlan.cs:901 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-6a58db2e | this.Load | SSP0007_ProductionPlan.cs:904 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SSP0007_ProductionPlan.GetDayRange

진입점: this.Load / cboPlanDate.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3a16d4f4 | this.Load 외 1 | SSP0007_ProductionPlan.cs:2836 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCM0001_GET_SCP_DAY_PERIOD") ⇒ SCP.SCM0001_GET_SCP_DAY_PERIOD | 엔드포인트 요청 생성 |  |  |  |
| AC-15919f20 | this.Load 외 1 | SSP0007_ProductionPlan.cs:2837 |  | DATA_OP | request.Parameters["p_from_date"] | p_from_date | 행/컬럼 값 대입 |  |  |  |
| AC-000f2e7f | this.Load 외 1 | SSP0007_ProductionPlan.cs:2838 |  | DATA_OP | request.Parameters["p_offset_day"] | "55" | 행/컬럼 값 대입 |  |  |  |
| AC-03a7f6c9 | this.Load 외 1 | SSP0007_ProductionPlan.cs:2839 |  | DATA_OP | request.Parameters["p_timezone"] | UserInfoContext.Current[UserInfoProperites.TimeZone] | 행/컬럼 값 대입 |  |  |  |
| AC-7b24a064 | this.Load 외 1 | SSP0007_ProductionPlan.cs:2840 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-fc0574df | this.Load 외 1 | SSP0007_ProductionPlan.cs:2843 |  | RETURN | return sDayRange; |  | 처리 중단/반환 |  |  |  |

## SSP0007_ProductionPlan.GetDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-aef60035 | (진입점 미연결) | SSP0007_ProductionPlan.cs:2768 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_DIVISION") ⇒ SCM.SCM0001_GET_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-bbf599cc | (진입점 미연결) | SSP0007_ProductionPlan.cs:2769 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-6a8affe6 | (진입점 미연결) | SSP0007_ProductionPlan.cs:2772 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SSP0007_ProductionPlan.GetEventField

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-442de8df | (진입점 미연결) | SSP0007_ProductionPlan.cs:2693 | while (type != null) | CALL_EXT | type.GetField | (eventName, BindingFlags.Static \| BindingFlags.Instance \| BindingFlags.NonPublic) | ⚠ 의미 확인 필요 |  |  |  |
| AC-56db3ab0 | (진입점 미연결) | SSP0007_ProductionPlan.cs:2694 | while (type != null) | CALL_EXT | field.FieldType.IsSubclassOf | (typeof(MulticastDelegate)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c7a97e7f | (진입점 미연결) | SSP0007_ProductionPlan.cs:2698 | while (type != null) | CALL_EXT | type.GetField | ("EVENT_" + eventName.ToUpper(), BindingFlags.Static \| BindingFlags.Instance \| BindingFl… | ⚠ 의미 확인 필요 |  |  |  |
| AC-3bf94c20 | (진입점 미연결) | SSP0007_ProductionPlan.cs:2703 |  | RETURN | return field; |  | 처리 중단/반환 |  |  |  |

## SSP0007_ProductionPlan.GetLastPlanVersion

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-96655afe | (진입점 미연결) | SSP0007_ProductionPlan.cs:994 | try | ENDPOINT | new FoxDataRequest | ("SSP.SSP_GET_LAST_PLAN_VERSION") ⇒ SSP.SSP_GET_LAST_PLAN_VERSION | 엔드포인트 요청 생성 |  |  |  |
| AC-23d34214 | (진입점 미연결) | SSP0007_ProductionPlan.cs:996 | try | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-94282e07 | (진입점 미연결) | SSP0007_ProductionPlan.cs:997 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-2260df8a | (진입점 미연결) | SSP0007_ProductionPlan.cs:1011 | try ▸ if (dsBinding.Tables.Count > 0 && dsBinding.Tables[0].Rows.Count > 0) | VALUE_SET | cboPlanDate.SelectedValue | PLAN_START_YYYYMMDD | 컨트롤 값 설정 |  |  |  |
| AC-35a0f169 | (진입점 미연결) | SSP0007_ProductionPlan.cs:1012 | try ▸ if (dsBinding.Tables.Count > 0 && dsBinding.Tables[0].Rows.Count > 0) | VALUE_SET | cboPlanType.SelectedValue | PLAN_TYPE | 컨트롤 값 설정 |  |  |  |
| AC-ce79c01d | (진입점 미연결) | SSP0007_ProductionPlan.cs:1013 | try ▸ if (dsBinding.Tables.Count > 0 && dsBinding.Tables[0].Rows.Count > 0) | VALUE_SET | cboPlanSeq.SelectedValue | PLAN_SEQ | 컨트롤 값 설정 |  |  |  |

## SSP0007_ProductionPlan.GetShipToParty

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e18be2dd | (진입점 미연결) | SSP0007_ProductionPlan.cs:2803 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SSP0007_ProductionPlan.GetShipType

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a19a7518 | (진입점 미연결) | SSP0007_ProductionPlan.cs:2798 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SSP0007_ProductionPlan.GetSoldToParty

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e43f0164 | (진입점 미연결) | SSP0007_ProductionPlan.cs:2808 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SSP0007_ProductionPlan.GetSpdTitle

진입점: this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ if (showMsg) ▸ try] / this.Load / this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row>=0) ▸ try] / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (fps.Name == "spdMain")] / FindButton [try] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9bfcf659 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 5 | SSP0007_ProductionPlan.cs:2815 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN") ⇒ SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | 엔드포인트 요청 생성 |  |  |  |
| AC-4f81efba | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 5 | SSP0007_ProductionPlan.cs:2820 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | drpPeriod.Text1.Replace("-", "") | 행/컬럼 값 대입 |  |  |  |
| AC-504ddd44 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 5 | SSP0007_ProductionPlan.cs:2821 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | drpPeriod.Text2.Replace("-", "") | 행/컬럼 값 대입 |  |  |  |
| AC-4110e4a2 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 5 | SSP0007_ProductionPlan.cs:2823 |  | FLAG | dsSpdTitle | client.ExecuteDataSet(request).DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-33d40a7e | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 5 | SSP0007_ProductionPlan.cs:2823 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## SSP0007_ProductionPlan.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9b21d371 | this.Load | SSP0007_ProductionPlan.cs:198 |  | DATA_OP | this.ConditionNotUseList.Add | (cboPlanDate) | 데이터 객체 조작/조회 |  |  |  |
| AC-0a10601f | this.Load | SSP0007_ProductionPlan.cs:199 |  | DATA_OP | this.ConditionNotUseList.Add | (cboPlanType) | 데이터 객체 조작/조회 |  |  |  |
| AC-ec53b941 | this.Load | SSP0007_ProductionPlan.cs:200 |  | DATA_OP | this.ConditionNotUseList.Add | (cboPlanSeq) | 데이터 객체 조작/조회 |  |  |  |
| AC-19e1793a | this.Load | SSP0007_ProductionPlan.cs:203 |  | DATA_OP | ReadOnlySheetList.Add | (SpdSheet.shtMain) | 데이터 객체 조작/조회 |  |  |  |
| AC-a5bb5473 | this.Load | SSP0007_ProductionPlan.cs:204 |  | DATA_OP | ReadOnlySheetList.Add | (SpdSheet.shtLine) | 데이터 객체 조작/조회 |  |  |  |
| AC-632d57e0 | this.Load | SSP0007_ProductionPlan.cs:207 | if (dtMyDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |
| AC-19d58172 | this.Load | SSP0007_ProductionPlan.cs:209 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-d00893d1 | this.Load | SSP0007_ProductionPlan.cs:213 |  | LIST_REBIND | clsCtrl.setListBox | (dtMyDivision, cboDivision, false,"CODE","NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-efe75320 | this.Load | SSP0007_ProductionPlan.cs:217 |  | LIST_REBIND | clsCtrl.setListBox | (dtElectrode, clbElectrode, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-426693b6 | this.Load | SSP0007_ProductionPlan.cs:228 |  | FLAG | dtBucketType | GetBucketType() | 화면 필드/플래그 변경 |  |  |  |
| AC-391953f3 | this.Load | SSP0007_ProductionPlan.cs:229 |  | LIST_REBIND | clsCtrl.setListBox | (dtBucketType, cboBucketType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-82a07806 | this.Load | SSP0007_ProductionPlan.cs:231 |  | VALUE_SET | drpPeriod.InitValue | GetDayRange() | 컨트롤 값 설정 |  |  |  |

## SSP0007_ProductionPlan.InitSpread

진입점: this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ if (showMsg) ▸ try] / this.Load / this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row>=0) ▸ try] / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (fps.Name == "spdMain")] / FindButton [try] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-edb7bb28 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 5 | SSP0007_ProductionPlan.cs:311 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.SetSheetHeaderColumn | (spdInfo, 3) | 그리드 재구성/초기화 |  |  |  |
| AC-cf8bd7cc | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 5 | SSP0007_ProductionPlan.cs:314 | if (spdInfo.SheetName == SpdSheet.shtMain) | UI_PROP | spdInfo.nIdxData | nIdxDataMain | 속성 nIdxData 설정 |  |  |  |
| AC-9db50c1a | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 5 | SSP0007_ProductionPlan.cs:319 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f6221b61 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 5 | SSP0007_ProductionPlan.cs:321 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-2c7999ca | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 5 | SSP0007_ProductionPlan.cs:326 | if (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (pDivisionID != "EE") | GRID_SET | spdInfo.ActiveSheet.Columns[siMain.GetColumnIndex("ORIGIN_DIVISION_ID")].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-017d1d0b | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 5 | SSP0007_ProductionPlan.cs:327 | if (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (pDivisionID != "EE") | GRID_SET | spdInfo.ActiveSheet.Columns[siMain.GetColumnIndex("ELECTRODE_TYPE")].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-8f7bea2a | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 5 | SSP0007_ProductionPlan.cs:331 | if (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (pDivisionID != "EE") | GRID_SET | spdInfo.ActiveSheet.Columns[siMain.GetColumnIndex("ORIGIN_DIVISION_ID")].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-de8ecbfd | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 5 | SSP0007_ProductionPlan.cs:332 | if (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (pDivisionID != "EE") | GRID_SET | spdInfo.ActiveSheet.Columns[siMain.GetColumnIndex("ELECTRODE_TYPE")].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-3fe9a911 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 5 | SSP0007_ProductionPlan.cs:377 | if (spdInfo.SheetName == SpdSheet.shtLine) | GRID_INIT | spdInfo.SetSheetHeaderColumn | (spdInfo, 3) | 그리드 재구성/초기화 |  |  |  |
| AC-116b558f | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 5 | SSP0007_ProductionPlan.cs:380 | if (spdInfo.SheetName == SpdSheet.shtLine) | UI_PROP | spdInfo.nIdxData | nIdxDataLine | 속성 nIdxData 설정 |  |  |  |
| AC-4c863cb5 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 5 | SSP0007_ProductionPlan.cs:386 | if (spdInfo.SheetName == SpdSheet.shtLine) | GRID_INIT | spdInfo.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-506e88e3 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 5 | SSP0007_ProductionPlan.cs:387 | if (spdInfo.SheetName == SpdSheet.shtLine) | GRID_INIT | spdInfo.Freeze | (0, spdInfo.GetColumnIndex(DefColumns.MEASURE_NAME) + 1) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-3ba06fe9 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 5 | SSP0007_ProductionPlan.cs:388 | if (spdInfo.SheetName == SpdSheet.shtLine) | GRID_INIT | spdInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-f34a65d2 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 5 | SSP0007_ProductionPlan.cs:392 | if (spdInfo.SheetName == SpdSheet.shtLine) ▸ if (pDivisionID != "EE") | GRID_SET | spdInfo.ActiveSheet.Columns[siLine.GetColumnIndex("ORIGIN_DIVISION_ID")].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-9862475f | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 5 | SSP0007_ProductionPlan.cs:393 | if (spdInfo.SheetName == SpdSheet.shtLine) ▸ if (pDivisionID != "EE") | GRID_SET | spdInfo.ActiveSheet.Columns[siLine.GetColumnIndex("ELECTRODE_TYPE")].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-68e21a46 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 5 | SSP0007_ProductionPlan.cs:397 | if (spdInfo.SheetName == SpdSheet.shtLine) ▸ else of (pDivisionID != "EE") | GRID_SET | spdInfo.ActiveSheet.Columns[siLine.GetColumnIndex("ORIGIN_DIVISION_ID")].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-a1cfd5a6 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 5 | SSP0007_ProductionPlan.cs:398 | if (spdInfo.SheetName == SpdSheet.shtLine) ▸ else of (pDivisionID != "EE") | GRID_SET | spdInfo.ActiveSheet.Columns[siLine.GetColumnIndex("ELECTRODE_TYPE")].Visible | true | 그리드 속성/값 설정 |  |  |  |

## SSP0007_ProductionPlan.InitSpreadDateColumn

진입점: this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ if (showMsg) ▸ try ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] / this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row>=0) ▸ try ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (fps.Name == "spdMain") ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / FindButton [try ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-efffa5bf | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 5 | SSP0007_ProductionPlan.cs:436 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sColumnName.IndexOf("B_") > 0) | GRID_INIT | spdInfo.AddTextColumn | (sColumnLabelname, sColumnName, FPMerge.None, 0, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-065f0dce | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 5 | SSP0007_ProductionPlan.cs:440 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sColumnName.IndexOf("B_") > 0) | GRID_INIT | spdInfo.AddNumColumn | (sColumnLabelname, sColumnName, FPMerge.None, 70, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ecf2d55b | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 5 | SSP0007_ProductionPlan.cs:441 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sColumnName.IndexOf("B_") > 0) | GRID_INIT | spdInfo.SetReNumerCellType | (spdInfo, spdInfo.GetColumnIndex(sColumnName),0,0) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-181d8788 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 5 | SSP0007_ProductionPlan.cs:444 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sColumnName.IndexOf("B_") > 0) ▸ if (sDayCode == DefColumnsLabel.Saturday \|\| … | GRID_SET | spdInfo.Sheet().ColumnHeader.Cells[2, spdInfo.GetMaxColumnIndex()].ForeColor | sDayCode == DefColumnsLabel.Saturday ? Color.Blue : Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-c5ebef6f | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 5 | SSP0007_ProductionPlan.cs:451 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-01e61f59 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 5 | SSP0007_ProductionPlan.cs:452 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-81cf87cb | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 5 | SSP0007_ProductionPlan.cs:457 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-04dad9d0 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 5 | SSP0007_ProductionPlan.cs:458 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 30, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-885263cf | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 5 | SSP0007_ProductionPlan.cs:466 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName != sSmallLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-00046464 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 5 | SSP0007_ProductionPlan.cs:467 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName != sSmallLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6a4540d3 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 5 | SSP0007_ProductionPlan.cs:477 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1242f45e | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 5 | SSP0007_ProductionPlan.cs:478 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-28c342fe | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 5 | SSP0007_ProductionPlan.cs:479 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d171af84 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 5 | SSP0007_ProductionPlan.cs:480 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |

## SSP0007_ProductionPlan.SaveButton

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9ad73f32 | SaveButton | SSP0007_ProductionPlan.cs:787 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9cc1cccc | SaveButton | SSP0007_ProductionPlan.cs:788 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SSP0007_ProductionPlan.SaveChage_CalData

진입점: this.btnCal.Click / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4f90d0a3 | this.btnCal.Click 외 1 | SSP0007_ProductionPlan.cs:2873 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-aace46bf | this.btnCal.Click 외 1 | SSP0007_ProductionPlan.cs:2874 |  | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-142d7b9f | this.btnCal.Click 외 1 | SSP0007_ProductionPlan.cs:2888 | try | ENDPOINT | new FoxDataRequest | ("SCP.PR_SCP_ANL_PRODUCTION_PLAN_I_AMEND") ⇒ SCP.PR_SCP_ANL_PRODUCTION_PLAN_I_AMEND | 엔드포인트 요청 생성 |  |  |  |
| AC-fa56589a | this.btnCal.Click 외 1 | SSP0007_ProductionPlan.cs:2891 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-c6d9e64b | this.btnCal.Click 외 1 | SSP0007_ProductionPlan.cs:2893 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCP.Analysis.WSL/FoxDataServi… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-9b54c9e2 | this.btnCal.Click 외 1 | SSP0007_ProductionPlan.cs:2897 | try ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-7d7c1435 | this.btnCal.Click 외 1 | SSP0007_ProductionPlan.cs:2898 | try ▸ lambda | DATA_OP | request.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-4f9cb2a1 | this.btnCal.Click 외 1 | SSP0007_ProductionPlan.cs:2899 | try ▸ lambda | DATA_OP | request.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-ce4951ca | this.btnCal.Click 외 1 | SSP0007_ProductionPlan.cs:2900 | try ▸ lambda | DATA_OP | request.Parameters["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-90da7517 | this.btnCal.Click 외 1 | SSP0007_ProductionPlan.cs:2901 | try ▸ lambda | DATA_OP | request.Parameters["p_operation_group"] | p_operation_group | 행/컬럼 값 대입 |  |  |  |
| AC-fa61f9bc | this.btnCal.Click 외 1 | SSP0007_ProductionPlan.cs:2902 | try ▸ lambda | DATA_OP | request.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-f39ad619 | this.btnCal.Click 외 1 | SSP0007_ProductionPlan.cs:2904 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a614aa7f | this.btnCal.Click 외 1 | SSP0007_ProductionPlan.cs:2904 | try ▸ lambda | RETURN | return client.ExecuteDataSet(request); |  | 처리 중단/반환 |  |  |  |
| AC-b9f7806d | this.btnCal.Click 외 1 | SSP0007_ProductionPlan.cs:2914 | try ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ if (showMsg) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-b4022fe8 | this.btnCal.Click 외 1 | SSP0007_ProductionPlan.cs:2937 | try ▸ if (t.Success) ▸ else of (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") | MESSAGE | MessageHelper.GMessageBox | ("MSG00284", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8c459064 | this.btnCal.Click 외 1 | SSP0007_ProductionPlan.cs:2945 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9e57c350 | this.btnCal.Click 외 1 | SSP0007_ProductionPlan.cs:2949 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SSP0007_ProductionPlan.SaveData_Line

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1038f534 | (진입점 미연결) | SSP0007_ProductionPlan.cs:2292 | if (fps.Name == "spdLine") ▸ if (siLine != null && siMain.IsLock(SpdSheet.shtLine) == false) ▸ if (siLine.ActiveSheet.Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-87e3fc13 | (진입점 미연결) | SSP0007_ProductionPlan.cs:2316 | if (fps.Name == "spdLine") ▸ if (siLine != null && siMain.IsLock(SpdSheet.shtLine) == false) | VALIDATE | DataUtil.checkRequiredOfSpread | (siLine) | 프레임워크 검증 |  |  |  |
| AC-846acff7 | (진입점 미연결) | SSP0007_ProductionPlan.cs:2316 | if (fps.Name == "spdLine") ▸ if (siLine != null && siMain.IsLock(SpdSheet.shtLine) == false) ▸ if (!DataUtil.checkRequiredOfSpread(siLine)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c0cfcef1 | (진입점 미연결) | SSP0007_ProductionPlan.cs:2349 | if (fps.Name == "spdLine") ▸ if (siLine != null && siMain.IsLock(SpdSheet.shtLine) == false) ▸ for (i <= siLine.GetMaxRowIndex()) ▸ for (j <… | GRID_STYLE | siLine.SetBGColor | (i, j, i, j, ControlColor.InvalidColor) | 그리드 표시 설정 |  |  |  |
| AC-a121fd7b | (진입점 미연결) | SSP0007_ProductionPlan.cs:2350 | if (fps.Name == "spdLine") ▸ if (siLine != null && siMain.IsLock(SpdSheet.shtLine) == false) ▸ for (i <= siLine.GetMaxRowIndex()) ▸ for (j <… | MESSAGE | MessageHelper.GMessageBox | ("MSG00084", new object[] { null}) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-bb85a5ff | (진입점 미연결) | SSP0007_ProductionPlan.cs:2351 | if (fps.Name == "spdLine") ▸ if (siLine != null && siMain.IsLock(SpdSheet.shtLine) == false) ▸ for (i <= siLine.GetMaxRowIndex()) ▸ for (j <… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7fdcc46b | (진입점 미연결) | SSP0007_ProductionPlan.cs:2396 | if (fps.Name == "spdLine") ▸ if (siLine != null && siMain.IsLock(SpdSheet.shtLine) == false) ▸ if (iCount > 0) ▸ try | ENDPOINT | new FoxDataRequest | ("SCP.SSP0007_SAVE_PRODUCTION_PLAN_LINE") ⇒ SCP.SSP0007_SAVE_PRODUCTION_PLAN_LINE | 엔드포인트 요청 생성 |  |  |  |
| AC-737f14a7 | (진입점 미연결) | SSP0007_ProductionPlan.cs:2400 | if (fps.Name == "spdLine") ▸ if (siLine != null && siMain.IsLock(SpdSheet.shtLine) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_active_flag"] | strACTIVE_FLAG | 행/컬럼 값 대입 |  |  |  |
| AC-1ba7ca5b | (진입점 미연결) | SSP0007_ProductionPlan.cs:2401 | if (fps.Name == "spdLine") ▸ if (siLine != null && siMain.IsLock(SpdSheet.shtLine) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_division_id"] | strDIVISION_ID | 행/컬럼 값 대입 |  |  |  |
| AC-874b7c25 | (진입점 미연결) | SSP0007_ProductionPlan.cs:2402 | if (fps.Name == "spdLine") ▸ if (siLine != null && siMain.IsLock(SpdSheet.shtLine) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_plan_start_yyyymmdd"] | strPLAN_START_YYYYMMDD | 행/컬럼 값 대입 |  |  |  |
| AC-27cef9b1 | (진입점 미연결) | SSP0007_ProductionPlan.cs:2403 | if (fps.Name == "spdLine") ▸ if (siLine != null && siMain.IsLock(SpdSheet.shtLine) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_plan_type"] | strPLAN_TYPE | 행/컬럼 값 대입 |  |  |  |
| AC-1e5a0cca | (진입점 미연결) | SSP0007_ProductionPlan.cs:2404 | if (fps.Name == "spdLine") ▸ if (siLine != null && siMain.IsLock(SpdSheet.shtLine) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_seq"] | strSEQ | 행/컬럼 값 대입 |  |  |  |
| AC-7c91453b | (진입점 미연결) | SSP0007_ProductionPlan.cs:2405 | if (fps.Name == "spdLine") ▸ if (siLine != null && siMain.IsLock(SpdSheet.shtLine) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_operation_group"] | strOPERATION_GROUP | 행/컬럼 값 대입 |  |  |  |
| AC-ad8baf24 | (진입점 미연결) | SSP0007_ProductionPlan.cs:2406 | if (fps.Name == "spdLine") ▸ if (siLine != null && siMain.IsLock(SpdSheet.shtLine) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_scm_site_id"] | strSCM_SITE_ID | 행/컬럼 값 대입 |  |  |  |
| AC-8bdeb3c7 | (진입점 미연결) | SSP0007_ProductionPlan.cs:2407 | if (fps.Name == "spdLine") ▸ if (siLine != null && siMain.IsLock(SpdSheet.shtLine) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_item_id"] | strITEM_ID | 행/컬럼 값 대입 |  |  |  |
| AC-e16f65c9 | (진입점 미연결) | SSP0007_ProductionPlan.cs:2408 | if (fps.Name == "spdLine") ▸ if (siLine != null && siMain.IsLock(SpdSheet.shtLine) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_line_id"] | strLINE_ID | 행/컬럼 값 대입 |  |  |  |
| AC-7bf694ad | (진입점 미연결) | SSP0007_ProductionPlan.cs:2409 | if (fps.Name == "spdLine") ▸ if (siLine != null && siMain.IsLock(SpdSheet.shtLine) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_operation_id"] | strOPERATION_ID | 행/컬럼 값 대입 |  |  |  |
| AC-4948419b | (진입점 미연결) | SSP0007_ProductionPlan.cs:2410 | if (fps.Name == "spdLine") ▸ if (siLine != null && siMain.IsLock(SpdSheet.shtLine) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_measure"] | strMEASURE | 행/컬럼 값 대입 |  |  |  |
| AC-c5c8dad2 | (진입점 미연결) | SSP0007_ProductionPlan.cs:2411 | if (fps.Name == "spdLine") ▸ if (siLine != null && siMain.IsLock(SpdSheet.shtLine) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_yyyymmdd"] | strYYYYMMDD | 행/컬럼 값 대입 |  |  |  |
| AC-bb365db7 | (진입점 미연결) | SSP0007_ProductionPlan.cs:2412 | if (fps.Name == "spdLine") ▸ if (siLine != null && siMain.IsLock(SpdSheet.shtLine) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_qty"] | strQTY | 행/컬럼 값 대입 |  |  |  |
| AC-5cf44c4a | (진입점 미연결) | SSP0007_ProductionPlan.cs:2413 | if (fps.Name == "spdLine") ▸ if (siLine != null && siMain.IsLock(SpdSheet.shtLine) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_user_id"] | strUSER_ID | 행/컬럼 값 대입 |  |  |  |
| AC-02236d48 | (진입점 미연결) | SSP0007_ProductionPlan.cs:2414 | if (fps.Name == "spdLine") ▸ if (siLine != null && siMain.IsLock(SpdSheet.shtLine) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_fix"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-408b11cd | (진입점 미연결) | SSP0007_ProductionPlan.cs:2416 | if (fps.Name == "spdLine") ▸ if (siLine != null && siMain.IsLock(SpdSheet.shtLine) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_program_id"] | "SSP0007" | 행/컬럼 값 대입 |  |  |  |
| AC-26254a31 | (진입점 미연결) | SSP0007_ProductionPlan.cs:2417 | if (fps.Name == "spdLine") ▸ if (siLine != null && siMain.IsLock(SpdSheet.shtLine) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-40741b18 | (진입점 미연결) | SSP0007_ProductionPlan.cs:2419 | if (fps.Name == "spdLine") ▸ if (siLine != null && siMain.IsLock(SpdSheet.shtLine) == false) ▸ if (iCount > 0) ▸ try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-8a490de9 | (진입점 미연결) | SSP0007_ProductionPlan.cs:2424 | if (fps.Name == "spdLine") ▸ if (siLine != null && siMain.IsLock(SpdSheet.shtLine) == false) ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { response.DataSet.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8c998ec5 | (진입점 미연결) | SSP0007_ProductionPlan.cs:2443 | if (fps.Name == "spdLine") ▸ if (siLine != null && siMain.IsLock(SpdSheet.shtLine) == false) ▸ if (iCount > 0) ▸ try ▸ else of (response.Dat… | MESSAGE | MessageHelper.GMessageBox | ("MSG00284", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-2b3c82bc | (진입점 미연결) | SSP0007_ProductionPlan.cs:2453 | if (fps.Name == "spdLine") ▸ if (siLine != null && siMain.IsLock(SpdSheet.shtLine) == false) ▸ if (iCount > 0) ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SSP0007_ProductionPlan.Set_FPOperationColor

진입점: EditButton [if (fps != null) ▸ if (fps.Name == "spdLine") ▸ if (fps.ActiveSheet.Columns.Get(xCol1).Visible == false)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-df90e92e | EditButton [if (fps != null) ▸ if (fps.Name == "spdLine") ▸ … | SSP0007_ProductionPlan.cs:2481 | if (siLine.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9c522e7b | EditButton [if (fps != null) ▸ if (fps.Name == "spdLine") ▸ … | SSP0007_ProductionPlan.cs:2482 |  | FLAG | siLine | GetSheetInfo(spdLine.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-023d111c | EditButton [if (fps != null) ▸ if (fps.Name == "spdLine") ▸ … | SSP0007_ProductionPlan.cs:2520 | for (i < spdLine.ActiveSheet.RowCount) ▸ if (spdLine.ActiveSheet.GetText(i, siLine.GetColumnIndex(DefColumns.MEASURE)).ToString() == "PROD_P… | DATA_OP | dtPlanType.Select | ("CODE='FN'") | 데이터 객체 조작/조회 |  |  |  |
| AC-e810206c | EditButton [if (fps != null) ▸ if (fps.Name == "spdLine") ▸ … | SSP0007_ProductionPlan.cs:2549 | for (i < spdLine.ActiveSheet.RowCount) ▸ if (spdLine.ActiveSheet.GetText(i, siLine.GetColumnIndex(DefColumns.MEASURE)).ToString() == "PROD_P… | GRID_STYLE | siLine.SetBGColor2 | (nEditableRow, nStartEditIdx, nEditableRow, siLine.ActiveSheet.ColumnCount - 1, Color.From… | 그리드 표시 설정 |  |  |  |
| AC-e6c8c9dd | EditButton [if (fps != null) ▸ if (fps.Name == "spdLine") ▸ … | SSP0007_ProductionPlan.cs:2559 | for (i < spdLine.ActiveSheet.RowCount) ▸ for (j < siLine.ActiveSheet.ColumnCount) ▸ if (siLine.GetColumnTag(j).IndexOf("M_") == 0) | GRID_LOCK | siLine.LockRange | (0, j, siLine.ActiveSheet.RowCount - 1, j, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-e0e7dc32 | EditButton [if (fps != null) ▸ if (fps.Name == "spdLine") ▸ … | SSP0007_ProductionPlan.cs:2565 |  | UI_MISC | spdLine.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## SSP0007_ProductionPlan.Set_OnHandEOH

진입점: this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ if (showMsg) ▸ try] / FindButton [try] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2664b0c1 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SSP0007_ProductionPlan.cs:1640 | if (!this.CanModelChange) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0864a6a3 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SSP0007_ProductionPlan.cs:1650 | if (ds == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-bb3f3f61 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SSP0007_ProductionPlan.cs:1664 | try ▸ for (nCol < dt.Columns.Count) ▸ if (dt.Columns[nCol].ColumnName.IndexOf("M_") == 0) | DATA_OP | listMonth.Add | (nCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-715c7569 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SSP0007_ProductionPlan.cs:1668 | try ▸ for (nCol < dt.Columns.Count) ▸ if (dt.Columns[nCol].ColumnName.IndexOf("W_") == 0) | DATA_OP | listWeek.Add | (nCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-30f2bb61 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SSP0007_ProductionPlan.cs:1742 | try ▸ for (i < dt.Rows.Count) ▸ if (dt.Rows[i][DefColumns.MEASURE].ToString() == "ONHAND_EOH") ▸ for (j < dt.Columns.Count) ▸ if (j == dt.Co… | GRID_SET | dt.Rows[i][nIdxWeek] | boh | 그리드 속성/값 설정 |  |  |  |
| AC-04598f67 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SSP0007_ProductionPlan.cs:1753 | try ▸ for (i < dt.Rows.Count) ▸ if (dt.Rows[i][DefColumns.MEASURE].ToString() == "ONHAND_EOH") ▸ for (j < dt.Columns.Count) ▸ if (j == dt.Co… | GRID_SET | dt.Rows[i][nIdxMonth] | boh | 그리드 속성/값 설정 |  |  |  |
| AC-4d5971dc | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SSP0007_ProductionPlan.cs:1767 | try ▸ for (i < dt.Rows.Count) ▸ if (dt.Rows[i][DefColumns.MEASURE].ToString() == "FORMATION_YIELD") | CALL_EXT | siMain.ActiveSheet.GetViewRowFromModelRow | (i) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a0b48c50 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SSP0007_ProductionPlan.cs:1768 | try ▸ for (i < dt.Rows.Count) ▸ if (dt.Rows[i][DefColumns.MEASURE].ToString() == "FORMATION_YIELD") | CALL_EXT | siMain.SetDecimal | (viewRow, nIdxStart, viewRow, nIdxEnd, 2, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-70778281 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SSP0007_ProductionPlan.cs:1774 | catch ((Exception et)) | THROW | throw et; |  | 예외 발생 |  |  |  |
| AC-de9b6ec0 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SSP0007_ProductionPlan.cs:1778 | finally | DATA_OP | dt.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |

## SSP0007_ProductionPlan.Set_OnHandEOH_Parallel

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-84a3262d | (진입점 미연결) | SSP0007_ProductionPlan.cs:1787 | if (!this.CanModelChange) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-bf65e7b5 | (진입점 미연결) | SSP0007_ProductionPlan.cs:1797 | if (ds == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3a718e71 | (진입점 미연결) | SSP0007_ProductionPlan.cs:1811 | try ▸ for (nCol < dt.Columns.Count) ▸ if (dt.Columns[nCol].ColumnName.IndexOf("M_") == 0) | DATA_OP | listMonth.Add | (nCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-1161d130 | (진입점 미연결) | SSP0007_ProductionPlan.cs:1815 | try ▸ for (nCol < dt.Columns.Count) ▸ if (dt.Columns[nCol].ColumnName.IndexOf("W_") == 0) | DATA_OP | listWeek.Add | (nCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-9920e668 | (진입점 미연결) | SSP0007_ProductionPlan.cs:1969 | try ▸ for (i < dt.Rows.Count) ▸ if (dt.Rows[i][DefColumns.MEASURE].ToString() == "ONHAND_EOH") ▸ for (j < dt.Columns.Count) ▸ if (dt.Columns… | DATA_OP | dt.Select | (sFilter) | 데이터 객체 조작/조회 |  |  |  |
| AC-a8b02c2d | (진입점 미연결) | SSP0007_ProductionPlan.cs:1998 | try ▸ for (i < dt.Rows.Count) ▸ if (dt.Rows[i][DefColumns.MEASURE].ToString() == "ONHAND_EOH") ▸ for (j < dt.Columns.Count) ▸ if (dt.Columns… | GRID_SET | dt.Rows[i][ColName] | result | 그리드 속성/값 설정 |  |  |  |
| AC-3e7ef2c3 | (진입점 미연결) | SSP0007_ProductionPlan.cs:2008 | try ▸ for (i < dt.Rows.Count) ▸ if (dt.Rows[i][DefColumns.MEASURE].ToString() == "ONHAND_EOH") ▸ for (j < dt.Columns.Count) ▸ if (j == dt.Co… | GRID_SET | dt.Rows[i][nIdxWeek] | boh | 그리드 속성/값 설정 |  |  |  |
| AC-589f2083 | (진입점 미연결) | SSP0007_ProductionPlan.cs:2019 | try ▸ for (i < dt.Rows.Count) ▸ if (dt.Rows[i][DefColumns.MEASURE].ToString() == "ONHAND_EOH") ▸ for (j < dt.Columns.Count) ▸ if (j == dt.Co… | GRID_SET | dt.Rows[i][nIdxMonth] | boh | 그리드 속성/값 설정 |  |  |  |
| AC-3911929c | (진입점 미연결) | SSP0007_ProductionPlan.cs:2033 | try ▸ for (i < dt.Rows.Count) ▸ if (dt.Rows[i][DefColumns.MEASURE].ToString() == "FORMATION_YIELD") | CALL_EXT | siMain.ActiveSheet.GetViewRowFromModelRow | (i) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ef82ebc0 | (진입점 미연결) | SSP0007_ProductionPlan.cs:2034 | try ▸ for (i < dt.Rows.Count) ▸ if (dt.Rows[i][DefColumns.MEASURE].ToString() == "FORMATION_YIELD") | CALL_EXT | siMain.SetDecimal | (viewRow, nIdxStart, viewRow, nIdxEnd, 2, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e7bcef24 | (진입점 미연결) | SSP0007_ProductionPlan.cs:2041 | catch ((Exception et)) | THROW | throw et; |  | 예외 발생 |  |  |  |
| AC-37de3544 | (진입점 미연결) | SSP0007_ProductionPlan.cs:2045 | finally | DATA_OP | dt.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |

## SSP0007_ProductionPlan.SetChangedControl

진입점: this.Load / cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5f6e37a7 | this.Load 외 1 | SSP0007_ProductionPlan.cs:927 | if (pDivisionID == "EE") | FLAG | dtOperationGroup | Data_SCP.Common(Data_SCP.Type.OperationGroupEE, false) | 화면 필드/플래그 변경 |  |  |  |
| AC-3f565d79 | this.Load 외 1 | SSP0007_ProductionPlan.cs:927 | if (pDivisionID == "EE") | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.OperationGroupEE, false) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-af28c5bc | this.Load 외 1 | SSP0007_ProductionPlan.cs:928 | if (pDivisionID == "EE") | FLAG | dtPlantSiteByDivision | Data_SCP.Common(Data_SCP.Type.PlantSiteProdPlanSSP, false, pDivisionID, pOperationGroup) | 화면 필드/플래그 변경 |  |  |  |
| AC-53c41f5d | this.Load 외 1 | SSP0007_ProductionPlan.cs:928 | if (pDivisionID == "EE") | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.PlantSiteProdPlanSSP, false, pDivisionID, pOperationGroup) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-5a539a33 | this.Load 외 1 | SSP0007_ProductionPlan.cs:932 | else of (pDivisionID == "EE") | FLAG | dtOperationGroup | Data_SCP.Common(Data_SCP.Type.OperationGroup, false) | 화면 필드/플래그 변경 |  |  |  |
| AC-f13fd918 | this.Load 외 1 | SSP0007_ProductionPlan.cs:932 | else of (pDivisionID == "EE") | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.OperationGroup, false) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-0176668f | this.Load 외 1 | SSP0007_ProductionPlan.cs:933 | else of (pDivisionID == "EE") | FLAG | dtPlantSiteByDivision | Data.Common(Data.Type.PlantByDivisionOperation, false, pDivisionID, pOperationGroup) ⇒ biz:CommonData.CommonDataList [code=PlantByDivisionOperation] | 화면 필드/플래그 변경 |  |  |  |
| AC-dadb4f17 | this.Load 외 1 | SSP0007_ProductionPlan.cs:933 | else of (pDivisionID == "EE") | COMBO_DATA | Data.Common | (Data.Type.PlantByDivisionOperation, false, pDivisionID, pOperationGroup) ⇒ biz:CommonData.CommonDataList [code=PlantByDivisionOperation] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-5dbdaed2 | this.Load 외 1 | SSP0007_ProductionPlan.cs:935 |  | LIST_REBIND | clsCtrl.setListBox | (dtOperationGroup, cboOperationGroup, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-fba861c3 | this.Load 외 1 | SSP0007_ProductionPlan.cs:939 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlantSiteByDivision, clbPlantSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-941a5955 | this.Load 외 1 | SSP0007_ProductionPlan.cs:943 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | LIST_REBIND | clsCtrl.setListBox | (dtOperationGroup, cboOperationGroup, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-9a640889 | this.Load 외 1 | SSP0007_ProductionPlan.cs:945 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | FLAG | dtPlanDate | Data.Common(Data.Type.PlanDateShip, false, pDivisionID) ⇒ biz:CommonData.CommonDataList [code=PlanDateShip] | 화면 필드/플래그 변경 |  |  |  |
| AC-1ac51849 | this.Load 외 1 | SSP0007_ProductionPlan.cs:945 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | COMBO_DATA | Data.Common | (Data.Type.PlanDateShip, false, pDivisionID) ⇒ biz:CommonData.CommonDataList [code=PlanDateShip] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-2a04a5be | this.Load 외 1 | SSP0007_ProductionPlan.cs:946 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | LIST_REBIND | clsCtrl.setListBox | (dtPlanDate, cboPlanDate, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-e81b8f0c | this.Load 외 1 | SSP0007_ProductionPlan.cs:949 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | FLAG | dtPlanType | Data.Common(Data.Type.PlanTypeShip, false, pDivisionID, pPlanDate) ⇒ biz:CommonData.CommonDataList [code=PlanTypeShip] | 화면 필드/플래그 변경 |  |  |  |
| AC-83d07ce3 | this.Load 외 1 | SSP0007_ProductionPlan.cs:949 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | COMBO_DATA | Data.Common | (Data.Type.PlanTypeShip, false, pDivisionID, pPlanDate) ⇒ biz:CommonData.CommonDataList [code=PlanTypeShip] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ba868023 | this.Load 외 1 | SSP0007_ProductionPlan.cs:950 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | LIST_REBIND | clsCtrl.setListBox | (dtPlanType, cboPlanType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-fb992ec0 | this.Load 외 1 | SSP0007_ProductionPlan.cs:951 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ if (dtPlanType.Rows.Count > 0) | VALUE_SET | cboPlanType.SelectedIndex | dtPlanType.Rows.Count - 1 | 컨트롤 값 설정 |  |  |  |
| AC-947c534e | this.Load 외 1 | SSP0007_ProductionPlan.cs:954 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ if (dtPlanType.Rows.Count > 0) | VALUE_SET | cboPlanType.SelectedIndex | dtPlanType.Rows.Count - 1 | 컨트롤 값 설정 |  |  |  |
| AC-e92f6e17 | this.Load 외 1 | SSP0007_ProductionPlan.cs:957 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | FLAG | dtPlanSeq | Data.Common(Data.Type.PlanSeqShip, false, pDivisionID, pPlanDate, pPlanType) ⇒ biz:CommonData.CommonDataList [code=PlanSeqShip] | 화면 필드/플래그 변경 |  |  |  |
| AC-c734ab53 | this.Load 외 1 | SSP0007_ProductionPlan.cs:957 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | COMBO_DATA | Data.Common | (Data.Type.PlanSeqShip, false, pDivisionID, pPlanDate, pPlanType) ⇒ biz:CommonData.CommonDataList [code=PlanSeqShip] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-6906a846 | this.Load 외 1 | SSP0007_ProductionPlan.cs:958 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | LIST_REBIND | clsCtrl.setListBox | (dtPlanSeq, cboPlanSeq, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-61a825ce | this.Load 외 1 | SSP0007_ProductionPlan.cs:963 | if (siMain != null) | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |
| AC-39bb59cd | this.Load 외 1 | SSP0007_ProductionPlan.cs:964 | if (siLine != null) | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdLine) | 그리드 데이터/선택 비움 |  |  |  |
| AC-ae9bcabc | this.Load 외 1 | SSP0007_ProductionPlan.cs:968 | if (pDivisionID != "EE") | VALUE_CLEAR | clbElectrode.ControlValues | "" | 컨트롤 값 비움 |  |  |  |
| AC-7073529a | this.Load 외 1 | SSP0007_ProductionPlan.cs:969 | if (pDivisionID != "EE") | STATE | clbElectrode.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-80bcc102 | this.Load 외 1 | SSP0007_ProductionPlan.cs:973 | else of (pDivisionID != "EE") | STATE | clbElectrode.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## SSP0007_ProductionPlan.SetChangedPeriod

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-28c940c5 | (진입점 미연결) | SSP0007_ProductionPlan.cs:2782 | if (string.IsNullOrEmpty(strcboPlanDate)) | COMBO_DATA | Data.CallBizCommonData | ("PERIOD_" + value) ⇒ biz:CommonData.CommonDataList [code=PERIOD_{p:value}] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-6eccb3cb | (진입점 미연결) | SSP0007_ProductionPlan.cs:2785 | else of (string.IsNullOrEmpty(strcboPlanDate)) | COMBO_DATA | Data.CallBizCommonData | ("PERIOD2_" + value, strcboPlanDate) ⇒ biz:CommonData.CommonDataList [code=PERIOD2_{p:value}] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c54ffef2 | (진입점 미연결) | SSP0007_ProductionPlan.cs:2788 | if (dt == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-bd9aa42c | (진입점 미연결) | SSP0007_ProductionPlan.cs:2791 | if (dt.Rows.Count > 0) | UI_PROP | drpPeriod.Text1 | dt.Rows[0]["FROM_VALUE"].ToString() | 속성 Text1 설정 |  |  |  |
| AC-a85ec8a7 | (진입점 미연결) | SSP0007_ProductionPlan.cs:2792 | if (dt.Rows.Count > 0) | UI_PROP | drpPeriod.Text2 | dt.Rows[0]["TO_VALUE"].ToString() | 속성 Text2 설정 |  |  |  |

## SSP0007_ProductionPlan.SetDataTableDateColumn

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c7d72521 | (진입점 미연결) | SSP0007_ProductionPlan.cs:496 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) | DATA_OP | dt.Columns.Add | (column) | 데이터 객체 조작/조회 |  |  |  |

## SSP0007_ProductionPlan.SetDataTableQtyData

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1252ebff | (진입점 미연결) | SSP0007_ProductionPlan.cs:514 | for (i < source.Rows.Count) ▸ for (j < source.Columns.Count) ▸ if (columnName.IndexOf("D_") == 0) | GRID_SET | target.Rows[i][columnName] | source.Rows[i][columnName] | 그리드 속성/값 설정 |  |  |  |
| AC-8304fa3b | (진입점 미연결) | SSP0007_ProductionPlan.cs:537 |  | DATA_OP | target.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |

## SSP0007_ProductionPlan.SetLockSumColumn

진입점: EditButton [if (fps != null) ▸ if (fps.Name == "spdLine")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1d22d5fc | EditButton [if (fps != null) ▸ if (fps.Name == "spdLine")] | SSP0007_ProductionPlan.cs:914 | for (iCol <= spreadInfo.GetMaxColumnIndex()) ▸ if (spreadInfo.GetColumnTag(iCol).IndexOf("W_") == 0 \|\| spreadInfo.GetColumnTag(iCol).Index… | GRID_LOCK | spreadInfo.LockRange | (0, iCol, spreadInfo.ActiveSheet.RowCount - 1, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |

## SSP0007_ProductionPlan.SetSpreadColumn

진입점: this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ if (showMsg) ▸ try ▸ if (siMain.GetMaxRowIndex() > 0)] / this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] / this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row>=0) ▸ try] / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (fps.Name == "spdMain") ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / this.cboBucketType.SelectedIndexChanged [if (fps != null) ▸ if (fps.Name == "spdMain")] / this.chkSum.CheckedChanged [if (fps != null) ▸ if (fps.Name == "spdMain")] / FindButt…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6f9e007a | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 7 | SSP0007_ProductionPlan.cs:854 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Daily) ▸ if (siObj.GetColumnTag(iCol).IndexOf("D_") … | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-b7be9649 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 7 | SSP0007_ProductionPlan.cs:859 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Daily) ▸ if (siObj.GetColumnTag(iCol).IndexOf("M_") … | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | chkSum.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-040bc2a8 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 7 | SSP0007_ProductionPlan.cs:866 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Buc… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-5b92c0d8 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 7 | SSP0007_ProductionPlan.cs:870 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Buc… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-2b1e0432 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 7 | SSP0007_ProductionPlan.cs:875 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Buc… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | chkSum.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-df6b34b2 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 7 | SSP0007_ProductionPlan.cs:882 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ else of (cboBucketType.ControlValues =… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-dadac172 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 7 | SSP0007_ProductionPlan.cs:886 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ else of (cboBucketType.ControlValues =… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |

## SSP0007_ProductionPlan.spdLine_CellDoubleClick

진입점: this.spdLine.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7f3fdad1 | this.spdLine.CellDoubleClick | SSP0007_ProductionPlan.cs:2675 |  | CALL_EXT | siLine.SetDblClickColumnShowHide | (sender, e) | ⚠ 의미 확인 필요 |  |  |  |

## SSP0007_ProductionPlan.SpdLine_Changed

진입점: dsdmLine.Changed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-61ae60b7 | dsdmLine.Changed | SSP0007_ProductionPlan.cs:2721 | if (!this.CanModelChange) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e97c6226 | dsdmLine.Changed | SSP0007_ProductionPlan.cs:2730 | if (ds == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3f84e009 | dsdmLine.Changed | SSP0007_ProductionPlan.cs:2738 | try ▸ if (ds == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-467593bd | dsdmLine.Changed | SSP0007_ProductionPlan.cs:2751 | catch ((Exception et)) | THROW | throw et; |  | 예외 발생 |  |  |  |

## SSP0007_ProductionPlan.SpdLine_SelectionChanged

진입점: spdLine.SelectionChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dca30f48 | spdLine.SelectionChanged | SSP0007_ProductionPlan.cs:2711 | try | FLAG | nSelRowOfLine | spdLine.ActiveSheet.ActiveRow.Index | 화면 필드/플래그 변경 |  |  |  |
| AC-cda2dfdd | spdLine.SelectionChanged | SSP0007_ProductionPlan.cs:2712 | try | FLAG | nSelColOfLine | spdLine.ActiveSheet.ActiveColumn.Index | 화면 필드/플래그 변경 |  |  |  |
| AC-b9999791 | spdLine.SelectionChanged | SSP0007_ProductionPlan.cs:2715 | catch ((Exception ex)) | FLAG | nSelRowOfLine | -1 | 화면 필드/플래그 변경 |  |  |  |
| AC-996ce6de | spdLine.SelectionChanged | SSP0007_ProductionPlan.cs:2716 | catch ((Exception ex)) | FLAG | nSelColOfLine | -1 | 화면 필드/플래그 변경 |  |  |  |

## SSP0007_ProductionPlan.SpdLine_TopChange

진입점: this.spdLine.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3bb5e0d0 | this.spdLine.TopChange | SSP0007_ProductionPlan.cs:574 |  | GRID_INIT | siLine.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SSP0007_ProductionPlan.SpdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4b4aac60 | this.spdMain.CellDoubleClick | SSP0007_ProductionPlan.cs:2661 |  | CALL_EXT | siMain.SetDblClickColumnShowHide | (sender, e) | ⚠ 의미 확인 필요 |  |  |  |
| AC-40ac6624 | this.spdMain.CellDoubleClick | SSP0007_ProductionPlan.cs:2664 | if (!e.ColumnHeader && e.Row>=0) | FLAG | nSelRowOfMain | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-5b2dc43c | this.spdMain.CellDoubleClick | SSP0007_ProductionPlan.cs:2665 | if (!e.ColumnHeader && e.Row>=0) | FLAG | nSelColOfMain | e.Column | 화면 필드/플래그 변경 |  |  |  |

## SSP0007_ProductionPlan.SpdMain_TopChange

진입점: this.spdMain.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1be03543 | this.spdMain.TopChange | SSP0007_ProductionPlan.cs:581 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

