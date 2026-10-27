# AS-IS 액션 대조표 — SCP0060

> 원천: `Doc/asisfacts/screens/SCP0060/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 498행 · 메서드 55 · 종류 DATA_OP 156 · RETURN 40 · ENDPOINT 33 · FLAG 31 · CALL_EXT 29 · GRID_INIT 28 · GRID_SET 25 · UI_PROP 23 · UI_MISC 18 · COMBO_DATA 17 · MESSAGE 16 · POPUP 13 · VALUE_SET 12 · LIST_REBIND 12 · GRID_CLEAR 10 · GRID_LOCK 8 · VALIDATE 7 · GRID_STYLE 7 · STATE 4 · GRID_BIND 3 · THROW 3 · STATE_RESET 1 · LIST_CLEAR 1 · VALUE_CLEAR 1 · ⚠ 의미 확인 필요 29


## SCP0060_ProductionPlan_JV.btnCal_Click

진입점: this.btnCal.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ada90d4f | this.btnCal.Click | SCP0060_ProductionPlan_JV.cs:3313 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-5813c361 | this.btnCal.Click | SCP0060_ProductionPlan_JV.cs:3314 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ccd4e489 | this.btnCal.Click | SCP0060_ProductionPlan_JV.cs:3318 |  | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-3e0c15f9 | this.btnCal.Click | SCP0060_ProductionPlan_JV.cs:3318 | if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-64a094cb | this.btnCal.Click | SCP0060_ProductionPlan_JV.cs:3321 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00206") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-1c8b3f25 | this.btnCal.Click | SCP0060_ProductionPlan_JV.cs:3323 | if (MessageHelper.GMessageBox("MSG00206") == DialogResult.No) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0060_ProductionPlan_JV.btnItemId_Click

진입점: this.btnItemId.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-eb53b174 | this.btnItemId.Click | SCP0060_ProductionPlan_JV.cs:785 |  | CALL_EXT | UIUtils.GetAllDivisionCheckedElectrode | (cboDivision) | ⚠ 의미 확인 필요 |  |  |  |
| AC-cccf2f6d | this.btnItemId.Click | SCP0060_ProductionPlan_JV.cs:792 |  | POPUP | new SCM0002_ItembyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-402c7785 | this.btnItemId.Click | SCP0060_ProductionPlan_JV.cs:794 |  | POPUP | popItem.Form_Load | (true, division, sScmSite, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-27f92d8d | this.btnItemId.Click | SCP0060_ProductionPlan_JV.cs:795 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-030344a3 | this.btnItemId.Click | SCP0060_ProductionPlan_JV.cs:796 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-f4d13ebf | this.btnItemId.Click | SCP0060_ProductionPlan_JV.cs:802 | if (popItem.ItemID != "") | VALUE_SET | txtItemId.Text | sItemId | 컨트롤 값 설정 |  |  |  |

## SCP0060_ProductionPlan_JV.btnMeasure_Click

진입점: this.btnMeasure.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fdf6365c | this.btnMeasure.Click | SCP0060_ProductionPlan_JV.cs:821 | if (fps != null) ▸ else of (fps.Name == "spdMain") ▸ else of (fps.Name == "spdLine") | MESSAGE | MessageHelper.GMessageBox | ("MSG00007", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-1967f2ed | this.btnMeasure.Click | SCP0060_ProductionPlan_JV.cs:822 | if (fps != null) ▸ else of (fps.Name == "spdMain") ▸ else of (fps.Name == "spdLine") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-57ba6692 | this.btnMeasure.Click | SCP0060_ProductionPlan_JV.cs:827 | else of (fps != null) | MESSAGE | MessageHelper.GMessageBox | ("MSG00007", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b149d792 | this.btnMeasure.Click | SCP0060_ProductionPlan_JV.cs:828 | else of (fps != null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c8118354 | this.btnMeasure.Click | SCP0060_ProductionPlan_JV.cs:831 |  | POPUP | new SCM0002_TitleSetForm_Popup | ("SCP0060", shtName, false) | 팝업/폼 생성 |  |  |  |
| AC-c0c905f9 | this.btnMeasure.Click | SCP0060_ProductionPlan_JV.cs:832 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-545adbe0 | this.btnMeasure.Click | SCP0060_ProductionPlan_JV.cs:833 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-313b50c9 | this.btnMeasure.Click | SCP0060_ProductionPlan_JV.cs:837 | if (frm.DialogResult == DialogResult.OK) | UI_PROP | this.CanModelChange | false | 속성 CanModelChange 설정 |  |  |  |
| AC-4ddd8e97 | this.btnMeasure.Click | SCP0060_ProductionPlan_JV.cs:847 | if (frm.DialogResult == DialogResult.OK) | UI_PROP | this.CanModelChange | true | 속성 CanModelChange 설정 |  |  |  |

## SCP0060_ProductionPlan_JV.CalculateSum

진입점: this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ if (showMsg) ▸ try ▸ if (p_bucket.Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all))] / dsdmLine.Changed [try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated:] / this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >= 0) ▸ try ▸ for (i < siLine.ActiveSheet.RowCount) ▸ if (mesure == "LINE_TOTAL_LOAD")] / FindButton [try ▸ if (p_bucket.Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all))] / SaveButton [if (fps.Name == "spdLine") ▸ if (siLine != null && s…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f87320cc | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 5 | SCP0060_ProductionPlan_JV.cs:2454 | if (strMeasure == "ONHAND_EOH") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-df7774b4 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 5 | SCP0060_ProductionPlan_JV.cs:2462 | for (nCol < dt.Columns.Count) ▸ if (dt.Columns[nCol].ColumnName.IndexOf("M_") == 0) | DATA_OP | listMonth.Add | (nCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-b2412d65 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 5 | SCP0060_ProductionPlan_JV.cs:2466 | for (nCol < dt.Columns.Count) ▸ if (dt.Columns[nCol].ColumnName.IndexOf("W_") == 0) | DATA_OP | listWeek.Add | (nCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-c888733c | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 5 | SCP0060_ProductionPlan_JV.cs:2511 | for (nCol < dt.Columns.Count) ▸ if (nCol == dt.Columns.Count - 1 \|\| dt.Columns[nCol].ColumnName.IndexOf("W_") == 0) ▸ if (strMeasure == "F… | DATA_OP | dr[nIdxWeek] | weekSum / nCntDayOfWeek | 행/컬럼 값 대입 |  |  |  |
| AC-67d8420c | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 5 | SCP0060_ProductionPlan_JV.cs:2515 | for (nCol < dt.Columns.Count) ▸ if (nCol == dt.Columns.Count - 1 \|\| dt.Columns[nCol].ColumnName.IndexOf("W_") == 0) ▸ else of (strMeasure … | DATA_OP | dr[nIdxWeek] | weekSum | 행/컬럼 값 대입 |  |  |  |
| AC-a8f92343 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 5 | SCP0060_ProductionPlan_JV.cs:2529 | for (nCol < dt.Columns.Count) ▸ if (nCol == dt.Columns.Count - 1 \|\| dt.Columns[nCol].ColumnName.IndexOf("M_") == 0) ▸ if (strMeasure == "F… | DATA_OP | dr[nIdxMonth] | monthSum / nCntDayOfMonth | 행/컬럼 값 대입 |  |  |  |
| AC-e9691567 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 5 | SCP0060_ProductionPlan_JV.cs:2533 | for (nCol < dt.Columns.Count) ▸ if (nCol == dt.Columns.Count - 1 \|\| dt.Columns[nCol].ColumnName.IndexOf("M_") == 0) ▸ else of (strMeasure … | DATA_OP | dr[nIdxMonth] | monthSum | 행/컬럼 값 대입 |  |  |  |
| AC-64eed691 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 5 | SCP0060_ProductionPlan_JV.cs:2542 |  | DATA_OP | dt.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-5459ccb9 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 5 | SCP0060_ProductionPlan_JV.cs:2564 | for (nCol < dt.Columns.Count) ▸ if (dt.Columns[nCol].ColumnName.IndexOf("M_") == 0) | DATA_OP | listMonth.Add | (nCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-d67bd8fc | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 5 | SCP0060_ProductionPlan_JV.cs:2568 | for (nCol < dt.Columns.Count) ▸ if (dt.Columns[nCol].ColumnName.IndexOf("W_") == 0) | DATA_OP | listWeek.Add | (nCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-0bf4ba89 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 5 | SCP0060_ProductionPlan_JV.cs:2629 | for (nRow < dt.Rows.Count) ▸ for (nCol < dt.Columns.Count) ▸ if (nCol == dt.Columns.Count - 1 \|\| dt.Columns[nCol].ColumnName.IndexOf("W_")… | DATA_OP | dr[nIdxWeek] | weekSum / nCntDayOfWeek | 행/컬럼 값 대입 |  |  |  |
| AC-a688aefc | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 5 | SCP0060_ProductionPlan_JV.cs:2651 | for (nRow < dt.Rows.Count) ▸ for (nCol < dt.Columns.Count) ▸ if (nCol == dt.Columns.Count - 1 \|\| dt.Columns[nCol].ColumnName.IndexOf("M_")… | DATA_OP | dr[nIdxMonth] | monthSum / nCntDayOfMonth | 행/컬럼 값 대입 |  |  |  |
| AC-eebfafcc | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 5 | SCP0060_ProductionPlan_JV.cs:2667 |  | DATA_OP | dt.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |

## SCP0060_ProductionPlan_JV.cboBucketType_SelectedIndexChanged

진입점: this.cboBucketType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8ee80c6a | this.cboBucketType.SelectedIndexChanged | SCP0060_ProductionPlan_JV.cs:871 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ else of (chkAll.Checked) | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |
| AC-3b3b6e1f | this.cboBucketType.SelectedIndexChanged | SCP0060_ProductionPlan_JV.cs:872 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ else of (chkAll.Checked) | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdLine) | 그리드 데이터/선택 비움 |  |  |  |

## SCP0060_ProductionPlan_JV.CboOperationGroup_SelectedIndexChanged

진입점: cboOperationGroup.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fff5dbb9 | cboOperationGroup.SelectedIndexChanged | SCP0060_ProductionPlan_JV.cs:3015 | if (!division.Substring(0, 2).Equals("EE")) | CALL_EXT | dic_JV_Plant.TryGetValue | (division, out get_JV_Value) | ⚠ 의미 확인 필요 |  |  |  |
| AC-1030ee9c | cboOperationGroup.SelectedIndexChanged | SCP0060_ProductionPlan_JV.cs:3020 | if (!division.Substring(0, 2).Equals("EE")) ▸ if (get_JV_Value != "") | FLAG | dtPlantSiteByDivision | Data.Common(Data.Type.PlantByDivisionOperation, false, division, pOperationGroup, "JV Plan… ⇒ biz:CommonData.CommonDataList [code=PlantByDivisionOperation] | 화면 필드/플래그 변경 |  |  |  |
| AC-e86de80d | cboOperationGroup.SelectedIndexChanged | SCP0060_ProductionPlan_JV.cs:3020 | if (!division.Substring(0, 2).Equals("EE")) ▸ if (get_JV_Value != "") | COMBO_DATA | Data.Common | (Data.Type.PlantByDivisionOperation, false, division, pOperationGroup, "JV Planner", get_J… ⇒ biz:CommonData.CommonDataList [code=PlantByDivisionOperation] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ee2c0da0 | cboOperationGroup.SelectedIndexChanged | SCP0060_ProductionPlan_JV.cs:3024 | if (!division.Substring(0, 2).Equals("EE")) ▸ else of (get_JV_Value != "") | FLAG | dtPlantSiteByDivision | Data.Common(Data.Type.PlantByDivisionOperation, false, "9999!!!!", pOperationGroup, "JV Pl… ⇒ biz:CommonData.CommonDataList [code=PlantByDivisionOperation] | 화면 필드/플래그 변경 |  |  |  |
| AC-fe210491 | cboOperationGroup.SelectedIndexChanged | SCP0060_ProductionPlan_JV.cs:3024 | if (!division.Substring(0, 2).Equals("EE")) ▸ else of (get_JV_Value != "") | COMBO_DATA | Data.Common | (Data.Type.PlantByDivisionOperation, false, "9999!!!!", pOperationGroup, "JV Planner", get… ⇒ biz:CommonData.CommonDataList [code=PlantByDivisionOperation] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-b4db6491 | cboOperationGroup.SelectedIndexChanged | SCP0060_ProductionPlan_JV.cs:3032 | else of (!division.Substring(0, 2).Equals("EE")) | CALL_EXT | dic_JV_Plant.TryGetValue | (division, out get_JV_Value) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ec3b1727 | cboOperationGroup.SelectedIndexChanged | SCP0060_ProductionPlan_JV.cs:3046 | else of (!division.Substring(0, 2).Equals("EE")) ▸ if (get_JV_Value != "") | FLAG | dtPlantSiteByDivision | Data_SCP.Common(Data_SCP.Type.PlantSiteProdPlan, false, division, pOperationGroup, "JV Pla… | 화면 필드/플래그 변경 |  |  |  |
| AC-eee7fe97 | cboOperationGroup.SelectedIndexChanged | SCP0060_ProductionPlan_JV.cs:3046 | else of (!division.Substring(0, 2).Equals("EE")) ▸ if (get_JV_Value != "") | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.PlantSiteProdPlan, false, division, pOperationGroup, "JV Planner", get_JV_V… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-8ae48344 | cboOperationGroup.SelectedIndexChanged | SCP0060_ProductionPlan_JV.cs:3050 | else of (!division.Substring(0, 2).Equals("EE")) ▸ else of (get_JV_Value != "") | FLAG | dtPlantSiteByDivision | Data_SCP.Common(Data_SCP.Type.PlantSiteProdPlan, false, division, pOperationGroup, "JV Pla… | 화면 필드/플래그 변경 |  |  |  |
| AC-45066af7 | cboOperationGroup.SelectedIndexChanged | SCP0060_ProductionPlan_JV.cs:3050 | else of (!division.Substring(0, 2).Equals("EE")) ▸ else of (get_JV_Value != "") | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.PlantSiteProdPlan, false, division, pOperationGroup, "JV Planner", "9999!!!… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-26ca5c44 | cboOperationGroup.SelectedIndexChanged | SCP0060_ProductionPlan_JV.cs:3054 | if (dtPlantSiteByDivision.Rows.Count < 1) | UI_PROP | clbPlantSite.ALL_VIEW | false | 속성 ALL_VIEW 설정 |  |  |  |
| AC-4a16f8ec | cboOperationGroup.SelectedIndexChanged | SCP0060_ProductionPlan_JV.cs:3055 | else of (dtPlantSiteByDivision.Rows.Count < 1) | UI_PROP | clbPlantSite.ALL_VIEW | true | 속성 ALL_VIEW 설정 |  |  |  |
| AC-3b779f74 | cboOperationGroup.SelectedIndexChanged | SCP0060_ProductionPlan_JV.cs:3057 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlantSiteByDivision, clbPlantSite, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0060_ProductionPlan_JV.CboPlanDate_SelectedIndexChanged

진입점: cboPlanDate.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-56609c68 | cboPlanDate.SelectedIndexChanged | SCP0060_ProductionPlan_JV.cs:3065 |  | FLAG | dtPlanType | Data.Common(Data.Type.PlanType, false, division, pPlanDate) ⇒ biz:CommonData.CommonDataList [code=PlanType] | 화면 필드/플래그 변경 |  |  |  |
| AC-b743c540 | cboPlanDate.SelectedIndexChanged | SCP0060_ProductionPlan_JV.cs:3065 |  | COMBO_DATA | Data.Common | (Data.Type.PlanType, false, division, pPlanDate) ⇒ biz:CommonData.CommonDataList [code=PlanType] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-e2a2d2d1 | cboPlanDate.SelectedIndexChanged | SCP0060_ProductionPlan_JV.cs:3066 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanType, cboPlanType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-2ad80792 | cboPlanDate.SelectedIndexChanged | SCP0060_ProductionPlan_JV.cs:3067 |  | VALUE_SET | cboPlanType.SelectedIndex | dtPlanType.Rows.Count - 1 | 컨트롤 값 설정 |  |  |  |
| AC-f397c2c6 | cboPlanDate.SelectedIndexChanged | SCP0060_ProductionPlan_JV.cs:3070 |  | VALUE_SET | drpPeriod.InitValue | GetDayRange() | 컨트롤 값 설정 |  |  |  |
| AC-b8818132 | cboPlanDate.SelectedIndexChanged | SCP0060_ProductionPlan_JV.cs:3075 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |
| AC-cd72c0e7 | cboPlanDate.SelectedIndexChanged | SCP0060_ProductionPlan_JV.cs:3076 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdLine) | 그리드 데이터/선택 비움 |  |  |  |

## SCP0060_ProductionPlan_JV.CboPlanSeq_SelectedIndexChanged

진입점: cboPlanSeq.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2622375b | cboPlanSeq.SelectedIndexChanged | SCP0060_ProductionPlan_JV.cs:3102 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |
| AC-2522544e | cboPlanSeq.SelectedIndexChanged | SCP0060_ProductionPlan_JV.cs:3103 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdLine) | 그리드 데이터/선택 비움 |  |  |  |

## SCP0060_ProductionPlan_JV.CboPlanType_SelectedIndexChanged

진입점: cboPlanType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-97cb2f80 | cboPlanType.SelectedIndexChanged | SCP0060_ProductionPlan_JV.cs:3091 |  | FLAG | dtPlanSeq | Data.Common(Data.Type.PlanSeq, false, division, pPlanDate, pPlanType) ⇒ biz:CommonData.CommonDataList [code=PlanSeq] | 화면 필드/플래그 변경 |  |  |  |
| AC-a81cbe1b | cboPlanType.SelectedIndexChanged | SCP0060_ProductionPlan_JV.cs:3091 |  | COMBO_DATA | Data.Common | (Data.Type.PlanSeq, false, division, pPlanDate, pPlanType) ⇒ biz:CommonData.CommonDataList [code=PlanSeq] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-26b1f816 | cboPlanType.SelectedIndexChanged | SCP0060_ProductionPlan_JV.cs:3092 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanSeq, cboPlanSeq, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-eb98fb52 | cboPlanType.SelectedIndexChanged | SCP0060_ProductionPlan_JV.cs:3093 |  | VALUE_SET | cboPlanSeq.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-6f461eaa | cboPlanType.SelectedIndexChanged | SCP0060_ProductionPlan_JV.cs:3095 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |
| AC-17e267ce | cboPlanType.SelectedIndexChanged | SCP0060_ProductionPlan_JV.cs:3096 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdLine) | 그리드 데이터/선택 비움 |  |  |  |

## SCP0060_ProductionPlan_JV.ClearEventInvocations

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9ba5e24f | (진입점 미연결) | SCP0060_ProductionPlan_JV.cs:3142 | if (fi == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5afbd0fa | (진입점 미연결) | SCP0060_ProductionPlan_JV.cs:3143 |  | GRID_SET | fi.SetValue | (obj, null) | 그리드 값 설정 |  |  |  |

## SCP0060_ProductionPlan_JV.ClearUsrCheckedList

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3392049c | (진입점 미연결) | SCP0060_ProductionPlan_JV.cs:214 | if (dt != null) | STATE_RESET | dt.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-ff3a07c1 | (진입점 미연결) | SCP0060_ProductionPlan_JV.cs:215 | if (dt != null) | LIST_REBIND | clsCtrl.setListBox | (dt, control, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0060_ProductionPlan_JV.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f45b23e4 | this.Load | SCP0060_ProductionPlan_JV.cs:268 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 3, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-fb9ead49 | this.Load | SCP0060_ProductionPlan_JV.cs:269 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, 0) | 화면 필드/플래그 변경 |  |  |  |
| AC-3c304e87 | this.Load | SCP0060_ProductionPlan_JV.cs:271 |  | GRID_INIT | this.AddSheet | (spdLine, SpdSheet.shtLine, SpdSheet.shtLine, 3, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-54d46dd2 | this.Load | SCP0060_ProductionPlan_JV.cs:272 |  | FLAG | siLine | GetSheetInfo(spdLine.Name, 0) | 화면 필드/플래그 변경 |  |  |  |
| AC-ffaeba53 | this.Load | SCP0060_ProductionPlan_JV.cs:275 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0060_ProductionPlan_JV.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5e189686 | this.Load | SCP0060_ProductionPlan_JV.cs:202 |  | UI_PROP | usrConditionPanel1.Height | 105 | 속성 Height 설정 |  |  |  |
| AC-8887559a | this.Load | SCP0060_ProductionPlan_JV.cs:203 |  | VALUE_SET | cboBucketType.ControlValues | BucketType.Weekly | 컨트롤 값 설정 |  |  |  |
| AC-684bb234 | this.Load | SCP0060_ProductionPlan_JV.cs:204 |  | VALUE_SET | chkSum.Checked | false | 컨트롤 값 설정 |  |  |  |

## SCP0060_ProductionPlan_JV.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6d8b119c | Dispose | SCP0060_ProductionPlan_JV.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0060_ProductionPlan_JV.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ec02473e | EditButton | SCP0060_ProductionPlan_JV.cs:667 | if (fps != null) ▸ if (fps.Name == "spdMain") | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-daf6ba1d | EditButton | SCP0060_ProductionPlan_JV.cs:668 | if (fps != null) ▸ if (fps.Name == "spdMain") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ad479669 | EditButton | SCP0060_ProductionPlan_JV.cs:676 | if (fps != null) ▸ if (fps.Name == "spdLine") | FLAG | siLine | GetSheetInfo(spdLine.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-cd3df672 | EditButton | SCP0060_ProductionPlan_JV.cs:677 | if (fps != null) ▸ if (fps.Name == "spdLine") | GRID_LOCK | siLine.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-bd89d9c0 | EditButton | SCP0060_ProductionPlan_JV.cs:681 | if (fps != null) ▸ if (fps.Name == "spdLine") | CALL_EXT | fps.ActiveSheet.GetColumnFromTag | (null, CAppSetting.StringAction) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f7853365 | EditButton | SCP0060_ProductionPlan_JV.cs:682 | if (fps != null) ▸ if (fps.Name == "spdLine") | CALL_EXT | fps.ActiveSheet.Columns.Get | (xCol1) | ⚠ 의미 확인 필요 |  |  |  |
| AC-48fd44c9 | EditButton | SCP0060_ProductionPlan_JV.cs:684 | if (fps != null) ▸ if (fps.Name == "spdLine") ▸ if (fps.ActiveSheet.Columns.Get(xCol1).Visible == true) | VALUE_SET | cboBucketType.ControlValues | BucketType.Daily | 컨트롤 값 설정 |  |  |  |
| AC-b5d81986 | EditButton | SCP0060_ProductionPlan_JV.cs:687 | if (fps != null) ▸ if (fps.Name == "spdLine") | GRID_LOCK | siLine.LockRange | (0, 0, siLine.ActiveSheet.RowCount - 1, siLine.ActiveSheet.ColumnCount - 1, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-4afa5684 | EditButton | SCP0060_ProductionPlan_JV.cs:690 | if (fps != null) ▸ if (fps.Name == "spdLine") | CALL_EXT | fps.ActiveSheet.Columns.Get | (xCol1) | ⚠ 의미 확인 필요 |  |  |  |
| AC-bda60978 | EditButton | SCP0060_ProductionPlan_JV.cs:694 | if (fps != null) ▸ if (fps.Name == "spdLine") ▸ if (fps.ActiveSheet.Columns.Get(xCol1).Visible == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b907393c | EditButton | SCP0060_ProductionPlan_JV.cs:733 | if (fps != null) ▸ if (fps.Name == "spdLine") ▸ for (i < spdLine.ActiveSheet.RowCount) ▸ if (spdLine.ActiveSheet.GetText(i, siLine.GetColumn… | DATA_OP | dtPlanType.Select | ("CODE='FN'") | 데이터 객체 조작/조회 |  |  |  |
| AC-77639072 | EditButton | SCP0060_ProductionPlan_JV.cs:767 | if (fps != null) ▸ if (fps.Name == "spdLine") ▸ for (i < spdLine.ActiveSheet.RowCount) ▸ if (spdLine.ActiveSheet.GetText(i, siLine.GetColumn… | GRID_LOCK | siLine.LockRange | (nEditableRow, nStartEditIdx, nEditableRow, siLine.ActiveSheet.ColumnCount - 1, false) | 그리드 편집 잠금/해제 |  |  |  |

## SCP0060_ProductionPlan_JV.FindButton

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-497e3d2e | FindButton | SCP0060_ProductionPlan_JV.cs:628 | if (checkPlantSite == 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00352") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d24a9cb5 | FindButton | SCP0060_ProductionPlan_JV.cs:629 | if (checkPlantSite == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6b137fdc | FindButton | SCP0060_ProductionPlan_JV.cs:641 | if (strValue == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00352") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d5cd7ef7 | FindButton | SCP0060_ProductionPlan_JV.cs:642 | if (strValue == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-724ae7b2 | FindButton | SCP0060_ProductionPlan_JV.cs:645 |  | FLAG | this.nSelColOfMain | -1 | 화면 필드/플래그 변경 |  |  |  |
| AC-d40c7b8f | FindButton | SCP0060_ProductionPlan_JV.cs:646 |  | FLAG | this.nSelRowOfMain | -1 | 화면 필드/플래그 변경 |  |  |  |

## SCP0060_ProductionPlan_JV.FindData_Division

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e52ac9d0 | this.Load | SCP0060_ProductionPlan_JV.cs:3487 |  | STATE | clbPlantSite.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-76b59eaa | this.Load | SCP0060_ProductionPlan_JV.cs:3490 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SystemMgmt.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a26033ce | this.Load | SCP0060_ProductionPlan_JV.cs:3494 | lambda | ENDPOINT | new FoxDataRequest | ("SystemManager.UP_FX_GetUserGroupAuthExtentionList") ⇒ SystemManager.UP_FX_GetUserGroupAuthExtentionList | 엔드포인트 요청 생성 |  |  |  |
| AC-37640466 | this.Load | SCP0060_ProductionPlan_JV.cs:3496 | lambda | DATA_OP | request.Parameters["GroupID"] | "JV Planner" | 행/컬럼 값 대입 |  |  |  |
| AC-ac5f71a7 | this.Load | SCP0060_ProductionPlan_JV.cs:3497 | lambda | DATA_OP | request.Parameters["UserID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-be999b64 | this.Load | SCP0060_ProductionPlan_JV.cs:3498 | lambda | DATA_OP | request.Parameters["AuthType"] | "J" | 행/컬럼 값 대입 |  |  |  |
| AC-8373e942 | this.Load | SCP0060_ProductionPlan_JV.cs:3499 | lambda | DATA_OP | request.Parameters["DivisionID"] | string.Empty | 행/컬럼 값 대입 |  |  |  |
| AC-52087989 | this.Load | SCP0060_ProductionPlan_JV.cs:3500 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-e17368ab | this.Load | SCP0060_ProductionPlan_JV.cs:3502 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-41bd383f | this.Load | SCP0060_ProductionPlan_JV.cs:3511 | for (i < ds.Tables[0].Rows.Count) | DATA_OP | dic_JV_Plant.Add | (Code, JV_PLANT_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-2034241d | this.Load | SCP0060_ProductionPlan_JV.cs:3513 |  | STATE | clbPlantSite.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## SCP0060_ProductionPlan_JV.FindData_Line

진입점: this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ if (showMsg) ▸ try ▸ if (this.nSelRowOfMain >= 0 && isReload)] / this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >= 0)] / FindButton [try ▸ if (this.nSelRowOfMain >= 0 && isReload)] / SaveButton [if (fps.Name == "spdLine") ▸ if (siLine != null && siMain.IsLock(SpdSheet.shtLine) == false) ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ if (showMsg) ▸ try ▸ if (this.nSel…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3e9376ef | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 4 | SCP0060_ProductionPlan_JV.cs:1573 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-6ac96eb0 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 4 | SCP0060_ProductionPlan_JV.cs:1609 | try | UI_PROP | proxyPivot.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-c3035828 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 4 | SCP0060_ProductionPlan_JV.cs:1610 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-f6fcbe2c | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 4 | SCP0060_ProductionPlan_JV.cs:1611 | try | ENDPOINT | proxyPivot.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, GSCM_SCP_ANALYS… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-ec17e058 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 4 | SCP0060_ProductionPlan_JV.cs:1614 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0011_GET_PRODUCTION_PLAN_LINE") ⇒ SCP.SCP0011_GET_PRODUCTION_PLAN_LINE | 엔드포인트 요청 생성 |  |  |  |
| AC-8beb6a5d | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 4 | SCP0060_ProductionPlan_JV.cs:1615 | try ▸ lambda | UI_PROP | req.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-a31e70b9 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 4 | SCP0060_ProductionPlan_JV.cs:1616 | try ▸ lambda | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-f9eb6dcc | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 4 | SCP0060_ProductionPlan_JV.cs:1617 | try ▸ lambda | DATA_OP | req.Parameters["p_operation_group"] | p_operation_group | 행/컬럼 값 대입 |  |  |  |
| AC-49f6413f | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 4 | SCP0060_ProductionPlan_JV.cs:1618 | try ▸ lambda | DATA_OP | req.Parameters["p_scm_site_id"] | p_scm_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-21e38fa9 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 4 | SCP0060_ProductionPlan_JV.cs:1619 | try ▸ lambda | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-0d3d47f2 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 4 | SCP0060_ProductionPlan_JV.cs:1620 | try ▸ lambda | DATA_OP | req.Parameters["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-861d3aa2 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 4 | SCP0060_ProductionPlan_JV.cs:1621 | try ▸ lambda | DATA_OP | req.Parameters["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-08ff597c | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 4 | SCP0060_ProductionPlan_JV.cs:1622 | try ▸ lambda | DATA_OP | req.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-c9210dfd | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 4 | SCP0060_ProductionPlan_JV.cs:1623 | try ▸ lambda | DATA_OP | req.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-33e8e290 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 4 | SCP0060_ProductionPlan_JV.cs:1624 | try ▸ lambda | DATA_OP | req.Parameters["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-32794657 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 4 | SCP0060_ProductionPlan_JV.cs:1625 | try ▸ lambda | DATA_OP | req.Parameters["p_program_id"] | p_program_id | 행/컬럼 값 대입 |  |  |  |
| AC-35b7b525 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 4 | SCP0060_ProductionPlan_JV.cs:1626 | try ▸ lambda | DATA_OP | req.Parameters["p_sheet_name"] | p_sheet_name | 행/컬럼 값 대입 |  |  |  |
| AC-89119acb | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 4 | SCP0060_ProductionPlan_JV.cs:1627 | try ▸ lambda | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-50371cf7 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 4 | SCP0060_ProductionPlan_JV.cs:1628 | try ▸ lambda | DATA_OP | req.Parameters["p_electrode_type"] | p_electrode_type | 행/컬럼 값 대입 |  |  |  |
| AC-d0062bbc | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 4 | SCP0060_ProductionPlan_JV.cs:1629 | try ▸ lambda | DATA_OP | req.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-67ff452b | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 4 | SCP0060_ProductionPlan_JV.cs:1630 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-12cf8620 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 4 | SCP0060_ProductionPlan_JV.cs:1631 | try ▸ lambda | RETURN | return res.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-a6843672 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 4 | SCP0060_ProductionPlan_JV.cs:1644 | try | GRID_BIND | siLine.Query | (dsBinding) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-463720ad | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 4 | SCP0060_ProductionPlan_JV.cs:1646 | try | GRID_LOCK | siLine.LockColumn | (0, siLine.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-d146ca8e | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 4 | SCP0060_ProductionPlan_JV.cs:1648 | try | UI_MISC | SetSearchCount | (dsBinding) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-ab456f2e | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 4 | SCP0060_ProductionPlan_JV.cs:1653 | try | GRID_INIT | siLine.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-00c4fd7c | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 4 | SCP0060_ProductionPlan_JV.cs:1664 | try ▸ for (i < siLine.ActiveSheet.RowCount) ▸ if (mesure == "LINE_TOTAL_LOAD") | CALL_EXT | siLine.SetDecimal | (i, nIdxStart, i, nIdxEnd, 2, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-0b00d762 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 4 | SCP0060_ProductionPlan_JV.cs:1677 | try ▸ for (i < siLine.ActiveSheet.RowCount) ▸ if (mesure == "LINE_TOTAL_LOAD") ▸ for (nCol < siMain.ActiveSheet.ColumnCount) ▸ if (siLine.Ge… | GRID_STYLE | siLine.SetFGColor2 | (i, nCol, i, nCol, ControlColor.MarkedForeColor) | 그리드 표시 설정 |  |  |  |
| AC-6c900ac4 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 4 | SCP0060_ProductionPlan_JV.cs:1681 | try ▸ for (i < siLine.ActiveSheet.RowCount) ▸ if (mesure == "LINE_TOTAL_LOAD") | UI_MISC | spdLine.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-112d42ee | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 4 | SCP0060_ProductionPlan_JV.cs:1705 | try ▸ if (this.nSelRowOfLine >= 0 && isReload) | GRID_STYLE | siLine.ActiveSheet.SetActiveCell | (this.nSelRowOfLine, this.nSelColOfLine) | 그리드 표시 설정 |  |  |  |
| AC-60dd6cb7 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 4 | SCP0060_ProductionPlan_JV.cs:1706 | try ▸ if (this.nSelRowOfLine >= 0 && isReload) | CALL_EXT | spdLine.ShowCell | (0, 0, this.nSelRowOfLine, this.nSelColOfLine, FarPoint.Win.Spread.VerticalPosition.Center… | ⚠ 의미 확인 필요 |  |  |  |
| AC-13efd059 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 4 | SCP0060_ProductionPlan_JV.cs:1709 | try | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-ea4fb607 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 4 | SCP0060_ProductionPlan_JV.cs:1714 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e1ccf164 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 4 | SCP0060_ProductionPlan_JV.cs:1719 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0060_ProductionPlan_JV.FindData_Model

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-53f0569b | (진입점 미연결) | SCP0060_ProductionPlan_JV.cs:1153 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-d1751b0b | (진입점 미연결) | SCP0060_ProductionPlan_JV.cs:1157 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-a7fe6eb6 | (진입점 미연결) | SCP0060_ProductionPlan_JV.cs:1157 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9c7171a5 | (진입점 미연결) | SCP0060_ProductionPlan_JV.cs:1158 | try | VALIDATE | DateUtil.Check_PeriodDate | (drpPeriod) | 프레임워크 검증 |  |  |  |
| AC-95e2a6b1 | (진입점 미연결) | SCP0060_ProductionPlan_JV.cs:1158 | try ▸ if (!DateUtil.Check_PeriodDate(drpPeriod)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-aa12b0dd | (진입점 미연결) | SCP0060_ProductionPlan_JV.cs:1162 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-13f46066 | (진입점 미연결) | SCP0060_ProductionPlan_JV.cs:1190 | try | UI_PROP | proxyPivot.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-8449392a | (진입점 미연결) | SCP0060_ProductionPlan_JV.cs:1192 | try | ENDPOINT | proxyPivot.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, GSCM_SCP_ANALYS… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-7aa5989c | (진입점 미연결) | SCP0060_ProductionPlan_JV.cs:1195 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0011_GET_PRODUCTION_PLAN_MODEL") ⇒ SCP.SCP0011_GET_PRODUCTION_PLAN_MODEL | 엔드포인트 요청 생성 |  |  |  |
| AC-d47c8549 | (진입점 미연결) | SCP0060_ProductionPlan_JV.cs:1197 | try ▸ lambda | UI_PROP | req.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-8a16ee57 | (진입점 미연결) | SCP0060_ProductionPlan_JV.cs:1198 | try ▸ lambda | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-b6b7349a | (진입점 미연결) | SCP0060_ProductionPlan_JV.cs:1199 | try ▸ lambda | DATA_OP | req.Parameters["p_operation_group"] | p_operation_group | 행/컬럼 값 대입 |  |  |  |
| AC-97ec8b44 | (진입점 미연결) | SCP0060_ProductionPlan_JV.cs:1200 | try ▸ lambda | DATA_OP | req.Parameters["p_scm_site_id"] | p_scm_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-a7a2bda4 | (진입점 미연결) | SCP0060_ProductionPlan_JV.cs:1201 | try ▸ lambda | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-ce2cec41 | (진입점 미연결) | SCP0060_ProductionPlan_JV.cs:1202 | try ▸ lambda | DATA_OP | req.Parameters["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-387fdeb1 | (진입점 미연결) | SCP0060_ProductionPlan_JV.cs:1203 | try ▸ lambda | DATA_OP | req.Parameters["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-4d45414e | (진입점 미연결) | SCP0060_ProductionPlan_JV.cs:1204 | try ▸ lambda | DATA_OP | req.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-e54df3ff | (진입점 미연결) | SCP0060_ProductionPlan_JV.cs:1205 | try ▸ lambda | DATA_OP | req.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-8d21294a | (진입점 미연결) | SCP0060_ProductionPlan_JV.cs:1206 | try ▸ lambda | DATA_OP | req.Parameters["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-bff7fdbd | (진입점 미연결) | SCP0060_ProductionPlan_JV.cs:1207 | try ▸ lambda | DATA_OP | req.Parameters["p_program_id"] | p_program_id | 행/컬럼 값 대입 |  |  |  |
| AC-2f091210 | (진입점 미연결) | SCP0060_ProductionPlan_JV.cs:1208 | try ▸ lambda | DATA_OP | req.Parameters["p_sheet_name"] | p_sheet_name | 행/컬럼 값 대입 |  |  |  |
| AC-8827eba1 | (진입점 미연결) | SCP0060_ProductionPlan_JV.cs:1209 | try ▸ lambda | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-20971940 | (진입점 미연결) | SCP0060_ProductionPlan_JV.cs:1210 | try ▸ lambda | DATA_OP | req.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-dfbaecf0 | (진입점 미연결) | SCP0060_ProductionPlan_JV.cs:1211 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-65181f97 | (진입점 미연결) | SCP0060_ProductionPlan_JV.cs:1212 | try ▸ lambda | RETURN | return res.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-8d85f7e9 | (진입점 미연결) | SCP0060_ProductionPlan_JV.cs:1219 | try | GRID_BIND | siMain.Query | (dsBinding) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-a82f04b7 | (진입점 미연결) | SCP0060_ProductionPlan_JV.cs:1221 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-ab917502 | (진입점 미연결) | SCP0060_ProductionPlan_JV.cs:1222 | try | UI_MISC | SetSearchCount | (dsBinding) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-2e188160 | (진입점 미연결) | SCP0060_ProductionPlan_JV.cs:1232 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-fefd2394 | (진입점 미연결) | SCP0060_ProductionPlan_JV.cs:1245 | try ▸ if (this.nSelRowOfMain >= 0 && isReload) | GRID_STYLE | siMain.ActiveSheet.SetActiveCell | (this.nSelRowOfMain, this.nSelColOfMain) | 그리드 표시 설정 |  |  |  |
| AC-e0a8794c | (진입점 미연결) | SCP0060_ProductionPlan_JV.cs:1246 | try ▸ if (this.nSelRowOfMain >= 0 && isReload) | CALL_EXT | spdMain.ShowCell | (0, 0, this.nSelRowOfMain, this.nSelColOfMain, FarPoint.Win.Spread.VerticalPosition.Center… | ⚠ 의미 확인 필요 |  |  |  |
| AC-8aca90c9 | (진입점 미연결) | SCP0060_ProductionPlan_JV.cs:1252 | try | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-1151d3ab | (진입점 미연결) | SCP0060_ProductionPlan_JV.cs:1257 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6da850e0 | (진입점 미연결) | SCP0060_ProductionPlan_JV.cs:1262 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0060_ProductionPlan_JV.FindData_Model_Parallel

진입점: this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ if (showMsg)] / FindButton / SaveButton [if (fps.Name == "spdLine") ▸ if (siLine != null && siMain.IsLock(SpdSheet.shtLine) == false) ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ if (showMsg)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c23076b0 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0060_ProductionPlan_JV.cs:1271 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-d8dbcb16 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0060_ProductionPlan_JV.cs:1276 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-d4c4753f | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0060_ProductionPlan_JV.cs:1276 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-38100334 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0060_ProductionPlan_JV.cs:1277 | try | VALIDATE | DateUtil.Check_PeriodDate | (drpPeriod) | 프레임워크 검증 |  |  |  |
| AC-715916a8 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0060_ProductionPlan_JV.cs:1277 | try ▸ if (!DateUtil.Check_PeriodDate(drpPeriod)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-03c05021 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0060_ProductionPlan_JV.cs:1281 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-1effd04e | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0060_ProductionPlan_JV.cs:1315 | try ▸ if (p_bucket.ToString().Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all)) | CALL_EXT | DateUtil.MonthDiff | (p_to_yyyymmdd.ToString(), p_from_yyyymmdd.ToString()) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3b72c4dd | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0060_ProductionPlan_JV.cs:1330 | try ▸ if (p_bucket.ToString().Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all)) | CALL_EXT | Parallel.For | (0, (nCnt), (i) => { //for(int i = 0; i < 6; i++) { if (i != nCnt - 1) { string strStartDa… | ⚠ 의미 확인 필요 |  |  |  |
| AC-1f671ae6 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0060_ProductionPlan_JV.cs:1353 | try ▸ if (p_bucket.ToString().Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ if (i != nCnt - 1) | CALL_EXT | FoxUserInfoContext.CreateScope | (new FoxUserInfoContext(p_user_id.ToString())) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b87d8a91 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0060_ProductionPlan_JV.cs:1356 | try ▸ if (p_bucket.ToString().Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ if (i != nCnt - 1) | ENDPOINT | new FoxDataRequest | ("SCP.SCP0011_GET_PRODUCTION_PLAN_MODEL") ⇒ SCP.SCP0011_GET_PRODUCTION_PLAN_MODEL | 엔드포인트 요청 생성 |  |  |  |
| AC-281d0052 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0060_ProductionPlan_JV.cs:1358 | try ▸ if (p_bucket.ToString().Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ if (i != nCnt - 1) | UI_PROP | req.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-85de1420 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0060_ProductionPlan_JV.cs:1359 | try ▸ if (p_bucket.ToString().Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ if (i != nCnt - 1) | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-3701dec6 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0060_ProductionPlan_JV.cs:1360 | try ▸ if (p_bucket.ToString().Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ if (i != nCnt - 1) | DATA_OP | req.Parameters["p_operation_group"] | p_operation_group | 행/컬럼 값 대입 |  |  |  |
| AC-3ac7bc7b | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0060_ProductionPlan_JV.cs:1361 | try ▸ if (p_bucket.ToString().Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ if (i != nCnt - 1) | DATA_OP | req.Parameters["p_scm_site_id"] | p_scm_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-514be1d3 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0060_ProductionPlan_JV.cs:1362 | try ▸ if (p_bucket.ToString().Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ if (i != nCnt - 1) | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-70f2dbb5 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0060_ProductionPlan_JV.cs:1363 | try ▸ if (p_bucket.ToString().Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ if (i != nCnt - 1) | DATA_OP | req.Parameters["p_from_yyyymmdd"] | strStartDate | 행/컬럼 값 대입 |  |  |  |
| AC-a7a739fc | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0060_ProductionPlan_JV.cs:1364 | try ▸ if (p_bucket.ToString().Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ if (i != nCnt - 1) | DATA_OP | req.Parameters["p_to_yyyymmdd"] | strEndDate | 행/컬럼 값 대입 |  |  |  |
| AC-71ee774e | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0060_ProductionPlan_JV.cs:1365 | try ▸ if (p_bucket.ToString().Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ if (i != nCnt - 1) | DATA_OP | req.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-5127427b | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0060_ProductionPlan_JV.cs:1366 | try ▸ if (p_bucket.ToString().Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ if (i != nCnt - 1) | DATA_OP | req.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-47083248 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0060_ProductionPlan_JV.cs:1367 | try ▸ if (p_bucket.ToString().Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ if (i != nCnt - 1) | DATA_OP | req.Parameters["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-f594902b | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0060_ProductionPlan_JV.cs:1368 | try ▸ if (p_bucket.ToString().Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ if (i != nCnt - 1) | DATA_OP | req.Parameters["p_program_id"] | p_program_id | 행/컬럼 값 대입 |  |  |  |
| AC-b74bb8dd | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0060_ProductionPlan_JV.cs:1369 | try ▸ if (p_bucket.ToString().Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ if (i != nCnt - 1) | DATA_OP | req.Parameters["p_sheet_name"] | p_sheet_name | 행/컬럼 값 대입 |  |  |  |
| AC-7826426a | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0060_ProductionPlan_JV.cs:1370 | try ▸ if (p_bucket.ToString().Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ if (i != nCnt - 1) | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-83d9034e | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0060_ProductionPlan_JV.cs:1371 | try ▸ if (p_bucket.ToString().Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ if (i != nCnt - 1) | DATA_OP | req.Parameters["p_electrode_type"] | p_electrode_type | 행/컬럼 값 대입 |  |  |  |
| AC-85f6e6ac | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0060_ProductionPlan_JV.cs:1372 | try ▸ if (p_bucket.ToString().Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ if (i != nCnt - 1) | DATA_OP | req.Parameters["p_nick_name"] | p_nick_name | 행/컬럼 값 대입 |  |  |  |
| AC-bd7a5cba | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0060_ProductionPlan_JV.cs:1373 | try ▸ if (p_bucket.ToString().Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ if (i != nCnt - 1) | DATA_OP | req.Parameters["p_bucket"] | p_bucket | 행/컬럼 값 대입 |  |  |  |
| AC-6273d765 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0060_ProductionPlan_JV.cs:1374 | try ▸ if (p_bucket.ToString().Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ if (i != nCnt - 1) | DATA_OP | req.Parameters["p_to_period"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-d6a09ccb | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0060_ProductionPlan_JV.cs:1375 | try ▸ if (p_bucket.ToString().Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ if (i != nCnt - 1) | DATA_OP | req.Parameters["p_chk_all"] | p_chk_all | 행/컬럼 값 대입 |  |  |  |
| AC-5eb18337 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0060_ProductionPlan_JV.cs:1376 | try ▸ if (p_bucket.ToString().Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ if (i != nCnt - 1) | DATA_OP | req.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-5d9349b5 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0060_ProductionPlan_JV.cs:1381 | try ▸ if (p_bucket.ToString().Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ if (i != nCnt - 1) ▸ if (i == 0) | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-b79b5417 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0060_ProductionPlan_JV.cs:1385 | try ▸ if (p_bucket.ToString().Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ if (i != nCnt - 1) ▸ else of (i == 0) ▸ if (i … | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-73ee214e | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0060_ProductionPlan_JV.cs:1389 | try ▸ if (p_bucket.ToString().Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ if (i != nCnt - 1) ▸ else of (i == 0) ▸ else o… | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-799c408a | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0060_ProductionPlan_JV.cs:1399 | try ▸ if (p_bucket.ToString().Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ else of (i != nCnt - 1) | CALL_EXT | FoxUserInfoContext.CreateScope | (new FoxUserInfoContext(p_user_id.ToString())) | ⚠ 의미 확인 필요 |  |  |  |
| AC-855206dd | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0060_ProductionPlan_JV.cs:1402 | try ▸ if (p_bucket.ToString().Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ else of (i != nCnt - 1) | ENDPOINT | new FoxDataRequest | ("SCP.SCP0011_GET_PRODUCTION_PLAN_MODEL_TITLE_PARAL") ⇒ SCP.SCP0011_GET_PRODUCTION_PLAN_MODEL_TITLE_PARAL | 엔드포인트 요청 생성 |  |  |  |
| AC-ebe3bbe1 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0060_ProductionPlan_JV.cs:1404 | try ▸ if (p_bucket.ToString().Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ else of (i != nCnt - 1) | UI_PROP | req.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-81a82a59 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0060_ProductionPlan_JV.cs:1405 | try ▸ if (p_bucket.ToString().Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ else of (i != nCnt - 1) | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-a7b0e11d | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0060_ProductionPlan_JV.cs:1406 | try ▸ if (p_bucket.ToString().Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ else of (i != nCnt - 1) | DATA_OP | req.Parameters["p_operation_group"] | p_operation_group | 행/컬럼 값 대입 |  |  |  |
| AC-a9cd85e9 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0060_ProductionPlan_JV.cs:1407 | try ▸ if (p_bucket.ToString().Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ else of (i != nCnt - 1) | DATA_OP | req.Parameters["p_scm_site_id"] | p_scm_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-f24ab6b9 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0060_ProductionPlan_JV.cs:1408 | try ▸ if (p_bucket.ToString().Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ else of (i != nCnt - 1) | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-3564476c | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0060_ProductionPlan_JV.cs:1409 | try ▸ if (p_bucket.ToString().Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ else of (i != nCnt - 1) | DATA_OP | req.Parameters["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-00ace63f | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0060_ProductionPlan_JV.cs:1410 | try ▸ if (p_bucket.ToString().Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ else of (i != nCnt - 1) | DATA_OP | req.Parameters["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-06366a28 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0060_ProductionPlan_JV.cs:1411 | try ▸ if (p_bucket.ToString().Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ else of (i != nCnt - 1) | DATA_OP | req.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-3c89915d | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0060_ProductionPlan_JV.cs:1412 | try ▸ if (p_bucket.ToString().Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ else of (i != nCnt - 1) | DATA_OP | req.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-555ccdff | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0060_ProductionPlan_JV.cs:1413 | try ▸ if (p_bucket.ToString().Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ else of (i != nCnt - 1) | DATA_OP | req.Parameters["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-cf1f8ecb | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0060_ProductionPlan_JV.cs:1414 | try ▸ if (p_bucket.ToString().Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ else of (i != nCnt - 1) | DATA_OP | req.Parameters["p_program_id"] | p_program_id | 행/컬럼 값 대입 |  |  |  |
| AC-08257927 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0060_ProductionPlan_JV.cs:1415 | try ▸ if (p_bucket.ToString().Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ else of (i != nCnt - 1) | DATA_OP | req.Parameters["p_sheet_name"] | p_sheet_name | 행/컬럼 값 대입 |  |  |  |
| AC-286dec9f | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0060_ProductionPlan_JV.cs:1416 | try ▸ if (p_bucket.ToString().Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ else of (i != nCnt - 1) | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-e29e9b9e | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0060_ProductionPlan_JV.cs:1417 | try ▸ if (p_bucket.ToString().Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ else of (i != nCnt - 1) | DATA_OP | req.Parameters["p_electrode_type"] | p_electrode_type | 행/컬럼 값 대입 |  |  |  |
| AC-f108f3a0 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0060_ProductionPlan_JV.cs:1418 | try ▸ if (p_bucket.ToString().Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ else of (i != nCnt - 1) | DATA_OP | req.Parameters["p_nick_name"] | p_nick_name | 행/컬럼 값 대입 |  |  |  |
| AC-05111402 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0060_ProductionPlan_JV.cs:1419 | try ▸ if (p_bucket.ToString().Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ else of (i != nCnt - 1) | DATA_OP | req.Parameters["p_bucket"] | p_bucket | 행/컬럼 값 대입 |  |  |  |
| AC-c7944f4c | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0060_ProductionPlan_JV.cs:1420 | try ▸ if (p_bucket.ToString().Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ else of (i != nCnt - 1) | DATA_OP | req.Parameters["p_chk_all"] | p_chk_all | 행/컬럼 값 대입 |  |  |  |
| AC-a8253702 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0060_ProductionPlan_JV.cs:1421 | try ▸ if (p_bucket.ToString().Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ else of (i != nCnt - 1) | DATA_OP | req.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-498c920e | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0060_ProductionPlan_JV.cs:1425 | try ▸ if (p_bucket.ToString().Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ else of (i != nCnt - 1) | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-c250d50a | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0060_ProductionPlan_JV.cs:1436 | try ▸ if (p_bucket.ToString().Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all)) | DATA_OP | dsTitle.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-904e2267 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0060_ProductionPlan_JV.cs:1437 | try ▸ if (p_bucket.ToString().Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all)) | UI_MISC | dsTitle.Dispose | () | 창 닫기/해제 |  |  |  |
| AC-c2cd45c2 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0060_ProductionPlan_JV.cs:1445 | try ▸ if (p_bucket.ToString().Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all)) ▸ if (dsBinding1 != null) | UI_MISC | dsBinding1.Dispose | () | 창 닫기/해제 |  |  |  |
| AC-9cf5461c | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0060_ProductionPlan_JV.cs:1450 | try ▸ if (p_bucket.ToString().Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all)) ▸ if (dsBinding2 != null) | UI_MISC | dsBinding2.Dispose | () | 창 닫기/해제 |  |  |  |
| AC-d0d505a3 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0060_ProductionPlan_JV.cs:1455 | try ▸ if (p_bucket.ToString().Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all)) ▸ if (dsBinding3 != null) | UI_MISC | dsBinding3.Dispose | () | 창 닫기/해제 |  |  |  |
| AC-21015cd4 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0060_ProductionPlan_JV.cs:1467 | try ▸ else of (p_bucket.ToString().Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all)) | CALL_EXT | FoxUserInfoContext.CreateScope | (new FoxUserInfoContext(p_user_id.ToString())) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9d006b9a | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0060_ProductionPlan_JV.cs:1470 | try ▸ else of (p_bucket.ToString().Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all)) | ENDPOINT | new FoxDataRequest | ("SCP.SCP0011_GET_PRODUCTION_PLAN_MODEL") ⇒ SCP.SCP0011_GET_PRODUCTION_PLAN_MODEL | 엔드포인트 요청 생성 |  |  |  |
| AC-23b10122 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0060_ProductionPlan_JV.cs:1472 | try ▸ else of (p_bucket.ToString().Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all)) | UI_PROP | req.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-36517f07 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0060_ProductionPlan_JV.cs:1473 | try ▸ else of (p_bucket.ToString().Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all)) | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-8033760e | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0060_ProductionPlan_JV.cs:1474 | try ▸ else of (p_bucket.ToString().Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all)) | DATA_OP | req.Parameters["p_operation_group"] | p_operation_group | 행/컬럼 값 대입 |  |  |  |
| AC-7c14bc86 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0060_ProductionPlan_JV.cs:1475 | try ▸ else of (p_bucket.ToString().Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all)) | DATA_OP | req.Parameters["p_scm_site_id"] | p_scm_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-742a8770 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0060_ProductionPlan_JV.cs:1476 | try ▸ else of (p_bucket.ToString().Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all)) | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-34fbbb5f | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0060_ProductionPlan_JV.cs:1477 | try ▸ else of (p_bucket.ToString().Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all)) | DATA_OP | req.Parameters["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-30f1b58c | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0060_ProductionPlan_JV.cs:1478 | try ▸ else of (p_bucket.ToString().Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all)) | DATA_OP | req.Parameters["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-89c96a0d | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0060_ProductionPlan_JV.cs:1479 | try ▸ else of (p_bucket.ToString().Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all)) | DATA_OP | req.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-598d3108 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0060_ProductionPlan_JV.cs:1480 | try ▸ else of (p_bucket.ToString().Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all)) | DATA_OP | req.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-5df8f5e1 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0060_ProductionPlan_JV.cs:1481 | try ▸ else of (p_bucket.ToString().Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all)) | DATA_OP | req.Parameters["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-0f2e6325 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0060_ProductionPlan_JV.cs:1482 | try ▸ else of (p_bucket.ToString().Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all)) | DATA_OP | req.Parameters["p_program_id"] | p_program_id | 행/컬럼 값 대입 |  |  |  |
| AC-fafb6662 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0060_ProductionPlan_JV.cs:1483 | try ▸ else of (p_bucket.ToString().Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all)) | DATA_OP | req.Parameters["p_sheet_name"] | p_sheet_name | 행/컬럼 값 대입 |  |  |  |
| AC-3e877fe1 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0060_ProductionPlan_JV.cs:1484 | try ▸ else of (p_bucket.ToString().Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all)) | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-bb13b8c8 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0060_ProductionPlan_JV.cs:1485 | try ▸ else of (p_bucket.ToString().Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all)) | DATA_OP | req.Parameters["p_electrode_type"] | p_electrode_type | 행/컬럼 값 대입 |  |  |  |
| AC-2156637b | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0060_ProductionPlan_JV.cs:1486 | try ▸ else of (p_bucket.ToString().Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all)) | DATA_OP | req.Parameters["p_nick_name"] | p_nick_name | 행/컬럼 값 대입 |  |  |  |
| AC-492bae51 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0060_ProductionPlan_JV.cs:1487 | try ▸ else of (p_bucket.ToString().Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all)) | DATA_OP | req.Parameters["p_bucket"] | p_bucket | 행/컬럼 값 대입 |  |  |  |
| AC-bb6b8187 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0060_ProductionPlan_JV.cs:1488 | try ▸ else of (p_bucket.ToString().Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all)) | DATA_OP | req.Parameters["p_to_period"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-2981dc07 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0060_ProductionPlan_JV.cs:1489 | try ▸ else of (p_bucket.ToString().Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all)) | DATA_OP | req.Parameters["p_chk_all"] | p_chk_all | 행/컬럼 값 대입 |  |  |  |
| AC-1eab7718 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0060_ProductionPlan_JV.cs:1490 | try ▸ else of (p_bucket.ToString().Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all)) | DATA_OP | req.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-751babc5 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0060_ProductionPlan_JV.cs:1492 | try ▸ else of (p_bucket.ToString().Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all)) | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a822476c | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0060_ProductionPlan_JV.cs:1501 | try | GRID_BIND | siMain.Query | (dsBinding) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-86d35a20 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0060_ProductionPlan_JV.cs:1505 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-aae6d636 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0060_ProductionPlan_JV.cs:1506 | try | UI_MISC | SetSearchCount | (dsBinding) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-99a03947 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0060_ProductionPlan_JV.cs:1516 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f7f4ef80 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0060_ProductionPlan_JV.cs:1547 | try ▸ if (this.nSelRowOfMain >= 0 && isReload) | GRID_STYLE | siMain.ActiveSheet.SetActiveCell | (this.nSelRowOfMain, this.nSelColOfMain) | 그리드 표시 설정 |  |  |  |
| AC-378caf80 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0060_ProductionPlan_JV.cs:1548 | try ▸ if (this.nSelRowOfMain >= 0 && isReload) | CALL_EXT | spdMain.ShowCell | (0, 0, this.nSelRowOfMain, this.nSelColOfMain, FarPoint.Win.Spread.VerticalPosition.Center… | ⚠ 의미 확인 필요 |  |  |  |
| AC-97daf9e7 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0060_ProductionPlan_JV.cs:1558 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-16a6a3db | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0060_ProductionPlan_JV.cs:1565 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0060_ProductionPlan_JV.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ba9ecd80 | this.Load | SCP0060_ProductionPlan_JV.cs:187 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCP0060_ProductionPlan_JV.Get_IsEditInfo

진입점: this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >= 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-20a17a93 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0060_ProductionPlan_JV.cs:1742 |  | UI_PROP | proxyPivot.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-758b1bf7 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0060_ProductionPlan_JV.cs:1743 |  | ENDPOINT | proxyPivot.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, GSCM_SCP_ANALYS… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-9a333210 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0060_ProductionPlan_JV.cs:1746 | lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0011_GET_PLAN_EDIT_INFO") ⇒ SCP.SCP0011_GET_PLAN_EDIT_INFO | 엔드포인트 요청 생성 |  |  |  |
| AC-e08d8971 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0060_ProductionPlan_JV.cs:1748 | lambda | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-5f92c6c0 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0060_ProductionPlan_JV.cs:1749 | lambda | DATA_OP | req.Parameters["p_scm_site_id"] | p_scm_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-cdb6071d | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0060_ProductionPlan_JV.cs:1750 | lambda | DATA_OP | req.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-116d343c | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0060_ProductionPlan_JV.cs:1751 | lambda | DATA_OP | req.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-32900a82 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0060_ProductionPlan_JV.cs:1752 | lambda | DATA_OP | req.Parameters["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-3df6cd63 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0060_ProductionPlan_JV.cs:1753 | lambda | DATA_OP | req.Parameters["p_origin_division_id"] | p_origin_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-bdbcb257 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0060_ProductionPlan_JV.cs:1754 | lambda | DATA_OP | req.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-229e9c29 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0060_ProductionPlan_JV.cs:1755 | lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-d751e6e0 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0060_ProductionPlan_JV.cs:1756 | lambda | RETURN | return res.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-6ea94ff3 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0060_ProductionPlan_JV.cs:1762 | if (dsBinding.Tables.Count > 0) | FLAG | dtIsEditInfo | dsBinding.Tables[0] | 화면 필드/플래그 변경 |  |  |  |

## SCP0060_ProductionPlan_JV.GetBucketType

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-aa22b17f | this.Load | SCP0060_ProductionPlan_JV.cs:973 |  | ENDPOINT | new FoxDataRequest | ("DM.DM0003_GET_BUCKET_TYPE_CODE") ⇒ DM.DM0003_GET_BUCKET_TYPE_CODE | 엔드포인트 요청 생성 |  |  |  |
| AC-bd3e8080 | this.Load | SCP0060_ProductionPlan_JV.cs:974 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-999cad5f | this.Load | SCP0060_ProductionPlan_JV.cs:977 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SCP0060_ProductionPlan_JV.GetDayRange

진입점: this.Load / cboPlanDate.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-17b8c0d7 | this.Load 외 1 | SCP0060_ProductionPlan_JV.cs:3301 |  | CALL_EXT | DateUtil.GetDayRange | (cboDivision.ControlValues, cboBucketType.ControlValues, cboPlanDate.ControlValues) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b4427d31 | this.Load 외 1 | SCP0060_ProductionPlan_JV.cs:3303 |  | RETURN | return sDayRange; |  | 처리 중단/반환 |  |  |  |

## SCP0060_ProductionPlan_JV.GetDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f71f4233 | (진입점 미연결) | SCP0060_ProductionPlan_JV.cs:3232 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_DIVISION") ⇒ SCM.SCM0001_GET_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-2dae4e21 | (진입점 미연결) | SCP0060_ProductionPlan_JV.cs:3233 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-8d3c3971 | (진입점 미연결) | SCP0060_ProductionPlan_JV.cs:3236 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SCP0060_ProductionPlan_JV.GetEventField

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bb063130 | (진입점 미연결) | SCP0060_ProductionPlan_JV.cs:3152 | while (type != null) | CALL_EXT | type.GetField | (eventName, BindingFlags.Static \| BindingFlags.Instance \| BindingFlags.NonPublic) | ⚠ 의미 확인 필요 |  |  |  |
| AC-00b26e4b | (진입점 미연결) | SCP0060_ProductionPlan_JV.cs:3153 | while (type != null) | CALL_EXT | field.FieldType.IsSubclassOf | (typeof(MulticastDelegate)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9db3b830 | (진입점 미연결) | SCP0060_ProductionPlan_JV.cs:3157 | while (type != null) | CALL_EXT | type.GetField | ("EVENT_" + eventName.ToUpper(), BindingFlags.Static \| BindingFlags.Instance \| BindingFl… | ⚠ 의미 확인 필요 |  |  |  |
| AC-fc914dc6 | (진입점 미연결) | SCP0060_ProductionPlan_JV.cs:3162 |  | RETURN | return field; |  | 처리 중단/반환 |  |  |  |

## SCP0060_ProductionPlan_JV.GetLastPlanVersion

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-74e4c785 | (진입점 미연결) | SCP0060_ProductionPlan_JV.cs:1112 | try | ENDPOINT | new FoxDataRequest | ("SCP.SCP0011_GET_LAST_PLAN_VERSION") ⇒ SCP.SCP0011_GET_LAST_PLAN_VERSION | 엔드포인트 요청 생성 |  |  |  |
| AC-1a4a6a02 | (진입점 미연결) | SCP0060_ProductionPlan_JV.cs:1114 | try | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-005ec0f4 | (진입점 미연결) | SCP0060_ProductionPlan_JV.cs:1115 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-4fb6630b | (진입점 미연결) | SCP0060_ProductionPlan_JV.cs:1129 | try ▸ if (dsBinding.Tables.Count > 0 && dsBinding.Tables[0].Rows.Count > 0) | VALUE_SET | cboPlanDate.SelectedValue | PLAN_START_YYYYMMDD | 컨트롤 값 설정 |  |  |  |
| AC-1ff60e1a | (진입점 미연결) | SCP0060_ProductionPlan_JV.cs:1130 | try ▸ if (dsBinding.Tables.Count > 0 && dsBinding.Tables[0].Rows.Count > 0) | VALUE_SET | cboPlanType.SelectedValue | PLAN_TYPE | 컨트롤 값 설정 |  |  |  |
| AC-f68b830a | (진입점 미연결) | SCP0060_ProductionPlan_JV.cs:1131 | try ▸ if (dsBinding.Tables.Count > 0 && dsBinding.Tables[0].Rows.Count > 0) | VALUE_SET | cboPlanSeq.SelectedValue | PLAN_SEQ | 컨트롤 값 설정 |  |  |  |

## SCP0060_ProductionPlan_JV.GetShipToParty

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-67d4b04d | (진입점 미연결) | SCP0060_ProductionPlan_JV.cs:3272 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SCP0060_ProductionPlan_JV.GetShipType

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fa500d6c | (진입점 미연결) | SCP0060_ProductionPlan_JV.cs:3266 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SCP0060_ProductionPlan_JV.GetSoldToParty

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9cec91c9 | (진입점 미연결) | SCP0060_ProductionPlan_JV.cs:3278 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SCP0060_ProductionPlan_JV.GetSpdTitle

진입점: this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ if (showMsg) ▸ try] / this.Load / this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >= 0) ▸ try] / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (fps.Name == "spdMain")] / FindButton [try] / SaveButton [if (fps.Name == "spdLine") ▸ if (siLine != null && siMain.IsLock(SpdSheet.shtLine) == false) ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ if (sh…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-efc12469 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 6 | SCP0060_ProductionPlan_JV.cs:3287 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN") ⇒ SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | 엔드포인트 요청 생성 |  |  |  |
| AC-8380cea5 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 6 | SCP0060_ProductionPlan_JV.cs:3292 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | drpPeriod.Text1.Replace("-", "") | 행/컬럼 값 대입 |  |  |  |
| AC-bf008c4e | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 6 | SCP0060_ProductionPlan_JV.cs:3293 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | drpPeriod.Text2.Replace("-", "") | 행/컬럼 값 대입 |  |  |  |
| AC-cd97fd93 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 6 | SCP0060_ProductionPlan_JV.cs:3295 |  | FLAG | dsSpdTitle | client.ExecuteDataSet(request).DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-db6b6387 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 6 | SCP0060_ProductionPlan_JV.cs:3295 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## SCP0060_ProductionPlan_JV.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2b4304e0 | this.Load | SCP0060_ProductionPlan_JV.cs:221 |  | DATA_OP | this.ConditionNotUseList.Add | (cboPlanDate) | 데이터 객체 조작/조회 |  |  |  |
| AC-ab16e810 | this.Load | SCP0060_ProductionPlan_JV.cs:222 |  | DATA_OP | this.ConditionNotUseList.Add | (cboPlanType) | 데이터 객체 조작/조회 |  |  |  |
| AC-b5cd9ca6 | this.Load | SCP0060_ProductionPlan_JV.cs:223 |  | DATA_OP | this.ConditionNotUseList.Add | (cboPlanSeq) | 데이터 객체 조작/조회 |  |  |  |
| AC-f998c856 | this.Load | SCP0060_ProductionPlan_JV.cs:226 |  | DATA_OP | ReadOnlySheetList.Add | (SpdSheet.shtMain) | 데이터 객체 조작/조회 |  |  |  |
| AC-b98acce1 | this.Load | SCP0060_ProductionPlan_JV.cs:230 | if (dtMyDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |
| AC-d214817d | this.Load | SCP0060_ProductionPlan_JV.cs:232 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-49f9105e | this.Load | SCP0060_ProductionPlan_JV.cs:236 |  | LIST_REBIND | clsCtrl.setListBox | (dtMyDivision, cboDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-8e3c7d72 | this.Load | SCP0060_ProductionPlan_JV.cs:242 |  | LIST_REBIND | clsCtrl.setListBox | (dtElectrodeType, cboElectrode, false) | 목록 컨트롤 재구성 |  |  |  |
| AC-84244687 | this.Load | SCP0060_ProductionPlan_JV.cs:249 |  | FLAG | dtBucketType | GetBucketType() | 화면 필드/플래그 변경 |  |  |  |
| AC-8987e4b1 | this.Load | SCP0060_ProductionPlan_JV.cs:250 |  | LIST_REBIND | clsCtrl.setListBox | (dtBucketType, cboBucketType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-6f8dfe6e | this.Load | SCP0060_ProductionPlan_JV.cs:252 |  | VALUE_SET | drpPeriod.InitValue | GetDayRange() | 컨트롤 값 설정 |  |  |  |

## SCP0060_ProductionPlan_JV.InitSpread

진입점: this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ if (showMsg) ▸ try] / this.Load / this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >= 0) ▸ try] / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (fps.Name == "spdMain")] / FindButton [try] / SaveButton [if (fps.Name == "spdLine") ▸ if (siLine != null && siMain.IsLock(SpdSheet.shtLine) == false) ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ if (sh…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-38494128 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 6 | SCP0060_ProductionPlan_JV.cs:332 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.SetSheetHeaderColumn | (spdInfo, 3) | 그리드 재구성/초기화 |  |  |  |
| AC-419c7ea2 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 6 | SCP0060_ProductionPlan_JV.cs:346 | if (spdInfo.SheetName == SpdSheet.shtMain) | UI_PROP | spdInfo.nIdxData | nIdxDataMain | 속성 nIdxData 설정 |  |  |  |
| AC-5c098681 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 6 | SCP0060_ProductionPlan_JV.cs:352 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6340e367 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 6 | SCP0060_ProductionPlan_JV.cs:354 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-1218c8ca | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 6 | SCP0060_ProductionPlan_JV.cs:358 | if (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (!division.Substring(0, 2).Equals("EE")) | GRID_SET | spdInfo.ActiveSheet.Columns[siMain.GetColumnIndex("ORIGIN_DIVISION_ID")].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-2067320f | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 6 | SCP0060_ProductionPlan_JV.cs:359 | if (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (!division.Substring(0, 2).Equals("EE")) | GRID_SET | spdInfo.ActiveSheet.Columns[siMain.GetColumnIndex("ELECTRODE_TYPE")].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-a3250456 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 6 | SCP0060_ProductionPlan_JV.cs:363 | if (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (!division.Substring(0, 2).Equals("EE")) | GRID_SET | spdInfo.ActiveSheet.Columns[siMain.GetColumnIndex("ORIGIN_DIVISION_ID")].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-aaf3699b | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 6 | SCP0060_ProductionPlan_JV.cs:364 | if (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (!division.Substring(0, 2).Equals("EE")) | GRID_SET | spdInfo.ActiveSheet.Columns[siMain.GetColumnIndex("ELECTRODE_TYPE")].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-97ba1248 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 6 | SCP0060_ProductionPlan_JV.cs:408 | if (spdInfo.SheetName == SpdSheet.shtLine) | GRID_INIT | spdInfo.SetSheetHeaderColumn | (spdInfo, 3) | 그리드 재구성/초기화 |  |  |  |
| AC-597d453f | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 6 | SCP0060_ProductionPlan_JV.cs:411 | if (spdInfo.SheetName == SpdSheet.shtLine) | UI_PROP | spdInfo.nIdxData | nIdxDataLine | 속성 nIdxData 설정 |  |  |  |
| AC-30982137 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 6 | SCP0060_ProductionPlan_JV.cs:417 | if (spdInfo.SheetName == SpdSheet.shtLine) | GRID_INIT | spdInfo.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-84d0fe9c | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 6 | SCP0060_ProductionPlan_JV.cs:418 | if (spdInfo.SheetName == SpdSheet.shtLine) | GRID_INIT | spdInfo.Freeze | (0, spdInfo.GetColumnIndex(DefColumns.MEASURE_NAME) + 1) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-16453c66 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 6 | SCP0060_ProductionPlan_JV.cs:419 | if (spdInfo.SheetName == SpdSheet.shtLine) | GRID_INIT | spdInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-e0f770ab | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 6 | SCP0060_ProductionPlan_JV.cs:423 | if (spdInfo.SheetName == SpdSheet.shtLine) ▸ if (!division.Substring(0, 2).Equals("EE")) | GRID_SET | spdInfo.ActiveSheet.Columns[siLine.GetColumnIndex("ORIGIN_DIVISION_ID")].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-e68275d1 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 6 | SCP0060_ProductionPlan_JV.cs:424 | if (spdInfo.SheetName == SpdSheet.shtLine) ▸ if (!division.Substring(0, 2).Equals("EE")) | GRID_SET | spdInfo.ActiveSheet.Columns[siLine.GetColumnIndex("ELECTRODE_TYPE")].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-3e519d5b | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 6 | SCP0060_ProductionPlan_JV.cs:428 | if (spdInfo.SheetName == SpdSheet.shtLine) ▸ else of (!division.Substring(0, 2).Equals("EE")) | GRID_SET | spdInfo.ActiveSheet.Columns[siLine.GetColumnIndex("ORIGIN_DIVISION_ID")].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-8aebf8df | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 6 | SCP0060_ProductionPlan_JV.cs:429 | if (spdInfo.SheetName == SpdSheet.shtLine) ▸ else of (!division.Substring(0, 2).Equals("EE")) | GRID_SET | spdInfo.ActiveSheet.Columns[siLine.GetColumnIndex("ELECTRODE_TYPE")].Visible | true | 그리드 속성/값 설정 |  |  |  |

## SCP0060_ProductionPlan_JV.InitSpreadDateColumn

진입점: this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ if (showMsg) ▸ try ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] / this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >= 0) ▸ try ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (fps.Name == "spdMain") ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / FindButton [try ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / SaveButton [if (fps.Name == "spdLine") ▸ if (siLine !=…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3126efc9 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 6 | SCP0060_ProductionPlan_JV.cs:469 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sColumnName.IndexOf("B_") > 0) | GRID_INIT | spdInfo.AddTextColumn | (sColumnLabelname, sColumnName, FPMerge.None, 0, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7fc506a8 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 6 | SCP0060_ProductionPlan_JV.cs:473 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sColumnName.IndexOf("B_") > 0) | GRID_INIT | spdInfo.AddNumColumn | (sColumnLabelname, sColumnName, FPMerge.None, 70, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3d8b1e7d | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 6 | SCP0060_ProductionPlan_JV.cs:474 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sColumnName.IndexOf("B_") > 0) | GRID_INIT | spdInfo.SetReNumerCellType | (spdInfo, spdInfo.GetColumnIndex(sColumnName), 0, 0, 99999999) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-e3dd3068 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 6 | SCP0060_ProductionPlan_JV.cs:477 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sColumnName.IndexOf("B_") > 0) ▸ if (sDayCode == DefColumnsLabel.Saturday \|\| … | GRID_SET | spdInfo.Sheet().ColumnHeader.Cells[2, spdInfo.GetMaxColumnIndex()].ForeColor | sDayCode == DefColumnsLabel.Saturday ? Color.Blue : Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-82d8e1c0 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 6 | SCP0060_ProductionPlan_JV.cs:484 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-60345c51 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 6 | SCP0060_ProductionPlan_JV.cs:485 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-13ef7ff6 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 6 | SCP0060_ProductionPlan_JV.cs:490 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2e247b39 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 6 | SCP0060_ProductionPlan_JV.cs:491 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 30, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8adc3aea | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 6 | SCP0060_ProductionPlan_JV.cs:499 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName != sSmallLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d26a5484 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 6 | SCP0060_ProductionPlan_JV.cs:500 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName != sSmallLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1e214cb9 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 6 | SCP0060_ProductionPlan_JV.cs:510 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-73c3a6f1 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 6 | SCP0060_ProductionPlan_JV.cs:511 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d68e5bbe | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 6 | SCP0060_ProductionPlan_JV.cs:512 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b8b8eced | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 6 | SCP0060_ProductionPlan_JV.cs:513 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0060_ProductionPlan_JV.SaveChage_CalData

진입점: this.btnCal.Click / SaveButton [if (fps.Name == "spdLine") ▸ if (siLine != null && siMain.IsLock(SpdSheet.shtLine) == false) ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.Tables[0].Rows[0][0].ToString() == "S")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-34bcb755 | this.btnCal.Click 외 1 | SCP0060_ProductionPlan_JV.cs:3333 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-ae8b6788 | this.btnCal.Click 외 1 | SCP0060_ProductionPlan_JV.cs:3334 |  | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-93515427 | this.btnCal.Click 외 1 | SCP0060_ProductionPlan_JV.cs:3348 | try | ENDPOINT | new FoxDataRequest | ("SCP.PR_SCP_ANL_PRODUCTION_PLAN_I_AMEND") ⇒ SCP.PR_SCP_ANL_PRODUCTION_PLAN_I_AMEND | 엔드포인트 요청 생성 |  |  |  |
| AC-04863f6d | this.btnCal.Click 외 1 | SCP0060_ProductionPlan_JV.cs:3351 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-280fc449 | this.btnCal.Click 외 1 | SCP0060_ProductionPlan_JV.cs:3353 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCP.Analysis.WSL/FoxDataServi… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-74b2412d | this.btnCal.Click 외 1 | SCP0060_ProductionPlan_JV.cs:3357 | try ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-cd799fe1 | this.btnCal.Click 외 1 | SCP0060_ProductionPlan_JV.cs:3358 | try ▸ lambda | DATA_OP | request.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-3b6d47d0 | this.btnCal.Click 외 1 | SCP0060_ProductionPlan_JV.cs:3359 | try ▸ lambda | DATA_OP | request.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-9b9f58ea | this.btnCal.Click 외 1 | SCP0060_ProductionPlan_JV.cs:3360 | try ▸ lambda | DATA_OP | request.Parameters["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-f38f359c | this.btnCal.Click 외 1 | SCP0060_ProductionPlan_JV.cs:3361 | try ▸ lambda | DATA_OP | request.Parameters["p_operation_group"] | p_operation_group | 행/컬럼 값 대입 |  |  |  |
| AC-8e53df11 | this.btnCal.Click 외 1 | SCP0060_ProductionPlan_JV.cs:3362 | try ▸ lambda | DATA_OP | request.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-a601021f | this.btnCal.Click 외 1 | SCP0060_ProductionPlan_JV.cs:3364 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-116ded92 | this.btnCal.Click 외 1 | SCP0060_ProductionPlan_JV.cs:3364 | try ▸ lambda | RETURN | return client.ExecuteDataSet(request); |  | 처리 중단/반환 |  |  |  |
| AC-fb312f84 | this.btnCal.Click 외 1 | SCP0060_ProductionPlan_JV.cs:3374 | try ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ if (showMsg) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-60aff96a | this.btnCal.Click 외 1 | SCP0060_ProductionPlan_JV.cs:3393 | try ▸ if (t.Success) ▸ else of (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8365d746 | this.btnCal.Click 외 1 | SCP0060_ProductionPlan_JV.cs:3400 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ef28bca9 | this.btnCal.Click 외 1 | SCP0060_ProductionPlan_JV.cs:3404 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0060_ProductionPlan_JV.SaveData_Line

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a450b8a5 | SaveButton | SCP0060_ProductionPlan_JV.cs:2681 | if (fps.Name == "spdLine") ▸ if (siLine != null && siMain.IsLock(SpdSheet.shtLine) == false) ▸ if (siLine.ActiveSheet.Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d8163501 | SaveButton | SCP0060_ProductionPlan_JV.cs:2707 | if (fps.Name == "spdLine") ▸ if (siLine != null && siMain.IsLock(SpdSheet.shtLine) == false) | VALIDATE | DataUtil.checkRequiredOfSpread | (siLine) | 프레임워크 검증 |  |  |  |
| AC-fcafe13e | SaveButton | SCP0060_ProductionPlan_JV.cs:2707 | if (fps.Name == "spdLine") ▸ if (siLine != null && siMain.IsLock(SpdSheet.shtLine) == false) ▸ if (!DataUtil.checkRequiredOfSpread(siLine)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7e35f06a | SaveButton | SCP0060_ProductionPlan_JV.cs:2741 | if (fps.Name == "spdLine") ▸ if (siLine != null && siMain.IsLock(SpdSheet.shtLine) == false) ▸ for (i <= siLine.GetMaxRowIndex()) ▸ for (j <… | GRID_STYLE | siLine.SetBGColor | (i, j, i, j, ControlColor.InvalidColor) | 그리드 표시 설정 |  |  |  |
| AC-6f784723 | SaveButton | SCP0060_ProductionPlan_JV.cs:2742 | if (fps.Name == "spdLine") ▸ if (siLine != null && siMain.IsLock(SpdSheet.shtLine) == false) ▸ for (i <= siLine.GetMaxRowIndex()) ▸ for (j <… | MESSAGE | MessageHelper.GMessageBox | ("MSG00084", new object[] { null }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9f04570a | SaveButton | SCP0060_ProductionPlan_JV.cs:2743 | if (fps.Name == "spdLine") ▸ if (siLine != null && siMain.IsLock(SpdSheet.shtLine) == false) ▸ for (i <= siLine.GetMaxRowIndex()) ▸ for (j <… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-cd5c8101 | SaveButton | SCP0060_ProductionPlan_JV.cs:2790 | if (fps.Name == "spdLine") ▸ if (siLine != null && siMain.IsLock(SpdSheet.shtLine) == false) ▸ if (iCount > 0) ▸ try | ENDPOINT | new FoxDataRequest | ("SCP.SCP0011_SAVE_PRODUCTION_PLAN_LINE") ⇒ SCP.SCP0011_SAVE_PRODUCTION_PLAN_LINE | 엔드포인트 요청 생성 |  |  |  |
| AC-a6770778 | SaveButton | SCP0060_ProductionPlan_JV.cs:2794 | if (fps.Name == "spdLine") ▸ if (siLine != null && siMain.IsLock(SpdSheet.shtLine) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_active_flag"] | strACTIVE_FLAG | 행/컬럼 값 대입 |  |  |  |
| AC-5c832534 | SaveButton | SCP0060_ProductionPlan_JV.cs:2795 | if (fps.Name == "spdLine") ▸ if (siLine != null && siMain.IsLock(SpdSheet.shtLine) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_division_id"] | strDIVISION_ID | 행/컬럼 값 대입 |  |  |  |
| AC-b3eaac85 | SaveButton | SCP0060_ProductionPlan_JV.cs:2796 | if (fps.Name == "spdLine") ▸ if (siLine != null && siMain.IsLock(SpdSheet.shtLine) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_plan_start_yyyymmdd"] | strPLAN_START_YYYYMMDD | 행/컬럼 값 대입 |  |  |  |
| AC-45fb2ca0 | SaveButton | SCP0060_ProductionPlan_JV.cs:2797 | if (fps.Name == "spdLine") ▸ if (siLine != null && siMain.IsLock(SpdSheet.shtLine) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_plan_type"] | strPLAN_TYPE | 행/컬럼 값 대입 |  |  |  |
| AC-2a5f185e | SaveButton | SCP0060_ProductionPlan_JV.cs:2798 | if (fps.Name == "spdLine") ▸ if (siLine != null && siMain.IsLock(SpdSheet.shtLine) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_seq"] | strSEQ | 행/컬럼 값 대입 |  |  |  |
| AC-69e45ba6 | SaveButton | SCP0060_ProductionPlan_JV.cs:2799 | if (fps.Name == "spdLine") ▸ if (siLine != null && siMain.IsLock(SpdSheet.shtLine) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_operation_group"] | strOPERATION_GROUP | 행/컬럼 값 대입 |  |  |  |
| AC-a7489b3c | SaveButton | SCP0060_ProductionPlan_JV.cs:2800 | if (fps.Name == "spdLine") ▸ if (siLine != null && siMain.IsLock(SpdSheet.shtLine) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_scm_site_id"] | strSCM_SITE_ID | 행/컬럼 값 대입 |  |  |  |
| AC-4f67f487 | SaveButton | SCP0060_ProductionPlan_JV.cs:2801 | if (fps.Name == "spdLine") ▸ if (siLine != null && siMain.IsLock(SpdSheet.shtLine) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_item_id"] | strITEM_ID | 행/컬럼 값 대입 |  |  |  |
| AC-50244760 | SaveButton | SCP0060_ProductionPlan_JV.cs:2802 | if (fps.Name == "spdLine") ▸ if (siLine != null && siMain.IsLock(SpdSheet.shtLine) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_line_id"] | strLINE_ID | 행/컬럼 값 대입 |  |  |  |
| AC-0e3923a2 | SaveButton | SCP0060_ProductionPlan_JV.cs:2803 | if (fps.Name == "spdLine") ▸ if (siLine != null && siMain.IsLock(SpdSheet.shtLine) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_operation_id"] | strOPERATION_ID | 행/컬럼 값 대입 |  |  |  |
| AC-26349dba | SaveButton | SCP0060_ProductionPlan_JV.cs:2804 | if (fps.Name == "spdLine") ▸ if (siLine != null && siMain.IsLock(SpdSheet.shtLine) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_measure"] | strMEASURE | 행/컬럼 값 대입 |  |  |  |
| AC-387dec72 | SaveButton | SCP0060_ProductionPlan_JV.cs:2805 | if (fps.Name == "spdLine") ▸ if (siLine != null && siMain.IsLock(SpdSheet.shtLine) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_yyyymmdd"] | strYYYYMMDD | 행/컬럼 값 대입 |  |  |  |
| AC-2cafbb9c | SaveButton | SCP0060_ProductionPlan_JV.cs:2806 | if (fps.Name == "spdLine") ▸ if (siLine != null && siMain.IsLock(SpdSheet.shtLine) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_qty"] | strQTY | 행/컬럼 값 대입 |  |  |  |
| AC-c647fab0 | SaveButton | SCP0060_ProductionPlan_JV.cs:2807 | if (fps.Name == "spdLine") ▸ if (siLine != null && siMain.IsLock(SpdSheet.shtLine) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_user_id"] | strUSER_ID | 행/컬럼 값 대입 |  |  |  |
| AC-6d431bc3 | SaveButton | SCP0060_ProductionPlan_JV.cs:2808 | if (fps.Name == "spdLine") ▸ if (siLine != null && siMain.IsLock(SpdSheet.shtLine) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_fix"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-8e03bb97 | SaveButton | SCP0060_ProductionPlan_JV.cs:2809 | if (fps.Name == "spdLine") ▸ if (siLine != null && siMain.IsLock(SpdSheet.shtLine) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_electrode_type"] | strELECTRODE_TYPE | 행/컬럼 값 대입 |  |  |  |
| AC-ef29fea6 | SaveButton | SCP0060_ProductionPlan_JV.cs:2810 | if (fps.Name == "spdLine") ▸ if (siLine != null && siMain.IsLock(SpdSheet.shtLine) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_origin_division_id"] | strORIGIN_DIVISION_ID | 행/컬럼 값 대입 |  |  |  |
| AC-c287b4bc | SaveButton | SCP0060_ProductionPlan_JV.cs:2812 | if (fps.Name == "spdLine") ▸ if (siLine != null && siMain.IsLock(SpdSheet.shtLine) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_program_id"] | "SCP0011" | 행/컬럼 값 대입 |  |  |  |
| AC-79995082 | SaveButton | SCP0060_ProductionPlan_JV.cs:2813 | if (fps.Name == "spdLine") ▸ if (siLine != null && siMain.IsLock(SpdSheet.shtLine) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-cf4bf139 | SaveButton | SCP0060_ProductionPlan_JV.cs:2815 | if (fps.Name == "spdLine") ▸ if (siLine != null && siMain.IsLock(SpdSheet.shtLine) == false) ▸ if (iCount > 0) ▸ try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-fce473bb | SaveButton | SCP0060_ProductionPlan_JV.cs:2820 | if (fps.Name == "spdLine") ▸ if (siLine != null && siMain.IsLock(SpdSheet.shtLine) == false) ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { response.DataSet.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a4677e38 | SaveButton | SCP0060_ProductionPlan_JV.cs:2836 | if (fps.Name == "spdLine") ▸ if (siLine != null && siMain.IsLock(SpdSheet.shtLine) == false) ▸ if (iCount > 0) ▸ try ▸ else of (response.Dat… | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0fcb5b69 | SaveButton | SCP0060_ProductionPlan_JV.cs:2845 | if (fps.Name == "spdLine") ▸ if (siLine != null && siMain.IsLock(SpdSheet.shtLine) == false) ▸ if (iCount > 0) ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SCP0060_ProductionPlan_JV.Set_FPOperationColor

진입점: this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ if (showMsg) ▸ try ▸ if (this.nSelRowOfMain >= 0 && isReload) ▸ try] / this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >= 0) ▸ try] / FindButton [try ▸ if (this.nSelRowOfMain >= 0 && isReload) ▸ try] / EditButton [if (fps != null) ▸ if (fps.Name == "spdLine") ▸ if (fps.ActiveSheet.Columns.Get(xCol1).Visible == false)] / SaveButton [if (fps.Name == "spdLine") ▸ if (siLine != null && siMain.IsLock(SpdSheet.shtLine) == false) ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.Tables[0].Rows[0]…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8dd5a8d3 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 5 | SCP0060_ProductionPlan_JV.cs:2873 | if (siLine.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9170bc17 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 5 | SCP0060_ProductionPlan_JV.cs:2874 |  | FLAG | siLine | GetSheetInfo(spdLine.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-09d6e086 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 5 | SCP0060_ProductionPlan_JV.cs:2914 | for (i < spdLine.ActiveSheet.RowCount) ▸ if (spdLine.ActiveSheet.GetText(i, siLine.GetColumnIndex(DefColumns.MEASURE)).ToString() == "PROD_P… | DATA_OP | dtPlanType.Select | ("CODE='FN'") | 데이터 객체 조작/조회 |  |  |  |
| AC-6ffd8615 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 5 | SCP0060_ProductionPlan_JV.cs:2951 | for (i < spdLine.ActiveSheet.RowCount) ▸ if (spdLine.ActiveSheet.GetText(i, siLine.GetColumnIndex(DefColumns.MEASURE)).ToString() == "PROD_P… | GRID_STYLE | siLine.SetBGColor2 | (nEditableRow, nStartEditIdx, nEditableRow, siLine.ActiveSheet.ColumnCount - 1, Color.From… | 그리드 표시 설정 |  |  |  |
| AC-34038ebc | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 5 | SCP0060_ProductionPlan_JV.cs:2962 | for (i < spdLine.ActiveSheet.RowCount) ▸ for (j < siLine.ActiveSheet.ColumnCount) ▸ if (siLine.GetColumnTag(j).IndexOf("M_") == 0) | GRID_LOCK | siLine.LockRange | (0, j, siLine.ActiveSheet.RowCount - 1, j, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-f474c65a | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 5 | SCP0060_ProductionPlan_JV.cs:2968 |  | UI_MISC | spdLine.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## SCP0060_ProductionPlan_JV.Set_OnHandEOH

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0b72b817 | (진입점 미연결) | SCP0060_ProductionPlan_JV.cs:1863 | if (!this.CanModelChange) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4d52e9f2 | (진입점 미연결) | SCP0060_ProductionPlan_JV.cs:1873 | if (ds == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-146c1647 | (진입점 미연결) | SCP0060_ProductionPlan_JV.cs:1887 | try ▸ for (nCol < dt.Columns.Count) ▸ if (dt.Columns[nCol].ColumnName.IndexOf("M_") == 0) | DATA_OP | listMonth.Add | (nCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-6e1b3a42 | (진입점 미연결) | SCP0060_ProductionPlan_JV.cs:1891 | try ▸ for (nCol < dt.Columns.Count) ▸ if (dt.Columns[nCol].ColumnName.IndexOf("W_") == 0) | DATA_OP | listWeek.Add | (nCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-e23cb8da | (진입점 미연결) | SCP0060_ProductionPlan_JV.cs:1967 | try ▸ for (i < dt.Rows.Count) ▸ if (dt.Rows[i][DefColumns.MEASURE].ToString() == "ONHAND_EOH") ▸ for (j < dt.Columns.Count) ▸ if (j == dt.Co… | GRID_SET | dt.Rows[i][nIdxWeek] | objBOH | 그리드 속성/값 설정 |  |  |  |
| AC-cf3f57f8 | (진입점 미연결) | SCP0060_ProductionPlan_JV.cs:1979 | try ▸ for (i < dt.Rows.Count) ▸ if (dt.Rows[i][DefColumns.MEASURE].ToString() == "ONHAND_EOH") ▸ for (j < dt.Columns.Count) ▸ if (j == dt.Co… | GRID_SET | dt.Rows[i][nIdxMonth] | objBOH | 그리드 속성/값 설정 |  |  |  |
| AC-965caa51 | (진입점 미연결) | SCP0060_ProductionPlan_JV.cs:1993 | try ▸ for (i < dt.Rows.Count) ▸ if (dt.Rows[i][DefColumns.MEASURE].ToString() == "FORMATION_YIELD") | CALL_EXT | siMain.ActiveSheet.GetViewRowFromModelRow | (i) | ⚠ 의미 확인 필요 |  |  |  |
| AC-6ced7814 | (진입점 미연결) | SCP0060_ProductionPlan_JV.cs:1994 | try ▸ for (i < dt.Rows.Count) ▸ if (dt.Rows[i][DefColumns.MEASURE].ToString() == "FORMATION_YIELD") | CALL_EXT | siMain.SetDecimal | (viewRow, nIdxStart, viewRow, nIdxEnd, 2, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-cd3cf208 | (진입점 미연결) | SCP0060_ProductionPlan_JV.cs:2000 | catch ((Exception et)) | THROW | throw et; |  | 예외 발생 |  |  |  |
| AC-def22f55 | (진입점 미연결) | SCP0060_ProductionPlan_JV.cs:2004 | finally | DATA_OP | dt.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |

## SCP0060_ProductionPlan_JV.Set_OnHandEOH_Parallel

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d6119fd8 | (진입점 미연결) | SCP0060_ProductionPlan_JV.cs:2013 | if (!this.CanModelChange) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4bb2280c | (진입점 미연결) | SCP0060_ProductionPlan_JV.cs:2023 | if (ds == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c8653e54 | (진입점 미연결) | SCP0060_ProductionPlan_JV.cs:2037 | try ▸ for (nCol < dt.Columns.Count) ▸ if (dt.Columns[nCol].ColumnName.IndexOf("M_") == 0) | DATA_OP | listMonth.Add | (nCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-b11812d4 | (진입점 미연결) | SCP0060_ProductionPlan_JV.cs:2041 | try ▸ for (nCol < dt.Columns.Count) ▸ if (dt.Columns[nCol].ColumnName.IndexOf("W_") == 0) | DATA_OP | listWeek.Add | (nCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-97d5eea5 | (진입점 미연결) | SCP0060_ProductionPlan_JV.cs:2195 | try ▸ for (i < dt.Rows.Count) ▸ if (dt.Rows[i][DefColumns.MEASURE].ToString() == "ONHAND_EOH") ▸ for (j < dt.Columns.Count) ▸ if (dt.Columns… | DATA_OP | dt.Select | (sFilter) | 데이터 객체 조작/조회 |  |  |  |
| AC-432c5e3e | (진입점 미연결) | SCP0060_ProductionPlan_JV.cs:2224 | try ▸ for (i < dt.Rows.Count) ▸ if (dt.Rows[i][DefColumns.MEASURE].ToString() == "ONHAND_EOH") ▸ for (j < dt.Columns.Count) ▸ if (dt.Columns… | GRID_SET | dt.Rows[i][ColName] | result | 그리드 속성/값 설정 |  |  |  |
| AC-fe561788 | (진입점 미연결) | SCP0060_ProductionPlan_JV.cs:2234 | try ▸ for (i < dt.Rows.Count) ▸ if (dt.Rows[i][DefColumns.MEASURE].ToString() == "ONHAND_EOH") ▸ for (j < dt.Columns.Count) ▸ if (j == dt.Co… | GRID_SET | dt.Rows[i][nIdxWeek] | boh | 그리드 속성/값 설정 |  |  |  |
| AC-8ef81412 | (진입점 미연결) | SCP0060_ProductionPlan_JV.cs:2245 | try ▸ for (i < dt.Rows.Count) ▸ if (dt.Rows[i][DefColumns.MEASURE].ToString() == "ONHAND_EOH") ▸ for (j < dt.Columns.Count) ▸ if (j == dt.Co… | GRID_SET | dt.Rows[i][nIdxMonth] | boh | 그리드 속성/값 설정 |  |  |  |
| AC-a46fa3f3 | (진입점 미연결) | SCP0060_ProductionPlan_JV.cs:2259 | try ▸ for (i < dt.Rows.Count) ▸ if (dt.Rows[i][DefColumns.MEASURE].ToString() == "FORMATION_YIELD") | CALL_EXT | siMain.ActiveSheet.GetViewRowFromModelRow | (i) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d017c6be | (진입점 미연결) | SCP0060_ProductionPlan_JV.cs:2260 | try ▸ for (i < dt.Rows.Count) ▸ if (dt.Rows[i][DefColumns.MEASURE].ToString() == "FORMATION_YIELD") | CALL_EXT | siMain.SetDecimal | (viewRow, nIdxStart, viewRow, nIdxEnd, 2, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-6404b041 | (진입점 미연결) | SCP0060_ProductionPlan_JV.cs:2267 | catch ((Exception et)) | THROW | throw et; |  | 예외 발생 |  |  |  |
| AC-1f40d161 | (진입점 미연결) | SCP0060_ProductionPlan_JV.cs:2271 | finally | DATA_OP | dt.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |

## SCP0060_ProductionPlan_JV.Set_ProductResult

진입점: this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ if (showMsg) ▸ try] / this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >= 0) ▸ try] / FindButton [try] / EditButton [if (fps != null) ▸ if (fps.Name == "spdLine") ▸ if (fps.ActiveSheet.Columns.Get(xCol1).Visible == false)] / SaveButton [if (fps.Name == "spdLine") ▸ if (siLine != null && siMain.IsLock(SpdSheet.shtLine) == false) ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-71fef4c0 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 5 | SCP0060_ProductionPlan_JV.cs:2985 | if (int.Parse(p_from_yyyymmdd.ToString()) < int.Parse(p_plan_start_yyyymmdd.ToString())) ▸ if (resultIdx != -1) | GRID_STYLE | spdInfo.SetBGColor2 | (0, spdInfo.nIdxData + 1, spdInfo.ActiveSheet.RowCount - 1, resultIdx, Color.FromArgb(234,… | 그리드 표시 설정 |  |  |  |

## SCP0060_ProductionPlan_JV.SetChangedControl

진입점: this.Load / cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d6ac6f4a | this.Load 외 1 | SCP0060_ProductionPlan_JV.cs:995 |  | LIST_CLEAR | clbPlantSite.Items.Clear | () | 목록 항목 비움 |  |  |  |
| AC-02b5b1ff | this.Load 외 1 | SCP0060_ProductionPlan_JV.cs:996 |  | UI_PROP | clbPlantSite.ALL_VIEW | false | 속성 ALL_VIEW 설정 |  |  |  |
| AC-5f004e01 | this.Load 외 1 | SCP0060_ProductionPlan_JV.cs:1001 | if (division.Substring(0, 2).Equals("EE")) | FLAG | dtOperationGroup | Data_SCP.Common(Data_SCP.Type.OperationGroupEE, false) | 화면 필드/플래그 변경 |  |  |  |
| AC-ee5ebfbb | this.Load 외 1 | SCP0060_ProductionPlan_JV.cs:1001 | if (division.Substring(0, 2).Equals("EE")) | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.OperationGroupEE, false) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-41c7d789 | this.Load 외 1 | SCP0060_ProductionPlan_JV.cs:1003 | else of (division.Substring(0, 2).Equals("EE")) | FLAG | dtOperationGroup | Data_SCP.Common(Data_SCP.Type.OperationGroup, false) | 화면 필드/플래그 변경 |  |  |  |
| AC-238219a8 | this.Load 외 1 | SCP0060_ProductionPlan_JV.cs:1003 | else of (division.Substring(0, 2).Equals("EE")) | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.OperationGroup, false) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-fbaa2f2c | this.Load 외 1 | SCP0060_ProductionPlan_JV.cs:1004 |  | LIST_REBIND | clsCtrl.setListBox | (dtOperationGroup, cboOperationGroup, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-2e88cdd0 | this.Load 외 1 | SCP0060_ProductionPlan_JV.cs:1012 | if (!division.Substring(0, 2).Equals("EE")) | CALL_EXT | dic_JV_Plant.TryGetValue | (division, out get_JV_Value) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d7638393 | this.Load 외 1 | SCP0060_ProductionPlan_JV.cs:1017 | if (!division.Substring(0, 2).Equals("EE")) ▸ if (get_JV_Value != "") | FLAG | dtPlantSiteByDivision | Data.Common(Data.Type.PlantByDivisionOperation, false, division, pOperationGroup, "JV Plan… ⇒ biz:CommonData.CommonDataList [code=PlantByDivisionOperation] | 화면 필드/플래그 변경 |  |  |  |
| AC-aaf26cc3 | this.Load 외 1 | SCP0060_ProductionPlan_JV.cs:1017 | if (!division.Substring(0, 2).Equals("EE")) ▸ if (get_JV_Value != "") | COMBO_DATA | Data.Common | (Data.Type.PlantByDivisionOperation, false, division, pOperationGroup, "JV Planner", get_J… ⇒ biz:CommonData.CommonDataList [code=PlantByDivisionOperation] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-af59f874 | this.Load 외 1 | SCP0060_ProductionPlan_JV.cs:1021 | if (!division.Substring(0, 2).Equals("EE")) ▸ else of (get_JV_Value != "") | FLAG | dtPlantSiteByDivision | Data.Common(Data.Type.PlantByDivisionOperation, false, "9999!!!!", pOperationGroup, "JV Pl… ⇒ biz:CommonData.CommonDataList [code=PlantByDivisionOperation] | 화면 필드/플래그 변경 |  |  |  |
| AC-2bdb250c | this.Load 외 1 | SCP0060_ProductionPlan_JV.cs:1021 | if (!division.Substring(0, 2).Equals("EE")) ▸ else of (get_JV_Value != "") | COMBO_DATA | Data.Common | (Data.Type.PlantByDivisionOperation, false, "9999!!!!", pOperationGroup, "JV Planner", get… ⇒ biz:CommonData.CommonDataList [code=PlantByDivisionOperation] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-fd52134a | this.Load 외 1 | SCP0060_ProductionPlan_JV.cs:1028 | else of (!division.Substring(0, 2).Equals("EE")) | CALL_EXT | dic_JV_Plant.TryGetValue | (division, out get_JV_Value) | ⚠ 의미 확인 필요 |  |  |  |
| AC-35241e38 | this.Load 외 1 | SCP0060_ProductionPlan_JV.cs:1042 | else of (!division.Substring(0, 2).Equals("EE")) ▸ if (get_JV_Value != "") | FLAG | dtPlantSiteByDivision | Data_SCP.Common(Data_SCP.Type.PlantSiteProdPlan, false, division, pOperationGroup, "JV Pla… | 화면 필드/플래그 변경 |  |  |  |
| AC-e0b7c92d | this.Load 외 1 | SCP0060_ProductionPlan_JV.cs:1042 | else of (!division.Substring(0, 2).Equals("EE")) ▸ if (get_JV_Value != "") | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.PlantSiteProdPlan, false, division, pOperationGroup, "JV Planner", get_JV_V… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-fc388b42 | this.Load 외 1 | SCP0060_ProductionPlan_JV.cs:1046 | else of (!division.Substring(0, 2).Equals("EE")) ▸ else of (get_JV_Value != "") | FLAG | dtPlantSiteByDivision | Data_SCP.Common(Data_SCP.Type.PlantSiteProdPlan, false, division, pOperationGroup, "JV Pla… | 화면 필드/플래그 변경 |  |  |  |
| AC-345d2ef6 | this.Load 외 1 | SCP0060_ProductionPlan_JV.cs:1046 | else of (!division.Substring(0, 2).Equals("EE")) ▸ else of (get_JV_Value != "") | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.PlantSiteProdPlan, false, division, pOperationGroup, "JV Planner", "9999!!!… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-3e59371d | this.Load 외 1 | SCP0060_ProductionPlan_JV.cs:1052 | if (dtPlantSiteByDivision.Rows.Count < 1) | UI_PROP | clbPlantSite.ALL_VIEW | false | 속성 ALL_VIEW 설정 |  |  |  |
| AC-c0daf562 | this.Load 외 1 | SCP0060_ProductionPlan_JV.cs:1053 | else of (dtPlantSiteByDivision.Rows.Count < 1) | UI_PROP | clbPlantSite.ALL_VIEW | true | 속성 ALL_VIEW 설정 |  |  |  |
| AC-5fbf9966 | this.Load 외 1 | SCP0060_ProductionPlan_JV.cs:1057 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlantSiteByDivision, clbPlantSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-13bcb792 | this.Load 외 1 | SCP0060_ProductionPlan_JV.cs:1061 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | FLAG | dtPlanDate | Data.Common(Data.Type.PlanDate, false, division) ⇒ biz:CommonData.CommonDataList [code=PlanDate] | 화면 필드/플래그 변경 |  |  |  |
| AC-a03daea2 | this.Load 외 1 | SCP0060_ProductionPlan_JV.cs:1061 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | COMBO_DATA | Data.Common | (Data.Type.PlanDate, false, division) ⇒ biz:CommonData.CommonDataList [code=PlanDate] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-7579eb37 | this.Load 외 1 | SCP0060_ProductionPlan_JV.cs:1062 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | LIST_REBIND | clsCtrl.setListBox | (dtPlanDate, cboPlanDate, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-fa19c6a5 | this.Load 외 1 | SCP0060_ProductionPlan_JV.cs:1066 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | FLAG | dtPlanType | Data.Common(Data.Type.PlanType, false, division, pPlanDate) ⇒ biz:CommonData.CommonDataList [code=PlanType] | 화면 필드/플래그 변경 |  |  |  |
| AC-0979308e | this.Load 외 1 | SCP0060_ProductionPlan_JV.cs:1066 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | COMBO_DATA | Data.Common | (Data.Type.PlanType, false, division, pPlanDate) ⇒ biz:CommonData.CommonDataList [code=PlanType] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-bc206533 | this.Load 외 1 | SCP0060_ProductionPlan_JV.cs:1067 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | LIST_REBIND | clsCtrl.setListBox | (dtPlanType, cboPlanType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-56bb69cf | this.Load 외 1 | SCP0060_ProductionPlan_JV.cs:1068 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ if (dtPlanType.Rows.Count > 0) | VALUE_SET | cboPlanType.SelectedIndex | dtPlanType.Rows.Count - 1 | 컨트롤 값 설정 |  |  |  |
| AC-685c403e | this.Load 외 1 | SCP0060_ProductionPlan_JV.cs:1071 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | FLAG | dtPlanSeq | Data.Common(Data.Type.PlanSeq, false, division, pPlanDate, pPlanType) ⇒ biz:CommonData.CommonDataList [code=PlanSeq] | 화면 필드/플래그 변경 |  |  |  |
| AC-d8c43c2a | this.Load 외 1 | SCP0060_ProductionPlan_JV.cs:1071 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | COMBO_DATA | Data.Common | (Data.Type.PlanSeq, false, division, pPlanDate, pPlanType) ⇒ biz:CommonData.CommonDataList [code=PlanSeq] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-3542fc08 | this.Load 외 1 | SCP0060_ProductionPlan_JV.cs:1072 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | LIST_REBIND | clsCtrl.setListBox | (dtPlanSeq, cboPlanSeq, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-681e4aaf | this.Load 외 1 | SCP0060_ProductionPlan_JV.cs:1081 | if (siMain != null) | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |
| AC-131cb23a | this.Load 외 1 | SCP0060_ProductionPlan_JV.cs:1082 | if (siLine != null) | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdLine) | 그리드 데이터/선택 비움 |  |  |  |
| AC-0d4a5f61 | this.Load 외 1 | SCP0060_ProductionPlan_JV.cs:1086 | if (!division.Substring(0, 2).Equals("EE")) | VALUE_CLEAR | cboElectrode.ControlValues | "" | 컨트롤 값 비움 |  |  |  |
| AC-f44d55f2 | this.Load 외 1 | SCP0060_ProductionPlan_JV.cs:1087 | if (!division.Substring(0, 2).Equals("EE")) | STATE | cboElectrode.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-62c8cc01 | this.Load 외 1 | SCP0060_ProductionPlan_JV.cs:1091 | else of (!division.Substring(0, 2).Equals("EE")) | STATE | cboElectrode.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## SCP0060_ProductionPlan_JV.SetChangedPeriod

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-782ed98a | (진입점 미연결) | SCP0060_ProductionPlan_JV.cs:3247 | if (string.IsNullOrEmpty(strcboPlanDate)) | COMBO_DATA | Data.CallBizCommonData | ("PERIOD_" + value) ⇒ biz:CommonData.CommonDataList [code=PERIOD_{p:value}] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-6cf92b23 | (진입점 미연결) | SCP0060_ProductionPlan_JV.cs:3251 | else of (string.IsNullOrEmpty(strcboPlanDate)) | COMBO_DATA | Data.CallBizCommonData | ("PERIOD2_" + value, strcboPlanDate) ⇒ biz:CommonData.CommonDataList [code=PERIOD2_{p:value}] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-db04a35f | (진입점 미연결) | SCP0060_ProductionPlan_JV.cs:3254 | if (dt == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-caffb56d | (진입점 미연결) | SCP0060_ProductionPlan_JV.cs:3258 | if (dt.Rows.Count > 0) | UI_PROP | drpPeriod.Text1 | dt.Rows[0]["FROM_VALUE"].ToString() | 속성 Text1 설정 |  |  |  |
| AC-94189b8a | (진입점 미연결) | SCP0060_ProductionPlan_JV.cs:3259 | if (dt.Rows.Count > 0) | UI_PROP | drpPeriod.Text2 | dt.Rows[0]["TO_VALUE"].ToString() | 속성 Text2 설정 |  |  |  |

## SCP0060_ProductionPlan_JV.SetDataTableDateColumn

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-82ce369d | (진입점 미연결) | SCP0060_ProductionPlan_JV.cs:529 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) | DATA_OP | dt.Columns.Add | (column) | 데이터 객체 조작/조회 |  |  |  |

## SCP0060_ProductionPlan_JV.SetDataTableQtyData

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-12c57175 | (진입점 미연결) | SCP0060_ProductionPlan_JV.cs:547 | for (i < source.Rows.Count) ▸ for (j < source.Columns.Count) ▸ if (columnName.IndexOf("D_") == 0) | GRID_SET | target.Rows[i][columnName] | source.Rows[i][columnName] | 그리드 속성/값 설정 |  |  |  |
| AC-a91c6aab | (진입점 미연결) | SCP0060_ProductionPlan_JV.cs:570 |  | DATA_OP | target.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |

## SCP0060_ProductionPlan_JV.SetFormationYield

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c6c4257f | (진입점 미연결) | SCP0060_ProductionPlan_JV.cs:2324 | for (nCol < dt.Columns.Count) ▸ if (dt.Columns[nCol].ColumnName.IndexOf("M_") == 0) | DATA_OP | listMonth.Add | (nCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-96eb4722 | (진입점 미연결) | SCP0060_ProductionPlan_JV.cs:2328 | for (nCol < dt.Columns.Count) ▸ if (dt.Columns[nCol].ColumnName.IndexOf("W_") == 0) | DATA_OP | listWeek.Add | (nCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-453d3d6f | (진입점 미연결) | SCP0060_ProductionPlan_JV.cs:2386 | for (nRow < dt.Rows.Count) ▸ if (strMeasure == "FORMATION_YIELD") ▸ for (nCol < dt.Columns.Count) ▸ if (nCol == dt.Columns.Count - 1 \|\| dt… | DATA_OP | dr[nIdxWeek] | weekSum / nCntDayOfWeek | 행/컬럼 값 대입 |  |  |  |
| AC-3f68a0e9 | (진입점 미연결) | SCP0060_ProductionPlan_JV.cs:2400 | for (nRow < dt.Rows.Count) ▸ if (strMeasure == "FORMATION_YIELD") ▸ for (nCol < dt.Columns.Count) ▸ if (nCol == dt.Columns.Count - 1 \|\| dt… | DATA_OP | dr[nIdxMonth] | monthSum / nCntDayOfMonth | 행/컬럼 값 대입 |  |  |  |
| AC-ef2cc7ab | (진입점 미연결) | SCP0060_ProductionPlan_JV.cs:2408 | for (nRow < dt.Rows.Count) ▸ if (strMeasure == "FORMATION_YIELD") ▸ for (nCol < dt.Columns.Count) | CALL_EXT | siMain.SetDecimal | (nRow, nIdxStart, nRow, nIdxEnd, 2, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c74364bb | (진입점 미연결) | SCP0060_ProductionPlan_JV.cs:2417 |  | DATA_OP | dt.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |

## SCP0060_ProductionPlan_JV.SetFormationYield1

진입점: this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ if (showMsg) ▸ try] / FindButton [try] / SaveButton [if (fps.Name == "spdLine") ▸ if (siLine != null && siMain.IsLock(SpdSheet.shtLine) == false) ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ if (showMsg) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-feb30818 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0060_ProductionPlan_JV.cs:2297 | for (nRow < dt.Rows.Count) ▸ if (strMeasure == "FORMATION_YIELD") | CALL_EXT | siMain.SetDecimal | (nRow, nIdxStart, nRow, nIdxEnd, 2, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-89de044f | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0060_ProductionPlan_JV.cs:2301 |  | DATA_OP | dt.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |

## SCP0060_ProductionPlan_JV.SetLockSumColumn

진입점: EditButton [if (fps != null) ▸ if (fps.Name == "spdLine")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-46142640 | EditButton [if (fps != null) ▸ if (fps.Name == "spdLine")] | SCP0060_ProductionPlan_JV.cs:988 | for (iCol <= spreadInfo.GetMaxColumnIndex()) ▸ if (spreadInfo.GetColumnTag(iCol).IndexOf("W_") == 0 \|\| spreadInfo.GetColumnTag(iCol).Index… | GRID_LOCK | spreadInfo.LockRange | (0, iCol, spreadInfo.ActiveSheet.RowCount - 1, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |

## SCP0060_ProductionPlan_JV.SetPlanDataTableQtyData

진입점: this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ if (showMsg) ▸ try ▸ if (p_bucket.ToString().Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all)) ▸ if (dsBinding1 != null)] / FindButton [try ▸ if (p_bucket.ToString().Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all)) ▸ if (dsBinding1 != null)] / SaveButton [if (fps.Name == "spdLine") ▸ if (siLine != null && siMain.IsLock(SpdSheet.shtLine) == false) ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0]…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6040c078 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0060_ProductionPlan_JV.cs:3449 | for (i < target.Rows.Count) | DATA_OP | source.Select | (strFilter) | 데이터 객체 조작/조회 |  |  |  |
| AC-bc151894 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0060_ProductionPlan_JV.cs:3464 | for (i < target.Rows.Count) ▸ foreach (DataRow row in dataRows) ▸ for (j < source.Columns.Count) ▸ if (columnName.IndexOf("M_") == 0 \|\| co… | GRID_SET | target.Rows[i][columnName] | dTaraget + dSource | 그리드 속성/값 설정 |  |  |  |
| AC-b37f4297 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0060_ProductionPlan_JV.cs:3468 | for (i < target.Rows.Count) ▸ foreach (DataRow row in dataRows) ▸ for (j < source.Columns.Count) ▸ if (columnName.IndexOf("M_") == 0 \|\| co… | GRID_SET | target.Rows[i][columnName] | row[columnName] | 그리드 속성/값 설정 |  |  |  |
| AC-3290986f | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0060_ProductionPlan_JV.cs:3480 |  | DATA_OP | target.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |

## SCP0060_ProductionPlan_JV.SetSpreadColumn

진입점: this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ if (showMsg) ▸ try ▸ if (siMain.GetMaxRowIndex() > 0)] / this.Load / this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >= 0) ▸ try] / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (fps.Name == "spdMain") ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / this.cboBucketType.SelectedIndexChanged [if (fps != null) ▸ if (fps.Name == "spdMain") ▸ if (chkAll.Checked) ▸ if (siMain != null)] / this.chkSum.CheckedChanged [if (fps != null) ▸ if (fps.Name == "spdMain")] / FindBut…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-10775044 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 8 | SCP0060_ProductionPlan_JV.cs:927 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Daily) ▸ if (siObj.GetColumnTag(iCol).IndexOf("D_") … | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-754ecbe9 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 8 | SCP0060_ProductionPlan_JV.cs:932 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Daily) ▸ if (siObj.GetColumnTag(iCol).IndexOf("M_") … | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | chkSum.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-c698d34f | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 8 | SCP0060_ProductionPlan_JV.cs:939 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Buc… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-72a16aa3 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 8 | SCP0060_ProductionPlan_JV.cs:943 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Buc… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-2abba300 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 8 | SCP0060_ProductionPlan_JV.cs:948 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Buc… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | chkSum.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-5da880fe | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 8 | SCP0060_ProductionPlan_JV.cs:955 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ else of (cboBucketType.ControlValues =… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-e9a1a96d | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 8 | SCP0060_ProductionPlan_JV.cs:959 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ else of (cboBucketType.ControlValues =… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |

## SCP0060_ProductionPlan_JV.spdLine_CellDoubleClick

진입점: this.spdLine.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8faf86d3 | this.spdLine.CellDoubleClick | SCP0060_ProductionPlan_JV.cs:3134 |  | CALL_EXT | siLine.SetDblClickColumnShowHide | (sender, e) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0060_ProductionPlan_JV.SpdLine_Changed

진입점: dsdmLine.Changed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4a8751d6 | dsdmLine.Changed | SCP0060_ProductionPlan_JV.cs:3182 | if (!this.CanModelChange) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9ed4ebe3 | dsdmLine.Changed | SCP0060_ProductionPlan_JV.cs:3191 | if (ds == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1c245eb4 | dsdmLine.Changed | SCP0060_ProductionPlan_JV.cs:3199 | try ▸ if (ds == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a30a7025 | dsdmLine.Changed | SCP0060_ProductionPlan_JV.cs:3212 | catch ((Exception et)) | THROW | throw et; |  | 예외 발생 |  |  |  |

## SCP0060_ProductionPlan_JV.SpdLine_SelectionChanged

진입점: spdLine.SelectionChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-20cc9847 | spdLine.SelectionChanged | SCP0060_ProductionPlan_JV.cs:3170 | try | FLAG | nSelRowOfLine | spdLine.ActiveSheet.ActiveRow.Index | 화면 필드/플래그 변경 |  |  |  |
| AC-1f7e2196 | spdLine.SelectionChanged | SCP0060_ProductionPlan_JV.cs:3171 | try | FLAG | nSelColOfLine | spdLine.ActiveSheet.ActiveColumn.Index | 화면 필드/플래그 변경 |  |  |  |
| AC-641e5b6b | spdLine.SelectionChanged | SCP0060_ProductionPlan_JV.cs:3175 | catch ((Exception ex)) | FLAG | nSelRowOfLine | -1 | 화면 필드/플래그 변경 |  |  |  |
| AC-bfb34245 | spdLine.SelectionChanged | SCP0060_ProductionPlan_JV.cs:3176 | catch ((Exception ex)) | FLAG | nSelColOfLine | -1 | 화면 필드/플래그 변경 |  |  |  |

## SCP0060_ProductionPlan_JV.SpdLine_TopChange

진입점: this.spdLine.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cfe3048f | this.spdLine.TopChange | SCP0060_ProductionPlan_JV.cs:608 |  | GRID_INIT | siLine.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0060_ProductionPlan_JV.SpdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2f67fa0e | this.spdMain.CellDoubleClick | SCP0060_ProductionPlan_JV.cs:3116 | if (!chkAll.Checked && e.ColumnHeader) ▸ if ((siMain.GetColumnTag(e.Column).IndexOf("M_") == 0 && BucketType.Monthly == sBucketType) \|\| (s… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-90890f02 | this.spdMain.CellDoubleClick | SCP0060_ProductionPlan_JV.cs:3119 |  | CALL_EXT | siMain.SetDblClickColumnShowHide | (sender, e) | ⚠ 의미 확인 필요 |  |  |  |
| AC-5e4f4b1b | this.spdMain.CellDoubleClick | SCP0060_ProductionPlan_JV.cs:3123 | if (!e.ColumnHeader && e.Row >= 0) | FLAG | nSelRowOfMain | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-3af6c254 | this.spdMain.CellDoubleClick | SCP0060_ProductionPlan_JV.cs:3124 | if (!e.ColumnHeader && e.Row >= 0) | FLAG | nSelColOfMain | e.Column | 화면 필드/플래그 변경 |  |  |  |

## SCP0060_ProductionPlan_JV.SpdMain_TopChange

진입점: this.spdMain.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-92139005 | this.spdMain.TopChange | SCP0060_ProductionPlan_JV.cs:615 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

