# AS-IS 액션 대조표 — SSP0009

> 원천: `Doc/asisfacts/screens/SSP0009/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 511행 · 메서드 43 · 종류 DATA_OP 221 · GRID_SET 37 · UI_PROP 31 · GRID_INIT 30 · RETURN 27 · POPUP 20 · ENDPOINT 20 · UI_MISC 19 · FLAG 17 · MESSAGE 16 · CALL_EXT 14 · GRID_LOCK 9 · LIST_REBIND 9 · GRID_CLEAR 9 · VALUE_SET 8 · STATE 8 · COMBO_DATA 7 · GRID_BIND 4 · VALIDATE 3 · GRID_STYLE 1 · VALUE_CLEAR 1 · ⚠ 의미 확인 필요 14


## SSP0009_Shipment_Plan_FG.BlockCellsChecking

진입점: this.spdMain.CellClick [if ((e.Column == siMain.GetColumnIndex(DefMain.TRANSPORT_MODE) \|\| e.Column == siMain.GetColumnIndex(DefMain.FROM_SITE_NAME))…)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-570c78a8 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SSP0009_Shipment_Plan_FG.cs:1682 | for (iRow < siMain.ActiveSheet.Rows.Count) | GRID_LOCK | siMain.LockRange | (iRow, 1, iRow, this._LastHeader_Idx, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-99fef271 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SSP0009_Shipment_Plan_FG.cs:1694 | for (iRow < siMain.ActiveSheet.Rows.Count) ▸ if (siMain.GetValue(iRow, measure_idx).ToString().Equals("SHIP_PLAN_AMEND") && !siMain.GetValue… | GRID_LOCK | siMain.LockRange | (iRow, this._LastHeader_Idx, iRow, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-192f2240 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SSP0009_Shipment_Plan_FG.cs:1706 | for (iRow < siMain.ActiveSheet.Rows.Count) ▸ if (siMain.GetValue(iRow, measure_idx).ToString().Equals("SHIP_PLAN_AMEND") && !siMain.GetValue… | GRID_LOCK | siMain.LockRange | (iRow, iCol, iRow, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-9242eff6 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SSP0009_Shipment_Plan_FG.cs:1713 | for (iRow < siMain.ActiveSheet.Rows.Count) ▸ if (siMain.GetValue(iRow, measure_idx).ToString().Equals("SHIP_PLAN_AMEND") && !siMain.GetValue… | GRID_LOCK | siMain.LockRange | (iRow, iCol, iRow, iCol, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-864cfefd | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SSP0009_Shipment_Plan_FG.cs:1717 | for (iRow < siMain.ActiveSheet.Rows.Count) ▸ if (siMain.GetValue(iRow, measure_idx).ToString().Equals("SHIP_PLAN_AMEND") && !siMain.GetValue… | GRID_LOCK | siMain.LockRange | (iRow, iCol, iRow, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-821e3317 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SSP0009_Shipment_Plan_FG.cs:1723 | for (iRow < siMain.ActiveSheet.Rows.Count) ▸ else of (siMain.GetValue(iRow, measure_idx).ToString().Equals("SHIP_PLAN_AMEND") && !siMain.Get… | GRID_LOCK | siMain.LockRange | (iRow, this._LastHeader_Idx, iRow, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |

## SSP0009_Shipment_Plan_FG.BtnColumn_Click

진입점: this.btnColumn.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2af2c50a | this.btnColumn.Click | SSP0009_Shipment_Plan_FG.cs:682 |  | POPUP | new SCM0002_TitleSetForm_Popup | ("SSP0009", SpdSheet.shtMain, true) | 팝업/폼 생성 |  |  |  |
| AC-67577161 | this.btnColumn.Click | SSP0009_Shipment_Plan_FG.cs:683 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-f6d910cb | this.btnColumn.Click | SSP0009_Shipment_Plan_FG.cs:684 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## SSP0009_Shipment_Plan_FG.BtnFix_Click

진입점: this.btnFix.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-de4dc7ba | this.btnFix.Click | SSP0009_Shipment_Plan_FG.cs:707 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b88f535e | this.btnFix.Click | SSP0009_Shipment_Plan_FG.cs:708 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d2d43df0 | this.btnFix.Click | SSP0009_Shipment_Plan_FG.cs:713 | if (fps != null) ▸ if (dsBinding.Tables.Count == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7226c090 | this.btnFix.Click | SSP0009_Shipment_Plan_FG.cs:716 | if (fps != null) ▸ if (siMain.IsLock(siMain.SheetName)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00010") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SSP0009_Shipment_Plan_FG.BtnItem_Id_Click

진입점: this.btnItem_Id.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-18d99bac | this.btnItem_Id.Click | SSP0009_Shipment_Plan_FG.cs:2541 |  | POPUP | new SCM0002_ItembyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-a6338b07 | this.btnItem_Id.Click | SSP0009_Shipment_Plan_FG.cs:2543 |  | POPUP | popItem.Form_Load | (true, sdivision, sScmSite, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-591d4535 | this.btnItem_Id.Click | SSP0009_Shipment_Plan_FG.cs:2544 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-9ab9aadc | this.btnItem_Id.Click | SSP0009_Shipment_Plan_FG.cs:2545 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-3e081891 | this.btnItem_Id.Click | SSP0009_Shipment_Plan_FG.cs:2550 | if (popItem.ItemID != "") | VALUE_SET | txtItem_Id.Text | sItemId | 컨트롤 값 설정 |  |  |  |

## SSP0009_Shipment_Plan_FG.btnMeasure_Click

진입점: this.btnMeasure.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-81f67b8d | this.btnMeasure.Click | SSP0009_Shipment_Plan_FG.cs:2576 |  | POPUP | new SCM0002_TitleSetForm_Popup | ("SSP0009", measure, false) | 팝업/폼 생성 |  |  |  |
| AC-14a4265f | this.btnMeasure.Click | SSP0009_Shipment_Plan_FG.cs:2577 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-a872c9be | this.btnMeasure.Click | SSP0009_Shipment_Plan_FG.cs:2578 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-e6ead667 | this.btnMeasure.Click | SSP0009_Shipment_Plan_FG.cs:2581 | if (frm.DialogResult == DialogResult.OK) | UI_PROP | this.CanModelChange | false | 속성 CanModelChange 설정 |  |  |  |
| AC-b3643606 | this.btnMeasure.Click | SSP0009_Shipment_Plan_FG.cs:2584 | if (frm.DialogResult == DialogResult.OK) | UI_PROP | this.CanModelChange | true | 속성 CanModelChange 설정 |  |  |  |

## SSP0009_Shipment_Plan_FG.BtnProject_Click

진입점: this.btnProject.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2183115f | this.btnProject.Click | SSP0009_Shipment_Plan_FG.cs:2561 |  | POPUP | new SCM0002_ProjectbyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-70d2d14c | this.btnProject.Click | SSP0009_Shipment_Plan_FG.cs:2563 |  | POPUP | popProject.Form_Load | (true, sDivision, sProject) | 팝업 초기화(인자 전달) |  |  |  |
| AC-9bf72201 | this.btnProject.Click | SSP0009_Shipment_Plan_FG.cs:2564 |  | UI_PROP | popProject.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-14b19765 | this.btnProject.Click | SSP0009_Shipment_Plan_FG.cs:2565 |  | POPUP | popProject.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-70c4e5a0 | this.btnProject.Click | SSP0009_Shipment_Plan_FG.cs:2570 | if (popProject.ProjectCode != "") | VALUE_SET | txtProject.Text | sProjectCode | 컨트롤 값 설정 |  |  |  |

## SSP0009_Shipment_Plan_FG.BtnUnfix_Click

진입점: this.btnUnfix.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c8ae5c8f | this.btnUnfix.Click | SSP0009_Shipment_Plan_FG.cs:728 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f6af1e4d | this.btnUnfix.Click | SSP0009_Shipment_Plan_FG.cs:729 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8dc625a6 | this.btnUnfix.Click | SSP0009_Shipment_Plan_FG.cs:734 | if (fps != null) ▸ if (dsBinding.Tables.Count == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-da60237a | this.btnUnfix.Click | SSP0009_Shipment_Plan_FG.cs:737 | if (fps != null) ▸ if (siMain.IsLock(siMain.SheetName)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00010") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-930e99c6 | this.btnUnfix.Click | SSP0009_Shipment_Plan_FG.cs:740 | if (fps != null) ▸ else of (siMain.IsLock(siMain.SheetName)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00016") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SSP0009_Shipment_Plan_FG.CboPlanDate_SelectedIndexChanged

진입점: cboPlanDate.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2f2b9011 | cboPlanDate.SelectedIndexChanged | SSP0009_Shipment_Plan_FG.cs:804 |  | FLAG | dtPlanType | Data.Common(Data.Type.PlanTypeShip, false, pDivisionID, pPlanDate) ⇒ biz:CommonData.CommonDataList [code=PlanTypeShip] | 화면 필드/플래그 변경 |  |  |  |
| AC-863796aa | cboPlanDate.SelectedIndexChanged | SSP0009_Shipment_Plan_FG.cs:804 |  | COMBO_DATA | Data.Common | (Data.Type.PlanTypeShip, false, pDivisionID, pPlanDate) ⇒ biz:CommonData.CommonDataList [code=PlanTypeShip] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c249f0a7 | cboPlanDate.SelectedIndexChanged | SSP0009_Shipment_Plan_FG.cs:805 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanType, cboPlanType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-44f7ea49 | cboPlanDate.SelectedIndexChanged | SSP0009_Shipment_Plan_FG.cs:807 |  | VALUE_SET | cboPlanType.SelectedIndex | dtPlanType.Rows.Count - 1 | 컨트롤 값 설정 |  |  |  |
| AC-0668336a | cboPlanDate.SelectedIndexChanged | SSP0009_Shipment_Plan_FG.cs:811 |  | VALUE_SET | drpPeriod.InitValue | GetDayRange() | 컨트롤 값 설정 |  |  |  |
| AC-8af31afb | cboPlanDate.SelectedIndexChanged | SSP0009_Shipment_Plan_FG.cs:813 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |
| AC-f75445eb | cboPlanDate.SelectedIndexChanged | SSP0009_Shipment_Plan_FG.cs:815 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdPeggingInfo) | 그리드 데이터/선택 비움 |  |  |  |
| AC-893710ff | cboPlanDate.SelectedIndexChanged | SSP0009_Shipment_Plan_FG.cs:816 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdPlanProblem) | 그리드 데이터/선택 비움 |  |  |  |

## SSP0009_Shipment_Plan_FG.CboPlanSeq_SelectedIndexChanged

진입점: cboPlanSeq.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7cd387c8 | cboPlanSeq.SelectedIndexChanged | SSP0009_Shipment_Plan_FG.cs:695 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |
| AC-6f814518 | cboPlanSeq.SelectedIndexChanged | SSP0009_Shipment_Plan_FG.cs:697 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdPeggingInfo) | 그리드 데이터/선택 비움 |  |  |  |
| AC-21490680 | cboPlanSeq.SelectedIndexChanged | SSP0009_Shipment_Plan_FG.cs:698 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdPlanProblem) | 그리드 데이터/선택 비움 |  |  |  |

## SSP0009_Shipment_Plan_FG.CboPlanType_SelectedIndexChanged

진입점: cboPlanType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-be1721a5 | cboPlanType.SelectedIndexChanged | SSP0009_Shipment_Plan_FG.cs:824 |  | FLAG | dtPlanSeq | Data.Common(Data.Type.PlanSeqShip, false, pDivisionID, pPlanDate, pPlanType) ⇒ biz:CommonData.CommonDataList [code=PlanSeqShip] | 화면 필드/플래그 변경 |  |  |  |
| AC-1d541f1d | cboPlanType.SelectedIndexChanged | SSP0009_Shipment_Plan_FG.cs:824 |  | COMBO_DATA | Data.Common | (Data.Type.PlanSeqShip, false, pDivisionID, pPlanDate, pPlanType) ⇒ biz:CommonData.CommonDataList [code=PlanSeqShip] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-74d72ec9 | cboPlanType.SelectedIndexChanged | SSP0009_Shipment_Plan_FG.cs:825 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanSeq, cboPlanSeq, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-13cd0e85 | cboPlanType.SelectedIndexChanged | SSP0009_Shipment_Plan_FG.cs:827 |  | VALUE_SET | cboPlanSeq.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-a16f2807 | cboPlanType.SelectedIndexChanged | SSP0009_Shipment_Plan_FG.cs:833 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |
| AC-af16e29a | cboPlanType.SelectedIndexChanged | SSP0009_Shipment_Plan_FG.cs:835 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdPeggingInfo) | 그리드 데이터/선택 비움 |  |  |  |
| AC-2cca6e98 | cboPlanType.SelectedIndexChanged | SSP0009_Shipment_Plan_FG.cs:836 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdPlanProblem) | 그리드 데이터/선택 비움 |  |  |  |

## SSP0009_Shipment_Plan_FG.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a11939fe | this.Load | SSP0009_Shipment_Plan_FG.cs:379 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 3, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-9476d68b | this.Load | SSP0009_Shipment_Plan_FG.cs:380 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-61e91a14 | this.Load | SSP0009_Shipment_Plan_FG.cs:381 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7d608933 | this.Load | SSP0009_Shipment_Plan_FG.cs:383 |  | GRID_INIT | this.AddSheet | (spdPeggingInfo, SpdSheet.shtPeggingInfo, SpdSheet.shtPeggingInfo, 1, 1, 50) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-6accee4f | this.Load | SSP0009_Shipment_Plan_FG.cs:384 |  | FLAG | siPeggingInfo | GetSheetInfo(spdPeggingInfo.Name, spdPeggingInfo.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-ae772d1a | this.Load | SSP0009_Shipment_Plan_FG.cs:386 |  | GRID_INIT | this.AddSheet | (spdPlanProblem, SpdSheet.shtPlanProblem, SpdSheet.shtPlanProblem, 1, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-f8077fee | this.Load | SSP0009_Shipment_Plan_FG.cs:387 |  | FLAG | siPlanProblem | GetSheetInfo(spdPlanProblem.Name, 0) | 화면 필드/플래그 변경 |  |  |  |

## SSP0009_Shipment_Plan_FG.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5134d9b5 | this.Load | SSP0009_Shipment_Plan_FG.cs:237 |  | UI_PROP | usrConditionPanel1.Height | 100 | 속성 Height 설정 |  |  |  |
| AC-7fed1ffa | this.Load | SSP0009_Shipment_Plan_FG.cs:238 |  | VALUE_SET | cboBucketType.SelectedValue | BucketType.Daily | 컨트롤 값 설정 |  |  |  |

## SSP0009_Shipment_Plan_FG.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-647cda74 | Dispose | SSP0009_Shipment_Plan_FG.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SSP0009_Shipment_Plan_FG.EditBlockChecking

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-19665deb | (진입점 미연결) | SSP0009_Shipment_Plan_FG.cs:1437 | if (number == 1) ▸ for (cols <= siMain.ActiveSheet.Columns.Count) | DATA_OP | dateColumn.Contains | ("W_") | 데이터 객체 조작/조회 |  |  |  |
| AC-b96a217f | (진입점 미연결) | SSP0009_Shipment_Plan_FG.cs:1440 | if (number == 1) ▸ for (cols <= siMain.ActiveSheet.Columns.Count) ▸ else of (dateColumn.Contains("W_")) | DATA_OP | dateColumn.Contains | ("D_") | 데이터 객체 조작/조회 |  |  |  |
| AC-50c7315c | (진입점 미연결) | SSP0009_Shipment_Plan_FG.cs:1462 | if (number == 1) | RETURN | return retIndex == 0 ? siMain.GetMaxColumnIndex() : retIndex; |  | 처리 중단/반환 |  |  |  |
| AC-3e2fa332 | (진입점 미연결) | SSP0009_Shipment_Plan_FG.cs:1469 |  | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |

## SSP0009_Shipment_Plan_FG.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5f81ea6a | EditButton | SSP0009_Shipment_Plan_FG.cs:848 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0ad3edc1 | EditButton | SSP0009_Shipment_Plan_FG.cs:849 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SSP0009_Shipment_Plan_FG.FindData_Main

진입점: FindButton / SaveButton [if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (iCount > 0) ▸ if (tran.Success)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6a86e336 | FindButton 외 1 | SSP0009_Shipment_Plan_FG.cs:897 |  | VALIDATE | DataUtil.checkRequired | (this.usrConditionPanel1) | 프레임워크 검증 |  |  |  |
| AC-94258450 | FindButton 외 1 | SSP0009_Shipment_Plan_FG.cs:897 | if (!DataUtil.checkRequired(this.usrConditionPanel1)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-09a8f5e2 | FindButton 외 1 | SSP0009_Shipment_Plan_FG.cs:898 |  | VALIDATE | DateUtil.Check_PeriodDate | (drpPeriod) | 프레임워크 검증 |  |  |  |
| AC-bd6410f9 | FindButton 외 1 | SSP0009_Shipment_Plan_FG.cs:898 | if (!DateUtil.Check_PeriodDate(drpPeriod)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-640e4ac6 | FindButton 외 1 | SSP0009_Shipment_Plan_FG.cs:934 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-fa1e7c21 | FindButton 외 1 | SSP0009_Shipment_Plan_FG.cs:936 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-5c2148a9 | FindButton 외 1 | SSP0009_Shipment_Plan_FG.cs:939 | try | CALL_EXT | DateUtil.MonthDiff | (p_to_yyyymmdd.ToString(), p_from_yyyymmdd.ToString()) | ⚠ 의미 확인 필요 |  |  |  |
| AC-8722674c | FindButton 외 1 | SSP0009_Shipment_Plan_FG.cs:954 | try | CALL_EXT | Parallel.For | (0, (nCnt), (i) => { if (i != nCnt-1) { string strStartDate = DateUtil.GetDateAdd(p_from_y… | ⚠ 의미 확인 필요 |  |  |  |
| AC-8bfeabf5 | FindButton 외 1 | SSP0009_Shipment_Plan_FG.cs:971 | try ▸ lambda ▸ if (i != nCnt-1) | ENDPOINT | new FoxDataRequest | ("SSP.SSP0009_GET_SHIPMENT_PLAN_FG") ⇒ SSP.SSP0009_GET_SHIPMENT_PLAN_FG | 엔드포인트 요청 생성 |  |  |  |
| AC-7d7fcad9 | FindButton 외 1 | SSP0009_Shipment_Plan_FG.cs:973 | try ▸ lambda ▸ if (i != nCnt-1) | UI_PROP | req.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-3fba1ec8 | FindButton 외 1 | SSP0009_Shipment_Plan_FG.cs:975 | try ▸ lambda ▸ if (i != nCnt-1) | DATA_OP | req.Parameters["p_from_yyyymmdd"] | strStartDate | 행/컬럼 값 대입 |  |  |  |
| AC-03f5b464 | FindButton 외 1 | SSP0009_Shipment_Plan_FG.cs:976 | try ▸ lambda ▸ if (i != nCnt-1) | DATA_OP | req.Parameters["p_to_yyyymmdd"] | strEndDate | 행/컬럼 값 대입 |  |  |  |
| AC-0cc0c71f | FindButton 외 1 | SSP0009_Shipment_Plan_FG.cs:977 | try ▸ lambda ▸ if (i != nCnt-1) | DATA_OP | req.Parameters["p_division_id"] | pDivisionID | 행/컬럼 값 대입 |  |  |  |
| AC-0d95bcb9 | FindButton 외 1 | SSP0009_Shipment_Plan_FG.cs:978 | try ▸ lambda ▸ if (i != nCnt-1) | DATA_OP | req.Parameters["p_biz_type"] | p_biz_type | 행/컬럼 값 대입 |  |  |  |
| AC-02fe550e | FindButton 외 1 | SSP0009_Shipment_Plan_FG.cs:979 | try ▸ lambda ▸ if (i != nCnt-1) | DATA_OP | req.Parameters["p_project_code"] | p_project_code | 행/컬럼 값 대입 |  |  |  |
| AC-62c97bb1 | FindButton 외 1 | SSP0009_Shipment_Plan_FG.cs:980 | try ▸ lambda ▸ if (i != nCnt-1) | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-2bff9d61 | FindButton 외 1 | SSP0009_Shipment_Plan_FG.cs:982 | try ▸ lambda ▸ if (i != nCnt-1) | DATA_OP | req.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-90dbc2f3 | FindButton 외 1 | SSP0009_Shipment_Plan_FG.cs:983 | try ▸ lambda ▸ if (i != nCnt-1) | DATA_OP | req.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-fbf13dd7 | FindButton 외 1 | SSP0009_Shipment_Plan_FG.cs:984 | try ▸ lambda ▸ if (i != nCnt-1) | DATA_OP | req.Parameters["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-0f8e4ad5 | FindButton 외 1 | SSP0009_Shipment_Plan_FG.cs:985 | try ▸ lambda ▸ if (i != nCnt-1) | DATA_OP | req.Parameters["p_program_id"] | "SSP0009" | 행/컬럼 값 대입 |  |  |  |
| AC-d15c4108 | FindButton 외 1 | SSP0009_Shipment_Plan_FG.cs:986 | try ▸ lambda ▸ if (i != nCnt-1) | DATA_OP | req.Parameters["p_sheet_name"] | p_sheet_name | 행/컬럼 값 대입 |  |  |  |
| AC-16cb45ec | FindButton 외 1 | SSP0009_Shipment_Plan_FG.cs:988 | try ▸ lambda ▸ if (i != nCnt-1) | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-278c9ba9 | FindButton 외 1 | SSP0009_Shipment_Plan_FG.cs:989 | try ▸ lambda ▸ if (i != nCnt-1) | DATA_OP | req.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-381262fe | FindButton 외 1 | SSP0009_Shipment_Plan_FG.cs:990 | try ▸ lambda ▸ if (i != nCnt-1) | DATA_OP | req.Parameters["p_electrode_type"] | p_electrode_type | 행/컬럼 값 대입 |  |  |  |
| AC-9132e3cb | FindButton 외 1 | SSP0009_Shipment_Plan_FG.cs:995 | try ▸ lambda ▸ if (i != nCnt-1) ▸ if (i == 0) | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-f469f4b9 | FindButton 외 1 | SSP0009_Shipment_Plan_FG.cs:998 | try ▸ lambda ▸ if (i != nCnt-1) ▸ else of (i == 0) ▸ if (i == 1) | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-9ac62b9d | FindButton 외 1 | SSP0009_Shipment_Plan_FG.cs:1001 | try ▸ lambda ▸ if (i != nCnt-1) ▸ else of (i == 0) ▸ else of (i == 1) ▸ if (i == 2) | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-3945d57f | FindButton 외 1 | SSP0009_Shipment_Plan_FG.cs:1008 | try ▸ lambda ▸ else of (i != nCnt-1) | ENDPOINT | new FoxDataRequest | ("SSP.SSP0009_GET_SHIPMENT_PLAN_FG_TITLE_PARAL") ⇒ SSP.SSP0009_GET_SHIPMENT_PLAN_FG_TITLE_PARAL | 엔드포인트 요청 생성 |  |  |  |
| AC-19d2648c | FindButton 외 1 | SSP0009_Shipment_Plan_FG.cs:1010 | try ▸ lambda ▸ else of (i != nCnt-1) | UI_PROP | req.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-bae193f2 | FindButton 외 1 | SSP0009_Shipment_Plan_FG.cs:1011 | try ▸ lambda ▸ else of (i != nCnt-1) | DATA_OP | req.Parameters["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-702a7840 | FindButton 외 1 | SSP0009_Shipment_Plan_FG.cs:1012 | try ▸ lambda ▸ else of (i != nCnt-1) | DATA_OP | req.Parameters["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-ae6ccaec | FindButton 외 1 | SSP0009_Shipment_Plan_FG.cs:1013 | try ▸ lambda ▸ else of (i != nCnt-1) | DATA_OP | req.Parameters["p_division_id"] | pDivisionID | 행/컬럼 값 대입 |  |  |  |
| AC-8ee29de8 | FindButton 외 1 | SSP0009_Shipment_Plan_FG.cs:1014 | try ▸ lambda ▸ else of (i != nCnt-1) | DATA_OP | req.Parameters["p_biz_type"] | p_biz_type | 행/컬럼 값 대입 |  |  |  |
| AC-6b4e256d | FindButton 외 1 | SSP0009_Shipment_Plan_FG.cs:1015 | try ▸ lambda ▸ else of (i != nCnt-1) | DATA_OP | req.Parameters["p_project_code"] | p_project_code | 행/컬럼 값 대입 |  |  |  |
| AC-2b8f5b00 | FindButton 외 1 | SSP0009_Shipment_Plan_FG.cs:1016 | try ▸ lambda ▸ else of (i != nCnt-1) | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-eca0b309 | FindButton 외 1 | SSP0009_Shipment_Plan_FG.cs:1018 | try ▸ lambda ▸ else of (i != nCnt-1) | DATA_OP | req.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-92283796 | FindButton 외 1 | SSP0009_Shipment_Plan_FG.cs:1019 | try ▸ lambda ▸ else of (i != nCnt-1) | DATA_OP | req.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-51ca183e | FindButton 외 1 | SSP0009_Shipment_Plan_FG.cs:1020 | try ▸ lambda ▸ else of (i != nCnt-1) | DATA_OP | req.Parameters["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-ab4a206d | FindButton 외 1 | SSP0009_Shipment_Plan_FG.cs:1021 | try ▸ lambda ▸ else of (i != nCnt-1) | DATA_OP | req.Parameters["p_program_id"] | "SSP0009" | 행/컬럼 값 대입 |  |  |  |
| AC-a0fc5be1 | FindButton 외 1 | SSP0009_Shipment_Plan_FG.cs:1022 | try ▸ lambda ▸ else of (i != nCnt-1) | DATA_OP | req.Parameters["p_sheet_name"] | p_sheet_name | 행/컬럼 값 대입 |  |  |  |
| AC-657a79ec | FindButton 외 1 | SSP0009_Shipment_Plan_FG.cs:1024 | try ▸ lambda ▸ else of (i != nCnt-1) | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-1961b811 | FindButton 외 1 | SSP0009_Shipment_Plan_FG.cs:1025 | try ▸ lambda ▸ else of (i != nCnt-1) | DATA_OP | req.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-4f8fa369 | FindButton 외 1 | SSP0009_Shipment_Plan_FG.cs:1026 | try ▸ lambda ▸ else of (i != nCnt-1) | DATA_OP | req.Parameters["p_electrode_type"] | p_electrode_type | 행/컬럼 값 대입 |  |  |  |
| AC-596b354f | FindButton 외 1 | SSP0009_Shipment_Plan_FG.cs:1028 | try ▸ lambda ▸ else of (i != nCnt-1) | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-ff5c2927 | FindButton 외 1 | SSP0009_Shipment_Plan_FG.cs:1034 | try | FLAG | dsBinding | dsTitle.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-7ed2f8f6 | FindButton 외 1 | SSP0009_Shipment_Plan_FG.cs:1034 | try | DATA_OP | dsTitle.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-14a3dc2d | FindButton 외 1 | SSP0009_Shipment_Plan_FG.cs:1035 | try | UI_MISC | dsTitle.Dispose | () | 창 닫기/해제 |  |  |  |
| AC-5bece894 | FindButton 외 1 | SSP0009_Shipment_Plan_FG.cs:1040 | try ▸ if (dsBinding1 != null) | CALL_EXT | DataUtil.SetDataTableQtyData | (dsBinding.Tables[0], dsBinding1.Tables[0]) | ⚠ 의미 확인 필요 |  |  |  |
| AC-874f340e | FindButton 외 1 | SSP0009_Shipment_Plan_FG.cs:1041 | try ▸ if (dsBinding2 != null) | CALL_EXT | DataUtil.SetDataTableQtyData | (dsBinding.Tables[0], dsBinding2.Tables[0]) | ⚠ 의미 확인 필요 |  |  |  |
| AC-bef3fd9c | FindButton 외 1 | SSP0009_Shipment_Plan_FG.cs:1042 | try ▸ if (dsBinding3 != null) | CALL_EXT | DataUtil.SetDataTableQtyData | (dsBinding.Tables[0], dsBinding3.Tables[0]) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c99cc0f8 | FindButton 외 1 | SSP0009_Shipment_Plan_FG.cs:1076 | try ▸ if (dsBinding.Tables[0].Rows.Count > 0) | GRID_BIND | siMain.Query | (dsBinding) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-22350c3f | FindButton 외 1 | SSP0009_Shipment_Plan_FG.cs:1079 | try ▸ if (dsBinding.Tables[0].Rows.Count > 0) | FLAG | this._IsEditable | "N" | 화면 필드/플래그 변경 |  |  |  |
| AC-7bbe4ae7 | FindButton 외 1 | SSP0009_Shipment_Plan_FG.cs:1090 | try ▸ if (dsBinding.Tables[0].Rows.Count > 0) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-c764246a | FindButton 외 1 | SSP0009_Shipment_Plan_FG.cs:1095 | try ▸ if (dsBinding.Tables[0].Rows.Count > 0) | UI_MISC | SetSearchCount | (dsBinding) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-22ec635a | FindButton 외 1 | SSP0009_Shipment_Plan_FG.cs:1113 | try ▸ if (dsBinding.Tables[0].Rows.Count > 0) | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3123c6f6 | FindButton 외 1 | SSP0009_Shipment_Plan_FG.cs:1116 | try ▸ else of (dsBinding.Tables[0].Rows.Count > 0) | GRID_BIND | siMain.Query | (dsBinding) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-1bf6565e | FindButton 외 1 | SSP0009_Shipment_Plan_FG.cs:1119 | try | UI_MISC | SetSearchCount | (dsBinding) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-6ad9db28 | FindButton 외 1 | SSP0009_Shipment_Plan_FG.cs:1122 | catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-28353971 | FindButton 외 1 | SSP0009_Shipment_Plan_FG.cs:1125 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e7fcf4ad | FindButton 외 1 | SSP0009_Shipment_Plan_FG.cs:1127 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-0cd50cb5 | FindButton 외 1 | SSP0009_Shipment_Plan_FG.cs:1128 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## SSP0009_Shipment_Plan_FG.FindData_PeggingInfo

진입점: this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >= 0) ▸ if (siMain.GetValue(e.Row, siMain.GetColumnIndex(DefMain.MEASURE)).ToString().Equals("MKT_FCST"))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5a845cd9 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SSP0009_Shipment_Plan_FG.cs:2278 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-1afef6b8 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SSP0009_Shipment_Plan_FG.cs:2280 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-33eec1d8 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SSP0009_Shipment_Plan_FG.cs:2283 | try | UI_PROP | proxyPivot.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-f94bb062 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SSP0009_Shipment_Plan_FG.cs:2285 | try | ENDPOINT | proxyPivot.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, GSCM_SSP_PLAN_S… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-5da0b1b9 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SSP0009_Shipment_Plan_FG.cs:2287 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SSP.SSP0009_GET_SHIPMENT_PLAN_FG_PEGGING") ⇒ SSP.SSP0009_GET_SHIPMENT_PLAN_FG_PEGGING | 엔드포인트 요청 생성 |  |  |  |
| AC-15506701 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SSP0009_Shipment_Plan_FG.cs:2288 | try ▸ lambda | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-d8fe7882 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SSP0009_Shipment_Plan_FG.cs:2289 | try ▸ lambda | DATA_OP | req.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-97a38910 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SSP0009_Shipment_Plan_FG.cs:2290 | try ▸ lambda | DATA_OP | req.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-f5fed826 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SSP0009_Shipment_Plan_FG.cs:2291 | try ▸ lambda | DATA_OP | req.Parameters["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-78ac3380 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SSP0009_Shipment_Plan_FG.cs:2292 | try ▸ lambda | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-1d1c1f5e | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SSP0009_Shipment_Plan_FG.cs:2293 | try ▸ lambda | DATA_OP | req.Parameters["p_biz_type"] | p_biz_type | 행/컬럼 값 대입 |  |  |  |
| AC-3112c481 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SSP0009_Shipment_Plan_FG.cs:2294 | try ▸ lambda | DATA_OP | req.Parameters["p_to_site"] | p_to_site | 행/컬럼 값 대입 |  |  |  |
| AC-92146379 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SSP0009_Shipment_Plan_FG.cs:2295 | try ▸ lambda | DATA_OP | req.Parameters["p_duedate"] | p_duedate | 행/컬럼 값 대입 |  |  |  |
| AC-1076a4d8 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SSP0009_Shipment_Plan_FG.cs:2296 | try ▸ lambda | DATA_OP | req.Parameters["p_project_code"] | p_project_code | 행/컬럼 값 대입 |  |  |  |
| AC-a0b03030 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SSP0009_Shipment_Plan_FG.cs:2297 | try ▸ lambda | DATA_OP | req.Parameters["p_electrode_type"] | p_electrode_type | 행/컬럼 값 대입 |  |  |  |
| AC-0c769b41 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SSP0009_Shipment_Plan_FG.cs:2299 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-19679d0c | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SSP0009_Shipment_Plan_FG.cs:2300 | try ▸ lambda | RETURN | return res.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-dad69447 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SSP0009_Shipment_Plan_FG.cs:2304 | try | GRID_BIND | siPeggingInfo.Query | (dsBinding) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-6c3bc2ac | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SSP0009_Shipment_Plan_FG.cs:2305 | try | GRID_LOCK | siPeggingInfo.LockColumn | (0, siPeggingInfo.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-65948233 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SSP0009_Shipment_Plan_FG.cs:2306 | try | GRID_INIT | siPeggingInfo.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c3fb65ee | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SSP0009_Shipment_Plan_FG.cs:2309 | catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-055a0762 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SSP0009_Shipment_Plan_FG.cs:2312 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9d136dd9 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SSP0009_Shipment_Plan_FG.cs:2314 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SSP0009_Shipment_Plan_FG.FindData_PlanProblem

진입점: this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >= 0) ▸ if (siMain.GetValue(e.Row, siMain.GetColumnIndex(DefMain.MEASURE)).ToString().Equals("MKT_FCST"))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0d6a26a1 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SSP0009_Shipment_Plan_FG.cs:2340 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-11b115dc | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SSP0009_Shipment_Plan_FG.cs:2343 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-930c49da | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SSP0009_Shipment_Plan_FG.cs:2346 | try | UI_PROP | proxyPivot.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-0173103f | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SSP0009_Shipment_Plan_FG.cs:2348 | try | ENDPOINT | proxyPivot.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, GSCM_SSP_PLAN_S… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-70cb9d88 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SSP0009_Shipment_Plan_FG.cs:2352 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SSP.SSP0009_GET_SHIPMENT_PLAN_FG_PROBLEM") ⇒ SSP.SSP0009_GET_SHIPMENT_PLAN_FG_PROBLEM | 엔드포인트 요청 생성 |  |  |  |
| AC-38df3042 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SSP0009_Shipment_Plan_FG.cs:2353 | try ▸ lambda | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-421322be | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SSP0009_Shipment_Plan_FG.cs:2354 | try ▸ lambda | DATA_OP | req.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-80ee0c3a | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SSP0009_Shipment_Plan_FG.cs:2355 | try ▸ lambda | DATA_OP | req.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-4c0d193e | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SSP0009_Shipment_Plan_FG.cs:2356 | try ▸ lambda | DATA_OP | req.Parameters["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-69075339 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SSP0009_Shipment_Plan_FG.cs:2357 | try ▸ lambda | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-2e8fb29b | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SSP0009_Shipment_Plan_FG.cs:2358 | try ▸ lambda | DATA_OP | req.Parameters["p_project_code"] | p_project_code | 행/컬럼 값 대입 |  |  |  |
| AC-519002ed | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SSP0009_Shipment_Plan_FG.cs:2363 | try ▸ lambda | DATA_OP | req.Parameters["p_to_site"] | p_to_site | 행/컬럼 값 대입 |  |  |  |
| AC-307a999e | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SSP0009_Shipment_Plan_FG.cs:2364 | try ▸ lambda | DATA_OP | req.Parameters["p_duedate"] | p_duedate | 행/컬럼 값 대입 |  |  |  |
| AC-cfc45864 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SSP0009_Shipment_Plan_FG.cs:2366 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-f7850d8e | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SSP0009_Shipment_Plan_FG.cs:2367 | try ▸ lambda | RETURN | return res.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-2436501f | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SSP0009_Shipment_Plan_FG.cs:2371 | try | GRID_BIND | siPlanProblem.Query | (dsBinding) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-6c0eff7c | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SSP0009_Shipment_Plan_FG.cs:2372 | try | GRID_LOCK | siPlanProblem.LockColumn | (0, siPlanProblem.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-be166675 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SSP0009_Shipment_Plan_FG.cs:2373 | try | GRID_INIT | siPlanProblem.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4245a389 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SSP0009_Shipment_Plan_FG.cs:2377 | catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-047a18b2 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SSP0009_Shipment_Plan_FG.cs:2380 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-53716bab | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SSP0009_Shipment_Plan_FG.cs:2384 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SSP0009_Shipment_Plan_FG.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1d805241 | this.Load | SSP0009_Shipment_Plan_FG.cs:226 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SSP0009_Shipment_Plan_FG.GetBucketType

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7c498c50 | this.Load | SSP0009_Shipment_Plan_FG.cs:278 |  | ENDPOINT | new FoxDataRequest | ("DM.DM0003_GET_BUCKET_TYPE_CODE") ⇒ DM.DM0003_GET_BUCKET_TYPE_CODE | 엔드포인트 요청 생성 |  |  |  |
| AC-d766d702 | this.Load | SSP0009_Shipment_Plan_FG.cs:279 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-9fa98001 | this.Load | SSP0009_Shipment_Plan_FG.cs:281 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SSP0009_Shipment_Plan_FG.GetDayRange

진입점: this.Load / cboPlanDate.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2a913bf0 | this.Load 외 1 | SSP0009_Shipment_Plan_FG.cs:2474 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCM0001_GET_SCP_DAY_PERIOD") ⇒ SCP.SCM0001_GET_SCP_DAY_PERIOD | 엔드포인트 요청 생성 |  |  |  |
| AC-4bf199c8 | this.Load 외 1 | SSP0009_Shipment_Plan_FG.cs:2475 |  | DATA_OP | request.Parameters["p_from_date"] | p_from_date | 행/컬럼 값 대입 |  |  |  |
| AC-4672c293 | this.Load 외 1 | SSP0009_Shipment_Plan_FG.cs:2476 |  | DATA_OP | request.Parameters["p_offset_day"] | "55" | 행/컬럼 값 대입 |  |  |  |
| AC-c132e596 | this.Load 외 1 | SSP0009_Shipment_Plan_FG.cs:2477 |  | DATA_OP | request.Parameters["p_timezone"] | UserInfoContext.Current[UserInfoProperites.TimeZone] | 행/컬럼 값 대입 |  |  |  |
| AC-f6eb02f8 | this.Load 외 1 | SSP0009_Shipment_Plan_FG.cs:2478 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-84257fba | this.Load 외 1 | SSP0009_Shipment_Plan_FG.cs:2483 |  | RETURN | return sDayRange; |  | 처리 중단/반환 |  |  |  |

## SSP0009_Shipment_Plan_FG.GetIsEditable

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-923b33fd | (진입점 미연결) | SSP0009_Shipment_Plan_FG.cs:2166 | foreach (DataRow item in dtPlanType.Rows) | DATA_OP | lst.Add | (item["code"].ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-b7782c85 | (진입점 미연결) | SSP0009_Shipment_Plan_FG.cs:2173 |  | DATA_OP | lst.Contains | ("SE") | 데이터 객체 조작/조회 |  |  |  |
| AC-471ff10f | (진입점 미연결) | SSP0009_Shipment_Plan_FG.cs:2178 |  | DATA_OP | lst.Contains | ("MA") | 데이터 객체 조작/조회 |  |  |  |
| AC-f35984e9 | (진입점 미연결) | SSP0009_Shipment_Plan_FG.cs:2178 |  | DATA_OP | lst.Contains | ("PR") | 데이터 객체 조작/조회 |  |  |  |
| AC-5153fb60 | (진입점 미연결) | SSP0009_Shipment_Plan_FG.cs:2183 |  | DATA_OP | lst.Contains | ("FN") | 데이터 객체 조작/조회 |  |  |  |
| AC-d72ed48b | (진입점 미연결) | SSP0009_Shipment_Plan_FG.cs:2187 |  | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |

## SSP0009_Shipment_Plan_FG.GetNewInsertRowIndex

진입점: this.spdMain.CellClick [if ((e.Column == siMain.GetColumnIndex(DefMain.TRANSPORT_MODE) \|\| e.Column == siMain.GetColumnIndex(DefMain.FROM_SITE_NAME))…) ▸ if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (chosedFromSite.ToString() == popupReturnSite)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9b506291 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SSP0009_Shipment_Plan_FG.cs:1792 |  | RETURN | return retIndex; |  | 처리 중단/반환 |  |  |  |

## SSP0009_Shipment_Plan_FG.GetSpdTitle

진입점: this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] / this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >= 0) ▸ if (siMain.GetValue(e.Row, siMain.GetColumnIndex(DefMain.MEASURE)).ToString().Equals("MKT_FCST")) ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / FindButton [if (spdInfo.SheetName == SpdSheet.shtMain)] / SaveButton [if (fps.Name == spdMain.Name) ▸ if (s…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3e7dfbb1 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 5 | SSP0009_Shipment_Plan_FG.cs:2446 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN") ⇒ SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | 엔드포인트 요청 생성 |  |  |  |
| AC-913ff1a2 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 5 | SSP0009_Shipment_Plan_FG.cs:2447 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-1774535c | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 5 | SSP0009_Shipment_Plan_FG.cs:2448 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-1759773c | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 5 | SSP0009_Shipment_Plan_FG.cs:2450 |  | FLAG | dsSpdTitle | client.ExecuteDataSet(request).DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-63a417f3 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 5 | SSP0009_Shipment_Plan_FG.cs:2450 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## SSP0009_Shipment_Plan_FG.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8deee7b1 | this.Load | SSP0009_Shipment_Plan_FG.cs:245 | if (dtDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |
| AC-7eeb236c | this.Load | SSP0009_Shipment_Plan_FG.cs:247 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-720559c8 | this.Load | SSP0009_Shipment_Plan_FG.cs:249 |  | DATA_OP | this.ConditionNotUseList.Add | (cboPlanDate) | 데이터 객체 조작/조회 |  |  |  |
| AC-c2f8ab20 | this.Load | SSP0009_Shipment_Plan_FG.cs:250 |  | DATA_OP | this.ConditionNotUseList.Add | (cboPlanType) | 데이터 객체 조작/조회 |  |  |  |
| AC-c7f35632 | this.Load | SSP0009_Shipment_Plan_FG.cs:251 |  | DATA_OP | this.ConditionNotUseList.Add | (cboPlanSeq) | 데이터 객체 조작/조회 |  |  |  |
| AC-b1de4051 | this.Load | SSP0009_Shipment_Plan_FG.cs:254 |  | DATA_OP | ReadOnlySheetList.Add | (SpdSheet.shtMain) | 데이터 객체 조작/조회 |  |  |  |
| AC-40f67d78 | this.Load | SSP0009_Shipment_Plan_FG.cs:255 |  | DATA_OP | ReadOnlySheetList.Add | (SpdSheet.shtPeggingInfo) | 데이터 객체 조작/조회 |  |  |  |
| AC-53250719 | this.Load | SSP0009_Shipment_Plan_FG.cs:256 |  | DATA_OP | ReadOnlySheetList.Add | (SpdSheet.shtPlanProblem) | 데이터 객체 조작/조회 |  |  |  |
| AC-26bc4915 | this.Load | SSP0009_Shipment_Plan_FG.cs:258 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, cboDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-e43209f8 | this.Load | SSP0009_Shipment_Plan_FG.cs:263 |  | LIST_REBIND | clsCtrl.setListBox | (dtElectrode, clbElectrode, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-a94ada8f | this.Load | SSP0009_Shipment_Plan_FG.cs:267 |  | VALUE_SET | drpPeriod.InitValue | GetDayRange() | 컨트롤 값 설정 |  |  |  |
| AC-e29662f7 | this.Load | SSP0009_Shipment_Plan_FG.cs:269 |  | FLAG | dtBucketType | GetBucketType() | 화면 필드/플래그 변경 |  |  |  |
| AC-8d6800e6 | this.Load | SSP0009_Shipment_Plan_FG.cs:270 |  | LIST_REBIND | clsCtrl.setListBox | (dtBucketType, cboBucketType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SSP0009_Shipment_Plan_FG.InitSpread_2

진입점: this.Load / this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >= 0) ▸ if (siMain.GetValue(e.Row, siMain.GetColumnIndex(DefMain.MEASURE)).ToString().Equals("MKT_FCST"))] / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK)] / FindButton / SaveButton [if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (iCount > 0) ▸ if (tran.Success)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9383b531 | this.Load 외 5 | SSP0009_Shipment_Plan_FG.cs:400 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.InitSheet | (SpdSheet.shtMain) | 그리드 재구성/초기화 |  |  |  |
| AC-87df7403 | this.Load 외 5 | SSP0009_Shipment_Plan_FG.cs:405 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.SetSheetHeaderColumn | (spdInfo, 3) | 그리드 재구성/초기화 |  |  |  |
| AC-8089daed | this.Load 외 5 | SSP0009_Shipment_Plan_FG.cs:409 | if (spdInfo.SheetName == SpdSheet.shtMain) | FLAG | this._LastHeader_Idx | nIdxDataMain | 화면 필드/플래그 변경 |  |  |  |
| AC-fe866152 | this.Load 외 5 | SSP0009_Shipment_Plan_FG.cs:414 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-aaf73da7 | this.Load 외 5 | SSP0009_Shipment_Plan_FG.cs:419 | if (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (pDivisionID != "EE") | GRID_SET | spdInfo.ActiveSheet.Columns[siMain.GetColumnIndex("ELECTRODE_TYPE")].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-0a693eed | this.Load 외 5 | SSP0009_Shipment_Plan_FG.cs:420 | if (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (pDivisionID != "EE") | GRID_SET | spdInfo.ActiveSheet.Columns[siMain.GetColumnIndex("ORIGIN_TO_DIVISION_ID")].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-a0ba49fe | this.Load 외 5 | SSP0009_Shipment_Plan_FG.cs:421 | if (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (pDivisionID != "EE") | GRID_SET | spdInfo.ActiveSheet.Columns[siMain.GetColumnIndex("ORIGIN_FROM_DIVISION_ID")].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-2e548d94 | this.Load 외 5 | SSP0009_Shipment_Plan_FG.cs:425 | if (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (pDivisionID != "EE") | GRID_SET | spdInfo.ActiveSheet.Columns[siMain.GetColumnIndex("ELECTRODE_TYPE")].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-a434e90c | this.Load 외 5 | SSP0009_Shipment_Plan_FG.cs:426 | if (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (pDivisionID != "EE") | GRID_SET | spdInfo.ActiveSheet.Columns[siMain.GetColumnIndex("ORIGIN_TO_DIVISION_ID")].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-79635cd1 | this.Load 외 5 | SSP0009_Shipment_Plan_FG.cs:427 | if (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (pDivisionID != "EE") | GRID_SET | spdInfo.ActiveSheet.Columns[siMain.GetColumnIndex("ORIGIN_FROM_DIVISION_ID")].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-f58d686e | this.Load 외 5 | SSP0009_Shipment_Plan_FG.cs:433 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (spdInfo.SheetName == SpdSheet.shtPeggingInfo) | GRID_INIT | spdInfo.InitSheet | (SpdSheet.shtPeggingInfo) | 그리드 재구성/초기화 |  |  |  |
| AC-b0961177 | this.Load 외 5 | SSP0009_Shipment_Plan_FG.cs:435 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (spdInfo.SheetName == SpdSheet.shtPeggingInfo) | GRID_INIT | siPeggingInfo.SetSheetHeaderColumn | (spdInfo, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-70446f20 | this.Load 외 5 | SSP0009_Shipment_Plan_FG.cs:436 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (spdInfo.SheetName == SpdSheet.shtPeggingInfo) | GRID_INIT | spdInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-d39ef5ae | this.Load 외 5 | SSP0009_Shipment_Plan_FG.cs:440 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (spdInfo.SheetName == SpdSheet.shtPeggingInfo) ▸ if (pDivisionID != "EE") | GRID_SET | spdInfo.ActiveSheet.Columns[siPeggingInfo.GetColumnIndex("ELECTRODE_TYPE")].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-046d14de | this.Load 외 5 | SSP0009_Shipment_Plan_FG.cs:441 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (spdInfo.SheetName == SpdSheet.shtPeggingInfo) ▸ if (pDivisionID != "EE") | GRID_SET | spdInfo.ActiveSheet.Columns[siPeggingInfo.GetColumnIndex("ORIGIN_FROM_DIVISION_ID")].Visib… | false | 그리드 속성/값 설정 |  |  |  |
| AC-ab08c72d | this.Load 외 5 | SSP0009_Shipment_Plan_FG.cs:442 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (spdInfo.SheetName == SpdSheet.shtPeggingInfo) ▸ if (pDivisionID != "EE") | GRID_SET | spdInfo.ActiveSheet.Columns[siPeggingInfo.GetColumnIndex("ORIGIN_TO_DIVISION_ID")].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-da998f1b | this.Load 외 5 | SSP0009_Shipment_Plan_FG.cs:446 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (spdInfo.SheetName == SpdSheet.shtPeggingInfo) ▸ else of (pDivisionID != "EE") | GRID_SET | spdInfo.ActiveSheet.Columns[siPeggingInfo.GetColumnIndex("ELECTRODE_TYPE")].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-e6cfcabe | this.Load 외 5 | SSP0009_Shipment_Plan_FG.cs:447 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (spdInfo.SheetName == SpdSheet.shtPeggingInfo) ▸ else of (pDivisionID != "EE") | GRID_SET | spdInfo.ActiveSheet.Columns[siPeggingInfo.GetColumnIndex("ORIGIN_FROM_DIVISION_ID")].Visib… | true | 그리드 속성/값 설정 |  |  |  |
| AC-4a46b85c | this.Load 외 5 | SSP0009_Shipment_Plan_FG.cs:448 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (spdInfo.SheetName == SpdSheet.shtPeggingInfo) ▸ else of (pDivisionID != "EE") | GRID_SET | spdInfo.ActiveSheet.Columns[siPeggingInfo.GetColumnIndex("ORIGIN_TO_DIVISION_ID")].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-8bb27fc2 | this.Load 외 5 | SSP0009_Shipment_Plan_FG.cs:454 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPeggingInfo) ▸ if (spdInfo.SheetName == SpdSheet… | GRID_INIT | spdInfo.InitSheet | (SpdSheet.shtPlanProblem) | 그리드 재구성/초기화 |  |  |  |
| AC-15601d3b | this.Load 외 5 | SSP0009_Shipment_Plan_FG.cs:455 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPeggingInfo) ▸ if (spdInfo.SheetName == SpdSheet… | GRID_INIT | siPlanProblem.SetSheetHeaderColumn | (spdInfo, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-7bb7e66d | this.Load 외 5 | SSP0009_Shipment_Plan_FG.cs:456 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPeggingInfo) ▸ if (spdInfo.SheetName == SpdSheet… | GRID_INIT | spdInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SSP0009_Shipment_Plan_FG.InitSpreadDateColumn

진입점: this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] / this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >= 0) ▸ if (siMain.GetValue(e.Row, siMain.GetColumnIndex(DefMain.MEASURE)).ToString().Equals("MKT_FCST")) ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / FindButton [if (spdInfo.SheetName == SpdSheet.shtMain)] / SaveButton [if (fps.Name == spdMain.Name) ▸ if (s…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b9b74c0e | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 5 | SSP0009_Shipment_Plan_FG.cs:607 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sColumnName.IndexOf("B_") > 0) | GRID_INIT | spdInfo.AddTextColumn | (sColumnLabelname, sColumnName, FPMerge.None, 0, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-bf87c763 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 5 | SSP0009_Shipment_Plan_FG.cs:610 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sColumnName.IndexOf("B_") > 0) | GRID_INIT | spdInfo.AddNumColumn | (sColumnLabelname, sColumnName, FPMerge.None, 70, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c77fba4e | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 5 | SSP0009_Shipment_Plan_FG.cs:611 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sColumnName.IndexOf("B_") > 0) | GRID_INIT | spdInfo.SetReNumerCellType | (spdInfo, spdInfo.GetColumnIndex(sColumnName)) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-d69f6806 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 5 | SSP0009_Shipment_Plan_FG.cs:614 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sColumnName.IndexOf("B_") > 0) ▸ if (sDayCode == DefMainLabel.Saturday \|\| sDa… | GRID_SET | spdInfo.Sheet().ColumnHeader.Cells[2, spdInfo.GetMaxColumnIndex()].ForeColor | sDayCode == DefMainLabel.Saturday ? Color.Blue : Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-e5ef5c00 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 5 | SSP0009_Shipment_Plan_FG.cs:620 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7bd49860 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 5 | SSP0009_Shipment_Plan_FG.cs:621 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5195cecb | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 5 | SSP0009_Shipment_Plan_FG.cs:626 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-48e96812 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 5 | SSP0009_Shipment_Plan_FG.cs:627 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 30, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0893d1fa | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 5 | SSP0009_Shipment_Plan_FG.cs:634 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName != sSmallLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e8e7df39 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 5 | SSP0009_Shipment_Plan_FG.cs:635 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName != sSmallLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6954027a | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 5 | SSP0009_Shipment_Plan_FG.cs:645 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2de96fbe | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 5 | SSP0009_Shipment_Plan_FG.cs:646 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-35a6f1aa | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 5 | SSP0009_Shipment_Plan_FG.cs:647 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ebb7c44e | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 5 | SSP0009_Shipment_Plan_FG.cs:648 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |

## SSP0009_Shipment_Plan_FG.InsertRow

진입점: this.spdMain.CellClick [if ((e.Column == siMain.GetColumnIndex(DefMain.TRANSPORT_MODE) \|\| e.Column == siMain.GetColumnIndex(DefMain.FROM_SITE_NAME))…)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-099d544d | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SSP0009_Shipment_Plan_FG.cs:1491 |  | DATA_OP | dsBinding.Tables[0].Select() .Where(c => c[DefMain.KEY_IDX].ToString() == key_idx.ToString… | () | 데이터 객체 조작/조회 |  |  |  |
| AC-5680d66d | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SSP0009_Shipment_Plan_FG.cs:1491 |  | DATA_OP | dsBinding.Tables[0].Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-aa89d262 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SSP0009_Shipment_Plan_FG.cs:1499 |  | POPUP | new SCM0002_GetBODPopup | (dtCaller, 0, this._plan_Start_Date) | 팝업/폼 생성 |  |  |  |
| AC-3aee2eca | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SSP0009_Shipment_Plan_FG.cs:1500 |  | UI_PROP | popup.Width | 1050 | 속성 Width 설정 |  |  |  |
| AC-6c0e0e6d | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SSP0009_Shipment_Plan_FG.cs:1501 |  | UI_PROP | popup.Height | 350 | 속성 Height 설정 |  |  |  |
| AC-d97258f1 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SSP0009_Shipment_Plan_FG.cs:1502 |  | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-309d2b99 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SSP0009_Shipment_Plan_FG.cs:1510 |  | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-dba3b4e5 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SSP0009_Shipment_Plan_FG.cs:1512 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (popup.retList.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-957d2c81 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SSP0009_Shipment_Plan_FG.cs:1530 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (chosedFromSite.ToString() == popupReturnSite) | DATA_OP | dtCaller.Select().Where(c => c[DefMain.MEASURE].ToString().Contains("SHIP_")).CopyToDataTa… | () | 데이터 객체 조작/조회 |  |  |  |
| AC-dbdfa772 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SSP0009_Shipment_Plan_FG.cs:1530 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (chosedFromSite.ToString() == popupReturnSite) | DATA_OP | dtCaller.Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-24fa35df | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SSP0009_Shipment_Plan_FG.cs:1530 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (chosedFromSite.ToString() == popupReturnSite) ▸ lambda | DATA_OP | c[DefMain.MEASURE].ToString().Contains | ("SHIP_") | 데이터 객체 조작/조회 |  |  |  |
| AC-e83f905c | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SSP0009_Shipment_Plan_FG.cs:1535 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (chosedFromSite.ToString() == popupReturnSite) ▸ foreac… | CALL_EXT | siMain.InsertNewRow | (insertStartIdx) | ⚠ 의미 확인 필요 |  |  |  |
| AC-50f96168 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SSP0009_Shipment_Plan_FG.cs:1537 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (chosedFromSite.ToString() == popupReturnSite) ▸ foreac… | DATA_OP | defaultData.Add | (DefMain.DIVISION_ID, dr["division_id"]) | 데이터 객체 조작/조회 |  |  |  |
| AC-756fe5d1 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SSP0009_Shipment_Plan_FG.cs:1538 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (chosedFromSite.ToString() == popupReturnSite) ▸ foreac… | DATA_OP | defaultData.Add | (DefMain.BIZ_TYPE_NAME, dr["BIZ_TYPE_NAME"]) | 데이터 객체 조작/조회 |  |  |  |
| AC-e4e6def4 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SSP0009_Shipment_Plan_FG.cs:1539 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (chosedFromSite.ToString() == popupReturnSite) ▸ foreac… | DATA_OP | defaultData.Add | (DefMain.ITEM_ID, dr["ITEM_ID"]) | 데이터 객체 조작/조회 |  |  |  |
| AC-cc3cbe06 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SSP0009_Shipment_Plan_FG.cs:1540 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (chosedFromSite.ToString() == popupReturnSite) ▸ foreac… | DATA_OP | defaultData.Add | (DefMain.NICK_NAME, dr["NICK_NAME"]) | 데이터 객체 조작/조회 |  |  |  |
| AC-f834dadb | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SSP0009_Shipment_Plan_FG.cs:1541 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (chosedFromSite.ToString() == popupReturnSite) ▸ foreac… | DATA_OP | defaultData.Add | (DefMain.TO_SITE_NAME, bod.first_site_name) | 데이터 객체 조작/조회 |  |  |  |
| AC-95892f6a | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SSP0009_Shipment_Plan_FG.cs:1543 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (chosedFromSite.ToString() == popupReturnSite) ▸ foreac… | DATA_OP | defaultData.Add | (DefMain.BOH, dr["BOH"]) | 데이터 객체 조작/조회 |  |  |  |
| AC-ebfd4b2f | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SSP0009_Shipment_Plan_FG.cs:1544 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (chosedFromSite.ToString() == popupReturnSite) ▸ foreac… | DATA_OP | defaultData.Add | (DefMain.INCOTERMS, bod.incoterms) | 데이터 객체 조작/조회 |  |  |  |
| AC-27a8e473 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SSP0009_Shipment_Plan_FG.cs:1545 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (chosedFromSite.ToString() == popupReturnSite) ▸ foreac… | DATA_OP | defaultData.Add | (DefMain.PROJECT_CODE, dr["PROJECT_CODE"]) | 데이터 객체 조작/조회 |  |  |  |
| AC-10f06ccc | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SSP0009_Shipment_Plan_FG.cs:1546 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (chosedFromSite.ToString() == popupReturnSite) ▸ foreac… | DATA_OP | defaultData.Add | (DefMain.FROM_SITE_NAME, bod.second_site_name) | 데이터 객체 조작/조회 |  |  |  |
| AC-29227727 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SSP0009_Shipment_Plan_FG.cs:1547 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (chosedFromSite.ToString() == popupReturnSite) ▸ foreac… | DATA_OP | defaultData.Add | (DefMain.TRANSPORT_MODE, bod.transport_mode) | 데이터 객체 조작/조회 |  |  |  |
| AC-dc8260c5 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SSP0009_Shipment_Plan_FG.cs:1549 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (chosedFromSite.ToString() == popupReturnSite) ▸ foreac… | DATA_OP | defaultData.Add | (DefMain.LT_DAY, bod.lt_total) | 데이터 객체 조작/조회 |  |  |  |
| AC-ff86a956 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SSP0009_Shipment_Plan_FG.cs:1550 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (chosedFromSite.ToString() == popupReturnSite) ▸ foreac… | DATA_OP | defaultData.Add | (DefMain.MEASURE_LABEL, dr["MEASURE_LABEL"]) | 데이터 객체 조작/조회 |  |  |  |
| AC-e8606266 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SSP0009_Shipment_Plan_FG.cs:1551 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (chosedFromSite.ToString() == popupReturnSite) ▸ foreac… | DATA_OP | defaultData.Add | (DefMain.MEASURE, dr["measure"]) | 데이터 객체 조작/조회 |  |  |  |
| AC-7c89ccfd | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SSP0009_Shipment_Plan_FG.cs:1552 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (chosedFromSite.ToString() == popupReturnSite) ▸ foreac… | DATA_OP | defaultData.Add | (DefMain.BOD_ID, bod.bod_id) | 데이터 객체 조작/조회 |  |  |  |
| AC-f711de47 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SSP0009_Shipment_Plan_FG.cs:1553 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (chosedFromSite.ToString() == popupReturnSite) ▸ foreac… | DATA_OP | defaultData.Add | (DefMain.KEY_IDX, dr["key_idx"]) | 데이터 객체 조작/조회 |  |  |  |
| AC-17099702 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SSP0009_Shipment_Plan_FG.cs:1555 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (chosedFromSite.ToString() == popupReturnSite) ▸ foreac… | DATA_OP | defaultData.Add | (DefMain.BIZ_TYPE, dr["biz_type"]) | 데이터 객체 조작/조회 |  |  |  |
| AC-b5a859ea | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SSP0009_Shipment_Plan_FG.cs:1556 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (chosedFromSite.ToString() == popupReturnSite) ▸ foreac… | DATA_OP | defaultData.Add | (DefMain.TO_SITE, bod.first_site) | 데이터 객체 조작/조회 |  |  |  |
| AC-8992634e | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SSP0009_Shipment_Plan_FG.cs:1557 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (chosedFromSite.ToString() == popupReturnSite) ▸ foreac… | DATA_OP | defaultData.Add | (DefMain.FROM_SITE, bod.second_site) | 데이터 객체 조작/조회 |  |  |  |
| AC-d5756dfc | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SSP0009_Shipment_Plan_FG.cs:1558 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (chosedFromSite.ToString() == popupReturnSite) ▸ foreac… | DATA_OP | defaultData.Add | (DefMain.SHIP_FROZEN, bod.ship_frozen) | 데이터 객체 조작/조회 |  |  |  |
| AC-67c3bb7f | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SSP0009_Shipment_Plan_FG.cs:1559 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (chosedFromSite.ToString() == popupReturnSite) ▸ foreac… | DATA_OP | defaultData.Add | (DefMain.MEASURE_ORDER_NO, dr["MEASURE_ORDER_NO"]) | 데이터 객체 조작/조회 |  |  |  |
| AC-18f20f4f | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SSP0009_Shipment_Plan_FG.cs:1561 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (chosedFromSite.ToString() == popupReturnSite) ▸ foreac… | DATA_OP | defaultData.Add | (DefMain.PLAN_START_YYYYMMDD, dr["plan_start_yyyymmdd"]) | 데이터 객체 조작/조회 |  |  |  |
| AC-4510b61e | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SSP0009_Shipment_Plan_FG.cs:1562 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (chosedFromSite.ToString() == popupReturnSite) ▸ foreac… | DATA_OP | defaultData.Add | (DefMain.PLAN_TYPE, dr["plan_type"]) | 데이터 객체 조작/조회 |  |  |  |
| AC-c0690fcf | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SSP0009_Shipment_Plan_FG.cs:1563 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (chosedFromSite.ToString() == popupReturnSite) ▸ foreac… | DATA_OP | defaultData.Add | (DefMain.SEQ, dr["seq"]) | 데이터 객체 조작/조회 |  |  |  |
| AC-23d033dc | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SSP0009_Shipment_Plan_FG.cs:1564 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (chosedFromSite.ToString() == popupReturnSite) ▸ foreac… | DATA_OP | defaultData.Add | (DefMain.TO_YYYYMMDD, dr["to_yyyymmdd"]) | 데이터 객체 조작/조회 |  |  |  |
| AC-9db9acfe | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SSP0009_Shipment_Plan_FG.cs:1566 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ if (chosedFromSite.ToString() == popupReturnSite) ▸ foreac… | GRID_SET | siMain.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |
| AC-c1df2de5 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SSP0009_Shipment_Plan_FG.cs:1593 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (chosedFromSite.ToString() == popupReturnSite) ▸ f… | CALL_EXT | siMain.InsertNewRow | (insertStartIdx) | ⚠ 의미 확인 필요 |  |  |  |
| AC-959a615f | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SSP0009_Shipment_Plan_FG.cs:1595 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (chosedFromSite.ToString() == popupReturnSite) ▸ f… | DATA_OP | defaultData.Add | (DefMain.DIVISION_ID, row["division_id"]) | 데이터 객체 조작/조회 |  |  |  |
| AC-e925dbc1 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SSP0009_Shipment_Plan_FG.cs:1596 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (chosedFromSite.ToString() == popupReturnSite) ▸ f… | DATA_OP | defaultData.Add | (DefMain.BIZ_TYPE_NAME, row["BIZ_TYPE_NAME"]) | 데이터 객체 조작/조회 |  |  |  |
| AC-ca4c61da | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SSP0009_Shipment_Plan_FG.cs:1597 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (chosedFromSite.ToString() == popupReturnSite) ▸ f… | DATA_OP | defaultData.Add | (DefMain.ITEM_ID, row["ITEM_ID"]) | 데이터 객체 조작/조회 |  |  |  |
| AC-35456e19 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SSP0009_Shipment_Plan_FG.cs:1598 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (chosedFromSite.ToString() == popupReturnSite) ▸ f… | DATA_OP | defaultData.Add | (DefMain.NICK_NAME, row["NICK_NAME"]) | 데이터 객체 조작/조회 |  |  |  |
| AC-e3eb55e4 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SSP0009_Shipment_Plan_FG.cs:1599 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (chosedFromSite.ToString() == popupReturnSite) ▸ f… | DATA_OP | defaultData.Add | (DefMain.TO_SITE_NAME, bod.first_site_name) | 데이터 객체 조작/조회 |  |  |  |
| AC-c3f21239 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SSP0009_Shipment_Plan_FG.cs:1601 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (chosedFromSite.ToString() == popupReturnSite) ▸ f… | DATA_OP | defaultData.Add | (DefMain.BOH, row["BOH"]) | 데이터 객체 조작/조회 |  |  |  |
| AC-3550586c | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SSP0009_Shipment_Plan_FG.cs:1602 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (chosedFromSite.ToString() == popupReturnSite) ▸ f… | DATA_OP | defaultData.Add | (DefMain.INCOTERMS, bod.incoterms) | 데이터 객체 조작/조회 |  |  |  |
| AC-842a8052 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SSP0009_Shipment_Plan_FG.cs:1603 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (chosedFromSite.ToString() == popupReturnSite) ▸ f… | DATA_OP | defaultData.Add | (DefMain.PROJECT_CODE, row["PROJECT_CODE"]) | 데이터 객체 조작/조회 |  |  |  |
| AC-2d0bffc6 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SSP0009_Shipment_Plan_FG.cs:1605 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (chosedFromSite.ToString() == popupReturnSite) ▸ f… | DATA_OP | cur_Measure.Contains | ("SHIP") | 데이터 객체 조작/조회 |  |  |  |
| AC-730b712c | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SSP0009_Shipment_Plan_FG.cs:1606 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (chosedFromSite.ToString() == popupReturnSite) ▸ f… | DATA_OP | defaultData.Add | (DefMain.FROM_SITE_NAME, "-") | 데이터 객체 조작/조회 |  |  |  |
| AC-e84ce626 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SSP0009_Shipment_Plan_FG.cs:1609 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (chosedFromSite.ToString() == popupReturnSite) ▸ f… | DATA_OP | defaultData.Add | (DefMain.FROM_SITE_NAME, bod.second_site_name) | 데이터 객체 조작/조회 |  |  |  |
| AC-9d17005d | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SSP0009_Shipment_Plan_FG.cs:1612 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (chosedFromSite.ToString() == popupReturnSite) ▸ f… | DATA_OP | cur_Measure.Contains | ("SHIP") | 데이터 객체 조작/조회 |  |  |  |
| AC-3b3f723b | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SSP0009_Shipment_Plan_FG.cs:1613 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (chosedFromSite.ToString() == popupReturnSite) ▸ f… | DATA_OP | defaultData.Add | (DefMain.TRANSPORT_MODE, bod.transport_mode) | 데이터 객체 조작/조회 |  |  |  |
| AC-8606abbb | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SSP0009_Shipment_Plan_FG.cs:1616 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (chosedFromSite.ToString() == popupReturnSite) ▸ f… | DATA_OP | defaultData.Add | (DefMain.TRANSPORT_MODE, "-") | 데이터 객체 조작/조회 |  |  |  |
| AC-1eb7a781 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SSP0009_Shipment_Plan_FG.cs:1619 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (chosedFromSite.ToString() == popupReturnSite) ▸ f… | DATA_OP | cur_Measure.Contains | ("SHIP") | 데이터 객체 조작/조회 |  |  |  |
| AC-64d59c8f | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SSP0009_Shipment_Plan_FG.cs:1620 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (chosedFromSite.ToString() == popupReturnSite) ▸ f… | DATA_OP | defaultData.Add | (DefMain.LT_DAY, bod.lt_total) | 데이터 객체 조작/조회 |  |  |  |
| AC-51e21a45 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SSP0009_Shipment_Plan_FG.cs:1623 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (chosedFromSite.ToString() == popupReturnSite) ▸ f… | DATA_OP | defaultData.Add | (DefMain.LT_DAY, 0) | 데이터 객체 조작/조회 |  |  |  |
| AC-2585b1a5 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SSP0009_Shipment_Plan_FG.cs:1626 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (chosedFromSite.ToString() == popupReturnSite) ▸ f… | DATA_OP | defaultData.Add | (DefMain.MEASURE_LABEL, row["MEASURE_LABEL"]) | 데이터 객체 조작/조회 |  |  |  |
| AC-ed6063c9 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SSP0009_Shipment_Plan_FG.cs:1627 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (chosedFromSite.ToString() == popupReturnSite) ▸ f… | DATA_OP | defaultData.Add | (DefMain.MEASURE, cur_Measure) | 데이터 객체 조작/조회 |  |  |  |
| AC-9a641052 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SSP0009_Shipment_Plan_FG.cs:1630 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (chosedFromSite.ToString() == popupReturnSite) ▸ f… | DATA_OP | cur_Measure.Contains | ("SHIP") | 데이터 객체 조작/조회 |  |  |  |
| AC-7a7a995b | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SSP0009_Shipment_Plan_FG.cs:1631 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (chosedFromSite.ToString() == popupReturnSite) ▸ f… | DATA_OP | defaultData.Add | (DefMain.BOD_ID, bod.bod_id) | 데이터 객체 조작/조회 |  |  |  |
| AC-1b8080e7 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SSP0009_Shipment_Plan_FG.cs:1634 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (chosedFromSite.ToString() == popupReturnSite) ▸ f… | DATA_OP | defaultData.Add | (DefMain.BOD_ID, "-") | 데이터 객체 조작/조회 |  |  |  |
| AC-76c9b293 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SSP0009_Shipment_Plan_FG.cs:1637 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (chosedFromSite.ToString() == popupReturnSite) ▸ f… | DATA_OP | defaultData.Add | (DefMain.KEY_IDX, row["key_idx"]) | 데이터 객체 조작/조회 |  |  |  |
| AC-48b76a14 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SSP0009_Shipment_Plan_FG.cs:1638 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (chosedFromSite.ToString() == popupReturnSite) ▸ f… | DATA_OP | defaultData.Add | (DefMain.BIZ_TYPE, row["biz_type"]) | 데이터 객체 조작/조회 |  |  |  |
| AC-934f2333 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SSP0009_Shipment_Plan_FG.cs:1639 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (chosedFromSite.ToString() == popupReturnSite) ▸ f… | DATA_OP | defaultData.Add | (DefMain.TO_SITE, bod.first_site) | 데이터 객체 조작/조회 |  |  |  |
| AC-1df9718d | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SSP0009_Shipment_Plan_FG.cs:1641 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (chosedFromSite.ToString() == popupReturnSite) ▸ f… | DATA_OP | cur_Measure.Contains | ("SHIP") | 데이터 객체 조작/조회 |  |  |  |
| AC-84bb625d | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SSP0009_Shipment_Plan_FG.cs:1642 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (chosedFromSite.ToString() == popupReturnSite) ▸ f… | DATA_OP | defaultData.Add | (DefMain.FROM_SITE, "-") | 데이터 객체 조작/조회 |  |  |  |
| AC-3c2c38b3 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SSP0009_Shipment_Plan_FG.cs:1645 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (chosedFromSite.ToString() == popupReturnSite) ▸ f… | DATA_OP | defaultData.Add | (DefMain.FROM_SITE, bod.second_site) | 데이터 객체 조작/조회 |  |  |  |
| AC-34e99efa | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SSP0009_Shipment_Plan_FG.cs:1648 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (chosedFromSite.ToString() == popupReturnSite) ▸ f… | DATA_OP | defaultData.Add | (DefMain.SHIP_FROZEN, bod.ship_frozen) | 데이터 객체 조작/조회 |  |  |  |
| AC-3a97f7cd | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SSP0009_Shipment_Plan_FG.cs:1649 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (chosedFromSite.ToString() == popupReturnSite) ▸ f… | DATA_OP | defaultData.Add | (DefMain.MEASURE_ORDER_NO, row["MEASURE_ORDER_NO"]) | 데이터 객체 조작/조회 |  |  |  |
| AC-39f6f606 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SSP0009_Shipment_Plan_FG.cs:1651 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (chosedFromSite.ToString() == popupReturnSite) ▸ f… | DATA_OP | defaultData.Add | (DefMain.PLAN_START_YYYYMMDD, row["plan_start_yyyymmdd"]) | 데이터 객체 조작/조회 |  |  |  |
| AC-c32dffe4 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SSP0009_Shipment_Plan_FG.cs:1652 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (chosedFromSite.ToString() == popupReturnSite) ▸ f… | DATA_OP | defaultData.Add | (DefMain.PLAN_TYPE, row["plan_type"]) | 데이터 객체 조작/조회 |  |  |  |
| AC-71291919 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SSP0009_Shipment_Plan_FG.cs:1653 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (chosedFromSite.ToString() == popupReturnSite) ▸ f… | DATA_OP | defaultData.Add | (DefMain.SEQ, row["seq"]) | 데이터 객체 조작/조회 |  |  |  |
| AC-de55e7fa | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SSP0009_Shipment_Plan_FG.cs:1654 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (chosedFromSite.ToString() == popupReturnSite) ▸ f… | DATA_OP | defaultData.Add | (DefMain.TO_YYYYMMDD, row["to_yyyymmdd"]) | 데이터 객체 조작/조회 |  |  |  |
| AC-56233ee5 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… | SSP0009_Shipment_Plan_FG.cs:1655 | if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var bod in popup.retList) ▸ else of (chosedFromSite.ToString() == popupReturnSite) ▸ f… | GRID_SET | siMain.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |

## SSP0009_Shipment_Plan_FG.RetIntValue

진입점: FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ for (iRow < dsBinding.Tables[0].Rows.Count) ▸ for (iCol < dsBinding.Tables[0].Columns.Count) ▸ else of (colName.IndexOf("M_") == 0) ▸ else of (colName.IndexOf("W_") == 0) ▸ if (colName.IndexOf("D_") == 0)] / SaveButton [if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (iCount > 0) ▸ if (tran.Success) ▸ try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ for (iRow < dsBinding.Tables[0].Rows.Count) ▸ for (iCol < dsBinding.Tables[0].Columns.Count) ▸ else of (colName.IndexOf("M_") == 0…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-05f6ec99 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ … 외 1 | SSP0009_Shipment_Plan_FG.cs:1479 |  | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |

## SSP0009_Shipment_Plan_FG.SaveData_Main

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f8ca4f0f | SaveButton | SSP0009_Shipment_Plan_FG.cs:1843 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (siMain.ActiveSheet.Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f3eac6dd | SaveButton | SSP0009_Shipment_Plan_FG.cs:1850 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-74ee2a32 | SaveButton | SSP0009_Shipment_Plan_FG.cs:1852 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-36e1f273 | SaveButton | SSP0009_Shipment_Plan_FG.cs:1869 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (iRow < siMain.ActiveSheet.Rows.… | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-d15caae4 | SaveButton | SSP0009_Shipment_Plan_FG.cs:1871 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (iRow < siMain.ActiveSheet.Rows.… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0a8988df | SaveButton | SSP0009_Shipment_Plan_FG.cs:1878 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (iRow < siMain.ActiveSheet.Rows.… | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-21c25a33 | SaveButton | SSP0009_Shipment_Plan_FG.cs:1880 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (iRow < siMain.ActiveSheet.Rows.… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-52c5f6ca | SaveButton | SSP0009_Shipment_Plan_FG.cs:1892 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (iRow < siMain.ActiveSheet.Rows.… | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-e7c0b928 | SaveButton | SSP0009_Shipment_Plan_FG.cs:1894 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (iRow < siMain.ActiveSheet.Rows.… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-921a470a | SaveButton | SSP0009_Shipment_Plan_FG.cs:1902 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | FLAG | saveDS | new DataSet() | 화면 필드/플래그 변경 |  |  |  |
| AC-a3907abd | SaveButton | SSP0009_Shipment_Plan_FG.cs:1904 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dt.Columns.Add | ("A", typeof(char)) | 데이터 객체 조작/조회 |  |  |  |
| AC-e114a1b5 | SaveButton | SSP0009_Shipment_Plan_FG.cs:1905 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dt.Columns.Add | ("p_active_flag") | 데이터 객체 조작/조회 |  |  |  |
| AC-ebd82950 | SaveButton | SSP0009_Shipment_Plan_FG.cs:1906 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dt.Columns.Add | ("p_division_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-371577e7 | SaveButton | SSP0009_Shipment_Plan_FG.cs:1907 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dt.Columns.Add | ("p_plan_start_yyyymmdd") | 데이터 객체 조작/조회 |  |  |  |
| AC-ed1f447a | SaveButton | SSP0009_Shipment_Plan_FG.cs:1908 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dt.Columns.Add | ("p_plan_type") | 데이터 객체 조작/조회 |  |  |  |
| AC-44f29725 | SaveButton | SSP0009_Shipment_Plan_FG.cs:1909 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dt.Columns.Add | ("p_seq") | 데이터 객체 조작/조회 |  |  |  |
| AC-eb96ad3a | SaveButton | SSP0009_Shipment_Plan_FG.cs:1910 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dt.Columns.Add | ("p_biz_type") | 데이터 객체 조작/조회 |  |  |  |
| AC-9bd76f4f | SaveButton | SSP0009_Shipment_Plan_FG.cs:1911 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dt.Columns.Add | ("p_project_code") | 데이터 객체 조작/조회 |  |  |  |
| AC-0c1d3ead | SaveButton | SSP0009_Shipment_Plan_FG.cs:1912 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dt.Columns.Add | ("p_item_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-38044348 | SaveButton | SSP0009_Shipment_Plan_FG.cs:1913 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dt.Columns.Add | ("p_to_site") | 데이터 객체 조작/조회 |  |  |  |
| AC-1ec1c620 | SaveButton | SSP0009_Shipment_Plan_FG.cs:1914 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dt.Columns.Add | ("p_incoterms") | 데이터 객체 조작/조회 |  |  |  |
| AC-11f4b6f6 | SaveButton | SSP0009_Shipment_Plan_FG.cs:1915 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dt.Columns.Add | ("p_from_site") | 데이터 객체 조작/조회 |  |  |  |
| AC-9d73e025 | SaveButton | SSP0009_Shipment_Plan_FG.cs:1916 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dt.Columns.Add | ("p_bod_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-522674fb | SaveButton | SSP0009_Shipment_Plan_FG.cs:1917 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dt.Columns.Add | ("p_measure") | 데이터 객체 조작/조회 |  |  |  |
| AC-b69d028b | SaveButton | SSP0009_Shipment_Plan_FG.cs:1918 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dt.Columns.Add | ("p_yyyymmdd") | 데이터 객체 조작/조회 |  |  |  |
| AC-0a2426d2 | SaveButton | SSP0009_Shipment_Plan_FG.cs:1919 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dt.Columns.Add | ("p_qty") | 데이터 객체 조작/조회 |  |  |  |
| AC-5c2eecbe | SaveButton | SSP0009_Shipment_Plan_FG.cs:1920 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dt.Columns.Add | ("p_created_by") | 데이터 객체 조작/조회 |  |  |  |
| AC-a48a3416 | SaveButton | SSP0009_Shipment_Plan_FG.cs:1921 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dt.Columns.Add | ("p_last_updated_by") | 데이터 객체 조작/조회 |  |  |  |
| AC-6f51d6e6 | SaveButton | SSP0009_Shipment_Plan_FG.cs:1922 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dt.Columns.Add | ("p_time_zone") | 데이터 객체 조작/조회 |  |  |  |
| AC-cd4b6cef | SaveButton | SSP0009_Shipment_Plan_FG.cs:1923 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dt.Columns.Add | ("p_first_row") | 데이터 객체 조작/조회 |  |  |  |
| AC-d9be1a46 | SaveButton | SSP0009_Shipment_Plan_FG.cs:1924 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | dt.Columns.Add | ("p_last_row") | 데이터 객체 조작/조회 |  |  |  |
| AC-044a52f3 | SaveButton | SSP0009_Shipment_Plan_FG.cs:1925 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | saveDS.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-a90323f0 | SaveButton | SSP0009_Shipment_Plan_FG.cs:1955 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | saveDS.Tables[0].NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-199e1821 | SaveButton | SSP0009_Shipment_Plan_FG.cs:1956 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["A"] | action | 행/컬럼 값 대입 |  |  |  |
| AC-5ebc077b | SaveButton | SSP0009_Shipment_Plan_FG.cs:1957 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_active_flag"] | action | 행/컬럼 값 대입 |  |  |  |
| AC-f538b769 | SaveButton | SSP0009_Shipment_Plan_FG.cs:1958 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_division_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.DIVISION_ID)) | 행/컬럼 값 대입 |  |  |  |
| AC-6249d984 | SaveButton | SSP0009_Shipment_Plan_FG.cs:1959 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-6fa74a43 | SaveButton | SSP0009_Shipment_Plan_FG.cs:1960 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-74fb2e02 | SaveButton | SSP0009_Shipment_Plan_FG.cs:1961 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-089453ab | SaveButton | SSP0009_Shipment_Plan_FG.cs:1962 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_biz_type"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.BIZ_TYPE)) | 행/컬럼 값 대입 |  |  |  |
| AC-71ee0769 | SaveButton | SSP0009_Shipment_Plan_FG.cs:1963 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_project_code"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.PROJECT_CODE)) | 행/컬럼 값 대입 |  |  |  |
| AC-4b617456 | SaveButton | SSP0009_Shipment_Plan_FG.cs:1964 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_item_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.ITEM_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-306f6d66 | SaveButton | SSP0009_Shipment_Plan_FG.cs:1965 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_to_site"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.TO_SITE)) | 행/컬럼 값 대입 |  |  |  |
| AC-d74ed415 | SaveButton | SSP0009_Shipment_Plan_FG.cs:1966 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_incoterms"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.INCOTERMS)) | 행/컬럼 값 대입 |  |  |  |
| AC-4dcb13b8 | SaveButton | SSP0009_Shipment_Plan_FG.cs:1967 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_from_site"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.FROM_SITE)) | 행/컬럼 값 대입 |  |  |  |
| AC-af947f13 | SaveButton | SSP0009_Shipment_Plan_FG.cs:1968 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_bod_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.BOD_ID)) | 행/컬럼 값 대입 |  |  |  |
| AC-57bbfbda | SaveButton | SSP0009_Shipment_Plan_FG.cs:1969 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_measure"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.MEASURE)) | 행/컬럼 값 대입 |  |  |  |
| AC-e7284b40 | SaveButton | SSP0009_Shipment_Plan_FG.cs:1972 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_yyyymmdd"] | yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-2f337e14 | SaveButton | SSP0009_Shipment_Plan_FG.cs:1973 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_qty"] | 0 | 행/컬럼 값 대입 |  |  |  |
| AC-31baabda | SaveButton | SSP0009_Shipment_Plan_FG.cs:1974 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_created_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-e6db96be | SaveButton | SSP0009_Shipment_Plan_FG.cs:1975 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_last_updated_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-797f8bc6 | SaveButton | SSP0009_Shipment_Plan_FG.cs:1976 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_time_zone"] | UserInfoContext.Current[UserInfoProperites.TimeZone] | 행/컬럼 값 대입 |  |  |  |
| AC-e9664aa5 | SaveButton | SSP0009_Shipment_Plan_FG.cs:1978 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | saveDS.Tables[0].Rows.Add | (dr) | 데이터 객체 조작/조회 |  |  |  |
| AC-a8493c57 | SaveButton | SSP0009_Shipment_Plan_FG.cs:1990 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | saveDS.Tables[0].NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-e3b83f58 | SaveButton | SSP0009_Shipment_Plan_FG.cs:1991 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["A"] | action | 행/컬럼 값 대입 |  |  |  |
| AC-534b09fc | SaveButton | SSP0009_Shipment_Plan_FG.cs:1992 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_active_flag"] | action | 행/컬럼 값 대입 |  |  |  |
| AC-55e371b9 | SaveButton | SSP0009_Shipment_Plan_FG.cs:1993 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_division_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.DIVISION_ID)) | 행/컬럼 값 대입 |  |  |  |
| AC-00d1ceb5 | SaveButton | SSP0009_Shipment_Plan_FG.cs:1994 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-bf3de377 | SaveButton | SSP0009_Shipment_Plan_FG.cs:1995 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-b7a30580 | SaveButton | SSP0009_Shipment_Plan_FG.cs:1996 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-5e7e4d69 | SaveButton | SSP0009_Shipment_Plan_FG.cs:1997 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_biz_type"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.BIZ_TYPE)) | 행/컬럼 값 대입 |  |  |  |
| AC-882b6f93 | SaveButton | SSP0009_Shipment_Plan_FG.cs:1998 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_project_code"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.PROJECT_CODE)) | 행/컬럼 값 대입 |  |  |  |
| AC-24aa4a57 | SaveButton | SSP0009_Shipment_Plan_FG.cs:1999 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_item_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.ITEM_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-afc12925 | SaveButton | SSP0009_Shipment_Plan_FG.cs:2001 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_to_site"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.TO_SITE)) | 행/컬럼 값 대입 |  |  |  |
| AC-4b50f280 | SaveButton | SSP0009_Shipment_Plan_FG.cs:2002 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_incoterms"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.INCOTERMS)) | 행/컬럼 값 대입 |  |  |  |
| AC-f6805419 | SaveButton | SSP0009_Shipment_Plan_FG.cs:2003 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_from_site"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.FROM_SITE)) | 행/컬럼 값 대입 |  |  |  |
| AC-80497ef0 | SaveButton | SSP0009_Shipment_Plan_FG.cs:2004 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_bod_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.BOD_ID)) | 행/컬럼 값 대입 |  |  |  |
| AC-8cabfe66 | SaveButton | SSP0009_Shipment_Plan_FG.cs:2005 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_measure"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.MEASURE)) | 행/컬럼 값 대입 |  |  |  |
| AC-1868398b | SaveButton | SSP0009_Shipment_Plan_FG.cs:2008 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_yyyymmdd"] | yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-a203e0ae | SaveButton | SSP0009_Shipment_Plan_FG.cs:2009 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_qty"] | val | 행/컬럼 값 대입 |  |  |  |
| AC-954085f3 | SaveButton | SSP0009_Shipment_Plan_FG.cs:2010 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_created_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-f8a6d156 | SaveButton | SSP0009_Shipment_Plan_FG.cs:2011 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_last_updated_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-7837dac7 | SaveButton | SSP0009_Shipment_Plan_FG.cs:2012 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_time_zone"] | UserInfoContext.Current[UserInfoProperites.TimeZone] | 행/컬럼 값 대입 |  |  |  |
| AC-29bfc4da | SaveButton | SSP0009_Shipment_Plan_FG.cs:2014 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | saveDS.Tables[0].Rows.Add | (dr) | 데이터 객체 조작/조회 |  |  |  |
| AC-de59b48e | SaveButton | SSP0009_Shipment_Plan_FG.cs:2030 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | saveDS.Tables[0].NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-6bf3a8bb | SaveButton | SSP0009_Shipment_Plan_FG.cs:2031 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["A"] | action | 행/컬럼 값 대입 |  |  |  |
| AC-09dba9ac | SaveButton | SSP0009_Shipment_Plan_FG.cs:2032 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_active_flag"] | action | 행/컬럼 값 대입 |  |  |  |
| AC-50e9909d | SaveButton | SSP0009_Shipment_Plan_FG.cs:2033 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_division_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.DIVISION_ID)) | 행/컬럼 값 대입 |  |  |  |
| AC-4fba9d7d | SaveButton | SSP0009_Shipment_Plan_FG.cs:2034 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-5d1e037a | SaveButton | SSP0009_Shipment_Plan_FG.cs:2035 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-c9f73a01 | SaveButton | SSP0009_Shipment_Plan_FG.cs:2036 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-a7948d25 | SaveButton | SSP0009_Shipment_Plan_FG.cs:2037 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_biz_type"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.BIZ_TYPE)) | 행/컬럼 값 대입 |  |  |  |
| AC-73f3851f | SaveButton | SSP0009_Shipment_Plan_FG.cs:2038 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_project_code"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.PROJECT_CODE)) | 행/컬럼 값 대입 |  |  |  |
| AC-4d0cf4e7 | SaveButton | SSP0009_Shipment_Plan_FG.cs:2039 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_item_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.ITEM_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-32c15717 | SaveButton | SSP0009_Shipment_Plan_FG.cs:2041 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_to_site"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.TO_SITE)) | 행/컬럼 값 대입 |  |  |  |
| AC-9fef433c | SaveButton | SSP0009_Shipment_Plan_FG.cs:2042 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_incoterms"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.INCOTERMS)) | 행/컬럼 값 대입 |  |  |  |
| AC-89920559 | SaveButton | SSP0009_Shipment_Plan_FG.cs:2043 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_from_site"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.FROM_SITE)) | 행/컬럼 값 대입 |  |  |  |
| AC-c34e7652 | SaveButton | SSP0009_Shipment_Plan_FG.cs:2044 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_bod_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.BOD_ID)) | 행/컬럼 값 대입 |  |  |  |
| AC-f5f88b15 | SaveButton | SSP0009_Shipment_Plan_FG.cs:2045 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_measure"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.MEASURE)) | 행/컬럼 값 대입 |  |  |  |
| AC-81b008d7 | SaveButton | SSP0009_Shipment_Plan_FG.cs:2048 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_yyyymmdd"] | yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-d33f355f | SaveButton | SSP0009_Shipment_Plan_FG.cs:2049 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_qty"] | strQty | 행/컬럼 값 대입 |  |  |  |
| AC-fe027c2f | SaveButton | SSP0009_Shipment_Plan_FG.cs:2050 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_created_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-2f82d481 | SaveButton | SSP0009_Shipment_Plan_FG.cs:2051 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_last_updated_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-5288eab7 | SaveButton | SSP0009_Shipment_Plan_FG.cs:2052 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | dr["p_time_zone"] | UserInfoContext.Current[UserInfoProperites.TimeZone] | 행/컬럼 값 대입 |  |  |  |
| AC-6daf8b1e | SaveButton | SSP0009_Shipment_Plan_FG.cs:2054 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (i < siMain.ActiveSheet.Rows.Cou… | DATA_OP | saveDS.Tables[0].Rows.Add | (dr) | 데이터 객체 조작/조회 |  |  |  |
| AC-e93d5399 | SaveButton | SSP0009_Shipment_Plan_FG.cs:2060 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | GRID_SET | saveDS.Tables[0].Rows[0]["p_first_row"] | "Y" | 그리드 속성/값 설정 |  |  |  |
| AC-973eea5a | SaveButton | SSP0009_Shipment_Plan_FG.cs:2061 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | GRID_SET | saveDS.Tables[0].Rows[iCount - 1]["p_last_row"] | "Y" | 그리드 속성/값 설정 |  |  |  |
| AC-83139333 | SaveButton | SSP0009_Shipment_Plan_FG.cs:2063 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try | DATA_OP | saveDS.Tables[0].AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-8af0ab26 | SaveButton | SSP0009_Shipment_Plan_FG.cs:2070 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (iCount > 0) ▸ foreach (DataRow r… | CALL_EXT | row.SetAdded | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-f932f3bd | SaveButton | SSP0009_Shipment_Plan_FG.cs:2071 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (iCount > 0) ▸ foreach (DataRow r… | CALL_EXT | row.SetModified | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-ff05a673 | SaveButton | SSP0009_Shipment_Plan_FG.cs:2072 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (iCount > 0) ▸ foreach (DataRow r… | DATA_OP | row.Delete | () | 데이터 객체 조작/조회 |  |  |  |
| AC-47c12090 | SaveButton | SSP0009_Shipment_Plan_FG.cs:2076 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (iCount > 0) | UI_PROP | req.InsertQueryId | "SCP.SCP0009_SAVE_ANL_SHIPMENT_PLAN_FG" | 속성 InsertQueryId 설정 |  |  |  |
| AC-1a50ffcd | SaveButton | SSP0009_Shipment_Plan_FG.cs:2077 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (iCount > 0) | UI_PROP | req.DeleteQueryId | "SCP.SCP0009_SAVE_ANL_SHIPMENT_PLAN_FG" | 속성 DeleteQueryId 설정 |  |  |  |
| AC-f6dbb291 | SaveButton | SSP0009_Shipment_Plan_FG.cs:2078 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (iCount > 0) | UI_PROP | req.UpdateQueryId | "SCP.SCP0009_SAVE_ANL_SHIPMENT_PLAN_FG" | 속성 UpdateQueryId 설정 |  |  |  |
| AC-471001ae | SaveButton | SSP0009_Shipment_Plan_FG.cs:2079 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (iCount > 0) | UI_PROP | req.DataSet | saveDS.GetChanges() | 속성 DataSet 설정 |  |  |  |
| AC-f0fcdc93 | SaveButton | SSP0009_Shipment_Plan_FG.cs:2079 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (iCount > 0) | CALL_EXT | saveDS.GetChanges | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-79fe8ea1 | SaveButton | SSP0009_Shipment_Plan_FG.cs:2082 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (iCount > 0) | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-39cea6dd | SaveButton | SSP0009_Shipment_Plan_FG.cs:2084 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (iCount > 0) | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCP.Analysis.WSL/FoxDataServi… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-36ba4de7 | SaveButton | SSP0009_Shipment_Plan_FG.cs:2086 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (iCount > 0) ▸ lambda | ENDPOINT | client.SaveDataTable | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a8f60659 | SaveButton | SSP0009_Shipment_Plan_FG.cs:2086 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (iCount > 0) ▸ lambda | RETURN | return client.SaveDataTable(req); |  | 처리 중단/반환 |  |  |  |
| AC-a73f4f85 | SaveButton | SSP0009_Shipment_Plan_FG.cs:2091 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (iCount > 0) ▸ if (tran.Success) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-53571dff | SaveButton | SSP0009_Shipment_Plan_FG.cs:2092 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (iCount > 0) ▸ if (tran.Success) | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { iCount }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-681b8144 | SaveButton | SSP0009_Shipment_Plan_FG.cs:2101 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-698b93bd | SaveButton | SSP0009_Shipment_Plan_FG.cs:2103 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a758cb52 | SaveButton | SSP0009_Shipment_Plan_FG.cs:2105 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-4a67f76f | SaveButton | SSP0009_Shipment_Plan_FG.cs:2106 | if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## SSP0009_Shipment_Plan_FG.Set_FixButtonEnabled

진입점: cboPlanDate.SelectedIndexChanged / cboPlanType.SelectedIndexChanged / cboPlanSeq.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7ba448e3 | cboPlanDate.SelectedIndexChanged 외 2 | SSP0009_Shipment_Plan_FG.cs:2421 | if (sPlanType.Equals("FN")) | STATE | btnFix.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-8b7e99cd | cboPlanDate.SelectedIndexChanged 외 2 | SSP0009_Shipment_Plan_FG.cs:2422 | if (sPlanType.Equals("FN")) | STATE | btnUnfix.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-b35edd20 | cboPlanDate.SelectedIndexChanged 외 2 | SSP0009_Shipment_Plan_FG.cs:2427 | else of (sPlanType.Equals("FN")) ▸ if (!string.IsNullOrEmpty(CString.GetCheckedListValue(dtPlanSeq, cboPlanSeq.ControlValues, true))) | DATA_OP | dtPlanSeq.AsEnumerable().Select | (a => a.Field<int>("CODE")) | 데이터 객체 조작/조회 |  |  |  |
| AC-2d5cec64 | cboPlanDate.SelectedIndexChanged 외 2 | SSP0009_Shipment_Plan_FG.cs:2427 | else of (sPlanType.Equals("FN")) ▸ if (!string.IsNullOrEmpty(CString.GetCheckedListValue(dtPlanSeq, cboPlanSeq.ControlValues, true))) ▸ lamb… | DATA_OP | a.Field | ("CODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-a0ae2c93 | cboPlanDate.SelectedIndexChanged 외 2 | SSP0009_Shipment_Plan_FG.cs:2430 | else of (sPlanType.Equals("FN")) ▸ if (!string.IsNullOrEmpty(CString.GetCheckedListValue(dtPlanSeq, cboPlanSeq.ControlValues, true))) ▸ if (… | STATE | btnFix.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-dbbf5452 | cboPlanDate.SelectedIndexChanged 외 2 | SSP0009_Shipment_Plan_FG.cs:2431 | else of (sPlanType.Equals("FN")) ▸ if (!string.IsNullOrEmpty(CString.GetCheckedListValue(dtPlanSeq, cboPlanSeq.ControlValues, true))) ▸ if (… | STATE | btnUnfix.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-24f8b594 | cboPlanDate.SelectedIndexChanged 외 2 | SSP0009_Shipment_Plan_FG.cs:2434 | else of (sPlanType.Equals("FN")) ▸ if (!string.IsNullOrEmpty(CString.GetCheckedListValue(dtPlanSeq, cboPlanSeq.ControlValues, true))) ▸ else… | STATE | btnFix.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-a0c117f5 | cboPlanDate.SelectedIndexChanged 외 2 | SSP0009_Shipment_Plan_FG.cs:2435 | else of (sPlanType.Equals("FN")) ▸ if (!string.IsNullOrEmpty(CString.GetCheckedListValue(dtPlanSeq, cboPlanSeq.ControlValues, true))) ▸ else… | STATE | btnUnfix.Enabled | false | 컨트롤 상태 Enabled |  |  |  |

## SSP0009_Shipment_Plan_FG.Set_FPOperationColor

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-020ea7a5 | (진입점 미연결) | SSP0009_Shipment_Plan_FG.cs:1236 | for (iRow < siMain.ActiveSheet.Rows.Count) ▸ if (siMain.ActiveSheet.GetText(iRow, siMain.GetColumnIndex(DefMain.MEASURE)).ToString() == "SHI… | GRID_STYLE | siMain.SetBGColor | (iRow, nCol, iRow, nCol, Color.FromArgb(234, 234, 234)) | 그리드 표시 설정 |  |  |  |

## SSP0009_Shipment_Plan_FG.Set_InsertColumnsFont

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-061c13c8 | (진입점 미연결) | SSP0009_Shipment_Plan_FG.cs:1734 | if (bBold) | UI_PROP | range1.Font | new System.Drawing.Font(spdMain.Font.Name, spdMain.Font.Size, FontStyle.Bold) | 속성 Font 설정 |  |  |  |
| AC-7855c263 | (진입점 미연결) | SSP0009_Shipment_Plan_FG.cs:1737 | else of (bBold) | UI_PROP | range1.Font | new System.Drawing.Font(spdMain.Font.Name, spdMain.Font.Size, FontStyle.Regular) | 속성 Font 설정 |  |  |  |

## SSP0009_Shipment_Plan_FG.Set_SumValues

진입점: FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] / SaveButton [if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ if (iCount > 0) ▸ if (tran.Success) ▸ try ▸ if (dsBinding.Tables[0].Rows.Count > 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-82ca6202 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] 외 1 | SSP0009_Shipment_Plan_FG.cs:1344 | for (iRow < dsBinding.Tables[0].Rows.Count) ▸ for (iCol < dsBinding.Tables[0].Columns.Count) ▸ if (colName.IndexOf("M_") == 0) ▸ if (bef_mon… | GRID_SET | dsBinding.Tables[0].Rows[iRow][bef_month_idx] | sum_month | 그리드 속성/값 설정 |  |  |  |
| AC-2c4ba881 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] 외 1 | SSP0009_Shipment_Plan_FG.cs:1353 | for (iRow < dsBinding.Tables[0].Rows.Count) ▸ for (iCol < dsBinding.Tables[0].Columns.Count) ▸ if (colName.IndexOf("M_") == 0) ▸ if (bef_mon… | GRID_SET | dsBinding.Tables[0].Rows[iRow][bef_month_idx] | qty | 그리드 속성/값 설정 |  |  |  |
| AC-0b9c5934 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] 외 1 | SSP0009_Shipment_Plan_FG.cs:1362 | for (iRow < dsBinding.Tables[0].Rows.Count) ▸ for (iCol < dsBinding.Tables[0].Columns.Count) ▸ else of (colName.IndexOf("M_") == 0) ▸ if (co… | GRID_SET | dsBinding.Tables[0].Rows[iRow][bef_week_idx] | sum_week | 그리드 속성/값 설정 |  |  |  |
| AC-5bd899c1 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] 외 1 | SSP0009_Shipment_Plan_FG.cs:1371 | for (iRow < dsBinding.Tables[0].Rows.Count) ▸ for (iCol < dsBinding.Tables[0].Columns.Count) ▸ else of (colName.IndexOf("M_") == 0) ▸ if (co… | GRID_SET | dsBinding.Tables[0].Rows[iRow][bef_week_idx] | qty | 그리드 속성/값 설정 |  |  |  |
| AC-dad22d40 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] 외 1 | SSP0009_Shipment_Plan_FG.cs:1389 | for (iRow < dsBinding.Tables[0].Rows.Count) ▸ for (iCol < dsBinding.Tables[0].Columns.Count) ▸ else of (colName.IndexOf("M_") == 0) ▸ else o… | GRID_SET | dsBinding.Tables[0].Rows[iRow][bef_week_idx] | sum_week | 그리드 속성/값 설정 |  |  |  |
| AC-abbb79a6 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] 외 1 | SSP0009_Shipment_Plan_FG.cs:1390 | for (iRow < dsBinding.Tables[0].Rows.Count) ▸ for (iCol < dsBinding.Tables[0].Columns.Count) ▸ else of (colName.IndexOf("M_") == 0) ▸ else o… | GRID_SET | dsBinding.Tables[0].Rows[iRow][bef_month_idx] | sum_month | 그리드 속성/값 설정 |  |  |  |
| AC-0cb54323 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] 외 1 | SSP0009_Shipment_Plan_FG.cs:1396 | for (iRow < dsBinding.Tables[0].Rows.Count) ▸ for (iCol < dsBinding.Tables[0].Columns.Count) ▸ else of (colName.IndexOf("M_") == 0) ▸ else o… | GRID_SET | dsBinding.Tables[0].Rows[iRow][bef_week_idx] | qty | 그리드 속성/값 설정 |  |  |  |
| AC-62faf94a | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] 외 1 | SSP0009_Shipment_Plan_FG.cs:1397 | for (iRow < dsBinding.Tables[0].Rows.Count) ▸ for (iCol < dsBinding.Tables[0].Columns.Count) ▸ else of (colName.IndexOf("M_") == 0) ▸ else o… | GRID_SET | dsBinding.Tables[0].Rows[iRow][bef_month_idx] | qty | 그리드 속성/값 설정 |  |  |  |
| AC-eb10e5e6 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] 외 1 | SSP0009_Shipment_Plan_FG.cs:1403 | for (iRow < dsBinding.Tables[0].Rows.Count) ▸ for (iCol < dsBinding.Tables[0].Columns.Count) ▸ else of (colName.IndexOf("M_") == 0) ▸ else o… | GRID_SET | dsBinding.Tables[0].Rows[iRow][bef_week_idx] | sum_week | 그리드 속성/값 설정 |  |  |  |
| AC-75554ca0 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] 외 1 | SSP0009_Shipment_Plan_FG.cs:1404 | for (iRow < dsBinding.Tables[0].Rows.Count) ▸ for (iCol < dsBinding.Tables[0].Columns.Count) ▸ else of (colName.IndexOf("M_") == 0) ▸ else o… | GRID_SET | dsBinding.Tables[0].Rows[iRow][bef_month_idx] | sum_month | 그리드 속성/값 설정 |  |  |  |
| AC-c4b2feaf | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] 외 1 | SSP0009_Shipment_Plan_FG.cs:1410 | for (iRow < dsBinding.Tables[0].Rows.Count) ▸ for (iCol < dsBinding.Tables[0].Columns.Count) ▸ else of (colName.IndexOf("M_") == 0) ▸ else o… | GRID_SET | dsBinding.Tables[0].Rows[iRow][bef_week_idx] | qty | 그리드 속성/값 설정 |  |  |  |
| AC-222215b5 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] 외 1 | SSP0009_Shipment_Plan_FG.cs:1411 | for (iRow < dsBinding.Tables[0].Rows.Count) ▸ for (iCol < dsBinding.Tables[0].Columns.Count) ▸ else of (colName.IndexOf("M_") == 0) ▸ else o… | GRID_SET | dsBinding.Tables[0].Rows[iRow][bef_month_idx] | qty | 그리드 속성/값 설정 |  |  |  |

## SSP0009_Shipment_Plan_FG.SetChangedControl

진입점: this.Load / cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f556f4a4 | this.Load 외 1 | SSP0009_Shipment_Plan_FG.cs:291 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ if (pDivisionID == "EE") | FLAG | dtOperGrp | Data_SCP.Common(Data_SCP.Type.OperationGroupEE, false) | 화면 필드/플래그 변경 |  |  |  |
| AC-084ee4b1 | this.Load 외 1 | SSP0009_Shipment_Plan_FG.cs:291 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ if (pDivisionID == "EE") | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.OperationGroupEE, false) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-43671907 | this.Load 외 1 | SSP0009_Shipment_Plan_FG.cs:293 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ else of (pDivisionID == "EE") | FLAG | dtOperGrp | Data_SCP.Common(Data_SCP.Type.OperationGroup, false) | 화면 필드/플래그 변경 |  |  |  |
| AC-d7bf12de | this.Load 외 1 | SSP0009_Shipment_Plan_FG.cs:293 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ else of (pDivisionID == "EE") | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.OperationGroup, false) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-55e09c70 | this.Load 외 1 | SSP0009_Shipment_Plan_FG.cs:294 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | LIST_REBIND | clsCtrl.setListBox | (dtOperGrp, cboBizType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-bc46b739 | this.Load 외 1 | SSP0009_Shipment_Plan_FG.cs:296 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | FLAG | dtPlanDate | Data.Common(Data.Type.PlanDateShip, false, pDivisionID) ⇒ biz:CommonData.CommonDataList [code=PlanDateShip] | 화면 필드/플래그 변경 |  |  |  |
| AC-71220fff | this.Load 외 1 | SSP0009_Shipment_Plan_FG.cs:296 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | COMBO_DATA | Data.Common | (Data.Type.PlanDateShip, false, pDivisionID) ⇒ biz:CommonData.CommonDataList [code=PlanDateShip] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-e14ea20f | this.Load 외 1 | SSP0009_Shipment_Plan_FG.cs:297 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | LIST_REBIND | clsCtrl.setListBox | (dtPlanDate, cboPlanDate, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-f296b3f1 | this.Load 외 1 | SSP0009_Shipment_Plan_FG.cs:300 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | FLAG | dtPlanType | Data.Common(Data.Type.PlanTypeShip, false, pDivisionID, pPlanDate) ⇒ biz:CommonData.CommonDataList [code=PlanTypeShip] | 화면 필드/플래그 변경 |  |  |  |
| AC-9af6c966 | this.Load 외 1 | SSP0009_Shipment_Plan_FG.cs:300 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | COMBO_DATA | Data.Common | (Data.Type.PlanTypeShip, false, pDivisionID, pPlanDate) ⇒ biz:CommonData.CommonDataList [code=PlanTypeShip] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-9788722f | this.Load 외 1 | SSP0009_Shipment_Plan_FG.cs:301 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | LIST_REBIND | clsCtrl.setListBox | (dtPlanType, cboPlanType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-4f29d828 | this.Load 외 1 | SSP0009_Shipment_Plan_FG.cs:304 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ if (dtPlanType.Rows.Count > 0) | VALUE_SET | cboPlanType.SelectedIndex | dtPlanType.Rows.Count - 1 | 컨트롤 값 설정 |  |  |  |
| AC-09b58a40 | this.Load 외 1 | SSP0009_Shipment_Plan_FG.cs:307 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | FLAG | dtPlanSeq | Data.Common(Data.Type.PlanSeqShip, false, pDivisionID, pPlanDate, pPlanType) ⇒ biz:CommonData.CommonDataList [code=PlanSeqShip] | 화면 필드/플래그 변경 |  |  |  |
| AC-bf8e8294 | this.Load 외 1 | SSP0009_Shipment_Plan_FG.cs:307 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | COMBO_DATA | Data.Common | (Data.Type.PlanSeqShip, false, pDivisionID, pPlanDate, pPlanType) ⇒ biz:CommonData.CommonDataList [code=PlanSeqShip] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-307e594d | this.Load 외 1 | SSP0009_Shipment_Plan_FG.cs:308 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | LIST_REBIND | clsCtrl.setListBox | (dtPlanSeq, cboPlanSeq, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-98a4c0dd | this.Load 외 1 | SSP0009_Shipment_Plan_FG.cs:314 | if (pDivisionID != "EE") | VALUE_CLEAR | clbElectrode.ControlValues | "" | 컨트롤 값 비움 |  |  |  |
| AC-0ad94f93 | this.Load 외 1 | SSP0009_Shipment_Plan_FG.cs:315 | if (pDivisionID != "EE") | STATE | clbElectrode.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-4768b70c | this.Load 외 1 | SSP0009_Shipment_Plan_FG.cs:319 | else of (pDivisionID != "EE") | STATE | clbElectrode.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## SSP0009_Shipment_Plan_FG.SetDataTableQtyData

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e201d61f | (진입점 미연결) | SSP0009_Shipment_Plan_FG.cs:468 | for (i < source.Rows.Count) ▸ for (j < source.Columns.Count) ▸ if (columnName.IndexOf("D_") == 0) | GRID_SET | target.Rows[i][columnName] | source.Rows[i][columnName] | 그리드 속성/값 설정 |  |  |  |
| AC-3ffb3dd0 | (진입점 미연결) | SSP0009_Shipment_Plan_FG.cs:474 |  | DATA_OP | target.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |

## SSP0009_Shipment_Plan_FG.SetSpreadColumn

진입점: this.chkSum.CheckedChanged [if (siMain != null)] / this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] / this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >= 0) ▸ if (siMain.GetValue(e.Row, siMain.GetColumnIndex(DefMain.MEASURE)).ToString().Equals("MKT_FCST")) ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / this.cboBucketType.SelectedIndexChanged [if (siMain != null)] / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (spdInfo.SheetName == SpdSheet.shtM…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0898a131 | this.chkSum.CheckedChanged [if (siMain != null)] 외 7 | SSP0009_Shipment_Plan_FG.cs:2503 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Daily) ▸ if (siObj.GetColumnTag(iCol).IndexOf("D_") … | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-bfd62db6 | this.chkSum.CheckedChanged [if (siMain != null)] 외 7 | SSP0009_Shipment_Plan_FG.cs:2507 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Daily) ▸ if (siObj.GetColumnTag(iCol).IndexOf("M_") … | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | chkSum.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-03456c18 | this.chkSum.CheckedChanged [if (siMain != null)] 외 7 | SSP0009_Shipment_Plan_FG.cs:2512 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Buc… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-978a7195 | this.chkSum.CheckedChanged [if (siMain != null)] 외 7 | SSP0009_Shipment_Plan_FG.cs:2515 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Buc… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-9d4ed148 | this.chkSum.CheckedChanged [if (siMain != null)] 외 7 | SSP0009_Shipment_Plan_FG.cs:2519 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Buc… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | chkSum.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-4409dfc0 | this.chkSum.CheckedChanged [if (siMain != null)] 외 7 | SSP0009_Shipment_Plan_FG.cs:2524 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ else of (cboBucketType.ControlValues =… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-b736313a | this.chkSum.CheckedChanged [if (siMain != null)] 외 7 | SSP0009_Shipment_Plan_FG.cs:2527 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ else of (cboBucketType.ControlValues =… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |

## SSP0009_Shipment_Plan_FG.SpdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e461dbcc | this.spdMain.CellClick | SSP0009_Shipment_Plan_FG.cs:769 | if (siMain.IsLock(siMain.SheetName)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SSP0009_Shipment_Plan_FG.SpdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ce8b0d9f | this.spdMain.CellDoubleClick | SSP0009_Shipment_Plan_FG.cs:2240 |  | CALL_EXT | siMain.SetDblClickColumnShowHide | (sender, e) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d46f6702 | this.spdMain.CellDoubleClick | SSP0009_Shipment_Plan_FG.cs:2244 | if (e.Column < this._LastHeader_Idx \|\| siMain.GetColumnTag(e.Column).IndexOf("M_") == 0 \|\| siMain.GetColumnTag(e.Column).Ind…) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SSP0009_Shipment_Plan_FG.SpdMain_KeyUp

진입점: this.spdMain.KeyUp

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-03c224ff | this.spdMain.KeyUp | SSP0009_Shipment_Plan_FG.cs:750 | if (siMain.GetColumnIndex(DefMain.MEASURE) >= siMain.ActiveColumnIndex) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8f04fef1 | this.spdMain.KeyUp | SSP0009_Shipment_Plan_FG.cs:753 | if (e.Control == true && e.KeyCode == Keys.V \|\| e.Control == false && e.KeyCode == Keys.V) | CALL_EXT | spdMain.ActiveSheet.ClipboardPaste | (ClipboardPasteOptions.AsStringSkipHidden) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c6724a7c | this.spdMain.KeyUp | SSP0009_Shipment_Plan_FG.cs:757 | if (e.Control == true && e.KeyCode == Keys.C \|\| e.Control == false && e.KeyCode == Keys.C) | CALL_EXT | Clipboard.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-85c33064 | this.spdMain.KeyUp | SSP0009_Shipment_Plan_FG.cs:758 | if (e.Control == true && e.KeyCode == Keys.C \|\| e.Control == false && e.KeyCode == Keys.C) | CALL_EXT | spdMain.Sheets[0].ClipboardCopy | (ClipboardCopyOptions.AsStringSkipHidden) | ⚠ 의미 확인 필요 |  |  |  |

## SSP0009_Shipment_Plan_FG.SpdMain_TopChange

진입점: this.spdMain.CellClick [if ((e.Column == siMain.GetColumnIndex(DefMain.TRANSPORT_MODE) \|\| e.Column == siMain.GetColumnIndex(DefMain.FROM_SITE_NAME))…)] / this.spdMain.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1e376c17 | this.spdMain.CellClick [if ((e.Column == siMain.GetColumnInd… 외 1 | SSP0009_Shipment_Plan_FG.cs:764 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SSP0009_Shipment_Plan_FG.TotalCellsMerge

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e7560b65 | (진입점 미연결) | SSP0009_Shipment_Plan_FG.cs:1249 |  | DATA_OP | list.Add | (siMain.GetColumnIndex(DefMain.FROM_SITE_NAME)) | 데이터 객체 조작/조회 |  |  |  |
| AC-e7af88c1 | (진입점 미연결) | SSP0009_Shipment_Plan_FG.cs:1250 |  | DATA_OP | list.Add | (siMain.GetColumnIndex(DefMain.TRANSPORT_MODE)) | 데이터 객체 조작/조회 |  |  |  |
| AC-337c1fd6 | (진입점 미연결) | SSP0009_Shipment_Plan_FG.cs:1251 |  | DATA_OP | list.Add | (siMain.GetColumnIndex(DefMain.LT_DAY)) | 데이터 객체 조작/조회 |  |  |  |
| AC-539b965e | (진입점 미연결) | SSP0009_Shipment_Plan_FG.cs:1273 | for (iRow <= siMain.GetMaxRowIndex()) ▸ if (cur_key_idx != bef_key_idx) ▸ foreach (int idx in list) | UI_PROP | range.HorizontalAlignment | CellHorizontalAlignment.Center | 속성 HorizontalAlignment 설정 |  |  |  |
| AC-3136cc79 | (진입점 미연결) | SSP0009_Shipment_Plan_FG.cs:1274 | for (iRow <= siMain.GetMaxRowIndex()) ▸ if (cur_key_idx != bef_key_idx) ▸ foreach (int idx in list) | UI_PROP | range.ForeColor | Color.Black | 속성 ForeColor 설정 |  |  |  |
| AC-a0cd6ca8 | (진입점 미연결) | SSP0009_Shipment_Plan_FG.cs:1275 | for (iRow <= siMain.GetMaxRowIndex()) ▸ if (cur_key_idx != bef_key_idx) ▸ foreach (int idx in list) | UI_PROP | range.RowSpan | rowSpan_Count | 속성 RowSpan 설정 |  |  |  |
| AC-4c342c0f | (진입점 미연결) | SSP0009_Shipment_Plan_FG.cs:1279 | for (iRow <= siMain.GetMaxRowIndex()) ▸ if (cur_key_idx != bef_key_idx) | UI_PROP | boh.HorizontalAlignment | CellHorizontalAlignment.Center | 속성 HorizontalAlignment 설정 |  |  |  |
| AC-1d2def58 | (진입점 미연결) | SSP0009_Shipment_Plan_FG.cs:1280 | for (iRow <= siMain.GetMaxRowIndex()) ▸ if (cur_key_idx != bef_key_idx) | UI_PROP | boh.RowSpan | bohSpan_Count | 속성 RowSpan 설정 |  |  |  |
| AC-f2171b03 | (진입점 미연결) | SSP0009_Shipment_Plan_FG.cs:1305 | for (iRow <= siMain.GetMaxRowIndex()) ▸ if (iRow == siMain.GetMaxRowIndex()) ▸ if (isSum) ▸ foreach (int idx in list) | UI_PROP | range.HorizontalAlignment | CellHorizontalAlignment.Center | 속성 HorizontalAlignment 설정 |  |  |  |
| AC-c017951a | (진입점 미연결) | SSP0009_Shipment_Plan_FG.cs:1306 | for (iRow <= siMain.GetMaxRowIndex()) ▸ if (iRow == siMain.GetMaxRowIndex()) ▸ if (isSum) ▸ foreach (int idx in list) | UI_PROP | range.ForeColor | Color.Black | 속성 ForeColor 설정 |  |  |  |
| AC-0e09a564 | (진입점 미연결) | SSP0009_Shipment_Plan_FG.cs:1307 | for (iRow <= siMain.GetMaxRowIndex()) ▸ if (iRow == siMain.GetMaxRowIndex()) ▸ if (isSum) ▸ foreach (int idx in list) | UI_PROP | range.RowSpan | rowSpan_Count | 속성 RowSpan 설정 |  |  |  |
| AC-28bdbc6f | (진입점 미연결) | SSP0009_Shipment_Plan_FG.cs:1311 | for (iRow <= siMain.GetMaxRowIndex()) ▸ if (iRow == siMain.GetMaxRowIndex()) ▸ if (isSum) | UI_PROP | boh.HorizontalAlignment | CellHorizontalAlignment.Center | 속성 HorizontalAlignment 설정 |  |  |  |
| AC-5c8d7ff7 | (진입점 미연결) | SSP0009_Shipment_Plan_FG.cs:1312 | for (iRow <= siMain.GetMaxRowIndex()) ▸ if (iRow == siMain.GetMaxRowIndex()) ▸ if (isSum) | UI_PROP | boh.RowSpan | bohSpan_Count | 속성 RowSpan 설정 |  |  |  |

## SSP0009_Shipment_Plan_FG.ValidateUserInput

진입점: SaveButton [if (fps.Name == spdMain.Name) ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ try ▸ for (iRow < siMain.ActiveSheet.Rows.Count) ▸ if (action == CAppSetting.FlagI && measure_name.Equals("SHIP_PLAN_AMEND")) ▸ for (iCol < siMain.GetMaxColumnIndex()) ▸ if (!string.IsNullOrEmpty(val)) ▸ if (nDayQty < 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-93c22988 | SaveButton [if (fps.Name == spdMain.Name) ▸ if (siMain != nu… | SSP0009_Shipment_Plan_FG.cs:2120 | if (action_name.Equals("NO_DATA")) ▸ if (siMain.ActiveSheet.RowCount <= 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00059") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-5031d4a2 | SaveButton [if (fps.Name == spdMain.Name) ▸ if (siMain != nu… | SSP0009_Shipment_Plan_FG.cs:2126 | else of (action_name.Equals("NO_DATA")) ▸ if (action_name.Equals("NO_CHECKED")) | MESSAGE | MessageHelper.GMessageBox | ("MSG00017") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6dc94898 | SaveButton [if (fps.Name == spdMain.Name) ▸ if (siMain != nu… | SSP0009_Shipment_Plan_FG.cs:2138 | else of (action_name.Equals("NO_DATA")) ▸ else of (action_name.Equals("NO_CHECKED")) ▸ if (action_name.Equals("CHK_PERIOD")) ▸ if (DateTime.… | MESSAGE | MessageHelper.GMessageBox | ("MSG00171") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-324048ec | SaveButton [if (fps.Name == spdMain.Name) ▸ if (siMain != nu… | SSP0009_Shipment_Plan_FG.cs:2140 | else of (action_name.Equals("NO_DATA")) ▸ else of (action_name.Equals("NO_CHECKED")) ▸ if (action_name.Equals("CHK_PERIOD")) ▸ if (DateTime.… | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |
| AC-45713fc4 | SaveButton [if (fps.Name == spdMain.Name) ▸ if (siMain != nu… | SSP0009_Shipment_Plan_FG.cs:2145 | else of (action_name.Equals("NO_DATA")) ▸ else of (action_name.Equals("NO_CHECKED")) ▸ if (action_name.Equals("CHK_PERIOD")) ▸ if (diff.Days… | MESSAGE | MessageHelper.GMessageBox | ("MSG00172", new object[] { 364 }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0b150208 | SaveButton [if (fps.Name == spdMain.Name) ▸ if (siMain != nu… | SSP0009_Shipment_Plan_FG.cs:2152 | else of (action_name.Equals("NO_DATA")) ▸ else of (action_name.Equals("NO_CHECKED")) ▸ else of (action_name.Equals("CHK_PERIOD")) ▸ if (acti… | MESSAGE | MessageHelper.GMessageBox | ("MSG00084") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6b310514 | SaveButton [if (fps.Name == spdMain.Name) ▸ if (siMain != nu… | SSP0009_Shipment_Plan_FG.cs:2156 |  | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |

