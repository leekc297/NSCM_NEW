# AS-IS 액션 대조표 — SSP0060

> 원천: `Doc/asisfacts/screens/SSP0060/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 1928행 · 메서드 115 · 종류 DATA_OP 619 · GRID_INIT 225 · GRID_SET 160 · UI_PROP 145 · RETURN 129 · FLAG 109 · CALL_EXT 105 · ENDPOINT 105 · MESSAGE 83 · POPUP 49 · UI_MISC 45 · GRID_LOCK 35 · COMBO_DATA 24 · GRID_STYLE 19 · VALUE_SET 15 · LIST_REBIND 14 · GRID_BIND 11 · VALUE_CLEAR 8 · STATE_RESET 8 · GRID_COMBO 6 · VALIDATE 6 · CALL_BASE 6 · LIST_CLEAR 2 · ⚠ 의미 확인 필요 111


## SSP0060_ShipmentPlan.btnItemId_Click

진입점: this.btnItemId.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ea7c3038 | this.btnItemId.Click | SSP0060_ShipmentPlan.cs:2907 |  | POPUP | new SCM0002_ItembyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-23d08faa | this.btnItemId.Click | SSP0060_ShipmentPlan.cs:2909 |  | POPUP | popItem.Form_Load | (true, sDivision_ID, sScmSite, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-ac01d84a | this.btnItemId.Click | SSP0060_ShipmentPlan.cs:2910 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-a23bf9af | this.btnItemId.Click | SSP0060_ShipmentPlan.cs:2911 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-010dc1e5 | this.btnItemId.Click | SSP0060_ShipmentPlan.cs:2917 | if (popItem.ItemID != "") | VALUE_SET | txtItemId.Text | sItemId | 컨트롤 값 설정 |  |  |  |

## SSP0060_ShipmentPlan.BtnItemID2_Click

진입점: this.btnItemID2.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d7893ba4 | this.btnItemID2.Click | SSP0060_ShipmentPlan.cs:1040 |  | POPUP | new SCM0002_ItembyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-6164062e | this.btnItemID2.Click | SSP0060_ShipmentPlan.cs:1042 |  | POPUP | popItem.Form_Load | (true, sdivision, sScmSite, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-5fa88e6e | this.btnItemID2.Click | SSP0060_ShipmentPlan.cs:1043 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-aa0b7e02 | this.btnItemID2.Click | SSP0060_ShipmentPlan.cs:1044 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-0ac29532 | this.btnItemID2.Click | SSP0060_ShipmentPlan.cs:1050 | if (popItem.ItemID != "") | VALUE_SET | txtModel2.Text | sItemId | 컨트롤 값 설정 |  |  |  |

## SSP0060_ShipmentPlan.BtnMeasure_Click

진입점: this.btnMeasure.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-56f9a89b | this.btnMeasure.Click | SSP0060_ShipmentPlan.cs:2150 | if (fps != null) ▸ else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdDetail") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-889b9481 | this.btnMeasure.Click | SSP0060_ShipmentPlan.cs:2155 | if (fps != null) ▸ else of (fps.Name == "spdMain") ▸ else of (fps.Name == "spdDetail") | MESSAGE | MessageHelper.GMessageBox | ("MSG00007", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-94d80831 | this.btnMeasure.Click | SSP0060_ShipmentPlan.cs:2156 | if (fps != null) ▸ else of (fps.Name == "spdMain") ▸ else of (fps.Name == "spdDetail") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d65e2fe7 | this.btnMeasure.Click | SSP0060_ShipmentPlan.cs:2161 | else of (fps != null) | MESSAGE | MessageHelper.GMessageBox | ("MSG00007", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e054a18e | this.btnMeasure.Click | SSP0060_ShipmentPlan.cs:2162 | else of (fps != null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-96bb395e | this.btnMeasure.Click | SSP0060_ShipmentPlan.cs:2165 |  | POPUP | new SCM0002_TitleSetForm_Popup | ("SSP0060", shtName, false) | 팝업/폼 생성 |  |  |  |
| AC-29186977 | this.btnMeasure.Click | SSP0060_ShipmentPlan.cs:2166 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-9c25e277 | this.btnMeasure.Click | SSP0060_ShipmentPlan.cs:2167 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-1912bf41 | this.btnMeasure.Click | SSP0060_ShipmentPlan.cs:2171 | if (frm.DialogResult == DialogResult.OK) | UI_PROP | this.CanModelChange | false | 속성 CanModelChange 설정 |  |  |  |
| AC-d6c5e523 | this.btnMeasure.Click | SSP0060_ShipmentPlan.cs:2183 | if (frm.DialogResult == DialogResult.OK) | UI_PROP | this.CanModelChange | true | 속성 CanModelChange 설정 |  |  |  |

## SSP0060_ShipmentPlan.BtnNew_Click

진입점: this.btnNew.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f6a51b48 | this.btnNew.Click | SSP0060_ShipmentPlan.cs:7339 | if (spdDetail.ActiveSheetIndex != 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-128d142b | this.btnNew.Click | SSP0060_ShipmentPlan.cs:7381 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDe…) ▸ if (siDetai… | DATA_OP | siDetail.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-b19d4b64 | this.btnNew.Click | SSP0060_ShipmentPlan.cs:7384 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDe…) ▸ if (siDetai… | DATA_OP | defaultData.Add | (DefColumns.DIVISION_ID, division_id) | 데이터 객체 조작/조회 |  |  |  |
| AC-745338bd | this.btnNew.Click | SSP0060_ShipmentPlan.cs:7411 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDe…) ▸ if (siDetai… | DATA_OP | defaultData.Add | (DefColumns.MKT_OWNER, mkt_owner) | 데이터 객체 조작/조회 |  |  |  |
| AC-308db30b | this.btnNew.Click | SSP0060_ShipmentPlan.cs:7413 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDe…) ▸ if (siDetai… | GRID_SET | siDetail.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |
| AC-b3ab0c97 | this.btnNew.Click | SSP0060_ShipmentPlan.cs:7421 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDe…) ▸ if (siDetai… | GRID_COMBO | siDetail.SetCellTypeCombo | (siDetail.ActiveRowIndex, siDetail.GetColumnIndex(DefColumns.FROM_SITE_DESCRIPTION), dtFro… | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-61278fe5 | this.btnNew.Click | SSP0060_ShipmentPlan.cs:7422 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDe…) ▸ if (siDetai… | GRID_COMBO | siDetail.SetCellTypeCombo | (siDetail.ActiveRowIndex, siDetail.GetColumnIndex(DefColumns.TO_SITE_DESCRIPTION), dtToSit… | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-48a1956d | this.btnNew.Click | SSP0060_ShipmentPlan.cs:7432 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDe…) ▸ if (siDetai… | GRID_SET | siDetail.ActiveSheet.Cells[siDetail.ActiveRowIndex, siDetail.GetColumnIndex(DefColumns.ITE… | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-bd670c0f | this.btnNew.Click | SSP0060_ShipmentPlan.cs:7433 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDe…) ▸ if (siDetai… | GRID_SET | siDetail.ActiveSheet.Cells[siDetail.ActiveRowIndex, siDetail.GetColumnIndex(DefColumns.PRO… | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-6a4404b2 | this.btnNew.Click | SSP0060_ShipmentPlan.cs:7434 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDe…) ▸ if (siDetai… | GRID_COMBO | siDetail.SetCellTypeCombo | (siDetail.ActiveRowIndex, siDetail.GetColumnIndex(DefColumns.DIVISION_ID), dtMyDivision) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-0fbfabab | this.btnNew.Click | SSP0060_ShipmentPlan.cs:7436 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDe…) ▸ if (siDetai… | GRID_LOCK | siDetail.LockRange | (insCell, siDetail.GetColumnIndex(DefColumns.DIVISION_ID), siDetail.GetColumnIndex(DefColu… | 그리드 편집 잠금/해제 |  |  |  |
| AC-1ef364e9 | this.btnNew.Click | SSP0060_ShipmentPlan.cs:7437 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDe…) ▸ if (siDetai… | GRID_LOCK | siDetail.LockRange | (insCell, siDetail.GetColumnIndex(DefColumns.MKT_OWNER), siDetail.GetColumnIndex(DefColumn… | 그리드 편집 잠금/해제 |  |  |  |

## SSP0060_ShipmentPlan.BtnRequestor_Click

진입점: this.btnRequestor.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-91840f02 | this.btnRequestor.Click | SSP0060_ShipmentPlan.cs:2385 |  | POPUP | new UserInfoPopup | () | 팝업/폼 생성 |  |  |  |
| AC-efdc9543 | this.btnRequestor.Click | SSP0060_ShipmentPlan.cs:2387 |  | UI_PROP | popup.Width | 500 | 속성 Width 설정 |  |  |  |
| AC-a3326942 | this.btnRequestor.Click | SSP0060_ShipmentPlan.cs:2388 |  | UI_PROP | popup.Height | 400 | 속성 Height 설정 |  |  |  |
| AC-cac620cf | this.btnRequestor.Click | SSP0060_ShipmentPlan.cs:2389 |  | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-7004e2fe | this.btnRequestor.Click | SSP0060_ShipmentPlan.cs:2390 |  | UI_PROP | popup.SSOUserYN | false | 속성 SSOUserYN 설정 |  |  |  |
| AC-e2fec227 | this.btnRequestor.Click | SSP0060_ShipmentPlan.cs:2391 |  | UI_PROP | popup.SingleSelectYn | true | 속성 SingleSelectYn 설정 |  |  |  |
| AC-9965f7a3 | this.btnRequestor.Click | SSP0060_ShipmentPlan.cs:2393 |  | UI_PROP | popup.Language | UserInfoContext.Current[UserInfoProperites.Language].ToString() | 속성 Language 설정 |  |  |  |
| AC-403a33df | this.btnRequestor.Click | SSP0060_ShipmentPlan.cs:2395 |  | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-bd4ea9e4 | this.btnRequestor.Click | SSP0060_ShipmentPlan.cs:2401 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (popup.SelectedUserInfoList.Count > 0) ▸ foreach (var item in popup.SelectedUserInfoList) | FLAG | sRequestor | item.UserID | 화면 필드/플래그 변경 |  |  |  |
| AC-241fb63f | this.btnRequestor.Click | SSP0060_ShipmentPlan.cs:2405 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (popup.SelectedUserInfoList.Count > 0) ▸ foreach (var item in popup.SelectedUserInfoList) ▸ … | VALUE_SET | txtRequestor.Text | item.UserName | 컨트롤 값 설정 |  |  |  |
| AC-d1b575a0 | this.btnRequestor.Click | SSP0060_ShipmentPlan.cs:2409 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (popup.SelectedUserInfoList.Count > 0) ▸ foreach (var item in popup.SelectedUserInfoList) ▸ … | VALUE_SET | txtRequestor.Text | item.UserName_E | 컨트롤 값 설정 |  |  |  |

## SSP0060_ShipmentPlan.BtnSearch_Click

진입점: this.btnSearch.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-112f98c6 | this.btnSearch.Click | SSP0060_ShipmentPlan.cs:7277 | if (spdDetail.ActiveSheetIndex == 0) | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtPlanDetail) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-902e723c | this.btnSearch.Click | SSP0060_ShipmentPlan.cs:7278 | if (spdDetail.ActiveSheetIndex == 0) | GRID_INIT | siDetail.ChangeActiveSheet | (SpdSheet.shtPlanDetail) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-f2e7d740 | this.btnSearch.Click | SSP0060_ShipmentPlan.cs:7281 | if (spdDetail.ActiveSheetIndex == 0) | FLAG | this.bDetail_Search | false | 화면 필드/플래그 변경 |  |  |  |
| AC-ac73bf15 | this.btnSearch.Click | SSP0060_ShipmentPlan.cs:7282 | if (spdDetail.ActiveSheetIndex == 0) | FLAG | this.bEdit_Mode | false | 화면 필드/플래그 변경 |  |  |  |
| AC-3eb259bc | this.btnSearch.Click | SSP0060_ShipmentPlan.cs:7286 | else of (spdDetail.ActiveSheetIndex == 0) ▸ if (spdDetail.ActiveSheetIndex == 1) | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtStockDetail) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-66fe3062 | this.btnSearch.Click | SSP0060_ShipmentPlan.cs:7287 | else of (spdDetail.ActiveSheetIndex == 0) ▸ if (spdDetail.ActiveSheetIndex == 1) | GRID_INIT | siDetail.ChangeActiveSheet | (SpdSheet.shtStockDetail) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-cfa823fb | this.btnSearch.Click | SSP0060_ShipmentPlan.cs:7293 | else of (spdDetail.ActiveSheetIndex == 0) ▸ else of (spdDetail.ActiveSheetIndex == 1) ▸ if (spdDetail.ActiveSheetIndex == 2) | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtoWMSDetail) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c6e74b1e | this.btnSearch.Click | SSP0060_ShipmentPlan.cs:7294 | else of (spdDetail.ActiveSheetIndex == 0) ▸ else of (spdDetail.ActiveSheetIndex == 1) ▸ if (spdDetail.ActiveSheetIndex == 2) | GRID_INIT | siDetail.ChangeActiveSheet | (SpdSheet.shtoWMSDetail) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-a2022834 | this.btnSearch.Click | SSP0060_ShipmentPlan.cs:7308 | if (spdDetail.ActiveSheetIndex == 3) | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtMESStock) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-fd51a57a | this.btnSearch.Click | SSP0060_ShipmentPlan.cs:7309 | if (spdDetail.ActiveSheetIndex == 3) | GRID_INIT | siDetail.ChangeActiveSheet | (SpdSheet.shtMESStock) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-e525e3ce | this.btnSearch.Click | SSP0060_ShipmentPlan.cs:7312 | if (spdDetail.ActiveSheetIndex == 3) | FLAG | this.bDetail_Search | false | 화면 필드/플래그 변경 |  |  |  |
| AC-1d4eb03a | this.btnSearch.Click | SSP0060_ShipmentPlan.cs:7316 | if (spdDetail.ActiveSheetIndex == 4) | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtMESStockDetail) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f38a569d | this.btnSearch.Click | SSP0060_ShipmentPlan.cs:7317 | if (spdDetail.ActiveSheetIndex == 4) | GRID_INIT | siDetail.ChangeActiveSheet | (SpdSheet.shtMESStockDetail) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-9f28f104 | this.btnSearch.Click | SSP0060_ShipmentPlan.cs:7320 | if (spdDetail.ActiveSheetIndex == 4) | FLAG | this.bDetail_Search | false | 화면 필드/플래그 변경 |  |  |  |
| AC-97282324 | this.btnSearch.Click | SSP0060_ShipmentPlan.cs:7324 | else of (spdDetail.ActiveSheetIndex == 4) ▸ if (spdDetail.ActiveSheetIndex == 5) | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtShipmentResult) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-97c942bb | this.btnSearch.Click | SSP0060_ShipmentPlan.cs:7325 | else of (spdDetail.ActiveSheetIndex == 4) ▸ if (spdDetail.ActiveSheetIndex == 5) | GRID_INIT | siDetail.ChangeActiveSheet | (SpdSheet.shtShipmentResult) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SSP0060_ShipmentPlan.CalcPlanQty

진입점: this.spdMain.KeyUp [if (e.KeyCode == Keys.Delete) ▸ if (ranges != null) ▸ for (x < 1) ▸ try ▸ if (rowstart >= 0 && rowend >= 0 && colstart >= 0 && colend >= 0) ▸ for (i <= rowend) ▸ for (j <= colend)] / this.spdMain.Change / this.spdMain.ClipboardPasted [try ▸ for (iRow < e.CellRange.Row + e.CellRange.RowCount) ▸ if (measure.Equals("SHIP_PLAN_DETAIL") && toSite != string.Empty) ▸ for (iCol < e.CellRange.Column + e.CellRange.ColumnCount)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5d18bb88 | this.spdMain.KeyUp [if (e.KeyCode == Keys.Delete) ▸ if (rang… 외 2 | SSP0060_ShipmentPlan.cs:6802 | if (dsMain == null \|\| dsMain.Tables[0].Rows.Count == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9c949f3e | this.spdMain.KeyUp [if (e.KeyCode == Keys.Delete) ▸ if (rang… 외 2 | SSP0060_ShipmentPlan.cs:6852 |  | DATA_OP | dRow.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-6570049b | this.spdMain.KeyUp [if (e.KeyCode == Keys.Delete) ▸ if (rang… 외 2 | SSP0060_ShipmentPlan.cs:6853 |  | DATA_OP | dRow.Field | ("FROM_SITE") | 데이터 객체 조작/조회 |  |  |  |
| AC-a50c78d3 | this.spdMain.KeyUp [if (e.KeyCode == Keys.Delete) ▸ if (rang… 외 2 | SSP0060_ShipmentPlan.cs:6854 |  | DATA_OP | dRow.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-6954fd79 | this.spdMain.KeyUp [if (e.KeyCode == Keys.Delete) ▸ if (rang… 외 2 | SSP0060_ShipmentPlan.cs:6855 |  | DATA_OP | dRow.Field | ("BOH_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-5e7ab927 | this.spdMain.KeyUp [if (e.KeyCode == Keys.Delete) ▸ if (rang… 외 2 | SSP0060_ShipmentPlan.cs:6860 | if (dr != null) | CALL_EXT | CommonUtils.GetValueDecimal | (dr["BOH_QTY"]) | ⚠ 의미 확인 필요 |  |  |  |
| AC-7fbf5d56 | this.spdMain.KeyUp [if (e.KeyCode == Keys.Delete) ▸ if (rang… 외 2 | SSP0060_ShipmentPlan.cs:6864 |  | DATA_OP | dRow.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-616b347e | this.spdMain.KeyUp [if (e.KeyCode == Keys.Delete) ▸ if (rang… 외 2 | SSP0060_ShipmentPlan.cs:6865 |  | DATA_OP | dRow.Field | ("FROM_SITE") | 데이터 객체 조작/조회 |  |  |  |
| AC-b78b9a5e | this.spdMain.KeyUp [if (e.KeyCode == Keys.Delete) ▸ if (rang… 외 2 | SSP0060_ShipmentPlan.cs:6866 |  | DATA_OP | dRow.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-46f28773 | this.spdMain.KeyUp [if (e.KeyCode == Keys.Delete) ▸ if (rang… 외 2 | SSP0060_ShipmentPlan.cs:6867 |  | DATA_OP | dRow.Field | ("MEASURE") | 데이터 객체 조작/조회 |  |  |  |
| AC-47ef423d | this.spdMain.KeyUp [if (e.KeyCode == Keys.Delete) ▸ if (rang… 외 2 | SSP0060_ShipmentPlan.cs:6872 | if (dr != null) | CALL_EXT | CommonUtils.GetValueDecimal | (dr[curColName]) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a685c69b | this.spdMain.KeyUp [if (e.KeyCode == Keys.Delete) ▸ if (rang… 외 2 | SSP0060_ShipmentPlan.cs:6919 | for (iCol < siMain.GetMaxColumnIndex()) ▸ for (iRow < siMain.ActiveSheet.RowCount) ▸ if (curDivisionId == divisionId && curFromSite == fromS… | CALL_EXT | CommonUtils.GetValueDecimal | (siMain.GetValue(iRow, iCol)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9ae01b31 | this.spdMain.KeyUp [if (e.KeyCode == Keys.Delete) ▸ if (rang… 외 2 | SSP0060_ShipmentPlan.cs:6922 | for (iCol < siMain.GetMaxColumnIndex()) ▸ for (iRow < siMain.ActiveSheet.RowCount) ▸ if (curDivisionId == divisionId && curFromSite == fromS… | CALL_EXT | CommonUtils.GetValueDecimal | (siMain.GetValue(iRow, siMain.GetColumnIndex(sBefCol))) | ⚠ 의미 확인 필요 |  |  |  |
| AC-4bbb8ba9 | this.spdMain.KeyUp [if (e.KeyCode == Keys.Delete) ▸ if (rang… 외 2 | SSP0060_ShipmentPlan.cs:6927 | for (iCol < siMain.GetMaxColumnIndex()) ▸ for (iRow < siMain.ActiveSheet.RowCount) ▸ if (curDivisionId == divisionId && curFromSite == fromS… | CALL_EXT | CommonUtils.GetValueDecimal | (siMain.GetValue(iRow, iCol)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-5bf794e2 | this.spdMain.KeyUp [if (e.KeyCode == Keys.Delete) ▸ if (rang… 외 2 | SSP0060_ShipmentPlan.cs:6930 | for (iCol < siMain.GetMaxColumnIndex()) ▸ for (iRow < siMain.ActiveSheet.RowCount) ▸ if (curDivisionId == divisionId && curFromSite == fromS… | CALL_EXT | CommonUtils.GetValueDecimal | (siMain.GetValue(iRow, siMain.GetColumnIndex(sBefCol))) | ⚠ 의미 확인 필요 |  |  |  |
| AC-cfaca71b | this.spdMain.KeyUp [if (e.KeyCode == Keys.Delete) ▸ if (rang… 외 2 | SSP0060_ShipmentPlan.cs:6935 | for (iCol < siMain.GetMaxColumnIndex()) ▸ for (iRow < siMain.ActiveSheet.RowCount) ▸ if (curDivisionId == divisionId && curFromSite == fromS… | CALL_EXT | CommonUtils.GetValueDecimal | (siMain.GetValue(iRow, iCol)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-486493d6 | this.spdMain.KeyUp [if (e.KeyCode == Keys.Delete) ▸ if (rang… 외 2 | SSP0060_ShipmentPlan.cs:6941 | for (iCol < siMain.GetMaxColumnIndex()) ▸ for (iRow < siMain.ActiveSheet.RowCount) ▸ if (curDivisionId == divisionId && curFromSite == fromS… | CALL_EXT | CommonUtils.GetValueDecimal | (siMain.GetValue(iRow, siMain.GetColumnIndex(sBefCol))) | ⚠ 의미 확인 필요 |  |  |  |
| AC-113a13a2 | this.spdMain.KeyUp [if (e.KeyCode == Keys.Delete) ▸ if (rang… 외 2 | SSP0060_ShipmentPlan.cs:6946 | for (iCol < siMain.GetMaxColumnIndex()) ▸ for (iRow < siMain.ActiveSheet.RowCount) ▸ if (curDivisionId == divisionId && curFromSite == fromS… | CALL_EXT | CommonUtils.GetValueDecimal | (siMain.GetValue(iRow, iCol)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-4e7c9c96 | this.spdMain.KeyUp [if (e.KeyCode == Keys.Delete) ▸ if (rang… 외 2 | SSP0060_ShipmentPlan.cs:6949 | for (iCol < siMain.GetMaxColumnIndex()) ▸ for (iRow < siMain.ActiveSheet.RowCount) ▸ if (curDivisionId == divisionId && curFromSite == fromS… | CALL_EXT | CommonUtils.GetValueDecimal | (siMain.GetValue(iRow, siMain.GetColumnIndex(sBefCol))) | ⚠ 의미 확인 필요 |  |  |  |
| AC-1fbf67bc | this.spdMain.KeyUp [if (e.KeyCode == Keys.Delete) ▸ if (rang… 외 2 | SSP0060_ShipmentPlan.cs:6952 | for (iCol < siMain.GetMaxColumnIndex()) ▸ for (iRow < siMain.ActiveSheet.RowCount) ▸ if (curDivisionId == divisionId && curFromSite == fromS… | CALL_EXT | CommonUtils.GetValueDecimal | (siMain.GetValue(iRow, iCol)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-4bcac012 | this.spdMain.KeyUp [if (e.KeyCode == Keys.Delete) ▸ if (rang… 외 2 | SSP0060_ShipmentPlan.cs:6953 | for (iCol < siMain.GetMaxColumnIndex()) ▸ for (iRow < siMain.ActiveSheet.RowCount) ▸ if (curDivisionId == divisionId && curFromSite == fromS… | CALL_EXT | CommonUtils.GetValueDecimal | (siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.LOT_YN))) | ⚠ 의미 확인 필요 |  |  |  |
| AC-8e5738f4 | this.spdMain.KeyUp [if (e.KeyCode == Keys.Delete) ▸ if (rang… 외 2 | SSP0060_ShipmentPlan.cs:6961 | for (iCol < siMain.GetMaxColumnIndex()) ▸ for (iRow < siMain.ActiveSheet.RowCount) ▸ if (curDivisionId == divisionId && curFromSite == fromS… | CALL_EXT | CommonUtils.GetValueDecimal | (siMain.GetValue(iRow, siMain.GetColumnIndex(sBefCol))) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ba1cbfe5 | this.spdMain.KeyUp [if (e.KeyCode == Keys.Delete) ▸ if (rang… 외 2 | SSP0060_ShipmentPlan.cs:6991 | for (iCol < siMain.GetMaxColumnIndex()) ▸ for (iRow < siMain.ActiveSheet.RowCount) ▸ if (curDivisionId == divisionId && curFromSite == fromS… | GRID_SET | siMain.ActiveSheet.SetValue | (iRow, iCol, dShipPlan) | 그리드 값 설정 |  |  |  |
| AC-02219d2e | this.spdMain.KeyUp [if (e.KeyCode == Keys.Delete) ▸ if (rang… 외 2 | SSP0060_ShipmentPlan.cs:6995 | for (iCol < siMain.GetMaxColumnIndex()) ▸ for (iRow < siMain.ActiveSheet.RowCount) ▸ if (curDivisionId == divisionId && curFromSite == fromS… | GRID_SET | siMain.ActiveSheet.SetValue | (iRow, iCol, dBefShipAvalGap + (dShipAval - dShipPlan)) | 그리드 값 설정 |  |  |  |
| AC-9cf6d2a7 | this.spdMain.KeyUp [if (e.KeyCode == Keys.Delete) ▸ if (rang… 외 2 | SSP0060_ShipmentPlan.cs:7001 | for (iCol < siMain.GetMaxColumnIndex()) ▸ for (iRow < siMain.ActiveSheet.RowCount) ▸ if (curDivisionId == divisionId && curFromSite == fromS… | GRID_SET | siMain.ActiveSheet.SetValue | (iRow, iCol, 0) | 그리드 값 설정 |  |  |  |
| AC-d892fd4b | this.spdMain.KeyUp [if (e.KeyCode == Keys.Delete) ▸ if (rang… 외 2 | SSP0060_ShipmentPlan.cs:7005 | for (iCol < siMain.GetMaxColumnIndex()) ▸ for (iRow < siMain.ActiveSheet.RowCount) ▸ if (curDivisionId == divisionId && curFromSite == fromS… | GRID_SET | siMain.ActiveSheet.SetValue | (iRow, iCol, Math.Ceiling(dContainer)) | 그리드 값 설정 |  |  |  |
| AC-a1a377db | this.spdMain.KeyUp [if (e.KeyCode == Keys.Delete) ▸ if (rang… 외 2 | SSP0060_ShipmentPlan.cs:7012 | for (iCol < siMain.GetMaxColumnIndex()) ▸ for (iRow < siMain.ActiveSheet.RowCount) ▸ if (curDivisionId == divisionId && curFromSite == fromS… | GRID_SET | siMain.ActiveSheet.SetValue | (iRow, iCol, dBefWhStock + dBefProdPlan - dBefIntnMovement - dBefShipPlan) | 그리드 값 설정 |  |  |  |
| AC-b38d9e35 | this.spdMain.KeyUp [if (e.KeyCode == Keys.Delete) ▸ if (rang… 외 2 | SSP0060_ShipmentPlan.cs:7017 | for (iCol < siMain.GetMaxColumnIndex()) ▸ for (iRow < siMain.ActiveSheet.RowCount) ▸ if (curDivisionId == divisionId && curFromSite == fromS… | GRID_SET | siMain.ActiveSheet.SetValue | (iRow, iCol, (dBefWhStock + dBefProdPlan - dBefIntnMovement - dBefShipPlan) - dShipPlan) | 그리드 값 설정 |  |  |  |
| AC-6211833f | this.spdMain.KeyUp [if (e.KeyCode == Keys.Delete) ▸ if (rang… 외 2 | SSP0060_ShipmentPlan.cs:7026 | for (iCol < siMain.GetMaxColumnIndex()) ▸ for (iRow < siMain.ActiveSheet.RowCount) ▸ if (curDivisionId == divisionId && curFromSite == fromS… | CALL_EXT | CommonUtils.GetValueDecimal | (siMain.GetValue(iRow, iCol)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-72c69d55 | this.spdMain.KeyUp [if (e.KeyCode == Keys.Delete) ▸ if (rang… 외 2 | SSP0060_ShipmentPlan.cs:7028 | for (iCol < siMain.GetMaxColumnIndex()) ▸ for (iRow < siMain.ActiveSheet.RowCount) ▸ if (curDivisionId == divisionId && curFromSite == fromS… | CALL_EXT | CommonUtils.GetValueDecimal | (siMain.GetValue(iRow, iCol)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-1edc3354 | this.spdMain.KeyUp [if (e.KeyCode == Keys.Delete) ▸ if (rang… 외 2 | SSP0060_ShipmentPlan.cs:7030 | for (iCol < siMain.GetMaxColumnIndex()) ▸ for (iRow < siMain.ActiveSheet.RowCount) ▸ if (curDivisionId == divisionId && curFromSite == fromS… | CALL_EXT | CommonUtils.GetValueDecimal | (siMain.GetValue(iRow, iCol)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-88dfcc74 | this.spdMain.KeyUp [if (e.KeyCode == Keys.Delete) ▸ if (rang… 외 2 | SSP0060_ShipmentPlan.cs:7032 | for (iCol < siMain.GetMaxColumnIndex()) ▸ for (iRow < siMain.ActiveSheet.RowCount) ▸ if (curDivisionId == divisionId && curFromSite == fromS… | CALL_EXT | CommonUtils.GetValueDecimal | (siMain.GetValue(iRow, iCol)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-724712cc | this.spdMain.KeyUp [if (e.KeyCode == Keys.Delete) ▸ if (rang… 외 2 | SSP0060_ShipmentPlan.cs:7033 | for (iCol < siMain.GetMaxColumnIndex()) ▸ for (iRow < siMain.ActiveSheet.RowCount) ▸ if (curDivisionId == divisionId && curFromSite == fromS… | CALL_EXT | CommonUtils.GetValueDecimal | (siMain.GetValue(iRow, iCol)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-5810b80d | this.spdMain.KeyUp [if (e.KeyCode == Keys.Delete) ▸ if (rang… 외 2 | SSP0060_ShipmentPlan.cs:7036 | for (iCol < siMain.GetMaxColumnIndex()) ▸ for (iRow < siMain.ActiveSheet.RowCount) ▸ if (curDivisionId == divisionId && curFromSite == fromS… | GRID_SET | siMain.ActiveSheet.SetValue | (iRow, iCol, dTotShipPlan) | 그리드 값 설정 |  |  |  |
| AC-de896be3 | this.spdMain.KeyUp [if (e.KeyCode == Keys.Delete) ▸ if (rang… 외 2 | SSP0060_ShipmentPlan.cs:7038 | for (iCol < siMain.GetMaxColumnIndex()) ▸ for (iRow < siMain.ActiveSheet.RowCount) ▸ if (curDivisionId == divisionId && curFromSite == fromS… | GRID_SET | siMain.ActiveSheet.SetValue | (iRow, iCol, dTotShipAvalGap) | 그리드 값 설정 |  |  |  |
| AC-84f5b63d | this.spdMain.KeyUp [if (e.KeyCode == Keys.Delete) ▸ if (rang… 외 2 | SSP0060_ShipmentPlan.cs:7040 | for (iCol < siMain.GetMaxColumnIndex()) ▸ for (iRow < siMain.ActiveSheet.RowCount) ▸ if (curDivisionId == divisionId && curFromSite == fromS… | GRID_SET | siMain.ActiveSheet.SetValue | (iRow, iCol, dTotContainer) | 그리드 값 설정 |  |  |  |
| AC-1ddf9a82 | this.spdMain.KeyUp [if (e.KeyCode == Keys.Delete) ▸ if (rang… 외 2 | SSP0060_ShipmentPlan.cs:7042 | for (iCol < siMain.GetMaxColumnIndex()) ▸ for (iRow < siMain.ActiveSheet.RowCount) ▸ if (curDivisionId == divisionId && curFromSite == fromS… | GRID_SET | siMain.ActiveSheet.SetValue | (iRow, iCol, dTotWhStock) | 그리드 값 설정 |  |  |  |
| AC-730d7d5a | this.spdMain.KeyUp [if (e.KeyCode == Keys.Delete) ▸ if (rang… 외 2 | SSP0060_ShipmentPlan.cs:7043 | for (iCol < siMain.GetMaxColumnIndex()) ▸ for (iRow < siMain.ActiveSheet.RowCount) ▸ if (curDivisionId == divisionId && curFromSite == fromS… | GRID_SET | siMain.ActiveSheet.SetValue | (iRow, iCol, dTotBalance) | 그리드 값 설정 |  |  |  |
| AC-9a838be5 | this.spdMain.KeyUp [if (e.KeyCode == Keys.Delete) ▸ if (rang… 외 2 | SSP0060_ShipmentPlan.cs:7052 |  | DATA_OP | dsMain.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |

## SSP0060_ShipmentPlan.CalculateSum

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f1fadde1 | (진입점 미연결) | SSP0060_ShipmentPlan.cs:6588 | for (nCol < dt.Columns.Count) ▸ if (dt.Columns[nCol].ColumnName.IndexOf("M_") == 0) | DATA_OP | listMonth.Add | (nCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-96e65907 | (진입점 미연결) | SSP0060_ShipmentPlan.cs:6592 | for (nCol < dt.Columns.Count) ▸ if (dt.Columns[nCol].ColumnName.IndexOf("W_") == 0) | DATA_OP | listWeek.Add | (nCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-fe202db4 | (진입점 미연결) | SSP0060_ShipmentPlan.cs:6613 | for (nCol < dt.Columns.Count) ▸ if (dt.Columns[nCol].ColumnName.IndexOf("D_") == 0) ▸ try | CALL_EXT | CommonUtils.GetValueDecimal | (strVal) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c4feb7ea | (진입점 미연결) | SSP0060_ShipmentPlan.cs:6614 | for (nCol < dt.Columns.Count) ▸ if (dt.Columns[nCol].ColumnName.IndexOf("D_") == 0) ▸ try | CALL_EXT | CommonUtils.GetValueDecimal | (strVal) | ⚠ 의미 확인 필요 |  |  |  |
| AC-0b31f086 | (진입점 미연결) | SSP0060_ShipmentPlan.cs:6636 | for (nCol < dt.Columns.Count) ▸ if (nCol == dt.Columns.Count - 1 \|\| dt.Columns[nCol].ColumnName.IndexOf("W_") == 0) ▸ if (strMeasure == "F… | DATA_OP | dr[nIdxWeek] | weekSum / nCntDayOfWeek | 행/컬럼 값 대입 |  |  |  |
| AC-912e482d | (진입점 미연결) | SSP0060_ShipmentPlan.cs:6640 | for (nCol < dt.Columns.Count) ▸ if (nCol == dt.Columns.Count - 1 \|\| dt.Columns[nCol].ColumnName.IndexOf("W_") == 0) ▸ else of (strMeasure … | DATA_OP | dr[nIdxWeek] | weekSum | 행/컬럼 값 대입 |  |  |  |
| AC-cc751bd2 | (진입점 미연결) | SSP0060_ShipmentPlan.cs:6654 | for (nCol < dt.Columns.Count) ▸ if (nCol == dt.Columns.Count - 1 \|\| dt.Columns[nCol].ColumnName.IndexOf("M_") == 0) ▸ if (strMeasure == "F… | DATA_OP | dr[nIdxMonth] | monthSum / nCntDayOfMonth | 행/컬럼 값 대입 |  |  |  |
| AC-9086ab2e | (진입점 미연결) | SSP0060_ShipmentPlan.cs:6658 | for (nCol < dt.Columns.Count) ▸ if (nCol == dt.Columns.Count - 1 \|\| dt.Columns[nCol].ColumnName.IndexOf("M_") == 0) ▸ else of (strMeasure … | DATA_OP | dr[nIdxMonth] | monthSum | 행/컬럼 값 대입 |  |  |  |
| AC-cef9b539 | (진입점 미연결) | SSP0060_ShipmentPlan.cs:6667 |  | DATA_OP | dt.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-fa83d21a | (진입점 미연결) | SSP0060_ShipmentPlan.cs:6684 | for (nCol < dt.Columns.Count) ▸ if (dt.Columns[nCol].ColumnName.IndexOf("M_") == 0) | DATA_OP | listMonth.Add | (nCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-349ee73b | (진입점 미연결) | SSP0060_ShipmentPlan.cs:6688 | for (nCol < dt.Columns.Count) ▸ if (dt.Columns[nCol].ColumnName.IndexOf("W_") == 0) | DATA_OP | listWeek.Add | (nCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-90fcc7f4 | (진입점 미연결) | SSP0060_ShipmentPlan.cs:6728 | for (nRow < dt.Rows.Count) ▸ for (nCol < dt.Columns.Count) ▸ if (dt.Columns[nCol].ColumnName.IndexOf("D_") == 0) ▸ if (!string.IsNullOrEmpty… | CALL_EXT | CommonUtils.GetValueDecimal | (dr[nCol]) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b7bc021c | (진입점 미연결) | SSP0060_ShipmentPlan.cs:6730 | for (nRow < dt.Rows.Count) ▸ for (nCol < dt.Columns.Count) ▸ if (dt.Columns[nCol].ColumnName.IndexOf("D_") == 0) ▸ if (!string.IsNullOrEmpty… | CALL_EXT | CommonUtils.GetValueDecimal | (dr[nCol]) | ⚠ 의미 확인 필요 |  |  |  |
| AC-82c49948 | (진입점 미연결) | SSP0060_ShipmentPlan.cs:6732 | for (nRow < dt.Rows.Count) ▸ for (nCol < dt.Columns.Count) ▸ if (dt.Columns[nCol].ColumnName.IndexOf("D_") == 0) ▸ if (!string.IsNullOrEmpty… | CALL_EXT | CommonUtils.GetValueDecimal | (dr[nCol]) | ⚠ 의미 확인 필요 |  |  |  |
| AC-82fc004a | (진입점 미연결) | SSP0060_ShipmentPlan.cs:6734 | for (nRow < dt.Rows.Count) ▸ for (nCol < dt.Columns.Count) ▸ if (dt.Columns[nCol].ColumnName.IndexOf("D_") == 0) ▸ if (!string.IsNullOrEmpty… | CALL_EXT | CommonUtils.GetValueDecimal | (dr[nCol]) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ca16c206 | (진입점 미연결) | SSP0060_ShipmentPlan.cs:6746 | for (nRow < dt.Rows.Count) ▸ for (nCol < dt.Columns.Count) ▸ if (dt.Columns[nCol].ColumnName.IndexOf("D_") == 0) ▸ if (!string.IsNullOrEmpty… | CALL_EXT | CommonUtils.GetValueDecimal | (dr[nCol]) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c70fb46c | (진입점 미연결) | SSP0060_ShipmentPlan.cs:6747 | for (nRow < dt.Rows.Count) ▸ for (nCol < dt.Columns.Count) ▸ if (dt.Columns[nCol].ColumnName.IndexOf("D_") == 0) ▸ if (!string.IsNullOrEmpty… | CALL_EXT | CommonUtils.GetValueDecimal | (dr[nCol]) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d2adc70b | (진입점 미연결) | SSP0060_ShipmentPlan.cs:6767 | for (nRow < dt.Rows.Count) ▸ for (nCol < dt.Columns.Count) ▸ if (nCol == dt.Columns.Count - 1 \|\| dt.Columns[nCol].ColumnName.IndexOf("W_")… | DATA_OP | dr[nIdxWeek] | weekSum | 행/컬럼 값 대입 |  |  |  |
| AC-547a334f | (진입점 미연결) | SSP0060_ShipmentPlan.cs:6782 | for (nRow < dt.Rows.Count) ▸ for (nCol < dt.Columns.Count) ▸ if (nCol == dt.Columns.Count - 1 \|\| dt.Columns[nCol].ColumnName.IndexOf("M_")… | DATA_OP | dr[nIdxMonth] | monthSum | 행/컬럼 값 대입 |  |  |  |
| AC-eb7de73e | (진입점 미연결) | SSP0060_ShipmentPlan.cs:6790 |  | DATA_OP | dt.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |

## SSP0060_ShipmentPlan.cboPlanDate_SelectedIndexChanged

진입점: cboPlanDate.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a0b6c27b | cboPlanDate.SelectedIndexChanged | SSP0060_ShipmentPlan.cs:7236 | if (cboPlanDate.ControlValues != null) | DATA_OP | dtPlanDate.Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-0eea3e3e | cboPlanDate.SelectedIndexChanged | SSP0060_ShipmentPlan.cs:7236 | if (cboPlanDate.ControlValues != null) ▸ lambda | DATA_OP | row.Field | ("CODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-3b049956 | cboPlanDate.SelectedIndexChanged | SSP0060_ShipmentPlan.cs:7240 | if (cboPlanDate.ControlValues != null) ▸ if (dr.ItemArray.Count() > 0) | UI_PROP | drpPeriod.Value1 | Convert.ToDateTime(dr["FROM_DATE"].ToString()) | 속성 Value1 설정 |  |  |  |
| AC-33e2220c | cboPlanDate.SelectedIndexChanged | SSP0060_ShipmentPlan.cs:7241 | if (cboPlanDate.ControlValues != null) ▸ if (dr.ItemArray.Count() > 0) | UI_PROP | drpPeriod.Value2 | Convert.ToDateTime(dr["TO_DATE1"].ToString()) | 속성 Value2 설정 |  |  |  |
| AC-9d65592c | cboPlanDate.SelectedIndexChanged | SSP0060_ShipmentPlan.cs:7242 | if (cboPlanDate.ControlValues != null) ▸ if (dr.ItemArray.Count() > 0) | UI_PROP | drpPeriod2.Value1 | Convert.ToDateTime(dr["FROM_DATE"].ToString()) | 속성 Value1 설정 |  |  |  |
| AC-5e97cfb1 | cboPlanDate.SelectedIndexChanged | SSP0060_ShipmentPlan.cs:7243 | if (cboPlanDate.ControlValues != null) ▸ if (dr.ItemArray.Count() > 0) | UI_PROP | drpPeriod2.Value2 | Convert.ToDateTime(dr["TO_DATE1"].ToString()) | 속성 Value2 설정 |  |  |  |
| AC-78658a0e | cboPlanDate.SelectedIndexChanged | SSP0060_ShipmentPlan.cs:7251 | if (cboPlanDate.ControlValues != null) ▸ if (dr.ItemArray.Count() > 0) ▸ if (!string.IsNullOrWhiteSpace(drpPeriod.Text1) && !string.IsNullOr… | VALUE_CLEAR | txtItemId.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-eac3ec6b | cboPlanDate.SelectedIndexChanged | SSP0060_ShipmentPlan.cs:7252 | if (cboPlanDate.ControlValues != null) ▸ if (dr.ItemArray.Count() > 0) ▸ if (!string.IsNullOrWhiteSpace(drpPeriod.Text1) && !string.IsNullOr… | VALUE_CLEAR | txtModel2.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-53254c92 | cboPlanDate.SelectedIndexChanged | SSP0060_ShipmentPlan.cs:7253 | if (cboPlanDate.ControlValues != null) ▸ if (dr.ItemArray.Count() > 0) ▸ if (!string.IsNullOrWhiteSpace(drpPeriod.Text1) && !string.IsNullOr… | VALUE_CLEAR | txtRequestor.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-7758f60b | cboPlanDate.SelectedIndexChanged | SSP0060_ShipmentPlan.cs:7263 | if (cboPlanDate.ControlValues != null) ▸ if (dr.ItemArray.Count() > 0) ▸ if (cboPlanDate.SelectedIndex == 0) | FLAG | bRealFlag | true | 화면 필드/플래그 변경 |  |  |  |
| AC-f8d9e880 | cboPlanDate.SelectedIndexChanged | SSP0060_ShipmentPlan.cs:7267 | if (cboPlanDate.ControlValues != null) ▸ if (dr.ItemArray.Count() > 0) ▸ else of (cboPlanDate.SelectedIndex == 0) | FLAG | bRealFlag | false | 화면 필드/플래그 변경 |  |  |  |

## SSP0060_ShipmentPlan.checkValidN

진입점: SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtHoldStock)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3a16e398 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:3543 | for (i <= siDetail.GetMaxRowIndex()) ▸ if (intORG_FROM_YYYYMMDD > intORG_TO_YYYYMMDD) | CALL_EXT | siMain.DisplayedSheet.GetViewRowFromModelRow | (i) | ⚠ 의미 확인 필요 |  |  |  |
| AC-6b2262a9 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:3553 | if (!isPass) | MESSAGE | MessageHelper.GMessageBox | ("MSG00219", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-4903108b | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:3556 |  | RETURN | return isPass; |  | 처리 중단/반환 |  |  |  |

## SSP0060_ShipmentPlan.ChkConfirmChangeTime

진입점: SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPIFBlockYn()) ▸ try ▸ try ▸ if (!string.IsNullOrEmpty(p_confirm_id))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e45796ce | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:7962 |  | ENDPOINT | new FoxDataRequest | ("SSP.SCM_SSP_CHECK_CONFIRM_CHANGETIME") ⇒ SSP.SCM_SSP_CHECK_CONFIRM_CHANGETIME | 엔드포인트 요청 생성 |  |  |  |
| AC-59803f5f | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:7966 |  | DATA_OP | request.Parameters["p_confirm_id"] | p_confirm_id | 행/컬럼 값 대입 |  |  |  |
| AC-7838d6b7 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:7968 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-f18825fd | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:7973 | if (ds.Tables[0].Rows[0][0].ToString() == "S") | RETURN | return result = true; |  | 처리 중단/반환 |  |  |  |
| AC-7ed3c064 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:7977 | else of (ds.Tables[0].Rows[0][0].ToString() == "S") ▸ if (ds.Tables[0].Rows[0][0].ToString() == "X") | RETURN | return result = false; |  | 처리 중단/반환 |  |  |  |
| AC-b256d912 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:7979 |  | RETURN | return result; |  | 처리 중단/반환 |  |  |  |

## SSP0060_ShipmentPlan.chkERPIFBlockYn

진입점: SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e89c6dd0 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:3565 |  | FLAG | dtERPBlockYnIF | Data_SCP.Common(Data_SCP.Type.SSPBlockCheckIF, false, "SSP0060") | 화면 필드/플래그 변경 |  |  |  |
| AC-d1f15e74 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:3565 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.SSPBlockCheckIF, false, "SSP0060") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-25d336b0 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:3568 | if (null != dtERPBlockYnIF && dtERPBlockYnIF.Rows.Count > 0) | DATA_OP | dtERPBlockYnIF.Rows[0].Field | ("BLOCK_YN") | 데이터 객체 조작/조회 |  |  |  |
| AC-bb5f9571 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:3577 | if (null != dtERPBlockYnIF && dtERPBlockYnIF.Rows.Count > 0) ▸ if (blockYn == "Y") | DATA_OP | dtERPBlockYnIF.Rows[0].Field | ("PERIOD") | 데이터 객체 조작/조회 |  |  |  |
| AC-331f4fb0 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:3578 | if (null != dtERPBlockYnIF && dtERPBlockYnIF.Rows.Count > 0) ▸ if (blockYn == "Y") | MESSAGE | MessageHelper.GMessageBox | ("MSG00267", new object[] { arg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-957aa47f | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:3582 |  | RETURN | return resultYn; |  | 처리 중단/반환 |  |  |  |

## SSP0060_ShipmentPlan.clbCompanyID_SelectedIndexChanged

진입점: clbCompany_ID.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-66d6a9c1 | clbCompany_ID.SelectedIndexChanged | SSP0060_ShipmentPlan.cs:7180 |  | FLAG | dtFromSite | Data_SCP.Common(Data_SCP.Type.Com_FromSite, false, strSelDivision_ID, strSelCompany_ID) | 화면 필드/플래그 변경 |  |  |  |
| AC-68974740 | clbCompany_ID.SelectedIndexChanged | SSP0060_ShipmentPlan.cs:7180 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.Com_FromSite, false, strSelDivision_ID, strSelCompany_ID) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-45bf14b2 | clbCompany_ID.SelectedIndexChanged | SSP0060_ShipmentPlan.cs:7181 |  | LIST_REBIND | clsCtrl.setListBox | (dtFromSite, clbPlantSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-a34a3779 | clbCompany_ID.SelectedIndexChanged | SSP0060_ShipmentPlan.cs:7185 |  | FLAG | dtToSite | Data_SCP.Common(Data_SCP.Type.ShipmentPlanToSite, false, strSelDivision_ID, UserInfoContex… | 화면 필드/플래그 변경 |  |  |  |
| AC-cb4e262b | clbCompany_ID.SelectedIndexChanged | SSP0060_ShipmentPlan.cs:7185 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.ShipmentPlanToSite, false, strSelDivision_ID, UserInfoContext.Current["NowG… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-a979a9c3 | clbCompany_ID.SelectedIndexChanged | SSP0060_ShipmentPlan.cs:7197 |  | FLAG | dtPlanDate | Data_SCP.Common(Data_SCP.Type.Plan_Infor, false, strSelCompany_ID) | 화면 필드/플래그 변경 |  |  |  |
| AC-1885a10b | clbCompany_ID.SelectedIndexChanged | SSP0060_ShipmentPlan.cs:7197 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.Plan_Infor, false, strSelCompany_ID) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-d58bf207 | clbCompany_ID.SelectedIndexChanged | SSP0060_ShipmentPlan.cs:7198 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanDate, cboPlanDate, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-2f1c2759 | clbCompany_ID.SelectedIndexChanged | SSP0060_ShipmentPlan.cs:7199 |  | VALUE_CLEAR | cboPlanDate.SelectedIndex | -1 | 컨트롤 값 비움 |  |  |  |
| AC-5be24557 | clbCompany_ID.SelectedIndexChanged | SSP0060_ShipmentPlan.cs:7203 |  | FLAG | dtProductLevel1 | Data_SCP.Common(Data_SCP.Type.CellGroup, false, strSelDivision_ID, null, null) | 화면 필드/플래그 변경 |  |  |  |
| AC-73c55059 | clbCompany_ID.SelectedIndexChanged | SSP0060_ShipmentPlan.cs:7203 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.CellGroup, false, strSelDivision_ID, null, null) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ea73be06 | clbCompany_ID.SelectedIndexChanged | SSP0060_ShipmentPlan.cs:7204 |  | DATA_OP | dtProductLevel1.Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-2d1b5688 | clbCompany_ID.SelectedIndexChanged | SSP0060_ShipmentPlan.cs:7207 | if (query.Count() != 0) | LIST_REBIND | clsCtrl.setListBox | (query.CopyToDataTable(), clbProductLevel11, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-ac393950 | clbCompany_ID.SelectedIndexChanged | SSP0060_ShipmentPlan.cs:7207 | if (query.Count() != 0) | DATA_OP | query.CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-c60fff07 | clbCompany_ID.SelectedIndexChanged | SSP0060_ShipmentPlan.cs:7208 | if (query.Count() != 0) | LIST_REBIND | clsCtrl.setListBox | (query.CopyToDataTable(), clbProductLevel12, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-99dc52ea | clbCompany_ID.SelectedIndexChanged | SSP0060_ShipmentPlan.cs:7208 | if (query.Count() != 0) | DATA_OP | query.CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-67d18bd0 | clbCompany_ID.SelectedIndexChanged | SSP0060_ShipmentPlan.cs:7218 |  | VALUE_CLEAR | txtItemId.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-9ab0298f | clbCompany_ID.SelectedIndexChanged | SSP0060_ShipmentPlan.cs:7219 |  | VALUE_CLEAR | txtModel2.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-6066ff5a | clbCompany_ID.SelectedIndexChanged | SSP0060_ShipmentPlan.cs:7220 |  | VALUE_CLEAR | txtRequestor.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-709f8a7c | clbCompany_ID.SelectedIndexChanged | SSP0060_ShipmentPlan.cs:7221 |  | UI_PROP | drpPeriod.Text1 | "" | 속성 Text1 설정 |  |  |  |
| AC-2ce6c166 | clbCompany_ID.SelectedIndexChanged | SSP0060_ShipmentPlan.cs:7222 |  | UI_PROP | drpPeriod.Text2 | "" | 속성 Text2 설정 |  |  |  |
| AC-0f22c59f | clbCompany_ID.SelectedIndexChanged | SSP0060_ShipmentPlan.cs:7223 |  | UI_PROP | drpPeriod2.Text1 | "" | 속성 Text1 설정 |  |  |  |
| AC-ab5cab8a | clbCompany_ID.SelectedIndexChanged | SSP0060_ShipmentPlan.cs:7224 |  | UI_PROP | drpPeriod2.Text2 | "" | 속성 Text2 설정 |  |  |  |
| AC-7d101ad0 | clbCompany_ID.SelectedIndexChanged | SSP0060_ShipmentPlan.cs:7228 | if (cboPlanDate.Items.Count > 0) | VALUE_SET | cboPlanDate.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |

## SSP0060_ShipmentPlan.clbDivision_ID_SelectedIndexChanged

진입점: clbDivision_ID.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b1ab9873 | clbDivision_ID.SelectedIndexChanged | SSP0060_ShipmentPlan.cs:7117 |  | DATA_OP | dtCompany.Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-beebc7d9 | clbDivision_ID.SelectedIndexChanged | SSP0060_ShipmentPlan.cs:7121 | if (query.Count() != 0) | DATA_OP | query.CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-47edf9a6 | clbDivision_ID.SelectedIndexChanged | SSP0060_ShipmentPlan.cs:7123 | if (query.Count() != 0) | LIST_REBIND | clsCtrl.setListBox | (dtDiv_Company_ID, clbCompany_ID, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-337fb2b9 | clbDivision_ID.SelectedIndexChanged | SSP0060_ShipmentPlan.cs:7129 | if (query.Count() != 0) ▸ if (!string.IsNullOrEmpty(sUserCompany_NM)) | FLAG | sUserCompany_NM | (tUserCompany_NM != sUserCompany_NM) ? tUserCompany_NM : sUserCompany_NM | 화면 필드/플래그 변경 |  |  |  |
| AC-30ef13ae | clbDivision_ID.SelectedIndexChanged | SSP0060_ShipmentPlan.cs:7131 | if (query.Count() != 0) ▸ if (!string.IsNullOrEmpty(sUserCompany_NM)) | CALL_EXT | clbCompany_ID.FindString | (sUserCompany_NM) | ⚠ 의미 확인 필요 |  |  |  |
| AC-1bd276b8 | clbDivision_ID.SelectedIndexChanged | SSP0060_ShipmentPlan.cs:7132 | if (query.Count() != 0) ▸ if (!string.IsNullOrEmpty(sUserCompany_NM)) | VALUE_SET | clbCompany_ID.SelectedIndex | intComIdx < 0 ? 0 : intComIdx | 컨트롤 값 설정 |  |  |  |
| AC-a4dd3d45 | clbDivision_ID.SelectedIndexChanged | SSP0060_ShipmentPlan.cs:7137 | else of (query.Count() != 0) | LIST_REBIND | clsCtrl.setListBox | (dtDiv_Company_ID, clbCompany_ID, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SSP0060_ShipmentPlan.ControlClear

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0970e148 | (진입점 미연결) | SSP0060_ShipmentPlan.cs:551 |  | CALL_EXT | clbCompany_ID.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-a932c9dd | (진입점 미연결) | SSP0060_ShipmentPlan.cs:552 |  | LIST_CLEAR | clbPlantSite.Items.Clear | () | 목록 항목 비움 |  |  |  |
| AC-d34eafa6 | (진입점 미연결) | SSP0060_ShipmentPlan.cs:553 |  | LIST_CLEAR | clbProductLevel11.Items.Clear | () | 목록 항목 비움 |  |  |  |
| AC-c75755d3 | (진입점 미연결) | SSP0060_ShipmentPlan.cs:556 |  | CALL_EXT | cboPlanDate.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-5868e617 | (진입점 미연결) | SSP0060_ShipmentPlan.cs:557 |  | UI_PROP | drpPeriod.Text1 | "" | 속성 Text1 설정 |  |  |  |
| AC-eabe5b4a | (진입점 미연결) | SSP0060_ShipmentPlan.cs:558 |  | UI_PROP | drpPeriod.Text2 | "" | 속성 Text2 설정 |  |  |  |
| AC-898eea56 | (진입점 미연결) | SSP0060_ShipmentPlan.cs:559 |  | UI_PROP | drpPeriod2.Text1 | "" | 속성 Text1 설정 |  |  |  |
| AC-4a600689 | (진입점 미연결) | SSP0060_ShipmentPlan.cs:560 |  | UI_PROP | drpPeriod2.Text2 | "" | 속성 Text2 설정 |  |  |  |

## SSP0060_ShipmentPlan.Convert_Requestor

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ade21d7b | (진입점 미연결) | SSP0060_ShipmentPlan.cs:6533 | if (string.IsNullOrWhiteSpace(this.txtRequestor.Text.Trim())) | RETURN | return strCVT_Requestor; |  | 처리 중단/반환 |  |  |  |
| AC-e845eae9 | (진입점 미연결) | SSP0060_ShipmentPlan.cs:6553 |  | RETURN | return strCVT_Requestor; |  | 처리 중단/반환 |  |  |  |

## SSP0060_ShipmentPlan.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7a2c06c7 | this.Load | SSP0060_ShipmentPlan.cs:566 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 3, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-aac245c8 | this.Load | SSP0060_ShipmentPlan.cs:567 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, 0) | 화면 필드/플래그 변경 |  |  |  |
| AC-32d6f609 | this.Load | SSP0060_ShipmentPlan.cs:570 |  | GRID_INIT | this.AddSheet | (spdDetail, SpdSheet.shtPlanDetail, SpdSheet.shtPlanDetail, 1, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-15bde18d | this.Load | SSP0060_ShipmentPlan.cs:571 |  | GRID_INIT | this.AddSheet | (spdDetail, SpdSheet.shtStockDetail, SpdSheet.shtStockDetail, 1, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-0e70bdd7 | this.Load | SSP0060_ShipmentPlan.cs:572 |  | GRID_INIT | this.AddSheet | (spdDetail, SpdSheet.shtoWMSDetail, SpdSheet.shtoWMSDetail, 1, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-8755c58d | this.Load | SSP0060_ShipmentPlan.cs:578 |  | GRID_INIT | this.AddSheet | (spdDetail, SpdSheet.shtMESStock, SpdSheet.shtMESStock, 1, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-acff6cd7 | this.Load | SSP0060_ShipmentPlan.cs:579 |  | GRID_INIT | this.AddSheet | (spdDetail, SpdSheet.shtMESStockDetail, SpdSheet.shtMESStockDetail, 1, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-addf4eed | this.Load | SSP0060_ShipmentPlan.cs:581 |  | GRID_INIT | this.AddSheet | (spdDetail, SpdSheet.shtShipmentResult, SpdSheet.shtShipmentResult, 1, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-ef74e34f | this.Load | SSP0060_ShipmentPlan.cs:583 |  | FLAG | siDetail | GetSheetInfo(spdDetail.Name, SpdSheet.shtPlanDetail) | 화면 필드/플래그 변경 |  |  |  |
| AC-ab152500 | this.Load | SSP0060_ShipmentPlan.cs:584 |  | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtPlanDetail) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9518596a | this.Load | SSP0060_ShipmentPlan.cs:587 |  | FLAG | siDetail | GetSheetInfo(spdDetail.Name, SpdSheet.shtStockDetail) | 화면 필드/플래그 변경 |  |  |  |
| AC-466e4b5e | this.Load | SSP0060_ShipmentPlan.cs:588 |  | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtStockDetail) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-beeffa57 | this.Load | SSP0060_ShipmentPlan.cs:591 |  | FLAG | siDetail | GetSheetInfo(spdDetail.Name, SpdSheet.shtoWMSDetail) | 화면 필드/플래그 변경 |  |  |  |
| AC-9e83664c | this.Load | SSP0060_ShipmentPlan.cs:592 |  | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtoWMSDetail) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c61cc59a | this.Load | SSP0060_ShipmentPlan.cs:604 |  | FLAG | siDetail | GetSheetInfo(spdDetail.Name, SpdSheet.shtMESStock) | 화면 필드/플래그 변경 |  |  |  |
| AC-6fdf5471 | this.Load | SSP0060_ShipmentPlan.cs:605 |  | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtMESStock) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d20cad13 | this.Load | SSP0060_ShipmentPlan.cs:608 |  | FLAG | siDetail | GetSheetInfo(spdDetail.Name, SpdSheet.shtMESStockDetail) | 화면 필드/플래그 변경 |  |  |  |
| AC-ff5a1e76 | this.Load | SSP0060_ShipmentPlan.cs:609 |  | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtMESStockDetail) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-946d4001 | this.Load | SSP0060_ShipmentPlan.cs:612 |  | FLAG | siDetail | GetSheetInfo(spdDetail.Name, SpdSheet.shtShipmentResult) | 화면 필드/플래그 변경 |  |  |  |
| AC-6f04eb09 | this.Load | SSP0060_ShipmentPlan.cs:613 |  | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtShipmentResult) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-fff38834 | this.Load | SSP0060_ShipmentPlan.cs:616 |  | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtPlanDetail) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4ff619d6 | this.Load | SSP0060_ShipmentPlan.cs:620 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SSP0060_ShipmentPlan.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-31857986 | this.Load | SSP0060_ShipmentPlan.cs:417 |  | UI_PROP | siMain.ImagePopUp | imageList1.Images[0] | 속성 ImagePopUp 설정 |  |  |  |
| AC-6ddaa934 | this.Load | SSP0060_ShipmentPlan.cs:419 |  | FLAG | cellTypeImage | new TextCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-4879f114 | this.Load | SSP0060_ShipmentPlan.cs:420 |  | UI_PROP | cellTypeImage.BackgroundImage | new FarPoint.Win.Picture(siMain.ImagePopUp) | 속성 BackgroundImage 설정 |  |  |  |
| AC-100423f2 | this.Load | SSP0060_ShipmentPlan.cs:421 |  | UI_PROP | cellTypeImage.BackgroundImage.AlignHorz | FarPoint.Win.HorizontalAlignment.Right | 속성 AlignHorz 설정 |  |  |  |
| AC-b5cefe14 | this.Load | SSP0060_ShipmentPlan.cs:423 |  | VALUE_SET | cboBucketType.ControlValues | BucketType.Daily | 컨트롤 값 설정 |  |  |  |

## SSP0060_ShipmentPlan.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-85bcfd65 | Dispose | SSP0060_ShipmentPlan.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SSP0060_ShipmentPlan.DrpPeriod2_ValueChanged

진입점: this.drpPeriod2.ValueChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-90caac52 | this.drpPeriod2.ValueChanged | SSP0060_ShipmentPlan.cs:2197 | if (intDiff1 > 0 \|\| intDiff2 > 0) | UI_PROP | drpPeriod2.Value1 | drpPeriod.Value1 | 속성 Value1 설정 |  |  |  |
| AC-4f8a9e77 | this.drpPeriod2.ValueChanged | SSP0060_ShipmentPlan.cs:2198 | if (intDiff1 > 0 \|\| intDiff2 > 0) | UI_PROP | drpPeriod2.Value2 | drpPeriod.Value2 | 속성 Value2 설정 |  |  |  |
| AC-e4c9eb4a | this.drpPeriod2.ValueChanged | SSP0060_ShipmentPlan.cs:2200 | if (intDiff1 > 0 \|\| intDiff2 > 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SSP0060_ShipmentPlan.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9689aee2 | EditButton | SSP0060_ShipmentPlan.cs:2720 | if (isOK == false) | MESSAGE | MessageHelper.GMessageBox | ("MSG00251", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-314a9ece | EditButton | SSP0060_ShipmentPlan.cs:2721 | if (isOK == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b1be2d59 | EditButton | SSP0060_ShipmentPlan.cs:2726 |  | DATA_OP | dtPlanDate.Compute | ("Max(code)", null) | 데이터 객체 조작/조회 |  |  |  |
| AC-fd6ef669 | EditButton | SSP0060_ShipmentPlan.cs:2732 | if (curPlanDate != newPlanDate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00170", new object[] { null }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c994d1d6 | EditButton | SSP0060_ShipmentPlan.cs:2733 | if (curPlanDate != newPlanDate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-315b3222 | EditButton | SSP0060_ShipmentPlan.cs:2738 | if (strEditSpread != string.Empty && strEditSpread != fps.Name) | MESSAGE | MessageHelper.GMessageBox | ("MSG00424", new object[] { null }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-56dae1d2 | EditButton | SSP0060_ShipmentPlan.cs:2739 | if (strEditSpread != string.Empty && strEditSpread != fps.Name) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8ae52e2b | EditButton | SSP0060_ShipmentPlan.cs:2745 | if (fps.Name == "spdMain") | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-05cc2f83 | EditButton | SSP0060_ShipmentPlan.cs:2746 | if (fps.Name == "spdMain") | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-24cd46a5 | EditButton | SSP0060_ShipmentPlan.cs:2763 | if (fps.Name == "spdMain") ▸ if (bEdit_Mode == false) ▸ if (siMain.Sheet(0).Rows.Count > 0) ▸ for (i < siMain.Sheet(0).Rows.Count) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.DIVISION_ID), siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-ccc754c1 | EditButton | SSP0060_ShipmentPlan.cs:2782 | if (fps.Name == "spdMain") ▸ if (bEdit_Mode == false) ▸ if (siMain.Sheet(0).Rows.Count > 0) ▸ for (i < siMain.Sheet(0).Rows.Count) ▸ if (sMe… | CALL_EXT | CString.IsNumber | (sEditYN) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e3758235 | EditButton | SSP0060_ShipmentPlan.cs:2785 | if (fps.Name == "spdMain") ▸ if (bEdit_Mode == false) ▸ if (siMain.Sheet(0).Rows.Count > 0) ▸ for (i < siMain.Sheet(0).Rows.Count) ▸ if (sMe… | GRID_LOCK | siMain.LockRange | (i, j, i, j, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-61e6551f | EditButton | SSP0060_ShipmentPlan.cs:2789 | if (fps.Name == "spdMain") ▸ if (bEdit_Mode == false) ▸ if (siMain.Sheet(0).Rows.Count > 0) ▸ for (i < siMain.Sheet(0).Rows.Count) ▸ if (sMe… | GRID_LOCK | siMain.LockRange | (i, j, i, j, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-640a1f7d | EditButton | SSP0060_ShipmentPlan.cs:2811 | if (fps.Name == "spdMain") ▸ if (bEdit_Mode == false) | FLAG | strEditSpread | fps.Name | 화면 필드/플래그 변경 |  |  |  |
| AC-56284735 | EditButton | SSP0060_ShipmentPlan.cs:2812 | if (fps.Name == "spdMain") ▸ if (bEdit_Mode == false) | FLAG | bEdit_Mode | true | 화면 필드/플래그 변경 |  |  |  |
| AC-26c542dd | EditButton | SSP0060_ShipmentPlan.cs:2827 | if (fps.Name == "spdMain") ▸ else of (bEdit_Mode == false) ▸ if (siMain.Sheet(0).Rows.Count > 0) ▸ for (i < siMain.Sheet(0).Rows.Count) ▸ if… | GRID_LOCK | siMain.LockRange | (i, j, i, j, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-2c5f32a0 | EditButton | SSP0060_ShipmentPlan.cs:2833 | if (fps.Name == "spdMain") ▸ else of (bEdit_Mode == false) | FLAG | strEditSpread | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-e188f8fe | EditButton | SSP0060_ShipmentPlan.cs:2834 | if (fps.Name == "spdMain") ▸ else of (bEdit_Mode == false) | FLAG | bEdit_Mode | false | 화면 필드/플래그 변경 |  |  |  |
| AC-aa7f1b49 | EditButton | SSP0060_ShipmentPlan.cs:2842 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdDetail") ▸ if (bRealFlag == false) | MESSAGE | MessageHelper.GMessageBox | ("MSG00312", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-acbc237a | EditButton | SSP0060_ShipmentPlan.cs:2843 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdDetail") ▸ if (bRealFlag == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1e581cef | EditButton | SSP0060_ShipmentPlan.cs:2847 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdDetail") | FLAG | siDetail | GetSheetInfo(spdDetail.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-9fdee03f | EditButton | SSP0060_ShipmentPlan.cs:2848 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdDetail") | GRID_LOCK | siDetail.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-e4fd1086 | EditButton | SSP0060_ShipmentPlan.cs:2862 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdDetail") ▸ if (bEdit_Mode == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.s… | GRID_LOCK | siDetail.LockColumn | (siDetail.GetColumnIndex(DefColumns.DIVISION_ID), siDetail.GetColumnIndex(DefColumns.FCST_… | 그리드 편집 잠금/해제 |  |  |  |
| AC-e83f126b | EditButton | SSP0060_ShipmentPlan.cs:2863 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdDetail") ▸ if (bEdit_Mode == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.s… | GRID_LOCK | siDetail.LockColumn | (siDetail.GetColumnIndex(DefColumns.MKT_OWNER), siDetail.GetColumnIndex(DefColumns.ORIGIN_… | 그리드 편집 잠금/해제 |  |  |  |
| AC-0a9aef3c | EditButton | SSP0060_ShipmentPlan.cs:2865 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdDetail") ▸ if (bEdit_Mode == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.s… | GRID_LOCK | siDetail.LockRange2 | (i, siDetail.GetColumnIndex(DefColumns.SHIPMENT_CONFIRM_QTY), i, siDetail.GetColumnIndex(D… | 그리드 편집 잠금 전환 |  |  |  |
| AC-e61d9b77 | EditButton | SSP0060_ShipmentPlan.cs:2870 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdDetail") ▸ if (bEdit_Mode == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.s… | GRID_LOCK | siDetail.LockRange2 | (i, 0, i, siDetail.GetMaxColumnIndex(), true, true) | 그리드 편집 잠금 전환 |  |  |  |
| AC-97d63e9b | EditButton | SSP0060_ShipmentPlan.cs:2876 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdDetail") ▸ if (bEdit_Mode == false) ▸ else of (siDetail.ActiveSheet.SheetName == SpdSh… | GRID_LOCK | siDetail.LockColumn | (siDetail.GetColumnIndex(DefColumns.DIVISION_ID), siDetail.GetColumnIndex(DefColumns.HOLD_… | 그리드 편집 잠금/해제 |  |  |  |
| AC-2cee522a | EditButton | SSP0060_ShipmentPlan.cs:2877 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdDetail") ▸ if (bEdit_Mode == false) ▸ else of (siDetail.ActiveSheet.SheetName == SpdSh… | GRID_LOCK | siDetail.LockColumn | (siDetail.GetColumnIndex(DefColumns.LAST_UPDATED_BY), siDetail.GetColumnIndex(DefColumns.L… | 그리드 편집 잠금/해제 |  |  |  |
| AC-edccd904 | EditButton | SSP0060_ShipmentPlan.cs:2879 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdDetail") ▸ if (bEdit_Mode == false) | FLAG | strEditSpread | fps.Name | 화면 필드/플래그 변경 |  |  |  |
| AC-d82268ae | EditButton | SSP0060_ShipmentPlan.cs:2880 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdDetail") ▸ if (bEdit_Mode == false) | FLAG | bEdit_Mode | true | 화면 필드/플래그 변경 |  |  |  |
| AC-dd95d5be | EditButton | SSP0060_ShipmentPlan.cs:2891 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdDetail") ▸ else of (bEdit_Mode == false) | FLAG | strEditSpread | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-c6b185ac | EditButton | SSP0060_ShipmentPlan.cs:2892 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdDetail") ▸ else of (bEdit_Mode == false) | FLAG | bEdit_Mode | false | 화면 필드/플래그 변경 |  |  |  |

## SSP0060_ShipmentPlan.EditByChange

진입점: this.spdMain.KeyUp [if (e.KeyCode == Keys.Delete) ▸ if (ranges != null) ▸ for (x < 1) ▸ try ▸ if (rowstart >= 0 && rowend >= 0 && colstart >= 0 && colend >= 0) ▸ for (i <= rowend) ▸ for (j <= colend)] / this.spdMain.Change / this.spdMain.ClipboardPasted [try ▸ for (iRow < e.CellRange.Row + e.CellRange.RowCount) ▸ if (measure.Equals("SHIP_PLAN_DETAIL") && toSite != string.Empty) ▸ for (iCol < e.CellRange.Column + e.CellRange.ColumnCount)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c4e9fb93 | this.spdMain.KeyUp [if (e.KeyCode == Keys.Delete) ▸ if (rang… 외 2 | SSP0060_ShipmentPlan.cs:2090 | if (sColName.IndexOf("D_") < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-cfa02d47 | this.spdMain.KeyUp [if (e.KeyCode == Keys.Delete) ▸ if (rang… 외 2 | SSP0060_ShipmentPlan.cs:2101 |  | CALL_EXT | CommonUtils.GetValueDecimal | (siMain.GetValue(iRow, iCol)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f7c67de9 | this.spdMain.KeyUp [if (e.KeyCode == Keys.Delete) ▸ if (rang… 외 2 | SSP0060_ShipmentPlan.cs:2103 |  | CALL_EXT | CString.IsNumber | (sEditYN) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d01d75d4 | this.spdMain.KeyUp [if (e.KeyCode == Keys.Delete) ▸ if (rang… 외 2 | SSP0060_ShipmentPlan.cs:2106 | if (CString.IsNumber(sEditYN)) | DATA_OP | row.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-77f77c7e | this.spdMain.KeyUp [if (e.KeyCode == Keys.Delete) ▸ if (rang… 외 2 | SSP0060_ShipmentPlan.cs:2107 | if (CString.IsNumber(sEditYN)) | DATA_OP | row.Field | ("FROM_SITE") | 데이터 객체 조작/조회 |  |  |  |
| AC-339625a1 | this.spdMain.KeyUp [if (e.KeyCode == Keys.Delete) ▸ if (rang… 외 2 | SSP0060_ShipmentPlan.cs:2108 | if (CString.IsNumber(sEditYN)) | DATA_OP | row.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-02fde214 | this.spdMain.KeyUp [if (e.KeyCode == Keys.Delete) ▸ if (rang… 외 2 | SSP0060_ShipmentPlan.cs:2109 | if (CString.IsNumber(sEditYN)) | DATA_OP | row.Field | ("TO_SITE") | 데이터 객체 조작/조회 |  |  |  |
| AC-f9dce733 | this.spdMain.KeyUp [if (e.KeyCode == Keys.Delete) ▸ if (rang… 외 2 | SSP0060_ShipmentPlan.cs:2110 | if (CString.IsNumber(sEditYN)) | DATA_OP | row.Field | ("TRANSPORT_MODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-4faac771 | this.spdMain.KeyUp [if (e.KeyCode == Keys.Delete) ▸ if (rang… 외 2 | SSP0060_ShipmentPlan.cs:2111 | if (CString.IsNumber(sEditYN)) | DATA_OP | row.Field | ("INCOTERMS") | 데이터 객체 조작/조회 |  |  |  |
| AC-79a42325 | this.spdMain.KeyUp [if (e.KeyCode == Keys.Delete) ▸ if (rang… 외 2 | SSP0060_ShipmentPlan.cs:2112 | if (CString.IsNumber(sEditYN)) | DATA_OP | row.Field | ("FCST_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-dead6cbb | this.spdMain.KeyUp [if (e.KeyCode == Keys.Delete) ▸ if (rang… 외 2 | SSP0060_ShipmentPlan.cs:2113 | if (CString.IsNumber(sEditYN)) | DATA_OP | row.Field | ("YYYYMMDD") | 데이터 객체 조작/조회 |  |  |  |
| AC-abec9053 | this.spdMain.KeyUp [if (e.KeyCode == Keys.Delete) ▸ if (rang… 외 2 | SSP0060_ShipmentPlan.cs:2118 | if (CString.IsNumber(sEditYN)) ▸ if (drQty != null) | CALL_EXT | CommonUtils.GetValueDecimal | (drQty["QTY"]) | ⚠ 의미 확인 필요 |  |  |  |
| AC-868064b2 | this.spdMain.KeyUp [if (e.KeyCode == Keys.Delete) ▸ if (rang… 외 2 | SSP0060_ShipmentPlan.cs:2119 | if (CString.IsNumber(sEditYN)) ▸ if (drQty != null) | CALL_EXT | CommonUtils.GetValueDecimal | (drQty["NOEDIT_QTY"]) | ⚠ 의미 확인 필요 |  |  |  |
| AC-692617b9 | this.spdMain.KeyUp [if (e.KeyCode == Keys.Delete) ▸ if (rang… 외 2 | SSP0060_ShipmentPlan.cs:2123 | if (CString.IsNumber(sEditYN)) ▸ if (drQty != null) ▸ if (dInputQty < dNoEditQty) | MESSAGE | MessageHelper.GMessageBox | ("MSG00425", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-5245e66f | this.spdMain.KeyUp [if (e.KeyCode == Keys.Delete) ▸ if (rang… 외 2 | SSP0060_ShipmentPlan.cs:2124 | if (CString.IsNumber(sEditYN)) ▸ if (drQty != null) ▸ if (dInputQty < dNoEditQty) | GRID_SET | siMain.SetValue | (iRow, iCol, dQty) | 그리드 값 설정 |  |  |  |
| AC-d856bd68 | this.spdMain.KeyUp [if (e.KeyCode == Keys.Delete) ▸ if (rang… 외 2 | SSP0060_ShipmentPlan.cs:2129 |  | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(DefColumns.MEASURE)].ForeColor | Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-f6b6c3e6 | this.spdMain.KeyUp [if (e.KeyCode == Keys.Delete) ▸ if (rang… 외 2 | SSP0060_ShipmentPlan.cs:2130 |  | GRID_SET | siMain.ActiveSheet.Cells[iRow, iCol].ForeColor | Color.Red | 그리드 속성/값 설정 |  |  |  |

## SSP0060_ShipmentPlan.FindData_Detail

진입점: this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 0)] / this.spdMain.CellDoubleClick [if (e.Column >= siMain.GetColumnIndex(DefColumns.FCST_TYPE) + 1 && (siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.M…)] / SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPIFBlockYn()) ▸ try ▸ if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "S") ▸ if (bDetail_Search == true)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-94afdfb9 | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 0)] 외 2 | SSP0060_ShipmentPlan.cs:5571 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-e3e13495 | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 0)] 외 2 | SSP0060_ShipmentPlan.cs:5576 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-8e021736 | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 0)] 외 2 | SSP0060_ShipmentPlan.cs:5651 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-fde64711 | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 0)] 외 2 | SSP0060_ShipmentPlan.cs:5656 | try | ENDPOINT | new FoxDataRequest | ("SSP.SSP0060_GET_SHIPMENT_PLAN_DETAIL") ⇒ SSP.SSP0060_GET_SHIPMENT_PLAN_DETAIL | 엔드포인트 요청 생성 |  |  |  |
| AC-f5bc5208 | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 0)] 외 2 | SSP0060_ShipmentPlan.cs:5657 | try | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-3176ceee | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 0)] 외 2 | SSP0060_ShipmentPlan.cs:5658 | try | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-c1530a9a | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 0)] 외 2 | SSP0060_ShipmentPlan.cs:5659 | try | DATA_OP | request.Parameters["p_company_id"] | p_company_id | 행/컬럼 값 대입 |  |  |  |
| AC-4aafd9c6 | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 0)] 외 2 | SSP0060_ShipmentPlan.cs:5660 | try | DATA_OP | request.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-ab1abda3 | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 0)] 외 2 | SSP0060_ShipmentPlan.cs:5661 | try | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-a96980b0 | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 0)] 외 2 | SSP0060_ShipmentPlan.cs:5662 | try | DATA_OP | request.Parameters["p_product_level1"] | p_product_level1 | 행/컬럼 값 대입 |  |  |  |
| AC-f2b1a918 | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 0)] 외 2 | SSP0060_ShipmentPlan.cs:5663 | try | DATA_OP | request.Parameters["p_requestor"] | p_requestor | 행/컬럼 값 대입 |  |  |  |
| AC-91df0d88 | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 0)] 외 2 | SSP0060_ShipmentPlan.cs:5664 | try | DATA_OP | request.Parameters["p_to_site"] | p_to_site | 행/컬럼 값 대입 |  |  |  |
| AC-6dbcac28 | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 0)] 외 2 | SSP0060_ShipmentPlan.cs:5665 | try | DATA_OP | request.Parameters["p_transport_mode"] | p_transport_mode | 행/컬럼 값 대입 |  |  |  |
| AC-51c82b39 | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 0)] 외 2 | SSP0060_ShipmentPlan.cs:5666 | try | DATA_OP | request.Parameters["p_incoterms"] | p_incoterms | 행/컬럼 값 대입 |  |  |  |
| AC-5b1246cb | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 0)] 외 2 | SSP0060_ShipmentPlan.cs:5667 | try | DATA_OP | request.Parameters["p_fcst_type"] | p_fcst_type | 행/컬럼 값 대입 |  |  |  |
| AC-c6a3c5f7 | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 0)] 외 2 | SSP0060_ShipmentPlan.cs:5668 | try | DATA_OP | request.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-db42555d | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 0)] 외 2 | SSP0060_ShipmentPlan.cs:5669 | try | DATA_OP | request.Parameters["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-74039df1 | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 0)] 외 2 | SSP0060_ShipmentPlan.cs:5670 | try | DATA_OP | request.Parameters["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-d8b82795 | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 0)] 외 2 | SSP0060_ShipmentPlan.cs:5671 | try | DATA_OP | request.Parameters["p_dbl_flag"] | p_dbl_flag | 행/컬럼 값 대입 |  |  |  |
| AC-2a3b51a2 | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 0)] 외 2 | SSP0060_ShipmentPlan.cs:5672 | try | DATA_OP | request.Parameters["p_real_flag"] | p_real_flag | 행/컬럼 값 대입 |  |  |  |
| AC-fda5c350 | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 0)] 외 2 | SSP0060_ShipmentPlan.cs:5673 | try | DATA_OP | request.Parameters["p_language"] | sLanguage | 행/컬럼 값 대입 |  |  |  |
| AC-94649b80 | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 0)] 외 2 | SSP0060_ShipmentPlan.cs:5674 | try | DATA_OP | request.Parameters["p_program_id"] | p_program_id | 행/컬럼 값 대입 |  |  |  |
| AC-1dfc1475 | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 0)] 외 2 | SSP0060_ShipmentPlan.cs:5675 | try | DATA_OP | request.Parameters["p_sheet_name"] | p_sheet_name | 행/컬럼 값 대입 |  |  |  |
| AC-9bfd44ee | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 0)] 외 2 | SSP0060_ShipmentPlan.cs:5676 | try | DATA_OP | request.Parameters["debug_mode"] | "T" | 행/컬럼 값 대입 |  |  |  |
| AC-c029989e | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 0)] 외 2 | SSP0060_ShipmentPlan.cs:5679 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-1113518d | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 0)] 외 2 | SSP0060_ShipmentPlan.cs:5688 | try | GRID_BIND | siDetail.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-477f688f | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 0)] 외 2 | SSP0060_ShipmentPlan.cs:5689 | try | GRID_LOCK | siDetail.LockColumn | (0, siDetail.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-b66c5742 | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 0)] 외 2 | SSP0060_ShipmentPlan.cs:5694 | try ▸ if (DefaultMainDS != null) | STATE_RESET | DefaultMainDS.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-3bdd47ef | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 0)] 외 2 | SSP0060_ShipmentPlan.cs:5696 | try | FLAG | DefaultMainDS | ds.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-638752a4 | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 0)] 외 2 | SSP0060_ShipmentPlan.cs:5696 | try | DATA_OP | ds.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-f5e05745 | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 0)] 외 2 | SSP0060_ShipmentPlan.cs:5699 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-6cb44b31 | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 0)] 외 2 | SSP0060_ShipmentPlan.cs:5718 | finally ▸ if (strEditSpread == "spdDetail") | FLAG | strEditSpread | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-2595cf3f | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 0)] 외 2 | SSP0060_ShipmentPlan.cs:5720 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SSP0060_ShipmentPlan.FindData_hold_stock

진입점: this.spdMain.CellDoubleClick [else of (e.Column >= siMain.GetColumnIndex(DefColumns.FCST_TYPE) + 1 && (siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.M…) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.BOH_QTY) && siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.BOH_TYPE…) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.BOH_QTY) && siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.BOH_TYPE…) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.BOH_QTY) && siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.BOH_TYPE…)] / SaveButton [else of (fps.Name == "spdM…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-06d72fd7 | this.spdMain.CellDoubleClick [else of (e.Column >= siMain.Ge… 외 1 | SSP0060_ShipmentPlan.cs:6172 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-4c730c60 | this.spdMain.CellDoubleClick [else of (e.Column >= siMain.Ge… 외 1 | SSP0060_ShipmentPlan.cs:6178 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-9cf0d1e3 | this.spdMain.CellDoubleClick [else of (e.Column >= siMain.Ge… 외 1 | SSP0060_ShipmentPlan.cs:6183 | try ▸ if (bolDoubleClick == true) | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtHoldStock) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a98529b4 | this.spdMain.CellDoubleClick [else of (e.Column >= siMain.Ge… 외 1 | SSP0060_ShipmentPlan.cs:6184 | try ▸ if (bolDoubleClick == true) | GRID_INIT | siDetail.ChangeActiveSheet | (SpdSheet.shtHoldStock) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-76505912 | this.spdMain.CellDoubleClick [else of (e.Column >= siMain.Ge… 외 1 | SSP0060_ShipmentPlan.cs:6193 | try ▸ else of (bolDoubleClick == true) | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtHoldStockDetail) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f80a7ee8 | this.spdMain.CellDoubleClick [else of (e.Column >= siMain.Ge… 외 1 | SSP0060_ShipmentPlan.cs:6194 | try ▸ else of (bolDoubleClick == true) | GRID_INIT | siDetail.ChangeActiveSheet | (SpdSheet.shtHoldStockDetail) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-398fb80d | this.spdMain.CellDoubleClick [else of (e.Column >= siMain.Ge… 외 1 | SSP0060_ShipmentPlan.cs:6220 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-162fcc0b | this.spdMain.CellDoubleClick [else of (e.Column >= siMain.Ge… 외 1 | SSP0060_ShipmentPlan.cs:6225 | try | ENDPOINT | new FoxDataRequest | ("SSP.SSP0060_GET_HOLD_STOCK") ⇒ SSP.SSP0060_GET_HOLD_STOCK | 엔드포인트 요청 생성 |  |  |  |
| AC-c42f881c | this.spdMain.CellDoubleClick [else of (e.Column >= siMain.Ge… 외 1 | SSP0060_ShipmentPlan.cs:6226 | try | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-61f4b959 | this.spdMain.CellDoubleClick [else of (e.Column >= siMain.Ge… 외 1 | SSP0060_ShipmentPlan.cs:6228 | try | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-d2ef7365 | this.spdMain.CellDoubleClick [else of (e.Column >= siMain.Ge… 외 1 | SSP0060_ShipmentPlan.cs:6229 | try | DATA_OP | request.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-c71671f4 | this.spdMain.CellDoubleClick [else of (e.Column >= siMain.Ge… 외 1 | SSP0060_ShipmentPlan.cs:6230 | try | DATA_OP | request.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-a2ac4dd9 | this.spdMain.CellDoubleClick [else of (e.Column >= siMain.Ge… 외 1 | SSP0060_ShipmentPlan.cs:6231 | try | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-21969489 | this.spdMain.CellDoubleClick [else of (e.Column >= siMain.Ge… 외 1 | SSP0060_ShipmentPlan.cs:6232 | try | DATA_OP | request.Parameters["p_product_level1"] | p_product_level1 | 행/컬럼 값 대입 |  |  |  |
| AC-b62a596c | this.spdMain.CellDoubleClick [else of (e.Column >= siMain.Ge… 외 1 | SSP0060_ShipmentPlan.cs:6233 | try | DATA_OP | request.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-3e25f6c4 | this.spdMain.CellDoubleClick [else of (e.Column >= siMain.Ge… 외 1 | SSP0060_ShipmentPlan.cs:6234 | try | DATA_OP | request.Parameters["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-a974cfa7 | this.spdMain.CellDoubleClick [else of (e.Column >= siMain.Ge… 외 1 | SSP0060_ShipmentPlan.cs:6235 | try | DATA_OP | request.Parameters["p_language"] | sLanguage | 행/컬럼 값 대입 |  |  |  |
| AC-5845a38b | this.spdMain.CellDoubleClick [else of (e.Column >= siMain.Ge… 외 1 | SSP0060_ShipmentPlan.cs:6236 | try | DATA_OP | request.Parameters["p_search_yn"] | p_search_yn | 행/컬럼 값 대입 |  |  |  |
| AC-4d8c0f80 | this.spdMain.CellDoubleClick [else of (e.Column >= siMain.Ge… 외 1 | SSP0060_ShipmentPlan.cs:6237 | try | DATA_OP | request.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-129936d6 | this.spdMain.CellDoubleClick [else of (e.Column >= siMain.Ge… 외 1 | SSP0060_ShipmentPlan.cs:6239 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-eb8f187f | this.spdMain.CellDoubleClick [else of (e.Column >= siMain.Ge… 외 1 | SSP0060_ShipmentPlan.cs:6248 | try | GRID_BIND | siDetail.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-449f9bba | this.spdMain.CellDoubleClick [else of (e.Column >= siMain.Ge… 외 1 | SSP0060_ShipmentPlan.cs:6249 | try | GRID_LOCK | siDetail.LockColumn | (0, siDetail.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-3c13d089 | this.spdMain.CellDoubleClick [else of (e.Column >= siMain.Ge… 외 1 | SSP0060_ShipmentPlan.cs:6252 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-e05d397a | this.spdMain.CellDoubleClick [else of (e.Column >= siMain.Ge… 외 1 | SSP0060_ShipmentPlan.cs:6262 | try | GRID_STYLE | siMain.ActiveSheet.SetActiveCell | (intRowIdx, intColIdx) | 그리드 표시 설정 |  |  |  |
| AC-c17513b0 | this.spdMain.CellDoubleClick [else of (e.Column >= siMain.Ge… 외 1 | SSP0060_ShipmentPlan.cs:6267 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SSP0060_ShipmentPlan.FindData_Main

진입점: this.chkTotPSI.CheckedChanged / FindButton / SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.Tables[0].Rows[0][0].ToString() == "S")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f51e5b04 | this.chkTotPSI.CheckedChanged 외 2 | SSP0060_ShipmentPlan.cs:5233 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-3aa74279 | this.chkTotPSI.CheckedChanged 외 2 | SSP0060_ShipmentPlan.cs:5238 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-d17792c5 | this.chkTotPSI.CheckedChanged 외 2 | SSP0060_ShipmentPlan.cs:5238 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b7e24a04 | this.chkTotPSI.CheckedChanged 외 2 | SSP0060_ShipmentPlan.cs:5246 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-5aeb2483 | this.chkTotPSI.CheckedChanged 외 2 | SSP0060_ShipmentPlan.cs:5247 | try | VALIDATE | DateUtil.Check_PeriodDate | (drpPeriod) | 프레임워크 검증 |  |  |  |
| AC-9e931259 | this.chkTotPSI.CheckedChanged 외 2 | SSP0060_ShipmentPlan.cs:5247 | try ▸ if (!DateUtil.Check_PeriodDate(drpPeriod)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-109ece5c | this.chkTotPSI.CheckedChanged 외 2 | SSP0060_ShipmentPlan.cs:5282 | try | UI_PROP | proxyPivot.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-51b50410 | this.chkTotPSI.CheckedChanged 외 2 | SSP0060_ShipmentPlan.cs:5283 | try | ENDPOINT | proxyPivot.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SSP.Plan.WSL/FoxDataService.s… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-85bf8c35 | this.chkTotPSI.CheckedChanged 외 2 | SSP0060_ShipmentPlan.cs:5287 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SSP.SSP0060_GET_SHIPMENT_PLAN") ⇒ SSP.SSP0060_GET_SHIPMENT_PLAN | 엔드포인트 요청 생성 |  |  |  |
| AC-887422bb | this.chkTotPSI.CheckedChanged 외 2 | SSP0060_ShipmentPlan.cs:5289 | try ▸ lambda | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-1fc11116 | this.chkTotPSI.CheckedChanged 외 2 | SSP0060_ShipmentPlan.cs:5291 | try ▸ lambda | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-87a1ec20 | this.chkTotPSI.CheckedChanged 외 2 | SSP0060_ShipmentPlan.cs:5292 | try ▸ lambda | DATA_OP | req.Parameters["p_company_id"] | p_company_id | 행/컬럼 값 대입 |  |  |  |
| AC-4215af5f | this.chkTotPSI.CheckedChanged 외 2 | SSP0060_ShipmentPlan.cs:5293 | try ▸ lambda | DATA_OP | req.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-e69f1bb1 | this.chkTotPSI.CheckedChanged 외 2 | SSP0060_ShipmentPlan.cs:5294 | try ▸ lambda | DATA_OP | req.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-c3e32c06 | this.chkTotPSI.CheckedChanged 외 2 | SSP0060_ShipmentPlan.cs:5295 | try ▸ lambda | DATA_OP | req.Parameters["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-e40d9631 | this.chkTotPSI.CheckedChanged 외 2 | SSP0060_ShipmentPlan.cs:5296 | try ▸ lambda | DATA_OP | req.Parameters["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-3a7590e0 | this.chkTotPSI.CheckedChanged 외 2 | SSP0060_ShipmentPlan.cs:5297 | try ▸ lambda | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-7260df83 | this.chkTotPSI.CheckedChanged 외 2 | SSP0060_ShipmentPlan.cs:5298 | try ▸ lambda | DATA_OP | req.Parameters["p_product_level1"] | p_product_level1 | 행/컬럼 값 대입 |  |  |  |
| AC-f0892219 | this.chkTotPSI.CheckedChanged 외 2 | SSP0060_ShipmentPlan.cs:5299 | try ▸ lambda | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-4fbbf6de | this.chkTotPSI.CheckedChanged 외 2 | SSP0060_ShipmentPlan.cs:5300 | try ▸ lambda | DATA_OP | req.Parameters["p_program_id"] | p_program_id | 행/컬럼 값 대입 |  |  |  |
| AC-68b88365 | this.chkTotPSI.CheckedChanged 외 2 | SSP0060_ShipmentPlan.cs:5301 | try ▸ lambda | DATA_OP | req.Parameters["p_sheet_name"] | p_sheet_name | 행/컬럼 값 대입 |  |  |  |
| AC-6595dd17 | this.chkTotPSI.CheckedChanged 외 2 | SSP0060_ShipmentPlan.cs:5302 | try ▸ lambda | DATA_OP | req.Parameters["p_real_flag"] | p_real_flag | 행/컬럼 값 대입 |  |  |  |
| AC-f5025adf | this.chkTotPSI.CheckedChanged 외 2 | SSP0060_ShipmentPlan.cs:5304 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-4b81b8e5 | this.chkTotPSI.CheckedChanged 외 2 | SSP0060_ShipmentPlan.cs:5305 | try ▸ lambda | FLAG | dsMain | res.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-590ab518 | this.chkTotPSI.CheckedChanged 외 2 | SSP0060_ShipmentPlan.cs:5306 | try ▸ lambda | RETURN | return res.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-83b69bb5 | this.chkTotPSI.CheckedChanged 외 2 | SSP0060_ShipmentPlan.cs:5315 | try | GRID_BIND | siMain.Query | (GetFilteredDs(dsMain)) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-e42fd076 | this.chkTotPSI.CheckedChanged 외 2 | SSP0060_ShipmentPlan.cs:5316 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-01037ec2 | this.chkTotPSI.CheckedChanged 외 2 | SSP0060_ShipmentPlan.cs:5327 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3df09529 | this.chkTotPSI.CheckedChanged 외 2 | SSP0060_ShipmentPlan.cs:5333 | try | UI_MISC | SetSearchCount | (dsBinding) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-51afc97a | this.chkTotPSI.CheckedChanged 외 2 | SSP0060_ShipmentPlan.cs:5336 | try | FLAG | dtNote | new DataTable() | 화면 필드/플래그 변경 |  |  |  |
| AC-29906f9e | this.chkTotPSI.CheckedChanged 외 2 | SSP0060_ShipmentPlan.cs:5337 | try | FLAG | dtNote | dsBinding.Tables[1].Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-8d54b546 | this.chkTotPSI.CheckedChanged 외 2 | SSP0060_ShipmentPlan.cs:5337 | try | DATA_OP | dsBinding.Tables[1].Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-ab7369b7 | this.chkTotPSI.CheckedChanged 외 2 | SSP0060_ShipmentPlan.cs:5338 | try | FLAG | intNoteCnt | dtNote.Rows.Count | 화면 필드/플래그 변경 |  |  |  |
| AC-f5c79e71 | this.chkTotPSI.CheckedChanged 외 2 | SSP0060_ShipmentPlan.cs:5347 | finally | FLAG | strEditSpread | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-45c3e5ed | this.chkTotPSI.CheckedChanged 외 2 | SSP0060_ShipmentPlan.cs:5348 | finally | FLAG | this.bEdit_Mode | false | 화면 필드/플래그 변경 |  |  |  |
| AC-60d72213 | this.chkTotPSI.CheckedChanged 외 2 | SSP0060_ShipmentPlan.cs:5350 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SSP0060_ShipmentPlan.FindData_MES_stock

진입점: this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 3)] / this.spdMain.CellDoubleClick [else of (e.Column >= siMain.GetColumnIndex(DefColumns.FCST_TYPE) + 1 && (siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.M…) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.BOH_QTY) && siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.BOH_TYPE…) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.BOH_QTY) && siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.BOH_TYPE…) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.BOH_QTY) && siMain.GetText(e.Row, siMain.GetColumnIn…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6340ea37 | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 3)] 외 1 | SSP0060_ShipmentPlan.cs:6275 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-44f0518f | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 3)] 외 1 | SSP0060_ShipmentPlan.cs:6280 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-c57cb7e9 | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 3)] 외 1 | SSP0060_ShipmentPlan.cs:6323 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-a6a72b78 | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 3)] 외 1 | SSP0060_ShipmentPlan.cs:6328 | try | ENDPOINT | new FoxDataRequest | ("SSP.SSP0060_GET_MES_STOCK") ⇒ SSP.SSP0060_GET_MES_STOCK | 엔드포인트 요청 생성 |  |  |  |
| AC-fd489bf4 | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 3)] 외 1 | SSP0060_ShipmentPlan.cs:6329 | try | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-6786c81d | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 3)] 외 1 | SSP0060_ShipmentPlan.cs:6330 | try | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-797fa938 | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 3)] 외 1 | SSP0060_ShipmentPlan.cs:6331 | try | DATA_OP | request.Parameters["p_company_id"] | p_company_id | 행/컬럼 값 대입 |  |  |  |
| AC-780c4434 | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 3)] 외 1 | SSP0060_ShipmentPlan.cs:6332 | try | DATA_OP | request.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-59382a71 | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 3)] 외 1 | SSP0060_ShipmentPlan.cs:6333 | try | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-2e5ce3e5 | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 3)] 외 1 | SSP0060_ShipmentPlan.cs:6334 | try | DATA_OP | request.Parameters["p_product_level1"] | p_product_level1 | 행/컬럼 값 대입 |  |  |  |
| AC-8359439d | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 3)] 외 1 | SSP0060_ShipmentPlan.cs:6335 | try | DATA_OP | request.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-41839a69 | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 3)] 외 1 | SSP0060_ShipmentPlan.cs:6336 | try | DATA_OP | request.Parameters["p_dbl_flag"] | p_dbl_flag | 행/컬럼 값 대입 |  |  |  |
| AC-902c20f5 | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 3)] 외 1 | SSP0060_ShipmentPlan.cs:6337 | try | DATA_OP | request.Parameters["p_language"] | sLanguage | 행/컬럼 값 대입 |  |  |  |
| AC-2644c74f | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 3)] 외 1 | SSP0060_ShipmentPlan.cs:6338 | try | DATA_OP | request.Parameters["p_program_id"] | p_program_id | 행/컬럼 값 대입 |  |  |  |
| AC-553747cd | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 3)] 외 1 | SSP0060_ShipmentPlan.cs:6339 | try | DATA_OP | request.Parameters["p_sheet_name"] | p_sheet_name | 행/컬럼 값 대입 |  |  |  |
| AC-ffc3e030 | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 3)] 외 1 | SSP0060_ShipmentPlan.cs:6340 | try | DATA_OP | request.Parameters["debug_mode"] | "T" | 행/컬럼 값 대입 |  |  |  |
| AC-c3fd42a6 | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 3)] 외 1 | SSP0060_ShipmentPlan.cs:6342 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-4d63ac1b | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 3)] 외 1 | SSP0060_ShipmentPlan.cs:6351 | try | GRID_BIND | siDetail.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-0ec0c91d | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 3)] 외 1 | SSP0060_ShipmentPlan.cs:6352 | try | GRID_LOCK | siDetail.LockColumn | (0, siDetail.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-4000bf0c | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 3)] 외 1 | SSP0060_ShipmentPlan.cs:6355 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-ceff9da7 | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 3)] 외 1 | SSP0060_ShipmentPlan.cs:6369 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SSP0060_ShipmentPlan.FindData_MES_stock_Detail

진입점: this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 4)] / this.spdMain.CellDoubleClick [else of (e.Column >= siMain.GetColumnIndex(DefColumns.FCST_TYPE) + 1 && (siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.M…) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.BOH_QTY) && siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.BOH_TYPE…) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.BOH_QTY) && siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.BOH_TYPE…) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.BOH_QTY) && siMain.GetText(e.Row, siMain.GetColumnIn…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ccb358b5 | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 4)] 외 1 | SSP0060_ShipmentPlan.cs:6376 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-0f12ef29 | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 4)] 외 1 | SSP0060_ShipmentPlan.cs:6381 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-d07d0f21 | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 4)] 외 1 | SSP0060_ShipmentPlan.cs:6427 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-ddbff524 | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 4)] 외 1 | SSP0060_ShipmentPlan.cs:6432 | try | ENDPOINT | new FoxDataRequest | ("SSP.SSP0060_GET_MES_STOCK_DETAIL") ⇒ SSP.SSP0060_GET_MES_STOCK_DETAIL | 엔드포인트 요청 생성 |  |  |  |
| AC-1e04b116 | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 4)] 외 1 | SSP0060_ShipmentPlan.cs:6433 | try | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-6c5a12d0 | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 4)] 외 1 | SSP0060_ShipmentPlan.cs:6434 | try | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-b967933a | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 4)] 외 1 | SSP0060_ShipmentPlan.cs:6435 | try | DATA_OP | request.Parameters["p_company_id"] | p_company_id | 행/컬럼 값 대입 |  |  |  |
| AC-fb047685 | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 4)] 외 1 | SSP0060_ShipmentPlan.cs:6436 | try | DATA_OP | request.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-ad8f643a | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 4)] 외 1 | SSP0060_ShipmentPlan.cs:6437 | try | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-1b340df7 | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 4)] 외 1 | SSP0060_ShipmentPlan.cs:6438 | try | DATA_OP | request.Parameters["p_product_level1"] | p_product_level1 | 행/컬럼 값 대입 |  |  |  |
| AC-3690ce01 | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 4)] 외 1 | SSP0060_ShipmentPlan.cs:6439 | try | DATA_OP | request.Parameters["p_box_id"] | p_box_id | 행/컬럼 값 대입 |  |  |  |
| AC-c6741283 | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 4)] 외 1 | SSP0060_ShipmentPlan.cs:6440 | try | DATA_OP | request.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-d46ec6b8 | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 4)] 외 1 | SSP0060_ShipmentPlan.cs:6441 | try | DATA_OP | request.Parameters["p_dbl_flag"] | p_dbl_flag | 행/컬럼 값 대입 |  |  |  |
| AC-2acccd1a | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 4)] 외 1 | SSP0060_ShipmentPlan.cs:6442 | try | DATA_OP | request.Parameters["p_language"] | sLanguage | 행/컬럼 값 대입 |  |  |  |
| AC-33ddfb9f | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 4)] 외 1 | SSP0060_ShipmentPlan.cs:6443 | try | DATA_OP | request.Parameters["p_program_id"] | p_program_id | 행/컬럼 값 대입 |  |  |  |
| AC-0f19e952 | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 4)] 외 1 | SSP0060_ShipmentPlan.cs:6444 | try | DATA_OP | request.Parameters["p_sheet_name"] | p_sheet_name | 행/컬럼 값 대입 |  |  |  |
| AC-20205602 | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 4)] 외 1 | SSP0060_ShipmentPlan.cs:6445 | try | DATA_OP | request.Parameters["debug_mode"] | "T" | 행/컬럼 값 대입 |  |  |  |
| AC-3a91550e | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 4)] 외 1 | SSP0060_ShipmentPlan.cs:6447 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-6bca6d73 | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 4)] 외 1 | SSP0060_ShipmentPlan.cs:6456 | try | GRID_BIND | siDetail.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-075badbb | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 4)] 외 1 | SSP0060_ShipmentPlan.cs:6457 | try | GRID_LOCK | siDetail.LockColumn | (0, siDetail.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-8f4e4f97 | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 4)] 외 1 | SSP0060_ShipmentPlan.cs:6460 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-91b49dbf | this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 4)] 외 1 | SSP0060_ShipmentPlan.cs:6474 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SSP0060_ShipmentPlan.FindData_oWMS_Detail

진입점: this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex == 0) ▸ else of (spdDetail.ActiveSheetIndex == 1) ▸ if (spdDetail.ActiveSheetIndex == 2)] / this.spdMain.CellDoubleClick [else of (e.Column >= siMain.GetColumnIndex(DefColumns.FCST_TYPE) + 1 && (siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.M…) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.BOH_QTY) && siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.BOH_TYPE…) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.BOH_QTY) && siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.BOH_TYPE…)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8afce4e2 | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… 외 1 | SSP0060_ShipmentPlan.cs:5829 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-6515243e | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… 외 1 | SSP0060_ShipmentPlan.cs:5834 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-8ca8f861 | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… 외 1 | SSP0060_ShipmentPlan.cs:5877 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-3807bfaa | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… 외 1 | SSP0060_ShipmentPlan.cs:5882 | try | ENDPOINT | new FoxDataRequest | ("SSP.SSP0060_GET_OWMS_DETAIL") ⇒ SSP.SSP0060_GET_OWMS_DETAIL | 엔드포인트 요청 생성 |  |  |  |
| AC-5f1b5ad1 | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… 외 1 | SSP0060_ShipmentPlan.cs:5883 | try | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-8c1c5933 | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… 외 1 | SSP0060_ShipmentPlan.cs:5884 | try | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-5598d693 | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… 외 1 | SSP0060_ShipmentPlan.cs:5885 | try | DATA_OP | request.Parameters["p_company_id"] | p_company_id | 행/컬럼 값 대입 |  |  |  |
| AC-6b6de792 | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… 외 1 | SSP0060_ShipmentPlan.cs:5886 | try | DATA_OP | request.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-17707ca9 | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… 외 1 | SSP0060_ShipmentPlan.cs:5887 | try | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-ad485e68 | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… 외 1 | SSP0060_ShipmentPlan.cs:5888 | try | DATA_OP | request.Parameters["p_product_level1"] | p_product_level1 | 행/컬럼 값 대입 |  |  |  |
| AC-6589494e | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… 외 1 | SSP0060_ShipmentPlan.cs:5889 | try | DATA_OP | request.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-6f2e6b82 | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… 외 1 | SSP0060_ShipmentPlan.cs:5890 | try | DATA_OP | request.Parameters["p_dbl_flag"] | p_dbl_flag | 행/컬럼 값 대입 |  |  |  |
| AC-df62843f | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… 외 1 | SSP0060_ShipmentPlan.cs:5891 | try | DATA_OP | request.Parameters["p_language"] | sLanguage | 행/컬럼 값 대입 |  |  |  |
| AC-873324e5 | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… 외 1 | SSP0060_ShipmentPlan.cs:5892 | try | DATA_OP | request.Parameters["p_program_id"] | p_program_id | 행/컬럼 값 대입 |  |  |  |
| AC-93dbb754 | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… 외 1 | SSP0060_ShipmentPlan.cs:5893 | try | DATA_OP | request.Parameters["p_sheet_name"] | p_sheet_name | 행/컬럼 값 대입 |  |  |  |
| AC-d61c5e12 | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… 외 1 | SSP0060_ShipmentPlan.cs:5894 | try | DATA_OP | request.Parameters["debug_mode"] | "T" | 행/컬럼 값 대입 |  |  |  |
| AC-72c5a4ea | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… 외 1 | SSP0060_ShipmentPlan.cs:5896 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-ecb07c12 | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… 외 1 | SSP0060_ShipmentPlan.cs:5905 | try | GRID_BIND | siDetail.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-ed549863 | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… 외 1 | SSP0060_ShipmentPlan.cs:5906 | try | GRID_LOCK | siDetail.LockColumn | (0, siDetail.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-718de924 | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… 외 1 | SSP0060_ShipmentPlan.cs:5909 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-9816c89d | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… 외 1 | SSP0060_ShipmentPlan.cs:5923 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SSP0060_ShipmentPlan.FindData_Shipment_Result

진입점: this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex == 4) ▸ if (spdDetail.ActiveSheetIndex == 5)] / this.spdMain.CellDoubleClick [else of (e.Column >= siMain.GetColumnIndex(DefColumns.FCST_TYPE) + 1 && (siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.M…) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.BOH_QTY) && siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.BOH_TYPE…) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.BOH_QTY) && siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.BOH_TYPE…) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.BOH_QTY)…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a47aa2d0 | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… 외 1 | SSP0060_ShipmentPlan.cs:5929 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-a660c47f | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… 외 1 | SSP0060_ShipmentPlan.cs:5934 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-f14dace8 | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… 외 1 | SSP0060_ShipmentPlan.cs:5972 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-2b12cdf5 | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… 외 1 | SSP0060_ShipmentPlan.cs:5977 | try | ENDPOINT | new FoxDataRequest | ("SSP.SSP0060_GET_SHIPMENT_RESULT") ⇒ SSP.SSP0060_GET_SHIPMENT_RESULT | 엔드포인트 요청 생성 |  |  |  |
| AC-814b8489 | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… 외 1 | SSP0060_ShipmentPlan.cs:5978 | try | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-31b69db4 | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… 외 1 | SSP0060_ShipmentPlan.cs:5979 | try | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-f7dacb1e | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… 외 1 | SSP0060_ShipmentPlan.cs:5980 | try | DATA_OP | request.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-9174407e | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… 외 1 | SSP0060_ShipmentPlan.cs:5981 | try | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-72cc12c5 | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… 외 1 | SSP0060_ShipmentPlan.cs:5982 | try | DATA_OP | request.Parameters["p_product_level1"] | p_product_level1 | 행/컬럼 값 대입 |  |  |  |
| AC-3c3a8ccb | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… 외 1 | SSP0060_ShipmentPlan.cs:5983 | try | DATA_OP | request.Parameters["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-a324236a | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… 외 1 | SSP0060_ShipmentPlan.cs:5984 | try | DATA_OP | request.Parameters["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-87834dcb | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… 외 1 | SSP0060_ShipmentPlan.cs:5985 | try | DATA_OP | request.Parameters["p_type"] | p_type | 행/컬럼 값 대입 |  |  |  |
| AC-178979e0 | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… 외 1 | SSP0060_ShipmentPlan.cs:5986 | try | DATA_OP | request.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-5834e08c | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… 외 1 | SSP0060_ShipmentPlan.cs:5987 | try | DATA_OP | request.Parameters["p_company_id"] | p_company_id | 행/컬럼 값 대입 |  |  |  |
| AC-d53cf3cb | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… 외 1 | SSP0060_ShipmentPlan.cs:5988 | try | DATA_OP | request.Parameters["p_myModelChk"] | p_myModelChk | 행/컬럼 값 대입 |  |  |  |
| AC-ed1e30bb | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… 외 1 | SSP0060_ShipmentPlan.cs:5989 | try | DATA_OP | request.Parameters["p_partLeaderChk"] | p_partLeaderChk | 행/컬럼 값 대입 |  |  |  |
| AC-5a93593e | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… 외 1 | SSP0060_ShipmentPlan.cs:5990 | try | DATA_OP | request.Parameters["p_teamLeaderChk"] | p_teamLeaderChk | 행/컬럼 값 대입 |  |  |  |
| AC-3f1fd11a | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… 외 1 | SSP0060_ShipmentPlan.cs:5991 | try | DATA_OP | request.Parameters["p_delegateeChk"] | p_delegateeChk | 행/컬럼 값 대입 |  |  |  |
| AC-4f729b3c | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… 외 1 | SSP0060_ShipmentPlan.cs:5992 | try | DATA_OP | request.Parameters["p_nonChk"] | p_nonChk | 행/컬럼 값 대입 |  |  |  |
| AC-a0dfb201 | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… 외 1 | SSP0060_ShipmentPlan.cs:5993 | try | DATA_OP | request.Parameters["p_real_flag"] | p_real_flag | 행/컬럼 값 대입 |  |  |  |
| AC-dfe98e15 | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… 외 1 | SSP0060_ShipmentPlan.cs:5994 | try | DATA_OP | request.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-d3fc6143 | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… 외 1 | SSP0060_ShipmentPlan.cs:5996 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-6a0801c6 | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… 외 1 | SSP0060_ShipmentPlan.cs:6005 | try | GRID_BIND | siDetail.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-66f04953 | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… 외 1 | SSP0060_ShipmentPlan.cs:6006 | try | GRID_LOCK | siDetail.LockColumn | (0, siDetail.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-1a95b92c | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… 외 1 | SSP0060_ShipmentPlan.cs:6009 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-9e96448c | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… 외 1 | SSP0060_ShipmentPlan.cs:6024 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-0ec727c1 | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… 외 1 | SSP0060_ShipmentPlan.cs:6030 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-360c1cc8 | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… 외 1 | SSP0060_ShipmentPlan.cs:6035 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-6cc4f88d | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… 외 1 | SSP0060_ShipmentPlan.cs:6038 | try | VALUE_SET | clbResultType.ControlValues | "E" | 컨트롤 값 설정 |  |  |  |
| AC-ef8b8ee9 | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… 외 1 | SSP0060_ShipmentPlan.cs:6112 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-7af1724b | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… 외 1 | SSP0060_ShipmentPlan.cs:6117 | try | ENDPOINT | new FoxDataRequest | ("SSP.SSP0060_GET_SHIPMENT_RESULT") ⇒ SSP.SSP0060_GET_SHIPMENT_RESULT | 엔드포인트 요청 생성 |  |  |  |
| AC-5563480a | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… 외 1 | SSP0060_ShipmentPlan.cs:6118 | try | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-7f118225 | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… 외 1 | SSP0060_ShipmentPlan.cs:6119 | try | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-940120f4 | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… 외 1 | SSP0060_ShipmentPlan.cs:6120 | try | DATA_OP | request.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-962b7f84 | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… 외 1 | SSP0060_ShipmentPlan.cs:6121 | try | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-e33fa425 | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… 외 1 | SSP0060_ShipmentPlan.cs:6122 | try | DATA_OP | request.Parameters["p_product_level1"] | p_product_level1 | 행/컬럼 값 대입 |  |  |  |
| AC-bc9aad7e | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… 외 1 | SSP0060_ShipmentPlan.cs:6123 | try | DATA_OP | request.Parameters["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-4dfbefa1 | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… 외 1 | SSP0060_ShipmentPlan.cs:6124 | try | DATA_OP | request.Parameters["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-fe9ef77c | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… 외 1 | SSP0060_ShipmentPlan.cs:6125 | try | DATA_OP | request.Parameters["p_type"] | p_type | 행/컬럼 값 대입 |  |  |  |
| AC-d2f13b4b | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… 외 1 | SSP0060_ShipmentPlan.cs:6126 | try | DATA_OP | request.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-2af5f509 | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… 외 1 | SSP0060_ShipmentPlan.cs:6127 | try | DATA_OP | request.Parameters["p_company_id"] | p_company_id | 행/컬럼 값 대입 |  |  |  |
| AC-303f3a95 | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… 외 1 | SSP0060_ShipmentPlan.cs:6128 | try | DATA_OP | request.Parameters["p_myModelChk"] | p_myModelChk | 행/컬럼 값 대입 |  |  |  |
| AC-afab803e | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… 외 1 | SSP0060_ShipmentPlan.cs:6129 | try | DATA_OP | request.Parameters["p_partLeaderChk"] | p_partLeaderChk | 행/컬럼 값 대입 |  |  |  |
| AC-46915dc9 | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… 외 1 | SSP0060_ShipmentPlan.cs:6130 | try | DATA_OP | request.Parameters["p_teamLeaderChk"] | p_teamLeaderChk | 행/컬럼 값 대입 |  |  |  |
| AC-1acbb4c9 | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… 외 1 | SSP0060_ShipmentPlan.cs:6131 | try | DATA_OP | request.Parameters["p_delegateeChk"] | p_delegateeChk | 행/컬럼 값 대입 |  |  |  |
| AC-8c0813cc | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… 외 1 | SSP0060_ShipmentPlan.cs:6132 | try | DATA_OP | request.Parameters["p_nonChk"] | p_nonChk | 행/컬럼 값 대입 |  |  |  |
| AC-1cca3fc6 | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… 외 1 | SSP0060_ShipmentPlan.cs:6133 | try | DATA_OP | request.Parameters["p_real_flag"] | p_real_flag | 행/컬럼 값 대입 |  |  |  |
| AC-d67814f8 | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… 외 1 | SSP0060_ShipmentPlan.cs:6134 | try | DATA_OP | request.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-48b14192 | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… 외 1 | SSP0060_ShipmentPlan.cs:6136 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-d12a24c8 | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… 외 1 | SSP0060_ShipmentPlan.cs:6145 | try | GRID_BIND | siDetail.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-afec7ca9 | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… 외 1 | SSP0060_ShipmentPlan.cs:6146 | try | GRID_LOCK | siDetail.LockColumn | (0, siDetail.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-df2dda91 | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… 외 1 | SSP0060_ShipmentPlan.cs:6149 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-9a43dd95 | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… 외 1 | SSP0060_ShipmentPlan.cs:6164 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SSP0060_ShipmentPlan.FindData_Stock_Detail

진입점: this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex == 0) ▸ if (spdDetail.ActiveSheetIndex == 1)] / this.spdMain.CellDoubleClick [else of (e.Column >= siMain.GetColumnIndex(DefColumns.FCST_TYPE) + 1 && (siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.M…) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.BOH_QTY) && siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.BOH_TYPE…)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9c6cf1e1 | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… 외 1 | SSP0060_ShipmentPlan.cs:5727 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-9779681b | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… 외 1 | SSP0060_ShipmentPlan.cs:5732 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-c6874887 | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… 외 1 | SSP0060_ShipmentPlan.cs:5776 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-567e5645 | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… 외 1 | SSP0060_ShipmentPlan.cs:5781 | try | ENDPOINT | new FoxDataRequest | ("SSP.SSP0060_GET_STOCK_LOCATION_DETAIL") ⇒ SSP.SSP0060_GET_STOCK_LOCATION_DETAIL | 엔드포인트 요청 생성 |  |  |  |
| AC-50c8187e | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… 외 1 | SSP0060_ShipmentPlan.cs:5782 | try | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-be7055cb | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… 외 1 | SSP0060_ShipmentPlan.cs:5783 | try | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-7fa6e45d | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… 외 1 | SSP0060_ShipmentPlan.cs:5784 | try | DATA_OP | request.Parameters["p_company_id"] | p_company_id | 행/컬럼 값 대입 |  |  |  |
| AC-4459483e | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… 외 1 | SSP0060_ShipmentPlan.cs:5785 | try | DATA_OP | request.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-e2834d14 | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… 외 1 | SSP0060_ShipmentPlan.cs:5786 | try | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-31a009b5 | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… 외 1 | SSP0060_ShipmentPlan.cs:5787 | try | DATA_OP | request.Parameters["p_product_level1"] | p_product_level1 | 행/컬럼 값 대입 |  |  |  |
| AC-cd99ad98 | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… 외 1 | SSP0060_ShipmentPlan.cs:5788 | try | DATA_OP | request.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-7f7e8e15 | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… 외 1 | SSP0060_ShipmentPlan.cs:5789 | try | DATA_OP | request.Parameters["p_dbl_flag"] | p_dbl_flag | 행/컬럼 값 대입 |  |  |  |
| AC-569730b7 | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… 외 1 | SSP0060_ShipmentPlan.cs:5790 | try | DATA_OP | request.Parameters["p_language"] | sLanguage | 행/컬럼 값 대입 |  |  |  |
| AC-8daf1be8 | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… 외 1 | SSP0060_ShipmentPlan.cs:5791 | try | DATA_OP | request.Parameters["p_program_id"] | p_program_id | 행/컬럼 값 대입 |  |  |  |
| AC-99331915 | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… 외 1 | SSP0060_ShipmentPlan.cs:5792 | try | DATA_OP | request.Parameters["p_sheet_name"] | p_sheet_name | 행/컬럼 값 대입 |  |  |  |
| AC-ee5110bb | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… 외 1 | SSP0060_ShipmentPlan.cs:5793 | try | DATA_OP | request.Parameters["debug_mode"] | "T" | 행/컬럼 값 대입 |  |  |  |
| AC-bf762e69 | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… 외 1 | SSP0060_ShipmentPlan.cs:5795 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-aa82b939 | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… 외 1 | SSP0060_ShipmentPlan.cs:5804 | try | GRID_BIND | siDetail.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-c4281dca | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… 외 1 | SSP0060_ShipmentPlan.cs:5805 | try | GRID_LOCK | siDetail.LockColumn | (0, siDetail.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-9b0e284a | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… 외 1 | SSP0060_ShipmentPlan.cs:5808 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-7478021d | this.btnSearch.Click [else of (spdDetail.ActiveSheetIndex ==… 외 1 | SSP0060_ShipmentPlan.cs:5822 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SSP0060_ShipmentPlan.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b34cf10f | this.Load | SSP0060_ShipmentPlan.cs:322 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-32aae1de | this.Load | SSP0060_ShipmentPlan.cs:331 | if (!string.IsNullOrEmpty(sUserCompany_NM)) | VALUE_CLEAR | clbCompany_ID.SelectedIndex | -1 | 컨트롤 값 비움 |  |  |  |
| AC-c95d4da0 | this.Load | SSP0060_ShipmentPlan.cs:332 | if (!string.IsNullOrEmpty(sUserCompany_NM)) | CALL_EXT | clbCompany_ID.FindString | (sUserCompany_NM) | ⚠ 의미 확인 필요 |  |  |  |
| AC-8ebace78 | this.Load | SSP0060_ShipmentPlan.cs:333 | if (!string.IsNullOrEmpty(sUserCompany_NM)) | VALUE_SET | clbCompany_ID.SelectedIndex | intComIdx < 0 ? 0 : intComIdx | 컨트롤 값 설정 |  |  |  |

## SSP0060_ShipmentPlan.GetBucketType

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-798e11eb | this.Load | SSP0060_ShipmentPlan.cs:5206 |  | ENDPOINT | new FoxDataRequest | ("DM.DM0003_GET_BUCKET_TYPE_CODE") ⇒ DM.DM0003_GET_BUCKET_TYPE_CODE | 엔드포인트 요청 생성 |  |  |  |
| AC-31be0319 | this.Load | SSP0060_ShipmentPlan.cs:5207 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-c8d20374 | this.Load | SSP0060_ShipmentPlan.cs:5210 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SSP0060_ShipmentPlan.GetErpIFCheck

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-50303e89 | (진입점 미연결) | SSP0060_ShipmentPlan.cs:4570 | try | CALL_EXT | service.FN_ERP_UIWebService | (RequestNo, "C", "") | ⚠ 의미 확인 필요 |  |  |  |
| AC-b2599002 | (진입점 미연결) | SSP0060_ShipmentPlan.cs:4579 | try ▸ if (service.RtFlag == "E" \|\| service.RtFlag == "F" \|\| service.RtFlag == "C_E") | ENDPOINT | new FoxDataRequest | ("SSP.SSP0060_DELETE_SHIPMENT_REQUEST_DRAFTING") ⇒ SSP.SSP0060_DELETE_SHIPMENT_REQUEST_DRAFTING | 엔드포인트 요청 생성 |  |  |  |
| AC-f87144e8 | (진입점 미연결) | SSP0060_ShipmentPlan.cs:4580 | try ▸ if (service.RtFlag == "E" \|\| service.RtFlag == "F" \|\| service.RtFlag == "C_E") | DATA_OP | request.Parameters["p_change_request_no"] | p_change_request_no | 행/컬럼 값 대입 |  |  |  |
| AC-968acb0b | (진입점 미연결) | SSP0060_ShipmentPlan.cs:4581 | try ▸ if (service.RtFlag == "E" \|\| service.RtFlag == "F" \|\| service.RtFlag == "C_E") | DATA_OP | request.Parameters["p_user_id"] | UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-043f8701 | (진입점 미연결) | SSP0060_ShipmentPlan.cs:4583 | try ▸ if (service.RtFlag == "E" \|\| service.RtFlag == "F" \|\| service.RtFlag == "C_E") | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-5f97c33c | (진입점 미연결) | SSP0060_ShipmentPlan.cs:4594 | try ▸ if (service.RtFlag == "E") | MESSAGE | MessageHelper.GMessageBox | ("MSG00197", new object[] { arg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c45453b0 | (진입점 미연결) | SSP0060_ShipmentPlan.cs:4601 | try ▸ else of (service.RtFlag == "E") ▸ if (service.RtFlag == "F") | MESSAGE | MessageHelper.GMessageBox | ("MSG00204", new object[] { arg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b2f702a3 | (진입점 미연결) | SSP0060_ShipmentPlan.cs:4606 | try ▸ else of (service.RtFlag == "E") ▸ else of (service.RtFlag == "F") ▸ if (service.RtFlag == "C_E") | MESSAGE | MessageHelper.GMessageBox | ("MSG00306", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-7f9b30e1 | (진입점 미연결) | SSP0060_ShipmentPlan.cs:4617 |  | RETURN | return bFlag; |  | 처리 중단/반환 |  |  |  |

## SSP0060_ShipmentPlan.GetErpIFCheckNew

진입점: SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPIFBlockYn()) ▸ try ▸ try ▸ for (i <= siDetail.ActiveSheet.RowCount - 1) ▸ if (action != CAppSetting.FlagI) ▸ if (string.IsNullOrWhiteSpace(erpSoNo)) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "S") ▸ if (!string.IsNullOrWhiteSpace(sRequestNo))] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-91defa1d | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… 외 1 | SSP0060_ShipmentPlan.cs:4629 | try | CALL_EXT | service.FN_ERP_UIWebService | (RequestNo, "C", "") | ⚠ 의미 확인 필요 |  |  |  |
| AC-0bfe1002 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… 외 1 | SSP0060_ShipmentPlan.cs:4638 | try ▸ if (service.RtFlag == "S_E" \|\| service.RtFlag == "E") ▸ if (service.ReErrorMsg.EndsWith("^")) | UI_PROP | service.ReErrorMsg | service.ReErrorMsg.Substring(0, service.ReErrorMsg.Length - 1) | 속성 ReErrorMsg 설정 |  |  |  |
| AC-7b970dca | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… 외 1 | SSP0060_ShipmentPlan.cs:4645 | try ▸ if (service.RtFlag == "S_E" \|\| service.RtFlag == "E") ▸ for (iCount < arrReMsg.Length) | DATA_OP | errConfirmList.Add | (arrReMsg[iCount] + ":" + RequestNo) | 데이터 객체 조작/조회 |  |  |  |
| AC-b9600492 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… 외 1 | SSP0060_ShipmentPlan.cs:4649 | try ▸ if (service.RtFlag == "S_E" \|\| service.RtFlag == "E") ▸ for (iCount < arrReMsg.Length) | DATA_OP | errConfrimList2.Add | (arrConfirm[0].ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-e5adf4b6 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… 외 1 | SSP0060_ShipmentPlan.cs:4657 | try ▸ if (service.RtFlag == "S_E" \|\| service.RtFlag == "E") | ENDPOINT | new FoxDataRequest | ("SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM") ⇒ SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM | 엔드포인트 요청 생성 |  |  |  |
| AC-41c18d0c | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… 외 1 | SSP0060_ShipmentPlan.cs:4659 | try ▸ if (service.RtFlag == "S_E" \|\| service.RtFlag == "E") | DATA_OP | request.Parameters["p_confirm_id"] | p_confirm_id | 행/컬럼 값 대입 |  |  |  |
| AC-3da88d37 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… 외 1 | SSP0060_ShipmentPlan.cs:4660 | try ▸ if (service.RtFlag == "S_E" \|\| service.RtFlag == "E") | DATA_OP | request.Parameters["p_change_request_no"] | p_change_request_no | 행/컬럼 값 대입 |  |  |  |
| AC-6943b290 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… 외 1 | SSP0060_ShipmentPlan.cs:4661 | try ▸ if (service.RtFlag == "S_E" \|\| service.RtFlag == "E") | DATA_OP | request.Parameters["p_del_flag"] | "D" | 행/컬럼 값 대입 |  |  |  |
| AC-98537579 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… 외 1 | SSP0060_ShipmentPlan.cs:4662 | try ▸ if (service.RtFlag == "S_E" \|\| service.RtFlag == "E") | DATA_OP | request.Parameters["p_last_updated_by"] | UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-5b182182 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… 외 1 | SSP0060_ShipmentPlan.cs:4663 | try ▸ if (service.RtFlag == "S_E" \|\| service.RtFlag == "E") | DATA_OP | request.Parameters["p_time_zone"] | UserInfoContext.Current[UserInfoProperites.TimeZone] | 행/컬럼 값 대입 |  |  |  |
| AC-0f62d90b | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… 외 1 | SSP0060_ShipmentPlan.cs:4664 | try ▸ if (service.RtFlag == "S_E" \|\| service.RtFlag == "E") | DATA_OP | request.Parameters["p_if_send_flag"] | "Y" | 행/컬럼 값 대입 |  |  |  |
| AC-d0d722e4 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… 외 1 | SSP0060_ShipmentPlan.cs:4665 | try ▸ if (service.RtFlag == "S_E" \|\| service.RtFlag == "E") | DATA_OP | request.Parameters["p_change_type"] | "C" | 행/컬럼 값 대입 |  |  |  |
| AC-32b95141 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… 외 1 | SSP0060_ShipmentPlan.cs:4667 | try ▸ if (service.RtFlag == "S_E" \|\| service.RtFlag == "E") | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-ea892500 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… 외 1 | SSP0060_ShipmentPlan.cs:4683 | try ▸ if (service.RtFlag == "S_E" \|\| service.RtFlag == "E") ▸ else of (service.RtFlag == "E") ▸ if (service.RtFlag == "S_E") | ENDPOINT | new FoxDataRequest | ("SSP.PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH") ⇒ SSP.PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH | 엔드포인트 요청 생성 |  |  |  |
| AC-8adb7ff4 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… 외 1 | SSP0060_ShipmentPlan.cs:4685 | try ▸ if (service.RtFlag == "S_E" \|\| service.RtFlag == "E") ▸ else of (service.RtFlag == "E") ▸ if (service.RtFlag == "S_E") | DATA_OP | request.Parameters["p_change_type"] | "B" | 행/컬럼 값 대입 |  |  |  |
| AC-71004e07 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… 외 1 | SSP0060_ShipmentPlan.cs:4686 | try ▸ if (service.RtFlag == "S_E" \|\| service.RtFlag == "E") ▸ else of (service.RtFlag == "E") ▸ if (service.RtFlag == "S_E") | DATA_OP | request.Parameters["p_change_req_no"] | RequestNo | 행/컬럼 값 대입 |  |  |  |
| AC-3f5094a3 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… 외 1 | SSP0060_ShipmentPlan.cs:4688 | try ▸ if (service.RtFlag == "S_E" \|\| service.RtFlag == "E") ▸ else of (service.RtFlag == "E") ▸ if (service.RtFlag == "S_E") | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-8748bdc9 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… 외 1 | SSP0060_ShipmentPlan.cs:4693 | try ▸ if (service.RtFlag == "S_E" \|\| service.RtFlag == "E") ▸ else of (service.RtFlag == "E") ▸ if (service.RtFlag == "S_E") | CALL_EXT | service.FN_ERP_UIWebService | (RequestNo, "C", "") | ⚠ 의미 확인 필요 |  |  |  |
| AC-1345e257 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… 외 1 | SSP0060_ShipmentPlan.cs:4699 | try ▸ if (service.RtFlag == "S_E" \|\| service.RtFlag == "E") | DATA_OP | bActiveList.Add | (bFlag) | 데이터 객체 조작/조회 |  |  |  |
| AC-2f619f4e | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… 외 1 | SSP0060_ShipmentPlan.cs:4704 | try ▸ else of (service.RtFlag == "S_E" \|\| service.RtFlag == "E") ▸ if (service.RtFlag == "F" \|\| service.RtFlag == "C_E") | FLAG | F_CE_requestNo | RequestNo | 화면 필드/플래그 변경 |  |  |  |
| AC-45866c01 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… 외 1 | SSP0060_ShipmentPlan.cs:4713 | try ▸ else of (service.RtFlag == "S_E" \|\| service.RtFlag == "E") ▸ else of (service.RtFlag == "F" \|\| service.RtFlag == "C_E") | ENDPOINT | new FoxDataRequest | ("SSP.PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH") ⇒ SSP.PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH | 엔드포인트 요청 생성 |  |  |  |
| AC-104ff5b5 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… 외 1 | SSP0060_ShipmentPlan.cs:4715 | try ▸ else of (service.RtFlag == "S_E" \|\| service.RtFlag == "E") ▸ else of (service.RtFlag == "F" \|\| service.RtFlag == "C_E") | DATA_OP | request.Parameters["p_change_type"] | "B" | 행/컬럼 값 대입 |  |  |  |
| AC-cbf829aa | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… 외 1 | SSP0060_ShipmentPlan.cs:4716 | try ▸ else of (service.RtFlag == "S_E" \|\| service.RtFlag == "E") ▸ else of (service.RtFlag == "F" \|\| service.RtFlag == "C_E") | DATA_OP | request.Parameters["p_change_req_no"] | RequestNo | 행/컬럼 값 대입 |  |  |  |
| AC-21b7f9ba | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… 외 1 | SSP0060_ShipmentPlan.cs:4718 | try ▸ else of (service.RtFlag == "S_E" \|\| service.RtFlag == "E") ▸ else of (service.RtFlag == "F" \|\| service.RtFlag == "C_E") | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-14954d6d | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… 외 1 | SSP0060_ShipmentPlan.cs:4723 | try ▸ else of (service.RtFlag == "S_E" \|\| service.RtFlag == "E") ▸ else of (service.RtFlag == "F" \|\| service.RtFlag == "C_E") | CALL_EXT | service.FN_ERP_UIWebService | (RequestNo, "C", "") | ⚠ 의미 확인 필요 |  |  |  |
| AC-1ea6e591 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… 외 1 | SSP0060_ShipmentPlan.cs:4726 | try ▸ else of (service.RtFlag == "S_E" \|\| service.RtFlag == "E") ▸ else of (service.RtFlag == "F" \|\| service.RtFlag == "C_E") | DATA_OP | bActiveList.Add | (bFlag) | 데이터 객체 조작/조회 |  |  |  |
| AC-015b9bee | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… 외 1 | SSP0060_ShipmentPlan.cs:4732 |  | RETURN | return bFlag; |  | 처리 중단/반환 |  |  |  |

## SSP0060_ShipmentPlan.GetErpIFCheckNew_

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a67386d2 | (진입점 미연결) | SSP0060_ShipmentPlan.cs:5033 | try | CALL_EXT | service.FN_ERP_UIWebService | (RequestNo, "P", "A") | ⚠ 의미 확인 필요 |  |  |  |
| AC-48a70448 | (진입점 미연결) | SSP0060_ShipmentPlan.cs:5042 | try ▸ if (service.RtFlag == "E" \|\| service.RtFlag == "F" \|\| service.RtFlag == "C_E") | ENDPOINT | new FoxDataRequest | ("SSP.SSP0060_DELETE_SHIPMENT_REQUEST_DRAFTING") ⇒ SSP.SSP0060_DELETE_SHIPMENT_REQUEST_DRAFTING | 엔드포인트 요청 생성 |  |  |  |
| AC-670020c7 | (진입점 미연결) | SSP0060_ShipmentPlan.cs:5043 | try ▸ if (service.RtFlag == "E" \|\| service.RtFlag == "F" \|\| service.RtFlag == "C_E") | DATA_OP | request.Parameters["p_change_request_no"] | p_change_request_no | 행/컬럼 값 대입 |  |  |  |
| AC-88187fb3 | (진입점 미연결) | SSP0060_ShipmentPlan.cs:5044 | try ▸ if (service.RtFlag == "E" \|\| service.RtFlag == "F" \|\| service.RtFlag == "C_E") | DATA_OP | request.Parameters["p_user_id"] | UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-c60d9b74 | (진입점 미연결) | SSP0060_ShipmentPlan.cs:5046 | try ▸ if (service.RtFlag == "E" \|\| service.RtFlag == "F" \|\| service.RtFlag == "C_E") | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-34907f30 | (진입점 미연결) | SSP0060_ShipmentPlan.cs:5057 | try ▸ if (service.RtFlag == "E") | MESSAGE | MessageHelper.GMessageBox | ("MSG00197", new object[] { arg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3a27276a | (진입점 미연결) | SSP0060_ShipmentPlan.cs:5064 | try ▸ else of (service.RtFlag == "E") ▸ if (service.RtFlag == "F") | MESSAGE | MessageHelper.GMessageBox | ("MSG00204", new object[] { arg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8e6eba63 | (진입점 미연결) | SSP0060_ShipmentPlan.cs:5069 | try ▸ else of (service.RtFlag == "E") ▸ else of (service.RtFlag == "F") ▸ if (service.RtFlag == "C_E") | MESSAGE | MessageHelper.GMessageBox | ("MSG00306", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-14617f86 | (진입점 미연결) | SSP0060_ShipmentPlan.cs:5080 |  | RETURN | return bFlag; |  | 처리 중단/반환 |  |  |  |

## SSP0060_ShipmentPlan.GetERPInterface

진입점: SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPIFBlockYn()) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0bf43646 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:3863 | try ▸ for (i <= siDetail.ActiveSheet.RowCount - 1) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM \|\| action == CAppSet… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-5dfff646 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:3875 | try ▸ for (i <= siDetail.ActiveSheet.RowCount - 1) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM \|\| action == CAppSet… | DATA_OP | (siDetail.ActiveSheet.DataSource as DataSet).Tables[0].Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-2b23eaf9 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:3881 | try ▸ for (i <= siDetail.ActiveSheet.RowCount - 1) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM \|\| action == CAppSet… | MESSAGE | MessageHelper.GMessageBox | ("MSG00247", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-79e9e53b | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:3882 | try ▸ for (i <= siDetail.ActiveSheet.RowCount - 1) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM \|\| action == CAppSet… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-ee81955d | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:3890 | try ▸ for (i <= siDetail.ActiveSheet.RowCount - 1) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM \|\| action == CAppSet… | MESSAGE | GSCM.App.Core.Text.MessageHelper.GMessageBox | ("MSG00049", new object[] { "" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-4ad2c7c4 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:3891 | try ▸ for (i <= siDetail.ActiveSheet.RowCount - 1) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM \|\| action == CAppSet… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-2d92eda6 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:3905 | try ▸ if (!string.IsNullOrEmpty(p_confirm_id)) ▸ if (!isResult) | MESSAGE | MessageHelper.GMessageBox | ("MSG00404", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6bedea59 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:3907 | try ▸ if (!string.IsNullOrEmpty(p_confirm_id)) ▸ if (!isResult) | RETURN | return bReturn = false; |  | 처리 중단/반환 |  |  |  |
| AC-8c3ac09a | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:3990 | try ▸ if (errConfirmList.Count > 0) | ENDPOINT | new FoxDataRequest | ("SSP.SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM") ⇒ SSP.SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM | 엔드포인트 요청 생성 |  |  |  |
| AC-fb19ed45 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:3992 | try ▸ if (errConfirmList.Count > 0) | DATA_OP | request.Parameters["p_change_request_no"] | p_change_request_no | 행/컬럼 값 대입 |  |  |  |
| AC-9d9d382a | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:3993 | try ▸ if (errConfirmList.Count > 0) | DATA_OP | request.Parameters["p_confirm_id"] | p_confirm_id2 | 행/컬럼 값 대입 |  |  |  |
| AC-e498d55d | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:3994 | try ▸ if (errConfirmList.Count > 0) | DATA_OP | request.Parameters["p_e_type"] | "E" | 행/컬럼 값 대입 |  |  |  |
| AC-3582397c | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:3995 | try ▸ if (errConfirmList.Count > 0) | DATA_OP | request.Parameters["p_e_message"] | p_e_message | 행/컬럼 값 대입 |  |  |  |
| AC-241570c8 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:3996 | try ▸ if (errConfirmList.Count > 0) | DATA_OP | request.Parameters["p_last_updated_by"] | UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-701666e9 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:3998 | try ▸ if (errConfirmList.Count > 0) | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-4a79bd20 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:4004 | try ▸ if (errConfirmList.Count > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00197", new object[] { arg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-87829b99 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:4031 | try ▸ else of (errConfirmList.Count > 0) ▸ if (String.IsNullOrEmpty(F_CE_requestNo) == false) ▸ if (p_confirm_id_F_CE.Length > 0) | ENDPOINT | new FoxDataRequest | ("SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM") ⇒ SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM | 엔드포인트 요청 생성 |  |  |  |
| AC-9b2bc3a3 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:4033 | try ▸ else of (errConfirmList.Count > 0) ▸ if (String.IsNullOrEmpty(F_CE_requestNo) == false) ▸ if (p_confirm_id_F_CE.Length > 0) | DATA_OP | request.Parameters["p_confirm_id"] | p_confirm_id_F_CE | 행/컬럼 값 대입 |  |  |  |
| AC-ab07ab43 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:4034 | try ▸ else of (errConfirmList.Count > 0) ▸ if (String.IsNullOrEmpty(F_CE_requestNo) == false) ▸ if (p_confirm_id_F_CE.Length > 0) | DATA_OP | request.Parameters["p_change_request_no"] | F_CE_requestNo | 행/컬럼 값 대입 |  |  |  |
| AC-3ab83318 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:4035 | try ▸ else of (errConfirmList.Count > 0) ▸ if (String.IsNullOrEmpty(F_CE_requestNo) == false) ▸ if (p_confirm_id_F_CE.Length > 0) | DATA_OP | request.Parameters["p_del_flag"] | "D" | 행/컬럼 값 대입 |  |  |  |
| AC-0f6e5dc8 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:4036 | try ▸ else of (errConfirmList.Count > 0) ▸ if (String.IsNullOrEmpty(F_CE_requestNo) == false) ▸ if (p_confirm_id_F_CE.Length > 0) | DATA_OP | request.Parameters["p_last_updated_by"] | UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-f3e37f85 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:4037 | try ▸ else of (errConfirmList.Count > 0) ▸ if (String.IsNullOrEmpty(F_CE_requestNo) == false) ▸ if (p_confirm_id_F_CE.Length > 0) | DATA_OP | request.Parameters["p_time_zone"] | UserInfoContext.Current[UserInfoProperites.TimeZone] | 행/컬럼 값 대입 |  |  |  |
| AC-2cd1cd2c | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:4038 | try ▸ else of (errConfirmList.Count > 0) ▸ if (String.IsNullOrEmpty(F_CE_requestNo) == false) ▸ if (p_confirm_id_F_CE.Length > 0) | DATA_OP | request.Parameters["p_if_send_flag"] | "Y" | 행/컬럼 값 대입 |  |  |  |
| AC-34386701 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:4039 | try ▸ else of (errConfirmList.Count > 0) ▸ if (String.IsNullOrEmpty(F_CE_requestNo) == false) ▸ if (p_confirm_id_F_CE.Length > 0) | DATA_OP | request.Parameters["p_change_type"] | "C" | 행/컬럼 값 대입 |  |  |  |
| AC-364995c7 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:4041 | try ▸ else of (errConfirmList.Count > 0) ▸ if (String.IsNullOrEmpty(F_CE_requestNo) == false) ▸ if (p_confirm_id_F_CE.Length > 0) | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-e4b46a25 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:4047 | try ▸ else of (errConfirmList.Count > 0) ▸ if (String.IsNullOrEmpty(F_CE_requestNo) == false) ▸ if (p_confirm_id_F_CE.Length > 0) | CALL_EXT | service.FN_ERP_UIWebService | (F_CE_requestNo, "C", "") | ⚠ 의미 확인 필요 |  |  |  |
| AC-cf1f8eed | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:4052 | try ▸ else of (errConfirmList.Count > 0) ▸ if (String.IsNullOrEmpty(F_CE_requestNo) == false) | MESSAGE | MessageHelper.GMessageBox | ("MSG00204", new object[] { arg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8a1f3e61 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:4057 | catch ((Exception ex)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-04319f7c | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:4060 | finally | STATE_RESET | bActiveList.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-1f326461 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:4061 | finally | STATE_RESET | errConfirmList.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-14bd6562 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:4062 | finally | FLAG | F_CE_requestNo | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-60c33df0 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:4064 |  | RETURN | return bReturn; |  | 처리 중단/반환 |  |  |  |

## SSP0060_ShipmentPlan.GetErpSoNoCnt

진입점: SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPIFBlockYn()) ▸ try ▸ try ▸ for (i <= siDetail.ActiveSheet.RowCount - 1) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM \|\| action == CAppSetting.FlagD) ▸ if (!string.IsNullOrWhiteSpace(erpSoNo))] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6d399a1a | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… 외 1 | SSP0060_ShipmentPlan.cs:4481 | try | ENDPOINT | new FoxDataRequest | ("SSP.SSP0060_GET_ERP_SO_NO_CNT") ⇒ SSP.SSP0060_GET_ERP_SO_NO_CNT | 엔드포인트 요청 생성 |  |  |  |
| AC-adfba53e | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… 외 1 | SSP0060_ShipmentPlan.cs:4482 | try | DATA_OP | request.Parameters["p_division_id"] | sDivisionID | 행/컬럼 값 대입 |  |  |  |
| AC-0f8360f1 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… 외 1 | SSP0060_ShipmentPlan.cs:4483 | try | DATA_OP | request.Parameters["p_erp_so_no"] | sErpSoNo | 행/컬럼 값 대입 |  |  |  |
| AC-0f31469f | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… 외 1 | SSP0060_ShipmentPlan.cs:4485 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-faab4d13 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… 외 1 | SSP0060_ShipmentPlan.cs:4491 | try ▸ if (ds.Tables[0].Rows.Count > 0) | CALL_EXT | CommonUtils.GetValueInt | (ds.Tables[0].Rows[0]["CNT"]) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ed4a7939 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… 외 1 | SSP0060_ShipmentPlan.cs:4493 | catch ((Exception ex)) | RETURN | return iReturn; |  | 처리 중단/반환 |  |  |  |
| AC-73fde3c6 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… 외 1 | SSP0060_ShipmentPlan.cs:4495 |  | RETURN | return iReturn; |  | 처리 중단/반환 |  |  |  |

## SSP0060_ShipmentPlan.GetFilteredDs

진입점: this.chkTotPSI.CheckedChanged [try] / FindButton [try] / SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c4925c7b | this.chkTotPSI.CheckedChanged [try] 외 2 | SSP0060_ShipmentPlan.cs:5183 |  | DATA_OP | row.Field | ("SEQ") | 데이터 객체 조작/조회 |  |  |  |
| AC-d36a1eb4 | this.chkTotPSI.CheckedChanged [try] 외 2 | SSP0060_ShipmentPlan.cs:5184 |  | DATA_OP | row.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-032486ac | this.chkTotPSI.CheckedChanged [try] 외 2 | SSP0060_ShipmentPlan.cs:5185 |  | DATA_OP | row.Field | ("FROM_SITE") | 데이터 객체 조작/조회 |  |  |  |
| AC-95bd9326 | this.chkTotPSI.CheckedChanged [try] 외 2 | SSP0060_ShipmentPlan.cs:5186 |  | DATA_OP | row.Field | ("PRODUCT_LEVEL1") | 데이터 객체 조작/조회 |  |  |  |
| AC-7d705356 | this.chkTotPSI.CheckedChanged [try] 외 2 | SSP0060_ShipmentPlan.cs:5187 |  | DATA_OP | row.Field | ("ORD_SEQ") | 데이터 객체 조작/조회 |  |  |  |
| AC-3259034f | this.chkTotPSI.CheckedChanged [try] 외 2 | SSP0060_ShipmentPlan.cs:5188 |  | DATA_OP | row.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-a4beea7f | this.chkTotPSI.CheckedChanged [try] 외 2 | SSP0060_ShipmentPlan.cs:5189 |  | DATA_OP | row.Field | ("SEQ") | 데이터 객체 조작/조회 |  |  |  |
| AC-7c122669 | this.chkTotPSI.CheckedChanged [try] 외 2 | SSP0060_ShipmentPlan.cs:5190 |  | DATA_OP | row.Field | ("TO_SITE") | 데이터 객체 조작/조회 |  |  |  |
| AC-ea570b77 | this.chkTotPSI.CheckedChanged [try] 외 2 | SSP0060_ShipmentPlan.cs:5191 |  | DATA_OP | row.Field | ("TRANSPORT_MODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-e8d65891 | this.chkTotPSI.CheckedChanged [try] 외 2 | SSP0060_ShipmentPlan.cs:5192 |  | DATA_OP | row.Field | ("INCOTERMS") | 데이터 객체 조작/조회 |  |  |  |
| AC-aa88af87 | this.chkTotPSI.CheckedChanged [try] 외 2 | SSP0060_ShipmentPlan.cs:5193 |  | DATA_OP | row.Field | ("FCST_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-6f3dca8e | this.chkTotPSI.CheckedChanged [try] 외 2 | SSP0060_ShipmentPlan.cs:5195 |  | CALL_EXT | query.AsDataView | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-ee36a7cd | this.chkTotPSI.CheckedChanged [try] 외 2 | SSP0060_ShipmentPlan.cs:5196 |  | RETURN | return dv; |  | 처리 중단/반환 |  |  |  |

## SSP0060_ShipmentPlan.GetNERPCode

진입점: clbDivision_ID.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-34f58608 | clbDivision_ID.SelectedIndexChanged | SSP0060_ShipmentPlan.cs:7149 | try | ENDPOINT | new FoxDataRequest | ("SSP.SSP0002_GET_NERP_CODE") ⇒ SSP.SSP0002_GET_NERP_CODE | 엔드포인트 요청 생성 |  |  |  |
| AC-cb4e5778 | clbDivision_ID.SelectedIndexChanged | SSP0060_ShipmentPlan.cs:7150 | try | DATA_OP | request.Parameters["P_PROCEDURE_KEY"] | sFileName | 행/컬럼 값 대입 |  |  |  |
| AC-450452eb | clbDivision_ID.SelectedIndexChanged | SSP0060_ShipmentPlan.cs:7151 | try | DATA_OP | request.Parameters["P_SEQUENCE"] | sGERPCode | 행/컬럼 값 대입 |  |  |  |
| AC-f2e4deeb | clbDivision_ID.SelectedIndexChanged | SSP0060_ShipmentPlan.cs:7153 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-7eac0508 | clbDivision_ID.SelectedIndexChanged | SSP0060_ShipmentPlan.cs:7161 | catch ((Exception ex)) | RETURN | return sReturn; |  | 처리 중단/반환 |  |  |  |
| AC-9236d67f | clbDivision_ID.SelectedIndexChanged | SSP0060_ShipmentPlan.cs:7163 |  | RETURN | return sReturn; |  | 처리 중단/반환 |  |  |  |

## SSP0060_ShipmentPlan.GetNewERPInterface

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dce2611e | (진입점 미연결) | SSP0060_ShipmentPlan.cs:4767 | try ▸ for (i <= siDetail.ActiveSheet.RowCount - 1) ▸ if (action == CAppSetting.FlagI) ▸ if (!string.IsNullOrWhiteSpace(erpSoNo)) | DATA_OP | (siDetail.ActiveSheet.DataSource as DataSet).Tables[0].Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-d051495f | (진입점 미연결) | SSP0060_ShipmentPlan.cs:4779 | try ▸ for (i <= siDetail.ActiveSheet.RowCount - 1) ▸ if (action == CAppSetting.FlagI) ▸ if (!string.IsNullOrWhiteSpace(erpSoNo)) ▸ if (iErpS… | MESSAGE | MessageHelper.GMessageBox | ("MSG00247", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c9c12bc1 | (진입점 미연결) | SSP0060_ShipmentPlan.cs:4780 | try ▸ for (i <= siDetail.ActiveSheet.RowCount - 1) ▸ if (action == CAppSetting.FlagI) ▸ if (!string.IsNullOrWhiteSpace(erpSoNo)) ▸ if (iErpS… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-604f2b95 | (진입점 미연결) | SSP0060_ShipmentPlan.cs:4789 | try ▸ for (i <= siDetail.ActiveSheet.RowCount - 1) ▸ if (action == CAppSetting.FlagI) ▸ if (DateTime.TryParse(siDetail.GetText(i, siDetail.G… | MESSAGE | GSCM.App.Core.Text.MessageHelper.GMessageBox | ("MSG00049", new object[] { "" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-eeb19641 | (진입점 미연결) | SSP0060_ShipmentPlan.cs:4790 | try ▸ for (i <= siDetail.ActiveSheet.RowCount - 1) ▸ if (action == CAppSetting.FlagI) ▸ if (DateTime.TryParse(siDetail.GetText(i, siDetail.G… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-20e13dca | (진입점 미연결) | SSP0060_ShipmentPlan.cs:4816 | try ▸ for (i <= siDetail.ActiveSheet.RowCount - 1) ▸ if (string.IsNullOrWhiteSpace(erpSoNo)) ▸ if (this.NewNonSoNo(i, action) == false) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-111e9fd6 | (진입점 미연결) | SSP0060_ShipmentPlan.cs:4825 | catch ((Exception ex)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-242bb694 | (진입점 미연결) | SSP0060_ShipmentPlan.cs:4827 |  | RETURN | return bReturn; |  | 처리 중단/반환 |  |  |  |

## SSP0060_ShipmentPlan.GetShipmentStatusChk

진입점: SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPIFBlockYn()) ▸ try ▸ try ▸ for (i <= siDetail.ActiveSheet.RowCount - 1) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM \|\| action == CAppSetting.FlagD) ▸ if (action != CAppSetting.FlagI)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5773b799 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:4506 | try | ENDPOINT | new FoxDataRequest | ("SSP.SSP0060_GET_SHIPMENT_STATUS") ⇒ SSP.SSP0060_GET_SHIPMENT_STATUS | 엔드포인트 요청 생성 |  |  |  |
| AC-bb02b7cd | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:4507 | try | DATA_OP | request.Parameters["p_division_id"] | sDivisionID | 행/컬럼 값 대입 |  |  |  |
| AC-09f6ed4d | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:4508 | try | DATA_OP | request.Parameters["p_confirm_id"] | sConfirmID | 행/컬럼 값 대입 |  |  |  |
| AC-887341d0 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:4510 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-82aba334 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:4525 | try ▸ if (ds.Tables[0].Rows.Count > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00248", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-fbd2e1a3 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:4539 | try ▸ if (ds.Tables[1].Rows.Count > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00249", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b9d47ecb | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:4554 | try ▸ if (ds.Tables[2].Rows.Count > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00189", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e0fd6a3b | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:4558 | catch ((Exception ex)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-320df625 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:4560 |  | RETURN | return bReturn; |  | 처리 중단/반환 |  |  |  |

## SSP0060_ShipmentPlan.GetSpdTitle

진입점: this.Load / this.chkTotPSI.CheckedChanged [try] / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (fps.Name == "spdMain")] / this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 0) ▸ try] / this.spdMain.CellDoubleClick / clbCompany_ID.SelectedIndexChanged / cboPlanDate.SelectedIndexChanged [if (cboPlanDate.ControlValues != null) ▸ if (dr.ItemArray.Count() > 0) ▸ if (!string.IsNullOrWhiteSpace(drpPeriod.Text1) && !string.IsNullOrWhiteSpace(drpPeriod.Text2))] / FindButton [try] / SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6fda42aa | this.Load 외 8 | SSP0060_ShipmentPlan.cs:7449 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN") ⇒ SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | 엔드포인트 요청 생성 |  |  |  |
| AC-0470f3f1 | this.Load 외 8 | SSP0060_ShipmentPlan.cs:7453 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | drpPeriod.Text1.Replace("-", "") | 행/컬럼 값 대입 |  |  |  |
| AC-787f4157 | this.Load 외 8 | SSP0060_ShipmentPlan.cs:7454 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | drpPeriod.Text2.Replace("-", "") | 행/컬럼 값 대입 |  |  |  |
| AC-02fac01f | this.Load 외 8 | SSP0060_ShipmentPlan.cs:7459 |  | FLAG | dsSpdTitle | client.ExecuteDataSet(request).DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-545d2fb0 | this.Load 외 8 | SSP0060_ShipmentPlan.cs:7459 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## SSP0060_ShipmentPlan.GetSSPUserCheck

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f9e12bdb | EditButton | SSP0060_ShipmentPlan.cs:8017 |  | ENDPOINT | new FoxDataRequest | ("SSP.SSP0002_GET_USER_INFO_LIST") ⇒ SSP.SSP0002_GET_USER_INFO_LIST | 엔드포인트 요청 생성 |  |  |  |
| AC-c225fc78 | EditButton | SSP0060_ShipmentPlan.cs:8021 |  | DATA_OP | request.Parameters["Search"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-ef7be8c6 | EditButton | SSP0060_ShipmentPlan.cs:8022 |  | DATA_OP | request.Parameters["Language"] | UserInfoContext.Current[UserInfoProperites.Language].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-fc125809 | EditButton | SSP0060_ShipmentPlan.cs:8023 |  | DATA_OP | request.Parameters["SSOUserYN"] | "N" | 행/컬럼 값 대입 |  |  |  |
| AC-ca7c0557 | EditButton | SSP0060_ShipmentPlan.cs:8024 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-d06892bb | EditButton | SSP0060_ShipmentPlan.cs:8028 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a4e1deb5 | EditButton | SSP0060_ShipmentPlan.cs:8032 |  | RETURN | return isResult; |  | 처리 중단/반환 |  |  |  |

## SSP0060_ShipmentPlan.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-783df986 | this.Load | SSP0060_ShipmentPlan.cs:443 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-e0091f3a | this.Load | SSP0060_ShipmentPlan.cs:446 |  | DATA_OP | this.ConditionNotUseList.Add | (cboPlanDate) | 데이터 객체 조작/조회 |  |  |  |
| AC-27762f43 | this.Load | SSP0060_ShipmentPlan.cs:449 |  | DATA_OP | ReadOnlySheetList.Add | (SpdSheet.shtMain) | 데이터 객체 조작/조회 |  |  |  |
| AC-90b782ea | this.Load | SSP0060_ShipmentPlan.cs:450 |  | DATA_OP | ReadOnlySheetList.Add | (SpdSheet.shtPlanDetail) | 데이터 객체 조작/조회 |  |  |  |
| AC-c22ef1d0 | this.Load | SSP0060_ShipmentPlan.cs:451 |  | DATA_OP | ReadOnlySheetList.Add | (SpdSheet.shtStockDetail) | 데이터 객체 조작/조회 |  |  |  |
| AC-94df5f01 | this.Load | SSP0060_ShipmentPlan.cs:452 |  | DATA_OP | ReadOnlySheetList.Add | (SpdSheet.shtoWMSDetail) | 데이터 객체 조작/조회 |  |  |  |
| AC-e1a13194 | this.Load | SSP0060_ShipmentPlan.cs:453 |  | DATA_OP | ReadOnlySheetList.Add | (SpdSheet.shtMESStock) | 데이터 객체 조작/조회 |  |  |  |
| AC-171bffc9 | this.Load | SSP0060_ShipmentPlan.cs:454 |  | DATA_OP | ReadOnlySheetList.Add | (SpdSheet.shtMESStockDetail) | 데이터 객체 조작/조회 |  |  |  |
| AC-07d4f826 | this.Load | SSP0060_ShipmentPlan.cs:456 |  | FLAG | sLanguage | UserInfoContext.Current[UserInfoProperites.Language] | 화면 필드/플래그 변경 |  |  |  |
| AC-8d9c7b45 | this.Load | SSP0060_ShipmentPlan.cs:459 |  | VALUE_SET | drpPeriod3.InitValue | ShipmentResult_GetDayRange() | 컨트롤 값 설정 |  |  |  |
| AC-a388db87 | this.Load | SSP0060_ShipmentPlan.cs:461 |  | FLAG | dtBucketType | GetBucketType() | 화면 필드/플래그 변경 |  |  |  |
| AC-56ce8af7 | this.Load | SSP0060_ShipmentPlan.cs:462 |  | LIST_REBIND | clsCtrl.setListBox | (dtBucketType, cboBucketType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-11d688bb | this.Load | SSP0060_ShipmentPlan.cs:465 |  | DATA_OP | dtPgmAuthId.Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-abd5956c | this.Load | SSP0060_ShipmentPlan.cs:468 | if (dtBaseDay.Rows.Count > 0) | FLAG | dDay | CommonUtils.GetValueDouble(dtBaseDay.Rows[0][1]) | 화면 필드/플래그 변경 |  |  |  |
| AC-dd772aba | this.Load | SSP0060_ShipmentPlan.cs:468 | if (dtBaseDay.Rows.Count > 0) | CALL_EXT | CommonUtils.GetValueDouble | (dtBaseDay.Rows[0][1]) | ⚠ 의미 확인 필요 |  |  |  |
| AC-4e9f94c7 | this.Load | SSP0060_ShipmentPlan.cs:470 |  | FLAG | dBaseDate | Convert.ToDateTime(Convert.ToDateTime(DateTime.Now).ToString()).AddDays(dDay) | 화면 필드/플래그 변경 |  |  |  |
| AC-3aec4938 | this.Load | SSP0060_ShipmentPlan.cs:475 | if (drPgmAuthId != null) | FLAG | bEdit_Auth | true | 화면 필드/플래그 변경 |  |  |  |
| AC-ae7b0bb9 | this.Load | SSP0060_ShipmentPlan.cs:476 | if (drPgmAuthId != null) | UI_PROP | lcbtnSimulation.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-25844f51 | this.Load | SSP0060_ShipmentPlan.cs:480 | else of (drPgmAuthId != null) | FLAG | bEdit_Auth | false | 화면 필드/플래그 변경 |  |  |  |
| AC-99a7d05a | this.Load | SSP0060_ShipmentPlan.cs:481 | else of (drPgmAuthId != null) | UI_PROP | lcbtnSimulation.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-4acae1e4 | this.Load | SSP0060_ShipmentPlan.cs:486 | if (dtShipmentInputPeriod.Rows.Count > 0) | FLAG | dateMaxShipDate | Convert.ToDateTime(dtShipmentInputPeriod.Rows[0]["VALUE"].ToString()) | 화면 필드/플래그 변경 |  |  |  |
| AC-68c935ec | this.Load | SSP0060_ShipmentPlan.cs:487 | if (dtShipmentInputPeriod.Rows.Count > 0) | FLAG | dateMinShipDate | Convert.ToDateTime(dtShipmentInputPeriod.Rows[1]["VALUE"].ToString()) | 화면 필드/플래그 변경 |  |  |  |
| AC-79551413 | this.Load | SSP0060_ShipmentPlan.cs:488 | if (dtShipmentInputPeriod.Rows.Count > 0) | FLAG | strDiffMaxDay | dtShipmentInputPeriod.Rows[0]["Diff_VALUE"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-ee534052 | this.Load | SSP0060_ShipmentPlan.cs:489 | if (dtShipmentInputPeriod.Rows.Count > 0) | FLAG | strDiffMinDay | dtShipmentInputPeriod.Rows[1]["Diff_VALUE"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-f0eb8055 | this.Load | SSP0060_ShipmentPlan.cs:491 |  | FLAG | sRequestor | UserInfoContext.Current.UserId | 화면 필드/플래그 변경 |  |  |  |
| AC-27f4a857 | this.Load | SSP0060_ShipmentPlan.cs:496 |  | LIST_REBIND | clsCtrl.setListBox | (dtResultType, clbResultType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-fce79203 | this.Load | SSP0060_ShipmentPlan.cs:497 |  | UI_PROP | layoutControlItem14.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-e2fe57c0 | this.Load | SSP0060_ShipmentPlan.cs:498 |  | UI_PROP | layoutControlItem13.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-ddb4cfec | this.Load | SSP0060_ShipmentPlan.cs:499 |  | UI_PROP | layoutControlItem17.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |

## SSP0060_ShipmentPlan.InitSpread

진입점: this.Load / this.chkTotPSI.CheckedChanged [try] / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (fps.Name == "spdMain")] / this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 0) ▸ try] / this.spdMain.CellDoubleClick / clbCompany_ID.SelectedIndexChanged / cboPlanDate.SelectedIndexChanged [if (cboPlanDate.ControlValues != null) ▸ if (dr.ItemArray.Count() > 0) ▸ if (!string.IsNullOrWhiteSpace(drpPeriod.Text1) && !string.IsNullOrWhiteSpace(drpPeriod.Text2))] / FindButton [try] / SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7460f39f | this.Load 외 8 | SSP0060_ShipmentPlan.cs:630 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.InitSheet | (SpdSheet.shtMain) | 그리드 재구성/초기화 |  |  |  |
| AC-5c901381 | this.Load 외 8 | SSP0060_ShipmentPlan.cs:631 | if (spdInfo.SheetName == SpdSheet.shtMain) | LIST_REBIND | SpreadInfo.SetComBoParam | ("PlantSiteByDivision", dtFromSite) | 목록 컨트롤 재구성 |  |  |  |
| AC-2dc000c1 | this.Load 외 8 | SSP0060_ShipmentPlan.cs:632 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.SetSheetHeaderColumn | (spdInfo, 3) | 그리드 재구성/초기화 |  |  |  |
| AC-36221915 | this.Load 외 8 | SSP0060_ShipmentPlan.cs:636 | if (spdInfo.SheetName == SpdSheet.shtMain) | CALL_EXT | clsCtrl.HeaderSpan | (siMain, 0, siMain.GetColumnIndex(DefColumns.BOH_TYPE), 3, 2, "BOH") | ⚠ 의미 확인 필요 |  |  |  |
| AC-c8b68f45 | this.Load 외 8 | SSP0060_ShipmentPlan.cs:645 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-758eef55 | this.Load 외 8 | SSP0060_ShipmentPlan.cs:648 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.Freeze | (0, spdInfo.GetColumnIndex(DefColumns.FCST_TYPE) + 1) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-11fb3be9 | this.Load 외 8 | SSP0060_ShipmentPlan.cs:649 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-c48e1349 | this.Load 외 8 | SSP0060_ShipmentPlan.cs:651 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Columns[DefColumns.PSI].MergePolicy | MergePolicy.Always | 그리드 속성/값 설정 |  |  |  |
| AC-4b4428b7 | this.Load 외 8 | SSP0060_ShipmentPlan.cs:652 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Columns[DefColumns.MEASURE_NAME].MergePolicy | MergePolicy.Always | 그리드 속성/값 설정 |  |  |  |
| AC-09f8dc48 | this.Load 외 8 | SSP0060_ShipmentPlan.cs:653 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Columns[DefColumns.TO_SITE].MergePolicy | MergePolicy.Always | 그리드 속성/값 설정 |  |  |  |
| AC-20a82e4c | this.Load 외 8 | SSP0060_ShipmentPlan.cs:654 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Columns[DefColumns.TRANSPORT_MODE].MergePolicy | MergePolicy.Always | 그리드 속성/값 설정 |  |  |  |
| AC-8ca5abc5 | this.Load 외 8 | SSP0060_ShipmentPlan.cs:655 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Columns[DefColumns.INCOTERMS].MergePolicy | MergePolicy.Always | 그리드 속성/값 설정 |  |  |  |
| AC-cfc533a8 | this.Load 외 8 | SSP0060_ShipmentPlan.cs:656 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Columns[DefColumns.FCST_TYPE].MergePolicy | MergePolicy.Always | 그리드 속성/값 설정 |  |  |  |
| AC-b36c3039 | this.Load 외 8 | SSP0060_ShipmentPlan.cs:660 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (spdInfo.SheetName == SpdSheet.shtPlanDetail) | GRID_INIT | spdInfo.InitSheet | (spdInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-038ea429 | this.Load 외 8 | SSP0060_ShipmentPlan.cs:662 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (spdInfo.SheetName == SpdSheet.shtPlanDetail) | GRID_INIT | spdInfo.SetSheetHeaderColumn | (spdInfo, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-78a80527 | this.Load 외 8 | SSP0060_ShipmentPlan.cs:664 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (spdInfo.SheetName == SpdSheet.shtPlanDetail) | LIST_REBIND | SpreadInfo.SetComBoParam | ("CHANGE_REASON_CODE_ALL", dtChangeReasonCode) | 목록 컨트롤 재구성 |  |  |  |
| AC-55f33a0c | this.Load 외 8 | SSP0060_ShipmentPlan.cs:666 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (spdInfo.SheetName == SpdSheet.shtPlanDetail) | GRID_SET | spdInfo.Sheet().ColumnHeader.Cells[0, spdInfo.GetColumnIndex(DefColumns.ERP_SO_NO)].Note | "Popup Column" | 그리드 속성/값 설정 |  |  |  |
| AC-200bde54 | this.Load 외 8 | SSP0060_ShipmentPlan.cs:667 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (spdInfo.SheetName == SpdSheet.shtPlanDetail) | GRID_SET | spdInfo.Sheet().ColumnHeader.Cells[0, spdInfo.GetColumnIndex(DefColumns.ERP_SO_NO)].NoteIn… | new Size(5, 5) | 그리드 속성/값 설정 |  |  |  |
| AC-bdc2799b | this.Load 외 8 | SSP0060_ShipmentPlan.cs:668 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (spdInfo.SheetName == SpdSheet.shtPlanDetail) | GRID_SET | spdInfo.Sheet().ColumnHeader.Cells[0, spdInfo.GetColumnIndex(DefColumns.ERP_SO_NO)].NoteIn… | Color.Blue | 그리드 속성/값 설정 |  |  |  |
| AC-8a3e9276 | this.Load 외 8 | SSP0060_ShipmentPlan.cs:669 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (spdInfo.SheetName == SpdSheet.shtPlanDetail) | GRID_SET | spdInfo.Sheet().ColumnHeader.Cells[0, spdInfo.GetColumnIndex(DefColumns.ERP_SO_NO)].NoteSt… | NoteStyle.PopupNote | 그리드 속성/값 설정 |  |  |  |
| AC-552d1ef4 | this.Load 외 8 | SSP0060_ShipmentPlan.cs:671 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (spdInfo.SheetName == SpdSheet.shtPlanDetail) | GRID_SET | spdInfo.Sheet().ColumnHeader.Cells[0, spdInfo.GetColumnIndex(DefColumns.CHANGE_REQ_NO)].No… | "Popup Column" | 그리드 속성/값 설정 |  |  |  |
| AC-fff54c27 | this.Load 외 8 | SSP0060_ShipmentPlan.cs:672 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (spdInfo.SheetName == SpdSheet.shtPlanDetail) | GRID_SET | spdInfo.Sheet().ColumnHeader.Cells[0, spdInfo.GetColumnIndex(DefColumns.CHANGE_REQ_NO)].No… | new Size(5, 5) | 그리드 속성/값 설정 |  |  |  |
| AC-ca68d60c | this.Load 외 8 | SSP0060_ShipmentPlan.cs:673 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (spdInfo.SheetName == SpdSheet.shtPlanDetail) | GRID_SET | spdInfo.Sheet().ColumnHeader.Cells[0, spdInfo.GetColumnIndex(DefColumns.CHANGE_REQ_NO)].No… | Color.Blue | 그리드 속성/값 설정 |  |  |  |
| AC-54dd8fc6 | this.Load 외 8 | SSP0060_ShipmentPlan.cs:674 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (spdInfo.SheetName == SpdSheet.shtPlanDetail) | GRID_SET | spdInfo.Sheet().ColumnHeader.Cells[0, spdInfo.GetColumnIndex(DefColumns.CHANGE_REQ_NO)].No… | NoteStyle.PopupNote | 그리드 속성/값 설정 |  |  |  |
| AC-83881996 | this.Load 외 8 | SSP0060_ShipmentPlan.cs:676 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (spdInfo.SheetName == SpdSheet.shtPlanDetail) | GRID_INIT | spdInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-4b26eb98 | this.Load 외 8 | SSP0060_ShipmentPlan.cs:683 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPlanDetail) ▸ if (spdInfo.SheetName == SpdSheet.… | GRID_INIT | spdInfo.InitSheet | (spdInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-f98ba4aa | this.Load 외 8 | SSP0060_ShipmentPlan.cs:685 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPlanDetail) ▸ if (spdInfo.SheetName == SpdSheet.… | GRID_INIT | spdInfo.SetSheetHeaderColumn | (spdInfo, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-6119165c | this.Load 외 8 | SSP0060_ShipmentPlan.cs:687 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPlanDetail) ▸ if (spdInfo.SheetName == SpdSheet.… | GRID_INIT | spdInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-c7e54bfa | this.Load 외 8 | SSP0060_ShipmentPlan.cs:694 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPlanDetail) ▸ else of (spdInfo.SheetName == SpdS… | GRID_INIT | spdInfo.InitSheet | (spdInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-5a8e48bc | this.Load 외 8 | SSP0060_ShipmentPlan.cs:696 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPlanDetail) ▸ else of (spdInfo.SheetName == SpdS… | GRID_INIT | spdInfo.SetSheetHeaderColumn | (spdInfo, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-80a8ca92 | this.Load 외 8 | SSP0060_ShipmentPlan.cs:698 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPlanDetail) ▸ else of (spdInfo.SheetName == SpdS… | LIST_REBIND | SpreadInfo.SetComBoParam | ("LookupCommon3", dtStockStatus) | 목록 컨트롤 재구성 |  |  |  |
| AC-7bb9f687 | this.Load 외 8 | SSP0060_ShipmentPlan.cs:700 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPlanDetail) ▸ else of (spdInfo.SheetName == SpdS… | GRID_INIT | spdInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-2f1c5580 | this.Load 외 8 | SSP0060_ShipmentPlan.cs:734 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPlanDetail) ▸ else of (spdInfo.SheetName == SpdS… | GRID_INIT | spdInfo.InitSheet | (spdInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-e0b9f29f | this.Load 외 8 | SSP0060_ShipmentPlan.cs:736 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPlanDetail) ▸ else of (spdInfo.SheetName == SpdS… | GRID_INIT | spdInfo.SetSheetHeaderColumn | (spdInfo, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-b5efec19 | this.Load 외 8 | SSP0060_ShipmentPlan.cs:738 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPlanDetail) ▸ else of (spdInfo.SheetName == SpdS… | GRID_INIT | spdInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-65556699 | this.Load 외 8 | SSP0060_ShipmentPlan.cs:744 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPlanDetail) ▸ else of (spdInfo.SheetName == SpdS… | GRID_INIT | spdInfo.InitSheet | (spdInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-f3178354 | this.Load 외 8 | SSP0060_ShipmentPlan.cs:746 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPlanDetail) ▸ else of (spdInfo.SheetName == SpdS… | GRID_INIT | spdInfo.SetSheetHeaderColumn | (spdInfo, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-0b59f893 | this.Load 외 8 | SSP0060_ShipmentPlan.cs:748 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPlanDetail) ▸ else of (spdInfo.SheetName == SpdS… | GRID_INIT | spdInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-f03a8c28 | this.Load 외 8 | SSP0060_ShipmentPlan.cs:754 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPlanDetail) ▸ else of (spdInfo.SheetName == SpdS… | GRID_INIT | spdInfo.InitSheet | (spdInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-ceef7295 | this.Load 외 8 | SSP0060_ShipmentPlan.cs:756 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPlanDetail) ▸ else of (spdInfo.SheetName == SpdS… | GRID_INIT | spdInfo.SetSheetHeaderColumn | (spdInfo, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-bc2f9666 | this.Load 외 8 | SSP0060_ShipmentPlan.cs:758 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPlanDetail) ▸ else of (spdInfo.SheetName == SpdS… | GRID_INIT | spdInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SSP0060_ShipmentPlan.InitSpreadDateColumn

진입점: this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] / this.chkTotPSI.CheckedChanged [try ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (fps.Name == "spdMain") ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 0) ▸ try ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / this.spdMain.CellDoubleClick [if (spdInfo.SheetName == SpdSheet.shtMain)] / clbCompany_ID.SelectedIndexChanged [if (spdInfo.SheetName == SpdSheet.shtMain)] / cboPlanDate.SelectedIndexChanged [if (cboPlanDat…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8413e69a | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 8 | SSP0060_ShipmentPlan.cs:860 | if (string.IsNullOrWhiteSpace(cboPlanDate.Text)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6952275e | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 8 | SSP0060_ShipmentPlan.cs:893 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sColumnName.IndexOf("B_") > -1) | GRID_INIT | spdInfo.AddTextColumn | (sColumnLabelname, sColumnName, FPMerge.None, 0, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-57fc65a1 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 8 | SSP0060_ShipmentPlan.cs:897 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sColumnName.IndexOf("B_") > -1) ▸ if (sColumnName.IndexOf("D_") > -1) | GRID_INIT | spdInfo.AddNumColumn | (sColumnLabelname, sColumnName, FPMerge.None, 70, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-eb7fbfb2 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 8 | SSP0060_ShipmentPlan.cs:900 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sColumnName.IndexOf("B_") > -1) ▸ if (sColumnName.IndexOf("D_") > -1) ▸ if (sDa… | GRID_SET | spdInfo.Sheet().ColumnHeader.Cells[2, spdInfo.GetMaxColumnIndex()].ForeColor | sDayCode == DefColumnsLabel.Saturday ? Color.Blue : Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-49f82f52 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 8 | SSP0060_ShipmentPlan.cs:903 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sColumnName.IndexOf("B_") > -1) ▸ if (sColumnName.IndexOf("D_") > -1) | GRID_INIT | spdInfo.AddTextColumn | ("E" + sColumnLabelname, "EDIT_YN_" + sColumnName.Replace("D_",""), FPMerge.None, 0, false… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9619bacb | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 8 | SSP0060_ShipmentPlan.cs:909 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sColumnName.IndexOf("B_") > -1) ▸ else of (sColumnName.IndexOf("D_") > -1) | GRID_INIT | spdInfo.AddNumColumn | (sColumnLabelname, sColumnName, FPMerge.None, 70, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d81cea21 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 8 | SSP0060_ShipmentPlan.cs:920 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c1a862e2 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 8 | SSP0060_ShipmentPlan.cs:921 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4ff9666e | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 8 | SSP0060_ShipmentPlan.cs:926 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1f89b77d | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 8 | SSP0060_ShipmentPlan.cs:927 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 30, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-14f6aaa5 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 8 | SSP0060_ShipmentPlan.cs:935 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName != sSmallLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a7c13144 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 8 | SSP0060_ShipmentPlan.cs:936 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName != sSmallLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a9ff3283 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 8 | SSP0060_ShipmentPlan.cs:946 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8ca39531 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 8 | SSP0060_ShipmentPlan.cs:947 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b7745d5c | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 8 | SSP0060_ShipmentPlan.cs:948 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b8dbf0c2 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 8 | SSP0060_ShipmentPlan.cs:949 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |

## SSP0060_ShipmentPlan.InitSpreadFooterSum

진입점: this.Load [else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (spdInfo.SheetName == SpdSheet.shtPlanDetail)] / this.chkTotPSI.CheckedChanged [try ▸ else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (spdInfo.SheetName == SpdSheet.shtPlanDetail)] / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (fps.Name == "spdMain") ▸ else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (spdInfo.SheetName == SpdSheet.shtPlanDetail)] / this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 0) ▸ try ▸ else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (spdInfo.SheetName == SpdSheet.…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2f550db0 | this.Load [else of (spdInfo.SheetName == SpdSheet.shtMain) ▸… 외 8 | SSP0060_ShipmentPlan.cs:802 |  | GRID_SET | siDetail.ActiveSheet.ColumnFooter.Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-242e3717 | this.Load [else of (spdInfo.SheetName == SpdSheet.shtMain) ▸… 외 8 | SSP0060_ShipmentPlan.cs:803 |  | GRID_SET | siDetail.ActiveSheet.ColumnFooter.Cells[0, 1].Value | "Sum" | 그리드 속성/값 설정 |  |  |  |
| AC-736bf585 | this.Load [else of (spdInfo.SheetName == SpdSheet.shtMain) ▸… 외 8 | SSP0060_ShipmentPlan.cs:849 | for (iCol <= siDetail.GetMaxColumnIndex()) | CALL_EXT | siDetail.ActiveSheet.ColumnFooter.SetAggregationFormat | (0, iCol, "{0:#,##0.###}") | ⚠ 의미 확인 필요 |  |  |  |
| AC-3b4e30ba | this.Load [else of (spdInfo.SheetName == SpdSheet.shtMain) ▸… 외 8 | SSP0060_ShipmentPlan.cs:850 | for (iCol <= siDetail.GetMaxColumnIndex()) | CALL_EXT | siDetail.ActiveSheet.ColumnFooter.SetAggregationType | (0, iCol, FarPoint.Win.Spread.Model.AggregationType.SumIgnoreHidden) | ⚠ 의미 확인 필요 |  |  |  |
| AC-4ed9def6 | this.Load [else of (spdInfo.SheetName == SpdSheet.shtMain) ▸… 외 8 | SSP0060_ShipmentPlan.cs:851 | for (iCol <= siDetail.GetMaxColumnIndex()) | GRID_SET | siDetail.ActiveSheet.ColumnFooter.Cells[0, iCol].BackColor | Color.LightGray | 그리드 속성/값 설정 |  |  |  |
| AC-98c55a05 | this.Load [else of (spdInfo.SheetName == SpdSheet.shtMain) ▸… 외 8 | SSP0060_ShipmentPlan.cs:852 | for (iCol <= siDetail.GetMaxColumnIndex()) | GRID_SET | siDetail.ActiveSheet.ColumnFooter.Cells[0, iCol].Border | bevelbrdr | 그리드 속성/값 설정 |  |  |  |

## SSP0060_ShipmentPlan.InsertRow

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c372cf8f | InsertButton | SSP0060_ShipmentPlan.cs:2541 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtHoldSt…) | DATA_OP | siDetail.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-9af96fc7 | InsertButton | SSP0060_ShipmentPlan.cs:2544 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtHoldSt…) | UI_MISC | siDetail.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-6ea19d12 | InsertButton | SSP0060_ShipmentPlan.cs:2546 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtHoldSt…) | GRID_SET | siDetail.SetValue | (siDetail.ActiveRowIndex, siDetail.GetColumnIndex(DefColumns.DIVISION_ID), siMain.GetValue… | 그리드 값 설정 |  |  |  |
| AC-6c79a838 | InsertButton | SSP0060_ShipmentPlan.cs:2547 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtHoldSt…) | GRID_SET | siDetail.SetValue | (siDetail.ActiveRowIndex, siDetail.GetColumnIndex(DefColumns.FROM_SITE), siMain.GetValue(s… | 그리드 값 설정 |  |  |  |
| AC-f1ccd07b | InsertButton | SSP0060_ShipmentPlan.cs:2548 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtHoldSt…) | GRID_SET | siDetail.SetValue | (siDetail.ActiveRowIndex, siDetail.GetColumnIndex(DefColumns.FROM_SITE_NM), siMain.GetValu… | 그리드 값 설정 |  |  |  |
| AC-8d474e09 | InsertButton | SSP0060_ShipmentPlan.cs:2549 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtHoldSt…) | GRID_SET | siDetail.SetValue | (siDetail.ActiveRowIndex, siDetail.GetColumnIndex(DefColumns.ITEM_ID), siMain.GetValue(siM… | 그리드 값 설정 |  |  |  |
| AC-7be3c71b | InsertButton | SSP0060_ShipmentPlan.cs:2550 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtHoldSt…) | GRID_SET | siDetail.SetValue | (siDetail.ActiveRowIndex, siDetail.GetColumnIndex(DefColumns.NICK_NAME), siMain.GetValue(s… | 그리드 값 설정 |  |  |  |
| AC-5e3f9dea | InsertButton | SSP0060_ShipmentPlan.cs:2552 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtHoldSt…) | GRID_LOCK | siDetail.LockRange | (siDetail.ActiveRowIndex, siDetail.GetColumnIndex(DefColumns.DIVISION_ID), siDetail.Active… | 그리드 편집 잠금/해제 |  |  |  |
| AC-5ccf955b | InsertButton | SSP0060_ShipmentPlan.cs:2553 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtHoldSt…) | GRID_LOCK | siDetail.LockRange | (siDetail.ActiveRowIndex, siDetail.GetColumnIndex(DefColumns.LAST_UPDATED_BY), siDetail.Ac… | 그리드 편집 잠금/해제 |  |  |  |
| AC-5dc28b02 | InsertButton | SSP0060_ShipmentPlan.cs:2555 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtHoldSt…) | GRID_SET | siDetail.SetValue | (siDetail.ActiveRowIndex, siDetail.GetColumnIndex(DefColumns.HOLD_YYYYMMDD), cboPlanDate.T… | 그리드 값 설정 |  |  |  |
| AC-8f566746 | InsertButton | SSP0060_ShipmentPlan.cs:2560 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtHoldSt…) ▸ if (si… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4bb2390d | InsertButton | SSP0060_ShipmentPlan.cs:2639 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtHoldSt…) ▸ if (si… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8c77d370 | InsertButton | SSP0060_ShipmentPlan.cs:2641 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtHoldSt…) ▸ if (si… | DATA_OP | siDetail.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-aa8cb305 | InsertButton | SSP0060_ShipmentPlan.cs:2644 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtHoldSt…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.DIVISION_ID, DIVISION_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-0d2b6cc1 | InsertButton | SSP0060_ShipmentPlan.cs:2645 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtHoldSt…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.ITEM_ID, ITEM_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-af67f731 | InsertButton | SSP0060_ShipmentPlan.cs:2646 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtHoldSt…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.NICK_NAME, NICK_NAME) | 데이터 객체 조작/조회 |  |  |  |
| AC-cef8c2b2 | InsertButton | SSP0060_ShipmentPlan.cs:2647 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtHoldSt…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.TO_SITE_DESCRIPTION, TO_SITE_DESCRIPTION) | 데이터 객체 조작/조회 |  |  |  |
| AC-270ea0c6 | InsertButton | SSP0060_ShipmentPlan.cs:2648 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtHoldSt…) ▸ if (si… | DATA_OP | defaultData.Add | ("PROJECT_CODE", PROJECT_CODE) | 데이터 객체 조작/조회 |  |  |  |
| AC-f312067c | InsertButton | SSP0060_ShipmentPlan.cs:2650 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtHoldSt…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.SHIPMENT_DATE, SHIPMENT_DATE) | 데이터 객체 조작/조회 |  |  |  |
| AC-2f719eb4 | InsertButton | SSP0060_ShipmentPlan.cs:2651 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtHoldSt…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.SHIPMENT_CONFIRM_QTY, 0) | 데이터 객체 조작/조회 |  |  |  |
| AC-8f17489a | InsertButton | SSP0060_ShipmentPlan.cs:2652 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtHoldSt…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.REMARKS2, REMARKS2) | 데이터 객체 조작/조회 |  |  |  |
| AC-4c50859b | InsertButton | SSP0060_ShipmentPlan.cs:2653 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtHoldSt…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.REMARKS, REMARKS) | 데이터 객체 조작/조회 |  |  |  |
| AC-83f21c9e | InsertButton | SSP0060_ShipmentPlan.cs:2654 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtHoldSt…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.TRANSPORT_MODE, TRANSPORT_MODE) | 데이터 객체 조작/조회 |  |  |  |
| AC-386e7016 | InsertButton | SSP0060_ShipmentPlan.cs:2655 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtHoldSt…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.FROM_SITE_DESCRIPTION, FROM_SITE_DESCRIPTION) | 데이터 객체 조작/조회 |  |  |  |
| AC-6ef550bf | InsertButton | SSP0060_ShipmentPlan.cs:2656 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtHoldSt…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.REQUESTOR, REQUESTOR) | 데이터 객체 조작/조회 |  |  |  |
| AC-df5f4a3f | InsertButton | SSP0060_ShipmentPlan.cs:2657 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtHoldSt…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.REMARKS3, REMARKS3) | 데이터 객체 조작/조회 |  |  |  |
| AC-486af85b | InsertButton | SSP0060_ShipmentPlan.cs:2658 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtHoldSt…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.CHANGE_REASON_CODE, CHANGE_REASON_CODE) | 데이터 객체 조작/조회 |  |  |  |
| AC-6912e640 | InsertButton | SSP0060_ShipmentPlan.cs:2659 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtHoldSt…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.CHANGE_REASON_DETAIL, CHANGE_REASON_DETAIL) | 데이터 객체 조작/조회 |  |  |  |
| AC-0b425ac8 | InsertButton | SSP0060_ShipmentPlan.cs:2660 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtHoldSt…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.INCOTERMS, INCOTERMS) | 데이터 객체 조작/조회 |  |  |  |
| AC-74febee9 | InsertButton | SSP0060_ShipmentPlan.cs:2661 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtHoldSt…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.LT_DAY, LT_DAY) | 데이터 객체 조작/조회 |  |  |  |
| AC-45490da9 | InsertButton | SSP0060_ShipmentPlan.cs:2662 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtHoldSt…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.ETD, ETD) | 데이터 객체 조작/조회 |  |  |  |
| AC-95d13005 | InsertButton | SSP0060_ShipmentPlan.cs:2663 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtHoldSt…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.ETA, ETA) | 데이터 객체 조작/조회 |  |  |  |
| AC-995c6750 | InsertButton | SSP0060_ShipmentPlan.cs:2665 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtHoldSt…) ▸ if (si… | DATA_OP | defaultData.Add | ("FCST_TYPE", FCST_TYPE) | 데이터 객체 조작/조회 |  |  |  |
| AC-3097c00f | InsertButton | SSP0060_ShipmentPlan.cs:2666 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtHoldSt…) ▸ if (si… | DATA_OP | defaultData.Add | ("UPDATED_BY", UPDATED_BY) | 데이터 객체 조작/조회 |  |  |  |
| AC-ba3ee4ee | InsertButton | SSP0060_ShipmentPlan.cs:2667 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtHoldSt…) ▸ if (si… | DATA_OP | defaultData.Add | ("UPDATED_DATE", UPDATED_DATE) | 데이터 객체 조작/조회 |  |  |  |
| AC-267c80dc | InsertButton | SSP0060_ShipmentPlan.cs:2668 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtHoldSt…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.CHANGE_REQ_NO, CHANGE_REQ_NO) | 데이터 객체 조작/조회 |  |  |  |
| AC-4cb4392e | InsertButton | SSP0060_ShipmentPlan.cs:2669 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtHoldSt…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.CONFIRM_ID, CONFIRM_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-bf0ca80d | InsertButton | SSP0060_ShipmentPlan.cs:2670 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtHoldSt…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.FROM_SITE, FROM_SITE) | 데이터 객체 조작/조회 |  |  |  |
| AC-b580f50d | InsertButton | SSP0060_ShipmentPlan.cs:2673 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtHoldSt…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.TO_SITE, TO_SITE) | 데이터 객체 조작/조회 |  |  |  |
| AC-c0093ca8 | InsertButton | SSP0060_ShipmentPlan.cs:2674 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtHoldSt…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.ERP_STATUS, ERP_STATUS) | 데이터 객체 조작/조회 |  |  |  |
| AC-f293d455 | InsertButton | SSP0060_ShipmentPlan.cs:2675 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtHoldSt…) ▸ if (si… | DATA_OP | defaultData.Add | ("BOD_ID", BOD_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-27ee2d06 | InsertButton | SSP0060_ShipmentPlan.cs:2676 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtHoldSt…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.CHANGE_TYPE, CHANGE_TYPE) | 데이터 객체 조작/조회 |  |  |  |
| AC-6d33c2cc | InsertButton | SSP0060_ShipmentPlan.cs:2677 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtHoldSt…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.NEW_ROUTE_ID, NEW_ROUTE_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-9758d266 | InsertButton | SSP0060_ShipmentPlan.cs:2678 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtHoldSt…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.NEW_BOD_ID, NEW_BOD_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-f5fa686b | InsertButton | SSP0060_ShipmentPlan.cs:2679 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtHoldSt…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.NEW_INCOTERMS, NEW_INCOTERMS) | 데이터 객체 조작/조회 |  |  |  |
| AC-a023ef6f | InsertButton | SSP0060_ShipmentPlan.cs:2680 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtHoldSt…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.NEW_D_COUNTRY, NEW_D_COUNTRY) | 데이터 객체 조작/조회 |  |  |  |
| AC-13d35b59 | InsertButton | SSP0060_ShipmentPlan.cs:2681 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtHoldSt…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.NEW_D_PORT_CODE, NEW_D_PORT_CODE) | 데이터 객체 조작/조회 |  |  |  |
| AC-8f10d8db | InsertButton | SSP0060_ShipmentPlan.cs:2682 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtHoldSt…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.NEW_A_COUNTRY, NEW_A_COUNTRY) | 데이터 객체 조작/조회 |  |  |  |
| AC-822043e1 | InsertButton | SSP0060_ShipmentPlan.cs:2683 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtHoldSt…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.NEW_A_PORT_CODE, NEW_A_PORT_CODE) | 데이터 객체 조작/조회 |  |  |  |
| AC-48e58d08 | InsertButton | SSP0060_ShipmentPlan.cs:2684 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtHoldSt…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.NEW_CUSTOMER_LT, NEW_CUSTOMER_LT) | 데이터 객체 조작/조회 |  |  |  |
| AC-b64b6bb6 | InsertButton | SSP0060_ShipmentPlan.cs:2685 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtHoldSt…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.NEW_TO_COUNTRY, NEW_TO_COUNTRY) | 데이터 객체 조작/조회 |  |  |  |
| AC-5138d494 | InsertButton | SSP0060_ShipmentPlan.cs:2686 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtHoldSt…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.NEW_TO_CITY, NEW_TO_CITY) | 데이터 객체 조작/조회 |  |  |  |
| AC-6d1e8ff8 | InsertButton | SSP0060_ShipmentPlan.cs:2687 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtHoldSt…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.NEW_ETA, NEW_ETA) | 데이터 객체 조작/조회 |  |  |  |
| AC-3756a465 | InsertButton | SSP0060_ShipmentPlan.cs:2688 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtHoldSt…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.NEW_ETD, NEW_ETD) | 데이터 객체 조작/조회 |  |  |  |
| AC-b0c816de | InsertButton | SSP0060_ShipmentPlan.cs:2689 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtHoldSt…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.NEW_LT_DAY, NEW_LT_DAY) | 데이터 객체 조작/조회 |  |  |  |
| AC-6e8ba525 | InsertButton | SSP0060_ShipmentPlan.cs:2690 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtHoldSt…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.NEW_TRANSPORT_MODE, NEW_TRANSPORT_MODE) | 데이터 객체 조작/조회 |  |  |  |
| AC-4d8642e8 | InsertButton | SSP0060_ShipmentPlan.cs:2691 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtHoldSt…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.NEW_SHIPMENT_DATE, NEW_SHIPMENT_DATE) | 데이터 객체 조작/조회 |  |  |  |
| AC-2d4e0d38 | InsertButton | SSP0060_ShipmentPlan.cs:2692 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtHoldSt…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.EDIT_REMARKS, EDIT_REMARKS) | 데이터 객체 조작/조회 |  |  |  |
| AC-ccd23d60 | InsertButton | SSP0060_ShipmentPlan.cs:2694 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtHoldSt…) ▸ if (si… | GRID_SET | siDetail.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |
| AC-bc3ddabf | InsertButton | SSP0060_ShipmentPlan.cs:2696 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtHoldSt…) ▸ if (si… | GRID_LOCK | siDetail.LockRange | (insCell, siDetail.GetColumnIndex(DefColumns.DIVISION_ID), siDetail.GetColumnIndex(DefColu… | 그리드 편집 잠금/해제 |  |  |  |
| AC-93923b32 | InsertButton | SSP0060_ShipmentPlan.cs:2697 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtHoldSt…) ▸ if (si… | GRID_LOCK | siDetail.LockRange | (insCell, siDetail.GetColumnIndex(DefColumns.MKT_OWNER), siDetail.GetColumnIndex(DefColumn… | 그리드 편집 잠금/해제 |  |  |  |

## SSP0060_ShipmentPlan.Measure_SearchIdx

진입점: this.btnSimulation.Click [try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(DefColumns.MEASURE)].Text == "SHIP_PLAN" && siMain.ActiveSheet.Cells[i…)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-06c4d5f5 | this.btnSimulation.Click [try ▸ for (i <= siMain.GetMaxRowIn… | SSP0060_ShipmentPlan.cs:7912 | for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.DIVISION_ID)).ToString() == sDivisionID &… | DATA_OP | intidxArr[0] | iRow | 행/컬럼 값 대입 |  |  |  |
| AC-1b454299 | this.btnSimulation.Click [try ▸ for (i <= siMain.GetMaxRowIn… | SSP0060_ShipmentPlan.cs:7916 | for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.DIVISION_ID)).ToString() == sDivisionID &… | DATA_OP | intidxArr[1] | iRow | 행/컬럼 값 대입 |  |  |  |
| AC-75044225 | this.btnSimulation.Click [try ▸ for (i <= siMain.GetMaxRowIn… | SSP0060_ShipmentPlan.cs:7920 | for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.DIVISION_ID)).ToString() == sDivisionID &… | DATA_OP | intidxArr[2] | iRow | 행/컬럼 값 대입 |  |  |  |
| AC-8e63185e | this.btnSimulation.Click [try ▸ for (i <= siMain.GetMaxRowIn… | SSP0060_ShipmentPlan.cs:7926 | for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.DIVISION_ID)).ToString() == sDivisionID &… | DATA_OP | intidxArr[3] | -1 | 행/컬럼 값 대입 |  |  |  |
| AC-047ab653 | this.btnSimulation.Click [try ▸ for (i <= siMain.GetMaxRowIn… | SSP0060_ShipmentPlan.cs:7930 | for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.DIVISION_ID)).ToString() == sDivisionID &… | DATA_OP | intidxArr[3] | iRow | 행/컬럼 값 대입 |  |  |  |
| AC-775939c5 | this.btnSimulation.Click [try ▸ for (i <= siMain.GetMaxRowIn… | SSP0060_ShipmentPlan.cs:7935 | for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.DIVISION_ID)).ToString() == sDivisionID &… | DATA_OP | intidxArr[4] | iRow | 행/컬럼 값 대입 |  |  |  |
| AC-5993a421 | this.btnSimulation.Click [try ▸ for (i <= siMain.GetMaxRowIn… | SSP0060_ShipmentPlan.cs:7940 |  | RETURN | return intidxArr; |  | 처리 중단/반환 |  |  |  |

## SSP0060_ShipmentPlan.NewNonSoNo

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-aedd11df | (진입점 미연결) | SSP0060_ShipmentPlan.cs:4928 |  | ENDPOINT | new FoxDataRequest | ("SSP.SSP0060_SAVE_SHIPMENT_REQUEST_DRAFTING") ⇒ SSP.SSP0060_SAVE_SHIPMENT_REQUEST_DRAFTING | 엔드포인트 요청 생성 |  |  |  |
| AC-d86a9fe6 | (진입점 미연결) | SSP0060_ShipmentPlan.cs:4932 |  | DATA_OP | request.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-2b5f67e4 | (진입점 미연결) | SSP0060_ShipmentPlan.cs:4933 |  | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-251d8af9 | (진입점 미연결) | SSP0060_ShipmentPlan.cs:4934 |  | DATA_OP | request.Parameters["p_confirm_id"] | p_confirm_id | 행/컬럼 값 대입 |  |  |  |
| AC-fbfd52b3 | (진입점 미연결) | SSP0060_ShipmentPlan.cs:4935 |  | DATA_OP | request.Parameters["p_shipment_qty"] | p_shipment_qty | 행/컬럼 값 대입 |  |  |  |
| AC-36ad8df8 | (진입점 미연결) | SSP0060_ShipmentPlan.cs:4936 |  | DATA_OP | request.Parameters["p_shipment_date"] | p_shipment_date | 행/컬럼 값 대입 |  |  |  |
| AC-80a20e4b | (진입점 미연결) | SSP0060_ShipmentPlan.cs:4937 |  | DATA_OP | request.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-958272d8 | (진입점 미연결) | SSP0060_ShipmentPlan.cs:4938 |  | DATA_OP | request.Parameters["p_new_bod_id"] | p_new_bod_id | 행/컬럼 값 대입 |  |  |  |
| AC-0370af62 | (진입점 미연결) | SSP0060_ShipmentPlan.cs:4939 |  | DATA_OP | request.Parameters["p_new_route_id"] | p_new_route_id | 행/컬럼 값 대입 |  |  |  |
| AC-093a1f28 | (진입점 미연결) | SSP0060_ShipmentPlan.cs:4940 |  | DATA_OP | request.Parameters["p_new_etd_date"] | p_new_etd_date | 행/컬럼 값 대입 |  |  |  |
| AC-017fab7a | (진입점 미연결) | SSP0060_ShipmentPlan.cs:4941 |  | DATA_OP | request.Parameters["p_new_eta_date"] | p_new_eta_date | 행/컬럼 값 대입 |  |  |  |
| AC-ac3a4a39 | (진입점 미연결) | SSP0060_ShipmentPlan.cs:4942 |  | DATA_OP | request.Parameters["p_new_incoterms"] | p_new_incoterms | 행/컬럼 값 대입 |  |  |  |
| AC-ffa7c513 | (진입점 미연결) | SSP0060_ShipmentPlan.cs:4943 |  | DATA_OP | request.Parameters["p_new_transport_mode"] | p_new_transport_mode | 행/컬럼 값 대입 |  |  |  |
| AC-13f03f1b | (진입점 미연결) | SSP0060_ShipmentPlan.cs:4944 |  | DATA_OP | request.Parameters["p_new_d_contry"] | p_new_d_contry | 행/컬럼 값 대입 |  |  |  |
| AC-a7934e17 | (진입점 미연결) | SSP0060_ShipmentPlan.cs:4945 |  | DATA_OP | request.Parameters["p_new_d_port_code"] | p_new_d_port_code | 행/컬럼 값 대입 |  |  |  |
| AC-db800657 | (진입점 미연결) | SSP0060_ShipmentPlan.cs:4946 |  | DATA_OP | request.Parameters["p_new_a_country"] | p_new_a_country | 행/컬럼 값 대입 |  |  |  |
| AC-e65f8da5 | (진입점 미연결) | SSP0060_ShipmentPlan.cs:4947 |  | DATA_OP | request.Parameters["p_new_a_port_code"] | p_new_a_port_code | 행/컬럼 값 대입 |  |  |  |
| AC-f97794dd | (진입점 미연결) | SSP0060_ShipmentPlan.cs:4948 |  | DATA_OP | request.Parameters["p_new_customer_lt"] | p_new_customer_lt | 행/컬럼 값 대입 |  |  |  |
| AC-7c42c4ef | (진입점 미연결) | SSP0060_ShipmentPlan.cs:4949 |  | DATA_OP | request.Parameters["p_new_to_country"] | p_new_to_country | 행/컬럼 값 대입 |  |  |  |
| AC-88e23b26 | (진입점 미연결) | SSP0060_ShipmentPlan.cs:4950 |  | DATA_OP | request.Parameters["p_new_to_city"] | p_new_to_city | 행/컬럼 값 대입 |  |  |  |
| AC-f7bff8cc | (진입점 미연결) | SSP0060_ShipmentPlan.cs:4951 |  | DATA_OP | request.Parameters["p_edit_main"] | p_edit_main | 행/컬럼 값 대입 |  |  |  |
| AC-78758126 | (진입점 미연결) | SSP0060_ShipmentPlan.cs:4952 |  | DATA_OP | request.Parameters["p_edit_remark"] | p_edit_remark | 행/컬럼 값 대입 |  |  |  |
| AC-91ad41c8 | (진입점 미연결) | SSP0060_ShipmentPlan.cs:4953 |  | DATA_OP | request.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-94a9395f | (진입점 미연결) | SSP0060_ShipmentPlan.cs:4954 |  | DATA_OP | request.Parameters["p_user_dept_id"] | p_user_dept_id | 행/컬럼 값 대입 |  |  |  |
| AC-c067f47d | (진입점 미연결) | SSP0060_ShipmentPlan.cs:4955 |  | DATA_OP | request.Parameters["p_electrode_yn"] | p_electrode_yn | 행/컬럼 값 대입 |  |  |  |
| AC-d4c28810 | (진입점 미연결) | SSP0060_ShipmentPlan.cs:4956 |  | DATA_OP | request.Parameters["p_electrode_type"] | p_electrode_type | 행/컬럼 값 대입 |  |  |  |
| AC-1e598847 | (진입점 미연결) | SSP0060_ShipmentPlan.cs:4957 |  | DATA_OP | request.Parameters["p_origin_from_division_id"] | p_origin_from_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-2b42958a | (진입점 미연결) | SSP0060_ShipmentPlan.cs:4958 |  | DATA_OP | request.Parameters["p_origion_to_division_id"] | p_origion_to_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-695dda3e | (진입점 미연결) | SSP0060_ShipmentPlan.cs:4960 |  | DATA_OP | request.Parameters["p_remarks"] | p_remarks | 행/컬럼 값 대입 |  |  |  |
| AC-02b8e82e | (진입점 미연결) | SSP0060_ShipmentPlan.cs:4961 |  | DATA_OP | request.Parameters["p_remarks2"] | p_remarks2 | 행/컬럼 값 대입 |  |  |  |
| AC-727eef06 | (진입점 미연결) | SSP0060_ShipmentPlan.cs:4962 |  | DATA_OP | request.Parameters["p_remarks3"] | p_remarks3 | 행/컬럼 값 대입 |  |  |  |
| AC-b49ebcf8 | (진입점 미연결) | SSP0060_ShipmentPlan.cs:4964 |  | DATA_OP | request.Parameters["p_change_reason_code"] | p_change_reason_code | 행/컬럼 값 대입 |  |  |  |
| AC-b150031c | (진입점 미연결) | SSP0060_ShipmentPlan.cs:4965 |  | DATA_OP | request.Parameters["p_change_reason_detail"] | p_change_reason_datail | 행/컬럼 값 대입 |  |  |  |
| AC-c2dbfc2f | (진입점 미연결) | SSP0060_ShipmentPlan.cs:4966 |  | DATA_OP | request.Parameters["p_title"] | p_title | 행/컬럼 값 대입 |  |  |  |
| AC-b41a16be | (진입점 미연결) | SSP0060_ShipmentPlan.cs:4967 |  | DATA_OP | request.Parameters["p_program_id"] | p_program_id | 행/컬럼 값 대입 |  |  |  |
| AC-d84f8775 | (진입점 미연결) | SSP0060_ShipmentPlan.cs:4968 |  | DATA_OP | request.Parameters["p_shipto_code"] | p_shipto_code | 행/컬럼 값 대입 |  |  |  |
| AC-dade124b | (진입점 미연결) | SSP0060_ShipmentPlan.cs:4971 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-8f4b48d2 | (진입점 미연결) | SSP0060_ShipmentPlan.cs:4996 | else of (ds.Tables[0].Rows[0][0].ToString() == "S") ▸ if (ds.Tables[0].Rows[0][0].ToString() == "X") | MESSAGE | MessageHelper.GMessageBox | ("MSG00324") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-83569106 | (진입점 미연결) | SSP0060_ShipmentPlan.cs:4998 | else of (ds.Tables[0].Rows[0][0].ToString() == "S") ▸ if (ds.Tables[0].Rows[0][0].ToString() == "X") ▸ if (MessageHelper.GMessageBox("MSG003… | CALL_BASE | base.AddHelpButton | ("Standard Information SSP Manual") | ⚠ 의미 확인 필요 |  |  |  |
| AC-03155221 | (진입점 미연결) | SSP0060_ShipmentPlan.cs:5019 | else of (ds.Tables[0].Rows[0][0].ToString() == "S") ▸ else of (ds.Tables[0].Rows[0][0].ToString() == "X") | MESSAGE | MessageHelper.GMessageBox | ("MSG00284", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ab2cfda7 | (진입점 미연결) | SSP0060_ShipmentPlan.cs:5023 |  | RETURN | return bReturn; |  | 처리 중단/반환 |  |  |  |

## SSP0060_ShipmentPlan.NonSoNo

진입점: SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPIFBlockYn()) ▸ try ▸ try ▸ for (i <= siDetail.ActiveSheet.RowCount - 1) ▸ if (action != CAppSetting.FlagI) ▸ if (string.IsNullOrWhiteSpace(erpSoNo))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-36a1f5d2 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:4159 |  | ENDPOINT | new FoxDataRequest | ("SSP.SSP0060_SAVE_SHIPMENT_REQUEST_DRAFTING") ⇒ SSP.SSP0060_SAVE_SHIPMENT_REQUEST_DRAFTING | 엔드포인트 요청 생성 |  |  |  |
| AC-eb687177 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:4163 |  | DATA_OP | request.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-4f1fd20c | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:4164 |  | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-49449f40 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:4165 |  | DATA_OP | request.Parameters["p_confirm_id"] | p_confirm_id | 행/컬럼 값 대입 |  |  |  |
| AC-dc1544e5 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:4166 |  | DATA_OP | request.Parameters["p_shipment_qty"] | p_shipment_qty | 행/컬럼 값 대입 |  |  |  |
| AC-dccd741f | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:4167 |  | DATA_OP | request.Parameters["p_shipment_date"] | p_shipment_date | 행/컬럼 값 대입 |  |  |  |
| AC-f2a68f62 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:4168 |  | DATA_OP | request.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-544df030 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:4169 |  | DATA_OP | request.Parameters["p_new_bod_id"] | p_new_bod_id | 행/컬럼 값 대입 |  |  |  |
| AC-9f68dfbe | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:4170 |  | DATA_OP | request.Parameters["p_new_route_id"] | p_new_route_id | 행/컬럼 값 대입 |  |  |  |
| AC-eb77a487 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:4171 |  | DATA_OP | request.Parameters["p_new_etd_date"] | p_new_etd_date | 행/컬럼 값 대입 |  |  |  |
| AC-2088a9d9 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:4172 |  | DATA_OP | request.Parameters["p_new_eta_date"] | p_new_eta_date | 행/컬럼 값 대입 |  |  |  |
| AC-f9959936 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:4173 |  | DATA_OP | request.Parameters["p_new_incoterms"] | p_new_incoterms | 행/컬럼 값 대입 |  |  |  |
| AC-05d94640 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:4174 |  | DATA_OP | request.Parameters["p_new_transport_mode"] | p_new_transport_mode | 행/컬럼 값 대입 |  |  |  |
| AC-990728a7 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:4175 |  | DATA_OP | request.Parameters["p_new_d_contry"] | p_new_d_contry | 행/컬럼 값 대입 |  |  |  |
| AC-a2582359 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:4176 |  | DATA_OP | request.Parameters["p_new_d_port_code"] | p_new_d_port_code | 행/컬럼 값 대입 |  |  |  |
| AC-3fae9059 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:4177 |  | DATA_OP | request.Parameters["p_new_a_country"] | p_new_a_country | 행/컬럼 값 대입 |  |  |  |
| AC-c72089a7 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:4178 |  | DATA_OP | request.Parameters["p_new_a_port_code"] | p_new_a_port_code | 행/컬럼 값 대입 |  |  |  |
| AC-f117b8c1 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:4179 |  | DATA_OP | request.Parameters["p_new_customer_lt"] | p_new_customer_lt | 행/컬럼 값 대입 |  |  |  |
| AC-d7187417 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:4180 |  | DATA_OP | request.Parameters["p_new_to_country"] | p_new_to_country | 행/컬럼 값 대입 |  |  |  |
| AC-8ebd2c06 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:4181 |  | DATA_OP | request.Parameters["p_new_to_city"] | p_new_to_city | 행/컬럼 값 대입 |  |  |  |
| AC-9df22260 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:4182 |  | DATA_OP | request.Parameters["p_edit_main"] | p_edit_main | 행/컬럼 값 대입 |  |  |  |
| AC-86e96d0c | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:4183 |  | DATA_OP | request.Parameters["p_edit_remark"] | p_edit_remark | 행/컬럼 값 대입 |  |  |  |
| AC-f7516b4b | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:4184 |  | DATA_OP | request.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-c4641cb7 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:4185 |  | DATA_OP | request.Parameters["p_user_dept_id"] | p_user_dept_id | 행/컬럼 값 대입 |  |  |  |
| AC-95640638 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:4186 |  | DATA_OP | request.Parameters["p_electrode_yn"] | p_electrode_yn | 행/컬럼 값 대입 |  |  |  |
| AC-b87a2216 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:4187 |  | DATA_OP | request.Parameters["p_electrode_type"] | p_electrode_type | 행/컬럼 값 대입 |  |  |  |
| AC-52c20f53 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:4188 |  | DATA_OP | request.Parameters["p_origin_from_division_id"] | p_origin_from_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-113f355f | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:4189 |  | DATA_OP | request.Parameters["p_origion_to_division_id"] | p_origion_to_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-95ee1955 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:4191 |  | DATA_OP | request.Parameters["p_remarks"] | p_remarks | 행/컬럼 값 대입 |  |  |  |
| AC-c857f7eb | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:4192 |  | DATA_OP | request.Parameters["p_remarks2"] | p_remarks2 | 행/컬럼 값 대입 |  |  |  |
| AC-4a338027 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:4193 |  | DATA_OP | request.Parameters["p_remarks3"] | p_remarks3 | 행/컬럼 값 대입 |  |  |  |
| AC-be9cd6a8 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:4195 |  | DATA_OP | request.Parameters["p_change_reason_code"] | p_change_reason_code | 행/컬럼 값 대입 |  |  |  |
| AC-c824d263 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:4196 |  | DATA_OP | request.Parameters["p_change_reason_detail"] | p_change_reason_datail | 행/컬럼 값 대입 |  |  |  |
| AC-4388c1f8 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:4197 |  | DATA_OP | request.Parameters["p_title"] | p_title | 행/컬럼 값 대입 |  |  |  |
| AC-5246bdd4 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:4198 |  | DATA_OP | request.Parameters["p_program_id"] | p_program_id | 행/컬럼 값 대입 |  |  |  |
| AC-a223207b | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:4200 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-3e4d929c | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:4222 | else of (ds.Tables[0].Rows[0][0].ToString() == "S") ▸ if (ds.Tables[0].Rows[0][0].ToString() == "X") | MESSAGE | MessageHelper.GMessageBox | ("MSG00324") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3ba3f76d | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:4224 | else of (ds.Tables[0].Rows[0][0].ToString() == "S") ▸ if (ds.Tables[0].Rows[0][0].ToString() == "X") ▸ if (MessageHelper.GMessageBox("MSG003… | CALL_BASE | base.AddHelpButton | ("Standard Information SSP Manual") | ⚠ 의미 확인 필요 |  |  |  |
| AC-cc747068 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:4246 | else of (ds.Tables[0].Rows[0][0].ToString() == "S") ▸ else of (ds.Tables[0].Rows[0][0].ToString() == "X") | MESSAGE | MessageHelper.GMessageBox | ("MSG00284", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8eeb963a | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:4250 |  | RETURN | return bReturn; |  | 처리 중단/반환 |  |  |  |

## SSP0060_ShipmentPlan.Plan_Current_Check

진입점: this.chkTotPSI.CheckedChanged [try ▸ if (cboPlanDate.SelectedIndex == 0)] / FindButton [try ▸ if (cboPlanDate.SelectedIndex == 0)] / SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try ▸ if (cboPlanDate.SelectedIndex == 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f5245adc | this.chkTotPSI.CheckedChanged [try ▸ if (cboPlanDate.Selecte… 외 2 | SSP0060_ShipmentPlan.cs:6489 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.Plan_Infor, false, strCompanyID) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-0556cf3c | this.chkTotPSI.CheckedChanged [try ▸ if (cboPlanDate.Selecte… 외 2 | SSP0060_ShipmentPlan.cs:6494 | if (cboPlanDate.SelectedValue.ToString() != Tmp_dtPlanDate.Rows[0]["CODE"].ToString()) | MESSAGE | MessageHelper.GMessageBox | ("MSG00313", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-1b1d8576 | this.chkTotPSI.CheckedChanged [try ▸ if (cboPlanDate.Selecte… 외 2 | SSP0060_ShipmentPlan.cs:6501 | if (cboPlanDate.SelectedValue.ToString() != Tmp_dtPlanDate.Rows[0]["CODE"].ToString()) ▸ if (Tmp_dtPlanDate.Rows.Count > 0) ▸ if (!DateTime.… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9d213afb | this.chkTotPSI.CheckedChanged [try ▸ if (cboPlanDate.Selecte… 외 2 | SSP0060_ShipmentPlan.cs:6507 | if (cboPlanDate.SelectedValue.ToString() != Tmp_dtPlanDate.Rows[0]["CODE"].ToString()) ▸ if (Tmp_dtPlanDate.Rows.Count > 0) ▸ if (!DateTime.… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0eabae5a | this.chkTotPSI.CheckedChanged [try ▸ if (cboPlanDate.Selecte… 외 2 | SSP0060_ShipmentPlan.cs:6513 | if (cboPlanDate.SelectedValue.ToString() != Tmp_dtPlanDate.Rows[0]["CODE"].ToString()) ▸ if (Tmp_dtPlanDate.Rows.Count > 0) ▸ if (!DateTime.… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6427584c | this.chkTotPSI.CheckedChanged [try ▸ if (cboPlanDate.Selecte… 외 2 | SSP0060_ShipmentPlan.cs:6515 | if (cboPlanDate.SelectedValue.ToString() != Tmp_dtPlanDate.Rows[0]["CODE"].ToString()) ▸ if (Tmp_dtPlanDate.Rows.Count > 0) | UI_PROP | drpPeriod.Value1 | dateFrom | 속성 Value1 설정 |  |  |  |
| AC-5f8aff1f | this.chkTotPSI.CheckedChanged [try ▸ if (cboPlanDate.Selecte… 외 2 | SSP0060_ShipmentPlan.cs:6516 | if (cboPlanDate.SelectedValue.ToString() != Tmp_dtPlanDate.Rows[0]["CODE"].ToString()) ▸ if (Tmp_dtPlanDate.Rows.Count > 0) | UI_PROP | drpPeriod.Value2 | dateTo | 속성 Value2 설정 |  |  |  |
| AC-c3382106 | this.chkTotPSI.CheckedChanged [try ▸ if (cboPlanDate.Selecte… 외 2 | SSP0060_ShipmentPlan.cs:6517 | if (cboPlanDate.SelectedValue.ToString() != Tmp_dtPlanDate.Rows[0]["CODE"].ToString()) ▸ if (Tmp_dtPlanDate.Rows.Count > 0) | UI_PROP | drpPeriod2.Value1 | dateFrom | 속성 Value1 설정 |  |  |  |
| AC-d8e7ba01 | this.chkTotPSI.CheckedChanged [try ▸ if (cboPlanDate.Selecte… 외 2 | SSP0060_ShipmentPlan.cs:6518 | if (cboPlanDate.SelectedValue.ToString() != Tmp_dtPlanDate.Rows[0]["CODE"].ToString()) ▸ if (Tmp_dtPlanDate.Rows.Count > 0) | UI_PROP | drpPeriod2.Value2 | dateTo | 속성 Value2 설정 |  |  |  |
| AC-d8191b4d | this.chkTotPSI.CheckedChanged [try ▸ if (cboPlanDate.Selecte… 외 2 | SSP0060_ShipmentPlan.cs:6519 | if (cboPlanDate.SelectedValue.ToString() != Tmp_dtPlanDate.Rows[0]["CODE"].ToString()) ▸ if (Tmp_dtPlanDate.Rows.Count > 0) | CALL_EXT | cboPlanDate.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-55f6e096 | this.chkTotPSI.CheckedChanged [try ▸ if (cboPlanDate.Selecte… 외 2 | SSP0060_ShipmentPlan.cs:6520 | if (cboPlanDate.SelectedValue.ToString() != Tmp_dtPlanDate.Rows[0]["CODE"].ToString()) ▸ if (Tmp_dtPlanDate.Rows.Count > 0) | LIST_REBIND | clsCtrl.setListBox | (Tmp_dtPlanDate, cboPlanDate, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SSP0060_ShipmentPlan.Re_Design

진입점: this.chkTotPSI.CheckedChanged [finally] / FindButton [finally] / EditButton [if (fps.Name == "spdMain") ▸ else of (bEdit_Mode == false) ▸ if (siMain.Sheet(0).Rows.Count > 0)] / SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ finally]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4f87d3df | this.chkTotPSI.CheckedChanged [finally] 외 3 | SSP0060_ShipmentPlan.cs:5443 | if (siMain.ActiveSheet.RowCount > 0) ▸ if (!bFindMain) | UI_PROP | range0.BackColor | Color.FromArgb(255, 255, 255) | 속성 BackColor 설정 |  |  |  |
| AC-6628b8ea | this.chkTotPSI.CheckedChanged [finally] 외 3 | SSP0060_ShipmentPlan.cs:5444 | if (siMain.ActiveSheet.RowCount > 0) ▸ if (!bFindMain) | UI_PROP | range0.Border | emptyBorder | 속성 Border 설정 |  |  |  |
| AC-2a4ff6a3 | this.chkTotPSI.CheckedChanged [finally] 외 3 | SSP0060_ShipmentPlan.cs:5447 | if (siMain.ActiveSheet.RowCount > 0) ▸ if (!bFindMain) | CALL_EXT | siMain.ActiveSheet.Cells[0, siMain.GetColumnIndex(DefColumns.TO_SITE) + 1, siMain.ActiveSh… | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-4e2722fa | this.chkTotPSI.CheckedChanged [finally] 외 3 | SSP0060_ShipmentPlan.cs:5476 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (i < siMain.ActiveSheet.RowCount) ▸ if (!string.IsNullOrWhiteSpace(siMain.GetValue(i, siMain.GetC… | UI_PROP | range1.BackColor | Color.FromArgb(CommonUtils.GetValueInt(sValues[0]), CommonUtils.GetValueInt(sValues[1]), C… | 속성 BackColor 설정 |  |  |  |
| AC-9d8f8d34 | this.chkTotPSI.CheckedChanged [finally] 외 3 | SSP0060_ShipmentPlan.cs:5476 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (i < siMain.ActiveSheet.RowCount) ▸ if (!string.IsNullOrWhiteSpace(siMain.GetValue(i, siMain.GetC… | CALL_EXT | CommonUtils.GetValueInt | (sValues[0]) | ⚠ 의미 확인 필요 |  |  |  |
| AC-5132d7be | this.chkTotPSI.CheckedChanged [finally] 외 3 | SSP0060_ShipmentPlan.cs:5476 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (i < siMain.ActiveSheet.RowCount) ▸ if (!string.IsNullOrWhiteSpace(siMain.GetValue(i, siMain.GetC… | CALL_EXT | CommonUtils.GetValueInt | (sValues[1]) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c3b7492a | this.chkTotPSI.CheckedChanged [finally] 외 3 | SSP0060_ShipmentPlan.cs:5476 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (i < siMain.ActiveSheet.RowCount) ▸ if (!string.IsNullOrWhiteSpace(siMain.GetValue(i, siMain.GetC… | CALL_EXT | CommonUtils.GetValueInt | (sValues[2]) | ⚠ 의미 확인 필요 |  |  |  |
| AC-575749e6 | this.chkTotPSI.CheckedChanged [finally] 외 3 | SSP0060_ShipmentPlan.cs:5490 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (i < siMain.ActiveSheet.RowCount) ▸ if (sMeasure == "CONTAINER") ▸ if (siMain.GetValue(i, siMain.… | GRID_SET | siMain.ActiveSheet.Cells[i, startIdx, i, siMain.ActiveSheet.ColumnCount - 1].Value | null | 그리드 속성/값 설정 |  |  |  |
| AC-6481bef1 | this.chkTotPSI.CheckedChanged [finally] 외 3 | SSP0060_ShipmentPlan.cs:5497 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (i < siMain.ActiveSheet.RowCount) ▸ if (sMeasure == "SHIP_PLAN" \|\| sMeasure == "TOT_SHIP_PLAN") | UI_PROP | range2.BackColor | Color.FromArgb(167, 213, 255) | 속성 BackColor 설정 |  |  |  |
| AC-9b1c69ed | this.chkTotPSI.CheckedChanged [finally] 외 3 | SSP0060_ShipmentPlan.cs:5503 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (i < siMain.ActiveSheet.RowCount) ▸ if (sMeasure == "SHIP_PLAN_DETAIL" \|\| sMeasure == "SHIP_RES… | UI_PROP | range3.BackColor | Color.FromArgb(80, Color.LightSkyBlue) | 속성 BackColor 설정 |  |  |  |
| AC-8040162f | this.chkTotPSI.CheckedChanged [finally] 외 3 | SSP0060_ShipmentPlan.cs:5513 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (i < siMain.ActiveSheet.RowCount) ▸ if (sMeasure == "SHIP_PLAN_DETAIL" \|\| sMeasure == "SHIP_RES… | CALL_EXT | CString.IsNumber | (sEditYN) | ⚠ 의미 확인 필요 |  |  |  |
| AC-fdd38c13 | this.chkTotPSI.CheckedChanged [finally] 외 3 | SSP0060_ShipmentPlan.cs:5536 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (i < siMain.ActiveSheet.RowCount) ▸ if (sMeasure != "SHIP_PLAN" && sMeasure != "SHIP_PLAN_DETAIL"… | UI_PROP | range4.BackColor | Color.FromArgb(169, 169, 169) | 속성 BackColor 설정 |  |  |  |
| AC-73d47165 | this.chkTotPSI.CheckedChanged [finally] 외 3 | SSP0060_ShipmentPlan.cs:5540 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (i < siMain.ActiveSheet.RowCount) ▸ if (sMeasure != "SHIP_PLAN" && sMeasure != "SHIP_PLAN_DETAIL"… | GRID_SET | siMain.SetValue | (i, j, siMain.GetValue(i, j).ToString() != string.Empty && CommonUtils.GetValueInt(siMain.… | 그리드 값 설정 |  |  |  |
| AC-26e6c3ac | this.chkTotPSI.CheckedChanged [finally] 외 3 | SSP0060_ShipmentPlan.cs:5540 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (i < siMain.ActiveSheet.RowCount) ▸ if (sMeasure != "SHIP_PLAN" && sMeasure != "SHIP_PLAN_DETAIL"… | CALL_EXT | CommonUtils.GetValueInt | (siMain.GetValue(i, j)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-dff64c61 | this.chkTotPSI.CheckedChanged [finally] 외 3 | SSP0060_ShipmentPlan.cs:5551 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (i < siMain.ActiveSheet.RowCount) ▸ if (sMeasure == "TOT_SHIP_REQ" \|\| sMeasure == "TOT_SHIP_AVA… | UI_PROP | range2.BackColor | Color.FromArgb(80, Color.Yellow) | 속성 BackColor 설정 |  |  |  |
| AC-3d898cd0 | this.chkTotPSI.CheckedChanged [finally] 외 3 | SSP0060_ShipmentPlan.cs:5560 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (i < siMain.ActiveSheet.RowCount) ▸ if (sItemID != strTmp_ItemID) | UI_PROP | range1.Border | bevelbrdr | 속성 Border 설정 |  |  |  |

## SSP0060_ShipmentPlan.SaveData_Detail

진입점: SaveButton [else of (fps.Name == "spdMain")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-db6d1595 | SaveButton [else of (fps.Name == "spdMain")] | SSP0060_ShipmentPlan.cs:3120 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) | VALIDATE | DataUtil.checkRequiredOfSpread | (siDetail) | 프레임워크 검증 |  |  |  |
| AC-fb7f9abb | SaveButton [else of (fps.Name == "spdMain")] | SSP0060_ShipmentPlan.cs:3123 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ if (!DataUtil.ch… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b74f8f8a | SaveButton [else of (fps.Name == "spdMain")] | SSP0060_ShipmentPlan.cs:3130 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ if (chkERPIFBloc… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-dc48498d | SaveButton [else of (fps.Name == "spdMain")] | SSP0060_ShipmentPlan.cs:3134 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPI… | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-b0c668dd | SaveButton [else of (fps.Name == "spdMain")] | SSP0060_ShipmentPlan.cs:3142 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPI… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b7f76327 | SaveButton [else of (fps.Name == "spdMain")] | SSP0060_ShipmentPlan.cs:3148 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPI… | MESSAGE | MessageHelper.GMessageBox | ("MSG00133", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-950e9d6f | SaveButton [else of (fps.Name == "spdMain")] | SSP0060_ShipmentPlan.cs:3150 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPI… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2a829e2e | SaveButton [else of (fps.Name == "spdMain")] | SSP0060_ShipmentPlan.cs:3154 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPI… | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-796d704b | SaveButton [else of (fps.Name == "spdMain")] | SSP0060_ShipmentPlan.cs:3159 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPI… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b8c72ff8 | SaveButton [else of (fps.Name == "spdMain")] | SSP0060_ShipmentPlan.cs:3286 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPI… | ENDPOINT | new FoxDataRequest | ("SSP.SSP0060_SAVE_SHIPMENT_REQUEST_CONFIRM") ⇒ SSP.SSP0060_SAVE_SHIPMENT_REQUEST_CONFIRM | 엔드포인트 요청 생성 |  |  |  |
| AC-b4d96a36 | SaveButton [else of (fps.Name == "spdMain")] | SSP0060_ShipmentPlan.cs:3290 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPI… | DATA_OP | request.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-9e335b8e | SaveButton [else of (fps.Name == "spdMain")] | SSP0060_ShipmentPlan.cs:3291 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPI… | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-066ecc1c | SaveButton [else of (fps.Name == "spdMain")] | SSP0060_ShipmentPlan.cs:3292 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPI… | DATA_OP | request.Parameters["p_change_request_no"] | p_change_request_no | 행/컬럼 값 대입 |  |  |  |
| AC-9ba0c552 | SaveButton [else of (fps.Name == "spdMain")] | SSP0060_ShipmentPlan.cs:3293 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPI… | DATA_OP | request.Parameters["p_confirm_id"] | p_confirm_id | 행/컬럼 값 대입 |  |  |  |
| AC-c53e705a | SaveButton [else of (fps.Name == "spdMain")] | SSP0060_ShipmentPlan.cs:3294 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPI… | DATA_OP | request.Parameters["p_product_level1"] | p_product_level1 | 행/컬럼 값 대입 |  |  |  |
| AC-2a0bb131 | SaveButton [else of (fps.Name == "spdMain")] | SSP0060_ShipmentPlan.cs:3295 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPI… | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-2859c922 | SaveButton [else of (fps.Name == "spdMain")] | SSP0060_ShipmentPlan.cs:3296 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPI… | DATA_OP | request.Parameters["p_nick_name"] | p_nick_name | 행/컬럼 값 대입 |  |  |  |
| AC-daf5270e | SaveButton [else of (fps.Name == "spdMain")] | SSP0060_ShipmentPlan.cs:3297 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPI… | DATA_OP | request.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-5fd7d512 | SaveButton [else of (fps.Name == "spdMain")] | SSP0060_ShipmentPlan.cs:3298 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPI… | DATA_OP | request.Parameters["p_to_site"] | p_to_site | 행/컬럼 값 대입 |  |  |  |
| AC-0c7c3b94 | SaveButton [else of (fps.Name == "spdMain")] | SSP0060_ShipmentPlan.cs:3299 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPI… | DATA_OP | request.Parameters["p_project_code"] | p_project_code | 행/컬럼 값 대입 |  |  |  |
| AC-27d16cef | SaveButton [else of (fps.Name == "spdMain")] | SSP0060_ShipmentPlan.cs:3300 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPI… | DATA_OP | request.Parameters["p_project_name"] | p_project_name | 행/컬럼 값 대입 |  |  |  |
| AC-80361205 | SaveButton [else of (fps.Name == "spdMain")] | SSP0060_ShipmentPlan.cs:3301 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPI… | DATA_OP | request.Parameters["p_fcst_type"] | p_fcst_type | 행/컬럼 값 대입 |  |  |  |
| AC-00682a15 | SaveButton [else of (fps.Name == "spdMain")] | SSP0060_ShipmentPlan.cs:3302 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPI… | DATA_OP | request.Parameters["p_etd"] | p_etd | 행/컬럼 값 대입 |  |  |  |
| AC-fe280537 | SaveButton [else of (fps.Name == "spdMain")] | SSP0060_ShipmentPlan.cs:3303 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPI… | DATA_OP | request.Parameters["p_eta"] | p_eta | 행/컬럼 값 대입 |  |  |  |
| AC-e0e55548 | SaveButton [else of (fps.Name == "spdMain")] | SSP0060_ShipmentPlan.cs:3304 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPI… | DATA_OP | request.Parameters["p_shipment_qty"] | p_shipment_qty | 행/컬럼 값 대입 |  |  |  |
| AC-4fe4ecbc | SaveButton [else of (fps.Name == "spdMain")] | SSP0060_ShipmentPlan.cs:3305 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPI… | DATA_OP | request.Parameters["p_shipment_date"] | p_shipment_date | 행/컬럼 값 대입 |  |  |  |
| AC-833efb21 | SaveButton [else of (fps.Name == "spdMain")] | SSP0060_ShipmentPlan.cs:3306 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPI… | DATA_OP | request.Parameters["p_new_bod_id"] | p_new_bod_id | 행/컬럼 값 대입 |  |  |  |
| AC-22721c1a | SaveButton [else of (fps.Name == "spdMain")] | SSP0060_ShipmentPlan.cs:3307 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPI… | DATA_OP | request.Parameters["p_new_route_id"] | p_new_route_id | 행/컬럼 값 대입 |  |  |  |
| AC-a594f325 | SaveButton [else of (fps.Name == "spdMain")] | SSP0060_ShipmentPlan.cs:3308 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPI… | DATA_OP | request.Parameters["p_new_etd_date"] | p_new_etd_date | 행/컬럼 값 대입 |  |  |  |
| AC-0aa18227 | SaveButton [else of (fps.Name == "spdMain")] | SSP0060_ShipmentPlan.cs:3309 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPI… | DATA_OP | request.Parameters["p_new_eta_date"] | p_new_eta_date | 행/컬럼 값 대입 |  |  |  |
| AC-73f05e79 | SaveButton [else of (fps.Name == "spdMain")] | SSP0060_ShipmentPlan.cs:3310 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPI… | DATA_OP | request.Parameters["p_new_incoterms"] | p_new_incoterms | 행/컬럼 값 대입 |  |  |  |
| AC-f5cd2521 | SaveButton [else of (fps.Name == "spdMain")] | SSP0060_ShipmentPlan.cs:3311 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPI… | DATA_OP | request.Parameters["p_new_transport_mode"] | p_new_transport_mode | 행/컬럼 값 대입 |  |  |  |
| AC-860904c3 | SaveButton [else of (fps.Name == "spdMain")] | SSP0060_ShipmentPlan.cs:3312 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPI… | DATA_OP | request.Parameters["p_new_d_country"] | p_new_d_country | 행/컬럼 값 대입 |  |  |  |
| AC-32865bd1 | SaveButton [else of (fps.Name == "spdMain")] | SSP0060_ShipmentPlan.cs:3313 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPI… | DATA_OP | request.Parameters["p_new_d_port_code"] | p_new_d_port_code | 행/컬럼 값 대입 |  |  |  |
| AC-0f207ac8 | SaveButton [else of (fps.Name == "spdMain")] | SSP0060_ShipmentPlan.cs:3314 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPI… | DATA_OP | request.Parameters["p_new_a_country"] | p_new_a_country | 행/컬럼 값 대입 |  |  |  |
| AC-37998ca9 | SaveButton [else of (fps.Name == "spdMain")] | SSP0060_ShipmentPlan.cs:3315 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPI… | DATA_OP | request.Parameters["p_new_a_port_code"] | p_new_a_port_code | 행/컬럼 값 대입 |  |  |  |
| AC-9e933ed5 | SaveButton [else of (fps.Name == "spdMain")] | SSP0060_ShipmentPlan.cs:3316 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPI… | DATA_OP | request.Parameters["p_new_customer_lt"] | p_new_customer_lt | 행/컬럼 값 대입 |  |  |  |
| AC-841164f2 | SaveButton [else of (fps.Name == "spdMain")] | SSP0060_ShipmentPlan.cs:3317 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPI… | DATA_OP | request.Parameters["p_new_to_country"] | p_new_to_country | 행/컬럼 값 대입 |  |  |  |
| AC-9c22877b | SaveButton [else of (fps.Name == "spdMain")] | SSP0060_ShipmentPlan.cs:3318 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPI… | DATA_OP | request.Parameters["p_new_to_city"] | p_new_to_city | 행/컬럼 값 대입 |  |  |  |
| AC-f5d54bdc | SaveButton [else of (fps.Name == "spdMain")] | SSP0060_ShipmentPlan.cs:3319 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPI… | DATA_OP | request.Parameters["p_remarks"] | p_remarks | 행/컬럼 값 대입 |  |  |  |
| AC-b0c194bf | SaveButton [else of (fps.Name == "spdMain")] | SSP0060_ShipmentPlan.cs:3320 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPI… | DATA_OP | request.Parameters["p_remarks2"] | p_remarks2 | 행/컬럼 값 대입 |  |  |  |
| AC-ebda17f5 | SaveButton [else of (fps.Name == "spdMain")] | SSP0060_ShipmentPlan.cs:3321 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPI… | DATA_OP | request.Parameters["p_remarks3"] | p_remarks3 | 행/컬럼 값 대입 |  |  |  |
| AC-e1133d64 | SaveButton [else of (fps.Name == "spdMain")] | SSP0060_ShipmentPlan.cs:3322 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPI… | DATA_OP | request.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-77b90bc7 | SaveButton [else of (fps.Name == "spdMain")] | SSP0060_ShipmentPlan.cs:3323 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPI… | DATA_OP | request.Parameters["p_check_need_yn"] | p_check_need_yn | 행/컬럼 값 대입 |  |  |  |
| AC-8de85369 | SaveButton [else of (fps.Name == "spdMain")] | SSP0060_ShipmentPlan.cs:3324 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPI… | DATA_OP | request.Parameters["p_edit_main"] | p_edit_main | 행/컬럼 값 대입 |  |  |  |
| AC-9c6bd9a2 | SaveButton [else of (fps.Name == "spdMain")] | SSP0060_ShipmentPlan.cs:3325 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPI… | DATA_OP | request.Parameters["p_change_reason_code"] | p_change_reason_code | 행/컬럼 값 대입 |  |  |  |
| AC-b014d283 | SaveButton [else of (fps.Name == "spdMain")] | SSP0060_ShipmentPlan.cs:3326 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPI… | DATA_OP | request.Parameters["p_change_reason_detail"] | p_change_reason_detail | 행/컬럼 값 대입 |  |  |  |
| AC-2e29bae1 | SaveButton [else of (fps.Name == "spdMain")] | SSP0060_ShipmentPlan.cs:3327 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPI… | DATA_OP | request.Parameters["p_top_flag"] | p_top_flag | 행/컬럼 값 대입 |  |  |  |
| AC-6c25f0e8 | SaveButton [else of (fps.Name == "spdMain")] | SSP0060_ShipmentPlan.cs:3329 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPI… | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-61ee7f47 | SaveButton [else of (fps.Name == "spdMain")] | SSP0060_ShipmentPlan.cs:3335 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPI… | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-746074a7 | SaveButton [else of (fps.Name == "spdMain")] | SSP0060_ShipmentPlan.cs:3336 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPI… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { ds.Tables[0].Rows[0][1].ToString() }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-72205b7e | SaveButton [else of (fps.Name == "spdMain")] | SSP0060_ShipmentPlan.cs:3362 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPI… | MESSAGE | MessageHelper.GMessageBox | ("MSG00324") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-69448499 | SaveButton [else of (fps.Name == "spdMain")] | SSP0060_ShipmentPlan.cs:3364 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPI… | CALL_BASE | base.AddHelpButton | ("Standard Information SSP Manual") | ⚠ 의미 확인 필요 |  |  |  |
| AC-4241ec99 | SaveButton [else of (fps.Name == "spdMain")] | SSP0060_ShipmentPlan.cs:3375 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPI… | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-5400f788 | SaveButton [else of (fps.Name == "spdMain")] | SSP0060_ShipmentPlan.cs:3387 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPI… | MESSAGE | MessageHelper.GMessageBox | ("MSG00284", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-95b3f3f1 | SaveButton [else of (fps.Name == "spdMain")] | SSP0060_ShipmentPlan.cs:3398 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPI… | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-65a96b52 | SaveButton [else of (fps.Name == "spdMain")] | SSP0060_ShipmentPlan.cs:3402 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPI… | STATE_RESET | errConfrimList2.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-c82d9b23 | SaveButton [else of (fps.Name == "spdMain")] | SSP0060_ShipmentPlan.cs:3403 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPI… | FLAG | strEditSpread | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-24c00aee | SaveButton [else of (fps.Name == "spdMain")] | SSP0060_ShipmentPlan.cs:3404 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPI… | FLAG | bEdit_Mode | false | 화면 필드/플래그 변경 |  |  |  |
| AC-6ec8cc41 | SaveButton [else of (fps.Name == "spdMain")] | SSP0060_ShipmentPlan.cs:3427 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtHoldStock) | VALIDATE | DataUtil.checkRequiredOfSpread | (siDetail) | 프레임워크 검증 |  |  |  |
| AC-b50131da | SaveButton [else of (fps.Name == "spdMain")] | SSP0060_ShipmentPlan.cs:3427 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtHoldStock) ▸ if (!DataUtil.che… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e5b042ea | SaveButton [else of (fps.Name == "spdMain")] | SSP0060_ShipmentPlan.cs:3429 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtHoldStock) ▸ if (!checkValidN(… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2858059b | SaveButton [else of (fps.Name == "spdMain")] | SSP0060_ShipmentPlan.cs:3460 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtHoldStock) ▸ if (iCount > 0) | ENDPOINT | new FoxDataRequest | ("SSP.SSP0060_SAVE_HOLD_STOCK_DATA") ⇒ SSP.SSP0060_SAVE_HOLD_STOCK_DATA | 엔드포인트 요청 생성 |  |  |  |
| AC-c109d02a | SaveButton [else of (fps.Name == "spdMain")] | SSP0060_ShipmentPlan.cs:3465 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtHoldStock) ▸ if (iCount > 0) | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SSP.Plan.WSL/FoxDataService.s… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-5c25edba | SaveButton [else of (fps.Name == "spdMain")] | SSP0060_ShipmentPlan.cs:3469 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtHoldStock) ▸ if (iCount > 0) ▸… | DATA_OP | request.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-17144494 | SaveButton [else of (fps.Name == "spdMain")] | SSP0060_ShipmentPlan.cs:3470 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtHoldStock) ▸ if (iCount > 0) ▸… | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-3beefd8b | SaveButton [else of (fps.Name == "spdMain")] | SSP0060_ShipmentPlan.cs:3471 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtHoldStock) ▸ if (iCount > 0) ▸… | DATA_OP | request.Parameters["p_hold_id"] | p_hold_id | 행/컬럼 값 대입 |  |  |  |
| AC-816f204d | SaveButton [else of (fps.Name == "spdMain")] | SSP0060_ShipmentPlan.cs:3472 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtHoldStock) ▸ if (iCount > 0) ▸… | DATA_OP | request.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-cf4dda15 | SaveButton [else of (fps.Name == "spdMain")] | SSP0060_ShipmentPlan.cs:3473 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtHoldStock) ▸ if (iCount > 0) ▸… | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-4dde6c5e | SaveButton [else of (fps.Name == "spdMain")] | SSP0060_ShipmentPlan.cs:3474 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtHoldStock) ▸ if (iCount > 0) ▸… | DATA_OP | request.Parameters["p_hold_yyyymmdd"] | p_hold_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-4d7cec6f | SaveButton [else of (fps.Name == "spdMain")] | SSP0060_ShipmentPlan.cs:3475 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtHoldStock) ▸ if (iCount > 0) ▸… | DATA_OP | request.Parameters["p_release_yyyymmdd"] | p_release_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-d4a6f5b7 | SaveButton [else of (fps.Name == "spdMain")] | SSP0060_ShipmentPlan.cs:3476 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtHoldStock) ▸ if (iCount > 0) ▸… | DATA_OP | request.Parameters["p_hold_qty"] | p_hold_qty | 행/컬럼 값 대입 |  |  |  |
| AC-09b0a85a | SaveButton [else of (fps.Name == "spdMain")] | SSP0060_ShipmentPlan.cs:3477 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtHoldStock) ▸ if (iCount > 0) ▸… | DATA_OP | request.Parameters["p_remarks"] | p_remarks | 행/컬럼 값 대입 |  |  |  |
| AC-4c37f406 | SaveButton [else of (fps.Name == "spdMain")] | SSP0060_ShipmentPlan.cs:3478 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtHoldStock) ▸ if (iCount > 0) ▸… | DATA_OP | request.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-7e7ec53e | SaveButton [else of (fps.Name == "spdMain")] | SSP0060_ShipmentPlan.cs:3480 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtHoldStock) ▸ if (iCount > 0) ▸… | DATA_OP | request.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-a8f6491b | SaveButton [else of (fps.Name == "spdMain")] | SSP0060_ShipmentPlan.cs:3481 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtHoldStock) ▸ if (iCount > 0) ▸… | DATA_OP | request.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-b9f30006 | SaveButton [else of (fps.Name == "spdMain")] | SSP0060_ShipmentPlan.cs:3482 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtHoldStock) ▸ if (iCount > 0) ▸… | DATA_OP | request.Parameters["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-32de21b8 | SaveButton [else of (fps.Name == "spdMain")] | SSP0060_ShipmentPlan.cs:3484 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtHoldStock) ▸ if (iCount > 0) ▸… | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-f484e859 | SaveButton [else of (fps.Name == "spdMain")] | SSP0060_ShipmentPlan.cs:3484 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtHoldStock) ▸ if (iCount > 0) ▸… | RETURN | return client.ExecuteDataSet(request); |  | 처리 중단/반환 |  |  |  |
| AC-e11fa8d6 | SaveButton [else of (fps.Name == "spdMain")] | SSP0060_ShipmentPlan.cs:3493 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtHoldStock) ▸ if (iCount > 0) ▸… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { t.DataSet.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-370a5ba8 | SaveButton [else of (fps.Name == "spdMain")] | SSP0060_ShipmentPlan.cs:3514 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtHoldStock) ▸ if (iCount > 0) ▸… | MESSAGE | MessageHelper.GMessageBox | ("MSG00284", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SSP0060_ShipmentPlan.SaveData_Main

진입점: SaveButton [if (fps.Name == "spdMain")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cb7b3d77 | SaveButton [if (fps.Name == "spdMain")] | SSP0060_ShipmentPlan.cs:2940 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (fps.Name == "spdMain") ▸ if (siMain.ActiveSheet.Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-92b0db60 | SaveButton [if (fps.Name == "spdMain")] | SSP0060_ShipmentPlan.cs:2960 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (fps.Name == "spdMain") | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-099e90e8 | SaveButton [if (fps.Name == "spdMain")] | SSP0060_ShipmentPlan.cs:2961 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (fps.Name == "spdMain") | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-54150dcf | SaveButton [if (fps.Name == "spdMain")] | SSP0060_ShipmentPlan.cs:2992 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j <… | GRID_STYLE | siMain.SetBGColor | (i, j, i, j, ControlColor.InvalidColor) | 그리드 표시 설정 |  |  |  |
| AC-9610e27b | SaveButton [if (fps.Name == "spdMain")] | SSP0060_ShipmentPlan.cs:2993 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j <… | MESSAGE | MessageHelper.GMessageBox | ("MSG00084", new object[] { null }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e8b09cf1 | SaveButton [if (fps.Name == "spdMain")] | SSP0060_ShipmentPlan.cs:2994 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j <… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d48b114e | SaveButton [if (fps.Name == "spdMain")] | SSP0060_ShipmentPlan.cs:3029 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ try | ENDPOINT | new FoxDataRequest | ("SSP.SSP0060_SAVE_SHIPMENT_PLAN") ⇒ SSP.SSP0060_SAVE_SHIPMENT_PLAN | 엔드포인트 요청 생성 |  |  |  |
| AC-eb1a4d55 | SaveButton [if (fps.Name == "spdMain")] | SSP0060_ShipmentPlan.cs:3031 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-8ff77a76 | SaveButton [if (fps.Name == "spdMain")] | SSP0060_ShipmentPlan.cs:3032 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-a6f07731 | SaveButton [if (fps.Name == "spdMain")] | SSP0060_ShipmentPlan.cs:3033 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_company_id"] | p_company_id | 행/컬럼 값 대입 |  |  |  |
| AC-2b75a726 | SaveButton [if (fps.Name == "spdMain")] | SSP0060_ShipmentPlan.cs:3034 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-d0ebf8e8 | SaveButton [if (fps.Name == "spdMain")] | SSP0060_ShipmentPlan.cs:3035 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-4d048549 | SaveButton [if (fps.Name == "spdMain")] | SSP0060_ShipmentPlan.cs:3036 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_to_site"] | p_to_site | 행/컬럼 값 대입 |  |  |  |
| AC-d89c4c24 | SaveButton [if (fps.Name == "spdMain")] | SSP0060_ShipmentPlan.cs:3037 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_transport_mode"] | p_transport_mode | 행/컬럼 값 대입 |  |  |  |
| AC-53860071 | SaveButton [if (fps.Name == "spdMain")] | SSP0060_ShipmentPlan.cs:3038 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_incoterms"] | p_incoterms | 행/컬럼 값 대입 |  |  |  |
| AC-2c647d08 | SaveButton [if (fps.Name == "spdMain")] | SSP0060_ShipmentPlan.cs:3039 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_fcst_type"] | p_fcst_type | 행/컬럼 값 대입 |  |  |  |
| AC-7b690f85 | SaveButton [if (fps.Name == "spdMain")] | SSP0060_ShipmentPlan.cs:3040 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-c69b3b17 | SaveButton [if (fps.Name == "spdMain")] | SSP0060_ShipmentPlan.cs:3041 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_yyyymmdd"] | p_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-4d88c73d | SaveButton [if (fps.Name == "spdMain")] | SSP0060_ShipmentPlan.cs:3042 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_shipment_qty"] | p_shipment_qty | 행/컬럼 값 대입 |  |  |  |
| AC-205059ef | SaveButton [if (fps.Name == "spdMain")] | SSP0060_ShipmentPlan.cs:3043 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-810ce95d | SaveButton [if (fps.Name == "spdMain")] | SSP0060_ShipmentPlan.cs:3044 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_user_dept_id"] | p_user_dept_id | 행/컬럼 값 대입 |  |  |  |
| AC-8abd2574 | SaveButton [if (fps.Name == "spdMain")] | SSP0060_ShipmentPlan.cs:3045 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-0985329a | SaveButton [if (fps.Name == "spdMain")] | SSP0060_ShipmentPlan.cs:3047 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-1da717fa | SaveButton [if (fps.Name == "spdMain")] | SSP0060_ShipmentPlan.cs:3051 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.… | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-d2256f23 | SaveButton [if (fps.Name == "spdMain")] | SSP0060_ShipmentPlan.cs:3053 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { response.DataSet.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6a1d5eba | SaveButton [if (fps.Name == "spdMain")] | SSP0060_ShipmentPlan.cs:3058 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.… | POPUP | new SSP0060_ShipmentPlanRequestPopup | () | 팝업/폼 생성 |  |  |  |
| AC-cbfa82a5 | SaveButton [if (fps.Name == "spdMain")] | SSP0060_ShipmentPlan.cs:3059 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.… | UI_PROP | pop.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-12473cbc | SaveButton [if (fps.Name == "spdMain")] | SSP0060_ShipmentPlan.cs:3060 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.… | UI_PROP | pop._sRequestNo | "" | 속성 _sRequestNo 설정 |  |  |  |
| AC-8a626b0c | SaveButton [if (fps.Name == "spdMain")] | SSP0060_ShipmentPlan.cs:3061 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.… | POPUP | pop.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-0624bb4c | SaveButton [if (fps.Name == "spdMain")] | SSP0060_ShipmentPlan.cs:3074 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ try ▸ else of (response.Dat… | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-f4a34c51 | SaveButton [if (fps.Name == "spdMain")] | SSP0060_ShipmentPlan.cs:3086 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ try ▸ else of (response.Dat… | MESSAGE | MessageHelper.GMessageBox | ("MSG00284", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-bb129ede | SaveButton [if (fps.Name == "spdMain")] | SSP0060_ShipmentPlan.cs:3087 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ try ▸ else of (response.Dat… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9ae0eaad | SaveButton [if (fps.Name == "spdMain")] | SSP0060_ShipmentPlan.cs:3095 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a22fb60b | SaveButton [if (fps.Name == "spdMain")] | SSP0060_ShipmentPlan.cs:3096 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ catch ((Exception ex)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-871806ed | SaveButton [if (fps.Name == "spdMain")] | SSP0060_ShipmentPlan.cs:3100 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-4ca8d7cd | SaveButton [if (fps.Name == "spdMain")] | SSP0060_ShipmentPlan.cs:3101 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ finally | FLAG | strEditSpread | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-3198bc3a | SaveButton [if (fps.Name == "spdMain")] | SSP0060_ShipmentPlan.cs:3102 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ finally | FLAG | bEdit_Mode | false | 화면 필드/플래그 변경 |  |  |  |

## SSP0060_ShipmentPlan.Set_SumValues

진입점: this.chkTotPSI.CheckedChanged [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] / FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] / SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try ▸ if (dsBinding.Tables[0].Rows.Count > 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c1e0900b | this.chkTotPSI.CheckedChanged [try ▸ if (dsBinding.Tables[0]… 외 2 | SSP0060_ShipmentPlan.cs:5367 | for (nCol < dsBinding.Tables[0].Columns.Count) ▸ if (dsBinding.Tables[0].Columns[nCol].ColumnName.IndexOf("M_") == 0) | DATA_OP | listMonth.Add | (nCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-7a31faaf | this.chkTotPSI.CheckedChanged [try ▸ if (dsBinding.Tables[0]… 외 2 | SSP0060_ShipmentPlan.cs:5371 | for (nCol < dsBinding.Tables[0].Columns.Count) ▸ if (dsBinding.Tables[0].Columns[nCol].ColumnName.IndexOf("W_") == 0) | DATA_OP | listWeek.Add | (nCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-3ea8117e | this.chkTotPSI.CheckedChanged [try ▸ if (dsBinding.Tables[0]… 외 2 | SSP0060_ShipmentPlan.cs:5395 | for (iRow < dsBinding.Tables[0].Rows.Count) ▸ if (measure.Equals("WH_STOCK") \|\| measure.Equals("BALANCE")) ▸ for (iCol < dsBinding.Tables[… | GRID_SET | dsBinding.Tables[0].Rows[iRow][bef_month_idx] | dsBinding.Tables[0].Rows[iRow][bef_day_idx] | 그리드 속성/값 설정 |  |  |  |
| AC-e47c9d92 | this.chkTotPSI.CheckedChanged [try ▸ if (dsBinding.Tables[0]… 외 2 | SSP0060_ShipmentPlan.cs:5403 | for (iRow < dsBinding.Tables[0].Rows.Count) ▸ if (measure.Equals("WH_STOCK") \|\| measure.Equals("BALANCE")) ▸ for (iCol < dsBinding.Tables[… | GRID_SET | dsBinding.Tables[0].Rows[iRow][bef_week_idx] | dsBinding.Tables[0].Rows[iRow][bef_day_idx] | 그리드 속성/값 설정 |  |  |  |
| AC-cf3e6a3b | this.chkTotPSI.CheckedChanged [try ▸ if (dsBinding.Tables[0]… 외 2 | SSP0060_ShipmentPlan.cs:5413 | for (iRow < dsBinding.Tables[0].Rows.Count) ▸ if (measure.Equals("WH_STOCK") \|\| measure.Equals("BALANCE")) ▸ for (iCol < dsBinding.Tables[… | GRID_SET | dsBinding.Tables[0].Rows[iRow][bef_week_idx] | dsBinding.Tables[0].Rows[iRow][bef_day_idx] | 그리드 속성/값 설정 |  |  |  |
| AC-6e1c7f6c | this.chkTotPSI.CheckedChanged [try ▸ if (dsBinding.Tables[0]… 외 2 | SSP0060_ShipmentPlan.cs:5414 | for (iRow < dsBinding.Tables[0].Rows.Count) ▸ if (measure.Equals("WH_STOCK") \|\| measure.Equals("BALANCE")) ▸ for (iCol < dsBinding.Tables[… | GRID_SET | dsBinding.Tables[0].Rows[iRow][bef_month_idx] | dsBinding.Tables[0].Rows[iRow][bef_day_idx] | 그리드 속성/값 설정 |  |  |  |

## SSP0060_ShipmentPlan.SetChangeControl

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c0eab492 | this.Load | SSP0060_ShipmentPlan.cs:359 |  | DATA_OP | Filter["GROUP_ID"] | UserInfoContext.Current["NowGroupID"] | 행/컬럼 값 대입 |  |  |  |
| AC-4dd1150b | this.Load | SSP0060_ShipmentPlan.cs:360 |  | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-052db6e5 | this.Load | SSP0060_ShipmentPlan.cs:366 | switch (triggerControl) case "MyDivisionOut40": | FLAG | dtMyDivision | DataService.GetSSPInnerTable("MyDivisionOut40", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-9a13eac1 | this.Load | SSP0060_ShipmentPlan.cs:366 | switch (triggerControl) case "MyDivisionOut40": | COMBO_DATA | DataService.GetSSPInnerTable | ("MyDivisionOut40", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-9e91f54f | this.Load | SSP0060_ShipmentPlan.cs:371 | switch (triggerControl) case "Div_Company": | FLAG | dtCompany | DataService.GetSSPInnerTable("Div_Company", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-58641c5c | this.Load | SSP0060_ShipmentPlan.cs:371 | switch (triggerControl) case "Div_Company": | COMBO_DATA | DataService.GetSSPInnerTable | ("Div_Company", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-899eb53d | this.Load | SSP0060_ShipmentPlan.cs:376 | switch (triggerControl) case "MyCompanyID": | FLAG | dtMyCompany | DataService.GetSSPInnerTable("MyCompanyID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-2850868b | this.Load | SSP0060_ShipmentPlan.cs:376 | switch (triggerControl) case "MyCompanyID": | COMBO_DATA | DataService.GetSSPInnerTable | ("MyCompanyID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-9a8408d0 | this.Load | SSP0060_ShipmentPlan.cs:381 | switch (triggerControl) case "CHANGE_REASON_CODE_ALL": | FLAG | dtChangeReasonCode | DataService.GetSSPInnerTable("CHANGE_REASON_CODE_ALL", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-f3ed3ec9 | this.Load | SSP0060_ShipmentPlan.cs:381 | switch (triggerControl) case "CHANGE_REASON_CODE_ALL": | COMBO_DATA | DataService.GetSSPInnerTable | ("CHANGE_REASON_CODE_ALL", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-098256d8 | this.Load | SSP0060_ShipmentPlan.cs:386 | switch (triggerControl) case "OWMS_STOCK_STATUS": | FLAG | dtStockStatus | DataService.GetSSPInnerTable("OWMS_STOCK_STATUS", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-1e8f3199 | this.Load | SSP0060_ShipmentPlan.cs:386 | switch (triggerControl) case "OWMS_STOCK_STATUS": | COMBO_DATA | DataService.GetSSPInnerTable | ("OWMS_STOCK_STATUS", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-4959f47b | this.Load | SSP0060_ShipmentPlan.cs:391 | switch (triggerControl) case "SSP_SHIPMENT_RESULT_TYPE": | FLAG | dtResultType | DataService.GetSSPInnerTable("SSP_SHIPMENT_RESULT_TYPE", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-419e1159 | this.Load | SSP0060_ShipmentPlan.cs:391 | switch (triggerControl) case "SSP_SHIPMENT_RESULT_TYPE": | COMBO_DATA | DataService.GetSSPInnerTable | ("SSP_SHIPMENT_RESULT_TYPE", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-9f4c68da | this.Load | SSP0060_ShipmentPlan.cs:396 | switch (triggerControl) case "CHANGE_REQ_DAY": | FLAG | dtBaseDay | DataService.GetSSPInnerTable("CHANGE_REQ_DAY", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-e30ea5e0 | this.Load | SSP0060_ShipmentPlan.cs:396 | switch (triggerControl) case "CHANGE_REQ_DAY": | COMBO_DATA | DataService.GetSSPInnerTable | ("CHANGE_REQ_DAY", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-914ab128 | this.Load | SSP0060_ShipmentPlan.cs:401 | switch (triggerControl) case "SHIPMENT_PERIOD_DAY": | FLAG | dtShipmentInputPeriod | DataService.GetSSPInnerTable("SHIPMENT_PERIOD_DAY", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-2341ed25 | this.Load | SSP0060_ShipmentPlan.cs:401 | switch (triggerControl) case "SHIPMENT_PERIOD_DAY": | COMBO_DATA | DataService.GetSSPInnerTable | ("SHIPMENT_PERIOD_DAY", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-30e744b3 | this.Load | SSP0060_ShipmentPlan.cs:406 | switch (triggerControl) case "PgmAuthId": | FLAG | dtPgmAuthId | DataService.GetSSPInnerTable("PgmAuthId", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-38e39e4a | this.Load | SSP0060_ShipmentPlan.cs:406 | switch (triggerControl) case "PgmAuthId": | COMBO_DATA | DataService.GetSSPInnerTable | ("PgmAuthId", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |

## SSP0060_ShipmentPlan.SetChangedControl

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4e9fc204 | this.Load | SSP0060_ShipmentPlan.cs:509 | if (dtMyDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |
| AC-cbd85c9c | this.Load | SSP0060_ShipmentPlan.cs:510 | if (dtMyDivision.Rows.Count == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-234bbccf | this.Load | SSP0060_ShipmentPlan.cs:514 |  | ENDPOINT | new FoxDataRequest | ("SSP.SSP0060_GET_SHIPMENT_DIVISION") ⇒ SSP.SSP0060_GET_SHIPMENT_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-4268936c | this.Load | SSP0060_ShipmentPlan.cs:518 |  | DATA_OP | request.Parameters["Param1"] | UserInfoContext.Current["NowGroupID"] | 행/컬럼 값 대입 |  |  |  |
| AC-3a8c9653 | this.Load | SSP0060_ShipmentPlan.cs:519 |  | DATA_OP | request.Parameters["Param2"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-d2729de6 | this.Load | SSP0060_ShipmentPlan.cs:520 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-aeffa37b | this.Load | SSP0060_ShipmentPlan.cs:523 |  | FLAG | dtMyDivision | ds.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-6e116e6b | this.Load | SSP0060_ShipmentPlan.cs:524 |  | FLAG | dtCompany | ds.Tables[1] | 화면 필드/플래그 변경 |  |  |  |
| AC-a9097d5a | this.Load | SSP0060_ShipmentPlan.cs:525 |  | LIST_REBIND | clsCtrl.setListBox | (dtMyDivision, clbDivision_ID, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-f2b44e31 | this.Load | SSP0060_ShipmentPlan.cs:529 |  | DATA_OP | dtCompany.Select().Where(c => c["DIVISION_ID"].ToString() == strSelDivision_ID).CopyToData… | () | 데이터 객체 조작/조회 |  |  |  |
| AC-7066bc42 | this.Load | SSP0060_ShipmentPlan.cs:529 |  | DATA_OP | dtCompany.Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-01d7d01a | this.Load | SSP0060_ShipmentPlan.cs:531 |  | LIST_REBIND | clsCtrl.setListBox | (dtDiv_Company_ID, clbCompany_ID, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-84782682 | this.Load | SSP0060_ShipmentPlan.cs:535 |  | FLAG | sUserCompany_NM | dtMyCompany.Rows[0]["NAME"].ToString() | 화면 필드/플래그 변경 |  |  |  |

## SSP0060_ShipmentPlan.SetEndCustomer

진입점: this.spdDetail.CellDoubleClick [if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.ITEM_ID)) ▸ if (action == "I") ▸ if (popItem.ItemID != "") ▸ if (sdivision == "40")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0bdfb571 | this.spdDetail.CellDoubleClick [if (siDetail.ActiveSheet.She… | SSP0060_ShipmentPlan.cs:7989 | if (sDivision != "" && sToSite != "" && sItemId != "") | FLAG | dtEndCustomer | Data_SCP.Common(Data_SCP.Type.EndCustomerByItemForSSP, false, sDivision, sToSite, sItemId) | 화면 필드/플래그 변경 |  |  |  |
| AC-9a230528 | this.spdDetail.CellDoubleClick [if (siDetail.ActiveSheet.She… | SSP0060_ShipmentPlan.cs:7989 | if (sDivision != "" && sToSite != "" && sItemId != "") | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.EndCustomerByItemForSSP, false, sDivision, sToSite, sItemId) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-aef641df | this.spdDetail.CellDoubleClick [if (siDetail.ActiveSheet.She… | SSP0060_ShipmentPlan.cs:7990 | if (sDivision != "" && sToSite != "" && sItemId != "") | GRID_COMBO | siDetail.SetCellTypeCombo | (iROW, siDetail.GetColumnIndex(DefColumns.END_CUSTOMER), dtEndCustomer) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-66cafe33 | this.spdDetail.CellDoubleClick [if (siDetail.ActiveSheet.She… | SSP0060_ShipmentPlan.cs:7993 | if (sDivision != "" && sToSite != "" && sItemId != "") ▸ if (null != dtEndCustomer && dtEndCustomer.Rows.Count == 1) | GRID_SET | siDetail.SetValue | (iROW, siDetail.GetColumnIndex(DefColumns.END_CUSTOMER), dtEndCustomer.Rows[0]["CODE"].ToS… | 그리드 값 설정 |  |  |  |
| AC-dd3b3e48 | this.spdDetail.CellDoubleClick [if (siDetail.ActiveSheet.She… | SSP0060_ShipmentPlan.cs:7994 | if (sDivision != "" && sToSite != "" && sItemId != "") ▸ if (null != dtEndCustomer && dtEndCustomer.Rows.Count == 1) | GRID_SET | siDetail.SetText | (iROW, siDetail.GetColumnIndex(DefColumns.END_CUSTOMER), dtEndCustomer.Rows[0]["CODE"].ToS… | 그리드 값 설정 |  |  |  |
| AC-989c12c3 | this.spdDetail.CellDoubleClick [if (siDetail.ActiveSheet.She… | SSP0060_ShipmentPlan.cs:7999 | if (sDivision != "" && sToSite != "" && sItemId != "") ▸ else of (null != dtEndCustomer && dtEndCustomer.Rows.Count == 1) ▸ if (null != dtEn… | FLAG | dtEndCustomer | new DataTable() | 화면 필드/플래그 변경 |  |  |  |
| AC-3bbc8249 | this.spdDetail.CellDoubleClick [if (siDetail.ActiveSheet.She… | SSP0060_ShipmentPlan.cs:8000 | if (sDivision != "" && sToSite != "" && sItemId != "") ▸ else of (null != dtEndCustomer && dtEndCustomer.Rows.Count == 1) ▸ if (null != dtEn… | DATA_OP | dtEndCustomer.Columns.Add | ("CODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-f4be31b5 | this.spdDetail.CellDoubleClick [if (siDetail.ActiveSheet.She… | SSP0060_ShipmentPlan.cs:8001 | if (sDivision != "" && sToSite != "" && sItemId != "") ▸ else of (null != dtEndCustomer && dtEndCustomer.Rows.Count == 1) ▸ if (null != dtEn… | DATA_OP | dtEndCustomer.Columns.Add | ("NAME") | 데이터 객체 조작/조회 |  |  |  |
| AC-b0d81ae7 | this.spdDetail.CellDoubleClick [if (siDetail.ActiveSheet.She… | SSP0060_ShipmentPlan.cs:8002 | if (sDivision != "" && sToSite != "" && sItemId != "") ▸ else of (null != dtEndCustomer && dtEndCustomer.Rows.Count == 1) ▸ if (null != dtEn… | DATA_OP | dtEndCustomer.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-51b9cf46 | this.spdDetail.CellDoubleClick [if (siDetail.ActiveSheet.She… | SSP0060_ShipmentPlan.cs:8003 | if (sDivision != "" && sToSite != "" && sItemId != "") ▸ else of (null != dtEndCustomer && dtEndCustomer.Rows.Count == 1) ▸ if (null != dtEn… | DATA_OP | drRow["CODE"] | "-" | 행/컬럼 값 대입 |  |  |  |
| AC-d22abf23 | this.spdDetail.CellDoubleClick [if (siDetail.ActiveSheet.She… | SSP0060_ShipmentPlan.cs:8004 | if (sDivision != "" && sToSite != "" && sItemId != "") ▸ else of (null != dtEndCustomer && dtEndCustomer.Rows.Count == 1) ▸ if (null != dtEn… | DATA_OP | drRow["NAME"] | "-" | 행/컬럼 값 대입 |  |  |  |
| AC-f4031a6c | this.spdDetail.CellDoubleClick [if (siDetail.ActiveSheet.She… | SSP0060_ShipmentPlan.cs:8005 | if (sDivision != "" && sToSite != "" && sItemId != "") ▸ else of (null != dtEndCustomer && dtEndCustomer.Rows.Count == 1) ▸ if (null != dtEn… | DATA_OP | dtEndCustomer.Rows.Add | (drRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-8246dc05 | this.spdDetail.CellDoubleClick [if (siDetail.ActiveSheet.She… | SSP0060_ShipmentPlan.cs:8006 | if (sDivision != "" && sToSite != "" && sItemId != "") ▸ else of (null != dtEndCustomer && dtEndCustomer.Rows.Count == 1) ▸ if (null != dtEn… | GRID_COMBO | siDetail.SetCellTypeCombo | (iROW, siDetail.GetColumnIndex(DefColumns.END_CUSTOMER), dtEndCustomer) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |

## SSP0060_ShipmentPlan.SetLockSumColumn

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-489a0927 | (진입점 미연결) | SSP0060_ShipmentPlan.cs:5223 | for (iCol < spreadInfo.ActiveSheet.ColumnCount) ▸ if (spreadInfo.GetColumnTag(iCol).IndexOf("W_") == 0 \|\| spreadInfo.GetColumnTag(iCol).In… | GRID_LOCK | spreadInfo.LockRange | (0, iCol, spreadInfo.ActiveSheet.RowCount - 1, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |

## SSP0060_ShipmentPlan.SetNote_Display

진입점: this.chkTotPSI.CheckedChanged [finally ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ for (i < siMain.ActiveSheet.RowCount) ▸ if (sMeasure == "SHIP_PLAN_DETAIL" \|\| sMeasure == "SHIP_RESULT") ▸ if (sMeasure == "SHIP_PLAN_DETAIL" && sToSite != string.Empty) ▸ for (j <= siMain.GetMaxColumnIndex()) ▸ if (siMain.ActiveSheet.Columns[j].Tag.ToString().IndexOf("D_") == 0) ▸ if (CString.IsNumber(sEditYN))] / FindButton [finally ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ for (i < siMain.ActiveSheet.RowCount) ▸ if (sMeasure == "SHIP_PLAN_DETAIL" \|\| sMeasure == "SHIP_RESULT") ▸ if (sMeasure == "SHIP_PLAN_DETA…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-271bee3f | this.chkTotPSI.CheckedChanged [finally ▸ if (siMain.ActiveSh… 외 3 | SSP0060_ShipmentPlan.cs:7070 |  | DATA_OP | row.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-9ed8575c | this.chkTotPSI.CheckedChanged [finally ▸ if (siMain.ActiveSh… 외 3 | SSP0060_ShipmentPlan.cs:7071 |  | DATA_OP | row.Field | ("FROM_SITE") | 데이터 객체 조작/조회 |  |  |  |
| AC-e4d1c8fb | this.chkTotPSI.CheckedChanged [finally ▸ if (siMain.ActiveSh… 외 3 | SSP0060_ShipmentPlan.cs:7072 |  | DATA_OP | row.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-e133d507 | this.chkTotPSI.CheckedChanged [finally ▸ if (siMain.ActiveSh… 외 3 | SSP0060_ShipmentPlan.cs:7073 |  | DATA_OP | row.Field | ("TO_SITE") | 데이터 객체 조작/조회 |  |  |  |
| AC-fe976e99 | this.chkTotPSI.CheckedChanged [finally ▸ if (siMain.ActiveSh… 외 3 | SSP0060_ShipmentPlan.cs:7074 |  | DATA_OP | row.Field | ("TRANSPORT_MODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-f1e934f9 | this.chkTotPSI.CheckedChanged [finally ▸ if (siMain.ActiveSh… 외 3 | SSP0060_ShipmentPlan.cs:7075 |  | DATA_OP | row.Field | ("INCOTERMS") | 데이터 객체 조작/조회 |  |  |  |
| AC-7c4b2610 | this.chkTotPSI.CheckedChanged [finally ▸ if (siMain.ActiveSh… 외 3 | SSP0060_ShipmentPlan.cs:7076 |  | DATA_OP | row.Field | ("FCST_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-f1db08a7 | this.chkTotPSI.CheckedChanged [finally ▸ if (siMain.ActiveSh… 외 3 | SSP0060_ShipmentPlan.cs:7077 |  | DATA_OP | row.Field | ("YYYYMMDD") | 데이터 객체 조작/조회 |  |  |  |
| AC-73fecc3b | this.chkTotPSI.CheckedChanged [finally ▸ if (siMain.ActiveSh… 외 3 | SSP0060_ShipmentPlan.cs:7084 | if (drQty != null) | GRID_SET | spdMain.ActiveSheet.Cells[intRowIdx, intColIdx].Note | strNote | 그리드 속성/값 설정 |  |  |  |
| AC-9ec4dcee | this.chkTotPSI.CheckedChanged [finally ▸ if (siMain.ActiveSh… 외 3 | SSP0060_ShipmentPlan.cs:7085 | if (drQty != null) | GRID_SET | spdMain.ActiveSheet.Cells[intRowIdx, intColIdx].NoteIndicatorSize | new Size(5, 5) | 그리드 속성/값 설정 |  |  |  |
| AC-66868b4a | this.chkTotPSI.CheckedChanged [finally ▸ if (siMain.ActiveSh… 외 3 | SSP0060_ShipmentPlan.cs:7086 | if (drQty != null) | GRID_SET | spdMain.ActiveSheet.Cells[intRowIdx, intColIdx].NoteIndicatorColor | Color.Blue | 그리드 속성/값 설정 |  |  |  |
| AC-3606f897 | this.chkTotPSI.CheckedChanged [finally ▸ if (siMain.ActiveSh… 외 3 | SSP0060_ShipmentPlan.cs:7088 | if (drQty != null) | CALL_EXT | spdMain.ActiveSheet.GetStickyNoteStyleInfo | (intRowIdx, intColIdx) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f6aded7c | this.chkTotPSI.CheckedChanged [finally ▸ if (siMain.ActiveSh… 외 3 | SSP0060_ShipmentPlan.cs:7090 | if (drQty != null) | UI_PROP | nsinfo.Width | 170 | 속성 Width 설정 |  |  |  |
| AC-d1a75e2c | this.chkTotPSI.CheckedChanged [finally ▸ if (siMain.ActiveSh… 외 3 | SSP0060_ShipmentPlan.cs:7092 | if (drQty != null) | CALL_EXT | spdMain.ActiveSheet.SetStickyNoteStyleInfo | (intRowIdx, intColIdx, nsinfo) | ⚠ 의미 확인 필요 |  |  |  |

## SSP0060_ShipmentPlan.SetSpreadColumn

진입점: this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] / this.cboBucketType.SelectedIndexChanged / this.chkSum.CheckedChanged / this.chkTotPSI.CheckedChanged [try ▸ if (siMain.GetMaxRowIndex() > 0)] / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (fps.Name == "spdMain") ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / this.btnSearch.Click [if (spdDetail.ActiveSheetIndex == 0) ▸ try ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / this.spdMain.CellDoubleClick [if (spdInfo.SheetName == SpdSheet.shtMain)] / clbCompany_ID.SelectedIndexChanged [if (spdInfo.SheetName == SpdSheet…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-76d5f915 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 10 | SSP0060_ShipmentPlan.cs:5126 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Daily) ▸ if (siMain.GetColumnTag(iCol).IndexOf("D_"… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-14ed38cc | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 10 | SSP0060_ShipmentPlan.cs:5131 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Daily) ▸ if (siMain.GetColumnTag(iCol).IndexOf("M_"… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | chkSum.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-71e8a93a | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 10 | SSP0060_ShipmentPlan.cs:5138 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Bu… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-cee8e2aa | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 10 | SSP0060_ShipmentPlan.cs:5142 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Bu… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-2253dd61 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 10 | SSP0060_ShipmentPlan.cs:5147 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Bu… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | chkSum.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-d5dfb9eb | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 10 | SSP0060_ShipmentPlan.cs:5154 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ else of (cboBucketType.ControlValues … | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-ba1bdb25 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 10 | SSP0060_ShipmentPlan.cs:5158 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ else of (cboBucketType.ControlValues … | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |

## SSP0060_ShipmentPlan.ShipmentResult_GetDayRange

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c344d143 | this.Load | SSP0060_ShipmentPlan.cs:7953 |  | RETURN | return sDayRange; |  | 처리 중단/반환 |  |  |  |

## SSP0060_ShipmentPlan.shtDetail_Change

진입점: dsdm.Changed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-761dceab | dsdm.Changed | SSP0060_ShipmentPlan.cs:1059 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (this.CanModelChange != true \|\| e.Row == -1 && e… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8abe9715 | dsdm.Changed | SSP0060_ShipmentPlan.cs:1060 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c77d4762 | dsdm.Changed | SSP0060_ShipmentPlan.cs:1069 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.IsLock(siDetail.SheetName) == false) ▸ i… | MESSAGE | MessageHelper.GMessageBox | ("MSG00189") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-de76bd2b | dsdm.Changed | SSP0060_ShipmentPlan.cs:1070 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.IsLock(siDetail.SheetName) == false) ▸ i… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b9f2c3cf | dsdm.Changed | SSP0060_ShipmentPlan.cs:1136 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.IsLock(siDetail.SheetName) == false) ▸ i… | MESSAGE | MessageHelper.GMessageBox | ("MSG00278") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0344ac44 | dsdm.Changed | SSP0060_ShipmentPlan.cs:1137 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.IsLock(siDetail.SheetName) == false) ▸ i… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ab7a36b2 | dsdm.Changed | SSP0060_ShipmentPlan.cs:1151 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.IsLock(siDetail.SheetName) == false) ▸ i… | GRID_SET | siDetail.SetValue | (e.Row, siDetail.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-8a80f3d2 | dsdm.Changed | SSP0060_ShipmentPlan.cs:1161 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.IsLock(siDetail.SheetName) == false) ▸ i… | GRID_SET | siDetail.SetValue | (iRow, siDetail.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-2e02fe31 | dsdm.Changed | SSP0060_ShipmentPlan.cs:1163 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.IsLock(siDetail.SheetName) == false) ▸ i… | GRID_SET | siDetail.ActiveSheet.Cells[iRow, siDetail.GetColumnIndex(CAppSetting.StringAction)].Value | CAppSetting.StringM | 그리드 속성/값 설정 |  |  |  |
| AC-7bf46b1b | dsdm.Changed | SSP0060_ShipmentPlan.cs:1164 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.IsLock(siDetail.SheetName) == false) ▸ i… | GRID_SET | siDetail.ActiveSheet.Cells[iRow, siDetail.GetColumnIndex(CAppSetting.StringAction)].ForeCo… | ControlColor.FGAction | 그리드 속성/값 설정 |  |  |  |
| AC-fe2500ff | dsdm.Changed | SSP0060_ShipmentPlan.cs:1165 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.IsLock(siDetail.SheetName) == false) ▸ i… | GRID_SET | siDetail.ActiveSheet.Cells[iRow, siDetail.GetColumnIndex(CAppSetting.StringAction)].BackCo… | ControlColor.BGModified | 그리드 속성/값 설정 |  |  |  |
| AC-bc45a4fe | dsdm.Changed | SSP0060_ShipmentPlan.cs:1169 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.IsLock(siDetail.SheetName) == false) ▸ i… | GRID_SET | siDetail.SetValue | (e.Row, siDetail.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-086c3197 | dsdm.Changed | SSP0060_ShipmentPlan.cs:1180 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.IsLock(siDetail.SheetName) == false) ▸ e… | GRID_SET | siDetail.SetValue | (e.Row, siDetail.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-5303c0a7 | dsdm.Changed | SSP0060_ShipmentPlan.cs:1190 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.IsLock(siDetail.SheetName) == false) ▸ e… | GRID_SET | siDetail.SetValue | (iRow, siDetail.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-663bd9e1 | dsdm.Changed | SSP0060_ShipmentPlan.cs:1192 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.IsLock(siDetail.SheetName) == false) ▸ e… | GRID_SET | siDetail.ActiveSheet.Cells[iRow, siDetail.GetColumnIndex(CAppSetting.StringAction)].Value | CAppSetting.StringM | 그리드 속성/값 설정 |  |  |  |
| AC-74e75fb9 | dsdm.Changed | SSP0060_ShipmentPlan.cs:1193 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.IsLock(siDetail.SheetName) == false) ▸ e… | GRID_SET | siDetail.ActiveSheet.Cells[iRow, siDetail.GetColumnIndex(CAppSetting.StringAction)].ForeCo… | ControlColor.FGAction | 그리드 속성/값 설정 |  |  |  |
| AC-5ce0ad02 | dsdm.Changed | SSP0060_ShipmentPlan.cs:1194 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.IsLock(siDetail.SheetName) == false) ▸ e… | GRID_SET | siDetail.ActiveSheet.Cells[iRow, siDetail.GetColumnIndex(CAppSetting.StringAction)].BackCo… | ControlColor.BGModified | 그리드 속성/값 설정 |  |  |  |
| AC-0c877091 | dsdm.Changed | SSP0060_ShipmentPlan.cs:1209 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.IsLock(siDetail.SheetName) == false) ▸ e… | GRID_SET | siDetail.SetValue | (e.Row, siDetail.GetColumnIndex(DefColumns.CHANGE_REASON_DETAIL), "") | 그리드 값 설정 |  |  |  |
| AC-b4773914 | dsdm.Changed | SSP0060_ShipmentPlan.cs:1210 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.IsLock(siDetail.SheetName) == false) ▸ e… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9a3d67ef | dsdm.Changed | SSP0060_ShipmentPlan.cs:1214 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.IsLock(siDetail.SheetName) == false) ▸ e… | GRID_SET | siDetail.SetValue | (e.Row, siDetail.GetColumnIndex(DefColumns.CHANGE_REASON_DETAIL), "") | 그리드 값 설정 |  |  |  |
| AC-c7a546d3 | dsdm.Changed | SSP0060_ShipmentPlan.cs:1221 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.IsLock(siDetail.SheetName) == false) ▸ e… | GRID_SET | siDetail.SetValue | (e.Row, siDetail.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-3cba9c4f | dsdm.Changed | SSP0060_ShipmentPlan.cs:1231 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.IsLock(siDetail.SheetName) == false) ▸ e… | GRID_SET | siDetail.SetValue | (iRow, siDetail.GetColumnIndex(DefColumns.CHANGE_REASON_CODE), sNewChangeReasonCode) | 그리드 값 설정 |  |  |  |
| AC-9b0be63b | dsdm.Changed | SSP0060_ShipmentPlan.cs:1232 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.IsLock(siDetail.SheetName) == false) ▸ e… | GRID_SET | siDetail.SetValue | (iRow, siDetail.GetColumnIndex(DefColumns.CHANGE_REASON_DETAIL), sNewChangeReasonDetail) | 그리드 값 설정 |  |  |  |
| AC-837e95ed | dsdm.Changed | SSP0060_ShipmentPlan.cs:1233 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.IsLock(siDetail.SheetName) == false) ▸ e… | GRID_SET | siDetail.SetValue | (iRow, siDetail.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-a0c94579 | dsdm.Changed | SSP0060_ShipmentPlan.cs:1245 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.IsLock(siDetail.SheetName) == false) ▸ e… | GRID_SET | siDetail.SetValue | (e.Row, siDetail.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-645f823e | dsdm.Changed | SSP0060_ShipmentPlan.cs:1255 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.IsLock(siDetail.SheetName) == false) ▸ e… | GRID_SET | siDetail.SetValue | (iRow, siDetail.GetColumnIndex(DefColumns.CHANGE_REASON_DETAIL), sNewChangeReasonDetail) | 그리드 값 설정 |  |  |  |
| AC-cd792b58 | dsdm.Changed | SSP0060_ShipmentPlan.cs:1256 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.IsLock(siDetail.SheetName) == false) ▸ e… | GRID_SET | siDetail.SetValue | (iRow, siDetail.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |

## SSP0060_ShipmentPlan.Simulation

진입점: this.btnSimulation.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-66f02c68 | this.btnSimulation.Click | SSP0060_ShipmentPlan.cs:7481 | if (bContainer_Flag == true) ▸ if (bRealFlag == false) | MESSAGE | MessageHelper.GMessageBox | ("MSG00292", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9477ae5a | this.btnSimulation.Click | SSP0060_ShipmentPlan.cs:7484 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-86956433 | this.btnSimulation.Click | SSP0060_ShipmentPlan.cs:7485 |  | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-005d496f | this.btnSimulation.Click | SSP0060_ShipmentPlan.cs:7488 | try | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.Container_Size, false) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-180f4123 | this.btnSimulation.Click | SSP0060_ShipmentPlan.cs:7509 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(DefColumns.MEASURE)].Text == "SHIP_PLAN" &&… | DATA_OP | dtContainer.Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-e121a187 | this.btnSimulation.Click | SSP0060_ShipmentPlan.cs:7509 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(DefColumns.MEASURE)].Text == "SHIP_PLAN" &&… | DATA_OP | row.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-fa62969e | this.btnSimulation.Click | SSP0060_ShipmentPlan.cs:7510 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(DefColumns.MEASURE)].Text == "SHIP_PLAN" &&… | DATA_OP | row.Field | ("FROM_SITE") | 데이터 객체 조작/조회 |  |  |  |
| AC-1156cd88 | this.btnSimulation.Click | SSP0060_ShipmentPlan.cs:7511 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(DefColumns.MEASURE)].Text == "SHIP_PLAN" &&… | DATA_OP | row.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-bd72274f | this.btnSimulation.Click | SSP0060_ShipmentPlan.cs:7515 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(DefColumns.MEASURE)].Text == "SHIP_PLAN" &&… | CALL_EXT | CommonUtils.GetValueDouble | (dr["Container_Qty"].ToString()) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ec7f388b | this.btnSimulation.Click | SSP0060_ShipmentPlan.cs:7533 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(DefColumns.MEASURE)].Text == "SHIP_PLAN" &&… | CALL_EXT | CommonUtils.GetValueInt | (siMain.GetValue(i, j).ToString()) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e5f02506 | this.btnSimulation.Click | SSP0060_ShipmentPlan.cs:7559 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(DefColumns.MEASURE)].Text == "SHIP_PLAN" &&… | CALL_EXT | CommonUtils.GetValueInt | (siMain.GetValue(intWHSearchIdx, j - (1 + intSum_Cnt)).ToString()) | ⚠ 의미 확인 필요 |  |  |  |
| AC-0b56e519 | this.btnSimulation.Click | SSP0060_ShipmentPlan.cs:7559 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(DefColumns.MEASURE)].Text == "SHIP_PLAN" &&… | CALL_EXT | CommonUtils.GetValueInt | (siMain.GetValue(intProdSerchIdx, j - (1 + intSum_Cnt)).ToString()) | ⚠ 의미 확인 필요 |  |  |  |
| AC-6a12f047 | this.btnSimulation.Click | SSP0060_ShipmentPlan.cs:7560 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(DefColumns.MEASURE)].Text == "SHIP_PLAN" &&… | CALL_EXT | CommonUtils.GetValueInt | (siMain.GetValue(i, j - (1 + intSum_Cnt)).ToString()) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ed96687a | this.btnSimulation.Click | SSP0060_ShipmentPlan.cs:7560 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(DefColumns.MEASURE)].Text == "SHIP_PLAN" &&… | CALL_EXT | CommonUtils.GetValueInt | (siMain.GetValue(intMOVEMENTIdx, j - (1 + intSum_Cnt)).ToString()) | ⚠ 의미 확인 필요 |  |  |  |
| AC-14cd1602 | this.btnSimulation.Click | SSP0060_ShipmentPlan.cs:7563 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(DefColumns.MEASURE)].Text == "SHIP_PLAN" &&… | GRID_SET | siMain.SetValue | (intWHSearchIdx, j, intWH_Qty) | 그리드 값 설정 |  |  |  |
| AC-038783aa | this.btnSimulation.Click | SSP0060_ShipmentPlan.cs:7580 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(DefColumns.MEASURE)].Text == "SHIP_PLAN" &&… | CALL_EXT | CommonUtils.GetValueInt | (siMain.GetValue(intWHSearchIdx, j).ToString()) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c515d8a9 | this.btnSimulation.Click | SSP0060_ShipmentPlan.cs:7580 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(DefColumns.MEASURE)].Text == "SHIP_PLAN" &&… | CALL_EXT | CommonUtils.GetValueInt | (siMain.GetValue(i, j).ToString()) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d8eeda65 | this.btnSimulation.Click | SSP0060_ShipmentPlan.cs:7582 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(DefColumns.MEASURE)].Text == "SHIP_PLAN" &&… | GRID_SET | siMain.SetValue | (intBalanceIdx, j, intBalance) | 그리드 값 설정 |  |  |  |
| AC-ec7640de | this.btnSimulation.Click | SSP0060_ShipmentPlan.cs:7597 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(DefColumns.MEASURE)].Text == "SHIP_PLAN" &&… | CALL_EXT | CommonUtils.GetValueDouble | (siMain.GetValue(i, j).ToString()) | ⚠ 의미 확인 필요 |  |  |  |
| AC-bda49fa8 | this.btnSimulation.Click | SSP0060_ShipmentPlan.cs:7601 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(DefColumns.MEASURE)].Text == "SHIP_PLAN" &&… | GRID_SET | siMain.SetValue | (intContainerIdx, j, intContainer) | 그리드 값 설정 |  |  |  |
| AC-b0767f98 | this.btnSimulation.Click | SSP0060_ShipmentPlan.cs:7682 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (strMeasure == "WH_STOCK") ▸ for (j <= siMain.GetMaxColumnIndex()) ▸ if (siMain.ActiveSheet.Co… | CALL_EXT | CommonUtils.GetValueInt | (siMain.GetValue(i, j).ToString()) | ⚠ 의미 확인 필요 |  |  |  |
| AC-0ce1bbf0 | this.btnSimulation.Click | SSP0060_ShipmentPlan.cs:7689 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (strMeasure == "WH_STOCK") ▸ for (j <= siMain.GetMaxColumnIndex()) ▸ else of (siMain.ActiveShe… | GRID_SET | siMain.SetValue | (i, whTemp, intSumWH_Qty) | 그리드 값 설정 |  |  |  |
| AC-39d88a24 | this.btnSimulation.Click | SSP0060_ShipmentPlan.cs:7695 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (strMeasure == "WH_STOCK") ▸ for (j <= siMain.GetMaxColumnIndex()) ▸ else of (siMain.ActiveShe… | GRID_SET | siMain.SetValue | (i, whTemp3, intTotWH_Qty) | 그리드 값 설정 |  |  |  |
| AC-2e4cbdf6 | this.btnSimulation.Click | SSP0060_ShipmentPlan.cs:7704 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (strMeasure == "WH_STOCK") | GRID_SET | siMain.SetValue | (i, whTemp, intSumWH_Qty) | 그리드 값 설정 |  |  |  |
| AC-503779c8 | this.btnSimulation.Click | SSP0060_ShipmentPlan.cs:7713 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (strMeasure == "BALANCE") ▸ for (j <= siMain.GetMaxColumnIndex()) ▸ if (siMain.ActiveSheet.Col… | CALL_EXT | CommonUtils.GetValueInt | (siMain.GetValue(i, j).ToString()) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e1b19926 | this.btnSimulation.Click | SSP0060_ShipmentPlan.cs:7719 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (strMeasure == "BALANCE") ▸ for (j <= siMain.GetMaxColumnIndex()) ▸ else of (siMain.ActiveShee… | GRID_SET | siMain.SetValue | (i, balnceTemp, intSumBalance) | 그리드 값 설정 |  |  |  |
| AC-4531de8d | this.btnSimulation.Click | SSP0060_ShipmentPlan.cs:7725 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (strMeasure == "BALANCE") ▸ for (j <= siMain.GetMaxColumnIndex()) ▸ else of (siMain.ActiveShee… | GRID_SET | siMain.SetValue | (i, balnceTem3, intTotBalance) | 그리드 값 설정 |  |  |  |
| AC-5a7c040f | this.btnSimulation.Click | SSP0060_ShipmentPlan.cs:7734 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (strMeasure == "BALANCE") | GRID_SET | siMain.SetValue | (i, balnceTemp, intSumBalance) | 그리드 값 설정 |  |  |  |
| AC-50e2edc4 | this.btnSimulation.Click | SSP0060_ShipmentPlan.cs:7743 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (strMeasure == "SHIP_REQ") ▸ for (j <= siMain.GetMaxColumnIndex()) ▸ if (siMain.ActiveSheet.Co… | CALL_EXT | CommonUtils.GetValueInt | (siMain.GetValue(i, j).ToString()) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f4fdf085 | this.btnSimulation.Click | SSP0060_ShipmentPlan.cs:7750 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (strMeasure == "SHIP_REQ") ▸ for (j <= siMain.GetMaxColumnIndex()) ▸ else of (siMain.ActiveShe… | GRID_SET | siMain.SetValue | (i, shipReqTemp, intSumShipReq_Qty) | 그리드 값 설정 |  |  |  |
| AC-aed8357d | this.btnSimulation.Click | SSP0060_ShipmentPlan.cs:7758 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (strMeasure == "SHIP_REQ") ▸ for (j <= siMain.GetMaxColumnIndex()) ▸ else of (siMain.ActiveShe… | GRID_SET | siMain.SetValue | (i, shipReqTemp3, intTotShipReq_Qty) | 그리드 값 설정 |  |  |  |
| AC-8869b979 | this.btnSimulation.Click | SSP0060_ShipmentPlan.cs:7767 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (strMeasure == "SHIP_REQ") | GRID_SET | siMain.SetValue | (i, shipReqTemp, intSumShipReq_Qty) | 그리드 값 설정 |  |  |  |
| AC-a1e3f255 | this.btnSimulation.Click | SSP0060_ShipmentPlan.cs:7776 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (strMeasure == "SHIP_PLAN") ▸ for (j <= siMain.GetMaxColumnIndex()) ▸ if (siMain.ActiveSheet.C… | CALL_EXT | CommonUtils.GetValueInt | (siMain.GetValue(i, j).ToString()) | ⚠ 의미 확인 필요 |  |  |  |
| AC-5b066821 | this.btnSimulation.Click | SSP0060_ShipmentPlan.cs:7781 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (strMeasure == "SHIP_PLAN") ▸ for (j <= siMain.GetMaxColumnIndex()) ▸ else of (siMain.ActiveSh… | GRID_SET | siMain.SetValue | (i, shipPlanTemp, intSumShipPlan_Qty) | 그리드 값 설정 |  |  |  |
| AC-988737d8 | this.btnSimulation.Click | SSP0060_ShipmentPlan.cs:7788 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (strMeasure == "SHIP_PLAN") ▸ for (j <= siMain.GetMaxColumnIndex()) ▸ else of (siMain.ActiveSh… | GRID_SET | siMain.SetValue | (i, shipPlanTemp3, intTotShipPlan_Qty) | 그리드 값 설정 |  |  |  |
| AC-d246f356 | this.btnSimulation.Click | SSP0060_ShipmentPlan.cs:7797 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (strMeasure == "SHIP_PLAN") | GRID_SET | siMain.SetValue | (i, shipPlanTemp, intSumShipPlan_Qty) | 그리드 값 설정 |  |  |  |
| AC-8068f1bb | this.btnSimulation.Click | SSP0060_ShipmentPlan.cs:7806 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (strMeasure == "INTN_MOVEMENT") ▸ for (j <= siMain.GetMaxColumnIndex()) ▸ if (siMain.ActiveShe… | CALL_EXT | CommonUtils.GetValueInt | (siMain.GetValue(i, j).ToString()) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d216d228 | this.btnSimulation.Click | SSP0060_ShipmentPlan.cs:7811 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (strMeasure == "INTN_MOVEMENT") ▸ for (j <= siMain.GetMaxColumnIndex()) ▸ else of (siMain.Acti… | GRID_SET | siMain.SetValue | (i, shipMoveTemp, intSumShipMove_Qty) | 그리드 값 설정 |  |  |  |
| AC-d578a70e | this.btnSimulation.Click | SSP0060_ShipmentPlan.cs:7818 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (strMeasure == "INTN_MOVEMENT") ▸ for (j <= siMain.GetMaxColumnIndex()) ▸ else of (siMain.Acti… | GRID_SET | siMain.SetValue | (i, shipMoveTemp3, intTotShipMove_Qty) | 그리드 값 설정 |  |  |  |
| AC-216a2af6 | this.btnSimulation.Click | SSP0060_ShipmentPlan.cs:7827 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (strMeasure == "INTN_MOVEMENT") | GRID_SET | siMain.SetValue | (i, shipMoveTemp, intSumShipMove_Qty) | 그리드 값 설정 |  |  |  |
| AC-16ef31c9 | this.btnSimulation.Click | SSP0060_ShipmentPlan.cs:7836 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (strMeasure == "CONTAINER") ▸ for (j <= siMain.GetMaxColumnIndex()) ▸ if (siMain.ActiveSheet.C… | CALL_EXT | CommonUtils.GetValueInt | (siMain.GetValue(i, j) == "" ? "0" : siMain.GetValue(i, j).ToString()) | ⚠ 의미 확인 필요 |  |  |  |
| AC-302bda86 | this.btnSimulation.Click | SSP0060_ShipmentPlan.cs:7840 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (strMeasure == "CONTAINER") ▸ for (j <= siMain.GetMaxColumnIndex()) ▸ else of (siMain.ActiveSh… | GRID_SET | siMain.SetValue | (i, shipContainerTemp, intSumContainer_Qty) | 그리드 값 설정 |  |  |  |
| AC-34b1328b | this.btnSimulation.Click | SSP0060_ShipmentPlan.cs:7847 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (strMeasure == "CONTAINER") ▸ for (j <= siMain.GetMaxColumnIndex()) ▸ else of (siMain.ActiveSh… | GRID_SET | siMain.SetValue | (i, shipContainerTemp3, intTotContainer_Qty) | 그리드 값 설정 |  |  |  |
| AC-d7ac143c | this.btnSimulation.Click | SSP0060_ShipmentPlan.cs:7856 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (strMeasure == "CONTAINER") | GRID_SET | siMain.SetValue | (i, shipContainerTemp, intSumContainer_Qty) | 그리드 값 설정 |  |  |  |
| AC-7e4dab6a | this.btnSimulation.Click | SSP0060_ShipmentPlan.cs:7865 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (strMeasure == "PROD_PLAN") ▸ for (j <= siMain.GetMaxColumnIndex()) ▸ if (siMain.ActiveSheet.C… | CALL_EXT | CommonUtils.GetValueInt | (siMain.GetValue(i, j).ToString()) | ⚠ 의미 확인 필요 |  |  |  |
| AC-aa467452 | this.btnSimulation.Click | SSP0060_ShipmentPlan.cs:7870 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (strMeasure == "PROD_PLAN") ▸ for (j <= siMain.GetMaxColumnIndex()) ▸ else of (siMain.ActiveSh… | GRID_SET | siMain.SetValue | (i, shipProdTemp, intSumProd_Qty) | 그리드 값 설정 |  |  |  |
| AC-ee1dc31b | this.btnSimulation.Click | SSP0060_ShipmentPlan.cs:7877 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (strMeasure == "PROD_PLAN") ▸ for (j <= siMain.GetMaxColumnIndex()) ▸ else of (siMain.ActiveSh… | GRID_SET | siMain.SetValue | (i, shipProdTemp3, intTotProd_Qty) | 그리드 값 설정 |  |  |  |
| AC-8a7d4e43 | this.btnSimulation.Click | SSP0060_ShipmentPlan.cs:7886 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (strMeasure == "PROD_PLAN") | GRID_SET | siMain.SetValue | (i, shipProdTemp, intSumProd_Qty) | 그리드 값 설정 |  |  |  |
| AC-d6e98117 | this.btnSimulation.Click | SSP0060_ShipmentPlan.cs:7896 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SSP0060_ShipmentPlan.SoNo

진입점: SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPIFBlockYn()) ▸ try ▸ try ▸ for (i <= siDetail.ActiveSheet.RowCount - 1) ▸ if (action != CAppSetting.FlagI) ▸ else of (string.IsNullOrWhiteSpace(erpSoNo))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-03c5e702 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:4266 | for (i < intRowIdx) ▸ if (erpSoNo == siDetail.GetValue(i, siDetail.GetColumnIndex(DefColumns.ERP_SO_NO)).ToString()) ▸ if (intRowIdx > i) | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-d9ebaf2a | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:4380 |  | ENDPOINT | new FoxDataRequest | ("SSP.SSP0060_SAVE_SHIPMENT_REQUEST_DRAFTING") ⇒ SSP.SSP0060_SAVE_SHIPMENT_REQUEST_DRAFTING | 엔드포인트 요청 생성 |  |  |  |
| AC-f75c750a | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:4384 |  | DATA_OP | request.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-46b153ee | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:4385 |  | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-135653fe | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:4386 |  | DATA_OP | request.Parameters["p_confirm_id"] | p_confirm_id | 행/컬럼 값 대입 |  |  |  |
| AC-441de11f | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:4387 |  | DATA_OP | request.Parameters["p_shipment_qty"] | p_shipment_qty | 행/컬럼 값 대입 |  |  |  |
| AC-ab534891 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:4388 |  | DATA_OP | request.Parameters["p_shipment_date"] | p_shipment_date | 행/컬럼 값 대입 |  |  |  |
| AC-46d0a91a | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:4389 |  | DATA_OP | request.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-ce68819d | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:4390 |  | DATA_OP | request.Parameters["p_new_bod_id"] | p_new_bod_id | 행/컬럼 값 대입 |  |  |  |
| AC-f5229f5e | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:4391 |  | DATA_OP | request.Parameters["p_new_route_id"] | p_new_route_id | 행/컬럼 값 대입 |  |  |  |
| AC-5b195da2 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:4392 |  | DATA_OP | request.Parameters["p_new_etd_date"] | p_new_etd_date | 행/컬럼 값 대입 |  |  |  |
| AC-5079c040 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:4393 |  | DATA_OP | request.Parameters["p_new_eta_date"] | p_new_eta_date | 행/컬럼 값 대입 |  |  |  |
| AC-ed7a20b2 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:4394 |  | DATA_OP | request.Parameters["p_new_incoterms"] | p_new_incoterms | 행/컬럼 값 대입 |  |  |  |
| AC-c302d849 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:4395 |  | DATA_OP | request.Parameters["p_new_transport_mode"] | p_new_transport_mode | 행/컬럼 값 대입 |  |  |  |
| AC-09ce5150 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:4396 |  | DATA_OP | request.Parameters["p_new_d_contry"] | p_new_d_contry | 행/컬럼 값 대입 |  |  |  |
| AC-5e2a0021 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:4397 |  | DATA_OP | request.Parameters["p_new_d_port_code"] | p_new_d_port_code | 행/컬럼 값 대입 |  |  |  |
| AC-7be7494c | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:4398 |  | DATA_OP | request.Parameters["p_new_a_country"] | p_new_a_country | 행/컬럼 값 대입 |  |  |  |
| AC-675a6ebf | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:4399 |  | DATA_OP | request.Parameters["p_new_a_port_code"] | p_new_a_port_code | 행/컬럼 값 대입 |  |  |  |
| AC-bc9bb60a | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:4400 |  | DATA_OP | request.Parameters["p_new_customer_lt"] | p_new_customer_lt | 행/컬럼 값 대입 |  |  |  |
| AC-cca8b0c9 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:4401 |  | DATA_OP | request.Parameters["p_new_to_country"] | p_new_to_country | 행/컬럼 값 대입 |  |  |  |
| AC-6a56ebcc | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:4402 |  | DATA_OP | request.Parameters["p_new_to_city"] | p_new_to_city | 행/컬럼 값 대입 |  |  |  |
| AC-a89faddf | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:4403 |  | DATA_OP | request.Parameters["p_edit_main"] | p_edit_main | 행/컬럼 값 대입 |  |  |  |
| AC-1933fa77 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:4404 |  | DATA_OP | request.Parameters["p_edit_remark"] | p_edit_remark | 행/컬럼 값 대입 |  |  |  |
| AC-150d5459 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:4405 |  | DATA_OP | request.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-edbdd0bf | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:4406 |  | DATA_OP | request.Parameters["p_user_dept_id"] | p_user_dept_id | 행/컬럼 값 대입 |  |  |  |
| AC-4c272ce2 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:4407 |  | DATA_OP | request.Parameters["p_electrode_yn"] | p_electrode_yn | 행/컬럼 값 대입 |  |  |  |
| AC-baf858c3 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:4408 |  | DATA_OP | request.Parameters["p_electrode_type"] | p_electrode_type | 행/컬럼 값 대입 |  |  |  |
| AC-305c59e6 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:4409 |  | DATA_OP | request.Parameters["p_origin_from_division_id"] | p_origin_from_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-14ac445a | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:4410 |  | DATA_OP | request.Parameters["p_origion_to_division_id"] | p_origion_to_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-777f992a | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:4412 |  | DATA_OP | request.Parameters["p_remarks"] | p_remarks | 행/컬럼 값 대입 |  |  |  |
| AC-c59b57d0 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:4413 |  | DATA_OP | request.Parameters["p_remarks2"] | p_remarks2 | 행/컬럼 값 대입 |  |  |  |
| AC-1a368495 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:4414 |  | DATA_OP | request.Parameters["p_remarks3"] | p_remarks3 | 행/컬럼 값 대입 |  |  |  |
| AC-7a6023f2 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:4416 |  | DATA_OP | request.Parameters["p_change_reason_code"] | p_change_reason_code | 행/컬럼 값 대입 |  |  |  |
| AC-aa7a70b9 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:4417 |  | DATA_OP | request.Parameters["p_change_reason_detail"] | p_change_reason_datail | 행/컬럼 값 대입 |  |  |  |
| AC-682220a4 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:4418 |  | DATA_OP | request.Parameters["p_title"] | p_title | 행/컬럼 값 대입 |  |  |  |
| AC-cb829e68 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:4419 |  | DATA_OP | request.Parameters["p_program_id"] | p_program_id | 행/컬럼 값 대입 |  |  |  |
| AC-efe93df0 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:4421 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a01be0d3 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:4442 | else of (ds.Tables[0].Rows[0][0].ToString() == "S") ▸ if (ds.Tables[0].Rows[0][0].ToString() == "X") | MESSAGE | MessageHelper.GMessageBox | ("MSG00324") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a58da49b | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:4444 | else of (ds.Tables[0].Rows[0][0].ToString() == "S") ▸ if (ds.Tables[0].Rows[0][0].ToString() == "X") ▸ if (MessageHelper.GMessageBox("MSG003… | CALL_BASE | base.AddHelpButton | ("Standard Information SSP Manual") | ⚠ 의미 확인 필요 |  |  |  |
| AC-43210066 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:4465 | else of (ds.Tables[0].Rows[0][0].ToString() == "S") ▸ else of (ds.Tables[0].Rows[0][0].ToString() == "X") | MESSAGE | MessageHelper.GMessageBox | ("MSG00284", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-56ccd69c | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:4469 |  | RETURN | return bReturn; |  | 처리 중단/반환 |  |  |  |

## SSP0060_ShipmentPlan.SpdDetail_ActiveSheetChanged

진입점: this.spdDetail.ActiveSheetChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a552eb1e | this.spdDetail.ActiveSheetChanged | SSP0060_ShipmentPlan.cs:2208 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") | UI_PROP | layoutControlItem11.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-7a451f2c | this.spdDetail.ActiveSheetChanged | SSP0060_ShipmentPlan.cs:2209 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") | UI_PROP | layoutControlItem4.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-f8d36936 | this.spdDetail.ActiveSheetChanged | SSP0060_ShipmentPlan.cs:2210 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") | UI_PROP | layoutControlItem5.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-fed3da0c | this.spdDetail.ActiveSheetChanged | SSP0060_ShipmentPlan.cs:2211 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") | UI_PROP | lcProductLevel12.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-9a3c4ccc | this.spdDetail.ActiveSheetChanged | SSP0060_ShipmentPlan.cs:2212 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") | UI_PROP | Requestor.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-68012596 | this.spdDetail.ActiveSheetChanged | SSP0060_ShipmentPlan.cs:2213 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") | UI_PROP | layoutControlItem9.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-caba3b2f | this.spdDetail.ActiveSheetChanged | SSP0060_ShipmentPlan.cs:2214 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") | UI_PROP | layoutControlItem13.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-44676091 | this.spdDetail.ActiveSheetChanged | SSP0060_ShipmentPlan.cs:2215 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") | UI_PROP | layoutControlItem14.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-275fe238 | this.spdDetail.ActiveSheetChanged | SSP0060_ShipmentPlan.cs:2216 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") | UI_PROP | layoutControlItem17.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-47900741 | this.spdDetail.ActiveSheetChanged | SSP0060_ShipmentPlan.cs:2217 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") | UI_PROP | lcbtnNew.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-81d965cf | this.spdDetail.ActiveSheetChanged | SSP0060_ShipmentPlan.cs:2218 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") | UI_PROP | layoutControlItem3.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-6a2c822c | this.spdDetail.ActiveSheetChanged | SSP0060_ShipmentPlan.cs:2222 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") ▸ if (((FarPoint.Win.Spread.FpSpread)sender… | UI_PROP | layoutControlItem11.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-85ea039b | this.spdDetail.ActiveSheetChanged | SSP0060_ShipmentPlan.cs:2223 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") ▸ if (((FarPoint.Win.Spread.FpSpread)sender… | UI_PROP | layoutControlItem4.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-049d42f6 | this.spdDetail.ActiveSheetChanged | SSP0060_ShipmentPlan.cs:2224 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") ▸ if (((FarPoint.Win.Spread.FpSpread)sender… | UI_PROP | layoutControlItem5.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-6db3d261 | this.spdDetail.ActiveSheetChanged | SSP0060_ShipmentPlan.cs:2225 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") ▸ if (((FarPoint.Win.Spread.FpSpread)sender… | UI_PROP | lcProductLevel12.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-f2fe1bfd | this.spdDetail.ActiveSheetChanged | SSP0060_ShipmentPlan.cs:2226 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") ▸ if (((FarPoint.Win.Spread.FpSpread)sender… | UI_PROP | Requestor.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-ce92082c | this.spdDetail.ActiveSheetChanged | SSP0060_ShipmentPlan.cs:2227 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") ▸ if (((FarPoint.Win.Spread.FpSpread)sender… | UI_PROP | layoutControlItem9.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-bc12737f | this.spdDetail.ActiveSheetChanged | SSP0060_ShipmentPlan.cs:2228 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") ▸ if (((FarPoint.Win.Spread.FpSpread)sender… | UI_PROP | layoutControlItem13.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-7d8ab9b0 | this.spdDetail.ActiveSheetChanged | SSP0060_ShipmentPlan.cs:2229 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") ▸ if (((FarPoint.Win.Spread.FpSpread)sender… | UI_PROP | layoutControlItem14.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-e25498d4 | this.spdDetail.ActiveSheetChanged | SSP0060_ShipmentPlan.cs:2230 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") ▸ if (((FarPoint.Win.Spread.FpSpread)sender… | UI_PROP | layoutControlItem17.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-c5d62f9d | this.spdDetail.ActiveSheetChanged | SSP0060_ShipmentPlan.cs:2231 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") ▸ if (((FarPoint.Win.Spread.FpSpread)sender… | UI_PROP | lcbtnNew.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-80ca296e | this.spdDetail.ActiveSheetChanged | SSP0060_ShipmentPlan.cs:2232 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") ▸ if (((FarPoint.Win.Spread.FpSpread)sender… | UI_PROP | layoutControlItem3.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-860e332e | this.spdDetail.ActiveSheetChanged | SSP0060_ShipmentPlan.cs:2236 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") ▸ else of (((FarPoint.Win.Spread.FpSpread)s… | UI_PROP | layoutControlItem11.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-d3ca4487 | this.spdDetail.ActiveSheetChanged | SSP0060_ShipmentPlan.cs:2237 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") ▸ else of (((FarPoint.Win.Spread.FpSpread)s… | UI_PROP | layoutControlItem4.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-20232b98 | this.spdDetail.ActiveSheetChanged | SSP0060_ShipmentPlan.cs:2238 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") ▸ else of (((FarPoint.Win.Spread.FpSpread)s… | UI_PROP | layoutControlItem5.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-590dfbb4 | this.spdDetail.ActiveSheetChanged | SSP0060_ShipmentPlan.cs:2239 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") ▸ else of (((FarPoint.Win.Spread.FpSpread)s… | UI_PROP | lcProductLevel12.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-6013063c | this.spdDetail.ActiveSheetChanged | SSP0060_ShipmentPlan.cs:2240 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") ▸ else of (((FarPoint.Win.Spread.FpSpread)s… | UI_PROP | Requestor.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-0fb43c73 | this.spdDetail.ActiveSheetChanged | SSP0060_ShipmentPlan.cs:2241 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") ▸ else of (((FarPoint.Win.Spread.FpSpread)s… | UI_PROP | layoutControlItem9.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-ace7e23f | this.spdDetail.ActiveSheetChanged | SSP0060_ShipmentPlan.cs:2242 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") ▸ else of (((FarPoint.Win.Spread.FpSpread)s… | UI_PROP | layoutControlItem13.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-54cc0ee9 | this.spdDetail.ActiveSheetChanged | SSP0060_ShipmentPlan.cs:2243 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") ▸ else of (((FarPoint.Win.Spread.FpSpread)s… | UI_PROP | layoutControlItem14.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-d3812c56 | this.spdDetail.ActiveSheetChanged | SSP0060_ShipmentPlan.cs:2244 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") ▸ else of (((FarPoint.Win.Spread.FpSpread)s… | UI_PROP | layoutControlItem17.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-b97ece09 | this.spdDetail.ActiveSheetChanged | SSP0060_ShipmentPlan.cs:2245 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") ▸ else of (((FarPoint.Win.Spread.FpSpread)s… | UI_PROP | lcbtnNew.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-f13441a4 | this.spdDetail.ActiveSheetChanged | SSP0060_ShipmentPlan.cs:2246 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") ▸ else of (((FarPoint.Win.Spread.FpSpread)s… | UI_PROP | layoutControlItem3.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-72fd4744 | this.spdDetail.ActiveSheetChanged | SSP0060_ShipmentPlan.cs:2250 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") ▸ else of (((FarPoint.Win.Spread.FpSpread)s… | UI_PROP | layoutControlItem11.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-1d34218a | this.spdDetail.ActiveSheetChanged | SSP0060_ShipmentPlan.cs:2251 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") ▸ else of (((FarPoint.Win.Spread.FpSpread)s… | UI_PROP | layoutControlItem4.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-c87eb7be | this.spdDetail.ActiveSheetChanged | SSP0060_ShipmentPlan.cs:2252 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") ▸ else of (((FarPoint.Win.Spread.FpSpread)s… | UI_PROP | layoutControlItem5.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-a5ae4fd6 | this.spdDetail.ActiveSheetChanged | SSP0060_ShipmentPlan.cs:2253 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") ▸ else of (((FarPoint.Win.Spread.FpSpread)s… | UI_PROP | lcProductLevel12.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-515cfc2f | this.spdDetail.ActiveSheetChanged | SSP0060_ShipmentPlan.cs:2254 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") ▸ else of (((FarPoint.Win.Spread.FpSpread)s… | UI_PROP | Requestor.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-57026930 | this.spdDetail.ActiveSheetChanged | SSP0060_ShipmentPlan.cs:2255 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") ▸ else of (((FarPoint.Win.Spread.FpSpread)s… | UI_PROP | layoutControlItem9.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-38b097fa | this.spdDetail.ActiveSheetChanged | SSP0060_ShipmentPlan.cs:2256 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") ▸ else of (((FarPoint.Win.Spread.FpSpread)s… | UI_PROP | layoutControlItem13.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-0b3d2c6d | this.spdDetail.ActiveSheetChanged | SSP0060_ShipmentPlan.cs:2257 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") ▸ else of (((FarPoint.Win.Spread.FpSpread)s… | UI_PROP | layoutControlItem14.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-0eb83c2b | this.spdDetail.ActiveSheetChanged | SSP0060_ShipmentPlan.cs:2258 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") ▸ else of (((FarPoint.Win.Spread.FpSpread)s… | UI_PROP | layoutControlItem17.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-8534a891 | this.spdDetail.ActiveSheetChanged | SSP0060_ShipmentPlan.cs:2259 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") ▸ else of (((FarPoint.Win.Spread.FpSpread)s… | UI_PROP | lcbtnNew.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-e6c90068 | this.spdDetail.ActiveSheetChanged | SSP0060_ShipmentPlan.cs:2260 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") ▸ else of (((FarPoint.Win.Spread.FpSpread)s… | UI_PROP | layoutControlItem3.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-7cc709c4 | this.spdDetail.ActiveSheetChanged | SSP0060_ShipmentPlan.cs:2292 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") ▸ else of (((FarPoint.Win.Spread.FpSpread)s… | UI_PROP | layoutControlItem11.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-322e6e46 | this.spdDetail.ActiveSheetChanged | SSP0060_ShipmentPlan.cs:2293 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") ▸ else of (((FarPoint.Win.Spread.FpSpread)s… | UI_PROP | layoutControlItem4.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-0c1f352e | this.spdDetail.ActiveSheetChanged | SSP0060_ShipmentPlan.cs:2294 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") ▸ else of (((FarPoint.Win.Spread.FpSpread)s… | UI_PROP | layoutControlItem5.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-07184943 | this.spdDetail.ActiveSheetChanged | SSP0060_ShipmentPlan.cs:2295 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") ▸ else of (((FarPoint.Win.Spread.FpSpread)s… | UI_PROP | lcProductLevel12.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-4dc47240 | this.spdDetail.ActiveSheetChanged | SSP0060_ShipmentPlan.cs:2296 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") ▸ else of (((FarPoint.Win.Spread.FpSpread)s… | UI_PROP | Requestor.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-d2b9fd23 | this.spdDetail.ActiveSheetChanged | SSP0060_ShipmentPlan.cs:2297 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") ▸ else of (((FarPoint.Win.Spread.FpSpread)s… | UI_PROP | layoutControlItem9.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-fe513a11 | this.spdDetail.ActiveSheetChanged | SSP0060_ShipmentPlan.cs:2298 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") ▸ else of (((FarPoint.Win.Spread.FpSpread)s… | UI_PROP | layoutControlItem13.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-b9ecbae7 | this.spdDetail.ActiveSheetChanged | SSP0060_ShipmentPlan.cs:2299 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") ▸ else of (((FarPoint.Win.Spread.FpSpread)s… | UI_PROP | layoutControlItem14.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-2d56b3cf | this.spdDetail.ActiveSheetChanged | SSP0060_ShipmentPlan.cs:2300 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") ▸ else of (((FarPoint.Win.Spread.FpSpread)s… | UI_PROP | layoutControlItem17.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-7d086598 | this.spdDetail.ActiveSheetChanged | SSP0060_ShipmentPlan.cs:2301 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") ▸ else of (((FarPoint.Win.Spread.FpSpread)s… | UI_PROP | lcbtnNew.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-b9b05eb8 | this.spdDetail.ActiveSheetChanged | SSP0060_ShipmentPlan.cs:2302 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") ▸ else of (((FarPoint.Win.Spread.FpSpread)s… | UI_PROP | layoutControlItem3.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-923841b9 | this.spdDetail.ActiveSheetChanged | SSP0060_ShipmentPlan.cs:2306 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") ▸ else of (((FarPoint.Win.Spread.FpSpread)s… | UI_PROP | layoutControlItem11.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-1180900c | this.spdDetail.ActiveSheetChanged | SSP0060_ShipmentPlan.cs:2307 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") ▸ else of (((FarPoint.Win.Spread.FpSpread)s… | UI_PROP | layoutControlItem4.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-2b6f6e9a | this.spdDetail.ActiveSheetChanged | SSP0060_ShipmentPlan.cs:2308 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") ▸ else of (((FarPoint.Win.Spread.FpSpread)s… | UI_PROP | layoutControlItem5.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-e2204238 | this.spdDetail.ActiveSheetChanged | SSP0060_ShipmentPlan.cs:2309 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") ▸ else of (((FarPoint.Win.Spread.FpSpread)s… | UI_PROP | lcProductLevel12.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-070c522a | this.spdDetail.ActiveSheetChanged | SSP0060_ShipmentPlan.cs:2310 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") ▸ else of (((FarPoint.Win.Spread.FpSpread)s… | UI_PROP | Requestor.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-4067862a | this.spdDetail.ActiveSheetChanged | SSP0060_ShipmentPlan.cs:2311 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") ▸ else of (((FarPoint.Win.Spread.FpSpread)s… | UI_PROP | layoutControlItem9.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-76234c6a | this.spdDetail.ActiveSheetChanged | SSP0060_ShipmentPlan.cs:2312 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") ▸ else of (((FarPoint.Win.Spread.FpSpread)s… | UI_PROP | layoutControlItem13.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-3674e745 | this.spdDetail.ActiveSheetChanged | SSP0060_ShipmentPlan.cs:2313 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") ▸ else of (((FarPoint.Win.Spread.FpSpread)s… | UI_PROP | layoutControlItem14.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-289e1153 | this.spdDetail.ActiveSheetChanged | SSP0060_ShipmentPlan.cs:2314 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") ▸ else of (((FarPoint.Win.Spread.FpSpread)s… | UI_PROP | layoutControlItem17.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-9f3fc71d | this.spdDetail.ActiveSheetChanged | SSP0060_ShipmentPlan.cs:2315 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") ▸ else of (((FarPoint.Win.Spread.FpSpread)s… | UI_PROP | lcbtnNew.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-4fc20661 | this.spdDetail.ActiveSheetChanged | SSP0060_ShipmentPlan.cs:2316 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment Plan Detail") ▸ else of (((FarPoint.Win.Spread.FpSpread)s… | UI_PROP | layoutControlItem3.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |

## SSP0060_ShipmentPlan.SpdDetail_CellClick

진입점: this.spdDetail.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3e6135f4 | this.spdDetail.CellClick | SSP0060_ShipmentPlan.cs:1966 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (spdDetail.AutoClipboard == true) | CALL_EXT | im.Put | (new Keystroke(Keys.V, Keys.Control), SpreadActions.ClipboardPasteAsStringSkipHidden) | ⚠ 의미 확인 필요 |  |  |  |
| AC-94c2cbe0 | this.spdDetail.CellClick | SSP0060_ShipmentPlan.cs:1967 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (spdDetail.AutoClipboard == true) | CALL_EXT | im.Put | (new Keystroke(Keys.C, Keys.Control), SpreadActions.ClipboardCopyAsStringSkipHidden) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c4d7809e | this.spdDetail.CellClick | SSP0060_ShipmentPlan.cs:1968 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (spdDetail.AutoClipboard == true) | UI_PROP | spdDetail.AutoClipboard | false | 속성 AutoClipboard 설정 |  |  |  |
| AC-21bdf7d9 | this.spdDetail.CellClick | SSP0060_ShipmentPlan.cs:1987 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.TRANSPORT_MODE)) | FLAG | dtTransMode | Data.Common(Data.Type.TransMode, false, sDivision, sFromSite, sToSite, sIncoterms) ⇒ biz:CommonData.CommonDataList [code=TransMode] | 화면 필드/플래그 변경 |  |  |  |
| AC-dc54c6bd | this.spdDetail.CellClick | SSP0060_ShipmentPlan.cs:1987 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.TRANSPORT_MODE)) | COMBO_DATA | Data.Common | (Data.Type.TransMode, false, sDivision, sFromSite, sToSite, sIncoterms) ⇒ biz:CommonData.CommonDataList [code=TransMode] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-d0466d9b | this.spdDetail.CellClick | SSP0060_ShipmentPlan.cs:1992 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.TRANSPORT_MODE)) | GRID_SET | siDetail.SetValue | (e.Row, siDetail.GetColumnIndex(DefColumns.TRANSPORT_MODE), sTransMode) | 그리드 값 설정 |  |  |  |
| AC-38a9323b | this.spdDetail.CellClick | SSP0060_ShipmentPlan.cs:1995 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.TRANSPORT_MODE)) | GRID_COMBO | siDetail.SetCellTypeCombo | (e.Row, siDetail.GetColumnIndex(DefColumns.TRANSPORT_MODE), dtTransMode) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-7928dbee | this.spdDetail.CellClick | SSP0060_ShipmentPlan.cs:1996 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.TRANSPORT_MODE)) | GRID_SET | siDetail.ActiveSheet.Cells[e.Row, siDetail.GetColumnIndex(DefColumns.TRANSPORT_MODE)].Vert… | CellVerticalAlignment.Center | 그리드 속성/값 설정 |  |  |  |
| AC-6fb4b5ee | this.spdDetail.CellClick | SSP0060_ShipmentPlan.cs:1997 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.TRANSPORT_MODE)) | GRID_SET | siDetail.ActiveSheet.Cells[e.Row, siDetail.GetColumnIndex(DefColumns.TRANSPORT_MODE)].Hori… | CellHorizontalAlignment.Center | 그리드 속성/값 설정 |  |  |  |
| AC-cbc9cf2b | this.spdDetail.CellClick | SSP0060_ShipmentPlan.cs:2005 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.RowCount >= 1 && e.ColumnHeader) ▸ if (siDe… | GRID_SET | siDetail.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].Value | false | 그리드 속성/값 설정 |  |  |  |
| AC-52430488 | this.spdDetail.CellClick | SSP0060_ShipmentPlan.cs:2009 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.RowCount >= 1 && e.ColumnHeader) ▸ if (siDe… | GRID_SET | siDetail.ActiveSheet.SetValue | (iRow, e.Column, false) | 그리드 값 설정 |  |  |  |
| AC-2f79dbb4 | this.spdDetail.CellClick | SSP0060_ShipmentPlan.cs:2022 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.ActiveColumnIndex == siDetail.GetColumnInde… | UI_PROP | spdDetail.AutoClipboard | true | 속성 AutoClipboard 설정 |  |  |  |
| AC-ce39a3cf | this.spdDetail.CellClick | SSP0060_ShipmentPlan.cs:2023 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.ActiveColumnIndex == siDetail.GetColumnInde… | FLAG | im | spdDetail.GetInputMap(FarPoint.Win.Spread.InputMapMode.WhenAncestorOfFocused) | 화면 필드/플래그 변경 |  |  |  |
| AC-b11fe6fe | this.spdDetail.CellClick | SSP0060_ShipmentPlan.cs:2023 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.ActiveColumnIndex == siDetail.GetColumnInde… | CALL_EXT | spdDetail.GetInputMap | (FarPoint.Win.Spread.InputMapMode.WhenAncestorOfFocused) | ⚠ 의미 확인 필요 |  |  |  |
| AC-321ff68b | this.spdDetail.CellClick | SSP0060_ShipmentPlan.cs:2024 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.ActiveColumnIndex == siDetail.GetColumnInde… | CALL_EXT | im.Put | (new Keystroke(Keys.V, Keys.Control), SpreadActions.None) | ⚠ 의미 확인 필요 |  |  |  |
| AC-03ba7079 | this.spdDetail.CellClick | SSP0060_ShipmentPlan.cs:2025 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.ActiveColumnIndex == siDetail.GetColumnInde… | CALL_EXT | im.Put | (new Keystroke(Keys.C, Keys.Control), SpreadActions.None) | ⚠ 의미 확인 필요 |  |  |  |
| AC-35440b4b | this.spdDetail.CellClick | SSP0060_ShipmentPlan.cs:2040 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.RowCount >= 1 && e.ColumnHeader) ▸ if … | GRID_SET | siDetail.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].Value | false | 그리드 속성/값 설정 |  |  |  |
| AC-e7ff7fd6 | this.spdDetail.CellClick | SSP0060_ShipmentPlan.cs:2044 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.RowCount >= 1 && e.ColumnHeader) ▸ if … | GRID_SET | siDetail.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].Value | true | 그리드 속성/값 설정 |  |  |  |
| AC-439246d3 | this.spdDetail.CellClick | SSP0060_ShipmentPlan.cs:2051 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.RowCount >= 1 && e.ColumnHeader) ▸ if … | GRID_SET | siDetail.ActiveSheet.SetValue | (iRow, e.Column, true) | 그리드 값 설정 |  |  |  |
| AC-092fe374 | this.spdDetail.CellClick | SSP0060_ShipmentPlan.cs:2055 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.RowCount >= 1 && e.ColumnHeader) ▸ if … | GRID_SET | siDetail.ActiveSheet.SetValue | (iRow, e.Column, false) | 그리드 값 설정 |  |  |  |
| AC-1edd7ab0 | this.spdDetail.CellClick | SSP0060_ShipmentPlan.cs:2066 | if (e.Column == siDetail.GetColumnIndex(DefColumns.CHANGE_REQ_NO)) ▸ if (string.IsNullOrWhiteSpace(sRequestNo)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b1492bb1 | this.spdDetail.CellClick | SSP0060_ShipmentPlan.cs:2069 | if (e.Column == siDetail.GetColumnIndex(DefColumns.CHANGE_REQ_NO)) | POPUP | new SSP0060_ShipmentPlanConfirmDetailPopup | () | 팝업/폼 생성 |  |  |  |
| AC-8a956d83 | this.spdDetail.CellClick | SSP0060_ShipmentPlan.cs:2070 | if (e.Column == siDetail.GetColumnIndex(DefColumns.CHANGE_REQ_NO)) | UI_PROP | pop.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-27e280ca | this.spdDetail.CellClick | SSP0060_ShipmentPlan.cs:2071 | if (e.Column == siDetail.GetColumnIndex(DefColumns.CHANGE_REQ_NO)) | UI_PROP | pop._sRequestNo | sRequestNo | 속성 _sRequestNo 설정 |  |  |  |
| AC-16ee64dd | this.spdDetail.CellClick | SSP0060_ShipmentPlan.cs:2072 | if (e.Column == siDetail.GetColumnIndex(DefColumns.CHANGE_REQ_NO)) | POPUP | pop.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## SSP0060_ShipmentPlan.SpdDetail_CellDoubleClick

진입점: this.spdDetail.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-87371dbf | this.spdDetail.CellDoubleClick | SSP0060_ShipmentPlan.cs:1684 | if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.ITEM_ID)) ▸ if (action ==… | MESSAGE | MessageHelper.GMessageBox | ("MSG00098", new object[] { MessageHelper.GetTerm("Div") }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-df1edd0b | this.spdDetail.CellDoubleClick | SSP0060_ShipmentPlan.cs:1686 | if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.ITEM_ID)) ▸ if (action ==… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ec02ff88 | this.spdDetail.CellDoubleClick | SSP0060_ShipmentPlan.cs:1692 | if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.ITEM_ID)) ▸ if (action ==… | MESSAGE | MessageHelper.GMessageBox | ("MSG00098", new object[] { MessageHelper.GetTerm("From Site") }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-2ee30656 | this.spdDetail.CellDoubleClick | SSP0060_ShipmentPlan.cs:1694 | if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.ITEM_ID)) ▸ if (action ==… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-bf684a82 | this.spdDetail.CellDoubleClick | SSP0060_ShipmentPlan.cs:1700 | if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.ITEM_ID)) ▸ if (action ==… | MESSAGE | MessageHelper.GMessageBox | ("MSG00098", new object[] { MessageHelper.GetTerm("To Site") }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6e2289f8 | this.spdDetail.CellDoubleClick | SSP0060_ShipmentPlan.cs:1702 | if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.ITEM_ID)) ▸ if (action ==… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-92a65b81 | this.spdDetail.CellDoubleClick | SSP0060_ShipmentPlan.cs:1707 | if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.ITEM_ID)) ▸ if (action ==… | POPUP | new SCM0002_ItembyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-1a0612fe | this.spdDetail.CellDoubleClick | SSP0060_ShipmentPlan.cs:1712 | if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.ITEM_ID)) ▸ if (action ==… | POPUP | popItem.Form_Load | (false, sdivision, sScmSite, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-5d0ddd55 | this.spdDetail.CellDoubleClick | SSP0060_ShipmentPlan.cs:1713 | if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.ITEM_ID)) ▸ if (action ==… | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-743dbc59 | this.spdDetail.CellDoubleClick | SSP0060_ShipmentPlan.cs:1714 | if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.ITEM_ID)) ▸ if (action ==… | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-21096a19 | this.spdDetail.CellDoubleClick | SSP0060_ShipmentPlan.cs:1720 | if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.ITEM_ID)) ▸ if (action ==… | GRID_SET | siDetail.SetValue | (e.Row, siDetail.GetColumnIndex(DefColumns.ITEM_ID), sItemId) | 그리드 값 설정 |  |  |  |
| AC-7ad827e9 | this.spdDetail.CellDoubleClick | SSP0060_ShipmentPlan.cs:1721 | if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.ITEM_ID)) ▸ if (action ==… | GRID_SET | siDetail.SetValue | (e.Row, siDetail.GetColumnIndex(DefColumns.NICK_NAME), popItem.NickName) | 그리드 값 설정 |  |  |  |
| AC-aeebcb82 | this.spdDetail.CellDoubleClick | SSP0060_ShipmentPlan.cs:1744 | if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ else of (e.Column == siDetail.GetColumnIndex(DefColumns.ITEM_ID)) ▸ if (e.Co… | MESSAGE | MessageHelper.GMessageBox | ("MSG00098", new object[] { MessageHelper.GetTerm("Div") }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-479df44f | this.spdDetail.CellDoubleClick | SSP0060_ShipmentPlan.cs:1746 | if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ else of (e.Column == siDetail.GetColumnIndex(DefColumns.ITEM_ID)) ▸ if (e.Co… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e50ad21c | this.spdDetail.CellDoubleClick | SSP0060_ShipmentPlan.cs:1752 | if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ else of (e.Column == siDetail.GetColumnIndex(DefColumns.ITEM_ID)) ▸ if (e.Co… | MESSAGE | MessageHelper.GMessageBox | ("MSG00098", new object[] { MessageHelper.GetTerm("From Site") }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f832188c | this.spdDetail.CellDoubleClick | SSP0060_ShipmentPlan.cs:1754 | if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ else of (e.Column == siDetail.GetColumnIndex(DefColumns.ITEM_ID)) ▸ if (e.Co… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1694ca83 | this.spdDetail.CellDoubleClick | SSP0060_ShipmentPlan.cs:1760 | if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ else of (e.Column == siDetail.GetColumnIndex(DefColumns.ITEM_ID)) ▸ if (e.Co… | MESSAGE | MessageHelper.GMessageBox | ("MSG00098", new object[] { MessageHelper.GetTerm("To Site") }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-226acff5 | this.spdDetail.CellDoubleClick | SSP0060_ShipmentPlan.cs:1762 | if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ else of (e.Column == siDetail.GetColumnIndex(DefColumns.ITEM_ID)) ▸ if (e.Co… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2adb5eb0 | this.spdDetail.CellDoubleClick | SSP0060_ShipmentPlan.cs:1768 | if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ else of (e.Column == siDetail.GetColumnIndex(DefColumns.ITEM_ID)) ▸ if (e.Co… | MESSAGE | MessageHelper.GMessageBox | ("MSG00098", new object[] { MessageHelper.GetTerm("Model") }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0c85cca6 | this.spdDetail.CellDoubleClick | SSP0060_ShipmentPlan.cs:1770 | if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ else of (e.Column == siDetail.GetColumnIndex(DefColumns.ITEM_ID)) ▸ if (e.Co… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e61d1053 | this.spdDetail.CellDoubleClick | SSP0060_ShipmentPlan.cs:1780 | if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ else of (e.Column == siDetail.GetColumnIndex(DefColumns.ITEM_ID)) ▸ if (e.Co… | POPUP | new SCM0002_ProjectbyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-a2977694 | this.spdDetail.CellDoubleClick | SSP0060_ShipmentPlan.cs:1781 | if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ else of (e.Column == siDetail.GetColumnIndex(DefColumns.ITEM_ID)) ▸ if (e.Co… | POPUP | popProject.Form_Load | (false, sDivision, sProject) | 팝업 초기화(인자 전달) |  |  |  |
| AC-f2a00998 | this.spdDetail.CellDoubleClick | SSP0060_ShipmentPlan.cs:1782 | if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ else of (e.Column == siDetail.GetColumnIndex(DefColumns.ITEM_ID)) ▸ if (e.Co… | UI_PROP | popProject.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-c7aa4952 | this.spdDetail.CellDoubleClick | SSP0060_ShipmentPlan.cs:1783 | if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ else of (e.Column == siDetail.GetColumnIndex(DefColumns.ITEM_ID)) ▸ if (e.Co… | POPUP | popProject.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-6d464133 | this.spdDetail.CellDoubleClick | SSP0060_ShipmentPlan.cs:1790 | if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ else of (e.Column == siDetail.GetColumnIndex(DefColumns.ITEM_ID)) ▸ if (e.Co… | GRID_SET | siDetail.SetValue | (e.Row, siDetail.GetColumnIndex(DefColumns.PROJECT_CODE), sProjectCode) | 그리드 값 설정 |  |  |  |
| AC-e3c3f7f2 | this.spdDetail.CellDoubleClick | SSP0060_ShipmentPlan.cs:1791 | if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ else of (e.Column == siDetail.GetColumnIndex(DefColumns.ITEM_ID)) ▸ if (e.Co… | GRID_SET | siDetail.SetValue | (e.Row, siDetail.GetColumnIndex(DefColumns.PROJECT_NAME), sProjectName) | 그리드 값 설정 |  |  |  |
| AC-ff6759f7 | this.spdDetail.CellDoubleClick | SSP0060_ShipmentPlan.cs:1806 | if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ else of (e.Column == siDetail.GetColumnIndex(DefColumns.ITEM_ID)) ▸ else of … | POPUP | new SSP0300_OrderDetailPopup | () | 팝업/폼 생성 |  |  |  |
| AC-029eb241 | this.spdDetail.CellDoubleClick | SSP0060_ShipmentPlan.cs:1808 | if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ else of (e.Column == siDetail.GetColumnIndex(DefColumns.ITEM_ID)) ▸ else of … | POPUP | pop.Form_Load | (_DivisionID, _ErpSoNo, _ConfirmId, _ItemID, "N") | 팝업 초기화(인자 전달) |  |  |  |
| AC-389ddea9 | this.spdDetail.CellDoubleClick | SSP0060_ShipmentPlan.cs:1809 | if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ else of (e.Column == siDetail.GetColumnIndex(DefColumns.ITEM_ID)) ▸ else of … | UI_PROP | pop.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-9a30bc45 | this.spdDetail.CellDoubleClick | SSP0060_ShipmentPlan.cs:1810 | if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ else of (e.Column == siDetail.GetColumnIndex(DefColumns.ITEM_ID)) ▸ else of … | POPUP | pop.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## SSP0060_ShipmentPlan.SpdDetail_ClipboardPasted

진입점: this.spdDetail.ClipboardPasted

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-646fc1b8 | this.spdDetail.ClipboardPasted | SSP0060_ShipmentPlan.cs:1475 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ for (iRow < e.CellRange.… | GRID_SET | siDetail.SetValue | (iRow, siDetail.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-043c3df9 | this.spdDetail.ClipboardPasted | SSP0060_ShipmentPlan.cs:1499 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ for (iRow < e.CellRange.… | GRID_SET | siDetail.SetValue | (i, siDetail.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-1c45c10b | this.spdDetail.ClipboardPasted | SSP0060_ShipmentPlan.cs:1517 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ for (iRow < e.CellRange.… | GRID_SET | siDetail.SetValue | (iRow, siDetail.GetColumnIndex(CAppSetting.StringAction), "") | 그리드 값 설정 |  |  |  |
| AC-5e281c3f | this.spdDetail.ClipboardPasted | SSP0060_ShipmentPlan.cs:1518 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ for (iRow < e.CellRange.… | GRID_STYLE | siDetail.ActiveSheet.Cells[iRow, siDetail.GetColumnIndex(CAppSetting.StringAction)].ResetF… | () | 그리드 표시 설정 |  |  |  |
| AC-75586954 | this.spdDetail.ClipboardPasted | SSP0060_ShipmentPlan.cs:1519 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ for (iRow < e.CellRange.… | GRID_STYLE | siDetail.ActiveSheet.Cells[iRow, siDetail.GetColumnIndex(CAppSetting.StringAction)].ResetB… | () | 그리드 표시 설정 |  |  |  |
| AC-1cd4a9e6 | this.spdDetail.ClipboardPasted | SSP0060_ShipmentPlan.cs:1522 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ for (iRow < e.CellRange.… | GRID_SET | siDetail.ActiveSheet.Cells[iRow, siDetail.GetColumnIndex(DefColumns.SHIPMENT_DATE)].ForeCo… | ControlColor.DefaultForeColor | 그리드 속성/값 설정 |  |  |  |
| AC-dfc728d7 | this.spdDetail.ClipboardPasted | SSP0060_ShipmentPlan.cs:1530 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ for (iRow < e.CellRange.… | CALL_EXT | CommonUtils.GetValueDouble | (siDetail.GetValue(iRow, siDetail.GetColumnIndex(DefColumns.NEW_LT_DAY))) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a3ec3974 | this.spdDetail.ClipboardPasted | SSP0060_ShipmentPlan.cs:1538 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ for (iRow < e.CellRange.… | GRID_SET | siDetail.SetValue | (iRow, siDetail.GetColumnIndex(DefColumns.SHIPMENT_DATE), sDate) | 그리드 값 설정 |  |  |  |
| AC-5d518bfa | this.spdDetail.ClipboardPasted | SSP0060_ShipmentPlan.cs:1541 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ for (iRow < e.CellRange.… | GRID_SET | siDetail.SetValue | (iRow, siDetail.GetColumnIndex(DefColumns.NEW_SHIPMENT_DATE), sDate) | 그리드 값 설정 |  |  |  |
| AC-e32cc414 | this.spdDetail.ClipboardPasted | SSP0060_ShipmentPlan.cs:1542 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ for (iRow < e.CellRange.… | GRID_SET | siDetail.SetValue | (iRow, siDetail.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-3015aea6 | this.spdDetail.ClipboardPasted | SSP0060_ShipmentPlan.cs:1552 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ for (iRow < e.CellRange.… | GRID_SET | siDetail.SetValue | (i, siDetail.GetColumnIndex(DefColumns.SHIPMENT_DATE), sDate) | 그리드 값 설정 |  |  |  |
| AC-192684ba | this.spdDetail.ClipboardPasted | SSP0060_ShipmentPlan.cs:1557 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ for (iRow < e.CellRange.… | GRID_SET | siDetail.SetValue | (i, siDetail.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-551bbed8 | this.spdDetail.ClipboardPasted | SSP0060_ShipmentPlan.cs:1565 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ for (iRow < e.CellRange.… | GRID_SET | siDetail.SetValue | (iRow, siDetail.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-3e912976 | this.spdDetail.ClipboardPasted | SSP0060_ShipmentPlan.cs:1572 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ for (iRow < e.CellRange.… | GRID_SET | siDetail.SetValue | (iRow, siDetail.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-d1340f4a | this.spdDetail.ClipboardPasted | SSP0060_ShipmentPlan.cs:1580 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ for (iRow < e.CellRange.… | DATA_OP | dtChangeReasonCode.Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-20b75517 | this.spdDetail.ClipboardPasted | SSP0060_ShipmentPlan.cs:1584 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ for (iRow < e.CellRange.… | CALL_EXT | ((FarPoint.Win.Spread.FpSpread)sender).CancelCellEditing | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-63c8945f | this.spdDetail.ClipboardPasted | SSP0060_ShipmentPlan.cs:1588 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ for (iRow < e.CellRange.… | MESSAGE | MessageHelper.GMessageBox | ("MSG00047", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8d868c55 | this.spdDetail.ClipboardPasted | SSP0060_ShipmentPlan.cs:1589 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ for (iRow < e.CellRange.… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5495dcd4 | this.spdDetail.ClipboardPasted | SSP0060_ShipmentPlan.cs:1595 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ for (iRow < e.CellRange.… | GRID_SET | siDetail.ActiveSheet.Cells[iRow, siDetail.GetColumnIndex(DefColumns.CHANGE_REASON_CODE)].F… | ControlColor.MarkedForeColor | 그리드 속성/값 설정 |  |  |  |
| AC-a13c6932 | this.spdDetail.ClipboardPasted | SSP0060_ShipmentPlan.cs:1599 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ for (iRow < e.CellRange.… | GRID_SET | siDetail.SetValue | (iRow, siDetail.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-491364d8 | this.spdDetail.ClipboardPasted | SSP0060_ShipmentPlan.cs:1610 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ for (iRow < e.CellRange.… | GRID_SET | siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(DefColumns.CHANGE_REASON_CODE)].Fore… | ControlColor.MarkedForeColor | 그리드 속성/값 설정 |  |  |  |
| AC-9844063b | this.spdDetail.ClipboardPasted | SSP0060_ShipmentPlan.cs:1612 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ for (iRow < e.CellRange.… | GRID_SET | siDetail.SetValue | (i, siDetail.GetColumnIndex(DefColumns.CHANGE_REASON_CODE), sNewChangeReasonCode) | 그리드 값 설정 |  |  |  |
| AC-50bd95ee | this.spdDetail.ClipboardPasted | SSP0060_ShipmentPlan.cs:1613 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ for (iRow < e.CellRange.… | GRID_SET | siDetail.SetValue | (i, siDetail.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-2f1225a3 | this.spdDetail.ClipboardPasted | SSP0060_ShipmentPlan.cs:1627 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ for (iRow < e.CellRange.… | GRID_SET | siDetail.SetValue | (iRow, siDetail.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-cd838568 | this.spdDetail.ClipboardPasted | SSP0060_ShipmentPlan.cs:1638 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ for (iRow < e.CellRange.… | GRID_SET | siDetail.SetValue | (i, siDetail.GetColumnIndex(DefColumns.CHANGE_REASON_DETAIL), sNewChangeReasonDetail) | 그리드 값 설정 |  |  |  |
| AC-fcc1e94c | this.spdDetail.ClipboardPasted | SSP0060_ShipmentPlan.cs:1640 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ for (iRow < e.CellRange.… | GRID_SET | siDetail.SetValue | (i, siDetail.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |

## SSP0060_ShipmentPlan.SpdDetail_ComboSelChange

진입점: this.spdDetail.ComboSelChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-42a3c741 | this.spdDetail.ComboSelChange | SSP0060_ShipmentPlan.cs:1824 | if (e.Column == siDetail.GetColumnIndex(DefColumns.TRANSPORT_MODE)) ▸ if (string.IsNullOrWhiteSpace(siDetail.GetValue(e.Row, siDetail.GetCol… | MESSAGE | MessageHelper.GMessageBox | ("MSG00278") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-7b29c418 | this.spdDetail.ComboSelChange | SSP0060_ShipmentPlan.cs:1825 | if (e.Column == siDetail.GetColumnIndex(DefColumns.TRANSPORT_MODE)) ▸ if (string.IsNullOrWhiteSpace(siDetail.GetValue(e.Row, siDetail.GetCol… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-30a6bcbe | this.spdDetail.ComboSelChange | SSP0060_ShipmentPlan.cs:1869 | if (e.Column == siDetail.GetColumnIndex(DefColumns.TRANSPORT_MODE)) ▸ if (string.IsNullOrWhiteSpace(sSoNo)) | GRID_SET | siDetail.SetValue | (e.Row, siDetail.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-a6b93bcd | this.spdDetail.ComboSelChange | SSP0060_ShipmentPlan.cs:1894 | if (e.Column == siDetail.GetColumnIndex(DefColumns.TRANSPORT_MODE)) ▸ else of (string.IsNullOrWhiteSpace(sSoNo)) ▸ for (iRow < siDetail.Acti… | GRID_SET | siDetail.SetValue | (iRow, siDetail.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-19cf8194 | this.spdDetail.ComboSelChange | SSP0060_ShipmentPlan.cs:1917 | else of (e.Column == siDetail.GetColumnIndex(DefColumns.TRANSPORT_MODE)) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.CHANGE_REASON_… | GRID_SET | siDetail.SetValue | (e.Row, siDetail.GetColumnIndex(DefColumns.EDIT_MAIN), "N") | 그리드 값 설정 |  |  |  |
| AC-d8706909 | this.spdDetail.ComboSelChange | SSP0060_ShipmentPlan.cs:1918 | else of (e.Column == siDetail.GetColumnIndex(DefColumns.TRANSPORT_MODE)) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.CHANGE_REASON_… | GRID_SET | siDetail.SetValue | (e.Row, siDetail.GetColumnIndex(DefColumns.CHANGE_REASON_DETAIL), "") | 그리드 값 설정 |  |  |  |
| AC-02dbb98b | this.spdDetail.ComboSelChange | SSP0060_ShipmentPlan.cs:1923 | else of (e.Column == siDetail.GetColumnIndex(DefColumns.TRANSPORT_MODE)) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.CHANGE_REASON_… | GRID_SET | siDetail.SetValue | (e.Row, siDetail.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-8b10add8 | this.spdDetail.ComboSelChange | SSP0060_ShipmentPlan.cs:1937 | else of (e.Column == siDetail.GetColumnIndex(DefColumns.TRANSPORT_MODE)) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.CHANGE_REASON_… | GRID_SET | siDetail.SetValue | (iRow, siDetail.GetColumnIndex(DefColumns.CHANGE_REASON_CODE), sNewChangeReasonCode) | 그리드 값 설정 |  |  |  |
| AC-20d7a786 | this.spdDetail.ComboSelChange | SSP0060_ShipmentPlan.cs:1938 | else of (e.Column == siDetail.GetColumnIndex(DefColumns.TRANSPORT_MODE)) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.CHANGE_REASON_… | GRID_SET | siDetail.SetValue | (iRow, siDetail.GetColumnIndex(DefColumns.CHANGE_REASON_DETAIL), "") | 그리드 값 설정 |  |  |  |
| AC-329fcd4d | this.spdDetail.ComboSelChange | SSP0060_ShipmentPlan.cs:1939 | else of (e.Column == siDetail.GetColumnIndex(DefColumns.TRANSPORT_MODE)) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.CHANGE_REASON_… | GRID_SET | siDetail.SetValue | (iRow, siDetail.GetColumnIndex(DefColumns.EDIT_MAIN), "N") | 그리드 값 설정 |  |  |  |
| AC-a72a325e | this.spdDetail.ComboSelChange | SSP0060_ShipmentPlan.cs:1944 | else of (e.Column == siDetail.GetColumnIndex(DefColumns.TRANSPORT_MODE)) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.CHANGE_REASON_… | GRID_SET | siDetail.SetValue | (iRow, siDetail.GetColumnIndex(DefColumns.CHANGE_REASON_CODE), sNewChangeReasonCode) | 그리드 값 설정 |  |  |  |
| AC-599965c8 | this.spdDetail.ComboSelChange | SSP0060_ShipmentPlan.cs:1945 | else of (e.Column == siDetail.GetColumnIndex(DefColumns.TRANSPORT_MODE)) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.CHANGE_REASON_… | GRID_SET | siDetail.SetValue | (iRow, siDetail.GetColumnIndex(DefColumns.CHANGE_REASON_DETAIL), sNewChangeReasonDetail) | 그리드 값 설정 |  |  |  |
| AC-745f40ab | this.spdDetail.ComboSelChange | SSP0060_ShipmentPlan.cs:1946 | else of (e.Column == siDetail.GetColumnIndex(DefColumns.TRANSPORT_MODE)) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.CHANGE_REASON_… | GRID_SET | siDetail.SetValue | (iRow, siDetail.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |

## SSP0060_ShipmentPlan.SpdDetail_EditChange

진입점: this.spdDetail.EditChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-add3aa87 | this.spdDetail.EditChange | SSP0060_ShipmentPlan.cs:1294 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ if (e.Column == siDetail… | CALL_EXT | CommonUtils.GetValueDouble | (siDetail.GetValue(e.Row, siDetail.GetColumnIndex(DefColumns.NEW_LT_DAY))) | ⚠ 의미 확인 필요 |  |  |  |
| AC-05a0cc70 | this.spdDetail.EditChange | SSP0060_ShipmentPlan.cs:1306 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ if (e.Column == siDetail… | GRID_SET | siDetail.SetValue | (e.Row, siDetail.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-179791e2 | this.spdDetail.EditChange | SSP0060_ShipmentPlan.cs:1316 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ if (e.Column == siDetail… | GRID_SET | siDetail.SetValue | (i, siDetail.GetColumnIndex(DefColumns.SHIPMENT_DATE), sDate) | 그리드 값 설정 |  |  |  |
| AC-09e817f3 | this.spdDetail.EditChange | SSP0060_ShipmentPlan.cs:1322 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ if (e.Column == siDetail… | GRID_SET | siDetail.SetValue | (i, siDetail.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-af3c4047 | this.spdDetail.EditChange | SSP0060_ShipmentPlan.cs:1338 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ else of (e.Column == siD… | GRID_STYLE | siDetail.ActiveSheet.SetActiveCell | (e.Row, siDetail.GetColumnIndex(DefColumns.ERP_SO_NO)) | 그리드 표시 설정 |  |  |  |
| AC-02777346 | this.spdDetail.EditChange | SSP0060_ShipmentPlan.cs:1339 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ else of (e.Column == siD… | CALL_EXT | siDetail.ActiveSheet.Cells[e.Row, siDetail.GetColumnIndex(DefColumns.CHANGE_REASON_DETAIL)… | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-9ced7684 | this.spdDetail.EditChange | SSP0060_ShipmentPlan.cs:1341 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ else of (e.Column == siD… | MESSAGE | MessageHelper.GMessageBox | ("MSG00287", new object[] { null }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f429af5e | this.spdDetail.EditChange | SSP0060_ShipmentPlan.cs:1343 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ else of (e.Column == siD… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b2e66b46 | this.spdDetail.EditChange | SSP0060_ShipmentPlan.cs:1351 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ else of (e.Column == siD… | GRID_SET | siDetail.SetValue | (e.Row, siDetail.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-1597eeb0 | this.spdDetail.EditChange | SSP0060_ShipmentPlan.cs:1361 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ else of (e.Column == siD… | GRID_SET | siDetail.SetValue | (i, siDetail.GetColumnIndex(DefColumns.CHANGE_REASON_DETAIL), sNewChangeReasonDetail) | 그리드 값 설정 |  |  |  |
| AC-6c397916 | this.spdDetail.EditChange | SSP0060_ShipmentPlan.cs:1363 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ else of (e.Column == siD… | GRID_SET | siDetail.SetValue | (i, siDetail.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-36da823d | this.spdDetail.EditChange | SSP0060_ShipmentPlan.cs:1376 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ else of (e.Column == siD… | GRID_SET | siDetail.SetValue | (e.Row, siDetail.GetColumnIndex(DefColumns.INCOTERMS), string.Empty) | 그리드 값 설정 |  |  |  |
| AC-c6efd410 | this.spdDetail.EditChange | SSP0060_ShipmentPlan.cs:1377 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ else of (e.Column == siD… | GRID_SET | siDetail.SetValue | (e.Row, siDetail.GetColumnIndex(DefColumns.TRANSPORT_MODE), string.Empty) | 그리드 값 설정 |  |  |  |
| AC-31d0825f | this.spdDetail.EditChange | SSP0060_ShipmentPlan.cs:1379 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ else of (e.Column == siD… | FLAG | dtIncoterms | Data_SCP.Common(Data_SCP.Type.Incoterms, false, sDivision, sFromSite, sToSite) | 화면 필드/플래그 변경 |  |  |  |
| AC-70e6f01f | this.spdDetail.EditChange | SSP0060_ShipmentPlan.cs:1379 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ else of (e.Column == siD… | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.Incoterms, false, sDivision, sFromSite, sToSite) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-6a69f9c6 | this.spdDetail.EditChange | SSP0060_ShipmentPlan.cs:1380 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ else of (e.Column == siD… | FLAG | dtTransMode | Data.Common(Data.Type.TransMode, false, sDivision, sFromSite, sToSite, string.Empty) ⇒ biz:CommonData.CommonDataList [code=TransMode] | 화면 필드/플래그 변경 |  |  |  |
| AC-890a3f62 | this.spdDetail.EditChange | SSP0060_ShipmentPlan.cs:1380 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ else of (e.Column == siD… | COMBO_DATA | Data.Common | (Data.Type.TransMode, false, sDivision, sFromSite, sToSite, string.Empty) ⇒ biz:CommonData.CommonDataList [code=TransMode] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-3ef08676 | this.spdDetail.EditChange | SSP0060_ShipmentPlan.cs:1389 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ else of (e.Column == siD… | FLAG | dtTransMode | Data.Common(Data.Type.TransMode, false, sDivision, sFromSite, sToSite, sIncoterms) ⇒ biz:CommonData.CommonDataList [code=TransMode] | 화면 필드/플래그 변경 |  |  |  |
| AC-08e73f3e | this.spdDetail.EditChange | SSP0060_ShipmentPlan.cs:1389 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtPlanDetail) ▸ else of (e.Column == siD… | COMBO_DATA | Data.Common | (Data.Type.TransMode, false, sDivision, sFromSite, sToSite, sIncoterms) ⇒ biz:CommonData.CommonDataList [code=TransMode] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |

## SSP0060_ShipmentPlan.SpdDetail_SheetTabClick

진입점: this.spdDetail.SheetTabClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ff0e1555 | this.spdDetail.SheetTabClick | SSP0060_ShipmentPlan.cs:2421 | if (e.SheetTabIndex == 0) | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtPlanDetail) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-97d95089 | this.spdDetail.SheetTabClick | SSP0060_ShipmentPlan.cs:2422 | if (e.SheetTabIndex == 0) | GRID_INIT | siDetail.ChangeActiveSheet | (SpdSheet.shtPlanDetail) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-de15c058 | this.spdDetail.SheetTabClick | SSP0060_ShipmentPlan.cs:2426 | else of (e.SheetTabIndex == 0) ▸ if (e.SheetTabIndex == 1) | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtStockDetail) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a7ec7904 | this.spdDetail.SheetTabClick | SSP0060_ShipmentPlan.cs:2427 | else of (e.SheetTabIndex == 0) ▸ if (e.SheetTabIndex == 1) | GRID_INIT | siDetail.ChangeActiveSheet | (SpdSheet.shtStockDetail) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-6d4637f7 | this.spdDetail.SheetTabClick | SSP0060_ShipmentPlan.cs:2431 | else of (e.SheetTabIndex == 0) ▸ else of (e.SheetTabIndex == 1) ▸ if (e.SheetTabIndex == 2) | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtoWMSDetail) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-13b0b5c9 | this.spdDetail.SheetTabClick | SSP0060_ShipmentPlan.cs:2432 | else of (e.SheetTabIndex == 0) ▸ else of (e.SheetTabIndex == 1) ▸ if (e.SheetTabIndex == 2) | GRID_INIT | siDetail.ChangeActiveSheet | (SpdSheet.shtoWMSDetail) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-f6c51db4 | this.spdDetail.SheetTabClick | SSP0060_ShipmentPlan.cs:2436 | else of (e.SheetTabIndex == 0) ▸ else of (e.SheetTabIndex == 1) ▸ else of (e.SheetTabIndex == 2) ▸ if (e.SheetTabIndex == 5) | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtShipmentResult) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-68bd0d6d | this.spdDetail.SheetTabClick | SSP0060_ShipmentPlan.cs:2437 | else of (e.SheetTabIndex == 0) ▸ else of (e.SheetTabIndex == 1) ▸ else of (e.SheetTabIndex == 2) ▸ if (e.SheetTabIndex == 5) | GRID_INIT | siDetail.ChangeActiveSheet | (SpdSheet.shtShipmentResult) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-629cc9f7 | this.spdDetail.SheetTabClick | SSP0060_ShipmentPlan.cs:2439 | else of (e.SheetTabIndex == 0) ▸ else of (e.SheetTabIndex == 1) ▸ else of (e.SheetTabIndex == 2) ▸ if (e.SheetTabIndex == 5) | CALL_EXT | clbResultType.SetItemChecked | (0, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-31bac74c | this.spdDetail.SheetTabClick | SSP0060_ShipmentPlan.cs:2440 | else of (e.SheetTabIndex == 0) ▸ else of (e.SheetTabIndex == 1) ▸ else of (e.SheetTabIndex == 2) ▸ if (e.SheetTabIndex == 5) | CALL_EXT | clbResultType.SetItemChecked | (1, true) | ⚠ 의미 확인 필요 |  |  |  |

## SSP0060_ShipmentPlan.SpdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-69f0ebbf | this.spdMain.CellDoubleClick | SSP0060_ShipmentPlan.cs:2329 | if (e.Column >= siMain.GetColumnIndex(DefColumns.FCST_TYPE) + 1 && (siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.M…) | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtPlanDetail) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4fc75ef9 | this.spdMain.CellDoubleClick | SSP0060_ShipmentPlan.cs:2330 | if (e.Column >= siMain.GetColumnIndex(DefColumns.FCST_TYPE) + 1 && (siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.M…) | GRID_INIT | siDetail.ChangeActiveSheet | (SpdSheet.shtPlanDetail) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-3e5e8445 | this.spdMain.CellDoubleClick | SSP0060_ShipmentPlan.cs:2333 | if (e.Column >= siMain.GetColumnIndex(DefColumns.FCST_TYPE) + 1 && (siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.M…) | FLAG | bDetail_Search | false | 화면 필드/플래그 변경 |  |  |  |
| AC-bad5cf22 | this.spdMain.CellDoubleClick | SSP0060_ShipmentPlan.cs:2337 | else of (e.Column >= siMain.GetColumnIndex(DefColumns.FCST_TYPE) + 1 && (siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.M…) ▸ if (e.… | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtStockDetail) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3b69eaa3 | this.spdMain.CellDoubleClick | SSP0060_ShipmentPlan.cs:2338 | else of (e.Column >= siMain.GetColumnIndex(DefColumns.FCST_TYPE) + 1 && (siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.M…) ▸ if (e.… | GRID_INIT | siDetail.ChangeActiveSheet | (SpdSheet.shtStockDetail) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-4bfe14ba | this.spdMain.CellDoubleClick | SSP0060_ShipmentPlan.cs:2344 | else of (e.Column >= siMain.GetColumnIndex(DefColumns.FCST_TYPE) + 1 && (siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.M…) ▸ else o… | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtoWMSDetail) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3bdfe82a | this.spdMain.CellDoubleClick | SSP0060_ShipmentPlan.cs:2345 | else of (e.Column >= siMain.GetColumnIndex(DefColumns.FCST_TYPE) + 1 && (siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.M…) ▸ else o… | GRID_INIT | siDetail.ChangeActiveSheet | (SpdSheet.shtoWMSDetail) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-3d10191e | this.spdMain.CellDoubleClick | SSP0060_ShipmentPlan.cs:2351 | else of (e.Column >= siMain.GetColumnIndex(DefColumns.FCST_TYPE) + 1 && (siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.M…) ▸ else o… | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtHoldStock) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0603d683 | this.spdMain.CellDoubleClick | SSP0060_ShipmentPlan.cs:2352 | else of (e.Column >= siMain.GetColumnIndex(DefColumns.FCST_TYPE) + 1 && (siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.M…) ▸ else o… | GRID_INIT | siDetail.ChangeActiveSheet | (SpdSheet.shtHoldStock) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-14380642 | this.spdMain.CellDoubleClick | SSP0060_ShipmentPlan.cs:2358 | else of (e.Column >= siMain.GetColumnIndex(DefColumns.FCST_TYPE) + 1 && (siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.M…) ▸ else o… | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtMESStockDetail) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7ca61385 | this.spdMain.CellDoubleClick | SSP0060_ShipmentPlan.cs:2359 | else of (e.Column >= siMain.GetColumnIndex(DefColumns.FCST_TYPE) + 1 && (siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.M…) ▸ else o… | GRID_INIT | siDetail.ChangeActiveSheet | (SpdSheet.shtMESStockDetail) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-66ea1b73 | this.spdMain.CellDoubleClick | SSP0060_ShipmentPlan.cs:2363 | else of (e.Column >= siMain.GetColumnIndex(DefColumns.FCST_TYPE) + 1 && (siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.M…) ▸ else o… | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtMESStock) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0581e87c | this.spdMain.CellDoubleClick | SSP0060_ShipmentPlan.cs:2364 | else of (e.Column >= siMain.GetColumnIndex(DefColumns.FCST_TYPE) + 1 && (siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.M…) ▸ else o… | GRID_INIT | siDetail.ChangeActiveSheet | (SpdSheet.shtMESStock) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-f6c6040e | this.spdMain.CellDoubleClick | SSP0060_ShipmentPlan.cs:2373 | else of (e.Column >= siMain.GetColumnIndex(DefColumns.FCST_TYPE) + 1 && (siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.M…) ▸ else o… | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtShipmentResult) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a09fd9fc | this.spdMain.CellDoubleClick | SSP0060_ShipmentPlan.cs:2374 | else of (e.Column >= siMain.GetColumnIndex(DefColumns.FCST_TYPE) + 1 && (siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.M…) ▸ else o… | GRID_INIT | siDetail.ChangeActiveSheet | (SpdSheet.shtShipmentResult) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-7c991f46 | this.spdMain.CellDoubleClick | SSP0060_ShipmentPlan.cs:2377 | else of (e.Column >= siMain.GetColumnIndex(DefColumns.FCST_TYPE) + 1 && (siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.M…) ▸ else o… | FLAG | bDetail_Search | false | 화면 필드/플래그 변경 |  |  |  |
| AC-34d83a84 | this.spdMain.CellDoubleClick | SSP0060_ShipmentPlan.cs:2380 | if (bEdit_Mode == true) | FLAG | bEdit_Mode | false | 화면 필드/플래그 변경 |  |  |  |

## SSP0060_ShipmentPlan.SpdMain_ClipboardPasted

진입점: this.spdMain.ClipboardPasted

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b6d02d88 | this.spdMain.ClipboardPasted | SSP0060_ShipmentPlan.cs:1007 | try ▸ for (iRow < e.CellRange.Row + e.CellRange.RowCount) ▸ if (measure.Equals("SHIP_PLAN_DETAIL") && toSite != string.Empty) | FLAG | cellclipboardPast | true | 화면 필드/플래그 변경 |  |  |  |
| AC-780bebc7 | this.spdMain.ClipboardPasted | SSP0060_ShipmentPlan.cs:1015 | try ▸ for (iRow < e.CellRange.Row + e.CellRange.RowCount) ▸ if (measure.Equals("SHIP_PLAN_DETAIL") && toSite != string.Empty) | FLAG | cellclipboardPast | false | 화면 필드/플래그 변경 |  |  |  |
| AC-7759c743 | this.spdMain.ClipboardPasted | SSP0060_ShipmentPlan.cs:1021 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-02300643 | this.spdMain.ClipboardPasted | SSP0060_ShipmentPlan.cs:1022 | catch ((Exception ex)) | FLAG | cellclipboardPast | false | 화면 필드/플래그 변경 |  |  |  |
| AC-ea2e29e7 | this.spdMain.ClipboardPasted | SSP0060_ShipmentPlan.cs:1026 | finally | FLAG | cellclipboardPast | false | 화면 필드/플래그 변경 |  |  |  |
| AC-cf000861 | this.spdMain.ClipboardPasted | SSP0060_ShipmentPlan.cs:1028 |  | FLAG | cellclipboardPast | false | 화면 필드/플래그 변경 |  |  |  |

## SSP0060_ShipmentPlan.spdMain_KeyUp

진입점: this.spdMain.KeyUp

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-67d5988e | this.spdMain.KeyUp | SSP0060_ShipmentPlan.cs:2483 | if (e.KeyCode == Keys.Delete) ▸ if (ranges != null) ▸ for (x < 1) ▸ try | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-6b82c4eb | this.spdMain.KeyUp | SSP0060_ShipmentPlan.cs:2496 | if (e.KeyCode == Keys.Delete) ▸ if (ranges != null) ▸ for (x < 1) ▸ try ▸ if (rowstart >= 0 && rowend >= 0 && colstart >= 0 && colend >= 0) … | GRID_SET | siMain.ActiveSheet.SetValue | (i, j, "0") | 그리드 값 설정 |  |  |  |
| AC-dd54c689 | this.spdMain.KeyUp | SSP0060_ShipmentPlan.cs:2509 | if (e.KeyCode == Keys.Delete) ▸ if (ranges != null) ▸ for (x < 1) ▸ finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-31dfb235 | this.spdMain.KeyUp | SSP0060_ShipmentPlan.cs:2513 | if (e.KeyCode == Keys.Delete) ▸ if (ranges != null) ▸ for (x < 1) ▸ finally ▸ if (error != null) | MESSAGE | MessageBox.Show | (error) | 메시지 표시 |  |  |  |
| AC-d2b4cfea | this.spdMain.KeyUp | SSP0060_ShipmentPlan.cs:2518 | if (e.KeyCode == Keys.Delete) ▸ if (ranges != null) | DATA_OP | dsMain.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |

## SSP0060_ShipmentPlan.SpdMain_TopChange

진입점: this.spdMain.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a84313fb | this.spdMain.TopChange | SSP0060_ShipmentPlan.cs:2453 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SSP0060_ShipmentPlan.Validation_Check

진입점: SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtPlanDetail) ▸ else of (chkERPIFBlockYn()) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-069b8360 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:3595 |  | FLAG | bolChang_Flag | false | 화면 필드/플래그 변경 |  |  |  |
| AC-282fe6a3 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:3621 | for (i < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].Text == "M" \… | MESSAGE | MessageHelper.GMessageBox | ("MSG00194", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-cfd2f44a | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:3622 | for (i < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].Text == "M" \… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-1d663c29 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:3644 | for (i < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].Text == "M" \… | DATA_OP | DefaultMainDS.Tables[0].Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-78e76a83 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:3644 | for (i < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].Text == "M" \… | DATA_OP | row.Field | ("confirm_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-f3456797 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:3658 | for (i < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].Text == "M" \… | FLAG | bolChang_Flag | true | 화면 필드/플래그 변경 |  |  |  |
| AC-e2109b96 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:3670 | for (i < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].Text == "M" \… | MESSAGE | MessageHelper.GMessageBox | ("MSG00285", new object[] { (i + 1).ToString() }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f1f4088c | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:3672 | for (i < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].Text == "M" \… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-0f6942af | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:3691 | for (i < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].Text == "M" \… | DATA_OP | DefaultMainDS.Tables[0].Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-a937d600 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:3691 | for (i < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].Text == "M" \… | DATA_OP | row.Field | ("confirm_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-f98c7068 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:3745 | for (i < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].Text == "M" \… | GRID_STYLE | siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].ResetBack… | () | 그리드 표시 설정 |  |  |  |
| AC-5b418c39 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:3746 | for (i < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].Text == "M" \… | GRID_STYLE | siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].ResetFore… | () | 그리드 표시 설정 |  |  |  |
| AC-b45b9e13 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:3747 | for (i < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].Text == "M" \… | GRID_SET | siDetail.SetValue | (i, siDetail.GetColumnIndex(CAppSetting.StringAction), "") | 그리드 값 설정 |  |  |  |
| AC-a1fe1a22 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:3749 | for (i < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].Text == "M" \… | GRID_STYLE | siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(DefColumns.SHIPMENT_CONFIRM_QTY)].Re… | () | 그리드 표시 설정 |  |  |  |
| AC-991afd0c | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:3750 | for (i < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].Text == "M" \… | GRID_STYLE | siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(DefColumns.SHIPMENT_DATE)].ResetFore… | () | 그리드 표시 설정 |  |  |  |
| AC-89513527 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:3751 | for (i < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].Text == "M" \… | GRID_STYLE | siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(DefColumns.TRANSPORT_MODE)].ResetFor… | () | 그리드 표시 설정 |  |  |  |
| AC-0eed7db2 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:3752 | for (i < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].Text == "M" \… | GRID_STYLE | siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(DefColumns.REMARKS2)].ResetForeColor | () | 그리드 표시 설정 |  |  |  |
| AC-edd771de | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:3753 | for (i < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].Text == "M" \… | GRID_STYLE | siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(DefColumns.REMARKS)].ResetForeColor | () | 그리드 표시 설정 |  |  |  |
| AC-49e092c6 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:3761 | for (i < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].Text == "M" \… | FLAG | bolChang_Flag | false | 화면 필드/플래그 변경 |  |  |  |
| AC-eb439812 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:3765 | for (i < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].Text == "M" \… | FLAG | bolChang_Flag | true | 화면 필드/플래그 변경 |  |  |  |
| AC-93bb297a | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:3781 | for (i < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].Text == "M" \… | DATA_OP | DefaultMainDS.Tables[0].Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-852b1a7a | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:3781 | for (i < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].Text == "M" \… | DATA_OP | row.Field | ("confirm_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-5b4c854c | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:3811 | for (i < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].Text == "M" \… | GRID_STYLE | siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].ResetBack… | () | 그리드 표시 설정 |  |  |  |
| AC-578e6b47 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:3812 | for (i < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].Text == "M" \… | GRID_STYLE | siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].ResetFore… | () | 그리드 표시 설정 |  |  |  |
| AC-64650fb3 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:3813 | for (i < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].Text == "M" \… | GRID_SET | siDetail.SetValue | (i, siDetail.GetColumnIndex(CAppSetting.StringAction), "") | 그리드 값 설정 |  |  |  |
| AC-9b5fd9f7 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:3815 | for (i < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].Text == "M" \… | GRID_STYLE | siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(DefColumns.SHIPMENT_CONFIRM_QTY)].Re… | () | 그리드 표시 설정 |  |  |  |
| AC-a5c6148d | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:3816 | for (i < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].Text == "M" \… | GRID_STYLE | siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(DefColumns.SHIPMENT_DATE)].ResetFore… | () | 그리드 표시 설정 |  |  |  |
| AC-b1c30724 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:3817 | for (i < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].Text == "M" \… | GRID_STYLE | siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(DefColumns.TRANSPORT_MODE)].ResetFor… | () | 그리드 표시 설정 |  |  |  |
| AC-2bfc4a96 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:3818 | for (i < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].Text == "M" \… | GRID_STYLE | siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(DefColumns.REMARKS2)].ResetForeColor | () | 그리드 표시 설정 |  |  |  |
| AC-6db9ff54 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:3819 | for (i < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].Text == "M" \… | GRID_STYLE | siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(DefColumns.REMARKS)].ResetForeColor | () | 그리드 표시 설정 |  |  |  |
| AC-eec169ec | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:3821 | for (i < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].Text == "M" \… | MESSAGE | MessageHelper.GMessageBox | ("MSG00286", new object[] { (i + 1).ToString() }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-deae3562 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:3823 | for (i < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].Text == "M" \… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-9e04ea4c | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:3829 | for (i < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].Text == "M" \… | FLAG | bolChang_Flag | true | 화면 필드/플래그 변경 |  |  |  |
| AC-0783300a | SaveButton [else of (fps.Name == "spdMain") ▸ if (siDetail !… | SSP0060_ShipmentPlan.cs:3837 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## SSP0060_ShipmentPlanConfirmDetailPopup.btnButtonList_UsrButtonList_Click_Detected

진입점: this.btnButtonList.UsrButtonList_Click_Detected

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-99436f4d | this.btnButtonList.UsrButtonList_Click_Detected | SSP0060_ShipmentPlanConfirmDetailPopup.cs:265 | switch (buttonItem.UserType) case ButtonListType.Close: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## SSP0060_ShipmentPlanConfirmDetailPopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9413b386 | this.Load | SSP0060_ShipmentPlanConfirmDetailPopup.cs:160 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 2, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-7f51ea0c | this.Load | SSP0060_ShipmentPlanConfirmDetailPopup.cs:161 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-d452daaa | this.Load | SSP0060_ShipmentPlanConfirmDetailPopup.cs:163 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SSP0060_ShipmentPlanConfirmDetailPopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b9ec995b | this.Load | SSP0060_ShipmentPlanConfirmDetailPopup.cs:155 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## SSP0060_ShipmentPlanConfirmDetailPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8b9d840a | Dispose | SSP0060_ShipmentPlanConfirmDetailPopup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SSP0060_ShipmentPlanConfirmDetailPopup.FindDataMain

진입점: this.Load / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bfba16c8 | this.Load 외 1 | SSP0060_ShipmentPlanConfirmDetailPopup.cs:308 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SSP.Plan.WSL/FoxDataService.s… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-15591b2d | this.Load 외 1 | SSP0060_ShipmentPlanConfirmDetailPopup.cs:312 | lambda | ENDPOINT | new FoxDataRequest | ("SSP.SSP0060_GET_SHIPMENT_REQUEST_CONFIRM_DRAFTING") ⇒ SSP.SSP0060_GET_SHIPMENT_REQUEST_CONFIRM_DRAFTING | 엔드포인트 요청 생성 |  |  |  |
| AC-21eeb414 | this.Load 외 1 | SSP0060_ShipmentPlanConfirmDetailPopup.cs:313 | lambda | DATA_OP | request.Parameters["p_change_request_no"] | _sRequestNo | 행/컬럼 값 대입 |  |  |  |
| AC-706bcae7 | this.Load 외 1 | SSP0060_ShipmentPlanConfirmDetailPopup.cs:314 | lambda | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-e3e9b815 | this.Load 외 1 | SSP0060_ShipmentPlanConfirmDetailPopup.cs:315 | lambda | DATA_OP | request.Parameters["p_language"] | sLanguage | 행/컬럼 값 대입 |  |  |  |
| AC-e046fd9e | this.Load 외 1 | SSP0060_ShipmentPlanConfirmDetailPopup.cs:317 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-0bf7d751 | this.Load 외 1 | SSP0060_ShipmentPlanConfirmDetailPopup.cs:319 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-3856e7df | this.Load 외 1 | SSP0060_ShipmentPlanConfirmDetailPopup.cs:326 |  | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-cb199471 | this.Load 외 1 | SSP0060_ShipmentPlanConfirmDetailPopup.cs:327 |  | GRID_LOCK | siMain.LockColumn | (1, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-86dcfec1 | this.Load 외 1 | SSP0060_ShipmentPlanConfirmDetailPopup.cs:329 |  | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SSP0060_ShipmentPlanConfirmDetailPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fbae3524 | this.Load | SSP0060_ShipmentPlanConfirmDetailPopup.cs:128 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-5b54232c | this.Load | SSP0060_ShipmentPlanConfirmDetailPopup.cs:129 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SSP0060_ShipmentPlanConfirmDetailPopup.InitSpread

진입점: this.Load / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8c52b9df | this.Load 외 1 | SSP0060_ShipmentPlanConfirmDetailPopup.cs:172 | if (spreadInfo.SheetName == SpdSheet.shtMain) | DATA_OP | Filter["GROUP_ID"] | UserInfoContext.Current["NowGroupID"] | 행/컬럼 값 대입 |  |  |  |
| AC-9935c46d | this.Load 외 1 | SSP0060_ShipmentPlanConfirmDetailPopup.cs:173 | if (spreadInfo.SheetName == SpdSheet.shtMain) | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-72b04190 | this.Load 외 1 | SSP0060_ShipmentPlanConfirmDetailPopup.cs:174 | if (spreadInfo.SheetName == SpdSheet.shtMain) | COMBO_DATA | DataService.GetSSPInnerTable | ("CHANGE_REASON_CODE_ALL", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-11a14abe | this.Load 외 1 | SSP0060_ShipmentPlanConfirmDetailPopup.cs:176 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.InitSheet | (spreadInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-f2b9e2b5 | this.Load 외 1 | SSP0060_ShipmentPlanConfirmDetailPopup.cs:178 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("A", CAppSetting.StringAction, FPMerge.Restricted, 10, false, FPHAlign.Center, FPVAlign.C… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-deaac0e9 | this.Load 외 1 | SSP0060_ShipmentPlanConfirmDetailPopup.cs:179 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("change_req_no", DefColumns.CHANGE_REQ_NO, FPMerge.Restricted, 100, false, FPHAlign.Cente… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8c98e3ff | this.Load 외 1 | SSP0060_ShipmentPlanConfirmDetailPopup.cs:180 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Division ID", DefColumns.DIVISION_ID, FPMerge.Restricted, 100, false, FPHAlign.Center, F… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2715f770 | this.Load 외 1 | SSP0060_ShipmentPlanConfirmDetailPopup.cs:181 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Confirm/Plan ID", DefColumns.CONFIRM_ID, FPMerge.Restricted, 100, true, FPHAlign.Left, F… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b21c035d | this.Load 외 1 | SSP0060_ShipmentPlanConfirmDetailPopup.cs:182 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("SO No", DefColumns.ERP_SO_NO, FPMerge.Restricted, 100, true, FPHAlign.Center, FPVAlign.C… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-82f1f0fc | this.Load 외 1 | SSP0060_ShipmentPlanConfirmDetailPopup.cs:183 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Project Name", DefColumns.PROJECT_NAME, FPMerge.Restricted, 100, true, FPHAlign.Left, FP… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3974dda7 | this.Load 외 1 | SSP0060_ShipmentPlanConfirmDetailPopup.cs:184 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddComboColumn | ("FCST Type", DefColumns.FCST_TYPE, FPMerge.Restricted, 100, true, dtFcstType, FPHAlign.Le… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3996085b | this.Load 외 1 | SSP0060_ShipmentPlanConfirmDetailPopup.cs:185 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Model", DefColumns.ITEM_ID, FPMerge.Restricted, 80, true, FPHAlign.Left, FPVAlign.Center… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f0ac41c5 | this.Load 외 1 | SSP0060_ShipmentPlanConfirmDetailPopup.cs:186 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("From Site", DefColumns.FROM_SITE, FPMerge.Restricted, 60, true, FPHAlign.Left, FPVAlign.… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0fbd3e20 | this.Load 외 1 | SSP0060_ShipmentPlanConfirmDetailPopup.cs:187 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("To Site", DefColumns.TO_SITE, FPMerge.Restricted, 100, true, FPHAlign.Left, FPVAlign.Cen… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b03e77ae | this.Load 외 1 | SSP0060_ShipmentPlanConfirmDetailPopup.cs:188 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Incoterms", DefColumns.INCOTERMS, FPMerge.Restricted, 65, true, FPHAlign.Center, FPVAlig… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a1e2bb29 | this.Load 외 1 | SSP0060_ShipmentPlanConfirmDetailPopup.cs:190 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("L/T(Day)", DefColumns.LT_DAY, FPMerge.Restricted, 60, true, FPHAlign.Center, FPVAlign.Ce… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b0c01862 | this.Load 외 1 | SSP0060_ShipmentPlanConfirmDetailPopup.cs:191 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddDateColumn | ("ETD", DefColumns.ETD, FPMerge.Restricted, 70, true, FPHAlign.Center, FPVAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-66619b64 | this.Load 외 1 | SSP0060_ShipmentPlanConfirmDetailPopup.cs:192 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddDateColumn | ("ETA", DefColumns.ETA, FPMerge.Restricted, 70, true, FPHAlign.Center, FPVAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8c722289 | this.Load 외 1 | SSP0060_ShipmentPlanConfirmDetailPopup.cs:193 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Trans Mode", DefColumns.TRANSPORT_MODE, FPMerge.Restricted, 45, true, FPHAlign.Center, F… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2caddca4 | this.Load 외 1 | SSP0060_ShipmentPlanConfirmDetailPopup.cs:194 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddDateColumn | ("Shipment Date", DefColumns.SHIPMENT_DATE, FPMerge.Restricted, 70, true, FPHAlign.Center,… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-62b570e5 | this.Load 외 1 | SSP0060_ShipmentPlanConfirmDetailPopup.cs:195 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddNumColumn | ("Qty", DefColumns.SHIPMENT_CONFIRM_QTY, FPMerge.Restricted, 60, true, FPHAlign.Right, FPV… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e6299977 | this.Load 외 1 | SSP0060_ShipmentPlanConfirmDetailPopup.cs:197 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("L/T(Day)", DefColumns.NEW_LT_DAY, FPMerge.Restricted, 60, true, FPHAlign.Center, FPVAlig… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-627c7f7d | this.Load 외 1 | SSP0060_ShipmentPlanConfirmDetailPopup.cs:198 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddDateColumn | ("ETD", DefColumns.NEW_ETD, FPMerge.Restricted, 70, true, FPHAlign.Center, FPVAlign.Center… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-62bad721 | this.Load 외 1 | SSP0060_ShipmentPlanConfirmDetailPopup.cs:199 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddDateColumn | ("ETA", DefColumns.NEW_ETA, FPMerge.Restricted, 70, true, FPHAlign.Center, FPVAlign.Center… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-fca48497 | this.Load 외 1 | SSP0060_ShipmentPlanConfirmDetailPopup.cs:200 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Trans Mode", DefColumns.NEW_TRANSPORT_MODE, FPMerge.Restricted, 45, true, FPHAlign.Cente… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4d85d897 | this.Load 외 1 | SSP0060_ShipmentPlanConfirmDetailPopup.cs:201 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddDateColumn | ("Shipment Date", DefColumns.NEW_SHIPMENT_DATE, FPMerge.Restricted, 70, true, FPHAlign.Cen… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c8e98643 | this.Load 외 1 | SSP0060_ShipmentPlanConfirmDetailPopup.cs:202 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddNumColumn | ("Qty", DefColumns.NEW_SHIPMENT_CONFIRM_QTY, FPMerge.Restricted, 60, true, FPHAlign.Right,… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f2f8c031 | this.Load 외 1 | SSP0060_ShipmentPlanConfirmDetailPopup.cs:203 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddNumColumn | ("Diff Qty", DefColumns.DIFF_QTY, FPMerge.Restricted, 60, true, FPHAlign.Right, FPVAlign.C… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-63c36d97 | this.Load 외 1 | SSP0060_ShipmentPlanConfirmDetailPopup.cs:205 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddComboColumn | ("Change Reason", DefColumns.CHANGE_REASON_CODE, FPMerge.Restricted, 100, true, dtChangeRe… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-522c1d2b | this.Load 외 1 | SSP0060_ShipmentPlanConfirmDetailPopup.cs:206 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Reason Detail", DefColumns.CHANGE_REASON_DETAIL, FPMerge.Restricted, 100, true, FPHAlign… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-582377c0 | this.Load 외 1 | SSP0060_ShipmentPlanConfirmDetailPopup.cs:208 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("NEW_BOD_ID", DefColumns.NEW_BOD_ID, FPMerge.Restricted, 100, false, FPHAlign.Center, FPV… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5bf5fb9d | this.Load 외 1 | SSP0060_ShipmentPlanConfirmDetailPopup.cs:209 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("NEW_ROUTE_ID", DefColumns.NEW_ROUTE_ID, FPMerge.Restricted, 100, false, FPHAlign.Center,… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c5f7e428 | this.Load 외 1 | SSP0060_ShipmentPlanConfirmDetailPopup.cs:210 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("NEW_D_COUNTRY", DefColumns.NEW_D_COUNTRY, FPMerge.Restricted, 100, false, FPHAlign.Cente… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-16e02b9e | this.Load 외 1 | SSP0060_ShipmentPlanConfirmDetailPopup.cs:211 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("NEW_D_PORT_CODE", DefColumns.NEW_D_PORT_CODE, FPMerge.Restricted, 100, false, FPHAlign.C… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4286a055 | this.Load 외 1 | SSP0060_ShipmentPlanConfirmDetailPopup.cs:212 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("NEW_A_COUNTRY", DefColumns.NEW_A_COUNTRY, FPMerge.Restricted, 100, false, FPHAlign.Cente… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2be9f5e5 | this.Load 외 1 | SSP0060_ShipmentPlanConfirmDetailPopup.cs:213 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("NEW_A_PORT_CODE", DefColumns.NEW_A_PORT_CODE, FPMerge.Restricted, 100, false, FPHAlign.C… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3bac9d6e | this.Load 외 1 | SSP0060_ShipmentPlanConfirmDetailPopup.cs:214 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("NEW_TO_COUNTRY", DefColumns.NEW_TO_COUNTRY, FPMerge.Restricted, 100, false, FPHAlign.Cen… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-548dfd17 | this.Load 외 1 | SSP0060_ShipmentPlanConfirmDetailPopup.cs:215 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("NEW_TO_CITY", DefColumns.ELECTRODE_YN, FPMerge.Restricted, 100, false, FPHAlign.Center, … | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-99246f47 | this.Load 외 1 | SSP0060_ShipmentPlanConfirmDetailPopup.cs:216 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("ELECTRODE_YN", DefColumns.NEW_TO_CITY, FPMerge.Restricted, 100, false, FPHAlign.Center, … | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3194704e | this.Load 외 1 | SSP0060_ShipmentPlanConfirmDetailPopup.cs:217 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("ELECTRODE_TYPE", DefColumns.ELECTRODE_TYPE, FPMerge.Restricted, 100, false, FPHAlign.Cen… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-eeb81034 | this.Load 외 1 | SSP0060_ShipmentPlanConfirmDetailPopup.cs:218 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("ORIGIN_FROM_DIVISION_ID", DefColumns.ORIGIN_FROM_DIVISION_ID, FPMerge.Restricted, 100, f… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1e611572 | this.Load 외 1 | SSP0060_ShipmentPlanConfirmDetailPopup.cs:219 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("ORIGIN_TO_DIVISION_ID", DefColumns.ORIGIN_TO_DIVISION_ID, FPMerge.Restricted, 100, false… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0916561e | this.Load 외 1 | SSP0060_ShipmentPlanConfirmDetailPopup.cs:220 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("EDIT_REMARKS", DefColumns.EDIT_REMARKS, FPMerge.Restricted, 100, false, FPHAlign.Center,… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e78fd532 | this.Load 외 1 | SSP0060_ShipmentPlanConfirmDetailPopup.cs:221 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("EDIT_MAIN", DefColumns.EDIT_MAIN, FPMerge.Restricted, 100, false, FPHAlign.Center, FPVAl… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-839765e1 | this.Load 외 1 | SSP0060_ShipmentPlanConfirmDetailPopup.cs:222 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("REMARKS", DefColumns.REMARKS, FPMerge.Restricted, 100, false, FPHAlign.Center, FPVAlign.… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-cbbc3d3b | this.Load 외 1 | SSP0060_ShipmentPlanConfirmDetailPopup.cs:223 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("REMARKS2", DefColumns.REMARKS2, FPMerge.Restricted, 100, false, FPHAlign.Center, FPVAlig… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7049d5d1 | this.Load 외 1 | SSP0060_ShipmentPlanConfirmDetailPopup.cs:224 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("REMARKS3", DefColumns.REMARKS3, FPMerge.Restricted, 100, false, FPHAlign.Center, FPVAlig… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0ac176da | this.Load 외 1 | SSP0060_ShipmentPlanConfirmDetailPopup.cs:225 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("PRODUCT_LEVEL1", DefColumns.PRODUCT_LEVEL1, FPMerge.Restricted, 100, false, FPHAlign.Cen… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-92cafded | this.Load 외 1 | SSP0060_ShipmentPlanConfirmDetailPopup.cs:226 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("NICK_NAME", DefColumns.NICK_NAME, FPMerge.Restricted, 100, false, FPHAlign.Center, FPVAl… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-69873c7e | this.Load 외 1 | SSP0060_ShipmentPlanConfirmDetailPopup.cs:227 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("FROM_SITE_DESCRIPTION", DefColumns.FROM_SITE_DESCRIPTION, FPMerge.Restricted, 100, false… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-94e669ee | this.Load 외 1 | SSP0060_ShipmentPlanConfirmDetailPopup.cs:228 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("TO_SITE_DESCRIPTION", DefColumns.TO_SITE_DESCRIPTION, FPMerge.Restricted, 100, false, FP… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e0e06d02 | this.Load 외 1 | SSP0060_ShipmentPlanConfirmDetailPopup.cs:229 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("PROJECT_CODE", DefColumns.PROJECT_CODE, FPMerge.Restricted, 100, false, FPHAlign.Center,… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3ef0d16f | this.Load 외 1 | SSP0060_ShipmentPlanConfirmDetailPopup.cs:232 | if (spreadInfo.SheetName == SpdSheet.shtMain) | CALL_EXT | siMain.ColumnHeaderSpanRow | (0, siMain.GetColumnIndex(DefColumns.INCOTERMS)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-1e4ef0ac | this.Load 외 1 | SSP0060_ShipmentPlanConfirmDetailPopup.cs:233 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefColumns.LT_DAY), 1, 6, 20, "Confirmed", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f601953b | this.Load 외 1 | SSP0060_ShipmentPlanConfirmDetailPopup.cs:234 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefColumns.NEW_LT_DAY), 1, 6, 20, "Change", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8f8143dd | this.Load 외 1 | SSP0060_ShipmentPlanConfirmDetailPopup.cs:236 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ColumnHeaderSpan | (1, siMain.GetColumnIndex(DefColumns.LT_DAY), 2, 1, 30, "L/T(Day)", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ccd0f27a | this.Load 외 1 | SSP0060_ShipmentPlanConfirmDetailPopup.cs:237 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ColumnHeaderSpan | (1, siMain.GetColumnIndex(DefColumns.ETD), 2, 1, 30, "ETD", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ae0eb5eb | this.Load 외 1 | SSP0060_ShipmentPlanConfirmDetailPopup.cs:238 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ColumnHeaderSpan | (1, siMain.GetColumnIndex(DefColumns.ETA), 2, 1, 30, "ETA", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-93fddb59 | this.Load 외 1 | SSP0060_ShipmentPlanConfirmDetailPopup.cs:239 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ColumnHeaderSpan | (1, siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE), 2, 1, 30, "Trans Mode", FPHAlign.Cen… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-feee20ca | this.Load 외 1 | SSP0060_ShipmentPlanConfirmDetailPopup.cs:240 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ColumnHeaderSpan | (1, siMain.GetColumnIndex(DefColumns.SHIPMENT_DATE), 2, 1, 30, "Shipment Date", FPHAlign.C… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d7b91610 | this.Load 외 1 | SSP0060_ShipmentPlanConfirmDetailPopup.cs:241 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ColumnHeaderSpan | (1, siMain.GetColumnIndex(DefColumns.SHIPMENT_CONFIRM_QTY), 2, 1, 30, "Qty", FPHAlign.Cent… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0a87c7dd | this.Load 외 1 | SSP0060_ShipmentPlanConfirmDetailPopup.cs:243 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ColumnHeaderSpan | (1, siMain.GetColumnIndex(DefColumns.NEW_LT_DAY), 2, 1, 30, "L/T(Day)", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2d7c54c3 | this.Load 외 1 | SSP0060_ShipmentPlanConfirmDetailPopup.cs:244 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ColumnHeaderSpan | (1, siMain.GetColumnIndex(DefColumns.NEW_ETD), 2, 1, 30, "ETD", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1f4dadec | this.Load 외 1 | SSP0060_ShipmentPlanConfirmDetailPopup.cs:245 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ColumnHeaderSpan | (1, siMain.GetColumnIndex(DefColumns.NEW_ETA), 2, 1, 30, "ETA", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-25dba1fd | this.Load 외 1 | SSP0060_ShipmentPlanConfirmDetailPopup.cs:246 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ColumnHeaderSpan | (1, siMain.GetColumnIndex(DefColumns.NEW_TRANSPORT_MODE), 2, 1, 30, "Trans Mode", FPHAlign… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-11df1226 | this.Load 외 1 | SSP0060_ShipmentPlanConfirmDetailPopup.cs:247 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ColumnHeaderSpan | (1, siMain.GetColumnIndex(DefColumns.NEW_SHIPMENT_DATE), 2, 1, 30, "Shipment Date", FPHAli… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1e624e35 | this.Load 외 1 | SSP0060_ShipmentPlanConfirmDetailPopup.cs:248 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ColumnHeaderSpan | (1, siMain.GetColumnIndex(DefColumns.NEW_SHIPMENT_CONFIRM_QTY), 2, 1, 30, "Qty", FPHAlign.… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a5a25cfa | this.Load 외 1 | SSP0060_ShipmentPlanConfirmDetailPopup.cs:250 | if (spreadInfo.SheetName == SpdSheet.shtMain) | CALL_EXT | siMain.ColumnHeaderSpanRow | (siMain.GetColumnIndex(DefColumns.DIFF_QTY), siMain.GetColumnIndex(DefColumns.CHANGE_REASO… | ⚠ 의미 확인 필요 |  |  |  |
| AC-0dc0dce2 | this.Load 외 1 | SSP0060_ShipmentPlanConfirmDetailPopup.cs:252 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.Freeze | (0, this.siMain.GetColumnIndex(DefColumns.INCOTERMS) + 1) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SSP0060_ShipmentPlanConfirmDetailPopup.SetChangeRequestInfo

진입점: this.Load [if (ds.Tables[1].Rows.Count > 0)] / FindButton [if (ds.Tables[1].Rows.Count > 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f4b6b655 | this.Load [if (ds.Tables[1].Rows.Count > 0)] 외 1 | SSP0060_ShipmentPlanConfirmDetailPopup.cs:352 |  | VALUE_SET | txtRequestNo.Text | sRequestNo | 컨트롤 값 설정 |  |  |  |
| AC-38868c59 | this.Load [if (ds.Tables[1].Rows.Count > 0)] 외 1 | SSP0060_ShipmentPlanConfirmDetailPopup.cs:353 |  | VALUE_SET | txtRequestor.Text | sRequestName | 컨트롤 값 설정 |  |  |  |
| AC-6c94291c | this.Load [if (ds.Tables[1].Rows.Count > 0)] 외 1 | SSP0060_ShipmentPlanConfirmDetailPopup.cs:354 |  | VALUE_SET | txtRequestDeptName.Text | sRequestDeptName | 컨트롤 값 설정 |  |  |  |
| AC-52df763b | this.Load [if (ds.Tables[1].Rows.Count > 0)] 외 1 | SSP0060_ShipmentPlanConfirmDetailPopup.cs:355 |  | VALUE_SET | txtApproval.Text | sApproval | 컨트롤 값 설정 |  |  |  |
| AC-175950c9 | this.Load [if (ds.Tables[1].Rows.Count > 0)] 외 1 | SSP0060_ShipmentPlanConfirmDetailPopup.cs:356 |  | VALUE_SET | txtAppDeptName.Text | sApprovalDeptName | 컨트롤 값 설정 |  |  |  |

## SSP0060_ShipmentPlanRequestPopup.btnAutoSet_Click

진입점: this.btnAutoSet.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ca68ef55 | this.btnAutoSet.Click | SSP0060_ShipmentPlanRequestPopup.cs:1983 | if (string.IsNullOrWhiteSpace(txtReasonDetail.ToString()) \|\| string.IsNullOrWhiteSpace(cboChangeReason.Text.ToString()) \|\| c…) | MESSAGE | MessageHelper.GMessageBox | ("MSG00275", new object[] { }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-db656420 | this.btnAutoSet.Click | SSP0060_ShipmentPlanRequestPopup.cs:1984 | if (string.IsNullOrWhiteSpace(txtReasonDetail.ToString()) \|\| string.IsNullOrWhiteSpace(cboChangeReason.Text.ToString()) \|\| c…) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SSP0060_ShipmentPlanRequestPopup.btnButtonList_UsrButtonList_Click_Detected

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-58e29c48 | (진입점 미연결) | SSP0060_ShipmentPlanRequestPopup.cs:290 | switch (buttonItem.UserType) case ButtonListType.Close: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## SSP0060_ShipmentPlanRequestPopup.CalcPlanQty

진입점: this.spdMain.ClipboardPasted [try ▸ for (iRow < e.CellRange.Row + e.CellRange.RowCount) ▸ for (iCol < e.CellRange.Column + e.CellRange.ColumnCount) ▸ if (iCol == siMain.GetColumnIndex(DefColumns.NEW_SHIPMENT_CONFIRM_QTY))] / this.spdMain.Change / this.spdMain.KeyDown [if (e.KeyCode == Keys.Delete) ▸ if (ranges != null) ▸ for (x < 1) ▸ try ▸ if (rowstart >= 0 && rowend >= 0 && colstart >= 0 && colend >= 0) ▸ for (i <= rowend) ▸ for (j <= colend) ▸ if (sColName == DefColumns.NEW_SHIPMENT_CONFIRM_QTY)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ad160221 | this.spdMain.ClipboardPasted [try ▸ for (iRow < e.CellRange.… 외 2 | SSP0060_ShipmentPlanRequestPopup.cs:1843 | if (dsMain == null \|\| dsMain.Tables[0].Rows.Count == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-79afc186 | this.spdMain.ClipboardPasted [try ▸ for (iRow < e.CellRange.… 외 2 | SSP0060_ShipmentPlanRequestPopup.cs:1845 |  | CALL_EXT | CommonUtils.GetValueDecimal | (siMain.GetValue(row, siMain.GetColumnIndex(DefColumns.SHIPMENT_CONFIRM_QTY))) | ⚠ 의미 확인 필요 |  |  |  |
| AC-1ce1c6a3 | this.spdMain.ClipboardPasted [try ▸ for (iRow < e.CellRange.… 외 2 | SSP0060_ShipmentPlanRequestPopup.cs:1846 |  | CALL_EXT | CommonUtils.GetValueDecimal | (siMain.GetValue(row, siMain.GetColumnIndex(DefColumns.NEW_SHIPMENT_CONFIRM_QTY))) | ⚠ 의미 확인 필요 |  |  |  |
| AC-25fb8d4f | this.spdMain.ClipboardPasted [try ▸ for (iRow < e.CellRange.… 외 2 | SSP0060_ShipmentPlanRequestPopup.cs:1848 |  | GRID_SET | siMain.ActiveSheet.SetValue | (row, siMain.GetColumnIndex(DefColumns.DIFF_QTY), new_qty - old_qty) | 그리드 값 설정 |  |  |  |

## SSP0060_ShipmentPlanRequestPopup.ChkConfirmChangeTime

진입점: this.usrButtonList1.UsrButtonList_Click_Detected [if (buttonItem.UserType == ButtonListType.Save) ▸ try ▸ try ▸ if (!string.IsNullOrEmpty(p_confirm_id))] / SaveButton [try ▸ try ▸ if (!string.IsNullOrEmpty(p_confirm_id))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ac749593 | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:1731 |  | ENDPOINT | new FoxDataRequest | ("SSP.SCM_SSP_CHECK_CONFIRM_CHANGETIME_DE") ⇒ SSP.SCM_SSP_CHECK_CONFIRM_CHANGETIME_DE | 엔드포인트 요청 생성 |  |  |  |
| AC-cdcc608f | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:1735 |  | DATA_OP | request.Parameters["p_confirm_id"] | sConfirmID | 행/컬럼 값 대입 |  |  |  |
| AC-f3467d58 | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:1737 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-d0f52074 | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:1742 | if (ds.Tables[0].Rows[0][0].ToString() == "S") | RETURN | return result = true; |  | 처리 중단/반환 |  |  |  |
| AC-1ea479e3 | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:1746 | else of (ds.Tables[0].Rows[0][0].ToString() == "S") ▸ if (ds.Tables[0].Rows[0][0].ToString() == "X") | RETURN | return result = false; |  | 처리 중단/반환 |  |  |  |
| AC-ce75ea4c | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:1748 |  | RETURN | return result; |  | 처리 중단/반환 |  |  |  |

## SSP0060_ShipmentPlanRequestPopup.ChkEngProcessing

진입점: this.usrButtonList1.UsrButtonList_Click_Detected [if (buttonItem.UserType == ButtonListType.Save)] / SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ffa7ae60 | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:716 | try | ENDPOINT | new FoxDataRequest | ("SSP.SSP0003_GET_SSP_PLAN_PROCESSING_CHECK") ⇒ SSP.SSP0003_GET_SSP_PLAN_PROCESSING_CHECK | 엔드포인트 요청 생성 |  |  |  |
| AC-92f8b9ff | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:717 | try | DATA_OP | request.Parameters["p_division_id"] | sDivisionID | 행/컬럼 값 대입 |  |  |  |
| AC-ab3e12a6 | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:719 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-8a1f309a | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:729 | try ▸ if (ds.Tables[0].Rows[0][0].ToString() == "Y") | MESSAGE | MessageHelper.GMessageBox | ("MSG00291", new object[] { remainMinute }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-22d6214f | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:739 | catch ((Exception ex)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-4b38669f | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:741 |  | RETURN | return bReturn; |  | 처리 중단/반환 |  |  |  |

## SSP0060_ShipmentPlanRequestPopup.ChkERPIFBlockYn

진입점: this.usrButtonList1.UsrButtonList_Click_Detected [if (buttonItem.UserType == ButtonListType.Save)] / SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5f4f8fcd | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:753 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.SSPBlockCheckIF, false, "SSP0060") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-72c94a79 | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:756 | if (null != dtERPBlockYnIF && dtERPBlockYnIF.Rows.Count > 0) | DATA_OP | dtERPBlockYnIF.Rows[0].Field | ("BLOCK_YN") | 데이터 객체 조작/조회 |  |  |  |
| AC-417859c8 | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:765 | if (null != dtERPBlockYnIF && dtERPBlockYnIF.Rows.Count > 0) ▸ if (blockYn == "Y") | DATA_OP | dtERPBlockYnIF.Rows[0].Field | ("PERIOD") | 데이터 객체 조작/조회 |  |  |  |
| AC-14deb555 | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:766 | if (null != dtERPBlockYnIF && dtERPBlockYnIF.Rows.Count > 0) ▸ if (blockYn == "Y") | MESSAGE | MessageHelper.GMessageBox | ("MSG00267", new object[] { arg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ecfb951b | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:770 |  | RETURN | return resultYn; |  | 처리 중단/반환 |  |  |  |

## SSP0060_ShipmentPlanRequestPopup.CopyFromAutoSet

진입점: this.btnAutoSet.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-de7ccada | this.btnAutoSet.Click | SSP0060_ShipmentPlanRequestPopup.cs:2016 | for (i < siMain.ActiveSheet.RowCount) ▸ if (siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CHANGE_REASON_CODE)).ToString() == "-" \|\| … | CALL_EXT | siMain.SetValue2 | (i, siMain.GetColumnIndex(CAppSetting.StringAction), i, siMain.GetColumnIndex(CAppSetting.… | ⚠ 의미 확인 필요 |  |  |  |
| AC-03189182 | this.btnAutoSet.Click | SSP0060_ShipmentPlanRequestPopup.cs:2019 | for (i < siMain.ActiveSheet.RowCount) ▸ if (siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CHANGE_REASON_CODE)).ToString() == "-" \|\| … | CALL_EXT | siMain.SetValue2 | (i,siMain.GetColumnIndex(DefColumns.CHANGE_REASON_CODE), i, siMain.GetColumnIndex(DefColum… | ⚠ 의미 확인 필요 |  |  |  |
| AC-e785e98c | this.btnAutoSet.Click | SSP0060_ShipmentPlanRequestPopup.cs:2020 | for (i < siMain.ActiveSheet.RowCount) ▸ if (siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CHANGE_REASON_CODE)).ToString() == "-" \|\| … | CALL_EXT | siMain.SetValue2 | (i, siMain.GetColumnIndex(DefColumns.CHANGE_REASON_DETAIL), i, siMain.GetColumnIndex(DefCo… | ⚠ 의미 확인 필요 |  |  |  |
| AC-6b6d61b9 | this.btnAutoSet.Click | SSP0060_ShipmentPlanRequestPopup.cs:2024 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## SSP0060_ShipmentPlanRequestPopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cbd2fe7b | this.Load | SSP0060_ShipmentPlanRequestPopup.cs:184 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 2, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-c65a8707 | this.Load | SSP0060_ShipmentPlanRequestPopup.cs:185 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-6d933957 | this.Load | SSP0060_ShipmentPlanRequestPopup.cs:187 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SSP0060_ShipmentPlanRequestPopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6408cf40 | this.Load | SSP0060_ShipmentPlanRequestPopup.cs:179 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## SSP0060_ShipmentPlanRequestPopup.Dispose

진입점: this.usrButtonList1.UsrButtonList_Click_Detected [if (buttonItem.UserType == ButtonListType.Save) ▸ finally ▸ if (bApprovedFlag)] / Dispose / SaveButton [finally ▸ if (bApprovedFlag)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3d8fe103 | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 2 | SSP0060_ShipmentPlanRequestPopup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SSP0060_ShipmentPlanRequestPopup.EditButton

진입점: this.Load [if (siMain.IsLock(siMain.SheetName))] / FindButton [if (siMain.IsLock(siMain.SheetName))] / EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3715c40a | this.Load [if (siMain.IsLock(siMain.SheetName))] 외 2 | SSP0060_ShipmentPlanRequestPopup.cs:313 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-3b273ef1 | this.Load [if (siMain.IsLock(siMain.SheetName))] 외 2 | SSP0060_ShipmentPlanRequestPopup.cs:314 |  | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-7383ae30 | this.Load [if (siMain.IsLock(siMain.SheetName))] 외 2 | SSP0060_ShipmentPlanRequestPopup.cs:318 |  | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-49cc5b14 | this.Load [if (siMain.IsLock(siMain.SheetName))] 외 2 | SSP0060_ShipmentPlanRequestPopup.cs:326 | if (bEdit_Mode == false) ▸ if (siMain.Sheet(0).Rows.Count > 0) ▸ for (i < siMain.Sheet(0).Rows.Count) | GRID_LOCK | siMain.LockRange | (i, siMain.GetColumnIndex(DefColumns.NEW_SHIPMENT_DATE), i, siMain.GetColumnIndex(DefColum… | 그리드 편집 잠금/해제 |  |  |  |
| AC-175c5d8e | this.Load [if (siMain.IsLock(siMain.SheetName))] 외 2 | SSP0060_ShipmentPlanRequestPopup.cs:327 | if (bEdit_Mode == false) ▸ if (siMain.Sheet(0).Rows.Count > 0) ▸ for (i < siMain.Sheet(0).Rows.Count) | GRID_LOCK | siMain.LockRange | (i, siMain.GetColumnIndex(DefColumns.CHANGE_REASON_CODE), i, siMain.GetColumnIndex(DefColu… | 그리드 편집 잠금/해제 |  |  |  |
| AC-e4502ef3 | this.Load [if (siMain.IsLock(siMain.SheetName))] 외 2 | SSP0060_ShipmentPlanRequestPopup.cs:331 | if (bEdit_Mode == false) | FLAG | bEdit_Mode | true | 화면 필드/플래그 변경 |  |  |  |
| AC-3b83ac2f | this.Load [if (siMain.IsLock(siMain.SheetName))] 외 2 | SSP0060_ShipmentPlanRequestPopup.cs:339 | else of (bEdit_Mode == false) ▸ if (siMain.Sheet(0).Rows.Count > 0) ▸ for (i < siMain.Sheet(0).Rows.Count) | GRID_LOCK | siMain.LockRange | (i, siMain.GetColumnIndex(DefColumns.CHANGE_REQ_NO), i, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-284fe217 | this.Load [if (siMain.IsLock(siMain.SheetName))] 외 2 | SSP0060_ShipmentPlanRequestPopup.cs:342 | else of (bEdit_Mode == false) | FLAG | bEdit_Mode | false | 화면 필드/플래그 변경 |  |  |  |

## SSP0060_ShipmentPlanRequestPopup.FindData_Main

진입점: this.Load / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dadc691a | this.Load 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:367 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SSP.Plan.WSL/FoxDataService.s… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-d5abccf5 | this.Load 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:371 | lambda | ENDPOINT | new FoxDataRequest | ("SSP.SSP0060_GET_SHIPMENT_REQUEST_CONFIRM_DRAFTING") ⇒ SSP.SSP0060_GET_SHIPMENT_REQUEST_CONFIRM_DRAFTING | 엔드포인트 요청 생성 |  |  |  |
| AC-5ae7b559 | this.Load 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:372 | lambda | DATA_OP | request.Parameters["p_change_request_no"] | _sRequestNo | 행/컬럼 값 대입 |  |  |  |
| AC-0b396678 | this.Load 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:373 | lambda | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-3d746a9a | this.Load 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:374 | lambda | DATA_OP | request.Parameters["p_language"] | sLanguage | 행/컬럼 값 대입 |  |  |  |
| AC-070a4ce9 | this.Load 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:376 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-0e72d855 | this.Load 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:377 | lambda | FLAG | dsMain | response.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-a944bcf8 | this.Load 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:378 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-0f10b042 | this.Load 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:385 |  | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-f5147b0f | this.Load 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:387 |  | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-f65b01ae | this.Load 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:388 |  | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-450ee9fc | this.Load 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:390 |  | FLAG | bEdit_Mode | false | 화면 필드/플래그 변경 |  |  |  |

## SSP0060_ShipmentPlanRequestPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9ad51d7b | this.Load | SSP0060_ShipmentPlanRequestPopup.cs:146 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-02e5483f | this.Load | SSP0060_ShipmentPlanRequestPopup.cs:147 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SSP0060_ShipmentPlanRequestPopup.GetErpIFCheck

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ff1b1aaf | (진입점 미연결) | SSP0060_ShipmentPlanRequestPopup.cs:842 | try | ENDPOINT | new FoxDataRequest | ("SSP.SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM_IF_CHECK") ⇒ SSP.SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM_IF_CHECK | 엔드포인트 요청 생성 |  |  |  |
| AC-dbdfa9a0 | (진입점 미연결) | SSP0060_ShipmentPlanRequestPopup.cs:843 | try | DATA_OP | request.Parameters["p_change_request_no"] | p_change_request_no | 행/컬럼 값 대입 |  |  |  |
| AC-7b11b41a | (진입점 미연결) | SSP0060_ShipmentPlanRequestPopup.cs:844 | try | DATA_OP | request.Parameters["p_change_status"] | p_change_status | 행/컬럼 값 대입 |  |  |  |
| AC-7f7cf3b8 | (진입점 미연결) | SSP0060_ShipmentPlanRequestPopup.cs:845 | try | DATA_OP | request.Parameters["p_time_zone"] | UserInfoContext.Current[UserInfoProperites.TimeZone] | 행/컬럼 값 대입 |  |  |  |
| AC-e8314f5a | (진입점 미연결) | SSP0060_ShipmentPlanRequestPopup.cs:846 | try | DATA_OP | request.Parameters["p_change_type"] | sChangeType | 행/컬럼 값 대입 |  |  |  |
| AC-0a3a35ca | (진입점 미연결) | SSP0060_ShipmentPlanRequestPopup.cs:848 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-b19f7ceb | (진입점 미연결) | SSP0060_ShipmentPlanRequestPopup.cs:891 |  | RETURN | return bFlag; |  | 처리 중단/반환 |  |  |  |

## SSP0060_ShipmentPlanRequestPopup.GetErpIFCheckNew

진입점: this.usrButtonList1.UsrButtonList_Click_Detected [if (buttonItem.UserType == ButtonListType.Save) ▸ try ▸ try ▸ for (i <= siMain.ActiveSheet.RowCount - 1) ▸ if (action != CAppSetting.FlagI) ▸ if (string.IsNullOrWhiteSpace(erpSoNo)) ▸ if (!string.IsNullOrWhiteSpace(p_change_seq))] / SaveButton [try ▸ try ▸ for (i <= siMain.ActiveSheet.RowCount - 1) ▸ if (action != CAppSetting.FlagI) ▸ if (string.IsNullOrWhiteSpace(erpSoNo)) ▸ if (!string.IsNullOrWhiteSpace(p_change_seq))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-488608be | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:1497 | try | CALL_EXT | service.FN_ERP_UIWebService | (RequestNo, "C", "") | ⚠ 의미 확인 필요 |  |  |  |
| AC-f52a70de | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:1506 | try ▸ if (service.RtFlag == "S_E" \|\| service.RtFlag == "E") ▸ if (service.ReErrorMsg.EndsWith("^")) | UI_PROP | service.ReErrorMsg | service.ReErrorMsg.Substring(0, service.ReErrorMsg.Length - 1) | 속성 ReErrorMsg 설정 |  |  |  |
| AC-450c6197 | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:1513 | try ▸ if (service.RtFlag == "S_E" \|\| service.RtFlag == "E") ▸ for (iCount < arrReMsg.Length) | DATA_OP | errConfirmList.Add | (arrReMsg[iCount] + ":" + RequestNo) | 데이터 객체 조작/조회 |  |  |  |
| AC-610a6709 | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:1517 | try ▸ if (service.RtFlag == "S_E" \|\| service.RtFlag == "E") ▸ for (iCount < arrReMsg.Length) | DATA_OP | errConfrimList2.Add | (arrConfirm[0].ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-fbc4a946 | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:1525 | try ▸ if (service.RtFlag == "S_E" \|\| service.RtFlag == "E") | ENDPOINT | new FoxDataRequest | ("SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM") ⇒ SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM | 엔드포인트 요청 생성 |  |  |  |
| AC-90a1919e | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:1527 | try ▸ if (service.RtFlag == "S_E" \|\| service.RtFlag == "E") | DATA_OP | request.Parameters["p_confirm_id"] | p_confirm_id | 행/컬럼 값 대입 |  |  |  |
| AC-154da6d1 | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:1528 | try ▸ if (service.RtFlag == "S_E" \|\| service.RtFlag == "E") | DATA_OP | request.Parameters["p_change_request_no"] | p_change_request_no | 행/컬럼 값 대입 |  |  |  |
| AC-e28e33d9 | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:1529 | try ▸ if (service.RtFlag == "S_E" \|\| service.RtFlag == "E") | DATA_OP | request.Parameters["p_del_flag"] | "D" | 행/컬럼 값 대입 |  |  |  |
| AC-b238885d | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:1530 | try ▸ if (service.RtFlag == "S_E" \|\| service.RtFlag == "E") | DATA_OP | request.Parameters["p_last_updated_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-03fe1f8a | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:1531 | try ▸ if (service.RtFlag == "S_E" \|\| service.RtFlag == "E") | DATA_OP | request.Parameters["p_time_zone"] | UserInfoContext.Current[UserInfoProperites.TimeZone] | 행/컬럼 값 대입 |  |  |  |
| AC-81448b66 | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:1532 | try ▸ if (service.RtFlag == "S_E" \|\| service.RtFlag == "E") | DATA_OP | request.Parameters["p_if_send_flag"] | "Y" | 행/컬럼 값 대입 |  |  |  |
| AC-74776f33 | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:1533 | try ▸ if (service.RtFlag == "S_E" \|\| service.RtFlag == "E") | DATA_OP | request.Parameters["p_change_type"] | "C" | 행/컬럼 값 대입 |  |  |  |
| AC-60f81707 | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:1535 | try ▸ if (service.RtFlag == "S_E" \|\| service.RtFlag == "E") | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-f5b6bcbf | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:1551 | try ▸ if (service.RtFlag == "S_E" \|\| service.RtFlag == "E") ▸ else of (service.RtFlag == "E") ▸ if (service.RtFlag == "S_E") | ENDPOINT | new FoxDataRequest | ("SSP.PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH_NEW_C") ⇒ SSP.PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH_NEW_C | 엔드포인트 요청 생성 |  |  |  |
| AC-14bf025a | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:1553 | try ▸ if (service.RtFlag == "S_E" \|\| service.RtFlag == "E") ▸ else of (service.RtFlag == "E") ▸ if (service.RtFlag == "S_E") | DATA_OP | request.Parameters["p_change_type"] | "B" | 행/컬럼 값 대입 |  |  |  |
| AC-90b1576b | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:1554 | try ▸ if (service.RtFlag == "S_E" \|\| service.RtFlag == "E") ▸ else of (service.RtFlag == "E") ▸ if (service.RtFlag == "S_E") | DATA_OP | request.Parameters["p_change_req_no"] | RequestNo | 행/컬럼 값 대입 |  |  |  |
| AC-894c2dca | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:1555 | try ▸ if (service.RtFlag == "S_E" \|\| service.RtFlag == "E") ▸ else of (service.RtFlag == "E") ▸ if (service.RtFlag == "S_E") | DATA_OP | request.Parameters["p_confirm_id"] | sConfirmId | 행/컬럼 값 대입 |  |  |  |
| AC-b33d49b8 | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:1557 | try ▸ if (service.RtFlag == "S_E" \|\| service.RtFlag == "E") ▸ else of (service.RtFlag == "E") ▸ if (service.RtFlag == "S_E") | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-cc1f12d4 | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:1562 | try ▸ if (service.RtFlag == "S_E" \|\| service.RtFlag == "E") ▸ else of (service.RtFlag == "E") ▸ if (service.RtFlag == "S_E") | CALL_EXT | service.FN_ERP_UIWebService | (RequestNo, "C", "") | ⚠ 의미 확인 필요 |  |  |  |
| AC-a2924366 | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:1568 | try ▸ if (service.RtFlag == "S_E" \|\| service.RtFlag == "E") | DATA_OP | bActiveList.Add | (bFlag) | 데이터 객체 조작/조회 |  |  |  |
| AC-f7fc9899 | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:1573 | try ▸ else of (service.RtFlag == "S_E" \|\| service.RtFlag == "E") ▸ if (service.RtFlag == "F" \|\| service.RtFlag == "C_E") | FLAG | F_CE_requestNo | RequestNo | 화면 필드/플래그 변경 |  |  |  |
| AC-f04c44a8 | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:1582 | try ▸ else of (service.RtFlag == "S_E" \|\| service.RtFlag == "E") ▸ else of (service.RtFlag == "F" \|\| service.RtFlag == "C_E") | ENDPOINT | new FoxDataRequest | ("SSP.PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH_NEW_C") ⇒ SSP.PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH_NEW_C | 엔드포인트 요청 생성 |  |  |  |
| AC-49250d9a | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:1584 | try ▸ else of (service.RtFlag == "S_E" \|\| service.RtFlag == "E") ▸ else of (service.RtFlag == "F" \|\| service.RtFlag == "C_E") | DATA_OP | request.Parameters["p_change_type"] | "B" | 행/컬럼 값 대입 |  |  |  |
| AC-621316e6 | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:1585 | try ▸ else of (service.RtFlag == "S_E" \|\| service.RtFlag == "E") ▸ else of (service.RtFlag == "F" \|\| service.RtFlag == "C_E") | DATA_OP | request.Parameters["p_change_req_no"] | RequestNo | 행/컬럼 값 대입 |  |  |  |
| AC-5525de81 | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:1586 | try ▸ else of (service.RtFlag == "S_E" \|\| service.RtFlag == "E") ▸ else of (service.RtFlag == "F" \|\| service.RtFlag == "C_E") | DATA_OP | request.Parameters["p_confirm_id"] | sConfirmId | 행/컬럼 값 대입 |  |  |  |
| AC-7f1af5e0 | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:1588 | try ▸ else of (service.RtFlag == "S_E" \|\| service.RtFlag == "E") ▸ else of (service.RtFlag == "F" \|\| service.RtFlag == "C_E") | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-bba006a3 | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:1593 | try ▸ else of (service.RtFlag == "S_E" \|\| service.RtFlag == "E") ▸ else of (service.RtFlag == "F" \|\| service.RtFlag == "C_E") | CALL_EXT | service.FN_ERP_UIWebService | (RequestNo, "C", "") | ⚠ 의미 확인 필요 |  |  |  |
| AC-148513fa | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:1596 | try ▸ else of (service.RtFlag == "S_E" \|\| service.RtFlag == "E") ▸ else of (service.RtFlag == "F" \|\| service.RtFlag == "C_E") | DATA_OP | bActiveList.Add | (bFlag) | 데이터 객체 조작/조회 |  |  |  |
| AC-527b020c | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:1602 |  | RETURN | return bFlag; |  | 처리 중단/반환 |  |  |  |
| AC-7115f766 | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:1614 | try | CALL_EXT | service.FN_ERP_UIWebService | (RequestNo, "C", "") | ⚠ 의미 확인 필요 |  |  |  |
| AC-8b51aa7e | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:1623 | try ▸ if (service.RtFlag == "S_E" \|\| service.RtFlag == "E") ▸ if (service.ReErrorMsg.EndsWith("^")) | UI_PROP | service.ReErrorMsg | service.ReErrorMsg.Substring(0, service.ReErrorMsg.Length - 1) | 속성 ReErrorMsg 설정 |  |  |  |
| AC-e38d2b8a | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:1630 | try ▸ if (service.RtFlag == "S_E" \|\| service.RtFlag == "E") ▸ for (iCount < arrReMsg.Length) | DATA_OP | errConfirmList.Add | (arrReMsg[iCount] + ":" + RequestNo) | 데이터 객체 조작/조회 |  |  |  |
| AC-f5aba27a | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:1634 | try ▸ if (service.RtFlag == "S_E" \|\| service.RtFlag == "E") ▸ for (iCount < arrReMsg.Length) | DATA_OP | errConfrimList2.Add | (arrConfirm[0].ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-4a12ddac | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:1642 | try ▸ if (service.RtFlag == "S_E" \|\| service.RtFlag == "E") | ENDPOINT | new FoxDataRequest | ("SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM") ⇒ SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM | 엔드포인트 요청 생성 |  |  |  |
| AC-e50b4e3f | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:1644 | try ▸ if (service.RtFlag == "S_E" \|\| service.RtFlag == "E") | DATA_OP | request.Parameters["p_confirm_id"] | p_confirm_id | 행/컬럼 값 대입 |  |  |  |
| AC-f41ef472 | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:1645 | try ▸ if (service.RtFlag == "S_E" \|\| service.RtFlag == "E") | DATA_OP | request.Parameters["p_change_request_no"] | p_change_request_no | 행/컬럼 값 대입 |  |  |  |
| AC-5491deff | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:1646 | try ▸ if (service.RtFlag == "S_E" \|\| service.RtFlag == "E") | DATA_OP | request.Parameters["p_del_flag"] | "D" | 행/컬럼 값 대입 |  |  |  |
| AC-d06e8616 | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:1647 | try ▸ if (service.RtFlag == "S_E" \|\| service.RtFlag == "E") | DATA_OP | request.Parameters["p_last_updated_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-cd8ff1a5 | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:1648 | try ▸ if (service.RtFlag == "S_E" \|\| service.RtFlag == "E") | DATA_OP | request.Parameters["p_time_zone"] | UserInfoContext.Current[UserInfoProperites.TimeZone] | 행/컬럼 값 대입 |  |  |  |
| AC-a691d5a4 | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:1649 | try ▸ if (service.RtFlag == "S_E" \|\| service.RtFlag == "E") | DATA_OP | request.Parameters["p_if_send_flag"] | "Y" | 행/컬럼 값 대입 |  |  |  |
| AC-1eb555aa | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:1650 | try ▸ if (service.RtFlag == "S_E" \|\| service.RtFlag == "E") | DATA_OP | request.Parameters["p_change_type"] | "C" | 행/컬럼 값 대입 |  |  |  |
| AC-c07d342d | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:1652 | try ▸ if (service.RtFlag == "S_E" \|\| service.RtFlag == "E") | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-bd4b4b20 | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:1668 | try ▸ if (service.RtFlag == "S_E" \|\| service.RtFlag == "E") ▸ else of (service.RtFlag == "E") ▸ if (service.RtFlag == "S_E") | ENDPOINT | new FoxDataRequest | ("SSP.PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH") ⇒ SSP.PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH | 엔드포인트 요청 생성 |  |  |  |
| AC-2111d219 | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:1670 | try ▸ if (service.RtFlag == "S_E" \|\| service.RtFlag == "E") ▸ else of (service.RtFlag == "E") ▸ if (service.RtFlag == "S_E") | DATA_OP | request.Parameters["p_change_type"] | "B" | 행/컬럼 값 대입 |  |  |  |
| AC-c6bdb7cc | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:1671 | try ▸ if (service.RtFlag == "S_E" \|\| service.RtFlag == "E") ▸ else of (service.RtFlag == "E") ▸ if (service.RtFlag == "S_E") | DATA_OP | request.Parameters["p_change_req_no"] | RequestNo | 행/컬럼 값 대입 |  |  |  |
| AC-60e2fedb | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:1674 | try ▸ if (service.RtFlag == "S_E" \|\| service.RtFlag == "E") ▸ else of (service.RtFlag == "E") ▸ if (service.RtFlag == "S_E") | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a8f970c0 | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:1679 | try ▸ if (service.RtFlag == "S_E" \|\| service.RtFlag == "E") ▸ else of (service.RtFlag == "E") ▸ if (service.RtFlag == "S_E") | CALL_EXT | service.FN_ERP_UIWebService | (RequestNo, "C", "") | ⚠ 의미 확인 필요 |  |  |  |
| AC-8cc9d41a | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:1685 | try ▸ if (service.RtFlag == "S_E" \|\| service.RtFlag == "E") | DATA_OP | bActiveList.Add | (bFlag) | 데이터 객체 조작/조회 |  |  |  |
| AC-97145604 | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:1690 | try ▸ else of (service.RtFlag == "S_E" \|\| service.RtFlag == "E") ▸ if (service.RtFlag == "F" \|\| service.RtFlag == "C_E") | FLAG | F_CE_requestNo | RequestNo | 화면 필드/플래그 변경 |  |  |  |
| AC-5fba3012 | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:1699 | try ▸ else of (service.RtFlag == "S_E" \|\| service.RtFlag == "E") ▸ else of (service.RtFlag == "F" \|\| service.RtFlag == "C_E") | ENDPOINT | new FoxDataRequest | ("SSP.PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH") ⇒ SSP.PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH | 엔드포인트 요청 생성 |  |  |  |
| AC-ee40f326 | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:1701 | try ▸ else of (service.RtFlag == "S_E" \|\| service.RtFlag == "E") ▸ else of (service.RtFlag == "F" \|\| service.RtFlag == "C_E") | DATA_OP | request.Parameters["p_change_type"] | "B" | 행/컬럼 값 대입 |  |  |  |
| AC-eb27ce3a | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:1702 | try ▸ else of (service.RtFlag == "S_E" \|\| service.RtFlag == "E") ▸ else of (service.RtFlag == "F" \|\| service.RtFlag == "C_E") | DATA_OP | request.Parameters["p_change_req_no"] | RequestNo | 행/컬럼 값 대입 |  |  |  |
| AC-14f7ba26 | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:1704 | try ▸ else of (service.RtFlag == "S_E" \|\| service.RtFlag == "E") ▸ else of (service.RtFlag == "F" \|\| service.RtFlag == "C_E") | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-9773b59a | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:1709 | try ▸ else of (service.RtFlag == "S_E" \|\| service.RtFlag == "E") ▸ else of (service.RtFlag == "F" \|\| service.RtFlag == "C_E") | CALL_EXT | service.FN_ERP_UIWebService | (RequestNo, "C", "") | ⚠ 의미 확인 필요 |  |  |  |
| AC-3d6d1b67 | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:1712 | try ▸ else of (service.RtFlag == "S_E" \|\| service.RtFlag == "E") ▸ else of (service.RtFlag == "F" \|\| service.RtFlag == "C_E") | DATA_OP | bActiveList.Add | (bFlag) | 데이터 객체 조작/조회 |  |  |  |
| AC-f8b49214 | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:1718 |  | RETURN | return bFlag; |  | 처리 중단/반환 |  |  |  |

## SSP0060_ShipmentPlanRequestPopup.GetERPInterface

진입점: this.usrButtonList1.UsrButtonList_Click_Detected [if (buttonItem.UserType == ButtonListType.Save) ▸ try] / SaveButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-43595023 | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:922 | try ▸ for (i <= siMain.ActiveSheet.RowCount - 1) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM \|\| action == CAppSetti… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-3b0cdcf6 | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:933 | try ▸ for (i <= siMain.ActiveSheet.RowCount - 1) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM \|\| action == CAppSetti… | DATA_OP | (siMain.ActiveSheet.DataSource as DataSet).Tables[0].Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-b0482f08 | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:939 | try ▸ for (i <= siMain.ActiveSheet.RowCount - 1) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM \|\| action == CAppSetti… | MESSAGE | MessageHelper.GMessageBox | ("MSG00247", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d9329c41 | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:940 | try ▸ for (i <= siMain.ActiveSheet.RowCount - 1) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM \|\| action == CAppSetti… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-c051d326 | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:948 | try ▸ for (i <= siMain.ActiveSheet.RowCount - 1) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM \|\| action == CAppSetti… | MESSAGE | GSCM.App.Core.Text.MessageHelper.GMessageBox | ("MSG00049", new object[] { "" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d9b8e737 | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:949 | try ▸ for (i <= siMain.ActiveSheet.RowCount - 1) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM \|\| action == CAppSetti… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-6a894189 | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:963 | try ▸ if (!string.IsNullOrEmpty(p_confirm_id)) ▸ if (!isResult) | MESSAGE | MessageHelper.GMessageBox | ("MSG00404", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3905e4ad | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:965 | try ▸ if (!string.IsNullOrEmpty(p_confirm_id)) ▸ if (!isResult) | RETURN | return bReturn = false; |  | 처리 중단/반환 |  |  |  |
| AC-0ed28544 | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:1044 | try ▸ if (errConfirmList.Count > 0) | ENDPOINT | new FoxDataRequest | ("SSP.SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM") ⇒ SSP.SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM | 엔드포인트 요청 생성 |  |  |  |
| AC-48c95930 | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:1046 | try ▸ if (errConfirmList.Count > 0) | DATA_OP | request.Parameters["p_change_request_no"] | p_change_request_no | 행/컬럼 값 대입 |  |  |  |
| AC-a73171c5 | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:1047 | try ▸ if (errConfirmList.Count > 0) | DATA_OP | request.Parameters["p_confirm_id"] | p_confirm_id2 | 행/컬럼 값 대입 |  |  |  |
| AC-ee8d3422 | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:1048 | try ▸ if (errConfirmList.Count > 0) | DATA_OP | request.Parameters["p_e_type"] | "E" | 행/컬럼 값 대입 |  |  |  |
| AC-44917608 | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:1049 | try ▸ if (errConfirmList.Count > 0) | DATA_OP | request.Parameters["p_e_message"] | p_e_message | 행/컬럼 값 대입 |  |  |  |
| AC-4de23a14 | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:1050 | try ▸ if (errConfirmList.Count > 0) | DATA_OP | request.Parameters["p_last_updated_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-6861a95a | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:1052 | try ▸ if (errConfirmList.Count > 0) | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-d36c66e0 | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:1058 | try ▸ if (errConfirmList.Count > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00197", new object[] { arg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-28c798bd | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:1072 | try ▸ else of (errConfirmList.Count > 0) ▸ if (String.IsNullOrEmpty(F_CE_requestNo) == false) ▸ if (p_confirm_id_F_CE.Length > 0) | ENDPOINT | new FoxDataRequest | ("SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM") ⇒ SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM | 엔드포인트 요청 생성 |  |  |  |
| AC-db6d0b9a | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:1074 | try ▸ else of (errConfirmList.Count > 0) ▸ if (String.IsNullOrEmpty(F_CE_requestNo) == false) ▸ if (p_confirm_id_F_CE.Length > 0) | DATA_OP | request.Parameters["p_confirm_id"] | p_confirm_id_F_CE | 행/컬럼 값 대입 |  |  |  |
| AC-3ac82719 | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:1075 | try ▸ else of (errConfirmList.Count > 0) ▸ if (String.IsNullOrEmpty(F_CE_requestNo) == false) ▸ if (p_confirm_id_F_CE.Length > 0) | DATA_OP | request.Parameters["p_change_request_no"] | F_CE_requestNo | 행/컬럼 값 대입 |  |  |  |
| AC-7c1b2e8d | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:1076 | try ▸ else of (errConfirmList.Count > 0) ▸ if (String.IsNullOrEmpty(F_CE_requestNo) == false) ▸ if (p_confirm_id_F_CE.Length > 0) | DATA_OP | request.Parameters["p_del_flag"] | "D" | 행/컬럼 값 대입 |  |  |  |
| AC-2ef20679 | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:1077 | try ▸ else of (errConfirmList.Count > 0) ▸ if (String.IsNullOrEmpty(F_CE_requestNo) == false) ▸ if (p_confirm_id_F_CE.Length > 0) | DATA_OP | request.Parameters["p_last_updated_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-04255e14 | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:1078 | try ▸ else of (errConfirmList.Count > 0) ▸ if (String.IsNullOrEmpty(F_CE_requestNo) == false) ▸ if (p_confirm_id_F_CE.Length > 0) | DATA_OP | request.Parameters["p_time_zone"] | UserInfoContext.Current[UserInfoProperites.TimeZone] | 행/컬럼 값 대입 |  |  |  |
| AC-f8adb14d | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:1079 | try ▸ else of (errConfirmList.Count > 0) ▸ if (String.IsNullOrEmpty(F_CE_requestNo) == false) ▸ if (p_confirm_id_F_CE.Length > 0) | DATA_OP | request.Parameters["p_if_send_flag"] | "Y" | 행/컬럼 값 대입 |  |  |  |
| AC-859c8e2d | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:1080 | try ▸ else of (errConfirmList.Count > 0) ▸ if (String.IsNullOrEmpty(F_CE_requestNo) == false) ▸ if (p_confirm_id_F_CE.Length > 0) | DATA_OP | request.Parameters["p_change_type"] | "C" | 행/컬럼 값 대입 |  |  |  |
| AC-fdee1053 | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:1082 | try ▸ else of (errConfirmList.Count > 0) ▸ if (String.IsNullOrEmpty(F_CE_requestNo) == false) ▸ if (p_confirm_id_F_CE.Length > 0) | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-696afa63 | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:1088 | try ▸ else of (errConfirmList.Count > 0) ▸ if (String.IsNullOrEmpty(F_CE_requestNo) == false) ▸ if (p_confirm_id_F_CE.Length > 0) | CALL_EXT | service.FN_ERP_UIWebService | (F_CE_requestNo, "C", "") | ⚠ 의미 확인 필요 |  |  |  |
| AC-aa96892d | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:1093 | try ▸ else of (errConfirmList.Count > 0) ▸ if (String.IsNullOrEmpty(F_CE_requestNo) == false) | MESSAGE | MessageHelper.GMessageBox | ("MSG00204", new object[] { arg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f88938b8 | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:1098 | catch ((Exception ex)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-483862ac | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:1101 | finally | STATE_RESET | bActiveList.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-68252385 | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:1102 | finally | STATE_RESET | errConfirmList.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-c901547e | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:1103 | finally | FLAG | F_CE_requestNo | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-17de09e2 | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:1105 |  | RETURN | return bReturn; |  | 처리 중단/반환 |  |  |  |

## SSP0060_ShipmentPlanRequestPopup.GetErpSoNoCnt

진입점: this.usrButtonList1.UsrButtonList_Click_Detected [if (buttonItem.UserType == ButtonListType.Save) ▸ try ▸ try ▸ for (i <= siMain.ActiveSheet.RowCount - 1) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM \|\| action == CAppSetting.FlagD) ▸ if (!string.IsNullOrWhiteSpace(erpSoNo))] / SaveButton [try ▸ try ▸ for (i <= siMain.ActiveSheet.RowCount - 1) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM \|\| action == CAppSetting.FlagD) ▸ if (!string.IsNullOrWhiteSpace(erpSoNo))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e9f7bcd4 | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:1759 | try | ENDPOINT | new FoxDataRequest | ("SSP.SSP0060_GET_ERP_SO_NO_CNT") ⇒ SSP.SSP0060_GET_ERP_SO_NO_CNT | 엔드포인트 요청 생성 |  |  |  |
| AC-99376fbf | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:1760 | try | DATA_OP | request.Parameters["p_division_id"] | sDivisionID | 행/컬럼 값 대입 |  |  |  |
| AC-d15fcc73 | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:1761 | try | DATA_OP | request.Parameters["p_erp_so_no"] | sErpSoNo | 행/컬럼 값 대입 |  |  |  |
| AC-39d67fdb | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:1763 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-31cebd12 | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:1771 | catch ((Exception ex)) | RETURN | return iReturn; |  | 처리 중단/반환 |  |  |  |
| AC-8309a17d | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:1773 |  | RETURN | return iReturn; |  | 처리 중단/반환 |  |  |  |

## SSP0060_ShipmentPlanRequestPopup.GetShipmentStatusChk

진입점: this.usrButtonList1.UsrButtonList_Click_Detected [if (buttonItem.UserType == ButtonListType.Save) ▸ for (iRow < siMain.ActiveSheet.RowCount)] / SaveButton [for (iRow < siMain.ActiveSheet.RowCount)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-850febfb | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:1784 | try | ENDPOINT | new FoxDataRequest | ("SSP.SSP0060_GET_SHIPMENT_STATUS") ⇒ SSP.SSP0060_GET_SHIPMENT_STATUS | 엔드포인트 요청 생성 |  |  |  |
| AC-fbb5e47f | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:1785 | try | DATA_OP | request.Parameters["p_division_id"] | sDivisionID | 행/컬럼 값 대입 |  |  |  |
| AC-9007be44 | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:1786 | try | DATA_OP | request.Parameters["p_confirm_id"] | sConfirmID | 행/컬럼 값 대입 |  |  |  |
| AC-7b99ce3a | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:1788 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-4f2ed30e | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:1803 | try ▸ if (ds.Tables[0].Rows.Count > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00248", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-63ecddcd | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:1817 | try ▸ if (ds.Tables[1].Rows.Count > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00249", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d9482c77 | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:1832 | try ▸ if (ds.Tables[2].Rows.Count > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00189", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-45fdefae | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:1836 | catch ((Exception ex)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-dbc9bb44 | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:1838 |  | RETURN | return bReturn; |  | 처리 중단/반환 |  |  |  |

## SSP0060_ShipmentPlanRequestPopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-86139bcd | this.Load | SSP0060_ShipmentPlanRequestPopup.cs:171 |  | FLAG | dtChangeReasonCode | DataService.GetSSPInnerTable("CHANGE_REASON_CODE_ALL", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-80fb1e4a | this.Load | SSP0060_ShipmentPlanRequestPopup.cs:171 |  | COMBO_DATA | DataService.GetSSPInnerTable | ("CHANGE_REASON_CODE_ALL", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-7e66f039 | this.Load | SSP0060_ShipmentPlanRequestPopup.cs:172 |  | CALL_EXT | clsCtrl.setListBoxEx | (dtChangeReasonCode, cboChangeReason, false, "CODE", "NAME") | ⚠ 의미 확인 필요 |  |  |  |

## SSP0060_ShipmentPlanRequestPopup.InitSpread

진입점: this.Load / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-251089d8 | this.Load 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:196 | if (spreadInfo.SheetName == SpdSheet.shtMain) | DATA_OP | Filter["GROUP_ID"] | UserInfoContext.Current["NowGroupID"] | 행/컬럼 값 대입 |  |  |  |
| AC-510f7bd7 | this.Load 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:197 | if (spreadInfo.SheetName == SpdSheet.shtMain) | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-c9d9e3ef | this.Load 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:200 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.InitSheet | (spreadInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-320a6b18 | this.Load 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:202 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("A", CAppSetting.StringAction, FPMerge.Restricted, 10, false, FPHAlign.Center, FPVAlign.C… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-942c335f | this.Load 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:203 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("change_req_no", DefColumns.CHANGE_REQ_NO, FPMerge.Restricted, 100, false, FPHAlign.Cente… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-711b27e3 | this.Load 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:204 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Division ID", DefColumns.DIVISION_ID, FPMerge.Restricted, 100, false, FPHAlign.Center, F… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-cbf5a0c6 | this.Load 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:205 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("New YN", DefColumns.NEW_YN, FPMerge.Restricted, 10, false, FPHAlign.Left, FPVAlign.Cente… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3260055f | this.Load 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:206 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Confirm/Plan ID", DefColumns.CONFIRM_ID, FPMerge.Restricted, 100, true, FPHAlign.Left, F… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b70e85f9 | this.Load 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:207 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("SO No", DefColumns.ERP_SO_NO, FPMerge.Restricted, 100, true, FPHAlign.Center, FPVAlign.C… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-126faa78 | this.Load 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:208 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Project Name", DefColumns.PROJECT_NAME, FPMerge.Restricted, 100, true, FPHAlign.Left, FP… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1414ad06 | this.Load 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:209 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddComboColumn | ("FCST Type", DefColumns.FCST_TYPE, FPMerge.Restricted, 100, true, dtFcstType, FPHAlign.Le… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-039ab243 | this.Load 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:210 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Model", DefColumns.ITEM_ID, FPMerge.Restricted, 80, true, FPHAlign.Left, FPVAlign.Center… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8b03987c | this.Load 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:211 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("From Site", DefColumns.FROM_SITE, FPMerge.Restricted, 60, true, FPHAlign.Left, FPVAlign.… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-44632a2e | this.Load 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:212 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("To Site", DefColumns.TO_SITE, FPMerge.Restricted, 100, true, FPHAlign.Left, FPVAlign.Cen… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4a92612c | this.Load 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:213 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Incoterms", DefColumns.INCOTERMS, FPMerge.Restricted, 65, true, FPHAlign.Center, FPVAlig… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f97f3068 | this.Load 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:215 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("L/T(Day)", DefColumns.LT_DAY, FPMerge.Restricted, 60, true, FPHAlign.Center, FPVAlign.Ce… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-71d01ed3 | this.Load 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:216 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddDateColumn | ("ETD", DefColumns.ETD, FPMerge.Restricted, 70, true, FPHAlign.Center, FPVAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-dd57a76c | this.Load 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:217 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddDateColumn | ("ETA", DefColumns.ETA, FPMerge.Restricted, 70, true, FPHAlign.Center, FPVAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4a40a27c | this.Load 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:218 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Trans Mode", DefColumns.TRANSPORT_MODE, FPMerge.Restricted, 45, true, FPHAlign.Center, F… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a85db44f | this.Load 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:219 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddDateColumn | ("Shipment Date", DefColumns.SHIPMENT_DATE, FPMerge.Restricted, 70, true, FPHAlign.Center,… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9550cce1 | this.Load 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:220 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddNumColumn | ("Qty", DefColumns.SHIPMENT_CONFIRM_QTY, FPMerge.Restricted, 60, true, FPHAlign.Right, FPV… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-25108928 | this.Load 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:222 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("L/T(Day)", DefColumns.NEW_LT_DAY, FPMerge.Restricted, 60, true, FPHAlign.Center, FPVAlig… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-77c589a8 | this.Load 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:223 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddDateColumn | ("ETD", DefColumns.NEW_ETD, FPMerge.Restricted, 70, true, FPHAlign.Center, FPVAlign.Center… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d2773f02 | this.Load 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:224 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddDateColumn | ("ETA", DefColumns.NEW_ETA, FPMerge.Restricted, 70, true, FPHAlign.Center, FPVAlign.Center… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c36251a4 | this.Load 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:225 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Trans Mode", DefColumns.NEW_TRANSPORT_MODE, FPMerge.Restricted, 45, true, FPHAlign.Cente… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-90c89f92 | this.Load 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:226 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddDateColumn | ("Shipment Date", DefColumns.NEW_SHIPMENT_DATE, FPMerge.Restricted, 70, true, FPHAlign.Cen… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5f76fb26 | this.Load 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:227 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddNumColumn | ("Qty", DefColumns.NEW_SHIPMENT_CONFIRM_QTY, FPMerge.Restricted, 60, true, FPHAlign.Right,… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6164bf51 | this.Load 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:228 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddNumColumn | ("Diff Qty", DefColumns.DIFF_QTY, FPMerge.Restricted, 60, true, FPHAlign.Right, FPVAlign.C… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5bc54358 | this.Load 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:230 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddComboColumn | ("Change Reason", DefColumns.CHANGE_REASON_CODE, FPMerge.Restricted, 100, true, dtChangeRe… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4234b0c9 | this.Load 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:231 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Reason Detail", DefColumns.CHANGE_REASON_DETAIL, FPMerge.Restricted, 100, true, FPHAlign… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f6b6cf5b | this.Load 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:233 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("NEW_BOD_ID", DefColumns.NEW_BOD_ID, FPMerge.Restricted, 100, false, FPHAlign.Center, FPV… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3fb2e763 | this.Load 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:234 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("NEW_ROUTE_ID", DefColumns.NEW_ROUTE_ID, FPMerge.Restricted, 100, false, FPHAlign.Center,… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7fac737d | this.Load 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:235 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("NEW_D_COUNTRY", DefColumns.NEW_D_COUNTRY, FPMerge.Restricted, 100, false, FPHAlign.Cente… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4da56b57 | this.Load 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:236 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("NEW_D_PORT_CODE", DefColumns.NEW_D_PORT_CODE, FPMerge.Restricted, 100, false, FPHAlign.C… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-959c8614 | this.Load 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:237 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("NEW_A_COUNTRY", DefColumns.NEW_A_COUNTRY, FPMerge.Restricted, 100, false, FPHAlign.Cente… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-768060bd | this.Load 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:238 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("NEW_A_PORT_CODE", DefColumns.NEW_A_PORT_CODE, FPMerge.Restricted, 100, false, FPHAlign.C… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-28f6e9b5 | this.Load 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:239 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("NEW_TO_COUNTRY", DefColumns.NEW_TO_COUNTRY, FPMerge.Restricted, 100, false, FPHAlign.Cen… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2de72952 | this.Load 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:240 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("NEW_TO_CITY", DefColumns.ELECTRODE_YN, FPMerge.Restricted, 100, false, FPHAlign.Center, … | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7f4c1d14 | this.Load 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:241 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("ELECTRODE_YN", DefColumns.NEW_TO_CITY, FPMerge.Restricted, 100, false, FPHAlign.Center, … | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-45ed882e | this.Load 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:242 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("ELECTRODE_TYPE", DefColumns.ELECTRODE_TYPE, FPMerge.Restricted, 100, false, FPHAlign.Cen… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5bd55b14 | this.Load 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:243 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("ORIGIN_FROM_DIVISION_ID", DefColumns.ORIGIN_FROM_DIVISION_ID, FPMerge.Restricted, 100, f… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-00b26390 | this.Load 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:244 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("ORIGIN_TO_DIVISION_ID", DefColumns.ORIGIN_TO_DIVISION_ID, FPMerge.Restricted, 100, false… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-80ac3462 | this.Load 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:245 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("EDIT_REMARKS", DefColumns.EDIT_REMARKS, FPMerge.Restricted, 100, false, FPHAlign.Center,… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2069af80 | this.Load 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:246 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("EDIT_MAIN", DefColumns.EDIT_MAIN, FPMerge.Restricted, 100, false, FPHAlign.Center, FPVAl… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5f8288db | this.Load 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:247 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("REMARKS", DefColumns.REMARKS, FPMerge.Restricted, 100, false, FPHAlign.Center, FPVAlign.… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c3adea27 | this.Load 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:248 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("REMARKS2", DefColumns.REMARKS2, FPMerge.Restricted, 100, false, FPHAlign.Center, FPVAlig… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-88909100 | this.Load 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:249 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("REMARKS3", DefColumns.REMARKS3, FPMerge.Restricted, 100, false, FPHAlign.Center, FPVAlig… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-913833ca | this.Load 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:250 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("PRODUCT_LEVEL1", DefColumns.PRODUCT_LEVEL1, FPMerge.Restricted, 100, false, FPHAlign.Cen… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-351c6ba7 | this.Load 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:251 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("NICK_NAME", DefColumns.NICK_NAME, FPMerge.Restricted, 100, false, FPHAlign.Center, FPVAl… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-de4ff031 | this.Load 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:252 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("FROM_SITE_DESCRIPTION", DefColumns.FROM_SITE_DESCRIPTION, FPMerge.Restricted, 100, false… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a9c798dc | this.Load 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:253 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("TO_SITE_DESCRIPTION", DefColumns.TO_SITE_DESCRIPTION, FPMerge.Restricted, 100, false, FP… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-fdc28815 | this.Load 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:254 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("PROJECT_CODE", DefColumns.PROJECT_CODE, FPMerge.Restricted, 100, false, FPHAlign.Center,… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-615f2180 | this.Load 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:257 | if (spreadInfo.SheetName == SpdSheet.shtMain) | CALL_EXT | siMain.ColumnHeaderSpanRow | (0, siMain.GetColumnIndex(DefColumns.INCOTERMS)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-7f737bd5 | this.Load 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:258 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefColumns.LT_DAY), 1, 6, 20, "Confirmed", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-cacbca32 | this.Load 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:259 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefColumns.NEW_LT_DAY), 1, 6, 20, "Change", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3a1da35c | this.Load 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:261 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ColumnHeaderSpan | (1, siMain.GetColumnIndex(DefColumns.LT_DAY), 2, 1, 30, "L/T(Day)", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8bec61a2 | this.Load 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:262 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ColumnHeaderSpan | (1, siMain.GetColumnIndex(DefColumns.ETD), 2, 1, 30, "ETD", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-24095fda | this.Load 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:263 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ColumnHeaderSpan | (1, siMain.GetColumnIndex(DefColumns.ETA), 2, 1, 30, "ETA", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5144034b | this.Load 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:264 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ColumnHeaderSpan | (1, siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE), 2, 1, 30, "Trans Mode", FPHAlign.Cen… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-25bc6fa7 | this.Load 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:265 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ColumnHeaderSpan | (1, siMain.GetColumnIndex(DefColumns.SHIPMENT_DATE), 2, 1, 30, "Shipment Date", FPHAlign.C… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-20ec92c4 | this.Load 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:266 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ColumnHeaderSpan | (1, siMain.GetColumnIndex(DefColumns.SHIPMENT_CONFIRM_QTY), 2, 1, 30, "Qty", FPHAlign.Cent… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4ae5d97a | this.Load 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:268 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ColumnHeaderSpan | (1, siMain.GetColumnIndex(DefColumns.NEW_LT_DAY), 2, 1, 30, "L/T(Day)", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-bee66b46 | this.Load 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:269 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ColumnHeaderSpan | (1, siMain.GetColumnIndex(DefColumns.NEW_ETD), 2, 1, 30, "ETD", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-cbe7d718 | this.Load 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:270 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ColumnHeaderSpan | (1, siMain.GetColumnIndex(DefColumns.NEW_ETA), 2, 1, 30, "ETA", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-fe1ae1e3 | this.Load 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:271 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ColumnHeaderSpan | (1, siMain.GetColumnIndex(DefColumns.NEW_TRANSPORT_MODE), 2, 1, 30, "Trans Mode", FPHAlign… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a7a20fde | this.Load 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:272 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ColumnHeaderSpan | (1, siMain.GetColumnIndex(DefColumns.NEW_SHIPMENT_DATE), 2, 1, 30, "Shipment Date", FPHAli… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-00cbbd03 | this.Load 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:273 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ColumnHeaderSpan | (1, siMain.GetColumnIndex(DefColumns.NEW_SHIPMENT_CONFIRM_QTY), 2, 1, 30, "Qty", FPHAlign.… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-bb48501c | this.Load 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:275 | if (spreadInfo.SheetName == SpdSheet.shtMain) | CALL_EXT | siMain.ColumnHeaderSpanRow | (siMain.GetColumnIndex(DefColumns.DIFF_QTY), siMain.GetColumnIndex(DefColumns.CHANGE_REASO… | ⚠ 의미 확인 필요 |  |  |  |
| AC-cce797d6 | this.Load 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:277 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.Freeze | (0, this.siMain.GetColumnIndex(DefColumns.INCOTERMS) + 1) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SSP0060_ShipmentPlanRequestPopup.NonSoNo

진입점: this.usrButtonList1.UsrButtonList_Click_Detected [if (buttonItem.UserType == ButtonListType.Save) ▸ try ▸ try ▸ for (i <= siMain.ActiveSheet.RowCount - 1) ▸ if (action != CAppSetting.FlagI) ▸ if (string.IsNullOrWhiteSpace(erpSoNo))] / SaveButton [try ▸ try ▸ for (i <= siMain.ActiveSheet.RowCount - 1) ▸ if (action != CAppSetting.FlagI) ▸ if (string.IsNullOrWhiteSpace(erpSoNo))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b19e4403 | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:1385 |  | ENDPOINT | new FoxDataRequest | ("SSP.SSP0060_SAVE_SHIPMENT_REQUEST_DRAFTING_MAIN") ⇒ SSP.SSP0060_SAVE_SHIPMENT_REQUEST_DRAFTING_MAIN | 엔드포인트 요청 생성 |  |  |  |
| AC-bf643d5b | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:1387 |  | DATA_OP | request.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-05d6ab2b | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:1388 |  | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-344f5bfa | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:1389 |  | DATA_OP | request.Parameters["p_change_req_no"] | p_change_seq | 행/컬럼 값 대입 |  |  |  |
| AC-7754f6ab | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:1390 |  | DATA_OP | request.Parameters["p_confirm_id"] | p_confirm_id | 행/컬럼 값 대입 |  |  |  |
| AC-20c80c13 | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:1391 |  | DATA_OP | request.Parameters["p_shipment_qty"] | p_shipment_qty | 행/컬럼 값 대입 |  |  |  |
| AC-588db78e | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:1392 |  | DATA_OP | request.Parameters["p_shipment_date"] | p_shipment_date | 행/컬럼 값 대입 |  |  |  |
| AC-28f34572 | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:1394 |  | DATA_OP | request.Parameters["p_new_yyyymmdd"] | p_new_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-596bff97 | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:1395 |  | DATA_OP | request.Parameters["p_new_qty"] | p_new_qty | 행/컬럼 값 대입 |  |  |  |
| AC-fe7e1605 | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:1396 |  | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-cd9e504c | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:1397 |  | DATA_OP | request.Parameters["p_change_reason_code"] | p_change_reason_code | 행/컬럼 값 대입 |  |  |  |
| AC-fc9dbabc | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:1398 |  | DATA_OP | request.Parameters["p_change_reason_detail"] | p_change_reason_datail | 행/컬럼 값 대입 |  |  |  |
| AC-9b954d5d | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:1399 |  | DATA_OP | request.Parameters["p_title"] | p_title | 행/컬럼 값 대입 |  |  |  |
| AC-1dd7e101 | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:1400 |  | DATA_OP | request.Parameters["p_program_id"] | p_program_id | 행/컬럼 값 대입 |  |  |  |
| AC-e6b89ae0 | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:1402 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a8259018 | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:1408 |  | ENDPOINT | new FoxDataRequest | ("SSP.PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH_NEW_C") ⇒ SSP.PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH_NEW_C | 엔드포인트 요청 생성 |  |  |  |
| AC-1c1b0a45 | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:1410 |  | DATA_OP | request.Parameters["p_change_type"] | "C" | 행/컬럼 값 대입 |  |  |  |
| AC-155ae97e | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:1411 |  | DATA_OP | request.Parameters["p_change_req_no"] | p_change_seq | 행/컬럼 값 대입 |  |  |  |
| AC-b688e081 | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:1412 |  | DATA_OP | request.Parameters["p_confirm_id"] | p_confirm_id | 행/컬럼 값 대입 |  |  |  |
| AC-d9e4ab39 | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:1414 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-39157553 | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:1430 | else of (!string.IsNullOrWhiteSpace(p_change_seq)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00284", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e2fbf0fb | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:1484 |  | RETURN | return bReturn; |  | 처리 중단/반환 |  |  |  |

## SSP0060_ShipmentPlanRequestPopup.RowSave_Check

진입점: this.usrButtonList1.UsrButtonList_Click_Detected [if (buttonItem.UserType == ButtonListType.Save) ▸ try ▸ for (i <= siMain.ActiveSheet.RowCount - 1)] / this.btnAutoSet.Click [for (i < siMain.ActiveSheet.RowCount)] / SaveButton [try ▸ for (i <= siMain.ActiveSheet.RowCount - 1)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7edc6ff1 | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 2 | SSP0060_ShipmentPlanRequestPopup.cs:814 |  | CALL_EXT | CommonUtils.GetValueDecimal | (siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.SHIPMENT_CONFIRM_QTY))) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a01ed9ba | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 2 | SSP0060_ShipmentPlanRequestPopup.cs:814 |  | CALL_EXT | CommonUtils.GetValueDecimal | (siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.NEW_SHIPMENT_CONFIRM_QTY))) | ⚠ 의미 확인 필요 |  |  |  |
| AC-220e272f | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 2 | SSP0060_ShipmentPlanRequestPopup.cs:817 | if (CommonUtils.GetValue(siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.SHIPMENT_DATE))) != CommonUtils.GetValue(siM…) | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-fdf5ffa6 | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 2 | SSP0060_ShipmentPlanRequestPopup.cs:819 |  | RETURN | return false; |  | 처리 중단/반환 |  |  |  |

## SSP0060_ShipmentPlanRequestPopup.SaveData

진입점: this.usrButtonList1.UsrButtonList_Click_Detected [if (buttonItem.UserType == ButtonListType.Save)] / SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b888a482 | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:405 |  | VALIDATE | DataUtil.checkRequiredOfSpread | (siMain) | 프레임워크 검증 |  |  |  |
| AC-624f4f13 | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:407 | if (!DataUtil.checkRequiredOfSpread(siMain)) | FLAG | bSaveCheck | false | 화면 필드/플래그 변경 |  |  |  |
| AC-8ac9c9b9 | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:408 | if (!DataUtil.checkRequiredOfSpread(siMain)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ccf4567a | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:412 | if (!ChkEngProcessing(sDivisionID)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a0cf91c0 | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:417 | if (ChkERPIFBlockYn()) | FLAG | bSaveCheck | false | 화면 필드/플래그 변경 |  |  |  |
| AC-7bc2d142 | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:418 | if (ChkERPIFBlockYn()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-20302665 | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:424 | if (!Validation_Check()) | FLAG | bSaveCheck | false | 화면 필드/플래그 변경 |  |  |  |
| AC-055f915f | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:425 | if (!Validation_Check()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-053a4c37 | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:435 | for (iRow < siMain.ActiveSheet.RowCount) ▸ if (GetShipmentStatusChk(sDivisionID, sConfirmID) == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-24aadf31 | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:440 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00012") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9ff02fd0 | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:442 | if (MessageHelper.GMessageBox("MSG00012") == DialogResult.No) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-41279109 | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:446 |  | STATE_RESET | errConfrimList2.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-b4c7c6ce | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:448 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-ed3d9e4e | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:452 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-cb26cb2c | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:459 | try ▸ if (!GetERPInterface()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-fb10569f | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:584 | try ▸ if (iCount > 0) | ENDPOINT | new FoxDataRequest | ("SSP.SSP0060_SAVE_SHIPMENT_REQUEST_CONFIRM") ⇒ SSP.SSP0060_SAVE_SHIPMENT_REQUEST_CONFIRM | 엔드포인트 요청 생성 |  |  |  |
| AC-c89ee250 | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:588 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-903d7255 | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:589 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-b184bf2b | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:590 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_change_request_no"] | p_change_request_no | 행/컬럼 값 대입 |  |  |  |
| AC-a60d1cf3 | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:591 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_confirm_id"] | p_confirm_id | 행/컬럼 값 대입 |  |  |  |
| AC-6fdc7495 | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:592 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_product_level1"] | p_product_level1 | 행/컬럼 값 대입 |  |  |  |
| AC-378d7de5 | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:593 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-3ee51114 | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:594 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_nick_name"] | p_nick_name | 행/컬럼 값 대입 |  |  |  |
| AC-470089da | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:595 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-ce98d696 | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:596 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_to_site"] | p_to_site | 행/컬럼 값 대입 |  |  |  |
| AC-a140db90 | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:597 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_project_code"] | p_project_code | 행/컬럼 값 대입 |  |  |  |
| AC-6b3706ad | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:598 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_project_name"] | p_project_name | 행/컬럼 값 대입 |  |  |  |
| AC-80e3bdaa | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:599 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_fcst_type"] | p_fcst_type | 행/컬럼 값 대입 |  |  |  |
| AC-4f192762 | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:600 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_etd"] | p_etd | 행/컬럼 값 대입 |  |  |  |
| AC-e579dcf6 | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:601 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_eta"] | p_eta | 행/컬럼 값 대입 |  |  |  |
| AC-78c379e4 | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:602 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_shipment_qty"] | p_shipment_qty | 행/컬럼 값 대입 |  |  |  |
| AC-88b01362 | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:603 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_shipment_date"] | p_shipment_date | 행/컬럼 값 대입 |  |  |  |
| AC-7908b15a | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:604 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_new_bod_id"] | p_new_bod_id | 행/컬럼 값 대입 |  |  |  |
| AC-7ab009ae | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:605 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_new_route_id"] | p_new_route_id | 행/컬럼 값 대입 |  |  |  |
| AC-12e64171 | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:606 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_new_etd_date"] | p_new_etd_date | 행/컬럼 값 대입 |  |  |  |
| AC-47a3db6a | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:607 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_new_eta_date"] | p_new_eta_date | 행/컬럼 값 대입 |  |  |  |
| AC-0e33194f | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:608 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_new_incoterms"] | p_new_incoterms | 행/컬럼 값 대입 |  |  |  |
| AC-3ce0c0c3 | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:609 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_new_transport_mode"] | p_new_transport_mode | 행/컬럼 값 대입 |  |  |  |
| AC-40405498 | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:610 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_new_d_country"] | p_new_d_country | 행/컬럼 값 대입 |  |  |  |
| AC-b55c07ef | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:611 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_new_d_port_code"] | p_new_d_port_code | 행/컬럼 값 대입 |  |  |  |
| AC-b121f62c | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:612 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_new_a_country"] | p_new_a_country | 행/컬럼 값 대입 |  |  |  |
| AC-3229ac0f | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:613 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_new_a_port_code"] | p_new_a_port_code | 행/컬럼 값 대입 |  |  |  |
| AC-703af548 | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:614 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_new_customer_lt"] | p_new_customer_lt | 행/컬럼 값 대입 |  |  |  |
| AC-bf9db24b | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:615 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_new_to_country"] | p_new_to_country | 행/컬럼 값 대입 |  |  |  |
| AC-1e06e406 | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:616 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_new_to_city"] | p_new_to_city | 행/컬럼 값 대입 |  |  |  |
| AC-d94a21de | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:617 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_remarks"] | p_remarks | 행/컬럼 값 대입 |  |  |  |
| AC-28004bed | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:618 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_remarks2"] | p_remarks2 | 행/컬럼 값 대입 |  |  |  |
| AC-15afbadf | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:619 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_remarks3"] | p_remarks3 | 행/컬럼 값 대입 |  |  |  |
| AC-e67cdbb9 | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:620 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-ce4a4b90 | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:621 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_check_need_yn"] | p_check_need_yn | 행/컬럼 값 대입 |  |  |  |
| AC-ef0a7b63 | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:622 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_edit_main"] | p_edit_main | 행/컬럼 값 대입 |  |  |  |
| AC-11c7bac8 | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:623 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_change_reason_code"] | p_change_reason_code | 행/컬럼 값 대입 |  |  |  |
| AC-65e56ce6 | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:624 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_change_reason_detail"] | p_change_reason_detail | 행/컬럼 값 대입 |  |  |  |
| AC-0c9c5550 | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:625 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_top_flag"] | p_top_flag | 행/컬럼 값 대입 |  |  |  |
| AC-cc646ac1 | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:627 | try ▸ if (iCount > 0) | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-c61a24b1 | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:632 | try ▸ if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "S") | FLAG | bApprovedFlag | true | 화면 필드/플래그 변경 |  |  |  |
| AC-9bdbf01f | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:634 | try ▸ if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "S") | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-70288438 | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:635 | try ▸ if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "S") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { ds.Tables[0].Rows[0][1].ToString() }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3d70b2ef | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:651 | try ▸ if (iCount > 0) ▸ else of (ds.Tables[0].Rows[0][0].ToString() == "S") ▸ if (ds.Tables[0].Rows[0][0].ToString() == "X") | MESSAGE | MessageHelper.GMessageBox | ("MSG00324") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-56eab378 | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:653 | try ▸ if (iCount > 0) ▸ else of (ds.Tables[0].Rows[0][0].ToString() == "S") ▸ if (ds.Tables[0].Rows[0][0].ToString() == "X") ▸ if (MessageHe… | CALL_BASE | base.AddHelpButton | ("Standard Information SSP Manual") | ⚠ 의미 확인 필요 |  |  |  |
| AC-ecc06664 | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:664 | try ▸ if (iCount > 0) ▸ else of (ds.Tables[0].Rows[0][0].ToString() == "S") ▸ else of (ds.Tables[0].Rows[0][0].ToString() == "X") | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-ba81ee39 | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:676 | try ▸ if (iCount > 0) ▸ else of (ds.Tables[0].Rows[0][0].ToString() == "S") ▸ else of (ds.Tables[0].Rows[0][0].ToString() == "X") | MESSAGE | MessageHelper.GMessageBox | ("MSG00284", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-646e6292 | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:682 | catch ((Exception ex)) | FLAG | bSaveCheck | false | 화면 필드/플래그 변경 |  |  |  |
| AC-2b3586b9 | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:686 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-c25a5ce2 | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:690 | finally | STATE_RESET | errConfrimList2.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-15f89dea | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:691 | finally | FLAG | bEdit_Mode | false | 화면 필드/플래그 변경 |  |  |  |
| AC-4683fa5d | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:695 | finally ▸ if (bApprovedFlag) | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## SSP0060_ShipmentPlanRequestPopup.SoNo

진입점: this.usrButtonList1.UsrButtonList_Click_Detected [if (buttonItem.UserType == ButtonListType.Save) ▸ try ▸ try ▸ for (i <= siMain.ActiveSheet.RowCount - 1) ▸ if (action != CAppSetting.FlagI) ▸ else of (string.IsNullOrWhiteSpace(erpSoNo))] / SaveButton [try ▸ try ▸ for (i <= siMain.ActiveSheet.RowCount - 1) ▸ if (action != CAppSetting.FlagI) ▸ else of (string.IsNullOrWhiteSpace(erpSoNo))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9f37758e | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:1120 | for (i < intRowIdx) ▸ if (erpSoNo == siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ERP_SO_NO)).ToString()) ▸ if (intRowIdx > i) | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-26b45065 | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:1181 |  | ENDPOINT | new FoxDataRequest | ("SSP.SSP0060_SAVE_SHIPMENT_REQUEST_DRAFTING_MAIN") ⇒ SSP.SSP0060_SAVE_SHIPMENT_REQUEST_DRAFTING_MAIN | 엔드포인트 요청 생성 |  |  |  |
| AC-5eb72362 | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:1185 |  | DATA_OP | request.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-e035b45c | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:1186 |  | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-3ec1bce9 | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:1187 |  | DATA_OP | request.Parameters["p_change_req_no"] | p_change_seq | 행/컬럼 값 대입 |  |  |  |
| AC-e7b5971e | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:1188 |  | DATA_OP | request.Parameters["p_confirm_id"] | p_confirm_id | 행/컬럼 값 대입 |  |  |  |
| AC-1b020afa | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:1189 |  | DATA_OP | request.Parameters["p_shipment_qty"] | p_shipment_qty | 행/컬럼 값 대입 |  |  |  |
| AC-c63680b0 | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:1190 |  | DATA_OP | request.Parameters["p_shipment_date"] | p_shipment_date | 행/컬럼 값 대입 |  |  |  |
| AC-be989d78 | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:1192 |  | DATA_OP | request.Parameters["p_new_yyyymmdd"] | p_new_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-e875871d | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:1193 |  | DATA_OP | request.Parameters["p_new_qty"] | p_new_qty | 행/컬럼 값 대입 |  |  |  |
| AC-909be180 | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:1194 |  | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-e65a4db5 | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:1195 |  | DATA_OP | request.Parameters["p_change_reason_code"] | p_change_reason_code | 행/컬럼 값 대입 |  |  |  |
| AC-a0ab45da | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:1196 |  | DATA_OP | request.Parameters["p_change_reason_detail"] | p_change_reason_datail | 행/컬럼 값 대입 |  |  |  |
| AC-4e421569 | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:1197 |  | DATA_OP | request.Parameters["p_title"] | p_title | 행/컬럼 값 대입 |  |  |  |
| AC-3aa81186 | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:1198 |  | DATA_OP | request.Parameters["p_program_id"] | p_program_id | 행/컬럼 값 대입 |  |  |  |
| AC-ea0d4932 | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:1200 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-41628faf | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:1222 | else of (ds.Tables[0].Rows[0][0].ToString() == "S") ▸ if (ds.Tables[0].Rows[0][0].ToString() == "X") | MESSAGE | MessageHelper.GMessageBox | ("MSG00324") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e6e800be | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:1224 | else of (ds.Tables[0].Rows[0][0].ToString() == "S") ▸ if (ds.Tables[0].Rows[0][0].ToString() == "X") ▸ if (MessageHelper.GMessageBox("MSG003… | CALL_BASE | base.AddHelpButton | ("Standard Information SSP Manual") | ⚠ 의미 확인 필요 |  |  |  |
| AC-f3c0c4dd | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:1245 | else of (ds.Tables[0].Rows[0][0].ToString() == "S") ▸ else of (ds.Tables[0].Rows[0][0].ToString() == "X") | MESSAGE | MessageHelper.GMessageBox | ("MSG00284", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d82ea84f | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:1253 |  | ENDPOINT | new FoxDataRequest | ("SSP.PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH") ⇒ SSP.PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH | 엔드포인트 요청 생성 |  |  |  |
| AC-055a480f | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:1255 |  | DATA_OP | request2.Parameters["p_change_type"] | "C" | 행/컬럼 값 대입 |  |  |  |
| AC-cfbbc959 | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:1256 |  | DATA_OP | request2.Parameters["p_change_req_no"] | p_change_seq | 행/컬럼 값 대입 |  |  |  |
| AC-f438f271 | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:1259 |  | ENDPOINT | client.ExecuteDataSet | (request2) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-0d1f851d | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:1273 | else of (!string.IsNullOrWhiteSpace(p_change_seq)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00284", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9c1f863c | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:1279 |  | RETURN | return bReturn; |  | 처리 중단/반환 |  |  |  |

## SSP0060_ShipmentPlanRequestPopup.spdMain_ClipboardPasted

진입점: this.spdMain.ClipboardPasted

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-60a8bdda | this.spdMain.ClipboardPasted | SSP0060_ShipmentPlanRequestPopup.cs:1968 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SSP0060_ShipmentPlanRequestPopup.spdMain_KeyDown

진입점: this.spdMain.KeyDown

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-86533be9 | this.spdMain.KeyDown | SSP0060_ShipmentPlanRequestPopup.cs:1910 | if (e.KeyCode == Keys.Delete) ▸ if (ranges != null) ▸ for (x < 1) ▸ try | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-db6b41f9 | this.spdMain.KeyDown | SSP0060_ShipmentPlanRequestPopup.cs:1937 | if (e.KeyCode == Keys.Delete) ▸ if (ranges != null) ▸ for (x < 1) ▸ finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-ad09ea26 | this.spdMain.KeyDown | SSP0060_ShipmentPlanRequestPopup.cs:1941 | if (e.KeyCode == Keys.Delete) ▸ if (ranges != null) ▸ for (x < 1) ▸ finally ▸ if (error != null) | MESSAGE | MessageBox.Show | (error) | 메시지 표시 |  |  |  |
| AC-db596ffc | this.spdMain.KeyDown | SSP0060_ShipmentPlanRequestPopup.cs:1946 | if (e.KeyCode == Keys.Delete) ▸ if (ranges != null) | DATA_OP | dsMain.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |

## SSP0060_ShipmentPlanRequestPopup.SSP0060_ShipmentPlanRequestPopup_FormClosing

진입점: this.FormClosing

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-56592b80 | this.FormClosing | SSP0060_ShipmentPlanRequestPopup.cs:1876 | if (!bApprovedFlag) | MESSAGE | MessageHelper.GMessageBox | ("MSG00013") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-01873799 | this.FormClosing | SSP0060_ShipmentPlanRequestPopup.cs:1878 | if (!bApprovedFlag) ▸ if (MessageHelper.GMessageBox("MSG00013") == DialogResult.No) | UI_PROP | e.Cancel | true | 속성 Cancel 설정 |  |  |  |
| AC-12321acb | this.FormClosing | SSP0060_ShipmentPlanRequestPopup.cs:1879 | if (!bApprovedFlag) ▸ if (MessageHelper.GMessageBox("MSG00013") == DialogResult.No) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SSP0060_ShipmentPlanRequestPopup.usrButtonList1_UsrButtonList_Click_Detected

진입점: this.usrButtonList1.UsrButtonList_Click_Detected

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-42f66df5 | this.usrButtonList1.UsrButtonList_Click_Detected | SSP0060_ShipmentPlanRequestPopup.cs:1860 | if (buttonItem.UserType == ButtonListType.Save) ▸ if (!bSaveCheck) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-de0628bb | this.usrButtonList1.UsrButtonList_Click_Detected | SSP0060_ShipmentPlanRequestPopup.cs:1867 | else of (buttonItem.UserType == ButtonListType.Save) ▸ if (buttonItem.UserType == ButtonListType.Cancel) | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## SSP0060_ShipmentPlanRequestPopup.Validation_Check

진입점: this.usrButtonList1.UsrButtonList_Click_Detected [if (buttonItem.UserType == ButtonListType.Save)] / SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5e787b82 | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:790 | for (i < siMain.ActiveSheet.RowCount) | CALL_EXT | CommonUtils.GetValueDecimal | (siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.SHIPMENT_CONFIRM_QTY))) | ⚠ 의미 확인 필요 |  |  |  |
| AC-5d2907cd | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:790 | for (i < siMain.ActiveSheet.RowCount) | CALL_EXT | CommonUtils.GetValueDecimal | (siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.NEW_SHIPMENT_CONFIRM_QTY))) | ⚠ 의미 확인 필요 |  |  |  |
| AC-2aa45357 | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:800 | for (i < siMain.ActiveSheet.RowCount) ▸ if (CommonUtils.GetValue(siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.SHIPMENT_DATE))) != Com… | MESSAGE | MessageHelper.GMessageBox | ("MSG00285", new object[] { (i + 1).ToString() }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-130a291b | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:802 | for (i < siMain.ActiveSheet.RowCount) ▸ if (CommonUtils.GetValue(siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.SHIPMENT_DATE))) != Com… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-d001405d | this.usrButtonList1.UsrButtonList_Click_Detected [if (button… 외 1 | SSP0060_ShipmentPlanRequestPopup.cs:808 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

