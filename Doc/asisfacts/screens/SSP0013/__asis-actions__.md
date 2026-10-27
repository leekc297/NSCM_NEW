# AS-IS 액션 대조표 — SSP0013

> 원천: `Doc/asisfacts/screens/SSP0013/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 568행 · 메서드 35 · 종류 DATA_OP 149 · GRID_SET 137 · RETURN 48 · GRID_INIT 31 · MESSAGE 31 · FLAG 30 · ENDPOINT 24 · GRID_STYLE 18 · POPUP 16 · UI_PROP 16 · CALL_EXT 13 · UI_MISC 12 · GRID_LOCK 9 · LIST_REBIND 9 · COMBO_DATA 8 · VALUE_SET 6 · VALIDATE 3 · GRID_BIND 3 · STATE_RESET 2 · VALUE_CLEAR 2 · GRID_COMBO 1 · ⚠ 의미 확인 필요 13


## SSP0013_ShipmentPlanAdjustment.BtnChecked_Click

진입점: this.btnChecked.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-57c4bf56 | this.btnChecked.Click | SSP0013_ShipmentPlanAdjustment.cs:3080 | if (siMain.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SSP0013_ShipmentPlanAdjustment.btnItemId_Click

진입점: this.btnItemId.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5f118b56 | this.btnItemId.Click | SSP0013_ShipmentPlanAdjustment.cs:3029 |  | POPUP | new SCM0002_ItembyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-0b953ef9 | this.btnItemId.Click | SSP0013_ShipmentPlanAdjustment.cs:3031 |  | POPUP | popItem.Form_Load | (true, sdivision, sScmSite, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-d558daf6 | this.btnItemId.Click | SSP0013_ShipmentPlanAdjustment.cs:3032 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-2a811993 | this.btnItemId.Click | SSP0013_ShipmentPlanAdjustment.cs:3033 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-2a8d2da9 | this.btnItemId.Click | SSP0013_ShipmentPlanAdjustment.cs:3039 | if (popItem.ItemID != "") | VALUE_SET | txtRequest.Text | sItemId | 컨트롤 값 설정 |  |  |  |

## SSP0013_ShipmentPlanAdjustment.BtnItemID2_Click

진입점: this.btnItemID2.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-806fbaf5 | this.btnItemID2.Click | SSP0013_ShipmentPlanAdjustment.cs:3052 |  | POPUP | new SCM0002_ItembyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-8ee6be29 | this.btnItemID2.Click | SSP0013_ShipmentPlanAdjustment.cs:3054 |  | POPUP | popItem.Form_Load | (true, sdivision, sScmSite, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-3ff5eb8b | this.btnItemID2.Click | SSP0013_ShipmentPlanAdjustment.cs:3055 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-31a7bebc | this.btnItemID2.Click | SSP0013_ShipmentPlanAdjustment.cs:3056 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-a961ff62 | this.btnItemID2.Click | SSP0013_ShipmentPlanAdjustment.cs:3062 | if (popItem.ItemID != "") | VALUE_SET | txtModel2.Text | sItemId | 컨트롤 값 설정 |  |  |  |

## SSP0013_ShipmentPlanAdjustment.BtnSearch_Click

진입점: this.btnSearch.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d352e38f | this.btnSearch.Click | SSP0013_ShipmentPlanAdjustment.cs:3072 |  | GRID_INIT | siSub.ChangeSheet | (SpdSheet.shtSub) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-646a1c30 | this.btnSearch.Click | SSP0013_ShipmentPlanAdjustment.cs:3073 |  | GRID_INIT | siSub.ChangeActiveSheet | (SpdSheet.shtSub) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SSP0013_ShipmentPlanAdjustment.chkERPIFBlockYn

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a8cc443d | SaveButton | SSP0013_ShipmentPlanAdjustment.cs:2046 |  | FLAG | dtERPBlockYnIF | Data_SCP.Common(Data_SCP.Type.SSPBlockCheckIF, false, "SSP0013") | 화면 필드/플래그 변경 |  |  |  |
| AC-c2bfc601 | SaveButton | SSP0013_ShipmentPlanAdjustment.cs:2046 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.SSPBlockCheckIF, false, "SSP0013") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c23f1d72 | SaveButton | SSP0013_ShipmentPlanAdjustment.cs:2049 | if (null != dtERPBlockYnIF && dtERPBlockYnIF.Rows.Count > 0) | DATA_OP | dtERPBlockYnIF.Rows[0].Field | ("BLOCK_YN") | 데이터 객체 조작/조회 |  |  |  |
| AC-5bf1fbba | SaveButton | SSP0013_ShipmentPlanAdjustment.cs:2058 | if (null != dtERPBlockYnIF && dtERPBlockYnIF.Rows.Count > 0) ▸ if (blockYn == "Y") | DATA_OP | dtERPBlockYnIF.Rows[0].Field | ("PERIOD") | 데이터 객체 조작/조회 |  |  |  |
| AC-7ab7d93f | SaveButton | SSP0013_ShipmentPlanAdjustment.cs:2059 | if (null != dtERPBlockYnIF && dtERPBlockYnIF.Rows.Count > 0) ▸ if (blockYn == "Y") | MESSAGE | MessageHelper.GMessageBox | ("MSG00267", new object[] { arg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b326cf31 | SaveButton | SSP0013_ShipmentPlanAdjustment.cs:2063 |  | RETURN | return resultYn; |  | 처리 중단/반환 |  |  |  |

## SSP0013_ShipmentPlanAdjustment.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f354bfad | this.Load | SSP0013_ShipmentPlanAdjustment.cs:426 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-2b2d8558 | this.Load | SSP0013_ShipmentPlanAdjustment.cs:427 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-d83023eb | this.Load | SSP0013_ShipmentPlanAdjustment.cs:430 |  | GRID_INIT | this.AddSheet | (spdSub, SpdSheet.shtSub, SpdSheet.shtSub, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-450bf371 | this.Load | SSP0013_ShipmentPlanAdjustment.cs:431 |  | GRID_INIT | this.AddSheet | (spdSub, SpdSheet.shtSubDetail, SpdSheet.shtSubDetail, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-87badb82 | this.Load | SSP0013_ShipmentPlanAdjustment.cs:433 |  | FLAG | siSub | GetSheetInfo(spdSub.Name, SpdSheet.shtSub) | 화면 필드/플래그 변경 |  |  |  |
| AC-1aeb1ed0 | this.Load | SSP0013_ShipmentPlanAdjustment.cs:434 |  | GRID_INIT | siSub.ChangeSheet | (SpdSheet.shtSub) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-aed6568c | this.Load | SSP0013_ShipmentPlanAdjustment.cs:437 |  | FLAG | siSub | GetSheetInfo(spdSub.Name, SpdSheet.shtSubDetail) | 화면 필드/플래그 변경 |  |  |  |
| AC-ea5eef76 | this.Load | SSP0013_ShipmentPlanAdjustment.cs:438 |  | GRID_INIT | siSub.ChangeSheet | (SpdSheet.shtSubDetail) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c1b5b337 | this.Load | SSP0013_ShipmentPlanAdjustment.cs:441 |  | GRID_INIT | siSub.ChangeSheet | (SpdSheet.shtSub) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-72dcc7ce | this.Load | SSP0013_ShipmentPlanAdjustment.cs:445 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SSP0013_ShipmentPlanAdjustment.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-19a342c4 | this.Load | SSP0013_ShipmentPlanAdjustment.cs:312 |  | UI_PROP | siMain.ImagePopUp | imageList1.Images[0] | 속성 ImagePopUp 설정 |  |  |  |
| AC-036f7080 | this.Load | SSP0013_ShipmentPlanAdjustment.cs:314 |  | FLAG | cellTypeImage | new TextCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-6ead4737 | this.Load | SSP0013_ShipmentPlanAdjustment.cs:315 |  | UI_PROP | cellTypeImage.BackgroundImage | new FarPoint.Win.Picture(siMain.ImagePopUp) | 속성 BackgroundImage 설정 |  |  |  |
| AC-26b4dc7c | this.Load | SSP0013_ShipmentPlanAdjustment.cs:316 |  | UI_PROP | cellTypeImage.BackgroundImage.AlignHorz | FarPoint.Win.HorizontalAlignment.Right | 속성 AlignHorz 설정 |  |  |  |

## SSP0013_ShipmentPlanAdjustment.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-81341011 | Dispose | SSP0013_ShipmentPlanAdjustment.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SSP0013_ShipmentPlanAdjustment.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-09dcd9c7 | EditButton | SSP0013_ShipmentPlanAdjustment.cs:550 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-048b1424 | EditButton | SSP0013_ShipmentPlanAdjustment.cs:554 | if (fps.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (siMain.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7b256667 | EditButton | SSP0013_ShipmentPlanAdjustment.cs:583 | if (fps.ActiveSheet.SheetName == SpdSheet.shtMain) | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-b2a15e2a | EditButton | SSP0013_ShipmentPlanAdjustment.cs:584 | if (fps.ActiveSheet.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-adcf71f5 | EditButton | SSP0013_ShipmentPlanAdjustment.cs:589 | if (fps.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (siMain.IsLock(siMain.SheetName) == false) | GRID_LOCK | siMain.LockRange2 | (0, siMain.GetColumnIndex(DefColumns.CHK), siMain.ActiveSheet.RowCount - 1, siMain.GetColu… | 그리드 편집 잠금 전환 |  |  |  |
| AC-9bb7c283 | EditButton | SSP0013_ShipmentPlanAdjustment.cs:593 | if (fps.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (siMain.IsLock(siMain.SheetName) == false) | GRID_LOCK | siMain.LockRange2 | (0, siMain.GetColumnIndex(DefColumns.CHK), siMain.ActiveSheet.RowCount - 1, siMain.GetColu… | 그리드 편집 잠금 전환 |  |  |  |
| AC-23c219bb | EditButton | SSP0013_ShipmentPlanAdjustment.cs:597 | if (fps.ActiveSheet.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.DIVISION_ID), siMain.GetColumnIndex(DefColumns.BEFORE_QT… | 그리드 편집 잠금/해제 |  |  |  |
| AC-61cc8136 | EditButton | SSP0013_ShipmentPlanAdjustment.cs:598 | if (fps.ActiveSheet.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.REMARKS3), siMain.GetColumnIndex(DefColumns.CONFIRM_ID),… | 그리드 편집 잠금/해제 |  |  |  |
| AC-73324ed7 | EditButton | SSP0013_ShipmentPlanAdjustment.cs:620 | if (fps.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < siMain.ActiveSheet.RowCount) ▸ if (sCheckYn == "Y") | GRID_STYLE | siMain.SetBGColor2 | (iRow, siMain.GetColumnIndex(DefColumns.SHIPMENT_CONFIRM_QTY), iRow, siMain.GetColumnIndex… | 그리드 표시 설정 |  |  |  |
| AC-daff5bca | EditButton | SSP0013_ShipmentPlanAdjustment.cs:629 | if (fps.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < siMain.ActiveSheet.RowCount) ▸ if (siMain.IsLock(siMain.SheetName) == false… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.SHIPMENT_CONFIRM_QTY), iRow, siMain.GetColumnIndex… | 그리드 편집 잠금/해제 |  |  |  |
| AC-ab6f79a3 | EditButton | SSP0013_ShipmentPlanAdjustment.cs:637 | else of (fps.ActiveSheet.SheetName == SpdSheet.shtMain) | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f064133d | EditButton | SSP0013_ShipmentPlanAdjustment.cs:638 | else of (fps.ActiveSheet.SheetName == SpdSheet.shtMain) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SSP0013_ShipmentPlanAdjustment.EngProcessingChk

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3ade4156 | SaveButton | SSP0013_ShipmentPlanAdjustment.cs:2075 | try | ENDPOINT | new FoxDataRequest | ("SSP.SSP0003_GET_SSP_PLAN_PROCESSING_CHECK") ⇒ SSP.SSP0003_GET_SSP_PLAN_PROCESSING_CHECK | 엔드포인트 요청 생성 |  |  |  |
| AC-fc226952 | SaveButton | SSP0013_ShipmentPlanAdjustment.cs:2076 | try | DATA_OP | request.Parameters["p_division_id"] | pDivisionID | 행/컬럼 값 대입 |  |  |  |
| AC-db8f34e2 | SaveButton | SSP0013_ShipmentPlanAdjustment.cs:2078 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-7453e127 | SaveButton | SSP0013_ShipmentPlanAdjustment.cs:2088 | try ▸ if (ds.Tables[0].Rows[0][0].ToString() == "Y") | MESSAGE | MessageHelper.GMessageBox | ("MSG00291", new object[] { remainMinute }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0aab7989 | SaveButton | SSP0013_ShipmentPlanAdjustment.cs:2098 | catch ((Exception ex)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-6531b528 | SaveButton | SSP0013_ShipmentPlanAdjustment.cs:2100 |  | RETURN | return bReturn; |  | 처리 중단/반환 |  |  |  |

## SSP0013_ShipmentPlanAdjustment.FindData_Main

진입점: this.btnChecked.Click [try ▸ if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "S")] / FindButton / SaveButton [try ▸ if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "S")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e39f40d1 | this.btnChecked.Click [try ▸ if (iCount > 0) ▸ if (ds.Tables… 외 2 | SSP0013_ShipmentPlanAdjustment.cs:707 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-70e99812 | this.btnChecked.Click [try ▸ if (iCount > 0) ▸ if (ds.Tables… 외 2 | SSP0013_ShipmentPlanAdjustment.cs:713 | try | VALIDATE | DateUtil.Check_PeriodDate | (drpPeriod) | 프레임워크 검증 |  |  |  |
| AC-6159019e | this.btnChecked.Click [try ▸ if (iCount > 0) ▸ if (ds.Tables… 외 2 | SSP0013_ShipmentPlanAdjustment.cs:713 | try ▸ if (!DateUtil.Check_PeriodDate(drpPeriod)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-17770dd1 | this.btnChecked.Click [try ▸ if (iCount > 0) ▸ if (ds.Tables… 외 2 | SSP0013_ShipmentPlanAdjustment.cs:717 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-6334e2b5 | this.btnChecked.Click [try ▸ if (iCount > 0) ▸ if (ds.Tables… 외 2 | SSP0013_ShipmentPlanAdjustment.cs:730 | try | CALL_EXT | CString.GetComboBoxValue | (cboChecked.SelectedValue) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d1fb9a28 | this.btnChecked.Click [try ▸ if (iCount > 0) ▸ if (ds.Tables… 외 2 | SSP0013_ShipmentPlanAdjustment.cs:737 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-06038417 | this.btnChecked.Click [try ▸ if (iCount > 0) ▸ if (ds.Tables… 외 2 | SSP0013_ShipmentPlanAdjustment.cs:738 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SSP.Plan.WSL/FoxDataService.s… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-6ff14e4d | this.btnChecked.Click [try ▸ if (iCount > 0) ▸ if (ds.Tables… 외 2 | SSP0013_ShipmentPlanAdjustment.cs:742 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SSP.SSP0013_GET_SHIPMENT_PLAN_CHANGE") ⇒ SSP.SSP0013_GET_SHIPMENT_PLAN_CHANGE | 엔드포인트 요청 생성 |  |  |  |
| AC-b0aad5d7 | this.btnChecked.Click [try ▸ if (iCount > 0) ▸ if (ds.Tables… 외 2 | SSP0013_ShipmentPlanAdjustment.cs:743 | try ▸ lambda | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-98861cb6 | this.btnChecked.Click [try ▸ if (iCount > 0) ▸ if (ds.Tables… 외 2 | SSP0013_ShipmentPlanAdjustment.cs:744 | try ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-af0b24ca | this.btnChecked.Click [try ▸ if (iCount > 0) ▸ if (ds.Tables… 외 2 | SSP0013_ShipmentPlanAdjustment.cs:745 | try ▸ lambda | DATA_OP | request.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-4d709dd4 | this.btnChecked.Click [try ▸ if (iCount > 0) ▸ if (ds.Tables… 외 2 | SSP0013_ShipmentPlanAdjustment.cs:746 | try ▸ lambda | DATA_OP | request.Parameters["p_to_site"] | p_to_site | 행/컬럼 값 대입 |  |  |  |
| AC-106741a1 | this.btnChecked.Click [try ▸ if (iCount > 0) ▸ if (ds.Tables… 외 2 | SSP0013_ShipmentPlanAdjustment.cs:747 | try ▸ lambda | DATA_OP | request.Parameters["p_erp_so_no"] | p_erp_so_no | 행/컬럼 값 대입 |  |  |  |
| AC-9b2540cb | this.btnChecked.Click [try ▸ if (iCount > 0) ▸ if (ds.Tables… 외 2 | SSP0013_ShipmentPlanAdjustment.cs:748 | try ▸ lambda | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-c483fb95 | this.btnChecked.Click [try ▸ if (iCount > 0) ▸ if (ds.Tables… 외 2 | SSP0013_ShipmentPlanAdjustment.cs:749 | try ▸ lambda | DATA_OP | request.Parameters["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-69ffa3b6 | this.btnChecked.Click [try ▸ if (iCount > 0) ▸ if (ds.Tables… 외 2 | SSP0013_ShipmentPlanAdjustment.cs:750 | try ▸ lambda | DATA_OP | request.Parameters["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-ec557fec | this.btnChecked.Click [try ▸ if (iCount > 0) ▸ if (ds.Tables… 외 2 | SSP0013_ShipmentPlanAdjustment.cs:751 | try ▸ lambda | DATA_OP | request.Parameters["p_status"] | p_status | 행/컬럼 값 대입 |  |  |  |
| AC-379cf39f | this.btnChecked.Click [try ▸ if (iCount > 0) ▸ if (ds.Tables… 외 2 | SSP0013_ShipmentPlanAdjustment.cs:752 | try ▸ lambda | DATA_OP | request.Parameters["p_change_type"] | p_change_type | 행/컬럼 값 대입 |  |  |  |
| AC-8939c507 | this.btnChecked.Click [try ▸ if (iCount > 0) ▸ if (ds.Tables… 외 2 | SSP0013_ShipmentPlanAdjustment.cs:753 | try ▸ lambda | DATA_OP | request.Parameters["p_language"] | sLanguage | 행/컬럼 값 대입 |  |  |  |
| AC-640a036b | this.btnChecked.Click [try ▸ if (iCount > 0) ▸ if (ds.Tables… 외 2 | SSP0013_ShipmentPlanAdjustment.cs:754 | try ▸ lambda | DATA_OP | request.Parameters["p_checked"] | p_checked | 행/컬럼 값 대입 |  |  |  |
| AC-d1e13403 | this.btnChecked.Click [try ▸ if (iCount > 0) ▸ if (ds.Tables… 외 2 | SSP0013_ShipmentPlanAdjustment.cs:755 | try ▸ lambda | DATA_OP | request.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-dcb498b8 | this.btnChecked.Click [try ▸ if (iCount > 0) ▸ if (ds.Tables… 외 2 | SSP0013_ShipmentPlanAdjustment.cs:756 | try ▸ lambda | DATA_OP | request.Parameters["p_myModelChk"] | p_myModelChk | 행/컬럼 값 대입 |  |  |  |
| AC-53fa2df8 | this.btnChecked.Click [try ▸ if (iCount > 0) ▸ if (ds.Tables… 외 2 | SSP0013_ShipmentPlanAdjustment.cs:757 | try ▸ lambda | DATA_OP | request.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-ba81afdf | this.btnChecked.Click [try ▸ if (iCount > 0) ▸ if (ds.Tables… 외 2 | SSP0013_ShipmentPlanAdjustment.cs:759 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-4cd3a751 | this.btnChecked.Click [try ▸ if (iCount > 0) ▸ if (ds.Tables… 외 2 | SSP0013_ShipmentPlanAdjustment.cs:761 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-02b57870 | this.btnChecked.Click [try ▸ if (iCount > 0) ▸ if (ds.Tables… 외 2 | SSP0013_ShipmentPlanAdjustment.cs:768 | try | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-f6fd1505 | this.btnChecked.Click [try ▸ if (iCount > 0) ▸ if (ds.Tables… 외 2 | SSP0013_ShipmentPlanAdjustment.cs:769 | try | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.DIVISION_ID), siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-4c27bac7 | this.btnChecked.Click [try ▸ if (iCount > 0) ▸ if (ds.Tables… 외 2 | SSP0013_ShipmentPlanAdjustment.cs:774 | try ▸ if (DefaultMainDS != null) | STATE_RESET | DefaultMainDS.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-94fabf0e | this.btnChecked.Click [try ▸ if (iCount > 0) ▸ if (ds.Tables… 외 2 | SSP0013_ShipmentPlanAdjustment.cs:776 | try | FLAG | DefaultMainDS | ds.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-d26814fa | this.btnChecked.Click [try ▸ if (iCount > 0) ▸ if (ds.Tables… 외 2 | SSP0013_ShipmentPlanAdjustment.cs:776 | try | DATA_OP | ds.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-98bafbc1 | this.btnChecked.Click [try ▸ if (iCount > 0) ▸ if (ds.Tables… 외 2 | SSP0013_ShipmentPlanAdjustment.cs:779 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-ca020831 | this.btnChecked.Click [try ▸ if (iCount > 0) ▸ if (ds.Tables… 외 2 | SSP0013_ShipmentPlanAdjustment.cs:789 | try | GRID_INIT | siSub.ChangeSheet | (SpdSheet.shtSubDetail) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5e777aff | this.btnChecked.Click [try ▸ if (iCount > 0) ▸ if (ds.Tables… 외 2 | SSP0013_ShipmentPlanAdjustment.cs:790 | try | GRID_INIT | siSub.ChangeActiveSheet | (SpdSheet.shtSubDetail) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-0920c226 | this.btnChecked.Click [try ▸ if (iCount > 0) ▸ if (ds.Tables… 외 2 | SSP0013_ShipmentPlanAdjustment.cs:793 | try | GRID_INIT | siSub.ChangeSheet | (SpdSheet.shtSub) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-09c4c0f6 | this.btnChecked.Click [try ▸ if (iCount > 0) ▸ if (ds.Tables… 외 2 | SSP0013_ShipmentPlanAdjustment.cs:794 | try | GRID_INIT | siSub.ChangeActiveSheet | (SpdSheet.shtSub) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-1d455359 | this.btnChecked.Click [try ▸ if (iCount > 0) ▸ if (ds.Tables… 외 2 | SSP0013_ShipmentPlanAdjustment.cs:797 | try | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtMain) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0bf7fe75 | this.btnChecked.Click [try ▸ if (iCount > 0) ▸ if (ds.Tables… 외 2 | SSP0013_ShipmentPlanAdjustment.cs:798 | try | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-b73385e1 | this.btnChecked.Click [try ▸ if (iCount > 0) ▸ if (ds.Tables… 외 2 | SSP0013_ShipmentPlanAdjustment.cs:806 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SSP0013_ShipmentPlanAdjustment.FindData_Sub

진입점: spdMain.CellDoubleClick [if (siMain != null && siMain.IsLock(siMain.SheetName) == true) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID))] / this.btnSearch.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1e45053b | spdMain.CellDoubleClick [if (siMain != null && siMain.IsLock… 외 1 | SSP0013_ShipmentPlanAdjustment.cs:812 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-ee4e904f | spdMain.CellDoubleClick [if (siMain != null && siMain.IsLock… 외 1 | SSP0013_ShipmentPlanAdjustment.cs:818 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-7c64c7d8 | spdMain.CellDoubleClick [if (siMain != null && siMain.IsLock… 외 1 | SSP0013_ShipmentPlanAdjustment.cs:828 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-720254f5 | spdMain.CellDoubleClick [if (siMain != null && siMain.IsLock… 외 1 | SSP0013_ShipmentPlanAdjustment.cs:829 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SSP.Plan.WSL/FoxDataService.s… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-b5d5b852 | spdMain.CellDoubleClick [if (siMain != null && siMain.IsLock… 외 1 | SSP0013_ShipmentPlanAdjustment.cs:833 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SSP.SSP0013_GET_STOCK_INFOMATION") ⇒ SSP.SSP0013_GET_STOCK_INFOMATION | 엔드포인트 요청 생성 |  |  |  |
| AC-10226385 | spdMain.CellDoubleClick [if (siMain != null && siMain.IsLock… 외 1 | SSP0013_ShipmentPlanAdjustment.cs:834 | try ▸ lambda | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-5a742322 | spdMain.CellDoubleClick [if (siMain != null && siMain.IsLock… 외 1 | SSP0013_ShipmentPlanAdjustment.cs:835 | try ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-0de893cd | spdMain.CellDoubleClick [if (siMain != null && siMain.IsLock… 외 1 | SSP0013_ShipmentPlanAdjustment.cs:836 | try ▸ lambda | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-fd039993 | spdMain.CellDoubleClick [if (siMain != null && siMain.IsLock… 외 1 | SSP0013_ShipmentPlanAdjustment.cs:838 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-8b8f7c35 | spdMain.CellDoubleClick [if (siMain != null && siMain.IsLock… 외 1 | SSP0013_ShipmentPlanAdjustment.cs:840 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-d1dee65d | spdMain.CellDoubleClick [if (siMain != null && siMain.IsLock… 외 1 | SSP0013_ShipmentPlanAdjustment.cs:847 | try | GRID_BIND | siSub.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-51fc6e8c | spdMain.CellDoubleClick [if (siMain != null && siMain.IsLock… 외 1 | SSP0013_ShipmentPlanAdjustment.cs:848 | try | GRID_LOCK | siSub.LockColumn | (0, siSub.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-aa42bb73 | spdMain.CellDoubleClick [if (siMain != null && siMain.IsLock… 외 1 | SSP0013_ShipmentPlanAdjustment.cs:850 | try | GRID_INIT | siSub.ChangeSheet | (SpdSheet.shtSubDetail) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f8637123 | spdMain.CellDoubleClick [if (siMain != null && siMain.IsLock… 외 1 | SSP0013_ShipmentPlanAdjustment.cs:851 | try | GRID_INIT | siSub.ChangeActiveSheet | (SpdSheet.shtSubDetail) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-e77e5440 | spdMain.CellDoubleClick [if (siMain != null && siMain.IsLock… 외 1 | SSP0013_ShipmentPlanAdjustment.cs:859 | try ▸ if (ds.Tables[1].Rows.Count > 0) | DATA_OP | ds.Tables[1].Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-5f5f6a26 | spdMain.CellDoubleClick [if (siMain != null && siMain.IsLock… 외 1 | SSP0013_ShipmentPlanAdjustment.cs:861 | try ▸ if (ds.Tables[1].Rows.Count > 0) | DATA_OP | dsDetail.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-d4abf023 | spdMain.CellDoubleClick [if (siMain != null && siMain.IsLock… 외 1 | SSP0013_ShipmentPlanAdjustment.cs:863 | try ▸ if (ds.Tables[1].Rows.Count > 0) | GRID_BIND | siSub.Query | (dsDetail) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-5f43622e | spdMain.CellDoubleClick [if (siMain != null && siMain.IsLock… 외 1 | SSP0013_ShipmentPlanAdjustment.cs:864 | try ▸ if (ds.Tables[1].Rows.Count > 0) | GRID_LOCK | siSub.LockColumn | (0, siSub.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-5be1306e | spdMain.CellDoubleClick [if (siMain != null && siMain.IsLock… 외 1 | SSP0013_ShipmentPlanAdjustment.cs:867 | try | GRID_INIT | siSub.ChangeSheet | (SpdSheet.shtSub) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4441ded3 | spdMain.CellDoubleClick [if (siMain != null && siMain.IsLock… 외 1 | SSP0013_ShipmentPlanAdjustment.cs:868 | try | GRID_INIT | siSub.ChangeActiveSheet | (SpdSheet.shtSub) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-987a5662 | spdMain.CellDoubleClick [if (siMain != null && siMain.IsLock… 외 1 | SSP0013_ShipmentPlanAdjustment.cs:872 | try ▸ if (ds.Tables[2].Rows.Count > 0) | VALUE_SET | txtCreateDate.Text | ds.Tables[2].Rows[0]["CREATION_DATE"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-8c5e68f6 | spdMain.CellDoubleClick [if (siMain != null && siMain.IsLock… 외 1 | SSP0013_ShipmentPlanAdjustment.cs:876 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-ceeee191 | spdMain.CellDoubleClick [if (siMain != null && siMain.IsLock… 외 1 | SSP0013_ShipmentPlanAdjustment.cs:886 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SSP0013_ShipmentPlanAdjustment.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cf73a312 | this.Load | SSP0013_ShipmentPlanAdjustment.cs:248 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SSP0013_ShipmentPlanAdjustment.GetDayRange

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7897f64a | this.Load | SSP0013_ShipmentPlanAdjustment.cs:2120 |  | ENDPOINT | new FoxDataRequest | ("SCP.GET_DATE_RANGE_1MONTH") ⇒ SCP.GET_DATE_RANGE_1MONTH | 엔드포인트 요청 생성 |  |  |  |
| AC-70b7b167 | this.Load | SSP0013_ShipmentPlanAdjustment.cs:2122 |  | DATA_OP | request.Parameters["p_from_date"] | sFromDate | 행/컬럼 값 대입 |  |  |  |
| AC-7b6cec9b | this.Load | SSP0013_ShipmentPlanAdjustment.cs:2123 |  | DATA_OP | request.Parameters["p_offset_day"] | "1" | 행/컬럼 값 대입 |  |  |  |
| AC-d2315892 | this.Load | SSP0013_ShipmentPlanAdjustment.cs:2124 |  | DATA_OP | request.Parameters["p_timezone"] | UserInfoContext.Current[UserInfoProperites.TimeZone] | 행/컬럼 값 대입 |  |  |  |
| AC-9d19879e | this.Load | SSP0013_ShipmentPlanAdjustment.cs:2125 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-2af4a99f | this.Load | SSP0013_ShipmentPlanAdjustment.cs:2128 |  | RETURN | return sDayRange; |  | 처리 중단/반환 |  |  |  |

## SSP0013_ShipmentPlanAdjustment.GetErpIFCheck

진입점: SaveButton [try ▸ try ▸ for (i <= siMain.ActiveSheet.RowCount - 1) ▸ if (string.IsNullOrWhiteSpace(erpSoNo)) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "S") ▸ if (!string.IsNullOrWhiteSpace(sRequestNo))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7771b48b | SaveButton [try ▸ try ▸ for (i <= siMain.ActiveSheet.RowCoun… | SSP0013_ShipmentPlanAdjustment.cs:1957 | try | CALL_EXT | service.FN_ERP_UIWebService | (RequestNo, "C", "") | ⚠ 의미 확인 필요 |  |  |  |
| AC-7ffe2fef | SaveButton [try ▸ try ▸ for (i <= siMain.ActiveSheet.RowCoun… | SSP0013_ShipmentPlanAdjustment.cs:1966 | try ▸ if (service.RtFlag == "E" \|\| service.RtFlag == "F" \|\| service.RtFlag == "C_E") | ENDPOINT | new FoxDataRequest | ("SSP.SSP0013_DELETE_SHIPMENT_REQUEST_DRAFTING") ⇒ SSP.SSP0013_DELETE_SHIPMENT_REQUEST_DRAFTING | 엔드포인트 요청 생성 |  |  |  |
| AC-0d488935 | SaveButton [try ▸ try ▸ for (i <= siMain.ActiveSheet.RowCoun… | SSP0013_ShipmentPlanAdjustment.cs:1967 | try ▸ if (service.RtFlag == "E" \|\| service.RtFlag == "F" \|\| service.RtFlag == "C_E") | DATA_OP | request.Parameters["p_change_request_no"] | p_change_request_no | 행/컬럼 값 대입 |  |  |  |
| AC-e63db3a9 | SaveButton [try ▸ try ▸ for (i <= siMain.ActiveSheet.RowCoun… | SSP0013_ShipmentPlanAdjustment.cs:1968 | try ▸ if (service.RtFlag == "E" \|\| service.RtFlag == "F" \|\| service.RtFlag == "C_E") | DATA_OP | request.Parameters["p_user_id"] | UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-080c2998 | SaveButton [try ▸ try ▸ for (i <= siMain.ActiveSheet.RowCoun… | SSP0013_ShipmentPlanAdjustment.cs:1970 | try ▸ if (service.RtFlag == "E" \|\| service.RtFlag == "F" \|\| service.RtFlag == "C_E") | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-734174ae | SaveButton [try ▸ try ▸ for (i <= siMain.ActiveSheet.RowCoun… | SSP0013_ShipmentPlanAdjustment.cs:1981 | try ▸ if (service.RtFlag == "E") | MESSAGE | MessageHelper.GMessageBox | ("MSG00197", new object[] { arg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0cf87de0 | SaveButton [try ▸ try ▸ for (i <= siMain.ActiveSheet.RowCoun… | SSP0013_ShipmentPlanAdjustment.cs:1988 | try ▸ else of (service.RtFlag == "E") ▸ if (service.RtFlag == "F") | MESSAGE | MessageHelper.GMessageBox | ("MSG00204", new object[] { arg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-092befcd | SaveButton [try ▸ try ▸ for (i <= siMain.ActiveSheet.RowCoun… | SSP0013_ShipmentPlanAdjustment.cs:1993 | try ▸ else of (service.RtFlag == "E") ▸ else of (service.RtFlag == "F") ▸ if (service.RtFlag == "C_E") | MESSAGE | MessageHelper.GMessageBox | ("MSG00306", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-19568c09 | SaveButton [try ▸ try ▸ for (i <= siMain.ActiveSheet.RowCoun… | SSP0013_ShipmentPlanAdjustment.cs:2004 |  | RETURN | return bFlag; |  | 처리 중단/반환 |  |  |  |

## SSP0013_ShipmentPlanAdjustment.GetERPInterface

진입점: SaveButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-38076868 | SaveButton [try] | SSP0013_ShipmentPlanAdjustment.cs:1425 | try ▸ for (i <= siMain.ActiveSheet.RowCount - 1) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM \|\| action == CAppSetti… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-f40afe84 | SaveButton [try] | SSP0013_ShipmentPlanAdjustment.cs:1435 | try ▸ for (i <= siMain.ActiveSheet.RowCount - 1) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM \|\| action == CAppSetti… | DATA_OP | (siMain.ActiveSheet.DataSource as DataSet).Tables[0].Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-ad0ee08e | SaveButton [try] | SSP0013_ShipmentPlanAdjustment.cs:1441 | try ▸ for (i <= siMain.ActiveSheet.RowCount - 1) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM \|\| action == CAppSetti… | MESSAGE | MessageHelper.GMessageBox | ("MSG00247", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b3fb8b80 | SaveButton [try] | SSP0013_ShipmentPlanAdjustment.cs:1442 | try ▸ for (i <= siMain.ActiveSheet.RowCount - 1) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM \|\| action == CAppSetti… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-fa9b9ee4 | SaveButton [try] | SSP0013_ShipmentPlanAdjustment.cs:1450 | try ▸ for (i <= siMain.ActiveSheet.RowCount - 1) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM \|\| action == CAppSetti… | MESSAGE | GSCM.App.Core.Text.MessageHelper.GMessageBox | ("MSG00049", new object[] { "" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9910da19 | SaveButton [try] | SSP0013_ShipmentPlanAdjustment.cs:1451 | try ▸ for (i <= siMain.ActiveSheet.RowCount - 1) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM \|\| action == CAppSetti… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-b17e0a10 | SaveButton [try] | SSP0013_ShipmentPlanAdjustment.cs:1495 | catch ((Exception ex)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-1af23856 | SaveButton [try] | SSP0013_ShipmentPlanAdjustment.cs:1497 |  | RETURN | return bReturn; |  | 처리 중단/반환 |  |  |  |

## SSP0013_ShipmentPlanAdjustment.GetErpSoNoCnt

진입점: SaveButton [try ▸ try ▸ for (i <= siMain.ActiveSheet.RowCount - 1) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM \|\| action == CAppSetting.FlagD) ▸ if (!string.IsNullOrWhiteSpace(erpSoNo))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-88ea82f2 | SaveButton [try ▸ try ▸ for (i <= siMain.ActiveSheet.RowCoun… | SSP0013_ShipmentPlanAdjustment.cs:1883 | try | ENDPOINT | new FoxDataRequest | ("SSP.SSP0013_GET_ERP_SO_NO_CNT") ⇒ SSP.SSP0013_GET_ERP_SO_NO_CNT | 엔드포인트 요청 생성 |  |  |  |
| AC-3d7b761a | SaveButton [try ▸ try ▸ for (i <= siMain.ActiveSheet.RowCoun… | SSP0013_ShipmentPlanAdjustment.cs:1884 | try | DATA_OP | request.Parameters["p_division_id"] | sDivisionID | 행/컬럼 값 대입 |  |  |  |
| AC-21c7b72f | SaveButton [try ▸ try ▸ for (i <= siMain.ActiveSheet.RowCoun… | SSP0013_ShipmentPlanAdjustment.cs:1885 | try | DATA_OP | request.Parameters["p_erp_so_no"] | sErpSoNo | 행/컬럼 값 대입 |  |  |  |
| AC-69557f13 | SaveButton [try ▸ try ▸ for (i <= siMain.ActiveSheet.RowCoun… | SSP0013_ShipmentPlanAdjustment.cs:1887 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-26bd2107 | SaveButton [try ▸ try ▸ for (i <= siMain.ActiveSheet.RowCoun… | SSP0013_ShipmentPlanAdjustment.cs:1895 | catch ((Exception ex)) | RETURN | return iReturn; |  | 처리 중단/반환 |  |  |  |
| AC-1184c1c4 | SaveButton [try ▸ try ▸ for (i <= siMain.ActiveSheet.RowCoun… | SSP0013_ShipmentPlanAdjustment.cs:1897 |  | RETURN | return iReturn; |  | 처리 중단/반환 |  |  |  |

## SSP0013_ShipmentPlanAdjustment.GetShipmentStatusChk

진입점: SaveButton [try ▸ try ▸ for (i <= siMain.ActiveSheet.RowCount - 1) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM \|\| action == CAppSetting.FlagD)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7aa0bee1 | SaveButton [try ▸ try ▸ for (i <= siMain.ActiveSheet.RowCoun… | SSP0013_ShipmentPlanAdjustment.cs:1908 | try | ENDPOINT | new FoxDataRequest | ("SSP.SSP0013_GET_SHIPMENT_STATUS") ⇒ SSP.SSP0013_GET_SHIPMENT_STATUS | 엔드포인트 요청 생성 |  |  |  |
| AC-3e415f70 | SaveButton [try ▸ try ▸ for (i <= siMain.ActiveSheet.RowCoun… | SSP0013_ShipmentPlanAdjustment.cs:1909 | try | DATA_OP | request.Parameters["p_division_id"] | sDivisionID | 행/컬럼 값 대입 |  |  |  |
| AC-757c81ee | SaveButton [try ▸ try ▸ for (i <= siMain.ActiveSheet.RowCoun… | SSP0013_ShipmentPlanAdjustment.cs:1910 | try | DATA_OP | request.Parameters["p_confirm_id"] | sConfirmID | 행/컬럼 값 대입 |  |  |  |
| AC-6653b410 | SaveButton [try ▸ try ▸ for (i <= siMain.ActiveSheet.RowCoun… | SSP0013_ShipmentPlanAdjustment.cs:1912 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-beab6eef | SaveButton [try ▸ try ▸ for (i <= siMain.ActiveSheet.RowCoun… | SSP0013_ShipmentPlanAdjustment.cs:1927 | try ▸ if (ds.Tables[0].Rows.Count > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00248", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-2684fa71 | SaveButton [try ▸ try ▸ for (i <= siMain.ActiveSheet.RowCoun… | SSP0013_ShipmentPlanAdjustment.cs:1941 | try ▸ if (ds.Tables[1].Rows.Count > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00249", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-faadad21 | SaveButton [try ▸ try ▸ for (i <= siMain.ActiveSheet.RowCoun… | SSP0013_ShipmentPlanAdjustment.cs:1945 | catch ((Exception ex)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-52961cd2 | SaveButton [try ▸ try ▸ for (i <= siMain.ActiveSheet.RowCoun… | SSP0013_ShipmentPlanAdjustment.cs:1947 |  | RETURN | return bReturn; |  | 처리 중단/반환 |  |  |  |

## SSP0013_ShipmentPlanAdjustment.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-975361a2 | this.Load | SSP0013_ShipmentPlanAdjustment.cs:321 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-315424d7 | this.Load | SSP0013_ShipmentPlanAdjustment.cs:324 | if (dtMyDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl1) | 권한 검사/설정 |  |  |  |
| AC-856be0fa | this.Load | SSP0013_ShipmentPlanAdjustment.cs:327 |  | DATA_OP | ReadOnlySheetList.Add | (SpdSheet.shtSub) | 데이터 객체 조작/조회 |  |  |  |
| AC-b943acf3 | this.Load | SSP0013_ShipmentPlanAdjustment.cs:328 |  | DATA_OP | ReadOnlySheetList.Add | (SpdSheet.shtSubDetail) | 데이터 객체 조작/조회 |  |  |  |
| AC-d6e272c6 | this.Load | SSP0013_ShipmentPlanAdjustment.cs:330 |  | DATA_OP | dtMyDivision.Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-0e556d43 | this.Load | SSP0013_ShipmentPlanAdjustment.cs:336 | foreach (DataRow dr in dtMyDivision.Rows) | DATA_OP | dtDivision.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-3bafd328 | this.Load | SSP0013_ShipmentPlanAdjustment.cs:337 | foreach (DataRow dr in dtMyDivision.Rows) | DATA_OP | dataRow["CODE"] | dr["CODE"] | 행/컬럼 값 대입 |  |  |  |
| AC-9412a95b | this.Load | SSP0013_ShipmentPlanAdjustment.cs:338 | foreach (DataRow dr in dtMyDivision.Rows) | DATA_OP | dataRow["NAME"] | dr["NAME"] | 행/컬럼 값 대입 |  |  |  |
| AC-5e66ecfa | this.Load | SSP0013_ShipmentPlanAdjustment.cs:340 | foreach (DataRow dr in dtMyDivision.Rows) | CALL_EXT | dtDivision.Rows.InsertAt | (dataRow, 0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d92ed1f7 | this.Load | SSP0013_ShipmentPlanAdjustment.cs:344 |  | UI_PROP | dtDivision.DefaultView.Sort | "CODE Asc" | 속성 Sort 설정 |  |  |  |
| AC-ce0cf2bf | this.Load | SSP0013_ShipmentPlanAdjustment.cs:345 |  | DATA_OP | dtDivision.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-669b4a72 | this.Load | SSP0013_ShipmentPlanAdjustment.cs:347 |  | DATA_OP | dtDivision.DefaultView.ToTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-cfa80d89 | this.Load | SSP0013_ShipmentPlanAdjustment.cs:349 |  | STATE_RESET | dtMyDivision.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-b77671a2 | this.Load | SSP0013_ShipmentPlanAdjustment.cs:350 |  | FLAG | dtMyDivision | dtDivisionOrder.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-c4737ed6 | this.Load | SSP0013_ShipmentPlanAdjustment.cs:350 |  | DATA_OP | dtDivisionOrder.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-a4ac672e | this.Load | SSP0013_ShipmentPlanAdjustment.cs:352 |  | LIST_REBIND | clsCtrl.setListBox | (dtMyDivision, cboDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-10ee4164 | this.Load | SSP0013_ShipmentPlanAdjustment.cs:354 |  | LIST_REBIND | clsCtrl.setListBox | (dtChangeStatusCode, cboStatus, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-8d12c2a3 | this.Load | SSP0013_ShipmentPlanAdjustment.cs:356 |  | LIST_REBIND | clsCtrl.setListBox | (dtChangeReqType, cboChangeType, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-393c19bb | this.Load | SSP0013_ShipmentPlanAdjustment.cs:358 |  | LIST_REBIND | cboChecked.DataBind | (Data.Type.YesOrNo, true) ⇒ biz:CommonData.YesOrNo | 목록 컨트롤 재구성 |  |  |  |
| AC-b8935432 | this.Load | SSP0013_ShipmentPlanAdjustment.cs:362 |  | VALUE_SET | drpPeriod.InitValue | GetDayRange("") | 컨트롤 값 설정 |  |  |  |
| AC-b69e3b28 | this.Load | SSP0013_ShipmentPlanAdjustment.cs:365 | if (dtBaseDay.Rows.Count > 0) | FLAG | dDay | Convert.ToDouble(dtBaseDay.Rows[0][1]) | 화면 필드/플래그 변경 |  |  |  |
| AC-c546c8ea | this.Load | SSP0013_ShipmentPlanAdjustment.cs:369 |  | FLAG | dBaseDate | Convert.ToDateTime(drpPeriod.Value1).AddDays(dDay) | 화면 필드/플래그 변경 |  |  |  |
| AC-349a1cda | this.Load | SSP0013_ShipmentPlanAdjustment.cs:371 |  | FLAG | sRequestID | UserInfoContext.Current.UserId | 화면 필드/플래그 변경 |  |  |  |
| AC-02740997 | this.Load | SSP0013_ShipmentPlanAdjustment.cs:373 |  | FLAG | sRequestDeptID | UserInfoContext.Current[UserInfoProperites.Dept_ID] | 화면 필드/플래그 변경 |  |  |  |
| AC-a8e3c6dd | this.Load | SSP0013_ShipmentPlanAdjustment.cs:375 |  | FLAG | sLanguage | UserInfoContext.Current[UserInfoProperites.Language] | 화면 필드/플래그 변경 |  |  |  |
| AC-49d1cf59 | this.Load | SSP0013_ShipmentPlanAdjustment.cs:377 |  | VALUE_SET | chkMyModel.Checked | false | 컨트롤 값 설정 |  |  |  |
| AC-9d474e07 | this.Load | SSP0013_ShipmentPlanAdjustment.cs:382 | if (dtMyModelChk.Rows.Count > 0) | DATA_OP | dtMyModelChk.Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-74208fb9 | this.Load | SSP0013_ShipmentPlanAdjustment.cs:385 | if (dtMyModelChk.Rows.Count > 0) ▸ if (dr != null) | VALUE_SET | chkMyModel.Checked | true | 컨트롤 값 설정 |  |  |  |
| AC-7db11bc2 | this.Load | SSP0013_ShipmentPlanAdjustment.cs:390 | if (dtShipmentInputPeriod.Rows.Count > 0) | FLAG | dateMaxShipDate | Convert.ToDateTime(dtShipmentInputPeriod.Rows[0]["VALUE"].ToString()) | 화면 필드/플래그 변경 |  |  |  |
| AC-73b755ab | this.Load | SSP0013_ShipmentPlanAdjustment.cs:391 | if (dtShipmentInputPeriod.Rows.Count > 0) | FLAG | dateMinShipDate | Convert.ToDateTime(dtShipmentInputPeriod.Rows[1]["VALUE"].ToString()) | 화면 필드/플래그 변경 |  |  |  |
| AC-e7b0f324 | this.Load | SSP0013_ShipmentPlanAdjustment.cs:392 | if (dtShipmentInputPeriod.Rows.Count > 0) | FLAG | strDiffMaxDay | dtShipmentInputPeriod.Rows[0]["Diff_VALUE"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-e6838f46 | this.Load | SSP0013_ShipmentPlanAdjustment.cs:393 | if (dtShipmentInputPeriod.Rows.Count > 0) | FLAG | strDiffMinDay | dtShipmentInputPeriod.Rows[1]["Diff_VALUE"].ToString() | 화면 필드/플래그 변경 |  |  |  |

## SSP0013_ShipmentPlanAdjustment.InitSpread

진입점: this.Load / spdMain.CellDoubleClick [if (siMain != null && siMain.IsLock(siMain.SheetName) == true) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) ▸ try] / this.btnSearch.Click [try] / this.btnChecked.Click [try ▸ if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "S") ▸ try] / FindButton [try] / SaveButton [try ▸ if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "S") ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-46334a9e | this.Load 외 5 | SSP0013_ShipmentPlanAdjustment.cs:452 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.InitSheet | (spreadInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-48c314c6 | this.Load 외 5 | SSP0013_ShipmentPlanAdjustment.cs:454 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.SetSheetHeaderColumn | (spreadInfo, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-5435d94e | this.Load 외 5 | SSP0013_ShipmentPlanAdjustment.cs:455 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.SetReNumerCellType | (spreadInfo, spreadInfo.GetColumnIndex(DefColumns.SHIPMENT_CONFIRM_QTY), 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-e7d8ffce | this.Load 외 5 | SSP0013_ShipmentPlanAdjustment.cs:456 | if (spreadInfo.SheetName == SpdSheet.shtMain) | LIST_REBIND | SpreadInfo.SetComBoParam | ("CHANGE_REASON_CODE_ALL", dtChangeReasonCode) | 목록 컨트롤 재구성 |  |  |  |
| AC-fa36185b | this.Load 외 5 | SSP0013_ShipmentPlanAdjustment.cs:458 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-24a5d3d8 | this.Load 외 5 | SSP0013_ShipmentPlanAdjustment.cs:466 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex(DefColumns.CHK)].CellType | chk | 그리드 속성/값 설정 |  |  |  |
| AC-9aa82e74 | this.Load 외 5 | SSP0013_ShipmentPlanAdjustment.cs:467 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex(DefColumns.CHK)].Value | false | 그리드 속성/값 설정 |  |  |  |
| AC-76dfa1ac | this.Load 외 5 | SSP0013_ShipmentPlanAdjustment.cs:468 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex(DefColumns.CHK)].Border | bevelbrdr | 그리드 속성/값 설정 |  |  |  |
| AC-d33b06c0 | this.Load 외 5 | SSP0013_ShipmentPlanAdjustment.cs:470 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.CHANGE_REQ_NO)].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-c132efff | this.Load 외 5 | SSP0013_ShipmentPlanAdjustment.cs:476 | else of (spreadInfo.SheetName == SpdSheet.shtMain) ▸ if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.InitSheet | (spreadInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-95ff4781 | this.Load 외 5 | SSP0013_ShipmentPlanAdjustment.cs:478 | else of (spreadInfo.SheetName == SpdSheet.shtMain) ▸ if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.SetSheetHeaderColumn | (spreadInfo, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-6d701e16 | this.Load 외 5 | SSP0013_ShipmentPlanAdjustment.cs:480 | else of (spreadInfo.SheetName == SpdSheet.shtMain) ▸ if (spreadInfo.SheetName == SpdSheet.shtSub) | LIST_REBIND | SpreadInfo.SetComBoParam | ("LookupCommon3", dtStockStatus) | 목록 컨트롤 재구성 |  |  |  |
| AC-d244a2fd | this.Load 외 5 | SSP0013_ShipmentPlanAdjustment.cs:482 | else of (spreadInfo.SheetName == SpdSheet.shtMain) ▸ if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-803b5808 | this.Load 외 5 | SSP0013_ShipmentPlanAdjustment.cs:488 | else of (spreadInfo.SheetName == SpdSheet.shtMain) ▸ else of (spreadInfo.SheetName == SpdSheet.shtSub) ▸ if (spreadInfo.SheetName == SpdShee… | GRID_INIT | spreadInfo.InitSheet | (spreadInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-9c28744e | this.Load 외 5 | SSP0013_ShipmentPlanAdjustment.cs:490 | else of (spreadInfo.SheetName == SpdSheet.shtMain) ▸ else of (spreadInfo.SheetName == SpdSheet.shtSub) ▸ if (spreadInfo.SheetName == SpdShee… | GRID_INIT | spreadInfo.SetSheetHeaderColumn | (spreadInfo, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-24f59bc3 | this.Load 외 5 | SSP0013_ShipmentPlanAdjustment.cs:492 | else of (spreadInfo.SheetName == SpdSheet.shtMain) ▸ else of (spreadInfo.SheetName == SpdSheet.shtSub) ▸ if (spreadInfo.SheetName == SpdShee… | LIST_REBIND | SpreadInfo.SetComBoParam | ("LookupCommon3", dtStockStatus) | 목록 컨트롤 재구성 |  |  |  |
| AC-50e5c9ea | this.Load 외 5 | SSP0013_ShipmentPlanAdjustment.cs:494 | else of (spreadInfo.SheetName == SpdSheet.shtMain) ▸ else of (spreadInfo.SheetName == SpdSheet.shtSub) ▸ if (spreadInfo.SheetName == SpdShee… | GRID_INIT | spreadInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SSP0013_ShipmentPlanAdjustment.InitSpreadFooterSum

진입점: this.Load [else of (spreadInfo.SheetName == SpdSheet.shtMain) ▸ if (spreadInfo.SheetName == SpdSheet.shtSub)] / spdMain.CellDoubleClick [if (siMain != null && siMain.IsLock(siMain.SheetName) == true) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) ▸ try ▸ else of (spreadInfo.SheetName == SpdSheet.shtMain) ▸ if (spreadInfo.SheetName == SpdSheet.shtSub)] / this.btnSearch.Click [try ▸ else of (spreadInfo.SheetName == SpdSheet.shtMain) ▸ if (spreadInfo.SheetName == SpdSheet.shtSub)] / this.btnChecked.Click [try ▸ if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "S") ▸ try ▸…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-49e858e7 | this.Load [else of (spreadInfo.SheetName == SpdSheet.shtMain… 외 5 | SSP0013_ShipmentPlanAdjustment.cs:513 |  | GRID_SET | siSub.ActiveSheet.ColumnFooter.Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-a045e2d4 | this.Load [else of (spreadInfo.SheetName == SpdSheet.shtMain… 외 5 | SSP0013_ShipmentPlanAdjustment.cs:514 |  | GRID_SET | siSub.ActiveSheet.ColumnFooter.Cells[0, 1].Value | "Sum" | 그리드 속성/값 설정 |  |  |  |
| AC-19e97be7 | this.Load [else of (spreadInfo.SheetName == SpdSheet.shtMain… 외 5 | SSP0013_ShipmentPlanAdjustment.cs:524 | for (iCol <= siSub.GetMaxColumnIndex()) | CALL_EXT | siSub.ActiveSheet.ColumnFooter.SetAggregationFormat | (0, iCol, "{0:#,##0.###}") | ⚠ 의미 확인 필요 |  |  |  |
| AC-69cd7006 | this.Load [else of (spreadInfo.SheetName == SpdSheet.shtMain… 외 5 | SSP0013_ShipmentPlanAdjustment.cs:525 | for (iCol <= siSub.GetMaxColumnIndex()) | CALL_EXT | siSub.ActiveSheet.ColumnFooter.SetAggregationType | (0, iCol, FarPoint.Win.Spread.Model.AggregationType.SumIgnoreHidden) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3fabef3c | this.Load [else of (spreadInfo.SheetName == SpdSheet.shtMain… 외 5 | SSP0013_ShipmentPlanAdjustment.cs:526 | for (iCol <= siSub.GetMaxColumnIndex()) | GRID_SET | siSub.ActiveSheet.ColumnFooter.Cells[0, iCol].BackColor | Color.LightGray | 그리드 속성/값 설정 |  |  |  |
| AC-4ae057f1 | this.Load [else of (spreadInfo.SheetName == SpdSheet.shtMain… 외 5 | SSP0013_ShipmentPlanAdjustment.cs:527 | for (iCol <= siSub.GetMaxColumnIndex()) | GRID_SET | siSub.ActiveSheet.ColumnFooter.Cells[0, iCol].Border | bevelbrdr | 그리드 속성/값 설정 |  |  |  |

## SSP0013_ShipmentPlanAdjustment.NonSoNo

진입점: SaveButton [try ▸ try ▸ for (i <= siMain.ActiveSheet.RowCount - 1) ▸ if (string.IsNullOrWhiteSpace(erpSoNo))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f181e460 | SaveButton [try ▸ try ▸ for (i <= siMain.ActiveSheet.RowCoun… | SSP0013_ShipmentPlanAdjustment.cs:1592 |  | ENDPOINT | new FoxDataRequest | ("SSP.SSP0013_SAVE_SHIPMENT_REQUEST_DRAFTING") ⇒ SSP.SSP0013_SAVE_SHIPMENT_REQUEST_DRAFTING | 엔드포인트 요청 생성 |  |  |  |
| AC-0e52f8d1 | SaveButton [try ▸ try ▸ for (i <= siMain.ActiveSheet.RowCoun… | SSP0013_ShipmentPlanAdjustment.cs:1596 |  | DATA_OP | request.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-f3148e73 | SaveButton [try ▸ try ▸ for (i <= siMain.ActiveSheet.RowCoun… | SSP0013_ShipmentPlanAdjustment.cs:1597 |  | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-b5997200 | SaveButton [try ▸ try ▸ for (i <= siMain.ActiveSheet.RowCoun… | SSP0013_ShipmentPlanAdjustment.cs:1598 |  | DATA_OP | request.Parameters["p_confirm_id"] | p_confirm_id | 행/컬럼 값 대입 |  |  |  |
| AC-cfbc243a | SaveButton [try ▸ try ▸ for (i <= siMain.ActiveSheet.RowCoun… | SSP0013_ShipmentPlanAdjustment.cs:1599 |  | DATA_OP | request.Parameters["p_shipment_qty"] | p_shipment_qty | 행/컬럼 값 대입 |  |  |  |
| AC-02af5c35 | SaveButton [try ▸ try ▸ for (i <= siMain.ActiveSheet.RowCoun… | SSP0013_ShipmentPlanAdjustment.cs:1600 |  | DATA_OP | request.Parameters["p_shipment_date"] | p_shipment_date | 행/컬럼 값 대입 |  |  |  |
| AC-bcc2aba5 | SaveButton [try ▸ try ▸ for (i <= siMain.ActiveSheet.RowCoun… | SSP0013_ShipmentPlanAdjustment.cs:1601 |  | DATA_OP | request.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-b410e3c8 | SaveButton [try ▸ try ▸ for (i <= siMain.ActiveSheet.RowCoun… | SSP0013_ShipmentPlanAdjustment.cs:1602 |  | DATA_OP | request.Parameters["p_new_bod_id"] | p_new_bod_id | 행/컬럼 값 대입 |  |  |  |
| AC-c606e9f3 | SaveButton [try ▸ try ▸ for (i <= siMain.ActiveSheet.RowCoun… | SSP0013_ShipmentPlanAdjustment.cs:1603 |  | DATA_OP | request.Parameters["p_new_route_id"] | p_new_route_id | 행/컬럼 값 대입 |  |  |  |
| AC-91675ba7 | SaveButton [try ▸ try ▸ for (i <= siMain.ActiveSheet.RowCoun… | SSP0013_ShipmentPlanAdjustment.cs:1604 |  | DATA_OP | request.Parameters["p_new_etd_date"] | p_new_etd_date | 행/컬럼 값 대입 |  |  |  |
| AC-a4738e65 | SaveButton [try ▸ try ▸ for (i <= siMain.ActiveSheet.RowCoun… | SSP0013_ShipmentPlanAdjustment.cs:1605 |  | DATA_OP | request.Parameters["p_new_eta_date"] | p_new_eta_date | 행/컬럼 값 대입 |  |  |  |
| AC-eaf0b2fa | SaveButton [try ▸ try ▸ for (i <= siMain.ActiveSheet.RowCoun… | SSP0013_ShipmentPlanAdjustment.cs:1606 |  | DATA_OP | request.Parameters["p_new_incoterms"] | p_new_incoterms | 행/컬럼 값 대입 |  |  |  |
| AC-991a217c | SaveButton [try ▸ try ▸ for (i <= siMain.ActiveSheet.RowCoun… | SSP0013_ShipmentPlanAdjustment.cs:1607 |  | DATA_OP | request.Parameters["p_new_transport_mode"] | p_new_transport_mode | 행/컬럼 값 대입 |  |  |  |
| AC-c89b56ef | SaveButton [try ▸ try ▸ for (i <= siMain.ActiveSheet.RowCoun… | SSP0013_ShipmentPlanAdjustment.cs:1608 |  | DATA_OP | request.Parameters["p_new_d_contry"] | p_new_d_contry | 행/컬럼 값 대입 |  |  |  |
| AC-9442673b | SaveButton [try ▸ try ▸ for (i <= siMain.ActiveSheet.RowCoun… | SSP0013_ShipmentPlanAdjustment.cs:1609 |  | DATA_OP | request.Parameters["p_new_d_port_code"] | p_new_d_port_code | 행/컬럼 값 대입 |  |  |  |
| AC-5b7867ca | SaveButton [try ▸ try ▸ for (i <= siMain.ActiveSheet.RowCoun… | SSP0013_ShipmentPlanAdjustment.cs:1610 |  | DATA_OP | request.Parameters["p_new_a_country"] | p_new_a_country | 행/컬럼 값 대입 |  |  |  |
| AC-019ea283 | SaveButton [try ▸ try ▸ for (i <= siMain.ActiveSheet.RowCoun… | SSP0013_ShipmentPlanAdjustment.cs:1611 |  | DATA_OP | request.Parameters["p_new_a_port_code"] | p_new_a_port_code | 행/컬럼 값 대입 |  |  |  |
| AC-fb191646 | SaveButton [try ▸ try ▸ for (i <= siMain.ActiveSheet.RowCoun… | SSP0013_ShipmentPlanAdjustment.cs:1612 |  | DATA_OP | request.Parameters["p_new_customer_lt"] | p_new_customer_lt | 행/컬럼 값 대입 |  |  |  |
| AC-1dde7521 | SaveButton [try ▸ try ▸ for (i <= siMain.ActiveSheet.RowCoun… | SSP0013_ShipmentPlanAdjustment.cs:1613 |  | DATA_OP | request.Parameters["p_new_to_country"] | p_new_to_country | 행/컬럼 값 대입 |  |  |  |
| AC-f9545a65 | SaveButton [try ▸ try ▸ for (i <= siMain.ActiveSheet.RowCoun… | SSP0013_ShipmentPlanAdjustment.cs:1614 |  | DATA_OP | request.Parameters["p_new_to_city"] | p_new_to_city | 행/컬럼 값 대입 |  |  |  |
| AC-ba91b4d0 | SaveButton [try ▸ try ▸ for (i <= siMain.ActiveSheet.RowCoun… | SSP0013_ShipmentPlanAdjustment.cs:1615 |  | DATA_OP | request.Parameters["p_edit_main"] | p_edit_main | 행/컬럼 값 대입 |  |  |  |
| AC-42babe05 | SaveButton [try ▸ try ▸ for (i <= siMain.ActiveSheet.RowCoun… | SSP0013_ShipmentPlanAdjustment.cs:1616 |  | DATA_OP | request.Parameters["p_edit_remark"] | p_edit_remark | 행/컬럼 값 대입 |  |  |  |
| AC-001a1550 | SaveButton [try ▸ try ▸ for (i <= siMain.ActiveSheet.RowCoun… | SSP0013_ShipmentPlanAdjustment.cs:1617 |  | DATA_OP | request.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-80776f71 | SaveButton [try ▸ try ▸ for (i <= siMain.ActiveSheet.RowCoun… | SSP0013_ShipmentPlanAdjustment.cs:1618 |  | DATA_OP | request.Parameters["p_user_dept_id"] | p_user_dept_id | 행/컬럼 값 대입 |  |  |  |
| AC-a8ac832f | SaveButton [try ▸ try ▸ for (i <= siMain.ActiveSheet.RowCoun… | SSP0013_ShipmentPlanAdjustment.cs:1619 |  | DATA_OP | request.Parameters["p_electrode_yn"] | p_electrode_yn | 행/컬럼 값 대입 |  |  |  |
| AC-8f9999dd | SaveButton [try ▸ try ▸ for (i <= siMain.ActiveSheet.RowCoun… | SSP0013_ShipmentPlanAdjustment.cs:1620 |  | DATA_OP | request.Parameters["p_electrode_type"] | p_electrode_type | 행/컬럼 값 대입 |  |  |  |
| AC-d01aa06e | SaveButton [try ▸ try ▸ for (i <= siMain.ActiveSheet.RowCoun… | SSP0013_ShipmentPlanAdjustment.cs:1621 |  | DATA_OP | request.Parameters["p_origin_from_division_id"] | p_origin_from_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-27e698fc | SaveButton [try ▸ try ▸ for (i <= siMain.ActiveSheet.RowCoun… | SSP0013_ShipmentPlanAdjustment.cs:1622 |  | DATA_OP | request.Parameters["p_origion_to_division_id"] | p_origion_to_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-dde53386 | SaveButton [try ▸ try ▸ for (i <= siMain.ActiveSheet.RowCoun… | SSP0013_ShipmentPlanAdjustment.cs:1624 |  | DATA_OP | request.Parameters["p_remarks"] | p_remarks | 행/컬럼 값 대입 |  |  |  |
| AC-14fde8fe | SaveButton [try ▸ try ▸ for (i <= siMain.ActiveSheet.RowCoun… | SSP0013_ShipmentPlanAdjustment.cs:1625 |  | DATA_OP | request.Parameters["p_remarks2"] | p_remarks2 | 행/컬럼 값 대입 |  |  |  |
| AC-83e2ba4a | SaveButton [try ▸ try ▸ for (i <= siMain.ActiveSheet.RowCoun… | SSP0013_ShipmentPlanAdjustment.cs:1626 |  | DATA_OP | request.Parameters["p_remarks3"] | p_remarks3 | 행/컬럼 값 대입 |  |  |  |
| AC-32831399 | SaveButton [try ▸ try ▸ for (i <= siMain.ActiveSheet.RowCoun… | SSP0013_ShipmentPlanAdjustment.cs:1628 |  | DATA_OP | request.Parameters["p_change_reason_code"] | p_change_reason_code | 행/컬럼 값 대입 |  |  |  |
| AC-f613f30f | SaveButton [try ▸ try ▸ for (i <= siMain.ActiveSheet.RowCoun… | SSP0013_ShipmentPlanAdjustment.cs:1629 |  | DATA_OP | request.Parameters["p_change_reason_detail"] | p_change_reason_datail | 행/컬럼 값 대입 |  |  |  |
| AC-53b9a65a | SaveButton [try ▸ try ▸ for (i <= siMain.ActiveSheet.RowCoun… | SSP0013_ShipmentPlanAdjustment.cs:1630 |  | DATA_OP | request.Parameters["p_title"] | p_title | 행/컬럼 값 대입 |  |  |  |
| AC-64237e43 | SaveButton [try ▸ try ▸ for (i <= siMain.ActiveSheet.RowCoun… | SSP0013_ShipmentPlanAdjustment.cs:1631 |  | DATA_OP | request.Parameters["p_program_id"] | p_program_id | 행/컬럼 값 대입 |  |  |  |
| AC-cf1510e4 | SaveButton [try ▸ try ▸ for (i <= siMain.ActiveSheet.RowCoun… | SSP0013_ShipmentPlanAdjustment.cs:1633 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-0b76dc49 | SaveButton [try ▸ try ▸ for (i <= siMain.ActiveSheet.RowCoun… | SSP0013_ShipmentPlanAdjustment.cs:1664 | else of (ds.Tables[0].Rows[0][0].ToString() == "S") | MESSAGE | MessageHelper.GMessageBox | ("MSG00284", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a23a9938 | SaveButton [try ▸ try ▸ for (i <= siMain.ActiveSheet.RowCoun… | SSP0013_ShipmentPlanAdjustment.cs:1668 |  | RETURN | return bReturn; |  | 처리 중단/반환 |  |  |  |

## SSP0013_ShipmentPlanAdjustment.SaveData

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d954efa1 | SaveButton | SSP0013_ShipmentPlanAdjustment.cs:892 |  | VALIDATE | DataUtil.checkRequiredOfSpread | (siMain) | 프레임워크 검증 |  |  |  |
| AC-f8bea9c5 | SaveButton | SSP0013_ShipmentPlanAdjustment.cs:892 | if (!DataUtil.checkRequiredOfSpread(siMain)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-fcc67df1 | SaveButton | SSP0013_ShipmentPlanAdjustment.cs:898 | if (chkERPIFBlockYn()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0dc51c92 | SaveButton | SSP0013_ShipmentPlanAdjustment.cs:905 | if (Validation_Check() == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-583d8820 | SaveButton | SSP0013_ShipmentPlanAdjustment.cs:911 | if (bolChang_Flag == false) | MESSAGE | MessageHelper.GMessageBox | ("MSG00133", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-4cce0857 | SaveButton | SSP0013_ShipmentPlanAdjustment.cs:913 | if (bolChang_Flag == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8724c96d | SaveButton | SSP0013_ShipmentPlanAdjustment.cs:919 | if (!EngProcessingChk(pDivisionID)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8c338a4f | SaveButton | SSP0013_ShipmentPlanAdjustment.cs:921 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-cd169403 | SaveButton | SSP0013_ShipmentPlanAdjustment.cs:925 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-880f3f83 | SaveButton | SSP0013_ShipmentPlanAdjustment.cs:930 | try ▸ if (!GetERPInterface()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f377f8ed | SaveButton | SSP0013_ShipmentPlanAdjustment.cs:1020 | try ▸ if (iCount > 0) | ENDPOINT | new FoxDataRequest | (requestNm) ⇒ SSP.SSP0015_SAVE_SHIPMENT_REQUEST_CONFIRM_40 \| SSP.SSP0013_SAVE_SHIPMENT_REQUES… | 엔드포인트 요청 생성 |  |  |  |
| AC-3401430c | SaveButton | SSP0013_ShipmentPlanAdjustment.cs:1026 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-7957eeaf | SaveButton | SSP0013_ShipmentPlanAdjustment.cs:1027 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-1c20499e | SaveButton | SSP0013_ShipmentPlanAdjustment.cs:1028 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_confirm_id"] | p_confirm_id | 행/컬럼 값 대입 |  |  |  |
| AC-782b5f16 | SaveButton | SSP0013_ShipmentPlanAdjustment.cs:1029 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_shipment_qty"] | p_shipment_qty | 행/컬럼 값 대입 |  |  |  |
| AC-f0f34249 | SaveButton | SSP0013_ShipmentPlanAdjustment.cs:1030 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_shipment_date"] | p_shipment_date | 행/컬럼 값 대입 |  |  |  |
| AC-da0e6511 | SaveButton | SSP0013_ShipmentPlanAdjustment.cs:1031 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_new_bod_id"] | p_new_bod_id | 행/컬럼 값 대입 |  |  |  |
| AC-934ed2f5 | SaveButton | SSP0013_ShipmentPlanAdjustment.cs:1032 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_new_route_id"] | p_new_route_id | 행/컬럼 값 대입 |  |  |  |
| AC-2c45d5ed | SaveButton | SSP0013_ShipmentPlanAdjustment.cs:1033 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_new_etd_date"] | p_new_etd_date | 행/컬럼 값 대입 |  |  |  |
| AC-adf5fcbb | SaveButton | SSP0013_ShipmentPlanAdjustment.cs:1034 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_new_eta_date"] | p_new_eta_date | 행/컬럼 값 대입 |  |  |  |
| AC-29fad8e9 | SaveButton | SSP0013_ShipmentPlanAdjustment.cs:1035 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_new_incoterms"] | p_new_incoterms | 행/컬럼 값 대입 |  |  |  |
| AC-da38719c | SaveButton | SSP0013_ShipmentPlanAdjustment.cs:1036 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_new_transport_mode"] | p_new_transport_mode | 행/컬럼 값 대입 |  |  |  |
| AC-33edadbc | SaveButton | SSP0013_ShipmentPlanAdjustment.cs:1037 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_new_d_contry"] | p_new_d_contry | 행/컬럼 값 대입 |  |  |  |
| AC-eae678af | SaveButton | SSP0013_ShipmentPlanAdjustment.cs:1038 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_new_d_port_code"] | p_new_d_port_code | 행/컬럼 값 대입 |  |  |  |
| AC-943a3bab | SaveButton | SSP0013_ShipmentPlanAdjustment.cs:1039 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_new_a_country"] | p_new_a_country | 행/컬럼 값 대입 |  |  |  |
| AC-0a7e58f3 | SaveButton | SSP0013_ShipmentPlanAdjustment.cs:1040 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_new_a_port_code"] | p_new_a_port_code | 행/컬럼 값 대입 |  |  |  |
| AC-9865decd | SaveButton | SSP0013_ShipmentPlanAdjustment.cs:1041 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_new_customer_lt"] | p_new_customer_lt | 행/컬럼 값 대입 |  |  |  |
| AC-13e7c3e9 | SaveButton | SSP0013_ShipmentPlanAdjustment.cs:1042 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_new_to_country"] | p_new_to_country | 행/컬럼 값 대입 |  |  |  |
| AC-93b845b6 | SaveButton | SSP0013_ShipmentPlanAdjustment.cs:1043 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_new_to_city"] | p_new_to_city | 행/컬럼 값 대입 |  |  |  |
| AC-b6481494 | SaveButton | SSP0013_ShipmentPlanAdjustment.cs:1044 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_remarks"] | p_remarks | 행/컬럼 값 대입 |  |  |  |
| AC-96e16ffb | SaveButton | SSP0013_ShipmentPlanAdjustment.cs:1045 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_remarks2"] | p_remarks2 | 행/컬럼 값 대입 |  |  |  |
| AC-436394d1 | SaveButton | SSP0013_ShipmentPlanAdjustment.cs:1046 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_remarks3"] | p_remarks3 | 행/컬럼 값 대입 |  |  |  |
| AC-761bc316 | SaveButton | SSP0013_ShipmentPlanAdjustment.cs:1047 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-2432c544 | SaveButton | SSP0013_ShipmentPlanAdjustment.cs:1048 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_check_need_yn"] | p_check_need_yn | 행/컬럼 값 대입 |  |  |  |
| AC-be8c143f | SaveButton | SSP0013_ShipmentPlanAdjustment.cs:1049 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_edit_main"] | p_edit_main | 행/컬럼 값 대입 |  |  |  |
| AC-f7cce62d | SaveButton | SSP0013_ShipmentPlanAdjustment.cs:1051 | try ▸ if (iCount > 0) | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-ec6659c4 | SaveButton | SSP0013_ShipmentPlanAdjustment.cs:1056 | try ▸ if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "S") | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-c9d2af3b | SaveButton | SSP0013_ShipmentPlanAdjustment.cs:1058 | try ▸ if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "S") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { ds.Tables[0].Rows[0][1].ToString() }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-32c0e716 | SaveButton | SSP0013_ShipmentPlanAdjustment.cs:1063 | try ▸ if (iCount > 0) ▸ else of (ds.Tables[0].Rows[0][0].ToString() == "S") | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-6da788d1 | SaveButton | SSP0013_ShipmentPlanAdjustment.cs:1075 | try ▸ if (iCount > 0) ▸ else of (ds.Tables[0].Rows[0][0].ToString() == "S") | MESSAGE | MessageHelper.GMessageBox | ("MSG00284", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-5f558440 | SaveButton | SSP0013_ShipmentPlanAdjustment.cs:1086 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SSP0013_ShipmentPlanAdjustment.SaveData_Check

진입점: this.btnChecked.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-945b1494 | this.btnChecked.Click | SSP0013_ShipmentPlanAdjustment.cs:1316 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-635d3747 | this.btnChecked.Click | SSP0013_ShipmentPlanAdjustment.cs:1320 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-bda9ef9b | this.btnChecked.Click | SSP0013_ShipmentPlanAdjustment.cs:1360 | try ▸ if (iCount > 0) | ENDPOINT | new FoxDataRequest | ("SSP.SSP0013_SAVE_SHIPMENT_REQUEST_CONFIRM_CHECK") ⇒ SSP.SSP0013_SAVE_SHIPMENT_REQUEST_CONFIRM_CHECK | 엔드포인트 요청 생성 |  |  |  |
| AC-7119775f | this.btnChecked.Click | SSP0013_ShipmentPlanAdjustment.cs:1364 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-b356bcf9 | this.btnChecked.Click | SSP0013_ShipmentPlanAdjustment.cs:1365 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_confirm_id"] | p_confirm_id | 행/컬럼 값 대입 |  |  |  |
| AC-f0921159 | this.btnChecked.Click | SSP0013_ShipmentPlanAdjustment.cs:1366 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_change_req_no"] | p_change_req_no | 행/컬럼 값 대입 |  |  |  |
| AC-1791af99 | this.btnChecked.Click | SSP0013_ShipmentPlanAdjustment.cs:1367 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-e25e2f21 | this.btnChecked.Click | SSP0013_ShipmentPlanAdjustment.cs:1368 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_check_need_yn"] | p_check_need_yn | 행/컬럼 값 대입 |  |  |  |
| AC-afbac790 | this.btnChecked.Click | SSP0013_ShipmentPlanAdjustment.cs:1370 | try ▸ if (iCount > 0) | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-c7cb6dc7 | this.btnChecked.Click | SSP0013_ShipmentPlanAdjustment.cs:1375 | try ▸ if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "S") | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-91ec9446 | this.btnChecked.Click | SSP0013_ShipmentPlanAdjustment.cs:1377 | try ▸ if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "S") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { ds.Tables[0].Rows[0][1].ToString() }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b9525754 | this.btnChecked.Click | SSP0013_ShipmentPlanAdjustment.cs:1382 | try ▸ if (iCount > 0) ▸ else of (ds.Tables[0].Rows[0][0].ToString() == "S") | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-727bae0d | this.btnChecked.Click | SSP0013_ShipmentPlanAdjustment.cs:1394 | try ▸ if (iCount > 0) ▸ else of (ds.Tables[0].Rows[0][0].ToString() == "S") | MESSAGE | MessageHelper.GMessageBox | ("MSG00284", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-98b2e82a | this.btnChecked.Click | SSP0013_ShipmentPlanAdjustment.cs:1402 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SSP0013_ShipmentPlanAdjustment.SetChangedControl

진입점: this.Load / cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-90345ffd | this.Load 외 1 | SSP0013_ShipmentPlanAdjustment.cs:406 |  | DATA_OP | pDivisionID.Contains | ("EE") | 데이터 객체 조작/조회 |  |  |  |
| AC-3eb0122e | this.Load 외 1 | SSP0013_ShipmentPlanAdjustment.cs:408 | if (!pDivisionID.Contains("EE")) | FLAG | dtPlantSiteByDivision | Data_SCP.Common(Data_SCP.Type.PlantSiteByDivision, false, pDivisionID) | 화면 필드/플래그 변경 |  |  |  |
| AC-5dbb11ad | this.Load 외 1 | SSP0013_ShipmentPlanAdjustment.cs:408 | if (!pDivisionID.Contains("EE")) | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.PlantSiteByDivision, false, pDivisionID) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-2a73bdec | this.Load 외 1 | SSP0013_ShipmentPlanAdjustment.cs:409 | if (!pDivisionID.Contains("EE")) | FLAG | dtToSite | Data_SCP.Common(Data_SCP.Type.SSPToSiteByDivision, false, cboDivision.ControlValues, UserI… | 화면 필드/플래그 변경 |  |  |  |
| AC-888037fe | this.Load 외 1 | SSP0013_ShipmentPlanAdjustment.cs:409 | if (!pDivisionID.Contains("EE")) | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.SSPToSiteByDivision, false, cboDivision.ControlValues, UserInfoContext.Curr… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-eff0f07a | this.Load 외 1 | SSP0013_ShipmentPlanAdjustment.cs:413 | else of (!pDivisionID.Contains("EE")) | FLAG | dtPlantSiteByDivision | Data_SCP.Common(Data_SCP.Type.ShipmentPlanPlantSite, false, pDivisionID) | 화면 필드/플래그 변경 |  |  |  |
| AC-1ae18df4 | this.Load 외 1 | SSP0013_ShipmentPlanAdjustment.cs:413 | else of (!pDivisionID.Contains("EE")) | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.ShipmentPlanPlantSite, false, pDivisionID) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-46493ebf | this.Load 외 1 | SSP0013_ShipmentPlanAdjustment.cs:414 | else of (!pDivisionID.Contains("EE")) | FLAG | dtToSite | Data_SCP.Common(Data_SCP.Type.ShipmentPlanToSite, false, pDivisionID, UserInfoContext.Curr… | 화면 필드/플래그 변경 |  |  |  |
| AC-f2c2a9eb | this.Load 외 1 | SSP0013_ShipmentPlanAdjustment.cs:414 | else of (!pDivisionID.Contains("EE")) | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.ShipmentPlanToSite, false, pDivisionID, UserInfoContext.Current["NowGroupID… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-74e64562 | this.Load 외 1 | SSP0013_ShipmentPlanAdjustment.cs:418 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlantSiteByDivision, this.clbFromSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-cc416902 | this.Load 외 1 | SSP0013_ShipmentPlanAdjustment.cs:421 |  | LIST_REBIND | clsCtrl.setListBox | (dtToSite, clbToSite, true) | 목록 컨트롤 재구성 |  |  |  |

## SSP0013_ShipmentPlanAdjustment.SetChangedPeriod

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3e8fdb0b | (진입점 미연결) | SSP0013_ShipmentPlanAdjustment.cs:2013 |  | COMBO_DATA | Data.CallBizCommonData | ("PERIOD_" + value) ⇒ biz:CommonData.CommonDataList [code=PERIOD_{p:value} \|\| PERIOD_DEFAULT] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ab95add1 | (진입점 미연결) | SSP0013_ShipmentPlanAdjustment.cs:2016 | if (dt == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-dfdab290 | (진입점 미연결) | SSP0013_ShipmentPlanAdjustment.cs:2020 | if (dt.Rows.Count > 0) | UI_PROP | drpPeriod.Text1 | dt.Rows[0]["FROM_VALUE"].ToString() | 속성 Text1 설정 |  |  |  |
| AC-e4ad02b9 | (진입점 미연결) | SSP0013_ShipmentPlanAdjustment.cs:2021 | if (dt.Rows.Count > 0) | UI_PROP | drpPeriod.Text2 | dt.Rows[0]["TO_VALUE"].ToString() | 속성 Text2 설정 |  |  |  |

## SSP0013_ShipmentPlanAdjustment.SetCheckRow

진입점: this.btnChecked.Click [try ▸ if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "S") ▸ try] / FindButton [try] / SaveButton [try ▸ if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "S") ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6b7734ee | this.btnChecked.Click [try ▸ if (iCount > 0) ▸ if (ds.Tables… 외 2 | SSP0013_ShipmentPlanAdjustment.cs:2036 | for (iRow < siMain.ActiveSheet.RowCount) ▸ if (sCheckYn == "Y") | GRID_SET | siMain.ActiveSheet.Rows[iRow].BackColor | Color.FromArgb(80, bkColor) | 그리드 속성/값 설정 |  |  |  |

## SSP0013_ShipmentPlanAdjustment.shtMain_Change

진입점: dsdm.Changed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3298d7eb | dsdm.Changed | SSP0013_ShipmentPlanAdjustment.cs:2287 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (this.CanModelChange != true \|\| e.Row == -1 && e… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6314b009 | dsdm.Changed | SSP0013_ShipmentPlanAdjustment.cs:2288 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6c85d388 | dsdm.Changed | SSP0013_ShipmentPlanAdjustment.cs:2297 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.IsLock(siMain.SheetName) == false) ▸ if (s… | MESSAGE | MessageHelper.GMessageBox | ("MSG00189") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b7b87e51 | dsdm.Changed | SSP0013_ShipmentPlanAdjustment.cs:2298 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.IsLock(siMain.SheetName) == false) ▸ if (s… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2c4b95ea | dsdm.Changed | SSP0013_ShipmentPlanAdjustment.cs:2313 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e… | MESSAGE | MessageHelper.GMessageBox | ("MSG00194", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8c214b86 | dsdm.Changed | SSP0013_ShipmentPlanAdjustment.cs:2328 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7eb66909 | dsdm.Changed | SSP0013_ShipmentPlanAdjustment.cs:2338 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e… | MESSAGE | MessageHelper.GMessageBox | ("MSG00288", new object[] { strDiffMaxDay }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-14539210 | dsdm.Changed | SSP0013_ShipmentPlanAdjustment.cs:2340 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e… | MESSAGE | MessageHelper.GMessageBox | ("MSG00288", new object[] { strDiffMinDay }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8aa11c6c | dsdm.Changed | SSP0013_ShipmentPlanAdjustment.cs:2355 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9f458891 | dsdm.Changed | SSP0013_ShipmentPlanAdjustment.cs:2364 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e… | MESSAGE | MessageHelper.GMessageBox | ("MSG00278") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d6937d69 | dsdm.Changed | SSP0013_ShipmentPlanAdjustment.cs:2365 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-135d02ae | dsdm.Changed | SSP0013_ShipmentPlanAdjustment.cs:2380 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-6667187d | dsdm.Changed | SSP0013_ShipmentPlanAdjustment.cs:2390 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-5c52390a | dsdm.Changed | SSP0013_ShipmentPlanAdjustment.cs:2392 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e… | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(CAppSetting.StringAction)].Value | CAppSetting.StringM | 그리드 속성/값 설정 |  |  |  |
| AC-edb44305 | dsdm.Changed | SSP0013_ShipmentPlanAdjustment.cs:2393 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e… | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(CAppSetting.StringAction)].ForeColor | ControlColor.FGAction | 그리드 속성/값 설정 |  |  |  |
| AC-ade06f34 | dsdm.Changed | SSP0013_ShipmentPlanAdjustment.cs:2394 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e… | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(CAppSetting.StringAction)].BackColor | ControlColor.BGModified | 그리드 속성/값 설정 |  |  |  |
| AC-a1796ce9 | dsdm.Changed | SSP0013_ShipmentPlanAdjustment.cs:2399 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-36adb000 | dsdm.Changed | SSP0013_ShipmentPlanAdjustment.cs:2410 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.IsLock(siMain.SheetName) == false) ▸ else … | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-73e82809 | dsdm.Changed | SSP0013_ShipmentPlanAdjustment.cs:2420 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.IsLock(siMain.SheetName) == false) ▸ else … | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-b30ca01f | dsdm.Changed | SSP0013_ShipmentPlanAdjustment.cs:2422 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.IsLock(siMain.SheetName) == false) ▸ else … | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(CAppSetting.StringAction)].Value | CAppSetting.StringM | 그리드 속성/값 설정 |  |  |  |
| AC-e1c6e96e | dsdm.Changed | SSP0013_ShipmentPlanAdjustment.cs:2423 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.IsLock(siMain.SheetName) == false) ▸ else … | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(CAppSetting.StringAction)].ForeColor | ControlColor.FGAction | 그리드 속성/값 설정 |  |  |  |
| AC-e15fc39c | dsdm.Changed | SSP0013_ShipmentPlanAdjustment.cs:2424 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.IsLock(siMain.SheetName) == false) ▸ else … | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(CAppSetting.StringAction)].BackColor | ControlColor.BGModified | 그리드 속성/값 설정 |  |  |  |
| AC-ec25f9f3 | dsdm.Changed | SSP0013_ShipmentPlanAdjustment.cs:2437 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.IsLock(siMain.SheetName) == false) ▸ else … | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.CHANGE_REASON_DETAIL), "") | 그리드 값 설정 |  |  |  |
| AC-86f8b837 | dsdm.Changed | SSP0013_ShipmentPlanAdjustment.cs:2445 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.IsLock(siMain.SheetName) == false) ▸ else … | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-0544e850 | dsdm.Changed | SSP0013_ShipmentPlanAdjustment.cs:2455 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.IsLock(siMain.SheetName) == false) ▸ else … | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.CHANGE_REASON_CODE), sNewChangeReasonCode) | 그리드 값 설정 |  |  |  |
| AC-6ad8b3d3 | dsdm.Changed | SSP0013_ShipmentPlanAdjustment.cs:2456 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.IsLock(siMain.SheetName) == false) ▸ else … | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.CHANGE_REASON_DETAIL), sNewChangeReasonDetail) | 그리드 값 설정 |  |  |  |
| AC-11056f96 | dsdm.Changed | SSP0013_ShipmentPlanAdjustment.cs:2457 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.IsLock(siMain.SheetName) == false) ▸ else … | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-9c9be461 | dsdm.Changed | SSP0013_ShipmentPlanAdjustment.cs:2469 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.IsLock(siMain.SheetName) == false) ▸ else … | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-0a015063 | dsdm.Changed | SSP0013_ShipmentPlanAdjustment.cs:2479 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.IsLock(siMain.SheetName) == false) ▸ else … | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.CHANGE_REASON_DETAIL), sNewChangeReasonDetail) | 그리드 값 설정 |  |  |  |
| AC-34721d29 | dsdm.Changed | SSP0013_ShipmentPlanAdjustment.cs:2481 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.IsLock(siMain.SheetName) == false) ▸ else … | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |

## SSP0013_ShipmentPlanAdjustment.SoNo

진입점: SaveButton [try ▸ try ▸ for (i <= siMain.ActiveSheet.RowCount - 1) ▸ else of (string.IsNullOrWhiteSpace(erpSoNo))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c7a5e83c | SaveButton [try ▸ try ▸ for (i <= siMain.ActiveSheet.RowCoun… | SSP0013_ShipmentPlanAdjustment.cs:1682 | for (i < intRowIdx) ▸ if (erpSoNo == siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ERP_SO_NO)).ToString()) ▸ if (intRowIdx > i) | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-220d04a3 | SaveButton [try ▸ try ▸ for (i <= siMain.ActiveSheet.RowCoun… | SSP0013_ShipmentPlanAdjustment.cs:1795 |  | ENDPOINT | new FoxDataRequest | ("SSP.SSP0013_SAVE_SHIPMENT_REQUEST_DRAFTING") ⇒ SSP.SSP0013_SAVE_SHIPMENT_REQUEST_DRAFTING | 엔드포인트 요청 생성 |  |  |  |
| AC-e26a3d4f | SaveButton [try ▸ try ▸ for (i <= siMain.ActiveSheet.RowCoun… | SSP0013_ShipmentPlanAdjustment.cs:1799 |  | DATA_OP | request.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-07549edd | SaveButton [try ▸ try ▸ for (i <= siMain.ActiveSheet.RowCoun… | SSP0013_ShipmentPlanAdjustment.cs:1800 |  | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-5602ed13 | SaveButton [try ▸ try ▸ for (i <= siMain.ActiveSheet.RowCoun… | SSP0013_ShipmentPlanAdjustment.cs:1801 |  | DATA_OP | request.Parameters["p_confirm_id"] | p_confirm_id | 행/컬럼 값 대입 |  |  |  |
| AC-1f23b3c2 | SaveButton [try ▸ try ▸ for (i <= siMain.ActiveSheet.RowCoun… | SSP0013_ShipmentPlanAdjustment.cs:1802 |  | DATA_OP | request.Parameters["p_shipment_qty"] | p_shipment_qty | 행/컬럼 값 대입 |  |  |  |
| AC-7d4d0955 | SaveButton [try ▸ try ▸ for (i <= siMain.ActiveSheet.RowCoun… | SSP0013_ShipmentPlanAdjustment.cs:1803 |  | DATA_OP | request.Parameters["p_shipment_date"] | p_shipment_date | 행/컬럼 값 대입 |  |  |  |
| AC-c453227c | SaveButton [try ▸ try ▸ for (i <= siMain.ActiveSheet.RowCoun… | SSP0013_ShipmentPlanAdjustment.cs:1804 |  | DATA_OP | request.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-1cc17d95 | SaveButton [try ▸ try ▸ for (i <= siMain.ActiveSheet.RowCoun… | SSP0013_ShipmentPlanAdjustment.cs:1805 |  | DATA_OP | request.Parameters["p_new_bod_id"] | p_new_bod_id | 행/컬럼 값 대입 |  |  |  |
| AC-05014f6a | SaveButton [try ▸ try ▸ for (i <= siMain.ActiveSheet.RowCoun… | SSP0013_ShipmentPlanAdjustment.cs:1806 |  | DATA_OP | request.Parameters["p_new_route_id"] | p_new_route_id | 행/컬럼 값 대입 |  |  |  |
| AC-50bdf5c3 | SaveButton [try ▸ try ▸ for (i <= siMain.ActiveSheet.RowCoun… | SSP0013_ShipmentPlanAdjustment.cs:1807 |  | DATA_OP | request.Parameters["p_new_etd_date"] | p_new_etd_date | 행/컬럼 값 대입 |  |  |  |
| AC-b2d9ee86 | SaveButton [try ▸ try ▸ for (i <= siMain.ActiveSheet.RowCoun… | SSP0013_ShipmentPlanAdjustment.cs:1808 |  | DATA_OP | request.Parameters["p_new_eta_date"] | p_new_eta_date | 행/컬럼 값 대입 |  |  |  |
| AC-4714c9ef | SaveButton [try ▸ try ▸ for (i <= siMain.ActiveSheet.RowCoun… | SSP0013_ShipmentPlanAdjustment.cs:1809 |  | DATA_OP | request.Parameters["p_new_incoterms"] | p_new_incoterms | 행/컬럼 값 대입 |  |  |  |
| AC-c2eda94b | SaveButton [try ▸ try ▸ for (i <= siMain.ActiveSheet.RowCoun… | SSP0013_ShipmentPlanAdjustment.cs:1810 |  | DATA_OP | request.Parameters["p_new_transport_mode"] | p_new_transport_mode | 행/컬럼 값 대입 |  |  |  |
| AC-b2bbcf51 | SaveButton [try ▸ try ▸ for (i <= siMain.ActiveSheet.RowCoun… | SSP0013_ShipmentPlanAdjustment.cs:1811 |  | DATA_OP | request.Parameters["p_new_d_contry"] | p_new_d_contry | 행/컬럼 값 대입 |  |  |  |
| AC-b62b2023 | SaveButton [try ▸ try ▸ for (i <= siMain.ActiveSheet.RowCoun… | SSP0013_ShipmentPlanAdjustment.cs:1812 |  | DATA_OP | request.Parameters["p_new_d_port_code"] | p_new_d_port_code | 행/컬럼 값 대입 |  |  |  |
| AC-4e70549c | SaveButton [try ▸ try ▸ for (i <= siMain.ActiveSheet.RowCoun… | SSP0013_ShipmentPlanAdjustment.cs:1813 |  | DATA_OP | request.Parameters["p_new_a_country"] | p_new_a_country | 행/컬럼 값 대입 |  |  |  |
| AC-60000f63 | SaveButton [try ▸ try ▸ for (i <= siMain.ActiveSheet.RowCoun… | SSP0013_ShipmentPlanAdjustment.cs:1814 |  | DATA_OP | request.Parameters["p_new_a_port_code"] | p_new_a_port_code | 행/컬럼 값 대입 |  |  |  |
| AC-92e70d76 | SaveButton [try ▸ try ▸ for (i <= siMain.ActiveSheet.RowCoun… | SSP0013_ShipmentPlanAdjustment.cs:1815 |  | DATA_OP | request.Parameters["p_new_customer_lt"] | p_new_customer_lt | 행/컬럼 값 대입 |  |  |  |
| AC-6adc4821 | SaveButton [try ▸ try ▸ for (i <= siMain.ActiveSheet.RowCoun… | SSP0013_ShipmentPlanAdjustment.cs:1816 |  | DATA_OP | request.Parameters["p_new_to_country"] | p_new_to_country | 행/컬럼 값 대입 |  |  |  |
| AC-66123450 | SaveButton [try ▸ try ▸ for (i <= siMain.ActiveSheet.RowCoun… | SSP0013_ShipmentPlanAdjustment.cs:1817 |  | DATA_OP | request.Parameters["p_new_to_city"] | p_new_to_city | 행/컬럼 값 대입 |  |  |  |
| AC-b7a6d758 | SaveButton [try ▸ try ▸ for (i <= siMain.ActiveSheet.RowCoun… | SSP0013_ShipmentPlanAdjustment.cs:1818 |  | DATA_OP | request.Parameters["p_edit_main"] | p_edit_main | 행/컬럼 값 대입 |  |  |  |
| AC-b9e51043 | SaveButton [try ▸ try ▸ for (i <= siMain.ActiveSheet.RowCoun… | SSP0013_ShipmentPlanAdjustment.cs:1819 |  | DATA_OP | request.Parameters["p_edit_remark"] | p_edit_remark | 행/컬럼 값 대입 |  |  |  |
| AC-4ad7938e | SaveButton [try ▸ try ▸ for (i <= siMain.ActiveSheet.RowCoun… | SSP0013_ShipmentPlanAdjustment.cs:1820 |  | DATA_OP | request.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-0ee0e108 | SaveButton [try ▸ try ▸ for (i <= siMain.ActiveSheet.RowCoun… | SSP0013_ShipmentPlanAdjustment.cs:1821 |  | DATA_OP | request.Parameters["p_user_dept_id"] | p_user_dept_id | 행/컬럼 값 대입 |  |  |  |
| AC-54e0e5d9 | SaveButton [try ▸ try ▸ for (i <= siMain.ActiveSheet.RowCoun… | SSP0013_ShipmentPlanAdjustment.cs:1822 |  | DATA_OP | request.Parameters["p_electrode_yn"] | p_electrode_yn | 행/컬럼 값 대입 |  |  |  |
| AC-4bac74bd | SaveButton [try ▸ try ▸ for (i <= siMain.ActiveSheet.RowCoun… | SSP0013_ShipmentPlanAdjustment.cs:1823 |  | DATA_OP | request.Parameters["p_electrode_type"] | p_electrode_type | 행/컬럼 값 대입 |  |  |  |
| AC-abff330b | SaveButton [try ▸ try ▸ for (i <= siMain.ActiveSheet.RowCoun… | SSP0013_ShipmentPlanAdjustment.cs:1824 |  | DATA_OP | request.Parameters["p_origin_from_division_id"] | p_origin_from_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-f4545fc9 | SaveButton [try ▸ try ▸ for (i <= siMain.ActiveSheet.RowCoun… | SSP0013_ShipmentPlanAdjustment.cs:1825 |  | DATA_OP | request.Parameters["p_origion_to_division_id"] | p_origion_to_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-8e77e127 | SaveButton [try ▸ try ▸ for (i <= siMain.ActiveSheet.RowCoun… | SSP0013_ShipmentPlanAdjustment.cs:1827 |  | DATA_OP | request.Parameters["p_remarks"] | p_remarks | 행/컬럼 값 대입 |  |  |  |
| AC-b69aa479 | SaveButton [try ▸ try ▸ for (i <= siMain.ActiveSheet.RowCoun… | SSP0013_ShipmentPlanAdjustment.cs:1828 |  | DATA_OP | request.Parameters["p_remarks2"] | p_remarks2 | 행/컬럼 값 대입 |  |  |  |
| AC-5618ca89 | SaveButton [try ▸ try ▸ for (i <= siMain.ActiveSheet.RowCoun… | SSP0013_ShipmentPlanAdjustment.cs:1829 |  | DATA_OP | request.Parameters["p_remarks3"] | p_remarks3 | 행/컬럼 값 대입 |  |  |  |
| AC-b51547ad | SaveButton [try ▸ try ▸ for (i <= siMain.ActiveSheet.RowCoun… | SSP0013_ShipmentPlanAdjustment.cs:1831 |  | DATA_OP | request.Parameters["p_change_reason_code"] | p_change_reason_code | 행/컬럼 값 대입 |  |  |  |
| AC-069a500c | SaveButton [try ▸ try ▸ for (i <= siMain.ActiveSheet.RowCoun… | SSP0013_ShipmentPlanAdjustment.cs:1832 |  | DATA_OP | request.Parameters["p_change_reason_detail"] | p_change_reason_datail | 행/컬럼 값 대입 |  |  |  |
| AC-2b6a8cf0 | SaveButton [try ▸ try ▸ for (i <= siMain.ActiveSheet.RowCoun… | SSP0013_ShipmentPlanAdjustment.cs:1833 |  | DATA_OP | request.Parameters["p_title"] | p_title | 행/컬럼 값 대입 |  |  |  |
| AC-18d5671b | SaveButton [try ▸ try ▸ for (i <= siMain.ActiveSheet.RowCoun… | SSP0013_ShipmentPlanAdjustment.cs:1834 |  | DATA_OP | request.Parameters["p_program_id"] | p_program_id | 행/컬럼 값 대입 |  |  |  |
| AC-c2f31f12 | SaveButton [try ▸ try ▸ for (i <= siMain.ActiveSheet.RowCoun… | SSP0013_ShipmentPlanAdjustment.cs:1836 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-828a53ef | SaveButton [try ▸ try ▸ for (i <= siMain.ActiveSheet.RowCoun… | SSP0013_ShipmentPlanAdjustment.cs:1867 | else of (ds.Tables[0].Rows[0][0].ToString() == "S") | MESSAGE | MessageHelper.GMessageBox | ("MSG00284", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-dae1affb | SaveButton [try ▸ try ▸ for (i <= siMain.ActiveSheet.RowCoun… | SSP0013_ShipmentPlanAdjustment.cs:1871 |  | RETURN | return bReturn; |  | 처리 중단/반환 |  |  |  |

## SSP0013_ShipmentPlanAdjustment.SpdMain_CellClick

진입점: spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5386f0a0 | spdMain.CellClick | SSP0013_ShipmentPlanAdjustment.cs:2883 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (spdMain.AutoClipboard == true) | CALL_EXT | im.Put | (new Keystroke(Keys.V, Keys.Control), SpreadActions.ClipboardPasteAsStringSkipHidden) | ⚠ 의미 확인 필요 |  |  |  |
| AC-7d900a71 | spdMain.CellClick | SSP0013_ShipmentPlanAdjustment.cs:2884 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (spdMain.AutoClipboard == true) | CALL_EXT | im.Put | (new Keystroke(Keys.C, Keys.Control), SpreadActions.ClipboardCopyAsStringSkipHidden) | ⚠ 의미 확인 필요 |  |  |  |
| AC-6577c7e1 | spdMain.CellClick | SSP0013_ShipmentPlanAdjustment.cs:2885 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (spdMain.AutoClipboard == true) | UI_PROP | spdMain.AutoClipboard | false | 속성 AutoClipboard 설정 |  |  |  |
| AC-f0643f35 | spdMain.CellClick | SSP0013_ShipmentPlanAdjustment.cs:2899 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE)) | FLAG | dtTransMode | Data.Common(Data.Type.TransMode, false, sDivision, sFromSite, sToSite, sIncoterms) ⇒ biz:CommonData.CommonDataList [code=TransMode] | 화면 필드/플래그 변경 |  |  |  |
| AC-482d6163 | spdMain.CellClick | SSP0013_ShipmentPlanAdjustment.cs:2899 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE)) | COMBO_DATA | Data.Common | (Data.Type.TransMode, false, sDivision, sFromSite, sToSite, sIncoterms) ⇒ biz:CommonData.CommonDataList [code=TransMode] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-43a2ebd4 | spdMain.CellClick | SSP0013_ShipmentPlanAdjustment.cs:2907 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE)) | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE), dtTransMode) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-74c8a0e7 | spdMain.CellClick | SSP0013_ShipmentPlanAdjustment.cs:2908 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE)) | GRID_SET | siMain.ActiveSheet.Cells[e.Row, siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE)].Vertical… | CellVerticalAlignment.Center | 그리드 속성/값 설정 |  |  |  |
| AC-d3070518 | spdMain.CellClick | SSP0013_ShipmentPlanAdjustment.cs:2909 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE)) | GRID_SET | siMain.ActiveSheet.Cells[e.Row, siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE)].Horizont… | CellHorizontalAlignment.Center | 그리드 속성/값 설정 |  |  |  |
| AC-d3c8baf8 | spdMain.CellClick | SSP0013_ShipmentPlanAdjustment.cs:2917 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.RowCount >= 1 && e.ColumnHeader) ▸ if (siMain.Activ… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].Value | false | 그리드 속성/값 설정 |  |  |  |
| AC-0919c518 | spdMain.CellClick | SSP0013_ShipmentPlanAdjustment.cs:2921 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.RowCount >= 1 && e.ColumnHeader) ▸ if (siMain.Activ… | GRID_SET | siMain.ActiveSheet.SetValue | (iRow, e.Column, false) | 그리드 값 설정 |  |  |  |
| AC-b94f9ae5 | spdMain.CellClick | SSP0013_ShipmentPlanAdjustment.cs:2933 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.REMARKS) \|\| e.Column ==… | UI_PROP | spdMain.AutoClipboard | true | 속성 AutoClipboard 설정 |  |  |  |
| AC-b6f5ffd2 | spdMain.CellClick | SSP0013_ShipmentPlanAdjustment.cs:2934 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.REMARKS) \|\| e.Column ==… | FLAG | im | spdMain.GetInputMap(FarPoint.Win.Spread.InputMapMode.WhenAncestorOfFocused) | 화면 필드/플래그 변경 |  |  |  |
| AC-e27dc3f3 | spdMain.CellClick | SSP0013_ShipmentPlanAdjustment.cs:2934 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.REMARKS) \|\| e.Column ==… | CALL_EXT | spdMain.GetInputMap | (FarPoint.Win.Spread.InputMapMode.WhenAncestorOfFocused) | ⚠ 의미 확인 필요 |  |  |  |
| AC-5d57b1fc | spdMain.CellClick | SSP0013_ShipmentPlanAdjustment.cs:2935 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.REMARKS) \|\| e.Column ==… | CALL_EXT | im.Put | (new Keystroke(Keys.V, Keys.Control), SpreadActions.None) | ⚠ 의미 확인 필요 |  |  |  |
| AC-bd8841df | spdMain.CellClick | SSP0013_ShipmentPlanAdjustment.cs:2936 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.REMARKS) \|\| e.Column ==… | CALL_EXT | im.Put | (new Keystroke(Keys.C, Keys.Control), SpreadActions.None) | ⚠ 의미 확인 필요 |  |  |  |
| AC-4c9868ca | spdMain.CellClick | SSP0013_ShipmentPlanAdjustment.cs:2949 | else of (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.RowCount >= 1 && e.ColumnHeader) ▸ if (siMain.… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].Value | false | 그리드 속성/값 설정 |  |  |  |
| AC-8870cf4f | spdMain.CellClick | SSP0013_ShipmentPlanAdjustment.cs:2953 | else of (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.RowCount >= 1 && e.ColumnHeader) ▸ if (siMain.… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].Value | true | 그리드 속성/값 설정 |  |  |  |
| AC-a49c20e2 | spdMain.CellClick | SSP0013_ShipmentPlanAdjustment.cs:2960 | else of (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.RowCount >= 1 && e.ColumnHeader) ▸ if (siMain.… | GRID_SET | siMain.ActiveSheet.SetValue | (iRow, e.Column, true) | 그리드 값 설정 |  |  |  |
| AC-493d22bf | spdMain.CellClick | SSP0013_ShipmentPlanAdjustment.cs:2964 | else of (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.RowCount >= 1 && e.ColumnHeader) ▸ if (siMain.… | GRID_SET | siMain.ActiveSheet.SetValue | (iRow, e.Column, false) | 그리드 값 설정 |  |  |  |
| AC-6f821db3 | spdMain.CellClick | SSP0013_ShipmentPlanAdjustment.cs:2981 | if (e.Column == siMain.GetColumnIndex(DefColumns.CHANGE_REQ_NO)) ▸ if (string.IsNullOrWhiteSpace(sRequestNo)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-89caa49d | spdMain.CellClick | SSP0013_ShipmentPlanAdjustment.cs:2983 | if (e.Column == siMain.GetColumnIndex(DefColumns.CHANGE_REQ_NO)) | POPUP | new SCM0002_ShipmentPlanRequestPopup | () | 팝업/폼 생성 |  |  |  |
| AC-dd18d657 | spdMain.CellClick | SSP0013_ShipmentPlanAdjustment.cs:2984 | if (e.Column == siMain.GetColumnIndex(DefColumns.CHANGE_REQ_NO)) | UI_PROP | pop.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-167f8f3e | spdMain.CellClick | SSP0013_ShipmentPlanAdjustment.cs:2985 | if (e.Column == siMain.GetColumnIndex(DefColumns.CHANGE_REQ_NO)) | UI_PROP | pop._sRequestNo | sRequestNo | 속성 _sRequestNo 설정 |  |  |  |
| AC-271d7dd2 | spdMain.CellClick | SSP0013_ShipmentPlanAdjustment.cs:2986 | if (e.Column == siMain.GetColumnIndex(DefColumns.CHANGE_REQ_NO)) | POPUP | pop.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## SSP0013_ShipmentPlanAdjustment.SpdMain_CellDoubleClick

진입점: spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-39eaa790 | spdMain.CellDoubleClick | SSP0013_ShipmentPlanAdjustment.cs:2997 | if (siMain != null && siMain.IsLock(siMain.SheetName) == true) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) | VALUE_CLEAR | txtModel2.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-96fa0b18 | spdMain.CellDoubleClick | SSP0013_ShipmentPlanAdjustment.cs:2998 | if (siMain != null && siMain.IsLock(siMain.SheetName) == true) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) | VALUE_CLEAR | txtCreateDate.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-c4053d25 | spdMain.CellDoubleClick | SSP0013_ShipmentPlanAdjustment.cs:3003 | if (siMain != null && siMain.IsLock(siMain.SheetName) == true) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) | GRID_INIT | siSub.ChangeSheet | (SpdSheet.shtSub) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-fb9699e7 | spdMain.CellDoubleClick | SSP0013_ShipmentPlanAdjustment.cs:3004 | if (siMain != null && siMain.IsLock(siMain.SheetName) == true) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) | GRID_INIT | siSub.ChangeActiveSheet | (SpdSheet.shtSub) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SSP0013_ShipmentPlanAdjustment.SpdMain_ClipboardPasted

진입점: spdMain.ClipboardPasted

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b2045671 | spdMain.ClipboardPasted | SSP0013_ShipmentPlanAdjustment.cs:2637 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | FLAG | dtTransMode | Data.Common(Data.Type.TransMode, false, sDivision, sFromSite, sToSite, sIncoterms2) ⇒ biz:CommonData.CommonDataList [code=TransMode] | 화면 필드/플래그 변경 |  |  |  |
| AC-8acc09f2 | spdMain.ClipboardPasted | SSP0013_ShipmentPlanAdjustment.cs:2637 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | COMBO_DATA | Data.Common | (Data.Type.TransMode, false, sDivision, sFromSite, sToSite, sIncoterms2) ⇒ biz:CommonData.CommonDataList [code=TransMode] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-9376857e | spdMain.ClipboardPasted | SSP0013_ShipmentPlanAdjustment.cs:2639 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | DATA_OP | dtTransMode.Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-cefc4922 | spdMain.ClipboardPasted | SSP0013_ShipmentPlanAdjustment.cs:2643 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | CALL_EXT | ((FarPoint.Win.Spread.FpSpread)sender).CancelCellEditing | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-3ad5738b | spdMain.ClipboardPasted | SSP0013_ShipmentPlanAdjustment.cs:2645 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(CAppSetting.StringAction), "") | 그리드 값 설정 |  |  |  |
| AC-dc12b939 | spdMain.ClipboardPasted | SSP0013_ShipmentPlanAdjustment.cs:2646 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(CAppSetting.StringAction)].BackColor | Color.White | 그리드 속성/값 설정 |  |  |  |
| AC-15207220 | spdMain.ClipboardPasted | SSP0013_ShipmentPlanAdjustment.cs:2647 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(DefColumns.SHIPMENT_CONFIRM_QTY)].For… | Color.Black | 그리드 속성/값 설정 |  |  |  |
| AC-8c618027 | spdMain.ClipboardPasted | SSP0013_ShipmentPlanAdjustment.cs:2648 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(DefColumns.SHIPMENT_DATE)].ForeColor | Color.Black | 그리드 속성/값 설정 |  |  |  |
| AC-4efb885e | spdMain.ClipboardPasted | SSP0013_ShipmentPlanAdjustment.cs:2654 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | MESSAGE | MessageHelper.GMessageBox | ("MSG00047", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b208d3a7 | spdMain.ClipboardPasted | SSP0013_ShipmentPlanAdjustment.cs:2655 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e76d1217 | spdMain.ClipboardPasted | SSP0013_ShipmentPlanAdjustment.cs:2680 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.NEW_ROUTE_ID), sRouteID) | 그리드 값 설정 |  |  |  |
| AC-77b5c101 | spdMain.ClipboardPasted | SSP0013_ShipmentPlanAdjustment.cs:2681 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.NEW_BOD_ID), sBodID) | 그리드 값 설정 |  |  |  |
| AC-ac9475fe | spdMain.ClipboardPasted | SSP0013_ShipmentPlanAdjustment.cs:2682 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.NEW_INCOTERMS), sIncoterms) | 그리드 값 설정 |  |  |  |
| AC-a90792b8 | spdMain.ClipboardPasted | SSP0013_ShipmentPlanAdjustment.cs:2683 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.NEW_D_COUNTRY), sDCountry) | 그리드 값 설정 |  |  |  |
| AC-7af8a1ec | spdMain.ClipboardPasted | SSP0013_ShipmentPlanAdjustment.cs:2684 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.NEW_D_PORT_CODE), sDPortCode) | 그리드 값 설정 |  |  |  |
| AC-c569eaac | spdMain.ClipboardPasted | SSP0013_ShipmentPlanAdjustment.cs:2685 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.NEW_A_COUNTRY), sACountry) | 그리드 값 설정 |  |  |  |
| AC-8dc86d05 | spdMain.ClipboardPasted | SSP0013_ShipmentPlanAdjustment.cs:2686 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.NEW_A_PORT_CODE), sAPortCode) | 그리드 값 설정 |  |  |  |
| AC-be990494 | spdMain.ClipboardPasted | SSP0013_ShipmentPlanAdjustment.cs:2687 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.NEW_TO_COUNTRY), sToCountry) | 그리드 값 설정 |  |  |  |
| AC-463de8c1 | spdMain.ClipboardPasted | SSP0013_ShipmentPlanAdjustment.cs:2688 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.NEW_TO_CITY), sToCity) | 그리드 값 설정 |  |  |  |
| AC-7f581891 | spdMain.ClipboardPasted | SSP0013_ShipmentPlanAdjustment.cs:2689 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.NEW_ETA), sEta) | 그리드 값 설정 |  |  |  |
| AC-18787332 | spdMain.ClipboardPasted | SSP0013_ShipmentPlanAdjustment.cs:2690 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.NEW_LT_DAY), dLT) | 그리드 값 설정 |  |  |  |
| AC-1e7de178 | spdMain.ClipboardPasted | SSP0013_ShipmentPlanAdjustment.cs:2691 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.NEW_TRANSPORT_MODE), sNewTransMode) | 그리드 값 설정 |  |  |  |
| AC-36fbf4fd | spdMain.ClipboardPasted | SSP0013_ShipmentPlanAdjustment.cs:2692 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-ccd2132e | spdMain.ClipboardPasted | SSP0013_ShipmentPlanAdjustment.cs:2702 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | GRID_SET | siMain.SetValue | (i, siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE), sNewTransMode) | 그리드 값 설정 |  |  |  |
| AC-20430dce | spdMain.ClipboardPasted | SSP0013_ShipmentPlanAdjustment.cs:2704 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | GRID_SET | siMain.SetValue | (i, siMain.GetColumnIndex(DefColumns.NEW_ROUTE_ID), sRouteID) | 그리드 값 설정 |  |  |  |
| AC-a0ba25e5 | spdMain.ClipboardPasted | SSP0013_ShipmentPlanAdjustment.cs:2705 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | GRID_SET | siMain.SetValue | (i, siMain.GetColumnIndex(DefColumns.NEW_BOD_ID), sBodID) | 그리드 값 설정 |  |  |  |
| AC-99e7ca2d | spdMain.ClipboardPasted | SSP0013_ShipmentPlanAdjustment.cs:2706 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | GRID_SET | siMain.SetValue | (i, siMain.GetColumnIndex(DefColumns.NEW_INCOTERMS), sIncoterms) | 그리드 값 설정 |  |  |  |
| AC-6f1075b0 | spdMain.ClipboardPasted | SSP0013_ShipmentPlanAdjustment.cs:2707 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | GRID_SET | siMain.SetValue | (i, siMain.GetColumnIndex(DefColumns.NEW_D_COUNTRY), sDCountry) | 그리드 값 설정 |  |  |  |
| AC-227a5472 | spdMain.ClipboardPasted | SSP0013_ShipmentPlanAdjustment.cs:2708 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | GRID_SET | siMain.SetValue | (i, siMain.GetColumnIndex(DefColumns.NEW_D_PORT_CODE), sDPortCode) | 그리드 값 설정 |  |  |  |
| AC-26d75997 | spdMain.ClipboardPasted | SSP0013_ShipmentPlanAdjustment.cs:2709 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | GRID_SET | siMain.SetValue | (i, siMain.GetColumnIndex(DefColumns.NEW_A_COUNTRY), sACountry) | 그리드 값 설정 |  |  |  |
| AC-f1e2437b | spdMain.ClipboardPasted | SSP0013_ShipmentPlanAdjustment.cs:2710 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | GRID_SET | siMain.SetValue | (i, siMain.GetColumnIndex(DefColumns.NEW_A_PORT_CODE), sAPortCode) | 그리드 값 설정 |  |  |  |
| AC-3352cdd7 | spdMain.ClipboardPasted | SSP0013_ShipmentPlanAdjustment.cs:2711 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | GRID_SET | siMain.SetValue | (i, siMain.GetColumnIndex(DefColumns.NEW_TO_COUNTRY), sToCountry) | 그리드 값 설정 |  |  |  |
| AC-88e1f2d3 | spdMain.ClipboardPasted | SSP0013_ShipmentPlanAdjustment.cs:2712 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | GRID_SET | siMain.SetValue | (i, siMain.GetColumnIndex(DefColumns.NEW_TO_CITY), sToCity) | 그리드 값 설정 |  |  |  |
| AC-c7c65e4f | spdMain.ClipboardPasted | SSP0013_ShipmentPlanAdjustment.cs:2713 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | GRID_SET | siMain.SetValue | (i, siMain.GetColumnIndex(DefColumns.NEW_ETA), sEta) | 그리드 값 설정 |  |  |  |
| AC-692865b2 | spdMain.ClipboardPasted | SSP0013_ShipmentPlanAdjustment.cs:2714 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | GRID_SET | siMain.SetValue | (i, siMain.GetColumnIndex(DefColumns.NEW_LT_DAY), dLT) | 그리드 값 설정 |  |  |  |
| AC-8798d226 | spdMain.ClipboardPasted | SSP0013_ShipmentPlanAdjustment.cs:2715 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | GRID_SET | siMain.SetValue | (i, siMain.GetColumnIndex(DefColumns.NEW_TRANSPORT_MODE), sNewTransMode) | 그리드 값 설정 |  |  |  |
| AC-18489247 | spdMain.ClipboardPasted | SSP0013_ShipmentPlanAdjustment.cs:2716 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | GRID_SET | siMain.SetValue | (i, siMain.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-3f7b63a6 | spdMain.ClipboardPasted | SSP0013_ShipmentPlanAdjustment.cs:2734 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(CAppSetting.StringAction), "") | 그리드 값 설정 |  |  |  |
| AC-cd96c9dc | spdMain.ClipboardPasted | SSP0013_ShipmentPlanAdjustment.cs:2735 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | GRID_STYLE | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(CAppSetting.StringAction)].ResetForeC… | () | 그리드 표시 설정 |  |  |  |
| AC-573428b4 | spdMain.ClipboardPasted | SSP0013_ShipmentPlanAdjustment.cs:2736 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | GRID_STYLE | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(CAppSetting.StringAction)].ResetBackC… | () | 그리드 표시 설정 |  |  |  |
| AC-b0606776 | spdMain.ClipboardPasted | SSP0013_ShipmentPlanAdjustment.cs:2739 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(DefColumns.SHIPMENT_DATE)].ForeColor | ControlColor.DefaultForeColor | 그리드 속성/값 설정 |  |  |  |
| AC-075a1d62 | spdMain.ClipboardPasted | SSP0013_ShipmentPlanAdjustment.cs:2757 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.SHIPMENT_DATE), sDate) | 그리드 값 설정 |  |  |  |
| AC-8429f343 | spdMain.ClipboardPasted | SSP0013_ShipmentPlanAdjustment.cs:2758 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.NEW_ETD), sDate) | 그리드 값 설정 |  |  |  |
| AC-09588dd3 | spdMain.ClipboardPasted | SSP0013_ShipmentPlanAdjustment.cs:2759 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.NEW_ETA), sEta) | 그리드 값 설정 |  |  |  |
| AC-c309e3fe | spdMain.ClipboardPasted | SSP0013_ShipmentPlanAdjustment.cs:2760 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.NEW_SHIPMENT_DATE), sDate) | 그리드 값 설정 |  |  |  |
| AC-8254a079 | spdMain.ClipboardPasted | SSP0013_ShipmentPlanAdjustment.cs:2761 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-ad628a15 | spdMain.ClipboardPasted | SSP0013_ShipmentPlanAdjustment.cs:2773 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | GRID_SET | siMain.SetValue | (i, siMain.GetColumnIndex(DefColumns.SHIPMENT_DATE), sDate) | 그리드 값 설정 |  |  |  |
| AC-73eb052e | spdMain.ClipboardPasted | SSP0013_ShipmentPlanAdjustment.cs:2775 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | GRID_SET | siMain.SetValue | (i, siMain.GetColumnIndex(DefColumns.NEW_ETD), sDate) | 그리드 값 설정 |  |  |  |
| AC-7f858032 | spdMain.ClipboardPasted | SSP0013_ShipmentPlanAdjustment.cs:2776 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | GRID_SET | siMain.SetValue | (i, siMain.GetColumnIndex(DefColumns.NEW_ETA), sEta) | 그리드 값 설정 |  |  |  |
| AC-af7a4077 | spdMain.ClipboardPasted | SSP0013_ShipmentPlanAdjustment.cs:2777 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | GRID_SET | siMain.SetValue | (i, siMain.GetColumnIndex(DefColumns.NEW_SHIPMENT_DATE), sDate) | 그리드 값 설정 |  |  |  |
| AC-0d81b6e8 | spdMain.ClipboardPasted | SSP0013_ShipmentPlanAdjustment.cs:2778 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | GRID_SET | siMain.SetValue | (i, siMain.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-89ca90e6 | spdMain.ClipboardPasted | SSP0013_ShipmentPlanAdjustment.cs:2786 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-111c3101 | spdMain.ClipboardPasted | SSP0013_ShipmentPlanAdjustment.cs:2793 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-5419a940 | spdMain.ClipboardPasted | SSP0013_ShipmentPlanAdjustment.cs:2802 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | DATA_OP | dtChangeReasonCode.Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-b11172e0 | spdMain.ClipboardPasted | SSP0013_ShipmentPlanAdjustment.cs:2806 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | CALL_EXT | ((FarPoint.Win.Spread.FpSpread)sender).CancelCellEditing | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-18806511 | spdMain.ClipboardPasted | SSP0013_ShipmentPlanAdjustment.cs:2810 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | MESSAGE | MessageHelper.GMessageBox | ("MSG00047", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-365171a7 | spdMain.ClipboardPasted | SSP0013_ShipmentPlanAdjustment.cs:2811 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3fa2acc7 | spdMain.ClipboardPasted | SSP0013_ShipmentPlanAdjustment.cs:2817 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(DefColumns.CHANGE_REASON_CODE)].ForeC… | ControlColor.MarkedForeColor | 그리드 속성/값 설정 |  |  |  |
| AC-3c973192 | spdMain.ClipboardPasted | SSP0013_ShipmentPlanAdjustment.cs:2821 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-2b2c2f3d | spdMain.ClipboardPasted | SSP0013_ShipmentPlanAdjustment.cs:2832 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | GRID_SET | siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(DefColumns.CHANGE_REASON_CODE)].ForeColo… | ControlColor.MarkedForeColor | 그리드 속성/값 설정 |  |  |  |
| AC-04e2ffb8 | spdMain.ClipboardPasted | SSP0013_ShipmentPlanAdjustment.cs:2834 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | GRID_SET | siMain.SetValue | (i, siMain.GetColumnIndex(DefColumns.CHANGE_REASON_CODE), sNewChangeReasonCode) | 그리드 값 설정 |  |  |  |
| AC-2acc6af8 | spdMain.ClipboardPasted | SSP0013_ShipmentPlanAdjustment.cs:2835 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | GRID_SET | siMain.SetValue | (i, siMain.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-68e13c04 | spdMain.ClipboardPasted | SSP0013_ShipmentPlanAdjustment.cs:2849 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-cbca1f86 | spdMain.ClipboardPasted | SSP0013_ShipmentPlanAdjustment.cs:2861 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | GRID_SET | siMain.SetValue | (i, siMain.GetColumnIndex(DefColumns.CHANGE_REASON_DETAIL), sNewChangeReasonDetail) | 그리드 값 설정 |  |  |  |
| AC-ad663886 | spdMain.ClipboardPasted | SSP0013_ShipmentPlanAdjustment.cs:2862 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (iRow < e.CellRange.Row + e.Cell… | GRID_SET | siMain.SetValue | (i, siMain.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |

## SSP0013_ShipmentPlanAdjustment.SpdMain_ComboSelChange

진입점: spdMain.ComboSelChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d3b4263e | spdMain.ComboSelChange | SSP0013_ShipmentPlanAdjustment.cs:2144 | if (e.Column == siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE)) ▸ if (string.IsNullOrWhiteSpace(siMain.GetValue(e.Row, siMain.GetColumnInd… | MESSAGE | MessageHelper.GMessageBox | ("MSG00278") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-deb88bd1 | spdMain.ComboSelChange | SSP0013_ShipmentPlanAdjustment.cs:2145 | if (e.Column == siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE)) ▸ if (string.IsNullOrWhiteSpace(siMain.GetValue(e.Row, siMain.GetColumnInd… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8d0489d0 | spdMain.ComboSelChange | SSP0013_ShipmentPlanAdjustment.cs:2149 | if (e.Column == siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE)) | DATA_OP | dtTransMode.Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-e4de47ba | spdMain.ComboSelChange | SSP0013_ShipmentPlanAdjustment.cs:2179 | if (e.Column == siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE)) ▸ if (string.IsNullOrWhiteSpace(sSoNo)) | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.NEW_ROUTE_ID), sRouteID) | 그리드 값 설정 |  |  |  |
| AC-fd3f6d56 | spdMain.ComboSelChange | SSP0013_ShipmentPlanAdjustment.cs:2180 | if (e.Column == siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE)) ▸ if (string.IsNullOrWhiteSpace(sSoNo)) | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.NEW_BOD_ID), sBodID) | 그리드 값 설정 |  |  |  |
| AC-3d6d824d | spdMain.ComboSelChange | SSP0013_ShipmentPlanAdjustment.cs:2181 | if (e.Column == siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE)) ▸ if (string.IsNullOrWhiteSpace(sSoNo)) | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.NEW_INCOTERMS), sIncoterms) | 그리드 값 설정 |  |  |  |
| AC-15d72eb8 | spdMain.ComboSelChange | SSP0013_ShipmentPlanAdjustment.cs:2182 | if (e.Column == siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE)) ▸ if (string.IsNullOrWhiteSpace(sSoNo)) | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.NEW_D_COUNTRY), sDCountry) | 그리드 값 설정 |  |  |  |
| AC-399ffa91 | spdMain.ComboSelChange | SSP0013_ShipmentPlanAdjustment.cs:2183 | if (e.Column == siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE)) ▸ if (string.IsNullOrWhiteSpace(sSoNo)) | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.NEW_D_PORT_CODE), sDPortCode) | 그리드 값 설정 |  |  |  |
| AC-7bd5687c | spdMain.ComboSelChange | SSP0013_ShipmentPlanAdjustment.cs:2184 | if (e.Column == siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE)) ▸ if (string.IsNullOrWhiteSpace(sSoNo)) | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.NEW_A_COUNTRY), sACountry) | 그리드 값 설정 |  |  |  |
| AC-3f2c96d8 | spdMain.ComboSelChange | SSP0013_ShipmentPlanAdjustment.cs:2185 | if (e.Column == siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE)) ▸ if (string.IsNullOrWhiteSpace(sSoNo)) | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.NEW_A_PORT_CODE), sAPortCode) | 그리드 값 설정 |  |  |  |
| AC-9691c284 | spdMain.ComboSelChange | SSP0013_ShipmentPlanAdjustment.cs:2186 | if (e.Column == siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE)) ▸ if (string.IsNullOrWhiteSpace(sSoNo)) | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.NEW_TO_COUNTRY), sToCountry) | 그리드 값 설정 |  |  |  |
| AC-a2cbcbd8 | spdMain.ComboSelChange | SSP0013_ShipmentPlanAdjustment.cs:2187 | if (e.Column == siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE)) ▸ if (string.IsNullOrWhiteSpace(sSoNo)) | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.NEW_TO_CITY), sToCity) | 그리드 값 설정 |  |  |  |
| AC-d746c3f9 | spdMain.ComboSelChange | SSP0013_ShipmentPlanAdjustment.cs:2188 | if (e.Column == siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE)) ▸ if (string.IsNullOrWhiteSpace(sSoNo)) | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.NEW_ETA), sEta) | 그리드 값 설정 |  |  |  |
| AC-27b274a7 | spdMain.ComboSelChange | SSP0013_ShipmentPlanAdjustment.cs:2189 | if (e.Column == siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE)) ▸ if (string.IsNullOrWhiteSpace(sSoNo)) | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.NEW_LT_DAY), dLT) | 그리드 값 설정 |  |  |  |
| AC-d7f4bd9b | spdMain.ComboSelChange | SSP0013_ShipmentPlanAdjustment.cs:2190 | if (e.Column == siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE)) ▸ if (string.IsNullOrWhiteSpace(sSoNo)) | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.NEW_CUSTOMER_LT), dLT) | 그리드 값 설정 |  |  |  |
| AC-6199cb87 | spdMain.ComboSelChange | SSP0013_ShipmentPlanAdjustment.cs:2191 | if (e.Column == siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE)) ▸ if (string.IsNullOrWhiteSpace(sSoNo)) | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.NEW_TRANSPORT_MODE), sNewTransMode) | 그리드 값 설정 |  |  |  |
| AC-d4dbde8e | spdMain.ComboSelChange | SSP0013_ShipmentPlanAdjustment.cs:2196 | if (e.Column == siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE)) ▸ if (string.IsNullOrWhiteSpace(sSoNo)) | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-64ae66c0 | spdMain.ComboSelChange | SSP0013_ShipmentPlanAdjustment.cs:2206 | if (e.Column == siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE)) ▸ else of (string.IsNullOrWhiteSpace(sSoNo)) ▸ for (iRow < siMain.ActiveSh… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE), sNewTransMode) | 그리드 값 설정 |  |  |  |
| AC-1aa7ce47 | spdMain.ComboSelChange | SSP0013_ShipmentPlanAdjustment.cs:2208 | if (e.Column == siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE)) ▸ else of (string.IsNullOrWhiteSpace(sSoNo)) ▸ for (iRow < siMain.ActiveSh… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.NEW_ROUTE_ID), sRouteID) | 그리드 값 설정 |  |  |  |
| AC-c318bc2c | spdMain.ComboSelChange | SSP0013_ShipmentPlanAdjustment.cs:2209 | if (e.Column == siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE)) ▸ else of (string.IsNullOrWhiteSpace(sSoNo)) ▸ for (iRow < siMain.ActiveSh… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.NEW_BOD_ID), sBodID) | 그리드 값 설정 |  |  |  |
| AC-928818c2 | spdMain.ComboSelChange | SSP0013_ShipmentPlanAdjustment.cs:2210 | if (e.Column == siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE)) ▸ else of (string.IsNullOrWhiteSpace(sSoNo)) ▸ for (iRow < siMain.ActiveSh… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.NEW_INCOTERMS), sIncoterms) | 그리드 값 설정 |  |  |  |
| AC-f530b410 | spdMain.ComboSelChange | SSP0013_ShipmentPlanAdjustment.cs:2211 | if (e.Column == siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE)) ▸ else of (string.IsNullOrWhiteSpace(sSoNo)) ▸ for (iRow < siMain.ActiveSh… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.NEW_D_COUNTRY), sDCountry) | 그리드 값 설정 |  |  |  |
| AC-56256ee9 | spdMain.ComboSelChange | SSP0013_ShipmentPlanAdjustment.cs:2212 | if (e.Column == siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE)) ▸ else of (string.IsNullOrWhiteSpace(sSoNo)) ▸ for (iRow < siMain.ActiveSh… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.NEW_D_PORT_CODE), sDPortCode) | 그리드 값 설정 |  |  |  |
| AC-34865483 | spdMain.ComboSelChange | SSP0013_ShipmentPlanAdjustment.cs:2213 | if (e.Column == siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE)) ▸ else of (string.IsNullOrWhiteSpace(sSoNo)) ▸ for (iRow < siMain.ActiveSh… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.NEW_A_COUNTRY), sACountry) | 그리드 값 설정 |  |  |  |
| AC-6865cc3d | spdMain.ComboSelChange | SSP0013_ShipmentPlanAdjustment.cs:2214 | if (e.Column == siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE)) ▸ else of (string.IsNullOrWhiteSpace(sSoNo)) ▸ for (iRow < siMain.ActiveSh… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.NEW_A_PORT_CODE), sAPortCode) | 그리드 값 설정 |  |  |  |
| AC-8f0b9b1f | spdMain.ComboSelChange | SSP0013_ShipmentPlanAdjustment.cs:2215 | if (e.Column == siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE)) ▸ else of (string.IsNullOrWhiteSpace(sSoNo)) ▸ for (iRow < siMain.ActiveSh… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.NEW_TO_COUNTRY), sToCountry) | 그리드 값 설정 |  |  |  |
| AC-4dc61e1a | spdMain.ComboSelChange | SSP0013_ShipmentPlanAdjustment.cs:2216 | if (e.Column == siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE)) ▸ else of (string.IsNullOrWhiteSpace(sSoNo)) ▸ for (iRow < siMain.ActiveSh… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.NEW_TO_CITY), sToCity) | 그리드 값 설정 |  |  |  |
| AC-545c1e47 | spdMain.ComboSelChange | SSP0013_ShipmentPlanAdjustment.cs:2217 | if (e.Column == siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE)) ▸ else of (string.IsNullOrWhiteSpace(sSoNo)) ▸ for (iRow < siMain.ActiveSh… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.NEW_ETA), sEta) | 그리드 값 설정 |  |  |  |
| AC-4105eea7 | spdMain.ComboSelChange | SSP0013_ShipmentPlanAdjustment.cs:2218 | if (e.Column == siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE)) ▸ else of (string.IsNullOrWhiteSpace(sSoNo)) ▸ for (iRow < siMain.ActiveSh… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.NEW_LT_DAY), dLT) | 그리드 값 설정 |  |  |  |
| AC-95cca3d0 | spdMain.ComboSelChange | SSP0013_ShipmentPlanAdjustment.cs:2219 | if (e.Column == siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE)) ▸ else of (string.IsNullOrWhiteSpace(sSoNo)) ▸ for (iRow < siMain.ActiveSh… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.NEW_CUSTOMER_LT), dLT) | 그리드 값 설정 |  |  |  |
| AC-2504a9d9 | spdMain.ComboSelChange | SSP0013_ShipmentPlanAdjustment.cs:2220 | if (e.Column == siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE)) ▸ else of (string.IsNullOrWhiteSpace(sSoNo)) ▸ for (iRow < siMain.ActiveSh… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.NEW_TRANSPORT_MODE), sNewTransMode) | 그리드 값 설정 |  |  |  |
| AC-a5813e4a | spdMain.ComboSelChange | SSP0013_ShipmentPlanAdjustment.cs:2225 | if (e.Column == siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE)) ▸ else of (string.IsNullOrWhiteSpace(sSoNo)) ▸ for (iRow < siMain.ActiveSh… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-2dde0afa | spdMain.ComboSelChange | SSP0013_ShipmentPlanAdjustment.cs:2248 | else of (e.Column == siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.CHANGE_REASON_CODE… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.EDIT_MAIN), "N") | 그리드 값 설정 |  |  |  |
| AC-ab9ae2c7 | spdMain.ComboSelChange | SSP0013_ShipmentPlanAdjustment.cs:2253 | else of (e.Column == siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.CHANGE_REASON_CODE… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-04c16e16 | spdMain.ComboSelChange | SSP0013_ShipmentPlanAdjustment.cs:2267 | else of (e.Column == siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.CHANGE_REASON_CODE… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.EDIT_MAIN), "N") | 그리드 값 설정 |  |  |  |
| AC-9b89bd0a | spdMain.ComboSelChange | SSP0013_ShipmentPlanAdjustment.cs:2272 | else of (e.Column == siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.CHANGE_REASON_CODE… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.CHANGE_REASON_CODE), sNewChangeReasonCode) | 그리드 값 설정 |  |  |  |
| AC-1e612c8c | spdMain.ComboSelChange | SSP0013_ShipmentPlanAdjustment.cs:2273 | else of (e.Column == siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.CHANGE_REASON_CODE… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |

## SSP0013_ShipmentPlanAdjustment.SpdMain_EditChange

진입점: spdMain.EditChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-21b6dcda | spdMain.EditChange | SSP0013_ShipmentPlanAdjustment.cs:2515 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (e.Column == siMain.GetColumnInde… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.NEW_ETD), sDate) | 그리드 값 설정 |  |  |  |
| AC-4654c995 | spdMain.EditChange | SSP0013_ShipmentPlanAdjustment.cs:2516 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (e.Column == siMain.GetColumnInde… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.NEW_ETA), sEta) | 그리드 값 설정 |  |  |  |
| AC-c481e0e0 | spdMain.EditChange | SSP0013_ShipmentPlanAdjustment.cs:2517 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (e.Column == siMain.GetColumnInde… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.NEW_SHIPMENT_DATE), sDate) | 그리드 값 설정 |  |  |  |
| AC-29de405e | spdMain.EditChange | SSP0013_ShipmentPlanAdjustment.cs:2518 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (e.Column == siMain.GetColumnInde… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-3957600e | spdMain.EditChange | SSP0013_ShipmentPlanAdjustment.cs:2528 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (e.Column == siMain.GetColumnInde… | GRID_SET | siMain.SetValue | (i, siMain.GetColumnIndex(DefColumns.SHIPMENT_DATE), sDate) | 그리드 값 설정 |  |  |  |
| AC-22beb3c6 | spdMain.EditChange | SSP0013_ShipmentPlanAdjustment.cs:2530 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (e.Column == siMain.GetColumnInde… | GRID_SET | siMain.SetValue | (i, siMain.GetColumnIndex(DefColumns.NEW_ETD), sDate) | 그리드 값 설정 |  |  |  |
| AC-c6e948d2 | spdMain.EditChange | SSP0013_ShipmentPlanAdjustment.cs:2531 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (e.Column == siMain.GetColumnInde… | GRID_SET | siMain.SetValue | (i, siMain.GetColumnIndex(DefColumns.NEW_ETA), sEta) | 그리드 값 설정 |  |  |  |
| AC-d61c09b1 | spdMain.EditChange | SSP0013_ShipmentPlanAdjustment.cs:2532 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (e.Column == siMain.GetColumnInde… | GRID_SET | siMain.SetValue | (i, siMain.GetColumnIndex(DefColumns.NEW_SHIPMENT_DATE), sDate) | 그리드 값 설정 |  |  |  |
| AC-2e4c01bc | spdMain.EditChange | SSP0013_ShipmentPlanAdjustment.cs:2533 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (e.Column == siMain.GetColumnInde… | GRID_SET | siMain.SetValue | (i, siMain.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-0ce749e9 | spdMain.EditChange | SSP0013_ShipmentPlanAdjustment.cs:2549 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (e.Column == siMain.GetColum… | GRID_STYLE | siMain.ActiveSheet.SetActiveCell | (e.Row, siMain.GetColumnIndex(DefColumns.ERP_SO_NO)) | 그리드 표시 설정 |  |  |  |
| AC-3103b597 | spdMain.EditChange | SSP0013_ShipmentPlanAdjustment.cs:2550 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (e.Column == siMain.GetColum… | CALL_EXT | siMain.ActiveSheet.Cells[e.Row, siMain.GetColumnIndex(DefColumns.CHANGE_REASON_DETAIL)].Re… | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-5b77f8be | spdMain.EditChange | SSP0013_ShipmentPlanAdjustment.cs:2552 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (e.Column == siMain.GetColum… | MESSAGE | MessageHelper.GMessageBox | ("MSG00287", new object[] { null }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-bc9a06b5 | spdMain.EditChange | SSP0013_ShipmentPlanAdjustment.cs:2554 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (e.Column == siMain.GetColum… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-02c9f60b | spdMain.EditChange | SSP0013_ShipmentPlanAdjustment.cs:2562 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (e.Column == siMain.GetColum… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-824c3843 | spdMain.EditChange | SSP0013_ShipmentPlanAdjustment.cs:2572 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (e.Column == siMain.GetColum… | GRID_SET | siMain.SetValue | (i, siMain.GetColumnIndex(DefColumns.CHANGE_REASON_DETAIL), sNewChangeReasonDetail) | 그리드 값 설정 |  |  |  |
| AC-dbee56e3 | spdMain.EditChange | SSP0013_ShipmentPlanAdjustment.cs:2574 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (e.Column == siMain.GetColum… | GRID_SET | siMain.SetValue | (i, siMain.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |

## SSP0013_ShipmentPlanAdjustment.Validation_Check

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-38cf8b50 | SaveButton | SSP0013_ShipmentPlanAdjustment.cs:1100 |  | FLAG | bolChang_Flag | false | 화면 필드/플래그 변경 |  |  |  |
| AC-336f1a36 | SaveButton | SSP0013_ShipmentPlanAdjustment.cs:1117 | for (i < siMain.ActiveSheet.RowCount) ▸ if (siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(CAppSetting.StringAction)].Text == "M") ▸ if (… | MESSAGE | MessageHelper.GMessageBox | ("MSG00194", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-4622dfd8 | SaveButton | SSP0013_ShipmentPlanAdjustment.cs:1118 | for (i < siMain.ActiveSheet.RowCount) ▸ if (siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(CAppSetting.StringAction)].Text == "M") ▸ if (… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-54df4c31 | SaveButton | SSP0013_ShipmentPlanAdjustment.cs:1129 | for (i < siMain.ActiveSheet.RowCount) ▸ if (siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(CAppSetting.StringAction)].Text == "M") ▸ if (… | MESSAGE | MessageHelper.GMessageBox | ("MSG00277", new object[] { (i + 1).ToString(), strDiffMaxDay }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-74b5d0a1 | SaveButton | SSP0013_ShipmentPlanAdjustment.cs:1130 | for (i < siMain.ActiveSheet.RowCount) ▸ if (siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(CAppSetting.StringAction)].Text == "M") ▸ if (… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-bbd319cc | SaveButton | SSP0013_ShipmentPlanAdjustment.cs:1134 | for (i < siMain.ActiveSheet.RowCount) ▸ if (siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(CAppSetting.StringAction)].Text == "M") ▸ if (… | MESSAGE | MessageHelper.GMessageBox | ("MSG00277", new object[] { (i + 1).ToString(), strDiffMinDay }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-2fe1cff7 | SaveButton | SSP0013_ShipmentPlanAdjustment.cs:1135 | for (i < siMain.ActiveSheet.RowCount) ▸ if (siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(CAppSetting.StringAction)].Text == "M") ▸ if (… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-11f62254 | SaveButton | SSP0013_ShipmentPlanAdjustment.cs:1141 | for (i < siMain.ActiveSheet.RowCount) ▸ if (siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(CAppSetting.StringAction)].Text == "M") | DATA_OP | DefaultMainDS.Tables[0].Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-c6acc8f0 | SaveButton | SSP0013_ShipmentPlanAdjustment.cs:1141 | for (i < siMain.ActiveSheet.RowCount) ▸ if (siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(CAppSetting.StringAction)].Text == "M") ▸ lamb… | DATA_OP | row.Field | ("confirm_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-e9cd3814 | SaveButton | SSP0013_ShipmentPlanAdjustment.cs:1155 | for (i < siMain.ActiveSheet.RowCount) ▸ if (siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(CAppSetting.StringAction)].Text == "M") ▸ if (… | FLAG | bolChang_Flag | true | 화면 필드/플래그 변경 |  |  |  |
| AC-4c422a58 | SaveButton | SSP0013_ShipmentPlanAdjustment.cs:1167 | for (i < siMain.ActiveSheet.RowCount) ▸ if (siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(CAppSetting.StringAction)].Text == "M") ▸ if (… | MESSAGE | MessageHelper.GMessageBox | ("MSG00285", new object[] { (i + 1).ToString() }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d909bfca | SaveButton | SSP0013_ShipmentPlanAdjustment.cs:1169 | for (i < siMain.ActiveSheet.RowCount) ▸ if (siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(CAppSetting.StringAction)].Text == "M") ▸ if (… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-752b67f2 | SaveButton | SSP0013_ShipmentPlanAdjustment.cs:1187 | for (i < siMain.ActiveSheet.RowCount) ▸ if (siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(CAppSetting.StringAction)].Text == "M") ▸ if (… | DATA_OP | DefaultMainDS.Tables[0].Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-279dca95 | SaveButton | SSP0013_ShipmentPlanAdjustment.cs:1187 | for (i < siMain.ActiveSheet.RowCount) ▸ if (siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(CAppSetting.StringAction)].Text == "M") ▸ if (… | DATA_OP | row.Field | ("confirm_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-dc7ad451 | SaveButton | SSP0013_ShipmentPlanAdjustment.cs:1222 | for (i < siMain.ActiveSheet.RowCount) ▸ if (siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(CAppSetting.StringAction)].Text == "M") ▸ else… | FLAG | bolChang_Flag | false | 화면 필드/플래그 변경 |  |  |  |
| AC-b7e80a61 | SaveButton | SSP0013_ShipmentPlanAdjustment.cs:1226 | for (i < siMain.ActiveSheet.RowCount) ▸ if (siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(CAppSetting.StringAction)].Text == "M") ▸ else… | FLAG | bolChang_Flag | true | 화면 필드/플래그 변경 |  |  |  |
| AC-5633bd28 | SaveButton | SSP0013_ShipmentPlanAdjustment.cs:1234 | for (i < siMain.ActiveSheet.RowCount) ▸ if (siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(CAppSetting.StringAction)].Text == "M") ▸ else… | GRID_STYLE | siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(CAppSetting.StringAction)].ResetBackColo… | () | 그리드 표시 설정 |  |  |  |
| AC-7e672766 | SaveButton | SSP0013_ShipmentPlanAdjustment.cs:1235 | for (i < siMain.ActiveSheet.RowCount) ▸ if (siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(CAppSetting.StringAction)].Text == "M") ▸ else… | GRID_STYLE | siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(CAppSetting.StringAction)].ResetForeColo… | () | 그리드 표시 설정 |  |  |  |
| AC-8d362ddf | SaveButton | SSP0013_ShipmentPlanAdjustment.cs:1236 | for (i < siMain.ActiveSheet.RowCount) ▸ if (siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(CAppSetting.StringAction)].Text == "M") ▸ else… | GRID_SET | siMain.SetValue | (i, siMain.GetColumnIndex(CAppSetting.StringAction), "") | 그리드 값 설정 |  |  |  |
| AC-e2a140e7 | SaveButton | SSP0013_ShipmentPlanAdjustment.cs:1238 | for (i < siMain.ActiveSheet.RowCount) ▸ if (siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(CAppSetting.StringAction)].Text == "M") ▸ else… | GRID_STYLE | siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(DefColumns.SHIPMENT_CONFIRM_QTY)].ResetF… | () | 그리드 표시 설정 |  |  |  |
| AC-2b716663 | SaveButton | SSP0013_ShipmentPlanAdjustment.cs:1239 | for (i < siMain.ActiveSheet.RowCount) ▸ if (siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(CAppSetting.StringAction)].Text == "M") ▸ else… | GRID_STYLE | siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(DefColumns.SHIPMENT_DATE)].ResetForeColo… | () | 그리드 표시 설정 |  |  |  |
| AC-a3e0948d | SaveButton | SSP0013_ShipmentPlanAdjustment.cs:1240 | for (i < siMain.ActiveSheet.RowCount) ▸ if (siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(CAppSetting.StringAction)].Text == "M") ▸ else… | GRID_STYLE | siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE)].ResetForeCol… | () | 그리드 표시 설정 |  |  |  |
| AC-fa74a03b | SaveButton | SSP0013_ShipmentPlanAdjustment.cs:1241 | for (i < siMain.ActiveSheet.RowCount) ▸ if (siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(CAppSetting.StringAction)].Text == "M") ▸ else… | GRID_STYLE | siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(DefColumns.REMARKS2)].ResetForeColor | () | 그리드 표시 설정 |  |  |  |
| AC-4efb8c94 | SaveButton | SSP0013_ShipmentPlanAdjustment.cs:1242 | for (i < siMain.ActiveSheet.RowCount) ▸ if (siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(CAppSetting.StringAction)].Text == "M") ▸ else… | GRID_STYLE | siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(DefColumns.REMARKS)].ResetForeColor | () | 그리드 표시 설정 |  |  |  |
| AC-27505957 | SaveButton | SSP0013_ShipmentPlanAdjustment.cs:1261 | for (i < siMain.ActiveSheet.RowCount) ▸ if (siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(CAppSetting.StringAction)].Text == "M") ▸ else… | DATA_OP | DefaultMainDS.Tables[0].Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-b760e588 | SaveButton | SSP0013_ShipmentPlanAdjustment.cs:1261 | for (i < siMain.ActiveSheet.RowCount) ▸ if (siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(CAppSetting.StringAction)].Text == "M") ▸ else… | DATA_OP | row.Field | ("confirm_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-47a73058 | SaveButton | SSP0013_ShipmentPlanAdjustment.cs:1289 | for (i < siMain.ActiveSheet.RowCount) ▸ if (siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(CAppSetting.StringAction)].Text == "M") ▸ else… | FLAG | bolChang_Flag | true | 화면 필드/플래그 변경 |  |  |  |
| AC-9e4738e8 | SaveButton | SSP0013_ShipmentPlanAdjustment.cs:1292 | for (i < siMain.ActiveSheet.RowCount) ▸ if (siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(CAppSetting.StringAction)].Text == "M") ▸ else… | GRID_STYLE | siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(CAppSetting.StringAction)].ResetBackColo… | () | 그리드 표시 설정 |  |  |  |
| AC-53713959 | SaveButton | SSP0013_ShipmentPlanAdjustment.cs:1293 | for (i < siMain.ActiveSheet.RowCount) ▸ if (siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(CAppSetting.StringAction)].Text == "M") ▸ else… | GRID_STYLE | siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(CAppSetting.StringAction)].ResetForeColo… | () | 그리드 표시 설정 |  |  |  |
| AC-adddf422 | SaveButton | SSP0013_ShipmentPlanAdjustment.cs:1294 | for (i < siMain.ActiveSheet.RowCount) ▸ if (siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(CAppSetting.StringAction)].Text == "M") ▸ else… | GRID_SET | siMain.SetValue | (i, siMain.GetColumnIndex(CAppSetting.StringAction), "") | 그리드 값 설정 |  |  |  |
| AC-b58ee2d7 | SaveButton | SSP0013_ShipmentPlanAdjustment.cs:1296 | for (i < siMain.ActiveSheet.RowCount) ▸ if (siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(CAppSetting.StringAction)].Text == "M") ▸ else… | GRID_STYLE | siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(DefColumns.SHIPMENT_CONFIRM_QTY)].ResetF… | () | 그리드 표시 설정 |  |  |  |
| AC-d7d27bef | SaveButton | SSP0013_ShipmentPlanAdjustment.cs:1297 | for (i < siMain.ActiveSheet.RowCount) ▸ if (siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(CAppSetting.StringAction)].Text == "M") ▸ else… | GRID_STYLE | siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(DefColumns.SHIPMENT_DATE)].ResetForeColo… | () | 그리드 표시 설정 |  |  |  |
| AC-bfc69c39 | SaveButton | SSP0013_ShipmentPlanAdjustment.cs:1298 | for (i < siMain.ActiveSheet.RowCount) ▸ if (siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(CAppSetting.StringAction)].Text == "M") ▸ else… | GRID_STYLE | siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE)].ResetForeCol… | () | 그리드 표시 설정 |  |  |  |
| AC-735aa53c | SaveButton | SSP0013_ShipmentPlanAdjustment.cs:1299 | for (i < siMain.ActiveSheet.RowCount) ▸ if (siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(CAppSetting.StringAction)].Text == "M") ▸ else… | GRID_STYLE | siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(DefColumns.REMARKS2)].ResetForeColor | () | 그리드 표시 설정 |  |  |  |
| AC-c4a0284e | SaveButton | SSP0013_ShipmentPlanAdjustment.cs:1300 | for (i < siMain.ActiveSheet.RowCount) ▸ if (siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(CAppSetting.StringAction)].Text == "M") ▸ else… | GRID_STYLE | siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(DefColumns.REMARKS)].ResetForeColor | () | 그리드 표시 설정 |  |  |  |
| AC-76ab0f70 | SaveButton | SSP0013_ShipmentPlanAdjustment.cs:1302 | for (i < siMain.ActiveSheet.RowCount) ▸ if (siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(CAppSetting.StringAction)].Text == "M") ▸ else… | MESSAGE | MessageHelper.GMessageBox | ("MSG00286", new object[] { (i + 1).ToString() }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a2b85bf3 | SaveButton | SSP0013_ShipmentPlanAdjustment.cs:1304 | for (i < siMain.ActiveSheet.RowCount) ▸ if (siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(CAppSetting.StringAction)].Text == "M") ▸ else… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-1a850392 | SaveButton | SSP0013_ShipmentPlanAdjustment.cs:1310 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

