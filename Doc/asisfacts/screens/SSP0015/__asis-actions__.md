# AS-IS 액션 대조표 — SSP0015

> 원천: `Doc/asisfacts/screens/SSP0015/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 2031행 · 메서드 111 · 종류 DATA_OP 671 · FLAG 189 · UI_PROP 170 · GRID_INIT 152 · GRID_SET 148 · RETURN 118 · ENDPOINT 107 · POPUP 63 · MESSAGE 62 · UI_MISC 53 · VALUE_SET 46 · CALL_EXT 46 · GRID_LOCK 42 · STATE 38 · GRID_STYLE 31 · COMBO_DATA 29 · GRID_BIND 21 · VALIDATE 14 · STATE_RESET 13 · LIST_REBIND 12 · CALL_BASE 3 · VALUE_CLEAR 2 · GRID_COMBO 1 · ⚠ 의미 확인 필요 49


## SSP0015_ShipmentPSI.BtnChecked_Click

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-eef3ec02 | (진입점 미연결) | SSP0015_ShipmentPSI.cs:8548 | if (siMain.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SSP0015_ShipmentPSI.btnItemId_Click

진입점: this.btnItemId.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d9a7058d | this.btnItemId.Click | SSP0015_ShipmentPSI.cs:2001 |  | POPUP | new SCM0002_ItembyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-80c6d281 | this.btnItemId.Click | SSP0015_ShipmentPSI.cs:2003 |  | POPUP | popItem.Form_Load | (true, sdivision, sScmSite, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-74e8b665 | this.btnItemId.Click | SSP0015_ShipmentPSI.cs:2004 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-4ec0965a | this.btnItemId.Click | SSP0015_ShipmentPSI.cs:2005 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-55e6bee4 | this.btnItemId.Click | SSP0015_ShipmentPSI.cs:2011 | if (popItem.ItemID != "") | VALUE_SET | txtItemId.Text | sItemId | 컨트롤 값 설정 |  |  |  |

## SSP0015_ShipmentPSI.BtnItemID2_Click

진입점: this.btnItemID2.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-438ab7c5 | this.btnItemID2.Click | SSP0015_ShipmentPSI.cs:8418 |  | POPUP | new SCM0002_ItembyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-e190be8b | this.btnItemID2.Click | SSP0015_ShipmentPSI.cs:8420 |  | POPUP | popItem.Form_Load | (true, sdivision, sScmSite, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-e924ddfa | this.btnItemID2.Click | SSP0015_ShipmentPSI.cs:8421 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-de5bb90a | this.btnItemID2.Click | SSP0015_ShipmentPSI.cs:8422 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-6105f87b | this.btnItemID2.Click | SSP0015_ShipmentPSI.cs:8428 | if (popItem.ItemID != "") | VALUE_SET | txtModel2.Text | sItemId | 컨트롤 값 설정 |  |  |  |

## SSP0015_ShipmentPSI.btnMeasure_Click

진입점: this.btnMeasure.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9999551e | this.btnMeasure.Click | SSP0015_ShipmentPSI.cs:2034 | if (fps != null) ▸ else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdDetail") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-11913837 | this.btnMeasure.Click | SSP0015_ShipmentPSI.cs:2039 | if (fps != null) ▸ else of (fps.Name == "spdMain") ▸ else of (fps.Name == "spdDetail") | MESSAGE | MessageHelper.GMessageBox | ("MSG00007", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-50c10d58 | this.btnMeasure.Click | SSP0015_ShipmentPSI.cs:2040 | if (fps != null) ▸ else of (fps.Name == "spdMain") ▸ else of (fps.Name == "spdDetail") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ea21bd2c | this.btnMeasure.Click | SSP0015_ShipmentPSI.cs:2045 | else of (fps != null) | MESSAGE | MessageHelper.GMessageBox | ("MSG00007", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b37ce733 | this.btnMeasure.Click | SSP0015_ShipmentPSI.cs:2046 | else of (fps != null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e085627f | this.btnMeasure.Click | SSP0015_ShipmentPSI.cs:2049 |  | POPUP | new SCM0002_TitleSetForm_Popup | ("SSP0015", shtName, false) | 팝업/폼 생성 |  |  |  |
| AC-f7c8293a | this.btnMeasure.Click | SSP0015_ShipmentPSI.cs:2050 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-5459e509 | this.btnMeasure.Click | SSP0015_ShipmentPSI.cs:2051 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-6122a488 | this.btnMeasure.Click | SSP0015_ShipmentPSI.cs:2055 | if (frm.DialogResult == DialogResult.OK) | UI_PROP | this.CanModelChange | false | 속성 CanModelChange 설정 |  |  |  |
| AC-00d42898 | this.btnMeasure.Click | SSP0015_ShipmentPSI.cs:2065 | if (frm.DialogResult == DialogResult.OK) | UI_PROP | this.CanModelChange | true | 속성 CanModelChange 설정 |  |  |  |

## SSP0015_ShipmentPSI.BtnRequestor_Click

진입점: this.btnRequestor.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d25cae1b | this.btnRequestor.Click | SSP0015_ShipmentPSI.cs:1516 |  | POPUP | new UserInfoPopup | () | 팝업/폼 생성 |  |  |  |
| AC-ea74046a | this.btnRequestor.Click | SSP0015_ShipmentPSI.cs:1518 |  | UI_PROP | popup.Width | 500 | 속성 Width 설정 |  |  |  |
| AC-e4ac0f53 | this.btnRequestor.Click | SSP0015_ShipmentPSI.cs:1519 |  | UI_PROP | popup.Height | 400 | 속성 Height 설정 |  |  |  |
| AC-e4475f6d | this.btnRequestor.Click | SSP0015_ShipmentPSI.cs:1520 |  | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-c60dfb1c | this.btnRequestor.Click | SSP0015_ShipmentPSI.cs:1521 |  | UI_PROP | popup.SSOUserYN | false | 속성 SSOUserYN 설정 |  |  |  |
| AC-166ffc6a | this.btnRequestor.Click | SSP0015_ShipmentPSI.cs:1522 |  | UI_PROP | popup.SingleSelectYn | true | 속성 SingleSelectYn 설정 |  |  |  |
| AC-5fda5f22 | this.btnRequestor.Click | SSP0015_ShipmentPSI.cs:1524 |  | UI_PROP | popup.Language | UserInfoContext.Current[UserInfoProperites.Language].ToString() | 속성 Language 설정 |  |  |  |
| AC-ec096c19 | this.btnRequestor.Click | SSP0015_ShipmentPSI.cs:1526 |  | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-3a016748 | this.btnRequestor.Click | SSP0015_ShipmentPSI.cs:1532 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (popup.SelectedUserInfoList.Count > 0) ▸ foreach (var item in popup.SelectedUserInfoList) | FLAG | sRequestor | item.UserID | 화면 필드/플래그 변경 |  |  |  |
| AC-65faa2f6 | this.btnRequestor.Click | SSP0015_ShipmentPSI.cs:1536 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (popup.SelectedUserInfoList.Count > 0) ▸ foreach (var item in popup.SelectedUserInfoList) ▸ … | VALUE_SET | txtRequestor.Text | item.UserName | 컨트롤 값 설정 |  |  |  |
| AC-233e2c53 | this.btnRequestor.Click | SSP0015_ShipmentPSI.cs:1540 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (popup.SelectedUserInfoList.Count > 0) ▸ foreach (var item in popup.SelectedUserInfoList) ▸ … | VALUE_SET | txtRequestor.Text | item.UserName_E | 컨트롤 값 설정 |  |  |  |

## SSP0015_ShipmentPSI.BtnSearch_Click

진입점: this.btnSearch.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-96ab2dd2 | this.btnSearch.Click | SSP0015_ShipmentPSI.cs:8434 |  | FLAG | bDetail_Search | true | 화면 필드/플래그 변경 |  |  |  |
| AC-de34948f | this.btnSearch.Click | SSP0015_ShipmentPSI.cs:8435 |  | FLAG | sDivision | CString.GetCheckedListValue(dtMyDivision, clbDivision.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-a04d81e7 | this.btnSearch.Click | SSP0015_ShipmentPSI.cs:8436 |  | FLAG | sItemID | txtModel2.Text | 화면 필드/플래그 변경 |  |  |  |
| AC-f91a705a | this.btnSearch.Click | SSP0015_ShipmentPSI.cs:8437 |  | FLAG | sFromSiteID | CString.GetCheckedListValue(dtPlantSiteByDivision, clbPlantSite.ControlValues, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-e0e5da33 | this.btnSearch.Click | SSP0015_ShipmentPSI.cs:8438 |  | FLAG | sPlanStartYyyymmdd | CString.GetCheckedListValue(dtPlanDate, cboPlanDate.ControlValues, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-ba5edbec | this.btnSearch.Click | SSP0015_ShipmentPSI.cs:8439 |  | FLAG | sPlanType | "SP" | 화면 필드/플래그 변경 |  |  |  |
| AC-3dd683aa | this.btnSearch.Click | SSP0015_ShipmentPSI.cs:8440 |  | FLAG | sSeq | "1" | 화면 필드/플래그 변경 |  |  |  |
| AC-a3643fb7 | this.btnSearch.Click | SSP0015_ShipmentPSI.cs:8441 |  | FLAG | sSrh | "N" | 화면 필드/플래그 변경 |  |  |  |
| AC-7530829b | this.btnSearch.Click | SSP0015_ShipmentPSI.cs:8446 | if (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) | FLAG | sSrh | "Y" | 화면 필드/플래그 변경 |  |  |  |
| AC-1191ceb3 | this.btnSearch.Click | SSP0015_ShipmentPSI.cs:8449 | if (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtDetail) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-788ef349 | this.btnSearch.Click | SSP0015_ShipmentPSI.cs:8450 | if (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) | GRID_INIT | siDetail.ChangeActiveSheet | (SpdSheet.shtDetail) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-b0df36e0 | this.btnSearch.Click | SSP0015_ShipmentPSI.cs:8466 | else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtRequestDetail) | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtRequestDetail) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-52b523e9 | this.btnSearch.Click | SSP0015_ShipmentPSI.cs:8467 | else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtRequestDetail) | GRID_INIT | siDetail.ChangeActiveSheet | (SpdSheet.shtRequestDetail) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-fb79f9e1 | this.btnSearch.Click | SSP0015_ShipmentPSI.cs:8476 | else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtRequestDetail) ▸ if … | FLAG | sSrh | "Y" | 화면 필드/플래그 변경 |  |  |  |
| AC-3a9162b7 | this.btnSearch.Click | SSP0015_ShipmentPSI.cs:8478 | else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtRequestDetail) ▸ if … | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtWHstock) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9fe00ded | this.btnSearch.Click | SSP0015_ShipmentPSI.cs:8479 | else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtRequestDetail) ▸ if … | GRID_INIT | siDetail.ChangeActiveSheet | (SpdSheet.shtWHstock) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-1d1b651c | this.btnSearch.Click | SSP0015_ShipmentPSI.cs:8489 | else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtRequestDetail) ▸ els… | FLAG | sSrh | "Y" | 화면 필드/플래그 변경 |  |  |  |
| AC-708b6391 | this.btnSearch.Click | SSP0015_ShipmentPSI.cs:8490 | else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtRequestDetail) ▸ els… | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtBolckStockDetail) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ec1d1809 | this.btnSearch.Click | SSP0015_ShipmentPSI.cs:8491 | else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtRequestDetail) ▸ els… | GRID_INIT | siDetail.ChangeActiveSheet | (SpdSheet.shtBolckStockDetail) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-ae2b96b9 | this.btnSearch.Click | SSP0015_ShipmentPSI.cs:8497 | else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtRequestDetail) ▸ els… | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtMesStock) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d8d805e0 | this.btnSearch.Click | SSP0015_ShipmentPSI.cs:8498 | else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtRequestDetail) ▸ els… | GRID_INIT | siDetail.ChangeActiveSheet | (SpdSheet.shtMesStock) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-b5aa931b | this.btnSearch.Click | SSP0015_ShipmentPSI.cs:8504 | else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtRequestDetail) ▸ els… | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtScsStock) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-86342dc3 | this.btnSearch.Click | SSP0015_ShipmentPSI.cs:8505 | else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtRequestDetail) ▸ els… | GRID_INIT | siDetail.ChangeActiveSheet | (SpdSheet.shtScsStock) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-4af2932c | this.btnSearch.Click | SSP0015_ShipmentPSI.cs:8511 | else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtRequestDetail) ▸ els… | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtStockLocationDetail) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5e203c46 | this.btnSearch.Click | SSP0015_ShipmentPSI.cs:8512 | else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtRequestDetail) ▸ els… | GRID_INIT | siDetail.ChangeActiveSheet | (SpdSheet.shtStockLocationDetail) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-d66de702 | this.btnSearch.Click | SSP0015_ShipmentPSI.cs:8521 | else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtRequestDetail) ▸ els… | FLAG | sSrh | "Y" | 화면 필드/플래그 변경 |  |  |  |
| AC-a5acdaa9 | this.btnSearch.Click | SSP0015_ShipmentPSI.cs:8522 | else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtRequestDetail) ▸ els… | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtWHinPlanDetail) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d3bfca16 | this.btnSearch.Click | SSP0015_ShipmentPSI.cs:8523 | else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtRequestDetail) ▸ els… | GRID_INIT | siDetail.ChangeActiveSheet | (SpdSheet.shtWHinPlanDetail) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-afef9eff | this.btnSearch.Click | SSP0015_ShipmentPSI.cs:8529 | else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtRequestDetail) ▸ els… | FLAG | sSrh | "Y" | 화면 필드/플래그 변경 |  |  |  |
| AC-0cf5c285 | this.btnSearch.Click | SSP0015_ShipmentPSI.cs:8530 | else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtRequestDetail) ▸ els… | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtShipmentResult) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9977d9cd | this.btnSearch.Click | SSP0015_ShipmentPSI.cs:8531 | else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtRequestDetail) ▸ els… | GRID_INIT | siDetail.ChangeActiveSheet | (SpdSheet.shtShipmentResult) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SSP0015_ShipmentPSI.CalculateSum

진입점: this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex == 0) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) ▸ if (sMeasure == "WH_IN") ▸ if (Comments != null) ▸ if (ssp0015Popup.DialogResult == DialogResult.OK) ▸ try] / FindButton [if (siMain.ActiveSheetIndex == 0) ▸ try] / SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-24d51d30 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0015_ShipmentPSI.cs:5037 | for (nCol < dt.Columns.Count) ▸ if (dt.Columns[nCol].ColumnName.IndexOf("M_") == 0) | DATA_OP | listMonth.Add | (nCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-73639357 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0015_ShipmentPSI.cs:5041 | for (nCol < dt.Columns.Count) ▸ if (dt.Columns[nCol].ColumnName.IndexOf("W_") == 0) | DATA_OP | listWeek.Add | (nCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-5299442f | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0015_ShipmentPSI.cs:5085 | for (nCol < dt.Columns.Count) ▸ if (nCol == dt.Columns.Count - 1 \|\| dt.Columns[nCol].ColumnName.IndexOf("W_") == 0) ▸ if (strMeasure == "F… | DATA_OP | dr[nIdxWeek] | weekSum / nCntDayOfWeek | 행/컬럼 값 대입 |  |  |  |
| AC-ca1cdb52 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0015_ShipmentPSI.cs:5089 | for (nCol < dt.Columns.Count) ▸ if (nCol == dt.Columns.Count - 1 \|\| dt.Columns[nCol].ColumnName.IndexOf("W_") == 0) ▸ else of (strMeasure … | DATA_OP | dr[nIdxWeek] | weekSum | 행/컬럼 값 대입 |  |  |  |
| AC-5b5add30 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0015_ShipmentPSI.cs:5103 | for (nCol < dt.Columns.Count) ▸ if (nCol == dt.Columns.Count - 1 \|\| dt.Columns[nCol].ColumnName.IndexOf("M_") == 0) ▸ if (strMeasure == "F… | DATA_OP | dr[nIdxMonth] | monthSum / nCntDayOfMonth | 행/컬럼 값 대입 |  |  |  |
| AC-a7663a04 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0015_ShipmentPSI.cs:5107 | for (nCol < dt.Columns.Count) ▸ if (nCol == dt.Columns.Count - 1 \|\| dt.Columns[nCol].ColumnName.IndexOf("M_") == 0) ▸ else of (strMeasure … | DATA_OP | dr[nIdxMonth] | monthSum | 행/컬럼 값 대입 |  |  |  |
| AC-5f612702 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0015_ShipmentPSI.cs:5116 |  | DATA_OP | dt.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-e49cbd2a | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0015_ShipmentPSI.cs:5210 | for (nCol < columCount) ▸ if (dt.Columns[nCol].ColumnName.IndexOf("M_") == 0) | DATA_OP | listMonth.Add | (nCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-f804cf2e | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0015_ShipmentPSI.cs:5214 | for (nCol < columCount) ▸ if (dt.Columns[nCol].ColumnName.IndexOf("W_") == 0) | DATA_OP | listWeek.Add | (nCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-c71dcbfb | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0015_ShipmentPSI.cs:5296 | for (nRow < rowCount) ▸ for (nCol < columCount) ▸ if (nCol == columCount - 1 \|\| dt.Columns[nCol].ColumnName.IndexOf("W_") == 0) | DATA_OP | dr[nIdxWeek] | weekSum | 행/컬럼 값 대입 |  |  |  |
| AC-f29b8330 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0015_ShipmentPSI.cs:5311 | for (nRow < rowCount) ▸ for (nCol < columCount) ▸ if (nCol == columCount - 1 \|\| dt.Columns[nCol].ColumnName.IndexOf("M_") == 0) | DATA_OP | dr[nIdxMonth] | monthSum | 행/컬럼 값 대입 |  |  |  |
| AC-1e0ebd7d | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0015_ShipmentPSI.cs:5319 |  | DATA_OP | dt.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |

## SSP0015_ShipmentPSI.CboPlanDate_SelectedIndexChanged

진입점: cboPlanDate.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-388f5c0c | cboPlanDate.SelectedIndexChanged | SSP0015_ShipmentPSI.cs:7945 | if (siMain.ActiveSheetIndex == 0) | VALUE_SET | drpPeriod.InitValue | GetDayRange("A") | 컨트롤 값 설정 |  |  |  |
| AC-e9518ac1 | cboPlanDate.SelectedIndexChanged | SSP0015_ShipmentPSI.cs:7946 | if (siMain.ActiveSheetIndex == 0) | VALUE_SET | drpPeriod2.InitValue | GetDayRange("A") | 컨트롤 값 설정 |  |  |  |
| AC-a0cc23aa | cboPlanDate.SelectedIndexChanged | SSP0015_ShipmentPSI.cs:7950 | else of (siMain.ActiveSheetIndex == 0) ▸ if (siMain.ActiveSheetIndex == 1) | VALUE_SET | drpPeriod.InitValue | GetDayRange("P") | 컨트롤 값 설정 |  |  |  |
| AC-3b4191b4 | cboPlanDate.SelectedIndexChanged | SSP0015_ShipmentPSI.cs:7951 | else of (siMain.ActiveSheetIndex == 0) ▸ if (siMain.ActiveSheetIndex == 1) | VALUE_SET | drpPeriod2.InitValue | GetDayRange("P") | 컨트롤 값 설정 |  |  |  |
| AC-f9ac48c0 | cboPlanDate.SelectedIndexChanged | SSP0015_ShipmentPSI.cs:7955 | else of (siMain.ActiveSheetIndex == 0) ▸ else of (siMain.ActiveSheetIndex == 1) | VALUE_SET | drpPeriod.InitValue | GetDayRange("A") | 컨트롤 값 설정 |  |  |  |
| AC-6ed5bb97 | cboPlanDate.SelectedIndexChanged | SSP0015_ShipmentPSI.cs:7956 | else of (siMain.ActiveSheetIndex == 0) ▸ else of (siMain.ActiveSheetIndex == 1) | VALUE_SET | drpPeriod2.InitValue | GetDayRange("A") | 컨트롤 값 설정 |  |  |  |

## SSP0015_ShipmentPSI.checkValidN

진입점: SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.ActiveSheetIndex == 0) ▸ if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtBolckStock)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5331b26e | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:9357 | for (i <= siDetail.GetMaxRowIndex()) ▸ if (intORG_FROM_YYYYMMDD > intORG_TO_YYYYMMDD) | CALL_EXT | siMain.DisplayedSheet.GetViewRowFromModelRow | (i) | ⚠ 의미 확인 필요 |  |  |  |
| AC-aa2a02fa | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:9367 | if (!isPass) | MESSAGE | MessageHelper.GMessageBox | ("MSG00219", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-60893443 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:9370 |  | RETURN | return isPass; |  | 처리 중단/반환 |  |  |  |

## SSP0015_ShipmentPSI.ChkConfirmChangeTime

진입점: SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.ActiveSheetIndex == 0) ▸ if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlockYn()) ▸ try ▸ try ▸ if (!string.IsNullOrEmpty(p_confirm_id))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f64bbc2b | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:9875 |  | ENDPOINT | new FoxDataRequest | ("SSP.SCM_SSP_CHECK_CONFIRM_CHANGETIME") ⇒ SSP.SCM_SSP_CHECK_CONFIRM_CHANGETIME | 엔드포인트 요청 생성 |  |  |  |
| AC-1473ef0a | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:9879 |  | DATA_OP | request.Parameters["p_confirm_id"] | p_confirm_id | 행/컬럼 값 대입 |  |  |  |
| AC-37d92918 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:9881 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-03952987 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:9886 | if (ds.Tables[0].Rows[0][0].ToString() == "S") | RETURN | return result = true; |  | 처리 중단/반환 |  |  |  |
| AC-c08781fd | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:9890 | else of (ds.Tables[0].Rows[0][0].ToString() == "S") ▸ if (ds.Tables[0].Rows[0][0].ToString() == "X") | RETURN | return result = false; |  | 처리 중단/반환 |  |  |  |
| AC-75cd1f3f | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:9892 |  | RETURN | return result; |  | 처리 중단/반환 |  |  |  |

## SSP0015_ShipmentPSI.chkERPIFBlockYn

진입점: SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.ActiveSheetIndex == 0) ▸ if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fa3aeb24 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:7446 |  | FLAG | dtERPBlockYnIF | Data_SCP.Common(Data_SCP.Type.SSPBlockCheckIF, false, "SSP0015") | 화면 필드/플래그 변경 |  |  |  |
| AC-bdd08019 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:7446 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.SSPBlockCheckIF, false, "SSP0015") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-1c965835 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:7449 | if (null != dtERPBlockYnIF && dtERPBlockYnIF.Rows.Count > 0) | DATA_OP | dtERPBlockYnIF.Rows[0].Field | ("BLOCK_YN") | 데이터 객체 조작/조회 |  |  |  |
| AC-3b404639 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:7458 | if (null != dtERPBlockYnIF && dtERPBlockYnIF.Rows.Count > 0) ▸ if (blockYn == "Y") | DATA_OP | dtERPBlockYnIF.Rows[0].Field | ("PERIOD") | 데이터 객체 조작/조회 |  |  |  |
| AC-4319ccbf | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:7459 | if (null != dtERPBlockYnIF && dtERPBlockYnIF.Rows.Count > 0) ▸ if (blockYn == "Y") | MESSAGE | MessageHelper.GMessageBox | ("MSG00267", new object[] { arg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-1da184ae | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:7463 |  | RETURN | return resultYn; |  | 처리 중단/반환 |  |  |  |

## SSP0015_ShipmentPSI.chkSaveYN

진입점: SaveButton [else of (fps.Name == "spdMain") ▸ else of (siMain.ActiveSheetIndex == 0) ▸ if (siMain.ActiveSheetIndex == 1) ▸ if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a37e0a18 | SaveButton [else of (fps.Name == "spdMain") ▸ else of (siMai… | SSP0015_ShipmentPSI.cs:9821 |  | ENDPOINT | new FoxDataRequest | ("SSP.SSP0202_GET_SCS_CONFIRM_ID_CHECK") ⇒ SSP.SSP0202_GET_SCS_CONFIRM_ID_CHECK | 엔드포인트 요청 생성 |  |  |  |
| AC-ca320ec0 | SaveButton [else of (fps.Name == "spdMain") ▸ else of (siMai… | SSP0015_ShipmentPSI.cs:9825 |  | DATA_OP | request.Parameters["p_confirm_id"] | p_confirm_id | 행/컬럼 값 대입 |  |  |  |
| AC-87028850 | SaveButton [else of (fps.Name == "spdMain") ▸ else of (siMai… | SSP0015_ShipmentPSI.cs:9827 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-61c104c8 | SaveButton [else of (fps.Name == "spdMain") ▸ else of (siMai… | SSP0015_ShipmentPSI.cs:9834 | if (ds.Tables[0].Rows.Count > 0) ▸ if (Convert.ToInt32(ds.Tables[0].Rows[0]["CNT"]) > 0) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-f2f7c93f | SaveButton [else of (fps.Name == "spdMain") ▸ else of (siMai… | SSP0015_ShipmentPSI.cs:9840 | if (ds.Tables[0].Rows.Count > 0) ▸ else of (Convert.ToInt32(ds.Tables[0].Rows[0]["CNT"]) > 0) ▸ if (Convert.ToInt32(ds.Tables[1].Rows[0]["CN… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-71a75b6f | SaveButton [else of (fps.Name == "spdMain") ▸ else of (siMai… | SSP0015_ShipmentPSI.cs:9844 | if (ds.Tables[0].Rows.Count > 0) ▸ else of (Convert.ToInt32(ds.Tables[0].Rows[0]["CNT"]) > 0) ▸ else of (Convert.ToInt32(ds.Tables[1].Rows[0… | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-960fdba4 | SaveButton [else of (fps.Name == "spdMain") ▸ else of (siMai… | SSP0015_ShipmentPSI.cs:9854 | else of (ds.Tables[0].Rows.Count > 0) ▸ if (ds.Tables[1].Rows.Count > 0) ▸ if (Convert.ToInt32(ds.Tables[1].Rows[0]["CNT"]) > 0) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-ec0d8649 | SaveButton [else of (fps.Name == "spdMain") ▸ else of (siMai… | SSP0015_ShipmentPSI.cs:9858 | else of (ds.Tables[0].Rows.Count > 0) ▸ if (ds.Tables[1].Rows.Count > 0) ▸ else of (Convert.ToInt32(ds.Tables[1].Rows[0]["CNT"]) > 0) | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-a04bb4f6 | SaveButton [else of (fps.Name == "spdMain") ▸ else of (siMai… | SSP0015_ShipmentPSI.cs:9863 | else of (ds.Tables[0].Rows.Count > 0) ▸ else of (ds.Tables[1].Rows.Count > 0) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |

## SSP0015_ShipmentPSI.ClearUsrCheckedList

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4ff77f18 | (진입점 미연결) | SSP0015_ShipmentPSI.cs:526 | if (dt != null) | STATE_RESET | dt.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-a6a81bb2 | (진입점 미연결) | SSP0015_ShipmentPSI.cs:527 | if (dt != null) | LIST_REBIND | clsCtrl.setListBox | (dt, control, true) | 목록 컨트롤 재구성 |  |  |  |

## SSP0015_ShipmentPSI.Convert_Requestor

진입점: this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ if (siMain.ActiveSheetIndex == 0) ▸ try] / SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.ActiveSheetIndex == 0) ▸ if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlockYn()) ▸ try ▸ if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "S") ▸ if (bDetail_Search == true) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4203116f | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0015_ShipmentPSI.cs:3780 | if (string.IsNullOrWhiteSpace(this.txtRequestor.Text.Trim())) | RETURN | return strCVT_Requestor; |  | 처리 중단/반환 |  |  |  |
| AC-7d15df19 | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0015_ShipmentPSI.cs:3800 |  | RETURN | return strCVT_Requestor; |  | 처리 중단/반환 |  |  |  |

## SSP0015_ShipmentPSI.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8dd68896 | this.Load | SSP0015_ShipmentPSI.cs:656 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 3, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-755430f2 | this.Load | SSP0015_ShipmentPSI.cs:657 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, 0) | 화면 필드/플래그 변경 |  |  |  |
| AC-43a70bee | this.Load | SSP0015_ShipmentPSI.cs:660 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtPacker, SpdSheet.shtPacker, 3, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-d24dd6ca | this.Load | SSP0015_ShipmentPSI.cs:661 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, 1) | 화면 필드/플래그 변경 |  |  |  |
| AC-e77c1c89 | this.Load | SSP0015_ShipmentPSI.cs:665 |  | GRID_INIT | this.AddSheet | (spdDetail, SpdSheet.shtDetail, SpdSheet.shtDetail, 1, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-ad847db7 | this.Load | SSP0015_ShipmentPSI.cs:666 |  | GRID_INIT | this.AddSheet | (spdDetail, SpdSheet.shtRequestDetail, SpdSheet.shtRequestDetail, 1, 1, 60) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-f85d0aee | this.Load | SSP0015_ShipmentPSI.cs:668 |  | GRID_INIT | this.AddSheet | (spdDetail, SpdSheet.shtWHstock, SpdSheet.shtWHstock, 1, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-005d1026 | this.Load | SSP0015_ShipmentPSI.cs:669 |  | GRID_INIT | this.AddSheet | (spdDetail, SpdSheet.shtWHstockDetail, SpdSheet.shtWHstockDetail, 1, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-37e0162f | this.Load | SSP0015_ShipmentPSI.cs:670 |  | GRID_INIT | this.AddSheet | (spdDetail, SpdSheet.shtBolckStock, SpdSheet.shtBolckStock, 1, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-ac20d788 | this.Load | SSP0015_ShipmentPSI.cs:671 |  | GRID_INIT | this.AddSheet | (spdDetail, SpdSheet.shtBolckStockDetail, SpdSheet.shtBolckStockDetail, 1, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-d64f3d88 | this.Load | SSP0015_ShipmentPSI.cs:672 |  | GRID_INIT | this.AddSheet | (spdDetail, SpdSheet.shtMesStock, SpdSheet.shtMesStock, 1, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-9cd5f0bc | this.Load | SSP0015_ShipmentPSI.cs:673 |  | GRID_INIT | this.AddSheet | (spdDetail, SpdSheet.shtScsStock, SpdSheet.shtScsStock, 1, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-956f2262 | this.Load | SSP0015_ShipmentPSI.cs:674 |  | GRID_INIT | this.AddSheet | (spdDetail, SpdSheet.shtStockLocationDetail, SpdSheet.shtStockLocationDetail, 1, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-dd624d31 | this.Load | SSP0015_ShipmentPSI.cs:680 | if (drPgmAuthId != null) | GRID_INIT | this.AddSheet | (spdDetail, SpdSheet.shtWHinPlanDetail, SpdSheet.shtWHinPlanDetail, 1, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-153c5d9f | this.Load | SSP0015_ShipmentPSI.cs:683 |  | GRID_INIT | this.AddSheet | (spdDetail, SpdSheet.shtShipmentResult, SpdSheet.shtShipmentResult, 1, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-3d3ea17b | this.Load | SSP0015_ShipmentPSI.cs:685 |  | FLAG | siDetail | GetSheetInfo(spdDetail.Name, SpdSheet.shtDetail) | 화면 필드/플래그 변경 |  |  |  |
| AC-baafe775 | this.Load | SSP0015_ShipmentPSI.cs:686 |  | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtDetail) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9be4e70f | this.Load | SSP0015_ShipmentPSI.cs:692 |  | FLAG | siDetail | GetSheetInfo(spdDetail.Name, SpdSheet.shtRequestDetail) | 화면 필드/플래그 변경 |  |  |  |
| AC-ee7bb204 | this.Load | SSP0015_ShipmentPSI.cs:693 |  | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtRequestDetail) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-fde2b8b3 | this.Load | SSP0015_ShipmentPSI.cs:698 |  | FLAG | siDetail | GetSheetInfo(spdDetail.Name, SpdSheet.shtWHstock) | 화면 필드/플래그 변경 |  |  |  |
| AC-43aecbaa | this.Load | SSP0015_ShipmentPSI.cs:699 |  | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtWHstock) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-dfe80563 | this.Load | SSP0015_ShipmentPSI.cs:702 |  | FLAG | siDetail | GetSheetInfo(spdDetail.Name, SpdSheet.shtWHstockDetail) | 화면 필드/플래그 변경 |  |  |  |
| AC-0eda7d6d | this.Load | SSP0015_ShipmentPSI.cs:703 |  | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtWHstockDetail) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a2ec2c2f | this.Load | SSP0015_ShipmentPSI.cs:706 |  | FLAG | siDetail | GetSheetInfo(spdDetail.Name, SpdSheet.shtBolckStock) | 화면 필드/플래그 변경 |  |  |  |
| AC-425b85f4 | this.Load | SSP0015_ShipmentPSI.cs:707 |  | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtBolckStock) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-123057d9 | this.Load | SSP0015_ShipmentPSI.cs:710 |  | FLAG | siDetail | GetSheetInfo(spdDetail.Name, SpdSheet.shtBolckStockDetail) | 화면 필드/플래그 변경 |  |  |  |
| AC-ca4917f5 | this.Load | SSP0015_ShipmentPSI.cs:711 |  | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtBolckStockDetail) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-fcdb4c64 | this.Load | SSP0015_ShipmentPSI.cs:714 |  | FLAG | siDetail | GetSheetInfo(spdDetail.Name, SpdSheet.shtMesStock) | 화면 필드/플래그 변경 |  |  |  |
| AC-75602807 | this.Load | SSP0015_ShipmentPSI.cs:715 |  | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtMesStock) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-baf2d946 | this.Load | SSP0015_ShipmentPSI.cs:719 |  | FLAG | siDetail | GetSheetInfo(spdDetail.Name, SpdSheet.shtScsStock) | 화면 필드/플래그 변경 |  |  |  |
| AC-bedf02ec | this.Load | SSP0015_ShipmentPSI.cs:720 |  | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtScsStock) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b93db0b6 | this.Load | SSP0015_ShipmentPSI.cs:723 |  | FLAG | siDetail | GetSheetInfo(spdDetail.Name, SpdSheet.shtStockLocationDetail) | 화면 필드/플래그 변경 |  |  |  |
| AC-ff13f424 | this.Load | SSP0015_ShipmentPSI.cs:724 |  | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtStockLocationDetail) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e7569083 | this.Load | SSP0015_ShipmentPSI.cs:731 | if (drPgmAuthId != null) | FLAG | siDetail | GetSheetInfo(spdDetail.Name, SpdSheet.shtWHinPlanDetail) | 화면 필드/플래그 변경 |  |  |  |
| AC-dbc5b452 | this.Load | SSP0015_ShipmentPSI.cs:732 | if (drPgmAuthId != null) | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtWHinPlanDetail) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8994a0ec | this.Load | SSP0015_ShipmentPSI.cs:736 |  | FLAG | siDetail | GetSheetInfo(spdDetail.Name, SpdSheet.shtShipmentResult) | 화면 필드/플래그 변경 |  |  |  |
| AC-6fc8367c | this.Load | SSP0015_ShipmentPSI.cs:737 |  | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtShipmentResult) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c9478bc7 | this.Load | SSP0015_ShipmentPSI.cs:740 |  | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtWHstock) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-bb5c69e2 | this.Load | SSP0015_ShipmentPSI.cs:741 |  | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtDetail) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a808a6ac | this.Load | SSP0015_ShipmentPSI.cs:746 |  | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtMain) | 그리드 컬럼/헤더 구성 |  |  |  |

## SSP0015_ShipmentPSI.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-abde90cc | this.Load | SSP0015_ShipmentPSI.cs:512 |  | UI_PROP | siMain.ImagePopUp | imageList1.Images[0] | 속성 ImagePopUp 설정 |  |  |  |
| AC-c577cc68 | this.Load | SSP0015_ShipmentPSI.cs:514 |  | FLAG | cellTypeImage | new TextCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-2e2b1b17 | this.Load | SSP0015_ShipmentPSI.cs:515 |  | UI_PROP | cellTypeImage.BackgroundImage | new FarPoint.Win.Picture(siMain.ImagePopUp) | 속성 BackgroundImage 설정 |  |  |  |
| AC-ff0b4a5f | this.Load | SSP0015_ShipmentPSI.cs:516 |  | UI_PROP | cellTypeImage.BackgroundImage.AlignHorz | FarPoint.Win.HorizontalAlignment.Right | 속성 AlignHorz 설정 |  |  |  |
| AC-952f00d5 | this.Load | SSP0015_ShipmentPSI.cs:519 |  | VALUE_SET | cboBucketType.ControlValues | BucketType.Daily | 컨트롤 값 설정 |  |  |  |

## SSP0015_ShipmentPSI.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1836d4be | DeleteButton | SSP0015_ShipmentPSI.cs:1724 | if (fps != null) ▸ if (fps.Name == "spdDetail" && siDetail.ActiveSheet.SheetName == SpdSheet.shtBolckStock) ▸ if (siDetail.ActiveSheet.Activ… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4a5d7600 | DeleteButton | SSP0015_ShipmentPSI.cs:1729 | if (fps != null) ▸ if (fps.Name == "spdDetail" && siDetail.ActiveSheet.SheetName == SpdSheet.shtBolckStock) ▸ if (action == CAppSetting.Flag… | DATA_OP | siDetail.Delete | () | 데이터 객체 조작/조회 |  |  |  |

## SSP0015_ShipmentPSI.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4aa0c612 | Dispose | SSP0015_ShipmentPSI.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SSP0015_ShipmentPSI.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-795c96f0 | EditButton | SSP0015_ShipmentPSI.cs:1743 | if (isOK == false) | MESSAGE | MessageHelper.GMessageBox | ("MSG00251", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b93a6545 | EditButton | SSP0015_ShipmentPSI.cs:1744 | if (isOK == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-217c8cf3 | EditButton | SSP0015_ShipmentPSI.cs:1753 | if (siMain.ActiveSheetIndex == 0) | FLAG | dtNewPlanDate | Data.Common(Data.Type.PlanDateShip, false, pDivisionID, "A") ⇒ biz:CommonData.CommonDataList [code=PlanDateShip] | 화면 필드/플래그 변경 |  |  |  |
| AC-0c476eb9 | EditButton | SSP0015_ShipmentPSI.cs:1753 | if (siMain.ActiveSheetIndex == 0) | COMBO_DATA | Data.Common | (Data.Type.PlanDateShip, false, pDivisionID, "A") ⇒ biz:CommonData.CommonDataList [code=PlanDateShip] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-7ae787aa | EditButton | SSP0015_ShipmentPSI.cs:1757 | else of (siMain.ActiveSheetIndex == 0) ▸ if (siMain.ActiveSheetIndex == 1) | FLAG | dtNewPlanDate | Data.Common(Data.Type.PlanDateShip, false, pDivisionID, "P") ⇒ biz:CommonData.CommonDataList [code=PlanDateShip] | 화면 필드/플래그 변경 |  |  |  |
| AC-404c1e91 | EditButton | SSP0015_ShipmentPSI.cs:1757 | else of (siMain.ActiveSheetIndex == 0) ▸ if (siMain.ActiveSheetIndex == 1) | COMBO_DATA | Data.Common | (Data.Type.PlanDateShip, false, pDivisionID, "P") ⇒ biz:CommonData.CommonDataList [code=PlanDateShip] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-7706ed75 | EditButton | SSP0015_ShipmentPSI.cs:1762 |  | DATA_OP | dtNewPlanDate.Compute | ("Max(code)", null) | 데이터 객체 조작/조회 |  |  |  |
| AC-fd91e90c | EditButton | SSP0015_ShipmentPSI.cs:1767 | if (oldPlanDate != newPlanDate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00170", new object[] { null }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-52963b70 | EditButton | SSP0015_ShipmentPSI.cs:1769 | if (oldPlanDate != newPlanDate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d8a39954 | EditButton | SSP0015_ShipmentPSI.cs:1775 | if (fps != null && isPass == true) | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-c1e69b77 | EditButton | SSP0015_ShipmentPSI.cs:1782 | if (fps != null && isPass == true) ▸ if (fps.Name == "spdMain") ▸ if (siMain.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3628b165 | EditButton | SSP0015_ShipmentPSI.cs:1783 | if (fps != null && isPass == true) ▸ if (fps.Name == "spdMain") | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-618ea3a4 | EditButton | SSP0015_ShipmentPSI.cs:1785 | if (fps != null && isPass == true) ▸ if (fps.Name == "spdMain") | CALL_EXT | siMain.SwitchLockEx | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-3879149e | EditButton | SSP0015_ShipmentPSI.cs:1786 | if (fps != null && isPass == true) ▸ if (fps.Name == "spdMain") | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-82c45994 | EditButton | SSP0015_ShipmentPSI.cs:1788 | if (fps != null && isPass == true) ▸ if (fps.Name == "spdMain") | GRID_LOCK | siMain.LockRange2 | (0, 0, siMain.ActiveSheet.RowCount - 1, siMain.ActiveSheet.ColumnCount - 1, true) | 그리드 편집 잠금 전환 |  |  |  |
| AC-b920bd7f | EditButton | SSP0015_ShipmentPSI.cs:1791 | if (fps != null && isPass == true) ▸ if (fps.Name == "spdMain") | CALL_EXT | fps.ActiveSheet.GetColumnFromTag | (null, CAppSetting.StringAction) | ⚠ 의미 확인 필요 |  |  |  |
| AC-724fa8eb | EditButton | SSP0015_ShipmentPSI.cs:1795 | if (fps != null && isPass == true) ▸ if (fps.Name == "spdMain") | CALL_EXT | fps.ActiveSheet.Columns.Get | (xCol1) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ae4f5a98 | EditButton | SSP0015_ShipmentPSI.cs:1807 | if (fps != null && isPass == true) ▸ if (fps.Name == "spdMain") ▸ if (fps.ActiveSheet.Columns.Get(xCol1).Visible == true) ▸ for (i < spdMain… | CALL_EXT | Convert.ToInt16 | (frozen_day_value) | ⚠ 의미 확인 필요 |  |  |  |
| AC-fc600ae2 | EditButton | SSP0015_ShipmentPSI.cs:1812 | if (fps != null && isPass == true) ▸ if (fps.Name == "spdMain") ▸ if (fps.ActiveSheet.Columns.Get(xCol1).Visible == true) ▸ for (i < spdMain… | GRID_STYLE | siMain.SetBGColor2 | (i, startIdx, i, intEndIdx, Color.FromArgb(Convert.ToInt32(242), Convert.ToInt32(242), Con… | 그리드 표시 설정 |  |  |  |
| AC-a5ca262a | EditButton | SSP0015_ShipmentPSI.cs:1826 | if (fps != null && isPass == true) ▸ if (fps.Name == "spdMain") ▸ if (fps.ActiveSheet.Columns.Get(xCol1).Visible == true) ▸ for (i < spdMain… | GRID_LOCK | siMain.LockRange2 | (nEditableRow, nStartEditIdx, nEditableRow, siMain.ActiveSheet.ColumnCount - 1, false) | 그리드 편집 잠금 전환 |  |  |  |
| AC-7111e986 | EditButton | SSP0015_ShipmentPSI.cs:1844 | if (fps != null && isPass == true) ▸ if (fps.Name == "spdMain") ▸ else of (fps.ActiveSheet.Columns.Get(xCol1).Visible == true) ▸ for (i < sp… | CALL_EXT | Convert.ToInt16 | (frozen_day_value) | ⚠ 의미 확인 필요 |  |  |  |
| AC-bbb1020e | EditButton | SSP0015_ShipmentPSI.cs:1849 | if (fps != null && isPass == true) ▸ if (fps.Name == "spdMain") ▸ else of (fps.ActiveSheet.Columns.Get(xCol1).Visible == true) ▸ for (i < sp… | GRID_STYLE | siMain.SetBGColor2 | (i, startIdx, i, intEndIdx, Color.FromArgb(Convert.ToInt32(242), Convert.ToInt32(242), Con… | 그리드 표시 설정 |  |  |  |
| AC-5bd0df5f | EditButton | SSP0015_ShipmentPSI.cs:1868 | if (fps != null && isPass == true) ▸ if (fps.Name == "spdDetail") ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtWHstock \|\| siDetail.… | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b4846c59 | EditButton | SSP0015_ShipmentPSI.cs:1869 | if (fps != null && isPass == true) ▸ if (fps.Name == "spdDetail") ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtWHstock \|\| siDetail.… | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-d05f49af | EditButton | SSP0015_ShipmentPSI.cs:1870 | if (fps != null && isPass == true) ▸ if (fps.Name == "spdDetail") ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtWHstock \|\| siDetail.… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0a848d6a | EditButton | SSP0015_ShipmentPSI.cs:1893 | if (fps != null && isPass == true) ▸ if (fps.Name == "spdDetail") | FLAG | siDetail | GetSheetInfo(spdDetail.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-99747c67 | EditButton | SSP0015_ShipmentPSI.cs:1894 | if (fps != null && isPass == true) ▸ if (fps.Name == "spdDetail") | GRID_LOCK | siDetail.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-d95df498 | EditButton | SSP0015_ShipmentPSI.cs:1915 | if (fps != null && isPass == true) ▸ if (fps.Name == "spdDetail") ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ if (siMain.A… | GRID_LOCK | siDetail.LockColumn | (siDetail.GetColumnIndex(DefColumns.DIVISION_ID), siDetail.GetColumnIndex(DefColumns.FCST_… | 그리드 편집 잠금/해제 |  |  |  |
| AC-d8fa872a | EditButton | SSP0015_ShipmentPSI.cs:1916 | if (fps != null && isPass == true) ▸ if (fps.Name == "spdDetail") ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ if (siMain.A… | GRID_LOCK | siDetail.LockColumn | (siDetail.GetColumnIndex(DefColumns.INCOTERMS), siDetail.ActiveSheet.ColumnCount - 1, true… | 그리드 편집 잠금/해제 |  |  |  |
| AC-3ac034ba | EditButton | SSP0015_ShipmentPSI.cs:1920 | if (fps != null && isPass == true) ▸ if (fps.Name == "spdDetail") ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ else of (siM… | GRID_LOCK | siDetail.LockColumn | (siDetail.GetColumnIndex(DefColumns.DIVISION_ID), siDetail.GetColumnIndex(DefColumns.FCST_… | 그리드 편집 잠금/해제 |  |  |  |
| AC-ec653096 | EditButton | SSP0015_ShipmentPSI.cs:1921 | if (fps != null && isPass == true) ▸ if (fps.Name == "spdDetail") ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ else of (siM… | GRID_LOCK | siDetail.LockColumn | (siDetail.GetColumnIndex(DefColumns.INCOTERMS), siDetail.GetColumnIndex(DefColumns.TO_SITE… | 그리드 편집 잠금/해제 |  |  |  |
| AC-6d6c8bcb | EditButton | SSP0015_ShipmentPSI.cs:1922 | if (fps != null && isPass == true) ▸ if (fps.Name == "spdDetail") ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ else of (siM… | GRID_LOCK | siDetail.LockColumn | (siDetail.GetColumnIndex(DefColumns.REQUESTOR), siDetail.ActiveSheet.ColumnCount - 1, true… | 그리드 편집 잠금/해제 |  |  |  |
| AC-059d358e | EditButton | SSP0015_ShipmentPSI.cs:1934 | if (fps != null && isPass == true) ▸ if (fps.Name == "spdDetail") ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ for (i < siD… | GRID_LOCK | siDetail.LockRange | (i, siDetail.GetColumnIndex(DefColumns.SHIPMENT_CONFIRM_QTY), i, siDetail.GetColumnIndex(D… | 그리드 편집 잠금/해제 |  |  |  |
| AC-d4d9abf7 | EditButton | SSP0015_ShipmentPSI.cs:1938 | if (fps != null && isPass == true) ▸ if (fps.Name == "spdDetail") ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ for (i < siD… | GRID_LOCK | siDetail.LockRange | (i, 0, i, siDetail.GetMaxColumnIndex(), true, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-bfe96d4b | EditButton | SSP0015_ShipmentPSI.cs:1958 | if (fps != null && isPass == true) ▸ if (fps.Name == "spdDetail") ▸ else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ if (siD… | GRID_LOCK | siDetail.LockRange | (iRow, siDetail.GetColumnIndex(DefColumns.DIVISION_ID), iRow, siDetail.GetColumnIndex(DefC… | 그리드 편집 잠금/해제 |  |  |  |
| AC-0341b8e5 | EditButton | SSP0015_ShipmentPSI.cs:1962 | if (fps != null && isPass == true) ▸ if (fps.Name == "spdDetail") ▸ else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ if (siD… | GRID_LOCK | siDetail.LockRange | (iRow, siDetail.GetColumnIndex(DefColumns.DIVISION_ID), iRow, siDetail.GetColumnIndex(DefC… | 그리드 편집 잠금/해제 |  |  |  |
| AC-cbf88c1e | EditButton | SSP0015_ShipmentPSI.cs:1963 | if (fps != null && isPass == true) ▸ if (fps.Name == "spdDetail") ▸ else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ if (siD… | GRID_LOCK | siDetail.LockRange | (iRow, siDetail.GetColumnIndex(DefColumns.AVAILABLE_YN), iRow, siDetail.GetColumnIndex(Def… | 그리드 편집 잠금/해제 |  |  |  |
| AC-1444b5b7 | EditButton | SSP0015_ShipmentPSI.cs:1964 | if (fps != null && isPass == true) ▸ if (fps.Name == "spdDetail") ▸ else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ if (siD… | GRID_LOCK | siDetail.LockRange | (iRow, siDetail.GetColumnIndex(DefColumns.JUDG_VLD_DATE), iRow, siDetail.GetColumnIndex(De… | 그리드 편집 잠금/해제 |  |  |  |
| AC-e47688c3 | EditButton | SSP0015_ShipmentPSI.cs:1986 | if (fps != null && isPass == true) | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## SSP0015_ShipmentPSI.EngProcessingChk

진입점: SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.ActiveSheetIndex == 0) ▸ if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6dab604e | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:7903 | try | ENDPOINT | new FoxDataRequest | ("SSP.SSP0003_GET_SSP_PLAN_PROCESSING_CHECK") ⇒ SSP.SSP0003_GET_SSP_PLAN_PROCESSING_CHECK | 엔드포인트 요청 생성 |  |  |  |
| AC-24448c2f | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:7904 | try | DATA_OP | request.Parameters["p_division_id"] | pDivisionID | 행/컬럼 값 대입 |  |  |  |
| AC-a8d7b1d8 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:7906 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-1f944f4e | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:7916 | try ▸ if (ds.Tables[0].Rows[0][0].ToString() == "Y") | MESSAGE | MessageHelper.GMessageBox | ("MSG00291", new object[] { remainMinute }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-36363bf0 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:7926 | catch ((Exception ex)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-05d5c90d | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:7928 |  | RETURN | return bReturn; |  | 처리 중단/반환 |  |  |  |

## SSP0015_ShipmentPSI.FindButton

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4cec5b51 | FindButton | SSP0015_ShipmentPSI.cs:1707 |  | FLAG | bDetail_Search | false | 화면 필드/플래그 변경 |  |  |  |

## SSP0015_ShipmentPSI.FindData_block_stock

진입점: this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex == 0) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.FIGURE) && sMeasure == "MES_FCS_RELEASE")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-313aac28 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… | SSP0015_ShipmentPSI.cs:4036 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-216b55bc | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… | SSP0015_ShipmentPSI.cs:4042 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-c08af4a4 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… | SSP0015_ShipmentPSI.cs:4065 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-a77d8ff8 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… | SSP0015_ShipmentPSI.cs:4070 | try | ENDPOINT | new FoxDataRequest | ("SSP.SSP0015_GET_BLOCK_STOCK") ⇒ SSP.SSP0015_GET_BLOCK_STOCK | 엔드포인트 요청 생성 |  |  |  |
| AC-1a8924fb | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… | SSP0015_ShipmentPSI.cs:4071 | try | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-c619a112 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… | SSP0015_ShipmentPSI.cs:4073 | try | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-842c7925 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… | SSP0015_ShipmentPSI.cs:4074 | try | DATA_OP | request.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-17cf8e9f | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… | SSP0015_ShipmentPSI.cs:4075 | try | DATA_OP | request.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-8d51eac5 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… | SSP0015_ShipmentPSI.cs:4076 | try | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-3fcb5df3 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… | SSP0015_ShipmentPSI.cs:4077 | try | DATA_OP | request.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-fedf340d | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… | SSP0015_ShipmentPSI.cs:4078 | try | DATA_OP | request.Parameters["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-705c6bfc | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… | SSP0015_ShipmentPSI.cs:4079 | try | DATA_OP | request.Parameters["p_language"] | sLanguage | 행/컬럼 값 대입 |  |  |  |
| AC-6d66a576 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… | SSP0015_ShipmentPSI.cs:4080 | try | DATA_OP | request.Parameters["p_search_yn"] | p_search_yn | 행/컬럼 값 대입 |  |  |  |
| AC-1dc9d831 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… | SSP0015_ShipmentPSI.cs:4081 | try | DATA_OP | request.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-75ac69c6 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… | SSP0015_ShipmentPSI.cs:4082 | try | DATA_OP | request.Parameters["p_myModelChk"] | p_myModelChk | 행/컬럼 값 대입 |  |  |  |
| AC-b14b72a1 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… | SSP0015_ShipmentPSI.cs:4083 | try | DATA_OP | request.Parameters["p_partLeaderChk"] | p_partLeaderChk | 행/컬럼 값 대입 |  |  |  |
| AC-38cc565d | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… | SSP0015_ShipmentPSI.cs:4084 | try | DATA_OP | request.Parameters["p_teamLeaderChk"] | p_teamLeaderChk | 행/컬럼 값 대입 |  |  |  |
| AC-edf286cb | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… | SSP0015_ShipmentPSI.cs:4085 | try | DATA_OP | request.Parameters["p_delegateeChk"] | p_delegateeChk | 행/컬럼 값 대입 |  |  |  |
| AC-b805f695 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… | SSP0015_ShipmentPSI.cs:4086 | try | DATA_OP | request.Parameters["p_nonChk"] | p_nonChk | 행/컬럼 값 대입 |  |  |  |
| AC-0856ef52 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… | SSP0015_ShipmentPSI.cs:4088 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-49a8aed3 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… | SSP0015_ShipmentPSI.cs:4097 | try | GRID_BIND | siDetail.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-5fb3ad56 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… | SSP0015_ShipmentPSI.cs:4098 | try | GRID_LOCK | siDetail.LockColumn | (0, siDetail.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-eec70e04 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… | SSP0015_ShipmentPSI.cs:4101 | try | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtBolckStockDetail) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7ad7f1e2 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… | SSP0015_ShipmentPSI.cs:4102 | try | GRID_INIT | siDetail.ChangeActiveSheet | (SpdSheet.shtBolckStockDetail) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-94b2ff47 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… | SSP0015_ShipmentPSI.cs:4111 | try ▸ if (ds.Tables[1].Rows.Count > 0) | DATA_OP | ds.Tables[1].Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-72e2477c | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… | SSP0015_ShipmentPSI.cs:4113 | try ▸ if (ds.Tables[1].Rows.Count > 0) | DATA_OP | dsDetail.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-5e84a099 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… | SSP0015_ShipmentPSI.cs:4115 | try ▸ if (ds.Tables[1].Rows.Count > 0) | GRID_BIND | siDetail.Query | (dsDetail) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-10aefb81 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… | SSP0015_ShipmentPSI.cs:4116 | try ▸ if (ds.Tables[1].Rows.Count > 0) | GRID_LOCK | siDetail.LockColumn | (0, siDetail.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-793a5613 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… | SSP0015_ShipmentPSI.cs:4119 | try | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtBolckStock) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1e01ad15 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… | SSP0015_ShipmentPSI.cs:4120 | try | GRID_INIT | siDetail.ChangeActiveSheet | (SpdSheet.shtBolckStock) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-bde85884 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… | SSP0015_ShipmentPSI.cs:4124 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-b0bb3763 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… | SSP0015_ShipmentPSI.cs:4134 | try | GRID_STYLE | siMain.ActiveSheet.SetActiveCell | (iSelRow, iSelCol) | 그리드 표시 설정 |  |  |  |
| AC-114805d2 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… | SSP0015_ShipmentPSI.cs:4139 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SSP0015_ShipmentPSI.FindData_BolckStockDetail_btnSearch

진입점: this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtRequestDetail) ▸ else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtWHstock \|\| siDetail.ActiveSheet.SheetName == SpdSheet.shtWHstockDetail) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtBolckStockDetail)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-604ce9ac | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0015_ShipmentPSI.cs:4146 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-3e75e12e | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0015_ShipmentPSI.cs:4152 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-e68b08ea | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0015_ShipmentPSI.cs:4188 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-1de2e9d9 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0015_ShipmentPSI.cs:4193 | try | ENDPOINT | new FoxDataRequest | ("SSP.SSP0015_GET_BLOCK_STOCK") ⇒ SSP.SSP0015_GET_BLOCK_STOCK | 엔드포인트 요청 생성 |  |  |  |
| AC-1b993298 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0015_ShipmentPSI.cs:4194 | try | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-58c15238 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0015_ShipmentPSI.cs:4196 | try | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-5a4c7ba4 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0015_ShipmentPSI.cs:4197 | try | DATA_OP | request.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-8dc932c8 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0015_ShipmentPSI.cs:4198 | try | DATA_OP | request.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-c969e69f | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0015_ShipmentPSI.cs:4199 | try | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-09e414bf | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0015_ShipmentPSI.cs:4200 | try | DATA_OP | request.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-40f5a885 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0015_ShipmentPSI.cs:4201 | try | DATA_OP | request.Parameters["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-d28cd5dc | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0015_ShipmentPSI.cs:4202 | try | DATA_OP | request.Parameters["p_language"] | sLanguage | 행/컬럼 값 대입 |  |  |  |
| AC-8da7bd9e | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0015_ShipmentPSI.cs:4203 | try | DATA_OP | request.Parameters["p_search_yn"] | p_search_yn | 행/컬럼 값 대입 |  |  |  |
| AC-aca84553 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0015_ShipmentPSI.cs:4204 | try | DATA_OP | request.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-e022e743 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0015_ShipmentPSI.cs:4205 | try | DATA_OP | request.Parameters["p_myModelChk"] | p_myModelChk | 행/컬럼 값 대입 |  |  |  |
| AC-b9872fda | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0015_ShipmentPSI.cs:4206 | try | DATA_OP | request.Parameters["p_partLeaderChk"] | p_partLeaderChk | 행/컬럼 값 대입 |  |  |  |
| AC-627fc735 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0015_ShipmentPSI.cs:4207 | try | DATA_OP | request.Parameters["p_teamLeaderChk"] | p_teamLeaderChk | 행/컬럼 값 대입 |  |  |  |
| AC-548cc4de | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0015_ShipmentPSI.cs:4208 | try | DATA_OP | request.Parameters["p_delegateeChk"] | p_delegateeChk | 행/컬럼 값 대입 |  |  |  |
| AC-d0d85b12 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0015_ShipmentPSI.cs:4209 | try | DATA_OP | request.Parameters["p_nonChk"] | p_nonChk | 행/컬럼 값 대입 |  |  |  |
| AC-4459a7b0 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0015_ShipmentPSI.cs:4211 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-ea2c06c2 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0015_ShipmentPSI.cs:4220 | try | GRID_BIND | siDetail.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-0f67ebbe | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0015_ShipmentPSI.cs:4221 | try | GRID_LOCK | siDetail.LockColumn | (0, siDetail.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-a8edfa22 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0015_ShipmentPSI.cs:4223 | try | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtBolckStockDetail) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-32ec5091 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0015_ShipmentPSI.cs:4224 | try | GRID_INIT | siDetail.ChangeActiveSheet | (SpdSheet.shtBolckStockDetail) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-fb2f70c6 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0015_ShipmentPSI.cs:4233 | try ▸ if (ds.Tables[1].Rows.Count > 0) | DATA_OP | ds.Tables[1].Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-494f1807 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0015_ShipmentPSI.cs:4235 | try ▸ if (ds.Tables[1].Rows.Count > 0) | DATA_OP | dsDetail.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-bcdbdd9e | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0015_ShipmentPSI.cs:4237 | try ▸ if (ds.Tables[1].Rows.Count > 0) | GRID_BIND | siDetail.Query | (dsDetail) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-d7cb41c3 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0015_ShipmentPSI.cs:4238 | try ▸ if (ds.Tables[1].Rows.Count > 0) | GRID_LOCK | siDetail.LockColumn | (0, siDetail.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-442e5134 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0015_ShipmentPSI.cs:4242 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-0bea902c | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0015_ShipmentPSI.cs:4252 | try | GRID_STYLE | siMain.ActiveSheet.SetActiveCell | (iSelRow, iSelCol) | 그리드 표시 설정 |  |  |  |
| AC-7850fd97 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0015_ShipmentPSI.cs:4258 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SSP0015_ShipmentPSI.FindData_Detail

진입점: this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex == 0) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) ▸ if (sMeasure == "SHIP_CONFIRM")] / SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.ActiveSheetIndex == 0) ▸ if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlockYn()) ▸ try ▸ if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "S") ▸ else of (bDetail_Search == true)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8449a108 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0015_ShipmentPSI.cs:3098 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-a21acc97 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0015_ShipmentPSI.cs:3108 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-cc0ee337 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0015_ShipmentPSI.cs:3131 | try | DATA_OP | dtNewPlanDate.Compute | ("Max(code)", null) | 데이터 객체 조작/조회 |  |  |  |
| AC-aa0a5fd6 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0015_ShipmentPSI.cs:3160 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-6b73586c | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0015_ShipmentPSI.cs:3165 | try | ENDPOINT | new FoxDataRequest | ("SSP.SSP0015_GET_SHIPMENT_CONFIRM_DETAIL") ⇒ SSP.SSP0015_GET_SHIPMENT_CONFIRM_DETAIL | 엔드포인트 요청 생성 |  |  |  |
| AC-a02515bd | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0015_ShipmentPSI.cs:3166 | try | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-a51ffb01 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0015_ShipmentPSI.cs:3168 | try | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-490e80c1 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0015_ShipmentPSI.cs:3169 | try | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-038200aa | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0015_ShipmentPSI.cs:3170 | try | DATA_OP | request.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-e10297c0 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0015_ShipmentPSI.cs:3171 | try | DATA_OP | request.Parameters["p_plan_start_yyyymmdd"] | CString.GetCheckedListValue(dtPlanDate, cboPlanDate.ControlValues, true) | 행/컬럼 값 대입 |  |  |  |
| AC-0034f2f8 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0015_ShipmentPSI.cs:3172 | try | DATA_OP | request.Parameters["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-80c65b90 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0015_ShipmentPSI.cs:3173 | try | DATA_OP | request.Parameters["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-00764219 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0015_ShipmentPSI.cs:3174 | try | DATA_OP | request.Parameters["p_language"] | sLanguage | 행/컬럼 값 대입 |  |  |  |
| AC-a2917951 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0015_ShipmentPSI.cs:3175 | try | DATA_OP | request.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-103746b5 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0015_ShipmentPSI.cs:3176 | try | DATA_OP | request.Parameters["p_myModelChk"] | p_myModelChk | 행/컬럼 값 대입 |  |  |  |
| AC-65c414f7 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0015_ShipmentPSI.cs:3177 | try | DATA_OP | request.Parameters["p_requestor"] | p_requestor | 행/컬럼 값 대입 |  |  |  |
| AC-50e75afe | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0015_ShipmentPSI.cs:3178 | try | DATA_OP | request.Parameters["p_partLeaderChk"] | p_partLeaderChk | 행/컬럼 값 대입 |  |  |  |
| AC-84928e35 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0015_ShipmentPSI.cs:3179 | try | DATA_OP | request.Parameters["p_teamLeaderChk"] | p_teamLeaderChk | 행/컬럼 값 대입 |  |  |  |
| AC-58b7104e | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0015_ShipmentPSI.cs:3180 | try | DATA_OP | request.Parameters["p_delegateeChk"] | p_delegateeChk | 행/컬럼 값 대입 |  |  |  |
| AC-d28b04ce | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0015_ShipmentPSI.cs:3181 | try | DATA_OP | request.Parameters["p_search_yn"] | p_search_yn | 행/컬럼 값 대입 |  |  |  |
| AC-c9121786 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0015_ShipmentPSI.cs:3182 | try | DATA_OP | request.Parameters["p_nonChk"] | p_nonChk | 행/컬럼 값 대입 |  |  |  |
| AC-bc844f91 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0015_ShipmentPSI.cs:3183 | try | DATA_OP | request.Parameters["p_real_flag"] | p_real_flag | 행/컬럼 값 대입 |  |  |  |
| AC-2cfcaeb4 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0015_ShipmentPSI.cs:3184 | try | DATA_OP | request.Parameters["debug_mode"] | "T" | 행/컬럼 값 대입 |  |  |  |
| AC-9f147a6f | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0015_ShipmentPSI.cs:3186 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-f61183d7 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0015_ShipmentPSI.cs:3195 | try | GRID_BIND | siDetail.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-03eeecbb | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0015_ShipmentPSI.cs:3196 | try | GRID_LOCK | siDetail.LockColumn | (0, siDetail.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-18aaea63 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0015_ShipmentPSI.cs:3201 | try ▸ if (DefaultMainDS != null) | STATE_RESET | DefaultMainDS.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-47a87033 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0015_ShipmentPSI.cs:3203 | try | FLAG | DefaultMainDS | ds.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-d11dfb60 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0015_ShipmentPSI.cs:3203 | try | DATA_OP | ds.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-ba3b9312 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0015_ShipmentPSI.cs:3206 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-bd06d273 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0015_ShipmentPSI.cs:3218 | try | GRID_SET | sv.Columns[62].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-0519a2cb | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0015_ShipmentPSI.cs:3219 | try | GRID_SET | sv.Columns[63].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-590f3b79 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0015_ShipmentPSI.cs:3220 | try | GRID_SET | sv.Columns[64].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-4c0c8341 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0015_ShipmentPSI.cs:3221 | try | GRID_SET | sv.Columns[65].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-5a695e90 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0015_ShipmentPSI.cs:3223 | try | GRID_STYLE | siMain.ActiveSheet.SetActiveCell | (iSelRow, iSelCol) | 그리드 표시 설정 |  |  |  |
| AC-2efceb3e | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0015_ShipmentPSI.cs:3228 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-e327770b | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0015_ShipmentPSI.cs:3236 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-7697fbcb | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0015_ShipmentPSI.cs:3246 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-2ed248a3 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0015_ShipmentPSI.cs:3269 | try | DATA_OP | dtNewPlanDate.Compute | ("Max(code)", null) | 데이터 객체 조작/조회 |  |  |  |
| AC-13f6da85 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0015_ShipmentPSI.cs:3298 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-6e09e1df | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0015_ShipmentPSI.cs:3303 | try | ENDPOINT | new FoxDataRequest | ("SSP.SSP0015_GET_SHIPMENT_CONFIRM_DETAIL") ⇒ SSP.SSP0015_GET_SHIPMENT_CONFIRM_DETAIL | 엔드포인트 요청 생성 |  |  |  |
| AC-19b1fe3a | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0015_ShipmentPSI.cs:3304 | try | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-09db7d91 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0015_ShipmentPSI.cs:3306 | try | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-95425c2a | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0015_ShipmentPSI.cs:3307 | try | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-718ec2a8 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0015_ShipmentPSI.cs:3308 | try | DATA_OP | request.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-7d7c9153 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0015_ShipmentPSI.cs:3309 | try | DATA_OP | request.Parameters["p_plan_start_yyyymmdd"] | CString.GetCheckedListValue(dtPlanDate, cboPlanDate.ControlValues, true) | 행/컬럼 값 대입 |  |  |  |
| AC-9a92e0e0 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0015_ShipmentPSI.cs:3310 | try | DATA_OP | request.Parameters["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-465614d6 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0015_ShipmentPSI.cs:3311 | try | DATA_OP | request.Parameters["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-a615ef71 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0015_ShipmentPSI.cs:3312 | try | DATA_OP | request.Parameters["p_language"] | sLanguage | 행/컬럼 값 대입 |  |  |  |
| AC-2572c41f | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0015_ShipmentPSI.cs:3313 | try | DATA_OP | request.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-e030f425 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0015_ShipmentPSI.cs:3314 | try | DATA_OP | request.Parameters["p_myModelChk"] | p_myModelChk | 행/컬럼 값 대입 |  |  |  |
| AC-2713b3aa | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0015_ShipmentPSI.cs:3315 | try | DATA_OP | request.Parameters["p_requestor"] | p_requestor | 행/컬럼 값 대입 |  |  |  |
| AC-c57f61be | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0015_ShipmentPSI.cs:3316 | try | DATA_OP | request.Parameters["p_partLeaderChk"] | p_partLeaderChk | 행/컬럼 값 대입 |  |  |  |
| AC-efb08701 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0015_ShipmentPSI.cs:3317 | try | DATA_OP | request.Parameters["p_teamLeaderChk"] | p_teamLeaderChk | 행/컬럼 값 대입 |  |  |  |
| AC-a5e6fafd | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0015_ShipmentPSI.cs:3318 | try | DATA_OP | request.Parameters["p_delegateeChk"] | p_delegateeChk | 행/컬럼 값 대입 |  |  |  |
| AC-4a00e09f | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0015_ShipmentPSI.cs:3319 | try | DATA_OP | request.Parameters["p_search_yn"] | p_search_yn | 행/컬럼 값 대입 |  |  |  |
| AC-f5de8f49 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0015_ShipmentPSI.cs:3320 | try | DATA_OP | request.Parameters["p_nonChk"] | p_nonChk | 행/컬럼 값 대입 |  |  |  |
| AC-cb1d1979 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0015_ShipmentPSI.cs:3321 | try | DATA_OP | request.Parameters["p_real_flag"] | p_real_flag | 행/컬럼 값 대입 |  |  |  |
| AC-9dd0ca99 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0015_ShipmentPSI.cs:3322 | try | DATA_OP | request.Parameters["debug_mode"] | "T" | 행/컬럼 값 대입 |  |  |  |
| AC-60cb5aaf | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0015_ShipmentPSI.cs:3324 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-f8a1d70d | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0015_ShipmentPSI.cs:3333 | try | GRID_BIND | siDetail.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-cfc4236d | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0015_ShipmentPSI.cs:3334 | try | GRID_LOCK | siDetail.LockColumn | (0, siDetail.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-1e48df8d | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0015_ShipmentPSI.cs:3339 | try ▸ if (DefaultMainDS != null) | STATE_RESET | DefaultMainDS.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-c11a4875 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0015_ShipmentPSI.cs:3341 | try | FLAG | DefaultMainDS | ds.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-adca872a | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0015_ShipmentPSI.cs:3341 | try | DATA_OP | ds.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-20e9caf7 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0015_ShipmentPSI.cs:3344 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-436ebf24 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0015_ShipmentPSI.cs:3356 | try | GRID_SET | sv.Columns[62].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-3bbfbeeb | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0015_ShipmentPSI.cs:3357 | try | GRID_SET | sv.Columns[63].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-3a7116a8 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0015_ShipmentPSI.cs:3358 | try | GRID_SET | sv.Columns[64].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-5a9dad89 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0015_ShipmentPSI.cs:3359 | try | GRID_SET | sv.Columns[65].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-e148b53a | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0015_ShipmentPSI.cs:3361 | try | GRID_STYLE | siMain.ActiveSheet.SetActiveCell | (iSelRow, iSelCol) | 그리드 표시 설정 |  |  |  |
| AC-28534d59 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0015_ShipmentPSI.cs:3366 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SSP0015_ShipmentPSI.FindData_Detail_btnSearch

진입점: this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ if (siMain.ActiveSheetIndex == 0)] / SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.ActiveSheetIndex == 0) ▸ if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlockYn()) ▸ try ▸ if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "S") ▸ if (bDetail_Search == true)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-29f148bd | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0015_ShipmentPSI.cs:3635 |  | VALIDATE | DateUtil.Check_PeriodDate | (drpPeriod2) | 프레임워크 검증 |  |  |  |
| AC-3d30195b | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0015_ShipmentPSI.cs:3635 | if (!DateUtil.Check_PeriodDate(drpPeriod2)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a0bf2f43 | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0015_ShipmentPSI.cs:3637 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-8e465802 | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0015_ShipmentPSI.cs:3643 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-19c497fb | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0015_ShipmentPSI.cs:3665 | try | DATA_OP | dtNewPlanDate.Compute | ("Max(code)", null) | 데이터 객체 조작/조회 |  |  |  |
| AC-3c0ac4e8 | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0015_ShipmentPSI.cs:3700 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-d3493299 | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0015_ShipmentPSI.cs:3705 | try | ENDPOINT | new FoxDataRequest | ("SSP.SSP0015_GET_SHIPMENT_CONFIRM_DETAIL") ⇒ SSP.SSP0015_GET_SHIPMENT_CONFIRM_DETAIL | 엔드포인트 요청 생성 |  |  |  |
| AC-9790dfe7 | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0015_ShipmentPSI.cs:3706 | try | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-4786833e | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0015_ShipmentPSI.cs:3708 | try | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-32fdaa2a | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0015_ShipmentPSI.cs:3709 | try | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-6d056475 | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0015_ShipmentPSI.cs:3710 | try | DATA_OP | request.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-c0499fc3 | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0015_ShipmentPSI.cs:3711 | try | DATA_OP | request.Parameters["p_plan_start_yyyymmdd"] | CString.GetCheckedListValue(dtPlanDate, cboPlanDate.ControlValues, true) | 행/컬럼 값 대입 |  |  |  |
| AC-0929f54d | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0015_ShipmentPSI.cs:3712 | try | DATA_OP | request.Parameters["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-19abe99e | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0015_ShipmentPSI.cs:3713 | try | DATA_OP | request.Parameters["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-6099f931 | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0015_ShipmentPSI.cs:3714 | try | DATA_OP | request.Parameters["p_language"] | sLanguage | 행/컬럼 값 대입 |  |  |  |
| AC-f107a9d5 | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0015_ShipmentPSI.cs:3715 | try | DATA_OP | request.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-33df05ed | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0015_ShipmentPSI.cs:3716 | try | DATA_OP | request.Parameters["p_myModelChk"] | p_myModelChk | 행/컬럼 값 대입 |  |  |  |
| AC-c2d13755 | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0015_ShipmentPSI.cs:3717 | try | DATA_OP | request.Parameters["p_requestor"] | p_requestor | 행/컬럼 값 대입 |  |  |  |
| AC-29ebdb94 | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0015_ShipmentPSI.cs:3718 | try | DATA_OP | request.Parameters["p_partLeaderChk"] | p_partLeaderChk | 행/컬럼 값 대입 |  |  |  |
| AC-0cc829b0 | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0015_ShipmentPSI.cs:3719 | try | DATA_OP | request.Parameters["p_teamLeaderChk"] | p_teamLeaderChk | 행/컬럼 값 대입 |  |  |  |
| AC-160d7f94 | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0015_ShipmentPSI.cs:3720 | try | DATA_OP | request.Parameters["p_delegateeChk"] | p_delegateeChk | 행/컬럼 값 대입 |  |  |  |
| AC-ea5d2cea | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0015_ShipmentPSI.cs:3721 | try | DATA_OP | request.Parameters["p_search_yn"] | p_search_yn | 행/컬럼 값 대입 |  |  |  |
| AC-200e652e | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0015_ShipmentPSI.cs:3722 | try | DATA_OP | request.Parameters["p_nonChk"] | p_nonChk | 행/컬럼 값 대입 |  |  |  |
| AC-bbea127f | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0015_ShipmentPSI.cs:3723 | try | DATA_OP | request.Parameters["p_real_flag"] | p_real_flag | 행/컬럼 값 대입 |  |  |  |
| AC-06164d8f | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0015_ShipmentPSI.cs:3724 | try | DATA_OP | request.Parameters["debug_mode"] | "T" | 행/컬럼 값 대입 |  |  |  |
| AC-3334440c | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0015_ShipmentPSI.cs:3726 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-378f492b | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0015_ShipmentPSI.cs:3735 | try | GRID_BIND | siDetail.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-be11413f | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0015_ShipmentPSI.cs:3736 | try | GRID_LOCK | siDetail.LockColumn | (0, siDetail.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-586a47b4 | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0015_ShipmentPSI.cs:3741 | try ▸ if (DefaultMainDS != null) | STATE_RESET | DefaultMainDS.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-749a0f5b | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0015_ShipmentPSI.cs:3743 | try | FLAG | DefaultMainDS | ds.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-f9708723 | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0015_ShipmentPSI.cs:3743 | try | DATA_OP | ds.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-e23db604 | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0015_ShipmentPSI.cs:3746 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-c0c00c18 | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0015_ShipmentPSI.cs:3758 | try | GRID_SET | sv.Columns[62].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-e8b839b6 | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0015_ShipmentPSI.cs:3759 | try | GRID_SET | sv.Columns[63].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-9952341b | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0015_ShipmentPSI.cs:3760 | try | GRID_SET | sv.Columns[64].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-f2ee7f49 | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0015_ShipmentPSI.cs:3761 | try | GRID_SET | sv.Columns[65].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-75f2abcb | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0015_ShipmentPSI.cs:3763 | try | GRID_STYLE | siMain.ActiveSheet.SetActiveCell | (iSelRow, iSelCol) | 그리드 표시 설정 |  |  |  |
| AC-64cd5f72 | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0015_ShipmentPSI.cs:3768 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SSP0015_ShipmentPSI.FindData_Detail_Packer_btnSearch

진입점: this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ else of (siMain.ActiveSheetIndex == 0) ▸ if (siMain.ActiveSheetIndex == 1)] / SaveButton [else of (fps.Name == "spdMain") ▸ else of (siMain.ActiveSheetIndex == 0) ▸ if (siMain.ActiveSheetIndex == 1) ▸ if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlockYn()) ▸ try ▸ if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "S")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0583a8a7 | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0015_ShipmentPSI.cs:3372 |  | VALIDATE | DateUtil.Check_PeriodDate | (drpPeriod2) | 프레임워크 검증 |  |  |  |
| AC-d8cefe83 | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0015_ShipmentPSI.cs:3372 | if (!DateUtil.Check_PeriodDate(drpPeriod2)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a2f7d870 | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0015_ShipmentPSI.cs:3373 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-cbdaa1a2 | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0015_ShipmentPSI.cs:3383 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-d85365b6 | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0015_ShipmentPSI.cs:3401 | try | DATA_OP | dtNewPlanDate.Compute | ("Max(code)", null) | 데이터 객체 조작/조회 |  |  |  |
| AC-6b2da95c | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0015_ShipmentPSI.cs:3435 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-d175bc22 | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0015_ShipmentPSI.cs:3439 | try | ENDPOINT | new FoxDataRequest | ("SSP.SSP0015_GET_SHIPMENT_CONFIRM_DETAIL_PACKER") ⇒ SSP.SSP0015_GET_SHIPMENT_CONFIRM_DETAIL_PACKER | 엔드포인트 요청 생성 |  |  |  |
| AC-fac48a0e | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0015_ShipmentPSI.cs:3440 | try | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-d3ed584e | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0015_ShipmentPSI.cs:3442 | try | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-fe792bbb | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0015_ShipmentPSI.cs:3443 | try | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-8722572d | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0015_ShipmentPSI.cs:3444 | try | DATA_OP | request.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-9a93ced4 | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0015_ShipmentPSI.cs:3445 | try | DATA_OP | request.Parameters["p_plan_start_yyyymmdd"] | CString.GetCheckedListValue(dtPlanDate, cboPlanDate.ControlValues, true) | 행/컬럼 값 대입 |  |  |  |
| AC-d5f8d0fe | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0015_ShipmentPSI.cs:3446 | try | DATA_OP | request.Parameters["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-1567a381 | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0015_ShipmentPSI.cs:3447 | try | DATA_OP | request.Parameters["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-c321f225 | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0015_ShipmentPSI.cs:3448 | try | DATA_OP | request.Parameters["p_language"] | sLanguage | 행/컬럼 값 대입 |  |  |  |
| AC-4731661c | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0015_ShipmentPSI.cs:3449 | try | DATA_OP | request.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-53453e75 | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0015_ShipmentPSI.cs:3450 | try | DATA_OP | request.Parameters["p_myModelChk"] | p_myModelChk | 행/컬럼 값 대입 |  |  |  |
| AC-a506dfcc | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0015_ShipmentPSI.cs:3451 | try | DATA_OP | request.Parameters["p_requestor"] | p_requestor | 행/컬럼 값 대입 |  |  |  |
| AC-00adf9ff | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0015_ShipmentPSI.cs:3452 | try | DATA_OP | request.Parameters["p_partLeaderChk"] | p_partLeaderChk | 행/컬럼 값 대입 |  |  |  |
| AC-9a9b70b6 | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0015_ShipmentPSI.cs:3453 | try | DATA_OP | request.Parameters["p_teamLeaderChk"] | p_teamLeaderChk | 행/컬럼 값 대입 |  |  |  |
| AC-d225d2a0 | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0015_ShipmentPSI.cs:3454 | try | DATA_OP | request.Parameters["p_delegateeChk"] | p_delegateeChk | 행/컬럼 값 대입 |  |  |  |
| AC-6d5f0039 | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0015_ShipmentPSI.cs:3455 | try | DATA_OP | request.Parameters["p_search_yn"] | p_search_yn | 행/컬럼 값 대입 |  |  |  |
| AC-d7c248bc | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0015_ShipmentPSI.cs:3456 | try | DATA_OP | request.Parameters["p_nonChk"] | p_nonChk | 행/컬럼 값 대입 |  |  |  |
| AC-46ff71e5 | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0015_ShipmentPSI.cs:3457 | try | DATA_OP | request.Parameters["p_real_flag"] | p_real_flag | 행/컬럼 값 대입 |  |  |  |
| AC-070c7b64 | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0015_ShipmentPSI.cs:3458 | try | DATA_OP | request.Parameters["debug_mode"] | "T" | 행/컬럼 값 대입 |  |  |  |
| AC-24be80f8 | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0015_ShipmentPSI.cs:3460 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-ba96ecce | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0015_ShipmentPSI.cs:3469 | try | GRID_BIND | siDetail.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-12d4ef7d | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0015_ShipmentPSI.cs:3470 | try | GRID_LOCK | siDetail.LockColumn | (0, siDetail.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-c5caf12c | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0015_ShipmentPSI.cs:3475 | try ▸ if (DefaultMainDS != null) | STATE_RESET | DefaultMainDS.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-24c68543 | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0015_ShipmentPSI.cs:3477 | try | FLAG | DefaultMainDS | ds.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-050e44ed | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0015_ShipmentPSI.cs:3477 | try | DATA_OP | ds.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-6fda62de | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0015_ShipmentPSI.cs:3480 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-3d5f2de1 | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0015_ShipmentPSI.cs:3491 | try | GRID_SET | sv.Columns[15].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-df740bde | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0015_ShipmentPSI.cs:3492 | try | GRID_SET | sv.Columns[60].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-68fb9cae | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0015_ShipmentPSI.cs:3493 | try | GRID_SET | sv.Columns[61].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-db9e9fee | this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == … 외 1 | SSP0015_ShipmentPSI.cs:3504 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SSP0015_ShipmentPSI.FindData_Main

진입점: this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex == 0) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) ▸ if (sMeasure == "WH_IN") ▸ if (Comments != null) ▸ if (ssp0015Popup.DialogResult == DialogResult.OK)] / FindButton [if (siMain.ActiveSheetIndex == 0)] / SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.Tables[0].Rows[0][0].ToString() == "S")] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-012bf1c2 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0015_ShipmentPSI.cs:2475 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-db21a083 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0015_ShipmentPSI.cs:2480 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-ad2ee2b2 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0015_ShipmentPSI.cs:2480 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-35e9f3c3 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0015_ShipmentPSI.cs:2483 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-ea669078 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0015_ShipmentPSI.cs:2484 | try | VALIDATE | DateUtil.Check_PeriodDate | (drpPeriod) | 프레임워크 검증 |  |  |  |
| AC-598fd862 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0015_ShipmentPSI.cs:2484 | try ▸ if (!DateUtil.Check_PeriodDate(drpPeriod)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5dde92fb | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0015_ShipmentPSI.cs:2531 | try | UI_PROP | proxyPivot.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-6b45487d | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0015_ShipmentPSI.cs:2532 | try | ENDPOINT | proxyPivot.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SSP.Plan.WSL/FoxDataService.s… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-543ee061 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0015_ShipmentPSI.cs:2536 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SSP.SSP0015_GET_SHIPMENT_PSI") ⇒ SSP.SSP0015_GET_SHIPMENT_PSI | 엔드포인트 요청 생성 |  |  |  |
| AC-972a9d8b | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0015_ShipmentPSI.cs:2538 | try ▸ lambda | UI_PROP | req.CommandTimeout | 2 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-ac59ae9c | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0015_ShipmentPSI.cs:2540 | try ▸ lambda | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-44a86c94 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0015_ShipmentPSI.cs:2541 | try ▸ lambda | DATA_OP | req.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-de7e6c4d | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0015_ShipmentPSI.cs:2542 | try ▸ lambda | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-e4efd730 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0015_ShipmentPSI.cs:2543 | try ▸ lambda | DATA_OP | req.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-e8e467f5 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0015_ShipmentPSI.cs:2544 | try ▸ lambda | DATA_OP | req.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-b3b3e16d | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0015_ShipmentPSI.cs:2545 | try ▸ lambda | DATA_OP | req.Parameters["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-8b16bba8 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0015_ShipmentPSI.cs:2546 | try ▸ lambda | DATA_OP | req.Parameters["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-0cf550cb | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0015_ShipmentPSI.cs:2547 | try ▸ lambda | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-b2224d87 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0015_ShipmentPSI.cs:2548 | try ▸ lambda | DATA_OP | req.Parameters["p_program_id"] | p_program_id | 행/컬럼 값 대입 |  |  |  |
| AC-52b0a700 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0015_ShipmentPSI.cs:2549 | try ▸ lambda | DATA_OP | req.Parameters["p_sheet_name"] | p_sheet_name | 행/컬럼 값 대입 |  |  |  |
| AC-8022f7cc | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0015_ShipmentPSI.cs:2550 | try ▸ lambda | DATA_OP | req.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-3be6ee4e | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0015_ShipmentPSI.cs:2551 | try ▸ lambda | DATA_OP | req.Parameters["p_language"] | p_language | 행/컬럼 값 대입 |  |  |  |
| AC-4d3eb920 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0015_ShipmentPSI.cs:2552 | try ▸ lambda | DATA_OP | req.Parameters["p_myModelChk"] | p_myModelChk | 행/컬럼 값 대입 |  |  |  |
| AC-6c7bf612 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0015_ShipmentPSI.cs:2553 | try ▸ lambda | DATA_OP | req.Parameters["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-bbc2032e | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0015_ShipmentPSI.cs:2554 | try ▸ lambda | DATA_OP | req.Parameters["p_partLeaderChk"] | p_partLeaderChk | 행/컬럼 값 대입 |  |  |  |
| AC-b5ea0360 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0015_ShipmentPSI.cs:2555 | try ▸ lambda | DATA_OP | req.Parameters["p_teamLeaderChk"] | p_teamLeaderChk | 행/컬럼 값 대입 |  |  |  |
| AC-4e224d57 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0015_ShipmentPSI.cs:2556 | try ▸ lambda | DATA_OP | req.Parameters["p_delegateeChk"] | p_delegateeChk | 행/컬럼 값 대입 |  |  |  |
| AC-bad32ec2 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0015_ShipmentPSI.cs:2557 | try ▸ lambda | DATA_OP | req.Parameters["p_nonChk"] | p_nonChk | 행/컬럼 값 대입 |  |  |  |
| AC-9892ed6a | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0015_ShipmentPSI.cs:2559 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-0a049607 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0015_ShipmentPSI.cs:2560 | try ▸ lambda | RETURN | return res.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-b2cc861e | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0015_ShipmentPSI.cs:2568 | try | FLAG | dtPlanNonZero | new DataTable() | 화면 필드/플래그 변경 |  |  |  |
| AC-94420750 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0015_ShipmentPSI.cs:2569 | try | FLAG | dtBalanceMinus | new DataTable() | 화면 필드/플래그 변경 |  |  |  |
| AC-8752307f | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0015_ShipmentPSI.cs:2571 | try | FLAG | dtPlanNonZero | dsBinding.Tables[0].Clone() | 화면 필드/플래그 변경 |  |  |  |
| AC-5e15a2d9 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0015_ShipmentPSI.cs:2571 | try | DATA_OP | dsBinding.Tables[0].Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-91a95746 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0015_ShipmentPSI.cs:2572 | try | FLAG | dtBalanceMinus | dsBinding.Tables[0].Clone() | 화면 필드/플래그 변경 |  |  |  |
| AC-57aa7ec0 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0015_ShipmentPSI.cs:2572 | try | DATA_OP | dsBinding.Tables[0].Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-a154469c | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0015_ShipmentPSI.cs:2574 | try | GRID_BIND | siMain.Query | (dsBinding) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-f72de7aa | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0015_ShipmentPSI.cs:2577 | try | FLAG | dtNote | new DataTable() | 화면 필드/플래그 변경 |  |  |  |
| AC-fe56ea5f | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0015_ShipmentPSI.cs:2578 | try | FLAG | dtNote | dsBinding.Tables[1].Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-3c080930 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0015_ShipmentPSI.cs:2578 | try | DATA_OP | dsBinding.Tables[1].Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-a3033e9d | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0015_ShipmentPSI.cs:2579 | try | FLAG | intNoteCnt | dtNote.Rows.Count | 화면 필드/플래그 변경 |  |  |  |
| AC-faa3ee1a | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0015_ShipmentPSI.cs:2583 | try | FLAG | dtPROD_Note | new DataTable() | 화면 필드/플래그 변경 |  |  |  |
| AC-fb88560a | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0015_ShipmentPSI.cs:2584 | try | FLAG | dtPROD_Note | dsBinding.Tables[2].Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-df05a0de | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0015_ShipmentPSI.cs:2584 | try | DATA_OP | dsBinding.Tables[2].Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-007d6602 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0015_ShipmentPSI.cs:2585 | try | FLAG | intProdNoteCNT | dtPROD_Note.Rows.Count | 화면 필드/플래그 변경 |  |  |  |
| AC-050b96a5 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0015_ShipmentPSI.cs:2589 | try | GRID_SET | spdMain.ActiveSheet.AllowNoteEdit | false | 그리드 속성/값 설정 |  |  |  |
| AC-339e478a | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0015_ShipmentPSI.cs:2590 | try | UI_PROP | spdMain.CellNoteIndicatorRenderer | new FarPoint.Win.Spread.TriangleNoteIndicatorRenderer() | 속성 CellNoteIndicatorRenderer 설정 |  |  |  |
| AC-22ecf5ac | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0015_ShipmentPSI.cs:2593 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-0522839a | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0015_ShipmentPSI.cs:2594 | try | UI_MISC | SetSearchCount | (dsBinding) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-a8c3860a | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0015_ShipmentPSI.cs:2652 | try ▸ if (dsBinding.Tables[0].Rows.Count > 0) | DATA_OP | dsBinding.Tables[0].DefaultView.ToTable | (true, "MEASURE") | 데이터 객체 조작/조회 |  |  |  |
| AC-f31961c9 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0015_ShipmentPSI.cs:2666 | try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ for (iRow < rowCount) ▸ if (!string.IsNullOrWhiteSpace(strLTupdateYN) && drPgmAuthId != null… | GRID_SET | spdMain.ActiveSheet.Cells[idx, siMain.GetColumnIndex(DefColumns.LT_DAY)].Note | strLTupdateYN | 그리드 속성/값 설정 |  |  |  |
| AC-8f089f28 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0015_ShipmentPSI.cs:2670 | try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ for (iRow < rowCount) ▸ if (!string.IsNullOrWhiteSpace(strLTupdateYN) && drPgmAuthId != null… | GRID_SET | spdMain.ActiveSheet.Cells[idx, siMain.GetColumnIndex(DefColumns.LT_DAY)].NoteIndicatorSize | new Size(0, 0) | 그리드 속성/값 설정 |  |  |  |
| AC-4a968abc | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0015_ShipmentPSI.cs:2673 | try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ for (iRow < rowCount) ▸ if (!string.IsNullOrWhiteSpace(strLTupdateYN) && drPgmAuthId != null… | GRID_SET | spdMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(DefColumns.LT_DAY)].NoteIndicatorSiz… | new Size(5, 5) | 그리드 속성/값 설정 |  |  |  |
| AC-73f9ed06 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0015_ShipmentPSI.cs:2728 | try ▸ for (iRow < rowCount) ▸ if (sMeasure == "PROD_DATE" \|\| sMeasure == "LOT" \|\| sMeasure == "WH_IN" \|\| sMeasure == "PROD_PLAN") ▸ fo… | GRID_INIT | siMain.SetCellTypeDateToText | (iRow, nCol) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-066c7cec | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0015_ShipmentPSI.cs:2732 | try ▸ for (iRow < rowCount) ▸ if (sMeasure == "PROD_DATE" \|\| sMeasure == "LOT" \|\| sMeasure == "WH_IN" \|\| sMeasure == "PROD_PLAN") ▸ fo… | GRID_INIT | siMain.SetCellTypeText | (iRow, nCol) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-7ee0a956 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0015_ShipmentPSI.cs:2733 | try ▸ for (iRow < rowCount) ▸ if (sMeasure == "PROD_DATE" \|\| sMeasure == "LOT" \|\| sMeasure == "WH_IN" \|\| sMeasure == "PROD_PLAN") ▸ fo… | GRID_SET | siMain.ActiveSheet.Cells[iRow, nCol].HorizontalAlignment | CellHorizontalAlignment.Center | 그리드 속성/값 설정 |  |  |  |
| AC-1c868e1e | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0015_ShipmentPSI.cs:2736 | try ▸ for (iRow < rowCount) ▸ if (sMeasure == "PROD_DATE" \|\| sMeasure == "LOT" \|\| sMeasure == "WH_IN" \|\| sMeasure == "PROD_PLAN") ▸ fo… | GRID_SET | siMain.SetValue | (iRow, nCol, "") | 그리드 값 설정 |  |  |  |
| AC-11ac690d | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0015_ShipmentPSI.cs:2762 | try | UI_PROP | spdMain.AutoClipboard | true | 속성 AutoClipboard 설정 |  |  |  |
| AC-bd2fcc5a | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0015_ShipmentPSI.cs:2785 | try | FLAG | intRNoteIdx | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-d265c1fd | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0015_ShipmentPSI.cs:2786 | try | FLAG | intCNoteIdx | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-181197ee | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0015_ShipmentPSI.cs:2793 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SSP0015_ShipmentPSI.FindData_Main_Packer

진입점: FindButton [else of (siMain.ActiveSheetIndex == 0) ▸ if (siMain.ActiveSheetIndex == 1) ▸ if (cboPlanDate.SelectedIndex == 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fe2b0ceb | FindButton [else of (siMain.ActiveSheetIndex == 0) ▸ if (siM… | SSP0015_ShipmentPSI.cs:2356 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-b0f68680 | FindButton [else of (siMain.ActiveSheetIndex == 0) ▸ if (siM… | SSP0015_ShipmentPSI.cs:2361 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-2fc50239 | FindButton [else of (siMain.ActiveSheetIndex == 0) ▸ if (siM… | SSP0015_ShipmentPSI.cs:2361 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e5b901be | FindButton [else of (siMain.ActiveSheetIndex == 0) ▸ if (siM… | SSP0015_ShipmentPSI.cs:2364 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-15ba95c9 | FindButton [else of (siMain.ActiveSheetIndex == 0) ▸ if (siM… | SSP0015_ShipmentPSI.cs:2365 | try | VALIDATE | DateUtil.Check_PeriodDate | (drpPeriod) | 프레임워크 검증 |  |  |  |
| AC-e04b9abf | FindButton [else of (siMain.ActiveSheetIndex == 0) ▸ if (siM… | SSP0015_ShipmentPSI.cs:2365 | try ▸ if (!DateUtil.Check_PeriodDate(drpPeriod)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-92c399fe | FindButton [else of (siMain.ActiveSheetIndex == 0) ▸ if (siM… | SSP0015_ShipmentPSI.cs:2407 | try | UI_PROP | proxyPivot.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-41f91414 | FindButton [else of (siMain.ActiveSheetIndex == 0) ▸ if (siM… | SSP0015_ShipmentPSI.cs:2408 | try | ENDPOINT | proxyPivot.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SSP.Plan.WSL/FoxDataService.s… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-707d34e4 | FindButton [else of (siMain.ActiveSheetIndex == 0) ▸ if (siM… | SSP0015_ShipmentPSI.cs:2412 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SSP.SSP0015_GET_SHIPMENT_PSI_PACKER") ⇒ SSP.SSP0015_GET_SHIPMENT_PSI_PACKER | 엔드포인트 요청 생성 |  |  |  |
| AC-09ac1fe8 | FindButton [else of (siMain.ActiveSheetIndex == 0) ▸ if (siM… | SSP0015_ShipmentPSI.cs:2414 | try ▸ lambda | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-0e0856f1 | FindButton [else of (siMain.ActiveSheetIndex == 0) ▸ if (siM… | SSP0015_ShipmentPSI.cs:2416 | try ▸ lambda | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-7ca96132 | FindButton [else of (siMain.ActiveSheetIndex == 0) ▸ if (siM… | SSP0015_ShipmentPSI.cs:2417 | try ▸ lambda | DATA_OP | req.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-4990a08a | FindButton [else of (siMain.ActiveSheetIndex == 0) ▸ if (siM… | SSP0015_ShipmentPSI.cs:2418 | try ▸ lambda | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-4dd68537 | FindButton [else of (siMain.ActiveSheetIndex == 0) ▸ if (siM… | SSP0015_ShipmentPSI.cs:2419 | try ▸ lambda | DATA_OP | req.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-5927a88d | FindButton [else of (siMain.ActiveSheetIndex == 0) ▸ if (siM… | SSP0015_ShipmentPSI.cs:2420 | try ▸ lambda | DATA_OP | req.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-e012ddab | FindButton [else of (siMain.ActiveSheetIndex == 0) ▸ if (siM… | SSP0015_ShipmentPSI.cs:2421 | try ▸ lambda | DATA_OP | req.Parameters["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-3ea45e4f | FindButton [else of (siMain.ActiveSheetIndex == 0) ▸ if (siM… | SSP0015_ShipmentPSI.cs:2422 | try ▸ lambda | DATA_OP | req.Parameters["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-f820fc55 | FindButton [else of (siMain.ActiveSheetIndex == 0) ▸ if (siM… | SSP0015_ShipmentPSI.cs:2423 | try ▸ lambda | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-a2903b26 | FindButton [else of (siMain.ActiveSheetIndex == 0) ▸ if (siM… | SSP0015_ShipmentPSI.cs:2424 | try ▸ lambda | DATA_OP | req.Parameters["p_program_id"] | p_program_id | 행/컬럼 값 대입 |  |  |  |
| AC-46d08243 | FindButton [else of (siMain.ActiveSheetIndex == 0) ▸ if (siM… | SSP0015_ShipmentPSI.cs:2425 | try ▸ lambda | DATA_OP | req.Parameters["p_sheet_name"] | p_sheet_name | 행/컬럼 값 대입 |  |  |  |
| AC-25f2af54 | FindButton [else of (siMain.ActiveSheetIndex == 0) ▸ if (siM… | SSP0015_ShipmentPSI.cs:2426 | try ▸ lambda | DATA_OP | req.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-22d3384d | FindButton [else of (siMain.ActiveSheetIndex == 0) ▸ if (siM… | SSP0015_ShipmentPSI.cs:2427 | try ▸ lambda | DATA_OP | req.Parameters["p_language"] | p_language | 행/컬럼 값 대입 |  |  |  |
| AC-07cf74c5 | FindButton [else of (siMain.ActiveSheetIndex == 0) ▸ if (siM… | SSP0015_ShipmentPSI.cs:2428 | try ▸ lambda | DATA_OP | req.Parameters["p_myModelChk"] | p_myModelChk | 행/컬럼 값 대입 |  |  |  |
| AC-4aeedb2c | FindButton [else of (siMain.ActiveSheetIndex == 0) ▸ if (siM… | SSP0015_ShipmentPSI.cs:2429 | try ▸ lambda | DATA_OP | req.Parameters["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-d573db4d | FindButton [else of (siMain.ActiveSheetIndex == 0) ▸ if (siM… | SSP0015_ShipmentPSI.cs:2430 | try ▸ lambda | DATA_OP | req.Parameters["p_partLeaderChk"] | p_partLeaderChk | 행/컬럼 값 대입 |  |  |  |
| AC-113578cb | FindButton [else of (siMain.ActiveSheetIndex == 0) ▸ if (siM… | SSP0015_ShipmentPSI.cs:2431 | try ▸ lambda | DATA_OP | req.Parameters["p_teamLeaderChk"] | p_teamLeaderChk | 행/컬럼 값 대입 |  |  |  |
| AC-cd4fefe8 | FindButton [else of (siMain.ActiveSheetIndex == 0) ▸ if (siM… | SSP0015_ShipmentPSI.cs:2432 | try ▸ lambda | DATA_OP | req.Parameters["p_delegateeChk"] | p_delegateeChk | 행/컬럼 값 대입 |  |  |  |
| AC-17a9656f | FindButton [else of (siMain.ActiveSheetIndex == 0) ▸ if (siM… | SSP0015_ShipmentPSI.cs:2433 | try ▸ lambda | DATA_OP | req.Parameters["p_nonChk"] | p_nonChk | 행/컬럼 값 대입 |  |  |  |
| AC-8a3ff27e | FindButton [else of (siMain.ActiveSheetIndex == 0) ▸ if (siM… | SSP0015_ShipmentPSI.cs:2435 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-d09aa353 | FindButton [else of (siMain.ActiveSheetIndex == 0) ▸ if (siM… | SSP0015_ShipmentPSI.cs:2436 | try ▸ lambda | RETURN | return res.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-cde84447 | FindButton [else of (siMain.ActiveSheetIndex == 0) ▸ if (siM… | SSP0015_ShipmentPSI.cs:2443 | try | GRID_BIND | siMain.Query | (dsBinding) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-7a0537ee | FindButton [else of (siMain.ActiveSheetIndex == 0) ▸ if (siM… | SSP0015_ShipmentPSI.cs:2445 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-ba1f1da9 | FindButton [else of (siMain.ActiveSheetIndex == 0) ▸ if (siM… | SSP0015_ShipmentPSI.cs:2446 | try | UI_MISC | SetSearchCount | (dsBinding) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-565a2c9a | FindButton [else of (siMain.ActiveSheetIndex == 0) ▸ if (siM… | SSP0015_ShipmentPSI.cs:2456 | try | UI_PROP | spdMain.AutoClipboard | true | 속성 AutoClipboard 설정 |  |  |  |
| AC-cb113afb | FindButton [else of (siMain.ActiveSheetIndex == 0) ▸ if (siM… | SSP0015_ShipmentPSI.cs:2463 | try | FLAG | intRNoteIdx | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-e4bee102 | FindButton [else of (siMain.ActiveSheetIndex == 0) ▸ if (siM… | SSP0015_ShipmentPSI.cs:2464 | try | FLAG | intCNoteIdx | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-8dbf9f2c | FindButton [else of (siMain.ActiveSheetIndex == 0) ▸ if (siM… | SSP0015_ShipmentPSI.cs:2470 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SSP0015_ShipmentPSI.FindData_Main_Packer_Past

진입점: FindButton [else of (siMain.ActiveSheetIndex == 0) ▸ if (siMain.ActiveSheetIndex == 1) ▸ else of (cboPlanDate.SelectedIndex == 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7ccf8595 | FindButton [else of (siMain.ActiveSheetIndex == 0) ▸ if (siM… | SSP0015_ShipmentPSI.cs:2237 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-338c1382 | FindButton [else of (siMain.ActiveSheetIndex == 0) ▸ if (siM… | SSP0015_ShipmentPSI.cs:2242 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-03d80722 | FindButton [else of (siMain.ActiveSheetIndex == 0) ▸ if (siM… | SSP0015_ShipmentPSI.cs:2242 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4e0fccf0 | FindButton [else of (siMain.ActiveSheetIndex == 0) ▸ if (siM… | SSP0015_ShipmentPSI.cs:2245 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-2662b728 | FindButton [else of (siMain.ActiveSheetIndex == 0) ▸ if (siM… | SSP0015_ShipmentPSI.cs:2246 | try | VALIDATE | DateUtil.Check_PeriodDate | (drpPeriod) | 프레임워크 검증 |  |  |  |
| AC-765e5ff8 | FindButton [else of (siMain.ActiveSheetIndex == 0) ▸ if (siM… | SSP0015_ShipmentPSI.cs:2246 | try ▸ if (!DateUtil.Check_PeriodDate(drpPeriod)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f34ba3d2 | FindButton [else of (siMain.ActiveSheetIndex == 0) ▸ if (siM… | SSP0015_ShipmentPSI.cs:2288 | try | UI_PROP | proxyPivot.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-3982a109 | FindButton [else of (siMain.ActiveSheetIndex == 0) ▸ if (siM… | SSP0015_ShipmentPSI.cs:2289 | try | ENDPOINT | proxyPivot.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SSP.Plan.WSL/FoxDataService.s… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-679ba748 | FindButton [else of (siMain.ActiveSheetIndex == 0) ▸ if (siM… | SSP0015_ShipmentPSI.cs:2293 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SSP.SSP0015_GET_SHIPMENT_PSI_PACKER_PAST") ⇒ SSP.SSP0015_GET_SHIPMENT_PSI_PACKER_PAST | 엔드포인트 요청 생성 |  |  |  |
| AC-8527ec84 | FindButton [else of (siMain.ActiveSheetIndex == 0) ▸ if (siM… | SSP0015_ShipmentPSI.cs:2295 | try ▸ lambda | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-b9d7ccd9 | FindButton [else of (siMain.ActiveSheetIndex == 0) ▸ if (siM… | SSP0015_ShipmentPSI.cs:2297 | try ▸ lambda | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-ea0b8d4b | FindButton [else of (siMain.ActiveSheetIndex == 0) ▸ if (siM… | SSP0015_ShipmentPSI.cs:2298 | try ▸ lambda | DATA_OP | req.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-1cb4636b | FindButton [else of (siMain.ActiveSheetIndex == 0) ▸ if (siM… | SSP0015_ShipmentPSI.cs:2299 | try ▸ lambda | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-5e778898 | FindButton [else of (siMain.ActiveSheetIndex == 0) ▸ if (siM… | SSP0015_ShipmentPSI.cs:2300 | try ▸ lambda | DATA_OP | req.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-f744b424 | FindButton [else of (siMain.ActiveSheetIndex == 0) ▸ if (siM… | SSP0015_ShipmentPSI.cs:2301 | try ▸ lambda | DATA_OP | req.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-bad846ba | FindButton [else of (siMain.ActiveSheetIndex == 0) ▸ if (siM… | SSP0015_ShipmentPSI.cs:2302 | try ▸ lambda | DATA_OP | req.Parameters["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-afa3b400 | FindButton [else of (siMain.ActiveSheetIndex == 0) ▸ if (siM… | SSP0015_ShipmentPSI.cs:2303 | try ▸ lambda | DATA_OP | req.Parameters["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-b4953581 | FindButton [else of (siMain.ActiveSheetIndex == 0) ▸ if (siM… | SSP0015_ShipmentPSI.cs:2304 | try ▸ lambda | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-523a6ed6 | FindButton [else of (siMain.ActiveSheetIndex == 0) ▸ if (siM… | SSP0015_ShipmentPSI.cs:2305 | try ▸ lambda | DATA_OP | req.Parameters["p_program_id"] | p_program_id | 행/컬럼 값 대입 |  |  |  |
| AC-85558d79 | FindButton [else of (siMain.ActiveSheetIndex == 0) ▸ if (siM… | SSP0015_ShipmentPSI.cs:2306 | try ▸ lambda | DATA_OP | req.Parameters["p_sheet_name"] | p_sheet_name | 행/컬럼 값 대입 |  |  |  |
| AC-6fa3497c | FindButton [else of (siMain.ActiveSheetIndex == 0) ▸ if (siM… | SSP0015_ShipmentPSI.cs:2307 | try ▸ lambda | DATA_OP | req.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-daddc0c6 | FindButton [else of (siMain.ActiveSheetIndex == 0) ▸ if (siM… | SSP0015_ShipmentPSI.cs:2308 | try ▸ lambda | DATA_OP | req.Parameters["p_language"] | p_language | 행/컬럼 값 대입 |  |  |  |
| AC-fd4e0baa | FindButton [else of (siMain.ActiveSheetIndex == 0) ▸ if (siM… | SSP0015_ShipmentPSI.cs:2309 | try ▸ lambda | DATA_OP | req.Parameters["p_myModelChk"] | p_myModelChk | 행/컬럼 값 대입 |  |  |  |
| AC-3222a8da | FindButton [else of (siMain.ActiveSheetIndex == 0) ▸ if (siM… | SSP0015_ShipmentPSI.cs:2310 | try ▸ lambda | DATA_OP | req.Parameters["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-5a5ca382 | FindButton [else of (siMain.ActiveSheetIndex == 0) ▸ if (siM… | SSP0015_ShipmentPSI.cs:2311 | try ▸ lambda | DATA_OP | req.Parameters["p_partLeaderChk"] | p_partLeaderChk | 행/컬럼 값 대입 |  |  |  |
| AC-205bd0f7 | FindButton [else of (siMain.ActiveSheetIndex == 0) ▸ if (siM… | SSP0015_ShipmentPSI.cs:2312 | try ▸ lambda | DATA_OP | req.Parameters["p_teamLeaderChk"] | p_teamLeaderChk | 행/컬럼 값 대입 |  |  |  |
| AC-1e953558 | FindButton [else of (siMain.ActiveSheetIndex == 0) ▸ if (siM… | SSP0015_ShipmentPSI.cs:2313 | try ▸ lambda | DATA_OP | req.Parameters["p_delegateeChk"] | p_delegateeChk | 행/컬럼 값 대입 |  |  |  |
| AC-aa6d96a6 | FindButton [else of (siMain.ActiveSheetIndex == 0) ▸ if (siM… | SSP0015_ShipmentPSI.cs:2314 | try ▸ lambda | DATA_OP | req.Parameters["p_nonChk"] | p_nonChk | 행/컬럼 값 대입 |  |  |  |
| AC-eb1099e9 | FindButton [else of (siMain.ActiveSheetIndex == 0) ▸ if (siM… | SSP0015_ShipmentPSI.cs:2316 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-ce027a6d | FindButton [else of (siMain.ActiveSheetIndex == 0) ▸ if (siM… | SSP0015_ShipmentPSI.cs:2317 | try ▸ lambda | RETURN | return res.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-b0394b92 | FindButton [else of (siMain.ActiveSheetIndex == 0) ▸ if (siM… | SSP0015_ShipmentPSI.cs:2324 | try | GRID_BIND | siMain.Query | (dsBinding) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-8219d4ba | FindButton [else of (siMain.ActiveSheetIndex == 0) ▸ if (siM… | SSP0015_ShipmentPSI.cs:2326 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-8e41da48 | FindButton [else of (siMain.ActiveSheetIndex == 0) ▸ if (siM… | SSP0015_ShipmentPSI.cs:2327 | try | UI_MISC | SetSearchCount | (dsBinding) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-76e1918c | FindButton [else of (siMain.ActiveSheetIndex == 0) ▸ if (siM… | SSP0015_ShipmentPSI.cs:2337 | try | UI_PROP | spdMain.AutoClipboard | true | 속성 AutoClipboard 설정 |  |  |  |
| AC-03411baf | FindButton [else of (siMain.ActiveSheetIndex == 0) ▸ if (siM… | SSP0015_ShipmentPSI.cs:2344 | try | FLAG | intRNoteIdx | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-f02926bf | FindButton [else of (siMain.ActiveSheetIndex == 0) ▸ if (siM… | SSP0015_ShipmentPSI.cs:2345 | try | FLAG | intCNoteIdx | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-5c0b9c55 | FindButton [else of (siMain.ActiveSheetIndex == 0) ▸ if (siM… | SSP0015_ShipmentPSI.cs:2351 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SSP0015_ShipmentPSI.FindData_mes_stock

진입점: this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex == 0) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.FIGURE) && sMeasure == "WH_STOCK")] / SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.ActiveSheetIndex == 0) ▸ if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtMesStock) ▸ if (iCount > 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ else of (bDetail_Search == true)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f98d285c | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0015_ShipmentPSI.cs:3916 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-72554553 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0015_ShipmentPSI.cs:3922 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-760f1c1f | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0015_ShipmentPSI.cs:3951 | try | VALUE_SET | txtModel2.Text | siMain.GetValue(nRowIdx, siMain.GetColumnIndex(DefColumns.ITEM_ID)).ToString() | 컨트롤 값 설정 |  |  |  |
| AC-075b3cd5 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0015_ShipmentPSI.cs:3961 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-c3c62c8b | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0015_ShipmentPSI.cs:3966 | try | ENDPOINT | new FoxDataRequest | ("SSP.SSP0015_GET_MES_STOCK") ⇒ SSP.SSP0015_GET_MES_STOCK | 엔드포인트 요청 생성 |  |  |  |
| AC-51aecaa9 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0015_ShipmentPSI.cs:3967 | try | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-73dd98ae | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0015_ShipmentPSI.cs:3969 | try | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-24c0c544 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0015_ShipmentPSI.cs:3970 | try | DATA_OP | request.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-ce534c39 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0015_ShipmentPSI.cs:3971 | try | DATA_OP | request.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-9bbac639 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0015_ShipmentPSI.cs:3972 | try | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-cd0e6974 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0015_ShipmentPSI.cs:3973 | try | DATA_OP | request.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-fdfec89e | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0015_ShipmentPSI.cs:3974 | try | DATA_OP | request.Parameters["p_lot_id"] | p_lot_id | 행/컬럼 값 대입 |  |  |  |
| AC-74ced21b | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0015_ShipmentPSI.cs:3975 | try | DATA_OP | request.Parameters["p_myModelChk"] | p_myModelChk | 행/컬럼 값 대입 |  |  |  |
| AC-f02ff152 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0015_ShipmentPSI.cs:3976 | try | DATA_OP | request.Parameters["p_partLeaderChk"] | p_partLeaderChk | 행/컬럼 값 대입 |  |  |  |
| AC-56f9c7a9 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0015_ShipmentPSI.cs:3977 | try | DATA_OP | request.Parameters["p_teamLeaderChk"] | p_teamLeaderChk | 행/컬럼 값 대입 |  |  |  |
| AC-c8198829 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0015_ShipmentPSI.cs:3978 | try | DATA_OP | request.Parameters["p_delegateeChk"] | p_delegateeChk | 행/컬럼 값 대입 |  |  |  |
| AC-52a4c7f7 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0015_ShipmentPSI.cs:3979 | try | DATA_OP | request.Parameters["p_nonChk"] | p_nonChk | 행/컬럼 값 대입 |  |  |  |
| AC-6499cadb | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0015_ShipmentPSI.cs:3980 | try | DATA_OP | request.Parameters["p_language"] | p_language | 행/컬럼 값 대입 |  |  |  |
| AC-c82db6af | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0015_ShipmentPSI.cs:3982 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-f5459591 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0015_ShipmentPSI.cs:3990 | try | GRID_BIND | siDetail.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-ced3e55f | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0015_ShipmentPSI.cs:3991 | try | GRID_LOCK | siDetail.LockColumn | (0, siDetail.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-ee99618e | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0015_ShipmentPSI.cs:3996 | try ▸ if (DefaultMainDS != null) | STATE_RESET | DefaultMainDS.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-d9c19461 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0015_ShipmentPSI.cs:3998 | try | FLAG | DefaultMainDS | ds.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-c930d4df | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0015_ShipmentPSI.cs:3998 | try | DATA_OP | ds.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-458f9b37 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0015_ShipmentPSI.cs:4003 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-d558a0b7 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0015_ShipmentPSI.cs:4010 | try ▸ for (iRow < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.GetValue(iRow, siDetail.GetColumnIndex(DefColumns.USER_MOD_RELEASE_DATE)).To… | GRID_SET | siDetail.ActiveSheet.Cells[iRow, siDetail.GetColumnIndex(DefColumns.USER_MOD_RELEASE_DATE)… | Color.Blue | 그리드 속성/값 설정 |  |  |  |
| AC-89288356 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0015_ShipmentPSI.cs:4025 | try | GRID_STYLE | siMain.ActiveSheet.SetActiveCell | (iSelRow, iSelCol) | 그리드 표시 설정 |  |  |  |
| AC-76657293 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0015_ShipmentPSI.cs:4030 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SSP0015_ShipmentPSI.FindData_MesStock_btnSearch

진입점: this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtRequestDetail) ▸ else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtWHstock \|\| siDetail.ActiveSheet.SheetName == SpdSheet.shtWHstockDetail) ▸ else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtBolckStockDetail) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtMesStock)] / SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.ActiveSheetIndex == 0) ▸ if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.Sheet…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9f5b8443 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… 외 1 | SSP0015_ShipmentPSI.cs:4482 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-098a6e05 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… 외 1 | SSP0015_ShipmentPSI.cs:4488 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-c845e0e5 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… 외 1 | SSP0015_ShipmentPSI.cs:4523 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-640094de | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… 외 1 | SSP0015_ShipmentPSI.cs:4528 | try | ENDPOINT | new FoxDataRequest | ("SSP.SSP0015_GET_MES_STOCK") ⇒ SSP.SSP0015_GET_MES_STOCK | 엔드포인트 요청 생성 |  |  |  |
| AC-0b94faef | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… 외 1 | SSP0015_ShipmentPSI.cs:4529 | try | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-291bf87c | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… 외 1 | SSP0015_ShipmentPSI.cs:4531 | try | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-ab1b157d | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… 외 1 | SSP0015_ShipmentPSI.cs:4532 | try | DATA_OP | request.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-50eb1a64 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… 외 1 | SSP0015_ShipmentPSI.cs:4533 | try | DATA_OP | request.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-77ecad74 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… 외 1 | SSP0015_ShipmentPSI.cs:4534 | try | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-84ccd315 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… 외 1 | SSP0015_ShipmentPSI.cs:4535 | try | DATA_OP | request.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-647136a5 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… 외 1 | SSP0015_ShipmentPSI.cs:4536 | try | DATA_OP | request.Parameters["p_lot_id"] | p_lot_id | 행/컬럼 값 대입 |  |  |  |
| AC-a97e079f | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… 외 1 | SSP0015_ShipmentPSI.cs:4537 | try | DATA_OP | request.Parameters["p_myModelChk"] | p_myModelChk | 행/컬럼 값 대입 |  |  |  |
| AC-0569a46a | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… 외 1 | SSP0015_ShipmentPSI.cs:4538 | try | DATA_OP | request.Parameters["p_partLeaderChk"] | p_partLeaderChk | 행/컬럼 값 대입 |  |  |  |
| AC-8efd26fd | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… 외 1 | SSP0015_ShipmentPSI.cs:4539 | try | DATA_OP | request.Parameters["p_teamLeaderChk"] | p_teamLeaderChk | 행/컬럼 값 대입 |  |  |  |
| AC-5a09f577 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… 외 1 | SSP0015_ShipmentPSI.cs:4540 | try | DATA_OP | request.Parameters["p_delegateeChk"] | p_delegateeChk | 행/컬럼 값 대입 |  |  |  |
| AC-ea9df471 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… 외 1 | SSP0015_ShipmentPSI.cs:4541 | try | DATA_OP | request.Parameters["p_nonChk"] | p_nonChk | 행/컬럼 값 대입 |  |  |  |
| AC-d88749bf | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… 외 1 | SSP0015_ShipmentPSI.cs:4542 | try | DATA_OP | request.Parameters["p_language"] | p_language | 행/컬럼 값 대입 |  |  |  |
| AC-dcfa2cbf | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… 외 1 | SSP0015_ShipmentPSI.cs:4544 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-3e2e5635 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… 외 1 | SSP0015_ShipmentPSI.cs:4553 | try | GRID_BIND | siDetail.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-2faa64b2 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… 외 1 | SSP0015_ShipmentPSI.cs:4554 | try | GRID_LOCK | siDetail.LockColumn | (0, siDetail.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-1529999a | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… 외 1 | SSP0015_ShipmentPSI.cs:4559 | try ▸ if (DefaultMainDS != null) | STATE_RESET | DefaultMainDS.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-a7568bcc | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… 외 1 | SSP0015_ShipmentPSI.cs:4561 | try | FLAG | DefaultMainDS | ds.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-f6447544 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… 외 1 | SSP0015_ShipmentPSI.cs:4561 | try | DATA_OP | ds.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-b8197333 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… 외 1 | SSP0015_ShipmentPSI.cs:4564 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-00705945 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… 외 1 | SSP0015_ShipmentPSI.cs:4571 | try ▸ for (iRow < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.GetValue(iRow, siDetail.GetColumnIndex(DefColumns.USER_MOD_RELEASE_DATE)).To… | GRID_SET | siDetail.ActiveSheet.Cells[iRow, siDetail.GetColumnIndex(DefColumns.USER_MOD_RELEASE_DATE)… | Color.Blue | 그리드 속성/값 설정 |  |  |  |
| AC-1b9e11d2 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… 외 1 | SSP0015_ShipmentPSI.cs:4584 | try | GRID_STYLE | siMain.ActiveSheet.SetActiveCell | (iSelRow, iSelCol) | 그리드 표시 설정 |  |  |  |
| AC-7a799b92 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… 외 1 | SSP0015_ShipmentPSI.cs:4590 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SSP0015_ShipmentPSI.FindData_Request_Detail

진입점: this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtRequestDetail)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e805a196 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0015_ShipmentPSI.cs:4595 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-eadb3f5b | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0015_ShipmentPSI.cs:4603 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-717dee41 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0015_ShipmentPSI.cs:4603 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-37889cee | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0015_ShipmentPSI.cs:4607 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-481062f4 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0015_ShipmentPSI.cs:4609 | try | VALIDATE | DateUtil.Check_PeriodDate | (drpPeriod2) | 프레임워크 검증 |  |  |  |
| AC-ad30ef24 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0015_ShipmentPSI.cs:4609 | try ▸ if (!DateUtil.Check_PeriodDate(drpPeriod2)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4e3cca37 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0015_ShipmentPSI.cs:4635 | try ▸ if (spdMain.ActiveSheetIndex == 1) | UI_PROP | proxyPivot.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-72cf8b42 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0015_ShipmentPSI.cs:4636 | try ▸ if (spdMain.ActiveSheetIndex == 1) | ENDPOINT | proxyPivot.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SSP.Plan.WSL/FoxDataService.s… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-88fb38cd | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0015_ShipmentPSI.cs:4640 | try ▸ if (spdMain.ActiveSheetIndex == 1) ▸ lambda | ENDPOINT | new FoxDataRequest | ("SSP.SSP0026_GET_REQUEST_DETAIL_PACK") ⇒ SSP.SSP0026_GET_REQUEST_DETAIL_PACK | 엔드포인트 요청 생성 |  |  |  |
| AC-50ad13a6 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0015_ShipmentPSI.cs:4642 | try ▸ if (spdMain.ActiveSheetIndex == 1) ▸ lambda | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-1e630e9f | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0015_ShipmentPSI.cs:4644 | try ▸ if (spdMain.ActiveSheetIndex == 1) ▸ lambda | DATA_OP | req.Parameters["p_sheet_name"] | siDetail.SheetName | 행/컬럼 값 대입 |  |  |  |
| AC-580e89d3 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0015_ShipmentPSI.cs:4645 | try ▸ if (spdMain.ActiveSheetIndex == 1) ▸ lambda | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-be421e03 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0015_ShipmentPSI.cs:4646 | try ▸ if (spdMain.ActiveSheetIndex == 1) ▸ lambda | DATA_OP | req.Parameters["p_team_id"] | (sTeam == "ALL") ? "" : sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-db12daed | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0015_ShipmentPSI.cs:4647 | try ▸ if (spdMain.ActiveSheetIndex == 1) ▸ lambda | DATA_OP | req.Parameters["p_customer"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-3f4b0813 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0015_ShipmentPSI.cs:4648 | try ▸ if (spdMain.ActiveSheetIndex == 1) ▸ lambda | DATA_OP | req.Parameters["p_scm_site_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-9927d61d | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0015_ShipmentPSI.cs:4650 | try ▸ if (spdMain.ActiveSheetIndex == 1) ▸ lambda | DATA_OP | req.Parameters["p_plant_site_id"] | sPlantSite | 행/컬럼 값 대입 |  |  |  |
| AC-c77ceba3 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0015_ShipmentPSI.cs:4651 | try ▸ if (spdMain.ActiveSheetIndex == 1) ▸ lambda | DATA_OP | req.Parameters["p_project_code"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-aa3d9e73 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0015_ShipmentPSI.cs:4652 | try ▸ if (spdMain.ActiveSheetIndex == 1) ▸ lambda | DATA_OP | req.Parameters["p_item_id"] | p_model_id | 행/컬럼 값 대입 |  |  |  |
| AC-8825782f | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0015_ShipmentPSI.cs:4653 | try ▸ if (spdMain.ActiveSheetIndex == 1) ▸ lambda | DATA_OP | req.Parameters["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-a0e16713 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0015_ShipmentPSI.cs:4654 | try ▸ if (spdMain.ActiveSheetIndex == 1) ▸ lambda | DATA_OP | req.Parameters["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-2192445b | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0015_ShipmentPSI.cs:4655 | try ▸ if (spdMain.ActiveSheetIndex == 1) ▸ lambda | DATA_OP | req.Parameters["p_nick_name"] | p_nick_name.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-1c42ffa8 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0015_ShipmentPSI.cs:4656 | try ▸ if (spdMain.ActiveSheetIndex == 1) ▸ lambda | DATA_OP | req.Parameters["p_requestor_id"] | p_requestor_id | 행/컬럼 값 대입 |  |  |  |
| AC-b7a91a89 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0015_ShipmentPSI.cs:4657 | try ▸ if (spdMain.ActiveSheetIndex == 1) ▸ lambda | DATA_OP | req.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-a1bb49b8 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0015_ShipmentPSI.cs:4658 | try ▸ if (spdMain.ActiveSheetIndex == 1) ▸ lambda | DATA_OP | req.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-17d33ee4 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0015_ShipmentPSI.cs:4660 | try ▸ if (spdMain.ActiveSheetIndex == 1) ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-aab7fb8b | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0015_ShipmentPSI.cs:4661 | try ▸ if (spdMain.ActiveSheetIndex == 1) ▸ lambda | RETURN | return res.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-f0a430e9 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0015_ShipmentPSI.cs:4671 | try ▸ if (spdMain.ActiveSheetIndex == 1) | UI_MISC | SetSearchCount | (dsBinding) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-278c4396 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0015_ShipmentPSI.cs:4673 | try ▸ if (spdMain.ActiveSheetIndex == 1) | GRID_BIND | siDetail.Query | (dsBinding) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-335d3a99 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0015_ShipmentPSI.cs:4677 | try | GRID_LOCK | siDetail.LockColumn | (0, siDetail.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-769260c0 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0015_ShipmentPSI.cs:4692 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SSP0015_ShipmentPSI.FindData_ScsStock_btnSearch

진입점: this.spdMain.CellDoubleClick [else of (siMain.ActiveSheetIndex == 0) ▸ if (siMain.ActiveSheetIndex == 1) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.FIGURE) && sMeasure == "WH_STOCK")] / this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtRequestDetail) ▸ else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtWHstock \|\| siDetail.ActiveSheet.SheetName == SpdSheet.shtWHstockDetail) ▸ else of (siDetail.ActiveSheet.SheetName == SpdSheet…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-36e76e9b | this.spdMain.CellDoubleClick [else of (siMain.ActiveSheetInd… 외 1 | SSP0015_ShipmentPSI.cs:4391 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-89959b26 | this.spdMain.CellDoubleClick [else of (siMain.ActiveSheetInd… 외 1 | SSP0015_ShipmentPSI.cs:4397 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-7a3a6b67 | this.spdMain.CellDoubleClick [else of (siMain.ActiveSheetInd… 외 1 | SSP0015_ShipmentPSI.cs:4432 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-2a75e90e | this.spdMain.CellDoubleClick [else of (siMain.ActiveSheetInd… 외 1 | SSP0015_ShipmentPSI.cs:4437 | try | ENDPOINT | new FoxDataRequest | ("SSP.SSP0015_GET_SCS_STOCK") ⇒ SSP.SSP0015_GET_SCS_STOCK | 엔드포인트 요청 생성 |  |  |  |
| AC-e1b1ea04 | this.spdMain.CellDoubleClick [else of (siMain.ActiveSheetInd… 외 1 | SSP0015_ShipmentPSI.cs:4438 | try | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-869fc91b | this.spdMain.CellDoubleClick [else of (siMain.ActiveSheetInd… 외 1 | SSP0015_ShipmentPSI.cs:4440 | try | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-c18fb274 | this.spdMain.CellDoubleClick [else of (siMain.ActiveSheetInd… 외 1 | SSP0015_ShipmentPSI.cs:4441 | try | DATA_OP | request.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-9f7f83f2 | this.spdMain.CellDoubleClick [else of (siMain.ActiveSheetInd… 외 1 | SSP0015_ShipmentPSI.cs:4442 | try | DATA_OP | request.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-16614059 | this.spdMain.CellDoubleClick [else of (siMain.ActiveSheetInd… 외 1 | SSP0015_ShipmentPSI.cs:4443 | try | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-be7c30fe | this.spdMain.CellDoubleClick [else of (siMain.ActiveSheetInd… 외 1 | SSP0015_ShipmentPSI.cs:4444 | try | DATA_OP | request.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-6b666a87 | this.spdMain.CellDoubleClick [else of (siMain.ActiveSheetInd… 외 1 | SSP0015_ShipmentPSI.cs:4445 | try | DATA_OP | request.Parameters["p_myModelChk"] | p_myModelChk | 행/컬럼 값 대입 |  |  |  |
| AC-be9f4c1f | this.spdMain.CellDoubleClick [else of (siMain.ActiveSheetInd… 외 1 | SSP0015_ShipmentPSI.cs:4446 | try | DATA_OP | request.Parameters["p_partLeaderChk"] | p_partLeaderChk | 행/컬럼 값 대입 |  |  |  |
| AC-8fb90131 | this.spdMain.CellDoubleClick [else of (siMain.ActiveSheetInd… 외 1 | SSP0015_ShipmentPSI.cs:4447 | try | DATA_OP | request.Parameters["p_teamLeaderChk"] | p_teamLeaderChk | 행/컬럼 값 대입 |  |  |  |
| AC-6220950a | this.spdMain.CellDoubleClick [else of (siMain.ActiveSheetInd… 외 1 | SSP0015_ShipmentPSI.cs:4448 | try | DATA_OP | request.Parameters["p_delegateeChk"] | p_delegateeChk | 행/컬럼 값 대입 |  |  |  |
| AC-b4156ea7 | this.spdMain.CellDoubleClick [else of (siMain.ActiveSheetInd… 외 1 | SSP0015_ShipmentPSI.cs:4449 | try | DATA_OP | request.Parameters["p_nonChk"] | p_nonChk | 행/컬럼 값 대입 |  |  |  |
| AC-868915ea | this.spdMain.CellDoubleClick [else of (siMain.ActiveSheetInd… 외 1 | SSP0015_ShipmentPSI.cs:4451 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-d8a5cd94 | this.spdMain.CellDoubleClick [else of (siMain.ActiveSheetInd… 외 1 | SSP0015_ShipmentPSI.cs:4460 | try | GRID_BIND | siDetail.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-69c4aa2f | this.spdMain.CellDoubleClick [else of (siMain.ActiveSheetInd… 외 1 | SSP0015_ShipmentPSI.cs:4461 | try | GRID_LOCK | siDetail.LockColumn | (0, siDetail.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-174acb93 | this.spdMain.CellDoubleClick [else of (siMain.ActiveSheetInd… 외 1 | SSP0015_ShipmentPSI.cs:4465 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-7928bbf2 | this.spdMain.CellDoubleClick [else of (siMain.ActiveSheetInd… 외 1 | SSP0015_ShipmentPSI.cs:4477 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SSP0015_ShipmentPSI.FindData_ShipmentResult_btnSearch

진입점: this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtRequestDetail) ▸ else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtWHstock \|\| siDetail.ActiveSheet.SheetName == SpdSheet.shtWHstockDetail) ▸ else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtBolckStockDetail) ▸ else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtMesStock) ▸ else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtScsStock) ▸ else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtStockLocationDetail) ▸ else of (siDetail.Activ…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1f3f045e | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0015_ShipmentPSI.cs:4888 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-1025ce7e | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0015_ShipmentPSI.cs:4899 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-9b74a3f0 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0015_ShipmentPSI.cs:4917 | try | DATA_OP | dtNewPlanDate.Compute | ("Max(code)", null) | 데이터 객체 조작/조회 |  |  |  |
| AC-de920215 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0015_ShipmentPSI.cs:4939 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-dc8602a2 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0015_ShipmentPSI.cs:4944 | try | ENDPOINT | new FoxDataRequest | ("SSP.SSP0015_GET_SHIPMENT_RESULT") ⇒ SSP.SSP0015_GET_SHIPMENT_RESULT | 엔드포인트 요청 생성 |  |  |  |
| AC-d254a560 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0015_ShipmentPSI.cs:4945 | try | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-95e086e7 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0015_ShipmentPSI.cs:4947 | try | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-2e9778a8 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0015_ShipmentPSI.cs:4948 | try | DATA_OP | request.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-a5973ad9 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0015_ShipmentPSI.cs:4949 | try | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-d7e4fdc9 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0015_ShipmentPSI.cs:4950 | try | DATA_OP | request.Parameters["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-eeb931df | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0015_ShipmentPSI.cs:4951 | try | DATA_OP | request.Parameters["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-50464228 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0015_ShipmentPSI.cs:4952 | try | DATA_OP | request.Parameters["p_type"] | p_type | 행/컬럼 값 대입 |  |  |  |
| AC-362cf26a | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0015_ShipmentPSI.cs:4953 | try | DATA_OP | request.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-1f56da25 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0015_ShipmentPSI.cs:4954 | try | DATA_OP | request.Parameters["p_company_id"] | p_company_id | 행/컬럼 값 대입 |  |  |  |
| AC-9c6c59a2 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0015_ShipmentPSI.cs:4955 | try | DATA_OP | request.Parameters["p_myModelChk"] | p_myModelChk | 행/컬럼 값 대입 |  |  |  |
| AC-414f941f | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0015_ShipmentPSI.cs:4956 | try | DATA_OP | request.Parameters["p_partLeaderChk"] | p_partLeaderChk | 행/컬럼 값 대입 |  |  |  |
| AC-113fb65c | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0015_ShipmentPSI.cs:4957 | try | DATA_OP | request.Parameters["p_teamLeaderChk"] | p_teamLeaderChk | 행/컬럼 값 대입 |  |  |  |
| AC-e63a584e | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0015_ShipmentPSI.cs:4958 | try | DATA_OP | request.Parameters["p_delegateeChk"] | p_delegateeChk | 행/컬럼 값 대입 |  |  |  |
| AC-d9cec693 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0015_ShipmentPSI.cs:4959 | try | DATA_OP | request.Parameters["p_nonChk"] | p_nonChk | 행/컬럼 값 대입 |  |  |  |
| AC-f87acbf6 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0015_ShipmentPSI.cs:4960 | try | DATA_OP | request.Parameters["p_real_flag"] | p_real_flag | 행/컬럼 값 대입 |  |  |  |
| AC-c3a2ccce | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0015_ShipmentPSI.cs:4961 | try | DATA_OP | request.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-67f5ee15 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0015_ShipmentPSI.cs:4963 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-23713eaf | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0015_ShipmentPSI.cs:4972 | try | GRID_BIND | siDetail.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-a6503cf4 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0015_ShipmentPSI.cs:4973 | try | GRID_LOCK | siDetail.LockColumn | (0, siDetail.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-a6a9ad70 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0015_ShipmentPSI.cs:4978 | try ▸ if (DefaultMainDS != null) | STATE_RESET | DefaultMainDS.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-b36be8a8 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0015_ShipmentPSI.cs:4980 | try | FLAG | DefaultMainDS | ds.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-68d0f07a | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0015_ShipmentPSI.cs:4980 | try | DATA_OP | ds.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-b13533a5 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0015_ShipmentPSI.cs:4983 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-8830fa74 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0015_ShipmentPSI.cs:4991 | try | GRID_SET | sv.Columns["SHIP_TO"].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-df05e857 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0015_ShipmentPSI.cs:4992 | try | GRID_SET | sv.Columns["SHIPTO_DESCRIPTION"].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-a3b82497 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0015_ShipmentPSI.cs:4994 | try | GRID_STYLE | siMain.ActiveSheet.SetActiveCell | (iSelRow, iSelCol) | 그리드 표시 설정 |  |  |  |
| AC-10bdcebf | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0015_ShipmentPSI.cs:4999 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SSP0015_ShipmentPSI.FindData_ShipmentSCSResult_btnSearch

진입점: this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtRequestDetail) ▸ else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtWHstock \|\| siDetail.ActiveSheet.SheetName == SpdSheet.shtWHstockDetail) ▸ else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtBolckStockDetail) ▸ else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtMesStock) ▸ else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtScsStock) ▸ else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtStockLocationDetail) ▸ else of (siDetail.Activ…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-19df29cd | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0015_ShipmentPSI.cs:4773 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-73f6ac30 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0015_ShipmentPSI.cs:4779 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-91219bc4 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0015_ShipmentPSI.cs:4797 | try | DATA_OP | dtNewPlanDate.Compute | ("Max(code)", null) | 데이터 객체 조작/조회 |  |  |  |
| AC-29ed006f | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0015_ShipmentPSI.cs:4827 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-b9f8302f | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0015_ShipmentPSI.cs:4832 | try | ENDPOINT | new FoxDataRequest | ("SSP.SSP0015_GET_SHIPMENT_RESULT_PACKER") ⇒ SSP.SSP0015_GET_SHIPMENT_RESULT_PACKER | 엔드포인트 요청 생성 |  |  |  |
| AC-7b6bc2fb | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0015_ShipmentPSI.cs:4833 | try | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-b73a626f | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0015_ShipmentPSI.cs:4835 | try | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-6915c275 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0015_ShipmentPSI.cs:4836 | try | DATA_OP | request.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-d2b4ac08 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0015_ShipmentPSI.cs:4837 | try | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-39ddfd3f | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0015_ShipmentPSI.cs:4838 | try | DATA_OP | request.Parameters["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-83af8fc7 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0015_ShipmentPSI.cs:4839 | try | DATA_OP | request.Parameters["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-d028507b | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0015_ShipmentPSI.cs:4840 | try | DATA_OP | request.Parameters["p_type"] | p_type | 행/컬럼 값 대입 |  |  |  |
| AC-55efc76a | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0015_ShipmentPSI.cs:4841 | try | DATA_OP | request.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-14dd0604 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0015_ShipmentPSI.cs:4842 | try | DATA_OP | request.Parameters["p_company_id"] | p_company_id | 행/컬럼 값 대입 |  |  |  |
| AC-5452acfa | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0015_ShipmentPSI.cs:4843 | try | DATA_OP | request.Parameters["p_myModelChk"] | p_myModelChk | 행/컬럼 값 대입 |  |  |  |
| AC-b65ba1fb | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0015_ShipmentPSI.cs:4844 | try | DATA_OP | request.Parameters["p_partLeaderChk"] | p_partLeaderChk | 행/컬럼 값 대입 |  |  |  |
| AC-97cb431b | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0015_ShipmentPSI.cs:4845 | try | DATA_OP | request.Parameters["p_teamLeaderChk"] | p_teamLeaderChk | 행/컬럼 값 대입 |  |  |  |
| AC-9097e219 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0015_ShipmentPSI.cs:4846 | try | DATA_OP | request.Parameters["p_delegateeChk"] | p_delegateeChk | 행/컬럼 값 대입 |  |  |  |
| AC-6c4b58fd | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0015_ShipmentPSI.cs:4847 | try | DATA_OP | request.Parameters["p_nonChk"] | p_nonChk | 행/컬럼 값 대입 |  |  |  |
| AC-92da677b | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0015_ShipmentPSI.cs:4848 | try | DATA_OP | request.Parameters["p_real_flag"] | p_real_flag | 행/컬럼 값 대입 |  |  |  |
| AC-efaa1375 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0015_ShipmentPSI.cs:4849 | try | DATA_OP | request.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-5cd35bbf | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0015_ShipmentPSI.cs:4851 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-197d2ef9 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0015_ShipmentPSI.cs:4860 | try | GRID_BIND | siDetail.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-b3149f86 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0015_ShipmentPSI.cs:4861 | try | GRID_LOCK | siDetail.LockColumn | (0, siDetail.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-704ccd2b | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0015_ShipmentPSI.cs:4866 | try ▸ if (DefaultMainDS != null) | STATE_RESET | DefaultMainDS.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-306ff620 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0015_ShipmentPSI.cs:4868 | try | FLAG | DefaultMainDS | ds.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-c88f873c | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0015_ShipmentPSI.cs:4868 | try | DATA_OP | ds.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-ba3624da | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0015_ShipmentPSI.cs:4871 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-0b76d924 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0015_ShipmentPSI.cs:4878 | try | GRID_STYLE | siMain.ActiveSheet.SetActiveCell | (iSelRow, iSelCol) | 그리드 표시 설정 |  |  |  |
| AC-ce629b23 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0015_ShipmentPSI.cs:4883 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SSP0015_ShipmentPSI.FindData_shtStockLocationDetail_btnSearch

진입점: this.spdMain.CellDoubleClick [else of (siMain.ActiveSheetIndex == 0) ▸ if (siMain.ActiveSheetIndex == 1) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.FIGURE) && sMeasure == "WH_STOCK") ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.FIGURE) && sMeasure == "BALANCE")] / this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtRequestDetail) ▸ else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtWHstock \|\| siDetail.ActiveSheet.She…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0f7b25d2 | this.spdMain.CellDoubleClick [else of (siMain.ActiveSheetInd… 외 1 | SSP0015_ShipmentPSI.cs:4266 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-d639269f | this.spdMain.CellDoubleClick [else of (siMain.ActiveSheetInd… 외 1 | SSP0015_ShipmentPSI.cs:4271 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-5214cc4e | this.spdMain.CellDoubleClick [else of (siMain.ActiveSheetInd… 외 1 | SSP0015_ShipmentPSI.cs:4332 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-f2d5fc6c | this.spdMain.CellDoubleClick [else of (siMain.ActiveSheetInd… 외 1 | SSP0015_ShipmentPSI.cs:4337 | try | ENDPOINT | new FoxDataRequest | ("SSP.SSP0015_GET_STOCK_LOCATION_DETAIL") ⇒ SSP.SSP0015_GET_STOCK_LOCATION_DETAIL | 엔드포인트 요청 생성 |  |  |  |
| AC-837abee2 | this.spdMain.CellDoubleClick [else of (siMain.ActiveSheetInd… 외 1 | SSP0015_ShipmentPSI.cs:4338 | try | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-676b90b8 | this.spdMain.CellDoubleClick [else of (siMain.ActiveSheetInd… 외 1 | SSP0015_ShipmentPSI.cs:4339 | try | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-e01df6cd | this.spdMain.CellDoubleClick [else of (siMain.ActiveSheetInd… 외 1 | SSP0015_ShipmentPSI.cs:4340 | try | DATA_OP | request.Parameters["p_company_id"] | p_company_id | 행/컬럼 값 대입 |  |  |  |
| AC-e938c0fc | this.spdMain.CellDoubleClick [else of (siMain.ActiveSheetInd… 외 1 | SSP0015_ShipmentPSI.cs:4341 | try | DATA_OP | request.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-33049b2f | this.spdMain.CellDoubleClick [else of (siMain.ActiveSheetInd… 외 1 | SSP0015_ShipmentPSI.cs:4342 | try | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-25f9af9f | this.spdMain.CellDoubleClick [else of (siMain.ActiveSheetInd… 외 1 | SSP0015_ShipmentPSI.cs:4343 | try | DATA_OP | request.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-f403ff24 | this.spdMain.CellDoubleClick [else of (siMain.ActiveSheetInd… 외 1 | SSP0015_ShipmentPSI.cs:4344 | try | DATA_OP | request.Parameters["p_dbl_flag"] | p_dbl_flag | 행/컬럼 값 대입 |  |  |  |
| AC-6f324258 | this.spdMain.CellDoubleClick [else of (siMain.ActiveSheetInd… 외 1 | SSP0015_ShipmentPSI.cs:4345 | try | DATA_OP | request.Parameters["p_language"] | sLanguage | 행/컬럼 값 대입 |  |  |  |
| AC-767e5d6e | this.spdMain.CellDoubleClick [else of (siMain.ActiveSheetInd… 외 1 | SSP0015_ShipmentPSI.cs:4346 | try | DATA_OP | request.Parameters["p_program_id"] | p_program_id | 행/컬럼 값 대입 |  |  |  |
| AC-d8a9947e | this.spdMain.CellDoubleClick [else of (siMain.ActiveSheetInd… 외 1 | SSP0015_ShipmentPSI.cs:4347 | try | DATA_OP | request.Parameters["p_sheet_name"] | p_sheet_name | 행/컬럼 값 대입 |  |  |  |
| AC-8a42c337 | this.spdMain.CellDoubleClick [else of (siMain.ActiveSheetInd… 외 1 | SSP0015_ShipmentPSI.cs:4348 | try | DATA_OP | request.Parameters["debug_mode"] | "T" | 행/컬럼 값 대입 |  |  |  |
| AC-6ed345cf | this.spdMain.CellDoubleClick [else of (siMain.ActiveSheetInd… 외 1 | SSP0015_ShipmentPSI.cs:4349 | try | DATA_OP | request.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-dab8cc0b | this.spdMain.CellDoubleClick [else of (siMain.ActiveSheetInd… 외 1 | SSP0015_ShipmentPSI.cs:4350 | try | DATA_OP | request.Parameters["p_myModelChk"] | p_myModelChk | 행/컬럼 값 대입 |  |  |  |
| AC-1f4ed77c | this.spdMain.CellDoubleClick [else of (siMain.ActiveSheetInd… 외 1 | SSP0015_ShipmentPSI.cs:4351 | try | DATA_OP | request.Parameters["p_partLeaderChk"] | p_partLeaderChk | 행/컬럼 값 대입 |  |  |  |
| AC-09218fb4 | this.spdMain.CellDoubleClick [else of (siMain.ActiveSheetInd… 외 1 | SSP0015_ShipmentPSI.cs:4352 | try | DATA_OP | request.Parameters["p_teamLeaderChk"] | p_teamLeaderChk | 행/컬럼 값 대입 |  |  |  |
| AC-ba2bfd30 | this.spdMain.CellDoubleClick [else of (siMain.ActiveSheetInd… 외 1 | SSP0015_ShipmentPSI.cs:4353 | try | DATA_OP | request.Parameters["p_delegateeChk"] | p_delegateeChk | 행/컬럼 값 대입 |  |  |  |
| AC-62000c69 | this.spdMain.CellDoubleClick [else of (siMain.ActiveSheetInd… 외 1 | SSP0015_ShipmentPSI.cs:4354 | try | DATA_OP | request.Parameters["p_nonChk"] | p_nonChk | 행/컬럼 값 대입 |  |  |  |
| AC-83640c9d | this.spdMain.CellDoubleClick [else of (siMain.ActiveSheetInd… 외 1 | SSP0015_ShipmentPSI.cs:4356 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-db739bed | this.spdMain.CellDoubleClick [else of (siMain.ActiveSheetInd… 외 1 | SSP0015_ShipmentPSI.cs:4365 | try | GRID_BIND | siDetail.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-070745f7 | this.spdMain.CellDoubleClick [else of (siMain.ActiveSheetInd… 외 1 | SSP0015_ShipmentPSI.cs:4366 | try | GRID_LOCK | siDetail.LockColumn | (0, siDetail.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-7336dd11 | this.spdMain.CellDoubleClick [else of (siMain.ActiveSheetInd… 외 1 | SSP0015_ShipmentPSI.cs:4369 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-f51a7d50 | this.spdMain.CellDoubleClick [else of (siMain.ActiveSheetInd… 외 1 | SSP0015_ShipmentPSI.cs:4386 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SSP0015_ShipmentPSI.FindData_WHinPlanDetail_btnSearch

진입점: this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtRequestDetail) ▸ else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtWHstock \|\| siDetail.ActiveSheet.SheetName == SpdSheet.shtWHstockDetail) ▸ else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtBolckStockDetail) ▸ else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtMesStock) ▸ else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtScsStock) ▸ else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtStockLocationDetail) ▸ if (siDetail.ActiveShee…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-108ec8ae | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0015_ShipmentPSI.cs:4697 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-9b663f92 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0015_ShipmentPSI.cs:4703 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-7aac9009 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0015_ShipmentPSI.cs:4718 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-25e09bcc | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0015_ShipmentPSI.cs:4723 | try | ENDPOINT | new FoxDataRequest | ("SSP.SSP0015_GET_SHIPMENT_PSI_COMMENTS") ⇒ SSP.SSP0015_GET_SHIPMENT_PSI_COMMENTS | 엔드포인트 요청 생성 |  |  |  |
| AC-b6e666bc | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0015_ShipmentPSI.cs:4724 | try | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-f661cb65 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0015_ShipmentPSI.cs:4726 | try | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-7392d7b0 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0015_ShipmentPSI.cs:4727 | try | DATA_OP | request.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-c1a38c55 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0015_ShipmentPSI.cs:4728 | try | DATA_OP | request.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-f1114dde | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0015_ShipmentPSI.cs:4729 | try | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-900e9a4a | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0015_ShipmentPSI.cs:4730 | try | DATA_OP | request.Parameters["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-e8193181 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0015_ShipmentPSI.cs:4731 | try | DATA_OP | request.Parameters["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-6f3b4d61 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0015_ShipmentPSI.cs:4733 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-42a9733e | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0015_ShipmentPSI.cs:4742 | try | GRID_BIND | siDetail.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-f8f18fb4 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0015_ShipmentPSI.cs:4743 | try | GRID_LOCK | siDetail.LockColumn | (0, siDetail.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-354eb21d | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0015_ShipmentPSI.cs:4748 | try ▸ if (DefaultMainDS != null) | STATE_RESET | DefaultMainDS.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-2aed9fe4 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0015_ShipmentPSI.cs:4750 | try | FLAG | DefaultMainDS | ds.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-e45fd46a | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0015_ShipmentPSI.cs:4750 | try | DATA_OP | ds.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-e0b88153 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0015_ShipmentPSI.cs:4753 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-577a2b55 | this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetNam… | SSP0015_ShipmentPSI.cs:4768 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SSP0015_ShipmentPSI.FindData_WHstock

진입점: this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex == 0) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) ▸ if (sMeasure == "WH_STOCK")] / this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtRequestDetail) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtWHstock \|\| siDetail.ActiveSheet.SheetName == SpdSheet.shtWHstockDetail)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-96c9a9f6 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0015_ShipmentPSI.cs:3805 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-28c2de88 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0015_ShipmentPSI.cs:3811 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-484d8c24 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0015_ShipmentPSI.cs:3845 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-575b6051 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0015_ShipmentPSI.cs:3846 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SSP.Plan.WSL/FoxDataService.s… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-5bc65031 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0015_ShipmentPSI.cs:3850 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SSP.SSP0015_GET_WH_STOCK") ⇒ SSP.SSP0015_GET_WH_STOCK | 엔드포인트 요청 생성 |  |  |  |
| AC-23c6d0b3 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0015_ShipmentPSI.cs:3851 | try ▸ lambda | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-b1b5ca3b | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0015_ShipmentPSI.cs:3852 | try ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-3642ff4a | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0015_ShipmentPSI.cs:3853 | try ▸ lambda | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-e6aa1364 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0015_ShipmentPSI.cs:3854 | try ▸ lambda | DATA_OP | request.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-0d1102a0 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0015_ShipmentPSI.cs:3855 | try ▸ lambda | DATA_OP | request.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-df0819a1 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0015_ShipmentPSI.cs:3856 | try ▸ lambda | DATA_OP | request.Parameters["p_plan_seq"] | p_plan_seq | 행/컬럼 값 대입 |  |  |  |
| AC-4400b525 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0015_ShipmentPSI.cs:3857 | try ▸ lambda | DATA_OP | request.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-3614f02d | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0015_ShipmentPSI.cs:3858 | try ▸ lambda | DATA_OP | request.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-29d56bca | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0015_ShipmentPSI.cs:3859 | try ▸ lambda | DATA_OP | request.Parameters["p_myModelChk"] | p_myModelChk | 행/컬럼 값 대입 |  |  |  |
| AC-3fa5d2a6 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0015_ShipmentPSI.cs:3860 | try ▸ lambda | DATA_OP | request.Parameters["p_partLeaderChk"] | p_partLeaderChk | 행/컬럼 값 대입 |  |  |  |
| AC-c2de4e52 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0015_ShipmentPSI.cs:3861 | try ▸ lambda | DATA_OP | request.Parameters["p_teamLeaderChk"] | p_teamLeaderChk | 행/컬럼 값 대입 |  |  |  |
| AC-ae922545 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0015_ShipmentPSI.cs:3862 | try ▸ lambda | DATA_OP | request.Parameters["p_delegateeChk"] | p_delegateeChk | 행/컬럼 값 대입 |  |  |  |
| AC-51056ba9 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0015_ShipmentPSI.cs:3863 | try ▸ lambda | DATA_OP | request.Parameters["p_search_yn"] | p_search_yn | 행/컬럼 값 대입 |  |  |  |
| AC-6e1bd46b | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0015_ShipmentPSI.cs:3864 | try ▸ lambda | DATA_OP | request.Parameters["p_nonChk"] | p_nonChk | 행/컬럼 값 대입 |  |  |  |
| AC-fce18195 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0015_ShipmentPSI.cs:3866 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-7fdb322f | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0015_ShipmentPSI.cs:3868 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-9e1d4bc1 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0015_ShipmentPSI.cs:3875 | try | GRID_BIND | siDetail.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-449f0efa | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0015_ShipmentPSI.cs:3876 | try | GRID_LOCK | siDetail.LockColumn | (0, siDetail.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-4947335d | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0015_ShipmentPSI.cs:3878 | try | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtWHstockDetail) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0fca9bc2 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0015_ShipmentPSI.cs:3879 | try | GRID_INIT | siDetail.ChangeActiveSheet | (SpdSheet.shtWHstockDetail) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-d4f87754 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0015_ShipmentPSI.cs:3888 | try ▸ if (ds.Tables[1].Rows.Count > 0) | DATA_OP | ds.Tables[1].Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-12ef2fd2 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0015_ShipmentPSI.cs:3890 | try ▸ if (ds.Tables[1].Rows.Count > 0) | DATA_OP | dsDetail.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-2cb66161 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0015_ShipmentPSI.cs:3892 | try ▸ if (ds.Tables[1].Rows.Count > 0) | GRID_BIND | siDetail.Query | (dsDetail) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-6f077fb6 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0015_ShipmentPSI.cs:3893 | try ▸ if (ds.Tables[1].Rows.Count > 0) | GRID_LOCK | siDetail.LockColumn | (0, siDetail.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-27d6663b | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0015_ShipmentPSI.cs:3896 | try | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtWHstock) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a08b91c7 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0015_ShipmentPSI.cs:3897 | try | GRID_INIT | siDetail.ChangeActiveSheet | (SpdSheet.shtWHstock) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-ac1d2a5c | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0015_ShipmentPSI.cs:3900 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-6c5882fc | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 1 | SSP0015_ShipmentPSI.cs:3910 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SSP0015_ShipmentPSI.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b3744a02 | this.Load | SSP0015_ShipmentPSI.cs:428 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SSP0015_ShipmentPSI.GetBucketType

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9329e0ea | this.Load | SSP0015_ShipmentPSI.cs:2162 |  | ENDPOINT | new FoxDataRequest | ("DM.DM0003_GET_BUCKET_TYPE_CODE") ⇒ DM.DM0003_GET_BUCKET_TYPE_CODE | 엔드포인트 요청 생성 |  |  |  |
| AC-015f7e81 | this.Load | SSP0015_ShipmentPSI.cs:2163 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-9a43b50c | this.Load | SSP0015_ShipmentPSI.cs:2166 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SSP0015_ShipmentPSI.GetDayRange

진입점: this.Load / this.spdMain.ActiveSheetChanged [if (spdMain.ActiveSheetIndex == 0)] / clbDivision.SelectedIndexChanged [if (spdMain.ActiveSheetIndex == 0)] / cboPlanDate.SelectedIndexChanged [if (siMain.ActiveSheetIndex == 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-955f8c84 | this.Load 외 3 | SSP0015_ShipmentPSI.cs:9289 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCM0001_GET_SCP_DAY_PERIOD") ⇒ SCP.SCM0001_GET_SCP_DAY_PERIOD | 엔드포인트 요청 생성 |  |  |  |
| AC-e622a1b7 | this.Load 외 3 | SSP0015_ShipmentPSI.cs:9290 |  | DATA_OP | request.Parameters["p_from_date"] | p_from_date | 행/컬럼 값 대입 |  |  |  |
| AC-003013c8 | this.Load 외 3 | SSP0015_ShipmentPSI.cs:9293 |  | DATA_OP | request.Parameters["p_offset_day"] | "31" | 행/컬럼 값 대입 |  |  |  |
| AC-a38e76f0 | this.Load 외 3 | SSP0015_ShipmentPSI.cs:9294 |  | DATA_OP | request.Parameters["p_timezone"] | UserInfoContext.Current[UserInfoProperites.TimeZone] | 행/컬럼 값 대입 |  |  |  |
| AC-6c9c6fce | this.Load 외 3 | SSP0015_ShipmentPSI.cs:9295 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-1f3fd67b | this.Load 외 3 | SSP0015_ShipmentPSI.cs:9298 |  | RETURN | return sDayRange; |  | 처리 중단/반환 |  |  |  |

## SSP0015_ShipmentPSI.GetDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-61d8b17a | (진입점 미연결) | SSP0015_ShipmentPSI.cs:9192 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_DIVISION") ⇒ SCM.SCM0001_GET_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-3fb4b4b6 | (진입점 미연결) | SSP0015_ShipmentPSI.cs:9193 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-f760eb9d | (진입점 미연결) | SSP0015_ShipmentPSI.cs:9196 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SSP0015_ShipmentPSI.GetErpIFCheck

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d0fd8ece | (진입점 미연결) | SSP0015_ShipmentPSI.cs:7276 | try | CALL_EXT | service.FN_ERP_UIWebService | (RequestNo, "C", "") | ⚠ 의미 확인 필요 |  |  |  |
| AC-56c79d8b | (진입점 미연결) | SSP0015_ShipmentPSI.cs:7285 | try ▸ if (service.RtFlag == "E" \|\| service.RtFlag == "F" \|\| service.RtFlag == "C_E") | ENDPOINT | new FoxDataRequest | ("SSP.SSP0015_DELETE_SHIPMENT_REQUEST_DRAFTING") ⇒ SSP.SSP0015_DELETE_SHIPMENT_REQUEST_DRAFTING | 엔드포인트 요청 생성 |  |  |  |
| AC-098294b3 | (진입점 미연결) | SSP0015_ShipmentPSI.cs:7286 | try ▸ if (service.RtFlag == "E" \|\| service.RtFlag == "F" \|\| service.RtFlag == "C_E") | DATA_OP | request.Parameters["p_change_request_no"] | p_change_request_no | 행/컬럼 값 대입 |  |  |  |
| AC-bcb513a5 | (진입점 미연결) | SSP0015_ShipmentPSI.cs:7287 | try ▸ if (service.RtFlag == "E" \|\| service.RtFlag == "F" \|\| service.RtFlag == "C_E") | DATA_OP | request.Parameters["p_user_id"] | UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-58b60216 | (진입점 미연결) | SSP0015_ShipmentPSI.cs:7289 | try ▸ if (service.RtFlag == "E" \|\| service.RtFlag == "F" \|\| service.RtFlag == "C_E") | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-d8a70416 | (진입점 미연결) | SSP0015_ShipmentPSI.cs:7300 | try ▸ if (service.RtFlag == "E") | MESSAGE | MessageHelper.GMessageBox | ("MSG00197", new object[] { arg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-1459f529 | (진입점 미연결) | SSP0015_ShipmentPSI.cs:7307 | try ▸ else of (service.RtFlag == "E") ▸ if (service.RtFlag == "F") | MESSAGE | MessageHelper.GMessageBox | ("MSG00204", new object[] { arg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c19e599a | (진입점 미연결) | SSP0015_ShipmentPSI.cs:7312 | try ▸ else of (service.RtFlag == "E") ▸ else of (service.RtFlag == "F") ▸ if (service.RtFlag == "C_E") | MESSAGE | MessageHelper.GMessageBox | ("MSG00306", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-447879b5 | (진입점 미연결) | SSP0015_ShipmentPSI.cs:7323 |  | RETURN | return bFlag; |  | 처리 중단/반환 |  |  |  |

## SSP0015_ShipmentPSI.GetErpIFCheckNew

진입점: SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.ActiveSheetIndex == 0) ▸ if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlockYn()) ▸ try ▸ try ▸ for (i <= siDetail.ActiveSheet.RowCount - 1) ▸ if (action != CAppSetting.FlagI) ▸ if (string.IsNullOrWhiteSpace(erpSoNo)) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "S") ▸ if (!string.IsNullOrWhiteSpace(sRequestNo)) ▸ if (siMain.ActiveSheetIndex == 0)] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-68c49068 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… 외 1 | SSP0015_ShipmentPSI.cs:7335 | try | CALL_EXT | service.FN_ERP_UIWebService | (RequestNo, "C", "") | ⚠ 의미 확인 필요 |  |  |  |
| AC-2089ba63 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… 외 1 | SSP0015_ShipmentPSI.cs:7344 | try ▸ if (service.RtFlag == "S_E" \|\| service.RtFlag == "E") ▸ if (service.ReErrorMsg.EndsWith("^")) | UI_PROP | service.ReErrorMsg | service.ReErrorMsg.Substring(0, service.ReErrorMsg.Length - 1) | 속성 ReErrorMsg 설정 |  |  |  |
| AC-6466480e | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… 외 1 | SSP0015_ShipmentPSI.cs:7351 | try ▸ if (service.RtFlag == "S_E" \|\| service.RtFlag == "E") ▸ for (iCount < arrReMsg.Length) | DATA_OP | errConfirmList.Add | (arrReMsg[iCount] + ":" + RequestNo) | 데이터 객체 조작/조회 |  |  |  |
| AC-21a2b121 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… 외 1 | SSP0015_ShipmentPSI.cs:7355 | try ▸ if (service.RtFlag == "S_E" \|\| service.RtFlag == "E") ▸ for (iCount < arrReMsg.Length) | DATA_OP | errConfrimList2.Add | (arrConfirm[0].ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-4435f923 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… 외 1 | SSP0015_ShipmentPSI.cs:7363 | try ▸ if (service.RtFlag == "S_E" \|\| service.RtFlag == "E") | ENDPOINT | new FoxDataRequest | ("SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM") ⇒ SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM | 엔드포인트 요청 생성 |  |  |  |
| AC-6e61f36e | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… 외 1 | SSP0015_ShipmentPSI.cs:7365 | try ▸ if (service.RtFlag == "S_E" \|\| service.RtFlag == "E") | DATA_OP | request.Parameters["p_confirm_id"] | p_confirm_id | 행/컬럼 값 대입 |  |  |  |
| AC-2600f147 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… 외 1 | SSP0015_ShipmentPSI.cs:7366 | try ▸ if (service.RtFlag == "S_E" \|\| service.RtFlag == "E") | DATA_OP | request.Parameters["p_change_request_no"] | p_change_request_no | 행/컬럼 값 대입 |  |  |  |
| AC-83787fe1 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… 외 1 | SSP0015_ShipmentPSI.cs:7367 | try ▸ if (service.RtFlag == "S_E" \|\| service.RtFlag == "E") | DATA_OP | request.Parameters["p_del_flag"] | "D" | 행/컬럼 값 대입 |  |  |  |
| AC-c389ca10 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… 외 1 | SSP0015_ShipmentPSI.cs:7368 | try ▸ if (service.RtFlag == "S_E" \|\| service.RtFlag == "E") | DATA_OP | request.Parameters["p_last_updated_by"] | UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-1ec1d785 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… 외 1 | SSP0015_ShipmentPSI.cs:7369 | try ▸ if (service.RtFlag == "S_E" \|\| service.RtFlag == "E") | DATA_OP | request.Parameters["p_time_zone"] | UserInfoContext.Current[UserInfoProperites.TimeZone] | 행/컬럼 값 대입 |  |  |  |
| AC-9358f74d | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… 외 1 | SSP0015_ShipmentPSI.cs:7370 | try ▸ if (service.RtFlag == "S_E" \|\| service.RtFlag == "E") | DATA_OP | request.Parameters["p_if_send_flag"] | "Y" | 행/컬럼 값 대입 |  |  |  |
| AC-fbc0338e | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… 외 1 | SSP0015_ShipmentPSI.cs:7371 | try ▸ if (service.RtFlag == "S_E" \|\| service.RtFlag == "E") | DATA_OP | request.Parameters["p_change_type"] | "C" | 행/컬럼 값 대입 |  |  |  |
| AC-0e5e4e7c | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… 외 1 | SSP0015_ShipmentPSI.cs:7373 | try ▸ if (service.RtFlag == "S_E" \|\| service.RtFlag == "E") | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-88d6d9b2 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… 외 1 | SSP0015_ShipmentPSI.cs:7389 | try ▸ if (service.RtFlag == "S_E" \|\| service.RtFlag == "E") ▸ else of (service.RtFlag == "E") ▸ if (service.RtFlag == "S_E") | ENDPOINT | new FoxDataRequest | ("SSP.PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH") ⇒ SSP.PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH | 엔드포인트 요청 생성 |  |  |  |
| AC-d3f0058f | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… 외 1 | SSP0015_ShipmentPSI.cs:7391 | try ▸ if (service.RtFlag == "S_E" \|\| service.RtFlag == "E") ▸ else of (service.RtFlag == "E") ▸ if (service.RtFlag == "S_E") | DATA_OP | request.Parameters["p_change_type"] | "B" | 행/컬럼 값 대입 |  |  |  |
| AC-b24b7b71 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… 외 1 | SSP0015_ShipmentPSI.cs:7392 | try ▸ if (service.RtFlag == "S_E" \|\| service.RtFlag == "E") ▸ else of (service.RtFlag == "E") ▸ if (service.RtFlag == "S_E") | DATA_OP | request.Parameters["p_change_req_no"] | RequestNo | 행/컬럼 값 대입 |  |  |  |
| AC-d92c6512 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… 외 1 | SSP0015_ShipmentPSI.cs:7394 | try ▸ if (service.RtFlag == "S_E" \|\| service.RtFlag == "E") ▸ else of (service.RtFlag == "E") ▸ if (service.RtFlag == "S_E") | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-c6692a91 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… 외 1 | SSP0015_ShipmentPSI.cs:7399 | try ▸ if (service.RtFlag == "S_E" \|\| service.RtFlag == "E") ▸ else of (service.RtFlag == "E") ▸ if (service.RtFlag == "S_E") | CALL_EXT | service.FN_ERP_UIWebService | (RequestNo, "C", "") | ⚠ 의미 확인 필요 |  |  |  |
| AC-f60b252f | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… 외 1 | SSP0015_ShipmentPSI.cs:7405 | try ▸ if (service.RtFlag == "S_E" \|\| service.RtFlag == "E") | DATA_OP | bActiveList.Add | (bFlag) | 데이터 객체 조작/조회 |  |  |  |
| AC-62a07126 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… 외 1 | SSP0015_ShipmentPSI.cs:7410 | try ▸ else of (service.RtFlag == "S_E" \|\| service.RtFlag == "E") ▸ if (service.RtFlag == "F" \|\| service.RtFlag == "C_E") | FLAG | F_CE_requestNo | RequestNo | 화면 필드/플래그 변경 |  |  |  |
| AC-db248ade | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… 외 1 | SSP0015_ShipmentPSI.cs:7419 | try ▸ else of (service.RtFlag == "S_E" \|\| service.RtFlag == "E") ▸ else of (service.RtFlag == "F" \|\| service.RtFlag == "C_E") | ENDPOINT | new FoxDataRequest | ("SSP.PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH") ⇒ SSP.PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH | 엔드포인트 요청 생성 |  |  |  |
| AC-1cf04b12 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… 외 1 | SSP0015_ShipmentPSI.cs:7421 | try ▸ else of (service.RtFlag == "S_E" \|\| service.RtFlag == "E") ▸ else of (service.RtFlag == "F" \|\| service.RtFlag == "C_E") | DATA_OP | request.Parameters["p_change_type"] | "B" | 행/컬럼 값 대입 |  |  |  |
| AC-4e1d5cc4 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… 외 1 | SSP0015_ShipmentPSI.cs:7422 | try ▸ else of (service.RtFlag == "S_E" \|\| service.RtFlag == "E") ▸ else of (service.RtFlag == "F" \|\| service.RtFlag == "C_E") | DATA_OP | request.Parameters["p_change_req_no"] | RequestNo | 행/컬럼 값 대입 |  |  |  |
| AC-a3b4ff65 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… 외 1 | SSP0015_ShipmentPSI.cs:7424 | try ▸ else of (service.RtFlag == "S_E" \|\| service.RtFlag == "E") ▸ else of (service.RtFlag == "F" \|\| service.RtFlag == "C_E") | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-ac033199 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… 외 1 | SSP0015_ShipmentPSI.cs:7429 | try ▸ else of (service.RtFlag == "S_E" \|\| service.RtFlag == "E") ▸ else of (service.RtFlag == "F" \|\| service.RtFlag == "C_E") | CALL_EXT | service.FN_ERP_UIWebService | (RequestNo, "C", "") | ⚠ 의미 확인 필요 |  |  |  |
| AC-215f8c7c | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… 외 1 | SSP0015_ShipmentPSI.cs:7432 | try ▸ else of (service.RtFlag == "S_E" \|\| service.RtFlag == "E") ▸ else of (service.RtFlag == "F" \|\| service.RtFlag == "C_E") | DATA_OP | bActiveList.Add | (bFlag) | 데이터 객체 조작/조회 |  |  |  |
| AC-6df0f1dc | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… 외 1 | SSP0015_ShipmentPSI.cs:7438 |  | RETURN | return bFlag; |  | 처리 중단/반환 |  |  |  |

## SSP0015_ShipmentPSI.GetErpIFCheckNew_

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-af37b68b | (진입점 미연결) | SSP0015_ShipmentPSI.cs:9722 | try | CALL_EXT | service.FN_ERP_UIWebService | (RequestNo, "P", "A") | ⚠ 의미 확인 필요 |  |  |  |
| AC-473bd976 | (진입점 미연결) | SSP0015_ShipmentPSI.cs:9731 | try ▸ if (service.RtFlag == "E" \|\| service.RtFlag == "F" \|\| service.RtFlag == "C_E") | ENDPOINT | new FoxDataRequest | ("SSP.SSP0015_DELETE_SHIPMENT_REQUEST_DRAFTING") ⇒ SSP.SSP0015_DELETE_SHIPMENT_REQUEST_DRAFTING | 엔드포인트 요청 생성 |  |  |  |
| AC-2f0e1581 | (진입점 미연결) | SSP0015_ShipmentPSI.cs:9732 | try ▸ if (service.RtFlag == "E" \|\| service.RtFlag == "F" \|\| service.RtFlag == "C_E") | DATA_OP | request.Parameters["p_change_request_no"] | p_change_request_no | 행/컬럼 값 대입 |  |  |  |
| AC-163bfa2c | (진입점 미연결) | SSP0015_ShipmentPSI.cs:9733 | try ▸ if (service.RtFlag == "E" \|\| service.RtFlag == "F" \|\| service.RtFlag == "C_E") | DATA_OP | request.Parameters["p_user_id"] | UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-04fbc7ee | (진입점 미연결) | SSP0015_ShipmentPSI.cs:9735 | try ▸ if (service.RtFlag == "E" \|\| service.RtFlag == "F" \|\| service.RtFlag == "C_E") | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-0e128b97 | (진입점 미연결) | SSP0015_ShipmentPSI.cs:9746 | try ▸ if (service.RtFlag == "E") | MESSAGE | MessageHelper.GMessageBox | ("MSG00197", new object[] { arg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3106051f | (진입점 미연결) | SSP0015_ShipmentPSI.cs:9753 | try ▸ else of (service.RtFlag == "E") ▸ if (service.RtFlag == "F") | MESSAGE | MessageHelper.GMessageBox | ("MSG00204", new object[] { arg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-1a0b5514 | (진입점 미연결) | SSP0015_ShipmentPSI.cs:9758 | try ▸ else of (service.RtFlag == "E") ▸ else of (service.RtFlag == "F") ▸ if (service.RtFlag == "C_E") | MESSAGE | MessageHelper.GMessageBox | ("MSG00306", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-867c2fe0 | (진입점 미연결) | SSP0015_ShipmentPSI.cs:9769 |  | RETURN | return bFlag; |  | 처리 중단/반환 |  |  |  |

## SSP0015_ShipmentPSI.GetERPInterface

진입점: SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.ActiveSheetIndex == 0) ▸ if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlockYn()) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-38ec6a92 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6541 | try ▸ for (i <= siDetail.ActiveSheet.RowCount - 1) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM \|\| action == CAppSet… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-66ae1bb0 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6551 | try ▸ for (i <= siDetail.ActiveSheet.RowCount - 1) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM \|\| action == CAppSet… | DATA_OP | (siDetail.ActiveSheet.DataSource as DataSet).Tables[0].Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-c5b3d835 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6557 | try ▸ for (i <= siDetail.ActiveSheet.RowCount - 1) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM \|\| action == CAppSet… | MESSAGE | MessageHelper.GMessageBox | ("MSG00247", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-79c0efa9 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6558 | try ▸ for (i <= siDetail.ActiveSheet.RowCount - 1) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM \|\| action == CAppSet… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-b08b1a46 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6566 | try ▸ for (i <= siDetail.ActiveSheet.RowCount - 1) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM \|\| action == CAppSet… | MESSAGE | GSCM.App.Core.Text.MessageHelper.GMessageBox | ("MSG00049", new object[] { "" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-2f26369e | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6567 | try ▸ for (i <= siDetail.ActiveSheet.RowCount - 1) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM \|\| action == CAppSet… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-5b40776e | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6580 | try ▸ if (!string.IsNullOrEmpty(p_confirm_id)) ▸ if (!isResult) | MESSAGE | MessageHelper.GMessageBox | ("MSG00404", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-7d5d6fcb | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6582 | try ▸ if (!string.IsNullOrEmpty(p_confirm_id)) ▸ if (!isResult) | RETURN | return bReturn = false; |  | 처리 중단/반환 |  |  |  |
| AC-7ba4eb9a | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6665 | try ▸ if (errConfirmList.Count > 0) | ENDPOINT | new FoxDataRequest | ("SSP.SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM") ⇒ SSP.SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM | 엔드포인트 요청 생성 |  |  |  |
| AC-bc842939 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6667 | try ▸ if (errConfirmList.Count > 0) | DATA_OP | request.Parameters["p_change_request_no"] | p_change_request_no | 행/컬럼 값 대입 |  |  |  |
| AC-6d4c2c3c | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6668 | try ▸ if (errConfirmList.Count > 0) | DATA_OP | request.Parameters["p_confirm_id"] | p_confirm_id2 | 행/컬럼 값 대입 |  |  |  |
| AC-4a4560aa | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6669 | try ▸ if (errConfirmList.Count > 0) | DATA_OP | request.Parameters["p_e_type"] | "E" | 행/컬럼 값 대입 |  |  |  |
| AC-de563de4 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6670 | try ▸ if (errConfirmList.Count > 0) | DATA_OP | request.Parameters["p_e_message"] | p_e_message | 행/컬럼 값 대입 |  |  |  |
| AC-fc0af03e | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6671 | try ▸ if (errConfirmList.Count > 0) | DATA_OP | request.Parameters["p_last_updated_by"] | UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-9dc3e54a | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6673 | try ▸ if (errConfirmList.Count > 0) | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-534d5692 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6679 | try ▸ if (errConfirmList.Count > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00197", new object[] { arg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6ac09531 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6706 | try ▸ else of (errConfirmList.Count > 0) ▸ if (String.IsNullOrEmpty(F_CE_requestNo) == false) ▸ if (p_confirm_id_F_CE.Length > 0) | ENDPOINT | new FoxDataRequest | ("SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM") ⇒ SSP.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM | 엔드포인트 요청 생성 |  |  |  |
| AC-1697f3df | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6708 | try ▸ else of (errConfirmList.Count > 0) ▸ if (String.IsNullOrEmpty(F_CE_requestNo) == false) ▸ if (p_confirm_id_F_CE.Length > 0) | DATA_OP | request.Parameters["p_confirm_id"] | p_confirm_id_F_CE | 행/컬럼 값 대입 |  |  |  |
| AC-5a4d4433 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6709 | try ▸ else of (errConfirmList.Count > 0) ▸ if (String.IsNullOrEmpty(F_CE_requestNo) == false) ▸ if (p_confirm_id_F_CE.Length > 0) | DATA_OP | request.Parameters["p_change_request_no"] | F_CE_requestNo | 행/컬럼 값 대입 |  |  |  |
| AC-a18123de | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6710 | try ▸ else of (errConfirmList.Count > 0) ▸ if (String.IsNullOrEmpty(F_CE_requestNo) == false) ▸ if (p_confirm_id_F_CE.Length > 0) | DATA_OP | request.Parameters["p_del_flag"] | "D" | 행/컬럼 값 대입 |  |  |  |
| AC-664c47f2 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6711 | try ▸ else of (errConfirmList.Count > 0) ▸ if (String.IsNullOrEmpty(F_CE_requestNo) == false) ▸ if (p_confirm_id_F_CE.Length > 0) | DATA_OP | request.Parameters["p_last_updated_by"] | UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-6857261a | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6712 | try ▸ else of (errConfirmList.Count > 0) ▸ if (String.IsNullOrEmpty(F_CE_requestNo) == false) ▸ if (p_confirm_id_F_CE.Length > 0) | DATA_OP | request.Parameters["p_time_zone"] | UserInfoContext.Current[UserInfoProperites.TimeZone] | 행/컬럼 값 대입 |  |  |  |
| AC-dd52e739 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6713 | try ▸ else of (errConfirmList.Count > 0) ▸ if (String.IsNullOrEmpty(F_CE_requestNo) == false) ▸ if (p_confirm_id_F_CE.Length > 0) | DATA_OP | request.Parameters["p_if_send_flag"] | "Y" | 행/컬럼 값 대입 |  |  |  |
| AC-635c228d | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6714 | try ▸ else of (errConfirmList.Count > 0) ▸ if (String.IsNullOrEmpty(F_CE_requestNo) == false) ▸ if (p_confirm_id_F_CE.Length > 0) | DATA_OP | request.Parameters["p_change_type"] | "C" | 행/컬럼 값 대입 |  |  |  |
| AC-c5a6b814 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6716 | try ▸ else of (errConfirmList.Count > 0) ▸ if (String.IsNullOrEmpty(F_CE_requestNo) == false) ▸ if (p_confirm_id_F_CE.Length > 0) | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-8187590a | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6722 | try ▸ else of (errConfirmList.Count > 0) ▸ if (String.IsNullOrEmpty(F_CE_requestNo) == false) ▸ if (p_confirm_id_F_CE.Length > 0) | CALL_EXT | service.FN_ERP_UIWebService | (F_CE_requestNo, "C", "") | ⚠ 의미 확인 필요 |  |  |  |
| AC-2063b6d5 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6727 | try ▸ else of (errConfirmList.Count > 0) ▸ if (String.IsNullOrEmpty(F_CE_requestNo) == false) | MESSAGE | MessageHelper.GMessageBox | ("MSG00204", new object[] { arg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-869d4c8c | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6733 | catch ((Exception ex)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-9f5ad9db | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6736 | finally | STATE_RESET | bActiveList.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-cb918461 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6737 | finally | STATE_RESET | errConfirmList.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-db4af9c1 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6738 | finally | FLAG | F_CE_requestNo | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-17691383 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6740 |  | RETURN | return bReturn; |  | 처리 중단/반환 |  |  |  |

## SSP0015_ShipmentPSI.GetErpSoNoCnt

진입점: SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.ActiveSheetIndex == 0) ▸ if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlockYn()) ▸ try ▸ try ▸ for (i <= siDetail.ActiveSheet.RowCount - 1) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM \|\| action == CAppSetting.FlagD) ▸ if (!string.IsNullOrWhiteSpace(erpSoNo))] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4011ef21 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… 외 1 | SSP0015_ShipmentPSI.cs:7185 | try | ENDPOINT | new FoxDataRequest | ("SSP.SSP0015_GET_ERP_SO_NO_CNT") ⇒ SSP.SSP0015_GET_ERP_SO_NO_CNT | 엔드포인트 요청 생성 |  |  |  |
| AC-585520d2 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… 외 1 | SSP0015_ShipmentPSI.cs:7186 | try | DATA_OP | request.Parameters["p_division_id"] | sDivisionID | 행/컬럼 값 대입 |  |  |  |
| AC-e4af6c44 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… 외 1 | SSP0015_ShipmentPSI.cs:7187 | try | DATA_OP | request.Parameters["p_erp_so_no"] | sErpSoNo | 행/컬럼 값 대입 |  |  |  |
| AC-10b0621d | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… 외 1 | SSP0015_ShipmentPSI.cs:7189 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-02a2df53 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… 외 1 | SSP0015_ShipmentPSI.cs:7197 | catch ((Exception ex)) | RETURN | return iReturn; |  | 처리 중단/반환 |  |  |  |
| AC-8dea6ae2 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… 외 1 | SSP0015_ShipmentPSI.cs:7199 |  | RETURN | return iReturn; |  | 처리 중단/반환 |  |  |  |

## SSP0015_ShipmentPSI.GetNERPCode

진입점: this.spdMain.CellDoubleClick [else of (siMain.ActiveSheetIndex == 0) ▸ if (siMain.ActiveSheetIndex == 1) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.FIGURE) && sMeasure == "WH_STOCK") ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.FIGURE) && sMeasure == "BALANCE") ▸ try] / this.btnSearch.Click [else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtRequestDetail) ▸ else of (siDetail.ActiveSheet.SheetName == SpdSheet.shtWHstock \|\| siDetail.ActiveShe…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a2afd0cd | this.spdMain.CellDoubleClick [else of (siMain.ActiveSheetInd… 외 4 | SSP0015_ShipmentPSI.cs:2904 | try | ENDPOINT | new FoxDataRequest | ("SSP.SSP0002_GET_NERP_CODE") ⇒ SSP.SSP0002_GET_NERP_CODE | 엔드포인트 요청 생성 |  |  |  |
| AC-a647f25b | this.spdMain.CellDoubleClick [else of (siMain.ActiveSheetInd… 외 4 | SSP0015_ShipmentPSI.cs:2905 | try | DATA_OP | request.Parameters["P_PROCEDURE_KEY"] | sFileName | 행/컬럼 값 대입 |  |  |  |
| AC-f758bb52 | this.spdMain.CellDoubleClick [else of (siMain.ActiveSheetInd… 외 4 | SSP0015_ShipmentPSI.cs:2906 | try | DATA_OP | request.Parameters["P_SEQUENCE"] | sGERPCode | 행/컬럼 값 대입 |  |  |  |
| AC-2ccdc8d2 | this.spdMain.CellDoubleClick [else of (siMain.ActiveSheetInd… 외 4 | SSP0015_ShipmentPSI.cs:2908 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-fef7f3f2 | this.spdMain.CellDoubleClick [else of (siMain.ActiveSheetInd… 외 4 | SSP0015_ShipmentPSI.cs:2916 | catch ((Exception ex)) | RETURN | return sReturn; |  | 처리 중단/반환 |  |  |  |
| AC-92bd6f4f | this.spdMain.CellDoubleClick [else of (siMain.ActiveSheetInd… 외 4 | SSP0015_ShipmentPSI.cs:2918 |  | RETURN | return sReturn; |  | 처리 중단/반환 |  |  |  |

## SSP0015_ShipmentPSI.GetNewERPInterface

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c4806b0a | (진입점 미연결) | SSP0015_ShipmentPSI.cs:9438 | try ▸ for (i <= siDetail.ActiveSheet.RowCount - 1) ▸ if (action == CAppSetting.FlagI) ▸ if (!GetShipmentStatusChk(p_division_id, p_status_ch… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-483019ee | (진입점 미연결) | SSP0015_ShipmentPSI.cs:9448 | try ▸ for (i <= siDetail.ActiveSheet.RowCount - 1) ▸ if (action == CAppSetting.FlagI) ▸ if (!string.IsNullOrWhiteSpace(erpSoNo)) | DATA_OP | (siDetail.ActiveSheet.DataSource as DataSet).Tables[0].Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-4695fb73 | (진입점 미연결) | SSP0015_ShipmentPSI.cs:9460 | try ▸ for (i <= siDetail.ActiveSheet.RowCount - 1) ▸ if (action == CAppSetting.FlagI) ▸ if (!string.IsNullOrWhiteSpace(erpSoNo)) ▸ if (iErpS… | MESSAGE | MessageHelper.GMessageBox | ("MSG00247", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f719b953 | (진입점 미연결) | SSP0015_ShipmentPSI.cs:9461 | try ▸ for (i <= siDetail.ActiveSheet.RowCount - 1) ▸ if (action == CAppSetting.FlagI) ▸ if (!string.IsNullOrWhiteSpace(erpSoNo)) ▸ if (iErpS… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-a16efacc | (진입점 미연결) | SSP0015_ShipmentPSI.cs:9470 | try ▸ for (i <= siDetail.ActiveSheet.RowCount - 1) ▸ if (action == CAppSetting.FlagI) ▸ if (DateTime.TryParse(siDetail.GetText(i, siDetail.G… | MESSAGE | GSCM.App.Core.Text.MessageHelper.GMessageBox | ("MSG00049", new object[] { "" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e0c717fc | (진입점 미연결) | SSP0015_ShipmentPSI.cs:9471 | try ▸ for (i <= siDetail.ActiveSheet.RowCount - 1) ▸ if (action == CAppSetting.FlagI) ▸ if (DateTime.TryParse(siDetail.GetText(i, siDetail.G… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-b1353f22 | (진입점 미연결) | SSP0015_ShipmentPSI.cs:9497 | try ▸ for (i <= siDetail.ActiveSheet.RowCount - 1) ▸ if (string.IsNullOrWhiteSpace(erpSoNo)) ▸ if (this.NewNonSoNo(i, action) == false) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-2c5846c9 | (진입점 미연결) | SSP0015_ShipmentPSI.cs:9506 | catch ((Exception ex)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-b939a966 | (진입점 미연결) | SSP0015_ShipmentPSI.cs:9508 |  | RETURN | return bReturn; |  | 처리 중단/반환 |  |  |  |

## SSP0015_ShipmentPSI.GetShipmentStatusChk

진입점: SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.ActiveSheetIndex == 0) ▸ if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlockYn()) ▸ try ▸ try ▸ for (i <= siDetail.ActiveSheet.RowCount - 1) ▸ if (action == CAppSetting.FlagI \|\| action == CAppSetting.FlagM \|\| action == CAppSetting.FlagD)] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c6a9d647 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… 외 1 | SSP0015_ShipmentPSI.cs:7210 | try | ENDPOINT | new FoxDataRequest | ("SSP.SSP0015_GET_SHIPMENT_STATUS") ⇒ SSP.SSP0015_GET_SHIPMENT_STATUS | 엔드포인트 요청 생성 |  |  |  |
| AC-924fb745 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… 외 1 | SSP0015_ShipmentPSI.cs:7211 | try | DATA_OP | request.Parameters["p_division_id"] | sDivisionID | 행/컬럼 값 대입 |  |  |  |
| AC-500073d3 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… 외 1 | SSP0015_ShipmentPSI.cs:7212 | try | DATA_OP | request.Parameters["p_confirm_id"] | sConfirmID | 행/컬럼 값 대입 |  |  |  |
| AC-84a4529f | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… 외 1 | SSP0015_ShipmentPSI.cs:7214 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-318aa27b | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… 외 1 | SSP0015_ShipmentPSI.cs:7229 | try ▸ if (ds.Tables[0].Rows.Count > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00248", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a7238e08 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… 외 1 | SSP0015_ShipmentPSI.cs:7243 | try ▸ if (ds.Tables[1].Rows.Count > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00249", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-35a89092 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… 외 1 | SSP0015_ShipmentPSI.cs:7259 | try ▸ if (ds.Tables[2].Rows.Count > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00189", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-416bc9b2 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… 외 1 | SSP0015_ShipmentPSI.cs:7264 | catch ((Exception ex)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-8b47d959 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… 외 1 | SSP0015_ShipmentPSI.cs:7266 |  | RETURN | return bReturn; |  | 처리 중단/반환 |  |  |  |

## SSP0015_ShipmentPSI.GetShipToParty

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b9db43f8 | (진입점 미연결) | SSP0015_ShipmentPSI.cs:9232 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SSP0015_ShipmentPSI.GetShipType

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-de7209a8 | (진입점 미연결) | SSP0015_ShipmentPSI.cs:9226 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SSP0015_ShipmentPSI.GetSoldToParty

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-12c21540 | (진입점 미연결) | SSP0015_ShipmentPSI.cs:9238 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SSP0015_ShipmentPSI.GetSpdTitle

진입점: this.Load / this.spdMain.CellDoubleClick [for (i < spdDetail.Sheets.Count)] / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (fps.Name == "spdMain")] / this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ if (siMain.ActiveSheetIndex == 0) ▸ try] / this.spdMain.ActiveSheetChanged / FindButton [if (siMain.ActiveSheetIndex == 0) ▸ try] / SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.Tables[0].Rows[0][0].ToString()…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-700b4ead | this.Load 외 7 | SSP0015_ShipmentPSI.cs:9247 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN") ⇒ SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | 엔드포인트 요청 생성 |  |  |  |
| AC-47c42b3a | this.Load 외 7 | SSP0015_ShipmentPSI.cs:9252 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | drpPeriod.Text1.Replace("-", "") | 행/컬럼 값 대입 |  |  |  |
| AC-4b90cbb7 | this.Load 외 7 | SSP0015_ShipmentPSI.cs:9253 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | drpPeriod.Text2.Replace("-", "") | 행/컬럼 값 대입 |  |  |  |
| AC-3f315736 | this.Load 외 7 | SSP0015_ShipmentPSI.cs:9255 |  | FLAG | dsSpdTitle | client.ExecuteDataSet(request).DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-ffe34840 | this.Load 외 7 | SSP0015_ShipmentPSI.cs:9255 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## SSP0015_ShipmentPSI.GetSSPUserCheck

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cf21ba02 | EditButton | SSP0015_ShipmentPSI.cs:9901 |  | ENDPOINT | new FoxDataRequest | ("SSP.SSP0002_GET_USER_INFO_LIST") ⇒ SSP.SSP0002_GET_USER_INFO_LIST | 엔드포인트 요청 생성 |  |  |  |
| AC-1ddd3c7d | EditButton | SSP0015_ShipmentPSI.cs:9905 |  | DATA_OP | request.Parameters["Search"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-f5d2242d | EditButton | SSP0015_ShipmentPSI.cs:9906 |  | DATA_OP | request.Parameters["Language"] | UserInfoContext.Current[UserInfoProperites.Language].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-4cc74c02 | EditButton | SSP0015_ShipmentPSI.cs:9907 |  | DATA_OP | request.Parameters["SSOUserYN"] | "N" | 행/컬럼 값 대입 |  |  |  |
| AC-d276ab30 | EditButton | SSP0015_ShipmentPSI.cs:9908 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-cd7a1b53 | EditButton | SSP0015_ShipmentPSI.cs:9912 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-9f354458 | EditButton | SSP0015_ShipmentPSI.cs:9916 |  | RETURN | return isResult; |  | 처리 중단/반환 |  |  |  |

## SSP0015_ShipmentPSI.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-028a10ef | this.Load | SSP0015_ShipmentPSI.cs:548 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-588c1434 | this.Load | SSP0015_ShipmentPSI.cs:551 |  | DATA_OP | ReadOnlySheetList.Add | (SpdSheet.shtWHstock) | 데이터 객체 조작/조회 |  |  |  |
| AC-57f1e15f | this.Load | SSP0015_ShipmentPSI.cs:552 |  | DATA_OP | ReadOnlySheetList.Add | (SpdSheet.shtWHstockDetail) | 데이터 객체 조작/조회 |  |  |  |
| AC-3c1d02af | this.Load | SSP0015_ShipmentPSI.cs:555 |  | DATA_OP | this.ConditionNotUseList.Add | (cboPlanDate) | 데이터 객체 조작/조회 |  |  |  |
| AC-a8ab9c93 | this.Load | SSP0015_ShipmentPSI.cs:558 | if (dtMyDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |
| AC-311a4d0e | this.Load | SSP0015_ShipmentPSI.cs:562 |  | LIST_REBIND | clsCtrl.setListBox | (dtMyDivision, clbDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-17eaad3d | this.Load | SSP0015_ShipmentPSI.cs:565 |  | VALUE_SET | clbDivision.ControlValues | "40" | 컨트롤 값 설정 |  |  |  |
| AC-60b3a534 | this.Load | SSP0015_ShipmentPSI.cs:566 |  | STATE | clbDivision.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-93ebc52b | this.Load | SSP0015_ShipmentPSI.cs:568 |  | FLAG | dtNewPlanDate | Data.Common(Data.Type.PlanDateShip, false, "40", "A") ⇒ biz:CommonData.CommonDataList [code=PlanDateShip] | 화면 필드/플래그 변경 |  |  |  |
| AC-afd306e8 | this.Load | SSP0015_ShipmentPSI.cs:568 |  | COMBO_DATA | Data.Common | (Data.Type.PlanDateShip, false, "40", "A") ⇒ biz:CommonData.CommonDataList [code=PlanDateShip] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-aa2900f8 | this.Load | SSP0015_ShipmentPSI.cs:572 |  | VALUE_SET | drpPeriod.InitValue | GetDayRange("A") | 컨트롤 값 설정 |  |  |  |
| AC-d2252611 | this.Load | SSP0015_ShipmentPSI.cs:573 |  | VALUE_SET | drpPeriod2.InitValue | GetDayRange("A") | 컨트롤 값 설정 |  |  |  |
| AC-6b20c4e6 | this.Load | SSP0015_ShipmentPSI.cs:574 |  | VALUE_SET | drpPeriod3.InitValue | ShipmentResult_GetDayRange() | 컨트롤 값 설정 |  |  |  |
| AC-b3bb0324 | this.Load | SSP0015_ShipmentPSI.cs:576 |  | FLAG | dtBucketType | GetBucketType() | 화면 필드/플래그 변경 |  |  |  |
| AC-a4ec4010 | this.Load | SSP0015_ShipmentPSI.cs:577 |  | LIST_REBIND | clsCtrl.setListBox | (dtBucketType, cboBucketType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-84921775 | this.Load | SSP0015_ShipmentPSI.cs:579 |  | FLAG | sLanguage | UserInfoContext.Current[UserInfoProperites.Language] | 화면 필드/플래그 변경 |  |  |  |
| AC-26968800 | this.Load | SSP0015_ShipmentPSI.cs:582 |  | FLAG | sRequestor | UserInfoContext.Current.UserId | 화면 필드/플래그 변경 |  |  |  |
| AC-33108a18 | this.Load | SSP0015_ShipmentPSI.cs:584 |  | FLAG | sGroupID | UserInfoContext.Current["NowGroupID"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-ba9aae67 | this.Load | SSP0015_ShipmentPSI.cs:585 |  | FLAG | drPgmAuthId | dtPgmAuthId.Select().Where(c => c["CODE"].ToString() == "SSP0015" && c["NAME"].ToString() … | 화면 필드/플래그 변경 |  |  |  |
| AC-63b1cf08 | this.Load | SSP0015_ShipmentPSI.cs:585 |  | DATA_OP | dtPgmAuthId.Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-50b8fc2c | this.Load | SSP0015_ShipmentPSI.cs:588 | if (dtBaseDay.Rows.Count > 0) | FLAG | dDay | Convert.ToDouble(dtBaseDay.Rows[0][1]) | 화면 필드/플래그 변경 |  |  |  |
| AC-3dd49ec5 | this.Load | SSP0015_ShipmentPSI.cs:590 |  | FLAG | dBaseDate | Convert.ToDateTime(Convert.ToDateTime(DateTime.Now).ToString()).AddDays(dDay) | 화면 필드/플래그 변경 |  |  |  |
| AC-07737418 | this.Load | SSP0015_ShipmentPSI.cs:593 |  | VALUE_SET | chkMyModel.Checked | false | 컨트롤 값 설정 |  |  |  |
| AC-d486074f | this.Load | SSP0015_ShipmentPSI.cs:599 | if (dtMyModelChk.Rows.Count > 0 && drPgmAuthId != null) | DATA_OP | dtMyModelChk.Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-82b0b63b | this.Load | SSP0015_ShipmentPSI.cs:602 | if (dtMyModelChk.Rows.Count > 0 && drPgmAuthId != null) ▸ if (dr != null) | VALUE_SET | chkMyModel.Checked | true | 컨트롤 값 설정 |  |  |  |
| AC-6bbe4971 | this.Load | SSP0015_ShipmentPSI.cs:613 | if (dtShipmentInputPeriod.Rows.Count > 0) | FLAG | dateMaxShipDate | Convert.ToDateTime(dtShipmentInputPeriod.Rows[0]["VALUE"].ToString()) | 화면 필드/플래그 변경 |  |  |  |
| AC-2a888098 | this.Load | SSP0015_ShipmentPSI.cs:614 | if (dtShipmentInputPeriod.Rows.Count > 0) | FLAG | dateMinShipDate | Convert.ToDateTime(dtShipmentInputPeriod.Rows[1]["VALUE"].ToString()) | 화면 필드/플래그 변경 |  |  |  |
| AC-44716084 | this.Load | SSP0015_ShipmentPSI.cs:615 | if (dtShipmentInputPeriod.Rows.Count > 0) | FLAG | strDiffMaxDay | dtShipmentInputPeriod.Rows[0]["Diff_VALUE"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-ef6b0c3b | this.Load | SSP0015_ShipmentPSI.cs:616 | if (dtShipmentInputPeriod.Rows.Count > 0) | FLAG | strDiffMinDay | dtShipmentInputPeriod.Rows[1]["Diff_VALUE"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-9dffd761 | this.Load | SSP0015_ShipmentPSI.cs:628 | if (drPgmAuthId != null) | DATA_OP | contextMenu.MenuItems.Add | ("&Memo", new EventHandler(TsmNotepad_Click)) | 데이터 객체 조작/조회 |  |  |  |
| AC-19a44768 | this.Load | SSP0015_ShipmentPSI.cs:632 | else of (drPgmAuthId != null) | UI_PROP | layoutControlItem1.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-b09d3d85 | this.Load | SSP0015_ShipmentPSI.cs:633 | else of (drPgmAuthId != null) | UI_PROP | layoutControlItem12.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-d36b64c9 | this.Load | SSP0015_ShipmentPSI.cs:634 | else of (drPgmAuthId != null) | UI_PROP | layoutControlItem13.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-ea5b5855 | this.Load | SSP0015_ShipmentPSI.cs:635 | else of (drPgmAuthId != null) | UI_PROP | layoutControlItem16.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-850cd346 | this.Load | SSP0015_ShipmentPSI.cs:642 |  | LIST_REBIND | clsCtrl.setListBox | (dtResultType, clbResultType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-fecb5798 | this.Load | SSP0015_ShipmentPSI.cs:643 |  | UI_PROP | layoutControlItem14.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-1c2e73b0 | this.Load | SSP0015_ShipmentPSI.cs:644 |  | UI_PROP | layoutControlItem15.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-82f3427f | this.Load | SSP0015_ShipmentPSI.cs:645 |  | UI_PROP | layoutControlItem17.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-81a79c5a | this.Load | SSP0015_ShipmentPSI.cs:648 |  | UI_PROP | layoutControlItem17.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-a1983cb4 | this.Load | SSP0015_ShipmentPSI.cs:649 |  | UI_PROP | layoutControlItem17.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |

## SSP0015_ShipmentPSI.InitSpread

진입점: this.Load / this.spdMain.CellDoubleClick [for (i < spdDetail.Sheets.Count)] / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (fps.Name == "spdMain")] / this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ if (siMain.ActiveSheetIndex == 0) ▸ try] / this.spdMain.ActiveSheetChanged / FindButton [if (siMain.ActiveSheetIndex == 0) ▸ try] / SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.Tables[0].Rows[0][0].ToString()…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9a743d84 | this.Load 외 7 | SSP0015_ShipmentPSI.cs:757 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.InitSheet | (SpdSheet.shtMain) | 그리드 재구성/초기화 |  |  |  |
| AC-627fc6f6 | this.Load 외 7 | SSP0015_ShipmentPSI.cs:759 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.SetSheetHeaderColumn | (spdInfo, 3) | 그리드 재구성/초기화 |  |  |  |
| AC-118fcd25 | this.Load 외 7 | SSP0015_ShipmentPSI.cs:763 | if (spdInfo.SheetName == SpdSheet.shtMain) | CALL_EXT | clsCtrl.HeaderSpan | (siMain, 0, siMain.GetColumnIndex(DefColumns.TYPE), 3, 2, "BOH") | ⚠ 의미 확인 필요 |  |  |  |
| AC-2cdf2ac3 | this.Load 외 7 | SSP0015_ShipmentPSI.cs:771 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f96bb8d5 | this.Load 외 7 | SSP0015_ShipmentPSI.cs:773 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-3be24b3d | this.Load 외 7 | SSP0015_ShipmentPSI.cs:776 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Columns[DefColumns.TYPE].MergePolicy | MergePolicy.Always | 그리드 속성/값 설정 |  |  |  |
| AC-f2e8c35d | this.Load 외 7 | SSP0015_ShipmentPSI.cs:778 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Columns[DefColumns.PSI_NAME].MergePolicy | MergePolicy.Always | 그리드 속성/값 설정 |  |  |  |
| AC-ff3d5afc | this.Load 외 7 | SSP0015_ShipmentPSI.cs:784 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (spdInfo.SheetName == SpdSheet.shtPacker) | GRID_INIT | spdInfo.InitSheet | (SpdSheet.shtPacker) | 그리드 재구성/초기화 |  |  |  |
| AC-f4a87e92 | this.Load 외 7 | SSP0015_ShipmentPSI.cs:786 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (spdInfo.SheetName == SpdSheet.shtPacker) | GRID_INIT | spdInfo.SetSheetHeaderColumn | (spdInfo, 3) | 그리드 재구성/초기화 |  |  |  |
| AC-9b02a57c | this.Load 외 7 | SSP0015_ShipmentPSI.cs:790 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (spdInfo.SheetName == SpdSheet.shtPacker) | CALL_EXT | clsCtrl.HeaderSpan | (siMain, 0, siMain.GetColumnIndex(DefColumns.TYPE), 3, 2, "BOH") | ⚠ 의미 확인 필요 |  |  |  |
| AC-25684eb4 | this.Load 외 7 | SSP0015_ShipmentPSI.cs:798 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (spdInfo.SheetName == SpdSheet.shtPacker) | GRID_INIT | spdInfo.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-92f29b03 | this.Load 외 7 | SSP0015_ShipmentPSI.cs:800 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (spdInfo.SheetName == SpdSheet.shtPacker) | GRID_INIT | spdInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-4051c415 | this.Load 외 7 | SSP0015_ShipmentPSI.cs:803 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (spdInfo.SheetName == SpdSheet.shtPacker) | GRID_SET | siMain.ActiveSheet.Columns[DefColumns.TYPE].MergePolicy | MergePolicy.Always | 그리드 속성/값 설정 |  |  |  |
| AC-96ae040a | this.Load 외 7 | SSP0015_ShipmentPSI.cs:805 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (spdInfo.SheetName == SpdSheet.shtPacker) | GRID_SET | siMain.ActiveSheet.Columns[DefColumns.PSI_NAME].MergePolicy | MergePolicy.Always | 그리드 속성/값 설정 |  |  |  |
| AC-de2add8f | this.Load 외 7 | SSP0015_ShipmentPSI.cs:809 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPacker) ▸ if (spdInfo.SheetName == SpdSheet.shtD… | GRID_INIT | spdInfo.InitSheet | (spdInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-aa23b935 | this.Load 외 7 | SSP0015_ShipmentPSI.cs:811 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPacker) ▸ if (spdInfo.SheetName == SpdSheet.shtD… | GRID_INIT | spdInfo.SetSheetHeaderColumn | (spdInfo, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-059d1162 | this.Load 외 7 | SSP0015_ShipmentPSI.cs:813 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPacker) ▸ if (spdInfo.SheetName == SpdSheet.shtD… | LIST_REBIND | SpreadInfo.SetComBoParam | ("CHANGE_REASON_CODE_ALL", dtChangeReasonCode) | 목록 컨트롤 재구성 |  |  |  |
| AC-661e2a5b | this.Load 외 7 | SSP0015_ShipmentPSI.cs:815 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPacker) ▸ if (spdInfo.SheetName == SpdSheet.shtD… | GRID_INIT | spdInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-469a1d0f | this.Load 외 7 | SSP0015_ShipmentPSI.cs:826 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPacker) ▸ else of (spdInfo.SheetName == SpdSheet… | GRID_INIT | siDetail.SetSheetHeaderColumn | (siDetail, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-32e8e07a | this.Load 외 7 | SSP0015_ShipmentPSI.cs:837 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPacker) ▸ else of (spdInfo.SheetName == SpdSheet… | STATE | sv.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-cfcf8a10 | this.Load 외 7 | SSP0015_ShipmentPSI.cs:841 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPacker) ▸ else of (spdInfo.SheetName == SpdSheet… | STATE | sv.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-fd26a95a | this.Load 외 7 | SSP0015_ShipmentPSI.cs:851 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPacker) ▸ else of (spdInfo.SheetName == SpdSheet… | GRID_INIT | spdInfo.InitSheet | (spdInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-535970e7 | this.Load 외 7 | SSP0015_ShipmentPSI.cs:853 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPacker) ▸ else of (spdInfo.SheetName == SpdSheet… | GRID_INIT | spdInfo.SetSheetHeaderColumn | (spdInfo, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-7a612c95 | this.Load 외 7 | SSP0015_ShipmentPSI.cs:855 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPacker) ▸ else of (spdInfo.SheetName == SpdSheet… | LIST_REBIND | SpreadInfo.SetComBoParam | ("LookupCommon3", dtStockStatus) | 목록 컨트롤 재구성 |  |  |  |
| AC-c586896f | this.Load 외 7 | SSP0015_ShipmentPSI.cs:857 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPacker) ▸ else of (spdInfo.SheetName == SpdSheet… | GRID_INIT | spdInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-18284d73 | this.Load 외 7 | SSP0015_ShipmentPSI.cs:864 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPacker) ▸ else of (spdInfo.SheetName == SpdSheet… | GRID_INIT | spdInfo.InitSheet | (spdInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-a424ea1a | this.Load 외 7 | SSP0015_ShipmentPSI.cs:866 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPacker) ▸ else of (spdInfo.SheetName == SpdSheet… | GRID_INIT | spdInfo.SetSheetHeaderColumn | (spdInfo, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-bec454a7 | this.Load 외 7 | SSP0015_ShipmentPSI.cs:868 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPacker) ▸ else of (spdInfo.SheetName == SpdSheet… | LIST_REBIND | SpreadInfo.SetComBoParam | ("LookupCommon3", dtStockStatus) | 목록 컨트롤 재구성 |  |  |  |
| AC-9cf10b19 | this.Load 외 7 | SSP0015_ShipmentPSI.cs:870 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPacker) ▸ else of (spdInfo.SheetName == SpdSheet… | GRID_INIT | spdInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-9826f599 | this.Load 외 7 | SSP0015_ShipmentPSI.cs:877 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPacker) ▸ else of (spdInfo.SheetName == SpdSheet… | GRID_INIT | spdInfo.InitSheet | (spdInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-03fd596e | this.Load 외 7 | SSP0015_ShipmentPSI.cs:879 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPacker) ▸ else of (spdInfo.SheetName == SpdSheet… | GRID_INIT | spdInfo.SetSheetHeaderColumn | (spdInfo, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-9ddd56a0 | this.Load 외 7 | SSP0015_ShipmentPSI.cs:881 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPacker) ▸ else of (spdInfo.SheetName == SpdSheet… | GRID_INIT | spdInfo.SetReNumerCellType | (spdInfo, spdInfo.GetColumnIndex(DefColumns.HOLD_QTY), -9999999, 0, 999999999) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-9d6dafdd | this.Load 외 7 | SSP0015_ShipmentPSI.cs:883 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPacker) ▸ else of (spdInfo.SheetName == SpdSheet… | GRID_INIT | spdInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-ec2396f4 | this.Load 외 7 | SSP0015_ShipmentPSI.cs:890 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPacker) ▸ else of (spdInfo.SheetName == SpdSheet… | GRID_INIT | spdInfo.InitSheet | (spdInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-87c3e2f1 | this.Load 외 7 | SSP0015_ShipmentPSI.cs:892 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPacker) ▸ else of (spdInfo.SheetName == SpdSheet… | GRID_INIT | spdInfo.SetSheetHeaderColumn | (spdInfo, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-29f26d6f | this.Load 외 7 | SSP0015_ShipmentPSI.cs:894 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPacker) ▸ else of (spdInfo.SheetName == SpdSheet… | GRID_INIT | spdInfo.SetReNumerCellType | (spdInfo, spdInfo.GetColumnIndex(DefColumns.HOLD_QTY), -9999999, 0, 999999999) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-2bde8709 | this.Load 외 7 | SSP0015_ShipmentPSI.cs:896 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPacker) ▸ else of (spdInfo.SheetName == SpdSheet… | GRID_INIT | spdInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-f213243f | this.Load 외 7 | SSP0015_ShipmentPSI.cs:903 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPacker) ▸ else of (spdInfo.SheetName == SpdSheet… | GRID_INIT | spdInfo.InitSheet | (spdInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-c6419101 | this.Load 외 7 | SSP0015_ShipmentPSI.cs:905 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPacker) ▸ else of (spdInfo.SheetName == SpdSheet… | GRID_INIT | spdInfo.SetSheetHeaderColumn | (spdInfo, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-a718d98e | this.Load 외 7 | SSP0015_ShipmentPSI.cs:907 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPacker) ▸ else of (spdInfo.SheetName == SpdSheet… | GRID_INIT | spdInfo.SetReNumerCellType | (spdInfo, spdInfo.GetColumnIndex(DefColumns.LOT_QTY), -9999999, 0, 999999999) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-a4d9b366 | this.Load 외 7 | SSP0015_ShipmentPSI.cs:909 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPacker) ▸ else of (spdInfo.SheetName == SpdSheet… | GRID_INIT | spdInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-f4c7ea83 | this.Load 외 7 | SSP0015_ShipmentPSI.cs:916 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPacker) ▸ else of (spdInfo.SheetName == SpdSheet… | GRID_INIT | spdInfo.InitSheet | (spdInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-f9982ad8 | this.Load 외 7 | SSP0015_ShipmentPSI.cs:918 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPacker) ▸ else of (spdInfo.SheetName == SpdSheet… | GRID_INIT | spdInfo.SetSheetHeaderColumn | (spdInfo, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-1ba2fb0e | this.Load 외 7 | SSP0015_ShipmentPSI.cs:928 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPacker) ▸ else of (spdInfo.SheetName == SpdSheet… | STATE | sv.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-1cfd4a72 | this.Load 외 7 | SSP0015_ShipmentPSI.cs:932 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPacker) ▸ else of (spdInfo.SheetName == SpdSheet… | STATE | sv.Visible | true | 컨트롤 상태 Visible |  |  |  |
| AC-168ef3cf | this.Load 외 7 | SSP0015_ShipmentPSI.cs:933 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPacker) ▸ else of (spdInfo.SheetName == SpdSheet… | GRID_INIT | spdInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-804a4315 | this.Load 외 7 | SSP0015_ShipmentPSI.cs:939 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPacker) ▸ else of (spdInfo.SheetName == SpdSheet… | GRID_INIT | spdInfo.InitSheet | (spdInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-b12d09e1 | this.Load 외 7 | SSP0015_ShipmentPSI.cs:941 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPacker) ▸ else of (spdInfo.SheetName == SpdSheet… | GRID_INIT | spdInfo.SetSheetHeaderColumn | (spdInfo, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-6752e33e | this.Load 외 7 | SSP0015_ShipmentPSI.cs:951 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPacker) ▸ else of (spdInfo.SheetName == SpdSheet… | STATE | sv.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-137dc3c4 | this.Load 외 7 | SSP0015_ShipmentPSI.cs:955 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPacker) ▸ else of (spdInfo.SheetName == SpdSheet… | STATE | sv.Visible | true | 컨트롤 상태 Visible |  |  |  |
| AC-74624637 | this.Load 외 7 | SSP0015_ShipmentPSI.cs:956 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPacker) ▸ else of (spdInfo.SheetName == SpdSheet… | GRID_INIT | spdInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-03588704 | this.Load 외 7 | SSP0015_ShipmentPSI.cs:965 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPacker) ▸ else of (spdInfo.SheetName == SpdSheet… | GRID_INIT | spdInfo.InitSheet | (spdInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-f621caca | this.Load 외 7 | SSP0015_ShipmentPSI.cs:967 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPacker) ▸ else of (spdInfo.SheetName == SpdSheet… | GRID_INIT | spdInfo.SetSheetHeaderColumn | (spdInfo, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-26d2254e | this.Load 외 7 | SSP0015_ShipmentPSI.cs:969 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPacker) ▸ else of (spdInfo.SheetName == SpdSheet… | GRID_INIT | spdInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-932f9366 | this.Load 외 7 | SSP0015_ShipmentPSI.cs:976 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPacker) ▸ else of (spdInfo.SheetName == SpdSheet… | GRID_INIT | spdInfo.InitSheet | (spdInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-fd657c25 | this.Load 외 7 | SSP0015_ShipmentPSI.cs:978 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPacker) ▸ else of (spdInfo.SheetName == SpdSheet… | GRID_INIT | spdInfo.SetSheetHeaderColumn | (spdInfo, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-ceff17e8 | this.Load 외 7 | SSP0015_ShipmentPSI.cs:983 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPacker) ▸ else of (spdInfo.SheetName == SpdSheet… | GRID_INIT | spdInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SSP0015_ShipmentPSI.InitSpreadDateColumn

진입점: this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] / this.spdMain.CellDoubleClick [for (i < spdDetail.Sheets.Count) ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (fps.Name == "spdMain") ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ if (siMain.ActiveSheetIndex == 0) ▸ try ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / this.spdMain.ActiveSheetChanged [if (spdInfo.SheetName == SpdSheet.shtMain)] / FindButton [if (siMain.ActiveSheetIndex ==…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-26820308 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 7 | SSP0015_ShipmentPSI.cs:1110 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sColumnName.IndexOf("B_") > 0) | GRID_INIT | spdInfo.AddTextColumn | (sColumnLabelname, sColumnName, FPMerge.None, 0, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-77b660fd | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 7 | SSP0015_ShipmentPSI.cs:1114 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sColumnName.IndexOf("B_") > 0) | GRID_INIT | spdInfo.AddNumColumn | (sColumnLabelname, sColumnName, FPMerge.None, 70, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8cefe71a | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 7 | SSP0015_ShipmentPSI.cs:1118 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sColumnName.IndexOf("B_") > 0) ▸ if (sDayCode == DefColumnsLabel.Saturday \|\| … | GRID_SET | spdInfo.Sheet().ColumnHeader.Cells[2, spdInfo.GetMaxColumnIndex()].ForeColor | sDayCode == DefColumnsLabel.Saturday ? Color.Blue : Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-b27e1d6c | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 7 | SSP0015_ShipmentPSI.cs:1125 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-dc433cfb | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 7 | SSP0015_ShipmentPSI.cs:1126 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1a4bb972 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 7 | SSP0015_ShipmentPSI.cs:1131 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e6644d0d | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 7 | SSP0015_ShipmentPSI.cs:1132 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 30, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b460163e | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 7 | SSP0015_ShipmentPSI.cs:1140 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName != sSmallLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9ece1f19 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 7 | SSP0015_ShipmentPSI.cs:1141 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName != sSmallLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-34946ec8 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 7 | SSP0015_ShipmentPSI.cs:1151 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7fac3415 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 7 | SSP0015_ShipmentPSI.cs:1152 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3e320edd | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 7 | SSP0015_ShipmentPSI.cs:1153 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e808ea7b | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 7 | SSP0015_ShipmentPSI.cs:1154 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |

## SSP0015_ShipmentPSI.InitSpreadFooterSum

진입점: this.Load [else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPacker) ▸ if (spdInfo.SheetName == SpdSheet.shtDetail)] / this.spdMain.CellDoubleClick [for (i < spdDetail.Sheets.Count) ▸ else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPacker) ▸ if (spdInfo.SheetName == SpdSheet.shtDetail)] / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (fps.Name == "spdMain") ▸ else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPacker) ▸ if (spdInfo.SheetName == Sp…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-94dce1cd | this.Load [else of (spdInfo.SheetName == SpdSheet.shtMain) ▸… 외 7 | SSP0015_ShipmentPSI.cs:1027 |  | GRID_SET | siDetail.ActiveSheet.ColumnFooter.Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-41c5923e | this.Load [else of (spdInfo.SheetName == SpdSheet.shtMain) ▸… 외 7 | SSP0015_ShipmentPSI.cs:1028 |  | GRID_SET | siDetail.ActiveSheet.ColumnFooter.Cells[0, 1].Value | "Sum" | 그리드 속성/값 설정 |  |  |  |
| AC-9ee500a2 | this.Load [else of (spdInfo.SheetName == SpdSheet.shtMain) ▸… 외 7 | SSP0015_ShipmentPSI.cs:1068 | for (iCol <= siDetail.GetMaxColumnIndex()) | CALL_EXT | siDetail.ActiveSheet.ColumnFooter.SetAggregationFormat | (0, iCol, "{0:#,##0.###}") | ⚠ 의미 확인 필요 |  |  |  |
| AC-de9abb8b | this.Load [else of (spdInfo.SheetName == SpdSheet.shtMain) ▸… 외 7 | SSP0015_ShipmentPSI.cs:1069 | for (iCol <= siDetail.GetMaxColumnIndex()) | CALL_EXT | siDetail.ActiveSheet.ColumnFooter.SetAggregationType | (0, iCol, FarPoint.Win.Spread.Model.AggregationType.SumIgnoreHidden) | ⚠ 의미 확인 필요 |  |  |  |
| AC-0b33bd48 | this.Load [else of (spdInfo.SheetName == SpdSheet.shtMain) ▸… 외 7 | SSP0015_ShipmentPSI.cs:1070 | for (iCol <= siDetail.GetMaxColumnIndex()) | GRID_SET | siDetail.ActiveSheet.ColumnFooter.Cells[0, iCol].BackColor | Color.LightGray | 그리드 속성/값 설정 |  |  |  |
| AC-eabac7b7 | this.Load [else of (spdInfo.SheetName == SpdSheet.shtMain) ▸… 외 7 | SSP0015_ShipmentPSI.cs:1071 | for (iCol <= siDetail.GetMaxColumnIndex()) | GRID_SET | siDetail.ActiveSheet.ColumnFooter.Cells[0, iCol].Border | bevelbrdr | 그리드 속성/값 설정 |  |  |  |

## SSP0015_ShipmentPSI.InitSpreadFooterSum_Detail

진입점: this.Load [else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPacker) ▸ else of (spdInfo.SheetName == SpdSheet.shtDetail) ▸ if (spdInfo.SheetName == SpdSheet.shtRequestDetail)] / this.spdMain.CellDoubleClick [for (i < spdDetail.Sheets.Count) ▸ else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPacker) ▸ else of (spdInfo.SheetName == SpdSheet.shtDetail) ▸ if (spdInfo.SheetName == SpdSheet.shtRequestDetail)] / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (fps.Name == "spdMain") ▸ else of (sp…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9b1e6704 | this.Load [else of (spdInfo.SheetName == SpdSheet.shtMain) ▸… 외 7 | SSP0015_ShipmentPSI.cs:9403 |  | GRID_SET | siDetail.ActiveSheet.ColumnFooter.Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-b3348170 | this.Load [else of (spdInfo.SheetName == SpdSheet.shtMain) ▸… 외 7 | SSP0015_ShipmentPSI.cs:9404 |  | GRID_SET | siDetail.ActiveSheet.ColumnFooter.Cells[0, 1].Value | "Sum" | 그리드 속성/값 설정 |  |  |  |

## SSP0015_ShipmentPSI.InsertRow

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ff32790b | InsertButton | SSP0015_ShipmentPSI.cs:7694 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtBolckS…) | DATA_OP | siDetail.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-a99969cb | InsertButton | SSP0015_ShipmentPSI.cs:7699 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtBolckS…) | UI_MISC | siDetail.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-9319c3c0 | InsertButton | SSP0015_ShipmentPSI.cs:7704 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtBolckS…) | GRID_SET | siDetail.SetValue | (siDetail.ActiveRowIndex, siDetail.GetColumnIndex(DefColumns.DIVISION_ID), siMain.GetValue… | 그리드 값 설정 |  |  |  |
| AC-3ce71ddf | InsertButton | SSP0015_ShipmentPSI.cs:7705 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtBolckS…) | GRID_SET | siDetail.SetValue | (siDetail.ActiveRowIndex, siDetail.GetColumnIndex(DefColumns.FROM_SITE), siMain.GetValue(s… | 그리드 값 설정 |  |  |  |
| AC-d40bc0c9 | InsertButton | SSP0015_ShipmentPSI.cs:7706 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtBolckS…) | GRID_SET | siDetail.SetValue | (siDetail.ActiveRowIndex, siDetail.GetColumnIndex(DefColumns.FROM_SITE_NM), siMain.GetValu… | 그리드 값 설정 |  |  |  |
| AC-36403820 | InsertButton | SSP0015_ShipmentPSI.cs:7707 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtBolckS…) | GRID_SET | siDetail.SetValue | (siDetail.ActiveRowIndex, siDetail.GetColumnIndex(DefColumns.ITEM_ID), siMain.GetValue(siM… | 그리드 값 설정 |  |  |  |
| AC-9a673dbb | InsertButton | SSP0015_ShipmentPSI.cs:7708 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtBolckS…) | GRID_SET | siDetail.SetValue | (siDetail.ActiveRowIndex, siDetail.GetColumnIndex(DefColumns.NICK_NAME), siMain.GetValue(s… | 그리드 값 설정 |  |  |  |
| AC-ed2731dd | InsertButton | SSP0015_ShipmentPSI.cs:7710 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtBolckS…) | GRID_LOCK | siDetail.LockRange | (siDetail.ActiveRowIndex, siDetail.GetColumnIndex(DefColumns.DIVISION_ID), siDetail.Active… | 그리드 편집 잠금/해제 |  |  |  |
| AC-2921cb41 | InsertButton | SSP0015_ShipmentPSI.cs:7711 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtBolckS…) | GRID_LOCK | siDetail.LockRange | (siDetail.ActiveRowIndex, siDetail.GetColumnIndex(DefColumns.LAST_UPDATED_BY), siDetail.Ac… | 그리드 편집 잠금/해제 |  |  |  |
| AC-cd6bec62 | InsertButton | SSP0015_ShipmentPSI.cs:7713 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtBolckS…) | GRID_SET | siDetail.SetValue | (siDetail.ActiveRowIndex, siDetail.GetColumnIndex(DefColumns.HOLD_YYYYMMDD), DateTime.Now.… | 그리드 값 설정 |  |  |  |
| AC-66e16154 | InsertButton | SSP0015_ShipmentPSI.cs:7713 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtBolckS…) | CALL_EXT | DateTime.Now.ToShortDateString | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-58f51573 | InsertButton | SSP0015_ShipmentPSI.cs:7718 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtBolckS…) ▸ if (si… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ba2f0168 | InsertButton | SSP0015_ShipmentPSI.cs:7795 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtBolckS…) ▸ if (si… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7ba1e016 | InsertButton | SSP0015_ShipmentPSI.cs:7797 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtBolckS…) ▸ if (si… | DATA_OP | siDetail.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-0fdaa6f1 | InsertButton | SSP0015_ShipmentPSI.cs:7800 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtBolckS…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.DIVISION_ID, DIVISION_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-415be15f | InsertButton | SSP0015_ShipmentPSI.cs:7801 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtBolckS…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.ITEM_ID, ITEM_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-b1091cc5 | InsertButton | SSP0015_ShipmentPSI.cs:7802 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtBolckS…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.NICK_NAME, NICK_NAME) | 데이터 객체 조작/조회 |  |  |  |
| AC-29543205 | InsertButton | SSP0015_ShipmentPSI.cs:7803 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtBolckS…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.TO_SITE_DESCRIPTION, TO_SITE_DESCRIPTION) | 데이터 객체 조작/조회 |  |  |  |
| AC-a97fa012 | InsertButton | SSP0015_ShipmentPSI.cs:7804 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtBolckS…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.END_CUSTOMER, PROJECT_CODE) | 데이터 객체 조작/조회 |  |  |  |
| AC-1b693818 | InsertButton | SSP0015_ShipmentPSI.cs:7806 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtBolckS…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.SHIPMENT_DATE, SHIPMENT_DATE) | 데이터 객체 조작/조회 |  |  |  |
| AC-92cfcdc2 | InsertButton | SSP0015_ShipmentPSI.cs:7807 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtBolckS…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.SHIPMENT_CONFIRM_QTY, 0) | 데이터 객체 조작/조회 |  |  |  |
| AC-030a4b6f | InsertButton | SSP0015_ShipmentPSI.cs:7808 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtBolckS…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.REMARKS2, REMARKS2) | 데이터 객체 조작/조회 |  |  |  |
| AC-c2a9db66 | InsertButton | SSP0015_ShipmentPSI.cs:7809 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtBolckS…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.REMARKS, REMARKS) | 데이터 객체 조작/조회 |  |  |  |
| AC-26652791 | InsertButton | SSP0015_ShipmentPSI.cs:7810 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtBolckS…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.TRANSPORT_MODE, TRANSPORT_MODE) | 데이터 객체 조작/조회 |  |  |  |
| AC-61713a47 | InsertButton | SSP0015_ShipmentPSI.cs:7811 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtBolckS…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.FROM_SITE_DESCRIPTION, FROM_SITE_DESCRIPTION) | 데이터 객체 조작/조회 |  |  |  |
| AC-eabcaa0d | InsertButton | SSP0015_ShipmentPSI.cs:7812 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtBolckS…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.REQUESTOR, REQUESTOR) | 데이터 객체 조작/조회 |  |  |  |
| AC-65801577 | InsertButton | SSP0015_ShipmentPSI.cs:7813 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtBolckS…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.REMARKS3, REMARKS3) | 데이터 객체 조작/조회 |  |  |  |
| AC-8c78ea59 | InsertButton | SSP0015_ShipmentPSI.cs:7814 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtBolckS…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.CHANGE_REASON_CODE, CHANGE_REASON_CODE) | 데이터 객체 조작/조회 |  |  |  |
| AC-2938b828 | InsertButton | SSP0015_ShipmentPSI.cs:7815 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtBolckS…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.CHANGE_REASON_DETAIL, CHANGE_REASON_DETAIL) | 데이터 객체 조작/조회 |  |  |  |
| AC-eef7259c | InsertButton | SSP0015_ShipmentPSI.cs:7816 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtBolckS…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.INCOTERMS, INCOTERMS) | 데이터 객체 조작/조회 |  |  |  |
| AC-7646a106 | InsertButton | SSP0015_ShipmentPSI.cs:7817 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtBolckS…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.LT_DAY, LT_DAY) | 데이터 객체 조작/조회 |  |  |  |
| AC-a9bb666e | InsertButton | SSP0015_ShipmentPSI.cs:7818 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtBolckS…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.ETD, ETD) | 데이터 객체 조작/조회 |  |  |  |
| AC-9921ef9e | InsertButton | SSP0015_ShipmentPSI.cs:7819 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtBolckS…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.ETA, ETA) | 데이터 객체 조작/조회 |  |  |  |
| AC-ebc3508e | InsertButton | SSP0015_ShipmentPSI.cs:7821 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtBolckS…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.FCST_TYPE, FCST_TYPE) | 데이터 객체 조작/조회 |  |  |  |
| AC-678b9e20 | InsertButton | SSP0015_ShipmentPSI.cs:7822 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtBolckS…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.UPDATED_BY, UPDATED_BY) | 데이터 객체 조작/조회 |  |  |  |
| AC-f97dfbbc | InsertButton | SSP0015_ShipmentPSI.cs:7823 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtBolckS…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.UPDATED_DATE, UPDATED_DATE) | 데이터 객체 조작/조회 |  |  |  |
| AC-6b56fe4b | InsertButton | SSP0015_ShipmentPSI.cs:7824 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtBolckS…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.CHANGE_REQ_NO, CHANGE_REQ_NO) | 데이터 객체 조작/조회 |  |  |  |
| AC-e3d53f96 | InsertButton | SSP0015_ShipmentPSI.cs:7825 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtBolckS…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.CONFIRM_ID, CONFIRM_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-516ea935 | InsertButton | SSP0015_ShipmentPSI.cs:7826 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtBolckS…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.FROM_SITE, FROM_SITE) | 데이터 객체 조작/조회 |  |  |  |
| AC-d2e364a0 | InsertButton | SSP0015_ShipmentPSI.cs:7827 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtBolckS…) ▸ if (si… | DATA_OP | defaultData.Add | ("TO_SITE_SOLDTO_CODE", SOLDTO_DESCRIPTION) | 데이터 객체 조작/조회 |  |  |  |
| AC-1e85d69d | InsertButton | SSP0015_ShipmentPSI.cs:7828 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtBolckS…) ▸ if (si… | DATA_OP | defaultData.Add | ("TO_SITE_SHIPTO_CODE", SHIPTO_DESCRIPTION) | 데이터 객체 조작/조회 |  |  |  |
| AC-b6328396 | InsertButton | SSP0015_ShipmentPSI.cs:7829 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtBolckS…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.TO_SITE, TO_SITE) | 데이터 객체 조작/조회 |  |  |  |
| AC-5c46765e | InsertButton | SSP0015_ShipmentPSI.cs:7830 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtBolckS…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.ERP_STATUS, ERP_STATUS) | 데이터 객체 조작/조회 |  |  |  |
| AC-d5e84622 | InsertButton | SSP0015_ShipmentPSI.cs:7831 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtBolckS…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.BOD_ID, BOD_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-7112d22a | InsertButton | SSP0015_ShipmentPSI.cs:7832 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtBolckS…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.CHANGE_TYPE, CHANGE_TYPE) | 데이터 객체 조작/조회 |  |  |  |
| AC-b058c4f9 | InsertButton | SSP0015_ShipmentPSI.cs:7833 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtBolckS…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.NEW_ROUTE_ID, NEW_ROUTE_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-59e36a12 | InsertButton | SSP0015_ShipmentPSI.cs:7834 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtBolckS…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.NEW_BOD_ID, NEW_BOD_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-3145f007 | InsertButton | SSP0015_ShipmentPSI.cs:7835 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtBolckS…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.NEW_INCOTERMS, NEW_INCOTERMS) | 데이터 객체 조작/조회 |  |  |  |
| AC-086e4694 | InsertButton | SSP0015_ShipmentPSI.cs:7836 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtBolckS…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.NEW_D_COUNTRY, NEW_D_COUNTRY) | 데이터 객체 조작/조회 |  |  |  |
| AC-92c94728 | InsertButton | SSP0015_ShipmentPSI.cs:7837 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtBolckS…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.NEW_D_PORT_CODE, NEW_D_PORT_CODE) | 데이터 객체 조작/조회 |  |  |  |
| AC-75d0d389 | InsertButton | SSP0015_ShipmentPSI.cs:7838 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtBolckS…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.NEW_A_COUNTRY, NEW_A_COUNTRY) | 데이터 객체 조작/조회 |  |  |  |
| AC-ccc6cd6f | InsertButton | SSP0015_ShipmentPSI.cs:7839 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtBolckS…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.NEW_A_PORT_CODE, NEW_A_PORT_CODE) | 데이터 객체 조작/조회 |  |  |  |
| AC-830d70a8 | InsertButton | SSP0015_ShipmentPSI.cs:7840 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtBolckS…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.NEW_CUSTOMER_LT, NEW_CUSTOMER_LT) | 데이터 객체 조작/조회 |  |  |  |
| AC-189a6276 | InsertButton | SSP0015_ShipmentPSI.cs:7841 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtBolckS…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.NEW_TO_COUNTRY, NEW_TO_COUNTRY) | 데이터 객체 조작/조회 |  |  |  |
| AC-92048125 | InsertButton | SSP0015_ShipmentPSI.cs:7842 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtBolckS…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.NEW_TO_CITY, NEW_TO_CITY) | 데이터 객체 조작/조회 |  |  |  |
| AC-5b74f2df | InsertButton | SSP0015_ShipmentPSI.cs:7843 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtBolckS…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.NEW_ETA, NEW_ETA) | 데이터 객체 조작/조회 |  |  |  |
| AC-03184613 | InsertButton | SSP0015_ShipmentPSI.cs:7844 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtBolckS…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.NEW_ETD, NEW_ETD) | 데이터 객체 조작/조회 |  |  |  |
| AC-9cfd3670 | InsertButton | SSP0015_ShipmentPSI.cs:7845 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtBolckS…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.NEW_LT_DAY, NEW_LT_DAY) | 데이터 객체 조작/조회 |  |  |  |
| AC-49ddb7b4 | InsertButton | SSP0015_ShipmentPSI.cs:7846 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtBolckS…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.NEW_TRANSPORT_MODE, NEW_TRANSPORT_MODE) | 데이터 객체 조작/조회 |  |  |  |
| AC-2fd1ba69 | InsertButton | SSP0015_ShipmentPSI.cs:7847 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtBolckS…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.NEW_SHIPMENT_DATE, NEW_SHIPMENT_DATE) | 데이터 객체 조작/조회 |  |  |  |
| AC-3948aa5d | InsertButton | SSP0015_ShipmentPSI.cs:7848 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtBolckS…) ▸ if (si… | DATA_OP | defaultData.Add | (DefColumns.EDIT_REMARKS, EDIT_REMARKS) | 데이터 객체 조작/조회 |  |  |  |
| AC-5ce29db2 | InsertButton | SSP0015_ShipmentPSI.cs:7850 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtBolckS…) ▸ if (si… | GRID_SET | siDetail.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |
| AC-7bc9964e | InsertButton | SSP0015_ShipmentPSI.cs:7852 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtBolckS…) ▸ if (si… | GRID_LOCK | siDetail.LockRange | (insCell, siDetail.GetColumnIndex(DefColumns.DIVISION_ID), siDetail.GetColumnIndex(DefColu… | 그리드 편집 잠금/해제 |  |  |  |
| AC-5a188305 | InsertButton | SSP0015_ShipmentPSI.cs:7856 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtBolckS…) ▸ if (si… | GRID_LOCK | siDetail.LockRange | (insCell, siDetail.GetColumnIndex(DefColumns.INCOTERMS), siDetail.ActiveSheet.ColumnCount … | 그리드 편집 잠금/해제 |  |  |  |
| AC-e8557f0a | InsertButton | SSP0015_ShipmentPSI.cs:7861 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtBolckS…) ▸ if (si… | GRID_LOCK | siDetail.LockRange | (insCell, siDetail.GetColumnIndex(DefColumns.INCOTERMS), siDetail.GetColumnIndex("TO_SITE_… | 그리드 편집 잠금/해제 |  |  |  |
| AC-a4e09a04 | InsertButton | SSP0015_ShipmentPSI.cs:7862 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false && siDetail.ActiveSheet.SheetName == SpdSheet.shtBolckS…) ▸ if (si… | GRID_LOCK | siDetail.LockRange | (insCell, siDetail.GetColumnIndex(DefColumns.REQUESTOR), siDetail.ActiveSheet.ColumnCount … | 그리드 편집 잠금/해제 |  |  |  |

## SSP0015_ShipmentPSI.NewNonSoNo

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fd33b021 | (진입점 미연결) | SSP0015_ShipmentPSI.cs:9611 | if (siMain.ActiveSheetIndex == 0) | ENDPOINT | new FoxDataRequest | ("SSP.SSP0015_SAVE_SHIPMENT_REQUEST_DRAFTING") ⇒ SSP.SSP0015_SAVE_SHIPMENT_REQUEST_DRAFTING | 엔드포인트 요청 생성 |  |  |  |
| AC-443e3877 | (진입점 미연결) | SSP0015_ShipmentPSI.cs:9615 | else of (siMain.ActiveSheetIndex == 0) ▸ if (siMain.ActiveSheetIndex == 1) | ENDPOINT | new FoxDataRequest | ("SSP.SSP0015_SAVE_SHIPMENT_REQUEST_DRAFTING_PACKER") ⇒ SSP.SSP0015_SAVE_SHIPMENT_REQUEST_DRAFTING_PACKER | 엔드포인트 요청 생성 |  |  |  |
| AC-2fd6ff3e | (진입점 미연결) | SSP0015_ShipmentPSI.cs:9621 |  | DATA_OP | request.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-f4270974 | (진입점 미연결) | SSP0015_ShipmentPSI.cs:9622 |  | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-c91e17d3 | (진입점 미연결) | SSP0015_ShipmentPSI.cs:9623 |  | DATA_OP | request.Parameters["p_confirm_id"] | p_confirm_id | 행/컬럼 값 대입 |  |  |  |
| AC-4ec6eaf5 | (진입점 미연결) | SSP0015_ShipmentPSI.cs:9624 |  | DATA_OP | request.Parameters["p_shipment_qty"] | p_shipment_qty | 행/컬럼 값 대입 |  |  |  |
| AC-455ec08d | (진입점 미연결) | SSP0015_ShipmentPSI.cs:9625 |  | DATA_OP | request.Parameters["p_shipment_date"] | p_shipment_date | 행/컬럼 값 대입 |  |  |  |
| AC-d0988dac | (진입점 미연결) | SSP0015_ShipmentPSI.cs:9626 |  | DATA_OP | request.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-8e4fe4bf | (진입점 미연결) | SSP0015_ShipmentPSI.cs:9627 |  | DATA_OP | request.Parameters["p_new_bod_id"] | p_new_bod_id | 행/컬럼 값 대입 |  |  |  |
| AC-96f3d2ac | (진입점 미연결) | SSP0015_ShipmentPSI.cs:9628 |  | DATA_OP | request.Parameters["p_new_route_id"] | p_new_route_id | 행/컬럼 값 대입 |  |  |  |
| AC-7c42b4ad | (진입점 미연결) | SSP0015_ShipmentPSI.cs:9629 |  | DATA_OP | request.Parameters["p_new_etd_date"] | p_new_etd_date | 행/컬럼 값 대입 |  |  |  |
| AC-48340094 | (진입점 미연결) | SSP0015_ShipmentPSI.cs:9630 |  | DATA_OP | request.Parameters["p_new_eta_date"] | p_new_eta_date | 행/컬럼 값 대입 |  |  |  |
| AC-5bc23565 | (진입점 미연결) | SSP0015_ShipmentPSI.cs:9631 |  | DATA_OP | request.Parameters["p_new_incoterms"] | p_new_incoterms | 행/컬럼 값 대입 |  |  |  |
| AC-06981eeb | (진입점 미연결) | SSP0015_ShipmentPSI.cs:9632 |  | DATA_OP | request.Parameters["p_new_transport_mode"] | p_new_transport_mode | 행/컬럼 값 대입 |  |  |  |
| AC-042d6ce3 | (진입점 미연결) | SSP0015_ShipmentPSI.cs:9633 |  | DATA_OP | request.Parameters["p_new_d_contry"] | p_new_d_contry | 행/컬럼 값 대입 |  |  |  |
| AC-ce92113d | (진입점 미연결) | SSP0015_ShipmentPSI.cs:9634 |  | DATA_OP | request.Parameters["p_new_d_port_code"] | p_new_d_port_code | 행/컬럼 값 대입 |  |  |  |
| AC-74a57835 | (진입점 미연결) | SSP0015_ShipmentPSI.cs:9635 |  | DATA_OP | request.Parameters["p_new_a_country"] | p_new_a_country | 행/컬럼 값 대입 |  |  |  |
| AC-04ae066a | (진입점 미연결) | SSP0015_ShipmentPSI.cs:9636 |  | DATA_OP | request.Parameters["p_new_a_port_code"] | p_new_a_port_code | 행/컬럼 값 대입 |  |  |  |
| AC-7c5e6033 | (진입점 미연결) | SSP0015_ShipmentPSI.cs:9637 |  | DATA_OP | request.Parameters["p_new_customer_lt"] | p_new_customer_lt | 행/컬럼 값 대입 |  |  |  |
| AC-35c398f8 | (진입점 미연결) | SSP0015_ShipmentPSI.cs:9638 |  | DATA_OP | request.Parameters["p_new_to_country"] | p_new_to_country | 행/컬럼 값 대입 |  |  |  |
| AC-a833ceef | (진입점 미연결) | SSP0015_ShipmentPSI.cs:9639 |  | DATA_OP | request.Parameters["p_new_to_city"] | p_new_to_city | 행/컬럼 값 대입 |  |  |  |
| AC-f689c249 | (진입점 미연결) | SSP0015_ShipmentPSI.cs:9640 |  | DATA_OP | request.Parameters["p_edit_main"] | p_edit_main | 행/컬럼 값 대입 |  |  |  |
| AC-69700a06 | (진입점 미연결) | SSP0015_ShipmentPSI.cs:9641 |  | DATA_OP | request.Parameters["p_edit_remark"] | p_edit_remark | 행/컬럼 값 대입 |  |  |  |
| AC-da0dcdc0 | (진입점 미연결) | SSP0015_ShipmentPSI.cs:9642 |  | DATA_OP | request.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-dbd95f6b | (진입점 미연결) | SSP0015_ShipmentPSI.cs:9643 |  | DATA_OP | request.Parameters["p_user_dept_id"] | p_user_dept_id | 행/컬럼 값 대입 |  |  |  |
| AC-2aeb49a5 | (진입점 미연결) | SSP0015_ShipmentPSI.cs:9644 |  | DATA_OP | request.Parameters["p_electrode_yn"] | p_electrode_yn | 행/컬럼 값 대입 |  |  |  |
| AC-0c79c71a | (진입점 미연결) | SSP0015_ShipmentPSI.cs:9645 |  | DATA_OP | request.Parameters["p_electrode_type"] | p_electrode_type | 행/컬럼 값 대입 |  |  |  |
| AC-125c7431 | (진입점 미연결) | SSP0015_ShipmentPSI.cs:9646 |  | DATA_OP | request.Parameters["p_origin_from_division_id"] | p_origin_from_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-014270b2 | (진입점 미연결) | SSP0015_ShipmentPSI.cs:9647 |  | DATA_OP | request.Parameters["p_origion_to_division_id"] | p_origion_to_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-c25f6231 | (진입점 미연결) | SSP0015_ShipmentPSI.cs:9649 |  | DATA_OP | request.Parameters["p_remarks"] | p_remarks | 행/컬럼 값 대입 |  |  |  |
| AC-f882ddc2 | (진입점 미연결) | SSP0015_ShipmentPSI.cs:9650 |  | DATA_OP | request.Parameters["p_remarks2"] | p_remarks2 | 행/컬럼 값 대입 |  |  |  |
| AC-c6acd066 | (진입점 미연결) | SSP0015_ShipmentPSI.cs:9651 |  | DATA_OP | request.Parameters["p_remarks3"] | p_remarks3 | 행/컬럼 값 대입 |  |  |  |
| AC-fe6dc4e4 | (진입점 미연결) | SSP0015_ShipmentPSI.cs:9653 |  | DATA_OP | request.Parameters["p_change_reason_code"] | p_change_reason_code | 행/컬럼 값 대입 |  |  |  |
| AC-6cd023f6 | (진입점 미연결) | SSP0015_ShipmentPSI.cs:9654 |  | DATA_OP | request.Parameters["p_change_reason_detail"] | p_change_reason_datail | 행/컬럼 값 대입 |  |  |  |
| AC-c6955fef | (진입점 미연결) | SSP0015_ShipmentPSI.cs:9655 |  | DATA_OP | request.Parameters["p_title"] | p_title | 행/컬럼 값 대입 |  |  |  |
| AC-6ce217d5 | (진입점 미연결) | SSP0015_ShipmentPSI.cs:9656 |  | DATA_OP | request.Parameters["p_program_id"] | p_program_id | 행/컬럼 값 대입 |  |  |  |
| AC-8a564614 | (진입점 미연결) | SSP0015_ShipmentPSI.cs:9657 |  | DATA_OP | request.Parameters["p_shipto_code"] | p_shipto_code | 행/컬럼 값 대입 |  |  |  |
| AC-57723407 | (진입점 미연결) | SSP0015_ShipmentPSI.cs:9660 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-76da1468 | (진입점 미연결) | SSP0015_ShipmentPSI.cs:9685 | else of (ds.Tables[0].Rows[0][0].ToString() == "S") ▸ if (ds.Tables[0].Rows[0][0].ToString() == "X") | MESSAGE | MessageHelper.GMessageBox | ("MSG00324") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a6815e3a | (진입점 미연결) | SSP0015_ShipmentPSI.cs:9687 | else of (ds.Tables[0].Rows[0][0].ToString() == "S") ▸ if (ds.Tables[0].Rows[0][0].ToString() == "X") ▸ if (MessageHelper.GMessageBox("MSG003… | CALL_BASE | base.AddHelpButton | ("Standard Information SSP Manual") | ⚠ 의미 확인 필요 |  |  |  |
| AC-35086833 | (진입점 미연결) | SSP0015_ShipmentPSI.cs:9708 | else of (ds.Tables[0].Rows[0][0].ToString() == "S") ▸ else of (ds.Tables[0].Rows[0][0].ToString() == "X") | MESSAGE | MessageHelper.GMessageBox | ("MSG00284", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a3185044 | (진입점 미연결) | SSP0015_ShipmentPSI.cs:9712 |  | RETURN | return bReturn; |  | 처리 중단/반환 |  |  |  |

## SSP0015_ShipmentPSI.NonSoNo

진입점: SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.ActiveSheetIndex == 0) ▸ if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlockYn()) ▸ try ▸ try ▸ for (i <= siDetail.ActiveSheet.RowCount - 1) ▸ if (action != CAppSetting.FlagI) ▸ if (string.IsNullOrWhiteSpace(erpSoNo))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ea20721f | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6843 | if (siMain.ActiveSheetIndex == 0) | ENDPOINT | new FoxDataRequest | ("SSP.SSP0015_SAVE_SHIPMENT_REQUEST_DRAFTING") ⇒ SSP.SSP0015_SAVE_SHIPMENT_REQUEST_DRAFTING | 엔드포인트 요청 생성 |  |  |  |
| AC-baddc996 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6847 | else of (siMain.ActiveSheetIndex == 0) ▸ if (siMain.ActiveSheetIndex == 1) | ENDPOINT | new FoxDataRequest | ("SSP.SSP0015_SAVE_SHIPMENT_REQUEST_DRAFTING_PACKER") ⇒ SSP.SSP0015_SAVE_SHIPMENT_REQUEST_DRAFTING_PACKER | 엔드포인트 요청 생성 |  |  |  |
| AC-ac7dc6a4 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6853 |  | DATA_OP | request.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-4d58f3cc | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6854 |  | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-153478a6 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6855 |  | DATA_OP | request.Parameters["p_confirm_id"] | p_confirm_id | 행/컬럼 값 대입 |  |  |  |
| AC-8225bfe7 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6856 |  | DATA_OP | request.Parameters["p_shipment_qty"] | p_shipment_qty | 행/컬럼 값 대입 |  |  |  |
| AC-5f9a606b | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6857 |  | DATA_OP | request.Parameters["p_shipment_date"] | p_shipment_date | 행/컬럼 값 대입 |  |  |  |
| AC-82709488 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6858 |  | DATA_OP | request.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-bdd6ae17 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6859 |  | DATA_OP | request.Parameters["p_new_bod_id"] | p_new_bod_id | 행/컬럼 값 대입 |  |  |  |
| AC-21096bea | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6860 |  | DATA_OP | request.Parameters["p_new_route_id"] | p_new_route_id | 행/컬럼 값 대입 |  |  |  |
| AC-d8ff6018 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6861 |  | DATA_OP | request.Parameters["p_new_etd_date"] | p_new_etd_date | 행/컬럼 값 대입 |  |  |  |
| AC-6f293c30 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6862 |  | DATA_OP | request.Parameters["p_new_eta_date"] | p_new_eta_date | 행/컬럼 값 대입 |  |  |  |
| AC-3dd88b63 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6863 |  | DATA_OP | request.Parameters["p_new_incoterms"] | p_new_incoterms | 행/컬럼 값 대입 |  |  |  |
| AC-97b51433 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6864 |  | DATA_OP | request.Parameters["p_new_transport_mode"] | p_new_transport_mode | 행/컬럼 값 대입 |  |  |  |
| AC-e3f0bd7d | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6865 |  | DATA_OP | request.Parameters["p_new_d_contry"] | p_new_d_contry | 행/컬럼 값 대입 |  |  |  |
| AC-80aa4d30 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6866 |  | DATA_OP | request.Parameters["p_new_d_port_code"] | p_new_d_port_code | 행/컬럼 값 대입 |  |  |  |
| AC-1afb6b55 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6867 |  | DATA_OP | request.Parameters["p_new_a_country"] | p_new_a_country | 행/컬럼 값 대입 |  |  |  |
| AC-17b337db | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6868 |  | DATA_OP | request.Parameters["p_new_a_port_code"] | p_new_a_port_code | 행/컬럼 값 대입 |  |  |  |
| AC-19cabee5 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6869 |  | DATA_OP | request.Parameters["p_new_customer_lt"] | p_new_customer_lt | 행/컬럼 값 대입 |  |  |  |
| AC-78dbced5 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6870 |  | DATA_OP | request.Parameters["p_new_to_country"] | p_new_to_country | 행/컬럼 값 대입 |  |  |  |
| AC-b8e9db6c | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6871 |  | DATA_OP | request.Parameters["p_new_to_city"] | p_new_to_city | 행/컬럼 값 대입 |  |  |  |
| AC-0aa6bf1a | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6872 |  | DATA_OP | request.Parameters["p_edit_main"] | p_edit_main | 행/컬럼 값 대입 |  |  |  |
| AC-632e23b0 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6873 |  | DATA_OP | request.Parameters["p_edit_remark"] | p_edit_remark | 행/컬럼 값 대입 |  |  |  |
| AC-58254f2b | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6874 |  | DATA_OP | request.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-60eb8600 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6875 |  | DATA_OP | request.Parameters["p_user_dept_id"] | p_user_dept_id | 행/컬럼 값 대입 |  |  |  |
| AC-9c1b2400 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6876 |  | DATA_OP | request.Parameters["p_electrode_yn"] | p_electrode_yn | 행/컬럼 값 대입 |  |  |  |
| AC-aa93c87f | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6877 |  | DATA_OP | request.Parameters["p_electrode_type"] | p_electrode_type | 행/컬럼 값 대입 |  |  |  |
| AC-db4a2e30 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6878 |  | DATA_OP | request.Parameters["p_origin_from_division_id"] | p_origin_from_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-124d3000 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6879 |  | DATA_OP | request.Parameters["p_origion_to_division_id"] | p_origion_to_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-85b63184 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6881 |  | DATA_OP | request.Parameters["p_remarks"] | p_remarks | 행/컬럼 값 대입 |  |  |  |
| AC-c75de82d | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6882 |  | DATA_OP | request.Parameters["p_remarks2"] | p_remarks2 | 행/컬럼 값 대입 |  |  |  |
| AC-e026d2b6 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6883 |  | DATA_OP | request.Parameters["p_remarks3"] | p_remarks3 | 행/컬럼 값 대입 |  |  |  |
| AC-f8efb066 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6885 |  | DATA_OP | request.Parameters["p_change_reason_code"] | p_change_reason_code | 행/컬럼 값 대입 |  |  |  |
| AC-5aeb9b5f | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6886 |  | DATA_OP | request.Parameters["p_change_reason_detail"] | p_change_reason_datail | 행/컬럼 값 대입 |  |  |  |
| AC-ae18faef | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6887 |  | DATA_OP | request.Parameters["p_title"] | p_title | 행/컬럼 값 대입 |  |  |  |
| AC-ae433614 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6888 |  | DATA_OP | request.Parameters["p_program_id"] | p_program_id | 행/컬럼 값 대입 |  |  |  |
| AC-de528c97 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6889 |  | DATA_OP | request.Parameters["p_shipto_code"] | p_shipto_code | 행/컬럼 값 대입 |  |  |  |
| AC-431b0a54 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6891 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-ff2feff2 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6933 | else of (ds.Tables[0].Rows[0][0].ToString() == "S") | MESSAGE | MessageHelper.GMessageBox | ("MSG00284", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-632a886f | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6937 |  | RETURN | return bReturn; |  | 처리 중단/반환 |  |  |  |

## SSP0015_ShipmentPSI.Re_Design

진입점: this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex == 0) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) ▸ if (sMeasure == "WH_IN") ▸ if (Comments != null) ▸ if (ssp0015Popup.DialogResult == DialogResult.OK) ▸ finally] / FindButton [if (siMain.ActiveSheetIndex == 0) ▸ finally] / SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ finally] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f4d3baa8 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0015_ShipmentPSI.cs:2844 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (i < rowCount) ▸ if (strItemId != strTmp_ItemID) | GRID_SET | siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(DefColumns.ITEM_ID), i, columnCount - 1]… | bevelbrdr | 그리드 속성/값 설정 |  |  |  |
| AC-6080706c | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0015_ShipmentPSI.cs:2860 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (i < rowCount) ▸ try ▸ if (frozen_day_pos > -1) | CALL_EXT | Convert.ToInt16 | (frozen_day_value) | ⚠ 의미 확인 필요 |  |  |  |
| AC-bb042bfa | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0015_ShipmentPSI.cs:2865 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (i < rowCount) ▸ try ▸ if (startIdx < intEndIdx) | GRID_STYLE | siMain.SetBGColor2 | (i, startIdx, i, intEndIdx, Color.FromArgb(Convert.ToInt32(242), Convert.ToInt32(242), Con… | 그리드 표시 설정 |  |  |  |
| AC-eaaee20f | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0015_ShipmentPSI.cs:2886 | if (siMain.ActiveSheet.RowCount > 0) | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SSP0015_ShipmentPSI.SaveData_Detail

진입점: SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.ActiveSheetIndex == 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2ddf021e | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:5708 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ if (!EngProcessingCh… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ed39ecb6 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:5710 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) | VALIDATE | DataUtil.checkRequiredOfSpread | (siDetail) | 프레임워크 검증 |  |  |  |
| AC-de01640e | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:5713 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ if (!DataUtil.checkR… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-aa34c02c | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:5720 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ if (chkERPIFBlockYn(… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-67cad8af | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:5724 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-ea4d4b07 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:5732 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-56146ea6 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:5738 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | MESSAGE | MessageHelper.GMessageBox | ("MSG00133", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a2108407 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:5740 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ba1953ec | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:5744 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-c27b0689 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:5749 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7eb14fac | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:5841 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | ENDPOINT | new FoxDataRequest | ("SSP.SSP0015_SAVE_SHIPMENT_REQUEST_CONFIRM_40") ⇒ SSP.SSP0015_SAVE_SHIPMENT_REQUEST_CONFIRM_40 | 엔드포인트 요청 생성 |  |  |  |
| AC-5f054ffc | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:5845 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | DATA_OP | request.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-c60d404b | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:5846 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-201a2610 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:5847 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | DATA_OP | request.Parameters["p_confirm_id"] | p_confirm_id | 행/컬럼 값 대입 |  |  |  |
| AC-43db92cf | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:5848 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | DATA_OP | request.Parameters["p_shipment_qty"] | p_shipment_qty | 행/컬럼 값 대입 |  |  |  |
| AC-a9a8ffd3 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:5849 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | DATA_OP | request.Parameters["p_shipment_date"] | p_shipment_date | 행/컬럼 값 대입 |  |  |  |
| AC-e6befb24 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:5850 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | DATA_OP | request.Parameters["p_new_bod_id"] | p_new_bod_id | 행/컬럼 값 대입 |  |  |  |
| AC-8ffddfb2 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:5851 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | DATA_OP | request.Parameters["p_new_route_id"] | p_new_route_id | 행/컬럼 값 대입 |  |  |  |
| AC-626598ca | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:5852 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | DATA_OP | request.Parameters["p_new_etd_date"] | p_new_etd_date | 행/컬럼 값 대입 |  |  |  |
| AC-21ce0437 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:5853 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | DATA_OP | request.Parameters["p_new_eta_date"] | p_new_eta_date | 행/컬럼 값 대입 |  |  |  |
| AC-e47a12f6 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:5854 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | DATA_OP | request.Parameters["p_new_incoterms"] | p_new_incoterms | 행/컬럼 값 대입 |  |  |  |
| AC-a353500e | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:5855 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | DATA_OP | request.Parameters["p_new_transport_mode"] | p_new_transport_mode | 행/컬럼 값 대입 |  |  |  |
| AC-0e4cd7ab | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:5856 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | DATA_OP | request.Parameters["p_new_d_contry"] | p_new_d_contry | 행/컬럼 값 대입 |  |  |  |
| AC-154634f9 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:5857 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | DATA_OP | request.Parameters["p_new_d_port_code"] | p_new_d_port_code | 행/컬럼 값 대입 |  |  |  |
| AC-015eae6b | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:5858 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | DATA_OP | request.Parameters["p_new_a_country"] | p_new_a_country | 행/컬럼 값 대입 |  |  |  |
| AC-5a899d41 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:5859 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | DATA_OP | request.Parameters["p_new_a_port_code"] | p_new_a_port_code | 행/컬럼 값 대입 |  |  |  |
| AC-7b092675 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:5860 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | DATA_OP | request.Parameters["p_new_customer_lt"] | p_new_customer_lt | 행/컬럼 값 대입 |  |  |  |
| AC-5950312f | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:5861 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | DATA_OP | request.Parameters["p_new_to_country"] | p_new_to_country | 행/컬럼 값 대입 |  |  |  |
| AC-af122a75 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:5862 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | DATA_OP | request.Parameters["p_new_to_city"] | p_new_to_city | 행/컬럼 값 대입 |  |  |  |
| AC-2bcc592d | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:5863 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | DATA_OP | request.Parameters["p_remarks"] | p_remarks | 행/컬럼 값 대입 |  |  |  |
| AC-de1175d9 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:5864 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | DATA_OP | request.Parameters["p_remarks2"] | p_remarks2 | 행/컬럼 값 대입 |  |  |  |
| AC-f1c23c12 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:5865 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | DATA_OP | request.Parameters["p_remarks3"] | p_remarks3 | 행/컬럼 값 대입 |  |  |  |
| AC-3fbfa48d | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:5866 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | DATA_OP | request.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-f8758ac3 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:5867 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | DATA_OP | request.Parameters["p_check_need_yn"] | p_check_need_yn | 행/컬럼 값 대입 |  |  |  |
| AC-f86b1f2b | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:5868 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | DATA_OP | request.Parameters["p_edit_main"] | p_edit_main | 행/컬럼 값 대입 |  |  |  |
| AC-d4107d4b | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:5870 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-07fca899 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:5876 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-3adf0c6e | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:5877 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { ds.Tables[0].Rows[0][1].ToString() }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0230d6d7 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:5905 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | MESSAGE | MessageHelper.GMessageBox | ("MSG00324") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-fa9dd5ee | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:5907 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | CALL_BASE | base.AddHelpButton | ("Standard Information SSP Manual") | ⚠ 의미 확인 필요 |  |  |  |
| AC-b913a7ae | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:5915 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-57ca9ed5 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:5927 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | MESSAGE | MessageHelper.GMessageBox | ("MSG00284", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e1639397 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:5940 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-b80ba5d8 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:5944 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | STATE_RESET | errConfrimList2.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-1f64c4f1 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:5967 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtBolckStock) | VALIDATE | DataUtil.checkRequiredOfSpread | (siDetail) | 프레임워크 검증 |  |  |  |
| AC-a4e758ee | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:5967 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtBolckStock) ▸ if (!DataUtil.ch… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2299551c | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:5969 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtBolckStock) ▸ if (!checkValidN… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e46b945f | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6011 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtBolckStock) ▸ if (iCount > 0) | ENDPOINT | new FoxDataRequest | ("SSP.SSP0015_SAVE_BLOCK_STOCK_DATA") ⇒ SSP.SSP0015_SAVE_BLOCK_STOCK_DATA | 엔드포인트 요청 생성 |  |  |  |
| AC-4ff57887 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6016 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtBolckStock) ▸ if (iCount > 0) | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SSP.Plan.WSL/FoxDataService.s… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-357ce5be | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6020 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtBolckStock) ▸ if (iCount > 0) … | DATA_OP | request.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-971350cc | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6021 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtBolckStock) ▸ if (iCount > 0) … | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-5a696544 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6022 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtBolckStock) ▸ if (iCount > 0) … | DATA_OP | request.Parameters["p_hold_id"] | p_hold_id | 행/컬럼 값 대입 |  |  |  |
| AC-05f9b64e | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6023 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtBolckStock) ▸ if (iCount > 0) … | DATA_OP | request.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-49d7e4d0 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6024 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtBolckStock) ▸ if (iCount > 0) … | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-d2271f34 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6025 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtBolckStock) ▸ if (iCount > 0) … | DATA_OP | request.Parameters["p_hold_yyyymmdd"] | p_hold_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-18e3c80e | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6026 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtBolckStock) ▸ if (iCount > 0) … | DATA_OP | request.Parameters["p_release_yyyymmdd"] | p_release_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-02acf202 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6027 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtBolckStock) ▸ if (iCount > 0) … | DATA_OP | request.Parameters["p_hold_qty"] | p_hold_qty | 행/컬럼 값 대입 |  |  |  |
| AC-12c6a112 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6028 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtBolckStock) ▸ if (iCount > 0) … | DATA_OP | request.Parameters["p_remarks"] | p_remarks | 행/컬럼 값 대입 |  |  |  |
| AC-5b8eded7 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6029 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtBolckStock) ▸ if (iCount > 0) … | DATA_OP | request.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-ee62ed24 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6031 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtBolckStock) ▸ if (iCount > 0) … | DATA_OP | request.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-51ef1a51 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6032 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtBolckStock) ▸ if (iCount > 0) … | DATA_OP | request.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-ed1eb4f8 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6033 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtBolckStock) ▸ if (iCount > 0) … | DATA_OP | request.Parameters["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-f0c4a346 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6035 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtBolckStock) ▸ if (iCount > 0) … | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-4de19ade | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6035 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtBolckStock) ▸ if (iCount > 0) … | RETURN | return client.ExecuteDataSet(request); |  | 처리 중단/반환 |  |  |  |
| AC-f3600f83 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6044 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtBolckStock) ▸ if (iCount > 0) … | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { t.DataSet.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-34a1e4af | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6059 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtBolckStock) ▸ if (iCount > 0) … | MESSAGE | MessageHelper.GMessageBox | ("MSG00284", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-85488f2b | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6112 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtMesStock) ▸ if (iCount > 0) | ENDPOINT | new FoxDataRequest | ("SSP.SSP0015_SAVE_MES_STOCK") ⇒ SSP.SSP0015_SAVE_MES_STOCK | 엔드포인트 요청 생성 |  |  |  |
| AC-ce7dc9ca | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6117 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtMesStock) ▸ if (iCount > 0) | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SSP.Plan.WSL/FoxDataService.s… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-d871d09f | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6121 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtMesStock) ▸ if (iCount > 0) ▸ … | UI_PROP | request.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-08db236d | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6123 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtMesStock) ▸ if (iCount > 0) ▸ … | DATA_OP | request.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-e925689d | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6124 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtMesStock) ▸ if (iCount > 0) ▸ … | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-17bcc711 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6125 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtMesStock) ▸ if (iCount > 0) ▸ … | DATA_OP | request.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-754f11a6 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6126 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtMesStock) ▸ if (iCount > 0) ▸ … | DATA_OP | request.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-384445d5 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6127 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtMesStock) ▸ if (iCount > 0) ▸ … | DATA_OP | request.Parameters["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-15e429e4 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6128 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtMesStock) ▸ if (iCount > 0) ▸ … | DATA_OP | request.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-9bd18a0c | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6129 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtMesStock) ▸ if (iCount > 0) ▸ … | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-3df4df8e | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6130 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtMesStock) ▸ if (iCount > 0) ▸ … | DATA_OP | request.Parameters["p_lot_id"] | p_lot_id | 행/컬럼 값 대입 |  |  |  |
| AC-0384c48b | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6131 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtMesStock) ▸ if (iCount > 0) ▸ … | DATA_OP | request.Parameters["p_user_mod_release_date"] | p_user_mod_release_date | 행/컬럼 값 대입 |  |  |  |
| AC-6be36b78 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6132 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtMesStock) ▸ if (iCount > 0) ▸ … | DATA_OP | request.Parameters["p_remarks"] | p_remarks | 행/컬럼 값 대입 |  |  |  |
| AC-e393742f | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6133 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtMesStock) ▸ if (iCount > 0) ▸ … | DATA_OP | request.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-a1060a49 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6135 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtMesStock) ▸ if (iCount > 0) ▸ … | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-1f790bef | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6135 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtMesStock) ▸ if (iCount > 0) ▸ … | RETURN | return client.ExecuteDataSet(request); |  | 처리 중단/반환 |  |  |  |
| AC-061d11ec | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6144 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtMesStock) ▸ if (iCount > 0) ▸ … | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { t.DataSet.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a820fb56 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6166 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtMesStock) ▸ if (iCount > 0) ▸ … | MESSAGE | MessageHelper.GMessageBox | ("MSG00284", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-2cbfe6b5 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6219 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtScsStock) ▸ if (iCount > 0) | ENDPOINT | new FoxDataRequest | ("SSP.SSP0015_SAVE_MES_STOCK") ⇒ SSP.SSP0015_SAVE_MES_STOCK | 엔드포인트 요청 생성 |  |  |  |
| AC-49bdee86 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6224 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtScsStock) ▸ if (iCount > 0) | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SSP.Plan.WSL/FoxDataService.s… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-11527e74 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6228 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtScsStock) ▸ if (iCount > 0) ▸ … | UI_PROP | request.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-0dc47229 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6230 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtScsStock) ▸ if (iCount > 0) ▸ … | DATA_OP | request.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-6d818de3 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6231 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtScsStock) ▸ if (iCount > 0) ▸ … | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-c172acfb | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6232 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtScsStock) ▸ if (iCount > 0) ▸ … | DATA_OP | request.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-de0bf64a | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6233 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtScsStock) ▸ if (iCount > 0) ▸ … | DATA_OP | request.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-ff0baac9 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6234 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtScsStock) ▸ if (iCount > 0) ▸ … | DATA_OP | request.Parameters["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-dc3dc772 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6235 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtScsStock) ▸ if (iCount > 0) ▸ … | DATA_OP | request.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-ca52140c | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6236 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtScsStock) ▸ if (iCount > 0) ▸ … | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-f77afa08 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6237 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtScsStock) ▸ if (iCount > 0) ▸ … | DATA_OP | request.Parameters["p_lot_id"] | p_lot_id | 행/컬럼 값 대입 |  |  |  |
| AC-3caf1478 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6238 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtScsStock) ▸ if (iCount > 0) ▸ … | DATA_OP | request.Parameters["p_user_mod_release_date"] | p_user_mod_release_date | 행/컬럼 값 대입 |  |  |  |
| AC-da3011f5 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6239 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtScsStock) ▸ if (iCount > 0) ▸ … | DATA_OP | request.Parameters["p_remarks"] | p_remarks | 행/컬럼 값 대입 |  |  |  |
| AC-88348bac | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6240 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtScsStock) ▸ if (iCount > 0) ▸ … | DATA_OP | request.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-0fe3b614 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6242 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtScsStock) ▸ if (iCount > 0) ▸ … | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-82b2aa22 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6242 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtScsStock) ▸ if (iCount > 0) ▸ … | RETURN | return client.ExecuteDataSet(request); |  | 처리 중단/반환 |  |  |  |
| AC-a37c74ca | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6251 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtScsStock) ▸ if (iCount > 0) ▸ … | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { t.DataSet.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-02d42bd0 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6273 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtScsStock) ▸ if (iCount > 0) ▸ … | MESSAGE | MessageHelper.GMessageBox | ("MSG00284", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SSP0015_ShipmentPSI.SaveData_Detail_Packer

진입점: SaveButton [else of (fps.Name == "spdMain") ▸ else of (siMain.ActiveSheetIndex == 0) ▸ if (siMain.ActiveSheetIndex == 1)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0a019a88 | SaveButton [else of (fps.Name == "spdMain") ▸ else of (siMai… | SSP0015_ShipmentPSI.cs:5481 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ if (chkSaveYN() == f… | MESSAGE | MessageHelper.GMessageBox | ("MSG00363") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-eb18226f | SaveButton [else of (fps.Name == "spdMain") ▸ else of (siMai… | SSP0015_ShipmentPSI.cs:5482 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ if (chkSaveYN() == f… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6990b928 | SaveButton [else of (fps.Name == "spdMain") ▸ else of (siMai… | SSP0015_ShipmentPSI.cs:5486 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ if (!EngProcessingCh… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d4bf35a1 | SaveButton [else of (fps.Name == "spdMain") ▸ else of (siMai… | SSP0015_ShipmentPSI.cs:5488 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) | VALIDATE | DataUtil.checkRequiredOfSpread | (siDetail) | 프레임워크 검증 |  |  |  |
| AC-dcf77df6 | SaveButton [else of (fps.Name == "spdMain") ▸ else of (siMai… | SSP0015_ShipmentPSI.cs:5491 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ if (!DataUtil.checkR… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-91d1ac9b | SaveButton [else of (fps.Name == "spdMain") ▸ else of (siMai… | SSP0015_ShipmentPSI.cs:5498 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ if (chkERPIFBlockYn(… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9e6d4a12 | SaveButton [else of (fps.Name == "spdMain") ▸ else of (siMai… | SSP0015_ShipmentPSI.cs:5502 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-1d51b544 | SaveButton [else of (fps.Name == "spdMain") ▸ else of (siMai… | SSP0015_ShipmentPSI.cs:5510 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-bdc4fb1a | SaveButton [else of (fps.Name == "spdMain") ▸ else of (siMai… | SSP0015_ShipmentPSI.cs:5516 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | MESSAGE | MessageHelper.GMessageBox | ("MSG00133", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ae2d883b | SaveButton [else of (fps.Name == "spdMain") ▸ else of (siMai… | SSP0015_ShipmentPSI.cs:5518 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b24d651f | SaveButton [else of (fps.Name == "spdMain") ▸ else of (siMai… | SSP0015_ShipmentPSI.cs:5522 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-429ba2dc | SaveButton [else of (fps.Name == "spdMain") ▸ else of (siMai… | SSP0015_ShipmentPSI.cs:5527 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5b4cf471 | SaveButton [else of (fps.Name == "spdMain") ▸ else of (siMai… | SSP0015_ShipmentPSI.cs:5602 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | ENDPOINT | new FoxDataRequest | ("SSP.SSP0015_SAVE_SHIPMENT_REQUEST_CONFIRM_PACKER") ⇒ SSP.SSP0015_SAVE_SHIPMENT_REQUEST_CONFIRM_PACKER | 엔드포인트 요청 생성 |  |  |  |
| AC-eea8e953 | SaveButton [else of (fps.Name == "spdMain") ▸ else of (siMai… | SSP0015_ShipmentPSI.cs:5606 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | DATA_OP | request.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-35af5b17 | SaveButton [else of (fps.Name == "spdMain") ▸ else of (siMai… | SSP0015_ShipmentPSI.cs:5607 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-f6ad52f6 | SaveButton [else of (fps.Name == "spdMain") ▸ else of (siMai… | SSP0015_ShipmentPSI.cs:5608 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | DATA_OP | request.Parameters["p_confirm_id"] | p_confirm_id | 행/컬럼 값 대입 |  |  |  |
| AC-63fcd504 | SaveButton [else of (fps.Name == "spdMain") ▸ else of (siMai… | SSP0015_ShipmentPSI.cs:5609 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | DATA_OP | request.Parameters["p_shipment_qty"] | p_shipment_qty | 행/컬럼 값 대입 |  |  |  |
| AC-bb12e0a2 | SaveButton [else of (fps.Name == "spdMain") ▸ else of (siMai… | SSP0015_ShipmentPSI.cs:5610 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | DATA_OP | request.Parameters["p_shipment_date"] | p_shipment_date | 행/컬럼 값 대입 |  |  |  |
| AC-f7216e7d | SaveButton [else of (fps.Name == "spdMain") ▸ else of (siMai… | SSP0015_ShipmentPSI.cs:5611 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | DATA_OP | request.Parameters["p_new_bod_id"] | p_new_bod_id | 행/컬럼 값 대입 |  |  |  |
| AC-b3339d5e | SaveButton [else of (fps.Name == "spdMain") ▸ else of (siMai… | SSP0015_ShipmentPSI.cs:5612 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | DATA_OP | request.Parameters["p_new_route_id"] | p_new_route_id | 행/컬럼 값 대입 |  |  |  |
| AC-045fb941 | SaveButton [else of (fps.Name == "spdMain") ▸ else of (siMai… | SSP0015_ShipmentPSI.cs:5613 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | DATA_OP | request.Parameters["p_new_etd_date"] | p_new_etd_date | 행/컬럼 값 대입 |  |  |  |
| AC-c2d9e1b8 | SaveButton [else of (fps.Name == "spdMain") ▸ else of (siMai… | SSP0015_ShipmentPSI.cs:5614 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | DATA_OP | request.Parameters["p_new_eta_date"] | p_new_eta_date | 행/컬럼 값 대입 |  |  |  |
| AC-df6f80a1 | SaveButton [else of (fps.Name == "spdMain") ▸ else of (siMai… | SSP0015_ShipmentPSI.cs:5615 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | DATA_OP | request.Parameters["p_new_incoterms"] | p_new_incoterms | 행/컬럼 값 대입 |  |  |  |
| AC-afa37dcf | SaveButton [else of (fps.Name == "spdMain") ▸ else of (siMai… | SSP0015_ShipmentPSI.cs:5616 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | DATA_OP | request.Parameters["p_new_transport_mode"] | p_new_transport_mode | 행/컬럼 값 대입 |  |  |  |
| AC-4a2d7d3c | SaveButton [else of (fps.Name == "spdMain") ▸ else of (siMai… | SSP0015_ShipmentPSI.cs:5617 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | DATA_OP | request.Parameters["p_new_d_contry"] | p_new_d_contry | 행/컬럼 값 대입 |  |  |  |
| AC-31b1553d | SaveButton [else of (fps.Name == "spdMain") ▸ else of (siMai… | SSP0015_ShipmentPSI.cs:5618 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | DATA_OP | request.Parameters["p_new_d_port_code"] | p_new_d_port_code | 행/컬럼 값 대입 |  |  |  |
| AC-1dba6156 | SaveButton [else of (fps.Name == "spdMain") ▸ else of (siMai… | SSP0015_ShipmentPSI.cs:5619 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | DATA_OP | request.Parameters["p_new_a_country"] | p_new_a_country | 행/컬럼 값 대입 |  |  |  |
| AC-23493c68 | SaveButton [else of (fps.Name == "spdMain") ▸ else of (siMai… | SSP0015_ShipmentPSI.cs:5620 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | DATA_OP | request.Parameters["p_new_a_port_code"] | p_new_a_port_code | 행/컬럼 값 대입 |  |  |  |
| AC-33c583dc | SaveButton [else of (fps.Name == "spdMain") ▸ else of (siMai… | SSP0015_ShipmentPSI.cs:5621 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | DATA_OP | request.Parameters["p_new_customer_lt"] | p_new_customer_lt | 행/컬럼 값 대입 |  |  |  |
| AC-2f70f91d | SaveButton [else of (fps.Name == "spdMain") ▸ else of (siMai… | SSP0015_ShipmentPSI.cs:5622 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | DATA_OP | request.Parameters["p_new_to_country"] | p_new_to_country | 행/컬럼 값 대입 |  |  |  |
| AC-04b233a0 | SaveButton [else of (fps.Name == "spdMain") ▸ else of (siMai… | SSP0015_ShipmentPSI.cs:5623 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | DATA_OP | request.Parameters["p_new_to_city"] | p_new_to_city | 행/컬럼 값 대입 |  |  |  |
| AC-c5bf9aaf | SaveButton [else of (fps.Name == "spdMain") ▸ else of (siMai… | SSP0015_ShipmentPSI.cs:5624 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | DATA_OP | request.Parameters["p_remarks"] | p_remarks | 행/컬럼 값 대입 |  |  |  |
| AC-60c2da10 | SaveButton [else of (fps.Name == "spdMain") ▸ else of (siMai… | SSP0015_ShipmentPSI.cs:5625 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | DATA_OP | request.Parameters["p_remarks2"] | p_remarks2 | 행/컬럼 값 대입 |  |  |  |
| AC-59df890f | SaveButton [else of (fps.Name == "spdMain") ▸ else of (siMai… | SSP0015_ShipmentPSI.cs:5626 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | DATA_OP | request.Parameters["p_remarks3"] | p_remarks3 | 행/컬럼 값 대입 |  |  |  |
| AC-c357d7f9 | SaveButton [else of (fps.Name == "spdMain") ▸ else of (siMai… | SSP0015_ShipmentPSI.cs:5627 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | DATA_OP | request.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-6cb77d65 | SaveButton [else of (fps.Name == "spdMain") ▸ else of (siMai… | SSP0015_ShipmentPSI.cs:5628 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | DATA_OP | request.Parameters["p_check_need_yn"] | p_check_need_yn | 행/컬럼 값 대입 |  |  |  |
| AC-0c5cc214 | SaveButton [else of (fps.Name == "spdMain") ▸ else of (siMai… | SSP0015_ShipmentPSI.cs:5629 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | DATA_OP | request.Parameters["p_edit_main"] | p_edit_main | 행/컬럼 값 대입 |  |  |  |
| AC-39beb4d5 | SaveButton [else of (fps.Name == "spdMain") ▸ else of (siMai… | SSP0015_ShipmentPSI.cs:5630 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | DATA_OP | request.Parameters["p_shipto_code"] | p_shipto_code | 행/컬럼 값 대입 |  |  |  |
| AC-74c70a67 | SaveButton [else of (fps.Name == "spdMain") ▸ else of (siMai… | SSP0015_ShipmentPSI.cs:5632 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-62131ef4 | SaveButton [else of (fps.Name == "spdMain") ▸ else of (siMai… | SSP0015_ShipmentPSI.cs:5638 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-f449043d | SaveButton [else of (fps.Name == "spdMain") ▸ else of (siMai… | SSP0015_ShipmentPSI.cs:5639 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { ds.Tables[0].Rows[0][1].ToString() }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f22faf43 | SaveButton [else of (fps.Name == "spdMain") ▸ else of (siMai… | SSP0015_ShipmentPSI.cs:5657 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | MESSAGE | MessageHelper.GMessageBox | ("MSG00324") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-93d119d9 | SaveButton [else of (fps.Name == "spdMain") ▸ else of (siMai… | SSP0015_ShipmentPSI.cs:5659 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | CALL_BASE | base.AddHelpButton | ("Standard Information SSP Manual") | ⚠ 의미 확인 필요 |  |  |  |
| AC-d1275839 | SaveButton [else of (fps.Name == "spdMain") ▸ else of (siMai… | SSP0015_ShipmentPSI.cs:5667 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-468dc85d | SaveButton [else of (fps.Name == "spdMain") ▸ else of (siMai… | SSP0015_ShipmentPSI.cs:5679 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | MESSAGE | MessageHelper.GMessageBox | ("MSG00284", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-7d02dcf3 | SaveButton [else of (fps.Name == "spdMain") ▸ else of (siMai… | SSP0015_ShipmentPSI.cs:5691 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlo… | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SSP0015_ShipmentPSI.SaveData_Main

진입점: SaveButton [if (fps.Name == "spdMain")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fff94d6f | SaveButton [if (fps.Name == "spdMain")] | SSP0015_ShipmentPSI.cs:5331 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (fps.Name == "spdMain") ▸ if (siMain.ActiveSheet.Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-977d7b4f | SaveButton [if (fps.Name == "spdMain")] | SSP0015_ShipmentPSI.cs:5377 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j <… | GRID_STYLE | siMain.SetBGColor | (i, j, i, j, ControlColor.InvalidColor) | 그리드 표시 설정 |  |  |  |
| AC-884b8385 | SaveButton [if (fps.Name == "spdMain")] | SSP0015_ShipmentPSI.cs:5378 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j <… | MESSAGE | MessageHelper.GMessageBox | ("MSG00084", new object[] { null }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-5d9644bb | SaveButton [if (fps.Name == "spdMain")] | SSP0015_ShipmentPSI.cs:5379 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j <… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d6e0ee9a | SaveButton [if (fps.Name == "spdMain")] | SSP0015_ShipmentPSI.cs:5412 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ try | ENDPOINT | new FoxDataRequest | ("SSP.SSP0015_SAVE_SHIPMENT_PSI") ⇒ SSP.SSP0015_SAVE_SHIPMENT_PSI | 엔드포인트 요청 생성 |  |  |  |
| AC-33e84728 | SaveButton [if (fps.Name == "spdMain")] | SSP0015_ShipmentPSI.cs:5414 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-e9cadd02 | SaveButton [if (fps.Name == "spdMain")] | SSP0015_ShipmentPSI.cs:5415 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-a8b769f5 | SaveButton [if (fps.Name == "spdMain")] | SSP0015_ShipmentPSI.cs:5416 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-8c2a8db3 | SaveButton [if (fps.Name == "spdMain")] | SSP0015_ShipmentPSI.cs:5417 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-821c1dd4 | SaveButton [if (fps.Name == "spdMain")] | SSP0015_ShipmentPSI.cs:5418 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-c4499af7 | SaveButton [if (fps.Name == "spdMain")] | SSP0015_ShipmentPSI.cs:5419 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_yyyymmdd"] | p_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-e8d8db61 | SaveButton [if (fps.Name == "spdMain")] | SSP0015_ShipmentPSI.cs:5420 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-7230553d | SaveButton [if (fps.Name == "spdMain")] | SSP0015_ShipmentPSI.cs:5421 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-f531e00a | SaveButton [if (fps.Name == "spdMain")] | SSP0015_ShipmentPSI.cs:5422 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_measure"] | p_measure | 행/컬럼 값 대입 |  |  |  |
| AC-f53a7807 | SaveButton [if (fps.Name == "spdMain")] | SSP0015_ShipmentPSI.cs:5423 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_qty"] | p_qty | 행/컬럼 값 대입 |  |  |  |
| AC-e1cc37df | SaveButton [if (fps.Name == "spdMain")] | SSP0015_ShipmentPSI.cs:5424 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-4e94392c | SaveButton [if (fps.Name == "spdMain")] | SSP0015_ShipmentPSI.cs:5425 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-69c77e77 | SaveButton [if (fps.Name == "spdMain")] | SSP0015_ShipmentPSI.cs:5427 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-35029f45 | SaveButton [if (fps.Name == "spdMain")] | SSP0015_ShipmentPSI.cs:5432 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { response.DataSet.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-cb82c7ca | SaveButton [if (fps.Name == "spdMain")] | SSP0015_ShipmentPSI.cs:5449 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ try ▸ else of (response.Dat… | MESSAGE | MessageHelper.GMessageBox | ("MSG00284", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-00609817 | SaveButton [if (fps.Name == "spdMain")] | SSP0015_ShipmentPSI.cs:5458 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SSP0015_ShipmentPSI.SCM_SYS_LOG_BATCH

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c6c9cb78 | (진입점 미연결) | SSP0015_ShipmentPSI.cs:7876 | try | ENDPOINT | new FoxDataRequest | ("SCP.PR_SCM_SYS_LOG_BATCH") ⇒ SCP.PR_SCM_SYS_LOG_BATCH | 엔드포인트 요청 생성 |  |  |  |
| AC-2dd9dea2 | (진입점 미연결) | SSP0015_ShipmentPSI.cs:7877 | try | DATA_OP | request.Parameters["p_program_name"] | p_program_name | 행/컬럼 값 대입 |  |  |  |
| AC-b509b6a5 | (진입점 미연결) | SSP0015_ShipmentPSI.cs:7878 | try | DATA_OP | request.Parameters["p_log_type"] | p_log_type | 행/컬럼 값 대입 |  |  |  |
| AC-b43749b6 | (진입점 미연결) | SSP0015_ShipmentPSI.cs:7879 | try | DATA_OP | request.Parameters["p_log_count"] | p_log_count | 행/컬럼 값 대입 |  |  |  |
| AC-f17a80da | (진입점 미연결) | SSP0015_ShipmentPSI.cs:7880 | try | DATA_OP | request.Parameters["p_log_message"] | p_log_message | 행/컬럼 값 대입 |  |  |  |
| AC-8a3c8ef2 | (진입점 미연결) | SSP0015_ShipmentPSI.cs:7881 | try | DATA_OP | request.Parameters["p_description"] | p_description | 행/컬럼 값 대입 |  |  |  |
| AC-da11ea7e | (진입점 미연결) | SSP0015_ShipmentPSI.cs:7882 | try | DATA_OP | request.Parameters["p_event_date"] | DateTime.Now | 행/컬럼 값 대입 |  |  |  |
| AC-96653826 | (진입점 미연결) | SSP0015_ShipmentPSI.cs:7884 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## SSP0015_ShipmentPSI.Set_SumValues

진입점: this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex == 0) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) ▸ if (sMeasure == "WH_IN") ▸ if (Comments != null) ▸ if (ssp0015Popup.DialogResult == DialogResult.OK) ▸ try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] / FindButton [if (siMain.ActiveSheetIndex == 0) ▸ try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] / SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.Tables[0].Rows[0][0].ToString() == "S")…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f47455dc | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0015_ShipmentPSI.cs:2939 | for (nCol < columCount) ▸ if (dsBinding.Tables[0].Columns[nCol].ColumnName.IndexOf("M_") == 0) | DATA_OP | listMonth.Add | (nCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-57f2aa35 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0015_ShipmentPSI.cs:2943 | for (nCol < columCount) ▸ if (dsBinding.Tables[0].Columns[nCol].ColumnName.IndexOf("W_") == 0) | DATA_OP | listWeek.Add | (nCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-eb28f382 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0015_ShipmentPSI.cs:3006 | for (iRow < rowCount) ▸ if (measure.Equals("INCO_WIP") \|\| measure.Equals("INSP_WIP") \|\| measure.Equals("WH_STOCK") \|\| measure.Equals("… | GRID_SET | dsBinding.Tables[0].Rows[iRow][bef_month_idx] | dsBinding.Tables[0].Rows[iRow][bef_day_idx] | 그리드 속성/값 설정 |  |  |  |
| AC-22c9eafc | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0015_ShipmentPSI.cs:3014 | for (iRow < rowCount) ▸ if (measure.Equals("INCO_WIP") \|\| measure.Equals("INSP_WIP") \|\| measure.Equals("WH_STOCK") \|\| measure.Equals("… | GRID_SET | dsBinding.Tables[0].Rows[iRow][bef_week_idx] | dsBinding.Tables[0].Rows[iRow][bef_day_idx] | 그리드 속성/값 설정 |  |  |  |
| AC-7cbc30eb | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0015_ShipmentPSI.cs:3024 | for (iRow < rowCount) ▸ if (measure.Equals("INCO_WIP") \|\| measure.Equals("INSP_WIP") \|\| measure.Equals("WH_STOCK") \|\| measure.Equals("… | GRID_SET | dsBinding.Tables[0].Rows[iRow][bef_week_idx] | dsBinding.Tables[0].Rows[iRow][bef_day_idx] | 그리드 속성/값 설정 |  |  |  |
| AC-e94d91a7 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0015_ShipmentPSI.cs:3025 | for (iRow < rowCount) ▸ if (measure.Equals("INCO_WIP") \|\| measure.Equals("INSP_WIP") \|\| measure.Equals("WH_STOCK") \|\| measure.Equals("… | GRID_SET | dsBinding.Tables[0].Rows[iRow][bef_month_idx] | dsBinding.Tables[0].Rows[iRow][bef_day_idx] | 그리드 속성/값 설정 |  |  |  |

## SSP0015_ShipmentPSI.SetBalanceMinus

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-48422086 | (진입점 미연결) | SSP0015_ShipmentPSI.cs:5123 | if (siMain.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-020f2df6 | (진입점 미연결) | SSP0015_ShipmentPSI.cs:5126 |  | DATA_OP | dt.Columns.Add | ("DivisionID") | 데이터 객체 조작/조회 |  |  |  |
| AC-a4cb4b82 | (진입점 미연결) | SSP0015_ShipmentPSI.cs:5127 |  | DATA_OP | dt.Columns.Add | ("FromSite") | 데이터 객체 조작/조회 |  |  |  |
| AC-5ffb76c7 | (진입점 미연결) | SSP0015_ShipmentPSI.cs:5128 |  | DATA_OP | dt.Columns.Add | ("ItemID") | 데이터 객체 조작/조회 |  |  |  |
| AC-b0bed8be | (진입점 미연결) | SSP0015_ShipmentPSI.cs:5156 | for (iRow < siMain.ActiveSheet.RowCount) ▸ for (iCol < siMain.ActiveSheet.ColumnCount) ▸ if (siMain.GetColumnTag(iCol).IndexOf("D_") == 0) ▸… | DATA_OP | dt.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-fff96e27 | (진입점 미연결) | SSP0015_ShipmentPSI.cs:5157 | for (iRow < siMain.ActiveSheet.RowCount) ▸ for (iCol < siMain.ActiveSheet.ColumnCount) ▸ if (siMain.GetColumnTag(iCol).IndexOf("D_") == 0) ▸… | DATA_OP | dr["DivisionID"] | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.DIVISION_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-3766239f | (진입점 미연결) | SSP0015_ShipmentPSI.cs:5158 | for (iRow < siMain.ActiveSheet.RowCount) ▸ for (iCol < siMain.ActiveSheet.ColumnCount) ▸ if (siMain.GetColumnTag(iCol).IndexOf("D_") == 0) ▸… | DATA_OP | dr["FromSite"] | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.FROM_SITE)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-692b6ca8 | (진입점 미연결) | SSP0015_ShipmentPSI.cs:5159 | for (iRow < siMain.ActiveSheet.RowCount) ▸ for (iCol < siMain.ActiveSheet.ColumnCount) ▸ if (siMain.GetColumnTag(iCol).IndexOf("D_") == 0) ▸… | DATA_OP | dr["ItemID"] | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ITEM_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-eea55f94 | (진입점 미연결) | SSP0015_ShipmentPSI.cs:5160 | for (iRow < siMain.ActiveSheet.RowCount) ▸ for (iCol < siMain.ActiveSheet.ColumnCount) ▸ if (siMain.GetColumnTag(iCol).IndexOf("D_") == 0) ▸… | DATA_OP | dt.Rows.Add | (dr) | 데이터 객체 조작/조회 |  |  |  |
| AC-c0d6c3e1 | (진입점 미연결) | SSP0015_ShipmentPSI.cs:5178 | if (dt.Rows.Count > 0) ▸ foreach (DataRow dr in dt.Rows) | DATA_OP | (siMain.SpreadObject.DataSource as DataSet).Tables[0].Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-855701b1 | (진입점 미연결) | SSP0015_ShipmentPSI.cs:5185 | if (dt.Rows.Count > 0) ▸ foreach (DataRow dr in dt.Rows) ▸ if (list.Count > 0) ▸ foreach (DataRow dr2 in list) | DATA_OP | dtBalanceMinus.ImportRow | (dr2) | 데이터 객체 조작/조회 |  |  |  |

## SSP0015_ShipmentPSI.SetChangeControl

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-516ac13d | this.Load | SSP0015_ShipmentPSI.cs:449 |  | DATA_OP | Filter["GROUP_ID"] | UserInfoContext.Current["NowGroupID"] | 행/컬럼 값 대입 |  |  |  |
| AC-d84622bb | this.Load | SSP0015_ShipmentPSI.cs:450 |  | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-842f6fbf | this.Load | SSP0015_ShipmentPSI.cs:456 | switch (triggerControl) case "MyDivision": | FLAG | dtMyDivision | DataService.GetSSPInnerTable("MyDivision", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-723da816 | this.Load | SSP0015_ShipmentPSI.cs:456 | switch (triggerControl) case "MyDivision": | COMBO_DATA | DataService.GetSSPInnerTable | ("MyDivision", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-2543b887 | this.Load | SSP0015_ShipmentPSI.cs:461 | switch (triggerControl) case "CHANGE_REASON_CODE_ALL": | FLAG | dtChangeReasonCode | DataService.GetSSPInnerTable("CHANGE_REASON_CODE_ALL", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-0a978d1e | this.Load | SSP0015_ShipmentPSI.cs:461 | switch (triggerControl) case "CHANGE_REASON_CODE_ALL": | COMBO_DATA | DataService.GetSSPInnerTable | ("CHANGE_REASON_CODE_ALL", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-42b2a9d5 | this.Load | SSP0015_ShipmentPSI.cs:466 | switch (triggerControl) case "SALES_TYPE_CODE": | FLAG | dtFcstType | DataService.GetSSPInnerTable("SALES_TYPE_CODE", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-eab04050 | this.Load | SSP0015_ShipmentPSI.cs:466 | switch (triggerControl) case "SALES_TYPE_CODE": | COMBO_DATA | DataService.GetSSPInnerTable | ("SALES_TYPE_CODE", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-2f984a53 | this.Load | SSP0015_ShipmentPSI.cs:471 | switch (triggerControl) case "MyModelChk": | FLAG | dtMyModelChk | DataService.GetSSPInnerTable("MyModelChk", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-7a146370 | this.Load | SSP0015_ShipmentPSI.cs:471 | switch (triggerControl) case "MyModelChk": | COMBO_DATA | DataService.GetSSPInnerTable | ("MyModelChk", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-c56c6186 | this.Load | SSP0015_ShipmentPSI.cs:476 | switch (triggerControl) case "CompanyID": | FLAG | dtCompany | DataService.GetSSPInnerTable("CompanyID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-d82cb5b5 | this.Load | SSP0015_ShipmentPSI.cs:476 | switch (triggerControl) case "CompanyID": | COMBO_DATA | DataService.GetSSPInnerTable | ("CompanyID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-83256c2e | this.Load | SSP0015_ShipmentPSI.cs:481 | switch (triggerControl) case "OWMS_STOCK_STATUS": | FLAG | dtStockStatus | DataService.GetSSPInnerTable("OWMS_STOCK_STATUS", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-35e613f6 | this.Load | SSP0015_ShipmentPSI.cs:481 | switch (triggerControl) case "OWMS_STOCK_STATUS": | COMBO_DATA | DataService.GetSSPInnerTable | ("OWMS_STOCK_STATUS", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-dc7a5ccc | this.Load | SSP0015_ShipmentPSI.cs:486 | switch (triggerControl) case "CHANGE_REQ_DAY": | FLAG | dtBaseDay | DataService.GetSSPInnerTable("CHANGE_REQ_DAY", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-eede6921 | this.Load | SSP0015_ShipmentPSI.cs:486 | switch (triggerControl) case "CHANGE_REQ_DAY": | COMBO_DATA | DataService.GetSSPInnerTable | ("CHANGE_REQ_DAY", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-326a4c20 | this.Load | SSP0015_ShipmentPSI.cs:491 | switch (triggerControl) case "SSP_SHIPMENT_RESULT_TYPE": | FLAG | dtResultType | DataService.GetSSPInnerTable("SSP_SHIPMENT_RESULT_TYPE", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-a98b4916 | this.Load | SSP0015_ShipmentPSI.cs:491 | switch (triggerControl) case "SSP_SHIPMENT_RESULT_TYPE": | COMBO_DATA | DataService.GetSSPInnerTable | ("SSP_SHIPMENT_RESULT_TYPE", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-7993fd41 | this.Load | SSP0015_ShipmentPSI.cs:496 | switch (triggerControl) case "PgmAuthId": | FLAG | dtPgmAuthId | DataService.GetSSPInnerTable("PgmAuthId", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-9a7dc16a | this.Load | SSP0015_ShipmentPSI.cs:496 | switch (triggerControl) case "PgmAuthId": | COMBO_DATA | DataService.GetSSPInnerTable | ("PgmAuthId", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-3a38d1d7 | this.Load | SSP0015_ShipmentPSI.cs:501 | switch (triggerControl) case "SHIPMENT_PERIOD_DAY": | FLAG | dtShipmentInputPeriod | DataService.GetSSPInnerTable("SHIPMENT_PERIOD_DAY", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-bdecfeb1 | this.Load | SSP0015_ShipmentPSI.cs:501 | switch (triggerControl) case "SHIPMENT_PERIOD_DAY": | COMBO_DATA | DataService.GetSSPInnerTable | ("SHIPMENT_PERIOD_DAY", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |

## SSP0015_ShipmentPSI.SetChangedControl

진입점: this.Load / this.spdMain.ActiveSheetChanged / clbDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-950b75a4 | this.Load 외 2 | SSP0015_ShipmentPSI.cs:2201 | if (spdMain.ActiveSheetIndex == 0) | FLAG | dtPlantSiteByDivision | Data_SCP.Common(Data_SCP.Type.ShipmentRequestPlantSite, false, pDivisionID, "P", "E") | 화면 필드/플래그 변경 |  |  |  |
| AC-a3437c17 | this.Load 외 2 | SSP0015_ShipmentPSI.cs:2201 | if (spdMain.ActiveSheetIndex == 0) | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.ShipmentRequestPlantSite, false, pDivisionID, "P", "E") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-b003df76 | this.Load 외 2 | SSP0015_ShipmentPSI.cs:2202 | if (spdMain.ActiveSheetIndex == 0) | FLAG | dtPlanDate | Data.Common(Data.Type.PlanDateShip, false, pDivisionID, "A") ⇒ biz:CommonData.CommonDataList [code=PlanDateShip] | 화면 필드/플래그 변경 |  |  |  |
| AC-fa03a174 | this.Load 외 2 | SSP0015_ShipmentPSI.cs:2202 | if (spdMain.ActiveSheetIndex == 0) | COMBO_DATA | Data.Common | (Data.Type.PlanDateShip, false, pDivisionID, "A") ⇒ biz:CommonData.CommonDataList [code=PlanDateShip] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-bac2d2f2 | this.Load 외 2 | SSP0015_ShipmentPSI.cs:2203 | if (spdMain.ActiveSheetIndex == 0) | FLAG | dtNewPlanDate | dtPlanDate | 화면 필드/플래그 변경 |  |  |  |
| AC-788800b8 | this.Load 외 2 | SSP0015_ShipmentPSI.cs:2204 | if (spdMain.ActiveSheetIndex == 0) | VALUE_SET | drpPeriod.InitValue | GetDayRange("A") | 컨트롤 값 설정 |  |  |  |
| AC-a6edf6ac | this.Load 외 2 | SSP0015_ShipmentPSI.cs:2205 | if (spdMain.ActiveSheetIndex == 0) | VALUE_SET | drpPeriod2.InitValue | GetDayRange("A") | 컨트롤 값 설정 |  |  |  |
| AC-874ccd2e | this.Load 외 2 | SSP0015_ShipmentPSI.cs:2209 | else of (spdMain.ActiveSheetIndex == 0) ▸ if (spdMain.ActiveSheetIndex == 1) | FLAG | dtPlantSiteByDivision | Data.UserPlantSiteByDivisionOspPack(UserInfoContext.Current["NowGroupID"], UserInfoContext… | 화면 필드/플래그 변경 |  |  |  |
| AC-3b79f072 | this.Load 외 2 | SSP0015_ShipmentPSI.cs:2209 | else of (spdMain.ActiveSheetIndex == 0) ▸ if (spdMain.ActiveSheetIndex == 1) | COMBO_DATA | Data.UserPlantSiteByDivisionOspPack | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, pDivisionID) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-e0a573d9 | this.Load 외 2 | SSP0015_ShipmentPSI.cs:2210 | else of (spdMain.ActiveSheetIndex == 0) ▸ if (spdMain.ActiveSheetIndex == 1) | FLAG | dtPlanDate | Data.Common(Data.Type.PlanDateShip, false, pDivisionID, "P") ⇒ biz:CommonData.CommonDataList [code=PlanDateShip] | 화면 필드/플래그 변경 |  |  |  |
| AC-5e205dba | this.Load 외 2 | SSP0015_ShipmentPSI.cs:2210 | else of (spdMain.ActiveSheetIndex == 0) ▸ if (spdMain.ActiveSheetIndex == 1) | COMBO_DATA | Data.Common | (Data.Type.PlanDateShip, false, pDivisionID, "P") ⇒ biz:CommonData.CommonDataList [code=PlanDateShip] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-705e5cbd | this.Load 외 2 | SSP0015_ShipmentPSI.cs:2211 | else of (spdMain.ActiveSheetIndex == 0) ▸ if (spdMain.ActiveSheetIndex == 1) | FLAG | dtNewPlanDate | dtPlanDate | 화면 필드/플래그 변경 |  |  |  |
| AC-337623d6 | this.Load 외 2 | SSP0015_ShipmentPSI.cs:2212 | else of (spdMain.ActiveSheetIndex == 0) ▸ if (spdMain.ActiveSheetIndex == 1) | VALUE_SET | drpPeriod.InitValue | GetDayRange("P") | 컨트롤 값 설정 |  |  |  |
| AC-3fc56ce1 | this.Load 외 2 | SSP0015_ShipmentPSI.cs:2213 | else of (spdMain.ActiveSheetIndex == 0) ▸ if (spdMain.ActiveSheetIndex == 1) | VALUE_SET | drpPeriod2.InitValue | GetDayRange("P") | 컨트롤 값 설정 |  |  |  |
| AC-e8eace3e | this.Load 외 2 | SSP0015_ShipmentPSI.cs:2217 | else of (spdMain.ActiveSheetIndex == 0) ▸ else of (spdMain.ActiveSheetIndex == 1) | FLAG | dtPlantSiteByDivision | Data_SCP.Common(Data_SCP.Type.ShipmentRequestPlantSite, false, pDivisionID, "P", "E") | 화면 필드/플래그 변경 |  |  |  |
| AC-e7ea081d | this.Load 외 2 | SSP0015_ShipmentPSI.cs:2217 | else of (spdMain.ActiveSheetIndex == 0) ▸ else of (spdMain.ActiveSheetIndex == 1) | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.ShipmentRequestPlantSite, false, pDivisionID, "P", "E") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-1cc86f0e | this.Load 외 2 | SSP0015_ShipmentPSI.cs:2218 | else of (spdMain.ActiveSheetIndex == 0) ▸ else of (spdMain.ActiveSheetIndex == 1) | FLAG | dtPlanDate | Data.Common(Data.Type.PlanDateShip, false, pDivisionID, "A") ⇒ biz:CommonData.CommonDataList [code=PlanDateShip] | 화면 필드/플래그 변경 |  |  |  |
| AC-3846cde3 | this.Load 외 2 | SSP0015_ShipmentPSI.cs:2218 | else of (spdMain.ActiveSheetIndex == 0) ▸ else of (spdMain.ActiveSheetIndex == 1) | COMBO_DATA | Data.Common | (Data.Type.PlanDateShip, false, pDivisionID, "A") ⇒ biz:CommonData.CommonDataList [code=PlanDateShip] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-8596c576 | this.Load 외 2 | SSP0015_ShipmentPSI.cs:2219 | else of (spdMain.ActiveSheetIndex == 0) ▸ else of (spdMain.ActiveSheetIndex == 1) | FLAG | dtNewPlanDate | dtPlanDate | 화면 필드/플래그 변경 |  |  |  |
| AC-53edb36a | this.Load 외 2 | SSP0015_ShipmentPSI.cs:2220 | else of (spdMain.ActiveSheetIndex == 0) ▸ else of (spdMain.ActiveSheetIndex == 1) | VALUE_SET | drpPeriod.InitValue | GetDayRange("A") | 컨트롤 값 설정 |  |  |  |
| AC-799f9c9d | this.Load 외 2 | SSP0015_ShipmentPSI.cs:2221 | else of (spdMain.ActiveSheetIndex == 0) ▸ else of (spdMain.ActiveSheetIndex == 1) | VALUE_SET | drpPeriod2.InitValue | GetDayRange("A") | 컨트롤 값 설정 |  |  |  |
| AC-74ca354c | this.Load 외 2 | SSP0015_ShipmentPSI.cs:2226 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlantSiteByDivision, clbPlantSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-9ac5ba84 | this.Load 외 2 | SSP0015_ShipmentPSI.cs:2230 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanDate, cboPlanDate, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SSP0015_ShipmentPSI.SetChangedPeriod

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-91b07903 | (진입점 미연결) | SSP0015_ShipmentPSI.cs:9207 | if (string.IsNullOrEmpty(strcboPlanDate)) | COMBO_DATA | Data.CallBizCommonData | ("PERIOD_" + value) ⇒ biz:CommonData.CommonDataList [code=PERIOD_{p:value}] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-8823db5f | (진입점 미연결) | SSP0015_ShipmentPSI.cs:9211 | else of (string.IsNullOrEmpty(strcboPlanDate)) | COMBO_DATA | Data.CallBizCommonData | ("PERIOD2_" + value, strcboPlanDate) ⇒ biz:CommonData.CommonDataList [code=PERIOD2_{p:value}] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-4fdfe729 | (진입점 미연결) | SSP0015_ShipmentPSI.cs:9214 | if (dt == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8b1aa830 | (진입점 미연결) | SSP0015_ShipmentPSI.cs:9218 | if (dt.Rows.Count > 0) | UI_PROP | drpPeriod.Text1 | dt.Rows[0]["FROM_VALUE"].ToString() | 속성 Text1 설정 |  |  |  |
| AC-863f004b | (진입점 미연결) | SSP0015_ShipmentPSI.cs:9219 | if (dt.Rows.Count > 0) | UI_PROP | drpPeriod.Text2 | dt.Rows[0]["TO_VALUE"].ToString() | 속성 Text2 설정 |  |  |  |

## SSP0015_ShipmentPSI.SetImageCell

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-64d58b9d | (진입점 미연결) | SSP0015_ShipmentPSI.cs:5007 | for (iRow < siDetail.ActiveSheet.RowCount) | GRID_SET | siDetail.ActiveSheet.Cells[iRow, siDetail.GetColumnIndex(DefColumns.INCOTERMS)].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-5e184f27 | (진입점 미연결) | SSP0015_ShipmentPSI.cs:5008 | for (iRow < siDetail.ActiveSheet.RowCount) | GRID_SET | siDetail.ActiveSheet.Cells[iRow, siDetail.GetColumnIndex(DefColumns.CHANGE_REQ_NO)].CellTy… | cellTypeImage | 그리드 속성/값 설정 |  |  |  |

## SSP0015_ShipmentPSI.SetLockSumColumn

진입점: EditButton [if (fps != null && isPass == true) ▸ if (fps.Name == "spdMain")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e367115c | EditButton [if (fps != null && isPass == true) ▸ if (fps.Nam… | SSP0015_ShipmentPSI.cs:2179 | for (iCol < spreadInfo.ActiveSheet.ColumnCount) ▸ if (spreadInfo.GetColumnTag(iCol).IndexOf("W_") == 0 \|\| spreadInfo.GetColumnTag(iCol).In… | GRID_LOCK | spreadInfo.LockRange | (0, iCol, spreadInfo.ActiveSheet.RowCount - 1, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |

## SSP0015_ShipmentPSI.SetNote_Display

진입점: this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex == 0) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) ▸ if (sMeasure == "WH_IN") ▸ if (Comments != null) ▸ if (ssp0015Popup.DialogResult == DialogResult.OK) ▸ try ▸ for (iRow < rowCount) ▸ if (sMeasure == "PROD_DATE" \|\| sMeasure == "LOT" \|\| sMeasure == "WH_IN" \|\| sMeasure == "PROD_PLAN") ▸ for (nCol < columnCount) ▸ else of (sMeasure == "PROD_DATE") ▸ else of (sMeasure == "LOT") ▸ if (intNoteCnt > 0 && sMeasure == "WH_IN") ▸ if (drPgmAuthId != null)] / FindButton [if (siMain.ActiveSheetIndex == 0) ▸ try ▸ for (iRo…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-84ef457c | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0015_ShipmentPSI.cs:3043 |  | DATA_OP | row.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-570c256d | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0015_ShipmentPSI.cs:3044 |  | DATA_OP | row.Field | ("SITE") | 데이터 객체 조작/조회 |  |  |  |
| AC-e0f834d9 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0015_ShipmentPSI.cs:3045 |  | DATA_OP | row.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-b73169f8 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0015_ShipmentPSI.cs:3046 |  | DATA_OP | row.Field | ("YYYYMMDD") | 데이터 객체 조작/조회 |  |  |  |
| AC-2ea0b66a | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0015_ShipmentPSI.cs:3053 | if (Comments != null) | GRID_SET | spdMain.ActiveSheet.Cells[intRowIdx, intColIdx].Note | strComments | 그리드 속성/값 설정 |  |  |  |
| AC-7d1db932 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0015_ShipmentPSI.cs:3054 | if (Comments != null) | GRID_SET | spdMain.ActiveSheet.Cells[intRowIdx, intColIdx].NoteIndicatorSize | new Size(5, 5) | 그리드 속성/값 설정 |  |  |  |

## SSP0015_ShipmentPSI.SetProdNote_Display

진입점: this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex == 0) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) ▸ if (sMeasure == "WH_IN") ▸ if (Comments != null) ▸ if (ssp0015Popup.DialogResult == DialogResult.OK) ▸ try ▸ for (iRow < rowCount) ▸ if (sMeasure == "PROD_DATE" \|\| sMeasure == "LOT" \|\| sMeasure == "WH_IN" \|\| sMeasure == "PROD_PLAN") ▸ for (nCol < columnCount) ▸ else of (sMeasure == "PROD_DATE") ▸ else of (sMeasure == "LOT") ▸ else of (intNoteCnt > 0 && sMeasure == "WH_IN") ▸ if (intProdNoteCNT > 0 && sMeasure == "PROD_PLAN") ▸ if (drPgmAuthId != null)] / Find…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a2998d89 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0015_ShipmentPSI.cs:3069 |  | DATA_OP | row.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-5db8270c | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0015_ShipmentPSI.cs:3070 |  | DATA_OP | row.Field | ("SITE") | 데이터 객체 조작/조회 |  |  |  |
| AC-03a500a3 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0015_ShipmentPSI.cs:3071 |  | DATA_OP | row.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-b12d832c | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0015_ShipmentPSI.cs:3072 |  | DATA_OP | row.Field | ("YYYYMMDD") | 데이터 객체 조작/조회 |  |  |  |
| AC-7cfd0b2c | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0015_ShipmentPSI.cs:3079 | if (drProdQty != null) | GRID_SET | spdMain.ActiveSheet.Cells[intRowIdx, intColIdx].Note | strProdQty | 그리드 속성/값 설정 |  |  |  |
| AC-2a8fe21c | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0015_ShipmentPSI.cs:3080 | if (drProdQty != null) | GRID_SET | spdMain.ActiveSheet.Cells[intRowIdx, intColIdx].NoteIndicatorSize | new Size(5, 5) | 그리드 속성/값 설정 |  |  |  |
| AC-13155ec5 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0015_ShipmentPSI.cs:3081 | if (drProdQty != null) | GRID_SET | spdMain.ActiveSheet.Cells[intRowIdx, intColIdx].NoteIndicatorColor | Color.Blue | 그리드 속성/값 설정 |  |  |  |
| AC-3d5181c8 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0015_ShipmentPSI.cs:3083 | if (drProdQty != null) | CALL_EXT | spdMain.ActiveSheet.GetStickyNoteStyleInfo | (intRowIdx, intColIdx) | ⚠ 의미 확인 필요 |  |  |  |
| AC-dbdc6ebe | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0015_ShipmentPSI.cs:3085 | if (drProdQty != null) | UI_PROP | nsinfo.Width | 170 | 속성 Width 설정 |  |  |  |
| AC-2245abc7 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheetIndex ==… 외 3 | SSP0015_ShipmentPSI.cs:3087 | if (drProdQty != null) | CALL_EXT | spdMain.ActiveSheet.SetStickyNoteStyleInfo | (intRowIdx, intColIdx, nsinfo) | ⚠ 의미 확인 필요 |  |  |  |

## SSP0015_ShipmentPSI.SetSoNoColumnVisible

진입점: this.Load [else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPacker) ▸ if (spdInfo.SheetName == SpdSheet.shtDetail)] / this.spdMain.CellDoubleClick [for (i < spdDetail.Sheets.Count) ▸ else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPacker) ▸ if (spdInfo.SheetName == SpdSheet.shtDetail)] / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (fps.Name == "spdMain") ▸ else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPacker) ▸ if (spdInfo.SheetName == Sp…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c505b074 | this.Load [else of (spdInfo.SheetName == SpdSheet.shtMain) ▸… 외 7 | SSP0015_ShipmentPSI.cs:9778 | if (ichkbtn == 1) ▸ if (sSheetName == SpdSheet.shtPacker) | GRID_SET | siDetail.ActiveSheet.Columns[DefColumns.ERP_SO_NO].Width | 80 | 그리드 속성/값 설정 |  |  |  |
| AC-7d9c48d6 | this.Load [else of (spdInfo.SheetName == SpdSheet.shtMain) ▸… 외 7 | SSP0015_ShipmentPSI.cs:9782 | if (ichkbtn == 1) ▸ else of (sSheetName == SpdSheet.shtPacker) | GRID_SET | siDetail.ActiveSheet.Columns[DefColumns.ERP_SO_NO].Width | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-732e412e | this.Load [else of (spdInfo.SheetName == SpdSheet.shtMain) ▸… 외 7 | SSP0015_ShipmentPSI.cs:9789 | else of (ichkbtn == 1) ▸ if (sSheetName == SpdSheet.shtPacker) | GRID_SET | siDetail.ActiveSheet.Columns[DefColumns.ERP_SO_NO].Width | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-c6cb4b1e | this.Load [else of (spdInfo.SheetName == SpdSheet.shtMain) ▸… 외 7 | SSP0015_ShipmentPSI.cs:9793 | else of (ichkbtn == 1) ▸ else of (sSheetName == SpdSheet.shtPacker) | GRID_SET | siDetail.ActiveSheet.Columns[DefColumns.ERP_SO_NO].Width | 80 | 그리드 속성/값 설정 |  |  |  |

## SSP0015_ShipmentPSI.SetSpreadColumn

진입점: this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] / this.spdMain.CellDoubleClick [for (i < spdDetail.Sheets.Count) ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (fps.Name == "spdMain") ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / this.cboBucketType.SelectedIndexChanged / this.chkSum.CheckedChanged / this.btnSearch.Click [if (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ if (siMain.ActiveSheetIndex == 0) ▸ try ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / this.spdMain.ActiveSheetChanged [if (spdInfo.Sheet…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-af5e0bdc | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SSP0015_ShipmentPSI.cs:2116 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Daily) ▸ if (siMain.GetColumnTag(iCol).IndexOf("D_"… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-303c3025 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SSP0015_ShipmentPSI.cs:2121 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Daily) ▸ if (siMain.GetColumnTag(iCol).IndexOf("M_"… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | chkSum.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-cb0d9467 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SSP0015_ShipmentPSI.cs:2128 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Bu… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-53f41b15 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SSP0015_ShipmentPSI.cs:2132 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Bu… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-9dc283ee | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SSP0015_ShipmentPSI.cs:2137 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Bu… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | chkSum.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-3e4c5521 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SSP0015_ShipmentPSI.cs:2144 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ else of (cboBucketType.ControlValues … | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-9372e105 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SSP0015_ShipmentPSI.cs:2148 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ else of (cboBucketType.ControlValues … | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |

## SSP0015_ShipmentPSI.ShipmentResult_GetDayRange

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4d99d631 | this.Load | SSP0015_ShipmentPSI.cs:9330 |  | RETURN | return sDayRange; |  | 처리 중단/반환 |  |  |  |

## SSP0015_ShipmentPSI.shtDetail_Change

진입점: dsdm.Changed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4f8e4092 | dsdm.Changed | SSP0015_ShipmentPSI.cs:7471 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (this.CanModelChange != true \|\| e.Row == -1 && e… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-00dc0c1d | dsdm.Changed | SSP0015_ShipmentPSI.cs:7472 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e16dd721 | dsdm.Changed | SSP0015_ShipmentPSI.cs:7483 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.IsLock(siDetail.SheetName) == false) ▸ i… | MESSAGE | MessageHelper.GMessageBox | ("MSG00189") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6e693b8f | dsdm.Changed | SSP0015_ShipmentPSI.cs:7488 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.IsLock(siDetail.SheetName) == false) ▸ i… | MESSAGE | MessageHelper.GMessageBox | ("MSG00362") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-485d0400 | dsdm.Changed | SSP0015_ShipmentPSI.cs:7490 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.IsLock(siDetail.SheetName) == false) ▸ i… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-678705c4 | dsdm.Changed | SSP0015_ShipmentPSI.cs:7557 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.IsLock(siDetail.SheetName) == false) ▸ i… | MESSAGE | MessageHelper.GMessageBox | ("MSG00278") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-bf8b9448 | dsdm.Changed | SSP0015_ShipmentPSI.cs:7558 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.IsLock(siDetail.SheetName) == false) ▸ i… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a1746cf0 | dsdm.Changed | SSP0015_ShipmentPSI.cs:7572 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.IsLock(siDetail.SheetName) == false) ▸ i… | GRID_SET | siDetail.SetValue | (e.Row, siDetail.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-2e4605dd | dsdm.Changed | SSP0015_ShipmentPSI.cs:7582 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.IsLock(siDetail.SheetName) == false) ▸ i… | GRID_SET | siDetail.SetValue | (iRow, siDetail.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-accbc1b5 | dsdm.Changed | SSP0015_ShipmentPSI.cs:7584 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.IsLock(siDetail.SheetName) == false) ▸ i… | GRID_SET | siDetail.ActiveSheet.Cells[iRow, siDetail.GetColumnIndex(CAppSetting.StringAction)].Value | CAppSetting.StringM | 그리드 속성/값 설정 |  |  |  |
| AC-40dbf7cb | dsdm.Changed | SSP0015_ShipmentPSI.cs:7585 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.IsLock(siDetail.SheetName) == false) ▸ i… | GRID_SET | siDetail.ActiveSheet.Cells[iRow, siDetail.GetColumnIndex(CAppSetting.StringAction)].ForeCo… | ControlColor.FGAction | 그리드 속성/값 설정 |  |  |  |
| AC-6a3da2f7 | dsdm.Changed | SSP0015_ShipmentPSI.cs:7586 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.IsLock(siDetail.SheetName) == false) ▸ i… | GRID_SET | siDetail.ActiveSheet.Cells[iRow, siDetail.GetColumnIndex(CAppSetting.StringAction)].BackCo… | ControlColor.BGModified | 그리드 속성/값 설정 |  |  |  |
| AC-02276077 | dsdm.Changed | SSP0015_ShipmentPSI.cs:7590 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.IsLock(siDetail.SheetName) == false) ▸ i… | GRID_SET | siDetail.SetValue | (e.Row, siDetail.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-f24f8651 | dsdm.Changed | SSP0015_ShipmentPSI.cs:7601 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.IsLock(siDetail.SheetName) == false) ▸ e… | GRID_SET | siDetail.SetValue | (e.Row, siDetail.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-ac18dfa2 | dsdm.Changed | SSP0015_ShipmentPSI.cs:7611 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.IsLock(siDetail.SheetName) == false) ▸ e… | GRID_SET | siDetail.SetValue | (iRow, siDetail.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-a7db9d4c | dsdm.Changed | SSP0015_ShipmentPSI.cs:7613 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.IsLock(siDetail.SheetName) == false) ▸ e… | GRID_SET | siDetail.ActiveSheet.Cells[iRow, siDetail.GetColumnIndex(CAppSetting.StringAction)].Value | CAppSetting.StringM | 그리드 속성/값 설정 |  |  |  |
| AC-501cecaf | dsdm.Changed | SSP0015_ShipmentPSI.cs:7614 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.IsLock(siDetail.SheetName) == false) ▸ e… | GRID_SET | siDetail.ActiveSheet.Cells[iRow, siDetail.GetColumnIndex(CAppSetting.StringAction)].ForeCo… | ControlColor.FGAction | 그리드 속성/값 설정 |  |  |  |
| AC-e72e16c5 | dsdm.Changed | SSP0015_ShipmentPSI.cs:7615 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.IsLock(siDetail.SheetName) == false) ▸ e… | GRID_SET | siDetail.ActiveSheet.Cells[iRow, siDetail.GetColumnIndex(CAppSetting.StringAction)].BackCo… | ControlColor.BGModified | 그리드 속성/값 설정 |  |  |  |
| AC-6d15b804 | dsdm.Changed | SSP0015_ShipmentPSI.cs:7630 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.IsLock(siDetail.SheetName) == false) ▸ e… | GRID_SET | siDetail.SetValue | (e.Row, siDetail.GetColumnIndex(DefColumns.CHANGE_REASON_DETAIL), "") | 그리드 값 설정 |  |  |  |
| AC-862d0422 | dsdm.Changed | SSP0015_ShipmentPSI.cs:7631 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.IsLock(siDetail.SheetName) == false) ▸ e… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5390170d | dsdm.Changed | SSP0015_ShipmentPSI.cs:7635 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.IsLock(siDetail.SheetName) == false) ▸ e… | GRID_SET | siDetail.SetValue | (e.Row, siDetail.GetColumnIndex(DefColumns.CHANGE_REASON_DETAIL), "") | 그리드 값 설정 |  |  |  |
| AC-6d06ae9d | dsdm.Changed | SSP0015_ShipmentPSI.cs:7642 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.IsLock(siDetail.SheetName) == false) ▸ e… | GRID_SET | siDetail.SetValue | (e.Row, siDetail.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-86c354c2 | dsdm.Changed | SSP0015_ShipmentPSI.cs:7652 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.IsLock(siDetail.SheetName) == false) ▸ e… | GRID_SET | siDetail.SetValue | (iRow, siDetail.GetColumnIndex(DefColumns.CHANGE_REASON_CODE), sNewChangeReasonCode) | 그리드 값 설정 |  |  |  |
| AC-b70cbe58 | dsdm.Changed | SSP0015_ShipmentPSI.cs:7653 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.IsLock(siDetail.SheetName) == false) ▸ e… | GRID_SET | siDetail.SetValue | (iRow, siDetail.GetColumnIndex(DefColumns.CHANGE_REASON_DETAIL), sNewChangeReasonDetail) | 그리드 값 설정 |  |  |  |
| AC-b1b65675 | dsdm.Changed | SSP0015_ShipmentPSI.cs:7654 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.IsLock(siDetail.SheetName) == false) ▸ e… | GRID_SET | siDetail.SetValue | (iRow, siDetail.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-a04d396b | dsdm.Changed | SSP0015_ShipmentPSI.cs:7666 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.IsLock(siDetail.SheetName) == false) ▸ e… | GRID_SET | siDetail.SetValue | (e.Row, siDetail.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-4c9e7de4 | dsdm.Changed | SSP0015_ShipmentPSI.cs:7676 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.IsLock(siDetail.SheetName) == false) ▸ e… | GRID_SET | siDetail.SetValue | (iRow, siDetail.GetColumnIndex(DefColumns.CHANGE_REASON_DETAIL), sNewChangeReasonDetail) | 그리드 값 설정 |  |  |  |
| AC-7e51f01c | dsdm.Changed | SSP0015_ShipmentPSI.cs:7677 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siDetail.IsLock(siDetail.SheetName) == false) ▸ e… | GRID_SET | siDetail.SetValue | (iRow, siDetail.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |

## SSP0015_ShipmentPSI.SoNo

진입점: SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.ActiveSheetIndex == 0) ▸ if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlockYn()) ▸ try ▸ try ▸ for (i <= siDetail.ActiveSheet.RowCount - 1) ▸ if (action != CAppSetting.FlagI) ▸ else of (string.IsNullOrWhiteSpace(erpSoNo))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f97fa0d9 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6953 | for (i < intRowIdx) ▸ if (erpSoNo == siDetail.GetValue(i, siDetail.GetColumnIndex(DefColumns.ERP_SO_NO)).ToString()) ▸ if (intRowIdx > i) | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-d72aab54 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:7076 | try ▸ if (siMain.ActiveSheetIndex == 0) | ENDPOINT | new FoxDataRequest | ("SSP.SSP0015_SAVE_SHIPMENT_REQUEST_DRAFTING") ⇒ SSP.SSP0015_SAVE_SHIPMENT_REQUEST_DRAFTING | 엔드포인트 요청 생성 |  |  |  |
| AC-366603b4 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:7080 | try ▸ else of (siMain.ActiveSheetIndex == 0) ▸ if (siMain.ActiveSheetIndex == 1) | ENDPOINT | new FoxDataRequest | ("SSP.SSP0015_SAVE_SHIPMENT_REQUEST_DRAFTING_PACKER") ⇒ SSP.SSP0015_SAVE_SHIPMENT_REQUEST_DRAFTING_PACKER | 엔드포인트 요청 생성 |  |  |  |
| AC-df465c8e | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:7085 | try | DATA_OP | request.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-d8742b93 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:7086 | try | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-e235f3bf | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:7087 | try | DATA_OP | request.Parameters["p_confirm_id"] | p_confirm_id | 행/컬럼 값 대입 |  |  |  |
| AC-33a1a0ef | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:7088 | try | DATA_OP | request.Parameters["p_shipment_qty"] | p_shipment_qty | 행/컬럼 값 대입 |  |  |  |
| AC-b25bdf88 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:7089 | try | DATA_OP | request.Parameters["p_shipment_date"] | p_shipment_date | 행/컬럼 값 대입 |  |  |  |
| AC-7cda1b9d | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:7090 | try | DATA_OP | request.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-a6c7b2ae | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:7091 | try | DATA_OP | request.Parameters["p_new_bod_id"] | p_new_bod_id | 행/컬럼 값 대입 |  |  |  |
| AC-f5cf11ac | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:7092 | try | DATA_OP | request.Parameters["p_new_route_id"] | p_new_route_id | 행/컬럼 값 대입 |  |  |  |
| AC-f700cc1c | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:7093 | try | DATA_OP | request.Parameters["p_new_etd_date"] | p_new_etd_date | 행/컬럼 값 대입 |  |  |  |
| AC-83e63285 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:7094 | try | DATA_OP | request.Parameters["p_new_eta_date"] | p_new_eta_date | 행/컬럼 값 대입 |  |  |  |
| AC-95a0cbf4 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:7095 | try | DATA_OP | request.Parameters["p_new_incoterms"] | p_new_incoterms | 행/컬럼 값 대입 |  |  |  |
| AC-eb96e34e | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:7096 | try | DATA_OP | request.Parameters["p_new_transport_mode"] | p_new_transport_mode | 행/컬럼 값 대입 |  |  |  |
| AC-369dffd8 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:7097 | try | DATA_OP | request.Parameters["p_new_d_contry"] | p_new_d_contry | 행/컬럼 값 대입 |  |  |  |
| AC-dd3c6f07 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:7098 | try | DATA_OP | request.Parameters["p_new_d_port_code"] | p_new_d_port_code | 행/컬럼 값 대입 |  |  |  |
| AC-75e68a65 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:7099 | try | DATA_OP | request.Parameters["p_new_a_country"] | p_new_a_country | 행/컬럼 값 대입 |  |  |  |
| AC-b465a69c | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:7100 | try | DATA_OP | request.Parameters["p_new_a_port_code"] | p_new_a_port_code | 행/컬럼 값 대입 |  |  |  |
| AC-60567a19 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:7101 | try | DATA_OP | request.Parameters["p_new_customer_lt"] | p_new_customer_lt | 행/컬럼 값 대입 |  |  |  |
| AC-fc1d43fb | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:7102 | try | DATA_OP | request.Parameters["p_new_to_country"] | p_new_to_country | 행/컬럼 값 대입 |  |  |  |
| AC-04b8984f | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:7103 | try | DATA_OP | request.Parameters["p_new_to_city"] | p_new_to_city | 행/컬럼 값 대입 |  |  |  |
| AC-e20ef481 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:7104 | try | DATA_OP | request.Parameters["p_edit_main"] | p_edit_main | 행/컬럼 값 대입 |  |  |  |
| AC-2859f948 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:7105 | try | DATA_OP | request.Parameters["p_edit_remark"] | p_edit_remark | 행/컬럼 값 대입 |  |  |  |
| AC-86df900c | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:7106 | try | DATA_OP | request.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-b0bf1707 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:7107 | try | DATA_OP | request.Parameters["p_user_dept_id"] | p_user_dept_id | 행/컬럼 값 대입 |  |  |  |
| AC-4fd2e8f2 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:7108 | try | DATA_OP | request.Parameters["p_electrode_yn"] | p_electrode_yn | 행/컬럼 값 대입 |  |  |  |
| AC-e07e08f2 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:7109 | try | DATA_OP | request.Parameters["p_electrode_type"] | p_electrode_type | 행/컬럼 값 대입 |  |  |  |
| AC-515400da | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:7110 | try | DATA_OP | request.Parameters["p_origin_from_division_id"] | p_origin_from_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-9fbba1c6 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:7111 | try | DATA_OP | request.Parameters["p_origion_to_division_id"] | p_origion_to_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-39be5151 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:7113 | try | DATA_OP | request.Parameters["p_remarks"] | p_remarks | 행/컬럼 값 대입 |  |  |  |
| AC-a907865c | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:7114 | try | DATA_OP | request.Parameters["p_remarks2"] | p_remarks2 | 행/컬럼 값 대입 |  |  |  |
| AC-825980c1 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:7115 | try | DATA_OP | request.Parameters["p_remarks3"] | p_remarks3 | 행/컬럼 값 대입 |  |  |  |
| AC-663a3a64 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:7117 | try | DATA_OP | request.Parameters["p_change_reason_code"] | p_change_reason_code | 행/컬럼 값 대입 |  |  |  |
| AC-5ecf3676 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:7118 | try | DATA_OP | request.Parameters["p_change_reason_detail"] | p_change_reason_datail | 행/컬럼 값 대입 |  |  |  |
| AC-6db68ad8 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:7119 | try | DATA_OP | request.Parameters["p_title"] | p_title | 행/컬럼 값 대입 |  |  |  |
| AC-c72ae931 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:7120 | try | DATA_OP | request.Parameters["p_program_id"] | p_program_id | 행/컬럼 값 대입 |  |  |  |
| AC-65bc71a3 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:7121 | try | DATA_OP | request.Parameters["p_shipto_code"] | p_shipto_code | 행/컬럼 값 대입 |  |  |  |
| AC-5a2d4322 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:7123 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-be8ad976 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:7162 | try ▸ else of (ds.Tables[0].Rows[0][0].ToString() == "S") | MESSAGE | MessageHelper.GMessageBox | ("MSG00284", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-822ca3de | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:7166 | try | RETURN | return bReturn; |  | 처리 중단/반환 |  |  |  |
| AC-87c3e12c | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:7173 | catch ((Exception ex)) | RETURN | return bReturn; |  | 처리 중단/반환 |  |  |  |

## SSP0015_ShipmentPSI.SpdDetail_ActiveSheetChanged

진입점: spdDetail.ActiveSheetChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3cf9e7d9 | spdDetail.ActiveSheetChanged | SSP0015_ShipmentPSI.cs:7986 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") | UI_PROP | layoutControlItem3.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-e00d752b | spdDetail.ActiveSheetChanged | SSP0015_ShipmentPSI.cs:7987 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") | UI_PROP | layoutControlItem4.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-69a5c0bd | spdDetail.ActiveSheetChanged | SSP0015_ShipmentPSI.cs:7988 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") | UI_PROP | layoutControlItem5.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-420c23a4 | spdDetail.ActiveSheetChanged | SSP0015_ShipmentPSI.cs:7989 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") | UI_PROP | layoutControlItem11.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-2d5773c9 | spdDetail.ActiveSheetChanged | SSP0015_ShipmentPSI.cs:7990 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") | UI_PROP | Requestor.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-3d45e58b | spdDetail.ActiveSheetChanged | SSP0015_ShipmentPSI.cs:7991 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") | UI_PROP | layoutControlItem9.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-2752ae86 | spdDetail.ActiveSheetChanged | SSP0015_ShipmentPSI.cs:7992 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") | UI_PROP | layoutControlItem14.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-2fd2f884 | spdDetail.ActiveSheetChanged | SSP0015_ShipmentPSI.cs:7993 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") | UI_PROP | layoutControlItem15.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-3d80777b | spdDetail.ActiveSheetChanged | SSP0015_ShipmentPSI.cs:7994 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") | UI_PROP | layoutControlItem17.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-e7fcccc3 | spdDetail.ActiveSheetChanged | SSP0015_ShipmentPSI.cs:8000 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") ▸ if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSh… | UI_PROP | layoutControlItem3.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-afccdcc8 | spdDetail.ActiveSheetChanged | SSP0015_ShipmentPSI.cs:8001 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") ▸ if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSh… | UI_PROP | layoutControlItem4.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-31414add | spdDetail.ActiveSheetChanged | SSP0015_ShipmentPSI.cs:8002 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") ▸ if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSh… | UI_PROP | layoutControlItem5.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-592faecd | spdDetail.ActiveSheetChanged | SSP0015_ShipmentPSI.cs:8003 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") ▸ if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSh… | UI_PROP | layoutControlItem11.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-8d494906 | spdDetail.ActiveSheetChanged | SSP0015_ShipmentPSI.cs:8004 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") ▸ if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSh… | UI_PROP | Requestor.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-35fc9108 | spdDetail.ActiveSheetChanged | SSP0015_ShipmentPSI.cs:8005 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") ▸ if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSh… | UI_PROP | layoutControlItem9.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-ed37ed9a | spdDetail.ActiveSheetChanged | SSP0015_ShipmentPSI.cs:8006 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") ▸ if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSh… | UI_PROP | layoutControlItem14.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-7b9eadd2 | spdDetail.ActiveSheetChanged | SSP0015_ShipmentPSI.cs:8007 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") ▸ if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSh… | UI_PROP | layoutControlItem15.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-e2b65f2a | spdDetail.ActiveSheetChanged | SSP0015_ShipmentPSI.cs:8008 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") ▸ if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSh… | UI_PROP | layoutControlItem17.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-3dcb9509 | spdDetail.ActiveSheetChanged | SSP0015_ShipmentPSI.cs:8015 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") ▸ else of (((FarPoint.Win.Spread.FpSpread)sender).Act… | UI_PROP | layoutControlItem3.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-fc2d0dc2 | spdDetail.ActiveSheetChanged | SSP0015_ShipmentPSI.cs:8016 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") ▸ else of (((FarPoint.Win.Spread.FpSpread)sender).Act… | UI_PROP | layoutControlItem4.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-30e3dffb | spdDetail.ActiveSheetChanged | SSP0015_ShipmentPSI.cs:8017 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") ▸ else of (((FarPoint.Win.Spread.FpSpread)sender).Act… | UI_PROP | layoutControlItem5.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-759858e3 | spdDetail.ActiveSheetChanged | SSP0015_ShipmentPSI.cs:8018 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") ▸ else of (((FarPoint.Win.Spread.FpSpread)sender).Act… | UI_PROP | layoutControlItem11.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-ad25f26f | spdDetail.ActiveSheetChanged | SSP0015_ShipmentPSI.cs:8019 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") ▸ else of (((FarPoint.Win.Spread.FpSpread)sender).Act… | UI_PROP | Requestor.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-6b0602f5 | spdDetail.ActiveSheetChanged | SSP0015_ShipmentPSI.cs:8020 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") ▸ else of (((FarPoint.Win.Spread.FpSpread)sender).Act… | UI_PROP | layoutControlItem9.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-f53f9664 | spdDetail.ActiveSheetChanged | SSP0015_ShipmentPSI.cs:8021 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") ▸ else of (((FarPoint.Win.Spread.FpSpread)sender).Act… | UI_PROP | layoutControlItem14.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-e869150e | spdDetail.ActiveSheetChanged | SSP0015_ShipmentPSI.cs:8022 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") ▸ else of (((FarPoint.Win.Spread.FpSpread)sender).Act… | UI_PROP | layoutControlItem15.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-119e54c5 | spdDetail.ActiveSheetChanged | SSP0015_ShipmentPSI.cs:8023 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") ▸ else of (((FarPoint.Win.Spread.FpSpread)sender).Act… | UI_PROP | layoutControlItem17.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-c37acefb | spdDetail.ActiveSheetChanged | SSP0015_ShipmentPSI.cs:8027 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") ▸ else of (((FarPoint.Win.Spread.FpSpread)sender).Act… | UI_PROP | layoutControlItem3.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-2d209fe7 | spdDetail.ActiveSheetChanged | SSP0015_ShipmentPSI.cs:8028 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") ▸ else of (((FarPoint.Win.Spread.FpSpread)sender).Act… | UI_PROP | layoutControlItem4.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-ec723c98 | spdDetail.ActiveSheetChanged | SSP0015_ShipmentPSI.cs:8029 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") ▸ else of (((FarPoint.Win.Spread.FpSpread)sender).Act… | UI_PROP | layoutControlItem5.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-6f9905e5 | spdDetail.ActiveSheetChanged | SSP0015_ShipmentPSI.cs:8030 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") ▸ else of (((FarPoint.Win.Spread.FpSpread)sender).Act… | UI_PROP | layoutControlItem11.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-6fed022b | spdDetail.ActiveSheetChanged | SSP0015_ShipmentPSI.cs:8031 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") ▸ else of (((FarPoint.Win.Spread.FpSpread)sender).Act… | UI_PROP | Requestor.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-4d058839 | spdDetail.ActiveSheetChanged | SSP0015_ShipmentPSI.cs:8032 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") ▸ else of (((FarPoint.Win.Spread.FpSpread)sender).Act… | UI_PROP | layoutControlItem9.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-71ef43e0 | spdDetail.ActiveSheetChanged | SSP0015_ShipmentPSI.cs:8033 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") ▸ else of (((FarPoint.Win.Spread.FpSpread)sender).Act… | UI_PROP | layoutControlItem14.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-88084341 | spdDetail.ActiveSheetChanged | SSP0015_ShipmentPSI.cs:8034 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") ▸ else of (((FarPoint.Win.Spread.FpSpread)sender).Act… | UI_PROP | layoutControlItem15.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-50df09d6 | spdDetail.ActiveSheetChanged | SSP0015_ShipmentPSI.cs:8035 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") ▸ else of (((FarPoint.Win.Spread.FpSpread)sender).Act… | UI_PROP | layoutControlItem17.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-69c19090 | spdDetail.ActiveSheetChanged | SSP0015_ShipmentPSI.cs:8039 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") ▸ else of (((FarPoint.Win.Spread.FpSpread)sender).Act… | UI_PROP | layoutControlItem3.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-7527b60c | spdDetail.ActiveSheetChanged | SSP0015_ShipmentPSI.cs:8040 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") ▸ else of (((FarPoint.Win.Spread.FpSpread)sender).Act… | UI_PROP | layoutControlItem4.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-346de3d6 | spdDetail.ActiveSheetChanged | SSP0015_ShipmentPSI.cs:8041 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") ▸ else of (((FarPoint.Win.Spread.FpSpread)sender).Act… | UI_PROP | layoutControlItem5.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-dafda9e0 | spdDetail.ActiveSheetChanged | SSP0015_ShipmentPSI.cs:8042 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") ▸ else of (((FarPoint.Win.Spread.FpSpread)sender).Act… | UI_PROP | layoutControlItem11.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-cdcf7fee | spdDetail.ActiveSheetChanged | SSP0015_ShipmentPSI.cs:8043 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") ▸ else of (((FarPoint.Win.Spread.FpSpread)sender).Act… | UI_PROP | Requestor.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-47f7c1b1 | spdDetail.ActiveSheetChanged | SSP0015_ShipmentPSI.cs:8044 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") ▸ else of (((FarPoint.Win.Spread.FpSpread)sender).Act… | UI_PROP | layoutControlItem9.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-f9d95827 | spdDetail.ActiveSheetChanged | SSP0015_ShipmentPSI.cs:8045 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") ▸ else of (((FarPoint.Win.Spread.FpSpread)sender).Act… | UI_PROP | layoutControlItem14.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-9b5867fd | spdDetail.ActiveSheetChanged | SSP0015_ShipmentPSI.cs:8046 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") ▸ else of (((FarPoint.Win.Spread.FpSpread)sender).Act… | UI_PROP | layoutControlItem15.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-4e188a37 | spdDetail.ActiveSheetChanged | SSP0015_ShipmentPSI.cs:8047 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") ▸ else of (((FarPoint.Win.Spread.FpSpread)sender).Act… | UI_PROP | layoutControlItem17.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-c2c62a14 | spdDetail.ActiveSheetChanged | SSP0015_ShipmentPSI.cs:8052 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") ▸ else of (((FarPoint.Win.Spread.FpSpread)sender).Act… | UI_PROP | layoutControlItem3.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-da09db79 | spdDetail.ActiveSheetChanged | SSP0015_ShipmentPSI.cs:8053 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") ▸ else of (((FarPoint.Win.Spread.FpSpread)sender).Act… | UI_PROP | layoutControlItem4.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-43709936 | spdDetail.ActiveSheetChanged | SSP0015_ShipmentPSI.cs:8054 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") ▸ else of (((FarPoint.Win.Spread.FpSpread)sender).Act… | UI_PROP | layoutControlItem5.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-d6b1c2e0 | spdDetail.ActiveSheetChanged | SSP0015_ShipmentPSI.cs:8055 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") ▸ else of (((FarPoint.Win.Spread.FpSpread)sender).Act… | UI_PROP | layoutControlItem11.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-987d713e | spdDetail.ActiveSheetChanged | SSP0015_ShipmentPSI.cs:8056 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") ▸ else of (((FarPoint.Win.Spread.FpSpread)sender).Act… | UI_PROP | Requestor.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-44f768c9 | spdDetail.ActiveSheetChanged | SSP0015_ShipmentPSI.cs:8057 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") ▸ else of (((FarPoint.Win.Spread.FpSpread)sender).Act… | UI_PROP | layoutControlItem9.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-157ca7fb | spdDetail.ActiveSheetChanged | SSP0015_ShipmentPSI.cs:8058 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") ▸ else of (((FarPoint.Win.Spread.FpSpread)sender).Act… | UI_PROP | layoutControlItem14.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-1909f248 | spdDetail.ActiveSheetChanged | SSP0015_ShipmentPSI.cs:8059 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") ▸ else of (((FarPoint.Win.Spread.FpSpread)sender).Act… | UI_PROP | layoutControlItem15.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-5f4faea4 | spdDetail.ActiveSheetChanged | SSP0015_ShipmentPSI.cs:8060 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") ▸ else of (((FarPoint.Win.Spread.FpSpread)sender).Act… | UI_PROP | layoutControlItem17.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-55dfcecb | spdDetail.ActiveSheetChanged | SSP0015_ShipmentPSI.cs:8064 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") ▸ else of (((FarPoint.Win.Spread.FpSpread)sender).Act… | UI_PROP | layoutControlItem3.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-72ab772d | spdDetail.ActiveSheetChanged | SSP0015_ShipmentPSI.cs:8065 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") ▸ else of (((FarPoint.Win.Spread.FpSpread)sender).Act… | UI_PROP | layoutControlItem4.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-550d5a03 | spdDetail.ActiveSheetChanged | SSP0015_ShipmentPSI.cs:8066 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") ▸ else of (((FarPoint.Win.Spread.FpSpread)sender).Act… | UI_PROP | layoutControlItem5.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-65357385 | spdDetail.ActiveSheetChanged | SSP0015_ShipmentPSI.cs:8067 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") ▸ else of (((FarPoint.Win.Spread.FpSpread)sender).Act… | UI_PROP | layoutControlItem11.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-2c460871 | spdDetail.ActiveSheetChanged | SSP0015_ShipmentPSI.cs:8068 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") ▸ else of (((FarPoint.Win.Spread.FpSpread)sender).Act… | UI_PROP | Requestor.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-940bd9b9 | spdDetail.ActiveSheetChanged | SSP0015_ShipmentPSI.cs:8069 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") ▸ else of (((FarPoint.Win.Spread.FpSpread)sender).Act… | UI_PROP | layoutControlItem9.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-3b4be1dc | spdDetail.ActiveSheetChanged | SSP0015_ShipmentPSI.cs:8070 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") ▸ else of (((FarPoint.Win.Spread.FpSpread)sender).Act… | UI_PROP | layoutControlItem14.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-236b4a00 | spdDetail.ActiveSheetChanged | SSP0015_ShipmentPSI.cs:8071 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") ▸ else of (((FarPoint.Win.Spread.FpSpread)sender).Act… | UI_PROP | layoutControlItem15.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-a30627d6 | spdDetail.ActiveSheetChanged | SSP0015_ShipmentPSI.cs:8072 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") ▸ else of (((FarPoint.Win.Spread.FpSpread)sender).Act… | UI_PROP | layoutControlItem17.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-1f2546bb | spdDetail.ActiveSheetChanged | SSP0015_ShipmentPSI.cs:8076 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") ▸ else of (((FarPoint.Win.Spread.FpSpread)sender).Act… | UI_PROP | layoutControlItem3.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-b201f83f | spdDetail.ActiveSheetChanged | SSP0015_ShipmentPSI.cs:8077 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") ▸ else of (((FarPoint.Win.Spread.FpSpread)sender).Act… | UI_PROP | layoutControlItem4.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-52d56fa3 | spdDetail.ActiveSheetChanged | SSP0015_ShipmentPSI.cs:8078 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") ▸ else of (((FarPoint.Win.Spread.FpSpread)sender).Act… | UI_PROP | layoutControlItem5.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-41ef4a95 | spdDetail.ActiveSheetChanged | SSP0015_ShipmentPSI.cs:8079 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") ▸ else of (((FarPoint.Win.Spread.FpSpread)sender).Act… | UI_PROP | layoutControlItem11.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-857411f6 | spdDetail.ActiveSheetChanged | SSP0015_ShipmentPSI.cs:8080 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") ▸ else of (((FarPoint.Win.Spread.FpSpread)sender).Act… | UI_PROP | Requestor.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-93f73097 | spdDetail.ActiveSheetChanged | SSP0015_ShipmentPSI.cs:8081 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") ▸ else of (((FarPoint.Win.Spread.FpSpread)sender).Act… | UI_PROP | layoutControlItem9.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-0884e271 | spdDetail.ActiveSheetChanged | SSP0015_ShipmentPSI.cs:8082 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") ▸ else of (((FarPoint.Win.Spread.FpSpread)sender).Act… | UI_PROP | layoutControlItem14.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-ad411585 | spdDetail.ActiveSheetChanged | SSP0015_ShipmentPSI.cs:8083 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") ▸ else of (((FarPoint.Win.Spread.FpSpread)sender).Act… | UI_PROP | layoutControlItem15.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-ebf22f76 | spdDetail.ActiveSheetChanged | SSP0015_ShipmentPSI.cs:8084 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") ▸ else of (((FarPoint.Win.Spread.FpSpread)sender).Act… | UI_PROP | layoutControlItem17.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-6fa1e480 | spdDetail.ActiveSheetChanged | SSP0015_ShipmentPSI.cs:8088 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") ▸ else of (((FarPoint.Win.Spread.FpSpread)sender).Act… | UI_PROP | layoutControlItem3.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-c8190b4f | spdDetail.ActiveSheetChanged | SSP0015_ShipmentPSI.cs:8089 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") ▸ else of (((FarPoint.Win.Spread.FpSpread)sender).Act… | UI_PROP | layoutControlItem4.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-0e6e3f86 | spdDetail.ActiveSheetChanged | SSP0015_ShipmentPSI.cs:8090 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") ▸ else of (((FarPoint.Win.Spread.FpSpread)sender).Act… | UI_PROP | layoutControlItem5.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-32f91e42 | spdDetail.ActiveSheetChanged | SSP0015_ShipmentPSI.cs:8091 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") ▸ else of (((FarPoint.Win.Spread.FpSpread)sender).Act… | UI_PROP | layoutControlItem11.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-6b0ef535 | spdDetail.ActiveSheetChanged | SSP0015_ShipmentPSI.cs:8092 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") ▸ else of (((FarPoint.Win.Spread.FpSpread)sender).Act… | UI_PROP | Requestor.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-4462fa7b | spdDetail.ActiveSheetChanged | SSP0015_ShipmentPSI.cs:8093 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") ▸ else of (((FarPoint.Win.Spread.FpSpread)sender).Act… | UI_PROP | layoutControlItem9.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-c58fcb3c | spdDetail.ActiveSheetChanged | SSP0015_ShipmentPSI.cs:8094 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") ▸ else of (((FarPoint.Win.Spread.FpSpread)sender).Act… | UI_PROP | layoutControlItem14.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-0b1dd16b | spdDetail.ActiveSheetChanged | SSP0015_ShipmentPSI.cs:8095 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") ▸ else of (((FarPoint.Win.Spread.FpSpread)sender).Act… | UI_PROP | layoutControlItem15.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-2e534eda | spdDetail.ActiveSheetChanged | SSP0015_ShipmentPSI.cs:8096 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Hold stock") ▸ else of (((FarPoint.Win.Spread.FpSpread)sender).Act… | UI_PROP | layoutControlItem17.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |

## SSP0015_ShipmentPSI.SpdDetail_CellClick

진입점: this.spdDetail.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-34eea671 | this.spdDetail.CellClick | SSP0015_ShipmentPSI.cs:8565 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (spdDetail.AutoClipboard == true) | CALL_EXT | im.Put | (new Keystroke(Keys.V, Keys.Control), SpreadActions.ClipboardPasteAsStringSkipHidden) | ⚠ 의미 확인 필요 |  |  |  |
| AC-2b88837d | this.spdDetail.CellClick | SSP0015_ShipmentPSI.cs:8566 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (spdDetail.AutoClipboard == true) | CALL_EXT | im.Put | (new Keystroke(Keys.C, Keys.Control), SpreadActions.ClipboardCopyAsStringSkipHidden) | ⚠ 의미 확인 필요 |  |  |  |
| AC-afda96e1 | this.spdDetail.CellClick | SSP0015_ShipmentPSI.cs:8567 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (spdDetail.AutoClipboard == true) | UI_PROP | spdDetail.AutoClipboard | false | 속성 AutoClipboard 설정 |  |  |  |
| AC-67a01c2d | this.spdDetail.CellClick | SSP0015_ShipmentPSI.cs:8581 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.TRANSPORT_MODE)) … | FLAG | sDivision | siDetail.GetValue(e.Row, siDetail.GetColumnIndex(DefColumns.ORIGIN_FROM_DIVISION_ID)).ToSt… | 화면 필드/플래그 변경 |  |  |  |
| AC-1883a9ac | this.spdDetail.CellClick | SSP0015_ShipmentPSI.cs:8583 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.TRANSPORT_MODE)) | FLAG | dtTransMode | Data.Common(Data.Type.TransMode, false, sDivision, sFromSite, sToSite, sIncoterms) ⇒ biz:CommonData.CommonDataList [code=TransMode] | 화면 필드/플래그 변경 |  |  |  |
| AC-18c80ee3 | this.spdDetail.CellClick | SSP0015_ShipmentPSI.cs:8583 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.TRANSPORT_MODE)) | COMBO_DATA | Data.Common | (Data.Type.TransMode, false, sDivision, sFromSite, sToSite, sIncoterms) ⇒ biz:CommonData.CommonDataList [code=TransMode] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-29bd4ba0 | this.spdDetail.CellClick | SSP0015_ShipmentPSI.cs:8592 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.TRANSPORT_MODE)) | GRID_SET | siDetail.ActiveSheet.Cells[e.Row, siDetail.GetColumnIndex(DefColumns.TRANSPORT_MODE)].Vert… | CellVerticalAlignment.Center | 그리드 속성/값 설정 |  |  |  |
| AC-73477787 | this.spdDetail.CellClick | SSP0015_ShipmentPSI.cs:8593 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.TRANSPORT_MODE)) | GRID_SET | siDetail.ActiveSheet.Cells[e.Row, siDetail.GetColumnIndex(DefColumns.TRANSPORT_MODE)].Hori… | CellHorizontalAlignment.Center | 그리드 속성/값 설정 |  |  |  |
| AC-b64a0ff8 | this.spdDetail.CellClick | SSP0015_ShipmentPSI.cs:8604 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.TO_SITE_SHIPTO_CO… | FLAG | dtShipToCode | Data.Common(Data.Type.ShipToCodeByDivision, false, sDivision, sToSite, "", "", "") ⇒ biz:CommonData.CommonDataList [code=ShipToCodeByDivision] | 화면 필드/플래그 변경 |  |  |  |
| AC-766426a7 | this.spdDetail.CellClick | SSP0015_ShipmentPSI.cs:8604 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.TO_SITE_SHIPTO_CO… | COMBO_DATA | Data.Common | (Data.Type.ShipToCodeByDivision, false, sDivision, sToSite, "", "", "") ⇒ biz:CommonData.CommonDataList [code=ShipToCodeByDivision] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-e5b2dcb3 | this.spdDetail.CellClick | SSP0015_ShipmentPSI.cs:8606 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.TO_SITE_SHIPTO_CO… | GRID_COMBO | siDetail.SetCellTypeCombo | (e.Row, siDetail.GetColumnIndex(DefColumns.TO_SITE_SHIPTO_CODE), dtShipToCode) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-bbc7e6ad | this.spdDetail.CellClick | SSP0015_ShipmentPSI.cs:8608 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.TO_SITE_SHIPTO_CO… | GRID_SET | siDetail.ActiveSheet.Cells[e.Row, siDetail.GetColumnIndex(DefColumns.TO_SITE_SHIPTO_CODE)]… | CellVerticalAlignment.Center | 그리드 속성/값 설정 |  |  |  |
| AC-df335dc8 | this.spdDetail.CellClick | SSP0015_ShipmentPSI.cs:8609 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.TO_SITE_SHIPTO_CO… | GRID_SET | siDetail.ActiveSheet.Cells[e.Row, siDetail.GetColumnIndex(DefColumns.TO_SITE_SHIPTO_CODE)]… | CellHorizontalAlignment.Center | 그리드 속성/값 설정 |  |  |  |
| AC-585322d2 | this.spdDetail.CellClick | SSP0015_ShipmentPSI.cs:8618 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.RowCount >= 1 && e.ColumnHeader) ▸ if (siDe… | GRID_SET | siDetail.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].Value | false | 그리드 속성/값 설정 |  |  |  |
| AC-3bac4117 | this.spdDetail.CellClick | SSP0015_ShipmentPSI.cs:8622 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.RowCount >= 1 && e.ColumnHeader) ▸ if (siDe… | GRID_SET | siDetail.ActiveSheet.SetValue | (iRow, e.Column, false) | 그리드 값 설정 |  |  |  |
| AC-8692014d | this.spdDetail.CellClick | SSP0015_ShipmentPSI.cs:8635 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.ActiveColumnIndex == siDetail.GetColumnInde… | UI_PROP | spdDetail.AutoClipboard | true | 속성 AutoClipboard 설정 |  |  |  |
| AC-fa64664e | this.spdDetail.CellClick | SSP0015_ShipmentPSI.cs:8636 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.ActiveColumnIndex == siDetail.GetColumnInde… | FLAG | im | spdDetail.GetInputMap(FarPoint.Win.Spread.InputMapMode.WhenAncestorOfFocused) | 화면 필드/플래그 변경 |  |  |  |
| AC-2ab72abf | this.spdDetail.CellClick | SSP0015_ShipmentPSI.cs:8636 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.ActiveColumnIndex == siDetail.GetColumnInde… | CALL_EXT | spdDetail.GetInputMap | (FarPoint.Win.Spread.InputMapMode.WhenAncestorOfFocused) | ⚠ 의미 확인 필요 |  |  |  |
| AC-8959dff4 | this.spdDetail.CellClick | SSP0015_ShipmentPSI.cs:8637 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.ActiveColumnIndex == siDetail.GetColumnInde… | CALL_EXT | im.Put | (new Keystroke(Keys.V, Keys.Control), SpreadActions.None) | ⚠ 의미 확인 필요 |  |  |  |
| AC-845e3ebd | this.spdDetail.CellClick | SSP0015_ShipmentPSI.cs:8638 | if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.ActiveColumnIndex == siDetail.GetColumnInde… | CALL_EXT | im.Put | (new Keystroke(Keys.C, Keys.Control), SpreadActions.None) | ⚠ 의미 확인 필요 |  |  |  |
| AC-762d36df | this.spdDetail.CellClick | SSP0015_ShipmentPSI.cs:8653 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.RowCount >= 1 && e.ColumnHeader) ▸ if … | GRID_SET | siDetail.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].Value | false | 그리드 속성/값 설정 |  |  |  |
| AC-cd185b53 | this.spdDetail.CellClick | SSP0015_ShipmentPSI.cs:8657 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.RowCount >= 1 && e.ColumnHeader) ▸ if … | GRID_SET | siDetail.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].Value | true | 그리드 속성/값 설정 |  |  |  |
| AC-9ddb9af3 | this.spdDetail.CellClick | SSP0015_ShipmentPSI.cs:8664 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.RowCount >= 1 && e.ColumnHeader) ▸ if … | GRID_SET | siDetail.ActiveSheet.SetValue | (iRow, e.Column, true) | 그리드 값 설정 |  |  |  |
| AC-48b0deba | this.spdDetail.CellClick | SSP0015_ShipmentPSI.cs:8668 | else of (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.RowCount >= 1 && e.ColumnHeader) ▸ if … | GRID_SET | siDetail.ActiveSheet.SetValue | (iRow, e.Column, false) | 그리드 값 설정 |  |  |  |
| AC-e11e9f5e | this.spdDetail.CellClick | SSP0015_ShipmentPSI.cs:8679 | if (e.Column == siDetail.GetColumnIndex(DefColumns.CHANGE_REQ_NO)) ▸ if (string.IsNullOrWhiteSpace(sRequestNo)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0a36404e | this.spdDetail.CellClick | SSP0015_ShipmentPSI.cs:8681 | if (e.Column == siDetail.GetColumnIndex(DefColumns.CHANGE_REQ_NO)) | POPUP | new SCM0002_ShipmentPlanRequestPopup | () | 팝업/폼 생성 |  |  |  |
| AC-dda01b97 | this.spdDetail.CellClick | SSP0015_ShipmentPSI.cs:8682 | if (e.Column == siDetail.GetColumnIndex(DefColumns.CHANGE_REQ_NO)) | UI_PROP | pop.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-134a958b | this.spdDetail.CellClick | SSP0015_ShipmentPSI.cs:8683 | if (e.Column == siDetail.GetColumnIndex(DefColumns.CHANGE_REQ_NO)) | UI_PROP | pop._sRequestNo | sRequestNo | 속성 _sRequestNo 설정 |  |  |  |
| AC-5a06e5b0 | this.spdDetail.CellClick | SSP0015_ShipmentPSI.cs:8684 | if (e.Column == siDetail.GetColumnIndex(DefColumns.CHANGE_REQ_NO)) | POPUP | pop.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## SSP0015_ShipmentPSI.SpdDetail_CellDoubleClick

진입점: this.spdDetail.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a45c239f | this.spdDetail.CellDoubleClick | SSP0015_ShipmentPSI.cs:1343 | if (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.ERP_SO_NO)) ▸ if (siDetail.Ge… | POPUP | new SSP0300_OrderDetailPopup | () | 팝업/폼 생성 |  |  |  |
| AC-3b4472a2 | this.spdDetail.CellDoubleClick | SSP0015_ShipmentPSI.cs:1345 | if (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.ERP_SO_NO)) ▸ if (siDetail.Ge… | POPUP | pop.Form_Load | (_DivisionID, _ErpSoNo, _ConfirmId, _ItemID, "N") | 팝업 초기화(인자 전달) |  |  |  |
| AC-99317efd | this.spdDetail.CellDoubleClick | SSP0015_ShipmentPSI.cs:1346 | if (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.ERP_SO_NO)) ▸ if (siDetail.Ge… | UI_PROP | pop.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-3a455439 | this.spdDetail.CellDoubleClick | SSP0015_ShipmentPSI.cs:1347 | if (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.ERP_SO_NO)) ▸ if (siDetail.Ge… | POPUP | pop.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## SSP0015_ShipmentPSI.SpdDetail_ClipboardPasted

진입점: spdDetail.ClipboardPasted

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-39d42ed4 | spdDetail.ClipboardPasted | SSP0015_ShipmentPSI.cs:8952 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ for (iRow < e.CellRange.Row … | FLAG | sDivision | siDetail.GetValue(iRow, siDetail.GetColumnIndex(DefColumns.ORIGIN_FROM_DIVISION_ID)).ToStr… | 화면 필드/플래그 변경 |  |  |  |
| AC-b119edb2 | spdDetail.ClipboardPasted | SSP0015_ShipmentPSI.cs:8954 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ for (iRow < e.CellRange.Row … | FLAG | dtTransMode | Data.Common(Data.Type.TransMode, false, sDivision, sFromSite, sToSite, sIncoterms2) ⇒ biz:CommonData.CommonDataList [code=TransMode] | 화면 필드/플래그 변경 |  |  |  |
| AC-15f95696 | spdDetail.ClipboardPasted | SSP0015_ShipmentPSI.cs:8954 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ for (iRow < e.CellRange.Row … | COMBO_DATA | Data.Common | (Data.Type.TransMode, false, sDivision, sFromSite, sToSite, sIncoterms2) ⇒ biz:CommonData.CommonDataList [code=TransMode] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-d2ad75eb | spdDetail.ClipboardPasted | SSP0015_ShipmentPSI.cs:8956 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ for (iRow < e.CellRange.Row … | DATA_OP | dtTransMode.Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-a4040670 | spdDetail.ClipboardPasted | SSP0015_ShipmentPSI.cs:8960 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ for (iRow < e.CellRange.Row … | CALL_EXT | ((FarPoint.Win.Spread.FpSpread)sender).CancelCellEditing | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-2ea22b5e | spdDetail.ClipboardPasted | SSP0015_ShipmentPSI.cs:8962 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ for (iRow < e.CellRange.Row … | GRID_SET | siDetail.SetValue | (iRow, siDetail.GetColumnIndex(CAppSetting.StringAction), "") | 그리드 값 설정 |  |  |  |
| AC-c3e9b8ca | spdDetail.ClipboardPasted | SSP0015_ShipmentPSI.cs:8963 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ for (iRow < e.CellRange.Row … | GRID_SET | siDetail.ActiveSheet.Cells[iRow, siDetail.GetColumnIndex(CAppSetting.StringAction)].BackCo… | Color.White | 그리드 속성/값 설정 |  |  |  |
| AC-ced44f77 | spdDetail.ClipboardPasted | SSP0015_ShipmentPSI.cs:8964 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ for (iRow < e.CellRange.Row … | GRID_SET | siDetail.ActiveSheet.Cells[iRow, siDetail.GetColumnIndex(DefColumns.SHIPMENT_CONFIRM_QTY)]… | Color.Black | 그리드 속성/값 설정 |  |  |  |
| AC-e7052e64 | spdDetail.ClipboardPasted | SSP0015_ShipmentPSI.cs:8965 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ for (iRow < e.CellRange.Row … | GRID_SET | siDetail.ActiveSheet.Cells[iRow, siDetail.GetColumnIndex(DefColumns.SHIPMENT_DATE)].ForeCo… | Color.Black | 그리드 속성/값 설정 |  |  |  |
| AC-8302bb5d | spdDetail.ClipboardPasted | SSP0015_ShipmentPSI.cs:8971 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ for (iRow < e.CellRange.Row … | MESSAGE | MessageHelper.GMessageBox | ("MSG00047", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-bfe9d8e5 | spdDetail.ClipboardPasted | SSP0015_ShipmentPSI.cs:8972 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ for (iRow < e.CellRange.Row … | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1b2b98f9 | spdDetail.ClipboardPasted | SSP0015_ShipmentPSI.cs:9009 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ for (iRow < e.CellRange.Row … | GRID_SET | siDetail.SetValue | (iRow, siDetail.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-1b1e3ffa | spdDetail.ClipboardPasted | SSP0015_ShipmentPSI.cs:9033 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ for (iRow < e.CellRange.Row … | GRID_SET | siDetail.SetValue | (i, siDetail.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-35acce8e | spdDetail.ClipboardPasted | SSP0015_ShipmentPSI.cs:9051 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ for (iRow < e.CellRange.Row … | GRID_SET | siDetail.SetValue | (iRow, siDetail.GetColumnIndex(CAppSetting.StringAction), "") | 그리드 값 설정 |  |  |  |
| AC-9e551400 | spdDetail.ClipboardPasted | SSP0015_ShipmentPSI.cs:9052 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ for (iRow < e.CellRange.Row … | GRID_STYLE | siDetail.ActiveSheet.Cells[iRow, siDetail.GetColumnIndex(CAppSetting.StringAction)].ResetF… | () | 그리드 표시 설정 |  |  |  |
| AC-fe6d08c1 | spdDetail.ClipboardPasted | SSP0015_ShipmentPSI.cs:9053 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ for (iRow < e.CellRange.Row … | GRID_STYLE | siDetail.ActiveSheet.Cells[iRow, siDetail.GetColumnIndex(CAppSetting.StringAction)].ResetB… | () | 그리드 표시 설정 |  |  |  |
| AC-5dc0439e | spdDetail.ClipboardPasted | SSP0015_ShipmentPSI.cs:9056 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ for (iRow < e.CellRange.Row … | GRID_SET | siDetail.ActiveSheet.Cells[iRow, siDetail.GetColumnIndex(DefColumns.SHIPMENT_DATE)].ForeCo… | ControlColor.DefaultForeColor | 그리드 속성/값 설정 |  |  |  |
| AC-367e75fe | spdDetail.ClipboardPasted | SSP0015_ShipmentPSI.cs:9072 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ for (iRow < e.CellRange.Row … | GRID_SET | siDetail.SetValue | (iRow, siDetail.GetColumnIndex(DefColumns.SHIPMENT_DATE), sDate) | 그리드 값 설정 |  |  |  |
| AC-5bdaa785 | spdDetail.ClipboardPasted | SSP0015_ShipmentPSI.cs:9073 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ for (iRow < e.CellRange.Row … | GRID_SET | siDetail.SetValue | (iRow, siDetail.GetColumnIndex(DefColumns.NEW_ETD), sDate) | 그리드 값 설정 |  |  |  |
| AC-9348be77 | spdDetail.ClipboardPasted | SSP0015_ShipmentPSI.cs:9074 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ for (iRow < e.CellRange.Row … | GRID_SET | siDetail.SetValue | (iRow, siDetail.GetColumnIndex(DefColumns.NEW_ETA), sEta) | 그리드 값 설정 |  |  |  |
| AC-5c3eb552 | spdDetail.ClipboardPasted | SSP0015_ShipmentPSI.cs:9075 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ for (iRow < e.CellRange.Row … | GRID_SET | siDetail.SetValue | (iRow, siDetail.GetColumnIndex(DefColumns.NEW_SHIPMENT_DATE), sDate) | 그리드 값 설정 |  |  |  |
| AC-cde82db7 | spdDetail.ClipboardPasted | SSP0015_ShipmentPSI.cs:9076 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ for (iRow < e.CellRange.Row … | GRID_SET | siDetail.SetValue | (iRow, siDetail.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-b478777a | spdDetail.ClipboardPasted | SSP0015_ShipmentPSI.cs:9086 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ for (iRow < e.CellRange.Row … | GRID_SET | siDetail.SetValue | (i, siDetail.GetColumnIndex(DefColumns.SHIPMENT_DATE), sDate) | 그리드 값 설정 |  |  |  |
| AC-b7e14ca9 | spdDetail.ClipboardPasted | SSP0015_ShipmentPSI.cs:9088 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ for (iRow < e.CellRange.Row … | GRID_SET | siDetail.SetValue | (i, siDetail.GetColumnIndex(DefColumns.NEW_ETD), sDate) | 그리드 값 설정 |  |  |  |
| AC-5e90655a | spdDetail.ClipboardPasted | SSP0015_ShipmentPSI.cs:9089 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ for (iRow < e.CellRange.Row … | GRID_SET | siDetail.SetValue | (i, siDetail.GetColumnIndex(DefColumns.NEW_ETA), sEta) | 그리드 값 설정 |  |  |  |
| AC-01aac2c6 | spdDetail.ClipboardPasted | SSP0015_ShipmentPSI.cs:9090 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ for (iRow < e.CellRange.Row … | GRID_SET | siDetail.SetValue | (i, siDetail.GetColumnIndex(DefColumns.NEW_SHIPMENT_DATE), sDate) | 그리드 값 설정 |  |  |  |
| AC-bf86c3ff | spdDetail.ClipboardPasted | SSP0015_ShipmentPSI.cs:9091 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ for (iRow < e.CellRange.Row … | GRID_SET | siDetail.SetValue | (i, siDetail.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-d0978398 | spdDetail.ClipboardPasted | SSP0015_ShipmentPSI.cs:9099 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ for (iRow < e.CellRange.Row … | GRID_SET | siDetail.SetValue | (iRow, siDetail.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-639cadb3 | spdDetail.ClipboardPasted | SSP0015_ShipmentPSI.cs:9106 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ for (iRow < e.CellRange.Row … | GRID_SET | siDetail.SetValue | (iRow, siDetail.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-ffc96135 | spdDetail.ClipboardPasted | SSP0015_ShipmentPSI.cs:9114 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ for (iRow < e.CellRange.Row … | DATA_OP | dtChangeReasonCode.Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-61167b63 | spdDetail.ClipboardPasted | SSP0015_ShipmentPSI.cs:9118 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ for (iRow < e.CellRange.Row … | CALL_EXT | ((FarPoint.Win.Spread.FpSpread)sender).CancelCellEditing | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-bf4cb079 | spdDetail.ClipboardPasted | SSP0015_ShipmentPSI.cs:9122 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ for (iRow < e.CellRange.Row … | MESSAGE | MessageHelper.GMessageBox | ("MSG00047", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-98120827 | spdDetail.ClipboardPasted | SSP0015_ShipmentPSI.cs:9123 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ for (iRow < e.CellRange.Row … | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4ce5c51a | spdDetail.ClipboardPasted | SSP0015_ShipmentPSI.cs:9129 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ for (iRow < e.CellRange.Row … | GRID_SET | siDetail.ActiveSheet.Cells[iRow, siDetail.GetColumnIndex(DefColumns.CHANGE_REASON_CODE)].F… | ControlColor.MarkedForeColor | 그리드 속성/값 설정 |  |  |  |
| AC-be311bb8 | spdDetail.ClipboardPasted | SSP0015_ShipmentPSI.cs:9133 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ for (iRow < e.CellRange.Row … | GRID_SET | siDetail.SetValue | (iRow, siDetail.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-225fadb3 | spdDetail.ClipboardPasted | SSP0015_ShipmentPSI.cs:9144 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ for (iRow < e.CellRange.Row … | GRID_SET | siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(DefColumns.CHANGE_REASON_CODE)].Fore… | ControlColor.MarkedForeColor | 그리드 속성/값 설정 |  |  |  |
| AC-f0773561 | spdDetail.ClipboardPasted | SSP0015_ShipmentPSI.cs:9146 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ for (iRow < e.CellRange.Row … | GRID_SET | siDetail.SetValue | (i, siDetail.GetColumnIndex(DefColumns.CHANGE_REASON_CODE), sNewChangeReasonCode) | 그리드 값 설정 |  |  |  |
| AC-a7071078 | spdDetail.ClipboardPasted | SSP0015_ShipmentPSI.cs:9147 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ for (iRow < e.CellRange.Row … | GRID_SET | siDetail.SetValue | (i, siDetail.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-0c976496 | spdDetail.ClipboardPasted | SSP0015_ShipmentPSI.cs:9161 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ for (iRow < e.CellRange.Row … | GRID_SET | siDetail.SetValue | (iRow, siDetail.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-fa6bee8a | spdDetail.ClipboardPasted | SSP0015_ShipmentPSI.cs:9172 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ for (iRow < e.CellRange.Row … | GRID_SET | siDetail.SetValue | (i, siDetail.GetColumnIndex(DefColumns.CHANGE_REASON_DETAIL), sNewChangeReasonDetail) | 그리드 값 설정 |  |  |  |
| AC-f2a74ede | spdDetail.ClipboardPasted | SSP0015_ShipmentPSI.cs:9174 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ for (iRow < e.CellRange.Row … | GRID_SET | siDetail.SetValue | (i, siDetail.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |

## SSP0015_ShipmentPSI.spdDetail_ComboSelChange

진입점: this.spdDetail.ComboSelChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f813c202 | this.spdDetail.ComboSelChange | SSP0015_ShipmentPSI.cs:8694 | if (e.Column == siDetail.GetColumnIndex(DefColumns.TRANSPORT_MODE)) ▸ if (string.IsNullOrWhiteSpace(siDetail.GetValue(e.Row, siDetail.GetCol… | MESSAGE | MessageHelper.GMessageBox | ("MSG00278") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-7cc09cd3 | this.spdDetail.ComboSelChange | SSP0015_ShipmentPSI.cs:8695 | if (e.Column == siDetail.GetColumnIndex(DefColumns.TRANSPORT_MODE)) ▸ if (string.IsNullOrWhiteSpace(siDetail.GetValue(e.Row, siDetail.GetCol… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-63723cc2 | this.spdDetail.ComboSelChange | SSP0015_ShipmentPSI.cs:8739 | if (e.Column == siDetail.GetColumnIndex(DefColumns.TRANSPORT_MODE)) ▸ if (string.IsNullOrWhiteSpace(sSoNo)) | GRID_SET | siDetail.SetValue | (e.Row, siDetail.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-0857d0f5 | this.spdDetail.ComboSelChange | SSP0015_ShipmentPSI.cs:8764 | if (e.Column == siDetail.GetColumnIndex(DefColumns.TRANSPORT_MODE)) ▸ else of (string.IsNullOrWhiteSpace(sSoNo)) ▸ for (iRow < siDetail.Acti… | GRID_SET | siDetail.SetValue | (iRow, siDetail.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-91d1da32 | this.spdDetail.ComboSelChange | SSP0015_ShipmentPSI.cs:8787 | else of (e.Column == siDetail.GetColumnIndex(DefColumns.TRANSPORT_MODE)) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.CHANGE_REASON_… | GRID_SET | siDetail.SetValue | (e.Row, siDetail.GetColumnIndex(DefColumns.EDIT_MAIN), "N") | 그리드 값 설정 |  |  |  |
| AC-ea48bb7e | this.spdDetail.ComboSelChange | SSP0015_ShipmentPSI.cs:8788 | else of (e.Column == siDetail.GetColumnIndex(DefColumns.TRANSPORT_MODE)) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.CHANGE_REASON_… | GRID_SET | siDetail.SetValue | (e.Row, siDetail.GetColumnIndex(DefColumns.CHANGE_REASON_DETAIL), "") | 그리드 값 설정 |  |  |  |
| AC-889de11c | this.spdDetail.ComboSelChange | SSP0015_ShipmentPSI.cs:8793 | else of (e.Column == siDetail.GetColumnIndex(DefColumns.TRANSPORT_MODE)) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.CHANGE_REASON_… | GRID_SET | siDetail.SetValue | (e.Row, siDetail.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-c6b6ac03 | this.spdDetail.ComboSelChange | SSP0015_ShipmentPSI.cs:8807 | else of (e.Column == siDetail.GetColumnIndex(DefColumns.TRANSPORT_MODE)) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.CHANGE_REASON_… | GRID_SET | siDetail.SetValue | (iRow, siDetail.GetColumnIndex(DefColumns.CHANGE_REASON_CODE), sNewChangeReasonCode) | 그리드 값 설정 |  |  |  |
| AC-4dac7b46 | this.spdDetail.ComboSelChange | SSP0015_ShipmentPSI.cs:8808 | else of (e.Column == siDetail.GetColumnIndex(DefColumns.TRANSPORT_MODE)) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.CHANGE_REASON_… | GRID_SET | siDetail.SetValue | (iRow, siDetail.GetColumnIndex(DefColumns.CHANGE_REASON_DETAIL), "") | 그리드 값 설정 |  |  |  |
| AC-461c1890 | this.spdDetail.ComboSelChange | SSP0015_ShipmentPSI.cs:8809 | else of (e.Column == siDetail.GetColumnIndex(DefColumns.TRANSPORT_MODE)) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.CHANGE_REASON_… | GRID_SET | siDetail.SetValue | (iRow, siDetail.GetColumnIndex(DefColumns.EDIT_MAIN), "N") | 그리드 값 설정 |  |  |  |
| AC-ec0d07fb | this.spdDetail.ComboSelChange | SSP0015_ShipmentPSI.cs:8814 | else of (e.Column == siDetail.GetColumnIndex(DefColumns.TRANSPORT_MODE)) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.CHANGE_REASON_… | GRID_SET | siDetail.SetValue | (iRow, siDetail.GetColumnIndex(DefColumns.CHANGE_REASON_CODE), sNewChangeReasonCode) | 그리드 값 설정 |  |  |  |
| AC-7bd38092 | this.spdDetail.ComboSelChange | SSP0015_ShipmentPSI.cs:8815 | else of (e.Column == siDetail.GetColumnIndex(DefColumns.TRANSPORT_MODE)) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.CHANGE_REASON_… | GRID_SET | siDetail.SetValue | (iRow, siDetail.GetColumnIndex(DefColumns.CHANGE_REASON_DETAIL), sNewChangeReasonDetail) | 그리드 값 설정 |  |  |  |
| AC-cea98508 | this.spdDetail.ComboSelChange | SSP0015_ShipmentPSI.cs:8816 | else of (e.Column == siDetail.GetColumnIndex(DefColumns.TRANSPORT_MODE)) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.CHANGE_REASON_… | GRID_SET | siDetail.SetValue | (iRow, siDetail.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |

## SSP0015_ShipmentPSI.SpdDetail_EditChange

진입점: spdDetail.EditChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d8f136f7 | spdDetail.EditChange | SSP0015_ShipmentPSI.cs:8861 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ if (e.Column == siDetail.Get… | GRID_SET | siDetail.SetValue | (e.Row, siDetail.GetColumnIndex(DefColumns.NEW_SHIPMENT_DATE), sDate) | 그리드 값 설정 |  |  |  |
| AC-b7b941da | spdDetail.EditChange | SSP0015_ShipmentPSI.cs:8862 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ if (e.Column == siDetail.Get… | GRID_SET | siDetail.SetValue | (e.Row, siDetail.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-9d990051 | spdDetail.EditChange | SSP0015_ShipmentPSI.cs:8872 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ if (e.Column == siDetail.Get… | GRID_SET | siDetail.SetValue | (i, siDetail.GetColumnIndex(DefColumns.SHIPMENT_DATE), sDate) | 그리드 값 설정 |  |  |  |
| AC-2670d81d | spdDetail.EditChange | SSP0015_ShipmentPSI.cs:8877 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ if (e.Column == siDetail.Get… | GRID_SET | siDetail.SetValue | (i, siDetail.GetColumnIndex(DefColumns.NEW_SHIPMENT_DATE), sDate) | 그리드 값 설정 |  |  |  |
| AC-582e298a | spdDetail.EditChange | SSP0015_ShipmentPSI.cs:8878 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ if (e.Column == siDetail.Get… | GRID_SET | siDetail.SetValue | (i, siDetail.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-acc0bdbb | spdDetail.EditChange | SSP0015_ShipmentPSI.cs:8894 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ else of (e.Column == siDetai… | GRID_STYLE | siDetail.ActiveSheet.SetActiveCell | (e.Row, siDetail.GetColumnIndex(DefColumns.ERP_SO_NO)) | 그리드 표시 설정 |  |  |  |
| AC-8cc31313 | spdDetail.EditChange | SSP0015_ShipmentPSI.cs:8895 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ else of (e.Column == siDetai… | CALL_EXT | siDetail.ActiveSheet.Cells[e.Row, siDetail.GetColumnIndex(DefColumns.CHANGE_REASON_DETAIL)… | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-e6b7c74e | spdDetail.EditChange | SSP0015_ShipmentPSI.cs:8897 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ else of (e.Column == siDetai… | MESSAGE | MessageHelper.GMessageBox | ("MSG00287", new object[] { null }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-75741ac4 | spdDetail.EditChange | SSP0015_ShipmentPSI.cs:8899 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ else of (e.Column == siDetai… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a0d57d6f | spdDetail.EditChange | SSP0015_ShipmentPSI.cs:8907 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ else of (e.Column == siDetai… | GRID_SET | siDetail.SetValue | (e.Row, siDetail.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |
| AC-2614252f | spdDetail.EditChange | SSP0015_ShipmentPSI.cs:8917 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ else of (e.Column == siDetai… | GRID_SET | siDetail.SetValue | (i, siDetail.GetColumnIndex(DefColumns.CHANGE_REASON_DETAIL), sNewChangeReasonDetail) | 그리드 값 설정 |  |  |  |
| AC-bb94c05b | spdDetail.EditChange | SSP0015_ShipmentPSI.cs:8919 | if (siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ else of (e.Column == siDetai… | GRID_SET | siDetail.SetValue | (i, siDetail.GetColumnIndex(DefColumns.EDIT_MAIN), "Y") | 그리드 값 설정 |  |  |  |

## SSP0015_ShipmentPSI.SpdDetail_SheetTabClick

진입점: this.spdDetail.SheetTabClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fb644be3 | this.spdDetail.SheetTabClick | SSP0015_ShipmentPSI.cs:1603 | if (e.SheetTabIndex == 0) | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtDetail) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2d615ab6 | this.spdDetail.SheetTabClick | SSP0015_ShipmentPSI.cs:1604 | if (e.SheetTabIndex == 0) | GRID_INIT | siDetail.ChangeActiveSheet | (SpdSheet.shtDetail) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-2de5543c | this.spdDetail.SheetTabClick | SSP0015_ShipmentPSI.cs:1608 | else of (e.SheetTabIndex == 0) ▸ if (e.SheetTabIndex == 1) | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtRequestDetail) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4dc7bcf0 | this.spdDetail.SheetTabClick | SSP0015_ShipmentPSI.cs:1609 | else of (e.SheetTabIndex == 0) ▸ if (e.SheetTabIndex == 1) | GRID_INIT | siDetail.ChangeActiveSheet | (SpdSheet.shtRequestDetail) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-ce6e8fb9 | this.spdDetail.SheetTabClick | SSP0015_ShipmentPSI.cs:1613 | else of (e.SheetTabIndex == 0) ▸ else of (e.SheetTabIndex == 1) ▸ if (e.SheetTabIndex == 2) | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtWHstock) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-012c7d5c | this.spdDetail.SheetTabClick | SSP0015_ShipmentPSI.cs:1614 | else of (e.SheetTabIndex == 0) ▸ else of (e.SheetTabIndex == 1) ▸ if (e.SheetTabIndex == 2) | GRID_INIT | siDetail.ChangeActiveSheet | (SpdSheet.shtWHstock) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-07afab5c | this.spdDetail.SheetTabClick | SSP0015_ShipmentPSI.cs:1618 | else of (e.SheetTabIndex == 0) ▸ else of (e.SheetTabIndex == 1) ▸ else of (e.SheetTabIndex == 2) ▸ if (e.SheetTabIndex == 3) | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtWHstockDetail) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ba8da5bf | this.spdDetail.SheetTabClick | SSP0015_ShipmentPSI.cs:1619 | else of (e.SheetTabIndex == 0) ▸ else of (e.SheetTabIndex == 1) ▸ else of (e.SheetTabIndex == 2) ▸ if (e.SheetTabIndex == 3) | GRID_INIT | siDetail.ChangeActiveSheet | (SpdSheet.shtWHstockDetail) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-07b09a1a | this.spdDetail.SheetTabClick | SSP0015_ShipmentPSI.cs:1623 | else of (e.SheetTabIndex == 0) ▸ else of (e.SheetTabIndex == 1) ▸ else of (e.SheetTabIndex == 2) ▸ else of (e.SheetTabIndex == 3) ▸ if (e.Sh… | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtBolckStockDetail) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-29c0364a | this.spdDetail.SheetTabClick | SSP0015_ShipmentPSI.cs:1624 | else of (e.SheetTabIndex == 0) ▸ else of (e.SheetTabIndex == 1) ▸ else of (e.SheetTabIndex == 2) ▸ else of (e.SheetTabIndex == 3) ▸ if (e.Sh… | GRID_INIT | siDetail.ChangeActiveSheet | (SpdSheet.shtBolckStockDetail) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-d07e43c0 | this.spdDetail.SheetTabClick | SSP0015_ShipmentPSI.cs:1628 | else of (e.SheetTabIndex == 0) ▸ else of (e.SheetTabIndex == 1) ▸ else of (e.SheetTabIndex == 2) ▸ else of (e.SheetTabIndex == 3) ▸ else of … | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtMesStock) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ed104ffe | this.spdDetail.SheetTabClick | SSP0015_ShipmentPSI.cs:1629 | else of (e.SheetTabIndex == 0) ▸ else of (e.SheetTabIndex == 1) ▸ else of (e.SheetTabIndex == 2) ▸ else of (e.SheetTabIndex == 3) ▸ else of … | GRID_INIT | siDetail.ChangeActiveSheet | (SpdSheet.shtMesStock) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-03cb6e33 | this.spdDetail.SheetTabClick | SSP0015_ShipmentPSI.cs:1633 | else of (e.SheetTabIndex == 0) ▸ else of (e.SheetTabIndex == 1) ▸ else of (e.SheetTabIndex == 2) ▸ else of (e.SheetTabIndex == 3) ▸ else of … | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtScsStock) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c38ec443 | this.spdDetail.SheetTabClick | SSP0015_ShipmentPSI.cs:1634 | else of (e.SheetTabIndex == 0) ▸ else of (e.SheetTabIndex == 1) ▸ else of (e.SheetTabIndex == 2) ▸ else of (e.SheetTabIndex == 3) ▸ else of … | GRID_INIT | siDetail.ChangeActiveSheet | (SpdSheet.shtScsStock) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-1997a682 | this.spdDetail.SheetTabClick | SSP0015_ShipmentPSI.cs:1639 | else of (e.SheetTabIndex == 0) ▸ else of (e.SheetTabIndex == 1) ▸ else of (e.SheetTabIndex == 2) ▸ else of (e.SheetTabIndex == 3) ▸ else of … | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtStockLocationDetail) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a35bc82b | this.spdDetail.SheetTabClick | SSP0015_ShipmentPSI.cs:1640 | else of (e.SheetTabIndex == 0) ▸ else of (e.SheetTabIndex == 1) ▸ else of (e.SheetTabIndex == 2) ▸ else of (e.SheetTabIndex == 3) ▸ else of … | GRID_INIT | siDetail.ChangeActiveSheet | (SpdSheet.shtStockLocationDetail) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-dd9da918 | this.spdDetail.SheetTabClick | SSP0015_ShipmentPSI.cs:1647 | else of (e.SheetTabIndex == 0) ▸ else of (e.SheetTabIndex == 1) ▸ else of (e.SheetTabIndex == 2) ▸ else of (e.SheetTabIndex == 3) ▸ else of … | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtWHinPlanDetail) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a3c257e2 | this.spdDetail.SheetTabClick | SSP0015_ShipmentPSI.cs:1648 | else of (e.SheetTabIndex == 0) ▸ else of (e.SheetTabIndex == 1) ▸ else of (e.SheetTabIndex == 2) ▸ else of (e.SheetTabIndex == 3) ▸ else of … | GRID_INIT | siDetail.ChangeActiveSheet | (SpdSheet.shtWHinPlanDetail) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-0f7a0a88 | this.spdDetail.SheetTabClick | SSP0015_ShipmentPSI.cs:1652 | else of (e.SheetTabIndex == 0) ▸ else of (e.SheetTabIndex == 1) ▸ else of (e.SheetTabIndex == 2) ▸ else of (e.SheetTabIndex == 3) ▸ else of … | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtShipmentResult) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e0faa576 | this.spdDetail.SheetTabClick | SSP0015_ShipmentPSI.cs:1653 | else of (e.SheetTabIndex == 0) ▸ else of (e.SheetTabIndex == 1) ▸ else of (e.SheetTabIndex == 2) ▸ else of (e.SheetTabIndex == 3) ▸ else of … | GRID_INIT | siDetail.ChangeActiveSheet | (SpdSheet.shtShipmentResult) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-1fbee1ad | this.spdDetail.SheetTabClick | SSP0015_ShipmentPSI.cs:1655 | else of (e.SheetTabIndex == 0) ▸ else of (e.SheetTabIndex == 1) ▸ else of (e.SheetTabIndex == 2) ▸ else of (e.SheetTabIndex == 3) ▸ else of … | CALL_EXT | clbResultType.SetItemChecked | (0, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3a87e8f1 | this.spdDetail.SheetTabClick | SSP0015_ShipmentPSI.cs:1656 | else of (e.SheetTabIndex == 0) ▸ else of (e.SheetTabIndex == 1) ▸ else of (e.SheetTabIndex == 2) ▸ else of (e.SheetTabIndex == 3) ▸ else of … | CALL_EXT | clbResultType.SetItemChecked | (1, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-6344807a | this.spdDetail.SheetTabClick | SSP0015_ShipmentPSI.cs:1661 | else of (e.SheetTabIndex == 0) ▸ else of (e.SheetTabIndex == 1) ▸ else of (e.SheetTabIndex == 2) ▸ else of (e.SheetTabIndex == 3) ▸ else of … | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtShipmentResult) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-dc66cea9 | this.spdDetail.SheetTabClick | SSP0015_ShipmentPSI.cs:1662 | else of (e.SheetTabIndex == 0) ▸ else of (e.SheetTabIndex == 1) ▸ else of (e.SheetTabIndex == 2) ▸ else of (e.SheetTabIndex == 3) ▸ else of … | GRID_INIT | siDetail.ChangeActiveSheet | (SpdSheet.shtShipmentResult) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-36c4f1c9 | this.spdDetail.SheetTabClick | SSP0015_ShipmentPSI.cs:1664 | else of (e.SheetTabIndex == 0) ▸ else of (e.SheetTabIndex == 1) ▸ else of (e.SheetTabIndex == 2) ▸ else of (e.SheetTabIndex == 3) ▸ else of … | CALL_EXT | clbResultType.SetItemChecked | (0, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-840203d8 | this.spdDetail.SheetTabClick | SSP0015_ShipmentPSI.cs:1665 | else of (e.SheetTabIndex == 0) ▸ else of (e.SheetTabIndex == 1) ▸ else of (e.SheetTabIndex == 2) ▸ else of (e.SheetTabIndex == 3) ▸ else of … | CALL_EXT | clbResultType.SetItemChecked | (1, true) | ⚠ 의미 확인 필요 |  |  |  |

## SSP0015_ShipmentPSI.SpdMain_ActiveSheetChanged

진입점: this.spdMain.ActiveSheetChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-500a87cb | this.spdMain.ActiveSheetChanged | SSP0015_ShipmentPSI.cs:1363 |  | FLAG | siDetail | GetSheetInfo(spdDetail.Name, SpdSheet.shtDetail) | 화면 필드/플래그 변경 |  |  |  |
| AC-fa5503ef | this.spdMain.ActiveSheetChanged | SSP0015_ShipmentPSI.cs:1366 |  | FLAG | siDetail | GetSheetInfo(spdDetail.Name, SpdSheet.shtWHstock) | 화면 필드/플래그 변경 |  |  |  |
| AC-79e14de5 | this.spdMain.ActiveSheetChanged | SSP0015_ShipmentPSI.cs:1369 |  | FLAG | siDetail | GetSheetInfo(spdDetail.Name, SpdSheet.shtWHstockDetail) | 화면 필드/플래그 변경 |  |  |  |
| AC-cd9f0084 | this.spdMain.ActiveSheetChanged | SSP0015_ShipmentPSI.cs:1372 |  | FLAG | siDetail | GetSheetInfo(spdDetail.Name, SpdSheet.shtBolckStock) | 화면 필드/플래그 변경 |  |  |  |
| AC-b4846fbb | this.spdMain.ActiveSheetChanged | SSP0015_ShipmentPSI.cs:1375 |  | FLAG | siDetail | GetSheetInfo(spdDetail.Name, SpdSheet.shtBolckStockDetail) | 화면 필드/플래그 변경 |  |  |  |
| AC-b2dac98d | this.spdMain.ActiveSheetChanged | SSP0015_ShipmentPSI.cs:1378 |  | FLAG | siDetail | GetSheetInfo(spdDetail.Name, SpdSheet.shtMesStock) | 화면 필드/플래그 변경 |  |  |  |
| AC-a9761913 | this.spdMain.ActiveSheetChanged | SSP0015_ShipmentPSI.cs:1381 |  | FLAG | siDetail | GetSheetInfo(spdDetail.Name, SpdSheet.shtScsStock) | 화면 필드/플래그 변경 |  |  |  |
| AC-d221cdad | this.spdMain.ActiveSheetChanged | SSP0015_ShipmentPSI.cs:1384 |  | FLAG | siDetail | GetSheetInfo(spdDetail.Name, SpdSheet.shtStockLocationDetail) | 화면 필드/플래그 변경 |  |  |  |
| AC-c99f5c8c | this.spdMain.ActiveSheetChanged | SSP0015_ShipmentPSI.cs:1387 |  | FLAG | siDetail | GetSheetInfo(spdDetail.Name, SpdSheet.shtWHinPlanDetail) | 화면 필드/플래그 변경 |  |  |  |
| AC-12d925dd | this.spdMain.ActiveSheetChanged | SSP0015_ShipmentPSI.cs:1390 |  | FLAG | siDetail | GetSheetInfo(spdDetail.Name, SpdSheet.shtShipmentResult) | 화면 필드/플래그 변경 |  |  |  |
| AC-80f56176 | this.spdMain.ActiveSheetChanged | SSP0015_ShipmentPSI.cs:1396 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment PSI(Mobility & IT)") | FLAG | siMain | GetSheetInfo(spdMain.Name, SpdSheet.shtMain) | 화면 필드/플래그 변경 |  |  |  |
| AC-f86cc5a7 | this.spdMain.ActiveSheetChanged | SSP0015_ShipmentPSI.cs:1400 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment PSI(Mobility & IT)") | FLAG | dtResultType | Data.Common(Data.Type.LookupCommon, false, "SSP_SHIPMENT_RESULT_TYPE") ⇒ biz:CommonData.CommonDataList [code=LookupCommon] | 화면 필드/플래그 변경 |  |  |  |
| AC-2c615a5e | this.spdMain.ActiveSheetChanged | SSP0015_ShipmentPSI.cs:1400 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment PSI(Mobility & IT)") | COMBO_DATA | Data.Common | (Data.Type.LookupCommon, false, "SSP_SHIPMENT_RESULT_TYPE") ⇒ biz:CommonData.CommonDataList [code=LookupCommon] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-3151793c | this.spdMain.ActiveSheetChanged | SSP0015_ShipmentPSI.cs:1402 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment PSI(Mobility & IT)") | DATA_OP | dtResultType.Rows.RemoveAt | (3) | 데이터 객체 조작/조회 |  |  |  |
| AC-4ea0c326 | this.spdMain.ActiveSheetChanged | SSP0015_ShipmentPSI.cs:1404 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment PSI(Mobility & IT)") | LIST_REBIND | clsCtrl.setListBox | (dtResultType, clbResultType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-88dae303 | this.spdMain.ActiveSheetChanged | SSP0015_ShipmentPSI.cs:1406 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment PSI(Mobility & IT)") | FLAG | dtPlantSiteByDivision | Data_SCP.Common(Data_SCP.Type.ShipmentRequestPlantSite, false, pDivisionID, "P", "E") | 화면 필드/플래그 변경 |  |  |  |
| AC-baafab44 | this.spdMain.ActiveSheetChanged | SSP0015_ShipmentPSI.cs:1406 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment PSI(Mobility & IT)") | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.ShipmentRequestPlantSite, false, pDivisionID, "P", "E") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-aba3bac4 | this.spdMain.ActiveSheetChanged | SSP0015_ShipmentPSI.cs:1415 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment PSI(Mobility & IT)") | STATE | sv.Visible | true | 컨트롤 상태 Visible |  |  |  |
| AC-ea66e8ac | this.spdMain.ActiveSheetChanged | SSP0015_ShipmentPSI.cs:1418 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment PSI(Mobility & IT)") | STATE | sv.Visible | true | 컨트롤 상태 Visible |  |  |  |
| AC-a41a8710 | this.spdMain.ActiveSheetChanged | SSP0015_ShipmentPSI.cs:1421 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment PSI(Mobility & IT)") | STATE | sv.Visible | true | 컨트롤 상태 Visible |  |  |  |
| AC-c141f766 | this.spdMain.ActiveSheetChanged | SSP0015_ShipmentPSI.cs:1424 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment PSI(Mobility & IT)") | STATE | sv.Visible | true | 컨트롤 상태 Visible |  |  |  |
| AC-bbc32d4f | this.spdMain.ActiveSheetChanged | SSP0015_ShipmentPSI.cs:1427 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment PSI(Mobility & IT)") | STATE | sv.Visible | true | 컨트롤 상태 Visible |  |  |  |
| AC-95bebbab | this.spdMain.ActiveSheetChanged | SSP0015_ShipmentPSI.cs:1430 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment PSI(Mobility & IT)") | STATE | sv.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-59f6a16c | this.spdMain.ActiveSheetChanged | SSP0015_ShipmentPSI.cs:1434 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment PSI(Mobility & IT)") | STATE | sv.Visible | true | 컨트롤 상태 Visible |  |  |  |
| AC-deba58d9 | this.spdMain.ActiveSheetChanged | SSP0015_ShipmentPSI.cs:1437 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment PSI(Mobility & IT)") | STATE | sv.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-f2304ed9 | this.spdMain.ActiveSheetChanged | SSP0015_ShipmentPSI.cs:1440 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment PSI(Mobility & IT)") | STATE | sv.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-f6b98ca8 | this.spdMain.ActiveSheetChanged | SSP0015_ShipmentPSI.cs:1442 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment PSI(Mobility & IT)") | STATE | drpPeriod.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-24bd6163 | this.spdMain.ActiveSheetChanged | SSP0015_ShipmentPSI.cs:1448 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment PSI(Mobility & IT)") ▸ if (((FarPoint.Win.Spread.FpSpread… | FLAG | siMain | GetSheetInfo(spdMain.Name, SpdSheet.shtPacker) | 화면 필드/플래그 변경 |  |  |  |
| AC-57ab307e | this.spdMain.ActiveSheetChanged | SSP0015_ShipmentPSI.cs:1452 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment PSI(Mobility & IT)") ▸ if (((FarPoint.Win.Spread.FpSpread… | FLAG | dtResultType | Data.Common(Data.Type.LookupCommon, false, "SSP_SHIPMENT_RESULT_TYPE_PACKER") ⇒ biz:CommonData.CommonDataList [code=LookupCommon] | 화면 필드/플래그 변경 |  |  |  |
| AC-30cf31ac | this.spdMain.ActiveSheetChanged | SSP0015_ShipmentPSI.cs:1452 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment PSI(Mobility & IT)") ▸ if (((FarPoint.Win.Spread.FpSpread… | COMBO_DATA | Data.Common | (Data.Type.LookupCommon, false, "SSP_SHIPMENT_RESULT_TYPE_PACKER") ⇒ biz:CommonData.CommonDataList [code=LookupCommon] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-dd2fb576 | this.spdMain.ActiveSheetChanged | SSP0015_ShipmentPSI.cs:1457 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment PSI(Mobility & IT)") ▸ if (((FarPoint.Win.Spread.FpSpread… | LIST_REBIND | clsCtrl.setListBox | (dtResultType, clbResultType, false) | 목록 컨트롤 재구성 |  |  |  |
| AC-05b10ad0 | this.spdMain.ActiveSheetChanged | SSP0015_ShipmentPSI.cs:1459 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment PSI(Mobility & IT)") ▸ if (((FarPoint.Win.Spread.FpSpread… | FLAG | dtPlantSiteByDivision | Data.UserPlantSiteByDivisionOspPack(UserInfoContext.Current["NowGroupID"], UserInfoContext… | 화면 필드/플래그 변경 |  |  |  |
| AC-40f1aff3 | this.spdMain.ActiveSheetChanged | SSP0015_ShipmentPSI.cs:1459 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment PSI(Mobility & IT)") ▸ if (((FarPoint.Win.Spread.FpSpread… | COMBO_DATA | Data.UserPlantSiteByDivisionOspPack | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, pDivisionID) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ccbc8fac | this.spdMain.ActiveSheetChanged | SSP0015_ShipmentPSI.cs:1468 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment PSI(Mobility & IT)") ▸ if (((FarPoint.Win.Spread.FpSpread… | STATE | sv.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-99eff567 | this.spdMain.ActiveSheetChanged | SSP0015_ShipmentPSI.cs:1472 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment PSI(Mobility & IT)") ▸ if (((FarPoint.Win.Spread.FpSpread… | STATE | sv.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-abd4feb7 | this.spdMain.ActiveSheetChanged | SSP0015_ShipmentPSI.cs:1476 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment PSI(Mobility & IT)") ▸ if (((FarPoint.Win.Spread.FpSpread… | STATE | sv.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-1d8de7ef | this.spdMain.ActiveSheetChanged | SSP0015_ShipmentPSI.cs:1480 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment PSI(Mobility & IT)") ▸ if (((FarPoint.Win.Spread.FpSpread… | STATE | sv.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-bdad8826 | this.spdMain.ActiveSheetChanged | SSP0015_ShipmentPSI.cs:1484 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment PSI(Mobility & IT)") ▸ if (((FarPoint.Win.Spread.FpSpread… | STATE | sv.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-9b1211cd | this.spdMain.ActiveSheetChanged | SSP0015_ShipmentPSI.cs:1488 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment PSI(Mobility & IT)") ▸ if (((FarPoint.Win.Spread.FpSpread… | STATE | sv.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-5b147b9d | this.spdMain.ActiveSheetChanged | SSP0015_ShipmentPSI.cs:1492 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment PSI(Mobility & IT)") ▸ if (((FarPoint.Win.Spread.FpSpread… | STATE | sv.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-bb0fcd90 | this.spdMain.ActiveSheetChanged | SSP0015_ShipmentPSI.cs:1496 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment PSI(Mobility & IT)") ▸ if (((FarPoint.Win.Spread.FpSpread… | STATE | sv.Visible | true | 컨트롤 상태 Visible |  |  |  |
| AC-4442da6b | this.spdMain.ActiveSheetChanged | SSP0015_ShipmentPSI.cs:1500 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment PSI(Mobility & IT)") ▸ if (((FarPoint.Win.Spread.FpSpread… | STATE | sv.Visible | true | 컨트롤 상태 Visible |  |  |  |
| AC-6743b112 | this.spdMain.ActiveSheetChanged | SSP0015_ShipmentPSI.cs:1502 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == "Shipment PSI(Mobility & IT)") ▸ if (((FarPoint.Win.Spread.FpSpread… | STATE | drpPeriod.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-b10716a9 | this.spdMain.ActiveSheetChanged | SSP0015_ShipmentPSI.cs:1505 |  | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtDetail) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-05a7a24c | this.spdMain.ActiveSheetChanged | SSP0015_ShipmentPSI.cs:1506 |  | GRID_INIT | siDetail.ChangeActiveSheet | (SpdSheet.shtDetail) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-8cb29ec5 | this.spdMain.ActiveSheetChanged | SSP0015_ShipmentPSI.cs:1508 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlantSiteByDivision, clbPlantSite, true) | 목록 컨트롤 재구성 |  |  |  |

## SSP0015_ShipmentPSI.SpdMain_CellClick

진입점: spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b236b78f | spdMain.CellClick | SSP0015_ShipmentPSI.cs:1200 | if (siMain.ActiveSheet.RowCount > 0) ▸ if (e.Column > siMain.GetColumnIndex(DefColumns.MEASURE) && siMain.GetValue(e.Row, siMain.GetColumnIn… | GRID_STYLE | spdMain.ActiveSheet.SetActiveCell | (e.Row, e.Column) | 그리드 표시 설정 |  |  |  |
| AC-271c5d5b | spdMain.CellClick | SSP0015_ShipmentPSI.cs:1201 | if (siMain.ActiveSheet.RowCount > 0) ▸ if (e.Column > siMain.GetColumnIndex(DefColumns.MEASURE) && siMain.GetValue(e.Row, siMain.GetColumnIn… | UI_PROP | spdMain.ContextMenu | contextMenu | 속성 ContextMenu 설정 |  |  |  |
| AC-5dc47a6d | spdMain.CellClick | SSP0015_ShipmentPSI.cs:1205 | if (siMain.ActiveSheet.RowCount > 0) ▸ else of (e.Column > siMain.GetColumnIndex(DefColumns.MEASURE) && siMain.GetValue(e.Row, siMain.GetCol… | UI_PROP | spdMain.ContextMenu | null | 속성 ContextMenu 설정 |  |  |  |

## SSP0015_ShipmentPSI.SpdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ebe448c1 | this.spdMain.CellDoubleClick | SSP0015_ShipmentPSI.cs:8106 | for (i < spdDetail.Sheets.Count) | FLAG | siDetail | GetSheetInfo(spdDetail.Name, spdDetail.Sheets[i].SheetName) | 화면 필드/플래그 변경 |  |  |  |
| AC-61bc3380 | this.spdMain.CellDoubleClick | SSP0015_ShipmentPSI.cs:8107 | for (i < spdDetail.Sheets.Count) | GRID_INIT | siDetail.ChangeSheet | (spdDetail.Sheets[i].SheetName) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ec954a6e | this.spdMain.CellDoubleClick | SSP0015_ShipmentPSI.cs:8113 | if (e.ColumnHeader) | CALL_EXT | siMain.SetDblClickColumnShowHide | (sender, e) | ⚠ 의미 확인 필요 |  |  |  |
| AC-94eb6dab | this.spdMain.CellDoubleClick | SSP0015_ShipmentPSI.cs:8118 | if (!e.ColumnHeader && e.Row >= 0) | FLAG | nSelRowOfMain | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-34f86deb | this.spdMain.CellDoubleClick | SSP0015_ShipmentPSI.cs:8119 | if (!e.ColumnHeader && e.Row >= 0) | FLAG | nSelColOfMain | e.Column | 화면 필드/플래그 변경 |  |  |  |
| AC-e5a8d5f2 | this.spdMain.CellDoubleClick | SSP0015_ShipmentPSI.cs:8130 | if (siMain.ActiveSheetIndex == 0) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) | FLAG | bDetail_Search | false | 화면 필드/플래그 변경 |  |  |  |
| AC-f9729894 | this.spdMain.CellDoubleClick | SSP0015_ShipmentPSI.cs:8135 | if (siMain.ActiveSheetIndex == 0) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) ▸ if (sMeasure == "SHIP_CONFIRM") | VALUE_CLEAR | txtModel2.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-aa14326e | this.spdMain.CellDoubleClick | SSP0015_ShipmentPSI.cs:8136 | if (siMain.ActiveSheetIndex == 0) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) ▸ if (sMeasure == "SHIP_CONFIRM") | VALUE_CLEAR | drpPeriod2.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-a4847852 | this.spdMain.CellDoubleClick | SSP0015_ShipmentPSI.cs:8137 | if (siMain.ActiveSheetIndex == 0) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) ▸ if (sMeasure == "SHIP_CONFIRM") | FLAG | sDivision | siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.DIVISION_ID)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-a640e4b7 | this.spdMain.CellDoubleClick | SSP0015_ShipmentPSI.cs:8138 | if (siMain.ActiveSheetIndex == 0) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) ▸ if (sMeasure == "SHIP_CONFIRM") | FLAG | sItemID | siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-3acea1cb | this.spdMain.CellDoubleClick | SSP0015_ShipmentPSI.cs:8139 | if (siMain.ActiveSheetIndex == 0) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) ▸ if (sMeasure == "SHIP_CONFIRM") | FLAG | sFromSiteID | siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.FROM_SITE)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-82216ae2 | this.spdMain.CellDoubleClick | SSP0015_ShipmentPSI.cs:8140 | if (siMain.ActiveSheetIndex == 0) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) ▸ if (sMeasure == "SHIP_CONFIRM") | FLAG | sPlanStartYyyymmdd | siMain.GetColumnTag(e.Column).Replace("D_", "") | 화면 필드/플래그 변경 |  |  |  |
| AC-5dcb8639 | this.spdMain.CellDoubleClick | SSP0015_ShipmentPSI.cs:8143 | if (siMain.ActiveSheetIndex == 0) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) ▸ if (sMeasure == "SHIP_CONFIRM") | FLAG | sSrh | "N" | 화면 필드/플래그 변경 |  |  |  |
| AC-c48b08b4 | this.spdMain.CellDoubleClick | SSP0015_ShipmentPSI.cs:8145 | if (siMain.ActiveSheetIndex == 0) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) ▸ if (sMeasure == "SHIP_CONFIRM") | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtDetail) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-faae8a95 | this.spdMain.CellDoubleClick | SSP0015_ShipmentPSI.cs:8146 | if (siMain.ActiveSheetIndex == 0) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) ▸ if (sMeasure == "SHIP_CONFIRM") | GRID_INIT | siDetail.ChangeActiveSheet | (SpdSheet.shtDetail) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-d5c6b06c | this.spdMain.CellDoubleClick | SSP0015_ShipmentPSI.cs:8158 | if (siMain.ActiveSheetIndex == 0) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) ▸ if (sMeasure == "WH_STOCK") | FLAG | sDivision | siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.DIVISION_ID)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-0ea25ec2 | this.spdMain.CellDoubleClick | SSP0015_ShipmentPSI.cs:8159 | if (siMain.ActiveSheetIndex == 0) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) ▸ if (sMeasure == "WH_STOCK") | FLAG | sItemID | siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-9dcebb7a | this.spdMain.CellDoubleClick | SSP0015_ShipmentPSI.cs:8160 | if (siMain.ActiveSheetIndex == 0) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) ▸ if (sMeasure == "WH_STOCK") | FLAG | sPlanStartYyyymmdd | CString.GetCheckedListValue(dtPlanDate, cboPlanDate.ControlValues, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-5c88b130 | this.spdMain.CellDoubleClick | SSP0015_ShipmentPSI.cs:8161 | if (siMain.ActiveSheetIndex == 0) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) ▸ if (sMeasure == "WH_STOCK") | FLAG | sPlanType | siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.PLAN_TYPE)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-65d6ef06 | this.spdMain.CellDoubleClick | SSP0015_ShipmentPSI.cs:8162 | if (siMain.ActiveSheetIndex == 0) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) ▸ if (sMeasure == "WH_STOCK") | FLAG | sSeq | siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.SEQ)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-7509840c | this.spdMain.CellDoubleClick | SSP0015_ShipmentPSI.cs:8163 | if (siMain.ActiveSheetIndex == 0) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) ▸ if (sMeasure == "WH_STOCK") | FLAG | sFromSiteID | siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.FROM_SITE)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-504be786 | this.spdMain.CellDoubleClick | SSP0015_ShipmentPSI.cs:8166 | if (siMain.ActiveSheetIndex == 0) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) ▸ if (sMeasure == "WH_STOCK") | FLAG | sSrh | "N" | 화면 필드/플래그 변경 |  |  |  |
| AC-c7352753 | this.spdMain.CellDoubleClick | SSP0015_ShipmentPSI.cs:8168 | if (siMain.ActiveSheetIndex == 0) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) ▸ if (sMeasure == "WH_STOCK") | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtWHstock) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ade0ebd1 | this.spdMain.CellDoubleClick | SSP0015_ShipmentPSI.cs:8169 | if (siMain.ActiveSheetIndex == 0) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) ▸ if (sMeasure == "WH_STOCK") | GRID_INIT | siDetail.ChangeActiveSheet | (SpdSheet.shtWHstock) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-ea3fef7d | this.spdMain.CellDoubleClick | SSP0015_ShipmentPSI.cs:8180 | if (siMain.ActiveSheetIndex == 0) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) ▸ if (e.Column == siMain.GetColumnIndex(D… | FLAG | sPlanStartYyyymmdd | CString.GetCheckedListValue(dtPlanDate, cboPlanDate.ControlValues, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-e6828108 | this.spdMain.CellDoubleClick | SSP0015_ShipmentPSI.cs:8181 | if (siMain.ActiveSheetIndex == 0) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) ▸ if (e.Column == siMain.GetColumnIndex(D… | FLAG | sFromSiteID | siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.FROM_SITE)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-e2d7cef9 | this.spdMain.CellDoubleClick | SSP0015_ShipmentPSI.cs:8182 | if (siMain.ActiveSheetIndex == 0) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) ▸ if (e.Column == siMain.GetColumnIndex(D… | FLAG | sItemID | siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-54de624d | this.spdMain.CellDoubleClick | SSP0015_ShipmentPSI.cs:8184 | if (siMain.ActiveSheetIndex == 0) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) ▸ if (e.Column == siMain.GetColumnIndex(D… | FLAG | sPlanType | siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.PLAN_TYPE)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-e4a8dda8 | this.spdMain.CellDoubleClick | SSP0015_ShipmentPSI.cs:8185 | if (siMain.ActiveSheetIndex == 0) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) ▸ if (e.Column == siMain.GetColumnIndex(D… | FLAG | sSeq | siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.SEQ)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-375c6d97 | this.spdMain.CellDoubleClick | SSP0015_ShipmentPSI.cs:8187 | if (siMain.ActiveSheetIndex == 0) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) ▸ if (e.Column == siMain.GetColumnIndex(D… | FLAG | sSrh | "N" | 화면 필드/플래그 변경 |  |  |  |
| AC-e0e46010 | this.spdMain.CellDoubleClick | SSP0015_ShipmentPSI.cs:8189 | if (siMain.ActiveSheetIndex == 0) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) ▸ if (e.Column == siMain.GetColumnIndex(D… | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtBolckStock) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ddeb517d | this.spdMain.CellDoubleClick | SSP0015_ShipmentPSI.cs:8190 | if (siMain.ActiveSheetIndex == 0) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) ▸ if (e.Column == siMain.GetColumnIndex(D… | GRID_INIT | siDetail.ChangeActiveSheet | (SpdSheet.shtBolckStock) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-ae983d48 | this.spdMain.CellDoubleClick | SSP0015_ShipmentPSI.cs:8203 | if (siMain.ActiveSheetIndex == 0) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) ▸ if (e.Column == siMain.GetColumnIndex(D… | FLAG | sPlanStartYyyymmdd | CString.GetCheckedListValue(dtPlanDate, cboPlanDate.ControlValues, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-d21954b9 | this.spdMain.CellDoubleClick | SSP0015_ShipmentPSI.cs:8204 | if (siMain.ActiveSheetIndex == 0) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) ▸ if (e.Column == siMain.GetColumnIndex(D… | FLAG | sFromSiteID | siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.FROM_SITE)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-ecfe9bd5 | this.spdMain.CellDoubleClick | SSP0015_ShipmentPSI.cs:8205 | if (siMain.ActiveSheetIndex == 0) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) ▸ if (e.Column == siMain.GetColumnIndex(D… | FLAG | sItemID | siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-5d3bc7d7 | this.spdMain.CellDoubleClick | SSP0015_ShipmentPSI.cs:8207 | if (siMain.ActiveSheetIndex == 0) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) ▸ if (e.Column == siMain.GetColumnIndex(D… | FLAG | sPlanType | siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.PLAN_TYPE)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-71f21671 | this.spdMain.CellDoubleClick | SSP0015_ShipmentPSI.cs:8208 | if (siMain.ActiveSheetIndex == 0) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) ▸ if (e.Column == siMain.GetColumnIndex(D… | FLAG | sSeq | siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.SEQ)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-47e1fb9d | this.spdMain.CellDoubleClick | SSP0015_ShipmentPSI.cs:8210 | if (siMain.ActiveSheetIndex == 0) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) ▸ if (e.Column == siMain.GetColumnIndex(D… | FLAG | sSrh | "N" | 화면 필드/플래그 변경 |  |  |  |
| AC-fbe5f455 | this.spdMain.CellDoubleClick | SSP0015_ShipmentPSI.cs:8212 | if (siMain.ActiveSheetIndex == 0) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) ▸ if (e.Column == siMain.GetColumnIndex(D… | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtMesStock) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b9826292 | this.spdMain.CellDoubleClick | SSP0015_ShipmentPSI.cs:8213 | if (siMain.ActiveSheetIndex == 0) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) ▸ if (e.Column == siMain.GetColumnIndex(D… | GRID_INIT | siDetail.ChangeActiveSheet | (SpdSheet.shtMesStock) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-fbb46d09 | this.spdMain.CellDoubleClick | SSP0015_ShipmentPSI.cs:8224 | if (siMain.ActiveSheetIndex == 0) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) ▸ if (e.Column == siMain.GetColumnIndex(D… | FLAG | sPlanStartYyyymmdd | CString.GetCheckedListValue(dtPlanDate, cboPlanDate.ControlValues, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-191e146c | this.spdMain.CellDoubleClick | SSP0015_ShipmentPSI.cs:8225 | if (siMain.ActiveSheetIndex == 0) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) ▸ if (e.Column == siMain.GetColumnIndex(D… | FLAG | sFromSiteID | siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.FROM_SITE)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-2c99a789 | this.spdMain.CellDoubleClick | SSP0015_ShipmentPSI.cs:8226 | if (siMain.ActiveSheetIndex == 0) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) ▸ if (e.Column == siMain.GetColumnIndex(D… | FLAG | sItemID | siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-81ca57d1 | this.spdMain.CellDoubleClick | SSP0015_ShipmentPSI.cs:8228 | if (siMain.ActiveSheetIndex == 0) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) ▸ if (e.Column == siMain.GetColumnIndex(D… | FLAG | sPlanType | siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.PLAN_TYPE)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-7e139f40 | this.spdMain.CellDoubleClick | SSP0015_ShipmentPSI.cs:8229 | if (siMain.ActiveSheetIndex == 0) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) ▸ if (e.Column == siMain.GetColumnIndex(D… | FLAG | sSeq | siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.SEQ)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-0a1f3626 | this.spdMain.CellDoubleClick | SSP0015_ShipmentPSI.cs:8231 | if (siMain.ActiveSheetIndex == 0) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) ▸ if (e.Column == siMain.GetColumnIndex(D… | FLAG | sSrh | "N" | 화면 필드/플래그 변경 |  |  |  |
| AC-9016e880 | this.spdMain.CellDoubleClick | SSP0015_ShipmentPSI.cs:8233 | if (siMain.ActiveSheetIndex == 0) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) ▸ if (e.Column == siMain.GetColumnIndex(D… | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtMesStock) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1d58e498 | this.spdMain.CellDoubleClick | SSP0015_ShipmentPSI.cs:8234 | if (siMain.ActiveSheetIndex == 0) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) ▸ if (e.Column == siMain.GetColumnIndex(D… | GRID_INIT | siDetail.ChangeActiveSheet | (SpdSheet.shtMesStock) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-506fefd2 | this.spdMain.CellDoubleClick | SSP0015_ShipmentPSI.cs:8259 | if (siMain.ActiveSheetIndex == 0) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) ▸ if (sMeasure == "WH_IN") ▸ else of (str… | DATA_OP | dtMyDivision.Compute | ("MAX(NAME)", "CODE = '" + strDivision_ID + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-c9f8535c | this.spdMain.CellDoubleClick | SSP0015_ShipmentPSI.cs:8283 | if (siMain.ActiveSheetIndex == 0) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) ▸ if (sMeasure == "WH_IN") ▸ if (strQty =… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2f13fe13 | this.spdMain.CellDoubleClick | SSP0015_ShipmentPSI.cs:8290 | if (siMain.ActiveSheetIndex == 0) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) ▸ if (sMeasure == "WH_IN") | DATA_OP | row.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-87bc73f1 | this.spdMain.CellDoubleClick | SSP0015_ShipmentPSI.cs:8291 | if (siMain.ActiveSheetIndex == 0) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) ▸ if (sMeasure == "WH_IN") | DATA_OP | row.Field | ("SITE") | 데이터 객체 조작/조회 |  |  |  |
| AC-32480250 | this.spdMain.CellDoubleClick | SSP0015_ShipmentPSI.cs:8292 | if (siMain.ActiveSheetIndex == 0) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) ▸ if (sMeasure == "WH_IN") | DATA_OP | row.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-c0cccdcd | this.spdMain.CellDoubleClick | SSP0015_ShipmentPSI.cs:8293 | if (siMain.ActiveSheetIndex == 0) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) ▸ if (sMeasure == "WH_IN") | DATA_OP | row.Field | ("YYYYMMDD") | 데이터 객체 조작/조회 |  |  |  |
| AC-6f360c42 | this.spdMain.CellDoubleClick | SSP0015_ShipmentPSI.cs:8302 | if (siMain.ActiveSheetIndex == 0) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) ▸ if (sMeasure == "WH_IN") ▸ if (Comments… | CALL_EXT | Comments["GAP"].ToString().LastIndexOf | (".") | ⚠ 의미 확인 필요 |  |  |  |
| AC-7cdd6c62 | this.spdMain.CellDoubleClick | SSP0015_ShipmentPSI.cs:8313 | if (siMain.ActiveSheetIndex == 0) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) ▸ if (sMeasure == "WH_IN") ▸ if (Comments… | POPUP | new SSP0015_ShipmentPSICommentsPopup | (strDivision_ID, strDivision_NM, strPlan_Date, strFromSite_ID, strFromSite_NM, strItem_ID,… | 팝업/폼 생성 |  |  |  |
| AC-6ffb1ca5 | this.spdMain.CellDoubleClick | SSP0015_ShipmentPSI.cs:8314 | if (siMain.ActiveSheetIndex == 0) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) ▸ if (sMeasure == "WH_IN") ▸ if (Comments… | UI_PROP | ssp0015Popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-52457793 | this.spdMain.CellDoubleClick | SSP0015_ShipmentPSI.cs:8315 | if (siMain.ActiveSheetIndex == 0) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) ▸ if (sMeasure == "WH_IN") ▸ if (Comments… | POPUP | ssp0015Popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-a413e533 | this.spdMain.CellDoubleClick | SSP0015_ShipmentPSI.cs:8318 | if (siMain.ActiveSheetIndex == 0) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) ▸ if (sMeasure == "WH_IN") ▸ if (Comments… | UI_PROP | spdMain.AutoClipboard | false | 속성 AutoClipboard 설정 |  |  |  |
| AC-9da31776 | this.spdMain.CellDoubleClick | SSP0015_ShipmentPSI.cs:8336 | if (siMain.ActiveSheetIndex == 0) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) ▸ if (sMeasure == "WH_IN") ▸ else of (Com… | POPUP | new SSP0015_ShipmentPSICommentsPopup | (strDivision_ID, strDivision_NM, strPlan_Date, strFromSite_ID, strFromSite_NM, strItem_ID,… | 팝업/폼 생성 |  |  |  |
| AC-4e307181 | this.spdMain.CellDoubleClick | SSP0015_ShipmentPSI.cs:8337 | if (siMain.ActiveSheetIndex == 0) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) ▸ if (sMeasure == "WH_IN") ▸ else of (Com… | UI_PROP | ssp0015Popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-2c647580 | this.spdMain.CellDoubleClick | SSP0015_ShipmentPSI.cs:8338 | if (siMain.ActiveSheetIndex == 0) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) ▸ if (sMeasure == "WH_IN") ▸ else of (Com… | POPUP | ssp0015Popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-7b548fe3 | this.spdMain.CellDoubleClick | SSP0015_ShipmentPSI.cs:8341 | if (siMain.ActiveSheetIndex == 0) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) ▸ if (sMeasure == "WH_IN") ▸ else of (Com… | UI_PROP | spdMain.AutoClipboard | false | 속성 AutoClipboard 설정 |  |  |  |
| AC-e046caad | this.spdMain.CellDoubleClick | SSP0015_ShipmentPSI.cs:8355 | else of (siMain.ActiveSheetIndex == 0) ▸ if (siMain.ActiveSheetIndex == 1) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) | FLAG | bDetail_Search | false | 화면 필드/플래그 변경 |  |  |  |
| AC-71f025a1 | this.spdMain.CellDoubleClick | SSP0015_ShipmentPSI.cs:8362 | else of (siMain.ActiveSheetIndex == 0) ▸ if (siMain.ActiveSheetIndex == 1) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) … | FLAG | sPlanStartYyyymmdd | CString.GetCheckedListValue(dtPlanDate, cboPlanDate.ControlValues, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-ef754dad | this.spdMain.CellDoubleClick | SSP0015_ShipmentPSI.cs:8363 | else of (siMain.ActiveSheetIndex == 0) ▸ if (siMain.ActiveSheetIndex == 1) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) … | FLAG | sFromSiteID | siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.FROM_SITE)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-47b7f2e0 | this.spdMain.CellDoubleClick | SSP0015_ShipmentPSI.cs:8364 | else of (siMain.ActiveSheetIndex == 0) ▸ if (siMain.ActiveSheetIndex == 1) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) … | FLAG | sItemID | siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-9835b02d | this.spdMain.CellDoubleClick | SSP0015_ShipmentPSI.cs:8366 | else of (siMain.ActiveSheetIndex == 0) ▸ if (siMain.ActiveSheetIndex == 1) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) … | FLAG | sPlanType | siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.PLAN_TYPE)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-a9971800 | this.spdMain.CellDoubleClick | SSP0015_ShipmentPSI.cs:8367 | else of (siMain.ActiveSheetIndex == 0) ▸ if (siMain.ActiveSheetIndex == 1) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) … | FLAG | sSeq | siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.SEQ)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-f8ee94cc | this.spdMain.CellDoubleClick | SSP0015_ShipmentPSI.cs:8369 | else of (siMain.ActiveSheetIndex == 0) ▸ if (siMain.ActiveSheetIndex == 1) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) … | FLAG | sSrh | "N" | 화면 필드/플래그 변경 |  |  |  |
| AC-8e3d6b08 | this.spdMain.CellDoubleClick | SSP0015_ShipmentPSI.cs:8372 | else of (siMain.ActiveSheetIndex == 0) ▸ if (siMain.ActiveSheetIndex == 1) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) … | VALUE_SET | txtModel2.Text | sItemID | 컨트롤 값 설정 |  |  |  |
| AC-2d92262c | this.spdMain.CellDoubleClick | SSP0015_ShipmentPSI.cs:8374 | else of (siMain.ActiveSheetIndex == 0) ▸ if (siMain.ActiveSheetIndex == 1) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) … | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtScsStock) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-fdb11786 | this.spdMain.CellDoubleClick | SSP0015_ShipmentPSI.cs:8375 | else of (siMain.ActiveSheetIndex == 0) ▸ if (siMain.ActiveSheetIndex == 1) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) … | GRID_INIT | siDetail.ChangeActiveSheet | (SpdSheet.shtScsStock) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-f8232e2d | this.spdMain.CellDoubleClick | SSP0015_ShipmentPSI.cs:8387 | else of (siMain.ActiveSheetIndex == 0) ▸ if (siMain.ActiveSheetIndex == 1) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) … | FLAG | sPlanStartYyyymmdd | CString.GetCheckedListValue(dtPlanDate, cboPlanDate.ControlValues, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-0f465d1d | this.spdMain.CellDoubleClick | SSP0015_ShipmentPSI.cs:8388 | else of (siMain.ActiveSheetIndex == 0) ▸ if (siMain.ActiveSheetIndex == 1) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) … | FLAG | sFromSiteID | siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.FROM_SITE)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-db0d0241 | this.spdMain.CellDoubleClick | SSP0015_ShipmentPSI.cs:8389 | else of (siMain.ActiveSheetIndex == 0) ▸ if (siMain.ActiveSheetIndex == 1) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) … | FLAG | sItemID | siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-9eee3770 | this.spdMain.CellDoubleClick | SSP0015_ShipmentPSI.cs:8391 | else of (siMain.ActiveSheetIndex == 0) ▸ if (siMain.ActiveSheetIndex == 1) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) … | FLAG | sPlanType | siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.PLAN_TYPE)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-03692d76 | this.spdMain.CellDoubleClick | SSP0015_ShipmentPSI.cs:8392 | else of (siMain.ActiveSheetIndex == 0) ▸ if (siMain.ActiveSheetIndex == 1) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) … | FLAG | sSeq | siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.SEQ)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-03158d20 | this.spdMain.CellDoubleClick | SSP0015_ShipmentPSI.cs:8394 | else of (siMain.ActiveSheetIndex == 0) ▸ if (siMain.ActiveSheetIndex == 1) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) … | FLAG | sSrh | "N" | 화면 필드/플래그 변경 |  |  |  |
| AC-866355f6 | this.spdMain.CellDoubleClick | SSP0015_ShipmentPSI.cs:8396 | else of (siMain.ActiveSheetIndex == 0) ▸ if (siMain.ActiveSheetIndex == 1) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) … | VALUE_SET | txtModel2.Text | sItemID | 컨트롤 값 설정 |  |  |  |
| AC-5dab7847 | this.spdMain.CellDoubleClick | SSP0015_ShipmentPSI.cs:8398 | else of (siMain.ActiveSheetIndex == 0) ▸ if (siMain.ActiveSheetIndex == 1) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) … | GRID_INIT | siDetail.ChangeSheet | (SpdSheet.shtStockLocationDetail) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a386ddde | this.spdMain.CellDoubleClick | SSP0015_ShipmentPSI.cs:8399 | else of (siMain.ActiveSheetIndex == 0) ▸ if (siMain.ActiveSheetIndex == 1) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) … | GRID_INIT | siDetail.ChangeActiveSheet | (SpdSheet.shtStockLocationDetail) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SSP0015_ShipmentPSI.SpdMain_EditModeOn

진입점: spdMain.EditModeOn

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f8c6a073 | spdMain.EditModeOn | SSP0015_ShipmentPSI.cs:1212 |  | UI_PROP | spdMain.EditingControl.ContextMenu | contextMenu | 속성 ContextMenu 설정 |  |  |  |

## SSP0015_ShipmentPSI.spdMain_TextTipFetch

진입점: this.spdMain.TextTipFetch

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e8daf9e1 | this.spdMain.TextTipFetch | SSP0015_ShipmentPSI.cs:9382 | if (drPgmAuthId != null) ▸ if (spdMain.ActiveSheet.RowCount > 0) | GRID_SET | spdMain.ActiveSheet.Cells[intRNoteIdx, intCNoteIdx].NoteStyle | NoteStyle.Hidden | 그리드 속성/값 설정 |  |  |  |
| AC-903eb0a5 | this.spdMain.TextTipFetch | SSP0015_ShipmentPSI.cs:9385 | if (drPgmAuthId != null) ▸ if (spdMain.ActiveSheet.RowCount > 0) ▸ if (spdMain.ActiveSheet.Cells[e.Row, e.Column].Note != "") | GRID_SET | spdMain.ActiveSheet.Cells[e.Row, e.Column].NoteStyle | NoteStyle.StickyNote | 그리드 속성/값 설정 |  |  |  |
| AC-df88b9a1 | this.spdMain.TextTipFetch | SSP0015_ShipmentPSI.cs:9386 | if (drPgmAuthId != null) ▸ if (spdMain.ActiveSheet.RowCount > 0) ▸ if (spdMain.ActiveSheet.Cells[e.Row, e.Column].Note != "") | FLAG | intRNoteIdx | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-d5817ad6 | this.spdMain.TextTipFetch | SSP0015_ShipmentPSI.cs:9387 | if (drPgmAuthId != null) ▸ if (spdMain.ActiveSheet.RowCount > 0) ▸ if (spdMain.ActiveSheet.Cells[e.Row, e.Column].Note != "") | FLAG | intCNoteIdx | e.Column | 화면 필드/플래그 변경 |  |  |  |

## SSP0015_ShipmentPSI.SpdMain_TopChange

진입점: this.spdMain.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3dffdc7c | this.spdMain.TopChange | SSP0015_ShipmentPSI.cs:1679 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SSP0015_ShipmentPSI.TsmNotepad_Click

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d2b66206 | (진입점 미연결) | SSP0015_ShipmentPSI.cs:1231 | else of (strDivision_ID == "40") | DATA_OP | dtMyDivision.Compute | ("MAX(NAME)", "CODE = '" + strDivision_ID + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-a7941399 | (진입점 미연결) | SSP0015_ShipmentPSI.cs:1257 |  | DATA_OP | row.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-5e52f7ca | (진입점 미연결) | SSP0015_ShipmentPSI.cs:1258 |  | DATA_OP | row.Field | ("SITE") | 데이터 객체 조작/조회 |  |  |  |
| AC-9a3cf619 | (진입점 미연결) | SSP0015_ShipmentPSI.cs:1259 |  | DATA_OP | row.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-56cbad80 | (진입점 미연결) | SSP0015_ShipmentPSI.cs:1260 |  | DATA_OP | row.Field | ("YYYYMMDD") | 데이터 객체 조작/조회 |  |  |  |
| AC-e841db5d | (진입점 미연결) | SSP0015_ShipmentPSI.cs:1269 | if (Comments != null) | CALL_EXT | Comments["GAP"].ToString().LastIndexOf | (".") | ⚠ 의미 확인 필요 |  |  |  |
| AC-77b20609 | (진입점 미연결) | SSP0015_ShipmentPSI.cs:1280 | if (Comments != null) | POPUP | new SSP0015_ShipmentPSICommentsPopup | (strDivision_ID, strDivision_NM, strPlan_Date, strFromSite_ID, strFromSite_NM, strItem_ID,… | 팝업/폼 생성 |  |  |  |
| AC-9165114f | (진입점 미연결) | SSP0015_ShipmentPSI.cs:1281 | if (Comments != null) | UI_PROP | ssp0015Popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-e9b3467a | (진입점 미연결) | SSP0015_ShipmentPSI.cs:1282 | if (Comments != null) | POPUP | ssp0015Popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-880da723 | (진입점 미연결) | SSP0015_ShipmentPSI.cs:1285 | if (Comments != null) | UI_PROP | spdMain.AutoClipboard | false | 속성 AutoClipboard 설정 |  |  |  |
| AC-c8a58101 | (진입점 미연결) | SSP0015_ShipmentPSI.cs:1303 | else of (Comments != null) | POPUP | new SSP0015_ShipmentPSICommentsPopup | (strDivision_ID, strDivision_NM, strPlan_Date, strFromSite_ID, strFromSite_NM, strItem_ID,… | 팝업/폼 생성 |  |  |  |
| AC-5028d063 | (진입점 미연결) | SSP0015_ShipmentPSI.cs:1304 | else of (Comments != null) | UI_PROP | ssp0015Popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-144e0a96 | (진입점 미연결) | SSP0015_ShipmentPSI.cs:1305 | else of (Comments != null) | POPUP | ssp0015Popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-685b7bd2 | (진입점 미연결) | SSP0015_ShipmentPSI.cs:1308 | else of (Comments != null) | UI_PROP | spdMain.AutoClipboard | false | 속성 AutoClipboard 설정 |  |  |  |

## SSP0015_ShipmentPSI.Validation_Check

진입점: SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.ActiveSheetIndex == 0) ▸ if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ if (siDetail.SheetName == SpdSheet.shtDetail) ▸ else of (chkERPIFBlockYn()) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ba2a7b59 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6293 |  | FLAG | bolChang_Flag | false | 화면 필드/플래그 변경 |  |  |  |
| AC-cc13328a | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6311 | for (i < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].Text == "M" \… | MESSAGE | MessageHelper.GMessageBox | ("MSG00194", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b9979bb0 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6312 | for (i < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].Text == "M" \… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-585356c6 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6318 | for (i < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].Text == "M" \… | DATA_OP | DefaultMainDS.Tables[0].Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-c82b2612 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6318 | for (i < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].Text == "M" \… | DATA_OP | row.Field | ("confirm_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-ab7bc435 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6334 | for (i < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].Text == "M" \… | FLAG | bolChang_Flag | true | 화면 필드/플래그 변경 |  |  |  |
| AC-e00b7562 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6354 | for (i < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].Text == "M" \… | GRID_SET | siDetail.SetValue | (i, siDetail.GetColumnIndex(DefColumns.CHANGE_REASON_CODE), "T07") | 그리드 값 설정 |  |  |  |
| AC-a8287082 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6374 | for (i < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].Text == "M" \… | DATA_OP | DefaultMainDS.Tables[0].Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-d40ecb50 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6374 | for (i < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].Text == "M" \… | DATA_OP | row.Field | ("confirm_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-ae68dad8 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6430 | for (i < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].Text == "M" \… | GRID_STYLE | siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].ResetBack… | () | 그리드 표시 설정 |  |  |  |
| AC-30e7bd29 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6431 | for (i < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].Text == "M" \… | GRID_STYLE | siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].ResetFore… | () | 그리드 표시 설정 |  |  |  |
| AC-ba1b52c3 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6432 | for (i < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].Text == "M" \… | GRID_SET | siDetail.SetValue | (i, siDetail.GetColumnIndex(CAppSetting.StringAction), "") | 그리드 값 설정 |  |  |  |
| AC-5ffcab20 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6434 | for (i < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].Text == "M" \… | GRID_STYLE | siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(DefColumns.SHIPMENT_CONFIRM_QTY)].Re… | () | 그리드 표시 설정 |  |  |  |
| AC-2845041b | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6435 | for (i < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].Text == "M" \… | GRID_STYLE | siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(DefColumns.SHIPMENT_DATE)].ResetFore… | () | 그리드 표시 설정 |  |  |  |
| AC-185463ad | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6436 | for (i < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].Text == "M" \… | GRID_STYLE | siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(DefColumns.TRANSPORT_MODE)].ResetFor… | () | 그리드 표시 설정 |  |  |  |
| AC-584c538c | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6437 | for (i < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].Text == "M" \… | GRID_STYLE | siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(DefColumns.REMARKS2)].ResetForeColor | () | 그리드 표시 설정 |  |  |  |
| AC-0465a063 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6438 | for (i < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].Text == "M" \… | GRID_STYLE | siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(DefColumns.REMARKS)].ResetForeColor | () | 그리드 표시 설정 |  |  |  |
| AC-b67f2a14 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6446 | for (i < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].Text == "M" \… | FLAG | bolChang_Flag | false | 화면 필드/플래그 변경 |  |  |  |
| AC-737ad6dd | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6450 | for (i < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].Text == "M" \… | FLAG | bolChang_Flag | true | 화면 필드/플래그 변경 |  |  |  |
| AC-9439595d | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6466 | for (i < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].Text == "M" \… | DATA_OP | DefaultMainDS.Tables[0].Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-90d69aaf | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6466 | for (i < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].Text == "M" \… | DATA_OP | row.Field | ("confirm_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-50cedc01 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6498 | for (i < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].Text == "M" \… | GRID_STYLE | siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].ResetBack… | () | 그리드 표시 설정 |  |  |  |
| AC-f891f18c | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6499 | for (i < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].Text == "M" \… | GRID_STYLE | siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].ResetFore… | () | 그리드 표시 설정 |  |  |  |
| AC-8af8e43d | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6500 | for (i < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].Text == "M" \… | GRID_SET | siDetail.SetValue | (i, siDetail.GetColumnIndex(CAppSetting.StringAction), "") | 그리드 값 설정 |  |  |  |
| AC-4f0d6642 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6502 | for (i < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].Text == "M" \… | GRID_STYLE | siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(DefColumns.SHIPMENT_CONFIRM_QTY)].Re… | () | 그리드 표시 설정 |  |  |  |
| AC-c27a30b7 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6503 | for (i < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].Text == "M" \… | GRID_STYLE | siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(DefColumns.SHIPMENT_DATE)].ResetFore… | () | 그리드 표시 설정 |  |  |  |
| AC-73c1b921 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6504 | for (i < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].Text == "M" \… | GRID_STYLE | siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(DefColumns.TRANSPORT_MODE)].ResetFor… | () | 그리드 표시 설정 |  |  |  |
| AC-496c89f2 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6505 | for (i < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].Text == "M" \… | GRID_STYLE | siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(DefColumns.REMARKS2)].ResetForeColor | () | 그리드 표시 설정 |  |  |  |
| AC-f63d4cfd | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6506 | for (i < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].Text == "M" \… | GRID_STYLE | siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(DefColumns.REMARKS)].ResetForeColor | () | 그리드 표시 설정 |  |  |  |
| AC-6c13bf24 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6508 | for (i < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].Text == "M" \… | MESSAGE | MessageHelper.GMessageBox | ("MSG00286", new object[] { (i + 1).ToString() }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-53916f79 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6510 | for (i < siDetail.ActiveSheet.RowCount) ▸ if (siDetail.ActiveSheet.Cells[i, siDetail.GetColumnIndex(CAppSetting.StringAction)].Text == "M" \… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-02ebac43 | SaveButton [else of (fps.Name == "spdMain") ▸ if (siMain.Act… | SSP0015_ShipmentPSI.cs:6516 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## SSP0015_ShipmentPSICommentsPopup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4993a9d6 | .ctor | SSP0015_ShipmentPSICommentsPopup.cs:187 |  | FLAG | this.Division_ID | spDivision_ID | 화면 필드/플래그 변경 |  |  |  |
| AC-412dc94f | .ctor | SSP0015_ShipmentPSICommentsPopup.cs:188 |  | FLAG | this.Division_NM | spDivision_NM | 화면 필드/플래그 변경 |  |  |  |
| AC-78e938ad | .ctor | SSP0015_ShipmentPSICommentsPopup.cs:189 |  | FLAG | this.Plan_Date | spPlan_Date.Replace("-", "") | 화면 필드/플래그 변경 |  |  |  |
| AC-5a5b4ea5 | .ctor | SSP0015_ShipmentPSICommentsPopup.cs:190 |  | FLAG | this.FromSite_ID | spFromSite_ID | 화면 필드/플래그 변경 |  |  |  |
| AC-66049e96 | .ctor | SSP0015_ShipmentPSICommentsPopup.cs:191 |  | FLAG | this.FromSite_NM | spFromSite_NM | 화면 필드/플래그 변경 |  |  |  |
| AC-b4dfaa0a | .ctor | SSP0015_ShipmentPSICommentsPopup.cs:192 |  | FLAG | this.Item_ID | spItem_ID | 화면 필드/플래그 변경 |  |  |  |
| AC-50f65004 | .ctor | SSP0015_ShipmentPSICommentsPopup.cs:193 |  | FLAG | this.Date | spDate | 화면 필드/플래그 변경 |  |  |  |
| AC-9cd14b2c | .ctor | SSP0015_ShipmentPSICommentsPopup.cs:194 |  | FLAG | this.Measure_ID | spMeasure_ID | 화면 필드/플래그 변경 |  |  |  |
| AC-05f43a13 | .ctor | SSP0015_ShipmentPSICommentsPopup.cs:195 |  | FLAG | this.Measure_NM | spMeasure_NM | 화면 필드/플래그 변경 |  |  |  |
| AC-03a2c2a3 | .ctor | SSP0015_ShipmentPSICommentsPopup.cs:196 |  | FLAG | this.UserAddQty | spUserAddQty | 화면 필드/플래그 변경 |  |  |  |
| AC-fb5999d9 | .ctor | SSP0015_ShipmentPSICommentsPopup.cs:197 |  | FLAG | this.BeforeQty | spBeforeQty | 화면 필드/플래그 변경 |  |  |  |
| AC-daa52592 | .ctor | SSP0015_ShipmentPSICommentsPopup.cs:198 |  | FLAG | this.Gap | spGap | 화면 필드/플래그 변경 |  |  |  |
| AC-609ba305 | .ctor | SSP0015_ShipmentPSICommentsPopup.cs:199 |  | FLAG | this.Qty | spQty | 화면 필드/플래그 변경 |  |  |  |
| AC-624754ab | .ctor | SSP0015_ShipmentPSICommentsPopup.cs:200 |  | FLAG | this.ProdQty | spProdQty | 화면 필드/플래그 변경 |  |  |  |
| AC-652c94e9 | .ctor | SSP0015_ShipmentPSICommentsPopup.cs:201 |  | FLAG | this.PlanType | spPlanType | 화면 필드/플래그 변경 |  |  |  |
| AC-7026fb64 | .ctor | SSP0015_ShipmentPSICommentsPopup.cs:202 |  | FLAG | this.Seq | spSeq | 화면 필드/플래그 변경 |  |  |  |
| AC-1f8a44ed | .ctor | SSP0015_ShipmentPSICommentsPopup.cs:203 |  | FLAG | this.User_ID | spUser_ID | 화면 필드/플래그 변경 |  |  |  |
| AC-6aeac895 | .ctor | SSP0015_ShipmentPSICommentsPopup.cs:204 |  | FLAG | this.Comments | spComments | 화면 필드/플래그 변경 |  |  |  |

## SSP0015_ShipmentPSICommentsPopup.btnButtonList_UsrButtonList_Click_Detected

진입점: this.btnButtonList.UsrButtonList_Click_Detected

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-674b0803 | this.btnButtonList.UsrButtonList_Click_Detected | SSP0015_ShipmentPSICommentsPopup.cs:440 | else of (buttonItem.UserType == ButtonListType.Save) ▸ if (buttonItem.UserType == ButtonListType.Cancel) | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## SSP0015_ShipmentPSICommentsPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0350cb80 | Dispose | SSP0015_ShipmentPSICommentsPopup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SSP0015_ShipmentPSICommentsPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-abd57a5a | this.Load | SSP0015_ShipmentPSICommentsPopup.cs:212 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SSP0015_ShipmentPSICommentsPopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-88bc2de4 | this.Load | SSP0015_ShipmentPSICommentsPopup.cs:225 |  | VALUE_SET | this.txtDivision_ID.Text | Division_NM | 컨트롤 값 설정 |  |  |  |
| AC-f0728748 | this.Load | SSP0015_ShipmentPSICommentsPopup.cs:226 |  | VALUE_SET | this.txtPlan_Date.Text | Plan_Date.Substring(0, 4) + "-" + Plan_Date.Substring(4, 2) + "-" + Plan_Date.Substring(6,… | 컨트롤 값 설정 |  |  |  |
| AC-bee786a3 | this.Load | SSP0015_ShipmentPSICommentsPopup.cs:227 |  | VALUE_SET | this.txtFrom_Site.Text | FromSite_NM | 컨트롤 값 설정 |  |  |  |
| AC-512be872 | this.Load | SSP0015_ShipmentPSICommentsPopup.cs:228 |  | VALUE_SET | this.txtItem_ID.Text | Item_ID | 컨트롤 값 설정 |  |  |  |
| AC-ab6c40fb | this.Load | SSP0015_ShipmentPSICommentsPopup.cs:229 |  | VALUE_SET | this.txtDate.Text | Date.Substring(0, 4) + "-" + Date.Substring(4, 2) + "-" + Date.Substring(6, 2) | 컨트롤 값 설정 |  |  |  |
| AC-5493a430 | this.Load | SSP0015_ShipmentPSICommentsPopup.cs:230 |  | VALUE_SET | this.txtMeasure.Text | Measure_NM | 컨트롤 값 설정 |  |  |  |
| AC-8ecb7216 | this.Load | SSP0015_ShipmentPSICommentsPopup.cs:231 |  | VALUE_SET | this.txtChange_Qty.Text | Qty | 컨트롤 값 설정 |  |  |  |
| AC-ad3b520f | this.Load | SSP0015_ShipmentPSICommentsPopup.cs:232 |  | VALUE_SET | this.txtCurrent_Qty.Text | Qty | 컨트롤 값 설정 |  |  |  |
| AC-270adbbc | this.Load | SSP0015_ShipmentPSICommentsPopup.cs:233 |  | VALUE_SET | this.txtBefore_Qty.Text | UserAddQty | 컨트롤 값 설정 |  |  |  |
| AC-45ac4b93 | this.Load | SSP0015_ShipmentPSICommentsPopup.cs:234 |  | VALUE_SET | this.txtGap_Qty.Text | Gap | 컨트롤 값 설정 |  |  |  |
| AC-77fb754b | this.Load | SSP0015_ShipmentPSICommentsPopup.cs:235 |  | VALUE_SET | this.txtWHin_Qty.Text | Qty | 컨트롤 값 설정 |  |  |  |
| AC-4905b952 | this.Load | SSP0015_ShipmentPSICommentsPopup.cs:236 |  | VALUE_SET | this.txtProd_Qty.Text | ProdQty | 컨트롤 값 설정 |  |  |  |
| AC-cedc25b8 | this.Load | SSP0015_ShipmentPSICommentsPopup.cs:237 |  | VALUE_SET | this.rtxComments.Text | Comments | 컨트롤 값 설정 |  |  |  |
| AC-781b9ba8 | this.Load | SSP0015_ShipmentPSICommentsPopup.cs:240 |  | STATE | this.txtDivision_ID.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-c4a262d3 | this.Load | SSP0015_ShipmentPSICommentsPopup.cs:241 |  | STATE | this.txtPlan_Date.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-e9a1492f | this.Load | SSP0015_ShipmentPSICommentsPopup.cs:242 |  | STATE | this.txtFrom_Site.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-e4f6dff2 | this.Load | SSP0015_ShipmentPSICommentsPopup.cs:243 |  | STATE | this.txtItem_ID.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-ebfbb913 | this.Load | SSP0015_ShipmentPSICommentsPopup.cs:244 |  | STATE | this.txtDate.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-94eee16c | this.Load | SSP0015_ShipmentPSICommentsPopup.cs:245 |  | STATE | this.txtMeasure.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-1c98aa7c | this.Load | SSP0015_ShipmentPSICommentsPopup.cs:246 |  | STATE | this.txtCurrent_Qty.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-b13de1ae | this.Load | SSP0015_ShipmentPSICommentsPopup.cs:247 |  | STATE | this.txtProd_Qty.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-33159b46 | this.Load | SSP0015_ShipmentPSICommentsPopup.cs:248 |  | STATE | this.txtWHin_Qty.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-f7a6db7e | this.Load | SSP0015_ShipmentPSICommentsPopup.cs:249 |  | STATE | this.txtBefore_Qty.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-83c31105 | this.Load | SSP0015_ShipmentPSICommentsPopup.cs:250 |  | STATE | this.txtGap_Qty.Enabled | false | 컨트롤 상태 Enabled |  |  |  |

## SSP0015_ShipmentPSICommentsPopup.SaveData

진입점: this.btnButtonList.UsrButtonList_Click_Detected [if (buttonItem.UserType == ButtonListType.Save)] / SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f5bb884f | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0015_ShipmentPSICommentsPopup.cs:282 | try | FLAG | SaveFlag | true | 화면 필드/플래그 변경 |  |  |  |
| AC-e4bc268c | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0015_ShipmentPSICommentsPopup.cs:285 | try ▸ if (Validation_Check() == false) | FLAG | SaveFlag | false | 화면 필드/플래그 변경 |  |  |  |
| AC-2f771072 | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0015_ShipmentPSICommentsPopup.cs:286 | try ▸ if (Validation_Check() == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ca731dd2 | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0015_ShipmentPSICommentsPopup.cs:331 | try | MESSAGE | MessageHelper.GMessageBox | ("MSG00012") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-731fa01d | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0015_ShipmentPSICommentsPopup.cs:333 | try ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) | ENDPOINT | new FoxDataRequest | ("SSP.SSP0015_SAVE_SHIPMENT_PSI_COMMENTS") ⇒ SSP.SSP0015_SAVE_SHIPMENT_PSI_COMMENTS | 엔드포인트 요청 생성 |  |  |  |
| AC-da76244a | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0015_ShipmentPSICommentsPopup.cs:337 | try ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SSP.Plan.WSL/FoxDataService.s… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-27a3792c | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0015_ShipmentPSICommentsPopup.cs:341 | try ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ lambda | DATA_OP | request.Parameters["p_change_flag"] | p_change_flag | 행/컬럼 값 대입 |  |  |  |
| AC-cfbd5a99 | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0015_ShipmentPSICommentsPopup.cs:342 | try ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-7bf0b5c5 | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0015_ShipmentPSICommentsPopup.cs:343 | try ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ lambda | DATA_OP | request.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-98bee18d | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0015_ShipmentPSICommentsPopup.cs:344 | try ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ lambda | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-3dd3505e | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0015_ShipmentPSICommentsPopup.cs:345 | try ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ lambda | DATA_OP | request.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-cc5b9cb8 | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0015_ShipmentPSICommentsPopup.cs:346 | try ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ lambda | DATA_OP | request.Parameters["p_yyyymmdd"] | p_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-35f73e1d | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0015_ShipmentPSICommentsPopup.cs:347 | try ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ lambda | DATA_OP | request.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-f7e4e1ad | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0015_ShipmentPSICommentsPopup.cs:348 | try ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ lambda | DATA_OP | request.Parameters["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-d3682960 | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0015_ShipmentPSICommentsPopup.cs:349 | try ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ lambda | DATA_OP | request.Parameters["p_measure"] | p_measure | 행/컬럼 값 대입 |  |  |  |
| AC-143bae07 | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0015_ShipmentPSICommentsPopup.cs:350 | try ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ lambda | DATA_OP | request.Parameters["p_qty"] | p_qty | 행/컬럼 값 대입 |  |  |  |
| AC-ecb78caa | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0015_ShipmentPSICommentsPopup.cs:351 | try ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ lambda | DATA_OP | request.Parameters["p_prodQty"] | p_prodQty | 행/컬럼 값 대입 |  |  |  |
| AC-d631e13b | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0015_ShipmentPSICommentsPopup.cs:352 | try ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ lambda | DATA_OP | request.Parameters["p_comments"] | p_comments | 행/컬럼 값 대입 |  |  |  |
| AC-de574fa6 | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0015_ShipmentPSICommentsPopup.cs:353 | try ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ lambda | DATA_OP | request.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-4ca72782 | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0015_ShipmentPSICommentsPopup.cs:355 | try ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ lambda | UI_PROP | request.CommandTimeout | 10 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-70fbe36a | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0015_ShipmentPSICommentsPopup.cs:357 | try ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-6ae52a38 | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0015_ShipmentPSICommentsPopup.cs:357 | try ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ lambda | RETURN | return client.ExecuteDataSet(request); |  | 처리 중단/반환 |  |  |  |
| AC-59c2c0b1 | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0015_ShipmentPSICommentsPopup.cs:368 | try ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S"… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { "1" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f7c5a4f9 | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0015_ShipmentPSICommentsPopup.cs:370 | try ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S"… | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-c095163c | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0015_ShipmentPSICommentsPopup.cs:376 | try ▸ if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ if (t.Success) ▸ else of (t.DataSet.Tables[0].Rows[0][0].ToString() =… | MESSAGE | MessageHelper.GMessageBox | ("MSG00284", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-05908759 | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0015_ShipmentPSICommentsPopup.cs:383 | try ▸ else of (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-663676ce | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0015_ShipmentPSICommentsPopup.cs:389 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6e599781 | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0015_ShipmentPSICommentsPopup.cs:390 | catch ((Exception ex)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SSP0015_ShipmentPSICommentsPopup.txtBefore_Qty_TextChanged

진입점: this.txtBefore_Qty.TextChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7ceee165 | this.txtBefore_Qty.TextChanged | SSP0015_ShipmentPSICommentsPopup.cs:137 | if (txtBefore_Qty.Text != "") ▸ if (Int64.TryParse(strTmpText, out intRusult)) | VALUE_SET | txtBefore_Qty.Text | string.Format("{0:#,##0}", Convert.ToInt64(strTmpText)) | 컨트롤 값 설정 |  |  |  |
| AC-0eee69ac | this.txtBefore_Qty.TextChanged | SSP0015_ShipmentPSICommentsPopup.cs:137 | if (txtBefore_Qty.Text != "") ▸ if (Int64.TryParse(strTmpText, out intRusult)) | CALL_EXT | Convert.ToInt64 | (strTmpText) | ⚠ 의미 확인 필요 |  |  |  |

## SSP0015_ShipmentPSICommentsPopup.txtChange_Qty_KeyPress

진입점: this.txtChange_Qty.KeyPress

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-da442bf1 | this.txtChange_Qty.KeyPress | SSP0015_ShipmentPSICommentsPopup.cs:66 |  | CALL_EXT | char.IsDigit | (e.KeyChar) | ⚠ 의미 확인 필요 |  |  |  |
| AC-544455cb | this.txtChange_Qty.KeyPress | SSP0015_ShipmentPSICommentsPopup.cs:66 |  | CALL_EXT | Convert.ToChar | (Keys.Back) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3280eb1a | this.txtChange_Qty.KeyPress | SSP0015_ShipmentPSICommentsPopup.cs:68 | if (!(char.IsDigit(e.KeyChar) \|\| e.KeyChar == Convert.ToChar(Keys.Back))) | UI_PROP | e.Handled | true | 속성 Handled 설정 |  |  |  |

## SSP0015_ShipmentPSICommentsPopup.txtChange_Qty_TextChanged

진입점: this.txtChange_Qty.TextChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6ad3e7d3 | this.txtChange_Qty.TextChanged | SSP0015_ShipmentPSICommentsPopup.cs:147 |  | CALL_EXT | txtChange_Qty.Text.Replace(",", "").ToCharArray | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-494b259a | this.txtChange_Qty.TextChanged | SSP0015_ShipmentPSICommentsPopup.cs:155 | foreach (char aChar in entereddata.AsEnumerable()) ▸ else of (intLengthCnt == 0 && aChar == '-') | CALL_EXT | Char.IsDigit | (aChar) | ⚠ 의미 확인 필요 |  |  |  |
| AC-fbd1cd49 | this.txtChange_Qty.TextChanged | SSP0015_ShipmentPSICommentsPopup.cs:163 | foreach (char aChar in entereddata.AsEnumerable()) ▸ else of (intLengthCnt == 0 && aChar == '-') ▸ else of (Char.IsDigit(aChar)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00050", new object[] { actualdata }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6f84fac9 | this.txtChange_Qty.TextChanged | SSP0015_ShipmentPSICommentsPopup.cs:164 | foreach (char aChar in entereddata.AsEnumerable()) ▸ else of (intLengthCnt == 0 && aChar == '-') ▸ else of (Char.IsDigit(aChar)) | VALUE_SET | txtChange_Qty.Text | strDivision + string.Format("{0:#,##0}", Convert.ToInt64(actualdata.Substring(0, actualdat… | 컨트롤 값 설정 |  |  |  |
| AC-8774dca7 | this.txtChange_Qty.TextChanged | SSP0015_ShipmentPSICommentsPopup.cs:164 | foreach (char aChar in entereddata.AsEnumerable()) ▸ else of (intLengthCnt == 0 && aChar == '-') ▸ else of (Char.IsDigit(aChar)) | CALL_EXT | Convert.ToInt64 | (actualdata.Substring(0, actualdata.Length)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-40cfa67c | this.txtChange_Qty.TextChanged | SSP0015_ShipmentPSICommentsPopup.cs:165 | foreach (char aChar in entereddata.AsEnumerable()) ▸ else of (intLengthCnt == 0 && aChar == '-') ▸ else of (Char.IsDigit(aChar)) | UI_PROP | txtChange_Qty.SelectionStart | txtChange_Qty.TextLength | 속성 SelectionStart 설정 |  |  |  |
| AC-7123f8d9 | this.txtChange_Qty.TextChanged | SSP0015_ShipmentPSICommentsPopup.cs:166 | foreach (char aChar in entereddata.AsEnumerable()) ▸ else of (intLengthCnt == 0 && aChar == '-') ▸ else of (Char.IsDigit(aChar)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-597c3e03 | this.txtChange_Qty.TextChanged | SSP0015_ShipmentPSICommentsPopup.cs:172 | if (actualdata != "") | VALUE_SET | txtChange_Qty.Text | strDivision + string.Format("{0:#,##0}", Convert.ToInt64(actualdata)) | 컨트롤 값 설정 |  |  |  |
| AC-7e4dc01a | this.txtChange_Qty.TextChanged | SSP0015_ShipmentPSICommentsPopup.cs:172 | if (actualdata != "") | CALL_EXT | Convert.ToInt64 | (actualdata) | ⚠ 의미 확인 필요 |  |  |  |
| AC-0662f19b | this.txtChange_Qty.TextChanged | SSP0015_ShipmentPSICommentsPopup.cs:173 | if (actualdata != "") | UI_PROP | txtChange_Qty.SelectionStart | txtChange_Qty.TextLength | 속성 SelectionStart 설정 |  |  |  |

## SSP0015_ShipmentPSICommentsPopup.txtCurrent_Qty_TextChanged

진입점: this.txtCurrent_Qty.TextChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-648caf52 | this.txtCurrent_Qty.TextChanged | SSP0015_ShipmentPSICommentsPopup.cs:109 | if (txtCurrent_Qty.Text != "") ▸ if (Int64.TryParse(strTmpText, out intRusult)) | VALUE_SET | txtCurrent_Qty.Text | string.Format("{0:#,##0}", Convert.ToInt64(strTmpText)) | 컨트롤 값 설정 |  |  |  |
| AC-0c242046 | this.txtCurrent_Qty.TextChanged | SSP0015_ShipmentPSICommentsPopup.cs:109 | if (txtCurrent_Qty.Text != "") ▸ if (Int64.TryParse(strTmpText, out intRusult)) | CALL_EXT | Convert.ToInt64 | (strTmpText) | ⚠ 의미 확인 필요 |  |  |  |

## SSP0015_ShipmentPSICommentsPopup.txtGap_Qty_TextChanged

진입점: this.txtGap_Qty.TextChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-617e2458 | this.txtGap_Qty.TextChanged | SSP0015_ShipmentPSICommentsPopup.cs:123 | if (txtGap_Qty.Text != "") ▸ if (Int64.TryParse(strTmpText, out intRusult)) | VALUE_SET | txtGap_Qty.Text | string.Format("{0:#,##0}", Convert.ToInt64(strTmpText)) | 컨트롤 값 설정 |  |  |  |
| AC-16658c62 | this.txtGap_Qty.TextChanged | SSP0015_ShipmentPSICommentsPopup.cs:123 | if (txtGap_Qty.Text != "") ▸ if (Int64.TryParse(strTmpText, out intRusult)) | CALL_EXT | Convert.ToInt64 | (strTmpText) | ⚠ 의미 확인 필요 |  |  |  |

## SSP0015_ShipmentPSICommentsPopup.txtProd_Qty_TextChanged

진입점: this.txtProd_Qty.TextChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f9f90d46 | this.txtProd_Qty.TextChanged | SSP0015_ShipmentPSICommentsPopup.cs:96 | if (txtProd_Qty.Text != "") ▸ if (Int64.TryParse(strTmpText, out intRusult)) | VALUE_SET | txtProd_Qty.Text | string.Format("{0:#,##0}", Convert.ToInt64(strTmpText)) | 컨트롤 값 설정 |  |  |  |
| AC-986f00b3 | this.txtProd_Qty.TextChanged | SSP0015_ShipmentPSICommentsPopup.cs:96 | if (txtProd_Qty.Text != "") ▸ if (Int64.TryParse(strTmpText, out intRusult)) | CALL_EXT | Convert.ToInt64 | (strTmpText) | ⚠ 의미 확인 필요 |  |  |  |

## SSP0015_ShipmentPSICommentsPopup.txtWHin_Qty_TextChanged

진입점: this.txtWHin_Qty.TextChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d9d83926 | this.txtWHin_Qty.TextChanged | SSP0015_ShipmentPSICommentsPopup.cs:83 | if (txtWHin_Qty.Text != "") ▸ if (Int64.TryParse(strTmpText, out intRusult)) | VALUE_SET | txtWHin_Qty.Text | string.Format("{0:#,##0}", Convert.ToInt64(strTmpText)) | 컨트롤 값 설정 |  |  |  |
| AC-87a3024e | this.txtWHin_Qty.TextChanged | SSP0015_ShipmentPSICommentsPopup.cs:83 | if (txtWHin_Qty.Text != "") ▸ if (Int64.TryParse(strTmpText, out intRusult)) | CALL_EXT | Convert.ToInt64 | (strTmpText) | ⚠ 의미 확인 필요 |  |  |  |

## SSP0015_ShipmentPSICommentsPopup.Validation_Check

진입점: this.btnButtonList.UsrButtonList_Click_Detected [if (buttonItem.UserType == ButtonListType.Save) ▸ try] / SaveButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f0c4f608 | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0015_ShipmentPSICommentsPopup.cs:412 | if (strChangeQty == strCurrenQty) ▸ if (rtxComments.Text.Trim() == Comments.Trim()) | MESSAGE | MessageHelper.GMessageBox | ("MSG00017", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-7127230c | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0015_ShipmentPSICommentsPopup.cs:413 | if (strChangeQty == strCurrenQty) ▸ if (rtxComments.Text.Trim() == Comments.Trim()) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-d96cf500 | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SSP0015_ShipmentPSICommentsPopup.cs:417 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

